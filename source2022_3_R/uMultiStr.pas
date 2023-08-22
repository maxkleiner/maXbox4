unit uMultiStr;

//
// Copyright (c) 1998-1999 by Luk Vermeulen (lvermeulen@seria.com)
// All rights reserved.
//
//

interface

uses
  Classes;

type
  TMultiStrings = class(TPersistent)
  private
    FRows: TList;
    FRowsEx, FColsEx: TStringList;

    procedure EnsureRow(const Row: integer);
    procedure EnsureColRow(const Col, Row: integer);

  protected
    // property helpers
    function GetRowCount : integer;
    procedure SetRowCount(Value: integer);
    function GetColCount : integer;
    procedure SetColCount(Value: integer);
    function GetCells(const Col, Row: integer): string;
    procedure SetCells(const Col, Row: integer; const Value: string);
    function GetObjects(const Col, Row: integer): TObject;
    procedure SetObjects(const Col, Row: integer; const Value: TObject);
    function GetRows(const Row: integer): TStrings;
    function GetCols(const Col: integer): TStrings;

  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Clear;

    property RowCount : integer
      read GetRowCount
      write SetRowCount;
    property ColCount: integer
      read GetColCount
      write SetColCount;
    property Rows[const Row: integer] : TStrings
      read GetRows;
    property Cols[const Col: integer] : TStrings
      read GetCols;
    property Cells[const Col, Row: integer] : string
      read GetCells
      write SetCells;
      default;
    property Objects[const Col, Row: integer] : TObject
      read GetObjects
      write SetObjects;
  end;

implementation

uses
  SysUtils;

{ --------------------------------------------------------------------------------------------- }

// TMultiStrings

constructor TMultiStrings.Create;
begin
  inherited;

  // create internal storage
  FRows := TList.Create;
  FRowsEx := TStringList.Create;
  FColsEx := TStringList.Create;
end;

destructor TMultiStrings.Destroy;
begin
  // free internal storage
  FRows.Free;
  FRowsEx.Free;
  FColsEx.Free;

  inherited;
end;

procedure TMultiStrings.Assign(Source: TPersistent);
var
  i: integer;
  msSource: TMultiStrings;
begin
  if (Source is TMultiStrings) then
    begin
    msSource := TMultiStrings(Source);

    Clear;
    for i:=0 to msSource.GetRowCount-1 do
      begin
      FRows[i] := TStringList.Create;
      TStringList(FRows[i]).AddStrings(msSource.FRows[i]);
      end;
    end;
end;

procedure TMultiStrings.EnsureRow(const Row: integer);
var
  i: integer;
begin
  // add needed rows
  if (Row > GetRowCount-1) then
    for i:=FRows.Count to Row do
      FRows.Add(TStringList.Create);
end;

procedure TMultiStrings.EnsureColRow(const Col, Row: integer);
var
  i, j, iColCount: integer;
begin
  // make sure row is there
  EnsureRow(Row);

  // add needed columns to all rows
  iColCount := TStringList(FRows[Row]).Count;
  if (Col > iColCount-1) then
    for i:=0 to FRows.Count-1 do
      for j:=TStringList(FRows[i]).Count to Col do
        TStringList(FRows[i]).Add(EmptyStr);
end;

function TMultiStrings.GetRowCount : integer;
begin
  Result := FRows.Count;
end;

procedure TMultiStrings.SetRowCount(Value: integer);
begin
  EnsureRow(Value-1);
end;

function TMultiStrings.GetColCount : integer;
begin
  if (GetRowCount = 0) then
    Result := 0
  else
    Result := TStringList(FRows[0]).Count;
end;

procedure TMultiStrings.SetColCount(Value: integer);
begin
  EnsureColRow(Value-1, 0);
end;

function TMultiStrings.GetCells(const Col, Row: integer) : string;
begin
  EnsureColRow(Col, Row);
  Result := TStringList(FRows[Row]).Strings[Col];
end;

procedure TMultiStrings.SetCells(const Col, Row: integer; const Value: string);
begin
  EnsureColRow(Col, Row);
  TStringList(FRows[Row]).Strings[Col] := Value;
end;

function TMultiStrings.GetObjects(const Col, Row: integer) : TObject;
begin
  EnsureColRow(Col, Row);
  Result := TStringList(FRows[Row]).Objects[Col];
end;

procedure TMultiStrings.SetObjects(const Col, Row: integer; const Value: TObject);
begin
  EnsureColRow(Col, Row);
  TStringList(FRows[Row]).Objects[Col] := Value;
end;

function TMultiStrings.GetCols(const Col: integer) : TStrings;
var
  i: integer;
begin
  // fill external cols
  FColsEx.Clear;
  for i:=0 to GetRowCount-1 do
    FColsEx.AddObject(GetCells(Col, i), GetObjects(Col, i));

  // return external cols
  Result := FColsEx;
end;

function TMultiStrings.GetRows(const Row: integer) : TStrings;
begin
  // make sure row is there
  EnsureRow(Row);

  // fill external rows
  FRowsEx.Assign(TStringList(FRows[Row]));

  // return external rows
  Result := FRowsEx;
end;

procedure TMultiStrings.Clear;
var
  i: integer;
begin
  // free all rows
  for i:=0 to FRows.Count-1 do
    TStringList(FRows[i]).Free;

  // clear list of rows
  FRows.Clear;
end;

{ --------------------------------------------------------------------------------------------- }

end.
