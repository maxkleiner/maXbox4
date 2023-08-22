unit uPSI_StStrL;
{
   big string utils
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
  TPSImport_StStrL = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StStrL(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StStrL_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StStrL
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StStrL]);
end;


  type ansichar= char;
(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StStrL(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('LStrRec', 'record AllocSize : Longint; RefCount : Longint; Length : Longint; end');
   CL.AddTypeS('AnsiChar', 'Char');
    CL.AddTypeS('BTable', 'array[0..255] of Byte');       //!!!

  CL.AddDelphiFunction('Function HexBL( B : Byte) : AnsiString');
 CL.AddDelphiFunction('Function HexWL( W : Word) : AnsiString');
 CL.AddDelphiFunction('Function HexLL( L : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function HexPtrL( P : ___Pointer) : AnsiString');
 CL.AddDelphiFunction('Function BinaryBL( B : Byte) : AnsiString');
 CL.AddDelphiFunction('Function BinaryWL( W : Word) : AnsiString');
 CL.AddDelphiFunction('Function BinaryLL( L : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function OctalBL( B : Byte) : AnsiString');
 CL.AddDelphiFunction('Function OctalWL( W : Word) : AnsiString');
 CL.AddDelphiFunction('Function OctalLL( L : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function Str2Int16L( const S : AnsiString; var I : SmallInt) : Boolean');
 CL.AddDelphiFunction('Function Str2WordL( const S : AnsiString; var I : Word) : Boolean');
 CL.AddDelphiFunction('Function Str2LongL( const S : AnsiString; var I : LongInt) : Boolean');
 CL.AddDelphiFunction('Function Str2RealL( const S : AnsiString; var R : Double) : Boolean');
 CL.AddDelphiFunction('Function Str2RealL( const S : AnsiString; var R : Real) : Boolean');
 CL.AddDelphiFunction('Function Str2ExtL( const S : AnsiString; var R : Extended) : Boolean');
 CL.AddDelphiFunction('Function Long2StrL( L : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function Real2StrL( R : Double; Width : Byte; Places : ShortInt) : AnsiString');
 CL.AddDelphiFunction('Function Ext2StrL( R : Extended; Width : Byte; Places : ShortInt) : AnsiString');
 CL.AddDelphiFunction('Function ValPrepL( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function CharStrL( C : Char; Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function PadChL( const S : AnsiString; C : AnsiChar; Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function PadLL( const S : AnsiString; Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function LeftPadChL( const S : AnsiString; C : AnsiChar; Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function LeftPadL( const S : AnsiString; Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function TrimLeadL( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function TrimTrailL( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function TrimL( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function TrimSpacesL( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function CenterChL( const S : AnsiString; C : AnsiChar; Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function CenterL( const S : AnsiString; Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function EntabL( const S : AnsiString; TabSize : Byte) : AnsiString');
 CL.AddDelphiFunction('Function DetabL( const S : AnsiString; TabSize : Byte) : AnsiString');
 CL.AddDelphiFunction('Function ScrambleL( const S, Key : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function SubstituteL( const S, FromStr, ToStr : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function FilterL( const S, Filters : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function CharExistsL( const S : AnsiString; C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function CharCountL( const S : AnsiString; C : AnsiChar) : Cardinal');
 CL.AddDelphiFunction('Function WordCountL( const S, WordDelims : AnsiString) : Cardinal');
 CL.AddDelphiFunction('Function WordPositionL( N : Cardinal; const S, WordDelims : AnsiString; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function ExtractWordL( N : Cardinal; const S, WordDelims : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AsciiCountL( const S, WordDelims : AnsiString; Quote : AnsiChar) : Cardinal');
 CL.AddDelphiFunction('Function AsciiPositionL( N : Cardinal; const S, WordDelims : AnsiString; Quote : AnsiChar; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function ExtractAsciiL( N : Cardinal; const S, WordDelims : AnsiString; Quote : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Procedure WordWrapL( const InSt : AnsiString; var OutSt, Overlap : AnsiString; Margin : Cardinal; PadToMargin : Boolean)');
 CL.AddDelphiFunction('Procedure WordWrap( const InSt : AnsiString; var OutSt, Overlap : AnsiString; Margin : Cardinal; PadToMargin : Boolean)');
 CL.AddDelphiFunction('Function CompStringL( const S1, S2 : AnsiString) : Integer');
 CL.AddDelphiFunction('Function CompUCStringL( const S1, S2 : AnsiString) : Integer');
 CL.AddDelphiFunction('Function SoundexL( const S : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function MakeLetterSetL( const S : AnsiString) : Longint');
 CL.AddDelphiFunction('Procedure BMMakeTableL( const MatchString : AnsiString; var BT : BTable)');
 CL.AddDelphiFunction('Function BMSearchL( var Buffer, BufLength : Cardinal; var BT : BTable; const MatchString : AnsiString; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function BMSearchUCL( var Buffer, BufLength : Cardinal; var BT : BTable; const MatchString : AnsiString; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function DefaultExtensionL( const Name, Ext : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ForceExtensionL( const Name, Ext : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function JustFilenameL( const PathName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function JustNameL( const PathName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function JustExtensionL( const Name : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function JustPathnameL( const PathName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AddBackSlashL( const DirName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function CleanPathNameL( const PathName : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function HasExtensionL( const Name : AnsiString; var DotPos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CommaizeL( L : LongInt) : AnsiString');
 CL.AddDelphiFunction('Function CommaizeChL( L : Longint; Ch : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function FloatFormL( const Mask : AnsiString; R : TstFloat; const LtCurr, RtCurr : AnsiString; Sep, DecPt : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function LongIntFormL( const Mask : AnsiString; L : LongInt; const LtCurr, RtCurr : AnsiString; Sep : AnsiChar) : AnsiString');
 CL.AddDelphiFunction('Function StrChPosL( const P : AnsiString; C : AnsiChar; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrStPosL( const P, S : AnsiString; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function StrStCopyL( const S : AnsiString; Pos, Count : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function StrChInsertL( const S : AnsiString; C : AnsiChar; Pos : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function StrStInsertL( const S1, S2 : AnsiString; Pos : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function StrChDeleteL( const S : AnsiString; Pos : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function StrStDeleteL( const S : AnsiString; Pos, Count : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function ContainsOnlyL( const S, Chars : AnsiString; var BadPos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function ContainsOtherThanL( const S, Chars : AnsiString; var BadPos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function CopyLeftL( const S : AnsiString; Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function CopyMidL( const S : AnsiString; First, Len : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function CopyRightL( const S : AnsiString; First : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function CopyRightAbsL( const S : AnsiString; NumChars : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function CopyFromNthWordL( const S, WordDelims : AnsiString; const AWord : AnsiString; N : Cardinal; var SubString : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function CopyFromToWordL( const S, WordDelims, Word1, Word2 : AnsiString; N1, N2 : Cardinal; var SubString : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function CopyWithinL( const S, Delimiter : AnsiString; Strip : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function DeleteFromNthWordL( const S, WordDelims : AnsiString; const AWord : AnsiString; N : Cardinal; var SubString : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function DeleteFromToWordL( const S, WordDelims, Word1, Word2 : AnsiString; N1, N2 : Cardinal; var SubString : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function DeleteWithinL( const S, Delimiter : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ExtractTokensL( const S, Delims : AnsiString; QuoteChar : AnsiChar; AllowNulls : Boolean; Tokens : TStrings) : Cardinal');
 CL.AddDelphiFunction('Function IsChAlphaL( C : AnsiChar) : Boolean');
 CL.AddDelphiFunction('Function IsChNumericL( C : AnsiChar; const Numbers : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IsChAlphaNumericL( C : AnsiChar; const Numbers : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IsStrAlphaL( const S : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IsStrNumericL( const S, Numbers : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IsStrAlphaNumericL( const S, Numbers : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function KeepCharsL( const S, Chars : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function LastWordL( const S, WordDelims, AWord : AnsiString; var Position : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function LastWordAbsL( const S, WordDelims : AnsiString; var Position : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function LastStringL( const S, AString : AnsiString; var Position : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function LeftTrimCharsL( const S, Chars : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ReplaceWordL( const S, WordDelims, OldWord, NewWord : AnsiString; N : Cardinal; var Replacements : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function ReplaceWordAllL( const S, WordDelims, OldWord, NewWord : AnsiString; var Replacements : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function ReplaceStringL( const S, OldString, NewString : AnsiString; N : Cardinal; var Replacements : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function ReplaceStringAllL( const S, OldString, NewString : AnsiString; var Replacements : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function RepeatStringL( const RepeatString : AnsiString; var Repetitions : Cardinal; MaxLen : Cardinal) : AnsiString');
 CL.AddDelphiFunction('Function RightTrimCharsL( const S, Chars : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function StrWithinL( const S, SearchStr : string; Start : Cardinal; var Position : Cardinal) : boolean');
 CL.AddDelphiFunction('Function TrimCharsL( const S, Chars : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function WordPosL( const S, WordDelims, AWord : AnsiString; N : Cardinal; var Position : Cardinal) : Boolean');
  CL.AddDelphiFunction('Function WordPos( const S, WordDelims, AWord : AnsiString; N : Cardinal; var Position : Cardinal) : Boolean');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StStrL_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HexBL, 'HexBL', cdRegister);
 S.RegisterDelphiFunction(@HexWL, 'HexWL', cdRegister);
 S.RegisterDelphiFunction(@HexLL, 'HexLL', cdRegister);
 S.RegisterDelphiFunction(@HexPtrL, 'HexPtrL', cdRegister);
 S.RegisterDelphiFunction(@BinaryBL, 'BinaryBL', cdRegister);
 S.RegisterDelphiFunction(@BinaryWL, 'BinaryWL', cdRegister);
 S.RegisterDelphiFunction(@BinaryLL, 'BinaryLL', cdRegister);
 S.RegisterDelphiFunction(@OctalBL, 'OctalBL', cdRegister);
 S.RegisterDelphiFunction(@OctalWL, 'OctalWL', cdRegister);
 S.RegisterDelphiFunction(@OctalLL, 'OctalLL', cdRegister);
 S.RegisterDelphiFunction(@Str2Int16L, 'Str2Int16L', cdRegister);
 S.RegisterDelphiFunction(@Str2WordL, 'Str2WordL', cdRegister);
 S.RegisterDelphiFunction(@Str2LongL, 'Str2LongL', cdRegister);
 S.RegisterDelphiFunction(@Str2RealL, 'Str2RealL', cdRegister);
 S.RegisterDelphiFunction(@Str2RealL, 'Str2RealL', cdRegister);
 S.RegisterDelphiFunction(@Str2ExtL, 'Str2ExtL', cdRegister);
 S.RegisterDelphiFunction(@Long2StrL, 'Long2StrL', cdRegister);
 S.RegisterDelphiFunction(@Real2StrL, 'Real2StrL', cdRegister);
 S.RegisterDelphiFunction(@Ext2StrL, 'Ext2StrL', cdRegister);
 S.RegisterDelphiFunction(@ValPrepL, 'ValPrepL', cdRegister);
 S.RegisterDelphiFunction(@CharStrL, 'CharStrL', cdRegister);
 S.RegisterDelphiFunction(@PadChL, 'PadChL', cdRegister);
 S.RegisterDelphiFunction(@PadL, 'PadLL', cdRegister);
 S.RegisterDelphiFunction(@LeftPadChL, 'LeftPadChL', cdRegister);
 S.RegisterDelphiFunction(@LeftPadL, 'LeftPadL', cdRegister);
 S.RegisterDelphiFunction(@TrimLeadL, 'TrimLeadL', cdRegister);
 S.RegisterDelphiFunction(@TrimTrailL, 'TrimTrailL', cdRegister);
 S.RegisterDelphiFunction(@TrimL, 'TrimL', cdRegister);
 S.RegisterDelphiFunction(@TrimSpacesL, 'TrimSpacesL', cdRegister);
 S.RegisterDelphiFunction(@CenterChL, 'CenterChL', cdRegister);
 S.RegisterDelphiFunction(@CenterL, 'CenterL', cdRegister);
 S.RegisterDelphiFunction(@EntabL, 'EntabL', cdRegister);
 S.RegisterDelphiFunction(@DetabL, 'DetabL', cdRegister);
 S.RegisterDelphiFunction(@ScrambleL, 'ScrambleL', cdRegister);
 S.RegisterDelphiFunction(@SubstituteL, 'SubstituteL', cdRegister);
 S.RegisterDelphiFunction(@FilterL, 'FilterL', cdRegister);
 S.RegisterDelphiFunction(@CharExistsL, 'CharExistsL', cdRegister);
 S.RegisterDelphiFunction(@CharCountL, 'CharCountL', cdRegister);
 S.RegisterDelphiFunction(@WordCountL, 'WordCountL', cdRegister);
 S.RegisterDelphiFunction(@WordPositionL, 'WordPositionL', cdRegister);
 S.RegisterDelphiFunction(@ExtractWordL, 'ExtractWordL', cdRegister);
 S.RegisterDelphiFunction(@AsciiCountL, 'AsciiCountL', cdRegister);
 S.RegisterDelphiFunction(@AsciiPositionL, 'AsciiPositionL', cdRegister);
 S.RegisterDelphiFunction(@ExtractAsciiL, 'ExtractAsciiL', cdRegister);
 S.RegisterDelphiFunction(@WordWrapL, 'WordWrapL', cdRegister);
 S.RegisterDelphiFunction(@WordWrapL, 'WordWrap', cdRegister);
 S.RegisterDelphiFunction(@CompStringL, 'CompStringL', cdRegister);
 S.RegisterDelphiFunction(@CompUCStringL, 'CompUCStringL', cdRegister);
 S.RegisterDelphiFunction(@SoundexL, 'SoundexL', cdRegister);
 S.RegisterDelphiFunction(@MakeLetterSetL, 'MakeLetterSetL', cdRegister);
 S.RegisterDelphiFunction(@BMMakeTableL, 'BMMakeTableL', cdRegister);
 S.RegisterDelphiFunction(@BMSearchL, 'BMSearchL', cdRegister);
 S.RegisterDelphiFunction(@BMSearchUCL, 'BMSearchUCL', cdRegister);
 S.RegisterDelphiFunction(@DefaultExtensionL, 'DefaultExtensionL', cdRegister);
 S.RegisterDelphiFunction(@ForceExtensionL, 'ForceExtensionL', cdRegister);
 S.RegisterDelphiFunction(@JustFilenameL, 'JustFilenameL', cdRegister);
 S.RegisterDelphiFunction(@JustNameL, 'JustNameL', cdRegister);
 S.RegisterDelphiFunction(@JustExtensionL, 'JustExtensionL', cdRegister);
 S.RegisterDelphiFunction(@JustPathnameL, 'JustPathnameL', cdRegister);
 S.RegisterDelphiFunction(@AddBackSlashL, 'AddBackSlashL', cdRegister);
 S.RegisterDelphiFunction(@CleanPathNameL, 'CleanPathNameL', cdRegister);
 S.RegisterDelphiFunction(@HasExtensionL, 'HasExtensionL', cdRegister);
 S.RegisterDelphiFunction(@CommaizeL, 'CommaizeL', cdRegister);
 S.RegisterDelphiFunction(@CommaizeChL, 'CommaizeChL', cdRegister);
 S.RegisterDelphiFunction(@FloatFormL, 'FloatFormL', cdRegister);
 S.RegisterDelphiFunction(@LongIntFormL, 'LongIntFormL', cdRegister);
 S.RegisterDelphiFunction(@StrChPosL, 'StrChPosL', cdRegister);
 S.RegisterDelphiFunction(@StrStPosL, 'StrStPosL', cdRegister);
 S.RegisterDelphiFunction(@StrStCopyL, 'StrStCopyL', cdRegister);
 S.RegisterDelphiFunction(@StrChInsertL, 'StrChInsertL', cdRegister);
 S.RegisterDelphiFunction(@StrStInsertL, 'StrStInsertL', cdRegister);
 S.RegisterDelphiFunction(@StrChDeleteL, 'StrChDeleteL', cdRegister);
 S.RegisterDelphiFunction(@StrStDeleteL, 'StrStDeleteL', cdRegister);
 S.RegisterDelphiFunction(@ContainsOnlyL, 'ContainsOnlyL', cdRegister);
 S.RegisterDelphiFunction(@ContainsOtherThanL, 'ContainsOtherThanL', cdRegister);
 S.RegisterDelphiFunction(@CopyLeftL, 'CopyLeftL', cdRegister);
 S.RegisterDelphiFunction(@CopyMidL, 'CopyMidL', cdRegister);
 S.RegisterDelphiFunction(@CopyRightL, 'CopyRightL', cdRegister);
 S.RegisterDelphiFunction(@CopyRightAbsL, 'CopyRightAbsL', cdRegister);
 S.RegisterDelphiFunction(@CopyFromNthWordL, 'CopyFromNthWordL', cdRegister);
 S.RegisterDelphiFunction(@CopyFromToWordL, 'CopyFromToWordL', cdRegister);
 S.RegisterDelphiFunction(@CopyWithinL, 'CopyWithinL', cdRegister);
 S.RegisterDelphiFunction(@DeleteFromNthWordL, 'DeleteFromNthWordL', cdRegister);
 S.RegisterDelphiFunction(@DeleteFromToWordL, 'DeleteFromToWordL', cdRegister);
 S.RegisterDelphiFunction(@DeleteWithinL, 'DeleteWithinL', cdRegister);
 S.RegisterDelphiFunction(@ExtractTokensL, 'ExtractTokensL', cdRegister);
 S.RegisterDelphiFunction(@IsChAlphaL, 'IsChAlphaL', cdRegister);
 S.RegisterDelphiFunction(@IsChNumericL, 'IsChNumericL', cdRegister);
 S.RegisterDelphiFunction(@IsChAlphaNumericL, 'IsChAlphaNumericL', cdRegister);
 S.RegisterDelphiFunction(@IsStrAlphaL, 'IsStrAlphaL', cdRegister);
 S.RegisterDelphiFunction(@IsStrNumericL, 'IsStrNumericL', cdRegister);
 S.RegisterDelphiFunction(@IsStrAlphaNumericL, 'IsStrAlphaNumericL', cdRegister);
 S.RegisterDelphiFunction(@KeepCharsL, 'KeepCharsL', cdRegister);
 S.RegisterDelphiFunction(@LastWordL, 'LastWordL', cdRegister);
 S.RegisterDelphiFunction(@LastWordAbsL, 'LastWordAbsL', cdRegister);
 S.RegisterDelphiFunction(@LastStringL, 'LastStringL', cdRegister);
 S.RegisterDelphiFunction(@LeftTrimCharsL, 'LeftTrimCharsL', cdRegister);
 S.RegisterDelphiFunction(@ReplaceWordL, 'ReplaceWordL', cdRegister);
 S.RegisterDelphiFunction(@ReplaceWordAllL, 'ReplaceWordAllL', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStringL, 'ReplaceStringL', cdRegister);
 S.RegisterDelphiFunction(@ReplaceStringAllL, 'ReplaceStringAllL', cdRegister);
 S.RegisterDelphiFunction(@RepeatStringL, 'RepeatStringL', cdRegister);
 S.RegisterDelphiFunction(@RightTrimCharsL, 'RightTrimCharsL', cdRegister);
 S.RegisterDelphiFunction(@StrWithinL, 'StrWithinL', cdRegister);
 S.RegisterDelphiFunction(@TrimCharsL, 'TrimCharsL', cdRegister);
 S.RegisterDelphiFunction(@WordPosL, 'WordPosL', cdRegister);
  S.RegisterDelphiFunction(@WordPosL, 'WordPos', cdRegister);

 end;

 
 
{ TPSImport_StStrL }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StStrL.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StStrL(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StStrL.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StStrL(ri);
  RIRegister_StStrL_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
