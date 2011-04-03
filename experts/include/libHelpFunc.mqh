//+------------------------------------------------------------------+
//|                                                  libHelpFunc.mq4 |
//|                      Copyright © 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"

 #import "libHelpFunc.ex4"
   string libHelp_Ver();
   /*///===================================================================
      Версия: v1.0 : 2011.03.24
      /*///----------------------------------------------------------------
      void logInfo( string msg, string fn="");
      void logError( string functionName, string msg, int errorCode = -1 );
   
      void assert( string functionName, bool assertion, string description = "" );
      double iif( bool condition, double ifTrue, double ifFalse );
      int orderDirection(int type, int OP);
      
      void addInfo(string mess);
      void deinitInfo(); //использовать при деинициализации советника, чтоб удалить все объекты 
                         //созданные addInfo()
      //--------------------
      int StringToArrayString(string st, string& as[], string de=",");
      int StringToArrayDouble(string st, double& ad[]);
      string ErrorDescription(int error_code);
	  
	  double NormalizeLot(double lo, bool ro=False, string sy="");
   ////====================================================================
 #import
//+------------------------------------------------------------------+