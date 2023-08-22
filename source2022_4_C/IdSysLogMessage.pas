{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10359: IdSysLogMessage.pas 
{
{   Rev 1.1    7/23/04 1:32:32 PM  RLebeau
{ Bug fix for TIdSyslogFacility where sfUUCP and sfClockDeamonOne were in the
{ wrong order
}
{
{   Rev 1.0    2002.11.12 10:54:38 PM  czhower
}
unit IdSysLogMessage;
//  Copyright the Indy pit crew
//  Original Author: Stephane Grobety (grobety@fulgan.com)
//  Release history:
//  25/2/02; - Stephane Grobety
//    - Moved Facility and Severity translation functions out of the class
//    - Restored the "SendToHost" method
//    - Changed the ASCII check tzo include only the PRI and HEADER part.
//    - Now allow nul chars in message result (Special handeling should be required, though)
//  09/20/01;  - J. Peter Mugaas
//    Added more properties dealing with Msg parts of the SysLog Message
//  09/19/01; - J. Peter Mugaas
//     restructured syslog classes
//  08/09/01: Dev started
interface

uses IdGlobal, SysUtils, Classes, IdBaseComponent;


type
//  TIdSyslogSeverity = ID_SYSLOG_SEVERITY_EMERGENCY..ID_SYSLOG_SEVERITY_DEBUG;
//  TIdSyslogFacility = ID_SYSLOG_FACILITY_KERNEL..ID_SYSLOG_FACILITY_LOCAL7;
  TIdSyslogPRI = 1..191;
  TIdSyslogFacility = (sfKernel, { ID_SYSLOG_FACILITY_KERNEL}
                      sfUserLevel, { ID_SYSLOG_FACILITY_USER }
                      sfMailSystem, { ID_SYSLOG_FACILITY_MAIL }
                      sfSystemDaemon, { ID_SYSLOG_FACILITY_SYS_DAEMON }
                      sfSecurityOne, { ID_SYSLOG_FACILITY_SECURITY1 }
                      sfSysLogInternal, { ID_SYSLOG_FACILITY_INTERNAL }
                      sfLPR, {ID_SYSLOG_FACILITY_LPR}
                      sfNNTP, { ID_SYSLOG_FACILITY_NNTP }
                      sfUUCP, { ID_SYSLOG_FACILITY_UUCP }
                      sfClockDaemonOne, { CILITY_CLOCK1 }
                      sfSecurityTwo, { ID_SYSLOG_FACILITY_SECURITY2 }
                      sfFTPDaemon, { ID_SYSLOG_FACILITY_FTP }
                      sfNTP, { ID_SYSLOG_FACILITY_NTP }
                      sfLogAudit, { ID_SYSLOG_FACILITY_AUDIT  }
                      sfLogAlert, { ID_SYSLOG_FACILITY_ALERT }
                      sfClockDaemonTwo, { ID_SYSLOG_FACILITY_CLOCK2 }
                      sfLocalUseZero, { ID_SYSLOG_FACILITY_LOCAL0 }
                      sfLocalUseOne, { ID_SYSLOG_FACILITY_LOCAL1 }
                      sfLocalUseTwo, { ID_SYSLOG_FACILITY_LOCAL2 }
                      sfLocalUseThree, { ID_SYSLOG_FACILITY_LOCAL3 }
                      sfLocalUseFour, { ID_SYSLOG_FACILITY_LOCAL4 }
                      sfLocalUseFive, { ID_SYSLOG_FACILITY_LOCAL5 }
                      sfLocalUseSix, { ID_SYSLOG_FACILITY_LOCAL6 }
                      sfLocalUseSeven); { ID_SYSLOG_FACILITY_LOCAL7  }

  TIdSyslogSeverity = (slEmergency, {0 - emergency - system unusable}
              slAlert, {1 - action must be taken immediately }
              slCritical, { 2 - critical conditions }
              slError, {3 - error conditions }
              slWarning, {4 - warning conditions }
              slNotice, {5 - normal but signification condition }
              slInformational, {6 - informational }
              slDebug); {7 - debug-level messages }

  TIdSysLogMsgPart = class(TPersistent)
  protected
    FPIDAvailable: Boolean;
    {we only use the text property as a basis for everything
    else so that SysLog messages are intact for the TIdSysLogServer}
    FText : String;
    FMsgPIDAvailable: Boolean;
    procedure SetPIDAvailable(const AValue: Boolean);
    function GetContent: String;
    function GetProcess: String;
    procedure SetContent(const AValue: String);
    procedure SetProcess(const AValue: String);
    procedure SetText(const AValue: String);
    function GetPID: Integer;
    procedure SetPID(const AValue: Integer);
    function GetMaxTagLength : Integer;
    //extract the PID part into a SysLog PID including []
    function PIDToStr(APID : Integer) : String; virtual;

  public
    procedure Assign(Source: Tpersistent); override;
  published
    property Text: String read FText write SetText;
    {These are part of the message property string so no need to store them}
    property PIDAvailable : Boolean read FPIDAvailable write SetPIDAvailable stored false;
    property Process : String read GetProcess write SetProcess stored false;
    property PID : Integer read GetPID write SetPID stored false;
    property Content : String read GetContent write SetContent stored false;
  end;

  TIdSysLogMessage = class(TIdBaseComponent)
  protected
    FMsg : TIdSysLogMsgPart;
    FFacility: TidSyslogFacility;
    FSeverity: TIdSyslogSeverity;
    FHostname: string;
    FMessage: String;
    FTimeStamp: TDateTime;
    FRawMessage: String;
    FPeer: String;
    FPri: TIdSyslogPRI;
    FUDPCliComp: TIdBaseComponent;
    procedure SetFacility(const AValue: TidSyslogFacility);
    procedure SetSeverity(const AValue: TIdSyslogSeverity);
    procedure SetHostname(const AValue: string);
    procedure SetRawMessage(const Value: string);
    procedure SetTimeStamp(const AValue: TDateTime);
    procedure SetMsg(const AValue : TIdSysLogMsgPart);
    procedure SetPri(const Value: TIdSyslogPRI);
    function GetHeader: String;
    procedure CheckASCIIRange(var Data: String); virtual;
    procedure ReadPRI(var StartPos: Integer); virtual;
    procedure ReadHeader(var StartPos: Integer); virtual;
    procedure ReadMSG(var StartPos: Integer); virtual;
    procedure parse; virtual;
    procedure UpdatePRI; virtual;
    function DecodeTimeStamp(TimeStampString: String): TDateTime; virtual;
//    function logFacilityToNo(AFac : TIdSyslogFacility) : Word; virtual;
//    function NoToFacility(AFac : Word) : TIdSyslogFacility;  virtual;
//    function logSeverityToNo(ASev :  TIdSyslogSeverity) : Word; virtual;
//    function SeverityToString(ASec: TIdsyslogSeverity): string; virtual;
//    function FacilityToString(AFac: TIdSyslogFacility): string; virtual;
//    function NoToSeverity(ASev :  Word) : TIdSyslogSeverity; virtual;
     //extract the PID part into a SysLog PID including []
  public
    property RawMessage: string read FRawMessage write SetRawMessage;
    function EncodeMessage: String; virtual;
    procedure ReadFromStream(Src: TStream; Size: integer; APeer: String); virtual;
    procedure assign(Source: TPersistent); override;
    property TimeStamp: TDateTime read FTimeStamp write SetTimeStamp;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SendToHost(const Dest: String);
    property Peer : String read FPeer write FPeer;
  published
    property Pri: TIdSyslogPRI read FPri write SetPri default 13;
    property Facility: TidSyslogFacility read FFacility write SetFacility stored false;
    property Severity: TIdSyslogSeverity read FSeverity write SetSeverity stored false;
    property Hostname: string read FHostname write SetHostname stored false;
    property Msg : TIdSysLogMsgPart read FMsg write SetMsg;
  end; // class

function FacilityToString(AFac: TIdSyslogFacility): string;
function SeverityToString(ASec: TIdsyslogSeverity): string;
function NoToSeverity(ASev :  Word) : TIdSyslogSeverity;
function logSeverityToNo(ASev :  TIdSyslogSeverity) : Word;
function NoToFacility(AFac : Word) : TIdSyslogFacility;
function logFacilityToNo(AFac : TIdSyslogFacility) : Word;

implementation

uses IdAssignedNumbers, IdException, IdResourceStrings, IdStack, IdStackConsts, IdUDPClient;

const
  // facility
  ID_SYSLOG_FACILITY_KERNEL     = 0;  // kernel messages
  ID_SYSLOG_FACILITY_USER       = 1;  // user-level messages
  ID_SYSLOG_FACILITY_MAIL       = 2;  // mail system
  ID_SYSLOG_FACILITY_SYS_DAEMON = 3;  // system daemons
  ID_SYSLOG_FACILITY_SECURITY1  = 4;  // security/authorization messages (1)
  ID_SYSLOG_FACILITY_INTERNAL   = 5;  // messages generated internally by syslogd
  ID_SYSLOG_FACILITY_LPR        = 6;  // line printer subsystem
  ID_SYSLOG_FACILITY_NNTP       = 7;  // network news subsystem
  ID_SYSLOG_FACILITY_UUCP       = 8;  // UUCP subsystem
  ID_SYSLOG_FACILITY_CLOCK1     = 9;  // clock daemon (1)
  ID_SYSLOG_FACILITY_SECURITY2  = 10; // security/authorization messages (2)
  ID_SYSLOG_FACILITY_FTP        = 11; // FTP daemon
  ID_SYSLOG_FACILITY_NTP        = 12; // NTP subsystem
  ID_SYSLOG_FACILITY_AUDIT      = 13; // log audit
  ID_SYSLOG_FACILITY_ALERT      = 14; // log alert
  ID_SYSLOG_FACILITY_CLOCK2     = 15; // clock daemon (2)
  ID_SYSLOG_FACILITY_LOCAL0     = 16; // local use 0  (local0)
  ID_SYSLOG_FACILITY_LOCAL1     = 17; // local use 1  (local1)
  ID_SYSLOG_FACILITY_LOCAL2     = 18; // local use 2  (local2)
  ID_SYSLOG_FACILITY_LOCAL3     = 19; // local use 3  (local3)
  ID_SYSLOG_FACILITY_LOCAL4     = 20; // local use 4  (local4)
  ID_SYSLOG_FACILITY_LOCAL5     = 21; // local use 5  (local5)
  ID_SYSLOG_FACILITY_LOCAL6     = 22; // local use 6  (local6)
  ID_SYSLOG_FACILITY_LOCAL7     = 23; // local use 7  (local7)

  // Severity
  ID_SYSLOG_SEVERITY_EMERGENCY     = 0; // Emergency: system is unusable
  ID_SYSLOG_SEVERITY_ALERT         = 1; // Alert: action must be taken immediately
  ID_SYSLOG_SEVERITY_CRITICAL      = 2; // Critical: critical conditions
  ID_SYSLOG_SEVERITY_ERROR         = 3; // Error: error conditions
  ID_SYSLOG_SEVERITY_WARNING       = 4; // Warning: warning conditions
  ID_SYSLOG_SEVERITY_NOTICE        = 5; // Notice: normal but significant condition
  ID_SYSLOG_SEVERITY_INFORMATIONAL = 6; // Informational: informational messages
  ID_SYSLOG_SEVERITY_DEBUG         = 7; // Debug: debug-level messages

function logFacilityToNo(AFac : TIdSyslogFacility) : Word;
begin
  case AFac of
   sfKernel : Result := ID_SYSLOG_FACILITY_KERNEL;
   sfUserLevel : Result := ID_SYSLOG_FACILITY_USER;
   sfMailSystem : Result := ID_SYSLOG_FACILITY_MAIL;
   sfSystemDaemon : Result := ID_SYSLOG_FACILITY_SYS_DAEMON;
   sfSecurityOne : Result := ID_SYSLOG_FACILITY_SECURITY1;
   sfSysLogInternal : Result := ID_SYSLOG_FACILITY_INTERNAL;
   sfLPR : Result := ID_SYSLOG_FACILITY_LPR;
   sfNNTP : Result := ID_SYSLOG_FACILITY_NNTP;
   sfClockDaemonOne : Result := ID_SYSLOG_FACILITY_CLOCK1;
   sfUUCP : Result := ID_SYSLOG_FACILITY_UUCP;
   sfSecurityTwo : Result := ID_SYSLOG_FACILITY_SECURITY2;
   sfFTPDaemon : Result := ID_SYSLOG_FACILITY_FTP;
   sfNTP : Result := ID_SYSLOG_FACILITY_NTP;
   sfLogAudit : Result := ID_SYSLOG_FACILITY_AUDIT;
   sfLogAlert : Result := ID_SYSLOG_FACILITY_ALERT;
   sfClockDaemonTwo : Result := ID_SYSLOG_FACILITY_CLOCK2;
   sfLocalUseZero : Result := ID_SYSLOG_FACILITY_LOCAL0;
   sfLocalUseOne : Result := ID_SYSLOG_FACILITY_LOCAL1;
   sfLocalUseTwo : Result := ID_SYSLOG_FACILITY_LOCAL2;
   sfLocalUseThree : Result := ID_SYSLOG_FACILITY_LOCAL3;
   sfLocalUseFour : Result := ID_SYSLOG_FACILITY_LOCAL4;
   sfLocalUseFive : Result := ID_SYSLOG_FACILITY_LOCAL5;
   sfLocalUseSix : Result := ID_SYSLOG_FACILITY_LOCAL6;
   sfLocalUseSeven : Result := ID_SYSLOG_FACILITY_LOCAL7;
  else
    Result := ID_SYSLOG_FACILITY_LOCAL7;
  end;
end;

function NoToFacility(AFac : Word) : TIdSyslogFacility;
begin
  case AFac of
    ID_SYSLOG_FACILITY_KERNEL : Result := sfKernel;
    ID_SYSLOG_FACILITY_USER : Result := sfUserLevel;
    ID_SYSLOG_FACILITY_MAIL : Result := sfMailSystem;
    ID_SYSLOG_FACILITY_SYS_DAEMON : Result := sfSystemDaemon;
    ID_SYSLOG_FACILITY_SECURITY1 : Result := sfSecurityOne;
    ID_SYSLOG_FACILITY_INTERNAL : Result := sfSysLogInternal;
    ID_SYSLOG_FACILITY_LPR : Result := sfLPR;
    ID_SYSLOG_FACILITY_NNTP : Result := sfNNTP;
    ID_SYSLOG_FACILITY_CLOCK1 : Result := sfClockDaemonOne;
    ID_SYSLOG_FACILITY_UUCP : Result := sfUUCP;
    ID_SYSLOG_FACILITY_SECURITY2 : Result := sfSecurityTwo;
    ID_SYSLOG_FACILITY_FTP : Result := sfFTPDaemon;
    ID_SYSLOG_FACILITY_NTP : Result := sfNTP;
    ID_SYSLOG_FACILITY_AUDIT : Result := sfLogAudit;
    ID_SYSLOG_FACILITY_ALERT : Result := sfLogAlert;
    ID_SYSLOG_FACILITY_CLOCK2 : Result := sfClockDaemonTwo;
    ID_SYSLOG_FACILITY_LOCAL0 : Result := sfLocalUseZero;
    ID_SYSLOG_FACILITY_LOCAL1 : Result := sfLocalUseOne;
    ID_SYSLOG_FACILITY_LOCAL2 : Result := sfLocalUseTwo;
    ID_SYSLOG_FACILITY_LOCAL3 : Result := sfLocalUseThree;
    ID_SYSLOG_FACILITY_LOCAL4 : Result := sfLocalUseFour;
    ID_SYSLOG_FACILITY_LOCAL5 : Result := sfLocalUseFive;
    ID_SYSLOG_FACILITY_LOCAL6 : Result := sfLocalUseSix;
    ID_SYSLOG_FACILITY_LOCAL7 : Result := sfLocalUseSeven;
    else
      Result := sfLocalUseSeven;
  end;
end;

function logSeverityToNo(ASev :  TIdSyslogSeverity) : Word;
begin
  case ASev of
    slEmergency : Result := ID_SYSLOG_SEVERITY_EMERGENCY;
    slAlert :  Result := ID_SYSLOG_SEVERITY_ALERT;
    slCritical : Result := ID_SYSLOG_SEVERITY_CRITICAL;
    slError : Result := ID_SYSLOG_SEVERITY_ERROR;
    slWarning : Result := ID_SYSLOG_SEVERITY_WARNING;
    slNotice : Result := ID_SYSLOG_SEVERITY_NOTICE;
    slInformational : Result := ID_SYSLOG_SEVERITY_INFORMATIONAL;
    slDebug : Result := ID_SYSLOG_SEVERITY_DEBUG;
  else
    Result := ID_SYSLOG_SEVERITY_DEBUG;
  end;
end;

function NoToSeverity(ASev :  Word) : TIdSyslogSeverity;
begin
  case ASev of
    ID_SYSLOG_SEVERITY_EMERGENCY : Result := slEmergency;
    ID_SYSLOG_SEVERITY_ALERT : Result := slAlert;
    ID_SYSLOG_SEVERITY_CRITICAL : Result := slCritical;
    ID_SYSLOG_SEVERITY_ERROR : Result := slError;
    ID_SYSLOG_SEVERITY_WARNING : Result := slWarning;
    ID_SYSLOG_SEVERITY_NOTICE : Result := slNotice;
    ID_SYSLOG_SEVERITY_INFORMATIONAL : Result := slInformational;
    ID_SYSLOG_SEVERITY_DEBUG : Result := slDebug;
  else
    Result := slDebug;
  end;
end;

function SeverityToString(ASec: TIdsyslogSeverity): string;
begin
  case ASec of    //
    slEmergency:
      result := STR_SYSLOG_SEVERITY_EMERGENCY;
    slAlert:
      result := STR_SYSLOG_SEVERITY_ALERT;
    slCritical:
      result := STR_SYSLOG_SEVERITY_CRITICAL;
    slError:
      result := STR_SYSLOG_SEVERITY_ERROR;
    slWarning:
      result := STR_SYSLOG_SEVERITY_WARNING;
    slNotice:
      result := STR_SYSLOG_SEVERITY_NOTICE;
    slInformational:
      result := STR_SYSLOG_SEVERITY_INFORMATIONAL;
    slDebug:
      result := STR_SYSLOG_SEVERITY_DEBUG;
    else
      result := STR_SYSLOG_SEVERITY_UNKNOWN;
  end;    // case
end;

function FacilityToString(AFac: TIdSyslogFacility): string;
begin
  case AFac of    //
    sfKernel:
      result := STR_SYSLOG_FACILITY_KERNEL;
    sfUserLevel:
      result := STR_SYSLOG_FACILITY_USER;
    sfMailSystem:
      result := STR_SYSLOG_FACILITY_MAIL;
    sfSystemDaemon:
      result := STR_SYSLOG_FACILITY_SYS_DAEMON;
    sfSecurityOne:
      result := STR_SYSLOG_FACILITY_SECURITY1;
    sfSysLogInternal:
      result := STR_SYSLOG_FACILITY_INTERNAL;
    sfLPR:
      result := STR_SYSLOG_FACILITY_LPR;
    sfNNTP:
      result := STR_SYSLOG_FACILITY_NNTP;
    sfClockDaemonOne:
      result := STR_SYSLOG_FACILITY_CLOCK1;
    sfUUCP:
      result := STR_SYSLOG_FACILITY_UUCP;
    sfSecurityTwo:
      result := STR_SYSLOG_FACILITY_SECURITY2;
    sfFTPDaemon:
      result := STR_SYSLOG_FACILITY_FTP;
    sfNTP:
      result := STR_SYSLOG_FACILITY_NTP;
    sfLogAudit:
      result := STR_SYSLOG_FACILITY_AUDIT;
    sfLogAlert:
      result := STR_SYSLOG_FACILITY_ALERT;
    sfClockDaemonTwo:
      result := STR_SYSLOG_FACILITY_CLOCK2;
    sfLocalUseZero:
      result := STR_SYSLOG_FACILITY_LOCAL0;
    sfLocalUseOne:
      result := STR_SYSLOG_FACILITY_LOCAL1;
    sfLocalUseTwo:
      result := STR_SYSLOG_FACILITY_LOCAL2;
    sfLocalUseThree:
      result := STR_SYSLOG_FACILITY_LOCAL3;
    sfLocalUseFour:
      result := STR_SYSLOG_FACILITY_LOCAL4;
    sfLocalUseFive:
      result := STR_SYSLOG_FACILITY_LOCAL5;
    sfLocalUseSix:
      result := STR_SYSLOG_FACILITY_LOCAL6;
    sfLocalUseSeven:
      result := STR_SYSLOG_FACILITY_LOCAL7;
    else
      result := STR_SYSLOG_FACILITY_UNKNOWN;
  end;    // case
end;
{ TIdSysLogMessage }

procedure TIdSysLogMessage.assign(Source: Tpersistent);
var ms : TIdSysLogMessage;
begin
  if Source is TIdSysLogMessage then
  begin
    ms := Source as TIdSysLogMessage;
    {Priority and facility properties are set with this so those assignments
    are not needed}
    Pri := Ms.Pri;
    HostName := ms.Hostname;
    FMsg.Assign(ms.Msg);
    TimeStamp := ms.TimeStamp;
  end
  else
    inherited Assign(Source);
end;

function TIdSysLogMessage.DecodeTimeStamp(
  TimeStampString: String): TDateTime;
var
  AYear, AMonth, ADay, AHour, AMin, ASec: Word;
begin
  // SG 25/2/02: Check the ASCII range
  CheckASCIIRange(TimeStampString);
  // Get the current date to get the current year
  DecodeDate(Date, AYear, AMonth, ADay);
  if length(TimeStampString) <> 16 then
    Raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogTimeStamp, [TimeStampString]);

  // Month
  AMonth := StrToMonth(Copy(TimeStampString, 1, 3));
  if not AMonth in [1..12] then
    Raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogTimeStamp, [TimeStampString]);
  // day
  ADay := StrToIntDef(trim(Copy(TimeStampString, 5, 2)), 0);
  if not (ADay in [1..31]) then
    Raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogTimeStamp, [TimeStampString]);
  // Time
  AHour := StrToIntDef(trim(Copy(TimeStampString, 8, 2)), 0);
  if not AHour in [0..23] then
    Raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogTimeStamp, [TimeStampString]);
  AMin := StrToIntDef(trim(Copy(TimeStampString, 11, 2)), 0);
  if not AMin in [0..59] then
    Raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogTimeStamp, [TimeStampString]);
  ASec := StrToIntDef(trim(Copy(TimeStampString, 14, 2)), 0);
  if not ASec in [0..59] then
    Raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogTimeStamp, [TimeStampString]);
  if TimeStampString[16] <> ' ' then    {Do not Localize}
    Raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogTimeStamp, [TimeStampString]);
  Result := EncodeDate(AYear, AMonth, ADay) + EncodeTime(AHour, AMin, ASec, 0);
