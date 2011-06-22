//+------------------------------------------------------------------+
//|                                                          eLT.mq4 |
//|                                                 ver 1.0.9.0612.02|
//|                                         программирование artamir |
//|                                                artamir@yandex.ru |
//+------------------------------------------------------------------+

/*///===================================================================
	Багфиксы :
		3,4,5,
		[6] 	- ошибка создания ини файла ордеров.
		[7] 	- ошибка компиляции библиотеки libELT.mq4
		[9] 	- Добавление добавочного стопового ордера.
		[12,13] - ошибка выставления добавочных ордеров.
		[14] 	- добавлена настройка SO_TP_on_first 
				- Исправлен расчет таргета, тп и сл для сеток порядка >= 2
				- Исправлено libELT: isMarketLevel
				- startCheckOrders разбита на две части
				- Добавлен признак "@ip1" для добавочных ордеров.
			-----
				- Добавлена библиотека libCO_closeByProfit
		[28]	- Исправлен баг с удалением отложенников, выставленных вручную, при МН = 0.
		[32]	- Добавлена библиотека libAutoOpen (libAO)
				- Добавлена библиотека libCWT (canWeTrade)
		[33]	- Изменения по этому багфиксу.	  
/*///=================================================================== 
#property copyright "copyright (c) 2008-2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org, mailto: artamir@yandex.ru"

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      инициализация констант
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Константы:
       OP_SLTP = применяется как флаг операций вычисления сл и тп для ордеров         
       OP_SORD = применяется как флаг операций открытия позиции
/*///-------------------------------------------------------------------

#define		CHK_SMBMN			500
#define		CHK_SMB				700
#define		CHK_MN				600
#define		CHK_TYMORE			400
#define		CHK_TYLESS			300
#define		CHK_TYEQ			200

#define		EXP_NAME			"eLT_10"

#define  TL_COUNT		1	// TL - Twise lot
#define  TL_VOL			2	// TL - Twise lot

//===================
// Настройки массива уровней

#define		a_dINI				-1.00	// значение инициализации массива (доубл) 

// размерность
#define		aL_MAXL				30			// 1-е измерение
#define		aL_MAXTY			10			// 2-е измерение 
#define		aL_AllTypes			21			// 2-е измерение 
#define		aL_MAXSET			11			// 3-е измерение

//===================
// Типы добавочных ордеров
#define		OP_ADD_BUYLIMIT		6			// добавочный байлимит
#define		OP_ADD_SELLLIMIT	7			// добавочный селллимит
#define		OP_ADD_BUYSTOP		8			// добавочный байстоп
#define		OP_ADD_SELLSTOP		9			// добавочный селлстоп

#define		OP_LIMLEVEL			20			// определение для типа, который будет описывать лимитную сетку

#define		idx_price	    0
#define		idx_vol     	1
#define		idx_tp_pip     	2
#define		idx_sl_pip      3
#define     idx_ParentType  4
#define		idx_isMarket    5
#define		idx_send        6
#define		idx_volMarket   7
#define		idx_volPending  8
#define		idx_gridLevel	9
#define		idx_ticket		10



//======================================================================

//---- input parameters
extern			double		TWISE_LOTS			=     20	;	// деление ордеров при достижении расчетного значения объема => заданного значения
extern			int			MN					=     0		;	// магик с которым будет работать советник. чужие магики обрабатываться не будут 
//{--- MAIN GRID PROP
extern string MGP	= "===== MAIN GRID PROP >>>>>>>>>>>>>>>";
extern			int       mgp_Target        =     25		;	//Фиксированное значение таргета (отменяется использованием useAVG_H1 или useAVG_D)
extern			int       mgp_TargetPlus    =      0		;	//увеличение таргета в зависимости от уровня на mgp_TargetPlus пунктов

extern			int       mgp_TP_on_first   =     25			;	//кол. пунктов для выставления тп на родительский ордер, когда нет сработавших дочерних ордеров
extern			int       mgp_TP            =     50			;	//кол. пунктов для выставления тп на сработавшие ордера сетки. расчет от последнего сработавшего ордера
extern			int       mgp_TPPlus        =      0			;	//увеличение тп от уровня на заданное количество пунктов.

int       mgp_SL_on_first   =      0;    // стоплосс на первый ордер (в общем пока уберу за ненадобностью) 
extern			bool	mgp_needSLToAll   =  false				;	// выставлять сл на всю сетку от последнего ордера или отдельно на каждый ордер
extern			int			mgp_SL				=		0		;	// зависит от <mgp_needSLToAll> размерность: пункты
extern			int			mgp_SLPlus			=		0		;	// Увеличение сл в зависимости от уровня текущей сетки

extern         bool      mgp_useLimOrders  =   true			;	// разрешает советнику использовать лимитную сетку
extern         int          mgp_LimLevels  =      5			;	// количество уровней лимитной сетки, включая родительский ордер

extern         double    mgp_plusVol       =    0.0			;	// увеличение объема след. уровня на величину <mgp_plusVol> (+)
extern         double    mgp_multiplyVol   =      2			;	// увеличение объема след. уровня в <mgp_multiplyVol> раз   (*)
//}

//{--- Adding lim. order
extern string ADD_LIMDESC  = "=========== Adding lim. order as parent";
extern         bool       add_useAddLimit          =	false		;	// разрешает советнику выставлять добавочный лимитный ордер как родительский
extern         int        	add_LimitLevel              =	3		;	// уровень сетки, от которого будет произведен расчет цены добавочного ордера
extern         int        	add_Limit_Pip               =	15		;	// сколько пунктов от уровня будет выставлен добавочный ордер
extern         bool       	add_Limit_useLevelVol    =	true		;	// разрешает советнику использовать настройку <add_Limit_multiplyVol> иначе будет использоваться <add_Limit_fixVol>  
extern         double     		add_Limit_multiplyVol       =	1	;	// коэф. умножения объема уровня <add_LimitLevel> основной сетки лимитных ордеров
extern         double     		add_Limit_fixVol            = 0.1	;	// фиксированный объем добавочного ордера
																		// Соглашение: сетка для добавочного ордера расчитывается из настроек <mgp_> 
//}

//{--- Adding stop order
extern string ADD_STOPDESC  = "=========== Adding stop order as parent";
extern         bool       add_useAddStop          =	false		;	// разрешает советнику выставлять добавочный стоповый ордер как родительский
extern         int        	add_StopLevel              =	3		;	// уровень сетки, от которого будет произведен расчет цены добавочного ордера. Родительский ордер находится на 1-м уровне 
extern         int        	add_Stop_Pip               =	15		;	// сколько пунктов от уровня будет выставлен добавочный ордер
extern         bool       	add_Stop_useLevelVol    =	true		;	// разрешает советнику использовать настройку <add_Stop_multiplyVol> иначе будет использоваться <add_Stop_fixVol>  
extern         double     		add_Stop_multiplyVol       =	1	;	// коэф. умножения объема уровня <add_StopLevel> основной сетки лимитных ордеров
extern         double     		add_Stop_fixVol            = 0.1	;	// фиксированный объем добавочного ордера
	// Соглашение: сетка для добавочного ордера расчитывается из настроек <mgp_> 								
//}	

//{--- auto lot																		
extern   string AL_DESC = "=========== AUTO_LOT SETUP ==========";
extern			double	al_LOT_fix           =    0.1				;	// фиксированный стартовый лот
extern			bool	al_needAutoLots      =  false				;	// разрешает авторасчет объема родительского ордера
                     bool    al_useMarginMethod      = true			;	// разрешает использовать метод залога
extern               double  al_DepositPercent       =    1			;	// процент от депозита для расчета методом залога                     
extern string MGP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";
//}

//{--- Стоповые ордера
extern string SOP       = "===== STOP ORDERS PROP >>>>>>>>>>>>>>>";
extern         bool     SO_useStopLevels		=    false			;	// разрешает советнику использовать выставление стоповых ордеров
extern         int             SO_Levels				=  -1		;	// -1 - количество уровней совпадает с уровнями лимитных ордеров, либо задает количетво стоповых уровней

extern         int             SO_StartLevel			=   2		;	// уровень, с которого выставляются стоповые ордера для данного родителя. Родительский ордер имеет индекс 1
																		// т.е. в данном случае стоповые ордера будут выставляться с уровня первого лимитного ордера
extern         bool            SO_useLimLevelVol		=	true	;	// разрешает использовать объем текущего уровня лимитной сетки для расчета объема стопового ордера
																		// иначе для расчета объема используется объем родительского ордера.
extern         double          SO_LimLevelVol_Divide	=	-1		;	// деление объема лим. ордера для вычисления объема стоп. до уровня LevelVolParent
																		// -1 выставляется объемом родительского      
extern         int             SO_EndLevel				=   3		;	// Настройки <SO_useLimLevelVol> и <SO_LimLevelVol_Divide> будут использоваться до этого уровня включительно

extern         int             SO_ContinueLevel			=   5		;	// Включая этот уровень и до SO_Levels будут продолжать выставляться стоповые ордера.
extern         double          SO_ContLevelVol_Divide	=	1		;	// Для расчета используется расчетное значение объема лим. ордера текущего уровня.

extern    string  SOTGP = "=========== SO_TARGET, SO_TP, SO_SL =="	;
extern         bool     SO_useKoefProp			=  true				;	// разрешает советнику использовать настройки таргета, тп и сл для стоповых ордеров в качестве коэф. умножения 
																		// применительно к настройкам сетки-родителя.
extern         double        SO_Target					=   1.5		;	// в зависимости от <SO_useKoefProp> будет принимать значение <таргета пред. сетки> * SO_Target, либо фикс. 
																		// значение в пунктах, приведенное к целому числу, для любой дочерней сетки.
extern         double        SO_TP						=   1.5		;	// описание аналогично пред. настройке
extern         double        SO_TP_on_first				=   1.5		;	// описание аналогично пред. настройке (расчитывается как гридЛевел-1)
extern         double        SO_SL						=   1.5		;	// описание аналогично пред. настройке
extern string SOP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"	;	
//}

//--------------------------------------
// открытие первого ордера (для тестера)
extern string    ex_OPEN_FIRST_ORDER      = "--- открытие первого ордера для тестера ---";
extern bool         openFirstOrder           = false;
extern int          FirstOrderDiapazonPip    = 75;  // диапазон, в котором выставляются первые 
                                                    // ордера (стоповые)
                                                    // если = 0, то рыночные по тек. цене
extern int          FirstOrderExp            = 15;  // время жизни отложенного ордера в мин.                                               
extern string    ex_END_OPEN_FIRST_ORDER  = "==================================================="; 
/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      глобальные переменные
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
/*///-------------------------------------------------------------------
bool	isDone				= true	;	// определяет флаг окончания функции start()
int		SPREAD				= 0		;	// Спред валютной пары, на которой запущен советник
string	INIFile_ord			= ""	;	// ини файл ордеров
string	INIFile_name		= ""	;	// основное название файла
string	INIFile_folder		= ""	;	// путь расположения файлов советника
string  file_ord			= ""    ;   // дублирует INIFile_ord
string	INIFile_grd			= ""	;	// ини файл объемов уровней сетки
//======================================================================

