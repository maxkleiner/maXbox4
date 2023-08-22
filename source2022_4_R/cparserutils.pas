{ The unit is part of Lazarus Chelper package

  Copyright (C) 2010 Dmitry Boyarintsev skalogryz dot lists at gmail.com

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

  extended to maXbox   from unit GIS_SysUtils;

}
unit cparserutils;

interface

{$ifdef fpc}{$mode delphi}{$h+}{$endif}

uses
  ALXMLDoc, classes, graphics;

  type  TNamePart = TALXMLNode;

// is function declared, i.e. int f()
(*function isFunc(name: TNamePart): Boolean;

// probably an untyped function: fn ().
// the name of the function has been consumed by TYPE parsing, so ommited!
// so TNamepart doesn't contain any children
function isUnnamedFunc(name: TNamepart): Boolean;

// is pointer to a function declared, i.e. int (*f)()
function isPtrToFunc(name: TNamePart): Boolean;

// is function declared, returning a pointer to a function, i.e. int (* (f)(int i) )()
// pascal variant of this case:
// type
//   TRetFunc = function : Integer;
// function f(i: Integer): TRetFunc; // body or extern modifier must be present!!!
function isFuncRetFuncPtr(name: TNamePart): Boolean;

// is pointer to a function declared, returning a pointer to a function, i.e.: int (*(*f)(int i))()
// pascal variant of this case:
// type
//   TRetFunc = function : Integer;
// var
//   f : function (i: Integer): TRetFunc;
function isPtrToFuncRetFuncPtr(name: TNamePart): Boolean;

function GetFuncParam(name: TNamePart): TNamePart;

// is array variable:
//   int a[10], *a[10] (array of 10 integers, or array of 10 pointers to integer)
function isArray(name: TNamePart): Boolean;

function GetArrayPart(name: TNamePart): TNamePart;

// returns the variable/function name from the struct
function GetIdFromPart(name: TNamePart): AnsiString;

function GetIdPart(name: TNamePart): TNamePart;

function isNamePartPtrToFunc(part: TNamePart): Boolean; inline;

function isAnyBlock(part: TNamePart): Boolean;  *)

// Geometry and General Routines
//

function  SphericalMod(X: Extended): Extended;
function  Sign(Value: Extended): Extended;
function  LimitFloat(const eValue, eMin, eMax: Extended): Extended;
//function  MinFloat(const eLeft, eRight: Extended): Extended;
//function  MaxFloat(const eLeft, eRight: Extended): Extended;
//function  MinVal(iLeft, iRight: integer): Integer; 
//function  MaxVal(iLeft, iRight: integer): Integer;
function  AngleToRadians(iAngle: Extended): Extended;
function  RadiansToAngle(eRad: Extended): Extended;
function  Cross180(iLong: Double): Boolean;
function  Mod180(Value: integer): Integer;
function  Mod180Float(Value: Extended): Extended;
Function  MulDivFloat(a,b,d:Extended):Extended;
function  LongDiff(iLong1, iLong2: Double): Double;

//....Bmp Procedures ..... 
//   
Procedure Bmp_AssignFromPersistent(Source:TPersistent;Bmp:TbitMap);
Function  Bmp_CreateFromPersistent(Source:TPersistent):TbitMap;


Function FixFilePath(Const Inpath,CheckPath:string):string;
Function UnFixFilePath(Const Inpath,CheckPath:string):string;
Procedure FillStringList(sl:TStringList;const aText:string);



type
  { TLineBreaker }

  TLineInfo = record
    linestart : Integer;
    lineend   : Integer;
  end;

  TLineBreaker = class(TObject)
  private
    fLines      : array of TLineInfo;
    flineCount  : Integer;
    procedure AddLine(const linestart, lineend: Integer);
  public
    procedure SetText(const AText: AnsiString);
    function LineNumber(Offset: Integer): Integer;
  end;

implementation

uses extctrls, jpeg, strutils, sysutils, math;