end;

procedure TIdSysLogMessage.ReadFromStream(Src: TStream; Size: integer; APeer: String);
var
  Buffer: string;
begin
  if Size > 1024 then
  begin
    // Truncate the size to RFC's max    {Do not Localize}
    Size := 1024;
  end
  else
    SetLength(Buffer, Size);
  FPeer := APeer;
  Src.ReadBuffer(PChar(Buffer)^, Size);

  RawMessage := Buffer;
end;

procedure TIdSysLogMessage.parse;
var
  APos: Integer;
begin
  APos := 1;
  ReadPRI(APos);
  ReadHeader(APos);
  ReadMSG(APos);
end;

procedure TIdSysLogMessage.ReadHeader(var StartPos: Integer);
var
  AHostNameEnd: Integer;
begin
  // DateTimeToInternetStr and StrInternetToDateTime
  // Time stamp string is 15 char long
  try
    FTimeStamp := DecodeTimeStamp(Copy(FRawMessage, StartPos, 16));
    Inc(StartPos, 16);
    // HostName
    AHostNameEnd := StartPos;
    while (AHostNameEnd < Length(FRawMessage)) and (FRawMessage[AHostNameEnd] <> ' ') do    {Do not Localize}
    begin
      Inc(AHostNameEnd);
    end;    // while

    FHostname := Copy(FRawMessage, StartPos, AHostNameEnd - StartPos);
    // SG 25/2/02: Check the ASCII range of host name
    CheckASCIIRange(FHostname);
    StartPos := AHostNameEnd + 1;
  except
    on e: Exception do
    begin
      FTimeStamp := Now;
      FHostname := FPeer;
    end;
  end;
