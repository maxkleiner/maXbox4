// 3D Lab -- Show selected object from specified eye coordinates.
//
// Copyright (C) 1997-1998 Earl F. Glynn, Overland Park, KS.
// All Rights Reserved.  E-Mail Address:  EarlGlynn@att.net
// adapted to mX by max 2014

unit ScreenThreeDLab;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, Buttons;

type
  TFormLab3D = class(TForm)
    GroupBoxEyePosition: TGroupBox;
    LabelAzimuth: TLabel;
    SpinEditAzimuth: TSpinEdit;
    LabelElevation: TLabel;
    SpinEditElevation: TSpinEdit;
    LabelDistance: TLabel;
    SpinEditDistance: TSpinEdit;
    GroupBoxScreen: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    SpinEditScreenWidthHeight: TSpinEdit;
    SpinEditScreenToCamera: TSpinEdit;
    ComboBoxFigure: TComboBox;
    Panel3DLab: TPanel;
    Image: TImage;
    LabelFigureSelect: TLabel;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure SpinEditBoxChange(Sender: TObject);
    procedure ComboBoxFigureChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    Changing:  BOOLEAN;
    PROCEDURE ShowFigure;
  public
    { Public declarations }
  end;

var
  FormLab3D: TFormLab3D;

implementation
{$R *.DFM}
  USES
    GraphicsMathLibrary,        {TMatrix}
    GraphicsPrimitivesLibrary,  {TPantoGraph}
    DrawFigures;                {DrawCube}


procedure TFormLab3D.FormCreate(Sender: TObject);
  VAR
    Bitmap:  TBitmap;
begin
  Bitmap        := TBitmap.Create;
  Bitmap.Width  := Image.Width;
  Bitmap.Height := Image.Height;
  Image.Picture.Graphic := Bitmap;
  ComboBoxFigure.ItemIndex := 0;
  Changing := FALSE;
  ShowFigure
end;

PROCEDURE TFormLab3D.ShowFigure;
  VAR
    a         :  TMatrix;
    b         :  TMatrix;
    pantograph:  TPantoGraph;
    u         :  TVector;
BEGIN
  WITH Image DO
    Canvas.FillRect( Rect(0,0, Width, Height) );

  pantograph := TPantoGraph.Create(Image.Canvas);

  {Use whole canvas as viewport}
  pantograph.ViewPort (0.00,1.00, 0.00,1.00);

  TRY
    a := ViewTransformMatrix(
           coordSpherical,
           ToRadians(SpinEditAzimuth.Value),
           ToRadians(SpinEditElevation.Value),
           SpinEditDistance.Value,
           SpinEditScreenWidthHeight.Value,
           SpinEditScreenWidthHeight.Value,
           SpinEditScreenToCamera.Value);

    IF   ComboBoxFigure.ItemIndex = 4
    THEN BEGIN
      pantograph.WorldCoordinatesRange (0.00,5.00, 0.00,1.50);  {establish aspect ratio}

      // For football field, we need to translate the origin from the corner of the
      // field to the center of the field.
      u := Vector3D(-80.0, -180.0, 0.0);
      b := TranslateMatrix(u);

      // Multiply this translation matrix by the view transform matrix to get overall
      // 3D transform matrix.
      b := MultiplyMatrices(b, a);
      pantograph.SetTransform(b);
      pantograph.SetClipping(TRUE);
    END
    ELSE BEGIN
      {The ViewTransformMatrix is all that is needed for other objects defined
      in world coordinates.}
      pantograph.WorldCoordinatesRange (0.0, 1.0,  0.0, 1.0);
      pantograph.SetTransform(a);
    END;


    CASE ComboBoxFigure.ItemIndex OF
      0:  DrawCube (pantograph, clRed);

      1:  DrawSphere (pantograph,
                     {LatitudeColor}        clBlue,
                     {LongitudeColor}       clLime,
                     {LatitudeCircles}       9,
                     {LongitudeSemicircles} 25,
                     {PointsInCircle}       40);

      2:  BEGIN
            DrawCube (pantograph, clRed);
            DrawSphere (pantograph,
                       {LatitudeColor}        clBlue,
                       {LongitudeColor}       clLime,
                       {LatitudeCircles}       9,
                       {LongitudeSemicircles} 25,
                       {PointsInCircle}       40);
          END;

      3:  DrawSurface (pantograph);

      4:  DrawFootballField (pantograph, clLime, clPurple, clGray);

    END
  FINALLY
    pantograph.free
  END
END {ShowFigure};

procedure TFormLab3D.SpinEditBoxChange(Sender: TObject);
begin
  IF   NOT Changing
  THEN ShowFigure
end;

procedure TFormLab3D.BitBtn1Click(Sender: TObject);
begin
  Application.MessageBox('G-Code RS-274 Ultimaker2 driver does not exist.', 'Error', MB_ICONSTOP OR MB_OK);
end;

procedure TFormLab3D.ComboBoxFigureChange(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  TRY

    {Adjust "eye" coordinates so figure is as big as possible without clipping}

    CASE ComboBoxFigure.ItemIndex OF

      {Cube, Sphere, SphereInCube}
      0,1,2:  BEGIN
            Changing := TRUE;
            SpinEditAzimuth.Value     := 30;  {degrees}
            SpinEditElevation.Value   := 45;  {degrees}
            SpinEditDistance.Value    := 11;  {distance units}
            SpinEditScreenWidthHeight.Value := 10;
            SpinEditScreenToCamera.Value    := 30;
            Changing := FALSE;
          END;

      {z = f(x,y) surface}
      3:  BEGIN
            Changing := TRUE;
            SpinEditAzimuth.Value     := 30;  {degrees}
            SpinEditElevation.Value   := 45;  {degrees}
            SpinEditDistance.Value    := 17;  {distance units}
            SpinEditScreenWidthHeight.Value := 10;
            SpinEditScreenToCamera.Value    := 30;
            Changing := FALSE;
          END;

      {Football field}
      4:  BEGIN
            Changing := TRUE;
            SpinEditAzimuth.Value     := 90;  {degrees}
            SpinEditElevation.Value   := 30;  {degrees}
            SpinEditDistance.Value    := 225; {feet}

            {Use wide angle view}
            SpinEditScreenWidthHeight.Value := 5;
            SpinEditScreenToCamera.Value    := 2;
            Changing := FALSE;
          END;
    END;

    ShowFigure
  FINALLY
    Screen.Cursor := crDefault
  END
end;

end.
