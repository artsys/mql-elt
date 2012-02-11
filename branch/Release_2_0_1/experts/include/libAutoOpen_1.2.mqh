extern string	aoMethods = ">>>>>>>>> AUTO OPEN METHODS =========";

//{======= Открытие для Вовы
	//{====== EXTERN
			extern string  ex60 = "--- Up To Level";
				extern bool       libAO_UTL_needUpToLevel = false;
					extern double     libAO_UTL_LevelPrice = 0;
					extern int        libAO_UTL_BorderLevelPricePip = 20;
					extern bool       libAO_UTL_filterStoh = true;

		//}
		
	//{====== EXTERN 
			extern string  ex70 = "--- Up To 252MA";
				extern bool       libAO_UTM_needUpToMA = false;
					//{--- MA 1
						extern int        libAO_UTM_MAPeriod_1 = 252;
						extern int        libAO_UTM_PipsToMA_1 = 25;
					//}
					//{--- MA 2
						extern int        libAO_UTM_MAPeriod_2 = 252;
						extern int        libAO_UTM_PipsToMA_2 = 25;
					//}
					//{--- MA 3 
						extern int        libAO_UTM_MAPeriod_3 = 252;
						extern int        libAO_UTM_PipsToMA_3 = 25;
					//}
					extern bool       libAO_UTM_filterStoh = true;
		//}
	
	//{====== EXTERN
			extern string  exBarOpen = "--- 1TF BAR OPEN";
				extern bool       libAO_BO_needOpen = true; //нужно ли открытие при начале бара
					extern bool       libAO_BO_needOpenOneDirection = true; //разрешает открывать советнику ордера только в одном направлении
					extern bool       libAO_BO_needBO_Filter = true; //разрешает фильтровать открытие
					extern bool       libAO_BO_use_MA_FILTERS = true;
					extern int        libAO_BO_filter_pip = 20;  //сколько очков ждем для определения направления открытия
					extern int        libAO_BO_TF_min = 1440; //тайм фрейм в минутах
			//---
			extern string  exBarOpen1 = "--- 2TF BAR OPEN";   
			//extern bool       libAO_BO_needOpen1 = false; //нужно ли открытие при начале бара
					extern int        libAO_BO1_filter_pip = 10;  //сколько очков ждем для определения направления открытия
					extern int        libAO_BO1_TF_min = 240; //тайм фрейм в минутах
			//---
			extern string  exBarOpen2 = "--- 3TF BAR OPEN";   
			//extern bool       libAO_BO_needOpen2 = false; //нужно ли открытие при начале бара
					extern int        libAO_BO2_filter_pip = 10;  //сколько очков ждем для определения направления открытия
					extern int        libAO_BO2_TF_min = 60; //тайм фрейм в минутах
			//---
			extern string  exBarOpen3 = "--- 4TF BAR OPEN";   
			//extern bool       libAO_BO_needOpen2 = false; //нужно ли открытие при начале бара
					extern int        libAO_BO3_filter_pip = 10;  //сколько очков ждем для определения направления открытия
					extern int        libAO_BO3_TF_min = 15; //тайм фрейм в минутах
			//---
			extern string  exBarOpen4 = "--- 5TF BAR OPEN";   
			//extern bool       libAO_BO_needOpen2 = false; //нужно ли открытие при начале бара
					extern int        libAO_BO4_filter_pip = 10;  //сколько очков ждем для определения направления открытия
					extern int        libAO_BO4_TF_min = 15; //тайм фрейм в минутах
			//---
			extern string  exBarOpen5 = "--- 6TF BAR OPEN";   
			//extern bool       libAO_BO_needOpen2 = false; //нужно ли открытие при начале бара
					extern int        libAO_BO5_filter_pip = 10;  //сколько очков ждем для определения направления открытия
					extern int        libAO_BO5_TF_min = 15; //тайм фрейм в минутах
			//---
			extern string  exBarOpen6 = "--- 7TF BAR OPEN";   
			//extern bool       libAO_BO_needOpen2 = false; //нужно ли открытие при начале бара
					extern int        libAO_BO6_filter_pip = 10;  //сколько очков ждем для определения направления открытия
					extern int        libAO_BO6_TF_min = 15; //тайм фрейм в минутах

		//}
	
	//{======= FILTERS
		//{======= EXTERN
			//------------------------------------
			extern string exFilt = "**** Filters ****";
			// int filterStohastic()

			extern bool    use_FILTER_STOH = false;
			extern string  exFilStoh = "--- Stohactic";
			extern bool       needFilterStoh_fast = false;
			extern string    exFilStoh1 = "     TF in min";
			extern string    exFilStoh2 = "     0 = Current TF";
			extern int        f_st_TF = 0;
			extern int        f_st_kPeriod = 5;
			extern int        f_st_dPeriod = 3;
			extern int        f_st_slowing = 3;
			extern string    exFilStoh3 = "SMA  = 0, EMA  = 1,";
			extern string    exFilStoh4 = "SMMA = 2, LWMA = 3,";
			extern int        f_st_method  = 0;
			extern string    exFilStoh5 = "Low/High = 0, Close/Close = 1,";
			extern int        f_st_price_field = 0;

			extern string  ex_FilStoh_slow = "--- Stohactic (slow)";
			extern bool       needFilterStoh_slow = false;
			extern string    exFilStoh_sl_1 = "     TF in min";
			extern string    exFilStoh_sl_2 = "     0 = Current TF";
			extern int        f_st_s_TF = 0;
			extern int        f_st_s_kPeriod = 5;
			extern int        f_st_s_dPeriod = 3;
			extern int        f_st_s_slowing = 3;
			extern string    exFilStoh_sl_3 = "SMA  = 0, EMA  = 1,";
			extern string    exFilStoh_sl_4 = "SMMA = 2, LWMA = 3,";
			extern int        f_st_s_method  = 0;
			extern string    exFilStoh_sl_5 = "Low/High = 0, Close/Close = 1,";
			extern int        f_st_s_price_field = 0;
			extern string exEND_FilStoh_slow;
			//---
			extern string  ex_FilStoh_slow2 = "--- Stohactic (slow) 2";
			extern bool       needFilterStoh_slow2 = false;
			extern string    exFilStoh_sl2_1 = "     TF in min";
			extern string    exFilStoh_sl2_2 = "     0 = Current TF";
			extern int        f_st_s2_TF = 0;
			extern int        f_st_s2_kPeriod = 5;
			extern int        f_st_s2_dPeriod = 3;
			extern int        f_st_s2_slowing = 3;
			extern string    exFilStoh_sl2_3 = "SMA  = 0, EMA  = 1,";
			extern string    exFilStoh_sl2_4 = "SMMA = 2, LWMA = 3,";
			extern int        f_st_s2_method  = 0;
			extern string    exFilStoh_sl2_5 = "Low/High = 0, Close/Close = 1,";
			extern int        f_st_s2_price_field = 0;
			extern string exEND_FilStoh_slow2;
			//---
			extern string  ex_FilStoh_slow3 = "--- Stohactic (slow) 3";
			extern bool       needFilterStoh_slow3 = false;
			extern string    exFilStoh_sl3_1 = "     TF in min";
			extern string    exFilStoh_sl3_2 = "     0 = Current TF";
			extern int        f_st_s3_TF = 0;
			extern int        f_st_s3_kPeriod = 5;
			extern int        f_st_s3_dPeriod = 3;
			extern int        f_st_s3_slowing = 3;
			extern string    exFilStoh_sl3_3 = "SMA  = 0, EMA  = 1,";
			extern string    exFilStoh_sl3_4 = "SMMA = 2, LWMA = 3,";
			extern int        f_st_s3_method  = 0;
			extern string    exFilStoh_sl3_5 = "Low/High = 0, Close/Close = 1,";
			extern int        f_st_s3_price_field = 0;
			extern string exEND_FilStoh_slow3;
			//---
			extern string  ex_FilStoh_slow4 = "--- Stohactic (slow) 4";
			extern bool       needFilterStoh_slow4 = false;
			extern string    exFilStoh_sl4_1 = "     TF in min";
			extern string    exFilStoh_sl4_2 = "     0 = Current TF";
			extern int        f_st_s4_TF = 0;
			extern int        f_st_s4_kPeriod = 5;
			extern int        f_st_s4_dPeriod = 3;
			extern int        f_st_s4_slowing = 3;
			extern string    exFilStoh_sl4_3 = "SMA  = 0, EMA  = 1,";
			extern string    exFilStoh_sl4_4 = "SMMA = 2, LWMA = 3,";
			extern int        f_st_s4_method  = 0;
			extern string    exFilStoh_sl4_5 = "Low/High = 0, Close/Close = 1,";
			extern int        f_st_s4_price_field = 0;
			extern string exEND_FilStoh_slow4;
			//---
			extern string  ex_FilStoh_slow5 = "--- Stohactic (slow) 5";
			extern bool       needFilterStoh_slow5 = false;
			extern string    exFilStoh_sl5_1 = "     TF in min";
			extern string    exFilStoh_sl5_2 = "     0 = Current TF";
			extern int        f_st_s5_TF = 0;
			extern int        f_st_s5_kPeriod = 5;
			extern int        f_st_s5_dPeriod = 3;
			extern int        f_st_s5_slowing = 3;
			extern string    exFilStoh_sl5_3 = "SMA  = 0, EMA  = 1,";
			extern string    exFilStoh_sl5_4 = "SMMA = 2, LWMA = 3,";
			extern int        f_st_s5_method  = 0;
			extern string    exFilStoh_sl5_5 = "Low/High = 0, Close/Close = 1,";
			extern int        f_st_s5_price_field = 0;
			extern string exEND_FilStoh_slow5;
			//---
			extern string  ex_FilStoh_slow6 = "--- Stohactic (slow) 6";
			extern bool       needFilterStoh_slow6 = false;
			extern string    exFilStoh_sl6_1 = "     TF in min";
			extern string    exFilStoh_sl6_2 = "     0 = Current TF";
			extern int        f_st_s6_TF = 0;
			extern int        f_st_s6_kPeriod = 5;
			extern int        f_st_s6_dPeriod = 3;
			extern int        f_st_s6_slowing = 3;
			extern string    exFilStoh_sl6_3 = "SMA  = 0, EMA  = 1,";
			extern string    exFilStoh_sl6_4 = "SMMA = 2, LWMA = 3,";
			extern int        f_st_s6_method  = 0;
			extern string    exFilStoh_sl6_5 = "Low/High = 0, Close/Close = 1,";
			extern int        f_st_s6_price_field = 0;
			extern string exEND_FilStoh_slow6;
			//=============================================================
			//Filters MA
			extern string ex_FIL_MA = "-=== FILTERS MA ===-";
				 extern string ex_FIL_MA_1 = "--- MA 1 ---";
						extern bool use_FILTER_MA1 = false;// использовать фильтр по МА
						extern int     FILTER_MA1_per    = 4; //период фильтрующей МА
						extern int     FILTER_MA1_tf     = 60; //таймфрейм для получения значения МА
						extern int     FILTER_MA1_pip    = 5; //конверт в пипсах
							extern string    exFilMA_1_mode_1 = "SMA  = 0, EMA  = 1,";
							extern string    exFilMA_1_mode_2 = "SMMA = 2, LWMA = 3,";
						extern int     FILTER_MA1_mode   = 0; //
				 extern string ex_END_FIL_MA_1 = "-----------";
				 extern string ex_FIL_MA_2 = "--- MA 2 ---";
						extern bool use_FILTER_MA2 = false;// использовать фильтр по МА
						extern int     FILTER_MA2_per    = 4; //период фильтрующей МА
						extern int     FILTER_MA2_tf     = 60; //таймфрейм для получения значения МА
						extern int     FILTER_MA2_pip    = 5; //конверт в пипсах
							extern string    exFilMA_2_mode_1 = "SMA  = 0, EMA  = 1,";
							extern string    exFilMA_2_mode_2 = "SMMA = 2, LWMA = 3,";
						extern int     FILTER_MA2_mode   = 0; //
				 extern string ex_END_FIL_MA_2 = "-----------";
				 extern string ex_FIL_MA_3 = "--- MA 3 ---";
						extern bool use_FILTER_MA3 = false;// использовать фильтр по МА
						extern int     FILTER_MA3_per    = 4; //период фильтрующей МА
						extern int     FILTER_MA3_tf     = 60; //таймфрейм для получения значения МА
						extern int     FILTER_MA3_pip    = 5; //конверт в пипсах
							extern string    exFilMA_3_mode_1 = "SMA  = 0, EMA  = 1,";
							extern string    exFilMA_3_mode_2 = "SMMA = 2, LWMA = 3,";
						extern int     FILTER_MA3_mode   = 0; //
				 extern string ex_END_FIL_MA_3 = "-----------";
				 extern string ex_FIL_MA_4 = "--- MA 4 ---";
						extern bool use_FILTER_MA4 = false;// использовать фильтр по МА
						extern int     FILTER_MA4_per    = 4; //период фильтрующей МА
						extern int     FILTER_MA4_tf     = 60; //таймфрейм для получения значения МА
						extern int     FILTER_MA4_pip    = 5; //конверт в пипсах
							extern string    exFilMA_4_mode_1 = "SMA  = 0, EMA  = 1,";
							extern string    exFilMA_4_mode_2 = "SMMA = 2, LWMA = 3,";
						extern int     FILTER_MA4_mode   = 0; //
				 extern string ex_END_FIL_MA_4 = "-----------";
				 extern string ex_FIL_MA_5 = "--- MA 5 ---";
						extern bool use_FILTER_MA5 = false;// использовать фильтр по МА
						extern int     FILTER_MA5_per    = 4; //период фильтрующей МА
						extern int     FILTER_MA5_tf     = 60; //таймфрейм для получения значения МА
						extern int     FILTER_MA5_pip    = 5; //конверт в пипсах
							extern string    exFilMA_5_mode_1 = "SMA  = 0, EMA  = 1,";
							extern string    exFilMA_5_mode_2 = "SMMA = 2, LWMA = 3,";
						extern int     FILTER_MA5_mode   = 0; //
				 extern string ex_END_FIL_MA_5 = "-----------";   
				 extern string ex_FIL_MA_6 = "--- MA 6 ---";
						extern bool use_FILTER_MA6 = false;// использовать фильтр по МА
						extern int     FILTER_MA6_per    = 4; //период фильтрующей МА
						extern int     FILTER_MA6_tf     = 60; //таймфрейм для получения значения МА
						extern int     FILTER_MA6_pip    = 5; //конверт в пипсах
							extern string    exFilMA_6_mode_1 = "SMA  = 0, EMA  = 1,";
							extern string    exFilMA_6_mode_2 = "SMMA = 2, LWMA = 3,";
						extern int     FILTER_MA6_mode   = 0; //
				 extern string ex_END_FIL_MA_6 = "-----------";
				 extern string ex_FIL_MA_7 = "--- MA 7 ---";
						extern bool use_FILTER_MA7 = false;// использовать фильтр по МА
						extern int     FILTER_MA7_per    = 4; //период фильтрующей МА
						extern int     FILTER_MA7_tf     = 60; //таймфрейм для получения значения МА
						extern int     FILTER_MA7_pip    = 5; //конверт в пипсах
							extern string    exFilMA_7_mode_1 = "SMA  = 0, EMA  = 1,";
							extern string    exFilMA_7_mode_2 = "SMMA = 2, LWMA = 3,";
						extern int     FILTER_MA7_mode   = 0; //
				 extern string ex_END_FIL_MA_7 = "-----------";
			extern string ex_END_FIL_MA = "-===================-";

	//}
	//}
	
	void libAO_MAIN(){
	//Начальные проверки по автооткрытию
	//сюда нужно дописывать процедуры 
	//инициализирующие тот или иной алгоритм открытия
	
	if(libAO_UTL_needUpToLevel){
		startUpToLevel();
	}
	//---
	if(libAO_UTM_needUpToMA){
		startUpToMA();
	}
	//---
	if(libAO_BO_needOpen){
		startBarOpen();	
	}
	
}
	
	//{======= UpToLevel	
		//{====== ALGORITM
		void startUpToLevel(){
			double lp = NormalizeDouble(libAO_UTL_LevelPrice,Digits);
			double bd = MarketInfo(Symbol(),MODE_BID);
			int cmd = -1;
			string comm = "@ip1@o";
    
			if(MathAbs((lp-bd)/Point) > libAO_UTL_BorderLevelPricePip){
				if(lp > bd){
					cmd = OP_BUY;
					string comm_add = "UTLB";
        } 
				//--- 
				if(lp < bd){
					cmd = OP_SELL;   
					comm_add = "UTLS";
				}
				//---
				if(libAO_UTL_filterStoh){
					if(filterStohastic_fast() != cmd) return; 
				}	
      }
        
				if(!isOrderWithParam("@o", comm_add, "", MN, -1)){
					OpenMarketSLTP_pip(	Symbol(),
														cmd,
														libAL_CalcLots(),
														0,
														0,
														0,
														comm+comm_add,
														MN,
														0,
														CLR_NONE);	 							
      //openFirst(cmd, "UPToLevel", mUpToLevel);
         
			}else{
				return;
			}
		}
		
		//}
	//}
	
	//{======= Up To 252MA
		//{====== ALGORITM
			void startUpToMA(){
					int OP_BUYUPTOMA		= 10;
					int OP_SELLUPTOMA		= -10;
					
					
					int cmd = -1;
					int cmd_res = 0;
					
					string comm = "@ip1@o";
					
					double MA1 = NormalizeDouble(iMA(Symbol(),0,libAO_UTM_MAPeriod_1,0,0,0,0),Digits);
					double bd_ = MarketInfo(Symbol(),MODE_BID);
					double bd = iif(bd > MA1,MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_BID));
					if(NormalizeDouble(MathAbs(bd - MA1)/Point,0) >= libAO_UTM_PipsToMA_1){
						if(MA1 > bd){
							 cmd_res = cmd_res + OP_BUYUPTOMA;
						}   
						//---	 
						if(MA1 < bd){
							 cmd_res = cmd_res + OP_SELLUPTOMA; 
						}     
						//---
					}
					//---
					double	MA2 = NormalizeDouble(iMA(Symbol(),0,libAO_UTM_MAPeriod_2,0,0,0,0),Digits);
									bd_ = MarketInfo(Symbol(),MODE_BID);
									bd	= iif(bd > MA2,MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_BID));
												
					if(NormalizeDouble(MathAbs(bd - MA2)/Point,0) >= libAO_UTM_PipsToMA_2){
						if(MA2 > bd){
							 cmd_res = cmd_res + OP_BUYUPTOMA;
						}   
						//---	 
						if(MA2 < bd){
							 cmd_res = cmd_res + OP_SELLUPTOMA; 
						}     
						//---
					}
					//---
					double	MA3 = NormalizeDouble(iMA(Symbol(),0,libAO_UTM_MAPeriod_3,0,0,0,0),Digits);
									bd_ = MarketInfo(Symbol(),MODE_BID);
									bd	= iif(bd > MA3,MarketInfo(Symbol(),MODE_ASK),MarketInfo(Symbol(),MODE_BID));
					if(NormalizeDouble(MathAbs(bd - MA3)/Point,0) >= libAO_UTM_PipsToMA_3){
						if(MA3 > bd){
							 cmd_res = cmd_res + OP_BUYUPTOMA;
						}   
						//---	 
						if(MA3 < bd){
							 cmd_res = cmd_res + OP_SELLUPTOMA; 
						}     
						//---
					}
					//---
					cmd_res = cmd_res / 3;
					strCommUPTOMA = "cmd_res = "+cmd_res;
					//---
					if(cmd_res == OP_BUYUPTOMA){
						string comm_add = "UTMB";
						cmd = OP_BUY;
					}	
					//---
					if(cmd_res == OP_SELLUPTOMA){
						comm_add = "UTLS";
						cmd = OP_SELL;
					}
					//---
					if(cmd > -1){
						if(libAO_UTM_filterStoh){
							//if(filterStohastic_fast() != cmd)return; 
							if(cmd == OP_BUY){
								if(use_FILTER_STOH){
									if(!can_FilterStoh(OP_BUY)) return; 
								}
							}
							//---
							if(cmd == OP_SELL){
								if(use_FILTER_STOH){
									if(!can_FilterStoh(OP_SELL)) return; 
								}
							}
						}    
						
						if(!isOrderWithParam("@o", comm_add, "", MN, -1)){
							OpenMarketSLTP_pip(	Symbol(),
															cmd,
															libAL_CalcLots(),
															0,
															0,
															0,
															comm+comm_add,
															MN,
															0,
															CLR_NONE);	 
							 
						}else{
							return;
						}
					}
			}
		//}
	//}	
	
	//{======= BAR OPEN
		//{====== ALGORITM
			void startBarOpen(){

				 Print("======== start BarOpen"); 

				 double ob = iOpen(Symbol(),libAO_BO_TF_min,0);
				 double bd = 0; 
				 
				if((MarketInfo(Symbol(),MODE_BID) - ob)/Point > 1){
							 bd = MarketInfo(Symbol(),MODE_BID);
				}else{
						if((ob - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
							 bd = MarketInfo(Symbol(),MODE_ASK);      
						else
							 bd = -1;   
				}			 
				 //---
				 
				 double ob1 = iOpen(Symbol(),libAO_BO1_TF_min,0);
				 double bd1 = 0; 
				 
				if((MarketInfo(Symbol(),MODE_BID) - ob1)/Point > 1){
							 bd1 = MarketInfo(Symbol(),MODE_BID);
				}else{
						if((ob1 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
							 bd1 = MarketInfo(Symbol(),MODE_ASK); 
						else
							 bd1 = -1;        
				}			 
				 //---
				 double ob2 = iOpen(Symbol(),libAO_BO2_TF_min,0);
				 double bd2 = 0; 
				 
				if((MarketInfo(Symbol(),MODE_BID) - ob2)/Point > 1){
							 bd2 = MarketInfo(Symbol(),MODE_BID);
				}else{
						if((ob2 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
							 bd2 = MarketInfo(Symbol(),MODE_ASK);      
						else
							 bd2 = -1;   
				}			 
				 //---
				 double ob3 = iOpen(Symbol(),libAO_BO3_TF_min,0);
				 double bd3 = 0; 
				 
				if((MarketInfo(Symbol(),MODE_BID) - ob3)/Point > 1){
							 bd3 = MarketInfo(Symbol(),MODE_BID);
				}else{
						if((ob3 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
							 bd3 = MarketInfo(Symbol(),MODE_ASK);      
						else
							 bd3 = -1;         
				} 
						//---
				 double ob4 = iOpen(Symbol(),libAO_BO4_TF_min,0);
				 double bd4 = 0; 
				 
				if((MarketInfo(Symbol(),MODE_BID) - ob4)/Point > 1){
							 bd4 = MarketInfo(Symbol(),MODE_BID);
				}else{
						if((ob4 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
							 bd4 = MarketInfo(Symbol(),MODE_ASK);      
						else
							 bd4 = -1;         
				}			 
						//---
				double ob5 = iOpen(Symbol(),libAO_BO5_TF_min,0);
				double bd5 = 0; 
				 
				if((MarketInfo(Symbol(),MODE_BID) - ob5)/Point > 1){
							bd5 = MarketInfo(Symbol(),MODE_BID);
				}else{
					 if((ob5 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
							bd5 = MarketInfo(Symbol(),MODE_ASK);      
					 else
							bd5 = -1;         
				}		
					//---
				 double ob6 = iOpen(Symbol(),libAO_BO6_TF_min,0);
				 double bd6 = 0; 
				 
				if((MarketInfo(Symbol(),MODE_BID) - ob6)/Point > 1){
							 bd6 = MarketInfo(Symbol(),MODE_BID);
				}else{
						if((ob6 - MarketInfo(Symbol(),MODE_ASK)) / Point > 1)
							 bd6 = MarketInfo(Symbol(),MODE_ASK);      
						else
							 bd6 = -1;         
				}
				 //---
					string comm = StringConcatenate("Period: ","\n\n");
				 
				 //=====
				 //Comment tf moving
				 //--- 0
				if((bd - ob) / Point > libAO_BO_filter_pip && bd > -1){
						comm = StringConcatenate(comm , getStrPeriod(libAO_BO_TF_min),": UP","\n");
				 }else{
						if((ob - bd) / Point > libAO_BO_filter_pip && bd > -1){
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO_TF_min),": DOWN","\n");
						}else{
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO_TF_min),": ====","\n");
						}	 
				}			 
				 //--- 1
				if((bd1 - ob1) / Point > libAO_BO1_filter_pip && bd1 > -1){
						comm = StringConcatenate(comm , getStrPeriod(libAO_BO1_TF_min),": UP","\n");
				 }else{
						if((ob1 - bd1) / Point > libAO_BO1_filter_pip && bd1 > -1){
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO1_TF_min),": DOWN","\n");
						}else{
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO1_TF_min),": ====","\n");
						}	 
				}			 
				 //--- 2
				if((bd2 - ob2) / Point > libAO_BO2_filter_pip && bd2 > -1){
						comm = StringConcatenate(comm , getStrPeriod(libAO_BO2_TF_min),": UP","\n");
				}else{
						if((ob2 - bd2) / Point > libAO_BO2_filter_pip && bd2 > -1){
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO2_TF_min),": DOWN","\n");
						}else{
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO2_TF_min),": ====","\n"); 
						}
				}
				 //--- 3
				if((bd3 - ob3) / Point > libAO_BO3_filter_pip && bd3 > -1){
						comm = StringConcatenate(comm , getStrPeriod(libAO_BO3_TF_min),": UP","\n");
				}else{
						if((ob3 - bd3) / Point > libAO_BO3_filter_pip && bd3 > -1){
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO3_TF_min),": DOWN","\n");
						}else{
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO3_TF_min),": ====","\n"); 
						}
				}
				 //--- 4
				if((bd4 - ob4) / Point > libAO_BO4_filter_pip && bd4 > -1)
						comm = StringConcatenate(comm , getStrPeriod(libAO_BO4_TF_min),": UP","\n");
				else
						if((ob4 - bd4) / Point > libAO_BO4_filter_pip && bd4 > -1)
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO4_TF_min),": DOWN","\n");
						else
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO4_TF_min),": ====","\n");
				//--- 5
				if((bd5 - ob5) / Point > libAO_BO5_filter_pip && bd5 > -1)
						comm = StringConcatenate(comm , getStrPeriod(libAO_BO5_TF_min),": UP","\n");
				else
						if((ob5 - bd5) / Point > libAO_BO5_filter_pip && bd5 > -1)
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO5_TF_min),": DOWN","\n");
						else
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO5_TF_min),": ====","\n");
				//--- 6
				if((bd6 - ob6) / Point > libAO_BO6_filter_pip && bd6 > -1)
						comm = StringConcatenate(comm , getStrPeriod(libAO_BO6_TF_min),": UP","\n");
				else
						if((ob6 - bd6) / Point > libAO_BO6_filter_pip && bd6 > -1)
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO6_TF_min),": DOWN","\n");
						else
							 comm = StringConcatenate(comm , getStrPeriod(libAO_BO6_TF_min),": ====","\n");                              
				//Конец собирания комментариев
				//=====
				 
				strCommBO = comm;
				if((bd - ob) / Point > libAO_BO_filter_pip && bd > -1){
						//Дневки бай
						if((bd1 - ob1) / Point > libAO_BO1_filter_pip && bd1 > -1){
							if((bd2 - ob2) / Point > libAO_BO2_filter_pip && bd2 > -1){
								if((bd3 - ob3) / Point > libAO_BO3_filter_pip && bd3 > -1){
									if((bd4 - ob4) / Point > libAO_BO4_filter_pip && bd4 > -1){
										if((bd5 - ob5) / Point > libAO_BO5_filter_pip && bd5 > -1){
											if((bd6 - ob6) / Point > libAO_BO6_filter_pip && bd6 > -1){
												if(libAO_BO_use_MA_FILTERS){
																 if(!can_FILTER_MA_OPEN(OP_BUY)){
																		return;
																 }
												}
												//---
												if(use_FILTER_STOH){
													if(!can_FilterStoh(OP_BUY)) return; 
												}
												//---
												if(!isOrderWithParam("@o", "BOB", "", MN, -1)){
													OpenMarketSLTP_pip(	Symbol(),
																							OP_BUY,
																							libAL_CalcLots(),
																							0,
																							0,
																							0,
																							"@ip1@oBOB",
																							MN,
																							0,
																							CLR_NONE);
												}
											}   
										}   
									}   
								}   
							}   
						}   
					}
				 //===
				 if((ob - bd) / Point > libAO_BO_filter_pip && bd > -1){
						if((ob1 - bd1) / Point > libAO_BO1_filter_pip && bd1 > -1){
							 if((ob2 - bd2) / Point > libAO_BO2_filter_pip && bd2 > -1){
									if((ob3 - bd3) / Point > libAO_BO3_filter_pip && bd3 > -1){
										 if((ob4 - bd4) / Point > libAO_BO4_filter_pip && bd4 > -1){
												if((ob5 - bd5) / Point > libAO_BO5_filter_pip && bd5 > -1){
													 if((ob6 - bd6) / Point > libAO_BO6_filter_pip && bd6 > -1){
															if(libAO_BO_use_MA_FILTERS){
																 if(!can_FILTER_MA_OPEN(OP_SELL)){
																		return;
																 }
															}
															//---
															if(use_FILTER_STOH){
																if(!can_FilterStoh(OP_SELL)) return; 
															}
															//---
															if(!isOrderWithParam("@o", "BOS", "", MN, -1)){
																OpenMarketSLTP_pip(	Symbol(),
																					OP_SELL,
																					libAL_CalcLots(),
																					0,
																					0,
																					0,
																					"@ip1@oBOS",
																					MN,
																					0,
																					CLR_NONE);
															}
													 }
												}
										 }
									}            
							 }   
						}   
				 } 
			}
		//}
	//}

