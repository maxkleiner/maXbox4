//{$DEFINE DEBUG}
{$UNDEF DEBUG}

unit interface2_so;

  {:
  just the view
  06.05.01 Purpose: export an object-reference from a DLL
  07.09.01 Purpose: export type and para-information
  12.08.02 Purpose: implement choice pattern with intF_ID
  13.08.02 DEBUG monitoring max@kleiner.com
  29.09.02 queryDLLIterfaceTwo just a Test in Frankfurt}

{ Important note about shared object exception handling:  In
  order for exception handling to work across multiple modules,
  ShareExcept must be the first unit in your library's USES
  clause AND your project's (select Project-View Source) USES
  clause if 1) your project loads (either directly or indirectly)
  shared omore than one Kylix-built bject, and 2) your project or
  the shared object are not built with runtime packages (baseclx).
  ShareExcept is the interface unit to the dynamic exception
  unwinder (libunwind.so.6), which must be deployed along with
  your shared object. }

interface



uses
  {$IFDEF DEBUG}
   QDialogs,
  {$ENDIF}
  Classes, TypInfo,
  income1 in 'income1.pas';

type

 

IIncomeInt = interface (IUnknown)
    ['{DBB42A04-E60F-41EC-870A-314D68B6913C}']
    function GetIncome(const aNetto: Currency): Currency; stdcall;
    function GetRate: Real;
    function queryDLLInterface(var queryList: TStringList): TStringList;
            stdcall;
    function queryDLLInterfaceTwo(var queryList: TStringList): TStringList;
            stdcall;
    procedure SetRate(const aPercent, aYear: integer); stdcall;
    property Rate: Real read GetRate;
  end;


  TIncomeRealIntf = class (TInterfacedObject, IIncomeInt)
  private
    FRate: Real;
    function Power(X: Real; Y: Integer): Real;
  protected
    function GetRate: Real;
  public
    constructor Create;
    destructor destroy; override;
    function GetIncome(const aNetto: Currency): Currency; stdcall;
    function queryDLLInterface(var queryList: TStringList): TStringList;
            stdcall;
    function queryDLLInterfaceTwo(var queryList: TStringList): TStringList;
            stdcall;
    procedure SetRate(const aPercent, aYear: integer); stdcall;
    property Rate: Real read GetRate;
  end;

  TIncomeRealSuper = class (TInterfacedObject, IIncomeInt)
  private
    FRate: Real;
    function Power(X: Real; Y: Integer): Real;
  protected
    function GetRate: Real;
  public
    constructor Create;
    function GetIncome(const aNetto: Currency): Currency; stdcall;
    function queryDLLInterface(var queryList: TStringList): TStringList;
            stdcall;
    function queryDLLInterfaceTwo(var queryList: TStringList): TStringList;
            stdcall;

    procedure SetRate(const aPercent, aYear: integer); stdcall;
    property Rate: Real read GetRate;
  end;

  TIncomeRealSuper2 = class (TInterfacedObject, IIncomeInt)
  private
    FRate: Real;
    function Power(X: Real; Y: Integer): Real;
  protected
    function GetRate: Real;
  public
    constructor Create;
    function GetIncome(const aNetto: Currency): Currency; stdcall;
    function queryDLLInterface(var queryList: TStringList): TStringList;
            stdcall;
    function queryDLLInterfaceTwo(var queryList: TStringList): TStringList;
            stdcall;

    procedure SetRate(const aPercent, aYear: integer); stdcall;
    property Rate: Real read GetRate;
  end;


{:
Purpose:
}
{:
TIncomeReal.Create
Constructor Create overrides the inherited Create.
First inherited Create is called, then the internal data structure is initialized
}
{
********************************* TIncomeReal **********************************
}
constructor TIncomeReal.Create;
begin
  inherited Create;
  FRate := 4.23; //default
  Assert(INCOME_VERSION = 1.8, 'Wrong Unit-Version');
end;

function TIncomeReal.GetIncome(const aNetto: Currency): Currency;
begin
  Result := aNetto * FRate
end;

function TIncomeReal.GetIncome2(const aNetto: Currency): Currency;
begin
  Result := aNetto * FRate + aNetto;
end;

function TIncomeReal.Power(X: Real; Y: Integer): Real;
var
  I: Integer;
begin
  Result := 1.0;
  I := Y;
  while I > 0 do begin
  if Odd(I) then Result := Result * X;
  I := I div 2; X := Sqr(X);
  end;
end;

function TIncomeReal.queryDLLInterface(var queryList: TStringList): TStringList;
var
  cInfo: TClass;
begin
  cInfo:= NIL;
  if cInfo.Create <> NIL then
  with queryList do begin
  //add(TObject(self).ClassName);
    add('Public Interface of Income DLL');
    add('function GetIncome(const aNetto: Currency): Currency');
    add('procedure SetRate(const aPercent, aYear: integer)');
    add('next cInfo.methodName...'); //just a check
  end;
  result:=queryList;
end;

procedure TIncomeReal.SetRate(const aPercent, aYear: integer);
begin
  FRate := power(1.0 + (aPercent/100),aYear);
end;

{
******************************* TIncomeRealIntf ********************************
}
constructor TIncomeRealIntf.Create;
begin
  inherited Create;
  FRate := 2.23; //default
  Assert(INCOME_VERSION = 1.8, 'Wrong DLL_Unit-Version');
end;

destructor TIncomeRealIntf.destroy;
begin
  {$IFDEF DEBUG}
   ShowMessage('automatic release');
  {$ENDIF}
