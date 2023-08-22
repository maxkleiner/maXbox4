// Copyright 2008 Martin Herold und Toolbox Verlag

unit fservice;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  IdBaseComponent, IdComponent, IdTCPServer, cmdIntf, {cmdModMgr,} IdCustomHTTPServer,
  IdHTTPServer, IdAntiFreezeBase, IdAntiFreeze, IdTCPServer, IdCustomTCPServer;

type
  TService1 = class(TService)
    Server: TIdTCPServer;
    HTTPServer: TIdHTTPServer;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure ServerTIdCommandHandler0Command(ASender: TIdCommand);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServerExecuteCommandCommand(ASender: TIdCommand);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServerreloadCommandCommand(ASender: TIdCommand);
    procedure HTTPServerCommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure ServerConnect(AThread: TIdPeerThread);
    procedure ServerDisconnect(AThread: TIdPeerThread);
  private
    { Private-Deklarationen }
    FModuleManager : TModuleManager;
    FAllowedIPs    : TStringList;
    FRootDir       : STRING;
    PROCEDURE Init;
    PROCEDURE LoadModules;
    procedure InitThread(AThread: TIdPeerThread);
    procedure InitWebThread(AThread: TIdPeerThread);
  public
    { Public-Deklarationen }
    FUNCTION GetFileContent( aModule, aFilename : STRING; VAR Content : STRING) : BOOLEAN;
    function GetServiceController: TServiceController; override;
    PROPERTY Modules : TModuleManager read FModuleManager;
    PROPERTY AllowedIPs : TStringList read FAllowedIPs;
  end;

var
  Service1: TService1;

implementation

{$R *.DFM}

USES
  dmWebThread,
  dmThread;


TYPE

  TServerCommandModule = CLASS( TCommandModule)
  public
    CONSTRUCTOR Create( aName : STRING);
  END;

  TCallCommand = CLASS( TModCommand)
    PROCEDURE   Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent); OVERRIDE;
  END;

  TReloadCommand = CLASS( TModCommand)
    PROCEDURE   Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent); OVERRIDE;
  END;


CONSTRUCTOR TServerCommandModule.Create( aName : STRING);
BEGIN
  INHERITED Create( aName);
  TCallCommand.Create( Self, 'call');
  TReloadCommand.Create( Self, 'reload');
END;

PROCEDURE   TCallCommand.Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent);
VAR
  Cmd    : STRING;
  Module : STRING;
  p      : INTEGER;
begin
  Module:='';
  IF Params.Count>0 THEN BEGIN
    Cmd:=Params[0];
    p:=Pos( '.', Cmd);
    IF p>0 THEN BEGIN
      Module:=Copy( Cmd, 1, p-1);
      Delete( Cmd, 1, p);
      Params[0]:=Cmd;
    END
  END;
  IF Module='' THEN BEGIN
    Respond.Add( 'result=-1');
    Respond.Add( 'errortext=Missing Modulename in Command');
  END
  ELSE Owner.Mananger.Execute( Thread, Module, Params, Respond);
end;

PROCEDURE   TReloadCommand.Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent);
begin
  TRY
    TidPeerThread( Thread).Synchronize( Service1.Init);
    Respond.Add( 'result=0');
  EXCEPT
    ON X : Exception DO BEGIN
      Respond.Add( 'result=-5');
      Respond.Add( 'errortext='+X.Message);
    END;
  END;
end;



function LoadFile(const FileName: TFileName): string;
begin
  with TFileStream.Create(FileName,
      fmOpenRead or fmShareDenyWrite) do begin
    try
      SetLength(Result, Size);
      Read(Pointer(Result)^, Size);
    except
      Result := '';  // Deallocates memory
      Free;
      raise;
    end;
    Free;
  end;
end;



procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Service1.Controller(CtrlCode);
end;

function TService1.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TService1.ServerTIdCommandHandler0Command(ASender: TIdCommand);
begin
  FModuleManager.Items[0].Execute( ASender.Thread, 'info', ASender.Params, ASender.Response, FModuleManager.Data);
end;

procedure TService1.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Server.Active:=TRUE;
  HTTPServer.Active:=TRUE;
end;

procedure TService1.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  Server.Active:=FALSE;
  HTTPServer.Active:=FALSE;
end;

procedure TService1.ServicePause(Sender: TService; var Paused: Boolean);
begin
  Server.Active:=FALSE;
  HTTPServer.Active:=FALSE;
end;

