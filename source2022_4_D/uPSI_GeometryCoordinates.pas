unit uPSI_GeometryCoordinates;
{
   coordinates of openGL
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
  TPSImport_GeometryCoordinates = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_GeometryCoordinates(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GeometryCoordinates_Routines(S: TPSExec);

procedure Register;

implementation


uses
   VectorGeometry
  ,GeometryCoordinates
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GeometryCoordinates]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_GeometryCoordinates(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure Cylindrical_Cartesian( const r, theta, z1 : single; var x, y, z : single);');
 CL.AddDelphiFunction('Procedure Cylindrical_Cartesian1( const r, theta, z1 : double; var x, y, z : double);');
 CL.AddDelphiFunction('Procedure Cylindrical_Cartesian2( const r, theta, z1 : single; var x, y, z : single; var ierr : integer);');
 CL.AddDelphiFunction('Procedure Cylindrical_Cartesian3( const r, theta, z1 : double; var x, y, z : double; var ierr : integer);');
 CL.AddDelphiFunction('Procedure Cartesian_Cylindrical( const x, y, z1 : single; var r, theta, z : single);');
 CL.AddDelphiFunction('Procedure Cartesian_Cylindrical1( const x, y, z1 : double; var r, theta, z : double);');
 CL.AddDelphiFunction('Procedure Spherical_Cartesian( const r, theta, phi : single; var x, y, z : single);');
 CL.AddDelphiFunction('Procedure Spherical_Cartesian1( const r, theta, phi : double; var x, y, z : double);');
 CL.AddDelphiFunction('Procedure Spherical_Cartesian2( const r, theta, phi : single; var x, y, z : single; var ierr : integer);');
 CL.AddDelphiFunction('Procedure Spherical_Cartesian3( const r, theta, phi : double; var x, y, z : double; var ierr : integer);');
 CL.AddDelphiFunction('Procedure Cartesian_Spherical( const x, y, z : single; var r, theta, phi : single);');
 CL.AddDelphiFunction('Procedure Cartesian_Spherical1( const v : TAffineVector; var r, theta, phi : Single);');
 CL.AddDelphiFunction('Procedure Cartesian_Spherical2( const x, y, z : double; var r, theta, phi : double);');
 CL.AddDelphiFunction('Procedure ProlateSpheroidal_Cartesian( const xi, eta, phi, a : single; var x, y, z : single);');
 CL.AddDelphiFunction('Procedure ProlateSpheroidal_Cartesian1( const xi, eta, phi, a : double; var x, y, z : double);');
 CL.AddDelphiFunction('Procedure ProlateSpheroidal_Cartesian2( const xi, eta, phi, a : single; var x, y, z : single; var ierr : integer);');
 CL.AddDelphiFunction('Procedure ProlateSpheroidal_Cartesian3( const xi, eta, phi, a : double; var x, y, z : double; var ierr : integer);');
 CL.AddDelphiFunction('Procedure OblateSpheroidal_Cartesian( const xi, eta, phi, a : single; var x, y, z : single);');
 CL.AddDelphiFunction('Procedure OblateSpheroidal_Cartesian1( const xi, eta, phi, a : double; var x, y, z : double);');
 CL.AddDelphiFunction('Procedure OblateSpheroidal_Cartesian2( const xi, eta, phi, a : single; var x, y, z : single; var ierr : integer);');
 CL.AddDelphiFunction('Procedure OblateSpheroidal_Cartesian3( const xi, eta, phi, a : double; var x, y, z : double; var ierr : integer);');
 CL.AddDelphiFunction('Procedure BipolarCylindrical_Cartesian( const u, v, z1, a : single; var x, y, z : single);');
 CL.AddDelphiFunction('Procedure BipolarCylindrical_Cartesian1( const u, v, z1, a : double; var x, y, z : double);');
 CL.AddDelphiFunction('Procedure BipolarCylindrical_Cartesian2( const u, v, z1, a : single; var x, y, z : single; var ierr : integer);');
 CL.AddDelphiFunction('Procedure BipolarCylindrical_Cartesian3( const u, v, z1, a : double; var x, y, z : double; var ierr : integer);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure BipolarCylindrical_Cartesian3_P( const u, v, z1, a : double; var x, y, z : double; var ierr : integer);
Begin GeometryCoordinates.BipolarCylindrical_Cartesian(u, v, z1, a, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure BipolarCylindrical_Cartesian2_P( const u, v, z1, a : single; var x, y, z : single; var ierr : integer);
Begin GeometryCoordinates.BipolarCylindrical_Cartesian(u, v, z1, a, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure BipolarCylindrical_Cartesian1_P( const u, v, z1, a : double; var x, y, z : double);
Begin GeometryCoordinates.BipolarCylindrical_Cartesian(u, v, z1, a, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure BipolarCylindrical_Cartesian_P( const u, v, z1, a : single; var x, y, z : single);
Begin GeometryCoordinates.BipolarCylindrical_Cartesian(u, v, z1, a, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure OblateSpheroidal_Cartesian3_P( const xi, eta, phi, a : double; var x, y, z : double; var ierr : integer);
Begin GeometryCoordinates.OblateSpheroidal_Cartesian(xi, eta, phi, a, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure OblateSpheroidal_Cartesian2_P( const xi, eta, phi, a : single; var x, y, z : single; var ierr : integer);
Begin GeometryCoordinates.OblateSpheroidal_Cartesian(xi, eta, phi, a, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure OblateSpheroidal_Cartesian1_P( const xi, eta, phi, a : double; var x, y, z : double);
Begin GeometryCoordinates.OblateSpheroidal_Cartesian(xi, eta, phi, a, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure OblateSpheroidal_Cartesian_P( const xi, eta, phi, a : single; var x, y, z : single);
Begin GeometryCoordinates.OblateSpheroidal_Cartesian(xi, eta, phi, a, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure ProlateSpheroidal_Cartesian3_P( const xi, eta, phi, a : double; var x, y, z : double; var ierr : integer);
Begin GeometryCoordinates.ProlateSpheroidal_Cartesian(xi, eta, phi, a, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure ProlateSpheroidal_Cartesian2_P( const xi, eta, phi, a : single; var x, y, z : single; var ierr : integer);
Begin GeometryCoordinates.ProlateSpheroidal_Cartesian(xi, eta, phi, a, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure ProlateSpheroidal_Cartesian1_P( const xi, eta, phi, a : double; var x, y, z : double);
Begin GeometryCoordinates.ProlateSpheroidal_Cartesian(xi, eta, phi, a, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure ProlateSpheroidal_Cartesian_P( const xi, eta, phi, a : single; var x, y, z : single);
Begin GeometryCoordinates.ProlateSpheroidal_Cartesian(xi, eta, phi, a, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure Cartesian_Spherical6_P( const x, y, z : double; var r, theta, phi : double);
Begin GeometryCoordinates.Cartesian_Spherical(x, y, z, r, theta, phi); END;

(*----------------------------------------------------------------------------*)
Procedure Cartesian_Spherical5_P( const v : TAffineVector; var r, theta, phi : Single);
Begin GeometryCoordinates.Cartesian_Spherical(v, r, theta, phi); END;

(*----------------------------------------------------------------------------*)
Procedure Cartesian_Spherical4_P( const x, y, z : single; var r, theta, phi : single);
Begin GeometryCoordinates.Cartesian_Spherical(x, y, z, r, theta, phi); END;

(*----------------------------------------------------------------------------*)
Procedure Spherical_Cartesian3_P( const r, theta, phi : double; var x, y, z : double; var ierr : integer);
Begin GeometryCoordinates.Spherical_Cartesian(r, theta, phi, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure Spherical_Cartesian2_P( const r, theta, phi : single; var x, y, z : single; var ierr : integer);
Begin GeometryCoordinates.Spherical_Cartesian(r, theta, phi, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure Spherical_Cartesian1_P( const r, theta, phi : double; var x, y, z : double);
Begin GeometryCoordinates.Spherical_Cartesian(r, theta, phi, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure Spherical_Cartesian_P( const r, theta, phi : single; var x, y, z : single);
Begin GeometryCoordinates.Spherical_Cartesian(r, theta, phi, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure Cartesian_Cylindrical1_P( const x, y, z1 : double; var r, theta, z : double);
Begin GeometryCoordinates.Cartesian_Cylindrical(x, y, z1, r, theta, z); END;

(*----------------------------------------------------------------------------*)
Procedure Cartesian_Cylindrical_P( const x, y, z1 : single; var r, theta, z : single);
Begin GeometryCoordinates.Cartesian_Cylindrical(x, y, z1, r, theta, z); END;

(*----------------------------------------------------------------------------*)
Procedure Cylindrical_Cartesian3_P( const r, theta, z1 : double; var x, y, z : double; var ierr : integer);
Begin GeometryCoordinates.Cylindrical_Cartesian(r, theta, z1, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure Cylindrical_Cartesian2_P( const r, theta, z1 : single; var x, y, z : single; var ierr : integer);
Begin GeometryCoordinates.Cylindrical_Cartesian(r, theta, z1, x, y, z, ierr); END;

(*----------------------------------------------------------------------------*)
Procedure Cylindrical_Cartesian1_P( const r, theta, z1 : double; var x, y, z : double);
Begin GeometryCoordinates.Cylindrical_Cartesian(r, theta, z1, x, y, z); END;

(*----------------------------------------------------------------------------*)
Procedure Cylindrical_Cartesian_P( const r, theta, z1 : single; var x, y, z : single);
Begin GeometryCoordinates.Cylindrical_Cartesian(r, theta, z1, x, y, z); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GeometryCoordinates_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Cylindrical_Cartesian_P, 'Cylindrical_Cartesian', cdRegister);
 S.RegisterDelphiFunction(@Cylindrical_Cartesian1_P, 'Cylindrical_Cartesian1', cdRegister);
 S.RegisterDelphiFunction(@Cylindrical_Cartesian2_P, 'Cylindrical_Cartesian2', cdRegister);
 S.RegisterDelphiFunction(@Cylindrical_Cartesian3_P, 'Cylindrical_Cartesian3', cdRegister);
 S.RegisterDelphiFunction(@Cartesian_Cylindrical_P, 'Cartesian_Cylindrical', cdRegister);
 S.RegisterDelphiFunction(@Cartesian_Cylindrical1_P, 'Cartesian_Cylindrical1', cdRegister);
 S.RegisterDelphiFunction(@Spherical_Cartesian_P, 'Spherical_Cartesian', cdRegister);
 S.RegisterDelphiFunction(@Spherical_Cartesian1_P, 'Spherical_Cartesian1', cdRegister);
 S.RegisterDelphiFunction(@Spherical_Cartesian2_P, 'Spherical_Cartesian2', cdRegister);
 S.RegisterDelphiFunction(@Spherical_Cartesian3_P, 'Spherical_Cartesian3', cdRegister);
 S.RegisterDelphiFunction(@Cartesian_Spherical4_P, 'Cartesian_Spherical', cdRegister);
 S.RegisterDelphiFunction(@Cartesian_Spherical5_P, 'Cartesian_Spherical1', cdRegister);
 S.RegisterDelphiFunction(@Cartesian_Spherical6_P, 'Cartesian_Spherical2', cdRegister);
 S.RegisterDelphiFunction(@ProlateSpheroidal_Cartesian_P, 'ProlateSpheroidal_Cartesian', cdRegister);
 S.RegisterDelphiFunction(@ProlateSpheroidal_Cartesian1_P, 'ProlateSpheroidal_Cartesian1', cdRegister);
 S.RegisterDelphiFunction(@ProlateSpheroidal_Cartesian2_P, 'ProlateSpheroidal_Cartesian2', cdRegister);
 S.RegisterDelphiFunction(@ProlateSpheroidal_Cartesian3_P, 'ProlateSpheroidal_Cartesian3', cdRegister);
 S.RegisterDelphiFunction(@OblateSpheroidal_Cartesian_P, 'OblateSpheroidal_Cartesian', cdRegister);
 S.RegisterDelphiFunction(@OblateSpheroidal_Cartesian1_P, 'OblateSpheroidal_Cartesian1', cdRegister);
 S.RegisterDelphiFunction(@OblateSpheroidal_Cartesian2_P, 'OblateSpheroidal_Cartesian2', cdRegister);
 S.RegisterDelphiFunction(@OblateSpheroidal_Cartesian3_P, 'OblateSpheroidal_Cartesian3', cdRegister);
 S.RegisterDelphiFunction(@BipolarCylindrical_Cartesian_P, 'BipolarCylindrical_Cartesian', cdRegister);
 S.RegisterDelphiFunction(@BipolarCylindrical_Cartesian1_P, 'BipolarCylindrical_Cartesian1', cdRegister);
 S.RegisterDelphiFunction(@BipolarCylindrical_Cartesian2_P, 'BipolarCylindrical_Cartesian2', cdRegister);
 S.RegisterDelphiFunction(@BipolarCylindrical_Cartesian3_P, 'BipolarCylindrical_Cartesian3', cdRegister);
end;



{ TPSImport_GeometryCoordinates }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GeometryCoordinates.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GeometryCoordinates(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GeometryCoordinates.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_GeometryCoordinates(ri);
  RIRegister_GeometryCoordinates_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
