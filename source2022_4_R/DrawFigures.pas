// Draw Sphere, Cube, and z = f(x,y) surface, and football field using
// Pantograph object to map world coordinates to canvas.
//
// Copyright (C) 1997 Earl F. Glynn, Overland Park, KS.
// All Rights Reserved.  E-Mail Address:  EarlGlynn@WorldNet.att.net

UNIT DrawFigures;

INTERFACE

  USES
    Graphics,                   // TColor
    GraphicsPrimitivesLibrary;  // TPantoGraph, MoveTo, LineTo

  PROCEDURE DrawCube(CONST PantoGraph:  TPantoGraph; CONST color:  TColor);

  PROCEDURE DrawSphere (CONST PantoGraph:  TPantoGraph;
                        CONST LatitudeColor,
                              LongitudeColor:  TColor;
                        CONST LatitudeCircles,
                              LongitudeSemicircles,
                              PointsInCircle:  WORD);

  PROCEDURE DrawSurface (CONST PantoGraph:  TPantoGraph);

  PROCEDURE DrawFootballField (CONST PantoGraph:  TPantoGraph;
                               CONST ColorField, ColorLetters, ColorGoals:  TColor);


IMPLEMENTATION

  USES
    GraphicsMathLibrary; // Vector3D

  CONST
    N      = 40;         // constants used with surface
    xfirst = -2.0;
    xlast  =  2.0;
    yfirst = -2.0;
    ylast  =  2.0;

  VAR
    z:  ARRAY[0..N,0..N] OF DOUBLE;   {z = f(x,y)}

  // ---  Cube  -----------------------------------------------------

  PROCEDURE DrawCube(CONST PantoGraph:  TPantoGraph; CONST color:  TColor);
  BEGIN
    WITH PantoGraph DO
    BEGIN
      SetColor(color);
      SetCoordinateType(coordCartesian);

      MoveTo( Vector3D( 1, 1, 1) );
      LineTo( Vector3D(-1, 1, 1) );
      LineTo( Vector3D(-1,-1, 1) );
      LineTo( Vector3D( 1,-1, 1) );
      LineTo( Vector3D( 1, 1, 1) );

      LineTo( Vector3D( 1, 1,-1) );
      LineTo( Vector3D(-1, 1,-1) );
      LineTo( Vector3D(-1,-1,-1) );
      LineTo( Vector3D( 1,-1,-1) );
      LineTo( Vector3D( 1, 1,-1) );

      MoveTo( Vector3D(-1, 1,-1) );
      LineTo( Vector3D(-1, 1, 1) );

      MoveTo( Vector3D(-1,-1, 1) );
      LineTo( Vector3D(-1,-1,-1) );

      MoveTo( Vector3D( 1,-1,-1) );
      LineTo( Vector3D( 1,-1, 1) );
    END
  END {Cube};


  // ---  Sphere  ---------------------------------------------------

  PROCEDURE DrawSphere (CONST PantoGraph:  TPantoGraph;
                        CONST LatitudeColor,
                              LongitudeColor:  TColor;
                        CONST LatitudeCircles,
                              LongitudeSemicircles,
                              PointsInCircle:  WORD);
    VAR
      arcdelta:  DOUBLE;
      i,j     :  INTEGER;
      phi     :  DOUBLE;
      r       :  DOUBLE;
      theta   :  DOUBLE;
  BEGIN
    // All points here are in spherical coordinates:
    //
    // (r, theta, phi)
    //
    //   r       distance from origin
    //
    //   theta   "longitude" angle, which ranges from 0..2*PI radians
    //                                               (0..360 degrees)
    //           The "theta" angle is the angle in the X-Y plane,
    //           where angle 0 starts at the X axis.
    //
    //   phi     "latitude" angle, which ranges from -PI/2 .. PI/2 radians
    //                                                 (-90..90 degrees)

    PantoGraph.SetCoordinateType (coordSpherical);

    r := 1.0;
    arcdelta := 360.0 / PointsInCircle;  // Approximate arc of "arcdelta" degrees
                                         // by line segment while drawing circle

    PantoGraph.SetColor(LatitudeColor);
    FOR j := 1 TO LatitudeCircles DO
    BEGIN
      phi := ToRadians(180.0/(LatitudeCircles+1) * j {degrees} );
      PantoGraph.MoveTo( Vector3D(r,0,phi) );
      FOR i := 1 TO PointsInCircle DO
      BEGIN
        theta := ToRadians(arcdelta * i {degrees});
        PantoGraph.LineTo( Vector3D(r,theta,phi) )
      END
    END;

    pantograph.SetColor(LongitudeColor);
    FOR i := 1 TO LongitudeSemicircles DO
    BEGIN
      theta := ToRadians(360.0/LongitudeSemicircles * i {degrees});
      PantoGraph.MoveTo( Vector3D(r,theta,0) );
      FOR j := 1 TO PointsInCircle DIV 2 DO  {only draw semicircle here}
      BEGIN
        phi := ToRadians(arcdelta * j {degrees});
        PantoGraph.LineTo( Vector3D(r,theta,phi) )
      END
    END;
  END {DrawSphere};


  // ---  Surface ---------------------------------------------------

  PROCEDURE CreateSurfacePoints;
    VAR
      denom    :  DOUBLE;
      i,j      :  0..N;
      x,   y   :  DOUBLE;
      xsq, ysq :  DOUBLE;
      xinc,yinc:  DOUBLE;
  BEGIN
    xinc := (xlast-xfirst)/N;
    yinc := (ylast-yfirst)/N;

    FOR j := N DOWNTO 0 DO
    BEGIN
      y := yfirst + yinc*j;
      ysq := SQR(y);
      FOR i := 0 TO N DO
      BEGIN
        x := xfirst + xinc*i;
        xsq := SQR(x);
        denom := xsq+ysq;
        IF   defuzz(denom) = 0.0
        THEN z[i,j] := 0.0
        ELSE z[i,j] := x * y * (xsq-ysq) / denom;
      END
    END
  END {CreateSurfacePoints};


  PROCEDURE DrawSurface (CONST Pantograph:  TPantoGraph);
    VAR
      i,j:   0..N;
      u  :   TVector;
      x,y:   DOUBLE;
      xinc:  DOUBLE;
      yinc:  DOUBLE;
  BEGIN
   Pantograph.Canvas.Pen.Color := clBlue;

    xinc := (xlast-xfirst)/N;
    yinc := (ylast-yfirst)/N;

    FOR i := 0 TO N DO BEGIN
      x := xfirst + xinc*i;
      FOR j := 0 TO N DO BEGIN
        y := yfirst + yinc*j;
        u := Vector3D (x,y,z[i,j]);
        IF   j = 0
        THEN pantograph.MoveTo (u)
        ELSE pantograph.LineTo (u)
      END
    END;

    FOR j := 0 TO N DO
    BEGIN
      y := yfirst + yinc*j;
      FOR i := 0 TO N DO
      BEGIN
        x := xfirst + xinc*i;
        u := Vector3D(x,y,z[i,j]);
        IF   i = 0
        THEN pantograph.MoveTo (u)
        ELSE pantograph.LineTo (u)
      END
    END
  END {DrawSurface};


  // ---  Football Field --------------------------------------------

  PROCEDURE DrawFootballField (CONST PantoGraph:  TPantoGraph;
                               CONST ColorField, ColorLetters, ColorGoals:  TColor);


    PROCEDURE FieldDefinition (CONST area:  TPantograph);
      VAR
        i,j :  INTEGER;
        feet:  DOUBLE;

      PROCEDURE M (x,y:  DOUBLE);
      BEGIN
         area.MoveTo ( Vector3D(x,y,0) )
      END {M};


      PROCEDURE L (x,y:  DOUBLE);
      BEGIN
        area.LineTo ( Vector3D(x,y,0) )
      END {L};


      PROCEDURE EndzoneAnnotation;
      BEGIN
        Pantograph.Canvas.Pen.Color := ColorLetters;
        // "south" endzone annotation:  upside-down WILDCATS
        {"S"}  M (5,5);     L (20,5);     L (20,15);    L (5,15);
               L (5,25);    L (20,25);
        {"T"}  M (25,5);    L (40,5);     M (32.5,5);   L (32.5,25);
        {"A"}  M (45,25);   L (52.5,5);   L (60,25);    M (49,15);
               L (56,15);
        {"C"}  M (65,5);    L (80,5);     L (80,25);    L (65,25);
        {"D"}  M (85,10);   L (90,5);     L (100,5);    L (100,25);
               L (90,25);   L (85,20);    L (85,10);
        {"L"}  M (105,25);  L (120,25);   L (120,5);
        {"I"}  M (127.5,5); L (127.5,25);
        {"W"}  M (135,5);   L (140,25);   L (145,15);   L (150,25);
               L (155,5);

        // "north" endzone annotation:  K-STATE
        {"K"}  M (6,335);   L (6,355);    M (6,343);    L (25,355);
               M (10,345);  L (25,335);
        {"-"}  M (26,345);  L (32,345);
        {"S"}  M (39,335);  L (58,335);   L (58,345);   L (39,345);
               L (39,355);  L (58,355);
        {"T"}  M (63,355);  L (82,355);   M (72.5,335); L (72.5,355);
        {"A"}  M (87,335);  L (96.5,355); L (106,335);  M (92,345);
               L (101,345);
        {"T"}  M (111,355); L (130,355);  M (120.5,355);
               L (120.5,335);
        {"E"}  M (154,335); L (135,335);  L (135,355);  L (154,355);
               M (135,345); L (150,345)

      END {EndzoneAnnotation};


      PROCEDURE NumberYardLines;
        VAR
          i,j :  INTEGER;
          feet:  DOUBLE;

        PROCEDURE number (n:  INTEGER; x,y,size:  DOUBLE);
          VAR
            half:  DOUBLE;
        BEGIN
          half := 0.50 * size;
          CASE n OF
            0:  BEGIN
                  M (x,y);
                  L (x+size,y);
                  L (x+size,y+size);
                  L (x,y+size); L (x,y)
                END;

            1:  BEGIN
                  M (x,y);
                  L (x+size,y)
                END;

            2:  BEGIN
                  M (x,y); L (x,y+size); L (x+half,y+size);
                  L (x+half,y); L (x+size,y); L (x+size,y+size)
                END;

            3:  BEGIN
                M (x,y+size); L (x,y);  L (x+size,y);
                L (x+size,y+size); M (x+half,y); L (x+half,y+size);
                END;

            4:  BEGIN
                  M (x,y); L(x+size,y); M (x+half,y);
                  L(x+half,y+size); L (x+size,y+size)
                END;

            5:  BEGIN
                  M (x,y+size); L (x,y); L (x+half,y); L (x+half,y+size);
                  L (x+size,y+size); L (x+size,y)
                END
          END
        END {number};

      BEGIN {NumberYardsLines}
        feet := 60;
        FOR i := 1 TO 9 DO
        BEGIN
          IF   i > 5
          THEN j := 10-i
          ELSE j := i;
          number (j, 10,feet+2,+3);
          number (0, 10,feet-5,+3);
          number (j,150,feet-2,-3);
          number (0,150,feet+5,-3);
          feet := feet+30
        END;
      END {NumberYardLines};

    BEGIN  {FieldDefinition}
      Pantograph.Canvas.Pen.Color := ColorField;
      M (0,0); L(160,0);            // "south" endzone boundary

      feet := 30;
      FOR i := 0 TO 19 DO
      BEGIN
        M (0,feet); L (160,feet);   // yard line
        IF   i <> 0                 // "vertical" hash lines
        THEN BEGIN
          M ( 45,feet-1.5); L ( 45,feet+1.5); // "west"
          M (115,feet-1.5); L (115,feet+1.5); // "east"
        END;
        FOR j := 1 TO 4 DO BEGIN    // "horizontal" hash lines
          feet := feet + 3;         // between yard lines
          M ( 45,feet); L ( 48,feet);         // "west"
          M (115,feet); L (112,feet)          // "east"
        END;
        feet := feet + 3
      END;

      M (0,330); L (160,330);      // "north" goal line
      M (0,360); L (160,360);      // "north" endzone boundary

      M (  0,0); L (  0,360);      // "west" sideline
      M (160,0); L (160,360);      // "east" sideline

      M (77,321); L (83,321);      // "north" PAT hash line
      M (77, 39); L (83, 39);      // "south" PAT hash line

      EndzoneAnnotation;
      NumberYardLines;

    END {FieldDefinition};


    PROCEDURE GoalPosts (CONST area:  TPantograph);
      TYPE
        TGoal = (goalSouth, goalNorth);

      VAR
        goal :  TGoal;
        t,x,y:  DOUBLE;
    BEGIN
      FOR goal :=  goalSouth TO goalNorth DO
      BEGIN
        IF   goal = goalSouth
        THEN BEGIN
          x := 80.0;
          y :=  0.0;
          t := -5.0
        END
        ELSE BEGIN
          x := 80.0;
          y := 360.0;
          t :=  5.0
        END;

        Pantograph.Canvas.Pen.Color := ColorGoals;
        area.MoveTo (Vector3D(x,      y+t,  0.0));
        area.LineTo (Vector3D(x,      y+t, 10.0));
        area.LineTo (Vector3D(x,      y,   10.0));
        area.MoveTo (Vector3D(x-10.0, y,   28.0));
        area.LineTo (Vector3D(x-10.0, y,   10.0));
        area.LineTo (Vector3D(x+10.0, y,   10.0));
        area.LineTo (Vector3D(x+10.0, y,   28.0))
      END;

    END {GoalPosts};

  BEGIN {DrawFootballField}
    FieldDefinition(pantograph);
    GoalPosts(pantograph);
  END {DrawFootballField};

  // ----------------------------------------------------------------

INITIALIZATION
  // Create points just once for quicker redisplay
  CreateSurfacePoints;
END.
