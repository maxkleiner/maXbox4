{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvConnectNetwork.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is SÈbastien Buysse [sbuysse att buypin dott com]
Portions created by SÈbastien Buysse are Copyright (C) 2001 SÈbastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck att bigfoot dott com].

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.delphi-jedi.org

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvConnectNetwork.pas 12461 2009-08-14 17:21:33Z obones $

unit JvConnectNetwork;

{$I jvcl.inc}
{$I windowsonly.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Windows, Dialogs,
  JvBaseDlg;

type
  TJvConnectNetwork = class(TCommonDialog)
  published
    function Execute: Boolean; override;
  end;

  TJvDisconnectNetwork = class(TCommonDialog)
  published
    function Execute: Boolean; override;
  end;

  TJvNetworkConnect = class(TCommonDialog)
  private
    FConnect: Boolean;
  published
    property Connect: Boolean read FConnect write FConnect;
    function Execute: Boolean; override;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_40_PREPARATION/run/JvConnectNetwork.pas $';
    Revision: '$Revision: 12461 $';
    Date: '$Date: 2009-08-14 19:21:33 +0200 (ven., 14 ao√ªt 2009) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation


function TJvConnectNetwork.Execute: Boolean;
begin
  Result := WNetConnectionDialog(GetForegroundWindow, RESOURCETYPE_DISK) = NO_ERROR;
end;

function TJvDisconnectNetwork.Execute: Boolean;
begin
  Result := WNetDisconnectDialog(GetForegroundWindow, RESOURCETYPE_DISK) = NO_ERROR;
end;

function TJvNetworkConnect.Execute: Boolean;
begin
  if FConnect then
    Result := WNetConnectionDialog(GetForegroundWindow, RESOURCETYPE_DISK) = NO_ERROR
  else
    Result := WNetDisconnectDialog(GetForegroundWindow, RESOURCETYPE_DISK) = NO_ERROR;
end;

(*{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING} *)

end.
