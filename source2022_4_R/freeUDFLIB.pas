(*
 * FreeUDFLib.pas
 *   Miscellaneous "exports" from FreeUDFLib, making it easy to call these
 *   functions from a Delphi app.
 *)
unit FreeUDFLib;

interface

uses
  SysUtils, ibase;


const
  LibName = 'FreeUDFLib.dll';

(*
 * InterBase Date/Time Functions
 *)
function AddMonth(ib_date: PISC_QUAD;
  var months_to_add: Integer): PISC_QUAD; cdecl;
  external LibName;
function AddYear(ib_date: PISC_QUAD;
  var years_to_add: Integer): PISC_QUAD; cdecl;
  external LibName;
function AgeInDays(ib_date,
  ib_date_reference: PISC_QUAD): integer; cdecl; 
  external LibName;
function AgeInDaysThreshold(ib_date, ib_date_reference: PISC_QUAD;
  var Min, UseMin, Max, UseMax: Integer): integer; cdecl; 
  external LibName;
function AgeInMonths(ib_date,
  ib_date_reference: PISC_QUAD): integer; cdecl; 
  external LibName;
function AgeInMonthsThreshold(ib_date, ib_date_reference: PISC_QUAD;
  var Min, UseMin, Max, UseMax: Integer): integer; cdecl;
  external LibName;
function AgeInWeeks(ib_date,
  ib_date_reference: PISC_QUAD): integer; cdecl;
  external LibName;
function AgeInWeeksThreshold(ib_date, ib_date_reference: PISC_QUAD;
  var Min, UseMin, Max, UseMax: Integer): integer; cdecl;
  external LibName;
function CDOWLong(ib_date: PISC_QUAD): PChar; cdecl;
  external LibName;
function CDOWShort(ib_date: PISC_QUAD): PChar; cdecl;
  external LibName;
function CMonthLong(ib_date: PISC_QUAD): PChar; cdecl;
  external LibName;
function CMonthShort(ib_date: PISC_QUAD): PChar; cdecl;
  external LibName;
function DayOfMonth(ib_date: PISC_QUAD): integer; cdecl;
  external LibName;
function DayOfWeek(ib_date: PISC_QUAD): integer; cdecl;
  external LibName;
function DayOfYear(ib_date: PISC_QUAD): integer; cdecl;
  external LibName;
function MaxDate(ib_d1, ib_d2: PISC_QUAD): PISC_QUAD; cdecl;
  external LibName;
function MinDate(ib_d1, ib_d2: PISC_QUAD): PISC_QUAD; cdecl;
  external LibName;
function Month(ib_date: PISC_QUAD): integer; cdecl;
  external LibName;
function Quarter(ib_date: PISC_QUAD): integer; cdecl;
  external LibName;
function StripDate(ib_date: PISC_QUAD): PISC_QUAD; cdecl;
  external LibName;
function StripTime(ib_date: PISC_QUAD): PISC_QUAD; cdecl;
  external LibName;
function WeekOfYear(ib_date: PISC_QUAD): integer; cdecl;
  external LibName;
function WOY(ib_date: PISC_QUAD): PChar; cdecl;
  external LibName;
function Year(ib_date: PISC_QUAD):  integer; cdecl;
  external LibName;
function YearOfYear(ib_date: PISC_QUAD): integer; cdecl;
  external LibName;
(*
 * String Functions
 *)
function Character(var Number: Integer): PChar; cdecl;
  external LibName;
function CRLF: PChar; cdecl;
  external LibName;
function FindWord(sz: PChar; var i: Integer): PChar; cdecl;
  external LibName;
function FindWordIndex(sz: PChar; var i: Integer): Integer; cdecl;
  external LibName;
function Left(sz: PChar; var Number: Integer): PChar; cdecl;
  external LibName;
function LineWrap(sz: PChar; var Start, ColWidth: Integer): PChar; cdecl;
  external LibName;
function lrTrim(sz: PChar): PChar; cdecl;
  external LibName;
function lTrim(sz: PChar): PChar; cdecl;
  external LibName;
function Mid(sz: PChar; var Start, Number: Integer): PChar; cdecl;
  external LibName;
function PadLeft(sz, szPadString: PChar; var Len: Integer): PChar; cdecl;
  external LibName;
function PadRight(sz, szPadString: PChar; var Len: Integer): PChar; cdecl;
  external LibName;
function ProperCase(sz: PChar): PChar; cdecl;
  external LibName;
function QPushQueue(szQ: PChar; var MaxQLength: Integer;
  szEntry: PChar): PChar; cdecl;
  external LibName;
function Right(sz: PChar; var Number: Integer): PChar; cdecl;
  external LibName;
function rTrim(sz: PChar): PChar; cdecl;
  external LibName;
function StringLength(sz: PChar): Integer; cdecl;
  external LibName;
function StripString(sz, szCharsToStrip: PChar): PChar; cdecl;
  external LibName;
function SubStr(szSubStr, szStr: PChar): Integer; cdecl;
  external LibName;
function GenerateFormattedName(szFormatString, szNamePrefix, szFirstName,
  szMiddleInitial, szLastName, szNameSuffix: PChar): PChar; cdecl; 
  external LibName;
function ValidateNameFormat(szFormatString: PChar): Integer; cdecl;
  external LibName;
function ValidateRegularExpression(sz: PChar): Integer; cdecl; 
  external LibName;
function ValidateStringInRE(sz, re: PChar): Integer; cdecl; 
  external LibName;
function GenerateSndxIndex(sz: PChar): PChar; cdecl;
  external LibName;
(*
 * Miscellaneous functions
 *)
function CloseDebuggerOutput: Integer; cdecl; 
  external LibName;
function Debug(szDebuggerOutput: PChar): Integer; cdecl; 
  external LibName;
(* Return what IB THINKS is the temp path *)
function IBTempPath: PChar; cdecl; 
  external LibName;
function SetDebuggerOutput(szOutputFile: PChar): Integer; cdecl; 
  external LibName;
function ValidateCycleExpression(szCycleExpression: PChar;
  var ExprStart: Integer): Integer; cdecl; 
  external LibName;
function EvaluateCycleExpression(szCycleExpression: PChar;
  var ExprStart: Integer; OldDate, NewDate: PISC_QUAD;
  var Amount: Double): Integer; cdecl; 
  external LibName;
function EvaluateExpression(szExpr: PChar;
  szSymbols: PChar): PChar; cdecl; 
  external LibName;
(*
 * Math functions
 *)
function DollarVal(var Value: Double): PChar; cdecl; 
  external LibName;
function DoubleAbs(var Value: Double): Double; cdecl;
  external LibName;
function FixedPoint(var Value: Double;
  var DecimalPlaces: Integer): PChar; cdecl;
  external LibName;
function IntegerAbs(var Value: Integer): Integer; cdecl;
  external LibName;
function Modulo(var Numerator, Denominator: Integer): Integer; cdecl;
  external LibName;
function IsDivisibleBy(var Numerator, Denominator: Integer): Integer; cdecl; 
  external LibName;
function RoundFloat(var Value, RoundToNearest: Double): Double; cdecl; 
  external LibName;
function Truncate(var Value: Double): Integer; cdecl; 
  external LibName;
(*
 * Encryption
 *)
function IBPassword(pInStr: PChar): PChar; cdecl; 
  external LibName;

implementation

end.