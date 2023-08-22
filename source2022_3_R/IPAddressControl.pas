{******************************************************************************}
{*        Copyright 2001 by J.Friebel all rights reserved.                    *}
{*        Autor           :  Jörg Friebel                                     *}
{*        Compiler        :  Delphi 4 / 5                                     *}
{*        System          :  Windows NT / 2000 (9x not tested !)              *}
{*        Projekt         :  IP Address Control                               *}
{*        Last Update     :  11-06-2001                                       *}
{*        Version         :  2.00                                            *}
{*        EMail           :  joergfriebel@t-online.de                         *}
{******************************************************************************}
{*        Warning you need Comctl32.dll Version 4.71 or later                 *}
{******************************************************************************}
{*                                                                            *}
{*    This File is free software; You can redistribute it and/or modify it    *}
{*    under the term of GNU Library General Public License as published by    *}
{*    the Free Software Foundation. This File is distribute in the hope       *}
{*    it will be useful "as is", but WITHOUT ANY WARRANTY OF ANY KIND;        *}
{*    See the GNU Library Public Licence for more details.                    *}
{*                                                                            *}
{******************************************************************************}
{*                                                                            *}
{*    Diese Datei ist Freie-Software. Sie können sie weitervertreiben         *}
{*    und/oder verändern im Sinne der Bestimmungen der "GNU Library GPL"      *}
{*    der Free Software Foundation. Diese Datei wird,"wie sie ist",           *}
{*    zur Verfügung gestellt, ohne irgendeine GEWÄHRLEISTUNG.                 *}
{*                                                                            *}
{******************************************************************************}
{*                          www.delphiclub.de                                 *}
{******************************************************************************}

unit IPAddressControl;

{$R-,T-,H+,X+,Q-}

interface

{$IFDEF Ver125} {$DEFINE C++Build3} {$ENDIF}

uses
  Windows, Messages, SysUtils, CommCtrl, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls,stdctrls;

resourcestring RangeError =
                 '$%x liegt nicht im gültigen Bereich zwischen $%x..$%x';


type
  TIPAddrRange = class(TPersistent)
  private
    FLowerLimit:byte;
    FUpperLimit:byte;
    function GetIPRange(Index:Integer): Byte;
    procedure SetIPRange(Index: Integer; Value: Byte);
  public
    constructor Create;
  published
    property LowerLimit:Byte index 1 read GetIPRange write SetIPRange default 0;
    property UpperLimit:Byte index 2 read GetIPRange write SetIPRange default 255;
  end;

type
  TIPAddressField = class(TPersistent)
  private
    FOwner:TComponent;
    FRange:TIPAddrRange;
    FDigit:Integer;
    FAddrID:Integer;
    procedure SetDigit(const Value: Integer);
    procedure SetRange(const Value: TIPAddrRange);
    procedure WMDestroy(var Message: TWMDestroy); message WM_DESTROY;
    function GetDigit: Integer;
  public
    constructor Create(AOwner:TComponent;AAddrID:Integer);
    destructor Destroy;override;
  published
    property Range:TIPAddrRange read FRange write SetRange;
    property Digit:Integer read GetDigit write SetDigit default 0;
  end;



type
 TRangeErrorEvent=procedure(Sender:TObject;var IPRange:TIPAddrRange;Value,Field:Integer)of Object;


