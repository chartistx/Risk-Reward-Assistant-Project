//+------------------------------------------------------------------+
//|                                               CL_RR_JOURNAL.mqh  |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+


void createConfirmPanelJournalComment()
   {
   int chwidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
   int chheight = int(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS));
   int x=chwidth/2;
   int y=0;
   RectLabelCreate(0,
                  prefix+"panel_base_journal-0",
                  0,
                  chwidth/2-80,
                  10,
                  155,
                  25,
                  clrRoyalBlue,
                  clrRoyalBlue);

   LabelCreate(0,prefix+"journal_panel_cancel-0",0,chwidth/2+10,13,
               "Cancel","Bernard MT Condensed",12,clrWhite,0,ANCHOR_LEFT_UPPER
               );
   LabelCreate(0,prefix+"journal_panel_confirm-0",0,chwidth/2-10,13,
               "Confirm","Bernard MT Condensed",12,clrWhite,0,ANCHOR_RIGHT_UPPER
               );
               
               
   RectLabelCreate(0,prefix+"text_panel-1",0,chwidth/9*2,50,chwidth/9*5,chheight-70,clrWhite);
   }//