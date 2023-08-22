unit uPSI_StStrS;
{
   short string funcs
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
  TPSImport_StStrS = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StStrS(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StStrS_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StStrS
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StStrS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StStrS(CL: TPSPascalCompiler);
begin

 // BTable  = array[0..255] of Byte;  {Table used by Boyer-Moore search routines}
 CL.AddTypeS('BTable', 'array of Byte');       //!!!

 CL.AddDelphiFunction('Function HexBS( B : Byte) : ShortString');
 CL.AddDelphiFunction('Function HexWS( W : Word) : ShortString');
 CL.AddDelphiFunction('Function HexLS( L : LongInt) : ShortString');
 CL.AddDelphiFunction('Function HexPtrS( P : ___Pointer) : ShortString');
 CL.AddDelphiFunction('Function BinaryBS( B : Byte) : ShortString');
 CL.AddDelphiFunction('Function BinaryWS( W : Word) : ShortString');
 CL.AddDelphiFunction('Function BinaryLS( L : LongInt) : ShortString');
 CL.AddDelphiFunction('Function OctalBS( B : Byte) : ShortString');
 CL.AddDelphiFunction('Function OctalWS( W : Word) : ShortString');
 CL.AddDelphiFunction('Function OctalLS( L : LongInt) : ShortString');
 CL.AddDelphiFunction('Function Str2Int16S( const S : ShortString; var I : SmallInt) : Boolean');
 CL.AddDelphiFunction('Function Str2WordS( const S : ShortString; var I : Word) : Boolean');
 CL.AddDelphiFunction('Function Str2LongS( const S : ShortString; var I : LongInt) : Boolean');
 CL.AddDelphiFunction('Function Str2RealS( const S : ShortString; var R : Double) : Boolean');
 CL.AddDelphiFunction('Function Str2RealS( const S : ShortString; var R : Real) : Boolean');
 CL.AddDelphiFunction('Function Str2ExtS( const S : ShortString; var R : Extended) : Boolean');
 CL.AddDelphiFunction('Function Long2StrS( L : LongInt) : ShortString');
 CL.AddDelphiFunction('Function Real2StrS( R : Double; Width : Byte; Places : ShortInt) : ShortString');
 CL.AddDelphiFunction('Function Ext2StrS( R : Extended; Width : Byte; Places : ShortInt) : ShortString');
 CL.AddDelphiFunction('Function ValPrepS( const S : ShortString) : ShortString');
 CL.AddDelphiFunction('Function CharStrS( C : AnsiChar; Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function PadChS( const S : ShortString; C : AnsiChar; Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function PadS( const S : ShortString; Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function LeftPadChS( const S : ShortString; C : AnsiChar; Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function LeftPadS( const S : ShortString; Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function TrimLeadS( const S : ShortString) : ShortString');
 CL.AddDelphiFunction('Function TrimTrailS( const S : ShortString) : ShortString');
 CL.AddDelphiFunction('Function TrimS( const S : ShortString) : ShortString');
 CL.AddDelphiFunction('Function TrimSpacesS( const S : ShortString) : ShortString');
 CL.AddDelphiFunction('Function CenterChS( const S : ShortString; C : AnsiChar; Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function CenterS( const S : ShortString; Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function EntabS( const S : ShortString; TabSize : Byte) : ShortString');
 CL.AddDelphiFunction('Function DetabS( const S : ShortString; TabSize : Byte) : ShortString');
 CL.AddDelphiFunction('Function ScrambleS( const S, Key : ShortString) : ShortString');
 CL.AddDelphiFunction('Function SubstituteS( const S, FromStr, ToStr : ShortString) : ShortString');
 CL.AddDelphiFunction('Function FilterS( const S, Filters : ShortString) : ShortString');
 CL.AddDelphiFunction('Function CharExistsS( const S : ShortString; C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharCountS( const S : ShortString; C : AnsiChar) : Byte');
 CL.AddDelphiFunction('Function WordCountS( const S, WordDelims : ShortString) : Cardinal');
 CL.AddDelphiFunction('Function WordPositionS( N : Cardinal; const S, WordDelims : ShortString; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function ExtractWordS( N : Cardinal; const S, WordDelims : ShortString) : ShortString');
 CL.AddDelphiFunction('Function AsciiCountS( const S, WordDelims : ShortString; Quote : AnsiChar) : Cardinal');
 CL.AddDelphiFunction('Function AsciiPositionS( N : Cardinal; const S, WordDelims : ShortString; Quote : AnsiChar; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function ExtractAsciiS( N : Cardinal; const S, WordDelims : ShortString; Quote : AnsiChar) : ShortString');
 CL.AddDelphiFunction('Procedure WordWrapS( const InSt : ShortString; var OutSt, Overlap : ShortString; Margin : Cardinal; PadToMargin : Boolean)');
 CL.AddDelphiFunction('Function CompStringS( const S1, S2 : ShortString) : Integer');
 CL.AddDelphiFunction('Function CompUCStringS( const S1, S2 : ShortString) : Integer');
 CL.AddDelphiFunction('Function SoundexS( const S : ShortString) : ShortString');
 CL.AddDelphiFunction('Function MakeLetterSetS( const S : ShortString) : Longint');
 CL.AddDelphiFunction('Procedure BMMakeTableS( const MatchString : ShortString; var BT : BTable)');
 CL.AddDelphiFunction('Function BMSearchS( var Buffer, BufLength : Cardinal; var BT : BTable; const MatchString : ShortString; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function BMSearchUCS( var Buffer, BufLength : Cardinal; var BT : BTable; const MatchString : ShortString; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function DefaultExtensionS( const Name, Ext : ShortString) : ShortString');
 CL.AddDelphiFunction('Function ForceExtensionS( const Name, Ext : ShortString) : ShortString');
 CL.AddDelphiFunction('Function JustFilenameS( const PathName : ShortString) : ShortString');
 CL.AddDelphiFunction('Function JustNameS( const PathName : ShortString) : ShortString');
 CL.AddDelphiFunction('Function JustExtensionS( const Name : ShortString) : ShortString');
 CL.AddDelphiFunction('Function JustPathnameS( const PathName : ShortString) : ShortString');
 CL.AddDelphiFunction('Function AddBackSlashS( const DirName : ShortString) : ShortString');
 CL.AddDelphiFunction('Function CleanPathNameS( const PathName : ShortString) : ShortString');
 CL.AddDelphiFunction('Function HasExtensionS( const Name : ShortString; var DotPos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CommaizeS( L : LongInt) : ShortString');
 CL.AddDelphiFunction('Function CommaizeChS( L : Longint; Ch : AnsiChar) : ShortString');
 CL.AddDelphiFunction('Function FloatFormS( const Mask : ShortString; R : TstFloat; const LtCurr, RtCurr : ShortString; Sep, DecPt : AnsiChar) : ShortString');
 CL.AddDelphiFunction('Function LongIntFormS( const Mask : ShortString; L : LongInt; const LtCurr, RtCurr : ShortString; Sep : AnsiChar) : ShortString');
 CL.AddDelphiFunction('Function StrChPosS( const P : ShortString; C : AnsiChar; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrStPosS( const P, S : ShortString; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrStCopyS( const S : ShortString; Pos, Count : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function StrChInsertS( const S : ShortString; C : AnsiChar; Pos : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function StrStInsertS( const S1, S2 : ShortString; Pos : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function StrChDeleteS( const S : ShortString; Pos : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function StrStDeleteS( const S : ShortString; Pos, Count : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function ContainsOnlyS( const S, Chars : ShortString; var BadPos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function ContainsOtherThanS( const S, Chars : ShortString; var BadPos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CopyLeftS( const S : ShortString; Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function CopyMidS( const S : ShortString; First, Len : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function CopyRightS( const S : ShortString; First : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function CopyRightAbsS( const S : ShortString; NumChars : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function CopyFromNthWordS( const S, WordDelims : ShortString; const AWord : ShortString; N : Cardinal; var SubString : ShortString) : Boolean');
 CL.AddDelphiFunction('Function DeleteFromNthWordS( const S, WordDelims : ShortString; AWord : ShortString; N : Cardinal; var SubString : ShortString) : Boolean');
 CL.AddDelphiFunction('Function CopyFromToWordS( const S, WordDelims, Word1, Word2 : ShortString; N1, N2 : Cardinal; var SubString : ShortString) : Boolean');
 CL.AddDelphiFunction('Function DeleteFromToWordS( const S, WordDelims, Word1, Word2 : ShortString; N1, N2 : Cardinal; var SubString : ShortString) : Boolean');
 CL.AddDelphiFunction('Function CopyWithinS( const S, Delimiter : ShortString; Strip : Boolean) : ShortString');
 CL.AddDelphiFunction('Function DeleteWithinS( const S, Delimiter : ShortString) : ShortString');
 CL.AddDelphiFunction('Function ExtractTokensS( const S, Delims : ShortString; QuoteChar : AnsiChar; AllowNulls : Boolean; Tokens : TStrings) : Cardinal');
 CL.AddDelphiFunction('Function IsChAlphaS( C : Char) : Boolean');
 CL.AddDelphiFunction('Function IsChNumericS( C : Char; const Numbers : ShortString) : Boolean');
 CL.AddDelphiFunction('Function IsChAlphaNumericS( C : Char; const Numbers : ShortString) : Boolean');
 CL.AddDelphiFunction('Function IsStrAlphaS( const S : Shortstring) : Boolean');
 CL.AddDelphiFunction('Function IsStrNumericS( const S, Numbers : ShortString) : Boolean');
 CL.AddDelphiFunction('Function IsStrAlphaNumericS( const S, Numbers : ShortString) : Boolean');
 CL.AddDelphiFunction('Function LastWordS( const S, WordDelims, AWord : ShortString; var Position : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function LastWordAbsS( const S, WordDelims : ShortString; var Position : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function LastStringS( const S, AString : ShortString; var Position : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function LeftTrimCharsS( const S, Chars : ShortString) : ShortString');
 CL.AddDelphiFunction('Function KeepCharsS( const S, Chars : ShortString) : ShortString');
 CL.AddDelphiFunction('Function RepeatStringS( const RepeatString : ShortString; var Repetitions : Cardinal; MaxLen : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function ReplaceStringSS( const S, OldString, NewString : ShortString; N : Cardinal; var Replacements : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function ReplaceStringAllS( const S, OldString, NewString : ShortString; var Replacements : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function ReplaceWordS( const S, WordDelims, OldWord, NewWord : ShortString; N : Cardinal; var Replacements : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function ReplaceWordAllS( const S, WordDelims, OldWord, NewWord : ShortString; var Replacements : Cardinal) : ShortString');
 CL.AddDelphiFunction('Function RightTrimCharsS( const S, Chars : ShortString) : ShortString');
 CL.AddDelphiFunction('Function StrWithinS( const S, SearchStr : ShortString; Start : Cardinal; var Position : Cardinal) : boolean');
 CL.AddDelphiFunction('Function TrimCharsS( const S, Chars : ShortString) : ShortString');
 CL.AddDelphiFunction('Function WordPosS( const S, WordDelims, AWord : ShortString; N : Cardinal; var Position : Cardinal) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StStrS_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HexBS, 'HexBS', cdRegister);
 S.RegisterDelphiFunction(@HexWS, 'HexWS', cdRegister);
 S.RegisterDelphiFunction(@HexLS, 'HexLS', cdRegister);
 S.RegisterDelphiFunction(@HexPtrS, 'HexPtrS', cdRegister);
 S.RegisterDelphiFunction(@BinaryBS, 'BinaryBS', cdRegister);
 S.RegisterDelphiFunction(@BinaryWS, 'BinaryWS', cdRegister);
 S.RegisterDelphiFunction(@BinaryLS, 'BinaryLS', cdRegister);
 S.RegisterDelphiFunction(@OctalBS, 'OctalBS', cdRegister);
 S.RegisterDelphiFunction(@OctalWS, 'OctalWS', cdRegister);
 S.RegisterDelphiFunction(@OctalLS, 'OctalLS', cdRegister);
 S.RegisterDelphiFunction(@Str2Int16S, 'Str2Int16S', cdRegister);
 S.RegisterDelphiFunction(@Str2WordS, 'Str2WordS', cdRegister);
 S.RegisterDelphiFunction(@Str2LongS, 'Str2LongS', cdRegister);
 S.RegisterDelphiFunction(@Str2RealS, 'Str2RealS', cdRegister);
 S.RegisterDelphiFunction(@Str2RealS, 'Str2RealS', cdRegister);
 S.RegisterDelphiFunction(@Str2ExtS, 'Str2ExtS', cdRegister);
 S.RegisterDelphiFunction(@Long2StrS, 'Long2StrS', cdRegister);
 S.RegisterDelphiFunction(@Real2StrS, 'Real2StrS', cdRegister);
 S.RegisterDelphiFunction(@Ext2StrS, 'Ext2StrS', cdRegister);
 S.RegisterDelphiFunction(@ValPrepS, 'ValPrepS', cdRegister);
 S.RegisterDelphiFunction(@CharStrS, 'CharStrS', cdRegister);
 S.RegisterDelphiFunction(@PadChS, 'PadChS', cdRegister);
 S.RegisterDelphiFunction(@PadS, 'PadS', cdRegister);
 S.RegisterDelphiFunction(@LeftPadChS, 'LeftPadChS', cdRegister);
 S.RegisterDelphiFunction(@LeftPadS, 'LeftPadS', cdRegister);
 S.RegisterDelphiFunction(@TrimLeadS, 'TrimLeadS', cdRegister);
 S.RegisterDelphiFunction(@TrimTrailS, 'TrimTrailS', cdRegister);
 S.RegisterDelphiFunction(@TrimS, 'TrimS', cdRegister);
 S.RegisterDelphiFunction(@TrimSpacesS, 'TrimSpacesS', cdRegister);
 S.RegisterDelphiFunction(@CenterChS, 'CenterChS', cdRegister);
 S.RegisterDelphiFunction(@CenterS, 'CenterS', cdRegister);
 S.RegisterDelphiFunction(@EntabS, 'EntabS', cdRegister);
 S.RegisterDelphiFunction(@DetabS, 'DetabS', cdRegister);
 S.RegisterDelphiFunction(@ScrambleS, 'ScrambleS', cdRegister);
 S.RegisterDelphiFunction(@SubstituteS, 'SubstituteS', cdRegister);
 S.RegisterDelphiFunction(@FilterS, 'FilterS', cdRegister);
 S.RegisterDelphiFunction(@CharExistsS, 'CharExistsS', cdRegister);
 S.RegisterDelphiFunction(@CharCountS, 'CharCountS', cdRegister);
 S.RegisterDelphiFunction(@WordCountS, 'WordCountS', cdRegister);
 S.RegisterDelphiFunction(@WordPositionS, 'WordPositionS', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordS, 'ExtractWordS', cdRegister);
 S.RegisterDelphiFunction(@AsciiCountS, 'AsciiCountS', cdRegister);
 S.RegisterDelphiFunction(@AsciiPositionS, 'AsciiPositionS', cdRegister);
 S.RegisterDelphiFunction(@ExtractAsciiS, 'ExtractAsciiS', cdRegister);
 S.RegisterDelphiFunction(@WordWrapS, 'WordWrapS', cdRegister);
 S.RegisterDelphiFunction(@CompStringS, 'CompStringS', cdRegister);
 S.RegisterDelphiFunction(@CompUCStringS, 'CompUCStringS', cdRegister);
 S.RegisterDelphiFunction(@SoundexS, 'SoundexS', cdRegister);
 S.RegisterDelphiFunction(@MakeLetterSetS, 'MakeLetterSetS', cdRegister);
 S.RegisterDelphiFunction(@BMMakeTableS, 'BMMakeTableS', cdRegister);
 S.RegisterDelphiFunction(@BMSearchS, 'BMSearchS', cdRegister);
 S.RegisterDelphiFunction(@BMSearchUCS, 'BMSearchUCS', cdRegister);
 S.RegisterDelphiFunction(@DefaultExtensionS, 'DefaultExtensionS', cdRegister);
 S.RegisterDelphiFunction(@ForceExtensionS, 'ForceExtensionS', cdRegister);
 S.RegisterDelphiFunction(@JustFilenameS, 'JustFilenameS', cdRegister);
 S.RegisterDelphiFunction(@JustNameS, 'JustNameS', cdRegister);
 S.RegisterDelphiFunction(@JustExtensionS, 'JustExtensionS', cdRegister);
 S.RegisterDelphiFunction(@JustPathnameS, 'JustPathnameS', cdRegister);
 S.RegisterDelphiFunction(@AddBackSlashS, 'AddBackSlashS', cdRegister);
 S.RegisterDelphiFunction(@CleanPathNameS, 'CleanPathNameS', cdRegister);
 S.RegisterDelphiFunction(@HasExtensionS, 'HasExtensionS', cdRegister);
 S.RegisterDelphiFunction(@CommaizeS, 'CommaizeS', cdRegister);
 S.RegisterDelphiFunction(@CommaizeChS, 'CommaizeChS', cdRegister);
 S.RegisterDelphiFunction(@FloatFormS, 'FloatFormS', cdRegister);
 S.RegisterDelphiFunction(@LongIntFormS, 'LongIntFormS', cdRegister);
 S.RegisterDelphiFunction(@StrChPosS, 'StrChPosS', cdRegister);
 S.RegisterDelphiFunction(@StrStPosS, 'StrStPosS', cdRegister);
 S.RegisterDelphiFunction(@StrStCopyS, 'StrStCopyS', cdRegister);
 S.RegisterDelphiFunction(@StrChInsertS, 'StrChInsertS', cdRegister);
 S.RegisterDelphiFunction(@StrStInsertS, 'StrStInsertS', cdRegister);
 S.RegisterDelphiFunction(@StrChDeleteS, 'StrChDeleteS', cdRegister);
 S.RegisterDelphiFunction(@StrStDeleteS, 'StrStDeleteS', cdRegister);
 S.RegisterDelphiFunction(@ContainsOnlyS, 'ContainsOnlyS', cdRegister);
 S.RegisterDelphiFunction(@ContainsOtherThanS, 'ContainsOtherThanS', cdRegister);
 S.RegisterDelphiFunction(@CopyLeftS, 'CopyLeftS', cdRegister);
 S.RegisterDelphiFunction(@CopyMidS, 'CopyMidS', cdRegister);
 S.RegisterDelphiFunction(@CopyRightS, 'CopyRightS', cdRegister);
 S.RegisterDelphiFunction(@CopyRightAbsS, 'CopyRightAbsS', cdRegister);
 S.RegisterDelphiFunction(@CopyFromNthWordS, 'CopyFromNthWordS', cdRegister);
 S.RegisterDelphiFunction(@DeleteFromNthWordS, 'DeleteFromNthWordS', cdRegister);
 S.RegisterDelphiFunction(@CopyFromToWordS, 'CopyFromToWordS', cdRegister);
 S.RegisterDelphiFunction(@DeleteFromToWordS, 'DeleteFromToWordS', cdRegister);
 S.RegisterDelphiFunction(@CopyWithinS, 'CopyWithinS', cdRegister);
 S.RegisterDelphiFunction(@DeleteWithinS, 'DeleteWithinS', cdRegister);
 S.RegisterDelphiFunction(@ExtractTokensS, 'ExtractTokensS', cdRegister);
 S.RegisterDelphiFunction(@IsChAlphaS, 'IsChAlphaS', cdRegister);
 S.RegisterDelphiFunction(@IsChNumericS, 'IsChNumericS', cdRegister);
 S.RegisterDelphiFunction(@IsChAlphaNumericS, 'IsChAlphaNumericS', cdRegister);
 S.RegisterDelphiFunction(@IsStrAlphaS, 'IsStrAlphaS', cdRegister);
 S.RegisterDelphiFunction(@IsStrNumericS, 'IsStrNumericS', cdRegister);
 S.RegisterDelphiFunction(@IsStrAlphaNumericS, 'IsStrAlphaNumericS', cdRegister);
 S.RegisterDelphiFunction(@LastWordS, 'LastWordS', cdRegister);
 S.RegisterDelphiFunction(@LastWordAbsS, 'LastWordAbsS', cdRegister);
 S.RegisterDelphiFunction(@LastStringS, 'LastStringS', cdRegister);
 S.RegisterDelphiFunction(@LeftTrimCharsS, 'LeftTrimCharsS', cdRegister);
 S.RegisterDelphiFunction(@KeepCharsS, 'KeepCharsS', cdRegister);
 S.RegisterDelphiFunction(@RepeatStringS, 'RepeatStringS', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStringS, 'ReplaceStringSS', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStringAllS, 'ReplaceStringAllS', cdRegister);
 S.RegisterDelphiFunction(@ReplaceWordS, 'ReplaceWordS', cdRegister);
 S.RegisterDelphiFunction(@ReplaceWordAllS, 'ReplaceWordAllS', cdRegister);
 S.RegisterDelphiFunction(@RightTrimCharsS, 'RightTrimCharsS', cdRegister);
 S.RegisterDelphiFunction(@StrWithinS, 'StrWithinS', cdRegister);
 S.RegisterDelphiFunction(@TrimCharsS, 'TrimCharsS', cdRegister);
 S.RegisterDelphiFunction(@WordPosS, 'WordPosS', cdRegister);
end;

 
 
{ TPSImport_StStrS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StStrS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StStrS(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StStrS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StStrS(ri);
  RIRegister_StStrS_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
