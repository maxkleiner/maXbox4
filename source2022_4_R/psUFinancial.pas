unit psUFinancial;

(*=== File Description ========================================================
   PURPOSE: Financial utility functions/procedures/helper classes.
START DATE: 2005.3.26
  CODED BY: Ryan Fischbach
   UPDATES:
==============================================================================*)

(*=== Copyright Notice =====================================================*
    This file contains proprietary information of Prometheus Software, Inc.
    Copying or reproduction without prior written approval is prohibited.

    Copyright(c) 2005
    Prometheus Software, Inc.
============================================================================*)

interface

uses
  Controls;

type
  TLoanType = (ltAmortized,ltSimple);

type
  TLoanPayType = (lptMonthly,lptBiMonthly,lptBiWeekly);

const
  cLoanNumPayPerYear: array[TLoanPayType] of integer = (12,24,26);

type
  TLoanPaymentEvent = procedure(PayDate:TDate; PayNum:integer; PaymentAmt,Balance,InterestAmt,
      TotalInterestAmt,AmortizedAmt,TotalAmortizedAmt:currency; var ExtraPayment:currency) of object;

function LoanPaymentAmt(Principal:currency; InterestRate:extended;
    TotalNumPay:integer; PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized): currency;

function LoanNumPayments(Principal,PaymentAmt:currency; InterestRate: extended;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized): integer;

//the next two functions are estimate formula's, true totals require use of AmortizationSchedule
//  reason: rounding to the nearest cent after every payment changes the actual totals
function LoanTotalEstimate(Principal:currency; InterestRate:extended;
    TotalNumPay:integer; PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized): currency;
function LoanInterestEstimate(Principal:currency; InterestRate:extended;
    TotalNumPay:integer; PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized): currency;

//Use of the LoanPaymentEvent is required to use the AmortizationSchedule procedures
//  for each payment, the event will fire; this is the only way to generate accurate totals
procedure AmortizationSchedule(OnLoanPayment:TLoanPaymentEvent; StartDate:TDate;
    Principal:currency; InterestRate:extended; TotalNumPay:integer;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized);
//calculates the PaymentAmt and calls the next function
procedure AmortizationSchedulePaymentAmt(OnLoanPayment:TLoanPaymentEvent; StartDate:TDate;
    Principal,PaymentAmt:currency; InterestRate:extended; TotalNumPay:integer;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized);
//takes the PaymentAmt and creates an amortazion that will fire the event on every payment


implementation

uses
  SysUtils, DateUtils, Math;

function LoanPaymentAmt(Principal:currency; InterestRate:extended; TotalNumPay:integer;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized): currency;
var
  TempCalc: extended;
  NumPayPerYear: extended;
begin
  NumPayPerYear := cLoanNumPayPerYear[PayType];
  if (InterestRate>0) and (TotalNumPay>0) then
    begin
      if (LoanType=ltAmortized) then
        begin
          TempCalc := exp(-TotalNumPay*ln(1.0+InterestRate/100.0/NumPayPerYear));
          if (TempCalc<>1) then
            Result := Principal*InterestRate/100.0/NumPayPerYear/(1.0-TempCalc)
          else
            Result := 0;
        end
      else
        Result := (Principal*InterestRate/(100.0*NumPayPerYear)) + (Principal/TotalNumPay);
    end
  else if (TotalNumPay>0) then
    Result := Principal/TotalNumPay
  else
    Result := 0;
  //round to nearest penny
  Result := RoundTo(Result,-2);
end;

function LoanNumPayments(Principal,PaymentAmt:currency; InterestRate: extended;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized): integer;
var
  TempCalc: extended;
  NumPayPerYear: extended;
  RealNumPay: extended;
begin
  NumPayPerYear := cLoanNumPayPerYear[PayType];
  if (PaymentAmt>0) and (Principal>0) then
    begin
      if (LoanType=ltAmortized) then
        begin
          TempCalc := Principal*InterestRate/100.0/PaymentAmt/NumPayPerYear;
          if (TempCalc>1) then
            RealNumPay := 0.0
          else
            RealNumPay := -ln(1.0-TempCalc)/ln(1.0+(InterestRate/100.0/NumPayPerYear));
        end
      else
        begin
          RealNumPay := (PaymentAmt/Principal) - (InterestRate/(100.0*NumPayPerYear));
          if (RealNumPay>0.0) then
            RealNumPay := 1/RealNumPay
          else
            RealNumPay := 0.0;
        end;
    end
  else
    RealNumPay := 0;
  Result := Ceil(RealNumPay);
