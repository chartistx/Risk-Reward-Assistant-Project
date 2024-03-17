//+------------------------------------------------------------------+
//|                                      CL_RR_EVENT_CREATE_OBJ.mqh  |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict--------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+


void event_change_in_rr_obj(int id,
                  long lparam,
                  double dparam,
                  string sparam)
   {
   if(id==CHARTEVENT_MOUSE_MOVE)
      {
      
      if(!(limstate||mstate||rrstate))//active when RR object is already created
         {
         //Print(sparam);
         if(Mouse_Left_Button_State(uint(sparam)))//(int(sparam)==1) // sparam = mouse state // 1 =  mouse left button is clicked 
            //(state& 1)== 1)// bitmask 1 bit 
            {
            
            //Print(selectedpoint);
            objMoved(int(lparam),int(dparam));// lparam = x // dparam = y
            }
         /*else if(!Mouse_Left_Button_State(uint(sparam)))//(int(sparam)==0)// left mouse button not clicked
            {
            //Print(1111);
            if(selectedpoint>=0)enableAll();
            selectedpoint=-1;
            }*/
         }
      }
   else if(id==CHARTEVENT_CLICK)// click event must be after mouse move event else enable all after move will not work
      {
      //Print("click");
      if(selectedpoint!=-1)//meaning -1 and click happened just after object move
         {
         enableAll();
         }
      //change selected point to -1 // meaning nothing is selected and moved
      selectedpoint=-1;// when any of selectable points are moved, it changes to its nr
      
      
      
      
      //Check state of clickable points change the state of group if necessary
      
      checkClickable(); // function checks if any of the points on RR object are selected(whean all were unselected)
                        // or unselected (when all were selected) and adjusts all the rest to the same state. 
                     
      correctSelectable();//This one should only be active when RR obect state is selected
                          // Also mouse move event shoud be enabled and disabled accordingly 
                          //function corrects points on RR object
                          //when is this function necessary? when created or when?
                          
      if(rr_tp_level)//hides extended lines after object is being moved/edited
         {
         ObjectSetInteger(0,prefix2+"TPExt-0",OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,prefix2+"SLExt-0",OBJPROP_COLOR,clrNONE);
         ObjectSetInteger(0,prefix2+"LineExt-0",OBJPROP_COLOR,clrNONE);
         }
                          
      } 
      
      
   } 
   
   
bool Mouse_Left_Button_State(uint state) 
  { 
   if((state& 1)== 1)
      {
      return true;//clicked
      }
   else
      {
      return false;//released
      }
  } 
   
   
void checkClickable()//function checks if any of the points on RR object are selected(whean all were unselected)
                     // or unselected (when all were selected) 
   {
   
   string allnames[]={"CodeLocusRRo_tpl-0","CodeLocusRRo_tpr-0","CodeLocusRRo_sll-0","CodeLocusRRo_slr-0",
                        "CodeLocusRRo_opl-0","CodeLocusRRo_opr-0","CodeLocusRRo_opm-0","CodeLocusRRo_movem-0"};
   
   int count = 0;                  
   for(int i=0;i<ArraySize(allnames);i++)
      {
      count+=int(ObjectGetInteger(0,allnames[i],OBJPROP_SELECTED));
      }
   //  
  
   if(count>0&&count<4)//
      {
      for(int j=0;j<ArraySize(allnames);j++)
         {
         ObjectSetInteger(0,allnames[j],OBJPROP_SELECTED,1);
         }
      laststateobj=false;
      
      }
   else if(count>=4&&count<8)
      {
      for(int j=0;j<ArraySize(allnames);j++)
         {
         ObjectSetInteger(0,allnames[j],OBJPROP_SELECTED,0);
         }
      laststateobj=true;
    
      }
   }
   
