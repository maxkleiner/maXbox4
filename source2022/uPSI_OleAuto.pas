unit uPSI_OleAuto;
{
  another COM

  fix  CL.AddClassN(CL.FindClass('Exception'),'EOleError');
          now in COMObjoleDButils !
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
  TPSImport_OleAuto = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
//procedure SIRegister_EOleException(CL: TPSPascalCompiler);
//procedure SIRegister_EOleSysError(CL: TPSPascalCompiler);
procedure SIRegister_TAutomation(CL: TPSPascalCompiler);
procedure SIRegister_TRegistryClass(CL: TPSPascalCompiler);
procedure SIRegister_TAutoObject(CL: TPSPascalCompiler);
procedure SIRegister_TAutoDispatch(CL: TPSPascalCompiler);
procedure SIRegister_OleAuto(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OleAuto_Routines(S: TPSExec);
//procedure RIRegister_EOleException(CL: TPSRuntimeClassImporter);
//procedure RIRegister_EOleSysError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAutomation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRegistryClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAutoObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAutoDispatch(CL: TPSRuntimeClassImporter);
procedure RIRegister_OleAuto(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Ole2
  ,OleCtl
  ,OleAuto
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OleAuto]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EOleException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EOleError', 'EOleException') do
  with CL.AddClassN(CL.FindClass('EOleError'),'EOleException') do begin
    RegisterMethod('Constructor Create( const ExcepInfo : TExcepInfo)');
    RegisterProperty('ErrorCode', 'Integer', iptr);
    RegisterProperty('HelpFile', 'string', iptr);
    RegisterProperty('Source', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EOleSysError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EOleError', 'EOleSysError') do
  with CL.AddClassN(CL.FindClass('EOleError'),'EOleSysError') do begin
    RegisterMethod('Constructor Create( ErrorCode : Integer)');
    RegisterProperty('ErrorCode', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAutomation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TAutomation') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TAutomation') do begin
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure RegisterClass( const AutoClassInfo : TAutoClassInfo)');
    RegisterMethod('Procedure UpdateRegistry( Register : Boolean)');
    RegisterProperty('AutoObjectCount', 'Integer', iptr);
    RegisterProperty('IsInprocServer', 'Boolean', iptrw);
    RegisterProperty('StartMode', 'TStartMode', iptr);
    RegisterProperty('OnLastRelease', 'TLastReleaseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRegistryClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TRegistryClass') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TRegistryClass') do begin
    RegisterMethod('Constructor Create( const AutoClassInfo : TAutoClassInfo)');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure UpdateRegistry( Register : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAutoObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAutoObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAutoObject') do begin
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
    RegisterMethod('Function AddRef : Integer');
    RegisterMethod('Function Release : Integer');
    RegisterProperty('AutoDispatch', 'TAutoDispatch', iptr);
    RegisterProperty('OleObject', 'Variant', iptr);
    RegisterProperty('RefCount', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAutoDispatch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'IDispatch', 'TAutoDispatch') do
  with CL.AddClassN(CL.FindClass('IDispatch'),'TAutoDispatch') do begin
    RegisterMethod('Constructor Create( AutoObject : TAutoObject)');
    RegisterMethod('Function GetAutoObject : TAutoObject');
    RegisterProperty('AutoObject', 'TAutoObject', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_OleAuto(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxDispArgs','LongInt').SetInt( 32);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAutoObject');
  SIRegister_TAutoDispatch(CL);
  SIRegister_TAutoObject(CL);
  //CL.AddTypeS('TAutoClass', 'class of TAutoObject');
  CL.AddTypeS('TAutoClassInstancing', '( acInternal, acSingleInstance, acMultiInstance )');
  //CL.AddTypeS('TAutoClassInfo', 'record AutoClass : TAutoClass; ProgID : string'
  // +'; ClassID : string; Description : string; Instancing : TAutoClassInstancing; end');
  SIRegister_TRegistryClass(CL);
  CL.AddTypeS('TStartMode', '( smStandalone, smAutomation, smRegServer, smUnregServer )');
  CL.AddTypeS('TLastReleaseEvent', 'Procedure ( var Shutdown : Boolean)');
  CL.AddTypeS('TIID', 'TGUID');
//  TIID = TGUID;    TCLSID = TGUID;
  CL.AddTypeS('TCLSID', 'TGUID');

  SIRegister_TAutomation(CL);
  //CL.AddClassN(CL.FindClass('TOBJECT'),'EOleError');
  CL.AddClassN(CL.FindClass('Exception'),'EOleError');

  // EOleError = class(Exception);

  //SIRegister_EOleSysError(CL);
  //SIRegister_EOleException(CL);
 CL.AddDelphiFunction('Function xCreateOleObject( const ClassName : string) : Variant');
 CL.AddDelphiFunction('Function xGetActiveOleObject( const ClassName : string) : Variant');
 //CL.AddDelphiFunction('Function DllGetClassObject( const CLSID : TCLSID; const IID : TIID; var Obj) : HResult');
 CL.AddDelphiFunction('Function DllCanUnloadNow : HResult');
 CL.AddDelphiFunction('Function DllRegisterServer : HResult');
 CL.AddDelphiFunction('Function DllUnregisterServer : HResult');
 CL.AddDelphiFunction('Function VarFromInterface( Unknown : IUnknown) : Variant');
 CL.AddDelphiFunction('Function VarToInterface( const V : Variant) : IDispatch');
 CL.AddDelphiFunction('Function VarToAutoObject( const V : Variant) : TAutoObject');
 //CL.AddDelphiFunction('Procedure DispInvoke( Dispatch : IDispatch; CallDesc : PCallDesc; DispIDs : PDispIDList; Params : Pointer; Result : PVariant)');
 //CL.AddDelphiFunction('Procedure DispInvokeError( Status : HResult; const ExcepInfo : TExcepInfo)');
 CL.AddDelphiFunction('Procedure xOleError( ErrorCode : HResult)');
 CL.AddDelphiFunction('Procedure OleCheck( Result : HResult)');
 CL.AddDelphiFunction('Function StringToClassID( const S : string) : TCLSID');
 CL.AddDelphiFunction('Function ClassIDToString( const ClassID : TCLSID) : string');
 CL.AddDelphiFunction('Function xProgIDToClassID( const ProgID : string) : TCLSID');
 CL.AddDelphiFunction('Function xClassIDToProgID( const ClassID : TCLSID) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure EOleExceptionSource_R(Self: EOleException; var T: string);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure EOleExceptionHelpFile_R(Self: EOleException; var T: string);
begin T := Self.HelpFile; end;

(*----------------------------------------------------------------------------*)
procedure EOleExceptionErrorCode_R(Self: EOleException; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure EOleSysErrorErrorCode_R(Self: EOleSysError; var T: Integer);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure TAutomationOnLastRelease_W(Self: TAutomation; const T: TLastReleaseEvent);
begin Self.OnLastRelease := T; end;

(*----------------------------------------------------------------------------*)
procedure TAutomationOnLastRelease_R(Self: TAutomation; var T: TLastReleaseEvent);
begin T := Self.OnLastRelease; end;

(*----------------------------------------------------------------------------*)
procedure TAutomationStartMode_R(Self: TAutomation; var T: TStartMode);
begin T := Self.StartMode; end;

(*----------------------------------------------------------------------------*)
procedure TAutomationIsInprocServer_W(Self: TAutomation; const T: Boolean);
begin Self.IsInprocServer := T; end;

(*----------------------------------------------------------------------------*)
procedure TAutomationIsInprocServer_R(Self: TAutomation; var T: Boolean);
begin T := Self.IsInprocServer; end;

(*----------------------------------------------------------------------------*)
procedure TAutomationAutoObjectCount_R(Self: TAutomation; var T: Integer);
begin T := Self.AutoObjectCount; end;

(*----------------------------------------------------------------------------*)
procedure TAutoObjectRefCount_R(Self: TAutoObject; var T: Integer);
begin T := Self.RefCount; end;

(*----------------------------------------------------------------------------*)
procedure TAutoObjectOleObject_R(Self: TAutoObject; var T: Variant);
begin T := Self.OleObject; end;

(*----------------------------------------------------------------------------*)
procedure TAutoObjectAutoDispatch_R(Self: TAutoObject; var T: TAutoDispatch);
begin T := Self.AutoDispatch; end;

(*----------------------------------------------------------------------------*)
procedure TAutoDispatchAutoObject_R(Self: TAutoDispatch; var T: TAutoObject);
begin T := Self.AutoObject; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OleAuto_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateOleObject, 'xCreateOleObject', cdRegister);
 S.RegisterDelphiFunction(@GetActiveOleObject, 'xGetActiveOleObject', cdRegister);
 S.RegisterDelphiFunction(@DllGetClassObject, 'DllGetClassObject', CdStdCall);
 S.RegisterDelphiFunction(@DllCanUnloadNow, 'DllCanUnloadNow', CdStdCall);
 S.RegisterDelphiFunction(@DllRegisterServer, 'DllRegisterServer', CdStdCall);
 S.RegisterDelphiFunction(@DllUnregisterServer, 'DllUnregisterServer', CdStdCall);
 S.RegisterDelphiFunction(@VarFromInterface, 'VarFromInterface', cdRegister);
 S.RegisterDelphiFunction(@VarToInterface, 'VarToInterface', cdRegister);
 S.RegisterDelphiFunction(@VarToAutoObject, 'VarToAutoObject', cdRegister);
 S.RegisterDelphiFunction(@DispInvoke, 'DispInvoke', cdRegister);
 S.RegisterDelphiFunction(@DispInvokeError, 'DispInvokeError', cdRegister);
 S.RegisterDelphiFunction(@OleError, 'xOleError', cdRegister);
 S.RegisterDelphiFunction(@OleCheck, 'OleCheck', cdRegister);
 S.RegisterDelphiFunction(@StringToClassID, 'StringToClassID', cdRegister);
 S.RegisterDelphiFunction(@ClassIDToString, 'ClassIDToString', cdRegister);
 S.RegisterDelphiFunction(@ProgIDToClassID, 'xProgIDToClassID', cdRegister);
 S.RegisterDelphiFunction(@ClassIDToProgID, 'xClassIDToProgID', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EOleException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOleException) do begin
    RegisterConstructor(@EOleException.Create, 'Create');
    RegisterPropertyHelper(@EOleExceptionErrorCode_R,nil,'ErrorCode');
    RegisterPropertyHelper(@EOleExceptionHelpFile_R,nil,'HelpFile');
    RegisterPropertyHelper(@EOleExceptionSource_R,nil,'Source');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EOleSysError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOleSysError) do begin
    RegisterConstructor(@EOleSysError.Create, 'Create');
    RegisterPropertyHelper(@EOleSysErrorErrorCode_R,nil,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAutomation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAutomation) do begin
    RegisterConstructor(@TAutomation.Create, 'Create');
    RegisterMethod(@TAutomation.Destroy, 'Free');
    RegisterMethod(@TAutomation.RegisterClass, 'RegisterClass');
    RegisterMethod(@TAutomation.UpdateRegistry, 'UpdateRegistry');
    RegisterPropertyHelper(@TAutomationAutoObjectCount_R,nil,'AutoObjectCount');
    RegisterPropertyHelper(@TAutomationIsInprocServer_R,@TAutomationIsInprocServer_W,'IsInprocServer');
    RegisterPropertyHelper(@TAutomationStartMode_R,nil,'StartMode');
    RegisterPropertyHelper(@TAutomationOnLastRelease_R,@TAutomationOnLastRelease_W,'OnLastRelease');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRegistryClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRegistryClass) do begin
    RegisterConstructor(@TRegistryClass.Create, 'Create');
   RegisterMethod(@TRegistryClass.Destroy, 'Free');
      RegisterMethod(@TRegistryClass.UpdateRegistry, 'UpdateRegistry');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAutoObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAutoObject) do begin
    RegisterVirtualConstructor(@TAutoObject.Create, 'Create');
    RegisterMethod(@TAutoObject.Destroy, 'Free');
     RegisterMethod(@TAutoObject.AddRef, 'AddRef');
    RegisterMethod(@TAutoObject.Release, 'Release');
    RegisterPropertyHelper(@TAutoObjectAutoDispatch_R,nil,'AutoDispatch');
    RegisterPropertyHelper(@TAutoObjectOleObject_R,nil,'OleObject');
    RegisterPropertyHelper(@TAutoObjectRefCount_R,nil,'RefCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAutoDispatch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAutoDispatch) do begin
    RegisterConstructor(@TAutoDispatch.Create, 'Create');
    RegisterVirtualMethod(@TAutoDispatch.GetAutoObject, 'GetAutoObject');
    RegisterPropertyHelper(@TAutoDispatchAutoObject_R,nil,'AutoObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OleAuto(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAutoObject) do
  RIRegister_TAutoDispatch(CL);
  RIRegister_TAutoObject(CL);
  RIRegister_TRegistryClass(CL);
  RIRegister_TAutomation(CL);
  //with CL.Add(EOleError) do
  //RIRegister_EOleSysError(CL);
  //RIRegister_EOleException(CL);
end;



{ TPSImport_OleAuto }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OleAuto.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OleAuto(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OleAuto.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OleAuto(ri);
  RIRegister_OleAuto_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
