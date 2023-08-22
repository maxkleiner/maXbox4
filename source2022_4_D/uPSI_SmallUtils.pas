unit uPSI_SmallUtils;
{
   pocket for android
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
  TPSImport_SmallUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_SmallUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SmallUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,SmallUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SmallUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SmallUtils(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TdriveSize', 'record FreeS : Int64; TotalS : Int64; end');
  CL.AddTypeS('TWinVerRec', 'record WinPlatform : Integer; WinMajorVersion : In'
   +'teger; WinMinorVersion : Integer; WinBuildNumber : Integer; WinCSDVersion: String; end');
 CL.AddDelphiFunction('Function aAllocPadedMem( Size : Cardinal) : TObject');
 CL.AddDelphiFunction('Procedure aFreePadedMem( var P : TObject);');
 CL.AddDelphiFunction('Procedure aFreePadedMem1( var P : PChar);');
 CL.AddDelphiFunction('Function aCheckPadedMem( P : TObject) : Byte');
 CL.AddDelphiFunction('Function aGetPadMemSize( P : TObject) : Cardinal');
 CL.AddDelphiFunction('Function aAllocMem( Size : Cardinal) : TObject');
 CL.AddDelphiFunction('Function aStrLen( const Str : PChar) : Cardinal');
 CL.AddDelphiFunction('Function aStrLCopy( Dest : PChar; const Source : PChar; MaxLen : Cardinal) : PChar');
 CL.AddDelphiFunction('Function aStrECopy( Dest : PChar; const Source : PChar) : PChar');
 CL.AddDelphiFunction('Function aStrCopy( Dest : PChar; const Source : PChar) : PChar');
 CL.AddDelphiFunction('Function aStrEnd( const Str : PChar) : PChar');
 CL.AddDelphiFunction('Function aStrScan( const Str : PChar; aChr : Char) : PChar');
 CL.AddDelphiFunction('Function aStrMove( Dest : PChar; const Source : PChar; Count : Cardinal) : PChar');
 CL.AddDelphiFunction('Function aPCharLength( const Str : PChar) : Cardinal');
 CL.AddDelphiFunction('Function aPCharUpper( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function aPCharLower( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function aStrCat( Dest : PChar; const Source : PChar) : PChar');
 CL.AddDelphiFunction('Function aLastDelimiter( const Delimiters, S : String) : Integer');
 CL.AddDelphiFunction('Function aCopyTail( const S : String; Len : Integer) : String');
 CL.AddDelphiFunction('Function aInt2Thos( I : Int64) : String');
 CL.AddDelphiFunction('Function aUpperCase( const S : String) : String');
 CL.AddDelphiFunction('Function aLowerCase( const S : string) : String');
 CL.AddDelphiFunction('Function aCompareText( const S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function aSameText( const S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function aInt2Str( Value : Int64) : String');
 CL.AddDelphiFunction('Function aStr2Int( const Value : String) : Int64');
 CL.AddDelphiFunction('Function aStr2IntDef( const S : string; Default : Int64) : Int64');
 CL.AddDelphiFunction('Function aGetFileExt( const FileName : String) : String');
 CL.AddDelphiFunction('Function aGetFilePath( const FileName : String) : String');
 CL.AddDelphiFunction('Function aGetFileName( const FileName : String) : String');
 CL.AddDelphiFunction('Function aChangeExt( const FileName, Extension : String) : String');
 CL.AddDelphiFunction('Function aAdjustLineBreaks( const S : string) : string');
 CL.AddDelphiFunction('Function aGetWindowStr( WinHandle : HWND) : String');
 CL.AddDelphiFunction('Function aDiskSpace( Drive : String) : TdriveSize');
 CL.AddDelphiFunction('Function aFileExists( FileName : String) : Boolean');
 CL.AddDelphiFunction('Function aFileSize( FileName : String) : Int64');
 CL.AddDelphiFunction('Function aDirectoryExists( const Name : string) : Boolean');
 CL.AddDelphiFunction('Function aSysErrorMessage( ErrorCode : Integer) : string');
 CL.AddDelphiFunction('Function aShortPathName( const LongName : string) : string');
 CL.AddDelphiFunction('Function aGetWindowVer : TWinVerRec');
 CL.AddDelphiFunction('procedure InitDriveSpacePtr;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure FreePadedMem1_P( var P : PChar);
Begin SmallUtils.FreePadedMem(P); END;

(*----------------------------------------------------------------------------*)
Procedure FreePadedMem_P( var P : Pointer);
Begin SmallUtils.FreePadedMem(P); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SmallUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AllocPadedMem, 'aAllocPadedMem', cdRegister);
 S.RegisterDelphiFunction(@FreePadedMem, 'aFreePadedMem', cdRegister);
 S.RegisterDelphiFunction(@FreePadedMem1_P, 'aFreePadedMem1', cdRegister);
 S.RegisterDelphiFunction(@CheckPadedMem, 'aCheckPadedMem', cdRegister);
 S.RegisterDelphiFunction(@GetPadMemSize, 'aGetPadMemSize', cdRegister);
 S.RegisterDelphiFunction(@AllocMem, 'aAllocMem', cdRegister);
 S.RegisterDelphiFunction(@StrLen, 'aStrLen', cdRegister);
 S.RegisterDelphiFunction(@StrLCopy, 'aStrLCopy', cdRegister);
 S.RegisterDelphiFunction(@StrECopy, 'aStrECopy', cdRegister);
 S.RegisterDelphiFunction(@StrCopy, 'aStrCopy', cdRegister);
 S.RegisterDelphiFunction(@StrEnd, 'aStrEnd', cdRegister);
 S.RegisterDelphiFunction(@StrScan, 'aStrScan', cdRegister);
 S.RegisterDelphiFunction(@StrMove, 'aStrMove', cdRegister);
 S.RegisterDelphiFunction(@PCharLength, 'aPCharLength', cdRegister);
 S.RegisterDelphiFunction(@PCharUpper, 'aPCharUpper', cdRegister);
 S.RegisterDelphiFunction(@PCharLower, 'aPCharLower', cdRegister);
 S.RegisterDelphiFunction(@StrCat, 'aStrCat', cdRegister);
 S.RegisterDelphiFunction(@LastDelimiter, 'aLastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@CopyTail, 'aCopyTail', cdRegister);
 S.RegisterDelphiFunction(@Int2Thos, 'aInt2Thos', cdRegister);
 S.RegisterDelphiFunction(@UpperCase, 'aUpperCase', cdRegister);
 S.RegisterDelphiFunction(@LowerCase, 'aLowerCase', cdRegister);
 S.RegisterDelphiFunction(@CompareText, 'aCompareText', cdRegister);
 S.RegisterDelphiFunction(@SameText, 'aSameText', cdRegister);
 S.RegisterDelphiFunction(@Int2Str, 'aInt2Str', cdRegister);
 S.RegisterDelphiFunction(@Str2Int, 'aStr2Int', cdRegister);
 S.RegisterDelphiFunction(@Str2IntDef, 'aStr2IntDef', cdRegister);
 S.RegisterDelphiFunction(@GetFileExt, 'aGetFileExt', cdRegister);
 S.RegisterDelphiFunction(@GetFilePath, 'aGetFilePath', cdRegister);
 S.RegisterDelphiFunction(@GetFileName, 'aGetFileName', cdRegister);
 S.RegisterDelphiFunction(@ChangeExt, 'aChangeExt', cdRegister);
 S.RegisterDelphiFunction(@AdjustLineBreaks, 'aAdjustLineBreaks', cdRegister);
 S.RegisterDelphiFunction(@GetWindowStr, 'aGetWindowStr', cdRegister);
 S.RegisterDelphiFunction(@DiskSpace, 'aDiskSpace', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'aFileExists', cdRegister);
 S.RegisterDelphiFunction(@FileSize, 'aFileSize', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'aDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessage, 'aSysErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@ShortPathName, 'aShortPathName', cdRegister);
 S.RegisterDelphiFunction(@GetWindowVer, 'aGetWindowVer', cdRegister);
 S.RegisterDelphiFunction(@InitDriveSpacePtr, 'InitDriveSpacePtr', cdRegister);


end;

 
 
{ TPSImport_SmallUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SmallUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SmallUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SmallUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_SmallUtils(ri);
  RIRegister_SmallUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
