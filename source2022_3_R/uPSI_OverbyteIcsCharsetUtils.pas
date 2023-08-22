unit uPSI_OverbyteIcsCharsetUtils;
{
charset and mimeutils  listing

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
  TPSImport_OverbyteIcsCharsetUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCodePageObj(CL: TPSPascalCompiler);
procedure SIRegister_OverbyteIcsCharsetUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_OverbyteIcsCharsetUtils_Routines(S: TPSExec);
procedure RIRegister_TCodePageObj(CL: TPSRuntimeClassImporter);
procedure RIRegister_OverbyteIcsCharsetUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   OverbyteIcsCharsetUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_OverbyteIcsCharsetUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCodePageObj(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCodePageObj') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCodePageObj') do
  begin
    RegisterProperty('CodePage', 'LongWord', iptr);
    RegisterProperty('CodePageName', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_OverbyteIcsCharsetUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ERR_CP_NOTMAPPED','LongInt').SetInt( MAX_CODEPAGE + 1);
 CL.AddConstantN('ERR_CP_NOTAVAILABLE','LongInt').SetInt( MAX_CODEPAGE + 2);
 CL.AddConstantN('CP_US_ASCII','LongInt').SetInt( 20127);
  CL.AddTypeS('CsuString', 'String');
  CL.AddTypeS('TMimeCharset', '( CS_DEFAULT, CS_NOTMAPPED, UTF_8, WIN_1250, WIN'
   +'_1251, WIN_1252, WIN_1253, WIN_1254, WIN_1255, WIN_1256, WIN_1257, WIN_125'
   +'8, ISO_8859_1, ISO_8859_2, ISO_8859_3, ISO_8859_4, ISO_8859_5, ISO_8859_6,'
   +' ISO_8859_7, ISO_8859_8, ISO_8859_8_i, ISO_8859_9, ISO_8859_13, ISO_8859_1'
   +'5, ISO_2022_JP, ISO_2022_JP_1, ISO_2022_JP_2, ISO_2022_KR, ISO_2022_CN, X_'
   +'CP50227, EUC_JP, GB_2312_80, GB_2312, HZ_GB_2312, GB_18030, EUC_CN, KOI8_R'
   +', KOI8_U, UTF_16LE, UTF_16BE, UTF_7, SHIFT_JIS, BIG_5, KOREAN_HANGUL, EUC_'
   +'KR, WIN_874, IBM_037, IBM_437, IBM_500, IBM_850, IBM_852, IBM_855, IBM_857'
   +', IBM_00858, IBM_860, IBM_861, IBM_862, IBM_863, IBM_864, IBM_865, IBM_866'
   +', IBM_869, IBM_870, IBM_1026, IBM_01047, IBM_01140, IBM_01141, IBM_01142, '
   +'IBM_01143, IBM_01144, IBM_01145, IBM_01146, IBM_01147, IBM_01148, IBM_0114'
   +'9, MACINTOSH, UTF_32LE, UTF_32BE, US_ASCII, T_61, CS_LAST_ITEM )');
  CL.AddTypeS('TMimeCharsets', 'set of TMimeCharset');
  CL.AddTypeS('_cpinfoexA', 'record MaxCharSize :UINT; DefaultChar: array[0..2 - 1] of Byte; LeadByte :array[0..12 - 1] of Byte;'+
              'UnicodeDefaultChar: WideChar; CodePage: UINT; CodePageName : array[0..MAX_PATH] of AnsiChar; end');
  CL.AddTypeS('_cpinfoexW', 'record MaxCharSize :UINT; DefaultChar: array[0..2 - 1] of Byte; LeadByte :array[0..12 - 1] of Byte;'+
              'UnicodeDefaultChar: WideChar; CodePage: UINT; CodePageName : array[0..MAX_PATH] of WideChar; end');
   (*_cpinfoexA = record
        MaxCharSize         : UINT;                                     { max length (bytes) of a char }
        DefaultChar         : array[0..MAX_DEFAULTCHAR - 1] of Byte;    { default character }
        LeadByte            : array[0..MAX_LEADBYTES - 1] of Byte;      { lead byte ranges }
        UnicodeDefaultChar  : WideChar;
        CodePage            : UINT;
        CodePageName        : array[0..MAX_PATH] of AnsiChar;
    end;   *)

  //CL.AddTypeS('PCharsetInfo', '^TCharsetInfo // will not work');
  CL.AddTypeS('TCharsetInfo', 'record MimeCharset : TMimeCharset; CodePage : Lo'
   +'ngWord; MimeName : CsuString; FriendlyName : String; end');
  CL.AddTypeS('TCharsetInfos', 'array of TCharsetInfo');
  //CL.AddTypeS('LPCPINFOEXA', '^CPINFOEXA // will not work');
  CL.AddTypeS('CPINFOEXA', '_cpinfoexA');
  CL.AddTypeS('TCpInfoExA', 'CPINFOEXA');
  //CL.AddTypeS('PCpInfoExA', 'LPCPINFOEXA');
  //CL.AddTypeS('LPCPINFOEXW', '^CPINFOEXW // will not work');
  CL.AddTypeS('CPINFOEXW', '_cpinfoexW');
  CL.AddTypeS('TCpInfoExW', 'CPINFOEXW');
  //CL.AddTypeS('PCpInfoExW', 'LPCPINFOEXW');
  //CL.AddTypeS('PCpInfoEx', 'PCpInfoExW');
  CL.AddTypeS('CPINFOEX', 'CPINFOEXW');
  CL.AddTypeS('TCpInfoEx', 'TCpInfoExW');
  //CL.AddTypeS('LPCPINFOEX', 'LPCPINFOEXW');
  //CL.AddTypeS('PCpInfoEx', 'PCpInfoExA');
  CL.AddTypeS('CPINFOEX', 'CPINFOEXA');
  CL.AddTypeS('TCpInfoEx', 'TCpInfoExA');
  //CL.AddTypeS('LPCPINFOEX', 'LPCPINFOEXA');
  SIRegister_TCodePageObj(CL);
 CL.AddDelphiFunction('Function CodePageToMimeCharset( ACodePage : LongWord) : TMimeCharset');
 CL.AddDelphiFunction('Function CodePageToMimeCharsetString( ACodePage : LongWord) : CsuString');
 //CL.AddDelphiFunction('Function GetMimeInfo0( AMimeCharSet : TMimeCharset) : PCharSetInfo;');
 //&&CL.AddDelphiFunction('Function GetMimeInfo1( const AMimeCharSetString : CsuString) : PCharSetInfo;');
 //CL.AddDelphiFunction('Function GetMimeInfo2( ACodePage : LongWord) : PCharSetInfo;');
 CL.AddDelphiFunction('Function MimeCharsetToCharsetString( AMimeCharSet : TMimeCharset) : CsuString');
 //CL.AddDelphiFunction('Function ExtractMimeName( PInfo : PCharSetInfo) : CsuString');
 CL.AddDelphiFunction('Function MimeCharsetToCodePage3( AMimeCharSet : TMimeCharset) : LongWord;');
 CL.AddDelphiFunction('Function MimeCharsetToCodePage4( const AMimeCharSetString : CsuString; out ACodePage : LongWord) : Boolean;');
 CL.AddDelphiFunction('Function MimeCharsetToCodePageDef( const AMimeCharSetString : CsuString) : LongWord');
 CL.AddDelphiFunction('Function MimeCharsetToCodePageEx5( const AMimeCharSetString : CsuString; out ACodePage : LongWord) : Boolean;');
 CL.AddDelphiFunction('Function MimeCharsetToCodePageExDef( const AMimeCharSetString : CsuString) : LongWord');
 CL.AddDelphiFunction('Function IsValidAnsiCodePage( ACodePage : LongWord) : Boolean');
 CL.AddDelphiFunction('Function IcsIsValidCodePageID( ACodePage : LongWord) : Boolean');
 CL.AddDelphiFunction('Function IsSingleByteCodePage( ACodePage : LongWord) : Boolean');
 CL.AddDelphiFunction('Procedure GetSystemCodePageList( AOwnsObjectList : TObjectList)');
 CL.AddDelphiFunction('Function AnsiCodePageFromLocale( ALcid : LCID) : LongWord');
 CL.AddDelphiFunction('Function OemCodePageFromLocale( ALcid : LCID) : LongWord');
 CL.AddDelphiFunction('Function GetThreadAnsiCodePage : LongWord');
 CL.AddDelphiFunction('Function GetThreadOemCodePage : LongWord');
 CL.AddDelphiFunction('Function GetUserDefaultAnsiCodePage : LongWord');
 CL.AddDelphiFunction('Function GetUserDefaultOemCodePage : LongWord');
 CL.AddDelphiFunction('Function GetCPInfoExA( CodePage : UINT; dwFlags : DWORD; var lpCPInfoEx : CPINFOEXA) : BOOL');
 CL.AddDelphiFunction('Function GetCPInfoExW( CodePage : UINT; dwFlags : DWORD; var lpCPInfoEx : CPINFOEXW) : BOOL');
 CL.AddDelphiFunction('Function GetCPInfoEx( CodePage : UINT; dwFlags : DWORD; var lpCPInfoEx : CPINFOEX) : BOOL');
 CL.AddDelphiFunction('Procedure GetFriendlyCharsetList( Items : TStrings; IncludeList : TMimeCharsets; ClearItems : Boolean)');
 CL.AddDelphiFunction('Procedure GetMimeCharsetList( Items : TStrings; IncludeList : TMimeCharsets; ClearItems : Boolean)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function MimeCharsetToCodePageEx5_P( const AMimeCharSetString : CsuString; out ACodePage : LongWord) : Boolean;
Begin Result := OverbyteIcsCharsetUtils.MimeCharsetToCodePageEx(AMimeCharSetString, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function MimeCharsetToCodePage4_P( const AMimeCharSetString : CsuString; out ACodePage : LongWord) : Boolean;
Begin Result := OverbyteIcsCharsetUtils.MimeCharsetToCodePage(AMimeCharSetString, ACodePage); END;

(*----------------------------------------------------------------------------*)
Function MimeCharsetToCodePage3_P( AMimeCharSet : TMimeCharset) : LongWord;
Begin Result := OverbyteIcsCharsetUtils.MimeCharsetToCodePage(AMimeCharSet); END;

(*----------------------------------------------------------------------------*)
Function GetMimeInfo2_P( ACodePage : LongWord) : PCharSetInfo;
Begin Result := OverbyteIcsCharsetUtils.GetMimeInfo(ACodePage); END;

(*----------------------------------------------------------------------------*)
Function GetMimeInfo1_P( const AMimeCharSetString : CsuString) : PCharSetInfo;
Begin Result := OverbyteIcsCharsetUtils.GetMimeInfo(AMimeCharSetString); END;

(*----------------------------------------------------------------------------*)
Function GetMimeInfo0_P( AMimeCharSet : TMimeCharset) : PCharSetInfo;
Begin Result := OverbyteIcsCharsetUtils.GetMimeInfo(AMimeCharSet); END;

(*----------------------------------------------------------------------------*)
procedure TCodePageObjCodePageName_R(Self: TCodePageObj; var T: String);
begin T := Self.CodePageName; end;

(*----------------------------------------------------------------------------*)
procedure TCodePageObjCodePage_R(Self: TCodePageObj; var T: LongWord);
begin T := Self.CodePage; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsCharsetUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CodePageToMimeCharset, 'CodePageToMimeCharset', cdRegister);
 S.RegisterDelphiFunction(@CodePageToMimeCharsetString, 'CodePageToMimeCharsetString', cdRegister);
 S.RegisterDelphiFunction(@GetMimeInfo0_P, 'GetMimeInfo0', cdRegister);
 S.RegisterDelphiFunction(@GetMimeInfo1_P, 'GetMimeInfo1', cdRegister);
 S.RegisterDelphiFunction(@GetMimeInfo2_P, 'GetMimeInfo2', cdRegister);
 S.RegisterDelphiFunction(@MimeCharsetToCharsetString, 'MimeCharsetToCharsetString', cdRegister);
 S.RegisterDelphiFunction(@ExtractMimeName, 'ExtractMimeName', cdRegister);
 S.RegisterDelphiFunction(@MimeCharsetToCodePage3_P, 'MimeCharsetToCodePage3', cdRegister);
 S.RegisterDelphiFunction(@MimeCharsetToCodePage4_P, 'MimeCharsetToCodePage4', cdRegister);
 S.RegisterDelphiFunction(@MimeCharsetToCodePageDef, 'MimeCharsetToCodePageDef', cdRegister);
 S.RegisterDelphiFunction(@MimeCharsetToCodePageEx5_P, 'MimeCharsetToCodePageEx5', cdRegister);
 S.RegisterDelphiFunction(@MimeCharsetToCodePageExDef, 'MimeCharsetToCodePageExDef', cdRegister);
 S.RegisterDelphiFunction(@IsValidAnsiCodePage, 'IsValidAnsiCodePage', cdRegister);
 S.RegisterDelphiFunction(@IcsIsValidCodePageID, 'IcsIsValidCodePageID', cdRegister);
 S.RegisterDelphiFunction(@IsSingleByteCodePage, 'IsSingleByteCodePage', cdRegister);
 S.RegisterDelphiFunction(@GetSystemCodePageList, 'GetSystemCodePageList', cdRegister);
 S.RegisterDelphiFunction(@AnsiCodePageFromLocale, 'AnsiCodePageFromLocale', cdRegister);
 S.RegisterDelphiFunction(@OemCodePageFromLocale, 'OemCodePageFromLocale', cdRegister);
 S.RegisterDelphiFunction(@GetThreadAnsiCodePage, 'GetThreadAnsiCodePage', cdRegister);
 S.RegisterDelphiFunction(@GetThreadOemCodePage, 'GetThreadOemCodePage', cdRegister);
 S.RegisterDelphiFunction(@GetUserDefaultAnsiCodePage, 'GetUserDefaultAnsiCodePage', cdRegister);
 S.RegisterDelphiFunction(@GetUserDefaultOemCodePage, 'GetUserDefaultOemCodePage', cdRegister);
 S.RegisterDelphiFunction(@GetCPInfoExA, 'GetCPInfoExA', CdStdCall);
 S.RegisterDelphiFunction(@GetCPInfoExW, 'GetCPInfoExW', CdStdCall);
 S.RegisterDelphiFunction(@GetCPInfoEx, 'GetCPInfoEx', CdStdCall);
 S.RegisterDelphiFunction(@GetFriendlyCharsetList, 'GetFriendlyCharsetList', cdRegister);
 S.RegisterDelphiFunction(@GetMimeCharsetList, 'GetMimeCharsetList', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCodePageObj(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCodePageObj) do
  begin
    RegisterPropertyHelper(@TCodePageObjCodePage_R,nil,'CodePage');
    RegisterPropertyHelper(@TCodePageObjCodePageName_R,nil,'CodePageName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_OverbyteIcsCharsetUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCodePageObj(CL);
end;

 
 
{ TPSImport_OverbyteIcsCharsetUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsCharsetUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_OverbyteIcsCharsetUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_OverbyteIcsCharsetUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_OverbyteIcsCharsetUtils(ri);
  RIRegister_OverbyteIcsCharsetUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
