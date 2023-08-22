unit KhFunction;

interface

uses
    SysUtils, Classes, Controls, Graphics;

type
    TKhPosInt = 1..4294967295;
    TKhFunction = class;

    { TKhFunctionInterval - Persistent }
    TKhFunctionInterval = class(TPersistent)
    private
        FFunction: TKhFunction;
        FFinish: Double;
        FStart:  Double;
        procedure SetFinish(Value: Double);
        procedure SetStart(Value: Double);
    published
        property Start:  Double read FStart  write SetStart;
        property Finish: Double read FFinish write SetFinish;
    end;

    { TkhFunctionStep - Persistent }
    TKhFunctionStep = class(TPersistent)
    private
        FFunction: TKhFunction;
        FCount: TKhPosInt;
        FSize: Double;
        procedure SetCount(Value: TKhPosInt);
        procedure SetSize(Value: Double);
    published
        property Count: TKhPosInt read FCount write SetCount default 1;
        property Size: Double read FSize write SetSize;
    end;

    TKhFunctionFunctionEvent = procedure (Sender: TObject;
        const X: Double; var Y: Double) of object;
    TKhFunctionValueEvent = procedure (Sender: TObject;
        const X, Y: Double) of object;

    { TKhFunction - KhCustomFunction }
    TKhFunction = class(TComponent)
    private
        FInterval: TKhFunctionInterval;
        FStep: TKhFunctionStep;
        FOnFunction: TKhFunctionFunctionEvent;
        FOnValue: TKhFunctionValueEvent;
    protected
        procedure DoFunction(const X: Double; var Y: Double);
    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure Evaluate; virtual;
    published
        property Interval: TKhFunctionInterval read FInterval write FInterval;
        property Step: TKhFunctionStep read FStep write FStep;
        property OnFunction: TKhFunctionFunctionEvent read FOnFunction
            write FOnFunction;
        property OnValue: TKhFunctionValueEvent read FOnValue write FOnValue;
    end;



    { TKh1stDerivativeMethod - Enumerated type }
    TKh1stDerivativeMethod = (fdmLeftLimit, fdmRightLimit, fdmBothLimit);

    { TKh1stDerivative - KhFunction }
    TKh1stDerivative = class(TKhFunction)
    private
        FMethod: TKh1stDerivativeMethod;
    public
        constructor Create(AOwner: TComponent); override;
        procedure Evaluate; override;
    published
        property Method: TKh1stDerivativeMethod read FMethod write FMethod
            default fdmLeftLimit;
    end;



    { TKh2ndDerivative - KhFunction }
    TKh2ndDerivative = class(TKhFunction)
    public
        procedure Evaluate; override;
    end;



    { TKh1stOrderDiffEquationMethod - Enumerated type }
    TKh1stOrderDiffEquationMethod = (demEuler, demEulerCauchy);

    TKh1stOrderDiffEquationFunctionEvent = procedure (Sender: TObject;
        const X,Y: Double; var Fxy: Double) of object;

    { TKh1stOrderDiffEquation - Component }
    TKh1stOrderDiffEquation = class(TKhFunction)
    private
        FMethod: TKh1stOrderDiffEquationMethod;
        FOnFunction: TKh1stOrderDiffEquationFunctionEvent;
        FX0: Double;
        FY0: Double;
    protected
        procedure DoFunction(const X,Y: Double; var Fxy: Double);
    public
        constructor Create(AOwner: TComponent); override;
        procedure Evaluate; override;
    published
        property Method: TKh1stOrderDiffEquationMethod read FMethod
            write FMethod default demEuler;
        property OnFunction: TKh1stOrderDiffEquationFunctionEvent
            read FOnFunction write FOnFunction;
        property X0: Double read FX0 write FX0;
        property Y0: Double read FY0 write FY0;
    end;


    TKhXYPloteAxesStyle = (pasCross, pasBox);
    TKhXYPlotAxis = class;
    TKhXYPlotFunctions = class;

    { TKhXYPlot - GraphicControl }
    TKhXYPlot = class(TGraphicControl)
    private
        FAutoDrawGraph: Boolean;
        FAxesStyle: TKhXYPloteAxesStyle;
        FColor: TColor;
        FFont: TFont;
        FFunctions: TKhXYPlotFunctions;
        FXAxis: TKhXYPlotAxis;
        FYAxis: TKhXYPlotAxis;
        procedure SetAutoDrawGraph(Value: Boolean);
        procedure SetAxesStyle(Value: TKhXYPloteAxesStyle);
        procedure SetFont(Value: TFont);
        procedure SetFunctions(Value: TKhXYPlotFunctions);
        procedure SetXAxis(Value: TKhXYPlotAxis);
        procedure SetYAxis(Value: TKhXYPlotAxis);
    private
        bmp: TBitmap;
        isStartDraw: Boolean;
        xZoom: Double;
        yZoom: Double;
        procedure DrawFunctionToBmp(Sender: TObject; const X, Y: Double);
        procedure DrawAxes;
    protected
        procedure Loaded; override;
        procedure Notification(AComponent: TComponent; Operation: TOperation);
            override;
        procedure Paint; override;
        procedure Resize; override;
        procedure SetColor(Value: TColor);
    public
        constructor Create(AOwner: TComponent); override;
        destructor Destroy; override;
        procedure DrawGraph;
    published
        property AutoDrawGraph: Boolean read FAutoDrawGraph write SetAutoDrawGraph
            default False;
        property AxesStyle: TKhXYPloteAxesStyle read FAxesStyle
            write SetAxesStyle default pasCross;
        property Color: TColor read FColor write SetColor default clWhite;
        property Functions: TKhXYPlotFunctions read FFunctions write SetFunctions;
        property XAxis: TKhXYPlotAxis read FXAxis write SetXAxis;
        property YAxis: TKhXYPlotAxis read FYAxis write SetYAxis;
        property Align;
        property Anchors;
        property Font: TFont read FFont write SetFont;
        property PopupMenu;
        property OnClick;
        property OnDblClick;
        property OnMouseDown;
        property OnMouseMove;
        property OnMouseUp;
    end;

    TKhXYPlotAxisGridCount = 2..99;

    { TKhXYPlotAxis - Persistent }
    TKhXYPlotAxis = class(TPersistent)
    private
        FColor: TColor;
        FGridCount: TKhXYPlotAxisGridCount;
        FGridLines: Boolean;
        FHigh: Double;
        FLow: Double;
        FNumbered: Boolean;
        FOwner: TKhXYPlot;
        FWidth: TKhPosInt;
        procedure SetColor(Value: TColor);
        procedure SetGridCount(Value: TKhXYPlotAxisGridCount);
        procedure SetGridLines(Value: Boolean);
        procedure SetHigh(Value: Double);
        procedure SetLow(Value: Double);
        procedure SetNumbered(Value: Boolean);
        procedure SetWidth(Value: TKhPosInt);
    published
        property Color: TColor read FColor write SetColor default clBlack;
        property GridCount: TKhXYPlotAxisGridCount read FGridCount
            write SetGridCount default 2;
        property GridLines: Boolean read FGridLines write SetGridLines
            default False;
        property High: Double read FHigh write SetHigh;
        property Low: Double read FLow write SetLow;
        property Numbered: Boolean read FNumbered write SetNumbered
            default False;
        property Width: TKhPosInt read FWidth write SetWidth default 1;
    end;

    { TKhXYPlotFunction - CollectionItem }
    TKhXYPlotFunction = class(TCollectionItem)
    private
        FColor: TColor;
        FKhFunction: TKhFunction;
        FPenStyle: TPenStyle;
        FWidth: TKhPosInt;
    private
        FOwnerXYPlot: TKhXYPlot;
    public
        constructor Create(Collection: TCollection); override;
    published
        property Color: TColor read FColor write FColor default clRed;
        property KhFunction: TKhFunction read FKhFunction write FKhFunction;
        property PenStyle: TPenStyle read FPenStyle write FPenStyle
            default psSolid;
        property Width: TKhPosInt read FWidth write FWidth default 1;
    end;

    { TKhXYPlotFunctions - Collection }
    TKhXYPlotFunctions = class(TOwnedCollection)
    private
        function GetItem(AIndex: Integer): TKhXYPlotFunction;
        procedure SetItem(AIndex: Integer; const AValue: TKhXYPlotFunction);
    public
        function Add: TKhXYPlotFunction;
        property Items[AIndex: Integer]: TKhXYPlotFunction read GetItem write SetItem;
    end;

