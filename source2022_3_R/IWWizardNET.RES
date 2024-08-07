        ��  ��                  (  H   ��
 I W _ S T A N D A L O N E _ P R O J E C T       0
        program %s;

uses
  %sIWMain,
  ServerController in 'ServerController.pas' {IWServerController: TIWServerController},%s
  %s in '%s.pas' {%s: TIWFormModuleBase};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormIWMain, formIWMain);
  Application.Run;
end.
�   8   ��
 I W _ U N I T _ F I L E         0
        unit %s;

interface

uses
  Classes, SysUtils, IWAppForm%s, IWApplication, IWColor, IWTypes;

type
  T%s = class(TIWAppForm%s)
  public
  end;

implementation

{$R %s}

%s
end.
 K   8   ��
 I W _ F O R M _ F I L E         0
        object %s: T%s
  Left = 0
  Top = 0
  Width = 555
  Height = 400
end
   P   ��
 I W _ S E R V E R C O N T R O L L E R _ F I L E         0
        unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  %sIWApplication, IWAppForm;

type
  TIWServerController = class(TIWServerControllerBase)
    %s
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication;
      var VMainForm: TIWBaseForm);
    %s 
  private
  public
  end;

  
  function UserSession: TIWUserSession;
  function IWServerController: TIWServerController;

implementation
{$R %s}

uses
  IWInit, IWGlobal;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;

%s

procedure TIWServerController.IWServerControllerBaseNewSession(
  ASession: TIWApplication; var VMainForm: TIWBaseForm);
begin
  ASession.Data := TIWUserSession.Create(nil);
end;


initialization
  TIWServerController.SetServerControllerClass;

end.

    P   ��
 I W _ S E R V E R C O N T R O L L E R _ F O R M         0
        object IWServerController: TIWServerController
  OldCreateOrder = False
  AllowSubFolders = False
  AppName = 'MyApp'
  ComInitialization = ciNone
  SessionTrackingMethod = tmURL
  Description = 'My IntraWeb Application'
  ExceptionDisplayMode = smAlert
  ExecCmd = 'EXEC'
  HistoryEnabled = False
  Port = 8888
  RestrictIPs = False
  ShowResyncWarning = True
  SessionTimeout = 10
  SSLOptions.Port = 0
  Version = 'Internal'
  Left = 367
  Top = 314
  Height = 310
  Width = 342
  %s
  %s
end
 *  d   ��
 I W _ S E R V E R C O N T R O L L E R _ F I L E _ N O _ S E S S I O N       0
        unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, HTTPApp,
  IWApplication, IWBaseForm;

type
  TIWServerController = class(TIWServerControllerBase)
    %s
    %s
  private
  public
  end;

  function IWServerController: TIWServerController;
  
implementation
{$R %s}

uses
  IWInit, IWGlobal;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

%s

initialization
  TIWServerController.SetServerControllerClass;

end.

  *  X   ��
 I W _ S E R V E R C O N T R O L L E R _ P O O L _ F I L E       0
        unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  %sIWApplication, IWAppForm, DataModuleUnit, IWDataModulePool;

type
  TIWServerController = class(TIWServerControllerBase)
    %s
    Pool: TIWDataModulePool;
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication;
      var VMainForm: TIWBaseForm);
    procedure IWServerControllerBaseCreate(Sender: TObject);
    procedure PoolCreateDataModule(var ADataModule: TDataModule);
    procedure PoolFreeDataModule(var ADataModule: TDataModule);
  private
  public
  end;

  function UserSession: TIWUserSession;
  function IWServerController: TIWServerController;
  function LockDataModule: TDataModule1;
  procedure UnlockDataModule(ADataModule: TDataModule1);

implementation

{$R %s}

uses
  IWInit, IWGlobal;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

procedure TIWServerController.IWServerControllerBaseNewSession(
  ASession: TIWApplication; var VMainForm: TIWBaseForm);
begin
  ASession.Data := TIWUserSession.Create(nil);
end;

procedure TIWServerController.IWServerControllerBaseCreate(Sender: TObject);
begin
  Pool.Active := True;
  %s
end;

