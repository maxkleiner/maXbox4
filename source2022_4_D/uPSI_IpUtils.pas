unit uPSI_IpUtils;
{
   of lazarus change to iputils2.pas  from turbo power
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
  TPSImport_IpUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIpBaseWinControl(CL: TPSPascalCompiler);
procedure SIRegister_TIpBaseComponent(CL: TPSPascalCompiler);
procedure SIRegister_TIpBasePersistent(CL: TPSPascalCompiler);
procedure SIRegister_TIpBaseAccess(CL: TPSPascalCompiler);
procedure SIRegister_IpUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IpUtils_Routines(S: TPSExec);
procedure RIRegister_TIpBaseWinControl(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIpBaseComponent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIpBasePersistent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIpBaseAccess(CL: TPSRuntimeClassImporter);
procedure RIRegister_IpUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { LCLType
  ,GraphType
  ,LCLIntf
  ,LMessages
  ,FileUtil
  ,LCLProc}
  Messages
  ,Windows
  ,ExtCtrls
  ,Controls
  ,Registry
  ,ComCtrls
  ,IpUtils2
  ;


procedure SoundAlarm;
begin
  Windows.Beep( 750, 500);
  Sleep(25);
  Windows.Beep(1000, 700);
  Sleep(25);
  Windows.Beep( 750, 500);
end;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IpUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIpBaseWinControl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TIpBaseWinControl') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TIpBaseWinControl') do
  begin
    RegisterProperty('Version', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIpBaseComponent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TIpBaseComponent') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TIpBaseComponent') do
  begin
    RegisterMethod('Function GetLogString( const S, D1, D2, D3 : DWORD) : string');
    RegisterProperty('Version', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIpBasePersistent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIpBasePersistent') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIpBasePersistent') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
      RegisterMethod('Procedure LockProperties');
    RegisterMethod('Procedure UnlockProperties');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIpBaseAccess(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIpBaseAccess') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIpBaseAccess') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure LockProperties');
    RegisterMethod('Procedure UnlockProperties');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IpUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('InternetProfessionalVersion','Extended').setExtended( 1.15);
 CL.AddConstantN('sShortVersion','String').SetString( 'v%.2f');
 CL.AddConstantN('IpMsgBase','LongWord').SetUInt( WM_USER + $0E90);
 CL.AddConstantN('CM_IPASYNCRESULT','LongInt').SetInt( IpMsgBase + 0);
 CL.AddConstantN('CM_IPSOCKMESSAGE','LongInt').SetInt( IpMsgBase + 1);
 CL.AddConstantN('CM_IPSOCKETSTATUS','LongInt').SetInt( IpMsgBase + 2);
 CL.AddConstantN('CM_IPFREESOCKET','LongInt').SetInt( IpMsgBase + 3);
 CL.AddConstantN('CM_IPLINEMESSAGE','LongInt').SetInt( IpMsgBase + 4);
 CL.AddConstantN('CM_IPTERMDATA','LongInt').SetInt( IpMsgBase + 5);
 CL.AddConstantN('CM_IPTERMRESIZE','LongInt').SetInt( IpMsgBase + 6);
 CL.AddConstantN('CM_IPICMPECHO','LongInt').SetInt( IpMsgBase + 7);
 CL.AddConstantN('CM_IPHTTPGETREQUEST','LongInt').SetInt( IpMsgBase + 8);
 CL.AddConstantN('CM_IPTIMESERVER','LongInt').SetInt( IpMsgBase + 9);
 CL.AddConstantN('CM_IPTIMECLIENT','LongInt').SetInt( IpMsgBase + 10);
 CL.AddConstantN('CM_IPSNTPCLIENT','LongInt').SetInt( IpMsgBase + 11);
 CL.AddConstantN('CM_IPFTPREPLY','LongInt').SetInt( IpMsgBase + 12);
 CL.AddConstantN('CM_IPFTPSTATUS','LongInt').SetInt( IpMsgBase + 13);
 CL.AddConstantN('CM_IPFTPERROR','LongInt').SetInt( IpMsgBase + 14);
 CL.AddConstantN('CM_IPFTPTIMEOUT','LongInt').SetInt( IpMsgBase + 15);
 CL.AddConstantN('CM_IPTERMFORCESIZE','LongInt').SetInt( IpMsgBase + 16);
 CL.AddConstantN('CM_IPTERMSTUFF','LongInt').SetInt( IpMsgBase + 17);
 CL.AddConstantN('CM_IPRASSTATUS','LongInt').SetInt( IpMsgBase + 18);
 CL.AddConstantN('CM_IPFINWHOSERVER','LongInt').SetInt( IpMsgBase + 19);
 CL.AddConstantN('CM_IPUTILITYSERVER','LongInt').SetInt( IpMsgBase + 20);
 CL.AddConstantN('CM_IPSMTPEVENT','LongInt').SetInt( IpMsgBase + 21);
 CL.AddConstantN('CM_IPPOP3EVENT','LongInt').SetInt( IpMsgBase + 22);
 CL.AddConstantN('CM_IPNNTPEVENT','LongInt').SetInt( IpMsgBase + 23);
 CL.AddConstantN('CM_IPHOTINVOKE','LongInt').SetInt( IpMsgBase + 24);
  CL.AddTypeS('TIpHandle', 'Cardinal');
  CL.AddTypeS('TIpMD5StateArray', 'array[0..3] of DWORD;');
  CL.AddTypeS('TIpMD5CountArray', 'array[0..1] of DWORD;');
  CL.AddTypeS('TIpMD5ByteBuf', 'array[0..63] of Byte;');
  CL.AddTypeS('TIpMD5LongBuf', 'array[0..15] of DWORD;');
  CL.AddTypeS('TIpMD5Digest', 'array[0..15] of Byte;');

  CL.AddTypeS('TIpLineTerminator', '( ltNone, ltCR, ltLF, ltCRLF, ltOther )');
  CL.AddTypeS('TIpMD5Context', 'record State : TIpMD5StateArray; Count : TIpMD5'
   +'CountArray; ByteBuf : TIpMD5ByteBuf; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIpBaseException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIpAccessException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIpHtmlException');
  SIRegister_TIpBaseAccess(CL);
  SIRegister_TIpBasePersistent(CL);
  //CL.AddTypeS('TIpComponentClass', 'class of TIpBaseComponent');
  SIRegister_TIpBaseComponent(CL);
  SIRegister_TIpBaseWinControl(CL);
 CL.AddDelphiFunction('Function InClassA( Addr : LongInt) : Boolean');
 CL.AddDelphiFunction('Function InClassB( Addr : LongInt) : Boolean');
 CL.AddDelphiFunction('Function InClassC( Addr : LongInt) : Boolean');
 CL.AddDelphiFunction('Function InClassD( Addr : LongInt) : Boolean');
 CL.AddDelphiFunction('Function InMulticast( Addr : LongInt) : Boolean');
 CL.AddDelphiFunction('Function IpCharCount( const Buffer, BufSize : DWORD; C : AnsiChar) : DWORD');
 CL.AddDelphiFunction('Function IpCompStruct( const S1, S2, Size : Cardinal) : Integer');
 CL.AddDelphiFunction('Function IpMaxInt( A, B : Integer) : Integer');
 CL.AddDelphiFunction('Function IpMinInt( A, B : Integer) : Integer');
 CL.AddDelphiFunction('Procedure IpSafeFree( var Obj: TObject)');
 CL.AddDelphiFunction('Function IpShortVersion : string');
 CL.AddDelphiFunction('Function IpInternetSumPrim( var Data, DataSize, CurCrc : DWORD) : DWORD');
 CL.AddDelphiFunction('Function IpInternetSumOfStream( Stream : TStream; CurCrc : DWORD) : DWORD');
 CL.AddDelphiFunction('Function IpInternetSumOfFile( const FileName : string) : DWORD');
 CL.AddDelphiFunction('Function MD5SumOfFile( const FileName : string) : string');
 CL.AddDelphiFunction('Function MD5SumOfStream( Stream : TStream) : string');
 CL.AddDelphiFunction('Function MD5SumOfStreamDigest( Stream : TStream) : TIpMD5Digest');
 CL.AddDelphiFunction('Function MD5SumOfString( const S : string) : string');
 CL.AddDelphiFunction('Function MD5SumOfStringDigest( const S : string) : TIpMD5Digest');
 CL.AddDelphiFunction('Function SafeYield : LongInt');
 CL.AddDelphiFunction('Function AllTrimSpaces( Strng : string) : string');
 CL.AddDelphiFunction('Function IpCharPos( C : AnsiChar; const S : string) : Integer');
 CL.AddDelphiFunction('Function CharPosIdx( C : AnsiChar; const S : string; Idx : Integer) : Integer');
 CL.AddDelphiFunction('Function NthCharPos( C : AnsiChar; const S : string; Nth : Integer) : Integer');
 CL.AddDelphiFunction('Function RCharPos( C : AnsiChar; const S : string) : Integer');
 CL.AddDelphiFunction('Function RCharPosIdx( C : AnsiChar; const S : string; Idx : Integer) : Integer');
 CL.AddDelphiFunction('Function RNthCharPos( C : AnsiChar; const S : string; Nth : Integer) : Integer');
 CL.AddDelphiFunction('Function IpRPos( const Substr : string; const S : string) : Integer');
 CL.AddDelphiFunction('Function IpPosIdx( const SubStr, S : string; Idx : Integer) : Integer');
  CL.AddTypeS('ATCharSet', 'set of AnsiChar');
  CL.AddTypeS('TIpAddrRec', 'record Scheme : string; UserName : string; Password'
   +': string; Authority : string; Port : string; Path : string; Fragment : string; Query : string; QueryDelim : AnsiChar; end');
 CL.AddDelphiFunction('Procedure Initialize( var AddrRec : TIpAddrRec)');
 CL.AddDelphiFunction('Procedure Finalize( var AddrRec : TIpAddrRec)');
 CL.AddDelphiFunction('Function ExtractEntityName( const NamePath : string) : string');
 CL.AddDelphiFunction('Function ExtractEntityPath( const NamePath : string) : string');
 CL.AddDelphiFunction('Function IpParseURL( const URL : string; var Rslt : TIpAddrRec) : Boolean');
 CL.AddDelphiFunction('Function BuildURL( const OldURL, NewURL : string) : string');
 CL.AddDelphiFunction('Function PutEscapes( const S : string; EscapeSet : ATCharSet) : string');
 CL.AddDelphiFunction('Function RemoveEscapes( const S : string; EscapeSet : ATCharSet) : string');
 CL.AddDelphiFunction('Procedure SplitParams( const Parms : string; Dest : TStrings)');
 CL.AddDelphiFunction('Function NetToDOSPath( const PathStr : string) : string');
 CL.AddDelphiFunction('Function DOSToNetPath( const PathStr : string) : string');
 CL.AddDelphiFunction('Procedure SplitHttpResponse( const S : string; var V, MsgID, Msg : string)');
 CL.AddDelphiFunction('Procedure FieldFix( Fields : TStrings)');
 CL.AddDelphiFunction('Function AppendSlash( APath : string) : string');
 CL.AddDelphiFunction('Function RemoveSlash( APath : string) : string');
 CL.AddDelphiFunction('Function GetParentPath( const Path : string) : string');
 CL.AddDelphiFunction('Function GetLocalContent( const TheFileName : string) : string');
 CL.AddDelphiFunction('Function IPDirExists( Dir : string) : Boolean');
 CL.AddDelphiFunction('Function GetTemporaryFile( const Path : string) : string');
 CL.AddDelphiFunction('Function GetTemporaryPath : string');
 CL.AddDelphiFunction('Function AppendBackSlash( APath : string) : string');
 CL.AddDelphiFunction('Function IpRemoveBackSlash( APath : string) : string');
 CL.AddDelphiFunction('Function INetDateStrToDateTime( const DateStr : string) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToINetDateTimeStr( DateTime : TDateTime) : string');
 CL.AddDelphiFunction('Function IpTimeZoneBias : Integer');
 CL.AddDelphiFunction('Procedure SplitCookieFields( const Data : string; Fields : TStrings)');
 CL.AddDelphiFunction('procedure SoundAlarm;');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIpBaseWinControlVersion_W(Self: TIpBaseWinControl; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpBaseWinControlVersion_R(Self: TIpBaseWinControl; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TIpBaseComponentVersion_W(Self: TIpBaseComponent; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TIpBaseComponentVersion_R(Self: TIpBaseComponent; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IpUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@InClassA, 'InClassA', cdRegister);
 S.RegisterDelphiFunction(@InClassB, 'InClassB', cdRegister);
 S.RegisterDelphiFunction(@InClassC, 'InClassC', cdRegister);
 S.RegisterDelphiFunction(@InClassD, 'InClassD', cdRegister);
 S.RegisterDelphiFunction(@InMulticast, 'InMulticast', cdRegister);
 S.RegisterDelphiFunction(@IpCharCount, 'IpCharCount', cdRegister);
 S.RegisterDelphiFunction(@IpCompStruct, 'IpCompStruct', cdRegister);
 S.RegisterDelphiFunction(@IpMaxInt, 'IpMaxInt', cdRegister);
 S.RegisterDelphiFunction(@IpMinInt, 'IpMinInt', cdRegister);
 S.RegisterDelphiFunction(@IpSafeFree, 'IpSafeFree', cdRegister);
 S.RegisterDelphiFunction(@IpShortVersion, 'IpShortVersion', cdRegister);
 S.RegisterDelphiFunction(@InternetSumPrim, 'IpInternetSumPrim', cdRegister);
 S.RegisterDelphiFunction(@InternetSumOfStream, 'IpInternetSumOfStream', cdRegister);
 S.RegisterDelphiFunction(@InternetSumOfFile, 'IpInternetSumOfFile', cdRegister);
 S.RegisterDelphiFunction(@MD5SumOfFile, 'MD5SumOfFile', cdRegister);
 S.RegisterDelphiFunction(@MD5SumOfStream, 'MD5SumOfStream', cdRegister);
 S.RegisterDelphiFunction(@MD5SumOfStreamDigest, 'MD5SumOfStreamDigest', cdRegister);
 S.RegisterDelphiFunction(@MD5SumOfString, 'MD5SumOfString', cdRegister);
 S.RegisterDelphiFunction(@MD5SumOfStringDigest, 'MD5SumOfStringDigest', cdRegister);
 S.RegisterDelphiFunction(@SafeYield, 'SafeYield', cdRegister);
 S.RegisterDelphiFunction(@AllTrimSpaces, 'AllTrimSpaces', cdRegister);
 S.RegisterDelphiFunction(@CharPos, 'IPCharPos', cdRegister);
 S.RegisterDelphiFunction(@CharPosIdx, 'CharPosIdx', cdRegister);
 S.RegisterDelphiFunction(@NthCharPos, 'NthCharPos', cdRegister);
 S.RegisterDelphiFunction(@RCharPos, 'RCharPos', cdRegister);
 S.RegisterDelphiFunction(@RCharPosIdx, 'RCharPosIdx', cdRegister);
 S.RegisterDelphiFunction(@RNthCharPos, 'RNthCharPos', cdRegister);
 S.RegisterDelphiFunction(@RPos, 'IpRPos', cdRegister);
 S.RegisterDelphiFunction(@PosIdx, 'IpPosIdx', cdRegister);
 //S.RegisterDelphiFunction(@Initialize_P, 'Initialize', cdRegister);
 //S.RegisterDelphiFunction(@Finalize, 'Finalize', cdRegister);
 S.RegisterDelphiFunction(@ExtractEntityName, 'ExtractEntityName', cdRegister);
 S.RegisterDelphiFunction(@ExtractEntityPath, 'ExtractEntityPath', cdRegister);
 S.RegisterDelphiFunction(@IpParseURL, 'IpParseURL', cdRegister);
 S.RegisterDelphiFunction(@BuildURL, 'BuildURL', cdRegister);
 S.RegisterDelphiFunction(@PutEscapes, 'PutEscapes', cdRegister);
 S.RegisterDelphiFunction(@RemoveEscapes, 'RemoveEscapes', cdRegister);
 S.RegisterDelphiFunction(@SplitParams, 'SplitParams', cdRegister);
 S.RegisterDelphiFunction(@NetToDOSPath, 'NetToDOSPath', cdRegister);
 S.RegisterDelphiFunction(@DOSToNetPath, 'DOSToNetPath', cdRegister);
 S.RegisterDelphiFunction(@SplitHttpResponse, 'SplitHttpResponse', cdRegister);
 S.RegisterDelphiFunction(@FieldFix, 'FieldFix', cdRegister);
 S.RegisterDelphiFunction(@AppendSlash, 'AppendSlash', cdRegister);
 S.RegisterDelphiFunction(@RemoveSlash, 'RemoveSlash', cdRegister);
 S.RegisterDelphiFunction(@GetParentPath, 'GetParentPath', cdRegister);
 S.RegisterDelphiFunction(@GetLocalContent, 'GetLocalContent', cdRegister);
 S.RegisterDelphiFunction(@DirExists, 'IpDirExists', cdRegister);
 S.RegisterDelphiFunction(@GetTemporaryFile, 'GetTemporaryFile', cdRegister);
 S.RegisterDelphiFunction(@GetTemporaryPath, 'GetTemporaryPath', cdRegister);
 S.RegisterDelphiFunction(@AppendBackSlash, 'AppendBackSlash', cdRegister);
 S.RegisterDelphiFunction(@RemoveBackSlash, 'IpRemoveBackSlash', cdRegister);
 S.RegisterDelphiFunction(@INetDateStrToDateTime, 'INetDateStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToINetDateTimeStr, 'DateTimeToINetDateTimeStr', cdRegister);
 S.RegisterDelphiFunction(@TimeZoneBias, 'IpTimeZoneBias', cdRegister);
 S.RegisterDelphiFunction(@SplitCookieFields, 'SplitCookieFields', cdRegister);
 S.RegisterDelphiFunction(@SoundAlarm, 'SoundAlarm', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIpBaseWinControl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIpBaseWinControl) do
  begin
    RegisterPropertyHelper(@TIpBaseWinControlVersion_R,@TIpBaseWinControlVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIpBaseComponent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIpBaseComponent) do
  begin
    RegisterVirtualMethod(@TIpBaseComponent.GetLogString, 'GetLogString');
    RegisterPropertyHelper(@TIpBaseComponentVersion_R,@TIpBaseComponentVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIpBasePersistent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIpBasePersistent) do begin
    RegisterVirtualConstructor(@TIpBasePersistent.Create, 'Create');
    RegisterMethod(@TIpBasePersistent.Destroy, 'Free');
    RegisterMethod(@TIpBasePersistent.LockProperties, 'LockProperties');
    RegisterMethod(@TIpBasePersistent.UnlockProperties, 'UnlockProperties');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIpBaseAccess(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIpBaseAccess) do begin
    RegisterVirtualConstructor(@TIpBaseAccess.Create, 'Create');
      RegisterMethod(@TIpBasePersistent.Destroy, 'Free');
       RegisterMethod(@TIpBaseAccess.LockProperties, 'LockProperties');
    RegisterMethod(@TIpBaseAccess.UnlockProperties, 'UnlockProperties');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IpUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIpBaseException) do
  with CL.Add(EIpAccessException) do
  with CL.Add(EIpHtmlException) do
  RIRegister_TIpBaseAccess(CL);
  RIRegister_TIpBasePersistent(CL);
  RIRegister_TIpBaseComponent(CL);
  RIRegister_TIpBaseWinControl(CL);
end;



{ TPSImport_IpUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IpUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IpUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IpUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IpUtils(ri);
  RIRegister_IpUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
