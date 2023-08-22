////////////////////////////////////////////////////////////////////////////////
//
// BitmapConversion.pas - Conversion utilities for TLinearBitmap
// -------------------------------------------------------------
// Version:   2005-10-02
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
unit BitmapConversion;

interface

uses SysUtils, Windows, Graphics, MemUtils, LinarBitmap, Math, Monitor, MathUtils;

type
  TMatrix3x3 = array[1..3,1..3] of Double;
  TMatrix4x4 = array[1..4,1..4] of Double;

const
  RGBTransform : TMatrix4x4      = ((1,0,0,0),
                                    (0,1,0,0),
                                    (0,0,1,0),
                                    (0,0,0,1));

  CMYTransform : TMatrix4x4      = (( -1,  0,  0,255),
                                    (  0, -1,  0,255),
                                    (  0,  0, -1,255),
                                    (  0,  0,  0,  1));


// Color spaces FAQ - David Bourgin
// Date: 28/9/94
//  Y=  0.2989*Red+0.5866*Green+0.1145*Blue	| Red=  Y+0.0000*Cb+1.4022*Cr
//  Cb=-0.1687*Red-0.3312*Green+0.5000*Blue	| Green=Y-0.3456*Cb-0.7145*Cr
//  Cr= 0.5000*Red-0.4183*Green-0.0816*Blue	| Blue= Y+1.7710*Cb+0.0000*Cr
  YCbCrTransform601 : TMatrix4x4    = (( 0.2989, 0.5866, 0.1145,  0  ),     // Rec 601-1 specs (whatever that is)
                                       (-0.1687,-0.3312, 0.5   ,127.5),
                                       ( 0.5   ,-0.4183,-0.0816,127.5),
                                       ( 0     , 0,      0     ,  1  ));

  YCbCrTransform : TMatrix4x4    = (( 0.299  , 0.587  , 0.114  ,  0  ),  // JPEG/JPEG 2000 standard transform (I think)
                                    (-0.16875,-0.33126, 0.5    ,127.5),
                                    ( 0.5    ,-0.41869,-0.08131,127.5),
                                    ( 0      , 0,       0      ,  1  ));

  YCbCrTransformCompressed : TMatrix4x4 = (( 65.481/255, 128.553/255,  24.966/255, 16), // From Matlab
                                           (-37.797/255,- 74.203/255, 112.000/255,128),
                                           (112.000/255,- 93.786/255,- 18.214/255,128),
                                           (          0,           0,           0,  1));

  YIQTransform : TMatrix4x4      = (( 0.299, 0.587, 0.114,    0),
                                    ( 0.569,-0.275,-0.321,127.5),
                                    ( 0.212,-0.523, 0.311,127.5),
                                    (     0,     0,     0,    1));

var
  InvYCbCrTransform, InvYIQTransform : TMatrix4x4;

// |X|     |A|
// |Y| = T·|B|   (bottom row of T must be [0 0 0 1])
// |Z|     |C|
// |0|     |1|
procedure ColorTransform(A,B,C: Byte; out X,Y,Z: Byte; const T: TMatrix4x4); overload;
procedure ColorTransform(A,B,C: Byte; out X,Y,Z: Float; const T: TMatrix4x4); overload;
procedure ColorTransform(const A,B,C: Float; out X,Y,Z: Byte; const T: TMatrix4x4); overload;

type TColorTransformProc = procedure(R,G,B: Byte; out V0,V1,V2: Byte);

procedure ColorTransformHSI2RGB(H,S,I: Byte; out R,G,B: Byte);
procedure ColorTransformRGB2HSI(R,G,B: Byte; out H,S,I: Byte);
procedure ColorTransformRGB2Lab(R,G,B: Byte; out L,a_,b_: Byte);
procedure ColorTransformLab2RGB(L,a_,b_: Byte; out R,G,B: Byte);
procedure ColorTransformRGB2LOCO(R,G,B: Byte; out S0,S1,S2: Byte); // Used in MNG
procedure ColorTransformLOCO2RGB(S0,S1,S2: Byte; out R,G,B: Byte);

