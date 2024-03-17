//+------------------------------------------------------------------+
//|                                      CL_RR_EVENT_CHANGE_OBJ.mqh  |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+


void event_creating_rr_obj(int id,
                  long lparam,
                  double dparam,
                  string sparam)
   {
   if(id==CHARTEVENT_CLICK)
      {
      
      }
   else if(id==CHARTEVENT_MOUSE_MOVE)
      {
      
      }
   }
   
   
bool createNewRR(int x, int y)//Craetes Following Objects - SL rectangle, SL extension, TP rectangle, TP extension
                                                          //Open Line, Open extension, TP text, SL text
   {
   //Coord to time & price
   datetime timeClick=0;
   double priceClick=0;
   int window=0;
   ChartXYToTimePrice(0,x,y,window,timeClick,priceClick);  
   
   priceClick=NormalizeDouble(priceClick,Digits);
   //RR width
   
   int widthRRbars = barsInWindow/5;
   //Time2
   datetime time2= timeClick;//+PeriodSeconds(Period())*widthRRbars;
   datetime timeext =timeClick-PeriodSeconds(Period()); 
   datetime timeTo = timeClick+PeriodSeconds(Period()); 
   //Window Max Min price
   double windMax = WindowPriceMax();
   double windMin = WindowPriceMin();
   //TP & SL box hight
   double boxHight= 0;//(windMax-windMin)/6;
 
   
   //TP Line extension
   lineExtension(0,
               prefix2+"TPExt-"+IntegerToString(rrnr),
               0,
               timeClick,
               priceClick+boxHight,
               timeext,
               priceClick+boxHight,
               clrNONE,
               STYLE_DASH,
               false
               );
   //SL Line extension
   lineExtension(0,
               prefix2+"SLExt-"+IntegerToString(rrnr),
               0,
               timeClick,
               priceClick-boxHight,
               timeext,
               priceClick-boxHight,
               clrNONE,
               STYLE_DASH,
               false
               );
   
   TextCreate(0,
            prefix2+"TPText-0",
            0,
            timeClick,
            priceClick,
            " Target: ",
            "Arial",
            12,
            clrNONE
            );
    
   TextCreate(0,
            prefix2+"SLText-0",
            0,
            timeClick,
            priceClick,
            " Stop: ",
            "Arial",
            12,
            clrNONE
            );
   
   //TP
   createNewTP(0,
               prefix2+"TP-"+IntegerToString(rrnr),
               0,
               timeClick,
               priceClick+boxHight,
               time2,
               priceClick
               );
   
   //SL
   createNewSL(0,
               prefix2+"SL-"+IntegerToString(rrnr),
               0,
               timeClick,
               priceClick-boxHight,
               time2,
               priceClick
               );
   //OpenLine
   createNewOpen(0,
               prefix2+"Line-"+IntegerToString(rrnr),
               0,
               timeClick,
               priceClick,
               time2,
               priceClick);
               
   
   //rrnr++;
   rrexists=true;
   return true;
   }
   

void createMoreLess()
   {
   //Print(true);
   string nametp =prefix2+"TP-0";
   string namesl =prefix2+"SL-0";
   double pricextp=ObjectGetDouble(0,nametp,OBJPROP_PRICE1);
   double pricexsl=ObjectGetDouble(0,namesl,OBJPROP_PRICE1);
   datetime timey=datetime(ObjectGetInteger(0,nametp,OBJPROP_TIME2));
   //int window=0;
   //ChartXYToTimePrice(0,lastObjectClickedXright,lastObjectClickedYsl,window,timey,pricex);
   Print(pricexsl,"   ",pricextp);
   //datetime timetext = ObjectGetInteger(0,prefix2+"SLText-0",OBJPROP_TIME1);
   TextCreate(0,
            prefix2+"MoreText-0",
            0,
            timey+PeriodSeconds(Period())*2,
            pricexsl>pricextp?pricexsl:pricextp,
            "<< Less Info",
            "Arial",
            8,
            clrNONE,
            ANCHOR_LEFT_UPPER
            );
   }

   
