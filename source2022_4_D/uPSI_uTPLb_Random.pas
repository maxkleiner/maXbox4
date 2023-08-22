unit uPSI_uTPLb_Random;
{
test case

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
  TPSImport_uTPLb_Random = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRandomStream(CL: TPSPascalCompiler);
procedure SIRegister_uTPLb_Random(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRandomStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_uTPLb_Random(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   uTPLb_Random
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uTPLb_Random]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRandomStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TRandomStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TRandomStream') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function Instance : TRandomStream');
    RegisterMethod('Function Read( var Buffer : string; Count : Longint) : Longint');
    RegisterMethod('Function Write( const Buffer : string; Count : Longint) : Longint');
    RegisterMethod('Function Seek( const Offset : Int64; Origin : TSeekOrigin) : Int64');
    RegisterMethod('Procedure Randomize');
    RegisterProperty('Seed', 'int64', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uTPLb_Random(CL: TPSPascalCompiler);
begin
  SIRegister_TRandomStream(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TRandomStreamSeed_W(Self: TRandomStream; const T: int64);
begin Self.Seed := T; end;

(*----------------------------------------------------------------------------*)
procedure TRandomStreamSeed_R(Self: TRandomStream; var T: int64);
begin T := Self.Seed; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRandomStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRandomStream) do  begin
    RegisterConstructor(@TRandomStream.Create, 'Create');
     RegisterMethod(@TRandomStream.Destroy, 'Free');
     RegisterConstructor(@TRandomStream.Instance, 'Instance');
     RegisterMethod(@TRandomStream.Instance, 'Instance2');

    RegisterMethod(@TRandomStream.Read, 'Read');
    RegisterMethod(@TRandomStream.Write, 'Write');
    RegisterMethod(@TRandomStream.Seek, 'Seek');
    RegisterMethod(@TRandomStream.Randomize, 'Randomize');
    RegisterPropertyHelper(@TRandomStreamSeed_R,@TRandomStreamSeed_W,'Seed');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uTPLb_Random(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRandomStream(CL);
end;

 
 
{ TPSImport_uTPLb_Random }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Random.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uTPLb_Random(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uTPLb_Random.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uTPLb_Random(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
