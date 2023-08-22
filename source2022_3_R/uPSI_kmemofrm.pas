unit uPSI_kmemofrm;
{
kmemo is rich

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
  TPSImport_kmemofrm = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TKMemoFrame(CL: TPSPascalCompiler);
procedure SIRegister_kmemofrm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TKMemoFrame(CL: TPSRuntimeClassImporter);
procedure RIRegister_kmemofrm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { LCLType
  ,LCLIntf
  ,LMessages
  ,LCLProc
  ,LResources }
  Windows
  ,Messages
  ,Variants
  ,Graphics
  ,Controls
  ,Forms
  ,Menus
  ,Dialogs
  ,ToolWin
  ,ComCtrls
  ,ImgList
  ,KFunctions
  ,KControls
  ,KMemo
  ,ActnList
  ,KDialogs
  //,KMemoDlgParaStyle
  //,KMemoDlgTextStyle
  //,KMemoDlgHyperlink
  //,KMemoDlgNumbering
  ,kmemofrm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_kmemofrm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TKMemoFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFrame', 'TKMemoFrame') do
  with CL.AddClassN(CL.FindClass('TFrame'),'TKMemoFrame') do begin
    RegisterProperty('ACParaNumbering', 'TAction', iptrw);
    RegisterProperty('Editor', 'TKMemo', iptrw);
    RegisterProperty('ILMain', 'TImageList', iptrw);
    RegisterProperty('ToBFirst', 'TToolBar', iptrw);
    RegisterProperty('ToBNew', 'TToolButton', iptrw);
    RegisterProperty('ToBOpen', 'TToolButton', iptrw);
    RegisterProperty('ToBSave', 'TToolButton', iptrw);
    RegisterProperty('ToBSep1', 'TToolButton', iptrw);
    RegisterProperty('ToBCut', 'TToolButton', iptrw);
    RegisterProperty('ToBCopy', 'TToolButton', iptrw);
    RegisterProperty('ToBPaste', 'TToolButton', iptrw);
    RegisterProperty('ToBPrint', 'TToolButton', iptrw);
    RegisterProperty('ToBPreview', 'TToolButton', iptrw);
    RegisterProperty('ToBSep3', 'TToolButton', iptrw);
    RegisterProperty('ALMain', 'TActionList', iptrw);
    RegisterProperty('ACEditCopy', 'TKMemoEditCopyAction', iptrw);
    RegisterProperty('ACEditCut', 'TKMemoEditCutAction', iptrw);
    RegisterProperty('ACEditPaste', 'TKMemoEditPasteAction', iptrw);
    RegisterProperty('ACFileOpen', 'TAction', iptrw);
    RegisterProperty('ACFileNew', 'TAction', iptrw);
    RegisterProperty('ACFilePrint', 'TAction', iptrw);
    RegisterProperty('ACFileSave', 'TAction', iptrw);
    RegisterProperty('ACFilePreview', 'TAction', iptrw);
    RegisterProperty('ACFontBold', 'TAction', iptrw);
    RegisterProperty('ACFontItalic', 'TAction', iptrw);
    RegisterProperty('ACFontUnderline', 'TAction', iptrw);
    RegisterProperty('ACFontStrikeout', 'TAction', iptrw);
    RegisterProperty('ACFontStyle', 'TAction', iptrw);
    RegisterProperty('ACParaLeft', 'TAction', iptrw);
    RegisterProperty('ACParaCenter', 'TAction', iptrw);
    RegisterProperty('ACParaRight', 'TAction', iptrw);
    RegisterProperty('ACParaIncIndent', 'TAction', iptrw);
    RegisterProperty('ACParaDecIndent', 'TAction', iptrw);
    RegisterProperty('ACParaStyle', 'TAction', iptrw);
    RegisterProperty('ODMain', 'TOpenDialog', iptrw);
    RegisterProperty('SDMain', 'TSaveDialog', iptrw);
    RegisterProperty('ACFileSaveAs', 'TAction', iptrw);
    RegisterProperty('ToBSaveAs', 'TToolButton', iptrw);
    RegisterProperty('PrintSetupDialog', 'TKPrintSetupDialog', iptrw);
    RegisterProperty('PrintPreviewDialog', 'TKPrintPreviewDialog', iptrw);
    RegisterProperty('ACFormatCopy', 'TAction', iptrw);
    RegisterProperty('ACShowFormatting', 'TAction', iptrw);
    RegisterProperty('ToBShowFormatting', 'TToolButton', iptrw);
    RegisterProperty('ToBSep2', 'TToolButton', iptrw);
    RegisterProperty('ACInsertHyperlink', 'TAction', iptrw);
    RegisterProperty('ToBInsertHyperlink', 'TToolButton', iptrw);
    RegisterProperty('PMMain', 'TPopupMenu', iptrw);
    RegisterProperty('MIEditCopy', 'TMenuItem', iptrw);
    RegisterProperty('MIEditCut', 'TMenuItem', iptrw);
    RegisterProperty('MIEditPaste', 'TMenuItem', iptrw);
    RegisterProperty('N1', 'TMenuItem', iptrw);
    RegisterProperty('MIEditSelectAll', 'TMenuItem', iptrw);
    RegisterProperty('ACEditSelectAll', 'TKMemoEditSelectAllAction', iptrw);
    RegisterProperty('N2', 'TMenuItem', iptrw);
    RegisterProperty('MIFontStyle', 'TMenuItem', iptrw);
    RegisterProperty('MIParaStyle', 'TMenuItem', iptrw);
    RegisterProperty('MIEditHyperlink', 'TMenuItem', iptrw);
    RegisterProperty('N3', 'TMenuItem', iptrw);
    RegisterProperty('ACEditHyperlink', 'TAction', iptrw);
    RegisterProperty('ToBSecond', 'TToolBar', iptrw);
    RegisterProperty('ToBFormatCopy', 'TToolButton', iptrw);
    RegisterProperty('ToBSep4', 'TToolButton', iptrw);
    RegisterProperty('ToBFontBold', 'TToolButton', iptrw);
    RegisterProperty('ToBFontItalic', 'TToolButton', iptrw);
    RegisterProperty('ToBFontUnderline', 'TToolButton', iptrw);
    RegisterProperty('ToBFont', 'TToolButton', iptrw);
    RegisterProperty('ToBSep5', 'TToolButton', iptrw);
    RegisterProperty('ToBParaLeft', 'TToolButton', iptrw);
    RegisterProperty('ToBParaCenter', 'TToolButton', iptrw);
    RegisterProperty('ToBParaRight', 'TToolButton', iptrw);
    RegisterProperty('ToBParaIncIndent', 'TToolButton', iptrw);
    RegisterProperty('ToBParaDecIndent', 'TToolButton', iptrw);
    RegisterProperty('ToBParaNumbering', 'TToolButton', iptrw);
    RegisterProperty('ToBPara', 'TToolButton', iptrw);
    RegisterProperty('ToBFontSubscript', 'TToolButton', iptrw);
    RegisterProperty('ACFontSuperscript', 'TAction', iptrw);
    RegisterProperty('ACFontSubscript', 'TAction', iptrw);
    RegisterProperty('ToBFontSuperscript', 'TToolButton', iptrw);
    RegisterProperty('ToBSelectAll', 'TToolButton', iptrw);
    RegisterMethod('Procedure ACFileNewExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFileNewUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFileOpenExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFileSaveExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFileSaveUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFileSaveAsExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFilePrintExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFilePreviewExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFontBoldExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFontBoldUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFontStyleUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFontItalicExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFontItalicUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFontUnderlineExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFontUnderlineUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFontStrikeoutExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFontStrikeoutUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFontStyleExecute( Sender : TObject)');
    RegisterMethod('Procedure ACParaLeftExecute( Sender : TObject)');
    RegisterMethod('Procedure ACParaLeftUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACParaCenterUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACParaCenterExecute( Sender : TObject)');
    RegisterMethod('Procedure ACParaRightExecute( Sender : TObject)');
    RegisterMethod('Procedure ACParaRightUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACParaIncIndentUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACParaIncIndentExecute( Sender : TObject)');
    RegisterMethod('Procedure ACParaDecIndentExecute( Sender : TObject)');
    RegisterMethod('Procedure ACParaDecIndentUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACParaStyleUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACParaStyleExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFormatCopyExecute( Sender : TObject)');
    RegisterMethod('Procedure EditorMouseUp( Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure EditorDropFiles( Sender : TObject; X, Y : Integer; Files : TStrings)');
    RegisterMethod('Procedure ACShowFormattingExecute( Sender : TObject)');
    RegisterMethod('Procedure ACShowFormattingUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACInsertHyperlinkExecute( Sender : TObject)');
    RegisterMethod('Procedure ACEditHyperlinkUpdate( Sender : TObject)');
    RegisterMethod('Procedure EditorMouseDown( Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer)');
    RegisterMethod('Procedure ACParaNumberingExecute( Sender : TObject)');
    RegisterMethod('Procedure ACParaNumberingUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFontSuperscriptExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFontSuperscriptUpdate( Sender : TObject)');
    RegisterMethod('Procedure ACFontSubscriptExecute( Sender : TObject)');
    RegisterMethod('Procedure ACFontSubscriptUpdate( Sender : TObject)');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure CloseFile');
    RegisterMethod('Procedure OpenNewFile');
    RegisterMethod('Procedure OpenFile( FileName : TKString)');
    RegisterMethod('Function SaveFile( SaveAs, NeedAnotherOp : Boolean) : Boolean');
    RegisterProperty('NewFile', 'Boolean', iptr);
    RegisterProperty('LastFileName', 'TKString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_kmemofrm(CL: TPSPascalCompiler);
begin
  SIRegister_TKMemoFrame(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TKMemoFrameLastFileName_R(Self: TKMemoFrame; var T: TKString);
begin T := Self.LastFileName; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameNewFile_R(Self: TKMemoFrame; var T: Boolean);
begin T := Self.NewFile; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSelectAll_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBSelectAll := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSelectAll_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBSelectAll; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontSuperscript_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBFontSuperscript := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontSuperscript_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBFontSuperscript; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontSubscript_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFontSubscript := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontSubscript_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFontSubscript; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontSuperscript_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFontSuperscript := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontSuperscript_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFontSuperscript; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontSubscript_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBFontSubscript := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontSubscript_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBFontSubscript; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBPara_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBPara := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBPara_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBPara; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaNumbering_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBParaNumbering := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaNumbering_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBParaNumbering; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaDecIndent_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBParaDecIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaDecIndent_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBParaDecIndent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaIncIndent_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBParaIncIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaIncIndent_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBParaIncIndent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaRight_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBParaRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaRight_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBParaRight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaCenter_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBParaCenter := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaCenter_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBParaCenter; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaLeft_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBParaLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBParaLeft_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBParaLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep5_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBSep5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep5_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBSep5; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFont_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFont_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBFont; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontUnderline_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBFontUnderline := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontUnderline_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBFontUnderline; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontItalic_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBFontItalic := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontItalic_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBFontItalic; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontBold_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBFontBold := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFontBold_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBFontBold; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep4_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBSep4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep4_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBSep4; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFormatCopy_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBFormatCopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFormatCopy_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBFormatCopy; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSecond_W(Self: TKMemoFrame; const T: TToolBar);
Begin Self.ToBSecond := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSecond_R(Self: TKMemoFrame; var T: TToolBar);
Begin T := Self.ToBSecond; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditHyperlink_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACEditHyperlink := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditHyperlink_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACEditHyperlink; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameN3_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.N3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameN3_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.N3; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditHyperlink_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.MIEditHyperlink := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditHyperlink_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.MIEditHyperlink; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIParaStyle_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.MIParaStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIParaStyle_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.MIParaStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIFontStyle_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.MIFontStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIFontStyle_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.MIFontStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameN2_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.N2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameN2_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.N2; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditSelectAll_W(Self: TKMemoFrame; const T: TKMemoEditSelectAllAction);
Begin Self.ACEditSelectAll := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditSelectAll_R(Self: TKMemoFrame; var T: TKMemoEditSelectAllAction);
Begin T := Self.ACEditSelectAll; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditSelectAll_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.MIEditSelectAll := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditSelectAll_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.MIEditSelectAll; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameN1_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.N1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameN1_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.N1; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditPaste_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.MIEditPaste := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditPaste_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.MIEditPaste; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditCut_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.MIEditCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditCut_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.MIEditCut; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditCopy_W(Self: TKMemoFrame; const T: TMenuItem);
Begin Self.MIEditCopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameMIEditCopy_R(Self: TKMemoFrame; var T: TMenuItem);
Begin T := Self.MIEditCopy; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFramePMMain_W(Self: TKMemoFrame; const T: TPopupMenu);
Begin Self.PMMain := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFramePMMain_R(Self: TKMemoFrame; var T: TPopupMenu);
Begin T := Self.PMMain; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBInsertHyperlink_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBInsertHyperlink := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBInsertHyperlink_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBInsertHyperlink; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACInsertHyperlink_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACInsertHyperlink := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACInsertHyperlink_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACInsertHyperlink; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep2_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBSep2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep2_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBSep2; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBShowFormatting_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBShowFormatting := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBShowFormatting_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBShowFormatting; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACShowFormatting_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACShowFormatting := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACShowFormatting_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACShowFormatting; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFormatCopy_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFormatCopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFormatCopy_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFormatCopy; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFramePrintPreviewDialog_W(Self: TKMemoFrame; const T: TKPrintPreviewDialog);
Begin Self.PrintPreviewDialog := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFramePrintPreviewDialog_R(Self: TKMemoFrame; var T: TKPrintPreviewDialog);
Begin T := Self.PrintPreviewDialog; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFramePrintSetupDialog_W(Self: TKMemoFrame; const T: TKPrintSetupDialog);
Begin Self.PrintSetupDialog := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFramePrintSetupDialog_R(Self: TKMemoFrame; var T: TKPrintSetupDialog);
Begin T := Self.PrintSetupDialog; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSaveAs_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBSaveAs := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSaveAs_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBSaveAs; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFileSaveAs_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFileSaveAs := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFileSaveAs_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFileSaveAs; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameSDMain_W(Self: TKMemoFrame; const T: TSaveDialog);
Begin Self.SDMain := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameSDMain_R(Self: TKMemoFrame; var T: TSaveDialog);
Begin T := Self.SDMain; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameODMain_W(Self: TKMemoFrame; const T: TOpenDialog);
Begin Self.ODMain := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameODMain_R(Self: TKMemoFrame; var T: TOpenDialog);
Begin T := Self.ODMain; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaStyle_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACParaStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaStyle_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACParaStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaDecIndent_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACParaDecIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaDecIndent_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACParaDecIndent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaIncIndent_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACParaIncIndent := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaIncIndent_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACParaIncIndent; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaRight_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACParaRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaRight_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACParaRight; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaCenter_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACParaCenter := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaCenter_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACParaCenter; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaLeft_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACParaLeft := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaLeft_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACParaLeft; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontStyle_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFontStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontStyle_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFontStyle; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontStrikeout_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFontStrikeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontStrikeout_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFontStrikeout; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontUnderline_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFontUnderline := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontUnderline_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFontUnderline; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontItalic_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFontItalic := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontItalic_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFontItalic; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontBold_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFontBold := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFontBold_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFontBold; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFilePreview_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFilePreview := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFilePreview_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFilePreview; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFileSave_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFileSave := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFileSave_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFileSave; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFilePrint_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFilePrint := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFilePrint_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFilePrint; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFileNew_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFileNew := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFileNew_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFileNew; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFileOpen_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACFileOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACFileOpen_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACFileOpen; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditPaste_W(Self: TKMemoFrame; const T: TKMemoEditPasteAction);
Begin Self.ACEditPaste := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditPaste_R(Self: TKMemoFrame; var T: TKMemoEditPasteAction);
Begin T := Self.ACEditPaste; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditCut_W(Self: TKMemoFrame; const T: TKMemoEditCutAction);
Begin Self.ACEditCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditCut_R(Self: TKMemoFrame; var T: TKMemoEditCutAction);
Begin T := Self.ACEditCut; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditCopy_W(Self: TKMemoFrame; const T: TKMemoEditCopyAction);
Begin Self.ACEditCopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACEditCopy_R(Self: TKMemoFrame; var T: TKMemoEditCopyAction);
Begin T := Self.ACEditCopy; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameALMain_W(Self: TKMemoFrame; const T: TActionList);
Begin Self.ALMain := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameALMain_R(Self: TKMemoFrame; var T: TActionList);
Begin T := Self.ALMain; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep3_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBSep3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep3_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBSep3; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBPreview_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBPreview := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBPreview_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBPreview; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBPrint_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBPrint := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBPrint_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBPrint; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBPaste_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBPaste := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBPaste_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBPaste; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBCopy_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBCopy := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBCopy_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBCopy; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBCut_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBCut := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBCut_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBCut; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep1_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBSep1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSep1_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBSep1; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSave_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBSave := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBSave_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBSave; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBOpen_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBOpen_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBOpen; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBNew_W(Self: TKMemoFrame; const T: TToolButton);
Begin Self.ToBNew := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBNew_R(Self: TKMemoFrame; var T: TToolButton);
Begin T := Self.ToBNew; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFirst_W(Self: TKMemoFrame; const T: TToolBar);
Begin Self.ToBFirst := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameToBFirst_R(Self: TKMemoFrame; var T: TToolBar);
Begin T := Self.ToBFirst; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameILMain_W(Self: TKMemoFrame; const T: TImageList);
Begin Self.ILMain := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameILMain_R(Self: TKMemoFrame; var T: TImageList);
Begin T := Self.ILMain; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameEditor_W(Self: TKMemoFrame; const T: TKMemo);
Begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameEditor_R(Self: TKMemoFrame; var T: TKMemo);
Begin T := Self.Editor; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaNumbering_W(Self: TKMemoFrame; const T: TAction);
Begin Self.ACParaNumbering := T; end;

(*----------------------------------------------------------------------------*)
procedure TKMemoFrameACParaNumbering_R(Self: TKMemoFrame; var T: TAction);
Begin T := Self.ACParaNumbering; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKMemoFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKMemoFrame) do
  begin
    RegisterPropertyHelper(@TKMemoFrameACParaNumbering_R,@TKMemoFrameACParaNumbering_W,'ACParaNumbering');
    RegisterPropertyHelper(@TKMemoFrameEditor_R,@TKMemoFrameEditor_W,'Editor');
    RegisterPropertyHelper(@TKMemoFrameILMain_R,@TKMemoFrameILMain_W,'ILMain');
    RegisterPropertyHelper(@TKMemoFrameToBFirst_R,@TKMemoFrameToBFirst_W,'ToBFirst');
    RegisterPropertyHelper(@TKMemoFrameToBNew_R,@TKMemoFrameToBNew_W,'ToBNew');
    RegisterPropertyHelper(@TKMemoFrameToBOpen_R,@TKMemoFrameToBOpen_W,'ToBOpen');
    RegisterPropertyHelper(@TKMemoFrameToBSave_R,@TKMemoFrameToBSave_W,'ToBSave');
    RegisterPropertyHelper(@TKMemoFrameToBSep1_R,@TKMemoFrameToBSep1_W,'ToBSep1');
    RegisterPropertyHelper(@TKMemoFrameToBCut_R,@TKMemoFrameToBCut_W,'ToBCut');
    RegisterPropertyHelper(@TKMemoFrameToBCopy_R,@TKMemoFrameToBCopy_W,'ToBCopy');
    RegisterPropertyHelper(@TKMemoFrameToBPaste_R,@TKMemoFrameToBPaste_W,'ToBPaste');
    RegisterPropertyHelper(@TKMemoFrameToBPrint_R,@TKMemoFrameToBPrint_W,'ToBPrint');
    RegisterPropertyHelper(@TKMemoFrameToBPreview_R,@TKMemoFrameToBPreview_W,'ToBPreview');
    RegisterPropertyHelper(@TKMemoFrameToBSep3_R,@TKMemoFrameToBSep3_W,'ToBSep3');
    RegisterPropertyHelper(@TKMemoFrameALMain_R,@TKMemoFrameALMain_W,'ALMain');
    RegisterPropertyHelper(@TKMemoFrameACEditCopy_R,@TKMemoFrameACEditCopy_W,'ACEditCopy');
    RegisterPropertyHelper(@TKMemoFrameACEditCut_R,@TKMemoFrameACEditCut_W,'ACEditCut');
    RegisterPropertyHelper(@TKMemoFrameACEditPaste_R,@TKMemoFrameACEditPaste_W,'ACEditPaste');
    RegisterPropertyHelper(@TKMemoFrameACFileOpen_R,@TKMemoFrameACFileOpen_W,'ACFileOpen');
    RegisterPropertyHelper(@TKMemoFrameACFileNew_R,@TKMemoFrameACFileNew_W,'ACFileNew');
    RegisterPropertyHelper(@TKMemoFrameACFilePrint_R,@TKMemoFrameACFilePrint_W,'ACFilePrint');
    RegisterPropertyHelper(@TKMemoFrameACFileSave_R,@TKMemoFrameACFileSave_W,'ACFileSave');
    RegisterPropertyHelper(@TKMemoFrameACFilePreview_R,@TKMemoFrameACFilePreview_W,'ACFilePreview');
    RegisterPropertyHelper(@TKMemoFrameACFontBold_R,@TKMemoFrameACFontBold_W,'ACFontBold');
    RegisterPropertyHelper(@TKMemoFrameACFontItalic_R,@TKMemoFrameACFontItalic_W,'ACFontItalic');
    RegisterPropertyHelper(@TKMemoFrameACFontUnderline_R,@TKMemoFrameACFontUnderline_W,'ACFontUnderline');
    RegisterPropertyHelper(@TKMemoFrameACFontStrikeout_R,@TKMemoFrameACFontStrikeout_W,'ACFontStrikeout');
    RegisterPropertyHelper(@TKMemoFrameACFontStyle_R,@TKMemoFrameACFontStyle_W,'ACFontStyle');
    RegisterPropertyHelper(@TKMemoFrameACParaLeft_R,@TKMemoFrameACParaLeft_W,'ACParaLeft');
    RegisterPropertyHelper(@TKMemoFrameACParaCenter_R,@TKMemoFrameACParaCenter_W,'ACParaCenter');
    RegisterPropertyHelper(@TKMemoFrameACParaRight_R,@TKMemoFrameACParaRight_W,'ACParaRight');
    RegisterPropertyHelper(@TKMemoFrameACParaIncIndent_R,@TKMemoFrameACParaIncIndent_W,'ACParaIncIndent');
    RegisterPropertyHelper(@TKMemoFrameACParaDecIndent_R,@TKMemoFrameACParaDecIndent_W,'ACParaDecIndent');
    RegisterPropertyHelper(@TKMemoFrameACParaStyle_R,@TKMemoFrameACParaStyle_W,'ACParaStyle');
    RegisterPropertyHelper(@TKMemoFrameODMain_R,@TKMemoFrameODMain_W,'ODMain');
    RegisterPropertyHelper(@TKMemoFrameSDMain_R,@TKMemoFrameSDMain_W,'SDMain');
    RegisterPropertyHelper(@TKMemoFrameACFileSaveAs_R,@TKMemoFrameACFileSaveAs_W,'ACFileSaveAs');
    RegisterPropertyHelper(@TKMemoFrameToBSaveAs_R,@TKMemoFrameToBSaveAs_W,'ToBSaveAs');
    RegisterPropertyHelper(@TKMemoFramePrintSetupDialog_R,@TKMemoFramePrintSetupDialog_W,'PrintSetupDialog');
    RegisterPropertyHelper(@TKMemoFramePrintPreviewDialog_R,@TKMemoFramePrintPreviewDialog_W,'PrintPreviewDialog');
    RegisterPropertyHelper(@TKMemoFrameACFormatCopy_R,@TKMemoFrameACFormatCopy_W,'ACFormatCopy');
    RegisterPropertyHelper(@TKMemoFrameACShowFormatting_R,@TKMemoFrameACShowFormatting_W,'ACShowFormatting');
    RegisterPropertyHelper(@TKMemoFrameToBShowFormatting_R,@TKMemoFrameToBShowFormatting_W,'ToBShowFormatting');
    RegisterPropertyHelper(@TKMemoFrameToBSep2_R,@TKMemoFrameToBSep2_W,'ToBSep2');
    RegisterPropertyHelper(@TKMemoFrameACInsertHyperlink_R,@TKMemoFrameACInsertHyperlink_W,'ACInsertHyperlink');
    RegisterPropertyHelper(@TKMemoFrameToBInsertHyperlink_R,@TKMemoFrameToBInsertHyperlink_W,'ToBInsertHyperlink');
    RegisterPropertyHelper(@TKMemoFramePMMain_R,@TKMemoFramePMMain_W,'PMMain');
    RegisterPropertyHelper(@TKMemoFrameMIEditCopy_R,@TKMemoFrameMIEditCopy_W,'MIEditCopy');
    RegisterPropertyHelper(@TKMemoFrameMIEditCut_R,@TKMemoFrameMIEditCut_W,'MIEditCut');
    RegisterPropertyHelper(@TKMemoFrameMIEditPaste_R,@TKMemoFrameMIEditPaste_W,'MIEditPaste');
    RegisterPropertyHelper(@TKMemoFrameN1_R,@TKMemoFrameN1_W,'N1');
    RegisterPropertyHelper(@TKMemoFrameMIEditSelectAll_R,@TKMemoFrameMIEditSelectAll_W,'MIEditSelectAll');
    RegisterPropertyHelper(@TKMemoFrameACEditSelectAll_R,@TKMemoFrameACEditSelectAll_W,'ACEditSelectAll');
    RegisterPropertyHelper(@TKMemoFrameN2_R,@TKMemoFrameN2_W,'N2');
    RegisterPropertyHelper(@TKMemoFrameMIFontStyle_R,@TKMemoFrameMIFontStyle_W,'MIFontStyle');
    RegisterPropertyHelper(@TKMemoFrameMIParaStyle_R,@TKMemoFrameMIParaStyle_W,'MIParaStyle');
    RegisterPropertyHelper(@TKMemoFrameMIEditHyperlink_R,@TKMemoFrameMIEditHyperlink_W,'MIEditHyperlink');
    RegisterPropertyHelper(@TKMemoFrameN3_R,@TKMemoFrameN3_W,'N3');
    RegisterPropertyHelper(@TKMemoFrameACEditHyperlink_R,@TKMemoFrameACEditHyperlink_W,'ACEditHyperlink');
    RegisterPropertyHelper(@TKMemoFrameToBSecond_R,@TKMemoFrameToBSecond_W,'ToBSecond');
    RegisterPropertyHelper(@TKMemoFrameToBFormatCopy_R,@TKMemoFrameToBFormatCopy_W,'ToBFormatCopy');
    RegisterPropertyHelper(@TKMemoFrameToBSep4_R,@TKMemoFrameToBSep4_W,'ToBSep4');
    RegisterPropertyHelper(@TKMemoFrameToBFontBold_R,@TKMemoFrameToBFontBold_W,'ToBFontBold');
    RegisterPropertyHelper(@TKMemoFrameToBFontItalic_R,@TKMemoFrameToBFontItalic_W,'ToBFontItalic');
    RegisterPropertyHelper(@TKMemoFrameToBFontUnderline_R,@TKMemoFrameToBFontUnderline_W,'ToBFontUnderline');
    RegisterPropertyHelper(@TKMemoFrameToBFont_R,@TKMemoFrameToBFont_W,'ToBFont');
    RegisterPropertyHelper(@TKMemoFrameToBSep5_R,@TKMemoFrameToBSep5_W,'ToBSep5');
    RegisterPropertyHelper(@TKMemoFrameToBParaLeft_R,@TKMemoFrameToBParaLeft_W,'ToBParaLeft');
    RegisterPropertyHelper(@TKMemoFrameToBParaCenter_R,@TKMemoFrameToBParaCenter_W,'ToBParaCenter');
    RegisterPropertyHelper(@TKMemoFrameToBParaRight_R,@TKMemoFrameToBParaRight_W,'ToBParaRight');
    RegisterPropertyHelper(@TKMemoFrameToBParaIncIndent_R,@TKMemoFrameToBParaIncIndent_W,'ToBParaIncIndent');
    RegisterPropertyHelper(@TKMemoFrameToBParaDecIndent_R,@TKMemoFrameToBParaDecIndent_W,'ToBParaDecIndent');
    RegisterPropertyHelper(@TKMemoFrameToBParaNumbering_R,@TKMemoFrameToBParaNumbering_W,'ToBParaNumbering');
    RegisterPropertyHelper(@TKMemoFrameToBPara_R,@TKMemoFrameToBPara_W,'ToBPara');
    RegisterPropertyHelper(@TKMemoFrameToBFontSubscript_R,@TKMemoFrameToBFontSubscript_W,'ToBFontSubscript');
    RegisterPropertyHelper(@TKMemoFrameACFontSuperscript_R,@TKMemoFrameACFontSuperscript_W,'ACFontSuperscript');
    RegisterPropertyHelper(@TKMemoFrameACFontSubscript_R,@TKMemoFrameACFontSubscript_W,'ACFontSubscript');
    RegisterPropertyHelper(@TKMemoFrameToBFontSuperscript_R,@TKMemoFrameToBFontSuperscript_W,'ToBFontSuperscript');
    RegisterPropertyHelper(@TKMemoFrameToBSelectAll_R,@TKMemoFrameToBSelectAll_W,'ToBSelectAll');
    RegisterMethod(@TKMemoFrame.ACFileNewExecute, 'ACFileNewExecute');
    RegisterMethod(@TKMemoFrame.ACFileNewUpdate, 'ACFileNewUpdate');
    RegisterMethod(@TKMemoFrame.ACFileOpenExecute, 'ACFileOpenExecute');
    RegisterMethod(@TKMemoFrame.ACFileSaveExecute, 'ACFileSaveExecute');
    RegisterMethod(@TKMemoFrame.ACFileSaveUpdate, 'ACFileSaveUpdate');
    RegisterMethod(@TKMemoFrame.ACFileSaveAsExecute, 'ACFileSaveAsExecute');
    RegisterMethod(@TKMemoFrame.ACFilePrintExecute, 'ACFilePrintExecute');
    RegisterMethod(@TKMemoFrame.ACFilePreviewExecute, 'ACFilePreviewExecute');
    RegisterMethod(@TKMemoFrame.ACFontBoldExecute, 'ACFontBoldExecute');
    RegisterMethod(@TKMemoFrame.ACFontBoldUpdate, 'ACFontBoldUpdate');
    RegisterMethod(@TKMemoFrame.ACFontStyleUpdate, 'ACFontStyleUpdate');
    RegisterMethod(@TKMemoFrame.ACFontItalicExecute, 'ACFontItalicExecute');
    RegisterMethod(@TKMemoFrame.ACFontItalicUpdate, 'ACFontItalicUpdate');
    RegisterMethod(@TKMemoFrame.ACFontUnderlineExecute, 'ACFontUnderlineExecute');
    RegisterMethod(@TKMemoFrame.ACFontUnderlineUpdate, 'ACFontUnderlineUpdate');
    RegisterMethod(@TKMemoFrame.ACFontStrikeoutExecute, 'ACFontStrikeoutExecute');
    RegisterMethod(@TKMemoFrame.ACFontStrikeoutUpdate, 'ACFontStrikeoutUpdate');
    RegisterMethod(@TKMemoFrame.ACFontStyleExecute, 'ACFontStyleExecute');
    RegisterMethod(@TKMemoFrame.ACParaLeftExecute, 'ACParaLeftExecute');
    RegisterMethod(@TKMemoFrame.ACParaLeftUpdate, 'ACParaLeftUpdate');
    RegisterMethod(@TKMemoFrame.ACParaCenterUpdate, 'ACParaCenterUpdate');
    RegisterMethod(@TKMemoFrame.ACParaCenterExecute, 'ACParaCenterExecute');
    RegisterMethod(@TKMemoFrame.ACParaRightExecute, 'ACParaRightExecute');
    RegisterMethod(@TKMemoFrame.ACParaRightUpdate, 'ACParaRightUpdate');
    RegisterMethod(@TKMemoFrame.ACParaIncIndentUpdate, 'ACParaIncIndentUpdate');
    RegisterMethod(@TKMemoFrame.ACParaIncIndentExecute, 'ACParaIncIndentExecute');
    RegisterMethod(@TKMemoFrame.ACParaDecIndentExecute, 'ACParaDecIndentExecute');
    RegisterMethod(@TKMemoFrame.ACParaDecIndentUpdate, 'ACParaDecIndentUpdate');
    RegisterMethod(@TKMemoFrame.ACParaStyleUpdate, 'ACParaStyleUpdate');
    RegisterMethod(@TKMemoFrame.ACParaStyleExecute, 'ACParaStyleExecute');
    RegisterMethod(@TKMemoFrame.ACFormatCopyExecute, 'ACFormatCopyExecute');
    RegisterMethod(@TKMemoFrame.EditorMouseUp, 'EditorMouseUp');
    RegisterMethod(@TKMemoFrame.EditorDropFiles, 'EditorDropFiles');
    RegisterMethod(@TKMemoFrame.ACShowFormattingExecute, 'ACShowFormattingExecute');
    RegisterMethod(@TKMemoFrame.ACShowFormattingUpdate, 'ACShowFormattingUpdate');
    RegisterMethod(@TKMemoFrame.ACInsertHyperlinkExecute, 'ACInsertHyperlinkExecute');
    RegisterMethod(@TKMemoFrame.ACEditHyperlinkUpdate, 'ACEditHyperlinkUpdate');
    RegisterMethod(@TKMemoFrame.EditorMouseDown, 'EditorMouseDown');
    RegisterMethod(@TKMemoFrame.ACParaNumberingExecute, 'ACParaNumberingExecute');
    RegisterMethod(@TKMemoFrame.ACParaNumberingUpdate, 'ACParaNumberingUpdate');
    RegisterMethod(@TKMemoFrame.ACFontSuperscriptExecute, 'ACFontSuperscriptExecute');
    RegisterMethod(@TKMemoFrame.ACFontSuperscriptUpdate, 'ACFontSuperscriptUpdate');
    RegisterMethod(@TKMemoFrame.ACFontSubscriptExecute, 'ACFontSubscriptExecute');
    RegisterMethod(@TKMemoFrame.ACFontSubscriptUpdate, 'ACFontSubscriptUpdate');
    RegisterConstructor(@TKMemoFrame.Create, 'Create');
    RegisterMethod(@TKMemoFrame.CloseFile, 'CloseFile');
    RegisterMethod(@TKMemoFrame.OpenNewFile, 'OpenNewFile');
    RegisterMethod(@TKMemoFrame.OpenFile, 'OpenFile');
    RegisterMethod(@TKMemoFrame.SaveFile, 'SaveFile');
    RegisterPropertyHelper(@TKMemoFrameNewFile_R,nil,'NewFile');
    RegisterPropertyHelper(@TKMemoFrameLastFileName_R,nil,'LastFileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_kmemofrm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TKMemoFrame(CL);
end;

 
 
{ TPSImport_kmemofrm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_kmemofrm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_kmemofrm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_kmemofrm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_kmemofrm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
