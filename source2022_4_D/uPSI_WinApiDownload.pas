unit uPSI_WinApiDownload;
{
to het direct to winapi  getcontent

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
  TPSImport_WinApiDownload = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TWinApiDownload(CL: TPSPascalCompiler);
procedure SIRegister_WinApiDownload(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TWinApiDownload(CL: TPSRuntimeClassImporter);
procedure RIRegister_WinApiDownload(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,WinInet
  ,WinApiDownload
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WinApiDownload]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TWinApiDownload(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TWinApiDownload') do
  with CL.AddClassN(CL.FindClass('TObject'),'TWinApiDownload') do
  begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function CheckURL( aURL : string) : Integer');
    RegisterMethod('Function Download( Stream : TStream) : Integer;');
    RegisterMethod('Function Download1( var res : string) : Integer;');
    RegisterMethod('Function ErrorCodeToMessageString( aErrorCode : Integer) : string');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Clear');
    RegisterProperty('UserAgent', 'string', iptrw);
    RegisterProperty('URL', 'string', iptrw);
    RegisterProperty('DownloadActive', 'Boolean', iptr);
    RegisterProperty('CachingEnabled', 'Boolean', iptrw);
    RegisterProperty('UpdateInterval', 'Cardinal', iptrw);
    RegisterProperty('OnWorkStart', 'TEventWorkStart', iptrw);
    RegisterProperty('OnWork', 'TEventWork', iptrw);
    RegisterProperty('OnWorkEnd', 'TEventWorkEnd', iptrw);
    RegisterProperty('OnError', 'TEventError', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WinApiDownload(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TEventWorkStart', 'Procedure ( Sender : TObject; iFileSize : Int64)');
  CL.AddTypeS('TEventWork', 'Procedure ( Sender : TObject; iBytesTransfered : Int64)');
  CL.AddTypeS('TEventWorkEnd', 'Procedure ( Sender : TObject; iBytesTransfered '
   +': Int64; ErrorCode : Integer)');
  CL.AddTypeS('TEventError', 'Procedure ( Sender : TObject; iErrorCode : Integer; sURL : string)');
  SIRegister_TWinApiDownload(CL);
 CL.AddConstantN('DOWNLOAD_ERROR_UNKNOWN','LongInt').SetInt( - 1);
 CL.AddConstantN('DOWNLOAD_ABORTED_BY_USER','LongInt').SetInt( - 2);
 CL.AddConstantN('DOWNLOAD_ERROR_INCOMPLETE_READ','LongInt').SetInt( - 3);
 CL.AddConstantN('DOWNLOAD_ERROR_DATA_READ','LongInt').SetInt( - 4);
 CL.AddConstantN('DOWNLOAD_ERROR_EMPTY_URL','LongInt').SetInt( - 5);
 CL.AddConstantN('DOWNLOAD_ERROR_DIR_NOT_EXISTS','LongInt').SetInt( - 6);
 CL.AddConstantN('DOWNLOAD_ERROR_INCORRECT_DATA_SIZE','LongInt').SetInt( - 7);
 //function GetUrlContent(const Url: string): UTF8String;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadOnError_W(Self: TWinApiDownload; const T: TEventError);
begin Self.OnError := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadOnError_R(Self: TWinApiDownload; var T: TEventError);
begin T := Self.OnError; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadOnWorkEnd_W(Self: TWinApiDownload; const T: TEventWorkEnd);
begin Self.OnWorkEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadOnWorkEnd_R(Self: TWinApiDownload; var T: TEventWorkEnd);
begin T := Self.OnWorkEnd; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadOnWork_W(Self: TWinApiDownload; const T: TEventWork);
begin Self.OnWork := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadOnWork_R(Self: TWinApiDownload; var T: TEventWork);
begin T := Self.OnWork; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadOnWorkStart_W(Self: TWinApiDownload; const T: TEventWorkStart);
begin Self.OnWorkStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadOnWorkStart_R(Self: TWinApiDownload; var T: TEventWorkStart);
begin T := Self.OnWorkStart; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadUpdateInterval_W(Self: TWinApiDownload; const T: Cardinal);
begin Self.UpdateInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadUpdateInterval_R(Self: TWinApiDownload; var T: Cardinal);
begin T := Self.UpdateInterval; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadCachingEnabled_W(Self: TWinApiDownload; const T: Boolean);
begin Self.CachingEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadCachingEnabled_R(Self: TWinApiDownload; var T: Boolean);
begin T := Self.CachingEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadDownloadActive_R(Self: TWinApiDownload; var T: Boolean);
begin T := Self.DownloadActive; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadURL_W(Self: TWinApiDownload; const T: string);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadURL_R(Self: TWinApiDownload; var T: string);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadUserAgent_W(Self: TWinApiDownload; const T: string);
begin Self.UserAgent := T; end;

(*----------------------------------------------------------------------------*)
procedure TWinApiDownloadUserAgent_R(Self: TWinApiDownload; var T: string);
begin T := Self.UserAgent; end;

(*----------------------------------------------------------------------------*)
Function TWinApiDownloadDownload1_P(Self: TWinApiDownload;  var res : string) : Integer;
Begin Result := Self.Download(res); END;

(*----------------------------------------------------------------------------*)
Function TWinApiDownloadDownload_P(Self: TWinApiDownload;  Stream : TStream) : Integer;
Begin Result := Self.Download(Stream); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWinApiDownload(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWinApiDownload) do begin
    RegisterConstructor(@TWinApiDownload.Create, 'Create');
     RegisterMethod(@TWinApiDownload.Destroy, 'Free');
    RegisterMethod(@TWinApiDownload.CheckURL, 'CheckURL');
    RegisterMethod(@TWinApiDownloadDownload_P, 'Download');
    RegisterMethod(@TWinApiDownloadDownload1_P, 'Download1');
    RegisterMethod(@TWinApiDownload.ErrorCodeToMessageString, 'ErrorCodeToMessageString');
    RegisterMethod(@TWinApiDownload.Stop, 'Stop');
    RegisterMethod(@TWinApiDownload.Clear, 'Clear');
    RegisterPropertyHelper(@TWinApiDownloadUserAgent_R,@TWinApiDownloadUserAgent_W,'UserAgent');
    RegisterPropertyHelper(@TWinApiDownloadURL_R,@TWinApiDownloadURL_W,'URL');
    RegisterPropertyHelper(@TWinApiDownloadDownloadActive_R,nil,'DownloadActive');
    RegisterPropertyHelper(@TWinApiDownloadCachingEnabled_R,@TWinApiDownloadCachingEnabled_W,'CachingEnabled');
    RegisterPropertyHelper(@TWinApiDownloadUpdateInterval_R,@TWinApiDownloadUpdateInterval_W,'UpdateInterval');
    RegisterPropertyHelper(@TWinApiDownloadOnWorkStart_R,@TWinApiDownloadOnWorkStart_W,'OnWorkStart');
    RegisterPropertyHelper(@TWinApiDownloadOnWork_R,@TWinApiDownloadOnWork_W,'OnWork');
    RegisterPropertyHelper(@TWinApiDownloadOnWorkEnd_R,@TWinApiDownloadOnWorkEnd_W,'OnWorkEnd');
    RegisterPropertyHelper(@TWinApiDownloadOnError_R,@TWinApiDownloadOnError_W,'OnError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WinApiDownload(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TWinApiDownload(CL);
end;

 
 
{ TPSImport_WinApiDownload }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinApiDownload.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WinApiDownload(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WinApiDownload.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WinApiDownload(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
