unit uPSI_OverbyteIcsMimeUtils;
{
to get the i crauti from charsetutils

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
  TPSImport_OverbyteIcsMimeUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMimeTypesList(CL: TPSPascalCompiler);
procedure SIRegister_OverbyteIcsMimeUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMimeTypesList(CL: TPSRuntimeClassImporter);
procedure RIRegister_OverbyteIcsMimeUtils(CL: TPSRuntimeClassImporter);
procedure RIRegister_OverbyteIcsMimeUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   OverbyteIcsTypes
  ,OverbyteIcsUtils
  ,OverbyteIcsCsc
  ,OverbyteIcsCharsetUtils
  ,OverbyteIcsMimeUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OverbyteIcsMimeUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMimeTypesList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TMimeTypesList') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TMimeTypesList') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function LoadTypeList : boolean');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function CountExtn : integer');
    RegisterMethod('Function CountContent : integer');
    RegisterMethod('Function AddContentType( const AExtn, AContent : string) : boolean');
    RegisterMethod('Function LoadWinReg : boolean');
    RegisterMethod('Function LoadFromOS : boolean');
    RegisterMethod('Function LoadFromList : boolean');
    RegisterMethod('Function LoadMimeFile( const AFileName : string) : boolean');
    RegisterMethod('Function LoadFromResource( const AResName : string) : boolean');
    RegisterMethod('Function LoadFromFile( const AFileName : string) : boolean');
    RegisterMethod('Function SaveToFile( const AFileName : string) : boolean');
    RegisterMethod('Procedure LoadContentTypes( AList : TStrings)');
    RegisterMethod('Procedure AddContentTypes( AList : TStrings)');
    RegisterMethod('Procedure GetContentTypes( AList : TStrings)');
    RegisterMethod('Function TypeFromExtn( const AExtn : string) : string');
    RegisterMethod('Function TypeFromFile( const AFileName : string) : string');
    RegisterMethod('Function TypeGetExtn( const AContent : string) : string');
    RegisterProperty('LoadOSonDemand', 'boolean', iptrw);
    RegisterProperty('MimeTypesFile', 'string', iptrw);
    RegisterProperty('DefaultTypes', 'TStringList', iptrw);
    RegisterProperty('MimeTypeSrc', 'TMimeTypeSrc', iptrw);
    RegisterProperty('UnknownType', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_OverbyteIcsMimeUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TMimeUtilsVersion','LongInt').SetInt( 802);
 CL.AddConstantN('mimuutilsCopyRight','String').SetString( ' MimeUtils (c) 2003-2014 F. Piette V8.02 ');
 CL.AddConstantN('SmtpDefaultLineLength','LongInt').SetInt( 76);
 CL.AddConstantN('SMTP_SND_BUF_SIZE','LongInt').SetInt( 2048);
 CL.AddConstantN('icsRegContentType','String').SetString( 'MIME\Database\Content Type');
 //CL.AddConstantN('SpecialsRFC822','TSysCharSet').SetString(ord(AnsiChar) ( '(' ) or ord(AnsiChar) ( ')' ) or ord(AnsiChar) ( '<' ) or ord(AnsiChar) ( '>' ) or ord(AnsiChar) ( '@' ) or ord(AnsiChar) ( ',' ) or ord(AnsiChar) ( ';' ) or ord(AnsiChar) ( ':' ) or ord(AnsiChar) ( '\' ) or ord(AnsiChar) ( '"' ) or ord(AnsiChar) ( '[' ) or ord(AnsiChar) ( ']' ) or ord(AnsiChar) ( '.' ));
 //CL.AddConstantN('CrLfSet','TSysCharSet').SetString(ord(AnsiChar) ( #13 ) or ord(AnsiChar) ( #10 ));
 //CL.AddConstantN('QuotedCharSet','TSysCharSet').SetString(ord(AnsiChar) ( '?' ) or ord(AnsiChar) ( '=' ) or ord(AnsiChar) ( ' ' ) or ord(AnsiChar) ( '_' ));
 //CL.AddConstantN('BreakCharsSet','TSysCharSet').SetString(ord(AnsiChar) ( #9 ) or ord(AnsiChar) ( #32 ) or ord(AnsiChar) ( ';' ) or ord(AnsiChar) ( ',' ) or ord(AnsiChar) ( '>' ) or ord(AnsiChar) ( ']' ));
 CL.AddDelphiFunction('Function EncodeQuotedPrintable0( const S : RawByteString) : String;');
 CL.AddDelphiFunction('Function EncodeQuotedPrintable1( const S : UnicodeString; ACodePage : LongWord) : UnicodeString;');
 CL.AddDelphiFunction('Function EncodeQuotedPrintable2( const S : UnicodeString) : UnicodeString;');
 CL.AddDelphiFunction('Function DecodeQuotedPrintable3( const S : RawByteString) : RawByteString;');
 CL.AddDelphiFunction('Function DecodeQuotedPrintable4( const S : UnicodeString; ACodePage : LongWord) : UnicodeString;');
 CL.AddDelphiFunction('Function DecodeQuotedPrintable5( const S : UnicodeString) : UnicodeString;');
 CL.AddDelphiFunction('Function SplitQuotedPrintableString( const S : String) : String');
 CL.AddDelphiFunction('Function FilenameToContentType( FileName : String) : String');
 CL.AddDelphiFunction('Function Base64Encode6( const Input : AnsiString) : AnsiString;');
 //CL.AddDelphiFunction('Function Base64Encode7( const Input : PAnsiChar; Len : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function Base64Encode8( const Input : UnicodeString; ACodePage : LongWord) : UnicodeString;');
 CL.AddDelphiFunction('Function Base64Encode9( const Input : UnicodeString) : UnicodeString;');
 //CL.AddDelphiFunction('Function Base64Encode10( Input : StringBuilder) : StringBuilder;');
 CL.AddDelphiFunction('Function Base64Decode11( const Input : AnsiString) : AnsiString;');
 CL.AddDelphiFunction('Function Base64Decode12( const Input : UnicodeString; ACodePage : LongWord) : UnicodeString;');
 CL.AddDelphiFunction('Function Base64Decode13( const Input : UnicodeString) : UnicodeString;');
 //CL.AddDelphiFunction('Function Base64Decode14( Input : StringBuilder) : StringBuilder;');
 CL.AddDelphiFunction('Function InitFileEncBase64( const FileName : String; ShareMode : Word) : TStream');
 CL.AddDelphiFunction('Function DoFileEncBase64( var Stream : TStream; var More : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function DoFileEncQuotedPrintable( var Stream : TStream; var More : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function DoTextFileReadNoEncoding( var Stream : TStream; var More : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function DoFileLoadNoEncoding( var Stream : TStream; var More : Boolean) : String');
 CL.AddDelphiFunction('Function Base64EncodeEx15( const Input : RawByteString; MaxCol : Integer; var cPos : Integer; CodePage : LongWord; IsMultiByteCP : Boolean) : RawByteString;');
 CL.AddDelphiFunction('Function Base64EncodeEx16( const Input : UnicodeString; MaxCol : Integer; var cPos : Integer) : UnicodeString;');
 CL.AddDelphiFunction('Function Base64EncodeEx17( const Input : UnicodeString; MaxCol : Integer; var cPos : Integer; ACodePage : LongWord) : UnicodeString;');
 CL.AddDelphiFunction('Procedure EndFileEncBase64( var Stream : TStream)');
 CL.AddDelphiFunction('Procedure DotEscape( var S : String; OnlyAfterCrLf : Boolean)');
 //CL.AddDelphiFunction('Function IcsWrapTextEx18( const Line : RawByteString; const BreakStr : RawByteString; const BreakingChars : TSysCharSet; MaxCol : Integer; QuoteChars : TSysCharSet; var cPos : Integer; ForceBreak : Boolean; ACodePage : LongWord; IsMultiByteCP : Boolean) : RawByteString;');
 CL.AddDelphiFunction('Function IcsWrapTextEx19( const Line : String; const BreakStr : String; const BreakingChars : TSysCharSet; MaxCol : Integer; QuoteChars : TSysCharSet; var cPos : Integer; ForceBreak : Boolean) : String;');
 CL.AddDelphiFunction('Function UnFoldHdrLine( const S : String) : String');
 CL.AddDelphiFunction('Function NeedsEncoding20( const S : AnsiString) : Boolean;');
 CL.AddDelphiFunction('Function NeedsEncoding21( const S : UnicodeString) : Boolean;');
 CL.AddDelphiFunction('Function NeedsEncodingPChar( S : PChar) : Boolean');
 CL.AddDelphiFunction('Function HdrEncodeInLine22( const Input : RawByteString; Specials : TSysCharSet; EncType : AnsiChar; const CharSet : AnsiString; MaxCol : Integer; DoFold : Boolean; CodePage : LongWord; IsMultiByteCP : Boolean) : RawByteString;');
 CL.AddDelphiFunction('Function HdrEncodeInLine23( const Input : UnicodeString; Specials : TSysCharSet; EncType : WideChar; const CharSet : UnicodeString; MaxCol : Integer; DoFold : Boolean; Codepage : LongWord; IsMultiByteCP : Boolean) : UnicodeString;');
 CL.AddDelphiFunction('Function HdrEncodeInLineEx( const Input : UnicodeString; Specials : TSysCharSet; EncType : WideChar; CodePage : LongWord; MaxCol : Integer; DoFold : Boolean; IsMultiByteCP : Boolean) : RawByteString');
 CL.AddDelphiFunction('Function StrEncodeQP24( const Input : RawByteString; MaxCol : Integer; Specials : TSysCharSet; CodePage : LongWord; IsMultibyteCP : Boolean) : String;');
 CL.AddDelphiFunction('Function StrEncodeQP25( const Input : UnicodeString; MaxCol : Integer; Specials : TSysCharSet; ACodePage : LongWord; IsMultibyteCP : Boolean) : UnicodeString;');
 CL.AddDelphiFunction('Function StrEncodeQPEx26( const Buf : RawByteString; MaxCol : Integer; Specials : TSysCharSet; ShortSpace : Boolean; var cPos : Integer; DoFold : Boolean; CodePage : LongWord; IsMultibyteCP : Boolean) : RawByteString;');
 CL.AddDelphiFunction('Function StrEncodeQPEx27( const Buf : UnicodeString; MaxCol : Integer; Specials : TSysCharSet; ShortSpace : Boolean; var cPos : Integer; DoFold : Boolean) : UnicodeString;');
 CL.AddDelphiFunction('Procedure FoldHdrLine28( HdrLines : TStrings; const HdrLine : String);');
 CL.AddDelphiFunction('Procedure FoldHdrLine29( HdrLines : TStrings; const HdrLine : RawByteString; ACodePage : LongWord; IsMultiByteCP : Boolean);');
 CL.AddDelphiFunction('Function FoldString30( const Input : RawByteString; BreakCharsSet : TSysCharSet; MaxCol : Integer; ACodePage : LongWord; IsMultiByteCP : Boolean) : RawByteString;');
 CL.AddDelphiFunction('Function FoldString31( const Input : UnicodeString; BreakCharsSet : TSysCharSet; MaxCol : Integer) : UnicodeString;');
 CL.AddDelphiFunction('Function CalcBase64AttachmentGrow( FileSize : Int64) : Int64');
 //CL.AddDelphiFunction('Function EncodeMbcsInline32( CodePage : LongWord; const Charset : String; EncType : Char; Body : PWideChar; Len : Integer; DoFold : Boolean; MaxLen : Integer) : AnsiString;');
 //CL.AddDelphiFunction('Function EncodeMbcsInline33( CodePage : LongWord; const Charset : String; EncType : Char; Body : PAnsiChar; Len : Integer; DoFold : Boolean; MaxLen : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function ContentTypeGetExtn( const Content : string; var CLSID : String) : string');
 CL.AddDelphiFunction('Function ContentTypeFromExtn( const Extension : string) : string');
  CL.AddTypeS('TMimeTypeSrc', '( MTypeList, MTypeOS, MTypeMimeFile, MTypeKeyFile, MTypeRes )');
  SIRegister_TMimeTypesList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMimeTypesListUnknownType_W(Self: TMimeTypesList; const T: string);
begin Self.UnknownType := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListUnknownType_R(Self: TMimeTypesList; var T: string);
begin T := Self.UnknownType; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListMimeTypeSrc_W(Self: TMimeTypesList; const T: TMimeTypeSrc);
begin Self.MimeTypeSrc := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListMimeTypeSrc_R(Self: TMimeTypesList; var T: TMimeTypeSrc);
begin T := Self.MimeTypeSrc; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListDefaultTypes_W(Self: TMimeTypesList; const T: TStringList);
begin Self.DefaultTypes := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListDefaultTypes_R(Self: TMimeTypesList; var T: TStringList);
begin T := Self.DefaultTypes; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListMimeTypesFile_W(Self: TMimeTypesList; const T: string);
begin Self.MimeTypesFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListMimeTypesFile_R(Self: TMimeTypesList; var T: string);
begin T := Self.MimeTypesFile; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListLoadOSonDemand_W(Self: TMimeTypesList; const T: boolean);
begin Self.LoadOSonDemand := T; end;

(*----------------------------------------------------------------------------*)
procedure TMimeTypesListLoadOSonDemand_R(Self: TMimeTypesList; var T: boolean);
begin T := Self.LoadOSonDemand; end;

(*----------------------------------------------------------------------------*)
Function EncodeMbcsInline33_P( CodePage : LongWord; const Charset : String; EncType : Char; Body : PAnsiChar; Len : Integer; DoFold : Boolean; MaxLen : Integer) : AnsiString;
Begin Result := OverbyteIcsMimeUtils.EncodeMbcsInline(CodePage, Charset, EncType, Body, Len, DoFold, MaxLen); END;

(*----------------------------------------------------------------------------*)
Function EncodeMbcsInline32_P( CodePage : LongWord; const Charset : String; EncType : Char; Body : PWideChar; Len : Integer; DoFold : Boolean; MaxLen : Integer) : AnsiString;
Begin Result := OverbyteIcsMimeUtils.EncodeMbcsInline(CodePage, Charset, EncType, Body, Len, DoFold, MaxLen); END;

(*----------------------------------------------------------------------------*)
Function FoldString31_P( const Input : UnicodeString; BreakCharsSet : TSysCharSet; MaxCol : Integer) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.FoldString(Input, BreakCharsSet, MaxCol); END;

(*----------------------------------------------------------------------------*)
Function FoldString30_P( const Input : RawByteString; BreakCharsSet : TSysCharSet; MaxCol : Integer; ACodePage : LongWord; IsMultiByteCP : Boolean) : RawByteString;
Begin Result := OverbyteIcsMimeUtils.FoldString(Input, BreakCharsSet, MaxCol, ACodePage, IsMultiByteCP); END;

(*----------------------------------------------------------------------------*)
Procedure FoldHdrLine29_P( HdrLines : TStrings; const HdrLine : RawByteString; ACodePage : LongWord; IsMultiByteCP : Boolean);
Begin OverbyteIcsMimeUtils.FoldHdrLine(HdrLines, HdrLine, ACodePage, IsMultiByteCP); END;

(*----------------------------------------------------------------------------*)
Procedure FoldHdrLine28_P( HdrLines : TStrings; const HdrLine : String);
Begin OverbyteIcsMimeUtils.FoldHdrLine(HdrLines, HdrLine); END;

(*----------------------------------------------------------------------------*)
Function StrEncodeQPEx27_P( const Buf : UnicodeString; MaxCol : Integer; Specials : TSysCharSet; ShortSpace : Boolean; var cPos : Integer; DoFold : Boolean) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.StrEncodeQPEx(Buf, MaxCol, Specials, ShortSpace, cPos, DoFold); END;

(*----------------------------------------------------------------------------*)
Function StrEncodeQPEx26_P( const Buf : RawByteString; MaxCol : Integer; Specials : TSysCharSet; ShortSpace : Boolean; var cPos : Integer; DoFold : Boolean; CodePage : LongWord; IsMultibyteCP : Boolean) : RawByteString;
Begin Result := OverbyteIcsMimeUtils.StrEncodeQPEx(Buf, MaxCol, Specials, ShortSpace, cPos, DoFold, CodePage, IsMultibyteCP); END;

(*----------------------------------------------------------------------------*)
Function StrEncodeQP25_P( const Input : UnicodeString; MaxCol : Integer; Specials : TSysCharSet; ACodePage : LongWord; IsMultibyteCP : Boolean) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.StrEncodeQP(Input, MaxCol, Specials, ACodePage, IsMultibyteCP); END;

(*----------------------------------------------------------------------------*)
Function StrEncodeQP24_P( const Input : RawByteString; MaxCol : Integer; Specials : TSysCharSet; CodePage : LongWord; IsMultibyteCP : Boolean) : String;
Begin Result := OverbyteIcsMimeUtils.StrEncodeQP(Input, MaxCol, Specials, CodePage, IsMultibyteCP); END;

(*
//(*----------------------------------------------------------------------------*)
//Function HdrEncodeInLine23_P( const Input : UnicodeString; Specials : TSysCharSet; EncType : WideChar; const CharSet : UnicodeString; MaxCol : Integer; DoFold : Boolean; Codepage : LongWord; IsMultiByteCP : Boolean) : UnicodeString;
//Begin Result := OverbyteIcsMimeUtils.HdrEncodeInLine(Input, Specials, EncType, CharSet, MaxCol, DoFold, Codepage, IsMultiByteCP); END;
//*)
(*----------------------------------------------------------------------------*)
Function HdrEncodeInLine22_P( const Input : RawByteString; Specials : TSysCharSet; EncType : AnsiChar; const CharSet : AnsiString; MaxCol : Integer; DoFold : Boolean; CodePage : LongWord; IsMultiByteCP : Boolean) : RawByteString;
Begin Result := OverbyteIcsMimeUtils.HdrEncodeInLine(Input, Specials, EncType, CharSet, MaxCol, DoFold, CodePage, IsMultiByteCP); END;

(*----------------------------------------------------------------------------*)
Function NeedsEncoding21_P( const S : UnicodeString) : Boolean;
Begin Result := OverbyteIcsMimeUtils.NeedsEncoding(S); END;

(*----------------------------------------------------------------------------*)
Function NeedsEncoding20_P( const S : AnsiString) : Boolean;
Begin Result := OverbyteIcsMimeUtils.NeedsEncoding(S); END;

(*----------------------------------------------------------------------------*)
Function IcsWrapTextEx19_P( const Line : String; const BreakStr : String; const BreakingChars : TSysCharSet; MaxCol : Integer; QuoteChars : TSysCharSet; var cPos : Integer; ForceBreak : Boolean) : String;
Begin Result := OverbyteIcsMimeUtils.IcsWrapTextEx(Line, BreakStr, BreakingChars, MaxCol, QuoteChars, cPos, ForceBreak); END;

(*----------------------------------------------------------------------------*)
Function IcsWrapTextEx18_P( const Line : RawByteString; const BreakStr : RawByteString; const BreakingChars : TSysCharSet; MaxCol : Integer; QuoteChars : TSysCharSet; var cPos : Integer; ForceBreak : Boolean; ACodePage : LongWord; IsMultiByteCP : Boolean) : RawByteString;
Begin Result := OverbyteIcsMimeUtils.IcsWrapTextEx(Line, BreakStr, BreakingChars, MaxCol, QuoteChars, cPos, ForceBreak, ACodePage, IsMultiByteCP); END;

(*----------------------------------------------------------------------------*)
Function Base64EncodeEx17_P( const Input : UnicodeString; MaxCol : Integer; var cPos : Integer; ACodePage : LongWord) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.Base64EncodeEx(Input, MaxCol, cPos, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function Base64EncodeEx16_P( const Input : UnicodeString; MaxCol : Integer; var cPos : Integer) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.Base64EncodeEx(Input, MaxCol, cPos); END;

(*----------------------------------------------------------------------------*)
Function Base64EncodeEx15_P( const Input : RawByteString; MaxCol : Integer; var cPos : Integer; CodePage : LongWord; IsMultiByteCP : Boolean) : RawByteString;
Begin Result := OverbyteIcsMimeUtils.Base64EncodeEx(Input, MaxCol, cPos, CodePage, IsMultiByteCP); END;

(*----------------------------------------------------------------------------*)
//Function Base64Decode14_P( Input : StringBuilder) : StringBuilder;
//Begin Result := OverbyteIcsMimeUtils.Base64Decode(Input); END;

(*----------------------------------------------------------------------------*)
Function Base64Decode13_P( const Input : UnicodeString) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.Base64Decode(Input); END;

(*----------------------------------------------------------------------------*)
//Function Base64Decode12_P( const Input : UnicodeString; ACodePage : LongWord) : UnicodeString;
//Begin Result := OverbyteIcsMimeUtils.Base64Decode(Input, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function Base64Decode11_P( const Input : AnsiString) : AnsiString;
Begin Result := OverbyteIcsMimeUtils.Base64Decode(Input); END;

(*----------------------------------------------------------------------------*)
//Function Base64Encode10_P( Input : StringBuilder) : StringBuilder;
//Begin Result := OverbyteIcsMimeUtils.Base64Encode(Input); END;

(*----------------------------------------------------------------------------*)
Function Base64Encode9_P( const Input : UnicodeString) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.Base64Encode(Input); END;

(*----------------------------------------------------------------------------*)
//Function Base64Encode8_P( const Input : UnicodeString; ACodePage : LongWord) : UnicodeString;
//Begin Result := OverbyteIcsMimeUtils.Base64Encode(Input, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function Base64Encode7_P( const Input : PAnsiChar; Len : Integer) : AnsiString;
Begin Result := OverbyteIcsMimeUtils.Base64Encode(Input, Len); END;

(*----------------------------------------------------------------------------*)
Function Base64Encode6_P( const Input : AnsiString) : AnsiString;
Begin Result := OverbyteIcsMimeUtils.Base64Encode(Input); END;

(*----------------------------------------------------------------------------*)
Function DecodeQuotedPrintable5_P( const S : UnicodeString) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.DecodeQuotedPrintable(S); END;

(*----------------------------------------------------------------------------*)
//Function DecodeQuotedPrintable4_P( const S : UnicodeString; ACodePage : LongWord) : UnicodeString;
//Begin Result := OverbyteIcsMimeUtils.DecodeQuotedPrintable(S, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function DecodeQuotedPrintable3_P( const S : RawByteString) : RawByteString;
Begin Result := OverbyteIcsMimeUtils.DecodeQuotedPrintable(S); END;

(*----------------------------------------------------------------------------*)
Function EncodeQuotedPrintable2_P( const S : UnicodeString) : UnicodeString;
Begin Result := OverbyteIcsMimeUtils.EncodeQuotedPrintable(S); END;

(*----------------------------------------------------------------------------*)
//Function EncodeQuotedPrintable1_P( const S : UnicodeString; ACodePage : LongWord) : UnicodeString;
//Begin Result := OverbyteIcsMimeUtils.EncodeQuotedPrintable(S, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function EncodeQuotedPrintable0_P( const S : RawByteString) : String;
Begin Result := OverbyteIcsMimeUtils.EncodeQuotedPrintable(S); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMimeTypesList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMimeTypesList) do begin
    RegisterConstructor(@TMimeTypesList.Create, 'Create');
    RegisterMethod(@TMimeTypesList.Destroy, 'Free');
    RegisterMethod(@TMimeTypesList.LoadTypeList, 'LoadTypeList');
    RegisterMethod(@TMimeTypesList.Clear, 'Clear');
    RegisterMethod(@TMimeTypesList.CountExtn, 'CountExtn');
    RegisterMethod(@TMimeTypesList.CountContent, 'CountContent');
    RegisterMethod(@TMimeTypesList.AddContentType, 'AddContentType');
    RegisterMethod(@TMimeTypesList.LoadWinReg, 'LoadWinReg');
    RegisterMethod(@TMimeTypesList.LoadFromOS, 'LoadFromOS');
    RegisterMethod(@TMimeTypesList.LoadFromList, 'LoadFromList');
    RegisterMethod(@TMimeTypesList.LoadMimeFile, 'LoadMimeFile');
    RegisterMethod(@TMimeTypesList.LoadFromResource, 'LoadFromResource');
    RegisterMethod(@TMimeTypesList.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TMimeTypesList.SaveToFile, 'SaveToFile');
    RegisterMethod(@TMimeTypesList.LoadContentTypes, 'LoadContentTypes');
    RegisterMethod(@TMimeTypesList.AddContentTypes, 'AddContentTypes');
    RegisterMethod(@TMimeTypesList.GetContentTypes, 'GetContentTypes');
    RegisterMethod(@TMimeTypesList.TypeFromExtn, 'TypeFromExtn');
    RegisterMethod(@TMimeTypesList.TypeFromFile, 'TypeFromFile');
    RegisterMethod(@TMimeTypesList.TypeGetExtn, 'TypeGetExtn');
    RegisterPropertyHelper(@TMimeTypesListLoadOSonDemand_R,@TMimeTypesListLoadOSonDemand_W,'LoadOSonDemand');
    RegisterPropertyHelper(@TMimeTypesListMimeTypesFile_R,@TMimeTypesListMimeTypesFile_W,'MimeTypesFile');
    RegisterPropertyHelper(@TMimeTypesListDefaultTypes_R,@TMimeTypesListDefaultTypes_W,'DefaultTypes');
    RegisterPropertyHelper(@TMimeTypesListMimeTypeSrc_R,@TMimeTypesListMimeTypeSrc_W,'MimeTypeSrc');
    RegisterPropertyHelper(@TMimeTypesListUnknownType_R,@TMimeTypesListUnknownType_W,'UnknownType');
  end;
end;

procedure RIRegister_OverbyteIcsMimeUtils(CL: TPSRuntimeClassImporter);
begin
  //RIRegister_TMimeTypesList(CL);
  RIRegister_TMimeTypesList(CL);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsMimeUtils_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@EncodeQuotedPrintable0, 'EncodeQuotedPrintable0', cdRegister);
 //S.RegisterDelphiFunction(@EncodeQuotedPrintable1, 'EncodeQuotedPrintable1', cdRegister);
 //S.RegisterDelphiFunction(@EncodeQuotedPrintable2, 'EncodeQuotedPrintable2', cdRegister);
 //S.RegisterDelphiFunction(@DecodeQuotedPrintable3, 'DecodeQuotedPrintable3', cdRegister);
 //S.RegisterDelphiFunction(@DecodeQuotedPrintable4, 'DecodeQuotedPrintable4', cdRegister);
 //S.RegisterDelphiFunction(@DecodeQuotedPrintable5, 'DecodeQuotedPrintable5', cdRegister);
 S.RegisterDelphiFunction(@SplitQuotedPrintableString, 'SplitQuotedPrintableString', cdRegister);
 S.RegisterDelphiFunction(@FilenameToContentType, 'FilenameToContentType', cdRegister);
 S.RegisterDelphiFunction(@Base64Encode6_P, 'Base64Encode6', cdRegister);
 S.RegisterDelphiFunction(@Base64Encode7_P, 'Base64Encode7', cdRegister);
 //S.RegisterDelphiFunction(@Base64Encode8_P, 'Base64Encode8', cdRegister);
 S.RegisterDelphiFunction(@Base64Encode9_P, 'Base64Encode9', cdRegister);
 //S.RegisterDelphiFunction(@Base64Encode10, 'Base64Encode10', cdRegister);
 S.RegisterDelphiFunction(@Base64Decode11_P, 'Base64Decode11', cdRegister);
 //S.RegisterDelphiFunction(@Base64Decode12, 'Base64Decode12', cdRegister);
 S.RegisterDelphiFunction(@Base64Decode13_P, 'Base64Decode13', cdRegister);
 //S.RegisterDelphiFunction(@Base64Decode14, 'Base64Decode14', cdRegister);
 S.RegisterDelphiFunction(@InitFileEncBase64, 'InitFileEncBase64', cdRegister);
 S.RegisterDelphiFunction(@DoFileEncBase64, 'DoFileEncBase64', cdRegister);
 S.RegisterDelphiFunction(@DoFileEncQuotedPrintable, 'DoFileEncQuotedPrintable', cdRegister);
 S.RegisterDelphiFunction(@DoTextFileReadNoEncoding, 'DoTextFileReadNoEncoding', cdRegister);
 S.RegisterDelphiFunction(@DoFileLoadNoEncoding, 'DoFileLoadNoEncoding', cdRegister);
 S.RegisterDelphiFunction(@Base64EncodeEx15_P, 'Base64EncodeEx15', cdRegister);
 //S.RegisterDelphiFunction(@Base64EncodeEx16, 'Base64EncodeEx16', cdRegister);
 //S//.RegisterDelphiFunction(@Base64EncodeEx17, 'Base64EncodeEx17', cdRegister);
 S.RegisterDelphiFunction(@EndFileEncBase64, 'EndFileEncBase64', cdRegister);
 S.RegisterDelphiFunction(@DotEscape, 'DotEscape', cdRegister);
 S.RegisterDelphiFunction(@IcsWrapTextEx18_P, 'IcsWrapTextEx18', cdRegister);
 S.RegisterDelphiFunction(@IcsWrapTextEx19_P, 'IcsWrapTextEx19', cdRegister);
 S.RegisterDelphiFunction(@UnFoldHdrLine, 'UnFoldHdrLine', cdRegister);
 S.RegisterDelphiFunction(@NeedsEncoding20_P, 'NeedsEncoding20', cdRegister);
 S.RegisterDelphiFunction(@NeedsEncoding21_P, 'NeedsEncoding21', cdRegister);
 S.RegisterDelphiFunction(@NeedsEncodingPChar, 'NeedsEncodingPChar', cdRegister);
 S.RegisterDelphiFunction(@HdrEncodeInLine22_P, 'HdrEncodeInLine22', cdRegister);
 //S.RegisterDelphiFunction(@HdrEncodeInLine23_P, 'HdrEncodeInLine23', cdRegister);
 S.RegisterDelphiFunction(@HdrEncodeInLineEx, 'HdrEncodeInLineEx', cdRegister);
 S.RegisterDelphiFunction(@StrEncodeQP24_P, 'StrEncodeQP24', cdRegister);
 S.RegisterDelphiFunction(@StrEncodeQP25_P, 'StrEncodeQP25', cdRegister);
 S.RegisterDelphiFunction(@StrEncodeQPEx26_P, 'StrEncodeQPEx26', cdRegister);
 S.RegisterDelphiFunction(@StrEncodeQPEx27_P, 'StrEncodeQPEx27', cdRegister);
 S.RegisterDelphiFunction(@FoldHdrLine28_P, 'FoldHdrLine28', cdRegister);
 S.RegisterDelphiFunction(@FoldHdrLine29_P, 'FoldHdrLine29', cdRegister);
 S.RegisterDelphiFunction(@FoldString30_P, 'FoldString30', cdRegister);
 S.RegisterDelphiFunction(@FoldString31_P, 'FoldString31', cdRegister);
 S.RegisterDelphiFunction(@CalcBase64AttachmentGrow, 'CalcBase64AttachmentGrow', cdRegister);
 //S.RegisterDelphiFunction(@EncodeMbcsInline32, 'EncodeMbcsInline32', cdRegister);
 //S.RegisterDelphiFunction(@EncodeMbcsInline33, 'EncodeMbcsInline33', cdRegister);
 S.RegisterDelphiFunction(@ContentTypeGetExtn, 'ContentTypeGetExtn', cdRegister);
 S.RegisterDelphiFunction(@ContentTypeFromExtn, 'ContentTypeFromExtn', cdRegister);
  //RIRegister_TMimeTypesList(CL);
end;



{ TPSImport_OverbyteIcsMimeUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsMimeUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OverbyteIcsMimeUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsMimeUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OverbyteIcsMimeUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
