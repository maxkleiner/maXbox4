unit MyBigInt;

interface

uses Sysutils, Math;

const 
  Base = 10;

type
  TMyBigInt = class
  private
    Len: Integer;
    Value: AnsiString;
    procedure Trim;
    procedure Shift(k: Integer);
    procedure MultiplyAtom(Multiplier1: TMyBigInt; Multiplier2: Integer);
  public
    constructor Create(iValue: Integer = 0);
    procedure Add(Addend1, Addend2: TMyBigInt);
    procedure Multiply(Multiplier1, Multiplier2: TMyBigInt); overload;
    procedure Multiply(Multiplier1: TMyBigInt; Multiplier2: Integer); overload;
    function ToString: string;
    procedure CopyFrom(mbCopy: TMyBigInt);
  end;

implementation

constructor TMyBigInt.Create(iValue: Integer = 0);
var 
  sTmp: ShortString; 
  i: Integer;
begin
  inherited Create;
  sTmp := IntToStr(abs(iValue));
  Len  := Length(sTmp);
  SetLength(Value, Len);
  for i := 1 to Len do Value[i] := Chr(StrToInt(sTmp[Len - i + 1]));
end;

procedure TMyBigInt.Add(Addend1, Addend2: TMyBigInt);
  { zwei TMyBigInt miteinander addieren }
var 
  i, iCarry, iTemp: Integer;
begin
  // Länge der Wert-Strings angleichen
  iTemp := max(Addend1.Len, Addend2.Len);
  SetLength(Value, iTemp);
  for i := Len + 1 to iTemp do Value[i] := #0; // Für den Fall Addend1/Addend2=Self
  Len := iTemp;
  // Berechnung von Übertrag und Summe
  iCarry := 0;
  for i := 1 to Len do 
  begin
    iTemp := iCarry;
    if i <= Addend1.Len then iTemp := iTemp + Ord(Addend1.Value[i]);
    if i <= Addend2.Len then iTemp := iTemp + Ord(Addend2.Value[i]);
    Value[i] := Char(iTemp mod Base);
    iCarry   := iTemp div Base;
  end;
  if iCarry > 0 then 
  begin
    Len := Len + 1;
    SetLength(Value, Len);
    Value[Len] := Char(iCarry);
  end;
end;

procedure TMyBigInt.Multiply(Multiplier1, Multiplier2: TMyBigInt);
  { zwei TMyBigInt miteinander multipliziren }
var 
  mbResult, mbTemp: TMyBigInt; 
  i: Integer;
begin
  mbResult := TMyBigInt.Create;
  try
    mbTemp := TMyBigInt.Create;
    try
      for i := 1 to Multiplier2.Len do 
      begin
        // Multiplizieren nach der "Schulmethode"
        mbTemp.MultiplyAtom(Multiplier1, Ord(Multiplier2.Value[i]));
        mbTemp.Shift(i - 1);
        mbResult.Add(mbResult, mbTemp);
      end;
    finally 
      FreeAndNil(mbTemp);
    end;
    CopyFrom(mbResult);
  finally 
    FreeAndNil(mbResult);
  end;
end;

procedure TMyBigInt.Multiply(Multiplier1: TMyBigInt; Multiplier2: Integer);
  { TMyBigInt und einen Integer multiplizieren }
var 
  mbTemp: TMyBigInt;
begin
  mbTemp := TMyBigInt.Create(Multiplier2);
  try 
    Multiply(Multiplier1, mbTemp);
  finally
  end;
end;

function TMyBigInt.ToString: string;
  { Zahl in einen String umwandeln }
var 
  i: Integer;
begin
  Trim;
  Result := '';
  for i := Len downto 1 do Result := Result + IntToStr(Ord(Value[i]));
end;

procedure TMyBigInt.CopyFrom(mbCopy: TMyBigInt);
  { von mbCopy kopieren }
begin
  Value := mbCopy.Value;
  Len   := mbCopy.Len;
end;

procedure TMyBigInt.Trim;
  { führende Nullen entfernen }
var 
  i, p: Integer;
begin
  p := Len;
  for i := Len downto 1 do 
  begin
    if not (Value[i] in ['0']) then break;
    p := i - 1;
  end;
  if p < Len then 
  begin
    SetLength(Value, p);
    Len := p;
  end;
end;

procedure TMyBigInt.Shift(k: Integer);
  { von hinten mit k Nullen auffüllen, also mit Base^k multiplizieren }
var 
  i: Integer;
begin
  if k = 0 then Exit;
  SetLength(Value, Len + k);
  for i := Len downto 1 do Value[i + k] := Value[i];
  for i := 1 to k do Value[i] := #0;
  Len := Len + k;
end;

procedure TMyBigInt.MultiplyAtom(Multiplier1: TMyBigInt; Multiplier2: Integer);
  { Multiplikation mit einer Ziffer }
var 
  i, iCarry, iTemp: Integer;
begin
  // Multiplikation mit 1
  if Multiplier2 = 1 then 
  begin
    CopyFrom(Multiplier1);
    Exit;
  end;
  SetLength(Value, Multiplier1.Len);
  Len    := Multiplier1.Len;
  iCarry := 0;
  for i := 1 to Len do 
  begin
    iTemp    := Ord(Multiplier1.Value[i]) * Multiplier2 + iCarry;
    Value[i] := Char(iTemp mod Base);
    iCarry   := iTemp div Base;
  end;
  if iCarry > 0 then 
  begin
    Len := Len + 1;
    SetLength(Value, Len);
    Value[Len] := Char(iCarry);
  end;
end;

end.


----app_template_loaded----