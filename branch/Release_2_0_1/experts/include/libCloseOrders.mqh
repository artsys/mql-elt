/*///===================================================================
	Ver:2012.02.11_0.0.17
		-----------------
		Описание: Библиотека различных методов закрытия рыночных ордеров
		-----------------
		Изменения:
			0106 - * Функция заполнения массива ордеров для частичного закрытия.
			0206 - + Закрытие по фиксированному профиту
		-----------------
/*///===================================================================
//--------------------------------------
extern string    ex_CLOSE_BY_PROFIT      = "--- SETUP: Close by Profit ---";
extern bool         needCloseByLots         = false;
extern double       growEquityPercent       = 1;
extern int          waitsec                 = 5;
extern string    ex_END_CLOSE_BY_PROFIT  = "===================================================";
//{--- CLOSE BY FIX PROFIT
	extern string    ex_CLOSE_BY_FIX_PROFIT    = "--- SETUP: CLOSE BY FIX PROFIT ---";
	extern bool         libCO_needCFP	     		= false; // Разрешает советнику использовать частичное закрытие прибыли
	extern double       	libCO_CFP_Profit			= 10000;	 // Прибыль в валюте депозита по ордерам советника 
	extern string    ex_END_CLOSE_BY_FIX_PROFIT = "===================================================";
//}

extern string    ex_CLOSE_PARTIAL_BY_LOTS      = "--- SETUP: Close by Partial close ---";
extern bool         libCO_needClosePartial	     = false; // Разрешает советнику использовать частичное закрытие прибыли
extern double       libCO_CP_Lots					= 8.5;	 // Объем в рынке, с которого включается эта функция 
extern int					libCO_ClosePip			= 10;	 // Сколько пунктов добавляем к безубытку.
extern string    ex_END_CLOSE_PARTIAL_BY_LOTS  = "===================================================";


//{--- DEFINE
	#define libCO_idx_ticket		0
	#define libCO_idx_type			1
	#define libCO_idx_MN			2
	#define libCO_idx_comm			3
	#define libCO_idx_lot			4
	#define libCO_idx_oop			5
//}

double price_close;

/*///===================================================================
		Ver: 2012.02.01_0.0.16
		-----------------
		Описание: Основная процедура модуля. Осуществляет проверки и запуск
			соответствующих блоков закрытия.
		-----------------
		Изменения:
		-----------------
/*///===================================================================
void libCO_MAIN(){
	if(needCloseByLots){
		libCO_closeByProfit();
	}
	//---
	if(libCO_needCFP){
		libCO_CFP_Check();
	}
	//---
	if(libCO_needClosePartial){
		price_close = libCO_checkPartialClose();
	}
}

//{--- CLOSE BY LOTS
double nextEquity;
double lastEquity;

void libCO_closeByProfit(){
 //***************************************
 // блок эксперта eCloseByLots
 //***************************************
	if(checkEquity(nextEquity) && needCloseByLots){
		Sleep(waitsec*1000);
		if(checkEquity(nextEquity))
			prepareOrdersToClose();       
  }    
  //---
  if(!isAnOrder(1))
    calculateEquity();

  //***************************************
  // конец блока эксперта eCloseByLots
  //***************************************
}
  
//********************************************************************
// Блок эксперта eCloseOrdersByLots_v4
//********************************************************************

//********************************************************************
//процедура расчета еквити
//Еквити*(1+гроу/100)
//********************************************************************
void calculateEquity()
{
   lastEquity = AccountEquity();
   nextEquity = NormalizeDouble(lastEquity*(1+NormalizeDouble((growEquityPercent/100),4)),2);
   
}

//====================================================================
bool checkEquity(double nE)
{  
   bool res = false;
   if(AccountEquity() >= nE)
      return(true);
      
   return(res);      
}

//============================================
//находим существует ли ордер заданного типа:
//1 - рыночный
//2 - лимитный
//3 - стоп
bool isAnOrder(int id_type){
   bool res = false;
   int total = OrdersTotal();
   for(int i = total; i >= 0; i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(id_type == 1){
            if(OrderType() == 0 || OrderType() == 1){
               return(true);
            }             //*** if(OrderType() == 0 || OrderType() == 1){
         }                //*** if(id_type == 1){
      }                   //*** if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
   }                      //*** for(int i = total; i >= 0; i--){
 return(res);  
}

