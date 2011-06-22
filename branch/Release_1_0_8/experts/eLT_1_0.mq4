//+------------------------------------------------------------------+
//|                                                          eLT.mq4 |
//|                                                 ver 1.0.9.0612.02|
//|                                         ���������������� artamir |
//|                                                artamir@yandex.ru |
//+------------------------------------------------------------------+

/*///===================================================================
	�������� :
		3,4,5,
		[6] 	- ������ �������� ��� ����� �������.
		[7] 	- ������ ���������� ���������� libELT.mq4
		[9] 	- ���������� ����������� ��������� ������.
		[12,13] - ������ ����������� ���������� �������.
		[14] 	- ��������� ��������� SO_TP_on_first 
				- ��������� ������ �������, �� � �� ��� ����� ������� >= 2
				- ���������� libELT: isMarketLevel
				- startCheckOrders ������� �� ��� �����
				- �������� ������� "@ip1" ��� ���������� �������.
			-----
				- ��������� ���������� libCO_closeByProfit
		[28]	- ��������� ��� � ��������� ������������, ������������ �������, ��� �� = 0.
		[32]	- ��������� ���������� libAutoOpen (libAO)
				- ��������� ���������� libCWT (canWeTrade)
		[33]	- ��������� �� ����� ��������.	  
/*///=================================================================== 
#property copyright "copyright (c) 2008-2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org, mailto: artamir@yandex.ru"

/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ������������� ��������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ���������:
       OP_SLTP = ����������� ��� ���� �������� ���������� �� � �� ��� �������         
       OP_SORD = ����������� ��� ���� �������� �������� �������
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
// ��������� ������� �������

#define		a_dINI				-1.00	// �������� ������������� ������� (�����) 

// �����������
#define		aL_MAXL				30			// 1-� ���������
#define		aL_MAXTY			10			// 2-� ��������� 
#define		aL_AllTypes			21			// 2-� ��������� 
#define		aL_MAXSET			11			// 3-� ���������

//===================
// ���� ���������� �������
#define		OP_ADD_BUYLIMIT		6			// ���������� ��������
#define		OP_ADD_SELLLIMIT	7			// ���������� ���������
#define		OP_ADD_BUYSTOP		8			// ���������� �������
#define		OP_ADD_SELLSTOP		9			// ���������� ��������

#define		OP_LIMLEVEL			20			// ����������� ��� ����, ������� ����� ��������� �������� �����

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
extern			double		TWISE_LOTS			=     20	;	// ������� ������� ��� ���������� ���������� �������� ������ => ��������� ��������
extern			int			MN					=     0		;	// ����� � ������� ����� �������� ��������. ����� ������ �������������� �� ����� 
//{--- MAIN GRID PROP
extern string MGP	= "===== MAIN GRID PROP >>>>>>>>>>>>>>>";
extern			int       mgp_Target        =     25		;	//������������� �������� ������� (���������� �������������� useAVG_H1 ��� useAVG_D)
extern			int       mgp_TargetPlus    =      0		;	//���������� ������� � ����������� �� ������ �� mgp_TargetPlus �������

extern			int       mgp_TP_on_first   =     25			;	//���. ������� ��� ����������� �� �� ������������ �����, ����� ��� ����������� �������� �������
extern			int       mgp_TP            =     50			;	//���. ������� ��� ����������� �� �� ����������� ������ �����. ������ �� ���������� ������������ ������
extern			int       mgp_TPPlus        =      0			;	//���������� �� �� ������ �� �������� ���������� �������.

int       mgp_SL_on_first   =      0;    // �������� �� ������ ����� (� ����� ���� ����� �� �������������) 
extern			bool	mgp_needSLToAll   =  false				;	// ���������� �� �� ��� ����� �� ���������� ������ ��� �������� �� ������ �����
extern			int			mgp_SL				=		0		;	// ������� �� <mgp_needSLToAll> �����������: ������
extern			int			mgp_SLPlus			=		0		;	// ���������� �� � ����������� �� ������ ������� �����

extern         bool      mgp_useLimOrders  =   true			;	// ��������� ��������� ������������ �������� �����
extern         int          mgp_LimLevels  =      5			;	// ���������� ������� �������� �����, ������� ������������ �����

extern         double    mgp_plusVol       =    0.0			;	// ���������� ������ ����. ������ �� �������� <mgp_plusVol> (+)
extern         double    mgp_multiplyVol   =      2			;	// ���������� ������ ����. ������ � <mgp_multiplyVol> ���   (*)
//}

