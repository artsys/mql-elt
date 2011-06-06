extern string	aoMethods = ">>>>>>>>> AUTO OPEN METHODS =========";
extern string  ex_BAR_OPEN = "--- 1TF BAR OPEN";
extern bool       libAO_needBarsOpen = true; //нужно ли открытие при начале бара
extern int        BO_filter_pip = 20;  //сколько очков ждем для определения направления открытия
extern int        BO_TF_min = 1440; //тайм фрейм в минутах
//---
extern string  ex_BAR_OPEN_1 = "--- 2TF BAR OPEN";   
//extern bool       needBarOpen1 = false; //нужно ли открытие при начале бара
extern int        BO1_filter_pip = 10;  //сколько очков ждем для определения направления открытия
extern int        BO1_TF_min = 240; //тайм фрейм в минутах
//---
extern string  ex_BAR_OPEN_2 = "--- 2TF BAR OPEN";   
//extern bool       needBarOpen2 = false; //нужно ли открытие при начале бара
extern int        BO2_filter_pip = 10;  //сколько очков ждем для определения направления открытия
extern int        BO2_TF_min = 60; //тайм фрейм в минутах



//=================================================================================================
//*******************************************************************
// Блок открытия по направлению бара
//*******************************************************************
void libAO_BarOpen(){

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
												OP_BUY,
												al_LOT_fix,
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
												OP_SELL,
												al_LOT_fix,
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
