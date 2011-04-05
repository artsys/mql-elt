//+------------------------------------------------------------------+
//|                                                       libeLT.mq4 |
//|                      Copyright © 2011, Morochin <artamir> Artiom |
//|               http://forexmd.ucoz.org  e-mail: artamir@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Morochin <artamir> Artiom"
#property link      "http://forexmd.ucoz.org  e-mail: artamir@yandex.ru"

#property library

#include <libHelpFunc.mqh>
#include <libOrdersFunc.mqh>
#include <libINIFileFunc.mqh>

/*///===================================================================
   Версия: 2011.03.24
   ---------------------
   Описание:
      инициализация констант
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Константы:
       OP_SLTP = применяется как флаг операций вычисления сл и тп для ордеров         
       OP_SORD = применяется как флаг операций открытия позиции
/*///-------------------------------------------------------------------
#define  libNAME "libOrdersFunc"

#define  OP_SLTP   200
#define  OP_SORD   100

#define  CHK_SMBMN    500
#define  CHK_SMB      700
#define  CHK_MN       600
#define  CHK_TYMORE   400
#define  CHK_TYLESS   300
#define  CHK_TYEQ     200

string   file_ord =  "";

//===================================================
void libeLT_setFile_ord(string str){
   file_ord = str;
}

/*///==================================================================
// Версия: 2011.03.24
//---------------------
// Описание:
// Возвращает версию библиотеки помощи :)
//---------------------
// Переменные:
//    нет
/*///-------------------------------------------------------------------
string libeLT_Ver(){
   return("v1.0");
}
//======================================================================



/*///===================================================================
   Версия: 2011.03.28
   ---------------------
   Описание:
      Возвращает уровень вложенности сетки
   ---------------------
   Алгоритм:
      1. проверяем, "@g"
         1.1 если > -1 тогда возвращаем уровень
         1.2 если == -1 тогда проверяем файл ордеров
            ищем [ticket]
                     grid = <x>
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      ticket - родительский ордер

/*///-------------------------------------------------------------------
int getGrid(int ticket){

   OrderSelect(ticket,SELECT_BY_TICKET);
   
   int res = 1;
      res = StrToInteger(returnComment(OrderComment(),"@g"));
      
      if(res == -1){ // проверим файл ордеров для 
         string sGrid = ReadIniString  (file_ord, ticket, "grid", "-1");
         int iGrid = StrToInteger(sGrid);
         return(iGrid);
      }
   return(res);
}
//======================================================================

/*///===================================================================
   Версия: 2011.03.29
   ---------------------
   Описание:
      возвращает расчетную цену в зависимости от типа ордера,
      уровня и таргета
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      condition    = логическое сравнение
      ifTrue       = значение в случае condition = ИСТИНА
      ifFalse      = значение в случае condition = ЛОЖЬ

/*///-------------------------------------------------------------------
double  calcPrice(double parent_pr, int parent_type, int pip){
	double pr = 0;
	if(parent_type == OP_BUY){
		pr	=	NormalizeDouble(parent_pr - pip*Point, Digits);
	}else{
		if(parent_type == OP_SELL){
			pr	=	NormalizeDouble(parent_pr + pip*Point, Digits);
		}	
	}
   
	return(pr);
}
//======================================================================

/*///===================================================================
   Версия: 2011.04.05
   ---------------------
   Описание:
      возвращает расчетную цену  тп в зависимости от типа ордера,
      уровня и таргета
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      condition    = логическое сравнение
      ifTrue       = значение в случае condition = ИСТИНА
      ifFalse      = значение в случае condition = ЛОЖЬ

/*///-------------------------------------------------------------------
double  calcTPPrice(double pr, int type, int pip){
	double calc_pr = 0;
	if(type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT){
		calc_pr	=	NormalizeDouble(pr + pip*Point, Digits);
	}else{
		if(type == OP_SELL || type == OP_SELLLIMIT || type == OP_SELLSTOP){
			calc_pr	=	NormalizeDouble(pr - pip*Point, Digits);
		}	
	}
   
	return(calc_pr);
}
//======================================================================


