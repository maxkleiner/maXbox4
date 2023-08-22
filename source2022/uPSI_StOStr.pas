unit uPSI_StOStr;
{
  SysTools4    add free
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
  TPSImport_StOStr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStString(CL: TPSPascalCompiler);
procedure SIRegister_StOStr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStString(CL: TPSRuntimeClassImporter);
procedure RIRegister_StOStr(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StStrZ
  ,StOStr
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StOStr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStString(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TStString') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TStString') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
       RegisterMethod('Constructor CreateAlloc( Size : Cardinal)');
    RegisterMethod('Constructor CreateS( const S : AnsiString)');
    RegisterMethod('Constructor CreateZ( const S : PAnsiChar)');
    RegisterMethod('Constructor CreateV( const S : Variant)');
    RegisterMethod('Procedure AppendPChar( S : PAnsiChar)');
    RegisterMethod('Procedure AppendString( S : AnsiString)');
    RegisterMethod('Function AsciiPosition( N : Cardinal; var Pos : Cardinal) : Boolean');
    RegisterMethod('Function BMSearch( const S : AnsiString; var Pos : Cardinal) : Boolean');
    RegisterMethod('Function BMSearchUC( const S : AnsiString; var Pos : Cardinal) : Boolean');
    RegisterMethod('Procedure Center( Size : Cardinal)');
    RegisterMethod('Procedure CenterCh( const C : AnsiChar; Size : Cardinal)');
    RegisterMethod('Function CharCount( const C : AnsiChar) : Cardinal');
    RegisterMethod('Function CharExists( const C : AnsiChar) : boolean');
    RegisterMethod('Procedure CharStr( const C : AnsiChar; Size : Cardinal)');
    RegisterMethod('Procedure ClearItems');
    RegisterMethod('Procedure CursorNextWord');
    RegisterMethod('Procedure CursorNextWordPrim');
    RegisterMethod('Procedure CursorPrevWord');
    RegisterMethod('Procedure CursorPrevWordPrim');
    RegisterMethod('Procedure CursorToEnd');
    RegisterMethod('Procedure DeleteAsciiAtCursor');
    RegisterMethod('Procedure DeleteAtCursor( Length : Cardinal)');
    RegisterMethod('Procedure DeleteWordAtCursor');
    RegisterMethod('Procedure Detab');
    RegisterMethod('Procedure Entab');
    RegisterMethod('Function ExtractAscii( N : Cardinal) : AnsiString');
    RegisterMethod('Function ExtractWord( N : Cardinal) : AnsiString');
    RegisterMethod('Procedure Filter( const Filters : PAnsiChar)');
    RegisterMethod('Function GetAsciiAtCursor : AnsiString');
    RegisterMethod('Function GetAsciiAtCursorZ( Dest : PAnsiChar) : PAnsiChar');
    RegisterMethod('Function GetAsPChar( Dest : PAnsiChar) : PAnsiChar');
    RegisterMethod('Function GetWordAtCursor : AnsiString');
    RegisterMethod('Function GetWordAtCursorZ( Dest : PAnsiChar) : PAnsiChar');
    RegisterMethod('Procedure InsertLineTerminatorAtCursor');
    RegisterMethod('Procedure InsertLineTerminator( Pos : Cardinal)');
    RegisterMethod('Procedure InsertPCharAtCursor( S : PAnsiChar)');
    RegisterMethod('Procedure InsertStringAtCursor( S : AnsiString)');
    RegisterMethod('Procedure ItemsToString');
    RegisterMethod('Procedure LeftPad( Size : Cardinal)');
    RegisterMethod('Procedure LeftPadCh( const C : AnsiChar; Size : Cardinal)');
    RegisterMethod('Function MakeLetterSet : LongInt');
    RegisterMethod('Procedure MoveCursor( Delta : Integer)');
    RegisterMethod('Procedure Pack');
    RegisterMethod('Procedure Pad( Size : Cardinal)');
    RegisterMethod('Procedure PadCh( const C : AnsiChar; Size : Cardinal)');
    RegisterMethod('Procedure ResetCursor');
    RegisterMethod('Procedure Scramble( const Key : AnsiString)');
    RegisterMethod('Procedure SetAsPChar( S : PAnsiChar)');
    RegisterMethod('Function SizeAsciiAtCursor( InclTrailers : Boolean) : Cardinal');
    RegisterMethod('Function SizeWordAtCursor( InclTrailers : Boolean) : Cardinal');
    RegisterMethod('Procedure StrChDelete( Pos : Cardinal)');
    RegisterMethod('Procedure StrChInsert( const C : AnsiChar; Pos : Cardinal)');
    RegisterMethod('Function StrChPos( const C : AnsiChar; var Pos : Cardinal) : Boolean');
    RegisterMethod('Procedure StringToItems');
    RegisterMethod('Procedure StripLineTerminators');
    RegisterMethod('Procedure StrStDelete( const Pos, Length : Cardinal)');
    RegisterMethod('Procedure StrStInsert( const S : AnsiString; Pos : Cardinal)');
    RegisterMethod('Function StrStPos( const S : AnsiString; var Pos : Cardinal) : Boolean');
    RegisterMethod('Procedure Substitute( FromStr, ToStr : PAnsiChar)');
    RegisterMethod('Procedure Trim');
    RegisterMethod('Procedure TrimLead');
    RegisterMethod('Procedure TrimSpaces');
    RegisterMethod('Procedure TrimTrail');
    RegisterMethod('Function WordPosition( N : Cardinal; var Pos : Cardinal) : Boolean');
    RegisterMethod('Procedure WrapToItems');
    RegisterProperty('AllocLength', 'Cardinal', iptrw);
    RegisterProperty('AsciiCount', 'Cardinal', iptr);
    RegisterProperty('AsLongStr', 'AnsiString', iptrw);
    RegisterProperty('AsVariant', 'Variant', iptrw);
    RegisterProperty('AsShortStr', 'ShortString', iptrw);
    RegisterProperty('AtIndex', 'Char Cardinal', iptrw);
    SetDefaultPropery('AtIndex');
    RegisterProperty('CursorPos', 'Cardinal', iptrw);
    RegisterProperty('Delimiters', 'AnsiString', iptrw);
    RegisterProperty('EnableCursor', 'Boolean', iptrw);
    RegisterProperty('Length', 'Cardinal', iptr);
    RegisterProperty('LineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('LineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('Items', 'TStringList', iptrw);
    RegisterProperty('OneBased', 'Boolean', iptrw);
    RegisterProperty('RepeatValue', 'Cardinal', iptrw);
    RegisterProperty('ResetRepeat', 'Boolean', iptrw);
    RegisterProperty('Soundex', 'AnsiString', iptr);
    RegisterProperty('Quote', 'AnsiChar', iptrw);
    RegisterProperty('TabSize', 'Byte', iptrw);
    RegisterProperty('WordCount', 'Cardinal', iptr);
    RegisterProperty('WrapColumn', 'Cardinal', iptrw);
    //TAction
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StOStr(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DefAllocSize','LongInt').SetInt( 8);
 CL.AddConstantN('DefDelimiters','String').SetString( ' ');
 CL.AddConstantN('DefQuote','String').SetString( '''');
 CL.AddConstantN('DefRepeatValue','LongInt').SetInt( 1);
 //CL.AddConstantN('DefResetRepeat','Boolean')BoolToStr( True);
 CL.AddConstantN('DefTabSize','LongInt').SetInt( 8);
 CL.AddConstantN('DefWrap','LongInt').SetInt( 80);
  SIRegister_TStString(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStStringWrapColumn_W(Self: TStString; const T: Cardinal);
begin Self.WrapColumn := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringWrapColumn_R(Self: TStString; var T: Cardinal);
begin T := Self.WrapColumn; end;

(*----------------------------------------------------------------------------*)
procedure TStStringWordCount_R(Self: TStString; var T: Cardinal);
begin T := Self.WordCount; end;

(*----------------------------------------------------------------------------*)
procedure TStStringTabSize_W(Self: TStString; const T: Byte);
begin Self.TabSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringTabSize_R(Self: TStString; var T: Byte);
begin T := Self.TabSize; end;

(*----------------------------------------------------------------------------*)
procedure TStStringQuote_W(Self: TStString; const T: AnsiChar);
begin Self.Quote := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringQuote_R(Self: TStString; var T: AnsiChar);
begin T := Self.Quote; end;

(*----------------------------------------------------------------------------*)
procedure TStStringSoundex_R(Self: TStString; var T: AnsiString);
begin T := Self.Soundex; end;

(*----------------------------------------------------------------------------*)
procedure TStStringResetRepeat_W(Self: TStString; const T: Boolean);
begin Self.ResetRepeat := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringResetRepeat_R(Self: TStString; var T: Boolean);
begin T := Self.ResetRepeat; end;

(*----------------------------------------------------------------------------*)
procedure TStStringRepeatValue_W(Self: TStString; const T: Cardinal);
begin Self.RepeatValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringRepeatValue_R(Self: TStString; var T: Cardinal);
begin T := Self.RepeatValue; end;

(*----------------------------------------------------------------------------*)
procedure TStStringOneBased_W(Self: TStString; const T: Boolean);
begin Self.OneBased := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringOneBased_R(Self: TStString; var T: Boolean);
begin T := Self.OneBased; end;

(*----------------------------------------------------------------------------*)
procedure TStStringItems_W(Self: TStString; const T: TStringList);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringItems_R(Self: TStString; var T: TStringList);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TStStringLineTerminator_W(Self: TStString; const T: TStLineTerminator);
begin Self.LineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringLineTerminator_R(Self: TStString; var T: TStLineTerminator);
begin T := Self.LineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStStringLineTermChar_W(Self: TStString; const T: AnsiChar);
begin Self.LineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringLineTermChar_R(Self: TStString; var T: AnsiChar);
begin T := Self.LineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStStringLength_R(Self: TStString; var T: Cardinal);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TStStringEnableCursor_W(Self: TStString; const T: Boolean);
begin Self.EnableCursor := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringEnableCursor_R(Self: TStString; var T: Boolean);
begin T := Self.EnableCursor; end;

(*----------------------------------------------------------------------------*)
procedure TStStringDelimiters_W(Self: TStString; const T: AnsiString);
begin Self.Delimiters := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringDelimiters_R(Self: TStString; var T: AnsiString);
begin T := Self.Delimiters; end;

(*----------------------------------------------------------------------------*)
procedure TStStringCursorPos_W(Self: TStString; const T: Cardinal);
begin Self.CursorPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringCursorPos_R(Self: TStString; var T: Cardinal);
begin T := Self.CursorPos; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAtIndex_W(Self: TStString; const T: AnsiChar; const t1: Cardinal);
begin Self.AtIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAtIndex_R(Self: TStString; var T: AnsiChar; const t1: Cardinal);
begin T := Self.AtIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAsShortStr_W(Self: TStString; const T: ShortString);
begin Self.AsShortStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAsShortStr_R(Self: TStString; var T: ShortString);
begin T := Self.AsShortStr; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAsVariant_W(Self: TStString; const T: Variant);
begin Self.AsVariant := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAsVariant_R(Self: TStString; var T: Variant);
begin T := Self.AsVariant; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAsLongStr_W(Self: TStString; const T: AnsiString);
begin Self.AsLongStr := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAsLongStr_R(Self: TStString; var T: AnsiString);
begin T := Self.AsLongStr; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAsciiCount_R(Self: TStString; var T: Cardinal);
begin T := Self.AsciiCount; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAllocLength_W(Self: TStString; const T: Cardinal);
begin Self.AllocLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TStStringAllocLength_R(Self: TStString; var T: Cardinal);
begin T := Self.AllocLength; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStString(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStString) do begin
    RegisterConstructor(@TStString.Create, 'Create');
     RegisterMethod(@TStString.Destroy, 'Free');
      RegisterVirtualConstructor(@TStString.CreateAlloc, 'CreateAlloc');
    RegisterVirtualConstructor(@TStString.CreateS, 'CreateS');
    RegisterVirtualConstructor(@TStString.CreateZ, 'CreateZ');
    RegisterVirtualConstructor(@TStString.CreateV, 'CreateV');
    RegisterMethod(@TStString.AppendPChar, 'AppendPChar');
    RegisterMethod(@TStString.AppendString, 'AppendString');
    RegisterMethod(@TStString.AsciiPosition, 'AsciiPosition');
    RegisterMethod(@TStString.BMSearch, 'BMSearch');
    RegisterMethod(@TStString.BMSearchUC, 'BMSearchUC');
    RegisterMethod(@TStString.Center, 'Center');
    RegisterMethod(@TStString.CenterCh, 'CenterCh');
    RegisterMethod(@TStString.CharCount, 'CharCount');
    RegisterMethod(@TStString.CharExists, 'CharExists');
    RegisterMethod(@TStString.CharStr, 'CharStr');
    RegisterMethod(@TStString.ClearItems, 'ClearItems');
    RegisterMethod(@TStString.CursorNextWord, 'CursorNextWord');
    RegisterMethod(@TStString.CursorNextWordPrim, 'CursorNextWordPrim');
    RegisterMethod(@TStString.CursorPrevWord, 'CursorPrevWord');
    RegisterMethod(@TStString.CursorPrevWordPrim, 'CursorPrevWordPrim');
    RegisterMethod(@TStString.CursorToEnd, 'CursorToEnd');
    RegisterMethod(@TStString.DeleteAsciiAtCursor, 'DeleteAsciiAtCursor');
    RegisterMethod(@TStString.DeleteAtCursor, 'DeleteAtCursor');
    RegisterMethod(@TStString.DeleteWordAtCursor, 'DeleteWordAtCursor');
    RegisterMethod(@TStString.Detab, 'Detab');
    RegisterMethod(@TStString.Entab, 'Entab');
    RegisterMethod(@TStString.ExtractAscii, 'ExtractAscii');
    RegisterMethod(@TStString.ExtractWord, 'ExtractWord');
    RegisterMethod(@TStString.Filter, 'Filter');
    RegisterMethod(@TStString.GetAsciiAtCursor, 'GetAsciiAtCursor');
    RegisterMethod(@TStString.GetAsciiAtCursorZ, 'GetAsciiAtCursorZ');
    RegisterMethod(@TStString.GetAsPChar, 'GetAsPChar');
    RegisterMethod(@TStString.GetWordAtCursor, 'GetWordAtCursor');
    RegisterMethod(@TStString.GetWordAtCursorZ, 'GetWordAtCursorZ');
    RegisterMethod(@TStString.InsertLineTerminatorAtCursor, 'InsertLineTerminatorAtCursor');
    RegisterMethod(@TStString.InsertLineTerminator, 'InsertLineTerminator');
    RegisterMethod(@TStString.InsertPCharAtCursor, 'InsertPCharAtCursor');
    RegisterMethod(@TStString.InsertStringAtCursor, 'InsertStringAtCursor');
    RegisterMethod(@TStString.ItemsToString, 'ItemsToString');
    RegisterMethod(@TStString.LeftPad, 'LeftPad');
    RegisterMethod(@TStString.LeftPadCh, 'LeftPadCh');
    RegisterMethod(@TStString.MakeLetterSet, 'MakeLetterSet');
    RegisterMethod(@TStString.MoveCursor, 'MoveCursor');
    RegisterMethod(@TStString.Pack, 'Pack');
    RegisterMethod(@TStString.Pad, 'Pad');
    RegisterMethod(@TStString.PadCh, 'PadCh');
    RegisterMethod(@TStString.ResetCursor, 'ResetCursor');
    RegisterMethod(@TStString.Scramble, 'Scramble');
    RegisterMethod(@TStString.SetAsPChar, 'SetAsPChar');
    RegisterMethod(@TStString.SizeAsciiAtCursor, 'SizeAsciiAtCursor');
    RegisterMethod(@TStString.SizeWordAtCursor, 'SizeWordAtCursor');
    RegisterMethod(@TStString.StrChDelete, 'StrChDelete');
    RegisterMethod(@TStString.StrChInsert, 'StrChInsert');
    RegisterMethod(@TStString.StrChPos, 'StrChPos');
    RegisterMethod(@TStString.StringToItems, 'StringToItems');
    RegisterMethod(@TStString.StripLineTerminators, 'StripLineTerminators');
    RegisterMethod(@TStString.StrStDelete, 'StrStDelete');
    RegisterMethod(@TStString.StrStInsert, 'StrStInsert');
    RegisterMethod(@TStString.StrStPos, 'StrStPos');
    RegisterMethod(@TStString.Substitute, 'Substitute');
    RegisterMethod(@TStString.Trim, 'Trim');
    RegisterMethod(@TStString.TrimLead, 'TrimLead');
    RegisterMethod(@TStString.TrimSpaces, 'TrimSpaces');
    RegisterMethod(@TStString.TrimTrail, 'TrimTrail');
    RegisterMethod(@TStString.WordPosition, 'WordPosition');
    RegisterMethod(@TStString.WrapToItems, 'WrapToItems');
    RegisterPropertyHelper(@TStStringAllocLength_R,@TStStringAllocLength_W,'AllocLength');
    RegisterPropertyHelper(@TStStringAsciiCount_R,nil,'AsciiCount');
    RegisterPropertyHelper(@TStStringAsLongStr_R,@TStStringAsLongStr_W,'AsLongStr');
    RegisterPropertyHelper(@TStStringAsVariant_R,@TStStringAsVariant_W,'AsVariant');
    RegisterPropertyHelper(@TStStringAsShortStr_R,@TStStringAsShortStr_W,'AsShortStr');
    RegisterPropertyHelper(@TStStringAtIndex_R,@TStStringAtIndex_W,'AtIndex');
    RegisterPropertyHelper(@TStStringCursorPos_R,@TStStringCursorPos_W,'CursorPos');
    RegisterPropertyHelper(@TStStringDelimiters_R,@TStStringDelimiters_W,'Delimiters');
    RegisterPropertyHelper(@TStStringEnableCursor_R,@TStStringEnableCursor_W,'EnableCursor');
    RegisterPropertyHelper(@TStStringLength_R,nil,'Length');
    RegisterPropertyHelper(@TStStringLineTermChar_R,@TStStringLineTermChar_W,'LineTermChar');
    RegisterPropertyHelper(@TStStringLineTerminator_R,@TStStringLineTerminator_W,'LineTerminator');
    RegisterPropertyHelper(@TStStringItems_R,@TStStringItems_W,'Items');
    RegisterPropertyHelper(@TStStringOneBased_R,@TStStringOneBased_W,'OneBased');
    RegisterPropertyHelper(@TStStringRepeatValue_R,@TStStringRepeatValue_W,'RepeatValue');
    RegisterPropertyHelper(@TStStringResetRepeat_R,@TStStringResetRepeat_W,'ResetRepeat');
    RegisterPropertyHelper(@TStStringSoundex_R,nil,'Soundex');
    RegisterPropertyHelper(@TStStringQuote_R,@TStStringQuote_W,'Quote');
    RegisterPropertyHelper(@TStStringTabSize_R,@TStStringTabSize_W,'TabSize');
    RegisterPropertyHelper(@TStStringWordCount_R,nil,'WordCount');
    RegisterPropertyHelper(@TStStringWrapColumn_R,@TStStringWrapColumn_W,'WrapColumn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StOStr(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStString(CL);
end;

 
 
{ TPSImport_StOStr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StOStr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StOStr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StOStr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StOStr(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
