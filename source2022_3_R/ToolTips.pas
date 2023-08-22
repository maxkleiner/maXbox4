unit Tooltips;

interface

uses Windows, Messages, SysUtils, Types, Graphics, Controls;

type
  // Large icons are supported on Vista+.
  TToolTipIcon = (tiNone, tiInfo, tiWarning, tiError, tiInfoLarge, tiWarningLarge, tiErrorLarge);

  TToolInfo = packed record
    cbSize: Integer;
    uFlags: Integer;
    hwnd: THandle;
    uId: Integer;
    rect: TRect;
    hinst: THandle;
    lpszText: PWideChar;
    lParam: Integer;
  end;

  TControlTooltip = class
  protected
    FWnd: THandle;
    FUnderWnd: THandle;
    FInfo: TToolInfo;
    FIcon: TToolTipIcon;
    FBkColor: TColor;
    FTextColor: TColor;
    FAutoHide: Boolean;     
    FCenterTail: Boolean;
    FTitle, FText: WideString;

    function CreateWnd: THandle;
    procedure UpdateInfo;

    procedure SetBkColor(Value: TColor);
    procedure SetIcon(Value: TToolTipIcon);
    procedure SetTextColor(Value: TColor);
    procedure SetAutoHide(Value: Boolean);
    procedure SetText(const Value: WideString);
    procedure SetTitle(const Value: WideString);
    procedure SetCenterTail(const Value: Boolean);
  public
    constructor Create(UnderWnd: THandle; const Title, Text: WideString);
    destructor Destroy; override;

    procedure MoveTo(const Point: TPoint); overload;
    procedure MoveTo(Control: TControl); overload;

    property Handle: THandle read FWnd;
    property UnderWnd: THandle read FUnderWnd;
    property Info: TToolInfo read FInfo;
    property Icon: TToolTipIcon read FIcon write SetIcon default tiNone;
    property BkColor: TColor read FBkColor write SetBkColor default clDefault;
    property TextColor: TColor read FTextColor write SetTextColor default clDefault;
    property Title: WideString read FTitle write SetTitle;
    property Text: WideString read FText write SetText;
    property AutoHide: Boolean read FAutoHide write SetAutoHide default True;
    property CenterTail: Boolean read FCenterTail write SetCenterTail;
  end;
                  
const
  TOOLTIPS_CLASS = 'tooltips_class32';

  TTS_ALWAYSTIP = 1;
  TTS_NOPREFIX = 2;
  TTS_NOANIMATE = $10;
  TTS_NOFADE = $20;
  TTS_BALLOON = $40;
  TTS_CLOSE = $80;

  TTF_IDISHWND = 1;
  TTF_RTLREADING = 4;
  TTF_CENTERTIP = $0002;
  TTF_SUBCLASS = $0010;
  TTF_TRACK = $0020;
  TTF_ABSOLUTE = $0080;
  TTF_TRANSPARENT = $0100;
  TTF_DI_SETITEM = $8000;
  TTF_PARSELINKS = $1000;

  TTM_ACTIVATE = WM_USER + 1;
  TTM_SETDELAYTIME = WM_USER + 3;
  TTM_ADDTOOLA = WM_USER + 4;
  TTM_ADDTOOLW = WM_USER + 50;
  TTM_DELTOOLA = WM_USER + 5;
  TTM_DELTOOLW = WM_USER + 51;
  TTM_NEWTOOLRECTA = WM_USER + 6;
  TTM_NEWTOOLRECTW = WM_USER + 52;
  TTM_RELAYEVENT = WM_USER + 7;
  TTM_GETTOOLINFOA = WM_USER + 8;
  TTM_GETTOOLINFOW = WM_USER + 53;
  TTM_SETTOOLINFOA = WM_USER + 9;
  TTM_SETTOOLINFOW = WM_USER + 54;
  TTM_HITTESTA = WM_USER + 10;
  TTM_HITTESTW = WM_USER + 55;
  TTM_GETTEXTA = WM_USER + 11;
  TTM_GETTEXTW = WM_USER + 56;
  TTM_UPDATETIPTEXTA = WM_USER + 12;
  TTM_UPDATETIPTEXTW = WM_USER + 57;
  TTM_GETTOOLCOUNT = WM_USER + 13;
  TTM_ENUMTOOLSA = WM_USER + 14;
  TTM_ENUMTOOLSW = WM_USER + 58;
  TTM_GETCURRENTTOOLA = WM_USER + 15;
  TTM_GETCURRENTTOOLW = WM_USER + 59;
  TTM_WINDOWFROMPOINT = WM_USER + 16;
  TTM_TRACKACTIVATE = WM_USER + 17;
  TTM_TRACKPOSITION = WM_USER + 18;
  TTM_SETTIPBKCOLOR = WM_USER + 19;
  TTM_SETTIPTEXTCOLOR = WM_USER + 20;
  TTM_GETDELAYTIME = WM_USER + 21;
  TTM_GETTIPBKCOLOR = WM_USER + 22;
  TTM_GETTIPTEXTCOLOR = WM_USER + 23;
  TTM_SETMAXTIPWIDTH = WM_USER + 24;
  TTM_GETMAXTIPWIDTH = WM_USER + 25;
  TTM_SETMARGIN = WM_USER + 26;
  TTM_GETMARGIN = WM_USER + 27;
  TTM_POP = WM_USER + 28;
  TTM_UPDATE = WM_USER + 29;
  TTM_GETBUBBLESIZE = WM_USER + 30;
  TTM_ADJUSTRECT = WM_USER + 31;
  TTM_SETTITLEA = WM_USER + 32;
  TTM_SETTITLEW = WM_USER + 33;

