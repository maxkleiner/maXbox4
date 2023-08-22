// Graphics Primitives Library including TPantograph non-visual object
//
// Copyright (C) 1982, 1985, 1992, 1995-1997 Earl F. Glynn, Overland Park, KS.
// All Rights Reserved.  E-Mail Address:  EarlGlynn@WorldNet.att.net


UNIT GraphicsPrimitivesLibrary;

INTERFACE

  USES
    Graphics,            // TColor, TCanvas
    ExtCtrls,            // TImage
    GraphicsMathLibrary, // TVector, TMatrix, etc.
    SysUtils,            // Exception
    WinTypes;            // TRect

  TYPE
    EGraphicsError = CLASS(Exception);

    // "ortho" = "orthographic" projection
    TProjection    = (pOrthoXY,pOrthoXZ,pOrthoYZ,pPerspective);

    TPositioning   = (positionAbsolute, positionRelative);

    // A PantoGraph object maps "World Coordinates" to a Delphi "Canvas".
    // These World Coordinates are DOUBLE values that are defined using
    // regular mathematical conventions.  This means that instead of having
    // increasing "Y" values as you go down a canvas, "Y" increases as you go
    // up using the computer "pantograph".
    TPantoGraph    =
      CLASS(TObject)
        PRIVATE
          iSave      :  INTEGER;
          jSave      :  INTEGER;

          vcx,vcy    :  DOUBLE;  // 3D projection center-size viewport parms
          vsx,vsy    :  DOUBLE;

          xform2D    :  TMatrix; // default 2D transformation matrix
          xform3D    :  TMatrix; // default 3D transformation matrix

          uSaveW     :  TVector; // last vector -- world coordinates
                                 // (used for relativePosition Positioning)
          uSaveX     :  TVector; // last vector -- transformed

          projection :  TProjection;
          ClipFlag   :  BOOLEAN;
          positioning:  TPositioning;
          coordinate :  TCoordinate;

        PROTECTED
          iMax       :  INTEGER;     // size of viewport in pixels
          jMax       :  INTEGER;

          iEast      :  INTEGER;     // ViewPort parameters
          iWest      :  INTEGER;
          jSouth     :  INTEGER;
          jNorth     :  INTEGER;

          xEast      :  DOUBLE;      // World Coordinates of Canvas
          xWest      :  DOUBLE;
          yNorth     :  DOUBLE;
          ySouth     :  DOUBLE;

          xPixel     :  DOUBLE;      // pixels per world unit horizontally
          yPixel     :  DOUBLE;      // pixels per world unit vertically

        PUBLIC
          Canvas     :  TCanvas;

          CONSTRUCTOR Create (CONST PantoCanvas:  TCanvas);
          DESTRUCTOR  Destroy;
            Override;

          PROCEDURE LineToIJ  (CONST i,j:  INTEGER);  // interface to TCanvas
          PROCEDURE MoveToIJ  (CONST i,j:  INTEGER);
          PROCEDURE PointAtIJ (CONST i,j:  INTEGER);
          PROCEDURE RectangleIJ (CONST i1,i2, j1,j2:  INTEGER);
          PROCEDURE SetColor (CONST color:  TColor);

          PROCEDURE LineTo  (CONST v:  TVector);      // draw 2D/3D vectors
          PROCEDURE MoveTo  (CONST v:  TVector);
          PROCEDURE PointAt (CONST v:  TVector);
          PROCEDURE Rectangle (CONST v1, v2:  TVector);

          PROCEDURE TextOutIJ (CONST i,j:  INTEGER; CONST Text:  STRING);
          PROCEDURE TextOut   (CONST v:    TVector; CONST Text:  STRING);

          PROCEDURE SetPositioning (CONST p:  TPositioning);  // Relative or Absolute
          PROCEDURE SetRelativeBase (CONST v:  TVector);

                                         // Clipping
          PROCEDURE Clip (VAR u1,u2:  TVector; VAR visible:  BOOLEAN);
          PROCEDURE SetClipping (CONST flag: BOOLEAN);

                                         // 3D-to-2D Projection
          PROCEDURE Project (CONST u:  TVector; VAR v:  TVector);
          PROCEDURE SetProjection (CONST PrjType:  TProjection);

                                         // Default Transformation Matrices
          PROCEDURE ClearTransform  (CONST d:  Tdimension);
          PROCEDURE GetTransform    (CONST d:  Tdimension; VAR a:  TMatrix);
          PROCEDURE SetTransform    (CONST a:  TMatrix);
          PROCEDURE VectorTransform (CONST u:  TVector; VAR v:  TVector);

                                         // Windows / Viewports
          PROCEDURE WorldCoordinatesRange (CONST xMin, xMax, yMin, yMax:  DOUBLE);
          PROCEDURE ViewPort (CONST xFractionMin, xFractionMax,
                              yFractionMin, yFractionMax:  DOUBLE);
          PROCEDURE ShowViewPortOutline;

                                         // World/Pixel Coordinate Conversion
          PROCEDURE WorldToPixel (CONST v:  TVector; VAR i,j:  INTEGER);
          PROCEDURE PixelToWorld (CONST i,j:  INTEGER; VAR visible:  BOOLEAN;
                                  VAR x,y:  DOUBLE);

                                         // Set coordinate type
          PROCEDURE SetCoordinateType (CONST c:  Tcoordinate);

      END;


