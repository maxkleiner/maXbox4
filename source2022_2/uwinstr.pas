{ ******************************************************************
  String routines for DELPHI
  ****************************************************************** }

unit uwinstr;

interface

uses
  utypes, ustrings, StdCtrls, SysUtils;

function StrDec(S : String) : String;
{ Replaces commas or decimal points by
  the decimal separator defined in SysUtils }

function IsNumeric(var S : String; var X : Float) : Boolean;
{ Replaces in string S the decimal comma by a point,
  tests if the resulting string represents a number.
  If so, returns this number in X }

function ReadNumFromEdit(Edit : TEdit) : Float;
{ Reads a floating point number from an Edit control }

procedure WriteNumToFile(var F : Text; X : Float);
{ Writes a floating point number in a text file,
  forcing the use of a decimal point }

implementation

var
  BadChar : Char;  { Decimal separator to be replaced }

function StrDec(S : String) : String;
begin
  StrDec := Replace(S, BadChar, DecimalSeparator);
end;

function IsNumeric(var S : String; var X : Float) : Boolean;
var
  ErrCode : Integer;
begin
  if DecimalSeparator = ',' then
    S := Replace(S, ',', '.');
  Val(S, X, ErrCode);
  IsNumeric := (ErrCode = 0);
end;

function ReadNumFromEdit(Edit : TEdit) : Float;
var
  S : String;
  X : Float;
begin
  S := Edit.Text;
  if IsNumeric(S, X) then
    ReadNumFromEdit := X
  else
    ReadNumFromEdit := 0.0;
end;

procedure WriteNumToFile(var F : Text; X : Float);
begin
  Write(F, ' ', Replace(FloatToStr(X), ',', '.'));
end;

begin
  if DecimalSeparator = '.' then BadChar := ',' else BadChar := '.';
end.
