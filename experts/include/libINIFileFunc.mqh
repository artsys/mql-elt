//+------------------------------------------------------------------+
//|                                               libINIFileFunc.mq4 |
//|                      Copyright © 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"

#import "libINIFileFunc.ex4"
   string   libINIFile_Ver();
   //---
   void addRecordInFileOrders(string filename,	string file_comm);
   string returnComment(string comm, string rejim = "");
   //--- Работа с ини файлом
   string   ReadIniString  (string FileName, string SectionName, string KeyName, string   Default   = "-1" );
   bool     ReadIniBool    (string FileName, string SectionName, string KeyName, bool     bDefault  = False);
   double   ReadIniDouble  (string FileName, string SectionName, string KeyName, double   dDefault  =  0.0 );
   datetime ReadIniTime    (string FileName, string SectionName, string KeyName, datetime dtDefault =  0   );
   int      ReadIniInteger (string FileName, string SectionName, string KeyName, int      iDefault  = -1   );
   void     ReadIniArrayInt(string FileName, string SectionName, string KeyName, int&     aiParam[]        );
   
   void     WriteIniArrayInt(string FileName, string SectionName, string KeyName, int&     aiParam[]);
   void     WriteIniBool    (string FileName, string SectionName, string KeyName, bool     bParam   );
   void     WriteIniDouble  (string FileName, string SectionName, string KeyName, double   dParam   );
   void     WriteIniTime    (string FileName, string SectionName, string KeyName, datetime dtParam  );
   void     WriteIniInteger (string FileName, string SectionName, string KeyName, int      iParam   );
   void     WriteIniString  (string FileName, string SectionName, string KeyName, string   sParam   );
   
   

