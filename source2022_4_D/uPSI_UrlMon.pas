unit uPSI_UrlMon;
{
   the very last past
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
  TPSImport_UrlMon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IEncodingFilterFactory(CL: TPSPascalCompiler);
procedure SIRegister_IDataFilter(CL: TPSPascalCompiler);
procedure SIRegister_ISoftDistExt(CL: TPSPascalCompiler);
procedure SIRegister_IInternetZoneManagerEx(CL: TPSPascalCompiler);
procedure SIRegister_IInternetZoneManager(CL: TPSPascalCompiler);
procedure SIRegister_IInternetSecurityManagerEx(CL: TPSPascalCompiler);
procedure SIRegister_IInternetHostSecurityManager(CL: TPSPascalCompiler);
procedure SIRegister_IInternetSecurityManager(CL: TPSPascalCompiler);
procedure SIRegister_IInternetSecurityMgrSite(CL: TPSPascalCompiler);
procedure SIRegister_IInternetProtocolInfo(CL: TPSPascalCompiler);
procedure SIRegister_IInternetPriority(CL: TPSPascalCompiler);
procedure SIRegister_IInternetThreadSwitch(CL: TPSPascalCompiler);
procedure SIRegister_IInternetSession(CL: TPSPascalCompiler);
procedure SIRegister_IInternetProtocolSink(CL: TPSPascalCompiler);
procedure SIRegister_IInternetProtocol(CL: TPSPascalCompiler);
procedure SIRegister_IInternetProtocolRoot(CL: TPSPascalCompiler);
procedure SIRegister_IInternetBindInfo(CL: TPSPascalCompiler);
procedure SIRegister_IInternet(CL: TPSPascalCompiler);
procedure SIRegister_IBindHost(CL: TPSPascalCompiler);
procedure SIRegister_IWinInetHttpInfo(CL: TPSPascalCompiler);
procedure SIRegister_IHttpSecurity(CL: TPSPascalCompiler);
procedure SIRegister_IWinInetInfo(CL: TPSPascalCompiler);
procedure SIRegister_ICodeInstall(CL: TPSPascalCompiler);
procedure SIRegister_IWindowForBindingUI(CL: TPSPascalCompiler);
procedure SIRegister_IHttpNegotiate(CL: TPSPascalCompiler);
procedure SIRegister_IAuthenticate(CL: TPSPascalCompiler);
procedure SIRegister_IBindStatusCallback(CL: TPSPascalCompiler);
procedure SIRegister_IBinding(CL: TPSPascalCompiler);
procedure SIRegister_IBindProtocol(CL: TPSPascalCompiler);
procedure SIRegister_IPersistMoniker(CL: TPSPascalCompiler);
procedure SIRegister_UrlMon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_UrlMon_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,UrlMon, ShellApi, WinInet
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_UrlMon]);
end;

function DownloadURL_NOCache(const aUrl: string; var s: String): Boolean;
var
  hSession: HINTERNET;
  hService: HINTERNET;
  lpBuffer: array[0..1024 + 1] of Char;
  dwBytesRead: DWORD;
