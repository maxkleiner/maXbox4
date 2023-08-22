unit uPSI_JvPcx;
{
  direct types
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
  TPSImport_JvPcx = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvPcx(CL: TPSPascalCompiler);
procedure SIRegister_JvPcx(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvPcx(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvPcx(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  //,QWindows
  ,Graphics
  ,Controls
  ,Forms
  ,JvTypes
  ,JvJCLUtils
  ,JvPcx
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvPcx]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvPcx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBitmap', 'TJvPcx') do
  with CL.AddClassN(CL.FindClass('TBitmap'),'TJvPcx') do begin
    RegisterMethod('Procedure LoadFromResourceName( Instance : THandle; const ResName : string; ResType : PChar)');
    RegisterMethod('Procedure LoadFromResourceID( Instance : THandle; ResID : Integer; ResType : PChar)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvPcx(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPcxError');
  SIRegister_TJvPcx(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvPcx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvPcx) do
  begin
    RegisterMethod(@TJvPcx.LoadFromResourceName, 'LoadFromResourceName');
    RegisterMethod(@TJvPcx.LoadFromResourceID, 'LoadFromResourceID');
    RegisterMethod(@TJvPcx.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJvPcx.SaveToStream, 'SaveToStream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvPcx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EPcxError) do
  RIRegister_TJvPcx(CL);
end;

 
 
{ TPSImport_JvPcx }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPcx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvPcx(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvPcx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvPcx(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
