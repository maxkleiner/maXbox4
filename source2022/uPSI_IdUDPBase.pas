unit uPSI_IdUDPBase;
{
  for FTP
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
  TPSImport_IdUDPBase = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdUDPBase(CL: TPSPascalCompiler);
procedure SIRegister_IdUDPBase(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdUDPBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdUDPBase(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdComponent
  ,IdException
  ,IdGlobal
  ,IdSocketHandle
  ,IdUDPBase
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdUDPBase]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdUDPBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdUDPBase') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdUDPBase') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Binding', 'TIdSocketHandle', iptr);
    RegisterMethod('Procedure Broadcast( const AData : string; const APort : integer)');
    RegisterMethod('Function ReceiveString( const AMSec : Integer) : string;');
    RegisterMethod('Function ReceiveString1( var VPeerIP : string; var VPeerPort : integer; const AMSec : Integer) : string;');
    RegisterMethod('Procedure Send( AHost : string; const APort : Integer; const AData : string)');
    RegisterProperty('ReceiveTimeout', 'Integer', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('BufferSize', 'Integer', iptrw);
    RegisterProperty('BroadcastEnabled', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdUDPBase(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ID_UDP_BUFFERSIZE','LongInt').SetInt(8192);
  SIRegister_TIdUDPBase(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdUDPException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdUDPReceiveErrorZeroBytes');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseBroadcastEnabled_W(Self: TIdUDPBase; const T: Boolean);
begin Self.BroadcastEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseBroadcastEnabled_R(Self: TIdUDPBase; var T: Boolean);
begin T := Self.BroadcastEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseBufferSize_W(Self: TIdUDPBase; const T: Integer);
begin Self.BufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseBufferSize_R(Self: TIdUDPBase; var T: Integer);
begin T := Self.BufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseActive_W(Self: TIdUDPBase; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseActive_R(Self: TIdUDPBase; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseReceiveTimeout_W(Self: TIdUDPBase; const T: Integer);
begin Self.ReceiveTimeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseReceiveTimeout_R(Self: TIdUDPBase; var T: Integer);
begin T := Self.ReceiveTimeout; end;

(*----------------------------------------------------------------------------*)
Function TIdUDPBaseReceiveString1_P(Self: TIdUDPBase;  var VPeerIP : string; var VPeerPort : integer; const AMSec : Integer) : string;
Begin Result := Self.ReceiveString(VPeerIP, VPeerPort, AMSec); END;

(*----------------------------------------------------------------------------*)
Function TIdUDPBaseReceiveString_P(Self: TIdUDPBase;  const AMSec : Integer) : string;
Begin Result := Self.ReceiveString(AMSec); END;

(*----------------------------------------------------------------------------*)
procedure TIdUDPBaseBinding_R(Self: TIdUDPBase; var T: TIdSocketHandle);
begin T := Self.Binding; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdUDPBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUDPBase) do
  begin
    RegisterConstructor(@TIdUDPBase.Create, 'Create');
    RegisterPropertyHelper(@TIdUDPBaseBinding_R,nil,'Binding');
    RegisterMethod(@TIdUDPBase.Broadcast, 'Broadcast');
    RegisterMethod(@TIdUDPBaseReceiveString_P, 'ReceiveString');
    RegisterMethod(@TIdUDPBaseReceiveString1_P, 'ReceiveString1');
    RegisterMethod(@TIdUDPBase.Send, 'Send');
    RegisterPropertyHelper(@TIdUDPBaseReceiveTimeout_R,@TIdUDPBaseReceiveTimeout_W,'ReceiveTimeout');
    RegisterPropertyHelper(@TIdUDPBaseActive_R,@TIdUDPBaseActive_W,'Active');
    RegisterPropertyHelper(@TIdUDPBaseBufferSize_R,@TIdUDPBaseBufferSize_W,'BufferSize');
    RegisterPropertyHelper(@TIdUDPBaseBroadcastEnabled_R,@TIdUDPBaseBroadcastEnabled_W,'BroadcastEnabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdUDPBase(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdUDPBase(CL);
  with CL.Add(EIdUDPException) do
  with CL.Add(EIdUDPReceiveErrorZeroBytes) do
end;

 
 
{ TPSImport_IdUDPBase }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdUDPBase.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdUDPBase(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdUDPBase.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdUDPBase(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