void createOpenExtLine(int x,int y)
   {
   datetime timeClick=0;
   double priceClick=0;
   datetime timeTo=0;
   double priceTo=0;
   int window=0;
   
   ChartXYToTimePrice(0,x,y,window,timeClick,priceClick);
   ChartXYToTimePrice(0,x+(chartWidth-x),y,window,timeTo,priceTo);
   priceClick=NormalizeDouble(priceClick,Digits);
   datetime timeext =timeClick-PeriodSeconds(Period()); 
   lineExtension(0,
               prefix2+"LineExt-0",
               0,
               timeClick,
               priceClick,
               timeext,
               priceClick,
               clrNONE,
               STYLE_DASH
               
              
               );
   /*lineExtension(0,
               prefix2+"OpenInfoExt-0",
               0,
               timeTo,
               priceClick,
               timeClick,
               priceClick,
               clrBlack,
               STYLE_DASHDOT,
               false//RAY
               );*/
   
   TextCreate(0,
            prefix2+"OpenText-0",
            0,
            timeClick,
            priceClick,
            " OPEN: ",
            "Arial",
            12,
            clrBlack
            );
   TextCreate(0,
            prefix2+"RRText-0",
            0,
            timeClick,
            priceClick,
            " RR ||| Lots",
            "Arial",
            12,
            clrBlack,
            ANCHOR_LEFT_UPPER
            );
   } 
   
void createClickable()
   {
   string nametp  = prefix2+"TPExt-0";
   string namesl  = prefix2+"SLExt-0";
   string nameop  = prefix2+"LineExt-0";
   string namemove= prefix2+"Move-0";
   
   double pricetp = NormalizeDouble(ObjectGetDouble(0,nametp,OBJPROP_PRICE1),_Digits);
   double pricesl = NormalizeDouble(ObjectGetDouble(0,namesl,OBJPROP_PRICE1),_Digits);
   double priceop = NormalizeDouble(ObjectGetDouble(0,nameop,OBJPROP_PRICE1),_Digits);
   
   int timeleft   = int(ObjectGetInteger(0,namesl,OBJPROP_TIME2));
   int timeright  = int(ObjectGetInteger(0,namesl,OBJPROP_TIME1));
   int timemid    =int(ObjectGetInteger(0,namemove,OBJPROP_TIME1));
   
   
            
   
   //Open left
   //ChartXYToTimePrice(0,lastObjectClickedXleft,lastObjectClickedYopen,window,timeo,priceo);
   TextCreate(0,
            prefix2+"opl-0",
            0,
            timeleft,
            priceop,
            "",
            "Arial",
            8,
            clrBlack,
            ANCHOR_CENTER,
            0,
            false,
            true
            
            );
   
   //Open right
   //ChartXYToTimePrice(0,lastObjectClickedXright,lastObjectClickedYopen,window,timeo,priceo);
   TextCreate(0,
            prefix2+"opr-0",
            0,
            timeright,
            priceop,
            "",
            "Arial",
            8,
            clrBlack,
            ANCHOR_LEFT_UPPER,
            0,
            false,
            true
            
            );
   
   //Open mid
   //int window;
   //datetime timeo;
   //double priceo;
   //ChartXYToTimePrice(0,int((lastObjectClickedXright+lastObjectClickedXleft)/2),lastObjectClickedYopen,window,timeo,priceo);
   TextCreate(0,
            prefix2+"opm-0",
            0,
            timemid,
            priceop,
            "",
            "Arial",
            8,
            clrBlack,
            ANCHOR_LEFT_UPPER,
            0,
            false,
            true
            
            );
            
   //MOVE POINT
   //ChartXYToTimePrice(0,int((lastObjectClickedXright+lastObjectClickedXleft)/2),
   //lastObjectClickedYsl,
   //window,timeo,priceo);
   TextCreate(0,
            prefix2+"movem-0",
            0,
            timemid,
            pricesl>pricetp?pricesl:pricetp,
            "",
            "Arial",
            8,
            clrBlack,
            ANCHOR_LEFT_UPPER,
            0,
            false,
            true
            
            );
            
   //TP left
   //ChartXYToTimePrice(0,lastObjectClickedXleft,lastObjectClickedYtp,window,timeo,priceo);
   TextCreate(0,
            prefix2+"tpl-0",
            0,
            timeleft,
            pricetp,
            "",
            "Arial",
            8,
            clrBlack,
            ANCHOR_CENTER,
            0,
            false,
            true,
            true,
            10
            
            
            );
   
   //TP right
   //ChartXYToTimePrice(0,lastObjectClickedXright,lastObjectClickedYtp,window,timeo,priceo);
   TextCreate(0,
            prefix2+"tpr-0",
            0,
            timeright,
            pricetp,
            "",
            "Arial",
            8,
            clrBlack,
            ANCHOR_CENTER,
            0,
            false,
            true,
            true,
            10
            
            );
   
   //SL left
   //ChartXYToTimePrice(0,lastObjectClickedXleft,lastObjectClickedYsl,window,timeo,priceo);
   TextCreate(0,
            prefix2+"sll-0",
            0,
            timeleft,
            pricesl,
            "",
            "Arial",
            8,
            clrBlack,
            ANCHOR_CENTER,
            0,
            false,
            true,
            true,
            10
            
            );
   
   //SL right
   //ChartXYToTimePrice(0,lastObjectClickedXright,lastObjectClickedYsl,window,timeo,priceo);
   TextCreate(0,
            prefix2+"slr-0",
            0,
            timeright,
            pricesl,
            "",
            "Arial",
            8,
            clrBlack,
            ANCHOR_CENTER,
            0,
            false,
            true,
            true,
            10
            
            );
   
   }
   
