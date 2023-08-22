{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: ConfirmReplDlg.pas, released 2005-06-23.

The Original Code is part of the FindReplDemo project, written by
Juergen Rathlev for the SynEdit component suite.
All Rights Reserved.

Contributors to the SynEdit project are listed in the Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

Known Issues:

Description:
  Confirm dialog for replace with prompt
-------------------------------------------------------------------------------}

unit ConfirmReplDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SynEdit;

type
  TConfirmReplDialog = class(TForm)
    btnYes: TButton;
    btnCancel: TButton;
    btnNo: TButton;
    btnAll: TButton;
    lblPrompt: TLabel;
    Image: TImage;
    Panel1: TPanel;
    procedure btnYesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
  private
    { Private-Deklarationen }
    fResult : TSynReplaceAction;
  public
    { Public-Deklarationen }
    function Execute (Apos : TPoint; APrompt : string) : TSynReplaceAction;
  end;

var
  ConfirmReplDialog: TConfirmReplDialog;

implementation

{$R *.dfm}

procedure TConfirmReplDialog.FormCreate(Sender: TObject);
begin
  fResult:=raCancel;
  end;

function TConfirmReplDialog.Execute (Apos : TPoint; APrompt : string) : TSynReplaceAction;
begin
  with APos do begin
    Left:=x; Top:=y;
    end;
  lblPrompt.Caption:=APrompt;
  if ShowModal=mrOK then Result:=fResult
  else Result:=raCancel;
  end;

procedure TConfirmReplDialog.btnYesClick(Sender: TObject);
begin
  fResult:=raReplace;
  ModalResult:=mrOK;
  end;

procedure TConfirmReplDialog.btnNoClick(Sender: TObject);
begin
  fResult:=raSkip;
  ModalResult:=mrOK;
  end;

procedure TConfirmReplDialog.btnAllClick(Sender: TObject);
begin
  fResult:=raReplaceAll;
  ModalResult:=mrOK;
  end;

end.
