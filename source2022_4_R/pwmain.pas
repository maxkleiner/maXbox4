{*******************************************************************************

                                POWTILS

********************************************************************************

--------------------------------------------------------------------------------
 Main Web Unit
--------------------------------------------------------------------------------
  Main functions for web programs. Developers: SVN logs are important. Notes are
  not added to the top of this source file any more. Log your changes when you
  upload to SVN. Comment the source code, regardless.
--------------------------------------------------------------------------------
  Authors/Credits:
--------------------------------------------------------------------------------
  Trustmaster (Vladimir Sibirov), L505 (Lars Olson), TonyH (Anthony Henry)
  This file is copyright to above authors. Legal: see the Artistic License.
********************************************************************************}


unit pwmain; {$IFDEF FPC}{$GOTO ON} {$NOTES ON} {$NOTE USING STATIC WEB UNIT}{$ENDIF}

{ Defines:
  DBUG_ON      // detailed custom debugging if you assign debugln:= @yourproc;
  GZIP_ON      // html compression output saves bandwidth, output_compression and output_buffering must also be enabled in config settings for gzip to have any effect. Gzip is harder to debug at the command line though as you will see a bunch of crap ;) It also takes more CPU power.. but saves the bandwidth bill, so it is up to you.
  PWUDEBUG     // text log file debugging, only use on localhost single visitor testing since it multiple visitors cannot write simutaneously to the same log file
  EXTRA_SECURE // check overflows, range errors (recommended)
  SYSUTILS_ON  // compactsysutils is used sometimes depending on above devines. If you have problems then resort back to using Sysutils
}
// Above defines customize behavior, some save exe size if OFF. Read comments!

// Delete all .a/.o/.ppu files in *all* directories with DELP tool, otherwise
// defines will not have effect in many cases.

// Using $DEFINE in this unit is not global for all units, so instead use delphi
// project options or fpc -d option for global define across units.

//{$I defines1.inc}

{$IFNDEF FPC}{$DEFINE SYSUTILS_ON}{$ENDIF}

{$IFDEF PWUDEBUG}{$DEFINE DBUG_ON}{$ENDIF} // debugln forced if pwudebug on

{$J+} // persistent local scope vars

interface

uses
  pwerrors,
  pwtypes;

// for setcookie default behavior.
const FUTURE_COOKIE  = 'Mon, 01 Dec 2099 12:00:00 GMT'; //must be many years ahead
      EXPIRED_COOKIE = 'Mon, 01 Jan 2001 12:00:00 GMT'; //must be many years behind


//type TSecurity = (sUnsafe, sTrim);
// for GetCgiVar_S function security parameter
const SECURE_OFF = 0;
      SECURE_ON = 2;
      SECURE_FILTER = 3;

const
  CASE_SENSITIVE = false;
  CASE_IGNORE = true;

  // Powtils version
  {$i version.inc}

type 
  TFilterFunc = function(const s: astr): astr;

{--- Public Functions --------------------------------------------------------}

procedure Init;

procedure OffReadln;

function Lcase(const s: astr): astr;
function Ucase(const s: astr): astr;

{ Posted Variable Functions } 
// note: function names changed to 'post' in 1.7.X rather than old CGI
function CountPostVars: longword;
function GetPostVar(const name: astr): astr; overload;
function GetPostVar(const name: astr; filter: TFilterFunc): astr; overload;
function GetPostVar_S(const name: astr; Security: integer): astr;
function GetPostVar_SF(const name: astr; Security: integer): astr;
function GetPostVarAsFloat(const name: astr): double;
function GetPostVarAsInt(const name: astr): longint;
function GetPostVar_SafeHTML(const name: astr): astr;
function FetchPostVarName(idx: longword): astr;
function FetchPostVarVal(idx: longword): astr; overload;
function FetchPostVarVal(idx: longword; filter: TFilterFunc): astr; overload;
function FetchPostVarName_S(idx: longword; Security: integer): astr;
function FetchPostVarVal_S(idx: longword; Security: integer): astr;
function IsPostVar(const name: astr): bln;

{ TODO get cgi var based on a valid set of characters such as A..Z, 1..9, a..z
  type TCharSet = set of char;
      function GetCgiVar(const input: astr; CharSet: TCharSet): bln;
  Use the pwstrfilter unit, with Alpha, numeric, alphanumeric sets     }


{ Abstract for Posts (cgi vars), Vars (macros), and Cookies }
function CountAny: longword;
function GetAny(const name: astr): astr; overload;
function GetAny(const name: astr; filter: TFilterFunc): astr; overload;
function GetAny_S(const name: astr; Security: integer): astr;
function GetAnyAsFloat(const name: astr): double;
function GetAnyAsInt(const name: astr): longint;
function IsAny(const name: astr): byte;

{ Cookie Functions }
function CountCookies: longword;
function FetchCookieName(idx: longword): astr;
function FetchCookieVal(idx: longword): astr; overload;
function FetchCookieVal(idx: longword; filter: TFilterFunc): astr; overload;
function GetCookie(const name: astr): astr; overload;
function GetCookie(const name: astr; filter: TFilterFunc): astr; overload;
function GetCookieAsFloat(const name: astr): double;
function GetCookieAsInt(const name: astr): longint;
function IsCookie(const name: astr): bln;
function SetCookie(const name, value: astr): bln;
function SetCookieAsFloat(const name: astr; value: double): bln;
function SetCookieAsInt(const name: astr; value: longint): bln;
function SetCookieEx(const name, value, path, domain, expiry: astr): bln;
function SetCookieAsFloatEx(const name: astr; value: double; const path, domain, expiry: astr): bln;
function SetCookieAsIntEx(const name: astr; value: longint; const path, domain, expiry: astr): bln;
function UnsetCookie(const name: astr): bln;
function UnsetCookieEx(const name, path, domain: astr): bln;

{ Environment Variable Functions } 
// now moved to pwenvvar.pas


{ Filtering Functions }
function FilterHtml(const input: astr): astr;
function FilterHtml_S(const input: astr; security: integer): astr;
function TrimBadChars(const input: astr): astr;
function TrimBadFile(const input: astr): astr;
function TrimBadDir(const input: astr): astr;
function TrimBad_S(const input: astr; security: integer): astr;

{ TODO
    function IsBadFile(const input: astr): bln;
    function IsBadDir(const input: astr): bln; }

{ Header Functions }
function CountHeaders: longword;
function FetchHeaderName(idx: longword): astr;
function FetchHeaderVal(idx: longword): astr;
function GetHeader(const name: astr): astr;
function IsHeader(const name: astr): bln;
function SetHeader(const name, value: astr): bln;
function UnsetHeader(const name: astr): bln;
function PutHeader(const header: astr): bln;

{ Output/Write Functions }
procedure Out(const s: astr);
procedure OutLn(const s: astr);
procedure OutA(args: array of const);
procedure OutF(const s: astr);
procedure OutLnF(const s: astr);
procedure OutFF(const s: astr);
procedure OutF_FI(const s: astr; HTMLFilter: bln);
procedure OutLnFF(const s: astr);
procedure OutLnF_FI(const s: astr; HTMLFilter: bln );


function FileOut(const fname: astr): errcode;
function ResourceOut(const fname: astr): errcode;
procedure BufferOut(Const buff; len: LongWord);

function TemplateOut(const fname: astr; HtmlFilter: bln): errcode; overload;
function TemplateOut(const fname: astr): errcode; overload;
function TemplateOut(const fname: astr; filter: TFilterFunc): errcode; overload;
function TemplateOut1(const fname: astr; HtmlFilter: bln): errcode; overload;
function TemplateRaw(const fname: astr): errcode;

{ fmt stands for format, to not conflict with sysutils Format() function }
function Fmt(const s: astr): astr; overload;
function Fmt(const s: astr; filter: TFilterFunc): astr; overload;
function FmtFilter(const s: astr): astr;

function Fmt_SF(const s: astr; HTMLFilter: bln; filter: TFilterFunc;
                FilterSecurity, TrimSecurity: integer): astr; overload;
function Fmt_SF(const s: astr; HTMLFilter: bln; 
                FilterSecurity, TrimSecurity: integer): astr; overload;


{ RTI Functions }
function CountRtiVars: longword;
function FetchRtiName(idx: longword): astr;
function FetchRtiVal(idx: longword): astr;
function GetRti(const name: astr): astr;
function GetRtiAsFloat(const name: astr): double;
function GetRtiAsInt(const name: astr): longint;
function IsRti(const name: astr): bln;
procedure SetRTI(const name, value: astr); 

{ Upload File Functions }
function FetchUpfileName(idx: longword): astr;
function GetUpfileName(const name: astr): astr;
function GetUpfileSize(const name: astr): longint;
function GetUpfileType(const name: astr): astr;
function CountUpfiles: longword;
function IsUpfile(const name: astr): bln;
function SaveUpfile(const name, fname: astr): bln;

{ Web Variable Functions }
function CountVars: longword;
function FetchVarName(idx: longword): astr;
function FetchVarVal(idx: longword): astr; overload;
function FetchVarVal(idx: longword; filter: TFilterFunc): astr; overload;
function GetVar(const name: astr): astr; overload;
function GetVar(const name: astr; filter: TFilterFunc): astr; overload;
function GetVar_S(const name: astr; security: integer): astr;
function GetVarAsFloat(const name: astr): double;
function GetVarAsInt(const name: astr): longint;
procedure SetVar(const name, value: astr);
procedure SetVarAsFloat(const name: astr; value: double);
procedure SetVarAsInt(const name: astr; value: longint);
function IsVar(const name: astr): byte;
procedure UnsetVar(const name: astr);

{ Utility/Tools Functions }
function LineEndToBR(const s: astr): astr;
function RandomStr(len: longint): astr;
function XorCrypt(const s: astr; key: byte): astr;

{ Config Functions }
function CountCfgVars: longword;
function FetchCfgVarName(idx: longword): astr;
function FetchCfgVarVal(idx: longword): astr;
function IsCfgVar(const name: astr): bln;
function SetCfgVar(const name, value: astr): bln;
function GetCfgVar(const name: astr): astr;

{ Error Functions }
procedure ThrowErr(const s: astr);
procedure ThrowWarn(const s: astr);  
procedure ErrWithHeader(const s: astr);

