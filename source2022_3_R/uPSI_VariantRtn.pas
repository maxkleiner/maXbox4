unit uPSI_VariantRtn;
{
supporz variants  vararrayget2

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
  TPSImport_VariantRtn = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_VariantRtn(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_VariantRtn_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,VariantRtn
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VariantRtn]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_VariantRtn(CL: TPSPascalCompiler);
begin

CL.AddTypeS('TProcReadElementValue', 'procedure(Value:Variant; IndexValue:integerarray; const HighBoundInd:integer; Var Continue:boolean)');
CL.AddTypeS('TProcWriteElementValue', 'procedure(OldValue:Variant; IndexValue:integerarray; Var NewValue:Variant; Var Continue:boolean)');

 //TProcReadElementValue=procedure (Value:Variant; IndexValue:array of integer; const HighBoundInd:integer; Var Continue:boolean);
 //TProcWriteElementValue=procedure (OldValue:Variant; IndexValue:array of integer; Var NewValue:Variant;  Var Continue:boolean);
//

 CL.AddDelphiFunction('Function SafeVarArrayCreate( const Bounds : array of Integer; VarType, DimCount : Integer) : Variant');
 CL.AddDelphiFunction('Function VarArrayGet2( const A : Variant; const Indices : array of Integer; const HighBound : integer) : Variant');
 CL.AddDelphiFunction('Procedure VarArrayPut2( var A : Variant; const Value : Variant; const Indices : array of Integer; const HighBound : integer)');
 CL.AddDelphiFunction('Function CycleReadArray( vArray : Variant; CallBackProc : TProcReadElementValue) : boolean');
 CL.AddDelphiFunction('Function CycleWriteArray( var vArray : Variant; CallBackProc : TProcWriteElementValue) : boolean');
 CL.AddDelphiFunction('Function CompareVarArray1( vArray1, vArray2 : Variant) : boolean');
 CL.AddDelphiFunction('Function EasyCompareVarArray1( vArray1, vArray2 : Variant; HighBound : integer) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_VariantRtn_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SafeVarArrayCreate, 'SafeVarArrayCreate', cdRegister);
 S.RegisterDelphiFunction(@VarArrayGet, 'VarArrayGet2', cdRegister);
 S.RegisterDelphiFunction(@VarArrayPut, 'VarArrayPut2', cdRegister);
 S.RegisterDelphiFunction(@CycleReadArray, 'CycleReadArray', cdRegister);
 S.RegisterDelphiFunction(@CycleWriteArray, 'CycleWriteArray', cdRegister);
 S.RegisterDelphiFunction(@CompareVarArray1, 'CompareVarArray1', cdRegister);
 S.RegisterDelphiFunction(@EasyCompareVarArray1, 'EasyCompareVarArray1', cdRegister);
end;

 
 
{ TPSImport_VariantRtn }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VariantRtn.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VariantRtn(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VariantRtn.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_VariantRtn_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
