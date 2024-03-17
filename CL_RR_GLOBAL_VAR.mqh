//+------------------------------------------------------------------+
//|                                             CL_RR_GLOBAL_VAR.mqh |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+


enum distanceformat
   {
   showpips,//PIPs
   showdollars,//$$$
   showboth//PIPs | $$$
   };
extern double riskpercents  = 1.0;//Max Risk % (per trade)
extern distanceformat distform = showpips;//Distance Format
extern int allowedSlippage = 3;//Allowed Slippage(Points)
extern int magic = 3333;//Magic Number

bool rrstate=false;
//bool qrstate=false;
bool limstate=false;
bool mstate=false;
int lastObjectClickedX = 0;
int lastObjectClickedY = 0;


long indiTime=GetTickCount();
int prevstate=0;
int beforeprevstate=0;
string prefix= "CodeLocusRRb_";
string prefix2= "CodeLocusRRo_";
bool rr_open_level = false;
uint lastObjectClickedTime = 0;
uint beforelastObjectClickedTime = 0;
string lastObjectClickedName = "";
int selectedpoint=-1;//FOR SELECtION

int lastObjectClickedYtp = 0;
int lastObjectClickedYsl = 0;
int lastObjectClickedYopen = 0;
int lastObjectClickedXleft = 0;
int lastObjectClickedXright = 0;
//int lastmousesparam=0;
int lastx=0;
int lasty=0;
int beforelastx=0;
int beforelasty=0;
int lastxmove=0;
int lastymove=0;
int leftx=0;
int rightx=0;
int uppery=0;
int lowery=0;
bool doubleClickedObject=false;
uint refresh1s=0;
bool rrexists=false;
bool rr_stop_level = false;
bool rr_tp_level = false;
int ppi = TerminalInfoInteger(TERMINAL_SCREEN_DPI);
double dpikoef = ppi/96.0;
int barsInWindow=WindowBarsPerChart();
int chartWidth = int(ChartGetInteger(0,CHART_WIDTH_IN_PIXELS));
int pmpix = 10;
int rrnr=0;
bool laststateobj;
double tppriceg = 0;
double slpriceg = 0;
double openpriceg = 0;     

bool creating_new_rr_obj = false;                                              