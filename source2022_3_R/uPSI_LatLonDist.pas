unit uPSI_LatLonDist;
{
for gps and distance optimizer to save energy

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
  TPSImport_LatLonDist = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_LatLonDist(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_LatLonDist_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // Windows
  //,Messages
  //,Controls
  //,Dialogs
  //,StdCtrls
  //,ExtCtrls
  //,ComCtrls
  Math
  ,mathslib
  ,LatLonDist
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_LatLonDist]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_LatLonDist(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function EllipticalDistance( llat1, llon1, llat2, llon2 : extended; units : integer) : extended');
 CL.AddDelphiFunction('Procedure VDirectLatLon( DGLAT1, DGLON1, DFAZ, S : EXTENDED; Units : integer; var DGLAT2, DGLON2, DBAZ : EXTENDED)');
 CL.AddDelphiFunction('Function VInverseDistance( dlat1, dlon1, dlat2, dlon2 : extended; var AzimuthInit, AzimuthFinal : extended; units : integer) : extended');
 CL.AddDelphiFunction('Function RhumbDistance( llat1, llon1, llat2, llon2 : extended; units : integer; var Azimuth : extended) : extended');
 CL.AddDelphiFunction('Procedure RhumbLatLon( LAT1, LON1, Azimuth1, Dist : EXTENDED; Units : integer; var LAT2, LON2 : EXTENDED)');
 CL.AddDelphiFunction('Function ApproxEllipticalDistance( llat1, llon1, llat2, llon2 : extended; units : integer) : extended');
 CL.AddDelphiFunction('Function ApproxRhumbDistance( llat1, llon1, llat2, llon2 : extended; units : integer; var Azimuth : extended) : extended');
 CL.AddDelphiFunction('Procedure ApproxRhumbLatLon( LAT1, LON1, Azimuth1, Dist : EXTENDED; Units : integer; var LAT2, LON2 : EXTENDED)');
 CL.AddDelphiFunction('Function convertunits( fromindex, ToIndex : integer; fromvalue : extended) : extended');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_LatLonDist_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EllipticalDistance, 'EllipticalDistance', cdRegister);
 S.RegisterDelphiFunction(@VDirectLatLon, 'VDirectLatLon', cdRegister);
 S.RegisterDelphiFunction(@VInverseDistance, 'VInverseDistance', cdRegister);
 S.RegisterDelphiFunction(@RhumbDistance, 'RhumbDistance', cdRegister);
 S.RegisterDelphiFunction(@RhumbLatLon, 'RhumbLatLon', cdRegister);
 S.RegisterDelphiFunction(@ApproxEllipticalDistance, 'ApproxEllipticalDistance', cdRegister);
 S.RegisterDelphiFunction(@ApproxRhumbDistance, 'ApproxRhumbDistance', cdRegister);
 S.RegisterDelphiFunction(@ApproxRhumbLatLon, 'ApproxRhumbLatLon', cdRegister);
 S.RegisterDelphiFunction(@convertunits, 'convertunits', cdRegister);
end;

 
 
{ TPSImport_LatLonDist }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LatLonDist.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LatLonDist(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LatLonDist.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_LatLonDist_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
