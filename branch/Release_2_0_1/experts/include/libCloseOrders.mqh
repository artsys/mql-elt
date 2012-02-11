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
 // ���� �������� eCloseByLots
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
  // ����� ����� �������� eCloseByLots
  //***************************************
}
  
//********************************************************************
// ���� �������� eCloseOrdersByLots_v4
//********************************************************************

//********************************************************************
//��������� ������� ������
//������*(1+����/100)
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
//������� ���������� �� ����� ��������� ����:
//1 - ��������
//2 - ��������
//3 - ����
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

//***** ���� �������� ������� ************************************** 
//==================================
//���������� ������ � ��������
// �� �����: ����� ������ ��� ��������
//�� ������: �������� �����
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
//������ ����� � ������������ �����
//������ ��� �����
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
//���������� ������ � ��������
//���� ����� �������� ������ � ������ ������ ���������� ��������,
//������� ��������� ���� �� ������ ����� � ���������� ������ �� ��� 
//��������
void prepareOrdersToClose(int rejim = 1) //1 - �������� �� ����������
                                         //2 - �������� ���� �������� ������� ��� �������� ������
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
// ����� ����� �������� eCloseOrdersByLots_v4
//********************************************************************
