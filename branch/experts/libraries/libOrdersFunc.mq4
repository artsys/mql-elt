//+------------------------------------------------------------------+
//|                                                libOrdersFunc.mq4 |
//|                      Copyright � 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"
#property library

#include <libHelpFunc.mqh>
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

string   EXP_NAME =   "";
//======================================================================
string   file_ord =  "";

void libOrders_setFile_ord(string str){
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
string libOrders_Ver(){
   return("v1.0");
}
//======================================================================

/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ���������, �������� �� ����� ������������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      ticket       = ����� ������������ ������
      magic        = ����� ���������
/*///-------------------------------------------------------------------
bool  isParentOrder(int ticket, int magic){
   //================
      if(!checkOrderByTicket(ticket, CHK_TYLESS, "", magic, 1)) return(false); // ��������, ���� ����� ��� ��������
      //----
      if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false); //�� ������ ������
   //================
   // ���������� ��������� ��� ���� ������������ �������
   int isParent = StrToInteger(ReadIniString(file_ord, ticket, "isParent", "-1"));
   //----
   if(isParent == -1){
      if(OrderComment() == "" || StrToInteger(returnComment(OrderComment(),"@i")) > -1)
         return(true);
      else
         return(false);   
   }
}
//======================================================================

/*///===================================================================
	������: 2011.03.31
	---------------------
	��������:
		���������, �������� �� ������������ ����� �����
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
/*///-------------------------------------------------------------------
bool isParentLive(int ticket){
	bool res = false;
		//{==========
			if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
			//---
		//}
		
		string comm = OrderComment();
		
		int parent_ticket = StrToInteger(returnComment(comm, "@p"));
		if(!OrderSelect(parent_ticket, SELECT_BY_TICKET)){
			parent_ticket = StrToInteger(ReadIniString(file_ord, ticket, "parent", "-1"));
			if(!OrderSelect(parent_ticket,SELECT_BY_TICKET)){
				return(false);
			}else{
				if(OrderCloseTime() != 0){
					return(false);
				}else{
					return(true);
				}
			}
		}else{
			if(OrderCloseTime() == 0) 
				return(true);
			else
				return(false);
		}
	return(res);
}
//======================================================================

/*///===================================================================
	������: 2011.03.31
	---------------------
	��������:
		���������� �������� �� �������
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
/*///-------------------------------------------------------------------
int getParentInHistory(int ticket){
	int res = -1;
		//{==========
			if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(-1);
			//---
		//}
		
		string comm = OrderComment();
		
		int parent_ticket = StrToInteger(returnComment(comm, "@p"));
		if(!OrderSelect(parent_ticket, SELECT_BY_TICKET)){
			parent_ticket = StrToInteger(ReadIniString(file_ord, ticket, "parent", "-1"));
			if(!OrderSelect(parent_ticket,SELECT_BY_TICKET)){
				return(-1);
			}else{
				return(parent_ticket);
			}
		}else{
			return(parent_ticket);
		}
	return(res);
}
//======================================================================

/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ��������� ����� �� �������� ����������
   ---------------------
   ���. �������:
      ���
   ---------------------
   ����������:
      ticket       = ����� ������
      ORD_CHK      = ����� ��������
      sy           = �������� ����(�����������)
      MN           = ����� �����
      ty           = ��� ������
/*///-------------------------------------------------------------------
bool checkOrderByTicket(int ticket, int ORD_CHK, string sy="", int MN=0, int ty = -1){
   bool res = false;
   //==================
		if(!OrderSelect(ticket,SELECT_BY_TICKET)) return(false);
		//-----
		if(ORD_CHK <= CHK_SMB){
			if(OrderSymbol() != Symbol())          return(false);
			//-----
			if(ORD_CHK <= CHK_MN){
				if(OrderMagicNumber() != MN)        return(false);
				//----
				if(ORD_CHK == CHK_TYMORE){
					if(OrderType() < ty)             return(false);
				}//if(ORD_CHK <= CHK_TYMORE){
				//----
				if(ORD_CHK == CHK_TYLESS){
					if(OrderType() > ty)             return(false);
				}//if(ORD_CHK <= CHK_TYLESS){
				//----
				if(ORD_CHK == CHK_TYEQ){
					if(OrderType() != ty)            return(false);
				}//if(ORD_CHK <= CHK_TYEQ){
				//----
			}//if(ORD_CHK <= CHK_MN){   
			//-----
		}//}} if(ORD_CHK <= CHK_SMB){   
   //==================
   return(true);  // ������ ��������, ������ ���
}
//======================================================================

/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ������ �� �������� ��������� ������ � ������������ �� � �� � ������� 
   ---------------------
   ���. �������:
      ._OrderSend()-��������� ����� ��� �� � ��
      ._OrderModify() - ������������� �� � �� ������������ ��������� ������
   ---------------------
   ����������:
      

/*///-------------------------------------------------------------------
int OpenMarketSLTP_pip(	string		sy		=	""		,
						int			cmd		=	-1		,
						double		lot		=	0		,
						double		pr		=	0		,
						int			sl_pip	=	0		,
						int			tp_pip	=	0		,
						string		comm	=	""		,
						int			MN		=	0		,
						datetime	exp		=	0		,
						color		cl		=	CLR_NONE){
   int res = _OrderSend(sy, cmd, lot, pr, 0, 0, 0, comm, MN, exp, cl);
   //============
   if(res > -1){
      OrderSelect(res, SELECT_BY_TICKET);
             pr = OrderOpenPrice();
      double sl = pr + iif(cmd == OP_BUY,-1,1) * sl_pip*Point;
      double tp = pr + iif(cmd == OP_BUY,1,-1) * tp_pip*Point;
      
      if( _OrderModify( res, -1, sl, tp, MN, -1, CLR_NONE))
         return(res);   
      else              // �������� �� ������ ��������� ����������� ������
         return(res);         
   }else{
      return(-1);     
   }//}}if(res > -1){   
} 
//======================================================================

/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ������ �� �������� ����������� ������ � �������� � ��� �� ���. ���� 
      � ������������ �� � �� � ������� 
   ---------------------
   ���. �������:
      ._OrderSend()-��������� ����� ��� �� � ��
      ._OrderModify() - ������������� �� � �� ������������ ��������� ������
   ---------------------
   ����������:
      

/*///-------------------------------------------------------------------
int OpenPendingPRSLTP_pip(	string		sy		=	""			, 
							int			cmd		=	-1			, 
							double		lot		=	0			, 
							int			pr		=	0			, 
							int			sl_pip	=	0			, 
							int			tp_pip	=	0			, 
							string		comm	=	""			, 
							int			MN		=	0			, 
							datetime	exp		=	0			, 
							color		cl		=	CLR_NONE	){
   
   if(sy == ""){
      sy = Symbol();
   }
   //----
   double pending_pr = MarketInfo(sy, MODE_BID) + orderDirection(cmd,OP_SORD)*pr*Point;
   
   int res = _OrderSend(sy, cmd, lot, pending_pr, 0, 0, 0, comm, MN, exp, cl);
   //============
   if(res > -1){
      OrderSelect(res, SELECT_BY_TICKET);
             pending_pr = OrderOpenPrice();
              double sl = pending_pr - orderDirection(cmd,OP_SLTP) * sl_pip*Point;
              double tp = pending_pr + orderDirection(cmd,OP_SLTP) * tp_pip*Point;
      
      if( _OrderModify( res, -1, sl, tp, MN, -1, CLR_NONE))
         return(res);   
      else              // �������� �� ������ ��������� ����������� ������
         return(res);         
   }else{
      return(-1);     
   }//}}if(res > -1){   
} 
//======================================================================

/*///===================================================================
	������: 2011.04.02
	---------------------
	��������:
		������������ �� � �� (�����������) ������
	---------------------
	���. �������:
		._OrderModify()
	---------------------
	����������:
		ticket
		tp_pip
		sl_pip
		magic
/*///-------------------------------------------------------------------
bool ModifyOrder_TPSL_pip(int ticket, int tp_pip, int sl_pip, int magic){
	
	bool res = false;

	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false);
	//======
	if(OrderCloseTime() > 0){
		addInfo("Order: "+ticket+" is CLOSED!!!!");
		return(false);
	}
	//----
		double oop = NormalizeDouble(OrderOpenPrice(), 	Digits);
		double otp = NormalizeDouble(OrderTakeProfit(), Digits);
		double osl = NormalizeDouble(OrderStopLoss(),	Digits);
		//---
		double calc_tp = 0;
		double calc_sl = 0;
		//---
		if(OrderType() == OP_BUY || OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT){
			calc_tp = (oop + tp_pip*Point);
			calc_sl = (oop - sl_pip*Point);
		}
		//---
		if(OrderType() == OP_SELL || OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT){
			calc_tp = (oop - tp_pip*Point);
			calc_sl = (oop + sl_pip*Point);
		}
		//---
		calc_tp = NormalizeDouble(calc_tp, Digits);
		calc_sl = NormalizeDouble(calc_sl, Digits);
		//---
		if(calc_tp == otp && calc_sl == osl){
			return(true);
		}else{
			res = _OrderModify(ticket, -1, calc_sl, calc_tp, magic, -1, CLR_NONE);
			return(res);
		}
		
}
//======================================================================

