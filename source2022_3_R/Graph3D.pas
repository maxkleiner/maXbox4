{ Written 1999 by Hannes Breuer (Hannes@BreuerOnline.com),

  Version 1.00 : 2.11.1999 (November the second)
          First release version, never mind the private version's history...

  Version 1.01 : 17.1.2000
          Kicked out the parts using TLargeInteger, as Delphi 4 and up seem
          to have shifted the definition away from Windows.pas.
          Changed the comments such that the F1help-compiler can compile a
          HLP-file for it. Added that helpfile, of course.
          See www.geocities.com/SiliconValley/Vista/5524/f1help.html for the
          latest version of this really excellent tool.

  NB: The compiler-option 'Range-checking' must be OFF.

  Licensing: Use however you want.
  Please tell me where you use it (location and use of program).
  If you fix bugs or add nifty features, please let me know.
  If you earn money with it, please mention me.

  I WILL NOT ASSUME ANY RESPONSIBILITY WHATSOEVER FOR ANY DAMAGES RESULTING
  FROM THE USE/MISUSE OF THIS UNIT. Use at your own risk.
}
unit Graph3D;

interface
uses Windows, Controls, Classes, Graphics, Messages;

const
//No of isodoses TGraph3D can handle.
//As yet this no is fixed, maybe it gets set dynamically in the future.
MaxNoOfIsodoses = 10;

type
//Basic type to define a point in 3D.
//Real values in real-life units
  T3DPoint = record
    X, Y, Z : Single;
  end;
//Just a pointer to T3DPoint
  P3DPoint = ^T3DPoint;

//This type is needed to allow setting the array's dimensions at runtime.
//NB: The compiler-option 'Range-checking' must be OFF.
  TSingleArray = Array[0..0] of Single;
//Just a pointer to TSingleArray
  PSingleArray = ^TSingleArray;