/*///==============================================================
      Версия: 2011.03.24
      ------------------
      Описание:
         Инициализация и проверка версии библиотеки функций помощи
         <libHelpFunc> 
/*///--------------------------------------------------------------
#include <libCWT.mqh>
#include <libCloseOrders.mqh>
#include <libHelpFunc.mqh>
#include <libOrdersFunc.mqh>
#include <libINIFileFunc.mqh>
#include <libeLT.mqh>
#include <libAutoOpen.mqh>
//-------
int initLibs(){
/*
   //--- libHelpFunc
   if(StringFind(libHelp_Ver(),"v1.0") == -1){
      logIni(StringConcatenate("last release - ", "v1.0"),
             StringConcatenate("initLibs: libHelpFunc ",libHelp_Ver()));
   }
   
   //--- libOrdersFunc
   if(StringFind(libOrders_Ver(),"v1.0") == -1){
      logIni(StringConcatenate("last release - ", "v1.0"),
             StringConcatenate("initLibs: libOrdersFunc ",libOrders_Ver()));
   }
   
   libOrders_setFile_ord( INIFile_ord);
   
   //--- libeLT
   if(StringFind(libeLT_Ver(),"v1.0") == -1){
      logIni(StringConcatenate("last release - ", "v1.0"),
             StringConcatenate("initLibs: libOrdersFunc ",libOrders_Ver()));
   }
   
   libOrders_setFile_ord( INIFile_ord);
   
   //--- libINIFileFunc
   if(StringFind(libINIFile_Ver(),"v1.0") == -1){
       logIni(StringConcatenate("last release - ", "v1.0"),
              StringConcatenate("initLibs: libOrdersFunc ",libINIFile_Ver()));
   }
   //--
   */
}   
//=================================================================


/*///==============================================================
      Версия: 2011.03.24
      ------------------
      Описание:
         Вывод отформатированного сообщения об ошибке в окно
         сообщений
      ------------------
      Переменные:
            на входе:
               str_err = строка с текстом сообщения
               fn      = имя модуля, вызвавшего ошибку
            ------------
            на выходе:
               нет       
/*///--------------------------------------------------------------
string logIni(string str_err, string fn=""){
   Print("===============================");
   Print("INI ERROR: ",str_err);
   Print("INI ERROR: in func - ",fn);
   Print("===============================");
}
//==============================================================



/*///===================================================================
   Версия: 2011.04.22
   ---------------------
   Описание:
      Возвращает текущее значение тп в зависимости 
      от настроек советника и текущего гридЛевела
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
		grid_level	-	уровень вложенности сетки
		level		-	уровень сетки

/*///-------------------------------------------------------------------
int getTP(int grid_level, int level){

   // проверка на 1-й гридЛевел
		if(grid_level <= 1 && level == 0){
			return(mgp_TP_on_first);
		}else{
			if(grid_level <= 1 && level > 0){
				return(mgp_TP + (mgp_TPPlus * (level-1)));
			}
		}
   //<<<<<<<
   // гридЛевел > 1
      if(grid_level >= 2){
         //значит у нас сработал стоповый ордер
         //Алгоритм: 
            // проверим тп для стоповых будет фикс или коэф
            // для коэф: тп лим. сетки * гридЛевел
            //    чтоб получить тп как для родительской сетки, нужно все коэф = 1;
            // для фикса: возвращаем заданное в настройках значение
            //---
            if(SO_useKoefProp){
				if(level == 0){
					return(mgp_TP_on_first * MathPow(SO_TP_on_first, (grid_level-2)));
				}else{
					return((mgp_TP + (mgp_TPPlus * (level-1))) * MathPow(SO_TP, (grid_level-1)));
				}	
            }else{
               return(SO_TP);
            }      
      }
   //<<<<<<<
   
}
//======================================================================

