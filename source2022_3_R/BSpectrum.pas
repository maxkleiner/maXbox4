unit BSpectrum;
{
 Source:
  Dan Bruton's "Color Science" Web Page,
  www.isc.tamu.edu/~astro/color.html

 Traslated from FORTRAN by Earl F. Glynn" <EarlGlynn@att.net>

 16 09 98
 Built a TComponent By Marco Bianchini <m.bianchini@mo.nettuno.it>

}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  {$IFDEF VER100}
  LongWord = Integer;
  {$ENDIF}
  Nanometers = Double;
  TSpectrumKind = (skVisible,skEmission,skAbsorption);
  TSpMM=Procedure(Shift:TShiftState;X,Y:Integer;R,G,B:Byte) Of Object;
  TBSpectrum = class(TGraphicControl)
  private
    { Private declarations }
    fMM:TSpMM;
    fBw,fBh,
//    fLow,fHigh,
    fDInterval:Integer;
    fBitmapSPectrum:TBitmap;
    fKind:TSpectrumKind;
    fInterval,
    fPPO:Boolean;
  protected
    { Protected declarations }
    Procedure MouseMove(Shift:TShiftState;X,Y:Integer); Override;

  public
    { Public declarations }
   Constructor Create(AOwner:TComponent); Override;
   Destructor Destroy; Override;
   Procedure Paint;Override;
  published
    { Published declarations }
   Property Align;
   Property Font;
   Property Hint;
   Property ShowHint;
{
   Property Low:Integer Read fLow Write fLow;
   Property High:Integer Read fHigh;
}
   Property Interval:Boolean Read fInterval Write fInterval;
   Property IntervalDelta:Integer Read fDInterval Write fDInterval;
   Property PhotoPlateOrder:Boolean Read fPPO Write fPPO;
   Property Kind:TSpectrumKind Read fKind Write fKind;
   Property OnMouseMove:TspMM Read fMM Write fMM;
   Property OnMouseDown;
   Property OnMouseUp;
   Property OnClick;
   Property OnDblClick;
  end;

procedure Register;

implementation

Uses
 SpectraLibrary;

Const
 BlueWavelength : NanoMeters = 380.0;
 RedWavelength  : NanoMeters = 780.0;
Var
 VisibleBalmerLines:  ARRAY[3..9] OF NanoMeters;

Procedure TBSpectrum.MouseMove(Shift:TShiftState;X,Y:Integer);
 Var
  Color:TColor;
 Begin
  If Assigned(OnMouseMove) Then
   Begin
    Color:=Canvas.Pixels[X,0];
    fMM(Shift,X,Y,GetRValue(Color),GetGValue(Color),GetBValue(Color));
   End;
 End;


