unit JsSendMail;

interface uses Windows, Classes, Mapi,
               Variants, ComObj, Dialogs;

{
- Wenn ohne Edit-Dialog gesendet wird erscheint in Outlook eine Sicherheitswarnung:
  Abschalten nicht möglich.
  Das Programm ClickYes von contextmagic.com soll es angeblich abschalten können.
  Kostenloses Add-In: Advanced Security for Outlook von mapilab.com
  In Outlook 2007 kann über Extras/Vertrauensstellungscenter/Programmgesteuerter Zugang die Sicherheitswarnung deaktiviert werden.
  Funktioniert bei mir aber nicht.
- Test mit Mozilla Thunderbird 1.5.0.4 vom 16.05.2006 verlief einwandfrei. Auch hier kam eine Sicherheitswarnung.
  Zughold hat 2.0.0.8, am 22.12.2009 Update auf 2.0.0.23 und Probleme mit Mapi.
}

type
  TJsMapiMail = class(TComponent)
  private
    FSessionHandle:Cardinal;
    FParentWindowHandle:Cardinal;
    FReturnCode: Cardinal;

    FMapiMessage:TMapiMessage;
    FMapiRecipients:array of TMapiRecipDesc;
    FMapiAttachments:array of TMapiFileDesc;

    FSubject: string;
    FBody: string;

    FSenderName: string;
    FSenderAddress: string;

    FRecipients: TStrings;
    FCCRecipients: TStrings;
    FBCCRecipients: TStrings;
    FAttachments: TStrings;

    FEditDialog: Boolean;
    FResolveNames: Boolean;
    FRequestReceipt: Boolean;

    procedure SetAttachments(Value: TStrings);
    procedure SetRecipients(Value: TStrings);
    procedure SetCCRecipients(Value: TStrings);
    procedure SetBCCRecipients(Value: TStrings);
  protected
    procedure FreeMapiMessage;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Connected: Boolean;
    function Connect: Boolean;
    function Disconnect: Boolean;
    function IsSimpleMapiInstalled:Boolean;
    function IsExtendedMapiInstalled:Boolean; // wird auch nur Mapi genannt
    function GetStandardEMailClient:string;
    function GetMapiParentWnd: Cardinal;
    function GetErrorCode: Cardinal;
    function GetErrorMessage(iErrorCode: Cardinal): string;
    procedure SetRecipientsStr(aRecipients:TStrings; Value: String);
    function SendMail: Boolean;
    function SendMailWithOle: Boolean;
  published
    property SenderName: string read FSenderName write FSenderName;
    property SenderAddress: string read FSenderAddress write FSenderAddress;
    property Subject: string read FSubject write FSubject;
    property Body: string read FBody write FBody;

    property Recipients: TStrings read FRecipients write SetRecipients;
    property CCRecipients: TStrings read FCCRecipients write SetCCRecipients;
    property BCCRecipients: TStrings read FBCCRecipients write SetBCCRecipients;
    property Attachments: TStrings read FAttachments write SetAttachments;

    property EditDialog: Boolean read FEditDialog write FEditDialog;
    property ResolveNames: Boolean read FResolveNames write FResolveNames;
    property RequestReceipt: Boolean read FRequestReceipt write FRequestReceipt;
  end;

//procedure Register;


implementation uses Forms, SysUtils, Registry, StrUtils;

{
procedure Register;
begin
  RegisterComponents('Extras', [TJsMapiMail]);
end;
}

