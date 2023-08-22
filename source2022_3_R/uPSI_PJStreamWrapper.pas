unit uPSI_PJStreamWrapper;
{
stream info env console

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
  TPSImport_PJStreamWrapper = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPJStreamWrapper(CL: TPSPascalCompiler);
procedure SIRegister_PJStreamWrapper(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPJStreamWrapper(CL: TPSRuntimeClassImporter);
procedure RIRegister_PJStreamWrapper(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   PJStreamWrapper
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PJStreamWrapper]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJStreamWrapper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TPJStreamWrapper') do
  with CL.AddClassN(CL.FindClass('TStream'),'TPJStreamWrapper') do begin
    RegisterMethod('Constructor Create( const Stream : TStream; const CloseStream : Boolean)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Read( var Buffer: string; Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer : string; Count : Longint) : Longint');
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : Longint');
    //RegisterMethod('Function Seek( const Offset : Int64; Origin : TSeekOrigin) : Int64');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PJStreamWrapper(CL: TPSPascalCompiler);
begin
  SIRegister_TPJStreamWrapper(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJStreamWrapper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJStreamWrapper) do begin
    RegisterConstructor(@TPJStreamWrapper.Create, 'Create');
    RegisterMethod(@TPJStreamWrapper.Destroy, 'Free');
    RegisterMethod(@TPJStreamWrapper.Read, 'Read');
    RegisterMethod(@TPJStreamWrapper.Write, 'Write');
    RegisterMethod(@TPJStreamWrapper.Seek, 'Seek');
    //RegisterMethod(@TPJStreamWrapper.Seek, 'Seek');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PJStreamWrapper(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPJStreamWrapper(CL);
end;

 
 
{ TPSImport_PJStreamWrapper }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJStreamWrapper.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PJStreamWrapper(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJStreamWrapper.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PJStreamWrapper(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
