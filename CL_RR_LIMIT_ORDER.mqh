//+------------------------------------------------------------------+
//|                                           CL_RR_LIMIT_ORDER.mqh  |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+


void createConfirmPanelLimit()
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

   LabelCreate(0,prefix+"confirm_limit_panel_cancel-0",0,chwidth/2+10,3,
               "Cancel","Bernard MT Condensed",12,clrWhite,0,ANCHOR_LEFT_UPPER
               );
   LabelCreate(0,prefix+"confirm_limit_panel_confirm-0",0,chwidth/2-10,3,
               "Confirm","Bernard MT Condensed",12,clrWhite,0,ANCHOR_RIGHT_UPPER
               );
   }