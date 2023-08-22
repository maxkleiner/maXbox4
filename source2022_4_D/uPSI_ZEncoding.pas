unit uPSI_ZEncoding;
{
   another beta for unicode
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
  TPSImport_ZEncoding = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ZEncoding(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ZEncoding_Routines(S: TPSExec);

procedure Register;

implementation


uses
   //LConvEncoding
  Windows
  ,ZCompatibility
  ,ZEncoding
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZEncoding]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ZEncoding(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('zCP_EBC037','LongInt').SetInt( 37);
 CL.AddConstantN('zCP_EBC273','LongInt').SetInt( 273);
 CL.AddConstantN('zCP_EBC277','LongInt').SetInt( 277);
 CL.AddConstantN('zCP_EBC278','LongInt').SetInt( 278);
 CL.AddConstantN('zCP_EBC280','LongInt').SetInt( 280);
 CL.AddConstantN('zCP_EBC284','LongInt').SetInt( 284);
 CL.AddConstantN('zCP_DOS437','LongInt').SetInt( 437);
 CL.AddConstantN('zCP_DOS500','LongInt').SetInt( 500);
 CL.AddConstantN('zCP_DOS708','LongInt').SetInt( 708);
 CL.AddConstantN('zCP_DOS709','LongInt').SetInt( 709);
 CL.AddConstantN('zCP_DOS710','LongInt').SetInt( 710);
 CL.AddConstantN('zCP_DOS720','LongInt').SetInt( 720);
 CL.AddConstantN('zCP_DOS737','LongInt').SetInt( 737);
 CL.AddConstantN('zCP_DOS775','LongInt').SetInt( 775);
 CL.AddConstantN('zCP_DOS850','LongInt').SetInt( 850);
 CL.AddConstantN('zCP_DOS851','LongInt').SetInt( 851);
 CL.AddConstantN('zCP_DOS852','LongInt').SetInt( 852);
 CL.AddConstantN('zCP_DOS853','LongInt').SetInt( 853);
 CL.AddConstantN('zCP_DOS855','LongInt').SetInt( 855);
 CL.AddConstantN('zCP_DOS856','LongInt').SetInt( 856);
 CL.AddConstantN('zCP_DOS857','LongInt').SetInt( 857);
 CL.AddConstantN('zCP_DOS858','LongInt').SetInt( 858);
 CL.AddConstantN('zCP_DOS895','LongInt').SetInt( 895);
 CL.AddConstantN('zCP_DOS860','LongInt').SetInt( 860);
 CL.AddConstantN('zCP_DOS861','LongInt').SetInt( 861);
 CL.AddConstantN('zCP_DOS862','LongInt').SetInt( 862);
 CL.AddConstantN('zCP_DOS863','LongInt').SetInt( 863);
 CL.AddConstantN('zCP_DOS864','LongInt').SetInt( 864);
 CL.AddConstantN('zCP_DOS865','LongInt').SetInt( 865);
 CL.AddConstantN('zCP_DOS866','LongInt').SetInt( 866);
 CL.AddConstantN('zCP_DOS869','LongInt').SetInt( 869);
 CL.AddConstantN('zCP_DOS870','LongInt').SetInt( 870);
 CL.AddConstantN('zCP_DOS874','LongInt').SetInt( 874);
 CL.AddConstantN('zCP_EBC875','LongInt').SetInt( 875);
 CL.AddConstantN('zCP_MSWIN921','LongInt').SetInt( 921);
 CL.AddConstantN('zCP_MSWIN923','LongInt').SetInt( 923);
 CL.AddConstantN('zCP_EBC924','LongInt').SetInt( 924);
 CL.AddConstantN('zCP_SHIFTJS','LongInt').SetInt( 932);
 CL.AddConstantN('zCP_GB2312','LongInt').SetInt( 936);
 CL.AddConstantN('zCP_EUCKR','LongInt').SetInt( 949);
 CL.AddConstantN('zCP_Big5','LongInt').SetInt( 950);
 CL.AddConstantN('zCP_IBM1026','LongInt').SetInt( 1026);
 CL.AddConstantN('zCP_IBM01047','LongInt').SetInt( 1047);
 CL.AddConstantN('zCP_IBM01140','LongInt').SetInt( 1140);
 CL.AddConstantN('zCP_IBM01141','LongInt').SetInt( 1141);
 CL.AddConstantN('zCP_IBM01142','LongInt').SetInt( 1142);
 CL.AddConstantN('zCP_IBM01143','LongInt').SetInt( 1143);
 CL.AddConstantN('zCP_IBM01144','LongInt').SetInt( 1144);
 CL.AddConstantN('zCP_IBM01145','LongInt').SetInt( 1145);
 CL.AddConstantN('zCP_IBM01146','LongInt').SetInt( 1146);
 CL.AddConstantN('zCP_IBM01147','LongInt').SetInt( 1147);
 CL.AddConstantN('zCP_IBM01148','LongInt').SetInt( 1148);
 CL.AddConstantN('zCP_IBM01149','LongInt').SetInt( 1149);
 CL.AddConstantN('zCP_UTF16','LongInt').SetInt( 1200);
 CL.AddConstantN('zCP_UTF16BE','LongInt').SetInt( 1201);
 CL.AddConstantN('zCP_WIN1250','LongInt').SetInt( 1250);
 CL.AddConstantN('zCP_WIN1251','LongInt').SetInt( 1251);
 CL.AddConstantN('zCP_WIN1252','LongInt').SetInt( 1252);
 CL.AddConstantN('zCP_WIN1253','LongInt').SetInt( 1253);
 CL.AddConstantN('zCP_WIN1254','LongInt').SetInt( 1254);
 CL.AddConstantN('zCP_WIN1255','LongInt').SetInt( 1255);
 CL.AddConstantN('cCP_WIN1256','LongInt').SetInt( 1256);
 CL.AddConstantN('zCP_WIN1257','LongInt').SetInt( 1257);
 CL.AddConstantN('zCP_WIN1258','LongInt').SetInt( 1258);
 CL.AddConstantN('ZCP_JOHAB','LongInt').SetInt( 1361);
 CL.AddConstantN('zCP_KOREAN','LongInt').SetInt( 2022);
 CL.AddConstantN('zCP_macintosh','LongInt').SetInt( 10000);
 CL.AddConstantN('zCP_x_mac_japanese','LongInt').SetInt( 10001);
 CL.AddConstantN('zCP_x_mac_chinesetrad','LongInt').SetInt( 10002);
 CL.AddConstantN('zCP_x_mac_korean','LongInt').SetInt( 10003);
 CL.AddConstantN('zCP_x_mac_arabic','LongInt').SetInt( 10004);
 CL.AddConstantN('zCP_x_mac_hebrew','LongInt').SetInt( 10005);
 CL.AddConstantN('zCP_x_mac_greek','LongInt').SetInt( 10006);
 CL.AddConstantN('zCP_x_mac_cyrillic','LongInt').SetInt( 10007);
 CL.AddConstantN('zCP_x_mac_chinesesimp','LongInt').SetInt( 10008);
 CL.AddConstantN('zCP_x_mac_romanian','LongInt').SetInt( 10010);
 CL.AddConstantN('zCP_x_mac_ukrainian','LongInt').SetInt( 10017);
 CL.AddConstantN('zCP_x_mac_thai','LongInt').SetInt( 10021);
 CL.AddConstantN('zCP_x_mac_ce','LongInt').SetInt( 10029);
 CL.AddConstantN('zCP_x_mac_icelandic','LongInt').SetInt( 10079);
 CL.AddConstantN('zCP_x_mac_turkish','LongInt').SetInt( 10081);
 CL.AddConstantN('zCP_x_mac_croatian','LongInt').SetInt( 10082);
 CL.AddConstantN('zCP_utf32','LongInt').SetInt( 12000);
 CL.AddConstantN('zCP_utf32BE','LongInt').SetInt( 12001);
 CL.AddConstantN('zCP_x_Chinese_CNS','LongInt').SetInt( 20000);
 CL.AddConstantN('zCP_x_cp20001','LongInt').SetInt( 20001);
 CL.AddConstantN('zCP_x_Chinese_Eten','LongInt').SetInt( 20002);
 CL.AddConstantN('zCP_x_cp20003','LongInt').SetInt( 20003);
 CL.AddConstantN('zCP_x_cp20004','LongInt').SetInt( 20004);
 CL.AddConstantN('zCP_x_cp20005','LongInt').SetInt( 20005);
 CL.AddConstantN('zCP_x_IA5','LongInt').SetInt( 20105);
 CL.AddConstantN('zCP_x_IA5_German','LongInt').SetInt( 20106);
 CL.AddConstantN('zCP_x_IA5_Swedish','LongInt').SetInt( 20107);
 CL.AddConstantN('zCP_x_IA5_Norwegian','LongInt').SetInt( 20108);
 CL.AddConstantN('zCP_us_ascii','LongInt').SetInt( 20127);
 CL.AddConstantN('zCP_x_cp20261','LongInt').SetInt( 20261);
 CL.AddConstantN('zCP_x_cp20269','LongInt').SetInt( 20269);
 CL.AddConstantN('zCP_IBM273','LongInt').SetInt( 20273);
 CL.AddConstantN('zCP_IBM277','LongInt').SetInt( 20277);
 CL.AddConstantN('zCP_IBM278','LongInt').SetInt( 20278);
 CL.AddConstantN('zCP_IBM280','LongInt').SetInt( 20280);
 CL.AddConstantN('zCP_IBM284','LongInt').SetInt( 20284);
 CL.AddConstantN('zCP_IBM285','LongInt').SetInt( 20285);
 CL.AddConstantN('zCP_IBM290','LongInt').SetInt( 20290);
 CL.AddConstantN('zCP_IBM297','LongInt').SetInt( 20297);
 CL.AddConstantN('zCP_IBM420','LongInt').SetInt( 20420);
 CL.AddConstantN('zCP_IBM423','LongInt').SetInt( 20423);
 CL.AddConstantN('zCP_IBM424','LongInt').SetInt( 20424);
 CL.AddConstantN('zCP_x_EBCDIC_KoreanExtended','LongInt').SetInt( 20833);
 CL.AddConstantN('zCP_IBM_Thai','LongInt').SetInt( 20838);
 CL.AddConstantN('zCP_KOI8R','LongInt').SetInt( 20866);
 CL.AddConstantN('zCP_IBM871','LongInt').SetInt( 20871);
 CL.AddConstantN('zCP_IBM880','LongInt').SetInt( 20880);
 CL.AddConstantN('zCP_IBM905','LongInt').SetInt( 20905);
 CL.AddConstantN('zCP_IBM00924','LongInt').SetInt( 20924);
 CL.AddConstantN('zCP_EUC_JP','LongInt').SetInt( 20932);
 CL.AddConstantN('zCP_x_cp20936','LongInt').SetInt( 20936);
 CL.AddConstantN('zCP_x_cp20949','LongInt').SetInt( 20949);
 CL.AddConstantN('zCP_cp1025','LongInt').SetInt( 21025);
 CL.AddConstantN('zCP_KOI8U','LongInt').SetInt( 21866);
 CL.AddConstantN('zCP_L1_ISO_8859_1','LongInt').SetInt( 28591);
 CL.AddConstantN('zCP_L2_ISO_8859_2','LongInt').SetInt( 28592);
 CL.AddConstantN('zCP_L3_ISO_8859_3','LongInt').SetInt( 28593);
 CL.AddConstantN('zCP_L4_ISO_8859_4','LongInt').SetInt( 28594);
 CL.AddConstantN('zCP_L5_ISO_8859_5','LongInt').SetInt( 28595);
 CL.AddConstantN('zCP_L6_ISO_8859_6','LongInt').SetInt( 28596);
 CL.AddConstantN('zCP_L7_ISO_8859_7','LongInt').SetInt( 28597);
 CL.AddConstantN('zCP_L8_ISO_8859_8','LongInt').SetInt( 28598);
 CL.AddConstantN('zCP_L5_ISO_8859_9','LongInt').SetInt( 28599);
 CL.AddConstantN('zCP_L6_ISO_8859_10','LongInt').SetInt( 28600);
 CL.AddConstantN('zCP_L7_ISO_8859_13','LongInt').SetInt( 28603);
 CL.AddConstantN('zCP_L8_ISO_8859_14','LongInt').SetInt( 28604);
 CL.AddConstantN('zCP_L9_ISO_8859_15','LongInt').SetInt( 28605);
 CL.AddConstantN('zCP_L10_ISO_8859_16','LongInt').SetInt( 28606);
 CL.AddConstantN('zCP_x_Europa','LongInt').SetInt( 29001);
 CL.AddConstantN('zCP_iso_8859_8_i','LongInt').SetInt( 38598);
 CL.AddConstantN('zCP_iso_2022_jp','LongInt').SetInt( 50220);
 CL.AddConstantN('zCP_csISO2022JP','LongInt').SetInt( 50221);
 CL.AddConstantN('zCP_x_iso_2022_jp','LongInt').SetInt( 50222);
 CL.AddConstantN('zCP_iso_2022_kr','LongInt').SetInt( 50225);
 CL.AddConstantN('zCP_x_cp50227','LongInt').SetInt( 50227);
 CL.AddConstantN('zCP_EUC_TC_ISO220','LongInt').SetInt( 50229);
 CL.AddConstantN('zCP_EBCDIC_euc_jpe','LongInt').SetInt( 50930);
 CL.AddConstantN('zCP_EBCDIC_euc_jp','LongInt').SetInt( 50931);
 CL.AddConstantN('zCP_euc_jp_auto','LongInt').SetInt( 50932);
 CL.AddConstantN('zCP_EBCDIC_euc_kr','LongInt').SetInt( 50933);
 CL.AddConstantN('zCP_EBCDIC_euc_cn','LongInt').SetInt( 50935);
 CL.AddConstantN('zCP_EBCDIC_euc_sc','LongInt').SetInt( 50936);
 CL.AddConstantN('zCP_EBCDIC_USC_TC','LongInt').SetInt( 50937);
 CL.AddConstantN('zCP_euc_cn_auto','LongInt').SetInt( 50939);
 CL.AddConstantN('zCP_euc_kr_auto','LongInt').SetInt( 50949);
 CL.AddConstantN('zCP_euc_JP_win','LongInt').SetInt( 51932);
 CL.AddConstantN('zCP_EUC_CN','LongInt').SetInt( 51936);
 CL.AddConstantN('zCP_euc_kr','LongInt').SetInt( 51949);
 CL.AddConstantN('zCP_euc_tc','LongInt').SetInt( 51950);
 CL.AddConstantN('zCP_hz_gb_2312','LongInt').SetInt( 52936);
 CL.AddConstantN('zCP_GB18030','LongInt').SetInt( 54936);
 CL.AddConstantN('zCP_x_iscii_de','LongInt').SetInt( 57002);
 CL.AddConstantN('zCP_x_iscii_be','LongInt').SetInt( 57003);
 CL.AddConstantN('zCP_x_iscii_ta','LongInt').SetInt( 57004);
 CL.AddConstantN('zCP_x_iscii_te','LongInt').SetInt( 57005);
 CL.AddConstantN('zCP_x_iscii_as','LongInt').SetInt( 57006);
 CL.AddConstantN('zCP_x_iscii_or','LongInt').SetInt( 57007);
 CL.AddConstantN('zCP_x_iscii_ka','LongInt').SetInt( 57008);
 CL.AddConstantN('zCP_x_iscii_ma','LongInt').SetInt( 57009);
 CL.AddConstantN('zCP_x_iscii_gu','LongInt').SetInt( 57010);
 CL.AddConstantN('zCP_x_iscii_pa','LongInt').SetInt( 57011);
 CL.AddConstantN('zCP_UTF8','LongInt').SetInt( 65001);
 CL.AddConstantN('zCP_UTF7','LongInt').SetInt( 65000);
 CL.AddConstantN('zCP_NONE','LongWord').SetUInt( $ffff);
 CL.AddDelphiFunction('Function IsLConvEncodingCodePage( const CP : Word) : Boolean');
 //CL.AddDelphiFunction('Procedure SetConvertFunctions( const CTRL_CP, DB_CP : Word; out PlainConvert, DbcConvert : TConvertEncodingFunction);');
 CL.AddDelphiFunction('Function StringToAnsiEx( const s : String; const FromCP, ToCP : Word) : RawByteString');
 CL.AddDelphiFunction('Function AnsiToStringEx( const s : RawByteString; const FromCP, ToCP : Word) : String');
 CL.AddDelphiFunction('Function ZRawToUnicode( const S : RawByteString; const CP : Word) : WideString');
 CL.AddDelphiFunction('Function ZUnicodeToRaw( const US : WideString; CP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZConvertAnsiToRaw( const Src : AnsiString; const RawCP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZConvertRawToAnsi( const Src : RawByteString; const RawCP : Word) : AnsiString');
 CL.AddDelphiFunction('Function ZConvertAnsiToUTF8( const Src : AnsiString) : UTF8String');
 CL.AddDelphiFunction('Function ZConvertUTF8ToAnsi( const Src : UTF8String) : AnsiString');
 CL.AddDelphiFunction('Function ZConvertRawToUTF8( const Src : RawByteString; const CP : Word) : UTF8String');
 CL.AddDelphiFunction('Function ZConvertUTF8ToRaw( const Src : UTF8String; const CP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZConvertRawToString( const Src : RawByteString; const RawCP, StringCP : Word) : String');
 CL.AddDelphiFunction('Function ZConvertStringToRaw( const Src : String; const StringCP, RawCP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZConvertStringToRawWithAutoEncode( const Src : String; const StringCP, RawCP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZConvertUTF8ToString( const Src : UTF8String; const StringCP : Word) : String');
 CL.AddDelphiFunction('Function ZConvertStringToUTF8( const Src : String; const StringCP : Word) : UTF8String');
 CL.AddDelphiFunction('Function ZConvertStringToUTF8WithAutoEncode( const Src : String; const StringCP : Word) : UTF8String');
 CL.AddDelphiFunction('Function ZConvertStringToAnsi( const Src : String; const StringCP : Word) : AnsiString');
 CL.AddDelphiFunction('Function ZConvertStringToAnsiWithAutoEncode( const Src : String; const StringCP : Word) : AnsiString');
 CL.AddDelphiFunction('Function ZConvertAnsiToString( const Src : AnsiString; const StringCP : Word) : String');
 CL.AddDelphiFunction('Function ZConvertUnicodeToString( const Src : WideString; const StringCP : Word) : String');
 CL.AddDelphiFunction('Function ZConvertUnicodeToString_CPUTF8( const Src : WideString; const StringCP : Word) : String');
 CL.AddDelphiFunction('Function ZConvertStringToUnicode( const Src : String; const StringCP : Word) : WideString');
 CL.AddDelphiFunction('Function ZConvertString_CPUTF8ToUnicode( const Src : String; const StringCP : Word) : WideString');
 CL.AddDelphiFunction('Function ZConvertStringToUnicodeWithAutoEncode( const Src : String; const StringCP : Word) : WideString');
 CL.AddDelphiFunction('Function ZMoveAnsiToRaw( const Src : AnsiString; const RawCP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZMoveRawToAnsi( const Src : RawByteString; const RawCP : Word) : AnsiString');
 CL.AddDelphiFunction('Function ZMoveAnsiToUTF8( const Src : AnsiString) : UTF8String');
 CL.AddDelphiFunction('Function ZMoveUTF8ToAnsi( const Src : UTF8String) : AnsiString');
 CL.AddDelphiFunction('Function ZMoveRawToUTF8( const Src : RawByteString; const CP : Word) : UTF8String');
 CL.AddDelphiFunction('Function ZMoveUTF8ToRaw( const Src : UTF8String; const CP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZMoveStringToAnsi( const Src : String; const StringCP : Word) : AnsiString');
 CL.AddDelphiFunction('Function ZMoveAnsiToString( const Src : AnsiString; const StringCP : Word) : String');
 CL.AddDelphiFunction('Function ZMoveRawToString( const Src : RawByteString; const RawCP, StringCP : Word) : String');
 CL.AddDelphiFunction('Function ZMoveStringToRaw( const Src : String; const StringCP, RawCP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZMoveUTF8ToString( const Src : UTF8String; StringCP : Word) : String');
 CL.AddDelphiFunction('Function ZMoveStringToUTF8( const Src : String; const StringCP : Word) : UTF8String');
 CL.AddDelphiFunction('Function ZUnknownRawToUnicode( const S : RawByteString; const CP : Word) : WideString');
 CL.AddDelphiFunction('Function ZUnknownRawToUnicodeWithAutoEncode( const S : RawByteString; const CP : Word) : WideString');
 CL.AddDelphiFunction('Function ZUnicodeToUnknownRaw( const US : WideString; CP : Word) : RawByteString');
 CL.AddDelphiFunction('Function ZDefaultSystemCodePage : Word');
 CL.AddDelphiFunction('Function ZCompatibleCodePages( const CP1, CP2 : Word) : Boolean');
 //CL.AddDelphiFunction('Procedure SetConvertFunctions1( ConSettings : PZConSettings);');
 //CL.AddDelphiFunction('Function GetValidatedAnsiStringFromBuffer( const Buffer : string; Size : Cardinal; ConSettings : PZConSettings) : RawByteString;');
 //CL.AddDelphiFunction('Function GetValidatedAnsiStringFromBuffer1( const Buffer : string; Size : Cardinal; ConSettings : PZConSettings; ToCP : Word) : RawByteString;');
 //CL.AddDelphiFunction('Function GetValidatedAnsiStringFromBuffer( const Buffer : string; Size : Cardinal; WasDecoded : Boolean; ConSettings : PZConSettings) : RawByteString;');
// CL.AddDelphiFunction('Function GetValidatedAnsiString( const Ansi : RawByteString; ConSettings : PZConSettings; const FromDB : Boolean) : RawByteString;');
 //CL.AddDelphiFunction('Function GetValidatedAnsiString1( const Uni : ZWideString; ConSettings : PZConSettings; const FromDB : Boolean) : RawByteString;');
 //CL.AddDelphiFunction('Function GetValidatedUnicodeStream( const Buffer : Pointer; Size : Cardinal; ConSettings : PZConSettings; FromDB : Boolean) : TStream;');
 //CL.AddDelphiFunction('Function GetValidatedUnicodeStream( const Ansi : RawByteString; ConSettings : PZConSettings; FromDB : Boolean) : TStream;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function GetValidatedUnicodeStream_P( const Ansi : RawByteString; ConSettings : PZConSettings; FromDB : Boolean) : TStream;
Begin Result := ZEncoding.GetValidatedUnicodeStream(Ansi, ConSettings, FromDB); END;

(*----------------------------------------------------------------------------*)
//Function GetValidatedUnicodeStream_P( const Buffer : Pointer; Size : Cardinal; ConSettings : PZConSettings; FromDB : Boolean) : TStream;
//Begin Result := ZEncoding.GetValidatedUnicodeStream(Buffer, Size, ConSettings, FromDB); END;

(*----------------------------------------------------------------------------*)
//Function GetValidatedAnsiString1_P( const Uni : ZWideString; ConSettings : PZConSettings; const FromDB : Boolean) : RawByteString;
//Begin Result := ZEncoding.GetValidatedAnsiString(Uni, ConSettings, FromDB); END;

(*----------------------------------------------------------------------------*)
Function GetValidatedAnsiString_P( const Ansi : RawByteString; ConSettings : PZConSettings; const FromDB : Boolean) : RawByteString;
Begin Result := ZEncoding.GetValidatedAnsiString(Ansi, ConSettings, FromDB); END;

(*----------------------------------------------------------------------------*)
Function GetValidatedAnsiStringFromBuffer_P( const Buffer : Pointer; Size : Cardinal; WasDecoded : Boolean; ConSettings : PZConSettings) : RawByteString;
Begin Result := ZEncoding.GetValidatedAnsiStringFromBuffer(Buffer, Size, WasDecoded, ConSettings); END;

(*----------------------------------------------------------------------------*)
Function GetValidatedAnsiStringFromBuffer1_P( const Buffer : Pointer; Size : Cardinal; ConSettings : PZConSettings; ToCP : Word) : RawByteString;
Begin Result := ZEncoding.GetValidatedAnsiStringFromBuffer(Buffer, Size, ConSettings, ToCP); END;

(*----------------------------------------------------------------------------*)
//Function GetValidatedAnsiStringFromBuffer_P( const Buffer : Pointer; Size : Cardinal; ConSettings : PZConSettings) : RawByteString;
//Begin Result := ZEncoding.GetValidatedAnsiStringFromBuffer(Buffer, Size, ConSettings); END;

(*----------------------------------------------------------------------------*)
Procedure SetConvertFunctions1_P( ConSettings : PZConSettings);
Begin ZEncoding.SetConvertFunctions(ConSettings); END;

(*----------------------------------------------------------------------------*)
//Procedure SetConvertFunctions_P( const CTRL_CP, DB_CP : Word; out PlainConvert, DbcConvert : TConvertEncodingFunction);
//Begin ZEncoding.SetConvertFunctions(CTRL_CP, DB_CP, PlainConvert, DbcConvert); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZEncoding_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@IsLConvEncodingCodePage, 'IsLConvEncodingCodePage', cdRegister);
 S.RegisterDelphiFunction(@SetConvertFunctions, 'SetConvertFunctions', cdRegister);
 S.RegisterDelphiFunction(@StringToAnsiEx, 'StringToAnsiEx', cdRegister);
 S.RegisterDelphiFunction(@AnsiToStringEx, 'AnsiToStringEx', cdRegister);
 S.RegisterDelphiFunction(@ZRawToUnicode, 'ZRawToUnicode', cdRegister);
 S.RegisterDelphiFunction(@ZUnicodeToRaw, 'ZUnicodeToRaw', cdRegister);
 S.RegisterDelphiFunction(@ZConvertAnsiToRaw, 'ZConvertAnsiToRaw', cdRegister);
 S.RegisterDelphiFunction(@ZConvertRawToAnsi, 'ZConvertRawToAnsi', cdRegister);
 S.RegisterDelphiFunction(@ZConvertAnsiToUTF8, 'ZConvertAnsiToUTF8', cdRegister);
 S.RegisterDelphiFunction(@ZConvertUTF8ToAnsi, 'ZConvertUTF8ToAnsi', cdRegister);
 S.RegisterDelphiFunction(@ZConvertRawToUTF8, 'ZConvertRawToUTF8', cdRegister);
 S.RegisterDelphiFunction(@ZConvertUTF8ToRaw, 'ZConvertUTF8ToRaw', cdRegister);
 S.RegisterDelphiFunction(@ZConvertRawToString, 'ZConvertRawToString', cdRegister);
 S.RegisterDelphiFunction(@ZConvertStringToRaw, 'ZConvertStringToRaw', cdRegister);
 S.RegisterDelphiFunction(@ZConvertStringToRawWithAutoEncode, 'ZConvertStringToRawWithAutoEncode', cdRegister);
 S.RegisterDelphiFunction(@ZConvertUTF8ToString, 'ZConvertUTF8ToString', cdRegister);
 S.RegisterDelphiFunction(@ZConvertStringToUTF8, 'ZConvertStringToUTF8', cdRegister);
 S.RegisterDelphiFunction(@ZConvertStringToUTF8WithAutoEncode, 'ZConvertStringToUTF8WithAutoEncode', cdRegister);
 S.RegisterDelphiFunction(@ZConvertStringToAnsi, 'ZConvertStringToAnsi', cdRegister);
 S.RegisterDelphiFunction(@ZConvertStringToAnsiWithAutoEncode, 'ZConvertStringToAnsiWithAutoEncode', cdRegister);
 S.RegisterDelphiFunction(@ZConvertAnsiToString, 'ZConvertAnsiToString', cdRegister);
 S.RegisterDelphiFunction(@ZConvertUnicodeToString, 'ZConvertUnicodeToString', cdRegister);
 S.RegisterDelphiFunction(@ZConvertUnicodeToString_CPUTF8, 'ZConvertUnicodeToString_CPUTF8', cdRegister);
 S.RegisterDelphiFunction(@ZConvertStringToUnicode, 'ZConvertStringToUnicode', cdRegister);
 S.RegisterDelphiFunction(@ZConvertString_CPUTF8ToUnicode, 'ZConvertString_CPUTF8ToUnicode', cdRegister);
 S.RegisterDelphiFunction(@ZConvertStringToUnicodeWithAutoEncode, 'ZConvertStringToUnicodeWithAutoEncode', cdRegister);
 S.RegisterDelphiFunction(@ZMoveAnsiToRaw, 'ZMoveAnsiToRaw', cdRegister);
 S.RegisterDelphiFunction(@ZMoveRawToAnsi, 'ZMoveRawToAnsi', cdRegister);
 S.RegisterDelphiFunction(@ZMoveAnsiToUTF8, 'ZMoveAnsiToUTF8', cdRegister);
 S.RegisterDelphiFunction(@ZMoveUTF8ToAnsi, 'ZMoveUTF8ToAnsi', cdRegister);
 S.RegisterDelphiFunction(@ZMoveRawToUTF8, 'ZMoveRawToUTF8', cdRegister);
 S.RegisterDelphiFunction(@ZMoveUTF8ToRaw, 'ZMoveUTF8ToRaw', cdRegister);
 S.RegisterDelphiFunction(@ZMoveStringToAnsi, 'ZMoveStringToAnsi', cdRegister);
 S.RegisterDelphiFunction(@ZMoveAnsiToString, 'ZMoveAnsiToString', cdRegister);
 S.RegisterDelphiFunction(@ZMoveRawToString, 'ZMoveRawToString', cdRegister);
 S.RegisterDelphiFunction(@ZMoveStringToRaw, 'ZMoveStringToRaw', cdRegister);
 S.RegisterDelphiFunction(@ZMoveUTF8ToString, 'ZMoveUTF8ToString', cdRegister);
 S.RegisterDelphiFunction(@ZMoveStringToUTF8, 'ZMoveStringToUTF8', cdRegister);
 S.RegisterDelphiFunction(@ZUnknownRawToUnicode, 'ZUnknownRawToUnicode', cdRegister);
 S.RegisterDelphiFunction(@ZUnknownRawToUnicodeWithAutoEncode, 'ZUnknownRawToUnicodeWithAutoEncode', cdRegister);
 S.RegisterDelphiFunction(@ZUnicodeToUnknownRaw, 'ZUnicodeToUnknownRaw', cdRegister);
 S.RegisterDelphiFunction(@ZDefaultSystemCodePage, 'ZDefaultSystemCodePage', cdRegister);
 S.RegisterDelphiFunction(@ZCompatibleCodePages, 'ZCompatibleCodePages', cdRegister);
 S.RegisterDelphiFunction(@SetConvertFunctions1_P, 'SetConvertFunctions1', cdRegister);
 S.RegisterDelphiFunction(@GetValidatedAnsiStringFromBuffer, 'GetValidatedAnsiStringFromBuffer', cdRegister);
 S.RegisterDelphiFunction(@GetValidatedAnsiStringFromBuffer1_P, 'GetValidatedAnsiStringFromBuffer1', cdRegister);
 S.RegisterDelphiFunction(@GetValidatedAnsiStringFromBuffer, 'GetValidatedAnsiStringFromBuffer', cdRegister);
 S.RegisterDelphiFunction(@GetValidatedAnsiString, 'GetValidatedAnsiString', cdRegister);
 //S.RegisterDelphiFunction(@GetValidatedAnsiString1_P, 'GetValidatedAnsiString1', cdRegister);
 S.RegisterDelphiFunction(@GetValidatedUnicodeStream, 'GetValidatedUnicodeStream', cdRegister);
 S.RegisterDelphiFunction(@GetValidatedUnicodeStream, 'GetValidatedUnicodeStream', cdRegister);
end;

 
 
{ TPSImport_ZEncoding }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZEncoding.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZEncoding(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZEncoding.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_ZEncoding(ri);
  RIRegister_ZEncoding_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
