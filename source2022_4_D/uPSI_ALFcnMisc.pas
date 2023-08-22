unit uPSI_ALFcnMisc;
{
  base func functor   getstrasutf8
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
  TPSImport_ALFcnMisc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ALFcnMisc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALFcnMisc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   ALFcnMisc, types; //, windows;


{*******************************************************************************************}
function  ALRandomStr1(const aLength: Longint; const aCharset: Array of ansiChar): AnsiString;
var X: Longint;
begin
  if aLength <= 0 then exit;
  SetLength(Result, aLength);
  for X:=1 to aLength do Result[X] := aCharset[Random(length(aCharset))];
end;

{*******************************************************}
function ALRandomStr(const aLength: Longint): AnsiString;
begin
  Result:= ALRandomStr1(aLength,['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']);
end;

{************************************************************************************}
function  ALRandomStrU1(const aLength: Longint; const aCharset: Array of Char): String;
var X: Longint;
   //sc: TChararray;
begin
  if aLength <= 0 then exit;
  SetLength(Result, aLength);
  for X:=1 to aLength do Result[X] := aCharset[Random(length(aCharset))];
end;

{****************************************************}
function ALRandomStrU(const aLength: Longint): String;
begin
  Result:= ALRandomStrU1(aLength,['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']);
end;

const
  CP_UTF8_2 = 65001;

{function GetStringAsUtf8(S: string): AnsiString;
var
  Len: Integer;
begin
  Len:= WideCharToMultiByte(CP_UTF8, 0, S, Length(S), Result,0,0,0);
  SetLength(Result, Len);
  WideCharToMultiByte(CP_UTF8, 0, S, Length(S), Result, Len,0,0);
end;  }
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALFcnMisc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ALFcnMisc(CL: TPSPascalCompiler);
begin

 //CL.AddConstantN('LETTERARRAY','array of char').SetString('ABCD');
  //of char'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O')+
    // (,'P','Q','R','S','T','U','V','W','X','Y','Z');
 //Const('LETTERSET','String').SetString('ABCDEFGHIJKLMNOPQRSTUVWXYZ');

 CL.AddDelphiFunction('Function AlBoolToInt( Value : Boolean) : Integer');
 CL.AddDelphiFunction('Function ALMediumPos( LTotal, LBorder, LObject : integer) : Integer');
 CL.AddDelphiFunction('Function AlIsValidEmail( const Value : AnsiString) : boolean');
 CL.AddDelphiFunction('Function AlLocalDateTimeToGMTDateTime( const aLocalDateTime : TDateTime) : TdateTime');
 CL.AddDelphiFunction('Function ALInc( var x : integer; Count : integer) : Integer');
 CL.AddDelphiFunction('function ALCopyStr(const aSourceString: AnsiString; aStart, aLength: Integer): AnsiString');
 CL.AddDelphiFunction('function ALGetStringFromFile(filename: AnsiString; const ShareMode: Word): AnsiString;');
 CL.AddDelphiFunction('procedure ALSaveStringtoFile(Str: AnsiString; filename: AnsiString);');
 //CL.AddDelphiFunction('procedure GetStringAsUtf8(S: string): AnsiString;');

  CL.AddDelphiFunction('Function ALIsInteger(const S: AnsiString): Boolean;');
 CL.AddDelphiFunction('function ALIsDecimal(const S: AnsiString): boolean;');
 CL.AddDelphiFunction('Function ALStringToWideString(const S: AnsiString; const aCodePage: Word): WideString;');
 CL.AddDelphiFunction('function AlWideStringToString(const WS: WideString; const aCodePage: Word): AnsiString;');

 CL.AddDelphiFunction('function ALGUIDToString(const Guid: TGUID): Ansistring;');
 CL.AddDelphiFunction('Function ALMakeKeyStrByGUID: AnsiString;');
 CL.AddDelphiFunction('Function ALGetCodePageFromCharSetName(Acharset:AnsiString): Word;');
 CL.AddDelphiFunction('Function ALUTF8Encode(const S: AnsiString; const aCodePage: Word): AnsiString;');
 CL.AddDelphiFunction('Function ALUTF8decode(const S: AnsiString; const aCodePage: Word): AnsiString;');
 CL.AddDelphiFunction('function ALQuotedStr(const S: AnsiString; const Quote: Char): AnsiString;');
 CL.AddDelphiFunction('function ALDequotedStr(const S: AnsiString; AQuote: Char): AnsiString;');
 CL.AddDelphiFunction('function  AlUTF8removeBOM(const S: AnsiString): AnsiString;');

//  tchararray
 CL.AddDelphiFunction('function ALRandomStr1(const aLength: Longint; const aCharset: Array of Char): AnsiString;');
 CL.AddDelphiFunction('function ALRandomStr(const aLength: Longint): String;');
 CL.AddDelphiFunction('function ALRandomStrU1(const aLength: Longint; const aCharset: Array of Char): String;');
 CL.AddDelphiFunction('function ALRandomStrU(const aLength: Longint): String;');

// CL.AddDelphiFunction('ALRandomStr(const aLength: Longint; const aCharset: Array of ansiChar): AnsiString;');

  end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ALFcnMisc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AlBoolToInt, 'AlBoolToInt', cdRegister);
 S.RegisterDelphiFunction(@ALMediumPos, 'ALMediumPos', cdRegister);
 S.RegisterDelphiFunction(@AlIsValidEmail, 'AlIsValidEmail', cdRegister);
 S.RegisterDelphiFunction(@AlLocalDateTimeToGMTDateTime, 'AlLocalDateTimeToGMTDateTime', cdRegister);
 S.RegisterDelphiFunction(@ALInc, 'ALInc', cdRegister);
 S.RegisterDelphiFunction(@ALCopyStr, 'ALCopyStr', cdRegister);
 S.RegisterDelphiFunction(@ALGetStringFromFile, 'ALGetStringFromFile', cdRegister);
 S.RegisterDelphiFunction(@ALSaveStringtoFile, 'ALSaveStringtoFile', cdRegister);
 S.RegisterDelphiFunction(@ALIsInteger, 'ALIsInteger', cdRegister);
 S.RegisterDelphiFunction(@ALIsDecimal, 'ALIsDecimal', cdRegister);
 S.RegisterDelphiFunction(@ALStringToWideString, 'ALStringToWideString', cdRegister);
 S.RegisterDelphiFunction(@AlWideStringToString, 'AlWideStringToString', cdRegister);

 S.RegisterDelphiFunction(@ALGUIDToString, 'ALGUIDToString', cdRegister);
 S.RegisterDelphiFunction(@ALMakeKeyStrByGUID, 'ALMakeKeyStrByGUID', cdRegister);
 S.RegisterDelphiFunction(@ALGetCodePageFromCharSetName, 'ALGetCodePageFromCharSetName', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8Encode, 'ALUTF8Encode', cdRegister);
 S.RegisterDelphiFunction(@ALUTF8decode, 'ALUTF8decode', cdRegister);
 S.RegisterDelphiFunction(@ALQuotedStr, 'ALQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@ALDequotedStr, 'ALDequotedStr', cdRegister);

 S.RegisterDelphiFunction(@ALRandomStr, 'ALRandomStr', cdRegister);
 S.RegisterDelphiFunction(@ALRandomStr1, 'ALRandomStr1', cdRegister);
 S.RegisterDelphiFunction(@ALRandomStrU, 'ALRandomStrU', cdRegister);
 S.RegisterDelphiFunction(@ALRandomStrU1, 'ALRandomStrU1', cdRegister);
 //S.RegisterDelphiFunction(@GetStringAsUtf8, 'GetStringAsUtf8', cdRegister);

 //GetStringAsUtf8(S: string): AnsiString;


{ function  ALRandomStr(const aLength: Longint; const aCharset: Array of ansiChar): AnsiString; overload;
function  ALRandomStr(const aLength: Longint): AnsiString; overload;
function  ALRandomStrU(const aLength: Longint; const aCharset: Array of Char): String; overload;
function  ALRandomStrU(const aLength: Longint): String; overload;}


//function  ALQuotedStr(const S: AnsiString; const Quote: AnsiChar = ''''): AnsiString;
//function  ALDequotedStr(const S: AnsiString; AQuote: AnsiChar): AnsiString;

 end;

 
 
{ TPSImport_ALFcnMisc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnMisc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALFcnMisc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALFcnMisc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ALFcnMisc(ri);
  RIRegister_ALFcnMisc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