implementation

{ TControlTooltip }

constructor TControlTooltip.Create(UnderWnd: THandle; const Title, Text: WideString);
begin
  FUnderWnd := UnderWnd;
  FTitle := Title;
  FText := Text;
  FAutoHide := True;
  FWnd := CreateWnd;

  FillChar(FInfo, SizeOf(FInfo), 0);
  FInfo.cbSize := SizeOf(FInfo);
  FInfo.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS or TTF_ABSOLUTE or TTF_TRACK;
  FInfo.hwnd := FUnderWnd;
  FInfo.lpszText := PWideChar(Text);
  Windows.GetClientRect(FUnderWnd, FInfo.rect);

  SendMessageW(FWnd, TTM_ADDTOOLW, 1, Integer(@FInfo));
end;
                 
destructor TControlTooltip.Destroy;
begin
  DestroyWindow(FWnd);
  inherited;
end;

function TControlTooltip.CreateWnd: THandle;
begin
  Result := CreateWindow(TOOLTIPS_CLASS, nil, WS_POPUP or TTS_NOPREFIX or TTS_BALLOON or TTS_ALWAYSTIP,
                         0, 0, 0, 0, FUnderWnd, 0, hInstance, nil);
  if Result = 0 then
    RaiseLastOSError;

  SetWindowPos(Result, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TControlTooltip.SetAutoHide(Value: Boolean);
begin
  FAutoHide := Value;
  SendMessageW(FWnd, TTM_TRACKACTIVATE, Integer(not Value), Integer(@FInfo));
end;

procedure TControlTooltip.SetBkColor(Value: TColor);
begin
  FBkColor := Value;
  if Value <> clDefault then
    SendMessageW(FWnd, TTM_SETTIPBKCOLOR, Value, 0);
end;

procedure TControlTooltip.SetTextColor(Value: TColor);
begin
  FTextColor := Value;
  if Value <> clDefault then
    SendMessageW(FWnd, TTM_SETTIPTEXTCOLOR, Value, 0);
end;

procedure TControlTooltip.SetIcon(Value: TToolTipIcon);
begin
  FIcon := Value;
  SendMessageW(FWnd, TTM_SETTITLEW, Ord(FIcon), Integer(FTitle));
end;

procedure TControlTooltip.SetText(const Value: WideString);
begin
  FText := Value;
  FInfo.lpszText := PWideChar(Value);
  SendMessageW(FWnd, TTM_UPDATETIPTEXTW, 0, Integer(@FInfo));
end;

procedure TControlTooltip.SetTitle(const Value: WideString);
begin
  FTitle := Value;
  SendMessageW(FWnd, TTM_SETTITLEW, Ord(FIcon), Integer(FTitle));
end;

procedure TControlTooltip.MoveTo(const Point: TPoint);
begin
  SendMessageW(FWnd, TTM_TRACKPOSITION, 0, MakeLong(Point.X, Point.Y));
end;

procedure TControlTooltip.MoveTo(Control: TControl);
begin
  with Control.ClientRect do
    MoveTo(Control.ClientToScreen( Point((Right - Left) div 2 + Left, Bottom) ));
end;

procedure TControlTooltip.SetCenterTail(const Value: Boolean);
begin
  FCenterTail := Value;
  if Value then
    FInfo.uFlags := FInfo.uFlags or TTF_CENTERTIP
  else
    FInfo.uFlags := FInfo.uFlags and not TTF_CENTERTIP;
  UpdateInfo;
end;

procedure TControlTooltip.UpdateInfo;
begin
  SendMessageW(FWnd, TTM_SETTOOLINFOW, 0, Integer(@FInfo));
end;

end.
