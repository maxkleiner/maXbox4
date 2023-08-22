{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcComplex.pas                                           }
{   File version:     5.07                                                     }
{   Description:      Complex numbers                                          }
{                                                                              }
{   Copyright:        Copyright (c) 1999-2016, David J Butler                  }
{                     All rights reserved.                                     }
{                     Redistribution and use in source and binary forms, with  }
{                     or without modification, are permitted provided that     }
{                     the following conditions are met:                        }
{                     Redistributions of source code must retain the above     }
{                     copyright notice, this list of conditions and the        }
{                     following disclaimer.                                    }
{                     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND   }
{                     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED          }
{                     WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED   }
{                     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A          }
{                     PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL     }
{                     THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,    }
{                     INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR             }
{                     CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,    }
{                     PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF     }
{                     USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)         }
{                     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER   }
{                     IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING        }
{                     NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE   }
{                     USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE             }
{                     POSSIBILITY OF SUCH DAMAGE.                              }
{                                                                              }
{   Github:           https://github.com/fundamentalslib                       }
{   E-mail:           fundamentals.library at gmail.com                        }
{                                                                              }
{ Revision history:                                                            }
{                                                                              }
{   1999/10/02  0.01  Added TComplex.                                          }
{   1999/11/21  0.02  Added TComplex.Power                                     }
{   2001/05/21  0.03  Moved TTRational and TTComplex from cExDataStructs.      }
{   2002/06/01  0.04  Created cComplex unit from cMaths.                       }
{   2003/02/16  3.05  Revised for Fundamentals 3.                              }
{   2012/10/26  4.06  Revised for Fundamentals 4.                              }
{   2016/01/17  5.07  Revised for Fundamentals 5.                              }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi XE7 Win32                    5.09  2016/01/17                       }
{   Delphi XE7 Win64                    5.09  2016/01/17                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE flcMaths.inc}

unit flcComplex;

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  cFundamentUtils,
  flcMaths;



{                                                                              }
{ Complex numbers                                                              }
{   Class that represents a complex number (Real + i * Imag)                   }
{                                                                              }
type
  EComplexClass = class(Exception);
  TComplexClass = class
  private
    FReal : MFloat;
    FImag : MFloat;

    function  GetAsString: String;
    {$IFDEF SupportRawByteString}
    function  GetAsStringB: RawByteString;
    {$ENDIF}
    function  GetAsStringU: UnicodeString;

    procedure SetAsString(const S: String);
    {$IFDEF SupportRawByteString}
    procedure SetAsStringB(const S: RawByteString);
    {$ENDIF}
    procedure SetAsStringU(const S: UnicodeString);

  public
    constructor Create(
                const ARealPart: MFloat = 0.0;
                const AImaginaryPart: MFloat = 0.0);

    property  RealPart: MFloat read FReal write FReal;
    property  ImaginaryPart: MFloat read FImag write FImag;

    property  AsString: String read GetAsString write SetAsString;
    {$IFDEF SupportRawByteString}
    property  AsStringB: RawByteString read GetAsStringB write SetAsStringB;
    {$ENDIF}
    property  AsStringU: UnicodeString read GetAsStringU write SetAsStringU;

    procedure Assign(const C: TComplexClass); overload;
    procedure Assign(const V: MFloat); overload;
    procedure AssignZero;
    procedure AssignI;
    procedure AssignMinI;

    function  Duplicate: TComplexClass;

    function  IsEqual(const C: TComplexClass): Boolean; overload;
    function  IsEqual(const R, I: MFloat): Boolean; overload;
    function  IsReal: Boolean;
    function  IsZero: Boolean;
    function  IsI: Boolean;

    procedure Add(const C: TComplexClass); overload;
    procedure Add(const V: MFloat); overload;
    procedure Subtract(const C: TComplexClass); overload;
    procedure Subtract(const V: MFloat); overload;
    procedure Multiply(const C: TComplexClass); overload;
    procedure Multiply (Const V: MFloat); overload;
    procedure MultiplyI;
    procedure MultiplyMinI;
    procedure Divide(const C: TComplexClass); overload;
    procedure Divide(const V: MFloat); overload;
    procedure Negate;

    function  Modulo: MFloat;
    function  Denom: MFloat;
    procedure Conjugate;
    procedure Inverse;

    procedure Sqrt;
    procedure Exp;
    procedure Ln;
    procedure Sin;
    procedure Cos;
    procedure Tan;
    procedure Power(const C: TComplexClass);
  end;

 {$DEFINE MATHS_TEST}

{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF MATHS_TEST}
procedure TestComplex;
{$ENDIF}



implementation

uses
  { System }
  Math,

  { Fundamentals }
  //flcStrings,
  cWindows,
  flcFloats;



{                                                                              }
{ TComplex                                                                     }
{                                                                              }
constructor TComplexClass.Create(const ARealPart, AImaginaryPart: MFloat);
begin
  inherited Create;
  FReal := ARealPart;
  FImag := AImaginaryPart;
