unit uPSI_ShellZipTool;
{
  a service to zip and unzip out of shell tools
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
  TPSImport_ShellZipTool = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TShellZip(CL: TPSPascalCompiler);
procedure SIRegister_ShellZipTool(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ShellZipTool_Routines(S: TPSExec);
procedure RIRegister_TShellZip(CL: TPSRuntimeClassImporter);
procedure RIRegister_ShellZipTool(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ShellZipTool;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ShellZipTool]);
end;


procedure Compress(azipfolder, azipfile: string);
begin
 with TShellZip.create do begin
   zipfile:= azipfile;
   ZipFolder(azipfolder);
   free;
 end;
 //compress
end;


procedure DeCompress(azipfolder, azipfile: string);
begin
 with TShellZip.create do begin
   zipfile:= azipfile;
   if DirectoryExists(azipfolder) = false then
               CreateDir(azipfolder);
   UnZip(azipfolder);
   free;
 end;
 //decompress
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TShellZip(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TShellZip') do
  with CL.AddClassN(CL.FindClass('TObject'),'TShellZip') do begin
    RegisterMethod('Procedure ZipFolder( const sourcefolder : WideString)');
    RegisterMethod('Procedure Zip( const sourcefolder : WideString)');
    RegisterMethod('Procedure Unzip( const targetfolder : WideString)');
    RegisterProperty('Zipfile', 'WideString', iptrw);
    RegisterProperty('Filter', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ShellZipTool(CL: TPSPascalCompiler);
begin
  SIRegister_TShellZip(CL);
 CL.AddDelphiFunction('Function NumProcessThreads : integer');
 CL.AddDelphiFunction('Function NumThreadCount : integer');
 CL.AddDelphiFunction('Function ThreadCount : integer');
 CL.AddDelphiFunction('procedure Compress(azipfolder, azipfile: string)');
 CL.AddDelphiFunction('procedure DeCompress(azipfolder, azipfile: string)');
 CL.AddDelphiFunction('procedure XZip(azipfolder, azipfile: string)');
 CL.AddDelphiFunction('procedure XUnZip(azipfolder, azipfile: string)');
 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TShellZipFilter_W(Self: TShellZip; const T: string);
begin Self.Filter := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellZipFilter_R(Self: TShellZip; var T: string);
begin T := Self.Filter; end;

(*----------------------------------------------------------------------------*)
procedure TShellZipZipfile_W(Self: TShellZip; const T: WideString);
begin Self.Zipfile := T; end;

(*----------------------------------------------------------------------------*)
procedure TShellZipZipfile_R(Self: TShellZip; var T: WideString);
begin T := Self.Zipfile; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ShellZipTool_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NumProcessThreads, 'NumProcessThreads', cdRegister);
 S.RegisterDelphiFunction(@NumProcessThreads, 'NumThreadCount', cdRegister);
 S.RegisterDelphiFunction(@NumProcessThreads, 'ThreadCount', cdRegister);
 S.RegisterDelphiFunction(@Compress, 'Compress', cdRegister);
 S.RegisterDelphiFunction(@DeCompress, 'DeCompress', cdRegister);
 S.RegisterDelphiFunction(@Compress, 'XZip', cdRegister);
 S.RegisterDelphiFunction(@DeCompress, 'XUnZip', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShellZip(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShellZip) do begin
    RegisterMethod(@TShellZip.ZipFolder, 'ZipFolder');
    RegisterMethod(@TShellZip.ZipFolder, 'Zip');
    RegisterMethod(@TShellZip.Unzip, 'Unzip');
    RegisterPropertyHelper(@TShellZipZipfile_R,@TShellZipZipfile_W,'Zipfile');
    RegisterPropertyHelper(@TShellZipFilter_R,@TShellZipFilter_W,'Filter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ShellZipTool(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TShellZip(CL);
end;


{ TPSImport_ShellZipTool }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ShellZipTool.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ShellZipTool(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ShellZipTool.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ShellZipTool(ri);
  RIRegister_ShellZipTool_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
