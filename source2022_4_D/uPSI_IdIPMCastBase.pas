unit uPSI_IdIPMCastBase;
{
   multicast
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
  TPSImport_IdIPMCastBase = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIPMCastBase(CL: TPSPascalCompiler);
procedure SIRegister_IdIPMCastBase(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIPMCastBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIPMCastBase(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdComponent
  ,IdException
  ,IdGlobal
  ,IdSocketHandle
  ,IdStack
  //,Libc
  ,IdIPMCastBase
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIPMCastBase]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIPMCastBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdIPMCastBase') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdIPMCastBase') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
   RegisterMethod('Function IsValidMulticastGroup( Value : string) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIPMCastBase(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IPMCastLo','LongInt').SetInt( 224);
 CL.AddConstantN('IPMCastHi','LongInt').SetInt( 239);
  CL.AddTypeS('TMultiCast', 'record IMRMultiAddr : TIdInAddr; IMRInterface : TIdInAddr; end');
  SIRegister_TIdIPMCastBase(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdMCastException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdMCastNoBindings');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdMCastNotValidAddress');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIPMCastBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIPMCastBase) do begin
    RegisterConstructor(@TIdIPMCastBase.Create, 'Create');
       RegisterMethod(@TIdIPMCastBase.Destroy, 'Free');
    RegisterMethod(@TIdIPMCastBase.IsValidMulticastGroup, 'IsValidMulticastGroup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIPMCastBase(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIPMCastBase(CL);
  with CL.Add(EIdMCastException) do
  with CL.Add(EIdMCastNoBindings) do
  with CL.Add(EIdMCastNotValidAddress) do
end;

 
 
{ TPSImport_IdIPMCastBase }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIPMCastBase.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIPMCastBase(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIPMCastBase.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIPMCastBase(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