end;

function LoanTotalEstimate(Principal:currency; InterestRate:extended; TotalNumPay:integer;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized): currency;
begin
  Result := LoanPaymentAmt(Principal,InterestRate,TotalNumPay,PayType,LoanType)*TotalNumPay;
end;

function LoanInterestEstimate(Principal:currency; InterestRate:extended; TotalNumPay:integer;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized): currency;
begin
  Result := LoanTotalEstimate(Principal,InterestRate,TotalNumPay,PayType,LoanType)-Principal;
end;

procedure AmortizationSchedule(OnLoanPayment:TLoanPaymentEvent; StartDate:TDate;
    Principal:currency; InterestRate:extended; TotalNumPay:integer;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized);
var
  PaymentAmt: currency;
begin
  PaymentAmt := LoanPaymentAmt(Principal,InterestRate,TotalNumPay,PayType,LoanType);
  AmortizationSchedulePaymentAmt(OnLoanPayment,StartDate,Principal,PaymentAmt,InterestRate,
                                 TotalNumPay,PayType,LoanType);
end;

procedure AmortizationSchedulePaymentAmt(OnLoanPayment:TLoanPaymentEvent; StartDate:TDate;
    Principal,PaymentAmt:currency; InterestRate:extended; TotalNumPay:integer;
    PayType:TLoanPayType=lptMonthly; LoanType:TLoanType=ltAmortized);
var
  PayDate: TDate;
  LastPayDate: TDate;
  PayNum: integer;
  InterestAmt: currency;
  Balance: currency;
  AmortizedAmt: currency;
  TotalInterestAmt: currency;
  TotalAmortizedAmt: currency;
  ExtraPayment: currency;
  NumPayPerYear: extended;
begin
  if Assigned(OnLoanPayment) then
  begin
    NumPayPerYear := cLoanNumPayPerYear[PayType];
    Balance := Principal;
    PayNum := 0;
    PayDate := StartDate;
    LastPayDate := PayDate;
    TotalInterestAmt := 0;
    TotalAmortizedAmt := 0;
    ExtraPayment := 0;
    repeat
      PayNum := PayNum + 1;
      if (PayNum>1) then
      begin
        case PayType of
          lptMonthly:
            PayDate := IncMonth(PayDate);
          else //bi-monthly, 24 payments a year
            begin
              if ((PayNum mod 2)=0) then
                PayDate := IncDay(PayDate,14)
              else
                begin
                  PayDate := IncMonth(LastPayDate,1);
                  LastPayDate := PayDate;
                end;
            end;
        end;//case
      end;//if
      if (LoanType=ltAmortized) then
        InterestAmt := Balance*InterestRate/NumPayPerYear/100.0
      else
        InterestAmt := Principal*InterestRate/NumPayPerYear/100.0;
      InterestAmt := RoundTo(InterestAmt,-2);
      //last payment should be what's left instead of what was calculated
      if (PayNum=TotalNumPay) then
        PaymentAmt := Balance+InterestAmt;
      AmortizedAmt := PaymentAmt-InterestAmt;
      Balance := Balance-AmortizedAmt;
      //correct PaymentAmt if we're still off by a little bit
      if (Balance<0.0) then
      begin
        PaymentAmt := PaymentAmt+Balance;
        AmortizedAmt := AmortizedAmt+Balance;
        Balance := 0.0;
      end;
      TotalInterestAmt := TotalInterestAmt+InterestAmt;
      TotalAmortizedAmt := TotalAmortizedAmt+AmortizedAmt;
      OnLoanPayment(PayDate,PayNum,PaymentAmt,Balance,InterestAmt,TotalInterestAmt,
                    AmortizedAmt,TotalAmortizedAmt,ExtraPayment);
      Balance := Balance-ExtraPayment;
    until (PayNum=TotalNumPay) or (Balance=0.0);
  end;//if
end;

end.
