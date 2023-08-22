unit uPSI_PathFunc;
{
   inno setup  with pathcombine
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
  TPSImport_PathFunc = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_PathFunc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PathFunc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   PathFunc, PathFuncTest
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PathFunc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_PathFunc(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function inAddBackslash( const S : String) : String');
 CL.AddDelphiFunction('Function PathChangeExt( const Filename, Extension : String) : String');
 CL.AddDelphiFunction('Function PathCharCompare( const S1, S2 : PChar) : Boolean');
 CL.AddDelphiFunction('Function PathCharIsSlash( const C : Char) : Boolean');
 CL.AddDelphiFunction('Function PathCharIsTrailByte( const S : String; const Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function PathCharLength( const S : String; const Index : Integer) : Integer');
 CL.AddDelphiFunction('Function inPathCombine( const Dir, Filename : String) : String');
 CL.AddDelphiFunction('Function PathCompare( const S1, S2 : String) : Integer');
 CL.AddDelphiFunction('Function PathDrivePartLength( const Filename : String) : Integer');
 CL.AddDelphiFunction('Function PathDrivePartLengthEx( const Filename : String; const IncludeSignificantSlash : Boolean) : Integer');
 CL.AddDelphiFunction('Function inPathExpand( const Filename : String) : String');
 CL.AddDelphiFunction('Function PathExtensionPos( const Filename : String) : Integer');
 CL.AddDelphiFunction('Function PathExtractDir( const Filename : String) : String');
 CL.AddDelphiFunction('Function PathExtractDrive( const Filename : String) : String');
 CL.AddDelphiFunction('Function PathExtractExt( const Filename : String) : String');
 CL.AddDelphiFunction('Function PathExtractName( const Filename : String) : String');
 CL.AddDelphiFunction('Function PathExtractPath( const Filename : String) : String');
 CL.AddDelphiFunction('Function PathIsRooted( const Filename : String) : Boolean');
 CL.AddDelphiFunction('Function PathLastChar( const S : String) : PChar');
 CL.AddDelphiFunction('Function PathLastDelimiter( const Delimiters, S : string) : Integer');
 CL.AddDelphiFunction('Function PathLowercase( const S : String) : String');
 CL.AddDelphiFunction('Function PathNormalizeSlashes( const S : String) : String');
 CL.AddDelphiFunction('Function PathPathPartLength( const Filename : String; const IncludeSlashesAfterPath : Boolean) : Integer');
 CL.AddDelphiFunction('Function PathPos( Ch : Char; const S : String) : Integer');
 CL.AddDelphiFunction('Function PathStartsWith( const S, AStartsWith : String) : Boolean');
 CL.AddDelphiFunction('Function PathStrNextChar( const S : PChar) : PChar');
 CL.AddDelphiFunction('Function PathStrPrevChar( const Start, Current : PChar) : PChar');
 CL.AddDelphiFunction('Function PathStrScan( const S : PChar; const C : Char) : PChar');
 CL.AddDelphiFunction('Function inRemoveBackslash( const S : String) : String');
 CL.AddDelphiFunction('Function RemoveBackslashUnlessRoot( const S : String) : String');
 CL.AddDelphiFunction('Procedure PathFuncRunTests( const AlsoTestJapaneseDBCS : Boolean)');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_PathFunc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AddBackslash, 'inAddBackslash', cdRegister);
 S.RegisterDelphiFunction(@PathChangeExt, 'PathChangeExt', cdRegister);
 S.RegisterDelphiFunction(@PathCharCompare, 'PathCharCompare', cdRegister);
 S.RegisterDelphiFunction(@PathCharIsSlash, 'PathCharIsSlash', cdRegister);
 S.RegisterDelphiFunction(@PathCharIsTrailByte, 'PathCharIsTrailByte', cdRegister);
 S.RegisterDelphiFunction(@PathCharLength, 'PathCharLength', cdRegister);
 S.RegisterDelphiFunction(@PathCombine, 'inPathCombine', cdRegister);
 S.RegisterDelphiFunction(@PathCompare, 'PathCompare', cdRegister);
 S.RegisterDelphiFunction(@PathDrivePartLength, 'PathDrivePartLength', cdRegister);
 S.RegisterDelphiFunction(@PathDrivePartLengthEx, 'PathDrivePartLengthEx', cdRegister);
 S.RegisterDelphiFunction(@PathExpand, 'inPathExpand', cdRegister);
 S.RegisterDelphiFunction(@PathExtensionPos, 'PathExtensionPos', cdRegister);
 S.RegisterDelphiFunction(@PathExtractDir, 'PathExtractDir', cdRegister);
 S.RegisterDelphiFunction(@PathExtractDrive, 'PathExtractDrive', cdRegister);
 S.RegisterDelphiFunction(@PathExtractExt, 'PathExtractExt', cdRegister);
 S.RegisterDelphiFunction(@PathExtractName, 'PathExtractName', cdRegister);
 S.RegisterDelphiFunction(@PathExtractPath, 'PathExtractPath', cdRegister);
 S.RegisterDelphiFunction(@PathIsRooted, 'PathIsRooted', cdRegister);
 S.RegisterDelphiFunction(@PathLastChar, 'PathLastChar', cdRegister);
 S.RegisterDelphiFunction(@PathLastDelimiter, 'PathLastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@PathLowercase, 'PathLowercase', cdRegister);
 S.RegisterDelphiFunction(@PathNormalizeSlashes, 'PathNormalizeSlashes', cdRegister);
 S.RegisterDelphiFunction(@PathPathPartLength, 'PathPathPartLength', cdRegister);
 S.RegisterDelphiFunction(@PathPos, 'PathPos', cdRegister);
 S.RegisterDelphiFunction(@PathStartsWith, 'PathStartsWith', cdRegister);
 S.RegisterDelphiFunction(@PathStrNextChar, 'PathStrNextChar', cdRegister);
 S.RegisterDelphiFunction(@PathStrPrevChar, 'PathStrPrevChar', cdRegister);
 S.RegisterDelphiFunction(@PathStrScan, 'PathStrScan', cdRegister);
 S.RegisterDelphiFunction(@RemoveBackslash, 'inRemoveBackslash', cdRegister);
 S.RegisterDelphiFunction(@RemoveBackslashUnlessRoot, 'RemoveBackslashUnlessRoot', cdRegister);
 S.RegisterDelphiFunction(@PathFuncRunTests, 'PathFuncRunTests', cdRegister);
 
end;

 
 
{ TPSImport_PathFunc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PathFunc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PathFunc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PathFunc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_PathFunc(ri);
  RIRegister_PathFunc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
