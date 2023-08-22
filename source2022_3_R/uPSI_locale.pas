unit uPSI_locale;
{
as long i can the ban  getcharencoding

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
  TPSImport_locale = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_locale(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_locale_Routines(S: TPSExec);

procedure Register;

implementation


uses
   {dpautils
  ,vpautils
  ,fpautils
  ,gpautils
  ,tpautils }
 locale
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_locale]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_locale(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function GetISODateString( Year, Month, Day : Word) : string');
 CL.AddDelphiFunction('Function GetISODateStringBasic( Year, Month, Day : Word) : string');
 CL.AddDelphiFunction('Function IsValidISODateString( datestr : string; strict : boolean) : boolean');
 CL.AddDelphiFunction('Function IsValidISODateStringExt( datestr : string; strict : boolean; var Year, Month, Day : word) : boolean');
 CL.AddDelphiFunction('Function IsValidISOTimeString( timestr : string; strict : boolean) : boolean');
 CL.AddDelphiFunction('Function IsValidISOTimeStringExt( timestr : string; strict : boolean; var hour, min, sec : word; var offhour, offmin : smallint) : boolean');
 CL.AddDelphiFunction('Function IsValidISODateTimeString( str : string; strict : boolean) : boolean');
 CL.AddDelphiFunction('Function GetISOTimeString( Hour, Minute, Second : Word; UTC : Boolean) : string');
 CL.AddDelphiFunction('Function GetISOTimeStringBasic( Hour, Minute, Second : Word; UTC : Boolean) : string');
 CL.AddDelphiFunction('Function GetISODateTimeString( Year, Month, Day, Hour, Minute, Second : Word; UTC : Boolean) : string');
 CL.AddDelphiFunction('Procedure UNIXToDateTime2( epoch : big_integer_t; var year, month, day, hour, minute, second : Word)');
 CL.AddDelphiFunction('Function GetCharEncoding( alias : string; var _name : string) : integer');
 CL.AddDelphiFunction('Function MicrosoftCodePageToMIMECharset( cp : word) : string');
 CL.AddDelphiFunction('Function MicrosoftLangageCodeToISOCode( langcode : integer) : string');
 CL.AddConstantN('CHAR_ENCODING_UTF8','LongInt').SetInt( 0);
 CL.AddConstantN('CHAR_ENCODING_UNKNOWN','LongInt').SetInt( - 1);
 CL.AddConstantN('CHAR_ENCODING_UTF32BE','LongInt').SetInt( 1);
 CL.AddConstantN('CHAR_ENCODING_UTF32LE','LongInt').SetInt( 2);
 CL.AddConstantN('CHAR_ENCODING_UTF16LE','LongInt').SetInt( 3);
 CL.AddConstantN('CHAR_ENCODING_UTF16BE','LongInt').SetInt( 4);
 CL.AddConstantN('CHAR_ENCODING_BYTE','LongInt').SetInt( 5);
 CL.AddConstantN('CHAR_ENCODING_UTF16','LongInt').SetInt( 6);
 CL.AddConstantN('CHAR_ENCODING_UTF32','LongInt').SetInt( 7);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_locale_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetISODateString, 'GetISODateString', cdRegister);
 S.RegisterDelphiFunction(@GetISODateStringBasic, 'GetISODateStringBasic', cdRegister);
 S.RegisterDelphiFunction(@IsValidISODateString, 'IsValidISODateString', cdRegister);
 S.RegisterDelphiFunction(@IsValidISODateStringExt, 'IsValidISODateStringExt', cdRegister);
 S.RegisterDelphiFunction(@IsValidISOTimeString, 'IsValidISOTimeString', cdRegister);
 S.RegisterDelphiFunction(@IsValidISOTimeStringExt, 'IsValidISOTimeStringExt', cdRegister);
 S.RegisterDelphiFunction(@IsValidISODateTimeString, 'IsValidISODateTimeString', cdRegister);
 S.RegisterDelphiFunction(@GetISOTimeString, 'GetISOTimeString', cdRegister);
 S.RegisterDelphiFunction(@GetISOTimeStringBasic, 'GetISOTimeStringBasic', cdRegister);
 S.RegisterDelphiFunction(@GetISODateTimeString, 'GetISODateTimeString', cdRegister);
 S.RegisterDelphiFunction(@UNIXToDateTime, 'UNIXToDateTime2', cdRegister);
 S.RegisterDelphiFunction(@GetCharEncoding, 'GetCharEncoding', cdRegister);
 S.RegisterDelphiFunction(@MicrosoftCodePageToMIMECharset, 'MicrosoftCodePageToMIMECharset', cdRegister);
 S.RegisterDelphiFunction(@MicrosoftLangageCodeToISOCode, 'MicrosoftLangageCodeToISOCode', cdRegister);
end;

 
 
{ TPSImport_locale }
(*----------------------------------------------------------------------------*)
procedure TPSImport_locale.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_locale(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_locale.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_locale_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
