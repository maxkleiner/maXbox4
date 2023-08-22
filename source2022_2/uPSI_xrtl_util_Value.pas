unit uPSI_xrtl_util_Value;
{
  more value variants
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
  TPSImport_xrtl_util_Value = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXRTLValue(CL: TPSPascalCompiler);
procedure SIRegister_IXRTLValue(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_Value(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_Value_Routines(S: TPSExec);
procedure RIRegister_TXRTLValue(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_util_Value(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Variants
  ,xrtl_util_Compare
  ,xrtl_util_Type
  ,xrtl_util_Compat
  ,xrtl_util_Value
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_Value]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLValue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TXRTLValue') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TXRTLValue') do begin
    RegisterMethod('Function Compare( const IValue : TObject) : TXRTLValueRelationship');
    RegisterMethod('Function GetHashCode : Cardinal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IXRTLValue(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IXRTLComparable', 'IXRTLValue') do
  with CL.AddInterface(CL.FindInterface('IXRTLComparable'),IXRTLValue, 'IXRTLValue') do
  begin
    RegisterMethod('Function GetHashCode : Cardinal', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_Value(CL: TPSPascalCompiler);
begin
  SIRegister_IXRTLValue(CL);
  SIRegister_TXRTLValue(CL);
  //CL.AddTypeS('PXRTLValueArray', '^TXRTLValueArray // will not work');
  CL.AddTypeS('TXRTLValueArray', 'array of IXRTLValue');
 CL.AddDelphiFunction('Function XRTLValue( const AValue : Cardinal) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue( const IValue : IXRTLValue; const AValue : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function XRTLGetAsCardinal( const IValue : IXRTLValue) : Cardinal');
 CL.AddDelphiFunction('Function XRTLGetAsCardinalDef( const IValue : IXRTLValue; const DefValue : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function XRTLValue1( const AValue : Integer) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue1( const IValue : IXRTLValue; const AValue : Integer) : Integer;');
 CL.AddDelphiFunction('Function XRTLGetAsInteger( const IValue : IXRTLValue) : Integer');
 CL.AddDelphiFunction('Function XRTLGetAsIntegerDef( const IValue : IXRTLValue; const DefValue : Integer) : Integer');
 CL.AddDelphiFunction('Function XRTLValue2( const AValue : Int64) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue2( const IValue : IXRTLValue; const AValue : Int64) : Int64;');
 CL.AddDelphiFunction('Function XRTLGetAsInt64( const IValue : IXRTLValue) : Int64');
 CL.AddDelphiFunction('Function XRTLGetAsInt64Def( const IValue : IXRTLValue; const DefValue : Int64) : Int64');
 CL.AddDelphiFunction('Function XRTLValue3( const AValue : Single) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue3( const IValue : IXRTLValue; const AValue : Single) : Single;');
 CL.AddDelphiFunction('Function XRTLGetAsSingle( const IValue : IXRTLValue) : Single');
 CL.AddDelphiFunction('Function XRTLGetAsSingleDef( const IValue : IXRTLValue; const DefValue : Single) : Single');
 CL.AddDelphiFunction('Function XRTLValue4( const AValue : Double) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue4( const IValue : IXRTLValue; const AValue : Double) : Double;');
 CL.AddDelphiFunction('Function XRTLGetAsDouble( const IValue : IXRTLValue) : Double');
 CL.AddDelphiFunction('Function XRTLGetAsDoubleDef( const IValue : IXRTLValue; const DefValue : Double) : Double');
 CL.AddDelphiFunction('Function XRTLValue5( const AValue : Extended) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue5( const IValue : IXRTLValue; const AValue : Extended) : Extended;');
 CL.AddDelphiFunction('Function XRTLGetAsExtended( const IValue : IXRTLValue) : Extended');
 CL.AddDelphiFunction('Function XRTLGetAsExtendedDef( const IValue : IXRTLValue; const DefValue : Extended) : Extended');
 CL.AddDelphiFunction('Function XRTLValue6( const AValue : IInterface) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue6( const IValue : IXRTLValue; const AValue : IInterface) : IInterface;');
 CL.AddDelphiFunction('Function XRTLGetAsInterface( const IValue : IXRTLValue) : IInterface;');
 //CL.AddDelphiFunction('Function XRTLGetAsInterface1( const IValue : IXRTLValue; out Obj) : IInterface;');
 CL.AddDelphiFunction('Function XRTLGetAsInterfaceDef( const IValue : IXRTLValue; const DefValue : IInterface) : IInterface;');
 CL.AddDelphiFunction('Function XRTLValue7( const AValue : WideString) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue7( const IValue : IXRTLValue; const AValue : WideString) : WideString;');
 CL.AddDelphiFunction('Function XRTLGetAsWideString( const IValue : IXRTLValue) : WideString');
 CL.AddDelphiFunction('Function XRTLGetAsWideStringDef( const IValue : IXRTLValue; const DefValue : WideString) : WideString');
 CL.AddDelphiFunction('Function XRTLValue8( const AValue : TObject; const AOwnValue : Boolean) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue8( const IValue : IXRTLValue; const AValue : TObject) : TObject;');
 CL.AddDelphiFunction('Function XRTLGetAsObject( const IValue : IXRTLValue; const ADetachOwnership : Boolean) : TObject;');
 CL.AddDelphiFunction('Function XRTLGetAsObjectDef( const IValue : IXRTLValue; const DefValue : TObject; const ADetachOwnership : Boolean) : TObject;');
// CL.AddDelphiFunction('Function XRTLValue9( const AValue : __Pointer) : IXRTLValue;');
 //CL.AddDelphiFunction('Function XRTLSetValue9( const IValue : IXRTLValue; const AValue : __Pointer) : __Pointer;');
// CL.AddDelphiFunction('Function XRTLGetAsPointer( const IValue : IXRTLValue) : __Pointer');
// CL.AddDelphiFunction('Function XRTLGetAsPointerDef( const IValue : IXRTLValue; const DefValue : __Pointer) : __Pointer');
 CL.AddDelphiFunction('Function XRTLValueV( const AValue : Variant) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValueV( const IValue : IXRTLValue; const AValue : Variant) : Variant;');
 CL.AddDelphiFunction('Function XRTLGetAsVariant( const IValue : IXRTLValue) : Variant');
 CL.AddDelphiFunction('Function XRTLGetAsVariantDef( const IValue : IXRTLValue; const DefValue : Variant) : Variant');
 CL.AddDelphiFunction('Function XRTLValue10( const AValue : Currency) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue10( const IValue : IXRTLValue; const AValue : Currency) : Currency;');
 CL.AddDelphiFunction('Function XRTLGetAsCurrency( const IValue : IXRTLValue) : Currency');
 CL.AddDelphiFunction('Function XRTLGetAsCurrencyDef( const IValue : IXRTLValue; const DefValue : Currency) : Currency');
 CL.AddDelphiFunction('Function XRTLValue11( const AValue : Comp) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue11( const IValue : IXRTLValue; const AValue : Comp) : Comp;');
 CL.AddDelphiFunction('Function XRTLGetAsComp( const IValue : IXRTLValue) : Comp');
 CL.AddDelphiFunction('Function XRTLGetAsCompDef( const IValue : IXRTLValue; const DefValue : Comp) : Comp');
 CL.AddDelphiFunction('Function XRTLValue12( const AValue : TClass) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue12( const IValue : IXRTLValue; const AValue : TClass) : TClass;');
 CL.AddDelphiFunction('Function XRTLGetAsClass( const IValue : IXRTLValue) : TClass');
 CL.AddDelphiFunction('Function XRTLGetAsClassDef( const IValue : IXRTLValue; const DefValue : TClass) : TClass');
 CL.AddDelphiFunction('Function XRTLValue13( const AValue : TGUID) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue13( const IValue : IXRTLValue; const AValue : TGUID) : TGUID;');
 CL.AddDelphiFunction('Function XRTLGetAsGUID( const IValue : IXRTLValue) : TGUID');
 CL.AddDelphiFunction('Function XRTLGetAsGUIDDef( const IValue : IXRTLValue; const DefValue : TGUID) : TGUID');
 CL.AddDelphiFunction('Function XRTLValue14( const AValue : Boolean) : IXRTLValue;');
 CL.AddDelphiFunction('Function XRTLSetValue14( const IValue : IXRTLValue; const AValue : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function XRTLGetAsBoolean( const IValue : IXRTLValue) : Boolean');
 CL.AddDelphiFunction('Function XRTLGetAsBooleanDef( const IValue : IXRTLValue; const DefValue : Boolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function XRTLSetValue14_P( const IValue : IXRTLValue; const AValue : Boolean) : Boolean;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue14_P( const AValue : Boolean) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue13_P( const IValue : IXRTLValue; const AValue : TGUID) : TGUID;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue13_P( const AValue : TGUID) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue12_P( const IValue : IXRTLValue; const AValue : TClass) : TClass;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue12_P( const AValue : TClass) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue11_P( const IValue : IXRTLValue; const AValue : Comp) : Comp;
Begin //Result := xrtl_util_Value.XRTLSetValue(IValue, AValue);
END;

(*----------------------------------------------------------------------------*)
Function XRTLValue11_P( const AValue : Comp) : IXRTLValue;
Begin //Result := xrtl_util_Value.XRTLValue(AValue);
 END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue10_P( const IValue : IXRTLValue; const AValue : Currency) : Currency;
Begin //Result := xrtl_util_Value.XRTLSetValue(IValue, AValue);
END;

(*----------------------------------------------------------------------------*)
Function XRTLValue10_P( const AValue : Currency) : IXRTLValue;
Begin //Result := xrtl_util_Value.XRTLValue(AValue);
END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValueV_P( const IValue : IXRTLValue; const AValue : Variant) : Variant;
Begin Result := xrtl_util_Value.XRTLSetValueV(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValueV_P( const AValue : Variant) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValueV(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue9_P( const IValue : IXRTLValue; const AValue : Pointer) : Pointer;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue9_P( const AValue : Pointer) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLGetAsObjectDef_P( const IValue : IXRTLValue; const DefValue : TObject; const ADetachOwnership : Boolean) : TObject;
Begin Result := xrtl_util_Value.XRTLGetAsObjectDef(IValue, DefValue, ADetachOwnership); END;

(*----------------------------------------------------------------------------*)
Function XRTLGetAsObject_P( const IValue : IXRTLValue; const ADetachOwnership : Boolean) : TObject;
Begin Result := xrtl_util_Value.XRTLGetAsObject(IValue, ADetachOwnership); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue8_P( const IValue : IXRTLValue; const AValue : TObject) : TObject;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue8_P( const AValue : TObject; const AOwnValue : Boolean) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue, AOwnValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue7_P( const IValue : IXRTLValue; const AValue : WideString) : WideString;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue7_P( const AValue : WideString) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLGetAsInterfaceDef_P( const IValue : IXRTLValue; const DefValue : IInterface) : IInterface;
Begin Result := xrtl_util_Value.XRTLGetAsInterfaceDef(IValue, DefValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLGetAsInterface1_P( const IValue : IXRTLValue; out Obj) : IInterface;
Begin Result := xrtl_util_Value.XRTLGetAsInterface(IValue, Obj); END;

(*----------------------------------------------------------------------------*)
Function XRTLGetAsInterface_P( const IValue : IXRTLValue) : IInterface;
Begin Result := xrtl_util_Value.XRTLGetAsInterface(IValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue6_P( const IValue : IXRTLValue; const AValue : IInterface) : IInterface;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue6_P( const AValue : IInterface) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue5_P( const IValue : IXRTLValue; const AValue : Extended) : Extended;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue5_P( const AValue : Extended) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue4_P( const IValue : IXRTLValue; const AValue : Double) : Double;
Begin //Result := xrtl_util_Value.XRTLSetValue(IValue, AValue);
END;

(*----------------------------------------------------------------------------*)
Function XRTLValue4_P( const AValue : Double) : IXRTLValue;
Begin //Result := xrtl_util_Value.XRTLValue(AValue);
END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue3_P( const IValue : IXRTLValue; const AValue : Single) : Single;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue3_P( const AValue : Single) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue2_P( const IValue : IXRTLValue; const AValue : Int64) : Int64;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue2_P( const AValue : Int64) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue1_P( const IValue : IXRTLValue; const AValue : Integer) : Integer;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue1_P( const AValue : Integer) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLSetValue_P( const IValue : IXRTLValue; const AValue : Cardinal) : Cardinal;
Begin Result := xrtl_util_Value.XRTLSetValue(IValue, AValue); END;

(*----------------------------------------------------------------------------*)
Function XRTLValue_P( const AValue : Cardinal) : IXRTLValue;
Begin Result := xrtl_util_Value.XRTLValue(AValue); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_Value_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLValue, 'XRTLValue', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue, 'XRTLSetValue', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsCardinal, 'XRTLGetAsCardinal', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsCardinalDef, 'XRTLGetAsCardinalDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue1_P, 'XRTLValue1', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue1_P, 'XRTLSetValue1', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsInteger, 'XRTLGetAsInteger', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsIntegerDef, 'XRTLGetAsIntegerDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue2_P, 'XRTLValue2', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue2_P, 'XRTLSetValue2', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsInt64, 'XRTLGetAsInt64', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsInt64Def, 'XRTLGetAsInt64Def', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue3_P, 'XRTLValue3', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue3_P, 'XRTLSetValue3', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsSingle, 'XRTLGetAsSingle', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsSingleDef, 'XRTLGetAsSingleDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue4_P, 'XRTLValue4', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue4_P, 'XRTLSetValue4', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsDouble, 'XRTLGetAsDouble', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsDoubleDef, 'XRTLGetAsDoubleDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue5_P, 'XRTLValue5', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue5_P, 'XRTLSetValue5', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsExtended, 'XRTLGetAsExtended', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsExtendedDef, 'XRTLGetAsExtendedDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue6_P, 'XRTLValue6', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue6_P, 'XRTLSetValue6', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsInterface, 'XRTLGetAsInterface', cdRegister);
 // S.RegisterDelphiFunction(@XRTLGetAsInterface1, 'XRTLGetAsInterface1', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsInterfaceDef, 'XRTLGetAsInterfaceDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue7_P, 'XRTLValue7', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue7_P, 'XRTLSetValue7', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsWideString, 'XRTLGetAsWideString', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsWideStringDef, 'XRTLGetAsWideStringDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue8_P, 'XRTLValue8', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue8_P, 'XRTLSetValue8', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsObject, 'XRTLGetAsObject', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsObjectDef, 'XRTLGetAsObjectDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue9_P, 'XRTLValue9', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue9_P, 'XRTLSetValue9', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsPointer, 'XRTLGetAsPointer', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsPointerDef, 'XRTLGetAsPointerDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValueV, 'XRTLValueV', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValueV, 'XRTLSetValueV', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsVariant, 'XRTLGetAsVariant', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsVariantDef, 'XRTLGetAsVariantDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue10_P, 'XRTLValue10', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue10_P, 'XRTLSetValue10', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsCurrency, 'XRTLGetAsCurrency', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsCurrencyDef, 'XRTLGetAsCurrencyDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue11_P, 'XRTLValue11', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue11_P, 'XRTLSetValue11', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsComp, 'XRTLGetAsComp', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsCompDef, 'XRTLGetAsCompDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue12_P, 'XRTLValue12', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue12_P, 'XRTLSetValue12', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsClass, 'XRTLGetAsClass', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsClassDef, 'XRTLGetAsClassDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue13_P, 'XRTLValue13', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue13_P, 'XRTLSetValue13', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsGUID, 'XRTLGetAsGUID', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsGUIDDef, 'XRTLGetAsGUIDDef', cdRegister);
 S.RegisterDelphiFunction(@XRTLValue14_P, 'XRTLValue14', cdRegister);
 S.RegisterDelphiFunction(@XRTLSetValue14_P, 'XRTLSetValue14', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsBoolean, 'XRTLGetAsBoolean', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetAsBooleanDef, 'XRTLGetAsBooleanDef', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLValue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLValue) do begin
    //RegisterVirtualAbstractMethod(@TXRTLValue, @!.Compare, 'Compare');
    //RegisterVirtualAbstractMethod(@TXRTLValue, @!.GetHashCode, 'GetHashCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_Value(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLValue(CL);
end;

 
 
{ TPSImport_xrtl_util_Value }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Value.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_Value(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Value.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_Value_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
