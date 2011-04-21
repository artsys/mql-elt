//+------------------------------------------------------------------+
//|                                                  libHelpFunc.mq4 |
//|                      Copyright © 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"


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
#define  OP_SLTP   200
#define  OP_SORD   100

//======================================================================

/*///==================================================================
// Версия: 2011.03.24
//---------------------
// Описание:
// Возвращает версию библиотеки помощи :)
//---------------------
// Переменные:
//    нет
/*///-------------------------------------------------------------------
string libHelp_Ver(){
   return("v1.0");
}
//======================================================================

/*///===================================================================
// Версия: 2011.03.24
//---------------------
// Описание:
// логирует текст в окно сообщений
//---------------------
// Переменные:
//    msg = текст сообщения
/*///-------------------------------------------------------------------
void logInfo( string msg, string fn="")
{
    Print( "INFO: " + msg );
    if(StringLen(fn) > 0)
      Print( "INFO: in "+fn+"()");
}
//======================================================================

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      логирует ошибку в окно сообщений, дополняя код ошибки 
      человеческим описанием   
   ---------------------
   Доп. функции:
      .ErrorDescription( int err )
   ---------------------
   Переменные:
      functionName = имя функции
      msg          = текст сообщения
      errorCode    = код ошибки      

/*///-------------------------------------------------------------------
void logError( string functionName, string msg, int errorCode = -1 )
{
    Print( "ERROR: in " + functionName + "()" );
    Print( "ERROR: " + msg );
    
    int err = GetLastError();
    if( errorCode != -1 ) err = errorCode;
        
    if( err > 0 ) 
    {
        Print( "ERROR: code=" + err + " - " + ErrorDescription( err ) );
    }    
}
//======================================================================

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      логирует результат сравнения в окно сообщений, 
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      functionName = имя функции
      assertion    = логическая операция
      description  = описание      

/*///-------------------------------------------------------------------
void assert( string functionName, bool assertion, string description = "" )
{
    if( !assertion ) Print( "ASSERT: in " + functionName + "() - " + description );
}
//======================================================================

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      возвращает значение в зависимости от результата
      логического сравнения 
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      condition    = логическое сравнение
      ifTrue       = значение в случае condition = ИСТИНА
      ifFalse      = значение в случае condition = ЛОЖЬ

/*///-------------------------------------------------------------------
double iif( bool condition, double ifTrue, double ifFalse )
{
    if( condition ) return( ifTrue );
    
    return( ifFalse );
}


/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      возвращает значение в зависимости от результата
      логического сравнения 
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      type         = тип ордера
      OP           = используемая операция
         может принимать значения OP_SLTP (установка сл и тп для ордера)
                                  OP_SORD (открытие позиции) 
      

/*///-------------------------------------------------------------------
int orderDirection(int type, int OP){
   int res = 0;
   //---
   if(   type == OP_BUY       || 
         type == OP_SELLLIMIT || 
         type == OP_BUYSTOP      ) res = 1;
   //---   
   if(   type == OP_SELL      || 
         type == OP_BUYLIMIT  || 
         type == OP_SELLSTOP     ) res = -1;   
   //---   
   //если реверс = 1, то это для выставления ордера, если = -1 то для 
   //расчета стопов и тейков
   
   if(   type == OP_BUYLIMIT  || 
         type == OP_SELLLIMIT    ) res = res * iif(OP == OP_SLTP,-1,1);   
   //--- 
   
    logInfo("type = "+type+"; res = "+res,"oD");
    return(res);
}
//======================================================================

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      Выводит на экран текст сообщения в левом нижнем углу
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      condition    = логическое сравнение
      ifTrue       = значение в случае condition = ИСТИНА
      ifFalse      = значение в случае condition = ЛОЖЬ