procedure Register;

implementation


procedure Register;
begin
    RegisterComponents('KhDiscrete', [TKhFunction, TKh1stDerivative,
        TKh2ndDerivative, TKh1stOrderDiffEquation, TKhXYPlot]
    );
end;


{ TKhFunctionInterval }

procedure TKhFunctionInterval.SetFinish(Value: Double);
begin
    if (Value=FFinish) then exit;
    FFinish := Value;
    FFunction.FStep.SetCount(FFunction.FStep.FCount);
end;

procedure TKhFunctionInterval.SetStart(Value: Double);
begin
    if (Value=FStart) then exit;
    FStart := Value;
    FFunction.FStep.SetCount(FFunction.FStep.FCount);
end;


{ TKhFunctionStep }

procedure TKhFunctionStep.SetCount(Value: TKhPosInt);
begin
    FCount := Value;
    with FFunction.FInterval do FSize := (FFinish-FStart)/FCount;
end;

procedure TKhFunctionStep.SetSize(Value: Double);
begin
    if (Value=FSize) then exit;
    if (Value=0.0) then raise Exception.Create('Function step size can''t be 0 (zero)');    
    FSize := Value;
    with FFunction.FInterval do FCount := Trunc((FFinish-FStart)/FSize);
end;


{ TKhFunction }

