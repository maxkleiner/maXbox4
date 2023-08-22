unit uPSI_synhttp_daemon;
{
   synpase thread demo
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
  TPSImport_synhttp_daemon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTCPHttpThrd(CL: TPSPascalCompiler);
procedure SIRegister_TTCPHttpDaemon(CL: TPSPascalCompiler);
procedure SIRegister_synhttp_daemon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTCPHttpThrd(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTCPHttpDaemon(CL: TPSRuntimeClassImporter);
procedure RIRegister_synhttp_daemon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   blcksock
  ,winsock
  ,Synautil
  ,ssl_openssl
  ,Dialogs
  ,synhttp_daemon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synhttp_daemon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTCPHttpThrd(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TTCPHttpThrd') do
  with CL.AddClassN(CL.FindClass('TThread'),'TTCPHttpThrd') do begin
    RegisterProperty('Headers', 'TStringList', iptrw);
    RegisterProperty('InputData', 'TMemoryStream', iptrw);
    RegisterProperty('OutputData', 'TMemoryStream', iptrw);
    RegisterMethod('Constructor Create( hsock : tSocket)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Execute');
    RegisterMethod('Function ProcessHttpRequest( Request, URI : string) : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTCPHttpDaemon(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TTCPHttpDaemon') do
  with CL.AddClassN(CL.FindClass('TThread'),'TTCPHttpDaemon') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_synhttp_daemon(CL: TPSPascalCompiler);
begin
  SIRegister_TTCPHttpDaemon(CL);
  SIRegister_TTCPHttpThrd(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTCPHttpThrdOutputData_W(Self: TTCPHttpThrd; const T: TMemoryStream);
Begin Self.OutputData := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPHttpThrdOutputData_R(Self: TTCPHttpThrd; var T: TMemoryStream);
Begin T := Self.OutputData; end;

(*----------------------------------------------------------------------------*)
procedure TTCPHttpThrdInputData_W(Self: TTCPHttpThrd; const T: TMemoryStream);
Begin Self.InputData := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPHttpThrdInputData_R(Self: TTCPHttpThrd; var T: TMemoryStream);
Begin T := Self.InputData; end;

(*----------------------------------------------------------------------------*)
procedure TTCPHttpThrdHeaders_W(Self: TTCPHttpThrd; const T: TStringList);
Begin Self.Headers := T; end;

(*----------------------------------------------------------------------------*)
procedure TTCPHttpThrdHeaders_R(Self: TTCPHttpThrd; var T: TStringList);
Begin T := Self.Headers; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTCPHttpThrd(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTCPHttpThrd) do
  begin
    RegisterPropertyHelper(@TTCPHttpThrdHeaders_R,@TTCPHttpThrdHeaders_W,'Headers');
    RegisterPropertyHelper(@TTCPHttpThrdInputData_R,@TTCPHttpThrdInputData_W,'InputData');
    RegisterPropertyHelper(@TTCPHttpThrdOutputData_R,@TTCPHttpThrdOutputData_W,'OutputData');
    RegisterConstructor(@TTCPHttpThrd.Create, 'Create');
         RegisterMethod(@TTCPHttpThrd.Destroy, 'Free');
    RegisterMethod(@TTCPHttpThrd.Execute, 'Execute');
      RegisterMethod(@TTCPHttpThrd.ProcessHttpRequest, 'ProcessHttpRequest');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTCPHttpDaemon(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTCPHttpDaemon) do begin
    RegisterConstructor(@TTCPHttpDaemon.Create, 'Create');
     RegisterMethod(@TTCPHttpDaemon.Destroy, 'Free');
     RegisterMethod(@TTCPHttpDaemon.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_synhttp_daemon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTCPHttpDaemon(CL);
  RIRegister_TTCPHttpThrd(CL);
end;

 
 
{ TPSImport_synhttp_daemon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synhttp_daemon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synhttp_daemon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synhttp_daemon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_synhttp_daemon(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
