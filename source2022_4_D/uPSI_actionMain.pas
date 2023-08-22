unit uPSI_actionMain;
{
   form prototype lib
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_actionMain = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
procedure SIRegister_actionMain(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_actionMain(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Variants
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdActns
  ,ExtActns
  ,ActnList
  ,ImgList
  ,ComCtrls
  ,ToolWin
  ,StdCtrls
  ,Menus
  ,Buttons
  ,ExtCtrls
  ,jpeg
  ,ListActns
  ,actionMain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_actionMain]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TActionForm') do begin
    RegisterProperty('ActionList1', 'TActionList', iptrw);
    RegisterProperty('ImageList1', 'TImageList', iptrw);
    RegisterProperty('RichEditBold1', 'TRichEditBold', iptrw);
    RegisterProperty('RichEditItalic1', 'TRichEditItalic', iptrw);
    RegisterProperty('RichEditUnderline1', 'TRichEditUnderline', iptrw);
    RegisterProperty('RichEditStrikeOut1', 'TRichEditStrikeOut', iptrw);
    RegisterProperty('RichEditBullets1', 'TRichEditBullets', iptrw);
    RegisterProperty('RichEditAlignLeft1', 'TRichEditAlignLeft', iptrw);
    RegisterProperty('RichEditAlignRight1', 'TRichEditAlignRight', iptrw);
    RegisterProperty('RichEditAlignCenter1', 'TRichEditAlignCenter', iptrw);
    RegisterProperty('SearchFind1', 'TSearchFind', iptrw);
    RegisterProperty('SearchFindNext1', 'TSearchFindNext', iptrw);
    RegisterProperty('SearchReplace1', 'TSearchReplace', iptrw);
    RegisterProperty('SearchFindFirst1', 'TSearchFindFirst', iptrw);
    RegisterProperty('GroupAction1', 'TAction', iptrw);
    RegisterProperty('GroupAction2', 'TAction', iptrw);
    RegisterProperty('GroupAction3', 'TAction', iptrw);
    RegisterProperty('AutoCheckAction', 'TAction', iptrw);
    RegisterProperty('StatusBar1', 'TStatusBar', iptrw);
    RegisterProperty('MainMenu1', 'TMainMenu', iptrw);
    RegisterProperty('File1', 'TMenuItem', iptrw);
    RegisterProperty('FileExit1', 'TFileExit', iptrw);
    RegisterProperty('Exit1', 'TMenuItem', iptrw);
    RegisterProperty('Search1', 'TMenuItem', iptrw);
    RegisterProperty('Find1', 'TMenuItem', iptrw);
    RegisterProperty('FindFirst1', 'TMenuItem', iptrw);
    RegisterProperty('FindNext1', 'TMenuItem', iptrw);
    RegisterProperty('Replace1', 'TMenuItem', iptrw);
    RegisterProperty('Edit1', 'TMenuItem', iptrw);
    RegisterProperty('EditCut1', 'TEditCut', iptrw);
    RegisterProperty('EditCopy1', 'TEditCopy', iptrw);
    RegisterProperty('EditPaste1', 'TEditPaste', iptrw);
    RegisterProperty('EditSelectAll1', 'TEditSelectAll', iptrw);
    RegisterProperty('EditUndo1', 'TEditUndo', iptrw);
    RegisterProperty('EditDelete1', 'TEditDelete', iptrw);
    RegisterProperty('Cut1', 'TMenuItem', iptrw);
    RegisterProperty('Copy1', 'TMenuItem', iptrw);
    RegisterProperty('Paste1', 'TMenuItem', iptrw);
    RegisterProperty('Delete1', 'TMenuItem', iptrw);
    RegisterProperty('SelectAll1', 'TMenuItem', iptrw);
    RegisterProperty('Undo1', 'TMenuItem', iptrw);
    RegisterProperty('AutoCheck1', 'TMenuItem', iptrw);
    RegisterProperty('GroupedAction11', 'TMenuItem', iptrw);
    RegisterProperty('GroupedAction21', 'TMenuItem', iptrw);
    RegisterProperty('GroupedAction31', 'TMenuItem', iptrw);
    RegisterProperty('N1', 'TMenuItem', iptrw);
    RegisterProperty('AutoCheckAction1', 'TMenuItem', iptrw);
    RegisterProperty('FileRun1', 'TFileRun', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Run1', 'TMenuItem', iptrw);
    RegisterProperty('N2', 'TMenuItem', iptrw);
    RegisterProperty('FileOpen1', 'TFileOpen', iptrw);
    RegisterProperty('Open1', 'TMenuItem', iptrw);
    RegisterProperty('BrowseURL1', 'TBrowseURL', iptrw);
    RegisterProperty('DownLoadURL1', 'TDownLoadURL', iptrw);
    RegisterProperty('SendMail1', 'TSendMail', iptrw);
    RegisterProperty('GroupedAction12', 'TMenuItem', iptrw);
    RegisterProperty('BrowseURL2', 'TMenuItem', iptrw);
    RegisterProperty('DownloadURL2', 'TMenuItem', iptrw);
    RegisterProperty('SendMail2', 'TMenuItem', iptrw);
    RegisterProperty('ColorSelect1', 'TColorSelect', iptrw);
    RegisterProperty('Dialog1', 'TMenuItem', iptrw);
    RegisterProperty('SelectColor1', 'TMenuItem', iptrw);
    RegisterProperty('OpenPicture1', 'TOpenPicture', iptrw);
    RegisterProperty('FontEdit1', 'TFontEdit', iptrw);
    RegisterProperty('PreviousTab1', 'TPreviousTab', iptrw);
    RegisterProperty('NextTab1', 'TNextTab', iptrw);
    RegisterProperty('Button3', 'TBitBtn', iptrw);
    RegisterProperty('Button4', 'TBitBtn', iptrw);
    RegisterProperty('SelectFont1', 'TMenuItem', iptrw);
    RegisterProperty('OpenPicture2', 'TMenuItem', iptrw);
    RegisterProperty('PageControl2', 'TPageControl', iptrw);
    RegisterProperty('ListTab', 'TTabSheet', iptrw);
    RegisterProperty('AutoCheckTab', 'TTabSheet', iptrw);
    RegisterProperty('DialogTab', 'TTabSheet', iptrw);
    RegisterProperty('FormatTab', 'TTabSheet', iptrw);
    RegisterProperty('EditTab', 'TTabSheet', iptrw);
    RegisterProperty('SearchTab', 'TTabSheet', iptrw);
    RegisterProperty('ToolBar2', 'TToolBar', iptrw);
    RegisterProperty('ToolButton18', 'TToolButton', iptrw);
    RegisterProperty('ToolButton19', 'TToolButton', iptrw);
    RegisterProperty('ToolButton20', 'TToolButton', iptrw);
    RegisterProperty('ToolButton21', 'TToolButton', iptrw);
    RegisterProperty('Memo2', 'TMemo', iptrw);
    RegisterProperty('Image1', 'TImage', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('SpeedButton1', 'TSpeedButton', iptrw);
    RegisterProperty('Button2', 'TBitBtn', iptrw);
    RegisterProperty('Button1', 'TBitBtn', iptrw);
    RegisterProperty('ToolBar1', 'TToolBar', iptrw);
    RegisterProperty('ToolButton5', 'TToolButton', iptrw);
    RegisterProperty('ToolButton6', 'TToolButton', iptrw);
    RegisterProperty('ToolButton7', 'TToolButton', iptrw);
    RegisterProperty('ToolButton8', 'TToolButton', iptrw);
    RegisterProperty('ToolButton11', 'TToolButton', iptrw);
    RegisterProperty('ToolButton12', 'TToolButton', iptrw);
    RegisterProperty('ToolButton1', 'TToolButton', iptrw);
    RegisterProperty('ToolButton2', 'TToolButton', iptrw);
    RegisterProperty('RichEdit1', 'TRichEdit', iptrw);
    RegisterProperty('ToolBar3', 'TToolBar', iptrw);
    RegisterProperty('ToolButton3', 'TToolButton', iptrw);
    RegisterProperty('ToolButton4', 'TToolButton', iptrw);
    RegisterProperty('ToolButton9', 'TToolButton', iptrw);
    RegisterProperty('ToolButton10', 'TToolButton', iptrw);
    RegisterProperty('ToolButton13', 'TToolButton', iptrw);
    RegisterProperty('ToolButton14', 'TToolButton', iptrw);
    RegisterProperty('Memo3', 'TMemo', iptrw);
    RegisterProperty('ListBoxTab', 'TTabSheet', iptrw);
    RegisterProperty('CheckBox2', 'TCheckBox', iptrw);
    RegisterProperty('CheckBox1', 'TCheckBox', iptrw);
    RegisterProperty('StaticListAction1', 'TStaticListAction', iptrw);
    RegisterProperty('DeleteAction', 'TAction', iptrw);
    RegisterProperty('AddAction', 'TAction', iptrw);
    RegisterProperty('ClearAction', 'TAction', iptrw);
    RegisterProperty('ActiveAction', 'TAction', iptrw);
    RegisterProperty('SetIndexAction', 'TAction', iptrw);
    RegisterProperty('Label4', 'TLabel', iptrw);
    RegisterProperty('Label5', 'TLabel', iptrw);
    RegisterProperty('Label6', 'TLabel', iptrw);
    RegisterProperty('ListView1', 'TListView', iptrw);
    RegisterProperty('ComboBoxEx1', 'TComboBoxEx', iptrw);
    RegisterProperty('AddBtn', 'TBitBtn', iptrw);
    RegisterProperty('AddEdit', 'TEdit', iptrw);
    RegisterProperty('DeleteBtn', 'TBitBtn', iptrw);
    RegisterProperty('DelEdit', 'TEdit', iptrw);
    RegisterProperty('Button5', 'TBitBtn', iptrw);
    RegisterProperty('IdxEdit', 'TEdit', iptrw);
    RegisterProperty('Button6', 'TBitBtn', iptrw);
    RegisterProperty('ActiveBtn', 'TBitBtn', iptrw);
    RegisterProperty('GroupedActions11', 'TMenuItem', iptrw);
    RegisterProperty('Previous1', 'TMenuItem', iptrw);
    RegisterProperty('Next1', 'TMenuItem', iptrw);
    RegisterProperty('ToolBar4', 'TToolBar', iptrw);
    RegisterProperty('ToolButton15', 'TToolButton', iptrw);
    RegisterProperty('SpeedButton2', 'TSpeedButton', iptrw);
    RegisterProperty('SpeedButton3', 'TSpeedButton', iptrw);
    RegisterProperty('RadioButton1', 'TRadioButton', iptrw);
    RegisterProperty('RadioButton2', 'TRadioButton', iptrw);
    RegisterProperty('RadioButton3', 'TRadioButton', iptrw);
    RegisterProperty('ToolButton16', 'TToolButton', iptrw);
    RegisterProperty('ToolButton17', 'TToolButton', iptrw);
    RegisterProperty('ToolButton22', 'TToolButton', iptrw);
    RegisterProperty('ToolButton23', 'TToolButton', iptrw);
    RegisterProperty('ListBox1', 'TListBox', iptrw);
    RegisterProperty('ListBox2', 'TListBox', iptrw);
    RegisterProperty('SpeedButton4', 'TSpeedButton', iptrw);
    RegisterProperty('SpeedButton5', 'TSpeedButton', iptrw);
    RegisterProperty('SpeedButton6', 'TSpeedButton', iptrw);
    RegisterProperty('SpeedButton7', 'TSpeedButton', iptrw);
    RegisterProperty('SpeedButton8', 'TSpeedButton', iptrw);
    RegisterProperty('ListControlCopySelection1', 'TListControlCopySelection', iptrw);
    RegisterProperty('ListControlDeleteSelection1', 'TListControlDeleteSelection', iptrw);
    RegisterProperty('ListControlSelectAll1', 'TListControlSelectAll', iptrw);
    RegisterProperty('ListControlClearSelection1', 'TListControlClearSelection', iptrw);
    RegisterProperty('ListControlMoveSelection1', 'TListControlMoveSelection', iptrw);
    RegisterProperty('Label8', 'TLabel', iptrw);
    RegisterProperty('Label9', 'TLabel', iptrw);
    RegisterProperty('StaticText1', 'TStaticText', iptrw);
    RegisterProperty('StaticText2', 'TStaticText', iptrw);
    RegisterProperty('StaticText3', 'TStaticText', iptrw);
    RegisterProperty('Label11', 'TLabel', iptrw);
    RegisterProperty('Label7', 'TLabel', iptrw);
    RegisterProperty('Label10', 'TLabel', iptrw);
    RegisterProperty('ShortCutTab', 'TTabSheet', iptrw);
    RegisterProperty('Button7', 'TBitBtn', iptrw);
    RegisterProperty('ShortCutAction', 'TAction', iptrw);
    RegisterProperty('HotKey1', 'THotKey', iptrw);
    RegisterProperty('Button8', 'TBitBtn', iptrw);
    RegisterProperty('AddShortCut', 'TAction', iptrw);
    RegisterProperty('Label12', 'TLabel', iptrw);
    RegisterProperty('Label13', 'TLabel', iptrw);
    RegisterProperty('ShortCutList', 'TListBox', iptrw);
    RegisterProperty('Label14', 'TLabel', iptrw);
    RegisterProperty('FileOpenWith1', 'TFileOpenWith', iptrw);
    RegisterProperty('OpenWith1', 'TMenuItem', iptrw);
    RegisterProperty('FileTab', 'TTabSheet', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Button9', 'TBitBtn', iptrw);
    RegisterProperty('Button10', 'TBitBtn', iptrw);
    RegisterProperty('FileSaveAs1', 'TFileSaveAs', iptrw);
    RegisterProperty('FilePrintSetup1', 'TFilePrintSetup', iptrw);
    RegisterProperty('N3', 'TMenuItem', iptrw);
    RegisterProperty('PrintSetup1', 'TMenuItem', iptrw);
    RegisterProperty('Memo1', 'TMemo', iptrw);
    RegisterProperty('Button11', 'TBitBtn', iptrw);
    RegisterProperty('Button12', 'TBitBtn', iptrw);
    RegisterProperty('LabeledEdit1', 'TLabeledEdit', iptrw);
    RegisterProperty('Button13', 'TBitBtn', iptrw);
    RegisterMethod('Procedure FileOpen1Accept( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure ColorSelect1Accept( Sender : TObject)');
    RegisterMethod('Procedure OpenPicture1Accept( Sender : TObject)');
    RegisterMethod('Procedure FontEdit1Accept( Sender : TObject)');
    RegisterMethod('Procedure DeleteActionExecute( Sender : TObject)');
    RegisterMethod('Procedure AddActionExecute( Sender : TObject)');
    RegisterMethod('Procedure ClearActionExecute( Sender : TObject)');
    RegisterMethod('Procedure ActiveActionExecute( Sender : TObject)');
    RegisterMethod('Procedure SetIndexActionExecute( Sender : TObject)');
    RegisterMethod('Procedure ShortCutActionExecute( Sender : TObject)');
    RegisterMethod('Procedure AddShortCutExecute( Sender : TObject)');
    RegisterMethod('Procedure FileSaveAs1Accept( Sender : TObject)');
    RegisterMethod('Procedure SearchTabShow( Sender : TObject)');
    RegisterMethod('Procedure EditTabShow( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_actionMain(CL: TPSPascalCompiler);
begin
  SIRegister_TForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TForm1Button13_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button13 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button13_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button13; end;

(*----------------------------------------------------------------------------*)
procedure TForm1LabeledEdit1_W(Self: TActionForm; const T: TLabeledEdit);
Begin Self.LabeledEdit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1LabeledEdit1_R(Self: TActionForm; var T: TLabeledEdit);
Begin T := Self.LabeledEdit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button12_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button12_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button12; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button11_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button11_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button11; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Memo1_W(Self: TActionForm; const T: TMemo);
Begin Self.Memo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Memo1_R(Self: TActionForm; var T: TMemo);
Begin T := Self.Memo1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PrintSetup1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.PrintSetup1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PrintSetup1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.PrintSetup1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N3_W(Self: TActionForm; const T: TMenuItem);
Begin Self.N3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N3_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.N3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FilePrintSetup1_W(Self: TActionForm; const T: TFilePrintSetup);
Begin Self.FilePrintSetup1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FilePrintSetup1_R(Self: TActionForm; var T: TFilePrintSetup);
Begin T := Self.FilePrintSetup1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileSaveAs1_W(Self: TActionForm; const T: TFileSaveAs);
Begin Self.FileSaveAs1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileSaveAs1_R(Self: TActionForm; var T: TFileSaveAs);
Begin T := Self.FileSaveAs1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button10_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button10_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button10; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button9_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button9_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button9; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label3_W(Self: TActionForm; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label3_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.FileTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.FileTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1OpenWith1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.OpenWith1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1OpenWith1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.OpenWith1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileOpenWith1_W(Self: TActionForm; const T: TFileOpenWith);
Begin Self.FileOpenWith1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileOpenWith1_R(Self: TActionForm; var T: TFileOpenWith);
Begin T := Self.FileOpenWith1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label14_W(Self: TActionForm; const T: TLabel);
Begin Self.Label14 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label14_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label14; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ShortCutList_W(Self: TActionForm; const T: TListBox);
Begin Self.ShortCutList := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ShortCutList_R(Self: TActionForm; var T: TListBox);
Begin T := Self.ShortCutList; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label13_W(Self: TActionForm; const T: TLabel);
Begin Self.Label13 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label13_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label13; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label12_W(Self: TActionForm; const T: TLabel);
Begin Self.Label12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label12_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label12; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AddShortCut_W(Self: TActionForm; const T: TAction);
Begin Self.AddShortCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AddShortCut_R(Self: TActionForm; var T: TAction);
Begin T := Self.AddShortCut; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button8_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button8_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button8; end;

(*----------------------------------------------------------------------------*)
procedure TForm1HotKey1_W(Self: TActionForm; const T: THotKey);
Begin Self.HotKey1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1HotKey1_R(Self: TActionForm; var T: THotKey);
Begin T := Self.HotKey1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ShortCutAction_W(Self: TActionForm; const T: TAction);
Begin Self.ShortCutAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ShortCutAction_R(Self: TActionForm; var T: TAction);
Begin T := Self.ShortCutAction; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button7_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button7_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button7; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ShortCutTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.ShortCutTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ShortCutTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.ShortCutTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label10_W(Self: TActionForm; const T: TLabel);
Begin Self.Label10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label10_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label10; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label7_W(Self: TActionForm; const T: TLabel);
Begin Self.Label7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label7_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label7; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label11_W(Self: TActionForm; const T: TLabel);
Begin Self.Label11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label11_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label11; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StaticText3_W(Self: TActionForm; const T: TStaticText);
Begin Self.StaticText3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StaticText3_R(Self: TActionForm; var T: TStaticText);
Begin T := Self.StaticText3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StaticText2_W(Self: TActionForm; const T: TStaticText);
Begin Self.StaticText2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StaticText2_R(Self: TActionForm; var T: TStaticText);
Begin T := Self.StaticText2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StaticText1_W(Self: TActionForm; const T: TStaticText);
Begin Self.StaticText1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StaticText1_R(Self: TActionForm; var T: TStaticText);
Begin T := Self.StaticText1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label9_W(Self: TActionForm; const T: TLabel);
Begin Self.Label9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label9_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label9; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label8_W(Self: TActionForm; const T: TLabel);
Begin Self.Label8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label8_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label8; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlMoveSelection1_W(Self: TActionForm; const T: TListControlMoveSelection);
Begin Self.ListControlMoveSelection1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlMoveSelection1_R(Self: TActionForm; var T: TListControlMoveSelection);
Begin T := Self.ListControlMoveSelection1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlClearSelection1_W(Self: TActionForm; const T: TListControlClearSelection);
Begin Self.ListControlClearSelection1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlClearSelection1_R(Self: TActionForm; var T: TListControlClearSelection);
Begin T := Self.ListControlClearSelection1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlSelectAll1_W(Self: TActionForm; const T: TListControlSelectAll);
Begin Self.ListControlSelectAll1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlSelectAll1_R(Self: TActionForm; var T: TListControlSelectAll);
Begin T := Self.ListControlSelectAll1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlDeleteSelection1_W(Self: TActionForm; const T: TListControlDeleteSelection);
Begin Self.ListControlDeleteSelection1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlDeleteSelection1_R(Self: TActionForm; var T: TListControlDeleteSelection);
Begin T := Self.ListControlDeleteSelection1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlCopySelection1_W(Self: TActionForm; const T: TListControlCopySelection);
Begin Self.ListControlCopySelection1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListControlCopySelection1_R(Self: TActionForm; var T: TListControlCopySelection);
Begin T := Self.ListControlCopySelection1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton8_W(Self: TActionForm; const T: TSpeedButton);
Begin Self.SpeedButton8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton8_R(Self: TActionForm; var T: TSpeedButton);
Begin T := Self.SpeedButton8; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton7_W(Self: TActionForm; const T: TSpeedButton);
Begin Self.SpeedButton7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton7_R(Self: TActionForm; var T: TSpeedButton);
Begin T := Self.SpeedButton7; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton6_W(Self: TActionForm; const T: TSpeedButton);
Begin Self.SpeedButton6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton6_R(Self: TActionForm; var T: TSpeedButton);
Begin T := Self.SpeedButton6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton5_W(Self: TActionForm; const T: TSpeedButton);
Begin Self.SpeedButton5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton5_R(Self: TActionForm; var T: TSpeedButton);
Begin T := Self.SpeedButton5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton4_W(Self: TActionForm; const T: TSpeedButton);
Begin Self.SpeedButton4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton4_R(Self: TActionForm; var T: TSpeedButton);
Begin T := Self.SpeedButton4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListBox2_W(Self: TActionForm; const T: TListBox);
Begin Self.ListBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListBox2_R(Self: TActionForm; var T: TListBox);
Begin T := Self.ListBox2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListBox1_W(Self: TActionForm; const T: TListBox);
Begin Self.ListBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListBox1_R(Self: TActionForm; var T: TListBox);
Begin T := Self.ListBox1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton23_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton23 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton23_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton23; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton22_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton22 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton22_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton22; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton17_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton17 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton17_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton17; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton16_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton16 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton16_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton16; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioButton3_W(Self: TActionForm; const T: TRadioButton);
Begin Self.RadioButton3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioButton3_R(Self: TActionForm; var T: TRadioButton);
Begin T := Self.RadioButton3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioButton2_W(Self: TActionForm; const T: TRadioButton);
Begin Self.RadioButton2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioButton2_R(Self: TActionForm; var T: TRadioButton);
Begin T := Self.RadioButton2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioButton1_W(Self: TActionForm; const T: TRadioButton);
Begin Self.RadioButton1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RadioButton1_R(Self: TActionForm; var T: TRadioButton);
Begin T := Self.RadioButton1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton3_W(Self: TActionForm; const T: TSpeedButton);
Begin Self.SpeedButton3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton3_R(Self: TActionForm; var T: TSpeedButton);
Begin T := Self.SpeedButton3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton2_W(Self: TActionForm; const T: TSpeedButton);
Begin Self.SpeedButton2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton2_R(Self: TActionForm; var T: TSpeedButton);
Begin T := Self.SpeedButton2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton15_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton15 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton15_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton15; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolBar4_W(Self: TActionForm; const T: TToolBar);
Begin Self.ToolBar4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolBar4_R(Self: TActionForm; var T: TToolBar);
Begin T := Self.ToolBar4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Next1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Next1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Next1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Next1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Previous1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Previous1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Previous1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Previous1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedActions11_W(Self: TActionForm; const T: TMenuItem);
Begin Self.GroupedActions11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedActions11_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.GroupedActions11; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ActiveBtn_W(Self: TActionForm; const T: TBitBtn);
Begin Self.ActiveBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ActiveBtn_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.ActiveBtn; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button6_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button6_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1IdxEdit_W(Self: TActionForm; const T: TEdit);
Begin Self.IdxEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1IdxEdit_R(Self: TActionForm; var T: TEdit);
Begin T := Self.IdxEdit; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button5_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button5_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DelEdit_W(Self: TActionForm; const T: TEdit);
Begin Self.DelEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DelEdit_R(Self: TActionForm; var T: TEdit);
Begin T := Self.DelEdit; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DeleteBtn_W(Self: TActionForm; const T: TBitBtn);
Begin Self.DeleteBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DeleteBtn_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.DeleteBtn; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AddEdit_W(Self: TActionForm; const T: TEdit);
Begin Self.AddEdit := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AddEdit_R(Self: TActionForm; var T: TEdit);
Begin T := Self.AddEdit; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AddBtn_W(Self: TActionForm; const T: TBitBtn);
Begin Self.AddBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AddBtn_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.AddBtn; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComboBoxEx1_W(Self: TActionForm; const T: TComboBoxEx);
Begin Self.ComboBoxEx1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ComboBoxEx1_R(Self: TActionForm; var T: TComboBoxEx);
Begin T := Self.ComboBoxEx1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListView1_W(Self: TActionForm; const T: TListView);
Begin Self.ListView1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListView1_R(Self: TActionForm; var T: TListView);
Begin T := Self.ListView1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label6_W(Self: TActionForm; const T: TLabel);
Begin Self.Label6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label6_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label5_W(Self: TActionForm; const T: TLabel);
Begin Self.Label5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label5_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label4_W(Self: TActionForm; const T: TLabel);
Begin Self.Label4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label4_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SetIndexAction_W(Self: TActionForm; const T: TAction);
Begin Self.SetIndexAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SetIndexAction_R(Self: TActionForm; var T: TAction);
Begin T := Self.SetIndexAction; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ActiveAction_W(Self: TActionForm; const T: TAction);
Begin Self.ActiveAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ActiveAction_R(Self: TActionForm; var T: TAction);
Begin T := Self.ActiveAction; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ClearAction_W(Self: TActionForm; const T: TAction);
Begin Self.ClearAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ClearAction_R(Self: TActionForm; var T: TAction);
Begin T := Self.ClearAction; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AddAction_W(Self: TActionForm; const T: TAction);
Begin Self.AddAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AddAction_R(Self: TActionForm; var T: TAction);
Begin T := Self.AddAction; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DeleteAction_W(Self: TActionForm; const T: TAction);
Begin Self.DeleteAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DeleteAction_R(Self: TActionForm; var T: TAction);
Begin T := Self.DeleteAction; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StaticListAction1_W(Self: TActionForm; const T: TStaticListAction);
Begin Self.StaticListAction1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StaticListAction1_R(Self: TActionForm; var T: TStaticListAction);
Begin T := Self.StaticListAction1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1CheckBox1_W(Self: TActionForm; const T: TCheckBox);
Begin Self.CheckBox1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1CheckBox1_R(Self: TActionForm; var T: TCheckBox);
Begin T := Self.CheckBox1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1CheckBox2_W(Self: TActionForm; const T: TCheckBox);
Begin Self.CheckBox2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1CheckBox2_R(Self: TActionForm; var T: TCheckBox);
Begin T := Self.CheckBox2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListBoxTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.ListBoxTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListBoxTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.ListBoxTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Memo3_W(Self: TActionForm; const T: TMemo);
Begin Self.Memo3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Memo3_R(Self: TActionForm; var T: TMemo);
Begin T := Self.Memo3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton14_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton14 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton14_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton14; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton13_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton13 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton13_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton13; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton10_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton10 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton10_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton10; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton9_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton9 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton9_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton9; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton4_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton4_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton3_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton3_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolBar3_W(Self: TActionForm; const T: TToolBar);
Begin Self.ToolBar3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolBar3_R(Self: TActionForm; var T: TToolBar);
Begin T := Self.ToolBar3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEdit1_W(Self: TActionForm; const T: TRichEdit);
Begin Self.RichEdit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEdit1_R(Self: TActionForm; var T: TRichEdit);
Begin T := Self.RichEdit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton2_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton2_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton1_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton1_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton12_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton12_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton12; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton11_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton11_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton11; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton8_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton8_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton8; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton7_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton7_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton7; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton6_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton6_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton6; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton5_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton5_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton5; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolBar1_W(Self: TActionForm; const T: TToolBar);
Begin Self.ToolBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolBar1_R(Self: TActionForm; var T: TToolBar);
Begin T := Self.ToolBar1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button1_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button1_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button2_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button2_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton1_W(Self: TActionForm; const T: TSpeedButton);
Begin Self.SpeedButton1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SpeedButton1_R(Self: TActionForm; var T: TSpeedButton);
Begin T := Self.SpeedButton1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Panel1_W(Self: TActionForm; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Panel1_R(Self: TActionForm; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Image1_W(Self: TActionForm; const T: TImage);
Begin Self.Image1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Image1_R(Self: TActionForm; var T: TImage);
Begin T := Self.Image1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Memo2_W(Self: TActionForm; const T: TMemo);
Begin Self.Memo2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Memo2_R(Self: TActionForm; var T: TMemo);
Begin T := Self.Memo2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton21_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton21 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton21_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton21; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton20_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton20 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton20_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton20; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton19_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton19 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton19_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton19; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton18_W(Self: TActionForm; const T: TToolButton);
Begin Self.ToolButton18 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolButton18_R(Self: TActionForm; var T: TToolButton);
Begin T := Self.ToolButton18; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolBar2_W(Self: TActionForm; const T: TToolBar);
Begin Self.ToolBar2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ToolBar2_R(Self: TActionForm; var T: TToolBar);
Begin T := Self.ToolBar2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.SearchTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.SearchTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.EditTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.EditTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FormatTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.FormatTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FormatTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.FormatTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DialogTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.DialogTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DialogTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.DialogTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AutoCheckTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.AutoCheckTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AutoCheckTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.AutoCheckTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListTab_W(Self: TActionForm; const T: TTabSheet);
Begin Self.ListTab := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ListTab_R(Self: TActionForm; var T: TTabSheet);
Begin T := Self.ListTab; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PageControl2_W(Self: TActionForm; const T: TPageControl);
Begin Self.PageControl2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PageControl2_R(Self: TActionForm; var T: TPageControl);
Begin T := Self.PageControl2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1OpenPicture2_W(Self: TActionForm; const T: TMenuItem);
Begin Self.OpenPicture2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1OpenPicture2_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.OpenPicture2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SelectFont1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.SelectFont1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SelectFont1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.SelectFont1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button4_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button4_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button4; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button3_W(Self: TActionForm; const T: TBitBtn);
Begin Self.Button3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button3_R(Self: TActionForm; var T: TBitBtn);
Begin T := Self.Button3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1NextTab1_W(Self: TActionForm; const T: TNextTab);
Begin Self.NextTab1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1NextTab1_R(Self: TActionForm; var T: TNextTab);
Begin T := Self.NextTab1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PreviousTab1_W(Self: TActionForm; const T: TPreviousTab);
Begin Self.PreviousTab1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1PreviousTab1_R(Self: TActionForm; var T: TPreviousTab);
Begin T := Self.PreviousTab1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FontEdit1_W(Self: TActionForm; const T: TFontEdit);
Begin Self.FontEdit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FontEdit1_R(Self: TActionForm; var T: TFontEdit);
Begin T := Self.FontEdit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1OpenPicture1_W(Self: TActionForm; const T: TOpenPicture);
Begin Self.OpenPicture1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1OpenPicture1_R(Self: TActionForm; var T: TOpenPicture);
Begin T := Self.OpenPicture1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SelectColor1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.SelectColor1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SelectColor1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.SelectColor1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Dialog1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Dialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Dialog1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Dialog1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ColorSelect1_W(Self: TActionForm; const T: TColorSelect);
Begin Self.ColorSelect1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ColorSelect1_R(Self: TActionForm; var T: TColorSelect);
Begin T := Self.ColorSelect1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SendMail2_W(Self: TActionForm; const T: TMenuItem);
Begin Self.SendMail2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SendMail2_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.SendMail2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DownloadURL2_W(Self: TActionForm; const T: TMenuItem);
Begin Self.DownloadURL2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DownloadURL2_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.DownloadURL2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrowseURL2_W(Self: TActionForm; const T: TMenuItem);
Begin Self.BrowseURL2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrowseURL2_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.BrowseURL2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedAction12_W(Self: TActionForm; const T: TMenuItem);
Begin Self.GroupedAction12 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedAction12_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.GroupedAction12; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SendMail1_W(Self: TActionForm; const T: TSendMail);
Begin Self.SendMail1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SendMail1_R(Self: TActionForm; var T: TSendMail);
Begin T := Self.SendMail1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DownLoadURL1_W(Self: TActionForm; const T: TDownLoadURL);
Begin Self.DownLoadURL1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1DownLoadURL1_R(Self: TActionForm; var T: TDownLoadURL);
Begin T := Self.DownLoadURL1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrowseURL1_W(Self: TActionForm; const T: TBrowseURL);
Begin Self.BrowseURL1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1BrowseURL1_R(Self: TActionForm; var T: TBrowseURL);
Begin T := Self.BrowseURL1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Open1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Open1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Open1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Open1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileOpen1_W(Self: TActionForm; const T: TFileOpen);
Begin Self.FileOpen1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileOpen1_R(Self: TActionForm; var T: TFileOpen);
Begin T := Self.FileOpen1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N2_W(Self: TActionForm; const T: TMenuItem);
Begin Self.N2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N2_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.N2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Run1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Run1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Run1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Run1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label1_W(Self: TActionForm; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Label1_R(Self: TActionForm; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileRun1_W(Self: TActionForm; const T: TFileRun);
Begin Self.FileRun1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileRun1_R(Self: TActionForm; var T: TFileRun);
Begin T := Self.FileRun1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AutoCheckAction1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.AutoCheckAction1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AutoCheckAction1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.AutoCheckAction1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.N1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1N1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.N1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedAction31_W(Self: TActionForm; const T: TMenuItem);
Begin Self.GroupedAction31 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedAction31_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.GroupedAction31; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedAction21_W(Self: TActionForm; const T: TMenuItem);
Begin Self.GroupedAction21 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedAction21_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.GroupedAction21; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedAction11_W(Self: TActionForm; const T: TMenuItem);
Begin Self.GroupedAction11 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupedAction11_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.GroupedAction11; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AutoCheck1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.AutoCheck1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AutoCheck1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.AutoCheck1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Undo1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Undo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Undo1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Undo1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SelectAll1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.SelectAll1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SelectAll1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.SelectAll1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Delete1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Delete1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Delete1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Delete1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Paste1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Paste1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Paste1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Paste1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Copy1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Copy1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Copy1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Copy1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Cut1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Cut1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Cut1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Cut1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditDelete1_W(Self: TActionForm; const T: TEditDelete);
Begin Self.EditDelete1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditDelete1_R(Self: TActionForm; var T: TEditDelete);
Begin T := Self.EditDelete1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditUndo1_W(Self: TActionForm; const T: TEditUndo);
Begin Self.EditUndo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditUndo1_R(Self: TActionForm; var T: TEditUndo);
Begin T := Self.EditUndo1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditSelectAll1_W(Self: TActionForm; const T: TEditSelectAll);
Begin Self.EditSelectAll1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditSelectAll1_R(Self: TActionForm; var T: TEditSelectAll);
Begin T := Self.EditSelectAll1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditPaste1_W(Self: TActionForm; const T: TEditPaste);
Begin Self.EditPaste1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditPaste1_R(Self: TActionForm; var T: TEditPaste);
Begin T := Self.EditPaste1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditCopy1_W(Self: TActionForm; const T: TEditCopy);
Begin Self.EditCopy1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditCopy1_R(Self: TActionForm; var T: TEditCopy);
Begin T := Self.EditCopy1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditCut1_W(Self: TActionForm; const T: TEditCut);
Begin Self.EditCut1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1EditCut1_R(Self: TActionForm; var T: TEditCut);
Begin T := Self.EditCut1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Edit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Edit1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Edit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Replace1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Replace1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Replace1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Replace1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FindNext1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.FindNext1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FindNext1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.FindNext1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FindFirst1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.FindFirst1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FindFirst1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.FindFirst1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Find1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Find1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Find1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Find1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Search1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Search1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Search1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Search1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Exit1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.Exit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Exit1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.Exit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileExit1_W(Self: TActionForm; const T: TFileExit);
Begin Self.FileExit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1FileExit1_R(Self: TActionForm; var T: TFileExit);
Begin T := Self.FileExit1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1File1_W(Self: TActionForm; const T: TMenuItem);
Begin Self.File1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1File1_R(Self: TActionForm; var T: TMenuItem);
Begin T := Self.File1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1MainMenu1_W(Self: TActionForm; const T: TMainMenu);
Begin Self.MainMenu1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1MainMenu1_R(Self: TActionForm; var T: TMainMenu);
Begin T := Self.MainMenu1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StatusBar1_W(Self: TActionForm; const T: TStatusBar);
Begin Self.StatusBar1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1StatusBar1_R(Self: TActionForm; var T: TStatusBar);
Begin T := Self.StatusBar1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AutoCheckAction_W(Self: TActionForm; const T: TAction);
Begin Self.AutoCheckAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AutoCheckAction_R(Self: TActionForm; var T: TAction);
Begin T := Self.AutoCheckAction; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupAction3_W(Self: TActionForm; const T: TAction);
Begin Self.GroupAction3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupAction3_R(Self: TActionForm; var T: TAction);
Begin T := Self.GroupAction3; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupAction2_W(Self: TActionForm; const T: TAction);
Begin Self.GroupAction2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupAction2_R(Self: TActionForm; var T: TAction);
Begin T := Self.GroupAction2; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupAction1_W(Self: TActionForm; const T: TAction);
Begin Self.GroupAction1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1GroupAction1_R(Self: TActionForm; var T: TAction);
Begin T := Self.GroupAction1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchFindFirst1_W(Self: TActionForm; const T: TSearchFindFirst);
Begin Self.SearchFindFirst1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchFindFirst1_R(Self: TActionForm; var T: TSearchFindFirst);
Begin T := Self.SearchFindFirst1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchReplace1_W(Self: TActionForm; const T: TSearchReplace);
Begin Self.SearchReplace1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchReplace1_R(Self: TActionForm; var T: TSearchReplace);
Begin T := Self.SearchReplace1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchFindNext1_W(Self: TActionForm; const T: TSearchFindNext);
Begin Self.SearchFindNext1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchFindNext1_R(Self: TActionForm; var T: TSearchFindNext);
Begin T := Self.SearchFindNext1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchFind1_W(Self: TActionForm; const T: TSearchFind);
Begin Self.SearchFind1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1SearchFind1_R(Self: TActionForm; var T: TSearchFind);
Begin T := Self.SearchFind1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditAlignCenter1_W(Self: TActionForm; const T: TRichEditAlignCenter);
Begin Self.RichEditAlignCenter1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditAlignCenter1_R(Self: TActionForm; var T: TRichEditAlignCenter);
Begin T := Self.RichEditAlignCenter1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditAlignRight1_W(Self: TActionForm; const T: TRichEditAlignRight);
Begin Self.RichEditAlignRight1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditAlignRight1_R(Self: TActionForm; var T: TRichEditAlignRight);
Begin T := Self.RichEditAlignRight1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditAlignLeft1_W(Self: TActionForm; const T: TRichEditAlignLeft);
Begin Self.RichEditAlignLeft1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditAlignLeft1_R(Self: TActionForm; var T: TRichEditAlignLeft);
Begin T := Self.RichEditAlignLeft1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditBullets1_W(Self: TActionForm; const T: TRichEditBullets);
Begin Self.RichEditBullets1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditBullets1_R(Self: TActionForm; var T: TRichEditBullets);
Begin T := Self.RichEditBullets1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditStrikeOut1_W(Self: TActionForm; const T: TRichEditStrikeOut);
Begin Self.RichEditStrikeOut1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditStrikeOut1_R(Self: TActionForm; var T: TRichEditStrikeOut);
Begin T := Self.RichEditStrikeOut1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditUnderline1_W(Self: TActionForm; const T: TRichEditUnderline);
Begin Self.RichEditUnderline1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditUnderline1_R(Self: TActionForm; var T: TRichEditUnderline);
Begin T := Self.RichEditUnderline1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditItalic1_W(Self: TActionForm; const T: TRichEditItalic);
Begin Self.RichEditItalic1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditItalic1_R(Self: TActionForm; var T: TRichEditItalic);
Begin T := Self.RichEditItalic1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditBold1_W(Self: TActionForm; const T: TRichEditBold);
Begin Self.RichEditBold1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1RichEditBold1_R(Self: TActionForm; var T: TRichEditBold);
Begin T := Self.RichEditBold1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ImageList1_W(Self: TActionForm; const T: TImageList);
Begin Self.ImageList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ImageList1_R(Self: TActionForm; var T: TImageList);
Begin T := Self.ImageList1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ActionList1_W(Self: TActionForm; const T: TActionList);
Begin Self.ActionList1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1ActionList1_R(Self: TActionForm; var T: TActionList);
Begin T := Self.ActionList1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TActionForm) do
  begin
    RegisterPropertyHelper(@TForm1ActionList1_R,@TForm1ActionList1_W,'ActionList1');
    RegisterPropertyHelper(@TForm1ImageList1_R,@TForm1ImageList1_W,'ImageList1');
    RegisterPropertyHelper(@TForm1RichEditBold1_R,@TForm1RichEditBold1_W,'RichEditBold1');
    RegisterPropertyHelper(@TForm1RichEditItalic1_R,@TForm1RichEditItalic1_W,'RichEditItalic1');
    RegisterPropertyHelper(@TForm1RichEditUnderline1_R,@TForm1RichEditUnderline1_W,'RichEditUnderline1');
    RegisterPropertyHelper(@TForm1RichEditStrikeOut1_R,@TForm1RichEditStrikeOut1_W,'RichEditStrikeOut1');
    RegisterPropertyHelper(@TForm1RichEditBullets1_R,@TForm1RichEditBullets1_W,'RichEditBullets1');
    RegisterPropertyHelper(@TForm1RichEditAlignLeft1_R,@TForm1RichEditAlignLeft1_W,'RichEditAlignLeft1');
    RegisterPropertyHelper(@TForm1RichEditAlignRight1_R,@TForm1RichEditAlignRight1_W,'RichEditAlignRight1');
    RegisterPropertyHelper(@TForm1RichEditAlignCenter1_R,@TForm1RichEditAlignCenter1_W,'RichEditAlignCenter1');
    RegisterPropertyHelper(@TForm1SearchFind1_R,@TForm1SearchFind1_W,'SearchFind1');
    RegisterPropertyHelper(@TForm1SearchFindNext1_R,@TForm1SearchFindNext1_W,'SearchFindNext1');
    RegisterPropertyHelper(@TForm1SearchReplace1_R,@TForm1SearchReplace1_W,'SearchReplace1');
    RegisterPropertyHelper(@TForm1SearchFindFirst1_R,@TForm1SearchFindFirst1_W,'SearchFindFirst1');
    RegisterPropertyHelper(@TForm1GroupAction1_R,@TForm1GroupAction1_W,'GroupAction1');
    RegisterPropertyHelper(@TForm1GroupAction2_R,@TForm1GroupAction2_W,'GroupAction2');
    RegisterPropertyHelper(@TForm1GroupAction3_R,@TForm1GroupAction3_W,'GroupAction3');
    RegisterPropertyHelper(@TForm1AutoCheckAction_R,@TForm1AutoCheckAction_W,'AutoCheckAction');
    RegisterPropertyHelper(@TForm1StatusBar1_R,@TForm1StatusBar1_W,'StatusBar1');
    RegisterPropertyHelper(@TForm1MainMenu1_R,@TForm1MainMenu1_W,'MainMenu1');
    RegisterPropertyHelper(@TForm1File1_R,@TForm1File1_W,'File1');
    RegisterPropertyHelper(@TForm1FileExit1_R,@TForm1FileExit1_W,'FileExit1');
    RegisterPropertyHelper(@TForm1Exit1_R,@TForm1Exit1_W,'Exit1');
    RegisterPropertyHelper(@TForm1Search1_R,@TForm1Search1_W,'Search1');
    RegisterPropertyHelper(@TForm1Find1_R,@TForm1Find1_W,'Find1');
    RegisterPropertyHelper(@TForm1FindFirst1_R,@TForm1FindFirst1_W,'FindFirst1');
    RegisterPropertyHelper(@TForm1FindNext1_R,@TForm1FindNext1_W,'FindNext1');
    RegisterPropertyHelper(@TForm1Replace1_R,@TForm1Replace1_W,'Replace1');
    RegisterPropertyHelper(@TForm1Edit1_R,@TForm1Edit1_W,'Edit1');
    RegisterPropertyHelper(@TForm1EditCut1_R,@TForm1EditCut1_W,'EditCut1');
    RegisterPropertyHelper(@TForm1EditCopy1_R,@TForm1EditCopy1_W,'EditCopy1');
    RegisterPropertyHelper(@TForm1EditPaste1_R,@TForm1EditPaste1_W,'EditPaste1');
    RegisterPropertyHelper(@TForm1EditSelectAll1_R,@TForm1EditSelectAll1_W,'EditSelectAll1');
    RegisterPropertyHelper(@TForm1EditUndo1_R,@TForm1EditUndo1_W,'EditUndo1');
    RegisterPropertyHelper(@TForm1EditDelete1_R,@TForm1EditDelete1_W,'EditDelete1');
    RegisterPropertyHelper(@TForm1Cut1_R,@TForm1Cut1_W,'Cut1');
    RegisterPropertyHelper(@TForm1Copy1_R,@TForm1Copy1_W,'Copy1');
    RegisterPropertyHelper(@TForm1Paste1_R,@TForm1Paste1_W,'Paste1');
    RegisterPropertyHelper(@TForm1Delete1_R,@TForm1Delete1_W,'Delete1');
    RegisterPropertyHelper(@TForm1SelectAll1_R,@TForm1SelectAll1_W,'SelectAll1');
    RegisterPropertyHelper(@TForm1Undo1_R,@TForm1Undo1_W,'Undo1');
    RegisterPropertyHelper(@TForm1AutoCheck1_R,@TForm1AutoCheck1_W,'AutoCheck1');
    RegisterPropertyHelper(@TForm1GroupedAction11_R,@TForm1GroupedAction11_W,'GroupedAction11');
    RegisterPropertyHelper(@TForm1GroupedAction21_R,@TForm1GroupedAction21_W,'GroupedAction21');
    RegisterPropertyHelper(@TForm1GroupedAction31_R,@TForm1GroupedAction31_W,'GroupedAction31');
    RegisterPropertyHelper(@TForm1N1_R,@TForm1N1_W,'N1');
    RegisterPropertyHelper(@TForm1AutoCheckAction1_R,@TForm1AutoCheckAction1_W,'AutoCheckAction1');
    RegisterPropertyHelper(@TForm1FileRun1_R,@TForm1FileRun1_W,'FileRun1');
    RegisterPropertyHelper(@TForm1Label1_R,@TForm1Label1_W,'Label1');
    RegisterPropertyHelper(@TForm1Run1_R,@TForm1Run1_W,'Run1');
    RegisterPropertyHelper(@TForm1N2_R,@TForm1N2_W,'N2');
    RegisterPropertyHelper(@TForm1FileOpen1_R,@TForm1FileOpen1_W,'FileOpen1');
    RegisterPropertyHelper(@TForm1Open1_R,@TForm1Open1_W,'Open1');
    RegisterPropertyHelper(@TForm1BrowseURL1_R,@TForm1BrowseURL1_W,'BrowseURL1');
    RegisterPropertyHelper(@TForm1DownLoadURL1_R,@TForm1DownLoadURL1_W,'DownLoadURL1');
    RegisterPropertyHelper(@TForm1SendMail1_R,@TForm1SendMail1_W,'SendMail1');
    RegisterPropertyHelper(@TForm1GroupedAction12_R,@TForm1GroupedAction12_W,'GroupedAction12');
    RegisterPropertyHelper(@TForm1BrowseURL2_R,@TForm1BrowseURL2_W,'BrowseURL2');
    RegisterPropertyHelper(@TForm1DownloadURL2_R,@TForm1DownloadURL2_W,'DownloadURL2');
    RegisterPropertyHelper(@TForm1SendMail2_R,@TForm1SendMail2_W,'SendMail2');
    RegisterPropertyHelper(@TForm1ColorSelect1_R,@TForm1ColorSelect1_W,'ColorSelect1');
    RegisterPropertyHelper(@TForm1Dialog1_R,@TForm1Dialog1_W,'Dialog1');
    RegisterPropertyHelper(@TForm1SelectColor1_R,@TForm1SelectColor1_W,'SelectColor1');
    RegisterPropertyHelper(@TForm1OpenPicture1_R,@TForm1OpenPicture1_W,'OpenPicture1');
    RegisterPropertyHelper(@TForm1FontEdit1_R,@TForm1FontEdit1_W,'FontEdit1');
    RegisterPropertyHelper(@TForm1PreviousTab1_R,@TForm1PreviousTab1_W,'PreviousTab1');
    RegisterPropertyHelper(@TForm1NextTab1_R,@TForm1NextTab1_W,'NextTab1');
    RegisterPropertyHelper(@TForm1Button3_R,@TForm1Button3_W,'Button3');
    RegisterPropertyHelper(@TForm1Button4_R,@TForm1Button4_W,'Button4');
    RegisterPropertyHelper(@TForm1SelectFont1_R,@TForm1SelectFont1_W,'SelectFont1');
    RegisterPropertyHelper(@TForm1OpenPicture2_R,@TForm1OpenPicture2_W,'OpenPicture2');
    RegisterPropertyHelper(@TForm1PageControl2_R,@TForm1PageControl2_W,'PageControl2');
    RegisterPropertyHelper(@TForm1ListTab_R,@TForm1ListTab_W,'ListTab');
    RegisterPropertyHelper(@TForm1AutoCheckTab_R,@TForm1AutoCheckTab_W,'AutoCheckTab');
    RegisterPropertyHelper(@TForm1DialogTab_R,@TForm1DialogTab_W,'DialogTab');
    RegisterPropertyHelper(@TForm1FormatTab_R,@TForm1FormatTab_W,'FormatTab');
    RegisterPropertyHelper(@TForm1EditTab_R,@TForm1EditTab_W,'EditTab');
    RegisterPropertyHelper(@TForm1SearchTab_R,@TForm1SearchTab_W,'SearchTab');
    RegisterPropertyHelper(@TForm1ToolBar2_R,@TForm1ToolBar2_W,'ToolBar2');
    RegisterPropertyHelper(@TForm1ToolButton18_R,@TForm1ToolButton18_W,'ToolButton18');
    RegisterPropertyHelper(@TForm1ToolButton19_R,@TForm1ToolButton19_W,'ToolButton19');
    RegisterPropertyHelper(@TForm1ToolButton20_R,@TForm1ToolButton20_W,'ToolButton20');
    RegisterPropertyHelper(@TForm1ToolButton21_R,@TForm1ToolButton21_W,'ToolButton21');
    RegisterPropertyHelper(@TForm1Memo2_R,@TForm1Memo2_W,'Memo2');
    RegisterPropertyHelper(@TForm1Image1_R,@TForm1Image1_W,'Image1');
    RegisterPropertyHelper(@TForm1Panel1_R,@TForm1Panel1_W,'Panel1');
    RegisterPropertyHelper(@TForm1SpeedButton1_R,@TForm1SpeedButton1_W,'SpeedButton1');
    RegisterPropertyHelper(@TForm1Button2_R,@TForm1Button2_W,'Button2');
    RegisterPropertyHelper(@TForm1Button1_R,@TForm1Button1_W,'Button1');
    RegisterPropertyHelper(@TForm1ToolBar1_R,@TForm1ToolBar1_W,'ToolBar1');
    RegisterPropertyHelper(@TForm1ToolButton5_R,@TForm1ToolButton5_W,'ToolButton5');
    RegisterPropertyHelper(@TForm1ToolButton6_R,@TForm1ToolButton6_W,'ToolButton6');
    RegisterPropertyHelper(@TForm1ToolButton7_R,@TForm1ToolButton7_W,'ToolButton7');
    RegisterPropertyHelper(@TForm1ToolButton8_R,@TForm1ToolButton8_W,'ToolButton8');
    RegisterPropertyHelper(@TForm1ToolButton11_R,@TForm1ToolButton11_W,'ToolButton11');
    RegisterPropertyHelper(@TForm1ToolButton12_R,@TForm1ToolButton12_W,'ToolButton12');
    RegisterPropertyHelper(@TForm1ToolButton1_R,@TForm1ToolButton1_W,'ToolButton1');
    RegisterPropertyHelper(@TForm1ToolButton2_R,@TForm1ToolButton2_W,'ToolButton2');
    RegisterPropertyHelper(@TForm1RichEdit1_R,@TForm1RichEdit1_W,'RichEdit1');
    RegisterPropertyHelper(@TForm1ToolBar3_R,@TForm1ToolBar3_W,'ToolBar3');
    RegisterPropertyHelper(@TForm1ToolButton3_R,@TForm1ToolButton3_W,'ToolButton3');
    RegisterPropertyHelper(@TForm1ToolButton4_R,@TForm1ToolButton4_W,'ToolButton4');
    RegisterPropertyHelper(@TForm1ToolButton9_R,@TForm1ToolButton9_W,'ToolButton9');
    RegisterPropertyHelper(@TForm1ToolButton10_R,@TForm1ToolButton10_W,'ToolButton10');
    RegisterPropertyHelper(@TForm1ToolButton13_R,@TForm1ToolButton13_W,'ToolButton13');
    RegisterPropertyHelper(@TForm1ToolButton14_R,@TForm1ToolButton14_W,'ToolButton14');
    RegisterPropertyHelper(@TForm1Memo3_R,@TForm1Memo3_W,'Memo3');
    RegisterPropertyHelper(@TForm1ListBoxTab_R,@TForm1ListBoxTab_W,'ListBoxTab');
    RegisterPropertyHelper(@TForm1CheckBox2_R,@TForm1CheckBox2_W,'CheckBox2');
    RegisterPropertyHelper(@TForm1CheckBox1_R,@TForm1CheckBox1_W,'CheckBox1');
    RegisterPropertyHelper(@TForm1StaticListAction1_R,@TForm1StaticListAction1_W,'StaticListAction1');
    RegisterPropertyHelper(@TForm1DeleteAction_R,@TForm1DeleteAction_W,'DeleteAction');
    RegisterPropertyHelper(@TForm1AddAction_R,@TForm1AddAction_W,'AddAction');
    RegisterPropertyHelper(@TForm1ClearAction_R,@TForm1ClearAction_W,'ClearAction');
    RegisterPropertyHelper(@TForm1ActiveAction_R,@TForm1ActiveAction_W,'ActiveAction');
    RegisterPropertyHelper(@TForm1SetIndexAction_R,@TForm1SetIndexAction_W,'SetIndexAction');
    RegisterPropertyHelper(@TForm1Label4_R,@TForm1Label4_W,'Label4');
    RegisterPropertyHelper(@TForm1Label5_R,@TForm1Label5_W,'Label5');
    RegisterPropertyHelper(@TForm1Label6_R,@TForm1Label6_W,'Label6');
    RegisterPropertyHelper(@TForm1ListView1_R,@TForm1ListView1_W,'ListView1');
    RegisterPropertyHelper(@TForm1ComboBoxEx1_R,@TForm1ComboBoxEx1_W,'ComboBoxEx1');
    RegisterPropertyHelper(@TForm1AddBtn_R,@TForm1AddBtn_W,'AddBtn');
    RegisterPropertyHelper(@TForm1AddEdit_R,@TForm1AddEdit_W,'AddEdit');
    RegisterPropertyHelper(@TForm1DeleteBtn_R,@TForm1DeleteBtn_W,'DeleteBtn');
    RegisterPropertyHelper(@TForm1DelEdit_R,@TForm1DelEdit_W,'DelEdit');
    RegisterPropertyHelper(@TForm1Button5_R,@TForm1Button5_W,'Button5');
    RegisterPropertyHelper(@TForm1IdxEdit_R,@TForm1IdxEdit_W,'IdxEdit');
    RegisterPropertyHelper(@TForm1Button6_R,@TForm1Button6_W,'Button6');
    RegisterPropertyHelper(@TForm1ActiveBtn_R,@TForm1ActiveBtn_W,'ActiveBtn');
    RegisterPropertyHelper(@TForm1GroupedActions11_R,@TForm1GroupedActions11_W,'GroupedActions11');
    RegisterPropertyHelper(@TForm1Previous1_R,@TForm1Previous1_W,'Previous1');
    RegisterPropertyHelper(@TForm1Next1_R,@TForm1Next1_W,'Next1');
    RegisterPropertyHelper(@TForm1ToolBar4_R,@TForm1ToolBar4_W,'ToolBar4');
    RegisterPropertyHelper(@TForm1ToolButton15_R,@TForm1ToolButton15_W,'ToolButton15');
    RegisterPropertyHelper(@TForm1SpeedButton2_R,@TForm1SpeedButton2_W,'SpeedButton2');
    RegisterPropertyHelper(@TForm1SpeedButton3_R,@TForm1SpeedButton3_W,'SpeedButton3');
    RegisterPropertyHelper(@TForm1RadioButton1_R,@TForm1RadioButton1_W,'RadioButton1');
    RegisterPropertyHelper(@TForm1RadioButton2_R,@TForm1RadioButton2_W,'RadioButton2');
    RegisterPropertyHelper(@TForm1RadioButton3_R,@TForm1RadioButton3_W,'RadioButton3');
    RegisterPropertyHelper(@TForm1ToolButton16_R,@TForm1ToolButton16_W,'ToolButton16');
    RegisterPropertyHelper(@TForm1ToolButton17_R,@TForm1ToolButton17_W,'ToolButton17');
    RegisterPropertyHelper(@TForm1ToolButton22_R,@TForm1ToolButton22_W,'ToolButton22');
    RegisterPropertyHelper(@TForm1ToolButton23_R,@TForm1ToolButton23_W,'ToolButton23');
    RegisterPropertyHelper(@TForm1ListBox1_R,@TForm1ListBox1_W,'ListBox1');
    RegisterPropertyHelper(@TForm1ListBox2_R,@TForm1ListBox2_W,'ListBox2');
    RegisterPropertyHelper(@TForm1SpeedButton4_R,@TForm1SpeedButton4_W,'SpeedButton4');
    RegisterPropertyHelper(@TForm1SpeedButton5_R,@TForm1SpeedButton5_W,'SpeedButton5');
    RegisterPropertyHelper(@TForm1SpeedButton6_R,@TForm1SpeedButton6_W,'SpeedButton6');
    RegisterPropertyHelper(@TForm1SpeedButton7_R,@TForm1SpeedButton7_W,'SpeedButton7');
    RegisterPropertyHelper(@TForm1SpeedButton8_R,@TForm1SpeedButton8_W,'SpeedButton8');
    RegisterPropertyHelper(@TForm1ListControlCopySelection1_R,@TForm1ListControlCopySelection1_W,'ListControlCopySelection1');
    RegisterPropertyHelper(@TForm1ListControlDeleteSelection1_R,@TForm1ListControlDeleteSelection1_W,'ListControlDeleteSelection1');
    RegisterPropertyHelper(@TForm1ListControlSelectAll1_R,@TForm1ListControlSelectAll1_W,'ListControlSelectAll1');
    RegisterPropertyHelper(@TForm1ListControlClearSelection1_R,@TForm1ListControlClearSelection1_W,'ListControlClearSelection1');
    RegisterPropertyHelper(@TForm1ListControlMoveSelection1_R,@TForm1ListControlMoveSelection1_W,'ListControlMoveSelection1');
    RegisterPropertyHelper(@TForm1Label8_R,@TForm1Label8_W,'Label8');
    RegisterPropertyHelper(@TForm1Label9_R,@TForm1Label9_W,'Label9');
    RegisterPropertyHelper(@TForm1StaticText1_R,@TForm1StaticText1_W,'StaticText1');
    RegisterPropertyHelper(@TForm1StaticText2_R,@TForm1StaticText2_W,'StaticText2');
    RegisterPropertyHelper(@TForm1StaticText3_R,@TForm1StaticText3_W,'StaticText3');
    RegisterPropertyHelper(@TForm1Label11_R,@TForm1Label11_W,'Label11');
    RegisterPropertyHelper(@TForm1Label7_R,@TForm1Label7_W,'Label7');
    RegisterPropertyHelper(@TForm1Label10_R,@TForm1Label10_W,'Label10');
    RegisterPropertyHelper(@TForm1ShortCutTab_R,@TForm1ShortCutTab_W,'ShortCutTab');
    RegisterPropertyHelper(@TForm1Button7_R,@TForm1Button7_W,'Button7');
    RegisterPropertyHelper(@TForm1ShortCutAction_R,@TForm1ShortCutAction_W,'ShortCutAction');
    RegisterPropertyHelper(@TForm1HotKey1_R,@TForm1HotKey1_W,'HotKey1');
    RegisterPropertyHelper(@TForm1Button8_R,@TForm1Button8_W,'Button8');
    RegisterPropertyHelper(@TForm1AddShortCut_R,@TForm1AddShortCut_W,'AddShortCut');
    RegisterPropertyHelper(@TForm1Label12_R,@TForm1Label12_W,'Label12');
    RegisterPropertyHelper(@TForm1Label13_R,@TForm1Label13_W,'Label13');
    RegisterPropertyHelper(@TForm1ShortCutList_R,@TForm1ShortCutList_W,'ShortCutList');
    RegisterPropertyHelper(@TForm1Label14_R,@TForm1Label14_W,'Label14');
    RegisterPropertyHelper(@TForm1FileOpenWith1_R,@TForm1FileOpenWith1_W,'FileOpenWith1');
    RegisterPropertyHelper(@TForm1OpenWith1_R,@TForm1OpenWith1_W,'OpenWith1');
    RegisterPropertyHelper(@TForm1FileTab_R,@TForm1FileTab_W,'FileTab');
    RegisterPropertyHelper(@TForm1Label3_R,@TForm1Label3_W,'Label3');
    RegisterPropertyHelper(@TForm1Button9_R,@TForm1Button9_W,'Button9');
    RegisterPropertyHelper(@TForm1Button10_R,@TForm1Button10_W,'Button10');
    RegisterPropertyHelper(@TForm1FileSaveAs1_R,@TForm1FileSaveAs1_W,'FileSaveAs1');
    RegisterPropertyHelper(@TForm1FilePrintSetup1_R,@TForm1FilePrintSetup1_W,'FilePrintSetup1');
    RegisterPropertyHelper(@TForm1N3_R,@TForm1N3_W,'N3');
    RegisterPropertyHelper(@TForm1PrintSetup1_R,@TForm1PrintSetup1_W,'PrintSetup1');
    RegisterPropertyHelper(@TForm1Memo1_R,@TForm1Memo1_W,'Memo1');
    RegisterPropertyHelper(@TForm1Button11_R,@TForm1Button11_W,'Button11');
    RegisterPropertyHelper(@TForm1Button12_R,@TForm1Button12_W,'Button12');
    RegisterPropertyHelper(@TForm1LabeledEdit1_R,@TForm1LabeledEdit1_W,'LabeledEdit1');
    RegisterPropertyHelper(@TForm1Button13_R,@TForm1Button13_W,'Button13');
    RegisterMethod(@TActionForm.FileOpen1Accept, 'FileOpen1Accept');
    RegisterMethod(@TActionForm.FormCreate, 'FormCreate');
    RegisterMethod(@TActionForm.ColorSelect1Accept, 'ColorSelect1Accept');
    RegisterMethod(@TActionForm.OpenPicture1Accept, 'OpenPicture1Accept');
    RegisterMethod(@TActionForm.FontEdit1Accept, 'FontEdit1Accept');
    RegisterMethod(@TActionForm.DeleteActionExecute, 'DeleteActionExecute');
    RegisterMethod(@TActionForm.AddActionExecute, 'AddActionExecute');
    RegisterMethod(@TActionForm.ClearActionExecute, 'ClearActionExecute');
    RegisterMethod(@TActionForm.ActiveActionExecute, 'ActiveActionExecute');
    RegisterMethod(@TActionForm.SetIndexActionExecute, 'SetIndexActionExecute');
    RegisterMethod(@TActionForm.ShortCutActionExecute, 'ShortCutActionExecute');
    RegisterMethod(@TActionForm.AddShortCutExecute, 'AddShortCutExecute');
    RegisterMethod(@TActionForm.FileSaveAs1Accept, 'FileSaveAs1Accept');
    RegisterMethod(@TActionForm.SearchTabShow, 'SearchTabShow');
    RegisterMethod(@TActionForm.EditTabShow, 'EditTabShow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_actionMain(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TForm1(CL);
end;

 
 
{ TPSImport_actionMain }
(*----------------------------------------------------------------------------*)
procedure TPSImport_actionMain.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_actionMain(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_actionMain.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_actionMain(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