{The TGraph3D component can be configured to let the user pan/zoom/rotate by just
dragging the mouse in the component's canvas.}
  TMouseControl = (mcNone, mcMove, mcRotate, mcZoom);

//Basic structure for defining isodoses for the TGraph3D.
//The field 'Active' is for future expansions, not used yet
  TIsodoseData = record
    Percentage : Single;
    Color      : TColor;
    Active     : Boolean;
  end;
//Just a pointer to TIsodoseData
  PIsodoseData = ^TIsodoseData;

//Possible values for TGraph3D.WaterLevel
  TWaterlevel = (wlNone, wlAbove, wlBelow);

//Basic class for one line of a 2D-array of values.
//Defined in this way to allow both dimensions to be set at runtime.
TGraphLine = Class(TObject)
   Private
     fNoOfValues : LongInt;
     fValues     : PSingleArray; //assumption: equally spaced
     procedure SetVal(Index: Integer; V:Single);
     function GetVal(Index: Integer) : Single;
     function GetX(Index: Integer) : Single;
     function GetY(Index: Integer) : Single;
   Public
     //Each line can start and stop anywhere on the XY-plane.
     //The X/Y-values are interpolated linearly between StartPoint and StopPoint.
     //Z-coord gets ignored here.
     StartPoint : T3DPoint;
     //Each line can start and stop anywhere on the XY-plane.
     //The X/Y-values are interpolated linearly between StartPoint and StopPoint.
     //V-coord gets ignored here.
     StopPoint : T3DPoint;
     //Read-only property to see how many values are are in this line.
     //Gets set in Create
     property NoOfValues : LongInt read fNoOfValues;
     //Reads/writes the Z values of the points in the line.
     //See also: X,Y
     {example:
      var Line : TGraphLine;
          i : LongInt;
      begin
        Line := TGraphLine.Create(10);
        //init values:
        For i := 0 to 9 do
          Line[i] := Sqr(i-5);
        //set direction of this line: (here in X-dir at Y=12.1)
        Line.StartPoint := Point3D(0, 12.1, 0); //Z anyway gets ignored
        Line.StopPoint := Point3D(100, 12.1, 0);
        //now display all values as 3D-points:
        For i := 0 to Line.NoOfValues-1 do
          ShowMessage('x,y,z: '+FormatFloat('0.0',Line.X[i])+
                           ', '+FormatFloat('0.0', Line.Y[i]+
                                ForamtFloat('0.0', Line[i]));
      end;
     }
     property Vals[Index: Integer]: Single read GetVal write SetVal; default;
     //Reads/writes the X-values of the points in the line
     //See also: Y, Vals (which contains an example of how to use these properties)
     property X[Index: Integer]: Single read GetX;
     //Reads/writes the Y-values of the points in the line
     //See also: X, Vals (which contains an example of how to use these properties)
     property Y[Index: Integer]: Single read GetY;
     //Standard constructor for a TGraphLine.
     //Once and for all sets the NoOfValues
     constructor Create(Nvals : LongInt);
     //Frees the line and all points in it
     destructor Destroy; override;
end;

type
{A component for displaying arrays of values as a net.

Summary of the functionality:

Supports hidden lines, 10 isodoses-colours, rotate/pan/zoom by mouse. All
colours, frame, caption, font, etc...  customizable. Can make a bitmap image
of itself, which will also replace the background-colour with white (if you want),
useful for printouts. While zooming and rotating, the picture gets centered such
that the average value of all datapoints appears in the middle of the canvas.
}
TGraph3D = Class(TCustomControl)
    Private
      //events:
      FAfterDraw,
      fOnScroll,
      fOnStopScrolling : TNotifyEvent;
      //general stuff:
      FLineDim : LongInt;       //no. of values per line
      FLines : TList;           //casts to TGraphLine
      FTrapezes : TList;        //casts to PTrapezeInfo
      //stuff depending on plot-data:
      Favgs : T3DPoint;      //avg. values, normalized to 100
      fDataChanged,
      fDidInit : Boolean;
      //stuff depending on viewangle/offset/size:
      fTheta, fPhi : Single;     //view-angles in rad
      FOffset : TPoint;          //in pixels
      fCosTheta, fSinTheta,      //Cos & Sin of view-angles
      fCosPhi, fSinPhi : Single;
      fXscale,                   //range vs. available space
      fYscale : Single;
      fViewPercentage : ShortInt;    //allow hiding some of the polygons
      FViewPoint : T3DPoint;  //corner of cube closest to viewer
      fZoomChanged,              //needed to keep track of what needs updating
      fOffsetChanged,
      fAnglesChanged,
      fHiddenLinesChanged,
      fLabelsChanged,
      fDrawAxesDataChanged,
      fRangeChanged,
      fWaterLevelChanged,
      fColorsChanged : Boolean;
      //stuff for speed/convenience in drawing:
      fPlotOrigin : TPoint; //depends on FOffset & Favgs
      fMouseActionData : record
                       fMouseControl : TMouseControl;
                       OldMousePos : TPoint;    //set on MouseMove
                       ExecuteAction : Boolean; //set on LMBdown, LMBup and MouseLeave
                       DidClear: Boolean;
                       end;
      fScrollData : record
                  AmScrolling,            //True if scrolling is activated        //set only in ScrollLines and StopScrolling
                  ScrollPaused : Boolean; //needed when rotating/panning/zooming
                  Position     : LongInt;
                  Speed        : Byte;    //0 = fastest
                  Incremental  : Boolean;
                  end;
      //view-options:
      FCaption, fOldCaption,
      FLabelX,
      FLabelY,
      FLabelZ   : String;     //axes-labels
      fAxesColor,             //axes-color
      fDataColor: TColor;     //datacolor
      fShowFrame,
      fDrawAxes,
      fDrawHiddenLines : Boolean;
      fZoomX,
      fZoomY : Single; //fraction of Width/Height to use for X/Y-range
      fFirstLine,
      fLastLine : LongInt; //allow drawing only some of the lines
      fUseColors : Boolean;
      fIsodoses : Array[0..MaxNoOfIsodoses-1] of TIsodoseData;
      fWaterlevelType : TWaterLevel;
      fWaterLevelPercent  : Single; //in percent
      //funcs for properties:
      function GetNoOfLines : LongInt;
      procedure SetTheta(v : LongInt); //converts given degrees to rad and calculates Cos/Sin
      function GetTheta : LongInt;     //converts internal rad to degrees
      procedure SetPhi(v : LongInt);   //dito
      function GetPhi : LongInt;       //dito
      procedure SetHiddenLines(b : Boolean);
      procedure SetDrawAxes(b : Boolean);
      procedure SetOffset(p : TPoint);
      procedure SetDataColor(c : TColor);
      procedure SetAxesColor(c : TColor);
      procedure SetLabelX(s : String);
      procedure SetLabelY(s : String);
      procedure SetLabelZ(s : String);
      procedure SetCaption(s : String);
      procedure SetZoomX(z : Single);
      procedure SetZoomY(z : Single);
      procedure SetViewPercentage(i : ShortInt);
      procedure SetFirstLine(i : Longint);
      procedure SetLastLine(i : Longint);
      procedure SetUseColors(b : Boolean);
      Procedure SetFont(F : TFont);
      Function GetFont : TFont;
      Procedure SetShowFrame(b : Boolean);
      //internals for projection:
      Procedure ClearLines;   //frees data (all TGraphlines, not the TList itself)
      Procedure ClearTrapezes;//dito for fTrapezes
      procedure BuildTrapezes;     //analyzes data and creates trapezes
      procedure CalcScales;   //according to size, extremes and zoomfactor
      function Map(Pt : T3DPoint) : TPoint; //convert to pixel-position
      procedure SetViewpoint;     //according to angles
      procedure OrderTrapezes;    //according to distance from viewpoint
      procedure MapTrapezes;      //maps their 3D-points to TPoints on canvas
      procedure SetTrapezeColors; //just that
      //Mouse-actions:
      function MouseIsInMyClientArea : Boolean; //checks MousePos
      procedure SetMouseControl(mc : TMouseControl); //also a property
      procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN; //starts MouseAction
      procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;       //redraws axes if MouseAction
      procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;       //stops MouseAction
      procedure WMMouseLeave(var Message: TWMLButtonUp); message 45076; //mouse leaves my client-area, drop all action
    Protected
      procedure WMSize(var Message: TWMSize); message WM_SIZE; //must be in protected part
      procedure InitDraw;
      Procedure ClearCanvas(CV : TCanvas);
      procedure DrawXaxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
      procedure DrawYaxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
      procedure DrawZaxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
      procedure DrawXFarAxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
      procedure DrawYFarAxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
      procedure DrawAxesNow(DrawThem : Boolean; CV : TCanvas); //draws the axes, if not DrawThem: overwrite with BackColor
      Procedure DrawFrame(CV : TCanvas);
      Procedure DeleteFrame(CV : TCanvas);
      Procedure DrawCaption(CV : TCanvas);
      Procedure DeleteCaption(CV : TCanvas);
      Procedure DrawTrapezes(CV : TCanvas);
      Procedure Draw(CV : TCanvas; CallEvent : Boolean);
      Procedure Paint; override;
(*      procedure WndProc(var Message: TMessage); override; needed only for spying *)
    Public
      //Returns the Percentage-val of the i'th isodose.
      //See also: GetIsodoseColor, SetIsodose, TIsodoseData
      function GetIsodoseValue(i : ShortInt) : Single;
      //Returns the Colour of the i'th isodose.
      //See also: GetIsodoseValue, SetIsodose, TIsodoseData
      function GetIsodoseColor(i : ShortInt) : TColor;
      //Use this to set the Ind'th Isodose-properties
      //See also: GetIsodoseValue, GetIsodoseColor, TIsodoseData
      Procedure SetIsodose(Ind : Byte; Percent : Single; col : TColor);
      //Returns the no of TGraphLine s in the Graph
      //See also: AddLine
      property NoOfLines : LongInt read GetNoOfLines;
      //This is the only way to add more datapoints to the Graph.
      //See also: NoOfLines
      {example:
      var MyGraph : TGraph3D
          NewLine : TGraphLine;
          i,j : LongInt;
      begin
        MyGraph := TGraph3D.Create(Panel1);
        //create 5 lines of 10 points each and add them to the graph:
        For i := 1 to 5 do begin
          NewLine := TGraphLine.Create(10);
          NewLine.StartPoint := Point3D(0, i*2, 0);
          NewLine.StopPoint  := Point3D(9, i*2, 0);
          For j := 0 to 9 do //fill line
            NewLine[j] := Sqr(i-2) + Sqr(j-5);
          MyGraph.AddLine(NewLine);
        end;
      }
      Procedure AddLine(L : TGraphLine);
      //Reads the current Waterleveltype
      //See also: TWaterLevel, SetWaterLevel
      property WaterlevelType : TWaterLevel read fWaterlevelType;
      //Reads the current type of Waterlevel
      //See also: WaterLevel, SetWaterLevel
      property Waterlevel     : Single read fWaterlevelPercent;
      //Set the current type of Waterlevel
      //See also: WaterLevelType, WaterLevel
      procedure SetWaterLevel(Kind : TWaterLevel; Percent : Single);
      //Use this to check if the graph is busy scrolling through the lines.
      //See also: ScrollLines, StopScrolling, ScrollSpeed, IncrementaScroll, FirstLine, LastLine
      property isScrolling : Boolean read fScrollData.AmScrolling;
      //Scrolls through the lines and shows them one-by-one.
      //Stops when mouse leaves client-area and while the PopupMenu is up.
      //Event OnScroll is called each time ScrollIndex changes.
      //See also: isScrolling, StopScrollling, ScrollSpeed, IncrementaScroll, FirstLine, LastLine
      Procedure ScrollLines;
      //Stops the scrolling and redraws the full graph.
      //Triggers the event onStopScrolling.
      //See also: isScrolling, ScrollLines, ScrollSpeed, IncrementaScroll, FirstLine, LastLine
      Procedure StopScrolling;
      //Fills the Canvas in BackColor. Lines do not get drawn.
      Procedure ClearPicture;
      //Clears everything, frees mem of lines and trapezes
      Procedure Clear;
      //Resets all Isodose-Colours to redshades according to their percentages
      //See also: SetIsodose, GetIsodoseValue, GetIsodoseColor, TIsodoseData
      Procedure ResetColors;
      //Shifts FPlotOrigin such that avg-value of plot is at the centre of the canvas
      Procedure CenterPlot;
      //Copies current Canvas to a bitmap.
      //Background will be white regardless of Color, if inWhite=True
      Function AsBitmap(inWhite : Boolean) : TBitmap;
      //Standard constructor
      Constructor Create(AOwner: TComponent); override;
      //Standard Destructor, calls Clear and then frees the component
      Destructor Destroy; override;
    Published
      //Determines whether a frame is drawn around the graph
      property ShowFrame : Boolean read fShowFrame write SetShowFrame default True;
      //Colour of lines if UseColors = False.
      //Gets ignored if we use the isodose-colours.
      //See also GetIsodoseColor, SetIsodose
      property DataColor : TColor read fDataColor write SetDataColor;
      //Determines whether we use the DataColor or the Isodose-colours for the lines
      property UseColors : Boolean read fUseColors write SetUseColors;
      //Colour of the axes.
      //See also: DrawAxes
      property AxesColor : TColor read fAxesColor write SetAxesColor;
      //Determines whether the axes get drawn.
      //See also: AxesColor
      property DrawAxes : Boolean read fDrawAxes write SetDrawAxes;
      //Label for the X-axis. Set to '' if you don't want it.
      //See also : Font
      property LabelX : String read fLabelX write SetLabelX;
      //Label for the Y-axis. Set to '' if you don't want it.
      //See also : Font
      property LabelY : String read fLabelY write SetLabelY;
      //Label for the Z-axis. Set to '' if you don't want it.
      //See also : Font
      property LabelZ : String read fLabelZ write SetLabelZ;
      //This caption gets drawn above the graph. Set to '' if you don't want it.
      //See also : Font
      property Caption : String read FCaption write SetCaption;
      //Viewpoint-rotation in the horizontal plane, in degrees.
      //You will not need this if you let the user rotate the graph with the mouse.
      //See also: Phi, MouseControl
      property Theta : LongInt read GetTheta write SetTheta;
      //Viewpoint-rotation in the vertical plane, in degrees.
      //You will not need this if you let the user rotate the graph with the mouse.
      //See also: Theta, MouseControl
      property Phi : LongInt read GetPhi write SetPhi;
      //Used to shift the graph within the canvas.
      //You will not need this if you let the user pan the graph with the mouse.
      //See also: MouseControl, CenterPlot
      property Offset : TPoint read FOffset write SetOffset;
      //Zoomfactor in the Canvas' horizontal direction. Valid: 0.1 .. 3
      //You will not need this if you let the user zoom the graph with the mouse.
      //See also: MouseControl
      property ZoomX : Single read fZoomX write SetZoomX;
      //Zoomfactor in the Canvas' vertical direction. Valid: 0.1 .. 3
      //You will not need this if you let the user zoom the graph with the mouse.
      //See also: MouseControl
      property ZoomY : Single read fZoomY write SetZoomY;
      //Determines how the plot reacts to Mouse-drags by the user.
      //Usage (that's really all you gotta do): MyGraph.MouseControl := mcRotate
      property MouseControl : TMouseControl read fMouseActionData.fMouseControl write SetMouseControl;
      //You can tell the graph to show only the xx furthest polygons.
      //Valid values: 1..100, 100 means 'show all'.
      //This allows the user to see otherwise hidden features in the graph-surface.
      //See also: FirstLine, LastLine
      property ViewPercentage : ShortInt read fViewPercentage write SetViewPercentage;
      //Used to temporarily hide some lines.
      //Graph will only show those lines inbetween FirstLine and LastLine.
      //Order of lines is determined by the sequence of the AddLine calls.
      //See also: ViewPercentage
      property FirstLine : LongInt read fFirstLine write SetFirstLine;
      //Used to temporarily hide some lines.
      //Graph will only show those lines inbetween FirstLine and LastLine.
      //Order of lines is determined by the sequence of the AddLine calls.
      //See also: ViewPercentage
      property LastLine  : LongInt read fLastLine  write SetLastLine;
      //You can set the speed at which Scrolling takes place.
      //This is a delay (Sleep(fScrollData.Speed)), so ScrollSpeed = 0 means: as fast as possible
      //See also: ScrollLines, StopScrolling
      property ScrollSpeed : Byte read fScrollData.Speed write fScrollData.Speed;
      //When scrolling, you can choose to show only one line at a time (False),
      //or all lines up the current line (True).
      //See also: ScrollLines, StopScrolling
      property IncrementalScroll : Boolean read fScrollData.Incremental write fScrollData.Incremental;
      //Line-number which scrolling-process is busy on
      property ScrollIndex : LongInt read fScrolldata.Position;
      //This event gets triggered when StopScrolling gets called
      property OnStopScrolling : TNotifyEvent read fOnStopScrolling write fOnStopScrolling;
      //This event gets triggered everytime the ScrollIndex changes during scrolling.
      //See also: ScrollLines
      property OnScroll : TNotifyEvent read fOnScroll write fOnScroll;
      //Determines whether hidden lines get shown or not
      property DrawHiddenLines : Boolean read fDrawHiddenLines write SetHiddenLines;
      //This event gets triggered everytime the graph got drawn
      property AfterDraw : TNotifyEvent read FAfterDraw write FAfterDraw;
      //Purely inherited property
      property Align;
      //This determines the backgroundcolour of the graph
      property Color;
      //This determines the font used for Caption, LabelX, LabelY, LabelZ
      property Font : TFont read GetFont write SetFont;
      //Purely inherited property
      property ParentColor;
      //Purely inherited property
      property ParentFont;
      //Purely inherited property
      property ParentShowHint;
      //Purely inherited property
      //This is a good place to link in a menu to steer the MouseControl property.
      property PopupMenu;
      //Purely inherited property.
      property ShowHint;
      //Purely inherited property
      property Visible;
      //Purely inherited event
      property OnClick;
      //Purely inherited event
      property OnDblClick;
      //Purely inherited event
      property OnDragDrop;
      //Purely inherited event
      property OnDragOver;
      //Purely inherited event
      property OnEndDrag;
end;

//A function to convert the three coords to a T3DPoint
Function Point3D(x,y,z : Single) : T3DPoint;

procedure Register;

implementation
uses SysUtils, Forms, Math;

const ToDeg = 57.296; //180/Pi
      ToRad = 0.017453; //Pi/180
      AxisLength = 1.1; //axes are 10% longer than necessary

{------------------------------------------------------------------------------}
Function Point3D(x,y,z : Single) : T3DPoint;
var p : T3DPoint;
Begin
  P.X := x;
  p.Y := y;
  p.Z := z;
  Result := p;
End;

{------------------------------------------------------------------------------}
Function SqrDistance(p1,p2 : T3DPoint) : Single;
Begin
  Result := Sqr(p1.X-p2.X) + Sqr(p1.Y-p2.Y);// + Sqr(p1.Z-p2.Z);
End;

{------------------------------------------------------------------------------
Procedure TGraph3D.WndProc(var Message: TMessage);
begin
  If (Message.msg = 45075) then StopScrolling;
  If (message.msg <> 512) and (message.msg <> 45066)
     then tellMe('message: '+IntToStr(Message.msg));
  inherited WndProc(Message);
end;                                                                           }


type{--------------------------------------------------------------------------}
TTrapezeInfo = record
    Vals : Array[0..3] of T3DPoint;  //real coords
    Pixs : Array[0..3] of TPoint;  //mapped positions
    LineNo : LongInt;
    DistanceToViewer : Double;
    IsEdge : Boolean;  //True for those forming the walls
    AVG : T3DPoint;    //average of real values
    Color : TColor;
end;
PTrapezeInfo = ^TTrapezeInfo;

{------------------------------------------------------------------------------}
constructor TGraphLine.Create(Nvals : LongInt);
begin
  If nVals < 2 then
    Raise Exception.Create('Cannot create a TGraphLine with '+IntToStr(Nvals)+' value(s)');
  inherited Create;
  fNoOfValues := Nvals;
  GetMem(fValues, fNoOfValues*SizeOf(Single));
  fNoOfValues := Nvals;
  StartPoint.X := 0;
  StartPoint.Y := 0;
  StartPoint.Z := 0;
  StopPoint.X := Nvals-1;
  StopPoint.Y := 0;
  StopPoint.Z := 0;
end;

{------------------------------------------------------------------------------}
destructor TGraphLine.Destroy;
Begin
  FreeMem(fValues, fNoOfValues*SizeOf(Single));
  inherited Destroy;
end;

{------------------------------------------------------------------------------}
function TGraphLine.GetVal(Index: Integer) : Single;
begin
  If (Index < 0) or (Index > fNoOfValues-1)
    then Raise Exception.Create('Index out of bounds: '+IntToStr(Index));
  Result := fValues^[Index];
end;

{------------------------------------------------------------------------------}
procedure TGraphLine.SetVal(Index: Integer; V:Single);
begin
  If (Index < 0) or (Index > fNoOfValues-1)
    then Raise Exception.Create('Index out of bounds: '+IntToStr(Index));
  fValues^[Index] := V;
end;

{------------------------------------------------------------------------------}
function TGraphLine.GetX(Index: Integer) : Single;
begin
  If (Index < 0) or (Index > fNoOfValues-1)
    then Raise Exception.Create('Index out of bounds: '+IntToStr(Index));
  Result := StartPoint.X + (StopPoint.X - StartPoint.X)*Index/(fNoOfValues-1);
end;

{------------------------------------------------------------------------------}
function TGraphLine.GetY(Index: Integer) : Single;
begin
  If (Index < 0) or (Index > fNoOfValues-1)
    then Raise Exception.Create('Index out of bounds: '+IntToStr(Index));
  Result := StartPoint.Y + (StopPoint.Y - StartPoint.Y)*Index/(fNoOfValues-1);
end;

{------------------------------------------------------------------------------}
Constructor TGraph3D.Create(AOwner: TComponent);
var i : Byte;
begin
  inherited;
  Width := 100;
  Height := 100;
  fLines    := TList.Create;
  fTrapezes := TList.Create;

  fOldCaption := '';
  fShowFrame     := True;
  fOnStopScrolling := nil;
  fAfterDraw       := nil;
  fOnScroll        := nil;
  //inits:
  fDataChanged   := True; //need to update
  fDidInit := False;
  //other stuff:
  fPlotOrigin.X := Width div 2;
  fPlotOrigin.Y := Height div 2;
  Favgs.X := 0;
  Favgs.Y := 0;
  Favgs.Z := 0;
  fLineDim := 50;
  fXscale := 0.5;
  fYscale := 0.5;
  //defaults:
  fUseColors := False;
  fDrawHiddenLines := True;
  fDrawAxes := True;
  fDataColor := clBlack;
  fAxesColor := clBlue;
  Theta   :=  60; //auto-converts to rad & sets Sin/Cos
  Phi     := 330; //
  Offset := Point(0,-Height div 10); //calls Set...
  FViewPoint.X := 1;
  FViewPoint.Y := 1;
  FViewPoint.Z := 1;
  fCaption := '';
  fLabelX := 'X';
  fLabelY := 'Y';
  fLabelZ := 'Val';
  fZoomX  := 0.55;
  fZoomY  := 0.55;
  fViewPercentage := 100;
  fFirstLine := -10;
  fLastLine  := -9;
  with fScrollData do begin
    AmScrolling  := False;
    ScrollPaused := False;
    Position     := 0;
    Speed        := 0; //fastest
    Incremental  := True;
  end;
  //Mouse.control:
  with fMouseActionData do begin
    MouseControl := mcNone;
    OldMousePos   := Point(0,0);
    ExecuteAction := False;
  end;
  //isodoses:
  For i := 0 to MaxNoOfIsodoses-1 do
   with fIsodoses[i] do begin
     Percentage := 70 + 30*i/MaxNoOfIsodoses;
     Color := RGB(Round((i+1)*(255 div MaxNoOfIsodoses)),0,0); //redshades
     Active := True;
   end;
   fIsodoses[MaxNoOfIsodoses-1].Color := clYellow; //overwrite max color
  fWaterlevelPercent := 95;
  fWaterlevelType    := wlNone;
end;

{------------------------------------------------------------------------------}
Destructor TGraph3D.Destroy;
begin
  If fScrollData.AmScrolling then StopScrolling;
  Clear;
  FLines.Free;
  FTrapezes.Free;
  inherited;
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.WMSize(var Message: TWMSize);
begin
  If fTrapezes.Count > 1 then begin
    CalcScales;
    CenterPlot;
  end;
  fZoomChanged  := True;
  inherited;
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.ClearPicture;
Begin
  ClearCanvas(Canvas);
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.SetMouseControl(mc : TMouseControl);
begin
  If mc = fMouseActionData.fMouseControl then Exit;
  fMouseActionData.fMouseControl := mc;
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.WMLButtonDown(var Message: TWMLButtonDown);
begin
  If csDesigning in ComponentState then Exit;
  If fMouseActionData.fMouseControl = mcNone then Exit;
  with fMouseActionData do begin
    OldMousePos := Point(Message.Xpos, Message.Ypos);
    ExecuteAction := True;
    DidClear := False;
  end;
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.WMMouseMove(var Message: TWMMouseMove);
var DeltaX, DeltaY : LongInt; //how far did the mouse move?
    x,y : Single;             //temp vars
begin
  If csDesigning in ComponentState then Exit;
  If fMouseActionData.fMouseControl = mcNone then Exit;
  If not fMouseActionData.ExecuteAction then Exit;
  fScrollData.ScrollPaused := True;
  with fMouseActionData do begin
    DeltaX := Message.Xpos - OldMousePos.X;
    DeltaY := Message.Ypos - OldMousePos.Y;
    OldMousePos := Point(Message.Xpos, Message.Ypos);
  end;
  If not fMouseActionData.DidClear then begin
    ClearCanvas(Canvas);
    fMouseActionData.DidClear := True;
  end else DrawAxesNow(False, Canvas); //delete them
  case fMouseActionData.fMouseControl of
      mcMove : begin
                 x := Offset.X;
                 y := Offset.Y;
                 Offset := Point(Round(x)+DeltaX, Round(y)+DeltaY);
               end;
      mcRotate : begin
                 x := Theta;
                 y := Phi;
                 Theta := Round(x - DeltaX*180/Width);
                 Phi   := Round(y + DeltaY*180/Height);
                 CenterPlot;
                 end;
      mcZoom : begin
                 x := fZoomX;
                 y := fZoomY;
                 ZoomX := x + DeltaX/Width;
                 ZoomY := y - DeltaY/Height; //Y-axis is inverted
                 CalcScales;
                 CenterPlot;
               end;
  end; //of case
  DrawAxesNow(True, Canvas); //new position
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.WMLButtonUp(var Message: TWMLButtonUp);
begin
  If csDesigning in ComponentState then Exit;
  If fMouseActionData.fMouseControl = mcNone then Exit;
  If not fMouseActionData.ExecuteAction then Exit;
  fMouseActionData.ExecuteAction := False;
  fScrollData.ScrollPaused := False;
  If fScrollData.AmScrolling
    then ScrollLines
    else Draw(Canvas, True);
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.WMMouseLeave(var Message: TWMLButtonUp);
begin //NB: does not get called when scrolling!
  WMLButtonUp(Message); //does all the checking for me
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.ResetColors;
var i : LongInt;
begin
  For i := 0 to MaxNoOfIsodoses-1 do
   fIsodoses[i].Color := RGB(Round(50+2*fIsodoses[i].Percentage),0,0); //redshades
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.ClearLines;
var i : LongInt;
begin
  For i := 0 to FLines.Count-1 do begin
    TGraphLine(FLines[i]).Free;
    FLines[i] := nil;
  end;
  FLines.Pack;
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.ClearTrapezes;
var i : LongInt;
begin
  For i := 0 to FTrapezes.Count-1 do begin
    Dispose(FTrapezes[i]);
    FTrapezes[i] := nil;
  end;
  FTrapezes.Pack;
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.ClearCanvas(CV : TCanvas);
begin
  with CV do begin
    Pen.Color   := Self.Color;
    Pen.Style   := psSolid;
    Brush.Style := bsSolid;
    Brush.Color := Self.Color;
    FillRect(ClientRect);
  end;
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.Clear;
begin
  ClearLines;
  ClearTrapezes;
end;

{------------------------------------------------------------------------------}
function TGraph3D.GetNoOfLines : LongInt;
begin
  Result := fLines.Count;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetTheta(v : LongInt);
begin
  While v > 360 do Dec(v,360);
  While v < 0   do Inc(v,360);
  If Round(fTheta*ToDeg) = v then Exit;
  fTheta := v*ToRad;
  fSinTheta := Sin(fTheta);
  fCosTheta := Cos(fTheta);
  fAnglesChanged := True;
end;

{------------------------------------------------------------------------------}
function TGraph3D.GetTheta : LongInt;
begin
  Result := Round(fTheta*ToDeg);
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetPhi(v : LongInt);
begin
  While v > 360 do Dec(v,360);
  While v < 0   do Inc(v,360);
  If Round(fPhi*ToDeg) = v then Exit;
  fPhi := v*ToRad;
  fSinPhi := Sin(fPhi);
  fCosPhi := Cos(fPhi);
  fAnglesChanged := True;
end;

{------------------------------------------------------------------------------}
function TGraph3D.GetPhi : LongInt;
begin
  Result := Round(fPhi*ToDeg);
end;

{------------------------------------------------------------------------------}
Function TGraph3D.GetFont : TFont;
Begin
  Result := Canvas.Font;
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.SetFont(f : TFont);
Begin
  If Canvas.Font = f then Exit;
  Canvas.Font := f;
  Draw(Canvas, True);
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.SetShowFrame(b : Boolean);
Begin
  If fShowFrame = b then Exit;
  fShowFrame := b;
  If fShowFrame then DrawFrame(Canvas)
                else DeleteFrame(Canvas);
End;

{------------------------------------------------------------------------------}
function TGraph3D.GetIsodoseValue(i : ShortInt) : Single;
begin
  If (i < 0) or (i > MaxNoOfIsodoses-1) then
    Raise Exception.Create('GetIsodoseValue was given invalid index');
  Result := fIsodoses[i].Percentage;
end;

{------------------------------------------------------------------------------}
function TGraph3D.GetIsodoseColor(i : ShortInt) : TColor;
begin
  If (i < 0) or (i > MaxNoOfIsodoses-1) then
    Raise Exception.Create('GetIsodoseColor was given invalid index');
  Result := fIsodoses[i].Color;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetHiddenLines(b : Boolean);
begin
  If b = fDrawHiddenLines then Exit;
  fDrawHiddenLines := b;
  fHiddenLinesChanged := True;
  If fDrawHiddenLines then DrawTrapezes(Canvas)
                      else Draw(Canvas, True);
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetDrawAxes(b : Boolean);
begin
  If b = fDrawAxes then Exit;
  fDrawAxes := b;
  fDrawAxesDataChanged := True;
  Draw(Canvas, True);
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetOffset(p : TPoint);
begin
  If (p.X = fOffset.X) and (p.Y = fOffset.Y) then Exit;
  Inc(fPlotOrigin.X, p.X - fOffset.X);
  Inc(fPlotOrigin.Y, p.Y - fOffset.Y);
  fOffset.X := p.x;
  fOffset.Y := p.y;
  fOffsetChanged  := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetDataColor(c : TColor);
begin
  If c = fDataColor then Exit;
  fDataColor := c;
  fColorsChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetAxesColor(c : TColor);
begin
  If c = fAxesColor then Exit;
  fAxesColor := c;
  fColorsChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetLabelX(s : String);
begin
  If s = fLabelX then Exit;
  fLabelX := s;
  fLabelsChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetLabelY(s : String);
begin
  If s = fLabelY then Exit;
  fLabelY := s;
  fLabelsChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetLabelZ(s : String);
begin
  If s = fLabelZ then Exit;
  fLabelZ := s;
  fLabelsChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetCaption(s : String);
begin
  s := Trim(s);
  If s = fCaption then Exit;
  fOldCaption := fCaption;
  fCaption := s;
  DrawCaption(Canvas);
  fLabelsChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetZoomX(z : Single);
begin
  If z = fZoomX then Exit;
  If z < 0.1 then z := 0.1;
  If z > 3   then z := 3;
  fZoomX := z;
  fZoomChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetZoomY(z : Single);
begin
  If z = fZoomY then Exit;
  If z < 0.1 then z := 0.1;
  If z > 3   then z := 3;
  fZoomY := z;
  fZoomChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetViewPercentage(i : ShortInt);
begin
  If i < 1 then i := 1;
  If i > 100 then i := 100;
  If i = fViewPercentage then Exit; //no action needed
  fViewPercentage := i;
  fRangeChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetFirstLine(i : Longint);
begin
  If i < 0 then i := 0;
  If i >= fLines.Count then i := fLines.Count-1;
  If i = fFirstLine then Exit;
  fFirstLine := i;
  fRangeChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetLastLine(i : Longint);
begin
  If i < 0 then i := 0;
  If i >= fLines.Count then i := fLines.Count-1;
  If i = fLastLine then Exit;
  fLastLine := i;
  fRangeChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetUseColors(b : Boolean);
begin
  If fUseColors = b then Exit;
  fUseColors := b;
  fColorsChanged := True;
  InitDraw;
  DrawTrapezes(Canvas);
end;
                                 (*
{------------------------------------------------------------------------------}
procedure TGraph3D.SetAxesKind(k : TAxesKind);
begin
  if fAxesKind = k then Exit;
  fAxesKind := k;
  case k of
     //  akBoth : ;
       akLeftHand : If Phi > 180 then Phi := Phi-180;
       akRightHand : If Phi < 180 then Phi := Phi+180;
  end;
end;                               *)

{------------------------------------------------------------------------------}
procedure TGraph3D.SetIsodose(Ind : Byte; Percent : Single; col : TColor);
begin
  If (Ind < 0) or (Ind >= MaxNoOfIsodoses) then
    Raise Exception.Create('Isodose-index must be between 0 and '+IntToStr(MaxNoOfIsodoses-1));
  If (Percent < 0) or (Percent > 100) then
    Raise Exception.Create('Isodose-percentage must be betwenn 0 and 100');
  with fIsodoses[Ind] do begin
    Percentage := Percent;
    If Col <> clNone then Color := col; //allow unchanged color
    Active     := True;
  end;
  fColorsChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetWaterLevel(Kind : TWaterLevel; Percent : Single);
begin
  If (Percent < 0) or (Percent > 100) then
    Raise Exception.Create('Waterlevel-percentage must be betwenn 0 and 100');
  fWaterlevelPercent := Percent;
  fWaterlevelType    := Kind;
  Draw(Canvas, True);
  fWaterLevelChanged := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.AddLine(L : TGraphLine);
begin
  If (L.NoOfValues <> fLineDim) then begin
    If (NoOfLines = 0)
      then fLineDim := L.NoOfValues
      else Raise Exception.Create('Given line does not match: wrong length');
  end;
  FLines.Add(L);
  fDataChanged := True;
  fDidInit := False;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.CalcScales;
begin
  fXscale := Width*fZoomX/100;
  fYscale := Height*fZoomY/100;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.CenterPlot;                                    
var tmpPt : TPoint;
begin
  If (csDesigning in ComponentState) then Exit;
  Offset := Point(0,0);    //calls SetOffset()
  fPlotOrigin := Point(0, 0);
  tmpPt := Map(Favgs);
  fPlotOrigin.X := (Width div 2) - tmpPt.X;
  fPlotOrigin.Y := (Height div 2)- tmpPt.Y;
end;

{------------------------------------------------------------------------------}
Function TGraph3D.MouseIsInMyClientArea : Boolean;
Var  Pt : TPoint;
Begin
  GetCursorPos(Pt);
  Pt := ScreenToClient(Pt);
  If (Pt.X < 0) or (Pt.X > Width) or (Pt.Y < 0) or (Pt.Y > Height)
    then Result := False
    else Result := True;
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.ScrollLines;
Begin
  fScrollData.AmScrolling := True;
  fScrollData.ScrollPaused := False;
  While fScrollData.AmScrolling and not fScrollData.ScrollPaused do begin
    FirstLine := fScrollData.Position;
    LastLine  := fScrollData.Position;
    //if mouse left my client-area then stop scrolling:
    //MWMouseLeave-message is lost while scrolling
    If not MouseIsInMyClientArea then StopScrolling
    else begin
      Application.ProcessMessages;
      Sleep(fScrollData.Speed);
      If fScrollData.Incremental then begin
        InitDraw; //in case of changes in aspect
        If FirstLine = 0 then begin
          ClearCanvas(Canvas);
          DrawAxesNow(True, Canvas);
          DrawCaption(Canvas);
        end;
        DrawTrapezes(Canvas);
        DrawFrame(Canvas);
      end else Draw(Canvas, False);
      If Assigned(fOnScroll) then fOnScroll(Self);
      Inc(fScrollData.Position);
      If fScrollData.Position = fLines.Count then fScrollData.Position := 0;
    end;
  end;
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.StopScrolling;
Begin
  fScrollData.AmScrolling := False;
  fScrollData.ScrollPaused := False;
  FirstLine := 0;
  LastLine  := fLines.Count-1;
  If Assigned(fOnStopScrolling) then fOnStopScrolling(Self);
End;

{------------------------------------------------------------------------------}
function TGraph3D.Map(Pt : T3DPoint) : TPoint;
var P : TPoint;        //result
begin
  P.Y := fPlotOrigin.Y - Round(fYScale*(pt.X*fCosTheta*fSinPhi +
                                        pt.Y*fSinTheta*fSinPhi +
                                        pt.Z*fCosPhi));
  P.X := fPlotOrigin.X + Round(fXScale*(pt.X*fSinTheta
                                      - pt.Y*fCosTheta));
  Result := P;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.BuildTrapezes;
//gets Min/Max etc... and creates trapeze-list
var i, j : LongInt;        //iterators
    Xmax, Xmin,
    Ymax, Ymin,
    Zmax, Zmin : Single;   //max/min of the 3 dimensions
    Xsum, Ysum, Zsum : Single;//sum, needed for average values
    T : PTrapezeInfo;      //new trapeze to fill
    XFactor, YFactor, ZFactor : Double; //used for normalization
    CurrentX, CurrentY, CurrentZ : Single;
    CurrentLine,
    NextLine : TGraphLine; //avoid excessive casting
begin
  If csDesigning in ComponentState then Exit;
  //clear data:
  ClearTrapezes;
  If (fLines.Count < 2) then Exit;
//    then Raise Exception.Create('Graph3D.BuildTrapezes: Not enough data, cannot init trapezes');
  //init:
  CurrentLine := TGraphLine(fLines[0]);
  Xmax := CurrentLine.X[0];
  Xmin := Xmax;
  Ymax := CurrentLine.Y[0];
  Ymin := Ymax;
  Zmax := CurrentLine[0];
  Zmin := Zmax;
  Xsum := 0; Ysum := 0; Zsum := 0;
  fTrapezes.Capacity := (fLines.Count-1)*(fLineDim-1);
  //OK, go through every given line to find min/max/avg:
  For j := 0 to fLines.Count-1 do begin
    CurrentLine := TGraphLine(fLines[j]);
    For i := 0 to fLineDim-1 do begin
      CurrentX := CurrentLine.X[i];
      CurrentY := CurrentLine.Y[i];
      CurrentZ := CurrentLine[i];
      Xsum := Xsum + CurrentX;
      Ysum := Ysum + CurrentY;
      Zsum := Zsum + CurrentZ;
      If CurrentX > XMax then Xmax := CurrentX;
      If CurrentX < XMin then Xmin := CurrentX;
      If CurrentY > YMax then Ymax := CurrentY;
      If CurrentY < YMin then Ymin := CurrentY;
      If CurrentZ > ZMax then Zmax := CurrentZ;
      If CurrentZ < ZMin then Zmin := CurrentZ;
    end; //of for all points on line do
  end; //of for each line do
  //check:
  If (Xmax = Xmin) or (Ymax = Ymin) or (Zmax = Zmin)
    then Raise Exception.Create('Graph3D.BuildTrapezes: Bad values: no range');
  //normalization-factors:
  Xfactor := 100/(Xmax-Xmin);
  Yfactor := 100/(Ymax-Ymin);
  Zfactor := 100/(Zmax-Zmin);
  Favgs.X := Xsum/(NoOfLines*flineDim);
  Favgs.Y := Ysum/(NoOfLines*flineDim);
  Favgs.Z := Zsum/(NoOfLines*flineDim);
  //scale averages to 100:
  Favgs.X := XFactor*(Favgs.X-Xmin);
  Favgs.Y := YFactor*(Favgs.Y-Ymin);
  Favgs.Z := ZFactor*(Favgs.Z-Zmin);

  //now build the trapezes:
  For j := 0 to fLines.Count-2 do begin//need next line, too
    CurrentLine := TGraphLine(fLines[j]);
    NextLine := TGraphLine(fLines[j+1]);
    For i := 0 to fLineDim-2 do begin//need next point, too
      T := New(PTrapezeInfo);
      with T^ do begin
        LineNo := j; //index of CurrentLine
        //set datapoints of trapeze to normalized Line-points:
        Vals[0].X := Xfactor*(CurrentLine.X[i]  -Xmin); //scale all to 100
        Vals[0].Y := Yfactor*(CurrentLine.Y[i]  -Ymin);
        Vals[0].Z := Zfactor*(CurrentLine[i]    -Zmin);
        Vals[1].X := Xfactor*(CurrentLine.X[i+1]-Xmin);
        Vals[1].Y := Yfactor*(CurrentLine.Y[i+1]-Ymin);
        Vals[1].Z := Zfactor*(CurrentLine[i+1]  -Zmin);
        Vals[2].X := Xfactor*(NextLine.X[i+1]   -Xmin);
        Vals[2].Y := Yfactor*(NextLine.Y[i+1]   -Ymin);
        Vals[2].Z := Zfactor*(NextLine[i+1]     -Zmin);
        Vals[3].X := Xfactor*(NextLine.X[i]     -Xmin);
        Vals[3].Y := Yfactor*(NextLine.Y[i]     -Ymin);
        Vals[3].Z := Zfactor*(NextLine[i]       -Zmin);
        //get avg. value for this trapeze (needed for distance from viewpoint):
        AVG.X := (Vals[1].X+Vals[2].X+Vals[3].X+Vals[0].X)/4;
        AVG.Y := (Vals[1].Y+Vals[2].Y+Vals[3].Y+Vals[0].Y)/4;
        AVG.Z := (Vals[1].Z+Vals[2].Z+Vals[3].Z+Vals[0].Z)/4;
      end; //of with T^ do
      fTrapezes.Add(T);
    end; //of for all points on line do
  end; //of for each line do
  //finish off:
  LastLine := fLines.Count-1;
  fDidInit := True;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetViewpoint;
const Far_Away = 10000; //viewpoint must be far to get parallel projection
begin
  fViewPoint.X := fAVGs.X + Far_Away*fCosPhi*fCosTheta;
  fViewPoint.Y := fAVGs.y + Far_Away*fCosPhi*fSinTheta;
  fViewPoint.Z := fAVGs.Z - Far_Away*fSinPhi;
end;

{------------------------------------------------------------------------------}
function DistanceCompare(Item1, Item2 : Pointer): Integer;
begin
  Result := Round(PTrapezeInfo(Item1).DistanceToViewer - PTrapezeInfo(Item2).DistanceToViewer);
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.OrderTrapezes;
//goes through list of trapezes, ordering them by distance from viewer
var i : LongInt;         //iterator
    T : PTrapezeInfo;    //avoid excessive casting
begin
  If fTrapezes.Count < 2 then Exit;
  //calculate Trapeze-Distances:
  For i := 0 to fTrapezes.Count-1 do begin
    T := PTrapezeInfo(fTrapezes[i]);
    T^.DistanceToViewer := SqrDistance(T^.AVG, fViewPoint);
  end;
  //now sort them according to distance:
  fTrapezes.Sort(DistanceCompare);
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.MapTrapezes;
//goes through list of trapezes, mapping the Vals[s to Points
var i,j : LongInt;
    T : PTrapezeInfo; //avoid excessive casting
    WaterPoint : T3DPoint; //used if we want a waterlevel
begin
  If fTrapezes.Count < 1 then Exit;
  For i := 0 to fTrapezes.Count-1 do begin
    T := PTrapezeInfo(fTrapezes[i]);
    with T^ do begin
      case fWaterLevelType of
         wlNone: begin
                   For j := 0 to 3 do Pixs[j] := Map(Vals[j]);
                 end;
         wlAbove: begin //force points up if need be
                   For j := 0 to 3 do begin
                     WaterPoint.X := Vals[j].X;
                     WaterPoint.Y := Vals[j].Y;
                     If Vals[j].Z < fWaterlevelPercent
                       then WaterPoint.Z := fWaterlevelPercent
                       else WaterPoint.Z := Vals[j].Z;
                     Pixs[j] := Map(WaterPoint);
                   end;
                 end;
         wlBelow: begin //force points down if need be
                   For j := 0 to 3 do begin
                     WaterPoint.X := Vals[j].X;
                     WaterPoint.Y := Vals[j].Y;
                     If Vals[j].Z > fWaterlevelPercent
                       then WaterPoint.Z := fWaterlevelPercent
                       else WaterPoint.Z := Vals[j].Z;
                     Pixs[j] := Map(WaterPoint);
                   end;
                 end;
      end; //of case
    end;
  end;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.SetTrapezeColors;
var i,j : LongInt;
    value : Single; //if waterlevel...
begin
  For i := 0 to fTrapezes.Count-1 do begin
    If fUseColors then begin
      Value := PTrapezeInfo(fTrapezes[i])^.AVG.Z;
      case fWaterLevelType of
           wlAbove : If Value < fWaterlevelPercent then Value := fWaterLevelPercent;
           wlBelow : If Value > fWaterlevelPercent then Value := fWaterLevelPercent;
      end;
      //find which isdose-color must get used: j
      For j := 0 to MaxNoOfIsodoses-1 do
        If Value <= fIsodoses[j].Percentage then Break;
      If j = MaxNoOfIsodoses then Dec(j); //For-loop: j is undefined at end
      PTrapezeInfo(fTrapezes[i])^.Color := fIsodoses[j].Color;
    end else
      PTrapezeInfo(fTrapezes[i])^.Color := fDataColor;
  end; //of for each Trapeze do
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.DrawXaxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
var Pt1, pt2 : TPoint;
    OldColor : TColor;
begin
  with CV  do begin
    OldColor := Font.Color;
    If DrawIt then begin
      Pen.Color := fAxesColor;
      Font.Color := fAxesColor;
    end else begin
      Pen.Color := Color;
      Font.Color := Color;
    end;
    Pen.Style := Style;//psDash;
    Brush.Style := bsClear; //otherwise text has background
    Pt1 := Map(Point3D(0,0,0));
    Pt2 := Map(Point3D(110,0,0)); //axes are 10% longer
    MoveTo(Pt1.X, Pt1.Y);
    LineTo(Pt2.X, Pt2.Y);
    TextOut(Pt2.X, Pt2.Y, fLabelX);
    //reset:
    Pen.Style  := psSolid;
    Font.Color := OldColor;
  end;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.DrawXFarAxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
var Pt1, pt2 : TPoint;
    OldColor : TColor;
begin
  with CV  do begin
    OldColor := Font.Color;
    If DrawIt then begin
      Pen.Color := fAxesColor;
      Font.Color := fAxesColor;
    end else begin
      Pen.Color := Color;
      Font.Color := Color;
    end;
    Pen.Style := Style;//psDash;
    Brush.Style := bsClear; //otherwise text has background
    Pt1 := Map(Point3D(0,100,0));
    Pt2 := Map(Point3D(100,100,0)); //axes are 10% longer
    MoveTo(Pt1.X, Pt1.Y);
    LineTo(Pt2.X, Pt2.Y);
    //reset:
    Pen.Style  := psSolid;
    Font.Color := OldColor;
  end;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.DrawYaxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
var Pt1, pt2 : TPoint;
    OldColor : TColor;
begin
  with CV  do begin
    OldColor := Font.Color;
    If DrawIt then begin
      Pen.Color := fAxesColor;
      Font.Color := fAxesColor;
    end else begin
      Pen.Color := Color;
      Font.Color := Color;
    end;
    Pen.Style := Style;//psDash;
    Brush.Style := bsClear; //otherwise text has background
    //origin:
    Pt1 := Map(Point3D(0,0,0));
    Pt2 := Map(Point3D(0,110,0)); //axes are 10% longer
    MoveTo(Pt1.X, Pt1.Y);
    LineTo(Pt2.X, Pt2.Y);
    TextOut(Pt2.X, Pt2.Y, fLabelY);
    //reset:
    Pen.Style  := psSolid;
    Font.Color := OldColor;
  end;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.DrawYFarAxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
var Pt1, pt2 : TPoint;
    OldColor : TColor;
begin
  with CV  do begin
    OldColor := Font.Color;
    If DrawIt then begin
      Pen.Color := fAxesColor;
      Font.Color := fAxesColor;
    end else begin
      Pen.Color := Color;
      Font.Color := Color;
    end;
    Pen.Style := Style;//psDash;
    Brush.Style := bsClear; //otherwise text has background
    //origin:
    Pt1 := Map(Point3D(100,0,0));
    Pt2 := Map(Point3D(100,100,0)); //axes are 10% longer
    MoveTo(Pt1.X, Pt1.Y);
    LineTo(Pt2.X, Pt2.Y);
    //reset:
    Pen.Style  := psSolid;
    Font.Color := OldColor;
  end;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.DrawZaxis(DrawIt : Boolean; Style: TPenStyle; CV : TCanvas);
var Pt1, pt2 : TPoint;
    OldColor : TColor;
begin
  with CV  do begin
    OldColor := Font.Color;
    If DrawIt then begin
      Pen.Color := fAxesColor;
      Font.Color := fAxesColor;
    end else begin
      Pen.Color := Color;
      Font.Color := Color;
    end;
    Pen.Style := Style;//psDash;
    Brush.Style := bsClear; //otherwise text has background
    //origin:
    Pt1 := Map(Point3D(0,0,0));
    Pt2 := Map(Point3D(0,0,110)); //axes are 10% longer
    MoveTo(Pt1.X, Pt1.Y);
    LineTo(Pt2.X, Pt2.Y);
    TextOut(Pt2.X+5, Pt2.Y, fLabelZ);
    //reset:
    Pen.Style  := psSolid;
    Font.Color := OldColor;
  end;
end;

{------------------------------------------------------------------------------}
procedure TGraph3D.DrawAxesNow(DrawThem : Boolean; CV : TCanvas);
begin
  DrawXaxis(DrawThem, psSolid, Canvas);
  DrawYaxis(DrawThem, psSolid, Canvas);
  DrawZaxis(DrawThem, psSolid, Canvas);
  DrawXFarAxis(DrawThem, psSolid, Canvas);
  DrawYFarAxis(DrawThem, psSolid, Canvas);
end;

          (*##
Function GetTimeCount : TLargeInteger;
var n : TLargeInteger;
begin
  QueryPerformanceCounter(n);
  Result := n;
end;
Function TimeTaken(start, stop : TLargeInteger) : LongInt; //msec
var n : TLargeInteger;
begin
  QueryPerformanceFrequency(n);
  Result := Round(1000*(stop.QuadPart-start.QuadPart)/n.QuadPart);
end;                  *)
{------------------------------------------------------------------------------}
procedure TGraph3D.Draw(CV : TCanvas; CallEvent : Boolean);
Var Xfirst, Yfirst, Zfirst : Boolean; //draw axes before trapezes?
    Xfar, Yfar : Boolean;             //show max X/Y as lines at Z = 0, too
    pt : T3DPoint;
//    n,n1,n2,n3,n4,n5 : TLargeInteger;
Begin
//  n := GetTimeCount;
  ClearCanvas(CV);
  If fShowFrame then DrawFrame(CV); //looks better if it's visible while drawing
  DrawCaption(CV);
  If csDesigning in ComponentState then Exit;
//  n1 := GetTimeCount;
  InitDraw; //does all calculations
//  n2 := GetTimeCount;
  //check which axes will be partly hidden (must be draw first):
  pt := Point3D(Favgs.X,0,0);
  XFirst := SqrDistance(pt, fViewPoint) > SqrDistance(Favgs, fViewPoint);
  pt := Point3D(Favgs.X,100,0);
  XFar := SqrDistance(pt, fViewPoint) > SqrDistance(Favgs, fViewPoint);
  pt := Point3D(0,Favgs.Y,0);
  YFirst := SqrDistance(pt, fViewPoint) > SqrDistance(Favgs, fViewPoint);
  pt := Point3D(100,Favgs.Y,0);
  YFar := SqrDistance(pt, fViewPoint) > SqrDistance(Favgs, fViewPoint);
  pt := Point3D(0,0,Favgs.Z);
  ZFirst := SqrDistance(pt, fViewPoint) > SqrDistance(Favgs, fViewPoint);
  If fDrawAxes and XFirst then DrawXaxis(True, psDash, CV);
  If fDrawAxes and YFirst then DrawYaxis(True, psDash, CV);
  If fDrawAxes and ZFirst then DrawZaxis(True, psDash, CV);
  If fDrawAxes and XFar then DrawXFarAxis(True, psDash, CV);
  If fDrawAxes and YFar then DrawYFarAxis(True, psDash, CV);
  //now draw the trapezes:
//  n3 := GetTimeCount;
  DrawTrapezes(CV);
//  n4 := GetTimeCount;
  If fDrawAxes and not XFirst then DrawXaxis(True, psSolid, CV);
  If fDrawAxes and not YFirst then DrawYaxis(True, psSolid, CV);
  If fDrawAxes and not ZFirst then DrawZaxis(True, psSolid, CV);
  If fDrawAxes and not XFar then DrawXFarAxis(True, psSolid, CV);
  If fDrawAxes and not YFar then DrawYFarAxis(True, psSolid, CV);
  If fShowFrame then DrawFrame(Canvas); //was probably ruined by trapezes
{  n5 := GetTimeCount;
  Canvas.TextOut(10,10, IntToStr(TimeTaken(n, n1))+':'+
                                IntToStr(TimeTaken(n1, n2))+':'+
                                IntToStr(TimeTaken(n2, n3))+':'+
                                IntToStr(TimeTaken(n3, n4))+':'+
                                IntToStr(TimeTaken(n4, n5))+':'+
                                IntToStr(TimeTaken(n, n5)));     }
  If CallEvent and Assigned(fAfterDraw) then fAfterDraw(Self);
end;

{------------------------------------------------------------------------------}
Procedure TGraph3D.DrawFrame(CV : TCanvas);
Begin
  with CV  do begin
    Pen.Color := clBtnShadow;
    Pen.Style := psSolid;
    Pen.Width := 1;
    MoveTo(0,Height);
    LineTo(0,0);
    LineTo(Width-1,0);
    Pen.Color := clBtnHighLight;
    LineTo(Width-1,Height-1);
    LineTo(0,Height-1);
  end;
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.DeleteFrame(CV : TCanvas);
Begin
  with CV  do begin
    Pen.Color := Color; //background
    Pen.Width := 1;
    MoveTo(0,Height);
    LineTo(0,0);
    LineTo(Width-1,0);
    LineTo(Width-1,Height-1);
    LineTo(0,Height-1);
  end;
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.DrawCaption(CV : TCanvas);
Begin
  If fCaption = '' then Exit;
  with CV  do begin
    Pen.Color := fAxesColor;
    Brush.Style := bsClear; //otherwise text has background
    TextOut(15, 15, fCaption);
  end;
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.DeleteCaption(CV : TCanvas);
Begin
  If fOldCaption = '' then Exit;
  with CV  do begin
    Pen.Color := Color;
    Brush.Style := bsClear; //otherwise text has background
    TextOut(15, 15, fOldCaption);
  end;
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.DrawTrapezes(CV : TCanvas);
var i : LongInt;
    Trapeze : TTrapezeInfo;
Begin
  with CV do begin
    Brush.Color := Color;
    If fDrawHiddenLines
      then Brush.Style := bsSolid
      else Brush.Style := bsClear;
    For i := fTrapezes.Count-1 downto Round(fTrapezes.Count*(100-fViewPercentage)/100) do begin//furthest ones first
      Trapeze := PTrapezeInfo(fTrapezes[i])^;
      If (Trapeze.LineNo > fLastLine) or (Trapeze.LineNo < fFirstLine) then Continue;
        Pen.Color   := Trapeze.Color;
        PolyGon([Trapeze.Pixs[0], Trapeze.Pixs[1], Trapeze.Pixs[2], Trapeze.Pixs[3]]);
    end;
  end;
End;

{------------------------------------------------------------------------------}
procedure TGraph3D.InitDraw;
var Yes : Boolean;
Begin
  Yes := fDataChanged and not fDidInit;
  If Yes
    then BuildTrapezes;
  If Yes or fColorsChanged or fWaterLevelChanged
    then SetTrapezeColors;
  If Yes or fZoomChanged
    then CalcScales;
  If Yes
    then CenterPlot;
  If Yes or fAnglesChanged then begin
    SetViewpoint;
    OrderTrapezes;
  end;
  If Yes or fZoomChanged or fAnglesChanged or fOffsetChanged or fWaterLevelChanged
    then MapTrapezes;
  fLabelsChanged       := False;
  fDrawAxesDataChanged := False;
  fRangeChanged        := False;
  fOffsetChanged       := False;
  fColorsChanged       := False;
  fHiddenLinesChanged  := False;
  fAnglesChanged       := False;
  fZoomChanged         := False;
  fWaterLevelChanged   := False;
End;

{------------------------------------------------------------------------------}
Procedure TGraph3D.Paint;
Begin
  Draw(Canvas, True);
End;

{------------------------------------------------------------------------------}
Function TGraph3D.AsBitmap(inWhite : Boolean) : TBitmap;
var BM : TBitmap;
    R  : TRect;
Begin
  BM := TBitmap.Create;
  R := Canvas.ClipRect;
  BM.Width := R.Right - R.Left;
  BM.Height := R.Bottom - R.Top;
//  TWinControl(Self).PaintTo(BM.Canvas.Handle, 0, 0);
  Draw(BM.Canvas, False);
  If inWhite and (Color <> clWhite) then begin
    BM.Canvas.Brush.Color := clWhite;
    BM.Canvas.BrushCopy(R, BM, R, Color);
  end;
  Result := BM;
End;


procedure Register;
begin
  RegisterComponents('Samples', [TGraph3D]);
end;

end.
