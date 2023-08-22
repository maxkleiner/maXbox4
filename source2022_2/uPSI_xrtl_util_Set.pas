unit uPSI_xrtl_util_Set;
{
  one last set on 3.9.6.4
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
  TPSImport_xrtl_util_Set = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXRTLArraySet(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLSet(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_Set(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXRTLArraySet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_util_Set(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   xrtl_util_Value
  ,xrtl_util_Array
  ,xrtl_util_Container
  ,xrtl_util_Set
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_Set]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLArraySet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLSet', 'TXRTLArraySet') do
  with CL.AddClassN(CL.FindClass('TXRTLSet'),'TXRTLArraySet') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterMethod('Function GetValues : TXRTLValueArray');
    RegisterMethod('Function Add( const IValue : IXRTLValue) : Boolean');
    RegisterMethod('Function Remove( const IValue : IXRTLValue) : Boolean');
    RegisterMethod('Function HasValue( const IValue : IXRTLValue) : Boolean');
    RegisterMethod('Function Find( const IValue : IXRTLValue; out Iterator : IXRTLIterator) : Boolean');
    RegisterMethod('Function AtBegin : IXRTLIterator');
    RegisterMethod('Function AtEnd : IXRTLIterator');
    RegisterMethod('Function GetValue( const Iterator : IXRTLIterator) : IXRTLValue');
    RegisterMethod('Function GetSize : Integer');
    RegisterMethod('Function GetCapacity : Integer');
    RegisterMethod('Procedure TrimToSize');
    RegisterMethod('Procedure EnsureCapacity( const ACapacity : Integer)');
    RegisterProperty('LoadFactor', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLSetContainer', 'TXRTLSet') do
  with CL.AddClassN(CL.FindClass('TXRTLSetContainer'),'TXRTLSet') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_Set(CL: TPSPascalCompiler);
begin
  SIRegister_TXRTLSet(CL);
  SIRegister_TXRTLArraySet(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXRTLArraySetLoadFactor_W(Self: TXRTLArraySet; const T: Double);
begin Self.LoadFactor := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLArraySetLoadFactor_R(Self: TXRTLArraySet; var T: Double);
begin T := Self.LoadFactor; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLArraySet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLArraySet) do
  begin
    RegisterConstructor(@TXRTLArraySet.Create, 'Create');
    RegisterMethod(@TXRTLArraySet.IsEmpty, 'IsEmpty');
    RegisterMethod(@TXRTLArraySet.GetValues, 'GetValues');
    RegisterMethod(@TXRTLArraySet.Add, 'Add');
    RegisterMethod(@TXRTLArraySet.Remove, 'Remove');
    RegisterMethod(@TXRTLArraySet.HasValue, 'HasValue');
    RegisterMethod(@TXRTLArraySet.Find, 'Find');
    RegisterMethod(@TXRTLArraySet.AtBegin, 'AtBegin');
    RegisterMethod(@TXRTLArraySet.AtEnd, 'AtEnd');
    RegisterMethod(@TXRTLArraySet.GetValue, 'GetValue');
    RegisterMethod(@TXRTLArraySet.GetSize, 'GetSize');
    RegisterMethod(@TXRTLArraySet.GetCapacity, 'GetCapacity');
    RegisterMethod(@TXRTLArraySet.TrimToSize, 'TrimToSize');
    RegisterMethod(@TXRTLArraySet.EnsureCapacity, 'EnsureCapacity');
    RegisterPropertyHelper(@TXRTLArraySetLoadFactor_R,@TXRTLArraySetLoadFactor_W,'LoadFactor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLSet) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_Set(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLSet(CL);
  RIRegister_TXRTLArraySet(CL);
end;

 
 
{ TPSImport_xrtl_util_Set }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Set.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_Set(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Set.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_Set(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
