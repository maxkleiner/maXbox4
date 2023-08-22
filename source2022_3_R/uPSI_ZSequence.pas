unit uPSI_ZSequence;
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
  TPSImport_ZSequence = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZSequence(CL: TPSPascalCompiler);
procedure SIRegister_ZSequence(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TZSequence(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZSequence(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ZDbcIntfs
  ,ZConnection
  ,ZSequence
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZSequence]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZSequence(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TZSequence') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TZSequence') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetCurrentValue : Int64');
    RegisterMethod('Function GetNextValue : Int64');
    RegisterMethod('Function GetCurrentValueSQL : string');
    RegisterMethod('Function GetNextValueSQL : string');
    RegisterMethod('Procedure CloseSequence');
    RegisterProperty('BlockSize', 'Integer', iptrw);
    RegisterProperty('Connection', 'TZConnection', iptrw);
    RegisterProperty('SequenceName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZSequence(CL: TPSPascalCompiler);
begin
  SIRegister_TZSequence(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TZSequenceSequenceName_W(Self: TZSequence; const T: string);
begin Self.SequenceName := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSequenceSequenceName_R(Self: TZSequence; var T: string);
begin T := Self.SequenceName; end;

(*----------------------------------------------------------------------------*)
procedure TZSequenceConnection_W(Self: TZSequence; const T: TZConnection);
begin Self.Connection := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSequenceConnection_R(Self: TZSequence; var T: TZConnection);
begin T := Self.Connection; end;

(*----------------------------------------------------------------------------*)
procedure TZSequenceBlockSize_W(Self: TZSequence; const T: Integer);
begin Self.BlockSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TZSequenceBlockSize_R(Self: TZSequence; var T: Integer);
begin T := Self.BlockSize; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZSequence(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZSequence) do
  begin
    RegisterConstructor(@TZSequence.Create, 'Create');
    RegisterMethod(@TZSequence.GetCurrentValue, 'GetCurrentValue');
    RegisterMethod(@TZSequence.GetNextValue, 'GetNextValue');
    RegisterMethod(@TZSequence.GetCurrentValueSQL, 'GetCurrentValueSQL');
    RegisterMethod(@TZSequence.GetNextValueSQL, 'GetNextValueSQL');
    RegisterMethod(@TZSequence.CloseSequence, 'CloseSequence');
    RegisterPropertyHelper(@TZSequenceBlockSize_R,@TZSequenceBlockSize_W,'BlockSize');
    RegisterPropertyHelper(@TZSequenceConnection_R,@TZSequenceConnection_W,'Connection');
    RegisterPropertyHelper(@TZSequenceSequenceName_R,@TZSequenceSequenceName_W,'SequenceName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZSequence(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TZSequence(CL);
end;

 
 
{ TPSImport_ZSequence }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZSequence.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZSequence(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZSequence.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ZSequence(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.