void createMove()
   {
   int top = lastObjectClickedYsl<lastObjectClickedYtp?lastObjectClickedYsl:lastObjectClickedYtp;//using coord y 
   int middle = (lastObjectClickedXleft+lastObjectClickedXright)/2;
   int window=0;
   datetime timeobj;
   double priceobj;
   double pricesl = ObjectGetDouble(0,prefix2+"SLExt-0",OBJPROP_PRICE1);
   double pricetp = ObjectGetDouble(0,prefix2+"TPExt-0",OBJPROP_PRICE1);
   //double pricetop=
   ChartXYToTimePrice(0,middle,top,window,timeobj,priceobj);
   //Print(lastObjectClickedYsl,"----",lastObjectClickedYtp);
   //Print(timeobj,"   ",priceobj);
   
   TextCreate(0,
            prefix2+"Move-0",
            0,
            timeobj,
            pricetp>pricesl?pricetp:pricesl,
            "",
            "Arial",
            12,
            clrBlack,
            ANCHOR_LOWER,
            0,
            false
            //true
            
            );
   }
   
void editOp(int xcurr, int ycurr)
   {
   
   
   //datetime timeFirst = iTime(_Symbol,PERIOD_CURRENT,WindowFirstVisibleBar());
  // double priceMax = ChartGetDouble(0,CHART_PRICE_MAX);
  // double priceMin = ChartGetDouble(0,CHART_PRICE_MIN);
   
   string nameopext =prefix2+"LineExt-0";
   //string nameopinfoext =prefix2+"OpenInfoExt-0";
   string nameoptext =prefix2+"OpenText-0";
   string namerrtext =prefix2+"RRText-0";
   
   double pricex;
   datetime timey;
   datetime timeinfo;
   int infox = xcurr+chartWidth/7;
   if(chartWidth<infox)infox=chartWidth;
   int window=0;
   ChartXYToTimePrice(0,xcurr,ycurr,window,timey,pricex);
   ChartXYToTimePrice(0,infox,ycurr,window,timeinfo,pricex);
   openpriceg=pricex;
   
   datetime time2 = timey-PeriodSeconds(Period());
   ObjectSetInteger(0,nameopext,OBJPROP_TIME1,timey);
   ObjectSetInteger(0,nameopext,OBJPROP_TIME2,time2);
   ObjectSetDouble(0,nameopext,OBJPROP_PRICE1,pricex);
   ObjectSetDouble(0,nameopext,OBJPROP_PRICE2,pricex);
   //ObjectSetInteger(0,nameopinfoext,OBJPROP_TIME1,timey);
   //ObjectSetInteger(0,nameopinfoext,OBJPROP_TIME2,timeinfo);
   //ObjectSetDouble(0,nameopinfoext,OBJPROP_PRICE1,pricex);
   //ObjectSetDouble(0,nameopinfoext,OBJPROP_PRICE2,pricex);
   
   ObjectSetDouble(0,nameoptext,OBJPROP_PRICE1,pricex);
   ObjectSetInteger(0,nameoptext,OBJPROP_TIME1,timey);
   ObjectSetDouble(0,namerrtext,OBJPROP_PRICE1,pricex);
   ObjectSetInteger(0,namerrtext,OBJPROP_TIME1,timey);
   
  
   string textop = " RR ";//+DoubleToString(tpdist/sldist,2);//" Open: "+DoubleToString(pricex,_Digits);
   ObjectSetString(0,nameoptext,OBJPROP_TEXT,textop);
   }
   
   
