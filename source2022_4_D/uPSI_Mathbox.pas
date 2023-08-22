unit uPSI_Mathbox;
{
   the box of gauss for real
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
  TPSImport_Mathbox = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Mathbox(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Mathbox_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Mathbox
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Mathbox]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Mathbox(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function mxArcCos( x : Real) : Real');
 CL.AddDelphiFunction('Function mxArcSin( x : Real) : Real');
 CL.AddDelphiFunction('Function Comp2Str( N : Comp) : String');
 CL.AddDelphiFunction('Function Int2StrPad0( N : LongInt; Len : Integer) : String');
 CL.AddDelphiFunction('Function Int2Str( N : LongInt) : String');
 CL.AddDelphiFunction('Function mxIsEqual( R1, R2 : Double) : Boolean');
 CL.AddDelphiFunction('Function LogXY( x, y : Real) : Real');
 CL.AddDelphiFunction('Function Pennies2Dollars( C : Comp) : String');
 CL.AddDelphiFunction('Function mxPower( X : Integer; Y : Integer) : Real');
 CL.AddDelphiFunction('Function Real2Str( N : Real; Width, Places : integer) : String');
 CL.AddDelphiFunction('Function mxStr2Comp( MyString : string) : Comp');
 CL.AddDelphiFunction('Function mxStr2Pennies( S : String) : Comp');
 CL.AddDelphiFunction('Function Str2Real( MyString : string) : Real');
 CL.AddDelphiFunction('Function XToTheY( x, y : Real) : Real');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_Mathbox_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ArcCos, 'mxArcCos', cdRegister);
 S.RegisterDelphiFunction(@ArcSin, 'mxArcSin', cdRegister);
 S.RegisterDelphiFunction(@Comp2Str, 'Comp2Str', cdRegister);
 S.RegisterDelphiFunction(@Int2StrPad0, 'Int2StrPad0', cdRegister);
 S.RegisterDelphiFunction(@Int2Str, 'Int2Str', cdRegister);
 S.RegisterDelphiFunction(@IsEqual, 'mxIsEqual', cdRegister);
 S.RegisterDelphiFunction(@LogXY, 'LogXY', cdRegister);
 S.RegisterDelphiFunction(@Pennies2Dollars, 'Pennies2Dollars', cdRegister);
 S.RegisterDelphiFunction(@Power, 'mxPower', cdRegister);
 S.RegisterDelphiFunction(@Real2Str, 'Real2Str', cdRegister);
 S.RegisterDelphiFunction(@Str2Comp, 'mxStr2Comp', cdRegister);
 S.RegisterDelphiFunction(@Str2Pennies, 'mxStr2Pennies', cdRegister);
 S.RegisterDelphiFunction(@Str2Real, 'Str2Real', cdRegister);
 S.RegisterDelphiFunction(@XToTheY, 'XToTheY', cdRegister);
end;

 
 
{ TPSImport_Mathbox }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Mathbox.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Mathbox(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Mathbox.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Mathbox(ri);
  RIRegister_Mathbox_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
