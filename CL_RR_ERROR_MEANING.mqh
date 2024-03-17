//+------------------------------------------------------------------+
//|                                         CL_RR_ERROR_MEANING.mqh  |
//|                           Copyright 2021, Eriks Karlis Sedvalds. |
//|                         https://www.mql5.com/en/users/magiccoder |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Eriks Karlis Sedvalds."
#property link      "https://www.mql5.com/en/users/magiccoder"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+


 string errorMeaning(int errorNR)
   {
   string error;
   switch(errorNR)
      {
      //--- codes returned from trade server
      case 0:   error="no error";                                                   break;
      case 1:   error="no error, trade conditions not changed";                     break;
      case 2:   error="common error";                                               break;
      case 3:   error="invalid trade parameters";                                   break;
      case 4:   error="trade server is busy";                                       break;
      case 5:   error="old version of the client terminal";                         break;
      case 6:   error="no connection with trade server";                            break;
      case 7:   error="not enough rights";                                          break;
      case 8:   error="too frequent requests";                                      break;
      case 9:   error="malfunctional trade operation (never returned error)";       break;
      case 64:  error="account disabled";                                           break;
      case 65:  error="invalid account";                                            break;
      case 128: error="trade timeout";                                              break;
      case 129: error="invalid price";                                              break;
      case 130: error="invalid stops";                                              break;
      case 131: error="invalid trade volume";                                       break;
      case 132: error="market is closed";                                           break;
      case 133: error="trade is disabled";                                          break;
      case 134: error="not enough money";                                           break;
      case 135: error="price changed";                                              break;
      case 136: error="off quotes";                                                 break;
      case 137: error="broker is busy (never returned error)";                      break;
      case 138: error="requote";                                                    break;
      case 139: error="order is locked";                                            break;
      case 140: error="long positions only allowed";                                break;
      case 141: error="too many requests";                                          break;
      case 145: error="modification denied because order is too close to market";   break;
      case 146: error="trade context is busy";                                      break;
      case 147: error="expirations are denied by broker";                           break;
      case 148: error="amount of open and pending orders has reached the limit";    break;
      case 149: error="hedging is prohibited";                                      break;
      case 150: error="prohibited by FIFO rules";                                   break;

      //--- mql4 errors
      case 4000: error="no error (never generated code)";                           break;
      case 4001: error="wrong function pointer";                                    break;
      case 4002: error="array index is out of range";                               break;
      case 4003: error="no memory for function call stack";                         break;
      case 4004: error="recursive stack overflow";                                  break;
      case 4005: error="not enough stack for parameter";                            break;
      case 4006: error="no memory for parameter string";                            break;
      case 4007: error="no memory for temp string";                                 break;
      case 4008: error="non-initialized string";                                    break;
      case 4009: error="non-initialized string in array";                           break;
      case 4010: error="no memory for array\' string";                              break;
      case 4011: error="too long string";                                           break;
      case 4012: error="remainder from zero divide";                                break;
      case 4013: error="zero divide";                                               break;
      case 4014: error="unknown command";                                           break;
      case 4015: error="wrong jump (never generated error)";                        break;
      case 4016: error="non-initialized array";                                     break;
      case 4017: error="dll calls are not allowed";                                 break;
      case 4018: error="cannot load library";                                       break;
      case 4019: error="cannot call function";                                      break;
      case 4020: error="expert function calls are not allowed";                     break;
      case 4021: error="not enough memory for temp string returned from function";  break;
      case 4022: error="system is busy (never generated error)";                    break;
      case 4023: error="dll-function call critical error";                          break;
      case 4024: error="internal error";                                            break;
      case 4025: error="out of memory";                                             break;
      case 4026: error="invalid pointer";                                           break;
      case 4027: error="too many formatters in the format function";                break;
      case 4028: error="parameters count is more than formatters count";            break;
      case 4029: error="invalid array";                                             break;
      case 4030: error="no reply from chart";                                       break;
      case 4050: error="invalid function parameters count";                         break;
      case 4051: error="invalid function parameter value";                          break;
      case 4052: error="string function internal error";                            break;
      case 4053: error="some array error";                                          break;
      case 4054: error="incorrect series array usage";                              break;
      case 4055: error="custom indicator error";                                    break;
      case 4056: error="arrays are incompatible";                                   break;
      case 4057: error="global variables processing error";                         break;
      case 4058: error="global variable not found";                                 break;
      case 4059: error="function is not allowed in testing mode";                   break;
      case 4060: error="function is not confirmed";                                 break;
      case 4061: error="send mail error";                                           break;
      case 4062: error="string parameter expected";                                 break;
      case 4063: error="integer parameter expected";                                break;
      case 4064: error="double parameter expected";                                 break;
      case 4065: error="array as parameter expected";                               break;
      case 4066: error="requested history data is in update state";                 break;
      case 4067: error="internal trade error";                                      break;
      case 4068: error="resource not found";                                        break;
      case 4069: error="resource not supported";                                    break;
      case 4070: error="duplicate resource";                                        break;
      case 4071: error="cannot initialize custom indicator";                        break;
      case 4072: error="cannot load custom indicator";                              break;
      case 4073: error="no history data";                                           break;
      case 4074: error="not enough memory for history data";                        break;
      case 4075: error="not enough memory for indicator";                           break;
      case 4099: error="end of file";                                               break;
      case 4100: error="some file error";                                           break;
      case 4101: error="wrong file name";                                           break;
      case 4102: error="too many opened files";                                     break;
      case 4103: error="cannot open file";                                          break;
      case 4104: error="incompatible access to a file";                             break;
      case 4105: error="no order selected";                                         break;
      case 4106: error="unknown symbol";                                            break;
      case 4107: error="invalid price parameter for trade function";                break;
      case 4108: error="invalid ticket";                                            break;
      case 4109: error="trade is not allowed in the expert properties";             break;
      case 4110: error="longs are not allowed in the expert properties";            break;
      case 4111: error="shorts are not allowed in the expert properties";           break;
      case 4200: error="object already exists";                                     break;
      case 4201: error="unknown object property";                                   break;
      case 4202: error="object does not exist";                                     break;
      case 4203: error="unknown object type";                                       break;
      case 4204: error="no object name";                                            break;
      case 4205: error="object coordinates error";                                  break;
      case 4206: error="no specified subwindow";                                    break;
      case 4207: error="graphical object error";                                    break;
      case 4210: error="unknown chart property";                                    break;
      case 4211: error="chart not found";                                           break;
      case 4212: error="chart subwindow not found";                                 break;
      case 4213: error="chart indicator not found";                                 break;
      case 4220: error="symbol select error";                                       break;
      case 4250: error="notification error";                                        break;
      case 4251: error="notification parameter error";                              break;
      case 4252: error="notifications disabled";                                    break;
      case 4253: error="notification send too frequent";                            break;
      case 4260: error="ftp server is not specified";                               break;
      case 4261: error="ftp login is not specified";                                break;
      case 4262: error="ftp connect failed";                                        break;
      case 4263: error="ftp connect closed";                                        break;
      case 4264: error="ftp change path error";                                     break;
      case 4265: error="ftp file error";                                            break;
      case 4266: error="ftp error";                                                 break;
      case 5001: error="too many opened files";                                     break;
      case 5002: error="wrong file name";                                           break;
      case 5003: error="too long file name";                                        break;
      case 5004: error="cannot open file";                                          break;
      case 5005: error="text file buffer allocation error";                         break;
      case 5006: error="cannot delete file";                                        break;
      case 5007: error="invalid file handle (file closed or was not opened)";       break;
      case 5008: error="wrong file handle (handle index is out of handle table)";   break;
      case 5009: error="file must be opened with FILE_WRITE flag";                  break;
      case 5010: error="file must be opened with FILE_READ flag";                   break;
      case 5011: error="file must be opened with FILE_BIN flag";                    break;
      case 5012: error="file must be opened with FILE_TXT flag";                    break;
      case 5013: error="file must be opened with FILE_TXT or FILE_CSV flag";        break;
      case 5014: error="file must be opened with FILE_CSV flag";                    break;
      case 5015: error="file read error";                                           break;
      case 5016: error="file write error";                                          break;
      case 5017: error="string size must be specified for binary file";             break;
      case 5018: error="incompatible file (for string arrays-TXT, for others-BIN)"; break;
      case 5019: error="file is directory, not file";                               break;
      case 5020: error="file does not exist";                                       break;
      case 5021: error="file cannot be rewritten";                                  break;
      case 5022: error="wrong directory name";                                      break;
      case 5023: error="directory does not exist";                                  break;
      case 5024: error="specified file is not directory";                           break;
      case 5025: error="cannot delete directory";                                   break;
      case 5026: error="cannot clean directory";                                    break;
      case 5027: error="array resize error";                                        break;
      case 5028: error="string resize error";                                       break;
      case 5029: error="structure contains strings or dynamic arrays";              break;
      default:   error="unknown error"; 
      }
   return error;
   }