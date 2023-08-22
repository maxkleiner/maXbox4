unit uPSI_xrtl_util_COMUtils;
{
  all classes
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
  TPSImport_xrtl_util_COMUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TXRTLEnumString(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLEnumUnknown(CL: TPSPascalCompiler);
procedure SIRegister_TXRTLEnumXXXX(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_COMUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_COMUtils_Routines(S: TPSExec);
procedure RIRegister_TXRTLEnumString(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLEnumUnknown(CL: TPSRuntimeClassImporter);
procedure RIRegister_TXRTLEnumXXXX(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_util_COMUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,COMObj
  ,ActiveX
  ,xrtl_util_Value
  ,xrtl_util_Container
  ,xrtl_util_Array
  ,xrtl_util_Algorithm
  ,xrtl_util_COMUtils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_COMUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLEnumString(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLEnumXXXX', 'TXRTLEnumString') do
  with CL.AddClassN(CL.FindClass('TXRTLEnumXXXX'),'TXRTLEnumString') do begin
    RegisterMethod('Constructor Create( const AStrings : TStrings)');
    RegisterProperty('Strings', 'TXRTLArray', iptr);
    RegisterMethod('Function Clone( out enm : IEnumString) : HResult');
    RegisterMethod('Procedure Assign( const AStrings : TStrings);');
    RegisterMethod('Procedure Assign1( const AStrings : TXRTLArray);');
    RegisterMethod('Procedure Add( const S : WideString)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLEnumUnknown(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TXRTLEnumXXXX', 'TXRTLEnumUnknown') do
  with CL.AddClassN(CL.FindClass('TXRTLEnumXXXX'),'TXRTLEnumUnknown') do begin
    RegisterMethod('Constructor Create( const AItems : TXRTLArray)');
    RegisterMethod('Procedure Add( const Obj : Pointer)');
    RegisterProperty('Items', 'TXRTLArray', iptrw);
    RegisterMethod('Function Clone( out enm : IEnumUnknown) : HResult');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLEnumXXXX(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TXRTLEnumXXXX') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TXRTLEnumXXXX') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Next( celt : Longint; out elt, pceltFetched : PLongInt) : HResult');
    RegisterMethod('Function Skip( celt : Longint) : HResult');
    RegisterMethod('Function Reset : HResult');
    RegisterProperty('Count', 'LongInt', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_COMUtils(CL: TPSPascalCompiler);
begin
  SIRegister_TXRTLEnumXXXX(CL);
  SIRegister_TXRTLEnumUnknown(CL);
  SIRegister_TXRTLEnumString(CL);
 CL.AddDelphiFunction('Function XRTLHandleCOMException : HResult');
 CL.AddDelphiFunction('Procedure XRTLCheckArgument( Flag : Boolean)');
 //CL.AddDelphiFunction('Procedure XRTLCheckOutArgument( out Arg)');
 CL.AddDelphiFunction('Procedure XRTLInterfaceConnect( const Source : IUnknown; const IID : TIID; const Sink : IUnknown; var Connection : Longint)');
 CL.AddDelphiFunction('Procedure XRTLInterfaceDisconnect( const Source : IUnknown; const IID : TIID; var Connection : Longint)');
 CL.AddDelphiFunction('Function XRTLRegisterActiveObject( const Unk : IUnknown; ClassID : TCLSID; Flags : DWORD; var RegisterCookie : Integer) : HResult');
 CL.AddDelphiFunction('Function XRTLUnRegisterActiveObject( var RegisterCookie : Integer) : HResult');
 CL.AddDelphiFunction('Function XRTLGetActiveObject( ClassID : TCLSID; RIID : TIID; aUnknown: IUnknown) : HResult');
 CL.AddDelphiFunction('Procedure XRTLEnumActiveObjects( Strings : TStrings)');
 CL.AddConstantN('strole32','String').SetString( 'ole32.dll');
 //CL.AddDelphiFunction('Function CreateClassMoniker( const ClsID : TClsID; out Moniker : IMoniker) : HResult');
 //CL.AddDelphiFunction('Function XRTLAllocOutWideString( const Src : WideString) : PWideChar');
 //CL.AddDelphiFunction('Procedure XRTLFreeOutWideString( var Src : PWideChar)');
 //CL.AddDelphiFunction('Function XRTLWideStringToOLEStr( const Src : WideString) : POLEStr');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure TXRTLEnumStringAssign1_P(Self: TXRTLEnumString;  const AStrings : TXRTLArray);
Begin Self.Assign(AStrings); END;

(*----------------------------------------------------------------------------*)
Procedure TXRTLEnumStringAssign_P(Self: TXRTLEnumString;  const AStrings : TStrings);
Begin Self.Assign(AStrings); END;

(*----------------------------------------------------------------------------*)
procedure TXRTLEnumStringStrings_R(Self: TXRTLEnumString; var T: TXRTLArray);
begin T := Self.Strings; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLEnumUnknownItems_W(Self: TXRTLEnumUnknown; const T: TXRTLArray);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLEnumUnknownItems_R(Self: TXRTLEnumUnknown; var T: TXRTLArray);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLEnumXXXXCount_R(Self: TXRTLEnumXXXX; var T: LongInt);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_COMUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@XRTLHandleCOMException, 'XRTLHandleCOMException', cdRegister);
 S.RegisterDelphiFunction(@XRTLCheckArgument, 'XRTLCheckArgument', cdRegister);
 S.RegisterDelphiFunction(@XRTLCheckOutArgument, 'XRTLCheckOutArgument', cdRegister);
 S.RegisterDelphiFunction(@XRTLInterfaceConnect, 'XRTLInterfaceConnect', cdRegister);
 S.RegisterDelphiFunction(@XRTLInterfaceDisconnect, 'XRTLInterfaceDisconnect', cdRegister);
 S.RegisterDelphiFunction(@XRTLRegisterActiveObject, 'XRTLRegisterActiveObject', cdRegister);
 S.RegisterDelphiFunction(@XRTLUnRegisterActiveObject, 'XRTLUnRegisterActiveObject', cdRegister);
 S.RegisterDelphiFunction(@XRTLGetActiveObject, 'XRTLGetActiveObject', cdRegister);
 S.RegisterDelphiFunction(@XRTLEnumActiveObjects, 'XRTLEnumActiveObjects', cdRegister);
 S.RegisterDelphiFunction(@CreateClassMoniker, 'CreateClassMoniker', CdStdCall);
 S.RegisterDelphiFunction(@XRTLAllocOutWideString, 'XRTLAllocOutWideString', cdRegister);
 S.RegisterDelphiFunction(@XRTLFreeOutWideString, 'XRTLFreeOutWideString', cdRegister);
 S.RegisterDelphiFunction(@XRTLWideStringToOLEStr, 'XRTLWideStringToOLEStr', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLEnumString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLEnumString) do begin
    RegisterConstructor(@TXRTLEnumString.Create, 'Create');
    RegisterPropertyHelper(@TXRTLEnumStringStrings_R,nil,'Strings');
    RegisterMethod(@TXRTLEnumString.Clone, 'Clone');
    RegisterMethod(@TXRTLEnumStringAssign_P, 'Assign');
    RegisterMethod(@TXRTLEnumStringAssign1_P, 'Assign1');
    RegisterMethod(@TXRTLEnumString.Add, 'Add');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLEnumUnknown(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLEnumUnknown) do begin
    RegisterConstructor(@TXRTLEnumUnknown.Create, 'Create');
    RegisterMethod(@TXRTLEnumUnknown.Add, 'Add');
    RegisterPropertyHelper(@TXRTLEnumUnknownItems_R,@TXRTLEnumUnknownItems_W,'Items');
    RegisterMethod(@TXRTLEnumUnknown.Clone, 'Clone');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLEnumXXXX(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLEnumXXXX) do begin
    RegisterConstructor(@TXRTLEnumXXXX.Create, 'Create');
    RegisterMethod(@TXRTLEnumXXXX.Next, 'Next');
    RegisterMethod(@TXRTLEnumXXXX.Skip, 'Skip');
    RegisterMethod(@TXRTLEnumXXXX.Reset, 'Reset');
    RegisterPropertyHelper(@TXRTLEnumXXXXCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_COMUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLEnumXXXX(CL);
  RIRegister_TXRTLEnumUnknown(CL);
  RIRegister_TXRTLEnumString(CL);
end;



{ TPSImport_xrtl_util_COMUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_COMUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_COMUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_COMUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_COMUtils(ri);
  RIRegister_xrtl_util_COMUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
