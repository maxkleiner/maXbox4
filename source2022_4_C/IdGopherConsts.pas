{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10173: IdGopherConsts.pas 
{
{   Rev 1.0    2002.11.12 10:39:38 PM  czhower
}
unit IdGopherConsts;
{*******************************************************}
{                                                       }
{       Indy IdGopherConsts - this just contains        }
{         Constants used for writing Gopher servers     }
{         and clients                                   }
{                                                       }
{       Copyright (C) 2000 Winshoes Working Group       }
{       Original author: Pete Mee and moved to          }
{       this unit by J. Peter Mugaas                    }
{       2000-April-23                                   }
{                                                       }
{*******************************************************}

interface
uses IdGlobal;

Const
  {Item constants - comments taken from RFC}
  IdGopherItem_Document = '0'; // Item is a file
  IdGopherItem_Directory = '1'; // Item is a directory
  IdGopherItem_CSO = '2'; // Item is a CSO phone-book server
  IdGopherItem_Error = '3';  // Error
  IdGopherItem_BinHex = '4'; // Item is a BinHexed Macintosh file.
  IdGopherItem_BinDOS = '5'; // Item is DOS binary archive of some sort.
    // Client must read until the TCP connection closes.  Beware.
  IdGopherItem_UUE = '6'; // Item is a UNIX uuencoded file.
  IdGopherItem_Search = '7'; // Item is an Index-Search server.
  IdGopherItem_Telnet = '8'; // Item points to a text-based telnet session.
  IdGopherItem_Binary = '9'; // Item is a binary file.
    // Client must read until the TCP connection closes.  Beware.
  IdGopherItem_Redundant = '+'; // Item is a redundant server
  IdGopherItem_TN3270 = 'T'; // Item points to a text-based tn3270 session.
  IdGopherItem_GIF = 'g'; // Item is a GIF format graphics file.
  IdGopherItem_Image = ':'; // Item is some kind of image file.
    // Client decides how to display.  Was 'I', but depracted
  IdGopherItem_Image2 = 'I'; //Item is some kind of image file -
    // this was drepreciated

  {Items discovered outside of Gopher RFC - "Gopher+"}
  IdGopherItem_Sound = '<';  //Was 'S', but deprecated
  IdGopherItem_Sound2 = 'S'; //This was depreciated but should be used with clients
  IdGopherItem_Movie = ';';  //Was 'M', but deprecated
  IdGopherItem_HTML = 'h';
  IdGopherItem_MIME = 'M'; //See above for a potential conflict with Movie
  IdGopherItem_Information = 'i'; // Not a file - just information

  IdGopherPlusIndicator = IdGopherItem_Redundant; // Observant people will note
    // the conflict here...!
  IdGopherPlusInformation = '!'; // Formatted information
  IdGopherPlusDirectoryInformation = '$';

  //Gopher+ additional information
  IdGopherPlusInfo = '+INFO: ';
  { Info format is the standard Gopher directory entry + TAB + '+'.
    The info is contained on the same line as the '+INFO: '}
  IdGopherPlusAdmin = '+ADMIN:' + EOL;
  { Admin block required for every item.  The '+ADMIN:' occurs on a
    line of it's own (starting with a space) and is followed by
    the fields - one per line.

    Required fields:
    ' Admin: ' [+ comments] + '<' + admin e-mail address + '>'
    ' ModDate: ' [+ comments] + '<' + dateformat:YYYYMMDDhhnnss + '>'

    Optional fields regardless of location:
    ' Score: ' + relevance-ranking
    ' Score-range: ' + lower-bound  + ' ' + upper-bound

    Optional fields recommended at the root only:
    ' Site: ' + site-name
    ' Org: ' + organization-description
    ' Loc: ' + city + ', ' + state + ', ' + country
    ' Geog: ' + latitude + ' ' + longitude
    ' TZ: ' + GMT-offset

    Additional recorded possibilities:
    ' Provider: ' + item-provider-name
    ' Author: ' + author
    ' Creation-Date: ' + '<' + YYYYMMDDhhnnss + '>'
    ' Expiration-Date: ' + '<' + YYYYMMDDhhnnss + '>'
    }
  IdGopherPlusViews = '+VIEWS:' + EOL;
  { View formats are one per line:
    ' ' + mime/type [+ langcode] + ': <' + size estimate + '>'
    ' ' + logcode = ' ' + ISO-639-Code + '_' + ISO-3166-Code
  }
  IdGopherPlusAbstract = '+ABSTRACT:' + EOL;
  { Is followed by a (multi-)line description.  Line(s) begin with
    a space.}
  IdGopherPlusAsk = '+ASK:';

  //Questions for +ASK section:
  IdGopherPlusAskPassword = 'AskP: ';
  IdGopherPlusAskLong = 'AskL: ';
  IdGopherPlusAskFileName = 'AskF: ';

  // Prompted responses for +ASK section:
  IdGopherPlusSelect = 'Select: '; // Multi-choice, multi-selection
  IdGopherPlusChoose = 'Choose: '; // Multi-choice, single-selection
  IdGopherPlusChooseFile = 'ChooseF: '; //Multi-choice, single-selection

  //Known response types:
  IdGopherPlusData_BeginSign = '+-1' + EOL;
  IdGopherPlusData_EndSign = EOL + '.' + EOL;
  IdGopherPlusData_UnknownSize = '+-2' + EOL;
  IdGopherPlusData_ErrorBeginSign = '--1' + EOL;
  IdGopherPlusData_ErrorUnknownSize = '--2' + EOL;
  IdGopherPlusError_NotAvailable = '1';
  IdGopherPlusError_TryLater = '2';
  IdGopherPlusError_ItemMoved = '3';

implementation

end.
