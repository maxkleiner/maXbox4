unit uPSI_SynEditMiscClasses;
{
  Reflection API
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
  TPSImport_SynEditMiscClasses = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TSynEditMarkList(CL: TPSPascalCompiler);
procedure SIRegister_TSynEditMark(CL: TPSPascalCompiler);
procedure SIRegister_TBetterRegistry(CL: TPSPascalCompiler);
procedure SIRegister_TSynEditSearchCustom(CL: TPSPascalCompiler);
procedure SIRegister_TSynHotKey(CL: TPSPascalCompiler);
procedure SIRegister_TSynInternalImage(CL: TPSPascalCompiler);
procedure SIRegister_TSynNotifyEventChain(CL: TPSPascalCompiler);
procedure SIRegister_TSynMethodChain(CL: TPSPascalCompiler);
procedure SIRegister_TSynGlyph(CL: TPSPascalCompiler);
procedure SIRegister_TSynBookMarkOpt(CL: TPSPascalCompiler);
procedure SIRegister_TSynGutter(CL: TPSPascalCompiler);
procedure SIRegister_TSynSelectedColor(CL: TPSPascalCompiler);
procedure SIRegister_SynEditMiscClasses(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynEditMarkList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynEditMark(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBetterRegistry(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynEditSearchCustom(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynHotKey(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynInternalImage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynNotifyEventChain(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynMethodChain(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynGlyph(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynBookMarkOpt(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynGutter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynSelectedColor(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditMiscClasses(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { Xlib
  ,Types
  ,Qt
  ,QConsts
  ,QGraphics
  ,QControls
  ,QImgList
  ,QStdCtrls
  ,QMenus
  ,kTextDrawer
  ,QSynEditTypes
  ,QSynEditKeyConst }
  Consts
  //,Windows
  //,Messages
  ,Graphics
  ,Controls
  //,Forms
  //,StdCtrls
  ,Menus
  //,Registry }
  ,SynEditTypes
  ,SynEditKeyConst
  ,Math
  ,SynEditMiscClasses
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditMiscClasses]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditMarkList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynEditMarkList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynEditMarkList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( Item : TSynEditMark) : Integer');
    RegisterMethod('Function Remove( Item : TSynEditMark) : Integer');
    RegisterMethod('Procedure ClearLine( line : integer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure GetMarksForLine( line : integer; out Marks : TSynEditLineMarks)');
    RegisterProperty('Items', 'TSynEditMark Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditMark(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TSynEditMark') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TSynEditMark') do begin
    RegisterMethod('Constructor Create( )');
    RegisterProperty('Line', 'integer', iptrw);
    RegisterProperty('Char', 'integer', iptrw);
    RegisterProperty('ImageIndex', 'integer', iptrw);
    RegisterProperty('BookmarkNumber', 'integer', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('InternalImage', 'boolean', iptrw);
    RegisterProperty('IsBookmark', 'boolean', iptr);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBetterRegistry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRegistry', 'TBetterRegistry') do
  with CL.AddClassN(CL.FindClass('TRegistry'),'TBetterRegistry') do
  begin
    RegisterMethod('Function OpenKeyReadOnly( const Key : string) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynEditSearchCustom(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSynEditSearchCustom') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSynEditSearchCustom') do begin
    RegisterMethod('Function FindAll( const NewText : string) : integer');
    RegisterMethod('Function Replace( const aOccurrence, aReplacement : string) : string');
    RegisterProperty('Pattern', 'string', iptrw);
    RegisterProperty('ResultCount', 'integer', iptr);
    RegisterProperty('Results', 'integer integer', iptr);
    RegisterProperty('Lengths', 'integer integer', iptr);
    RegisterProperty('Options', 'TSynSearchOptions', iptw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynHotKey(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TSynHotKey') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TSynHotKey') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('BorderStyle', 'TSynBorderStyle', iptrw);
    RegisterProperty('HotKey', 'TShortCut', iptrw);
    RegisterProperty('InvalidKeys', 'THKInvalidKeys', iptrw);
    RegisterProperty('Modifiers', 'THKModifiers', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynInternalImage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynInternalImage') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynInternalImage') do begin
    RegisterMethod('Constructor Create( aModule : THandle; const Name : string; Count : integer)');
    RegisterMethod('Procedure Draw( ACanvas : TCanvas; Number, X, Y, LineHeight : integer)');
    RegisterMethod('Procedure DrawTransparent( ACanvas : TCanvas; Number, X, Y, LineHeight : integer; TransparentColor : TColor)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynNotifyEventChain(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynMethodChain', 'TSynNotifyEventChain') do
  with CL.AddClassN(CL.FindClass('TSynMethodChain'),'TSynNotifyEventChain') do
  begin
    RegisterMethod('Constructor CreateEx( ASender : TObject)');
    RegisterMethod('Procedure Add( AEvent : TNotifyEvent)');
    RegisterMethod('Procedure Remove( AEvent : TNotifyEvent)');
    RegisterProperty('Sender', 'TObject', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynMethodChain(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynMethodChain') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynMethodChain') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Add( AEvent : TMethod)');
    RegisterMethod('Procedure Remove( AEvent : TMethod)');
    RegisterMethod('Procedure Fire');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynGlyph(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSynGlyph') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSynGlyph') do begin
    RegisterMethod('Constructor Create( aModule : THandle; const aName : string; aMaskColor : TColor)');
    RegisterMethod('Procedure Assign( aSource : TPersistent)');
    RegisterMethod('Procedure Draw( aCanvas : TCanvas; aX, aY, aLineHeight : integer)');
    RegisterProperty('Width', 'integer', iptr);
    RegisterProperty('Height', 'integer', iptr);
    RegisterProperty('Glyph', 'TBitmap', iptrw);
    RegisterProperty('MaskColor', 'TColor', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynBookMarkOpt(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSynBookMarkOpt') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSynBookMarkOpt') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('BookmarkImages', 'TImageList', iptrw);
    RegisterProperty('DrawBookmarksFirst', 'boolean', iptrw);
    RegisterProperty('EnableKeys', 'Boolean', iptrw);
    RegisterProperty('GlyphsVisible', 'Boolean', iptrw);
    RegisterProperty('LeftMargin', 'Integer', iptrw);
    RegisterProperty('Xoffset', 'integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynGutter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSynGutter') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSynGutter') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure AutoSizeDigitCount( LinesCount : integer)');
    RegisterMethod('Function FormatLineNumber( Line : integer) : string');
    RegisterMethod('Function RealGutterWidth( CharWidth : integer) : integer');
    RegisterProperty('AutoSize', 'boolean', iptrw);
    RegisterProperty('BorderStyle', 'TSynGutterBorderStyle', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('BorderColor', 'TColor', iptrw);
    RegisterProperty('Cursor', 'TCursor', iptrw);
    RegisterProperty('DigitCount', 'integer', iptrw);
    RegisterProperty('Font', 'TFont', iptrw);
    RegisterProperty('LeadingZeros', 'boolean', iptrw);
    RegisterProperty('LeftOffset', 'integer', iptrw);
    RegisterProperty('RightOffset', 'integer', iptrw);
    RegisterProperty('ShowLineNumbers', 'boolean', iptrw);
    RegisterProperty('UseFontStyle', 'boolean', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('Width', 'integer', iptrw);
    RegisterProperty('ZeroStart', 'boolean', iptrw);
    RegisterProperty('LineNumberStart', 'Integer', iptrw);
    RegisterProperty('Gradient', 'Boolean', iptrw);
    RegisterProperty('GradientStartColor', 'TColor', iptrw);
    RegisterProperty('GradientEndColor', 'TColor', iptrw);
    RegisterProperty('GradientSteps', 'Integer', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynSelectedColor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSynSelectedColor') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSynSelectedColor') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Background', 'TColor', iptrw);
    RegisterProperty('Foreground', 'TColor', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditMiscClasses(CL: TPSPascalCompiler);
begin
  SIRegister_TSynSelectedColor(CL);
  CL.AddTypeS('TSynGutterBorderStyle', '( gbsNone, gbsMiddle, gbsRight )');
  //CL.AddTypeS('TSynEditLineMarks', 'array[0..16] of TSynEditMark;');

  //TSynEditLineMarks = array[0..16] of TSynEditMark;

  SIRegister_TSynGutter(CL);
  SIRegister_TSynBookMarkOpt(CL);
  SIRegister_TSynGlyph(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESynMethodChain');
  CL.AddTypeS('TSynExceptionEvent', 'Procedure ( Sender : TObject; E : Exceptio'
   +'n; var DoContinue : Boolean)');
  SIRegister_TSynMethodChain(CL);
  SIRegister_TSynNotifyEventChain(CL);
  SIRegister_TSynInternalImage(CL);
 //CL.AddConstantN('BorderWidth','LongInt').SetInt( 2);
 //CL.AddConstantN('BorderWidth','LongInt').SetInt( 0);
  CL.AddTypeS('TSynBorderStyle', 'TBorderStyle');
  CL.AddTypeS('THKModifier', '( hkShift, hkCtrl, hkAlt )');
  CL.AddTypeS('THKModifiers', 'set of THKModifier');
  CL.AddTypeS('THKInvalidKey', '( hcNone, hcShift, hcCtrl, hcAlt, hcShiftCtrl, '
   +'hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt )');
  CL.AddTypeS('THKInvalidKeys', 'set of THKInvalidKey');
  SIRegister_TSynHotKey(CL);
  SIRegister_TSynEditSearchCustom(CL);
  SIRegister_TBetterRegistry(CL);
  CL.AddTypeS('TBetterRegistry', 'TRegistry');
  SIRegister_TSynEditMark(CL);
  CL.AddTypeS('TSynEditLineMarks', 'array[0..16] of TSynEditMark;');
  SIRegister_TSynEditMarkList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynEditMarkListOnChange_W(Self: TSynEditMarkList; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkListOnChange_R(Self: TSynEditMarkList; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkListCount_R(Self: TSynEditMarkList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkListItems_R(Self: TSynEditMarkList; var T: TSynEditMark; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkOnChange_W(Self: TSynEditMark; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkOnChange_R(Self: TSynEditMark; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkIsBookmark_R(Self: TSynEditMark; var T: boolean);
begin T := Self.IsBookmark; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkInternalImage_W(Self: TSynEditMark; const T: boolean);
begin Self.InternalImage := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkInternalImage_R(Self: TSynEditMark; var T: boolean);
begin T := Self.InternalImage; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkVisible_W(Self: TSynEditMark; const T: boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkVisible_R(Self: TSynEditMark; var T: boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkBookmarkNumber_W(Self: TSynEditMark; const T: integer);
begin Self.BookmarkNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkBookmarkNumber_R(Self: TSynEditMark; var T: integer);
begin T := Self.BookmarkNumber; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkImageIndex_W(Self: TSynEditMark; const T: integer);
begin Self.ImageIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkImageIndex_R(Self: TSynEditMark; var T: integer);
begin T := Self.ImageIndex; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkChar_W(Self: TSynEditMark; const T: integer);
begin Self.Char := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkChar_R(Self: TSynEditMark; var T: integer);
begin T := Self.Char; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkLine_W(Self: TSynEditMark; const T: integer);
begin Self.Line := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditMarkLine_R(Self: TSynEditMark; var T: integer);
begin T := Self.Line; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchCustomOptions_W(Self: TSynEditSearchCustom; const T: TSynSearchOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchCustomLengths_R(Self: TSynEditSearchCustom; var T: integer; const t1: integer);
begin T := Self.Lengths[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchCustomResults_R(Self: TSynEditSearchCustom; var T: integer; const t1: integer);
begin T := Self.Results[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchCustomResultCount_R(Self: TSynEditSearchCustom; var T: integer);
begin T := Self.ResultCount; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchCustomPattern_W(Self: TSynEditSearchCustom; const T: string);
begin Self.Pattern := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynEditSearchCustomPattern_R(Self: TSynEditSearchCustom; var T: string);
begin T := Self.Pattern; end;

(*----------------------------------------------------------------------------*)
procedure TSynHotKeyModifiers_W(Self: TSynHotKey; const T: THKModifiers);
begin Self.Modifiers := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHotKeyModifiers_R(Self: TSynHotKey; var T: THKModifiers);
begin T := Self.Modifiers; end;

(*----------------------------------------------------------------------------*)
procedure TSynHotKeyInvalidKeys_W(Self: TSynHotKey; const T: THKInvalidKeys);
begin Self.InvalidKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHotKeyInvalidKeys_R(Self: TSynHotKey; var T: THKInvalidKeys);
begin T := Self.InvalidKeys; end;

(*----------------------------------------------------------------------------*)
procedure TSynHotKeyHotKey_W(Self: TSynHotKey; const T: TShortCut);
begin Self.HotKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHotKeyHotKey_R(Self: TSynHotKey; var T: TShortCut);
begin T := Self.HotKey; end;

(*----------------------------------------------------------------------------*)
procedure TSynHotKeyBorderStyle_W(Self: TSynHotKey; const T: TSynBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHotKeyBorderStyle_R(Self: TSynHotKey; var T: TSynBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TSynNotifyEventChainSender_W(Self: TSynNotifyEventChain; const T: TObject);
begin Self.Sender := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynNotifyEventChainSender_R(Self: TSynNotifyEventChain; var T: TObject);
begin T := Self.Sender; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphOnChange_W(Self: TSynGlyph; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphOnChange_R(Self: TSynGlyph; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphVisible_W(Self: TSynGlyph; const T: boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphVisible_R(Self: TSynGlyph; var T: boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphMaskColor_W(Self: TSynGlyph; const T: TColor);
begin Self.MaskColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphMaskColor_R(Self: TSynGlyph; var T: TColor);
begin T := Self.MaskColor; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphGlyph_W(Self: TSynGlyph; const T: TBitmap);
begin Self.Glyph := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphGlyph_R(Self: TSynGlyph; var T: TBitmap);
begin T := Self.Glyph; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphHeight_R(Self: TSynGlyph; var T: integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TSynGlyphWidth_R(Self: TSynGlyph; var T: integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptOnChange_W(Self: TSynBookMarkOpt; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptOnChange_R(Self: TSynBookMarkOpt; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptXoffset_W(Self: TSynBookMarkOpt; const T: integer);
begin Self.Xoffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptXoffset_R(Self: TSynBookMarkOpt; var T: integer);
begin T := Self.Xoffset; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptLeftMargin_W(Self: TSynBookMarkOpt; const T: Integer);
begin Self.LeftMargin := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptLeftMargin_R(Self: TSynBookMarkOpt; var T: Integer);
begin T := Self.LeftMargin; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptGlyphsVisible_W(Self: TSynBookMarkOpt; const T: Boolean);
begin Self.GlyphsVisible := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptGlyphsVisible_R(Self: TSynBookMarkOpt; var T: Boolean);
begin T := Self.GlyphsVisible; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptEnableKeys_W(Self: TSynBookMarkOpt; const T: Boolean);
begin Self.EnableKeys := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptEnableKeys_R(Self: TSynBookMarkOpt; var T: Boolean);
begin T := Self.EnableKeys; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptDrawBookmarksFirst_W(Self: TSynBookMarkOpt; const T: boolean);
begin Self.DrawBookmarksFirst := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptDrawBookmarksFirst_R(Self: TSynBookMarkOpt; var T: boolean);
begin T := Self.DrawBookmarksFirst; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptBookmarkImages_W(Self: TSynBookMarkOpt; const T: TImageList);
begin Self.BookmarkImages := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBookMarkOptBookmarkImages_R(Self: TSynBookMarkOpt; var T: TImageList);
begin T := Self.BookmarkImages; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterOnChange_W(Self: TSynGutter; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterOnChange_R(Self: TSynGutter; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterGradientSteps_W(Self: TSynGutter; const T: Integer);
begin Self.GradientSteps := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterGradientSteps_R(Self: TSynGutter; var T: Integer);
begin T := Self.GradientSteps; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterGradientEndColor_W(Self: TSynGutter; const T: TColor);
begin Self.GradientEndColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterGradientEndColor_R(Self: TSynGutter; var T: TColor);
begin T := Self.GradientEndColor; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterGradientStartColor_W(Self: TSynGutter; const T: TColor);
begin Self.GradientStartColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterGradientStartColor_R(Self: TSynGutter; var T: TColor);
begin T := Self.GradientStartColor; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterGradient_W(Self: TSynGutter; const T: Boolean);
begin Self.Gradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterGradient_R(Self: TSynGutter; var T: Boolean);
begin T := Self.Gradient; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterLineNumberStart_W(Self: TSynGutter; const T: Integer);
begin Self.LineNumberStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterLineNumberStart_R(Self: TSynGutter; var T: Integer);
begin T := Self.LineNumberStart; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterZeroStart_W(Self: TSynGutter; const T: boolean);
begin Self.ZeroStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterZeroStart_R(Self: TSynGutter; var T: boolean);
begin T := Self.ZeroStart; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterWidth_W(Self: TSynGutter; const T: integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterWidth_R(Self: TSynGutter; var T: integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterVisible_W(Self: TSynGutter; const T: boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterVisible_R(Self: TSynGutter; var T: boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterUseFontStyle_W(Self: TSynGutter; const T: boolean);
begin Self.UseFontStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterUseFontStyle_R(Self: TSynGutter; var T: boolean);
begin T := Self.UseFontStyle; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterShowLineNumbers_W(Self: TSynGutter; const T: boolean);
begin Self.ShowLineNumbers := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterShowLineNumbers_R(Self: TSynGutter; var T: boolean);
begin T := Self.ShowLineNumbers; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterRightOffset_W(Self: TSynGutter; const T: integer);
begin Self.RightOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterRightOffset_R(Self: TSynGutter; var T: integer);
begin T := Self.RightOffset; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterLeftOffset_W(Self: TSynGutter; const T: integer);
begin Self.LeftOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterLeftOffset_R(Self: TSynGutter; var T: integer);
begin T := Self.LeftOffset; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterLeadingZeros_W(Self: TSynGutter; const T: boolean);
begin Self.LeadingZeros := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterLeadingZeros_R(Self: TSynGutter; var T: boolean);
begin T := Self.LeadingZeros; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterFont_W(Self: TSynGutter; const T: TFont);
begin Self.Font := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterFont_R(Self: TSynGutter; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterDigitCount_W(Self: TSynGutter; const T: integer);
begin Self.DigitCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterDigitCount_R(Self: TSynGutter; var T: integer);
begin T := Self.DigitCount; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterCursor_W(Self: TSynGutter; const T: TCursor);
begin Self.Cursor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterCursor_R(Self: TSynGutter; var T: TCursor);
begin T := Self.Cursor; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterBorderColor_W(Self: TSynGutter; const T: TColor);
begin Self.BorderColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterBorderColor_R(Self: TSynGutter; var T: TColor);
begin T := Self.BorderColor; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterColor_W(Self: TSynGutter; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterColor_R(Self: TSynGutter; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterBorderStyle_W(Self: TSynGutter; const T: TSynGutterBorderStyle);
begin Self.BorderStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterBorderStyle_R(Self: TSynGutter; var T: TSynGutterBorderStyle);
begin T := Self.BorderStyle; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterAutoSize_W(Self: TSynGutter; const T: boolean);
begin Self.AutoSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGutterAutoSize_R(Self: TSynGutter; var T: boolean);
begin T := Self.AutoSize; end;

(*----------------------------------------------------------------------------*)
procedure TSynSelectedColorOnChange_W(Self: TSynSelectedColor; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynSelectedColorOnChange_R(Self: TSynSelectedColor; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynSelectedColorForeground_W(Self: TSynSelectedColor; const T: TColor);
begin Self.Foreground := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynSelectedColorForeground_R(Self: TSynSelectedColor; var T: TColor);
begin T := Self.Foreground; end;

(*----------------------------------------------------------------------------*)
procedure TSynSelectedColorBackground_W(Self: TSynSelectedColor; const T: TColor);
begin Self.Background := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynSelectedColorBackground_R(Self: TSynSelectedColor; var T: TColor);
begin T := Self.Background; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditMarkList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditMarkList) do
  begin
    RegisterConstructor(@TSynEditMarkList.Create, 'Create');
    RegisterMethod(@TSynEditMarkList.Add, 'Add');
    RegisterMethod(@TSynEditMarkList.Remove, 'Remove');
    RegisterMethod(@TSynEditMarkList.ClearLine, 'ClearLine');
    RegisterMethod(@TSynEditMarkList.Clear, 'Clear');
    RegisterMethod(@TSynEditMarkList.GetMarksForLine, 'GetMarksForLine');
    RegisterPropertyHelper(@TSynEditMarkListItems_R,nil,'Items');
    RegisterPropertyHelper(@TSynEditMarkListCount_R,nil,'Count');
    RegisterPropertyHelper(@TSynEditMarkListOnChange_R,@TSynEditMarkListOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditMark(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditMark) do
  begin
    RegisterConstructor(@TSynEditMark.Create, 'Create');
    RegisterPropertyHelper(@TSynEditMarkLine_R,@TSynEditMarkLine_W,'Line');
    RegisterPropertyHelper(@TSynEditMarkChar_R,@TSynEditMarkChar_W,'Char');
    RegisterPropertyHelper(@TSynEditMarkImageIndex_R,@TSynEditMarkImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TSynEditMarkBookmarkNumber_R,@TSynEditMarkBookmarkNumber_W,'BookmarkNumber');
    RegisterPropertyHelper(@TSynEditMarkVisible_R,@TSynEditMarkVisible_W,'Visible');
    RegisterPropertyHelper(@TSynEditMarkInternalImage_R,@TSynEditMarkInternalImage_W,'InternalImage');
    RegisterPropertyHelper(@TSynEditMarkIsBookmark_R,nil,'IsBookmark');
    RegisterPropertyHelper(@TSynEditMarkOnChange_R,@TSynEditMarkOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBetterRegistry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBetterRegistry) do
  begin
    RegisterMethod(@TBetterRegistry.OpenKeyReadOnly, 'OpenKeyReadOnly');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynEditSearchCustom(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynEditSearchCustom) do begin
    //RegisterVirtualAbstractMethod(@TSynEditSearchCustom, @!.FindAll, 'FindAll');
    //RegisterVirtualAbstractMethod(@TSynEditSearchCustom, @!.Replace, 'Replace');
    //RegisterPropertyHelper(@TSynEditSearchCustomPattern_R,@TSynEditSearchCustomPattern_W,'Pattern');
    RegisterPropertyHelper(@TSynEditSearchCustomResultCount_R,nil,'ResultCount');
    RegisterPropertyHelper(@TSynEditSearchCustomResults_R,nil,'Results');
    RegisterPropertyHelper(@TSynEditSearchCustomLengths_R,nil,'Lengths');
    RegisterPropertyHelper(nil,@TSynEditSearchCustomOptions_W,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynHotKey(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynHotKey) do begin
    RegisterConstructor(@TSynHotKey.Create, 'Create');
    RegisterPropertyHelper(@TSynHotKeyBorderStyle_R,@TSynHotKeyBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TSynHotKeyHotKey_R,@TSynHotKeyHotKey_W,'HotKey');
    RegisterPropertyHelper(@TSynHotKeyInvalidKeys_R,@TSynHotKeyInvalidKeys_W,'InvalidKeys');
    RegisterPropertyHelper(@TSynHotKeyModifiers_R,@TSynHotKeyModifiers_W,'Modifiers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynInternalImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynInternalImage) do
  begin
    RegisterConstructor(@TSynInternalImage.Create, 'Create');
    RegisterMethod(@TSynInternalImage.Draw, 'Draw');
    RegisterMethod(@TSynInternalImage.DrawTransparent, 'DrawTransparent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynNotifyEventChain(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynNotifyEventChain) do
  begin
    RegisterConstructor(@TSynNotifyEventChain.CreateEx, 'CreateEx');
    RegisterMethod(@TSynNotifyEventChain.Add, 'Add');
    RegisterMethod(@TSynNotifyEventChain.Remove, 'Remove');
    RegisterPropertyHelper(@TSynNotifyEventChainSender_R,@TSynNotifyEventChainSender_W,'Sender');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynMethodChain(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynMethodChain) do
  begin
    RegisterConstructor(@TSynMethodChain.Create, 'Create');
    RegisterMethod(@TSynMethodChain.Add, 'Add');
    RegisterMethod(@TSynMethodChain.Remove, 'Remove');
    RegisterMethod(@TSynMethodChain.Fire, 'Fire');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynGlyph(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynGlyph) do
  begin
    RegisterConstructor(@TSynGlyph.Create, 'Create');
    RegisterMethod(@TSynGlyph.Assign, 'Assign');
    RegisterMethod(@TSynGlyph.Draw, 'Draw');
    RegisterPropertyHelper(@TSynGlyphWidth_R,nil,'Width');
    RegisterPropertyHelper(@TSynGlyphHeight_R,nil,'Height');
    RegisterPropertyHelper(@TSynGlyphGlyph_R,@TSynGlyphGlyph_W,'Glyph');
    RegisterPropertyHelper(@TSynGlyphMaskColor_R,@TSynGlyphMaskColor_W,'MaskColor');
    RegisterPropertyHelper(@TSynGlyphVisible_R,@TSynGlyphVisible_W,'Visible');
    RegisterPropertyHelper(@TSynGlyphOnChange_R,@TSynGlyphOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynBookMarkOpt(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynBookMarkOpt) do
  begin
    RegisterConstructor(@TSynBookMarkOpt.Create, 'Create');
    RegisterMethod(@TSynBookMarkOpt.Assign, 'Assign');
    RegisterPropertyHelper(@TSynBookMarkOptBookmarkImages_R,@TSynBookMarkOptBookmarkImages_W,'BookmarkImages');
    RegisterPropertyHelper(@TSynBookMarkOptDrawBookmarksFirst_R,@TSynBookMarkOptDrawBookmarksFirst_W,'DrawBookmarksFirst');
    RegisterPropertyHelper(@TSynBookMarkOptEnableKeys_R,@TSynBookMarkOptEnableKeys_W,'EnableKeys');
    RegisterPropertyHelper(@TSynBookMarkOptGlyphsVisible_R,@TSynBookMarkOptGlyphsVisible_W,'GlyphsVisible');
    RegisterPropertyHelper(@TSynBookMarkOptLeftMargin_R,@TSynBookMarkOptLeftMargin_W,'LeftMargin');
    RegisterPropertyHelper(@TSynBookMarkOptXoffset_R,@TSynBookMarkOptXoffset_W,'Xoffset');
    RegisterPropertyHelper(@TSynBookMarkOptOnChange_R,@TSynBookMarkOptOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynGutter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynGutter) do
  begin
    RegisterConstructor(@TSynGutter.Create, 'Create');
    RegisterMethod(@TSynGutter.Assign, 'Assign');
    RegisterMethod(@TSynGutter.AutoSizeDigitCount, 'AutoSizeDigitCount');
    RegisterMethod(@TSynGutter.FormatLineNumber, 'FormatLineNumber');
    RegisterMethod(@TSynGutter.RealGutterWidth, 'RealGutterWidth');
    RegisterPropertyHelper(@TSynGutterAutoSize_R,@TSynGutterAutoSize_W,'AutoSize');
    RegisterPropertyHelper(@TSynGutterBorderStyle_R,@TSynGutterBorderStyle_W,'BorderStyle');
    RegisterPropertyHelper(@TSynGutterColor_R,@TSynGutterColor_W,'Color');
    RegisterPropertyHelper(@TSynGutterBorderColor_R,@TSynGutterBorderColor_W,'BorderColor');
    RegisterPropertyHelper(@TSynGutterCursor_R,@TSynGutterCursor_W,'Cursor');
    RegisterPropertyHelper(@TSynGutterDigitCount_R,@TSynGutterDigitCount_W,'DigitCount');
    RegisterPropertyHelper(@TSynGutterFont_R,@TSynGutterFont_W,'Font');
    RegisterPropertyHelper(@TSynGutterLeadingZeros_R,@TSynGutterLeadingZeros_W,'LeadingZeros');
    RegisterPropertyHelper(@TSynGutterLeftOffset_R,@TSynGutterLeftOffset_W,'LeftOffset');
    RegisterPropertyHelper(@TSynGutterRightOffset_R,@TSynGutterRightOffset_W,'RightOffset');
    RegisterPropertyHelper(@TSynGutterShowLineNumbers_R,@TSynGutterShowLineNumbers_W,'ShowLineNumbers');
    RegisterPropertyHelper(@TSynGutterUseFontStyle_R,@TSynGutterUseFontStyle_W,'UseFontStyle');
    RegisterPropertyHelper(@TSynGutterVisible_R,@TSynGutterVisible_W,'Visible');
    RegisterPropertyHelper(@TSynGutterWidth_R,@TSynGutterWidth_W,'Width');
    RegisterPropertyHelper(@TSynGutterZeroStart_R,@TSynGutterZeroStart_W,'ZeroStart');
    RegisterPropertyHelper(@TSynGutterLineNumberStart_R,@TSynGutterLineNumberStart_W,'LineNumberStart');
    RegisterPropertyHelper(@TSynGutterGradient_R,@TSynGutterGradient_W,'Gradient');
    RegisterPropertyHelper(@TSynGutterGradientStartColor_R,@TSynGutterGradientStartColor_W,'GradientStartColor');
    RegisterPropertyHelper(@TSynGutterGradientEndColor_R,@TSynGutterGradientEndColor_W,'GradientEndColor');
    RegisterPropertyHelper(@TSynGutterGradientSteps_R,@TSynGutterGradientSteps_W,'GradientSteps');
    RegisterPropertyHelper(@TSynGutterOnChange_R,@TSynGutterOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynSelectedColor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynSelectedColor) do
  begin
    RegisterConstructor(@TSynSelectedColor.Create, 'Create');
    RegisterMethod(@TSynSelectedColor.Assign, 'Assign');
    RegisterPropertyHelper(@TSynSelectedColorBackground_R,@TSynSelectedColorBackground_W,'Background');
    RegisterPropertyHelper(@TSynSelectedColorForeground_R,@TSynSelectedColorForeground_W,'Foreground');
    RegisterPropertyHelper(@TSynSelectedColorOnChange_R,@TSynSelectedColorOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditMiscClasses(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynSelectedColor(CL);
  RIRegister_TSynGutter(CL);
  RIRegister_TSynBookMarkOpt(CL);
  RIRegister_TSynGlyph(CL);
  with CL.Add(ESynMethodChain) do
  RIRegister_TSynMethodChain(CL);
  RIRegister_TSynNotifyEventChain(CL);
  RIRegister_TSynInternalImage(CL);
  RIRegister_TSynHotKey(CL);
  RIRegister_TSynEditSearchCustom(CL);
  RIRegister_TBetterRegistry(CL);
  RIRegister_TSynEditMark(CL);
  RIRegister_TSynEditMarkList(CL);
end;

 
 
{ TPSImport_SynEditMiscClasses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditMiscClasses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditMiscClasses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditMiscClasses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditMiscClasses(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
