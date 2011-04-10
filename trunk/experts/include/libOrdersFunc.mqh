//+------------------------------------------------------------------+
//|                                                libOrdersFunc.mq4 |
//|                      Copyright © 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"

//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2005

 #import "libOrdersFunc.ex4"
   string   libOrders_Ver();
   void     libOrders_setFile_ord(  string str);
   
   double TwisePending(double nlot,double ulot,int rejim, double TL);
   
   bool     checkOrderByTicket   (  int    ticket,  int ORD_CHK,  string sy="",   int    MN = 0, int ty     = -1);
   int      OpenMarketSLTP_pip   (  string sy = "", int cmd = -1, double lot = 0, double pr = 0, int sl_pip =  0, int tp_pip = 0, string comm = "", int MN = 0, datetime exp = 0, color cl = CLR_NONE);
   int OpenPendingPRSLTP_pip(	string		sy		=	""			, 
							int			cmd		=	-1			, 
							double		lot		=	0			, 
							double		pr		=	0			, 
							int			sl_pip	=	0			, 
							int			tp_pip	=	0			, 
							string		comm	=	""			, 
							int			MN		=	0			, 
							datetime	exp		=	0			, 
							color		cl		=	CLR_NONE	);
   
	bool  isParentOrder(int ticket, int magic);
	bool isParentLive(int ticket);
	int getParentInHistory(int ticket);
	int getParentByTicket(int ticket);
	int getWasType(int ticket);
	bool ModifyOrder_TPSL_pip(int ticket, int tp_pip, int sl_pip, int magic);
	bool ModifyOrder_TPSL_price(int ticket, double tp_pr, double sl_pr, int magic);
	bool delPendingByTicket(int ticket);