const

  //EARTHRADIUS = (3437.747 * GU_NAUTICALMILE);

    GMAXPOINTS = (1024 * 128);
  GMINALTITUDE=0.001;
  GMAXALTITUDE=10000000000.0;     //1000000;
  GMAXSCALEFACTOR = 1000.0;//3.0;
  GMINSCALEFACTOR = 0.00000003;    //0.00000003;

  Earth_RESOLUTION_Max=1500.0;
  Earth_RESOLUTION = (360 * 60 * 60 * Earth_RESOLUTION_Max);//(360 * 60 * 60 * 1500);
  
  GU_DEGREE = (Earth_RESOLUTION/360);
  GU_MINUTE = (GU_DEGREE/60);
  GU_MINUTE_THOUSANTH = (GU_DEGREE/60000);


  GU_10_DEGREE = (10 * GU_DEGREE);
  GU_15_DEGREE = (15 * GU_DEGREE);
  GU_30_DEGREE = (30 * GU_DEGREE);
  GU_90_DEGREE = (90 * GU_DEGREE);
  GU_180_DEGREE = (180 * GU_DEGREE);
  GU_360_DEGREE = (360 * GU_DEGREE);

   LocalPI = 3.14159265358979323846;
  DoublePI = (LocalPi * 2.0);
  HalfPI = (LocalPI / 2.0);
  QuarterPi = (LocalPI / 4.0);



  GU_TORADIANS = (LocalPI / GU_180_DEGREE);
  DEG_TORADIANS = (LocalPI / 180.0);

  GU_FROMRADIANS = (GU_180_DEGREE / LocalPI);
  DEG_FROMRADIANS = (180.0 / LocalPI);


(*function isNamePartPtrToFunc(part: TNamePart): Boolean; inline;
begin
  Result:=Assigned(part) and (part.nodetype=nk_Ref) and Assigned(part.owner) and (part.owner.kind=nk_Func);
end;

function isAnyBlock(part: TNamePart): Boolean;
begin
  Result:=Assigned(part) and ((part.Kind=nk_Block) or isAnyBlock(part.child));
end;

function isPtrToFunc(name: TNamePart): Boolean;
begin
  Result := Assigned(name) and (name.Kind=nk_Func) and Assigned(name.child) and
            (name.child.Kind=nk_Ref) and Assigned(name.child.child) and
            (name.child.child.Kind=nk_Ident);
end;

function SkipRefPart(name: TNamePart): TNamePart;
begin
  if Assigned(name) then begin
    if name.Kind=nk_Ref then Result:=name.child
    else Result:=name;
  end else
    Result:=nil;
end;

function isFunc(name: TNamePart): Boolean;
begin
  name:=SkipRefPart(name);
  Result:=Assigned(name) and (name.Kind=nk_Func) and Assigned(name.child) and (name.child.Kind=nk_Ident)
end;

function isUnnamedFunc(name: TNamepart): Boolean;
begin
  Result:=Assigned(name) and not Assigned(name.child) and (name.Kind=nk_Func);
end;

function isRetFuncPtr(name: TNamePart): Boolean;
begin
  Result:=Assigned(name) and Assigned(name.child) and
          (name.Kind=nk_Func) and (name.child.Kind=nk_Ref);
end;

function GetFuncParam(name:TNamePart):TNamePart;
begin
  while Assigned(name) and (name.Kind<>nk_Func) do name:=name.child;
  Result:=name;
end;

function isArray(name: TNamePart): Boolean;
begin
  Result:=(name.Kind=nk_Array)
          or (Assigned(name.child)
              and (name.child.Kind=nk_Array)
              and (name.Kind=nk_Ref));
end;

function isFuncRetFuncPtr(name: TNamePart): Boolean;
var
  p : TNamePart;
begin
  Result:=isRetFuncPtr(name);
  if Result then begin
    p:=name.child.child;
    Result:=Assigned(p) and Assigned(p.child)
            and (p.Kind=nk_Func)
            and (p.child.Kind=nk_Ident)
  end;
end;

function isPtrToFuncRetFuncPtr(name: TNamePart): Boolean;
var
  p : TNamePart;
begin
  Result:=isRetFuncPtr(name);
  if Result then begin
    p:=name.child.child;
    Result:=Assigned(p) and Assigned(p.child) and Assigned(p.child.child)
            and (p.Kind=nk_Func) and (p.child.Kind=nk_Ref)
            and (p.child.child.Kind=nk_Ident);
  end;
end;

function GetArrayPart(name:TNamePart):TNamePart;
begin
  if name.Kind=nk_Array then
    Result:=name
  else if (name.Kind=nk_Ref) and (Assigned(name.child)) and (name.child.Kind=nk_array) then
    Result:=name.child
  else
    Result:=nil;
end;

function GetIdFromPart(name: TNamePart): AnsiString;
begin
  while Assigned(name) and (name.Kind<>nk_Ident) do
    name:=name.child;
  if Assigned(name) then Result:=name.Id
  else Result:='';
end;

function GetIdPart(name: TNamePart): TNamePart;
begin
  Result:=nil;
  while Assigned(name) and (name.Kind<>nk_Ident) do
    name:=name.child;
  Result:=name;
end; *)


