unit IFSI_IdGlobalProtocols;
{
This file has been generated by UnitParser v0.6, written by M. Knight
and updated by NP. v/d Spek.
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok''s conv unility

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
  TPSImport_IdGlobalProtocols = class(TPSPlugin)
  protected
    procedure CompOnUses(CompExec: TPSScript); override;
    procedure ExecOnUses(CompExec: TPSScript); override;
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure CompileImport2(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
    procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
(*
{ compile-time registration functions }
procedure SIRegister_TIdInterfacedObject(CL: TPSPascalCompiler);
procedure SIRegister_TIdMimeTable(CL: TPSPascalCompiler);
procedure SIRegister_IdGlobalProtocols(CL: TPSPascalCompiler);
 
{ run-time registration functions }
procedure RIRegister_IdGlobalProtocols_Routines(S: TPSExec);
procedure RIRegister_TIdInterfacedObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMimeTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdGlobalProtocols(CL: TPSRuntimeClassImporter);
*)


implementation


uses
   Windows
  ,IdCharsets
  ,IdBaseComponent
  ,IdGlobal
  ,IdException
  ,IdObjs
  ,IdSys
  ,IdGlobalProtocols
  ;
 
 
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
  
  
(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdInterfacedObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TIdInterfacedObject') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TIdInterfacedObject') do
  begin
    RegisterMethod('Function _AddRef : Integer');
    RegisterMethod('Function _Release : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMimeTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdMimeTable') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdMimeTable') do
  begin
    RegisterProperty('LoadTypesFromOS', 'Boolean', iptrw);
    RegisterMethod('Procedure BuildCache');
    RegisterMethod('Procedure AddMimeType( const Ext, MIMEType : string)');
    RegisterMethod('Function GetFileMIMEType( const AFileName : string) : string');
    RegisterMethod('Function GetDefaultFileExt( const MIMEType : string) : string');
    RegisterMethod('Procedure LoadFromStrings( const AStrings : TIdStrings; const MimeSeparator : Char)');
    RegisterMethod('Procedure SaveToStrings( const AStrings : TIdStrings; const MimeSeparator : Char)');
    RegisterMethod('Constructor Create( const AutoFill : Boolean)');
    RegisterProperty('OnBuildCache', 'TIdNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdGlobalProtocols(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdFileName', 'WideString');
  CL.AddTypeS('TIdFileName', 'String');
  CL.AddTypeS('TIdReadLnFunction', 'Function  : string');
  SIRegister_TIdMimeTable(CL);
  SIRegister_TIdInterfacedObject(CL);
  CL.AddTypeS('PByte', '^Byte // will not work');
  CL.AddTypeS('PWord', '^Word // will not work');
  CL.AddTypeS('TIdWin32Type', '( Win32s, WindowsNT40PreSP6Workstation, WindowsN'
   +'T40PreSP6Server, WindowsNT40PreSP6AdvancedServer, WindowsNT40Workstation, '
   +'WindowsNT40Server, WindowsNT40AdvancedServer, Windows95, Windows95OSR2, Wi'
   +'ndows98, Windows98SE, Windows2000Pro, Windows2000Server, Windows2000Advanc'
   +'edServer, WindowsMe, WindowsXPPro, Windows2003Server, Windows2003AdvancedS'
   +'erver )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdFailedToRetreiveTimeZoneInfo');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdExtensionAlreadyExists');
 CL.AddDelphiFunction('Function ABNFToText( const AText : String) : String');
 CL.AddDelphiFunction('Function BinStrToInt( const ABinary : String) : Integer');
 CL.AddDelphiFunction('Function BreakApart( BaseString, BreakString : string; StringList : TIdStrings) : TIdStrings');
 CL.AddDelphiFunction('Function LongWordToFourChar( ACardinal : LongWord) : string');
 CL.AddDelphiFunction('Function CharRange( const AMin, AMax : Char) : String');
 CL.AddDelphiFunction('Function CharToHex( const APrefix : String; const c : AnsiChar) : shortstring');
 CL.AddDelphiFunction('Procedure CommaSeparatedToStringList( AList : TIdStrings; const Value : string)');
 CL.AddDelphiFunction('Function CompareDateTime( const ADateTime1, ADateTime2 : TIdDateTime) : Integer');
 CL.AddDelphiFunction('Procedure CopyBytesToHostLongWord( const ASource : TIdBytes; const ASourceIndex : Integer; var VDest : LongWord)');
 CL.AddDelphiFunction('Procedure CopyBytesToHostWord( const ASource : TIdBytes; const ASourceIndex : Integer; var VDest : Word)');
 CL.AddDelphiFunction('Procedure CopyTIdNetworkLongWord( const ASource : LongWord; var VDest : TIdBytes; const ADestIndex : Integer)');
 CL.AddDelphiFunction('Procedure CopyTIdNetworkWord( const ASource : Word; var VDest : TIdBytes; const ADestIndex : Integer)');
 CL.AddDelphiFunction('Function CopyFileTo( const Source, Destination : TIdFileName) : Boolean');
 CL.AddDelphiFunction('Function DomainName( const AHost : String) : String');
 CL.AddDelphiFunction('Function EnsureMsgIDBrackets( const AMsgID : String) : String');
 CL.AddDelphiFunction('Function FileSizeByName( const AFilename : TIdFileName) : Int64');
 CL.AddDelphiFunction('Function FTPMLSToGMTDateTime( const ATimeStamp : String) : TIdDateTime');
 CL.AddDelphiFunction('Function FTPMLSToLocalDateTime( const ATimeStamp : String) : TIdDateTime');
 CL.AddDelphiFunction('Function FTPGMTDateTimeToMLS( const ATimeStamp : TIdDateTime; const AIncludeMSecs : Boolean) : String');
 CL.AddDelphiFunction('Function FTPLocalDateTimeToMLS( const ATimeStamp : TIdDateTime; const AIncludeMSecs : Boolean) : String');
 CL.AddDelphiFunction('Function GetClockValue : Int64');
 CL.AddDelphiFunction('Function GetMIMETypeFromFile( const AFile : TIdFileName) : string');
 CL.AddDelphiFunction('Function GetMIMEDefaultFileExt( const MIMEType : string) : TIdFileName');
 CL.AddDelphiFunction('Function GetGMTDateByName( const AFileName : TIdFileName) : TIdDateTime');
 CL.AddDelphiFunction('Function GmtOffsetStrToDateTime( S : string) : TIdDateTime');
 CL.AddDelphiFunction('Function GMTToLocalDateTime( S : string) : TIdDateTime');
 CL.AddDelphiFunction('Function IdGetDefaultCharSet : TIdCharSet');
 CL.AddDelphiFunction('Function IntToBin( Value : cardinal) : string');
 CL.AddDelphiFunction('Function IndyComputerName : String');
 CL.AddDelphiFunction('Function IndyStrToBool( const AString : String) : Boolean');
 CL.AddDelphiFunction('Function IsDomain( const S : String) : Boolean');
 CL.AddDelphiFunction('Function IsFQDN( const S : String) : Boolean');
 CL.AddDelphiFunction('Function IsBinary( const AChar : Char) : Boolean');
 CL.AddDelphiFunction('Function IsHex( const AChar : Char) : Boolean');
 CL.AddDelphiFunction('Function IsHostname( const S : String) : Boolean');
 CL.AddDelphiFunction('Function IsLeadChar( ACh : Char) : Boolean');
 CL.AddDelphiFunction('Function IsTopDomain( const AStr : string) : Boolean');
 CL.AddDelphiFunction('Function IsValidIP( const S : String) : Boolean');
 CL.AddDelphiFunction('Function Max( AValueOne, AValueTwo : Integer) : Integer');
 CL.AddDelphiFunction('Function MakeTempFilename( const APath : String) : string');
 CL.AddDelphiFunction('Procedure MoveChars( const ASource : ShortString; ASourceStart : integer; var ADest : ShortString; ADestStart, ALen : integer)');
 CL.AddDelphiFunction('Function OrdFourByteToLongWord( AByte1, AByte2, AByte3, AByte4 : Byte) : LongWord');
 CL.AddDelphiFunction('Function PadString( const AString : String; const ALen : Integer; const AChar : Char) : String');
 CL.AddDelphiFunction('Function ProcessPath( const ABasePath : String; const APath : String; const APathDelim : string) : string');
 CL.AddDelphiFunction('Function RightStr( const AStr : String; const Len : Integer) : String');
 CL.AddDelphiFunction('Function ROL( AVal : LongWord; AShift : Byte) : LongWord');
 CL.AddDelphiFunction('Function ROR( AVal : LongWord; AShift : Byte) : LongWord');
 CL.AddDelphiFunction('Function RPos( const ASub, AIn : String; AStart : Integer) : Integer');
 CL.AddDelphiFunction('Function SetLocalTime( Value : TIdDateTime) : boolean');
 CL.AddDelphiFunction('Function StartsWith( const ANSIStr, APattern : String) : Boolean');
 CL.AddDelphiFunction('Function StrToCard( const AStr : String) : Cardinal');
 CL.AddDelphiFunction('Function StrInternetToDateTime( Value : string) : TIdDateTime');
 CL.AddDelphiFunction('Function StrToDay( const ADay : string) : Byte');
 CL.AddDelphiFunction('Function StrToMonth( const AMonth : string) : Byte');
 CL.AddDelphiFunction('Function StrToWord( const Value : String) : Word');
 CL.AddDelphiFunction('Function TimeZoneBias : TIdDateTime');
 CL.AddDelphiFunction('Function UnixDateTimeToDelphiDateTime( UnixDateTime : Cardinal) : TIdDateTime');
 CL.AddDelphiFunction('Function DateTimeToUnix( ADateTime : TIdDateTime) : Cardinal');
 CL.AddDelphiFunction('Function TwoCharToWord( AChar1, AChar2 : Char) : Word');
 CL.AddDelphiFunction('Function UpCaseFirst( const AStr : string) : string');
 CL.AddDelphiFunction('Function UpCaseFirstWord( const AStr : string) : string');
 CL.AddDelphiFunction('Function GetUniqueFileName( const APath, APrefix, AExt : String) : String');
 CL.AddDelphiFunction('Function Win32Type : TIdWin32Type');
 CL.AddDelphiFunction('Procedure WordToTwoBytes( AWord : Word; ByteArray : TIdBytes; Index : integer)');
 CL.AddDelphiFunction('Function WordToStr( const Value : Word) : String');
 CL.AddDelphiFunction('Function WrapText( const ALine, ABreakStr, ABreakChars : string; MaxCol : Integer) : string');
 CL.AddDelphiFunction('Function RemoveHeaderEntry( AHeader, AEntry : string) : string');
 CL.AddConstantN('UNIXSTARTDATE','TIdDateTime').SetString( 25569.0);
 CL.AddConstantN('TIME_BASEDATE','LongInt').SetInt( 2);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdMimeTableOnBuildCache_W(Self: TIdMimeTable; const T: TIdNotifyEvent);
begin Self.OnBuildCache := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMimeTableOnBuildCache_R(Self: TIdMimeTable; var T: TIdNotifyEvent);
begin T := Self.OnBuildCache; end;

(*----------------------------------------------------------------------------*)
procedure TIdMimeTableLoadTypesFromOS_W(Self: TIdMimeTable; const T: Boolean);
begin Self.LoadTypesFromOS := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMimeTableLoadTypesFromOS_R(Self: TIdMimeTable; var T: Boolean);
begin T := Self.LoadTypesFromOS; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdGlobalProtocols_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ABNFToText, 'ABNFToText', cdRegister);
 S.RegisterDelphiFunction(@BinStrToInt, 'BinStrToInt', cdRegister);
 S.RegisterDelphiFunction(@BreakApart, 'BreakApart', cdRegister);
 S.RegisterDelphiFunction(@LongWordToFourChar, 'LongWordToFourChar', cdRegister);
 S.RegisterDelphiFunction(@CharRange, 'CharRange', cdRegister);
 S.RegisterDelphiFunction(@CharToHex, 'CharToHex', cdRegister);
 //S.RegisterDelphiFunction(@CommaSeparatedToStringList, 'CommaSeparatedToStringList', cdRegister);
 S.RegisterDelphiFunction(@CompareDateTime, 'CompareDateTime', cdRegister);
 S.RegisterDelphiFunction(@CopyBytesToHostLongWord, 'CopyBytesToHostLongWord', cdRegister);
 S.RegisterDelphiFunction(@CopyBytesToHostWord, 'CopyBytesToHostWord', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdNetworkLongWord, 'CopyTIdNetworkLongWord', cdRegister);
 S.RegisterDelphiFunction(@CopyTIdNetworkWord, 'CopyTIdNetworkWord', cdRegister);
 S.RegisterDelphiFunction(@CopyFileTo, 'CopyFileTo', cdRegister);
 S.RegisterDelphiFunction(@DomainName, 'DomainName', cdRegister);
 S.RegisterDelphiFunction(@EnsureMsgIDBrackets, 'EnsureMsgIDBrackets', cdRegister);
 S.RegisterDelphiFunction(@FileSizeByName, 'FileSizeByName', cdRegister);
 S.RegisterDelphiFunction(@FTPMLSToGMTDateTime, 'FTPMLSToGMTDateTime', cdRegister);
 S.RegisterDelphiFunction(@FTPMLSToLocalDateTime, 'FTPMLSToLocalDateTime', cdRegister);
 S.RegisterDelphiFunction(@FTPGMTDateTimeToMLS, 'FTPGMTDateTimeToMLS', cdRegister);
 S.RegisterDelphiFunction(@FTPLocalDateTimeToMLS, 'FTPLocalDateTimeToMLS', cdRegister);
 S.RegisterDelphiFunction(@GetClockValue, 'GetClockValue', cdRegister);
 S.RegisterDelphiFunction(@GetMIMETypeFromFile, 'GetMIMETypeFromFile', cdRegister);

 S.RegisterDelphiFunction(@GetMIMEDefaultFileExt, 'GetMIMEDefaultFileExt', cdRegister);
 S.RegisterDelphiFunction(@GetGMTDateByName, 'GetGMTDateByName', cdRegister);
 S.RegisterDelphiFunction(@GmtOffsetStrToDateTime, 'GmtOffsetStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@GMTToLocalDateTime, 'GMTToLocalDateTime', cdRegister);
 S.RegisterDelphiFunction(@IdGetDefaultCharSet, 'IdGetDefaultCharSet', cdRegister);
 S.RegisterDelphiFunction(@IntToBin, 'IntToBin', cdRegister);
 S.RegisterDelphiFunction(@IndyComputerName, 'IndyComputerName', cdRegister);
 S.RegisterDelphiFunction(@IndyStrToBool, 'IndyStrToBool', cdRegister);
 S.RegisterDelphiFunction(@IsDomain, 'IsDomain', cdRegister);
 S.RegisterDelphiFunction(@IsFQDN, 'IsFQDN', cdRegister);
 S.RegisterDelphiFunction(@IsBinary, 'IsBinary', cdRegister);
 S.RegisterDelphiFunction(@IsHex, 'IsHex', cdRegister);
 S.RegisterDelphiFunction(@IsHostname, 'IsHostname', cdRegister);
 S.RegisterDelphiFunction(@IsLeadChar, 'IsLeadChar', cdRegister);
 S.RegisterDelphiFunction(@IsTopDomain, 'IsTopDomain', cdRegister);
 S.RegisterDelphiFunction(@IsValidIP, 'IsValidIP', cdRegister);
 S.RegisterDelphiFunction(@Max, 'Max', cdRegister);
 S.RegisterDelphiFunction(@MakeTempFilename, 'MakeTempFilename', cdRegister);
 S.RegisterDelphiFunction(@MoveChars, 'MoveChars', cdRegister);
 S.RegisterDelphiFunction(@OrdFourByteToLongWord, 'OrdFourByteToLongWord', cdRegister);
 S.RegisterDelphiFunction(@PadString, 'PadString', cdRegister);
 S.RegisterDelphiFunction(@ProcessPath, 'ProcessPath', cdRegister);
 S.RegisterDelphiFunction(@RightStr, 'RightStr', cdRegister);
 S.RegisterDelphiFunction(@ROL, 'ROL', cdRegister);
 S.RegisterDelphiFunction(@ROR, 'ROR', cdRegister);
 S.RegisterDelphiFunction(@RPos, 'RPos', cdRegister);
 S.RegisterDelphiFunction(@SetLocalTime, 'SetLocalTime', cdRegister);
 S.RegisterDelphiFunction(@StartsWith, 'StartsWith', cdRegister);
 S.RegisterDelphiFunction(@StrToCard, 'StrToCard', cdRegister);
 S.RegisterDelphiFunction(@StrInternetToDateTime, 'StrInternetToDateTime', cdRegister);
 S.RegisterDelphiFunction(@StrToDay, 'StrToDay', cdRegister);
 S.RegisterDelphiFunction(@StrToMonth, 'StrToMonth', cdRegister);
 S.RegisterDelphiFunction(@StrToWord, 'StrToWord', cdRegister);
 S.RegisterDelphiFunction(@TimeZoneBias, 'TimeZoneBias', cdRegister);
 S.RegisterDelphiFunction(@UnixDateTimeToDelphiDateTime, 'UnixDateTimeToDelphiDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToUnix, 'DateTimeToUnix', cdRegister);
 S.RegisterDelphiFunction(@TwoCharToWord, 'TwoCharToWord', cdRegister);
 S.RegisterDelphiFunction(@UpCaseFirst, 'UpCaseFirst', cdRegister);
 S.RegisterDelphiFunction(@UpCaseFirstWord, 'UpCaseFirstWord', cdRegister);
 S.RegisterDelphiFunction(@GetUniqueFileName, 'GetUniqueFileName', cdRegister);
 S.RegisterDelphiFunction(@Win32Type, 'Win32Type', cdRegister);
 S.RegisterDelphiFunction(@WordToTwoBytes, 'WordToTwoBytes', cdRegister);
 S.RegisterDelphiFunction(@WordToStr, 'WordToStr', cdRegister);
 S.RegisterDelphiFunction(@WrapText, 'WrapText', cdRegister);
 S.RegisterDelphiFunction(@RemoveHeaderEntry, 'RemoveHeaderEntry', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdInterfacedObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdInterfacedObject) do
  begin
    RegisterMethod(@TIdInterfacedObject._AddRef, '_AddRef');
    RegisterMethod(@TIdInterfacedObject._Release, '_Release');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMimeTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMimeTable) do begin
    RegisterPropertyHelper(@TIdMimeTableLoadTypesFromOS_R,@TIdMimeTableLoadTypesFromOS_W,'LoadTypesFromOS');
    RegisterVirtualMethod(@TIdMimeTable.BuildCache, 'BuildCache');
    RegisterMethod(@TIdMimeTable.AddMimeType, 'AddMimeType');
    RegisterMethod(@TIdMimeTable.GetFileMIMEType, 'GetFileMIMEType');
    RegisterMethod(@TIdMimeTable.GetDefaultFileExt, 'GetDefaultFileExt');
    RegisterMethod(@TIdMimeTable.LoadFromStrings, 'LoadFromStrings');
    RegisterMethod(@TIdMimeTable.SaveToStrings, 'SaveToStrings');
    RegisterConstructor(@TIdMimeTable.Create, 'Create');
    RegisterPropertyHelper(@TIdMimeTableOnBuildCache_R,@TIdMimeTableOnBuildCache_W,'OnBuildCache');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdGlobalProtocols(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdMimeTable(CL);
  RIRegister_TIdInterfacedObject(CL);
  with CL.Add(EIdFailedToRetreiveTimeZoneInfo) do
  with CL.Add(EIdExtensionAlreadyExists) do
end;

 
 
{ TPSImport_IdGlobalProtocols }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGlobalProtocols.CompOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGlobalProtocols.ExecOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGlobalProtocols.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdGlobalProtocols(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGlobalProtocols.CompileImport2(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGlobalProtocols.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdGlobalProtocols(ri);
  RIRegister_IdGlobalProtocols_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdGlobalProtocols.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  { nothing } 
end;
 
 
end.
