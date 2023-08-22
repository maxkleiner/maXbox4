unit uPSI_changefind;
{
   was originally a helper from dws of 2007
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
  TPSImport_changefind = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TChangeFinder(CL: TPSPascalCompiler);
procedure SIRegister_changefind(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TChangeFinder(CL: TPSRuntimeClassImporter);
procedure RIRegister_changefind(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   windows
  ,stdctrls
  ,changefind
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_changefind]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TChangeFinder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TChangeFinder') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TChangeFinder') do begin
    RegisterMethod('Constructor Create_prepList_and_Date( alistView : TListBox)');
    RegisterMethod('Procedure SearchDirectories( path : string; const fname : string)');
    RegisterMethod('procedure ShowFiles(Showpath: string; sr: TSearchRec);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_changefind(CL: TPSPascalCompiler);
begin
  SIRegister_TChangeFinder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TChangeFinder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChangeFinder) do begin
    RegisterConstructor(@TChangeFinder.Create_prepList_and_Date, 'Create_prepList_and_Date');
    RegisterMethod(@TChangeFinder.SearchDirectories, 'SearchDirectories');
    RegisterMethod(@TChangeFinder.Showfiles, 'Showfiles');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_changefind(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TChangeFinder(CL);
end;



{ TPSImport_changefind }
(*----------------------------------------------------------------------------*)
procedure TPSImport_changefind.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_changefind(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_changefind.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_changefind(ri);
end;
(*----------------------------------------------------------------------------*)


end.
