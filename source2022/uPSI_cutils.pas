unit uPSI_cutils;
{
  first step to integrate ctools for arduino , csyntax
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
  TPSImport_utils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_cutils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_cutils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,ShellAPI
  ,Dialogs
  ,SynEditHighlighter
  ,Menus
  ,Registry
  ,cutils
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_utils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_cutils(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PdevSearchResult', '^TdevSearchResult // will not work');
  CL.AddTypeS('TdevSearchResult', 'record pt : TPoint; InFile : string; msg : string; end');
  CL.AddTypeS('TUnitType', '( utSrc, utHead, utRes, utPrj, utOther )');
  CL.AddTypeS('TExUnitType', '(utcSrc, utcppSrc, utcHead, utcppHead, utresHead, utresComp, utresSrc, utxPrj, utxOther )');
  CL.AddTypeS('TFilterSet', '( ftOpen, ftHelp, ftPrj, ftSrc, ftAll )');
  CL.AddTypeS('TErrFunc', 'Procedure ( Msg : String)');
  CL.AddTypeS('TLineOutputFunc', 'Procedure ( Line : String)');
  CL.AddTypeS('TCheckAbortFunc', 'Procedure ( var AbortThread : boolean)');
  //CL.FindClass('TPersistent','TSynHighlighterAttributes');
  CL.AddClassN(CL.FindClass('TPersistent'),'TSynHighlighterAttributes');
 CL.AddDelphiFunction('Function cIsWinNT : boolean');
 CL.AddDelphiFunction('Procedure cFilesFromWildcard( Directory, Mask : string; var Files : TStringList; Subdirs, ShowDirs, Multitasking : Boolean)');
 CL.AddDelphiFunction('Function cExecuteFile( const FileName, Params, DefaultDir : string; ShowCmd : Integer) : THandle');
 CL.AddDelphiFunction('Function cRunAndGetOutput( Cmd, WorkDir : string; ErrFunc : TErrFunc; LineOutputFunc : TLineOutputFunc; CheckAbortFunc : TCheckAbortFunc; ShowReturnValue : Boolean) : string');
 CL.AddDelphiFunction('Function cGetShortName( FileName : string) : string');
 CL.AddDelphiFunction('Procedure cShowError( Msg : String)');
 CL.AddDelphiFunction('Function cCommaStrToStr( s : string; formatstr : string) : string');
 CL.AddDelphiFunction('Function cIncludeQuoteIfSpaces( s : string) : string');
 CL.AddDelphiFunction('Function cIncludeQuoteIfNeeded( s : string) : string');
 CL.AddDelphiFunction('Function CommaStrToStr( s : string; formatstr : string) : string');
 CL.AddDelphiFunction('Function IncludeQuoteIfSpaces( s : string) : string');
 CL.AddDelphiFunction('Function IncludeQuoteIfNeeded( s : string) : string');

 CL.AddDelphiFunction('Procedure cLoadFilefromResource( const FileName : string; ms : TMemoryStream)');
 CL.AddDelphiFunction('Function cValidateFile( const FileName : string; const WorkPath : string; const CheckDirs : boolean) : string');
 CL.AddDelphiFunction('Function cBuildFilter( var value : string; const FLTStyle : TFILTERSET) : boolean;');
 CL.AddDelphiFunction('Function cBuildFilter1( var value : string; const _filters : array of string) : boolean;');
 CL.AddDelphiFunction('Function cCodeInstoStr( s : string) : string');
 CL.AddDelphiFunction('Function cStrtoCodeIns( s : string) : string');
 //CL.AddDelphiFunction('Procedure cStrtoAttr( var Attr : TSynHighlighterAttributes; Value : string)');
 //CL.AddDelphiFunction('Function cAttrtoStr( const Attr : TSynHighlighterAttributes) : string');
 CL.AddDelphiFunction('Procedure cStrtoPoint( var pt : TPoint; value : string)');
 CL.AddDelphiFunction('Function cPointtoStr( const pt : TPoint) : string');
 CL.AddDelphiFunction('Procedure StrtoPoint( var pt : TPoint; value : string)');
 CL.AddDelphiFunction('Function PointtoStr( const pt : TPoint) : string');

 CL.AddDelphiFunction('Function cListtoStr( const List : TStrings) : string');
 CL.AddDelphiFunction('Function ListtoStr( const List : TStrings) : string');
 CL.AddDelphiFunction('Procedure StrtoList( s : string; const List : TStrings; const delimiter : char)');
 CL.AddDelphiFunction('Procedure cStrtoList( s : string; const List : TStrings; const delimiter : char)');
 CL.AddDelphiFunction('Function cGetFileTyp( const FileName : string) : TUnitType');
 CL.AddDelphiFunction('Function cGetExTyp( const FileName : string) : TExUnitType');
 CL.AddDelphiFunction('Procedure cSetPath( Add : string; const UseOriginal : boolean)');
 CL.AddDelphiFunction('Function cExpandFileto( const FileName : string; const BasePath : string) : string');
 CL.AddDelphiFunction('Function cFileSamePath( const FileName : string; const TestPath : string) : boolean');
 CL.AddDelphiFunction('Procedure cCloneMenu( const FromMenu : TMenuItem; ToMenu : TMenuItem)');
 CL.AddDelphiFunction('Function cGetLastPos( const SubStr : string; const S : string) : integer');
 CL.AddDelphiFunction('Function cGenMakePath( FileName : String) : String;');
 CL.AddDelphiFunction('Function cGenMakePath2( FileName : String) : String');
 CL.AddDelphiFunction('Function cGenMakePath1( FileName : String; EscapeSpaces, EncloseInQuotes : Boolean) : String;');
 CL.AddDelphiFunction('Function cGetRealPath( BrokenFileName : String; Directory : String) : String');
 CL.AddDelphiFunction('Function cCalcMod( Count : Integer) : Integer');
 CL.AddDelphiFunction('Function cGetVersionString( FileName : string) : string');
 CL.AddDelphiFunction('Function cCheckChangeDir( var Dir : string) : boolean');
 CL.AddDelphiFunction('Function cGetAssociatedProgram( const Extension : string; var Filename, Description : string) : boolean');
 CL.AddDelphiFunction('Function cIsNumeric( s : string) : boolean');
 CL.AddDelphiFunction('Procedure StrtoAttr( var Attr : TSynHighlighterAttributes; Value : string)');
 CL.AddDelphiFunction('Function AttrtoStr( const Attr : TSynHighlighterAttributes) : string');
 CL.AddDelphiFunction('Function GetFileTyp( const FileName : string) : TUnitType');
//  CL.AddDelphiFunction('Function StrToInt( S : string) : Integer');

 CL.AddDelphiFunction('Function Atoi(const aStr: string): integer');
 CL.AddDelphiFunction('Function Itoa(const aint: integer): string');
 CL.AddDelphiFunction('Function Atof(const aStr: string): double');
 CL.AddDelphiFunction('Function Atol(const aStr: string): longint');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function cGenMakePath1_P( FileName : String; EscapeSpaces, EncloseInQuotes : Boolean) : String;
Begin Result := cutils.GenMakePath(FileName, EscapeSpaces, EncloseInQuotes); END;

(*----------------------------------------------------------------------------*)
Function cGenMakePath_P( FileName : String) : String;
Begin Result := cutils.GenMakePath(FileName); END;

(*----------------------------------------------------------------------------*)
Function cBuildFilter1_P( var value : string; const _filters : array of string) : boolean;
Begin Result := cutils.BuildFilter(value, _filters); END;

(*----------------------------------------------------------------------------*)
Function cBuildFilter_P( var value : string; const FLTStyle : TFILTERSET) : boolean;
Begin Result := cutils.BuildFilter(value, FLTStyle); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cutils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsWinNT, 'cIsWinNT', cdRegister);
 S.RegisterDelphiFunction(@FilesFromWildcard, 'cFilesFromWildcard', cdRegister);
 S.RegisterDelphiFunction(@ExecuteFile, 'cExecuteFile', cdRegister);
 S.RegisterDelphiFunction(@RunAndGetOutput, 'cRunAndGetOutput', cdRegister);
 S.RegisterDelphiFunction(@GetShortName, 'cGetShortName', cdRegister);
 S.RegisterDelphiFunction(@ShowError, 'cShowError', cdRegister);
 S.RegisterDelphiFunction(@CommaStrToStr, 'cCommaStrToStr', cdRegister);
 S.RegisterDelphiFunction(@IncludeQuoteIfSpaces, 'cIncludeQuoteIfSpaces', cdRegister);
 S.RegisterDelphiFunction(@IncludeQuoteIfNeeded, 'cIncludeQuoteIfNeeded', cdRegister);
 S.RegisterDelphiFunction(@CommaStrToStr, 'CommaStrToStr', cdRegister);
 S.RegisterDelphiFunction(@IncludeQuoteIfSpaces, 'IncludeQuoteIfSpaces', cdRegister);
 S.RegisterDelphiFunction(@IncludeQuoteIfNeeded, 'IncludeQuoteIfNeeded', cdRegister);

 S.RegisterDelphiFunction(@LoadFilefromResource, 'cLoadFilefromResource', cdRegister);
 S.RegisterDelphiFunction(@ValidateFile, 'cValidateFile', cdRegister);
 S.RegisterDelphiFunction(@BuildFilter, 'cBuildFilter', cdRegister);
 S.RegisterDelphiFunction(@cBuildFilter1_P, 'cBuildFilter1', cdRegister);
 S.RegisterDelphiFunction(@CodeInstoStr, 'cCodeInstoStr', cdRegister);
 S.RegisterDelphiFunction(@StrtoCodeIns, 'cStrtoCodeIns', cdRegister);
 S.RegisterDelphiFunction(@StrtoAttr, 'cStrtoAttr', cdRegister);
 S.RegisterDelphiFunction(@AttrtoStr, 'cAttrtoStr', cdRegister);
 S.RegisterDelphiFunction(@StrtoPoint, 'StrtoPoint', cdRegister);
 S.RegisterDelphiFunction(@PointtoStr, 'PointtoStr', cdRegister);
 S.RegisterDelphiFunction(@StrtoPoint, 'cStrtoPoint', cdRegister);
 S.RegisterDelphiFunction(@PointtoStr, 'cPointtoStr', cdRegister);
 S.RegisterDelphiFunction(@ListtoStr, 'cListtoStr', cdRegister);
 S.RegisterDelphiFunction(@StrtoList, 'cStrtoList', cdRegister);
 S.RegisterDelphiFunction(@ListtoStr, 'ListtoStr', cdRegister);
 S.RegisterDelphiFunction(@StrtoList, 'StrtoList', cdRegister);
  S.RegisterDelphiFunction(@GetFileTyp, 'cGetFileTyp', cdRegister);
  S.RegisterDelphiFunction(@GetFileTyp, 'GetFileTyp', cdRegister);
 S.RegisterDelphiFunction(@StrtoAttr, 'StrtoAttr', cdRegister);
 S.RegisterDelphiFunction(@AttrtoStr, 'AttrtoStr', cdRegister);

 S.RegisterDelphiFunction(@GetExTyp, 'cGetExTyp', cdRegister);
 S.RegisterDelphiFunction(@SetPath, 'cSetPath', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileto, 'cExpandFileto', cdRegister);
 S.RegisterDelphiFunction(@FileSamePath, 'cFileSamePath', cdRegister);
 S.RegisterDelphiFunction(@CloneMenu, 'cCloneMenu', cdRegister);
 S.RegisterDelphiFunction(@GetLastPos, 'cGetLastPos', cdRegister);
 S.RegisterDelphiFunction(@GenMakePath, 'cGenMakePath', cdRegister);
 S.RegisterDelphiFunction(@GenMakePath2, 'cGenMakePath2', cdRegister);
 S.RegisterDelphiFunction(@cGenMakePath1_P, 'cGenMakePath1', cdRegister);
 S.RegisterDelphiFunction(@GetRealPath, 'cGetRealPath', cdRegister);
 S.RegisterDelphiFunction(@CalcMod, 'cCalcMod', cdRegister);
 S.RegisterDelphiFunction(@GetVersionString, 'cGetVersionString', cdRegister);
 S.RegisterDelphiFunction(@CheckChangeDir, 'cCheckChangeDir', cdRegister);
 S.RegisterDelphiFunction(@GetAssociatedProgram, 'cGetAssociatedProgram', cdRegister);
 S.RegisterDelphiFunction(@StrtoInt, 'Atoi', cdRegister);
 S.RegisterDelphiFunction(@IntToStr, 'Itoa', cdRegister);
 S.RegisterDelphiFunction(@StrtoFloat, 'Atof', cdRegister);
 S.RegisterDelphiFunction(@StrtoInt64, 'Atol', cdRegister);

end;



{ TPSImport_utils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_utils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cutils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_utils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_cutils(ri);
  RIRegister_cutils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