void moveRRobj(int x, int y)
   {
   //GET LAST CLICKED DISTANCES
   int distxleft,distxright;
   int distylsl,distymid,distytp;
   distxleft=lastxmove-lastObjectClickedXleft;
   distxright=lastObjectClickedXright-lastxmove;
   distylsl=lastObjectClickedYsl-lastymove;
   distymid=lastObjectClickedYopen-lastymove;
   distytp=lastObjectClickedYtp-lastymove;
   //Get new coordinates of each point
   int xleft,xright,xmid;
   int ytp,ysl,yop;
   xleft=x-distxleft;
   xright=x+distxright;
   xmid=(xleft+xright)/2;
   ytp=y+distytp;
   ysl=y+distylsl;
   yop=y+distymid;
   int window=0;
   //CONVERT PIXELS TO TIME AND PRICE
   datetime timexleft,timexright,timexmid;
   double priceysl,priceytp,priceyop;
   ChartXYToTimePrice(0,xleft,yop,window,timexleft,priceyop);
   ChartXYToTimePrice(0,xmid,ysl,window,timexmid,priceysl);
   ChartXYToTimePrice(0,xright,ytp,window,timexright,priceytp);
   
   
   
   //EDIT POINTS ACCORDINGLY
   string objnr = getNr(lastObjectClickedName);
   string nameop =prefix2+"Line-0" ;
   string nametp =prefix2+"TP-0";
   string namesl =prefix2+"SL-0" ;
   string nameopext =prefix2+"LineExt-0" ;
   string nametpext =prefix2+"TPExt-0" ;
   string nameslext =prefix2+"SLExt-0" ;
   string nameoptext =prefix2+"OpenText-0";
   string nametptext =prefix2+"TPText-0";
   string namesltext =prefix2+"SLText-0";
   string namerrtext =prefix2+"RRText-0";
   string namemtext = prefix2+"MoreText-0";
   //string movename = prefix2+"Move-0";
   //Move profit,loss,open
   
   /*ObjectSetInteger(0,movename,OBJPROP_TIME1,timexmid);
   if(ytp<ysl)ObjectSetDouble(0,movename,OBJPROP_PRICE1,priceytp);
   else ObjectSetDouble(0,movename,OBJPROP_PRICE1,priceysl);
   */
   
   ObjectSetInteger(0,nameop,OBJPROP_TIME1,timexleft);
   ObjectSetInteger(0,nameop,OBJPROP_TIME2,timexright);
   ObjectSetDouble(0,nameop,OBJPROP_PRICE1,priceyop);
   ObjectSetDouble(0,nameop,OBJPROP_PRICE2,priceyop);
   
   ObjectSetInteger(0,nametp,OBJPROP_TIME1,timexleft);
   ObjectSetInteger(0,nametp,OBJPROP_TIME2,timexright);
   ObjectSetDouble(0,nametp,OBJPROP_PRICE1,priceytp);
   ObjectSetDouble(0,nametp,OBJPROP_PRICE2,priceyop);
   
   ObjectSetInteger(0,namesl,OBJPROP_TIME1,timexleft);
   ObjectSetInteger(0,namesl,OBJPROP_TIME2,timexright);
   ObjectSetDouble(0,namesl,OBJPROP_PRICE1,priceysl);
   ObjectSetDouble(0,namesl,OBJPROP_PRICE2,priceyop);
   
   
   
   //More/less, Target, Stop, Open , RR
   ObjectSetInteger(0,namesltext,OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,namesltext,OBJPROP_PRICE1,priceysl);
   
   ObjectSetInteger(0,nametptext,OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,nametptext,OBJPROP_PRICE1,priceytp);
   
   ObjectSetInteger(0,nameoptext,OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,nameoptext,OBJPROP_PRICE1,priceyop);
   
   ObjectSetInteger(0,namerrtext,OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,namerrtext,OBJPROP_PRICE1,priceyop);
   
   ObjectSetInteger(0,namemtext,OBJPROP_TIME1,timexright+PeriodSeconds(Period())*2);
   if(ytp<ysl)ObjectSetDouble(0,namemtext,OBJPROP_PRICE1,priceytp);
   else ObjectSetDouble(0,namemtext,OBJPROP_PRICE1,priceysl);
   
   
   //move extentions
   ObjectSetInteger(0,nameopext,OBJPROP_TIME1,timexright);
   ObjectSetInteger(0,nameopext,OBJPROP_TIME2,timexleft);
   ObjectSetDouble(0,nameopext,OBJPROP_PRICE1,priceyop);
   ObjectSetDouble(0,nameopext,OBJPROP_PRICE2,priceyop);
   
   ObjectSetInteger(0,nametpext,OBJPROP_TIME2,timexleft);
   ObjectSetInteger(0,nametpext,OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,nametpext,OBJPROP_PRICE1,priceytp);
   ObjectSetDouble(0,nametpext,OBJPROP_PRICE2,priceytp);
   
   ObjectSetInteger(0,nameslext,OBJPROP_TIME2,timexleft);
   ObjectSetInteger(0,nameslext,OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,nameslext,OBJPROP_PRICE1,priceysl);
   ObjectSetDouble(0,nameslext,OBJPROP_PRICE2,priceysl);
   
   //SELECTABLE
   string allnames[]={"CodeLocusRRo_tpl-0","CodeLocusRRo_tpr-0","CodeLocusRRo_sll-0","CodeLocusRRo_slr-0",
                        "CodeLocusRRo_opl-0","CodeLocusRRo_opr-0","CodeLocusRRo_opm-0","CodeLocusRRo_movem-0"};
   string namemove = prefix2+"Move-0";
   
   ObjectSetInteger(0,namemove,OBJPROP_TIME1,timexmid);
   ObjectSetDouble(0,namemove,OBJPROP_PRICE1,priceysl>priceytp?priceysl:priceytp);
   
   ObjectSetInteger(0,allnames[0],OBJPROP_TIME1,timexleft);
   ObjectSetDouble(0,allnames[0],OBJPROP_PRICE1,priceytp);
   ObjectSetInteger(0,allnames[1],OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,allnames[1],OBJPROP_PRICE1,priceytp);
   ObjectSetInteger(0,allnames[2],OBJPROP_TIME1,timexleft);
   ObjectSetDouble(0,allnames[2],OBJPROP_PRICE1,priceysl);
   ObjectSetInteger(0,allnames[3],OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,allnames[3],OBJPROP_PRICE1,priceysl);
   ObjectSetInteger(0,allnames[4],OBJPROP_TIME1,timexleft);
   ObjectSetDouble(0,allnames[4],OBJPROP_PRICE1,priceyop);
   ObjectSetInteger(0,allnames[5],OBJPROP_TIME1,timexright);
   ObjectSetDouble(0,allnames[5],OBJPROP_PRICE1,priceyop);
   ObjectSetInteger(0,allnames[6],OBJPROP_TIME1,timexmid);
   ObjectSetDouble(0,allnames[6],OBJPROP_PRICE1,priceyop);
   }
   
   