type
  TCustomIPAddressControl = class(TWinControl)
  private
    FHandle: HWnd;
    FFirstChildID:Integer;
    FField0:TIPAddressField;
    FField1:TIPAddressField;
    FField2:TIPAddressField;
    FField3:TIPAddressField;
    FOnChange: TNotifyEvent;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    FOnRangeError:TRangeErrorEvent;
    FAutoSize: Boolean;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMCTLCOLOREDIT(var Message: TWMCTLCOLOREDIT);message WM_CTLCOLOREDIT;
    procedure WMSize(var Message: TMessage);message WM_Size;
    procedure WMParentNotify(var Message: TWMParentNotify); message WM_PARENTNOTIFY;
    procedure WMGETDLGCODE(var Message :TWMGetDlgCode);message WM_GETDLGCODE;
    procedure SetFirstIPAddress(const Value: Integer);
    procedure SetIPAddress;
    procedure SetFourthIPAddress(const Value: Integer);
    procedure SetSecondIPAddress(const Value: Integer);
    procedure SetThirdIPAddress(const Value: Integer);
    function GetIsBlank: boolean;
    procedure SetIsBlank(const Value: boolean);
    procedure Adjust;
    procedure SetAutoSize(const Value: Boolean);
    procedure UpdateHeight;
    function GetIPAddr: String;
    procedure SetIPAddr(const Value: String);
    function GetFirstIPAddress: Integer;
    function GetSecondIPAddress: Integer;
    function GetFourthIPAddress: Integer;
    function GetThirdIPAddress: Integer;
    function GetRanges0: TIPAddrRange;
    function GetRanges1: TIPAddrRange;
    function GetRanges2: TIPAddrRange;
    function GetRanges3: TIPAddrRange;
    procedure SetRanges0(const Value: TIPAddrRange);
    procedure SetRanges1(const Value: TIPAddrRange);
    procedure SetRanges2(const Value: TIPAddrRange);
    procedure SetRanges3(const Value: TIPAddrRange);
    function GetModified: Boolean;
    procedure UpdateIPAddress;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Change;
    procedure Enter;
    procedure Leave;
    procedure RaiseRangeError(IPRange:TIPAddrRange;Value,Field:Integer);
    property AutoSize:Boolean read FAutoSize write SetAutoSize default False;
    property ParentColor default False;
    property ParentFont default False;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DefaultHandler(var Message);override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
    property IsBlank:boolean read GetIsBlank write SetIsBlank default True;
    property OnRangeError:TRangeErrorEvent read FOnRangeError write FOnRangeError;
    property Color default clWindow;
    property Font;
    property IPAddress:String read GetIPAddr write SetIPAddr;
    property Modified:Boolean read GetModified ;
  published
    property Field0 :Integer read GetFirstIPAddress write SetFirstIPAddress default 0;
    property Field1 :Integer read GetSecondIPAddress write SetSecondIPAddress default 0;
    property Field2 :Integer read GetThirdIPAddress write SetThirdIPAddress default 0;
    property Field3 :Integer read GetFourthIPAddress write SetFourthIPAddress default 0;
    property RangeField0:TIPAddrRange read GetRanges0 write SetRanges0;
    property RangeFiled1:TIPAddrRange read GetRanges1 write SetRanges1;
    property RangeField2:TIPAddrRange read GetRanges2 write SetRanges2;
    property RangeFiled3:TIPAddrRange read GetRanges3 write SetRanges3;
    property TabStop default True;
    property TabOrder;
  end;

type
  TIPAddressControl = class(TCustomIPAddressControl)
  published
    property OnChange;
    property OnEnter;
    property OnExit;
    property OnRangeError;
    {$IFNDEF C++Build3}
    property OnResize;
    {$ENDIF}
    property ShowHint;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property AutoSize;
    {$IFNDEF C++Build3}
    property Anchors;
    {$ENDIF}
    property Visible;
    property Color;
    {$IFNDEF C++Build3}
    property BiDiMode;
    {$ENDIF}
    property Font;
    property IPAddress;
    property Modified;

  end;

procedure Register;

implementation

uses Consts;


procedure Register;
begin
  RegisterComponents('Internet', [TIPAddressControl]);
end;

{ TCustomIPAddressControl }

constructor TCustomIPAddressControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFirstChildID:=0;
  ControlStyle :=ControlStyle+[csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  TabStop := True;
  Width := 121;
  Height := 25;
  FField0:=TIPAddressField.Create(self,0);
  FField1:=TIPAddressField.Create(self,1);
  FField2:=TIPAddressField.Create(self,2);
  FField3:=TIPAddressField.Create(self,3);
  FAutoSize:=False;
  ParentColor:=False;
  ParentFont:=False;
  Color:=clWindow;
  IsBlank:=true;
end;

destructor TCustomIPAddressControl.Destroy;
begin
  if HandleAllocated then DestroyWindowHandle;
  FField0.Free;
  FField1.Free;
  FField2.Free;
  FField3.Free;
  inherited Destroy;
end;

procedure TCustomIPAddressControl.Change;
begin
  inherited Changed;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TCustomIPAddressControl.CMFontChanged(var Message: TMessage);
begin
  Adjust;
  inherited;
  if HandleAllocated then Perform(WM_SIZE, 0, 0);
end;

procedure TCustomIPAddressControl.WMSize(var Message: TMessage);
begin
  if not (csLoading in ComponentState) then Resize;
  Repaint;
end;

procedure TCustomIPAddressControl.Adjust;
var
  DC: HDC;
  SaveFont: HFont;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Height := Metrics.tmHeight + 8;
  Width :=(Metrics.tmMaxCharWidth+8)*8;
end;

procedure TCustomIPAddressControl.CNCommand(var Message: TWMCommand);
begin
  case Message.NotifyCode of
    EN_SETFOCUS :Enter;
    EN_KILLFOCUS:Leave;
    EN_CHANGE :Change;
    1:;
    else inherited;
  end;
end;

procedure TCustomIPAddressControl.CNNotify(var Message: TWMNotify);
var IP_a:TNMIPAddress ;
begin
  inherited;
  with Message do
  begin
    case NMHdr^.Code of
      IPN_FIELDCHANGED:
      begin
        IP_a:=PNMIPADDRESS(Message.NMHdr)^;
        with IP_a do
        case iField of
          0:FField0.Digit:=iValue;
          1:FField1.Digit:=iValue;
          2:FField2.Digit:=iValue;
          3:FField3.Digit:=iValue;
        end;
      end;
    end;
  end;
end;

procedure TCustomIPAddressControl.CreateParams(var Params: TCreateParams);
begin
  InitCommonControl(ICC_INTERNET_CLASSES);
  inherited CreateParams(Params);
  CreateSubClass(Params, WC_IPADDRESS);
  with Params  do
  begin
    Style :=WS_Child;
    ExStyle:=WS_EX_CONTROLPARENT;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW );
  end;
