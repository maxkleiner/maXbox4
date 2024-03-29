unit uPSI_dwsXPlatform;
{
This file has been generated by UnitParser v0.7, written by M. Knight Kleiner
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility
    more list and date separator
    getusername definitive
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
  TPSImport_dwsXPlatform = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TdwsThread(CL: TPSPascalCompiler);
procedure SIRegister_TFile(CL: TPSPascalCompiler);
procedure SIRegister_TPath(CL: TPSPascalCompiler);
procedure SIRegister_TMultiReadSingleWrite(CL: TPSPascalCompiler);
procedure SIRegister_TFixedCriticalSection(CL: TPSPascalCompiler);
procedure SIRegister_dwsXPlatform(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TdwsThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPath(CL: TPSRuntimeClassImporter);
procedure RIRegister_dwsXPlatform_Routines(S: TPSExec);
procedure RIRegister_TMultiReadSingleWrite(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFixedCriticalSection(CL: TPSRuntimeClassImporter);
procedure RIRegister_dwsXPlatform(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Types
  ,Masks
  ,Windows
  ,dwsXPlatform
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_dwsXPlatform]);
end;

const
  cnMaxUserNameLen = 254;

function GetCurrentUserName : string;

var
  sUserName     : string;
  dwUserNameLen : DWord;
begin
  dwUserNameLen := cnMaxUserNameLen-1;
  SetLength( sUserName, cnMaxUserNameLen );
  GetUserName(PChar( sUserName ),dwUserNameLen );
  SetLength( sUserName, dwUserNameLen-1 );
  Result := sUserName;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TdwsThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TdwsThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TdwsThread') do
  begin
    RegisterMethod('Procedure Start');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TFile') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TFile') do
  begin
    RegisterMethod('Function ReadAllBytes( const filename : UnicodeString) : TBytes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPath(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPath') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPath') do
  begin
    RegisterMethod('Function GetTempFileName : UnicodeString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMultiReadSingleWrite(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMultiReadSingleWrite') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMultiReadSingleWrite') do begin
    RegisterMethod('Constructor Create( forceFallBack : Boolean)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure BeginRead');
    RegisterMethod('Procedure EndRead');
    RegisterMethod('Procedure BeginWrite');
    RegisterMethod('Procedure EndWrite');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFixedCriticalSection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TFixedCriticalSection') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TFixedCriticalSection') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Enter');
    RegisterMethod('Procedure Leave');
    RegisterMethod('Function TryEnter : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_dwsXPlatform(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('cLineTerminator','Char').SetString( #10);
 CL.AddConstantN('cLineTerminators','String').SetString( #13#10);
 CL.AddConstantN('INVALID_HANDLE_VALUE','LongInt').SetInt( DWORD ( - 1 ));
  SIRegister_TFixedCriticalSection(CL);
  SIRegister_TMultiReadSingleWrite(CL);
 CL.AddDelphiFunction('Procedure SetDecimalSeparator( c : Char)');
 CL.AddDelphiFunction('Function GetDecimalSeparator : Char');
 CL.AddDelphiFunction('Procedure SetDateSeparator( c : Char)');
 CL.AddDelphiFunction('Function GetDateSeparator : Char');
 CL.AddDelphiFunction('Procedure setTimeSeparator( c : Char)');
 CL.AddDelphiFunction('Function getTimeSeparator : Char');

 CL.AddDelphiFunction('Procedure setShortDateFormat( c : string)');
 CL.AddDelphiFunction('Function getShortDateFormat : string');
 CL.AddDelphiFunction('Procedure setlongDateFormat( c : string)');
 CL.AddDelphiFunction('Function getlongDateFormat : string');
 CL.AddDelphiFunction('Procedure setShorttimeFormat( c : string)');
 CL.AddDelphiFunction('Function getShorttimeFormat : string');
 CL.AddDelphiFunction('Procedure setlongtimeFormat( c : string)');
 CL.AddDelphiFunction('Function getlongtimeFormat : string');

 //getTimeSeparator
 CL.AddDelphiFunction('Procedure setThousandSeparator( c : Char)');
 CL.AddDelphiFunction('Function getThousandSeparator : Char');
 CL.AddDelphiFunction('Procedure setListSeparator( c : Char)');
 CL.AddDelphiFunction('Function getListSeparator : Char');

 CL.AddConstantN('LOGON32_LOGON_INTERACTIVE','LongInt').SetInt( 2);
 CL.AddConstantN('LOGON32_LOGON_NETWORK','LongInt').SetInt( 3);
 CL.AddConstantN('LOGON32_LOGON_BATCH','LongInt').SetInt( 4);
 CL.AddConstantN('LOGON32_LOGON_SERVICE','LongInt').SetInt( 5);
 CL.AddConstantN('LOGON32_PROVIDER_DEFAULT','LongInt').SetInt( 0);
 CL.AddConstantN('LOGON32_PROVIDER_WINNT35','LongInt').SetInt( 1);
 CL.AddConstantN('LOGON32_PROVIDER_WINNT40','LongInt').SetInt( 2);
 CL.AddConstantN('LOGON32_PROVIDER_WINNT50','LongInt').SetInt( 3);


  CL.AddTypeS('TCollectFileProgressEvent', 'Procedure ( const directory : String; var skipScan : Boolean)');
 CL.AddDelphiFunction('Procedure CollectFiles( const directory, fileMask : UnicodeString; list : TStrings; recurseSubdirectories : Boolean; onProgress : TCollectFileProgressEvent)');
  CL.AddTypeS('NativeInt', 'Integer');
  //CL.AddTypeS('PNativeInt', '^NativeInt // will not work');
  CL.AddTypeS('NativeUInt', 'Cardinal');
  //CL.AddTypeS('PNativeUInt', '^NativeUInt // will not work');
  //CL.AddTypeS('TBytes', 'array of Byte');
  CL.AddTypeS('RawByteString', 'UnicodeString');
  //CL.AddTypeS('PNativeInt', '^NativeInt // will not work');
  //CL.AddTypeS('PUInt64', '^UInt64 // will not work');
  SIRegister_TPath(CL);
  SIRegister_TFile(CL);
  SIRegister_TdwsThread(CL);
 CL.AddDelphiFunction('Function GetSystemMilliseconds : Int64');
 CL.AddDelphiFunction('Function UTCDateTime : TDateTime');
 CL.AddDelphiFunction('Function UnicodeFormat( const fmt : UnicodeString; const args : array of const) : UnicodeString');
 CL.AddDelphiFunction('Function UnicodeCompareStr( const S1, S2 : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function dwsAnsiCompareText( const S1, S2 : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function dwsAnsiCompareStr( const S1, S2 : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function UnicodeComparePChars( p1 : PChar; n1 : Integer; p2 : PChar; n2 : Integer) : Integer;');
 CL.AddDelphiFunction('Function UnicodeComparePChars1( p1, p2 : PChar; n : Integer) : Integer;');
 CL.AddDelphiFunction('Function UnicodeLowerCase( const s : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function UnicodeUpperCase( const s : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Function ASCIICompareText( const s1, s2 : UnicodeString) : Integer');
 CL.AddDelphiFunction('Function ASCIISameText( const s1, s2 : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function InterlockedIncrement( var val : Integer) : Integer');
 CL.AddDelphiFunction('Function InterlockedDecrement( var val : Integer) : Integer');
 CL.AddDelphiFunction('Procedure FastInterlockedIncrement( var val : Integer)');
 CL.AddDelphiFunction('Procedure FastInterlockedDecrement( var val : Integer)');
 CL.AddDelphiFunction('Function InterlockedExchangePointer( var target : ___Pointer; val : ___Pointer) : ___Pointer');
 CL.AddDelphiFunction('Procedure SetThreadName( const threadName : Char; threadID : Cardinal)');
 CL.AddDelphiFunction('Procedure dwsOutputDebugString( const msg : UnicodeString)');
 CL.AddDelphiFunction('Procedure WriteToOSEventLog( const logName, logCaption, logDetails : UnicodeString; const logRawData : RawByteString);');
 CL.AddDelphiFunction('Function TryTextToFloat( const s : PChar; var value : Extended; const formatSettings : TFormatSettings) : Boolean');
 CL.AddDelphiFunction('Procedure VarCopy( out dest : Variant; const src : Variant)');
 CL.AddDelphiFunction('Function VarToUnicodeStr( const v : Variant) : UnicodeString');
 CL.AddDelphiFunction('Function LoadTextFromBuffer( const buf : TBytes) : UnicodeString');
 CL.AddDelphiFunction('Function LoadTextFromStream( aStream : TStream) : UnicodeString');
 CL.AddDelphiFunction('Function LoadTextFromFile( const fileName : UnicodeString) : UnicodeString');
 CL.AddDelphiFunction('Procedure SaveTextToUTF8File( const fileName, text : UnicodeString)');
 CL.AddDelphiFunction('Function OpenFileForSequentialReadOnly( const fileName : UnicodeString) : THandle');
 CL.AddDelphiFunction('Function OpenFileHandle( const fileName : UnicodeString) : THandle');
 CL.AddDelphiFunction('Function GetUserNameAPI( lpBuffer : PChar; var nSize : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SetComputerName( lpComputerName : PChar) : BOOL');
 CL.AddDelphiFunction('Function GetCurrentUserName: string');


 CL.AddDelphiFunction('Function OpenFileForSequentialWriteOnly( const fileName : UnicodeString) : THandle');
 CL.AddDelphiFunction('Procedure CloseFileHandle( hFile : THandle)');
 CL.AddDelphiFunction('Function FileCopy( const existing, new : UnicodeString; failIfExists : Boolean) : Boolean');
 CL.AddDelphiFunction('Function FileMove( const existing, new : UnicodeString) : Boolean');
 CL.AddDelphiFunction('Function dwsFileDelete( const fileName : String) : Boolean');
 CL.AddDelphiFunction('Function FileRename( const oldName, newName : String) : Boolean');
 CL.AddDelphiFunction('Function dwsFileSize( const name : String) : Int64');
 CL.AddDelphiFunction('Function dwsFileDateTime( const name : String) : TDateTime');
 CL.AddDelphiFunction('Function DirectSet8087CW( newValue : Word) : Word');
 CL.AddDelphiFunction('Function DirectSetMXCSR( newValue : Word) : Word');
 CL.AddDelphiFunction('Function TtoObject( const T: byte) : TObject');
 CL.AddDelphiFunction('Function TtoPointer( const T: byte) : ___Pointer');
 CL.AddDelphiFunction('Procedure GetMemForT(var T: byte; Size : integer)');
 CL.AddDelphiFunction('Function FindDelimiter( const Delimiters, S : string; StartIdx : Integer) : Integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure WriteToOSEventLog_P( const logName, logCaption, logDetails : UnicodeString; const logRawData : String);
Begin dwsXPlatform.WriteToOSEventLog(logName, logCaption, logDetails, logRawData); END;

(*----------------------------------------------------------------------------*)
Function UnicodeComparePChars1_P( p1, p2 : PWideChar; n : Integer) : Integer;
Begin Result := dwsXPlatform.UnicodeComparePChars(p1, p2, n); END;

(*----------------------------------------------------------------------------*)
Function UnicodeComparePChars_P( p1 : PWideChar; n1 : Integer; p2 : PWideChar; n2 : Integer) : Integer;
Begin Result := dwsXPlatform.UnicodeComparePChars(p1, n1, p2, n2); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TdwsThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TdwsThread) do
  begin
    //RegisterMethod(@TdwsThread.Start, 'Start');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFile) do
  begin
    RegisterMethod(@TFile.ReadAllBytes, 'ReadAllBytes');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPath(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPath) do
  begin
    RegisterMethod(@TPath.GetTempFileName, 'GetTempFileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_dwsXPlatform_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetDecimalSeparator, 'SetDecimalSeparator', cdRegister);
 S.RegisterDelphiFunction(@GetDecimalSeparator, 'GetDecimalSeparator', cdRegister);
 S.RegisterDelphiFunction(@SetDateSeparator, 'SetDateSeparator', cdRegister);
 S.RegisterDelphiFunction(@GetDateSeparator, 'GetDateSeparator', cdRegister);
 S.RegisterDelphiFunction(@SetTimeSeparator, 'SetTimeSeparator', cdRegister);
 S.RegisterDelphiFunction(@GetTimeSeparator, 'GetTimeSeparator', cdRegister);
 S.RegisterDelphiFunction(@SetThousandSeparator, 'SetThousandSeparator', cdRegister);
 S.RegisterDelphiFunction(@GetThousandSeparator, 'GetThousandSeparator', cdRegister);
 S.RegisterDelphiFunction(@SetListSeparator, 'SetListSeparator', cdRegister);
 S.RegisterDelphiFunction(@GetListSeparator, 'GetListSeparator', cdRegister);

  S.RegisterDelphiFunction(@setShortDateFormat, 'setShortDateFormat', cdRegister);
 S.RegisterDelphiFunction(@getShortDateFormat, 'getShortDateFormat', cdRegister);
 S.RegisterDelphiFunction(@setlongDateFormat, 'setlongDateFormat', cdRegister);
 S.RegisterDelphiFunction(@getlongDateFormat, 'getlongDateFormat', cdRegister);
 S.RegisterDelphiFunction(@setShorttimeFormat, 'setShorttimeFormat', cdRegister);
 S.RegisterDelphiFunction(@getShorttimeFormat, 'getShorttimeFormat', cdRegister);
 S.RegisterDelphiFunction(@setlongtimeFormat, 'setlongtimeFormat', cdRegister);
 S.RegisterDelphiFunction(@getlongtimeFormat, 'getlongtimeFormat', cdRegister);

 { CL.AddDelphiFunction('Procedure setShortDateFormat( c : string)');
 CL.AddDelphiFunction('Function getShortDateFormat : string');
 CL.AddDelphiFunction('Procedure setlongDateFormat( c : string)');
 CL.AddDelphiFunction('Function getlongDateFormat : string');
 CL.AddDelphiFunction('Procedure setShorttimeFormat( c : string)');
 CL.AddDelphiFunction('Function getShorttimeFormat : string');
 CL.AddDelphiFunction('Procedure setlongtimeFormat( c : string)');
 CL.AddDelphiFunction('Function getlongtimeFormat : string');
  }

 S.RegisterDelphiFunction(@CollectFiles, 'CollectFiles', cdRegister);
 // RIRegister_TPath(CL);
  //RIRegister_TFile(CL);
  //RIRegister_TdwsThread(CL);
 S.RegisterDelphiFunction(@GetSystemMilliseconds, 'GetSystemMilliseconds', cdRegister);
 S.RegisterDelphiFunction(@UTCDateTime, 'UTCDateTime', cdRegister);
 S.RegisterDelphiFunction(@UnicodeFormat, 'UnicodeFormat', cdRegister);
 S.RegisterDelphiFunction(@UnicodeCompareStr, 'UnicodeCompareStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareText, 'dwsAnsiCompareText', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareStr, 'dwsAnsiCompareStr', cdRegister);
 S.RegisterDelphiFunction(@UnicodeComparePChars, 'UnicodeComparePChars', cdRegister);
 //S.RegisterDelphiFunction(@UnicodeComparePChars1, 'UnicodeComparePChars1', cdRegister);
 S.RegisterDelphiFunction(@UnicodeLowerCase, 'UnicodeLowerCase', cdRegister);
 S.RegisterDelphiFunction(@UnicodeUpperCase, 'UnicodeUpperCase', cdRegister);
 S.RegisterDelphiFunction(@ASCIICompareText, 'ASCIICompareText', cdRegister);
 S.RegisterDelphiFunction(@ASCIISameText, 'ASCIISameText', cdRegister);
 S.RegisterDelphiFunction(@InterlockedIncrement, 'InterlockedIncrement', cdRegister);
 S.RegisterDelphiFunction(@InterlockedDecrement, 'InterlockedDecrement', cdRegister);
 S.RegisterDelphiFunction(@FastInterlockedIncrement, 'FastInterlockedIncrement', cdRegister);
 S.RegisterDelphiFunction(@FastInterlockedDecrement, 'FastInterlockedDecrement', cdRegister);
 S.RegisterDelphiFunction(@InterlockedExchangePointer, 'InterlockedExchangePointer', cdRegister);
 S.RegisterDelphiFunction(@SetThreadName, 'SetThreadName', cdRegister);
 S.RegisterDelphiFunction(@OutputDebugString, 'dwsOutputDebugString', cdRegister);
 S.RegisterDelphiFunction(@WriteToOSEventLog, 'WriteToOSEventLog', cdRegister);
 S.RegisterDelphiFunction(@TryTextToFloat, 'TryTextToFloat', cdRegister);
 //((S.RegisterDelphiFunction(@VarCopy, 'VarCopy', cdRegister);
 S.RegisterDelphiFunction(@VarToUnicodeStr, 'VarToUnicodeStr', cdRegister);
 S.RegisterDelphiFunction(@LoadTextFromBuffer, 'LoadTextFromBuffer', cdRegister);
 S.RegisterDelphiFunction(@LoadTextFromStream, 'LoadTextFromStream', cdRegister);
 S.RegisterDelphiFunction(@LoadTextFromFile, 'LoadTextFromFile', cdRegister);
 S.RegisterDelphiFunction(@SaveTextToUTF8File, 'SaveTextToUTF8File', cdRegister);
 S.RegisterDelphiFunction(@OpenFileForSequentialReadOnly, 'OpenFileForSequentialReadOnly', cdRegister);
 S.RegisterDelphiFunction(@OpenFileForSequentialReadOnly, 'OpenFileHandle', cdRegister);
 S.RegisterDelphiFunction(@GetUserNameA, 'GetUserNameAPI', CdStdCall);
  S.RegisterDelphiFunction(@SetComputerName, 'SetComputerName', CdStdCall);
  S.RegisterDelphiFunction(@GetCurrentUserName, 'GetCurrentUserName', cdRegister);


 S.RegisterDelphiFunction(@OpenFileForSequentialWriteOnly, 'OpenFileForSequentialWriteOnly', cdRegister);
 S.RegisterDelphiFunction(@CloseFileHandle, 'CloseFileHandle', cdRegister);
 S.RegisterDelphiFunction(@FileCopy, 'FileCopy', cdRegister);
 S.RegisterDelphiFunction(@FileMove, 'FileMove', cdRegister);
 S.RegisterDelphiFunction(@FileDelete, 'dwsFileDelete', cdRegister);
 S.RegisterDelphiFunction(@FileRename, 'FileRename', cdRegister);
 S.RegisterDelphiFunction(@FileSize, 'dwsFileSize', cdRegister);
 S.RegisterDelphiFunction(@FileDateTime, 'dwsFileDateTime', cdRegister);
 S.RegisterDelphiFunction(@DirectSet8087CW, 'DirectSet8087CW', cdRegister);
 S.RegisterDelphiFunction(@DirectSetMXCSR, 'DirectSetMXCSR', cdRegister);
 S.RegisterDelphiFunction(@TtoObject, 'TtoObject', cdRegister);
 S.RegisterDelphiFunction(@TtoPointer, 'TtoPointer', cdRegister);
 S.RegisterDelphiFunction(@GetMemForT, 'GetMemForT', cdRegister);
 S.RegisterDelphiFunction(@FindDelimiter, 'FindDelimiter', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMultiReadSingleWrite(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMultiReadSingleWrite) do begin
    RegisterConstructor(@TMultiReadSingleWrite.Create, 'Create');
      RegisterMethod(@TMultiReadSingleWrite.Destroy, 'Free');
      RegisterMethod(@TMultiReadSingleWrite.BeginRead, 'BeginRead');
    RegisterMethod(@TMultiReadSingleWrite.EndRead, 'EndRead');
    RegisterMethod(@TMultiReadSingleWrite.BeginWrite, 'BeginWrite');
    RegisterMethod(@TMultiReadSingleWrite.EndWrite, 'EndWrite');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFixedCriticalSection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFixedCriticalSection) do begin
    RegisterConstructor(@TFixedCriticalSection.Create, 'Create');
    RegisterMethod(@TFixedCriticalSection.Destroy, 'Free');
     RegisterMethod(@TFixedCriticalSection.Enter, 'Enter');
    RegisterMethod(@TFixedCriticalSection.Leave, 'Leave');
    RegisterMethod(@TFixedCriticalSection.TryEnter, 'TryEnter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_dwsXPlatform(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFixedCriticalSection(CL);
  RIRegister_TMultiReadSingleWrite(CL);
   RIRegister_TPath(CL);
  RIRegister_TFile(CL);

end;

 
 
{ TPSImport_dwsXPlatform }
(*----------------------------------------------------------------------------*)
procedure TPSImport_dwsXPlatform.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_dwsXPlatform(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_dwsXPlatform.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_dwsXPlatform(ri);
  RIRegister_dwsXPlatform_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
