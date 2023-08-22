unit uPSI_StMoney;
{
   add free  4 times
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_StMoney = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStMoney(CL: TPSPascalCompiler);
procedure SIRegister_TStExchangeRateList(CL: TPSPascalCompiler);
procedure SIRegister_TStExchangeRate(CL: TPSPascalCompiler);
procedure SIRegister_TStCurrencyList(CL: TPSPascalCompiler);
procedure SIRegister_TStCurrency(CL: TPSPascalCompiler);
procedure SIRegister_StMoney(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStMoney(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStExchangeRateList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStExchangeRate(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStCurrencyList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStCurrency(CL: TPSRuntimeClassImporter);
procedure RIRegister_StMoney(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StConst
  ,StBase
  ,StStrms
  ,StDecMth
  ,StIniStm
  ,StMoney
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StMoney]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStMoney(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStMoney') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStMoney') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Assign( AMoney : TStMoney)');
    RegisterMethod('Procedure Abs( Result : TStMoney)');
    RegisterMethod('Procedure Add( Addend, Sum : TStMoney)');
    RegisterMethod('Procedure Divide( Divisor : Double; Quotient : TStMoney)');
    RegisterMethod('Procedure DivideByDecimal( Divisor : TStDecimal; Quotient : TStMoney)');
    RegisterMethod('Procedure Multiply( Multiplier : Double; Product : TStMoney)');
    RegisterMethod('Procedure MultiplyByDecimal( Multiplier : TStDecimal; Product : TStMoney)');
    RegisterMethod('Procedure Negate( Result : TStMoney)');
    RegisterMethod('Procedure Subtract( Subtrahend, Remainder : TStMoney)');
    RegisterMethod('Function Compare( CompareTo : TStMoney) : Integer');
    RegisterMethod('Function IsEqual( AMoney : TStMoney) : Boolean');
    RegisterMethod('Function IsGreaterThan( AMoney : TStMoney) : Boolean');
    RegisterMethod('Function IsGreaterThanOrEqual( AMoney : TStMoney) : Boolean');
    RegisterMethod('Function IsLessThan( AMoney : TStMoney) : Boolean');
    RegisterMethod('Function IsLessThanOrEqual( AMoney : TStMoney) : Boolean');
    RegisterMethod('Function IsNegative : Boolean');
    RegisterMethod('Function IsNotEqual( AMoney : TStMoney) : Boolean');
    RegisterMethod('Function IsPositive : Boolean');
    RegisterMethod('Function IsZero : Boolean');
    RegisterMethod('Procedure Convert( const Target : AnsiString; Result : TStMoney)');
    RegisterMethod('Procedure Round( Method : TStRoundMethod; Decimals : Integer; Result : TStMoney)');
    RegisterProperty('Amount', 'TStDecimal', iptrw);
    RegisterProperty('AsFloat', 'Double', iptrw);
    RegisterProperty('AsString', 'AnsiString', iptrw);
    RegisterProperty('Currency', 'AnsiString', iptrw);
    RegisterProperty('ExchangeRates', 'TStExchangeRateList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStExchangeRateList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStExchangeRateList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStExchangeRateList') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Add( ARate : TStExchangeRate)');
    RegisterMethod('Procedure AddByValues( const Source, Target, Intermediate : AnsiString; Rate : Double; ConversionType : TStConversionType; DateUpdated : TDateTime)');
    RegisterMethod('Procedure Assign( AList : TStExchangeRateList)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Contains( ARate : TStExchangeRate) : Boolean');
    RegisterMethod('Function ContainsByName( const Source, Target : AnsiString) : Boolean');
    RegisterMethod('Procedure Convert( const Source, Target : AnsiString; Amount, Result : TStDecimal)');
    RegisterMethod('Procedure Delete( ARate : TStExchangeRate)');
    RegisterMethod('Procedure DeleteByName( const Source, Target : AnsiString)');
    RegisterMethod('Procedure UpdateRate( const Source, Target : AnsiString; Rate : TStDecimal)');
    RegisterMethod('Procedure LoadFromFile( const AFileName : TFileName)');
    RegisterMethod('Procedure LoadFromStream( AStream : TStream)');
    RegisterMethod('Procedure SaveToFile( const AFileName : TFileName)');
    RegisterMethod('Procedure SaveToStream( AStream : TStream)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'TStExchangeRate Integer', iptr);
    RegisterProperty('Rates', 'TStExchangeRate AnsiString AnsiString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStExchangeRate(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStExchangeRate') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStExchangeRate') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Assign( ARate : TStExchangeRate)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Convert( Amount, Result : TStDecimal)');
    RegisterMethod('Function Equals( aRate : TStExchangeRate) : Boolean');
    RegisterMethod('Function IsValid : Boolean');
    RegisterMethod('Function SameSourceAndTarget( aRate : TStExchangeRate) : Boolean');
    RegisterMethod('Procedure Update');
    RegisterMethod('Procedure LoadFromList( List : TStrings)');
    RegisterMethod('Procedure SaveToList( List : TStrings)');
    RegisterProperty('ConversionType', 'TStConversionType', iptrw);
    RegisterProperty('DateUpdated', 'TDateTime', iptrw);
    RegisterProperty('Intermediate', 'AnsiString', iptrw);
    RegisterProperty('Rate', 'TStDecimal', iptrw);
    RegisterProperty('Source', 'AnsiString', iptrw);
    RegisterProperty('Target', 'AnsiString', iptrw);
    RegisterProperty('OnGetRateUpdate', 'TStGetRateUpdateEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStCurrencyList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStCurrencyList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStCurrencyList') do begin
    RegisterMethod('Constructor Create');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Add( ACurrency : TStCurrency)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Contains( ACurrency : TStCurrency) : Boolean');
    RegisterMethod('Function ContainsName( const ISOName : AnsiString) : Boolean');
    RegisterMethod('Procedure Delete( const ISOName : AnsiString)');
    RegisterMethod('Function IndexOf( const ISOName : AnsiString) : Integer');
    RegisterMethod('Procedure LoadFromFile( const AFileName : TFileName)');
    RegisterMethod('Procedure LoadFromStream( AStream : TStream)');
    RegisterMethod('Procedure SaveToFile( const AFileName : TFileName)');
    RegisterMethod('Procedure SaveToStream( AStream : TStream)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Currencies', 'TStCurrency AnsiString', iptrw);
    RegisterProperty('Items', 'TStCurrency Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStCurrency(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStCurrency') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStCurrency') do
  begin
    RegisterMethod('Procedure LoadFromList( List : TStrings)');
    RegisterMethod('Procedure SaveToList( List : TStrings)');
    RegisterProperty('ISOCode', 'AnsiString', iptrw);
    RegisterProperty('ISOName', 'AnsiString', iptrw);
    RegisterProperty('Name', 'AnsiString', iptrw);
    RegisterProperty('Ratio', 'Integer', iptrw);
    RegisterProperty('UnitMajor', 'AnsiString', iptrw);
    RegisterProperty('UnitMinor', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StMoney(CL: TPSPascalCompiler);
begin
  SIRegister_TStCurrency(CL);
  SIRegister_TStCurrencyList(CL);
  CL.AddTypeS('TStConversionType', '( ctUnknown, ctTriangular, ctMultiply, ctDivide )');
  CL.AddTypeS('TStGetRateUpdateEvent', 'Procedure ( Sender : TObject; NewRate : TStDecimal; var NewDate : TDateTime)');
  SIRegister_TStExchangeRate(CL);
  SIRegister_TStExchangeRateList(CL);
  SIRegister_TStMoney(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStMoneyExchangeRates_W(Self: TStMoney; const T: TStExchangeRateList);
begin Self.ExchangeRates := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyExchangeRates_R(Self: TStMoney; var T: TStExchangeRateList);
begin T := Self.ExchangeRates; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyCurrency_W(Self: TStMoney; const T: AnsiString);
begin Self.Currency := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyCurrency_R(Self: TStMoney; var T: AnsiString);
begin T := Self.Currency; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyAsString_W(Self: TStMoney; const T: AnsiString);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyAsString_R(Self: TStMoney; var T: AnsiString);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyAsFloat_W(Self: TStMoney; const T: Double);
begin Self.AsFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyAsFloat_R(Self: TStMoney; var T: Double);
begin T := Self.AsFloat; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyAmount_W(Self: TStMoney; const T: TStDecimal);
begin Self.Amount := T; end;

(*----------------------------------------------------------------------------*)
procedure TStMoneyAmount_R(Self: TStMoney; var T: TStDecimal);
begin T := Self.Amount; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateListRates_R(Self: TStExchangeRateList; var T: TStExchangeRate; const t1: AnsiString; const t2: AnsiString);
begin T := Self.Rates[t1, t2]; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateListItems_R(Self: TStExchangeRateList; var T: TStExchangeRate; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateListCount_R(Self: TStExchangeRateList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateOnGetRateUpdate_W(Self: TStExchangeRate; const T: TStGetRateUpdateEvent);
begin Self.OnGetRateUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateOnGetRateUpdate_R(Self: TStExchangeRate; var T: TStGetRateUpdateEvent);
begin T := Self.OnGetRateUpdate; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateTarget_W(Self: TStExchangeRate; const T: AnsiString);
begin Self.Target := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateTarget_R(Self: TStExchangeRate; var T: AnsiString);
begin T := Self.Target; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateSource_W(Self: TStExchangeRate; const T: AnsiString);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateSource_R(Self: TStExchangeRate; var T: AnsiString);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateRate_W(Self: TStExchangeRate; const T: TStDecimal);
begin Self.Rate := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateRate_R(Self: TStExchangeRate; var T: TStDecimal);
begin T := Self.Rate; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateIntermediate_W(Self: TStExchangeRate; const T: AnsiString);
begin Self.Intermediate := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateIntermediate_R(Self: TStExchangeRate; var T: AnsiString);
begin T := Self.Intermediate; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateDateUpdated_W(Self: TStExchangeRate; const T: TDateTime);
begin Self.DateUpdated := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateDateUpdated_R(Self: TStExchangeRate; var T: TDateTime);
begin T := Self.DateUpdated; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateConversionType_W(Self: TStExchangeRate; const T: TStConversionType);
begin Self.ConversionType := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExchangeRateConversionType_R(Self: TStExchangeRate; var T: TStConversionType);
begin T := Self.ConversionType; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyListItems_W(Self: TStCurrencyList; const T: TStCurrency; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyListItems_R(Self: TStCurrencyList; var T: TStCurrency; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyListCurrencies_W(Self: TStCurrencyList; const T: TStCurrency; const t1: AnsiString);
begin Self.Currencies[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyListCurrencies_R(Self: TStCurrencyList; var T: TStCurrency; const t1: AnsiString);
begin T := Self.Currencies[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyListCount_R(Self: TStCurrencyList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyUnitMinor_W(Self: TStCurrency; const T: AnsiString);
begin Self.UnitMinor := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyUnitMinor_R(Self: TStCurrency; var T: AnsiString);
begin T := Self.UnitMinor; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyUnitMajor_W(Self: TStCurrency; const T: AnsiString);
begin Self.UnitMajor := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyUnitMajor_R(Self: TStCurrency; var T: AnsiString);
begin T := Self.UnitMajor; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyRatio_W(Self: TStCurrency; const T: Integer);
begin Self.Ratio := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyRatio_R(Self: TStCurrency; var T: Integer);
begin T := Self.Ratio; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyName_W(Self: TStCurrency; const T: AnsiString);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyName_R(Self: TStCurrency; var T: AnsiString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyISOName_W(Self: TStCurrency; const T: AnsiString);
begin Self.ISOName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyISOName_R(Self: TStCurrency; var T: AnsiString);
begin T := Self.ISOName; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyISOCode_W(Self: TStCurrency; const T: AnsiString);
begin Self.ISOCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStCurrencyISOCode_R(Self: TStCurrency; var T: AnsiString);
begin T := Self.ISOCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStMoney(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStMoney) do
  begin
    RegisterConstructor(@TStMoney.Create, 'Create');
      RegisterMethod(@TStMoney.Destroy, 'Free');
     RegisterMethod(@TStMoney.Assign, 'Assign');
    RegisterMethod(@TStMoney.Abs, 'Abs');
    RegisterMethod(@TStMoney.Add, 'Add');
    RegisterMethod(@TStMoney.Divide, 'Divide');
    RegisterMethod(@TStMoney.DivideByDecimal, 'DivideByDecimal');
    RegisterMethod(@TStMoney.Multiply, 'Multiply');
    RegisterMethod(@TStMoney.MultiplyByDecimal, 'MultiplyByDecimal');
    RegisterMethod(@TStMoney.Negate, 'Negate');
    RegisterMethod(@TStMoney.Subtract, 'Subtract');
    RegisterMethod(@TStMoney.Compare, 'Compare');
    RegisterMethod(@TStMoney.IsEqual, 'IsEqual');
    RegisterMethod(@TStMoney.IsGreaterThan, 'IsGreaterThan');
    RegisterMethod(@TStMoney.IsGreaterThanOrEqual, 'IsGreaterThanOrEqual');
    RegisterMethod(@TStMoney.IsLessThan, 'IsLessThan');
    RegisterMethod(@TStMoney.IsLessThanOrEqual, 'IsLessThanOrEqual');
    RegisterMethod(@TStMoney.IsNegative, 'IsNegative');
    RegisterMethod(@TStMoney.IsNotEqual, 'IsNotEqual');
    RegisterMethod(@TStMoney.IsPositive, 'IsPositive');
    RegisterMethod(@TStMoney.IsZero, 'IsZero');
    RegisterMethod(@TStMoney.Convert, 'Convert');
    RegisterMethod(@TStMoney.Round, 'Round');
    RegisterPropertyHelper(@TStMoneyAmount_R,@TStMoneyAmount_W,'Amount');
    RegisterPropertyHelper(@TStMoneyAsFloat_R,@TStMoneyAsFloat_W,'AsFloat');
    RegisterPropertyHelper(@TStMoneyAsString_R,@TStMoneyAsString_W,'AsString');
    RegisterPropertyHelper(@TStMoneyCurrency_R,@TStMoneyCurrency_W,'Currency');
    RegisterPropertyHelper(@TStMoneyExchangeRates_R,@TStMoneyExchangeRates_W,'ExchangeRates');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStExchangeRateList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStExchangeRateList) do begin
    RegisterConstructor(@TStExchangeRateList.Create, 'Create');
      RegisterMethod(@TStExchangeRateList.Destroy, 'Free');
      RegisterMethod(@TStExchangeRateList.Add, 'Add');
    RegisterMethod(@TStExchangeRateList.AddByValues, 'AddByValues');
    RegisterMethod(@TStExchangeRateList.Assign, 'Assign');
    RegisterMethod(@TStExchangeRateList.Clear, 'Clear');
    RegisterMethod(@TStExchangeRateList.Contains, 'Contains');
    RegisterMethod(@TStExchangeRateList.ContainsByName, 'ContainsByName');
    RegisterMethod(@TStExchangeRateList.Convert, 'Convert');
    RegisterMethod(@TStExchangeRateList.Delete, 'Delete');
    RegisterMethod(@TStExchangeRateList.DeleteByName, 'DeleteByName');
    RegisterMethod(@TStExchangeRateList.UpdateRate, 'UpdateRate');
    RegisterMethod(@TStExchangeRateList.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TStExchangeRateList.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStExchangeRateList.SaveToFile, 'SaveToFile');
    RegisterMethod(@TStExchangeRateList.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TStExchangeRateListCount_R,nil,'Count');
    RegisterPropertyHelper(@TStExchangeRateListItems_R,nil,'Items');
    RegisterPropertyHelper(@TStExchangeRateListRates_R,nil,'Rates');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStExchangeRate(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStExchangeRate) do begin
    RegisterConstructor(@TStExchangeRate.Create, 'Create');
      RegisterMethod(@TStExchangeRate.Destroy, 'Free');
      RegisterMethod(@TStExchangeRate.Assign, 'Assign');
    RegisterMethod(@TStExchangeRate.Clear, 'Clear');
    RegisterMethod(@TStExchangeRate.Convert, 'Convert');
    RegisterMethod(@TStExchangeRate.Equals, 'Equals');
    RegisterMethod(@TStExchangeRate.IsValid, 'IsValid');
    RegisterMethod(@TStExchangeRate.SameSourceAndTarget, 'SameSourceAndTarget');
    RegisterMethod(@TStExchangeRate.Update, 'Update');
    RegisterMethod(@TStExchangeRate.LoadFromList, 'LoadFromList');
    RegisterMethod(@TStExchangeRate.SaveToList, 'SaveToList');
    RegisterPropertyHelper(@TStExchangeRateConversionType_R,@TStExchangeRateConversionType_W,'ConversionType');
    RegisterPropertyHelper(@TStExchangeRateDateUpdated_R,@TStExchangeRateDateUpdated_W,'DateUpdated');
    RegisterPropertyHelper(@TStExchangeRateIntermediate_R,@TStExchangeRateIntermediate_W,'Intermediate');
    RegisterPropertyHelper(@TStExchangeRateRate_R,@TStExchangeRateRate_W,'Rate');
    RegisterPropertyHelper(@TStExchangeRateSource_R,@TStExchangeRateSource_W,'Source');
    RegisterPropertyHelper(@TStExchangeRateTarget_R,@TStExchangeRateTarget_W,'Target');
    RegisterPropertyHelper(@TStExchangeRateOnGetRateUpdate_R,@TStExchangeRateOnGetRateUpdate_W,'OnGetRateUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStCurrencyList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStCurrencyList) do begin
    RegisterConstructor(@TStCurrencyList.Create, 'Create');
      RegisterMethod(@TStCurrencyList.Destroy, 'Free');
      RegisterMethod(@TStCurrencyList.Add, 'Add');
    RegisterMethod(@TStCurrencyList.Clear, 'Clear');
    RegisterMethod(@TStCurrencyList.Contains, 'Contains');
    RegisterMethod(@TStCurrencyList.ContainsName, 'ContainsName');
    RegisterMethod(@TStCurrencyList.Delete, 'Delete');
    RegisterMethod(@TStCurrencyList.IndexOf, 'IndexOf');
    RegisterMethod(@TStCurrencyList.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TStCurrencyList.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStCurrencyList.SaveToFile, 'SaveToFile');
    RegisterMethod(@TStCurrencyList.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TStCurrencyListCount_R,nil,'Count');
    RegisterPropertyHelper(@TStCurrencyListCurrencies_R,@TStCurrencyListCurrencies_W,'Currencies');
    RegisterPropertyHelper(@TStCurrencyListItems_R,@TStCurrencyListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStCurrency(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStCurrency) do
  begin
    RegisterMethod(@TStCurrency.LoadFromList, 'LoadFromList');
    RegisterMethod(@TStCurrency.SaveToList, 'SaveToList');
    RegisterPropertyHelper(@TStCurrencyISOCode_R,@TStCurrencyISOCode_W,'ISOCode');
    RegisterPropertyHelper(@TStCurrencyISOName_R,@TStCurrencyISOName_W,'ISOName');
    RegisterPropertyHelper(@TStCurrencyName_R,@TStCurrencyName_W,'Name');
    RegisterPropertyHelper(@TStCurrencyRatio_R,@TStCurrencyRatio_W,'Ratio');
    RegisterPropertyHelper(@TStCurrencyUnitMajor_R,@TStCurrencyUnitMajor_W,'UnitMajor');
    RegisterPropertyHelper(@TStCurrencyUnitMinor_R,@TStCurrencyUnitMinor_W,'UnitMinor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StMoney(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStCurrency(CL);
  RIRegister_TStCurrencyList(CL);
  RIRegister_TStExchangeRate(CL);
  RIRegister_TStExchangeRateList(CL);
  RIRegister_TStMoney(CL);
end;

 
 
{ TPSImport_StMoney }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StMoney.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StMoney(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StMoney.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StMoney(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
