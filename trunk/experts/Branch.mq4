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
#define  OP_SLTP   200
#define  OP_SORD   100

#define  CHK_SMBMN    500
#define  CHK_SMB      700
#define  CHK_MN       600
#define  CHK_TYMORE   400
#define  CHK_TYLESS   300
#define  CHK_TYEQ     200

#define  EXP_NAME   "eLT 10.x"

//===================
// ��������� ������� �������

#define a_dINI     -10000.00 // �������� ������������� ������� (�����) 

// �����������
#define aL_MAXL     30 // 1-� ���������
#define aL_MAXTY    10 // 2-� ��������� 
#define aL_MAXSET   10 // 3-� ���������

//===================
// ���� ���������� �������
#define OP_ADD_BUYLIMIT    6  // ���������� ��������
#define OP_ADD_SELLLIMIT   7  // ���������� ���������
#define OP_ADD_BUYSTOP     8  // ���������� �������
#define OP_ADD_SELLSTOP    9  // ���������� ��������


#define idx_price       0
#define idx_vol         1
#define idx_tp_pip      2
#define idx_sl_pip      3
#define idx_ParentType  4
#define idx_isMarket    5

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
extern         bool       add_useAddLimit          =  false;    // ��������� ��������� ���������� ���������� �������� ����� ��� ������������
extern         int        add_LimitLevel              =   3;    // ������� �����, �� �������� ����� ���������� ������ ���� ����������� ������
extern         int        add_Limit_Pip               =  15;    // ������� ������� �� ������ ����� ��������� ���������� �����
extern         bool       add_Limit_useLevelVol    =   true;    // ��������� ��������� ������������ ��������� <add_Limit_multiplyVol> ����� ����� �������������� <add_Limit_fixVol>  
extern         double     add_Limit_multiplyVol       =   1;    // ����. ��������� ������ ������ <add_LimitLevel> �������� ����� �������� �������
extern         double     add_Limit_fixVol            = 0.1;    // ������������� ����� ����������� ������


extern   string AL_DESC = "=========== AUTO_LOT SETUP ==========";
extern         double     al_LOT_fix           =    0.1;         // ������������� ��������� ���
extern            bool    al_needAutoLots      =  false;         // ��������� ���������� ������ ������������� ������
                     bool    al_useMarginMethod      = true;     // ��������� ������������ ����� ������
extern               double  al_DepositPercent       =    1;     // ������� �� �������� ��� ������� ������� ������                     
extern string MGP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";

extern string SOP       = "===== STOP ORDERS PROP >>>>>>>>>>>>>>>";
extern         bool     SO_useStopLevels      =    false;       // ��������� ��������� ������������ ����������� �������� �������
extern         int             SO_Levels           =  -1;       // ���������� ������� ��������� � �������� �������� �������, ���� ������ ��������� �������� �������

extern         int             SO_StartLevel       =   2;       // �������, � �������� ������������ �������� ������ ��� ������� ��������. ������������ ����� ����� ������ 1
extern         bool            SO_useLimLevelVol   =   true;    // ��������� ������������ ����� �������� ������ �������� ����� ��� ������� ������ ��������� ������
extern         double          SO_LimLevelVol_Divide   = -1;    // ������� ������ ���. ������ ��� ���������� ������ ����. �� ������ LevelVolParent
                                                                // -1 ������������ ������� �������������      
extern         int             SO_EndLevel         =   2;       // ��������� <SO_useLimLevelVol> � <SO_LimLevelVol_Divide> ����� �������������� �� ����� ������ ������������

extern         int             SO_ContinueLevel    =   5;       // ������� ���� ������� � �� SO_Levels ����� ���������� ������������ �������� ������.
extern         double          SO_ContLevelVol_Divide  =  1;    // ��� ������� ������������ ��������� �������� ������ ���. ������ �������� ������.

extern    string  SOTGP = "=========== SO_TARGET, SO_TP, SO_SL ==";
extern         bool     SO_useKoefProp        =  true;          // ��������� ��������� ������������ ��������� �������, �� � �� ��� �������� ������� � �������� ����. ��������� 
                                                                // ��� �������� ���������� �����.
extern         double        SO_Target        =   1.5;          // � ����������� �� <SO_useKoefProp> ����� ��������� �������� <������� ����. �����> * SO_Target, ���� ����. 
                                                                // �������� � �������, ����������� � ������ �����, ��� ����� �������� �����.
extern         double        SO_TP            =   1.5;          // �������� ���������� ����. ���������
extern         double        SO_SL            =   1.5;          // �������� ���������� ����. ���������
extern string SOP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";


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
bool     isDone         = true; // ���������� ���� ��������� ������� start()
string   INIFile_ord    = "";   // ��� ���� �������
string   INIFile_name   = "";   // �������� �������� �����
string   INIFile_folder = "";   // ���� ������������ ������ ���������
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
int getTarget(int grid_level){
   // �������� �� 1-� ���������
      if(grid_level == 1){
         return(mgp_Target);
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
               return(mgp_Target * SO_Target);
            }else{
               return(SO_Target);
            }      
      }
   //<<<<<<<
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
   
   double aLevels[][aL_MAXTY][aL_MAXSET]; // 1-� ��������� �������� ������ ��� �������

   int t = OrdersTotal();
   for(int i = 0; i <= t; i++){
      //=================
      if(!OrderSelect(i, SELECT_BY_POS,MODE_TRADES)) continue;
      //----
      int    parent_ticket = OrderTicket();
      int    parent_type   = OrderType();
      double parent_opr    = OrderOpenPrice();
      string parent_comm   = OrderComment();
      double parent_vol    = OrderLots();
      
      int    parent_grid   = getGrid(parent_ticket); 
      //------   
      if(parent_grid <= 1) parent_grid = 1;
      //------
      if(!isParentOrder(OrderTicket(), MN)) continue;      
      //=================
      // ������ ��� ����� ��������
      
      //============================================
      // ������������ ������������ �����
      //--------------------------------------------
         /* 1. ��������� ������������ ���������� ������� �����
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
      
      for(int idx_L = 1; idx_L < maxaLevels; idx_L++){                     // ���� �� �������
         // ����  �� ����� ������� >>>>>>>
         for(int idx_oty = 2; idx_oty < aL_MAXTY; idx_oty++){              // ���� �� ����� ������� �� ������� ������
            //2.23
            // ��������� �������� �������
               if(idx_oty == OP_BUYLIMIT || idx_oty == OP_SELLLIMIT){
                  if(mgp_useLimOrders){ // �������� ���������� �������� �������� �������
                     if(idx_L < mgp_LimLevels){
                        int target = getTarget(parent_grid);
                     
                        //aLevels[idx_L][idx_oty][idx_price] = calcPrice(parent_opr, idx_L, idx_oty);                     
                     }   
                  }     
               }
            //<<<< ��������� �������� �������         
         }
         // ����  �� ����� ������� <<<<<<<
      }
   }
}
//======================================================================

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
      INIFile_name   = StringConcatenate(EXP_NAME,"_",AccountNumber(),"_",Symbol(),"_",MN);
      INIFile_folder = StringConcatenate(TerminalPath(),"/experts/files/",EXP_NAME);
      INIFile_ord    = StringConcatenate(INIFile_folder,INIFile_ord,".ord");

      initLibs(); // �������������� ����������   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
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