{------------------------------------------------------------------------------
 Mod180
------------------------------------------------------------------------------}
{**
  @Param Value Value in EarthUnits to modulus
  @Return Value modified to be in the range -180 .. +180
}

function Mod180(Value: integer): Integer;
begin
  if Value > Round(GU_180_DEGREE) + 1 then
    Value := Value - Round(GU_360_DEGREE)
  else
    if Value < -Round(GU_180_DEGREE + 1) then
      Value := Value + Round(GU_360_DEGREE);
  Result := Value;
end;

function Mod180Float(Value: Extended): Extended;
begin
  if Value > GU_180_DEGREE then
    Value := Value - GU_360_DEGREE
  else
    if Value < -GU_180_DEGREE then
      Value := Value + GU_360_DEGREE;
  Result := Value;
end;

Function  MulDivFloat(a,b,d:Extended):Extended;
 begin
  // result:=MulDiv(Round(a),Round(b),Round(d));
   result:= a * b / d;
 end;
{------------------------------------------------------------------------------
  LimitFloat
------------------------------------------------------------------------------}
{**
  @Param eValue Extended value to Limit.
  @Param eMin Minimum Extended value of Limit.
  @Param eMax Minimum Extended value of Limit.
  @Return Smaller Extended value of eLeft and eRight.
}
function LimitFloat(const eValue, eMin, eMax: Extended): Extended;
begin
  Result := eValue;
  if Result < eMin then Result := eMin
  else
  if Result > eMax then Result := eMax;
end;

{------------------------------------------------------------------------------
  LongDiff
------------------------------------------------------------------------------}
{**
  @Param iLong1 First Longitude in Earth Units.
  @Param iLong2 Second Longitude in Earth Units.
  @Return Distance in Earth Units between the two Longitudes.


}

//const   GMaxDouble=10000000000000000000000000000000.0;
const   GMaxDouble=10000000000.0;

function LongDiff(iLong1, iLong2: Double): Double;
begin
  Result := abs(iLong2 - iLong1);

  if Result >= GU_180_DEGREE then Result := GU_360_DEGREE - Result;

  if Result = 0 then Result:=GMaxDouble; { avoid divide by zero }
end;

{------------------------------------------------------------------------------
  StrToExtendedDef
------------------------------------------------------------------------------}
{**
  @Param Text String to convert.
  @Param Default Value to use if the conversion fails.
  @Return Extended representation of string.
}
function StrToExtendedDef(const Text: string; Default: Extended): Extended;
var
  Code: integer;
begin
  Val(Text, Result, Code);
  if Code <> 0 then  Result := Default;
end;

{------------------------------------------------------------------------------
  StrToExtended
------------------------------------------------------------------------------}
{**
  @Param Text String to convert.
  @Return Extended representation of string.
}
function StrToExtended(const Text: string): Extended;
var
  Code: integer;
begin
  Val(Text, Result, Code);
  if Code <> 0 then
    //raise EEarthException.CreateFmt(rsEConversionError, [Text]);
end;

{-------------------------------------------------------------------------
 AngleToRadians
-------------------------------------------------------------------------}
{**
  @Param iAngle Angle in radians to convert to EarthUnits.
  @Return Angle in EarthUnits.
}
function AngleToRadians(iAngle: Extended): Extended;
begin
  Result := iAngle * GU_TORADIANS;