void editTp(int xcurr, int ycurr)
   {
   //asda
   string nametp =prefix2+"TP-0";
   string nametpext =prefix2+"TPExt-0";
   string nameslext =prefix2+"SLExt-0";
   string nameopext =prefix2+"LineExt-0";
   string namesl =prefix2+"SL-0";
   string nameop =prefix2+"Line-0";
   //string nameopinfoext =prefix2+"OpenInfoExt-0";
   //string nametpinfoext =prefix2+"TPInfoExt-0";
   //string nameslinfoext =prefix2+"SLInfoExt-0";
   string nameoptext =prefix2+"OpenText-0";
   string nametptext =prefix2+"TPText-0";
   string namesltext =prefix2+"SLText-0";
   string namerrtext =prefix2+"RRText-0";
   
               
   //double priceop = ObjectGetDouble(0,nameop,OBJPROP_PRICE1);
   
   double pricex;
   datetime timey;
   datetime timeinfo;
   datetime beforelastxtime;
   datetime lastxtime;
   double beforelastyprice;
   double lastyprice;
   int infox = xcurr+chartWidth/7;
   if(chartWidth<infox)infox=chartWidth;
   
   int window=0;
   ChartXYToTimePrice(0,xcurr,ycurr,window,timey,pricex);
   ChartXYToTimePrice(0,infox,ycurr,window,timeinfo,pricex);
   ChartXYToTimePrice(0,beforelastx,beforelasty,window,beforelastxtime,beforelastyprice);
   ChartXYToTimePrice(0,lastx,lasty,window,lastxtime,lastyprice);
   tppriceg=pricex;
   datetime time2 = timey-PeriodSeconds(Period()); 
   ObjectSetDouble(0,nametp,OBJPROP_PRICE1,pricex);
   datetime timeright  = datetime(ObjectGetInteger(0,nametpext,OBJPROP_TIME1));
   
   if(timey<lastxtime)
      {
      ObjectSetInteger(0,nametp,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,nameop,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,namesl,OBJPROP_TIME1,timey);
      
      ObjectSetInteger(0,nametpext,OBJPROP_TIME2,timey);
      ObjectSetInteger(0,nameslext,OBJPROP_TIME2,timey);
      ObjectSetInteger(0,nameopext,OBJPROP_TIME2,timey);
      
     
      }
   else if(timey>beforelastxtime)
      {
      ObjectSetInteger(0,nametp,OBJPROP_TIME2,timey);
      ObjectSetInteger(0,nameop,OBJPROP_TIME2,timey);
      ObjectSetInteger(0,namesl,OBJPROP_TIME2,timey);
      
      ObjectSetInteger(0,nametpext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,nameslext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,nameopext,OBJPROP_TIME1,timey);
      
      ObjectSetInteger(0,nameoptext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,nametptext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,namesltext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,namerrtext,OBJPROP_TIME1,timey);
      
      
      }
    
      
   //ObjectSetInteger(0,nametpext,OBJPROP_TIME2,time2);
   
   ObjectSetDouble(0,nametpext,OBJPROP_PRICE1,pricex);
   ObjectSetDouble(0,nametpext,OBJPROP_PRICE2,pricex);
   ObjectSetDouble(0,nametptext,OBJPROP_PRICE1,pricex);
   
   
   
   
   double slprice = ObjectGetDouble(0,nameslext,OBJPROP_PRICE1);   
   double openPrice = ObjectGetDouble(0,nameopext,OBJPROP_PRICE1);  
   double tpdist = MathAbs(pricex-openPrice);
   string texttp;
   
   double koefrisk = riskpercents;
   double lotsizeunfiltered = 1;
   double sldist = MathAbs(openPrice-slprice);
   double lotsize = calcLots(sldist,koefrisk,lotsizeunfiltered);
   double dollars = MathAbs((pricex-openPrice)*lotsize*MarketInfo(_Symbol, MODE_TICKVALUE)/_Point);
   
   if(distform==showpips)texttp = " Target: "+DoubleToString(pricex,_Digits)+" ("+DoubleToString(tpdist/_Point/10,1)+")";
   else if(distform==showdollars)texttp = " Target: "+DoubleToString(pricex,_Digits)+" ("+DoubleToString(dollars,2)+")";
   else texttp = " Target: "+DoubleToString(pricex,_Digits)+" ("+DoubleToString(tpdist/_Point/10,1)+" | $"+DoubleToString(dollars,2)+")";
      
   
   ObjectSetString(0,nametptext,OBJPROP_TEXT,texttp);
   
   
  // double sldist = MathAbs(slprice-openPrice);
   string targettexto;
   if((slprice<openPrice&&pricex>openPrice)||(slprice>openPrice&&pricex<openPrice))
      {
      targettexto = " RR = "+DoubleToString(tpdist/sldist,2);
      }
   else
      {
      targettexto = " RR = 0.00";
      }
   ObjectSetString(0,nameoptext,OBJPROP_TEXT,targettexto);
   //tpedit=true;
   }
