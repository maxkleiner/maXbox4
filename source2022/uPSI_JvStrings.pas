unit uPSI_JvStrings;
{
  after strutil and strutils  , above all savestring!
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
  TPSImport_JvStrings = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvStrings(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvStrings_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Graphics
  ,JvStrings
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvStrings]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvStrings(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function ReplaceFirst( const SourceStr, FindStr, ReplaceStr : string) : string');
 CL.AddDelphiFunction('Function ReplaceLast( const SourceStr, FindStr, ReplaceStr : string) : string');
 CL.AddDelphiFunction('Function InsertLastBlock( var SourceStr : string; BlockStr : string) : Boolean');
 CL.AddDelphiFunction('Function RemoveMasterBlocks( const SourceStr : string) : string');
 CL.AddDelphiFunction('Function RemoveFields( const SourceStr : string) : string');
 CL.AddDelphiFunction('Function URLEncode( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function URLDecode( const Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Procedure SplitSet( AText : string; AList : TStringList)');
 CL.AddDelphiFunction('Function JoinSet( AList : TStringList) : string');
 CL.AddDelphiFunction('Function FirstOfSet( const AText : string) : string');
 CL.AddDelphiFunction('Function LastOfSet( const AText : string) : string');
 CL.AddDelphiFunction('Function CountOfSet( const AText : string) : Integer');
 CL.AddDelphiFunction('Function SetRotateRight( const AText : string) : string');
 CL.AddDelphiFunction('Function SetRotateLeft( const AText : string) : string');
 CL.AddDelphiFunction('Function SetPick( const AText : string; AIndex : Integer) : string');
 CL.AddDelphiFunction('Function SetSort( const AText : string) : string');
 CL.AddDelphiFunction('Function SetUnion( const Set1, Set2 : string) : string');
 CL.AddDelphiFunction('Function SetIntersect( const Set1, Set2 : string) : string');
 CL.AddDelphiFunction('Function SetExclude( const Set1, Set2 : string) : string');
 CL.AddDelphiFunction('Function XMLSafe( const AText : string) : string');
 CL.AddDelphiFunction('Function Hash( const AText : string) : Integer');
 CL.AddDelphiFunction('Function B64Encode( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function B64Decode( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function Encrypt( const InString : AnsiString; StartKey, MultKey, AddKey : Integer) : AnsiString');
 CL.AddDelphiFunction('Function Decrypt( const InString : AnsiString; StartKey, MultKey, AddKey : Integer) : AnsiString');
 CL.AddDelphiFunction('Function EncryptB64( const InString : AnsiString; StartKey, MultKey, AddKey : Integer) : AnsiString');
 CL.AddDelphiFunction('Function DecryptB64( const InString : AnsiString; StartKey, MultKey, AddKey : Integer) : AnsiString');
 CL.AddDelphiFunction('Procedure CSVToTags( Src, Dst : TStringList)');
 CL.AddDelphiFunction('Procedure TagsToCSV( Src, Dst : TStringList)');
 CL.AddDelphiFunction('Procedure ListSelect( Src, Dst : TStringList; const AKey, AValue : string)');
 CL.AddDelphiFunction('Procedure ListFilter( Src : TStringList; const AKey, AValue : string)');
 CL.AddDelphiFunction('Procedure ListOrderBy( Src : TStringList; const AKey : string; Numeric : Boolean)');
 CL.AddDelphiFunction('Function PosStr( const FindString, SourceString : string; StartPos : Integer) : Integer');
 CL.AddDelphiFunction('Function PosStrLast( const FindString, SourceString : string) : Integer');
 CL.AddDelphiFunction('Function LastPosChar( const FindChar : Char; SourceString : string) : Integer');
 CL.AddDelphiFunction('Function PosText( const FindString, SourceString : string; StartPos : Integer) : Integer');
 CL.AddDelphiFunction('Function PosTextLast( const FindString, SourceString : string) : Integer');
 CL.AddDelphiFunction('Function NameValuesToXML( const AText : string) : string');
 CL.AddDelphiFunction('Procedure LoadResourceFile( AFile : string; MemStream : TMemoryStream)');
 CL.AddDelphiFunction('Procedure DirFiles( const ADir, AMask : string; AFileList : TStringList)');
 CL.AddDelphiFunction('Procedure RecurseDirFiles( const ADir : string; var AFileList : TStringList)');
 CL.AddDelphiFunction('Procedure RecurseDirProgs( const ADir : string; var AFileList : TStringList)');
 CL.AddDelphiFunction('Procedure SaveString( const AFile, AText : string)');
 CL.AddDelphiFunction('Procedure SaveStringasFile( const AFile, AText : string)');
 CL.AddDelphiFunction('Procedure SaveStringtoFile( const AFile, AText : string)');
 CL.AddDelphiFunction('Procedure Writeln2( const AFile, AText : string)');
 CL.AddDelphiFunction('Procedure Saveln( const AFile, AText : string)');
 CL.AddDelphiFunction('Function LoadStringJ( const AFile : string) : string');
 CL.AddDelphiFunction('Function LoadStringofFile( const AFile : string) : string');
 CL.AddDelphiFunction('Function LSOF( const AFile : string) : string');

 CL.AddDelphiFunction('Function LoadStringofFile( const AFile : string) : string');
 CL.AddDelphiFunction('Function LoadStringfromFile( const AFile : string) : string');
 CL.AddDelphiFunction('Function HexToColor( const AText : string) : TColor');
 CL.AddDelphiFunction('Function UppercaseHTMLTags( const AText : string) : string');
 CL.AddDelphiFunction('Function LowercaseHTMLTags( const AText : string) : string');
 CL.AddDelphiFunction('Procedure GetHTMLAnchors( const AFile : string; AList : TStringList)');
 CL.AddDelphiFunction('Function RelativePath( const ASrc, ADst : string) : string');
 CL.AddDelphiFunction('Function GetToken( var Start : Integer; const SourceText : string) : string');
 CL.AddDelphiFunction('Function PosNonSpace( Start : Integer; const SourceText : string) : Integer');
 CL.AddDelphiFunction('Function PosEscaped( Start : Integer; const SourceText, FindText : string; EscapeChar : Char) : Integer');
 CL.AddDelphiFunction('Function DeleteEscaped( const SourceText : string; EscapeChar : Char) : string');
 CL.AddDelphiFunction('Function BeginOfAttribute( Start : Integer; const SourceText : string) : Integer');
 CL.AddDelphiFunction('Function ParseAttribute( var Start : Integer; const SourceText : string; var AName, AValue : string) : Boolean');
 CL.AddDelphiFunction('Procedure ParseAttributes( const SourceText : string; Attributes : TStrings)');
 CL.AddDelphiFunction('Function HasStrValue( const AText, AName : string; var AValue : string) : Boolean');
 CL.AddDelphiFunction('Function GetStrValue( const AText, AName, ADefault : string) : string');
 CL.AddDelphiFunction('Function GetHTMLColorValue( const AText, AName : string; ADefault : TColor) : TColor');
 CL.AddDelphiFunction('Function GetIntValue( const AText, AName : string; ADefault : Integer) : Integer');
 CL.AddDelphiFunction('Function GetFloatValue( const AText, AName : string; ADefault : Extended) : Extended');
 CL.AddDelphiFunction('Function GetBoolValue( const AText, AName : string) : Boolean');
 CL.AddDelphiFunction('Function GetValue( const AText, AName : string) : string');
 CL.AddDelphiFunction('Procedure SetValue( var AText : string; const AName, AValue : string)');
 CL.AddDelphiFunction('Procedure DeleteValue( var AText : string; const AName : string)');
 CL.AddDelphiFunction('Procedure GetNames( AText : string; AList : TStringList)');
 CL.AddDelphiFunction('Function GetHTMLColor( AColor : TColor) : string');
 CL.AddDelphiFunction('Function BackPosStr( Start : Integer; const FindString, SourceString : string) : Integer');
 CL.AddDelphiFunction('Function BackPosText( Start : Integer; const FindString, SourceString : string) : Integer');
 CL.AddDelphiFunction('Function PosRangeStr( Start : Integer; const HeadString, TailString, SourceString : string; var RangeBegin : Integer; var RangeEnd : Integer) : Boolean');
 CL.AddDelphiFunction('Function PosRangeText( Start : Integer; const HeadString, TailString, SourceString : string; var RangeBegin : Integer; var RangeEnd : Integer) : Boolean');
 CL.AddDelphiFunction('Function BackPosRangeStr( Start : Integer; const HeadString, TailString, SourceString : string; var RangeBegin : Integer; var RangeEnd : Integer) : Boolean');
 CL.AddDelphiFunction('Function BackPosRangeText( Start : Integer; const HeadString, TailString, SourceString : string; var RangeBegin : Integer; var RangeEnd : Integer) : Boolean');
 CL.AddDelphiFunction('Function PosTag( Start : Integer; SourceString : string; var RangeBegin : Integer; var RangeEnd : Integer) : Boolean');
 CL.AddDelphiFunction('Function InnerTag( Start : Integer; const HeadString, TailString, SourceString : string; var RangeBegin : Integer; var RangeEnd : Integer) : Boolean');
 CL.AddDelphiFunction('Function Easter( NYear : Integer) : TDateTime');
 CL.AddDelphiFunction('Function GetWeekNumber( Today : TDateTime) : string');
 CL.AddDelphiFunction('Function ParseNumber( const S : string) : Integer');
 CL.AddDelphiFunction('Function ParseDateJ( const S : string) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JvStrings_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ReplaceFirst, 'ReplaceFirst', cdRegister);
 S.RegisterDelphiFunction(@ReplaceLast, 'ReplaceLast', cdRegister);
 S.RegisterDelphiFunction(@InsertLastBlock, 'InsertLastBlock', cdRegister);
 S.RegisterDelphiFunction(@RemoveMasterBlocks, 'RemoveMasterBlocks', cdRegister);
 S.RegisterDelphiFunction(@RemoveFields, 'RemoveFields', cdRegister);
 S.RegisterDelphiFunction(@URLEncode, 'URLEncode', cdRegister);
 S.RegisterDelphiFunction(@URLDecode, 'URLDecode', cdRegister);
 S.RegisterDelphiFunction(@SplitSet, 'SplitSet', cdRegister);
 S.RegisterDelphiFunction(@JoinSet, 'JoinSet', cdRegister);
 S.RegisterDelphiFunction(@FirstOfSet, 'FirstOfSet', cdRegister);
 S.RegisterDelphiFunction(@LastOfSet, 'LastOfSet', cdRegister);
 S.RegisterDelphiFunction(@CountOfSet, 'CountOfSet', cdRegister);
 S.RegisterDelphiFunction(@SetRotateRight, 'SetRotateRight', cdRegister);
 S.RegisterDelphiFunction(@SetRotateLeft, 'SetRotateLeft', cdRegister);
 S.RegisterDelphiFunction(@SetPick, 'SetPick', cdRegister);
 S.RegisterDelphiFunction(@SetSort, 'SetSort', cdRegister);
 S.RegisterDelphiFunction(@SetUnion, 'SetUnion', cdRegister);
 S.RegisterDelphiFunction(@SetIntersect, 'SetIntersect', cdRegister);
 S.RegisterDelphiFunction(@SetExclude, 'SetExclude', cdRegister);
 S.RegisterDelphiFunction(@XMLSafe, 'XMLSafe', cdRegister);
 S.RegisterDelphiFunction(@Hash, 'Hash', cdRegister);
 S.RegisterDelphiFunction(@B64Encode, 'B64Encode', cdRegister);
 S.RegisterDelphiFunction(@B64Decode, 'B64Decode', cdRegister);
 S.RegisterDelphiFunction(@Encrypt, 'Encrypt', cdRegister);
 S.RegisterDelphiFunction(@Decrypt, 'Decrypt', cdRegister);
 S.RegisterDelphiFunction(@EncryptB64, 'EncryptB64', cdRegister);
 S.RegisterDelphiFunction(@DecryptB64, 'DecryptB64', cdRegister);
 S.RegisterDelphiFunction(@CSVToTags, 'CSVToTags', cdRegister);
 S.RegisterDelphiFunction(@TagsToCSV, 'TagsToCSV', cdRegister);
 S.RegisterDelphiFunction(@ListSelect, 'ListSelect', cdRegister);
 S.RegisterDelphiFunction(@ListFilter, 'ListFilter', cdRegister);
 S.RegisterDelphiFunction(@ListOrderBy, 'ListOrderBy', cdRegister);
 S.RegisterDelphiFunction(@PosStr, 'PosStr', cdRegister);
 S.RegisterDelphiFunction(@PosStrLast, 'PosStrLast', cdRegister);
 S.RegisterDelphiFunction(@LastPosChar, 'LastPosChar', cdRegister);
 S.RegisterDelphiFunction(@PosText, 'PosText', cdRegister);
 S.RegisterDelphiFunction(@PosTextLast, 'PosTextLast', cdRegister);
 S.RegisterDelphiFunction(@NameValuesToXML, 'NameValuesToXML', cdRegister);
 S.RegisterDelphiFunction(@LoadResourceFile, 'LoadResourceFile', cdRegister);
 S.RegisterDelphiFunction(@DirFiles, 'DirFiles', cdRegister);
 S.RegisterDelphiFunction(@RecurseDirFiles, 'RecurseDirFiles', cdRegister);
 S.RegisterDelphiFunction(@RecurseDirProgs, 'RecurseDirProgs', cdRegister);
 S.RegisterDelphiFunction(@SaveString, 'SaveString', cdRegister);
 S.RegisterDelphiFunction(@SaveString, 'Writeln2', cdRegister);
 S.RegisterDelphiFunction(@SaveString, 'Saveln', cdRegister);
 S.RegisterDelphiFunction(@SaveString, 'SaveStringasFile', cdRegister);
 S.RegisterDelphiFunction(@SaveString, 'SaveStringtoFile', cdRegister);
 S.RegisterDelphiFunction(@LoadString, 'LoadStringJ', cdRegister);
 S.RegisterDelphiFunction(@LoadString, 'LoadStringofFile', cdRegister);
 S.RegisterDelphiFunction(@LoadString, 'LSOF', cdRegister);

 S.RegisterDelphiFunction(@LoadString, 'LoadStringofFile', cdRegister);
 S.RegisterDelphiFunction(@LoadString, 'LoadStringfromFile', cdRegister);
 S.RegisterDelphiFunction(@HexToColor, 'HexToColor', cdRegister);
 S.RegisterDelphiFunction(@UppercaseHTMLTags, 'UppercaseHTMLTags', cdRegister);
 S.RegisterDelphiFunction(@LowercaseHTMLTags, 'LowercaseHTMLTags', cdRegister);
 S.RegisterDelphiFunction(@GetHTMLAnchors, 'GetHTMLAnchors', cdRegister);
 S.RegisterDelphiFunction(@RelativePath, 'RelativePath', cdRegister);
 S.RegisterDelphiFunction(@GetToken, 'GetToken', cdRegister);
 S.RegisterDelphiFunction(@PosNonSpace, 'PosNonSpace', cdRegister);
 S.RegisterDelphiFunction(@PosEscaped, 'PosEscaped', cdRegister);
 S.RegisterDelphiFunction(@DeleteEscaped, 'DeleteEscaped', cdRegister);
 S.RegisterDelphiFunction(@BeginOfAttribute, 'BeginOfAttribute', cdRegister);
 S.RegisterDelphiFunction(@ParseAttribute, 'ParseAttribute', cdRegister);
 S.RegisterDelphiFunction(@ParseAttributes, 'ParseAttributes', cdRegister);
 S.RegisterDelphiFunction(@HasStrValue, 'HasStrValue', cdRegister);
 S.RegisterDelphiFunction(@GetStrValue, 'GetStrValue', cdRegister);
 S.RegisterDelphiFunction(@GetHTMLColorValue, 'GetHTMLColorValue', cdRegister);
 S.RegisterDelphiFunction(@GetIntValue, 'GetIntValue', cdRegister);
 S.RegisterDelphiFunction(@GetFloatValue, 'GetFloatValue', cdRegister);
 S.RegisterDelphiFunction(@GetBoolValue, 'GetBoolValue', cdRegister);
 S.RegisterDelphiFunction(@GetValue, 'GetValue', cdRegister);
 S.RegisterDelphiFunction(@SetValue, 'SetValue', cdRegister);
 S.RegisterDelphiFunction(@DeleteValue, 'DeleteValue', cdRegister);
 S.RegisterDelphiFunction(@GetNames, 'GetNames', cdRegister);
 S.RegisterDelphiFunction(@GetHTMLColor, 'GetHTMLColor', cdRegister);
 S.RegisterDelphiFunction(@BackPosStr, 'BackPosStr', cdRegister);
 S.RegisterDelphiFunction(@BackPosText, 'BackPosText', cdRegister);
 S.RegisterDelphiFunction(@PosRangeStr, 'PosRangeStr', cdRegister);
 S.RegisterDelphiFunction(@PosRangeText, 'PosRangeText', cdRegister);
 S.RegisterDelphiFunction(@BackPosRangeStr, 'BackPosRangeStr', cdRegister);
 S.RegisterDelphiFunction(@BackPosRangeText, 'BackPosRangeText', cdRegister);
 S.RegisterDelphiFunction(@PosTag, 'PosTag', cdRegister);
 S.RegisterDelphiFunction(@InnerTag, 'InnerTag', cdRegister);
 S.RegisterDelphiFunction(@Easter, 'Easter', cdRegister);
 S.RegisterDelphiFunction(@GetWeekNumber, 'GetWeekNumber', cdRegister);
 S.RegisterDelphiFunction(@ParseNumber, 'ParseNumber', cdRegister);
 S.RegisterDelphiFunction(@ParseDate, 'ParseDateJ', cdRegister);
end;


 
{ TPSImport_JvStrings }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStrings.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvStrings(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStrings.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvStrings(ri);
  RIRegister_JvStrings_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