IMPLEMENTATION

  USES
    Dialogs;   {MessageDlg}

// ******************  Constructor / Destructor ***********************

  CONSTRUCTOR TPantoGraph.Create (CONST PantoCanvas:  TCanvas);
  BEGIN
    INHERITED Create;

    Canvas := PantoCanvas;

    iMax := Canvas.ClipRect.Right  - 1;
    jMax := Canvas.ClipRect.Bottom - 1;

    SetClipping (TRUE);
    SetPositioning (positionAbsolute);
    ClearTransform (dimen2D);
    ClearTransform (dimen3D);
    SetProjection (pPerspective);
    coordinate := coordCartesian;

    xWest  := 0.0;      // Default 2D World Coordinates
    xEast  := 1.0;
    ySouth := 0.0;
    yNorth := 1.0;

    vcx := 0.5;         // 3D project center-size viewport parms
    vcy := 0.5;
    vsx := 0.5;
    vsy := 0.5;

    ViewPort (0.0,1.0, 0.0,1.0);         // Viewport maps to entire Plot Area
    uSaveW := Vector3D(0.0, 0.0, 0.0);   // for positionRelative Positioning
  END {Create};


  DESTRUCTOR TPantoGraph.Destroy;
  BEGIN
    INHERITED Destroy;
  END {Destroy};


//******************  LineToIJ / MoveToIJ / PointAtIJ  ***************

  PROCEDURE TPantoGraph.LineToIJ (CONST i,j:  INTEGER);
  BEGIN
    // Fix the "problem" in the direction of the "Y" axis.
    Canvas.MoveTo (iSave, jMax - jSave);
    Canvas.LineTo (i, jMax - j);
    iSave := i;
    jSave := j
  END {LineToIJ};


  PROCEDURE TPantoGraph.MoveToIJ (CONST i,j:  INTEGER);
  BEGIN
    iSave := i;
    jSave := j;
  END {MoveToIJ};


  PROCEDURE TPantoGraph.PointAtIJ (CONST i,j:  INTEGER);
    VAR
      temp:  INTEGER;
  BEGIN
    // Fix the "problem" with the "wrong" direction of the "Y" axis.
    temp := jMax - j;
    Canvas.Pixels[i, temp] := Canvas.Pen.Color;
    MoveToIJ (i, temp);
  END {PointAtIJ};


  PROCEDURE TPantoGraph.RectangleIJ (CONST i1,i2, j1,j2:  INTEGER);
  BEGIN
    // RectangleIJ asumes
    //     (i1,j1) is at the lower left and
    //     (i2,j2) is at the upper right.
    //
    // The Canvas.Rectangle procedure assumes
    //     (X1,Y1) at upper left and
    //     (X2,Y2) at the lower right.
    //
    // So, (X1,Y1) = (i1,j2) and (X2,Y2) = (i2,j1)

    Canvas.Rectangle (i1, jMax-j2, i2, jMax-j1);
  END {RectangleIJ};


  PROCEDURE TPantoGraph.SetColor (CONST color:  TColor);
  BEGIN
    Canvas.Pen.Color := color
  END {SetColor};