procedure TService1.ServiceContinue(Sender: TService;
  var Continued: Boolean);
begin
  Server.Active:=TRUE;
  HTTPServer.Active:=TRUE;
end;

procedure TService1.ServerExecuteCommandCommand(ASender: TIdCommand);
begin
  FModuleManager.Items[0].Execute( ASender.Thread, 'call', ASender.Params, ASender.Response, FModuleManager.Data);
end;

PROCEDURE TService1.LoadModules;
VAR
  r       : INTEGER;
  Path    : STRING;
  Sr      : TSearchRec;
BEGIN
  Path:=ExtractFilePath( ParamStr( 0));
  r:=FindFirst( Path+'*.DLL', faAnyFile, Sr);
  WHILE r=0 DO BEGIN
    FModuleManager.LoadModuleFile( Path+Sr.Name);
    r:=FindNext( Sr);
  END;
  FindClose( Sr);
END;


PROCEDURE TService1.Init;
VAR
  str    : ARRAY[0..255] OF CHAR;
BEGIN
  GetModuleFileName( hInstance, @str, 255);
  FRootDir:=ExtractFilePath( StrPas( str));
  FAllowedIPs.Clear;
  FModuleManager.Clear;
  FModuleManager.InstallMainModule( TServerCommandModule.Create( 'server'));
  IF FileExists( ExtractFilePath( ParamStr(0))+'okips.txt') THEN
    FAllowedIps.LoadFromFile(ExtractFilePath( ParamStr(0))+'okips.txt');
  LoadModules;
END;

procedure TService1.ServiceCreate(Sender: TObject);
begin
  Server.OnConnect:=InitThread;
  HTTPServer.OnConnect:=InitWebThread;
  FModuleManager:=TModuleManager.Create;
  FAllowedIPs:=TStringList.Create;
  Init;
end;

procedure TService1.InitThread(AThread: TIdPeerThread);
VAR
  td : TThreadData;
BEGIN
  IF (FAllowedIPs.Count>0) AND (FAllowedIPs.IndexOf( AThread.Connection.Socket.Binding.PeerIP)=-1) THEN RAISE Exception.Create( 'Not allowed to connect from this ip');
  td:=TThreadData.Create( NIL);
  td.Init( aThread, Self);
  AThread.Data:=td;
END;

procedure TService1.InitWebThread(AThread: TIdPeerThread);
VAR
  td : TWebThreadData;
BEGIN
  td:=TWebThreadData.Create( NIL);
  td.Init( aThread, Self);
  AThread.Data:=td;
END;


procedure TService1.ServiceDestroy(Sender: TObject);
begin
  FAllowedIPs.Free;
  FModuleManager.Free;
end;

procedure TService1.ServerReloadCommandCommand(ASender: TIdCommand);
begin
  FModuleManager.Items[0].Execute( ASender.Thread, 'reload', ASender.Params, ASender.Response, FModuleManager.Data);
end;


FUNCTION  TService1.GetFileContent( aModule, aFilename : STRING; VAR Content : STRING) : BOOLEAN;
BEGIN
  Content:='';
  Result:=TRUE;
  {$IFDEF WebExtern}
    aFilename:=FRootDir+'web\'+aModule+'\'+aFilename;
    IF FileExists( aFileName) THEN BEGIN
      Content:=LoadFile( aFilename);
    END
    ELSE result:=FALSE;
  {$ELSE}
  {$ENDIF}
END;



procedure TService1.HTTPServerCommandGet(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  TRY
    IF aThread.Data=NIL THEN aResponseInfo.ContentText:='ThreadData = NIL'
    ELSE TWebThreadData( aThread.Data).HTTPRequest( ARequestInfo, AResponseInfo);
  EXCEPT
    ON X : Exception DO BEGIN
      AResponseInfo.ContentType:='text/plain';
      AResponseInfo.ContentText:=AResponseInfo.ContentText+' Exception of Class '+X.ClassName+': '+X.Message;
    END;
  END;
end;

procedure TService1.ServerConnect(AThread: TIdPeerThread);
VAR
  i : INTEGER;
begin
  FOR i:=1 TO FModuleManager.Count DO BEGIN
    FModuleManager.Items[ i-1].ServerConnect( AThread);
  END;
end;

procedure TService1.ServerDisconnect(AThread: TIdPeerThread);
VAR
  i : INTEGER;
begin
  FOR i:=1 TO FModuleManager.Count DO BEGIN
    FModuleManager.Items[ i-1].ServerDisconnect( AThread);
  END;
end;

end.