end;

procedure TCustomIPAddressControl.CreateWindowHandle(
  const Params: TCreateParams);
begin
  with Params do
    FHandle := CreateWindowEx(ExStyle, WinClassName, Caption, Style,
      X, Y, Width, Height, WndParent, 0, WindowClass.hInstance, Param);
end;

procedure TCustomIPAddressControl.CreateWnd;
var
  Params: TCreateParams;
  TempClass: TWndClass;
  ClassRegistered: Boolean;
begin
  CreateParams(Params);
  with Params do
  begin
    if (WndParent = 0) and (Style and WS_CHILD <> 0) then
      if (Owner <> nil) and (csReading in Owner.ComponentState) and
        (Owner is TWinControl) then
        WndParent := TWinControl(Owner).Handle
      else
        raise EInvalidOperation.CreateFmt(SParentRequired, [Name]);
    DefWndProc := WindowClass.lpfnWndProc;
    ClassRegistered := GetClassInfo(WindowClass.hInstance, WinClassName, TempClass);
    if not ClassRegistered or (TempClass.lpfnWndProc <> @InitWndProc) then
    begin
      if ClassRegistered then Windows.UnregisterClass(WinClassName,
        WindowClass.hInstance);
      WindowClass.lpfnWndProc := @InitWndProc;
      WindowClass.lpszClassName := WinClassName;
      if Windows.RegisterClass(WindowClass) = 0 then RaiseLastWin32Error;
    end;
    CreationControl := Self;
    CreateWindowHandle(Params);
    if Handle = 0 then RaiseLastWin32Error;
  end;
  Text := '';
  if AutoSize then Adjust;
  SetIPAddress;
end;

procedure TCustomIPAddressControl.Enter;
begin
  if Assigned(FOnEnter) then FOnEnter(Self);
end;

procedure TCustomIPAddressControl.Leave;
begin
  if Assigned(FOnExit) then FOnExit(Self);
end;

function TCustomIPAddressControl.GetIsBlank: boolean;
begin
  Result:=True;
  if HandleAllocated then
    if SendMessage(Handle,IPM_ISBLANK,0,0)=0 then Result:=False;
end;

procedure TCustomIPAddressControl.RaiseRangeError(
   IPRange: TIPAddrRange;Value,Field:Integer);
begin
  if Assigned(FOnRangeError) then FOnRangeError(Self,IPRange,Value,Field)
  else
  begin
    case Field of
      1:FField0.Digit:=255;
      2:FField1.Digit:=255;
      3:FField2.Digit:=255;
      4:FField3.Digit:=255;
     end;
     raise ERangeError.CreateFmt(RangeError,[Value,IPRange.LowerLimit,IPRange.UpperLimit ]);
  end;
end;

procedure TCustomIPAddressControl.SetFirstIPAddress(const Value: Integer);
begin
  if (Value <> FField0.FDigit) or isBlank then
  begin
    if (Value < FField0.Range.LowerLimit) or (Value >FField0.Range.UpperLimit)then
    RaiseRangeError(FField0.Range,Value,1);
    FField0.FDigit := Value;
    SetIPAddress;
  end;
end;