// Transform color space
procedure ConvertColorSpace(Image: TLinarBitmap; const T: TMatrix4x4; NewImage: TLinarBitmap=nil); overload;
procedure ConvertColorSpace(Image: TLinarBitmap; ColorTransform: TColorTransformProc; NewImage: TLinarBitmap=nil); overload;
procedure ConvertToGrayscale(const Image,GrayImage: TLinarBitmap); overload;
procedure ConvertToGrayscale(const Image: TLinarBitmap); overload;


implementation

uses ColorMapper;

// Convert to 8-bit grayscale image
procedure ConvertToGrayscale(const Image,GrayImage: TLinarBitmap);
var
  Pix : ^RGBRec;
  NewPix : ^Byte;
  P : Integer;
begin
  if Image.PixelFormat=pf24bit then
  begin
    GrayImage.New(Image.Width,Image.Height,pf8bit);
    GrayImage.Palette^:=GrayPal;
    Pointer(Pix):=Image.Map;
    Pointer(NewPix):=GrayImage.Map;
    for P:=0 to GrayImage.Size-1 do
    begin
     NewPix^:=(Pix^.R*2+Pix^.G*3+Pix^.B+3) div 6;
     Inc(Pix); Inc(NewPix);
    end;
  end
  else
  begin
    Image.AssignTo(GrayImage);
    ConvertToGrayscale(GrayImage);
  end;
end;

// Convert to 8-bit grayscale image
procedure ConvertToGrayscale(const Image: TLinarBitmap);
var
  Pix : ^Byte;
  P : Integer;
  LUT : array[0..255] of Byte;
  NewImage : TLinarBitmap;
begin
  if Image.PixelFormat=pf32bit then Image.PixelFormat:=pf24bit;
  if Image.PixelFormat=pf24bit then
  begin
    NewImage:=TLinarBitmap.Create;
    ConvertToGrayscale(Image,NewImage);
    Image.TakeOver(NewImage);
    NewImage.Free;
  end
  else
  begin
    for P:=0 to 255 do LUT[P]:=(Image.Palette^[P].R*2+Image.Palette^[P].G*3+Image.Palette^[P].B+3) div 6;
    Pointer(Pix):=Image.Map;
    for P:=1 to Image.Size do
    begin
      Pix^:=LUT[Pix^];
      Inc(Pix);
    end;
    Image.Palette^:=GrayPal;
  end;
end;

procedure ColorTransform(A,B,C: Byte; out X,Y,Z: Float; const T: TMatrix4x4); overload;
begin
  X:=A*T[1,1]+B*T[1,2]+C*T[1,3]+T[1,4];
  Y:=A*T[2,1]+B*T[2,2]+C*T[2,3]+T[2,4];
  Z:=A*T[3,1]+B*T[3,2]+C*T[3,3]+T[3,4];
end;

procedure ColorTransform(A,B,C: Byte; out X,Y,Z: Byte; const T: TMatrix4x4);
var D : Integer;
begin
  D:=Round(A*T[1,1]+B*T[1,2]+C*T[1,3]+T[1,4]);
  if D>255 then
    D:=255
  else if D<0 then
    D:=0;
  X:=D;
  D:=Round(A*T[2,1]+B*T[2,2]+C*T[2,3]+T[2,4]);
  if D>255 then
    D:=255
  else if D<0 then
    D:=0;
  Y:=D;
  D:=Round(A*T[3,1]+B*T[3,2]+C*T[3,3]+T[3,4]);
  if D>255 then
    D:=255
  else if D<0 then
    D:=0;
  Z:=D;
end;