Procedure TBSpectrum.Paint;
 Const
  MaxPixelCount=32768;
 Type
  TRGBArray = ARRAY[0..MaxPixelCount-1] OF TRGBTriple;
  pRGBArray = ^TRGBArray;
 Var
  B,G,R:BYTE;
  Flags:pByteArray;
  i,index,j:INTEGER;
  Row:pRGBArray;
  s:STRING;
  Wavelength:NanoMeters;
 Begin
  // Set flags if emission or absorption spectra
  fBw:=Width;
  fBh:=Height;
  fBitmapSpectrum.Width:=fBw;
  fBitmapSpectrum.Height:=fBh;
  If fKind=skVisible Then
   Flags:=Nil   // Do this to avoid compiler warning
  Else
   Begin
    // Dynamically allocate one flag for each column in bitmap
    GetMem(Flags,fBw);
    For i:=0 To fBw-1 Do
     Flags[i]:=0;
    For j:=Low(VisibleBalmerLines) To High(VisibleBalmerLines) Do
     Begin
      Index:=Round((fBw-1)*(VisibleBalmerLines[j]-BlueWavelength)/(RedWavelength-BlueWavelength));
      If (Index>=0) And (Index<fBw) Then
       Flags[Index]:=1;
     End;
   End;
  For i:=0 To fBw-1 Do
   Begin
    If fPPO Then
     Index:=fBw-1-i
    Else
     index:=i;
    Wavelength:=BlueWavelength+(RedWavelength-BlueWavelength)*i/fBw;
    WavelengthToRGB(Wavelength,R,G,B);
    // Fix "line" for Emission Spectra
    If (fKind=skEmission) And (Flags[i]=0) Then
     Begin
      R:=0;
      G:=0;
      B:=0;
     End;

    // Fix "line" for Absorption Spectra
    If (fKind=skAbsorption) And (Flags[i]=1) Then
     Begin
      R:=0;
      G:=0;
      B:=0;
     End;

    For j:=0 To fBh-1 Do
     Begin
      row:=fBitmapSpectrum.Scanline[j];
      With row[index] Do
       Begin
        rgbtRed:=R;
        rgbtGreen:=G;
        rgbtBlue:=B;
       End;
     End;
   End;

  If fInterval And (fDInterval>0) Then
   Begin
    Wavelength:=Trunc(BlueWavelength/fDInterval)*fDInterval;

    fBitmapSpectrum.Canvas.Font:=Self.Font;
    fBitmapSpectrum.Canvas.Brush.Style:=bsClear;

    While (Wavelength<=RedWavelength) Do
     Begin // Empirical adjustment to make sure text contrast is always good
      If (Wavelength>=470) And (Wavelength<=620) And
         (fKind In [skVisible,skAbsorption]) Then
       Begin // Black on very light greens and yellow provides good contrast
        fBitmapSpectrum.Canvas.Pen.Color:=clBlack;
        fBitmapSpectrum.Canvas.Font.Color:=clBlack;
       End
      Else
       Begin // White on darker reds and blues provides good contrast
        fBitmapSpectrum.Canvas.Pen.Color:=clWhite;
        fBitmapSpectrum.Canvas.Font.Color:=clWhite
       End;
      i:=Round(fBw*(Wavelength-BlueWavelength)/(RedWavelength-BlueWavelength));
      If fPPO Then
       Index:=fBw-1-i
      Else
       Index:=i;
      fBitmapSpectrum.Canvas.MoveTo(Index,fBh-1);
      j:=8*fBh Div 10;
      fBitmapSpectrum.Canvas.LineTo(index,j);
      s:=IntToStr(Trunc(Wavelength));
      fBitmapSpectrum.Canvas.TextOut(index-fBitmapSpectrum.Canvas.TextWidth(s) Div 2,
                                     j-fBitmapSpectrum.Canvas.TextHeight(s),s);
      Wavelength := Wavelength + fDInterval;
    End;
  End;

  Canvas.Draw(0,0,fBitmapSpectrum);

  // Free flags if hydrogen emission or absorption spectra
  If fKind<>skVisible Then
   FreeMem(Flags);
{
  fBw:=Width;//fBMP.Width;
  fBh:=Height;// Div 2-10;//fBMP.Height;
  fBitmapSpectrum.Width:=fBw;
  fBitmapSpectrum.Height:=fBh;
  PaintSpectr;
}
 End;

Constructor TBSpectrum.Create(AOwner:TComponent);
 Var
  N:Integer;
 Begin
  Inherited Create(AOwner);
  fBitmapSpectrum:=TBitmap.Create;
  fBitmapSPectrum.PixelFormat:=pf24bit;
  fDInterval:=50;
  For n:=Low(VisibleBalmerLines) To High(VisibleBalmerLines) Do
    VisibleBalmerLines[n] := 364.7054 * SQR(n) / (SQR(n) - 4);
 End;

Destructor TBSpectrum.Destroy;
 Begin
  fBitmapSpectrum.Free;
  Inherited Destroy;
 End;

procedure Register;
begin
  RegisterComponents('Oxide', [TBSpectrum]);
end;

end.
