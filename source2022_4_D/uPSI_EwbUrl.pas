unit uPSI_EwbUrl;
{
T   TIURL

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
  TPSImport_EwbUrl = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TUrl(CL: TPSPascalCompiler);
procedure SIRegister_EwbUrl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TUrl(CL: TPSRuntimeClassImporter);
procedure RIRegister_EwbUrl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Dialogs
  ,Windows
  ,WinInet
  ,EwbUrl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_EwbUrl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TUrl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TUrl') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TUrl') do begin
    RegisterMethod('Function FixUrl( Url : string) : string');
    RegisterMethod('Function BuildUrl : WideString');
    RegisterMethod('Function CanonicalizeUrl( const Url : string; dwFlags : integer) : WideString');
    RegisterMethod('Function CombineUrl( const BaseUrl, RelativaUrl : string; dwFlags : DWord) : WideString');
    RegisterMethod('Function CompareUrl( const pwzUrl1, pwzUrl2 : WideString) : HResult');
    RegisterMethod('Function CrackUrl( const Url : string; dwFlags : DWord) : WideString');
    RegisterMethod('Function CreateUrl( const dwFlags : DWord) : WideString');
    RegisterMethod('Function EncodeUrl( const InputStr : string; const bQueryStr : Boolean) : string');
    RegisterMethod('Function DecodeUrl( const InputStr : string) : string');
    RegisterMethod('Function IsUrlValid( const Url : string) : boolean');
    RegisterMethod('Function IsUrlCached( const Url : string) : boolean');
    RegisterMethod('Function GetUrlSize( const Url : string) : string');
    RegisterMethod('Function GetUrlType( const Url : string) : string');
    RegisterMethod('Function GetUrlProtocolVersion( const Url : string) : string');
    RegisterMethod('Function GetUrlServerDetails( const Url : string) : string');
    RegisterMethod('Function GetUrlCharSet( const Url : string) : string');
    RegisterMethod('Function GetUrlServer( const Url : string) : string');
    RegisterMethod('Function GetUrlLastModified( const Url : string) : string');
    RegisterMethod('Function GetUrlDate( const Url : string) : string');
    RegisterMethod('Function GetUrlStatusCode( const Url : string) : string');
    RegisterMethod('Function GetUrlEntityTag( const Url : string) : string');
    RegisterMethod('Function QueryInfo( const Url : string; dwInfoFlag : Integer) : string');
    RegisterMethod('Function CoInetQueryInfo( const Url : WideString; QueryOptions : Cardinal) : Boolean');
    RegisterMethod('Function ReadFile( const URL : string; TimeOut : LongWord) : string');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ClearUrlComponent');
    RegisterMethod('Procedure QueryUrl( Url : string)');
    RegisterMethod('Constructor Create( const Url : string)');
    RegisterProperty('Bookmark', 'string', iptrw);
    RegisterProperty('Document', 'string', iptrw);
    RegisterProperty('ExtraInfo', 'string', iptrw);
    RegisterProperty('HostName', 'string', iptrw);
    RegisterProperty('Parameters', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('Protocol', 'string', iptrw);
    RegisterProperty('OnError', 'TOnError_EWB', iptrw);
    RegisterProperty('Url', 'string', iptrw);
    RegisterProperty('UrlComponent', 'URL_COMPONENTS', iptrw);
    RegisterProperty('UrlPath', 'string', iptrw);
    RegisterProperty('UserName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EwbUrl(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TEMP_SIZE_EWB','LongInt').SetInt( 1024);
 CL.AddConstantN('MAX_BUFFER_EWB','LongInt').SetInt( 256);
 CL.AddConstantN('WebDelim_EWB','String').SetString( '/');
 CL.AddConstantN('ProtocolDelim_EWB','String').SetString( '://');
 CL.AddConstantN('QueryDelim_EWB','String').SetString( '?');
 CL.AddConstantN('BookmarkDelim_EWB','String').SetString( '#');
 CL.AddConstantN('EqualDelim_EWB','String').SetString( '=');
 CL.AddConstantN('DriveDelim_EWB','String').SetString( ':');
  CL.AddTypeS('TQueryOption_EWB', 'ULONG');
  CL.AddTypeS('TOnError_EWB', 'Procedure ( Sender : TObject; ErrorCode : integer; ErrMessage : string)');
  SIRegister_TUrl(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TUrlUserName_W(Self: TUrl; const T: string);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlUserName_R(Self: TUrl; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TUrlUrlPath_W(Self: TUrl; const T: string);
begin Self.UrlPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlUrlPath_R(Self: TUrl; var T: string);
begin T := Self.UrlPath; end;

(*----------------------------------------------------------------------------*)
procedure TUrlUrlComponent_W(Self: TUrl; const T: URL_COMPONENTS);
begin Self.UrlComponent := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlUrlComponent_R(Self: TUrl; var T: URL_COMPONENTS);
begin T := Self.UrlComponent; end;

(*----------------------------------------------------------------------------*)
procedure TUrlUrl_W(Self: TUrl; const T: string);
begin Self.Url := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlUrl_R(Self: TUrl; var T: string);
begin T := Self.Url; end;

(*----------------------------------------------------------------------------*)
procedure TUrlOnError_W(Self: TUrl; const T: TOnError);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlOnError_R(Self: TUrl; var T: TOnError);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TUrlProtocol_W(Self: TUrl; const T: string);
begin Self.Protocol := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlProtocol_R(Self: TUrl; var T: string);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure TUrlPort_W(Self: TUrl; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlPort_R(Self: TUrl; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TUrlPassword_W(Self: TUrl; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlPassword_R(Self: TUrl; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TUrlParameters_W(Self: TUrl; const T: string);
begin Self.Parameters := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlParameters_R(Self: TUrl; var T: string);
begin T := Self.Parameters; end;

(*----------------------------------------------------------------------------*)
procedure TUrlHostName_W(Self: TUrl; const T: string);
begin Self.HostName := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlHostName_R(Self: TUrl; var T: string);
begin T := Self.HostName; end;

(*----------------------------------------------------------------------------*)
procedure TUrlExtraInfo_W(Self: TUrl; const T: string);
begin Self.ExtraInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlExtraInfo_R(Self: TUrl; var T: string);
begin T := Self.ExtraInfo; end;

(*----------------------------------------------------------------------------*)
procedure TUrlDocument_W(Self: TUrl; const T: string);
begin Self.Document := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlDocument_R(Self: TUrl; var T: string);
begin T := Self.Document; end;

(*----------------------------------------------------------------------------*)
procedure TUrlBookmark_W(Self: TUrl; const T: string);
begin Self.Bookmark := T; end;

(*----------------------------------------------------------------------------*)
procedure TUrlBookmark_R(Self: TUrl; var T: string);
begin T := Self.Bookmark; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TUrl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TUrl) do
  begin
    RegisterMethod(@TUrl.FixUrl, 'FixUrl');
    RegisterMethod(@TUrl.BuildUrl, 'BuildUrl');
    RegisterMethod(@TUrl.CanonicalizeUrl, 'CanonicalizeUrl');
    RegisterMethod(@TUrl.CombineUrl, 'CombineUrl');
    RegisterMethod(@TUrl.CompareUrl, 'CompareUrl');
    RegisterMethod(@TUrl.CrackUrl, 'CrackUrl');
    RegisterMethod(@TUrl.CreateUrl, 'CreateUrl');
    RegisterMethod(@TUrl.EncodeUrl, 'EncodeUrl');
    RegisterMethod(@TUrl.DecodeUrl, 'DecodeUrl');
    RegisterMethod(@TUrl.IsUrlValid, 'IsUrlValid');
    RegisterMethod(@TUrl.IsUrlCached, 'IsUrlCached');
    RegisterMethod(@TUrl.GetUrlSize, 'GetUrlSize');
    RegisterMethod(@TUrl.GetUrlType, 'GetUrlType');
    RegisterMethod(@TUrl.GetUrlProtocolVersion, 'GetUrlProtocolVersion');
    RegisterMethod(@TUrl.GetUrlServerDetails, 'GetUrlServerDetails');
    RegisterMethod(@TUrl.GetUrlCharSet, 'GetUrlCharSet');
    RegisterMethod(@TUrl.GetUrlServer, 'GetUrlServer');
    RegisterMethod(@TUrl.GetUrlLastModified, 'GetUrlLastModified');
    RegisterMethod(@TUrl.GetUrlDate, 'GetUrlDate');
    RegisterMethod(@TUrl.GetUrlStatusCode, 'GetUrlStatusCode');
    RegisterMethod(@TUrl.GetUrlEntityTag, 'GetUrlEntityTag');
    RegisterMethod(@TUrl.QueryInfo, 'QueryInfo');
    RegisterMethod(@TUrl.CoInetQueryInfo, 'CoInetQueryInfo');
    RegisterMethod(@TUrl.ReadFile, 'ReadFile');
    RegisterMethod(@TUrl.Clear, 'Clear');
    RegisterMethod(@TUrl.ClearUrlComponent, 'ClearUrlComponent');
    RegisterMethod(@TUrl.QueryUrl, 'QueryUrl');
    RegisterConstructor(@TUrl.Create, 'Create');
    RegisterPropertyHelper(@TUrlBookmark_R,@TUrlBookmark_W,'Bookmark');
    RegisterPropertyHelper(@TUrlDocument_R,@TUrlDocument_W,'Document');
    RegisterPropertyHelper(@TUrlExtraInfo_R,@TUrlExtraInfo_W,'ExtraInfo');
    RegisterPropertyHelper(@TUrlHostName_R,@TUrlHostName_W,'HostName');
    RegisterPropertyHelper(@TUrlParameters_R,@TUrlParameters_W,'Parameters');
    RegisterPropertyHelper(@TUrlPassword_R,@TUrlPassword_W,'Password');
    RegisterPropertyHelper(@TUrlPort_R,@TUrlPort_W,'Port');
    RegisterPropertyHelper(@TUrlProtocol_R,@TUrlProtocol_W,'Protocol');
    RegisterPropertyHelper(@TUrlOnError_R,@TUrlOnError_W,'OnError');
    RegisterPropertyHelper(@TUrlUrl_R,@TUrlUrl_W,'Url');
    RegisterPropertyHelper(@TUrlUrlComponent_R,@TUrlUrlComponent_W,'UrlComponent');
    RegisterPropertyHelper(@TUrlUrlPath_R,@TUrlUrlPath_W,'UrlPath');
    RegisterPropertyHelper(@TUrlUserName_R,@TUrlUserName_W,'UserName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EwbUrl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TUrl(CL);
end;

 
 
{ TPSImport_EwbUrl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_EwbUrl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_EwbUrl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_EwbUrl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_EwbUrl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
