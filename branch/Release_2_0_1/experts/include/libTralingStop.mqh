/*///===================================================================
Версия: 2011.14.12
/*///===================================================================

string libTralingStop = "==== lib TRALING STOP";
bool	libTrSl_UseTralingStoploss = false;	// Использовать трайлинг стоп
bool		libTrSl_ProfitTraling	= true;	// Тралить только профит
int			libTrSl_TralingSTOP		= 50;	// Фиксированный размер трала
int			libTrSl_TralingSTEP		= 5;	// Шаг трала



/*///===================================================================
	Версия: 2011.12.12
	---------------------
	Описание:
		Сопровождение заданного ордера простым тралом
	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		ticket	- Тикет ордера для трала
/*///-------------------------------------------------------------------
bool libTrSl_TralingSimple(int ticket){
	if(!libTrSl_UseTralingStoploss) return(true); 

	if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(true);
	//---
	double p 	= MarketInfo(OrderSymbol(),MODE_POINT);
	if(OrderType() == OP_BUY){
		double pp	= MarketInfo(OrderSymbol(),MODE_BID);
		if(!libTrSl_ProfitTraling || (pp - OrderOpenPrice()) > libTrSl_TralingSTOP*p){
			if(OrderStopLoss() < pp - (libTrSl_TralingSTOP+ libTrSl_TralingSTEP-1)*p){
				ModifyOrder_TPSL_price(ticket, -1, pp-libTrSl_TralingSTOP*p, OrderMagicNumber());
			}
		}
	}
	
	if(OrderType() == OP_SELL){
		pp	= MarketInfo(OrderSymbol(),MODE_ASK);
		if(!libTrSl_ProfitTraling || (OrderOpenPrice() - pp) > libTrSl_TralingSTOP*p){
			if(OrderStopLoss() > pp + (libTrSl_TralingSTOP+ libTrSl_TralingSTEP-1)*p){
				ModifyOrder_TPSL_price(ticket, -1, pp+libTrSl_TralingSTOP*p, OrderMagicNumber());
			}
		}
	}
}
//======================================================================

//{--- Трейлинг отложенного ордера 
	//{--- Настройки пользователя
	extern string	libTr_SO = "---------- TRALING STOP ORDERS";
		extern bool libTr_SO_useTralingStopOrder	=	false; // разрешает советнику использовать трейлинг отложенного ордера
		extern 	int libTr_SO_TralingSTART_pip	=	50; // сколько пунктов должна пройти цена в плюс родительского ордера для начала работы трейлинга.
		extern	int libTr_SO_TralingSTOP_pip	=	30;	// расстояние от отложенного ордера до цены
		extern	int libTr_SO_TralingSTEP_pip	=	10; // шаг трейлинга.
	//}
	
	/*///===================================================================
		Описание алгоритма:
			если цена идет в плюс родительского ордера на величину равную или больше
			трейлинг СТАРТ, то переносим отложенный ордер на СТЕП, если цена 
			проходит величину СТЕП.
	/*///===================================================================
	
	/*///===================================================================
		Версия: 2011.12.12
	/*///===================================================================
	void libTr_SO_fTSO(int ticket){
	
		if(!libTr_SO_useTralingStopOrder) return;
		//---
		if(!OrderSelect(ticket, SELECT_BY_TICKET)) return;
		//---
			int 		o_ty		= OrderType();
			string	o_comm	= OrderComment();
			double	o_OOP		= OrderOpenPrice();
			double	o_SL		= OrderStopLoss();
			double	o_TP		= OrderTakeProfit();
		//---
		if(OrderType() <= 1) return;	// у нас рыночный ордер, а его тралить мы не можем.
		
		
		
		int parent_ti = StrToInteger(returnComment(o_comm,"@p"));
				
		if(libOF_fgetPipFromOrder(parent_ti) > libTr_SO_TralingSTART_pip){
			if(libOF_fgetPipFromOrder(ticket) > (libTr_SO_TralingSTEP_pip + libTr_SO_TralingSTOP_pip)){
				if(o_ty == OP_BUYSTOP){
					int step_pip = -libTr_SO_TralingSTEP_pip;
				}else{
					if(o_ty == OP_SELLSTOP)
						step_pip = libTr_SO_TralingSTEP_pip;
					//---	
				}
					libOF_ModifyOrder_PR_pip(ticket, step_pip, MN);
				//}
				//---
				//if(o_ty == OP_SELL || o_ty == OP_SELLLIMIT || o_ty == OP_SELLSTOP){
				//}
			}
		}
	}
	//----------------------------------------------------------------------
//}