constructor TKhFunction.Create(AOwner: TComponent);
begin
    inherited;

    FInterval           := TKhFunctionInterval.Create;
    FInterval.FFunction := Self;
    FInterval.FStart    := 0.0;
    FInterval.FFinish   := 1.0;

    FStep               := TKhFunctionStep.Create;
    FStep.FFunction     := Self;
    FStep.FCount        := 1;
    FStep.FSize         := 1.0;
end;

destructor TKhFunction.Destroy;
begin
    FStep.Free;
    FInterval.Free;
    inherited;
end;

procedure TKhFunction.DoFunction(const X: Double; var Y: Double);
begin
    if Assigned(FOnFunction) then FOnFunction(Self, X, Y)
    else Y := 0.0;
end;

procedure TKhFunction.Evaluate;
var i: Cardinal;
    x, fx: Double;
begin
    if not Assigned(FOnValue) then exit;
    x := FInterval.FStart;
    for i := 0 to FStep.FCount do begin
        DoFunction(x, fx);
        FOnValue(Self, x, fx);
        x := x+FStep.FSize;
    end;
end;

{ TKh1stDerivative }

constructor TKh1stDerivative.Create(AOwner: TComponent);
begin
    inherited;
    FMethod := fdmLeftLimit;
end;

procedure TKh1stDerivative.Evaluate;
var i: Cardinal;
    x, x0, f0, f1, ff, h1: Double;
begin
    if not Assigned(FOnValue) then exit;
    x := FInterval.FStart;
    h1 := FStep.FCount/(FInterval.FFinish-FInterval.FStart);

    if (FMethod=fdmLeftLimit) then begin
        DoFunction(x-FStep.FSize, f0);
        for i := 0 to FStep.FCount do begin
            x := x + FStep.FSize;
            DoFunction(x, f1);
            FOnValue(Self, x, (f1-f0)*h1);
            f0 := f1;
        end;
        exit;
    end;

    if (FMethod=fdmRightLimit) then begin
        DoFunction(x, f0);
        for i := 0 to FStep.FCount do begin
            x0 := x;
            x := x + FStep.FSize;
            DoFunction(x, f1);
            FOnValue(Self, x0, (f1-f0)*h1);
            f0 := f1;
        end;
        exit;
    end;

    if (FMethod=fdmBothLimit) then begin
        h1 := 0.5*h1;
        x0 := x - FStep.FSize;
        DoFunction(x0, f0);
        DoFunction(x, ff);
        for i := 0 to FStep.FCount do begin
            x0 := x;
            x := x + FStep.FSize;
            DoFunction(x, f1);
            FOnValue(Self, x0, (f1-f0)*h1);
            f0 := ff; ff := f1;
        end;
        exit;
    end;
end;

{ TKh1ndDerivative }

procedure TKh2ndDerivative.Evaluate;
var i: Cardinal;
    x, x0, f0, f1, f2, h1: Double;
begin
    if not Assigned(FOnValue) then exit;
    x := FInterval.FStart;
    DoFunction(x-FStep.FSize, f0);
    DoFunction(x, f1);
    h1 := FStep.FCount/(FInterval.FFinish-FInterval.FStart);
    h1 := Sqr(h1);

    for i := 0 to FStep.FCount do begin
        x0 := x;
        x := x + FStep.Size;
        DoFunction(x, f2);
        FOnValue(Self, x0, (f0+f2-f1-f1)*h1);
        f0 := f1; f1 := f2;
    end;