//***** Блок закрытия ордеров ************************************** 
//==================================
//подготовка ордера к закрытию
// на входе: тикет ордера для закрытия
//на выходе: закрытый ордер
void CloseMarketOrder(int ticket)
{
   bool res = false;
   int tryClose = 5;
   int ntry = 0;
   int err;
   if(OrderSelect(ticket,SELECT_BY_TICKET)){
      if(OrderType() >= 2) return; 
      
      if(IsTradeAllowed() && IsExpertEnabled()){
         while(IsTradeContextBusy()){
            Sleep(5);
         }
         double price = 0;
         
         while((!res || ntry >= tryClose) && (OrderCloseTime() == 0)){   
            if(OrderType() == 0)
               price = NormalizeDouble(MarketInfo(OrderSymbol(),MODE_BID),Digits);
            
            if(OrderType() == 1)   
               price = NormalizeDouble(MarketInfo(OrderSymbol(),MODE_ASK),Digits);
            
            if(OrderCloseTime() != 0) return;
               
            res = OrderClose(ticket,OrderLots(),price,1,CLR_NONE);   
            ntry++;
            
            err = GetLastError();
            if(err > 1)
               Print("ERROR => CloseOrder() => ",err);
            
         }   
      }
   }                                    //*** if(OrderSelect(ticket,SELECT_BY_TICKET))  
}

//==================================
//найдем ордер с максимальным лотом
//вернем его тикет
int getMaxOrder()
{
   int res = 0;
   int total = OrdersTotal();
   double maxlot = 0;
   
   
   for(int i = total; i >= 0; i--){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderType() == 0 || OrderType() == 1)
         if(OrderLots() > maxlot){
	            maxlot = OrderLots();
        	      res    = OrderTicket();
         }                      //*** if(OrderLots() > maxlot)      
      }                         //*** if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
   }                            //*** for(int i = total; i >= 0; i--)
                               
   return(res);
}

//==================================
//подготовим ордера к закрытию
//пока будут рыночные ордера и еквити больше расчетного значения,
//находим следующий макс по объему ордер и отправляем приказ на его 
//закрытие
void prepareOrdersToClose(int rejim = 1) //1 - закрытие по гроуэквити
                                         //2 - закрытие всех рыночных ордеров без контроля эквити
{  
   if(rejim == 1){
      while(checkEquity(nextEquity) && isAnOrder(1)){
     
         int ticket = getMaxOrder();
     
         if(ticket > 0)
            CloseMarketOrder(ticket);
      }                          //***while(checkEquity && isOrder(1))
   }else{
      while(isAnOrder(1)){
     
         ticket = getMaxOrder();
     
         if(ticket > 0)
            CloseMarketOrder(ticket);
      }
   }
}

//********************************************************************
// Конец блока эксперта eCloseOrdersByLots_v4
//********************************************************************
//}


//{--- PARTIAL CLOSE
/*///===================================================================
	Версия: 2011.09.24
	---------------------
	Описание: Различные начальные проверки блока

	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		нет
/*///-------------------------------------------------------------------
double libCO_checkPartialClose(){
	double res = 0;
	
	double maxBUY = 0;
	double maxSELL = 0;
	double price_close = 0;
	
	string aOrdersToClose[100][11];
		//--- Проверим разрешение использовать этот функционал
		if(!libCO_needClosePartial) return(0);
		//---
		maxBUY	=	libOF_getMarketLots("", OP_BUY,		MN, -1); // Вычисляем общее количество баев советника
		maxSELL	=	libOF_getMarketLots("", OP_SELL,	MN, -1); // Вычисляем общее количество селлов советника
		//---
		if(maxBUY >= libCO_CP_Lots || maxSELL >= libCO_CP_Lots){
			// мы перешагнули за разрешенный предел
			//	1.	попытаемся расчитать цену безубытка
			//		1.2	Если цена безубытка расчитана, то:
			//			1.2.1 Если баев больше чем селлов, к цене безубытка добавим заданное 
			//						кол. пунктов для начала закрытия.
			//			1.2.2 Если больше селлов то от безубытка отнимем заданное кол. пунктов.
			//	2. Если цена дошла до расчетного закрывающего уровня, то:
			//		2.1 расчитаем объемы, которые	нам необходимо закрыть для бая и селла
			//		2.2 Передаем в функцию, которая отвечает за частичное закрытие ордеров объем.
			//				А эта функция сама на основе открытых ордеров определяет какие нужно закрыть
			//				и  в коком объеме
			
			int idx_maxrow = libCO_fillAOrders(aOrdersToClose);
			
			double price_Zero = libCO_getNillPrice(aOrdersToClose);
			//---
			if(price_Zero <= 0) return(-1);
			//---
				if(maxBUY > maxSELL){
						price_close = price_Zero + libCO_ClosePip*Point;
						libCO_checkAbilityToClose(aOrdersToClose, price_close, OP_BUY);
				}else{
					if(maxSELL > maxBUY){
						price_close = price_Zero - libCO_ClosePip*Point;
						libCO_checkAbilityToClose(aOrdersToClose, price_close, OP_SELL);
					}
				}
			//---	
		}
	return(price_close);
}
//======================================================================


