//+------------------------------------------------------------------+
//|                                                 CodeLocus_RR.mq4 |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property version   "1.00"
#property strict

#include "CL_RR_GLOBAL_VAR.mqh"
#include "CL_RR_ON_EVENT.mqh"
#include "CL_RR_PANEL_MAIN.mqh"
#include "CL_RR_JOURNAL.mqh"
#include "CL_RR_LIMIT_ORDER.mqh"
#include "CL_RR_MARKET_ORDER.mqh"
#include "CL_RR_OBJECTS_CREATE.mqh"
#include "CL_RR_ERROR_MEANING.mqh"
#include "CL_RR_SEND_ORDERS.mqh"
#include "CL_RR_EVENT_CREATE_OBJ.mqh"
#include "CL_RR_EVENT_CHANGE_OBJ.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

int OnInit()
  {
   

   if(IsTesting())
      {
      Comment("EA DOES NOT WORK IN STRATEGY TESTER");
      Print("EA DOES NOT WORK IN STRATEGY TESTER");
      }
   else
      {
      EventSetMillisecondTimer(333);
      
      //ChartSetInteger(0,CHART_SCALEFIX,false);
      indiTime=GetTickCount()+33;
      //Print(ppi);
      pmpix=int(pmpix*(dpikoef));
   //--- indicator buffers mapping
      string butname = prefix+"more-0";
      string panelname = prefix+"panel_base-0";
      string tpname = prefix2+"TP-0";
      if(ObjectFind(0,butname)!=0&&ObjectFind(0,panelname)!=0)
         {
         //buttonCreate(0,butname,0,25,0,25,18,CORNER_RIGHT_UPPER,"RR");
         createPanelMore();
         
         }
      if(ObjectFind(0,tpname)==0)
         {
         //mapLastObjectClickedPoints(prefix2+"TP-0");
         rr_tp_level=true;
         mapLastObjectClickedPoints(prefix2+"Line-0"); 
         string namemove= prefix2+"Move-0";
         ChartTimePriceToXY(0,0,ObjectGetInteger(0,namemove,OBJPROP_TIME1),ObjectGetDouble(0,namemove,OBJPROP_PRICE1),lastxmove,lastymove);
            
         }
      //beforelastObjectClickedTime=int(GetTickCount());  
      ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,1);
      ChartSetInteger(0,CHART_EVENT_OBJECT_DELETE,1);
      }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   if(reason!=3)
      {
      ObjectsDeleteAll(0,prefix);
      ObjectsDeleteAll(0,prefix2);
      }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
   if(!IsTesting()&&rr_tp_level)
      {
      if(ObjectFind(0,prefix+"confirm_market_panel_less-0")>=0||ObjectFind(0,prefix+"confirm_market_panel_more-0")>=0)
         {
         //Modify Open line
         marketOrderCheckOpenPrice();
         }
      }
      
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   if(chartWidth!=ChartGetInteger(0,CHART_WIDTH_IN_PIXELS))
      {
      //correct object the positons
      }
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id_,
                  const long &lparam_,
                  const double &dparam_,
                  const string &sparam_)
  {
  
  check_event(id_,lparam_,dparam_,sparam_);
  
  }
//+------------------------------------------------------------------+

  
void mapLastObjectClickedPoints(string name)//maps the coordinates of RR obj right after its creation
                                            // cooridantes are then used in RR obj move function 
   {
   string nr = getNr(name);
   datetime linetime1,linetime2;
   double lineprice,tpprice1,slprice1,tpprice2,slprice2,tpprice,slprice;
   string nameop =prefix2+"Line-"+nr ;
   string nametp =prefix2+"TP-"+nr ;
   string namesl =prefix2+"SL-"+nr ;
   linetime1= datetime(ObjectGetInteger(0,nameop,OBJPROP_TIME1));
   linetime2= datetime(ObjectGetInteger(0,nameop,OBJPROP_TIME2));
   lineprice= ObjectGetDouble(0,nameop,OBJPROP_PRICE1);
   tpprice1= ObjectGetDouble(0,nametp,OBJPROP_PRICE1);
   tpprice2= ObjectGetDouble(0,nametp,OBJPROP_PRICE2);
   slprice1= ObjectGetDouble(0,namesl,OBJPROP_PRICE1);
   slprice2= ObjectGetDouble(0,namesl,OBJPROP_PRICE2);
   
   if((tpprice1+tpprice2)>(slprice1+slprice2))
      {
      if(tpprice1>tpprice2)tpprice=tpprice1;
      else tpprice=tpprice2;
      if(slprice1>slprice2)slprice=slprice2;
      else slprice=slprice1;
      }
   else
      {
      if(tpprice1<tpprice2)tpprice=tpprice1;
      else tpprice=tpprice2;
      if(slprice1<slprice2)slprice=slprice2;
      else slprice=slprice1;
      }
   tpprice=NormalizeDouble(tpprice,Digits);
   slprice=NormalizeDouble(slprice,Digits);
   
   //MAP X and Y for all points
   int window = 0;
   ChartTimePriceToXY(0,window,linetime1,lineprice,lastObjectClickedXleft,lastObjectClickedYopen);
   ChartTimePriceToXY(0,window,linetime1,tpprice,lastObjectClickedXleft,lastObjectClickedYtp);
   ChartTimePriceToXY(0,window,linetime2,slprice,lastObjectClickedXright,lastObjectClickedYsl);
   
   
 
   }

 
string getNr(string name)//gets obj id nr at the end of the name?
   {
   int pos = StringFind(name,"-");
   string strnr="";
   for(int i=pos+1;i<StringLen(name);i++)
      {
      strnr+=CharToString(char(name[i]));
      }
   return strnr;
   }