// ******************  LineTo / MoveTo / PointAt    *******************

  PROCEDURE TPantoGraph.LineTo (CONST v:  TVector);

  // "LineTo" draws a straight line from the current screen position to
  // a new point and resets the current screen position.  Transformation
  // of the point can automatically occur (see note for "MoveTo" above).
  // Pixels traced over by the line segement are automatically selected.
  // Clipping of the line segment to the view boundary can also automatically
  // occur.

    VAR
      flag     :  BOOLEAN;
      i        :  INTEGER;
      j        :  INTEGER;
      uNew,uOld:  TVector;
      visible  :  BOOLEAN;
      u        :  TVector;

  BEGIN
    u := v;  // because v is CONST

    IF   positioning = positionRelative   // Adjustment for relative positioning
    THEN BEGIN
      u := AddVectors(uSaveW, u);
      uSaveW := u
    END;

    u := ToCartesian (coordinate,u);
    VectorTransform (u,u);

    IF   ClipFlag
    THEN BEGIN
      uOld := uSaveX;
      uNew := u;
      clip (uOld,uNew, visible);
      IF   visible
      THEN BEGIN
        flag := (uOld.x <> uSaveX.x)  OR  (uOld.y <> uSaveX.y);
        IF   uOld.Size = size3D
        THEN flag := flag OR (uOld.z <> uSaveX.z);
        IF   flag
        THEN BEGIN
          WorldToPixel (uOld, i,j);
          MoveToIJ (i,j)
        END;
        WorldToPixel (uNew, i,j);
        LineToIJ (i,j)
      END
    END
    ELSE BEGIN
      WorldToPixel (u, i,j);
      LineToIJ (i,j)
    END;
    uSaveX := u
  END {LineTo};


  PROCEDURE TPantoGraph.MoveTo (CONST v:  TVector);

    // "MoveTo" sets the current screen position.  This position is defined
    // in user-defined world units.  Transformation of the point automatically
    // occurs if a transformation matrix was defined for the dimensionality
    // ("dimen2D" or "dimen3D") of the point.

    VAR
      i,j:  INTEGER;
      u  :  TVector;

  BEGIN
    u := v;

    IF   positioning = positionRelative   // Adjustment for relative positioning
    THEN BEGIN
      u := AddVectors(uSaveW, u);
      uSaveW := u
    END;

    u := ToCartesian (coordinate,u);
    VectorTransform (u,uSaveX);
    WorldToPixel (uSaveX, i,j);
    IF   ClipFlag
    THEN BEGIN
      IF   (i >= iWest) AND (i <= iEast) AND (j >= jSouth) AND (j <= jNorth)
      THEN MoveToIJ (i,j)
    END
    ELSE MoveToIJ (i,j)
  END {MoveTo};


  PROCEDURE TPantoGraph.PointAt (CONST v:  TVector);

    // A 'point' could be considered an extremely 'short' line segment.

    VAR
      i,j:  INTEGER;
      u  :  TVector;

  BEGIN
    u := v;

    IF   positioning = positionRelative   // Adjustment for relative positioning
    THEN BEGIN
      u := AddVectors(uSaveW, u);
      uSaveW := u
    END;

    u := ToCartesian (coordinate,u);
    VectorTransform (u,uSaveX);
    WorldToPixel (uSaveX, i,j);
    IF   ClipFlag
    THEN BEGIN
      IF   (i >= iWest) AND (i <= iEast) AND (j >= jSouth) AND (j <= jNorth)
      THEN PointAtIJ (i,j)
    END
    ELSE PointAtIJ (i,j)
  END {PointAt};


  PROCEDURE TPantoGraph.Rectangle (CONST v1, v2:  TVector);
    VAR
      i1:  INTEGER;
      i2:  INTEGER;
      j1:  INTEGER;
      j2:  INTEGER;

      u1:  TVector;
      u2:  TVector;
  BEGIN
    u1 := v1;
    u2 := v2;

    IF   positioning = positionRelative   // Adjustment for relative positioning
    THEN BEGIN
      u1 := AddVectors(uSaveW, u1);
      u2 := AddVectors(u1, u2);
      uSaveW := u2
    END;

    u1 := ToCartesian (coordinate,u1);
    VectorTransform (u1,u1);
    WorldToPixel (u1, i1,j1);

    u2 := ToCartesian (coordinate,u2);
    VectorTransform (u2,u2);
    WorldToPixel (u2, i2,j2);

    RectangleIJ (i1, i2, j1, j2);
  END {Rectangle};