//{--- Adding lim. order
extern string ADD_LIMDESC  = "=========== Adding lim. order as parent";
extern         bool       add_useAddLimit          =	false		;	// ��������� ��������� ���������� ���������� �������� ����� ��� ������������
extern         int        	add_LimitLevel              =	3		;	// ������� �����, �� �������� ����� ���������� ������ ���� ����������� ������
extern         int        	add_Limit_Pip               =	15		;	// ������� ������� �� ������ ����� ��������� ���������� �����
extern         bool       	add_Limit_useLevelVol    =	true		;	// ��������� ��������� ������������ ��������� <add_Limit_multiplyVol> ����� ����� �������������� <add_Limit_fixVol>  
extern         double     		add_Limit_multiplyVol       =	1	;	// ����. ��������� ������ ������ <add_LimitLevel> �������� ����� �������� �������
extern         double     		add_Limit_fixVol            = 0.1	;	// ������������� ����� ����������� ������
																		// ����������: ����� ��� ����������� ������ ������������� �� �������� <mgp_> 
//}

//{--- Adding stop order
extern string ADD_STOPDESC  = "=========== Adding stop order as parent";
extern         bool       add_useAddStop          =	false		;	// ��������� ��������� ���������� ���������� �������� ����� ��� ������������
extern         int        	add_StopLevel              =	3		;	// ������� �����, �� �������� ����� ���������� ������ ���� ����������� ������. ������������ ����� ��������� �� 1-� ������ 
extern         int        	add_Stop_Pip               =	15		;	// ������� ������� �� ������ ����� ��������� ���������� �����
extern         bool       	add_Stop_useLevelVol    =	true		;	// ��������� ��������� ������������ ��������� <add_Stop_multiplyVol> ����� ����� �������������� <add_Stop_fixVol>  
extern         double     		add_Stop_multiplyVol       =	1	;	// ����. ��������� ������ ������ <add_StopLevel> �������� ����� �������� �������
extern         double     		add_Stop_fixVol            = 0.1	;	// ������������� ����� ����������� ������
	// ����������: ����� ��� ����������� ������ ������������� �� �������� <mgp_> 								
//}	

//{--- auto lot																		
extern   string AL_DESC = "=========== AUTO_LOT SETUP ==========";
extern			double	al_LOT_fix           =    0.1				;	// ������������� ��������� ���
extern			bool	al_needAutoLots      =  false				;	// ��������� ���������� ������ ������������� ������
                     bool    al_useMarginMethod      = true			;	// ��������� ������������ ����� ������
extern               double  al_DepositPercent       =    1			;	// ������� �� �������� ��� ������� ������� ������                     
extern string MGP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";
//}

//{--- �������� ������
extern string SOP       = "===== STOP ORDERS PROP >>>>>>>>>>>>>>>";
extern         bool     SO_useStopLevels		=    false			;	// ��������� ��������� ������������ ����������� �������� �������
extern         int             SO_Levels				=  -1		;	// -1 - ���������� ������� ��������� � �������� �������� �������, ���� ������ ��������� �������� �������

extern         int             SO_StartLevel			=   2		;	// �������, � �������� ������������ �������� ������ ��� ������� ��������. ������������ ����� ����� ������ 1
																		// �.�. � ������ ������ �������� ������ ����� ������������ � ������ ������� ��������� ������
extern         bool            SO_useLimLevelVol		=	true	;	// ��������� ������������ ����� �������� ������ �������� ����� ��� ������� ������ ��������� ������
																		// ����� ��� ������� ������ ������������ ����� ������������� ������.
extern         double          SO_LimLevelVol_Divide	=	-1		;	// ������� ������ ���. ������ ��� ���������� ������ ����. �� ������ LevelVolParent
																		// -1 ������������ ������� �������������      
extern         int             SO_EndLevel				=   3		;	// ��������� <SO_useLimLevelVol> � <SO_LimLevelVol_Divide> ����� �������������� �� ����� ������ ������������

extern         int             SO_ContinueLevel			=   5		;	// ������� ���� ������� � �� SO_Levels ����� ���������� ������������ �������� ������.
extern         double          SO_ContLevelVol_Divide	=	1		;	// ��� ������� ������������ ��������� �������� ������ ���. ������ �������� ������.

extern    string  SOTGP = "=========== SO_TARGET, SO_TP, SO_SL =="	;
extern         bool     SO_useKoefProp			=  true				;	// ��������� ��������� ������������ ��������� �������, �� � �� ��� �������� ������� � �������� ����. ��������� 
																		// ������������� � ���������� �����-��������.
