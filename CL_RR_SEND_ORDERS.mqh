//+------------------------------------------------------------------+
//|                                           CL_RR_SEND_ORDERS.mqh  |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+


   
void sendOrderLimit()
   {
   ResetLastError();
   //ORDER DETAILS
   string nametpext  = prefix2+"TPExt-0";
   string nameslext  = prefix2+"SLExt-0";
   string nameopext  = prefix2+"LineExt-0";
   
   double openP = NormalizeDouble(ObjectGetDouble(0,nameopext,OBJPROP_PRICE1),_Digits);
   double sl = NormalizeDouble(ObjectGetDouble(0,nameslext,OBJPROP_PRICE1),_Digits);
   double tp = NormalizeDouble(ObjectGetDouble(0,nametpext,OBJPROP_PRICE1),_Digits);
  
   double sldist = MathAbs(openP-sl);
   double koefrisk = riskpercents;
   double lotsizeunfiltered = 1;
   double lotsize = calcLots(sldist,koefrisk,lotsizeunfiltered);

   datetime expiration = 0;
   
   ENUM_ORDER_TYPE orderType;
   if(Close[0]>openP)
      {
      //sell stop and buy limit
      if(sl>tp)orderType=OP_SELLSTOP;
      else orderType=OP_BUYLIMIT;
      }
   else
      {
      //buy stop and sell limit
      if(sl>tp)orderType=OP_SELLLIMIT;
      else orderType=OP_BUYSTOP;
      }
   
   
   //Try 9 times to send order
   int ticket=-1;
   for(int i=0;i<9;i++)
      {
      ticket = OrderSend(Symbol(),orderType,lotsize,openP,allowedSlippage,sl,tp,NULL,magic,expiration,clrNONE);
      if(ticket!=-1)
         break;
      }
   //check if order was sent
   if(ticket==-1)
      {
      Print("Error - could not send order - "+errorMeaning(GetLastError()));
      }
   }
   
void sendOrderMarket()
   {
   ResetLastError();
   //ORDER DETAILS
   string nametpext  = prefix2+"TPExt-0";
   string nameslext  = prefix2+"SLExt-0";
   
   double sl = NormalizeDouble(ObjectGetDouble(0,nameslext,OBJPROP_PRICE1),_Digits);
   double tp = NormalizeDouble(ObjectGetDouble(0,nametpext,OBJPROP_PRICE1),_Digits);
   
   ENUM_ORDER_TYPE orderType;
   if(sl>tp)orderType=OP_SELL;
   else orderType=OP_BUY;
   
   double sldist;// = MathAbs(openP-sl);
   double koefrisk = riskpercents;
   double lotsizeunfiltered = 1;
   double lotsize;// = calcLots(sldist,koefrisk,lotsizeunfiltered);
   if(orderType==OP_SELL)
      {
      sldist=MathAbs(sl-Bid);
      lotsize = calcLots(sldist,koefrisk,lotsizeunfiltered);
      }
   else
      {
      sldist=MathAbs(sl-Ask);
      lotsize = calcLots(sldist,koefrisk,lotsizeunfiltered);
      }
 
   
   datetime expiration = 0;
   //Try 9 times to send order
   int ticket=-1;
   for(int i=0;i<9;i++)
      {
      if(orderType==OP_SELL)ticket = OrderSend(Symbol(),orderType,lotsize,Bid,allowedSlippage,sl,tp,NULL,magic,expiration,clrNONE);
      else ticket = OrderSend(Symbol(),orderType,lotsize,Ask,allowedSlippage,sl,tp,NULL,magic,expiration,clrNONE);
      
      if(ticket!=-1)
         break;
      }
   //check if order was sent
   if(ticket==-1)
      {
      Print("Error - could not send order - "+errorMeaning(GetLastError()));
      }
   }
   
   

double calcLots(double riskPips,double &koef,double &lotu)
   {
   double balance = AccountBalance();
   riskPips=riskPips/_Point/10;
   
   double riskindollars = balance*riskpercents/100.0;
   double pipVal = MarketInfo(Symbol(), MODE_TICKVALUE)*10.0;
   double lotSize = MathFloor(riskindollars/(riskPips*pipVal)*100)/100;
   lotu = riskindollars/(riskPips*pipVal);
   lotSize=NormalizeDouble(lotSize,2);
   koef = lotSize*riskPips*pipVal/balance*100;
   if(lotSize==0)lotSize=0.0000001;
   return lotSize;
   }