{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Serial communication basic component                               |
|==============================================================================|
| The contents of this file are subject to the Mozilla Public License Ver. 1.0 |
| (the "License"); you may not use this file except in compliance with the     |
| License. You may obtain a copy of the License at http://www.mozilla.org/MPL/ |
|                                                                              |
| Software distributed under the License is distributed on an "AS IS" basis,   |
| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for |
| the specific language governing rights and limitations under the License.    |
|==============================================================================|
| The Original Code is AsyncFree Library.                                      |
|==============================================================================|
| The Initial Developer of the Original Code is Petr Vones (Czech Republic).   |
| Portions created by Petr Vones are Copyright (C) 1998, 1999.                 |
| All Rights Reserved.                                                         |
|==============================================================================|
| Contributor(s):                                                              |
|==============================================================================|
| History:                                                                     |
|   see AfRegister.pas                                                         |
|==============================================================================}

unit AfComPort;

{$I PVDEFINE.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AfComPortCore, AfSafeSync, AfDataDispatcher;

type
  TAfBaudrate = (br110, br300, br600, br1200, br2400, br4800, br9600, br14400,
    br19200, br38400, br56000, br57600, br115200, br128000, br256000, brUser);
  TAfParity = (paNone, paOdd, paEven, paMark, paSpace);
  TAfDatabits = (db4, db5, db6, db7, db8);
  TAfStopbits = (sbOne, sbOneAndHalf, sbTwo);
  TAfFlowControl = (fwNone, fwXOnXOff, fwRtsCts, fwDtrDsr);

  TAfComOption = (coParityCheck, coDsrSensitivity, coIgnoreXOff, coErrorChar, coStripNull);
  TAfComOptions = set of TAfComOption;

  EAfComPortError = class(Exception);

  TAfComPortEventKind = TAfCoreEvent;

  TAfComPortEventData = DWORD;

  TAfCPTCoreEvent = procedure(Sender: TObject; EventKind: TAfComPortEventKind; Data: TAfComPortEventData) of object;
  TAfCPTErrorEvent = procedure(Sender: TObject; Errors: DWORD) of object;
  TAfCPTDataReceivedEvent = procedure(Sender: TObject; Count: Integer) of object;

  TAfCustomSerialPort = class(TAfDataDispConnComponent)
  private
    FAutoOpen: Boolean;
    FBaudRate: TAfBaudrate;
    FClosing: Boolean;
    FCoreComPort: TAfComPortCore;
    FDatabits: TAfDatabits;
    FDCB: TDCB;
    FDTR: Boolean;
    FEventThreadPriority: TThreadPriority;
    FFlowControl: TAfFlowControl;
    FInBufSize: Integer;
    FOptions: TAfComOptions;
    FOutBufSize: Integer;
    FParity: TAfParity;
    FRTS: Boolean;
    FStopbits: TAfStopbits;
    FSyncID: TAfSyncSlotID;
    FUserBaudRate: Integer;
    FXOnChar, FXOffChar: Char;
    FXOnLim, FXOffLim: Word;
    FOnCTSChanged: TNotifyEvent;
    FOnDataRecived: TAfCPTDataReceivedEvent;
    FOnDSRChanged: TNotifyEvent;
    FOnRLSDChanged: TNotifyEvent;
    FOnRINGDetected: TNotifyEvent;
    FOnLineError: TAfCPTErrorEvent;
    FOnOutBufFree: TNotifyEvent;
    FOnNonSyncEvent: TAfCPTCoreEvent;
    FOnPortClose: TNotifyEvent;
    FOnPortOpen: TNotifyEvent;
    FOnSyncEvent: TAfCPTCoreEvent;
    Sync_Event: TAfComPortEventKind;
    Sync_Data: TAfComPortEventData;
    FWriteThreadPriority: TThreadPriority;
    procedure CheckClose;
    procedure CoreComPortEvent(Sender: TAfComPortCore; EventKind: TAfCoreEvent; Data: DWORD);
    function GetActive: Boolean;
    function GetComStat(Index: Integer): Boolean;
    function GetHandle: THandle;
    function GetModemStatus(Index: Integer): Boolean;
    function IsUserBaudRateStored: Boolean;
    procedure SafeSyncEvent(ID: TAfSyncSlotID);
    procedure Set_DTR(const Value: Boolean);
    procedure Set_RTS(const Value: Boolean);
    procedure SetActive(const Value: Boolean);
    procedure SetBaudRate(const Value: TAfBaudrate);
    procedure SetDCB(const Value: TDCB);
    procedure SetDatabits(const Value: TAfDatabits);
    procedure SetEventThreadPriority(const Value: TThreadPriority);
    procedure SetFlowControl(const Value: TAfFlowControl);
    procedure SetInBufSize(const Value: Integer);
    procedure SetStopbits(const Value: TAfStopbits);
    procedure SetOptions(const Value: TAfComOptions);
    procedure SetOutBufSize(const Value: Integer);
    procedure SetParity(const Value: TAfParity);
    procedure SetUserBaudRate(const Value: Integer);
    procedure SetWriteThreadPriority(const Value: TThreadPriority);
    procedure SetXOnChar(const Value: Char);
    procedure SetXOnLim(const Value: Word);
    procedure SetXOffChar(const Value: Char);
    procedure SetXOffLim(const Value: Word);
    procedure UpdateDCB;
    procedure UpdateOnOffLimit;
  protected
    procedure DispatchComEvent(EventKind: TAfComPortEventKind; Data: TAfComPortEventData);
    procedure DoOutBufFree;
    procedure DoPortData(Count: Integer);
    procedure DoPortEvent(Event: DWORD);
    procedure DoPortClose;
    procedure DoPortOpen;
    function GetNumericBaudrate: Integer;
    procedure InternalOpen; dynamic; abstract;
    procedure Loaded; override;
    procedure RaiseError(const ErrorMsg: String); dynamic;
    property AutoOpen: Boolean read FAutoOpen write FAutoOpen default False;
    property BaudRate: TAfBaudrate read FBaudRate write SetBaudRate default br115200;
    property Core: TAfComPortCore read FCoreComPort;
    property Databits: TAfDatabits read FDatabits write SetDatabits default db8;
    property DTR: Boolean read FDTR write Set_DTR default True;
    property EventThreadPriority: TThreadPriority read FEventThreadPriority write SetEventThreadPriority default tpNormal;
    property FlowControl: TAfFlowControl read FFlowControl write SetFlowControl default fwNone;
    property InBufSize: Integer read FInBufSize write SetInBufSize default 4096;
    property Options: TAfComOptions read FOptions write SetOptions default [];
    property OutBufSize: Integer read FOutBufSize write SetOutBufSize default 2048;
    property Parity: TAfParity read FParity write SetParity default paNone;
    property RTS: Boolean read FRTS write Set_RTS default True;
    property Stopbits: TAfStopbits read FStopbits write SetStopbits default sbOne;
    property UserBaudRate: Integer read FUserBaudRate write SetUserBaudRate stored IsUserBaudRateStored;
    property WriteThreadPriority: TThreadPriority read FWriteThreadPriority write SetWriteThreadPriority default tpHighest;
    property XOnChar: Char read FXOnChar write SetXOnChar default #17;
    property XOffChar: Char read FXOffChar write SetXOffChar default #19;
    property XOnLim: Word read FXOnLim write SetXOnLim default 0;
    property XOffLim: Word read FXOffLim write SetXOffLim default 0;
    property OnCTSChanged: TNotifyEvent read FOnCTSChanged write FOnCTSChanged;
    property OnDataRecived: TAfCPTDataReceivedEvent read FOnDataRecived write FOnDataRecived;
    property OnDSRChanged: TNotifyEvent read FOnDSRChanged write FOnDSRChanged;
    property OnRLSDChanged: TNotifyEvent read FOnRLSDChanged write FOnRLSDChanged;
    property OnRINGDetected: TNotifyEvent read FOnRINGDetected write FOnRINGDetected;
    property OnLineError: TAfCPTErrorEvent read FOnLineError write FOnLineError;
    property OnNonSyncEvent: TAfCPTCoreEvent read FOnNonSyncEvent write FOnNonSyncEvent;
    property OnOutBufFree: TNotifyEvent read FOnOutBufFree write FOnOutBufFree;
    property OnPortClose: TNotifyEvent read FOnPortClose write FOnPortClose;
    property OnPortOpen: TNotifyEvent read FOnPortOpen write FOnPortOpen;
    property OnSyncEvent: TAfCPTCoreEvent read FOnSyncEvent write FOnSyncEvent;
  public
    procedure Close; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteConfigDialog: Boolean; dynamic; abstract;
    function ExecuteCOMDialog: Boolean; dynamic; abstract;
    function InBufUsed: Integer;
    procedure Open; override;
    function OutBufFree: Integer;
    function OutBufUsed: Integer;
    procedure PurgeRX;
    procedure PurgeTX;
    function ReadChar: Char;
    procedure ReadData(var Buf; Size: Integer);
    function ReadString: String;
    function SynchronizeEvent(EventKind: TAfComPortEventKind; Data: TAfComPortEventData; Timeout: Integer): Boolean;
    procedure WriteChar(C: Char);
    procedure WriteData(const Data; Size: Integer); override;
    procedure WriteString(const S: String);
    property Active: Boolean read GetActive write SetActive;
    property DCB: TDCB read FDCB write SetDCB;
    property Handle: THandle read GetHandle;
    property CTSHold: Boolean index 1 read GetComStat;
    property DSRHold: Boolean index 2 read GetComStat;
    property RLSDHold: Boolean index 3 read GetComStat;
    property XOffHold: Boolean index 4 read GetComStat;
    property XOffSent: Boolean index 5 read GetComStat;
    property CTS: Boolean index 1 read GetModemStatus;
    property DSR: Boolean index 2 read GetModemStatus;
    property RING: Boolean index 3 read GetModemStatus;
    property RLSD: Boolean index 4 read GetModemStatus;
  end;

  TAfCustomComPort = class(TAfCustomSerialPort)
  private
    FComNumber: Word;
    procedure SetComNumber(const Value: Word);
  protected
    property ComNumber: Word read FComNumber write SetComNumber default 0;
    procedure InternalOpen; override;
    function GetDeviceName: String;
  public
    function ExecuteConfigDialog: Boolean; override;
    function ExecuteCOMDialog: Boolean; override;
    procedure SetDefaultParameters;
    function SettingsStr: String;
  end;

  TAfComPort = class(TAfCustomComPort)
  public
    property Core;
  published
    property AutoOpen;
    property BaudRate;
    property ComNumber;
    property Databits;
    property DTR;
    property EventThreadPriority;
    property FlowControl;
    property InBufSize;
    property Options;
    property OutBufSize;
    property Parity;
    property RTS;
    property Stopbits;
    property UserBaudRate;
    property WriteThreadPriority;
    property XOnChar;
    property XOffChar;
    property XOnLim;
    property XOffLim;
    property OnCTSChanged;
    property OnDataRecived;
    property OnDSRChanged;
    property OnLineError;
    property OnNonSyncEvent;
    property OnOutBufFree;
    property OnPortClose;
    property OnPortOpen;
    property OnRINGDetected;
    property OnRLSDChanged;
    property OnSyncEvent;
  end;

implementation

resourcestring
  sErrorSetDCB = 'Error setting parameters from DCB';
  sPortIsNotClosed = 'Port is not closed';
  sReadError = 'Read data error';
  sWriteError = 'Write data error [requested: %d, free: %d]';

const
  DCB_BaudRates: array[TAfBaudRate] of DWORD =
    (CBR_110, CBR_300, CBR_600, CBR_1200, CBR_2400, CBR_4800, CBR_9600,
     CBR_14400, CBR_19200, CBR_38400, CBR_56000, CBR_57600, CBR_115200,
     CBR_128000, CBR_256000, 0);
  DCB_DataBits: array[TAfDatabits] of DWORD =
    (4, 5, 6, 7, 8);
  DCB_Parity: array[TAfParity] of DWORD =
    (NOPARITY, ODDPARITY, EVENPARITY, MARKPARITY, SPACEPARITY);
  DCB_StopBits: array[TAfStopbits] of DWORD =
    (ONESTOPBIT, ONE5STOPBITS, TWOSTOPBITS);
  DCB_FlowControl: array[TAfFlowControl] of DWORD =
    (0,
     fOutX or fInX,
     fOutxCtsFlow or fRtsControlHandshake,
     fOutxDsrFlow or fDtrControlHandshake);
  DCB_ComOptions: array[TAfComOption] of LongInt =
    (fParity, fDsrSensitivity, fTXContinueOnXoff, fErrorChar, fNull);

{ TAfCustomSerialPort }

procedure TAfCustomSerialPort.CheckClose;
begin
  if Active then
    RaiseError(sPortIsNotClosed);
end;

procedure TAfCustomSerialPort.Close;
begin
  FClosing := True;
  inherited Close;
  if not (csDesigning in ComponentState) then
  begin
    AfEnableSyncSlot(FSyncID, False);
    FCoreComPort.CloseComPort;
    DoPortClose;
  end;
  FClosing := False;
end;

procedure TAfCustomSerialPort.CoreComPortEvent(Sender: TAfComPortCore;
  EventKind: TAfCoreEvent; Data: DWORD);
var
  P: Pointer;
  Count: Integer;
  NeedCallSyncEvents: Boolean;
begin
  if FClosing or (csDestroying in ComponentState) then Exit;
  NeedCallSyncEvents := True;
  if EventKind = ceException then
    SynchronizeEvent(EventKind, Data, AfSynchronizeTimeout)
  else
  begin
    if Assigned(FDispatcher) then
      case TAfComPortEventKind(EventKind) of
        ceLineEvent:
          if Data and EV_RXCHAR <> 0 then
          begin
            if Data and (not EV_RXCHAR) = 0 then
              NeedCallSyncEvents := False; // there aren't any other events to dispatch
            Count := InBufUsed;
            GetMem(P, Count);
            try
              ReadData(P^, Count);
              FDispatcher.Dispatcher_WriteTo(P^, Count);
            finally
              FreeMem(P);
            end;
          end;
        ceNeedReadData:
          begin
            NeedCallSyncEvents := False;
            Count := Data;
            GetMem(P, Count);
            try
              ReadData(P^, Count);
              FDispatcher.Dispatcher_WriteTo(P^, Count);
            finally
              FreeMem(P);
            end;
          end;
        ceOutFree:
          begin
            NeedCallSyncEvents := Assigned(FOnOutBufFree); // some kind of optimization
            FDispatcher.Dispatcher_WriteBufFree;
          end;
      end;
    if Assigned(FOnNonSyncEvent) then
      FOnNonSyncEvent(Self, EventKind, Data)
    else
      if NeedCallSyncEvents then SynchronizeEvent(EventKind, Data, AfSynchronizeTimeout);
  end;
end;

constructor TAfCustomSerialPort.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBaudRate := br115200;
  FDatabits := db8;
  FDTR := True;
  FEventThreadPriority := tpNormal;
  FFlowControl := fwNone;
  FInBufSize := 4096;
  FOptions := [];
  FOutBufSize := 2048;
  FParity := paNone;
  FRTS := True;
  FStopbits := sbOne;
  FWriteThreadPriority := tpHighest;
  FXOnChar := #17;
  FXOffChar := #19;
  if not (csDesigning in ComponentState) then
  begin
    FSyncID := AfNewSyncSlot(SafeSyncEvent);
    FCoreComPort := TAfComPortCore.Create;
    FCoreComPort.OnPortEvent := CoreComPortEvent;
    UpdateDCB;
  end;
end;

destructor TAfCustomSerialPort.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    AfReleaseSyncSlot(FSyncID);
    FCoreComPort.Free;
    FCoreComPort := nil;
  end;
  inherited Destroy;
end;

procedure TAfCustomSerialPort.DispatchComEvent(EventKind: TAfComPortEventKind; Data: TAfComPortEventData);
begin
  if FClosing or (csDestroying in ComponentState) then Exit;
  if Assigned(FOnSyncEvent) then FOnSyncEvent(Self, EventKind, Data);
  case EventKind of
    ceLineEvent:
      begin
        if Data and EV_RXCHAR <> 0 then DoPortData(FCoreComPort.ComStatus.cbInQue);
        DoPortEvent(Data);
      end;
    ceOutFree:
      DoOutBufFree;
    ceNeedReadData:
      DoPortData(Data);
    ceException:
      raise Exception(Data);
  end;
end;

procedure TAfCustomSerialPort.DoOutBufFree;
begin
  if Assigned(FOnOutBufFree) then FOnOutBufFree(Self);
end;

procedure TAfCustomSerialPort.DoPortClose;
begin
  if Assigned(FOnPortClose) then FOnPortClose(Self);
end;

procedure TAfCustomSerialPort.DoPortData(Count: Integer);
begin
  if Assigned(FOnDataRecived) then FOnDataRecived(Self, Count);
end;

procedure TAfCustomSerialPort.DoPortEvent(Event: DWORD);
var
  LastError: DWORD;
begin
  LastError := FCoreComPort.ComError;
  if (Event and EV_ERR <> 0) {or (LastError <> 0)} then
  begin
    if Assigned(FOnLineError) then FOnLineError(Self, LastError);
  end;
  if (Event and EV_CTS <> 0) and Assigned(FOnCTSChanged) then
    FOnCTSChanged(Self);
  if (Event and EV_DSR <> 0) and Assigned(FOnDSRChanged) then
    FOnDSRChanged(Self);
  if (Event and EV_RING <> 0) and Assigned(FOnRINGDetected) then
    FOnRINGDetected(Self);
  if (Event and EV_RLSD <> 0) and Assigned(FOnRLSDChanged) then
    FOnRLSDChanged(Self);
end;

procedure TAfCustomSerialPort.DoPortOpen;
begin
  if Assigned(FOnPortOpen) then FOnPortOpen(Self);
end;

function TAfCustomSerialPort.GetActive: Boolean;
begin
  Result := Assigned(FCoreComPort) and FCoreComPort.IsOpen;
end;

function TAfCustomSerialPort.GetComStat(Index: Integer): Boolean;
begin
  Result := TComStateFlag(Index - 1) in FCoreComPort.ComStatus.Flags
end;

function TAfCustomSerialPort.GetHandle: THandle;
begin
  Result := FCoreComPort.Handle;
end;

function TAfCustomSerialPort.GetModemStatus(Index: Integer): Boolean;
const
  Mask: array[1..4] of DWORD = (MS_CTS_ON, MS_DSR_ON, MS_RING_ON, MS_RLSD_ON);
begin
  Result := FCoreComPort.ModemStatus and Mask[Index] <> 0;
end;

function TAfCustomSerialPort.GetNumericBaudrate: Integer;
begin
  if FBaudRate = brUser then
    Result := FUserBaudRate
  else
    Result := DCB_BaudRates[FBaudRate];
end;

function TAfCustomSerialPort.InBufUsed: Integer;
begin
  Result := FCoreComPort.ComStatus.cbInQue;
end;

function TAfCustomSerialPort.IsUserBaudRateStored: Boolean;
begin
  Result := FBaudRate = brUser;
end;

procedure TAfCustomSerialPort.Loaded;
begin
  inherited Loaded;
  if FAutoOpen then Open else UpdateDCB;
end;

procedure TAfCustomSerialPort.Open;
begin
  if not ((csDesigning in ComponentState) or FCoreComPort.IsOpen) then
  begin
    AfEnableSyncSlot(FSyncID, True);
    FCoreComPort.DCB := FDCB;
    FCoreComPort.InBuffSize := FInBufSize;
    FCoreComPort.OutBuffSize := FOutBufSize;
    FCoreComPort.EventThreadPriority := FEventThreadPriority;
    FCoreComPort.WriteThreadPriority := FWriteThreadPriority;
    FClosing := False;
    InternalOpen;
    DoPortOpen;
  end;
  inherited Open;
end;

function TAfCustomSerialPort.OutBufFree: Integer;
begin
  Result := FCoreComPort.OutBuffFree;
end;

function TAfCustomSerialPort.OutBufUsed: Integer;
begin
  Result := FCoreComPort.OutBuffUsed;
end;

procedure TAfCustomSerialPort.PurgeRX;
begin
  if not FClosing then FCoreComPort.PurgeRX;
end;

procedure TAfCustomSerialPort.PurgeTX;
begin
  if not FClosing then FCoreComPort.PurgeTX;
end;

procedure TAfCustomSerialPort.RaiseError(const ErrorMsg: String);
begin
  raise EAfComPortError.CreateFmt('%s - %s ', [ErrorMsg, Name]);
end;

function TAfCustomSerialPort.ReadChar: Char;
begin
  ReadData(Result, Sizeof(Result));
end;

procedure TAfCustomSerialPort.ReadData(var Buf; Size: Integer);
begin
  if FClosing then Exit;
  if FCoreComPort.ReadData(Buf, Size) <> Size then
    RaiseError(sReadError);
end;

function TAfCustomSerialPort.ReadString: String;
var
  Size: Integer;
begin
  if FClosing then
    Result := ''
  else
  begin
    Size := FCoreComPort.ComStatus.cbInQue;
    SetLength(Result, Size);
    FCoreComPort.ReadData(Pointer(Result)^, Size);
  end;  
end;

procedure TAfCustomSerialPort.SafeSyncEvent(ID: TAfSyncSlotID);
begin
  if not FClosing {Active} then DispatchComEvent(Sync_Event, Sync_Data);
end;

procedure TAfCustomSerialPort.SetActive(const Value: Boolean);
begin
  if Value then Open else Close;
end;

procedure TAfCustomSerialPort.SetBaudRate(const Value: TAfBaudrate);
begin
  if FBaudRate <> Value then
  begin;
    FBaudRate := Value;
    if FBaudRate <> brUser then FUserBaudRate := 0;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.SetDatabits(const Value: TAfDatabits);
begin
  if FDatabits <> Value then
  begin
    FDatabits := Value;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.SetDCB(const Value: TDCB);
var
  QBaudRate: TAfBaudrate;
  QDataBits: TAfDatabits;
  QParity: TAfParity;
  QStopBits: TAfStopbits;
  QFlowControl: TAfFlowControl;
  QOptions: TAfComOption;
  Found: Boolean;
begin
  if Value.DCBlength <> Sizeof(TDCB) then
    RaiseError(sErrorSetDCB);
  FDCB := Value;
  Found := False;
  for QBaudRate := Low(QBaudRate) to High(QBaudRate) do
    if FDCB.BaudRate = DCB_BaudRates[QBaudRate] then
    begin
      Found := True;
      FBaudRate := QBaudRate;
      Break;
    end;
  if not Found then
  begin
    FBaudRate := brUser;
    FUserBaudRate := FDCB.BaudRate;
  end;

  Found := False;
  for QDataBits := Low(QDataBits) to High(QDataBits) do
    if FDCB.ByteSize = DCB_DataBits[QDataBits] then
    begin
      Found := True;
      FDatabits := QDataBits;
      Break;
    end;
  if not Found then FDatabits := db8;

  Found := False;
  for QParity := Low(QParity) to High(QParity) do
    if FDCB.Parity = DCB_Parity[QParity] then
    begin
      Found := True;
      FParity := QParity;
      Break;
    end;
  if not Found then FParity := paNone;

  Found := False;
  for QStopBits := Low(QStopBits) to High(QStopBits) do
    if FDCB.StopBits = DCB_StopBits[QStopBits] then
    begin
      Found := True;
      FStopbits := QStopBits;
      Break;
    end;
  if not Found then FStopbits := sbOne;

  Found := False;
  for QFlowControl := High(QFlowControl) downto Low(QFlowControl) do
    if FDCB.Flags and DCB_FlowControl[QFlowControl] = DCB_FlowControl[QFlowControl] then
    begin
      Found := True;
      FFlowControl := QFlowControl;
      Break;
    end;
  if not Found then FFlowControl := fwNone;

  FOptions := [];
  for QOptions := Low(QOptions) to High(QOptions) do
    if FDCB.Flags and DCB_ComOptions[QOptions] <> 0 then
      Include(FOptions, QOptions);
  FXOnChar := FDCB.XonChar;
  FXOffChar := FDCB.XoffChar;
  FXOnLim := FDCB.XonLim;
  FXOffLim := FDCB.XoffLim;

  UpdateDCB;
end;

procedure TAfCustomSerialPort.Set_DTR(const Value: Boolean);
const
  ESC_DTR: array[Boolean] of DWORD = (CLRDTR, SETDTR);
begin
  if FDTR <> Value then
  begin
    if Assigned(FCoreComPort) then FCoreComPort.EscapeComm(ESC_DTR[Value]);
    FDTR := Value;
  end;
end;

procedure TAfCustomSerialPort.SetEventThreadPriority(const Value: TThreadPriority);
begin
  if FEventThreadPriority <> Value then
  begin
    FEventThreadPriority := Value;
  end;
end;

procedure TAfCustomSerialPort.SetFlowControl(const Value: TAfFlowControl);
begin
  if (FFlowControl <> Value) then
  begin
    FFlowControl := Value;
    UpdateOnOffLimit;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.SetInBufSize(const Value: Integer);
begin
  if FInBufSize <> Value then
  begin
    CheckClose;
    FInBufSize := Value;
    UpdateOnOffLimit;
  end;
end;

procedure TAfCustomSerialPort.SetOptions(const Value: TAfComOptions);
begin
  if FOptions <> Value then
  begin
    FOptions := Value;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.SetOutBufSize(const Value: Integer);
begin
  if FOutBufSize <> Value then
  begin
    CheckClose;
    FOutBufSize := Value;
  end;
end;

procedure TAfCustomSerialPort.SetParity(const Value: TAfParity);
begin
  if FParity <> Value then
  begin
    FParity := Value;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.Set_RTS(const Value: Boolean);
const
  ESC_RTS: array[Boolean] of DWORD = (CLRRTS, SETRTS);
begin
  if (FRTS <> Value) then
  begin
    if Assigned(FCoreComPort) then FCoreComPort.EscapeComm(ESC_RTS[Value]);
    FRTS := Value;
  end;
end;

procedure TAfCustomSerialPort.SetStopbits(const Value: TAfStopbits);
begin
  if FStopbits <> Value then
  begin
    FStopbits := Value;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.SetUserBaudRate(const Value: Integer);
begin
  if FUserBaudRate <> Value then
  begin
    FUserBaudRate := Value;
    FBaudRate := brUser;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.SetWriteThreadPriority(const Value: TThreadPriority);
begin
  if FWriteThreadPriority <> Value then
  begin
    FWriteThreadPriority := Value;
  end;
end;

procedure TAfCustomSerialPort.SetXOffChar(const Value: Char);
begin
  if FXOffChar <> Value then
  begin
    FXOffChar := Value;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.SetXOnChar(const Value: Char);
begin
  if FXOnChar <> Value then
  begin
    FXOnChar := Value;
    UpdateDCB;
  end;
end;

procedure TAfCustomSerialPort.SetXOffLim(const Value: Word);
begin
  if FXOffLim <> Value then
  begin
    FXOffLim := Value;
    FXOnLim := FInBufSize - Value;
  end;
end;

procedure TAfCustomSerialPort.SetXOnLim(const Value: Word);
begin
  if FXOnLim <> Value then
  begin
    FXOnLim := Value;
    FXOffLim := FInBufSize - Value;
  end;
end;

function TAfCustomSerialPort.SynchronizeEvent(EventKind: TAfComPortEventKind;
  Data: TAfComPortEventData; Timeout: Integer): Boolean;
begin
  Sync_Event := EventKind;
  Sync_Data := Data;
  Result := AfSyncEvent(FSyncID, Timeout);
  if (not Result) then
    Abort; // object was destroyed during sync event, get out from here
end;

procedure TAfCustomSerialPort.UpdateDCB;
var
  ComOpt: TAfComOption;
begin
  if not (csDesigning in ComponentState) then
  begin
    ZeroMemory(@FDCB, Sizeof(FDCB));
    with FDCB do
    begin
      DCBlength := Sizeof(TDCB);
      if FBaudRate = brUser then
        BaudRate := FUserBaudRate
      else
        BaudRate := DCB_BaudRates[FBaudRate];
      ByteSize := DCB_Databits[FDatabits];
      Parity := DCB_Parity[FParity];
      Stopbits := DCB_Stopbits[FStopbits];
      XonChar := FXOnChar;
      XoffChar := FXOffChar;
      XonLim := FXOnLim;
      XoffLim := FXOffLim;
      Flags := DCB_FlowControl[FFlowControl] or fBinary;
      for ComOpt := Low(TAfComOption) to High(TAfComOption) do
        if ComOpt in FOptions then Flags := Flags or DCB_ComOptions[ComOpt];
      if FDTR and (FFlowControl <> fwDtrDsr) then
        Flags := Flags or fDtrControlEnable;
      if FRTS and (FFlowControl <> fwRtsCts) then
        Flags := Flags or fRtsControlEnable;
    end;
    if Active then
    try
      FCoreComPort.DCB := FDCB;
    except
      FDCB := FCoreComPort.DCB;
      raise;
    end;
  end;
end;

procedure TAfCustomSerialPort.UpdateOnOffLimit;
begin
  if FFlowControl = fwNone then
  begin
    FXOnLim := 0;
    FXOffLim := 0;
  end else
  begin
    FXOnLim := FInBufSize div 4;
    FXOffLim := FInBufSize - FXOnLim;
  end;
end;

procedure TAfCustomSerialPort.WriteChar(C: Char);
begin
  WriteData(C, 1);
end;

procedure TAfCustomSerialPort.WriteData(const Data; Size: Integer);
begin
  if (not FClosing) and not FCoreComPort.WriteData(Data, Size) then
    RaiseError(Format(sWriteError, [Size, OutBufFree]));
end;

procedure TAfCustomSerialPort.WriteString(const S: String);
begin
  if Length(S) > 0 then WriteData(Pointer(S)^, Length(S));
end;

{ TAfCustomComPort }

function TAfCustomComPort.ExecuteCOMDialog: Boolean;
begin
  result:=  ExecuteConfigDialog;
end;

function TAfCustomComPort.ExecuteConfigDialog: Boolean;
var
  CommConfig: TCommConfig;
  BufSize: DWORD;
  Res: Boolean;
begin
  Result := False;
  ZeroMemory(@CommConfig, Sizeof(CommConfig));
  if Active then
    Res := GetCommConfig(Handle, CommConfig, BufSize) else
      Res := GetDefaultCommConfig(PChar(GetDeviceName), CommConfig, BufSize);
  CommConfig.dcb := FDCB;
  CommConfig.dwSize := Sizeof(CommConfig);
  if Res then
    Result := CommConfigDialog(PChar(GetDeviceName), Application.Handle, CommConfig);
  if Result then
    SetDCB(CommConfig.dcb);
end;

function TAfCustomComPort.GetDeviceName: String;
begin
  Result := Format('COM%d', [FComNumber]);
end;

procedure TAfCustomComPort.InternalOpen;
begin
  Screen.Cursor := crHourGlass;
  try
    FCoreComPort.OpenComPort(FComNumber);
  finally
    Screen.Cursor := crDefault;
  end;  
end;

procedure TAfCustomComPort.SetComNumber(const Value: Word);
begin
  if FComNumber <> Value then
  begin
    if Active then
    begin
      Close;
      FComNumber := Value;
      Open;
    end else
      FComNumber := Value;
  end;
end;

procedure TAfCustomComPort.SetDefaultParameters;
var
  CommConfig: TCommConfig;
  BufSize: DWORD;
begin
  ZeroMemory(@CommConfig, Sizeof(CommConfig));
  CommConfig.dwSize := Sizeof(CommConfig);
  if GetDefaultCommConfig(PChar(GetDeviceName), CommConfig, BufSize) then
    SetDCB(CommConfig.dcb);
end;

function TAfCustomComPort.SettingsStr: String;
const
  ParityStr: array[TAfParity] of Char = ('N', 'O', 'E', 'M', 'S');
  StopbitStr: array[TAfStopbits] of String = ('1', '1.5', '2');
begin
  Result := Format('COM%d: %d,%s,%s,%s', [FComNumber, GetNumericBaudrate,
    ParityStr[FParity], Chr(Ord(FDatabits) + 4 + 48), StopbitStr[FStopbits]]);
end;

end.