end;

function TComplexClass.IsI: Boolean;
begin
  Result := FloatZero(FReal) and FloatOne(FImag);
end;

function TComplexClass.IsReal: Boolean;
begin
  Result := FloatZero(FImag);
end;

function TComplexClass.IsZero: Boolean;
begin
  Result := FloatZero(FReal) and FloatZero(FImag);
end;

function TComplexClass.IsEqual(const C: TComplexClass): Boolean;
begin
  Result := FloatApproxEqual(FReal, C.FReal) and
            FloatApproxEqual(FImag, C.FImag);
end;

function TComplexClass.IsEqual(const R, I: MFloat): Boolean;
begin
  Result := FloatApproxEqual(FReal, R) and
            FloatApproxEqual(FImag, I);
end;

procedure TComplexClass.AssignZero;
begin
  FReal := 0.0;
  FImag := 0.0;
end;

procedure TComplexClass.AssignI;
begin
  FReal := 0.0;
  FImag := 1.0;
end;

procedure TComplexClass.AssignMinI;
begin
  FReal := 0.0;
  FImag := -1.0;
end;

procedure TComplexClass.Assign(const C: TComplexClass);
begin
  FReal := C.FReal;
  FImag := C.FImag;
end;

procedure TComplexClass.Assign(const V: MFloat);
begin
  FReal := V;
  FImag := 0.0;
end;

function TComplexClass.Duplicate: TComplexClass;
begin
  Result := TComplexClass.Create(FReal, FImag);
end;

function TComplexClass.GetAsString: String;
var RZ, IZ : Boolean;
begin
  RZ := FloatZero(FReal);
  IZ := FloatZero(FImag);
  if IZ then
    Result := FloatToStr(FReal)
  else
    begin
      Result := Result + FloatToStr(FImag) + 'i';
      if not RZ then
        Result := Result + iif(flcMaths.Sign(FReal) >= 0, '+', '-') + FloatToStr(Abs(FReal));
    end;
end;

{$IFDEF SupportRawByteString}
function TComplex.GetAsStringB: RawByteString;
var RZ, IZ : Boolean;
begin
  RZ := FloatZero(FReal);
  IZ := FloatZero(FImag);
  if IZ then
    Result := FloatToStringB(FReal)
  else
    begin
      Result := Result + FloatToStringB(FImag) + 'i';
      if not RZ then
        Result := Result + iifB(flcMaths.Sign(FReal) >= 0, '+', '-') + FloatToStringB(Abs(FReal));
    end;
end;
{$ENDIF}

function TComplexClass.GetAsStringU: UnicodeString;
var RZ, IZ : Boolean;
begin
  RZ := FloatZero(FReal);
  IZ := FloatZero(FImag);
  if IZ then
    Result := FloatToStringU(FReal)
  else
    begin
      Result := Result + FloatToStringU(FImag) + 'i';
      if not RZ then
        Result := Result + iifU(flcMaths.Sign(FReal) >= 0, '+', '-') + FloatToStringU(Abs(FReal));
    end;
end;

procedure TComplexClass.SetAsString(const S: String);
var F, G, H : Integer;
begin
  F := PosStr('(', S,1,true);
  G := PosStr(',', S,1,true);
  H := PosStr(')', S,1,true);
  if (F <> 1) or (H <> Length(S)) or (G < F) or (G > H) then
    raise EConvertError.Create('Cannot convert string to complex number');
  FReal := StringToFloat(CopyRange(S, F + 1, G - 1));
  FImag := StringToFloat(CopyRange(S, G + 1, H - 1));
end;

{$IFDEF SupportRawByteString}
procedure TComplex.SetAsStringB(const S: RawByteString);
var F, G, H : Integer;
begin
  F := PosStrB('(', S);
  G := PosStrB(',', S);
  H := PosStrB(')', S);
  if (F <> 1) or (H <> Length(S)) or (G < F) or (G > H) then
    raise EConvertError.Create('Cannot convert string to complex number');
  FReal := StringToFloatB(CopyRangeB(S, F + 1, G - 1));
  FImag := StringToFloatB(CopyRangeB(S, G + 1, H - 1));
end;
{$ENDIF}

procedure TComplexClass.SetAsStringU(const S: UnicodeString);
var F, G, H : Integer;
begin
  F := PosStr('(', S,1,true);
  G := PosStr(',', S,1,true);
  H := PosStr(')', S,1,true);
  if (F <> 1) or (H <> Length(S)) or (G < F) or (G > H) then
    raise EConvertError.Create('Cannot convert string to complex number');
  FReal := StringToFloatU(CopyRange(S, F + 1, G - 1));
  FImag := StringToFloatU(CopyRange(S, G + 1, H - 1));
end;

procedure TComplexClass.Add(const C: TComplexClass);
begin
  FReal := FReal + C.FReal;
  FImag := FImag + C.FImag;
end;

procedure TComplexClass.Add(const V: MFloat);
begin
  FReal := FReal + V;