/*///===================================================================
   Версия: 2011.04.22
   ---------------------
   Описание:
      Возвращает текущее значение sl в зависимости 
      от настроек советника и текущего гридЛевела
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
		grid_level	-	порядок сетки

/*///-------------------------------------------------------------------
int getSL(int grid_level, int level){

   // проверка на 1-й гридЛевел
		if(grid_level <= 1 && level == 0){
			return(mgp_SL);
		}else{
			if(grid_level <= 1 && level > 0){
				return(mgp_SL + (mgp_SLPlus * (level-1)));
			}
		}
   //<<<<<<<
   // гридЛевел > 1
      if(grid_level >= 2){
         //значит у нас сработал стоповый ордер
         //Алгоритм: 
            // проверим тп для стоповых будет фикс или коэф
            // для коэф: тп лим. сетки * гридЛевел
            //    чтоб получить тп как для родительской сетки, нужно все коэф = 1;
            // для фикса: возвращаем заданное в настройках значение
            //---
            if(SO_useKoefProp){
				if(level == 0){
					return(mgp_SL * MathPow(SO_SL, (grid_level-1)));
				}else{
					return((mgp_SL + (mgp_SLPlus * (level-1))) * MathPow(SO_SL, (grid_level-1)));
				}	
            }else{
               return(SO_SL);
            }      
      }
   //<<<<<<<
   
}
//======================================================================

/*///===================================================================
   Версия: 2011.04.22
   ---------------------
   Описание:
      Возвращает текущее значение таргета в зависимости 
      от настроек советника и текущего гридЛевела
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
		grid_level - порядок сетки
		level - уровень сетки
/*///-------------------------------------------------------------------
int getTarget(int grid_level, int level){
	
	int trg = mgp_Target * level + (mgp_TargetPlus*level-1);
	
   // проверка на 1-й гридЛевел
      if(grid_level <= 1){
         return(trg);
      }
   //<<<<<<<
   // гридЛевел > 1
      if(grid_level >= 2){
		//значит у нас сработал стоповый ордер
		//Алгоритм: 
			// проверим таргет для стоповых будет фикс или коэф
			// для коэф: таргет лим. сетки * коэф. в степени(гридЛевел-1)
			//    чтоб получить таргеты как для родительской сетки, нужно все коэф = 1;
			// для фикса: возвращаем заданное в настройках значение
			//---
			if(SO_useKoefProp){
				return(trg * MathPow(SO_Target, (grid_level-1)));
			}else{
				return(SO_Target*(level));
			}      
      }
   //<<<<<<<
}
//======================================================================

/*///===================================================================
   Версия: 2011.03.31
   ---------------------
   Описание:
      возвращает максимальный рыночный уровень сетки      
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      arr = aLevels

/*///-------------------------------------------------------------------
int getMaxMarketLevel(double& arr[][][]){
   double res = 0;
		for(int idx_L = 0; idx_L < ArrayRange(arr, 0); idx_L++){
			for(int idx_oty = 0; idx_oty <= 5; idx_oty++){ // цикл по лимитным и стоповым ордерам
				if(arr[idx_L][idx_oty][idx_isMarket] == 1)
					res = MathMax(res , idx_L);	
			}
		}
   return(res);    
}
//======================================================================

/*///===================================================================
	Версия: 2011.04.08
	---------------------
	Описание:
		Возвращает цену максимального уровня лимитной сетки.
	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		arr[][][] - массив уровней
/*///-------------------------------------------------------------------
double getMaxLimitLevelPrice(double& arr[][][], int parent_ticket = -1){
	double res = -1;
	//{-----
		return(NormalizeDouble(arr[mgp_LimLevels-1][OP_LIMLEVEL][idx_price], Digits));
	//}-----
	return(res);
}
//======================================================================


/*///===================================================================
   Версия: 2011.03.29
   ---------------------
   Описание:
      возвращает объем для текущего уровня лимитной сетки      
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      нет

/*///-------------------------------------------------------------------
double calcLimitVol(double parent_vol, int level){
   double vol = 0;
      vol = (parent_vol + mgp_plusVol*level) * MathPow(mgp_multiplyVol,level);
   return(calcVolNormalize(vol,	1));    
}
//======================================================================

/*///===================================================================
	Версия: 2011.03.31
	---------------------
	Описание:
		возвращает нормализованный объем для  
	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		нет
/*///-------------------------------------------------------------------
double calcVolNormalize(double vol, double divide){
	double res = 0;
	double minLot = MarketInfo(Symbol(),	MODE_MINLOT);
	//{--- расчет объема
		res = vol / divide;
		res = MathMax(NormalizeLot(res,	false, ""), NormalizeLot(minLot,	false,	""));
	//}
	return(res);
}
//======================================================================

/*///===================================================================
	Версия: 2011.04.03
	---------------------
	Описание:
		Заполняет массив ордеров тек. уровня   
	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		arr - массив ордеров уровня
		level - уровень
		wt -  тип, которым выставлялся ордер
/*///-------------------------------------------------------------------
int fillLevelOrders(int& arr[], int parent_ticket, int level, int wt){
	int res = 0;
	int dim = 0;
	//---
		int t = OrdersTotal();
		for(int i = t; i >= 0; i--){
			//==================
				if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))	continue;
				//---
				int ot = OrderTicket();
				int oty = OrderType();
				int om = OrderMagicNumber();
				//---
				if(!checkOrderByTicket(ot, CHK_MN, Symbol(), MN, -1)) continue; // проверим, чтоб ордер был рыночным
				//---
				int olevel = getOrderLevel(ot);
				if(olevel != level) continue;
				//---
				int owt = getWasType(ot);
				if(owt != wt) continue;
				//---
				int opt = getParentByTicket(ot);
				if(opt != parent_ticket) continue;
			//==================
			dim++;
			ArrayResize(arr, dim);
			arr[dim-1] = ot;
		}
	//---
	res = dim;
	return(res);
}
//======================================================================

/*///===================================================================
	Версия:	20110609_09

	Изменения:
	---------------
		2011.06.09 - [+] Массив родительских ордеров, чтоб передать его дальше.
/*///===================================================================

void startCheckOrders(){
//	Print("========================");
//	Print("startCheckOrders    ");
	double aParentOrders[1];
	ArrayInitialize(aParentOrders,-1);
	int dim = 0;
	
	int t = OrdersTotal();
	for(int tekOrder = 0; tekOrder <= OrdersTotal(); tekOrder++){ // собираем массив aLevels[][][]
		if(!OrderSelect(tekOrder, SELECT_BY_POS, MODE_TRADES)) continue;	
			//---
		int    parent_ticket	=	OrderTicket();
		int    parent_type		=	OrderType();
		double parent_opr		=	OrderOpenPrice();
		string parent_comm		=	OrderComment();
		double parent_vol		=	OrderLots();
		int    parent_grid		=	getGrid(parent_ticket); 
			//---
		if(!checkOrderByTicket(parent_ticket, CHK_TYLESS, Symbol(), MN, 1)) continue; // проверим, чтоб ордер был рыночным)
		
			
			Print("   parent_ticket = ", parent_ticket);
			
			//---
		if(!isParentOrder(parent_ticket, MN, Symbol())) {
			// если это рыночный ордер, то проверим, живой ли родитель.
			// если родителя нет, то в истории ищем родителя и 
			// перенастраиваем родительские переменные
			// согласно историческому ордеру.
				
			if(!isParentLive(parent_ticket) && parent_type <= 1){
				//---
				parent_ticket = getParentInHistory(parent_ticket);
				//---
				OrderSelect(parent_ticket, SELECT_BY_TICKET);
					parent_type   = OrderType();
					parent_opr    = OrderOpenPrice();
					parent_comm   = OrderComment();
					parent_vol    = OrderLots();
					parent_grid   = getGrid(parent_ticket); 
					//------   
					if(parent_grid <= 1) parent_grid = 1;
					//---
					dim++;
					ArrayResize(aParentOrders,dim);
					aParentOrders[dim-1] = parent_ticket;
					//checkParentOrder(parent_ticket);
			}else{
				continue;      
			}
		}else{
			dim++;
			ArrayResize(aParentOrders,dim);
			aParentOrders[dim-1] = parent_ticket;
			
//			Print("      isParent ticket = ", parent_ticket);
//			Print("      dim = ", dim);
			//checkParentOrder(parent_ticket);
			//---
			if(!isParentLive(parent_ticket)){
					//---
					parent_ticket = getParentInHistory(parent_ticket);
					//checkParentOrder(parent_ticket);
					dim++;
					ArrayResize(aParentOrders,dim);
					aParentOrders[dim-1] = parent_ticket;
			}		
		}
	}
//	Print("========================");
	if(dim > 0)
		checkParentOrder(aParentOrders);
	else 
		return(0);
}

