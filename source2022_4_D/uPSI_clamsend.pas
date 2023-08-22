unit uPSI_clamsend;
{
    synapse antivirus
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
  TPSImport_clamsend = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TClamSend(CL: TPSPascalCompiler);
procedure SIRegister_clamsend(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TClamSend(CL: TPSRuntimeClassImporter);
procedure RIRegister_clamsend(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   synsock
  ,blcksock
  ,synautil
  ,clamsend
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_clamsend]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TClamSend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynaClient', 'TClamSend') do
  with CL.AddClassN(CL.FindClass('TSynaClient'),'TClamSend') do begin
    RegisterMethod('Procedure Free');
      RegisterMethod('Constructor Create');
    RegisterMethod('Function DoCommand( const Value : AnsiString) : AnsiString');
    RegisterMethod('Function GetVersion : AnsiString');
    RegisterMethod('Function ScanStrings( const Value : TStrings) : AnsiString');
    RegisterMethod('Function ScanStream( const Value : TStream) : AnsiString');
    RegisterMethod('Function ScanStrings2( const Value : TStrings) : AnsiString');
    RegisterMethod('Function ScanStream2( const Value : TStream) : AnsiString');
    RegisterProperty('Sock', 'TTCPBlockSocket', iptr);
    RegisterProperty('DSock', 'TTCPBlockSocket', iptr);
    RegisterProperty('Session', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_clamsend(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cClamProtocol','String').SetString( '3310');
  SIRegister_TClamSend(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TClamSendSession_W(Self: TClamSend; const T: boolean);
begin Self.Session := T; end;

(*----------------------------------------------------------------------------*)
procedure TClamSendSession_R(Self: TClamSend; var T: boolean);
begin T := Self.Session; end;

(*----------------------------------------------------------------------------*)
procedure TClamSendDSock_R(Self: TClamSend; var T: TTCPBlockSocket);
begin T := Self.DSock; end;

(*----------------------------------------------------------------------------*)
procedure TClamSendSock_R(Self: TClamSend; var T: TTCPBlockSocket);
begin T := Self.Sock; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClamSend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClamSend) do begin
    RegisterConstructor(@TClamSend.Create, 'Create');
       RegisterMethod(@TClamSend.Destroy, 'Free');
       RegisterVirtualMethod(@TClamSend.DoCommand, 'DoCommand');
    RegisterVirtualMethod(@TClamSend.GetVersion, 'GetVersion');
    RegisterVirtualMethod(@TClamSend.ScanStrings, 'ScanStrings');
    RegisterVirtualMethod(@TClamSend.ScanStream, 'ScanStream');
    RegisterVirtualMethod(@TClamSend.ScanStrings2, 'ScanStrings2');
    RegisterVirtualMethod(@TClamSend.ScanStream2, 'ScanStream2');
    RegisterPropertyHelper(@TClamSendSock_R,nil,'Sock');
    RegisterPropertyHelper(@TClamSendDSock_R,nil,'DSock');
    RegisterPropertyHelper(@TClamSendSession_R,@TClamSendSession_W,'Session');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_clamsend(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TClamSend(CL);
end;

 
 
{ TPSImport_clamsend }
(*----------------------------------------------------------------------------*)
procedure TPSImport_clamsend.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_clamsend(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_clamsend.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_clamsend(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