const // obsolete backwards compatibility
  CountCgiVars: function: longword = {$ifdef FPC}@{$endif}countpostvars;
  GetCgiVar: function(const name: astr): astr = {$ifdef FPC}@{$endif}getpostvar;
  GetCgiVar_S: function(const name: astr; Security: integer): astr = {$ifdef FPC}@{$endif}getpostvar_s;
  GetCgiVar_SF: function(const name: astr; Security: integer): astr= {$ifdef FPC}@{$endif}getpostvar_sf;
  IsCgiVar: function(const name: astr): bln= {$ifdef FPC}@{$endif}ispostvar;
  GetCgiVarAsFloat: function(const name: astr): double= {$ifdef FPC}@{$endif}getpostvarasfloat;
  GetCgiVarAsInt: function(const name: astr): longint= {$ifdef FPC}@{$endif}getpostvarasint;
  GetCgiVar_SafeHTML: function(const name: astr): astr= {$ifdef FPC}@{$endif}getpostvar_safehtml;
  FetchCgiVarName: function(idx: longword): astr= {$ifdef FPC}@{$endif}fetchpostvarname;
  FetchCgiVarVal: function(idx: longword): astr= {$ifdef FPC}@{$endif}fetchpostvarval;
  FetchCgiVarName_S: function(idx: longword; Security: integer): astr= {$ifdef FPC}@{$endif}fetchpostvarname_s;
  FetchCgiVarVal_S: function(idx: longword; Security: integer): astr= {$ifdef FPC}@{$endif}fetchpostvarval_s;
  
  ThrowWebError: procedure(const s: astr)                                       = {$IFDEF FPC}@{$ENDIF}ThrowErr;
  WebFileOut: function(const fname: astr): errcode                              = {$IFDEF FPC}@{$ENDIF}fileout;
  WebResourceOut: function(const fname: astr): errcode                          = {$IFDEF FPC}@{$ENDIF}resourceout;
  WebBufferOut: procedure(Const Buff; BuffLength : LongWord)                    = {$IFDEF FPC}@{$ENDIF}bufferout;
  WebTemplateOut: function(const fname: astr;
                           HTMLFilter: bln): errcode                      = {$IFDEF FPC}@{$ENDIF}templateout;
  WebTemplateRaw: function(const fname: astr): errcode                          = {$IFDEF FPC}@{$ENDIF}templateraw;
  WebFormat: function(const s: astr): astr                                      = {$IFDEF FPC}@{$ENDIF}fmt;
  WebFormatAndFilter: function(const s: astr): astr                             = {$IFDEF FPC}@{$ENDIF}fmtfilter;
  WebFormat_SF: function(const s: astr;
                         HtmlFilter: bln;
                         Security,
                         TrimSecurity: integer): astr                           = {$IFDEF FPC}@{$ENDIF}fmt_SF;
  CountWebVars: function: longword                                              = {$IFDEF FPC}@{$ENDIF}CountVars;
  FetchWebVarName: function(idx: longword): astr                                = {$IFDEF FPC}@{$ENDIF}FetchVarName;
  FetchWebVarValue: function(idx: longword): astr                               = {$IFDEF FPC}@{$ENDIF}FetchVarVal;
  GetWebVar: function(const name: astr): astr                                   = {$IFDEF FPC}@{$ENDIF}GetAny;
  GetWebVar_S: function(const name: astr; Security: integer): astr              = {$IFDEF FPC}@{$ENDIF}GetAny_S;
  GetWebVarAsFloat: function(const name: astr): double                          = {$IFDEF FPC}@{$ENDIF}GetAnyAsFloat;
  GetWebVarAsInt: function(const name: astr): longint                           = {$IFDEF FPC}@{$ENDIF}GetAnyAsInt;
  SetWebVar: procedure(const name, value: astr)                                 = {$IFDEF FPC}@{$ENDIF}SetVar;
  SetWebVarAsFloat: procedure(const name: astr; value: double)                  = {$IFDEF FPC}@{$ENDIF}SetVarAsFloat;
  SetWebVarAsInt: procedure(const name: astr; value: longint)                   = {$IFDEF FPC}@{$ENDIF}SetVarAsInt;
  IsWebVar: function(const name: astr): byte                                    = {$IFDEF FPC}@{$ENDIF}IsAny;
  UnsetWebVar: procedure (const name: astr)                                     = {$IFDEF FPC}@{$ENDIF}UnsetVar;
  Webwrite: procedure(const s: astr)                                            = {$IFDEF FPC}@{$ENDIF}out;
  WebwriteA: procedure(args: array of const)                                    = {$IFDEF FPC}@{$ENDIF}outa;
  WebwriteF: procedure(const s: astr)                                           = {$IFDEF FPC}@{$ENDIF}outf;
  WebwriteFF: procedure(const s: astr)                                          = {$IFDEF FPC}@{$ENDIF}outff;
  WebwriteF_Fi: procedure(const s: astr; HTMLFilter: bln)                 = {$IFDEF FPC}@{$ENDIF}outf_fi;
  WebwriteLn: procedure(const s: astr)                                          = {$IFDEF FPC}@{$ENDIF}outln;
  WebwriteLnF: procedure(const s: astr)                                         = {$IFDEF FPC}@{$ENDIF}outlnf;
  WebwriteLnFF: procedure(const s: astr)                                        = {$IFDEF FPC}@{$ENDIF}outlnff;
  WebwriteLnF_Fi: procedure(const s: astr; HTMLFilter: bln )              = {$IFDEF FPC}@{$ENDIF}outlnf_fi;
  CountWebHeaders: function: longword                                           = {$IFDEF FPC}@{$ENDIF}CountHeaders;
  FetchWebHeaderName: function(idx: longword): astr                             = {$IFDEF FPC}@{$ENDIF}FetchHeaderName;
  FetchWebHeaderVal: function(idx: longword): astr                              = {$IFDEF FPC}@{$ENDIF}FetchHeaderVal;
  GetWebHeader: function(const name: astr): astr                                = {$IFDEF FPC}@{$ENDIF}GetHeader;
  IsWebHeader: function(const name: astr): bln                                  = {$IFDEF FPC}@{$ENDIF}IsHeader;
  SetWebHeader: function(const name, value: astr): bln                          = {$IFDEF FPC}@{$ENDIF}SetHeader;
  UnsetWebHeader: function(const name: astr): bln                               = {$IFDEF FPC}@{$ENDIF}UnsetHeader;
  PutWebHeader: function(const header: astr): bln                               = {$IFDEF FPC}@{$ENDIF}PutHeader;
  TrimBadChars_file:  function (const input: astr): astr                        = {$IFDEF FPC}@{$ENDIF}TrimBadFile;
  TrimBadChars_dir:  function (const input: astr): astr                         = {$IFDEF FPC}@{$ENDIF}TrimBadDir;

  CountWebConfigVars: function: longword                                        = {$IFDEF FPC}@{$ENDIF}CountCfgVars;
  FetchWebConfigVarName: function(idx: longword): astr                          = {$IFDEF FPC}@{$ENDIF}FetchCfgVarName;
  FetchWebConfigVarValue: function(idx: longword): astr                         = {$IFDEF FPC}@{$ENDIF}FetchCfgVarVal;
  IsWebConfigVar: function(const name: astr): bln                               = {$IFDEF FPC}@{$ENDIF}IsCfgVar;
  SetWebConfigVar: function(const name, value: astr): bln                       = {$IFDEF FPC}@{$ENDIF}SetCfgVar;
  GetWebConfigVar: function(const name: astr): astr                             = {$IFDEF FPC}@{$ENDIF}GetCfgVar;


{$IFDEF DBUG_ON}
  procedure dummydebug(s: astr);
  var debugln: procedure(s: astr) = {$IFDEF FPC}@{$ENDIF}dummydebug;
  // DEVELOPERS: ASSIGN DEBUGLN() PROC IN YOUR CGI PROGRAM FOR CUSTOM LOGGING
{$ENDIF}

// flags
var headers_sent: bln = false;

// END OF PUBLIC FUNCTION DECLARATIONS
{-----------------------------------------------------------------------------}

{-----------------------------------------------------------------------------}
{ FOR PLUGIN UNITS - TYPICAL USERS CAN IGNORE THIS PUBLIC INTERFACE           }
{-----------------------------------------------------------------------------}
// more advanced developers use this part of the interface to extend Powtils
// such as custom session units (mysql, firebird addons instead of SDS) and
// any functions in this section are not for a typical Powtils coder

type
  // variable structure
  TWebVar = record
    name, value: astr;
  end;
  TWebVars = array of TWebVar;

  TSessUpdate = function: bln;

var
  // set this when using session plugin unit
  CustomSessUnitInit: procedure = nil;
  CustomSessUpdate: TSessUpdate = nil;
  // set this when using config plugin unit
  CustomCfgUnitInit: procedure = nil;

{ functions prefixed with "i" are internal but publically available for addons}
function iUpdateWebVar(var webv: TWebVars; const name, value: astr; upcased: bln): bln;
function iAddWebCfgVar(const name, value: astr): bln;
procedure iAddWebVar(var webv: TWebVars; const name, value: astr);
procedure iSetRTI(const name, value: astr);
function iCustomSessUnitSet: bln;
function iCustomCfgUnitSet: bln;

// END OF INTERNAL DECLARATIONS
{-----------------------------------------------------------------------------}

{=============================================================================}
 implementation
{=============================================================================}

uses
  {$IFDEF WINDOWS}windows,{$ENDIF}
  {$IFDEF UNIX}baseunix,{$ENDIF}
  {$IFDEF SYSUTILS_ON}sysutils{$ELSE}compactsysutils{$ENDIF},
  //pwstrutil,
  {$IFDEF GZIP_ON}pwobjbuff,{$ENDIF} // output buffer w/built in gzip
  pwnative_out, // simple writeln
  pwenvvar, pwfileutil, pwsubstr, pwurlenc, pwmimetypes, strwrap1;

{$IFDEF PWUDEBUG}var debugt: text; // Debug output file (for localhost single visitor testing only!)
{$ENDIF}

var
  // flags
  plugin_init_called: bln = false;

type
  // file structure
  TWebUpFile = record
    name, filename, data, content_type: astr;
    size: longint;
  end;

  // uploaded files
  TWebUpFiles = array of TWebUpFile;

  // Line type for Multipart/Form-Data handling functions
  TMp_Line = array[1..6] of astr;

  // Multipart/Form-Data storage
  TMp_Form = array of astr;
  PMp_Form = ^TMp_Form;

  // type safety to prevent from being sent into the wrong AddXyz() functions
  TWebCfgVar = type TWebVar;
  // multiple config name=value pairs
  TWebCfgVars = array of TWebCfgVar;

var
  cgi,  // CGI GET/POST data
  cook, // cookie data
  hdr,  // headers
  rti,  // run time information
  vars  // all web data
  : TWebVars;

  conf: TWebCfgVars;    // configuration data

  upfiles: TWebUpFiles; // file uploads storage

  // config flags
  error_reporting, error_halt: bln;
 {$IFDEF GZIP_ON}
  output_buffering, output_compression : bln; // Output flags
 {$ENDIF}

  // init flags
  cook_initialized: bln = false;

 {$IFDEF GZIP_ON}
  outbuff: PSmartBuffer = nil;
 {$ENDIF}

{------------------------------------------------------------------------------}
{--- SYSAPI FUNCTIONS ---------------------------------------------------------}
{------------------------------------------------------------------------------}
(* // obsolete, no need when using baseunix.pp
{$IFDEF UNIX}
var
  environ: ppchar; cvar; external;

function getenv(const name: PChar): PChar; cdecl; external 'c' name 'getenv';
function setenv(const name, value: pchar; replace: longint): longint; cdecl; external 'c' name 'setenv';
function unsetenv(const name: pchar): longint; cdecl; external 'c' name 'unsetenv';
{$ENDIF}  *)
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{--- PRIVATE FUNCTIONS/PROCEDURES ---------------------------------------------}
{------------------------------------------------------------------------------}

// delphi issues
{$I delphisystemcompat.inc}


{$IFDEF DBUG_ON}
  // USER MUST ASSIGN HIS OWN DEBUG PROC UNLESS PWUDEBUG DEFINED
  procedure dummydebug(s: astr);
  begin
  end;

 {$IFDEF PWUDEBUG} // error logging option
 { ERROR LOGGING   NOTE: WITH DYNPWU USE DEBUG DLL IF AVAIL }
  procedure logdebugln(s: astr);
  begin
    writeln(debugt, s);
    flush(debugt);
  end;
  {$ENDIF PWUDEBUG}
{$ENDIF DBUG_ON}

{ allows a READLN to be called in offling console, but not on the web. Useful
  for debugging at the console and keeping the window open }
procedure OffReadln;
begin
  if SERV.DocRoot() = '' then readln;
end;

procedure ThrowNoFileErr(const fname: astr);
begin
  ThrowErr('reading file: ' + fname);
end;           

{ init default http headers on successful startup }
procedure InitHeaders;
{$I begin_initheaders.inc}
  SetLength(hdr, 2);
  hdr[0].name:= 'X-Powered-By';
  hdr[0].value:= 'Powtils/' + 'PWU_VERSION';
  hdr[1].name:= 'Content-Type';
  hdr[1].value:= 'text/html; charset=' + GetCfgVar(L_HEADER_CHARSET);

 {$IFDEF GZIP_ON}
  if (output_buffering) and (output_compression)
    and substrexists(GetEnvVar('HTTP_ACCEPT_ENCODING'), 'gzip') then begin
      SetLength(hdr, 3);
      hdr[2].name:= 'Content-Encoding';
      hdr[2].value:= 'gzip';
    end
  else
    output_compression:= false;
 {$ENDIF}
{$I end_initheaders.inc}

procedure InitBufAndHeaders;
begin
 {$IFDEF GZIP_ON}
  if (output_buffering) and (output_compression) then
    if OutBuff = nil then
      OutBuff := new(PSmartBuffer, DynamicBuffer(8192));
 {$ENDIF}
  InitHeaders;
end;


{ append single new value to WebVariables array i.e. hdr[], sess[],  cook[] }
procedure AddWebVar(var webv: TWebVars; const name, value: astr);
var oldlen: integer;
begin
  oldlen:= length(webv);
  setlength(webv, oldlen + 1);
  webv[oldlen].name:= name;
  webv[oldlen].value:= value;
end;

function IsGzipFlag(s: astr): bln;
begin
  result:= false;
  if (Lcase(s) = L_OUTPUT_COMPRESSION) or (Lcase(s) = L_OUTPUT_BUFFERING) then
    result:= true;
end;

function CfgVarToBool(const s: astr): bln;
begin
 if GetCfgVar(s) = 'on' then result:= true else result:= false;
end;

{ merge program flags to config settings }
procedure MergeFlagsToCfg;
begin
 {$IFDEF GZIP_ON}
  output_buffering:= CfgVarToBool(L_OUTPUT_BUFFERING);
  output_compression:= CfgVarToBool(L_OUTPUT_COMPRESSION);
 {$ENDIF}
  error_reporting:= CfgVarToBool(L_ERROR_REPORTING);
  error_halt:= CfgVarToBool(L_ERROR_HALT);