void disableOtherSelectable(int exception)
   {
   string allnames[]={"CodeLocusRRo_tpl-0","CodeLocusRRo_tpr-0","CodeLocusRRo_sll-0","CodeLocusRRo_slr-0",
                        "CodeLocusRRo_opl-0","CodeLocusRRo_opr-0","CodeLocusRRo_opm-0","CodeLocusRRo_movem-0"};
   for(int i=0;i<8;i++)
      {
      //ORIGINAL CODE // DISABLE ALL EXCEPT MOVED POINT
      /*if(i==exception)continue;
      else
         {
         ObjectSetInteger(0,allnames[i],OBJPROP_SELECTED,false);
         }*/
         
      //EDITED CODE // DISABLE ALL
      ObjectSetInteger(0,allnames[i],OBJPROP_SELECTED,false);  
      }
   }
void enableAll()
   {
   string allnames[]={"CodeLocusRRo_tpl-0","CodeLocusRRo_tpr-0","CodeLocusRRo_sll-0","CodeLocusRRo_slr-0",
                        "CodeLocusRRo_opl-0","CodeLocusRRo_opr-0","CodeLocusRRo_opm-0","CodeLocusRRo_movem-0"};
   for(int i=0;i<8;i++)
      {
      ObjectSetInteger(0,allnames[i],OBJPROP_SELECTED,true);
      }
   }


