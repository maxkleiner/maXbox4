{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: FindReplDlg.pas, released 2005-06-23.

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
  Dialog to set texts and options for find and replace
  - Find and replace are combined in one dialog
  - The dialog window remains staying on top of form
  - The find text follows the cursor in the edit text
  - The history of find and replace texts can be saved to an ini file
    (use LoadFromIni to load th history list and to initiate automatic
    saving on destroy event)
  - Use ConfirmReplDlg for prompt on replace    
-------------------------------------------------------------------------------}

unit FindReplDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SynEditTypes, IniFiles;

type
  TFindReplDialog = class(TForm)
    btnSearch: TButton;
    CancelBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    pnlSearch: TPanel;
    cbxSearch: TComboBox;
    pnlReplace: TPanel;
    cbxReplace: TComboBox;
    GroupBox1: TGroupBox;
    rgpDirection: TRadioGroup;
    rgpStart: TRadioGroup;
    cbCase: TCheckBox;
    cbWord: TCheckBox;
    cbConfirm: TCheckBox;
    rgpRange: TRadioGroup;
    pnlControls: TPanel;
    btnRepeat: TButton;
    btnReplAll: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnRepeatClick(Sender: TObject);
    procedure btnReplAllClick(Sender: TObject);
    procedure cbxSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCaseClick(Sender: TObject);
    procedure cbWordClick(Sender: TObject);
    procedure rgpRangeClick(Sender: TObject);
    procedure rgpDirectionClick(Sender: TObject);
    procedure rgpStartClick(Sender: TObject);
    procedure cbConfirmClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure cbxSearchExit(Sender: TObject);
    procedure cbxSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    fIniFileName : string;
    fSearching,
    fFromCursor,
    fRepeat,
    fReplace     : boolean;
    fOptions     : TSynSearchOptions;
    fOnFind      : TNotifyEvent;
    fOnReplace   : TNotifyEvent;
    procedure LoadHistory (AIniFile : TIniFile; ASection : string; ACombo   : TComboBox);
    procedure SaveHistory (AIniFile : TIniFile; ASection : string; ACombo   : TComboBox);
    procedure EnableButtons (AEnabled : boolean);
    function GetSearch : string;
    procedure SetSearch (Value : string);
    function GetReplace : string;
    procedure SetReplace (Value : string);
    function GetOptions : TSynSearchOptions;
    procedure SetOptions (Value : TSynSearchOptions);
    procedure AddToHistory (ACombo: TComboBox);
  public
    { Public-Deklarationen }
    procedure LoadFromIni (AIniName : string);
    function Execute (AReplace : boolean) : boolean;
  published
    property FindText : string read GetSearch write SetSearch;
    property ReplaceText : string read GetReplace write SetReplace;
    property Searching : boolean read fSearching;
    property Options : TSynSearchOptions read GetOptions write SetOptions;
    property OnFind: TNotifyEvent read FOnFind write FOnFind;
    property OnReplace: TNotifyEvent read FOnReplace write FOnReplace;
  end;

var
  FindReplDialog: TFindReplDialog;

implementation
  uses fmain;

{$R *.dfm}

resourcestring
  rsFindText = 'Search for Pascal Text';
  rsReplText = 'Replace text';
  rsFind = 'Search';
  rsRepl = 'Replace';

const
  defOptions = [ssoPrompt];
  MaxHist = 20;

  DlgSect  = 'FindReplaceDialog';
  FindSect = 'Find';
  ReplSect = 'Replace';
  iniHist = 'Text';
  iniLeft = 'Left';
  iniTop  = 'Top';


procedure TFindReplDialog.FormCreate(Sender: TObject);
begin
  Options:=defOptions;
  fSearching:=false;
  fRepeat:=false;
  fReplace:=false;
  fFromCursor:=true;
  fIniFileName:='';
  end;

procedure TFindReplDialog.FormDestroy(Sender: TObject);
var
 IniFile : TIniFile;
begin
  if fIniFilename<>'' then begin
    IniFile:=TIniFile.Create(fIniFilename);
    SaveHistory (IniFile,FindSect,cbxSearch);
    SaveHistory (IniFile,ReplSect,cbxReplace);
    with IniFile do begin
      WriteInteger(DlgSect,iniLeft,Left);
      WriteInteger(DlgSect,iniTop,Top);
      Free;
      end;
    end;
  end;

procedure TFindReplDialog.FormActivate(Sender: TObject);
begin
  fSearching:=true;
  ActiveControl:=cbxSearch;
  //if Visible then btnSearch.SetFocus;
  //ActiveControl:=btnSearch;
end;

