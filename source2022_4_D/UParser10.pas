 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{*********************************************************}
{                                                         }
{     TExParser 10.1 for Borland Delphi                   }
{                                                         }
{       A component for parsing and evaluating            }
{       mathematical expressions specified at runtime     }
{                                                         }
{         Renate Schaaf (schaaf@math.usu.edu), 1993       }
{         Alin Flaider (aflaidar@datalog.ro), 1996        }
{         Stefan Hoffmeister                              }
{              Stefan.Hoffmeister@Uni-Passau.de, 1997     }
{                                                         }
{                                                         }
{  See  PARSER10.TXT  for documentation                   }
{                                                         }
{*********************************************************}
unit UParser10;



interface

uses
  SysUtils,
  Classes;

type
  { a couple of unfortunately necessary global declarations }
  ParserFloat = extended;  { please do NOT use "real", only single, double, extended}
  PParserFloat = ^ParserFloat;

  TToken=( variab, constant,
           minus,
           sum, diff, prod, divis, modulo, IntDiv, IntDIVZ,
           integerpower, realpower,
           square, third, fourth,
           FuncOneVar, FuncTwoVar );

  POperation = ^TOperation;
  { functions that are added to the engine MUST have this declaration }
  { make sure that the procedure is declared far !!! }
  TMathProcedure = procedure(AnOperation: POperation);
  TOperation = record
                 { MUST use pointers (!), because argument and destination are linked... }
                 Arg1, Arg2 : PParserFloat;
                 Dest : PParserFloat;

                 NextOperation : POperation;

                 Operation: TMathProcedure;
                 Token : TToken;
               end;

  EMathParserError = class(Exception); { create a new exception class and... }

  { ... some descendants }
  ESyntaxError = class(EMathParserError);
  EExpressionHasBlanks = class(EMathParserError);
  EExpressionTooComplex = class(EMathParserError);
  ETooManyNestings = class(EMathParserError);
  EMissMatchingBracket = class(EMathParserError);
  EBadName = class(EMathParserError);
  EParserInternalError = class(EMathParserError); { hopefully we will never see this one }


  { we COULD use Forms and the TExceptionEvent therein,
    but that would give us all the VCL overhead.
    Consequentially we just redeclare an appropriate event }
  TExParserExceptionEvent = procedure (Sender: TObject; E: Exception) of object;



  TCustomParser = class(TComponent)
  private
    { some pre-allocated space for variables }
    FA,
    FB,
    FC,
    FD,
    FE,
    FX,
    FY,
    FT: ParserFloat;
  private
    FExpression : string;
    FPascalNumberformat: boolean;
    FParserError : boolean;

    FVariables: TStringList;

    FStartOperationList: POperation;

    FOnParserError : TExParserExceptionEvent;

    function CalcValue: extended;
    {procedure SetExpression(const AnExpression: string);}
    procedure SetVar(const VarName: string; const Value: extended);
  protected
    { lists of available functions, see .Create for example use }
    FunctionOne : TStringList;     { functions with ONE argument, e.g. exp() }
    FunctionTwo : TStringList;     { functions with TWO arguments, e.g. max(,) }

    { predefined variables - could be left out }
    property A: ParserFloat read FA write FA;
    property B: ParserFloat read FB write FB;
    property C: ParserFloat read FC write FC;
    property D: ParserFloat read FD write FD;
    property E: ParserFloat read FE write FE;
    property T: ParserFloat read FT write FT;
    property X: ParserFloat read FX write FX;
    property Y: ParserFloat read FY write FY;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetExpression(const AnExpression: string);
    function ParseExpression(const AnExpression: string): boolean;
    procedure FreeExpression;

    { The PParserFloat returned points to the place in memory where the
      variable actually sits; to speed up assignment you can DIRECTLY
      assign data to the memory area. }
    function SetVariable(VarName: string; const Value: extended): PParserFloat;
    function GetVariable(const VarName: string): extended;

    procedure AddFunctionOneParam(const AFunctionName: string; const Func: TMathProcedure);
    procedure AddFunctionTwoParam(const AFunctionName: string; const Func: TMathProcedure);

    procedure ClearVariables;
    procedure ClearVariable(const AVarName: string);
    function  VariableExists(const AVarName: string): boolean;

    procedure ClearFunctions;
    procedure ClearFunction(const AFunctionName: string);

    property ParserError: boolean read FParserError;
    property LinkedOperationList: POperation read FStartOperationList;

    property Variable[const VarName: string]: extended read GetVariable write SetVar;
  published
    property Value: extended read CalcValue stored false;

    { setting Expression automatically parses it
      Warning: exceptions MAY be raised, if OnParserError is NOT assigned,
               otherwise the event will be triggered in case of an error }
    property Expression: string read FExpression write SetExpression;
    property PascalNumberformat: boolean read FPascalNumberformat write FPascalNumberformat default true;
    property OnParserError: TExParserExceptionEvent read FOnParserError write FOnParserError;
  end;




  TExParser = class(TCustomParser)
  public
    { overrides to add the properties below as variables
      and adds all the functions }
    constructor Create(AOwner: TComponent); override;

    { returns the string with the blanks inside removed }
    class function RemoveBlanks(const s: string): string;
  published
    { predefined variables - could be left out }
    property A;
    property B;
    property C;
    property D;
    property E;
    property T;
    property X;
    property Y;
 end;



