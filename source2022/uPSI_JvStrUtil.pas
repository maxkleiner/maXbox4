unit uPSI_JvStrUtil;
{
    mX3.8.6.   jedi with name conflicts end with J in name!
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
  TPSImport_JvStrUtil = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_JvStrUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvStrUtil_Routines(S: TPSExec);

procedure Register;

implementation


uses
   JvStrUtil_max;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvStrUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvStrUtil(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TSetOfChar', 'set of Char');
 // CL.AddTypeS('TSetOfChar', 'string');
  // TSetOfChar = set of Char;
 CL.AddDelphiFunction('Function FindNotBlankCharPos( const S : string) : Integer');
 CL.AddDelphiFunction('Function AnsiChangeCase( const S : string) : string');
 CL.AddDelphiFunction('Function GetWordOnPos( const S : string; const P : Integer) : string');
 CL.AddDelphiFunction('Function GetWordOnPosEx( const S : string; const P : Integer; var iBeg, iEnd : Integer) : string');
 CL.AddDelphiFunction('Function CmpJ( const S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function Spaces( const N : Integer) : string');
 CL.AddDelphiFunction('Function HasChar( const Ch : Char; const S : string) : Boolean');
 CL.AddDelphiFunction('Function HasAnyChar( const Chars : string; const S : string) : Boolean');
 CL.AddDelphiFunction('Function SubStrJ( const S : string; const Index : Integer; const Separator : string) : string');
 CL.AddDelphiFunction('Function SubStrEndJ( const S : string; const Index : Integer; const Separator : string) : string');
 CL.AddDelphiFunction('Function ReplaceStringJ( S : string; const OldPattern, NewPattern : string) : string');
 //CL.AddDelphiFunction('Function CharInSet( const Ch : Char; const SetOfChar : TSetOfChar) : Boolean');
 CL.AddDelphiFunction('Procedure GetXYByPosJ( const S : string; const Pos : Integer; var X, Y : Integer)');
 CL.AddDelphiFunction('Function AddSlash2( const Dir : TFileName) : string');
 CL.AddDelphiFunction('Function AddPath( const FileName, Path : TFileName) : TFileName');
 CL.AddDelphiFunction('Function ExePath : TFileName');
 CL.AddDelphiFunction('Function LoadTextFile( const FileName : TFileName) : string');
 CL.AddDelphiFunction('Procedure SaveTextFile( const FileName : TFileName; const Source : string)');
 CL.AddDelphiFunction('Function ConcatSep( const S, S2, Separator : string) : string');
 CL.AddDelphiFunction('Function FileEquMask( FileName, Mask : TFileName) : Boolean');
 CL.AddDelphiFunction('Function FileEquMasks( FileName, Masks : TFileName) : Boolean');
 CL.AddDelphiFunction('Function StringEndsWith( const Str, SubStr : string) : Boolean');
 CL.AddDelphiFunction('Function ExtractFilePath2( const FileName : string) : string');
 CL.AddDelphiFunction('Function AnsiStrIComp( S1, S2 : PChar) : Integer');
 CL.AddDelphiFunction('Function AnsiStrLIComp( S1, S2 : PChar; MaxLen : Cardinal) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvStrUtil_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FindNotBlankCharPos, 'FindNotBlankCharPos', cdRegister);
 S.RegisterDelphiFunction(@AnsiChangeCase, 'AnsiChangeCase', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPos, 'GetWordOnPos', cdRegister);
 S.RegisterDelphiFunction(@GetWordOnPosEx, 'GetWordOnPosEx', cdRegister);
 S.RegisterDelphiFunction(@Cmp, 'CmpJ', cdRegister);
 S.RegisterDelphiFunction(@Spaces, 'Spaces', cdRegister);
 S.RegisterDelphiFunction(@HasChar, 'HasChar', cdRegister);
 S.RegisterDelphiFunction(@HasAnyChar, 'HasAnyChar', cdRegister);
 S.RegisterDelphiFunction(@SubStr, 'SubStrJ', cdRegister);
 S.RegisterDelphiFunction(@SubStrEnd, 'SubStrEndJ', cdRegister);
 S.RegisterDelphiFunction(@ReplaceString, 'ReplaceStringJ', cdRegister);
// S.RegisterDelphiFunction(@CharInSet, 'CharInSet', cdRegister);
 S.RegisterDelphiFunction(@GetXYByPos, 'GetXYByPosJ', cdRegister);
 S.RegisterDelphiFunction(@AddSlash2, 'AddSlash2', cdRegister);
 S.RegisterDelphiFunction(@AddPath, 'AddPath', cdRegister);
 S.RegisterDelphiFunction(@ExePath, 'ExePath', cdRegister);
 S.RegisterDelphiFunction(@LoadTextFile, 'LoadTextFile', cdRegister);
 S.RegisterDelphiFunction(@SaveTextFile, 'SaveTextFile', cdRegister);
 S.RegisterDelphiFunction(@ConcatSep, 'ConcatSep', cdRegister);
 S.RegisterDelphiFunction(@FileEquMask, 'FileEquMask', cdRegister);
 S.RegisterDelphiFunction(@FileEquMasks, 'FileEquMasks', cdRegister);
 S.RegisterDelphiFunction(@StringEndsWith, 'StringEndsWith', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePath2, 'ExtractFilePath2', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrIComp, 'AnsiStrIComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLIComp, 'AnsiStrLIComp', cdRegister);
end;

 
 
{ TPSImport_JvStrUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStrUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvStrUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStrUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvStrUtil(ri);
  RIRegister_JvStrUtil_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