procedure TFindReplDialog.FormDeactivate(Sender: TObject);
begin
  fSearching:=false;
  end;

{ ---------------------------------------------------------------- }
procedure TFindReplDialog.LoadFromIni (AIniName : string);
var
 IniFile : TIniFile;
begin
  fIniFilename:=AIniName;
  IniFile:=TIniFile.Create(AIniName);
  LoadHistory (IniFile,FindSect,cbxSearch);
  LoadHistory (IniFile,ReplSect,cbxReplace);
  with IniFile do begin
    Left:=ReadInteger(DlgSect,iniLeft,Left);
    Top:=ReadInteger(DlgSect,iniTop,Top);
    Free;
    end;
  end;

{ ---------------------------------------------------------------- }
procedure TFindReplDialog.LoadHistory (AIniFile : TIniFile;
                                       ASection : string;
                                       ACombo   : TComboBox);
var
  i : integer;
  s : string;
begin
  with AIniFile do begin
    if SectionExists(ASection) then with ACombo do begin
      Clear;
      for i:=0 to MaxHist-1 do begin
        s:=ReadString(ASection,iniHist+IntToStr(i),'');
        if s<>'' then Items.Add(s);
        end;
      end;
    end;
  end;

procedure TFindReplDialog.SaveHistory (AIniFile : TIniFile;
                                       ASection : string;
                                       ACombo   : TComboBox);
var
  i : integer;
begin
  with AIniFile do begin
    EraseSection (ASection);
    with ACombo.Items do for i:=0 to Count-1 do
      WriteString(ASection,iniHist+IntToStr(i),Strings[i]);
    end;
  end;

procedure TFindReplDialog.AddToHistory (ACombo: TComboBox);
var
  n : integer;
  s : string;
begin
  with ACombo do begin
    s:=Text;
    with Items do begin
      n:=IndexOf(s);
      if n<0 then begin
        if Count>=MaxHist then Delete (Count-1);
        Insert (0,s);
        end
      end;
    end;
  end;

{ ---------------------------------------------------------------- }
procedure TFindReplDialog.EnableButtons (AEnabled : boolean);
begin
  btnSearch.Enabled:=AEnabled;
  btnRepeat.Enabled:=AEnabled;
  btnReplAll.Enabled:=AEnabled;
  end;

{ ---------------------------------------------------------------- }
function TFindReplDialog.GetSearch : string;
begin
  Result:=cbxSearch.Text;
    //btnSearch.SetFocus;

  end;

procedure TFindReplDialog.SetSearch (Value : string);
begin
  with cbxSearch do begin
    Text:=Value;
    EnableButtons (length(Text)>0);
    end;
  end;

function TFindReplDialog.GetReplace : string;
begin
  Result:=cbxReplace.Text;
  end;

procedure TFindReplDialog.SetReplace (Value : string);
begin
  cbxReplace.Text:=Value;
  end;

function TFindReplDialog.GetOptions : TSynSearchOptions;
begin
  Result:=fOptions;
  end;

procedure TFindReplDialog.SetOptions (Value : TSynSearchOptions);
begin
  fOptions:=Value;
  cbConfirm.Checked:=ssoPrompt in fOptions;
  cbCase.Checked:=ssoMatchCase in fOptions;
  cbWord.Checked:=ssoWholeWord in fOptions;
  with rgpRange do if ssoSelectedOnly in fOptions then ItemIndex:=1 else ItemIndex:=0;
  with rgpDirection do if ssoBackwards in fOptions then ItemIndex:=1 else ItemIndex:=0;
  with rgpStart do if ssoEntireScope in fOptions then ItemIndex:=1 else ItemIndex:=0;
  end;

procedure TFindReplDialog.cbxSearchChange(Sender: TObject);
begin
  with cbxSearch do EnableButtons (length(Text)>0);
  //btnSearch.SetFocus;

  end;

procedure TFindReplDialog.cbxSearchExit(Sender: TObject);
begin
    // btnSearch.SetFocus;
end;

procedure TFindReplDialog.cbxSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_REturn then begin
       btnSearch.SetFocus;
      //  maxform1.FindNextText(sender);    //must be public
       maxform1.SearchNext1Click(self);    //is public
      //  btnSearch.SetFocus;
  end;
  //cbxSearch.onkeydown:= NIL;
end;


{ ---------------------------------------------------------------- }
procedure TFindReplDialog.cbCaseClick(Sender: TObject);
begin
  if cbCase.Checked then Include(fOptions,ssoMatchCase)
  else Exclude(fOptions,ssoMatchCase);
  end;