begin
  Result := False;
  s := '';
  // hSession := InternetOpen( 'MyApp', INTERNET_OPEN_TYPE_DIRECT, nil, nil, 0);
  hSession := InternetOpen('MyApp', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  try
    if Assigned(hSession) then
    begin
      hService := InternetOpenUrl(hSession, PChar(aUrl), nil, 0, INTERNET_FLAG_RELOAD, 0);
      if Assigned(hService) then
        try
          while True do begin
            dwBytesRead := 1024;
            InternetReadFile(hService, @lpBuffer, 1024, dwBytesRead);
            if dwBytesRead = 0 then break;
            lpBuffer[dwBytesRead] := #0;
            s := s + lpBuffer;
          end;
          Result := True;
        finally
          InternetCloseHandle(hService);
        end;
    end;
  finally
    InternetCloseHandle(hSession);
  end;
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IEncodingFilterFactory(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IEncodingFilterFactory') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IEncodingFilterFactory, 'IEncodingFilterFactory') do
  begin
    RegisterMethod('Function FindBestFilter( pwzCodeIn, pwzCodeOut : LPCWSTR; info : TDataInfo; out DF : IDataFilter) : HResult', CdStdCall);
    RegisterMethod('Function GetDefaultFilter( pwzCodeIn, pwzCodeOut : LPCWSTR; info : TDataInfo; out DF : IDataFilter) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDataFilter(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDataFilter') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDataFilter, 'IDataFilter') do
  begin
    RegisterMethod('Function DoEncode( dwFlags : DWORD; lInBufferSize : Longint; pbInBuffer : Pointer; lOutBufferSize : Longint; pbOutBuffer : Pointer; lInBytesAvailable : Longint; out lInBytesRead, lOutBytesWritten : Longint; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function DoDecode( dwFlags : DWORD; lInBufferSize : Longint; pbInBuffer : Pointer; lOutBufferSize : Longint; pbOutBuffer : Pointer; lInBytesAvailable : Longint; out lInBytesRead, lOutBytesWritten : Longint; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function SetEncodingLevel( dwEncLevel : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISoftDistExt(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ISoftDistExt') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISoftDistExt, 'ISoftDistExt') do
  begin
    RegisterMethod('Function ProcessSoftDist( szCDFURL : LPCWSTR; SoftDistElement : Pointer; var lpdsi : TSoftDistInfo) : HResult', CdStdCall);
    RegisterMethod('Function GetFirstCodeBase( var szCodeBase : LPWSTR; const dwMaxSize : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function GetNextCodeBase( var szCodeBase : LPWSTR; const dwMaxSize : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function AsyncInstallDistributionUnit( bc : IBindCtx; pvReserved : Pointer; flags : DWORD; const cbh : TCodeBaseHold) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetZoneManagerEx(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInternetZoneManager', 'IInternetZoneManagerEx') do
  with CL.AddInterface(CL.FindInterface('IInternetZoneManager'),IInternetZoneManagerEx, 'IInternetZoneManagerEx') do
  begin
    RegisterMethod('Function GetZoneActionPolicyEx( dwZone, dwAction : DWORD; pPolicy : Pointer; cbPolicy : DWORD; urlZoneReg : TUrlZoneReg; dwFlags : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function SetZoneActionPolicyEx( dwZone, dwAction : DWORD; pPolicy : Pointer; cbPolicy : DWORD; urlZoneReg : TUrlZoneReg; dwFlags : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetZoneManager(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetZoneManager') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetZoneManager, 'IInternetZoneManager') do
  begin
    RegisterMethod('Function GetZoneAttributes( dwZone : DWORD; var ZoneAttributes : TZoneAttributes) : HResult', CdStdCall);
    RegisterMethod('Function SetZoneAttributes( dwZone : DWORD; const ZoneAttributes : TZoneAttributes) : HResult', CdStdCall);
    RegisterMethod('Function GetZoneCustomPolicy( dwZone : DWORD; const guidKey : TGUID; out pPolicy : Pointer; out cbPolicy : DWORD; urlZoneReg : TUrlZoneReg) : HResult', CdStdCall);
    RegisterMethod('Function SetZoneCustomPolicy( dwZone : DWORD; const guidKey : TGUID; pPolicy : Pointer; cbPolicy : DWORD; urlZoneReg : TUrlZoneReg) : HResult', CdStdCall);
    RegisterMethod('Function GetZoneActionPolicy( dwZone, dwAction : DWORD; pPolicy : Pointer; cbPolicy : DWORD; urlZoneReg : TUrlZoneReg) : HResult', CdStdCall);
    RegisterMethod('Function SetZoneActionPolicy( dwZone, dwAction : DWORD; pPolicy : Pointer; cbPolicy : DWORD; urlZoneReg : TUrlZoneReg) : HResult', CdStdCall);
    RegisterMethod('Function PromptAction( dwAction : DWORD; hwndParent : HWnd; pwszUrl, pwszText : LPCWSTR; dwPromptFlags : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function LogAction( dwAction : DWORD; pwszUrl, pwszText : LPCWSTR; dwLogFlags : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function CreateZoneEnumerator( out dwEnum, dwCount : DWORD; dwFlags : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function GetZoneAt( dwEnum, dwIndex : DWORD; out dwZone : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function DestroyZoneEnumerator( dwEnum : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function CopyTemplatePoliciesToZone( dwTemplate, dwZone, dwReserved : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetSecurityManagerEx(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInternetSecurityManager', 'IInternetSecurityManagerEx') do
  with CL.AddInterface(CL.FindInterface('IInternetSecurityManager'),IInternetSecurityManagerEx, 'IInternetSecurityManagerEx') do
  begin
    RegisterMethod('Function ProcessUrlActionEx( pwszUrl : LPCWSTR; dwAction : DWORD; pPolicy : Pointer; cbPolicy : DWORD; pContext : Pointer; cbContext : DWORD; dwFlags, dwReserved : DWORD; out pdwOutFlags : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetHostSecurityManager(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetHostSecurityManager') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetHostSecurityManager, 'IInternetHostSecurityManager') do
  begin
    RegisterMethod('Function GetSecurityId( pbSecurityId : Pointer; var cbSecurityId : DWORD; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function ProcessUrlAction( dwAction : DWORD; pPolicy : Pointer; cbPolicy : DWORD; pContext : Pointer; cbContext, dwFlags, dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function QueryCustomPolicy( const guidKey : TGUID; out pPolicy : Pointer; out cbPolicy : DWORD; pContext : Pointer; cbContext, dwReserved : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetSecurityManager(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetSecurityManager') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetSecurityManager, 'IInternetSecurityManager') do
  begin
    RegisterMethod('Function SetSecuritySite( Site : IInternetSecurityMgrSite) : HResult', CdStdCall);
    RegisterMethod('Function GetSecuritySite( out Site : IInternetSecurityMgrSite) : HResult', CdStdCall);
    RegisterMethod('Function MapUrlToZone( pwszUrl : LPCWSTR; out dwZone : DWORD; dwFlags : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function GetSecurityId( pwszUrl : LPCWSTR; pbSecurityId : Pointer; var cbSecurityId : DWORD; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function ProcessUrlAction( pwszUrl : LPCWSTR; dwAction : DWORD; pPolicy : Pointer; cbPolicy : DWORD; pContext : Pointer; cbContext : DWORD; dwFlags, dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function QueryCustomPolicy( pwszUrl : LPCWSTR; const guidKey : TGUID; out pPolicy : Pointer; out cbPolicy : DWORD; pContext : Pointer; cbContext : DWORD; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function SetZoneMapping( dwZone : DWORD; lpszPattern : LPCWSTR; dwFlags : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function GetZoneMappings( dwZone : DWORD; out enumString : IEnumString; dwFlags : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetSecurityMgrSite(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetSecurityMgrSite') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetSecurityMgrSite, 'IInternetSecurityMgrSite') do
  begin
    RegisterMethod('Function GetWindow( out hwnd : HWnd) : HResult', CdStdCall);
    RegisterMethod('Function EnableModeless( fEnable : BOOL) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetProtocolInfo(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetProtocolInfo') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetProtocolInfo, 'IInternetProtocolInfo') do
  begin
    RegisterMethod('Function ParseUrl( pwzUrl : LPCWSTR; ParseAction : TParseAction; dwParseFlags : DWORD; pwzResult : LPWSTR; cchResult : DWORD; out pcchResult : DWORD; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function CombineUrl( pwzBaseUrl, pwzRelativeUrl : LPCWSTR; dwCombineFlags : DWORD; pwzResult : LPWSTR; cchResult : DWORD; out pcchResult : DWORD; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function CompareUrl( pwzUrl1, pwzUrl2 : LPCWSTR; dwCompareFlags : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function QueryInfo( pwzUrl : LPCWSTR; QueryOption : TQueryOption; dwQueryFlags : DWORD; pBuffer : Pointer; cbBuffer : DWORD; var cbBuf : DWORD; dwReserved : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetPriority(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetPriority') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetPriority, 'IInternetPriority') do
  begin
    RegisterMethod('Function SetPriority( nPriority : Longint) : HResult', CdStdCall);
    RegisterMethod('Function GetPriority( out nPriority : Longint) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetThreadSwitch(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetThreadSwitch') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetThreadSwitch, 'IInternetThreadSwitch') do
  begin
    RegisterMethod('Function Prepare : HResult', CdStdCall);
    RegisterMethod('Function Continue : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetSession(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetSession') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetSession, 'IInternetSession') do
  begin
    RegisterMethod('Function RegisterNameSpace( CF : IClassFactory; const clsid : TCLSID; pwzProtocol : LPCWSTR; cPatterns : ULONG; const pwzPatterns : PLPCWSTRArray; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function UnregisterNameSpace( CF : IClassFactory; pszProtocol : LPCWSTR) : HResult', CdStdCall);
    RegisterMethod('Function RegisterMimeFilter( CF : IClassFactory; const rclsid : TCLSID; pwzType : LPCWSTR) : HResult', CdStdCall);
    RegisterMethod('Function UnregisterMimeFilter( CF : IClassFactory; pwzType : LPCWSTR) : HResult', CdStdCall);
    RegisterMethod('Function CreateBinding( BC : IBindCtx; szUrl : LPCWSTR; UnkOuter : IUnknown; out Unk : IUnknown; out OINetProt : IInternetProtocol; dwOption : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function SetSessionOption( dwOption : DWORD; pBuffer : Pointer; dwBufferLength : DWORD; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function GetSessionOption( dwOption : DWORD; pBuffer : Pointer; var dwBufferLength : DWORD; dwReserved : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetProtocolSink(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetProtocolSink') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetProtocolSink, 'IInternetProtocolSink') do
  begin
    RegisterMethod('Function Switch( const ProtocolData : TProtocolData) : HResult', CdStdCall);
    RegisterMethod('Function ReportProgress( ulStatusCode : ULONG; szStatusText : LPCWSTR) : HResult', CdStdCall);
    RegisterMethod('Function ReportData( grfBSCF : DWORD; ulProgress, ulProgressMax : ULONG) : HResult', CdStdCall);
    RegisterMethod('Function ReportResult( hrResult : HResult; dwError : DWORD; szResult : LPCWSTR) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetProtocol(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInternetProtocolRoot', 'IInternetProtocol') do
  with CL.AddInterface(CL.FindInterface('IInternetProtocolRoot'),IInternetProtocol, 'IInternetProtocol') do
  begin
    RegisterMethod('Function Read( pv : Pointer; cb : ULONG; out cbRead : ULONG) : HResult', CdStdCall);
    RegisterMethod('Function Seek( dlibMove : LARGE_INTEGER; dwOrigin : DWORD; out libNewPosition : ULARGE_INTEGER) : HResult', CdStdCall);
    RegisterMethod('Function LockRequest( dwOptions : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function UnlockRequest : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetProtocolRoot(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetProtocolRoot') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetProtocolRoot, 'IInternetProtocolRoot') do
  begin
    RegisterMethod('Function Start( szUrl : LPCWSTR; OIProtSink : IInternetProtocolSink; OIBindInfo : IInternetBindInfo; grfPI, dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function Continue( const ProtocolData : TProtocolData) : HResult', CdStdCall);
    RegisterMethod('Function Abort( hrReason : HResult; dwOptions : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function Terminate( dwOptions : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function Suspend : HResult', CdStdCall);
    RegisterMethod('Function Resume : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternetBindInfo(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternetBindInfo') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetBindInfo, 'IInternetBindInfo') do
  begin
    RegisterMethod('Function GetBindInfo( out grfBINDF : DWORD; var bindinfo : TBindInfo) : HResult', CdStdCall);
    RegisterMethod('Function GetBindString( ulStringType : ULONG; wzStr : POLEStrArray; cEl : ULONG; var cElFetched : ULONG) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInternet(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInternet') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternet, 'IInternet') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBindHost(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IBindHost') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IBindHost, 'IBindHost') do
  begin
    RegisterMethod('Function CreateMoniker( szName : POLEStr; BC : IBindCtx; out mk : IMoniker; dwReserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function MonikerBindToStorage( Mk : IMoniker; BC : IBindCtx; BSC : IBindStatusCallback; const iid : TGUID; out pvObj) : HResult', CdStdCall);
    RegisterMethod('Function MonikerBindToObject( Mk : IMoniker; BC : IBindCtx; BSC : IBindStatusCallback; const iid : TGUID; out pvObj) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IWinInetHttpInfo(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IWinInetInfo', 'IWinInetHttpInfo') do
  with CL.AddInterface(CL.FindInterface('IWinInetInfo'),IWinInetHttpInfo, 'IWinInetHttpInfo') do
  begin
    RegisterMethod('Function QueryInfo( dwOption : DWORD; Buffer : Pointer; var cbBuf, dwFlags, dwReserved : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IHttpSecurity(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IWindowForBindingUI', 'IHttpSecurity') do
  with CL.AddInterface(CL.FindInterface('IWindowForBindingUI'),IHttpSecurity, 'IHttpSecurity') do
  begin
    RegisterMethod('Function OnSecurityProblem( dwProblem : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IWinInetInfo(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IWinInetInfo') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IWinInetInfo, 'IWinInetInfo') do
  begin
    RegisterMethod('Function QueryOption( dwOption : DWORD; Buffer : Pointer; var cbBuf : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ICodeInstall(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IWindowForBindingUI', 'ICodeInstall') do
  with CL.AddInterface(CL.FindInterface('IWindowForBindingUI'),ICodeInstall, 'ICodeInstall') do
  begin
    RegisterMethod('Function OnCodeInstallProblem( ulStatusCode : ULONG; szDestination, szSource : LPCWSTR; dwReserved : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IWindowForBindingUI(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IWindowForBindingUI') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IWindowForBindingUI, 'IWindowForBindingUI') do
  begin
    RegisterMethod('Function GetWindow( const guidReason : TGUID; out hwnd) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IHttpNegotiate(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IHttpNegotiate') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IHttpNegotiate, 'IHttpNegotiate') do
  begin
    RegisterMethod('Function BeginningTransaction( szURL, szHeaders : LPCWSTR; dwReserved : DWORD; out szAdditionalHeaders : LPWSTR) : HResult', CdStdCall);
    RegisterMethod('Function OnResponse( dwResponseCode : DWORD; szResponseHeaders, szRequestHeaders : LPCWSTR; out szAdditionalRequestHeaders : LPWSTR) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IAuthenticate(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IAuthenticate') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAuthenticate, 'IAuthenticate') do
  begin
    RegisterMethod('Function Authenticate( var hwnd : HWnd; var szUserName, szPassWord : LPWSTR) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBindStatusCallback(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IBindStatusCallback') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IBindStatusCallback, 'IBindStatusCallback') do
  begin
    RegisterMethod('Function OnStartBinding( dwReserved : DWORD; pib : IBinding) : HResult', CdStdCall);
    RegisterMethod('Function GetPriority( out nPriority) : HResult', CdStdCall);
    RegisterMethod('Function OnLowResource( reserved : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function OnProgress( ulProgress, ulProgressMax, ulStatusCode : ULONG; szStatusText : LPCWSTR) : HResult', CdStdCall);
    RegisterMethod('Function OnStopBinding( hresult : HResult; szError : LPCWSTR) : HResult', CdStdCall);
    RegisterMethod('Function GetBindInfo( out grfBINDF : DWORD; var bindinfo : TBindInfo) : HResult', CdStdCall);
    RegisterMethod('Function OnDataAvailable( grfBSCF : DWORD; dwSize : DWORD; formatetc : PFormatEtc; stgmed : PStgMedium) : HResult', CdStdCall);
    RegisterMethod('Function OnObjectAvailable( const iid : TGUID; punk : IUnknown) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBinding(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IBinding') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IBinding, 'IBinding') do
  begin
    RegisterMethod('Function Abort : HResult', CdStdCall);
    RegisterMethod('Function Suspend : HResult', CdStdCall);
    RegisterMethod('Function Resume : HResult', CdStdCall);
    RegisterMethod('Function SetPriority( nPriority : Longint) : HResult', CdStdCall);
    RegisterMethod('Function GetPriority( out nPriority : Longint) : HResult', CdStdCall);
    RegisterMethod('Function GetBindResult( out clsidProtocol : TCLSID; out dwResult : DWORD; out szResult : POLEStr; dwReserved : DWORD) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IBindProtocol(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IBindProtocol') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IBindProtocol, 'IBindProtocol') do
  begin
    RegisterMethod('Function CreateBinding( szUrl : LPCWSTR; pbc : IBindCtx; out ppb : IBinding) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IPersistMoniker(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IPersistMoniker') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IPersistMoniker, 'IPersistMoniker') do
  begin
    RegisterMethod('Function GetClassID( out ClassID : TCLSID) : HResult', CdStdCall);
    RegisterMethod('Function IsDirty : HResult', CdStdCall);
    RegisterMethod('Function Load( fFullyAvailable : BOOL; pimkName : IMoniker; pibc : IBindCtx; grfMode : DWORD) : HResult', CdStdCall);
    RegisterMethod('Function Save( pimkName : IMoniker; pbc : IBindCtx; fRemember : BOOL) : HResult', CdStdCall);
    RegisterMethod('Function SaveCompleted( pimkName : IMoniker; pibc : IBindCtx) : HResult', CdStdCall);
    RegisterMethod('Function GetCurMoniker( ppimkName : IMoniker) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_UrlMon(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('SZ_URLCONTEXT','POLEStr').SetString( 'URL Context');
 //CL.AddConstantN('SZ_ASYNC_CALLEE','POLEStr').SetString( 'AsyncCallee');
 CL.AddConstantN('MKSYS_URLMONIKER','LongInt').SetInt( 6);
 (*CL.AddConstantN('IID_IPersistMoniker','TGUID').SetString( '{79eac9c9-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IBinding','TGUID').SetString( '{79eac9c0-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IBindStatusCallback','TGUID').SetString( '{79eac9c1-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IAuthenticate','TGUID').SetString( '{79eac9d0-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IHttpNegotiate','TGUID').SetString( '{79eac9d2-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IWindowForBindingUI','TGUID').SetString( '{79eac9d5-bafa-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_ICodeInstall','TGUID').SetString( '{79eac9d1-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IWinInetInfo','TGUID').SetString( '{79eac9d6-bafa-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IHttpSecurity','TGUID').SetString( '{79eac9d7-bafa-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IWinInetHttpInfo','TGUID').SetString( '{79eac9d8-bafa-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IBindHost','TGUID').SetString( '{fc4801a1-2ba9-11cf-a229-00aa003d7352}');
 CL.AddConstantN('IID_IInternet','TGUID').SetString( '{79eac9e0-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetBindInfo','TGUID').SetString( '{79eac9e1-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetProtocolRoot','TGUID').SetString( '{79eac9e3-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetProtocol','TGUID').SetString( '{79eac9e4-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetProtocolSink','TGUID').SetString( '{79eac9e5-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetSession','TGUID').SetString( '{79eac9e7-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetThreadSwitch','TGUID').SetString( '{79eac9e8-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetPriority','TGUID').SetString( '{79eac9eb-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetProtocolInfo','TGUID').SetString( '{79eac9ec-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('SID_IBindHost','TGUID').SetString( '{fc4801a1-2ba9-11cf-a229-00aa003d7352}');
 CL.AddConstantN('SID_SBindHost','TGUID').SetString( '{fc4801a1-2ba9-11cf-a229-00aa003d7352}');
 CL.AddConstantN('IID_IOInet','TGUID').SetString( '{79eac9e0-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IOInetBindInfo','TGUID').SetString( '{79eac9e1-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IOInetProtocolRoot','TGUID').SetString( '{79eac9e3-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IOInetProtocol','TGUID').SetString( '{79eac9e4-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IOInetProtocolSink','TGUID').SetString( '{79eac9e5-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IOInetProtocolInfo','TGUID').SetString( '{79eac9ec-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IOInetSession','TGUID').SetString( '{79eac9e7-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IOInetPriority','TGUID').SetString( '{79eac9eb-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IOInetThreadSwitch','TGUID').SetString( '{79eac9e8-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetSecurityMgrSite','TGUID').SetString( '{79eac9ed-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetSecurityManager','TGUID').SetString( '{79eac9ee-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetSecurityManagerEx','TGUID').SetString( '{F164EDF1-CC7C-4f0d-9A94-34222625C393}');
 CL.AddConstantN('IID_IInternetHostSecurityManager','TGUID').SetString( '{3af280b6-cb3f-11d0-891e-00c04fb6bfc4}');
 CL.AddConstantN('SID_IInternetSecurityManager','TGUID').SetString( '{79eac9ee-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('SID_IInternetSecurityManagerEx','TGUID').SetString( '{F164EDF1-CC7C-4f0d-9A94-34222625C393}');
 CL.AddConstantN('SID_IInternetHostSecurityManager','TGUID').SetString( '{3af280b6-cb3f-11d0-891e-00c04fb6bfc4}');
 CL.AddConstantN('IID_IInternetZoneManager','TGUID').SetString( '{79eac9ef-baf9-11ce-8c82-00aa004ba90b}');
 CL.AddConstantN('IID_IInternetZoneManagerEx','TGUID').SetString( '{A4C23339-8E06-431e-9BF4-7E711C085648}');
 CL.AddConstantN('IID_ISoftDistExt','TGUID').SetString( '{B15B8DC1-C7E1-11d0-8680-00AA00BDCB71}');
 CL.AddConstantN('IID_IDataFilter','TGUID').SetString( '{69d14c80-c18e-11d0-a9ce-006097942311}');
 CL.AddConstantN('IID_IEncodingFilterFactory','TGUID').SetString( '{70bdde00-c18e-11d0-a9ce-006097942311}');  *)

  CL.AddTypeS('ULONG', 'Cardinal');
  CL.AddTypeS('LPCWSTR', 'PChar');
  CL.AddTypeS('LPWSTR', 'PChar');
  CL.AddTypeS('LPSTR', 'PChar');
  CL.AddTypeS('TBindVerb', 'ULONG');
  CL.AddTypeS('TBindInfoF', 'ULONG');
  CL.AddTypeS('TBindF', 'ULONG');
  CL.AddTypeS('TBSCF', 'ULONG');
  CL.AddTypeS('TBindStatus', 'ULONG');
  CL.AddTypeS('TCIPStatus', 'ULONG');
  CL.AddTypeS('TBindString', 'ULONG');
  CL.AddTypeS('TPiFlags', 'ULONG');
  CL.AddTypeS('TOIBdgFlags', 'ULONG');
  CL.AddTypeS('TParseAction', 'ULONG');
  CL.AddTypeS('TPSUAction', 'ULONG');
  CL.AddTypeS('TQueryOption', 'ULONG');
  CL.AddTypeS('TPUAF', 'ULONG');
  CL.AddTypeS('TSZMFlags', 'ULONG');
  CL.AddTypeS('TUrlZone', 'ULONG');
  CL.AddTypeS('TUrlTemplate', 'ULONG');
  CL.AddTypeS('TZAFlags', 'ULONG');
  CL.AddTypeS('TUrlZoneReg', 'ULONG');
 CL.AddConstantN('URLMON_OPTION_USERAGENT','LongWord').SetUInt( $10000001);
 CL.AddConstantN('URLMON_OPTION_USERAGENT_REFRESH','LongWord').SetUInt( $10000002);
 CL.AddConstantN('URLMON_OPTION_URL_ENCODING','LongWord').SetUInt( $10000004);
 CL.AddConstantN('URLMON_OPTION_USE_BINDSTRINGCREDS','LongWord').SetUInt( $10000008);
 CL.AddConstantN('CF_NULL','LongInt').SetInt( 0);
 CL.AddConstantN('CFSTR_MIME_NULL','LongInt').SetInt( 0);
 CL.AddConstantN('CFSTR_MIME_TEXT','String').SetString( 'text/plain');
 CL.AddConstantN('CFSTR_MIME_RICHTEXT','String').SetString( 'text/richtext');
 CL.AddConstantN('CFSTR_MIME_X_BITMAP','String').SetString( 'image/x-xbitmap');
 CL.AddConstantN('CFSTR_MIME_POSTSCRIPT','String').SetString( 'application/postscript');
 CL.AddConstantN('CFSTR_MIME_AIFF','String').SetString( 'audio/aiff');
 CL.AddConstantN('CFSTR_MIME_BASICAUDIO','String').SetString( 'audio/basic');
 CL.AddConstantN('CFSTR_MIME_WAV','String').SetString( 'audio/wav');
 CL.AddConstantN('CFSTR_MIME_X_WAV','String').SetString( 'audio/x-wav');
 CL.AddConstantN('CFSTR_MIME_GIF','String').SetString( 'image/gif');
 CL.AddConstantN('CFSTR_MIME_PJPEG','String').SetString( 'image/pjpeg');
 CL.AddConstantN('CFSTR_MIME_JPEG','String').SetString( 'image/jpeg');
 CL.AddConstantN('CFSTR_MIME_TIFF','String').SetString( 'image/tiff');
 CL.AddConstantN('CFSTR_MIME_X_PNG','String').SetString( 'image/x-png');
 CL.AddConstantN('CFSTR_MIME_BMP','String').SetString( 'image/bmp');
 CL.AddConstantN('CFSTR_MIME_X_ART','String').SetString( 'image/x-jg');
 CL.AddConstantN('CFSTR_MIME_X_EMF','String').SetString( 'image/x-emf');
 CL.AddConstantN('CFSTR_MIME_X_WMF','String').SetString( 'image/x-wmf');
 CL.AddConstantN('CFSTR_MIME_AVI','String').SetString( 'video/avi');
 CL.AddConstantN('CFSTR_MIME_MPEG','String').SetString( 'video/mpeg');
 CL.AddConstantN('CFSTR_MIME_FRACTALS','String').SetString( 'application/fractals');
 CL.AddConstantN('CFSTR_MIME_RAWDATA','String').SetString( 'application/octet-stream');
 CL.AddConstantN('CFSTR_MIME_RAWDATASTRM','String').SetString( 'application/octet-stream');
 CL.AddConstantN('CFSTR_MIME_PDF','String').SetString( 'application/pdf');
 CL.AddConstantN('CFSTR_MIME_X_AIFF','String').SetString( 'audio/x-aiff');
 CL.AddConstantN('CFSTR_MIME_X_REALAUDIO','String').SetString( 'audio/x-pn-realaudio');
 CL.AddConstantN('CFSTR_MIME_XBM','String').SetString( 'image/xbm');
 CL.AddConstantN('CFSTR_MIME_QUICKTIME','String').SetString( 'video/quicktime');
 CL.AddConstantN('CFSTR_MIME_X_MSVIDEO','String').SetString( 'video/x-msvideo');
 CL.AddConstantN('CFSTR_MIME_X_SGI_MOVIE','String').SetString( 'video/x-sgi-movie');
 CL.AddConstantN('CFSTR_MIME_HTML','String').SetString( 'text/html');
 CL.AddConstantN('MK_S_ASYNCHRONOUS','LongWord').SetUInt( $000401E8);
 CL.AddConstantN('S_ASYNCHRONOUS','LongWord').SetUInt( $000401E8);
 CL.AddConstantN('E_PENDING','LongWord').SetUInt( $8000000A);
 //CL.AddConstantN('INET_E_INVALID_URL','LongWord').SetUInt( HResult ( $800C0002 ));
 //CL.AddConstantN('INET_E_ERROR_FIRST','LongWord').SetUInt( HResult ( $800C0002 ));
// CL.AddConstantN('INET_E_ERROR_LAST','').SetString( INET_E_CODE_INSTALL_SUPPRESSED);
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IBinding, 'IBinding');
  SIRegister_IPersistMoniker(CL);
  SIRegister_IBindProtocol(CL);
  SIRegister_IBinding(CL);
 CL.AddConstantN('BINDVERB_GET','LongWord').SetUInt( $00000000);
 CL.AddConstantN('BINDVERB_POST','LongWord').SetUInt( $00000001);
 CL.AddConstantN('BINDVERB_PUT','LongWord').SetUInt( $00000002);
 CL.AddConstantN('BINDVERB_CUSTOM','LongWord').SetUInt( $00000003);
 CL.AddConstantN('BINDINFOF_URLENCODESTGMEDDATA','LongWord').SetUInt( $00000001);
 CL.AddConstantN('BINDINFOF_URLENCODEDEXTRAINFO','LongWord').SetUInt( $00000002);
 CL.AddConstantN('BINDF_ASYNCHRONOUS','LongWord').SetUInt( $00000001);
 CL.AddConstantN('BINDF_ASYNCSTORAGE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('BINDF_NOPROGRESSIVERENDERING','LongWord').SetUInt( $00000004);
 CL.AddConstantN('BINDF_OFFLINEOPERATION','LongWord').SetUInt( $00000008);
 CL.AddConstantN('BINDF_GETNEWESTVERSION','LongWord').SetUInt( $00000010);
 CL.AddConstantN('BINDF_NOWRITECACHE','LongWord').SetUInt( $00000020);
 CL.AddConstantN('BINDF_NEEDFILE','LongWord').SetUInt( $00000040);
 CL.AddConstantN('BINDF_PULLDATA','LongWord').SetUInt( $00000080);
 CL.AddConstantN('BINDF_IGNORESECURITYPROBLEM','LongWord').SetUInt( $00000100);
 CL.AddConstantN('BINDF_RESYNCHRONIZE','LongWord').SetUInt( $00000200);
 CL.AddConstantN('BINDF_HYPERLINK','LongWord').SetUInt( $00000400);
 CL.AddConstantN('BINDF_NO_UI','LongWord').SetUInt( $00000800);
 CL.AddConstantN('BINDF_SILENTOPERATION','LongWord').SetUInt( $00001000);
 CL.AddConstantN('BINDF_PRAGMA_NO_CACHE','LongWord').SetUInt( $00002000);
 CL.AddConstantN('BINDF_FREE_THREADED','LongWord').SetUInt( $00010000);
 CL.AddConstantN('BINDF_DIRECT_READ','LongWord').SetUInt( $00020000);
 CL.AddConstantN('BINDF_FORMS_SUBMIT','LongWord').SetUInt( $00040000);
 CL.AddConstantN('BINDF_GETFROMCACHE_IF_NET_FAIL','LongWord').SetUInt( $00080000);
 //CL.AddConstantN('BINDF_DONTUSECACHE','').SetString( BINDF_GETNEWESTVERSION);
 //CL.AddConstantN('BINDF_DONTPUTINCACHE','').SetString( BINDF_NOWRITECACHE);
 //CL.AddConstantN('BINDF_NOCOPYDATA','').SetString( BINDF_PULLDATA);
 CL.AddConstantN('BSCF_FIRSTDATANOTIFICATION','LongWord').SetUInt( $00000001);
 CL.AddConstantN('BSCF_INTERMEDIATEDATANOTIFICATION','LongWord').SetUInt( $00000002);
 CL.AddConstantN('BSCF_LASTDATANOTIFICATION','LongWord').SetUInt( $00000004);
 CL.AddConstantN('BSCF_DATAFULLYAVAILABLE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('BSCF_AVAILABLEDATASIZEUNKNOWN','LongWord').SetUInt( $00000010);
 CL.AddConstantN('BINDSTATUS_FINDINGRESOURCE','LongInt').SetInt( 1);
 CL.AddConstantN('BINDSTATUS_CONNECTING','LongInt').SetInt( BINDSTATUS_FINDINGRESOURCE + 1);
 CL.AddConstantN('BINDSTATUS_REDIRECTING','LongInt').SetInt( BINDSTATUS_CONNECTING + 1);
 CL.AddConstantN('BINDSTATUS_BEGINDOWNLOADDATA','LongInt').SetInt( BINDSTATUS_REDIRECTING + 1);
 CL.AddConstantN('BINDSTATUS_DOWNLOADINGDATA','LongInt').SetInt( BINDSTATUS_BEGINDOWNLOADDATA + 1);
 CL.AddConstantN('BINDSTATUS_ENDDOWNLOADDATA','LongInt').SetInt( BINDSTATUS_DOWNLOADINGDATA + 1);
 CL.AddConstantN('BINDSTATUS_BEGINDOWNLOADCOMPONENTS','LongInt').SetInt( BINDSTATUS_ENDDOWNLOADDATA + 1);
 CL.AddConstantN('BINDSTATUS_INSTALLINGCOMPONENTS','LongInt').SetInt( BINDSTATUS_BEGINDOWNLOADCOMPONENTS + 1);
 CL.AddConstantN('BINDSTATUS_ENDDOWNLOADCOMPONENTS','LongInt').SetInt( BINDSTATUS_INSTALLINGCOMPONENTS + 1);
 CL.AddConstantN('BINDSTATUS_USINGCACHEDCOPY','LongInt').SetInt( BINDSTATUS_ENDDOWNLOADCOMPONENTS + 1);
 CL.AddConstantN('BINDSTATUS_SENDINGREQUEST','LongInt').SetInt( BINDSTATUS_USINGCACHEDCOPY + 1);
 CL.AddConstantN('BINDSTATUS_CLASSIDAVAILABLE','LongInt').SetInt( BINDSTATUS_SENDINGREQUEST + 1);
 CL.AddConstantN('BINDSTATUS_MIMETYPEAVAILABLE','LongInt').SetInt( BINDSTATUS_CLASSIDAVAILABLE + 1);
 CL.AddConstantN('BINDSTATUS_CACHEFILENAMEAVAILABLE','LongInt').SetInt( BINDSTATUS_MIMETYPEAVAILABLE + 1);
 CL.AddConstantN('BINDSTATUS_BEGINSYNCOPERATION','LongInt').SetInt( BINDSTATUS_CACHEFILENAMEAVAILABLE + 1);
 CL.AddConstantN('BINDSTATUS_ENDSYNCOPERATION','LongInt').SetInt( BINDSTATUS_BEGINSYNCOPERATION + 1);
 CL.AddConstantN('BINDSTATUS_BEGINUPLOADDATA','LongInt').SetInt( BINDSTATUS_ENDSYNCOPERATION + 1);
 CL.AddConstantN('BINDSTATUS_UPLOADINGDATA','LongInt').SetInt( BINDSTATUS_BEGINUPLOADDATA + 1);
 CL.AddConstantN('BINDSTATUS_ENDUPLOADDATA','LongInt').SetInt( BINDSTATUS_UPLOADINGDATA + 1);
 CL.AddConstantN('BINDSTATUS_PROTOCOLCLASSID','LongInt').SetInt( BINDSTATUS_ENDUPLOADDATA + 1);
 CL.AddConstantN('BINDSTATUS_ENCODING','LongInt').SetInt( BINDSTATUS_PROTOCOLCLASSID + 1);
 CL.AddConstantN('BINDSTATUS_VERIFIEDMIMETYPEAVAILABLE','LongInt').SetInt( BINDSTATUS_ENCODING + 1);
 CL.AddConstantN('BINDSTATUS_CLASSINSTALLLOCATION','LongInt').SetInt( BINDSTATUS_VERIFIEDMIMETYPEAVAILABLE + 1);
 CL.AddConstantN('BINDSTATUS_DECODING','LongInt').SetInt( BINDSTATUS_CLASSINSTALLLOCATION + 1);
 CL.AddConstantN('BINDSTATUS_LOADINGMIMEHANDLER','LongInt').SetInt( BINDSTATUS_DECODING + 1);
 CL.AddConstantN('BINDSTATUS_CONTENTDISPOSITIONATTACH','LongInt').SetInt( BINDSTATUS_LOADINGMIMEHANDLER + 1);
 CL.AddConstantN('BINDSTATUS_FILTERREPORTMIMETYPE','LongInt').SetInt( BINDSTATUS_CONTENTDISPOSITIONATTACH + 1);
 CL.AddConstantN('BINDSTATUS_CLSIDCANINSTANTIATE','LongInt').SetInt( BINDSTATUS_FILTERREPORTMIMETYPE + 1);
 CL.AddConstantN('BINDSTATUS_IUNKNOWNAVAILABLE','LongInt').SetInt( BINDSTATUS_CLSIDCANINSTANTIATE + 1);
 CL.AddConstantN('BINDSTATUS_DIRECTBIND','LongInt').SetInt( BINDSTATUS_IUNKNOWNAVAILABLE + 1);
 CL.AddConstantN('BINDSTATUS_RAWMIMETYPE','LongInt').SetInt( BINDSTATUS_DIRECTBIND + 1);
 CL.AddConstantN('BINDSTATUS_PROXYDETECTING','LongInt').SetInt( BINDSTATUS_RAWMIMETYPE + 1);
 CL.AddConstantN('BINDSTATUS_ACCEPTRANGES','LongInt').SetInt( BINDSTATUS_PROXYDETECTING + 1);
 CL.AddConstantN('BINDSTATUS_COOKIE_SENT','LongInt').SetInt( BINDSTATUS_ACCEPTRANGES + 1);
 CL.AddConstantN('BINDSTATUS_COMPACT_POLICY_RECEIVED','LongInt').SetInt( BINDSTATUS_COOKIE_SENT + 1);
 CL.AddConstantN('BINDSTATUS_COOKIE_SUPPRESSED','LongInt').SetInt( BINDSTATUS_COMPACT_POLICY_RECEIVED + 1);
 CL.AddConstantN('BINDSTATUS_COOKIE_STATE_UNKNOWN','LongInt').SetInt( BINDSTATUS_COOKIE_SUPPRESSED + 1);
 CL.AddConstantN('BINDSTATUS_COOKIE_STATE_ACCEPT','LongInt').SetInt( BINDSTATUS_COOKIE_STATE_UNKNOWN + 1);
 CL.AddConstantN('BINDSTATUS_COOKIE_STATE_REJECT','LongInt').SetInt( BINDSTATUS_COOKIE_STATE_ACCEPT + 1);
 CL.AddConstantN('BINDSTATUS_COOKIE_STATE_PROMPT','LongInt').SetInt( BINDSTATUS_COOKIE_STATE_REJECT + 1);
 CL.AddConstantN('BINDSTATUS_COOKIE_STATE_LEASH','LongInt').SetInt( BINDSTATUS_COOKIE_STATE_PROMPT + 1);
 CL.AddConstantN('BINDSTATUS_COOKIE_STATE_DOWNGRADE','LongInt').SetInt( BINDSTATUS_COOKIE_STATE_LEASH + 1);
 CL.AddConstantN('BINDSTATUS_POLICY_HREF','LongInt').SetInt( BINDSTATUS_COOKIE_STATE_DOWNGRADE + 1);
 CL.AddConstantN('BINDSTATUS_P3P_HEADER','LongInt').SetInt( BINDSTATUS_POLICY_HREF + 1);
 CL.AddConstantN('BINDSTATUS_SESSION_COOKIE_RECEIVED','LongInt').SetInt( BINDSTATUS_P3P_HEADER + 1);
 CL.AddConstantN('BINDSTATUS_PERSISTENT_COOKIE_RECEIVED','LongInt').SetInt( BINDSTATUS_SESSION_COOKIE_RECEIVED + 1);
 CL.AddConstantN('BINDSTATUS_SESSION_COOKIES_ALLOWED','LongInt').SetInt( BINDSTATUS_PERSISTENT_COOKIE_RECEIVED + 1);
 CL.AddConstantN('BINDSTATUS_CACHECONTROL','LongInt').SetInt( BINDSTATUS_SESSION_COOKIES_ALLOWED + 1);
 CL.AddConstantN('BINDSTATUS_CONTENTDISPOSITIONFILENAME','LongInt').SetInt( BINDSTATUS_CACHECONTROL + 1);
 CL.AddConstantN('BINDSTATUS_MIMETEXTPLAINMISMATCH','LongInt').SetInt( BINDSTATUS_CONTENTDISPOSITIONFILENAME + 1);
 CL.AddConstantN('BINDSTATUS_PUBLISHERAVAILABLE','LongInt').SetInt( BINDSTATUS_MIMETEXTPLAINMISMATCH + 1);
 CL.AddConstantN('BINDSTATUS_DISPLAYNAMEAVAILABLE','LongInt').SetInt( BINDSTATUS_PUBLISHERAVAILABLE + 1);
 // CL.AddTypeS('PBindInfo', '^TBindInfo // will not work');
  {CL.AddTypeS('_tagBINDINFO', 'record cbSize : ULONG; szExtraInfo : LPWSTR; stg'
   +'medData : TStgMedium; grfBindInfoF : DWORD; dwBindVerb : DWORD; szCustomVe'
   +'rb : LPWSTR; cbstgmedData : DWORD; dwOptions : DWORD; dwOptionsFlags : DWO'
   +'RD; dwCodePage : DWORD; securityAttributes : TSecurityAttributes; iid : TG'
   +'UID; pUnk : IUnknown; dwReserved : DWORD; end');
  CL.AddTypeS('TBindInfo', '_tagBINDINFO');
  CL.AddTypeS('BINDINFO', '_tagBINDINFO');}
  CL.AddTypeS('_REMSECURITY_ATTRIBUTES', 'record nLength : DWORD; lpSecurityDes'
   +'criptor : DWORD; bInheritHandle : BOOL; end');
  CL.AddTypeS('TRemSecurityAttributes', '_REMSECURITY_ATTRIBUTES');
  CL.AddTypeS('REMSECURITY_ATTRIBUTES', '_REMSECURITY_ATTRIBUTES');
  //CL.AddTypeS('PRemBindInfo', '^TRemBindInfo // will not work');
  {CL.AddTypeS('_tagRemBINDINFO', 'record cbSize : ULONG; szExtraInfo : LPWSTR; '
   +'grfBindInfoF : DWORD; dwBindVerb : DWORD; szCustomVerb : LPWSTR; cbstgmedD'
   +'ata : DWORD; dwOptions : DWORD; dwOptionsFlags : DWORD; dwCodePage : DWORD'
   +'; securityAttributes : TRemSecurityAttributes; iid : TGUID; pUnk : IUnknow'
   +'n; dwReserved : DWORD; end');
  CL.AddTypeS('TRemBindInfo', '_tagRemBINDINFO');
  CL.AddTypeS('RemBINDINFO', '_tagRemBINDINFO');}
  //CL.AddTypeS('PRemFormatEtc', '^TRemFormatEtc // will not work');
  CL.AddTypeS('tagRemFORMATETC', 'record cfFormat : DWORD; ptd : DWORD; dwAspect : DWORD; lindex : Longint; tymed : DWORD; end');
  CL.AddTypeS('TRemFormatEtc', 'tagRemFORMATETC');
  CL.AddTypeS('RemFORMATETC', 'tagRemFORMATETC');
  SIRegister_IBindStatusCallback(CL);
  SIRegister_IAuthenticate(CL);
  SIRegister_IHttpNegotiate(CL);
  SIRegister_IWindowForBindingUI(CL);
 CL.AddConstantN('CIP_DISK_FULL','LongInt').SetInt( 0);
 CL.AddConstantN('CIP_ACCESS_DENIED','LongInt').SetInt( CIP_DISK_FULL + 1);
 CL.AddConstantN('CIP_NEWER_VERSION_EXISTS','LongInt').SetInt( CIP_ACCESS_DENIED + 1);
 CL.AddConstantN('CIP_OLDER_VERSION_EXISTS','LongInt').SetInt( CIP_NEWER_VERSION_EXISTS + 1);
 CL.AddConstantN('CIP_NAME_CONFLICT','LongInt').SetInt( CIP_OLDER_VERSION_EXISTS + 1);
 CL.AddConstantN('CIP_TRUST_VERIFICATION_COMPONENT_MISSING','LongInt').SetInt( CIP_NAME_CONFLICT + 1);
 CL.AddConstantN('CIP_EXE_SELF_REGISTERATION_TIMEOUT','LongInt').SetInt( CIP_TRUST_VERIFICATION_COMPONENT_MISSING + 1);
 CL.AddConstantN('CIP_UNSAFE_TO_ABORT','LongInt').SetInt( CIP_EXE_SELF_REGISTERATION_TIMEOUT + 1);
 CL.AddConstantN('CIP_NEED_REBOOT','LongInt').SetInt( CIP_UNSAFE_TO_ABORT + 1);
 CL.AddConstantN('CIP_NEED_REBOOT_UI_PERMISSION','LongInt').SetInt( CIP_NEED_REBOOT + 1);
  SIRegister_ICodeInstall(CL);
  SIRegister_IWinInetInfo(CL);
 CL.AddConstantN('WININETINFO_OPTION_LOCK_HANDLE','LongInt').SetInt( 65534);
  SIRegister_IHttpSecurity(CL);
  SIRegister_IWinInetHttpInfo(CL);
  SIRegister_IBindHost(CL);
 CL.AddConstantN('URLOSTRM_USECACHEDCOPY_ONLY','LongWord').SetUInt( $00000001);
 CL.AddConstantN('URLOSTRM_USECACHEDCOPY','LongWord').SetUInt( $00000002);
 CL.AddConstantN('URLOSTRM_GETNEWESTVERSION','LongWord').SetUInt( $00000003);
// CL.AddDelphiFunction('Function HlinkSimpleNavigateToString( szTarget, szLocation, szTargetFrameName : LPCWSTR; Unk : IUnknown; pbc : IBindCtx; BSC : IBindStatusCallback; grfHLNF, dwReserved : DWORD) : HResult');
 //CL.AddDelphiFunction('Function HlinkSimpleNavigateToMoniker( mkTarget : Imoniker; szLocation, szTargetFrameName : LPCWSTR; Unk : IUnknown; bc : IBindCtx; BSC : IBindStatusCallback; grfHLNF, dwReserved : DWORD) : HResult');
 //CL.AddDelphiFunction('Function CreateURLMoniker( MkCtx : IMoniker; szURL : LPCWSTR; out mk : IMoniker) : HResult');
 //CL.AddDelphiFunction('Function GetClassURL( szURL : LPCWSTR; const ClsID : TCLSID) : HResult');
 {CL.AddDelphiFunction('Function CreateAsyncBindCtx( reserved : DWORD; pBSCb : IBindStatusCallback; pEFetc : IEnumFORMATETC; out ppBC : IBindCtx) : HResult');
 CL.AddDelphiFunction('Function CreateAsyncBindCtxEx( pbc : IBindCtx; dwOptions : DWORD; BSCb : IBindStatusCallback; Enum : IEnumFORMATETC; out ppBC : IBindCtx; reserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function MkParseDisplayNameEx( pbc : IBindCtx; szDisplayName : LPCWSTR; out pchEaten : ULONG; out ppmk : IMoniker) : HResult');
 CL.AddDelphiFunction('Function RegisterBindStatusCallback( pBC : IBindCtx; pBSCb : IBindStatusCallback; out ppBSCBPrev : IBindStatusCallback; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function RevokeBindStatusCallback( pBC : IBindCtx; pBSCb : IBindStatusCallback) : HResult');
 CL.AddDelphiFunction('Function GetClassFileOrMime( pBC : IBindCtx; szFilename : LPCWSTR; pBuffer : Pointer; cbSize : DWORD; szMime : LPCWSTR; dwReserved : DWORD; out pclsid : TCLSID) : HResult');
 CL.AddDelphiFunction('Function IsValidURL( pBC : IBindCtx; szURL : LPCWSTR; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function CoGetClassObjectFromURL( const rCLASSID : TCLSID; szCODE : LPCWSTR; dwFileVersionMS, dwFileVersionLS : DWORD; szTYPE : LPCWSTR; pBindCtx : IBindCtx; dwClsContext : DWORD; pvReserved : Pointer; const riid : TGUID; out ppv) : HResult');
 CL.AddDelphiFunction('Function IsAsyncMoniker( pmk : IMoniker) : HResult');
 CL.AddDelphiFunction('Function CreateURLBinding( lpszUrl : LPCWSTR; pbc : IBindCtx; out ppBdg : IBinding) : HResult');
 CL.AddDelphiFunction('Function RegisterMediaTypes( ctypes : UINT; const rgszTypes : LPCSTR; const rgcfTypes : TClipFormat) : HResult');
 CL.AddDelphiFunction('Function FindMediaType( rgszTypes : LPCSTR; rgcfTypes : PClipFormat) : HResult');
 CL.AddDelphiFunction('Function CreateFormatEnumerator( cfmtetc : UINT; const rgfmtetc : TFormatEtc; out ppenumfmtetc : IEnumFormatEtc) : HResult');
 CL.AddDelphiFunction('Function RegisterFormatEnumerator( pBC : IBindCtx; pEFetc : IEnumFormatEtc; reserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function RevokeFormatEnumerator( pBC : IBindCtx; pEFetc : IEnumFormatEtc) : HResult');
 CL.AddDelphiFunction('Function RegisterMediaTypeClass( pBC : IBindCtx; ctypes : UINT; const rgszTypes : LPCSTR; rgclsID : PCLSID; reserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function FindMediaTypeClass( pBC : IBindCtx; szType : LPCSTR; const pclsID : TCLSID; reserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function UrlMkSetSessionOption( dwOption : DWORD; pBuffer : Pointer; dwBufferLength, dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function UrlMkGetSessionOption( dwOption : DWORD; pBuffer : Pointer; dwBufferLength : DWORD; out pdwBufferLength : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function FindMimeFromData( pBC : IBindCtx; pwzUrl : LPCWSTR; pBuffer : Pointer; cbSize : DWORD; pwzMimeProposed : LPCWSTR; dwMimeFlags : DWORD; out ppwzMimeOut : LPWSTR; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function ObtainUserAgentString( dwOption : DWORD; pszUAOut : LPSTR; var cbSize : DWORD) : HResult');}
 CL.AddDelphiFunction('Function URLOpenStream( p1 : IUnknown; p2 : PChar; p3 : DWORD; p4 : IBindStatusCallback) : HResult');
// CL.AddDelphiFunction('Function URLOpenStreamA( p1 : IUnknown; p2 : PAnsiChar; p3 : DWORD; p4 : IBindStatusCallback) : HResult');
 //CL.AddDelphiFunction('Function URLOpenStreamW( p1 : IUnknown; p2 : PWideChar; p3 : DWORD; p4 : IBindStatusCallback) : HResult');
 CL.AddDelphiFunction('Function URLOpenPullStream( p1 : IUnknown; p2 : PChar; p3 : DWORD; BSC : IBindStatusCallback) : HResult');
 //7CL.AddDelphiFunction('Function URLOpenPullStreamA( p1 : IUnknown; p2 : PAnsiChar; p3 : DWORD; BSC : IBindStatusCallback) : HResult');
 //CL.AddDelphiFunction('Function URLOpenPullStreamW( p1 : IUnknown; p2 : PWideChar; p3 : DWORD; BSC : IBindStatusCallback) : HResult');
 CL.AddDelphiFunction('Function URLDownloadToFile( Caller : IUnknown; URL : PChar; FileName : PChar; Reserved : DWORD; StatusCB : IBindStatusCallback) : HResult');
 //CL.AddDelphiFunction('Function URLDownloadToFileA( Caller : IUnknown; URL : PAnsiChar; FileName : PAnsiChar; Reserved : DWORD; StatusCB : IBindStatusCallback) : HResult');
 //CL.AddDelphiFunction('Function URLDownloadToFileW( Caller : IUnknown; URL : PWideChar; FileName : PWideChar; Reserved : DWORD; StatusCB : IBindStatusCallback) : HResult');
 CL.AddDelphiFunction('Function URLDownloadToCacheFile( p1 : IUnknown; p2 : PChar; p3 : PChar; p4 : DWORD; p5 : DWORD; p6 : IBindStatusCallback) : HResult');
 //CL.AddDelphiFunction('Function URLDownloadToCacheFileA( p1 : IUnknown; p2 : PAnsiChar; p3 : PAnsiChar; p4 : DWORD; p5 : DWORD; p6 : IBindStatusCallback) : HResult');
 //CL.AddDelphiFunction('Function URLDownloadToCacheFileW( p1 : IUnknown; p2 : PWideChar; p3 : PWideChar; p4 : DWORD; p5 : DWORD; p6 : IBindStatusCallback) : HResult');
 CL.AddDelphiFunction('Function URLOpenBlockingStream( p1 : IUnknown; p2 : PChar; out p3 : IStream; p4 : DWORD; p5 : IBindStatusCallback) : HResult');
 //CL.AddDelphiFunction('Function URLOpenBlockingStreamA( p1 : IUnknown; p2 : PAnsiChar; out p3 : IStream; p4 : DWORD; p5 : IBindStatusCallback) : HResult');
 //CL.AddDelphiFunction('Function URLOpenBlockingStreamW( p1 : IUnknown; p2 : PWideChar; out p3 : IStream; p4 : DWORD; p5 : IBindStatusCallback) : HResult');
 CL.AddDelphiFunction('Function HlinkGoBack( unk : IUnknown) : HResult');
 CL.AddDelphiFunction('Function HlinkGoForward( unk : IUnknown) : HResult');
 CL.AddDelphiFunction('Function HlinkNavigateString( unk : IUnknown; szTarget : LPCWSTR) : HResult');
// CL.AddDelphiFunction('Function HlinkNavigateMoniker( Unk : IUnknown; mkTarget : IMoniker) : HResult');
  SIRegister_IInternet(CL);
 CL.AddConstantN('BINDSTRING_HEADERS','LongInt').SetInt( 1);
 CL.AddConstantN('BINDSTRING_ACCEPT_MIMES','LongInt').SetInt( BINDSTRING_HEADERS + 1);
 CL.AddConstantN('BINDSTRING_EXTRA_URL','LongInt').SetInt( BINDSTRING_ACCEPT_MIMES + 1);
 CL.AddConstantN('BINDSTRING_LANGUAGE','LongInt').SetInt( BINDSTRING_EXTRA_URL + 1);
 CL.AddConstantN('BINDSTRING_USERNAME','LongInt').SetInt( BINDSTRING_LANGUAGE + 1);
 CL.AddConstantN('BINDSTRING_PASSWORD','LongInt').SetInt( BINDSTRING_USERNAME + 1);
 CL.AddConstantN('BINDSTRING_UA_PIXELS','LongInt').SetInt( BINDSTRING_PASSWORD + 1);
 CL.AddConstantN('BINDSTRING_UA_COLOR','LongInt').SetInt( BINDSTRING_UA_PIXELS + 1);
 CL.AddConstantN('BINDSTRING_OS','LongInt').SetInt( BINDSTRING_UA_COLOR + 1);
 CL.AddConstantN('BINDSTRING_USER_AGENT','LongInt').SetInt( BINDSTRING_OS + 1);
 CL.AddConstantN('BINDSTRING_ACCEPT_ENCODINGS','LongInt').SetInt( BINDSTRING_USER_AGENT + 1);
 CL.AddConstantN('BINDSTRING_POST_COOKIE','LongInt').SetInt( BINDSTRING_ACCEPT_ENCODINGS + 1);
 CL.AddConstantN('BINDSTRING_POST_DATA_MIME','LongInt').SetInt( BINDSTRING_POST_COOKIE + 1);
 CL.AddConstantN('BINDSTRING_URL','LongInt').SetInt( BINDSTRING_POST_DATA_MIME + 1);
  //CL.AddTypeS('POLEStrArray', '^TOLESTRArray // will not work');
  SIRegister_IInternetBindInfo(CL);
 CL.AddConstantN('PI_PARSE_URL','LongWord').SetUInt( $00000001);
 CL.AddConstantN('PI_FILTER_MODE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('PI_FORCE_ASYNC','LongWord').SetUInt( $00000004);
 CL.AddConstantN('PI_USE_WORKERTHREAD','LongWord').SetUInt( $00000008);
 CL.AddConstantN('PI_MIMEVERIFICATION','LongWord').SetUInt( $00000010);
 CL.AddConstantN('PI_CLSIDLOOKUP','LongWord').SetUInt( $00000020);
 CL.AddConstantN('PI_DATAPROGRESS','LongWord').SetUInt( $00000040);
 CL.AddConstantN('PI_SYNCHRONOUS','LongWord').SetUInt( $00000080);
 CL.AddConstantN('PI_APARTMENTTHREADED','LongWord').SetUInt( $00000100);
 CL.AddConstantN('PI_CLASSINSTALL','LongWord').SetUInt( $00000200);
 CL.AddConstantN('PD_FORCE_SWITCH','LongWord').SetUInt( $00010000);
 //CL.AddConstantN('PI_DOCFILECLSIDLOOKUP','').SetString( PI_CLSIDLOOKUP);
  //CL.AddTypeS('PProtocolData', '^TProtocolData // will not work');
  CL.AddTypeS('_tagPROTOCOLDATA', 'record grfFlags : DWORD; dwState : DWORD; pData : TObject; cbData : ULONG; end');
  CL.AddTypeS('TProtocolData', '_tagPROTOCOLDATA');
  CL.AddTypeS('PROTOCOLDATA', '_tagPROTOCOLDATA');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInternetProtocolSink, 'IInternetProtocolSink');
  SIRegister_IInternetProtocolRoot(CL);
  SIRegister_IInternetProtocol(CL);
  SIRegister_IInternetProtocolSink(CL);
 CL.AddConstantN('OIBDG_APARTMENTTHREADED','LongWord').SetUInt( $00000100);
  SIRegister_IInternetSession(CL);
  SIRegister_IInternetThreadSwitch(CL);
  SIRegister_IInternetPriority(CL);
 CL.AddConstantN('PARSE_CANONICALIZE','LongInt').SetInt( 1);
 CL.AddConstantN('PARSE_FRIENDLY','LongInt').SetInt( PARSE_CANONICALIZE + 1);
 CL.AddConstantN('PARSE_SECURITY_URL','LongInt').SetInt( PARSE_FRIENDLY + 1);
 CL.AddConstantN('PARSE_ROOTDOCUMENT','LongInt').SetInt( PARSE_SECURITY_URL + 1);
 CL.AddConstantN('PARSE_DOCUMENT','LongInt').SetInt( PARSE_ROOTDOCUMENT + 1);
 CL.AddConstantN('PARSE_ANCHOR','LongInt').SetInt( PARSE_DOCUMENT + 1);
 CL.AddConstantN('PARSE_ENCODE','LongInt').SetInt( PARSE_ANCHOR + 1);
 CL.AddConstantN('PARSE_DECODE','LongInt').SetInt( PARSE_ENCODE + 1);
 CL.AddConstantN('PARSE_PATH_FROM_URL','LongInt').SetInt( PARSE_DECODE + 1);
 CL.AddConstantN('PARSE_URL_FROM_PATH','LongInt').SetInt( PARSE_PATH_FROM_URL + 1);
 CL.AddConstantN('PARSE_MIME','LongInt').SetInt( PARSE_URL_FROM_PATH + 1);
 CL.AddConstantN('PARSE_SERVER','LongInt').SetInt( PARSE_MIME + 1);
 CL.AddConstantN('PARSE_SCHEMA','LongInt').SetInt( PARSE_SERVER + 1);
 CL.AddConstantN('PARSE_SITE','LongInt').SetInt( PARSE_SCHEMA + 1);
 CL.AddConstantN('PARSE_DOMAIN','LongInt').SetInt( PARSE_SITE + 1);
 CL.AddConstantN('PARSE_LOCATION','LongInt').SetInt( PARSE_DOMAIN + 1);
 CL.AddConstantN('PARSE_SECURITY_DOMAIN','LongInt').SetInt( PARSE_LOCATION + 1);
 CL.AddConstantN('PSU_DEFAULT','LongInt').SetInt( 1);
 CL.AddConstantN('PSU_SECURITY_URL_ONLY','LongInt').SetInt( PSU_DEFAULT + 1);
 CL.AddConstantN('QUERY_EXPIRATION_DATE','LongInt').SetInt( 1);
 CL.AddConstantN('QUERY_TIME_OF_LAST_CHANGE','LongInt').SetInt( QUERY_EXPIRATION_DATE + 1);
 CL.AddConstantN('QUERY_CONTENT_ENCODING','LongInt').SetInt( QUERY_TIME_OF_LAST_CHANGE + 1);
 CL.AddConstantN('QUERY_CONTENT_TYPE','LongInt').SetInt( QUERY_CONTENT_ENCODING + 1);
 CL.AddConstantN('QUERY_REFRESH','LongInt').SetInt( QUERY_CONTENT_TYPE + 1);
 CL.AddConstantN('QUERY_RECOMBINE','LongInt').SetInt( QUERY_REFRESH + 1);
 CL.AddConstantN('QUERY_CAN_NAVIGATE','LongInt').SetInt( QUERY_RECOMBINE + 1);
 CL.AddConstantN('QUERY_USES_NETWORK','LongInt').SetInt( QUERY_CAN_NAVIGATE + 1);
 CL.AddConstantN('QUERY_IS_CACHED','LongInt').SetInt( QUERY_USES_NETWORK + 1);
 CL.AddConstantN('QUERY_IS_INSTALLEDENTRY','LongInt').SetInt( QUERY_IS_CACHED + 1);
 CL.AddConstantN('QUERY_IS_CACHED_OR_MAPPED','LongInt').SetInt( QUERY_IS_INSTALLEDENTRY + 1);
 CL.AddConstantN('QUERY_USES_CACHE','LongInt').SetInt( QUERY_IS_CACHED_OR_MAPPED + 1);
 CL.AddConstantN('QUERY_IS_SECURE','LongInt').SetInt( QUERY_USES_CACHE + 1);
 CL.AddConstantN('QUERY_IS_SAFE','LongInt').SetInt( QUERY_IS_SECURE + 1);
  SIRegister_IInternetProtocolInfo(CL);
  CL.AddTypeS('IOInet', 'IInternet');
  CL.AddTypeS('IOInetBindInfo', 'IInternetBindInfo');
  CL.AddTypeS('IOInetProtocolRoot', 'IInternetProtocolRoot');
  CL.AddTypeS('IOInetProtocol', 'IInternetProtocol');
  CL.AddTypeS('IOInetProtocolSink', 'IInternetProtocolSink');
  CL.AddTypeS('IOInetProtocolInfo', 'IInternetProtocolInfo');
  CL.AddTypeS('IOInetSession', 'IInternetSession');
  CL.AddTypeS('IOInetPriority', 'IInternetPriority');
  CL.AddTypeS('IOInetThreadSwitch', 'IInternetThreadSwitch');
 CL.AddDelphiFunction('Function CoInternetParseUrl( pwzUrl : LPCWSTR; ParseAction : TParseAction; dwFlags : DWORD; pszResult : LPWSTR; cchResult : DWORD; var pcchResult : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function CoInternetCombineUrl( pwzBaseUrl, pwzRelativeUrl : LPCWSTR; dwCombineFlags : DWORD; pszResult : LPWSTR; cchResult : DWORD; var pcchResult : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function CoInternetCompareUrl( pwzUrl1, pwzUrl2 : LPCWSTR; dwFlags : DWORD) : HResult');
 CL.AddDelphiFunction('Function CoInternetGetProtocolFlags( pwzUrl : LPCWSTR; var dwFlags : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function CoInternetQueryInfo( pwzUrl : LPCWSTR; QueryOptions : TQueryOption; dwQueryFlags : DWORD; pvBuffer : TObject; cbBuffer : DWORD; var pcbBuffer : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function CoInternetGetSession( dwSessionMode : DWORD; var pIInternetSession : IInternetSession; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function CoInternetGetSecurityUrl( pwzUrl : LPCWSTR; var pwzSecUrl : LPWSTR; psuAction : TPSUAction; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function OInetParseUrl( pwzUrl : LPCWSTR; ParseAction : TParseAction; dwFlags : DWORD; pszResult : LPWSTR; cchResult : DWORD; var pcchResult : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function OInetCombineUrl( pwzBaseUrl, pwzRelativeUrl : LPCWSTR; dwCombineFlags : DWORD; pszResult : LPWSTR; cchResult : DWORD; var pcchResult : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function OInetCompareUrl( pwzUrl1, pwzUrl2 : LPCWSTR; dwFlags : DWORD) : Hresult');
 CL.AddDelphiFunction('Function OInetGetProtocolFlags( pwzUrl : LPCWSTR; var dwFlags : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function OInetQueryInfo( pwzUrl : LPCWSTR; QueryOptions : TQueryOption; dwQueryFlags : DWORD; pvBuffer : TObject; cbBuffer : DWORD; var pcbBuffer : DWORD; dwReserved : DWORD) : HResult');
 CL.AddDelphiFunction('Function OInetGetSession( dwSessionMode : DWORD; var pIInternetSession : IInternetSession; dwReserved : DWORD) : HResult');
 //CL.AddDelphiFunction('Function OInetGetSecurityUrl( pwzUrl : LPCWSTR; var pwzSecUrl : LPWSTR; psuAction : TPSUAction; dwReserved : DWORD) : HResult');
 //CL.AddDelphiFunction('Function CopyStgMedium( const cstgmedSrc : TStgMedium; var stgmedDest : TStgMedium) : HResult');
 //CL.AddDelphiFunction('Function CopyBindInfo( const cbiSrc : TBindInfo; var biDest : TBindInfo) : HResult');
 //CL.AddDelphiFunction('Procedure ReleaseBindInfo( const bindinfo : TBindInfo)');
// CL.AddConstantN('INET_E_USE_DEFAULT_PROTOCOLHANDLER','LongWord').SetUInt( HResult ( $800C0011 ));
// CL.AddConstantN('INET_E_USE_DEFAULT_SETTING','LongWord').SetUInt( HResult ( $800C0012 ));
 //CL.AddConstantN('INET_E_DEFAULT_ACTION','LongWord').SetUInt( HResult ( $800C0011 ));
 //CL.AddConstantN('INET_E_QUERYOPTION_UNKNOWN','LongWord').SetUInt( HResult ( $800C0013 ));
 //CL.AddConstantN('INET_E_REDIRECTING','LongWord').SetUInt( HResult ( $800C0014 ));
 CL.AddConstantN('PROTOCOLFLAG_NO_PICS_CHECK','LongWord').SetUInt( $00000001);
  SIRegister_IInternetSecurityMgrSite(CL);
 CL.AddConstantN('MUTZ_NOSAVEDFILECHECK','LongWord').SetUInt( $00000001);
 CL.AddConstantN('MUTZ_ISFILE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('MUTZ_ACCEPT_WILDCARD_SCHEME','LongWord').SetUInt( $00000080);
 CL.AddConstantN('MUTZ_ENFORCERESTRICTED','LongWord').SetUInt( $00000100);
 CL.AddConstantN('MUTZ_REQUIRESAVEDFILECHECK','LongWord').SetUInt( $00000400);
 CL.AddConstantN('MAX_SIZE_SECURITY_ID','LongInt').SetInt( 512);
 CL.AddConstantN('PUAF_DEFAULT','LongWord').SetUInt( $00000000);
 CL.AddConstantN('PUAF_NOUI','LongWord').SetUInt( $00000001);
 CL.AddConstantN('PUAF_ISFILE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('PUAF_WARN_IF_DENIED','LongWord').SetUInt( $00000004);
 CL.AddConstantN('PUAF_FORCEUI_FOREGROUND','LongWord').SetUInt( $00000008);
 CL.AddConstantN('PUAF_CHECK_TIFS','LongWord').SetUInt( $00000010);
 CL.AddConstantN('PUAF_DONTCHECKBOXINDIALOG','LongWord').SetUInt( $00000020);
 CL.AddConstantN('PUAF_TRUSTED','LongWord').SetUInt( $00000040);
 CL.AddConstantN('PUAF_ACCEPT_WILDCARD_SCHEME','LongWord').SetUInt( $00000080);
 CL.AddConstantN('PUAF_ENFORCERESTRICTED','LongWord').SetUInt( $00000100);
 CL.AddConstantN('PUAF_NOSAVEDFILECHECK','LongWord').SetUInt( $00000200);
 CL.AddConstantN('PUAF_REQUIRESAVEDFILECHECK','LongWord').SetUInt( $00000400);
 CL.AddConstantN('PUAF_LMZ_UNLOCKED','LongWord').SetUInt( $00010000);
 CL.AddConstantN('PUAF_LMZ_LOCKED','LongWord').SetUInt( $00020000);
 CL.AddConstantN('PUAF_DEFAULTZONEPOL','LongWord').SetUInt( $00040000);
 CL.AddConstantN('PUAF_NPL_USE_LOCKED_IF_RESTRICTED','LongWord').SetUInt( $00080000);
 CL.AddConstantN('PUAF_NOUIIFLOCKED','LongWord').SetUInt( $00100000);
 CL.AddConstantN('PUAFOUT_DEFAULT','LongWord').SetUInt( $0);
 CL.AddConstantN('PUAFOUT_ISLOCKZONEPOLICY','LongWord').SetUInt( $1);
 CL.AddConstantN('SZM_CREATE','LongWord').SetUInt( $00000000);
 CL.AddConstantN('SZM_DELETE','LongWord').SetUInt( $00000001);
  SIRegister_IInternetSecurityManager(CL);
  SIRegister_IInternetHostSecurityManager(CL);
  SIRegister_IInternetSecurityManagerEx(CL);
 CL.AddConstantN('URLACTION_MIN','LongWord').SetUInt( $00001000);
 CL.AddConstantN('URLACTION_DOWNLOAD_MIN','LongWord').SetUInt( $00001000);
 CL.AddConstantN('URLACTION_DOWNLOAD_SIGNED_ACTIVEX','LongWord').SetUInt( $00001001);
 CL.AddConstantN('URLACTION_DOWNLOAD_UNSIGNED_ACTIVEX','LongWord').SetUInt( $00001004);
 CL.AddConstantN('URLACTION_DOWNLOAD_CURR_MAX','LongWord').SetUInt( $00001004);
 CL.AddConstantN('URLACTION_DOWNLOAD_MAX','LongWord').SetUInt( $000011FF);
 CL.AddConstantN('URLACTION_ACTIVEX_MIN','LongWord').SetUInt( $00001200);
 CL.AddConstantN('URLACTION_ACTIVEX_RUN','LongWord').SetUInt( $00001200);
 CL.AddConstantN('URLACTION_ACTIVEX_OVERRIDE_OBJECT_SAFETY','LongWord').SetUInt( $00001201);
 CL.AddConstantN('URLACTION_ACTIVEX_OVERRIDE_DATA_SAFETY','LongWord').SetUInt( $00001202);
 CL.AddConstantN('URLACTION_ACTIVEX_OVERRIDE_SCRIPT_SAFETY','LongWord').SetUInt( $00001203);
 CL.AddConstantN('URLACTION_SCRIPT_OVERRIDE_SAFETY','LongWord').SetUInt( $00001401);
 CL.AddConstantN('URLACTION_ACTIVEX_CONFIRM_NOOBJECTSAFETY','LongWord').SetUInt( $00001204);
 CL.AddConstantN('URLACTION_ACTIVEX_TREATASUNTRUSTED','LongWord').SetUInt( $00001205);
 CL.AddConstantN('URLACTION_ACTIVEX_NO_WEBOC_SCRIPT','LongWord').SetUInt( $00001206);
 CL.AddConstantN('URLACTION_ACTIVEX_CURR_MAX','LongWord').SetUInt( $00001206);
 CL.AddConstantN('URLACTION_ACTIVEX_MAX','LongWord').SetUInt( $000013FF);
 CL.AddConstantN('URLACTION_SCRIPT_MIN','LongWord').SetUInt( $00001400);
 CL.AddConstantN('URLACTION_SCRIPT_RUN','LongWord').SetUInt( $00001400);
 CL.AddConstantN('URLACTION_SCRIPT_JAVA_USE','LongWord').SetUInt( $00001402);
 CL.AddConstantN('URLACTION_SCRIPT_SAFE_ACTIVEX','LongWord').SetUInt( $00001405);
 CL.AddConstantN('URLACTION_SCRIPT_CURR_MAX','LongWord').SetUInt( $00001405);
 CL.AddConstantN('URLACTION_SCRIPT_MAX','LongWord').SetUInt( $000015FF);
 CL.AddConstantN('URLACTION_HTML_MIN','LongWord').SetUInt( $00001600);
 CL.AddConstantN('URLACTION_HTML_SUBMIT_FORMS','LongWord').SetUInt( $00001601);
 CL.AddConstantN('URLACTION_HTML_SUBMIT_FORMS_FROM','LongWord').SetUInt( $00001602);
 CL.AddConstantN('URLACTION_HTML_SUBMIT_FORMS_TO','LongWord').SetUInt( $00001603);
 CL.AddConstantN('URLACTION_HTML_FONT_DOWNLOAD','LongWord').SetUInt( $00001604);
 CL.AddConstantN('URLACTION_HTML_JAVA_RUN','LongWord').SetUInt( $00001605);
 CL.AddConstantN('URLACTION_HTML_CURR_MAX','LongWord').SetUInt( $00001605);
 CL.AddConstantN('URLACTION_HTML_MAX','LongWord').SetUInt( $000017FF);
 CL.AddConstantN('URLACTION_SHELL_MIN','LongWord').SetUInt( $00001800);
 CL.AddConstantN('URLACTION_SHELL_INSTALL_DTITEMS','LongWord').SetUInt( $00001800);
 CL.AddConstantN('URLACTION_SHELL_MOVE_OR_COPY','LongWord').SetUInt( $00001802);
 CL.AddConstantN('URLACTION_SHELL_FILE_DOWNLOAD','LongWord').SetUInt( $00001803);
 CL.AddConstantN('URLACTION_SHELL_VERB','LongWord').SetUInt( $00001804);
 CL.AddConstantN('URLACTION_SHELL_WEBVIEW_VERB','LongWord').SetUInt( $00001805);
 CL.AddConstantN('URLACTION_SHELL_SHELLEXECUTE','LongWord').SetUInt( $00001806);
 CL.AddConstantN('URLACTION_SHELL_EXECUTE_HIGHRISK','LongWord').SetUInt( $00001806);
 CL.AddConstantN('URLACTION_SHELL_EXECUTE_MODRISK','LongWord').SetUInt( $00001807);
 CL.AddConstantN('URLACTION_SHELL_EXECUTE_LOWRISK','LongWord').SetUInt( $00001808);
 CL.AddConstantN('URLACTION_SHELL_POPUPMGR','LongWord').SetUInt( $00001809);
 CL.AddConstantN('URLACTION_SHELL_CURR_MAX','LongWord').SetUInt( $00001809);
 CL.AddConstantN('URLACTION_SHELL_MAX','LongWord').SetUInt( $000019ff);
 CL.AddConstantN('URLACTION_NETWORK_MIN','LongWord').SetUInt( $00001A00);
 CL.AddConstantN('URLACTION_CREDENTIALS_USE','LongWord').SetUInt( $00001A00);
 CL.AddConstantN('URLPOLICY_CREDENTIALS_SILENT_LOGON_OK','LongWord').SetUInt( $00000000);
 CL.AddConstantN('URLPOLICY_CREDENTIALS_MUST_PROMPT_USER','LongWord').SetUInt( $00010000);
 CL.AddConstantN('URLPOLICY_CREDENTIALS_CONDITIONAL_PROMPT','LongWord').SetUInt( $00020000);
 CL.AddConstantN('URLPOLICY_CREDENTIALS_ANONYMOUS_ONLY','LongWord').SetUInt( $00030000);
 CL.AddConstantN('URLACTION_AUTHENTICATE_CLIENT','LongWord').SetUInt( $00001A01);
 CL.AddConstantN('URLPOLICY_AUTHENTICATE_CLEARTEXT_OK','LongWord').SetUInt( $00000000);
 CL.AddConstantN('URLPOLICY_AUTHENTICATE_CHALLENGE_RESPONSE','LongWord').SetUInt( $00010000);
 CL.AddConstantN('URLPOLICY_AUTHENTICATE_MUTUAL_ONLY','LongWord').SetUInt( $00030000);
 CL.AddConstantN('URLACTION_NETWORK_CURR_MAX','LongWord').SetUInt( $00001A01);
 CL.AddConstantN('URLACTION_NETWORK_MAX','LongWord').SetUInt( $00001BFF);
 CL.AddConstantN('URLACTION_JAVA_MIN','LongWord').SetUInt( $00001C00);
 CL.AddConstantN('URLACTION_JAVA_PERMISSIONS','LongWord').SetUInt( $00001C00);
 CL.AddConstantN('URLPOLICY_JAVA_PROHIBIT','LongWord').SetUInt( $00000000);
 CL.AddConstantN('URLPOLICY_JAVA_HIGH','LongWord').SetUInt( $00010000);
 CL.AddConstantN('URLPOLICY_JAVA_MEDIUM','LongWord').SetUInt( $00020000);
 CL.AddConstantN('URLPOLICY_JAVA_LOW','LongWord').SetUInt( $00030000);
 CL.AddConstantN('URLPOLICY_JAVA_CUSTOM','LongWord').SetUInt( $00800000);
 CL.AddConstantN('URLACTION_JAVA_CURR_MAX','LongWord').SetUInt( $00001C00);
 CL.AddConstantN('URLACTION_JAVA_MAX','LongWord').SetUInt( $00001CFF);
 CL.AddConstantN('URLACTION_INFODELIVERY_MIN','LongWord').SetUInt( $00001D00);
 CL.AddConstantN('URLACTION_INFODELIVERY_NO_ADDING_CHANNELS','LongWord').SetUInt( $00001D00);
 CL.AddConstantN('URLACTION_INFODELIVERY_NO_EDITING_CHANNELS','LongWord').SetUInt( $00001D01);
 CL.AddConstantN('URLACTION_INFODELIVERY_NO_REMOVING_CHANNELS','LongWord').SetUInt( $00001D02);
 CL.AddConstantN('URLACTION_INFODELIVERY_NO_ADDING_SUBSCRIPTIONS','LongWord').SetUInt( $00001D03);
 CL.AddConstantN('URLACTION_INFODELIVERY_NO_EDITING_SUBSCRIPTIONS','LongWord').SetUInt( $00001D04);
 CL.AddConstantN('URLACTION_INFODELIVERY_NO_REMOVING_SUBSCRIPTIONS','LongWord').SetUInt( $00001D05);
 CL.AddConstantN('URLACTION_INFODELIVERY_NO_CHANNEL_LOGGING','LongWord').SetUInt( $00001D06);
 CL.AddConstantN('URLACTION_INFODELIVERY_CURR_MAX','LongWord').SetUInt( $00001D06);
 CL.AddConstantN('URLACTION_INFODELIVERY_MAX','LongWord').SetUInt( $00001Dff);
 CL.AddConstantN('URLACTION_CHANNEL_SOFTDIST_MIN','LongWord').SetUInt( $00001E00);
 CL.AddConstantN('URLACTION_CHANNEL_SOFTDIST_PERMISSIONS','LongWord').SetUInt( $00001E05);
 CL.AddConstantN('URLPOLICY_CHANNEL_SOFTDIST_PROHIBIT','LongWord').SetUInt( $00010000);
 CL.AddConstantN('URLPOLICY_CHANNEL_SOFTDIST_PRECACHE','LongWord').SetUInt( $00020000);
 CL.AddConstantN('URLPOLICY_CHANNEL_SOFTDIST_AUTOINSTALL','LongWord').SetUInt( $00030000);
 CL.AddConstantN('URLACTION_CHANNEL_SOFTDIST_MAX','LongWord').SetUInt( $00001EFF);
 CL.AddConstantN('URLACTION_BEHAVIOR_MIN','LongWord').SetUInt( $00002000);
 CL.AddConstantN('URLACTION_BEHAVIOR_RUN','LongWord').SetUInt( $00002000);
 CL.AddConstantN('URLPOLICY_BEHAVIOR_CHECK_LIST','LongWord').SetUInt( $00010000);
 CL.AddConstantN('URLACTION_FEATURE_MIN','LongWord').SetUInt( $00002100);
 CL.AddConstantN('URLACTION_FEATURE_MIME_SNIFFING','LongWord').SetUInt( $00002100);
 CL.AddConstantN('URLACTION_FEATURE_ZONE_ELEVATION','LongWord').SetUInt( $00002101);
 CL.AddConstantN('URLACTION_FEATURE_WINDOW_RESTRICTIONS','LongWord').SetUInt( $00002102);
 CL.AddConstantN('URLACTION_AUTOMATIC_DOWNLOAD_UI_MIN','LongWord').SetUInt( $00002200);
 CL.AddConstantN('URLACTION_AUTOMATIC_DOWNLOAD_UI','LongWord').SetUInt( $00002200);
 CL.AddConstantN('URLACTION_AUTOMATIC_ACTIVEX_UI','LongWord').SetUInt( $00002201);
 CL.AddConstantN('URLACTION_ALLOW_RESTRICTEDPROTOCOLS','LongWord').SetUInt( $00002300);
 CL.AddConstantN('URLPOLICY_ALLOW','LongWord').SetUInt( $00);
 CL.AddConstantN('URLPOLICY_QUERY','LongWord').SetUInt( $01);
 CL.AddConstantN('URLPOLICY_DISALLOW','LongWord').SetUInt( $03);
 CL.AddConstantN('URLPOLICY_NOTIFY_ON_ALLOW','LongWord').SetUInt( $10);
 CL.AddConstantN('URLPOLICY_NOTIFY_ON_DISALLOW','LongWord').SetUInt( $20);
 CL.AddConstantN('URLPOLICY_LOG_ON_ALLOW','LongWord').SetUInt( $40);
 CL.AddConstantN('URLPOLICY_LOG_ON_DISALLOW','LongWord').SetUInt( $80);
 CL.AddConstantN('URLPOLICY_MASK_PERMISSIONS','LongWord').SetUInt( $0f);
 CL.AddDelphiFunction('Function GetUrlPolicyPermissions( dw : DWORD) : DWORD');
 CL.AddDelphiFunction('Function SetUrlPolicyPermissions( dw, dw2 : DWORD) : DWORD');
 CL.AddConstantN('URLZONE_PREDEFINED_MIN','LongInt').SetInt( 0);
 CL.AddConstantN('URLZONE_LOCAL_MACHINE','LongInt').SetInt( 0);
 CL.AddConstantN('URLZONE_INTRANET','LongInt').SetInt( URLZONE_LOCAL_MACHINE + 1);
 CL.AddConstantN('URLZONE_TRUSTED','LongInt').SetInt( URLZONE_INTRANET + 1);
 CL.AddConstantN('URLZONE_INTERNET','LongInt').SetInt( URLZONE_TRUSTED + 1);
 CL.AddConstantN('URLZONE_UNTRUSTED','LongInt').SetInt( URLZONE_INTERNET + 1);
 CL.AddConstantN('URLZONE_PREDEFINED_MAX','LongInt').SetInt( 999);
 CL.AddConstantN('URLZONE_USER_MIN','LongInt').SetInt( 1000);
 CL.AddConstantN('URLZONE_USER_MAX','LongInt').SetInt( 10000);
 CL.AddConstantN('URLTEMPLATE_CUSTOM','LongWord').SetUInt( $00000000);
 CL.AddConstantN('URLTEMPLATE_PREDEFINED_MIN','LongWord').SetUInt( $00010000);
 CL.AddConstantN('URLTEMPLATE_LOW','LongWord').SetUInt( $00010000);
 CL.AddConstantN('URLTEMPLATE_MEDIUM','LongWord').SetUInt( $00011000);
 CL.AddConstantN('URLTEMPLATE_HIGH','LongWord').SetUInt( $00012000);
 CL.AddConstantN('URLTEMPLATE_PREDEFINED_MAX','LongWord').SetUInt( $00020000);
 CL.AddConstantN('MAX_ZONE_PATH','LongInt').SetInt( 260);
 CL.AddConstantN('MAX_ZONE_DESCRIPTION','LongInt').SetInt( 200);
 CL.AddConstantN('ZAFLAGS_CUSTOM_EDIT','LongWord').SetUInt( $00000001);
 CL.AddConstantN('ZAFLAGS_ADD_SITES','LongWord').SetUInt( $00000002);
 CL.AddConstantN('ZAFLAGS_REQUIRE_VERIFICATION','LongWord').SetUInt( $00000004);
 CL.AddConstantN('ZAFLAGS_INCLUDE_PROXY_OVERRIDE','LongWord').SetUInt( $00000008);
 CL.AddConstantN('ZAFLAGS_INCLUDE_INTRANET_SITES','LongWord').SetUInt( $00000010);
 CL.AddConstantN('ZAFLAGS_NO_UI','LongWord').SetUInt( $00000020);
 CL.AddConstantN('ZAFLAGS_SUPPORTS_VERIFICATION','LongWord').SetUInt( $00000040);
 CL.AddConstantN('ZAFLAGS_UNC_AS_INTRANET','LongWord').SetUInt( $00000080);
 CL.AddConstantN('ZAFLAGS_USE_LOCKED_ZONES','LongWord').SetUInt( $00010000);
  //CL.AddTypeS('PZoneAttributes', '^TZoneAttributes // will not work');

   CL.AddTypeS('_ZONEATTRIBUTES', 'record cbSize : ULONG; szDisplayName: array [0..260-1] of Char; szDescription: array [0..200 - 1] of Char;'+
   'szIconPath: array [0..260 - 1] of char;  dwTemplateMinLevel: DWORD;  dwTemplateRecommended: DWORD;  dwTemplateCurrentLevel: DWORD;  dwFlags: DWORD; end');

  { _ZONEATTRIBUTES = packed record
    cbSize: ULONG;
    szDisplayName: array [0..260 - 1] of WideChar;
    szDescription: array [0..200 - 1] of WideChar;
    szIconPath: array [0..260 - 1] of WideChar;
    dwTemplateMinLevel: DWORD;
    dwTemplateRecommended: DWORD;
    dwTemplateCurrentLevel: DWORD;
    dwFlags: DWORD;
  end; }
  CL.AddTypeS('TZoneAttributes', '_ZONEATTRIBUTES');
  CL.AddTypeS('ZONEATTRIBUTES', '_ZONEATTRIBUTES');
 CL.AddConstantN('URLZONEREG_DEFAULT','LongInt').SetInt( 0);
 CL.AddConstantN('URLZONEREG_HKLM','LongInt').SetInt( URLZONEREG_DEFAULT + 1);
 CL.AddConstantN('URLZONEREG_HKCU','LongInt').SetInt( URLZONEREG_HKLM + 1);
  SIRegister_IInternetZoneManager(CL);
  SIRegister_IInternetZoneManagerEx(CL);
 //CL.AddDelphiFunction('Function CoInternetCreateSecurityManager( SP : IServiceProvider; var SM : IInternetSecurityManager; dwReserved : DWORD) : HResult');
 //CL.AddDelphiFunction('Function CoInternetCreateZoneManager( SP : IServiceProvider; var ZM : IInternetZoneManager; dwReserved : DWORD) : HResult');
 CL.AddConstantN('SOFTDIST_FLAG_USAGE_EMAIL','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SOFTDIST_FLAG_USAGE_PRECACHE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SOFTDIST_FLAG_USAGE_AUTOINSTALL','LongWord').SetUInt( $00000004);
 CL.AddConstantN('SOFTDIST_FLAG_DELETE_SUBSCRIPTION','LongWord').SetUInt( $00000008);
 CL.AddConstantN('SOFTDIST_ADSTATE_NONE','LongWord').SetUInt( $00000000);
 CL.AddConstantN('SOFTDIST_ADSTATE_AVAILABLE','LongWord').SetUInt( $00000001);
 CL.AddConstantN('SOFTDIST_ADSTATE_DOWNLOADED','LongWord').SetUInt( $00000002);
 CL.AddConstantN('SOFTDIST_ADSTATE_INSTALLED','LongWord').SetUInt( $00000003);
  //CL.AddTypeS('PCodeBaseHold', '^TCodeBaseHold // will not work');
  CL.AddTypeS('_tagCODEBASEHOLD', 'record cbSize : ULONG; szDistUnit : LPWSTR; '
   +'szCodeBase : LPWSTR; dwVersionMS : DWORD; dwVersionLS : DWORD; dwStyle : DWORD; end');
  CL.AddTypeS('TCodeBaseHold', '_tagCODEBASEHOLD');
  CL.AddTypeS('CODEBASEHOLD', '_tagCODEBASEHOLD');
  //CL.AddTypeS('PSoftDistInfo', '^TSoftDistInfo // will not work');
  CL.AddTypeS('_tagSOFTDISTINFO', 'record cbSize : ULONG; dwFlags : DWORD; dwAd'
   +'State : DWORD; szTitle : LPWSTR; szAbstract : LPWSTR; szHREF : LPWSTR; dwI'
   +'nstalledVersionMS : DWORD; dwInstalledVersionLS : DWORD; dwUpdateVersionMS'
   +' : DWORD; dwUpdateVersionLS : DWORD; dwAdvertisedVersionMS : DWORD; dwAdve'
   +'rtisedVersionLS : DWORD; dwReserved : DWORD; end');
  CL.AddTypeS('TSoftDistInfo', '_tagSOFTDISTINFO');
  CL.AddTypeS('SOFTDISTINFO', '_tagSOFTDISTINFO');
  SIRegister_ISoftDistExt(CL);
 CL.AddDelphiFunction('Function GetSoftwareUpdateInfo( szDistUnit : LPCWSTR; var dsi : TSoftDistInfo) : HResult');
 CL.AddDelphiFunction('Function SetSoftwareUpdateAdvertisementState( szDistUnit : LPCWSTR; dwAdState, dwAdvertisedVersionMS, dwAdvertisedVersionLS : DWORD) : HResult');
  SIRegister_IDataFilter(CL);
 // CL.AddTypeS('PProtocolFilterData', '^TProtocolFilterData // will not work');
  CL.AddTypeS('_tagPROTOCOLFILTERDATA', 'record cbSize : DWORD; ProtocolSink : '
   +'IInternetProtocolSink; Protocol : IInternetProtocol; Unk : IUnknown; dwFil'
   +'terFlags : DWORD; end');
  CL.AddTypeS('TProtocolFilterData', '_tagPROTOCOLFILTERDATA');
  CL.AddTypeS('PROTOCOLFILTERDATA', '_tagPROTOCOLFILTERDATA');
  //CL.AddTypeS('PDataInfo', '^TDataInfo // will not work');
  CL.AddTypeS('_tagDATAINFO', 'record ulTotalSize : ULONG; ulavrPacketSize : UL'
   +'ONG; ulConnectSpeed : ULONG; ulProcessorSpeed : ULONG; end');
  CL.AddTypeS('TDataInfo', '_tagDATAINFO');
  CL.AddTypeS('DATAINFO', '_tagDATAINFO');
  SIRegister_IEncodingFilterFactory(CL);
 CL.AddDelphiFunction('Function IsLoggingEnabled( pszUrl : PChar) : BOOL');
 //CL.AddDelphiFunction('Function IsLoggingEnabledA( pszUrl : PAnsiChar) : BOOL');
 //CL.AddDelphiFunction('Function IsLoggingEnabledW( pszUrl : PWideChar) : BOOL');
  //CL.AddTypeS('PHitLoggingInfo', '^THitLoggingInfo // will not work');
  CL.AddTypeS('_tagHIT_LOGGING_INFO', 'record dwStructSize : DWORD; lpszLoggedU'
   +'rlName : LPSTR; StartTime : TSystemTime; EndTime : TSystemTime; lpszExtendedInfo : LPSTR; end');
  CL.AddTypeS('THitLoggingInfo', '_tagHIT_LOGGING_INFO');
  CL.AddTypeS('HIT_LOGGING_INFO', '_tagHIT_LOGGING_INFO');
 CL.AddDelphiFunction('Function WriteHitLogging( const Logginginfo : THitLoggingInfo) : BOOL');
 CL.AddDelphiFunction('function DownloadURL_NOCache(const aUrl: string; var s: String): Boolean;');
 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_UrlMon_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HlinkSimpleNavigateToString, 'HlinkSimpleNavigateToString', CdStdCall);
 S.RegisterDelphiFunction(@HlinkSimpleNavigateToMoniker, 'HlinkSimpleNavigateToMoniker', CdStdCall);
 S.RegisterDelphiFunction(@CreateURLMoniker, 'CreateURLMoniker', CdStdCall);
 S.RegisterDelphiFunction(@GetClassURL, 'GetClassURL', CdStdCall);
 S.RegisterDelphiFunction(@CreateAsyncBindCtx, 'CreateAsyncBindCtx', CdStdCall);
 S.RegisterDelphiFunction(@CreateAsyncBindCtxEx, 'CreateAsyncBindCtxEx', CdStdCall);
 S.RegisterDelphiFunction(@MkParseDisplayNameEx, 'MkParseDisplayNameEx', CdStdCall);
 S.RegisterDelphiFunction(@RegisterBindStatusCallback, 'RegisterBindStatusCallback', CdStdCall);
 S.RegisterDelphiFunction(@RevokeBindStatusCallback, 'RevokeBindStatusCallback', CdStdCall);
 S.RegisterDelphiFunction(@GetClassFileOrMime, 'GetClassFileOrMime', CdStdCall);
 S.RegisterDelphiFunction(@IsValidURL, 'IsValidURL', CdStdCall);
 S.RegisterDelphiFunction(@CoGetClassObjectFromURL, 'CoGetClassObjectFromURL', CdStdCall);
 S.RegisterDelphiFunction(@IsAsyncMoniker, 'IsAsyncMoniker', CdStdCall);
 //S.RegisterDelphiFunction(@CreateURLBinding, 'CreateURLBinding', CdStdCall);
 S.RegisterDelphiFunction(@RegisterMediaTypes, 'RegisterMediaTypes', CdStdCall);
 S.RegisterDelphiFunction(@FindMediaType, 'FindMediaType', CdStdCall);
 S.RegisterDelphiFunction(@CreateFormatEnumerator, 'CreateFormatEnumerator', CdStdCall);
 S.RegisterDelphiFunction(@RegisterFormatEnumerator, 'RegisterFormatEnumerator', CdStdCall);
 S.RegisterDelphiFunction(@RevokeFormatEnumerator, 'RevokeFormatEnumerator', CdStdCall);
 S.RegisterDelphiFunction(@RegisterMediaTypeClass, 'RegisterMediaTypeClass', CdStdCall);
 S.RegisterDelphiFunction(@FindMediaTypeClass, 'FindMediaTypeClass', CdStdCall);
 S.RegisterDelphiFunction(@UrlMkSetSessionOption, 'UrlMkSetSessionOption', CdStdCall);
 S.RegisterDelphiFunction(@UrlMkGetSessionOption, 'UrlMkGetSessionOption', CdStdCall);
 S.RegisterDelphiFunction(@FindMimeFromData, 'FindMimeFromData', CdStdCall);
 S.RegisterDelphiFunction(@ObtainUserAgentString, 'ObtainUserAgentString', CdStdCall);
 S.RegisterDelphiFunction(@URLOpenStream, 'URLOpenStream', CdStdCall);
 //S.RegisterDelphiFunction(@URLOpenStreamA, 'URLOpenStreamA', CdStdCall);
// S.RegisterDelphiFunction(@URLOpenStreamW, 'URLOpenStreamW', CdStdCall);
 S.RegisterDelphiFunction(@URLOpenPullStream, 'URLOpenPullStream', CdStdCall);
// S.RegisterDelphiFunction(@URLOpenPullStreamA, 'URLOpenPullStreamA', CdStdCall);
// S.RegisterDelphiFunction(@URLOpenPullStreamW, 'URLOpenPullStreamW', CdStdCall);
 S.RegisterDelphiFunction(@URLDownloadToFile, 'URLDownloadToFile', CdStdCall);
 //S.RegisterDelphiFunction(@URLDownloadToFileA, 'URLDownloadToFileA', CdStdCall);
 //S.RegisterDelphiFunction(@URLDownloadToFileW, 'URLDownloadToFileW', CdStdCall);
 S.RegisterDelphiFunction(@URLDownloadToCacheFile, 'URLDownloadToCacheFile', CdStdCall);
 //S.RegisterDelphiFunction(@URLDownloadToCacheFileA, 'URLDownloadToCacheFileA', CdStdCall);
 //S.RegisterDelphiFunction(@URLDownloadToCacheFileW, 'URLDownloadToCacheFileW', CdStdCall);
 S.RegisterDelphiFunction(@URLOpenBlockingStream, 'URLOpenBlockingStream', CdStdCall);
 //S.RegisterDelphiFunction(@URLOpenBlockingStreamA, 'URLOpenBlockingStreamA', CdStdCall);
 //S.RegisterDelphiFunction(@URLOpenBlockingStreamW, 'URLOpenBlockingStreamW', CdStdCall);
 S.RegisterDelphiFunction(@HlinkGoBack, 'HlinkGoBack', CdStdCall);
 S.RegisterDelphiFunction(@HlinkGoForward, 'HlinkGoForward', CdStdCall);
 S.RegisterDelphiFunction(@HlinkNavigateString, 'HlinkNavigateString', CdStdCall);
 S.RegisterDelphiFunction(@HlinkNavigateMoniker, 'HlinkNavigateMoniker', CdStdCall);
 S.RegisterDelphiFunction(@CoInternetParseUrl, 'CoInternetParseUrl', CdStdCall);
 S.RegisterDelphiFunction(@CoInternetCombineUrl, 'CoInternetCombineUrl', CdStdCall);
 S.RegisterDelphiFunction(@CoInternetCompareUrl, 'CoInternetCompareUrl', CdStdCall);
 S.RegisterDelphiFunction(@CoInternetGetProtocolFlags, 'CoInternetGetProtocolFlags', CdStdCall);
 S.RegisterDelphiFunction(@CoInternetQueryInfo, 'CoInternetQueryInfo', CdStdCall);
 S.RegisterDelphiFunction(@CoInternetGetSession, 'CoInternetGetSession', CdStdCall);
 S.RegisterDelphiFunction(@CoInternetGetSecurityUrl, 'CoInternetGetSecurityUrl', CdStdCall);
 S.RegisterDelphiFunction(@OInetParseUrl, 'OInetParseUrl', CdStdCall);
 S.RegisterDelphiFunction(@OInetCombineUrl, 'OInetCombineUrl', CdStdCall);
 S.RegisterDelphiFunction(@OInetCompareUrl, 'OInetCompareUrl', CdStdCall);
 //S.RegisterDelphiFunction(@OInetGetProtocolFlags, 'OInetGetProtocolFlags', CdStdCall);
 S.RegisterDelphiFunction(@OInetQueryInfo, 'OInetQueryInfo', CdStdCall);
 S.RegisterDelphiFunction(@OInetGetSession, 'OInetGetSession', CdStdCall);
 //S.RegisterDelphiFunction(@OInetGetSecurityUrl, 'OInetGetSecurityUrl', CdStdCall);
 S.RegisterDelphiFunction(@CopyStgMedium, 'CopyStgMedium', CdStdCall);
 S.RegisterDelphiFunction(@CopyBindInfo, 'CopyBindInfo', CdStdCall);
 S.RegisterDelphiFunction(@ReleaseBindInfo, 'ReleaseBindInfo', CdStdCall);
 S.RegisterDelphiFunction(@GetUrlPolicyPermissions, 'GetUrlPolicyPermissions', cdRegister);
 S.RegisterDelphiFunction(@SetUrlPolicyPermissions, 'SetUrlPolicyPermissions', cdRegister);
 S.RegisterDelphiFunction(@CoInternetCreateSecurityManager, 'CoInternetCreateSecurityManager', CdStdCall);
 S.RegisterDelphiFunction(@CoInternetCreateZoneManager, 'CoInternetCreateZoneManager', CdStdCall);
 S.RegisterDelphiFunction(@GetSoftwareUpdateInfo, 'GetSoftwareUpdateInfo', CdStdCall);
 S.RegisterDelphiFunction(@SetSoftwareUpdateAdvertisementState, 'SetSoftwareUpdateAdvertisementState', CdStdCall);
 S.RegisterDelphiFunction(@IsLoggingEnabled, 'IsLoggingEnabled', CdStdCall);
 //S.RegisterDelphiFunction(@IsLoggingEnabledA, 'IsLoggingEnabledA', CdStdCall);
 //S.RegisterDelphiFunction(@IsLoggingEnabledW, 'IsLoggingEnabledW', CdStdCall);
 S.RegisterDelphiFunction(@WriteHitLogging, 'WriteHitLogging', CdStdCall);
  S.RegisterDelphiFunction(@DownloadURL_NOCache, 'DownloadURL_NOCache', cdRegister);


end;



{ TPSImport_UrlMon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_UrlMon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_UrlMon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_UrlMon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_UrlMon_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
