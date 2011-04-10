//+------------------------------------------------------------------+
//|                                                libOrdersFunc.mq4 |
//|                      Copyright © 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"
#property library

#include <libHelpFunc.mqh>
#include <libINIFileFunc.mqh>
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
#define  libNAME "libOrdersFunc"

#define  OP_SLTP   200
#define  OP_SORD   100

#define  CHK_SMBMN    500
#define  CHK_SMB      700
#define  CHK_MN       600
#define  CHK_TYMORE   400
#define  CHK_TYLESS   300
#define  CHK_TYEQ     200

#define  TL_COUNT		1	// TL - Twise lot
#define  TL_VOL			2	// TL - Twise lot

string   EXP_NAME =   "";
//======================================================================
string   file_ord =  "";

void libOrders_setFile_ord(string str){
   file_ord = str;
}

/*///==================================================================
// Версия: 2011.03.24
//---------------------
// Описание:
// Возвращает версию библиотеки помощи :)
//---------------------
// Переменные:
//    нет
/*///-------------------------------------------------------------------
string libOrders_Ver(){
   return("v1.0");
}
//======================================================================

//===================================================
//v2
//+----------------------------------------------------------------------------+
//    Автор    : Морокин Артём ака artamir <artamir@yandex.ru>
//+----------------------------------------------------------------------------+
//    Версия   : 2010.07.04
//    Описание : Возвращает значение объема или количество ордеров, 
//               нужное для деления заданного объема
//+----------------------------------------------------------------------------+
//    На входе:
//       nlot      - нужный объем для деления
//       ulot      - использованны объем (вычитается из нужного)
//      rejim      - режим выдачи информации(TL_COUNT - количество ордеров, TL_VOL - объем)
//+----------------------------------------------------------------------------+
//    На выходе:
//       в зависимости от режима
//+----------------------------------------------------------------------------+
double TwisePending(double nlot,double ulot,int rejim, double TL)
{
   double delta = nlot - ulot;
   //---
   if(delta <= 0) return(-1);
   //---
   double    norders = MathCeil((nlot-ulot)/TL);           // нашли количество ордеров, которое нужно выставить
   if(norders > 0 && norders < 1)
      norders = 1;
   double twlot   = NormalizeDouble((nlot-ulot)/norders,2);   // нашли лот, который нужен
   
   twlot = NormalizeLot(twlot, False, "");
   
   if(rejim == TL_COUNT)
      return(norders);
      
   if(rejim == TL_VOL)
      return(twlot);   
}

//=======================================================

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      проверяет, является ли ордер родительским
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      ticket       = тикет проверяемого ордера
      magic        = магик советника
