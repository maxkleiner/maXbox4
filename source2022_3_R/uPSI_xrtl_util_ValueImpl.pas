unit uPSI_xrtl_util_ValueImpl;
{
retyper recompiler repiler

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
  TPSImport_xrtl_util_ValueImpl = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXRTLValueBoolean(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueBoolean(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueGUID(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueGUID(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueClass(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueClass(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueComp(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueComp(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueCurrency(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueCurrency(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueVariant(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueVariant(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValuePointer(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValuePointer(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueObject(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueObject(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueWideString(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueWideString(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueInterface(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueInterface(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueExtended(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueExtended(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueDouble(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueDouble(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueSingle(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueSingle(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueInt64(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueInt64(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueInteger(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueInteger(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueCardinal(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValueCardinal(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLValueBase(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_ValueImpl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXRTLValueBoolean(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueGUID(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueComp(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueCurrency(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueVariant(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValuePointer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueWideString(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueInterface(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueExtended(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueDouble(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueSingle(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueInt64(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueInteger(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueCardinal(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLValueBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_util_ValueImpl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,xrtl_util_Compare
  ,xrtl_util_Type
  ,xrtl_util_Value
  ,xrtl_util_Compat
  ,xrtl_util_ValueImpl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_ValueImpl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueBoolean(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueBoolean') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueBoolean') do
  begin
    RegisterMethod('Constructor Create( const AValue : Boolean)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Boolean');
    RegisterMethod('Function SetValue( const AValue : Boolean) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueBoolean(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueBoolean') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueBoolean, 'IXRTLValueBoolean') do
  begin
    RegisterMethod('Function GetValue : Boolean', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Boolean) : Boolean', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueGUID(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueGUID') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueGUID') do
  begin
    RegisterMethod('Constructor Create( const AValue : TGUID)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : TGUID');
    RegisterMethod('Function SetValue( const AValue : TGUID) : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueGUID(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueGUID') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueGUID, 'IXRTLValueGUID') do
  begin
    RegisterMethod('Function GetValue : TGUID', cdRegister);
    RegisterMethod('Function SetValue( const AValue : TGUID) : TGUID', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueClass') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueClass') do
  begin
    RegisterMethod('Constructor Create( const AValue : TClass)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : TClass');
    RegisterMethod('Function SetValue( const AValue : TClass) : TClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueClass(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueClass') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueClass, 'IXRTLValueClass') do
  begin
    RegisterMethod('Function GetValue : TClass', cdRegister);
    RegisterMethod('Function SetValue( const AValue : TClass) : TClass', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueComp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueComp') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueComp') do
  begin
    RegisterMethod('Constructor Create( const AValue : Comp)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Comp');
    RegisterMethod('Function SetValue( const AValue : Comp) : Comp');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueComp(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueComp') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueComp, 'IXRTLValueComp') do
  begin
    RegisterMethod('Function GetValue : Comp', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Comp) : Comp', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueCurrency(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueCurrency') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueCurrency') do
  begin
    RegisterMethod('Constructor Create( const AValue : Currency)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Currency');
    RegisterMethod('Function SetValue( const AValue : Currency) : Currency');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueCurrency(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueCurrency') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueCurrency, 'IXRTLValueCurrency') do
  begin
    RegisterMethod('Function GetValue : Currency', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Currency) : Currency', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueVariant(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueVariant') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueVariant') do
  begin
    RegisterMethod('Constructor Create( const AValue : Variant)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Variant');
    RegisterMethod('Function SetValue( const AValue : Variant) : Variant');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueVariant(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueVariant') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueVariant, 'IXRTLValueVariant') do
  begin
    RegisterMethod('Function GetValue : Variant', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Variant) : Variant', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValuePointer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValuePointer') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValuePointer') do
  begin
    RegisterMethod('Constructor Create( const AValue : Pointer)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Pointer');
    RegisterMethod('Function SetValue( const AValue : Pointer) : Pointer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValuePointer(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValuePointer') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValuePointer, 'IXRTLValuePointer') do
  begin
    RegisterMethod('Function GetValue : Pointer', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Pointer) : Pointer', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueObject') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueObject') do
  begin
    RegisterMethod('Constructor Create( const AValue : TObject; const AOwnValue : Boolean)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue( const ADetachOwnership : Boolean) : TObject');
    RegisterMethod('Function SetValue( const AValue : TObject) : TObject');
    RegisterProperty('OwnValue', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueObject(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueObject') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueObject, 'IXRTLValueObject') do
  begin
    RegisterMethod('Function GetValue( const ADetachOwnership : Boolean) : TObject', cdRegister);
    RegisterMethod('Function SetValue( const AValue : TObject) : TObject', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueWideString(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueWideString') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueWideString') do
  begin
    RegisterMethod('Constructor Create( const AValue : WideString)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : WideString');
    RegisterMethod('Function SetValue( const AValue : WideString) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueWideString(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueWideString') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueWideString, 'IXRTLValueWideString') do
  begin
    RegisterMethod('Function GetValue : WideString', cdRegister);
    RegisterMethod('Function SetValue( const AValue : WideString) : WideString', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueInterface(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueInterface') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueInterface') do
  begin
    RegisterMethod('Constructor Create( const AValue : IInterface)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : IInterface');
    RegisterMethod('Function SetValue( const AValue : IInterface) : IInterface');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueInterface(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueInterface') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueInterface, 'IXRTLValueInterface') do
  begin
    RegisterMethod('Function GetValue : IInterface', cdRegister);
    RegisterMethod('Function SetValue( const AValue : IInterface) : IInterface', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueExtended(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueExtended') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueExtended') do
  begin
    RegisterMethod('Constructor Create( const AValue : Extended)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Extended');
    RegisterMethod('Function SetValue( const AValue : Extended) : Extended');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueExtended(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueExtended') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueExtended, 'IXRTLValueExtended') do
  begin
    RegisterMethod('Function GetValue : Extended', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Extended) : Extended', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueDouble(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueDouble') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueDouble') do
  begin
    RegisterMethod('Constructor Create( const AValue : Double)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Double');
    RegisterMethod('Function SetValue( const AValue : Double) : Double');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueDouble(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueDouble') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueDouble, 'IXRTLValueDouble') do
  begin
    RegisterMethod('Function GetValue : Double', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Double) : Double', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueSingle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueSingle') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueSingle') do
  begin
    RegisterMethod('Constructor Create( const AValue : Single)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Single');
    RegisterMethod('Function SetValue( const AValue : Single) : Single');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueSingle(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueSingle') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueSingle, 'IXRTLValueSingle') do
  begin
    RegisterMethod('Function GetValue : Single', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Single) : Single', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueInt64(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueInt64') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueInt64') do
  begin
    RegisterMethod('Constructor Create( const AValue : Int64)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Int64');
    RegisterMethod('Function SetValue( const AValue : Int64) : Int64');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueInt64(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueInt64') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueInt64, 'IXRTLValueInt64') do
  begin
    RegisterMethod('Function GetValue : Int64', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Int64) : Int64', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueInteger(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueInteger') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueInteger') do
  begin
    RegisterMethod('Constructor Create( const AValue : Integer)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Integer');
    RegisterMethod('Function SetValue( const AValue : Integer) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueInteger(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueInteger') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueInteger, 'IXRTLValueInteger') do
  begin
    RegisterMethod('Function GetValue : Integer', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Integer) : Integer', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueCardinal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLValueBase', 'TXRTLValueCardinal') do
  with CL.AddClassN(CL.FindClass('TXRTLValueBase'),'TXRTLValueCardinal') do
  begin
    RegisterMethod('Constructor Create( const AValue : Cardinal)');
    RegisterMethod('Function Compare( const IValue : IInterface) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
    RegisterMethod('Function GetValue : Cardinal');
    RegisterMethod('Function SetValue( const AValue : Cardinal) : Cardinal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValueCardinal(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLValue', 'IXRTLValueCardinal') do
  with CL.AddInterface(CL.FindInterface('IXRTLValue'),IXRTLValueCardinal, 'IXRTLValueCardinal') do
  begin
    RegisterMethod('Function GetValue : Cardinal', cdRegister);
    RegisterMethod('Function SetValue( const AValue : Cardinal) : Cardinal', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValueBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLImplementationObjectProvider', 'TXRTLValueBase') do
  with CL.AddClassN(CL.FindClass('TXRTLImplementationObjectProvider'),'TXRTLValueBase') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_ValueImpl(CL: TPSPascalCompiler);
begin
  SIRegister_TXRTLValueBase(CL);
  SIRegister_IXRTLValueCardinal(CL);
  SIRegister_TXRTLValueCardinal(CL);
  SIRegister_IXRTLValueInteger(CL);
  SIRegister_TXRTLValueInteger(CL);
  SIRegister_IXRTLValueInt64(CL);
  SIRegister_TXRTLValueInt64(CL);
  SIRegister_IXRTLValueSingle(CL);
  SIRegister_TXRTLValueSingle(CL);
  SIRegister_IXRTLValueDouble(CL);
  SIRegister_TXRTLValueDouble(CL);
  SIRegister_IXRTLValueExtended(CL);
  SIRegister_TXRTLValueExtended(CL);
  SIRegister_IXRTLValueInterface(CL);
  SIRegister_TXRTLValueInterface(CL);
  SIRegister_IXRTLValueWideString(CL);
  SIRegister_TXRTLValueWideString(CL);
  SIRegister_IXRTLValueObject(CL);
  SIRegister_TXRTLValueObject(CL);
  SIRegister_IXRTLValuePointer(CL);
  SIRegister_TXRTLValuePointer(CL);
  SIRegister_IXRTLValueVariant(CL);
  SIRegister_TXRTLValueVariant(CL);
  SIRegister_IXRTLValueCurrency(CL);
  SIRegister_TXRTLValueCurrency(CL);
  SIRegister_IXRTLValueComp(CL);
  SIRegister_TXRTLValueComp(CL);
  SIRegister_IXRTLValueClass(CL);
  SIRegister_TXRTLValueClass(CL);
  SIRegister_IXRTLValueGUID(CL);
  SIRegister_TXRTLValueGUID(CL);
  SIRegister_IXRTLValueBoolean(CL);
  SIRegister_TXRTLValueBoolean(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXRTLValueObjectOwnValue_W(Self: TXRTLValueObject; const T: Boolean);
begin Self.OwnValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLValueObjectOwnValue_R(Self: TXRTLValueObject; var T: Boolean);
begin T := Self.OwnValue; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueBoolean(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueBoolean) do
  begin
    RegisterConstructor(@TXRTLValueBoolean.Create, 'Create');
    RegisterMethod(@TXRTLValueBoolean.Compare, 'Compare');
    RegisterMethod(@TXRTLValueBoolean.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueBoolean.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueBoolean.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueGUID(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueGUID) do
  begin
    RegisterConstructor(@TXRTLValueGUID.Create, 'Create');
    RegisterMethod(@TXRTLValueGUID.Compare, 'Compare');
    RegisterMethod(@TXRTLValueGUID.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueGUID.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueGUID.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueClass) do
  begin
    RegisterConstructor(@TXRTLValueClass.Create, 'Create');
    RegisterMethod(@TXRTLValueClass.Compare, 'Compare');
    RegisterMethod(@TXRTLValueClass.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueClass.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueClass.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueComp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueComp) do
  begin
    RegisterConstructor(@TXRTLValueComp.Create, 'Create');
    RegisterMethod(@TXRTLValueComp.Compare, 'Compare');
    RegisterMethod(@TXRTLValueComp.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueComp.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueComp.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueCurrency(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueCurrency) do
  begin
    RegisterConstructor(@TXRTLValueCurrency.Create, 'Create');
    RegisterMethod(@TXRTLValueCurrency.Compare, 'Compare');
    RegisterMethod(@TXRTLValueCurrency.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueCurrency.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueCurrency.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueVariant(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueVariant) do
  begin
    RegisterConstructor(@TXRTLValueVariant.Create, 'Create');
    RegisterMethod(@TXRTLValueVariant.Compare, 'Compare');
    RegisterMethod(@TXRTLValueVariant.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueVariant.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueVariant.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValuePointer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValuePointer) do
  begin
    RegisterConstructor(@TXRTLValuePointer.Create, 'Create');
    RegisterMethod(@TXRTLValuePointer.Compare, 'Compare');
    RegisterMethod(@TXRTLValuePointer.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValuePointer.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValuePointer.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueObject) do
  begin
    RegisterConstructor(@TXRTLValueObject.Create, 'Create');
    RegisterMethod(@TXRTLValueObject.Compare, 'Compare');
    RegisterMethod(@TXRTLValueObject.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueObject.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueObject.SetValue, 'SetValue');
    RegisterPropertyHelper(@TXRTLValueObjectOwnValue_R,@TXRTLValueObjectOwnValue_W,'OwnValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueWideString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueWideString) do
  begin
    RegisterConstructor(@TXRTLValueWideString.Create, 'Create');
    RegisterMethod(@TXRTLValueWideString.Compare, 'Compare');
    RegisterMethod(@TXRTLValueWideString.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueWideString.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueWideString.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueInterface(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueInterface) do
  begin
    RegisterConstructor(@TXRTLValueInterface.Create, 'Create');
    RegisterMethod(@TXRTLValueInterface.Compare, 'Compare');
    RegisterMethod(@TXRTLValueInterface.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueInterface.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueInterface.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueExtended(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueExtended) do
  begin
    RegisterConstructor(@TXRTLValueExtended.Create, 'Create');
    RegisterMethod(@TXRTLValueExtended.Compare, 'Compare');
    RegisterMethod(@TXRTLValueExtended.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueExtended.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueExtended.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueDouble(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueDouble) do
  begin
    RegisterConstructor(@TXRTLValueDouble.Create, 'Create');
    RegisterMethod(@TXRTLValueDouble.Compare, 'Compare');
    RegisterMethod(@TXRTLValueDouble.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueDouble.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueDouble.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueSingle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueSingle) do
  begin
    RegisterConstructor(@TXRTLValueSingle.Create, 'Create');
    RegisterMethod(@TXRTLValueSingle.Compare, 'Compare');
    RegisterMethod(@TXRTLValueSingle.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueSingle.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueSingle.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueInt64(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueInt64) do
  begin
    RegisterConstructor(@TXRTLValueInt64.Create, 'Create');
    RegisterMethod(@TXRTLValueInt64.Compare, 'Compare');
    RegisterMethod(@TXRTLValueInt64.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueInt64.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueInt64.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueInteger(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueInteger) do
  begin
    RegisterConstructor(@TXRTLValueInteger.Create, 'Create');
    RegisterMethod(@TXRTLValueInteger.Compare, 'Compare');
    RegisterMethod(@TXRTLValueInteger.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueInteger.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueInteger.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueCardinal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueCardinal) do
  begin
    RegisterConstructor(@TXRTLValueCardinal.Create, 'Create');
    RegisterMethod(@TXRTLValueCardinal.Compare, 'Compare');
    RegisterMethod(@TXRTLValueCardinal.GetHashCode, 'GetHashCode');
    RegisterMethod(@TXRTLValueCardinal.GetValue, 'GetValue');
    RegisterMethod(@TXRTLValueCardinal.SetValue, 'SetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValueBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValueBase) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_ValueImpl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLValueBase(CL);
  RIRegister_TXRTLValueCardinal(CL);
  RIRegister_TXRTLValueInteger(CL);
  RIRegister_TXRTLValueInt64(CL);
  RIRegister_TXRTLValueSingle(CL);
  RIRegister_TXRTLValueDouble(CL);
  RIRegister_TXRTLValueExtended(CL);
  RIRegister_TXRTLValueInterface(CL);
  RIRegister_TXRTLValueWideString(CL);
  RIRegister_TXRTLValueObject(CL);
  RIRegister_TXRTLValuePointer(CL);
  RIRegister_TXRTLValueVariant(CL);
  RIRegister_TXRTLValueCurrency(CL);
  RIRegister_TXRTLValueComp(CL);
  RIRegister_TXRTLValueClass(CL);
  RIRegister_TXRTLValueGUID(CL);
  RIRegister_TXRTLValueBoolean(CL);
end;

 
 
{ TPSImport_xrtl_util_ValueImpl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_ValueImpl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_ValueImpl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_ValueImpl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_ValueImpl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
