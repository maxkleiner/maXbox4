unit uPSI_JclAppInst;
{
   instance manager
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
  TPSImport_JclAppInst = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclAppInstances(CL: TPSPascalCompiler);
procedure SIRegister_JclAppInst(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclAppInst_Routines(S: TPSExec);
procedure RIRegister_TJclAppInstances(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclAppInst(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,JclBase
  ,JclFileUtils
  ,JclSynch
  ,JclAppInst
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclAppInst]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclAppInstances(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclAppInstances') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclAppInstances') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function BringAppWindowToFront( const Wnd : HWND) : Boolean');
    RegisterMethod('Function GetApplicationWnd( const ProcessID : DWORD) : HWND');
    RegisterMethod('Procedure KillInstance');
    RegisterMethod('Function SetForegroundWindow98( const Wnd : HWND) : Boolean');
    RegisterMethod('Function CheckInstance( const MaxInstances : Word) : Boolean');
    RegisterMethod('Procedure CheckMultipleInstances( const MaxInstances : Word)');
    RegisterMethod('Procedure CheckSingleInstance');
    RegisterMethod('Function SendCmdLineParams( const WindowClassName : string; const OriginatorWnd : HWND) : Boolean');
    RegisterMethod('Function SendData( const WindowClassName : string; const DataKind : TJclAppInstDataKind; const Data : Pointer; const Size : Integer; const OriginatorWnd : HWND) : Boolean');
    RegisterMethod('Function SendString( const WindowClassName : string; const DataKind : TJclAppInstDataKind; const S : string; const OriginatorWnd : HWND) : Boolean');
    RegisterMethod('Function SendStrings( const WindowClassName : string; const DataKind : TJclAppInstDataKind; const Strings : TStrings; const OriginatorWnd : HWND) : Boolean');
    RegisterMethod('Function SwitchTo( const Index : Integer) : Boolean');
    RegisterMethod('Procedure UserNotify( const Param : Longint)');
    RegisterProperty('AppWnds', 'HWND Integer', iptr);
    RegisterProperty('InstanceIndex', 'Integer DWORD', iptr);
    RegisterProperty('InstanceCount', 'Integer', iptr);
    RegisterProperty('MessageID', 'DWORD', iptr);
    RegisterProperty('ProcessIDs', 'DWORD Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclAppInst(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJclAppInstDataKind', 'Integer');
 CL.AddConstantN('AI_INSTANCECREATED','LongWord').SetUInt( $0001);
 CL.AddConstantN('AI_INSTANCEDESTROYED','LongWord').SetUInt( $0002);
 CL.AddConstantN('AI_USERMSG','LongWord').SetUInt( $0003);
 CL.AddConstantN('AppInstDataKindNoData','LongInt').SetInt( - 1);
 CL.AddConstantN('AppInstCmdLineDataKind','LongInt').SetInt( 1);
  SIRegister_TJclAppInstances(CL);
 CL.AddDelphiFunction('Function JclAppInstances : TJclAppInstances;');
 CL.AddDelphiFunction('Function JclAppInstances1( const UniqueAppIdGuidStr : string) : TJclAppInstances;');
 CL.AddDelphiFunction('Function ReadMessageCheck( var Message : TMessage; const IgnoredOriginatorWnd : HWND) : TJclAppInstDataKind');
 CL.AddDelphiFunction('Procedure ReadMessageData( const Message : TMessage; var Data : ___Pointer; var Size : Integer)');
 CL.AddDelphiFunction('Procedure ReadMessageString( const Message : TMessage; var S : string)');
 CL.AddDelphiFunction('Procedure ReadMessageStrings( const Message : TMessage; const Strings : TStrings)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function JclAppInstances1_P( const UniqueAppIdGuidStr : string) : TJclAppInstances;
Begin Result := JclAppInst.JclAppInstances(UniqueAppIdGuidStr); END;

(*----------------------------------------------------------------------------*)
Function JclAppInstances_P : TJclAppInstances;
Begin Result := JclAppInst.JclAppInstances; END;

(*----------------------------------------------------------------------------*)
procedure TJclAppInstancesProcessIDs_R(Self: TJclAppInstances; var T: DWORD; const t1: Integer);
begin T := Self.ProcessIDs[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclAppInstancesMessageID_R(Self: TJclAppInstances; var T: DWORD);
begin T := Self.MessageID; end;

(*----------------------------------------------------------------------------*)
procedure TJclAppInstancesInstanceCount_R(Self: TJclAppInstances; var T: Integer);
begin T := Self.InstanceCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclAppInstancesInstanceIndex_R(Self: TJclAppInstances; var T: Integer; const t1: DWORD);
begin T := Self.InstanceIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclAppInstancesAppWnds_R(Self: TJclAppInstances; var T: HWND; const t1: Integer);
begin T := Self.AppWnds[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclAppInst_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JclAppInstances, 'JclAppInstances', cdRegister);
 S.RegisterDelphiFunction(@JclAppInstances1_P, 'JclAppInstances1', cdRegister);
 S.RegisterDelphiFunction(@ReadMessageCheck, 'ReadMessageCheck', cdRegister);
 S.RegisterDelphiFunction(@ReadMessageData, 'ReadMessageData', cdRegister);
 S.RegisterDelphiFunction(@ReadMessageString, 'ReadMessageString', cdRegister);
 S.RegisterDelphiFunction(@ReadMessageStrings, 'ReadMessageStrings', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclAppInstances(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclAppInstances) do begin
    RegisterConstructor(@TJclAppInstances.Create, 'Create');
    RegisterMethod(@TJclAppInstances.BringAppWindowToFront, 'BringAppWindowToFront');
    RegisterMethod(@TJclAppInstances.GetApplicationWnd, 'GetApplicationWnd');
    RegisterMethod(@TJclAppInstances.KillInstance, 'KillInstance');
    RegisterMethod(@TJclAppInstances.SetForegroundWindow98, 'SetForegroundWindow98');
    RegisterMethod(@TJclAppInstances.CheckInstance, 'CheckInstance');
    RegisterMethod(@TJclAppInstances.CheckMultipleInstances, 'CheckMultipleInstances');
    RegisterMethod(@TJclAppInstances.CheckSingleInstance, 'CheckSingleInstance');
    RegisterMethod(@TJclAppInstances.SendCmdLineParams, 'SendCmdLineParams');
    RegisterMethod(@TJclAppInstances.SendData, 'SendData');
    RegisterMethod(@TJclAppInstances.SendString, 'SendString');
    RegisterMethod(@TJclAppInstances.SendStrings, 'SendStrings');
    RegisterMethod(@TJclAppInstances.SwitchTo, 'SwitchTo');
    RegisterMethod(@TJclAppInstances.UserNotify, 'UserNotify');
    RegisterPropertyHelper(@TJclAppInstancesAppWnds_R,nil,'AppWnds');
    RegisterPropertyHelper(@TJclAppInstancesInstanceIndex_R,nil,'InstanceIndex');
    RegisterPropertyHelper(@TJclAppInstancesInstanceCount_R,nil,'InstanceCount');
    RegisterPropertyHelper(@TJclAppInstancesMessageID_R,nil,'MessageID');
    RegisterPropertyHelper(@TJclAppInstancesProcessIDs_R,nil,'ProcessIDs');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclAppInst(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclAppInstances(CL);
end;

 
 
{ TPSImport_JclAppInst }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclAppInst.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclAppInst(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclAppInst.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclAppInst(ri);
  RIRegister_JclAppInst_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
