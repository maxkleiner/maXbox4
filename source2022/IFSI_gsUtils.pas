unit IFSI_gsUtils;
{
 teach & train the brain LEDMAX, shellexecute3
}
{$I PascalScript.inc}
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
  TPSImport_gsUtils = class(TPSPlugin)
  protected
    procedure CompOnUses(CompExec: TPSScript); override;
    procedure ExecOnUses(CompExec: TPSScript); override;
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure CompileImport2(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
    procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;



{ compile-time registration functions }
procedure SIRegister_gsUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_gsUtils_Routines(S: TPSExec);



implementation


uses
  // Wintypes
  //,WinProcs
  //Dialogs
  //,graphics
  //,gsStdObj
  gsUtils, uPSI_ImageGrabber, FileUtils;


{ compile-time importer function }
(*----------------------------------------------------------------------------
 Sometimes the CL.AddClassN() fails to correctly register a class,
 for unknown (at least to me) reasons
 So, you may use the below RegClassS() replacing the CL.AddClassN()
 of the various SIRegister_XXXX calls
 ----------------------------------------------------------------------------*)
function RegClassS(CL: TPSPascalCompiler; const InheritsFrom, Classname: string): TPSCompileTimeClass;
begin
  Result := CL.FindClass(Classname);
  if Result = nil then
    Result := CL.AddClassN(CL.FindClass(InheritsFrom), Classname)
  else Result.ClassInheritsFrom := CL.FindClass(InheritsFrom);
end;

procedure OpenDirectory(adir: string);
begin
   S_ShellExecute('explorer.exe',adir,secmdopen);
end;


 const
   B = 1; //byte
   KB = 1024 * B; //kilobyte
   aMB = 1024 * KB; //megabyte
   GB = 1024 * aMB; //gigabyte


function FormatByteSize(const bytes: int64): string;
 begin
   if bytes > GB then
     result:= FormatFloat('#.## GB',bytes / GB)
   else
     if bytes > aMB then
       result:= FormatFloat('#.## MB',bytes / aMB)
     else
       if bytes > KB then
         result:= FormatFloat('#.## KB',bytes / KB)
       else
         result:= FormatFloat('#.## bytes',bytes) ;
 end;
 
 function countDirfiles(const apath: string): integer;
 var dlist: TStringlist;
 begin
    dlist:= TStringlist.create;
    try
      GetDirList(apath,dlist,true);
      //for i:= 0 to dirlist.count - 1 do
       //writeln(ExtractFileName(dirlist[i]));
      result:= dlist.count;
    finally
      dlist.Free;
    end;
 end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_gsUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('function S_StrToReal(const cStr: string; var R: Double): Boolean');
 CL.AddDelphiFunction('Procedure S_IBox( const AText : string)');
 CL.AddDelphiFunction('Procedure S_EBox( const AText : string)');
 CL.AddDelphiFunction('Function S_WBox( const AText : string) : integer');
 CL.AddDelphiFunction('Function S_RTrim( const cStr : string) : string');
 CL.AddDelphiFunction('Function S_RTrimCopy( const cStr : string; iPos, iLen : integer) : string');
 CL.AddDelphiFunction('Function S_LTrim( const cStr : string) : string');
 CL.AddDelphiFunction('Function S_AllTrim( const cStr : string) : string');
 CL.AddDelphiFunction('Function S_Empty( const cStr : string) : boolean');
 CL.AddDelphiFunction('Function S_Cut( const cStr : string; const iLen : integer) : string');
 CL.AddDelphiFunction('Function S_AtRepl( const cAT, cStr, cRepl : string) : string');
 CL.AddDelphiFunction('Function S_ReplFirst( const cAT, cStr, cRepl : string) : string');
 CL.AddDelphiFunction('Function S_Space( const iLen : integer) : String');
 CL.AddDelphiFunction('Function S_RepeatChar( const iLen : integer; const AChar : Char) : String');
 CL.AddDelphiFunction('Procedure S_ReplaceChar( var cStr : string; cOldChr, cNewChr : char)');
 CL.AddDelphiFunction('Procedure S_ReplaceStringInFile( AFileName : string; ASearchString, AReplaceString : string)');
 CL.AddDelphiFunction('Function S_StrBlanks( const cStr : string; const iLen : integer) : string');
 CL.AddDelphiFunction('Function S_StrBlanksCuttooLong( const cStr : string; const iLen : integer) : string');
 CL.AddDelphiFunction('Function S_StrLBlanks( const cStr : string; const iLen : integer) : string');
 CL.AddDelphiFunction('Procedure S_TokenInit( cBuffer : PChar; const cDelimiters : string)');
 CL.AddDelphiFunction('Function S_TokenEnd( cBuffer : PChar; lEmptyToken : boolean) : boolean');
 CL.AddDelphiFunction('Function S_TokenNext( cBuffer : PChar; lEmptyToken : boolean) : string');
 CL.AddDelphiFunction('Function S_AddBackSlash( const ADirName : string) : string');
 //CL.AddDelphiFunction('Function Buf2HexStr( ABuffer : Pointer; ABufLen : integer; AAddSpaces : Boolean) : string');
 //CL.AddDelphiFunction('Function HexBuf2Str( ABuffer : Pointer; ABufLen : integer; AHasSpaces : Boolean) : string');
 CL.AddDelphiFunction('Function LastPos( const ASubstr : string; const AStr : string) : Integer');
 CL.AddDelphiFunction('Function DelSpace( const pStr : string) : string');
 CL.AddDelphiFunction('Function DelChar( const pStr : string; const pChar : Char) : string');
 CL.AddDelphiFunction('Function DelString( const pStr, pDelStr : string) : string');
 CL.AddDelphiFunction('Procedure DeleteString( var pStr : String; const pDelStr : string)');
 CL.AddDelphiFunction('Function PadL( pStr : String; pLth : integer) : String');
 CL.AddDelphiFunction('Function PadR( pStr : String; pLth : integer) : String');
 CL.AddDelphiFunction('Function PadLCh( pStr : String; pLth : integer; pChr : char) : String');
 CL.AddDelphiFunction('Function PadRCh( pStr : String; pLth : integer; pChr : char) : String');
 CL.AddDelphiFunction('Function GetReadableName( const AName : string) : string');
 CL.AddDelphiFunction('Function GetNextDelimitedToken( const cDelim : char; var cStr : String) : String');
 CL.AddDelphiFunction('Function GetLastDelimitedToken( const cDelim : char; const cStr : string) : string');
 CL.AddDelphiFunction('Function GetFirstDelimitedToken( const cDelim : char; const cStr : string) : string');
 CL.AddDelphiFunction('Function CompareTextLike( cWildStr, cStr : string; const cWildChar : char; lCaseSensitive : boolean) : boolean');
 CL.AddDelphiFunction('Function MaskString( Mask, Value : String) : String');
 CL.AddDelphiFunction('Function UnMaskString( Mask, Value : String) : String');
 CL.AddDelphiFunction('Function StrToFloatRegionalIndependent( aValue : String; aDecimalSymbol : Char; aDigitGroupSymbol : Char) : Extended');
 CL.AddDelphiFunction('Function S_UTF_8ToString( const AString : string) : string');
 CL.AddDelphiFunction('Function S_StringtoUTF_8( const AString : string) : string');
 CL.AddDelphiFunction('Function S_ReadNextTextLineFromStream( stream : TStream) : string');
 CL.AddDelphiFunction('Function Stream2WideString( oStream : TStream) : WideString');
 CL.AddDelphiFunction('Procedure WideString2Stream( aWideString : WideString; oStream : TStream)');
 CL.AddDelphiFunction('Procedure S_AddMessageToStrings( AMessages : TStrings; AMsg : string)');
 CL.AddDelphiFunction('Function BitmapsAreIdentical( ABitmap1, ABitmap2 : TBitmap) : Boolean');
 CL.AddDelphiFunction('Procedure SimulateKeystroke( Key : byte; Shift : TShiftState)');
 CL.AddDelphiFunction('Procedure GetApplicationsRunning( Strings : TStrings)');
 CL.AddDelphiFunction('Function IsApplicationRunning( const AClassName, ApplName : string) : Boolean');
 CL.AddDelphiFunction('Function IsDelphiRunning : boolean');
 CL.AddDelphiFunction('Function IsDelphiDesignMode : boolean');
 CL.AddDelphiFunction('Function AddFileExtIfNecessary( AFileName, AExt : string) : string');
 CL.AddDelphiFunction('Procedure WaitMiliSeconds( AMSec : word)');
 CL.AddDelphiFunction('Function BinaryToDouble( ABinary : string; DefValue : Double) : Double');
 CL.AddDelphiFunction('Function S_RoundDecimal( AValue : Extended; APlaces : Integer) : Extended');
 CL.AddDelphiFunction('Function S_LimitDigits( AValue : Extended; ANumDigits : Integer) : Extended');
 CL.AddDelphiFunction('Function S_StrCRC32( const Text : string) : LongWORD');
 CL.AddDelphiFunction('Function S_EncryptCRC32( const crc : LongWORD; StartKey, MultKey, AddKey : integer) : string');
 CL.AddDelphiFunction('Function S_DecryptCRC32( const crc : string; StartKey, MultKey, AddKey : integer) : integer');
 CL.AddDelphiFunction('Procedure S_GetEncryptionKeys( DateTime1, DateTime2 : TDateTime; var StartKey : integer; var MultKey : integer; var AddKey : integer)');
 CL.AddDelphiFunction('Function S_StrEncrypt96( const InString : string; StartKey, MultKey, AddKey : Integer) : string');
 CL.AddDelphiFunction('Function S_StrDecrypt96( const InString : string; StartKey, MultKey, AddKey : Integer) : string');
 CL.AddDelphiFunction('Function GetWindowsUserID : string');
 CL.AddDelphiFunction('Function GetWindowsComputerID : string');
 CL.AddDelphiFunction('Function GetEnvironmentVar( const AVariableName : string) : string');
 CL.AddDelphiFunction('Function S_DirExists( const ADir : string) : Boolean');
 CL.AddDelphiFunction('Function S_LargeFontsActive : Boolean');
 CL.AddTypeS('TS_ShellExecuteCmd', '( seCmdOpen, seCmdPrint, seCmdExplore )');
 CL.AddDelphiFunction('Function S_ShellExecute( aFilename : string; aParameters : string; aCommand : TS_ShellExecuteCmd) : string');
 CL.AddDelphiFunction('Function ShellExecute3( aFilename : string; aParameters : string; aCommand : TS_ShellExecuteCmd) : string');
 CL.AddDelphiFunction('function  GetResStringChecked(Ident: string; const Args: array of const): string');
 CL.AddDelphiFunction('Procedure OpenDirectory(adir: string);');
 CL.AddDelphiFunction('Procedure OpenDir(adir: string);');
  CL.AddDelphiFunction('function getVideoDrivers: string;');
  CL.AddDelphiFunction('function FormatByteSize(const bytes: int64): string;');
  CL.AddDelphiFunction('function countDirfiles(const apath: string): integer;');

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_gsUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@S_StrToReal, 'S_StrToReal', cdRegister);
 S.RegisterDelphiFunction(@S_RTrim, 'S_RTrim', cdRegister);
 S.RegisterDelphiFunction(@S_RTrimCopy, 'S_RTrimCopy', cdRegister);
 S.RegisterDelphiFunction(@S_LTrim, 'S_LTrim', cdRegister);
 S.RegisterDelphiFunction(@S_AllTrim, 'S_AllTrim', cdRegister);
 S.RegisterDelphiFunction(@S_Empty, 'S_Empty', cdRegister);
 S.RegisterDelphiFunction(@S_Cut, 'S_Cut', cdRegister);
 S.RegisterDelphiFunction(@S_AtRepl, 'S_AtRepl', cdRegister);
 S.RegisterDelphiFunction(@S_ReplFirst, 'S_ReplFirst', cdRegister);
 S.RegisterDelphiFunction(@S_Space, 'S_Space', cdRegister);
 S.RegisterDelphiFunction(@S_RepeatChar, 'S_RepeatChar', cdRegister);
 S.RegisterDelphiFunction(@S_ReplaceChar, 'S_ReplaceChar', cdRegister);
 S.RegisterDelphiFunction(@S_ReplaceStringInFile, 'S_ReplaceStringInFile', cdRegister);
 S.RegisterDelphiFunction(@S_StrBlanks, 'S_StrBlanks', cdRegister);
 S.RegisterDelphiFunction(@S_StrBlanksCuttooLong, 'S_StrBlanksCuttooLong', cdRegister);
 S.RegisterDelphiFunction(@S_StrLBlanks, 'S_StrLBlanks', cdRegister);
 S.RegisterDelphiFunction(@S_TokenInit, 'S_TokenInit', cdRegister);
 S.RegisterDelphiFunction(@S_TokenEnd, 'S_TokenEnd', cdRegister);
 S.RegisterDelphiFunction(@S_TokenNext, 'S_TokenNext', cdRegister);
 S.RegisterDelphiFunction(@S_AddBackSlash, 'S_AddBackSlash', cdRegister);
 S.RegisterDelphiFunction(@Buf2HexStr, 'Buf2HexStr', cdRegister);
 //S.RegisterDelphiFunction(@HexBuf2Str, 'HexBuf2Str', cdRegister);
 S.RegisterDelphiFunction(@LastPos, 'LastPos', cdRegister);
 S.RegisterDelphiFunction(@DelSpace, 'DelSpace', cdRegister);
 S.RegisterDelphiFunction(@DelChar, 'DelChar', cdRegister);
 S.RegisterDelphiFunction(@DelString, 'DelString', cdRegister);
 S.RegisterDelphiFunction(@DeleteString, 'DeleteString', cdRegister);
 S.RegisterDelphiFunction(@PadL, 'PadL', cdRegister);
 S.RegisterDelphiFunction(@PadR, 'PadR', cdRegister);
 S.RegisterDelphiFunction(@PadLCh, 'PadLCh', cdRegister);
 S.RegisterDelphiFunction(@PadRCh, 'PadRCh', cdRegister);
 S.RegisterDelphiFunction(@GetReadableName, 'GetReadableName', cdRegister);
 S.RegisterDelphiFunction(@GetNextDelimitedToken, 'GetNextDelimitedToken', cdRegister);
 S.RegisterDelphiFunction(@GetLastDelimitedToken, 'GetLastDelimitedToken', cdRegister);
 S.RegisterDelphiFunction(@GetFirstDelimitedToken, 'GetFirstDelimitedToken', cdRegister);
 S.RegisterDelphiFunction(@CompareTextLike, 'CompareTextLike', cdRegister);
 S.RegisterDelphiFunction(@MaskString, 'MaskString', cdRegister);
 S.RegisterDelphiFunction(@UnMaskString, 'UnMaskString', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatRegionalIndependent, 'StrToFloatRegionalIndependent', cdRegister);
 S.RegisterDelphiFunction(@S_UTF_8ToString, 'S_UTF_8ToString', cdRegister);
 S.RegisterDelphiFunction(@S_StringtoUTF_8, 'S_StringtoUTF_8', cdRegister);
 S.RegisterDelphiFunction(@S_ReadNextTextLineFromStream, 'S_ReadNextTextLineFromStream', cdRegister);
 S.RegisterDelphiFunction(@Stream2WideString, 'Stream2WideString', cdRegister);
 S.RegisterDelphiFunction(@WideString2Stream, 'WideString2Stream', cdRegister);
 S.RegisterDelphiFunction(@S_AddMessageToStrings, 'S_AddMessageToStrings', cdRegister);
 S.RegisterDelphiFunction(@BitmapsAreIdentical, 'BitmapsAreIdentical', cdRegister);
 S.RegisterDelphiFunction(@SimulateKeystroke, 'SimulateKeystroke', cdRegister);
 S.RegisterDelphiFunction(@GetApplicationsRunning, 'GetApplicationsRunning', cdRegister);
 S.RegisterDelphiFunction(@IsApplicationRunning, 'IsApplicationRunning', cdRegister);
 S.RegisterDelphiFunction(@IsDelphiRunning, 'IsDelphiRunning', cdRegister);
 S.RegisterDelphiFunction(@IsDelphiDesignMode, 'IsDelphiDesignMode', cdRegister);
 S.RegisterDelphiFunction(@AddFileExtIfNecessary, 'AddFileExtIfNecessary', cdRegister);
 S.RegisterDelphiFunction(@WaitMiliSeconds, 'WaitMiliSeconds', cdRegister);
 S.RegisterDelphiFunction(@BinaryToDouble, 'BinaryToDouble', cdRegister);
 S.RegisterDelphiFunction(@S_RoundDecimal, 'S_RoundDecimal', cdRegister);
 S.RegisterDelphiFunction(@S_LimitDigits, 'S_LimitDigits', cdRegister);
 S.RegisterDelphiFunction(@S_StrCRC32, 'S_StrCRC32', cdRegister);
 S.RegisterDelphiFunction(@S_EncryptCRC32, 'S_EncryptCRC32', cdRegister);
 S.RegisterDelphiFunction(@S_DecryptCRC32, 'S_DecryptCRC32', cdRegister);
 S.RegisterDelphiFunction(@S_GetEncryptionKeys, 'S_GetEncryptionKeys', cdRegister);
 S.RegisterDelphiFunction(@S_StrEncrypt96, 'S_StrEncrypt96', cdRegister);
 S.RegisterDelphiFunction(@S_StrDecrypt96, 'S_StrDecrypt96', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsUserID, 'GetWindowsUserID', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsComputerID, 'GetWindowsComputerID', cdRegister);
 S.RegisterDelphiFunction(@GetEnvironmentVar, 'GetEnvironmentVar', cdRegister);
 S.RegisterDelphiFunction(@S_DirExists, 'S_DirExists', cdRegister);
 S.RegisterDelphiFunction(@S_LargeFontsActive, 'S_LargeFontsActive', cdRegister);
 S.RegisterDelphiFunction(@S_ShellExecute, 'S_ShellExecute', cdRegister);
 S.RegisterDelphiFunction(@S_ShellExecute, 'ShellExecute3', cdRegister);
 S.RegisterDelphiFunction(@S_IBox, 'S_IBox', cdRegister);
 S.RegisterDelphiFunction(@S_EBox, 'S_EBox', cdRegister);
 S.RegisterDelphiFunction(@S_WBox, 'S_WBox', cdRegister);
 S.RegisterDelphiFunction(@GetResStringChecked, 'GetResStringChecked',cdRegister);
 S.RegisterDelphiFunction(@OpenDirectory, 'OpenDirectory', cdRegister);
 S.RegisterDelphiFunction(@OpenDirectory, 'OpenDir', cdRegister);
  S.RegisterDelphiFunction(@getVideoDrivers, 'getVideoDrivers', cdRegister);
 S.RegisterDelphiFunction(@FormatByteSize, 'FormatByteSize', cdRegister);
  S.RegisterDelphiFunction(@countDirfiles, 'countDirfiles', cdRegister);
end;



{ TPSImport_gsUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_gsUtils.CompOnUses(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_gsUtils.ExecOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_gsUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_gsUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_gsUtils.CompileImport2(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_gsUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_gsUtils(ri);
  RIRegister_gsUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_gsUtils.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  { nothing } 
end;
 
 
end.