end;

procedure TComplexClass.Subtract(const C: TComplexClass);
begin
  FReal := FReal - C.FReal;
  FImag := FImag - C.FImag;
end;

procedure TComplexClass.Subtract(const V: MFloat);
begin
  FReal := FReal - V;
end;

procedure TComplexClass.Multiply(const C: TComplexClass);
var R, I : MFloat;
begin
  R := FReal * C.FReal - FImag * C.FImag;
  I := FReal * C.FImag + FImag * C.FReal;
  FReal := R;
  FImag := I;
end;

procedure TComplexClass.Multiply(const V: MFloat);
begin
  FReal := FReal * V;
  FImag := FImag * V;
end;

procedure TComplexClass.MultiplyI;
var R : MFloat;
begin
  R := FReal;
  FReal := -FImag;
  FImag := R;
end;

procedure TComplexClass.MultiplyMinI;
var R : MFloat;
begin
  R := FReal;
  FReal := FImag;
  FImag := -R;
end;

function TComplexClass.Denom: MFloat;
begin
  Result := Sqr(FReal) + Sqr(FImag);
end;

procedure TComplexClass.Divide(const C: TComplexClass);
var R, D : MFloat;
begin
  D := Denom;
  if FloatZero(D) then
    raise EDivByZero.Create('Complex division by zero')
  else
    begin
      R := FReal;
      FReal := (R * C.FReal + FImag * C.FImag) / D;
      FImag := (FImag * C.FReal - FReal * C.FImag) / D;
    end;
end;

procedure TComplexClass.Divide(const V: MFloat);
var D : MFloat;
begin
  D := Denom;
  if FloatZero(D) then
    raise EDivByZero.Create('Complex division by zero')
  else
    begin
      FReal := (FReal * V) / D;
      FImag := (FImag * V) / D;
    end;
end;

procedure TComplexClass.Negate;
begin
  FReal := -FReal;
  FImag := -FImag;
end;

procedure TComplexClass.Conjugate;
begin
  FImag := -FImag;
end;

procedure TComplexClass.Inverse;
var D : MFloat;
begin
  D := Denom;
  if FloatZero(D) then
    raise EDivByZero.Create('Complex division by zero');
  FReal := FReal / D;
  FImag := - FImag / D;
end;

procedure TComplexClass.Exp;
var ExpZ : MFloat;
    S, C : MFloat;
begin
  ExpZ := System.Exp(FReal);
  SinCos(FImag, S, C);
  FReal := ExpZ * C;
  FImag := ExpZ * S;
end;

procedure TComplexClass.Ln;
var ModZ : MFloat;
begin
  ModZ := Denom;
  if FloatZero(ModZ) then
    raise EDivByZero.Create('Complex log zero');
  FReal := System.Ln(ModZ);
  FImag := ArcTan2(FReal, FImag);
end;

procedure TComplexClass.Power(const C: TComplexClass);
begin
  if not IsZero then
    begin
      Ln;
      Multiply(C);
      Exp;
    end
  else
    if C.IsZero then
      Assign(1.0)            { lim a^a = 1 as a-> 0 }
    else
      AssignZero;            { 0^a = 0 for a <> 0   }
end;

function TComplexClass.Modulo: MFloat;
begin
  Result := System.Sqrt(Denom);
end;

procedure TComplexClass.Sqrt;
var Root, Q : MFloat;
begin
  if not FloatZero(FReal) or not FloatZero(FImag) then
    begin
      Root := System.Sqrt(0.5 * (Abs(FReal) + Modulo));
      Q := FImag / (2.0 * Root);
      if FReal >= 0.0 then
        begin
          FReal := Root;
          FImag := Q;
        end else
        if FImag < 0.0 then
          begin
            FReal := - Q;
            FImag := - Root;
          end else
          begin
            FReal := Q;
            FImag := Root;
          end;
    end
  else
    AssignZero;
end;

procedure TComplexClass.Cos;
begin
  FReal := System.Cos(FReal) * Cosh(FImag);
  FImag := -System.Sin(FReal) * Sinh(FImag);
end;

procedure TComplexClass.Sin;
begin
  FReal := System.Sin(FReal) * Cosh(FImag);
  FImag := -System.Cos(FReal) * Sinh(FImag);
end;

procedure TComplexClass.Tan;
var CCos : TComplexClass;
begin
  CCos := TComplexClass.Create(FReal, FImag);
  try
    CCos.Cos;
    if CCos.IsZero then
      raise EDivByZero.Create('Complex division by zero');
    self.Sin;
    self.Divide(CCos);
  finally
    CCos.Free;
  end;
end;



{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF MATHS_TEST}
{$ASSERTIONS ON}
procedure TestComplex;
var A : TComplexClass;
begin
  A := TComplexClass.Create(1, 2);
  Assert(A.RealPart = 1);
  Assert(A.ImaginaryPart = 2);
  Assert(A.GetAsString = '2i+1');
  A.Free;
end;
{$ENDIF}



end.

