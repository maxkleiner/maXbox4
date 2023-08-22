//=========================================================
//                 Color Functions V1.0
//             2006-02 (c) Christer Wiklund
//               saltronic.cw@swipnet.se
//=========================================================
unit uColorFunctions;

interface
uses SysUtils,Graphics;

type
   TRGBType=record
       RedHex:string;
       GreenHex:string;
       BlueHex:string;
       Red:integer;
       Green:integer;
       Blue:integer;
    end;

//Adjust ligt of color
function FadeColor(aColor:Longint;aFade:integer ):Tcolor;
//Compare color and return a color that is visible to the color
function CountColor(aColor: Tcolor ;CompareColor:Tcolor ;  AdjustVale :integer=15 ):Tcolor;


implementation


function TestMax(Value:integer):integer;
begin
  if Value > 255 then
    result := 255
  else
    result := value;
end;

function TestMin(Value:integer):integer;
begin
  if Value < 0 then
    result := 0
  else
    result := value;
end;

function IntToRGB(value:Longint):TRGBType;
var
  colorHex:string;
begin
  colorHex        := IntToHex(value,6);
  result.RedHex   := copy(colorhex,5,2);
  result.GreenHex := copy(colorhex,3,2);
  result.BlueHex  := copy(colorhex,1,2);

  result.red   := StringToColor(HexDisplayPrefix+result.RedHex);
  result.Green := StringToColor(HexDisplayPrefix+result.GreenHex);
  result.Blue  := StringToColor(HexDisplayPrefix+result.BlueHex);
end;

function FadeColor(aColor:Longint;aFade:integer ):Tcolor;
var
  cRec:TRGBType;
begin
  cRec := IntToRGB(aColor);

  cRec.Red   := cRec.Red   + aFade;
  cRec.Green := cRec.Green + aFade;
  cRec.Blue  := cRec.Blue  + aFade;

  cRec.RedHex   := IntToHex(TestMin(TestMax(cRec.Red)),2);
  cRec.GreenHex := IntToHex(TestMin(TestMax(cRec.Green)),2);
  cRec.BlueHex  := IntToHex(TestMin(TestMax(cRec.Blue)),2);

  Result := StringToColor(HexDisplayPrefix+ cRec.BlueHex+cRec.GreenHex+cRec.RedHex );
end;

function CountColor(aColor: Tcolor ;CompareColor:Tcolor ;  AdjustVale :integer=15 ):Tcolor;
var
   Rc,Gc,Bc:integer;
   RGB:TRGBType;
   RGBCop:TRGBType;
   DecValue:integer;
begin

   RGB      := IntToRGB(aColor);
   RGBCop   := IntToRGB(CompareColor);
   DecValue := round( ((765 - rgb.Red-rgb.Green-rgb.Blue)/20 )+1 *AdjustVale);

   if ((RGB.Red  >= RGBCop.red-DecValue)  and(RGB.Red  <=RGBCop.red+DecValue))and
      ((RGB.Green>= RGBCop.Green-DecValue)and(RGB.Green<=RGBCop.Green+DecValue))and
      ((RGB.blue >= RGBCop.blue-DecValue) and(RGB.Blue <=RGBCop.blue+DecValue)) then
   begin

     if rgb.Red+rgb.Green+rgb.Blue>DecValue*3 then
     begin
       Rc := TestMin(rgb.Red-DecValue);
       Gc := TestMin(rgb.Green-DecValue);
       Bc := TestMin(rgb.Blue-DecValue);
     end
     else
     begin
       Rc := TestMin(rgb.Red+DecValue);
       Gc := TestMin(rgb.Green+DecValue);
       Bc := TestMin(rgb.Blue+DecValue);
     end;

     Result := StringToColor(HexDisplayPrefix
      +IntToHex(Bc,2) +IntToHex(Gc,2) +IntToHex(Rc,2));
   end
   else
     Result := aColor;
end;



end.