end;

{ append single new value to WebConfiguration array i.e. conf[] }
function AddWebCfgVar(const name, value: astr): bln;
begin
  result:= false;
 {$IFNDEF GZIP_ON} // not applicable if gzip off
  if IsGzipFlag(name) then exit;
 {$ENDIF}
  AddWebVar(TWebVars(conf), name, value);
  MergeFlagsToCfg;
end;

{ updates value if name exists in list, returns false if no update }
function UpdateWebVar(var webv: TWebVars; const name, value: astr; upcased: bln): bln;
var i, len: longword;
begin
  result:= false;
  len:= length(webv);
  if len > 0 then for i:= 0 to len - 1 do begin
    if upcased then // case Insensitive NAME
    begin
      if Ucase(webv[i].name) = Ucase(name) then begin 
        webv[i].value:= value;
        result:= true;
      end;
    end else // case Sensitive NAME
      if webv[i].name = name then begin 
        webv[i].value:= value;
        result:= true;
      end;
  end;
end;


{ updates value if name exists in list, returns false if no update }
function UpdateWebCfgVar(const name, value: astr; upcased: bln): bln;
begin
  result:= false;
 {$IFNDEF GZIP_ON} // not applicable if gzip off
  if IsGzipFlag(name) then exit;
 {$ENDIF}
  result:= UpdateWebVar(TWebVars(conf), name, value, upcased);
  if result = true then MergeFlagsToCfg;
end;


function iAddWebCfgVar(const name, value: astr): bln;
begin
  result:= AddWebCfgVar(name, value);
end;


function iUpdateWebVar(var webv: TWebVars; const name, value: astr; upcased: bln): bln;
begin
  result:= UpdateWebVar(webv, name, value, upcased);
end;