procedure TFindReplDialog.cbWordClick(Sender: TObject);
begin
  if cbWord.Checked then Include(fOptions,ssoWholeWord)
  else Exclude(fOptions,ssoWholeWord);
  end;

procedure TFindReplDialog.rgpRangeClick(Sender: TObject);
begin
  if rgpRange.ItemIndex=1 then Include(fOptions,ssoSelectedOnly)
  else Exclude(fOptions,ssoSelectedOnly);
  end;

procedure TFindReplDialog.rgpDirectionClick(Sender: TObject);
begin
  if rgpDirection.ItemIndex=1 then Include(fOptions,ssoBackwards)
  else Exclude(fOptions,ssoBackwards);
  end;

procedure TFindReplDialog.rgpStartClick(Sender: TObject);
begin
  fFromCursor:=rgpStart.ItemIndex=0;
  if rgpStart.ItemIndex=1 then Include(fOptions,ssoEntireScope)
  else begin
    Exclude(fOptions,ssoEntireScope);
    btnRepeat.Visible:=false;
    end;
  end;

procedure TFindReplDialog.cbConfirmClick(Sender: TObject);
begin
  if cbConfirm.Checked then Include(fOptions,ssoPrompt)
  else Exclude(fOptions,ssoPrompt);
  end;

{ ---------------------------------------------------------------- }
function TFindReplDialog.Execute (AReplace : boolean) : boolean;
begin
  fReplace:=AReplace;
  if AReplace then begin
    Caption:=rsReplText;
    pnlReplace.Show;
    btnReplAll.Show;
    btnRepeat.Show;
    pnlControls.Top:=90;
    ClientHeight:=280;
    btnSearch.Caption:=rsRepl;
    Include(fOptions,ssoReplace);
    end
  else begin
    Caption:=rsFindText;
    pnlReplace.Hide;
    btnReplAll.Hide;
    btnRepeat.Hide;
    pnlControls.Top:=50;
    ClientHeight:=240;
    btnSearch.Caption:=rsFind;
    Exclude(fOptions,ssoReplace);
    //btnSearch.SetFocus;
    end;
  Exclude(fOptions,ssoReplaceAll);
  fRepeat:=false;
  with cbxSearch do EnableButtons (length(Text)>0);
  if Visible then BringToFront
  else Show;
  //btnSearch.SetFocus;
  Result:=true;
  end;

{ ---------------------------------------------------------------- }
procedure TFindReplDialog.CancelBtnClick(Sender: TObject);
begin
  Exclude(fOptions,ssoReplaceAll);
  Close;
  end;

// search or replace
procedure TFindReplDialog.btnSearchClick(Sender: TObject);
begin
  Exclude(fOptions,ssoReplaceAll);
  AddToHistory(cbxSearch);
  if fReplace then begin
    AddToHistory(cbxReplace);
    Include(fOptions,ssoReplace);
    if fRepeat then begin
      if ssoBackwards in fOptions then Exclude(fOptions,ssoBackwards)
      else Include(fOptions,ssoBackwards);
      end;
    if Assigned(FOnReplace) then FOnReplace(Self);
    if fRepeat then begin
      if ssoBackwards in fOptions then Exclude(fOptions,ssoBackwards)
      else Include(fOptions,ssoBackwards);
      end;
    end
  else begin
    if rgpStart.ItemIndex=1 then Include(fOptions,ssoEntireScope);
    if Assigned(FOnFind) then FOnFind(Self);
    if rgpStart.ItemIndex=1 then begin
      btnRepeat.Visible:=true;
      end;
    end;
  if rgpStart.ItemIndex=1 then Exclude(fOptions,ssoEntireScope);
  fRepeat:=false;
  ActiveControl:=cbxSearch;
  end;

// continue search
procedure TFindReplDialog.btnRepeatClick(Sender: TObject);
begin
  if fReplace then begin
    AddToHistory(cbxSearch);
    Exclude(fOptions,ssoReplace);
    Exclude(fOptions,ssoReplaceAll);
    if Assigned(FOnFind) then FOnFind(Self);
    fRepeat:=true;
    end
  else begin
    if Assigned(FOnFind) then FOnFind(Self);
    end;
  ActiveControl:=cbxSearch;
  end;

// replace all
procedure TFindReplDialog.btnReplAllClick(Sender: TObject);
begin
  AddToHistory(cbxSearch);
  AddToHistory(cbxReplace);
  Include(fOptions,ssoReplace);
  Include(fOptions,ssoReplaceAll);
  fRepeat:=false;
  if Assigned(FOnFind) then FOnReplace(Self);
  ActiveControl:=cbxSearch;
  end;

end.
