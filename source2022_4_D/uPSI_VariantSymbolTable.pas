unit uPSI_VariantSymbolTable;
{
   symbol with hash
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
  TPSImport_VariantSymbolTable = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TVariantSymbolTable(CL: TPSPascalCompiler);
procedure SIRegister_VariantSymbolTable(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TVariantSymbolTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_VariantSymbolTable(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   VariantSymbolTable
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VariantSymbolTable]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TVariantSymbolTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TVariantSymbolTable') do
  with CL.AddClassN(CL.FindClass('TObject'),'TVariantSymbolTable') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function CreateSymbol( SymbolName : String; SymbolValue : Variant) : PSymbol');
    RegisterMethod('Procedure EnterBlock');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterMethod('Procedure LeaveBlock');
    RegisterProperty('FirstSymbol', 'PSymbol', iptr);
    RegisterProperty('LocalScope', 'Boolean', iptrw);
    RegisterProperty('Symbol', 'PSymbol String', iptr);
    RegisterProperty('Value', 'Variant String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_VariantSymbolTable(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('HASH_SIZE','LongInt').SetInt( 256);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantSymbolTable');
  CL.AddTypeS('TSymbolType', '( stInteger, stFloat, stDate, stString )');
  //CL.AddTypeS('PSymbol', '^TSymbol // will not work');
  CL.AddTypeS('TSymbol', 'record Name : String; BlockLevel : integer; HashValue'
   +' : Integer; Value : Variant; end');
  //CL.AddTypeS('PSymbolArray', '^TSymbolArray // will not work');
  SIRegister_TVariantSymbolTable(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TVariantSymbolTableValue_W(Self: TVariantSymbolTable; const T: Variant; const t1: String);
begin Self.Value[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TVariantSymbolTableValue_R(Self: TVariantSymbolTable; var T: Variant; const t1: String);
begin T := Self.Value[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TVariantSymbolTableSymbol_R(Self: TVariantSymbolTable; var T: PSymbol; const t1: String);
begin T := Self.Symbol[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TVariantSymbolTableLocalScope_W(Self: TVariantSymbolTable; const T: Boolean);
begin Self.LocalScope := T; end;

(*----------------------------------------------------------------------------*)
procedure TVariantSymbolTableLocalScope_R(Self: TVariantSymbolTable; var T: Boolean);
begin T := Self.LocalScope; end;

(*----------------------------------------------------------------------------*)
procedure TVariantSymbolTableFirstSymbol_R(Self: TVariantSymbolTable; var T: PSymbol);
begin T := Self.FirstSymbol; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVariantSymbolTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVariantSymbolTable) do begin
    RegisterConstructor(@TVariantSymbolTable.Create, 'Create');
    RegisterMethod(@TVariantSymbolTable.Destroy, 'Free');
    RegisterMethod(@TVariantSymbolTable.Clear, 'Clear');
    RegisterMethod(@TVariantSymbolTable.CreateSymbol, 'CreateSymbol');
    RegisterMethod(@TVariantSymbolTable.EnterBlock, 'EnterBlock');
    RegisterMethod(@TVariantSymbolTable.IsEmpty, 'IsEmpty');
    RegisterMethod(@TVariantSymbolTable.LeaveBlock, 'LeaveBlock');
    RegisterPropertyHelper(@TVariantSymbolTableFirstSymbol_R,nil,'FirstSymbol');
    RegisterPropertyHelper(@TVariantSymbolTableLocalScope_R,@TVariantSymbolTableLocalScope_W,'LocalScope');
    RegisterPropertyHelper(@TVariantSymbolTableSymbol_R,nil,'Symbol');
    RegisterPropertyHelper(@TVariantSymbolTableValue_R,@TVariantSymbolTableValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VariantSymbolTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EVariantSymbolTable) do
  RIRegister_TVariantSymbolTable(CL);
end;

 
 
{ TPSImport_VariantSymbolTable }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VariantSymbolTable.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VariantSymbolTable(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VariantSymbolTable.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_VariantSymbolTable(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
