unit uPSI_StFIN;
{
 SysTools4
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
  TPSImport_StFIN = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_StFIN(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StFIN_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Math
  ,StMath
  ,StBase
  ,StConst
  ,StDate
  ,StFIN
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StFIN]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StFIN(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStPaymentTime', '( ptEndOfPeriod, ptStartOfPeriod )');
  CL.AddTypeS('TStFrequency', '( fqAnnual, fqSemiAnnual, fqQuarterly, fqMonthly)');
  CL.AddTypeS('TStBasis', '( BasisNASD, BasisActAct, BasisAct360, BasisAct365, '
   +'BasisEur30360 )');
  CL.AddTypeS('TStDate', 'Longint');
  CL.AddTypeS('TStTime', 'Longint');

  // TStTime = LongInt;

//   type
  //TStDate = LongInt;

 CL.AddConstantN('StDelta','Extended').setExtended( 0.00001);
 CL.AddConstantN('StEpsilon','Extended').setExtended( 0.00001);
 CL.AddConstantN('StMaxIterations','Integer').SetInt( 100);
 CL.AddDelphiFunction('Function AccruedInterestMaturity( Issue, Maturity : TStDate; Rate, Par : Extended; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function AccruedInterestPeriodic( Issue, Settlement, Maturity : TStDate; Rate, Par : Extended; Frequency : TStFrequency; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function BondDuration( Settlement, Maturity : TStDate; Rate, Yield : Extended; Frequency : TStFrequency; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function BondPrice( Settlement, Maturity : TStDate; Rate, Yield, Redemption : Extended; Frequency : TStFrequency; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function CumulativeInterest( Rate : Extended; NPeriods : Integer; PV : Extended; StartPeriod, EndPeriod : Integer; Frequency : TStFrequency; Timing : TStPaymentTime) : Extended');
 CL.AddDelphiFunction('Function CumulativePrincipal( Rate : Extended; NPeriods : Integer; PV : Extended; StartPeriod, EndPeriod : Integer; Frequency : TStFrequency; Timing : TStPaymentTime) : Extended');
 CL.AddDelphiFunction('Function DayCount( Day1, Day2 : TStDate; Basis : TStBasis) : LongInt');
 CL.AddDelphiFunction('Function DecliningBalance( Cost, Salvage : Extended; Life, Period, Month : Integer) : Extended');
 CL.AddDelphiFunction('Function DiscountRate( Settlement, Maturity : TStDate; Price, Redemption : Extended; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function DollarToDecimal( FracDollar : Extended; Fraction : Integer) : Extended');
 CL.AddDelphiFunction('Function DollarToDecimalText( DecDollar : Extended) : string');
 CL.AddDelphiFunction('Function DollarToFraction( DecDollar : Extended; Fraction : Integer) : Extended');
 CL.AddDelphiFunction('Function DollarToFractionStr( FracDollar : Extended; Fraction : Integer) : string');
 CL.AddDelphiFunction('Function EffectiveInterestRate( NominalRate : Extended; Frequency : TStFrequency) : Extended');
 CL.AddDelphiFunction('Function FutureValueS( Rate : Extended; NPeriods : Integer; Pmt, PV : Extended; Frequency : TStFrequency; Timing : TStPaymentTime) : Extended');
 CL.AddDelphiFunction('Function FutureValueSchedule( Principal : Extended; const Schedule : array of Double) : Extended');
 CL.AddDelphiFunction('Function FutureValueSchedule16( Principal : Extended; const Schedule, NRates : Integer) : Extended');
 CL.AddDelphiFunction('Function InterestRateS( NPeriods : Integer; Pmt, PV, FV : Extended; Frequency : TStFrequency; Timing : TStPaymentTime; Guess : Extended) : Extended');
 CL.AddDelphiFunction('Function InternalRateOfReturn( const Values : array of Double; Guess : Extended) : Extended');
 CL.AddDelphiFunction('Function InternalRateOfReturn16( const Values, NValues : Integer; Guess : Extended) : Extended');
 CL.AddDelphiFunction('Function IsCardValid( const S : string) : Boolean');
 CL.AddDelphiFunction('Function ModifiedDuration( Settlement, Maturity : TStDate; Rate, Yield : Extended; Frequency : TStFrequency; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function ModifiedIRR( const Values : array of Double; FinanceRate, ReinvestRate : Extended) : Extended');
 CL.AddDelphiFunction('Function ModifiedIRR16( const Values, NValues : Integer; FinanceRate, ReinvestRate : Extended) : Extended');
 CL.AddDelphiFunction('Function NetPresentValueS( Rate : Extended; const Values : array of Double) : Extended');
 CL.AddDelphiFunction('Function NetPresentValue16( Rate : Extended; const Values, NValues : Integer) : Extended');
 CL.AddDelphiFunction('Function NominalInterestRate( EffectRate : Extended; Frequency : TStFrequency) : Extended');
 CL.AddDelphiFunction('Function NonperiodicIRR( const Values : array of Double; const Dates : array of TStDate; Guess : Extended) : Extended');
 CL.AddDelphiFunction('Function NonperiodicNPV( Rate : Extended; const Values : array of Double; const Dates : array of TStDate) : Extended');
 CL.AddDelphiFunction('Function PaymentS( Rate : Extended; NPeriods : Integer; PV, FV : Extended; Frequency : TStFrequency; Timing : TStPaymentTime) : Extended');
 CL.AddDelphiFunction('Function Periods( Rate : Extended; Pmt, PV, FV : Extended; Frequency : TStFrequency; Timing : TStPaymentTime) : Integer');
 CL.AddDelphiFunction('Function PresentValueS( Rate : Extended; NPeriods : Integer; Pmt, FV : Extended; Frequency : TStFrequency; Timing : TStPaymentTime) : Extended');
 CL.AddDelphiFunction('Function ReceivedAtMaturity( Settlement, Maturity : TStDate; Investment, Discount : Extended; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function RoundToDecimal( Value : Extended; Places : Integer; Bankers : Boolean) : Extended');
 CL.AddDelphiFunction('Function TBillEquivYield( Settlement, Maturity : TStDate; Discount : Extended) : Extended');
 CL.AddDelphiFunction('Function TBillPrice( Settlement, Maturity : TStDate; Discount : Extended) : Extended');
 CL.AddDelphiFunction('Function TBillYield( Settlement, Maturity : TStDate; Price : Extended) : Extended');
 CL.AddDelphiFunction('Function VariableDecliningBalance( Cost, Salvage : Extended; Life : Integer; StartPeriod, EndPeriod, Factor : Extended; NoSwitch : boolean) : Extended');
 CL.AddDelphiFunction('Function YieldDiscounted( Settlement, Maturity : TStDate; Price, Redemption : Extended; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function YieldPeriodic( Settlement, Maturity : TStDate; Rate, Price, Redemption : Extended; Frequency : TStFrequency; Basis : TStBasis) : Extended');
 CL.AddDelphiFunction('Function YieldMaturity( Issue, Settlement, Maturity : TStDate; Rate, Price : Extended; Basis : TStBasis) : Extended');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StFIN_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AccruedInterestMaturity, 'AccruedInterestMaturity', cdRegister);
 S.RegisterDelphiFunction(@AccruedInterestPeriodic, 'AccruedInterestPeriodic', cdRegister);
 S.RegisterDelphiFunction(@BondDuration, 'BondDuration', cdRegister);
 S.RegisterDelphiFunction(@BondPrice, 'BondPrice', cdRegister);
 S.RegisterDelphiFunction(@CumulativeInterest, 'CumulativeInterest', cdRegister);
 S.RegisterDelphiFunction(@CumulativePrincipal, 'CumulativePrincipal', cdRegister);
 S.RegisterDelphiFunction(@DayCount, 'DayCount', cdRegister);
 S.RegisterDelphiFunction(@DecliningBalance, 'DecliningBalance', cdRegister);
 S.RegisterDelphiFunction(@DiscountRate, 'DiscountRate', cdRegister);
 S.RegisterDelphiFunction(@DollarToDecimal, 'DollarToDecimal', cdRegister);
 S.RegisterDelphiFunction(@DollarToDecimalText, 'DollarToDecimalText', cdRegister);
 S.RegisterDelphiFunction(@DollarToFraction, 'DollarToFraction', cdRegister);
 S.RegisterDelphiFunction(@DollarToFractionStr, 'DollarToFractionStr', cdRegister);
 S.RegisterDelphiFunction(@EffectiveInterestRate, 'EffectiveInterestRate', cdRegister);
 S.RegisterDelphiFunction(@FutureValue, 'FutureValueS', cdRegister);
 S.RegisterDelphiFunction(@FutureValueSchedule, 'FutureValueSchedule', cdRegister);
 S.RegisterDelphiFunction(@FutureValueSchedule16, 'FutureValueSchedule16', cdRegister);
 S.RegisterDelphiFunction(@InterestRate, 'InterestRateS', cdRegister);
 S.RegisterDelphiFunction(@InternalRateOfReturn, 'InternalRateOfReturn', cdRegister);
 S.RegisterDelphiFunction(@InternalRateOfReturn16, 'InternalRateOfReturn16', cdRegister);
 S.RegisterDelphiFunction(@IsCardValid, 'IsCardValid', cdRegister);
 S.RegisterDelphiFunction(@ModifiedDuration, 'ModifiedDuration', cdRegister);
 S.RegisterDelphiFunction(@ModifiedIRR, 'ModifiedIRR', cdRegister);
 S.RegisterDelphiFunction(@ModifiedIRR16, 'ModifiedIRR16', cdRegister);
 S.RegisterDelphiFunction(@NetPresentValue, 'NetPresentValueS', cdRegister);
 S.RegisterDelphiFunction(@NetPresentValue16, 'NetPresentValue16', cdRegister);
 S.RegisterDelphiFunction(@NominalInterestRate, 'NominalInterestRate', cdRegister);
 S.RegisterDelphiFunction(@NonperiodicIRR, 'NonperiodicIRR', cdRegister);
 S.RegisterDelphiFunction(@NonperiodicNPV, 'NonperiodicNPV', cdRegister);
 S.RegisterDelphiFunction(@Payment, 'PaymentS', cdRegister);
 S.RegisterDelphiFunction(@Periods, 'Periods', cdRegister);
 S.RegisterDelphiFunction(@PresentValue, 'PresentValueS', cdRegister);
 S.RegisterDelphiFunction(@ReceivedAtMaturity, 'ReceivedAtMaturity', cdRegister);
 S.RegisterDelphiFunction(@RoundToDecimal, 'RoundToDecimal', cdRegister);
 S.RegisterDelphiFunction(@TBillEquivYield, 'TBillEquivYield', cdRegister);
 S.RegisterDelphiFunction(@TBillPrice, 'TBillPrice', cdRegister);
 S.RegisterDelphiFunction(@TBillYield, 'TBillYield', cdRegister);
 S.RegisterDelphiFunction(@VariableDecliningBalance, 'VariableDecliningBalance', cdRegister);
 S.RegisterDelphiFunction(@YieldDiscounted, 'YieldDiscounted', cdRegister);
 S.RegisterDelphiFunction(@YieldPeriodic, 'YieldPeriodic', cdRegister);
 S.RegisterDelphiFunction(@YieldMaturity, 'YieldMaturity', cdRegister);
end;

 
 
{ TPSImport_StFIN }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StFIN.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StFIN(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StFIN.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StFIN(ri);
  RIRegister_StFIN_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
