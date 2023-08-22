unit uPSI_IdIOHandlerStream;
{
  stream io
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
  TPSImport_IdIOHandlerStream = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIOHandlerStream(CL: TPSPascalCompiler);
procedure SIRegister_IdIOHandlerStream(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIOHandlerStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIOHandlerStream(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdGlobal
  ,IdIOHandler
  ,IdIOHandlerStream
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIOHandlerStream]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIOHandlerStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdIOHandler', 'TIdIOHandlerStream') do
  with CL.AddClassN(CL.FindClass('TIdIOHandler'),'TIdIOHandlerStream') do
  begin
    RegisterMethod('Procedure Close');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Open');
    RegisterMethod('Function Readable( AMSec : integer) : boolean');
    RegisterMethod('Function Recv( var ABuf, ALen : integer) : integer');
    RegisterMethod('Function Send( var ABuf, ALen : integer) : integer');
    RegisterProperty('InputStream', 'TStream', iptrw);
    RegisterProperty('OutputStream', 'TStream', iptrw);
    RegisterProperty('FreeStreams', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIOHandlerStream(CL: TPSPascalCompiler);
begin
  SIRegister_TIdIOHandlerStream(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerStreamFreeStreams_W(Self: TIdIOHandlerStream; const T: Boolean);
begin Self.FreeStreams := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerStreamFreeStreams_R(Self: TIdIOHandlerStream; var T: Boolean);
begin T := Self.FreeStreams; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerStreamOutputStream_W(Self: TIdIOHandlerStream; const T: TStream);
begin Self.OutputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerStreamOutputStream_R(Self: TIdIOHandlerStream; var T: TStream);
begin T := Self.OutputStream; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerStreamInputStream_W(Self: TIdIOHandlerStream; const T: TStream);
begin Self.InputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIOHandlerStreamInputStream_R(Self: TIdIOHandlerStream; var T: TStream);
begin T := Self.InputStream; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIOHandlerStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIOHandlerStream) do
  begin
    RegisterMethod(@TIdIOHandlerStream.Close, 'Close');
    RegisterConstructor(@TIdIOHandlerStream.Create, 'Create');
    RegisterMethod(@TIdIOHandlerStream.Open, 'Open');
    RegisterMethod(@TIdIOHandlerStream.Readable, 'Readable');
    RegisterMethod(@TIdIOHandlerStream.Recv, 'Recv');
    RegisterMethod(@TIdIOHandlerStream.Send, 'Send');
    RegisterPropertyHelper(@TIdIOHandlerStreamInputStream_R,@TIdIOHandlerStreamInputStream_W,'InputStream');
    RegisterPropertyHelper(@TIdIOHandlerStreamOutputStream_R,@TIdIOHandlerStreamOutputStream_W,'OutputStream');
    RegisterPropertyHelper(@TIdIOHandlerStreamFreeStreams_R,@TIdIOHandlerStreamFreeStreams_W,'FreeStreams');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIOHandlerStream(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIOHandlerStream(CL);
end;

 
 
{ TPSImport_IdIOHandlerStream }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIOHandlerStream.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIOHandlerStream(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIOHandlerStream.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIOHandlerStream(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
