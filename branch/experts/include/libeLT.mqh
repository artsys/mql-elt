//+------------------------------------------------------------------+
//|                                                       libeLT.mq4 |
//|                      Copyright © 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"

#import "libeLT.ex4"
   void   libeLT_setFile_ord(string str);
   string libeLT_Ver();
   int    getGrid(int ticket);
   double  calcPrice(double parent_pr, int parent_type, int pip);
   double  calcTPPrice(double pr, int type, int pip);
   int getOrderLevel(int ticket);
   int isMarketLevel(int parent_ticket, int level, int magic);

   string getLevelOpenedVol(int parent_ticket, int level, int type, int magic);