unit uPSI_uTPLb_PointerArithmetic;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_uTPLb_PointerArithmetic = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uTPLb_PointerArithmetic(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uTPLb_PointerArithmetic_Routines(S: TPSExec);

procedure Register;

implementation


uses
   uTPLb_PointerArithmetic
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_PointerArithmetic]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_PointerArithmetic(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function Offset( Pntr : pointer; Value : integer) : pointer');
 CL.AddDelphiFunction('Function MemStrmOffset( Stream : TMemoryStream; Value : integer) : pointer');
 CL.AddDelphiFunction('Procedure ClearMemory( Stream : TMemoryStream; Offset, CountBytes : integer)');
 CL.AddDelphiFunction('Function ReadMem( Source : TStream; Destin : TMemoryStream; DestinOffset, CountBytes : integer) : integer');
 CL.AddDelphiFunction('Function WriteMem( Source : TMemoryStream; SourceOffset : integer; Destin : TStream; CountBytes : integer) : integer');
 CL.AddDelphiFunction('Function isAligned32( P : pointer) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_PointerArithmetic_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Offset, 'Offset', cdRegister);
 S.RegisterDelphiFunction(@MemStrmOffset, 'MemStrmOffset', cdRegister);
 S.RegisterDelphiFunction(@ClearMemory, 'ClearMemory', cdRegister);
 S.RegisterDelphiFunction(@ReadMem, 'ReadMem', cdRegister);
 S.RegisterDelphiFunction(@WriteMem, 'WriteMem', cdRegister);
 S.RegisterDelphiFunction(@isAligned32, 'isAligned32', cdRegister);
end;

 
 
{ TPSImport_uTPLb_PointerArithmetic }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_PointerArithmetic.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_PointerArithmetic(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_PointerArithmetic.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_PointerArithmetic_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
