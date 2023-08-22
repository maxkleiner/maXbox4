unit uPSI_PJFileHandle;
{
   first serie of PJ
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
  TPSImport_PJFileHandle = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPJFileHandle(CL: TPSPascalCompiler);
procedure SIRegister_PJFileHandle(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPJFileHandle(CL: TPSRuntimeClassImporter);
procedure RIRegister_PJFileHandle(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,PJFileHandle
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PJFileHandle]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPJFileHandle(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPJFileHandle') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPJFileHandle') do begin
    RegisterMethod('Constructor Create( const FileName : string; const Mode : LongWord; const Inheritable : Boolean);');
    RegisterMethod('Constructor Create1( const FileName : string; const Mode : LongWord; const Security : PSecurityAttributes);');
    RegisterMethod('Procedure Free');
    RegisterProperty('Handle', 'THandle', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PJFileHandle(CL: TPSPascalCompiler);
begin
  SIRegister_TPJFileHandle(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPJFileHandleHandle_R(Self: TPJFileHandle; var T: THandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
Function TPJFileHandleCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : string; const Mode : LongWord; const Security : PSecurityAttributes):TObject;
Begin Result := TPJFileHandle.Create(FileName, Mode, Security); END;

(*----------------------------------------------------------------------------*)
Function TPJFileHandleCreate_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : string; const Mode : LongWord; const Inheritable : Boolean):TObject;
Begin Result := TPJFileHandle.Create(FileName, Mode, Inheritable); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPJFileHandle(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPJFileHandle) do begin
    RegisterConstructor(@TPJFileHandleCreate_P, 'Create');
    RegisterConstructor(@TPJFileHandleCreate1_P, 'Create1');
    RegisterMethod(@TPJFileHandle.Destroy, 'Free');

    RegisterPropertyHelper(@TPJFileHandleHandle_R,nil,'Handle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PJFileHandle(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPJFileHandle(CL);
end;

 
 
{ TPSImport_PJFileHandle }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJFileHandle.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PJFileHandle(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PJFileHandle.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PJFileHandle(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
