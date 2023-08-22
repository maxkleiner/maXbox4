{******************************************************************************}
{                                                                              }
{   Library:          Fundamentals 5.00                                        }
{   File name:        flcVectors.pas                                           }
{   File version:     5.11                                                     }
{   Description:      Vector class                                             }
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
{   1999/09/27  0.01  Initial version.                                         }
{   1999/10/30  0.02  Added StdDev                                             }
{   1999/11/04  0.03  Added Pos, Append                                        }
{   2000/06/08  0.04  TVector now inherits from TExtendedArray.                }
{   2002/06/01  0.05  Created cVector unit from cMaths.                        }
{   2003/02/16  3.06  Revised for Fundamentals 3.                              }
{   2003/03/08  3.07  Revision and bug fixes.                                  }
{   2003/03/12  3.08  Optimizations.                                           }
{   2003/03/14  3.09  Removed vector based on Int64 values.                    }
{                     Added documentation.                                     }
{   2012/10/26  4.10  Revised for Fundamentals 4.                              }
{   2016/01/17  5.11  Revised for Fundamentals 5.                              }
{                                                                              }
{ Supported compilers:                                                         }
{                                                                              }
{   Delphi 7 Win32                      5.11  2016/01/17                       }
{   Delphi XE7 Win32                    5.11  2016/01/17                       }
{   Delphi XE7 Win64                    5.11  2016/01/17                       }
{                                                                              }
{******************************************************************************}

{$INCLUDE flcMaths.inc}

unit flcVectors;

//compare problems  solved  - locs:2814   max included datastructs light

interface

uses
  { System }
  SysUtils,

  { Fundamentals }
  flcStdTypes,
  flcFloats,
  flcMaths;
  //flcDataStructs;



