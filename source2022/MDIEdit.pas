unit MDIEdit;

//to mX4 NO MDI just MIDI

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls, ToolWin, ImgList, StdActns, ExtActns, ListActns, ActnList;

type
  TEditForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    N3: TMenuItem;
    Selectall1: TMenuItem;
    Character1: TMenuItem;
    Left1: TMenuItem;
    Right1: TMenuItem;
    Center1: TMenuItem;
    N4: TMenuItem;
    Wordwrap1: TMenuItem;
    N5: TMenuItem;
    Font1: TMenuItem;
    Editor: TRichEdit;
    PopupMenu1: TPopupMenu;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    SaveFileDialog: TSaveDialog;
    FontDialog1: TFontDialog;
    Printersetup1: TMenuItem;
    Close1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
    OpenFileDialog: TOpenDialog;
    ActionList1: TActionList;
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
    FileExit1: TFileExit;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    FileRun1: TFileRun;
    StaticListAction1: TStaticListAction;
    DeleteAction: TAction;
    AddAction: TAction;
    ClearAction: TAction;
    ActiveAction: TAction;
    SetIndexAction: TAction;
    FileOpen1: TFileOpen;
    BrowseURL1: TBrowseURL;
    DownLoadURL1: TDownLoadURL;
    SendMail1: TSendMail;
    ColorSelect1: TColorSelect;
    OpenPicture1: TOpenPicture;
    FontEdit1: TFontEdit;
    PreviousTab1: TPreviousTab;
    NextTab1: TNextTab;
    ListControlCopySelection1: TListControlCopySelection;
    ListControlDeleteSelection1: TListControlDeleteSelection;
    ListControlSelectAll1: TListControlSelectAll;
    ListControlClearSelection1: TListControlClearSelection;
    ListControlMoveSelection1: TListControlMoveSelection;
    ShortCutAction: TAction;
    AddShortCut: TAction;
    FileOpenWith1: TFileOpenWith;
    FileSaveAs1: TFileSaveAs;
    FilePrintSetup1: TFilePrintSetup;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure AlignClick(Sender: TObject);
    procedure Wordwrap1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Printersetup1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SearchFind1FindDialogFind(Sender: TObject);
  private
    { Private declarations }
    PathName: string;
  public
    { Public declarations }
    procedure Open(const AFileName: string);
  end;

var
  EditForm: TEditForm;

const
  DefaultFileName = 'mX4Untitled';

implementation

uses Clipbrd, Printers; //, MDIFrame;

{$R *.dfm}

procedure TEditForm.Exit1Click(Sender: TObject);
begin
  //FrameForm.Exit1Click(Sender);
    //Exit1Click(Sender);

  end;

procedure TEditForm.New1Click(Sender: TObject);
begin
  //FrameForm.New1Click(Sender);
     //New1Click(Sender);
   //PathName := DefaultFileName;
   end;

procedure TEditForm.Open1Click(Sender: TObject);
begin
  //FrameForm.Open1Click(Sender);
    //Open1Click(Sender);
if OpenFileDialog.Execute then
  //with TEditForm.Create(Self) do
    Open(OpenFileDialog.FileName);


  end;

procedure TEditForm.AlignClick(Sender: TObject);
begin
  Left1.Checked := False;
  Right1.Checked := False;
  Center1.Checked := False;
  with Sender as TMenuItem do Checked := True;
  with Editor.Paragraph do
    if Left1.Checked then
      Alignment := taLeftJustify
    else if Right1.Checked then
      Alignment := taRightJustify
    else if Center1.Checked then
      Alignment := taCenter;
end;

procedure TEditForm.Wordwrap1Click(Sender: TObject);
begin
  with Editor do begin
    WordWrap := not WordWrap; { toggle word wrapping }
    if WordWrap then
      ScrollBars := ssVertical
    else
      ScrollBars := ssBoth;
    WordWrap1.Checked := WordWrap; { set menu item check }
  end;
end;

procedure TEditForm.Cut1Click(Sender: TObject);
begin
  Editor.CutToClipboard;
end;

procedure TEditForm.Copy1Click(Sender: TObject);
begin
  Editor.CopyToClipboard;
end;

procedure TEditForm.Paste1Click(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TEditForm.SearchFind1FindDialogFind(Sender: TObject);
begin
  editor.SelText;
end;

procedure TEditForm.Selectall1Click(Sender: TObject);
begin
  Editor.SelectAll;
end;

procedure TEditForm.Delete1Click(Sender: TObject);
begin
  Editor.ClearSelection;
end;

procedure TEditForm.Edit1Click(Sender: TObject);
var
  HasSelection: Boolean;
begin
  Paste1.Enabled := Clipboard.HasFormat(CF_TEXT);
  Paste2.Enabled := Paste1.Enabled;
  HasSelection := Editor.SelLength > 0;
  Cut1.Enabled := HasSelection;
  Cut2.Enabled := HasSelection;
  Copy1.Enabled := HasSelection;
  Copy2.Enabled := HasSelection;
  Delete1.Enabled := HasSelection;
end;

procedure TEditForm.Open(const AFileName: string);
begin
  PathName := AFileName;
  Caption := 'mX4 RichEdit: ' +ExtractFileName(AFileName);
  with Editor do begin
    Lines.LoadFromFile(PathName);
    SelStart := 0;
    Modified := False;
  end;
end;

procedure TEditForm.Saveas1Click(Sender: TObject);
begin
  SaveFileDialog.FileName := PathName;
  if SaveFileDialog.Execute then begin
    PathName := SaveFileDialog.FileName;
    Caption := ExtractFileName(PathName);
    Save1Click(Sender);
  end;
end;

procedure TEditForm.Save1Click(Sender: TObject);
begin
  if PathName = DefaultFileName then
    SaveAs1Click(Sender)
  else begin
    Editor.Lines.SaveToFile(PathName);
    Editor.Modified := False;
  end;
end;

procedure TEditForm.Font1Click(Sender: TObject);
begin
  FontDialog1.Font := Editor.Font;
  if FontDialog1.Execute then
    Editor.SelAttributes.Assign(FontDialog1.Font);
end;

procedure TEditForm.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TEditForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  //Close;
end;

procedure TEditForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
const
  SWarningText = 'Save changes to %s?';
begin
  if Editor.Modified then begin
    case MessageDlg(Format(SWarningText, [PathName]), mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) of
      idYes: Save1Click(Self);
      idCancel: CanClose := False;
    end;
  end;
end;

procedure TEditForm.FormCreate(Sender: TObject);
begin
  PathName := DefaultFileName;
 //Application.CreateForm(TEditForm, EditForm);
  with Editor do begin
    Font.Size:= 30;
    font.name:= 'Arial';
    font.Color:= clpurple;
    Lines.Add('/////');
    Lines.Add('Welcome to maXtex, type some words of wisdom...');
    SelStart := 0;
    Modified := False;
  end;
end;

procedure TEditForm.Printersetup1Click(Sender: TObject);
begin
  PrinterSetupDialog1.Execute;
end;

procedure TEditForm.Print1Click(Sender: TObject);
begin
  if PrintDialog1.Execute then
    Editor.Print(PathName);
end;

end.
