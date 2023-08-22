unit uPSI_PJIStreams;
{
  stream pipe
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
  TPSImport_PJIStreams = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPJFileIStream(CL: TPSPascalCompiler);
procedure SIRegister_TPJHandleIStreamWrapper(CL: TPSPascalCompiler);
procedure SIRegister_TPJIStreamWrapper(CL: TPSPascalCompiler);
procedure SIRegister_PJIStreams(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPJFileIStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPJHandleIStreamWrapper(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPJIStreamWrapper(CL: TPSRuntimeClassImporter);
procedure RIRegister_PJIStreams(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,PJIStreams
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PJIStreams]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJFileIStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPJHandleIStreamWrapper', 'TPJFileIStream') do
  with CL.AddClassN(CL.FindClass('TPJHandleIStreamWrapper'),'TPJFileIStream') do
  begin
    RegisterMethod('Constructor Create( const FileName : string; Mode : Word)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJHandleIStreamWrapper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPJIStreamWrapper', 'TPJHandleIStreamWrapper') do
  with CL.AddClassN(CL.FindClass('TPJIStreamWrapper'),'TPJHandleIStreamWrapper') do
  begin
    RegisterMethod('Constructor Create( const Stream : THandleStream; const CloseStream : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJIStreamWrapper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TPJIStreamWrapper') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TPJIStreamWrapper') do begin
    RegisterMethod('Constructor Create( const Stream : TStream; const CloseStream : Boolean)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Read( pv : Pointer; cb : Longint; pcbRead : PLongint) : HResult');
    RegisterMethod('Function Write( pv : Pointer; cb : Longint; pcbWritten : PLongint) : HResult');
    RegisterMethod('Function Seek( dlibMove : Largeint; dwOrigin : Longint; out libNewPosition : Largeint) : HResult');
    RegisterMethod('Function SetSize( libNewSize : Largeint) : HResult');
    RegisterMethod('Function CopyTo( stm : IStream; cb : Largeint; out cbRead : Largeint; out cbWritten : Largeint) : HResult');
    RegisterMethod('Function Commit( grfCommitFlags : Longint) : HResult');
    RegisterMethod('Function Revert : HResult');
    RegisterMethod('Function LockRegion( libOffset : Largeint; cb : Largeint; dwLockType : Longint) : HResult');
    RegisterMethod('Function UnlockRegion( libOffset : Largeint; cb : Largeint; dwLockType : Longint) : HResult');
    RegisterMethod('Function Stat( out statstg : TStatStg; grfStatFlag : Longint) : HResult');
    RegisterMethod('Function Clone( out stm : IStream) : HResult');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PJIStreams(CL: TPSPascalCompiler);
begin
  SIRegister_TPJIStreamWrapper(CL);
  SIRegister_TPJHandleIStreamWrapper(CL);
  SIRegister_TPJFileIStream(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJFileIStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJFileIStream) do
  begin
    RegisterConstructor(@TPJFileIStream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJHandleIStreamWrapper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJHandleIStreamWrapper) do
  begin
    RegisterConstructor(@TPJHandleIStreamWrapper.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJIStreamWrapper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJIStreamWrapper) do begin
    RegisterConstructor(@TPJIStreamWrapper.Create, 'Create');
       RegisterMethod(@TPJIStreamWrapper.Destroy, 'Free');
    RegisterVirtualMethod(@TPJIStreamWrapper.Read, 'Read');
    RegisterVirtualMethod(@TPJIStreamWrapper.Write, 'Write');
    RegisterVirtualMethod(@TPJIStreamWrapper.Seek, 'Seek');
    RegisterVirtualMethod(@TPJIStreamWrapper.SetSize, 'SetSize');
    RegisterVirtualMethod(@TPJIStreamWrapper.CopyTo, 'CopyTo');
    RegisterVirtualMethod(@TPJIStreamWrapper.Commit, 'Commit');
    RegisterVirtualMethod(@TPJIStreamWrapper.Revert, 'Revert');
    RegisterVirtualMethod(@TPJIStreamWrapper.LockRegion, 'LockRegion');
    RegisterVirtualMethod(@TPJIStreamWrapper.UnlockRegion, 'UnlockRegion');
    RegisterVirtualMethod(@TPJIStreamWrapper.Stat, 'Stat');
    RegisterVirtualMethod(@TPJIStreamWrapper.Clone, 'Clone');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PJIStreams(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPJIStreamWrapper(CL);
  RIRegister_TPJHandleIStreamWrapper(CL);
  RIRegister_TPJFileIStream(CL);
end;

 
 
{ TPSImport_PJIStreams }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJIStreams.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PJIStreams(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJIStreams.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PJIStreams(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
