//+------------------------------------------------------------------+
//|                                                          eLT.mq4 |
//|                                         ���������������� artamir |
//|                                                artamir@yandex.ru |
//+------------------------------------------------------------------+ 

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
// ��������� ������� �������

#define		a_dINI				-10000.00	// �������� ������������� ������� (�����) 

// �����������
#define		aL_MAXL				30			// 1-� ���������
#define		aL_MAXTY			10			// 2-� ��������� 
#define		aL_AllTypes			21			// 2-� ��������� 
#define		aL_MAXSET			10			// 3-� ���������

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


//======================================================================

//---- input parameters
extern         double    TWISE_LOTS        =     20;     // ������� ������� ��� ���������� ���������� �������� ������ => ��������� ��������
extern         int       MN                =     0;      // ����� � ������� ����� �������� ��������. ����� ������ �������������� �� ����� 
extern string MGP       = "===== MAIN GRID PROP >>>>>>>>>>>>>>>>>";
extern         int       mgp_Target        =     25;    //������������� �������� ������� (���������� �������������� useAVG_H1 ��� useAVG_D)
extern         int       mgp_TargetPlus    =      0;    //���������� ������� � ����������� �� ������ �� TargetPlus �������

extern         int       mgp_TP_on_first   =     25;    //���. ������� ��� ����������� �� �� ������������ �����, ����� ��� ����������� �������� �������
extern         int       mgp_TP            =     50;    //���. ������� ��� ����������� �� �� ����������� ������ �����. ������ �� ���������� ������������ ������
extern         int       mgp_TPPlus        =      0;    //���������� �� �� ������ �� �������� ���������� �������.

extern         int       mgp_SL_on_first   =      0;    // �������� �� ������ �����
extern         bool      mgp_needSLToAll   =  false;    // ���������� �� �� ��� ����� �� ���������� ������ ��� �������� �� ������ �����
extern         int       mgp_SL            =      0;    // ������������ ��� �������

extern         bool      mgp_useLimOrders  =   true;    // ��������� ��������� ������������ �������� �����
extern         int          mgp_LimLevels  =      5;    // ���������� ������� �������� �����, ������� ������������ �����

extern         double    mgp_plusVol       =    0.0;    // ���������� ������ ����. ������ �� �������� <mgp_plusVol> (+)
extern         double    mgp_multiplyVol   =      2;    // ���������� ������ ����. ������ � <mgp_multiplyVol> ���   (*)


extern string ADD_DESC  = "=========== Adding lim. order as parent";
extern         bool       add_useAddLimit          =	false		;	// ��������� ��������� ���������� ���������� �������� ����� ��� ������������
extern         int        	add_LimitLevel              =	3		;	// ������� �����, �� �������� ����� ���������� ������ ���� ����������� ������
extern         int        	add_Limit_Pip               =	15		;	// ������� ������� �� ������ ����� ��������� ���������� �����
extern         bool       	add_Limit_useLevelVol    =	true		;	// ��������� ��������� ������������ ��������� <add_Limit_multiplyVol> ����� ����� �������������� <add_Limit_fixVol>  
extern         double     		add_Limit_multiplyVol       =	1	;	// ����. ��������� ������ ������ <add_LimitLevel> �������� ����� �������� �������
extern         double     		add_Limit_fixVol            = 0.1	;	// ������������� ����� ����������� ������
																		// ����������: ����� ��� ����������� ������ ������������� �� �������� <mgp_> 

extern   string AL_DESC = "=========== AUTO_LOT SETUP ==========";
extern         double     al_LOT_fix           =    0.1;         // ������������� ��������� ���
extern            bool    al_needAutoLots      =  false;         // ��������� ���������� ������ ������������� ������
                     bool    al_useMarginMethod      = true;     // ��������� ������������ ����� ������
extern               double  al_DepositPercent       =    1;     // ������� �� �������� ��� ������� ������� ������                     
extern string MGP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";

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
extern         double        SO_SL						=   1.5		;	// �������� ���������� ����. ���������
extern string SOP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"	;	


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
bool	isDone			= true	;	// ���������� ���� ��������� ������� start()
int		SPREAD			= 0		;	// ����� �������� ����, �� ������� ������� ��������
string	INIFile_ord		= ""	;	// ��� ���� �������
string	INIFile_name	= ""	;	// �������� �������� �����
string	INIFile_folder	= ""	;	// ���� ������������ ������ ���������
//======================================================================