end;

procedure TIdSysLogMessage.ReadMSG(var StartPos: Integer);
begin
  FMessage := Copy(FRawMessage, StartPos, Length(FRawMessage));
  Msg.text := FMessage;
end;

procedure TIdSysLogMessage.ReadPRI(var StartPos: Integer);
var
  StartPosSave: Integer;
  Buffer: string;
begin
  StartPosSave := StartPos;
  try
    // Read the PRI string
    // PRI must start with "less than" sign
    Buffer := '';    {Do not Localize}
    if FRawMessage[StartPos] <> '<' then    {Do not Localize}
      raise EInvalidSyslogMessage.Create(RSInvalidSyslogPRI);
    repeat
      Inc(StartPos);
      if FRawMessage[StartPos] = '>' then    {Do not Localize}
      begin
        Break;
      end
      else
        if not (FRawMessage[StartPos] in ['0'..'9']) then    {Do not Localize}
          raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogPRINumber, [Buffer])
        else
          Buffer  := Buffer + FRawMessage[StartPos];
    until StartPos = StartPosSave + 5;

    // PRI must end with "greater than" sign
    if (FRawMessage[StartPos] <> '>') then    {Do not Localize}
      raise EInvalidSyslogMessage.Create(RSInvalidSyslogPRI);
    // Convert PRI to numerical value
    Inc(StartPos);
    CheckASCIIRange(Buffer);
    PRI := StrToIntDef(Buffer, -1);
  except
    // as per RFC, on invalid/missing PRI, use value 13
    on e: Exception do
    begin
      Pri := 13;
      // Reset the position to saved value
      StartPos := StartPosSave;
    end;
  end;
