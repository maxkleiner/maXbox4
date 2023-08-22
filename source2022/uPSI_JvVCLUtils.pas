unit uPSI_JvVCLUtils;
{
added inc files
  add with unit JvJVCLUtils;

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
  TPSImport_JvVCLUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TResourceStream(CL: TPSPascalCompiler);
procedure SIRegister_TMetafileCanvas(CL: TPSPascalCompiler);
procedure SIRegister_TBits(CL: TPSPascalCompiler);
procedure SIRegister_TJvScreenCanvas(CL: TPSPascalCompiler);
procedure SIRegister_JvVCLUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TResourceStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMetafileCanvas(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBits(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvScreenCanvas(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvVCLUtils(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvVCLUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   RTLConsts
  ,Variants
  ,Windows
  ,Graphics
  ,Forms
  ,Controls
  ,Dialogs
  ,ImgList
  ,JvVCLUtils_max
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvVCLUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TResourceStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THandleStream', 'TResourceStream') do
  with CL.AddClassN(CL.FindClass('THandleStream'),'TResourceStream') do begin
    RegisterMethod('Constructor Create( Instance : THandle; const ResName : string; ResType : PChar)');
    RegisterMethod('Constructor CreateFromID( Instance : THandle; ResID : Integer; ResType : PChar)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMetafileCanvas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCanvas', 'TMetafileCanvas') do
  with CL.AddClassN(CL.FindClass('TCanvas'),'TMetafileCanvas') do
  begin
    RegisterMethod('Constructor Create( AMetafile : TMetafile; ReferenceDevice : HDC)');
    RegisterProperty('Metafile', 'TMetafile', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBits(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TBits') do
  with CL.AddClassN(CL.FindClass('TObject'),'TBits') do begin
    RegisterMethod('Function OpenBit : Integer');
    RegisterProperty('Bits', 'Boolean Integer', iptrw);
    SetDefaultPropery('Bits');
    RegisterProperty('Size', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvScreenCanvas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCanvas', 'TJvScreenCanvas') do
  with CL.AddClassN(CL.FindClass('TCanvas'),'TJvScreenCanvas') do begin
    RegisterMethod('Procedure SetOrigin( X, Y : Integer)');
    RegisterMethod('Procedure FreeHandle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvVCLUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure DrawBitmapTransparent( Dest : TCanvas; DstX, DstY : Integer; Bitmap : TBitmap; TransparentColor : TColor)');
 CL.AddDelphiFunction('Procedure DrawBitmapRectTransparent( Dest : TCanvas; DstX, DstY : Integer; SrcRect : TRect; Bitmap : TBitmap; TransparentColor : TColor)');
 CL.AddDelphiFunction('Procedure StretchBitmapRectTransparent( Dest : TCanvas; DstX, DstY, DstW, DstH : Integer; SrcRect : TRect; Bitmap : TBitmap; TransparentColor : TColor)');
 CL.AddDelphiFunction('Function MakeBitmap( ResID : PChar) : TBitmap');
 CL.AddDelphiFunction('Function MakeBitmapID( ResID : Word) : TBitmap');
 CL.AddDelphiFunction('Function MakeModuleBitmap( Module : THandle; ResID : PChar) : TBitmap');
 CL.AddDelphiFunction('Function CreateTwoColorsBrushPattern( Color1, Color2 : TColor) : TBitmap');
 CL.AddDelphiFunction('Function CreateDisabledBitmap_NewStyle( FOriginal : TBitmap; BackColor : TColor) : TBitmap');
 CL.AddDelphiFunction('Function CreateDisabledBitmapEx( FOriginal : TBitmap; OutlineColor, BackColor, HighlightColor, ShadowColor : TColor; DrawHighlight : Boolean) : TBitmap');
 CL.AddDelphiFunction('Function CreateDisabledBitmap( FOriginal : TBitmap; OutlineColor : TColor) : TBitmap');
 CL.AddDelphiFunction('Function ChangeBitmapColor( Bitmap : TBitmap; Color, NewColor : TColor) : TBitmap');
 CL.AddDelphiFunction('Procedure AssignBitmapCell( Source : TGraphic; Dest : TBitmap; Cols, Rows, Index : Integer)');
 //CL.AddDelphiFunction('Procedure ImageListDrawDisabled( Images : TImageList; Canvas : TCanvas; X, Y, Index : Integer; HighlightColor, GrayColor : TColor; DrawHighlight : Boolean)');
 CL.AddDelphiFunction('Function MakeIcon( ResID : PChar) : TIcon');
 CL.AddDelphiFunction('Function MakeIconID( ResID : Word) : TIcon');
 CL.AddDelphiFunction('Function MakeModuleIcon( Module : THandle; ResID : PChar) : TIcon');
 CL.AddDelphiFunction('Function CreateBitmapFromIcon( Icon : TIcon; BackColor : TColor) : TBitmap');
 CL.AddDelphiFunction('Function CreateIconFromBitmap( Bitmap : TBitmap; TransparentColor : TColor) : TIcon');
 CL.AddDelphiFunction('Procedure NotImplemented');
 CL.AddDelphiFunction('Procedure ResourceNotFound( ResID : PChar)');
 CL.AddDelphiFunction('Function PointInRect( const P : TPoint; const R : TRect) : Boolean');
 CL.AddDelphiFunction('Function PointInPolyRgn( const P : TPoint; const Points : array of TPoint) : Boolean');
 CL.AddDelphiFunction('Function PaletteColor( Color : TColor) : Longint');
 CL.AddDelphiFunction('Function WidthOf( R : TRect) : Integer');
 CL.AddDelphiFunction('Function HeightOf( R : TRect) : Integer');
 CL.AddDelphiFunction('Procedure PaintInverseRect( const RectOrg, RectEnd : TPoint)');
 CL.AddDelphiFunction('Procedure DrawInvertFrame( ScreenRect : TRect; Width : Integer)');
 CL.AddDelphiFunction('Procedure CopyParentImage( Control : TControl; Dest : TCanvas)');
 CL.AddDelphiFunction('Procedure Delay( MSecs : Longint)');
 CL.AddDelphiFunction('Procedure CenterControl( Control : TControl)');
 CL.AddDelphiFunction('Procedure ShowMDIClientEdge( ClientHandle : THandle; ShowEdge : Boolean)');
 CL.AddDelphiFunction('Function MakeVariant( const Values : array of Variant) : Variant');
 CL.AddDelphiFunction('Function CreateRotatedFont( Font : TFont; Angle : Integer) : HFONT');
 CL.AddDelphiFunction('Function MsgBox( const Caption, Text : string; Flags : Integer) : Integer');
 CL.AddDelphiFunction('Function MsgDlg( const Msg : string; AType : TMsgDlgType; AButtons : TMsgDlgButtons; HelpCtx : Longint) : Word');
 CL.AddDelphiFunction('Function FindPrevInstance( const MainFormClass : ShortString; const ATitle : string) : HWND');
 CL.AddDelphiFunction('Function ActivatePrevInstance( const MainFormClass : ShortString; const ATitle : string) : Boolean');
 CL.AddDelphiFunction('Function FindPrevInstance( const MainFormClass, ATitle : string) : HWND');
 CL.AddDelphiFunction('Function ActivatePrevInstance( const MainFormClass, ATitle : string) : Boolean');
 CL.AddDelphiFunction('Function IsForegroundTask : Boolean');
 CL.AddDelphiFunction('Procedure MergeForm( AControl : TWinControl; AForm : TForm; Align : TAlign; Show : Boolean)');
 CL.AddDelphiFunction('Function GetAveCharSize( Canvas : TCanvas) : TPoint');
 CL.AddDelphiFunction('Function MinimizeText( const Text : string; Canvas : TCanvas; MaxWidth : Integer) : string');
 CL.AddDelphiFunction('Procedure FreeUnusedOle');
 CL.AddDelphiFunction('Procedure Beep');
 CL.AddDelphiFunction('Function GetWindowsVersionJ: string');
 CL.AddDelphiFunction('Function LoadDLL( const LibName : string) : THandle');
 CL.AddDelphiFunction('Function RegisterServer( const ModuleName : string) : Boolean');
 CL.AddDelphiFunction('Function IsLibrary : Boolean');
  CL.AddTypeS('TFillDirection', '( fdTopToBottom, fdBottomToTop, fdLeftToRight,'
   +' fdRightToLeft )');
 CL.AddDelphiFunction('Procedure GradientFillRect( Canvas : TCanvas; ARect : TRect; StartColor, EndColor : TColor; Direction : TFillDirection; Colors : Byte)');
 CL.AddDelphiFunction('Function GetEnvVar( const VarName : string) : string');
 CL.AddDelphiFunction('Function AnsiUpperFirstChar( const S : string) : string');
 CL.AddDelphiFunction('Function StringToPChar( var S : string) : PChar');
 CL.AddDelphiFunction('Function StrPAlloc( const S : string) : PChar');
 CL.AddDelphiFunction('Procedure SplitCommandLine( const CmdLine : string; var ExeName, Params : string)');
 CL.AddDelphiFunction('Function DropT( const S : string) : string');
 {CL.AddDelphiFunction('Function AllocMemo( Size : Longint) : Pointer');
 CL.AddDelphiFunction('Function ReallocMemo( fpBlock : Pointer; Size : Longint) : Pointer');
 CL.AddDelphiFunction('Procedure FreeMemo( var fpBlock : Pointer)');
 CL.AddDelphiFunction('Function GetMemoSize( fpBlock : Pointer) : Longint');
 CL.AddDelphiFunction('Function CompareMem( fpBlock1, fpBlock2 : Pointer; Size : Cardinal) : Boolean');}
 //CL.AddDelphiFunction('Procedure FreeAndNil( var Obj)');
 {CL.AddDelphiFunction('Procedure HugeInc( var HugePtr : Pointer; Amount : Longint)');
 CL.AddDelphiFunction('Procedure HugeDec( var HugePtr : Pointer; Amount : Longint)');
 CL.AddDelphiFunction('Function HugeOffset( HugePtr : Pointer; Amount : Longint) : Pointer');
 CL.AddDelphiFunction('Procedure HugeMove( Base : Pointer; Dst, Src, Size : Longint)');
 CL.AddDelphiFunction('Procedure HMemCpy( DstPtr, SrcPtr : Pointer; Amount : Longint)');
 CL.AddDelphiFunction('Procedure ZeroMemory( Ptr : Pointer; Length : Longint)');
 CL.AddDelphiFunction('Procedure FillMemory( Ptr : Pointer; Length : Longint; Fill : Byte)');}
 //CL.AddConstantN('clInfoBk','LongWord').SetUInt( TColor ( $02E1FFFF ));
 //CL.AddConstantN('clNone','LongWord').SetUInt( TColor ( $02FFFFFF ));
 CL.AddConstantN('clCream','LongWord').SetUInt(TColor($A6CAF0));
 CL.AddConstantN('clMoneyGreen','LongWord').SetUInt(TColor($C0DCC0));
 CL.AddConstantN('clSkyBlue','LongWord').SetUInt(TColor($FFFBF0));
// CL.AddConstantN('mrNoToAll','LongInt').SetInt( mrAll + 1);
// CL.AddConstantN('mrYesToAll','LongInt').SetInt( mrNoToAll + 1);
 CL.AddConstantN('WM_MOUSEWHEEL','LongWord').SetUInt( $020A);
 CL.AddConstantN('WHEEL_DELTA','LongInt').SetInt( 120);
 //CL.AddConstantN('WHEEL_PAGESCROLL','').SetInt( MAXDWORD);
 CL.AddConstantN('SM_MOUSEWHEELPRESENT','LongInt').SetInt( 75);
 CL.AddConstantN('MOUSEEVENTF_WHEEL','LongWord').SetUInt( $0800);
 CL.AddConstantN('SPI_GETWHEELSCROLLLINES','LongInt').SetInt( 104);
 CL.AddConstantN('SPI_SETWHEELSCROLLLINES','LongInt').SetInt( 105);
 CL.AddConstantN('WaitCursor','TCursor').SetInt( crHourGlass);
 CL.AddDelphiFunction('Procedure StartWait');
 CL.AddDelphiFunction('Procedure StopWait');
 CL.AddDelphiFunction('Function DefineCursor( Instance : THandle; ResID : PChar) : TCursor');
 CL.AddDelphiFunction('Function LoadAniCursor( Instance : THandle; ResID : PChar) : HCURSOR');
 CL.AddDelphiFunction('Procedure StretchBltTransparent( DstDC : HDC; DstX, DstY, DstW, DstH : Integer; SrcDC : HDC; SrcX, SrcY, SrcW, SrcH : Integer; Palette : HPALETTE; TransparentColor : TColorRef)');
 // tcolorref
 CL.AddDelphiFunction('Procedure DrawTransparentBitmap( DC : HDC; Bitmap : HBITMAP; DstX, DstY : Integer; TransparentColor : TColorRef)');
 CL.AddDelphiFunction('Function PaletteEntries( Palette : HPALETTE) : Integer');
 CL.AddDelphiFunction('Function WindowClassName( Wnd : HWND) : string');
 CL.AddDelphiFunction('Function ScreenWorkArea : TRect');
 CL.AddDelphiFunction('Procedure MoveWindowOrg( DC : HDC; DX, DY : Integer)');
 CL.AddDelphiFunction('Procedure SwitchToWindow( Wnd : HWND; Restore : Boolean)');
 CL.AddDelphiFunction('Procedure ActivateWindow( Wnd : HWND)');
 CL.AddDelphiFunction('Procedure ShowWinNoAnimate( Handle : HWND; CmdShow : Integer)');
 CL.AddDelphiFunction('Procedure CenterWindow( Wnd : HWND)');
 CL.AddDelphiFunction('Procedure ShadeRect( DC : HDC; const Rect : TRect)');
 CL.AddDelphiFunction('Procedure KillMessage( Wnd : HWND; Msg : Cardinal)');
 CL.AddDelphiFunction('Function DialogUnitsToPixelsX( DlgUnits : Word) : Word');
 CL.AddDelphiFunction('Function DialogUnitsToPixelsY( DlgUnits : Word) : Word');
 CL.AddDelphiFunction('Function PixelsToDialogUnitsX( PixUnits : Word) : Word');
 CL.AddDelphiFunction('Function PixelsToDialogUnitsY( PixUnits : Word) : Word');
  CL.AddTypeS('TVertAlignment', '( vaTopJustify, vaCenter, vaBottomJustify )');
 CL.AddDelphiFunction('Procedure WriteText( ACanvas : TCanvas; ARect : TRect; DX, DY : Integer; const Text : string; Alignment : TAlignment; WordWrap : Boolean; ARightToLeft : Boolean)');
 CL.AddDelphiFunction('Procedure DrawCellText( Control : TCustomControl; ACol, ARow : Longint; const S : string; const ARect : TRect; Align : TAlignment; VertAlign : TVertAlignment);');
 CL.AddDelphiFunction('Procedure DrawCellTextEx( Control : TCustomControl; ACol, ARow : Longint; const S : string; const ARect : TRect; Align : TAlignment; VertAlign : TVertAlignment; WordWrap : Boolean);');
 CL.AddDelphiFunction('Procedure DrawCellText1( Control : TCustomControl; ACol, ARow : Longint; const S : string; const ARect : TRect; Align : TAlignment; VertAlign : TVertAlignment; ARightToLeft : Boolean);');
 CL.AddDelphiFunction('Procedure DrawCellTextEx2( Control : TCustomControl; ACol, ARow : Longint; const S : string; const ARect : TRect; Align : TAlignment; VertAlign : TVertAlignment; WordWrap : Boolean; ARightToLeft : Boolean);');
 CL.AddDelphiFunction('Procedure DrawCellBitmap( Control : TCustomControl; ACol, ARow : Longint; Bmp : TGraphic; Rect : TRect)');
  SIRegister_TJvScreenCanvas(CL);
  SIRegister_TBits(CL);
  SIRegister_TMetafileCanvas(CL);
  SIRegister_TResourceStream(CL);
 CL.AddDelphiFunction('Function GetCurrentDir : string');
 CL.AddDelphiFunction('Function SetCurrentDir( const Dir : string) : Boolean');
 CL.AddDelphiFunction('Function CheckWin32( OK : Boolean) : Boolean');
 CL.AddDelphiFunction('Function Win32Check( RetVal : Bool) : Bool');
 CL.AddDelphiFunction('Procedure RaiseWin32Error( ErrorCode : DWORD)');
  CL.AddTypeS('TCustomForm', 'TForm');
  CL.AddTypeS('TDate', 'TDateTime');
  CL.AddTypeS('TTime', 'TDateTime');
 //CL.AddDelphiFunction('Function ResStr( Ident : Cardinal) : string');
 CL.AddDelphiFunction('Function ResStr( const Ident : string) : string');
 // CL.AddTypeS('Longword', 'Longint');
  CL.AddDelphiFunction('function DualInputQuery(const ACaption, Prompt1, Prompt2: string; var AValue1, AValue2: string; PasswordChar: Char): Boolean;');
 CL.AddDelphiFunction('procedure MsgAbout(Handle: Integer; const Msg, Caption: string; const IcoName: string; Flags: DWORD)');
CL.AddDelphiFunction('procedure LoadIcoToImage(ALarge, ASmall: TCustomImageList; const NameRes: string)');
//from jvjvclutils

 (*tagSIZE = packed record
    cx: Longint;
    cy: Longint;
  end;  {$EXTERNALSYM tagSIZE} TSize = tagSIZE;*)
  CL.AddTypeS('TSize2', 'record cx: Longint; cy: Longint; end');

CL.AddDelphiFunction('Function CanvasMaxTextHeight( Canvas : TCanvas) : Integer');
 CL.AddDelphiFunction('Function ReplaceComponentReference( This, NewReference : TComponent; var VarReference : TComponent) : Boolean');
 CL.AddDelphiFunction('Procedure DrawLine( Canvas : TCanvas; X, Y, X2, Y2 : Integer)');
 CL.AddDelphiFunction('Function IsPositiveResult( Value : TModalResult) : Boolean');
 CL.AddDelphiFunction('Function IsNegativeResult( Value : TModalResult) : Boolean');
 CL.AddDelphiFunction('Function IsAbortResult( const Value : TModalResult) : Boolean');
 CL.AddDelphiFunction('Function StripAllFromResult( const Value : TModalResult) : TModalResult');
 CL.AddDelphiFunction('Function SelectColorByLuminance( AColor, DarkColor, BrightColor : TColor) : TColor');
 CL.AddTypeS('TJvHTMLCalcType', '(htmlShow, htmlCalcWidth, htmlCalcHeight, htmlHyperLink )');
 CL.AddDelphiFunction('Procedure HTMLDrawTextEx( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; var Width : Integer; CalcType : TJvHTMLCalcType; MouseX, MouseY : Integer; var MouseOnLink : Boolean; var LinkName: string; Scale: Integer);');
 CL.AddDelphiFunction('Procedure HTMLDrawTextEx1(Canvas: TCanvas; Rect: TRect; const State: TOwnerDrawState; const Text : string; var Width, Height: Integer; CalcType: TJvHTMLCalcType; MouseX, MouseY: Integer; var MouseOnLink : Boolean; var LinkName: string; Scale: Integer);');
 CL.AddDelphiFunction('Function HTMLDrawText( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; Scale : Integer) : string');
 CL.AddDelphiFunction('Function HTMLDrawTextHL( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; MouseX, MouseY : Integer; Scale : Integer) : string');
 CL.AddDelphiFunction('Function HTMLPlainText( const Text : string) : string');
 CL.AddDelphiFunction('Function HTMLTextExtent( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; Scale : Integer) : TSize');
 CL.AddDelphiFunction('Function HTMLTextExtent2( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; Scale : Integer) : TSize2');

 CL.AddDelphiFunction('Function HTMLTextWidth( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; Scale : Integer) : Integer');
 CL.AddDelphiFunction('Function HTMLTextHeight( Canvas : TCanvas; const Text : string; Scale : Integer) : Integer');
 CL.AddDelphiFunction('Function HTMLPrepareText( const Text : string) : string');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMetafileCanvasMetafile_R(Self: TMetafileCanvas; var T: TMetafile);
begin
  //T := Self.Metafile;
 end;

(*----------------------------------------------------------------------------*)
procedure TBitsSize_W(Self: TBits; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitsSize_R(Self: TBits; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TBitsBits_W(Self: TBits; const T: Boolean; const t1: Integer);
begin Self.Bits[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitsBits_R(Self: TBits; var T: Boolean; const t1: Integer);
begin T := Self.Bits[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure DrawCellTextEx2_P( Control : TCustomControl; ACol, ARow : Longint; const S : string; const ARect : TRect; Align : TAlignment; VertAlign : TVertAlignment; WordWrap : Boolean; ARightToLeft : Boolean);
Begin
//JvVCLUtils_max.DrawCellTextEx(Control, ACol, ARow, S, ARect, Align, VertAlign, WordWrap, ARightToLeft);
 END;

(*----------------------------------------------------------------------------*)
Procedure DrawCellText1_P( Control : TCustomControl; ACol, ARow : Longint; const S : string; const ARect : TRect; Align : TAlignment; VertAlign : TVertAlignment; ARightToLeft : Boolean);
Begin
 //JvVCLUtils_max.DrawCellText(Control, ACol, ARow, S, ARect, Align, VertAlign, ARightToLeft);
 END;

(*----------------------------------------------------------------------------*)
Procedure DrawCellTextEx_P( Control : TCustomControl; ACol, ARow : Longint; const S : string; const ARect : TRect; Align : TAlignment; VertAlign : TVertAlignment; WordWrap : Boolean);
Begin
  //JvVCLUtils.DrawCellTextEx(Control, ACol, ARow, S, ARect, Align, VertAlign, WordWrap);
 END;

(*----------------------------------------------------------------------------*)
Procedure DrawCellText_P( Control : TCustomControl; ACol, ARow : Longint; const S : string; const ARect : TRect; Align : TAlignment; VertAlign : TVertAlignment);
Begin
JvVCLUtils_max.DrawCellText(Control, ACol, ARow, S, ARect, Align, VertAlign);
 END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TResourceStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TResourceStream) do begin
    RegisterConstructor(@TResourceStream.Create, 'Create');
    RegisterConstructor(@TResourceStream.CreateFromID, 'CreateFromID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMetafileCanvas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMetafileCanvas) do begin
    RegisterConstructor(@TMetafileCanvas.Create, 'Create');
    RegisterPropertyHelper(@TMetafileCanvasMetafile_R,nil,'Metafile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBits(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBits) do begin
    RegisterMethod(@TBits.OpenBit, 'OpenBit');
    RegisterPropertyHelper(@TBitsBits_R,@TBitsBits_W,'Bits');
    RegisterPropertyHelper(@TBitsSize_R,@TBitsSize_W,'Size');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvScreenCanvas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvScreenCanvas) do begin
    RegisterMethod(@TJvScreenCanvas.SetOrigin, 'SetOrigin');
    RegisterMethod(@TJvScreenCanvas.FreeHandle, 'FreeHandle');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_JvVCLUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DrawBitmapTransparent, 'DrawBitmapTransparent', cdRegister);
 S.RegisterDelphiFunction(@DrawBitmapRectTransparent, 'DrawBitmapRectTransparent', cdRegister);
 S.RegisterDelphiFunction(@StretchBitmapRectTransparent, 'StretchBitmapRectTransparent', cdRegister);
 S.RegisterDelphiFunction(@MakeBitmap, 'MakeBitmap', cdRegister);
 S.RegisterDelphiFunction(@MakeBitmapID, 'MakeBitmapID', cdRegister);
 S.RegisterDelphiFunction(@MakeModuleBitmap, 'MakeModuleBitmap', cdRegister);
 S.RegisterDelphiFunction(@CreateTwoColorsBrushPattern, 'CreateTwoColorsBrushPattern', cdRegister);
 S.RegisterDelphiFunction(@CreateDisabledBitmap_NewStyle, 'CreateDisabledBitmap_NewStyle', cdRegister);
 S.RegisterDelphiFunction(@CreateDisabledBitmapEx, 'CreateDisabledBitmapEx', cdRegister);
 S.RegisterDelphiFunction(@CreateDisabledBitmap, 'CreateDisabledBitmap', cdRegister);
 S.RegisterDelphiFunction(@ChangeBitmapColor, 'ChangeBitmapColor', cdRegister);
 S.RegisterDelphiFunction(@AssignBitmapCell, 'AssignBitmapCell', cdRegister);
 S.RegisterDelphiFunction(@ImageListDrawDisabled, 'ImageListDrawDisabled', cdRegister);
 S.RegisterDelphiFunction(@MakeIcon, 'MakeIcon', cdRegister);
 S.RegisterDelphiFunction(@MakeIconID, 'MakeIconID', cdRegister);
 S.RegisterDelphiFunction(@MakeModuleIcon, 'MakeModuleIcon', cdRegister);
 S.RegisterDelphiFunction(@CreateBitmapFromIcon, 'CreateBitmapFromIcon', cdRegister);
 S.RegisterDelphiFunction(@CreateIconFromBitmap, 'CreateIconFromBitmap', cdRegister);
 S.RegisterDelphiFunction(@NotImplemented, 'NotImplemented', cdRegister);
 S.RegisterDelphiFunction(@ResourceNotFound, 'ResourceNotFound', cdRegister);
 S.RegisterDelphiFunction(@PointInRect, 'PointInRect', cdRegister);
 S.RegisterDelphiFunction(@PointInPolyRgn, 'PointInPolyRgn', cdRegister);
 S.RegisterDelphiFunction(@PaletteColor, 'PaletteColor', cdRegister);
 S.RegisterDelphiFunction(@WidthOf, 'WidthOf', cdRegister);
 S.RegisterDelphiFunction(@HeightOf, 'HeightOf', cdRegister);
 S.RegisterDelphiFunction(@PaintInverseRect, 'PaintInverseRect', cdRegister);
 S.RegisterDelphiFunction(@DrawInvertFrame, 'DrawInvertFrame', cdRegister);
 S.RegisterDelphiFunction(@CopyParentImage, 'CopyParentImage', cdRegister);
 S.RegisterDelphiFunction(@Delay, 'Delay', cdRegister);
 S.RegisterDelphiFunction(@CenterControl, 'CenterControl', cdRegister);
 S.RegisterDelphiFunction(@ShowMDIClientEdge, 'ShowMDIClientEdge', cdRegister);
 S.RegisterDelphiFunction(@MakeVariant, 'MakeVariant', cdRegister);
 S.RegisterDelphiFunction(@CreateRotatedFont, 'CreateRotatedFont', cdRegister);
 S.RegisterDelphiFunction(@MsgBox, 'MsgBox', cdRegister);
 S.RegisterDelphiFunction(@MsgDlg, 'MsgDlg', cdRegister);
 S.RegisterDelphiFunction(@FindPrevInstance, 'FindPrevInstance', cdRegister);
 S.RegisterDelphiFunction(@ActivatePrevInstance, 'ActivatePrevInstance', cdRegister);
 S.RegisterDelphiFunction(@FindPrevInstance, 'FindPrevInstance', cdRegister);
 S.RegisterDelphiFunction(@ActivatePrevInstance, 'ActivatePrevInstance', cdRegister);
 S.RegisterDelphiFunction(@IsForegroundTask, 'IsForegroundTask', cdRegister);
 S.RegisterDelphiFunction(@MergeForm, 'MergeForm', cdRegister);
 S.RegisterDelphiFunction(@GetAveCharSize, 'GetAveCharSize', cdRegister);
 S.RegisterDelphiFunction(@MinimizeText, 'MinimizeText', cdRegister);
 S.RegisterDelphiFunction(@FreeUnusedOle, 'FreeUnusedOle', cdRegister);
 S.RegisterDelphiFunction(@Beep, 'Beep', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsVersion, 'GetWindowsVersionJ', cdRegister);
 S.RegisterDelphiFunction(@LoadDLL, 'LoadDLL', cdRegister);
 S.RegisterDelphiFunction(@RegisterServer, 'RegisterServer', cdRegister);
 S.RegisterDelphiFunction(@IsLibrary, 'IsLibrary', cdRegister);
 S.RegisterDelphiFunction(@GradientFillRect, 'GradientFillRect', cdRegister);
 S.RegisterDelphiFunction(@GetEnvVar, 'GetEnvVar', cdRegister);
 S.RegisterDelphiFunction(@AnsiUpperFirstChar, 'AnsiUpperFirstChar', cdRegister);
 S.RegisterDelphiFunction(@StringToPChar, 'StringToPChar', cdRegister);
 S.RegisterDelphiFunction(@StrPAlloc, 'StrPAlloc', cdRegister);
 S.RegisterDelphiFunction(@SplitCommandLine, 'SplitCommandLine', cdRegister);
 S.RegisterDelphiFunction(@DropT, 'DropT', cdRegister);
 S.RegisterDelphiFunction(@AllocMemo, 'AllocMemo', cdRegister);
 S.RegisterDelphiFunction(@ReallocMemo, 'ReallocMemo', cdRegister);
 S.RegisterDelphiFunction(@FreeMemo, 'FreeMemo', cdRegister);
 S.RegisterDelphiFunction(@GetMemoSize, 'GetMemoSize', cdRegister);
 S.RegisterDelphiFunction(@CompareMem, 'CompareMem', cdRegister);
 S.RegisterDelphiFunction(@FreeAndNil, 'FreeAndNil', cdRegister);
 S.RegisterDelphiFunction(@HugeInc, 'HugeInc', cdRegister);
 S.RegisterDelphiFunction(@HugeDec, 'HugeDec', cdRegister);
 S.RegisterDelphiFunction(@HugeOffset, 'HugeOffset', cdRegister);
 S.RegisterDelphiFunction(@HugeMove, 'HugeMove', cdRegister);
 S.RegisterDelphiFunction(@HMemCpy, 'HMemCpy', cdRegister);
 S.RegisterDelphiFunction(@ZeroMemory, 'ZeroMemory', cdRegister);
 S.RegisterDelphiFunction(@FillMemory, 'FillMemory', cdRegister);
 S.RegisterDelphiFunction(@StartWait, 'StartWait', cdRegister);
 S.RegisterDelphiFunction(@StopWait, 'StopWait', cdRegister);
 S.RegisterDelphiFunction(@DefineCursor, 'DefineCursor', cdRegister);
 S.RegisterDelphiFunction(@LoadAniCursor, 'LoadAniCursor', cdRegister);
 S.RegisterDelphiFunction(@StretchBltTransparent, 'StretchBltTransparent', cdRegister);
 S.RegisterDelphiFunction(@DrawTransparentBitmap, 'DrawTransparentBitmap', cdRegister);
 S.RegisterDelphiFunction(@PaletteEntries, 'PaletteEntries', cdRegister);
 S.RegisterDelphiFunction(@WindowClassName, 'WindowClassName', cdRegister);
 S.RegisterDelphiFunction(@ScreenWorkArea, 'ScreenWorkArea', cdRegister);
 S.RegisterDelphiFunction(@MoveWindowOrg, 'MoveWindowOrg', cdRegister);
 S.RegisterDelphiFunction(@SwitchToWindow, 'SwitchToWindow', cdRegister);
 S.RegisterDelphiFunction(@ActivateWindow, 'ActivateWindow', cdRegister);
 S.RegisterDelphiFunction(@ShowWinNoAnimate, 'ShowWinNoAnimate', cdRegister);
 S.RegisterDelphiFunction(@CenterWindow, 'CenterWindow', cdRegister);
 S.RegisterDelphiFunction(@ShadeRect, 'ShadeRect', cdRegister);
 S.RegisterDelphiFunction(@KillMessage, 'KillMessage', cdRegister);
 S.RegisterDelphiFunction(@DialogUnitsToPixelsX, 'DialogUnitsToPixelsX', cdRegister);
 S.RegisterDelphiFunction(@DialogUnitsToPixelsY, 'DialogUnitsToPixelsY', cdRegister);
 S.RegisterDelphiFunction(@PixelsToDialogUnitsX, 'PixelsToDialogUnitsX', cdRegister);
 S.RegisterDelphiFunction(@PixelsToDialogUnitsY, 'PixelsToDialogUnitsY', cdRegister);
 S.RegisterDelphiFunction(@WriteText, 'WriteText', cdRegister);
 S.RegisterDelphiFunction(@DrawCellText, 'DrawCellText', cdRegister);
 S.RegisterDelphiFunction(@DrawCellTextEx, 'DrawCellTextEx', cdRegister);
 //S.RegisterDelphiFunction(@DrawCellText1, 'DrawCellText1', cdRegister);
 //S.RegisterDelphiFunction(@DrawCellTextEx2, 'DrawCellTextEx2', cdRegister);
 S.RegisterDelphiFunction(@DrawCellBitmap, 'DrawCellBitmap', cdRegister);
{  RIRegister_TJvScreenCanvas(CL);
  RIRegister_TBits(CL);
  RIRegister_TMetafileCanvas(CL);
  RIRegister_TResourceStream(CL);}
 S.RegisterDelphiFunction(@GetCurrentDir, 'GetCurrentDir', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentDir, 'SetCurrentDir', cdRegister);
 S.RegisterDelphiFunction(@CheckWin32, 'CheckWin32', cdRegister);
 S.RegisterDelphiFunction(@Win32Check, 'Win32Check', cdRegister);
 S.RegisterDelphiFunction(@RaiseWin32Error, 'RaiseWin32Error', cdRegister);
 S.RegisterDelphiFunction(@ResStr, 'ResStr', cdRegister);
 //S.RegisterDelphiFunction(@ResStr, 'ResStr', cdRegister);
  S.RegisterDelphiFunction(@DualInputQuery, 'DualInputQuery', cdRegister);
  S.RegisterDelphiFunction(@MsgAbout, 'MsgAbout', cdRegister);
  S.RegisterDelphiFunction(@LoadIcoToImage, 'LoadIcoToImage', cdRegister);
  // from jvjvclutils
 S.RegisterDelphiFunction(@CanvasMaxTextHeight, 'CanvasMaxTextHeight', cdRegister);
 S.RegisterDelphiFunction(@ReplaceComponentReference, 'ReplaceComponentReference', cdRegister);
 S.RegisterDelphiFunction(@DrawLine, 'DrawLine', cdRegister);
 S.RegisterDelphiFunction(@IsPositiveResult, 'IsPositiveResult', cdRegister);
 S.RegisterDelphiFunction(@IsNegativeResult, 'IsNegativeResult', cdRegister);
 S.RegisterDelphiFunction(@IsAbortResult, 'IsAbortResult', cdRegister);
 S.RegisterDelphiFunction(@StripAllFromResult, 'StripAllFromResult', cdRegister);
 S.RegisterDelphiFunction(@SelectColorByLuminance, 'SelectColorByLuminance', cdRegister);
 S.RegisterDelphiFunction(@HTMLDrawTextEx, 'HTMLDrawTextEx', cdRegister);
 S.RegisterDelphiFunction(@HTMLDrawTextEx, 'HTMLDrawTextEx1', cdRegister);
 S.RegisterDelphiFunction(@HTMLDrawText, 'HTMLDrawText', cdRegister);
 S.RegisterDelphiFunction(@HTMLDrawTextHL, 'HTMLDrawTextHL', cdRegister);
 S.RegisterDelphiFunction(@HTMLPlainText, 'HTMLPlainText', cdRegister);
 S.RegisterDelphiFunction(@HTMLTextExtent, 'HTMLTextExtent', cdRegister);
 S.RegisterDelphiFunction(@HTMLTextExtent, 'HTMLTextExtent2', cdRegister);
 S.RegisterDelphiFunction(@HTMLTextWidth, 'HTMLTextWidth', cdRegister);
 S.RegisterDelphiFunction(@HTMLTextHeight, 'HTMLTextHeight', cdRegister);
 S.RegisterDelphiFunction(@HTMLPrepareText, 'HTMLPrepareText', cdRegister);

end;


procedure RIRegister_JvVCLUtils(CL: TPSRuntimeClassImporter);
begin
//  RIRegister_JvVCLUtils(ri);
  RIRegister_TJvScreenCanvas(CL);
  RIRegister_TBits(CL);
  RIRegister_TMetafileCanvas(CL);
  RIRegister_TResourceStream(CL);
end;



{ TPSImport_JvVCLUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvVCLUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvVCLUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvVCLUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvVCLUtils(ri);
  RIRegister_JvVCLUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