bool objMoved(int xcurr,int ycurr)//Checks if any of selectable is being moved and edits OBJ accordingly
                                  //active while the left mouse click is pressed
   {
   
   string allnames[]={"CodeLocusRRo_tpl-0","CodeLocusRRo_tpr-0","CodeLocusRRo_sll-0","CodeLocusRRo_slr-0",
                        "CodeLocusRRo_opl-0","CodeLocusRRo_opr-0","CodeLocusRRo_opm-0","CodeLocusRRo_movem-0"};
   int alltimes[8];
   alltimes[0]=int(ObjectGetInteger(0,allnames[0],OBJPROP_TIME1));
   alltimes[1]=int(ObjectGetInteger(0,allnames[1],OBJPROP_TIME1));
   alltimes[2]=int(ObjectGetInteger(0,allnames[2],OBJPROP_TIME1));
   alltimes[3]=int(ObjectGetInteger(0,allnames[3],OBJPROP_TIME1));
   alltimes[4]=int(ObjectGetInteger(0,allnames[4],OBJPROP_TIME1));
   alltimes[5]=int(ObjectGetInteger(0,allnames[5],OBJPROP_TIME1));
   alltimes[6]=int(ObjectGetInteger(0,allnames[6],OBJPROP_TIME1));
   alltimes[7]=int(ObjectGetInteger(0,allnames[7],OBJPROP_TIME1));
   double allprices[8];
   allprices[0]=NormalizeDouble(ObjectGetDouble(0,allnames[0],OBJPROP_PRICE1),_Digits);
   allprices[1]=NormalizeDouble(ObjectGetDouble(0,allnames[1],OBJPROP_PRICE1),_Digits);
   allprices[2]=NormalizeDouble(ObjectGetDouble(0,allnames[2],OBJPROP_PRICE1),_Digits);
   allprices[3]=NormalizeDouble(ObjectGetDouble(0,allnames[3],OBJPROP_PRICE1),_Digits);
   allprices[4]=NormalizeDouble(ObjectGetDouble(0,allnames[4],OBJPROP_PRICE1),_Digits);
   allprices[5]=NormalizeDouble(ObjectGetDouble(0,allnames[5],OBJPROP_PRICE1),_Digits);
   allprices[6]=NormalizeDouble(ObjectGetDouble(0,allnames[6],OBJPROP_PRICE1),_Digits);
   allprices[7]=NormalizeDouble(ObjectGetDouble(0,allnames[7],OBJPROP_PRICE1),_Digits);
   
   string nametpext  = prefix2+"TPExt-0";
   string nameslext  = prefix2+"SLExt-0";
   string nameopext  = prefix2+"LineExt-0";
   string namemove   = prefix2+"Move-0";
   
   string nameoptext =prefix2+"OpenText-0";
   string nametptext =prefix2+"TPText-0";
   string namesltext =prefix2+"SLText-0";
   string namerrtext =prefix2+"RRText-0";
   string namemtext = prefix2+"MoreText-0";
   
   string nameop =prefix2+"Line-0" ;
   string nametp =prefix2+"TP-0" ;
   string namesl =prefix2+"SL-0" ;
   
   int timeleft   = int(ObjectGetInteger(0,nameslext,OBJPROP_TIME2));// why not use previously got values from RR obj?
   int timeright  = int(ObjectGetInteger(0,nameslext,OBJPROP_TIME1));
   int timemid    = int(ObjectGetInteger(0,namemove,OBJPROP_TIME1));

   double pricetp = NormalizeDouble(ObjectGetDouble(0,nametpext,OBJPROP_PRICE1),_Digits);
   double pricesl = NormalizeDouble(ObjectGetDouble(0,nameslext,OBJPROP_PRICE1),_Digits);
   double priceop = NormalizeDouble(ObjectGetDouble(0,nameopext,OBJPROP_PRICE1),_Digits);
   
   
   
   if(((alltimes[0]!=timeleft || allprices[0]!=pricetp)&&selectedpoint==-1)||selectedpoint==0)//TP LEFT --------------------------------------------
      {
      //if(!(selectedpoint==-1||selectedpoint==0))return false;
      if(selectedpoint==-1)disableOtherSelectable(0);
      selectedpoint=0;
      
      Print("TP LEFt MOVED");
      //EXTENSION COLOR EDIT
      ObjectSetInteger(0,nametpext,OBJPROP_COLOR,clrDarkGreen);
      
      datetime timey = alltimes[0];
      double   pricex= allprices[0];
               
      if(timey<timeright)
         {
         ObjectSetInteger(0,nametp,OBJPROP_TIME1,timey);
         //SL EDIT
         ObjectSetInteger(0,namesl,OBJPROP_TIME1,timey);
         //OPEN EDIT
         ObjectSetInteger(0,nameop,OBJPROP_TIME1,timey);
         //EXTENDED LINES EDIT
         ObjectSetInteger(0,nametpext,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,nameslext,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,nameopext,OBJPROP_TIME2,timey);
         
         }
     

      if(pricetp>pricesl?pricex>priceop:pricex<priceop)
         {
         //TP EXTENDED LINES EDIT
         ObjectSetDouble(0,nametpext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nametpext,OBJPROP_PRICE2,pricex);
         //TP EDIT
         ObjectSetDouble(0,nametp,OBJPROP_PRICE1,pricex);
         //TP TEXT EDIT
         ObjectSetDouble(0,nametptext,OBJPROP_PRICE1,pricex);
         //ObjectSetDouble(0,namemtext,OBJPROP_PRICE1,pricex);//more/less
         
         
         //RR OBJ TEXT EDIT
         edit_rr_obj_text(pricex,pricesl,priceop);
         
         if(lastObjectClickedYtp<lastObjectClickedYsl) // this checks if TP or SL ir on top side
                                                       //cant we use current tp sl lvl??????????????????
            {
            ObjectSetDouble(0,namemtext,OBJPROP_PRICE1,pricex);
            }
            
         //ObjectSetInteger(0,allnames[0],OBJPROP_SELECTED,true);
         }
      

      }
   else if(((alltimes[1]!=timeright || allprices[1]!=pricetp)&&selectedpoint==-1)||selectedpoint==1)//TP RIGHT --------------------------------------------
      {
      //if(selectedpoint!=-1||selectedpoint!=1)return false;
      if(selectedpoint==-1)disableOtherSelectable(1);
      selectedpoint=1;
      
      Print("TP RIGHT MOVED");
      //EXTENSION LINE COLOr EDIT
      ObjectSetInteger(0,nametpext,OBJPROP_COLOR,clrDarkGreen);
      
      datetime timey = alltimes[1];
      double   pricex= allprices[1];
      

      if(timey>timeleft)
         {
         //TP EDIT
         ObjectSetInteger(0,nametp,OBJPROP_TIME2,timey);
         //SL EDIT
         ObjectSetInteger(0,namesl,OBJPROP_TIME2,timey);
         //OPEN EDIT
         ObjectSetInteger(0,nameop,OBJPROP_TIME2,timey);
         //EXTENDED LINE EDIT
         ObjectSetInteger(0,nameslext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nametpext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nameopext,OBJPROP_TIME1,timey);
         
         //TEXT EDIT
         ObjectSetInteger(0,namemtext,OBJPROP_TIME1,timey+PeriodSeconds(Period())*2);// More/Less
         ObjectSetInteger(0,namesltext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nametptext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nameoptext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,namerrtext,OBJPROP_TIME1,timey);
         }
            
      if(pricetp>pricesl?pricex>priceop:pricex<priceop)
         {
         //TP EXTENDED LINES EDIT
         ObjectSetDouble(0,nametpext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nametpext,OBJPROP_PRICE2,pricex);
         //TP EDIT
         ObjectSetDouble(0,nametp,OBJPROP_PRICE1,pricex);
         //TP TEXT EDIT
         ObjectSetDouble(0,nametptext,OBJPROP_PRICE1,pricex);
         
         //RR OBJ TEXT EDIT
         edit_rr_obj_text(pricex,pricesl,priceop);
         
         if(lastObjectClickedYtp<lastObjectClickedYsl) // this checks if TP or SL ir on top side
                                                       //cant we use current tp sl lvl??????????????????
            {
            ObjectSetDouble(0,namemtext,OBJPROP_PRICE1,pricex);
            }
         }
      
      }
   else if(((alltimes[2]!=timeleft || allprices[2]!=pricesl)&&selectedpoint==-1)||selectedpoint==2)//SL LEFT --------------------------------------------
      {
      //if(selectedpoint!=-1||selectedpoint!=2)return false;
      if(selectedpoint==-1)disableOtherSelectable(2);
      selectedpoint=2;
      
      Print("SL LEFt MOVED");
      ObjectSetInteger(0,nameslext,OBJPROP_COLOR,clrMaroon);
      
      datetime timey = alltimes[2];
      double   pricex= allprices[2];
      
      if(timey<timeright)
         {   
         ObjectSetInteger(0,nametp,OBJPROP_TIME1,timey);
         //SL EDIT
         ObjectSetInteger(0,namesl,OBJPROP_TIME1,timey);
         //OPEN EDIT
         ObjectSetInteger(0,nameop,OBJPROP_TIME1,timey);
         //EXTENDED LINES EDIT
         ObjectSetInteger(0,nametpext,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,nameslext,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,nameopext,OBJPROP_TIME2,timey);
         }
      //MOVE POINT EDIT
      if(pricetp<pricesl?pricex>priceop:pricex<priceop)
         {
         //SL EDIT
         ObjectSetDouble(0,namesl,OBJPROP_PRICE1,pricex);
         //SL EXTENSION EDIT
         ObjectSetDouble(0,nameslext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameslext,OBJPROP_PRICE2,pricex);
         //SL TEXT EDIT
         ObjectSetDouble(0,namesltext,OBJPROP_PRICE1,pricex);
         //RR OBJ TEXT EDIT
         edit_rr_obj_text(pricetp,pricex,priceop);
         
         if(lastObjectClickedYtp>lastObjectClickedYsl)
            {
            ObjectSetDouble(0,namemtext,OBJPROP_PRICE1,pricex);
            }
         }
      
      }
   else if(((alltimes[3]!=timeright || allprices[3]!=pricesl)&&selectedpoint==-1)||selectedpoint==3)//SL RIGHT --------------------------------------------
      {
      //if(selectedpoint!=-1||selectedpoint!=3)return false;
      if(selectedpoint==-1)disableOtherSelectable(3);
      selectedpoint=3;
      
      //EXTENSION EDIT
      ObjectSetInteger(0,nameslext,OBJPROP_COLOR,clrMaroon);//Makes extended line visible
      
      Print("SL RIGHT MOVED");
      datetime timey = alltimes[3];
      double   pricex= allprices[3];
      
      //TP EDIT
      if(timey>timeleft)// rr obj time edit
         {
         ObjectSetInteger(0,nametp,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,namesl,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,nameop,OBJPROP_TIME2,timey);
         
         ObjectSetInteger(0,nameslext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nametpext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nameopext,OBJPROP_TIME1,timey);
         
         ObjectSetInteger(0,namesltext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nametptext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nameoptext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,namerrtext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,namemtext,OBJPROP_TIME1,timey+PeriodSeconds(Period())*2);// More/Less
         }
      
      
      if(pricetp<pricesl?pricex>priceop:pricex<priceop)
         {
         ObjectSetDouble(0,nameslext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameslext,OBJPROP_PRICE2,pricex);
         
         ObjectSetDouble(0,namesltext,OBJPROP_PRICE1,pricex);
         
         ObjectSetDouble(0,namesl,OBJPROP_PRICE1,pricex);
         
         edit_rr_obj_text(pricetp,pricex,priceop);
         
         if(lastObjectClickedYtp>lastObjectClickedYsl)
            {
            ObjectSetDouble(0,namemtext,OBJPROP_PRICE1,pricex);
            }
         }
      
      }
   else if(((alltimes[4]!=timeleft || allprices[4]!=priceop)&&selectedpoint==-1)||selectedpoint==4)//OPEN LEFT --------------------------------------------
      {
     // if(!(selectedpoint==-1||selectedpoint==4))return false;
      if(selectedpoint==-1)disableOtherSelectable(4);
      selectedpoint=4;
      
      Print("OPEN LEFt MOVED");
      ObjectSetInteger(0,nameopext,OBJPROP_COLOR,clrBlack);
      
      datetime timey = alltimes[4];
      double   pricex= allprices[4];
      
      //TP EDIT
      if(timey<timeright)
         ObjectSetInteger(0,nametp,OBJPROP_TIME1,timey);
      if(pricetp<pricesl?(pricex>pricetp&&pricex<pricesl):(pricex<pricetp&&pricex>pricesl))
         {
         ObjectSetDouble(0,nametp,OBJPROP_PRICE2,pricex);
      //SL EDIT
         ObjectSetDouble(0,namesl,OBJPROP_PRICE2,pricex);
         }
      if(timey<timeright)
         {
         ObjectSetInteger(0,namesl,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nameop,OBJPROP_TIME1,timey);
         
         ObjectSetInteger(0,nametpext,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,nameslext,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,nameopext,OBJPROP_TIME2,timey);
         }
      if(pricetp<pricesl?(pricex>pricetp&&pricex<pricesl):(pricex<pricetp&&pricex>pricesl))
         {
         ObjectSetDouble(0,nameop,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameop,OBJPROP_PRICE2,pricex);
         
         ObjectSetDouble(0,nameopext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameopext,OBJPROP_PRICE2,pricex);
         //TEXT EDIT
         ObjectSetDouble(0,nameoptext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,namerrtext,OBJPROP_PRICE1,pricex);
         
         edit_rr_obj_text(pricetp,pricesl,pricex);
         }
      
      }
   else if(((alltimes[5]!=timeright || allprices[5]!=priceop)&&selectedpoint==-1)||selectedpoint==5)//OPEN RIGHT --------------------------------------------
      {
      //if(selectedpoint!=-1||selectedpoint!=5)return false;
      if(selectedpoint==-1)disableOtherSelectable(5);
      selectedpoint=5;
      
      Print("OPEN RIGT MOVED");
      ObjectSetInteger(0,nameopext,OBJPROP_COLOR,clrBlack);
      
      datetime timey = alltimes[5];
      double   pricex= allprices[5];
      
      //TP EDIT
      if(timey>timeleft)
         {
         ObjectSetInteger(0,nametp,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,namesl,OBJPROP_TIME2,timey);
         ObjectSetInteger(0,nameop,OBJPROP_TIME2,timey);
         
         ObjectSetInteger(0,nameslext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nametpext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nameopext,OBJPROP_TIME1,timey);
         
         ObjectSetInteger(0,namesltext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nametptext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,nameoptext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,namerrtext,OBJPROP_TIME1,timey);
         ObjectSetInteger(0,namemtext,OBJPROP_TIME1,timey+PeriodSeconds(Period())*2);// More/Less
         }
      if(pricetp<pricesl?(pricex>pricetp&&pricex<pricesl):(pricex<pricetp&&pricex>pricesl))
         {
         ObjectSetDouble(0,nametp,OBJPROP_PRICE2,pricex);
         ObjectSetDouble(0,namesl,OBJPROP_PRICE2,pricex);
         
         ObjectSetDouble(0,nameop,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameop,OBJPROP_PRICE2,pricex);
         //EXTENSION EDIT
         ObjectSetDouble(0,nameopext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameopext,OBJPROP_PRICE2,pricex);
         
         ObjectSetDouble(0,nameoptext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameoptext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,namerrtext,OBJPROP_PRICE1,pricex);
         
         edit_rr_obj_text(pricetp,pricesl,pricex);
         }
      
      }
   else if(((alltimes[6]!=timemid || allprices[6]!=priceop)&&selectedpoint==-1)||selectedpoint==6)//OPEN MID --------------------------------------------
      {
      //EXTENSION EDIT
      ObjectSetInteger(0,nameopext,OBJPROP_COLOR,clrBlack);// Enable extension color
      
      if(selectedpoint==-1)disableOtherSelectable(6);
      selectedpoint=6;// Movable point nr inside name array
      
      Print("OPEN MID MOVED");
      datetime timey = alltimes[6];
      double   pricex= allprices[6];
      
      if(pricetp<pricesl?(pricex>pricetp&&pricex<pricesl):(pricex<pricetp&&pricex>pricesl))
         {
         ObjectSetDouble(0,nametp,OBJPROP_PRICE2,pricex);
         ObjectSetDouble(0,namesl,OBJPROP_PRICE2,pricex);
         
         //OPEN AND OP EXTENSION EDIT
         ObjectSetDouble(0,nameop,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameop,OBJPROP_PRICE2,pricex);
         
         ObjectSetDouble(0,nameopext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,nameopext,OBJPROP_PRICE2,pricex);
         
         //TEXT EDIT
         ObjectSetDouble(0,nameoptext,OBJPROP_PRICE1,pricex);
         ObjectSetDouble(0,namerrtext,OBJPROP_PRICE1,pricex);
         
         //CALCULATE AND CHANGE RR TARGET AND STOP DISTANCE(VAL)
         edit_rr_obj_text(pricetp,pricesl,pricex);
         }
      }
      
   //-------------------------------------------------------------------------------------------------------------------------------
      
   else if(((alltimes[7]!=timemid || allprices[7]!=(pricesl>pricetp?pricesl:pricetp))&&selectedpoint==-1)||selectedpoint==7)//MOVE POINT --------------------------------------------
      {
      int pixhalfwith = (lastObjectClickedXright-lastObjectClickedXleft)/2+2;
      int pixtobott = lastObjectClickedYtp<lastObjectClickedYsl?lastObjectClickedYsl-lastObjectClickedYtp:lastObjectClickedYtp-lastObjectClickedYsl;
      //bool xcorrect = (xcurr>pixhalfwith&&xcurr<ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)-pixhalfwith);
      //bool ycorrect = (ycurr>1&&ycurr<(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)-pixtobott));
      //if(!(ycorrect&&xcorrect))return false;
      
      
      //if(selectedpoint!=-1||selectedpoint!=7)return false;
      if(selectedpoint==-1)disableOtherSelectable(7);
      selectedpoint=7;
      
      
      ObjectSetInteger(0,nameopext,OBJPROP_COLOR,clrBlack);
      //if(pricetp>pricesl)ObjectSetInteger(0,nametpext,OBJPROP_COLOR,clrDarkGreen);// Maybe enable only open ext line
      //else ObjectSetInteger(0,nameslext,OBJPROP_COLOR,clrMaroon);
      
      Print("MOVE POINT MOVED");
      
      datetime timey = alltimes[7];
      double   pricex= allprices[7];
      int timexx,priceyy;
      ChartTimePriceToXY(0,0,timey,pricex,timexx,priceyy);
  
      //fix coordinates when movepoint distance is too close to borders
      if(timexx<pixhalfwith)timexx=pixhalfwith;
      else if(timexx>ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)-pixhalfwith)timexx=int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)-pixhalfwith);
      if(priceyy>ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)-pixtobott)priceyy=int(ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)-pixtobott);
      
      moveRRobj(timexx,priceyy);// Move all points 
      } 
   return true;
   }
   