end;

procedure TIdSysLogMessage.UpdatePRI;
begin
  PRI := logFacilityToNo(Facility) * 8 + logSeverityToNo(Severity);
end;

procedure TIdSysLogMessage.SetFacility(const AValue: TidSyslogFacility);
begin
  if FFacility <> AValue then
  begin
    FFacility := AValue;
    UpdatePRI;
  end;
end;

procedure TIdSysLogMessage.SetHostname(const AValue: string);
begin
  if Pos(' ', AValue) <> 0 then    {Do not Localize}
  begin
    Raise EInvalidSyslogMessage.CreateFmt(RSInvalidHostName, [AValue]);
  end
  else
    FHostname := AValue;
end;

procedure TIdSysLogMessage.SetSeverity(const AValue: TIdSyslogSeverity);
begin
  if FSeverity <> AValue then
  begin
    FSeverity := AValue;
    UpdatePRI;
  end;
end;

procedure TIdSysLogMessage.SetTimeStamp(const AValue: TDateTime);
begin
  FTimeStamp := AValue;
end;

function TIdSysLogMessage.GetHeader: String;
var
  AYear, AMonth, ADay, AHour, AMin, ASec, AMSec: Word;

  function YearOf(ADate : TDateTime) : Word;
  var mm, dd : Word;
  begin
    DecodeDate(ADate,Result,mm,dd);
  end;

  Function DayToStr(day: Word): String;
  begin
    if Day < 10 then
       result :=  ' ' + IntToStr(day)    {Do not Localize}
    else
      result := IntToStr(day);
  end;
