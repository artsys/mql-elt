//+------------------------------------------------------------------+
//|                                                          eLT.mq4 |
//|                                         программирование artamir |
//|                                                artamir@yandex.ru |
//+------------------------------------------------------------------+ 

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
#define		OP_SLTP				200
#define		OP_SORD				100

#define		CHK_SMBMN			500
#define		CHK_SMB				700
#define		CHK_MN				600
#define		CHK_TYMORE			400
#define		CHK_TYLESS			300
#define		CHK_TYEQ			200

#define		EXP_NAME			"eLT 10.x"

//===================
// Настройки массива уровней

#define		a_dINI				-10000.00	// значение инициализации массива (доубл) 

// размерность
#define		aL_MAXL				30			// 1-е измерение
#define		aL_MAXTY			10			// 2-е измерение 
#define		aL_AllTypes			21			// 2-е измерение 
#define		aL_MAXSET			10			// 3-е измерение

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


//======================================================================

//---- input parameters
extern         double    TWISE_LOTS        =     20;     // деление ордеров при достижении расчетного значения объема => заданного значения
extern         int       MN                =     0;      // магик с которым будет работать советник. чужие магики обрабатываться не будут 
extern string MGP       = "===== MAIN GRID PROP >>>>>>>>>>>>>>>>>";
extern         int       mgp_Target        =     25;    //Фиксированное значение таргета (отменяется использованием useAVG_H1 или useAVG_D)
extern         int       mgp_TargetPlus    =      0;    //увеличение таргета в зависимости от уровня на TargetPlus пунктов

extern         int       mgp_TP_on_first   =     25;    //кол. пунктов для выставления тп на родительский ордер, когда нет сработавших дочерних ордеров
extern         int       mgp_TP            =     50;    //кол. пунктов для выставления тп на сработавшие ордера сетки. расчет от последнего сработавшего ордера
extern         int       mgp_TPPlus        =      0;    //увеличение тп от уровня на заданное количество пунктов.

extern         int       mgp_SL_on_first   =      0;    // стоплосс на первый ордер
extern         bool      mgp_needSLToAll   =  false;    // выставлять сл на всю сетку от последнего ордера или отдельно на каждый ордер
extern         int       mgp_SL            =      0;    // выставляется для каждого

extern         bool      mgp_useLimOrders  =   true;    // разрешает советнику использовать лимитную сетку
extern         int          mgp_LimLevels  =      5;    // количество уровней лимитной сетки, включая родительский ордер

extern         double    mgp_plusVol       =    0.0;    // увеличение объема след. уровня на величину <mgp_plusVol> (+)
extern         double    mgp_multiplyVol   =      2;    // увеличение объема след. уровня в <mgp_multiplyVol> раз   (*)


extern string ADD_DESC  = "=========== Adding lim. order as parent";
extern         bool       add_useAddLimit          =	false		;	// разрешает советнику выставлять добавочный лимитный ордер как родительский
extern         int        	add_LimitLevel              =	3		;	// уровень сетки, от которого будет произведен расчет цены добавочного ордера
extern         int        	add_Limit_Pip               =	15		;	// сколько пунктов от уровня будет выставлен добавочный ордер
extern         bool       	add_Limit_useLevelVol    =	true		;	// разрешает советнику использовать настройку <add_Limit_multiplyVol> иначе будет использоваться <add_Limit_fixVol>  
extern         double     		add_Limit_multiplyVol       =	1	;	// коэф. умножения объема уровня <add_LimitLevel> основной сетки лимитных ордеров
extern         double     		add_Limit_fixVol            = 0.1	;	// фиксированный объем добавочного ордера
																		// Соглашение: сетка для добавочного ордера расчитывается из настроек <mgp_> 

extern   string AL_DESC = "=========== AUTO_LOT SETUP ==========";
extern         double     al_LOT_fix           =    0.1;         // фиксированный стартовый лот
extern            bool    al_needAutoLots      =  false;         // разрешает авторасчет объема родительского ордера
                     bool    al_useMarginMethod      = true;     // разрешает использовать метод залога
extern               double  al_DepositPercent       =    1;     // процент от депозита для расчета методом залога                     
extern string MGP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";

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
extern         double        SO_SL						=   1.5		;	// описание аналогично пред. настройке
extern string SOP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"	;	


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
bool	isDone			= true	;	// определяет флаг окончания функции start()
int		SPREAD			= 0		;	// Спред валютной пары, на которой запущен советник
string	INIFile_ord		= ""	;	// ини файл ордеров
string	INIFile_name	= ""	;	// основное название файла
string	INIFile_folder	= ""	;	// путь расположения файлов советника
//======================================================================