void correctSelectable()
   {
   string allnames[]={"CodeLocusRRo_tpl-0","CodeLocusRRo_tpr-0","CodeLocusRRo_sll-0","CodeLocusRRo_slr-0",
                        "CodeLocusRRo_opl-0","CodeLocusRRo_opr-0","CodeLocusRRo_opm-0","CodeLocusRRo_movem-0"};
                        
   string nametpext  = prefix2+"TPExt-0";
   string nameslext  = prefix2+"SLExt-0";
   string nameopext  = prefix2+"LineExt-0";
   string namemove= prefix2+"Move-0";     
   
   int timeleft   = int(ObjectGetInteger(0,nameslext,OBJPROP_TIME2));
   int timeright  = int(ObjectGetInteger(0,nameslext,OBJPROP_TIME1));
   //int timemid    = int(ObjectGetInteger(0,namemove,OBJPROP_TIME1));

   double pricetp = NormalizeDouble(ObjectGetDouble(0,nametpext,OBJPROP_PRICE1),_Digits);
   double pricesl = NormalizeDouble(ObjectGetDouble(0,nameslext,OBJPROP_PRICE1),_Digits);
   double priceop = NormalizeDouble(ObjectGetDouble(0,nameopext,OBJPROP_PRICE1),_Digits);
   
   //CALCULATE NEW MID TIME
   int temp_x_left, temp_x_right, y_temp1;
   ChartTimePriceToXY(0,0,timeleft,pricetp,temp_x_left,y_temp1);
   ChartTimePriceToXY(0,0,timeright,pricetp,temp_x_right,y_temp1);
   datetime timemid;
   double temp_price_mid;
   int window=0;
   ChartXYToTimePrice(0,int((temp_x_left+temp_x_right)/2),y_temp1,window,timemid,temp_price_mid);
   
   
   
   
   ObjectSetInteger(0,allnames[0],OBJPROP_TIME1,timeleft);
   ObjectSetDouble(0,allnames[0],OBJPROP_PRICE1,pricetp);
   ObjectSetInteger(0,allnames[1],OBJPROP_TIME1,timeright);
   ObjectSetDouble(0,allnames[1],OBJPROP_PRICE1,pricetp);
   ObjectSetInteger(0,allnames[2],OBJPROP_TIME1,timeleft);
   ObjectSetDouble(0,allnames[2],OBJPROP_PRICE1,pricesl);
   ObjectSetInteger(0,allnames[3],OBJPROP_TIME1,timeright);
   ObjectSetDouble(0,allnames[3],OBJPROP_PRICE1,pricesl);
   ObjectSetInteger(0,allnames[4],OBJPROP_TIME1,timeleft);
   ObjectSetDouble(0,allnames[4],OBJPROP_PRICE1,priceop);
   ObjectSetInteger(0,allnames[5],OBJPROP_TIME1,timeright);
   ObjectSetDouble(0,allnames[5],OBJPROP_PRICE1,priceop);
   ObjectSetInteger(0,allnames[6],OBJPROP_TIME1,int(timemid));
   ObjectSetDouble(0,allnames[6],OBJPROP_PRICE1,priceop);
   ObjectSetInteger(0,allnames[7],OBJPROP_TIME1,int(timemid));
   ObjectSetDouble(0,allnames[7],OBJPROP_PRICE1,pricetp>pricesl?pricetp:pricesl);
   
   ObjectSetInteger(0,namemove,OBJPROP_TIME1,int(timemid));
   ObjectSetDouble(0,namemove,OBJPROP_PRICE1,pricetp>pricesl?pricetp:pricesl);
                 
   
   }
  