end;

{ TKhXYPlot }

constructor TKhXYPlot.Create(AOwner: TComponent);
begin
    inherited;
    FXAxis := TKhXYPlotAxis.Create;
    with FXAxis do begin
        FColor := clBlack;
        FGridCount := 2;
        FGridLines := False;
        FHigh  := 1.0;
        FLow   := -1.0;
        FNumbered := False;
        FOwner := Self;
        FWidth := 1;
    end;
    FYAxis := TKhXYPlotAxis.Create;
    with FYAxis do begin
        FColor := clBlack;
        FGridCount := 2;
        FGridLines := False;
        FHigh  := 1.0;
        FLow   := -1.0;
        FNumbered := False;
        FOwner := Self;
        FWidth := 1;
    end;
    FAutoDrawGraph := False;
    FAxesStyle := pasCross;
    FColor := clWhite;
    bmp := TBitmap.Create;
    FFont := TFont.Create;
    with FFont do begin
        Name  := 'Small Fonts';
        Size  := 7;
        Color := clBlack;
    end;
    FFunctions := TKhXYPlotFunctions.Create(Self, TKhXYPlotFunction);
end;

destructor TKhXYPlot.Destroy;
begin
    FFunctions.Free;
    FFont.Free;
    bmp.Free;
    FYAxis.Free;
    FXAxis.Free;
    inherited;
end;

procedure TKhXYPlot.DrawAxes;
const
    smLine = 10;
var
    i, n2, n3: Integer;
    s: String;
    n1, dx, d, r: Double;
begin
    // Coordinate zoom factors
    if (FXAxis.FHigh=FXAxis.FLow) then xZoom := 0.0 else
    xZoom := Width/(FXAxis.FHigh-FXAxis.FLow);
    if (FYAxis.FHigh=FYAxis.FLow) then yZoom := 0.0 else
    yZoom := Height/(FYAxis.FHigh-FYAxis.FLow);

    // Prepare the bmp
    with bmp.Canvas do begin

        // Background
        bmp.Width  := Width;
        bmp.Height := Height;
        Brush.Color := FColor;
        FillRect(ClipRect);
        Pen.Style := psSolid;


        // X-Axis
        with FXAxis do begin
            dx := Self.Width/FGridCount;
            if (FGridCount>2) then
            if FGridLines then begin
                Pen.Color := clGreen;
                Pen.Width := 1;
                n1 := 0.0;
                for i := 0 to FXAxis.FGridCount do begin
                    MoveTo(Trunc(n1), 0); LineTo(Trunc(n1), Height);
                    n1 := n1 + dx;
                end;
            end;
        end;

        // Y-Axis;
        with FYAxis do begin
            dx := Self.Height/FGridCount;
            if (FGridCount>2) then
            if FGridLines then begin
                Pen.Color := clGreen;
                Pen.Width := 1;
                n1 := 0.0;
                for i := 0 to FGridCount do begin
                    MoveTo(0, Trunc(n1)); LineTo(Self.Width, Trunc(n1));
                    n1 := n1 + dx;
                end;
            end;
        end;

        with FXAxis do begin
            Pen.Color := FColor;
            Pen.Width := FWidth;
            n2 := Trunc(Height+FYAxis.FLow*yZoom);
            dx := Self.Width/FGridCount;
            if (FYAxis.FLow<0.0) and (FYAxis.FHigh>0.0) then begin
                MoveTo(0, n2); LineTo(Self.Width, n2);

                Dec(n2, smLine div 2);
                n3 := n2 + smLine; n1 := 0.0;
                for i := 0 to FGridCount do begin
                    MoveTo(Trunc(n1), n2); LineTo(Trunc(n1), n3);
                    n1 := n1 + dx;
                end;
            end;
        end;

        with FYAxis do begin
            Pen.Color := FColor;
            Pen.Width := FWidth;
            n2 := Trunc(-FXAxis.FLow*xZoom);
            dx := Self.Height/FGridCount;
            if (FXAxis.FLow<0.0) and (FXAxis.FHigh>0.0) then begin
                MoveTo(n2, 0); LineTo(n2, Height);

                Dec(n2, smLine div 2);
                n3 := n2 + smLine; n1 := 0.0;
                for i := 0 to FGridCount do begin
                    MoveTo(n2, Trunc(n1)); LineTo(n3, Trunc(n1));
                    n1 := n1 + dx;
                end;
            end;
        end;

        with FXAxis do begin
            if FNumbered then begin
                Font.Assign(Self.Font);
                dx := Self.Width/FGridCount;
                n1 := 0.0; d := FLow;
                n2 := Trunc(Height+FYAxis.FLow*yZoom)+smLine div 2;
                r := (FHigh-FLow)/FGridCount;
                for i := 0 to FGridCount do begin
                    s := FloatToStrF(d, ffFixed, 10, 2);
                    TextOut(Trunc(n1) - TextWidth(s) div 2, n2, s);
                    n1 := n1 + dx; d := d + r;
                end;
            end;
        end;

        with FYAxis do begin
            if FNumbered then begin
                Font.Assign(Self.Font);
                dx := Height/FGridCount;
                n1 := 0.0; d := FLow;
                n2 := Trunc(-FXAxis.FLow*xZoom)-smLine div 2-TextWidth('1000.00 ');
                n3 := TextHeight('1') div 2;
                r := (FHigh-FLow)/FGridCount;
                for i := 0 to FGridCount do begin
                    s := FloatToStrF(d, ffFixed, 10, 2);
                    TextOut(n2, Trunc(n1)-n3, s);
                    n1 := n1 + dx; d := d + r;
                end;
            end;
        end;
    end;