procedure ColorTransform(const A,B,C: Double; out X,Y,Z: Byte; const T: TMatrix4x4);
var D : Integer;
begin
  D:=Round(A*T[1,1]+B*T[1,2]+C*T[1,3]+T[1,4]);
  if D>255 then D:=255 else if D<0 then D:=0;
  X:=D;
  D:=Round(A*T[2,1]+B*T[2,2]+C*T[2,3]+T[2,4]);
  if D>255 then D:=255 else if D<0 then D:=0;
  Y:=D;
  D:=Round(A*T[3,1]+B*T[3,2]+C*T[3,3]+T[3,4]);
  if D>255 then D:=255 else if D<0 then D:=0;
  Z:=D;
end;

procedure ColorTransformRGB2HSI(R,G,B: Byte; out H,S,I: Byte);
var
  D : Byte;
  RR, RG, RB, RH : Double;
begin
  I:=Round((R+G+B)/3);
  if I=0 then
  begin
    S:=0;
    H:=0;
  end
  else
  begin
    D:=R;
    if G<D then D:=G;
    if B<D then D:=B;
    RR:=R/255; RG:=G/255; RB:=B/255;
    S:=Round(255-3/(RR+RG+RB)*D);
    if S=0 then H:=0
    else
    begin
      RH:=ArcCos(0.5*((RR-RG)+(RR-RB))/Sqrt((Sqr(RR-RG)+(RR-RB)*(RG-RB))));
      if B/I>G/I then RH:=2*Pi-RH;
      H:=Round(RH*(255/(2*Pi)));
    end;
  end
end;

procedure ColorTransformHSI2RGB(H,S,I: Byte; out R,G,B: Byte);
var
  RR, RG, RB, RH, RS : Double;
  D : Integer;
begin
  RS:=S/255;
  if H<=85 then // 0°<H<=120°
  begin
    RH:=H*(Pi*2/255);
    RB:=1-RS;
    RR:=1+RS*Cos(RH)/Cos((60/180*Pi)-RH);
    RG:=3-(RR+RB);
  end
  else if H<170 then // 120°<H<=240°
  begin
    RH:=(H-85)*(Pi*2/255);
    RR:=1-RS;
    RG:=1+RS*Cos(RH)/Cos((60/180*Pi)-RH);
    RB:=3-(RR+RG);
  end
  else // 240°<H<=360°
  begin
    RH:=(H-170)*(Pi*2/255);
    RG:=1-RS;
    RB:=1+RS*Cos(RH)/Cos((60/180*Pi)-RH);
    RR:=3-(RB+RG);
  end;
  D:=Round(RR*I);
  Assert(D>=0);
  if D>255 then D:=255; R:=D;
  D:=Round(RG*I);
  Assert(D>=0);
  if D>255 then D:=255; G:=D;
  D:=Round(RB*I);
  Assert(D>=0);
  if D>255 then D:=255; B:=D;
end;

procedure ColorTransformRGB2Lab(R,G,B: Byte; out L,a_,b_: Byte);
const
  XYZTransform : TMatrix3x3 = ((0.412453, 0.357580, 0.180423),
                               (0.212671, 0.715160, 0.072169),
                               (0.019334, 0.119193, 0.950227));
  T = 0.008856;
var
  X, Y, Z, fX, fY, fZ, Y3, DL, Da, Db : Double;
begin
  X:=(XYZTransform[1,1]*R+XYZTransform[1,2]*G+XYZTransform[1,3]*B)/(0.950456*255);
  Y:=(XYZTransform[2,1]*R+XYZTransform[2,2]*G+XYZTransform[2,3]*B)/255;
  Z:=(XYZTransform[3,1]*R+XYZTransform[3,2]*G+XYZTransform[3,3]*B)/(1.088754*255);

  Y3:=Power(Y,1/3);
  if X>T then fX:=Power(X,1/3) else fX:=7.787*X + 16/116; // [0.137931034483;1]
  if Y>T then fY:=Y3           else fY:=7.787*Y + 16/116;
  if Z>T then fZ:=Power(Z,1/3) else fZ:=7.787*Z + 16/116;

  if Y>T then DL:=116*Y3-16.0  else DL:=903.3*Y;          // [0;100]
  Da:=500*(fX-fY);                                        // [-431;431]
  Db:=200*(fY-fZ);                                        // [-172.4;172.4]

  L:=ForceInRange(Round(DL*(255/100)),0,255);
  a_:=ForceInRange(Round(Da*(127.5/100)+127.5),0,255);
  b_:=ForceInRange(Round(Db*(127.5/100)+127.5),0,255);
