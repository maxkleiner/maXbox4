unit uPSI_xrtl_util_Map;
{
   a map to keys
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
  TPSImport_xrtl_util_Map = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXRTLArrayMap(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLSynchronizedMap(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLMap(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_Map(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXRTLArrayMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLSynchronizedMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_util_Map(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   xrtl_util_Value
  ,xrtl_util_Lock
  ,xrtl_util_Type
  ,xrtl_util_Array
  ,xrtl_util_Container
  ,xrtl_util_Compat
  ,xrtl_util_Map
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_Map]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLArrayMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLMap', 'TXRTLArrayMap') do
  with CL.AddClassN(CL.FindClass('TXRTLMap'),'TXRTLArrayMap') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function GetKeys : TXRTLValueArray');
    RegisterMethod('Function GetValues : TXRTLValueArray');
    RegisterMethod('Function GetValue( const IKey : IXRTLValue) : IXRTLValue');
    RegisterMethod('Function SetValue( const IKey, IValue : IXRTLValue) : IXRTLValue');
    RegisterMethod('Function HasKey( const IKey : IXRTLValue) : Boolean');
    RegisterMethod('Function Remove( const IKey : IXRTLValue) : IXRTLValue');
    RegisterMethod('Function GetSize : Integer');
    RegisterMethod('Function GetCapacity : Integer');
    RegisterMethod('Procedure TrimToSize');
    RegisterMethod('Procedure EnsureCapacity( const ACapacity : Integer)');
    RegisterProperty('LoadFactor', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLSynchronizedMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLMap', 'TXRTLSynchronizedMap') do
  with CL.AddClassN(CL.FindClass('TXRTLMap'),'TXRTLSynchronizedMap') do begin
    RegisterMethod('Constructor Create( const ACoreMap : TXRTLMap; AOwnCoreMap : Boolean; const ALock : IXRTLReadWriteLock)');
    RegisterProperty('CoreMap', 'TXRTLMap', iptr);
    RegisterProperty('OwnCoreMap', 'Boolean', iptrw);
    RegisterProperty('Lock', 'IXRTLReadWriteLock', iptr);
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function GetKeys : TXRTLValueArray');
    RegisterMethod('Function GetValues : TXRTLValueArray');
    RegisterMethod('Function GetValue( const IKey : IXRTLValue) : IXRTLValue');
    RegisterMethod('Function SetValue( const IKey, IValue : IXRTLValue) : IXRTLValue;');
    RegisterMethod('Function HasKey( const IKey : IXRTLValue) : Boolean');
    RegisterMethod('Function Remove( const IKey : IXRTLValue) : IXRTLValue');
    RegisterMethod('Procedure BeginRead');
    RegisterMethod('Procedure EndRead');
    RegisterMethod('Procedure BeginWrite');
    RegisterMethod('Procedure EndWrite');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLKeyValueContainer', 'TXRTLMap') do
  with CL.AddClassN(CL.FindClass('TXRTLKeyValueContainer'),'TXRTLMap') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_Map(CL: TPSPascalCompiler);
begin
  SIRegister_TXRTLMap(CL);
  SIRegister_TXRTLSynchronizedMap(CL);
  SIRegister_TXRTLArrayMap(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXRTLArrayMapLoadFactor_W(Self: TXRTLArrayMap; const T: Double);
begin Self.LoadFactor := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLArrayMapLoadFactor_R(Self: TXRTLArrayMap; var T: Double);
begin T := Self.LoadFactor; end;

(*----------------------------------------------------------------------------*)
Function TXRTLSynchronizedMapSetValue_P(Self: TXRTLSynchronizedMap;  const IKey, IValue : IXRTLValue) : IXRTLValue;
Begin Result := Self.SetValue(IKey, IValue); END;

(*----------------------------------------------------------------------------*)
procedure TXRTLSynchronizedMapLock_R(Self: TXRTLSynchronizedMap; var T: IXRTLReadWriteLock);
begin T := Self.Lock; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLSynchronizedMapOwnCoreMap_W(Self: TXRTLSynchronizedMap; const T: Boolean);
begin Self.OwnCoreMap := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLSynchronizedMapOwnCoreMap_R(Self: TXRTLSynchronizedMap; var T: Boolean);
begin T := Self.OwnCoreMap; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLSynchronizedMapCoreMap_R(Self: TXRTLSynchronizedMap; var T: TXRTLMap);
begin T := Self.CoreMap; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLArrayMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLArrayMap) do
  begin
    RegisterConstructor(@TXRTLArrayMap.Create, 'Create');
    RegisterMethod(@TXRTLArrayMap.IsEmpty, 'IsEmpty');
    RegisterMethod(@TXRTLArrayMap.Clear, 'Clear');
    RegisterMethod(@TXRTLArrayMap.GetKeys, 'GetKeys');
    RegisterMethod(@TXRTLArrayMap.GetValues, 'GetValues');
    RegisterMethod(@TXRTLArrayMap.GetValue, 'GetValue');
    RegisterMethod(@TXRTLArrayMap.SetValue, 'SetValue');
    RegisterMethod(@TXRTLArrayMap.HasKey, 'HasKey');
    RegisterMethod(@TXRTLArrayMap.Remove, 'Remove');
    RegisterMethod(@TXRTLArrayMap.GetSize, 'GetSize');
    RegisterMethod(@TXRTLArrayMap.GetCapacity, 'GetCapacity');
    RegisterMethod(@TXRTLArrayMap.TrimToSize, 'TrimToSize');
    RegisterMethod(@TXRTLArrayMap.EnsureCapacity, 'EnsureCapacity');
    RegisterPropertyHelper(@TXRTLArrayMapLoadFactor_R,@TXRTLArrayMapLoadFactor_W,'LoadFactor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLSynchronizedMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLSynchronizedMap) do
  begin
    RegisterConstructor(@TXRTLSynchronizedMap.Create, 'Create');
    RegisterPropertyHelper(@TXRTLSynchronizedMapCoreMap_R,nil,'CoreMap');
    RegisterPropertyHelper(@TXRTLSynchronizedMapOwnCoreMap_R,@TXRTLSynchronizedMapOwnCoreMap_W,'OwnCoreMap');
    RegisterPropertyHelper(@TXRTLSynchronizedMapLock_R,nil,'Lock');
    RegisterMethod(@TXRTLSynchronizedMap.IsEmpty, 'IsEmpty');
    RegisterMethod(@TXRTLSynchronizedMap.Clear, 'Clear');
    RegisterMethod(@TXRTLSynchronizedMap.GetKeys, 'GetKeys');
    RegisterMethod(@TXRTLSynchronizedMap.GetValues, 'GetValues');
    RegisterMethod(@TXRTLSynchronizedMap.GetValue, 'GetValue');
    RegisterMethod(@TXRTLSynchronizedMapSetValue_P, 'SetValue');
    RegisterMethod(@TXRTLSynchronizedMap.HasKey, 'HasKey');
    RegisterMethod(@TXRTLSynchronizedMap.Remove, 'Remove');
    RegisterMethod(@TXRTLSynchronizedMap.BeginRead, 'BeginRead');
    RegisterMethod(@TXRTLSynchronizedMap.EndRead, 'EndRead');
    RegisterMethod(@TXRTLSynchronizedMap.BeginWrite, 'BeginWrite');
    RegisterMethod(@TXRTLSynchronizedMap.EndWrite, 'EndWrite');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLMap) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_Map(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLMap(CL);
  RIRegister_TXRTLSynchronizedMap(CL);
  RIRegister_TXRTLArrayMap(CL);
end;

 
 
{ TPSImport_xrtl_util_Map }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Map.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_Map(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Map.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_Map(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
