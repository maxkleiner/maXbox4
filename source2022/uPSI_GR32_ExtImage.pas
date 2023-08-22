unit uPSI_GR32_ExtImage;
{
  for for add free
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
  TPSImport_GR32_ExtImage = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRenderThread(CL: TPSPascalCompiler);
procedure SIRegister_TSyntheticImage32(CL: TPSPascalCompiler);
procedure SIRegister_GR32_ExtImage(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_GR32_ExtImage_Routines(S: TPSExec);
procedure RIRegister_TRenderThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSyntheticImage32(CL: TPSRuntimeClassImporter);
procedure RIRegister_GR32_ExtImage(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // LCLIntf
 // ,LCLType
 // ,LMessages
  Windows
  ,Messages
  ,GR32
  ,GR32_Image
  ,GR32_Rasterizers
  ,Controls
  ,GR32_ExtImage
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_GR32_ExtImage]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRenderThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TRenderThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TRenderThread') do begin
    RegisterMethod('Constructor Create( Rasterizer : TRasterizer; Dst : TBitmap32; DstRect : TRect; Suspended : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSyntheticImage32(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPaintBox32', 'TSyntheticImage32') do
  with CL.AddClassN(CL.FindClass('TPaintBox32'),'TSyntheticImage32') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Resize');
    RegisterMethod('Procedure Rasterize');
    RegisterProperty('DstRect', 'TRect', iptrw);
    RegisterProperty('AutoRasterize', 'Boolean', iptrw);
    RegisterProperty('Rasterizer', 'TRasterizer', iptrw);
    RegisterProperty('ClearBuffer', 'Boolean', iptrw);
    RegisterProperty('RenderMode', 'TRenderMode', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('Buffer', 'TBitmap32', iptrw);
    RegisterProperty('Color', 'TColor', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_GR32_ExtImage(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TRenderThread');
  CL.AddTypeS('TRenderMode', '( rnmFull, rnmConstrained )');
  SIRegister_TSyntheticImage32(CL);
  SIRegister_TRenderThread(CL);
 CL.AddDelphiFunction('Procedure Rasterize( Rasterizer : TRasterizer; Dst : TBitmap32; DstRect : TRect)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32RenderMode_W(Self: TSyntheticImage32; const T: TRenderMode);
begin Self.RenderMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32RenderMode_R(Self: TSyntheticImage32; var T: TRenderMode);
begin T := Self.RenderMode; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32ClearBuffer_W(Self: TSyntheticImage32; const T: Boolean);
begin Self.ClearBuffer := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32ClearBuffer_R(Self: TSyntheticImage32; var T: Boolean);
begin T := Self.ClearBuffer; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32Rasterizer_W(Self: TSyntheticImage32; const T: TRasterizer);
begin Self.Rasterizer := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32Rasterizer_R(Self: TSyntheticImage32; var T: TRasterizer);
begin T := Self.Rasterizer; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32AutoRasterize_W(Self: TSyntheticImage32; const T: Boolean);
begin Self.AutoRasterize := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32AutoRasterize_R(Self: TSyntheticImage32; var T: Boolean);
begin T := Self.AutoRasterize; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32DstRect_W(Self: TSyntheticImage32; const T: TRect);
begin Self.DstRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TSyntheticImage32DstRect_R(Self: TSyntheticImage32; var T: TRect);
begin T := Self.DstRect; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_ExtImage_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Rasterize, 'Rasterize', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRenderThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRenderThread) do
  begin
    RegisterConstructor(@TRenderThread.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSyntheticImage32(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSyntheticImage32) do begin
    RegisterConstructor(@TSyntheticImage32.Create, 'Create');
     RegisterMethod(@TSyntheticImage32.Destroy, 'Free');
     RegisterMethod(@TSyntheticImage32.Resize, 'Resize');
    RegisterMethod(@TSyntheticImage32.Rasterize, 'Rasterize');
    RegisterPropertyHelper(@TSyntheticImage32DstRect_R,@TSyntheticImage32DstRect_W,'DstRect');
    RegisterPropertyHelper(@TSyntheticImage32AutoRasterize_R,@TSyntheticImage32AutoRasterize_W,'AutoRasterize');
    RegisterPropertyHelper(@TSyntheticImage32Rasterizer_R,@TSyntheticImage32Rasterizer_W,'Rasterizer');
    RegisterPropertyHelper(@TSyntheticImage32ClearBuffer_R,@TSyntheticImage32ClearBuffer_W,'ClearBuffer');
    RegisterPropertyHelper(@TSyntheticImage32RenderMode_R,@TSyntheticImage32RenderMode_W,'RenderMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_GR32_ExtImage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRenderThread) do
  RIRegister_TSyntheticImage32(CL);
  RIRegister_TRenderThread(CL);
end;

 
 
{ TPSImport_GR32_ExtImage }
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_ExtImage.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_GR32_ExtImage(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_GR32_ExtImage.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_GR32_ExtImage(ri);
  RIRegister_GR32_ExtImage_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
