unit uPSI_cyAttract;
{
   another way of para dice
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
  TPSImport_cyAttract = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyAttract(CL: TPSPascalCompiler);
procedure SIRegister_TAnimationThreadHandler(CL: TPSPascalCompiler);
procedure SIRegister_TAttractFrames(CL: TPSPascalCompiler);
procedure SIRegister_TAttractFrame(CL: TPSPascalCompiler);
procedure SIRegister_cyAttract(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyAttract(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAnimationThreadHandler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAttractFrames(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAttractFrame(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyAttract(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Types
  ,Graphics
  ,Controls
  ,cyGraphics
  ,cyAttract
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyAttract]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyAttract(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyAttract') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyAttract') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Control', 'TControl', iptrw);
    RegisterProperty('Enabled', 'boolean', iptrw);
    RegisterProperty('Interval', 'Cardinal', iptrw);
    RegisterProperty('Fluid', 'boolean', iptrw);
    RegisterProperty('Frames', 'TAttractFrames', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAnimationThreadHandler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TAnimationThreadHandler') do
  with CL.AddClassN(CL.FindClass('TThread'),'TAnimationThreadHandler') do begin
    RegisterMethod('Procedure Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAttractFrames(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TAttractFrames') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TAttractFrames') do begin
    RegisterMethod('Constructor Create( aControl : TComponent; FrameClass : TAttractFrameClass)');
    RegisterMethod('Function Add : TAttractFrame');
    RegisterProperty('Items', 'TAttractFrame Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAttractFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TAttractFrame') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TAttractFrame') do
  begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterProperty('Pen', 'TPen', iptrw);
    RegisterProperty('SizePercent', 'Cardinal', iptrw);
    RegisterProperty('TimeStart', 'cardinal', iptrw);
    RegisterProperty('TimeEnd', 'cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyAttract(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('constInterval','LongInt').SetInt( 3000);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TcyAttract');
  SIRegister_TAttractFrame(CL);
  //CL.AddTypeS('TAttractFrameClass', 'class of TAttractFrame');
  SIRegister_TAttractFrames(CL);
  SIRegister_TAnimationThreadHandler(CL);
  SIRegister_TcyAttract(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyAttractFrames_W(Self: TcyAttract; const T: TAttractFrames);
begin Self.Frames := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractFrames_R(Self: TcyAttract; var T: TAttractFrames);
begin T := Self.Frames; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractFluid_W(Self: TcyAttract; const T: boolean);
begin Self.Fluid := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractFluid_R(Self: TcyAttract; var T: boolean);
begin T := Self.Fluid; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractInterval_W(Self: TcyAttract; const T: Cardinal);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractInterval_R(Self: TcyAttract; var T: Cardinal);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractEnabled_W(Self: TcyAttract; const T: boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractEnabled_R(Self: TcyAttract; var T: boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractControl_W(Self: TcyAttract; const T: TControl);
begin Self.Control := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyAttractControl_R(Self: TcyAttract; var T: TControl);
begin T := Self.Control; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFramesItems_R(Self: TAttractFrames; var T: TAttractFrame; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFrameTimeEnd_W(Self: TAttractFrame; const T: cardinal);
begin Self.TimeEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFrameTimeEnd_R(Self: TAttractFrame; var T: cardinal);
begin T := Self.TimeEnd; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFrameTimeStart_W(Self: TAttractFrame; const T: cardinal);
begin Self.TimeStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFrameTimeStart_R(Self: TAttractFrame; var T: cardinal);
begin T := Self.TimeStart; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFrameSizePercent_W(Self: TAttractFrame; const T: Cardinal);
begin Self.SizePercent := T; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFrameSizePercent_R(Self: TAttractFrame; var T: Cardinal);
begin T := Self.SizePercent; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFramePen_W(Self: TAttractFrame; const T: TPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TAttractFramePen_R(Self: TAttractFrame; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyAttract(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyAttract) do
  begin
    RegisterConstructor(@TcyAttract.Create, 'Create');
    RegisterPropertyHelper(@TcyAttractControl_R,@TcyAttractControl_W,'Control');
    RegisterPropertyHelper(@TcyAttractEnabled_R,@TcyAttractEnabled_W,'Enabled');
    RegisterPropertyHelper(@TcyAttractInterval_R,@TcyAttractInterval_W,'Interval');
    RegisterPropertyHelper(@TcyAttractFluid_R,@TcyAttractFluid_W,'Fluid');
    RegisterPropertyHelper(@TcyAttractFrames_R,@TcyAttractFrames_W,'Frames');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAnimationThreadHandler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAnimationThreadHandler) do
  begin
    RegisterMethod(@TAnimationThreadHandler.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAttractFrames(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAttractFrames) do
  begin
    RegisterConstructor(@TAttractFrames.Create, 'Create');
    RegisterMethod(@TAttractFrames.Add, 'Add');
    RegisterPropertyHelper(@TAttractFramesItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAttractFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAttractFrame) do
  begin
    RegisterConstructor(@TAttractFrame.Create, 'Create');
    RegisterPropertyHelper(@TAttractFramePen_R,@TAttractFramePen_W,'Pen');
    RegisterPropertyHelper(@TAttractFrameSizePercent_R,@TAttractFrameSizePercent_W,'SizePercent');
    RegisterPropertyHelper(@TAttractFrameTimeStart_R,@TAttractFrameTimeStart_W,'TimeStart');
    RegisterPropertyHelper(@TAttractFrameTimeEnd_R,@TAttractFrameTimeEnd_W,'TimeEnd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyAttract(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyAttract) do
  RIRegister_TAttractFrame(CL);
  RIRegister_TAttractFrames(CL);
  RIRegister_TAnimationThreadHandler(CL);
  RIRegister_TcyAttract(CL);
end;

 
 
{ TPSImport_cyAttract }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyAttract.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyAttract(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyAttract.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyAttract(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