//}

//{====== ФИЛЬТРЫ


//*******************************************************************
// Фильтры
//*******************************************************************

bool can_FilterStoh(int cmd){
   bool res = true;
      //---
         if(needFilterStoh_fast){
            if(filterStohastic_fast() != cmd) res = false;
         }
         //---
         if(needFilterStoh_slow){
            if(filterStohastic_slow() != cmd) res = false;
         }
         //---
         if(needFilterStoh_slow2){
            if(filterStohastic_slow2() != cmd) res = false;
         }
         //---
         if(needFilterStoh_slow3){
            if(filterStohastic_slow3() != cmd) res = false;
         }
         //---
         if(needFilterStoh_slow4){
            if(filterStohastic_slow4() != cmd) res = false;
         }
         //---
         if(needFilterStoh_slow5){
            if(filterStohastic_slow5() != cmd) res = false;
         }
         //---
         if(needFilterStoh_slow6){
            if(filterStohastic_slow6() != cmd) res = false;
         }
      //---
   return(res);
}

int filterStohastic_fast(){
      double stMain   = iStochastic(Symbol(),f_st_TF,f_st_kPeriod,f_st_dPeriod,f_st_slowing,f_st_method,f_st_price_field,0,0);
      double stSignal = iStochastic(Symbol(),f_st_TF,f_st_kPeriod,f_st_dPeriod,f_st_slowing,f_st_method,f_st_price_field,1,0);

      if(stSignal < stMain){
         return(OP_BUY); 
      }
      //---
      if(stSignal > stMain){
         return(OP_SELL); 
      }
      
      return(-1);
}