// ******************  TPantoGraph.TextOut  ***************************

 PROCEDURE TPantoGraph.TextOutIJ (CONST i,j:  INTEGER; CONST Text:  STRING);
 BEGIN
   Canvas.TextOut (i, jMax - j - Canvas.TextHeight(Text), Text);
 END {OutTextIJ};


 PROCEDURE TPantoGraph.TextOut (CONST v:  TVector; CONST Text:  STRING);
   VAR
     i,j:  INTEGER;
 BEGIN
    WorldToPixel (v, i,j);
    Canvas.TextOut (i, jMax - j - Canvas.TextHeight(Text), Text);
 END {OutText};


// ******************  Absolute/Relative Positioning  *****************

  PROCEDURE TPantoGraph.SetPositioning (CONST p:  TPositioning);
  BEGIN
    positioning := p
  END {SetPositioning};


 PROCEDURE TPantoGraph.SetRelativeBase (CONST v:  TVector);
 // SetRelativeBase should be called BEFORE calling
 // SetPositioning (positionRelative).
 BEGIN
   uSaveW := v;
   MoveTo (uSaveW)
 END {SetRelativeBase};


//************************    C l i p p i n g   **********************

  PROCEDURE TPantoGraph.Clip (VAR u1,u2:  TVector; VAR visible:  BOOLEAN);

    // "Clip" integrates both two- and three-dimensional clipping into a
    // single procedure.  The input parameters are of the type "vector" and
    // internally have their dimensionality defined.  These clipping algorithms
    // were adapted from Newman and Sproull, "Principles of Interactive
    // Computer Graphics", Second Edition, pp. 66-67 for 2D and p. 345 for 3D.
    // The Newman and Sproull internal "code" procedure was replaced by a
    // "region" procedure for clarity.  For example, the code '1001' is
    // replaced by a set of Regions [North West]. See diagram below.  Also,
    // see pp. 144-148 and 295-297 of "Fundamentals of Interactive Computer
    // Graphics" by Foley and Van Dam.

    TYPE
      Regions   = (North,South,East,West);
      RegionSet = SET OF Regions;

    VAR
      reg,reg1,reg2:  RegionSet;
      u            :  TVector;

    PROCEDURE Region (u:  TVector; VAR reg: RegionSet);
      // This procedure is internal to "clip".  "Region" defines the regions
      // a given point is in.  If the set of regions is the null set [], then
      // the point is in the viewing area.  If the union of regions from both
      // points is the empty set, the segment is entirely visible. If the
      // intersection of regions from two different points is not the empty
      // set, the segment must lie entirely off the screen.
    BEGIN
      reg := [];
      CASE u.size OF                  // Picture and surrounding regions:
        size2D:
          BEGIN
            IF   u.x < xWest          // [North West] |  [North]  | [North East]
            THEN reg := [West]        // -------------+-----------+-------------
            ELSE                      //     [West]   |    []     |   [East]
              IF  u.x > xEast         // -------------+-----------+-------------
              THEN reg := [East];     // [South West] |  [South]  | [South East]
            IF   u.y < ySouth
            THEN reg := reg + [South]
            ELSE
              IF  u.y > yNorth
              THEN reg := reg + [North]
          END {size2D};

        size3D:
          BEGIN
            IF   u.x < -u.z
            THEN reg := [West]
            ELSE
              IF  u.x > u.z
              THEN reg := [East];
              IF   u.y < -u.z
              THEN reg := reg + [South]
              ELSE
                IF  u.y > u.z
                THEN reg := reg + [North]
          END {size3D}
      END {CASE}
    END {Region};


    PROCEDURE Clip2D;

      // This code is used only for clipping two-dimensional vectors.

      VAR
        deltaX:  DOUBLE;
        deltaY:  DOUBLE;

    BEGIN
      deltaX := u2.x-u1.x;             // x2 - x1
      deltaY := u2.y-u1.y;             // y2 - y1
      IF   West IN reg                 // crosses West edge
      THEN u := Vector2D (xWest, u1.y + deltaY*(xWest-u1.x)/deltaX)
      ELSE
        IF   East IN reg               // crosses East edge
        THEN u := Vector2D (xEast, u1.y + deltaY*(xEast-u1.x)/deltaX)
        ELSE
          IF   South IN reg            // crosses South edge
          THEN u := Vector2D (u1.x + deltaX*(ySouth-u1.y)/deltaY, ySouth)
          ELSE
            IF   North IN reg          // crosses North edge
            THEN u := Vector2D (u1.x + deltaX*(yNorth-u1.y)/deltaY, yNorth);
    END {Clip2D};


    PROCEDURE Clip3D;

      // This code is used only for clipping three-dimensional vectors.

      VAR
        t,z:  DOUBLE;

    BEGIN
      IF   West IN reg                 // crosses West edge
      THEN BEGIN
        t := (u1.z+u1.x) / ((u1.x-u2.x)-(u2.z-u1.z));
        z := t*(u2.z-u1.z)+u1.z;
        u := Vector3D (-z, t*(u2.y-u1.y)+u1.y, z)
      END
      ELSE
        IF   East IN reg               // crosses East edge
        THEN BEGIN
          t := (u1.z-u1.x) / ((u2.x-u1.x)-(u2.z-u1.z));
          z := t*(u2.z-u1.z)+u1.z;
          u := Vector3D (z, t*(u2.y-u1.y)+u1.y, z)
        END
        ELSE
          IF  South IN reg             // crosses South edge
          THEN BEGIN
            t := (u1.z+u1.y) / ((u1.y-u2.y)-(u2.z-u1.z));
            z := t*(u2.z-u1.z)+u1.z;
            u := Vector3D (t*(u2.x-u1.x)+u1.x, -z, z)
          END
          ELSE
            IF  North IN reg           // crosses North edge
            THEN BEGIN
              t := (u1.z-u1.y) / ((u2.y-u1.y)-(u2.z-u1.z));
              z := t*(u2.z-u1.z)+u1.z;
              u := Vector3D (t*(u2.x-u1.x)+u1.x, z, z)
            END
    END {Clip3D};

  BEGIN {clip}
    Region (u1,reg1);
    Region (u2,reg2);
    visible := reg1*reg2 = [];
    WHILE ((reg1 <> []) OR (reg2 <> [])) AND visible DO
    BEGIN
      reg := reg1;

      IF   reg = []
      THEN reg := reg2;
      CASE u1.size OF
        3:  Clip2D;
        4:  Clip3D
      END;

      IF   reg = reg1
      THEN BEGIN
        u1 := u;
        Region (u,reg1)
      END
      ELSE BEGIN
        u2 := u;
        Region (u,reg2)
      END;

      visible :=  reg1*reg2 = []
    END {WHILE}
  END {clip};


  PROCEDURE TPantoGraph.SetClipping (CONST flag:  BOOLEAN);
    // This procedure sets the clipping flag to a specified value.  When TRUE
    // is specified, the "Clip" procedure will be used following any "LineTo"
    // calls.
  BEGIN
    ClipFlag := flag
  END {SetClipping};


