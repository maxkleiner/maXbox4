unit uPSI_MaxStrUtils;
{
   from max to max
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
  TPSImport_MaxStrUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MaxStrUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MaxStrUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   MaxStrUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MaxStrUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_MaxStrUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('CharSet2', 'TSysCharSet');
 CL.AddDelphiFunction('Procedure ParseFields( Separators, WhiteSpace : TSysCharSet; Content : PChar; Strings : TStrings; Decode : Boolean)');
 CL.AddDelphiFunction('Function HTTPDecodemax( const AStr : String) : string');
 CL.AddDelphiFunction('Function HTTPEncodemax( const AStr : String) : string');
 CL.AddDelphiFunction('Function FormatDate( const DateString : string) : string');
 CL.AddDelphiFunction('Function FormatListMasterDate( const DateStr, FormatDefStr : String; Len : Integer) : String');
 CL.AddDelphiFunction('Function InvertCase( const S : String) : String');
 CL.AddDelphiFunction('Function CommentLinesWithSlashes( const S : String) : String');
 CL.AddDelphiFunction('Function UncommentLinesWithSlashes( const S : String) : String');
 CL.AddDelphiFunction('Function StripChars( const S : String; Strip : Charset2) : String');
 CL.AddDelphiFunction('Function TrimChars( const S : string; Chars : Charset2) : string');
 CL.AddDelphiFunction('Function TrimLeftChars( const S : string; Chars : Charset2) : string');
 CL.AddDelphiFunction('Function TrimRightChars( const S : string; Chars : Charset2) : string');
 CL.AddDelphiFunction('Function ContainsChars( const S : String; Strip : Charset2) : Boolean');
 CL.AddDelphiFunction('Function DequotedStrmax( const S : String; AQuoteChar : Char) : String');
 CL.AddDelphiFunction('Procedure LeftPadStr( var S : String; toLength : Integer; withChar : Char)');
 CL.AddDelphiFunction('Procedure RightPadStr( var S : String; toLength : Integer; withChar : Char)');
 CL.AddDelphiFunction('Function RemoveChars( S : string; Chars : Charset2) : string');
 CL.AddDelphiFunction('Function FilterChars( S : string; Chars : Charset2) : string');
 CL.AddDelphiFunction('Function RemoveNonNumericChars( S : string) : string');
 CL.AddDelphiFunction('Function RemoveNonAlphanumChars( S : string) : string');
 CL.AddDelphiFunction('Function RemoveNonAlphaChars( S : string) : string');
 CL.AddDelphiFunction('Function HasAlphaChars( S : string) : boolean');
 CL.AddDelphiFunction('Function ReplaceChars( S : string; Chars : Charset2; ReplaceWith : Char) : string');
 CL.AddDelphiFunction('Function DomainOfEMail( const EMailAddress : String) : String');
 CL.AddDelphiFunction('Function IPToHexIP( const IP : String) : String');
 CL.AddDelphiFunction('Procedure CmdLineToStrings( S : AnsiString; const List : TStrings)');
 CL.AddConstantN('BASE2','String').SetString( '01');
 CL.AddConstantN('BASE10','String').SetString( '0123456789');
 CL.AddConstantN('BASE16','String').SetString( '0123456789ABCDEF');
 CL.AddConstantN('BASE36','String').SetString( '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
 CL.AddConstantN('BASE62','String').SetString( '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz');
 CL.AddDelphiFunction('Function BaseConvert( Number, FromDigits, ToDigits : String) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_MaxStrUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ParseFields, 'ParseFields', cdRegister);
 S.RegisterDelphiFunction(@HTTPDecode, 'HTTPDecodemax', cdRegister);
 S.RegisterDelphiFunction(@HTTPEncode, 'HTTPEncodemax', cdRegister);
 S.RegisterDelphiFunction(@FormatDate, 'FormatDate', cdRegister);
 S.RegisterDelphiFunction(@FormatListMasterDate, 'FormatListMasterDate', cdRegister);
 S.RegisterDelphiFunction(@InvertCase, 'InvertCase', cdRegister);
 S.RegisterDelphiFunction(@CommentLinesWithSlashes, 'CommentLinesWithSlashes', cdRegister);
 S.RegisterDelphiFunction(@UncommentLinesWithSlashes, 'UncommentLinesWithSlashes', cdRegister);
 S.RegisterDelphiFunction(@StripChars, 'StripChars', cdRegister);
 S.RegisterDelphiFunction(@TrimChars, 'TrimChars', cdRegister);
 S.RegisterDelphiFunction(@TrimLeftChars, 'TrimLeftChars', cdRegister);
 S.RegisterDelphiFunction(@TrimRightChars, 'TrimRightChars', cdRegister);
 S.RegisterDelphiFunction(@ContainsChars, 'ContainsChars', cdRegister);
 S.RegisterDelphiFunction(@DequotedStr, 'DequotedStrmax', cdRegister);
 S.RegisterDelphiFunction(@LeftPadStr, 'LeftPadStr', cdRegister);
 S.RegisterDelphiFunction(@RightPadStr, 'RightPadStr', cdRegister);
 S.RegisterDelphiFunction(@RemoveChars, 'RemoveChars', cdRegister);
 S.RegisterDelphiFunction(@FilterChars, 'FilterChars', cdRegister);
 S.RegisterDelphiFunction(@RemoveNonNumericChars, 'RemoveNonNumericChars', cdRegister);
 S.RegisterDelphiFunction(@RemoveNonAlphanumChars, 'RemoveNonAlphanumChars', cdRegister);
 S.RegisterDelphiFunction(@RemoveNonAlphaChars, 'RemoveNonAlphaChars', cdRegister);
 S.RegisterDelphiFunction(@HasAlphaChars, 'HasAlphaChars', cdRegister);
 S.RegisterDelphiFunction(@ReplaceChars, 'ReplaceChars', cdRegister);
 S.RegisterDelphiFunction(@DomainOfEMail, 'DomainOfEMail', cdRegister);
 S.RegisterDelphiFunction(@IPToHexIP, 'IPToHexIP', cdRegister);
 S.RegisterDelphiFunction(@CmdLineToStrings, 'CmdLineToStrings', cdRegister);
 S.RegisterDelphiFunction(@BaseConvert, 'BaseConvert', cdRegister);
end;

 
 
{ TPSImport_MaxStrUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxStrUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MaxStrUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxStrUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MaxStrUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
