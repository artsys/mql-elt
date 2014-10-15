// v. 2012.01.16

extern string	aoMethods = ">>>>>>>>> AUTO OPEN METHODS =========";
//{=== BAR OPEN
	extern string		ex_BAR_OPEN = "--- 1 TF BAR OPEN";
	extern bool       libAO_needBarsOpen = false; //нужно ли открытие при начале бара
		extern int        BO_filter_pip = 20;  //сколько очков ждем для определения направления открытия
		extern int        BO_TF_min = 1440; //тайм фрейм в минутах
	//---
	extern string		ex_BAR_OPEN_1 = "--- 2 TF BAR OPEN";   
	//extern bool       needBarOpen1 = false; //нужно ли открытие при начале бара
		extern int        BO1_filter_pip = 10;  //сколько очков ждем для определения направления открытия
		extern int        BO1_TF_min = 240; //тайм фрейм в минутах
	//---
	extern string		ex_BAR_OPEN_2 = "--- 3 TF BAR OPEN";   
	//extern bool       needBarOpen2 = false; //нужно ли открытие при начале бара
		extern int        BO2_filter_pip = 10;  //сколько очков ждем для определения направления открытия
		extern int        BO2_TF_min = 60; //тайм фрейм в минутах
	extern string		ex_REVERS = "--- REVERS SIGNAL";
		extern bool				libAO_BORevers = false; // разрешает советнику открывалься в прот. направлении сигналу.	
//}