int filterStohastic_slow(){
      double stMain   = iStochastic(Symbol(),f_st_s_TF,f_st_s_kPeriod,f_st_s_dPeriod,f_st_s_slowing,f_st_s_method,f_st_s_price_field,0,0);
      double stSignal = iStochastic(Symbol(),f_st_s_TF,f_st_s_kPeriod,f_st_s_dPeriod,f_st_s_slowing,f_st_s_method,f_st_s_price_field,1,0);

      if(stSignal < stMain){
         return(OP_BUY); 
      }
      //---
      if(stSignal > stMain){
         return(OP_SELL); 
      }
      
      return(-1);
}

int filterStohastic_slow2(){
      double stMain   = iStochastic(Symbol(),f_st_s2_TF,f_st_s2_kPeriod,f_st_s2_dPeriod,f_st_s2_slowing,f_st_s2_method,f_st_s2_price_field,0,0);
      double stSignal = iStochastic(Symbol(),f_st_s2_TF,f_st_s2_kPeriod,f_st_s2_dPeriod,f_st_s2_slowing,f_st_s2_method,f_st_s2_price_field,1,0);

      if(stSignal < stMain){
         return(OP_BUY); 
      }
      //---
      if(stSignal > stMain){
         return(OP_SELL); 
      }
      
      return(-1);
}

