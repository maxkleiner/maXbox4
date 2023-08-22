unit uPSI_GR32_Rasterizers;
{

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
  TPSImport_GR32_Rasterizers = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMultithreadedRegularRasterizer(CL: TPSPascalCompiler);
procedure SIRegister_TContourRasterizer(CL: TPSPascalCompiler);
procedure SIRegister_TTesseralRasterizer(CL: TPSPascalCompiler);
procedure SIRegister_TProgressiveRasterizer(CL: TPSPascalCompiler);
procedure SIRegister_TSwizzlingRasterizer(CL: TPSPascalCompiler);
procedure SIRegister_TRegularRasterizer(CL: TPSPascalCompiler);
procedure SIRegister_TRasterizer(CL: TPSPascalCompiler);
procedure SIRegister_GR32_Rasterizers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GR32_Rasterizers_Routines(S: TPSExec);
procedure RIRegister_TMultithreadedRegularRasterizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TContourRasterizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTesseralRasterizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProgressiveRasterizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSwizzlingRasterizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRegularRasterizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TRasterizer(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_Rasterizers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //LCLIntf
  Windows
  ,GR32
  ,GR32_Blend
  ,GR32_OrdinalMaps
  ,GR32_Rasterizers
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_Rasterizers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMultithreadedRegularRasterizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRasterizer', 'TMultithreadedRegularRasterizer') do
  with CL.AddClassN(CL.FindClass('TRasterizer'),'TMultithreadedRegularRasterizer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TContourRasterizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRasterizer', 'TContourRasterizer') do
  with CL.AddClassN(CL.FindClass('TRasterizer'),'TContourRasterizer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTesseralRasterizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRasterizer', 'TTesseralRasterizer') do
  with CL.AddClassN(CL.FindClass('TRasterizer'),'TTesseralRasterizer') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProgressiveRasterizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRasterizer', 'TProgressiveRasterizer') do
  with CL.AddClassN(CL.FindClass('TRasterizer'),'TProgressiveRasterizer') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Steps', 'Integer', iptrw);
    RegisterProperty('UpdateRows', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSwizzlingRasterizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRasterizer', 'TSwizzlingRasterizer') do
  with CL.AddClassN(CL.FindClass('TRasterizer'),'TSwizzlingRasterizer') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('BlockSize', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRegularRasterizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TRasterizer', 'TRegularRasterizer') do
  with CL.AddClassN(CL.FindClass('TRasterizer'),'TRegularRasterizer') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('UpdateRowCount', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRasterizer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThreadPersistent', 'TRasterizer') do
  with CL.AddClassN(CL.FindClass('TThreadPersistent'),'TRasterizer') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Rasterize( Dst : TCustomBitmap32);');
    RegisterMethod('Procedure Rasterize1( Dst : TCustomBitmap32; const DstRect : TRect);');
    RegisterMethod('Procedure Rasterize2( Dst : TCustomBitmap32; const DstRect : TRect; const CombineInfo : TCombineInfo);');
    RegisterMethod('Procedure Rasterize3( Dst : TCustomBitmap32; const DstRect : TRect; Src : TCustomBitmap32);');
    RegisterProperty('Sampler', 'TCustomSampler', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_Rasterizers(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TAssignColor', 'Procedure ( var Dst : TColor32; Src : TColor32)');
  //CL.AddTypeS('PCombineInfo', '^TCombineInfo // will not work');
  CL.AddTypeS('TCombineInfo', 'record SrcAlpha : Integer; DrawMode : TDrawMode;'
   +' CombineMode : TCombineMode; CombineCallBack : TPixelCombineEvent; Transpa'
   +'rentColor : TColor32; end');
  SIRegister_TRasterizer(CL);
  //CL.AddTypeS('TRasterizerClass', 'class of TRasterizer');
  SIRegister_TRegularRasterizer(CL);
  SIRegister_TSwizzlingRasterizer(CL);
  SIRegister_TProgressiveRasterizer(CL);
  SIRegister_TTesseralRasterizer(CL);
  SIRegister_TContourRasterizer(CL);
  SIRegister_TMultithreadedRegularRasterizer(CL);
 CL.AddDelphiFunction('Function CombineInfo( Bitmap : TCustomBitmap32) : TCombineInfo');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TProgressiveRasterizerUpdateRows_W(Self: TProgressiveRasterizer; const T: Boolean);
begin Self.UpdateRows := T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressiveRasterizerUpdateRows_R(Self: TProgressiveRasterizer; var T: Boolean);
begin T := Self.UpdateRows; end;

(*----------------------------------------------------------------------------*)
procedure TProgressiveRasterizerSteps_W(Self: TProgressiveRasterizer; const T: Integer);
begin Self.Steps := T; end;

(*----------------------------------------------------------------------------*)
procedure TProgressiveRasterizerSteps_R(Self: TProgressiveRasterizer; var T: Integer);
begin T := Self.Steps; end;

(*----------------------------------------------------------------------------*)
procedure TSwizzlingRasterizerBlockSize_W(Self: TSwizzlingRasterizer; const T: Integer);
begin Self.BlockSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSwizzlingRasterizerBlockSize_R(Self: TSwizzlingRasterizer; var T: Integer);
begin T := Self.BlockSize; end;

(*----------------------------------------------------------------------------*)
procedure TRegularRasterizerUpdateRowCount_W(Self: TRegularRasterizer; const T: Integer);
begin Self.UpdateRowCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TRegularRasterizerUpdateRowCount_R(Self: TRegularRasterizer; var T: Integer);
begin T := Self.UpdateRowCount; end;

(*----------------------------------------------------------------------------*)
procedure TRasterizerSampler_W(Self: TRasterizer; const T: TCustomSampler);
begin Self.Sampler := T; end;

(*----------------------------------------------------------------------------*)
procedure TRasterizerSampler_R(Self: TRasterizer; var T: TCustomSampler);
begin T := Self.Sampler; end;

(*----------------------------------------------------------------------------*)
Procedure TRasterizerRasterize3_P(Self: TRasterizer;  Dst : TCustomBitmap32; const DstRect : TRect; Src : TCustomBitmap32);
Begin Self.Rasterize(Dst, DstRect, Src); END;

(*----------------------------------------------------------------------------*)
Procedure TRasterizerRasterize2_P(Self: TRasterizer;  Dst : TCustomBitmap32; const DstRect : TRect; const CombineInfo : TCombineInfo);
Begin Self.Rasterize(Dst, DstRect, CombineInfo); END;

(*----------------------------------------------------------------------------*)
Procedure TRasterizerRasterize1_P(Self: TRasterizer;  Dst : TCustomBitmap32; const DstRect : TRect);
Begin Self.Rasterize(Dst, DstRect); END;

(*----------------------------------------------------------------------------*)
Procedure TRasterizerRasterize_P(Self: TRasterizer;  Dst : TCustomBitmap32);
Begin Self.Rasterize(Dst); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_Rasterizers_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CombineInfo, 'CombineInfo', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMultithreadedRegularRasterizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMultithreadedRegularRasterizer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TContourRasterizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TContourRasterizer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTesseralRasterizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTesseralRasterizer) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProgressiveRasterizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProgressiveRasterizer) do
  begin
    RegisterConstructor(@TProgressiveRasterizer.Create, 'Create');
    RegisterPropertyHelper(@TProgressiveRasterizerSteps_R,@TProgressiveRasterizerSteps_W,'Steps');
    RegisterPropertyHelper(@TProgressiveRasterizerUpdateRows_R,@TProgressiveRasterizerUpdateRows_W,'UpdateRows');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSwizzlingRasterizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSwizzlingRasterizer) do
  begin
    RegisterConstructor(@TSwizzlingRasterizer.Create, 'Create');
    RegisterPropertyHelper(@TSwizzlingRasterizerBlockSize_R,@TSwizzlingRasterizerBlockSize_W,'BlockSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRegularRasterizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRegularRasterizer) do
  begin
    RegisterConstructor(@TRegularRasterizer.Create, 'Create');
    RegisterPropertyHelper(@TRegularRasterizerUpdateRowCount_R,@TRegularRasterizerUpdateRowCount_W,'UpdateRowCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRasterizer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRasterizer) do
  begin
    RegisterConstructor(@TRasterizer.Create, 'Create');
    RegisterMethod(@TRasterizer.Assign, 'Assign');
    RegisterMethod(@TRasterizerRasterize_P, 'Rasterize');
    RegisterMethod(@TRasterizerRasterize1_P, 'Rasterize1');
    RegisterMethod(@TRasterizerRasterize2_P, 'Rasterize2');
    RegisterMethod(@TRasterizerRasterize3_P, 'Rasterize3');
    RegisterPropertyHelper(@TRasterizerSampler_R,@TRasterizerSampler_W,'Sampler');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_Rasterizers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TRasterizer(CL);
  RIRegister_TRegularRasterizer(CL);
  RIRegister_TSwizzlingRasterizer(CL);
  RIRegister_TProgressiveRasterizer(CL);
  RIRegister_TTesseralRasterizer(CL);
  RIRegister_TContourRasterizer(CL);
  RIRegister_TMultithreadedRegularRasterizer(CL);
end;

 
 
{ TPSImport_GR32_Rasterizers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Rasterizers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_Rasterizers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_Rasterizers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32_Rasterizers(ri);
  RIRegister_GR32_Rasterizers_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