end;

procedure ColorTransformLab2RGB(L,a_,b_: Byte; out R,G,B: Byte);
const
  InvXYZTransform : TMatrix3x3 = (( 3.240479,-1.537150,-0.498535),
                                  (-0.969256, 1.875992, 0.041556),
                                  ( 0.055648,-0.204043, 1.057311));
  T1 = 0.008856;
  T2 = 0.206893;
var
  X, Y, Z, fX, fY, fZ, DL, Da, Db : Double;
begin
  DL:=L*(100/255);
  Da:=(a_-127.5)*(100/127.5);
  Db:=(b_-127.5)*(100/127.5);

  // Compute Y
  fY:=Power((DL+16)/116,3);
  if fY<=T1 then fY:=DL/903.3;
  Y:=fY;
  // Alter fY slightly for further calculations
  if fY>T1 then fY:=Power(fY,1/3)
  else fY:=(7.787*fY+16/116);

  // Compute X
  fX:=fY+Da/500;
  if fX>T2 then X:=Power(fX,3)
  else X:=(fX-16/116)/7.787;

  // Compute Z
  fZ:=fY-Db/200;
  if fZ>T2 then Z:=Power(fZ,3)
  else Z:=(fZ-16/116)/7.787;

  X:=X*0.950456;
  Z:=Z*1.088754;

  R:=ForceInRange(Round(255*(InvXYZTransform[1,1]*X+InvXYZTransform[1,2]*Y+InvXYZTransform[1,3]*Z)),0,255);
  G:=ForceInRange(Round(255*(InvXYZTransform[2,1]*X+InvXYZTransform[2,2]*Y+InvXYZTransform[2,3]*Z)),0,255);
  B:=ForceInRange(Round(255*(InvXYZTransform[3,1]*X+InvXYZTransform[3,2]*Y+InvXYZTransform[3,3]*Z)),0,255);
end;

procedure ColorTransformRGB2LOCO(R,G,B: Byte; out S0,S1,S2: Byte);
begin
  S0:=R-G;
  S1:=G;
  S2:=B-G;
end;

procedure ColorTransformLOCO2RGB(S0,S1,S2: Byte; out R,G,B: Byte);
begin
  R:=S0+S1;
  G:=S1;
  B:=S2+S1;
end;

procedure ConvertColorSpace(Image: TLinarBitmap; const T: TMatrix4x4; NewImage: TLinarBitmap);
var
  Pix, NewPix : ^RGBRec;
  P : Integer;
begin
  Pix:=Pointer(Image.Map);
  if (NewImage=nil) or (NewImage=Image) then
    for P:=1 to Image.Width*Image.Height do
    begin
      ColorTransform(Pix^.R,Pix^.G,Pix^.B,Pix^.R,Pix^.G,Pix^.B,T);
      Inc(Pix);
    end
  else
  begin
    NewImage.New(image.Width,Image.Height,pf24bit);
    NewPix:=Pointer(NewImage.Map);
    for P:=1 to Image.Width*Image.Height do
    begin
      ColorTransform(Pix^.R,Pix^.G,Pix^.B,NewPix^.R,NewPix^.G,NewPix^.B,T);
      Inc(Pix);
      Inc(NewPix);
    end
  end;
end;

procedure ConvertColorSpace(Image: TLinarBitmap; ColorTransform: TColorTransformProc; NewImage: TLinarBitmap=nil);
var
  Pix, NewPix : ^RGBRec;
  P : Integer;