/*///==============================================================
      Версия: 2011.03.24
      ------------------
      Описание:
         Инициализация и проверка версии библиотеки функций помощи
         <libHelpFunc> 
/*///--------------------------------------------------------------
#include <libHelpFunc.mqh>
#include <libOrdersFunc.mqh>
#include <libINIFileFunc.mqh>
#include <libeLT.mqh>
//-------
int initLibs(){
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
   Версия: 2011.04.01
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
		if(grid_level == 1 && level == 0){
			return(mgp_TP_on_first);
		}else{
			if(grid_level == 1 && level > 0){
				return(mgp_TP + (mgp_TPPlus * level-1));
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
					return(mgp_TP_on_first * SO_TP * grid_level);
				}else{
					return((mgp_TP + (mgp_TPPlus * level-1)) * SO_TP * grid_level);
				}	
            }else{
               return(SO_TP * grid_level);
            }      
      }
   //<<<<<<<
   
}
//======================================================================


/*///===================================================================
   Версия: 2011.03.29
   ---------------------
   Описание:
      Возвращает текущее значение таргета в зависимости 
      от настроек советника и текущего гридЛевела
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      condition    = логическое сравнение
      ifTrue       = значение в случае condition = ИСТИНА
      ifFalse      = значение в случае condition = ЛОЖЬ

/*///-------------------------------------------------------------------
int getTarget(int grid_level, int level){
   // проверка на 1-й гридЛевел
      if(grid_level == 1){
         return(mgp_Target * level);
      }
   //<<<<<<<
   // гридЛевел > 1
      if(grid_level >= 2){
         //значит у нас сработал стоповый ордер
         //Алгоритм: 
            // проверим таргет для стоповых будет фикс или коэф
            // для коэф: таргет лим. сетки * гридЛевел
            //    чтоб получить таргеты как для родительской сетки, нужно все коэф = 1;
            // для фикса: возвращаем заданное в настройках значение
            //---
            if(SO_useKoefProp){
               return(mgp_Target * SO_Target * level * grid_level);
            }else{
               return(SO_Target * level * grid_level);
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
int getMaxMarketLevel(double arr[][][]){
   double res = 0;
		for(int idx_L = 0; idx_L < ArrayRange(arr, 1); idx_L++){
			for(int idx_oty = 0; idx_oty <= 5; idx_oty++){ // цикл по лимитным и стоповым ордерам
				if(arr[idx_L][idx_oty][idx_isMarket] == 1)
					res = MathMax(res , idx_L);	
			}
		}
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
int fillLevelOrders(int& arr[], int level, int wt){
	int res = 0;
	ArrayResize(arr,1);
	ArrayInitialize(arr, -1);
	int dim = ArrayRange(arr, 1);
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
				if(!checkOrderByTicket(ot, CHK_MN, "", MN, -1)) continue; // проверим, чтоб ордер был рыночным
				//---
				int olevel = getOrderLevel(ot);
				if(olevel != level) continue;
				//---
				int owt = getWasType(ot);
				if(owt != wt) continue;
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
   Версия: 2011.03.24
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
   Доп. функции:
      нет
   ---------------------
   Переменные:
      нет

/*///-------------------------------------------------------------------
void startCheckOrders(){

	double aLevels[][aL_AllTypes][aL_MAXSET]; // 1-е измерение оставили пустым для ресайза

	int t = OrdersTotal();
	for(int i = 0; i <= t; i++){ // собираем массив aLevels[][][]
		//=================
			if(!OrderSelect(i, SELECT_BY_POS,MODE_TRADES)) continue;
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
			if(!isParentOrder(parent_ticket, MN)) {
				// если это рыночный ордер, то проверим, живой ли родитель.
				// если родителя нет, то в истории ищем родителя и 
				// перенастраиваем родительские переменные
				// согласно историческому ордеру.
				
				if(parent_type <= 1){
					//--- у нас рыночный ордер
					if(!isParentLive(parent_ticket)){
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
						
					}else{
						continue;	// если родитель живой, тогда продолжим цикл по ордерам
					}
				}else{
					continue;      
				}	
			}	
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
			aLevels[0][0][idx_ParentType  ]  = OrderType();

			for(int idx_L = 1; idx_L < maxaLevels; idx_L++){                     // цикл по уровням. Первый отложенный уровень = 1. 
				// цикл  по типам ордеров >>>>>>>
				for(int idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){              // цикл по типам ордеров на текущем уровне
					//2.23
					//{ обработка лимитных ордеров
						if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
							//---
							//{--- Проверим правильный тип лимитного ордера 
								if(parent_type == OP_BUY && idx_oty != OP_BUYLIMIT){
									aLevels[idx_L][idx_oty][idx_send] = -1.00;
									continue;
								}
								//---
								if(parent_type == OP_SELL && idx_oty != OP_SELLLIMIT){
									aLevels[idx_L][idx_oty][idx_send] = -1.00;
									continue;
								}
							//}<<<< правильный тип лимитного ордера	
						
							//{--- добавим объем в глоб. описание лим. сетки
							//    это описание доступно по адресу: aL[<нужный уровень>][OP_LIMLEVEL][<нужный параметр>]
								int target = getTarget(parent_grid, idx_L);
								aLevels[idx_L][OP_LIMLEVEL][idx_vol			]	= calcLimitVol( parent_vol, idx_L)              ;
								aLevels[idx_L][OP_LIMLEVEL][idx_price		]	= calcPrice(    parent_opr, parent_type, target);
								aLevels[idx_L][OP_LIMLEVEL][idx_gridLevel	]	= parent_grid;
							//}	
							//---
							if(idx_L < mgp_LimLevels && mgp_useLimOrders){
								//---						      
								aLevels[idx_L][idx_oty][idx_price     	]	=	calcPrice(parent_opr,	parent_type,	target);
																				//-----					
								aLevels[idx_L][idx_oty][idx_vol       	]	=	calcLimitVol(	parent_vol,	idx_L);
																				//-----				
								aLevels[idx_L][idx_oty][idx_isMarket  	]	=	isMarketLevel(	parent_ticket,	idx_L,	MN);
																				//------				
								aLevels[idx_L][idx_oty][idx_ParentType	]	=	parent_type;
								//---
								string sVolLevel = getLevelOpenedVol(	parent_ticket,	idx_L,	idx_oty,	MN); // возвращает результат в виде "@vm1.6@vp3.2" vm - объем рыночных, vp - отложенных
								//---
								aLevels[idx_L][idx_oty][idx_volMarket 	]	=	StrToDouble(	returnComment(sVolLevel	, "@vm_")	);
																				//------								
								aLevels[idx_L][idx_oty][idx_volPending	]	=	StrToDouble(	returnComment(sVolLevel	, "@vp_")	);
																				//------								
								//---
								aLevels[idx_L][idx_oty][idx_send 		]	=	1.00;      
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
								
									if(idx_L >= SO_StartLevel-1 && idx_L < SO_EndLevel-1){
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
										sVolLevel	=	getLevelOpenedVol(parent_ticket, idx_L, idx_oty, MN);
										//---
										aLevels[idx_L][idx_oty][idx_volMarket ] = StrToDouble(	returnComment(sVolLevel,"@vm_")	);
										aLevels[idx_L][idx_oty][idx_volPending] = StrToDouble(	returnComment(sVolLevel,"@vp_")	);
									
									}
								}else{
									aLevels[idx_L][idx_oty][idx_send] = -1.00; // уровень больше чем разрешенный для стопордеров
								}
								//---
							}else{
								aLevels[idx_L][idx_oty][idx_send] = -1.00;		// не будем выставлять стопордера на этом уровне
							}
						}//}<<<< обработка стоповых ордеров
					
					//{ обработка добавочных ордеров
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
								
									sVolLevel	=	getLevelOpenedVol(parent_ticket, idx_L, idx_oty, MN);
									//---
									aLevels[idx_L][idx_oty][idx_volMarket ] = StrToDouble(	returnComment(sVolLevel,"@vm_")	);
									aLevels[idx_L][idx_oty][idx_volPending] = StrToDouble(	returnComment(sVolLevel,"@vp_")	);
								}
							}
						}
					//}
				}//<<<< цикл  по типам ордеров         
			}
	}	

	/*///===================================================
		3. Проверим какой уровень максимальный сработавщий для данного родителя.
		    3.1 в зависимости от макс. сработавшего уровня определяем тп сл для всех уровней  		
	/*///===================================================
	
	int maxMarketLevel = getMaxMarketLevel(aLevels); // уровни считаются с 0. 0 -родительский
	
	//{--- в цикле по уровням проверим тп и сл для ордеров сетки
		//	продумать алгоритм проверки на тп и сл.
		//	и возможно, одновременное выставление недостающих ордеров.
		// объемы рыночных и отложенных для данного уровня у нас уже есть.
		//	осталось доставить ордера до расчетного объема.
		int		grid_level	= NormalizeDouble(aLevels[idx_L][OP_LIMLEVEL][idx_gridLevel],0);
		double	maxMarketLevel_tp = 0;	
		//{3.1 --- расчитаем ТП для лимитной сетки, если maxMarketLevel > 1
			if(maxMarketLevel > 0){
				double	maxlevel_op	=	NormalizeDouble(aLevels[maxMarketLevel-1][OP_LIMLEVEL][idx_price], Digits);
						
						maxMarketLevel_tp	=	calcPrice(maxlevel_op, parent_type, getTP(grid_level, maxMarketLevel));
			}
		//}
		//{3.2--- установим тп для родительского ордера
			if(thisOrderTicket == parent_ticket){
				// значит родитель живой
				if(maxMarketLevel_tp == 0){
					// сработавшим уровнем является только уровень родителя
					int tp_pip = getTP(grid_level, 0);
					int sl_pip = 0; // дописать определение стоплосса для родителя
					//---
					if(!ModifyOrder_TPSL_pip(thisOrderTicket, tp_pip, sl_pip, MN )){
						addInfo(" CAN'T Modify order: "+thisOrderTicket);
					}
				}
			}
		//}	
		
		//{3.3 --- обработка тп и сл ордеров уровней
			int aLevelOrders[];
		
			for(idx_L = 1; idx_L < ArrayRange(aLevels,1); idx_L++){
				// Дописать: 2011.03.31
				for(idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){
					int	dimLO = fillLevelOrders(aLevelOrders, idx_L, idx_oty); // заполнение массива ордеров тек. уровня
					//{--- 3.3.1 обработка тп и сл для лимитных ордеров
						if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
							
							tp_pip = 0;
							sl_pip = 0;
							
							//{--- 3.3.1.1 если уровень <= maxMarketLevel
								if(idx_L <= maxMarketLevel){
									tp_pip	=	getTP(grid_level, maxMarketLevel);
								}
							//}
							
							//{--- 3.3.1.2 если уровень > maxMarketLevel
								if(idx_L > maxMarketLevel){
									tp_pip = getTP(grid_level, idx_L);
								}
							//}
							
							for(int idx_ord = 0; idx_ord < dimLO; idx_ord++){
								//======
									if(!OrderSelect(aLevelOrders[idx_ord],SELECT_BY_TICKET)) continue;
								//======
								if(!ModifyOrder_TPSL_pip(aLevelOrders[idx_ord], tp_pip, sl_pip, MN )){
									addInfo(" CAN'T Modify order: "+aLevelOrders[idx_ord]);
								}
							}	
						}
					//}
					
					//{--- 3.3.2 обработка тп и сл для стоповых ордеров. если стоповый ордер еще отложенный
						if(idx_oty == OP_BUYSTOP || idx_oty == OP_SELLSTOP){
							tp_pip = 0;
							sl_pip = 0;
							
							for(idx_ord = 0; idx_ord < dimLO; idx_ord++){
								int LO_ticket = aLevelOrders[idx_ord];
								
								//======
									if(!OrderSelect(LO_ticket, SELECT_BY_TICKET)) continue;
								//======
								int LO_grid_level = getGrid(LO_ticket);
								//---
								tp_pip = getTP(LO_grid_level, 0);
								sl_pip = 0;
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
								sl_pip = 0;
								//---
								if(!ModifyOrder_TPSL_pip(LO_ticket, tp_pip, sl_pip, MN )){
									addInfo(" CAN'T Modify order: "+LO_ticket);
								}
							}
						}
					//}
				}
			}
		//}
	//}
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
		INIFile_folder = StringConcatenate(TerminalPath(),"/experts/files/",EXP_NAME);
		INIFile_ord    = StringConcatenate(INIFile_folder,INIFile_ord,".ord");
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
   if(!isDone) 
      return(0); // если не закончена предыдущая ф-ция start(), тогда выходим
   else
      isDone = false;
   //------
   startCheckOrders(); 
   //---
   isDone = true;
   return(0);
}
//========================}} 