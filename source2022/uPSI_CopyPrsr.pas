unit uPSI_CopyPrsr;
{
  copy constructor --> assign
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
  TPSImport_CopyPrsr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCopyParser(CL: TPSPascalCompiler);
procedure SIRegister_CopyPrsr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCopyParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_CopyPrsr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   CopyPrsr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CopyPrsr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCopyParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCopyParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCopyParser') do begin
    RegisterMethod('Constructor Create( Stream, OutStream : TStream)');
        RegisterMethod('Procedure Free');
     RegisterMethod('Procedure CheckToken( T : Char)');
    RegisterMethod('Procedure CheckTokenSymbol( const S : string)');
    RegisterMethod('Function CopyTo( Length : Integer) : string');
    RegisterMethod('Function CopyToToken( AToken : Char) : string');
    RegisterMethod('Function CopyToEOL : string');
    RegisterMethod('Function CopyToEOF : string');
    RegisterMethod('Procedure CopyTokenToOutput');
    RegisterMethod('Procedure Error( const Ident : string)');
    RegisterMethod('Procedure ErrorFmt( const Ident : string; const Args : array of const)');
    RegisterMethod('Procedure ErrorStr( const Message : string)');
    RegisterMethod('Function NextToken : Char');
    RegisterMethod('Function SkipToken( CopyBlanks : Boolean) : Char');
    RegisterMethod('Procedure SkipEOL');
    RegisterMethod('Function SkipTo( Length : Integer) : string');
    RegisterMethod('Function SkipToToken( AToken : Char) : string');
    RegisterMethod('Function SkipToEOL : string');
    RegisterMethod('Function SkipToEOF : string');
    RegisterMethod('Function SourcePos : Longint');
    RegisterMethod('Function TokenComponentIdent : String');
    RegisterMethod('Function TokenFloat : Extended');
    RegisterMethod('Function TokenInt : Longint');
    RegisterMethod('Function TokenString : string');
    RegisterMethod('Function TokenSymbolIs( const S : string) : Boolean');
    RegisterProperty('SourceLine', 'Integer', iptr);
    RegisterProperty('Token', 'Char', iptr);
    RegisterProperty('OutputStream', 'TStream', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CopyPrsr(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('toEOL','LongInt').SetInt((5));
  SIRegister_TCopyParser(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCopyParserOutputStream_W(Self: TCopyParser; const T: TStream);
begin Self.OutputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TCopyParserOutputStream_R(Self: TCopyParser; var T: TStream);
begin T := Self.OutputStream; end;

(*----------------------------------------------------------------------------*)
procedure TCopyParserToken_R(Self: TCopyParser; var T: Char);
begin T := Self.Token; end;

(*----------------------------------------------------------------------------*)
procedure TCopyParserSourceLine_R(Self: TCopyParser; var T: Integer);
begin T := Self.SourceLine; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCopyParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCopyParser) do begin
    RegisterConstructor(@TCopyParser.Create, 'Create');
      RegisterMethod(@TCopyParser.Destroy, 'Free');
     RegisterMethod(@TCopyParser.CheckToken, 'CheckToken');
    RegisterMethod(@TCopyParser.CheckTokenSymbol, 'CheckTokenSymbol');
    RegisterMethod(@TCopyParser.CopyTo, 'CopyTo');
    RegisterMethod(@TCopyParser.CopyToToken, 'CopyToToken');
    RegisterMethod(@TCopyParser.CopyToEOL, 'CopyToEOL');
    RegisterMethod(@TCopyParser.CopyToEOF, 'CopyToEOF');
    RegisterMethod(@TCopyParser.CopyTokenToOutput, 'CopyTokenToOutput');
    RegisterMethod(@TCopyParser.Error, 'Error');
    RegisterMethod(@TCopyParser.ErrorFmt, 'ErrorFmt');
    RegisterMethod(@TCopyParser.ErrorStr, 'ErrorStr');
    RegisterMethod(@TCopyParser.NextToken, 'NextToken');
    RegisterMethod(@TCopyParser.SkipToken, 'SkipToken');
    RegisterMethod(@TCopyParser.SkipEOL, 'SkipEOL');
    RegisterMethod(@TCopyParser.SkipTo, 'SkipTo');
    RegisterMethod(@TCopyParser.SkipToToken, 'SkipToToken');
    RegisterMethod(@TCopyParser.SkipToEOL, 'SkipToEOL');
    RegisterMethod(@TCopyParser.SkipToEOF, 'SkipToEOF');
    RegisterMethod(@TCopyParser.SourcePos, 'SourcePos');
    RegisterMethod(@TCopyParser.TokenComponentIdent, 'TokenComponentIdent');
    RegisterMethod(@TCopyParser.TokenFloat, 'TokenFloat');
    RegisterMethod(@TCopyParser.TokenInt, 'TokenInt');
    RegisterMethod(@TCopyParser.TokenString, 'TokenString');
    RegisterMethod(@TCopyParser.TokenSymbolIs, 'TokenSymbolIs');
    RegisterPropertyHelper(@TCopyParserSourceLine_R,nil,'SourceLine');
    RegisterPropertyHelper(@TCopyParserToken_R,nil,'Token');
    RegisterPropertyHelper(@TCopyParserOutputStream_R,@TCopyParserOutputStream_W,'OutputStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CopyPrsr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCopyParser(CL);
end;

 
 
{ TPSImport_CopyPrsr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CopyPrsr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CopyPrsr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CopyPrsr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CopyPrsr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
