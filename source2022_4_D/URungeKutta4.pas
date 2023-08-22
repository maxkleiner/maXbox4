unit URungeKutta4;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This implementation of the Runge-Kutta method for solving Second Order Ordinary
 Differential Equations when inital values are known adapts two procedures from
 Borland's Turbo Pascal Numerical Methods Toolbox, published in 1987.

 The two procedures are
    1: InitialCond2ndOrder implemented here as RungeKutta2ndOrderIC  which solves a
       single 2nd order O.D.E. and
    2: InitialCondition2ndOrderIC_System implemented here as RungeKuttaIC_System
       which solves a system of up to 10 coupled O.D.Es.

  The primary change was to make the procedures more interactive by replacing
  the original result arrays with a caller provided callback procedure which
  receives each calculated point.

}

interface

const
  maxfuncs=10;

type
  float=extended;
  {prototype definitions for single ODE functions}

  {gets next 2nd deritvative value fron caller}
  TUserFunction=function (T, X, XPrime : Float) : Float of object;

  {Passes set of [Time, Value, 1st derivative value]  back to caller}
  TUserCallBackFunction=function (T, X, XPrime : Float) : Boolean of object;

  TNData    = record
                X      : Float;
                xPrime : Float;
              end;

  TNvector = array[0..maxfuncs] of TNData;
  TUserFunctionV=function (V : TNVector):Float of object; {Vectors passed to user funcs,
                                            v[0].x is time}
  TUserCallbackFunctionV=function (V : TNVector):boolean of object; {Vectors passed to user funcs,
                                            v[0].x is time}
  {Pointers to functions}
  TFuncVect  = array[1..MaxFuncs] of TUserFunctionV;


procedure RungeKutta2ndOrderIC(LowerLimit   : Float;
                              UpperLimit    : Float;
                              InitialValue  : Float;
                              InitialDeriv  : Float;
                              ReturnInterval: Float;
                              CalcInterval  : Float;
                          var Error         : byte;
                              UserFunc     : TUserFunction;
                              UserCallBack : TUserCallbackFunction);

{----------------------------------------------------------------------------}


{********************** RungeKuttaSystem **********************}
procedure RungeKutta2ndOrderIC_System(
                              LowerLimit    : Float;
                              UpperLimit    : Float;
                              InitialValues : TNVector;
                              ReturnInterval: Float;
                              CalcInterval  : Float;
                          var Error         : byte;
                              NumEquations  : Integer;
                              Vector        : TFuncVect;
                              UserCallBack  : TUserCallbackFunctionV);

{----------------------------------------------------------------------------}
{  Same as InitialCond2@ndOrder except it calls a user callback function for
  each return point calculated and quits when user returns false
 }

implementation

{*****************************************************************}
{             RungeKutta2ndOrderIC                                }
{*****************************************************************}
procedure RungeKutta2ndOrderIC;

var
  {Values : Ptr;   }                       { Pointer to the stack  }
  Spacing, HalfSpacing : Float;           { Size of each subinterval  }
  Index : integer;
  F1x, F2x, F3x, F4x,
  F1xPrime, F2xPrime,
  F3xPrime, F4xPrime : Float;             { Iteration variables  }
  T, X, xPrime : Float;                   { Values pushed and pulled  }
                                          { from the stack.           }

var
  IntsPerReturn: Float;
  NextReturn: Float;
  NumIntervals:integer;
  Maxreturn:integer;
begin
  MaxReturn:=trunc(upperlimit/Returninterval);
  if MaxReturn <= 0 then    Error := 1
  else if (calcinterval*returninterval<0) or
              (abs(CalcInterval) > abs(ReturnInterval)) then    Error := 2
  else if LowerLimit = UpperLimit then     Error := 3
  else
  begin
    Error := 0;
    NumIntervals:=round(abs((Upperlimit-lowerlimit)/calcinterval));
    Spacing := CalcInterval {(UpperLimit - LowerLimit)/NumIntervals};
    IntsPerReturn:=ReturnInterval/CalcInterval {NumIntervals / NumReturn}; {Callback to user this often}
    NextReturn:=0; {Call whenever Index exceeds this counter}

    T := LowerLimit;
    X := InitialValue;
    xPrime := InitialDeriv;
    HalfSpacing := Spacing / 2;
    for Index := 1 to NumIntervals+1 do
    begin
      If Index>nextreturn then
      begin
        if not Usercallback(T,X,XPrime) then break;
        NextReturn:=NextReturn+IntsPerReturn;
      end;
      F1x := Spacing * xPrime;
      F1xPrime := Spacing * UserFunc(T, X, xPrime);
      F2x := Spacing * (xPrime + 0.5 * F1xPrime);
      F2xPrime := Spacing * UserFunc(T + HalfSpacing, X + 0.5 * F1x,
                  xPrime + 0.5 * F1xPrime);
      F3x := Spacing * (xPrime + 0.5 * F2xPrime);
      F3xPrime := Spacing * UserFunc(T + HalfSpacing, X + 0.5 * F2x,
                  xPrime + 0.5 * F2xPrime);
      F4x := Spacing * (xPrime + F3xPrime);
      F4xPrime := Spacing * UserFunc(T + Spacing, X + F3x, xPrime +
                                          F3xPrime);
      X := X + (F1x + 2 * F2x + 2 * F3x + F4x) / 6;
      xPrime := xPrime + (F1xPrime + 2 * F2xPrime + 2 * F3xPrime + F4xPrime) / 6;
      T := T + Spacing;
    end;
  end;
