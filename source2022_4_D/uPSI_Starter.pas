unit uPSI_Starter;
{
   kind of TProcess of Hydra and DWS
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
  TPSImport_Starter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStarter(CL: TPSPascalCompiler);
procedure SIRegister_Starter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStarter(CL: TPSRuntimeClassImporter);
procedure RIRegister_Starter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Starter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Starter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStarter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStarter') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStarter') do begin
    RegisterMethod('Function CheckVersion( version, required, nojre : string) : boolean');
    RegisterMethod('Function WinExecAndWait32( FileName : String; Visibility : integer) : DWORD');
    RegisterMethod('Function getFileList( aList : TStringList; apath: string) : integer');
    RegisterMethod('Function checkNameVersion( aFilename : string; apath: string) : boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Starter(CL: TPSPascalCompiler);
begin
  SIRegister_TStarter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TStarter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStarter) do
  begin
    RegisterMethod(@TStarter.CheckVersion, 'CheckVersion');
    RegisterMethod(@TStarter.WinExecAndWait32, 'WinExecAndWait32');
    RegisterMethod(@TStarter.getFileList, 'getFileList');
    RegisterMethod(@TStarter.checkNameVersion, 'checkNameVersion');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Starter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStarter(CL);
end;

 
 
{ TPSImport_Starter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Starter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Starter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Starter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Starter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