//=================================================================================================
//*******************************************************************
// Блок открытия по направлению бара
// Ver: 2012.02.02
//*******************************************************************
void libAO_BarOpen(){
   if(!libAO_needBarsOpen) return;
   double ob = iOpen(Symbol(),BO_TF_min,0);
   double bd = 0; 
   
   if((MarketInfo(Symbol(),MODE_BID) - ob)/Point > 1)
         bd = MarketInfo(Symbol(),MODE_BID);
   else
      if((ob - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
         bd = MarketInfo(Symbol(),MODE_ASK);      
      else
         bd = -1;   
   //---
   
   double ob1 = iOpen(Symbol(),BO1_TF_min,0);
   double bd1 = 0; 
   
   if((MarketInfo(Symbol(),MODE_BID) - ob1)/Point > 1)
         bd1 = MarketInfo(Symbol(),MODE_BID);
   else
      if((ob1 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
         bd1 = MarketInfo(Symbol(),MODE_ASK); 
      else
         bd1 = -1;        
   //---
   double ob2 = iOpen(Symbol(),BO2_TF_min,0);
   double bd2 = 0; 
   
   if((MarketInfo(Symbol(),MODE_BID) - ob2)/Point > 1)
         bd2 = MarketInfo(Symbol(),MODE_BID);
   else
      if((ob2 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
         bd2 = MarketInfo(Symbol(),MODE_ASK);      
      else
         bd2 = -1;   
   //---
   /*
   double ob3 = iOpen(Symbol(),BO3_TF_min,0);
   double bd3 = 0; 
   
   if((MarketInfo(Symbol(),MODE_BID) - ob3)/Point > 1)
         bd3 = MarketInfo(Symbol(),MODE_BID);
   else
      if((ob3 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
         bd3 = MarketInfo(Symbol(),MODE_ASK);      
      else
         bd3 = -1;         
   
      //---
   double ob4 = iOpen(Symbol(),BO4_TF_min,0);
   double bd4 = 0; 
   
   if((MarketInfo(Symbol(),MODE_BID) - ob4)/Point > 1)
         bd4 = MarketInfo(Symbol(),MODE_BID);
   else
      if((ob4 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
         bd4 = MarketInfo(Symbol(),MODE_ASK);      
      else
         bd4 = -1;         
      //---
      double ob5 = iOpen(Symbol(),BO5_TF_min,0);
      double bd5 = 0; 
   
      if((MarketInfo(Symbol(),MODE_BID) - ob5)/Point > 1)
            bd5 = MarketInfo(Symbol(),MODE_BID);
      else
         if((ob5 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
            bd5 = MarketInfo(Symbol(),MODE_ASK);      
         else
            bd5 = -1;         
         //---
   double ob6 = iOpen(Symbol(),BO6_TF_min,0);
   double bd6 = 0; 
   
   if((MarketInfo(Symbol(),MODE_BID) - ob6)/Point > 1)
         bd6 = MarketInfo(Symbol(),MODE_BID);
   else
      if((ob6 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
         bd6 = MarketInfo(Symbol(),MODE_ASK);      
      else
         bd6 = -1;         
   */
   //---
   
	if((bd - ob) / Point > BO_filter_pip && bd > -1){
		//Дневки бай
		if((bd1 - ob1) / Point > BO1_filter_pip && bd1 > -1){
			if((bd2 - ob2) / Point > BO2_filter_pip && bd2 > -1){
				/*if((bd3 - ob3) / Point > BO3_filter_pip && bd3 > -1){
					if((bd4 - ob4) / Point > BO4_filter_pip && bd4 > -1){
						if((bd5 - ob5) / Point > BO5_filter_pip && bd5 > -1){
							if((bd6 - ob6) / Point > BO6_filter_pip && bd6 > -1){*/
								//openFirst(OP_BUY, "bar open buy 1", mBOB);
						if(!isOrderWithParam("@o", "BOB", "", MN, -1)){
							OpenMarketSLTP_pip(	Symbol(),
												iif(!libAO_BORevers,OP_BUY,OP_SELL),
												libAL_CalcLots(),
												0,
												0,
												0,
												"@ip1@oBOB",
												MN,
												0,
												CLR_NONE);
						}						
							/*}   
						}   
					}   
				}*/   
			}   
		}   
	}
   //===
   if((ob - bd) / Point > BO_filter_pip && bd > -1){
      if((ob1 - bd1) / Point > BO1_filter_pip && bd1 > -1){
         if((ob2 - bd2) / Point > BO2_filter_pip && bd2 > -1){
            /*if((ob3 - bd3) / Point > BO3_filter_pip && bd3 > -1){
               if((ob4 - bd4) / Point > BO4_filter_pip && bd4 > -1){
                  if((ob5 - bd5) / Point > BO5_filter_pip && bd5 > -1){
                     if((ob6 - bd6) / Point > BO6_filter_pip && bd6 > -1){*/
                        if(!isOrderWithParam("@o", "BOS", "", MN, -1)){
													OpenMarketSLTP_pip(	Symbol(),
																		iif(!libAO_BORevers,OP_SELL,OP_BUY),
																		libAL_CalcLots(),
																		0,
																		0,
																		0,
																		"@ip1@oBOS",
																		MN,
																		0,
																		CLR_NONE);
												}
                     /*}
                  }
               }
            }*/            
         }   
      }   
   } 
}
//*******************************************************************
//Конец Блока открытия по направлению бара
//*******************************************************************

//{======= Открытие в канале МА_HL_pip
	#define OMCB "MCB" 
	#define OMCS "MCS" 

	extern string	libAO_MAHL = ">>>>>>> iWORM OPEN";
		extern bool		libAO_MAHL_useOpen = false;	// разрешает советнику открытие в канале МА_HL_pip
			//{--- Настройки индикатора
				extern	int		libAO_MAHL_MA_pip					= 20;		// 
				extern	int		libAO_MAHL_MA_Level_pip		= 20;
				extern	int		libAO_MAHL_MA_per					=	144;
				extern	int		libAO_MAHL_TFmin					=	15; // тф в минутах
				extern	int		libAO_MAHL_Delta_pip			= 10; // расстояние от границы канала, при котором выставляются стартовые отложенники.	
			//}
			
	void libAO_MAHL_Open(){
		if(!libAO_MAHL_useOpen) return;
	
		if (isOrderWithParam("@o", "MCB", "", MN, -1) ||
				isOrderWithParam("@o", "MCS", "", MN, -1))  {
					libAO_MAHL_deleteParentSO();
					return;
		}else{
			double	ma_h = iCustom(Symbol(), libAO_MAHL_TFmin, "iWorm_v1", libAO_MAHL_MA_pip, libAO_MAHL_MA_Level_pip, libAO_MAHL_MA_per,1, 0);
			double	ma_l = iCustom(Symbol(), libAO_MAHL_TFmin, "iWorm_v1", libAO_MAHL_MA_pip, libAO_MAHL_MA_Level_pip, libAO_MAHL_MA_per,2, 0);
			
			if(Bid > (ma_l + libAO_MAHL_Delta_pip*Point) && Bid < (ma_h - libAO_MAHL_Delta_pip*Point)){
				
				OpenPendingPRSLTP_pip(Symbol()		, 
															OP_BUYSTOP	, 
															libAL_CalcLots()	, 
															ma_h				, 
															0						, 
															0						, 
															0						, 
															"@ip1@oMCB"	, 
															MN					, 
															0						, 
															CLR_NONE);

				OpenPendingPRSLTP_pip(Symbol()		, 
															OP_SELLSTOP	, 
															libAL_CalcLots()	, 
															ma_l				, 
															0						, 
															0						, 
															0						, 
															"@ip1@oMCS"	, 
															MN					, 
															0						, 
															CLR_NONE);

			}else{
				return;
			}
		}
	}

		
	void libAO_MAHL_deleteParentSO(){
		if(!isOrderWithParam("@o", "MCB", Symbol(), MN, 0) &&
				!isOrderWithParam("@o", "MCB", Symbol(), MN, 1) &&
				!isOrderWithParam("@o", "MCS", Symbol(), MN, 0) &&
				!isOrderWithParam("@o", "MCS", Symbol(), MN, 1) 		) return;
		//---
		int t = OrdersTotal();
		
		for(int i = t; i >=0; i--){
			if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
			//---
			int o_ti = OrderTicket();
			string o_comm = OrderComment();
			//---
			if(checkOrderByTicket(o_ti, CHK_TYLESS, Symbol(), MN, 1)) continue;
			//---
			if(returnComment(o_comm,"@o") == OMCB || returnComment(o_comm,"@o") == OMCS){
				if(StrToInteger(returnComment(o_comm,"@p")) == -1){
					delPendingByTicket(o_ti, "libAO");
				}
			}
		}
	}
//}

//{ --- MA envelope
#define MAENVInBUY "oMEIB"
#define MAENVInSELL "oMEIS"

extern string libAO_MAEnvIn=">>>>>>>>>> MA Envelopes in";
	extern bool libAO_MAEnvIn_useOpen=false;
		extern int libAO_MAEnvIn_MAPer=50;
		extern int libAO_MAEnvIn_MAMethod=1;
		extern int libAO_MAEnvIn_MAAppPr=0;
		extern string libAO_MAEnvIn_Levels="50;-50;100;-100;200;-200;300;-300";
	void libAO_MAEnvIn_Open(){
		int sig[];
		libAO_MAEnvIn_Signal(sig);
		
		if(sig[0]<=-1){
			return;
		}
		
		if(isOrderWithParam("@o", "MEIB", "", MN, -1) ||
			isOrderWithParam("@o", "MEIS", "", MN, -1)){
				return;	
		}
		
		if(sig[0]==OP_BUYSTOP){
			OpenMarketSLTP_pip(	Symbol(),OP_BUY,libAL_CalcLots(),0,0,0,"@ip1@oMEIB",MN,0,CLR_NONE);
		}
		
		if(sig[0]==OP_SELLSTOP){
			OpenMarketSLTP_pip(	Symbol(),OP_SELL,libAL_CalcLots(),0,0,0,"@ip1@oMEIS",MN,0,CLR_NONE);
		}
	}
	
	void libAO_MAEnvIn_Signal(int &sig[]){
	   
	   ArrayResize(sig,0);
	   ArrayResize(sig,2);
	   double ma=iMA(NULL,0,libAO_MAEnvIn_MAPer,0,libAO_MAEnvIn_MAMethod,libAO_MAEnvIn_MAAppPr,1);
	   
	   string asMALvl[];
	   ArrayResize(asMALvl,0);
	   StringToArrayString(libAO_MAEnvIn_Levels,asMALvl,";");//,";");
	   
	   int rows=ArrayRange(asMALvl,0);
	   for(int i=0;i<rows;i++){
		  string sMALvl=asMALvl[i];
		  int iMALvl=StrToInteger(sMALvl);
		  double dMALvl=ma+iMALvl*Point;
		  if(iMALvl!=0){
			 if(High[1]>dMALvl && Low[1]<dMALvl){
				if(iMALvl<0){
				   sig[0]=OP_BUYSTOP;
				}else{
				   sig[0]=OP_SELLSTOP;
				}
				sig[1]=iMALvl;
			 }
		  }
	   }
	   
	}

// }

//{ --- MA envelope
#define MAENVOutBUY "oMEOB"
#define MAENVOutSELL "oMEOS"

extern string libAO_MAEnvOut=">>>>>>>>>> MA Envelopes out";
	extern bool libAO_MAEnvOut_useOpen=false;
		extern int libAO_MAEnvOut_MAPer=50;
		extern int libAO_MAEnvOut_MAMethod=1;
		extern int libAO_MAEnvOut_MAAppPr=0;
		extern string libAO_MAEnvOut_Levels="50;-50;100;-100;200;-200;300;-300";
	void libAO_MAEnvOut_Open(){
		int sig[];
		libAO_MAEnvOut_Signal(sig);
		
		if(sig[0]<=-1){
			return;
		}
		
		if(isOrderWithParam("@o", "MEOB", "", MN, -1) ||
			isOrderWithParam("@o", "MEOS", "", MN, -1)){
				return;	
		}
		
		if(sig[0]==OP_BUYSTOP){
			OpenMarketSLTP_pip(	Symbol(),OP_BUY,libAL_CalcLots(),0,0,0,"@ip1@oMEOB",MN,0,CLR_NONE);
		}
		
		if(sig[0]==OP_SELLSTOP){
			OpenMarketSLTP_pip(	Symbol(),OP_SELL,libAL_CalcLots(),0,0,0,"@ip1@oMEOS",MN,0,CLR_NONE);
		}
	}
	
	void libAO_MAEnvOut_Signal(int &sig[]){
	   
	   ArrayResize(sig,0);
	   ArrayResize(sig,2);
	   double ma=iMA(NULL,0,libAO_MAEnvOut_MAPer,0,libAO_MAEnvOut_MAMethod,libAO_MAEnvOut_MAAppPr,1);
	   
	   string asMALvl[];
	   ArrayResize(asMALvl,0);
	   StringToArrayString(libAO_MAEnvOut_Levels,asMALvl,";");//,";");
	   
	   int rows=ArrayRange(asMALvl,0);
	   for(int i=0;i<rows;i++){
		  string sMALvl=asMALvl[i];
		  int iMALvl=StrToInteger(sMALvl);
		  double dMALvl=ma+iMALvl*Point;
		  if(iMALvl!=0){
			 if(High[1]>dMALvl && Low[1]<dMALvl){
				if(iMALvl<0){
				   sig[0]=OP_SELLSTOP;
				}else{
				   sig[0]=OP_BUYSTOP;
				}
				sig[1]=iMALvl;
			 }
		  }
	   }
	   
	}

// int StringToArrayString(string &a[], string s, string del = ";"){
	// /**
		// \version	0.0.0.1
		// \date		2013.06.12
		// \author		Morochin <artamir> Artiom
		// \details	Разбивает строку на подстроки разделителем. если разделителя нет, то в массиве возврящается строка.
		// \internal
			// >Hist:	
					 // @0.0.0.1@2013.06.12@artamir	[]	StringToArray
			// >Rev:0
	// */
	// string fn="StringToArrayString";
	// int pR = StringFind(s, del, 0);
	// int rows = ArrayRange(a,0);
	// int lastROW = rows-1;
	// if(pR > -1){
		// rows = rows + 1;
		// ArrayResize(a, rows);
		
		// lastROW++;
		// a[lastROW] = StringSubstr(s, 0, pR);
		// s=StringSubstr(s, pR+StringLen(del), StringLen(s)-pR+StringLen(del));
		// rows=StringToArrayString(a, s, del);
	// }else{
		// rows = rows + 1;
		// ArrayResize(a, rows);
		
		// lastROW++;
		// a[lastROW] = s;
		// return(rows);
	// }
	
	// return(rows);
// }


void libAO_MAIN(){
	//Начальные проверки по автооткрытию
	//сюда нужно дописывать процедуры 
	//инициализирующие тот или иной алгоритм открытия
	
	if(libAO_MAHL_useOpen){
		libAO_MAHL_Open();
	}
	//---
	if(libAO_needBarsOpen){
		libAO_BarOpen();
	}
	
	if(libAO_MAEnvIn_useOpen){
		libAO_MAEnvIn_Open();
	}
	
	if(libAO_MAEnvOut_useOpen){
		libAO_MAEnvOut_Open();
	}
}