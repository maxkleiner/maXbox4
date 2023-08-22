unit uPSI_uXmlDates;
{
in and out dates

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
  TPSImport_uXmlDates = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uXmlDates(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uXmlDates_Routines(S: TPSExec);

procedure Register;

implementation


uses
   uXmlDates
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uXmlDates]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uXmlDates(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TXMLDateZeroOptions', '( dzoBlank, dzoZero, dzoNow )');
 CL.AddDelphiFunction('Function GetTimeZoneOffset : string');
 CL.AddDelphiFunction('Function GetTimestampWithTimeZone( const ADateTime : TDateTime) : string');
 CL.AddDelphiFunction('Function GetXmlDate( const ADateTime : TDateTime; const DateZeroOption : TXMLDateZeroOptions) : string');
 CL.AddDelphiFunction('Function ConvertToDelphiDateFromXml( const ADateTime : string) : TDateTime');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uXmlDates_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetTimeZoneOffset, 'GetTimeZoneOffset', cdRegister);
 S.RegisterDelphiFunction(@GetTimestampWithTimeZone, 'GetTimestampWithTimeZone', cdRegister);
 S.RegisterDelphiFunction(@GetXmlDate, 'GetXmlDate', cdRegister);
 S.RegisterDelphiFunction(@ConvertToDelphiDateFromXml, 'ConvertToDelphiDateFromXml', cdRegister);
end;

 
 
{ TPSImport_uXmlDates }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uXmlDates.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uXmlDates(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uXmlDates.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uXmlDates_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
