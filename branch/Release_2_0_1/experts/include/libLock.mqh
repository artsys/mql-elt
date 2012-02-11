//������:	2011.08.24
//��������:	��������� �������� � ����� ������� ����������� �������� �������
//			������� � ���� ������� �� � ��.
//			���������� ������ ��� ����������� ������� ��� �� � ��.
//			��������� ���������� ���������� exp_name+symbol()+locked = 1.
//			���������� ����� BUYLIMIT �� ���� 0.01 � ������������ "@locked_1";
//			�� ����� ������ � ���������� �����������, ��� ���� ���������� � ��������� ������� �� �����.
//��������:	1. ������������ ������� ��� �������� ��������� � ����� ������� �����������.
//			2. ������� �� � �� � �������� �������.
//			3. ������� ��� ���������� ������.
//			4. ���������� �������� ������ ��� ������������ ������ � ��������� "@lock_1";
//			5. �������� ������� �������� �������.
//			6. ����������� BUYLIMIT �� ���� 0.01 � ������������ "@locked_1";
//{
extern string LOCK = "=========== LOCK SETUP =========="; 
extern		bool libLck_useLock	= false;					// ��������� ��������� ������������ ������ �����������.
extern			bool libLck_useStopOrder	= true;
extern			bool libLck_usePercentALG	= true;			//		��������� ������������ �������� ���������� �� ������.
extern				int	libLck_MaxDD		= 30;			//			������������ �������� �� ������.
extern			bool libLck_useVolALG		= false;		//		��������� ������������ �������� ���������� �� ����. ������
extern				int libLck_MaxVol		= 120;			//			������������ �������� �����.
extern string LOCK_END = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";
//}

#define lck_WORK	-1	//- �������� ����� ���������� ������
#define lck_STOP	100	//- �������� ���������� ������. 

/*///===================================================================
	������: 2011.08.22
	---------------------
	��������:
		��������� ����������� �����������
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
	---------------------
	�������:
		lck_WORK	- �������� ����� ���������� ������
		lck_STOP	- �������� ���������� ������.
/*///-------------------------------------------------------------------
int libLck_checkLocking(double parent_op = 0, int lck_addpip = 0, int flag = 0){
	int res	= lck_WORK;
	
		libLck_checkDelPendingLock();
		if(!libLck_useLock) return(lck_WORK);
	
		bool needLock = false;
		if(libLck_isSyLocked()){
			if(flag == 1) return(lck_STOP);
			//---
			libLck_delTPSL();
			return(lck_STOP);
		}
		//---
		if(flag == 1) return(res);
		//---
		if(libLck_usePercentALG){
			if(maxDDPercent >= libLck_MaxDD)
				needLock = true;
		}else{
			if(libLck_useVolALG){
				if(getOpenedVolum(OP_BUY) >= libLck_MaxVol || getOpenedVolum(OP_SELL) >= libLck_MaxVol){
					needLock = true;
				}
			}
		}
		//---
		if(needLock){
			res = libLck_setLockSy("",parent_op,lck_addpip);
		}	
	return(res);
}

