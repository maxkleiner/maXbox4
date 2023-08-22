unit uPSI_TeCanvas;
{
The point to TEE Chart ext  and axis   moveto - lineto   style TFontStyles!
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
  TPSImport_TeCanvas = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ICanvasToolTips(CL: TPSPascalCompiler);
procedure SIRegister_ICanvasHyperlinks(CL: TPSPascalCompiler);
procedure SIRegister_TComboFlat(CL: TPSPascalCompiler);
procedure SIRegister_TButtonColor(CL: TPSPascalCompiler);
procedure SIRegister_TTeeButton(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCanvas3D(CL: TPSPascalCompiler);
procedure SIRegister_TCanvas3D(CL: TPSPascalCompiler);
procedure SIRegister_TFloatXYZ(CL: TPSPascalCompiler);
procedure SIRegister_TTeeCanvas(CL: TPSPascalCompiler);
procedure SIRegister_TTeeFont(CL: TPSPascalCompiler);
procedure SIRegister_TTeeFontGradient(CL: TPSPascalCompiler);
procedure SIRegister_TTeeGradient(CL: TPSPascalCompiler);
procedure SIRegister_TSubGradient(CL: TPSPascalCompiler);
procedure SIRegister_TCustomTeeGradient(CL: TPSPascalCompiler);
procedure SIRegister_TTeeShadow(CL: TPSPascalCompiler);
procedure SIRegister_TTeeBlend(CL: TPSPascalCompiler);
procedure SIRegister_TView3DOptions(CL: TPSPascalCompiler);
procedure SIRegister_TChartBrush(CL: TPSPascalCompiler);
procedure SIRegister_TWhitePen(CL: TPSPascalCompiler);
procedure SIRegister_TDarkGrayPen(CL: TPSPascalCompiler);
procedure SIRegister_TDottedGrayPen(CL: TPSPascalCompiler);
procedure SIRegister_TChartHiddenPen(CL: TPSPascalCompiler);
procedure SIRegister_TChartPen(CL: TPSPascalCompiler);
procedure SIRegister_TTeePicture(CL: TPSPascalCompiler);
procedure SIRegister_TBlurFilter(CL: TPSPascalCompiler);
procedure SIRegister_TConvolveFilter(CL: TPSPascalCompiler);
procedure SIRegister_TFilterItems(CL: TPSPascalCompiler);
procedure SIRegister_TTeeFilter(CL: TPSPascalCompiler);
procedure SIRegister_IFormCreator(CL: TPSPascalCompiler);
procedure SIRegister_TFilterRegion(CL: TPSPascalCompiler);
procedure SIRegister_TeCanvas(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TComboFlat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TButtonColor(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeButton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TeCanvas_Routines(S: TPSExec);
procedure RIRegister_TTeeCanvas3D(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCanvas3D(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFloatXYZ(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeCanvas(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeFont(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeFontGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSubGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomTeeGradient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeShadow(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeBlend(CL: TPSRuntimeClassImporter);
procedure RIRegister_TView3DOptions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartBrush(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWhitePen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDarkGrayPen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDottedGrayPen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartHiddenPen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TChartPen(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeePicture(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBlurFilter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TConvolveFilter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFilterItems(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTeeFilter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TFilterRegion(CL: TPSRuntimeClassImporter);
procedure RIRegister_TeCanvas(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  {,Qt
  ,QGraphics
  ,QStdCtrls
  ,QControls
  ,QComCtrls }
  ,Types
  ,Controls
  ,StdCtrls
  ,Graphics
  ,Buttons
  //,LMessages
  ,TypInfo
  //,TeeUnicode
  ,TeCanvas
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TeCanvas]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ICanvasToolTips(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ICanvasToolTips') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ICanvasToolTips, 'ICanvasToolTips') do
  begin
    RegisterMethod('Procedure AddToolTip( const Entity, ToolTip : String)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ICanvasHyperlinks(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'ICanvasHyperlinks') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),ICanvasHyperlinks, 'ICanvasHyperlinks') do
  begin
    RegisterMethod('Procedure AddLink( x, y : Integer; const Text, URL, Hint : String)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComboFlat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComboBox', 'TComboFlat') do
  with CL.AddClassN(CL.FindClass('TComboBox'),'TComboFlat') do begin
    RegisterMethod('Procedure Add( const Item : String)');
    RegisterMethod('Procedure AddItem( Item : String; AObject : TObject)');
    RegisterMethod('Procedure AddItem( Item : String; AObject : TObject)');
    RegisterMethod('Function CurrentItem : String');
    RegisterMethod('Function SelectedObject : TObject');
    RegisterProperty('DropDownWidth', 'Integer', iptrw);
    RegisterPublishedProperties;
     RegisterProperty('Height', 'Integer', iptrw);
     RegisterProperty('ItemHeight', 'Integer', iptrw);
     RegisterProperty('ItemIndex', 'Integer', iptrw);
     RegisterProperty('Style', 'TComboboxstyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TButtonColor(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeButton', 'TButtonColor') do
  with CL.AddClassN(CL.FindClass('TTeeButton'),'TButtonColor') do
  begin
    RegisterProperty('GetColorProc', 'TButtonGetColorProc', iptrw);
    RegisterProperty('SymbolColor', 'TColor', iptrw);
    RegisterMethod('Procedure Click');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeButton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TButton', 'TTeeButton') do
  with CL.AddClassN(CL.FindClass('TButton'),'TTeeButton') do begin
    RegisterMethod('Procedure LinkProperty( AInstance : TObject; const PropName : String)');
    RegisterPublishedProperties;
     RegisterProperty('Height', 'Integer', iptrw);
     RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCanvas3D(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCanvas3D', 'TTeeCanvas3D') do
  with CL.AddClassN(CL.FindClass('TCanvas3D'),'TTeeCanvas3D') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure CalcTrigValues');
    RegisterMethod('Procedure GetCirclePoints( var P : TPointArray; X1, Y1, X2, Y2, Z : Integer)');
    RegisterProperty('Bitmap', 'TBitmap', iptrw);
    RegisterMethod('Procedure LineTo( X, Y : Integer);');
   RegisterMethod('Procedure LineTo1( const P : TPoint);');
    RegisterMethod('Procedure MoveTo( X, Y : Integer);');
    RegisterMethod('Procedure MoveTo1( const P : TPoint);');
     RegisterMethod('procedure FillRect(const Rect: TRect);');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCanvas3D(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeCanvas', 'TCanvas3D') do
  with CL.AddClassN(CL.FindClass('TTeeCanvas'),'TCanvas3D') do begin
    RegisterProperty('RotationCenter', 'TPoint3DFloat', iptrw);
    RegisterMethod('Function CalcRect3D( const R : TRect; Z : Integer) : TRect');
    RegisterMethod('Procedure Calculate2DPosition( var x, y : Integer; z : Integer);');
    RegisterMethod('Function Calculate3DPosition( const P : TPoint3D) : TPoint;');
    RegisterMethod('Function Calculate3DPosition1( P : TPoint; z : Integer) : TPoint;');
    RegisterMethod('Function Calculate3DPosition2( x, y, z : Integer) : TPoint;');
    RegisterMethod('Function Calc3DPoints( const Points : array of TPoint; z : Integer) : TPointArray');
    RegisterMethod('Procedure FourPointsFromRect( const R : TRect; Z : Integer; var P : TFourPoints)');
    RegisterMethod('Function RectFromRectZ( const R : TRect; Z : Integer) : TRect');
    RegisterMethod('Function InitWindow( DestCanvas : TCanvas; A3DOptions : TView3DOptions; ABackColor : TColor; Is3D : Boolean; const UserRect : TRect) : TRect');
    RegisterMethod('Procedure Assign( Source : TCanvas3D)');
    RegisterMethod('Procedure Projection( MaxDepth : Integer; const ABounds, Rect : TRect)');
    RegisterMethod('Procedure ShowImage( DestCanvas, DefaultCanvas : TCanvas; const UserRect : TRect)');
    RegisterMethod('Function ReDrawBitmap : Boolean');
    RegisterMethod('Procedure Arrow( Filled : Boolean; const FromPoint, ToPoint : TPoint; ArrowWidth, ArrowHeight, Z : Integer);');
    RegisterMethod('Procedure Arrow1( Filled : Boolean; const FromPoint, ToPoint : TPoint; ArrowWidth, ArrowHeight, Z : Integer; const ArrowPercent : Double);');
    RegisterMethod('Procedure ClipCube( const Rect : TRect; MinZ, MaxZ : Integer)');
    RegisterMethod('Procedure Cone( Vertical : Boolean; Left, Top, Right, Bottom, Z0, Z1 : Integer; Dark3D : Boolean; ConePercent : Integer)');
    RegisterMethod('Procedure Cube( Left, Right, Top, Bottom, Z0, Z1 : Integer; DarkSides : Boolean);');
    RegisterMethod('Procedure Cube1( const R : TRect; Z0, Z1 : Integer; DarkSides : Boolean);');
    RegisterMethod('Procedure Cylinder( Vertical : Boolean; Left, Top, Right, Bottom, Z0, Z1 : Integer; Dark3D : Boolean)');
    RegisterMethod('Procedure DisableRotation');
    RegisterMethod('Procedure EllipseWithZ( const Rect : TRect; Z : Integer);');
    RegisterMethod('Procedure EllipseWithZ1( X1, Y1, X2, Y2, Z : Integer);');
    RegisterMethod('Procedure EnableRotation');
    RegisterMethod('Procedure HorizLine3D( Left, Right, Y, Z : Integer)');
    RegisterMethod('Procedure VertLine3D( X, Top, Bottom, Z : Integer)');
    RegisterMethod('Procedure ZLine3D( X, Y, Z0, Z1 : Integer)');
    RegisterMethod('Procedure FrontPlaneBegin');
    RegisterMethod('Procedure FrontPlaneEnd');
    RegisterMethod('Procedure LineWithZ( X0, Y0, X1, Y1, Z : Integer);');
    RegisterMethod('Procedure LineWithZ1( const FromPoint, ToPoint : TPoint; Z : Integer);');
    RegisterMethod('Procedure MoveTo3D( X, Y, Z : Integer);');
    RegisterMethod('Procedure MoveTo3D1( const P : TPoint3D);');
    RegisterMethod('Procedure LineTo3D( X, Y, Z : Integer);');
    RegisterMethod('Procedure LineTo3D1( const P : TPoint3D);');
  //   RegisterMethod('Procedure LineTo( X, Y : Integer);');
  //  RegisterMethod('Procedure LineTo1( const P : TPoint);');
  //  RegisterMethod('Procedure MoveTo( X, Y : Integer);');
  //  RegisterMethod('Procedure MoveTo1( const P : TPoint);');
    RegisterMethod('Procedure Pie3D( XCenter, YCenter, XRadius, YRadius, Z0, Z1 : Integer; const StartAngle, EndAngle : Double; DarkSides, DrawSides : Boolean; DonutPercent : Integer; Gradient : TCustomTeeGradient)');
    RegisterMethod('Procedure Plane3D( const A, B : TPoint; Z0, Z1 : Integer)');
    RegisterMethod('Procedure PlaneWithZ( const P : TFourPoints; Z : Integer);');
    RegisterMethod('Procedure PlaneWithZ1( P1, P2, P3, P4 : TPoint; Z : Integer);');
    RegisterMethod('Procedure PlaneFour3D( var Points : TFourPoints; Z0, Z1 : Integer)');
    RegisterMethod('Procedure Polygon3D( const Points : array of TPoint3D)');
    RegisterMethod('Procedure PolygonWithZ( const Points : array of TPoint; Z : Integer)');
    RegisterMethod('Procedure Polyline( const Points : array of TPointTPointArray, Z : Integer);');
    RegisterMethod('Procedure Pyramid( Vertical : Boolean; Left, Top, Right, Bottom, z0, z1 : Integer; DarkSides : Boolean)');
    RegisterMethod('Procedure PyramidTrunc( const R : TRect; StartZ, EndZ : Integer; TruncX, TruncZ : Integer)');
    RegisterMethod('Procedure Rectangle( const R : TRect; Z : Integer);');
    RegisterMethod('Procedure Rectangle1( X0, Y0, X1, Y1, Z : Integer);');
    RegisterMethod('Procedure RectangleWithZ( const Rect : TRect; Z : Integer)');
    RegisterMethod('Procedure RectangleY( Left, Top, Right, Z0, Z1 : Integer)');
    RegisterMethod('Procedure RectangleZ( Left, Top, Bottom, Z0, Z1 : Integer)');
    RegisterMethod('Procedure RotatedEllipse( Left, Top, Right, Bottom, Z : Integer; const Angle : Double)');
    RegisterMethod('Procedure RotateLabel3D( x, y, z : Integer; const St : String; RotDegree : Double)');
    RegisterMethod('Procedure Sphere( x, y, z : Integer; const Radius : Double);');
    RegisterMethod('Procedure StretchDraw( const Rect : TRect; Graphic : TGraphic; Pos : Integer; Plane : TCanvas3DPlane);');
    RegisterMethod('Procedure Surface3D( Style : TTeeCanvasSurfaceStyle; SameBrush : Boolean; NumXValues, NumZValues : Integer; CalcPoints : TTeeCanvasCalcPoints)');
    RegisterMethod('Procedure TextOut3D( x, y, z : Integer; const Text : String)');
    RegisterMethod('Procedure Triangle3D( const Points : TTrianglePoints3D; const Colors : TTriangleColors3D)');
    RegisterMethod('Procedure TriangleWithZ( const P1, P2, P3 : TPoint; Z : Integer)');
    RegisterProperty('Pixels3D', 'TColor Integer Integer Integer', iptrw);
    RegisterProperty('Supports3DText', 'Boolean', iptr);
    RegisterProperty('View3DOptions', 'TView3DOptions', iptrw);
    RegisterProperty('XCenter', 'Integer', iptrw);
    RegisterProperty('YCenter', 'Integer', iptrw);
    RegisterProperty('ZCenter', 'Integer', iptrw);
    // RegisterProperty('OnMouseMove', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFloatXYZ(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TFloatXYZ') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TFloatXYZ') do begin
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('X', 'Double', iptrw);
    RegisterProperty('Y', 'Double', iptrw);
    RegisterProperty('Z', 'Double', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeCanvas(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTeeCanvas') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTeeCanvas') do begin
    RegisterProperty('FontZoom', 'Double', iptrw);
    RegisterMethod('Procedure AssignBrush( ABrush : TChartBrush);');
    RegisterMethod('Procedure AssignBrush1( ABrush : TChartBrush; ABackColor : TColor);');
    RegisterMethod('Procedure AssignBrush2( ABrush : TChartBrush; AColor, ABackColor : TColor);');
    RegisterMethod('Procedure AssignBrushColor( ABrush : TChartBrush; AColor, ABackColor : TColor)');
    RegisterMethod('Procedure AssignVisiblePen( APen : TPen)');
    RegisterMethod('Procedure AssignVisiblePenColor( APen : TPen; AColor : TColor)');
    RegisterMethod('Procedure AssignFont( AFont : TTeeFont)');
    RegisterMethod('Procedure ResetState');
    RegisterMethod('Function BeginBlending( const R : TRect; Transparency : TTeeTransparency) : TTeeBlend');
    RegisterMethod('Procedure EndBlending( Blend : TTeeBlend)');
    RegisterMethod('Procedure Arc( const Left, Top, Right, Bottom, StartX, StartY, EndX, EndY : Integer);');
    RegisterMethod('Procedure Arc1( const Left, Top, Right, Bottom : Integer; StartAngle, EndAngle : Double);');
    RegisterMethod('Procedure Arrow( Filled : Boolean; const ArrowPercent : Double; const FromPoint, ToPoint : TPoint; ArrowWidth, ArrowHeight : Integer);');
    RegisterMethod('Procedure Donut( XCenter, YCenter, XRadius, YRadius : Integer; const StartAngle, EndAngle, HolePercent : Double)');
    RegisterMethod('Procedure Draw( X, Y : Integer; Graphic : TGraphic)');
    RegisterMethod('Procedure Ellipse( const R : TRect);');
    RegisterMethod('Procedure Ellipse1( X1, Y1, X2, Y2 : Integer);');
    RegisterMethod('Procedure FillRect( const Rect : TRect)');
    RegisterMethod('Procedure Frame3D( var Rect : TRect; TopColor, BottomColor : TColor; Width : Integer)');
    RegisterMethod('Procedure LineTo( X, Y : Integer);');
    RegisterMethod('Procedure LineTo1( const P : TPoint);');
    RegisterMethod('Procedure MoveTo( X, Y : Integer);');
    RegisterMethod('Procedure MoveTo1( const P : TPoint);');
    RegisterMethod('Procedure Pie( X1, Y1, X2, Y2, X3, Y3, X4, Y4 : Integer)');
    RegisterMethod('Procedure Rectangle( const R : TRect);');
    RegisterMethod('Procedure Rectangle1( X0, Y0, X1, Y1 : Integer);');
    RegisterMethod('Procedure RoundRect( X1, Y1, X2, Y2, X3, Y3 : Integer);');
    RegisterMethod('Procedure RoundRect1( const R : TRect; X, Y : Integer);');
    RegisterMethod('Procedure StretchDraw( const Rect : TRect; Graphic : TGraphic);');
    RegisterMethod('Procedure TextOut( X, Y : Integer; const Text : WideString);');
    RegisterMethod('Procedure TextOut1( X, Y : Integer; const Text : String; AllowHtml : Boolean);');
    RegisterMethod('Procedure TextOut2( X, Y : Integer; const Text : String);');
    RegisterMethod('Function TextWidth( const St : String) : Integer;');
    RegisterMethod('Function TextHeight( const St : String) : Integer;');
    RegisterMethod('Function TextWidth1( const St : WideString) : Integer;');
    RegisterMethod('Function TextHeight1( const St : WideString) : Integer;');
    RegisterMethod('Procedure ClipRectangle( const Rect : TRect);');
    RegisterMethod('Procedure ClipRectangle1( const Rect : TRect; RoundSize : Integer);');
    RegisterMethod('Procedure ClipEllipse( const Rect : TRect; Inverted : Boolean)');
    RegisterMethod('Procedure ClipPolygon( const Points : array of TPoint; NumPoints : Integer; DiffRegion : Boolean)');
    RegisterMethod('Function ConvexHull( var Points : TPointArray) : Boolean');
    RegisterMethod('Procedure DoHorizLine( X0, X1, Y : Integer)');
    RegisterMethod('Procedure DoRectangle( const Rect : TRect)');
    RegisterMethod('Procedure DoVertLine( X, Y0, Y1 : Integer)');
    RegisterMethod('Procedure EraseBackground( const Rect : TRect)');
    RegisterMethod('Procedure GradientFill( const Rect : TRect; StartColor, EndColor : TColor; Direction : TGradientDirection; Balance : Integer)');
    RegisterMethod('Procedure Invalidate');
    RegisterMethod('Procedure Line( X0, Y0, X1, Y1 : Integer);');
    RegisterMethod('Procedure Line1( const FromPoint, ToPoint : TPoint);');
    RegisterMethod('Procedure Polyline( const Points : array of TPointTPointArray);');
    RegisterMethod('Procedure Polygon( const Points : array of TPoint)');
    RegisterMethod('Procedure PolygonGradient( const Points : array of TPoint; Gradient : TCustomTeeGradient)');
    RegisterMethod('Procedure RotateLabel( x, y : Integer; const St : String; RotDegree : Double)');
    RegisterProperty('SupportsFullRotation', 'Boolean', iptr);
    RegisterMethod('Procedure UnClipRectangle');
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('BackMode', 'TCanvasBackMode', iptrw);
    RegisterProperty('Bounds', 'TRect', iptr);
    RegisterProperty('Brush', 'TBrush', iptr);
    RegisterProperty('Font', 'TFont', iptr);
    RegisterProperty('FontHeight', 'Integer', iptr);
    RegisterProperty('Handle', 'TTeeCanvasHandle', iptr);
    RegisterProperty('Metafiling', 'Boolean', iptrw);
    RegisterProperty('Monochrome', 'Boolean', iptrw);
    RegisterProperty('Pen', 'TPen', iptr);
    RegisterProperty('Pixels', 'TColor Integer Integer', iptrw);
    RegisterProperty('ReferenceCanvas', 'TCanvas', iptrw);
    RegisterProperty('TextAlign', 'TCanvasTextAlign', iptrw);
    RegisterProperty('UseBuffer', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeFont(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFont', 'TTeeFont') do
  with CL.AddClassN(CL.FindClass('TFont'),'TTeeFont') do begin
    RegisterMethod('Constructor Create( ChangedEvent : TNotifyEvent)');
      RegisterMethod('Procedure Free;');
      RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Gradient', 'TTeeFontGradient', iptrw);
    RegisterProperty('InterCharSize', 'Integer', iptrw);
    RegisterProperty('OutLine', 'TChartHiddenPen', iptrw);
    RegisterProperty('Picture', 'TTeePicture', iptrw);
    RegisterProperty('Shadow', 'TTeeShadow', iptrw);
     RegisterPublishedProperties;
     RegisterProperty('Charset', 'Byte', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
     RegisterProperty('Height', 'Integer', iptrw);
      RegisterProperty('Name', 'string', iptrw);
     RegisterProperty('Style', 'TFontStyles', iptrw);
    //RegisterProperty('Handle', 'TTeeCanvasHandle', iptr);
    //RegisterProperty('Gradient', 'TTeeGradient', iptrw);
    //RegisterProperty('Picture', 'TBackimage', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeFontGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeGradient', 'TTeeFontGradient') do
  with CL.AddClassN(CL.FindClass('TTeeGradient'),'TTeeFontGradient') do
  begin
    RegisterProperty('Outline', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTeeGradient', 'TTeeGradient') do
  with CL.AddClassN(CL.FindClass('TCustomTeeGradient'),'TTeeGradient') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSubGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomTeeGradient', 'TSubGradient') do
  with CL.AddClassN(CL.FindClass('TCustomTeeGradient'),'TSubGradient') do
  begin
    RegisterProperty('Transparency', 'TTeeTransparency', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomTeeGradient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TCustomTeeGradient') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TCustomTeeGradient') do begin
    RegisterMethod('Constructor Create( ChangedEvent : TNotifyEvent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Draw3( Canvas : TTeeCanvas; const Rect : TRect; RoundRectSize : Integer);');
    RegisterMethod('Procedure Draw4( Canvas : TTeeCanvas; var P : TFourPoints);');
    RegisterMethod('Procedure Draw5( Canvas : TCanvas3D; var P : TFourPoints; Z : Integer);');
    RegisterMethod('Procedure Draw6( Canvas : TCanvas3D; var P : TPointArray; Z : Integer; Is3D : Boolean);');
    RegisterProperty('Changed', 'TNotifyEvent', iptrw);
    RegisterMethod('Procedure UseMiddleColor');
    RegisterProperty('Angle', 'Integer', iptrw);
    RegisterProperty('Balance', 'Integer', iptrw);
    RegisterProperty('Direction', 'TGradientDirection', iptrw);
    RegisterProperty('EndColor', 'TColor', iptrw);
    RegisterProperty('MidColor', 'TColor', iptrw);
    RegisterProperty('RadialX', 'Integer', iptrw);
    RegisterProperty('RadialY', 'Integer', iptrw);
    RegisterProperty('StartColor', 'TColor', iptrw);
    RegisterProperty('SubGradient', 'TSubGradient', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeShadow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTeeShadow') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTeeShadow') do
  begin
    RegisterMethod('Constructor Create( AOnChange : TNotifyEvent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Draw( ACanvas : TCanvas3D; const P : array of TPointTPointArray);');
    RegisterMethod('Procedure Draw1( ACanvas : TCanvas3D; const Rect : TRect);');
    RegisterMethod('Procedure Draw2( ACanvas : TCanvas3D; const Rect : TRect; Z : Integer; RoundSize : Integer);');
    RegisterMethod('Procedure DrawEllipse( ACanvas : TCanvas3D; const Rect : TRect; Z : Integer)');
    RegisterProperty('Size', 'Integer', iptrw);
    RegisterProperty('Clip', 'Boolean', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
    RegisterProperty('HorizSize', 'Integer', iptrw);
    RegisterProperty('Smooth', 'Boolean', iptrw);
    RegisterProperty('SmoothBlur', 'Integer', iptrw);
    RegisterProperty('Transparency', 'TTeeTransparency', iptrw);
    RegisterProperty('VertSize', 'Integer', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeBlend(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTeeBlend') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTeeBlend') do begin
    RegisterMethod('Constructor Create( ACanvas : TTeeCanvas; const R : TRect)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure DoBlend( Transparency : TTeeTransparency)');
    RegisterMethod('Procedure SetRectangle( const R : TRect)');
    RegisterProperty('Bitmap', 'TBitmap', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TView3DOptions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TView3DOptions') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TView3DOptions') do
  begin
    RegisterMethod('Constructor Create( AParent : TWinControl)');
    RegisterMethod('Procedure Repaint');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Parent', 'TWinControl', iptrw);
    RegisterProperty('ElevationFloat', 'Double', iptrw);
    RegisterProperty('RotationFloat', 'Double', iptrw);
    RegisterProperty('ZoomFloat', 'Double', iptrw);
    RegisterProperty('OnChangedZoom', 'TTeeView3DChangedZoom', iptrw);
    RegisterProperty('OnScrolled', 'TTeeView3DScrolled', iptrw);
    RegisterProperty('Elevation', 'Integer', iptrw);
    RegisterProperty('FontZoom', 'Integer', iptrw);
    RegisterProperty('HorizOffset', 'Integer', iptrw);
    RegisterProperty('OrthoAngle', 'Integer', iptrw);
    RegisterProperty('Orthogonal', 'Boolean', iptrw);
    RegisterProperty('Perspective', 'Integer', iptrw);
    RegisterProperty('Rotation', 'Integer', iptrw);
    RegisterProperty('Tilt', 'Integer', iptrw);
    RegisterProperty('VertOffset', 'Integer', iptrw);
    RegisterProperty('Zoom', 'Integer', iptrw);
    RegisterProperty('ZoomText', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartBrush(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBrush', 'TChartBrush') do
  with CL.AddClassN(CL.FindClass('TBrush'),'TChartBrush') do begin
    RegisterMethod('Constructor Create( OnChangeEvent : TNotifyEvent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Clear');
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('Image', 'TPicture', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('Color', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWhitePen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartPen', 'TWhitePen') do
  with CL.AddClassN(CL.FindClass('TChartPen'),'TWhitePen') do begin
    RegisterMethod('Constructor Create( OnChangeEvent : TNotifyEvent)');
     RegisterPublishedProperties;
    RegisterProperty('Color', 'TColor', iptrw);
     RegisterProperty('Visible', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDarkGrayPen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartPen', 'TDarkGrayPen') do
  with CL.AddClassN(CL.FindClass('TChartPen'),'TDarkGrayPen') do begin
    RegisterMethod('Constructor Create( OnChangeEvent : TNotifyEvent)');
     RegisterPublishedProperties;
    RegisterProperty('Color', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDottedGrayPen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartPen', 'TDottedGrayPen') do
  with CL.AddClassN(CL.FindClass('TChartPen'),'TDottedGrayPen') do
  begin
    RegisterMethod('Constructor Create( OnChangeEvent : TNotifyEvent)');
    RegisterPublishedProperties;
     RegisterProperty('Color', 'TColor', iptrw);
     RegisterProperty('Style', 'TPenStyle', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartHiddenPen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TChartPen', 'TChartHiddenPen') do
  with CL.AddClassN(CL.FindClass('TChartPen'),'TChartHiddenPen') do begin
    RegisterMethod('Constructor Create( OnChangeEvent : TNotifyEvent)');
    RegisterPublishedProperties;
    //RegisterProperty('Color', 'TColor', iptrw);
     RegisterProperty('Visible', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TChartPen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPen', 'TChartPen') do
  with CL.AddClassN(CL.FindClass('TPen'),'TChartPen') do
  begin
    RegisterMethod('Constructor Create( OnChangeEvent : TNotifyEvent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Hide');
    RegisterMethod('Procedure Show');
    RegisterProperty('EndStyle', 'TPenEndStyle', iptrw);
    RegisterProperty('SmallDots', 'Boolean', iptrw);
    RegisterProperty('SmallSpace', 'Integer', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeePicture(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPicture', 'TTeePicture') do
  with CL.AddClassN(CL.FindClass('TPicture'),'TTeePicture') do begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
      RegisterMethod('Procedure Free;');
    RegisterMethod('Function Filtered : TGraphic');
    RegisterMethod('Procedure Repaint');
    RegisterMethod('Procedure ReadFilters( Reader : TReader; Filters : TFilterItems)');
    RegisterMethod('Procedure WriteFilters( Writer : TWriter; Filters : TFilterItems)');
    RegisterProperty('Filters', 'TFilterItems', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlurFilter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TConvolveFilter', 'TBlurFilter') do
  with CL.AddClassN(CL.FindClass('TConvolveFilter'),'TBlurFilter') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Apply( Bitmap : TBitmap; const R : TRect)');
    RegisterMethod('Function Description : String');
    RegisterMethod('Procedure CreateEditor( Creator : IFormCreator; AChanged : TNotifyEvent)');
    RegisterProperty('Amount', 'Integer', iptrw);
    RegisterProperty('Steps', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TConvolveFilter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TTeeFilter', 'TConvolveFilter') do
  with CL.AddClassN(CL.FindClass('TTeeFilter'),'TConvolveFilter') do begin
   RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Apply( Bitmap : TBitmap; const R : TRect)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFilterItems(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TFilterItems') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TFilterItems') do
  begin
    RegisterMethod('Function Add( Filter : TFilterClass) : TTeeFilter');
    RegisterMethod('Procedure ApplyTo( ABitmap : TBitmap)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Item', 'TTeeFilter Integer', iptrw);
    SetDefaultPropery('Item');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTeeFilter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TTeeFilter') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TTeeFilter') do begin
    RegisterProperty('Lines', 'TRGBArray', iptrw);
    RegisterMethod('Constructor Create( Collection : TCollection)');
     RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure ApplyTo( Bitmap : TBitmap)');
    RegisterMethod('Procedure Apply( Bitmap : TBitmap);');
    RegisterMethod('Procedure Apply1( Bitmap : TBitmap; const R : TRect);');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure CreateEditor( Creator : IFormCreator; AChanged : TNotifyEvent)');
    RegisterMethod('Function Description : String');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Region', 'TFilterRegion', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IFormCreator(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IFormCreator') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IFormCreator, 'IFormCreator') do begin
    RegisterMethod('Function AddCheckBox( const PropName, ACaption : String; OnChange : TNotifyEvent) : TCheckBox', cdRegister);
    RegisterMethod('Function AddColor( const PropName, ACaption : String) : TButton', cdRegister);
    RegisterMethod('Function AddCombo( const PropName : String) : TComboBox', cdRegister);
    RegisterMethod('Function AddInteger( const PropName, ACaption : String; AMin, AMax : Integer) : TEdit', cdRegister);
    RegisterMethod('Function AddScroll( const PropName : String; AMin, AMax : Integer) : TScrollBar', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TFilterRegion(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TFilterRegion') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TFilterRegion') do begin
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Rectangle', 'TRect', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Left', 'Integer', iptrw);
    RegisterProperty('Top', 'Integer', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TeCanvas(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TeePiStep','Double').setExtended( Pi / 180.0);
 CL.AddConstantN('TeeDefaultPerspective','LongInt').SetInt( 100);
 CL.AddConstantN('TeeMinAngle','LongInt').SetInt( 270);
 CL.AddConstantN('teeclMoneyGreen','LongWord').SetUInt( TColor ( $C0DCC0 ));
 CL.AddConstantN('teeclSkyBlue','LongWord').SetUInt( TColor ( $F0CAA6 ));
 CL.AddConstantN('teeclCream','LongWord').SetUInt( TColor ( $F0FBFF ));
 CL.AddConstantN('teeclMedGray','LongWord').SetUInt( TColor ( $A4A0A0 ));
 CL.AddConstantN('teeclMoneyGreen','LongWord').SetUInt( TColor ( $C0DCC0 ));
 CL.AddConstantN('teeclSkyBlue','LongWord').SetUInt( TColor ( $F0CAA6 ));
 CL.AddConstantN('teeclCream','LongWord').SetUInt( TColor ( $F0FBFF ));
 CL.AddConstantN('teeclMedGray','LongWord').SetUInt( TColor ( $A4A0A0 ));
 CL.AddConstantN('TA_LEFT','LongInt').SetInt( 0);
 CL.AddConstantN('TA_RIGHT','LongInt').SetInt( 2);
 CL.AddConstantN('TA_CENTER','LongInt').SetInt( 6);
 CL.AddConstantN('TA_TOP','LongInt').SetInt( 0);
 CL.AddConstantN('TA_BOTTOM','LongInt').SetInt( 8);
 CL.AddConstantN('teePATCOPY','LongInt').SetInt( 0);
 CL.AddConstantN('NumCirclePoints','LongInt').SetInt( 64);
 CL.AddConstantN('teeDEFAULT_CHARSET','LongInt').SetInt( 1);
 CL.AddConstantN('teeANTIALIASED_QUALITY','LongInt').SetInt( 4);
 CL.AddConstantN('TA_LEFT','LongInt').SetInt( 0);
 CL.AddConstantN('bs_Solid','LongInt').SetInt( 0);
 CL.AddConstantN('teepf24Bit','LongInt').SetInt( 0);
 CL.AddConstantN('teepfDevice','LongInt').SetInt( 1);
 CL.AddConstantN('CM_MOUSELEAVE','LongInt').SetInt( 10000);
 CL.AddConstantN('CM_SYSCOLORCHANGE','LongInt').SetInt( 10001);
 CL.AddConstantN('DC_BRUSH','LongInt').SetInt( 18);
 CL.AddConstantN('DC_PEN','LongInt').SetInt( 19);
  CL.AddTypeS('teeCOLORREF', 'LongWord');
  CL.AddTypeS('TLogBrush', 'record lbStyle : Integer; lbColor : TColor; lbHatch: Integer; end');
  //CL.AddTypeS('TNotifyEvent', 'Procedure ( Sender : TObject)');
  SIRegister_TFilterRegion(CL);
  SIRegister_IFormCreator(CL);
  SIRegister_TTeeFilter(CL);
  //CL.AddTypeS('TFilterClass', 'class of TTeeFilter');
  SIRegister_TFilterItems(CL);
  SIRegister_TConvolveFilter(CL);
  SIRegister_TBlurFilter(CL);
  SIRegister_TTeePicture(CL);
  CL.AddTypeS('TPenEndStyle', '( esRound, esSquare, esFlat )');
  SIRegister_TChartPen(CL);
  SIRegister_TChartHiddenPen(CL);
  SIRegister_TDottedGrayPen(CL);
  SIRegister_TDarkGrayPen(CL);
  SIRegister_TWhitePen(CL);
  SIRegister_TChartBrush(CL);
  CL.AddTypeS('TTeeView3DScrolled', 'Procedure ( IsHoriz : Boolean)');
  CL.AddTypeS('TTeeView3DChangedZoom', 'Procedure ( NewZoom : Integer)');
  SIRegister_TView3DOptions(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TTeeCanvas');
  CL.AddTypeS('TTeeTransparency', 'Integer');
  SIRegister_TTeeBlend(CL);
  CL.AddClassN(CL.FindClass('TTeeCanvas'),'TCanvas3D');
  SIRegister_TTeeShadow(CL);
  CL.AddTypeS('teeTGradientDirection', '( gdTopBottom, gdBottomTop, gdLeftRight, g'
   +'dRightLeft, gdFromCenter, gdFromTopLeft, gdFromBottomLeft, gdRadial, gdDiagonalUp, gdDiagonalDown )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSubGradient');
  SIRegister_TCustomTeeGradient(CL);
  SIRegister_TSubGradient(CL);
  SIRegister_TTeeGradient(CL);
  SIRegister_TTeeFontGradient(CL);
  SIRegister_TTeeFont(CL);
  CL.AddTypeS('TCanvasBackMode', '( cbmNone, cbmTransparent, cbmOpaque )');
  CL.AddTypeS('TCanvasTextAlign', 'Integer');
  CL.AddTypeS('TTeeCanvasHandle', 'HDC');
  SIRegister_TTeeCanvas(CL);
  CL.AddTypeS('TPoint3DFloat', 'record X : Double; Y : Double; Z : Double; end');
  SIRegister_TFloatXYZ(CL);
  CL.AddTypeS('TPoint3D', 'record x : integer; y : integer; z : Integer; end');
  CL.AddTypeS('TRGB', 'record blue: byte; green: byte; red: byte; end');
  CL.AddTypeS('TRGBArray', 'Array of TRGB;');

  {TRGB=packed record
    Blue  : Byte;
    Green : Byte;
    Red   : Byte;
    //$IFDEF CLX  //Alpha : Byte; // Linux
  end;}

  CL.AddTypeS('TTeeCanvasCalcPoints', 'Function ( x, z : Integer; var P0, P1 : '
   +'TPoint3D; var Color0, Color1 : TColor) : Boolean');
  CL.AddTypeS('TTeeCanvasSurfaceStyle', '( tcsSolid, tcsWire, tcsDot )');
  CL.AddTypeS('TCanvas3DPlane', '( cpX, cpY, cpZ )');
  //CL.AddTypeS('IInterface', 'IUnknown');
   CL.AddTypeS('TTrianglePoints', 'Array[0..2] of TPoint;');
  CL.AddTypeS('TFourPoints', 'Array[0..3] of TPoint;');
  SIRegister_TCanvas3D(CL);
  SIRegister_TTeeCanvas3D(CL);
 // CL.AddTypeS('TTrianglePoints', 'Array[0..2] of TPoint;');
  //CL.AddTypeS('TFourPoints', 'Array[0..3] of TPoint;');

   // TFourPoints=Array[0..3] of TPoint;
   // TTrianglePoints  =Array[0..2] of TPoint;
   //TRGBArray=Array of PRGBs;

 CL.AddDelphiFunction('Function ApplyDark( Color : TColor; HowMuch : Byte) : TColor');
 CL.AddDelphiFunction('Function ApplyBright( Color : TColor; HowMuch : Byte) : TColor');
 CL.AddDelphiFunction('Function Point3D( const x, y, z : Integer) : TPoint3D');
 CL.AddDelphiFunction('Procedure SwapDouble( var a, b : Double)');
 CL.AddDelphiFunction('Procedure SwapInteger( var a, b : Integer)');
 CL.AddDelphiFunction('Procedure RectSize( const R : TRect; var RectWidth, RectHeight : Integer)');
 CL.AddDelphiFunction('Procedure teeRectCenter( const R : TRect; var X, Y : Integer)');
 CL.AddDelphiFunction('Function RectFromPolygon( const Points : array of TPoint; NumPoints : Integer) : TRect');
 CL.AddDelphiFunction('Function RectFromTriangle( const Points : TTrianglePoints) : TRect');
 CL.AddDelphiFunction('Function RectangleInRectangle( const Small, Big : TRect) : Boolean');
 CL.AddDelphiFunction('Procedure ClipCanvas( ACanvas : TCanvas; const Rect : TRect)');
 CL.AddDelphiFunction('Procedure UnClipCanvas( ACanvas : TCanvas)');
 CL.AddDelphiFunction('Procedure ClipEllipse( ACanvas : TTeeCanvas; const Rect : TRect)');
 CL.AddDelphiFunction('Procedure ClipRoundRectangle( ACanvas : TTeeCanvas; const Rect : TRect; RoundSize : Integer)');
 CL.AddDelphiFunction('Procedure ClipPolygon( ACanvas : TTeeCanvas; const Points : array of TPoint; NumPoints : Integer)');
 CL.AddConstantN('TeeCharForHeight','String').SetString( 'W');
 CL.AddConstantN('DarkerColorQuantity','Byte').SetUInt( 128);
 CL.AddConstantN('DarkColorQuantity','Byte').SetUInt( 64);
  CL.AddTypeS('TButtonGetColorProc', 'Function  : TColor');
  SIRegister_TTeeButton(CL);
  SIRegister_TButtonColor(CL);
  SIRegister_TComboFlat(CL);
 {CL.AddDelphiFunction('Procedure FreeAndNil( var Obj)');
 CL.AddDelphiFunction('Procedure FreeAndNil( var Obj)');
 CL.AddDelphiFunction('Function StrToInt( const S : string) : Integer');
 CL.AddDelphiFunction('Function ColorToRGB( Color : TColor) : Longint');
 CL.AddDelphiFunction('Function GetRValue( Color : Integer) : Byte');
 CL.AddDelphiFunction('Function GetGValue( Color : Integer) : Byte');
 CL.AddDelphiFunction('Function GetBValue( Color : Integer) : Byte');
 CL.AddDelphiFunction('Function RGB( r, g, b : Integer) : TColor');}
 CL.AddDelphiFunction('Procedure TeeSetTeePen( FPen : TPen; APen : TChartPen; AColor : TColor; Handle : TTeeCanvasHandle)');
 CL.AddDelphiFunction('Function TeePoint( const aX, aY : Integer) : TPoint');
 CL.AddDelphiFunction('Function TEEPointInRect( const Rect : TRect; const P : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function PointInRect1( const Rect : TRect; x, y : Integer) : Boolean;');
 CL.AddDelphiFunction('Function TeeRect( Left, Top, Right, Bottom : Integer) : TRect');
 CL.AddDelphiFunction('Function OrientRectangle( const R : TRect) : TRect');
 CL.AddDelphiFunction('Procedure TeeSetBitmapSize( Bitmap : TBitmap; Width, Height : Integer)');
 CL.AddDelphiFunction('Function PolygonBounds( const P : array of TPoint) : TRect');
 CL.AddDelphiFunction('Function PolygonInPolygon( const A, B : array of TPoint) : Boolean');
 CL.AddDelphiFunction('Function RGBValue( const Color : TColor) : TRGB');
 CL.AddDelphiFunction('Function EditColor( AOwner : TComponent; AColor : TColor) : TColor');
 CL.AddDelphiFunction('Function EditColorDialog( AOwner : TComponent; var AColor : TColor) : Boolean');
 CL.AddDelphiFunction('Function PointAtDistance( AFrom, ATo : TPoint; ADist : Integer) : TPoint');
 CL.AddDelphiFunction('Function TeeCull( const P : TFourPoints) : Boolean;');
 CL.AddDelphiFunction('Function TeeCull1( const P0, P1, P2 : TPoint) : Boolean;');
  CL.AddTypeS('TSmoothStretchOption', '( ssBestQuality, ssBestPerformance )');
 CL.AddDelphiFunction('Procedure SmoothStretch( Src, Dst : TBitmap);');
 CL.AddDelphiFunction('Procedure SmoothStretch1( Src, Dst : TBitmap; Option : TSmoothStretchOption);');
 CL.AddDelphiFunction('Function TeeDistance( const x, y : Double) : Double');
 CL.AddDelphiFunction('Function TeeLoadLibrary( const FileName : String) : HInst');
 CL.AddDelphiFunction('Procedure TeeFreeLibrary( hLibModule : HMODULE)');
 CL.AddDelphiFunction('Procedure TeeBlendBitmaps( const Percent : Double; ABitmap, BBitmap : TBitmap; BOrigin : TPoint)');
 CL.AddDelphiFunction('Procedure TeeCalcLines( var Lines : TRGBArray; Bitmap : TBitmap)');
 CL.AddDelphiFunction('Procedure TeeShadowSmooth( Bitmap, Back : TBitmap; Left, Top, Width, Height, horz, vert : Integer; Smoothness : Double; FullDraw : Boolean; ACanvas : TCanvas3D; Clip : Boolean)');
  SIRegister_ICanvasHyperlinks(CL);
  SIRegister_ICanvasToolTips(CL);
 CL.AddDelphiFunction('Function Supports( const Instance : IInterface; const IID : TGUID) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure SmoothStretch1_P( Src, Dst : TBitmap; Option : TSmoothStretchOption);
Begin TeCanvas.SmoothStretch(Src, Dst, Option); END;

(*----------------------------------------------------------------------------*)
Procedure SmoothStretch_P( Src, Dst : TBitmap);
Begin TeCanvas.SmoothStretch(Src, Dst); END;

(*----------------------------------------------------------------------------*)
Function TeeCull1_P( const P0, P1, P2 : TPoint) : Boolean;
Begin Result := TeCanvas.TeeCull(P0, P1, P2); END;

(*----------------------------------------------------------------------------*)
Function TeeCull_P( const P : TFourPoints) : Boolean;
Begin Result := TeCanvas.TeeCull(P); END;

(*----------------------------------------------------------------------------*)
Function PointInRect1_P( const Rect : TRect; x, y : Integer) : Boolean;
Begin Result := TeCanvas.PointInRect(Rect, x, y); END;

(*----------------------------------------------------------------------------*)
Function PointInRect_P( const Rect : TRect; const P : TPoint) : Boolean;
Begin Result := TeCanvas.PointInRect(Rect, P); END;

(*----------------------------------------------------------------------------*)
procedure TComboFlatDropDownWidth_W(Self: TComboFlat; const T: Integer);
begin Self.DropDownWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TComboFlatDropDownWidth_R(Self: TComboFlat; var T: Integer);
begin T := Self.DropDownWidth; end;

(*----------------------------------------------------------------------------*)
procedure TButtonColorSymbolColor_W(Self: TButtonColor; const T: TColor);
begin Self.SymbolColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonColorSymbolColor_R(Self: TButtonColor; var T: TColor);
begin T := Self.SymbolColor; end;

(*----------------------------------------------------------------------------*)
procedure TButtonColorGetColorProc_W(Self: TButtonColor; const T: TButtonGetColorProc);
Begin Self.GetColorProc := T; end;

(*----------------------------------------------------------------------------*)
procedure TButtonColorGetColorProc_R(Self: TButtonColor; var T: TButtonGetColorProc);
Begin T := Self.GetColorProc; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvas3DBitmap_W(Self: TTeeCanvas3D; const T: TBitmap);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvas3DBitmap_R(Self: TTeeCanvas3D; var T: TBitmap);
begin T := Self.Bitmap; end;

{(*
(*----------------------------------------------------------------------------*)
procedure TTeeCanvas3DLineto_W(Self: TTeeCanvas3D; const T: TBitmap);
begin Self.Bitmap := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvas3DLineto_R(Self: TTeeCanvas3D; var T: TBitmap);
begin T := Self.Bitmap; end;  }

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvas3DSphere1_P(Self: TTeeCanvas3D;  x, y, z : Integer; const Radius : Double);
Begin Self.Sphere(x, y, z, Radius); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvas3DCalculate2DPosition1_P(Self: TTeeCanvas3D;  var x, y : Integer; z : Integer);
Begin Self.Calculate2DPosition(x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvas3DPolyline1_P(Self: TTeeCanvas3D;  const Points : array of TPoint);
Begin Self.Polyline(Points);
 END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvas3DCalc3DPos_P(Self: TTeeCanvas3D;  var x, y : Integer; z : Integer);
Begin //Self.Calc3DPos(x, y, z);
END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvas3DCalc3DPoint1_P(Self: TTeeCanvas3D;  var P : TPoint; x, y : Double; z : Integer);
Begin //Self.Calc3DPoint(P, x, y, z);
END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvas3DCalc3DPoint_P(Self: TTeeCanvas3D;  var P : TPoint; x, y, z : Integer);
Begin //Self.Calc3DPoint(P, x, y, z);
END;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DZCenter_W(Self: TCanvas3D; const T: Integer);
begin Self.ZCenter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DZCenter_R(Self: TCanvas3D; var T: Integer);
begin T := Self.ZCenter; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DYCenter_W(Self: TCanvas3D; const T: Integer);
begin Self.YCenter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DYCenter_R(Self: TCanvas3D; var T: Integer);
begin T := Self.YCenter; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DXCenter_W(Self: TCanvas3D; const T: Integer);
begin Self.XCenter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DXCenter_R(Self: TCanvas3D; var T: Integer);
begin T := Self.XCenter; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DView3DOptions_W(Self: TCanvas3D; const T: TView3DOptions);
begin Self.View3DOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DView3DOptions_R(Self: TCanvas3D; var T: TView3DOptions);
begin T := Self.View3DOptions; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DSupports3DText_R(Self: TCanvas3D; var T: Boolean);
begin T := Self.Supports3DText; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DPixels3D_W(Self: TCanvas3D; const T: TColor; const t1: Integer; const t2: Integer; const t3: Integer);
begin Self.Pixels3D[t1, t2, t3] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DPixels3D_R(Self: TCanvas3D; var T: TColor; const t1: Integer; const t2: Integer; const t3: Integer);
begin T := Self.Pixels3D[t1, t2, t3]; end;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DStretchDraw_P(Self: TCanvas3D;  const Rect : TRect; Graphic : TGraphic; Pos : Integer; Plane : TCanvas3DPlane);
Begin Self.StretchDraw(Rect, Graphic, Pos, Plane); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DSphere_P(Self: TCanvas3D;  x, y, z : Integer; const Radius : Double);
Begin Self.Sphere(x, y, z, Radius); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DRectangle1_P(Self: TCanvas3D;  X0, Y0, X1, Y1, Z : Integer);
Begin Self.Rectangle(X0, Y0, X1, Y1, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DRectangle_P(Self: TCanvas3D;  const R : TRect; Z : Integer);
Begin Self.Rectangle(R, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DPolyline_P(Self: TCanvas3D;  const Points : array of TPoint; Z : Integer);
Begin Self.Polyline(Points,  Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DPlaneWithZ1_P(Self: TCanvas3D;  P1, P2, P3, P4 : TPoint; Z : Integer);
Begin Self.PlaneWithZ(P1, P2, P3, P4, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DPlaneWithZ_P(Self: TCanvas3D;  const P : TFourPoints; Z : Integer);
Begin Self.PlaneWithZ(P, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DLineTo3D1_P(Self: TCanvas3D;  const P : TPoint3D);
Begin Self.LineTo3D(P); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DLineTo3D_P(Self: TCanvas3D;  X, Y, Z : Integer);
Begin Self.LineTo3D(X, Y, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DMoveTo3D1_P(Self: TCanvas3D;  const P : TPoint3D);
Begin Self.MoveTo3D(P); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DMoveTo3D_P(Self: TCanvas3D;  X, Y, Z : Integer);
Begin Self.MoveTo3D(X, Y, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DLineWithZ1_P(Self: TCanvas3D;  const FromPoint, ToPoint : TPoint; Z : Integer);
Begin Self.LineWithZ(FromPoint, ToPoint, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DLineWithZ_P(Self: TCanvas3D;  X0, Y0, X1, Y1, Z : Integer);
Begin Self.LineWithZ(X0, Y0, X1, Y1, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DEllipseWithZ1_P(Self: TCanvas3D;  X1, Y1, X2, Y2, Z : Integer);
Begin Self.EllipseWithZ(X1, Y1, X2, Y2, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DEllipseWithZ_P(Self: TCanvas3D;  const Rect : TRect; Z : Integer);
Begin Self.EllipseWithZ(Rect, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DCube1_P(Self: TCanvas3D;  const R : TRect; Z0, Z1 : Integer; DarkSides : Boolean);
Begin Self.Cube(R, Z0, Z1, DarkSides); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DCube_P(Self: TCanvas3D;  Left, Right, Top, Bottom, Z0, Z1 : Integer; DarkSides : Boolean);
Begin Self.Cube(Left, Right, Top, Bottom, Z0, Z1, DarkSides); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DArrow1_P(Self: TCanvas3D;  Filled : Boolean; const FromPoint, ToPoint : TPoint; ArrowWidth, ArrowHeight, Z : Integer; const ArrowPercent : Double);
Begin Self.Arrow(Filled, FromPoint, ToPoint, ArrowWidth, ArrowHeight, Z, ArrowPercent); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DArrow_P(Self: TCanvas3D;  Filled : Boolean; const FromPoint, ToPoint : TPoint; ArrowWidth, ArrowHeight, Z : Integer);
Begin Self.Arrow(Filled, FromPoint, ToPoint, ArrowWidth, ArrowHeight, Z); END;

(*----------------------------------------------------------------------------*)
Function TCanvas3DCalculate3DPosition2_P(Self: TCanvas3D;  x, y, z : Integer) : TPoint;
Begin Result := Self.Calculate3DPosition(x, y, z); END;

(*----------------------------------------------------------------------------*)
Function TCanvas3DCalculate3DPosition1_P(Self: TCanvas3D;  P : TPoint; z : Integer) : TPoint;
Begin Result := Self.Calculate3DPosition(P, z); END;

(*----------------------------------------------------------------------------*)
Function TCanvas3DCalculate3DPosition_P(Self: TCanvas3D;  const P : TPoint3D) : TPoint;
Begin Result := Self.Calculate3DPosition(P); END;

(*----------------------------------------------------------------------------*)
Procedure TCanvas3DCalculate2DPosition_P(Self: TCanvas3D;  var x, y : Integer; z : Integer);
Begin Self.Calculate2DPosition(x, y, z); END;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DRotationCenter_W(Self: TCanvas3D; const T: TPoint3DFloat);
Begin Self.RotationCenter := T; end;

(*----------------------------------------------------------------------------*)
procedure TCanvas3DRotationCenter_R(Self: TCanvas3D; var T: TPoint3DFloat);
Begin T := Self.RotationCenter; end;

(*----------------------------------------------------------------------------*)
procedure TFloatXYZZ_W(Self: TFloatXYZ; const T: Double);
begin Self.Z := T; end;

(*----------------------------------------------------------------------------*)
procedure TFloatXYZZ_R(Self: TFloatXYZ; var T: Double);
begin T := Self.Z; end;

(*----------------------------------------------------------------------------*)
procedure TFloatXYZY_W(Self: TFloatXYZ; const T: Double);
begin Self.Y := T; end;

(*----------------------------------------------------------------------------*)
procedure TFloatXYZY_R(Self: TFloatXYZ; var T: Double);
begin T := Self.Y; end;

(*----------------------------------------------------------------------------*)
procedure TFloatXYZX_W(Self: TFloatXYZ; const T: Double);
begin Self.X := T; end;

(*----------------------------------------------------------------------------*)
procedure TFloatXYZX_R(Self: TFloatXYZ; var T: Double);
begin T := Self.X; end;

(*----------------------------------------------------------------------------*)
procedure TFloatXYZOnChange_W(Self: TFloatXYZ; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TFloatXYZOnChange_R(Self: TFloatXYZ; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasUseBuffer_W(Self: TTeeCanvas; const T: Boolean);
begin Self.UseBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasUseBuffer_R(Self: TTeeCanvas; var T: Boolean);
begin T := Self.UseBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasTextAlign_W(Self: TTeeCanvas; const T: TCanvasTextAlign);
begin Self.TextAlign := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasTextAlign_R(Self: TTeeCanvas; var T: TCanvasTextAlign);
begin T := Self.TextAlign; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasReferenceCanvas_W(Self: TTeeCanvas; const T: TCanvas);
begin Self.ReferenceCanvas := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasReferenceCanvas_R(Self: TTeeCanvas; var T: TCanvas);
begin T := Self.ReferenceCanvas; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasPixels_W(Self: TTeeCanvas; const T: TColor; const t1: Integer; const t2: Integer);
begin Self.Pixels[t1, t2] := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasPixels_R(Self: TTeeCanvas; var T: TColor; const t1: Integer; const t2: Integer);
begin T := Self.Pixels[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasPen_R(Self: TTeeCanvas; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasMonochrome_W(Self: TTeeCanvas; const T: Boolean);
begin Self.Monochrome := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasMonochrome_R(Self: TTeeCanvas; var T: Boolean);
begin T := Self.Monochrome; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasMetafiling_W(Self: TTeeCanvas; const T: Boolean);
begin Self.Metafiling := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasMetafiling_R(Self: TTeeCanvas; var T: Boolean);
begin T := Self.Metafiling; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasHandle_R(Self: TTeeCanvas; var T: TTeeCanvasHandle);
begin T := Self.Handle; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasFontHeight_R(Self: TTeeCanvas; var T: Integer);
begin T := Self.FontHeight; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasFont_R(Self: TTeeCanvas; var T: TFont);
begin T := Self.Font; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasBrush_R(Self: TTeeCanvas; var T: TBrush);
begin T := Self.Brush; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasBounds_R(Self: TTeeCanvas; var T: TRect);
begin T := Self.Bounds; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasBackMode_W(Self: TTeeCanvas; const T: TCanvasBackMode);
begin Self.BackMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasBackMode_R(Self: TTeeCanvas; var T: TCanvasBackMode);
begin T := Self.BackMode; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasBackColor_W(Self: TTeeCanvas; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasBackColor_R(Self: TTeeCanvas; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasSupportsFullRotation_R(Self: TTeeCanvas; var T: Boolean);
begin T := Self.SupportsFullRotation; end;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasPolyline_P(Self: TTeeCanvas;  const Points : array of TPoint);
Begin Self.Polyline(Points); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasLine1_P(Self: TTeeCanvas;  const FromPoint, ToPoint : TPoint);
Begin Self.Line(FromPoint, ToPoint); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasLine_P(Self: TTeeCanvas;  X0, Y0, X1, Y1 : Integer);
Begin Self.Line(X0, Y0, X1, Y1); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasClipRectangle1_P(Self: TTeeCanvas;  const Rect : TRect; RoundSize : Integer);
Begin Self.ClipRectangle(Rect, RoundSize); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasClipRectangle_P(Self: TTeeCanvas;  const Rect : TRect);
Begin Self.ClipRectangle(Rect); END;

(*----------------------------------------------------------------------------*)
Function TTeeCanvasTextHeight1_P(Self: TTeeCanvas;  const St : WideString) : Integer;
Begin Result := Self.TextHeight(St); END;

(*----------------------------------------------------------------------------*)
Function TTeeCanvasTextWidth1_P(Self: TTeeCanvas;  const St : WideString) : Integer;
Begin Result := Self.TextWidth(St); END;

(*----------------------------------------------------------------------------*)
Function TTeeCanvasTextHeight_P(Self: TTeeCanvas;  const St : String) : Integer;
Begin Result := Self.TextHeight(St); END;

(*----------------------------------------------------------------------------*)
Function TTeeCanvasTextWidth_P(Self: TTeeCanvas;  const St : String) : Integer;
Begin Result := Self.TextWidth(St); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasTextOut2_P(Self: TTeeCanvas;  X, Y : Integer; const Text : String);
Begin Self.TextOut(X, Y, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasTextOut1_P(Self: TTeeCanvas;  X, Y : Integer; const Text : String; AllowHtml : Boolean);
Begin Self.TextOut(X, Y, Text, AllowHtml); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasTextOut_P(Self: TTeeCanvas;  X, Y : Integer; const Text : WideString);
Begin Self.TextOut(X, Y, Text); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasStretchDraw_P(Self: TTeeCanvas;  const Rect : TRect; Graphic : TGraphic);
Begin Self.StretchDraw(Rect, Graphic); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasRoundRect1_P(Self: TTeeCanvas;  const R : TRect; X, Y : Integer);
Begin Self.RoundRect(R, X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasRoundRect_P(Self: TTeeCanvas;  X1, Y1, X2, Y2, X3, Y3 : Integer);
Begin Self.RoundRect(X1, Y1, X2, Y2, X3, Y3); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasRectangle1_P(Self: TTeeCanvas;  X0, Y0, X1, Y1 : Integer);
Begin Self.Rectangle(X0, Y0, X1, Y1); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasRectangle_P(Self: TTeeCanvas;  const R : TRect);
Begin Self.Rectangle(R); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasMoveTo1_P(Self: TTeeCanvas;  const P : TPoint);
Begin Self.MoveTo(P); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasMoveTo_P(Self: TTeeCanvas;  X, Y : Integer);
Begin Self.MoveTo(X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasLineTo1_P(Self: TTeeCanvas;  const P : TPoint);
Begin Self.LineTo(P); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasLineTo_P(Self: TTeeCanvas;  X, Y : Integer);
Begin Self.LineTo(X, Y); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasEllipse1_P(Self: TTeeCanvas;  X1, Y1, X2, Y2 : Integer);
Begin Self.Ellipse(X1, Y1, X2, Y2); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasEllipse_P(Self: TTeeCanvas;  const R : TRect);
Begin Self.Ellipse(R); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasArrow_P(Self: TTeeCanvas;  Filled : Boolean; const ArrowPercent : Double; const FromPoint, ToPoint : TPoint; ArrowWidth, ArrowHeight : Integer);
Begin Self.Arrow(Filled, ArrowPercent, FromPoint, ToPoint, ArrowWidth, ArrowHeight); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasArc1_P(Self: TTeeCanvas;  const Left, Top, Right, Bottom : Integer; StartAngle, EndAngle : Double);
Begin Self.Arc(Left, Top, Right, Bottom, StartAngle, EndAngle); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasArc_P(Self: TTeeCanvas;  const Left, Top, Right, Bottom, StartX, StartY, EndX, EndY : Integer);
Begin Self.Arc(Left, Top, Right, Bottom, StartX, StartY, EndX, EndY); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasAssignBrush2_P(Self: TTeeCanvas;  ABrush : TChartBrush; AColor, ABackColor : TColor);
Begin Self.AssignBrush(ABrush, AColor, ABackColor); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasAssignBrush1_P(Self: TTeeCanvas;  ABrush : TChartBrush; ABackColor : TColor);
Begin Self.AssignBrush(ABrush, ABackColor); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeCanvasAssignBrush_P(Self: TTeeCanvas;  ABrush : TChartBrush);
Begin Self.AssignBrush(ABrush); END;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasFontZoom_W(Self: TTeeCanvas; const T: Double);
Begin Self.FontZoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeCanvasFontZoom_R(Self: TTeeCanvas; var T: Double);
Begin T := Self.FontZoom; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontShadow_W(Self: TTeeFont; const T: TTeeShadow);
begin Self.Shadow := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontShadow_R(Self: TTeeFont; var T: TTeeShadow);
begin T := Self.Shadow; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontPicture_W(Self: TTeeFont; const T: TTeePicture);
begin Self.Picture := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontPicture_R(Self: TTeeFont; var T: TTeePicture);
begin T := Self.Picture; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontOutLine_W(Self: TTeeFont; const T: TChartHiddenPen);
begin Self.OutLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontOutLine_R(Self: TTeeFont; var T: TChartHiddenPen);
begin T := Self.OutLine; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontInterCharSize_W(Self: TTeeFont; const T: Integer);
begin Self.InterCharSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontInterCharSize_R(Self: TTeeFont; var T: Integer);
begin T := Self.InterCharSize; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontGradient_W(Self: TTeeFont; const T: TTeeFontGradient);
begin Self.Gradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontGradient_R(Self: TTeeFont; var T: TTeeFontGradient);
begin T := Self.Gradient; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontGradientOutline_W(Self: TTeeFontGradient; const T: Boolean);
begin Self.Outline := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFontGradientOutline_R(Self: TTeeFontGradient; var T: Boolean);
begin T := Self.Outline; end;

(*----------------------------------------------------------------------------*)
procedure TSubGradientTransparency_W(Self: TSubGradient; const T: TTeeTransparency);
begin Self.Transparency := T; end;

(*----------------------------------------------------------------------------*)
procedure TSubGradientTransparency_R(Self: TSubGradient; var T: TTeeTransparency);
begin T := Self.Transparency; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientVisible_W(Self: TCustomTeeGradient; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientVisible_R(Self: TCustomTeeGradient; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientSubGradient_W(Self: TCustomTeeGradient; const T: TSubGradient);
begin Self.SubGradient := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientSubGradient_R(Self: TCustomTeeGradient; var T: TSubGradient);
begin T := Self.SubGradient; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientStartColor_W(Self: TCustomTeeGradient; const T: TColor);
begin Self.StartColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientStartColor_R(Self: TCustomTeeGradient; var T: TColor);
begin T := Self.StartColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientRadialY_W(Self: TCustomTeeGradient; const T: Integer);
begin Self.RadialY := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientRadialY_R(Self: TCustomTeeGradient; var T: Integer);
begin T := Self.RadialY; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientRadialX_W(Self: TCustomTeeGradient; const T: Integer);
begin Self.RadialX := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientRadialX_R(Self: TCustomTeeGradient; var T: Integer);
begin T := Self.RadialX; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientMidColor_W(Self: TCustomTeeGradient; const T: TColor);
begin Self.MidColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientMidColor_R(Self: TCustomTeeGradient; var T: TColor);
begin T := Self.MidColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientEndColor_W(Self: TCustomTeeGradient; const T: TColor);
begin Self.EndColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientEndColor_R(Self: TCustomTeeGradient; var T: TColor);
begin T := Self.EndColor; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientDirection_W(Self: TCustomTeeGradient; const T: TGradientDirection);
begin Self.Direction := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientDirection_R(Self: TCustomTeeGradient; var T: TGradientDirection);
begin T := Self.Direction; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientBalance_W(Self: TCustomTeeGradient; const T: Integer);
begin Self.Balance := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientBalance_R(Self: TCustomTeeGradient; var T: Integer);
begin T := Self.Balance; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientAngle_W(Self: TCustomTeeGradient; const T: Integer);
begin Self.Angle := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientAngle_R(Self: TCustomTeeGradient; var T: Integer);
begin T := Self.Angle; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientChanged_W(Self: TCustomTeeGradient; const T: TNotifyEvent);
begin Self.Changed := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomTeeGradientChanged_R(Self: TCustomTeeGradient; var T: TNotifyEvent);
begin T := Self.Changed; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeeGradientDraw6_P(Self: TCustomTeeGradient;  Canvas : TCanvas3D; var P : TPointArray; Z : Integer; Is3D : Boolean);
Begin Self.Draw(Canvas, P, Z, Is3D); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeeGradientDraw5_P(Self: TCustomTeeGradient;  Canvas : TCanvas3D; var P : TFourPoints; Z : Integer);
Begin Self.Draw(Canvas, P, Z); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeeGradientDraw4_P(Self: TCustomTeeGradient;  Canvas : TTeeCanvas; var P : TFourPoints);
Begin Self.Draw(Canvas, P); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomTeeGradientDraw3_P(Self: TCustomTeeGradient;  Canvas : TTeeCanvas; const Rect : TRect; RoundRectSize : Integer);
Begin Self.Draw(Canvas, Rect, RoundRectSize); END;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowVisible_W(Self: TTeeShadow; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowVisible_R(Self: TTeeShadow; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowVertSize_W(Self: TTeeShadow; const T: Integer);
begin Self.VertSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowVertSize_R(Self: TTeeShadow; var T: Integer);
begin T := Self.VertSize; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowTransparency_W(Self: TTeeShadow; const T: TTeeTransparency);
begin Self.Transparency := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowTransparency_R(Self: TTeeShadow; var T: TTeeTransparency);
begin T := Self.Transparency; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowSmoothBlur_W(Self: TTeeShadow; const T: Integer);
begin Self.SmoothBlur := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowSmoothBlur_R(Self: TTeeShadow; var T: Integer);
begin T := Self.SmoothBlur; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowSmooth_W(Self: TTeeShadow; const T: Boolean);
begin Self.Smooth := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowSmooth_R(Self: TTeeShadow; var T: Boolean);
begin T := Self.Smooth; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowHorizSize_W(Self: TTeeShadow; const T: Integer);
begin Self.HorizSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowHorizSize_R(Self: TTeeShadow; var T: Integer);
begin T := Self.HorizSize; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowColor_W(Self: TTeeShadow; const T: TColor);
begin Self.Color := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowColor_R(Self: TTeeShadow; var T: TColor);
begin T := Self.Color; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowClip_W(Self: TTeeShadow; const T: Boolean);
begin Self.Clip := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowClip_R(Self: TTeeShadow; var T: Boolean);
begin T := Self.Clip; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowSize_W(Self: TTeeShadow; const T: Integer);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeShadowSize_R(Self: TTeeShadow; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
Procedure TTeeShadowDraw2_P(Self: TTeeShadow;  ACanvas : TCanvas3D; const Rect : TRect; Z : Integer; RoundSize : Integer);
Begin Self.Draw(ACanvas, Rect, Z, RoundSize); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeShadowDraw1_P(Self: TTeeShadow;  ACanvas : TCanvas3D; const Rect : TRect);
Begin Self.Draw(ACanvas, Rect); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeShadowDraw_P(Self: TTeeShadow;  ACanvas : TCanvas3D; const P : array of TPoint);
Begin Self.Draw(ACanvas, P); END;

(*----------------------------------------------------------------------------*)
procedure TTeeBlendBitmap_R(Self: TTeeBlend; var T: TBitmap);
begin T := Self.Bitmap; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsZoomText_W(Self: TView3DOptions; const T: Boolean);
begin Self.ZoomText := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsZoomText_R(Self: TView3DOptions; var T: Boolean);
begin T := Self.ZoomText; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsZoom_W(Self: TView3DOptions; const T: Integer);
begin Self.Zoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsZoom_R(Self: TView3DOptions; var T: Integer);
begin T := Self.Zoom; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsVertOffset_W(Self: TView3DOptions; const T: Integer);
begin Self.VertOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsVertOffset_R(Self: TView3DOptions; var T: Integer);
begin T := Self.VertOffset; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsTilt_W(Self: TView3DOptions; const T: Integer);
begin Self.Tilt := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsTilt_R(Self: TView3DOptions; var T: Integer);
begin T := Self.Tilt; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsRotation_W(Self: TView3DOptions; const T: Integer);
begin Self.Rotation := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsRotation_R(Self: TView3DOptions; var T: Integer);
begin T := Self.Rotation; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsPerspective_W(Self: TView3DOptions; const T: Integer);
begin Self.Perspective := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsPerspective_R(Self: TView3DOptions; var T: Integer);
begin T := Self.Perspective; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsOrthogonal_W(Self: TView3DOptions; const T: Boolean);
begin Self.Orthogonal := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsOrthogonal_R(Self: TView3DOptions; var T: Boolean);
begin T := Self.Orthogonal; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsOrthoAngle_W(Self: TView3DOptions; const T: Integer);
begin Self.OrthoAngle := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsOrthoAngle_R(Self: TView3DOptions; var T: Integer);
begin T := Self.OrthoAngle; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsHorizOffset_W(Self: TView3DOptions; const T: Integer);
begin Self.HorizOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsHorizOffset_R(Self: TView3DOptions; var T: Integer);
begin T := Self.HorizOffset; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsFontZoom_W(Self: TView3DOptions; const T: Integer);
begin Self.FontZoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsFontZoom_R(Self: TView3DOptions; var T: Integer);
begin T := Self.FontZoom; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsElevation_W(Self: TView3DOptions; const T: Integer);
begin Self.Elevation := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsElevation_R(Self: TView3DOptions; var T: Integer);
begin T := Self.Elevation; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsOnScrolled_W(Self: TView3DOptions; const T: TTeeView3DScrolled);
begin Self.OnScrolled := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsOnScrolled_R(Self: TView3DOptions; var T: TTeeView3DScrolled);
begin T := Self.OnScrolled; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsOnChangedZoom_W(Self: TView3DOptions; const T: TTeeView3DChangedZoom);
begin Self.OnChangedZoom := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsOnChangedZoom_R(Self: TView3DOptions; var T: TTeeView3DChangedZoom);
begin T := Self.OnChangedZoom; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsZoomFloat_W(Self: TView3DOptions; const T: Double);
begin Self.ZoomFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsZoomFloat_R(Self: TView3DOptions; var T: Double);
begin T := Self.ZoomFloat; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsRotationFloat_W(Self: TView3DOptions; const T: Double);
begin Self.RotationFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsRotationFloat_R(Self: TView3DOptions; var T: Double);
begin T := Self.RotationFloat; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsElevationFloat_W(Self: TView3DOptions; const T: Double);
begin Self.ElevationFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsElevationFloat_R(Self: TView3DOptions; var T: Double);
begin T := Self.ElevationFloat; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsParent_W(Self: TView3DOptions; const T: TWinControl);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TView3DOptionsParent_R(Self: TView3DOptions; var T: TWinControl);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
Procedure TView3DOptionsSetRotation_P(Self: TView3DOptions;  const Value : Double);
Begin //Self.SetRotation(Value);
END;

(*----------------------------------------------------------------------------*)
procedure TChartBrushImage_W(Self: TChartBrush; const T: TPicture);
begin Self.Image := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartBrushImage_R(Self: TChartBrush; var T: TPicture);
begin T := Self.Image; end;

(*----------------------------------------------------------------------------*)
procedure TChartBrushBackColor_W(Self: TChartBrush; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartBrushBackColor_R(Self: TChartBrush; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TChartPenVisible_W(Self: TChartPen; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartPenVisible_R(Self: TChartPen; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TChartPenSmallSpace_W(Self: TChartPen; const T: Integer);
begin Self.SmallSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartPenSmallSpace_R(Self: TChartPen; var T: Integer);
begin T := Self.SmallSpace; end;

(*----------------------------------------------------------------------------*)
procedure TChartPenSmallDots_W(Self: TChartPen; const T: Boolean);
begin Self.SmallDots := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartPenSmallDots_R(Self: TChartPen; var T: Boolean);
begin T := Self.SmallDots; end;

(*----------------------------------------------------------------------------*)
procedure TChartPenEndStyle_W(Self: TChartPen; const T: TPenEndStyle);
begin Self.EndStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TChartPenEndStyle_R(Self: TChartPen; var T: TPenEndStyle);
begin T := Self.EndStyle; end;

(*----------------------------------------------------------------------------*)
procedure TTeePictureFilters_W(Self: TTeePicture; const T: TFilterItems);
begin Self.Filters := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeePictureFilters_R(Self: TTeePicture; var T: TFilterItems);
begin T := Self.Filters; end;

(*----------------------------------------------------------------------------*)
procedure TBlurFilterSteps_W(Self: TBlurFilter; const T: Integer);
begin Self.Steps := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlurFilterSteps_R(Self: TBlurFilter; var T: Integer);
begin T := Self.Steps; end;

(*----------------------------------------------------------------------------*)
procedure TBlurFilterAmount_W(Self: TBlurFilter; const T: Integer);
begin Self.Amount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlurFilterAmount_R(Self: TBlurFilter; var T: Integer);
begin T := Self.Amount; end;

(*----------------------------------------------------------------------------*)
procedure TFilterItemsItem_W(Self: TFilterItems; const T: TTeeFilter; const t1: Integer);
begin Self.Item[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilterItemsItem_R(Self: TFilterItems; var T: TTeeFilter; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFilterRegion_W(Self: TTeeFilter; const T: TFilterRegion);
begin Self.Region := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFilterRegion_R(Self: TTeeFilter; var T: TFilterRegion);
begin T := Self.Region; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFilterEnabled_W(Self: TTeeFilter; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFilterEnabled_R(Self: TTeeFilter; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
Procedure TTeeFilterApply1_P(Self: TTeeFilter;  Bitmap : TBitmap; const R : TRect);
Begin Self.Apply(Bitmap, R); END;

(*----------------------------------------------------------------------------*)
Procedure TTeeFilterApply_P(Self: TTeeFilter;  Bitmap : TBitmap);
Begin Self.Apply(Bitmap); END;

(*----------------------------------------------------------------------------*)
procedure TTeeFilterLines_W(Self: TTeeFilter; const T: TRGBArray);
Begin Self.Lines := T; end;

(*----------------------------------------------------------------------------*)
procedure TTeeFilterLines_R(Self: TTeeFilter; var T: TRGBArray);
Begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionWidth_W(Self: TFilterRegion; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionWidth_R(Self: TFilterRegion; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionTop_W(Self: TFilterRegion; const T: Integer);
begin Self.Top := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionTop_R(Self: TFilterRegion; var T: Integer);
begin T := Self.Top; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionLeft_W(Self: TFilterRegion; const T: Integer);
begin Self.Left := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionLeft_R(Self: TFilterRegion; var T: Integer);
begin T := Self.Left; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionHeight_W(Self: TFilterRegion; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionHeight_R(Self: TFilterRegion; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionRectangle_W(Self: TFilterRegion; const T: TRect);
begin Self.Rectangle := T; end;

(*----------------------------------------------------------------------------*)
procedure TFilterRegionRectangle_R(Self: TFilterRegion; var T: TRect);
begin T := Self.Rectangle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComboFlat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComboFlat) do begin
    RegisterMethod(@TComboFlat.Add, 'Add');
    RegisterMethod(@TComboFlat.AddItem, 'AddItem');
    RegisterMethod(@TComboFlat.AddItem, 'AddItem');
    RegisterMethod(@TComboFlat.CurrentItem, 'CurrentItem');
    RegisterMethod(@TComboFlat.SelectedObject, 'SelectedObject');
    RegisterPropertyHelper(@TComboFlatDropDownWidth_R,@TComboFlatDropDownWidth_W,'DropDownWidth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TButtonColor(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TButtonColor) do begin
   RegisterMethod(@TButtonColor.Click, 'Click');
    RegisterPropertyHelper(@TButtonColorGetColorProc_R,@TButtonColorGetColorProc_W,'GetColorProc');
    RegisterPropertyHelper(@TButtonColorSymbolColor_R,@TButtonColorSymbolColor_W,'SymbolColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeButton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeButton) do
  begin
    RegisterMethod(@TTeeButton.LinkProperty, 'LinkProperty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TeCanvas_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ApplyDark, 'ApplyDark', cdRegister);
 S.RegisterDelphiFunction(@ApplyBright, 'ApplyBright', cdRegister);
 S.RegisterDelphiFunction(@Point3D, 'Point3D', cdRegister);
 S.RegisterDelphiFunction(@SwapDouble, 'SwapDouble', cdRegister);
 S.RegisterDelphiFunction(@SwapInteger, 'SwapInteger', cdRegister);
 S.RegisterDelphiFunction(@RectSize, 'RectSize', cdRegister);
 S.RegisterDelphiFunction(@RectCenter, 'teeRectCenter', cdRegister);
 S.RegisterDelphiFunction(@RectFromPolygon, 'RectFromPolygon', cdRegister);
 S.RegisterDelphiFunction(@RectFromTriangle, 'RectFromTriangle', cdRegister);
 S.RegisterDelphiFunction(@RectangleInRectangle, 'RectangleInRectangle', cdRegister);
 S.RegisterDelphiFunction(@ClipCanvas, 'ClipCanvas', cdRegister);
 S.RegisterDelphiFunction(@UnClipCanvas, 'UnClipCanvas', cdRegister);
 S.RegisterDelphiFunction(@ClipEllipse, 'ClipEllipse', cdRegister);
 S.RegisterDelphiFunction(@ClipRoundRectangle, 'ClipRoundRectangle', cdRegister);
 S.RegisterDelphiFunction(@ClipPolygon, 'ClipPolygon', cdRegister);
{  RIRegister_TTeeButton(CL);
  RIRegister_TButtonColor(CL);
  RIRegister_TComboFlat(CL); }
{ S.RegisterDelphiFunction(@FreeAndNil, 'FreeAndNil', cdRegister);
 S.RegisterDelphiFunction(@FreeAndNil, 'FreeAndNil', cdRegister);
 S.RegisterDelphiFunction(@StrToInt, 'StrToInt', cdRegister);
 S.RegisterDelphiFunction(@ColorToRGB, 'ColorToRGB', cdRegister);  }
 {S.RegisterDelphiFunction(@GetRValue, 'GetRValue', cdRegister);
 S.RegisterDelphiFunction(@GetGValue, 'GetGValue', cdRegister);
 S.RegisterDelphiFunction(@GetBValue, 'GetBValue', cdRegister);
 S.RegisterDelphiFunction(@RGB, 'RGB', cdRegister); }
 S.RegisterDelphiFunction(@TeeSetTeePen, 'TeeSetTeePen', cdRegister);
 S.RegisterDelphiFunction(@TeePoint, 'TeePoint', cdRegister);
 S.RegisterDelphiFunction(@PointInRect, 'TEEPointInRect', cdRegister);
 S.RegisterDelphiFunction(@PointInRect1_P, 'PointInRect1', cdRegister);
 S.RegisterDelphiFunction(@TeeRect, 'TeeRect', cdRegister);
 S.RegisterDelphiFunction(@OrientRectangle, 'OrientRectangle', cdRegister);
 S.RegisterDelphiFunction(@TeeSetBitmapSize, 'TeeSetBitmapSize', cdRegister);
 S.RegisterDelphiFunction(@PolygonBounds, 'PolygonBounds', cdRegister);
 S.RegisterDelphiFunction(@PolygonInPolygon, 'PolygonInPolygon', cdRegister);
 S.RegisterDelphiFunction(@RGBValue, 'RGBValue', cdRegister);
 S.RegisterDelphiFunction(@EditColor, 'EditColor', cdRegister);
 S.RegisterDelphiFunction(@EditColorDialog, 'EditColorDialog', cdRegister);
 S.RegisterDelphiFunction(@PointAtDistance, 'PointAtDistance', cdRegister);
 S.RegisterDelphiFunction(@TeeCull, 'TeeCull', cdRegister);
 S.RegisterDelphiFunction(@TeeCull1_P, 'TeeCull1', cdRegister);
 S.RegisterDelphiFunction(@SmoothStretch, 'SmoothStretch', cdRegister);
 S.RegisterDelphiFunction(@SmoothStretch1_P, 'SmoothStretch1', cdRegister);
 S.RegisterDelphiFunction(@TeeDistance, 'TeeDistance', cdRegister);
 S.RegisterDelphiFunction(@TeeLoadLibrary, 'TeeLoadLibrary', cdRegister);
 S.RegisterDelphiFunction(@TeeFreeLibrary, 'TeeFreeLibrary', cdRegister);
 S.RegisterDelphiFunction(@TeeBlendBitmaps, 'TeeBlendBitmaps', cdRegister);
 S.RegisterDelphiFunction(@TeeCalcLines, 'TeeCalcLines', cdRegister);
 S.RegisterDelphiFunction(@TeeShadowSmooth, 'TeeShadowSmooth', cdRegister);
 S.RegisterDelphiFunction(@Supports, 'Supports', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCanvas3D(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCanvas3D) do begin
    RegisterConstructor(@TTeeCanvas3D.Create, 'Create');
      RegisterMethod(@TTeeCanvas3D.Destroy, 'Free');
    //RegisterMethod(@TTeeCanvas3D.CalcTrigValues, 'CalcTrigValues');
    RegisterMethod(@TTeeCanvas3D.Fillrect, 'FillRect');
    RegisterMethod(@TTeeCanvas3D.lineto, 'LineTo');
    RegisterMethod(@TTeeCanvas3D.Moveto, 'Moveto');
    RegisterPropertyHelper(@TTeeCanvas3DBitmap_R,@TTeeCanvas3DBitmap_W,'Bitmap');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCanvas3D(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCanvas3D) do begin
    RegisterPropertyHelper(@TCanvas3DRotationCenter_R,@TCanvas3DRotationCenter_W,'RotationCenter');
    RegisterMethod(@TCanvas3D.CalcRect3D, 'CalcRect3D');
    RegisterMethod(@TCanvas3D.Calculate2DPosition, 'Calculate2DPosition');
    RegisterMethod(@TCanvas3DCalculate3DPosition_P, 'Calculate3DPosition');
    RegisterMethod(@TCanvas3DCalculate3DPosition1_P, 'Calculate3DPosition1');
    //RegisterVirtualAbstractMethod(@TCanvas3D, @!.Calculate3DPosition2, 'Calculate3DPosition2');
    RegisterMethod(@TCanvas3D.Calc3DPoints, 'Calc3DPoints');
    RegisterMethod(@TCanvas3D.FourPointsFromRect, 'FourPointsFromRect');
    RegisterMethod(@TCanvas3D.RectFromRectZ, 'RectFromRectZ');
    RegisterMethod(@TCanvas3D.InitWindow, 'InitWindow');
    RegisterVirtualMethod(@TCanvas3D.Assign, 'Assign');
    RegisterMethod(@TCanvas3D.Projection, 'Projection');
    RegisterMethod(@TCanvas3D.ShowImage, 'ShowImage');
    RegisterMethod(@TCanvas3D.ReDrawBitmap, 'ReDrawBitmap');
    RegisterMethod(@TCanvas3DArrow_P, 'Arrow');
    RegisterMethod(@TCanvas3DCube1_P, 'Cube1');
    RegisterMethod(@TCanvas3DCube_P, 'Cube');
    RegisterMethod(@TCanvas3D.Cylinder, 'Cylinder');
    RegisterVirtualMethod(@TCanvas3D.DisableRotation, 'DisableRotation');
    RegisterMethod(@TCanvas3DEllipseWithZ_P, 'EllipseWithZ');
    //RegisterVirtualAbstractMethod(@TCanvas3D, @!.EllipseWithZ1, 'EllipseWithZ1');
    RegisterMethod(@TCanvas3DEllipseWithZ1_P, 'EllipseWithZ1');

    RegisterVirtualMethod(@TCanvas3D.EnableRotation, 'EnableRotation');
    RegisterVirtualMethod(@TCanvas3D.HorizLine3D, 'HorizLine3D');
    RegisterVirtualMethod(@TCanvas3D.VertLine3D, 'VertLine3D');
    RegisterVirtualMethod(@TCanvas3D.ZLine3D, 'ZLine3D');
    RegisterVirtualMethod(@TCanvas3D.FrontPlaneBegin, 'FrontPlaneBegin');
    RegisterVirtualMethod(@TCanvas3D.FrontPlaneEnd, 'FrontPlaneEnd');
    RegisterVirtualMethod(@TCanvas3DLineWithZ_P, 'LineWithZ');
    RegisterMethod(@TCanvas3DLineWithZ1_P, 'LineWithZ1');
    RegisterVirtualMethod(@TCanvas3DMoveTo3D_P, 'MoveTo3D');
    RegisterMethod(@TCanvas3DMoveTo3D1_P, 'MoveTo3D1');
    RegisterVirtualMethod(@TCanvas3DLineTo3D_P, 'LineTo3D');
    RegisterMethod(@TCanvas3DLineTo3D1_P, 'LineTo3D1');
    RegisterMethod(@TCanvas3D.Pie3D, 'Pie3D');
    RegisterMethod(@TCanvas3D.Plane3D, 'Plane3D');
    RegisterMethod(@TCanvas3DPlaneWithZ_P, 'PlaneWithZ');
    RegisterMethod(@TCanvas3DPlaneWithZ1_P, 'PlaneWithZ1');
    RegisterMethod(@TCanvas3D.PlaneFour3D, 'PlaneFour3D');
    //RegisterVirtualAbstractMethod(@TCanvas3D, @!.Polygon3D, 'Polygon3D');
    RegisterMethod(@TCanvas3D.Polygon3D, 'Polygon3D');
     RegisterVirtualMethod(@TCanvas3D.PolygonWithZ, 'PolygonWithZ');
    RegisterVirtualMethod(@TCanvas3DPolyline_P, 'Polyline');
    RegisterMethod(@TCanvas3D.Pyramid, 'Pyramid');
    RegisterMethod(@TCanvas3D.PyramidTrunc, 'PyramidTrunc');
    RegisterMethod(@TCanvas3DRectangle_P, 'Rectangle');
    RegisterMethod(@TCanvas3DRectangle1_P, 'Rectangle1');
    RegisterMethod(@TCanvas3D.RectangleWithZ, 'RectangleWithZ');
    RegisterMethod(@TCanvas3D.RectangleY, 'RectangleY');
    RegisterMethod(@TCanvas3D.RectangleZ, 'RectangleZ');
    RegisterMethod(@TCanvas3D.RotatedEllipse, 'RotatedEllipse');
    RegisterMethod(@TCanvas3D.RotateLabel3D, 'RotateLabel3D');
    RegisterMethod(@TCanvas3D.Sphere, 'Sphere');
    RegisterMethod(@TCanvas3DStretchDraw_P, 'StretchDraw');
    RegisterPropertyHelper(@TCanvas3DPixels3D_R,@TCanvas3DPixels3D_W,'Pixels3D');
    RegisterPropertyHelper(@TCanvas3DSupports3DText_R,nil,'Supports3DText');
    RegisterPropertyHelper(@TCanvas3DView3DOptions_R,@TCanvas3DView3DOptions_W,'View3DOptions');
    RegisterPropertyHelper(@TCanvas3DXCenter_R,@TCanvas3DXCenter_W,'XCenter');
    RegisterPropertyHelper(@TCanvas3DYCenter_R,@TCanvas3DYCenter_W,'YCenter');
    RegisterPropertyHelper(@TCanvas3DZCenter_R,@TCanvas3DZCenter_W,'ZCenter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFloatXYZ(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFloatXYZ) do begin
    RegisterPropertyHelper(@TFloatXYZOnChange_R,@TFloatXYZOnChange_W,'OnChange');
    RegisterMethod(@TFloatXYZ.Assign, 'Assign');
    RegisterPropertyHelper(@TFloatXYZX_R,@TFloatXYZX_W,'X');
    RegisterPropertyHelper(@TFloatXYZY_R,@TFloatXYZY_W,'Y');
    RegisterPropertyHelper(@TFloatXYZZ_R,@TFloatXYZZ_W,'Z');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeCanvas(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeCanvas) do begin
    RegisterPropertyHelper(@TTeeCanvasFontZoom_R,@TTeeCanvasFontZoom_W,'FontZoom');
    RegisterMethod(@TTeeCanvasAssignBrush_P, 'AssignBrush');
    RegisterMethod(@TTeeCanvasAssignBrush1_P, 'AssignBrush1');
    RegisterMethod(@TTeeCanvasAssignBrush2_P, 'AssignBrush2');
    RegisterMethod(@TTeeCanvas.AssignBrushColor, 'AssignBrushColor');
    RegisterMethod(@TTeeCanvas.AssignVisiblePen, 'AssignVisiblePen');
    RegisterVirtualMethod(@TTeeCanvas.AssignVisiblePenColor, 'AssignVisiblePenColor');
    RegisterMethod(@TTeeCanvas.AssignFont, 'AssignFont');
    RegisterMethod(@TTeeCanvas.ResetState, 'ResetState');
    RegisterVirtualMethod(@TTeeCanvas.BeginBlending, 'BeginBlending');
    RegisterVirtualMethod(@TTeeCanvas.EndBlending, 'EndBlending');
    RegisterMethod(@TTeeCanvas.Arc, 'Arc');
    RegisterVirtualMethod(@TTeeCanvasArc1_P, 'Arc1');
    RegisterMethod(@TTeeCanvasArrow_P, 'Arrow');
    RegisterMethod(@TTeeCanvas.Donut, 'Donut');
    RegisterMethod(@TTeeCanvas.Draw, 'Draw');
    RegisterMethod(@TTeeCanvasEllipse_P, 'Ellipse');
    RegisterMethod(@TTeeCanvasEllipse1_P, 'Ellipse1');
    RegisterMethod(@TTeeCanvas.FillRect, 'FillRect');
    RegisterVirtualMethod(@TTeeCanvas.Frame3D, 'Frame3D');
    RegisterMethod(@TTeeCanvas.LineTo, 'LineTo');
    RegisterMethod(@TTeeCanvasLineTo1_P, 'LineTo1');
    RegisterMethod(@TTeeCanvas.MoveTo, 'MoveTo');
    RegisterMethod(@TTeeCanvasMoveTo1_P, 'MoveTo1');
    RegisterMethod(@TTeeCanvas.Pie, 'Pie');
    RegisterMethod(@TTeeCanvasRectangle_P, 'Rectangle');
    RegisterMethod(@TTeeCanvasRectangle1_P, 'Rectangle1');
    RegisterMethod(@TTeeCanvasRoundRect_P, 'RoundRect');
    RegisterMethod(@TTeeCanvasRoundRect1_P, 'RoundRect1');
    RegisterMethod(@TTeeCanvas.StretchDraw, 'StretchDraw');
    RegisterMethod(@TTeeCanvasTextOut_P, 'TextOut');
    RegisterMethod(@TTeeCanvasTextOut1_P, 'TextOut1');
    RegisterMethod(@TTeeCanvasTextOut2_P, 'TextOut2');
    RegisterVirtualMethod(@TTeeCanvasTextWidth_P, 'TextWidth');
    RegisterVirtualMethod(@TTeeCanvasTextHeight_P, 'TextHeight');
    RegisterVirtualMethod(@TTeeCanvasTextWidth1_P, 'TextWidth1');
    RegisterVirtualMethod(@TTeeCanvasTextHeight1_P, 'TextHeight1');
    RegisterMethod(@TTeeCanvasClipRectangle_P, 'ClipRectangle');
    RegisterVirtualMethod(@TTeeCanvasClipRectangle1_P, 'ClipRectangle1');
    RegisterVirtualMethod(@TTeeCanvas.ClipEllipse, 'ClipEllipse');
    RegisterVirtualMethod(@TTeeCanvas.ClipPolygon, 'ClipPolygon');
    RegisterMethod(@TTeeCanvas.ConvexHull, 'ConvexHull');
    RegisterVirtualMethod(@TTeeCanvas.DoHorizLine, 'DoHorizLine');
    RegisterMethod(@TTeeCanvas.DoRectangle, 'DoRectangle');
    RegisterVirtualMethod(@TTeeCanvas.DoVertLine, 'DoVertLine');
    RegisterMethod(@TTeeCanvas.EraseBackground, 'EraseBackground');
    RegisterMethod(@TTeeCanvas.GradientFill, 'GradientFill');
    RegisterMethod(@TTeeCanvas.Invalidate, 'Invalidate');
    RegisterVirtualMethod(@TTeeCanvasLine_P, 'Line');
    RegisterMethod(@TTeeCanvasLine1_P, 'Line1');
    RegisterMethod(@TTeeCanvas.Polyline, 'Polyline');
    RegisterMethod(@TTeeCanvas.Polygon, 'Polygon');
    RegisterVirtualMethod(@TTeeCanvas.PolygonGradient, 'PolygonGradient');
    RegisterMethod(@TTeeCanvas.RotateLabel, 'RotateLabel');
    RegisterPropertyHelper(@TTeeCanvasSupportsFullRotation_R,nil,'SupportsFullRotation');
    RegisterMethod(@TTeeCanvas.UnClipRectangle, 'UnClipRectangle');
    RegisterPropertyHelper(@TTeeCanvasBackColor_R,@TTeeCanvasBackColor_W,'BackColor');
    RegisterPropertyHelper(@TTeeCanvasBackMode_R,@TTeeCanvasBackMode_W,'BackMode');
    RegisterPropertyHelper(@TTeeCanvasBounds_R,nil,'Bounds');
    RegisterPropertyHelper(@TTeeCanvasBrush_R,nil,'Brush');
    RegisterPropertyHelper(@TTeeCanvasFont_R,nil,'Font');
    RegisterPropertyHelper(@TTeeCanvasFontHeight_R,nil,'FontHeight');
    RegisterPropertyHelper(@TTeeCanvasHandle_R,nil,'Handle');
    RegisterPropertyHelper(@TTeeCanvasMetafiling_R,@TTeeCanvasMetafiling_W,'Metafiling');
    RegisterPropertyHelper(@TTeeCanvasMonochrome_R,@TTeeCanvasMonochrome_W,'Monochrome');
    RegisterPropertyHelper(@TTeeCanvasPen_R,nil,'Pen');
    RegisterPropertyHelper(@TTeeCanvasPixels_R,@TTeeCanvasPixels_W,'Pixels');
    RegisterPropertyHelper(@TTeeCanvasReferenceCanvas_R,@TTeeCanvasReferenceCanvas_W,'ReferenceCanvas');
    RegisterPropertyHelper(@TTeeCanvasTextAlign_R,@TTeeCanvasTextAlign_W,'TextAlign');
    RegisterPropertyHelper(@TTeeCanvasUseBuffer_R,@TTeeCanvasUseBuffer_W,'UseBuffer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeFont(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeFont) do begin
    RegisterConstructor(@TTeeFont.Create, 'Create');
    RegisterMethod(@TTeeFont.Assign, 'Assign');
       RegisterMethod(@TTeeFont.Destroy, 'Free');
     RegisterPropertyHelper(@TTeeFontGradient_R,@TTeeFontGradient_W,'Gradient');
    RegisterPropertyHelper(@TTeeFontInterCharSize_R,@TTeeFontInterCharSize_W,'InterCharSize');
    RegisterPropertyHelper(@TTeeFontOutLine_R,@TTeeFontOutLine_W,'OutLine');
    RegisterPropertyHelper(@TTeeFontPicture_R,@TTeeFontPicture_W,'Picture');
    RegisterPropertyHelper(@TTeeFontShadow_R,@TTeeFontShadow_W,'Shadow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeFontGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeFontGradient) do
  begin
    RegisterPropertyHelper(@TTeeFontGradientOutline_R,@TTeeFontGradientOutline_W,'Outline');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeGradient) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSubGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSubGradient) do
  begin
    RegisterPropertyHelper(@TSubGradientTransparency_R,@TSubGradientTransparency_W,'Transparency');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomTeeGradient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomTeeGradient) do begin
    RegisterConstructor(@TCustomTeeGradient.Create, 'Create');
    RegisterMethod(@TCustomTeeGradient.Destroy, 'Free');
    RegisterMethod(@TCustomTeeGradient.Assign, 'Assign');
    RegisterMethod(@TCustomTeeGradientDraw3_P, 'Draw3');
    RegisterMethod(@TCustomTeeGradientDraw4_P, 'Draw4');
    RegisterMethod(@TCustomTeeGradientDraw5_P, 'Draw5');
    RegisterMethod(@TCustomTeeGradientDraw6_P, 'Draw6');
    RegisterPropertyHelper(@TCustomTeeGradientChanged_R,@TCustomTeeGradientChanged_W,'Changed');
    RegisterMethod(@TCustomTeeGradient.UseMiddleColor, 'UseMiddleColor');
    RegisterPropertyHelper(@TCustomTeeGradientAngle_R,@TCustomTeeGradientAngle_W,'Angle');
    RegisterPropertyHelper(@TCustomTeeGradientBalance_R,@TCustomTeeGradientBalance_W,'Balance');
    RegisterPropertyHelper(@TCustomTeeGradientDirection_R,@TCustomTeeGradientDirection_W,'Direction');
    RegisterPropertyHelper(@TCustomTeeGradientEndColor_R,@TCustomTeeGradientEndColor_W,'EndColor');
    RegisterPropertyHelper(@TCustomTeeGradientMidColor_R,@TCustomTeeGradientMidColor_W,'MidColor');
    RegisterPropertyHelper(@TCustomTeeGradientRadialX_R,@TCustomTeeGradientRadialX_W,'RadialX');
    RegisterPropertyHelper(@TCustomTeeGradientRadialY_R,@TCustomTeeGradientRadialY_W,'RadialY');
    RegisterPropertyHelper(@TCustomTeeGradientStartColor_R,@TCustomTeeGradientStartColor_W,'StartColor');
    RegisterPropertyHelper(@TCustomTeeGradientSubGradient_R,@TCustomTeeGradientSubGradient_W,'SubGradient');
    RegisterPropertyHelper(@TCustomTeeGradientVisible_R,@TCustomTeeGradientVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeShadow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeShadow) do
  begin
    RegisterConstructor(@TTeeShadow.Create, 'Create');
    RegisterMethod(@TTeeShadow.Assign, 'Assign');
    RegisterMethod(@TTeeShadowDraw_P, 'Draw');
    RegisterMethod(@TTeeShadowDraw1_P, 'Draw1');
    RegisterMethod(@TTeeShadowDraw2_P, 'Draw2');
    RegisterMethod(@TTeeShadow.DrawEllipse, 'DrawEllipse');
    RegisterPropertyHelper(@TTeeShadowSize_R,@TTeeShadowSize_W,'Size');
    RegisterPropertyHelper(@TTeeShadowClip_R,@TTeeShadowClip_W,'Clip');
    RegisterPropertyHelper(@TTeeShadowColor_R,@TTeeShadowColor_W,'Color');
    RegisterPropertyHelper(@TTeeShadowHorizSize_R,@TTeeShadowHorizSize_W,'HorizSize');
    RegisterPropertyHelper(@TTeeShadowSmooth_R,@TTeeShadowSmooth_W,'Smooth');
    RegisterPropertyHelper(@TTeeShadowSmoothBlur_R,@TTeeShadowSmoothBlur_W,'SmoothBlur');
    RegisterPropertyHelper(@TTeeShadowTransparency_R,@TTeeShadowTransparency_W,'Transparency');
    RegisterPropertyHelper(@TTeeShadowVertSize_R,@TTeeShadowVertSize_W,'VertSize');
    RegisterPropertyHelper(@TTeeShadowVisible_R,@TTeeShadowVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeBlend(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeBlend) do begin
    RegisterConstructor(@TTeeBlend.Create, 'Create');
   RegisterMethod(@TTeeBlend.Destroy, 'Free');
    RegisterMethod(@TTeeBlend.DoBlend, 'DoBlend');
    RegisterMethod(@TTeeBlend.SetRectangle, 'SetRectangle');
    RegisterPropertyHelper(@TTeeBlendBitmap_R,nil,'Bitmap');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TView3DOptions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TView3DOptions) do
  begin
    RegisterConstructor(@TView3DOptions.Create, 'Create');
    RegisterMethod(@TView3DOptions.Repaint, 'Repaint');
    RegisterMethod(@TView3DOptions.Assign, 'Assign');
    RegisterPropertyHelper(@TView3DOptionsParent_R,@TView3DOptionsParent_W,'Parent');
    RegisterPropertyHelper(@TView3DOptionsElevationFloat_R,@TView3DOptionsElevationFloat_W,'ElevationFloat');
    RegisterPropertyHelper(@TView3DOptionsRotationFloat_R,@TView3DOptionsRotationFloat_W,'RotationFloat');
    RegisterPropertyHelper(@TView3DOptionsZoomFloat_R,@TView3DOptionsZoomFloat_W,'ZoomFloat');
    RegisterPropertyHelper(@TView3DOptionsOnChangedZoom_R,@TView3DOptionsOnChangedZoom_W,'OnChangedZoom');
    RegisterPropertyHelper(@TView3DOptionsOnScrolled_R,@TView3DOptionsOnScrolled_W,'OnScrolled');
    RegisterPropertyHelper(@TView3DOptionsElevation_R,@TView3DOptionsElevation_W,'Elevation');
    RegisterPropertyHelper(@TView3DOptionsFontZoom_R,@TView3DOptionsFontZoom_W,'FontZoom');
    RegisterPropertyHelper(@TView3DOptionsHorizOffset_R,@TView3DOptionsHorizOffset_W,'HorizOffset');
    RegisterPropertyHelper(@TView3DOptionsOrthoAngle_R,@TView3DOptionsOrthoAngle_W,'OrthoAngle');
    RegisterPropertyHelper(@TView3DOptionsOrthogonal_R,@TView3DOptionsOrthogonal_W,'Orthogonal');
    RegisterPropertyHelper(@TView3DOptionsPerspective_R,@TView3DOptionsPerspective_W,'Perspective');
    RegisterPropertyHelper(@TView3DOptionsRotation_R,@TView3DOptionsRotation_W,'Rotation');
    RegisterPropertyHelper(@TView3DOptionsTilt_R,@TView3DOptionsTilt_W,'Tilt');
    RegisterPropertyHelper(@TView3DOptionsVertOffset_R,@TView3DOptionsVertOffset_W,'VertOffset');
    RegisterPropertyHelper(@TView3DOptionsZoom_R,@TView3DOptionsZoom_W,'Zoom');
    RegisterPropertyHelper(@TView3DOptionsZoomText_R,@TView3DOptionsZoomText_W,'ZoomText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartBrush(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartBrush) do
  begin
    RegisterConstructor(@TChartBrush.Create, 'Create');
     RegisterMethod(@TChartBrush.Destroy, 'Free');
    RegisterMethod(@TChartBrush.Assign, 'Assign');
    RegisterMethod(@TChartBrush.Clear, 'Clear');
    RegisterPropertyHelper(@TChartBrushBackColor_R,@TChartBrushBackColor_W,'BackColor');
    RegisterPropertyHelper(@TChartBrushImage_R,@TChartBrushImage_W,'Image');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWhitePen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWhitePen) do
  begin
    RegisterConstructor(@TWhitePen.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDarkGrayPen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDarkGrayPen) do
  begin
    RegisterConstructor(@TDarkGrayPen.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDottedGrayPen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDottedGrayPen) do
  begin
    RegisterConstructor(@TDottedGrayPen.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartHiddenPen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartHiddenPen) do
  begin
    RegisterConstructor(@TChartHiddenPen.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TChartPen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TChartPen) do
  begin
    RegisterConstructor(@TChartPen.Create, 'Create');
    RegisterMethod(@TChartPen.Assign, 'Assign');
    RegisterMethod(@TChartPen.Hide, 'Hide');
    RegisterMethod(@TChartPen.Show, 'Show');
    RegisterPropertyHelper(@TChartPenEndStyle_R,@TChartPenEndStyle_W,'EndStyle');
    RegisterPropertyHelper(@TChartPenSmallDots_R,@TChartPenSmallDots_W,'SmallDots');
    RegisterPropertyHelper(@TChartPenSmallSpace_R,@TChartPenSmallSpace_W,'SmallSpace');
    RegisterPropertyHelper(@TChartPenVisible_R,@TChartPenVisible_W,'Visible');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeePicture(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeePicture) do begin
    RegisterMethod(@TTeePicture.Assign, 'Assign');
    RegisterMethod(@TTeePicture.Destroy, 'Free');
    RegisterMethod(@TTeePicture.Filtered, 'Filtered');
    RegisterMethod(@TTeePicture.Repaint, 'Repaint');
    RegisterMethod(@TTeePicture.ReadFilters, 'ReadFilters');
    RegisterMethod(@TTeePicture.WriteFilters, 'WriteFilters');
    RegisterPropertyHelper(@TTeePictureFilters_R,@TTeePictureFilters_W,'Filters');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlurFilter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlurFilter) do
  begin
    RegisterConstructor(@TBlurFilter.Create, 'Create');
    RegisterMethod(@TBlurFilter.Apply, 'Apply');
    RegisterMethod(@TBlurFilter.Description, 'Description');
    RegisterMethod(@TBlurFilter.CreateEditor, 'CreateEditor');
    RegisterPropertyHelper(@TBlurFilterAmount_R,@TBlurFilterAmount_W,'Amount');
    RegisterPropertyHelper(@TBlurFilterSteps_R,@TBlurFilterSteps_W,'Steps');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TConvolveFilter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TConvolveFilter) do begin
  RegisterConstructor(@TConvolveFilter.Create, 'Create');
    RegisterMethod(@TConvolveFilter.Apply, 'Apply');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFilterItems(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFilterItems) do
  begin
    RegisterMethod(@TFilterItems.Add, 'Add');
    RegisterMethod(@TFilterItems.ApplyTo, 'ApplyTo');
    RegisterMethod(@TFilterItems.Assign, 'Assign');
    RegisterPropertyHelper(@TFilterItemsItem_R,@TFilterItemsItem_W,'Item');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTeeFilter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTeeFilter) do begin
    RegisterPropertyHelper(@TTeeFilterLines_R,@TTeeFilterLines_W,'Lines');
    RegisterConstructor(@TTeeFilter.Create, 'Create');
       RegisterMethod(@TTeeFilter.Destroy, 'Free');
    RegisterMethod(@TTeeFilter.Assign, 'Assign');
    RegisterMethod(@TTeeFilter.ApplyTo, 'ApplyTo');
    RegisterMethod(@TTeeFilterApply_P, 'Apply');
    RegisterVirtualMethod(@TTeeFilterApply1_P, 'Apply1');
    RegisterMethod(@TTeeFilter.Assign, 'Assign');
    RegisterVirtualMethod(@TTeeFilter.CreateEditor, 'CreateEditor');
    RegisterVirtualMethod(@TTeeFilter.Description, 'Description');
    RegisterPropertyHelper(@TTeeFilterEnabled_R,@TTeeFilterEnabled_W,'Enabled');
    RegisterPropertyHelper(@TTeeFilterRegion_R,@TTeeFilterRegion_W,'Region');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TFilterRegion(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TFilterRegion) do
  begin
    RegisterMethod(@TFilterRegion.Assign, 'Assign');
    RegisterPropertyHelper(@TFilterRegionRectangle_R,@TFilterRegionRectangle_W,'Rectangle');
    RegisterPropertyHelper(@TFilterRegionHeight_R,@TFilterRegionHeight_W,'Height');
    RegisterPropertyHelper(@TFilterRegionLeft_R,@TFilterRegionLeft_W,'Left');
    RegisterPropertyHelper(@TFilterRegionTop_R,@TFilterRegionTop_W,'Top');
    RegisterPropertyHelper(@TFilterRegionWidth_R,@TFilterRegionWidth_W,'Width');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TeCanvas(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TFilterRegion(CL);
  RIRegister_TTeeFilter(CL);
  RIRegister_TFilterItems(CL);
  RIRegister_TConvolveFilter(CL);
  RIRegister_TBlurFilter(CL);
  RIRegister_TTeePicture(CL);
  RIRegister_TChartPen(CL);
  RIRegister_TChartHiddenPen(CL);
  RIRegister_TDottedGrayPen(CL);
  RIRegister_TDarkGrayPen(CL);
  RIRegister_TWhitePen(CL);
  RIRegister_TChartBrush(CL);
  RIRegister_TView3DOptions(CL);
  with CL.Add(TTeeCanvas) do
  RIRegister_TTeeBlend(CL);
  with CL.Add(TCanvas3D) do
  RIRegister_TTeeShadow(CL);
  with CL.Add(TSubGradient) do
  RIRegister_TCustomTeeGradient(CL);
  RIRegister_TSubGradient(CL);
  RIRegister_TTeeGradient(CL);
  RIRegister_TTeeFontGradient(CL);
  RIRegister_TTeeFont(CL);
  RIRegister_TTeeCanvas(CL);
  RIRegister_TFloatXYZ(CL);
  RIRegister_TCanvas3D(CL);
  RIRegister_TTeeCanvas3D(CL);
  RIRegister_TTeeButton(CL);
  RIRegister_TButtonColor(CL);
  RIRegister_TComboFlat(CL);

end;

 
 
{ TPSImport_TeCanvas }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TeCanvas.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TeCanvas(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TeCanvas.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TeCanvas_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
