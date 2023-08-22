unit uPSI_IdRemoteCMDClient;
{
  in 3.9.6.3.
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
  TPSImport_IdRemoteCMDClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdRemoteCMDClient(CL: TPSPascalCompiler);
procedure SIRegister_IdRemoteCMDClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdRemoteCMDClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdRemoteCMDClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  ,IdTCPClient
  ,SyncObjs
  ,IdRemoteCMDClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdRemoteCMDClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdRemoteCMDClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdRemoteCMDClient') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdRemoteCMDClient') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute( ACommand : String) : String');
    RegisterProperty('ErrorReply', 'Boolean', iptr);
    RegisterProperty('ErrorMessage', 'String', iptr);
    RegisterProperty('UseStdError', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdRemoteCMDClient(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IDRemoteUseStdErr','Boolean').SetInt(1);
 CL.AddConstantN('IDRemoteFixPort','Boolean').SetInt(1);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdCanNotBindRang');
  SIRegister_TIdRemoteCMDClient(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdRemoteCMDClientUseStdError_W(Self: TIdRemoteCMDClient; const T: Boolean);
begin Self.UseStdError := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdRemoteCMDClientUseStdError_R(Self: TIdRemoteCMDClient; var T: Boolean);
begin T := Self.UseStdError; end;

(*----------------------------------------------------------------------------*)
procedure TIdRemoteCMDClientErrorMessage_R(Self: TIdRemoteCMDClient; var T: String);
begin T := Self.ErrorMessage; end;

(*----------------------------------------------------------------------------*)
procedure TIdRemoteCMDClientErrorReply_R(Self: TIdRemoteCMDClient; var T: Boolean);
begin T := Self.ErrorReply; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdRemoteCMDClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdRemoteCMDClient) do begin
    RegisterConstructor(@TIdRemoteCMDClient.Create, 'Create');
    RegisterVirtualMethod(@TIdRemoteCMDClient.Execute, 'Execute');
    RegisterPropertyHelper(@TIdRemoteCMDClientErrorReply_R,nil,'ErrorReply');
    RegisterPropertyHelper(@TIdRemoteCMDClientErrorMessage_R,nil,'ErrorMessage');
    RegisterPropertyHelper(@TIdRemoteCMDClientUseStdError_R,@TIdRemoteCMDClientUseStdError_W,'UseStdError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdRemoteCMDClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIdCanNotBindRang) do
  RIRegister_TIdRemoteCMDClient(CL);
end;

 
 
{ TPSImport_IdRemoteCMDClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRemoteCMDClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdRemoteCMDClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdRemoteCMDClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdRemoteCMDClient(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