//********************    3D-to-2D Projection   **********************

  PROCEDURE TPantoGraph.Project (CONST u:  TVector; VAR v:  TVector);
    // A three-dimensional vector is projected into two dimensions with this
    // procedure. Orthograpic or perspective projections can be specified with
    // the "SetTProjection" procedure.
  BEGIN
    IF  u.size = size3D
    THEN BEGIN
      CASE projection OF
        pOrthoXY:
          BEGIN
            v.x := u.x;
            v.y := u.y
          END;

        pOrthoXZ:
          BEGIN
            v.x := u.x;
            v.y := u.z
          END;

        pOrthoYZ:
          BEGIN
            v.x := u.y;
            v.y := u.z
          END;

        pPerspective:
          BEGIN
            IF   defuzz(u.z) = 0.0
            THEN BEGIN       // avoid division by zero
              v.x := vcx;    // visible viewing screen is only a point
              v.y := vcy
            END
            ELSE BEGIN
              v.x := vcx + vsx*u.x/u.z;
              v.y := vcy + vsy*u.y/u.z
            END
          END
      END {CASE};
      v.size := size2D;      // now a 2D vector
      v.z := 1.0             // last component of 2D homogenous coordinate
    END
    ELSE
      v.size := sizeUndefined              // not a 3D vector
  END {Project};


  PROCEDURE TPantoGraph.SetProjection (CONST PrjType:  TProjection);
  BEGIN
    projection := PrjType
  END {SetTProjection};


