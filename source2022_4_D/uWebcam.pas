unit uWebcam;

interface

uses
  Windows, sysutils,jpeg,graphics,classes;

  //uMain;

const
//  WM_CAP_START = $400;
//  WM_CAP_DRIVER_CONNECT = WM_CAP_START + $a;
//  WM_CAP_DRIVER_DISCONNECT = WM_CAP_START + $b;
//  WM_CAP_EDIT_COPY = WM_CAP_START + $1e;
//  WM_CAP_GRAB_FRAME = WM_CAP_START + $3c;
//  WM_CAP_STOP = WM_CAP_START + $44;
//  WM_CAP_SAVEDIB = $0400 + 25;
  WM_CAP_START = $0400;
  WM_CAP_DRIVER_CONNECT = $0400 + 10;
  WM_CAP_DRIVER_DISCONNECT = $0400 + 11;
  WM_CAP_SAVEDIB = $0400 + 25;
  WM_CAP_GRAB_FRAME = $0400 + 60;
  WM_CAP_STOP = $0400 + 68;

var
  capturewindow:cardinal;
  libhandle:cardinal;
  CapGetDriverDescriptionA: function(DrvIndex:cardinal; Name:pansichar;NameLen:cardinal;Description:pansichar;DescLen:cardinal):boolean; stdcall;
  CapCreateCaptureWindowA: function(lpszWindowName: pchar; dwStyle: dword; x, y, nWidth, nHeight: word; ParentWin: dword; nId: word): dword; stdcall;
  function Connectwebcam(WebcamID:integer):boolean;
procedure CaptureWebCam(FilePath: String);
  procedure CloseWebcam();
procedure WebcamInit;
function WebcamList: TStringlist;

implementation

procedure WebcamInit;
begin
  LibHandle := LoadLibrary('avicap32.dll');
  CapGetDriverDescriptionA := GetProcAddress(LibHandle,'capGetDriverDescriptionA');
  CapCreateCaptureWindowA := GetProcAddress(LibHandle,'capCreateCaptureWindowA');
end;

function WebcamList: TStringlist;
var
  x:cardinal;
  names: string;
  Descriptions: string;
  //alist: TStringlist;
begin
  result:= TStringlist.create;
  for x := 0 to 9 do begin
    setlength(Names,256);
    setlength(Descriptions,256);
    if not capGetDriverDescriptionA(x,pchar(Names),256,pchar(Descriptions),256) then continue;
    if length(Names) > 0 then
      result.Add(inttostr(x)+' '+names);
    end;
end;

function Connectwebcam(WebcamID:integer):boolean;
begin
  if CaptureWindow <> 0 then begin
    SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
    SendMessage(CaptureWindow, $0010, 0, 0);
    CaptureWindow := 0;
  end;
  CaptureWindow := capCreateCaptureWindowA('CaptureWindow', WS_CHILD and WS_VISIBLE, 0, 0, 0, 0, GetDesktopWindow, 0);
  if SendMessage(CaptureWindow, WM_CAP_DRIVER_CONNECT, WebcamID, 0) <> 1 then begin
    SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
    SendMessage(CaptureWindow, $0010, 0, 0);
    CaptureWindow := 0;
    result := false;
  end else begin
    result := true;
  end;
end;

procedure CloseWebcam();
begin
  SendMessage(CaptureWindow, WM_CAP_DRIVER_DISCONNECT, 0, 0);
  SendMessage(CaptureWindow, $0010, 0, 0);
  CaptureWindow := 0;
end;

procedure CaptureWebCam(FilePath: String);
begin
  if CaptureWindow <> 0 then begin
  SendMessage(CaptureWindow, WM_CAP_GRAB_FRAME, 0, 0);
  SendMessage(CaptureWindow, WM_CAP_SAVEDIB, 0, longint(pchar(FilePath)));
  end;
end;



end.
