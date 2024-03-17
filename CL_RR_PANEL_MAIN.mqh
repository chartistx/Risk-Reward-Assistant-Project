//+------------------------------------------------------------------+
//|                                             CL_RR_PANEL_MAIN.mqh |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+


void createPanelMore()//creates ||| line menu when the indicator is initilized (UI start position)
   {
   int chwidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
   int chheight = int(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS));
   int x=chwidth/2+12;
   int y=1;
   LabelCreate(0,prefix+"more-0",0,x,y);// sides are +- 8 pixels from center
   
   //Create journal button
   createJournalButton();
   }
   
void createJournalButton()// Creates Camera image at the start position
   {
   
   int chwidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
   int chheight = int(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS));
   int x=chwidth/2;
   int y=0;
   RectLabelCreate(0,
                  prefix+"journal_obj-0",
                  0,
                  chwidth/2-40+12,
                  4,
                  20,
                  15,
                  clrNavy,
                  clrNavy);
   RectLabelCreate(0,
                  prefix+"journal_obj-1",
                  0,
                  chwidth/2-35+12,
                  2,
                  10,
                  2,
                  clrNavy,
                  clrNavy);
   LabelCreate(0,prefix+"journal_obj-2",0,x-25+12,y+11,"O","Arial",9,clrWhite,0);
   LabelCreate(0,prefix+"journal_obj-3",0,x-30+12,y+7,"O","Arial",9,clrWhite,90);
   //CharToStr()
   }
   
void createPanel()// Creates panel with all main tools (menu)
   {
   //aa
   int chwidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
   int chheight = int(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS));
   int x=chwidth/2;
   int y=0;
   RectLabelCreate(0,
                  prefix+"panel_base-0",
                  0,
                  chwidth/2-132,
                  0,
                  248,
                  25,
                  clrRoyalBlue,
                  clrRoyalBlue);
   LabelCreate(0,prefix+"panel_rr-0",0,chwidth/2+15,3,
               "R:R","Bernard MT Condensed",12,clrWhite,0,ANCHOR_UPPER
               );
    
    // NO NEED FOR QUICK RISK, TRADER SHOULD NOT LOOK AT LOT SIZE WITHOUT
    // LOOKING AT TP AND HAVING GOOD RISK REWARD RATIO
    // TRADES WITH TARGET NOT EVEN CONSIDERED ARE DANGEROUS
    
   //LabelCreate(0,prefix+"panel_qr-0",0,chwidth/2-25,3,
     //          "QR","Bernard MT Condensed",12,clrWhite,0,ANCHOR_UPPER
     //          );
   LabelCreate(0,prefix+"panel_market-0",0,chwidth/2+45,3,
               "Market","Bernard MT Condensed",12,clrWhite,0,ANCHOR_LEFT_UPPER
               );
   LabelCreate(0,prefix+"panel_limit-0",0,chwidth/2-55,3,
               "P-Ord","Bernard MT Condensed",12,clrWhite,0,ANCHOR_RIGHT_UPPER
               );
   LabelCreate(0,prefix+"panel_less-0",0,chwidth/2+120,6,
               ">>","Bernard MT Condensed",9,clrMidnightBlue,90,ANCHOR_RIGHT_UPPER
               );
   }

