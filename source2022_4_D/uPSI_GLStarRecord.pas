unit uPSI_GLStarRecord;
{
   star wars start
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
  TPSImport_GLStarRecord = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_GLStarRecord(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GLStarRecord_Routines(S: TPSExec);

procedure Register;

implementation


uses
   VectorGeometry
  ,GLStarRecord
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GLStarRecord]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_GLStarRecord(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TGLStarRecord', 'record RA: Word; DEC: SmallInt; BVColorIndex: Byte; VMagnitude: Byte; end');
 // CL.AddTypeS('PGLStarRecord', '^TGLStarRecord // will not work');
 CL.AddDelphiFunction('Function StarRecordPositionZUp( const starRecord : TGLStarRecord) : TAffineVector');
 CL.AddDelphiFunction('Function StarRecordPositionYUp( const starRecord : TGLStarRecord) : TAffineVector');
 CL.AddDelphiFunction('Function StarRecordColor( const starRecord : TGLStarRecord; bias : Single) : TVector');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_GLStarRecord_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StarRecordPositionZUp, 'StarRecordPositionZUp', cdRegister);
 S.RegisterDelphiFunction(@StarRecordPositionYUp, 'StarRecordPositionYUp', cdRegister);
 S.RegisterDelphiFunction(@StarRecordColor, 'StarRecordColor', cdRegister);
end;

 
 
{ TPSImport_GLStarRecord }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLStarRecord.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GLStarRecord(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GLStarRecord.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_GLStarRecord(ri);
  RIRegister_GLStarRecord_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
