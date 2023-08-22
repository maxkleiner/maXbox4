unit uPSI_JvHLParser;
{
   TEST FOR PERL AND PYTHON INTERPRETER
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
  TPSImport_JvHLParser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_EJvIParserError(CL: TPSPascalCompiler);
procedure SIRegister_TJvIParserW(CL: TPSPascalCompiler);
procedure SIRegister_TJvIParser(CL: TPSPascalCompiler);
procedure SIRegister_JvHLParser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvHLParser_Routines(S: TPSExec);
procedure RIRegister_EJvIParserError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvIParserW(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvIParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvHLParser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Dialogs
  //,JclWideStrings
  ,JvTypes
  ,JvJCLUtils
  ,JvHLParser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvHLParser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EJvIParserError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EJvIParserError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EJvIParserError') do
  begin
    RegisterMethod('Constructor Create( AErrCode : Integer; APosition : Cardinal; Dummy : Integer)');
    RegisterProperty('ErrCode', 'Integer', iptr);
    RegisterProperty('Position', 'Cardinal', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvIParserW(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvIParserW') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvIParserW') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Token : WideString');
    RegisterMethod('Procedure RollBack( Index : Integer)');
    RegisterProperty('History', 'WideString Integer', iptr);
    RegisterProperty('PosBeg', 'Integer Integer', iptr);
    RegisterProperty('PosEnd', 'Integer Integer', iptr);
    RegisterProperty('HistorySize', 'Integer', iptrw);
    RegisterProperty('Pos', 'Integer', iptr);
    RegisterProperty('pcPos', 'PWideChar', iptrw);
    RegisterProperty('pcProgram', 'PWideChar', iptrw);
    RegisterProperty('Style', 'TIParserStyle', iptrw);
    RegisterProperty('ReturnComments', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvIParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvIParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvIParser') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
     RegisterMethod('Function Token : string');
    RegisterMethod('Procedure RollBack( Index : Integer)');
    RegisterProperty('History', 'string Integer', iptr);
    RegisterProperty('PosBeg', 'Integer Integer', iptr);
    RegisterProperty('PosEnd', 'Integer Integer', iptr);
    RegisterProperty('HistorySize', 'Integer', iptrw);
    RegisterProperty('Pos', 'Integer', iptr);
    RegisterProperty('pcPos', 'PChar', iptrw);
    RegisterProperty('pcProgram', 'PChar', iptrw);
    RegisterProperty('Style', 'TIParserStyle', iptrw);
    RegisterProperty('ReturnComments', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvHLParser(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ieBadRemark','LongInt').SetInt( 1);
  CL.AddTypeS('TIParserStyle', '(psNone, psPascal, psCpp, psPython, psVB, psHtml, psPerl, psCocoR, psPhp, psSql )');
  SIRegister_TJvIParser(CL);
  SIRegister_TJvIParserW(CL);
  SIRegister_EJvIParserError(CL);
 CL.AddDelphiFunction('Function IsStringConstant( const St : string) : Boolean');
 CL.AddDelphiFunction('Function IsIntConstant( const St : string) : Boolean');
 CL.AddDelphiFunction('Function IsRealConstant( const St : string) : Boolean');
 CL.AddDelphiFunction('Function IsIdentifier( const ID : string) : Boolean');
 CL.AddDelphiFunction('Function GetStringValue( const St : string) : string');
 CL.AddDelphiFunction('Procedure ParseString( const S : string; Ss : TStrings)');
 CL.AddDelphiFunction('Function IsStringConstantW( const St : WideString) : Boolean');
 CL.AddDelphiFunction('Function IsIntConstantW( const St : WideString) : Boolean');
 CL.AddDelphiFunction('Function IsRealConstantW( const St : WideString) : Boolean');
 CL.AddDelphiFunction('Function IsIdentifierW( const ID : WideString) : Boolean');
 CL.AddDelphiFunction('Function GetStringValueW( const St : WideString) : WideString');
 CL.AddDelphiFunction('Procedure ParseStringW( const S : WideString; Ss : TStrings)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure EJvIParserErrorPosition_R(Self: EJvIParserError; var T: Cardinal);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure EJvIParserErrorErrCode_R(Self: EJvIParserError; var T: Integer);
begin T := Self.ErrCode; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWReturnComments_W(Self: TJvIParserW; const T: Boolean);
begin Self.ReturnComments := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWReturnComments_R(Self: TJvIParserW; var T: Boolean);
begin T := Self.ReturnComments; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWStyle_W(Self: TJvIParserW; const T: TIParserStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWStyle_R(Self: TJvIParserW; var T: TIParserStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWpcProgram_W(Self: TJvIParserW; const T: PAnsiChar);
begin Self.pcProgram := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWpcProgram_R(Self: TJvIParserW; var T: PAnsiChar);
begin T := Self.pcProgram; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWpcPos_W(Self: TJvIParserW; const T: PAnsiChar);
begin Self.pcPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWpcPos_R(Self: TJvIParserW; var T: PAnsiChar);
begin T := Self.pcPos; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWPos_R(Self: TJvIParserW; var T: Integer);
begin T := Self.Pos; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWHistorySize_W(Self: TJvIParserW; const T: Integer);
begin Self.HistorySize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWHistorySize_R(Self: TJvIParserW; var T: Integer);
begin T := Self.HistorySize; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWPosEnd_R(Self: TJvIParserW; var T: Integer; const t1: Integer);
begin T := Self.PosEnd[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWPosBeg_R(Self: TJvIParserW; var T: Integer; const t1: Integer);
begin T := Self.PosBeg[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserWHistory_R(Self: TJvIParserW; var T: WideString; const t1: Integer);
begin T := Self.History[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserReturnComments_W(Self: TJvIParser; const T: Boolean);
begin Self.ReturnComments := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserReturnComments_R(Self: TJvIParser; var T: Boolean);
begin T := Self.ReturnComments; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserStyle_W(Self: TJvIParser; const T: TIParserStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserStyle_R(Self: TJvIParser; var T: TIParserStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserpcProgram_W(Self: TJvIParser; const T: PChar);
begin Self.pcProgram := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserpcProgram_R(Self: TJvIParser; var T: PChar);
begin T := Self.pcProgram; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserpcPos_W(Self: TJvIParser; const T: PChar);
begin Self.pcPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserpcPos_R(Self: TJvIParser; var T: PChar);
begin T := Self.pcPos; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserPos_R(Self: TJvIParser; var T: Integer);
begin T := Self.Pos; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserHistorySize_W(Self: TJvIParser; const T: Integer);
begin Self.HistorySize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserHistorySize_R(Self: TJvIParser; var T: Integer);
begin T := Self.HistorySize; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserPosEnd_R(Self: TJvIParser; var T: Integer; const t1: Integer);
begin T := Self.PosEnd[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserPosBeg_R(Self: TJvIParser; var T: Integer; const t1: Integer);
begin T := Self.PosBeg[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvIParserHistory_R(Self: TJvIParser; var T: string; const t1: Integer);
begin T := Self.History[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvHLParser_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsStringConstant, 'IsStringConstant', cdRegister);
 S.RegisterDelphiFunction(@IsIntConstant, 'IsIntConstant', cdRegister);
 S.RegisterDelphiFunction(@IsRealConstant, 'IsRealConstant', cdRegister);
 S.RegisterDelphiFunction(@IsIdentifier, 'IsIdentifier', cdRegister);
 S.RegisterDelphiFunction(@GetStringValue, 'GetStringValue', cdRegister);
 S.RegisterDelphiFunction(@ParseString, 'ParseString', cdRegister);
 S.RegisterDelphiFunction(@IsStringConstantW, 'IsStringConstantW', cdRegister);
 S.RegisterDelphiFunction(@IsIntConstantW, 'IsIntConstantW', cdRegister);
 S.RegisterDelphiFunction(@IsRealConstantW, 'IsRealConstantW', cdRegister);
 S.RegisterDelphiFunction(@IsIdentifierW, 'IsIdentifierW', cdRegister);
 S.RegisterDelphiFunction(@GetStringValueW, 'GetStringValueW', cdRegister);
 S.RegisterDelphiFunction(@ParseStringW, 'ParseStringW', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EJvIParserError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJvIParserError) do
  begin
    RegisterConstructor(@EJvIParserError.Create, 'Create');
    RegisterPropertyHelper(@EJvIParserErrorErrCode_R,nil,'ErrCode');
    RegisterPropertyHelper(@EJvIParserErrorPosition_R,nil,'Position');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvIParserW(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvIParserW) do begin
    RegisterConstructor(@TJvIParserW.Create, 'Create');
    RegisterMethod(@TJvIParserW.Destroy, 'Free');
    RegisterMethod(@TJvIParserW.Token, 'Token');
    RegisterMethod(@TJvIParserW.RollBack, 'RollBack');
    RegisterPropertyHelper(@TJvIParserWHistory_R,nil,'History');
    RegisterPropertyHelper(@TJvIParserWPosBeg_R,nil,'PosBeg');
    RegisterPropertyHelper(@TJvIParserWPosEnd_R,nil,'PosEnd');
    RegisterPropertyHelper(@TJvIParserWHistorySize_R,@TJvIParserWHistorySize_W,'HistorySize');
    RegisterPropertyHelper(@TJvIParserWPos_R,nil,'Pos');
    RegisterPropertyHelper(@TJvIParserWpcPos_R,@TJvIParserWpcPos_W,'pcPos');
    RegisterPropertyHelper(@TJvIParserWpcProgram_R,@TJvIParserWpcProgram_W,'pcProgram');
    RegisterPropertyHelper(@TJvIParserWStyle_R,@TJvIParserWStyle_W,'Style');
    RegisterPropertyHelper(@TJvIParserWReturnComments_R,@TJvIParserWReturnComments_W,'ReturnComments');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvIParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvIParser) do begin
    RegisterConstructor(@TJvIParser.Create, 'Create');
    RegisterMethod(@TJvIParserW.Destroy, 'Free');
    RegisterMethod(@TJvIParser.Token, 'Token');
    RegisterMethod(@TJvIParser.RollBack, 'RollBack');
    RegisterPropertyHelper(@TJvIParserHistory_R,nil,'History');
    RegisterPropertyHelper(@TJvIParserPosBeg_R,nil,'PosBeg');
    RegisterPropertyHelper(@TJvIParserPosEnd_R,nil,'PosEnd');
    RegisterPropertyHelper(@TJvIParserHistorySize_R,@TJvIParserHistorySize_W,'HistorySize');
    RegisterPropertyHelper(@TJvIParserPos_R,nil,'Pos');
    RegisterPropertyHelper(@TJvIParserpcPos_R,@TJvIParserpcPos_W,'pcPos');
    RegisterPropertyHelper(@TJvIParserpcProgram_R,@TJvIParserpcProgram_W,'pcProgram');
    RegisterPropertyHelper(@TJvIParserStyle_R,@TJvIParserStyle_W,'Style');
    RegisterPropertyHelper(@TJvIParserReturnComments_R,@TJvIParserReturnComments_W,'ReturnComments');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvHLParser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvIParser(CL);
  RIRegister_TJvIParserW(CL);
  RIRegister_EJvIParserError(CL);
end;

 
 
{ TPSImport_JvHLParser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvHLParser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvHLParser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvHLParser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvHLParser(ri);
  RIRegister_JvHLParser_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
