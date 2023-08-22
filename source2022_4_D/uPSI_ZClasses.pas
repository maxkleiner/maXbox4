unit uPSI_ZClasses;
{
  with ToString and Clone
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
  TPSImport_ZClasses = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZAbstractObject(CL: TPSPascalCompiler);
procedure SIRegister_IZStack(CL: TPSPascalCompiler);
procedure SIRegister_IZHashMap(CL: TPSPascalCompiler);
procedure SIRegister_IZCollection(CL: TPSPascalCompiler);
procedure SIRegister_IZIterator(CL: TPSPascalCompiler);
procedure SIRegister_IZClonnable(CL: TPSPascalCompiler);
procedure SIRegister_IZComparable(CL: TPSPascalCompiler);
procedure SIRegister_IZObject(CL: TPSPascalCompiler);
procedure SIRegister_TContainedObject(CL: TPSPascalCompiler);
procedure SIRegister_TAggregatedObject(CL: TPSPascalCompiler);
procedure SIRegister_ZClasses(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TZAbstractObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TContainedObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAggregatedObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZClasses(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ZClasses
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZClasses]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZAbstractObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TZAbstractObject') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TZAbstractObject') do begin
    RegisterMethod('Function Equals( const Value : IZInterface) : Boolean;');
    RegisterMethod('Function GetHashCode : LongInt');
    RegisterMethod('Function Clone : IZInterface');
    RegisterMethod('Function ToString : string');
    RegisterMethod('Function InstanceOf( const IId : TGUID) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IZStack(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IZClonnable', 'IZStack') do
  with CL.AddInterface(CL.FindInterface('IZClonnable'),IZStack, 'IZStack') do begin
    RegisterMethod('Function Peek : IZInterface', cdRegister);
    RegisterMethod('Function Pop : IZInterface', cdRegister);
    RegisterMethod('Procedure Push( Value : IZInterface)', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IZHashMap(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IZClonnable', 'IZHashMap') do
  with CL.AddInterface(CL.FindInterface('IZClonnable'),IZHashMap, 'IZHashMap') do begin
    RegisterMethod('Function Get( const Key : IZInterface) : IZInterface', cdRegister);
    RegisterMethod('Procedure Put( const Key : IZInterface; const Value : IZInterface)', cdRegister);
    RegisterMethod('Function GetKeys : IZCollection', cdRegister);
    RegisterMethod('Function GetValues : IZCollection', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Function Remove( Key : IZInterface) : Boolean', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IZCollection(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IZClonnable', 'IZCollection') do
  with CL.AddInterface(CL.FindInterface('IZClonnable'),IZCollection, 'IZCollection') do
  begin
    RegisterMethod('Function Get( Index : Integer) : IZInterface', cdRegister);
    RegisterMethod('Procedure Put( Index : Integer; const Item : IZInterface)', cdRegister);
    RegisterMethod('Function IndexOf( const Item : IZInterface) : Integer', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Function GetIterator : IZIterator', cdRegister);
    RegisterMethod('Function First : IZInterface', cdRegister);
    RegisterMethod('Function Last : IZInterface', cdRegister);
    RegisterMethod('Function Add( const Item : IZInterface) : Integer', cdRegister);
    RegisterMethod('Procedure Insert( Index : Integer; const Item : IZInterface)', cdRegister);
    RegisterMethod('Function Remove( const Item : IZInterface) : Integer', cdRegister);
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)', cdRegister);
    RegisterMethod('Procedure Delete( Index : Integer)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Function Contains( const Item : IZInterface) : Boolean', cdRegister);
    RegisterMethod('Function ContainsAll( const Col : IZCollection) : Boolean', cdRegister);
    RegisterMethod('Function AddAll( const Col : IZCollection) : Boolean', cdRegister);
    RegisterMethod('Function RemoveAll( const Col : IZCollection) : Boolean', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IZIterator(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IZObject', 'IZIterator') do
  with CL.AddInterface(CL.FindInterface('IZObject'),IZIterator, 'IZIterator') do
  begin
    RegisterMethod('Function HasNext : Boolean', cdRegister);
    RegisterMethod('Function Next : IZInterface', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IZClonnable(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IZObject', 'IZClonnable') do
  with CL.AddInterface(CL.FindInterface('IZObject'),IZClonnable, 'IZClonnable') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IZComparable(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IZObject', 'IZComparable') do
  with CL.AddInterface(CL.FindInterface('IZObject'),IZComparable, 'IZComparable') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IZObject(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IZInterface', 'IZObject') do begin
  with CL.AddInterface(CL.FindInterface('IInterface'),IZObject, 'IZObject') do begin
    RegisterMethod('Function Equals( const Value : IInterface) : Boolean', cdRegister);
    RegisterMethod('Function GetHashCode : LongInt', cdRegister);
    RegisterMethod('Function Clone : IZInterface', cdRegister);
    RegisterMethod('Function ToString : string', cdRegister);
    RegisterMethod('Function InstanceOf( const IId : TGUID) : Boolean', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TContainedObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAggregatedObject', 'TContainedObject') do
  with CL.AddClassN(CL.FindClass('TAggregatedObject'),'TContainedObject') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAggregatedObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAggregatedObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAggregatedObject') do begin
    RegisterMethod('Constructor Create( const Controller : IInterface)');
    RegisterProperty('Controller', 'IInterface', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZClasses(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ZEOS_MAJOR_VERSION','LongInt').SetInt( 7);
 CL.AddConstantN('ZEOS_MINOR_VERSION','LongInt').SetInt( 1);
 CL.AddConstantN('ZEOS_SUB_VERSION','LongInt').SetInt( 2);
 CL.AddConstantN('ZEOS_STATUS','String').SetString( 'stable');
 CL.AddConstantN('ZEOS_VERSION','String').SetString( '7.1.2-stable');
 CL.AddConstantN('PooledPrefix','String').SetString( 'pooled.');
  //CL.AddTypeS('PDateTime', '^TDateTime // will not work');

  //CL.AddTypeS('IZInterface', 'IInterface');
  CL.AddTypeS('IZInterface', 'IUnknown');

  SIRegister_TAggregatedObject(CL);
  SIRegister_TContainedObject(CL);
  //CL.AddTypeS('IZInterface', 'IUnknown');
  SIRegister_IZObject(CL);
  SIRegister_IZComparable(CL);
  SIRegister_IZClonnable(CL);
  SIRegister_IZIterator(CL);
  SIRegister_IZCollection(CL);
  SIRegister_IZHashMap(CL);
  SIRegister_IZStack(CL);
  SIRegister_TZAbstractObject(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TZAbstractObjectEquals_P(Self: TZAbstractObject;  const Value : IZInterface) : Boolean;
Begin Result := Self.Equals(Value); END;

(*----------------------------------------------------------------------------*)
procedure TAggregatedObjectController_R(Self: TAggregatedObject; var T: IInterface);
begin T := Self.Controller; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZAbstractObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZAbstractObject) do begin
    RegisterVirtualMethod(@TZAbstractObjectEquals_P, 'Equals');
    RegisterMethod(@TZAbstractObject.GetHashCode, 'GetHashCode');
    RegisterVirtualMethod(@TZAbstractObject.Clone, 'Clone');
    RegisterMethod(@TZAbstractObject.ToString, 'ToString');
    RegisterMethod(@TZAbstractObject.InstanceOf, 'InstanceOf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TContainedObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TContainedObject) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAggregatedObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAggregatedObject) do
  begin
    RegisterConstructor(@TAggregatedObject.Create, 'Create');
    RegisterPropertyHelper(@TAggregatedObjectController_R,nil,'Controller');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZClasses(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAggregatedObject(CL);
  RIRegister_TContainedObject(CL);
  RIRegister_TZAbstractObject(CL);
end;

 
 
{ TPSImport_ZClasses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZClasses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZClasses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZClasses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