{                                                                              }
{ TVector                                                                      }
{                                                                              }
{   A vector class with mathematical and statistical functions.                }
{                                                                              }
{   Internally the vector stores its values as MFloat type floating-point      }
{   values. The storage functionality is inherited from TBaseVectorArray.      }
{                                                                              }
{   Min and Max return the minimum and maximum vector values. Range is the     }
{   difference between the maximum and minimum values.                         }
{                                                                              }
{   IsZero returns True if all elements in the vector have a zero value.       }
{   HasZero returns True if at least one element has a zero value.             }
{   HasNegative returns True it at least one element has a negative value.     }
{                                                                              }
{   Add, Subtract, Multiply and DotProduct is overloaded to operate on         }
{   Extended and Int64 values.                                                 }
{                                                                              }
{   Normalize divides each element with the Norm of the vector.                }
{                                                                              }
{   Sum returns the sum of all vector elements. SumAndSquares calculates the   }
{   sum of all elements and the sum of each element squared. Likewise for      }
{   SumAndCubes and SumAndQuads.                                               }
{                                                                              }
{   Mean (or average) is the sum of all vector values divided by the number    }
{   of elements in the vector.                                                 }
{                                                                              }
{   Median is the middle-most value.                                           }
{                                                                              }
{   Mode is the most frequently appearing value.                               }
{                                                                              }
{   Variance is a measure of the spread of a distribution about its mean and   }
{   is defined by var(X) = E([X - E(X)]2). The variance is expressed in the    }
{   squared unit of measurement of X.                                          }
{                                                                              }
{   Standard deviation is the square root of the variance and like variance    }
{   is a measure of variability or dispersion of a sample. Standard deviation  }
{   is expressed in the same unit of measurement as the sample values.         }
{                                                                              }
{   StdDev returns the standard deviation of the sample while                  }
{   PopulationStdDev returns the standard deviation of the population.         }
{                                                                              }
{   M1, M2, M3 and M4 are the first four central moments (moments about the    }
{   mean). The second moment about the mean is equal to the variance.          }
{                                                                              }
{   Skewness is the degree of asymmetry about a central value of a             }
{   distribution. A distribution with many small values and few large values   }
{   is positively skewed (right tail), the opposite (left tail) is negatively  }
{   skewed.                                                                    }
{                                                                              }
{   Kurtosis is the degree of peakedness of a distribution, defined as a       }
{   normalized form of the fourth central moment of a distribution. Kurtosis   }
{   is based on the size of a distribution's tails. Distributions with         }
{   relatively large tails are called "leptokurtic"; those with small tails    }
{   are called "platykurtic." A distribution with the same kurtosis as the     }
{   normal distribution is called "mesokurtic."  The kurtosis of a normal      }
{   distribution is 0.                                                         }
{                                                                              }
{   Product returns the product of all vector elements.                        }
{                                                                              }
{   Angle returns the angle in radians between two vectors. Derived from       }
{   the equation: UV = |U| |V| Cos(Angle)                                      }
{                                                                              }
const
  {$IFDEF MFloatIsExtended}
  VectorFloatDelta = ExtendedCompareDelta;
  {$ELSE}
  {$IFDEF MFloatIsDouble}
  VectorFloatDelta = DoubleCompareDelta;
  {$ENDIF}
  {$ENDIF}
  //$


  type
  EType = class(Exception);

  TCompareResult = (crLesser,   // Comparison identifies left side < right side
                     crEqual,    // Comparison identifies left side = right side
                      crGreater,  // Comparison identifies left side > right side
                      crInvalid,   // Left and right sides cannot be compared
                     crundefined);
  TCompareFunction = function(const DataA, DataB): TCompareResult;

  {                                                                              }
{ Compare result                                                               }
{   Generic compare result enumeration.                                        }
{                                                                              }
{type
  TCompareResult = (
      crLess,
      crEqual,
      crGreater,
      crUndefined
      );        }
  TCompareResultSet = set of TCompareResult;

//function  InverseCompareResult(const C: TCompareResult): TCompareResult;

  AType = class
  protected
    procedure RaiseTypeError(const Msg: String; const ErrorClass: ExceptClass = nil); virtual;

    procedure Init; virtual;
    procedure AssignTo(const Dest: TObject); virtual;

    function  GetAsString: String; virtual;
    procedure SetAsString(const S: String); virtual;

    function  GetAsUTF8String: RawByteString; virtual;
    procedure SetAsUTF8String(const S: RawByteString); virtual;

    function  GetAsUnicodeString: UnicodeString; virtual;
    procedure SetAsUnicodeString(const S: UnicodeString); virtual;

  public
    constructor Create;
    class function CreateInstance: AType; virtual;

    function  Duplicate: TObject; virtual;
    procedure Assign(const Source: TObject); overload; virtual;

    procedure Clear; virtual;
    function  IsEmpty: Boolean; virtual;
    function  IsEqual(const V: TObject): Boolean; virtual;
    function  Compare(const V: TObject): TCompareResult; virtual;
    function  HashValue: Word32; virtual;

    property  AsString: String read GetAsString write SetAsString;
    property  AsUTF8String: RawByteString read GetAsUTF8String write SetAsUTF8String;
    property  AsUnicodeString: UnicodeString read GetAsUnicodeString write SetAsUnicodeString;
  end;
  TypeClass = class of AType;
  ATypeArray = Array of AType;
  TypeClassArray = Array of TypeClass;



 {                                                                          }
{ AArray                                                                       }
{   Base class for an array.                                                   }
{                                                                              }
type
  AArray = class(AType)
  protected
    procedure RaiseIndexError(const Idx: Integer); virtual;

    function  GetAsString: String; override;
    procedure SetAsString(const S: String); override;

    function  GetCount: Integer; virtual; abstract;
    procedure SetCount(const NewCount: Integer); virtual; abstract;

    function  GetItemAsString(const Idx: Integer): String; virtual;
    procedure SetItemAsString(const Idx: Integer; const Value: String); virtual;

  public
    { AType                                                                    }
    procedure Clear; override;

    { AArray                                                                   }
    property  Count: Integer read GetCount write SetCount;
    property  ItemAsString[const Idx: Integer]: String read GetItemAsString write SetItemAsString;

    function  CompareItems(const Idx1, Idx2: Integer): TCompareResult; virtual; abstract;
    procedure ExchangeItems(const Idx1, Idx2: Integer); virtual; abstract;
    procedure Sort; virtual;
    procedure ReverseOrder; virtual;
    procedure RemoveDuplicates(const IsSortedAscending: Boolean); virtual;

    function  DuplicateRange(const LoIdx, HiIdx: Integer): AArray; virtual; abstract;
    procedure Delete(const Idx: Integer; const ACount: Integer = 1); virtual; abstract;
    procedure Insert(const Idx: Integer; const ACount: Integer = 1); virtual; abstract;
    function  AppendArray(const V: AArray): Integer; overload; virtual; abstract;
  end;
  EArray = class(EType);
  ArrayClass = class of AArray;


  {                                                                              }
{ AInt64Array                                                                  }
{   Base class for an array of Int64s.                                         }
{                                                                              }
type
  AInt64Array = class(AArray)
  protected
    function  GetItem(const Idx: Integer): Int64; virtual; abstract;
    procedure SetItem(const Idx: Integer; const Value: Int64); virtual; abstract;

    function  GetItemAsString(const Idx: Integer): String; override;
    procedure SetItemAsString(const Idx: Integer; const Value: String); override;

    function  GetRange(const LoIdx, HiIdx: Integer): Int64Array; virtual;
    procedure SetRange(const LoIdx, HiIdx: Integer; const V: Int64Array); virtual;

  public
    { AType                                                                    }
    procedure Assign(const Source: TObject); override;
    function  IsEqual(const V: TObject): Boolean; override;

    { AArray                                                                   }
    procedure ExchangeItems(const Idx1, Idx2: Integer); override;
    function  CompareItems(const Idx1, Idx2: Integer): TCompareResult; override;
    function  AppendArray(const V: AArray): Integer; overload; override;
    function  DuplicateRange(const LoIdx, HiIdx: Integer): AArray; override;
    procedure Delete(const Idx: Integer; const ACount: Integer = 1); override;
    procedure Insert(const Idx: Integer; const ACount: Integer = 1); override;

    { AInt64Array interface                                                        }
    property  Item[const Idx: Integer]: Int64 read GetItem write SetItem; default;
    property  Range[const LoIdx, HiIdx: Integer]: Int64Array read GetRange write SetRange;
    procedure Fill(const Idx, ACount: Integer; const Value: Int64); virtual;
    function  AppendItem(const Value: Int64): Integer; virtual;
    function  AppendArray(const V: Int64Array): Integer; overload; virtual;
    function  PosNext(const Find: Int64; const PrevPos: Integer = -1;
              const IsSortedAscending: Boolean = False): Integer;
  end;
  EInt64Array = class(EArray);


 { TInt64ArrayClass                                                                 }
{   AInt64Array implemented using a dynamic array.                             }
{                                                                              }
type
  TInt64ArrayClass = class(AInt64Array)
  protected
    FData     : Int64Array;
    FCapacity : Integer;
    FCount    : Integer;

    { ACollection                                                              }
    function  GetCount: Integer; override;
    procedure SetCount(const NewCount: Integer); override;

    { AInt64Array                                                            }
    function  GetItem(const Idx: Integer): Int64; override;
    procedure SetItem(const Idx: Integer; const Value: Int64); override;
    function  GetRange(const LoIdx, HiIdx: Integer): Int64Array; override;
    procedure SetRange(const LoIdx, HiIdx: Integer; const V: Int64Array); override;
    procedure SetData(const AData: Int64Array); virtual;

  public
    constructor Create(const V: Int64Array = nil); //overload;

    { AType                                                                    }
    procedure Assign(const Source: TObject); overload; override;

    { AArray                                                                   }
    procedure ExchangeItems(const Idx1, Idx2: Integer); //override;
    function  DuplicateRange(const LoIdx, HiIdx: Integer): AArray; //override;
    procedure Delete(const Idx: Integer; const ACount: Integer = 1); //override;
    procedure Insert(const Idx: Integer; const ACount: Integer = 1); //override;

    { AInt64Array                                                            }
    procedure Assign(const V: Int64Array); overload;
    procedure Assign(const V: Array of Int64); overload;
    function  AppendItem(const Value: Int64): Integer; //override;

    { TInt64Array                                                            }
    property  Data: Int64Array read FData write SetData;
    property  Count: Integer read FCount write SetCount;
  end;

 

{                                                                              }
{ AExtendedArray                                                               }
{   Base class for an array of Extendeds.                                      }
{                                                                              }
type
  AExtendedArray = class(AArray)
  protected
    function  GetItem(const Idx: Integer): Extended; virtual; abstract;
    procedure SetItem(const Idx: Integer; const Value: Extended); virtual; abstract;

    function  GetItemAsString(const Idx: Integer): String; override;
    procedure SetItemAsString(const Idx: Integer; const Value: String); override;

    function  GetRange(const LoIdx, HiIdx: Integer): ExtendedArray; virtual;
    procedure SetRange(const LoIdx, HiIdx: Integer; const V: ExtendedArray); virtual;

  //  function AExtendedArray.GetRange(const LoIdx, HiIdx: Integer): ExtendedArray;

  public
    { AType                                                                    }
    procedure Assign(const Source: TObject); override;
    function  IsEqual(const V: TObject): Boolean; override;

    { AArray                                                                   }
    procedure ExchangeItems(const Idx1, Idx2: Integer); override;
    function  CompareItems(const Idx1, Idx2: Integer): TCompareResult; override;
    function  AppendArray(const V: AArray): Integer; overload; override;
    function  DuplicateRange(const LoIdx, HiIdx: Integer): AArray; override;
    procedure Delete(const Idx: Integer; const ACount: Integer = 1); override;
    procedure Insert(const Idx: Integer; const ACount: Integer = 1); override;

    { AExtendedArray interface                                                     }
    property  Item[const Idx: Integer]: Extended read GetItem write SetItem; default;
    property  Range[const LoIdx, HiIdx: Integer]: ExtendedArray read GetRange write SetRange;
    procedure Fill(const Idx, ACount: Integer; const Value: Extended); virtual;
    function  AppendItem(const Value: Extended): Integer; virtual;
   function  AppendArray(const V: ExtendedArray): Integer; overload; virtual;
    function  PosNext(const Find: Extended; const PrevPos: Integer = -1;
              const IsSortedAscending: Boolean = False): Integer;
  end;
  EExtendedArray = class(EArray);

{                                                                              }
{ TExtendedArray                                                               }
{   AExtendedArray implemented using a dynamic array.                          }
{                                                                              }
type
  TExtendedArray = class(AExtendedArray)
  protected
    FData     : ExtendedArray;
    FCapacity : Integer;
    FCount    : Integer;

    { ACollection                                                              }
   function  GetCount: Integer; override;
    procedure SetCount(const NewCount: Integer); override;

    { AExtendedArray                                                            }
    function  GetItem(const Idx: Integer): Extended; override;
    procedure SetItem(const Idx: Integer; const Value: Extended); override;
    function  GetRange(const LoIdx, HiIdx: Integer): ExtendedArray; override;
    //function  GetRange(const LoIdx, HiIdx: Integer): ExtendedArray;

    procedure SetRange(const LoIdx, HiIdx: Integer; const V: ExtendedArray); override;
    procedure SetData(const AData: ExtendedArray); virtual;

  public
    constructor Create(const V: ExtendedArray = nil); overload;

    { AType                                                                    }
    procedure Assign(const Source: TObject); overload; override;

    { AArray                                                                   }
    procedure ExchangeItems(const Idx1, Idx2: Integer); override;
    function  DuplicateRange(const LoIdx, HiIdx: Integer): AArray; override;
    procedure Delete(const Idx: Integer; const ACount: Integer = 1); override;
    procedure Insert(const Idx: Integer; const ACount: Integer = 1); override;

    { AExtendedArray                                                            }
    procedure Assign(const V: ExtendedArray); overload;
    procedure Assign(const V: Array of Extended); overload;
    function  AppendItem(const Value: Extended): Integer; override;

    { TExtendedArray                                                            }
    property  Data: ExtendedArray read FData write SetData;
    property  Count: Integer read FCount write SetCount;
  end;



type
  {$IFDEF MFloatIsExtended}
  TVectorBaseArray = TExtendedArray;
  {$ELSE}
  {$IFDEF MFloatIsDouble}
  TVectorBaseArray = TDoubleArray;
  {$ENDIF}
  {$ENDIF}

  type  TInt64Array = TInt64ArrayClass; //array of Int64;    //has to be a Class!


  TVectorClass = class(TVectorBaseArray)
  protected
    { Errors                                                                   }
    procedure CheckVectorSizeMatch(const Size: Integer);

  public
    { AType implementations                                                    }
    class function CreateInstance: AType; override;

    { TVector interface                                                        }
    procedure Add(const V: MFloat); overload;
    procedure Add(const V: PMFloat; const Count: Integer); overload;
    procedure Add(const V: PInt64; const Count: Integer); overload;
    procedure Add(const V: MFloatArray); overload;
    procedure Add(const V: Int64Array); overload;
    procedure Add(const V: TVectorBaseArray); overload;
    procedure Add(const V: TInt64Array); overload;
    procedure Add(Const V: TObject); overload;

    procedure Subtract(const V: MFloat); overload;
    procedure Subtract(const V: PMFloat; const Count: Integer); overload;
    procedure Subtract(const V: PInt64; const Count: Integer); overload;
    procedure Subtract(const V: MFloatArray); overload;
    procedure Subtract(const V: Int64Array); overload;
    procedure Subtract(const V: TVectorBaseArray); overload;
    procedure Subtract(const V: TInt64Array); overload;
    procedure Subtract(Const V: TObject); overload;

    procedure Multiply(const V: MFloat); overload;
    procedure Multiply(const V: PMFloat; const Count: Integer); overload;
    procedure Multiply(const V: PInt64; const Count: Integer); overload;
    procedure Multiply(const V: MFloatArray); overload;
    procedure Multiply(const V: Int64Array); overload;
    procedure Multiply(const V: TVectorBaseArray); overload;
    procedure Multiply(const V: TInt64Array); overload;
    procedure Multiply(const V: TObject); overload;

    function  DotProduct(const V: PMFloat; const Count: Integer): MFloat; overload;
    function  DotProduct(const V: PInt64; const Count: Integer): MFloat; overload;
    function  DotProduct(const V: MFloatArray): MFloat; overload;
    function  DotProduct(const V: Int64Array): MFloat; overload;
    function  DotProduct(const V: TVectorBaseArray): MFloat; overload;
    function  DotProduct(const V: TInt64Array): MFloat; overload;
    function  DotProduct(const V: TObject): MFloat; overload;

    function  Norm: MFloat;
    function  Min: MFloat;
    function  Max: MFloat;
    function  Range(var Min, Max: MFloat): MFloat;

    function  IsZero(const CompareDelta: MFloat = VectorFloatDelta): Boolean;
    function  HasZero(const CompareDelta: MFloat = VectorFloatDelta): Boolean;
    function  HasNegative: Boolean;

    procedure Normalize;
    procedure Negate;
    procedure ValuesInvert;
    procedure ValuesSqr;
    procedure ValuesSqrt;

    function  Sum: MFloat;
    function  SumOfSquares: MFloat;
    procedure SumAndSquares(out Sum, SumOfSquares: MFloat);
    procedure SumAndCubes(out Sum, SumOfSquares, SumOfCubes: MFloat);
    procedure SumAndQuads(out Sum, SumOfSquares, SumOfCubes, SumOfQuads: MFloat);
    function  WeightedSum(const Weights: TVectorClass): MFloat;

    function  Mean: MFloat;
    function  HarmonicMean: MFloat;
    function  GeometricMean: MFloat;
    function  Median: MFloat;
    function  Mode: MFloat;

    function  Variance: MFloat;
    function  StdDev(var Mean: MFloat): MFloat;
    function  PopulationVariance: MFloat;
    function  PopulationStdDev: MFloat;

    function  M1: MFloat;
    function  M2: MFloat;
    function  M3: MFloat;
    function  M4: MFloat;
    function  Skew: MFloat;
    function  Kurtosis: MFloat;

    function  Product: MFloat;
    function  Angle(const V: TVectorClass): MFloat;
  end;

  function  InverseCompareResult(const C: TCompareResult): TCompareResult;


{                                                                              }
{ Exceptions                                                                   }
{                                                                              }
type
  EVector = class(Exception);
  EVectorInvalidSize = class(EVector);
  EVectorInvalidType = class(EVector);
  EVectorEmpty = class(EVector);
  EVectorInvalidValue = class(EVector);
  EVectorDivisionByZero = class(EVector);

{$DEFINE MATHS_TEST}

{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF MATHS_TEST}
procedure TestVectorClass4;
{$ENDIF}



implementation

uses
  { System }
  Math, flcUtils;
  { Fundamentals }
  //cfundamentutils; //flcUtils;


  {                                                                              }
{ Compare                                                                      }
{                                                                              }
function InverseCompareResult(const C: TCompareResult): TCompareResult;
begin
  if C = crLesser then
    Result := crGreater else
  if C = crGreater then
    Result := crLesser
  else
    Result := C;
end;


{                                                                              }
{ AType                                                                        }
{                                                                              }
constructor AType.Create;
begin
  inherited Create;
  Init;
end;

procedure AType.Init;
begin
end;

procedure AType.RaiseTypeError(const Msg: String; const ErrorClass: ExceptClass);
begin
  if Assigned(ErrorClass) then
    raise ErrorClass.Create(Msg)
  else
    raise EType.Create(Msg);
end;

class function AType.CreateInstance: AType;
begin
  Result := AType(TypeClass(self).Create);
end;

procedure AType.Clear;
begin
  raise EType.CreateFmt('Method %s.Clear not implemented', [ClassName]);
end;

function AType.IsEmpty: Boolean;
begin
  raise EType.CreateFmt('Method %s.IsEmpty not implemented', [ClassName]);
end;

function AType.Duplicate: TObject;
begin
  try
    Result := CreateInstance;
    try
      AType(Result).Assign(self);
    except
      Result.Free;
      raise;
    end;
  except
    on E : Exception do
      raise EType.CreateFmt('%s cannot duplicate: %s', [ClassName, E.Message]);
  end;
end;

procedure AType.Assign(const Source: TObject);
var R : Boolean;
begin
  if Source is AType then
    try
      AType(Source).AssignTo(self);
      R := True;
    except
      R := False;
    end
  else
    R := False;
  if not R then
    raise EType.CreateFmt('%s cannot assign from %s', [ClassName, ObjectClassName(Source)]);
end;

procedure AType.AssignTo(const Dest: TObject);
begin
  raise EType.CreateFmt('%s cannot assign to %s', [ClassName, ObjectClassName(Dest)]);
end;

function AType.IsEqual(const V: TObject): Boolean;
begin
  raise EType.CreateFmt('%s cannot compare with %s', [ClassName, ObjectClassName(V)]);
end;

function AType.Compare(const V: TObject): TCompareResult;
begin
  raise EType.CreateFmt('%s cannot compare with %s', [ClassName, ObjectClassName(V)]);
end;     //}

function AType.HashValue: Word32;
begin
  try
    Result := HashStr(GetAsString, 1, -1, True);
  except
    on E : Exception do
      raise EType.CreateFmt('Hash error: %s', [E.Message]);
  end;
end;

function AType.GetAsString: String;
begin
  raise EType.CreateFmt('Method %s.GetAsString not implemented', [ClassName]);
end;

function AType.GetAsUTF8String: RawByteString;
begin
  {$IFDEF StringIsUnicode}
  Result := StringToUTF8String(GetAsString);
  {$ELSE}
  Result := GetAsString;
  {$ENDIF}
end;

function AType.GetAsUnicodeString: UnicodeString;
begin
  {$IFDEF StringIsUnicode}
  Result := GetAsString;
  {$ELSE}
  Result := UTF8Decode(GetAsString);
  {$ENDIF}
end;

procedure AType.SetAsUTF8String(const S: RawByteString);
begin
  raise EType.CreateFmt('Method %s.SetAsUTF8String not implemented', [ClassName]);
end;

procedure AType.SetAsUnicodeString(const S: UnicodeString);
begin
  raise EType.CreateFmt('Method %s.SetAsUnicodeString not implemented', [ClassName]);
end;

procedure AType.SetAsString(const S: String);
begin
  raise EType.CreateFmt('Method %s.SetAsString not implemented', [ClassName]);
end;



{                                                                              }
{ AType helper functions                                                       }
{                                                                              }
function TypeGetAsString(const V: TObject): String;
begin
  if V is AType then
    Result := AType(V).GetAsString
  else
    raise EType.CreateFmt('%s cannot convert to string', [ObjectClassName(V)]);
end;

procedure TypeSetAsString(const V: TObject; const S: String);
begin
  if V is AType then
    AType(V).SetAsString(S)
  else
    raise EType.CreateFmt('%s cannot set as string', [ObjectClassName(V)]);
end;

function TypeGetAsUTF8String(const V: TObject): RawByteString;
begin
  if V is AType then
    Result := AType(V).GetAsUTF8String
  else
    raise EType.CreateFmt('%s cannot convert to utf-8 string', [ObjectClassName(V)]);
end;

procedure TypeSetAsUTF8String(const V: TObject; const S: RawByteString);
begin
  if V is AType then
    AType(V).SetAsUTF8String(S)
  else
    raise EType.CreateFmt('%s cannot set as utf-8 string', [ObjectClassName(V)]);
end;

function TypeGetAsUnicodeString(const V: TObject): UnicodeString;
begin
  if V is AType then
    Result := AType(V).GetAsUnicodeString
  else
    raise EType.CreateFmt('%s cannot convert to utf-16 string', [ObjectClassName(V)]);
end;

procedure TypeSetAsUnicodeString(const V: TObject; const S: UnicodeString);
begin
  if V is AType then
    AType(V).SetAsUnicodeString(S)
  else
    raise EType.CreateFmt('%s cannot set as utf-16 string', [ObjectClassName(V)]);
end;

function TypeDuplicate(const V: TObject): TObject;
begin
  if V is AType then
    Result := AType(V).Duplicate else
  if not Assigned(V) then
    Result := nil
  else
    raise EType.CreateFmt('%s cannot duplicate', [ObjectClassName(V)]);
end;

procedure TypeClear(const V: TObject);
begin
  if V is AType then
    AType(V).Clear else
  if Assigned(V) then
    raise EType.CreateFmt('%s cannot clear', [ObjectClassName(V)]);
end;

function TypeIsEqual(const A, B: TObject): Boolean;
begin
  if A = B then
    Result := True else
  if not Assigned(A) or not Assigned(B) then
    Result := False else
  if A is AType then
    Result := AType(A).IsEqual(B) else
  if B is AType then
    Result := AType(B).IsEqual(A)
  else
    raise EType.CreateFmt('%s and %s cannot compare',
        [ObjectClassName(A), ObjectClassName(B)]);
end;

function TypeCompare(const A, B: TObject): TCompareResult;
begin
  if A = B then
    Result := crEqual else
 if A is AType then
    Result := AType(A).Compare(B) else
  if B is AType then
    Result := InverseCompareResult(AType(B).Compare(A))
  else    //}
    Result := crUndefined;
end;

procedure TypeAssign(const A, B: TObject);
begin
  if A = B then
    exit else
  if A is AType then
    AType(A).Assign(B) else
  if B is AType then
    AType(B).AssignTo(A)
  else
    raise EType.CreateFmt('%s cannot assign %s',
        [ObjectClassName(A), ObjectClassName(B)]);
end;

function TypeHashValue(const A: TObject): Word32;
begin
  if not Assigned(A) then
    Result := 0 else
  if A is AType then
    Result := AType(A).HashValue
  else
    raise EType.CreateFmt('%s cannot calculate hash value', [A.ClassName]);
end;


 {                                                                              }
{ AArray                                                                       }
{                                                                              }
procedure AArray.RaiseIndexError(const Idx: Integer);
begin
  raise EArray.Create(
      'Array index out of bounds'
      {$IFDEF DEBUG} + ': ' + IntToStr(Idx) + '/' + IntToStr(GetCount){$ENDIF}
      );
end;

function AArray.GetItemAsString(const Idx: Integer): String;
begin
  raise EArray.CreateFmt('%s.GetItemAsString not implemented', [ClassName]);
end;

procedure AArray.SetItemAsString(const Idx: Integer; const Value: String);
begin
  raise EArray.CreateFmt('%s.SetItemAsString not implemented', [ClassName]);
end;

procedure AArray.Clear;
begin
  Count := 0;
end;

procedure AArray.Sort;

  procedure QuickSort(L, R: Integer);
  var I, J : Integer;
      M    : Integer;
    begin
      repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        repeat
          while CompareItems(I, M) = crLesser do
            Inc(I);
          while CompareItems(J, M) = crGreater do
            Dec(J);
          if I <= J then
            begin
              ExchangeItems(I, J);
              if M = I then
                M := J else
                if M = J then
                  M := I;
              Inc(I);
              Dec(J);
            end;
        until I > J;
        if L < J then
          QuickSort(L, J);
        L := I;
      until I >= R;
    end;

var I : Integer;
begin
  I := Count;
  if I > 0 then
    QuickSort(0, I - 1);
end;

procedure AArray.ReverseOrder;
var I, L : Integer;
begin
  L := Count;
  for I := 1 to L div 2 do
    ExchangeItems(I - 1, L - I);
end;

function AArray.GetAsString: String;
var I, L : Integer;
begin
  L := Count;
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  Result := GetItemAsString(0);
  for I := 1 to L - 1 do
    Result := Result + ',' + GetItemAsString(I);
end;

procedure AArray.SetAsString(const S: String);
var F, G, L, C : Integer;
begin
  L := Length(S);
  if L = 0 then
    begin
      Count := 0;
      exit;
    end;
  L := 0;
  F := 1;
  C := Length(S);
  while F < C do
    begin
      G := 0;
      while (F + G <= C) and (S[F + G] <> ',') do
        Inc(G);
      Inc(L);
      Count := L;
      SetItemAsString(L - 1, Copy(S, F, G));
      Inc(F, G + 1);
    end;
end;

procedure AArray.RemoveDuplicates(const IsSortedAscending: Boolean);
var I, C, J, L : Integer;
begin
  L := GetCount;
  if L = 0 then
    exit;
  if IsSortedAscending then
    begin
      J := 0;
      repeat
        I := J + 1;
        while (I < L) and (CompareItems(I, J) = crEqual) do
          Inc(I);
        C := I - J;
        if C > 1 then
          begin
            Delete(J + 1, C - 1);
            Dec(L, C - 1);
            Inc(J);
          end
        else
          J := I;
      until J >= L;
    end else
    begin
      J := 0;
      while J < L - 1 do
        begin
          I := J + 1;
          while I <= L - 1 do
            if CompareItems(J, I) = crEqual then
              begin
                Delete(I, 1);
                Dec(L);
              end else
              Inc(I);
          Inc(J);
        end;
    end;
end;


{                                                                              }
{ TInt64ArrayClass                                                                  }
{                                                                              }
function TInt64ArrayClass.GetItem(const Idx: Integer): Int64;
begin
  {$IFOPT R+}
  if (Idx < 0) or (Idx >= FCount) then
    RaiseIndexError(Idx);
  {$ENDIF}
  Result := FData[Idx];
end;

procedure TInt64ArrayClass.SetItem(const Idx: Integer; const Value: Int64);
begin
  {$IFOPT R+}
  if (Idx < 0) or (Idx >= FCount) then
    RaiseIndexError(Idx);
  {$ENDIF}
  FData[Idx] := Value;
end;

procedure TInt64ArrayClass.ExchangeItems(const Idx1, Idx2: Integer);
var I : Int64;
begin
  {$IFOPT R+}
  if (Idx1 < 0) or (Idx1 >= FCount) then
    RaiseIndexError(Idx1);
  if (Idx2 < 0) or (Idx2 >= FCount) then
    RaiseIndexError(Idx2);
  {$ENDIF}
  I := FData[Idx1];
  FData[Idx1] := FData[Idx2];
  FData[Idx2] := I;
end;

function TInt64ArrayClass.GetCount: Integer;
begin
  Result := FCount;
end;

procedure SetLengthAndZeroC(var V: Int64Array; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Int64) * (NewLen - OldLen), #0);
end;

{ Memory allocation strategy to reduce memory copies:                          }
{   * For first allocation: allocate the exact size.                           }
{   * For change to < 16: allocate 16 entries.                                 }
{   * For growing to >= 16: pre-allocate 1/8th of NewCount.                    }
{   * For shrinking blocks: shrink actual allocation when Count is less        }
{     than half of the allocated size.                                         }
procedure TInt64ArrayClass.SetCount(const NewCount: Integer);
var L, N : Integer;
begin
  N := NewCount;
  if FCount = N then
    exit;
  FCount := N;
  L := FCapacity;
  if L > 0 then
    if N < 16 then // pre-allocate first 16 entries
      N := 16 else
    if N > L then
      N := N + N shr 3 else // pre-allocate 1/8th extra if growing
    if N > L shr 1 then // only reduce capacity if size is at least half
      exit;
  if N <> L then
    begin
      SetLengthAndZeroC(FData, N);
      FCapacity := N;
    end;
end;

function TInt64ArrayClass.AppendItem(const Value: Int64): Integer;
begin
  Result := FCount;
  if Result >= FCapacity then
    SetCount(Result + 1)
  else
    FCount := Result + 1;
  FData[Result] := Value;
end;


function DynArrayRemove64(var V: Int64Array; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  M := L - J - I;
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Int64));
  SetLength(V, L - J);
  Result := J;
