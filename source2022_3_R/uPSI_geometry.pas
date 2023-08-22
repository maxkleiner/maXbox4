unit uPSI_geometry;
{
   very last unit
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
  TPSImport_geometry = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_geometry(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_geometry_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,KOL
  ,KOLmath
  ,geometry
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_geometry]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_geometry(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('PPointF2', '^TPointF2 // will not work');
  CL.AddTypeS('TPointF2', 'record X : Double; Y : Double; end');
  CL.AddTypeS('PPoint3', '^TPoint3 // will not work');
  CL.AddTypeS('TPoint3', 'record X : integer; Y : integer; Z : Integer; end');
  CL.AddTypeS('PPointF3', '^TPointF3 // will not work');
  CL.AddTypeS('TPointF3', 'record X : double; Y : double; Z : Double; end');
 CL.AddDelphiFunction('Function AreLinesParallel( p1, p2, p3, p4 : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function AreLinesParallel1( p1, p2, p3, p4 : TPointF2; e : Double) : Boolean;');
 CL.AddDelphiFunction('Function AreLinesParallel2( p1, p2, p3, p4, p5, p6 : TPoint3) : Boolean;');
 CL.AddDelphiFunction('Function AreLinesParallel3( p1, p2, p3, p4, p5, p6 : TPointF3; e : Double) : Boolean;');
 CL.AddDelphiFunction('Function IntersectLines( p1, p2, p3, p4 : TPoint) : TPoint;');
 CL.AddDelphiFunction('Function IntersectLines1( p1, p2, p3, p4 : TPointF2; e : Double) : TPointF2;');
 CL.AddDelphiFunction('Function AngleDifference( alpha, beta : Double) : Double');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function IntersectLines1_P( p1, p2, p3, p4 : TPointF2; e : Double) : TPointF2;
Begin Result := geometry.IntersectLines(p1, p2, p3, p4, e); END;

(*----------------------------------------------------------------------------*)
Function IntersectLines_P( p1, p2, p3, p4 : TPoint) : TPoint;
Begin Result := geometry.IntersectLines(p1, p2, p3, p4); END;

(*----------------------------------------------------------------------------*)
Function AreLinesParallel3_P( p1, p2, p3, p4, p5, p6 : TPointF3; e : Double) : Boolean;
Begin Result := geometry.AreLinesParallel(p1, p2, p3, p4, p5, p6, e); END;

(*----------------------------------------------------------------------------*)
Function AreLinesParallel2_P( p1, p2, p3, p4, p5, p6 : TPoint3) : Boolean;
Begin Result := geometry.AreLinesParallel(p1, p2, p3, p4, p5, p6); END;

(*----------------------------------------------------------------------------*)
Function AreLinesParallel1_P( p1, p2, p3, p4 : TPointF2; e : Double) : Boolean;
Begin Result := geometry.AreLinesParallel(p1, p2, p3, p4, e); END;

(*----------------------------------------------------------------------------*)
Function AreLinesParallel_P( p1, p2, p3, p4 : TPoint) : Boolean;
Begin Result := geometry.AreLinesParallel(p1, p2, p3, p4); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_geometry_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AreLinesParallel, 'AreLinesParallel', cdRegister);
 S.RegisterDelphiFunction(@AreLinesParallel1, 'AreLinesParallel1', cdRegister);
 S.RegisterDelphiFunction(@AreLinesParallel2, 'AreLinesParallel2', cdRegister);
 S.RegisterDelphiFunction(@AreLinesParallel3, 'AreLinesParallel3', cdRegister);
 S.RegisterDelphiFunction(@IntersectLines, 'IntersectLines', cdRegister);
 S.RegisterDelphiFunction(@IntersectLines1, 'IntersectLines1', cdRegister);
 S.RegisterDelphiFunction(@AngleDifference, 'AngleDifference', cdRegister);
end;

 
 
{ TPSImport_geometry }
(*----------------------------------------------------------------------------*)
procedure TPSImport_geometry.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_geometry(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_geometry.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_geometry_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