/*///===================================================================
   Версия: 2011.06.09
   ---------------------
   Описание:
      основная процедура советника
   ---------------------   
   Алгоритм:
      1. Проверяем каждый ордер на соответствие родительскому
         1.1 - комментарий = "" или "@ip1"
         1.2 - в ини файле у этого ордера признак родительского
         
      2. Для каждого родительского пересоздаем массив уровней
      3. Для каждого уровня проверяем дочерние ордера, 
         3.1 определяем последний сработавший уровень сетки
         
      4. Проверяем ТП и СЛ для каждого ордера сетки
      
      5. Проводим удаление отложенных ордеров, если нет ни одного
         сработавшего ордера сетки.         
   ---------------------
   Описание массивов:
      т.к. мы определили родительский ордер, то можем собрать 
      массив уровней для этого ордера.
      double aLevels[номер уровня][тип ордера][idx_price     ] = цена уровня.                  //расчет цены уровня расчитывается для лимитной сетки и зависит от уровня в иерархии сеток
             aLevels[номер уровня][тип ордера][idx_vol       ] = объем уровня.                 //для каждого типа ордера объем расчитывается отдельно согласно настройкам
             aLevels[номер уровня][тип ордера][idx_tp_pip    ] = тейкпрофит в пунктах.         //для каждого типа ордера отдельный
             aLevels[номер уровня][тип ордера][idx_sl_pip    ] = стоплосс в пунктах.           //
             aLevels[номер уровня][тип ордера][idx_isMarket  ] = 1,0 - есть/нет рыночный ордер
             aLevels[номер уровня][тип ордера][idx_ParentType] = Тип родительского ордера      //бай или селл            
                  для определения последнего сработавшего уровня будем использовать 
                  уровень с максимальным индексом
                  у которого есть хоть один рыночный ордер.                                                                   
   ---------------------
   Изменения:
		2011.04.08 - [+] Начал расчеты сл для ордеров уровней.
		2011.06.08 - [+] Цикл по всем найденым родителям на тек. момент
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      нет

/*///-------------------------------------------------------------------
void checkParentOrder(double& aParentOrders[]){//int tekOrder){

	int dim = ArraySize(aParentOrders);
	for(int idx_PO = 0; idx_PO < dim; idx_PO++){
		
		int tekOrder = aParentOrders[idx_PO];
		
//		Print("==========================");
//		Print("idx_PO = ",idx_PO);
//		Print("tekOrder = ", tekOrder);
//		Print("==========================");
		
		double aLevels[][aL_AllTypes][aL_MAXSET]; // 1-е измерение оставили пустым для ресайза

			//=================
				if(!OrderSelect(tekOrder, SELECT_BY_TICKET)) continue;
				//----
				int    thisOrderTicket	=	OrderTicket(); 
				int    parent_ticket	=	OrderTicket();
				int    parent_type		=	OrderType();
				double parent_opr		=	OrderOpenPrice();
				string parent_comm		=	OrderComment();
				double parent_vol		=	OrderLots();

				int    parent_grid		=	getGrid(parent_ticket); 
				//------   
				if(parent_grid <= 1) parent_grid = 1;
				//------
					
				
			//=================
			// значит наш ордер родитель

			//============================================
			// Обрабатываем родительский ордер
			//--------------------------------------------
			/* 	1. Определим максимальное количество уровней сетки
					1.1 Максимальным уровнем будет считаться количество
						уровней лимитных ордеров, если не используются 
						стоповые ордера. Либо максимальное значение
						между количеством лимитных и стоповых уровней 

					1.2 Ресайзим первое измерение под количество уровней    
					1.3 Инициализируем массив значением (-10000.00). //вряд ли будет исользовано значение -10000 для расчетов 

				2. Начинаем расчет и заполнение массива.   
					2.1 Заполняем 0 уровень значениями родительского ордера
					2.2 В цикле с 1 по maxLevels определяем:
						2.21 цену уровня относительно лимитной сетки
						2.22 в цикле с 2 по 10
						2.23 проверяем по настройкам, для данного типа ордера нужные настройки 
						2.24 определяем, есть ли рыночные ордера для текущего родителя
						2.25 для каждого уровня заполняем массив, содержащий данные для записи 
							 в файл ордеров.
				*/      
			//--------------------------------------------

			int maxaLevels = mgp_LimLevels;// максимальное количество уровней сетки
			//----
			if(SO_useStopLevels){
				if(SO_Levels != -1) maxaLevels = MathMax(maxaLevels,SO_Levels);
			}
			//----
			ArrayResize(aLevels, maxaLevels);
			ArrayInitialize(aLevels, a_dINI);
			//----
			// 2.1
				aLevels[0][0][idx_price       ]  = parent_opr;
				aLevels[0][0][idx_vol         ]  = parent_vol;
				aLevels[0][0][idx_isMarket    ]  = 1;
				aLevels[0][0][idx_ParentType  ]  = parent_type;
				aLevels[0][0][idx_ticket      ]  = parent_ticket;
				
				//Print("maxLevels = ",maxaLevels);

				for(int idx_L = 1; idx_L < maxaLevels; idx_L++){                     // цикл по уровням. Первый отложенный уровень = 1. 
					// цикл  по типам ордеров >>>>>>>
					for(int idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){              // цикл по типам ордеров на текущем уровне
						//2.23
						//{ обработка лимитных ордеров
							if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
								//---
								//{--- Проверим правильный тип лимитного ордера 
									if(parent_type == OP_BUY && idx_oty != OP_BUYLIMIT){
										aLevels[idx_L][idx_oty][idx_send] = a_dINI;
										continue;
									}
									//---
									if(parent_type == OP_SELL && idx_oty != OP_SELLLIMIT){
										aLevels[idx_L][idx_oty][idx_send] = a_dINI;
										continue;
									}
								//}<<<< правильный тип лимитного ордера	
							
								//{--- добавим объем в глоб. описание лим. сетки
								//    это описание доступно по адресу: aL[<нужный уровень>][OP_LIMLEVEL][<нужный параметр>]
									int target = getTarget(parent_grid, idx_L);
									
									
									aLevels[idx_L][OP_LIMLEVEL][idx_vol			]	= calcLimitVol( parent_vol, idx_L)              ;
									aLevels[idx_L][OP_LIMLEVEL][idx_price		]	= calcPrice(    parent_opr, parent_type, target);
									//-----
									aLevels[idx_L][OP_LIMLEVEL][idx_gridLevel	]	= parent_grid;
								//}	
								//---
								if(idx_L < mgp_LimLevels && mgp_useLimOrders){
									//---						      
									aLevels[idx_L][idx_oty][idx_price     	]	=	calcPrice(parent_opr,	parent_type,	target);
																					//-----					
									aLevels[idx_L][idx_oty][idx_vol       	]	=	calcLimitVol(	parent_vol,	idx_L);
																					//-----				
									aLevels[idx_L][idx_oty][idx_isMarket  	]	=	isMarketLevel(	parent_ticket,	idx_L,	MN, Symbol());
																					//------				
									aLevels[idx_L][idx_oty][idx_ParentType	]	=	parent_type;
									//---
									string sVolLevel = getLevelOpenedVol(	parent_ticket,	idx_L,	idx_oty,	MN, Symbol()); // возвращает результат в виде "@vm1.6@vp3.2" vm - объем рыночных, vp - отложенных
									//---
									aLevels[idx_L][idx_oty][idx_volMarket 	]	=	StrToDouble(	returnComment(sVolLevel	, "@vm_")	);
																					//------								
									aLevels[idx_L][idx_oty][idx_volPending	]	=	StrToDouble(	returnComment(sVolLevel	, "@vp_")	);
																					//------								
									//---
									// проверим выставленные объемы, если больше расчетного, то в топку
									double wasLots = StrToDouble(	returnComment(sVolLevel	, "@hl_"));
									
									if(wasLots >= aLevels[idx_L][idx_oty][idx_vol])
										aLevels[idx_L][idx_oty][idx_send]	=	-1.00;
									else	
										aLevels[idx_L][idx_oty][idx_send]	=	1.00;      
								}//if(idx_L < mgp_LimLevels && mgp_useLimOrders){   
							}//}<<<< обработка лимитных ордеров         
						
						//{ обработка стоповых ордеров
							if(idx_oty == OP_SELLSTOP || idx_oty == OP_BUYSTOP){
								//{ проверим правильный тип стопового ордера
									if(parent_type == OP_BUY && idx_oty != OP_SELLSTOP){
										aLevels[idx_L][idx_oty][idx_send] = -1.00;
										continue;
									}
								//---
									if(parent_type == OP_SELL && idx_oty != OP_BUYSTOP){
										aLevels[idx_L][idx_oty][idx_send] = -1.00;
										continue;
									}
								//}
							
								if(SO_useStopLevels){
									//{--- определяем общее количество уровней стоповой сетки
										int totalSOLevels = mgp_LimLevels; // это при -1. т.е. используем количество уровней лимитной сетки.
										// если > -1 - то используем указанное в настройках количество уровней
										if(SO_Levels > -1){
											totalSOLevels = SO_Levels;
										}
									//}---
								
									if(idx_L < totalSOLevels){
										//{--- определяем коэф. 1/-1 для спреда
											int oD	=	1; // для байстопа (цена лимитного ордера + спред)
											//---
											if(idx_oty == OP_SELLSTOP)	oD	=	-1;
										//}---
									
										if(idx_L >= SO_StartLevel-1 && idx_L <= SO_EndLevel-1){
											aLevels[idx_L][idx_oty][idx_send	]	=	1.00;
											aLevels[idx_L][idx_oty][idx_price	]	=	aLevels[idx_L][OP_LIMLEVEL][idx_price]
																					+ SPREAD*Point*oD;
											//{--- определяем объем стопового ордера
												double volToCalc = 0;
												//---
												if(SO_useLimLevelVol){
													volToCalc = aLevels[idx_L][OP_LIMLEVEL][idx_vol];
												}else{
													volToCalc = parent_vol;
												}
											//}
											aLevels[idx_L][idx_oty][idx_vol		]	= calcVolNormalize(	volToCalc,	
																									SO_LimLevelVol_Divide);
											sVolLevel	=	getLevelOpenedVol(parent_ticket, idx_L, idx_oty, MN, Symbol());
											//---
											aLevels[idx_L][idx_oty][idx_volMarket ] = StrToDouble(	returnComment(sVolLevel,"@vm_")	);
											aLevels[idx_L][idx_oty][idx_volPending] = StrToDouble(	returnComment(sVolLevel,"@vp_")	);
										
										}else{
											if(idx_L >= SO_ContinueLevel-1){
												aLevels[idx_L][idx_oty][idx_send	]	=	1.00;
												aLevels[idx_L][idx_oty][idx_price	]	=	aLevels[idx_L][OP_LIMLEVEL][idx_price]
																					+ SPREAD*Point*oD;
												//{--- определяем объем стопового ордера
													volToCalc = 0;
													//---
													volToCalc = aLevels[idx_L][OP_LIMLEVEL][idx_vol];
													
												//}
												aLevels[idx_L][idx_oty][idx_vol		]	= calcVolNormalize(	volToCalc,	
																									SO_ContLevelVol_Divide);
												sVolLevel	=	getLevelOpenedVol(parent_ticket, idx_L, idx_oty, MN, Symbol());
												//---
												aLevels[idx_L][idx_oty][idx_volMarket ] = StrToDouble(	returnComment(sVolLevel,"@vm_")	);
												aLevels[idx_L][idx_oty][idx_volPending] = StrToDouble(	returnComment(sVolLevel,"@vp_")	);
											}
										}
									}else{
										aLevels[idx_L][idx_oty][idx_send] = -1.00; // уровень больше чем разрешенный для стопордеров
									}
									//---
								}else{
									aLevels[idx_L][idx_oty][idx_send] = -1.00;		// не будем выставлять стопордера на этом уровне
								}
							}//}<<<< обработка стоповых ордеров
						
						//{ обработка добавочных лимитных ордеров
							if(idx_oty == OP_ADD_BUYLIMIT || idx_oty == OP_ADD_SELLLIMIT){
								if(add_useAddLimit){
									if(idx_L == add_LimitLevel-1){
										//{ проверим правильный тип добавочного ордера
											if(parent_type == OP_BUY && idx_oty != OP_ADD_BUYLIMIT){
												aLevels[idx_L][idx_oty][idx_send] = -1.00;
												continue;
											}
										//---
											if(parent_type == OP_SELL && idx_oty != OP_ADD_SELLLIMIT){
												aLevels[idx_L][idx_oty][idx_send] = -1.00;
												continue;
											}
										//}	
									
										//{--- определяем коэф. 1/-1 для спреда
											oD	=	1; // для селллимита (цена лимитного ордера + кол. пунктов)
											//---
											if(idx_oty == OP_ADD_BUYLIMIT)	oD	=	-1;
										//}---
									
										aLevels[idx_L][idx_oty][idx_send]	=	1.00;
										aLevels[idx_L][idx_oty][idx_price]	=	aLevels[idx_L][OP_LIMLEVEL][idx_price]	+
																				add_Limit_Pip*Point*oD;
																				//---
										//{--- определяем объем добавочного ордера
											volToCalc = 0;
											double add_mult = 1;
											//---
											if(add_Limit_useLevelVol){
												volToCalc	=	aLevels[idx_L][OP_LIMLEVEL][idx_vol];
												add_mult	=	add_Limit_multiplyVol;
											}else{
												volToCalc	=	add_Limit_fixVol;
												add_mult	=	1;
											}
										//}
									
										aLevels[idx_L][idx_oty][idx_vol]	=	calcVolNormalize(volToCalc, add_mult);
									
										sVolLevel	=	getLevelOpenedVol(parent_ticket, idx_L, idx_oty, MN, Symbol());
										//---
										aLevels[idx_L][idx_oty][idx_volMarket ] = StrToDouble(	returnComment(sVolLevel,"@vm_")	);
										aLevels[idx_L][idx_oty][idx_volPending] = StrToDouble(	returnComment(sVolLevel,"@vp_")	);
									}
								}
							}
						//}
						
						//{ обработка добавочных стоповых ордеров
							if(idx_oty == OP_ADD_BUYSTOP || idx_oty == OP_ADD_SELLSTOP){
								if(add_useAddStop){
									if(idx_L == add_StopLevel-1){
										//{ проверим правильный тип добавочного ордера
											if(parent_type == OP_BUY && idx_oty != OP_ADD_SELLSTOP){
												aLevels[idx_L][idx_oty][idx_send] = -1.00;
												continue;
											}
										//---
											if(parent_type == OP_SELL && idx_oty != OP_ADD_BUYSTOP){
												aLevels[idx_L][idx_oty][idx_send] = -1.00;
												continue;
											}
										//}	
									
										//{--- определяем коэф. 1/-1 для спреда
											oD	=	1; // для байстопа (цена лимитного ордера + кол. пунктов)
											//---
											if(idx_oty == OP_ADD_SELLSTOP)	oD	=	-1;
										//}---
									
										aLevels[idx_L][idx_oty][idx_send]	=	1.00;
										aLevels[idx_L][idx_oty][idx_price]	=	aLevels[idx_L][OP_LIMLEVEL][idx_price]	+
																				add_Stop_Pip*Point*oD;
																				//---
										//{--- определяем объем добавочного ордера
											volToCalc = 0;
											add_mult = 1;
											//---
											if(add_Stop_useLevelVol){
												volToCalc	=	aLevels[idx_L][OP_LIMLEVEL][idx_vol];
												add_mult	=	add_Stop_multiplyVol;
											}else{
												volToCalc	=	add_Stop_fixVol;
												add_mult	=	1;
											}
										//}
									
										aLevels[idx_L][idx_oty][idx_vol]	=	calcVolNormalize(volToCalc, add_mult);
									
										sVolLevel	=	getLevelOpenedVol(parent_ticket, idx_L, idx_oty, MN, Symbol());
										//---
										aLevels[idx_L][idx_oty][idx_volMarket ] = StrToDouble(	returnComment(sVolLevel,"@vm_")	);
										aLevels[idx_L][idx_oty][idx_volPending] = StrToDouble(	returnComment(sVolLevel,"@vp_")	);
									}
								}
							}
						//}
					
					}//<<<< цикл  по типам ордеров         
				}
			
		/*
		for(idx_L = 0; idx_L <= 3; idx_L++){
			for(idx_oty = 0; idx_oty < 10; idx_oty++){
				Print("aLevels[",idx_L,"][",idx_oty,"][idx_price]= ",aLevels[idx_L][idx_oty][idx_price]);
				Print("aLevels[",idx_L,"][",idx_oty,"][idx_vol]= ",aLevels[idx_L][idx_oty][idx_vol]);
				Print("aLevels[",idx_L,"][",idx_oty,"][idx_volMarket]= ",aLevels[idx_L][idx_oty][idx_volMarket]);
				Print("aLevels[",idx_L,"][",idx_oty,"][idx_volPending]= ",aLevels[idx_L][idx_oty][idx_volPending]);
				Print("aLevels[",idx_L,"][",idx_oty,"][idx_isMarket]= ",aLevels[idx_L][idx_oty][idx_isMarket]);
				Print("aLevels[",idx_L,"][",idx_oty,"][idx_ParentType]= ",aLevels[idx_L][idx_oty][idx_ParentType]);
				Print("aLevels[",idx_L,"][",idx_oty,"][idx_send]= ",aLevels[idx_L][idx_oty][idx_send]);
				Print("=============================================");
				Sleep(100);
			}
		}
		/***********************************************/
		/*///===================================================
			3. Проверим какой уровень максимальный сработавщий для данного родителя.
				3.1 в зависимости от макс. сработавшего уровня определяем тп сл для всех уровней  		
		/*///===================================================
		
		int maxMarketLevel = getMaxMarketLevel(aLevels); // уровни считаются с 0. 0 -родительский
		
		//Print("maxMarketLevel = ", maxMarketLevel);
		//{--- в цикле по уровням проверим тп и сл для ордеров сетки
			//	продумать алгоритм проверки на тп и сл.
			//	и возможно, одновременное выставление недостающих ордеров.
			// объемы рыночных и отложенных для данного уровня у нас уже есть.
			//	осталось доставить ордера до расчетного объема.
			int		grid_level	= NormalizeDouble(aLevels[idx_L][OP_LIMLEVEL][idx_gridLevel],0);
			double	maxMarketLevel_tp = 0;	
			
			//{--- 3.1a расчитаем максимальный уровень лимитной сетки.
				// расчет будем вести след. образом: 
				// определяем цену последнего лим. уровня
				// и в ф-цию расчета цены сл будем подставлять 
				// либо цену последнего лимитного уровня, либо цену 
				// тек уровня.
				double maxLimitLevelPrice = getMaxLimitLevelPrice(aLevels, "-1");
				
				//{--- 3.1a.1 определим цену и расстояние в пунктах от родителя до сл
					parent_opr = NormalizeDouble(aLevels[0][0][idx_price], Digits);
					
					double	sl_parent_price	= -1; // цена сл родителя
					int		sl_parent_pip	= -1; // расстояние от родителя до сл в пунктах
					
					//{--- 3.1a.1.1 расчитываем сл для родителя в зависимости от настроек.
						if(mgp_SL > 0){
							if(mgp_needSLToAll){
								sl_parent_price	=	calcSLPrice(maxLimitLevelPrice, parent_type, getSL(grid_level, 0));
								sl_parent_pip	=	MathAbs((parent_opr - sl_parent_price)/Point);
							}else{
								sl_parent_pip	= getSL(grid_level,0);
							}
						}else{
							sl_parent_price = -1;
							sl_parent_pip = -1;
						}
					//}
					
				//}
			//}
			
			//{3.1 --- расчитаем ТП для лимитной сетки, если maxMarketLevel > 1
				if(maxMarketLevel > 0){
					double	maxlevel_op	=	NormalizeDouble(aLevels[maxMarketLevel][OP_LIMLEVEL][idx_price], Digits);
							
							maxMarketLevel_tp	=	calcTPPrice(maxlevel_op, parent_type, getTP(grid_level, maxMarketLevel));
							maxMarketLevel_tp	=	NormalizeDouble(maxMarketLevel_tp, Digits); 
				}
			//}
			
			//{3.2--- установим тп для родительского ордера
				if(libOrdersFunc_isThisOrderLive(parent_ticket)){
					// значит родитель живой
					if(maxMarketLevel_tp == 0){
						// сработавшим уровнем является только уровень родителя
						int tp_pip = getTP(grid_level, 0);
						int sl_pip = sl_parent_pip; // дописать определение стоплосса для родителя
						//---
						if(!ModifyOrder_TPSL_pip(thisOrderTicket, tp_pip, sl_pip, MN )){
							addInfo(" CAN'T Modify parent order: "+thisOrderTicket);
						}
					}
					//{--- 3.2.2 модификация родителя, при сработавшем лимитно-стоповом уровне
						if(maxMarketLevel > 0){
							//--- модификация только тп. сл оставляем выставленым изначально
							if(!ModifyOrder_TPSL_price(thisOrderTicket, maxMarketLevel_tp, -1, MN)){
								addInfo(" CAN'T Modify parent order: "+thisOrderTicket);
								Print("maxMarketLevel_tp = ", maxMarketLevel_tp);
							}
						}
					//}
				}
			//}	
			
			//{3.3 --- обработка тп и сл ордеров уровней
				int aLevelOrders[];
			
				for(idx_L = 1; idx_L < ArrayRange(aLevels,0); idx_L++){
					for(idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){
						int	dimLO = fillLevelOrders(aLevelOrders, parent_ticket, idx_L, idx_oty); // заполнение массива ордеров тек. уровня

						//{--- 3.3.1 обработка тп и сл для лимитных ордеров
							if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
								
								tp_pip = 0;
								sl_pip = -1;
								double sl_price = -1;
								
								//{--- 3.3.1.1a расчет сл для лимитного ордера
									double level_price = aLevels[idx_L][idx_oty][idx_price];
									if(mgp_SL > 0){
										if(mgp_needSLToAll){
											sl_price	=	calcSLPrice(maxLimitLevelPrice, idx_oty, getSL(grid_level, idx_L));
											sl_pip	=	MathAbs((level_price - sl_price)/Point);
										}else{
											sl_pip = getSL(grid_level, idx_L);
											sl_price = calcSLPrice(level_price, idx_oty, sl_pip);
										}
									}else{
										sl_price = -1;
										sl_pip = -1;
									}
								//}
								
								//{--- 3.3.1.1 если уровень <= maxMarketLevel
									if(idx_L <= maxMarketLevel){
										
										for(int idx_ord = 0; idx_ord < dimLO; idx_ord++){
											//======
												if(!OrderSelect(aLevelOrders[idx_ord],SELECT_BY_TICKET)) continue;
											//======
											if(!ModifyOrder_TPSL_price(aLevelOrders[idx_ord], maxMarketLevel_tp, sl_price, MN )){
												addInfo(" CAN'T Modify order: "+aLevelOrders[idx_ord]);
												Print("ticket = ", aLevelOrders[idx_ord], "maxMarketLevel_tp = ", maxMarketLevel_tp);
											}
										}
									}
								//}
								
								//{--- 3.3.1.2 если уровень > maxMarketLevel
									if(idx_L > maxMarketLevel){
										tp_pip = getTP(grid_level, idx_L);
										
										for(idx_ord = 0; idx_ord < dimLO; idx_ord++){
											
											//Print("aLevelOrders["+idx_ord+"] = ",aLevelOrders[idx_ord]);
											
											//======
												if(!OrderSelect(aLevelOrders[idx_ord],SELECT_BY_TICKET)) continue;
											//======
											if(!ModifyOrder_TPSL_pip(aLevelOrders[idx_ord], tp_pip, sl_pip, MN )){
												addInfo(" CAN'T Modify order: "+aLevelOrders[idx_ord]);
											}
										}	
									}
								//}
								
							}
						//}
						
						//{--- 3.3.2 обработка тп и сл для стоповых ордеров. если стоповый ордер еще отложенный
							if(idx_oty == OP_BUYSTOP || idx_oty == OP_SELLSTOP){
								tp_pip = 0;
								sl_pip = 0;
								
								// в будущем, это у нас родительские ордера, 
								// по этому будем здесь обрабатывать только отложенные ордера
								
								
								for(idx_ord = 0; idx_ord < dimLO; idx_ord++){
									int LO_ticket = aLevelOrders[idx_ord];
									
									//======
										if(!OrderSelect(LO_ticket, SELECT_BY_TICKET)) continue;
										//---
										if(OrderType() <= 1) continue;
									//======
									int LO_grid_level = getGrid(LO_ticket);
									//---
									
									tp_pip = getTP(LO_grid_level, 0);
									sl_pip = getSL(LO_grid_level, 0); // когда станет родительским, тогда и пересчитаем сл.
									
									//---
									if(!ModifyOrder_TPSL_pip(LO_ticket, tp_pip, sl_pip, MN )){
										addInfo(" CAN'T Modify order: "+LO_ticket);
									}
								}
							}
						//}
						
						//{--- 3.3.3 обработка добавочных ордеров
							if(idx_oty == OP_ADD_BUYLIMIT || idx_oty == OP_ADD_SELLLIMIT){
								tp_pip = 0;
								sl_pip = 0;
								
								for(idx_ord = 0; idx_ord < dimLO; idx_ord++){
									LO_ticket = aLevelOrders[idx_ord];
									
									//======
										if(!OrderSelect(LO_ticket, SELECT_BY_TICKET)) continue;
									//======
									//---
									tp_pip = getTP(1, 0);
									sl_pip = getSL(1, 0); // когда станет родительским, тогда и обработаем сл.
									//---
									if(!ModifyOrder_TPSL_pip(LO_ticket, tp_pip, sl_pip, MN )){
										addInfo(" CAN'T Modify order: "+LO_ticket);
									}
								}
							}
						//}
					
						//{--- 3.3.4 обработка добавочных стоповых ордеров
							if(idx_oty == OP_ADD_BUYSTOP || idx_oty == OP_ADD_SELLSTOP){
								tp_pip = 0;
								sl_pip = 0;
								
								for(idx_ord = 0; idx_ord < dimLO; idx_ord++){
									LO_ticket = aLevelOrders[idx_ord];
									
									//======
										if(!OrderSelect(LO_ticket, SELECT_BY_TICKET)) continue;
									//======
									//---
									tp_pip = getTP(1, 0);
									sl_pip = getSL(1, 0); // когда станет родительским, тогда и обработаем сл.
									//---
									if(!ModifyOrder_TPSL_pip(LO_ticket, tp_pip, sl_pip, MN )){
										addInfo(" CAN'T Modify order: "+LO_ticket);
									}
								}
							}
						//}
					
						//{3.4 --- выставление ордеров до недостающего объема
							/*///===========================
								Алгоритм:
									1.	Определим какой объем нужно выставить на данном уровне сетки.
											расчетный объем - (объем рыночных + объем отложенных)
											пересоберем .
									2.	нужный объем разделим на кол-во ордеров в зависимости от TWISE_LOTS.
									3.	выставим эти ордера.
									4.	по каждому выставленному ордеру занесем информацию в файл ордеров.
							/*///===========================
							
							//{--- 3.4.1
								sVolLevel = getLevelOpenedVol(	parent_ticket,	idx_L,	idx_oty,	MN, Symbol());
								int	parent = NormalizeDouble(aLevels[0][0][idx_ticket],0);
								int needSend = NormalizeDouble(	aLevels[idx_L][idx_oty][idx_send],0);
								double	calc_level_vol		=	aLevels[idx_L][idx_oty][idx_vol];
								double	market_level_vol	=	StrToDouble(	returnComment(sVolLevel	, "@vm_")	);
								double	pending_level_vol	=	StrToDouble(	returnComment(sVolLevel	, "@vp_")	);
								double	pending_level_price	=	aLevels[idx_L][idx_oty][idx_price];
								string	pending_comm		=	"@p"+parent+"@l"+idx_L;
								string	file_comm			=	"";
								
								if(needSend == -1) continue;
								
								tp_pip = 0;
								sl_pip = 0;
								
								//{--- 3.4.1.1 расчет тп и сл в пунктах для лимитных ордеров
									if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
										tp_pip 	= getTP(grid_level, idx_L);
										int cmd = idx_oty;
										pending_comm = pending_comm+"@g"+grid_level+"@w"+idx_oty;
									}
								//}
								
								//{--- 3.4.1.2 расчет тп и сл в пунктах для стоповых ордеров
									if(idx_oty == OP_BUYSTOP || idx_oty == OP_SELLSTOP){
										tp_pip	=	getTP(grid_level+1, 1);
										cmd		=	idx_oty; 
										pending_comm = pending_comm+"@g"+(grid_level+1)+"@ip1"+"@w"+idx_oty;
									}
								//}
								
								//{--- 3.4.1.3 расчет тп и сл в пунктах для добавочных лимитных ордеров
									if(idx_oty == OP_ADD_BUYLIMIT || idx_oty == OP_ADD_SELLLIMIT){
										tp_pip 	= getTP(1, 0);
										
										if(idx_oty == OP_ADD_BUYLIMIT)
											cmd = OP_BUYLIMIT;
										//---
										if(idx_oty == OP_ADD_SELLLIMIT)
											cmd = OP_SELLLIMIT;
										//---	
										pending_comm = pending_comm+"@g"+grid_level+"@w"+idx_oty+"@ip1";
									}
								//}
								
								//{--- 3.4.1.4 расчет тп и сл в пунктах для добавочных стоповых ордеров
									if(idx_oty == OP_ADD_BUYSTOP || idx_oty == OP_ADD_SELLSTOP){
										tp_pip 	= getTP(1, 0);
										
										if(idx_oty == OP_ADD_BUYSTOP)
											cmd = OP_BUYSTOP;
										//---
										if(idx_oty == OP_ADD_SELLSTOP)
											cmd = OP_SELLSTOP;
										//---	
										pending_comm = pending_comm+"@g"+grid_level+"@w"+idx_oty+"@ip1";
									}
								//}
								
								//=====
									if(needSend == -1) continue;
								//=====
								double	needSendVol = calc_level_vol - (market_level_vol + pending_level_vol);
								
								int	sendCount = TwisePending(needSendVol,	0,	TL_COUNT, TWISE_LOTS);
								double	used_send_vol = 0;
								for(int ord_count = 1; ord_count <= sendCount; ord_count++){
									double send_vol = TwisePending(needSendVol, used_send_vol, TL_VOL, TWISE_LOTS);
									used_send_vol = used_send_vol + send_vol;
									//{--- 
										int	res	=	OpenPendingPRSLTP_pip(	Symbol(), cmd, send_vol, pending_level_price, sl_pip, tp_pip, pending_comm, MN, 0, CLR_NONE);
										if(	res == -1 ){
											addInfo("CAN'T send order at level:"+idx_L+" type: "+cmd+" pr = "+pending_level_price);
										}else{
											file_comm = file_comm + "@ot"+res+pending_comm;
											addRecordInFileOrders(INIFile_ord,	file_comm);
											libELT_addRecordInFileGrid(INIFile_grd, file_comm+"@wl"+send_vol);
										}
									//}
								}
							//}
						//}
					}
				}
			//}
		//}
	}