int libLck_setLockSy(string sy = "", double parent_op = 0, int lck_pip = 0){
	if(sy == "")
		sy = Symbol();
		
	//{ --- �������� ���������� �������.	
	int t = OrdersTotal();
	for(int i = t; i >= 0; i--){
		if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
		//---
		int		o_ticket	= OrderTicket();
		string	o_comm		= OrderComment();
		int		o_type		= OrderType();
		//---
		if(!checkOrderByTicket(o_ticket, CHK_TYMORE, Symbol(), MN, 2)) continue; // ��������, ���� ����� ��� ����� � ����������
		//---
		delPendingByTicket(o_ticket);
	}
	//}
	double volBUY = getOpenedVolum(OP_BUY);
	double volSELL = getOpenedVolum(OP_SELL);
	
	double nvolSend = volBUY-volSELL;
	Print("nvolSend = ", nvolSend);
	int ncmdSend = -1;
	int ncmdSend_Stop = -1;
	if(nvolSend > 0){
		ncmdSend = OP_SELL;
		ncmdSend_Stop = OP_SELLSTOP;
	}else{
		if(nvolSend < 0){
			ncmdSend = OP_BUY;
			ncmdSend_Stop = OP_BUYSTOP;
		}
	}
	nvolSend = MathAbs(nvolSend);
	
	//{--- ����������� ������� �� ������� ������
	double	needSendVol = nvolSend;
		int	sendCount = TwisePending(needSendVol,	0,	TL_COUNT, TWISE_LOTS);
		double	used_send_vol = 0;
		for(int ord_count = 1; ord_count <= sendCount; ord_count++){
			double send_vol = TwisePending(needSendVol, used_send_vol, TL_VOL, TWISE_LOTS);
			used_send_vol = used_send_vol + send_vol;
			//{---
			if(!libLck_useStopOrder){
				int children_ticket = OpenMarketSLTP_pip(	Symbol(),
															ncmdSend,
															send_vol,
															0,
															0,
															0,
															"@lock_1",
															MN,
															0,
															CLR_NONE);
			}else{
				children_ticket = OpenPendingPRSLTP_pip(	Symbol()
															,	ncmdSend_Stop
															,	send_vol
															,	parent_op
															,	lck_pip
															,	0
															,	0
															,	"@lock_2"
															,	MN
															,	0
															,	CLR_NONE);
			}
		}												
	//}
	if(libLck_delTPSL())
		bool tpsl_deleted = true;
	//---
	OpenPendingPRSLTP_pip(	Symbol()
						,	OP_BUYLIMIT
						,	al_LOT_fix
						,	NormalizeDouble(1*Point, Digits)
						,	0
						,	0
						,	0
						,	"@locked_1"
						,	MN
						,	0
						,	CLR_NONE);
	
	return(lck_STOP);
}

/*///===================================================================
	������: 2011.08.22
	---------------------
	��������:
		��������� ���������� �� ����� � ��������� "@locked_1";
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
/*///-------------------------------------------------------------------
bool libLck_isSyLocked(string sy = ""){
	if(sy == "")
		sy = Symbol();
	//---	
	int t = OrdersTotal();
	for(int i = t; i >= 0; i--){
		if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
		int		o_ticket	= OrderTicket();
		string	o_comm		= OrderComment();
		
		if(!checkOrderByTicket(o_ticket, CHK_MN, Symbol(), MN, -1)) continue; // ��������, ���� ����� ��� �����
		if(StrToInteger(returnComment(o_comm,"@locked_")) > -1)
			return(true);
	}
	return(false);
}

/*///===================================================================
	������: 2011.08.29
	---------------------
	��������:
		������� �� � �� � �������� �������.
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
/*///-------------------------------------------------------------------
bool libLck_delTPSL(){
	bool res = true;
	int t = OrdersTotal();
	for(int i = t; i >= 0; i--){
		if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
			int o_ticket = OrderTicket();
		
		if(!checkOrderByTicket(o_ticket, CHK_TYLESS, Symbol(), MN, 1)) continue; // ��������, ���� ����� ��� ����� � ����������	
		//---
		if(!libLck_useStopOrder 
			|| isOrderWithParam("@lock_", "2", "", MN, OP_BUY) 
			|| isOrderWithParam("@lock_", "2", "", MN, OP_SELL)){
			_OrderModify( o_ticket, -1, 0, 0, MN, -1, CLR_NONE);
		}
	}
	return(res);
}

/*///===================================================================
	������: 2011.08.29
	---------------------
	��������:
		������� ������������ ���������� ������, ���� ��� �� �����
	---------------------
	���. �������:
		���
	---------------------
	����������:
		���
/*///-------------------------------------------------------------------
void libLck_checkDelPendingLock(){
	if(getOpenedVolum(OP_BUY) == 0 && getOpenedVolum(OP_SELL) == 0){
	
		int t = OrdersTotal();
		for(int i = t; i >= 0; i--){
			if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
				int o_ticket = OrderTicket();
				string o_comm	 = OrderComment();
		
			if(!checkOrderByTicket(o_ticket, CHK_TYMORE, Symbol(), MN, 2)) continue; // ��������, ���� ����� ��� ����� � ����������	
			Print("o_ticket - ",o_ticket);
			//---
			if(StrToInteger(returnComment(o_comm,"@lock_")) <= -1 && StrToInteger(returnComment(o_comm,"@locked_")) <= -1) continue;
			//---
			delPendingByTicket(o_ticket);
		}
	}	
}