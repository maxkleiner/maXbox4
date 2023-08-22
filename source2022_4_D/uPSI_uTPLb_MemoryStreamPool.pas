unit uPSI_uTPLb_MemoryStreamPool;
{
Tfor huge cardinal ty   IMemoryStreamPoolEx = interface IMemoryStreamPool = interface

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
  TPSImport_uTPLb_MemoryStreamPool = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPooledMemoryStream(CL: TPSPascalCompiler);
procedure SIRegister_TMemoryStreamPool(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_MemoryStreamPool(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPooledMemoryStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMemoryStreamPool(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_MemoryStreamPool(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_MemoryStreamPool
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_MemoryStreamPool]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPooledMemoryStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMemoryStream', 'TPooledMemoryStream') do
  with CL.AddClassN(CL.FindClass('TMemoryStream'),'TPooledMemoryStream') do
  begin
    RegisterMethod('Constructor Create( Pool1 : TMemoryStreamPool)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMemoryStreamPool(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMemoryStreamPool') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMemoryStreamPool') do begin
    RegisterMethod('Function BayCount : integer');
    RegisterMethod('Procedure GetUsage( Size : integer; var Current, Peak : integer)');
    RegisterMethod('Function GetSize( Idx : Integer) : integer');
    RegisterMethod('Function NewMemoryStream( InitSize : integer) : TMemoryStream');
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_MemoryStreamPool(CL: TPSPascalCompiler);
begin
  SIRegister_TMemoryStreamPool(CL);
  SIRegister_TPooledMemoryStream(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TPooledMemoryStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPooledMemoryStream) do
  begin
    RegisterConstructor(@TPooledMemoryStream.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMemoryStreamPool(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMemoryStreamPool) do begin
    RegisterMethod(@TMemoryStreamPool.BayCount, 'BayCount');
    RegisterMethod(@TMemoryStreamPool.GetUsage, 'GetUsage');
    RegisterMethod(@TMemoryStreamPool.GetSize, 'GetSize');
    RegisterVirtualMethod(@TMemoryStreamPool.NewMemoryStream, 'NewMemoryStream');
    RegisterConstructor(@TMemoryStreamPool.Create, 'Create');
    RegisterMethod(@TMemoryStreamPool.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_MemoryStreamPool(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMemoryStreamPool(CL);
  RIRegister_TPooledMemoryStream(CL);
end;

 
 
{ TPSImport_uTPLb_MemoryStreamPool }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_MemoryStreamPool.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_MemoryStreamPool(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_MemoryStreamPool.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_MemoryStreamPool(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
