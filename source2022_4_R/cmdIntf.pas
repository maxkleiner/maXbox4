// Copyright 2008 Martin Herold und Toolbox Verlag

unit cmdIntf;

interface

USES
  Contnrs,
  Classes;

TYPE
  TCommandModule = CLASS;
  TmodCommand    = CLASS;

  ICommandServer = INTERFACE
    ['{6CB99555-D1A0-488B-B8F2-0E2C1C697F83}']
    FUNCTION InstallModule( aModule : TCommandModule) : INTEGER;
    FUNCTION GetModuleByName( aName : STRING) : TCommandModule;
    FUNCTION GetModuleCount : INTEGER;
    FUNCTION GetModule( i : INTEGER) : TCommandModule;
    PROCEDURE Execute( Thread : TThread; Module : STRING; Params, Response : TStrings);
  END;

  TmodCommand    = CLASS( tObject)
  private
    FOwner   : TCommandModule;
    FName    : STRING;
    FEnabled : BOOLEAN;
  public
    CONSTRUCTOR Create( aOwner : TCommandModule; aName : STRING);
    DESTRUCTOR  Destroy; OVERRIDE;
    PROCEDURE   Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent); VIRTUAL;
    PROPERTY    Name : STRING read FName;
    PROPERTY    Enabled : BOOLEAN read FEnabled write FEnabled;
    PROPERTY    Owner : TCommandModule read FOwner;
  END;

  TInfoCommand = CLASS( TModCommand)
  public
    PROCEDURE   Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent); OVERRIDE;
  END;
  

  TCommandModule = CLASS( tObjectList)
  private
    FName      : STRING;
    FEnabled   : BOOLEAN;
    FHandle    : THandle;
    FVersion   : TStringList;
    FMgr       : ICommandServer;
    FUNCTION    GetmodCommand( i : INTEGER) : TmodCommand;
    FUNCTION    GetModuleFilePath : STRING;
    FUNCTION    GetModuleFileName : STRING;
  protected
    PROPERTY    Handle : THandle read FHandle write FHandle;
    PROPERTY    Server : ICommandServer read FMgr write FMgr;
  public
    CONSTRUCTOR Create( aName : STRING);
    DESTRUCTOR  Destroy; OVERRIDE;
    PROCEDURE   ServerConnect( aThread : TThread); VIRTUAL;
    PROCEDURE   ServerDisconnect( aThread : TThread); VIRTUAL;
    FUNCTION    GetCommandByName( aName : STRING) : TmodCommand;
    PROCEDURE   Execute( Thread : TThread; Command : STRING; Params, Response : TStrings; Data : TComponent);
    PROPERTY    Name : STRING read FName;
    PROPERTY    Items[ i : INTEGER] : TmodCommand read GetmodCommand;
    PROPERTY    Enabled : BOOLEAN read FEnabled write FEnabled;
    PROPERTY    Mananger : ICommandServer read FMgr;
    PROPERTY    ModuleFilePath : STRING read GetModuleFilePath;
    PROPERTY    ModuleFileName : STRING read GetModuleFileName;
    Property    ModuleHandle : THandle read FHandle;
    PROPERTY    Version : TStringList read FVersion;
  END;



implementation

USES
  //fService,
  Windows,
  SysUtils;

CONSTRUCTOR TmodCommand.Create( aOwner : TCommandModule; aName : STRING);
BEGIN
  INHERITED Create;
  FOwner:=aOwner;
  FName:=aName;
  IF FOwner<>NIL THEN FOwner.Add( Self);
  FEnabled:=TRUE;
END;

DESTRUCTOR  TmodCommand.Destroy;
BEGIN
  IF FOwner<>NIL THEN FOwner.Extract( Self);
  INHERITED Destroy;
END;

PROCEDURE   TmodCommand.Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent);
BEGIN
  Respond.Add( 'Command is not yet implemented');
END;


PROCEDURE   TInfoCommand.Execute( Thread : TThread; Params, Respond : tStrings; Data : TComponent);
begin
  Respond.Add( 'title='+Owner.Version.Values[ 'FileDescription']);
  Respond.Add( 'company='+Owner.Version.Values['CompanyName']);
  Respond.Add( 'version='+Owner.Version.Values['FileVersion']);
  Respond.Add( 'path='+Owner.ModuleFilePath);
  Respond.Add( 'filename='+Owner.ModuleFileName);
END;





CONSTRUCTOR TCommandModule.Create( aName : STRING);
BEGIN
  INHERITED Create( TRUE);
  FVersion:=TStringList.Create;
  FName:=aName;
  FEnabled:=TRUE;
  TInfoCommand.Create( Self, 'info');
END;

DESTRUCTOR  TCommandModule.Destroy;
BEGIN
  FVersion.Free;
  INHERITED Destroy;
END;



FUNCTION    TCommandModule.GetModuleFilePath : STRING;
VAR
  MName : ARRAY[0..255] OF CHAR;
BEGIN
  FillChar( MName, SizeOf( MName), 0);
  Windows.GetModuleFileName( Handle, @MName, 256);
  Result:=ExtractFilePath( StrPas( MName));
END;

FUNCTION    TCommandModule.GetModuleFileName : STRING;
VAR
  MName : ARRAY[0..255] OF CHAR;
BEGIN
  FillChar( MName, SizeOf( MName), 0);
  Windows.GetModuleFileName( Handle, @MName, 256);
  Result:=ExtractFileName( StrPas( MName));
END;

FUNCTION    TCommandModule.GetmodCommand( i : INTEGER) : TmodCommand;
BEGIN
  Result:=TmodCommand( INHERITED Items[i]);
END;

FUNCTION    TCommandModule.GetCommandByName( aName : STRING) : TmodCommand;
VAR
  i : INTEGER;
BEGIN
  Result:=NIL;
  FOR i:=1 TO Count DO BEGIN
    IF SameText( Items[i-1].Name, aName) THEN BEGIN
      Result:=Items[i-1];
      Break;
    END;
  END;
END;

PROCEDURE   TCommandModule.Execute( Thread : TThread; Command : STRING; Params, Response : TStrings; Data : TComponent);
VAR
  CommandObj : TmodCommand;
BEGIN
  CommandObj:=GetCommandByName( Command);
  IF CommandObj=NIL THEN BEGIN
    Response.Add( 'result=-4');
    Response.Add( 'errortext=Unknown command '+Command+' in Module '+FName);
  END
  ELSE BEGIN
    TRY
      CommandObj.Execute( Thread, Params, Response, Data);
    EXCEPT
      ON X : Exception DO BEGIN
        Response.Clear;
        Response.Add( 'result=-5');
        Response.Add( 'errortext='+X.Message);
        Response.Add( 'command='+Command);
        Response.Add( 'module='+FName);
      END;
    END;
  END;
END;

PROCEDURE   TCommandModule.ServerConnect( aThread : TThread);
BEGIN

END;

PROCEDURE   TCommandModule.ServerDisconnect( aThread : TThread);
BEGIN

END;



end.