/*///===================================================================
   Версия: 2011.03.29
   ---------------------
   Описание:
      возвращает уровень ордеро
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      нет

/*///-------------------------------------------------------------------
int getOrderLevel(int ticket){
   int res = -1;
   //---------------
   if(!OrderSelect(ticket,SELECT_BY_TICKET)) return(-1);
   //---
   res = StrToInteger(returnComment(OrderComment(),"@l"));
   //---
   if(res == -1){
      res = StrToInteger(ReadIniString  (file_ord, ticket, "level", "-1"));
   }  
   //---------------
   return(res);
}
//======================================================================
/*///===================================================================
   Версия: 2011.03.30
   ---------------------
   Описание:
      возвращает родительский тикет для текущего ордера
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      ticket - тикет ордера, для которого определяем родителя

/*///-------------------------------------------------------------------
int getParentByTicket(int ticket){
    int res = -1;
    //---------------
        if(!OrderSelect(ticket,SELECT_BY_TICKET)) return(-1);
        //---
        res = StrToInteger(returnComment(OrderComment(),"@p"));
        //---
        if(res == -1){
            res = StrToInteger(ReadIniString  (file_ord, ticket, "parent", "-1"));
        }  
    //---------------
    return(res);
    
}
//======================================================================
/*///===================================================================
   Версия: 2011.03.29
   ---------------------
   Описание:
      возвращает результат проверки - является ли текущий уровень 
      рыночным. т.е. есть ли рыночные ордера этого уровня      
   ---------------------
   Доп. функции:
        .checkOrderByTicket()
        .getOrderLevel()
        .getParentByTicket()
   ---------------------
   Переменные:
      нет

/*///-------------------------------------------------------------------
int isMarketLevel(int parent_ticket, int level, int magic){

   int res = -1;
   
      int t = OrdersTotal();
      for(int i = t; i >= 0; i--){
         int      ot    = OrderTicket();
         int      oty   = OrderType();
         string   ocomm = OrderComment(); 
         //==============
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
            //---
            if(!checkOrderByTicket(ot, CHK_TYLESS, "", magic, 1)) continue; // проверим, чтоб ордер был рыночным
            //---
            int olevel = getOrderLevel(ot);
            //---
            if(olevel != level) continue;
            //---
            if(getParentByTicket(ot) != parent_ticket) continue;
         //==============      
         res = 1;
      }
   
   return(res);
}
//======================================================================
/*///===================================================================
    Версия: 2011.03.30
    ---------------------
    Описание:
        возвращает, какой тип операции был у 
        ордера при его выставлении
    ---------------------
    Доп. функции:
        нет
    ---------------------
    Переменные:
        нет
/*///-------------------------------------------------------------------
int getWasType(int ticket){
    int res = -1;
    //---------------
    if(!OrderSelect(ticket,SELECT_BY_TICKET)) return(-1);
    //---
    res = StrToInteger(returnComment(OrderComment(),"@w"));
    //---
    if(res == -1){
        res = StrToInteger(ReadIniString  (file_ord, ticket, "wasType", "-1"));
    }  
    //---------------
    return(res);    
}
//======================================================================
/*///===================================================================
   Версия: 2011.03.30
   ---------------------
   Описание:
      возвращает результат в виде "@vm1.6@vp3.2" 
            vm - объем рыночных, 
            vp - отложенных
   ---------------------
   Доп. функции:
      нет
   ---------------------
   Переменные:
      нет

/*///-------------------------------------------------------------------
string getLevelOpenedVol(int parent_ticket, int level, int type, int magic){
    string res = "";

    double vm = 0;      // объем рыночных ордеров
    double vp = 0;      // объем отложенных ордеров
    
    int t = OrdersTotal();
    for(int i = t; i >= 0; i--){
        //==============
			//---
            if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
            //---
			int      ot     = OrderTicket() ;
			int      oty    = OrderType()   ;
			string   ocomm  = OrderComment(); 
			double   ol     = OrderLots()   ;
			//---
            if(!checkOrderByTicket(ot, CHK_MN, "", magic, -1)) continue; // проверим, чтоб ордер был рыночным
            //---
            int olevel = getOrderLevel(ot);
            //---
            if(olevel != level) continue;
            //---
            if(getParentByTicket(ot) != parent_ticket) continue;
            //--- вычислим, какие рыночные ордера могут быть для заданного типа ордера
                if(type == OP_BUYLIMIT)
                    int MarketType = OP_BUY;
                //----    
                if(type == OP_SELLLIMIT)
                    MarketType = OP_SELL;
                //----
                if(type == OP_BUYSTOP)
                    MarketType = OP_BUY;
                //----
                if(type == OP_SELLSTOP)
                    MarketType = OP_SELL;            
                //----
            //----
            int wasType = getWasType(ot); // определим тип ордера, который был
            if(wasType != type) continue;
        //==============      
        if(oty <= 1){
            vm = vm+ol;
        }else{
            if(oty >= 2){
                vp = vp+ol;
            }
        }
        
    }
    //---
    res = StringConcatenate("@vm_",DoubleToStr(vm,2),"@vp_",DoubleToStr(vp,2));
    return(res);    
}
//======================================================================