procedure TIWServerController.PoolCreateDataModule(var ADataModule: TDataModule);
begin
  ADataModule := TDataModule1.Create(nil);
end;

procedure TIWServerController.PoolFreeDataModule(var ADataModule: TDataModule);
begin
  FreeAndNil(ADataModule);
end;

function LockDataModule: TDataModule1;
begin
  Result := TDataModule1(TIWServerController(GServerController).Pool.Lock);
end;

procedure UnlockDataModule(ADataModule: TDataModule1);
var
  LTemp: TDataModule;
begin
  LTemp := ADataModule;
  TIWServerController(GServerController).Pool.Unlock(LTemp);
end;


initialization
  TIWServerController.SetServerControllerClass;

end.

  E  p   ��
 I W _ S E R V E R C O N T R O L L E R _ P O O L _ F I L E _ N O _ S E S S I O N         0
        unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, HTTPApp,
  DataModuleUnit, IWDataModulePool, IWApplication, IWBaseForm;

type
  TIWServerController = class(TIWServerControllerBase)
    %s
    Pool: TIWDataModulePool;
    procedure IWServerControllerBaseCreate(Sender: TObject);
    procedure PoolCreateDataModule(var ADataModule: TDataModule);
    procedure PoolFreeDataModule(var ADataModule: TDataModule);
  private
  public
  end;

  function IWServerController: TIWServerController;
  function LockDataModule: TDataModule1;
  procedure UnlockDataModule(ADataModule: TDataModule1);

implementation

{$R %s}

uses
  IWInit, IWGlobal;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

procedure TIWServerController.IWServerControllerBaseCreate(Sender: TObject);
begin
  Pool.Active := True;
  %s
end;

procedure TIWServerController.PoolCreateDataModule(var ADataModule: TDataModule);
begin
  ADataModule := TDataModule1.Create(nil);
end;

procedure TIWServerController.PoolFreeDataModule(var ADataModule: TDataModule);
begin
  FreeAndNil(ADataModule);
end;

function LockDataModule: TDataModule1;
begin
  Result := TDataModule1(TIWServerController(GServerController).Pool.Lock);
end;

procedure UnlockDataModule(ADataModule: TDataModule1);
var
  LTemp: TDataModule;
begin
  LTemp := ADataModule;
  TIWServerController(GServerController).Pool.Unlock(LTemp);
end;

initialization
  TIWServerController.SetServerControllerClass;

end.

   E  X   ��
 I W _ S E R V E R C O N T R O L L E R _ P O O L _ F O R M       0
        object IWServerController: TIWServerController
  OldCreateOrder = False
  AllowSubFolders = False
  AppName = 'MyApp'
  ComInitialization = ciNone
  SessionTrackingMethod = tmURL
  Description = 'My IntraWeb Application'
  ExceptionDisplayMode = smAlert
  ExecCmd = 'EXEC'
  HistoryEnabled = False
  Port = 8888
  RestrictIPs = True
  ShowResyncWarning = True
  SessionTimeout = 10
  SSLOptions.Port = 0
  SupportedBrowsers = [brIE, brNetscape6, brOpera]
  Version = 'Internal'
  Left = 367
  Top = 314
  Height = 310
  Width = 342
  OnCreate = IWServerControllerBaseCreate
  %s
  object Pool: TIWDataModulePool
    OnCreateDataModule = PoolCreateDataModule
    OnFreeDataModule = PoolFreeDataModule
    PoolCount = 20
    Active = False
    Version = '0.1.1b'
    Left = 60
    Top = 12
  end
  %s
end
   �  0   ��
 I W _ D E P L O Y       0
        <?xml version="1.0"?>
