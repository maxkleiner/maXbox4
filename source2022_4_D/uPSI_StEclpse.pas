unit uPSI_StEclpse;
{
   nr 666 of units
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
  TPSImport_StEclpse = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStEclipses(CL: TPSPascalCompiler);
procedure SIRegister_StEclpse(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStEclipses(CL: TPSRuntimeClassImporter);
procedure RIRegister_StEclpse(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Math
  ,StBase
  ,StList
  ,StDate
  ,StAstro
  ,StMath
  ,StEclpse
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StEclpse]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStEclipses(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStList', 'TStEclipses') do
  with CL.AddClassN(CL.FindClass('TStList'),'TStEclipses') do begin
    RegisterMethod('Constructor Create(NodeClass : TStNodeClass)');
    RegisterMethod('Procedure FindEclipses( Year : integer)');
    RegisterProperty('Eclipses', 'PStEclipseRecord longint', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StEclpse(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStEclipseType', '( etLunarPenumbral, etLunarPartial, etLunarTot'
   +'al, etSolarPartial, etSolarAnnular, etSolarTotal, etSolarAnnularTotal )');
  CL.AddTypeS('TStHemisphereType', '( htNone, htNorthern, htSouthern )');
  CL.AddTypeS('TStContactTimes', 'record UT1 : TDateTime; UT2 : TDateTime; Firs'
   +'tContact : TDateTime; SecondContact : TDateTime; MidEclipse : TDateTime; T'
   +'hirdContact : TDateTime; FourthContact : TDateTime; end');
  CL.AddTypeS('TStLongLat', 'record JD : TDateTime; Longitude : Double; Latitud'
   +'e : Double; Duration : Double; end');
  //CL.AddTypeS('PStLongLat', '^TStLongLat // will not work');
  CL.AddTypeS('TStEclipseRecord', 'record EType : TStEclipseType; Magnitude : D'
   +'ouble; Hemisphere : TStHemisphereType; LContacts : TStContactTimes; Path : TStList; end');
  //CL.AddTypeS('PStEclipseRecord', '^TStEclipseRecord // will not work');
  CL.AddTypeS('TStBesselianRecord', 'record JD : TDateTime; Delta : Double; Ang'
   +'le : Double; XAxis : Double; YAxis : Double; L1 : Double; L2 : Double; end');
  SIRegister_TStEclipses(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStEclipsesEclipses_R(Self: TStEclipses; var T: PStEclipseRecord; const t1: longint);
begin T := Self.Eclipses[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStEclipses(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStEclipses) do
  begin
    RegisterMethod(@TStEclipses.FindEclipses, 'FindEclipses');
    RegisterPropertyHelper(@TStEclipsesEclipses_R,nil,'Eclipses');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StEclpse(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStEclipses(CL);
end;

 
 
{ TPSImport_StEclpse }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StEclpse.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StEclpse(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StEclpse.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StEclpse(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