return(0);	
}
//======================================================================

/*///===================================================================
	Версия: 2011.04.10
	---------------------
	Описание:
		пробегаемся по рыночным выставленным ордерам
		и удаляем только отложенные ордера, для которых 
		нет ни одного рыночного ордера, принадлежащего его (тек. ордера) сетке
	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		нет
/*///-------------------------------------------------------------------
void delPendingOrders(){
	int t = OrdersTotal();
	for(int thisOrder = 0; thisOrder <= t; thisOrder++){
		//==========
			if(!OrderSelect(thisOrder, SELECT_BY_POS, MODE_TRADES)) continue;
			//---
			int		ot		= OrderTicket();
			int 	oty		= OrderType();
			string 	ocomm 	= OrderComment();
			//---
				if(StrToInteger(returnComment(ocomm,"@p")) == -1){
					if(isParentOrder(ot, MN, Symbol()) && isFirstOrder(ot, MN, Symbol())) continue;
				}
				if(!checkOrderByTicket(ot, CHK_TYMORE, Symbol(), MN, 2)) continue;
				//---
				if(isGridLive(ot, MN)) continue; // сетка еще живая, значит удалять ордер нет смысла :)
		//==========
		// сетка умерла. убъем ордер.
		delPendingByTicket(ot);
	}
}
//======================================================================

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init(){
//----
		SPREAD = MarketInfo(Symbol(),	MODE_SPREAD);
		//---
		INIFile_name   = StringConcatenate(EXP_NAME,"_",AccountNumber(),"_",Symbol(),"_",MN);
		INIFile_folder = TerminalPath()+"\\experts\\files\\";
		INIFile_ord    = StringConcatenate(INIFile_folder,INIFile_name,".ord");
		INIFile_grd		= StringConcatenate(INIFile_folder,INIFile_name,".grd");
		Print(INIFile_ord);
		//---
		initLibs(); // инициализируем библиотеки   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit(){
//----
   deinitInfo(); // удаляем объекты, созданные addInfo();
//----
   return(0);
  }