/*///==============================================================
      ������: 2011.03.24
      ------------------
      ��������:
         ������������� � �������� ������ ���������� ������� ������
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
   ������: 2011.04.01
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
		if(grid_level == 1 && level == 0){
			return(mgp_TP_on_first);
		}else{
			if(grid_level == 1 && level > 0){
				return(mgp_TP + (mgp_TPPlus * level-1));
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
   ������: 2011.03.29
   ---------------------
   ��������:
      ���������� ������� �������� ������� � ����������� 
      �� �������� ��������� � �������� ����������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      condition    = ���������� ���������
      ifTrue       = �������� � ������ condition = ������
      ifFalse      = �������� � ������ condition = ����

/*///-------------------------------------------------------------------
int getTarget(int grid_level, int level){
   // �������� �� 1-� ���������
      if(grid_level == 1){
         return(mgp_Target * level);
      }
   //<<<<<<<
   // ��������� > 1
      if(grid_level >= 2){
         //������ � ��� �������� �������� �����
         //��������: 
            // �������� ������ ��� �������� ����� ���� ��� ����
            // ��� ����: ������ ���. ����� * ���������
            //    ���� �������� ������� ��� ��� ������������ �����, ����� ��� ���� = 1;
            // ��� �����: ���������� �������� � ���������� ��������
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
int getMaxMarketLevel(double arr[][][]){
   double res = 0;
		for(int idx_L = 0; idx_L < ArrayRange(arr, 1); idx_L++){
			for(int idx_oty = 0; idx_oty <= 5; idx_oty++){ // ���� �� �������� � �������� �������
				if(arr[idx_L][idx_oty][idx_isMarket] == 1)
					res = MathMax(res , idx_L);	
			}
		}
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
				if(!checkOrderByTicket(ot, CHK_MN, "", MN, -1)) continue; // ��������, ���� ����� ��� ��������
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
   ������: 2011.03.24
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
   ���. �������:
      ���
   ---------------------
   ����������:
      ���

/*///-------------------------------------------------------------------
void startCheckOrders(){

	double aLevels[][aL_AllTypes][aL_MAXSET]; // 1-� ��������� �������� ������ ��� �������

	int t = OrdersTotal();
	for(int i = 0; i <= t; i++){ // �������� ������ aLevels[][][]
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
				// ���� ��� �������� �����, �� ��������, ����� �� ��������.
				// ���� �������� ���, �� � ������� ���� �������� � 
				// ��������������� ������������ ����������
				// �������� ������������� ������.
				
				if(parent_type <= 1){
					//--- � ��� �������� �����
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
						continue;	// ���� �������� �����, ����� ��������� ���� �� �������
					}
				}else{
					continue;      
				}	
			}	
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
			aLevels[0][0][idx_ParentType  ]  = OrderType();

			for(int idx_L = 1; idx_L < maxaLevels; idx_L++){                     // ���� �� �������. ������ ���������� ������� = 1. 
				// ����  �� ����� ������� >>>>>>>
				for(int idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){              // ���� �� ����� ������� �� ������� ������
					//2.23
					//{ ��������� �������� �������
						if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
							//---
							//{--- �������� ���������� ��� ��������� ������ 
								if(parent_type == OP_BUY && idx_oty != OP_BUYLIMIT){
									aLevels[idx_L][idx_oty][idx_send] = -1.00;
									continue;
								}
								//---
								if(parent_type == OP_SELL && idx_oty != OP_SELLLIMIT){
									aLevels[idx_L][idx_oty][idx_send] = -1.00;
									continue;
								}
							//}<<<< ���������� ��� ��������� ������	
						
							//{--- ������� ����� � ����. �������� ���. �����
							//    ��� �������� �������� �� ������: aL[<������ �������>][OP_LIMLEVEL][<������ ��������>]
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
								string sVolLevel = getLevelOpenedVol(	parent_ticket,	idx_L,	idx_oty,	MN); // ���������� ��������� � ���� "@vm1.6@vp3.2" vm - ����� ��������, vp - ����������
								//---
								aLevels[idx_L][idx_oty][idx_volMarket 	]	=	StrToDouble(	returnComment(sVolLevel	, "@vm_")	);
																				//------								
								aLevels[idx_L][idx_oty][idx_volPending	]	=	StrToDouble(	returnComment(sVolLevel	, "@vp_")	);
																				//------								
								//---
								aLevels[idx_L][idx_oty][idx_send 		]	=	1.00;      
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
								
									if(idx_L >= SO_StartLevel-1 && idx_L < SO_EndLevel-1){
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
										sVolLevel	=	getLevelOpenedVol(parent_ticket, idx_L, idx_oty, MN);
										//---
										aLevels[idx_L][idx_oty][idx_volMarket ] = StrToDouble(	returnComment(sVolLevel,"@vm_")	);
										aLevels[idx_L][idx_oty][idx_volPending] = StrToDouble(	returnComment(sVolLevel,"@vp_")	);
									
									}
								}else{
									aLevels[idx_L][idx_oty][idx_send] = -1.00; // ������� ������ ��� ����������� ��� �����������
								}
								//---
							}else{
								aLevels[idx_L][idx_oty][idx_send] = -1.00;		// �� ����� ���������� ���������� �� ���� ������
							}
						}//}<<<< ��������� �������� �������
					
					//{ ��������� ���������� �������
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
								
									sVolLevel	=	getLevelOpenedVol(parent_ticket, idx_L, idx_oty, MN);
									//---
									aLevels[idx_L][idx_oty][idx_volMarket ] = StrToDouble(	returnComment(sVolLevel,"@vm_")	);
									aLevels[idx_L][idx_oty][idx_volPending] = StrToDouble(	returnComment(sVolLevel,"@vp_")	);
								}
							}
						}
					//}
				}//<<<< ����  �� ����� �������         
			}
	}	

	/*///===================================================
		3. �������� ����� ������� ������������ ����������� ��� ������� ��������.
		    3.1 � ����������� �� ����. ������������ ������ ���������� �� �� ��� ���� �������  		
	/*///===================================================
	
	int maxMarketLevel = getMaxMarketLevel(aLevels); // ������ ��������� � 0. 0 -������������
	
	//{--- � ����� �� ������� �������� �� � �� ��� ������� �����
		//	��������� �������� �������� �� �� � ��.
		//	� ��������, ������������� ����������� ����������� �������.
		// ������ �������� � ���������� ��� ������� ������ � ��� ��� ����.
		//	�������� ��������� ������ �� ���������� ������.
		int		grid_level	= NormalizeDouble(aLevels[idx_L][OP_LIMLEVEL][idx_gridLevel],0);
		double	maxMarketLevel_tp = 0;	
		//{3.1 --- ��������� �� ��� �������� �����, ���� maxMarketLevel > 1
			if(maxMarketLevel > 0){
				double	maxlevel_op	=	NormalizeDouble(aLevels[maxMarketLevel-1][OP_LIMLEVEL][idx_price], Digits);
						
						maxMarketLevel_tp	=	calcPrice(maxlevel_op, parent_type, getTP(grid_level, maxMarketLevel));
			}
		//}
		//{3.2--- ��������� �� ��� ������������� ������
			if(thisOrderTicket == parent_ticket){
				// ������ �������� �����
				if(maxMarketLevel_tp == 0){
					// ����������� ������� �������� ������ ������� ��������
					int tp_pip = getTP(grid_level, 0);
					int sl_pip = 0; // �������� ����������� ��������� ��� ��������
					//---
					if(!ModifyOrder_TPSL_pip(thisOrderTicket, tp_pip, sl_pip, MN )){
						addInfo(" CAN'T Modify order: "+thisOrderTicket);
					}
				}
			}
		//}	
		
		//{3.3 --- ��������� �� � �� ������� �������
			int aLevelOrders[];
		
			for(idx_L = 1; idx_L < ArrayRange(aLevels,1); idx_L++){
				// ��������: 2011.03.31
				for(idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){
					int	dimLO = fillLevelOrders(aLevelOrders, idx_L, idx_oty); // ���������� ������� ������� ���. ������
					//{--- 3.3.1 ��������� �� � �� ��� �������� �������
						if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
							
							tp_pip = 0;
							sl_pip = 0;
							
							//{--- 3.3.1.1 ���� ������� <= maxMarketLevel
								if(idx_L <= maxMarketLevel){
									tp_pip	=	getTP(grid_level, maxMarketLevel);
								}
							//}
							
							//{--- 3.3.1.2 ���� ������� > maxMarketLevel
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
					
					//{--- 3.3.2 ��������� �� � �� ��� �������� �������. ���� �������� ����� ��� ����������
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
   if(!isDone) 
      return(0); // ���� �� ��������� ���������� �-��� start(), ����� �������
   else
      isDone = false;
   //------
   startCheckOrders(); 
   //---
   isDone = true;
   return(0);
}
//========================}} 