// *********************************************************************************************************************
resourcestring
  errMapiUserAbort                  = 'Operation abgebrochen.'; // wenn man das EMail-Bearbeitungsfenster abbricht
  errMapiFailure                    = 'Allgemeiner MAPI-Fehler.';
  errMapiLoginFailure               = 'MAPI Login Fehler.';
  errMapiDiskFull                   = 'Disk Full.';
  errMapiInsufficientMemory         = 'Zu wenig Speicher.';
  errMapiAccessDenied               = 'Zugriff verweigert.';
  errMapiTooManySessions            = 'Zu viele MAPI-Sessions.';
  errMapiTooManyFiles               = 'Zu viele Dateien im Anhang.';
  errMapiTooManyRecipients          = 'Zu viele Empfänger.';
  errMapiAttachmentNotFound         = 'Anhang nicht gefunden.';
  errMapiAttachmentOpenFailure      = 'Anhang konnte nicht geöffnet werden.';
  errMapiAttachmentWriteFailure     = 'Anhang konnte nicht geschrieben werden.';
  errMapiUnknownRecipient           = 'Empfänger fehlt.';
  errMapiBadRecipType               = 'Ungültiger Empfängertyp.';
  errMapiNoMessages                 = 'Mitteilungstext ist leer.';
  errMapiInvalidMessage             = 'Die E-Mail ist ungültig.';
  errMapiTextTooLarge               = 'Der Mitteilungstext ist zu lang.';
  errMapiInvalidSession             = 'Ungültige MAPI-Session.';
  errMapiTypeNotSupported           = 'Dieser Typ wird nicht unterstützt.';
  errMapiAmbiguousRecipient         = 'Ein Empfänger wurde mehrfach angegeben.';
  errMapiMessageInUse               = 'Die E-Mail wird gerade bearbeitet.';
  errMapiNetworkFailure             = 'Netzwerk Fehler.';
  errMapiInvalidEditFields          = 'Invalid Edit Fields.';
  errMapiInvalidRecips              = 'Die Empfänger sind ungültig.'; // bei der 1. Sicherheitsabfrage: wenn der Zugriff auf das Adressbuch verweigert wird
  errMapiNotSupported               = 'E-Mail nicht möglich.'; // bei der 2. Sicherheitsabfrage: wenn man den Zugriff auf Outlook verweigert

// *********************************************************************************************************************
// *********************************************************************************************************************
// *********************************************************************************************************************

type
  TJsMapiRecipient = record
    Recipient: AnsiString;
    ClassType: DWORD;
  end;

  TJsMapiAttachment = record
    FileName: PAnsiChar;
    PathName: AnsiString;
  end;

  TJsMapiRecipientArray = array of TJsMapiRecipient;
  TJsMapiAttachmentArray = array of TJsMapiAttachment;

  TJsMapiMessageObject=class(TObject)
  private
    FSubject: AnsiString;
    FBodyText: AnsiString;
    FRecipients: TJsMapiRecipientArray;
    FAttachments: TJsMapiAttachmentArray;
  public
    procedure CreateMapiMessage(aMailMessage:TJsMapiMail);
  end;


procedure TJsMapiMessageObject.CreateMapiMessage(aMailMessage:TJsMapiMail);

  function ExtractFileNameEx(const aFileName: AnsiString): PAnsiChar;
  var liPos: Integer;
  begin
    liPos := LastDelimiter(PathDelim + DriveDelim, String(aFileName));
    if liPos > 0
    then Result := @aFileName[liPos + 1]
    else Result := PAnsiChar(aFileName);
  end;

var i,n:integer;
begin
  FSubject:=AnsiString(aMailMessage.FSubject);
  FBodyText:=AnsiString(aMailMessage.FBody);

  // Dateien
  SetLength(FAttachments, aMailMessage.FAttachments.Count);
  n:=0;
  for i:=0 to aMailMessage.FAttachments.Count - 1 do begin
      if FileExists(aMailMessage.FAttachments[i]) then begin
         FAttachments[n].PathName := AnsiString(aMailMessage.FAttachments[i]);
         FAttachments[n].FileName := ExtractFileNameEx(FAttachments[n].PathName);
         inc(n);
      end;
  end;

  // Empfänger
  SetLength(FRecipients, aMailMessage.FRecipients.Count + aMailMessage.FCCRecipients.Count + aMailMessage.FBCCRecipients.Count);
  n:=0;
  for i:=0 to aMailMessage.FRecipients.Count-1 do begin
      FRecipients[n].Recipient := AnsiString(aMailMessage.FRecipients[i]);
      FRecipients[n].ClassType := MAPI_TO;
      inc(n);
  end;
  for i:=0 to aMailMessage.FCCRecipients.Count-1 do begin
      FRecipients[n].Recipient := AnsiString(aMailMessage.FCCRecipients[i]);
      FRecipients[n].ClassType := MAPI_CC;
      inc(n);
  end;
  for i:=0 to aMailMessage.FBCCRecipients.Count-1 do begin
      FRecipients[n].Recipient := AnsiString(aMailMessage.FBCCRecipients[i]);
      FRecipients[n].ClassType := MAPI_BCC;
      inc(n);
  end;