/*///===================================================================
	Версия: 2011.09.29
	---------------------
	Описание: Подготавливает массив ордеров для расчета цены безубытка.

	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		нет
/*///-------------------------------------------------------------------
int libCO_fillAOrders(string& maxOrders[][]){
	
	string orders[100][11];
	
	
	
	double res = 0;
	double SLots=0,Lots=MarketInfo(Symbol(),MODE_MINLOT);
	double Price=0;
	double TotalLots=0;
	
	int	idx_row = 0;
	for (int i=0;i<OrdersTotal();i++){
		if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
			int			ot	= OrderTicket();
			int			om	= OrderMagicNumber();
			int			oty	= OrderType();
			double	ol	= OrderLots();
			string	oc	= OrderComment();
			double	oop	= OrderOpenPrice();
			
			if(!checkOrderByTicket(ot, CHK_TYLESS, "", MN, 1)) continue;
			
			orders[idx_row][libCO_idx_ticket]	= ot;
			orders[idx_row][libCO_idx_type]		=	oty;
			orders[idx_row][libCO_idx_MN]			= om;
			orders[idx_row][libCO_idx_comm]		= oc;
			orders[idx_row][libCO_idx_lot]		= ol;
			orders[idx_row][libCO_idx_oop]		= oop;
			
			idx_row++;
		}
	}
	
	idx_row--;
	
	double maxLots 	= 0;
	int 	 	maxRow 	= 0;
	string	maxComm = "";
	
	for(i = 0; i <= idx_row; i++){
		if(i == 0){
			maxComm = orders[i][libCO_idx_comm];
		}
			
			double sumLots = 0;
		
		for(int j = 0; j <= idx_row; j++){
			if(orders[j][libCO_idx_comm] == orders[i][libCO_idx_comm]){
				sumLots = sumLots + StrToDouble(orders[j][libCO_idx_lot]);
			}
		}
		
		if(sumLots > maxLots){
			maxLots = sumLots;
			maxComm = orders[i][libCO_idx_comm];
			maxRow = i;
		}
	}
	

	int idx_maxrow = 0;
	for(i = 0; i <= idx_row; i++){
		if(orders[i][libCO_idx_comm] == maxComm){
			for(int idx_col = 0; idx_col <= 10; idx_col++){
				maxOrders[idx_maxrow][idx_col] = orders[i][idx_col];
			}
			idx_maxrow++;
		}
	}

	idx_maxrow--;
	string comm = maxOrders[0][libCO_idx_comm];
	int parent_t = StrToInteger(returnComment(comm,"@p"));
	
	if(!OrderSelect(parent_t,SELECT_BY_TICKET)) return(-1);
	//---
	int parent_ty = OrderType();
	double parent_l = OrderLots();
	double parent_oop = OrderOpenPrice();
	string parent_comm = OrderComment();
	
	for(i = 0; i <= OrdersTotal(); i++){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		//---
		if(OrderCloseTime() > 0) continue;
		//---
		if(OrderComment() == parent_comm){
			idx_maxrow++;
			maxOrders[idx_maxrow][libCO_idx_ticket] = OrderTicket();
			maxOrders[idx_maxrow][libCO_idx_type] = OrderType();
		}	
	}
	return(idx_maxrow);
}


/*///===================================================================
	Версия: 2011.09.29
	---------------------
	Описание: расчитывает цену безубытка.

	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		a[][] - массив ордеров для расчета безубытка
/*///-------------------------------------------------------------------
double libCO_getNillPrice(string& a[][]){
	double lots=0;
	double sum=0;
	
	for (int idx_row=0; idx_row<100; idx_row++){
		int ti = StrToInteger(a[idx_row][libCO_idx_ticket]);
		//---
		if (!OrderSelect(ti,SELECT_BY_TICKET)) continue;
		//---
		if (OrderSymbol()!=Symbol()) continue;
		//---
		if (OrderType()==OP_BUY){
			lots=lots+OrderLots();
			sum=sum+OrderLots()*OrderOpenPrice();
		}
		//---
    if (OrderType()==OP_SELL){
			lots=lots-OrderLots();
			sum=sum-OrderLots()*OrderOpenPrice();
    }
  }
   
	double price=0;
  if (lots!=0) price=sum/lots;
	
	return(price);
}
//======================================================================