/*///-------------------------------------------------------------------
string info[3];

//--- деинициализация инфо-сообщений
void deinitInfo(){
   
   string oName = StringConcatenate(EXP_NAME,"_info");

   int obj_tot = ObjectsTotal();
   for(int i = 0; i < obj_tot; i++){
      if(StringFind(ObjectName(i), oName) > -1){
         ObjectDelete(ObjectName(i));
      }
   }   
}
//---
void upInfo(){
   int ks = ArraySize(info);
   for(int i = 1; i < ks; i++){
      info[i-1] = info[i];
   }
}

void ShowInfo(){
   
   int y_startdistance = 50;

   int ks = ArraySize(info);
   string infoName = "info";
   for(int i = 0; i < ks ; i++){
      string oName = StringConcatenate(EXP_NAME,"_",infoName,i);
      if(ObjectFind(oName) == -1){
        ObjectCreate(oName,OBJ_LABEL,0,0,0);
      }
      
      ObjectSet(oName,OBJPROP_XDISTANCE,30);
      ObjectSet(oName,OBJPROP_YDISTANCE,y_startdistance-i*20);
      ObjectSet(oName,OBJPROP_CORNER,2);
      //--- color
      if(i == 0){
         color clr = Red;
      }
      
      if(i == 1){
         clr = Coral;
      }
      
      if(i == 2){
         clr = Silver;
      }
      
      ObjectSetText(oName, info[ks-1-i], 10, "Arial", clr);
   }
}

void addInfo(string mess){
   upInfo(); 
   
   string sTime = TimeToStr(TimeLocal(),TIME_DATE|TIME_MINUTES); 
   mess = StringConcatenate(mess," | ",sTime); 
   info[2] = mess;
   ShowInfo(); 
}

//======================================================================

//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 23.06.2008                                                     |
//|  Описание : Разбиение строки на массив элементов                           |
//+----------------------------------------------------------------------------+
//|  Возврат:                                                                  |
//|    Количество элементов в массиве                                          |
//|  Параметры:                                                                |
//|    st - строка с разделителями                                             |
//|    as - строковый массив                                                   |
//|    de - разделитель                                                        |
//+----------------------------------------------------------------------------+
int StringToArrayString(string st, string& as[], string de=",") { 
  int    i=0, np;
  string stp;

  ArrayResize(as, 0);
  while (StringLen(st)>0) {
    np=StringFind(st, ",");
    if (np<0) {
      stp=st;
      st="";
    } else {
      stp=StringSubstr(st, 0, np);
      st=StringSubstr(st, np+1);
    }
    i++;
    ArrayResize(as, i);
    as[i-1]=stp;
  }
  return(ArraySize(as));
}

//+----------------------------------------------------------------------------+
//|  Автор    : Ким Игорь В. aka KimIV,  http://www.kimiv.ru                   |
//+----------------------------------------------------------------------------+
//|  Версия   : 10.10.2008                                                     |
//|  Описание : Перенос вещественных чисел из строки в массив                  |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    st - строка вещественных чисел через точку с запятой                    |
//|    ad - массив вещественных чисел                                          |
//+----------------------------------------------------------------------------+
//|  Возврат:                                                                  |
//|    Количество элементов в массиве                                          |
//+----------------------------------------------------------------------------+
int StringToArrayDouble(string st, double& ad[]) {
  int    i=0, np;
  string stp;

  ArrayResize(ad, 0);
  while (StringLen(st)>0) {
    np=StringFind(st, ",");
    if (np<0) {
      stp=st;
      st="";
    } else {
      stp=StringSubstr(st, 0, np);
      st=StringSubstr(st, np+1);
    }
    i++;
    ArrayResize(ad, i);
    ad[i-1]=StrToDouble(stp);
  }
  return(ArraySize(ad));
}



//+------------------------------------------------------------------+
//| return error description                                         |
//+------------------------------------------------------------------+
string ErrorDescription(int error_code)
  {
   string error_string;
//----
   switch(error_code)
     {
      //---- codes returned from trade server
      case 0:
      case 1:   error_string="no error";                                                  break;
      case 2:   error_string="common error";                                              break;
      case 3:   error_string="invalid trade parameters";                                  break;
      case 4:   error_string="trade server is busy";                                      break;
      case 5:   error_string="old version of the client terminal";                        break;
      case 6:   error_string="no connection with trade server";                           break;
      case 7:   error_string="not enough rights";                                         break;
      case 8:   error_string="too frequent requests";                                     break;
      case 9:   error_string="malfunctional trade operation (never returned error)";      break;
      case 64:  error_string="account disabled";                                          break;
      case 65:  error_string="invalid account";                                           break;
      case 128: error_string="trade timeout";                                             break;
      case 129: error_string="invalid price";                                             break;
      case 130: error_string="invalid stops";                                             break;
      case 131: error_string="invalid trade volume";                                      break;
      case 132: error_string="market is closed";                                          break;
      case 133: error_string="trade is disabled";                                         break;
      case 134: error_string="not enough money";                                          break;
      case 135: error_string="price changed";                                             break;
      case 136: error_string="off quotes";                                                break;
      case 137: error_string="broker is busy (never returned error)";                     break;
      case 138: error_string="requote";                                                   break;
      case 139: error_string="order is locked";                                           break;
      case 140: error_string="long positions only allowed";                               break;
      case 141: error_string="too many requests";                                         break;
      case 145: error_string="modification denied because order too close to market";     break;
      case 146: error_string="trade context is busy";                                     break;
      case 147: error_string="expirations are denied by broker";                          break;
      case 148: error_string="amount of open and pending orders has reached the limit";   break;
      case 149: error_string="hedging is prohibited";                                     break;
      case 150: error_string="prohibited by FIFO rules";                                  break;
      //---- mql4 errors
      case 4000: error_string="no error (never generated code)";                          break;
      case 4001: error_string="wrong function pointer";                                   break;
      case 4002: error_string="array index is out of range";                              break;
      case 4003: error_string="no memory for function call stack";                        break;
      case 4004: error_string="recursive stack overflow";                                 break;
      case 4005: error_string="not enough stack for parameter";                           break;
      case 4006: error_string="no memory for parameter string";                           break;
      case 4007: error_string="no memory for temp string";                                break;
      case 4008: error_string="not initialized string";                                   break;
      case 4009: error_string="not initialized string in array";                          break;
      case 4010: error_string="no memory for array\' string";                             break;
      case 4011: error_string="too long string";                                          break;
      case 4012: error_string="remainder from zero divide";                               break;
      case 4013: error_string="zero divide";                                              break;
      case 4014: error_string="unknown command";                                          break;
      case 4015: error_string="wrong jump (never generated error)";                       break;
      case 4016: error_string="not initialized array";                                    break;
      case 4017: error_string="dll calls are not allowed";                                break;
      case 4018: error_string="cannot load library";                                      break;
      case 4019: error_string="cannot call function";                                     break;
      case 4020: error_string="expert function calls are not allowed";                    break;
      case 4021: error_string="not enough memory for temp string returned from function"; break;
      case 4022: error_string="system is busy (never generated error)";                   break;
      case 4050: error_string="invalid function parameters count";                        break;
      case 4051: error_string="invalid function parameter value";                         break;
      case 4052: error_string="string function internal error";                           break;
      case 4053: error_string="some array error";                                         break;
      case 4054: error_string="incorrect series array using";                             break;
      case 4055: error_string="custom indicator error";                                   break;
      case 4056: error_string="arrays are incompatible";                                  break;
      case 4057: error_string="global variables processing error";                        break;
      case 4058: error_string="global variable not found";                                break;
      case 4059: error_string="function is not allowed in testing mode";                  break;
      case 4060: error_string="function is not confirmed";                                break;
      case 4061: error_string="send mail error";                                          break;
      case 4062: error_string="string parameter expected";                                break;
      case 4063: error_string="integer parameter expected";                               break;
      case 4064: error_string="double parameter expected";                                break;
      case 4065: error_string="array as parameter expected";                              break;
      case 4066: error_string="requested history data in update state";                   break;
      case 4099: error_string="end of file";                                              break;
      case 4100: error_string="some file error";                                          break;
      case 4101: error_string="wrong file name";                                          break;
      case 4102: error_string="too many opened files";                                    break;
      case 4103: error_string="cannot open file";                                         break;
      case 4104: error_string="incompatible access to a file";                            break;
      case 4105: error_string="no order selected";                                        break;
      case 4106: error_string="unknown symbol";                                           break;
      case 4107: error_string="invalid price parameter for trade function";               break;
      case 4108: error_string="invalid ticket";                                           break;
      case 4109: error_string="trade is not allowed in the expert properties";            break;
      case 4110: error_string="longs are not allowed in the expert properties";           break;
      case 4111: error_string="shorts are not allowed in the expert properties";          break;
      case 4200: error_string="object is already exist";                                  break;
      case 4201: error_string="unknown object property";                                  break;
      case 4202: error_string="object is not exist";                                      break;
      case 4203: error_string="unknown object type";                                      break;
      case 4204: error_string="no object name";                                           break;
      case 4205: error_string="object coordinates error";                                 break;
      case 4206: error_string="no specified subwindow";                                   break;
      default:   error_string="unknown error";
     }
//----
   return(error_string);
  }

  //+----------------------------------------------------------------------------|
//|  Описание : Возвращает нормализованное значение торгуемого лота.           |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    lo - нормализуемое значение лота.                                       |
//|    ro - способ округления          (   False    - в меньшую,               |
//|                                        True     - в большую сторону)       |
//|    sy - наименование инструмента   ("" или NULL - текущий символ)          |
//+----------------------------------------------------------------------------+
double NormalizeLot(double lo, bool ro=False, string sy="") {
  double l, k;
  if (sy=="" || sy=="0") sy=Symbol();
  double ls=MarketInfo(sy, MODE_LOTSTEP);
  double ml=MarketInfo(sy, MODE_MINLOT);
  double mx=MarketInfo(sy, MODE_MAXLOT);

  if (ml==0) ml=0.1;
  if (mx==0) mx=100;

  if (ls>0) k=1/ls; else k=1/ml;
  if (ro) l=MathCeil(lo*k)/k; else l=MathFloor(lo*k)/k;

  if (l<ml) l=ml;
  if (l>mx) l=mx;

  return(l);
}