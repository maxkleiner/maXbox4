(***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Async Professional
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1991-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{*                   ADSELCOM.PAS 4.06                   *}
{*********************************************************}
{* Port selection dialog, IsPortAvailable method         *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

{Options required for this unit}
{$G+,X+,F+,J+}
{$C MOVEABLE,DEMANDLOAD,DISCARDABLE}

unit AdSelCom;
	{-Com port selection dialog}
interface

uses
  WinTypes,
  WinProcs,
  SysUtils,
  Classes,
  Messages,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Buttons,
  OoMisc,
  AwUser,
  AwWin32;

type
  TComSelectForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    OkBtn: TBitBtn;
    AbortBtn: TBitBtn;
    Bevel1: TBevel;
    PortsComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
  public
    function SelectedCom : String;
    function SelectedComNum : Word;
  end;

function IsPortAvailable(ComNum : Cardinal) : Boolean;

const
  {True to create a dispatcher to validate the port; false to open the
   port using direct API calls}
  UseDispatcherForAvail : Boolean = True;
  {True to return True even if the port is in use; False to return False
   if the port is in use}
  ShowPortsInUse : Boolean = True;                                  
implementation

{$R *.DFM}

function IsPortAvailable(ComNum : Cardinal) : Boolean;
  function MakeComName(const Dest : PChar; const ComNum : Cardinal) : PChar;
    {-Return a string like 'COMXX'}
  begin
    {$IFDEF WIN32}
    StrFmt(Dest,'\\.\COM%d',[ComNum]);
    {$ELSE}
    StrFmt(Dest,'COM%d',[ComNum]);
    {$ENDIF}
    MakeComName := Dest;
  end;

var
  ComName : array[0..12] of Char;
  Res : Integer;
  DeviceLayer : TApdBaseDispatcher;
begin
  DeviceLayer := nil;
  try
    if (ComNum = 0) then
      Result := False
    else begin
      if UseDispatcherForAvail then begin
        {$IFDEF Win32}
        DeviceLayer  := TApdWin32Dispatcher.Create(nil);
        {$ELSE}
        DeviceLayer := TApdCommDispatcher.Create(nil);
        {$ENDIF}
        Res := DeviceLayer.OpenCom(MakeComName(ComName,ComNum), 64, 64);
        if (Res < 0) then
          if ShowPortsInUse then
            {$IFDEF Win32}
            Result := GetLastError = DWORD(Abs(ecAccessDenied))
            {$ELSE}
            Result := Res = ie_Open
            {$ENDIF}
          else
            Result := False
        else begin
          Result := True;
          DeviceLayer.CloseCom;
        end;
      end else begin
        {$IFDEF Win32}
        Res := CreateFile(MakeComName(ComName, ComNum),
                 GENERIC_READ or GENERIC_WRITE,
                 0,
                 nil,
                 OPEN_EXISTING,
                 FILE_ATTRIBUTE_NORMAL or
                 FILE_FLAG_OVERLAPPED,
                 0);
        {$ELSE}
        Res := OpenComm(MakeComName(ComName, ComNum), 64, 64);
        {$ENDIF}

        if Res > 0 then begin
          {$IFDEF Win32}
          CloseHandle(Res);
          {$ELSE}
          CloseComm(Res);
          {$ENDIF}
          Result := True;
        end else begin
          if ShowPortsInUse then
            {$IFDEF Win32}
            Result := GetLastError = DWORD(Abs(ecAccessDenied))
            {$ELSE}
            Result := Res = ie_Open
            {$ENDIF}
          else
            Result := False;
        end;
      end;
    end;
  finally
    if UseDispatcherForAvail then                                  
      DeviceLayer.Free;
  end;
end;

procedure TComSelectForm.FormCreate(Sender: TObject);
var
  I : Integer;
  S : string;
begin
  for I := 1 to MaxComHandles do
    if IsPortAvailable(I) then begin
      S := Format('COM%d', [I]);
      PortsComboBox.Items.Add(S);
    end;
  PortsComboBox.ItemIndex := 0;
end;

function TComSelectForm.SelectedCom : String;
begin
  Result := PortsComboBox.Items[PortsComboBox.ItemIndex];
end;

function TComSelectForm.SelectedComNum : Word;
var
  S : String;
begin
  S := PortsComboBox.Items[PortsComboBox.ItemIndex];
  S := Copy(S, 4, 255);
  Result := StrToInt(S);
end;

end.

