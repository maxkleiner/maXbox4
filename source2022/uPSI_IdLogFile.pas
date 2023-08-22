unit uPSI_IdLogFile;
{
another log on earth
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
  TPSImport_IdLogFile = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdLogFile(CL: TPSPascalCompiler);
procedure SIRegister_IdLogFile(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdLogFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdLogFile(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdLogBase
  ,IdLogFile
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdLogFile]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdLogFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdLogBase', 'TIdLogFile') do
  with CL.AddClassN(CL.FindClass('TIdLogBase'),'TIdLogFile') do begin
     RegisterMethod('Constructor Create(AOwner: TComponent);');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    RegisterProperty('Filename', 'TFilename', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdLogFile(CL: TPSPascalCompiler);
begin
  SIRegister_TIdLogFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdLogFileFilename_W(Self: TIdLogFile; const T: TFilename);
begin Self.Filename := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLogFileFilename_R(Self: TIdLogFile; var T: TFilename);
begin T := Self.Filename; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdLogFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdLogFile) do begin
    RegisterVirtualConstructor(@TIdLogFile.Create, 'Create');
    RegisterMethod(@TIdLogFile.Destroy, 'Free');
    RegisterPropertyHelper(@TIdLogFileFilename_R,@TIdLogFileFilename_W,'Filename');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdLogFile(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdLogFile(CL);
end;

 
 
{ TPSImport_IdLogFile }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdLogFile.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdLogFile(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdLogFile.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdLogFile(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
