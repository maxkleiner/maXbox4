unit uPSI_GR32_Image;
{
  fight 2
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
  TPSImport_GR32_Image = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBitmap32List(CL: TPSPascalCompiler);
procedure SIRegister_TBitmap32Collection(CL: TPSPascalCompiler);
procedure SIRegister_TBitmap32Item(CL: TPSPascalCompiler);
procedure SIRegister_TImgView32(CL: TPSPascalCompiler);
procedure SIRegister_TCustomImgView32(CL: TPSPascalCompiler);
procedure SIRegister_TIVScrollProperties(CL: TPSPascalCompiler);
procedure SIRegister_TImage32(CL: TPSPascalCompiler);
procedure SIRegister_TCustomImage32(CL: TPSPascalCompiler);
procedure SIRegister_TPaintBox32(CL: TPSPascalCompiler);
procedure SIRegister_TCustomPaintBox32(CL: TPSPascalCompiler);
procedure SIRegister_TPaintStages(CL: TPSPascalCompiler);
procedure SIRegister_GR32_Image(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBitmap32List(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBitmap32Collection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBitmap32Item(CL: TPSRuntimeClassImporter);
procedure RIRegister_TImgView32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomImgView32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIVScrollProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TImage32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomImage32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPaintBox32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomPaintBox32(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPaintStages(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_Image(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // LCLIntf
 // ,LCLType
  //,LMessages
  Types
  ,Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,GR32
  ,GR32_Layers
  //,GR32_RangeBars
  //,GR32_LowLevel
  ,GR32_System
  //,GR32_Containers
  //,GR32_RepaintOpt
  ,GR32_Image
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_Image]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitmap32List(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TBitmap32List') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TBitmap32List') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Bitmap', 'TBitmap32 Integer', iptrw);
    SetDefaultPropery('Bitmap');
    RegisterProperty('Bitmaps', 'TBitmap32Collection', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitmap32Collection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TBitmap32Collection') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TBitmap32Collection') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent; ItemClass : TBitmap32ItemClass)');
    RegisterMethod('Function Add : TBitmap32Item');
    RegisterProperty('Items', 'TBitmap32Item Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBitmap32Item(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TBitmap32Item') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TBitmap32Item') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterProperty('Bitmap', 'TBitmap32', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TImgView32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomImgView32', 'TImgView32') do
  with CL.AddClassN(CL.FindClass('TCustomImgView32'),'TImgView32') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomImgView32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomImage32', 'TCustomImgView32') do
  with CL.AddClassN(CL.FindClass('TCustomImage32'),'TCustomImgView32') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ScrollToCenter( X, Y : Integer)');
    RegisterMethod('Procedure Scroll( Dx, Dy : Integer)');
    RegisterProperty('Centered', 'Boolean', iptrw);
    RegisterProperty('ScrollBars', 'TIVScrollProperties', iptrw);
    RegisterProperty('SizeGrip', 'TSizeGripStyle', iptrw);
    RegisterProperty('OverSize', 'Integer', iptrw);
    RegisterProperty('OnScroll', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIVScrollProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TArrowBarAccess', 'TIVScrollProperties') do
  with CL.AddClassN(CL.FindClass('TArrowBarAccess'),'TIVScrollProperties') do begin
    RegisterProperty('Increment', 'Integer', iptrw);
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('Visibility', 'TScrollBarVisibility', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TImage32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomImage32', 'TImage32') do
  with CL.AddClassN(CL.FindClass('TCustomImage32'),'TImage32') do begin
     RegisterMethod('Constructor Create( AOwner : TComponent)');
     registerPublishedProperties;
    {property Align;
    property Anchors;
    property AutoSize;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Options;
    property ParentShowHint;
    property PopupMenu;
    property RepaintMode;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;}
    RegisterProperty('ALIGN', 'TAlignment', iptr);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('CANVAS', 'TCANVAS', iptr);
    RegisterProperty('AUTOSIZE', 'BOOLEAN', iptrw);
    RegisterProperty('CENTER', 'BOOLEAN', iptrw);
    RegisterProperty('PICTURE', 'TPICTURE', iptrw);
    RegisterProperty('STRETCH', 'BOOLEAN', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomImage32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPaintBox32', 'TCustomImage32') do
  with CL.AddClassN(CL.FindClass('TCustomPaintBox32'),'TCustomImage32') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Function BitmapToControl( const APoint : TPoint) : TPoint;');
    RegisterMethod('Function BitmapToControl1( const APoint : TFloatPoint) : TFloatPoint;');
    RegisterMethod('Procedure Changed');
    RegisterMethod('Procedure Update( const Rect : TRect);');
    RegisterMethod('Function ControlToBitmap( const APoint : TPoint) : TPoint;');
    RegisterMethod('Function ControlToBitmap1( const APoint : TFloatPoint) : TFloatPoint;');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Procedure ExecBitmapFrame( Dest : TBitmap32; StageNum : Integer)');
    RegisterMethod('Procedure ExecClearBuffer( Dest : TBitmap32; StageNum : Integer)');
    RegisterMethod('Procedure ExecClearBackgnd( Dest : TBitmap32; StageNum : Integer)');
    RegisterMethod('Procedure ExecControlFrame( Dest : TBitmap32; StageNum : Integer)');
    RegisterMethod('Procedure ExecCustom( Dest : TBitmap32; StageNum : Integer)');
    RegisterMethod('Procedure ExecDrawBitmap( Dest : TBitmap32; StageNum : Integer)');
    RegisterMethod('Procedure ExecDrawLayers( Dest : TBitmap32; StageNum : Integer)');
    RegisterMethod('Function GetBitmapRect : TRect');
    RegisterMethod('Function GetBitmapSize : TSize');
    RegisterMethod('Procedure PaintTo( Dest : TBitmap32; DestRect : TRect)');
    RegisterMethod('Procedure SetupBitmap( DoClear : Boolean; ClearColor : TColor32)');
    RegisterProperty('Bitmap', 'TBitmap32', iptrw);
    RegisterProperty('BitmapAlign', 'TBitmapAlign', iptrw);
    RegisterProperty('Layers', 'TLayerCollection', iptrw);
    RegisterProperty('OffsetHorz', 'TFloat', iptrw);
    RegisterProperty('OffsetVert', 'TFloat', iptrw);
    RegisterProperty('PaintStages', 'TPaintStages', iptr);
    RegisterProperty('Scale', 'TFloat', iptrw);
    RegisterProperty('ScaleX', 'TFloat', iptrw);
    RegisterProperty('ScaleY', 'TFloat', iptrw);
    RegisterProperty('ScaleMode', 'TScaleMode', iptrw);
    RegisterProperty('OnBitmapResize', 'TNotifyEvent', iptrw);
    RegisterProperty('OnBitmapPixelCombine', 'TPixelCombineEvent', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnInitStages', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseDown', 'TImgMouseEvent', iptrw);
    RegisterProperty('OnMouseMove', 'TImgMouseMoveEvent', iptrw);
    RegisterProperty('OnMouseUp', 'TImgMouseEvent', iptrw);
    RegisterProperty('OnPaintStage', 'TPaintStageEvent', iptrw);
    RegisterProperty('OnScaleChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPaintBox32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomPaintBox32', 'TPaintBox32') do
  with CL.AddClassN(CL.FindClass('TCustomPaintBox32'),'TPaintBox32') do begin
    //RegisterMethod('Constructor Create( AOwner : TComponent)');
    //RegisterMethod('Procedure Free');
    RegisterProperty('OnPaintBuffer', 'TNotifyEvent', iptrw);
    registerPublishedProperties;
    //RegisterProperty('Buffer', 'TBitmap32', iptr);
    RegisterProperty('CANVAS', 'TCanvas', iptr);
    //RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('Visible', 'boolean', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONPAINT', 'TNOTIFYEVENT', iptrw);
    //RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    //RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);


  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomPaintBox32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomControl', 'TCustomPaintBox32') do
  with CL.AddClassN(CL.FindClass('TCustomControl'),'TCustomPaintBox32') do begin
    RegisterPublishedProperties;
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetViewportRect : TRect');
    RegisterMethod('Procedure Flush;');
    RegisterMethod('Procedure Flush1( const SrcRect : TRect);');
    RegisterMethod('Procedure ForceFullInvalidate');
    RegisterMethod('Procedure Loaded');
    RegisterMethod('Procedure Resize');
    RegisterMethod('Procedure SetBounds( ALeft, ATop, AWidth, AHeight : Integer)');
    RegisterMethod('Procedure AssignTo( Dest : TPersistent)');
    RegisterProperty('Buffer', 'TBitmap32', iptr);
    RegisterProperty('BufferOversize', 'Integer', iptrw);
    RegisterProperty('Options', 'TPaintBoxOptions', iptrw);
    RegisterProperty('MouseInControl', 'Boolean', iptr);
    RegisterProperty('RepaintMode', 'TRepaintMode', iptrw);
    RegisterProperty('OnMouseEnter', 'TNotifyEvent', iptrw);
    RegisterProperty('OnMouseLeave', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGDIOverlay', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPaintStages(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPaintStages') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPaintStages') do begin
    RegisterMethod('Function Add : PPaintStage');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Count : Integer');
    RegisterMethod('Procedure Delete( Index : Integer)');
   // RegisterMethod('Function Insert( Index : Integer) : PPaintStage');
    //RegisterProperty('Items', 'PPaintStage Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_Image(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('PST_CUSTOM','LongInt').SetInt( 1);
 CL.AddConstantN('PST_CLEAR_BUFFER','LongInt').SetInt( 2);
 CL.AddConstantN('PST_CLEAR_BACKGND','LongInt').SetInt( 3);
 CL.AddConstantN('PST_DRAW_BITMAP','LongInt').SetInt( 4);
 CL.AddConstantN('PST_DRAW_LAYERS','LongInt').SetInt( 5);
 CL.AddConstantN('PST_CONTROL_FRAME','LongInt').SetInt( 6);
 CL.AddConstantN('PST_BITMAP_FRAME','LongInt').SetInt( 7);
  CL.AddTypeS('TPaintStageEvent', 'Procedure ( Sender : TObject; Buffer : TBitmap32; StageNum : Cardinal)');
  //CL.AddTypeS('PPaintStage', '^TPaintStage // will not work');
  CL.AddTypeS('TPaintStage', 'record DsgnTime: Boolean; RunTime: Boolean; Stage: Cardinal; Parameter : Cardinal; end');
  //SIRegister_TPaintStages(CL);
  CL.AddTypeS('TBitmapAlign', '( baTopLeft, baCenter, baTile, baCustom )');
  CL.AddTypeS('TScaleMode', '( smNormal, smStretch, smScale, smResize, smOptimal, smOptimalScaled )');
  CL.AddTypeS('TPaintBoxOptions', '( pboWantArrowKeys, pboAutoFocus )');   //set of
  CL.AddTypeS('TRepaintMode', '( rmFull, rmDirect, rmOptimizer )');
  SIRegister_TCustomPaintBox32(CL);
  SIRegister_TPaintBox32(CL);
 { CL.AddTypeS('TImgMouseEvent', 'Procedure ( Sender : TObject; Button : TMouseB'
   +'utton; Shift : TShiftState; X, Y : Integer; Layer : TCustomLayer)');
  CL.AddTypeS('TImgMouseMoveEvent', 'Procedure ( Sender : TObject; Shift : TShi'
   +'ftState; X, Y : Integer; Layer : TCustomLayer)');    }
  CL.AddTypeS('TPaintStageHandler', 'Procedure ( Dest : TBitmap32; StageNum : Integer)');
  SIRegister_TCustomImage32(CL);
  SIRegister_TImage32(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomImgView32');
  CL.AddTypeS('TScrollBarVisibility', '( svAlways, svHidden, svAuto )');
  SIRegister_TIVScrollProperties(CL);
  CL.AddTypeS('TSizeGripStyle', '( sgAuto, sgNone, sgAlways )');
  SIRegister_TCustomImgView32(CL);
  SIRegister_TImgView32(CL);
  SIRegister_TBitmap32Item(CL);
  //CL.AddTypeS('TBitmap32ItemClass', 'class of TBitmap32Item');
  SIRegister_TBitmap32Collection(CL);
  SIRegister_TBitmap32List(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBitmap32ListBitmaps_W(Self: TBitmap32List; const T: TBitmap32Collection);
begin Self.Bitmaps := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32ListBitmaps_R(Self: TBitmap32List; var T: TBitmap32Collection);
begin T := Self.Bitmaps; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32ListBitmap_W(Self: TBitmap32List; const T: TBitmap32; const t1: Integer);
begin Self.Bitmap[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32ListBitmap_R(Self: TBitmap32List; var T: TBitmap32; const t1: Integer);
begin T := Self.Bitmap[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32CollectionItems_W(Self: TBitmap32Collection; const T: TBitmap32Item; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32CollectionItems_R(Self: TBitmap32Collection; var T: TBitmap32Item; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32ItemBitmap_W(Self: TBitmap32Item; const T: TBitmap32);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TBitmap32ItemBitmap_R(Self: TBitmap32Item; var T: TBitmap32);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32OnScroll_W(Self: TCustomImgView32; const T: TNotifyEvent);
begin Self.OnScroll := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32OnScroll_R(Self: TCustomImgView32; var T: TNotifyEvent);
begin T := Self.OnScroll; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32OverSize_W(Self: TCustomImgView32; const T: Integer);
begin Self.OverSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32OverSize_R(Self: TCustomImgView32; var T: Integer);
begin T := Self.OverSize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32SizeGrip_W(Self: TCustomImgView32; const T: TSizeGripStyle);
begin Self.SizeGrip := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32SizeGrip_R(Self: TCustomImgView32; var T: TSizeGripStyle);
begin T := Self.SizeGrip; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32ScrollBars_W(Self: TCustomImgView32; const T: TIVScrollProperties);
begin Self.ScrollBars := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32ScrollBars_R(Self: TCustomImgView32; var T: TIVScrollProperties);
begin T := Self.ScrollBars; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32Centered_W(Self: TCustomImgView32; const T: Boolean);
begin Self.Centered := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImgView32Centered_R(Self: TCustomImgView32; var T: Boolean);
begin T := Self.Centered; end;

(*----------------------------------------------------------------------------*)
procedure TIVScrollPropertiesVisibility_W(Self: TIVScrollProperties; const T: TScrollBarVisibility);
begin Self.Visibility := T; end;

(*----------------------------------------------------------------------------*)
procedure TIVScrollPropertiesVisibility_R(Self: TIVScrollProperties; var T: TScrollBarVisibility);
begin T := Self.Visibility; end;

(*----------------------------------------------------------------------------*)
procedure TIVScrollPropertiesSize_W(Self: TIVScrollProperties; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TIVScrollPropertiesSize_R(Self: TIVScrollProperties; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TIVScrollPropertiesIncrement_W(Self: TIVScrollProperties; const T: Integer);
begin Self.Increment := T; end;

(*----------------------------------------------------------------------------*)
procedure TIVScrollPropertiesIncrement_R(Self: TIVScrollProperties; var T: Integer);
begin T := Self.Increment; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnScaleChange_W(Self: TCustomImage32; const T: TNotifyEvent);
begin Self.OnScaleChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnScaleChange_R(Self: TCustomImage32; var T: TNotifyEvent);
begin T := Self.OnScaleChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnPaintStage_W(Self: TCustomImage32; const T: TPaintStageEvent);
begin Self.OnPaintStage := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnPaintStage_R(Self: TCustomImage32; var T: TPaintStageEvent);
begin T := Self.OnPaintStage; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnMouseUp_W(Self: TCustomImage32; const T: TImgMouseEvent);
begin Self.OnMouseUp := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnMouseUp_R(Self: TCustomImage32; var T: TImgMouseEvent);
begin T := Self.OnMouseUp; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnMouseMove_W(Self: TCustomImage32; const T: TImgMouseMoveEvent);
begin Self.OnMouseMove := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnMouseMove_R(Self: TCustomImage32; var T: TImgMouseMoveEvent);
begin T := Self.OnMouseMove; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnMouseDown_W(Self: TCustomImage32; const T: TImgMouseEvent);
begin Self.OnMouseDown := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnMouseDown_R(Self: TCustomImage32; var T: TImgMouseEvent);
begin T := Self.OnMouseDown; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnInitStages_W(Self: TCustomImage32; const T: TNotifyEvent);
begin Self.OnInitStages := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnInitStages_R(Self: TCustomImage32; var T: TNotifyEvent);
begin T := Self.OnInitStages; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnChange_W(Self: TCustomImage32; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnChange_R(Self: TCustomImage32; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnBitmapPixelCombine_W(Self: TCustomImage32; const T: TPixelCombineEvent);
begin Self.OnBitmapPixelCombine := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnBitmapPixelCombine_R(Self: TCustomImage32; var T: TPixelCombineEvent);
begin T := Self.OnBitmapPixelCombine; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnBitmapResize_W(Self: TCustomImage32; const T: TNotifyEvent);
begin Self.OnBitmapResize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OnBitmapResize_R(Self: TCustomImage32; var T: TNotifyEvent);
begin T := Self.OnBitmapResize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32ScaleMode_W(Self: TCustomImage32; const T: TScaleMode);
begin Self.ScaleMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32ScaleMode_R(Self: TCustomImage32; var T: TScaleMode);
begin T := Self.ScaleMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32ScaleY_W(Self: TCustomImage32; const T: TFloat);
begin Self.ScaleY := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32ScaleY_R(Self: TCustomImage32; var T: TFloat);
begin T := Self.ScaleY; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32ScaleX_W(Self: TCustomImage32; const T: TFloat);
begin Self.ScaleX := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32ScaleX_R(Self: TCustomImage32; var T: TFloat);
begin T := Self.ScaleX; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32Scale_W(Self: TCustomImage32; const T: TFloat);
begin Self.Scale := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32Scale_R(Self: TCustomImage32; var T: TFloat);
begin T := Self.Scale; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32PaintStages_R(Self: TCustomImage32; var T: TPaintStages);
begin T := Self.PaintStages; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OffsetVert_W(Self: TCustomImage32; const T: TFloat);
begin Self.OffsetVert := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OffsetVert_R(Self: TCustomImage32; var T: TFloat);
begin T := Self.OffsetVert; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OffsetHorz_W(Self: TCustomImage32; const T: TFloat);
begin Self.OffsetHorz := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32OffsetHorz_R(Self: TCustomImage32; var T: TFloat);
begin T := Self.OffsetHorz; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32Layers_W(Self: TCustomImage32; const T: TLayerCollection);
begin Self.Layers := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32Layers_R(Self: TCustomImage32; var T: TLayerCollection);
begin T := Self.Layers; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32BitmapAlign_W(Self: TCustomImage32; const T: TBitmapAlign);
begin Self.BitmapAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32BitmapAlign_R(Self: TCustomImage32; var T: TBitmapAlign);
begin T := Self.BitmapAlign; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32Bitmap_W(Self: TCustomImage32; const T: TBitmap32);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomImage32Bitmap_R(Self: TCustomImage32; var T: TBitmap32);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
Function TCustomImage32ControlToBitmap1_P(Self: TCustomImage32;  const APoint : TFloatPoint) : TFloatPoint;
Begin Result := Self.ControlToBitmap(APoint); END;

(*----------------------------------------------------------------------------*)
Function TCustomImage32ControlToBitmap_P(Self: TCustomImage32;  const APoint : TPoint) : TPoint;
Begin Result := Self.ControlToBitmap(APoint); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomImage32Update_P(Self: TCustomImage32;  const Rect : TRect);
Begin Self.Update(Rect); END;

(*----------------------------------------------------------------------------*)
Function TCustomImage32BitmapToControl1_P(Self: TCustomImage32;  const APoint : TFloatPoint) : TFloatPoint;
Begin Result := Self.BitmapToControl(APoint); END;

(*----------------------------------------------------------------------------*)
Function TCustomImage32BitmapToControl_P(Self: TCustomImage32;  const APoint : TPoint) : TPoint;
Begin Result := Self.BitmapToControl(APoint); END;

(*----------------------------------------------------------------------------*)
//Procedure TCustomImage32MouseUp1_P(Self: TCustomImage32;  Button : TMouseButton; Shift : TShiftState; X, Y : Integer; Layer : TCustomLayer);
//Begin Self.MouseUp(Button, Shift, X, Y, Layer); END;

(*----------------------------------------------------------------------------*)
//Procedure TCustomImage32MouseMove1_P(Self: TCustomImage32;  Shift : TShiftState; X, Y : Integer; Layer : TCustomLayer);
//Begin Self.MouseMove(Shift, X, Y, Layer); END;

(*----------------------------------------------------------------------------*)
//Procedure TCustomImage32MouseDown1_P(Self: TCustomImage32;  Button : TMouseButton; Shift : TShiftState; X, Y : Integer; Layer : TCustomLayer);
//Begin Self.MouseDown(Button, Shift, X, Y, Layer); END;

(*----------------------------------------------------------------------------*)
//Procedure TCustomImage32MouseUp_P(Self: TCustomImage32;  Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
//Begin Self.MouseUp(Button, Shift, X, Y); END;

(*----------------------------------------------------------------------------*)
//Procedure TCustomImage32MouseMove_P(Self: TCustomImage32;  Shift : TShiftState; X, Y : Integer);
//Begin Self.MouseMove(Shift, X, Y); END;

(*----------------------------------------------------------------------------*)
//Procedure TCustomImage32MouseDown_P(Self: TCustomImage32;  Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
//Begin Self.MouseDown(Button, Shift, X, Y); END;

(*----------------------------------------------------------------------------*)
procedure TPaintBox32OnPaintBuffer_W(Self: TPaintBox32; const T: TNotifyEvent);
begin Self.OnPaintBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TPaintBox32OnPaintBuffer_R(Self: TPaintBox32; var T: TNotifyEvent);
begin T := Self.OnPaintBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TPaintBox32Color_W(Self: TPaintBox32; const T: TColor);
begin //Self.Color:= T;
 end;

(*----------------------------------------------------------------------------*)
procedure TPaintBox32Color_R(Self: TPaintBox32; var T: TColor);
begin //T := Self.Color;
end;


(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32OnGDIOverlay_W(Self: TCustomPaintBox32; const T: TNotifyEvent);
begin Self.OnGDIOverlay := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32OnGDIOverlay_R(Self: TCustomPaintBox32; var T: TNotifyEvent);
begin T := Self.OnGDIOverlay; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32OnMouseLeave_W(Self: TCustomPaintBox32; const T: TNotifyEvent);
begin Self.OnMouseLeave := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32OnMouseLeave_R(Self: TCustomPaintBox32; var T: TNotifyEvent);
begin T := Self.OnMouseLeave; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32OnMouseEnter_W(Self: TCustomPaintBox32; const T: TNotifyEvent);
begin Self.OnMouseEnter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32OnMouseEnter_R(Self: TCustomPaintBox32; var T: TNotifyEvent);
begin T := Self.OnMouseEnter; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32RepaintMode_W(Self: TCustomPaintBox32; const T: TRepaintMode);
begin Self.RepaintMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32RepaintMode_R(Self: TCustomPaintBox32; var T: TRepaintMode);
begin T := Self.RepaintMode; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32MouseInControl_R(Self: TCustomPaintBox32; var T: Boolean);
begin T := Self.MouseInControl; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32Options_W(Self: TCustomPaintBox32; const T: TPaintBoxOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32Options_R(Self: TCustomPaintBox32; var T: TPaintBoxOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32BufferOversize_W(Self: TCustomPaintBox32; const T: Integer);
begin Self.BufferOversize := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32BufferOversize_R(Self: TCustomPaintBox32; var T: Integer);
begin T := Self.BufferOversize; end;

(*----------------------------------------------------------------------------*)
procedure TCustomPaintBox32Buffer_R(Self: TCustomPaintBox32; var T: TBitmap32);
begin T := Self.Buffer; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomPaintBox32Flush1_P(Self: TCustomPaintBox32;  const SrcRect : TRect);
Begin Self.Flush(SrcRect); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomPaintBox32Flush_P(Self: TCustomPaintBox32);
Begin Self.Flush; END;

(*----------------------------------------------------------------------------*)
procedure TPaintStagesItems_R(Self: TPaintStages; var T: PPaintStage; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBitmap32List(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitmap32List) do begin
    RegisterConstructor(@TBitmap32List.Create, 'Create');
    RegisterPropertyHelper(@TBitmap32ListBitmap_R,@TBitmap32ListBitmap_W,'Bitmap');
    RegisterPropertyHelper(@TBitmap32ListBitmaps_R,@TBitmap32ListBitmaps_W,'Bitmaps');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBitmap32Collection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitmap32Collection) do begin
    RegisterConstructor(@TBitmap32Collection.Create, 'Create');
    RegisterMethod(@TBitmap32Collection.Add, 'Add');
    RegisterPropertyHelper(@TBitmap32CollectionItems_R,@TBitmap32CollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBitmap32Item(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBitmap32Item) do begin
    RegisterConstructor(@TBitmap32Item.Create, 'Create');
    RegisterPropertyHelper(@TBitmap32ItemBitmap_R,@TBitmap32ItemBitmap_W,'Bitmap');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TImgView32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TImgView32) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomImgView32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomImgView32) do begin
    RegisterConstructor(@TCustomImgView32.Create, 'Create');
    RegisterMethod(@TCustomImgView32.ScrollToCenter, 'ScrollToCenter');
    RegisterMethod(@TCustomImgView32.Scroll, 'Scroll');
    RegisterPropertyHelper(@TCustomImgView32Centered_R,@TCustomImgView32Centered_W,'Centered');
    RegisterPropertyHelper(@TCustomImgView32ScrollBars_R,@TCustomImgView32ScrollBars_W,'ScrollBars');
    RegisterPropertyHelper(@TCustomImgView32SizeGrip_R,@TCustomImgView32SizeGrip_W,'SizeGrip');
    RegisterPropertyHelper(@TCustomImgView32OverSize_R,@TCustomImgView32OverSize_W,'OverSize');
    RegisterPropertyHelper(@TCustomImgView32OnScroll_R,@TCustomImgView32OnScroll_W,'OnScroll');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIVScrollProperties(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIVScrollProperties) do begin
    RegisterPropertyHelper(@TIVScrollPropertiesIncrement_R,@TIVScrollPropertiesIncrement_W,'Increment');
    RegisterPropertyHelper(@TIVScrollPropertiesSize_R,@TIVScrollPropertiesSize_W,'Size');
    RegisterPropertyHelper(@TIVScrollPropertiesVisibility_R,@TIVScrollPropertiesVisibility_W,'Visibility');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TImage32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TImage32) do begin
      //RegisterConstructor(@TImage32.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomImage32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomImage32) do begin
    RegisterConstructor(@TCustomImage32.Create, 'Create');
    RegisterVirtualMethod(@TCustomImage32.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TCustomImage32BitmapToControl_P, 'BitmapToControl');
    RegisterMethod(@TCustomImage32BitmapToControl1_P, 'BitmapToControl1');
    RegisterVirtualMethod(@TCustomImage32.Changed, 'Changed');
    RegisterVirtualMethod(@TCustomImage32Update_P, 'Update');
    RegisterMethod(@TCustomImage32ControlToBitmap_P, 'ControlToBitmap');
    RegisterMethod(@TCustomImage32ControlToBitmap1_P, 'ControlToBitmap1');
    RegisterVirtualMethod(@TCustomImage32.EndUpdate, 'EndUpdate');
    RegisterVirtualMethod(@TCustomImage32.ExecBitmapFrame, 'ExecBitmapFrame');
    RegisterVirtualMethod(@TCustomImage32.ExecClearBuffer, 'ExecClearBuffer');
    RegisterVirtualMethod(@TCustomImage32.ExecClearBackgnd, 'ExecClearBackgnd');
    RegisterVirtualMethod(@TCustomImage32.ExecControlFrame, 'ExecControlFrame');
    RegisterVirtualMethod(@TCustomImage32.ExecCustom, 'ExecCustom');
    RegisterVirtualMethod(@TCustomImage32.ExecDrawBitmap, 'ExecDrawBitmap');
    RegisterVirtualMethod(@TCustomImage32.ExecDrawLayers, 'ExecDrawLayers');
    RegisterVirtualMethod(@TCustomImage32.GetBitmapRect, 'GetBitmapRect');
    RegisterVirtualMethod(@TCustomImage32.GetBitmapSize, 'GetBitmapSize');
    RegisterVirtualMethod(@TCustomImage32.PaintTo, 'PaintTo');
    RegisterVirtualMethod(@TCustomImage32.SetupBitmap, 'SetupBitmap');
    RegisterPropertyHelper(@TCustomImage32Bitmap_R,@TCustomImage32Bitmap_W,'Bitmap');
    RegisterPropertyHelper(@TCustomImage32BitmapAlign_R,@TCustomImage32BitmapAlign_W,'BitmapAlign');
    RegisterPropertyHelper(@TCustomImage32Layers_R,@TCustomImage32Layers_W,'Layers');
    RegisterPropertyHelper(@TCustomImage32OffsetHorz_R,@TCustomImage32OffsetHorz_W,'OffsetHorz');
    RegisterPropertyHelper(@TCustomImage32OffsetVert_R,@TCustomImage32OffsetVert_W,'OffsetVert');
    RegisterPropertyHelper(@TCustomImage32PaintStages_R,nil,'PaintStages');
    RegisterPropertyHelper(@TCustomImage32Scale_R,@TCustomImage32Scale_W,'Scale');
    RegisterPropertyHelper(@TCustomImage32ScaleX_R,@TCustomImage32ScaleX_W,'ScaleX');
    RegisterPropertyHelper(@TCustomImage32ScaleY_R,@TCustomImage32ScaleY_W,'ScaleY');
    RegisterPropertyHelper(@TCustomImage32ScaleMode_R,@TCustomImage32ScaleMode_W,'ScaleMode');
    RegisterPropertyHelper(@TCustomImage32OnBitmapResize_R,@TCustomImage32OnBitmapResize_W,'OnBitmapResize');
    RegisterPropertyHelper(@TCustomImage32OnBitmapPixelCombine_R,@TCustomImage32OnBitmapPixelCombine_W,'OnBitmapPixelCombine');
    RegisterPropertyHelper(@TCustomImage32OnChange_R,@TCustomImage32OnChange_W,'OnChange');
    RegisterPropertyHelper(@TCustomImage32OnInitStages_R,@TCustomImage32OnInitStages_W,'OnInitStages');
    RegisterPropertyHelper(@TCustomImage32OnMouseDown_R,@TCustomImage32OnMouseDown_W,'OnMouseDown');
    RegisterPropertyHelper(@TCustomImage32OnMouseMove_R,@TCustomImage32OnMouseMove_W,'OnMouseMove');
    RegisterPropertyHelper(@TCustomImage32OnMouseUp_R,@TCustomImage32OnMouseUp_W,'OnMouseUp');
    RegisterPropertyHelper(@TCustomImage32OnPaintStage_R,@TCustomImage32OnPaintStage_W,'OnPaintStage');
    RegisterPropertyHelper(@TCustomImage32OnScaleChange_R,@TCustomImage32OnScaleChange_W,'OnScaleChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPaintBox32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPaintBox32) do begin
    //RegisterConstructor(@TPaintBox32.Create, 'Create');
    //RegisterMethod(@TPaintBox32.Destroy, 'Free');
    RegisterPropertyHelper(@TPaintBox32OnPaintBuffer_R,@TPaintBox32OnPaintBuffer_W,'OnPaintBuffer');
    //RegisterPropertyHelper(@TCustomPaintBox32Buffer_R,nil,'Buffer');
    //RegisterPropertyHelper(@TPaintBox32Color_R,@TPaintBox32Color_W,'Color');

    //RegisterProperty('COLOR', 'TColor', iptrw);

   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomPaintBox32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomPaintBox32) do begin
    RegisterConstructor(@TCustomPaintBox32.Create, 'Create');
    RegisterMethod(@TCustomPaintBox32.Destroy, 'Free');

    RegisterVirtualMethod(@TCustomPaintBox32.GetViewportRect, 'GetViewportRect');
    RegisterMethod(@TCustomPaintBox32Flush_P, 'Flush');
    RegisterMethod(@TCustomPaintBox32Flush1_P, 'Flush1');
    RegisterVirtualMethod(@TCustomPaintBox32.ForceFullInvalidate, 'ForceFullInvalidate');
    RegisterMethod(@TCustomPaintBox32.Loaded, 'Loaded');
    RegisterMethod(@TCustomPaintBox32.Resize, 'Resize');
    RegisterMethod(@TCustomPaintBox32.SetBounds, 'SetBounds');
    RegisterMethod(@TCustomPaintBox32.AssignTo, 'AssignTo');
    RegisterPropertyHelper(@TCustomPaintBox32Buffer_R,nil,'Buffer');
    RegisterPropertyHelper(@TCustomPaintBox32BufferOversize_R,@TCustomPaintBox32BufferOversize_W,'BufferOversize');
    RegisterPropertyHelper(@TCustomPaintBox32Options_R,@TCustomPaintBox32Options_W,'Options');
    RegisterPropertyHelper(@TCustomPaintBox32MouseInControl_R,nil,'MouseInControl');
    RegisterPropertyHelper(@TCustomPaintBox32RepaintMode_R,@TCustomPaintBox32RepaintMode_W,'RepaintMode');
    RegisterPropertyHelper(@TCustomPaintBox32OnMouseEnter_R,@TCustomPaintBox32OnMouseEnter_W,'OnMouseEnter');
    RegisterPropertyHelper(@TCustomPaintBox32OnMouseLeave_R,@TCustomPaintBox32OnMouseLeave_W,'OnMouseLeave');
    RegisterPropertyHelper(@TCustomPaintBox32OnGDIOverlay_R,@TCustomPaintBox32OnGDIOverlay_W,'OnGDIOverlay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPaintStages(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPaintStages) do begin
    RegisterMethod(@TPaintStages.Add, 'Add');
    RegisterMethod(@TPaintStages.Clear, 'Clear');
    RegisterMethod(@TPaintStages.Count, 'Count');
    RegisterMethod(@TPaintStages.Delete, 'Delete');
    RegisterMethod(@TPaintStages.Insert, 'Insert');
    RegisterPropertyHelper(@TPaintStagesItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_Image(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPaintStages(CL);
  RIRegister_TCustomPaintBox32(CL);
  RIRegister_TPaintBox32(CL);
  RIRegister_TCustomImage32(CL);
  RIRegister_TImage32(CL);
  with CL.Add(TCustomImgView32) do
  RIRegister_TIVScrollProperties(CL);
  RIRegister_TCustomImgView32(CL);
  RIRegister_TImgView32(CL);
  RIRegister_TBitmap32Item(CL);
  RIRegister_TBitmap32Collection(CL);
  RIRegister_TBitmap32List(CL);
end;



{ TPSImport_GR32_Image }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Image.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_Image(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Image.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32_Image(ri);
end;
(*----------------------------------------------------------------------------*)


end.