(*
{ updates value if name exists in list, adds one if it doesn't }
procedure PutWebVar(var webv: TWebVars; const name, value: astr; upcased: bln);
var updated: bln;
begin
  updated:= UpdateWebVar(webv,  name, value, upcased);
  if not updated then AddWebVar(webv, name, value);
end;
*)

{ updates value if name exists in list, adds one if it doesn't }
procedure PutWebCfgVar(const name, value: astr; upcased: bln);
var updated: bln;
begin
  updated:= UpdateWebCfgVar(name, value, upcased);
  if not updated then AddWebCfgVar(name, value);
end;


{ init default RTI definitions on startup }
procedure InitRTI;
{$I begin_initrti.inc}
  SetLength(rti, 2);
  rti[0].name:=  U_HEADERS_SENT;
  rti[0].value:= U_FALSE;
  rti[1].name:=  U_ERRORS;
  rti[1].value:= '0';
{$I end_initrti.inc}

{ Defaults if not using config file plugin unit }
procedure DefaultCfgInit;
begin {$IFDEF DBUG_ON} debugln('SetDefaultCfgInit begin');{$ENDIF}
  AddWebCfgVar(L_HEADER_CHARSET, 'iso-8859-1');
  AddWebCfgVar(L_ERROR_REPORTING, 'on');
  AddWebCfgVar(L_ERROR_HALT, 'off');
  AddWebCfgVar(L_UPLOAD_MAX_SIZE, '20');
 {$IFDEF GZIP_ON}
  AddWebCfgVar(L_OUTPUT_BUFFERING, 'off');
  AddWebCfgVar(L_OUTPUT_COMPRESSION, 'off');
 {$ENDIF}
 {$IFDEF DBUG_ON}debugln('DefaultCfgInit end');{$ENDIF}
end;


procedure InitCook;

  procedure PutCookies;

    { Dump into cook[] var }
    procedure PutCookieVars(const data: astr);
    var
      i, len: longword;
      lex, name, value: astr;

      procedure AddToLex;
      begin
        SetLength(lex, length(lex) + 1);
        lex[length(lex)]:= data[i];
        inc(i);
      end;

    begin
      {$IFDEF DBUG_ON} debugln('PutCookieVars begin');{$ENDIF}
      // Init
      i:= 1;
      len:= length(data);
      if data[1] = '\' then inc(i);
      // Parse out
      while (i <= len) do
      begin
        // Get name
        lex:= '';
        while (i <= len) and (data[i] <> '=') do AddToLex;;
        name:= UrlDecode(lex);
        inc(i);
        // Get value
        lex:= '';
        while (i <= len) and (data[i] <> ';') do AddToLex;
        value:= UrlDecode(lex);
        AddWebVar(cook, name, value);
        inc(i);
        // Ignore spaces
        while (i <= len) and (data[i] = ' ') do inc(i);
      end;

      {$IFDEF DBUG_ON} debugln('PutCookieVars end');{$ENDIF}
    end;

  var hcook: astr;
  begin
    hcook:= '';
    if IsEnvVar('HTTP_COOKIE') then
    begin
      hcook:= GetEnvVar('HTTP_COOKIE');
      PutCookieVars(hcook);
    end;
  end;


begin
  // only once
  if cook_initialized then exit;
  PutCookies;
  cook_initialized:= true;
end;


{ Send simple headers and an error.. for cases where headers not in itialized }
procedure ErrWithHeader(const s: astr);
begin
  NativeWriteLn('Content-type: text/html');
  NativeWriteLn;
  NativeWriteLn('ERR '+s);
  headers_sent:= true;
  halt;
end;

{ Send HTTP headers }
function SendHeaders: bln;
var i: longword;
begin
  {$IFDEF DBUG_ON}debugln('SendHeaders begin');{$ENDIF}
  result:= false;
  // only send once
  if headers_sent then exit;
  // kill if mandatory Init() not called
  if not plugin_init_called then ErrWithHeader(MISSING_INIT_CALL_OR_UNIT);
  if {$IFNDEF FPC}@{$ENDIF}CustomSessUpdate <> nil then CustomSessUpdate;
  // write headers to stdout
  if length(hdr) > 0 then
    for i:= 0 to length(hdr) - 1 do
      NativeWriteLn(hdr[i].name + ': ' + hdr[i].value);

  NativeWriteLn;

  // Update RTI
  headers_sent:= true;
  SetRTI(U_HEADERS_SENT, 'TRUE');
  result:= true;
  {$IFDEF DBUG_ON} debugln('SendHeaders end');{$ENDIF}
end;


{$IFDEF GZIP_ON}
 // flush output buffer
 function FlushBuffer: bln;
 begin {$IFDEF DBUG_ON}debugln('FlushBuffer begin');{$ENDIF}
   result:= false;
   if not headers_sent then SendHeaders;
   OutBuff^.Flush;
   result:= true;
   {$IFDEF DBUG_ON}debugln('FlushBuffer end');{$ENDIF}
 end;
{$ENDIF}


{ Append into cgi[] var }
function AppendCgiVars(const data: astr): bln;
var
  i,
  len,
  cnt: longword;
  lex: astr;

  procedure AddToLex;
  begin
    SetLength(lex, length(lex) + 1);
    lex[length(lex)]:= data[i];
    inc(i);
  end;

begin
  {$IFDEF DBUG_ON}debugln('AppendCgiVars begin');{$ENDIF}
  // Init
  result:= false;
  i:= 1;
  cnt:= length(cgi);
  len:= length(data);
  if len = 0 then 
  begin
    {$IFDEF DBUG_ON}debugln('AppendCgiVars Exit 1');{$ENDIF}
    exit;
  end;
  if data[1] = '\' then inc(i);
  // Parse 
  while (i <= len) do
  begin
    // New item
    SetLength(cgi, cnt + 1);
    // Get name
    lex:= '';
    while (i <= len) and (data[i] <> '=') do AddToLex;
    cgi[cnt].name:= UrlDecode(lex);
    inc(i);
    // Get value
    lex:= '';
    while (i <= len) and (data[i] <> '&') do AddToLex;
    cgi[cnt].value:= UrlDecode(lex);
    inc(i);
    inc(cnt);
  end;

  result:= true;
  {$IFDEF DBUG_ON}debugln('AppendCgiVars end');{$ENDIF}
end;


{ Multipart: Dump vars from multipart/form-data into cgi and UpFile, splits 
  form into items }
procedure MP_FormSplit(var data: PString; const boundary: astr; var form: PMp_Form);
var separator: astr;
    ptr, len, len2: longint;
begin {$IFDEF DBUG_ON} debugln('MP_FormSplit begin');{$ENDIF}
  separator:= '--' + boundary + #13 + #10;
  len2:= length(separator);
  // Cut off last boundary
  len:= substrpos(data^, '--' + boundary + '--');
  data^:= copy(data^, 1, len-1);
  // Cut off first boundary
  delete(data^, 1, len2);
  while len > 0 do
  begin
    len:= length(data^);
    ptr:= substrpos(data^, separator);
    if ptr <> 0 then
    begin
      // Not last item
      SetLength(form^, length(form^) + 1);
      form^[length(form^) - 1]:= copy(data^, 1, ptr - 2);
      // Cut this item and next boundary
      delete(data^, 1, ptr + len2 - 1);
    end else
    begin
      // Last item
      SetLength(form^, length(form^) + 1);
      form^[length(form^) - 1]:= copy(data^, 1, len-1);
      break;
    end;
  end;
  {$IFDEF DBUG_ON} debugln('MP_FormSplit end');{$ENDIF}
end;


{ Multipart: Extracts current line beginning from ptr and ending with #13#10 }
function MP_GetLine(data: PString; var ptr: longint): astr;
var s: astr;
begin {$IFDEF DBUG_ON} debugln('MP_GetLine begin');{$ENDIF}
  result:= '';
  if data = nil then 
  begin
    {$IFDEF DBUG_ON} debugln('MP_GetLine exit, data nil');{$ENDIF}
    exit;
  end;

  repeat
    s:= copy(data^, ptr, 1);
    if (s <> #13) and (s <> #10) then result:= result + s;
    inc(ptr);
  until (s = #13) or (s = #10);

  inc(ptr);

  {$IFDEF DBUG_ON} debugln('MP_GetLine end');{$ENDIF}
end;


{ Multipart: splits string by space. Max. result = 6 strings. }
function MP_SplitLine(line: astr): TMp_Line;
var
  cnt, elem, len: integer;
  s: astr;
  quoted: bln;
begin {$IFDEF DBUG_ON} debugln('MP_SplitLine begin...');{$ENDIF}
  result[1]:= '';
  result[2]:= '';
  result[3]:= '';
  result[4]:= '';
  result[5]:= '';
  result[6]:= '';
  elem:= 1;
  len:= length(line);
  quoted:= false;

  for cnt:= 1 to len do
  begin
    s:= copy(line, cnt, 1);
    if (s='"') then quoted:= not quoted; // on/off - track whether inside quotes or not
    if (s<>' ') and (s<>'=') and (s<>';') and (s<>'"') and (s<>':') then
      result[elem]:= result[elem] + s;
    if ((s=' ') or (s=';') or (s=':') or (s='=')) and quoted then 
      result[elem]:= result[elem] + s;
    if ((s=';') or (s='=') or (s=':')) and (not quoted) then
      inc(elem);
  end;
  {$IFDEF DBUG_ON} debugln('MP_SplitLine end ');{$ENDIF}
end;


{ Multipart: extracts data boundary from content-type string }
function MP_GetBoundary(const content_type: astr): astr;
var len: integer;
begin {$IFDEF DBUG_ON} debugln('MP_GetBoundry begin');{$ENDIF}
  len:= substrpos(Content_Type, '=');
  result:= copy(content_type, len + 1, length(content_type)-len);
  if substrpos(result, '"') = 1 then result:= copy(result, 2, length(result) - 2);
  {$IFDEF DBUG_ON} debugln('MP_GetBoundry end');{$ENDIF}
end;


{ Multipart: put cgi vars }
procedure MP_PutCGIVars(data: PString; const content_type: astr);
var cnt, ptr, tmp, len, dpos: longint;
    buff, boundary: astr;
    line: TMp_Line;
    form: PMp_Form;
    UpIdx: integer; // current index to UpFile array
begin {$IFDEF DBUG_ON} debugln('MP_PutCGIVars begin');{$ENDIF}
  New(form);
  boundary:= MP_GetBoundary(content_type);
  MP_FormSplit(data, boundary, form);
  for cnt:= 0 to (length(form^) - 1) do
  begin
    ptr:= 1;
    len:= length(form^[cnt]);
    dpos:= substrpos(form^[cnt], #13 + #10 + #13 + #10) + 4;
    // Getting first line
    buff:= MP_GetLine(@(form^[cnt]), ptr);
    // Splitting into words
    line:= MP_SplitLine(buff);
    // Is it file or variable?
    if substrpos(buff, 'filename') <> 0 then
    begin
      // It is a file
      SetLength(UpFiles, length(UpFiles) + 1);
      UpIdx:= length(UpFiles) - 1;
      UpFiles[UpIdx].name:= line[4];
      UpFiles[UpIdx].filename:= line[6];
      {$IFDEF DBUG_ON} debugln('Upload name var: ' +UpFiles[UpIdx].name);
                          debugln('Upload filename: ' + UpFiles[UpIdx].filename);
      {$ENDIF}

      // Getting content type
      buff:= MP_GetLine(@(form^[cnt]), ptr);
      line:= MP_SplitLine(buff);
      UpFiles[UpIdx].content_type:= line[2];
      // Getting value till the end
      UpFiles[UpIdx].size:= len - dpos;
      
      // *** Make sure we have enough room to use MOVE *** (equivalent to GetMem);
      SetLength(UpFiles[UpIdx].data, UpFiles[UpIdx].size);
      
      // NO LONGER NEEDED *** UpFiles[UpIdx].data:= copy(form^[cnt], dpos, UpFiles[UpIdx].size);
       // ** Tonys Code     
       // *** Move is Much faster then copy especially for large strings.
      if UpFiles[UpIdx].size > 0 then
        move(form^[cnt][dpos], UpFiles[UpIdx].Data[1], UpFiles[UpIdx].size);
    end else // It is a variable
    begin
      // Getting value till the end
      tmp:= len - dpos;
      AddWebVar(cgi, line[4], copy(form^[cnt], dpos, tmp));
    end;
  end;

  dispose(form);
  {$IFDEF DBUG_ON} debugln('MP_PutCGIVars end');{$ENDIF}
end;


{ Get/set url query string, get/post etc. }
procedure InitWebData;

  procedure PutQueryString;
  var s: astr;
  begin
    s:= '';
    s:= GetEnvVar('QUERY_STRING');
    AppendCgiVars(s);
  end;

var
  upl_max_size, cont_len, cnt: longword;
  method, ctype, data: astr;
begin
  {$IFDEF DBUG_ON} debugln('InitWebData begin');{$ENDIF}
  // First get method data
  method:= GetEnvVar('REQUEST_METHOD');
  if method = 'POST' then
  begin
    // url variables persist even in a POST
    PutQueryString;
    // now retrieve and store POST data from stdin
    data:= '';
    val(GetCfgVar(L_UPLOAD_MAX_SIZE), upl_max_size);
    upl_max_size:= upl_max_size * 1048576;
    val(GetEnvVar('CONTENT_LENGTH'), cont_len);
    if cont_len > upl_max_size then cont_len:= upl_max_size;
    SetLength(data, cont_len);
    for cnt:= 1 to cont_len do read(data[cnt]);
    // Depending on content type
    ctype:= GetEnvVar('CONTENT_TYPE');
    if substrpos(Lcase(ctype), 'application/x-www-form-urlencoded') > 0 then
      AppendCGIVars(data)
    else
      if substrpos(Lcase(ctype), 'multipart/form-data') > 0 then
        MP_PutCGIVars(@data, ctype);
  end;

  if method = 'GET' then PutQueryString;
  {$IFDEF DBUG_ON} debugln('InitWebData end');{$ENDIF}
end;


{ Sets Run Time Information variable }
procedure SetRTI(const name, value: astr);
begin {$IFDEF DBUG_ON} debugln('SetRTIi begin');{$ENDIF}
  if not UpdateWebVar(rti, name, value, CASE_IGNORE) then
    AddWebVar(rti, name, value);
  {$IFDEF DBUG_ON}debugln('SetRTI end');{$ENDIF}
end;


{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{--- PUBLIC FUNCTIONS/PROCEDURES ----------------------------------------------}
{------------------------------------------------------------------------------}

{..............................................................................}

  { iFunction prefixed with "i" means internal. They are for addon/extension 
    units. PUBLIC, but regular API users  SHOULD NOT USE THEM  }

  procedure iAddWebVar(var webv: TWebVars; const name, value: astr);
  begin
   AddWebVar(webv, name, value);
  end;

  procedure iSetRTI(const name, value: astr);
  begin
   SetRTI(name, value);
  end;

  { Check session plugin unit is setup properly }
  function iCustomSessUnitSet: bln;
  begin
    result:= false;
    if (assigned(CustomSessUnitInit)) and (assigned(CustomSessUpdate))
    then
      result:= true;
  end;

  { Check config plugin unit is setup properly }
  function iCustomCfgUnitSet: bln;
  begin
    result:= false;
    if assigned(CustomCfgUnitInit) then result:= true;
  end;


{..............................................................................}


{ wrapper for fpc/delphi lowercase function }
function Lcase(const s: astr): astr;
begin
 {$IFDEF FPC} result:= system.lowercase(s);
 {$ELSE}      result:= lowercase(s);
 {$ENDIF}
end;

{ wrapper for fpc/delphi uppercase function }
function Ucase(const s: astr): astr;
begin
 {$IFDEF FPC}result:= system.upcase(s);
 {$ELSE}     result:= uppercase(s); 
 {$ENDIF}
end;


{ Return number of config variables }
function CountCfgVars: longword;
begin
  result:= length(conf);
end;

{ Indexed access to configuration variable }
function FetchCfgVarName(idx: longword): astr;
begin
  if (idx < longword(length(conf))) and (length(conf) > 0) then
    result:= conf[idx].name
  else
    result:= '';
end;

{ Indexed access to configuration variable }
function FetchCfgVarVal(idx: longword): astr;
begin
  if (idx < longword(length(conf))) and (length(conf) > 0) then
    result:= conf[idx].value
  else
    result:= '';
end;

{ Tells whether a configuration variable is assigned }
function IsCfgVar(const name: astr): bln;
var i: longword;
begin
  result:= false;
  if length(conf) > 0 then 
    for i:= 0 to length(conf) - 1 do if conf[i].name = name then
    begin
      result:= true;
      break;
    end;
end;


{ Dynamically sets configuration variable name and value }
function SetCfgVar(const name, value: astr): bln;

  { convert string to bln, 'on' equals true }
  procedure SetFlag(var flag: bln; const value: astr);
  begin
    if Lcase(value) = 'on' then flag:= true else flag:= false;
  end;

  { convert string to coolean, then check flag: 'on' equals true }
  function FlagOn(const value: astr): bln;
  begin
    if Lcase(value) = 'on' then result:= true else result:= false;
  end;

  type TCfgKind = (ckOther, ckHeaderCharset, ckErrorReporting, ckErrorHalt, 
                   ckOutputBuffering, ckOutputCompression, ckSessionPath,
                   ckSessionLifetime, ckUploadMaxSize);
  { makes case statement possible for strings }
  function CfgKind(const f: astr): TCfgKind;
  begin
    result:= ckOther;
    if f = L_HEADER_CHARSET then result:= ckHeaderCharset else if
       f = L_ERROR_REPORTING then result:= ckErrorReporting else if
       f = L_ERROR_HALT then result:= ckErrorHalt else if
      {$IFDEF GZIP_ON}
       f = L_OUTPUT_BUFFERING then result:= ckOutputBuffering else if
       f = L_OUTPUT_COMPRESSION then result:= ckOutputCompression else if
      {$ENDIF}
       f = L_SESSION_PATH then result:= ckSessionPath else if
       f = L_SESSION_LIFE_TIME then result:= ckSessionLifetime else if
       f = L_UPLOAD_MAX_SIZE then result:= ckUploadMaxSize 
    {end};
  end;

label error1, error2, error3, error4, error5, error6;

{$I begin_setconfigvar.inc}
  // initialize
  result:= false; 

  // set flags
  case CfgKind(name) of
    ckHeaderCharset: if headers_sent then goto error1;
    ckErrorReporting:  SetFlag(error_reporting, value);
    ckErrorHalt: SetFlag(error_halt,value);
   {$IFDEF GZIP_ON}
    ckOutputBuffering: 
    begin
      // set flags and apply checks
      if FlagOn(value) then output_buffering:= true
      else begin
        if output_buffering then FlushBuffer;
        output_buffering:= false;
      end;
    end;
    ckOutputCompression:
    begin
      // Setting internal flag and applying checks
      if FlagOn(value) then begin
        if headers_sent then goto error3;
        if not output_buffering then goto error2;
        output_compression:= true;
      end else begin
        if headers_sent then goto error3;
        if output_compression then UnsetHeader('Content-Encoding');
        output_compression:= false;
      end;
    end;
   {$ENDIF GZIP_ON}
    ckSessionPath, ckSessionLifetime:
    begin
      if not(iCustomSessUnitSet) then goto error6;
      if headers_sent then goto error4;
    end; 
    
    ckUploadMaxSize: if headers_sent then goto error5;
  end; {case}
  
  PutWebCfgVar(name, value, CASE_IGNORE);
  // headers may have been updated and gzip buffer may need to be created
  InitBufAndHeaders;
  result:= true;

  // ---- EXIT OR HANDLE ERRORS ----
  {$I end_setconfigvar.inc}
end;

{ Returns value of configuration variable. Case insensitive NAME search.
  todo: research if security levels can be implemented }
function GetCfgVar(const name: astr): astr;
var i: longword;
begin
  result:= '';
  if length(conf) > 0 then begin
    for i:= 0 to length(conf) - 1 do if Ucase(conf[i].name) = Ucase(name) then
    begin
      result:= conf[i].value;
      break;
    end;
  end;
end;


{ Returns number of elements in the cgi var list }
function CountPostVars: longword;
begin
  result:= length(cgi);
end;


{ Returns number of cookie variables }
function CountCookies: longword;
begin
  result:= length(cook);
end;


{ Returns number of set headers }
function CountHeaders: longword;
begin
  result:= length(hdr);
end;


{ Returns number of Run-Time Information variables }
function CountRTIVars: longword;
begin
  result:= length(rti);
end;

{ Returns number of files uploaded }
function CountUpFiles: longword;
begin
  result:= length(UpFiles);
end;


{ Returns number of all web (macro) variables }
function CountVars: longword;
begin
  result:= length(vars);
end;

{ Returns number of any macro, cookie, or cgi variables }
function CountAny: longword;
begin
  result:= length(vars) + length(cook) + length(cgi);
end;


{ Replaces special characters with their HTML equivalents
  If you are taking input on a guestook or forum for example, you will want to
  use FilterHTML or the GetCgiVar_SafeHtml function

  Default security level: 2 }
function FilterHtml(const input: astr): astr;
begin
  result:= FilterHtml_S(input, SECURE_ON);
end;


(* Powers the FilterHTML function, here with ability to define security level

  Secure Level X:
    For future consideration
  Secure Level 2:
    Filtering of malicious input variable injection characters. *)
function FilterHtml_S(const input: astr; security: integer): astr;
begin
  
  if security = SECURE_ON then
  begin
    result:= substrreplace(input, ';', '&#59;');    //sql injection semi colon
    result:= substrreplace(result, '&', '&amp;');
    result:= substrreplace(result, '#', '&#35;');   //pound sign
    result:= substrreplace(result, '"', '&quot;');  //quote
    result:= substrreplace(result, '''', '&#39;');  //single quote
    result:= substrreplace(result, '<', '&lt;');    //less than
    result:= substrreplace(result, '>', '&gt;');    //greater than
    result:= substrreplace(result, '|', '&#124;');  //pipe
    result:= substrreplace(result, '%', '&#37;');   //percent sign
    result:= substrreplace(result, '(', '&#40;');   //open bracket
    result:= substrreplace(result, ')', '&#41;');   //closed bracket
    result:= substrreplace(result, '$', '&#36;');   //dollar sign
    result:= substrreplace(result, '?', '&#63;');   //question mark
    result:= substrreplace(result, '--', '&#45;&#45;'); //sql injection double dash
    result:= substrreplace(result,  #0, '0');       //null bad, show 0 to make hackers obvious
//   Note: CSS Styles in a macro var could contain curlies { } so are not filtered    
  end;
  
end;

{ Indexed access to cgi variable }
function FetchPostVarName(idx: longword): astr;
begin
  result:= FetchPostVarName_S(idx, SECURE_ON);
end;

{ Indexed access to cgi variable }
function FetchPostVarVal(idx: longword): astr;
begin
  result:= FetchPostVarVal_S(idx, SECURE_ON);
end;

{ security 0 and custom user filter applied }
function FetchPostVarVal(idx: longword; filter: TFilterFunc): astr;
begin
  result:= FetchPostVarVal_S(idx, SECURE_OFF);
  if assigned(filter) then result:= filter(result);
end;

{ for DLL }
function FetchPostVarVal1(idx: longword): astr;
begin
  result:= FetchPostVarVal(idx);
end;

{ for DLL }
function FetchPostVarVal2(idx: longword; filter: TFilterFunc): astr;
begin
  result:= FetchPostVarVal2(idx, filter);
end;


{ Indexed access to Twebvars name, security specifiable }
function FetchTWebVarName_S(const w: TWebVars; idx: longword; security: integer): astr;
begin
  if (idx < longword(length(w))) and (length(w) > 0) then
  begin
    case Security of 
      SECURE_OFF: result:= w[idx].name;
      SECURE_ON: result:= TrimBadCHars(w[idx].name);
    end;
  end else
   result:= '';
end;

{ Indexed access to Twebvars value, security specifiable }
function FetchTWebVarVal_S(const w: TWebVars; idx: longword; security: integer): astr;
begin
  if (idx < longword(length(w))) and (length(w) > 0) then
  begin
    case Security of 
      SECURE_OFF: result:= w[idx].value;
      SECURE_ON: result:= TrimBadChars(w[idx].value);
    end;
  end else
    result:= '';
end;


{ Indexed access to cgi variable name, security specifiable }
function FetchPostVarName_S(idx: longword; security: integer): astr;
begin
  result:= FetchTWebVarName_S(cgi, idx, security);
end;

{ Indexed access to cgi variable value, security specifiable }
function FetchPostVarVal_S(idx: longword; security: integer): astr;
begin
  result:= FetchTWebVarVal_S(cgi, idx, security);
end;


{ Indexed access to cookie variable }
function FetchCookieName(idx: longword): astr;
begin
  // security off because cookies could characters developers don't want 
  // trimmed, and they may get confused if security was trimming their cookies
  result:= FetchTWebvarName_S(cook, idx, SECURE_OFF);
end;

{ Indexed access to cookie variable }
function FetchCookieVal(idx: longword): astr;
begin
  // security off for the same reasons as FetchCookieName
  result:= FetchTWebvarVal_S(cook, idx, SECURE_OFF);
end;

function FetchCookieVal(idx: longword; filter: TFilterFunc): astr;
begin
  result:= FetchCookieVal(idx);
    if assigned(filter) then result:= filter(result);
end;

{ Indexed access to header }
function FetchHeaderName(idx: longword): astr;
begin
  // security off because headers may contain characters developers don't
  // want trimmed
  result:= FetchTWebvarName_S(hdr, idx, SECURE_OFF);
end;


{ Indexed access to header }
function FetchHeaderVal(idx: longword): astr;
begin
  // security off for same reasons as FetchHeaderName
  result:= FetchTWebvarVal_S(hdr, idx, SECURE_OFF);
end;

{ Indexed access to RTI variable }
function FetchRtiName(idx: longword): astr;
begin
  // security off because RTI vars currently not so externally vulnerible and 
  // could  contain characters that developers don't want trimmed 
  result:= FetchTWebvarName_S(rti, idx, SECURE_OFF);
end;


{ Indexed access to RTI variable }
function FetchRtiVal(idx: longword): astr;
begin
  // security off for same reasons as FetchRtiName
  result:= FetchTWebvarVal_S(rti, idx, SECURE_OFF);
end;


{ Indexed access to uploaded file name }
function FetchUpFileName(idx: longword): astr;
begin
  if (idx < longword(length(UpFiles))) and (length(UpFiles) > 0) then
    result:= UpFiles[idx].name
  else
    result:= '';
end;


{ Indexed access to user defined variable }
function FetchVarName(idx: longword): astr;
begin
  result:= FetchTWebvarName_S(vars, idx, SECURE_OFF);
end;

{ Indexed access to user defined variable }
function FetchVarVal(idx: longword): astr;
begin
  result:= FetchTWebVarVal_S(vars, idx, SECURE_OFF);
end;

function FetchVarVal(idx: longword; filter: TFilterFunc): astr;
begin
  result:= FetchVarVal(idx);
  if assigned(filter) then result:= filter(result);
end;

{ Fmt_SF offers the ability to specify security levels and filter
  settings, and is also used internally to power the default Format
  and FmtFilter functions. Those are the ones you use normally,
  this one is for special circumstances

  The _SF suffix means "with specifiable Security and Filter options"

  If HTMLFilter = false the Filter security is ignored and should be set
  at 0, because there is no filter security setting that applies.

  The trim security is ignored and should set at 0 when
  HTMLFIlter = true,  because we can't trim the special characters
  and then try to replace them after (they would already be trimmed).
  i.e. we have to use one or the other, either replace or trim input.}

function Fmt_SF(const s: astr; HTMLFilter: bln; filter: TFilterFunc;
                FilterSecurity, TrimSecurity: integer): astr;
const
  ID_CHARS = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_';
var
  i,
  len: longword;
  lex: astr;

  { appends char to result string }
  procedure AddToResult;
  begin
    SetLength(result, length(result) + 1);
    result[length(result)]:= s[i];
    inc(i);
  end;

  { if escaped \$var then we must replace \ with $}
  procedure AddEscapedDollar;
  begin
    result[length(result)]:= s[i];
    inc(i);
  end;

  { appends char to lex string }
  procedure AddToLex;
  begin
    SetLength(lex, length(lex) + 1);
    lex[length(lex)]:= s[i];
    inc(i);
  end;

begin
  // Init
  i:= 1;
  len:= length(s);
  lex:= '';
  result:= '';
  // Parsing
  while i <= len do
  begin
    // Normal concat until chars of our attention
    while (i <= len) and (s[i] <> '$') and (s[i] <> '{') 
      do AddToResult;
    // If encountered an indication char
    if (i <= len) and (s[i] = '$') then
    begin
      // $varname?
      // Checking if escaped
      if ((i - 1) > 0) and (s[i - 1] = '\') then AddEscapedDollar
        else
      begin
        // Getting var name
        inc(i);
        lex:= '';
        while (i <= len) and (substrpos(ID_CHARS, s[i]) > 0) do AddToLex;
        // Evaluating and adding
        if HTMLFilter = true then begin
          case FilterSecurity of
            SECURE_OFF: lex:= GetVar_S(lex, SECURE_OFF); //must use GetVar security level off here since we are implementing our own security with filterHTML.
            SECURE_ON: lex:= GetVar(lex, {$IFDEF FPC}@{$ENDIF}FilterHTML); // apply html filter
            SECURE_FILTER: lex:= GetVar(lex, filter); // apply custom filter
          end;
        end else begin
          lex:= GetVar_S(lex, TrimSecurity);
        end;
        result:= result + lex;
      end;
    end else
      if (i <= len) and (s[i] = '{') then 
      begin
        // {$varname}?
        // Check if escaped or for pattern match
        if ((i - 1) > 0) and (s[i - 1] = '\') then AddToResult
          else
        // at end of line?
        if i = len then AddToResult
          else
        // if not found then continue on
        if ((i + 1) < len) and (s[i + 1] <> '$') then AddToResult
          else
        begin
          // There MUST be } or curly braces should be escaped
          // Getting var name till }
          i:= i + 2;
          lex:= '';
          while (i <= len) and (s[i] <> '}') do AddToLex;
          inc(i);
          // Evaluating and adding
          if HTMLFilter = true then
          begin
            case FilterSecurity of
              SECURE_OFF: lex:= GetVar_S(lex, SECURE_OFF); 
              SECURE_ON: lex:= GetVar(lex, {$IFDEF FPC}@{$ENDIF}FilterHtml); // apply html filter
              SECURE_FILTER: lex:= GetVar(lex, filter);   // apply custom filter
            end;
          end else
          begin
            lex:= GetVar_S(lex, TrimSecurity);
          end;
          result:= result + lex;
        end;
      end;
  end;
end;


{ applies a custom html filter to web vars being formatted }
function Fmt(const s: astr; filter: TFilterFunc): astr;
begin
  result:= Fmt_SF(s, true, filter, SECURE_FILTER, SECURE_OFF);
end;


function Fmt_SF(const s: astr; HTMLFilter: bln; 
                FilterSecurity, TrimSecurity: integer): astr;
begin
  result:= Fmt_SF(s, HTMLFilter, nil, FilterSecurity, TrimSecurity);
end;


{ Formats a string replacing variables as if they were macros.
  i.e. if a string contains $MyVariable it will be replaced
  This function does not filter and replace malicious/html characters, but
  rather trims (discards) them

  Default security level: 2 }
function Fmt(const s: astr): astr;
begin
  result:= Fmt_SF(s, false, SECURE_OFF, SECURE_ON);
  // Uses the following default security settings:
  //   Filter HTML: no, we are trimming
  //   Filter security: level 0, we are trimming
  //   Trim security: level 2

end;

{ Same as Fmt, but filters and replaces HTML characters with safe ones,
  as opposed to trimming and discarding them like Fmt() does.

  Default security level: 2 }
function FmtFilter(const s: astr): astr;
begin
  result:= fmt(s, {$IFDEF FPC}@{$ENDIF}FilterHtml);
end;

{ Returns value of CGI (GET/POST) variable. This also means your URL variables.

  Default Security level is 2. Use the _S suffix function if you do not need
  high filtering security, or you wish to implment your own filters }
function GetPostVar(const name: astr): astr;
begin
  result:= GetPostVar_S(name, SECURE_ON);
end;

{ security 0, with custom user filter in place }
function GetPostVar(const name: astr; filter: TFilterFunc): astr;
begin
  result:= GetPostVar_S(name, SECURE_OFF);  
  if assigned(filter) then result:= filter(result);
end;

{ for DLL }
function GetPostVar1(const name: astr; filter: TFilterFunc): astr;
begin
  result:= GetPostVar(name, filter);
end;
{ for DLL }
function GetPostVar2(const name: astr): astr;
begin
  result:= GetPostVar(name);
end;


function GetPostVar_Unsafe(const name: astr): astr;
var i: longword;
begin
  result:= '';
  if length(cgi) = 0 then exit;
  for i:= 0 to length(cgi) - 1 do if cgi[i].name = name then
  begin
    result:= cgi[i].value; 
    exit;
  end;
end;


(* Old way
function GetPostVar_S(const name: string; security: integer): astr;
var
  i: longword;
begin
  result:= '';
  if length(cgi) = 0 then exit;
  
  for i:= 0 to length(cgi) - 1 do if cgi[i].name = name then
  begin
    case security of
     //perform a trim with security 2, output result
     SECURE_ON: 
       begin
         result:= TrimBad_S(cgi[i].value, SECURE_ON);
         exit;
       end;
     //perform NO trim, output result
     SECURE_OFF: 
       begin 
         result:= cgi[i].value; 
         exit;
       end;
    end;{case}
  end;
end;
*)

{ Same as GetPostVar, but the _S suffix means you can choose the security level

  Security 0: does not automatically trim. use this when you want to implement
              your own filtering, such as when using FilterHTML
  Security 2: trims (deletes) special (malicious) characters}
function GetPostVar_S(const name: astr; security: integer): astr;
begin
  result:= GetPostVar_Unsafe(name);
  case security of
    // trim malicous characters
    SECURE_ON: result:= TrimBadChars(result);
    //perform NO trim, raw result
    SECURE_OFF: result:= result; 
  end;
end;

function GetTwebvarAsFloat(const w: TWebVars; const name: astr): double;
var i: longword;
begin
  result:= 0.0;
  if length(w) = 0 then exit;
  for i:= 0 to length(w) - 1 do if w[i].name = name then
  begin
    val(w[i].value, result);
    break;
  end;
end;


{ Returns value of CGI (GET/POST) variable as double precision float }
function GetPostVarAsFloat(const name: astr): double;
begin
  result:= GetTwebvarAsFloat(cgi, name);
end;


function GetTWebvarAsInt(const w: TWebVars; const name: astr): longint;
var i: longword;
begin
  result:= 0;
  if length(w) = 0 then exit;
  for i:= 0 to length(w) - 1 do if w[i].name = name then
  begin
    val(w[i].value, result);
    break;
  end;
end;

{ Returns value of CGI (GET/POST) variable as integer }
function GetPostVarAsInt(const name: astr): longint;
begin
  result:= GetTWebvarAsInt(cgi, name);
end;

function GetTWebvarVal(const w: TWebVars; const name: astr): astr;
var i: longword;
begin
  result:= '';
  if length(w) < 1 then exit;
  for i:= 0 to length(w) - 1 do if w[i].name = name then
  begin
    result:= w[i].value;
    break;
  end;
end;

{ Returns value of a cookie
  todo: research if security levels can be implemented }
function GetCookie(const name: astr): astr;
begin
  result:= GetTWebVarVal(cook, name);
end;

function GetCookie(const name: astr; filter: TFilterFunc): astr;
begin
  result:= GetCookie(name);
    if assigned(filter) then result:= filter(result);
end;

{ Returns value of a cookie as double precision float
  todo: research if security levels can be implemented }
function GetCookieAsFloat(const name: astr): double;
begin
  result:= GetTwebvarAsFloat(cook, name);
end;

{ Returns value of a cookie as integer
  todo: research if security levels can be implemented }
function GetCookieAsInt(const name: astr): longint;
begin
   result:= GetTWebvarAsInt(cook, name);
end;

{ Returns value part of already assigned HTTP header
  todo: research if security levels can be implemented }
function GetHeader(const name: astr): astr;
begin
  result:= GetTWebVarVal(hdr, name);
end;

{ Returns value of RTI (Run Time Information) variable
  todo: research if security levels can be implemented }
function GetRti(const name: astr): astr;
begin
  result:= GetTWebVarVal(rti, name);
end;

{ Returns value of RTI variable as double precision float
  todo: research if security levels can be implemented }
function GetRtiAsFloat(const name: astr): double;
begin
  result:= GetTwebvarAsFloat(rti, name);
end;

{ Returns value of RTI variable as integer
  todo: research if security levels can be implemented }
function GetRtiAsInt(const name: astr): longint;
begin
  result:= GetTWebvarAsInt(rti, name);
end;

{ Returns original name of the uploaded file
  todo: research if security levels can be implemented }
function GetUpFileName(const name: astr): astr;
var i: longword;
begin
  result:= '';
  if length(UpFiles) = 0 then exit;
  for i:= 0 to length(UpFiles) - 1 do if UpFiles[i].name = name then
  begin
    result:= UpFiles[i].filename;
    break;
  end;
end;

{ Returns size of the uploaded file }
function GetUpFileSize(const name: astr): longint;
var i: longword;
begin
  result:= 0;
  if length(UpFiles) = 0 then exit;
  for i:= 0 to length(UpFiles) - 1 do if UpFiles[i].name = name then
  begin
    result:= UpFiles[i].size;
    break;
  end;
end;

{ Returns Content-Type of the uploaded file
  todo: research if security levels can be implemented }
function GetUpFileType(const name: astr): astr;
var i: longword;
begin
  result:= '';
  if length(UpFiles) = 0 then exit;
  for i:= 0 to length(UpFiles) - 1 do if UpFiles[i].name = name then
  begin
    result:= UpFiles[i].content_type;
    break;
  end;
end;

(* Powers the GetVar function. Use this function for special circumstances,
   with the ability to specify security level.

   Security level 0:
     Doesn't trim special characters. Use this if you are trimming yourself,
     or when you are using FilterHTML() function yourself

   Security level 2:
     Trims (deletes) malicious characters from variable *)
function GetVar_S(const name: astr; security: integer): astr;
var i: longword;
begin
  result:= '';
  // look in vars
  if length(vars) > 0 then
    for i:= 0 to length(vars) - 1 do if vars[i].name = name then
    begin
      case security of 
        SECURE_OFF: 
        begin
          result:= vars[i].value;
          exit;
        end;
        SECURE_ON:
        begin
          result:= TrimBadCHars(vars[i].value);
          exit;
        end;
      end;{case}
    end;{loop}
end;


{ Returns value of any macro template variable (vars[])
  Default security level: 2 }
function GetVar(const name: astr): astr;
begin
  result:= GetVar_S(name, SECURE_ON);
end;

function GetVar(const name: astr; filter: TFilterFunc): astr;
begin
  result:= GetVar_S(name, SECURE_OFF);
  if assigned(filter) then result:= filter(result);
end;

function GetAny(const name: astr): astr;
begin
  result:= GetAny_S(name, SECURE_ON);
end;

{ security 0, with custom user filter in place }
function GetAny(const name: astr; filter: TFilterFunc): astr;
begin
  result:= GetAny_S(name, SECURE_OFF);  
  if assigned(filter) then result:= filter(result);
end;

(*
 Powers the GetCGIVar_SafeHTML function. Use this function for special
 circumstances, with the ability to specify security level.

 Security level 0:
   Doesn't filter special characters. Use this if you are filtering or
   trimming yourself, or when you are using FilterHTML

 Security level 2:
   Filters malicious characters from variable into safe html equivalents
*)
function GetPostVar_SF(const name: astr; security: integer): astr;
var i: longword;
begin
  result:= '';
  // look in cgi vars
  if length(cgi) > 0 then
    for i:= 0 to length(cgi) - 1 do if cgi[i].name = name then
    begin
      case security of
        SECURE_OFF: 
        begin
          result:= cgi[i].value;
          exit;
        end;
        SECURE_ON: 
        begin
          result:= FilterHtml(cgi[i].value);
          exit;
        end;
      end;
    end;
end;

function GetPostVar_SafeHTML(const name: astr): astr;
begin
  result:= GetPostVar_SF(name, SECURE_ON);
end;


function GetAny_S(const name: astr; security: integer): astr;
  
  function Check(const w: TWebVars): astr;
  var i: longword;
  begin
    result:= '';
    if length(w) > 0 then
      for i:= 0 to length(w) - 1 do if w[i].name = name then
      begin
        case security of 
         SECURE_OFF: 
         begin
            result:= w[i].value;
            exit;
         end;
         SECURE_ON:
         begin
           result:= TrimBadChars(w[i].value);
           exit;
         end;
        end;{case}
      end;
  end;

begin
  result:= '';
  // look in vars (marcos), cgi (posted), and cookies
  result:= Check(vars); 
  if result = '' then result:= Check(cgi); 
  if result = '' then result:= Check(cook);
end;


{ Returns value of any web variable as float (double precision) }
function GetVarAsFloat(const name: astr): double;
begin
  val(GetVar(name), result);
end;

function GetAnyAsFloat(const name: astr): double;
begin
  val(GetAny(name), result);
end;

{ Returns value of any web variable as integer }
function GetVarAsInt(const name: astr): longint;
begin
  val(GetVar(name), result);
end;

function GetAnyAsInt(const name: astr): longint;
begin
  val(GetAny(name), result);
end;

{ Tells whether a CGI (GET/POST/URL) variable is assigned }
function IsPostVar(const name: astr): bln;
var i: longword;
begin
  result:= false;
  if length(cgi) > 0 then begin
    for i:= 0 to length(cgi) - 1 do if cgi[i].name = name then
    begin
      result:= true;
      break;
    end;
  end;
end;


{ Tells whether a cookie is assigned }
function IsCookie(const name: astr): bln;
var i: longword;
begin
  result:= false;
  if length(cook) > 0 then begin
    for i:= 0 to length(cook) - 1 do if cook[i].name = name then
    begin
      result:= true;
      break;
    end;
  end;
end;


{ Tells if a header is assigned }
function IsHeader(const name: astr): bln;
var i: longword;
begin
  result:= false;
  if length(hdr) = 0 then exit;
  for i:= 0 to length(hdr) - 1 do if Ucase(hdr[i].name) = Ucase(name) then
  begin
    result:= true;
    break;
  end;
end;

{ Tells if an RTI variable exists }
function IsRTI(const name: astr): bln;
var i: longword;
begin
  result:= false;
  if length(rti) > 0 then
    for i:= 0 to length(rti) - 1 do if rti[i].name = name then
    begin
      result:= true;
      break;
    end;
end;

{ Tells if a file field is uploaded }
function IsUpFile(const name: astr): bln;
var i: longword;
begin
  result:= false;
  if length(UpFiles) = 0 then exit;
  for i:= 0 to length(UpFiles) - 1 do if UpFiles[i].name = name then
  begin
    result:= true;
    break;
  end;
end;

function IsVar(const name: astr): byte;
var i: longword;
begin
  result:= 0;
  // look in vars
  if length(vars) > 0 then
    for i:= 0 to length(vars) - 1 do if vars[i].name = name then
    begin
      result:= 1;
      break;
    end;
end;

{ Tells if any web var exists (macro, cookie, POST/GET, etc) 
  NOTE: Backwards compatibility issue: DOES NOT CHECK SESSIONS IN 1.7.X }
function IsAny(const name: astr): byte;
var i: longword;
begin
  result:= 0;
  // look in vars
  if length(vars) > 0 then
    for i:= 0 to length(vars) - 1 do if vars[i].name = name then
    begin
      result:= 1;
      exit;
    end;
  // look in cookies
  if length(cook) > 0 then
    for i:= 0 to length(cook) - 1 do if cook[i].name = name then
    begin
      result:= 3;
      exit;
    end;
  // look in cgi vars
  if length(cgi) > 0 then
    for i:= 0 to length(cgi) - 1 do if cgi[i].name = name then
    begin
      result:= 4;
      exit;
    end;
end;

{ Replaces all end-of-line chars with <br /> tags }
function LineEndToBR(const s: astr): astr;
begin
  result:= s;
  if substrexists(result, #13+#10) then
    result:= substrreplace(result, #13+#10, '<br />');
  if substrexists(result, #10) then
    result:= substrreplace(result, #10, '<br />');
end;

{ Plain text output }
procedure out(const s: astr);
begin
 {$IFDEF GZIP_ON}
  if output_buffering then 
    OutBuff^.AppendStr(s) 
  else
 {$ENDIF}
  begin
    if not headers_sent then SendHeaders;
    NativeWrite(s);
  end;
end;

{ Output several arguments at once, multiple types allowed }
procedure outa(args: array of const);
var i: longint;  
begin  
  if high(Args)<0 then 
    out('')  
  else
  begin
    for i:=0 to high(Args) do  
    begin  
      case Args[i].vtype of  
        vtinteger   : out(inttostr(args[i].vinteger));
        vtboolean   : out(booltostr(args[i].vboolean));
        vtchar      : out(astr(args[i].vchar));  
        vtextended  : out(FormatFloat('', args[i].VExtended^));  // i.e float value
        vtString    : out(args[i].VString^);  
        vtPChar     : out(Args[i].VPChar);  
        vtAnsiString: out(AnsiString(Args[I].VAnsiString));
      else  
        {$IFDEF DBUG_ON} debugln ('OutA():’Unknown type in array of const parameter'{ + args[i].vtype});  {$ENDIF}
      end;  
    end;  
  end;
end;

{ PWU-formatted output $MacroVariables.  As opposed to OutFF, this
  function trims (deletes) malicious characters. It does not replace them with
  html equivilents. F suffix stands for "formatted"
  Default security level: 2, trim }
procedure outf(const s: astr);
begin
  OutF_Fi(s, false{filter OFF});
end;

{ Powers the OutF and OutFF functions
  With specifiable filter option for malicious input. If FilterTheHTML is true
  then the malicious input and special characters are replaced with HTML
  equivilents. If false, the malious input is trimmed (deleted). If you don't
  want trimming or filtering at all, see Format_SF. }
procedure outf_fi(const s: astr; HTMLFilter: bln);
begin
  if HTMLFilter = true then out(FmtFilter(s)) else out(Fmt(s));
end;

{ PWU-formatted output $MacroVariables. As opposed to OutF, this function
  fiters and replaces malicious characters with HTML equivilents, rather
  than deleting them.  FF suffix stands for "format and filter".
  Default security level: 2, filter }
procedure outff(const s: astr);
begin
  outf_fi(s, true{filter});
end;


{ Plain output with line feed (no html break, just CRLF) }
procedure outln(const s: astr);
begin
  out(s + CGI_CRLF);
end;

(* Formatted writeln, outputs $variables that exist from setwebvar. 
   Trims malicious attempts by deleting special characters. F stands 
   for "Formatted". *)
procedure outlnf(const s: astr);
begin
  outlnf_fi(s, false);
end;

{ Formatted and filtered writeln, outputs variables like macros,
  i.e. replaces $MyVar with an existing web variable, plus filters
  malicious attempts by filtering HTML special characters.
  FF stands for "Formatted and Filtered" }
procedure outlnff(const s: astr);
begin
  outlnf_Fi(s, true);
end;


(* powers the WebWriteLnF and WebWriteLnFF functions, and is to be used for
   more control when webwritelnf and webwritelnff are too limiting.
   If HTMLFilter option is on, then the template is filtered first and
   special characters are replaced with HTML equivilents.
   F stands for "Formatted", while _Fi stands for "Filter input options" *)
procedure outlnf_fi(const s: astr; HTMLFilter: bln );
var tmp: astr;
begin
  if HTMLFilter = true then tmp:= FmtFilter(s) else tmp:= Fmt(s);
  outln(tmp);
end;

function NoHeadSentNorBuffering: bln;
begin
  result:= false;
  if (not headers_sent) {$IFDEF GZIP_ON}and (not output_buffering){$ENDIF} then
    result:= true;
end;

{ private, does not check for headers }
procedure SimpleOutLn(const s: astr);
begin
 {$IFDEF GZIP_ON}
  if output_buffering then
  begin
    // Append str to buffer
    OutBuff^.AppendStr(S);
    OutBuff^.AppendLineFeed;
  end else
 {$ENDIF}
    NativeWriteLn(s);
end;

{ Plain file output - returns FILE_READ_ERR if problem, OK otherwise  }
function FileOut(const fname: astr): errcode;
var
  fh: text;
  s: astr;
begin
  result:= FILE_READ_ERR;
  if not FileExists_read(fname) then
  begin
    ThrowNoFileErr(fname);
    exit;
  end;
  if NoHeadSentNorBuffering then SendHeaders;

  assign(fh, fname);
  reset(fh);

  while not eof(fh) do
  begin
    readln(fh, s);
    SimpleOutLn(s);
  end;
  close(fh);
  result:= OK;
end;

{ private }
procedure WriteBuff(p: Pointer; len: LongWord);
begin
 {$IFDEF GZIP_ON}
  if output_buffering then
  begin
    OutBuff^.AppendBuffer(p, len);
  end else
 {$ENDIF}
    NativeWrite(p, len);
end;

{ Binary Buffer Output...UNTYPED }
procedure BufferOut(const buff; len: LongWord);
var P : Pointer;
begin
  P := @Buff;
  if NoHeadSentNorBuffering then SendHeaders;
  WriteBuff(P, len);
end;


{ Plain binary file output }
function ResourceOut(const fname: astr): errcode;
const BUFFSIZE = 16384;
var
  fh: file of char;
  buff: pchar;
  len: longword;
begin
  result:= FILE_READ_ERR;
  len:= 0;
  InitMimeDb; // prepare Tony's mime db unit
  if not FileExists_read(fname) then
  begin
    ThrowNoFileErr(fname);
    exit;
  end;
  GetMem(buff, BUFFSIZE);
  if (not headers_sent) then SetHeader('Content-Type', GetMimeType(fname));
  if NoHeadSentNorBuffering then SendHeaders;
  assign(fh, fname);
  reset(fh);
  while not eof(fh) do
  begin
    blockread(fh, buff^, BUFFSIZE, len);
    WriteBuff(buff, len);
  end;  
  close(fh);
  FreeMem(Buff);
  result:= ok;
end;


{ with custom filter func set by user for security on each macro var }
function TemplateOut(const fname: astr; filter: TFilterFunc): errcode;
var
  fh: text;
  s: astr;
begin
  result:= FILE_READ_ERR;
  if not strwrap1.OpenFile(fh, fname, 'r') then
  begin
    ThrowNoFileErr(fname);
    // cleanup note: file handle shouldn't need closing... if it wasn't opened
    exit;
  end;
  if NoHeadSentNorBuffering then SendHeaders;
  
  while not eof(fh) do
  begin
    readln(fh, s);
    s:= Fmt(s, filter); // apply custom filter to any template macro vars
    SimpleOutLn(s);
  end;
  close(fh);
  result:= OK;
end;

{ default templateout, applies html filter }
function TemplateOut(const fname: astr): errcode;
begin
  result:= TemplateOut(fname, true);
end;


{ Formatted file output (macro $variables). If HTMLFilter is true, then any 
  malicious characters from the incoming variables, are replaced with html 
  equivalents. If false, malicious characters are trimmed (deleted).

  i.e. if an incoming variable $EditInput contains malicious characters, they
  are either trimmed or they are filtered. The actual TEMPLATE itself is not 
  filtered or trimmed of malicious input, just variables being used in the 
  template. Template files are dynamic text files. Anything dynamic in text 
  file format is less secure, just like a PHP script is less secure than static 
  html.}
function TemplateOut(const fname: astr; HtmlFilter: bln): errcode; {overload;}
begin
  if HtmlFilter = true then 
    result:= TemplateOut(fname, {$ifdef FPC}@{$endif}FilterHTML) 
  else 
    result:= TemplateOut(fname, nil);   
end;


{ for DLL exporting }
function TemplateOut1(const fname: astr; HtmlFilter: bln): errcode; overload;
begin
  result:= TemplateOut(fname, htmlfilter);
end;



{ Raw template output. Similar to TemplateOut but NO filtering or trimming
  is perfomed on the macro vars.

  Insecure, only use when you wish to output raw HTML. People can inject
  javascript and other stuff into URL variables if you use RAW template}
function TemplateRaw(const fname: astr): errcode;
begin
  result:= TemplateOut(fname, nil);
end;


{ Sets HTTP header like 'Name: Value' }
function PutHeader(const header: astr): bln;
var i: longword;
    nv: TStrArray;
begin
  result:= false;
  setlength(nv, 0);
  // Check headers
  if headers_sent then
  begin
    ThrowErr('Can''t put header, headers already sent');
    exit;
  end;
  // split into name=value pair
  nv:= substrsplit(header, ':');
  if length(nv) <> 2 then exit;
  nv[0]:= strtrim(nv[0]);
  nv[1]:= strtrim(nv[1]);
  // Change value if already set
  if length(hdr) > 0 then
  for i:= 0 to length(hdr) - 1 do if Ucase(hdr[i].name) = Ucase(nv[0]) then
  begin
    hdr[i].value:= nv[1];
    exit;
  end;
  // Add new header
  AddWebVar(hdr, nv[0], nv[1]);
  result:= true;
  
end;


{ Generate random string of alphanumeric + '_' char, specify string length }
function RandomStr(len: longint): astr;
const PW_CHARS = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_';
var i: longword;
begin
  setlength(result, len);
  for i:= 1 to len do
  begin
    randomize;
    result[i]:= PW_CHARS[random(62) + 1];
  end;
end;


{ Saves uploaded file to disk }
function SaveUpFile(const name, fname: astr): bln;
var
  i: integer;
  fh: TFileOfChar;
  written : bln;
{$I begin_saveupfile.inc}
  result:= false;
  if length(UpFiles) = 0 then exit;
  written:= false;
  if not strwrap1.OpenFile(fh, fname, 'w') then exit;
  i:= 0;
  repeat
    if UpFiles[i].name = name then
      if length(UpFiles[i].Data) > 0 then begin
        blockwrite(fh, UpFiles[i].data[1], UpFiles[i].size);
        if ioresult = 0 then written := true;
      end;
    inc(i);
  until (i = Length(UpFiles)) or written;
  close(fh);
  result:= written;
{$I end_saveupfile.inc}


{ Set a cookie }
function SetCookie(const name, value: astr): bln;
var hdrval: astr;
label error1;
{$I begin_setcookie.inc}
  result:= false;
  // Check headers
  if headers_sent then goto error1;

  // Change value if already exist, or add new one if not exist
  if not UpdateWebVar(cook, name, value, CASE_SENSITIVE) then
  begin
    // Add new one
    AddWebVar(cook, name, value);
    // Add header
    hdrval:= UrlEncode(name) + '=' + UrlEncode(value) + ';path=/;expires='+ FUTURE_COOKIE;
    AddWebVar(hdr, 'Set-Cookie', hdrval);
  end;
  result:= true;
   // ---- EXIT OR HANDLE ERRORS ----
  {$I end_setcookie.inc}
  error1: {$I err_setcookie1.inc}
end;

{ Set cookie as double precision float }
function SetCookieAsFloat(const name: astr; value: double): bln;
var s: astr;
begin
  str(value, s);
  result:= SetCookie(name, s);
end;


{ Set cookie as integer }
function SetCookieAsInt(const name: astr; value: longint): bln;
var s: astr;
begin
  str(value, s);
  result:= SetCookie(name, s);
end;

{ Set extended cookie }
function SetCookieEx(const name, value, path, domain, expiry: astr): bln;
var headval, pathval, domainpart, expireval: astr;
    updated: bln;
label error1;
{$I begin_setcookieex.inc}
  result:= false;
  // Check headers
  if headers_sent then goto error1;
  // Update value if name already exists, or add new one
  updated:= UpdateWebVar(cook, name, value, CASE_SENSITIVE);
  if not updated then
  begin
    AddWebVar(cook, name, value);
    pathval:= path;
    if pathval = '' then pathval:= '/';
    if domain = '' then domainpart:= '' else domainpart:= 'domain=' + domain + ';';
    expireval:= expiry;
    if expireval = '' then expireval:= FUTURE_COOKIE;
    // Add new header
    headval:= UrlEncode(name) + '=' + UrlEncode(value) + ';' + 
              'path=' + pathval + ';' + 
              domainpart + 
              'expires=' + expireval; // note: no trailing semi-colon
    AddWebVar(hdr, 'Set-Cookie', headval);
  end;
  result:= true;
  // ---- EXIT OR HANDLE ERRORS ----
  {$I end_setcookieex.inc}
  error1: {$I err_setcookieex1.inc}
end;

{ Sets an extended cookie as double precision float }
function SetCookieAsFloatEx(const name: astr; value: double; const path, domain, expiry: astr): bln;
var s: astr;
begin
  str(value, s);
  result:= SetCookieEx(name, s, path, domain, expiry);
end;


{ Sets an extended cookie as integer }
function SetCookieAsIntEx(const name: astr; value: longint; const path, domain, expiry: astr): bln;
var s: astr;
begin
  str(value, s);
  result:= SetCookieEx(name, s, path, domain, expiry);
end;

{ Sets HTTP header }
function SetHeader(const name, value: astr): bln;
begin
  {$IFDEF DBUG_ON} debugln('SetHeader begin'); {$ENDIF}
  result:= false;
  // Check headers
  if headers_sent then
  begin
    ThrowErr('Can''t set header, headers already sent');
    {$IFDEF DBUG_ON} debugln('SetHeader exit 1'); {$ENDIF}
    exit;
  end;
  // Change value if already exist or add new if not exist
  if not UpdateWebVar(hdr, name, value, CASE_IGNORE) then
  begin
    // add new
    AddWebVar(hdr, name, value);
    result:= true;
  end;
 {$IFDEF DBUG_ON} debugln('SetHeader end'); {$ENDIF}
end;

(* Assigns web variable. i.e. macro variables in templates and formated output
   such as $SomeVar and {$SomeVar} *)
procedure SetVar(const name, value: astr);
begin {$IFDEF DBUG_ON} debugln('SetVar begin'); {$ENDIF}
  // Change value if name already exist, or add new one if not exist
  if not UpdateWebVar(vars, name, value, CASE_IGNORE) then
    AddWebVar(vars, name, value);
 {$IFDEF DBUG_ON} debugln('SetVar end'); {$ENDIF}
end;


{ Assigns PWU variable as double precision float }
procedure SetVarAsFloat(const name: astr; value: double);
var s: astr;
begin
  str(value, s);
  SetVar(name, s);
end;


{ Assigns PWU variable as integer }
procedure SetVarAsInt(const name: astr; value: longint);
var s: astr;
begin
  str(value, s);
  SetVar(name, s);
end;


type TThrowType = (ttError, ttWarn);

{ Abstract for throwerr and throwwarn }
procedure ThrowMsg(const msg: astr; const style: TThrowType);
var i: longint;
    s: astr;
begin  {$IFDEF DBUG_ON} debugln('ThrowMsg begin'); {$ENDIF}
  // Increase ERRORS RTI
  i:= GetRtiAsInt('ERRORS');
  inc(i);
  str(i, s);
  iSetRTI('ERRORS', s);
  if not error_reporting then exit; 
  // Disable content encoding
  if IsHeader('Content-Encoding') then UnsetHeader('Content-Encoding');
  // Send headers
  if not headers_sent then SendHeaders;
 {$IFDEF GZIP_ON} // Flush buffer
  if output_buffering then FlushBuffer;
 {$ENDIF}
  // spit error to screen
  outln('<br>');
  case style of
    ttError: outln('ERR: ' + Msg);
    ttWarn: outln('WARNING: ' + Msg);
  end;
  outln('<br>');
  if error_halt then halt(0);
  // Done
 {$IFDEF DBUG_ON} debugln('ThrowMsg end'); {$ENDIF}
end;


{ Throws err if error reporting is on in config settings }
procedure ThrowErr(const s: astr);
begin
  ThrowMsg(s, ttError);
end;

{ Throws warning }
procedure ThrowWarn(const s: astr);
begin
  ThrowMsg(s, ttWarn);
end;


{ Trims (deletes) all bad, unsecure characters from a string.
  i.e. hackers sometimes use pipe characters | or ../../ to try to hack the
  server. Mainly useful for trimming URL variables for malicious attempts.
  Note: see also FilterHTML, which replaces characters with real output such
        as &gt; &quot;

 Default security level: 2 }
function TrimBadChars(const input: astr): astr;
begin
  result:= TrimBad_S(input, SECURE_ON);
end;


{ Trims (deletes) all bad, unsecure characters from a string that is being used
  for filenames.  This function is not meant UTF8 or international file systems
  Replaces invalid character with ZERO, to help report malicious attempts. If you see ZERO's in your files on FTP you know someone has been fucking around with your server trying to get into your system using special characters.  }
function TrimBadFile(const input: astr): astr;

  { first character in file name must be alphanumeric (no hyphen, space, etc) }
  procedure FirstCharTrim;
  begin
    if (not (result[1] in ['a'..'z'])) and (not (result[1] in ['A'..'Z'])) and
      (not (result[1] in ['0'..'9']))
    then
      result[1]:= '0';
  end;

begin
 {$IFDEF DBUG_ON} debugln('TrimBadChars_file begin'); {$ENDIF}
  if length(input) < 1 then exit;

  //    . Dot is okay
  //    ~ Squiggly  character is okay for filenames

  result:= substrreplace(input,'/',   '0');   // slashes NOT okay. safe means local directory only!
  result:= substrreplace(result,'\',  '0');   // slashes NOT okay. safe means local directory only!
  result:= substrreplace(result,'|',  '0');   // pipe character bad
  result:= substrreplace(result,'#',  '0');
  result:= substrreplace(result,'@',  '0');
  result:= substrreplace(result,'$',  '0');
  result:= substrreplace(result,'!',  '0');
  result:= substrreplace(result,'%',  '0');
  result:= substrreplace(result,'^',  '0');
  result:= substrreplace(result,'&',  '0');
  result:= substrreplace(result,'*',  '0');
  result:= substrreplace(result,'=',  '0');
  result:= substrreplace(result,'`',  '0');
  result:= substrreplace(result,'?',  '0');
  result:= substrreplace(result,'"',  '0');   // double quote
  result:= substrreplace(result,'''', '0');   // single quote
  result:= substrreplace(result,'[',  '0');   // square bracket open
  result:= substrreplace(result,']',  '0');   // square bracket close
  result:= substrreplace(result,'>',  '0');   // greater than
  result:= substrreplace(result,'<',  '0');   // less than
  result:= substrreplace(result,',',  '0');   // comma
  result:= substrreplace(result, #0,  '0');   // NULL
  result:= substrreplace(result, ';',  '0');  // semicolon not used in files normally
  FirstCharTrim;
 {$IFDEF DBUG_ON} debugln('TrimBadChars_file end'); {$ENDIF}
end;


{ Trims all bad, unsecure characters from a string that is being used
  for a directory. For example, if you are opening a directory or file and
  directory, you will want only characters like A-Z, plus dots, slashes, and
  brackets, but not things like pipe characters and quotations
  This function is not meant UTF8 or international file systems
  Replaces invalid character with ZERO, to help report malicious attempts. If you see ZERO's in your files on FTP you know someone has been fucking around with your server trying to get into your system using special characters.  }
function TrimBadDir(const input: astr): astr;

  { first char in directory should be alphanumeric, dot, or slash (DIRSEP)  }
  procedure FirstCharTrim;
  begin
    if length(result) < 1 then exit;
    if (not (result[1] in ['a'..'z'])) and (not (result[1] in ['A'..'Z'])) and
       (not (result[1] in ['0'..'9'])) and (result[1] <> '.') 
       and (result[1] <> SLASH)
    then
      result[1]:= '0';
  end;

begin
 {$IFDEF DBUG_ON} debugln('TrimBadChars_dir begin'); {$ENDIF}
  result:= substrreplace(input,  '|', '0'); // pipe bad
//    result:= substrreplace(result,'.', '');  // Dot is okay
//    result:= substrreplace(result,'~', '');  // Squiggly ~ okay
 {$IFDEF UNIX} // windows slashes on unix not accepted
  result:= substrreplace(result,'\', '');
 {$ENDIF}
 {$IFDEF WINDOWS} // unix slashes on windows not allowed (therefor http/ftp paths on windows not allowed in this function)
  result:= substrreplace(result,'/', '');
 {$ENDIF}
  result:= substrreplace(result, '#', '0');
  result:= substrreplace(result, '@', '0');
  result:= substrreplace(result, '$', '0');
  result:= substrreplace(result, '!', '0');
  result:= substrreplace(result, '%', '0');
  result:= substrreplace(result, '^', '0');
  result:= substrreplace(result, '&', '0');
  result:= substrreplace(result, '*', '0');
  result:= substrreplace(result, '=', '0');
  result:= substrreplace(result, '`', '0');
  result:= substrreplace(result, '?', '0');
  result:= substrreplace(result, '"', '0');   // double quote
  result:= substrreplace(result, '''','0');   // single quote
  result:= substrreplace(result, '[', '0');   // square bracket open
  result:= substrreplace(result, ']', '0');   // square bracket close
  result:= substrreplace(result, '>', '0');   // greater than
  result:= substrreplace(result, '<', '0');   // less than
  result:= substrreplace(result, ',', '0');   // comma
  result:= substrreplace(result, #0, '0');    // NULL
  result:= substrreplace(result, ';', '0');   // semicolon not used in directories normally
  FirstCharTrim;
 {$IFDEF DBUG_ON} debugln('TrimBadChars_dir end'); {$ENDIF}
end;


{ Powers the TrimBadChars function. Replaces bad characters with ZERO which
  makes early problems in web application easy to spot.
  Define security level
    SECURE_ON:  Trims bad (malicious) characters
    OTHERS: future consideration}
function TrimBad_S(const input: astr; security: integer): astr;
begin
 {$IFDEF DBUG_ON} debugln('TrimBad_S begin'); {$ENDIF}
  result:= '';
  if security = SECURE_ON then
  begin
    result:= substrreplace(input, '/',  '0');  // slashes bad
    result:= substrreplace(result,  #0, '0');  // null character
    result:= substrreplace(result, '\', '0');
    result:= substrreplace(result, '|', '0');  // pipe character bad
    result:= substrreplace(result, '?', '0');
    result:= substrreplace(result, '$', '0');
    result:= substrreplace(result, '<', '0');
    result:= substrreplace(result, '>', '0');
    result:= substrreplace(result, '#', '0');
    result:= substrreplace(result, '@', '0');
    result:= substrreplace(result, '!', '0');
    result:= substrreplace(result, '%', '0');
    result:= substrreplace(result, '^', '0');
    result:= substrreplace(result, '&', '0');
    result:= substrreplace(result, '*', '0');
    result:= substrreplace(result, '=', '0');
    result:= substrreplace(result, '~', '0');
    result:= substrreplace(result, '(', '0');
    result:= substrreplace(result, ')', '0');
    result:= substrreplace(result, '[', '0');
    result:= substrreplace(result, ']', '0');
    result:= substrreplace(result, '--', '00'); // SQL injection double dash
    result:= substrreplace(result, ';', '0');   // SQL injection semi colon
    result:= substrreplace(result, '`', '0');  // backquote
    result:= substrreplace(result, '"', '0');  // double quote
    result:= substrreplace(result, '''','0');  // single quote
  end;

 {$IFDEF DBUG_ON}debugln('TrimBad_S end');{$ENDIF}
end;


{ Unsets a cookie }
function UnsetCookie(const name: astr): bln;
begin
  result:= UnsetCookieEx(name, '', '');
end;


{ Unset cookie extended }
function UnsetCookieEx(const name, path, domain: astr): bln;
var
  tmp: TWebVars;
  i: longword;
  hdrval: astr;
begin  {$IFDEF DBUG_ON} debugln('UnsetCookieEx begin'); {$ENDIF}
  result:= false;
  // Header check
  if headers_sent then
  begin
    ThrowErr('Can''t unset cookie, headers already sent');
    {$IFDEF DBUG_ON} debugln('UnsetCookieEx exit'); {$ENDIF}
    exit;
  end;
  // First removing from the list
  SetLength(tmp, 0);
  if length(cook) > 0 then
  for i:= 0 to length(cook) - 1 do if cook[i].name <> name then
  begin
    SetLength(tmp, length(tmp) + 1);
    tmp[length(tmp) - 1]:= cook[i];
  end;
  // Swap
  cook:= tmp;
  // process UnsetCookie if domain & path = '' or process UnsetCookieEx if not empty
  if (domain = '') and (path = '') then
    hdrval:= UrlEncode(name) + '=;path=/;expires=' + EXPIRED_COOKIE
  else
    hdrval:= UrlEncode(name) + '=;path=' + path + ';domain=' + domain + ';expires='+ EXPIRED_COOKIE;
  AddWebVar(hdr, 'Set-Cookie', hdrval);

  result:= true;
 {$IFDEF DBUG_ON} debugln('UnsetCookieEx end'); {$ENDIF}
end;


{ Removes HTTP header from the list }
function UnsetHeader(const name: astr): bln;
var
  tmp: TWebVars;
  i: longword;
begin
  {$IFDEF DBUG_ON}debugln('UnsetHeader begin');{$ENDIF}
  result:= false;
  // Check
  if headers_sent then
  begin
    ThrowErr('UnsetHeader: no effect, header already sent');
    {$IFDEF DBUG_ON}debugln('UnsetHeader exit');{$ENDIF}
    exit;
  end;
  // first remove from list
  SetLength(tmp, 0);
  if length(hdr) > 0 then
  for i:= 0 to length(hdr) - 1 do if Ucase(hdr[i].name) <> Ucase(name) then
  begin
    SetLength(tmp, length(tmp) + 1);
    tmp[length(tmp) - 1]:= hdr[i];
  end;
  // Swap
  hdr:= tmp;
  result:= true;
 {$IFDEF DBUG_ON}debugln('UnsetHeader end');{$ENDIF}
end;


{ Removes web variable from list }
procedure UnsetVar(const name: astr);
var
  tmp: TWebVars;
  i: longword;
{$I begin_unsetvar.inc}
  SetLength(tmp, 0);
  if length(vars) > 0 then
  for i:= 0 to length(vars) - 1 do
    if Ucase(vars[i].name) <> Ucase(name) then
    begin
      SetLength(tmp, length(tmp) + 1);
      tmp[length(tmp) - 1]:= vars[i];
    end;
  // Swap
  vars:= tmp;
{$I end_unsetvar.inc}


{ Bytewise XOR encryption }
function XorCrypt(const s: astr; key: byte): astr;
var i, len: longword;
begin
  result:= '';
  len:= length(s);
  if len > 0 then
  begin
    SetLength(result, len);
    for i:= 1 to len do
      result[i]:= chr(ord(s[i]) xor key);
  end;
end;

{ END OF PUBLIC FUNCTIONS/PROCEDURES                                           }
{------------------------------------------------------------------------------}


{--- INITIALIZATION/FINALIZATION ----------------------------------------------}

{$IFDEF GZIP_ON}
 // Flush buffer if not already
 procedure FlushOutputBuf;
 begin
   if (output_buffering) and (output_compression) then dispose(OutBuff, Destroy); // flushes on destroy
 end;

 // Set content length if buffering/compression enabled
 procedure SetGzipContentLength;
 var gzipused: astr; 
 begin
   gzipused:= '';
   if (output_buffering) and (output_compression) and (not headers_sent)
     and (OutBuff^.Used > 0) then
   begin
     OutBuff^.gzip;
     str(OutBuff^.Used, gzipused);
     SetHeader('Content-Length', gzipused);
   end;
 end;
{$ENDIF}

{ Below Init function must be called at start of all web progams, and cannot 
  be put in pwmain initialization since it relies on other units initializing 
  first such as addon session and config plugin units }
procedure Init;
begin
  if plugin_init_called then exit;
  if iCustomCfgUnitSet then CustomCfgUnitInit else DefaultCfgInit;
  InitRTI;
  InitBufAndHeaders;
  InitWebData;
  // init cookies
  InitCook; 
  // init sessions
  if iCustomSessUnitSet then CustomSessUnitInit;
  plugin_init_called:= true;
end;


procedure LocalInit;

 {$IFDEF PWUDEBUG}
  procedure InitDebug;
  begin
    debugln:= @logdebugln; // default log file debugging
    assign(debugt, 'pwmain.debug.log');
    rewrite(debugt);
    debugln('----DEBUG LOG----');
    flush(debugt);
  end;
 {$ENDIF}

begin
  {$IFDEF PWUDEBUG}InitDebug;{$ENDIF}
end;

procedure LocalFini;
begin
  {$IFDEF GZIP_ON}SetGzipContentLength;{$ENDIF}
  if not headers_sent then SendHeaders;
  {$IFDEF GZIP_ON}FlushOutputBuf;{$ENDIF}
  {$IFDEF PWUDEBUG}close(debugt);{$ENDIF}
end;

{initialization
  LocalInit;
finalization
  LocalFini; }
end.