end;

// *********************************************************************************************************************
// *** JsMapiMail ******************************************************************************************************
// *********************************************************************************************************************

constructor TJsMapiMail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSessionHandle:=0;
  FParentWindowHandle:=0; // 0 heisst Application.Modal
  FReturnCode:=0;

  FResolveNames:=false;
  FRequestReceipt:=false;
  FEditDialog:=true; // true=mit Outlook-Bearbeitungsfenster

  FRecipients := TStringList.Create;
  FCCRecipients := TStringList.Create;
  FBCCRecipients := TStringList.Create;
  FAttachments := TStringList.Create;
end;


destructor TJsMapiMail.Destroy;
begin
  FreeMapiMessage;

  FRecipients.Free;
  FCCRecipients.Free;
  FBCCRecipients.Free;
  FAttachments.Free;

  inherited Destroy;
end;


procedure TJsMapiMail.FreeMapiMessage;
begin
  FMapiAttachments := nil;
  FMapiRecipients := nil;
  FillChar(FMapiMessage, SizeOf(FMapiMessage), #0);
end;


procedure TJsMapiMail.SetRecipientsStr(aRecipients:TStrings; Value: String);
var z,s:string;
    p1,p2:integer;
begin
  aRecipients.Clear;
  z:=trim(value);
  if z<>'' then begin
     if pos(';',z)=0
     then aRecipients.Add(z)
     else begin
            z:=z + ';';
            p1:=1;
            p2:=PosEx(';',z,p1);
            while p2>0 do begin
                  s:=trim(copy(z,p1,p2-p1));
                  if s<>'' then aRecipients.Add(s);
                  p1:=p2+1;
                  p2:=PosEx(';',z,p1);
            end;
     end;
  end;
end;

procedure TJsMapiMail.SetRecipients(Value: TStrings);
begin
  FRecipients.Assign(Value)
end;

procedure TJsMapiMail.SetCCRecipients(Value: TStrings);
begin
  FCCRecipients.Assign(Value)
end;


procedure TJsMapiMail.SetBCCRecipients(Value: TStrings);
begin
  FBCCRecipients.Assign(Value)
end;


procedure TJsMapiMail.SetAttachments(Value: TStrings);
begin
  FAttachments.Assign(Value)
end;


function TJsMapiMail.Connected:Boolean;
begin
  Result := FSessionHandle <> 0;
end;


function TJsMapiMail.Connect:Boolean;
var Flags: Cardinal;
    zDefaultProfileName:AnsiString;

  function GetProfilesRegKey: string;
  var IsWinNT : Boolean;
  begin
    IsWinNT := Win32Platform = VER_PLATFORM_WIN32_NT;
    if IsWinNT
    then Result := 'Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles'
    else Result := 'Software\Microsoft\Windows Messaging Subsystem\Profiles';
  end;

  function GetDefaultLogon(var strDefaultLogon: AnsiString): Boolean;
  begin
    Result := False;
    strDefaultLogon := '';
    with TRegistry.Create do
    try
        Access:=Key_Read;
        RootKey := HKEY_CURRENT_USER;
        if OpenKey(GetProfilesRegKey, False) then begin
           try
              strDefaultLogon := ReadString('DefaultProfile'); // z.B. Outlook
              Result := True;
           except
           end;
           CloseKey;
        end;
    finally
        Free;
    end;
  end;

begin
  zDefaultProfileName := '';
  GetDefaultLogon(zDefaultProfileName);
  Flags:=MAPI_LOGON_UI or MAPI_NEW_SESSION;
  FReturnCode := MapiLogon(Application.Handle, PAnsiChar(zDefaultProfileName), nil, Flags, 0, @FSessionHandle);
  Result := (FReturnCode = SUCCESS_SUCCESS);
end;


function TJsMapiMail.Disconnect: Boolean;
var RetCode: Cardinal;
begin
  Result:=true;
  if Connected then begin
     RetCode:=MapiLogOff(FSessionHandle, Application.Handle, 0, 0);
     FSessionHandle := 0;
     Result := (RetCode = SUCCESS_SUCCESS);
  end;
end;


function TJsMapiMail.SendMail: Boolean;
var aMapiMessageObject:TJsMapiMessageObject;
    SendFlags: Cardinal;

  procedure AssignMapiMessage(aMapiMessage:TJsMapiMessageObject);
  var i,n:integer;
  begin
    // Empfänger
    n:=Length(aMapiMessage.FRecipients);
    SetLength(FMapiRecipients, n);
    for i:=0 to n-1 do begin
        FillChar(FMapiRecipients[i], SizeOf(TMapiRecipDesc), #0);
        FMapiRecipients[i].ulRecipClass := aMapiMessage.FRecipients[i].ClassType;
        FMapiRecipients[i].lpszName     := PAnsiChar(aMapiMessage.FRecipients[i].Recipient);
        FMapiRecipients[i].ulReserved   := 0;
        FMapiRecipients[i].lpEntryID    := nil;
        FMapiRecipients[i].ulEIDSize    := 0;
    end;

    // Dateien
    n:=Length(aMapiMessage.FAttachments);
    if n>0
    then begin
         SetLength(FMapiAttachments, n);
         for i:=0 to n-1 do begin
             FillChar(FMapiAttachments[i], SizeOf(TMapiFileDesc), #0);
             FMapiAttachments[i].nPosition    := $FFFFFFFF;
             FMapiAttachments[i].lpszFileName := aMapiMessage.FAttachments[i].FileName;
             FMapiAttachments[i].lpszPathName := PAnsiChar(aMapiMessage.FAttachments[i].PathName);
         end;
    end
    else FMapiAttachments:=nil;


    FillChar(FMapiMessage, SizeOf(FMapiMessage), #0);

    FMapiMessage.lpszSubject  := PAnsiChar(aMapiMessage.FSubject);  // Betreff
{
    if aMapiMessage.FBodyText=''
    then FMapiMessage.lpszNoteText := nil
    else FMapiMessage.lpszNoteText := PAnsiChar(aMapiMessage.FBodyText); // Text
}
    if aMapiMessage.FBodyText<>'' then FMapiMessage.lpszNoteText := PAnsiChar(aMapiMessage.FBodyText); // Text

    FMapiMessage.lpRecips     := PMapiRecipDesc(FMapiRecipients);   // Empfänger
    FMapiMessage.nRecipCount  := Length(FMapiRecipients);           // Anzahl Empfänger
    FMapiMessage.lpFiles      := PMapiFileDesc(FMapiAttachments);   // Dateinamen für Anhang
    FMapiMessage.nFileCount   := Length(FMapiAttachments);          // Anzahl Dateien
  end;


begin
  Result:=false;

  FParentWindowHandle:=GetMapiParentWnd;

  try
     aMapiMessageObject:=TJsMapiMessageObject.Create;

     aMapiMessageObject.CreateMapiMessage(self);
     AssignMapiMessage(aMapiMessageObject);

     if not Connected then Connect;

//     SendFlags := 0;
     SendFlags := MAPI_LOGON_UI;
     if FEditDialog then SendFlags := SendFlags + MAPI_DIALOG;
     if FRequestReceipt then SendFlags := SendFlags + MAPI_RECEIPT_REQUESTED;

     FReturnCode:=MapiSendMail( FSessionHandle, FParentWindowHandle, FMapiMessage, SendFlags, 0 );
     Result:=(FReturnCode = SUCCESS_SUCCESS);
     Disconnect;
  finally
     FreeMapiMessage;
     aMapiMessageObject.Free;
  end;
end;

function TJsMapiMail.SendMailWithOle: Boolean;
const olMailItem = 0;
      olFolderOutbox = $00000004;

var FOutlook : OleVariant;
    olNamespace: OleVariant;
    FMailItem, aAttachments : OleVariant;
    i:integer;
    z:AnsiString;
begin
  result:=false;

  try
    FOutlook := GetActiveOleObject('Outlook.Application');
  except
    FOutlook := CreateOleObject('Outlook.Application');
  end;

//  olNamespace:=FOutlook.GetNamespace('MAPI');
//  olMailItems:=olNameSpace.GetDefaultFolder(olFolderOutbox);

  FMailItem := Null;
  FMailItem := FOutlook.CreateItem(olMailItem);
  if VarIsNull(FMailItem) then exit;

  FMailItem.Subject := AnsiString(FSubject);
  if FBody<>'' then FMailItem.Body := AnsiString(FBody);

  if FRecipients.Count>0 then begin
     z:=AnsiString(FRecipients[0]);
     for i:=1 to FRecipients.Count - 1 do z:=z+'; '+ AnsiString(FRecipients[i]);
     FMailItem.To:=z;
  end;
  if FCCRecipients.Count>0 then begin
     z:=AnsiString(FCCRecipients[0]);
     for i:=1 to FCCRecipients.Count - 1 do z:=z+'; '+ AnsiString(FCCRecipients[i]);
     FMailItem.CC:=z;
  end;
  if FBCCRecipients.Count>0 then begin
     z:=AnsiString(FBCCRecipients[0]);
     for i:=1 to FBCCRecipients.Count - 1 do z:=z+'; '+ AnsiString(FBCCRecipients[i]);
     FMailItem.BCC:=z;
  end;

  if FAttachments.Count>0
  then begin
         aAttachments:=Null;
         aAttachments:=FMailItem.Attachments;                                              // olByValue, 1, Anzeigename
         for i:=0 to FAttachments.Count-1 do aAttachments.Add(AnsiString(FAttachments[i]), 1, 1, AnsiString(FAttachments[i]));
  end
  else begin
         // Send-Methode funktioniert nicht, wenn keine Dateien im Anhang sind
         // Fehlermeldung: Vorgang abgebrochen
//         aAttachments:=Null;
//         aAttachments:=FMailItem.Attachments;
  end;

  try
     if FEditDialog
     then FMailItem.Display(0) // 0=nicht modales Fenster (ist Default), 1=modales Fenster
                               // Mit Outlook 2007 kommt immer ein EOleSysError "Unzulassige Funktion", FehlercodeNr= 1
                               // Mit Outlook 2003 keine Fehlermeldung

     else FMailItem.Send;      // Es erscheint der Sicherheitshinweis. Exception, wenn dieser verweigert wird.

     result:=true;
  finally
     aAttachments:=Null;
     FMailItem:=Null;
     FOutlook:=Unassigned;
  end;
end;

// *** Hilfsprozeduren *************************************************************************************************

function TJsMapiMail.IsSimpleMapiInstalled:Boolean;
// Simple Mapi wird von Windows installiert, Extended Mapi von Office Outlook.
// Thunderbird und Outlook Express unterstützen kein Extended Mapi
// Thunderbird unterstützt Simple Mapi, ist aber buggy. (siehe http://kb.mozillazine.org/MAPI_Support)
const MessageSubsytemKey = 'Software\Microsoft\Windows Messaging Subsystem';
begin
  result:=false;
  with TRegistry.Create do
  try
      Access:=Key_Read;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey(MessageSubsytemKey, False) then begin
         try result := ReadString('MAPI')='1'; except end;
         CloseKey;
      end;
  finally
      Free;
  end;
end;

function TJsMapiMail.IsExtendedMapiInstalled:Boolean; // wird auch nur Mapi genannt
const MessageSubsytemKey = 'Software\Microsoft\Windows Messaging Subsystem';
begin
  result:=false;
  with TRegistry.Create do
  try
      Access:=Key_Read;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey(MessageSubsytemKey, False) then begin
         try result := ReadString('MAPIX')='1'; except end;
         CloseKey;
      end;
  finally
      Free;
  end;
end;

function TJsMapiMail.GetStandardEMailClient:string;
// Gibt den Programmnamen der E-Mail-Anwendung zurück
// z.B. Mozilla Thunderbird, Microsoft Outlook oder Outlook Express
const MailClientsKey = 'Software\Clients\Mail';
begin
  result:='';
  with TRegistry.Create do
  try
      Access:=Key_Read;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey(MailClientsKey, False) then begin
         try result := ReadString(''); except end; // den Schlüssel (Standard) abfragen
         CloseKey;
      end;
  finally
      Free;
  end;
end;

function TJsMapiMail.GetMapiParentWnd: Cardinal;
var bIsMDIApp : Boolean;
begin
  bIsMDIApp := (Application.MainForm <> nil) and (Application.MainForm.FormStyle = fsMDIForm);
  if not bIsMDIApp and (Screen.ActiveForm <> nil) and not(GetStandardEMailClient = 'Outlook Express')
  then Result := 0 // Microsoft Outlook
  else Result := Application.Handle; // Outlook Express
end;

function TJsMapiMail.GetErrorCode: Cardinal;
begin
  result:=FReturnCode;
end;

function TJsMapiMail.GetErrorMessage(iErrorCode: Cardinal): string;
begin
   case iErrorCode of
     MAPI_E_USER_ABORT: Result := errMapiUserAbort;
     MAPI_E_FAILURE: Result := errMapiFailure;
     MAPI_E_LOGON_FAILURE: Result := errMapiLoginFailure;
     MAPI_E_DISK_FULL: Result := errMapiDiskFull;
     MAPI_E_INSUFFICIENT_MEMORY: Result := errMapiInsufficientMemory;
     MAPI_E_ACCESS_DENIED: Result := errMapiAccessDenied;
     MAPI_E_TOO_MANY_SESSIONS: Result := errMapiTooManySessions;
     MAPI_E_TOO_MANY_FILES: Result := errMapiTooManyFiles;
     MAPI_E_TOO_MANY_RECIPIENTS: Result := errMapiTooManyRecipients;
     MAPI_E_ATTACHMENT_NOT_FOUND: Result := errMapiAttachmentNotFound;
     MAPI_E_ATTACHMENT_OPEN_FAILURE: Result := errMapiAttachmentOpenFailure;
     MAPI_E_ATTACHMENT_WRITE_FAILURE: Result := errMapiAttachmentWriteFailure;
     MAPI_E_UNKNOWN_RECIPIENT: Result := errMapiUnknownRecipient;
     MAPI_E_BAD_RECIPTYPE: Result := errMapiBadRecipType;
     MAPI_E_NO_MESSAGES: Result := errMapiNoMessages;
     MAPI_E_INVALID_MESSAGE: Result := errMapiInvalidMessage;
     MAPI_E_TEXT_TOO_LARGE: Result := errMapiTextTooLarge;
     MAPI_E_INVALID_SESSION: Result := errMapiInvalidSession;
     MAPI_E_TYPE_NOT_SUPPORTED: Result := errMapiTypeNotSupported;
     MAPI_E_AMBIGUOUS_RECIPIENT: Result := errMapiAmbiguousRecipient;
     MAPI_E_MESSAGE_IN_USE: Result := errMapiMessageInUse;
     MAPI_E_NETWORK_FAILURE: Result := errMapiNetworkFailure;
     MAPI_E_INVALID_EDITFIELDS: Result := errMapiInvalidEditFields;
     MAPI_E_INVALID_RECIPS: Result := errMapiInvalidRecips;
     MAPI_E_NOT_SUPPORTED: Result := errMapiNotSupported;
   else
     Result := 'Unbekannter Fehler. Fehlernummer: ' + IntToStr(iErrorCode);
   end;
end;

end.