{procedure Register; commented by GDD 9/25/00}

implementation

{$DEFINE UseMath}
{ Note: if you do not have the MATH unit simply remove the conditional define
        the component will continue to work, just a bit slower }

uses
  Math,
  UP10Build;

{Commented by GDD 9/25/00
procedure Register;
begin
  RegisterComponents('Samples', [TExParser]);
end;
}



{$IFDEF VER80}
  {$R *.D16}
{$ELSE}
  {$IFDEF VER90}
    {$R *.D32}
  {$ENDIF}
{$ENDIF}


{****************************************************************}
{                                                                }
{   Following are "built-in" calculation procedures              }
{                                                                }
{****************************************************************}
{
Naming convention for functions:

  Name of built-in function, prepended with an underscore.
  Example:

    ln --> _ln

Passed arguments / results:

  If the function takes any arguments - i.e. if it has been added to
  either the FunctionOne or the FunctionTwo list:

  - First  argument --> arg1^
  - Second argument --> arg2^

  The result of the operation must ALWAYS be put into

     dest^


 Note: These are POINTERS to floats.
}



{****************************************************************}
{                                                                }
{   These are mandatory procedures - never remove them           }
{                                                                }
{****************************************************************}

{ do nothing - this only happens if the "term" is just a number
  or a variable; otherwise this procedure will never be called }
procedure _nothing(AnOp: POperation); far;
begin
end;

