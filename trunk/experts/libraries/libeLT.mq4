//+------------------------------------------------------------------+
//|                                                       libeLT.mq4 |
//|                      Copyright � 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"

#property library

#include <libHelpFunc.mqh>
#include <libOrdersFunc.mqh>
#include <libINIFileFunc.mqh>

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
#define  libNAME "libOrdersFunc"

#define  OP_SLTP   200
#define  OP_SORD   100

#define  CHK_SMBMN    500
#define  CHK_SMB      700
#define  CHK_MN       600
#define  CHK_TYMORE   400
#define  CHK_TYLESS   300
#define  CHK_TYEQ     200

string   file_ord =  "";

//===================================================
void libeLT_setFile_ord(string str){
   file_ord = str;
}

/*///==================================================================
// ������: 2011.03.24
//---------------------
// ��������:
// ���������� ������ ���������� ������ :)
//---------------------
// ����������:
//    ���
/*///-------------------------------------------------------------------
string libeLT_Ver(){
   return("v1.0");
}
//======================================================================



/*///===================================================================
   ������: 2011.03.28
   ---------------------
   ��������:
      ���������� ������� ����������� �����
   ---------------------
   ��������:
      1. ���������, "@g"
         1.1 ���� > -1 ����� ���������� �������
         1.2 ���� == -1 ����� ��������� ���� �������
            ���� [ticket]
                     grid = <x>
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      ticket - ������������ �����

/*///-------------------------------------------------------------------
int getGrid(int ticket){

   OrderSelect(ticket,SELECT_BY_TICKET);
   
   int res = 1;
      res = StrToInteger(returnComment(OrderComment(),"@g"));
      
      if(res == -1){ // �������� ���� ������� ��� 
         string sGrid = ReadIniString  (file_ord, ticket, "grid", "-1");
         int iGrid = StrToInteger(sGrid);
         return(iGrid);
      }
   return(res);
}
//======================================================================

/*///===================================================================
   ������: 2011.03.29
   ---------------------
   ��������:
      ���������� ��������� ���� � ����������� �� ���� ������,
      ������ � �������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      condition    = ���������� ���������
      ifTrue       = �������� � ������ condition = ������
      ifFalse      = �������� � ������ condition = ����

/*///-------------------------------------------------------------------
double  calcPrice(double parent_pr, int parent_type, int pip){
	double pr = 0;
	if(parent_type == OP_BUY){
		pr	=	NormalizeDouble(parent_pr - pip*Point, Digits);
	}else{
		if(parent_type == OP_SELL){
			pr	=	NormalizeDouble(parent_pr + pip*Point, Digits);
		}	
	}
   
	return(pr);
}
//======================================================================

/*///===================================================================
   ������: 2011.04.05
   ---------------------
   ��������:
      ���������� ��������� ����  �� � ����������� �� ���� ������,
      ������ � �������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      condition    = ���������� ���������
      ifTrue       = �������� � ������ condition = ������
      ifFalse      = �������� � ������ condition = ����

/*///-------------------------------------------------------------------
double  calcTPPrice(double pr, int type, int pip){
	double calc_pr = 0;
	if(type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT){
		calc_pr	=	NormalizeDouble(pr + pip*Point, Digits);
	}else{
		if(type == OP_SELL || type == OP_SELLLIMIT || type == OP_SELLSTOP){
			calc_pr	=	NormalizeDouble(pr - pip*Point, Digits);
		}	
	}
   
	return(calc_pr);
}
//======================================================================