end;

{-------------------------------------------------------------------------
 RadiansToAngle
-------------------------------------------------------------------------}
{**
  @Param iAngle Angle in EarthUnits to convert to radians.
  @Return Angle in Radians.
}

function RadiansToAngle(eRad: Extended): Extended;
begin
  Result := (eRad * GU_FROMRADIANS);
end;

{------------------------------------------------------------------------------
 Cross180
------------------------------------------------------------------------------}
{**
  @Param iLong Longitude coordinate in EarthUnits
  @Return True if this point has crossed the 180 meridian since the last call to this routine.
}
function Cross180(iLong:Double): Boolean;
var
  iZone,iLastZone: Double;
begin
  iLastZone:=0;
  iZone := iLong / GU_90_DEGREE;
  Result := ((iZone < 0) and (iLastZone > 0)) or ((iZone > 0) and (iLastZone < 0));
  iLastZone := iZone;
end;
     {
function Cross180(iLong:Double): Boolean;
var  iZone,iLastZone: integer;
begin
  iLastZone:=0;
  iZone := Round(iLong / GU_90_DEGREE);
  Result := ((iZone < 0) and (iLastZone > 0)) or ((iZone > 0) and (iLastZone < 0));
  iLastZone := iZone;
end;
      }
{-------------------------------------------------------------------------
 Sign
-------------------------------------------------------------------------}
{**
  @Param Value to test the sign of.
  @Return -1 if Value is < 0 or 1 if >= 0.
}
function Sign(Value: Extended): Extended;
begin
  Result := 1.0;
  if Value < 0.0 then  Result := -1.0;
end;

{------------------------------------------------------------------------------
 SphericalMod
------------------------------------------------------------------------------}
{**
  @Param X Value in radians to modulus.
  @Return X in the range -LocalPi to +LocalPi
}
function SphericalMod(X: Extended): Extended;
begin
  Result := X;
  if X < -LocalPi then
    Result := X + DoublePi
  else
    if X > LocalPi then
      Result := X - DoublePi;
end;

Procedure Bmp_AssignFromPersistent(Source:TPersistent;Bmp:TbitMap);

procedure AssignFromTBitmap(Val:TBitmap);
 begin
 Bmp.Assign(Source);
end;

procedure AssignFromTGraphic(Val:TGraphic);
 begin
    Bmp.PixelFormat:=pf32bit;
    Bmp.Width :=Val.Width;
    Bmp.Height :=Val.Height;
    Bmp.Canvas.Draw(0,0,Val);
    Bmp.PixelFormat:=pf16bit;

end;

begin

if Source is TBitmap then
  begin
   AssignFromTBitmap(TBitmap(Source));
   exit;
  end;

if Source is Timage then
  begin
   if Timage(Source).Picture.Graphic<>nil then
    begin
      AssignFromTGraphic(Timage(Source).Picture.Graphic);
      exit;
     end;
  end;
if Source is TGraphic then
  begin
   AssignFromTGraphic(TGraphic(Source));
   exit;
  end;
if Source is Ticon then
  begin
   AssignFromTGraphic(Ticon(Source));
   exit;
  end;
if Source is TJpegImage then
  begin
   AssignFromTGraphic(TJpegImage(Source));
   exit;
  end;

end;

//...................BMP Procedures..............................
Function  Bmp_CreateFromPersistent(Source:TPersistent):TbitMap;
 var bmp:TbitMap;
 begin
    bmp:=TbitMap.Create;
    Bmp_AssignFromPersistent(Source,bmp);
    result:=Bmp;
 end;

   Const FixText='../';

  //=======================================================================

Function FixFilePath(Const Inpath,CheckPath:string):string;
var   i,si: Integer;
      sl1,sl2 : TStringList;
      s1,s2:string;
