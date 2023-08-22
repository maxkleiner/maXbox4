unit uPSI_psUFinancial;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_psUFinancial = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_psUFinancial(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_psUFinancial_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Controls
  ,psUFinancial
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_psUFinancial]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_psUFinancial(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TLoanType', '( ltAmortized, ltSimple )');
  CL.AddTypeS('TLoanPayType', '( lptMonthly, lptBiMonthly, lptBiWeekly )');
  CL.AddTypeS('TLoanPaymentEvent', 'Procedure ( PayDate : TDate; PayNum : integ'
   +'er; PaymentAmt, Balance, InterestAmt, TotalInterestAmt, AmortizedAmt, Tota'
   +'lAmortizedAmt : currency; var ExtraPayment : currency)');
 CL.AddDelphiFunction('Function LoanPaymentAmt( Principal : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType) : currency');
 CL.AddDelphiFunction('Function LoanNumPayments( Principal, PaymentAmt : currency; InterestRate : extended; PayType : TLoanPayType; LoanType : TLoanType) : integer');
 CL.AddDelphiFunction('Function LoanTotalEstimate( Principal : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType) : currency');
 CL.AddDelphiFunction('Function LoanInterestEstimate( Principal : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType) : currency');
 CL.AddDelphiFunction('Procedure AmortizationSchedule( OnLoanPayment : TLoanPaymentEvent; StartDate : TDate; Principal : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType)');
 CL.AddDelphiFunction('Procedure AmortizationSchedulePaymentAmt( OnLoanPayment : TLoanPaymentEvent; StartDate : TDate; Principal, PaymentAmt : currency; InterestRate : extended; TotalNumPay : integer; PayType : TLoanPayType; LoanType : TLoanType)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_psUFinancial_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LoanPaymentAmt, 'LoanPaymentAmt', cdRegister);
 S.RegisterDelphiFunction(@LoanNumPayments, 'LoanNumPayments', cdRegister);
 S.RegisterDelphiFunction(@LoanTotalEstimate, 'LoanTotalEstimate', cdRegister);
 S.RegisterDelphiFunction(@LoanInterestEstimate, 'LoanInterestEstimate', cdRegister);
 S.RegisterDelphiFunction(@AmortizationSchedule, 'AmortizationSchedule', cdRegister);
 S.RegisterDelphiFunction(@AmortizationSchedulePaymentAmt, 'AmortizationSchedulePaymentAmt', cdRegister);
end;

 
 
{ TPSImport_psUFinancial }
(*----------------------------------------------------------------------------*)
procedure TPSImport_psUFinancial.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_psUFinancial(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_psUFinancial.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_psUFinancial_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.