begin
  Pix:=Pointer(Image.Map);
  if (NewImage=nil) or (NewImage=Image) then
    for P:=1 to Image.Width*Image.Height do
    begin
      ColorTransform(Pix^.R,Pix^.G,Pix^.B,Pix^.R,Pix^.G,Pix^.B);
      Inc(Pix);
    end
  else
  begin
    NewImage.New(image.Width,Image.Height,pf24bit);
    NewPix:=Pointer(NewImage.Map);
    for P:=1 to Image.Width*Image.Height do
    begin
      ColorTransform(Pix^.R,Pix^.G,Pix^.B,NewPix^.R,NewPix^.G,NewPix^.B);
      Inc(Pix);
      Inc(NewPix);
    end
  end;
end;

type
  TList9 = array[1..9] of Double;

procedure ComplementMatrix3x3(const A: TMatrix3x3; var CA: TMatrix3x3);
begin
  TList9(CA)[1]:=TList9(A)[5]*TList9(A)[9]-TList9(A)[6]*TList9(A)[8];
  TList9(CA)[2]:=TList9(A)[7]*TList9(A)[6]-TList9(A)[4]*TList9(A)[9];
  TList9(CA)[3]:=TList9(A)[4]*TList9(A)[8]-TList9(A)[7]*TList9(A)[5];
  TList9(CA)[4]:=TList9(A)[8]*TList9(A)[3]-TList9(A)[2]*TList9(A)[9];
  TList9(CA)[5]:=TList9(A)[1]*TList9(A)[9]-TList9(A)[7]*TList9(A)[3];
  TList9(CA)[6]:=TList9(A)[7]*TList9(A)[2]-TList9(A)[1]*TList9(A)[8];
  TList9(CA)[7]:=TList9(A)[2]*TList9(A)[6]-TList9(A)[5]*TList9(A)[3];
  TList9(CA)[8]:=TList9(A)[4]*TList9(A)[3]-TList9(A)[1]*TList9(A)[6];
  TList9(CA)[9]:=TList9(A)[1]*TList9(A)[5]-TList9(A)[4]*TList9(A)[2];
end;

procedure TransposeMatrix3x3(const A: TMatrix3x3; var TA: TMatrix3x3);
var
  R, C : Integer;
begin
  for R:=1 to 3 do for C:=1 to 3 do TA[R,C]:=A[C,R];
end;

procedure InvertMatrix3x3(var A: TMatrix3x3);
var
  B : TMatrix3x3;
  I : Integer;
  InvDet : Double;
begin
  ComplementMatrix3x3(A,B);
  InvDet:=1/(TList9(A)[1]*TList9(B)[1]+TList9(A)[2]*TList9(B)[2]+TList9(A)[3]*TList9(B)[3]);
  TransposeMatrix3x3(B,A);
  for I:=1 to 9 do TList9(A)[I]:=TList9(A)[I]*InvDet;
end;

function InvertTransform4x4(const M : TMatrix4x4): TMatrix4x4;
var
  T : TMatrix3x3;
  R : Integer;
begin
  for R:=1 to 3 do Move(M[R],T[R],3*SizeOf(M[1,1]));
  InvertMatrix3x3(T);
  for R:=1 to 3 do Move(T[R],Result[R],3*SizeOf(M[1,1]));
  Result[1,4]:=-(M[1,4]*T[1,1]+M[2,4]*T[1,2]+M[3,4]*T[1,3]);
  Result[2,4]:=-(M[1,4]*T[2,1]+M[2,4]*T[2,2]+M[3,4]*T[2,3]);
  Result[3,4]:=-(M[1,4]*T[3,1]+M[2,4]*T[3,2]+M[3,4]*T[3,3]);
  Result[4,1]:=0; Result[4,2]:=0; Result[4,3]:=0; Result[4,4]:=1;
end;

initialization
  InvYCbCrTransform:=InvertTransform4x4(YCbCrTransform);
  InvYIQTransform:=InvertTransform4x4(YIQTransform);
end.

