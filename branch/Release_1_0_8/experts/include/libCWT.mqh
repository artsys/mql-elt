//Библиотека проверок разрешения работы советника
// Версия 1.0 0605_12

extern string ex_CWT    = ">>>>>>>>>> CAN WE TRADE =====";
extern string 	ex_CWT_TT = "----------- TRADE TIME";
extern bool       CWT_needStopOnTime = false;
extern string     CWT_startTradeTime = "03:00";
extern string     CWT_endTradeTime   = "18:00";
extern string ex_CWT_END = "===================================================";


//+------------------------------------------------------------------+
// проверка времени разрешения работы 
// v 22.09.2009
// проверка временного интервала работы
//+------------------------------------------------------------------+
bool libCWT_canWeTrade(){
   
   //if(stopAutoOpen)
   //   return(false);
   
   if(!CWT_needStopOnTime)
      return(true);

   string sthisStartTime = StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",CWT_startTradeTime);
   string sthisEndTime = StringConcatenate(TimeToStr(TimeCurrent(),TIME_DATE)," ",CWT_endTradeTime);
   datetime thisStartTime = StrToTime(sthisStartTime);
   datetime thisEndTime = StrToTime(sthisEndTime);
   
   bool res = false;
   
   
   if(TimeCurrent() > thisStartTime && TimeCurrent() < thisEndTime){
      
      return(true);
   }
   
   addInfo(StringConcatenate("STOP AUTOOPEN !!!!",""));        
   return(res);
}

