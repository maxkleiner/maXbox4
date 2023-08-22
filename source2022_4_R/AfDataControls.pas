{==============================================================================|
| Project : Delphree - AsyncFree                                 | 001.004.000 |
|==============================================================================|
| Content:  Data-aware controls                                                |
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

unit AfDataControls;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AfDataDispatcher;

type
  TAfDataEdit = class(TCustomEdit)
  private
    FDataLink: TAfDataDispatcherLink;
    function GetDispatcher: TAfCustomDataDispatcher;
    procedure SetDispatcher(const Value: TAfCustomDataDispatcher);
    procedure OnNotify(Sender: TObject; EventKind: TAfDispEventKind);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Dispatcher: TAfCustomDataDispatcher read GetDispatcher write SetDispatcher;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AsyncFree', [TAfDataEdit]);
end;

{ TAfDataEdit }

constructor TAfDataEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TAfDataDispatcherLink.Create;
  FDataLink.OnNotify := OnNotify;
end;

destructor TAfDataEdit.Destroy;
begin
  FDataLink.Free;
  inherited Destroy;
end;

function TAfDataEdit.GetDispatcher: TAfCustomDataDispatcher;
begin
  Result := FDataLink.Dispatcher;
end;

procedure TAfDataEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = Dispatcher) then
    Dispatcher := nil;
end;

procedure TAfDataEdit.OnNotify(Sender: TObject; EventKind: TAfDispEventKind);
begin

end;

procedure TAfDataEdit.SetDispatcher(const Value: TAfCustomDataDispatcher);
begin
  FDataLink.Dispatcher := Value;
end;

end.
