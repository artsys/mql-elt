extern string libTralingStop = "==== lib TRALING STOP";
extern 	bool	libTrSl_UseTralingStop = false;	// ������������ �������� ����
extern	bool		libTrSl_ProfitTraling	= true;	// ������� ������ ������
extern	int			libTrSl_TralingSTOP		= 50;	// ������������� ������ �����
extern	int			libTrSl_TralingSTEP		= 5;	// ��� �����

/*///===================================================================
	������: 2011.07.11
	---------------------
	��������:
		������������� ��������� ������ ������� ������
	---------------------
	���. �������:
		���
	---------------------
	����������:
		ticket	- ����� ������ ��� �����
/*///-------------------------------------------------------------------
bool libTrSl_TralingSimple(int ticket){
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