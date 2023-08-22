unit uPSI_lifeblocks;
{
from life science fiction http://cyberunits.sf.net

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
  TPSImport_lifeblocks = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNoCoDI(CL: TPSPascalCompiler);
procedure SIRegister_TMiMe(CL: TPSPascalCompiler);
procedure SIRegister_TASIA(CL: TPSPascalCompiler);
procedure SIRegister_lifeblocks(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TNoCoDI(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMiMe(CL: TPSRuntimeClassImporter);
procedure RIRegister_TASIA(CL: TPSRuntimeClassImporter);
procedure RIRegister_lifeblocks(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   bricks
  ,lifeblocks
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_lifeblocks]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNoCoDI(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TNoCoDI') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TNoCoDI') do begin
    RegisterProperty('input1', 'extended', iptrw);
    RegisterProperty('input2', 'extended', iptrw);
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMiMe(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TMiMe') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TMiMe') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('D', 'extended', iptrw);
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TASIA(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TASIA') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TASIA') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterProperty('alpha', 'extended', iptrw);
    RegisterProperty('beta', 'extended', iptrw);
    RegisterProperty('delta', 'extended', iptw);
    RegisterProperty('x1', 'extended', iptrw);
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_lifeblocks(CL: TPSPascalCompiler);
begin
  SIRegister_TASIA(CL);
  SIRegister_TMiMe(CL);
  SIRegister_TNoCoDI(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TNoCoDIsimOutput_R(Self: TNoCoDI; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TNoCoDIoutput_R(Self: TNoCoDI; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TNoCoDIinput2_W(Self: TNoCoDI; const T: extended);
Begin Self.input2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TNoCoDIinput2_R(Self: TNoCoDI; var T: extended);
Begin T := Self.input2; end;

(*----------------------------------------------------------------------------*)
procedure TNoCoDIinput1_W(Self: TNoCoDI; const T: extended);
Begin Self.input1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TNoCoDIinput1_R(Self: TNoCoDI; var T: extended);
Begin T := Self.input1; end;

(*----------------------------------------------------------------------------*)
procedure TMiMesimOutput_R(Self: TMiMe; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TMiMeoutput_R(Self: TMiMe; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TMiMeD_W(Self: TMiMe; const T: extended);
Begin Self.D := T; end;

(*----------------------------------------------------------------------------*)
procedure TMiMeD_R(Self: TMiMe; var T: extended);
Begin T := Self.D; end;

(*----------------------------------------------------------------------------*)
procedure TMiMeG_W(Self: TMiMe; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TMiMeG_R(Self: TMiMe; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TMiMeinput_W(Self: TMiMe; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TMiMeinput_R(Self: TMiMe; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TASIAsimOutput_R(Self: TASIA; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TASIAoutput_R(Self: TASIA; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TASIAx1_W(Self: TASIA; const T: extended);
begin Self.x1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TASIAx1_R(Self: TASIA; var T: extended);
begin T := Self.x1; end;

(*----------------------------------------------------------------------------*)
procedure TASIAdelta_W(Self: TASIA; const T: extended);
begin Self.delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TASIAbeta_W(Self: TASIA; const T: extended);
begin Self.beta := T; end;

(*----------------------------------------------------------------------------*)
procedure TASIAbeta_R(Self: TASIA; var T: extended);
begin T := Self.beta; end;

(*----------------------------------------------------------------------------*)
procedure TASIAalpha_W(Self: TASIA; const T: extended);
begin Self.alpha := T; end;

(*----------------------------------------------------------------------------*)
procedure TASIAalpha_R(Self: TASIA; var T: extended);
begin T := Self.alpha; end;

(*----------------------------------------------------------------------------*)
procedure TASIAinput_W(Self: TASIA; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TASIAinput_R(Self: TASIA; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNoCoDI(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNoCoDI) do
  begin
    RegisterPropertyHelper(@TNoCoDIinput1_R,@TNoCoDIinput1_W,'input1');
    RegisterPropertyHelper(@TNoCoDIinput2_R,@TNoCoDIinput2_W,'input2');
    RegisterConstructor(@TNoCoDI.Create, 'Create');
    RegisterMethod(@TNoCoDI.Destroy, 'Free');
    RegisterPropertyHelper(@TNoCoDIoutput_R,nil,'output');
    RegisterMethod(@TNoCoDI.simulate, 'simulate');
    RegisterPropertyHelper(@TNoCoDIsimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMiMe(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMiMe) do
  begin
    RegisterPropertyHelper(@TMiMeinput_R,@TMiMeinput_W,'input');
    RegisterPropertyHelper(@TMiMeG_R,@TMiMeG_W,'G');
    RegisterPropertyHelper(@TMiMeD_R,@TMiMeD_W,'D');
    RegisterConstructor(@TMiMe.Create, 'Create');
    RegisterMethod(@TMiMe.Destroy, 'Free');
    RegisterPropertyHelper(@TMiMeoutput_R,nil,'output');
    RegisterMethod(@TMiMe.simulate, 'simulate');
    RegisterPropertyHelper(@TMiMesimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TASIA(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TASIA) do
  begin
    RegisterPropertyHelper(@TASIAinput_R,@TASIAinput_W,'input');
    RegisterConstructor(@TASIA.Create, 'Create');
    RegisterMethod(@TASIA.Destroy, 'Free');
    RegisterPropertyHelper(@TASIAalpha_R,@TASIAalpha_W,'alpha');
    RegisterPropertyHelper(@TASIAbeta_R,@TASIAbeta_W,'beta');
    RegisterPropertyHelper(nil,@TASIAdelta_W,'delta');
    RegisterPropertyHelper(@TASIAx1_R,@TASIAx1_W,'x1');
    RegisterPropertyHelper(@TASIAoutput_R,nil,'output');
    RegisterPropertyHelper(@TASIAsimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_lifeblocks(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TASIA(CL);
  RIRegister_TMiMe(CL);
  RIRegister_TNoCoDI(CL);
end;

 
 
{ TPSImport_lifeblocks }
(*----------------------------------------------------------------------------*)
procedure TPSImport_lifeblocks.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_lifeblocks(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_lifeblocks.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_lifeblocks(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