end;

function TIncomeRealIntf.GetIncome(const aNetto: Currency): Currency;
begin
  Result := aNetto * FRate
end;

function TIncomeRealIntf.GetRate: Real;
begin
  Result := FRate;
end;

function TIncomeRealIntf.Power(X: Real; Y: Integer): Real;
var
  I: Integer;
begin
  Result := 1.0;
  I := Y;
  while I > 0 do begin
  if Odd(I) then Result := Result * X;
  I := I div 2; X := Sqr(X);
  end;
end;

function TIncomeRealIntf.queryDLLInterface(var queryList: TStringList):
        TStringList;
 var
    propCount, i: integer;
    proplist: pPropList;
begin
  //if cInfo <> NIL then begin
  propCount:=getTypeData(TypeInfo(TIncomeRealIntf)).PropCount;
  i:= 1;
  while i <= propCount do begin
    getPropList(TypeInfo(TIncomeRealIntf),Proplist);
    queryList.Add(proplist[i-1].name);
    inc(i);
  end;
  with queryList do begin
  //add(TObject(self).ClassName);
    add('Public Interface of Income Intf DLL');
    add('function GetIncome(const aNetto: Currency): Currency');
    add('procedure SetRate(const aPercent, aYear: integer)');
    add('property rate');
    add('comes from ID1 Intf_DLL...'); //just a check
  end;
  result:=queryList;
end;

function TIncomeRealIntf.queryDLLInterfaceTwo(
  var queryList: TStringList): TStringList;
begin
  queryList:= TStringList.Create;
  queryList.Add('new interface method');
  result:=queryList;
end;

procedure TIncomeRealIntf.SetRate(const aPercent, aYear: integer);
begin
  FRate := power(1.0 + (aPercent/100),aYear);
end;

{
******************************* TIncomeRealSuper *******************************
}
constructor TIncomeRealSuper.Create;
begin
  inherited Create;
  FRate := 4.23; //default
  Assert(INCOME_VERSION = 1.8, 'Wrong Unit-Version');
end;

function TIncomeRealSuper.GetIncome(const aNetto: Currency): Currency;
begin
  Result := aNetto * FRate
end;

function TIncomeRealSuper.GetRate: Real;
begin
  Result := FRate;
end;

function TIncomeRealSuper.Power(X: Real; Y: Integer): Real;
var
  I: Integer;
begin
  Result := 1.0;
  I := Y;
  while I > 0 do begin
  if Odd(I) then Result := Result * X;
  I := I div 2; X := Sqr(X);
  end;
end;

function TIncomeRealSuper.queryDLLInterface(var queryList: TStringList):
        TStringList;
begin
  //if cInfo <> NIL then begin
  with queryList do begin
  //add(TObject(self).ClassName);
    add('Public Interface of Income DLL');
    add('function GetIncome(const aNetto: Currency): Currency');
    add('procedure SetRate(const aPercent, aYear: integer)');
    add('comes from ID2 Super Intf_DLL...'); //just a check
  end;
  result:=queryList;
end;

function TIncomeRealSuper.queryDLLInterfaceTwo(
  var queryList: TStringList): TStringList;
begin
  queryList:= TStringList.Create;
  queryList.Add('new interface method');
  result:=queryList;
end;

procedure TIncomeRealSuper.SetRate(const aPercent, aYear: integer);
begin
  FRate := power(1.0 + (aPercent/100),aYear);
end;

{:
TIncomeReal.GetIncome
(aNetto)
function GetIncome overrides inherited GetIncome.
aNetto.
Returns:
}
{:
TIncomeReal.Power
(X, Y)
function Power.
X, Y.
Returns:
}
{:
TIncomeReal.SetRate
(aPercent, aYear)
procedure SetRate overrides inherited SetRate.
aPercent, aYear.
}
{-------------------------------------------------------------}
{ Schnittstellenprozedur }
{-------------------------------------------------------------}

function CreateIncome(intfID: byte): IIncomeInt; stdcall;
begin
  //back with Realisation from ID_Interface
  case intfID of
  1: result:= TIncomeRealIntf.Create;
  2: result:= TIncomeRealSuper.Create;
  3: result:= TIncomeRealSuper2.Create;
  end;
end;

{-------------------------------------------------------------}
{ Export der Schnittstellenprozedur }
{-------------------------------------------------------------}
exports CreateIncome;

{ TIncomeRealSuper2 }

constructor TIncomeRealSuper2.Create;
begin
  inherited Create;
  FRate := 4.23; //default
  Assert(INCOME_VERSION = 1.8, 'Wrong Unit-Version');
end;

function TIncomeRealSuper2.GetIncome(const aNetto: Currency): Currency;
begin
//fake
result:=0.0;
end;

function TIncomeRealSuper2.GetRate: Real;
begin
//fake
result:=0.0;
end;

function TIncomeRealSuper2.Power(X: Real; Y: Integer): Real;
begin
//fake
result:=0.0;
end;

function TIncomeRealSuper2.queryDLLInterface(
  var queryList: TStringList): TStringList;
begin
  queryList.add('new choice interface');
  result:= queryList;
end;

function TIncomeRealSuper2.queryDLLInterfaceTwo(
  var queryList: TStringList): TStringList;
begin
  queryList:= TStringList.Create;
  queryList.Add('new interface method');
  result:=queryList;
end;

procedure TIncomeRealSuper2.SetRate(const aPercent, aYear: integer);
begin
 //fake
end;

begin
  {a fake}
end.