//****************    Default Transformation Matrices   **************

  PROCEDURE TPantoGraph.ClearTransform (CONST d:  Tdimension);
    // "ClearTransform" sets the "size" of the "dimen2D" or "dimen3D"
    // transformation matrix in the parameter prefix to 1.  When the "Size" of the
    // matrix is 1, it is not automatically used when "MoveTo" or "LineTo" is
    // invoked.  "ClearTransform" removes the effect of the "SetTransform"
    // matrix.
  BEGIN
    CASE d OF
      dimen2D:  xform2D.size := 1;
      dimen3D:  xform3D.size := 1
    END
  END {ClearTransform};


  PROCEDURE TPantoGraph.GetTransform (CONST d:  Tdimension; VAR a:  TMatrix);
    // The default "dimen2D" or "dimen3D" transformation matrix can be retreived
    // using "GetTransform" for inspection or further modification using other
    // matrix operations.
  BEGIN
    CASE d OF
      dimen2D:  a := xform2D;
      dimen3D:  a := xform3D
    END
  END  {GetTransform};


  PROCEDURE TPantoGraph.SetTransform (CONST a:  TMatrix);
    // "SetTransform" establishes a default "dimen2D" or "dimen3D" transformation
    // matrix which is used every time "MoveTo" or "LineTo" is invoked.  The
    // transformation matrix can be changed any number of times.  "ClearTransform"
    // removes the effect of the matrix.  Alternately, an identity transformation
    // matrix could be specified.
  BEGIN
    CASE a.size OF
      size2D:  xform2D := a;
      size3D:  xform3D := a
    END
  END {SetTransfrom};


  PROCEDURE TPantoGraph.VectorTransform  (CONST u:  TVector; VAR v:  TVector);
    // "VectorTransform" is used by "MoveTo" and "LineTo" to automatically
    // multiply a "vector" by a default transformation matrix if one has
    // been defined.
  BEGIN
    CASE u.size OF
      sizeUndefined:
        v.size := sizeUndefined;
      size2D:
        IF   xform2D.size = size2D
        THEN v := Transform (u,xform2D)
        ELSE v := u;
      size3D:
        IF   xform3D.size = size3D
        THEN v := Transform (u,xform3D)
        ELSE v := u
    END {CASE}
  END {VectorTransform};


