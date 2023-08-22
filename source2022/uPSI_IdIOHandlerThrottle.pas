unit uPSI_IdIOHandlerThrottle;
{
   indy of iohandler
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
  TPSImport_IdIOHandlerThrottle = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIOHandlerThrottle(CL: TPSPascalCompiler);
procedure SIRegister_IdIOHandlerThrottle(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIOHandlerThrottle(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIOHandlerThrottle(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdComponent
  ,IdGlobal
  ,IdIOHandler
  ,IdIOHandlerThrottle
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIOHandlerThrottle]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIOHandlerThrottle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdIOHandler', 'TIdIOHandlerThrottle') do
  with CL.AddClassN(CL.FindClass('TIdIOHandler'),'TIdIOHandlerThrottle') do begin
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure ConnectClient( const AHost : string; const APort : Integer; const ABoundIP : string; const ABoundPort : Integer; const ABoundPortMin : Integer; const ABoundPortMax : Integer; const ATimeout : Integer)');
    RegisterMethod('Function Connected : Boolean');
    RegisterMethod('Function Readable( AMSec : integer) : boolean');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function Recv( var ABuf: string; ALen : integer) : integer');
    RegisterMethod('Function Send( var ABuf: string; ALen : integer) : integer');
    RegisterProperty('BytesPerSec', 'Cardinal', iptrw);
    RegisterProperty('BitsPerSec', 'Cardinal', iptrw);
    RegisterProperty('ChainedHandler', 'TIdIOHandler', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIOHandlerThrottle(CL: TPSPascalCompiler);
begin
  SIRegister_TIdIOHandlerThrottle(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerThrottleChainedHandler_W(Self: TIdIOHandlerThrottle; const T: TIdIOHandler);
begin Self.ChainedHandler := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerThrottleChainedHandler_R(Self: TIdIOHandlerThrottle; var T: TIdIOHandler);
begin T := Self.ChainedHandler; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerThrottleBitsPerSec_W(Self: TIdIOHandlerThrottle; const T: Cardinal);
begin Self.BitsPerSec := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerThrottleBitsPerSec_R(Self: TIdIOHandlerThrottle; var T: Cardinal);
begin T := Self.BitsPerSec; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerThrottleBytesPerSec_W(Self: TIdIOHandlerThrottle; const T: Cardinal);
begin Self.BytesPerSec := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerThrottleBytesPerSec_R(Self: TIdIOHandlerThrottle; var T: Cardinal);
begin T := Self.BytesPerSec; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIOHandlerThrottle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIOHandlerThrottle) do begin
    RegisterMethod(@TIdIOHandlerThrottle.Close, 'Close');
    RegisterConstructor(@TIdIOHandlerThrottle.Create, 'Create');
     RegisterMethod(@TIdIOHandlerThrottle.Destroy, 'Free');
      RegisterMethod(@TIdIOHandlerThrottle.Open, 'Open');
     RegisterMethod(@TIdIOHandlerThrottle.ConnectClient, 'ConnectClient');
    RegisterMethod(@TIdIOHandlerThrottle.Connected, 'Connected');
    RegisterMethod(@TIdIOHandlerThrottle.Readable, 'Readable');
    RegisterMethod(@TIdIOHandlerThrottle.Recv, 'Recv');
    RegisterMethod(@TIdIOHandlerThrottle.Send, 'Send');
    RegisterPropertyHelper(@TIdIOHandlerThrottleBytesPerSec_R,@TIdIOHandlerThrottleBytesPerSec_W,'BytesPerSec');
    RegisterPropertyHelper(@TIdIOHandlerThrottleBitsPerSec_R,@TIdIOHandlerThrottleBitsPerSec_W,'BitsPerSec');
    RegisterPropertyHelper(@TIdIOHandlerThrottleChainedHandler_R,@TIdIOHandlerThrottleChainedHandler_W,'ChainedHandler');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIOHandlerThrottle(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIOHandlerThrottle(CL);
end;

 
 
{ TPSImport_IdIOHandlerThrottle }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIOHandlerThrottle.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIOHandlerThrottle(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIOHandlerThrottle.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIOHandlerThrottle(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