int filterStohastic_slow3(){
      double stMain   = iStochastic(Symbol(),f_st_s3_TF,f_st_s3_kPeriod,f_st_s3_dPeriod,f_st_s3_slowing,f_st_s3_method,f_st_s3_price_field,0,0);
      double stSignal = iStochastic(Symbol(),f_st_s3_TF,f_st_s3_kPeriod,f_st_s3_dPeriod,f_st_s3_slowing,f_st_s3_method,f_st_s3_price_field,1,0);

      if(stSignal < stMain){
         return(OP_BUY); 
      }
      //---
      if(stSignal > stMain){
         return(OP_SELL); 
      }
      
      return(-1);
}

int filterStohastic_slow4(){
      double stMain   = iStochastic(Symbol(),f_st_s4_TF,f_st_s4_kPeriod,f_st_s4_dPeriod,f_st_s4_slowing,f_st_s4_method,f_st_s4_price_field,0,0);
      double stSignal = iStochastic(Symbol(),f_st_s4_TF,f_st_s4_kPeriod,f_st_s4_dPeriod,f_st_s4_slowing,f_st_s4_method,f_st_s4_price_field,1,0);

      if(stSignal < stMain){
         return(OP_BUY); 
      }
      //---
      if(stSignal > stMain){
         return(OP_SELL); 
      }
      
      return(-1);
}

