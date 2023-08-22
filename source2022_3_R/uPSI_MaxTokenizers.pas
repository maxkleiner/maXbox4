unit uPSI_MaxTokenizers;
{
   tokenmaxer    tok tik
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
  TPSImport_MaxTokenizers = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBaseTokenizer(CL: TPSPascalCompiler);
procedure SIRegister_ITokenizer(CL: TPSPascalCompiler);
procedure SIRegister_MaxTokenizers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBaseTokenizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_MaxTokenizers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   MaxTokenizers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MaxTokenizers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseTokenizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TBaseTokenizer') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TBaseTokenizer') do
  begin
    RegisterProperty('Token', 'String', iptr);
    RegisterProperty('Source', 'PChar', iptr);
    RegisterProperty('SourceLength', 'Longint', iptr);
    RegisterProperty('BufferCapacity', 'Longint', iptr);
    RegisterProperty('TokenID', 'TTokenID', iptr);
    RegisterProperty('LineNo', 'Integer', iptr);
    RegisterProperty('TokenNo', 'Integer', iptr);
    RegisterProperty('TokenPosition', 'Integer', iptr);
    RegisterProperty('TokenLen', 'Integer', iptr);
    RegisterProperty('LineCount', 'Int64', iptr);
    RegisterProperty('LOCCount', 'Int64', iptr);
    RegisterProperty('NonJunkCount', 'Int64', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ITokenizer(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ITokenizer') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ITokenizer, 'ITokenizer') do
  begin
    RegisterMethod('Function GetTokenStr : String', cdRegister);
    RegisterMethod('Function GetTokenName : String', cdRegister);
    RegisterMethod('Function GetSourceBuffer : PChar', cdRegister);
    RegisterMethod('Function GetTokenID : TTokenID', cdRegister);
    RegisterMethod('Function GetLineNo : Integer', cdRegister);
    RegisterMethod('Function GetTokenPosition : Integer', cdRegister);
    RegisterMethod('Function GetTokenLen : Integer', cdRegister);
    RegisterMethod('Function GetLineCount : Int64', cdRegister);
    RegisterMethod('Function GetTokenCount : Int64', cdRegister);
    RegisterMethod('Function GetLOCCount : Int64', cdRegister);
    RegisterMethod('Function GetNonJunkCount : Int64', cdRegister);
    RegisterMethod('Function GetToken : String', cdRegister);
    RegisterMethod('Function IsJunk : Boolean', cdRegister);
    RegisterMethod('Procedure Init( NewSource : PChar; NewSize : LongInt)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function EOF : Boolean', cdRegister);
    RegisterMethod('Procedure NextToken', cdRegister);
    RegisterMethod('Procedure NextNonComment', cdRegister);
    RegisterMethod('Procedure NextNonJunk', cdRegister);
    RegisterMethod('Procedure NextNonSpace', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MaxTokenizers(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('tkNULLmax','LongInt').SetInt( 0);
 CL.AddConstantN('tkNONEmax','LongInt').SetInt( 0);
 CL.AddConstantN('tkTABmax','LongInt').SetInt( 1);
 CL.AddConstantN('tkEOLmax','LongInt').SetInt( 2);
 CL.AddConstantN('tkEOFmax','LongInt').SetInt( 3);
 CL.AddConstantN('tkCOMMENTmax','LongInt').SetInt( 4);
 CL.AddConstantN('tkSPACEmax','LongInt').SetInt( 5);
  CL.AddTypeS('TTokenID', 'Byte');
  CL.AddTypeS('TTokenSet', 'set of TTokenID');
  CL.AddTypeS('TTokenRec', 'record TokenID : TTokenID; Pos : integer; Len : Int'
   +'eger; LineNo : integer; ColNo : Integer; end');
  SIRegister_ITokenizer(CL);
  SIRegister_TBaseTokenizer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerNonJunkCount_R(Self: TBaseTokenizer; var T: Int64);
begin T := Self.NonJunkCount; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerLOCCount_R(Self: TBaseTokenizer; var T: Int64);
begin T := Self.LOCCount; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerLineCount_R(Self: TBaseTokenizer; var T: Int64);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerTokenLen_R(Self: TBaseTokenizer; var T: Integer);
begin T := Self.TokenLen; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerTokenPosition_R(Self: TBaseTokenizer; var T: Integer);
begin T := Self.TokenPosition; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerTokenNo_R(Self: TBaseTokenizer; var T: Integer);
begin T := Self.TokenNo; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerLineNo_R(Self: TBaseTokenizer; var T: Integer);
begin T := Self.LineNo; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerTokenID_R(Self: TBaseTokenizer; var T: TTokenID);
begin T := Self.TokenID; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerBufferCapacity_R(Self: TBaseTokenizer; var T: Longint);
begin T := Self.BufferCapacity; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerSourceLength_R(Self: TBaseTokenizer; var T: Longint);
begin T := Self.SourceLength; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerSource_R(Self: TBaseTokenizer; var T: PChar);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TBaseTokenizerToken_R(Self: TBaseTokenizer; var T: String);
begin T := Self.Token; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseTokenizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseTokenizer) do
  begin
    RegisterPropertyHelper(@TBaseTokenizerToken_R,nil,'Token');
    RegisterPropertyHelper(@TBaseTokenizerSource_R,nil,'Source');
    RegisterPropertyHelper(@TBaseTokenizerSourceLength_R,nil,'SourceLength');
    RegisterPropertyHelper(@TBaseTokenizerBufferCapacity_R,nil,'BufferCapacity');
    RegisterPropertyHelper(@TBaseTokenizerTokenID_R,nil,'TokenID');
    RegisterPropertyHelper(@TBaseTokenizerLineNo_R,nil,'LineNo');
    RegisterPropertyHelper(@TBaseTokenizerTokenNo_R,nil,'TokenNo');
    RegisterPropertyHelper(@TBaseTokenizerTokenPosition_R,nil,'TokenPosition');
    RegisterPropertyHelper(@TBaseTokenizerTokenLen_R,nil,'TokenLen');
    RegisterPropertyHelper(@TBaseTokenizerLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TBaseTokenizerLOCCount_R,nil,'LOCCount');
    RegisterPropertyHelper(@TBaseTokenizerNonJunkCount_R,nil,'NonJunkCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MaxTokenizers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBaseTokenizer(CL);
end;

 
 
{ TPSImport_MaxTokenizers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxTokenizers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MaxTokenizers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MaxTokenizers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MaxTokenizers(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
