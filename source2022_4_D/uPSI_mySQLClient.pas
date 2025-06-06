unit uPSI_mySQLClient;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_mySQLClient = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TmySQLClient(CL: TPSPascalCompiler);
procedure SIRegister_TCustom_mySQLClient(CL: TPSPascalCompiler);
procedure SIRegister_mySQLClient(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_mySQLClient_Routines(S: TPSExec);
procedure RIRegister_TmySQLClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustom_mySQLClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_mySQLClient(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   mySQLCommon
  ,ExtCtrls
  ,mysql
  ,mySQLClient
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_mySQLClient]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TmySQLClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustom_mySQLClient', 'TmySQLClient') do
  with CL.AddClassN(CL.FindClass('TCustom_mySQLClient'),'TmySQLClient') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustom_mySQLClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TCustom_mySQLClient') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TCustom_mySQLClient') do
  begin
    RegisterProperty('Query', 'TmySQLClientQuery', iptrw);
    RegisterProperty('Modify', 'TmySQLClientModify', iptrw);
    RegisterProperty('Utility', 'TmySQLClientUtility', iptrw);
    RegisterProperty('TaskHandler', 'TmySQLClientTaskHandler', iptrw);
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure ForceClose');
    RegisterMethod('Procedure Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_mySQLClient(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TMYSQLCLIENT_VERSION','String').SetString( '2.1a');
 CL.AddConstantN('TMYSQLCLIENT_LAST_MODIFIED','String').SetString( '01.27.2002');
 CL.AddConstantN('TMYSQLCLIENT_LAST_AUTHOR','String').SetString( 'jpy');
 CL.AddConstantN('DEFAULT_CONNECTED_TIMEOUT_INTERVAL','LongInt').SetInt( 300000);
  SIRegister_TCustom_mySQLClient(CL);
  SIRegister_TmySQLClient(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustom_mySQLClientTaskHandler_W(Self: TCustom_mySQLClient; const T: TmySQLClientTaskHandler);
begin Self.TaskHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustom_mySQLClientTaskHandler_R(Self: TCustom_mySQLClient; var T: TmySQLClientTaskHandler);
begin T := Self.TaskHandler; end;

(*----------------------------------------------------------------------------*)
procedure TCustom_mySQLClientUtility_W(Self: TCustom_mySQLClient; const T: TmySQLClientUtility);
begin Self.Utility := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustom_mySQLClientUtility_R(Self: TCustom_mySQLClient; var T: TmySQLClientUtility);
begin T := Self.Utility; end;

(*----------------------------------------------------------------------------*)
procedure TCustom_mySQLClientModify_W(Self: TCustom_mySQLClient; const T: TmySQLClientModify);
begin Self.Modify := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustom_mySQLClientModify_R(Self: TCustom_mySQLClient; var T: TmySQLClientModify);
begin T := Self.Modify; end;

(*----------------------------------------------------------------------------*)
procedure TCustom_mySQLClientQuery_W(Self: TCustom_mySQLClient; const T: TmySQLClientQuery);
begin Self.Query := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustom_mySQLClientQuery_R(Self: TCustom_mySQLClient; var T: TmySQLClientQuery);
begin T := Self.Query; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_mySQLClient_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TmySQLClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TmySQLClient) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustom_mySQLClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustom_mySQLClient) do
  begin
    RegisterPropertyHelper(@TCustom_mySQLClientQuery_R,@TCustom_mySQLClientQuery_W,'Query');
    RegisterPropertyHelper(@TCustom_mySQLClientModify_R,@TCustom_mySQLClientModify_W,'Modify');
    RegisterPropertyHelper(@TCustom_mySQLClientUtility_R,@TCustom_mySQLClientUtility_W,'Utility');
    RegisterPropertyHelper(@TCustom_mySQLClientTaskHandler_R,@TCustom_mySQLClientTaskHandler_W,'TaskHandler');
    RegisterMethod(@TCustom_mySQLClient.Connect, 'Connect');
    RegisterMethod(@TCustom_mySQLClient.Close, 'Close');
    RegisterMethod(@TCustom_mySQLClient.ForceClose, 'ForceClose');
    RegisterMethod(@TCustom_mySQLClient.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_mySQLClient(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCustom_mySQLClient(CL);
  RIRegister_TmySQLClient(CL);
end;

 
 
{ TPSImport_mySQLClient }
(*----------------------------------------------------------------------------*)
procedure TPSImport_mySQLClient.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_mySQLClient(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_mySQLClient.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_mySQLClient(ri);
  RIRegister_mySQLClient_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
