unit uPSI_AfCircularBuffer;
{
  buf as string!
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
  TPSImport_AfCircularBuffer = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAfCircularBuffer(CL: TPSPascalCompiler);
procedure SIRegister_AfCircularBuffer(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAfCircularBuffer(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfCircularBuffer(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   AfCircularBuffer
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfCircularBuffer]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCircularBuffer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAfCircularBuffer') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAfCircularBuffer') do begin
    RegisterMethod('Constructor Create( ASize : Integer)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function BufFree : Integer');
    RegisterMethod('Function BufUsed : Integer');
    RegisterMethod('Function BufLinearFree : Integer');
    RegisterMethod('Function BufLinearUsed : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function LinearPoke( Len : Integer) : Boolean');
    RegisterMethod('Function Peek( var Buf: string; Len : Integer) : Boolean');
    RegisterMethod('Function PeekChar( Index : Integer; var C : Char) : Boolean');
    RegisterMethod('Function Read( var Buf: string; Len : Integer) : Boolean');
    RegisterMethod('Function Remove( Len : Integer) : Boolean');
    RegisterMethod('Function Write( const Buf: string; Len : Integer) : Boolean');
    RegisterProperty('StartPtr', 'PChar', iptr);
    RegisterProperty('StartBufPtr', 'PChar', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfCircularBuffer(CL: TPSPascalCompiler);
begin
  SIRegister_TAfCircularBuffer(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfCircularBufferStartBufPtr_R(Self: TAfCircularBuffer; var T: PChar);
begin T := Self.StartBufPtr; end;

(*----------------------------------------------------------------------------*)
procedure TAfCircularBufferStartPtr_R(Self: TAfCircularBuffer; var T: PChar);
begin T := Self.StartPtr; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCircularBuffer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCircularBuffer) do begin
    RegisterConstructor(@TAfCircularBuffer.Create, 'Create');
      RegisterMethod(@TAfCircularBuffer.Destroy, 'Free');
      RegisterMethod(@TAfCircularBuffer.BufFree, 'BufFree');
    RegisterMethod(@TAfCircularBuffer.BufUsed, 'BufUsed');
    RegisterMethod(@TAfCircularBuffer.BufLinearFree, 'BufLinearFree');
    RegisterMethod(@TAfCircularBuffer.BufLinearUsed, 'BufLinearUsed');
    RegisterMethod(@TAfCircularBuffer.Clear, 'Clear');
    RegisterMethod(@TAfCircularBuffer.LinearPoke, 'LinearPoke');
    RegisterMethod(@TAfCircularBuffer.Peek, 'Peek');
    RegisterMethod(@TAfCircularBuffer.PeekChar, 'PeekChar');
    RegisterMethod(@TAfCircularBuffer.Read, 'Read');
    RegisterMethod(@TAfCircularBuffer.Remove, 'Remove');
    RegisterMethod(@TAfCircularBuffer.Write, 'Write');
    RegisterPropertyHelper(@TAfCircularBufferStartPtr_R,nil,'StartPtr');
    RegisterPropertyHelper(@TAfCircularBufferStartBufPtr_R,nil,'StartBufPtr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfCircularBuffer(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAfCircularBuffer(CL);
end;

 
 
{ TPSImport_AfCircularBuffer }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfCircularBuffer.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfCircularBuffer(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfCircularBuffer.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfCircularBuffer(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