extern         double        SO_Target					=   1.5		;	// � ����������� �� <SO_useKoefProp> ����� ��������� �������� <������� ����. �����> * SO_Target, ���� ����. 
																		// �������� � �������, ����������� � ������ �����, ��� ����� �������� �����.
extern         double        SO_TP						=   1.5		;	// �������� ���������� ����. ���������
extern         double        SO_TP_on_first				=   1.5		;	// �������� ���������� ����. ��������� (������������� ��� ���������-1)
extern         double        SO_SL						=   1.5		;	// �������� ���������� ����. ���������
extern string SOP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"	;	
//}

//--------------------------------------
// �������� ������� ������ (��� �������)
extern string    ex_OPEN_FIRST_ORDER      = "--- �������� ������� ������ ��� ������� ---";
extern bool         openFirstOrder           = false;
extern int          FirstOrderDiapazonPip    = 75;  // ��������, � ������� ������������ ������ 
                                                    // ������ (��������)
                                                    // ���� = 0, �� �������� �� ���. ����
extern int          FirstOrderExp            = 15;  // ����� ����� ����������� ������ � ���.                                               
extern string    ex_END_OPEN_FIRST_ORDER  = "==================================================="; 
/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ���������� ����������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
/*///-------------------------------------------------------------------
bool	isDone				= true	;	// ���������� ���� ��������� ������� start()
int		SPREAD				= 0		;	// ����� �������� ����, �� ������� ������� ��������
string	INIFile_ord			= ""	;	// ��� ���� �������
string	INIFile_name		= ""	;	// �������� �������� �����
string	INIFile_folder		= ""	;	// ���� ������������ ������ ���������
string  file_ord			= ""    ;   // ��������� INIFile_ord
string	INIFile_grd			= ""	;	// ��� ���� ������� ������� �����
//======================================================================

/*///==============================================================
      ������: 2011.03.24
      ------------------
      ��������:
         ������������� � �������� ������ ���������� ������� ������
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
      ������: 2011.03.24
      ------------------
      ��������:
         ����� ������������������ ��������� �� ������ � ����
         ���������
      ------------------
      ����������:
            �� �����:
               str_err = ������ � ������� ���������
               fn      = ��� ������, ���������� ������
            ------------
            �� ������:
               ���       
/*///--------------------------------------------------------------
string logIni(string str_err, string fn=""){
   Print("===============================");
   Print("INI ERROR: ",str_err);
   Print("INI ERROR: in func - ",fn);
   Print("===============================");
}
//==============================================================



/*///===================================================================
   ������: 2011.04.22
   ---------------------
   ��������:
      ���������� ������� �������� �� � ����������� 
      �� �������� ��������� � �������� ����������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
		grid_level	-	������� ����������� �����
		level		-	������� �����

