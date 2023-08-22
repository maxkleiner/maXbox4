unit uPSI_Reversi;
{
   Othello Helper
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
  TPSImport_Reversi = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_Reversi(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Reversi_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Reversi
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Reversi]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_Reversi(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('sPosData', 'record corner : boolean; square2x2 : boolean; edge :'
   +' boolean; stable : integer; internal : integer; disks : integer; mx : inte'
   +'ger; my : integer; end');
 // CL.AddTypeS('pBoard', '^tBoard // will not work');
 CL.AddDelphiFunction('Function rCalculateData( cc : byte; cx, cy : integer) : sPosData');
 CL.AddDelphiFunction('Function rCheckMove( color : byte; cx, cy : integer) : integer');
 //CL.AddDelphiFunction('Function rDoStep( data : pBoard) : word');
 CL.AddDelphiFunction('Function winExecAndWait( const sAppPath : string; wVisible : word) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_Reversi_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CalculateData, 'rCalculateData', cdRegister);
 S.RegisterDelphiFunction(@CheckMove, 'rCheckMove', cdRegister);
 //S.RegisterDelphiFunction(@DoStep, 'rDoStep', cdRegister);
 S.RegisterDelphiFunction(@winExecAndWait, 'winExecAndWait', cdRegister);
end;

 
 
{ TPSImport_Reversi }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Reversi.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Reversi(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Reversi.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_Reversi(ri);
  RIRegister_Reversi_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