void event_object_clicked(string sparam,int x, int y)//called from OnChartEvent()
   {
   int chwidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
   int x1=chwidth/2-40+12-1;
   //obj width 20
   //y= 1-25
   //
   string confnamel = prefix+"confirm_limit_panel_confirm-0";
   string cancelnamel = prefix+"confirm_limit_panel_cancel-0";
   string confnamem = prefix+"confirm_market_panel_confirm-0";
   string cancelnamem = prefix+"confirm_market_panel_cancel-0";
   string lessmpanel = prefix+"confirm_market_panel_less-0";
   string morempanel = prefix+"confirm_market_panel_more-0";
   string journal_confirm = prefix+"journal_panel_confirm-0";
   string journal_cancel = prefix+"journal_panel_cancel-0";
   
   string mname = prefix2+"MoreText-0";
   
   if(sparam==prefix+"more-0")// main ||| lines clicked
      {
      ObjectsDeleteAll(0,prefix);
      createPanel();
      
      }
   else if(x>x1&&x<x1+23&&y<24)//photo clicked
      {
      
      int mes = MessageBox("Picture has been taken.\nWould you like to add a comment?","Trading Journal",MB_YESNO);
      if(mes==6)
         {
         ObjectsDeleteAll(0,prefix);
         int cwidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
         int cheight = int(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS));
         //RectLabelCreate(0,prefix+"text_panel-0",0,0,0,cwidth,cheight,clrWhite);
         ChartSetInteger(0,CHART_FOREGROUND,false);
         
         //Create Add Comment and Cancel Buttons
         createConfirmPanelJournalComment();
         }
      }
   else if(sparam==prefix+"panel_less-0")
      {
      ObjectsDeleteAll(0,prefix);
      createPanelMore();
      
      }
   else if(sparam==prefix+"panel_rr-0")
      {
      rrstate=true;
      
      }
  /* else if(sparam==prefix+"panel_qr-0")
      {
      qrstate=true;
      
      }*/
   else if(sparam==prefix+"panel_limit-0")
      {
      limstate=true;
      }
   else if(sparam==prefix+"panel_market-0")
      {
      mstate=true;
      }
   else if(sparam==cancelnamel||sparam==cancelnamem)// cancel limit or market order clicked
      {
      ObjectsDeleteAll(0,prefix2);
      ObjectsDeleteAll(0,prefix);
      createPanelMore();
      
      }
   else if(sparam==confnamel)//confirm limit order clicked
      {
      // SEND ORDER
      // THEN TAKE PICTURE
      // THEN DELETE OBJECTS
      
      sendOrderLimit();//Limit Order
      
      // THAKE PICTURE, JOURNAL
      
      ObjectsDeleteAll(0,prefix);
      ObjectsDeleteAll(0,prefix2);
      createPanelMore();
      
      
      //send limit order
      }
   else if(sparam==confnamem)// confirm market order clicked
      {
      // SEND ORDER
      // THEN TAKE PICTURE
      // THEN DELETE OBJECTS
      
      sendOrderMarket();//Market Order
      ObjectsDeleteAll(0,prefix2);
      ObjectsDeleteAll(0,prefix);
      
      createPanelMore();
      
      
      //send market order
      }
   else if(sparam==lessmpanel)// hide order confirmation/cancel  panel clicked
      {
      ObjectsDeleteAll(0,prefix);
      createConfirmMarketPanelMore();
      }
   else if(sparam==morempanel)//show order confirm/cancel panel clicked
      {
      ObjectsDeleteAll(0,prefix);
      createConfirmPanelMarket();
      }
   else if(sparam == journal_confirm)// journal confirm text button clicked
      {
      ObjectsDeleteAll(0,prefix);
      createPanelMore();
      }
   else if(sparam == journal_cancel)//journal cancel button was clicked
      {
      ObjectsDeleteAll(0,prefix);
      createPanelMore();
      }
      
      
   //Add text when clicked on Visible Info turns invisible and back if clicked again
   
   else if(sparam==mname) // more>> or <<less was clicked
      {
      //Print(true);
      string nameoptext =prefix2+"OpenText-0";
      string nametptext =prefix2+"TPText-0";
      string namesltext =prefix2+"SLText-0";
      string namerrtext =prefix2+"RRText-0";
      string mtext = ObjectGetString(0,mname,OBJPROP_TEXT);
      if(mtext=="<< Less Info")
         {
         //Print(true);
         ObjectSetInteger(0,nameoptext,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,nametptext,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,namesltext,OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,namerrtext,OBJPROP_COLOR,clrNONE);
         
         ObjectSetString(0,mname,OBJPROP_TEXT,">> More");
         }
      else
         {
         //Print(false);
         ObjectSetInteger(0,nameoptext,OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,nametptext,OBJPROP_COLOR,clrGreen);
         ObjectSetInteger(0,namesltext,OBJPROP_COLOR,clrRed);
         ObjectSetInteger(0,namerrtext,OBJPROP_COLOR,clrBlack);
         ObjectSetString(0,mname,OBJPROP_TEXT,"<< Less Info");
         }
      }
   }