/*///-------------------------------------------------------------------
int getTP(int grid_level, int level){

   // �������� �� 1-� ���������
		if(grid_level <= 1 && level == 0){
			return(mgp_TP_on_first);
		}else{
			if(grid_level <= 1 && level > 0){
				return(mgp_TP + (mgp_TPPlus * (level-1)));
			}
		}
   //<<<<<<<
   // ��������� > 1
      if(grid_level >= 2){
         //������ � ��� �������� �������� �����
         //��������: 
            // �������� �� ��� �������� ����� ���� ��� ����
            // ��� ����: �� ���. ����� * ���������
            //    ���� �������� �� ��� ��� ������������ �����, ����� ��� ���� = 1;
            // ��� �����: ���������� �������� � ���������� ��������
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
   ������: 2011.04.22
   ---------------------
   ��������:
      ���������� ������� �������� sl � ����������� 
      �� �������� ��������� � �������� ����������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
		grid_level	-	������� �����

/*///-------------------------------------------------------------------
int getSL(int grid_level, int level){

   // �������� �� 1-� ���������
		if(grid_level <= 1 && level == 0){
			return(mgp_SL);
		}else{
			if(grid_level <= 1 && level > 0){
				return(mgp_SL + (mgp_SLPlus * (level-1)));
			}
		}
   //<<<<<<<
   // ��������� > 1
      if(grid_level >= 2){
         //������ � ��� �������� �������� �����
         //��������: 
            // �������� �� ��� �������� ����� ���� ��� ����
            // ��� ����: �� ���. ����� * ���������
            //    ���� �������� �� ��� ��� ������������ �����, ����� ��� ���� = 1;
            // ��� �����: ���������� �������� � ���������� ��������
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
   ������: 2011.04.22
   ---------------------
   ��������:
      ���������� ������� �������� ������� � ����������� 
      �� �������� ��������� � �������� ����������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
		grid_level - ������� �����
		level - ������� �����
/*///-------------------------------------------------------------------
int getTarget(int grid_level, int level){
	
	int trg = mgp_Target * level + (mgp_TargetPlus*level-1);
	
   // �������� �� 1-� ���������
      if(grid_level <= 1){
         return(trg);
      }
   //<<<<<<<
   // ��������� > 1
      if(grid_level >= 2){
		//������ � ��� �������� �������� �����
		//��������: 
			// �������� ������ ��� �������� ����� ���� ��� ����
			// ��� ����: ������ ���. ����� * ����. � �������(���������-1)
			//    ���� �������� ������� ��� ��� ������������ �����, ����� ��� ���� = 1;
			// ��� �����: ���������� �������� � ���������� ��������
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
   ������: 2011.03.31
   ---------------------
   ��������:
      ���������� ������������ �������� ������� �����      
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      arr = aLevels

/*///-------------------------------------------------------------------
int getMaxMarketLevel(double& arr[][][]){
   double res = 0;
		for(int idx_L = 0; idx_L < ArrayRange(arr, 0); idx_L++){
			for(int idx_oty = 0; idx_oty <= 5; idx_oty++){ // ���� �� �������� � �������� �������
				if(arr[idx_L][idx_oty][idx_isMarket] == 1)
					res = MathMax(res , idx_L);	
			}
		}
   return(res);    
}
//======================================================================

/*///===================================================================
	������: 2011.04.08
	---------------------
	��������:
		���������� ���� ������������� ������ �������� �����.
	---------------------
	���. �������:
		���
	---------------------
	����������:
		arr[][][] - ������ �������
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
   ������: 2011.03.29
   ---------------------
   ��������:
      ���������� ����� ��� �������� ������ �������� �����      
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      ���

/*///-------------------------------------------------------------------
double calcLimitVol(double parent_vol, int level){
   double vol = 0;
      vol = (parent_vol + mgp_plusVol*level) * MathPow(mgp_multiplyVol,level);
   return(calcVolNormalize(vol,	1));    
}
//======================================================================

/*///===================================================================
	������: 2011.03.31
	---------------------
	��������:
		���������� ��������������� ����� ���  
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
/*///-------------------------------------------------------------------
double calcVolNormalize(double vol, double divide){
	double res = 0;
	double minLot = MarketInfo(Symbol(),	MODE_MINLOT);
	//{--- ������ ������
		res = vol / divide;
		res = MathMax(NormalizeLot(res,	false, ""), NormalizeLot(minLot,	false,	""));
	//}
	return(res);
}
//======================================================================

/*///===================================================================
	������: 2011.04.03
	---------------------
	��������:
		��������� ������ ������� ���. ������   
	---------------------
	���. �������:
		���
	---------------------
	����������:
		arr - ������ ������� ������
		level - �������
		wt -  ���, ������� ����������� �����
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
				if(!checkOrderByTicket(ot, CHK_MN, Symbol(), MN, -1)) continue; // ��������, ���� ����� ��� ��������
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
	������:	20110609_09

	���������:
	---------------
		2011.06.09 - [+] ������ ������������ �������, ���� �������� ��� ������.
/*///===================================================================

void startCheckOrders(){
//	Print("========================");
//	Print("startCheckOrders    ");
	double aParentOrders[1];
	ArrayInitialize(aParentOrders,-1);
	int dim = 0;
	
	int t = OrdersTotal();
	for(int tekOrder = 0; tekOrder <= OrdersTotal(); tekOrder++){ // �������� ������ aLevels[][][]
		if(!OrderSelect(tekOrder, SELECT_BY_POS, MODE_TRADES)) continue;	
			//---
		int    parent_ticket	=	OrderTicket();
		int    parent_type		=	OrderType();
		double parent_opr		=	OrderOpenPrice();
		string parent_comm		=	OrderComment();
		double parent_vol		=	OrderLots();
		int    parent_grid		=	getGrid(parent_ticket); 
			//---
		if(!checkOrderByTicket(parent_ticket, CHK_TYLESS, Symbol(), MN, 1)) continue; // ��������, ���� ����� ��� ��������)
		
			
			Print("   parent_ticket = ", parent_ticket);
			
			//---
		if(!isParentOrder(parent_ticket, MN, Symbol())) {
			// ���� ��� �������� �����, �� ��������, ����� �� ��������.
			// ���� �������� ���, �� � ������� ���� �������� � 
			// ��������������� ������������ ����������
			// �������� ������������� ������.
				
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
   ������: 2011.06.09
   ---------------------
   ��������:
      �������� ��������� ���������
   ---------------------   
   ��������:
      1. ��������� ������ ����� �� ������������ �������������
         1.1 - ����������� = "" ��� "@ip1"
         1.2 - � ��� ����� � ����� ������ ������� �������������
         
      2. ��� ������� ������������� ����������� ������ �������
      3. ��� ������� ������ ��������� �������� ������, 
         3.1 ���������� ��������� ����������� ������� �����
         
      4. ��������� �� � �� ��� ������� ������ �����
      
      5. �������� �������� ���������� �������, ���� ��� �� ������
         ������������ ������ �����.         
   ---------------------
   �������� ��������:
      �.�. �� ���������� ������������ �����, �� ����� ������� 
      ������ ������� ��� ����� ������.
      double aLevels[����� ������][��� ������][idx_price     ] = ���� ������.                  //������ ���� ������ ������������� ��� �������� ����� � ������� �� ������ � �������� �����
             aLevels[����� ������][��� ������][idx_vol       ] = ����� ������.                 //��� ������� ���� ������ ����� ������������� �������� �������� ����������
             aLevels[����� ������][��� ������][idx_tp_pip    ] = ���������� � �������.         //��� ������� ���� ������ ���������
             aLevels[����� ������][��� ������][idx_sl_pip    ] = �������� � �������.           //
             aLevels[����� ������][��� ������][idx_isMarket  ] = 1,0 - ����/��� �������� �����
             aLevels[����� ������][��� ������][idx_ParentType] = ��� ������������� ������      //��� ��� ����            
                  ��� ����������� ���������� ������������ ������ ����� ������������ 
                  ������� � ������������ ��������
                  � �������� ���� ���� ���� �������� �����.                                                                   
   ---------------------
   ���������:
		2011.04.08 - [+] ����� ������� �� ��� ������� �������.
		2011.06.08 - [+] ���� �� ���� �������� ��������� �� ���. ������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      ���

/*///-------------------------------------------------------------------
void checkParentOrder(double& aParentOrders[]){//int tekOrder){

	int dim = ArraySize(aParentOrders);
	for(int idx_PO = 0; idx_PO < dim; idx_PO++){
		
		int tekOrder = aParentOrders[idx_PO];
		
//		Print("==========================");
//		Print("idx_PO = ",idx_PO);
//		Print("tekOrder = ", tekOrder);
//		Print("==========================");
		
		double aLevels[][aL_AllTypes][aL_MAXSET]; // 1-� ��������� �������� ������ ��� �������

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
			// ������ ��� ����� ��������

			//============================================
			// ������������ ������������ �����
			//--------------------------------------------
			/* 	1. ��������� ������������ ���������� ������� �����
					1.1 ������������ ������� ����� ��������� ����������
						������� �������� �������, ���� �� ������������ 
						�������� ������. ���� ������������ ��������
						����� ����������� �������� � �������� ������� 

					1.2 �������� ������ ��������� ��� ���������� �������    
					1.3 �������������� ������ ��������� (-10000.00). //���� �� ����� ����������� �������� -10000 ��� �������� 

				2. �������� ������ � ���������� �������.   
					2.1 ��������� 0 ������� ���������� ������������� ������
					2.2 � ����� � 1 �� maxLevels ����������:
						2.21 ���� ������ ������������ �������� �����
						2.22 � ����� � 2 �� 10
						2.23 ��������� �� ����������, ��� ������� ���� ������ ������ ��������� 
						2.24 ����������, ���� �� �������� ������ ��� �������� ��������
						2.25 ��� ������� ������ ��������� ������, ���������� ������ ��� ������ 
							 � ���� �������.
				*/      
			//--------------------------------------------

			int maxaLevels = mgp_LimLevels;// ������������ ���������� ������� �����
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

				for(int idx_L = 1; idx_L < maxaLevels; idx_L++){                     // ���� �� �������. ������ ���������� ������� = 1. 
					// ����  �� ����� ������� >>>>>>>
					for(int idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){              // ���� �� ����� ������� �� ������� ������
						//2.23
						//{ ��������� �������� �������
							if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
								//---
								//{--- �������� ���������� ��� ��������� ������ 
									if(parent_type == OP_BUY && idx_oty != OP_BUYLIMIT){
										aLevels[idx_L][idx_oty][idx_send] = a_dINI;
										continue;
									}
									//---
									if(parent_type == OP_SELL && idx_oty != OP_SELLLIMIT){
										aLevels[idx_L][idx_oty][idx_send] = a_dINI;
										continue;
									}
								//}<<<< ���������� ��� ��������� ������	
							
								//{--- ������� ����� � ����. �������� ���. �����
								//    ��� �������� �������� �� ������: aL[<������ �������>][OP_LIMLEVEL][<������ ��������>]
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
									string sVolLevel = getLevelOpenedVol(	parent_ticket,	idx_L,	idx_oty,	MN, Symbol()); // ���������� ��������� � ���� "@vm1.6@vp3.2" vm - ����� ��������, vp - ����������
									//---
									aLevels[idx_L][idx_oty][idx_volMarket 	]	=	StrToDouble(	returnComment(sVolLevel	, "@vm_")	);
																					//------								
									aLevels[idx_L][idx_oty][idx_volPending	]	=	StrToDouble(	returnComment(sVolLevel	, "@vp_")	);
																					//------								
									//---
									// �������� ������������ ������, ���� ������ ����������, �� � �����
									double wasLots = StrToDouble(	returnComment(sVolLevel	, "@hl_"));
									
									if(wasLots >= aLevels[idx_L][idx_oty][idx_vol])
										aLevels[idx_L][idx_oty][idx_send]	=	-1.00;
									else	
										aLevels[idx_L][idx_oty][idx_send]	=	1.00;      
								}//if(idx_L < mgp_LimLevels && mgp_useLimOrders){   
							}//}<<<< ��������� �������� �������         
						
						//{ ��������� �������� �������
							if(idx_oty == OP_SELLSTOP || idx_oty == OP_BUYSTOP){
								//{ �������� ���������� ��� ��������� ������
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
									//{--- ���������� ����� ���������� ������� �������� �����
										int totalSOLevels = mgp_LimLevels; // ��� ��� -1. �.�. ���������� ���������� ������� �������� �����.
										// ���� > -1 - �� ���������� ��������� � ���������� ���������� �������
										if(SO_Levels > -1){
											totalSOLevels = SO_Levels;
										}
									//}---
								
									if(idx_L < totalSOLevels){
										//{--- ���������� ����. 1/-1 ��� ������
											int oD	=	1; // ��� �������� (���� ��������� ������ + �����)
											//---
											if(idx_oty == OP_SELLSTOP)	oD	=	-1;
										//}---
									
										if(idx_L >= SO_StartLevel-1 && idx_L <= SO_EndLevel-1){
											aLevels[idx_L][idx_oty][idx_send	]	=	1.00;
											aLevels[idx_L][idx_oty][idx_price	]	=	aLevels[idx_L][OP_LIMLEVEL][idx_price]
																					+ SPREAD*Point*oD;
											//{--- ���������� ����� ��������� ������
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
												//{--- ���������� ����� ��������� ������
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
										aLevels[idx_L][idx_oty][idx_send] = -1.00; // ������� ������ ��� ����������� ��� �����������
									}
									//---
								}else{
									aLevels[idx_L][idx_oty][idx_send] = -1.00;		// �� ����� ���������� ���������� �� ���� ������
								}
							}//}<<<< ��������� �������� �������
						
						//{ ��������� ���������� �������� �������
							if(idx_oty == OP_ADD_BUYLIMIT || idx_oty == OP_ADD_SELLLIMIT){
								if(add_useAddLimit){
									if(idx_L == add_LimitLevel-1){
										//{ �������� ���������� ��� ����������� ������
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
									
										//{--- ���������� ����. 1/-1 ��� ������
											oD	=	1; // ��� ���������� (���� ��������� ������ + ���. �������)
											//---
											if(idx_oty == OP_ADD_BUYLIMIT)	oD	=	-1;
										//}---
									
										aLevels[idx_L][idx_oty][idx_send]	=	1.00;
										aLevels[idx_L][idx_oty][idx_price]	=	aLevels[idx_L][OP_LIMLEVEL][idx_price]	+
																				add_Limit_Pip*Point*oD;
																				//---
										//{--- ���������� ����� ����������� ������
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
						
						//{ ��������� ���������� �������� �������
							if(idx_oty == OP_ADD_BUYSTOP || idx_oty == OP_ADD_SELLSTOP){
								if(add_useAddStop){
									if(idx_L == add_StopLevel-1){
										//{ �������� ���������� ��� ����������� ������
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
									
										//{--- ���������� ����. 1/-1 ��� ������
											oD	=	1; // ��� �������� (���� ��������� ������ + ���. �������)
											//---
											if(idx_oty == OP_ADD_SELLSTOP)	oD	=	-1;
										//}---
									
										aLevels[idx_L][idx_oty][idx_send]	=	1.00;
										aLevels[idx_L][idx_oty][idx_price]	=	aLevels[idx_L][OP_LIMLEVEL][idx_price]	+
																				add_Stop_Pip*Point*oD;
																				//---
										//{--- ���������� ����� ����������� ������
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
					
					}//<<<< ����  �� ����� �������         
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
			3. �������� ����� ������� ������������ ����������� ��� ������� ��������.
				3.1 � ����������� �� ����. ������������ ������ ���������� �� �� ��� ���� �������  		
		/*///===================================================
		
		int maxMarketLevel = getMaxMarketLevel(aLevels); // ������ ��������� � 0. 0 -������������
		
		//Print("maxMarketLevel = ", maxMarketLevel);
		//{--- � ����� �� ������� �������� �� � �� ��� ������� �����
			//	��������� �������� �������� �� �� � ��.
			//	� ��������, ������������� ����������� ����������� �������.
			// ������ �������� � ���������� ��� ������� ������ � ��� ��� ����.
			//	�������� ��������� ������ �� ���������� ������.
			int		grid_level	= NormalizeDouble(aLevels[idx_L][OP_LIMLEVEL][idx_gridLevel],0);
			double	maxMarketLevel_tp = 0;	
			
			//{--- 3.1a ��������� ������������ ������� �������� �����.
				// ������ ����� ����� ����. �������: 
				// ���������� ���� ���������� ���. ������
				// � � �-��� ������� ���� �� ����� ����������� 
				// ���� ���� ���������� ��������� ������, ���� ���� 
				// ��� ������.
				double maxLimitLevelPrice = getMaxLimitLevelPrice(aLevels, "-1");
				
				//{--- 3.1a.1 ��������� ���� � ���������� � ������� �� �������� �� ��
					parent_opr = NormalizeDouble(aLevels[0][0][idx_price], Digits);
					
					double	sl_parent_price	= -1; // ���� �� ��������
					int		sl_parent_pip	= -1; // ���������� �� �������� �� �� � �������
					
					//{--- 3.1a.1.1 ����������� �� ��� �������� � ����������� �� ��������.
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
			
			//{3.1 --- ��������� �� ��� �������� �����, ���� maxMarketLevel > 1
				if(maxMarketLevel > 0){
					double	maxlevel_op	=	NormalizeDouble(aLevels[maxMarketLevel][OP_LIMLEVEL][idx_price], Digits);
							
							maxMarketLevel_tp	=	calcTPPrice(maxlevel_op, parent_type, getTP(grid_level, maxMarketLevel));
							maxMarketLevel_tp	=	NormalizeDouble(maxMarketLevel_tp, Digits); 
				}
			//}
			
			//{3.2--- ��������� �� ��� ������������� ������
				if(libOrdersFunc_isThisOrderLive(parent_ticket)){
					// ������ �������� �����
					if(maxMarketLevel_tp == 0){
						// ����������� ������� �������� ������ ������� ��������
						int tp_pip = getTP(grid_level, 0);
						int sl_pip = sl_parent_pip; // �������� ����������� ��������� ��� ��������
						//---
						if(!ModifyOrder_TPSL_pip(thisOrderTicket, tp_pip, sl_pip, MN )){
							addInfo(" CAN'T Modify parent order: "+thisOrderTicket);
						}
					}
					//{--- 3.2.2 ����������� ��������, ��� ����������� �������-�������� ������
						if(maxMarketLevel > 0){
							//--- ����������� ������ ��. �� ��������� ����������� ����������
							if(!ModifyOrder_TPSL_price(thisOrderTicket, maxMarketLevel_tp, -1, MN)){
								addInfo(" CAN'T Modify parent order: "+thisOrderTicket);
								Print("maxMarketLevel_tp = ", maxMarketLevel_tp);
							}
						}
					//}
				}
			//}	
			
			//{3.3 --- ��������� �� � �� ������� �������
				int aLevelOrders[];
			
				for(idx_L = 1; idx_L < ArrayRange(aLevels,0); idx_L++){
					for(idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){
						int	dimLO = fillLevelOrders(aLevelOrders, parent_ticket, idx_L, idx_oty); // ���������� ������� ������� ���. ������

						//{--- 3.3.1 ��������� �� � �� ��� �������� �������
							if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
								
								tp_pip = 0;
								sl_pip = -1;
								double sl_price = -1;
								
								//{--- 3.3.1.1a ������ �� ��� ��������� ������
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
								
								//{--- 3.3.1.1 ���� ������� <= maxMarketLevel
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
								
								//{--- 3.3.1.2 ���� ������� > maxMarketLevel
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
						
						//{--- 3.3.2 ��������� �� � �� ��� �������� �������. ���� �������� ����� ��� ����������
							if(idx_oty == OP_BUYSTOP || idx_oty == OP_SELLSTOP){
								tp_pip = 0;
								sl_pip = 0;
								
								// � �������, ��� � ��� ������������ ������, 
								// �� ����� ����� ����� ������������ ������ ���������� ������
								
								
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
									sl_pip = getSL(LO_grid_level, 0); // ����� ������ ������������, ����� � ����������� ��.
									
									//---
									if(!ModifyOrder_TPSL_pip(LO_ticket, tp_pip, sl_pip, MN )){
										addInfo(" CAN'T Modify order: "+LO_ticket);
									}
								}
							}
						//}
						
						//{--- 3.3.3 ��������� ���������� �������
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
									sl_pip = getSL(1, 0); // ����� ������ ������������, ����� � ���������� ��.
									//---
									if(!ModifyOrder_TPSL_pip(LO_ticket, tp_pip, sl_pip, MN )){
										addInfo(" CAN'T Modify order: "+LO_ticket);
									}
								}
							}
						//}
					
						//{--- 3.3.4 ��������� ���������� �������� �������
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
									sl_pip = getSL(1, 0); // ����� ������ ������������, ����� � ���������� ��.
									//---
									if(!ModifyOrder_TPSL_pip(LO_ticket, tp_pip, sl_pip, MN )){
										addInfo(" CAN'T Modify order: "+LO_ticket);
									}
								}
							}
						//}
					
						//{3.4 --- ����������� ������� �� ������������ ������
							/*///===========================
								��������:
									1.	��������� ����� ����� ����� ��������� �� ������ ������ �����.
											��������� ����� - (����� �������� + ����� ����������)
											����������� .
									2.	������ ����� �������� �� ���-�� ������� � ����������� �� TWISE_LOTS.
									3.	�������� ��� ������.
									4.	�� ������� ������������� ������ ������� ���������� � ���� �������.
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
								
								//{--- 3.4.1.1 ������ �� � �� � ������� ��� �������� �������
									if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
										tp_pip 	= getTP(grid_level, idx_L);
										int cmd = idx_oty;
										pending_comm = pending_comm+"@g"+grid_level+"@w"+idx_oty;
									}
								//}
								
								//{--- 3.4.1.2 ������ �� � �� � ������� ��� �������� �������
									if(idx_oty == OP_BUYSTOP || idx_oty == OP_SELLSTOP){
										tp_pip	=	getTP(grid_level+1, 1);
										cmd		=	idx_oty; 
										pending_comm = pending_comm+"@g"+(grid_level+1)+"@ip1"+"@w"+idx_oty;
									}
								//}
								
								//{--- 3.4.1.3 ������ �� � �� � ������� ��� ���������� �������� �������
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
								
								//{--- 3.4.1.4 ������ �� � �� � ������� ��� ���������� �������� �������
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
	������: 2011.04.10
	---------------------
	��������:
		����������� �� �������� ������������ �������
		� ������� ������ ���������� ������, ��� ������� 
		��� �� ������ ��������� ������, �������������� ��� (���. ������) �����
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
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
				if(isGridLive(ot, MN)) continue; // ����� ��� �����, ������ ������� ����� ��� ������ :)
		//==========
		// ����� ������. ����� �����.
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
		initLibs(); // �������������� ����������   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit(){
//----
   deinitInfo(); // ������� �������, ��������� addInfo();
//----
   return(0);
  }


int res = 0;
//{{-----------------------
int start(){
	res++;
	//Print("========= START ===== ", res);
   if(!isDone){ 
      return(0); // ���� �� ��������� ���������� �-��� start(), ����� �������
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
//���������� ���������� ������ � �������� �� ����
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