unit uPSI_FmxUtils;
{
   code blocks for closures
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
  TPSImport_FmxUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_FmxUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_FmxUtils_Routines(S: TPSExec);
procedure RIRegister_FmxUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Consts
  ,FmxUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_FmxUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_FmxUtils(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidDest');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EFCantMove');
 CL.AddDelphiFunction('Procedure fmxCopyFile( const FileName, DestName : string)');
 CL.AddDelphiFunction('Procedure fmxMoveFile( const FileName, DestName : string)');
 CL.AddDelphiFunction('Function fmxGetFileSize( const FileName : string) : LongInt');
 CL.AddDelphiFunction('Function fmxFileDateTime( const FileName : string) : TDateTime');
 CL.AddDelphiFunction('Function fmxHasAttr( const FileName : string; Attr : Word) : Boolean');
 CL.AddDelphiFunction('Function fmxExecuteFile( const FileName, Params, DefaultDir : string; ShowCmd : Integer) : THandle');
 CL.AddDelphiFunction('Function fmxExecuteFile2( const FileName, Params, DefaultDir : string; ShowCmd : Integer) : THandle');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_FmxUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CopyFile, 'fmxCopyFile', cdRegister);
 S.RegisterDelphiFunction(@MoveFile, 'fmxMoveFile', cdRegister);
 S.RegisterDelphiFunction(@GetFileSize, 'fmxGetFileSize', cdRegister);
 S.RegisterDelphiFunction(@FileDateTime, 'fmxFileDateTime', cdRegister);
 S.RegisterDelphiFunction(@HasAttr, 'fmxHasAttr', cdRegister);
 S.RegisterDelphiFunction(@ExecuteFile, 'fmxExecuteFile', cdRegister);
 S.RegisterDelphiFunction(@ExecuteFile2, 'fmxExecuteFile2', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_FmxUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidDest) do
  with CL.Add(EFCantMove) do
end;

 
 
{ TPSImport_FmxUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_FmxUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_FmxUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_FmxUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_FmxUtils(ri);
  RIRegister_FmxUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
