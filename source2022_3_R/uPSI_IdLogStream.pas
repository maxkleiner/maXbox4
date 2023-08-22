unit uPSI_IdLogStream;
{
of logbase
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
  TPSImport_IdLogStream = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdLogStream(CL: TPSPascalCompiler);
procedure SIRegister_IdLogStream(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdLogStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdLogStream(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdLogBase
  ,IdLogStream
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdLogStream]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdLogStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdLogBase', 'TIdLogStream') do
  with CL.AddClassN(CL.FindClass('TIdLogBase'),'TIdLogStream') do
  begin
    RegisterProperty('InputStream', 'TStream', iptrw);
    RegisterProperty('OutputStream', 'TStream', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdLogStream(CL: TPSPascalCompiler);
begin
  SIRegister_TIdLogStream(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdLogStreamOutputStream_W(Self: TIdLogStream; const T: TStream);
begin Self.OutputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogStreamOutputStream_R(Self: TIdLogStream; var T: TStream);
begin T := Self.OutputStream; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogStreamInputStream_W(Self: TIdLogStream; const T: TStream);
begin Self.InputStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogStreamInputStream_R(Self: TIdLogStream; var T: TStream);
begin T := Self.InputStream; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdLogStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdLogStream) do
  begin
    RegisterPropertyHelper(@TIdLogStreamInputStream_R,@TIdLogStreamInputStream_W,'InputStream');
    RegisterPropertyHelper(@TIdLogStreamOutputStream_R,@TIdLogStreamOutputStream_W,'OutputStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdLogStream(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdLogStream(CL);
end;

 
 
{ TPSImport_IdLogStream }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdLogStream.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdLogStream(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdLogStream.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdLogStream(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
