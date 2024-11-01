unit uPSI_IdDayTimeServer;
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
  TPSImport_IdDayTimeServer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdDayTimeServer(CL: TPSPascalCompiler);
procedure SIRegister_IdDayTimeServer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdDayTimeServer(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdDayTimeServer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPServer
  ,IdDayTimeServer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdDayTimeServer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdDayTimeServer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPServer', 'TIdDayTimeServer') do
  with CL.AddClassN(CL.FindClass('TIdTCPServer'),'TIdDayTimeServer') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('TimeZone', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdDayTimeServer(CL: TPSPascalCompiler);
begin
  SIRegister_TIdDayTimeServer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdDayTimeServerTimeZone_W(Self: TIdDayTimeServer; const T: String);
begin Self.TimeZone := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdDayTimeServerTimeZone_R(Self: TIdDayTimeServer; var T: String);
begin T := Self.TimeZone; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdDayTimeServer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdDayTimeServer) do
  begin
    RegisterConstructor(@TIdDayTimeServer.Create, 'Create');
    RegisterPropertyHelper(@TIdDayTimeServerTimeZone_R,@TIdDayTimeServerTimeZone_W,'TimeZone');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdDayTimeServer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdDayTimeServer(CL);
end;

 
 
{ TPSImport_IdDayTimeServer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdDayTimeServer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdDayTimeServer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdDayTimeServer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdDayTimeServer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