/*///-------------------------------------------------------------------
bool  isParentOrder(int ticket, int magic){
   //================
      if(!checkOrderByTicket(ticket, CHK_TYLESS, "", magic, 1)) return(false); // проверим, чтоб ордер был рыночным
      //----
      if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(false); //на всякий случай
   //================
   // Попытаемся проверить ини файл родительских ордеров
   int isParent = StrToInteger(ReadIniString(file_ord, ticket, "isParent", "-1"));
   //----
   if(isParent == -1){
      if(OrderComment() == "" || StrToInteger(returnComment(OrderComment(),"@ip")) > -1)
         return(true);
      else
         return(false);   
   }
}
//======================================================================

/*///===================================================================
	Версия: 2011.03.31
	---------------------
	Описание:
		проверяем, является ли родительский ордер живым
	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		нет
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
	Версия: 2011.03.31
	---------------------
	Описание:
		Возвращает родителя из истории
	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		нет
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
   Версия: 2011.03.30
   ---------------------
   Описание:
      возвращает родительский тикет для текущего ордера
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      ticket - тикет ордера, для которого определяем родителя

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
    Версия: 2011.03.30
    ---------------------
    Описание:
        возвращает, какой тип операции был у 
        ордера при его выставлении
    ---------------------
    Доп. функции:
        нет
    ---------------------
    Переменные:
        нет
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
   Версия: 2011.03.24
   ---------------------
   Описание:
      проверяет ордер по заданным параметрам
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      ticket       = тикет ордера
      ORD_CHK      = режим проверки
      sy           = валютная пара(опционально)
      MN           = магик номер
      ty           = тип ордера
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
   return(true);  // прошли проверку, вернем ТРУ
}
//======================================================================

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      Запрос на открытие рыночного ордера с выставлением тп и сл в пунктах 
   ---------------------
   Доп. функции:
      ._OrderSend()-открываем ордер без тп и сл
      ._OrderModify() - устанавливаем тп и сл относительно открытого ордера
   ---------------------
   Переменные:
      

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
						
	
   int res = _OrderSend(sy, cmd, lot, pr, 0, 0, 0, comm, MN, exp, libNAME+": OpenMarketSLTP_pip");
   //============
   if(res > -1){
      OrderSelect(res, SELECT_BY_TICKET);
             pr = OrderOpenPrice();
			 if(sl_pip > 0)
				double sl = pr + iif(cmd == OP_BUY,-1,1) * sl_pip*Point;
			else
				sl = 0;
			//---
			if(tp_pip > 0)
			    double tp = pr + iif(cmd == OP_BUY,1,-1) * tp_pip*Point;
			else
				tp = 0;
			//---
      if( _OrderModify( res, -1, sl, tp, MN, -1, CLR_NONE))
         return(res);   
      else              // заглушка на случай неудачной модификации ордера
         return(res);         
   }else{
      return(-1);     
   }//}}if(res > -1){   
} 
//======================================================================

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      Запрос на открытие отложенного ордера с заданной ценой 
      с выставлением тп и сл в пунктах 
   ---------------------
   Доп. функции:
      ._OrderSend()-открываем ордер без тп и сл
      ._OrderModify() - устанавливаем тп и сл относительно открытого ордера
   ---------------------
   Переменные:
      

