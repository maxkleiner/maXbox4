unit actionMain2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdActns, ExtActns, ActnList, ImgList, ComCtrls, ToolWin,
  StdCtrls, Menus, Buttons, ExtCtrls, jpeg, ListActns;

type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    ImageList1: TImageList;
    RichEditBold1: TRichEditBold;
    RichEditItalic1: TRichEditItalic;
    RichEditUnderline1: TRichEditUnderline;
    RichEditStrikeOut1: TRichEditStrikeOut;
    RichEditBullets1: TRichEditBullets;
    RichEditAlignLeft1: TRichEditAlignLeft;
    RichEditAlignRight1: TRichEditAlignRight;
    RichEditAlignCenter1: TRichEditAlignCenter;
    SearchFind1: TSearchFind;
    SearchFindNext1: TSearchFindNext;
    SearchReplace1: TSearchReplace;
    SearchFindFirst1: TSearchFindFirst;
    GroupAction1: TAction;
    GroupAction2: TAction;
    GroupAction3: TAction;
    AutoCheckAction: TAction;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileExit1: TFileExit;
    Exit1: TMenuItem;
    Search1: TMenuItem;
    Find1: TMenuItem;
    FindFirst1: TMenuItem;
    FindNext1: TMenuItem;
    Replace1: TMenuItem;
    Edit1: TMenuItem;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    SelectAll1: TMenuItem;
    Undo1: TMenuItem;
    AutoCheck1: TMenuItem;
    GroupedAction11: TMenuItem;
    GroupedAction21: TMenuItem;
    GroupedAction31: TMenuItem;
    N1: TMenuItem;
    AutoCheckAction1: TMenuItem;
    FileRun1: TFileRun;
    Label1: TLabel;
    Run1: TMenuItem;
    N2: TMenuItem;
    FileOpen1: TFileOpen;
    Open1: TMenuItem;
    BrowseURL1: TBrowseURL;
    DownLoadURL1: TDownLoadURL;
    SendMail1: TSendMail;
    GroupedAction12: TMenuItem;
    BrowseURL2: TMenuItem;
    DownloadURL2: TMenuItem;
    SendMail2: TMenuItem;
    ColorSelect1: TColorSelect;
    Dialog1: TMenuItem;
    SelectColor1: TMenuItem;
    OpenPicture1: TOpenPicture;
    FontEdit1: TFontEdit;
    PreviousTab1: TPreviousTab;
    NextTab1: TNextTab;
    Button3: TBitBtn;
    Button4: TBitBtn;
    SelectFont1: TMenuItem;
    OpenPicture2: TMenuItem;
    PageControl2: TPageControl;
    ListTab: TTabSheet;
    AutoCheckTab: TTabSheet;
    DialogTab: TTabSheet;
    FormatTab: TTabSheet;
    EditTab: TTabSheet;
    SearchTab: TTabSheet;
    ToolBar2: TToolBar;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    Memo2: TMemo;
    Image1: TImage;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    Button2: TBitBtn;
    Button1: TBitBtn;
    ToolBar1: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    RichEdit1: TRichEdit;
    ToolBar3: TToolBar;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    Memo3: TMemo;
    ListBoxTab: TTabSheet;
    CheckBox2: TCheckBox;
    CheckBox1: TCheckBox;
    StaticListAction1: TStaticListAction;
    DeleteAction: TAction;
    AddAction: TAction;
    ClearAction: TAction;
    ActiveAction: TAction;
    SetIndexAction: TAction;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ListView1: TListView;
    ComboBoxEx1: TComboBoxEx;
    AddBtn: TBitBtn;
    AddEdit: TEdit;
    DeleteBtn: TBitBtn;
    DelEdit: TEdit;
    Button5: TBitBtn;
    IdxEdit: TEdit;
    Button6: TBitBtn;
    ActiveBtn: TBitBtn;
    GroupedActions11: TMenuItem;
    Previous1: TMenuItem;
    Next1: TMenuItem;
    ToolBar4: TToolBar;
    ToolButton15: TToolButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    ListControlCopySelection1: TListControlCopySelection;
    ListControlDeleteSelection1: TListControlDeleteSelection;
    ListControlSelectAll1: TListControlSelectAll;
    ListControlClearSelection1: TListControlClearSelection;
    ListControlMoveSelection1: TListControlMoveSelection;
    Label8: TLabel;
    Label9: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Label11: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    ShortCutTab: TTabSheet;
    Button7: TBitBtn;
    ShortCutAction: TAction;
    HotKey1: THotKey;
    Button8: TBitBtn;
    AddShortCut: TAction;
    Label12: TLabel;
    Label13: TLabel;
    ShortCutList: TListBox;
    Label14: TLabel;
    FileOpenWith1: TFileOpenWith;
    OpenWith1: TMenuItem;
    FileTab: TTabSheet;
    Label3: TLabel;
    Button9: TBitBtn;
    Button10: TBitBtn;
    FileSaveAs1: TFileSaveAs;
    FilePrintSetup1: TFilePrintSetup;
    N3: TMenuItem;
    PrintSetup1: TMenuItem;
    Memo1: TMemo;
    Button11: TBitBtn;
    Button12: TBitBtn;
    LabeledEdit1: TLabeledEdit;
    Button13: TBitBtn;
    procedure FileOpen1Accept(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ColorSelect1Accept(Sender: TObject);
    procedure OpenPicture1Accept(Sender: TObject);
    procedure FontEdit1Accept(Sender: TObject);
    procedure DeleteActionExecute(Sender: TObject);
    procedure AddActionExecute(Sender: TObject);
    procedure ClearActionExecute(Sender: TObject);
    procedure ActiveActionExecute(Sender: TObject);
    procedure SetIndexActionExecute(Sender: TObject);
    procedure ShortCutActionExecute(Sender: TObject);
    procedure AddShortCutExecute(Sender: TObject);
    procedure FileSaveAs1Accept(Sender: TObject);
    procedure SearchTabShow(Sender: TObject);
    procedure EditTabShow(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateShortCutList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FileOpen1Accept(Sender: TObject);
begin
  Label3.Caption := FileOpen1.Dialog.FileName;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FontEdit1.Dialog.Font.Assign(Font);
  // Make sure the following actions are enabled even though they don't do anything
  GroupAction1.DisableIfNoHandler := False;
  GroupAction2.DisableIfNoHandler := False;
  GroupAction3.DisableIfNoHandler := False;
  AutoCheckAction.DisableIfNoHandler := False;
  UpdateShortCutList;
end;

procedure TForm1.ColorSelect1Accept(Sender: TObject);
begin
  Color := ColorSelect1.Dialog.Color;
end;

procedure TForm1.OpenPicture1Accept(Sender: TObject);
begin
  Image1.Picture.LoadFromFile(OpenPicture1.Dialog.FileName);
end;

procedure TForm1.FontEdit1Accept(Sender: TObject);
begin
  Font.Assign(FontEdit1.Dialog.Font);
end;

procedure TForm1.DeleteActionExecute(Sender: TObject);
begin
  StaticListAction1.Items.Delete(StrToInt(DelEdit.Text));
end;

procedure TForm1.AddActionExecute(Sender: TObject);
begin
  with StaticListAction1.Items.Add do
    Caption := AddEdit.Text;
end;

procedure TForm1.ClearActionExecute(Sender: TObject);
begin
  StaticListAction1.Items.Clear;
end;

procedure TForm1.ActiveActionExecute(Sender: TObject);
begin
  StaticListAction1.Active := not StaticListAction1.Active;
  if StaticListAction1.Active then
    ActiveBtn.Caption := 'Set InActive'
  else
    ActiveBtn.Caption := 'Set Active';
end;

procedure TForm1.SetIndexActionExecute(Sender: TObject);
begin
  StaticListAction1.ItemIndex := StrToInt(IdxEdit.Text);
end;

procedure TForm1.ShortCutActionExecute(Sender: TObject);
begin
  ShowMessage('ShortCut action executed');
end;

procedure TForm1.UpdateShortCutList;
var
  I: Integer;
begin
  ShortCutList.Items.BeginUpdate;
  try
    ShortCutList.Items.Clear;
    ShortCutList.Items.Add(ShortCutToText(ShortCutAction.ShortCut));
    for I := 0 to ShortCutAction.SecondaryShortCuts.Count - 1 do
      ShortCutList.Items.Add(ShortCutToText(ShortCutAction.SecondaryShortCuts.ShortCuts[I]));
  finally
    ShortCutList.Items.EndUpdate;
  end;
end;

procedure TForm1.AddShortCutExecute(Sender: TObject);
begin
  ShortCutAction.SecondaryShortCuts.Add(ShortCutToText(HotKey1.HotKey));
  UpdateShortCutList;
end;

procedure TForm1.FileSaveAs1Accept(Sender: TObject);
begin
  Memo1.Lines.SaveToFile(FileSaveAs1.Dialog.FileName);
end;

procedure TForm1.SearchTabShow(Sender: TObject);
begin
  Memo2.SetFocus;
end;

procedure TForm1.EditTabShow(Sender: TObject);
begin
  Memo3.SetFocus;
end;

end.
