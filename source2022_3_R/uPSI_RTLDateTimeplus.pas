unit uPSI_RTLDateTimeplus;
{
anotheer shorrt hostory of slime

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
  TPSImport_RTLDateTimeplus = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNullableDateTime(CL: TPSPascalCompiler);
procedure SIRegister_RTLDateTimeplus(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_RTLDateTimeplus_Routines(S: TPSExec);
procedure RIRegister_TNullableDateTime(CL: TPSRuntimeClassImporter);
procedure RIRegister_RTLDateTimeplus(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   RTLDateTimeplus
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RTLDateTimeplus]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNullableDateTime(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TNullableDateTime') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TNullableDateTime') do
  begin
    RegisterMethod('Constructor Create( const AValue : TDateTime)');
    RegisterMethod('Function Value : TDateTime');
    RegisterMethod('Function HasValue : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RTLDateTimeplus(CL: TPSPascalCompiler);
begin
  SIRegister_TNullableDateTime(CL);
 CL.AddDelphiFunction('Function IsValidDate2( const Value : string; out ADate : TDatetime) : Boolean');
 CL.AddDelphiFunction('Function IsValidTime2( const Value : string; out ATime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function IsValidDateTime2( const Value : string; out ADateTime : TDateTime) : Boolean');
 CL.AddDelphiFunction('Procedure ChangeSystemTime( const Value : TDateTime)');
 CL.AddDelphiFunction('Function TryChangeSystemTime( const Value : TDateTime) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_RTLDateTimeplus_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsValidDate, 'IsValidDate2', cdRegister);
 S.RegisterDelphiFunction(@IsValidTime, 'IsValidTime2', cdRegister);
 S.RegisterDelphiFunction(@IsValidDateTime, 'IsValidDateTime2', cdRegister);
 S.RegisterDelphiFunction(@ChangeSystemTime, 'ChangeSystemTime', cdRegister);
 S.RegisterDelphiFunction(@TryChangeSystemTime, 'TryChangeSystemTime', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNullableDateTime(CL: TPSRuntimeClassImporter);
begin
  {with CL.Add(TNullableDateTime) do
  begin
    RegisterConstructor(@TNullableDateTime.Create, 'Create');
    RegisterMethod(@TNullableDateTime.Value, 'Value');
    RegisterMethod(@TNullableDateTime.HasValue, 'HasValue');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RTLDateTimeplus(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNullableDateTime(CL);
end;

 
 
{ TPSImport_RTLDateTimeplus }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RTLDateTimeplus.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RTLDateTimeplus(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RTLDateTimeplus.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RTLDateTimeplus(ri);
  RIRegister_RTLDateTimeplus_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