// ********************    Windows / Viewports   **********************

  PROCEDURE vwParmError (CONST title:  STRING;
                         CONST xMin,xMax,yMin,yMax:  DOUBLE);
    // This procedure reports definition errors in setting the "View" or
    // "Window".
  BEGIN
    MessageDlg(title + #$0D +
               'xMin =' + FormatFloat('0.00',xMin) + '  ' +
               'xMax =' + FormatFloat('0.00',xMax) + '  ' + #$0D +
               'yMin =' + FormatFloat('0.00',yMin) + '  ' +
               'yMax =' + FormatFloat('0.00',yMax),
               mtError, [mbOK], 0);
    RAISE EGraphicsError.Create ('Window/Viewport Error')
  END {vwParmError};


  PROCEDURE TPantoGraph.WorldCoordinatesRange (CONST xMin, xMax,
                                                     yMin, yMax:  DOUBLE);
  BEGIN
    IF  (xMax <= xMin) OR (yMax <= yMin)
    THEN vwParmError ('Window parameter error(s):',xMin,xMax,yMin,yMax);

    xWest  := xMin;
    xEast  := xMax;
    ySouth := yMin;
    yNorth := yMax;

    vcx := 0.5 * (xEast  + xWest ); {3D projection parameters}
    vcy := 0.5 * (yNorth + ySouth);
    vsx := 0.5 * (xEast  - xWest);
    vsy := 0.5 * (yNorth - ySouth);

    xPixel := (iEast - iWest)   / (xEast - xWest);
    yPixel := (jNorth - jSouth) / (yNorth - ySouth);
    uSaveX := Vector2D (xWest,ySouth);
    MoveToIJ (iWest,jSouth);
  END {WorldCoordinatesRange};


  PROCEDURE TPantoGraph.ViewPort (CONST xFractionMin, xFractionMax,
                                        yFractionMin, yFractionMax:  DOUBLE);
  BEGIN
    IF  (xFractionMin < 0.0)  OR  (xFractionMax > 1.0)  OR
        (yFractionMin < 0.0)  OR  (yFractionMax > 1.0)  OR
        (xFractionMax <= xFractionMin) OR
        (yFractionMax <= yFractionMin)
    THEN vwParmError ('View parameter error(s):',
                      xFractionMin,xFractionMax,yFractionMin,yFractionMax);

    iWest  := ROUND(xFractionMin * iMax);
    iEast  := ROUND(xFractionMax * iMax);
    jSouth := ROUND(yFractionMin * jMax);
    jNorth := ROUND(yFractionMax * jMax);

    xPixel := (iEast - iWest)   / (xEast - xWest);
    yPixel := (jNorth - jSouth) / (yNorth - ySouth);
    uSaveX := Vector2D (xWest,ySouth);
    MoveToIJ (iWest,jSouth);
  END {ViewPort};


  PROCEDURE TPantoGraph.ShowViewPortOutline;
  BEGIN
    MoveToIJ (iWest, jSouth);
    LineToIJ (iEast, jSouth);
    LineToIJ (iEast, jNorth);
    LineToIJ (iWest, jNorth);
    LineToIJ (iWest, jSouth)
  END {ShowViewPortOutline};


// *************   World/Pixel Coordinate Conversion   ****************

  PROCEDURE TPantoGraph.WorldToPixel (CONST v: TVector; VAR i,j:  INTEGER);

    // This procedure converts a 2D/3D 'vector' into pixel indices.  A three-
    // dimensional vector is projected into two dimensions automatically.
    // The user-defined world coordinates are used in specifying the 'vector'.
    // The pixel indices are determined by the definition of the Viewport and
    // Window.

    VAR
      u:  TVector;

  BEGIN
    u := v;

    IF   u.size = size3D
    THEN Project (u,u);

    i := iWest  + ROUND(xPixel * (u.x - xWest) );
    j := jSouth + ROUND(yPixel * (u.y - ySouth));
  END {WorldToPixel};


//*************   Pixel-to-World Coordinate Conversion   *************

  PROCEDURE TPantoGraph.PixelToWorld (CONST i,j:  INTEGER;
                                      VAR visible:  BOOLEAN;
                                      VAR x,y:  DOUBLE);
  BEGIN

    // Use "jMax-j" instead of "j" since Pantograph reverses "y" direction
    IF   (i >= iWest)         AND (i <= iEast)         AND
         (jMax - j >= jSouth) AND (jMax - j <= jNorth)
    THEN BEGIN
      visible := TRUE;
      x := (i - iWest )/xPixel + xWest;
      y := ((jMax - j) - jSouth)/yPixel + ySouth;
    END
    ELSE BEGIN
      visible := FALSE;
      x := 0;  {use this value when not visible}
      y := 0;
    END
  END {PixelToWorld};


//******************  Set Type of Coordinates  ***********************

  PROCEDURE TPantoGraph.SetCoordinateType (CONST c:  Tcoordinate);
  BEGIN
    coordinate := c
  END {SetCoordType};


END {GraphicsPrimitives UNIT}.
