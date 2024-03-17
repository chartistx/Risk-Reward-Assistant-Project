//+------------------------------------------------------------------+
//|                                          CL_RR_MARKET_ORDER.mqh  |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+


   
void createConfirmPanelMarket()
   {
   int chwidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
   int chheight = int(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS));
   int x=chwidth/2;
   int y=0;
   RectLabelCreate(0,
                  prefix+"panel_base-0",
                  0,
                  chwidth/2-80,
                  0,
                  155,
                  25,
                  clrRoyalBlue,
                  clrRoyalBlue);

   LabelCreate(0,prefix+"confirm_market_panel_cancel-0",0,chwidth/2+10,3,
               "Cancel","Bernard MT Condensed",12,clrWhite,0,ANCHOR_LEFT_UPPER
               );
   LabelCreate(0,prefix+"confirm_market_panel_confirm-0",0,chwidth/2-10,3,
               "Confirm","Bernard MT Condensed",12,clrWhite,0,ANCHOR_RIGHT_UPPER
               );
   LabelCreate(0,prefix+"confirm_market_panel_less-0",0,chwidth/2+75,6,
               ">>","Bernard MT Condensed",9,clrMidnightBlue,90,ANCHOR_RIGHT_UPPER
               );
   }
   
   
void createConfirmMarketPanelMore()
   {
   int chwidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
   int chheight = int(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS));
   int x=chwidth/2;
   int y=0;
   LabelCreate(0,prefix+"confirm_market_panel_more-0",0,x,y);
   }
   
   
void marketOrderCheckOpenPrice()
   {
   string nameOp= prefix2+"Line-0";
   string nameTp= prefix2+"TP-0";
   string nameSl= prefix2+"SL-0";
   
   double openPrice = NormalizeDouble(ObjectGetDouble(0,nameOp,OBJPROP_PRICE1),_Digits);
   double slPrice = NormalizeDouble(ObjectGetDouble(0,nameSl,OBJPROP_PRICE1),_Digits);
   
   double currentPrice;
   if(slPrice>openPrice)currentPrice=NormalizeDouble(Bid,_Digits);
   else currentPrice=NormalizeDouble(Ask,_Digits);
   
   if(openPrice!=currentPrice)
      {
      //edit sl price1 / tp ptice1 / open price
      ObjectSetDouble(0,nameTp,OBJPROP_PRICE2,currentPrice);
      ObjectSetDouble(0,nameSl,OBJPROP_PRICE2,currentPrice);
      ObjectSetDouble(0,nameOp,OBJPROP_PRICE1,currentPrice);
      ObjectSetDouble(0,nameOp,OBJPROP_PRICE2,currentPrice);
      }
   }