<DeployTarget>
  <Title>Target1</Title>
  <Active>0</Active>
  <Options>
    <LogFilename>DeployLog.txt</LogFilename>
    <EnableLogging>0</EnableLogging>
  </Options>
  <Rules>
    <Rule>
      <Title>Executables</Title>
      <Filter>*.%s</Filter>
      <Ignored>0</Ignored>
    </Rule>
    <Rule>
      <Title>HTML Files</Title>
      <Filter>*.html;*.htm;*.css;*.js</Filter>
      <Ignored>0</Ignored>
    </Rule>
    <Rule>
      <Title>Image Files</Title>
      <Filter>*.jpg;*.bmp;*.dib;*.png;*.tiff;*.gif</Filter>
      <Ignored>0</Ignored>
    </Rule>
    <Rule>
      <Title>Other Files</Title>
      <Filter>*.*</Filter>
      <Ignored>1</Ignored>
    </Rule>  </Rules>
  <Locations>
    <Location>
      <LocationID>Borland.Studio.Directory</LocationID>
      <Borland.Studio.Directory>
        <Active>0</Active>
        <Directory></Directory>
      </Borland.Studio.Directory>
    </Location>
    <Location>
      <LocationID>Borland.Studio.FTP</LocationID>
      <Borland.Studio.FTP>
        <Active>0</Active>
        <Server></Server>
        <Port>21</Port>
        <Folder></Folder>
        <UserName></UserName>
        <PassiveMode>0</PassiveMode>
        <AnonymousLogin>0</AnonymousLogin>
      </Borland.Studio.FTP>
    </Location>
  </Locations>
  <RenamedFiles/>
  <Ignorediles/>
  <LocationHistories/>
</DeployTarget>
    @   ��
 I W _ I S A P I _ P R O J E C T         0
        library %s;

uses
  %sServerController in 'ServerController.pas' {IWServerController: TIWServerController},%s
  %s in '%s.pas' {%s: TIWFormModuleBase};
  
{$R *.RES}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  IWRun;
end.
  &  @   ��
 I W _ A P A C H E _ P R O J E C T       0
        library %s;

uses
  %sApacheApp,
  IWInitApache,
  ServerController in 'ServerController.pas' {IWServerController: TIWServerController},%s
  %s in '%s.pas' {%s: TIWFormModuleBase};

{$E so}

{$R *.res}

exports
  apache_module name 'IWDSOProject_module';

begin
  IWRun;
end.
  2  H   ��
 I W _ A P A C H E T W O _ P R O J E C T         0
        library %s;

uses
  %sIWInitApacheTwo,
  ApacheTwoApp, 
  ServerController in 'ServerController.pas' {IWServerController: TIWServerControllerBase},%s
  %s in '%s.pas' {%s: TIWFormModuleBase};

{$E so}

{$R *.RES}

exports
  apache_module name 'IWDSO2Project_module';

begin
  IWRun;
end.
  �   D   ��
 I W _ S E R V I C E _ P R O J E C T         0
        program %s;

uses
  %sIWInitService,
  ServerController in 'ServerController.pas' {IWServerController: TIWServerController},%s
  %s in '%s.pas' {%s: TIWFormModuleBase};

{$R *.res}

begin
  IWRun;
end.

d  D   ��
 I W _ D A T A M O D U L E _ F I L E         0
        unit DatamoduleUnit;

interface

uses
  {$IFDEF Linux}QForms, {$ELSE}Forms, {$ENDIF}
  SysUtils, Classes;

type
  TDataModule1 = class(TDataModule)
  private
  public
  end;

// Procs
  function DataModule1: TDataModule1;

implementation
{$R %s}

uses
  IWInit,
  ServerController;

// Since we are threaded we cannot use global variables to store form / datamodule references
// so we store them in WebApplication.Data and we could reference that each time, but by creating
// a function like this our other code looks "normal" almost as if its referencing a global.
// This function is not necessary but it makes the code in the main form which references this
// datamodule a lot neater.
// Without this function every time we would reference this datamodule we would use:
//   TDataModule1(WebApplication.Data).Datamodule.<method / component>
// By creating this procedure it becomes:
//   TDataModule1.<method / component>
// Which is just like normal Delphi code.

function DataModule1: TDataModule1;
begin
  Result := TUserSession(WebApplication.Data).Datamodule1;
end;