int res = 0;
//{{-----------------------
int start(){
	res++;
	//Print("========= START ===== ", res);
   if(!isDone){ 
      return(0); // если не закончена предыдущая ф-ция start(), тогда выходим
   }else{
      isDone = false;
	}
   //------
   libCO_closeByProfit();
   startCheckOrders(); 
   delPendingOrders();
   //---
	if(OrdersTotal() == 0 && openFirstOrder){
		OpenPendingOrders();
	} 
	//---
	//********************************
    //2010,09,09
    //*******************************
    if(libCWT_canWeTrade()){
		if(libAO_needBarsOpen){
            //delLimits();
            //collapsArray();
			libAO_BarOpen();
        }
    }
   //------
   isDone = true;
   //Print("<<<<<, END ", res);
   return(0);
}
//========================}} 

void OpenPendingOrders(int magicBUY = 0, int magicSELL = 0){
int res = -1;
int tryOpen = 5;

datetime exp = 0;

if(FirstOrderExp > 0){
   exp = TimeCurrent() + FirstOrderExp*60;
}

int cmd = 0;
   if(FirstOrderDiapazonPip > 0)
      cmd = OP_BUYSTOP;
double pr = Ask;
//Выставляем отложенные ордера с отступом от цены
   while (IsTradeContextBusy())
   {
      Sleep(3000);
      RefreshRates();
   }
   int try = 0;
   
   while (res < 0 && try < tryOpen && !IsStopped())
   {   
      Sleep(3000);
      RefreshRates();
      
      pr = Ask;
      if(FirstOrderDiapazonPip > 0)
         pr = NormalizeDouble((pr + FirstOrderDiapazonPip*Point),Digits);
      //---
      if(cmd <= 1){
         exp = 0;
      }
      //---
      
      pr = NormalizeDouble(pr,Digits);
      res = OrderSend(Symbol(),cmd,al_LOT_fix, pr,3,0,0,"@ip1@g1",magicBUY,exp,CLR_NONE);
      try++;
   }   
   
   try = 0;
   res = -1;
   cmd = 1;
   if(FirstOrderDiapazonPip > 0)
         cmd = OP_SELLSTOP;
   while (res < 0 && try < tryOpen && !IsStopped())
   {   
      Sleep(3000);
      RefreshRates();
      
      pr = Bid;
      if(FirstOrderDiapazonPip > 0)
         pr = NormalizeDouble((pr - FirstOrderDiapazonPip*Point),Digits);
      //---
      if(cmd <= 1){
         exp = 0;
      }
      //---
      pr = NormalizeDouble(pr,Digits);
      res = OrderSend(Symbol(),cmd,al_LOT_fix, pr,3,0,0,"@ip1@g1",magicSELL,exp,CLR_NONE);
      try++;
   }   
} 