/*///===================================================================
   ������: 2011.03.29
   ---------------------
   ��������:
      ���������� ������� ������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      ���

/*///-------------------------------------------------------------------
int getOrderLevel(int ticket){
   int res = -1;
   //---------------
   if(!OrderSelect(ticket,SELECT_BY_TICKET)) return(-1);
   //---
   res = StrToInteger(returnComment(OrderComment(),"@l"));
   //---
   if(res == -1){
      res = StrToInteger(ReadIniString  (file_ord, ticket, "level", "-1"));
   }  
   //---------------
   return(res);
}
//======================================================================
/*///===================================================================
   ������: 2011.03.30
   ---------------------
   ��������:
      ���������� ������������ ����� ��� �������� ������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      ticket - ����� ������, ��� �������� ���������� ��������

/*///-------------------------------------------------------------------
int getParentByTicket(int ticket){
    int res = -1;
    //---------------
        if(!OrderSelect(ticket,SELECT_BY_TICKET)) return(-1);
        //---
        res = StrToInteger(returnComment(OrderComment(),"@p"));
        //---
        if(res == -1){
            res = StrToInteger(ReadIniString  (file_ord, ticket, "parent", "-1"));
        }  
    //---------------
    return(res);
    
}
//======================================================================
/*///===================================================================
   ������: 2011.03.29
   ---------------------
   ��������:
      ���������� ��������� �������� - �������� �� ������� ������� 
      ��������. �.�. ���� �� �������� ������ ����� ������      
   ---------------------
   ���. �������:
        .checkOrderByTicket()
        .getOrderLevel()
        .getParentByTicket()
   ---------------------
   ����������:
      ���

/*///-------------------------------------------------------------------
int isMarketLevel(int parent_ticket, int level, int magic){

   int res = -1;
   
      int t = OrdersTotal();
      for(int i = t; i >= 0; i--){
         int      ot    = OrderTicket();
         int      oty   = OrderType();
         string   ocomm = OrderComment(); 
         //==============
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
            //---
            if(!checkOrderByTicket(ot, CHK_TYLESS, "", magic, 1)) continue; // ��������, ���� ����� ��� ��������
            //---
            int olevel = getOrderLevel(ot);
            //---
            if(olevel != level) continue;
            //---
            if(getParentByTicket(ot) != parent_ticket) continue;
         //==============      
         res = 1;
      }
   
   return(res);
}
//======================================================================
/*///===================================================================
    ������: 2011.03.30
    ---------------------
    ��������:
        ����������, ����� ��� �������� ��� � 
        ������ ��� ��� �����������
    ---------------------
    ���. �������:
        ���
    ---------------------
    ����������:
        ���
/*///-------------------------------------------------------------------
int getWasType(int ticket){
    int res = -1;
    //---------------
    if(!OrderSelect(ticket,SELECT_BY_TICKET)) return(-1);
    //---
    res = StrToInteger(returnComment(OrderComment(),"@w"));
    //---
    if(res == -1){
        res = StrToInteger(ReadIniString  (file_ord, ticket, "wasType", "-1"));
    }  
    //---------------
    return(res);    
}
//======================================================================
/*///===================================================================
   ������: 2011.03.30
   ---------------------
   ��������:
      ���������� ��������� � ���� "@vm1.6@vp3.2" 
            vm - ����� ��������, 
            vp - ����������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      ���

/*///-------------------------------------------------------------------
string getLevelOpenedVol(int parent_ticket, int level, int type, int magic){
    string res = "";

    double vm = 0;      // ����� �������� �������
    double vp = 0;      // ����� ���������� �������
    
    int t = OrdersTotal();
    for(int i = t; i >= 0; i--){
        //==============
			//---
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
            //---
			int      ot     = OrderTicket() ;
			int      oty    = OrderType()   ;
			string   ocomm  = OrderComment(); 
			double   ol     = OrderLots()   ;
			//---
            if(!checkOrderByTicket(ot, CHK_MN, "", magic, -1)) continue; // ��������, ���� ����� ��� ��������
            //---
            int olevel = getOrderLevel(ot);
            //---
            if(olevel != level) continue;
            //---
            if(getParentByTicket(ot) != parent_ticket) continue;
            //--- ��������, ����� �������� ������ ����� ���� ��� ��������� ���� ������
                if(type == OP_BUYLIMIT)
                    int MarketType = OP_BUY;
                //----    
                if(type == OP_SELLLIMIT)
                    MarketType = OP_SELL;
                //----
                if(type == OP_BUYSTOP)
                    MarketType = OP_BUY;
                //----
                if(type == OP_SELLSTOP)
                    MarketType = OP_SELL;            
                //----
            //----
            int wasType = getWasType(ot); // ��������� ��� ������, ������� ���
            if(wasType != type) continue;
        //==============      
        if(oty <= 1){
            vm = vm+ol;
        }else{
            if(oty >= 2){
                vp = vp+ol;
            }
        }
        
    }
    //---
    res = StringConcatenate("@vm_",DoubleToStr(vm,2),"@vp_",DoubleToStr(vp,2));
    return(res);    
}
//======================================================================