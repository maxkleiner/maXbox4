// **************************************************************************************************
//
// Unit WDCC.OleVariant.Enum
// unit for the WMI Delphi Code Creator
// https://github.com/RRUZ/wmi-delphi-code-creator
//
// The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy of the
// License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
// ANY KIND, either express or implied. See the License for the specific language governing rights
// and limitations under the License.
//
// The Original Code is WDCC.OleVariant.Enum.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2021 Rodrigo Ruz V.
// All Rights Reserved.
//
// **************************************************************************************************

unit WDCCOleVariantEnum;

interface

Uses
  ActiveX;

type
  IOleVariantEnum = interface
  ['{1C06BCF6-1C6D-473E-993F-2B231B17D4F4}']
    function GetCurrent: OLEVariant;
    function MoveNext: Boolean;
    property Current: OLEVariant read GetCurrent;
  end;

  IGetOleVariantEnum = interface
  ['{1C06BCF6-1C6D-473E-993F-2B231B17D4F5}']
    function GetEnumerator: IOleVariantEnum;
  end;

  TOleVariantEnum = class(TInterfacedObject, IOleVariantEnum, IGetOleVariantEnum)
  private
    FCurrent: OLEVariant;
    FEnum: IEnumVARIANT;
  public
    function GetEnumerator: IOleVariantEnum;
    constructor Create(Collection: OLEVariant);
    function GetCurrent: OLEVariant;
    function MoveNext: Boolean;
    property Current: OLEVariant read GetCurrent;
  end;

  TOleVariantArrayEnum = class(TInterfacedObject, IOleVariantEnum, IGetOleVariantEnum)
  private
    FCollection: OLEVariant;
    FIndex: Integer;
    FLowBound: Integer;
    FHighBound: Integer;
  public
    function GetEnumerator: IOleVariantEnum;
    constructor Create(Collection: OLEVariant);
    function GetCurrent: OLEVariant;
    function MoveNext: Boolean;
    property Current: OLEVariant read GetCurrent;
  end;

function GetOleVariantEnum(Collection: OLEVariant): IGetOleVariantEnum;
function GetOleVariantArrEnum(Collection: OLEVariant): IGetOleVariantEnum;

implementation

Uses
  Variants;

function GetOleVariantEnum(Collection: OLEVariant): IGetOleVariantEnum;
begin
  Result := TOleVariantEnum.Create(Collection);
end;

function GetOleVariantArrEnum(Collection: OLEVariant): IGetOleVariantEnum;
begin
  Result := TOleVariantArrayEnum.Create(Collection);
end;

{ TOleVariantEnum }

constructor TOleVariantEnum.Create(Collection: OLEVariant);
begin
  inherited Create;
  FEnum := IUnknown(Collection._NewEnum) As IEnumVARIANT;
end;

function TOleVariantEnum.GetCurrent: OLEVariant;
begin
  Result := FCurrent;
end;

function TOleVariantEnum.GetEnumerator: IOleVariantEnum;
begin
  Result := Self;
end;

function TOleVariantEnum.MoveNext: Boolean;
var
  iValue: LongWord;
begin
  FCurrent := Unassigned; // avoid memory leaks
  Result := FEnum.Next(1, FCurrent, iValue) = S_OK;
end;

{ TOleVariantArrayEnum }

constructor TOleVariantArrayEnum.Create(Collection: OLEVariant);
begin
  inherited Create;
  FCollection := Collection;
  FLowBound := VarArrayLowBound(FCollection, 1);
  FHighBound := VarArrayHighBound(FCollection, 1);
  FIndex := FLowBound - 1;
end;

function TOleVariantArrayEnum.GetCurrent: OLEVariant;
begin
  Result := FCollection[FIndex];
end;

function TOleVariantArrayEnum.GetEnumerator: IOleVariantEnum;
begin
  Result := Self;
end;

function TOleVariantArrayEnum.MoveNext: Boolean;
begin
  Result := FIndex < FHighBound;
  if Result then
    Inc(FIndex);
end;

end.
