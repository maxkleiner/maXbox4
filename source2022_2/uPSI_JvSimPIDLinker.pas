unit uPSI_JvSimPIDLinker;
{
  direct utils
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
  TPSImport_JvSimPIDLinker = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSimPIDLinker(CL: TPSPascalCompiler);
procedure SIRegister_JvSimPIDLinker(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSimPIDLinker(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSimPIDLinker(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  JvSimPID
  ,JvSimPIDLinker
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSimPIDLinker]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimPIDLinker(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvSimPIDLinker') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvSimPIDLinker') do begin
    RegisterMethod('Procedure Execute');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('In1', 'TJvSimPID', iptrw);
    RegisterProperty('Out1', 'TJvSimPID', iptrw);
    RegisterProperty('In2', 'TJvSimPID', iptrw);
    RegisterProperty('Out2', 'TJvSimPID', iptrw);
    RegisterProperty('In3', 'TJvSimPID', iptrw);
    RegisterProperty('Out3', 'TJvSimPID', iptrw);
    RegisterProperty('In4', 'TJvSimPID', iptrw);
    RegisterProperty('Out4', 'TJvSimPID', iptrw);
    RegisterProperty('In5', 'TJvSimPID', iptrw);
    RegisterProperty('Out5', 'TJvSimPID', iptrw);
    RegisterProperty('In6', 'TJvSimPID', iptrw);
    RegisterProperty('Out6', 'TJvSimPID', iptrw);
    RegisterProperty('In7', 'TJvSimPID', iptrw);
    RegisterProperty('Out7', 'TJvSimPID', iptrw);
    RegisterProperty('In8', 'TJvSimPID', iptrw);
    RegisterProperty('Out8', 'TJvSimPID', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSimPIDLinker(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPIDS', 'array of TJvSimPID');
  SIRegister_TJvSimPIDLinker(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut8_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.Out8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut8_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.Out8; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn8_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.In8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn8_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.In8; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut7_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.Out7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut7_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.Out7; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn7_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.In7 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn7_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.In7; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut6_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.Out6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut6_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.Out6; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn6_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.In6 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn6_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.In6; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut5_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.Out5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut5_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.Out5; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn5_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.In5 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn5_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.In5; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut4_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.Out4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut4_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.Out4; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn4_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.In4 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn4_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.In4; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut3_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.Out3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut3_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.Out3; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn3_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.In3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn3_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.In3; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut2_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.Out2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut2_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.Out2; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn2_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.In2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn2_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.In2; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut1_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.Out1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerOut1_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.Out1; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn1_W(Self: TJvSimPIDLinker; const T: TJvSimPID);
begin Self.In1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDLinkerIn1_R(Self: TJvSimPIDLinker; var T: TJvSimPID);
begin T := Self.In1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimPIDLinker(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimPIDLinker) do begin
    RegisterMethod(@TJvSimPIDLinker.Execute, 'Execute');
    RegisterConstructor(@TJvSimPIDLinker.Create, 'Create');
    RegisterPropertyHelper(@TJvSimPIDLinkerIn1_R,@TJvSimPIDLinkerIn1_W,'In1');
    RegisterPropertyHelper(@TJvSimPIDLinkerOut1_R,@TJvSimPIDLinkerOut1_W,'Out1');
    RegisterPropertyHelper(@TJvSimPIDLinkerIn2_R,@TJvSimPIDLinkerIn2_W,'In2');
    RegisterPropertyHelper(@TJvSimPIDLinkerOut2_R,@TJvSimPIDLinkerOut2_W,'Out2');
    RegisterPropertyHelper(@TJvSimPIDLinkerIn3_R,@TJvSimPIDLinkerIn3_W,'In3');
    RegisterPropertyHelper(@TJvSimPIDLinkerOut3_R,@TJvSimPIDLinkerOut3_W,'Out3');
    RegisterPropertyHelper(@TJvSimPIDLinkerIn4_R,@TJvSimPIDLinkerIn4_W,'In4');
    RegisterPropertyHelper(@TJvSimPIDLinkerOut4_R,@TJvSimPIDLinkerOut4_W,'Out4');
    RegisterPropertyHelper(@TJvSimPIDLinkerIn5_R,@TJvSimPIDLinkerIn5_W,'In5');
    RegisterPropertyHelper(@TJvSimPIDLinkerOut5_R,@TJvSimPIDLinkerOut5_W,'Out5');
    RegisterPropertyHelper(@TJvSimPIDLinkerIn6_R,@TJvSimPIDLinkerIn6_W,'In6');
    RegisterPropertyHelper(@TJvSimPIDLinkerOut6_R,@TJvSimPIDLinkerOut6_W,'Out6');
    RegisterPropertyHelper(@TJvSimPIDLinkerIn7_R,@TJvSimPIDLinkerIn7_W,'In7');
    RegisterPropertyHelper(@TJvSimPIDLinkerOut7_R,@TJvSimPIDLinkerOut7_W,'Out7');
    RegisterPropertyHelper(@TJvSimPIDLinkerIn8_R,@TJvSimPIDLinkerIn8_W,'In8');
    RegisterPropertyHelper(@TJvSimPIDLinkerOut8_R,@TJvSimPIDLinkerOut8_W,'Out8');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSimPIDLinker(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvSimPIDLinker(CL);
end;

 
 
{ TPSImport_JvSimPIDLinker }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimPIDLinker.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSimPIDLinker(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimPIDLinker.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSimPIDLinker(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