begin
  // if the year of the message is not the current year, the timestamp is
  // invalid -> Create a new timestamp with the current date/time
  if YearOf(date) <> YearOf(TimeStamp) then
    TimeStamp := Now;
  DecodeDate(TimeStamp, AYear, AMonth, ADay);
  DecodeTime(TimeStamp, AHour, AMin, ASec, AMSec);

  result := Format('%s %s %.2d:%.2d:%.2d %s',[monthnames[AMonth], DayToStr(ADay), AHour, AMin, ASec, Hostname]);    {Do not Localize}

end;

function TIdSysLogMessage.EncodeMessage: String;
begin
  // Create a syslog message string
  // PRI
  result := Format('<%d>%s %s', [PRI, GetHeader, FMsg.Text]);    {Do not Localize}
  // If the message is too long, tuncate it
  if Length(result) > 1024  then
  begin
    result := Copy(result, 1, 1024);
  end;
end;

procedure TIdSysLogMessage.SetPri(const Value: TIdSyslogPRI);
begin
  if FPri <> value then
  begin
    if not (value in [0..191]) then
      raise EInvalidSyslogMessage.CreateFmt(RSInvalidSyslogPRINumber, [IntToStr(value)]);
    FPri := Value;
    FFacility := NoToFacility(Value div 8);
    FSeverity := NoToSeverity(Value mod 8);
  end;