int filterStohastic_slow5(){
      double stMain   = iStochastic(Symbol(),f_st_s5_TF,f_st_s5_kPeriod,f_st_s5_dPeriod,f_st_s5_slowing,f_st_s5_method,f_st_s5_price_field,0,0);
      double stSignal = iStochastic(Symbol(),f_st_s5_TF,f_st_s5_kPeriod,f_st_s5_dPeriod,f_st_s5_slowing,f_st_s5_method,f_st_s5_price_field,1,0);

      if(stSignal < stMain){
         return(OP_BUY); 
      }
      //---
      if(stSignal > stMain){
         return(OP_SELL); 
      }
      
      return(-1);
}

int filterStohastic_slow6(){
      double stMain   = iStochastic(Symbol(),f_st_s6_TF,f_st_s6_kPeriod,f_st_s6_dPeriod,f_st_s6_slowing,f_st_s6_method,f_st_s6_price_field,0,0);
      double stSignal = iStochastic(Symbol(),f_st_s6_TF,f_st_s6_kPeriod,f_st_s6_dPeriod,f_st_s6_slowing,f_st_s6_method,f_st_s6_price_field,1,0);

      if(stSignal < stMain){
         return(OP_BUY); 
      }
      //---
      if(stSignal > stMain){
         return(OP_SELL); 
      }
      
      return(-1);
}