end;



{*****************************************************************}
{                        RungeKutta2ndOrderIC_System              }
{*****************************************************************}
procedure RungeKutta2ndOrderIC_System;

var
  Spacing, HalfSpacing : Float;           { Size of each subinterval  }
  Index : integer;
  IntsPerReturn: Float;
  NextReturn: Float;
  Term : integer;
  F1 : TNvector;
  F2 : TNvector;
  F3 : TNvector;
  F4 : TNvector;
  CurrentValues : TNvector;
  TempValues : TNvector;
  NumIntervals:integer;

procedure Step(Spacing       : Float;
               var CurrentValues : TNvector;
               var F             : TNvector);

    var i:integer;
    begin
      for i:=1 to numequations do
      if assigned(Vector[i]) then
      begin
        F[i].x:=Spacing * CurrentValues[i].xPrime;
        F[i].xPrime:=Spacing* Vector[i](CurrentValues);
      end
    end; { procedure Step }


begin

  if ReturnInterval <= 0 then    Error := 1
  else if CalcInterval > ReturnInterval then    Error := 2
  else if LowerLimit = UpperLimit then     Error := 3
  else
  begin
    Error := 0;
    NumIntervals:=round(abs(Upperlimit-lowerlimit)/calcinterval);
    Spacing := (UpperLimit - LowerLimit)/NumIntervals;
    IntsPerReturn:=ReturnInterval/CalcInterval {NumIntervals / NumReturn}; {Callback to user this often}
    NextReturn:=0; {Call whenever Index exceeds this counter}
    CurrentValues := InitialValues;
    HalfSpacing := Spacing / 2;
    for Index := 1 to NumIntervals+1 do
    begin
      If Index>nextreturn then
      begin
        if not Usercallback(CurrentValues) then break;
        NextReturn:=NextReturn+IntsPerReturn;
      end;
      { First step - calculate F1  }
      Step(Spacing, CurrentValues, F1);
      TempValues[0].X := CurrentValues[0].X + HalfSpacing;
      for Term := 1 to NumEquations do
      begin
        TempValues[Term].X := CurrentValues[Term].X + 0.5 * F1[Term].X;
        TempValues[Term].xPrime := CurrentValues[Term].xPrime +
                                   0.5 * F1[Term].xPrime;
      end;

      { Second step - calculate F2  }
      Step(Spacing, TempValues, F2);
      for Term := 1 to NumEquations do
      begin
        TempValues[Term].X := CurrentValues[Term].X + 0.5 * F2[Term].X;
        TempValues[Term].xPrime := CurrentValues[Term].xPrime +
                                   0.5 * F2[Term].xPrime;
      end;

      { Third step - calculate F3  }
      Step(Spacing, TempValues, F3);
      TempValues[0].X := CurrentValues[0].X + Spacing;
      for Term := 1 to NumEquations do
      begin
        TempValues[Term].X := CurrentValues[Term].X + F3[Term].X;
        TempValues[Term].xPrime := CurrentValues[Term].xPrime + F3[Term].xPrime;
      end;

      { Fourth step - calculate F4  }
      Step(Spacing, TempValues, F4);

      { Combine F1, F2, F3, and F4 to get  }
      { the solution at this mesh point    }
      CurrentValues[0].X := CurrentValues[0].X + Spacing;
      for Term := 1 to NumEquations do
      begin
        CurrentValues[Term].X := CurrentValues[Term].X + (F1[Term].X +
                             2 * F2[Term].X + 2 * F3[Term].X + F4[Term].X) / 6;
        CurrentValues[Term].xPrime := CurrentValues[Term].xPrime +
                                      (F1[Term].xPrime + 2 * F2[Term].xPrime +
                                    2 * F3[Term].xPrime + F4[Term].xPrime) / 6;
      end;
    end;
  end;
end;

end.
