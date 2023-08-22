unit uPSI_ExtCtrls2;
{
   enhance to extctrls also tsplitter  and collections  , add constructors
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
  TPSImport_ExtCtrls2 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTrayIcon(CL: TPSPascalCompiler);
procedure SIRegister_TColorListBox(CL: TPSPascalCompiler);
procedure SIRegister_TCustomColorListBox(CL: TPSPascalCompiler);
procedure SIRegister_TColorBox(CL: TPSPascalCompiler);
procedure SIRegister_TCustomColorBox(CL: TPSPascalCompiler);
procedure SIRegister_TLabeledEdit(CL: TPSPascalCompiler);
procedure SIRegister_TCustomLabeledEdit(CL: TPSPascalCompiler);
procedure SIRegister_TBoundLabel(CL: TPSPascalCompiler);
procedure SIRegister_TControlBar(CL: TPSPascalCompiler);
procedure SIRegister_TCustomControlBar(CL: TPSPascalCompiler);
procedure SIRegister_TSplitter(CL: TPSPascalCompiler);
//procedure SIRegister_TRadioGroup(CL: TPSPascalCompiler);     in upsc_extctrls
//procedure SIRegister_TCustomRadioGroup(CL: TPSPascalCompiler);
//procedure SIRegister_THeader(CL: TPSPascalCompiler);
//procedure SIRegister_TNotebook(CL: TPSPascalCompiler);
//procedure SIRegister_TPage(CL: TPSPascalCompiler);
procedure SIRegister_TGridPanel(CL: TPSPascalCompiler);
procedure SIRegister_TCustomGridPanel(CL: TPSPascalCompiler);
procedure SIRegister_TControlCollection(CL: TPSPascalCompiler);
procedure SIRegister_TControlItem(CL: TPSPascalCompiler);
procedure SIRegister_TColumnCollection(CL: TPSPascalCompiler);
procedure SIRegister_TRowCollection(CL: TPSPascalCompiler);
procedure SIRegister_TCellCollection(CL: TPSPascalCompiler);
procedure SIRegister_TCellItem(CL: TPSPascalCompiler);
procedure SIRegister_TFlowPanel(CL: TPSPascalCompiler);
procedure SIRegister_TCustomFlowPanel(CL: TPSPascalCompiler);
//procedure SIRegister_TPanel(CL: TPSPascalCompiler);
//procedure SIRegister_TCustomPanel(CL: TPSPascalCompiler);
//procedure SIRegister_TTimer(CL: TPSPascalCompiler);
//procedure SIRegister_TBevel(CL: TPSPascalCompiler);
//procedure SIRegister_TImage(CL: TPSPascalCompiler);
//procedure SIRegister_TPaintBox(CL: TPSPascalCompiler);
//procedure SIRegister_TShape(CL: TPSPascalCompiler);
procedure SIRegister_ExtCtrls2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ExtCtrls2_Routines(S: TPSExec);
procedure RIRegister_TTrayIcon(CL: TPSRuntimeClassImporter);
procedure RIRegister_TColorListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomColorListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TColorBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomColorBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLabeledEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomLabeledEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBoundLabel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TControlBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomControlBar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSplitter(CL: TPSRuntimeClassImporter);
{procedure RIRegister_TRadioGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomRadioGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_THeader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNotebook(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPage(CL: TPSRuntimeClassImporter);}
procedure RIRegister_TGridPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomGridPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TControlCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TControlItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TColumnCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRowCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCellCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCellItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFlowPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomFlowPanel(CL: TPSRuntimeClassImporter);
{procedure RIRegister_TPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomPanel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTimer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBevel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPaintBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TShape(CL: TPSRuntimeClassImporter); }
procedure RIRegister_ExtCtrls2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // Messages
  Windows
  ,Contnrs
  ,Controls
  ,Forms
  //,Menus
  ,Graphics
  ,StdCtrls
  ,GraphUtil
  //,ShellApi
  ,ExtCtrls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ExtCtrls2]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTrayIcon(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTrayIcon', 'TTrayIcon') do
  with CL.AddClassN(CL.FindClass('TCustomTrayIcon'),'TTrayIcon') do begin
   RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TColorListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomColorListBox', 'TColorListBox') do
  with CL.AddClassN(CL.FindClass('TCustomColorListBox'),'TColorListBox') do begin
   RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
       RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
    RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomColorListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomListBox', 'TCustomColorListBox') do
  with CL.AddClassN(CL.FindClass('TCustomListBox'),'TCustomColorListBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Style', 'TColorBoxStyle', iptrw);
    RegisterProperty('Colors', 'TColor Integer', iptr);
    RegisterProperty('ColorNames', 'string Integer', iptr);
    RegisterProperty('Selected', 'TColor', iptrw);
    RegisterProperty('DefaultColorColor', 'TColor', iptrw);
    RegisterProperty('NoneColorColor', 'TColor', iptrw);
    RegisterProperty('OnGetColors', 'TLBGetColorsEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TColorBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomColorBox', 'TColorBox') do
  with CL.AddClassN(CL.FindClass('TCustomColorBox'),'TColorBox') do begin
  RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
       RegisterProperty('Style', 'TColorBoxStyle', iptrw);
    RegisterProperty('Colors', 'TColor Integer', iptr);
    RegisterProperty('ColorNames', 'string Integer', iptr);
    RegisterProperty('Selected', 'TColor', iptrw);
    RegisterProperty('DefaultColorColor', 'TColor', iptrw);
    RegisterProperty('NoneColorColor', 'TColor', iptrw);
    RegisterProperty('OnGetColors', 'TLBGetColorsEvent', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
    RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);

   end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomColorBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComboBox', 'TCustomColorBox') do
  with CL.AddClassN(CL.FindClass('TCustomComboBox'),'TCustomColorBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Style', 'TColorBoxStyle', iptrw);
    RegisterProperty('Colors', 'TColor Integer', iptr);
    RegisterProperty('ColorNames', 'string Integer', iptr);
    RegisterProperty('Selected', 'TColor', iptrw);
    RegisterProperty('DefaultColorColor', 'TColor', iptrw);
    RegisterProperty('NoneColorColor', 'TColor', iptrw);
    RegisterProperty('OnGetColors', 'TGetColorsEvent', iptrw);
  end;
end;

//standard package property
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLabeledEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomLabeledEdit', 'TLabeledEdit') do
  with CL.AddClassN(CL.FindClass('TCustomLabeledEdit'),'TLabeledEdit') do begin
   RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);

     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
      RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
 
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomLabeledEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomEdit', 'TCustomLabeledEdit') do
  with CL.AddClassN(CL.FindClass('TCustomEdit'),'TCustomLabeledEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetBounds( ALeft : Integer; ATop : Integer; AWidth : Integer; AHeight : Integer)');
    RegisterMethod('Procedure SetupInternalLabel');
    RegisterProperty('EditLabel', 'TBoundLabel', iptr);
    RegisterProperty('LabelPosition', 'TLabelPosition', iptrw);
    RegisterProperty('LabelSpacing', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBoundLabel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomLabel', 'TBoundLabel') do
  with CL.AddClassN(CL.FindClass('TCustomLabel'),'TBoundLabel') do
  begin
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Left', 'Integer', iptr);
    RegisterProperty('Top', 'Integer', iptr);
    RegisterProperty('Width', 'Integer', iptrw);

    RegisterPublishedProperties;
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TControlBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControlBar', 'TControlBar') do
  with CL.AddClassN(CL.FindClass('TCustomControlBar'),'TControlBar') do begin
  RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
        RegisterPublishedProperties;
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomControlBar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCustomControlBar') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCustomControlBar') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure FlipChildren( AllLevels : Boolean)');
    RegisterMethod('Procedure StickControls');
    RegisterProperty('Picture', 'TPicture', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSplitter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TSplitter') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TSplitter') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Canvas', 'TCanvas', iptrw);
     RegisterPublishedProperties;
    RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('AutoSnap', 'Boolean', iptrw);
    RegisterProperty('Beveled', 'Boolean', iptrw);
    RegisterProperty('MinSize', 'NaturalNumber', iptrw);
    RegisterProperty('ResizeStyle', 'TResizeStyle', iptrw);
    RegisterProperty('OnCanResize', 'TCanResizeEvent', iptrw);
    RegisterProperty('OnMoved', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPaint', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRadioGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRadioGroup', 'TRadioGroup') do
  with CL.AddClassN(CL.FindClass('TCustomRadioGroup'),'TRadioGroup') do begin
   RegisterPublishedProperties;
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);
      RegisterProperty('ItemIndex', 'Integer', iptrw);
    RegisterProperty('Items', 'TStrings', iptrw);
    //RegisterProperty('Items', 'TStrings Integer', iptrw);
     RegisterProperty('Columns', 'Integer', iptrw);
    //SetDefaultPropery('Items');

    {   property ItemIndex;
    property Items;
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItems write SetItems; }


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomRadioGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGroupBox', 'TCustomRadioGroup') do
  with CL.AddClassN(CL.FindClass('TCustomGroupBox'),'TCustomRadioGroup') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure FlipChildren( AllLevels : Boolean)');
    RegisterProperty('Buttons', 'TRadioButton Integer', iptr);
    RegisterMethod('Procedure Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THeader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'THeader') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'THeader') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('SectionWidth', 'Integer Integer', iptrw);
    RegisterProperty('AllowResize', 'Boolean', iptrw);
    RegisterProperty('BorderStyle', 'TBorderStyle', iptrw);
    RegisterProperty('Sections', 'TStrings', iptrw);
    RegisterProperty('OnSizing', 'TSectionEvent', iptrw);
    RegisterProperty('OnSized', 'TSectionEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNotebook(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TNotebook') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TNotebook') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ActivePage', 'string', iptrw);
    RegisterProperty('PageIndex', 'Integer', iptrw);
    RegisterProperty('Pages', 'TStrings', iptrw);
    RegisterProperty('OnPageChanged', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TPage') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TPage') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGridPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomGridPanel', 'TGridPanel') do
  with CL.AddClassN(CL.FindClass('TCustomGridPanel'),'TGridPanel') do begin
    RegisterPublishedProperties;
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomGridPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanel', 'TCustomGridPanel') do
  with CL.AddClassN(CL.FindClass('TCustomPanel'),'TCustomGridPanel') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
     RegisterMethod('Procedure GetChildren( Proc : TGetChildProc; Root : TComponent)');
    RegisterMethod('Function IsColumnEmpty( AColumn : Integer) : Boolean');
    RegisterMethod('Function IsRowEmpty( ARow : Integer) : Boolean');
    RegisterProperty('ColumnSpanIndex', 'Integer Integer Integer', iptr);
    RegisterProperty('CellCount', 'Integer', iptr);
    RegisterProperty('CellSize', 'TPoint Integer Integer', iptr);
    RegisterProperty('CellRect', 'TRect Integer Integer', iptr);
    RegisterProperty('ColumnCollection', 'TColumnCollection', iptrw);
    RegisterProperty('ControlCollection', 'TControlCollection', iptrw);
    RegisterProperty('ExpandStyle', 'TExpandStyle', iptrw);
    RegisterProperty('RowCollection', 'TRowCollection', iptrw);
    RegisterProperty('RowSpanIndex', 'Integer Integer Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TControlCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TControlCollection') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TControlCollection') do begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Function Add : TControlItem');
    RegisterMethod('Procedure AddControl( AControl : TControl; AColumn : Integer; ARow : Integer)');
    RegisterMethod('Procedure RemoveControl( AControl : TControl)');
    RegisterMethod('Function IndexOf( AControl : TControl) : Integer');
    RegisterMethod('Function Owner : TCustomGridPanel');
    RegisterProperty('Controls', 'TControl Integer Integer', iptrw);
    RegisterProperty('ControlItems', 'TControlItem Integer Integer', iptr);
    RegisterProperty('Items', 'TControlItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TControlItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TControlItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TControlItem') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure SetLocation( AColumn, ARow : Integer; APushed : Boolean)');
    RegisterProperty('Column', 'Integer', iptrw);
    RegisterProperty('ColumnSpan', 'TCellSpan', iptrw);
    RegisterProperty('Control', 'TControl', iptrw);
    RegisterProperty('Row', 'Integer', iptrw);
    RegisterProperty('RowSpan', 'TCellSpan', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TColumnCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCellCollection', 'TColumnCollection') do
  with CL.AddClassN(CL.FindClass('TCellCollection'),'TColumnCollection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Function Add : TColumnItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRowCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCellCollection', 'TRowCollection') do
  with CL.AddClassN(CL.FindClass('TCellCollection'),'TRowCollection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Function Add : TRowItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCellCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TCellCollection') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TCellCollection') do
  begin
    RegisterMethod('Function Owner : TCustomGridPanel');
    RegisterProperty('Items', 'TCellItem Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCellItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TCellItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TCellItem') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterProperty('SizeStyle', 'TSizeStyle', iptrw);
    RegisterProperty('Value', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFlowPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomFlowPanel', 'TFlowPanel') do
  with CL.AddClassN(CL.FindClass('TCustomFlowPanel'),'TFlowPanel') do begin
    RegisterPublishedProperties;
   RegisterProperty('ONCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONENTER', 'TNOTIFYEVENT', iptrw);
    RegisterProperty('ONEXIT', 'TNOTIFYEVENT', iptrw);
     RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
     RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
   RegisterProperty('ALIGNMENT', 'TALIGNMENT', iptrw);
    RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);
    RegisterProperty('HIDESELECTION', 'Boolean', iptrw);
    RegisterProperty('MAXLENGTH', 'Integer', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CHARCASE', 'TEditCharCase', iptrw);
    RegisterProperty('OEMCONVERT', 'Boolean', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomFlowPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanel', 'TCustomFlowPanel') do
  with CL.AddClassN(CL.FindClass('TCustomPanel'),'TCustomFlowPanel') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure GetChildren( Proc : TGetChildProc; Root : TComponent)');
    RegisterMethod('Function GetControlIndex( AControl : TControl) : Integer');
    RegisterMethod('Procedure SetControlIndex( AControl : TControl; Index : Integer)');
    RegisterProperty('AutoWrap', 'Boolean', iptrw);
    RegisterProperty('FlowStyle', 'TFlowStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPanel', 'TPanel') do
  with CL.AddClassN(CL.FindClass('TCustomPanel'),'TPanel') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomPanel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCustomPanel') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCustomPanel') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetControlsAlignment : TAlignment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTimer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TTimer') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TTimer') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('OnTimer', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBevel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TBevel') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TBevel') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Shape', 'TBevelShape', iptrw);
    RegisterProperty('Style', 'TBevelStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TImage') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TImage') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Canvas', 'TCanvas', iptr);
    RegisterProperty('Center', 'Boolean', iptrw);
    RegisterProperty('IncrementalDisplay', 'Boolean', iptrw);
    RegisterProperty('Picture', 'TPicture', iptrw);
    RegisterProperty('Proportional', 'Boolean', iptrw);
    RegisterProperty('Stretch', 'Boolean', iptrw);
    RegisterProperty('Transparent', 'Boolean', iptrw);
    RegisterProperty('OnProgress', 'TProgressEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPaintBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TPaintBox') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TPaintBox') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('OnPaint', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TShape(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TShape') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TShape') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure StyleChanged( Sender : TObject)');
    RegisterProperty('Brush', 'TBrush', iptrw);
    RegisterProperty('Pen', 'TPen', iptrw);
    RegisterProperty('Shape', 'TShapeType', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ExtCtrls2(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TShapeType', '( stRectangle, stSquare, stRoundRect, stRoundSquar'
  // +'e, stEllipse, stCircle )');
  //SIRegister_TShape(CL);
  //SIRegister_TPaintBox(CL);
  //SIRegister_TImage(CL);
  //CL.AddTypeS('TBevelStyle', '( bsLowered, bsRaised )');
  //CL.AddTypeS('TBevelShape', '( bsBox, bsFrame, bsTopLine, bsBottomLine, bsLeft'
   //+'Line, bsRightLine, bsSpacer )');
  //SIRegister_TBevel(CL);
  //SIRegister_TTimer(CL);
  CL.AddTypeS('TBevelCut','(bvNone, bvLowered, bvRaised, bvSpace)');
  CL.AddTypeS('TPanelBevel', 'TBevelCut');
  //SIRegister_TCustomPanel(CL);
  //SIRegister_TPanel(CL);
  CL.AddTypeS('TFlowStyle', '( fsLeftRightTopBottom, fsRightLeftTopBottom, fsLe'
   +'ftRightBottomTop, fsRightLeftBottomTop, fsTopBottomLeftRight, fsBottomTopL'
   +'eftRight, fsTopBottomRightLeft, fsBottomTopRightLeft )');
  SIRegister_TCustomFlowPanel(CL);
  SIRegister_TFlowPanel(CL);
  CL.AddTypeS('TSizeStyle', '( ssAbsolute, ssPercent, ssAuto )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomGridPanel');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EGridPanelException');
  SIRegister_TCellItem(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TRowItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TColumnItem');
  SIRegister_TCellCollection(CL);
  CL.AddTypeS('TCellSpan', 'Integer');
  SIRegister_TRowCollection(CL);
  SIRegister_TColumnCollection(CL);
  SIRegister_TControlItem(CL);
  SIRegister_TControlCollection(CL);
  CL.AddTypeS('TExpandStyle', '( emAddRows, emAddColumns, emFixedSize )');
  SIRegister_TCustomGridPanel(CL);
  SIRegister_TGridPanel(CL);
  //SIRegister_TPage(CL);
  //SIRegister_TNotebook(CL);
  CL.AddTypeS('TSectionEvent', 'Procedure ( Sender : TObject; ASection, AWidth: Integer)');
  //SIRegister_THeader(CL);
  //SIRegister_TCustomRadioGroup(CL);
  //SIRegister_TRadioGroup(CL);
  CL.AddTypeS('NaturalNumber', 'Integer');
  CL.AddTypeS('TSplitterCanResizeEvent', 'Procedure ( Sender : TObject; var New'
   +'Size : Integer; var Accept : Boolean)');
  CL.AddTypeS('TCanResizeEvent', 'TSplitterCanResizeEvent');
  CL.AddTypeS('TResizeStyle', '( rsNone, rsLine, rsUpdate, rsPattern )');
  SIRegister_TSplitter(CL);
  CL.AddTypeS('TBandPaintOption', '( bpoGrabber, bpoFrame, bpoGradient, bpoRoundRect )');
  CL.AddTypeS('TBandPaintOptions', 'set of TBandPaintOption');
  CL.AddTypeS('TBandDrawingStyle', '( dsNormal, dsGradient )');
  CL.AddTypeS('TBandDragEvent', 'Procedure ( Sender : TObject; Control : TContr'
   +'ol; var Drag : Boolean)');
  CL.AddTypeS('TBandInfoEvent', 'Procedure ( Sender : TObject; Control : TContr'
   +'ol; var Insets : TRect; var PreferredSize, RowCount : Integer)');
  CL.AddTypeS('TBandMoveEvent', 'Procedure (Sender : TObject; Control : TControl; var ARect : TRect)');
  CL.AddTypeS('TBeginBandMoveEvent', 'Procedure ( Sender : TObject; Control : T'
   +'Control; var AllowMove : Boolean)');
  CL.AddTypeS('TEndBandMoveEvent', 'Procedure ( Sender : TObject; Control : TControl)');
  CL.AddTypeS('TBandPaintEvent', 'Procedure ( Sender : TObject; Control : TCont'
   +'rol; Canvas : TCanvas; var ARect : TRect; var Options : TBandPaintOptions)');
  CL.AddTypeS('TCornerEdge', '( ceNone, ceSmall, ceMedium, ceLarge )');
  CL.AddTypeS('TRowSize', 'Integer');
  SIRegister_TCustomControlBar(CL);
  SIRegister_TControlBar(CL);
  SIRegister_TBoundLabel(CL);
  CL.AddTypeS('TLabelPosition', '( lpAbove, lpBelow, lpLeft, lpRight )');
  SIRegister_TCustomLabeledEdit(CL);
  SIRegister_TLabeledEdit(CL);
 //CL.AddConstantN('NoColorSelected','LongWord').SetUInt(TColor ( $FF000000 ));
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomColorBox');
  CL.AddTypeS('TColorBoxStyles', '( cbStandardColors, cbExtendedColors, cbSyste'
   +'mColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors )');
  CL.AddTypeS('TColorBoxStyle', 'set of TColorBoxStyles');
  CL.AddTypeS('TGetColorsEvent', 'Procedure ( Sender: TCustomColorBox; Items: TStrings)');
  SIRegister_TCustomColorBox(CL);
  SIRegister_TColorBox(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomColorListBox');
  CL.AddTypeS('TLBGetColorsEvent', 'Procedure ( Sender : TCustomColorListBox; Items : TStrings)');
  SIRegister_TCustomColorListBox(CL);
  SIRegister_TColorListBox(CL);
  SIRegister_TTrayIcon(CL);
 CL.AddDelphiFunction('Procedure Frame3D( Canvas : TCanvas; var Rect : TRect; TopColor, BottomColor : TColor; Width : Integer)');
 CL.AddDelphiFunction('Procedure NotebookHandlesNeeded( Notebook : TNotebook)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxOnGetColors_W(Self: TCustomColorListBox; const T: TLBGetColorsEvent);
begin Self.OnGetColors := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxOnGetColors_R(Self: TCustomColorListBox; var T: TLBGetColorsEvent);
begin T := Self.OnGetColors; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxNoneColorColor_W(Self: TCustomColorListBox; const T: TColor);
begin Self.NoneColorColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxNoneColorColor_R(Self: TCustomColorListBox; var T: TColor);
begin T := Self.NoneColorColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxDefaultColorColor_W(Self: TCustomColorListBox; const T: TColor);
begin Self.DefaultColorColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxDefaultColorColor_R(Self: TCustomColorListBox; var T: TColor);
begin T := Self.DefaultColorColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxSelected_W(Self: TCustomColorListBox; const T: TColor);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxSelected_R(Self: TCustomColorListBox; var T: TColor);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxColorNames_R(Self: TCustomColorListBox; var T: string; const t1: Integer);
begin T := Self.ColorNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxColors_R(Self: TCustomColorListBox; var T: TColor; const t1: Integer);
begin T := Self.Colors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxStyle_W(Self: TCustomColorListBox; const T: TColorBoxStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorListBoxStyle_R(Self: TCustomColorListBox; var T: TColorBoxStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxOnGetColors_W(Self: TCustomColorBox; const T: TGetColorsEvent);
begin Self.OnGetColors := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxOnGetColors_R(Self: TCustomColorBox; var T: TGetColorsEvent);
begin T := Self.OnGetColors; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxNoneColorColor_W(Self: TCustomColorBox; const T: TColor);
begin Self.NoneColorColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxNoneColorColor_R(Self: TCustomColorBox; var T: TColor);
begin T := Self.NoneColorColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxDefaultColorColor_W(Self: TCustomColorBox; const T: TColor);
begin Self.DefaultColorColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxDefaultColorColor_R(Self: TCustomColorBox; var T: TColor);
begin T := Self.DefaultColorColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxSelected_W(Self: TCustomColorBox; const T: TColor);
begin Self.Selected := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxSelected_R(Self: TCustomColorBox; var T: TColor);
begin T := Self.Selected; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxColorNames_R(Self: TCustomColorBox; var T: string; const t1: Integer);
begin T := Self.ColorNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxColors_R(Self: TCustomColorBox; var T: TColor; const t1: Integer);
begin T := Self.Colors[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxStyle_W(Self: TCustomColorBox; const T: TColorBoxStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomColorBoxStyle_R(Self: TCustomColorBox; var T: TColorBoxStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLabeledEditLabelSpacing_W(Self: TCustomLabeledEdit; const T: Integer);
begin Self.LabelSpacing := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLabeledEditLabelSpacing_R(Self: TCustomLabeledEdit; var T: Integer);
begin T := Self.LabelSpacing; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLabeledEditLabelPosition_W(Self: TCustomLabeledEdit; const T: TLabelPosition);
begin Self.LabelPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLabeledEditLabelPosition_R(Self: TCustomLabeledEdit; var T: TLabelPosition);
begin T := Self.LabelPosition; end;

(*----------------------------------------------------------------------------*)
procedure TCustomLabeledEditEditLabel_R(Self: TCustomLabeledEdit; var T: TBoundLabel);
begin T := Self.EditLabel; end;

(*----------------------------------------------------------------------------*)
procedure TBoundLabelWidth_W(Self: TBoundLabel; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoundLabelWidth_R(Self: TBoundLabel; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TBoundLabelTop_R(Self: TBoundLabel; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TBoundLabelLeft_R(Self: TBoundLabel; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TBoundLabelHeight_W(Self: TBoundLabel; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TBoundLabelHeight_R(Self: TBoundLabel; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TCustomControlBarPicture_W(Self: TCustomControlBar; const T: TPicture);
begin Self.Picture := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomControlBarPicture_R(Self: TCustomControlBar; var T: TPicture);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterOnPaint_W(Self: TSplitter; const T: TNotifyEvent);
begin Self.OnPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterOnPaint_R(Self: TSplitter; var T: TNotifyEvent);
begin T := Self.OnPaint; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterOnMoved_W(Self: TSplitter; const T: TNotifyEvent);
begin Self.OnMoved := T; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterOnMoved_R(Self: TSplitter; var T: TNotifyEvent);
begin T := Self.OnMoved; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterOnCanResize_W(Self: TSplitter; const T: TCanResizeEvent);
begin Self.OnCanResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterOnCanResize_R(Self: TSplitter; var T: TCanResizeEvent);
begin T := Self.OnCanResize; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterResizeStyle_W(Self: TSplitter; const T: TResizeStyle);
begin Self.ResizeStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterResizeStyle_R(Self: TSplitter; var T: TResizeStyle);
begin T := Self.ResizeStyle; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterMinSize_W(Self: TSplitter; const T: NaturalNumber);
begin Self.MinSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterMinSize_R(Self: TSplitter; var T: NaturalNumber);
begin T := Self.MinSize; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterBeveled_W(Self: TSplitter; const T: Boolean);
begin Self.Beveled := T; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterBeveled_R(Self: TSplitter; var T: Boolean);
begin T := Self.Beveled; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterAutoSnap_W(Self: TSplitter; const T: Boolean);
begin Self.AutoSnap := T; end;

(*----------------------------------------------------------------------------*)
procedure TSplitterAutoSnap_R(Self: TSplitter; var T: Boolean);
begin T := Self.AutoSnap; end;

(*----------------------------------------------------------------------------*)
procedure TCustomRadioGroupButtons_R(Self: TCustomRadioGroup; var T: TRadioButton; const t1: Integer);
begin T := Self.Buttons[t1]; end;

(*----------------------------------------------------------------------------*)
procedure THeaderOnSized_W(Self: THeader; const T: TSectionEvent);
begin Self.OnSized := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderOnSized_R(Self: THeader; var T: TSectionEvent);
begin T := Self.OnSized; end;

(*----------------------------------------------------------------------------*)
procedure THeaderOnSizing_W(Self: THeader; const T: TSectionEvent);
begin Self.OnSizing := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderOnSizing_R(Self: THeader; var T: TSectionEvent);
begin T := Self.OnSizing; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSections_W(Self: THeader; const T: TStrings);
begin Self.Sections := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSections_R(Self: THeader; var T: TStrings);
begin T := Self.Sections; end;

(*----------------------------------------------------------------------------*)
procedure THeaderBorderStyle_W(Self: THeader; const T: TBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderBorderStyle_R(Self: THeader; var T: TBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure THeaderAllowResize_W(Self: THeader; const T: Boolean);
begin Self.AllowResize := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderAllowResize_R(Self: THeader; var T: Boolean);
begin T := Self.AllowResize; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionWidth_W(Self: THeader; const T: Integer; const t1: Integer);
begin Self.SectionWidth[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure THeaderSectionWidth_R(Self: THeader; var T: Integer; const t1: Integer);
begin T := Self.SectionWidth[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TNotebookOnPageChanged_W(Self: TNotebook; const T: TNotifyEvent);
begin Self.OnPageChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TNotebookOnPageChanged_R(Self: TNotebook; var T: TNotifyEvent);
begin T := Self.OnPageChanged; end;

(*----------------------------------------------------------------------------*)
procedure TNotebookPages_W(Self: TNotebook; const T: TStrings);
begin Self.Pages := T; end;

(*----------------------------------------------------------------------------*)
procedure TNotebookPages_R(Self: TNotebook; var T: TStrings);
begin T := Self.Pages; end;

(*----------------------------------------------------------------------------*)
procedure TNotebookPageIndex_W(Self: TNotebook; const T: Integer);
begin Self.PageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TNotebookPageIndex_R(Self: TNotebook; var T: Integer);
begin T := Self.PageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TNotebookActivePage_W(Self: TNotebook; const T: string);
begin Self.ActivePage := T; end;

(*----------------------------------------------------------------------------*)
procedure TNotebookActivePage_R(Self: TNotebook; var T: string);
begin T := Self.ActivePage; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelRowSpanIndex_R(Self: TCustomGridPanel; var T: Integer; const t1: Integer; const t2: Integer);
begin T := Self.RowSpanIndex[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelRowCollection_W(Self: TCustomGridPanel; const T: TRowCollection);
begin Self.RowCollection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelRowCollection_R(Self: TCustomGridPanel; var T: TRowCollection);
begin T := Self.RowCollection; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelExpandStyle_W(Self: TCustomGridPanel; const T: TExpandStyle);
begin Self.ExpandStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelExpandStyle_R(Self: TCustomGridPanel; var T: TExpandStyle);
begin T := Self.ExpandStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelControlCollection_W(Self: TCustomGridPanel; const T: TControlCollection);
begin Self.ControlCollection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelControlCollection_R(Self: TCustomGridPanel; var T: TControlCollection);
begin T := Self.ControlCollection; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelColumnCollection_W(Self: TCustomGridPanel; const T: TColumnCollection);
begin Self.ColumnCollection := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelColumnCollection_R(Self: TCustomGridPanel; var T: TColumnCollection);
begin T := Self.ColumnCollection; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelCellRect_R(Self: TCustomGridPanel; var T: TRect; const t1: Integer; const t2: Integer);
begin T := Self.CellRect[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelCellSize_R(Self: TCustomGridPanel; var T: TPoint; const t1: Integer; const t2: Integer);
begin T := Self.CellSize[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelCellCount_R(Self: TCustomGridPanel; var T: Integer);
begin T := Self.CellCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomGridPanelColumnSpanIndex_R(Self: TCustomGridPanel; var T: Integer; const t1: Integer; const t2: Integer);
begin T := Self.ColumnSpanIndex[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TControlCollectionItems_W(Self: TControlCollection; const T: TControlItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlCollectionItems_R(Self: TControlCollection; var T: TControlItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TControlCollectionControlItems_R(Self: TControlCollection; var T: TControlItem; const t1: Integer; const t2: Integer);
begin T := Self.ControlItems[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TControlCollectionControls_W(Self: TControlCollection; const T: TControl; const t1: Integer; const t2: Integer);
begin Self.Controls[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlCollectionControls_R(Self: TControlCollection; var T: TControl; const t1: Integer; const t2: Integer);
begin T := Self.Controls[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemRowSpan_W(Self: TControlItem; const T: TCellSpan);
begin Self.RowSpan := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemRowSpan_R(Self: TControlItem; var T: TCellSpan);
begin T := Self.RowSpan; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemRow_W(Self: TControlItem; const T: Integer);
begin Self.Row := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemRow_R(Self: TControlItem; var T: Integer);
begin T := Self.Row; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemControl_W(Self: TControlItem; const T: TControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemControl_R(Self: TControlItem; var T: TControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemColumnSpan_W(Self: TControlItem; const T: TCellSpan);
begin Self.ColumnSpan := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemColumnSpan_R(Self: TControlItem; var T: TCellSpan);
begin T := Self.ColumnSpan; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemColumn_W(Self: TControlItem; const T: Integer);
begin Self.Column := T; end;

(*----------------------------------------------------------------------------*)
procedure TControlItemColumn_R(Self: TControlItem; var T: Integer);
begin T := Self.Column; end;

(*----------------------------------------------------------------------------*)
procedure TCellCollectionItems_W(Self: TCellCollection; const T: TCellItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCellCollectionItems_R(Self: TCellCollection; var T: TCellItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCellItemValue_W(Self: TCellItem; const T: Double);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TCellItemValue_R(Self: TCellItem; var T: Double);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TCellItemSizeStyle_W(Self: TCellItem; const T: TSizeStyle);
begin Self.SizeStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCellItemSizeStyle_R(Self: TCellItem; var T: TSizeStyle);
begin T := Self.SizeStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFlowPanelFlowStyle_W(Self: TCustomFlowPanel; const T: TFlowStyle);
begin Self.FlowStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFlowPanelFlowStyle_R(Self: TCustomFlowPanel; var T: TFlowStyle);
begin T := Self.FlowStyle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFlowPanelAutoWrap_W(Self: TCustomFlowPanel; const T: Boolean);
begin Self.AutoWrap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomFlowPanelAutoWrap_R(Self: TCustomFlowPanel; var T: Boolean);
begin T := Self.AutoWrap; end;

(*----------------------------------------------------------------------------*)
procedure TTimerOnTimer_W(Self: TTimer; const T: TNotifyEvent);
begin Self.OnTimer := T; end;

(*----------------------------------------------------------------------------*)
procedure TTimerOnTimer_R(Self: TTimer; var T: TNotifyEvent);
begin T := Self.OnTimer; end;

(*----------------------------------------------------------------------------*)
procedure TTimerInterval_W(Self: TTimer; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TTimerInterval_R(Self: TTimer; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TTimerEnabled_W(Self: TTimer; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TTimerEnabled_R(Self: TTimer; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TBevelStyle_W(Self: TBevel; const T: TBevelStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TBevelStyle_R(Self: TBevel; var T: TBevelStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TBevelShape_W(Self: TBevel; const T: TBevelShape);
begin Self.Shape := T; end;

(*----------------------------------------------------------------------------*)
procedure TBevelShape_R(Self: TBevel; var T: TBevelShape);
begin T := Self.Shape; end;

(*----------------------------------------------------------------------------*)
procedure TImageOnProgress_W(Self: TImage; const T: TProgressEvent);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageOnProgress_R(Self: TImage; var T: TProgressEvent);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TImageTransparent_W(Self: TImage; const T: Boolean);
begin Self.Transparent := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageTransparent_R(Self: TImage; var T: Boolean);
begin T := Self.Transparent; end;

(*----------------------------------------------------------------------------*)
procedure TImageStretch_W(Self: TImage; const T: Boolean);
begin Self.Stretch := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageStretch_R(Self: TImage; var T: Boolean);
begin T := Self.Stretch; end;

(*----------------------------------------------------------------------------*)
procedure TImageProportional_W(Self: TImage; const T: Boolean);
begin Self.Proportional := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageProportional_R(Self: TImage; var T: Boolean);
begin T := Self.Proportional; end;

(*----------------------------------------------------------------------------*)
procedure TImagePicture_W(Self: TImage; const T: TPicture);
begin Self.Picture := T; end;

(*----------------------------------------------------------------------------*)
procedure TImagePicture_R(Self: TImage; var T: TPicture);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TImageIncrementalDisplay_W(Self: TImage; const T: Boolean);
begin Self.IncrementalDisplay := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageIncrementalDisplay_R(Self: TImage; var T: Boolean);
begin T := Self.IncrementalDisplay; end;

(*----------------------------------------------------------------------------*)
procedure TImageCenter_W(Self: TImage; const T: Boolean);
begin Self.Center := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageCenter_R(Self: TImage; var T: Boolean);
begin T := Self.Center; end;

(*----------------------------------------------------------------------------*)
procedure TImageCanvas_R(Self: TImage; var T: TCanvas);
begin T := Self.Canvas; end;

(*----------------------------------------------------------------------------*)
procedure TPaintBoxOnPaint_W(Self: TPaintBox; const T: TNotifyEvent);
begin Self.OnPaint := T; end;

(*----------------------------------------------------------------------------*)
procedure TPaintBoxOnPaint_R(Self: TPaintBox; var T: TNotifyEvent);
begin T := Self.OnPaint; end;

(*----------------------------------------------------------------------------*)
procedure TShapeShape_W(Self: TShape; const T: TShapeType);
begin Self.Shape := T; end;

(*----------------------------------------------------------------------------*)
procedure TShapeShape_R(Self: TShape; var T: TShapeType);
begin T := Self.Shape; end;

(*----------------------------------------------------------------------------*)
procedure TShapePen_W(Self: TShape; const T: TPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TShapePen_R(Self: TShape; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TShapeBrush_W(Self: TShape; const T: TBrush);
begin Self.Brush := T; end;

(*----------------------------------------------------------------------------*)
procedure TShapeBrush_R(Self: TShape; var T: TBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ExtCtrls2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Frame3D, 'Frame3D', cdRegister);
 S.RegisterDelphiFunction(@NotebookHandlesNeeded, 'NotebookHandlesNeeded', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTrayIcon(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTrayIcon) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TColorListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TColorListBox) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomColorListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomColorListBox) do begin
    RegisterConstructor(@TCustomColorListBox.Create, 'Create');
    RegisterPropertyHelper(@TCustomColorListBoxStyle_R,@TCustomColorListBoxStyle_W,'Style');
    RegisterPropertyHelper(@TCustomColorListBoxColors_R,nil,'Colors');
    RegisterPropertyHelper(@TCustomColorListBoxColorNames_R,nil,'ColorNames');
    RegisterPropertyHelper(@TCustomColorListBoxSelected_R,@TCustomColorListBoxSelected_W,'Selected');
    RegisterPropertyHelper(@TCustomColorListBoxDefaultColorColor_R,@TCustomColorListBoxDefaultColorColor_W,'DefaultColorColor');
    RegisterPropertyHelper(@TCustomColorListBoxNoneColorColor_R,@TCustomColorListBoxNoneColorColor_W,'NoneColorColor');
    RegisterPropertyHelper(@TCustomColorListBoxOnGetColors_R,@TCustomColorListBoxOnGetColors_W,'OnGetColors');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TColorBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TColorBox) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomColorBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomColorBox) do begin
    RegisterConstructor(@TCustomColorBox.Create, 'Create');
    RegisterPropertyHelper(@TCustomColorBoxStyle_R,@TCustomColorBoxStyle_W,'Style');
    RegisterPropertyHelper(@TCustomColorBoxColors_R,nil,'Colors');
    RegisterPropertyHelper(@TCustomColorBoxColorNames_R,nil,'ColorNames');
    RegisterPropertyHelper(@TCustomColorBoxSelected_R,@TCustomColorBoxSelected_W,'Selected');
    RegisterPropertyHelper(@TCustomColorBoxDefaultColorColor_R,@TCustomColorBoxDefaultColorColor_W,'DefaultColorColor');
    RegisterPropertyHelper(@TCustomColorBoxNoneColorColor_R,@TCustomColorBoxNoneColorColor_W,'NoneColorColor');
    RegisterPropertyHelper(@TCustomColorBoxOnGetColors_R,@TCustomColorBoxOnGetColors_W,'OnGetColors');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLabeledEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLabeledEdit) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomLabeledEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomLabeledEdit) do
  begin
    RegisterConstructor(@TCustomLabeledEdit.Create, 'Create');
    RegisterMethod(@TCustomLabeledEdit.SetBounds, 'SetBounds');
    RegisterMethod(@TCustomLabeledEdit.SetupInternalLabel, 'SetupInternalLabel');
    RegisterPropertyHelper(@TCustomLabeledEditEditLabel_R,nil,'EditLabel');
    RegisterPropertyHelper(@TCustomLabeledEditLabelPosition_R,@TCustomLabeledEditLabelPosition_W,'LabelPosition');
    RegisterPropertyHelper(@TCustomLabeledEditLabelSpacing_R,@TCustomLabeledEditLabelSpacing_W,'LabelSpacing');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBoundLabel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBoundLabel) do
  begin
    RegisterPropertyHelper(@TBoundLabelHeight_R,@TBoundLabelHeight_W,'Height');
    RegisterPropertyHelper(@TBoundLabelLeft_R,nil,'Left');
    RegisterPropertyHelper(@TBoundLabelTop_R,nil,'Top');
    RegisterPropertyHelper(@TBoundLabelWidth_R,@TBoundLabelWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TControlBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TControlBar) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomControlBar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomControlBar) do
  begin
    RegisterConstructor(@TCustomControlBar.Create, 'Create');
    RegisterMethod(@TCustomControlBar.FlipChildren, 'FlipChildren');
    RegisterVirtualMethod(@TCustomControlBar.StickControls, 'StickControls');
    RegisterPropertyHelper(@TCustomControlBarPicture_R,@TCustomControlBarPicture_W,'Picture');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSplitter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSplitter) do begin
    RegisterConstructor(@TSplitter.Create, 'Create');
    RegisterPropertyHelper(@TSplitterAutoSnap_R,@TSplitterAutoSnap_W,'AutoSnap');
    RegisterPropertyHelper(@TSplitterBeveled_R,@TSplitterBeveled_W,'Beveled');
    RegisterPropertyHelper(@TSplitterMinSize_R,@TSplitterMinSize_W,'MinSize');
    RegisterPropertyHelper(@TSplitterResizeStyle_R,@TSplitterResizeStyle_W,'ResizeStyle');
    RegisterPropertyHelper(@TSplitterOnCanResize_R,@TSplitterOnCanResize_W,'OnCanResize');
    RegisterPropertyHelper(@TSplitterOnMoved_R,@TSplitterOnMoved_W,'OnMoved');
    RegisterPropertyHelper(@TSplitterOnPaint_R,@TSplitterOnPaint_W,'OnPaint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRadioGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRadioGroup) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomRadioGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomRadioGroup) do begin
    RegisterConstructor(@TCustomRadioGroup.Create, 'Create');
   RegisterMethod(@TCustomRadioGroup.Free, 'Free');
     RegisterMethod(@TCustomRadioGroup.FlipChildren, 'FlipChildren');
    RegisterPropertyHelper(@TCustomRadioGroupButtons_R,nil,'Buttons');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THeader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THeader) do
  begin
    RegisterConstructor(@THeader.Create, 'Create');
    RegisterPropertyHelper(@THeaderSectionWidth_R,@THeaderSectionWidth_W,'SectionWidth');
    RegisterPropertyHelper(@THeaderAllowResize_R,@THeaderAllowResize_W,'AllowResize');
    RegisterPropertyHelper(@THeaderBorderStyle_R,@THeaderBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@THeaderSections_R,@THeaderSections_W,'Sections');
    RegisterPropertyHelper(@THeaderOnSizing_R,@THeaderOnSizing_W,'OnSizing');
    RegisterPropertyHelper(@THeaderOnSized_R,@THeaderOnSized_W,'OnSized');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNotebook(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNotebook) do
  begin
    RegisterConstructor(@TNotebook.Create, 'Create');
    RegisterPropertyHelper(@TNotebookActivePage_R,@TNotebookActivePage_W,'ActivePage');
    RegisterPropertyHelper(@TNotebookPageIndex_R,@TNotebookPageIndex_W,'PageIndex');
    RegisterPropertyHelper(@TNotebookPages_R,@TNotebookPages_W,'Pages');
    RegisterPropertyHelper(@TNotebookOnPageChanged_R,@TNotebookOnPageChanged_W,'OnPageChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPage) do
  begin
    RegisterConstructor(@TPage.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGridPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGridPanel) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomGridPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomGridPanel) do begin
    RegisterConstructor(@TCustomGridPanel.Create, 'Create');
     RegisterMethod(@TCustomGridPanel.Free, 'Free');
      RegisterMethod(@TCustomGridPanel.GetChildren, 'GetChildren');
    RegisterMethod(@TCustomGridPanel.IsColumnEmpty, 'IsColumnEmpty');
    RegisterMethod(@TCustomGridPanel.IsRowEmpty, 'IsRowEmpty');
    RegisterPropertyHelper(@TCustomGridPanelColumnSpanIndex_R,nil,'ColumnSpanIndex');
    RegisterPropertyHelper(@TCustomGridPanelCellCount_R,nil,'CellCount');
    RegisterPropertyHelper(@TCustomGridPanelCellSize_R,nil,'CellSize');
    RegisterPropertyHelper(@TCustomGridPanelCellRect_R,nil,'CellRect');
    RegisterPropertyHelper(@TCustomGridPanelColumnCollection_R,@TCustomGridPanelColumnCollection_W,'ColumnCollection');
    RegisterPropertyHelper(@TCustomGridPanelControlCollection_R,@TCustomGridPanelControlCollection_W,'ControlCollection');
    RegisterPropertyHelper(@TCustomGridPanelExpandStyle_R,@TCustomGridPanelExpandStyle_W,'ExpandStyle');
    RegisterPropertyHelper(@TCustomGridPanelRowCollection_R,@TCustomGridPanelRowCollection_W,'RowCollection');
    RegisterPropertyHelper(@TCustomGridPanelRowSpanIndex_R,nil,'RowSpanIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TControlCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TControlCollection) do
  begin
    RegisterConstructor(@TControlCollection.Create, 'Create');
    RegisterMethod(@TControlCollection.Add, 'Add');
    RegisterMethod(@TControlCollection.AddControl, 'AddControl');
    RegisterMethod(@TControlCollection.RemoveControl, 'RemoveControl');
    RegisterMethod(@TControlCollection.IndexOf, 'IndexOf');
    RegisterMethod(@TControlCollection.Owner, 'Owner');
    RegisterPropertyHelper(@TControlCollectionControls_R,@TControlCollectionControls_W,'Controls');
    RegisterPropertyHelper(@TControlCollectionControlItems_R,nil,'ControlItems');
    RegisterPropertyHelper(@TControlCollectionItems_R,@TControlCollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TControlItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TControlItem) do
  begin
    RegisterConstructor(@TControlItem.Create, 'Create');
    RegisterMethod(@TControlItem.SetLocation, 'SetLocation');
    RegisterPropertyHelper(@TControlItemColumn_R,@TControlItemColumn_W,'Column');
    RegisterPropertyHelper(@TControlItemColumnSpan_R,@TControlItemColumnSpan_W,'ColumnSpan');
    RegisterPropertyHelper(@TControlItemControl_R,@TControlItemControl_W,'Control');
    RegisterPropertyHelper(@TControlItemRow_R,@TControlItemRow_W,'Row');
    RegisterPropertyHelper(@TControlItemRowSpan_R,@TControlItemRowSpan_W,'RowSpan');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TColumnCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TColumnCollection) do
  begin
    RegisterConstructor(@TColumnCollection.Create, 'Create');
    RegisterMethod(@TColumnCollection.Add, 'Add');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRowCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRowCollection) do
  begin
    RegisterConstructor(@TRowCollection.Create, 'Create');
    RegisterMethod(@TRowCollection.Add, 'Add');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCellCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCellCollection) do
  begin
    RegisterMethod(@TCellCollection.Owner, 'Owner');
    RegisterPropertyHelper(@TCellCollectionItems_R,@TCellCollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCellItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCellItem) do
  begin
    RegisterConstructor(@TCellItem.Create, 'Create');
    RegisterPropertyHelper(@TCellItemSizeStyle_R,@TCellItemSizeStyle_W,'SizeStyle');
    RegisterPropertyHelper(@TCellItemValue_R,@TCellItemValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFlowPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFlowPanel) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomFlowPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomFlowPanel) do
  begin
    RegisterConstructor(@TCustomFlowPanel.Create, 'Create');
    RegisterMethod(@TCustomFlowPanel.GetChildren, 'GetChildren');
    RegisterMethod(@TCustomFlowPanel.GetControlIndex, 'GetControlIndex');
    RegisterMethod(@TCustomFlowPanel.SetControlIndex, 'SetControlIndex');
    RegisterPropertyHelper(@TCustomFlowPanelAutoWrap_R,@TCustomFlowPanelAutoWrap_W,'AutoWrap');
    RegisterPropertyHelper(@TCustomFlowPanelFlowStyle_R,@TCustomFlowPanelFlowStyle_W,'FlowStyle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPanel) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomPanel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomPanel) do
  begin
    RegisterConstructor(@TCustomPanel.Create, 'Create');
    RegisterMethod(@TCustomPanel.GetControlsAlignment, 'GetControlsAlignment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTimer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTimer) do
  begin
    RegisterConstructor(@TTimer.Create, 'Create');
    RegisterPropertyHelper(@TTimerEnabled_R,@TTimerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TTimerInterval_R,@TTimerInterval_W,'Interval');
    RegisterPropertyHelper(@TTimerOnTimer_R,@TTimerOnTimer_W,'OnTimer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBevel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBevel) do
  begin
    RegisterConstructor(@TBevel.Create, 'Create');
    RegisterPropertyHelper(@TBevelShape_R,@TBevelShape_W,'Shape');
    RegisterPropertyHelper(@TBevelStyle_R,@TBevelStyle_W,'Style');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TImage) do
  begin
    RegisterConstructor(@TImage.Create, 'Create');
    RegisterPropertyHelper(@TImageCanvas_R,nil,'Canvas');
    RegisterPropertyHelper(@TImageCenter_R,@TImageCenter_W,'Center');
    RegisterPropertyHelper(@TImageIncrementalDisplay_R,@TImageIncrementalDisplay_W,'IncrementalDisplay');
    RegisterPropertyHelper(@TImagePicture_R,@TImagePicture_W,'Picture');
    RegisterPropertyHelper(@TImageProportional_R,@TImageProportional_W,'Proportional');
    RegisterPropertyHelper(@TImageStretch_R,@TImageStretch_W,'Stretch');
    RegisterPropertyHelper(@TImageTransparent_R,@TImageTransparent_W,'Transparent');
    RegisterPropertyHelper(@TImageOnProgress_R,@TImageOnProgress_W,'OnProgress');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPaintBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPaintBox) do begin
    RegisterConstructor(@TPaintBox.Create, 'Create');
    RegisterPropertyHelper(@TPaintBoxOnPaint_R,@TPaintBoxOnPaint_W,'OnPaint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TShape(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TShape) do
  begin
    RegisterConstructor(@TShape.Create, 'Create');
    RegisterMethod(@TShape.StyleChanged, 'StyleChanged');
    RegisterPropertyHelper(@TShapeBrush_R,@TShapeBrush_W,'Brush');
    RegisterPropertyHelper(@TShapePen_R,@TShapePen_W,'Pen');
    RegisterPropertyHelper(@TShapeShape_R,@TShapeShape_W,'Shape');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ExtCtrls2(CL: TPSRuntimeClassImporter);
begin
  {RIRegister_TShape(CL);
  RIRegister_TPaintBox(CL);
  RIRegister_TImage(CL);
  RIRegister_TBevel(CL);
  RIRegister_TTimer(CL);
  RIRegister_TCustomPanel(CL);
  RIRegister_TPanel(CL);  }
  RIRegister_TCustomFlowPanel(CL);
  RIRegister_TFlowPanel(CL);
  with CL.Add(TCustomGridPanel) do
  with CL.Add(EGridPanelException) do
  RIRegister_TCellItem(CL);
  with CL.Add(TRowItem) do
  with CL.Add(TColumnItem) do
  RIRegister_TCellCollection(CL);
  RIRegister_TRowCollection(CL);
  RIRegister_TColumnCollection(CL);
  RIRegister_TControlItem(CL);
  RIRegister_TControlCollection(CL);
  RIRegister_TCustomGridPanel(CL);
  RIRegister_TGridPanel(CL);
  {RIRegister_TPage(CL);
  RIRegister_TNotebook(CL);
  RIRegister_THeader(CL);
  RIRegister_TCustomRadioGroup(CL);
  RIRegister_TRadioGroup(CL); }
  RIRegister_TSplitter(CL);
  RIRegister_TCustomControlBar(CL);
  RIRegister_TControlBar(CL);
  RIRegister_TBoundLabel(CL);
  RIRegister_TCustomLabeledEdit(CL);
  RIRegister_TLabeledEdit(CL);
  with CL.Add(TCustomColorBox) do
  RIRegister_TCustomColorBox(CL);
  RIRegister_TColorBox(CL);
  with CL.Add(TCustomColorListBox) do
  RIRegister_TCustomColorListBox(CL);
  RIRegister_TColorListBox(CL);
  RIRegister_TTrayIcon(CL);
end;

 
 
{ TPSImport_ExtCtrls2 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtCtrls2.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ExtCtrls2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtCtrls2.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ExtCtrls2(ri);
  RIRegister_ExtCtrls2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
