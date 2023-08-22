unit uPSI_ScriptFunc_R;
{
   just to work with findfiles as adapter
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
  TPSImport_ScriptFunc_R = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ScriptFunc_R(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ScriptFunc_R_Routines(S: TPSExec);

procedure Register;

implementation

  uses windows, RedirFunc;

  { SysUtils }

type
  { *Must* keep this in synch with ScriptFunc_C }
  TFindRec = record
    Name: String;
    Attributes: LongWord;
    SizeHigh: LongWord;
    SizeLow: LongWord;
    CreationTime: TFileTime;
    LastAccessTime: TFileTime;
    LastWriteTime: TFileTime;
    AlternateName: String;
    FindHandle: THandle;
  end;



procedure FindDataToFindRec(const FindData: TWin32FindData;
  var FindRec: TFindRec);
begin
  FindRec.Name := FindData.cFileName;
  FindRec.Attributes := FindData.dwFileAttributes;
  FindRec.SizeHigh := FindData.nFileSizeHigh;
  FindRec.SizeLow := FindData.nFileSizeLow;
  FindRec.CreationTime := FindData.ftCreationTime;
  FindRec.LastAccessTime := FindData.ftLastAccessTime;
  FindRec.LastWriteTime := FindData.ftLastWriteTime;
  FindRec.AlternateName := FindData.cAlternateFileName;
end;

function _FindFirst(const FileName: String; var FindRec: TFindRec): Boolean;
var
  FindHandle: THandle;
  FindData: TWin32FindData;
begin
  FindHandle := FindFirstFileRedir(false{ScriptFuncDisableFsRedir}, FileName, FindData);
  if FindHandle <> INVALID_HANDLE_VALUE then begin
    FindRec.FindHandle := FindHandle;
    FindDataToFindRec(FindData, FindRec);
    Result := True;
  end
  else begin
    FindRec.FindHandle := 0;
    Result := False;
  end;
end;

function _FindNext(var FindRec: TFindRec): Boolean;
var
  FindData: TWin32FindData;
begin
  Result := (FindRec.FindHandle <> 0) and FindNextFile(FindRec.FindHandle, FindData);
  if Result then
    FindDataToFindRec(FindData, FindRec);
end;

procedure _FindClose(var FindRec: TFindRec);
begin
  if FindRec.FindHandle <> 0 then begin
    Windows.FindClose(FindRec.FindHandle);
    FindRec.FindHandle := 0;
  end;
end;



//uses
  // ScriptFunc_R ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ScriptFunc_R]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ScriptFunc_R(CL: TPSPascalCompiler);
begin
 //CL.AddDelphiFunction('Procedure ScriptFuncLibraryRegister_R( ScriptInterpreter : TPSExec)');
 CL.AddDelphiFunction('Procedure FindDataToFindRec( const FindData : TWin32FindData; var FindRec : TFindRec)');
 CL.AddDelphiFunction('Function _FindFirst( const FileName : String; var FindRec : TFindRec) : Boolean');
 CL.AddDelphiFunction('Function _FindNext( var FindRec : TFindRec) : Boolean');
 CL.AddDelphiFunction('Procedure _FindClose( var FindRec : TFindRec)');
  CL.AddDelphiFunction('Function FindFirst3( const FileName : String; var FindRec : TFindRec) : Boolean');
 CL.AddDelphiFunction('Function FindNext3( var FindRec : TFindRec) : Boolean');
 CL.AddDelphiFunction('Procedure FindClose3( var FindRec : TFindRec)');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ScriptFunc_R_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@ScriptFuncLibraryRegister_R, 'ScriptFuncLibraryRegister_R', cdRegister);
 S.RegisterDelphiFunction(@FindDataToFindRec, 'FindDataToFindRec', cdRegister);
 S.RegisterDelphiFunction(@_FindFirst, '_FindFirst', cdRegister);
 S.RegisterDelphiFunction(@_FindNext, '_FindNext', cdRegister);
 S.RegisterDelphiFunction(@_FindClose, '_FindClose', cdRegister);
  S.RegisterDelphiFunction(@_FindFirst, 'FindFirst3', cdRegister);
 S.RegisterDelphiFunction(@_FindNext, 'FindNext3', cdRegister);
 S.RegisterDelphiFunction(@_FindClose, 'FindClose3', cdRegister);
end;



{ TPSImport_ScriptFunc_R }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ScriptFunc_R.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ScriptFunc_R(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ScriptFunc_R.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ScriptFunc_R(ri);
  RIRegister_ScriptFunc_R_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