begin
 Result:='';
 if inPath='' then exit;
 Result:=inPath;
 if CheckPath='' then exit;

 if SameText(ExtractFiledrive(Inpath),ExtractFiledrive(CheckPath))=false then exit;

 sl1:=TStringList.Create;
 sl2:=TStringList.Create;

 try
  FillStringList(sl1,EXtractFilePath(Inpath));
  FillStringList(sl2,EXtractFilePath(CheckPath));

  //........... Find Common ..................
  si:=0;
  for i:=0 to Min(sl1.Count-1,sl2.Count-1) do
      if (sl1[i]<>'') and (sl2[i]<>'') and sameText(sl1[i],sl2[i]) then
        inc(si) else
        Break;

  //.......................................
  if si>0 then
  begin

    s1:='';
    if si<(sl2.Count) then
      For i:=0 to (sl2.Count-si) do s1:=FixText+s1;


    s2:='';
    if si<sl1.Count then
      For i:=(sl1.Count-1) downto si do s2:=sl1[i]+s2;



     result:=s1+s2+ExtractFileName(Inpath);
  end else
  begin
     result:=Inpath;
  end;

   finally
      sl1.Free;
      sl2.Free;
   end;

end;

Function UnFixFilePath(Const Inpath,CheckPath:string):string;
  var i,si : Integer;
      sl1,sl2 : TStringList;
      s1,s2:string;
begin
 Result:='';
 if inPath='' then exit;
 Result:=inPath;
 if CheckPath='' then exit;

if ExtractFiledrive(Inpath)<>'' then exit;

  sl1:=TStringList.Create;
  sl2:=TStringList.Create;

try
  FillStringList(sl1,EXtractFilePath(Inpath));
  FillStringList(sl2,EXtractFilePath(CheckPath));

  //.............................
  si:=0;

  for i:=0 to sl1.Count-1 do
    if sameText(sl1[i],'..\') then
        inc(si) else
        Break;

  if  si>0 then
  begin

      s1:='';
      if si<sl2.Count then
        For i:=0 to (sl2.Count-si) do s1:=s1+sl2[i];

      s2:='';
      if si<sl1.Count then
        For i:=sl1.Count-1 downto si do s2:=sl1[i]+s2;

      result:=s1+s2+ExtractFileName(Inpath);
  end else
  begin
     result:=CheckPath+Inpath;
  end;

   finally
      sl1.Free;
      sl2.Free;
   end;
  end;


//==========================================
Procedure FillStringList(sl:TStringList;const aText:string);
 var p1,p2,l1:integer;
     ss:string;
     ex:boolean;
 begin
 if sl=nil then exit;
 if aText='' then exit;

 l1:=Length(aText);
 //...............
 p1:=1;
 p2:=0;

 repeat
   ex:=true;

   p2:=Pos('\',aText);

   if (p1<p2) and (p2>0) then
     begin
      ss:=copy(aText,p1,p2-p1+1);
      sl.Add(ss);
      p1:=p2+1;
      ex:=false;
     end;

 if p1>=l1 then exit;

 until ex=true;

 end;





{ TLineBreaker }

procedure TLineBreaker.AddLine(const linestart,lineend:Integer);
begin
  if flineCount=length(fLines) then begin
    if fLineCount=0 then SetLength(fLines, 4)
    else SetLength(fLines, fLineCount*2)
  end;
  fLines[fLineCount].linestart:=linestart;
  fLines[fLineCount].lineend:=lineend;
  inc(fLineCount);
end;

procedure TLineBreaker.SetText(const AText: AnsiString);
var
  i : Integer;
  j : Integer;
begin
  flineCount:=0;
  i:=1;
  j:=1;
  while i<=length(AText) do begin
    if (AText[i] in [#10, #13]) then begin
      inc(i);
      if (i<=length(AText)) and (AText[i] in [#10, #13]) and (AText[i-1]<>Atext[i]) then
        inc(i);
      AddLine(j, i-1);
      j:=i;
    end else
      inc(i);
  end;
  if j<>i-1 then AddLine(j, i-1);
end;

function TLineBreaker.LineNumber(Offset:Integer):Integer;
var
  i : Integer;
begin
  for i:=0 to flineCount-1 do
    if (Offset>=fLines[i].linestart) and (Offset<=flines[i].lineend) then begin
      Result:=i;
      Exit;
    end;
  Result:=-1;
end;

end.