procedure TCustomIPAddressControl.SetFourthIPAddress(const Value: Integer);
begin
  if (Value <> FField3.Digit) or isBlank then
  begin
    if (Value < FField3.Range.LowerLimit) or (Value >FField3.Range.UpperLimit)then
    RaiseRangeError(FField3.Range,Value,4);
    FField3.Digit := Value;
    SetIPAddress;
  end;
end;

procedure TCustomIPAddressControl.SetIPAddress;
begin
  if HandleAllocated then
  SendMessage(Handle,IPM_SETADDRESS,0,
  MakeIPAddress(FField0.Digit,FField1.Digit,FField2.Digit,FField3.Digit));
end;

procedure TCustomIPAddressControl.SetIsBlank(const Value: boolean);
begin
  if HandleAllocated then
  If (Value=True) then SendMessage(Handle,IPM_CLEARADDRESS,0,0);
end;

procedure TCustomIPAddressControl.SetSecondIPAddress(const Value: Integer);
begin
  if (Value <> FField1.Digit) or isBlank then
  begin
    if (Value < FField1.Range.LowerLimit) or (Value >FField1.Range.UpperLimit)then
    RaiseRangeError(FField1.Range,Value,2);
    FField1.Digit := Value;
    SetIPAddress;
  end;
end;

procedure TCustomIPAddressControl.SetThirdIPAddress(const Value: Integer);
begin
  if (Value <> FField2.Digit) or isBlank then
  begin
    if (Value < FField2.Range.LowerLimit) or (Value >FField2.Range.UpperLimit)then
    RaiseRangeError(FField2.Range,Value,3);
    FField2.Digit := Value;
    SetIPAddress;
  end;
end;