end;

procedure TKhXYPlot.DrawFunctionToBmp(Sender: TObject; const X, Y: Double);
begin
    with bmp.Canvas do begin
        if isStartDraw then begin
            MoveTo(Trunc(xZoom*(X-FXAxis.FLow)),
                Trunc(Height-yZoom*(Y-FYAxis.FLow))
            );
            isStartDraw := False;
        end else
        LineTo(Trunc(xZoom*(X-FXAxis.FLow)),
            Trunc(Height-yZoom*(Y-FYAxis.FLow))
        );
    end;
end;

procedure TKhXYPlot.DrawGraph;
var i: Integer;
    f: TKhXYPlotFunction;
    proc: TKhFunctionValueEvent; // pointer
begin
    DrawAxes;

    // KhFunctions
    if not (Classes.csDesigning in Self.ComponentState) then
    with bmp.Canvas do
    for i := 0 to FFunctions.Count-1 do begin
        f :=  TKhXYPlotFunction(FFunctions.Items[i]);
        if not Assigned(f.KhFunction) then Continue;
        Pen.Style := f.FPenStyle;
        Pen.Width := f.FWidth;
        Pen.Color := f.FColor;
        isStartDraw := True;
        proc := f.FKhFunction.FOnValue;
        f.FKhFunction.FOnValue := DrawFunctionToBmp;
        f.FKhFunction.Evaluate;
        f.FKhFunction.FOnValue := proc;
    end;
    Paint;
end;

procedure TKhXYPlot.Loaded;
begin
    inherited;
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlot.Notification(AComponent: TComponent; Operation: TOperation);
var i: Integer;
begin
    inherited;
    if (Operation=opRemove) then for i := 0 to FFunctions.Count-1 do
    if  (AComponent=FFunctions.Items[i].KhFunction) then
    FFunctions.Items[i].KhFunction := nil;
end;

procedure TKhXYPlot.Paint;
begin
    inherited; // can ignore, cause there's nothing
    Canvas.Draw(0, 0, bmp);
end;                              

procedure TKhXYPlot.Resize;
begin
    inherited;
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlot.SetAutoDrawGraph(Value: Boolean);
begin
    if (Value=FAutoDrawGraph) then exit;
    FAutoDrawGraph := Value;
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlot.SetAxesStyle(Value: TKhXYPloteAxesStyle);
begin
    if (Value=FAxesStyle) then exit;
    FAxesStyle := Value;
    //--
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlot.SetColor(Value: TColor);
begin
    if (Value=FColor) then exit;
    FColor := Value;
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlot.SetFont(Value: TFont);
begin
    if (Value=FFont) then exit;
    FFont.Assign(Value);
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlot.SetFunctions(Value: TKhXYPlotFunctions);
begin
    if (Value=FFunctions) then exit;
    FFunctions.Assign(Value);
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlot.SetXAxis(Value: TKhXYPlotAxis);
begin
    if (Value=FXAxis) then exit;
    FXAxis.Assign(Value);
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlot.SetYAxis(Value: TKhXYPlotAxis);
begin
    if (Value=FYAxis) then exit;
    FYAxis.Assign(Value);
    if FAutoDrawGraph then DrawGraph else begin
        DrawAxes; Paint;
    end;