end.
{   D   ��
 I W _ D A T A M O D U L E _ F O R M         0
        object DataModule1: TDataModule1
  OldCreateOrder = False
  Left = 472
  Top = 220
  Height = 150
  Width = 215
end
 �   L   ��
 I W _ D A T A M O D U L E _ P O O L _ F I L E       0
        unit DataModuleUnit;

interface

uses
  {$IFDEF Linux}QForms, {$ELSE}Forms, {$ENDIF}
  SysUtils, Classes;

type
  TDataModule1 = class(TDataModule)
  private
  public
  end;

  
implementation

{$R %s}

end.
�  D   ��
 I W _ U S E R S E S S I O N _ F I L E       0
        unit UserSessionUnit;

{
  This is a DataModule where you can add components or declare fields that are specific to 
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface

uses
  IWUserSessionBase, SysUtils, Classes;

type
  TIWUserSession = class(TIWUserSessionBase)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.   {   D   ��
 I W _ U S E R S E S S I O N _ F O R M       0
        object UserSession: TIWUserSession
  OldCreateOrder = False
  Left = 192
  Top = 160
  Height = 150
  Width = 215
end {   D   ��
 I W _ U E S R S E S S I O N _ F O R M       0
        object UserSession: TIWUserSession
  OldCreateOrder = False
  Left = 192
  Top = 160
  Height = 150
  Width = 215
end �   8   ��
 I W _ P A G E _ F I L E         0
        unit %s;

interface

uses
  Classes, SysUtils, IWApplication, IWTypes, IWPageForm%s, IWInit, IWLicenseKey;

type
  T%s = class(TIWPageForm%s)
  public
  end;

implementation

{$R %s}

%s

end.  �   8   ��
 I W _ P A G E _ F O R M         0
        object %s: T%s
  Left = 0
  Top = 0
  Width = 349
  Height = 296
  AutoProcess = True
  PostToSelf = True
  DesignLeft = 340
  DesignTop = 125
end
   :  8   ��
 I W _ F R A M E _ U N I T       0
        unit %s;

interface

uses
  SysUtils, Classes, Controls, Forms,
  IWVCLBaseContainer, IWColor, IWContainer, IWRegion%s;

type
  T%s = class(TFrame)
    IWFrameRegion: TIWRegion%s;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R %s}

end.  �   8   ��
 I W _ F R A M E _ F I L E       0
        object %s: T%s
  Left = 0
  Top = 0
  Width = 343
  Height = 169
  TabOrder = 0
  object IWFrameRegion: TIWRegion%s
    TabOrder = 0
    %s
    %s
  end
end �  P   ��
 I W _ B C B _ S T A N D A L O N E _ P R O J E C T       0
        //---------------------------------------------------------------------------

#include <%s.h>
#pragma hdrstop
USERES("%s.res");
USEFORM("%s.cpp", %s);
USEFORM("ServerController.cpp", IWServerController);
//---------------------------------------------------------------------------
#include <IWMain.hpp>
//---------------------------------------------------------------------------
%s
{
        try
        {
          %s::Application->Initialize();
          %s::Application->CreateForm(__classid(TFormIWMain), &FormIWMain);
          %s::Application->Run();
        }
        catch (Exception &exception)
        {

        }
        return 0;
}
//---------------------------------------------------------------------------
�  @   ��
 I W _ B C B _ U N I T _ F I L E         0
        //---------------------------------------------------------------------------

#include <%s.h>
#pragma hdrstop

#include "%s.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "%s"
//---------------------------------------------------------------------------
__fastcall %s::%s(TComponent* Owner)
        : %s(Owner)
{

}
//---------------------------------------------------------------------------

%s  �  D   ��
 I W _ B C B _ U N I T _ H _ F I L E         0
        //---------------------------------------------------------------------------

#ifndef %sH
#define %sH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <%sControls.hpp>
#include <%sStdCtrls.hpp>
#include <%sForms.hpp>
#include <%s.hpp>
%s
//---------------------------------------------------------------------------
class %s: public %s
{
__published:	// IDE-managed Components
private:	// User declarations
public:		// User declarations
        __fastcall %s(TComponent* Owner);
};
//---------------------------------------------------------------------------
#endif
  �  L   ��
 I W _ B C B _ U S E R S E S S I O N _ F I L E       0
        //---------------------------------------------------------------------------

#include <%s.h>
#pragma hdrstop

#include "UserSessionUnit.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "%s"

//---------------------------------------------------------------------------
TIWUserSession* UserSession()
{
  return (TIWUserSession*)WebApplication->Data;
}

//---------------------------------------------------------------------------
__fastcall TIWUserSession ::TIWUserSession (TComponent* Owner)
        : TIWUserSessionBase(Owner)
{
}
//---------------------------------------------------------------------------


�  P   ��
 I W _ B C B _ U S E R S E S S I O N _ H E A D E R       0
        //---------------------------------------------------------------------------

#ifndef UserSessionUnitH
#define UserSessionUnitH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <IWUserSessionBase.hpp>
#include <IWApplication.hpp>
#include <IWInit.hpp>
//---------------------------------------------------------------------------
class TIWUserSession : public TIWUserSessionBase
{
__published:	// IDE-managed Components
private:	// User declarations
public:		// User declarations
        __fastcall TIWUserSession(TComponent* Owner);
};

extern TIWUserSession* UserSession();

#endif   �  X   ��
 I W _ B C B _ S E R V E R C O N T R O L L E R _ F I L E         0
        //---------------------------------------------------------------------------

#include <%s.h>
#pragma hdrstop

#include "ServerController.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "%s"

//---------------------------------------------------------------------------
__fastcall TIWServerController::TIWServerController(TComponent* Owner)
        : TIWServerControllerBase(Owner)
{
}
//---------------------------------------------------------------------------
%s

void setServerController() {
  TIWServerController::SetServerControllerClass(__classid(TIWServerController));
}

#pragma startup setServerController
 h  \   ��
 I W _ B C B _ S E R V E R C O N T R O L L E R _ H E A D E R         0
        //---------------------------------------------------------------------------

#ifndef ServerControllerH
#define ServerControllerH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <IWServerControllerBase.hpp>
#include <IWApplication.hpp>
#include <IWInit.hpp>
%s
//---------------------------------------------------------------------------
class TIWServerController  : public TIWServerControllerBase
{
__published:	// IDE-managed Components
%s
private:	// User declarations
public:		// User declarations
        __fastcall TIWServerController(TComponent* Owner);
};

//---------------------------------------------------------------------------
extern PACKAGE TIWServerController *IWServerController;
//---------------------------------------------------------------------------
#endif
(  `   ��
 I W _ B C B _ S E R V E R C O N T R O L L E R _ P O O L _ F I L E       0
        //---------------------------------------------------------------------------

#include <%s.h>
#pragma hdrstop

#include "ServerController.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "%s"

//---------------------------------------------------------------------------
__fastcall TIWServerController::TIWServerController(TComponent* Owner)
        : TIWServerControllerBase(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TIWServerController::IWServerControllerBaseNewSession(
      TIWApplication *ASession, TIWBaseForm *&VMainForm)
{
  %s
}
//---------------------------------------------------------------------------

void __fastcall TIWServerController::IWServerControllerBaseCreate(
      TObject *Sender)
{
   Pool->Active = true;
}
//---------------------------------------------------------------------------
void __fastcall TIWServerController::PoolCreateDataModule(
      TDataModule *&ADataModule)
{
  ADataModule = new TDataModule1(NULL);
}
//---------------------------------------------------------------------------
void __fastcall TIWServerController::PoolFreeDataModule(
      TDataModule *&ADataModule)
{
  ADataModule->Free();
}
//---------------------------------------------------------------------------

TDataModule1 LockDataModule()
{
  return (TDataModule1)((TIWServerController)GServerController.Pool.Lock());
}

//---------------------------------------------------------------------------

void UnlockDataModule(TDataModule1 &ADataModule)
{
  TDataModule &LTemp;

  LTemp = ADataModule;
  ((TIWServerController)GServerController).Pool.Unlock(LTemp);
}
//---------------------------------------------------------------------------
void setServerController() {
  TIWServerController::SetServerControllerClass(__classid(TIWServerController));
}
//---------------------------------------------------------------------------

#pragma startup setServerController
b  d   ��
 I W _ B C B _ S E R V E R C O N T R O L L E R _ P O O L _ H E A D E R       0
        //---------------------------------------------------------------------------

#ifndef ServerControllerH
#define ServerControllerH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <IWServerControllerBase.hpp>
#include <IWDataModulePool.h>
#include <IWApplication.hpp>
#include <IWInit.hpp>
%s
//---------------------------------------------------------------------------
class TIWServerController  : public TIWServerControllerBase
{
__published:	// IDE-managed Components
        TIWDataModulePool *Pool;
%s
        void __fastcall IWServerControllerBaseNewSession(
          TIWApplication *ASession, TIWBaseForm *&VMainForm);

        void __fastcall IWServerControllerBaseCreate(TObject *Sender);
        void __fastcall PoolCreateDataModule(TDataModule *&ADataModule);
        void __fastcall PoolFreeDataModule(TDataModule *&ADataModule);
private:	// User declarations
public:		// User declarations
        __fastcall TIWServerController(TComponent* Owner);
};

extern void UnlockDataModule(TDataModule1 &ADataModule);
extern TDataModule1 LockDataModule();

//---------------------------------------------------------------------------
extern PACKAGE TIWServerController *IWServerController;
//---------------------------------------------------------------------------
#endif
  �  L   ��
 I W _ B C B _ D A T A M O D U L E _ F I L E         0
        //---------------------------------------------------------------------------

#include <%s.h>
#pragma hdrstop

#include "DatamoduleUnit.h"
#include "ServerController.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "%s"
//---------------------------------------------------------------------------
__fastcall TDataModule1::TDataModule1(TComponent* Owner)
        : TDataModule(Owner)
{
}
//---------------------------------------------------------------------------
TDataModule1* getDataModule1()
{
  return UserSession()->DataModule1;
}
//---------------------------------------------------------------------------
 "  P   ��
 I W _ B C B _ D A T A M O D U L E _ H E A D E R         0
        //---------------------------------------------------------------------------

#ifndef DatamoduleUnitH
#define DatamoduleUnitH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <%sControls.hpp>
#include <%sStdCtrls.hpp>
#include <%sForms.hpp>
//---------------------------------------------------------------------------
class TDataModule1 : public TDataModule
{
__published:	// IDE-managed Components
private:	// User declarations
public:		// User declarations
        __fastcall TDataModule1(TComponent* Owner);
};

//---------------------------------------------------------------------------
extern TDataModule1* getDataModule1();
//---------------------------------------------------------------------------
#endif
  �  @   ��
 I W _ B C B _ F R A M E _ U N I T       0
        //---------------------------------------------------------------------------

#include <%s.h>
#pragma hdrstop

#include "%s.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "%s"
//---------------------------------------------------------------------------
__fastcall %s::%s(TComponent* Owner)
        : TFrame(Owner)
{

}
//---------------------------------------------------------------------------

�  P   ��
 I W _ B C B _ F R A M E _ U N I T _ H _ F I L E         0
        //---------------------------------------------------------------------------

#ifndef %sH
#define %sH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <%sControls.hpp>
#include <%sStdCtrls.hpp>
#include <%sForms.hpp>
#include <IWColor.hpp>
#include <IWRegion%s.hpp>
//---------------------------------------------------------------------------
class %s: public TFrame
{
__published:	// IDE-managed Components
 TIWRegion%s *IWFrameRegion;
private:	// User declarations
public:		// User declarations
        __fastcall %s(TComponent* Owner);
};
//---------------------------------------------------------------------------
#endif
d  L   ��
 I W _ B C B _ I S A P I _ P R O J E C T _ 5 0       0
        //---------------------------------------------------------------------------
#include <vcl.h>
#include <IWInitISAPI.hpp>

#pragma hdrstop

USERES("%s.res");
USEFORM("%s.cpp", %s);
USEFORM("ServerController.cpp", IWServerController);
//---------------------------------------------------------------------------
#define Application Webbroker::Application

#pragma link "isapiapp.obj"
#pragma link "webbroker.obj"
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
  try {
    switch (reason) {
      case DLL_PROCESS_ATTACH: {
        IWRun();
        break;
      }
    }

  }
  catch (Exception &exception)
  {
  }
  return 1;
}
//---------------------------------------------------------------------------
extern "C"
{
  BOOL __declspec(dllexport) WINAPI GetExtensionVersion(Isapi2::THSE_VERSION_INFO &Ver)
  {
      return Isapiapp::GetExtensionVersion(Ver);
  }
  //---------------------------------------------------------------------------
  unsigned __declspec(dllexport) WINAPI HttpExtensionProc(Isapi2::TEXTENSION_CONTROL_BLOCK &ECB)
  {
      return Isapiapp::HttpExtensionProc(ECB);
  }
  //---------------------------------------------------------------------------
  BOOL __declspec(dllexport) WINAPI TerminateExtension(int dwFlags)
  {
      return Isapiapp::TerminateExtension(dwFlags);
  }
}
//---------------------------------------------------------------------------
#undef Application
//---------------------------------------------------------------------------
�  L   ��
 I W _ B C B _ I S A P I _ P R O J E C T _ 6 0       0
        //---------------------------------------------------------------------------
#include <ActiveX.hpp>
#include <ComObj.hpp>
#include <WebBroker.hpp>
#include <ISAPIApp.hpp>
#include <Isapi2.hpp>
#include <IWInitISAPI.hpp>

#pragma hdrstop

USERES("%s.res");
USEFORM("%s.cpp", %s);
USEFORM("ServerController.cpp", IWServerController);
//---------------------------------------------------------------------------
#define Application Webbroker::Application

#pragma link "isapiapp.obj"
#pragma link "webbroker.obj"
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
  try {
    switch (reason) {
      case DLL_PROCESS_ATTACH: {
        CoInitFlags = COINIT_MULTITHREADED;
        IWRun();
        break;
      }
    }

  }
  catch (Exception &exception)
  {
  }
  return 1;
}
//---------------------------------------------------------------------------
extern "C"
{
  BOOL __declspec(dllexport) WINAPI GetExtensionVersion(Isapi2::THSE_VERSION_INFO &Ver)
  {
    return Isapiapp::GetExtensionVersion(Ver);
  }
  //---------------------------------------------------------------------------
  unsigned __declspec(dllexport) WINAPI HttpExtensionProc(Isapi2::TEXTENSION_CONTROL_BLOCK &ECB)
  {
    return Isapiapp::HttpExtensionProc(ECB);
  }
  //---------------------------------------------------------------------------
  BOOL __declspec(dllexport) WINAPI TerminateExtension(int dwFlags)
  {
    return Isapiapp::TerminateExtension(dwFlags);
  }
}
//---------------------------------------------------------------------------
#undef Application
//---------------------------------------------------------------------------
  K  `   ��
 I W _ B C B _ I S A P I T H R E A D P O O L _ P R O J E C T _ 6 0       0
        //---------------------------------------------------------------------------
#include <ActiveX.hpp>
#include <ComObj.hpp>
#include <WebBroker.hpp>
#include <ISAPIApp.hpp>
#include <ISAPIThreadPool.hpp>
#include <Isapi2.hpp>
#include <IWInitISAPI.hpp>

#pragma hdrstop

USERES("%s.res");
USEFORM("%s.cpp", %s);
USEFORM("ServerController.cpp", IWServerController);
//---------------------------------------------------------------------------
#define Application Webbroker::Application

#pragma link "isapiapp.obj"
#pragma link "isapithreadpool.obj"
#pragma link "webbroker.obj"
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
  try {
    switch (reason) {
      case DLL_PROCESS_ATTACH: {
        CoInitFlags = COINIT_MULTITHREADED;
        IWRun();
        break;
      }
    }

  }
  catch (Exception &exception)
  {
  }
  return 1;
}
//---------------------------------------------------------------------------
extern "C"
{
  BOOL __declspec(dllexport) WINAPI GetExtensionVersion(Isapi2::THSE_VERSION_INFO &Ver)
  {
    return Isapithreadpool::GetExtensionVersion(Ver);
  }
  //---------------------------------------------------------------------------
  unsigned __declspec(dllexport) WINAPI HttpExtensionProc(Isapi2::TEXTENSION_CONTROL_BLOCK &ECB)
  {
    return Isapithreadpool::HttpExtensionProc(ECB);
  }
  //---------------------------------------------------------------------------
  BOOL __declspec(dllexport) WINAPI TerminateExtension(int dwFlags)
  {
    return Isapithreadpool::TerminateExtension(dwFlags);
  }
}
//---------------------------------------------------------------------------
#undef Application
//---------------------------------------------------------------------------
 %  H   ��
 I W _ B C B _ A P A C H E _ P R O J E C T       0
        //---------------------------------------------------------------------------

#include <WebBroker.hpp>
#include <ApacheApp.hpp>
#include <IWInitApache.hpp>
#pragma hdrstop


USERES("%s.res");
USEFORM("%s.cpp", %s);
USEFORM("ServerController.cpp", IWServerController);
//---------------------------------------------------------------------------
#define Application Webbroker::Application
//---------------------------------------------------------------------------
extern "C"
{
  /* This module is the exported entry point accessed by Apache.
     Use the name of this variable in the httpd.conf file when loading
     this module, but preced it with an underscore:

     #### Start httpd.conf suggestion
     LoadModule _%s_module "C:\FullPathToTheDll.dll"
     <Location /some_location>
       SetHandler %s-handler
     </Location>
    #### End httpd.conf suggestion

    Be sure to put the LoadModule directive after the ClearModuleList
    directive in the httpd.conf file.

    To change the default handler name and the ModuleName, do a strcpy in
    the DllEntryPoint function below, such as:

    ...

      if (reason == DLL_PROCESS_ATTACH) {
        strcpy(ContentType, "custom_handler_name-handler");
        strcpy(ModuleName, "unique_module_name");
    ...

    */

  Httpd::module __declspec(dllexport) %s_module;
}

//---------------------------------------------------------------------------
%s
{
  try
  {
    if (reason == DLL_PROCESS_ATTACH) {
      Apacheapp::set_module(&%s_module);
      IWRun();
    }
  }
  catch (Exception &exception)
  {
  }
  return 1;
}
%s
//---------------------------------------------------------------------------
#undef Application
//---------------------------------------------------------------------------
     P   ��
 I W _ B C B _ A P A C H E T W O _ P R O J E C T         0
        //---------------------------------------------------------------------------

#include <WebBroker.hpp>
#include <ApacheAppTwo.hpp>
#include <IWInitApacheTwo.hpp>
#pragma hdrstop


USERES("%s.res");
USEFORM("%s.cpp", %s);
USEFORM("ServerController.cpp", IWServerController);
//---------------------------------------------------------------------------
#define Application Webbroker::Application

//#pragma link "ApacheAppTwo.obj"
//#pragma link "webbroker.obj"
//#pragma link "ReqMulti.obj"
//#pragma link "WebSnap.lib"
//#pragma link "WebDSnap.lib"

//---------------------------------------------------------------------------
extern "C"
{
  /* This module is the exported entry point accessed by Apache.
     Use the name of this variable in the httpd.conf file when loading
     this module, but preced it with an underscore:

     #### Start httpd.conf suggestion
     LoadModule _%s_module "C:\FullPathToTheDll.dll"
     <Location /some_location>
       SetHandler %s-handler
     </Location>
    #### End httpd.conf suggestion

    Be sure to put the LoadModule directive after the ClearModuleList
    directive in the httpd.conf file.

    To change the default handler name and the ModuleName, do a strcpy in
    the DllEntryPoint function below, such as:

    ...

      if (reason == DLL_PROCESS_ATTACH) {
        strcpy(ContentType, "custom_handler_name-handler");
        strcpy(ModuleName, "unique_module_name");
    ...

    */

  Httpd::module __declspec(dllexport) %s_module;
}

//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
  try
  {
    if (reason == DLL_PROCESS_ATTACH) {
      Apacheapp::set_module(&%s_module);
      IWRun();
    }
  }
  catch (Exception &exception)
  {
  }
  return 1;
}
//---------------------------------------------------------------------------
#undef Application
//---------------------------------------------------------------------------
  S  L   ��
 I W _ B C B _ S E R V I C E _ P R O J E C T         0
        //---------------------------------------------------------------------------

#include <vcl.h>
#include <IWInitService.hpp>
#pragma hdrstop

USERES("%s.res");
USEFORM("%s.cpp", %s);
USEFORM("ServerController.cpp", IWServerController);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
          IWRun();
        }
        catch (Exception &exception)
        {

        }
        return 0;
}
//---------------------------------------------------------------------------
 