procedure _Add(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := arg1^ + arg2^;
end;

procedure _Subtract(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := arg1^ - arg2^;
end;

procedure _Multiply(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := arg1^ * arg2^;
end;

procedure _RealDivide(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := arg1^ / arg2^;
end;

procedure _Modulo(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := trunc(arg1^) mod trunc(arg2^);
end;

procedure _IntDiv(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := trunc(arg1^) div trunc(arg2^);
end;

procedure _IntDIVZ(AnOp: POperation); far;
begin
  with AnOp^ do
    if trunc(arg2^)<>0
    then dest^ := trunc(arg1^) div trunc(arg2^)
    else dest^ :=0;
end;

procedure _Negate(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := -arg1^;
end;

procedure _IntPower(AnOp: POperation); far;
{$IFNDEF UseMath}
var
  n, i: longint;
{$ENDIF}
begin

{$IFNDEF UseMath}
  with AnOp^ do
  begin
    n := trunc(abs(arg2^))-1;

    case n of
      -1: dest^ := 1;
       0: dest^ := arg1^;
    else
      dest^ := arg1^;
      for i := 1 to n do
        dest^ := dest^ * arg1^;
    end;

    if arg2^ < 0 then
      dest^ := 1 / dest^;

  end;
{$ELSE}
  with AnOp^ do
    dest^ := IntPower(arg1^, trunc(arg2^));
{$ENDIF}
end;

procedure _square(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := sqr(arg1^);
end;

procedure _third(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := arg1^ * arg1^ * arg1^;
end;

procedure _forth(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := sqr(sqr(arg1^));
end;

procedure _power(AnOp: POperation); far;
begin
  with AnOp^ do
  begin
{$IFNDEF UseMath}
    if arg1^ = 0 then
      dest^ := 0
    else
      dest^ := exp(arg2^*ln(arg1^));
{$ELSE}
    dest^ := Power(arg1^, arg2^);
{$ENDIF}
  end;
end;


{****************************************************************}
{                                                                }
{   These are OPTIONAL procedures - you may remove them, though  }
{   it is preferable to not register them for use                }
{                                                                }
{****************************************************************}
procedure _sin(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := sin(arg1^);
end;

procedure _cos(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := cos(arg1^);
end;

procedure _arctan(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := arctan(arg1^);
end;

procedure _arcsin(AnOp: POperation); far;
begin
  with AnOp^ do
  begin
    if arg1^>1.0 then arg1^:=1.0
    else  if arg1^<-1.0 then arg1^:=-1.0;
    dest^ := arcsin(arg1^);
  end;
end;

procedure _arccos(AnOp: POperation); far;
begin

  with AnOp^ do
  Begin
    if arg1^>1.0 then arg1^:=1.0
    else  if arg1^<-1.0 then arg1^:=-1.0;
    dest^ := arccos(arg1^);
  end;
end;
procedure _arg(AnOp: POperation); far;
begin
  with AnOp^ do
    if arg1^ < 0 then
      dest^ := arctan(arg2^/arg1^)+Pi
    else
      if arg1^>0 then
        dest^ := arctan(arg2^/arg1^)
      else
        if arg2^ > 0 then
          dest^ := 0.5 * Pi
        else
          dest^ := -0.5 * Pi;
end;

procedure _sinh(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := (exp(arg1^)-exp(-arg1^))*0.5;
end;

procedure _cosh(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := (exp(arg1^)+exp(-arg1^))*0.5;
end;

procedure _cotan(AnOp: POperation); far;
begin
  with AnOp^ do
  {$IFNDEF UseMath}
    dest^ := cos(arg1^) / sin(arg1^);
  {$ELSE}
    dest^ := cotan(arg1^);
  {$ENDIF}
end;

procedure _tan(AnOp: POperation); far;
begin
  with AnOp^ do
  {$IFNDEF UseMath}
    dest^ := sin(arg1^) / cos(arg1^);
  {$ELSE}
    dest^ := tan(arg1^);
  {$ENDIF}
end;

procedure _exp(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := exp(arg1^);
end;

procedure _ln(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := ln(arg1^);
end;

procedure _log10(AnOp: POperation); far;
const
  _1_ln10 =  0.4342944819033;
begin
  with AnOp^ do
    dest^ := log10(arg1^);
    //dest^ := ln(arg1^) * _1_ln10;
end;

procedure _log2(AnOp: POperation); far;
const
  _1_ln2 = 1.4426950409;
begin
  with AnOp^ do
    dest^ := log2(arg1^);
   // dest^ := ln(arg1^) * _1_ln2;
end;

procedure _logN(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := logN(arg1^, arg2^);
    //dest^ := ln(arg1^) / ln(arg2^);
end;

procedure _sqrt(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := sqrt(arg1^);
end;


procedure _abs(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := abs(arg1^);
end;

procedure _min(AnOp: POperation); far;
begin
  with AnOp^ do
    if arg1^ < arg2^ then
      dest^ := arg1^
    else
      dest^ := arg2^;
end;

procedure _max(AnOp: POperation); far;
begin
  with AnOp^ do
    if arg1^ < arg2^ then
      dest^ := arg2^
    else
      dest^ := arg1^;
end;

procedure _heaviside(AnOp: POperation); far;
begin
  with AnOp^ do
    if arg1^ < 0 then
      dest^ := 0
    else
      dest^ := 1;
end;

procedure _sign(AnOp: POperation); far;
begin
  with AnOp^ do
    if arg1^ < 0 then
      dest^ := -1
    else
      if arg1^ > 0 then
        dest^ := 1.0
      else
        dest^ := 0.0;
end;

procedure _zero(AnOp: POperation); far;
begin
  with AnOp^ do
    if arg1^ = 0.0 then
      dest^ := 0.0
    else
      dest^ := 1.0;
end;

procedure _trunc(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := int(arg1^)
end;

procedure _ceil(AnOp: POperation); far;
begin
  with AnOp^ do
    if frac(arg1^) > 0 then
      dest^ := int(arg1^ + 1)
    else
      dest^ := int(arg1^);
end;

procedure _floor(AnOp: POperation); far;
begin
  with AnOp^ do
    if frac(arg1^) < 0 then
      dest^ := int(arg1^ - 1)
    else
      dest^ := int(arg1^);
end;

procedure _rnd(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := Random * int(arg1^);
end;

procedure _random(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := Random;
end;

procedure _radius(AnOp: POperation); far;
begin
  with AnOp^ do
    dest^ := sqrt(sqr(arg1^)+sqr(arg2^));
end;

procedure _phase(AnOp: POperation); far;
var
  a: ParserFloat;
begin
  with AnOp^ do
  begin
    a := arg1^ / (2/pi);
    dest^ := (2*pi) * (a-round(a));
  end;
end;

procedure _factorial(AnOp:Poperation); far;
var i:integer;
    n,r:int64;
begin
  with anop^ do
  begin
    n:=trunc(arg1^);
    r:=1;
    if n<=18 then for i:=2 to n do r:=r*i;
    dest^:=r;
  end;
end;



procedure _combo(AnOp: POperation); far;
var
  i:integer;
  f, nn, rr: int64;
  num: extended;

  (*
  function  factorial(n:integer):int64;
  var  i:integer;
  begin
    result:=1;
    if n<=18 then for i:=2 to n do result:=result*i;
  end;
  *)

begin
  with AnOp^ do
  begin
    dest^  := 1;  {this function defaults to 1 use binomial}
    nn     := trunc(arg1^);
    rr     := trunc(arg2^);
    num    := 1;
    if (nn <= rr) then  exit;
    if (rr * 2 > nn) then
    begin
      rr := nn - rr
    end;
    for i := 1 to rr do
    begin
      f := nn;
      if (nn mod i = 0) then f := f div i
      else  num := num / i;
      num := num * f;
      Dec(nn);
    end;
    dest^:=num;
end;
 (*
    r:=trunc(arg2^);
    n:=trunc(arg1^);
    dest^ := factorial(n)/(factorial(r)*factorial(n-r));
  *)
end;


{****************************************************************}
{                                                                }
{   TCustomParser                                                }
{                                                                }
{    A base class which does not publish the variable properties }
{    and adds no functions by default                            }
{                                                                }
{****************************************************************}
function TCustomParser.ParseExpression(const AnExpression: string):boolean;
var
  OperationLoop: POperation;
begin
  FreeExpression;
  FExpression := AnExpression;

  if AnExpression <> '' then
  begin
    Result := false;

    try
      ParseFunction( AnExpression,

                     FVariables,

                     FunctionOne,
                     FunctionTwo,

                     FPascalNumberformat,

                     FStartOperationList,
                     Result);

      FParserError := Result;

    except
      on E: Exception do
      begin
        FParserError := true;

        if Assigned(FOnParserError) then
        begin
          FOnParserError(Self, E);
          exit;
        end
        else
          raise;
      end;
    end;

    Result := not Result;

    OperationLoop := FStartOperationList;
    while OperationLoop <> nil do
    begin
      with OperationLoop^ do
      begin
        case Token of

          variab,
          constant:      Operation := _nothing;

          minus:         Operation := _negate;

          sum:           Operation := _add;
          diff:          Operation := _subtract;
          prod:          Operation := _multiply;
          divis:         Operation := _RealDivide;
          
          modulo:        Operation := _Modulo;
          intdiv:        Operation := _IntDiv;
          intDIVZ:       Operation := _IntDIVZ;

          integerpower:  Operation := _IntPower;
          realpower:     Operation := _Power;

          square:        Operation := _square;
          third:         Operation := _third;
          fourth:        Operation := _forth;

          FuncOneVar, FuncTwoVar:    { job has been done in build already !};
        end; {case}

        OperationLoop := NextOperation;
      end; {with OperationLoop^}

    end; {while OperationLoop<>nil}
  end;
end;

constructor TCustomParser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPascalNumberformat := true;

  FVariables := TStringList.Create;
  with FVariables do
  begin
    Sorted := true;
    Duplicates := dupIgnore;
  end;

  FunctionOne := TStringList.Create;
  with FunctionOne do
  begin
    Sorted := true;
    Duplicates := dupError;
  end;

  FunctionTwo := TStringList.Create;
  with FunctionTwo do
  begin
    Sorted := true;
    Duplicates := dupError;
  end;

end;

destructor TCustomParser.Destroy;
begin
  FreeExpression;

  ClearVariables;
  FVariables.Free;

  FunctionOne.Free;
  FunctionTwo.Free;

  inherited Destroy;
end;

                     


procedure TCustomParser.SetVar(const VarName: string; const Value: extended);
begin
  SetVariable(VarName, Value);
end;

function TCustomParser.SetVariable(VarName: string; const Value: extended): PParserFloat;
var
  i: integer;
begin
  { always convert to uppercase }
  VarName := UpperCase(VarName);

  with FVariables do
    if Find(VarName, i) then
    begin
      Result := PParserFloat(Objects[i]);
      Result^ := Value;
    end
    else
    begin
      if Length(Varname) = 1 then
        case VarName[1] of
          'A': Result := @FA;
          'B': Result := @FB;
          'C': Result := @FC;
          'D': Result := @FD;
          'E': Result := @FE;
          'T': Result := @FT;
          'X': Result := @FX;
          'Y': Result := @FY;
        else { case }
          { is the variable name a valid identifier? }
          if not IsValidIdent(VarName) then
            raise EBadName.Create(VarName);

          { unravelled loop for improved (string!) performance! }

          { check whether the variable contains any of the operators (DIV and MOD)
            this would confuse the parser... }
          if pos('+', VarName) <> 0 then
              raise EBadName.Create(VarName);

          if pos('-', VarName) <> 0 then
              raise EBadName.Create(VarName);

          if pos('*', VarName) <> 0 then
              raise EBadName.Create(VarName);

          if pos('/', VarName) <> 0 then
              raise EBadName.Create(VarName);

          if pos('^', VarName) <> 0 then
              raise EBadName.Create(VarName);

          if pos('DIV', VarName) <> 0 then
              raise EBadName.Create(VarName);

          if pos('MOD', VarName) <> 0 then
              raise EBadName.Create(VarName);

          new(Result);
        end { case }
      else
      begin
        { is the variable name a valid identifier? }
        if not IsValidIdent(VarName) then
          raise EBadName.Create(VarName);

        new(Result);
      end;

      Result^ := Value;

      AddObject(VarName, TObject(Result));
    end
end;

function TCustomParser.GetVariable(const VarName: string): extended;
var
  i: integer;
begin
  with FVariables do
    if Find(UpperCase(VarName), i) then
      Result := PParserFloat(Objects[i])^
    else
      Result := 0.0;
end;

procedure TCustomParser.AddFunctionOneParam(const AFunctionName: string; const Func: TMathProcedure);
begin
  if IsValidIdent(AFunctionName) then
    FunctionOne.AddObject(UpperCase(AFunctionName), TObject(@Func))
  else
    raise EBadName.Create(AFunctionName);
end;

procedure TCustomParser.AddFunctionTwoParam(const AFunctionName: string; const Func: TMathProcedure);
begin
  if IsValidIdent(AFunctionName) then
    FunctionTwo.AddObject(UpperCase(AFunctionName), TObject(@Func))
  else
    raise EBadName.Create(AFunctionName);
end;

procedure TCustomParser.ClearVariables;
var
  i: integer;
  APPFloat: PParserFloat;
  AString: string; { disregard stack consumption }
begin
  with FVariables do
  begin
    i := Count;
    while i > 0 do
    begin
      dec(i);
      AString := Strings[i];
      if (Length(AString) <> 1) or
         (not (AString[1] in ['A'..'E', 'T', 'X', 'Y'])) then
      begin
        APPFloat := PParserFloat(Objects[i]);
        if APPFloat <> nil then
          dispose( APPFloat ); { dispose only user-defined variables }
      end;
    end;

    Clear;
  end;

  with FVariables do
  begin
    i := Count;
    while i > 0 do
    begin
      dec(i);
      AString := Strings[i];
      if (Length(AString) <> 1) or
         (not (AString[1] in ['A'..'E', 'T', 'X', 'Y'])) then
      begin
        APPFloat := PParserFloat(Objects[i]);
        if APPFloat <> nil then
          dispose( APPFloat ); { dispose only user-defined variables }
      end;
    end;

    Clear;
  end;

  SetExpression(''); { invalidate expression }
end;

procedure TCustomParser.ClearVariable(const AVarName: string);
var
  index: integer;
begin
  with FVariables do
  begin
    if Find(AVarName, index) then
    begin
      if (Length(AVarName) <> 1) and
         (not (AVarName[1] in ['A'..'E', 'T', 'X', 'Y'])) then
        dispose( PParserFloat(Objects[index]) ); { dispose only user-defined variables }

      Delete(index);
    end;
  end;

  SetExpression(''); { invalidate expression }
end;

function TCustomParser.VariableExists(const AVarName: string): boolean;
var
  index: integer;
begin
  Result := FVariables.Find(UpperCase(AVarName), index);
end;

procedure TCustomParser.ClearFunctions;
begin
  FunctionOne.Clear;
  FunctionTwo.Clear;

  SetExpression(''); { invalidate expression }
end;

procedure TCustomParser.ClearFunction(const AFunctionName: string);
var
  index: integer;
begin
  with FunctionOne do
  begin
    if Find(AFunctionName, index) then
    begin
      Delete(index);
      SetExpression(''); { invalidate expression }
      exit;
    end;
  end;

  with FunctionTwo do
  begin
    if Find(AFunctionName, index) then
    begin
      Delete(index);
      SetExpression(''); { invalidate expression }
    end;
  end;
end;


procedure TCustomParser.FreeExpression;
var
  LastOP,
  NextOP: POperation;
begin
  LastOP := FStartOperationList;

  while LastOP <> nil do
  begin
    NextOP := LastOP^.NextOperation;

    while NextOP <> nil do
      with NextOP^ do
      begin
        if (Arg1 = lastop^.Arg1) or (Arg1 = lastop^.Arg2) or (Arg1 = lastop^.Dest) then
          Arg1 := nil;

        if (Arg2 = lastop^.Arg1) or (Arg2 = lastop^.Arg2) or (Arg2 = lastop^.Dest) then
          Arg2 := nil;

        if (Dest = lastop^.Arg1) or (Dest = lastop^.Arg2) or (Dest = lastop^.Dest) then
          Dest := nil;

        NextOP := NextOperation;
      end;

    with LastOP^, FVariables do
    begin
      if IndexOfObject( TObject(Arg1)) >= 0 then Arg1 := nil;
      if IndexOfObject( TObject(Arg2)) >= 0 then Arg2 := nil;
      if IndexOfObject( TObject(Dest)) >= 0 then Dest := nil;

      if (Dest <> nil) and (Dest <> Arg2) and (Dest <> Arg1) then
        dispose(Dest);

      if (Arg2 <> nil) and (Arg2 <> Arg1) then
        dispose(Arg2);

      if (Arg1 <> nil) then
        dispose(Arg1);
    end;

    NextOP := LastOP^.NextOperation;
    dispose(LastOP);
    LastOP := NextOP;
  end;

  FStartOperationList := nil;
end;

procedure TCustomParser.SetExpression(const AnExpression: string);
begin
  ParseExpression(AnExpression); { this implies FExpression := AnExpression }
end;


function TCustomParser.CalcValue: extended;
var
  LastOP: POperation;
begin
  if FStartOperationList <> nil then
  begin
    LastOP := FStartOperationList;

    while LastOP^.NextOperation <> nil do
    begin
      with LastOP^ do
      begin
        Operation(LastOP);
        LastOP := NextOperation;
      end;
    end;
    LastOP^.Operation(LastOP);

    Result := LastOP^.Dest^;
  end
  else
    Result := 0;
end;


{****************************************************************}
{                                                                }
{   TCustomParser                                                }
{                                                                }
{****************************************************************}
constructor TExParser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  with FVariables do
  begin
    AddObject( 'A', TObject(@FA));
    AddObject( 'B', TObject(@FB));
    AddObject( 'C', TObject(@FC));
    AddObject( 'D', TObject(@FD));
    AddObject( 'E', TObject(@FE));
    AddObject( 'X', TObject(@FX));
    AddObject( 'Y', TObject(@FY));
    AddObject( 'T', TObject(@FT));
  end;

  with FunctionOne do
  begin
{....$DEFINE SpeedCompare} { compare speed against older versions with less functions }

    AddObject('TAN', TObject(@_tan));
    AddObject('SIN', TObject(@_sin));
    AddObject('COS', TObject(@_cos));
    AddObject('SINH', TObject(@_sinh));
    AddObject('COSH', TObject(@_cosh));
    AddObject('ARCTAN', TObject(@_arctan));
    AddObject('ARCSIN', TObject(@_arcsin));
    AddObject('ARCCOS', TObject(@_arccos));
    Addobject('FACT', TObject(@_factorial));

{$IFNDEF SpeedCompare}
    AddObject('COTAN', TObject(@_cotan));
    AddObject('ARG', TObject(@_arg));
{$ENDIF}

    AddObject('EXP', TObject(@_exp));
    AddObject('LN', TObject(@_ln));
{$IFNDEF SpeedCompare}
    AddObject('LOG10', TObject(@_log10));
    AddObject('LOG2', TObject(@_log2));

    AddObject('SQR', TObject(@_square));
{$ENDIF}
    AddObject('SQRT', TObject(@_sqrt));

    AddObject('ABS', TObject(@_abs));
{$IFNDEF SpeedCompare}
    AddObject('TRUNC', TObject(@_trunc));
    AddObject('INT', TObject(@_trunc)); { NOTE: INT = TRUNC ! }
    AddObject('CEIL', TObject(@_ceil));
    AddObject('FLOOR', TObject(@_floor));
{$ENDIF}

    AddObject('HEAV', TObject(@_heaviside));
    AddObject('SIGN', TObject(@_sign));
    AddObject('ZERO', TObject(@_zero));
    AddObject('PH', TObject(@_phase));
    AddObject('RND', TObject(@_rnd));


{$IFNDEF SpeedCompare}
    AddObject('RANDOM', TObject(@_random));
{$ENDIF}
  end;

  with FunctionTwo do
  begin
    AddObject('MAX', TObject(@_max));
    AddObject('MIN', TObject(@_min));
    AddObject('COMBO', TObject(@_combo));

{$IFNDEF SpeedCompare}
    AddObject('POWER', TObject(@_Power));
    AddObject('INTPOWER', TObject(@_IntPower));

    AddObject('LOGN', TObject(@_logN));
{$ENDIF}
  end;
end;


class function TExParser.RemoveBlanks(const s: string): string;
{deletes all blanks in s}
var
  i : integer;
begin
  Result := s;
  StringReplace(Result,' ','',[rfReplaceAll]);
  (*
  i := pos(' ', Result);
  while i > 0 do
  begin
    delete(Result, i, 1);
    i := pos(' ', Result);
  end;
  *)
end;

end.
