unit uPSI_DBXIndyChannel;
{
  for maxbook
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
  TPSImport_DBXIndyChannel = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDBXIndyTcpChannel(CL: TPSPascalCompiler);
procedure SIRegister_DBXIndyChannel(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDBXIndyTcpChannel(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBXIndyChannel(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DBXCommon
  ,DBXChannel
  ,IdTCPClient
  ,DBXIndyChannel
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBXIndyChannel]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDBXIndyTcpChannel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDBXChannel', 'TDBXIndyTcpChannel') do
  with CL.AddClassN(CL.FindClass('TDBXChannel'),'TDBXIndyTcpChannel') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function Read( const Buffer : TBytes; Offset : Integer; Count : Integer) : Integer');
    RegisterMethod('Function Write( const Buffer : TBytes; Offset : Integer; Count : Integer) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBXIndyChannel(CL: TPSPascalCompiler);
begin
  SIRegister_TDBXIndyTcpChannel(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TDBXIndyTcpChannel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBXIndyTcpChannel) do begin
    RegisterConstructor(@TDBXIndyTcpChannel.Create, 'Create');
    RegisterMethod(@TDBXIndyTcpChannel.Open, 'Open');
    RegisterMethod(@TDBXIndyTcpChannel.Close, 'Close');
    RegisterMethod(@TDBXIndyTcpChannel.Read, 'Read');
    RegisterMethod(@TDBXIndyTcpChannel.Write, 'Write');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBXIndyChannel(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDBXIndyTcpChannel(CL);
end;

 
 
{ TPSImport_DBXIndyChannel }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXIndyChannel.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBXIndyChannel(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBXIndyChannel.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBXIndyChannel(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
