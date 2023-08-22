unit uPSI_Bricks;
{
cybernetics

//https://svn.freepascal.org/cgi-bin/viewvc.cgi/tags/release_3_0_4/packages/rtl-extra/src/inc/ucomplex.pp?view=markup

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
  TPSImport_Bricks = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPDiv(CL: TPSPascalCompiler);
procedure SIRegister_TPMul(CL: TPSPascalCompiler);
procedure SIRegister_TPSub(CL: TPSPascalCompiler);
procedure SIRegister_TPAdd(CL: TPSPascalCompiler);
procedure SIRegister_TIT2(CL: TPSPascalCompiler);
procedure SIRegister_TDT1(CL: TPSPascalCompiler);
procedure SIRegister_TIT1(CL: TPSPascalCompiler);
procedure SIRegister_TInt2(CL: TPSPascalCompiler);
procedure SIRegister_TPT2(CL: TPSPascalCompiler);
procedure SIRegister_TPT1(CL: TPSPascalCompiler);
procedure SIRegister_TPT0(CL: TPSPascalCompiler);
procedure SIRegister_TP2(CL: TPSPascalCompiler);
procedure SIRegister_TBlock(CL: TPSPascalCompiler);
procedure SIRegister_Bricks(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPDiv(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPMul(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSub(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPAdd(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIT2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDT1(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIT1(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInt2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPT2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPT1(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPT0(CL: TPSRuntimeClassImporter);
procedure RIRegister_TP2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBlock(CL: TPSRuntimeClassImporter);
procedure RIRegister_Bricks(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Math
  //,ucomplex
  ,Bricks
  ;


 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Bricks]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPDiv(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TPDiv') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TPDiv') do begin
    RegisterProperty('input1', 'extended', iptrw);
    RegisterProperty('input2', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPMul(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TPMul') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TPMul') do begin
    RegisterProperty('input1', 'extended', iptrw);
    RegisterProperty('input2', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSub(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TPSub') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TPSub') do begin
    RegisterProperty('input1', 'extended', iptrw);
    RegisterProperty('input2', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPAdd(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TPAdd') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TPAdd') do begin
    RegisterProperty('input1', 'extended', iptrw);
    RegisterProperty('input2', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIT2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TIT2') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TIT2') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('t2', 'extended', iptrw);
    RegisterProperty('dmp', 'extended', iptrw);
    RegisterProperty('x1', 'extended', iptrw);
    RegisterProperty('x2', 'extended', iptrw);
    RegisterProperty('x3', 'extended', iptrw);
    RegisterProperty('amplitude', 'extended', iptrw);
    RegisterProperty('omega', 'extended', iptrw);
    RegisterProperty('delta', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDT1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TDT1') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TDT1') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('t1', 'extended', iptrw);
    RegisterProperty('x1', 'extended', iptrw);
    RegisterProperty('amplitude', 'extended', iptrw);
    RegisterProperty('omega', 'extended', iptrw);
    RegisterProperty('delta', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIT1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TIT1') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TIT1') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('t1', 'extended', iptrw);
    RegisterProperty('x1', 'extended', iptrw);
    RegisterProperty('amplitude', 'extended', iptrw);
    RegisterProperty('omega', 'extended', iptrw);
    RegisterProperty('delta', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInt2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TInt') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TInt2') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('amplitude', 'extended', iptrw);
    RegisterProperty('omega', 'extended', iptrw);
    RegisterProperty('delta', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPT2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TPT2') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TPT2') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('t2', 'extended', iptrw);
    RegisterProperty('dmp', 'extended', iptrw);
    RegisterProperty('x1', 'extended', iptrw);
    RegisterProperty('x2', 'extended', iptrw);
    RegisterProperty('amplitude', 'extended', iptrw);
    RegisterProperty('omega', 'extended', iptrw);
    RegisterProperty('delta', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPT1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TPT1') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TPT1') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('t1', 'extended', iptrw);
    RegisterProperty('x1', 'extended', iptrw);
    RegisterProperty('amplitude', 'extended', iptrw);
    RegisterProperty('omega', 'extended', iptrw);
    RegisterProperty('delta', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPT0(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TPT0') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TPT0') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('amplitude', 'extended', iptrw);
    RegisterProperty('omega', 'extended', iptrw);
    RegisterProperty('delta', 'extended', iptrw);
    RegisterProperty('xt', 'array of extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
    RegisterProperty('nt', 'integer', iptrw);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TP2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBlock', 'TP') do
  with CL.AddClassN(CL.FindClass('TBlock'),'TP2') do begin
    RegisterProperty('input', 'extended', iptrw);
    RegisterProperty('G', 'extended', iptrw);
    RegisterProperty('amplitude', 'extended', iptrw);
    RegisterProperty('omega', 'extended', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
    RegisterMethod('Procedure simulate');
    RegisterProperty('simOutput', 'extended', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlock(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBlock') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBlock') do begin
    RegisterProperty('name', 'string', iptrw);
    RegisterMethod('Procedure simulate');
    RegisterMethod('Procedure Free');
    RegisterProperty('output', 'extended', iptr);
    RegisterProperty('fr', 'TFR', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Bricks(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('kError101','String').SetString( 'Runtime error: Negative parameter(s)');
 CL.AddConstantN('kError102','String').SetString( 'Runtime error: Parameter(s) out of range');
 CL.AddConstantN('kError103','String').SetString( 'Runtime error: min > max');
 CL.AddConstantN('kError104','String').SetString( 'Runtime error: max = 0');
 CL.AddConstantN('kError105','String').SetString( 'Runtime error: Denominator is zero');
  CL.AddTypeS('TVectorE', 'array of extended');
  CL.AddTypeS('complexreal', 'record re : real; im : real; end');
  CL.AddTypeS('TFR', 'record M : extended; phi : extended; F : complexreal; end');
  //CL.AddTypeS('complexreal', 'record re : real; im : real; end');

  SIRegister_TBlock(CL);
  SIRegister_TP2(CL);
  SIRegister_TPT0(CL);
  SIRegister_TPT1(CL);
  SIRegister_TPT2(CL);
  SIRegister_TInt2(CL);
  SIRegister_TIT1(CL);
  SIRegister_TDT1(CL);
  SIRegister_TIT2(CL);
  SIRegister_TPAdd(CL);
  SIRegister_TPSub(CL);
  SIRegister_TPMul(CL);
  SIRegister_TPDiv(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPDivsimOutput_R(Self: TPDiv; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPDivoutput_R(Self: TPDiv; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TPDivG_W(Self: TPDiv; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TPDivG_R(Self: TPDiv; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TPDivinput2_W(Self: TPDiv; const T: extended);
Begin Self.input2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPDivinput2_R(Self: TPDiv; var T: extended);
Begin T := Self.input2; end;

(*----------------------------------------------------------------------------*)
procedure TPDivinput1_W(Self: TPDiv; const T: extended);
Begin Self.input1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPDivinput1_R(Self: TPDiv; var T: extended);
Begin T := Self.input1; end;

(*----------------------------------------------------------------------------*)
procedure TPMulsimOutput_R(Self: TPMul; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPMuloutput_R(Self: TPMul; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TPMulG_W(Self: TPMul; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TPMulG_R(Self: TPMul; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TPMulinput2_W(Self: TPMul; const T: extended);
Begin Self.input2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPMulinput2_R(Self: TPMul; var T: extended);
Begin T := Self.input2; end;

(*----------------------------------------------------------------------------*)
procedure TPMulinput1_W(Self: TPMul; const T: extended);
Begin Self.input1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPMulinput1_R(Self: TPMul; var T: extended);
Begin T := Self.input1; end;

(*----------------------------------------------------------------------------*)
procedure TPSubsimOutput_R(Self: TPSub; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPSuboutput_R(Self: TPSub; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TPSubG_W(Self: TPSub; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSubG_R(Self: TPSub; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TPSubinput2_W(Self: TPSub; const T: extended);
Begin Self.input2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSubinput2_R(Self: TPSub; var T: extended);
Begin T := Self.input2; end;

(*----------------------------------------------------------------------------*)
procedure TPSubinput1_W(Self: TPSub; const T: extended);
Begin Self.input1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSubinput1_R(Self: TPSub; var T: extended);
Begin T := Self.input1; end;

(*----------------------------------------------------------------------------*)
procedure TPAddsimOutput_R(Self: TPAdd; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPAddoutput_R(Self: TPAdd; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TPAddG_W(Self: TPAdd; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TPAddG_R(Self: TPAdd; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TPAddinput2_W(Self: TPAdd; const T: extended);
Begin Self.input2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPAddinput2_R(Self: TPAdd; var T: extended);
Begin T := Self.input2; end;

(*----------------------------------------------------------------------------*)
procedure TPAddinput1_W(Self: TPAdd; const T: extended);
Begin Self.input1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPAddinput1_R(Self: TPAdd; var T: extended);
Begin T := Self.input1; end;

(*----------------------------------------------------------------------------*)
procedure TIT2simOutput_R(Self: TIT2; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TIT2fr_R(Self: TIT2; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TIT2output_R(Self: TIT2; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TIT2delta_W(Self: TIT2; const T: extended);
Begin Self.delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2delta_R(Self: TIT2; var T: extended);
Begin T := Self.delta; end;

(*----------------------------------------------------------------------------*)
procedure TIT2omega_W(Self: TIT2; const T: extended);
Begin Self.omega := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2omega_R(Self: TIT2; var T: extended);
Begin T := Self.omega; end;

(*----------------------------------------------------------------------------*)
procedure TIT2amplitude_W(Self: TIT2; const T: extended);
Begin Self.amplitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2amplitude_R(Self: TIT2; var T: extended);
Begin T := Self.amplitude; end;

(*----------------------------------------------------------------------------*)
procedure TIT2x3_W(Self: TIT2; const T: extended);
Begin Self.x3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2x3_R(Self: TIT2; var T: extended);
Begin T := Self.x3; end;

(*----------------------------------------------------------------------------*)
procedure TIT2x2_W(Self: TIT2; const T: extended);
Begin Self.x2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2x2_R(Self: TIT2; var T: extended);
Begin T := Self.x2; end;

(*----------------------------------------------------------------------------*)
procedure TIT2x1_W(Self: TIT2; const T: extended);
Begin Self.x1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2x1_R(Self: TIT2; var T: extended);
Begin T := Self.x1; end;

(*----------------------------------------------------------------------------*)
procedure TIT2dmp_W(Self: TIT2; const T: extended);
Begin Self.dmp := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2dmp_R(Self: TIT2; var T: extended);
Begin T := Self.dmp; end;

(*----------------------------------------------------------------------------*)
procedure TIT2t2_W(Self: TIT2; const T: extended);
Begin Self.t2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2t2_R(Self: TIT2; var T: extended);
Begin T := Self.t2; end;

(*----------------------------------------------------------------------------*)
procedure TIT2G_W(Self: TIT2; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2G_R(Self: TIT2; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TIT2input_W(Self: TIT2; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT2input_R(Self: TIT2; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TDT1simOutput_R(Self: TDT1; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TDT1fr_R(Self: TDT1; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TDT1output_R(Self: TDT1; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TDT1delta_W(Self: TDT1; const T: extended);
Begin Self.delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TDT1delta_R(Self: TDT1; var T: extended);
Begin T := Self.delta; end;

(*----------------------------------------------------------------------------*)
procedure TDT1omega_W(Self: TDT1; const T: extended);
Begin Self.omega := T; end;

(*----------------------------------------------------------------------------*)
procedure TDT1omega_R(Self: TDT1; var T: extended);
Begin T := Self.omega; end;

(*----------------------------------------------------------------------------*)
procedure TDT1amplitude_W(Self: TDT1; const T: extended);
Begin Self.amplitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TDT1amplitude_R(Self: TDT1; var T: extended);
Begin T := Self.amplitude; end;

(*----------------------------------------------------------------------------*)
procedure TDT1x1_W(Self: TDT1; const T: extended);
Begin Self.x1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TDT1x1_R(Self: TDT1; var T: extended);
Begin T := Self.x1; end;

(*----------------------------------------------------------------------------*)
procedure TDT1t1_W(Self: TDT1; const T: extended);
Begin Self.t1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TDT1t1_R(Self: TDT1; var T: extended);
Begin T := Self.t1; end;

(*----------------------------------------------------------------------------*)
procedure TDT1G_W(Self: TDT1; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TDT1G_R(Self: TDT1; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TDT1input_W(Self: TDT1; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TDT1input_R(Self: TDT1; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TIT1simOutput_R(Self: TIT1; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TIT1fr_R(Self: TIT1; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TIT1output_R(Self: TIT1; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TIT1delta_W(Self: TIT1; const T: extended);
Begin Self.delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT1delta_R(Self: TIT1; var T: extended);
Begin T := Self.delta; end;

(*----------------------------------------------------------------------------*)
procedure TIT1omega_W(Self: TIT1; const T: extended);
Begin Self.omega := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT1omega_R(Self: TIT1; var T: extended);
Begin T := Self.omega; end;

(*----------------------------------------------------------------------------*)
procedure TIT1amplitude_W(Self: TIT1; const T: extended);
Begin Self.amplitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT1amplitude_R(Self: TIT1; var T: extended);
Begin T := Self.amplitude; end;

(*----------------------------------------------------------------------------*)
procedure TIT1x1_W(Self: TIT1; const T: extended);
Begin Self.x1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT1x1_R(Self: TIT1; var T: extended);
Begin T := Self.x1; end;

(*----------------------------------------------------------------------------*)
procedure TIT1t1_W(Self: TIT1; const T: extended);
Begin Self.t1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT1t1_R(Self: TIT1; var T: extended);
Begin T := Self.t1; end;

(*----------------------------------------------------------------------------*)
procedure TIT1G_W(Self: TIT1; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT1G_R(Self: TIT1; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TIT1input_W(Self: TIT1; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TIT1input_R(Self: TIT1; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TIntsimOutput_R(Self: TInt2; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TIntfr_R(Self: TInt2; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TIntoutput_R(Self: TInt2; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TIntdelta_W(Self: TInt2; const T: extended);
Begin Self.delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntdelta_R(Self: TInt2; var T: extended);
Begin T := Self.delta; end;

(*----------------------------------------------------------------------------*)
procedure TIntomega_W(Self: TInt2; const T: extended);
Begin Self.omega := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntomega_R(Self: TInt2; var T: extended);
Begin T := Self.omega; end;

(*----------------------------------------------------------------------------*)
procedure TIntamplitude_W(Self: TInt2; const T: extended);
Begin Self.amplitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntamplitude_R(Self: TInt2; var T: extended);
Begin T := Self.amplitude; end;

(*----------------------------------------------------------------------------*)
procedure TIntG_W(Self: TInt2; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntG_R(Self: TInt2; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TIntinput_W(Self: TInt2; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TIntinput_R(Self: TInt2; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TPT2simOutput_R(Self: TPT2; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPT2fr_R(Self: TPT2; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TPT2output_R(Self: TPT2; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TPT2delta_W(Self: TPT2; const T: extended);
Begin Self.delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2delta_R(Self: TPT2; var T: extended);
Begin T := Self.delta; end;

(*----------------------------------------------------------------------------*)
procedure TPT2omega_W(Self: TPT2; const T: extended);
Begin Self.omega := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2omega_R(Self: TPT2; var T: extended);
Begin T := Self.omega; end;

(*----------------------------------------------------------------------------*)
procedure TPT2amplitude_W(Self: TPT2; const T: extended);
Begin Self.amplitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2amplitude_R(Self: TPT2; var T: extended);
Begin T := Self.amplitude; end;

(*----------------------------------------------------------------------------*)
procedure TPT2x2_W(Self: TPT2; const T: extended);
Begin Self.x2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2x2_R(Self: TPT2; var T: extended);
Begin T := Self.x2; end;

(*----------------------------------------------------------------------------*)
procedure TPT2x1_W(Self: TPT2; const T: extended);
Begin Self.x1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2x1_R(Self: TPT2; var T: extended);
Begin T := Self.x1; end;

(*----------------------------------------------------------------------------*)
procedure TPT2dmp_W(Self: TPT2; const T: extended);
Begin Self.dmp := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2dmp_R(Self: TPT2; var T: extended);
Begin T := Self.dmp; end;

(*----------------------------------------------------------------------------*)
procedure TPT2t2_W(Self: TPT2; const T: extended);
Begin Self.t2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2t2_R(Self: TPT2; var T: extended);
Begin T := Self.t2; end;

(*----------------------------------------------------------------------------*)
procedure TPT2G_W(Self: TPT2; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2G_R(Self: TPT2; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TPT2input_W(Self: TPT2; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT2input_R(Self: TPT2; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TPT1simOutput_R(Self: TPT1; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPT1fr_R(Self: TPT1; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TPT1output_R(Self: TPT1; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TPT1delta_W(Self: TPT1; const T: extended);
Begin Self.delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT1delta_R(Self: TPT1; var T: extended);
Begin T := Self.delta; end;

(*----------------------------------------------------------------------------*)
procedure TPT1omega_W(Self: TPT1; const T: extended);
Begin Self.omega := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT1omega_R(Self: TPT1; var T: extended);
Begin T := Self.omega; end;

(*----------------------------------------------------------------------------*)
procedure TPT1amplitude_W(Self: TPT1; const T: extended);
Begin Self.amplitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT1amplitude_R(Self: TPT1; var T: extended);
Begin T := Self.amplitude; end;

(*----------------------------------------------------------------------------*)
procedure TPT1x1_W(Self: TPT1; const T: extended);
Begin Self.x1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT1x1_R(Self: TPT1; var T: extended);
Begin T := Self.x1; end;

(*----------------------------------------------------------------------------*)
procedure TPT1t1_W(Self: TPT1; const T: extended);
Begin Self.t1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT1t1_R(Self: TPT1; var T: extended);
Begin T := Self.t1; end;

(*----------------------------------------------------------------------------*)
procedure TPT1G_W(Self: TPT1; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT1G_R(Self: TPT1; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TPT1input_W(Self: TPT1; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT1input_R(Self: TPT1; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TPT0simOutput_R(Self: TPT0; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPT0nt_W(Self: TPT0; const T: integer);
begin Self.nt := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT0nt_R(Self: TPT0; var T: integer);
begin T := Self.nt; end;

(*----------------------------------------------------------------------------*)
procedure TPT0fr_R(Self: TPT0; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TPT0output_R(Self: TPT0; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TPT0xt_W(Self: TPT0; const T: TVectorE);
Begin Self.xt := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT0xt_R(Self: TPT0; var T: TVectorE {array of extended});
Begin T := Self.xt; end;

(*----------------------------------------------------------------------------*)
procedure TPT0delta_W(Self: TPT0; const T: extended);
Begin Self.delta := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT0delta_R(Self: TPT0; var T: extended);
Begin T := Self.delta; end;

(*----------------------------------------------------------------------------*)
procedure TPT0omega_W(Self: TPT0; const T: extended);
Begin Self.omega := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT0omega_R(Self: TPT0; var T: extended);
Begin T := Self.omega; end;

(*----------------------------------------------------------------------------*)
procedure TPT0amplitude_W(Self: TPT0; const T: extended);
Begin Self.amplitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT0amplitude_R(Self: TPT0; var T: extended);
Begin T := Self.amplitude; end;

(*----------------------------------------------------------------------------*)
procedure TPT0G_W(Self: TPT0; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT0G_R(Self: TPT0; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TPT0input_W(Self: TPT0; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TPT0input_R(Self: TPT0; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TPsimOutput_R(Self: TP2; var T: extended);
begin T := Self.simOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPfr_R(Self: TP2; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TPoutput_R(Self: TP2; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TPomega_W(Self: TP2; const T: extended);
Begin Self.omega := T; end;

(*----------------------------------------------------------------------------*)
procedure TPomega_R(Self: TP2; var T: extended);
Begin T := Self.omega; end;

(*----------------------------------------------------------------------------*)
procedure TPamplitude_W(Self: TP2; const T: extended);
Begin Self.amplitude := T; end;

(*----------------------------------------------------------------------------*)
procedure TPamplitude_R(Self: TP2; var T: extended);
Begin T := Self.amplitude; end;

(*----------------------------------------------------------------------------*)
procedure TPG_W(Self: TP2; const T: extended);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TPG_R(Self: TP2; var T: extended);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TPinput_W(Self: TP2; const T: extended);
Begin Self.input := T; end;

(*----------------------------------------------------------------------------*)
procedure TPinput_R(Self: TP2; var T: extended);
Begin T := Self.input; end;

(*----------------------------------------------------------------------------*)
procedure TBlockfr_R(Self: TBlock; var T: TFR);
begin T := Self.fr; end;

(*----------------------------------------------------------------------------*)
procedure TBlockoutput_R(Self: TBlock; var T: extended);
begin T := Self.output; end;

(*----------------------------------------------------------------------------*)
procedure TBlockname_W(Self: TBlock; const T: string);
Begin Self.name := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockname_R(Self: TBlock; var T: string);
Begin T := Self.name; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPDiv(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPDiv) do
  begin
    RegisterPropertyHelper(@TPDivinput1_R,@TPDivinput1_W,'input1');
    RegisterPropertyHelper(@TPDivinput2_R,@TPDivinput2_W,'input2');
    RegisterPropertyHelper(@TPDivG_R,@TPDivG_W,'G');
    RegisterConstructor(@TPDiv.Create, 'Create');
    RegisterMethod(@TPDiv.Destroy, 'Free');
    RegisterPropertyHelper(@TPDivoutput_R,nil,'output');
    RegisterMethod(@TPDiv.simulate, 'simulate');
    RegisterPropertyHelper(@TPDivsimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPMul(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPMul) do
  begin
    RegisterPropertyHelper(@TPMulinput1_R,@TPMulinput1_W,'input1');
    RegisterPropertyHelper(@TPMulinput2_R,@TPMulinput2_W,'input2');
    RegisterPropertyHelper(@TPMulG_R,@TPMulG_W,'G');
    RegisterConstructor(@TPMul.Create, 'Create');
    RegisterMethod(@TPMul.Destroy, 'Free');
    RegisterPropertyHelper(@TPMuloutput_R,nil,'output');
    RegisterMethod(@TPMul.simulate, 'simulate');
    RegisterPropertyHelper(@TPMulsimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSub(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSub) do
  begin
    RegisterPropertyHelper(@TPSubinput1_R,@TPSubinput1_W,'input1');
    RegisterPropertyHelper(@TPSubinput2_R,@TPSubinput2_W,'input2');
    RegisterPropertyHelper(@TPSubG_R,@TPSubG_W,'G');
    RegisterConstructor(@TPSub.Create, 'Create');
    RegisterMethod(@TPSub.Destroy, 'Free');
    RegisterPropertyHelper(@TPSuboutput_R,nil,'output');
    RegisterMethod(@TPSub.simulate, 'simulate');
    RegisterPropertyHelper(@TPSubsimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPAdd(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPAdd) do
  begin
    RegisterPropertyHelper(@TPAddinput1_R,@TPAddinput1_W,'input1');
    RegisterPropertyHelper(@TPAddinput2_R,@TPAddinput2_W,'input2');
    RegisterPropertyHelper(@TPAddG_R,@TPAddG_W,'G');
    RegisterConstructor(@TPAdd.Create, 'Create');
    RegisterMethod(@TPAdd.Destroy, 'Free');
    RegisterPropertyHelper(@TPAddoutput_R,nil,'output');
    RegisterMethod(@TPAdd.simulate, 'simulate');
    RegisterPropertyHelper(@TPAddsimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIT2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIT2) do
  begin
    RegisterPropertyHelper(@TIT2input_R,@TIT2input_W,'input');
    RegisterPropertyHelper(@TIT2G_R,@TIT2G_W,'G');
    RegisterPropertyHelper(@TIT2t2_R,@TIT2t2_W,'t2');
    RegisterPropertyHelper(@TIT2dmp_R,@TIT2dmp_W,'dmp');
    RegisterPropertyHelper(@TIT2x1_R,@TIT2x1_W,'x1');
    RegisterPropertyHelper(@TIT2x2_R,@TIT2x2_W,'x2');
    RegisterPropertyHelper(@TIT2x3_R,@TIT2x3_W,'x3');
    RegisterPropertyHelper(@TIT2amplitude_R,@TIT2amplitude_W,'amplitude');
    RegisterPropertyHelper(@TIT2omega_R,@TIT2omega_W,'omega');
    RegisterPropertyHelper(@TIT2delta_R,@TIT2delta_W,'delta');
    RegisterConstructor(@TIT2.Create, 'Create');
    RegisterMethod(@TIT2.Destroy, 'Free');
    RegisterPropertyHelper(@TIT2output_R,nil,'output');
    RegisterPropertyHelper(@TIT2fr_R,nil,'fr');
    RegisterMethod(@TIT2.simulate, 'simulate');
    RegisterPropertyHelper(@TIT2simOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDT1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDT1) do
  begin
    RegisterPropertyHelper(@TDT1input_R,@TDT1input_W,'input');
    RegisterPropertyHelper(@TDT1G_R,@TDT1G_W,'G');
    RegisterPropertyHelper(@TDT1t1_R,@TDT1t1_W,'t1');
    RegisterPropertyHelper(@TDT1x1_R,@TDT1x1_W,'x1');
    RegisterPropertyHelper(@TDT1amplitude_R,@TDT1amplitude_W,'amplitude');
    RegisterPropertyHelper(@TDT1omega_R,@TDT1omega_W,'omega');
    RegisterPropertyHelper(@TDT1delta_R,@TDT1delta_W,'delta');
    RegisterConstructor(@TDT1.Create, 'Create');
    RegisterMethod(@TDT1.Destroy, 'Free');
    RegisterPropertyHelper(@TDT1output_R,nil,'output');
    RegisterPropertyHelper(@TDT1fr_R,nil,'fr');
    RegisterMethod(@TDT1.simulate, 'simulate');
    RegisterPropertyHelper(@TDT1simOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIT1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIT1) do
  begin
    RegisterPropertyHelper(@TIT1input_R,@TIT1input_W,'input');
    RegisterPropertyHelper(@TIT1G_R,@TIT1G_W,'G');
    RegisterPropertyHelper(@TIT1t1_R,@TIT1t1_W,'t1');
    RegisterPropertyHelper(@TIT1x1_R,@TIT1x1_W,'x1');
    RegisterPropertyHelper(@TIT1amplitude_R,@TIT1amplitude_W,'amplitude');
    RegisterPropertyHelper(@TIT1omega_R,@TIT1omega_W,'omega');
    RegisterPropertyHelper(@TIT1delta_R,@TIT1delta_W,'delta');
    RegisterConstructor(@TIT1.Create, 'Create');
    RegisterMethod(@TIT1.Destroy, 'Free');
    RegisterPropertyHelper(@TIT1output_R,nil,'output');
    RegisterPropertyHelper(@TIT1fr_R,nil,'fr');
    RegisterMethod(@TIT1.simulate, 'simulate');
    RegisterPropertyHelper(@TIT1simOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInt2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInt2) do
  begin
    RegisterPropertyHelper(@TIntinput_R,@TIntinput_W,'input');
    RegisterPropertyHelper(@TIntG_R,@TIntG_W,'G');
    RegisterPropertyHelper(@TIntamplitude_R,@TIntamplitude_W,'amplitude');
    RegisterPropertyHelper(@TIntomega_R,@TIntomega_W,'omega');
    RegisterPropertyHelper(@TIntdelta_R,@TIntdelta_W,'delta');
    RegisterConstructor(@TInt2.Create, 'Create');
    RegisterMethod(@TInt2.Destroy, 'Free');
    RegisterPropertyHelper(@TIntoutput_R,nil,'output');
    RegisterPropertyHelper(@TIntfr_R,nil,'fr');
    RegisterMethod(@TInt2.simulate, 'simulate');
    RegisterPropertyHelper(@TIntsimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPT2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPT2) do
  begin
    RegisterPropertyHelper(@TPT2input_R,@TPT2input_W,'input');
    RegisterPropertyHelper(@TPT2G_R,@TPT2G_W,'G');
    RegisterPropertyHelper(@TPT2t2_R,@TPT2t2_W,'t2');
    RegisterPropertyHelper(@TPT2dmp_R,@TPT2dmp_W,'dmp');
    RegisterPropertyHelper(@TPT2x1_R,@TPT2x1_W,'x1');
    RegisterPropertyHelper(@TPT2x2_R,@TPT2x2_W,'x2');
    RegisterPropertyHelper(@TPT2amplitude_R,@TPT2amplitude_W,'amplitude');
    RegisterPropertyHelper(@TPT2omega_R,@TPT2omega_W,'omega');
    RegisterPropertyHelper(@TPT2delta_R,@TPT2delta_W,'delta');
    RegisterConstructor(@TPT2.Create, 'Create');
    RegisterMethod(@TPT2.Destroy, 'Free');
    RegisterPropertyHelper(@TPT2output_R,nil,'output');
    RegisterPropertyHelper(@TPT2fr_R,nil,'fr');
    RegisterMethod(@TPT2.simulate, 'simulate');
    RegisterPropertyHelper(@TPT2simOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPT1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPT1) do
  begin
    RegisterPropertyHelper(@TPT1input_R,@TPT1input_W,'input');
    RegisterPropertyHelper(@TPT1G_R,@TPT1G_W,'G');
    RegisterPropertyHelper(@TPT1t1_R,@TPT1t1_W,'t1');
    RegisterPropertyHelper(@TPT1x1_R,@TPT1x1_W,'x1');
    RegisterPropertyHelper(@TPT1amplitude_R,@TPT1amplitude_W,'amplitude');
    RegisterPropertyHelper(@TPT1omega_R,@TPT1omega_W,'omega');
    RegisterPropertyHelper(@TPT1delta_R,@TPT1delta_W,'delta');
    RegisterConstructor(@TPT1.Create, 'Create');
    RegisterMethod(@TPT1.Destroy, 'Free');
    RegisterPropertyHelper(@TPT1output_R,nil,'output');
    RegisterPropertyHelper(@TPT1fr_R,nil,'fr');
    RegisterMethod(@TPT1.simulate, 'simulate');
    RegisterPropertyHelper(@TPT1simOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPT0(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPT0) do
  begin
    RegisterPropertyHelper(@TPT0input_R,@TPT0input_W,'input');
    RegisterPropertyHelper(@TPT0G_R,@TPT0G_W,'G');
    RegisterPropertyHelper(@TPT0amplitude_R,@TPT0amplitude_W,'amplitude');
    RegisterPropertyHelper(@TPT0omega_R,@TPT0omega_W,'omega');
    RegisterPropertyHelper(@TPT0delta_R,@TPT0delta_W,'delta');
    RegisterPropertyHelper(@TPT0xt_R,@TPT0xt_W,'xt');
    RegisterConstructor(@TPT0.Create, 'Create');
    RegisterMethod(@TPT0.Destroy, 'Free');
    RegisterPropertyHelper(@TPT0output_R,nil,'output');
    RegisterPropertyHelper(@TPT0fr_R,nil,'fr');
    RegisterPropertyHelper(@TPT0nt_R,@TPT0nt_W,'nt');
    RegisterMethod(@TPT0.simulate, 'simulate');
    RegisterPropertyHelper(@TPT0simOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TP2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TP2) do
  begin
    RegisterPropertyHelper(@TPinput_R,@TPinput_W,'input');
    RegisterPropertyHelper(@TPG_R,@TPG_W,'G');
    RegisterPropertyHelper(@TPamplitude_R,@TPamplitude_W,'amplitude');
    RegisterPropertyHelper(@TPomega_R,@TPomega_W,'omega');
    RegisterConstructor(@TP2.Create, 'Create');
    RegisterMethod(@TP2.Destroy, 'Free');
    RegisterPropertyHelper(@TPoutput_R,nil,'output');
    RegisterPropertyHelper(@TPfr_R,nil,'fr');
    RegisterMethod(@TP2.simulate, 'simulate');
    RegisterPropertyHelper(@TPsimOutput_R,nil,'simOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlock(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlock) do
  begin
    RegisterPropertyHelper(@TBlockname_R,@TBlockname_W,'name');
    //RegisterVirtualAbstractMethod(@TBlock, @!.simulate, 'simulate');
    RegisterPropertyHelper(@TBlockoutput_R,nil,'output');
    RegisterMethod(@TBlock.Destroy, 'Free');
    RegisterPropertyHelper(@TBlockfr_R,nil,'fr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Bricks(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBlock(CL);
  RIRegister_TP2(CL);
  RIRegister_TPT0(CL);
  RIRegister_TPT1(CL);
  RIRegister_TPT2(CL);
  RIRegister_TInt2(CL);
  RIRegister_TIT1(CL);
  RIRegister_TDT1(CL);
  RIRegister_TIT2(CL);
  RIRegister_TPAdd(CL);
  RIRegister_TPSub(CL);
  RIRegister_TPMul(CL);
  RIRegister_TPDiv(CL);
end;

 
 
{ TPSImport_Bricks }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Bricks.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Bricks(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Bricks.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Bricks(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