//==================================================================
// ФИЛЬТРЫ МА
//------------------------------------------------------------------
bool can_FILTER_MA_OPEN(int OP){
   bool res = true;
   //------
      int maxFil_MA = 0;
      int resFil_MA = 0;
      
      double pr = iif(OP == OP_BUY,Bid,Ask);
      //---
      double ma1 = iMA(Symbol(),FILTER_MA1_tf,FILTER_MA1_per,0,FILTER_MA1_mode,0,0) + (iif(OP == OP_BUY,1,-1)*FILTER_MA1_pip*Point);
      double ma2 = iMA(Symbol(),FILTER_MA2_tf,FILTER_MA2_per,0,FILTER_MA2_mode,0,0) + (iif(OP == OP_BUY,1,-1)*FILTER_MA2_pip*Point);
      double ma3 = iMA(Symbol(),FILTER_MA3_tf,FILTER_MA3_per,0,FILTER_MA3_mode,0,0) + (iif(OP == OP_BUY,1,-1)*FILTER_MA3_pip*Point);
      double ma4 = iMA(Symbol(),FILTER_MA4_tf,FILTER_MA4_per,0,FILTER_MA4_mode,0,0) + (iif(OP == OP_BUY,1,-1)*FILTER_MA4_pip*Point);
      double ma5 = iMA(Symbol(),FILTER_MA5_tf,FILTER_MA5_per,0,FILTER_MA5_mode,0,0) + (iif(OP == OP_BUY,1,-1)*FILTER_MA5_pip*Point);
      double ma6 = iMA(Symbol(),FILTER_MA6_tf,FILTER_MA6_per,0,FILTER_MA6_mode,0,0) + (iif(OP == OP_BUY,1,-1)*FILTER_MA6_pip*Point);
      double ma7 = iMA(Symbol(),FILTER_MA7_tf,FILTER_MA7_per,0,FILTER_MA7_mode,0,0) + (iif(OP == OP_BUY,1,-1)*FILTER_MA7_pip*Point);
      
      if(use_FILTER_MA1){
         maxFil_MA++;
         if(iif(OP == OP_BUY,pr,ma1) - iif(OP == OP_BUY,ma1,pr) >= 0){
            resFil_MA++;
         }
      }
      //---
      if(use_FILTER_MA2){
         maxFil_MA++;
         if(iif(OP == OP_BUY,pr,ma2) - iif(OP == OP_BUY,ma2,pr) >= 0){
            resFil_MA++;
         }
      }
      //---
      if(use_FILTER_MA3){
         maxFil_MA++;
         if(iif(OP == OP_BUY,pr,ma3) - iif(OP == OP_BUY,ma3,pr) >= 0){
            resFil_MA++;
         }
      }
      //---
      if(use_FILTER_MA4){
         maxFil_MA++;
         if(iif(OP == OP_BUY,pr,ma4) - iif(OP == OP_BUY,ma4,pr) >= 0){
            resFil_MA++;
         }
      }
      //---
      if(use_FILTER_MA5){
         maxFil_MA++;
         if(iif(OP == OP_BUY,pr,ma5) - iif(OP == OP_BUY,ma5,pr) >= 0){
            resFil_MA++;
         }
      }
      //---
      if(use_FILTER_MA6){
         maxFil_MA++;
         if(iif(OP == OP_BUY,pr,ma6) - iif(OP == OP_BUY,ma6,pr) >= 0){
            resFil_MA++;
         }
      }
      //---
      if(use_FILTER_MA7){
         maxFil_MA++;
         if(iif(OP == OP_BUY,pr,ma7) - iif(OP == OP_BUY,ma7,pr) >= 0){
            resFil_MA++;
         }
      }
      //=========================
      if(resFil_MA == maxFil_MA){
         return(true);
      }else{
         return(false);
      }
   //------
   return(res);
}

//*******************************************************************
// Конец Фильтры
//*******************************************************************

//}