unit uPSI_pwmain;
{
  for cgi  define pastr
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_pwmain = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 
{ compile-time registration functions }
procedure SIRegister_pwmain(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_pwmain_Routines(S: TPSExec);

procedure Register;

implementation


uses
   pwerrors
  ,pwtypes
  ,pwmain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_pwmain]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_pwmain(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('FUTURE_COOKIE','String').SetString( 'Mon, 01 Dec 2099 12:00:00 GMT');
 CL.AddConstantN('EXPIRED_COOKIE','String').SetString( 'Mon, 01 Jan 2001 12:00:00 GMT');
 CL.AddConstantN('SECURE_OFF','LongInt').SetInt( 0);
 CL.AddConstantN('SECURE_ON','LongInt').SetInt( 2);
 CL.AddConstantN('SECURE_FILTER','LongInt').SetInt( 3);

 //  astr = ansistring;
  CL.AddTypeS('pastr', 'ansistring');
  CL.AddTypeS('TFilterFunc', 'function(const s: pastr): pastr;');

  //type  TFilterFunc = function(const s: astr): astr;


 //CL.AddConstantN('CASE_SENSITIVE','Boolean')BoolToStr( false);
 //CL.AddConstantN('CASE_IGNORE','Boolean')BoolToStr( false);
 CL.AddDelphiFunction('Procedure pwInit');
 CL.AddDelphiFunction('Procedure OffReadln');
 CL.AddDelphiFunction('Function Lcase( const s : pastr) : pastr');
 CL.AddDelphiFunction('Function Ucase( const s : pastr) : pastr');
 CL.AddDelphiFunction('Function CountPostVars : longword');
 CL.AddDelphiFunction('Function GetPostVar( const name : pastr) : pastr;');
 CL.AddDelphiFunction('Function GetPostVar1( const name : pastr; filter : TFilterFunc) : pastr;');
 CL.AddDelphiFunction('Function GetPostVar_S( const name : pastr; Security : integer) : pastr');
 CL.AddDelphiFunction('Function GetPostVar_SF( const name : pastr; Security : integer) : pastr');
 CL.AddDelphiFunction('Function GetPostVarAsFloat( const name : pastr) : double');
 CL.AddDelphiFunction('Function GetPostVarAsInt( const name : pastr) : longint');
 CL.AddDelphiFunction('Function GetPostVar_SafeHTML( const name : pastr) : pastr');
 CL.AddDelphiFunction('Function FetchPostVarName( idx : longword) : pastr');
 CL.AddDelphiFunction('Function FetchPostVarVal( idx : longword) : pastr;');
 CL.AddDelphiFunction('Function FetchPostVarVal1( idx : longword; filter : TFilterFunc) : pastr;');
 CL.AddDelphiFunction('Function FetchPostVarName_S( idx : longword; Security : integer) : pastr');
 CL.AddDelphiFunction('Function FetchPostVarVal_S( idx : longword; Security : integer) : pastr');
 CL.AddDelphiFunction('Function IsPostVar( const name : pastr) : boolean');
 CL.AddDelphiFunction('Function CountAny : longword');
 CL.AddDelphiFunction('Function GetAny( const name : pastr) : pastr;');
 CL.AddDelphiFunction('Function GetAny1( const name : pastr; filter : TFilterFunc) : pastr;');
 CL.AddDelphiFunction('Function GetAny_S( const name : pastr; Security : integer) : pastr');
 CL.AddDelphiFunction('Function GetAnyAsFloat( const name : pastr) : double');
 CL.AddDelphiFunction('Function GetAnyAsInt( const name : pastr) : longint');
 CL.AddDelphiFunction('Function IsAny( const name : pastr) : byte');
 CL.AddDelphiFunction('Function CountCookies : longword');
 CL.AddDelphiFunction('Function FetchCookieName( idx : longword) : pastr');
 CL.AddDelphiFunction('Function FetchCookieVal( idx : longword) : pastr;');
 CL.AddDelphiFunction('Function FetchCookieVal1( idx : longword; filter : TFilterFunc) : pastr;');
 CL.AddDelphiFunction('Function GetCookie( const name : pastr) : pastr;');
 CL.AddDelphiFunction('Function GetCookie1( const name : pastr; filter : TFilterFunc) : pastr;');
 CL.AddDelphiFunction('Function GetCookieAsFloat( const name : pastr) : double');
 CL.AddDelphiFunction('Function GetCookieAsInt( const name : pastr) : longint');
 CL.AddDelphiFunction('Function IsCookie( const name : pastr) : boolean');
 CL.AddDelphiFunction('Function SetCookie( const name, value : pastr) : boolean');
 CL.AddDelphiFunction('Function SetCookieAsFloat( const name : pastr; value : double) : boolean');
 CL.AddDelphiFunction('Function SetCookieAsInt( const name : pastr; value : longint) : boolean');
 CL.AddDelphiFunction('Function SetCookieEx( const name, value, path, domain, expiry : pastr) : boolean');
 CL.AddDelphiFunction('Function SetCookieAsFloatEx( const name : pastr; value : double; const path, domain, expiry : pastr) : boolean');
 CL.AddDelphiFunction('Function SetCookieAsIntEx( const name : pastr; value : longint; const path, domain, expiry : pastr) : boolean');
 CL.AddDelphiFunction('Function UnsetCookie( const name : pastr) : boolean');
 CL.AddDelphiFunction('Function UnsetCookieEx( const name, path, domain : pastr) : boolean');
 CL.AddDelphiFunction('Function FilterHtml( const input : pastr) : pastr');
 CL.AddDelphiFunction('Function FilterHtml_S( const input : pastr; security : integer) : pastr');
 CL.AddDelphiFunction('Function TrimBadChars( const input : pastr) : pastr');
 CL.AddDelphiFunction('Function TrimBadFile( const input : pastr) : pastr');
 CL.AddDelphiFunction('Function TrimBadDir( const input : pastr) : pastr');
 CL.AddDelphiFunction('Function TrimBad_S( const input : pastr; security : integer) : pastr');
 CL.AddDelphiFunction('Function CountHeaders : longword');
 CL.AddDelphiFunction('Function FetchHeaderName( idx : longword) : pastr');
 CL.AddDelphiFunction('Function FetchHeaderVal( idx : longword) : pastr');
 CL.AddDelphiFunction('Function GetHeader( const name : pastr) : pastr');
 CL.AddDelphiFunction('Function IsHeader( const name : pastr) : boolean');
 CL.AddDelphiFunction('Function SetHeader( const name, value : pastr) : boolean');
 CL.AddDelphiFunction('Function UnsetHeader( const name : pastr) : boolean');
 CL.AddDelphiFunction('Function PutHeader( const header : pastr) : boolean');
 CL.AddDelphiFunction('Procedure Out1( const s : pastr)');
 CL.AddDelphiFunction('Procedure OutLn( const s : pastr)');
 CL.AddDelphiFunction('Procedure OutA( args : array of const)');
 CL.AddDelphiFunction('Procedure OutF( const s : pastr)');
 CL.AddDelphiFunction('Procedure OutLnF( const s : pastr)');
 CL.AddDelphiFunction('Procedure OutFF( const s : pastr)');
 CL.AddDelphiFunction('Procedure OutF_FI( const s : pastr; HTMLFilter : boolean)');
 CL.AddDelphiFunction('Procedure OutLnFF( const s : pastr)');
 CL.AddDelphiFunction('Procedure OutLnF_FI( const s : pastr; HTMLFilter : boolean)');
 CL.AddDelphiFunction('Function FileOut( const fname : pastr) : word');
 CL.AddDelphiFunction('Function ResourceOut( const fname : pastr) : word');
 CL.AddDelphiFunction('Procedure BufferOut( const buff, len : LongWord)');
 CL.AddDelphiFunction('Function TemplateOut( const fname : pastr; HtmlFilter : boolean) : word;');
 CL.AddDelphiFunction('Function TemplateOut1( const fname : pastr) : word;');
 CL.AddDelphiFunction('Function TemplateOut2( const fname : pastr; filter : TFilterFunc) : word;');
 CL.AddDelphiFunction('Function TemplateOut3( const fname : pastr; HtmlFilter : boolean) : word;');
 CL.AddDelphiFunction('Function TemplateRaw( const fname : pastr) : word');
 CL.AddDelphiFunction('Function Fmt( const s : pastr) : pastr;');
 CL.AddDelphiFunction('Function Fmt1( const s : pastr; filter : TFilterFunc) : pastr;');
 CL.AddDelphiFunction('Function FmtFilter( const s : pastr) : pastr');
 CL.AddDelphiFunction('Function Fmt_SF( const s : pastr; HTMLFilter : boolean; filter : TFilterFunc; FilterSecurity, TrimSecurity : integer) : pastr;');
 CL.AddDelphiFunction('Function Fmt_SF1( const s : pastr; HTMLFilter : boolean; FilterSecurity, TrimSecurity : integer) : pastr;');
 CL.AddDelphiFunction('Function CountRtiVars : longword');
 CL.AddDelphiFunction('Function FetchRtiName( idx : longword) : pastr');
 CL.AddDelphiFunction('Function FetchRtiVal( idx : longword) : pastr');
 CL.AddDelphiFunction('Function GetRti( const name : pastr) : pastr');
 CL.AddDelphiFunction('Function GetRtiAsFloat( const name : pastr) : double');
 CL.AddDelphiFunction('Function GetRtiAsInt( const name : pastr) : longint');
 CL.AddDelphiFunction('Function IsRti( const name : pastr) : boolean');
 CL.AddDelphiFunction('Procedure SetRTI( const name, value : pastr)');
 CL.AddDelphiFunction('Function FetchUpfileName( idx : longword) : pastr');
 CL.AddDelphiFunction('Function GetUpfileName( const name : pastr) : pastr');
 CL.AddDelphiFunction('Function GetUpfileSize( const name : pastr) : longint');
 CL.AddDelphiFunction('Function GetUpfileType( const name : pastr) : pastr');
 CL.AddDelphiFunction('Function CountUpfiles : longword');
 CL.AddDelphiFunction('Function IsUpfile( const name : pastr) : boolean');
 CL.AddDelphiFunction('Function SaveUpfile( const name, fname : pastr) : boolean');
 CL.AddDelphiFunction('Function CountVars : longword');
 CL.AddDelphiFunction('Function FetchVarName( idx : longword) : pastr');
 CL.AddDelphiFunction('Function FetchVarVal( idx : longword) : pastr;');
 CL.AddDelphiFunction('Function FetchVarVal1( idx : longword; filter : TFilterFunc) : pastr;');
 CL.AddDelphiFunction('Function GetVar( const name : pastr) : pastr;');
 CL.AddDelphiFunction('Function GetVar1( const name : pastr; filter : TFilterFunc) : pastr;');
 CL.AddDelphiFunction('Function GetVar_S( const name : pastr; security : integer) : pastr');
 CL.AddDelphiFunction('Function GetVarAsFloat( const name : pastr) : double');
 CL.AddDelphiFunction('Function GetVarAsInt( const name : pastr) : longint');
 CL.AddDelphiFunction('Procedure SetVar( const name, value : pastr)');
 CL.AddDelphiFunction('Procedure SetVarAsFloat( const name : pastr; value : double)');
 CL.AddDelphiFunction('Procedure SetVarAsInt( const name : pastr; value : longint)');
 CL.AddDelphiFunction('Function IsVar( const name : pastr) : byte');
 CL.AddDelphiFunction('Procedure UnsetVar( const name : pastr)');
 CL.AddDelphiFunction('Function LineEndToBR( const s : pastr) : pastr');
 CL.AddDelphiFunction('Function RandomStr( len : longint) : pastr');
 CL.AddDelphiFunction('Function XorCrypt( const s : pastr; key : byte) : pastr');
 CL.AddDelphiFunction('Function CountCfgVars : longword');
 CL.AddDelphiFunction('Function FetchCfgVarName( idx : longword) : pastr');
 CL.AddDelphiFunction('Function FetchCfgVarVal( idx : longword) : pastr');
 CL.AddDelphiFunction('Function IsCfgVar( const name : pastr) : boolean');
 CL.AddDelphiFunction('Function SetCfgVar( const name, value : pastr) : boolean');
 CL.AddDelphiFunction('Function GetCfgVar( const name : pastr) : pastr');
 CL.AddDelphiFunction('Procedure ThrowErr( const s : pastr)');
 CL.AddDelphiFunction('Procedure ThrowWarn( const s : pastr)');
 CL.AddDelphiFunction('Procedure ErrWithHeader( const s : pastr)');
  CL.AddTypeS('TWebVar', 'record name : pastr; value : pastr; end');
  CL.AddTypeS('TWebVars', 'array of TWebVar');
 CL.AddDelphiFunction('Function iUpdateWebVar( var webv : TWebVars; const name, value : pastr; upcased : boolean) : boolean');
 CL.AddDelphiFunction('Function iAddWebCfgVar( const name, value : pastr) : boolean');
 CL.AddDelphiFunction('Procedure iAddWebVar( var webv : TWebVars; const name, value : pastr)');
 CL.AddDelphiFunction('Procedure iSetRTI( const name, value : pastr)');
 CL.AddDelphiFunction('Function iCustomSessUnitSet : boolean');
 CL.AddDelphiFunction('Function iCustomCfgUnitSet : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function GetVar1_P( const name : astr; filter : TFilterFunc) : astr;
Begin Result := pwmain.GetVar(name, filter); END;

(*----------------------------------------------------------------------------*)
Function GetVar_P( const name : astr) : astr;
Begin Result := pwmain.GetVar(name); END;

(*----------------------------------------------------------------------------*)
Function FetchVarVal1_P( idx : longword; filter : TFilterFunc) : astr;
Begin Result := pwmain.FetchVarVal(idx, filter); END;

(*----------------------------------------------------------------------------*)
Function FetchVarVal_P( idx : longword) : astr;
Begin Result := pwmain.FetchVarVal(idx); END;

(*----------------------------------------------------------------------------*)
Function Fmt_SF1_P( const s : astr; HTMLFilter : bln; FilterSecurity, TrimSecurity : integer) : astr;
Begin Result := pwmain.Fmt_SF(s, HTMLFilter, FilterSecurity, TrimSecurity); END;

(*----------------------------------------------------------------------------*)
Function Fmt_SF_P( const s : astr; HTMLFilter : bln; filter : TFilterFunc; FilterSecurity, TrimSecurity : integer) : astr;
Begin Result := pwmain.Fmt_SF(s, HTMLFilter, filter, FilterSecurity, TrimSecurity); END;

(*----------------------------------------------------------------------------*)
Function Fmt1_P( const s : astr; filter : TFilterFunc) : astr;
Begin Result := pwmain.Fmt(s, filter); END;

(*----------------------------------------------------------------------------*)
Function Fmt_P( const s : astr) : astr;
Begin Result := pwmain.Fmt(s); END;

(*----------------------------------------------------------------------------*)
Function TemplateOut3_P( const fname : astr; HtmlFilter : bln) : errcode;
Begin Result := pwmain.TemplateOut1(fname, HtmlFilter); END;

(*----------------------------------------------------------------------------*)
Function TemplateOut2_P( const fname : astr; filter : TFilterFunc) : errcode;
Begin Result := pwmain.TemplateOut(fname, filter); END;

(*----------------------------------------------------------------------------*)
Function TemplateOut1_P( const fname : astr) : errcode;
Begin Result := pwmain.TemplateOut(fname); END;

(*----------------------------------------------------------------------------*)
Function TemplateOut_P( const fname : astr; HtmlFilter : bln) : errcode;
Begin Result := pwmain.TemplateOut(fname, HtmlFilter); END;

(*----------------------------------------------------------------------------*)
Function GetCookie1_P( const name : astr; filter : TFilterFunc) : astr;
Begin Result := pwmain.GetCookie(name, filter); END;

(*----------------------------------------------------------------------------*)
Function GetCookie_P( const name : astr) : astr;
Begin Result := pwmain.GetCookie(name); END;

(*----------------------------------------------------------------------------*)
Function FetchCookieVal1_P( idx : longword; filter : TFilterFunc) : astr;
Begin Result := pwmain.FetchCookieVal(idx, filter); END;

(*----------------------------------------------------------------------------*)
Function FetchCookieVal_P( idx : longword) : astr;
Begin Result := pwmain.FetchCookieVal(idx); END;

(*----------------------------------------------------------------------------*)
Function GetAny1_P( const name : astr; filter : TFilterFunc) : astr;
Begin Result := pwmain.GetAny(name, filter); END;

(*----------------------------------------------------------------------------*)
Function GetAny_P( const name : astr) : astr;
Begin Result := pwmain.GetAny(name); END;

(*----------------------------------------------------------------------------*)
Function FetchPostVarVal1_P( idx : longword; filter : TFilterFunc) : astr;
Begin Result := pwmain.FetchPostVarVal(idx, filter); END;

(*----------------------------------------------------------------------------*)
Function FetchPostVarVal_P( idx : longword) : astr;
Begin Result := pwmain.FetchPostVarVal(idx); END;

(*----------------------------------------------------------------------------*)
Function GetPostVar1_P( const name : astr; filter : TFilterFunc) : astr;
Begin Result := pwmain.GetPostVar(name, filter); END;

(*----------------------------------------------------------------------------*)
Function GetPostVar_P( const name : astr) : astr;
Begin Result := pwmain.GetPostVar(name); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_pwmain_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Init, 'pwInit', cdRegister);
 S.RegisterDelphiFunction(@OffReadln, 'OffReadln', cdRegister);
 S.RegisterDelphiFunction(@Lcase, 'Lcase', cdRegister);
 S.RegisterDelphiFunction(@Ucase, 'Ucase', cdRegister);
 S.RegisterDelphiFunction(@CountPostVars, 'CountPostVars', cdRegister);
 S.RegisterDelphiFunction(@GetPostVar, 'GetPostVar', cdRegister);
 S.RegisterDelphiFunction(@GetPostVar1_P, 'GetPostVar1', cdRegister);
 S.RegisterDelphiFunction(@GetPostVar_S, 'GetPostVar_S', cdRegister);
 S.RegisterDelphiFunction(@GetPostVar_SF, 'GetPostVar_SF', cdRegister);
 S.RegisterDelphiFunction(@GetPostVarAsFloat, 'GetPostVarAsFloat', cdRegister);
 S.RegisterDelphiFunction(@GetPostVarAsInt, 'GetPostVarAsInt', cdRegister);
 S.RegisterDelphiFunction(@GetPostVar_SafeHTML, 'GetPostVar_SafeHTML', cdRegister);
 S.RegisterDelphiFunction(@FetchPostVarName, 'FetchPostVarName', cdRegister);
 S.RegisterDelphiFunction(@FetchPostVarVal, 'FetchPostVarVal', cdRegister);
 S.RegisterDelphiFunction(@FetchPostVarVal1_P, 'FetchPostVarVal1', cdRegister);
 S.RegisterDelphiFunction(@FetchPostVarName_S, 'FetchPostVarName_S', cdRegister);
 S.RegisterDelphiFunction(@FetchPostVarVal_S, 'FetchPostVarVal_S', cdRegister);
 S.RegisterDelphiFunction(@IsPostVar, 'IsPostVar', cdRegister);
 S.RegisterDelphiFunction(@CountAny, 'CountAny', cdRegister);
 S.RegisterDelphiFunction(@GetAny, 'GetAny', cdRegister);
 S.RegisterDelphiFunction(@GetAny1_P, 'GetAny1', cdRegister);
 S.RegisterDelphiFunction(@GetAny_S, 'GetAny_S', cdRegister);
 S.RegisterDelphiFunction(@GetAnyAsFloat, 'GetAnyAsFloat', cdRegister);
 S.RegisterDelphiFunction(@GetAnyAsInt, 'GetAnyAsInt', cdRegister);
 S.RegisterDelphiFunction(@IsAny, 'IsAny', cdRegister);
 S.RegisterDelphiFunction(@CountCookies, 'CountCookies', cdRegister);
 S.RegisterDelphiFunction(@FetchCookieName, 'FetchCookieName', cdRegister);
 S.RegisterDelphiFunction(@FetchCookieVal, 'FetchCookieVal', cdRegister);
 S.RegisterDelphiFunction(@FetchCookieVal1_P, 'FetchCookieVal1', cdRegister);
 S.RegisterDelphiFunction(@GetCookie, 'GetCookie', cdRegister);
 S.RegisterDelphiFunction(@GetCookie1_P, 'GetCookie1', cdRegister);
 S.RegisterDelphiFunction(@GetCookieAsFloat, 'GetCookieAsFloat', cdRegister);
 S.RegisterDelphiFunction(@GetCookieAsInt, 'GetCookieAsInt', cdRegister);
 S.RegisterDelphiFunction(@IsCookie, 'IsCookie', cdRegister);
 S.RegisterDelphiFunction(@SetCookie, 'SetCookie', cdRegister);
 S.RegisterDelphiFunction(@SetCookieAsFloat, 'SetCookieAsFloat', cdRegister);
 S.RegisterDelphiFunction(@SetCookieAsInt, 'SetCookieAsInt', cdRegister);
 S.RegisterDelphiFunction(@SetCookieEx, 'SetCookieEx', cdRegister);
 S.RegisterDelphiFunction(@SetCookieAsFloatEx, 'SetCookieAsFloatEx', cdRegister);
 S.RegisterDelphiFunction(@SetCookieAsIntEx, 'SetCookieAsIntEx', cdRegister);
 S.RegisterDelphiFunction(@UnsetCookie, 'UnsetCookie', cdRegister);
 S.RegisterDelphiFunction(@UnsetCookieEx, 'UnsetCookieEx', cdRegister);
 S.RegisterDelphiFunction(@FilterHtml, 'FilterHtml', cdRegister);
 S.RegisterDelphiFunction(@FilterHtml_S, 'FilterHtml_S', cdRegister);
 S.RegisterDelphiFunction(@TrimBadChars, 'TrimBadChars', cdRegister);
 S.RegisterDelphiFunction(@TrimBadFile, 'TrimBadFile', cdRegister);
 S.RegisterDelphiFunction(@TrimBadDir, 'TrimBadDir', cdRegister);
 S.RegisterDelphiFunction(@TrimBad_S, 'TrimBad_S', cdRegister);
 S.RegisterDelphiFunction(@CountHeaders, 'CountHeaders', cdRegister);
 S.RegisterDelphiFunction(@FetchHeaderName, 'FetchHeaderName', cdRegister);
 S.RegisterDelphiFunction(@FetchHeaderVal, 'FetchHeaderVal', cdRegister);
 S.RegisterDelphiFunction(@GetHeader, 'GetHeader', cdRegister);
 S.RegisterDelphiFunction(@IsHeader, 'IsHeader', cdRegister);
 S.RegisterDelphiFunction(@SetHeader, 'SetHeader', cdRegister);
 S.RegisterDelphiFunction(@UnsetHeader, 'UnsetHeader', cdRegister);
 S.RegisterDelphiFunction(@PutHeader, 'PutHeader', cdRegister);
 //S.RegisterDelphiFunction(@Out, 'Out1', cdRegister);
 S.RegisterDelphiFunction(@OutLn, 'OutLn', cdRegister);
 S.RegisterDelphiFunction(@OutA, 'OutA', cdRegister);
 S.RegisterDelphiFunction(@OutF, 'OutF', cdRegister);
 S.RegisterDelphiFunction(@OutLnF, 'OutLnF', cdRegister);
 S.RegisterDelphiFunction(@OutFF, 'OutFF', cdRegister);
 S.RegisterDelphiFunction(@OutF_FI, 'OutF_FI', cdRegister);
 S.RegisterDelphiFunction(@OutLnFF, 'OutLnFF', cdRegister);
 S.RegisterDelphiFunction(@OutLnF_FI, 'OutLnF_FI', cdRegister);
 S.RegisterDelphiFunction(@FileOut, 'FileOut', cdRegister);
 S.RegisterDelphiFunction(@ResourceOut, 'ResourceOut', cdRegister);
 S.RegisterDelphiFunction(@BufferOut, 'BufferOut', cdRegister);
 S.RegisterDelphiFunction(@TemplateOut, 'TemplateOut', cdRegister);
 S.RegisterDelphiFunction(@TemplateOut1, 'TemplateOut1', cdRegister);
 S.RegisterDelphiFunction(@TemplateOut2_P, 'TemplateOut2', cdRegister);
 S.RegisterDelphiFunction(@TemplateOut3_P, 'TemplateOut3', cdRegister);
 S.RegisterDelphiFunction(@TemplateRaw, 'TemplateRaw', cdRegister);
 S.RegisterDelphiFunction(@Fmt, 'Fmt', cdRegister);
 S.RegisterDelphiFunction(@Fmt1_P, 'Fmt1', cdRegister);
 S.RegisterDelphiFunction(@FmtFilter, 'FmtFilter', cdRegister);
 S.RegisterDelphiFunction(@Fmt_SF, 'Fmt_SF', cdRegister);
 S.RegisterDelphiFunction(@Fmt_SF1_P, 'Fmt_SF1', cdRegister);
 S.RegisterDelphiFunction(@CountRtiVars, 'CountRtiVars', cdRegister);
 S.RegisterDelphiFunction(@FetchRtiName, 'FetchRtiName', cdRegister);
 S.RegisterDelphiFunction(@FetchRtiVal, 'FetchRtiVal', cdRegister);
 S.RegisterDelphiFunction(@GetRti, 'GetRti', cdRegister);
 S.RegisterDelphiFunction(@GetRtiAsFloat, 'GetRtiAsFloat', cdRegister);
 S.RegisterDelphiFunction(@GetRtiAsInt, 'GetRtiAsInt', cdRegister);
 S.RegisterDelphiFunction(@IsRti, 'IsRti', cdRegister);
 S.RegisterDelphiFunction(@SetRTI, 'SetRTI', cdRegister);
 S.RegisterDelphiFunction(@FetchUpfileName, 'FetchUpfileName', cdRegister);
 S.RegisterDelphiFunction(@GetUpfileName, 'GetUpfileName', cdRegister);
 S.RegisterDelphiFunction(@GetUpfileSize, 'GetUpfileSize', cdRegister);
 S.RegisterDelphiFunction(@GetUpfileType, 'GetUpfileType', cdRegister);
 S.RegisterDelphiFunction(@CountUpfiles, 'CountUpfiles', cdRegister);
 S.RegisterDelphiFunction(@IsUpfile, 'IsUpfile', cdRegister);
 S.RegisterDelphiFunction(@SaveUpfile, 'SaveUpfile', cdRegister);
 S.RegisterDelphiFunction(@CountVars, 'CountVars', cdRegister);
 S.RegisterDelphiFunction(@FetchVarName, 'FetchVarName', cdRegister);
 S.RegisterDelphiFunction(@FetchVarVal, 'FetchVarVal', cdRegister);
 S.RegisterDelphiFunction(@FetchVarVal1_P, 'FetchVarVal1', cdRegister);
 S.RegisterDelphiFunction(@GetVar, 'GetVar', cdRegister);
 S.RegisterDelphiFunction(@GetVar1_P, 'GetVar1', cdRegister);
 S.RegisterDelphiFunction(@GetVar_S, 'GetVar_S', cdRegister);
 S.RegisterDelphiFunction(@GetVarAsFloat, 'GetVarAsFloat', cdRegister);
 S.RegisterDelphiFunction(@GetVarAsInt, 'GetVarAsInt', cdRegister);
 S.RegisterDelphiFunction(@SetVar, 'SetVar', cdRegister);
 S.RegisterDelphiFunction(@SetVarAsFloat, 'SetVarAsFloat', cdRegister);
 S.RegisterDelphiFunction(@SetVarAsInt, 'SetVarAsInt', cdRegister);
 S.RegisterDelphiFunction(@IsVar, 'IsVar', cdRegister);
 S.RegisterDelphiFunction(@UnsetVar, 'UnsetVar', cdRegister);
 S.RegisterDelphiFunction(@LineEndToBR, 'LineEndToBR', cdRegister);
 S.RegisterDelphiFunction(@RandomStr, 'RandomStr', cdRegister);
 S.RegisterDelphiFunction(@XorCrypt, 'XorCrypt', cdRegister);
 S.RegisterDelphiFunction(@CountCfgVars, 'CountCfgVars', cdRegister);
 S.RegisterDelphiFunction(@FetchCfgVarName, 'FetchCfgVarName', cdRegister);
 S.RegisterDelphiFunction(@FetchCfgVarVal, 'FetchCfgVarVal', cdRegister);
 S.RegisterDelphiFunction(@IsCfgVar, 'IsCfgVar', cdRegister);
 S.RegisterDelphiFunction(@SetCfgVar, 'SetCfgVar', cdRegister);
 S.RegisterDelphiFunction(@GetCfgVar, 'GetCfgVar', cdRegister);
 S.RegisterDelphiFunction(@ThrowErr, 'ThrowErr', cdRegister);
 S.RegisterDelphiFunction(@ThrowWarn, 'ThrowWarn', cdRegister);
 S.RegisterDelphiFunction(@ErrWithHeader, 'ErrWithHeader', cdRegister);
 S.RegisterDelphiFunction(@iUpdateWebVar, 'iUpdateWebVar', cdRegister);
 S.RegisterDelphiFunction(@iAddWebCfgVar, 'iAddWebCfgVar', cdRegister);
 S.RegisterDelphiFunction(@iAddWebVar, 'iAddWebVar', cdRegister);
 S.RegisterDelphiFunction(@iSetRTI, 'iSetRTI', cdRegister);
 S.RegisterDelphiFunction(@iCustomSessUnitSet, 'iCustomSessUnitSet', cdRegister);
 S.RegisterDelphiFunction(@iCustomCfgUnitSet, 'iCustomCfgUnitSet', cdRegister);
end;

 
 
{ TPSImport_pwmain }
(*----------------------------------------------------------------------------*)
procedure TPSImport_pwmain.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_pwmain(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_pwmain.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_pwmain(ri);
  RIRegister_pwmain_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
