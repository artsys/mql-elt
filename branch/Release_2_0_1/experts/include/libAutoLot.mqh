//{--- v2012.01.16

//}

//{--- auto lot																		
extern   string AL_DESC = "=========== AUTO_LOT SETUP ==========";
extern			double	al_LOT_fix           =    0.1				;	// ������������� ��������� ���
extern			bool	al_needAutoLots      =  false				;	// ��������� ���������� ������ ������������� ������
                     bool    al_useMarginMethod      = true			;	// ��������� ������������ ����� ������
extern               double  al_DepositPercent       =    1			;	// ������� �� �������� ��� ������� ������� ������                     
extern string MGP_END   = "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<";
//}

//{=== ������� ��������
	//********************************************************************
// ���� ������� ������
// v 2012.01.19
//----------------------------
double libAL_CalcLots(){
	if(!al_needAutoLots){
		return(al_LOT_fix);
	}

	double lot = 0;
	double lotPrice = MarketInfo(Symbol(),MODE_MARGINREQUIRED);
	double MaxLot = NormalizeDouble((AccountBalance() / lotPrice),2);
	double FirstLot = MaxLot;
   
   /*
	 if(al_useKoefMethod){
      FirstLot = depositKoef * (AccountBalance() / 100000);
   }
	 */
   
	if(al_useMarginMethod){   
		FirstLot = (((AccountBalance() / 100) * al_DepositPercent) / lotPrice);
	}
	lot = NormalizeLot(FirstLot, False, "");
	return (lot);
}
//----------------------------

//}