end;

procedure TInt64ArrayClass.Delete(const Idx: Integer; const ACount: Integer = 1);
var N : Integer;
begin
  N := DynArrayRemove64(FData, Idx, ACount);
  Dec(FCapacity, N);
  Dec(FCount, N);
end;


function DynArrayInsert64(var V: Int64Array; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Int64));
  FillChar(P^, Count * Sizeof(Int64), #0);
  Result := I;
end;

procedure TInt64ArrayClass.Insert(const Idx: Integer; const ACount: Integer = 1);
var I : Integer;
begin
  I := DynArrayInsert64(FData, Idx, ACount);
  if I >= 0 then
    begin
      Inc(FCapacity, ACount);
      Inc(FCount, ACount);
    end;
end;

function TInt64ArrayClass.GetRange(const LoIdx, HiIdx: Integer): Int64Array;
var L, H : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(HiIdx, FCount);
  if H >= L then
    Result := Copy(FData, L, H - L + 1) else
    Result := nil;
end;

procedure TInt64ArrayClass.SetRange(const LoIdx, HiIdx: Integer; const V: Int64Array);
var L, H, C : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(HiIdx, FCount);
  C := MaxInt(MinInt(Length(V), H - L + 1), 0);
  if C > 0 then
    Move(V[0], FData[L], C * Sizeof(Int64));
end;

constructor TInt64ArrayClass.Create(const V: Int64Array);
begin
  inherited Create;
  SetData(V);
end;

procedure TInt64ArrayClass.SetData(const AData: Int64Array);
begin
  FData := AData;
  FCount := Length(FData);
  FCapacity := FCount;
end;

function TInt64ArrayClass.DuplicateRange(const LoIdx, HiIdx: Integer): AArray;
var L, H, C : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(HiIdx, FCount);
  C := MaxInt(0, H - L + 1);
  Result := CreateInstance as TInt64ArrayClass;
  TInt64ArrayClass(Result).FCount := C;
  if C > 0 then
    TInt64ArrayClass(Result).FData := Copy(FData, L, C);
end;

procedure TInt64ArrayClass.Assign(const V: Int64Array);
begin
  FData := Copy(V);
  FCount := Length(FData);
  FCapacity := FCount;
end;

function AsInt64Array(const V: array of Int64): Int64Array;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;


procedure TInt64ArrayClass.Assign(const V: Array of Int64);
begin
  FData := AsInt64Array(V);
  FCount := Length(FData);
  FCapacity := FCount;
end;

procedure TInt64ArrayClass.Assign(const Source: TObject);
begin
  if Source is TInt64ArrayClass then
    begin
      FCount := TInt64ArrayClass(Source).FCount;
      FData := Copy(TInt64ArrayClass(Source).FData, 0, FCount);
    end
  else
    inherited Assign(Source);
end;




 {                                                                              }
{ AExtendedArray                                                               }
{                                                                              }
procedure AExtendedArray.ExchangeItems(const Idx1, Idx2: Integer);
var I : Extended;
begin
  I := Item[Idx1];
  Item[Idx1] := Item[Idx2];
  Item[Idx2] := I;
end;

function AExtendedArray.AppendItem(const Value: Extended): Integer;
begin
  Result := Count;
  Count := Result + 1;
  Item[Result] := Value;
end;

                      //  GetRange(const LoIdx, HiIdx: Integer): ExtendedArray; virtual;

function AExtendedArray.GetRange(const LoIdx, HiIdx: Integer): ExtendedArray; //override;
var I, L, H, C : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(Count - 1, HiIdx);
  C := H - L + 1;
  SetLength(Result, C);
  for I := 0 to C - 1 do
    Result[I] := Item[L + I];
end;                   //}

function MinInt(const A, B: Int64): Int64;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

function MaxInt(const A, B: Int64): Int64;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

function AExtendedArray.DuplicateRange(const LoIdx, HiIdx: Integer): AArray;
var I, L, H, C : Integer;
begin
  Result := AExtendedArray(CreateInstance);
  L := MaxInt(0, LoIdx);
  H := MinInt(Count - 1, HiIdx);
  C := H - L + 1;
  AExtendedArray(Result).Count := C;
  for I := 0 to C - 1 do
    AExtendedArray(Result)[I] := Item[L + I];
end;

procedure AExtendedArray.SetRange(const LoIdx, HiIdx: Integer; const V: ExtendedArray);
var I, L, H, C : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(Count - 1, HiIdx);
  C := MinInt(Length(V), H - L + 1);
  for I := 0 to C - 1 do
    Item[L + I] := V[I];
end;       //}

procedure AExtendedArray.Fill(const Idx, ACount: Integer; const Value: Extended);
var I : Integer;
begin
  for I := Idx to Idx + ACount - 1 do
    Item[I] := Value;
end;

function AExtendedArray.AppendArray(const V: ExtendedArray): Integer;
begin
  Result := Count;
  Count := Result + Length(V);
  Range[Result, Count - 1] := V;
end;           //}

function AExtendedArray.CompareItems(const Idx1, Idx2: Integer): TCompareResult;
var I, J : Extended;
begin
  I := Item[Idx1];
  J := Item[Idx2];
  if I < J then
    Result := crLesser else
  if I > J then
    Result := crGreater else
    Result := crEqual;
end;

function AExtendedArray.PosNext(const Find: Extended;
    const PrevPos: Integer; const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Extended;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxInt(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Count - 1;
          repeat
            I := (L + H) div 2;
            D := Item[I];
            if D = Find then
              begin
                while (I > 0) and (Item[I - 1] = Find) do
                  Dec(I);
                Result := I;
                exit;
              end else
            if D > Find then
              H := I - 1 else
              L := I + 1;
          until L > H;
          Result := -1;
        end else // find next
        if PrevPos >= Count - 1 then
          Result := -1 else
          if Item[PrevPos + 1] = Find then
            Result := PrevPos + 1 else
            Result := -1;
    end else // linear search
    begin
      for I := MaxInt(PrevPos + 1, 0) to Count - 1 do
        if Item[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function AExtendedArray.GetItemAsString(const Idx: Integer): String;
begin
  Result := FloatToStr(GetItem(Idx));
end;

procedure AExtendedArray.SetItemAsString(const Idx: Integer; const Value: String);
begin
  SetItem(Idx, StrToFloat(Value));
end;

{procedure AExtendedArray.SetData(const AData: ExtendedArray);
begin
  //
end;   }

procedure AExtendedArray.Assign(const Source: TObject);
var I, L : Integer;
begin
  if Source is AExtendedArray then
    begin
      L := AExtendedArray(Source).Count;
      Count := L;
      for I := 0 to L - 1 do
        Item[I] := AExtendedArray(Source).Item[I];
    end else
  if Source is AInt64Array then
    begin
      L := AInt64Array(Source).Count;
      Count := L;
      for I := 0 to L - 1 do
        Item[I] := AInt64Array(Source).Item[I];
    end else
    inherited Assign(Source);
end;

function AExtendedArray.IsEqual(const V: TObject): Boolean;
var I, L : Integer;
begin
  if V is AExtendedArray then
    begin
      L := AExtendedArray(V).Count;
      Result := L = Count;
      if not Result then
        exit;
      for I := 0 to L - 1 do
        if Item[I] <> AExtendedArray(V).Item[I] then
          begin
            Result := False;
            exit;
          end;
    end else
    Result := inherited IsEqual(V);
end;

function AExtendedArray.AppendArray(const V: AArray): Integer;
var I, L : Integer;
begin
  Result := Count;
  if V is AExtendedArray then
    begin
      L := V.Count;
      Count := Result + L;
      for I := 0 to L - 1 do
        Item[Result + I] := AExtendedArray(V)[I];
    end
  else
    raise EExtendedArray.CreateFmt('%s can not append %s', [ClassName, ObjectClassName(V)]);
end;

procedure AExtendedArray.Delete(const Idx: Integer; const ACount: Integer);
var I, C, J, L : Integer;
begin
  J := MaxInt(Idx, 0);
  C := GetCount;
  L := MinInt(ACount, C - J);
  if L > 0 then
    begin
      for I := J to J + C - 1 do
        SetItem(I, GetItem(I + ACount));
      SetCount(C - L);
    end;
end;

procedure AExtendedArray.Insert(const Idx: Integer; const ACount: Integer);
var I, C, J, L : Integer;
begin
  if ACount <= 0 then
    exit;
  C := GetCount;
  SetCount(C + ACount);
  J := MinInt(MaxInt(Idx, 0), C);
  L := C - J;
  for I := C - 1 downto C - L do
    SetItem(I + ACount, GetItem(I));
end;

//{$IFDEF SupportAnsiString}

{                                                                              }
{ AInt64Array                                                                  }
{                                                                              }
procedure AInt64Array.ExchangeItems(const Idx1, Idx2: Integer);
var I : Int64;
begin
  I := Item[Idx1];
  Item[Idx1] := Item[Idx2];
  Item[Idx2] := I;
end;

function AInt64Array.AppendItem(const Value: Int64): Integer;
begin
  Result := Count;
  Count := Result + 1;
  Item[Result] := Value;
end;


function AInt64Array.GetRange(const LoIdx, HiIdx: Integer): Int64Array;
var I, L, H, C : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(Count - 1, HiIdx);
  C := H - L + 1;
  SetLength(Result, C);
  for I := 0 to C - 1 do
    Result[I] := Item[L + I];
end;   //}

function AInt64Array.DuplicateRange(const LoIdx, HiIdx: Integer): AArray;
var I, L, H, C : Integer;
begin
  Result := AInt64Array(CreateInstance);
  L := MaxInt(0, LoIdx);
  H := MinInt(Count - 1, HiIdx);
  C := H - L + 1;
  AInt64Array(Result).Count := C;
  for I := 0 to C - 1 do
    AInt64Array(Result)[I] := Item[L + I];
end;


procedure AInt64Array.SetRange(const LoIdx, HiIdx: Integer; const V: Int64Array);
var I, L, H, C : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(Count - 1, HiIdx);
  C := MinInt(Length(V), H - L + 1);
  for I := 0 to C - 1 do
    Item[L + I] := V[I];
end;    //}

procedure AInt64Array.Fill(const Idx, ACount: Integer; const Value: Int64);
var I : Integer;
begin
  for I := Idx to Idx + ACount - 1 do
    Item[I] := Value;
end;

function AInt64Array.AppendArray(const V: Int64Array): Integer;
begin
  Result := Count;
  Count := Result + Length(V);
  Range[Result, Count - 1] := V;
end;      //}

function AInt64Array.CompareItems(const Idx1, Idx2: Integer): TCompareResult;
var I, J : Int64;
begin
  I := Item[Idx1];
  J := Item[Idx2];
  if I < J then
    Result := crLesser else
  if I > J then
    Result := crGreater else
    Result := crEqual;
end;

function AInt64Array.PosNext(const Find: Int64;
    const PrevPos: Integer; const IsSortedAscending: Boolean): Integer;
var I, L, H : Integer;
    D       : Int64;
begin
  if IsSortedAscending then // binary search
    begin
      if MaxInt(PrevPos + 1, 0) = 0 then // find first
        begin
          L := 0;
          H := Count - 1;
          repeat
            I := (L + H) div 2;
            D := Item[I];
            if D = Find then
              begin
                while (I > 0) and (Item[I - 1] = Find) do
                  Dec(I);
                Result := I;
                exit;
              end else
            if D > Find then
              H := I - 1 else
              L := I + 1;
          until L > H;
          Result := -1;
        end else // find next
        if PrevPos >= Count - 1 then
          Result := -1 else
          if Item[PrevPos + 1] = Find then
            Result := PrevPos + 1 else
            Result := -1;
    end else // linear search
    begin
      for I := MaxInt(PrevPos + 1, 0) to Count - 1 do
        if Item[I] = Find then
          begin
            Result := I;
            exit;
          end;
      Result := -1;
    end;
end;

function AInt64Array.GetItemAsString(const Idx: Integer): String;
begin
  Result := IntToStr(GetItem(Idx));
end;

procedure AInt64Array.SetItemAsString(const Idx: Integer; const Value: String);
begin
  SetItem(Idx, StrToInt64(Value));
end;

procedure AInt64Array.Assign(const Source: TObject);
var I, L : Integer;
begin
  if Source is AInt64Array then
    begin
      L := AInt64Array(Source).Count;
      Count := L;
      for I := 0 to L - 1 do
        Item[I] := AInt64Array(Source).Item[I];
    end else
 { if Source is ALongIntArray then
    begin
      L := ALongIntArray(Source).Count;
      Count := L;
      for I := 0 to L - 1 do
        Item[I] := ALongIntArray(Source).Item[I];
    end else  }
    inherited Assign(Source);
end;

function AInt64Array.IsEqual(const V: TObject): Boolean;
var I, L : Integer;
begin
  if V is AInt64Array then
    begin
      L := AInt64Array(V).Count;
      Result := L = Count;
      if not Result then
        exit;
      for I := 0 to L - 1 do
        if Item[I] <> AInt64Array(V).Item[I] then
          begin
            Result := False;
            exit;
          end;
    end else
    Result := inherited IsEqual(V);
end;

function AInt64Array.AppendArray(const V: AArray): Integer;
var I, L : Integer;
begin
  Result := Count;
  if V is AInt64Array then
    begin
      L := V.Count;
      Count := Result + L;
      for I := 0 to L - 1 do
        Item[Result + I] := AInt64Array(V)[I];
    end
  else
    raise EInt64Array.CreateFmt('%s can not append %s', [ClassName, ObjectClassName(V)]);
end;

procedure AInt64Array.Delete(const Idx: Integer; const ACount: Integer);
var I, C, J, L : Integer;
begin
  J := MaxInt(Idx, 0);
  C := GetCount;
  L := MinInt(ACount, C - J);
  if L > 0 then
    begin
      for I := J to J + C - 1 do
        SetItem(I, GetItem(I + ACount));
      SetCount(C - L);
    end;
end;

procedure AInt64Array.Insert(const Idx: Integer; const ACount: Integer);
var I, C, J, L : Integer;
begin
  if ACount <= 0 then
    exit;
  C := GetCount;
  SetCount(C + ACount);
  J := MinInt(MaxInt(Idx, 0), C);
  L := C - J;
  for I := C - 1 downto C - L do
    SetItem(I + ACount, GetItem(I));
end;


{                                                                              }
{ TExtendedArray     as Class                                                          }
{                                                                              }
function TExtendedArray.GetItem(const Idx: Integer): Extended;
begin
  {$IFOPT R+}
  if (Idx < 0) or (Idx >= FCount) then
    RaiseIndexError(Idx);
  {$ENDIF}
  Result := FData[Idx];
end;

procedure TExtendedArray.SetItem(const Idx: Integer; const Value: Extended);
begin
  {$IFOPT R+}
  if (Idx < 0) or (Idx >= FCount) then
    RaiseIndexError(Idx);
  {$ENDIF}
  FData[Idx] := Value;
end;

procedure TExtendedArray.ExchangeItems(const Idx1, Idx2: Integer);
var I : Extended;
begin
  {$IFOPT R+}
  if (Idx1 < 0) or (Idx1 >= FCount) then
    RaiseIndexError(Idx1);
  if (Idx2 < 0) or (Idx2 >= FCount) then
    RaiseIndexError(Idx2);
  {$ENDIF}
  I := FData[Idx1];
  FData[Idx1] := FData[Idx2];
  FData[Idx2] := I;
end;

function TExtendedArray.GetCount: Integer;
begin
  Result := FCount;
end;


procedure SetLengthAndZero2(var V: ExtendedArray; const NewLength: Integer);
var OldLen, NewLen : Integer;
begin
  NewLen := NewLength;
  if NewLen < 0 then
    NewLen := 0;
  OldLen := Length(V);
  if OldLen = NewLen then
    exit;
  SetLength(V, NewLen);
  if OldLen > NewLen then
    exit;
  FillChar(Pointer(@V[OldLen])^, Sizeof(Extended) * (NewLen - OldLen), #0);
end;


{ Memory allocation strategy to reduce memory copies:                          }
{   * For first allocation: allocate the exact size.                           }
{   * For change to < 16: allocate 16 entries.                                 }
{   * For growing to >= 16: pre-allocate 1/8th of NewCount.                    }
{   * For shrinking blocks: shrink actual allocation when Count is less        }
{     than half of the allocated size.                                         }
procedure TExtendedArray.SetCount(const NewCount: Integer);
var L, N : Integer;
begin
  N := NewCount;
  if FCount = N then
    exit;
  FCount := N;
  L := FCapacity;
  if L > 0 then
    if N < 16 then // pre-allocate first 16 entries
      N := 16 else
    if N > L then
      N := N + N shr 3 else // pre-allocate 1/8th extra if growing
    if N > L shr 1 then // only reduce capacity if size is at least half
      exit;
  if N <> L then
    begin
      SetLengthAndZero2(FData, N);
      SetLength(FData, N);
      FCapacity := N;
    end;
end;

function TExtendedArray.AppendItem(const Value: Extended): Integer;
begin
  Result := FCount;
  if Result >= FCapacity then
    SetCount(Result + 1)
  else
    FCount := Result + 1;
  FData[Result] := Value;
end;


function DynArrayRemove(var V: ExtendedArray; const Idx: Integer; const Count: Integer): Integer;
var I, J, L, M: Integer;
begin
  L := Length(V);
  if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
    begin
      Result := 0;
      exit;
    end;
  I := MaxInt(Idx, 0);
  J := MinInt(Count, L - I);
  M := L - J - I;
  if M > 0 then
    Move(V[I + J], V[I], M * SizeOf(Extended));
  SetLength(V, L - J);
  Result := J;
end;

procedure TExtendedArray.Delete(const Idx: Integer; const ACount: Integer = 1);
var N : Integer;
begin
  N := DynArrayRemove(FData, Idx, ACount);
  Dec(FCapacity, N);
  Dec(FCount, N);
end;

function DynArrayInsert(var V: ExtendedArray; const Idx: Integer; const Count: Integer): Integer;
var I, L : Integer;
    P    : Pointer;
begin
  L := Length(V);
  if (Idx > L) or (Idx + Count <= 0) or (Count <= 0) then
    begin
      Result := -1;
      exit;
    end;
  SetLength(V, L + Count);
  I := Idx;
  if I < 0 then
    I := 0;
  P := @V[I];
  if I < L then
    Move(P^, V[I + Count], (L - I) * Sizeof(Extended));
  FillChar(P^, Count * Sizeof(Extended), #0);
  Result := I;
end;


procedure TExtendedArray.Insert(const Idx: Integer; const ACount: Integer = 1);
var I : Integer;
begin
  I := DynArrayInsert(FData, Idx, ACount);
  if I >= 0 then
    begin
      Inc(FCapacity, ACount);
      Inc(FCount, ACount);
    end;
end;

function TExtendedArray.GetRange(const LoIdx, HiIdx: Integer): ExtendedArray;
var L, H : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(HiIdx, FCount);
  if H >= L then
    Result := Copy(FData, L, H - L + 1) else
    Result := nil;
end;

procedure TExtendedArray.SetRange(const LoIdx, HiIdx: Integer; const V: ExtendedArray);
var L, H, C : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(HiIdx, FCount);
  C := MaxInt(MinInt(Length(V), H - L + 1), 0);
  if C > 0 then
    Move(V[0], FData[L], C * Sizeof(Extended));
end;

constructor TExtendedArray.Create(const V: ExtendedArray);
begin
  inherited Create;
  SetData(V);
end;

procedure TExtendedArray.SetData(const AData: ExtendedArray);
begin
  FData := AData;
  FCount := Length(FData);
  FCapacity := FCount;
end;

function TExtendedArray.DuplicateRange(const LoIdx, HiIdx: Integer): AArray;
var L, H, C : Integer;
begin
  L := MaxInt(0, LoIdx);
  H := MinInt(HiIdx, FCount);
  C := MaxInt(0, H - L + 1);
  Result := CreateInstance as TExtendedArray;
  TExtendedArray(Result).FCount := C;
  if C > 0 then
    TExtendedArray(Result).FData := Copy(FData, L, C);
end;

procedure TExtendedArray.Assign(const V: ExtendedArray);
begin
  FData := Copy(V);
  FCount := Length(FData);
  FCapacity := FCount;
end;


function AsSingleArray(const V: array of Single): SingleArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsDoubleArray(const V: array of Double): DoubleArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

function AsExtendedArray(const V: array of Extended): ExtendedArray;
var I : Integer;
begin
  SetLength(Result, High(V) + 1);
  for I := 0 to High(V) do
    Result[I] := V[I];
end;

procedure TExtendedArray.Assign(const V: Array of Extended);
begin
  FData := AsExtendedArray(V);
  FCount := Length(FData);
  FCapacity := FCount;
end;

procedure TExtendedArray.Assign(const Source: TObject);
begin
  if Source is TExtendedArray then
    begin
      FCount := TExtendedArray(Source).FCount;
      FData := Copy(TExtendedArray(Source).FData, 0, FCount);
    end
  else
    inherited Assign(Source);
end;

{                                                                              }
{ TVector  plus+                                                                   }
{                                                                              }
class function TVectorClass.CreateInstance: AType;
begin
  Result := TVectorClass.Create;
end;

procedure TVectorClass.CheckVectorSizeMatch(const Size: Integer);
begin
  if Size <> FCount then
    raise EVectorInvalidSize.CreateFmt('Vector sizes mismatch (%d, %d)', [FCount, Size]);
end;

procedure TVectorClass.Add(const V: MFloat);
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    begin
      P^ := P^ + V;
      Inc(P);
    end;
end;

procedure TVectorClass.Add(const V: PMFloat; const Count: Integer);
var I    : Integer;
    P, Q : PMFloat;
begin
  CheckVectorSizeMatch(Count);
  P := Pointer(FData);
  Q := V;
  for I := 0 to Count - 1 do
    begin
      P^ := P^ + Q^;
      Inc(P);
      Inc(Q);
    end;
end;

procedure TVectorClass.Add(const V: PInt64; const Count: Integer);
var I : Integer;
    P : PMFloat;
    Q : PInt64;
begin
  CheckVectorSizeMatch(Count);
  P := Pointer(FData);
  Q := V;
  for I := 0 to Count - 1 do
    begin
      P^ := P^ + Q^;
      Inc(P);
      Inc(Q);
    end;
end;

procedure TVectorClass.Add(const V: MFloatArray);
begin
  Add(PMFloat(V), Length(V));
end;



procedure TVectorClass.Add(const V: Int64Array);
begin
  Add(PInt64(V), Length(V));
end;   //}

procedure TVectorClass.Add(const V: TVectorBaseArray);
begin
  Add(PMFloat(V.Data), V.Count);
end;

procedure TVectorClass.Add(const V: TInt64Array);
begin
  Add(PInt64(V.Data), V.Count);
end;

procedure TVectorClass.Add(const V: TObject);
begin
  if V is TVectorBaseArray then
    Add(TVectorBaseArray(V)) else
  if V is TInt64Array then
    Add(TInt64Array(V))
  else   //}
    raise EVectorInvalidType.CreateFmt('Vector can not add with %s', [ObjectClassName(V)]);  // }
end;

procedure TVectorClass.Subtract(const V: MFloat);
begin
  Add(-V);
end;

procedure TVectorClass.Subtract(const V: PMFloat; const Count: Integer);
var I    : Integer;
    P, Q : PMFloat;
begin
  CheckVectorSizeMatch(Count);
  P := Pointer(FData);
  Q := V;
  for I := 0 to Count - 1 do
    begin
      P^ := P^ - Q^;
      Inc(P);
      Inc(Q);
    end;
end;

procedure TVectorClass.Subtract(const V: PInt64; const Count: Integer);
var I : Integer;
    P : PMFloat;
    Q : PInt64;
begin
  CheckVectorSizeMatch(Count);
  P := Pointer(FData);
  Q := V;
  for I := 0 to Count - 1 do
    begin
      P^ := P^ - Q^;
      Inc(P);
      Inc(Q);
    end;
end;

procedure TVectorClass.Subtract(const V: MFloatArray);
begin
  Subtract(PMFloat(V), Length(V));
end;


procedure TVectorClass.Subtract(const V: Int64Array);
begin
  Subtract(PInt64(V), Length(V));
end;    //}

procedure TVectorClass.Subtract(const V: TVectorBaseArray);
begin
  Subtract(PMFloat(V.Data), V.Count);
end;

procedure TVectorClass.Subtract(const V: TInt64Array);
begin
  Subtract(PInt64(V.Data), V.Count);
end;

procedure TVectorClass.Subtract(const V: TObject);
begin
  if V is TVectorBaseArray then
    Subtract(TVectorBaseArray(V)) else
  if V is TInt64Array then
    Subtract(TInt64Array(V))
  else
    raise EVectorInvalidType.CreateFmt('Vector can not subtract with %s', [ObjectClassName(V)]);  //}
end;

procedure TVectorClass.Multiply(const V: MFloat);
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    begin
      P^ := P^ * V;
      Inc(P);
    end;
end;

procedure TVectorClass.Multiply(const V: PMFloat; const Count: Integer);
var I    : Integer;
    P, Q : PMFloat;
begin
  CheckVectorSizeMatch(Count);
  P := Pointer(FData);
  Q := V;
  for I := 0 to Count - 1 do
    begin
      P^ := P^ * Q^;
      Inc(P);
      Inc(Q);
    end;
end;

procedure TVectorClass.Multiply(const V: PInt64; const Count: Integer);
var I : Integer;
    P : PMFloat;
    Q : PInt64;
begin
  CheckVectorSizeMatch(Count);
  P := Pointer(FData);
  Q := V;
  for I := 0 to Count - 1 do
    begin
      P^ := P^ * Q^;
      Inc(P);
      Inc(Q);
    end;
end;

procedure TVectorClass.Multiply(const V: MFloatArray);
begin
  Multiply(PMFloat(V), Length(V));
end;


procedure TVectorClass.Multiply(const V: Int64Array);
begin
  Multiply(PInt64(V), Length(V));
end;   //}

procedure TVectorClass.Multiply(const V: TVectorBaseArray);
begin
  Multiply(PMFloat(V.Data), V.Count);
end;

procedure TVectorClass.Multiply(const V: TInt64Array);
begin
  Multiply(PInt64(V.Data), V.Count);
end;

procedure TVectorClass.Multiply(const V: TObject);
begin
  if V is TVectorBaseArray then
    Multiply(TVectorBaseArray(V)) else
  if V is TInt64Array then
    Multiply(TInt64Array(V))
  else //}
    raise EVectorInvalidType.CreateFmt('Vector can not multiply with %s', [ObjectClassName(V)]);
end;

function TVectorClass.DotProduct(const V: PMFloat; const Count: Integer): MFloat;
var I    : Integer;
    P, Q : PMFloat;
begin
  CheckVectorSizeMatch(Count);
  P := Pointer(FData);
  Q := V;
  Result := 0.0;
  for I := 0 to Count - 1 do
    begin
      Result := Result + P^ * Q^;
      Inc(P);
      Inc(Q);
    end;
end;

function TVectorClass.DotProduct(const V: PInt64; const Count: Integer): MFloat;
var I : Integer;
    P : PMFloat;
    Q : PInt64;
begin
  CheckVectorSizeMatch(Count);
  P := Pointer(FData);
  Q := V;
  Result := 0.0;
  for I := 0 to Count - 1 do
    begin
      Result := Result + P^ * Q^;
      Inc(P);
      Inc(Q);
    end;
end;

function TVectorClass.DotProduct(const V: MFloatArray): MFloat;
begin
  Result := DotProduct(PMFloat(V), Length(V));
end;

function TVectorClass.DotProduct(const V: Int64Array): MFloat;
begin
  Result := DotProduct(PInt64(V), Length(V));
end;  //}

function TVectorClass.DotProduct(const V: TVectorBaseArray): MFloat;
begin
  Result := DotProduct(PMFloat(V.Data), V.Count);
end;

function TVectorClass.DotProduct(const V: TInt64Array): MFloat;
begin
  Result := DotProduct(PInt64(V.Data), V.Count);
end;

function TVectorClass.DotProduct(const V: TObject): MFloat;
begin
  if V is TVectorBaseArray then
    Result := DotProduct(TVectorBaseArray(V)) else
  if V is TInt64Array then
    Result := DotProduct(TInt64Array(V))
  else //}
    raise EVectorInvalidType.CreateFmt('Vector can not calculate dot product with %s', [ObjectClassName(V)]);
end;

function TVectorClass.Norm: MFloat;
begin
  Result := Sqrt(DotProduct(self));
end;

function TVectorClass.Min: MFloat;
var I : Integer;
    P : PMFloat;
begin
  if FCount = 0 then
    raise EVectorEmpty.Create('No minimum: Vector empty');
  P := Pointer(FData);
  Result := P^;
  Inc(P);
  for I := 1 to FCount - 1 do
    begin
      if P^ < Result then
        Result := P^;
      Inc(P);
    end;
end;

function TVectorClass.Max: MFloat;
var I : Integer;
    P : PMFloat;
begin
  if FCount = 0 then
    raise EVectorEmpty.Create('No maximum: Vector empty');
  P := Pointer(FData);
  Result := P^;
  Inc(P);
  for I := 1 to FCount - 1 do
    begin
      if P^ > Result then
        Result := P^;
      Inc(P);
    end;
end;

function TVectorClass.Range(var Min, Max: MFloat): MFloat;
var I : Integer;
    P : PMFloat;
begin
  if FCount = 0 then
    raise EVectorEmpty.Create('No range: Vector empty');
  P := Pointer(FData);
  Min := P^;
  Max := P^;
  Inc(P);
  for I := 1 to FCount - 1 do
    begin
      if P^ < Min then
        Min := P^ else
        if P^ > Max then
          Max := P^;
      Inc(P);
    end;
  Result := Max - Min;
end;

function TVectorClass.IsZero(const CompareDelta: MFloat): Boolean;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    if not FloatZero(P^, CompareDelta) then
      begin
        Result := False;
        exit;
      end else
      Inc(P);
  Result := True;
end;

function TVectorClass.HasZero(const CompareDelta: MFloat): Boolean;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    if FloatZero(P^, CompareDelta) then
      begin
        Result := True;
        exit;
      end else
      Inc(P);
  Result := False;
end;

function TVectorClass.HasNegative: Boolean;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    if P^ < 0.0 then
      begin
        Result := True;
        exit;
      end else
      Inc(P);
  Result := False;
end;

procedure TVectorClass.Normalize;
var I : Integer;
    P : PMFloat;
    S : MFloat;
begin
  if FCount = 0 then
    exit;
  S := Norm;
  if FloatZero(S, VectorFloatDelta) then
    exit;
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    begin
      P^ := P^ / S;
      Inc(P);
    end;
end;

procedure TVectorClass.Negate;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    begin
      P^ := -P^;
      Inc(P);
    end;
end;

procedure TVectorClass.ValuesInvert;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    begin
      if P^ <> 0.0 then
        P^ := 1.0 / P^;
      Inc(P);
    end;
end;

procedure TVectorClass.ValuesSqr;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    begin
      P^ := Sqr(P^);
      Inc(P);
    end;
end;

procedure TVectorClass.ValuesSqrt;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  for I := 0 to FCount - 1 do
    begin
      P^ := Sqrt(P^);
      Inc(P);
    end;
end;

function TVectorClass.Sum: MFloat;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  Result := 0.0;
  for I := 0 to FCount - 1 do
    begin
      Result := Result + P^;
      Inc(P);
    end;
end;

function TVectorClass.SumOfSquares: MFloat;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  Result := 0.0;
  for I := 0 to FCount - 1 do
    begin
      Result := Result + Sqr(P^);
      Inc(P);
    end;
end;

procedure TVectorClass.SumAndSquares(out Sum, SumOfSquares: MFloat);
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  Sum := 0.0;
  SumOfSquares := 0.0;
  for I := 0 to FCount - 1 do
    begin
      Sum := Sum + P^;
      SumOfSquares := SumOfSquares + Sqr(P^);
      Inc(P);
    end;
end;

procedure TVectorClass.SumAndCubes(out Sum, SumOfSquares, SumOfCubes: MFloat);
var I : Integer;
    P : PMFloat;
    A : MFloat;
begin
  P := Pointer(FData);
  Sum := 0.0;
  SumOfSquares := 0.0;
  SumOfCubes := 0.0;
  for I := 0 to FCount - 1 do
    begin
      Sum := Sum + P^;
      A := Sqr(P^);
      SumOfSquares := SumOfSquares + A;
      A := A * P^;
      SumOfCubes := SumOfCubes + A;
    end;
end;

procedure TVectorClass.SumAndQuads(out Sum, SumOfSquares, SumOfCubes,
    SumOfQuads: MFloat);
var I : Integer;
    P : PMFloat;
    A : MFloat;
begin
  P := Pointer(FData);
  Sum := 0.0;
  SumOfSquares := 0.0;
  SumOfCubes := 0.0;
  SumOfQuads := 0.0;
  for I := 0 to FCount - 1 do
    begin
      Sum := Sum + P^;
      A := Sqr(P^);
      SumOfSquares := SumOfSquares + A;
      A := A * P^;
      SumOfCubes := SumOfCubes + A;
      A := A * P^;
      SumOfQuads := SumOfQuads + A;
    end;
end;

function TVectorClass.WeightedSum(const Weights: TVectorClass): MFloat;
begin
  Result := DotProduct(Weights);
end;

function TVectorClass.Mean: MFloat;
begin
  if FCount = 0 then
    raise EVectorEmpty.Create('No mean: Vector empty');
  Result := Sum / FCount;
end;

function TVectorClass.HarmonicMean: MFloat;
var I : Integer;
    P : PMFloat;
    S : MFloat;
begin
  if FCount = 0 then
    raise EVectorEmpty.Create('No harmonic mean: Vector empty');
  P := Pointer(FData);
  S := 0.0;
  for I := 0 to FCount - 1 do
    begin
      if P^ < 0.0 then
        raise EVectorInvalidValue.Create(
            'No harmonic mean: Vector contains negative values');
      S := S + 1.0 / P^;
      Inc(P);
    end;
  Result := FCount / S;
end;

function TVectorClass.GeometricMean: MFloat;
var I : Integer;
    P : PMFloat;
    S : MFloat;
begin
  if FCount = 0 then
    raise EVectorEmpty.Create('No geometric mean');
  P := Pointer(FData);
  S := 0.0;
  for I := 0 to FCount - 1 do
    begin
      if P^ <= 0.0 then
        raise EVectorInvalidValue.Create(
            'No geometric mean: Vector contains non-positive values');
      S := S + Ln(P^);
    end;
  Result := Exp(S / FCount);
end;

function TVectorClass.Median: MFloat;
var V : TVectorClass;
    I : Integer;
begin
  if FCount = 0 then
    raise EVectorEmpty.Create('No median: Vector empty');
  V := TVectorClass(Duplicate);
  try
    V.Sort;
    I := (FCount - 1) div 2;
    if FCount mod 2 = 0 then
      Result := (V.FData[I] + V.FData[I + 1]) / 2.0
    else
      Result := V.FData[I];
  finally
    V.Free;
  end;
end;

function TVectorClass.Mode: MFloat;
var V         : TVectorClass;
    I         : Integer;
    P         : PMFloat;
    ModeVal   : MFloat;
    ModeCount : Integer;
    CurrVal   : MFloat;
    CurrCount : Integer;
begin
  if FCount = 0 then
    raise EVectorEmpty.Create('No mode: Vector empty');
  V := TVectorClass(Duplicate);
  try
    V.Sort;
    Assert(V.FCount = FCount, 'V.FCount = FCount');
    Assert(V.FCount > 0, 'V.FCount > 0');
    P := Pointer(V.FData);
    ModeVal := P^;
    ModeCount := 0;
    CurrVal := P^;
    CurrCount := 1;
    Inc(P);
    for I := 1 to V.FCount - 1 do
      begin
        if P^ = CurrVal then
          Inc(CurrCount)
        else
          begin
            if CurrCount > ModeCount then
              begin
                ModeVal := CurrVal;
                ModeCount := CurrCount;
              end;
            CurrVal := P^;
            CurrCount := 1;
          end;
        Inc(P);
      end;
    if CurrCount > ModeCount then
      ModeVal := CurrVal;
  finally
    V.Free;
  end;
  Result := ModeVal;
end;

function TVectorClass.Variance: MFloat;
var Sum, SumOfSquares : MFloat;
begin
  if FCount <= 1 then
    Result := 0.0
  else
    begin
      SumAndSquares(Sum, SumOfSquares);
      Result := (SumOfSquares - Sqr(Sum) / FCount) / (FCount - 1);
    end;
end;

function TVectorClass.StdDev(var Mean: MFloat): MFloat;
var S    : MFloat;
    I, N : Integer;
    P    : PMFloat;
begin
  N := FCount;
  if N = 0 then
    begin
      Result := 0.0;
      exit;
    end;
  P := Pointer(FData);
  if N = 1 then
    begin
      Mean := P^;
      Result := P^;
      exit;
    end;
  Mean := self.Mean;
  S := 0.0;
  for I := 0 to N - 1 do
    begin
      S := S + Sqr(P^ - Mean);
      Inc(P);
    end;
  Result := Sqrt(S / (N - 1));
end;

function TVectorClass.PopulationVariance: MFloat;
var Sum, Sum2 : MFloat;
begin
  if FCount = 0 then
    Result := 0.0
  else
    begin
      SumAndSquares(Sum, Sum2);
      Result := (Sum2 - Sqr(Sum) / FCount) / FCount;
    end;
end;

function TVectorClass.PopulationStdDev: MFloat;
begin
  Result := Sqrt(PopulationVariance);
end;

function TVectorClass.M1: MFloat;
begin
  Result := Sum / (FCount + 1.0);
end;

function TVectorClass.M2: MFloat;
var Sum, Sum2, NI : MFloat;
begin
  SumAndSquares(Sum, Sum2);
  NI     := 1.0 / (FCount + 1.0);
  Result := (Sum2 * NI)
          - Sqr(Sum * NI);
end;

function TVectorClass.M3: MFloat;
var Sum, Sum2, Sum3 : MFloat;
    NI, M1          : MFloat;
begin
  SumAndCubes(Sum, Sum2, Sum3);
  NI     := 1.0 / (FCount + 1.0);
  M1     := Sum * NI;
  Result := (Sum3 * NI)
          - (M1 * 3.0 * Sum2 * NI)
          + (2.0 * Sqr(M1) * M1);
end;

function TVectorClass.M4: MFloat;
var Sum, Sum2, Sum3, Sum4 : MFloat;
    NI, M1, M1Sqr         : MFloat;
begin
  SumAndQuads(Sum, Sum2, Sum3, Sum4);
  NI     := 1.0 / (FCount + 1.0);
  M1     := Sum * NI;
  M1Sqr  := Sqr(M1);
  Result := (Sum4 * NI)
          - (M1 * 4.0 * Sum3 * NI)
          + (M1Sqr * 6.0 * Sum2 * NI)
          - (3.0 * Sqr(M1Sqr));
end;

function TVectorClass.Skew: MFloat;
var Sum, Sum2, Sum3     : MFloat;
    M1, M2, M3          : MFloat;
    M1Sqr, S2N, S3N, NI : MFloat;
begin
  SumAndCubes(Sum, Sum2, Sum3);
  NI     := 1.0 / (FCount + 1.0);
  M1     := Sum * NI;
  M1Sqr  := Sqr(M1);
  S2N    := Sum2 * NI;
  S3N    := Sum3 * NI;
  M2     := S2N - M1Sqr;
  M3     := S3N
          - (M1 * 3.0 * S2N)
          + (2.0 * M1Sqr * M1);
  Result := M3 * Power(M2, -3/2);
end;

function TVectorClass.Kurtosis: MFloat;
var Sum, Sum2, Sum3, Sum4    : MFloat;
    M1, M2, M4, M1Sqr, M2Sqr : MFloat;
    S2N, S3N, NI             : MFloat;
begin
  SumAndQuads(Sum, Sum2, Sum3, Sum4);
  NI     := 1.0 / (FCount + 1.0);
  M1     := Sum * NI;
  M1Sqr  := Sqr(M1);
  S2N    := Sum2 * NI;
  S3N    := Sum3 * NI;
  M2     := S2N - M1Sqr;
  M2Sqr  := Sqr(M2);
  M4     := (Sum4 * NI)
          - (M1 * 4.0 * S3N)
          + (M1Sqr * 6.0 * S2N)
          - (3.0 * Sqr(M1Sqr));
  if FloatZero(M2Sqr, VectorFloatDelta) then
    raise EVectorDivisionByZero.Create('Kurtosis: Division by zero');
  Result := M4 / M2Sqr;
end;

function TVectorClass.Product: MFloat;
var I : Integer;
    P : PMFloat;
begin
  P := Pointer(FData);
  Result := 1.0;
  for I := 0 to FCount - 1 do
    begin
      Result := Result * P^;
      Inc(P);
    end;
end;

function TVectorClass.Angle(const V: TVectorClass): MFloat;
begin
  Assert(Assigned(V), 'Assigned(V)');
  Result := ArcCos(DotProduct(V) / (Norm * V.Norm));
end;


  {$DEFINE MATHS_TEST}
{                                                                              }
{ Test cases                                                                   }
{                                                                              }
{$IFDEF MATHS_TEST}
{$ASSERTIONS ON}
procedure TestvectorClass4;
var A, B : TVectorClass;
begin
  A := TVectorClass.Create;
  B := TVectorClass.Create;

  Assert(A.Count = 0);
  Assert(A.IsZero);

  A.AppendItem(1.0);
  A.AppendItem(2.0);
  A.AppendItem(3.0);

  Assert(A.Count = 3);
  Assert(A[0] = 1.0);
  Assert(A[1] = 2.0);
  Assert(A[2] = 3.0);

  Assert(A.Sum = 6.0);
  Assert(A.Min = 1.0);
  Assert(A.Max = 3.0);
  Assert(not A.IsZero);
  Assert(A.Median = 2.0);
  Assert(A.Mean = 2.0);
  Assert(A.Product = 6.0);
  Assert(Abs(A.Norm - Sqrt(14.0)) < 1e-10);

  B.Assign(A);
  Assert(B.Sum = 6.0);

  B.Add(A);
  Assert(B.Sum = 12.0);

  A.Clear;
  Assert(A.Count = 0);

  A.AppendItem(4.0);
  A.AppendItem(10.0);
  A.AppendItem(1.0);

  Assert(A.Count = 3);
  Assert(A[0] = 4.0);
  Assert(A[1] = 10.0);
  Assert(A[2] = 1.0);

  Assert(A.Sum = 15.0);
  Assert(A.Min = 1.0);
  Assert(A.Max = 10.0);
  Assert(not A.IsZero);
  Assert(A.Median = 4.0);
  Assert(A.Mean = 5.0);
  Assert(A.Product = 40.0);
  Assert(Abs(A.Norm - Sqrt(117.0)) < 1e-10);

  B.Free;
  A.Free;
end;
{$ENDIF}



end.

