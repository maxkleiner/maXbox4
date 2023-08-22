unit uPSI_NSToIS;
{
   more than api is isapi
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
  TPSImport_NSToIS = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TISAPIApplicationList(CL: TPSPascalCompiler);
procedure SIRegister_TISAPISession(CL: TPSPascalCompiler);
procedure SIRegister_TISAPIApplication(CL: TPSPascalCompiler);
procedure SIRegister_NSToIS(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_NSToIS_Routines(S: TPSExec);
procedure RIRegister_TISAPIApplicationList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TISAPISession(CL: TPSRuntimeClassImporter);
procedure RIRegister_TISAPIApplication(CL: TPSRuntimeClassImporter);
procedure RIRegister_NSToIS(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Isapi2
  ,Nsapi
  ,SyncObjs
  ,NSToIS
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_NSToIS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TISAPIApplicationList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TISAPIApplicationList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TISAPIApplicationList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function LoadApplication( const AFileName : string) : TISAPIApplication');
    RegisterMethod('Function InitLog( pb : PPblock; sn : PSession; rq : Prequest) : Integer');
    RegisterMethod('Procedure LogMessage( const Fmt : string; const Params : array of const)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TISAPISession(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TISAPISession') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TISAPISession') do begin
   RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create( pb : PPblock; sn : PSession; rq : PRequest; ISAPIApplication : TISAPIApplication)');
    RegisterMethod('Procedure ProcessExtension');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TISAPIApplication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TISAPIApplication') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TISAPIApplication') do begin
    RegisterProperty('GetExtensionVersion', 'TGetExtensionVersion', iptrw);
    RegisterProperty('HTTPExtensionProc', 'THTTPExtensionProc', iptrw);
    RegisterProperty('TerminateExtension', 'TTerminateExtension', iptrw);
    RegisterMethod('Constructor Create( AOWner : TISAPIApplicationList; const AFileName : string)');
    RegisterMethod('Procedure Load');
    RegisterMethod('Procedure Unload( Ask : Boolean)');
   RegisterMethod('Procedure Free');
     RegisterProperty('VersionInfo', 'THSE_VERSION_INFO', iptr);
   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NSToIS(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TISAPIApplicationList');
  SIRegister_TISAPIApplication(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EISAPIException');
  SIRegister_TISAPISession(CL);
  SIRegister_TISAPIApplicationList(CL);
 CL.AddDelphiFunction('Procedure LogMessage( const Fmt : string; const Params : array of const)');
 CL.AddDelphiFunction('Function UnixPathToDosPath2( const Path : string) : string');
 CL.AddDelphiFunction('Function DosPathToUnixPath2( const Path : string) : string');
 CL.AddDelphiFunction('Procedure InitISAPIApplicationList');
 CL.AddDelphiFunction('Procedure DoneISAPIAPplicationList');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TISAPIApplicationVersionInfo_R(Self: TISAPIApplication; var T: THSE_VERSION_INFO);
begin T := Self.VersionInfo; end;

(*----------------------------------------------------------------------------*)
procedure TISAPIApplicationTerminateExtension_W(Self: TISAPIApplication; const T: TTerminateExtension);
Begin Self.TerminateExtension := T; end;

(*----------------------------------------------------------------------------*)
procedure TISAPIApplicationTerminateExtension_R(Self: TISAPIApplication; var T: TTerminateExtension);
Begin T := Self.TerminateExtension; end;

(*----------------------------------------------------------------------------*)
procedure TISAPIApplicationHTTPExtensionProc_W(Self: TISAPIApplication; const T: THTTPExtensionProc);
Begin Self.HTTPExtensionProc := T; end;

(*----------------------------------------------------------------------------*)
procedure TISAPIApplicationHTTPExtensionProc_R(Self: TISAPIApplication; var T: THTTPExtensionProc);
Begin T := Self.HTTPExtensionProc; end;

(*----------------------------------------------------------------------------*)
procedure TISAPIApplicationGetExtensionVersion_W(Self: TISAPIApplication; const T: TGetExtensionVersion);
Begin Self.GetExtensionVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TISAPIApplicationGetExtensionVersion_R(Self: TISAPIApplication; var T: TGetExtensionVersion);
Begin T := Self.GetExtensionVersion; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NSToIS_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LogMessage, 'LogMessage', cdRegister);
 S.RegisterDelphiFunction(@UnixPathToDosPath, 'UnixPathToDosPath2', cdRegister);
 S.RegisterDelphiFunction(@DosPathToUnixPath, 'DosPathToUnixPath2', cdRegister);
 S.RegisterDelphiFunction(@InitISAPIApplicationList, 'InitISAPIApplicationList', cdRegister);
 S.RegisterDelphiFunction(@DoneISAPIAPplicationList, 'DoneISAPIAPplicationList', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TISAPIApplicationList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TISAPIApplicationList) do begin
    RegisterConstructor(@TISAPIApplicationList.Create, 'Create');
    RegisterMethod(@TISAPIApplicationList.Destroy, 'Free');

    RegisterMethod(@TISAPIApplicationList.LoadApplication, 'LoadApplication');
    RegisterMethod(@TISAPIApplicationList.InitLog, 'InitLog');
    RegisterMethod(@TISAPIApplicationList.LogMessage, 'LogMessage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TISAPISession(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TISAPISession) do begin
    RegisterConstructor(@TISAPISession.Create, 'Create');
    RegisterMethod(@TISAPISession.Destroy, 'Free');
    RegisterMethod(@TISAPISession.ProcessExtension, 'ProcessExtension');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TISAPIApplication(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TISAPIApplication) do begin
    RegisterPropertyHelper(@TISAPIApplicationGetExtensionVersion_R,@TISAPIApplicationGetExtensionVersion_W,'GetExtensionVersion');
    RegisterPropertyHelper(@TISAPIApplicationHTTPExtensionProc_R,@TISAPIApplicationHTTPExtensionProc_W,'HTTPExtensionProc');
    RegisterPropertyHelper(@TISAPIApplicationTerminateExtension_R,@TISAPIApplicationTerminateExtension_W,'TerminateExtension');
    RegisterConstructor(@TISAPIApplication.Create, 'Create');
    RegisterMethod(@TISAPIApplication.Destroy, 'Free');
    RegisterMethod(@TISAPIApplication.Load, 'Load');
    RegisterMethod(@TISAPIApplication.Unload, 'Unload');
    RegisterPropertyHelper(@TISAPIApplicationVersionInfo_R,nil,'VersionInfo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NSToIS(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TISAPIApplicationList) do
  RIRegister_TISAPIApplication(CL);
  with CL.Add(EISAPIException) do
  RIRegister_TISAPISession(CL);
  RIRegister_TISAPIApplicationList(CL);
end;

 
 
{ TPSImport_NSToIS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_NSToIS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_NSToIS(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_NSToIS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_NSToIS(ri);
  RIRegister_NSToIS_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