end;

{ TKh1stOrderDiffEquation }

constructor TKh1stOrderDiffEquation.Create(AOwner: TComponent);
begin
    inherited;
    FMethod := demEuler;
end;

procedure TKh1stOrderDiffEquation.DoFunction(const X, Y: Double;
    var Fxy: Double);
begin
    if Assigned(FOnFunction) then FOnFunction(Self, X, Y, Fxy)
    else Fxy := 0.0;
end;

procedure TKh1stOrderDiffEquation.Evaluate;
var i: Cardinal;
    x, f, f0, f1, y, y1: Double;
begin
    if not Assigned(FOnValue) then exit;
    x := FInterval.FStart;
    DoFunction(FX0, FY0, f);
    y := FY0 + f*(x-FX0);
    FOnValue(Self, x, y);

    if (FMethod=demEuler) then begin
        for i := 1 to FStep.FCount do begin
            DoFunction(x, y, f);
            x := x + FStep.FSize;
            y := y + FStep.FSize*f;
            FOnValue(Self, x, y);
        end;
        exit;
    end;

    if (FMethod=demEulerCauchy) then begin
        y1 := y;
        for i := 1 to FStep.FCount do begin
            DoFunction(x, y1, f0);
            y := y1 + FStep.FSize*f0;
            x := x + FStep.FSize;
            DoFunction(x, y, f1);
            y1 := y1 + FStep.FSize*(f0+f1)*0.5;
            FOnValue(Self, x, y1);
        end;
        exit;
    end;
end;

{ TKhXYPlotFunction }

constructor TKhXYPlotFunction.Create(Collection: TCollection);
begin
    inherited;
    FColor := clRed;
    FPenStyle := psSolid;
    FWidth := 1;
end;

{ TKhXYPlotFunctions }

function TKhXYPlotFunctions.Add: TKhXYPlotFunction;
begin
    Result := TKhXYPlotFunction(inherited Add);
    Result.FOwnerXYPlot := TKhXYPlot(Owner);
end;

function TKhXYPlotFunctions.GetItem(AIndex: Integer): TKhXYPlotFunction;
begin
    Result := TKhXYPlotFunction(inherited Items[AIndex]);
end;

procedure TKhXYPlotFunctions.SetItem(AIndex: Integer;
    const AValue: TKhXYPlotFunction);
begin
    inherited SetItem(AIndex, AValue);
end;

{ TKhXYPlotAxis }

procedure TKhXYPlotAxis.SetColor(Value: TColor);
begin
    if (Value=FColor) then exit;
    FColor := Value;
    with FOwner do if FAutoDrawGraph then DrawGraph
    else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlotAxis.SetGridCount(Value: TKhXYPlotAxisGridCount);
begin
    if (Value=FGridCount) then exit;
    FGridCount := Value;
    with FOwner do if FAutoDrawGraph then DrawGraph
    else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlotAxis.SetGridLines(Value: Boolean);
begin
    if (Value=FGridLines) then exit;
    FGridLines := Value;
    with FOwner do if FAutoDrawGraph then DrawGraph
    else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlotAxis.SetHigh(Value: Double);
begin
    if (Value=FHigh) then exit;
    FHigh := Value;
    with FOwner do if FAutoDrawGraph then DrawGraph
    else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlotAxis.SetLow(Value: Double);
begin
    if (Value=FLow) then exit;
    FLow := Value;
    with FOwner do if FAutoDrawGraph then DrawGraph
    else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlotAxis.SetNumbered(Value: Boolean);
begin
    if (Value=FNumbered) then exit;
    FNumbered := Value;
    with FOwner do if FAutoDrawGraph then DrawGraph
    else begin
        DrawAxes; Paint;
    end;
end;

procedure TKhXYPlotAxis.SetWidth(Value: TKhPosInt);
begin
    if (Value=FWidth) then exit;
    FWidth := Value;
    with FOwner do if FAutoDrawGraph then DrawGraph
    else begin
        DrawAxes; Paint;
    end;
end;

end.