end;

constructor TIdSysLogMessage.Create(AOwner: TComponent);
var bCreatedStack : Boolean;
begin
  inherited Create(AOwner);
  PRI := 13; //default
  {This stuff is necessary to prevent an AV in the IDE if GStack does not exist}
  bCreatedStack := False;
  if not Assigned(GStack) then
  begin
    GStack := TIdStack.CreateStack;
    bCreatedStack := True;
  end;
  try
    Hostname := GStack.LocalAddress;
  finally
    {Free the stack ONLY if we created it to prevent a memory leak}
    if bCreatedStack then
    begin
      FreeAndNil(GStack);
    end;
  end;
  FMsg := TIdSysLogMsgPart.Create;
end;

procedure TIdSysLogMessage.CheckASCIIRange(var Data: String);
const
  ValidChars = [#0..#127];
var
  i: Integer;
begin
  for i := 1 to Length(Data) do    // Iterate
  begin
    if not (Data[i] in ValidChars) then
      data[i] := '?';    {Do not Localize}
  end;    // for
end;

destructor TIdSysLogMessage.Destroy;
begin
  FreeAndNil(FMsg);
  inherited Destroy;
end;

procedure TIdSysLogMessage.SetMsg(const AValue: TIdSysLogMsgPart);
begin
  FMsg.Assign(AValue);
end;

procedure TIdSysLogMessage.SetRawMessage(const Value: string);
begin
  FRawMessage := Value;
  // check that message contains only valid ASCII chars.
  // Replace Invalid entries by "?"
  // SG 25/2/02: Moved to header decoding
  Parse;
end;

procedure TIdSysLogMessage.SendToHost(const Dest: String);
begin
  if not assigned(FUDPCliComp) then
    FUDPCliComp := TIdUDPClient.Create(self);
  (FUDPCliComp as TIdUDPClient).Send(Dest, IdPORT_syslog, EncodeMessage);
end;

{ TIdSysLogMsgPart }

procedure TIdSysLogMsgPart.Assign(Source: Tpersistent);
var m : TIdSysLogMsgPart;
begin
  if Source is TIdSysLogMsgPart then
  begin
    m := Source as TIdSysLogMsgPart;
    {This sets about everything here}
    FText := m.Text;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

function TIdSysLogMsgPart.GetContent: String;
begin
  Result := FText;
  if Pos(':',Result)>1 then    {Do not Localize}
  begin
    Fetch(Result,':');    {Do not Localize}
  end;
end;


function TIdSysLogMsgPart.GetMaxTagLength: Integer;
begin
  Result := 32 - Length(PIDToStr(PID));
end;

function TIdSysLogMsgPart.GetPID: Integer;
var SBuf : String;
begin
  Result := -1;
  SBuf := FText;
  if Pos(':',FText)> 1 then    {Do not Localize}
  begin
    SBuf := Fetch(SBuf,':');    {Do not Localize}
    Fetch(SBuf,'[');    {Do not Localize}
    //there may not be a PID number in the Text property
    SBuf := Fetch(SBuf,']');    {Do not Localize}
    if (Length(SBuf)>0) then
    begin
      Result := StrToInt(SBuf);
    end;
  end;
end;

function TIdSysLogMsgPart.GetProcess: String;
begin
  if Pos(':',FText)>1 then    {Do not Localize}
  begin
    Result := Fetch(FText,':',False);    {Do not Localize}

    //strip of the PID if it's there    {Do not Localize}

    Result := Fetch(Result,'[');    {Do not Localize}
  end
  else
  begin
    Result := '';    {Do not Localize}
  end;
end;

function TIdSysLogMsgPart.PIDToStr(APID: Integer): String;
begin
  if FPIDAvailable then
  begin
    Result := Format('[%d]:',[APID]);    {Do not Localize}
  end
  else
  begin
    Result := ':';    {Do not Localize}
  end;
end;

procedure TIdSysLogMsgPart.SetContent(const AValue: String);
begin
  FText := Process + PIDToStr(PID) + AValue;
end;

procedure TIdSysLogMsgPart.SetPID(const AValue: Integer);
begin
  FText := Process + PIDToStr(AValue) + Content;
end;

procedure TIdSysLogMsgPart.SetPIDAvailable(const AValue: Boolean);
var SSaveProcess : String;
begin
  SSaveProcess := Process;
  FPIDAvailable := AValue;
  FText := SSaveProcess + PidToStr(PID)+Content;
  if not AValue and (FText = ':') then    {Do not Localize}
  begin
    FText := '';    {Do not Localize}
  end;
end;

procedure TIdSysLogMsgPart.SetProcess(const AValue: String);

   function AlphaNumericStr(AString : String) : String;
   var i : Integer;
   begin
     for i := 1 to Length(AString) do
     begin
         //numbers
       if ((Ord(AString[i])>=$30) and (Ord(AString[i])<$3A)) or
         //alphabet
          ((Ord(AString[i])>=$61) and (Ord(AString[i])<$5B)) or
          ((Ord(AString[i])>=$41) and (Ord(AString[i])<$7B)) then
       begin
         Result := Result + AString[i];
       end
       else
       begin
         Break;
       end;
     end;
   end;

begin
  //we have to ensure that the TAG feild will never be greater than 32 charactors
  //and the program name must contain alphanumeric charactors
  FText := AlphaNumericStr(Copy(AValue,1,GetMaxTagLength))
    + PIDToStr(PID) + Content;
end;

procedure TIdSysLogMsgPart.SetText(const AValue: String);
begin
  FText := AValue;
end;

end.