void edit_rr_obj_text(double pricetp, double pricesl, double priceop)
   {
   string nameoptext =prefix2+"OpenText-0";
   string nametptext =prefix2+"TPText-0";
   string namesltext =prefix2+"SLText-0";
   string namerrtext =prefix2+"RRText-0";
   
   double sldist = MathAbs(pricesl-priceop);
   double tpdist = MathAbs(priceop-pricetp);
   double koefrisk = riskpercents;
   double lotsizeunfiltered = 1;
   double lotsize = calcLots(sldist,koefrisk,lotsizeunfiltered);
   //if(lotsize<minlot)lotsize=minlot;
   double dollarstp = tpdist*lotsize*MarketInfo(_Symbol, MODE_TICKVALUE)/_Point;
   double dollarssl = sldist*lotsize*MarketInfo(_Symbol, MODE_TICKVALUE)/_Point;
   string targettexttp;
   string targettextsl;
   
   
   if(distform==showpips)targettexttp = "Target: "+DoubleToString(pricetp,_Digits)+" ("+DoubleToString(MathAbs((priceop-pricetp)/_Point/10),1)+")";
   else if(distform==showdollars)targettexttp = "Target: "+DoubleToString(pricetp,_Digits)+" ($"+DoubleToString(dollarstp,2)+")";
   else targettexttp = "Target: "+DoubleToString(pricetp,_Digits)+" ("+DoubleToString(MathAbs((priceop-pricetp)/_Point/10),1)+" | $"+DoubleToString(dollarstp,2)+")";
   
   if(distform==showpips)targettextsl = "Stop: "+DoubleToString(pricesl,_Digits)+" ("+DoubleToString(MathAbs((priceop-pricesl)/_Point/10),1)+")";
   else if(distform==showdollars)targettextsl = "Stop: "+DoubleToString(pricesl,_Digits)+" ($"+DoubleToString(dollarssl,2)+")";
   else targettextsl = "Stop: "+DoubleToString(pricesl,_Digits)+" ("+DoubleToString(MathAbs((priceop-pricesl)/_Point/10),1)+" | $"+DoubleToString(dollarssl,2)+")";
   
   
   if(sldist==0)sldist=_Point;
   if(tpdist==0)tpdist=_Point;
   string targettext = " RR = "+DoubleToString(tpdist/sldist,2);
   //string targettextrr = "RR (1 : "+DoubleToString(tpdist/sldist,2)+")";
   
   //double koefrisk = riskpercents;
   //double lotsizeunfiltered = 1;
   //double lotsize = calcLots(sldist,koefrisk,lotsizeunfiltered);
   string lotss = " Lots="+DoubleToString(lotsize,2)+" (Risk="+DoubleToString(koefrisk,2)+"%)";
   double minlot = MarketInfo(Symbol(),MODE_MINLOT);
   if(lotsize<minlot)
      {
      
      double riskrecalc = riskpercents*(minlot/lotsizeunfiltered);
      if(riskrecalc>100)riskrecalc=100.0;
      lotss=" Risk="+DoubleToString(riskrecalc,2)+" %(Lot="+DoubleToString(minlot,2)+")";
      }
   string targettextrr = lotss;

   
   ObjectSetString(0,namerrtext,OBJPROP_TEXT,targettextrr);
   
   ObjectSetString(0,nameoptext,OBJPROP_TEXT,targettext);
   ObjectSetString(0,nametptext,OBJPROP_TEXT,targettexttp);
   ObjectSetString(0,namesltext,OBJPROP_TEXT,targettextsl);
   }