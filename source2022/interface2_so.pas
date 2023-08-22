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
   //QDialogs,
  {$ENDIF}
  Classes, TypInfo, math;

const INCOME_VERSION = 1.8;  

type

 
IIncomeInt = interface (IUnknown)
    ['{DBB42A04-E60F-41EC-870A-314D68B6913C}']

    function GetIncome2(const aNetto: Currency): Currency; stdcall;
    function GetIncome(const aNetto: Extended): Extended; stdcall;
    function GetRate: Extended;
    function queryDLLInterface(var queryList: TStringList): TStringList;
            stdcall;
    function queryDLLInterfaceTwo(var queryList: TStringList): TStringList;
            stdcall;
    procedure SetRate(const aPercent, aYear: integer); stdcall;
    //property Rate: Double read GetRate;
  end;


  TIncomeRealIntf = class (TInterfacedObject, IIncomeInt)
  private
    FRate: Extended;
    function Power2(X: Extended; Y: Integer): Extended;
  protected
    function GetRate: Extended;
  public
    constructor Create;
    destructor destroy; override;
    function GetIncome2(const aNetto: Currency): Currency; stdcall;
    function GetIncome(const aNetto: Extended): Extended; stdcall;
    function queryDLLInterface(var queryList: TStringList): TStringList;
            stdcall;
    function queryDLLInterfaceTwo(var queryList: TStringList): TStringList;
            stdcall;
    procedure SetRate(const aPercent, aYear: integer); stdcall;
    property Rate: Extended read GetRate;
  end;

  TIncomeRealSuper = class (TInterfacedObject, IIncomeInt)
  private
    FRate: Double;
    function Power2(X: Double; Y: Integer): Double;
  protected
    function GetRate: Extended;
  public
    constructor Create;
    function GetIncome2(const aNetto: Currency): Currency; stdcall;
    function GetIncome(const aNetto: Extended): Extended; stdcall;
    function queryDLLInterface(var queryList: TStringList): TStringList;
            stdcall;
    function queryDLLInterfaceTwo(var queryList: TStringList): TStringList;
            stdcall;

    procedure SetRate(const aPercent, aYear: integer); stdcall;
    property Rate: Extended read GetRate;
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
implementation
  uses IFSI_WinForm1puzzle;
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

function TIncomeRealIntf.GetIncome2(const aNetto: Currency): Currency;
begin
  Result := aNetto * FRate
end;

function TIncomeRealIntf.GetIncome(const aNetto: Extended): Extended;
begin
  Result := aNetto * FRate
end;

function TIncomeRealIntf.GetRate: Extended;
begin
  Result := FRate;
end;

function TIncomeRealIntf.Power2(X: Extended; Y: Integer): Extended;
var
  I: Integer;
begin
  Result := 1.0;
  I := Y;
  while I > 0 do begin
  if Odd(I) then
      Result:= (Result * X);
  I := I div 2;
  X := Sqr(X);
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
    add('property Rate');
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
var aperc: extended;
begin
  aperc:= 1.0 + (aPercent / 100);
  //aperc:= round((1.0 + aPercent));
  FRate:=  power2(aperc , aYear);
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

function TIncomeRealSuper.GetIncome2(const aNetto: Currency): Currency;
begin
  Result := aNetto * FRate
end;

function TIncomeRealSuper.GetIncome(const aNetto: Extended): Extended;
begin
  Result := aNetto * FRate
end;

function TIncomeRealSuper.GetRate: Extended;
begin
  Result := FRate;
end;

function TIncomeRealSuper.Power2(X: Double; Y: Integer): Double;
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
  result:= queryList;
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
  FRate := power2(1.0 + (aPercent/100),aYear);
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
  //3: result:= TIncomeRealSuper2.Create;
  end;
end;

{-------------------------------------------------------------}
{ Export der Schnittstellenprozedur }
{-------------------------------------------------------------}
exports CreateIncome;
exports GetOSName;
exports getBigPI;
exports GetProcessorName;
exports GetBiosVendor;
exports RemainingBatteryPercent;
exports GetScriptPath2;
exports GetScriptName2;
exports GetMemoryInfo;
exports UpTime;
exports ExePath;  //GetCPUSpeed
exports GetASCII;
exports IsInternet;
exports isSound;
exports getHostIP;
exports IsCOMConnected;


//function GetMemoryInfo: string;
  //   function UpTime: string;

 // function GetScriptPath2: string;
  //function GetScriptName2: string;

{ TIncomeRealSuper2 }

end.
