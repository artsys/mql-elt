//--------------------------------------
extern string    ex_CLOSE_BY_PROFIT      = "--- SETUP: Close by Profit ---";
extern bool         needCloseByLots         = true;
extern double       growEquityPercent       = 1;
extern int          waitsec                 = 5;
extern string    ex_END_CLOSE_BY_LOTS  = "===================================================";


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