/*///-------------------------------------------------------------------
int OpenPendingPRSLTP_pip(	string		sy		=	""			, 
							int			cmd		=	-1			, 
							double		lot		=	0			, 
							double		pr		=	0			, 
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
   
   int res = _OrderSend(sy, cmd, lot, pr, 0, 0, 0, comm, MN, exp, libNAME+": OpenPendingPR_SLTP_pip");
   //============
   if(res > -1){
      OrderSelect(res, SELECT_BY_TICKET);
             pending_pr = OrderOpenPrice();
              double sl = pending_pr - orderDirection(cmd,OP_SLTP) * sl_pip*Point;
              double tp = pending_pr + orderDirection(cmd,OP_SLTP) * tp_pip*Point;
      
      if( ModifyOrder_TPSL_pip( res, tp_pip, sl_pip, MN))
         return(res);   
      else              // заглушка на случай неудачной модификации ордера
         return(res);         
   }else{
      return(-1);     
   }//}}if(res > -1){   
} 
//======================================================================

/*///===================================================================
	Версия: 2011.04.02
	---------------------
	Описание:
		Модифицирует тп и сл (опционально) ордера
		если значение тп или сл < 0, тогда будет использоваться соответствующее значение тп или сл ордера
	---------------------
	Доп. функции:
		._OrderModify()
	---------------------
	Переменные:
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
			if(tp_pip > 0)
				calc_tp = (oop + tp_pip*Point);
			else
				if(tp_pip < 0)
					calc_tp = otp;
				else	
					calc_tp = 0;
			//---
			if(sl_pip > 0)
				calc_sl = (oop - sl_pip*Point);
			else
				if(sl_pip < 0)
					calc_sl = osl;
				else
					calc_sl = 0;
			//---	
		}
		//---
		if(OrderType() == OP_SELL || OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT){
			if(tp_pip > 0)
				calc_tp = (oop - tp_pip*Point);
			else
				if(tp_pip < 0)
					calc_tp = otp;
				else	
					calc_tp = 0;
			//---
			if(sl_pip > 0)
				calc_sl = (oop + sl_pip*Point);
			else
				if(sl_pip < 0)
					calc_sl = osl;
				else	
					calc_sl = 0;
			//---	
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
// если значение тп или сл < 0, тогда будет использоваться соответствующее значение тп или сл ордера
bool ModifyOrder_TPSL_price(int ticket, double tp_pr, double sl_pr, int magic){
	
	bool res = false;
    //Print("ModifyOrder_TPSL_price("+ticket+", "+tp_pr+","+ sl_pr+", "+magic+")");
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
		tp_pr = NormalizeDouble(tp_pr, Digits);
		sl_pr = NormalizeDouble(sl_pr, Digits);
		
		if(tp_pr < 0)
			tp_pr = otp;
		//---
		if(sl_pr < 0)
			sl_pr = osl;
		//---
		if(tp_pr == otp && sl_pr == osl){
			return(true);
		}else{
			res = _OrderModify(ticket, -1, sl_pr, tp_pr, magic, -1, CLR_NONE);
			return(res);
		}
		
}
//======================================================================

//+------------------------------------------------------------------+
//удаляем отложенник
//+------------------------------------------------------------------+
bool delPendingByTicket(int ticket){
   bool res = false;
   int  ntry = 0;
   int tryCount = 5;
   
   if(!IsTradeAllowed()) return(false);
   
   if(OrderSelect(ticket,SELECT_BY_TICKET)){      //выбрали ордер
      if(OrderCloseTime() > 0) return(true);     //проверили, чтоб он не был закрыт или удален
      while(IsTradeContextBusy()){                //пока занят торговый поток 
            Sleep(3000);                          //спим 3 сек.
      }
      //---
      while(!res && ntry <= tryCount){
         res = OrderDelete(ticket,CLR_NONE);
         ntry++;
      }
      //---
      int err = GetLastError();
      if(!res){
         logError("delPending",StringConcatenate("tick = ",ticket),err);
      }
         
      return(res);
   }else
      return(true);
}
//=======================================================================

/*///===================================================================
         ЗАКРЫТЫЕ ФУНКЦИИ БИБЛИОТЕКИ		 
/*///===================================================================   
//{
      
/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      Запрос на открытие позиции
   ---------------------
   Доп. функции:
      ._OrderModify()
               .checkOrderByTicket(int ticket, int CHK_OPTION)
   ---------------------
   Переменные:
      см. в теле процедуры

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
   symbol   -   Наименование финансового инструмента, с которым проводится торговая операция. 
   cmd   -   Торговая операция. Может быть любым из значений торговых операций.  
   volume   -   Количество лотов. 
   price   -   Цена открытия. 
   slippage   -   Максимально допустимое отклонение цены для рыночных ордеров (ордеров на покупку или продажу). 
   stoploss   -   Цена закрытия позиции при достижении уровня убыточности (0 в случае отсутствия уровня убыточности). 
   takeprofit   -   Цена закрытия позиции при достижении уровня прибыльности (0 в случае отсутствия уровня прибыльности). 
   comment   -   Текст комментария ордера. Последняя часть комментария может быть изменена торговым сервером.  
   magic   -   Магическое число ордера. Может использоваться как определяемый пользователем идентификатор. 
   expiration   -   Срок истечения отложенного ордера. 
   arrow_color   -   Цвет открывающей стрелки на графике. Если параметр отсутствует или его значение равно CLR_NONE, то открывающая стрелка не отображается на графике. 
   
   если price == 0 тогда открываем по текущей цене
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
               logInfo(StringConcatenate("cant open ", "ot = ",_cmd, " op = ",_price," fn = ",fn),libNAME+" : _OrderSend");
               return(-1);
            }
         }
         //***
         if(_cmd == OP_SELLSTOP || _cmd == OP_BUYLIMIT){
            if(_price > (MarketInfo(Symbol(),MODE_BID) - sltpLevel  *  Point)){
              logInfo(StringConcatenate("cant open ", "ot = ",_cmd, " op = ",_price," fn = ",fn),libNAME+" : _OrderSend");
               return(-1);
            }
         }
      }
      
      //нормализуем все переменные зависящие от цены
      _price      = NormalizeDouble(_price,      Digits);  
      _stoploss   = NormalizeDouble(_stoploss,   Digits);
      _takeprofit = NormalizeDouble(_takeprofit, Digits);
              
      res = OrderSend(_symbol, _cmd, _volume, _price, _sleepage, 0, 0, _comment, _magic, _exp, CLR_NONE);
      
      logInfo(StringConcatenate("OpenOrder = ",res," sender -> ",fn), libNAME+" : _OrderSend");
      
      if(res > -1 && (_stoploss > 0 || _takeprofit > 0)){
         if(_OrderModify(res,-1,_stoploss,_takeprofit,_magic,_exp,CLR_NONE,"_OrderSend"))
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
   Версия: 2011.03.24
   ---------------------
   Описание:
      Производит модификацию ценовых значений ордера
   ---------------------
   Доп. функции:
      .checkOrderByTicket(int ticket, int CHK_OPTION)
   ---------------------
   Переменные:
      condition    = логическое сравнение
      ifTrue       = значение в случае condition = ИСТИНА
      ifFalse      = значение в случае condition = ЛОЖЬ

/*///-------------------------------------------------------------------
bool _OrderModify( 	int 		ticket					, 
					double 		price					, 
					double 		stoploss				, 
					double 		takeprofit				, 
					int 		MN 			= 	0		, 
					datetime 	expiration	=	-1		, 
					color 		clr			=	CLR_NONE,
					string 		fn			= ""){
   bool res = false;   
   //===================
      if(!checkOrderByTicket(ticket, CHK_SMBMN, "", MN, -1)) return(false);
   //===================   
   // Проверка на возможность работы советника
   
   OrderSelect(ticket,SELECT_BY_TICKET);
   
	double oop	= OrderOpenPrice();
	double otp	= OrderTakeProfit();
	double osl	= OrderStopLoss();
   
   if(price       < 0) price       = oop;
   //-----
   if(stoploss    < 0) stoploss    = osl;
   //-----
   if(takeprofit  < 0) takeprofit  = otp;
   //-----
   if(expiration  < 0) expiration  = OrderExpiration();
   //-----
   // Нормализуем все переменные
      price       = NormalizeDouble(price,      Digits);
      stoploss    = NormalizeDouble(stoploss,   Digits);
      takeprofit  = NormalizeDouble(takeprofit, Digits);      
   //-----
   //Print("======================================");
   //Print("otp = ", otp);
   //Print("takeprofit = ", takeprofit);
   
   if(	NormalizeDouble(otp, Digits) == NormalizeDouble(takeprofit, Digits) && 
		NormalizeDouble(osl, Digits) == NormalizeDouble(stoploss, Digits) && price < 0){
			return(true);
	}
   
   
   int nTry = 5;
   int i    = 1;
   
   while(!res && i <= nTry && (IsExpertEnabled() || IsTesting()) && !IsStopped()){
      //---
      while(IsTradeContextBusy()) Sleep(1000*5);
      //---
      res = OrderModify(ticket, price, stoploss, takeprofit, expiration, clr);   
      //==========================  
		if(GetLastError() == 1)
			res = true;
      i++;
   }
   //==========
   // Разбираемся с результатом:
   if(res)
      return(true);
   else{
      logError("libOrdersFunc :"+fn+"() _OrderModify()","",GetLastError());   
      return(res);
   }   
} 

//}======================================================================