/*///===================================================================
         �������� ������� ����������		 
/*///===================================================================   
//{
      
/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ������ �� �������� �������
   ---------------------
   ���. �������:
      ._OrderModify()
               .checkOrderByTicket(int ticket, int CHK_OPTION)
   ---------------------
   ����������:
      ��. � ���� ���������

/*///-------------------------------------------------------------------
int _OrderSend(string    _symbol,
                  int    _cmd, 
                  double _volume, 
                  double _price, 
                  int    _sleepage, 
                  double _stoploss, 
                  double _takeprofit, 
                  string _comment, 
                  int    _magic, 
                  int    _exp, string fn = ""){
   /*
   symbol   -   ������������ ����������� �����������, � ������� ���������� �������� ��������. 
   cmd   -   �������� ��������. ����� ���� ����� �� �������� �������� ��������.  
   volume   -   ���������� �����. 
   price   -   ���� ��������. 
   slippage   -   ����������� ���������� ���������� ���� ��� �������� ������� (������� �� ������� ��� �������). 
   stoploss   -   ���� �������� ������� ��� ���������� ������ ����������� (0 � ������ ���������� ������ �����������). 
   takeprofit   -   ���� �������� ������� ��� ���������� ������ ������������ (0 � ������ ���������� ������ ������������). 
   comment   -   ����� ����������� ������. ��������� ����� ����������� ����� ���� �������� �������� ��������.  
   magic   -   ���������� ����� ������. ����� �������������� ��� ������������ ������������� �������������. 
   expiration   -   ���� ��������� ����������� ������. 
   arrow_color   -   ���� ����������� ������� �� �������. ���� �������� ����������� ��� ��� �������� ����� CLR_NONE, �� ����������� ������� �� ������������ �� �������. 
   
   ���� price == 0 ����� ��������� �� ������� ����
   */
   int res        = -1;
   int countOfTry = 5;
   int nTry       = 0;
   
   int sltpLevel = MarketInfo(Symbol(),MODE_STOPLEVEL);
 
   
   
   while(      res   <   0                && nTry  <=  countOfTry 
                     &&  !IsStopped()     &&           IsTradeAllowed()){
      
      //---            
      if(!IsExpertEnabled()) break;
      //---
      
      if(_cmd <= 1 && _price <= 0){
         _price = iif(_cmd == OP_BUY, MarketInfo(Symbol(), MODE_ASK), MarketInfo(Symbol(), MODE_BID));
      }
      //---
      if(_price > 0 ){
         if(_cmd == OP_BUYSTOP || _cmd == OP_SELLLIMIT){
            if(_price < (MarketInfo(Symbol(),MODE_ASK) + sltpLevel  *  Point)){
               logInfo(StringConcatenate("cant open ", "ot = ",_cmd, " op = ",_price," fn = OpenOrder"),libNAME+" : _OrderSend");
               return(-1);
            }
         }
         //***
         if(_cmd == OP_SELLSTOP || _cmd == OP_BUYLIMIT){
            if(_price > (MarketInfo(Symbol(),MODE_BID) - sltpLevel  *  Point)){
              logInfo(StringConcatenate("cant open ", "ot = ",_cmd, " op = ",_price," fn = OpenOrder"),libNAME+" : _OrderSend");
               return(-1);
            }
         }
      }
      
      //����������� ��� ���������� ��������� �� ����
      _price      = NormalizeDouble(_price,      Digits);  
      _stoploss   = NormalizeDouble(_stoploss,   Digits);
      _takeprofit = NormalizeDouble(_takeprofit, Digits);
              
      res = OrderSend(_symbol, _cmd, _volume, _price, _sleepage, 0, 0, _comment, _magic, _exp, CLR_NONE);
      
      logInfo(StringConcatenate("OpenOrder = ",res), "");
      
      if(res > -1 && (_stoploss > 0 || _takeprofit > 0)){
         if(_OrderModify(res,-1,_stoploss,_takeprofit,_magic,_exp,CLR_NONE))
            return(res);   
      }   
      //---
      int err = GetLastError();
      if(err > 0)
      {
         if(err == 4109){
            logInfo("TRADE IS DISABLED!!!!", "");
            addInfo("TRADE IS DISABLED!!!!");
            return(-1);
         }   
            
         if(err == 4051)
            break;   
         //logInfo(_price);
         if(err == 148){
            logInfo("BROCKER MAX ORDERS!!!!!", "");
            addInfo("BROCKER MAX ORDERS!!!!!");
            return(-1);
         }
         
         if(err == 130){
            logInfo(StringConcatenate("sl = ",_stoploss," tp = ",_takeprofit), "");
            return(-1);
         }
         logError("OpenOrder",StringConcatenate("OrderSendError, fn = ",fn),err);
         logInfo(StringConcatenate("Price = ",_price," cmd = ",_cmd, " bid = ", Bid, " ask = ", Ask), "");
      }
      
      nTry++;
   }
   