/*///===================================================================
	Версия: 2011.09.29
	---------------------
	Описание: Проверка на положение цены на заданном уровне
						и закрытие ордеров из массива.
	---------------------
	Доп. функции:
		нет
	---------------------
	Переменные:
		нет
/*///-------------------------------------------------------------------
bool libCO_checkAbilityToClose(string& a[][], double price, int type){
	bool res = true;
	//{---
		double thisprice = iif(type == OP_BUY, MarketInfo(Symbol(),MODE_BID), MarketInfo(Symbol(), MODE_ASK));
	
		bool canClose = false;
		if(type == OP_BUY){
			if(thisprice >= price) canClose = true;
		}else{
			if(type == OP_SELL){
				if(thisprice <= price) canClose = true;
			}
		}
		
		if(canClose){
			for(int i = 0; i <= 99; i++){
				int ticket = StrToInteger(a[i][libCO_idx_ticket]);
				//---
				if(!OrderSelect(ticket, SELECT_BY_TICKET)) continue;
				//---
				libCO_CloseMarketOrder(ticket);
			}
		}
	//}
	comm2 = "";
	for(i = 0; i<=5; i++){
		comm2 = StringConcatenate(comm2, a[i][libCO_idx_ticket],"\n");
	}
	return(res);
}
//}

//{--- CLOSE BY FIX PROFIT
/*///===================================================================
	Ver:2012.02.10_0.0.01
	Описание:
		Проверяет возможность закрытия ордеров советника при выходе в 
		заданную фикс. прибыль
	На Входе:
		нет
	На Выходе:
		нет
/*///===================================================================
	void libCO_CFP_Check(){
		double lProfit = libFO_getProfit(Symbol(), MN);
		
		if(lProfit >= libCO_CFP_Profit){
			int lT = OrdersTotal();
			for(int idx_ord = lT; idx_ord >= 0; idx_ord --){
				if(!OrderSelect(idx_ord, SELECT_BY_POS, MODE_TRADES)) continue;
				//---
					int lO_ti = OrderTicket();	
				//---
				if(!checkOrderByTicket(lO_ti, CHK_TYLESS, Symbol(), MN, 2)) continue;
				//---
				libCO_CloseOrderByTicket(lO_ti);	
			}
		}
	}
//}

//{---- SPECIAL FUNCTION

/*///===================================================================
	Ver:2011.09.29_0.0.01
	---------------------
	Описание: Обертка для CloseMarketOrder
						Закрывает рыночный ордер по тикету.
	---------------------
	Доп. функции:
		CloseMarketOrder(int ticket)
	---------------------
	Переменные:
		int ticket - тикет ордера.
/*///-------------------------------------------------------------------
void libCO_CloseMarketOrder(int ticket){
	CloseMarketOrder(ticket);
}
//}

/*///===================================================================
   Ver:2012.02.01_0.0.01
   ---------------------
   Описание:
		Закрывает рыночный ордер с заданным тикетом.
   ---------------------
   Доп. функции:
   ---------------------
   Переменные:
		ticket		= логическое сравнение
/*///-------------------------------------------------------------------
bool libCO_CloseOrderByTicket(int ticket){
	if(!IsTradeAllowed()) return(false);
	//---
	if(!IsExpertEnabled()) return(false);
	//---
	bool res = false;
	//---
		if(!OrderSelect(ticket, SELECT_BY_TICKET)) return(true);
		//---
		while(IsTradeContextBusy()){
			Sleep(1000);
		}
		//---
		int try = 5;
		while(!res && try > 0){
			res = !OrderClose(OrderTicket(), OrderLots(), iif(OrderType()==OP_BUY,MarketInfo(Symbol(),MODE_BID),MarketInfo(Symbol(),MODE_ASK)), 1, CLR_NONE);
			try--;
		}
		//---
		int err = GetLastError();
		if(err > 1){
			logError("libCO_CloseOrderByTicket", "", err);
			OrderPrint();
		}
	return(res);
}