void editSl(int xcurr, int ycurr)
   {
   //asda
   datetime lastxtime;
   double lastyprice;
   string nametp =prefix2+"TP-0";
   string namesl =prefix2+"SL-0";
   string nameslext =prefix2+"SLExt-0";
   string nametpext =prefix2+"TPExt-0";
   string nameopext =prefix2+"LineExt-0";
   string nameop =prefix2+"Line-0";
   string namemtext = prefix2+"MoreText-0";
   //string nametpinfoext =prefix2+"TPInfoExt-0";
   //string nameslinfoext =prefix2+"SLInfoExt-0";
   string namesltext =prefix2+"SLText-0";
   string nametptext =prefix2+"TPText-0";
   string nameoptext =prefix2+"OpenText-0";
   string namerrtext =prefix2+"RRText-0";
   //datetime infot1 = ObjectGetInteger(0,nametpinfoext,OBJPROP_TIME1);
   //datetime infot2 = ObjectGetInteger(0,nametpinfoext,OBJPROP_TIME2);
   double pricex;
   datetime timey;
   int window=0;
   ChartXYToTimePrice(0,xcurr,ycurr,window,timey,pricex);
   ChartXYToTimePrice(0,lastx,lasty,window,lastxtime,lastyprice);
   slpriceg=pricex;
   datetime time2 = timey-PeriodSeconds(Period()); 
   //datetime timerightside = datetime(ObjectGetInteger(0,nameop,OBJPROP_TIME2));
   //if(timey<timerightside)
    //  {
     // 
     // ObjectSetInteger(0,namesl,OBJPROP_TIME1,timey);
    //  ObjectSetInteger(0,nameop,OBJPROP_TIME1,timey);
    //  ObjectSetInteger(0,nametp,OBJPROP_TIME1,timey);
    //  ObjectSetInteger(0,nameslext,OBJPROP_TIME2,timey);
     // }
     
   if(timey<lastxtime)
      {
      ObjectSetInteger(0,nametp,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,nameop,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,namesl,OBJPROP_TIME1,timey);
      
      ObjectSetInteger(0,nametpext,OBJPROP_TIME2,timey);
      ObjectSetInteger(0,nameslext,OBJPROP_TIME2,timey);
      ObjectSetInteger(0,nameopext,OBJPROP_TIME2,timey);
      
      
      }
   else
      {
      ObjectSetInteger(0,nametp,OBJPROP_TIME2,timey);
      ObjectSetInteger(0,nameop,OBJPROP_TIME2,timey);
      ObjectSetInteger(0,namesl,OBJPROP_TIME2,timey);
      
      ObjectSetInteger(0,nametpext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,nameslext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,nameopext,OBJPROP_TIME1,timey);
      
      ObjectSetInteger(0,nameoptext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,nametptext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,namesltext,OBJPROP_TIME1,timey);
      ObjectSetInteger(0,namerrtext,OBJPROP_TIME1,timey);
      
      
      }
     
   
   ObjectSetDouble(0,namesl,OBJPROP_PRICE1,pricex);   
   ObjectSetDouble(0,nameslext,OBJPROP_PRICE1,pricex);
   ObjectSetDouble(0,nameslext,OBJPROP_PRICE2,pricex);
   
   
   
   if(tppriceg<openpriceg)ObjectSetDouble(0,namemtext,OBJPROP_PRICE1,pricex);
   //ObjectSetInteger(0,namesltext,OBJPROP_TIME1,timey);
   ObjectSetDouble(0,namesltext,OBJPROP_PRICE1,pricex);
   double openPrice = ObjectGetDouble(0,nameopext,OBJPROP_PRICE1);
   
         
   
        // string targettext;
        // if(distform==showpips)targettext = "Target: "+DoubleToString(pricex,_Digits)+" ("+DoubleToString(MathAbs((pricex-priceop)/_Point/10),1)+")";
        // else if(distform==showdollars)targettext = "Target: "+DoubleToString(pricex,_Digits)+" ($"+DoubleToString(dollars,2)+")";
        // else targettext = "Target: "+DoubleToString(pricex,_Digits)+" ("+DoubleToString(MathAbs((pricex-priceop)/_Point/10),1)+" | $"+DoubleToString(dollars,2)+")";
         
   
   double koefrisk = riskpercents;
   double lotsizeunfiltered = 1;
   double sldist = MathAbs(openPrice-pricex);
   if(sldist==0)sldist=1;
   double lotsize = calcLots(sldist,koefrisk,lotsizeunfiltered);
   double dollars = MathAbs((pricex-openPrice)*lotsize*MarketInfo(_Symbol, MODE_TICKVALUE)/_Point);
   string textsl;
   if(distform==showpips)textsl = " Stop: "+DoubleToString(pricex,_Digits)+" ("+DoubleToString(MathAbs((pricex-openPrice)/_Point/10),1)+")";
   else if(distform==showdollars)textsl = " Stop: "+DoubleToString(pricex,_Digits)+" ($"+DoubleToString(dollars,2)+")";
   else textsl = " Stop: "+DoubleToString(pricex,_Digits)+" ("+DoubleToString(MathAbs((pricex-openPrice)/_Point/10),1)+" | $"+DoubleToString(dollars,2)+")";
   
   
   ObjectSetString(0,namesltext,OBJPROP_TEXT,textsl);
   double tpPrice = ObjectGetDouble(0,nametpext,OBJPROP_PRICE1);
   //double openPrice = ObjectGetDouble(0,nameopext,OBJPROP_PRICE1);
   //double sldist = MathAbs(openPrice-pricex);
   
   
   //double koefrisk = riskpercents;
   //double lotsizeunfiltered = 1;
  // double lotsize = calcLots(sldist,koefrisk,lotsizeunfiltered);
   string lotss = " Lots="+DoubleToString(lotsize,2)+" (Risk="+DoubleToString(koefrisk,2)+"%)";
   double minlot = MarketInfo(Symbol(),MODE_MINLOT);
   if(lotsize<minlot)
      {
      
      double riskrecalc = riskpercents*(minlot/lotsizeunfiltered);
      if(riskrecalc>100)riskrecalc=100.0;
      lotss=" Risk="+DoubleToString(riskrecalc,2)+" %(Lot="+DoubleToString(minlot,2)+")";
      }
   string targettextrr = lotss;
   
 
   double tpdist = MathAbs(openPrice-tpPrice);
   
   string targettexto = " RR = 0.00";//+DoubleToString(tpdist/sldist,2);
   ObjectSetString(0,nameoptext,OBJPROP_TEXT,targettexto);
   ObjectSetString(0,namerrtext,OBJPROP_TEXT,targettextrr);
   
   //sledit=true;
   }
   
bool checkSlClick(int x,int y)
   {
   datetime timex;
   double pricey;
   int window=0;
   ChartXYToTimePrice(0,x,y,window,timex,pricey);
   //Comment(MarketInfo(_Symbol,MODE_SPREAD));
   double priceOpen = ObjectGetDouble(0,prefix2+"Line-0",OBJPROP_PRICE1);
   if(MathAbs(pricey-priceOpen)<=MarketInfo(_Symbol,MODE_STOPLEVEL)*_Point)return false;
   else return true;
   }