//+------------------------------------------------------------------+
//|                                               CL_RR_ON_EVENT.mqh |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+





void check_event(int id,
                  long lparam,
                  double dparam,
                  string sparam)
   {
  /* int id=id_;
   long lparam=lparam_;
   double dparam=dparam_;
   string sparam=sparam_;*/
   
   
   bool xcorrect = (int(lparam)>1&&int(lparam)<ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));//used to maintain obj inside the visible window
   bool ycorrect = (int(dparam)>1&&int(dparam)<ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS));
   
   if(id==CHARTEVENT_OBJECT_DELETE)
      {
      if(StringFind(sparam,prefix2)>=0)
         {
         ObjectsDeleteAll(0,prefix2);
         rrexists=false;
         rr_stop_level=false;
         rr_tp_level=false;
         ObjectsDeleteAll(0,prefix);
         createPanelMore();
         
         }
      }
      
   if(id==CHARTEVENT_OBJECT_CLICK)
      {
      //Print(lparam);
      //Print(ObjectGetInteger(0,sparam,OBJPROP_XSIZE));
      lastObjectClickedX=int(lparam);
      lastObjectClickedY=int(dparam);
      lastObjectClickedName=sparam;
      
      event_object_clicked(sparam,lastObjectClickedX,lastObjectClickedY);
      
      }
   /*   
   if(creating_new_rr_obj)
      {
      event_creating_rr_obj(id,lparam,dparam,sparam);
      }
      */
   event_change_in_rr_obj(id,lparam,dparam,sparam);
   
   if(id==CHARTEVENT_CLICK)
      {
                        
      if(mstate &&!rr_open_level)//skip open price selection// auto selelect market price as open
            {
            int x,y;
            ChartTimePriceToXY(0,0,Time[0],Close[0],x,y);
            lparam=x;
            dparam=y;
            
            ObjectsDeleteAll(0,prefix);
            createConfirmMarketPanelMore();
            rr_open_level=true;
            createOpenExtLine(int(lparam),int(dparam));
            //string nameopext =prefix2+"LineExt-0" ; 
           // ObjectSetInteger(0,nameopext,OBJPROP_COLOR,clrBlack); 
            }
         
         
   
      if((limstate||mstate||rrstate)&&!rr_open_level)
         {
         if(!mstate)
            {
            ObjectsDeleteAll(0,prefix);
            createPanelMore();//????? why is it here?????????????????
            rr_open_level=true;
            createOpenExtLine(int(lparam),int(dparam));
            string nameopext =prefix2+"LineExt-0" ; 
            ObjectSetInteger(0,nameopext,OBJPROP_COLOR,clrBlack); 
            }
         /*else //skip open price selection
            {
            int x,y;
            ChartTimePriceToXY(0,0,Time[0],Close[0],x,y);
            lparam=x;
            dparam=y;
            
            ObjectsDeleteAll(0,prefix);
            createConfirmMarketPanelMore();
            rr_open_level=true;
            createOpenExtLine(int(lparam),int(dparam));
            //string nameopext =prefix2+"LineExt-0" ; 
           // ObjectSetInteger(0,nameopext,OBJPROP_COLOR,clrBlack); 
            }*/
         }    
         
      else if((limstate||mstate||rrstate)&&rr_open_level)
         {
         if(!rrexists&&xcorrect&&ycorrect)
            {
            
            createNewRR(int(lparam),int(dparam));
            if(rrexists)
               {
               string nameslext =prefix2+"SLExt-0" ;
               ObjectSetInteger(0,nameslext,OBJPROP_COLOR,clrRed);
               string nameopext =prefix2+"LineExt-0" ; 
               ObjectSetInteger(0,nameopext,OBJPROP_COLOR,clrNONE);  
   
               string namesltext =prefix2+"SLText-0";
               ObjectSetInteger(0,namesltext,OBJPROP_COLOR,clrRed);
               }
               
            }  
         else if(rrexists)
            {
            
            if(!rr_stop_level&&xcorrect&&ycorrect)
               {
               //editSl(int(lparam),int(dparam));
               if(checkSlClick(int(lparam),int(dparam)))rr_stop_level=true;//chechs if sl is larger than spread, although it should check 
                                                                    // minimum SL distance set by the brokers
               if(rr_stop_level)
                  {
                  string nametpext =prefix2+"TPExt-0" ; 
                  ObjectSetInteger(0,nametpext,OBJPROP_COLOR,clrGreen);
                  string nameslext =prefix2+"SLExt-0" ;
                  ObjectSetInteger(0,nameslext,OBJPROP_COLOR,clrNONE);
                  //string nameslinfoext =prefix2+"SLInfoExt-0";
                  //ObjectSetInteger(0,nameslinfoext,OBJPROP_COLOR,clrRed);
                  string nametptext =prefix2+"TPText-0";
                  ObjectSetInteger(0,nametptext,OBJPROP_COLOR,clrGreen);
                  }
                  
               
               }
            else
               {
               if(!rr_tp_level&&xcorrect&&ycorrect)
                  {
                  
                  string namesl =prefix2+"SL-0";
                  string nameop =prefix2+"Line-0";
                  double pricesl = ObjectGetDouble(0,namesl,OBJPROP_PRICE1);
                  double priceop = ObjectGetDouble(0,nameop,OBJPROP_PRICE1);
                  datetime timeop =datetime(ObjectGetInteger(0,nameop,OBJPROP_TIME1));
                  
                  double pricex;
                  datetime timey;
                  int window=0;
                  ChartXYToTimePrice(0,int(lparam),int(dparam),window,timey,pricex);
                  if(pricesl<priceop)
                     {
                     if(pricex>priceop)
                        {
                        
                        //if(timeop!=timey)//check time in case( SL time == open time)
                          // {
                           //editTp(int(lparam),int(dparam)); 
                        rr_tp_level=true;
                        string nametpext =prefix2+"TPExt-0" ; 
                        ObjectSetInteger(0,nametpext,OBJPROP_COLOR,clrNONE);
                        createMoreLess(); 
                          // } 
                        }
                     }
                  else
                     {
                     if(pricex<priceop)
                        {
                        //editTp(int(lparam),int(dparam)); 
                        rr_tp_level=true;
                        string nametpext =prefix2+"TPExt-0" ; 
                        ObjectSetInteger(0,nametpext,OBJPROP_COLOR,clrNONE);
                        createMoreLess();  
                        }
                     }
                     
                  
                  
                  
                  
                  
                  }
               if(rr_tp_level)
                  {
                  
                  
                  //ObjectSetInteger(0,prefix+"Button1",OBJPROP_STATE,0);
                  ObjectSetInteger(0,prefix2+"MoreText-0",OBJPROP_COLOR,clrBlack);
                  
                  
                  mapLastObjectClickedPoints(prefix2+"Line-0"); 
                  //Add touch points
                  createMove();
                  createClickable();
                  //mapLastObjectClickedPoints(prefix2+"Line-0"); 
                  laststateobj=true;
                  rrstate=false;
                  if(limstate)
                     {
                     ObjectsDeleteAll(0,prefix);
                     createConfirmPanelLimit();
                     }
                  limstate=false;
                  if(mstate)
                     {
                     ObjectsDeleteAll(0,prefix);
                     createConfirmPanelMarket();
                     
                     }
                  mstate=false;
                  } 
               }
                 
            }
         
         }
      
      if(rr_tp_level)
         {
         
        
         mapLastObjectClickedPoints(prefix2+"Line-0"); 
         string namemove= prefix2+"Move-0";
         ChartTimePriceToXY(0,0,ObjectGetInteger(0,namemove,OBJPROP_TIME1),ObjectGetDouble(0,namemove,OBJPROP_PRICE1),lastxmove,lastymove);
         
         
         
         }
      beforelastObjectClickedTime=lastObjectClickedTime;
      lastObjectClickedTime=GetTickCount();
      
      if(xcorrect)
         {
         beforelastx = lastx;
         lastx=int(lparam);
         }
      if(ycorrect)
         {
         beforelasty = lasty;
         lasty=int(dparam);
         }
      //map zone

      }
   if(!(limstate||mstate||rrstate))
      {
      rr_open_level=false;
      }
     
   //Follow and modify RR objects when dragged
   if(id==CHARTEVENT_MOUSE_MOVE&&xcorrect&&ycorrect)
      {
      
      /*if(!(limstate||mstate||rrstate))//active when RR object is already created
         {
         //Print(sparam);
         if(int(sparam)==1) // sparam = mouse state // 1 =  mouse left button is 
            {
            //Print(selectedpoint);
            objMoved(int(lparam),int(dparam));// lparam = x // dparam = y
            }
         else if(int(sparam)==0)// no button clicked
            {
            if(selectedpoint!=-1)enableAll();
            selectedpoint=-1;
            }
         }*/
      if((limstate||mstate||rrstate)) 
         {
         
         if(!rrexists)// active when object is being created
            {
            editOp(int(lparam),int(dparam));////////////////////////////
            }
         else if(!rr_stop_level)//&&!mstate)//Market Order Open price should be constant and no edit point should be created
            {
            
            editSl(int(lparam),int(dparam));
            }
         else if(!rr_tp_level)
            {
            editTp(int(lparam),int(dparam));
            }
         }
      beforeprevstate=prevstate;
      prevstate=int(sparam);
      }
   
   
   }
