unit uPSI_pipes;
{
  for tprocess
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
  TPSImport_pipes = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TOutputPipeStream(CL: TPSPascalCompiler);
procedure SIRegister_TInputPipeStream(CL: TPSPascalCompiler);
procedure SIRegister_TPipeStream(CL: TPSPascalCompiler);
procedure SIRegister_pipes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_pipes_Routines(S: TPSExec);
procedure RIRegister_TOutputPipeStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInputPipeStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPipeStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_pipes(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,pipes
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_pipes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOutputPipeStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPipeStream', 'TOutputPipeStream') do
  with CL.AddClassN(CL.FindClass('TPipeStream'),'TOutputPipeStream') do
  begin
    RegisterMethod('Function Read( var Buffer, Count : Longint) : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInputPipeStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPipeStream', 'TInputPipeStream') do
  with CL.AddClassN(CL.FindClass('TPipeStream'),'TInputPipeStream') do
  begin
    RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPipeStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandleStream', 'TPipeStream') do
  with CL.AddClassN(CL.FindClass('THandleStream'),'TPipeStream') do
  begin
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_pipes(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PSecurityAttributes', '^TSecurityAttributes // will not work');
  CL.AddTypeS('TSecurityAttributes', 'record nlength : Integer; lpSecurityDescriptor : ___Pointer; BinheritHandle : Boolean; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ENoReadPipe');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ENoWritePipe');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPipeSeek');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPipeCreation');
  SIRegister_TPipeStream(CL);
  SIRegister_TInputPipeStream(CL);
  SIRegister_TOutputPipeStream(CL);
 CL.AddDelphiFunction('Procedure CreatePipeStreams( var InPipe : TInputPipeStream; var OutPipe : TOutputPipeStream; SecAttr : PSecurityAttributes; BufSize : Longint)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_pipes_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreatePipeStreams, 'CreatePipeStreams', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOutputPipeStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOutputPipeStream) do
  begin
    RegisterMethod(@TOutputPipeStream.Read, 'Read');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInputPipeStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInputPipeStream) do
  begin
    RegisterMethod(@TInputPipeStream.Write, 'Write');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPipeStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPipeStream) do
  begin
    RegisterMethod(@TPipeStream.Seek, 'Seek');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_pipes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ENoReadPipe) do
  with CL.Add(ENoWritePipe) do
  with CL.Add(EPipeSeek) do
  with CL.Add(EPipeCreation) do
  RIRegister_TPipeStream(CL);
  RIRegister_TInputPipeStream(CL);
  RIRegister_TOutputPipeStream(CL);
end;

 
 
{ TPSImport_pipes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_pipes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_pipes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_pipes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_pipes(ri);
  RIRegister_pipes_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
