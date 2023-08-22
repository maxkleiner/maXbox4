unit uPSI_StDecMth;
{
  SysTools4 another big decimal
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
  TPSImport_StDecMth = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStDecimal(CL: TPSPascalCompiler);
procedure SIRegister_StDecMth(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStDecimal(CL: TPSRuntimeClassImporter);
procedure RIRegister_StDecMth(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StDecMth
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StDecMth]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDecimal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStDecimal') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStDecimal') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Compare( X : TStDecimal) : integer');
    RegisterMethod('Function IsNegative : boolean');
    RegisterMethod('Function IsOne : boolean');
    RegisterMethod('Function IsPositive : boolean');
    RegisterMethod('Function IsZero : boolean');
    RegisterMethod('Procedure SetToOne');
    RegisterMethod('Procedure SetToZero');
    RegisterMethod('Procedure Assign( X : TStDecimal)');
    RegisterMethod('Procedure AssignFromFloat( aValue : double)');
    RegisterMethod('Procedure AssignFromInt( aValue : integer)');
    RegisterMethod('Function AsFloat : double');
    RegisterMethod('Function AsInt( aRound : TStRoundMethod) : integer');
    RegisterMethod('Procedure Abs');
    RegisterMethod('Procedure Add( X : TStDecimal)');
    RegisterMethod('Procedure AddOne');
    RegisterMethod('Procedure ChangeSign');
    RegisterMethod('Procedure Divide( X : TStDecimal)');
    RegisterMethod('Procedure Multiply( X : TStDecimal)');
    RegisterMethod('Procedure RaiseToPower( N : integer)');
    RegisterMethod('Procedure Round( aRound : TStRoundMethod; aDecPl : integer)');
    RegisterMethod('Procedure Subtract( X : TStDecimal)');
    RegisterMethod('Procedure SubtractOne');
    RegisterProperty('AsString', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StDecMth(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStRoundMethod', '( rmNormal, rmTrunc, rmBankers, rmUp )');
  SIRegister_TStDecimal(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStDecimalAsString_W(Self: TStDecimal; const T: AnsiString);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDecimalAsString_R(Self: TStDecimal; var T: AnsiString);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDecimal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDecimal) do begin
    RegisterConstructor(@TStDecimal.Create, 'Create');
    RegisterMethod(@TStDecimal.Destroy, 'Free');
    RegisterMethod(@TStDecimal.Compare, 'Compare');
    RegisterMethod(@TStDecimal.IsNegative, 'IsNegative');
    RegisterMethod(@TStDecimal.IsOne, 'IsOne');
    RegisterMethod(@TStDecimal.IsPositive, 'IsPositive');
    RegisterMethod(@TStDecimal.IsZero, 'IsZero');
    RegisterMethod(@TStDecimal.SetToOne, 'SetToOne');
    RegisterMethod(@TStDecimal.SetToZero, 'SetToZero');
    RegisterMethod(@TStDecimal.Assign, 'Assign');
    RegisterMethod(@TStDecimal.AssignFromFloat, 'AssignFromFloat');
    RegisterMethod(@TStDecimal.AssignFromInt, 'AssignFromInt');
    RegisterMethod(@TStDecimal.AsFloat, 'AsFloat');
    RegisterMethod(@TStDecimal.AsInt, 'AsInt');
    RegisterMethod(@TStDecimal.Abs, 'Abs');
    RegisterMethod(@TStDecimal.Add, 'Add');
    RegisterMethod(@TStDecimal.AddOne, 'AddOne');
    RegisterMethod(@TStDecimal.ChangeSign, 'ChangeSign');
    RegisterMethod(@TStDecimal.Divide, 'Divide');
    RegisterMethod(@TStDecimal.Multiply, 'Multiply');
    RegisterMethod(@TStDecimal.RaiseToPower, 'RaiseToPower');
    RegisterMethod(@TStDecimal.Round, 'Round');
    RegisterMethod(@TStDecimal.Subtract, 'Subtract');
    RegisterMethod(@TStDecimal.SubtractOne, 'SubtractOne');
    RegisterPropertyHelper(@TStDecimalAsString_R,@TStDecimalAsString_W,'AsString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StDecMth(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStDecimal(CL);
end;

 
 
{ TPSImport_StDecMth }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDecMth.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StDecMth(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StDecMth.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StDecMth(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