return(res);   
}
//======================================================================

/*///===================================================================
   ������: 2011.03.24
   ---------------------
   ��������:
      ���������� ����������� ������� �������� ������
   ---------------------
   ���. �������:
      .checkOrderByTicket(int ticket, int CHK_OPTION)
   ---------------------
   ����������:
      condition    = ���������� ���������
      ifTrue       = �������� � ������ condition = ������
      ifFalse      = �������� � ������ condition = ����

/*///-------------------------------------------------------------------
bool _OrderModify( 	int 		ticket					, 
					double 		price					, 
					double 		stoploss				, 
					double 		takeprofit				, 
					int 		MN 			= 	0		, 
					datetime 	expiration	=	-1		, 
					color 		clr			=	CLR_NONE){
   bool res = false;   
   //===================
      if(!checkOrderByTicket(ticket, CHK_SMBMN, "", MN, -1)) return(false);
   //===================   
   // �������� �� ����������� ������ ���������
   
   OrderSelect(ticket,SELECT_BY_TICKET);
   
   if(price       < 0) price       = OrderOpenPrice();
   //-----
   if(stoploss    < 0) stoploss    = OrderStopLoss();
   //-----
   if(takeprofit  < 0) takeprofit  = OrderTakeProfit();
   //-----
   if(expiration  < 0) expiration  = OrderExpiration();
   //-----
   // ����������� ��� ����������
      price       = NormalizeDouble(price,      Digits);
      stoploss    = NormalizeDouble(stoploss,   Digits);
      takeprofit  = NormalizeDouble(takeprofit, Digits);      
   //-----
   int nTry = 5;
   int i    = 1;
   
   while(!res && i <= nTry && (IsExpertEnabled() || IsTesting()) && !IsStopped()){
      //---
      while(IsTradeContextBusy()) Sleep(1000*5);
      //---
      res = OrderModify(ticket, price, stoploss, takeprofit, expiration, clr);   
      //==========================   
      i++;
   }
   //==========
   // ����������� � �����������:
   if(res)
      return(true);
   else{
      logError("libOrdersFunc : _OrderModify()","",GetLastError());   
      return(res);
   }   
} 

//}======================================================================