procedure TCustomIPAddressControl.SetAutoSize(const Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    UpdateHeight;
  end;
end;
procedure TCustomIPAddressControl.UpdateHeight;
begin
  if FAutoSize then
  begin
    ControlStyle := ControlStyle + [csFixedHeight];
    Adjust;
  end else
    ControlStyle := ControlStyle - [csFixedHeight];
end;

procedure TCustomIPAddressControl.WMCTLCOLOREDIT(
  var Message: TWMCTLCOLOREDIT);
var DC:HDC;
begin
  DC:=GetDC(Handle);
  Brush.Color:=ColorToRGB(Color);
  Brush.Style:=bsSolid;
  SetTextColor(DC,ColorToRGB(Font.Color));
  SetTextColor(Message.ChildDC,ColorToRGB(Font.Color));
  SetBkColor(DC,ColorToRGB(Brush.Color));
  SetBkColor(Message.ChildDC,ColorToRGB(Brush.Color));
  SetBkMode(Message.ChildDC,TRANSPARENT	);
  ReleaseDC(Handle,DC);
  Message.Result:=Brush.Handle;
end;

procedure TCustomIPAddressControl.WMParentNotify(
  var Message: TWMParentNotify);
begin
  DefaultHandler(Message);
end;

function TCustomIPAddressControl.GetIPAddr: String;
begin
  if isBlank then Result:=''
  else
  begin
    IF Modified then UpdateIPAddress;
    Result:=IntToStr(Field0)+'.'+IntToStr(Field1)+'.'+IntToStr(Field2)+'.'+IntToStr(Field3);
  end;
end;

procedure TCustomIPAddressControl.SetIPAddr(const Value: String);
var SubStr,NStr:String;
    L,L1,I,Count:Integer;
    S1:String;
begin
  try
    NStr:=Value+'.';
    i:=1;
    while NStr<>''do
    begin
      L:=Length(NStr);
      Count:=Pos('.',NStr);
      S1:=Copy(NStr,0,Count-1);
      L1:=Length(S1);
      SubStr:=Copy(NStr,L1+2,L-L1);
      NStr:=SubStr;
      case i of
        1:Field0:=StrToInt(S1);
        2:Field1:=StrToInt(S1);
        3:Field2:=StrToInt(S1);
        4:Field3:=StrToInt(S1);
      end;
      inc(i);
      if i=5 then break;
    end;
  except
    isBlank:=True
  end;
end;

function TCustomIPAddressControl.GetFirstIPAddress: Integer;
begin
  Result:=FField0.Digit;
end;

function TCustomIPAddressControl.GetSecondIPAddress: Integer;
begin
  Result:=FField1.Digit;
end;

function TCustomIPAddressControl.GetFourthIPAddress: Integer;
begin
  Result:=FField3.Digit;
end;

function TCustomIPAddressControl.GetThirdIPAddress: Integer;
begin
  Result:=FField2.Digit;
end;

function TCustomIPAddressControl.GetRanges0: TIPAddrRange;
begin
  Result:=FField0.Range;
end;

function TCustomIPAddressControl.GetRanges1: TIPAddrRange;
begin
  Result:=FField1.Range;
end;

function TCustomIPAddressControl.GetRanges2: TIPAddrRange;
begin
  Result:=FField2.Range;
end;

function TCustomIPAddressControl.GetRanges3: TIPAddrRange;
begin
  Result:=FField3.Range;
end;

procedure TCustomIPAddressControl.SetRanges0(const Value: TIPAddrRange);
begin
  if (Value <> FField0.Range)then
    FField0.Range:=Value;
end;

procedure TCustomIPAddressControl.SetRanges1(const Value: TIPAddrRange);
begin
  if (Value <> FField1.Range)then
    FField0.Range:=Value;
end;

procedure TCustomIPAddressControl.SetRanges2(const Value: TIPAddrRange);
begin
  if (Value <> FField2.Range)then
    FField0.Range:=Value;
end;

procedure TCustomIPAddressControl.SetRanges3(const Value: TIPAddrRange);
begin
  if (Value <> FField3.Range)then
    FField0.Range:=Value;
end;

function TCustomIPAddressControl.GetModified: Boolean;
var NewValues:DWORD;
begin
  NewValues:=0;
  if HandleAllocated then
  SendMessage(Handle,IPM_GETADDRESS,0,longint(@NewValues));
  IF ((FIRST_IPADDRESS(NewValues)=DWORD(FField0.Digit)) and
     (SECOND_IPADDRESS(NewValues)=DWORD(FField1.Digit)) and
        (THIRD_IPADDRESS(NewValues)= DWORD(FField2.Digit)) and
           (FOURTH_IPADDRESS(NewValues)= DWORD(FField3.Digit))) then Result:=False
  else
  Result:=True;
end;

procedure TCustomIPAddressControl.UpdateIPAddress;
var NewValues:DWord;
begin
  NewValues:=0;
  if HandleAllocated then
  SendMessage(Handle,IPM_GETADDRESS,0,longint(@NewValues));
  FField0.Digit:= FIRST_IPADDRESS(NewValues);
  FField1.Digit:= SECOND_IPADDRESS(NewValues);
  FField2.Digit:= THIRD_IPADDRESS(NewValues);
  FField3.Digit:= FOURTH_IPADDRESS(NewValues);
end;

procedure TCustomIPAddressControl.DefaultHandler(var Message);
begin
  if TMessage(Message).Msg = WM_SETFOCUS then
    if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
        not IsWindow(TWMSetFocus(Message).FocusedWnd) then
        TWMSetFocus(Message).FocusedWnd := 0;
   inherited;
end;


procedure TCustomIPAddressControl.WMGETDLGCODE(var Message: TWMGetDlgCode);
begin
  Message.Result:=DLGC_WANTARROWS;
end;


{ TIPAddrRange }

constructor TIPAddrRange.Create;
begin
  inherited Create;
  FLowerLimit:=0;
  FUpperLimit:=255;
end;

function TIPAddrRange.GetIPRange(Index: Integer): Byte;
begin
  Result:=255;
  case Index of
    1:Result:=FLowerLimit;
    2:Result:=FUpperLimit;
  end;
end;

procedure TIPAddrRange.SetIPRange(Index: Integer; Value: Byte);
begin
  case Index of
    1:FLowerLimit:=Value;
    2:FUpperLimit:=Value;
  end;
end;

{ TIPAddressField }

constructor TIPAddressField.Create(AOwner: TComponent; AAddrID: Integer);
begin
  inherited Create;
  FOwner:=AOwner;
  FRange:=TIPAddrRange.Create;
  Digit:=0;
  FAddrID:=AAddrID;
end;

destructor TIPAddressField.Destroy;
begin

  inherited Destroy;
end;

function TIPAddressField.GetDigit: Integer;
begin
  Result:=FDigit;
end;

procedure TIPAddressField.SetDigit(const Value: Integer);
begin
  FDigit:=Value;
end;

procedure TIPAddressField.SetRange(const Value: TIPAddrRange);
begin
  if FRange<> Value then
  begin
    FRange := Value;
    SendMessage(TIPAddressControl(FOwner).Handle,IPM_SETRANGE,FAddrID,MakeIPRange(FRange.LowerLimit,FRange.UpperLimit));
  end;
end;

procedure TIPAddressField.WMDestroy(var Message: TWMDestroy);
begin
  inherited;
end;

end.
