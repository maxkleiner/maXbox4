unit uPSI_JvTMTL;
{
   time liner
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
  TPSImport_JvTMTL = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvTMTimeline(CL: TPSPascalCompiler);
procedure SIRegister_TJvCustomTMTimeline(CL: TPSPascalCompiler);
procedure SIRegister_TJvTLSelFrame(CL: TPSPascalCompiler);
procedure SIRegister_JvTMTL(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvTMTimeline(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvCustomTMTimeline(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvTLSelFrame(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvTMTL(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Buttons
  ,Graphics
  ,ExtCtrls
  ,Forms
  ,ImgList
  ,JvComponent
  ,JvTMTL
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvTMTL]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTMTimeline(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomTMTimeline', 'TJvTMTimeline') do
  with CL.AddClassN(CL.FindClass('TJvCustomTMTimeline'),'TJvTMTimeline') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCustomTMTimeline(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomPanel', 'TJvCustomTMTimeline') do
  with CL.AddClassN(CL.FindClass('TJvCustomPanel'),'TJvCustomTMTimeline') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure ClearImages');
    RegisterMethod('Procedure ClearObjects');
    RegisterMethod('Procedure ScrollDate( Sender : TObject; Delta : Integer)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromFile( const Filename : string)');
    RegisterMethod('Procedure SaveToFile( const Filename : string)');
    RegisterProperty('ImageIndex', 'Integer TDate', iptrw);
    RegisterProperty('Objects', 'TObject TDate', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvTLSelFrame(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TJvTLSelFrame') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TJvTLSelFrame') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('Pen', 'TPen', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvTMTL(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TDate', 'TDateTime');
  SIRegister_TJvTLSelFrame(CL);
  CL.AddTypeS('TJvBtnDown', '( bdNone, bdLeft, bdRight )');
  CL.AddTypeS('TJvObjectReadEvent', 'Procedure ( Sender : TObject; Stream : TStream; var AObject : TObject)');
  CL.AddTypeS('TJvObjectWriteEvent', 'Procedure ( Sender : TObject; Stream : TStream; const AObject : TObject)');
  SIRegister_TJvCustomTMTimeline(CL);
  SIRegister_TJvTMTimeline(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCustomTMTimelineObjects_W(Self: TJvCustomTMTimeline; const T: TObject; const t1: TDate);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomTMTimelineObjects_R(Self: TJvCustomTMTimeline; var T: TObject; const t1: TDate);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomTMTimelineImageIndex_W(Self: TJvCustomTMTimeline; const T: Integer; const t1: TDate);
begin Self.ImageIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCustomTMTimelineImageIndex_R(Self: TJvCustomTMTimeline; var T: Integer; const t1: TDate);
begin T := Self.ImageIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvTLSelFrameOnChange_W(Self: TJvTLSelFrame; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTLSelFrameOnChange_R(Self: TJvTLSelFrame; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvTLSelFrameVisible_W(Self: TJvTLSelFrame; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTLSelFrameVisible_R(Self: TJvTLSelFrame; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TJvTLSelFramePen_W(Self: TJvTLSelFrame; const T: TPen);
begin Self.Pen := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvTLSelFramePen_R(Self: TJvTLSelFrame; var T: TPen);
begin T := Self.Pen; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTMTimeline(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTMTimeline) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCustomTMTimeline(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCustomTMTimeline) do
  begin
    RegisterConstructor(@TJvCustomTMTimeline.Create, 'Create');
    RegisterMethod(@TJvCustomTMTimeline.ClearImages, 'ClearImages');
    RegisterMethod(@TJvCustomTMTimeline.ClearObjects, 'ClearObjects');
    RegisterMethod(@TJvCustomTMTimeline.ScrollDate, 'ScrollDate');
    RegisterMethod(@TJvCustomTMTimeline.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJvCustomTMTimeline.SaveToStream, 'SaveToStream');
    RegisterMethod(@TJvCustomTMTimeline.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TJvCustomTMTimeline.SaveToFile, 'SaveToFile');
    RegisterPropertyHelper(@TJvCustomTMTimelineImageIndex_R,@TJvCustomTMTimelineImageIndex_W,'ImageIndex');
    RegisterPropertyHelper(@TJvCustomTMTimelineObjects_R,@TJvCustomTMTimelineObjects_W,'Objects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvTLSelFrame(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvTLSelFrame) do
  begin
    RegisterConstructor(@TJvTLSelFrame.Create, 'Create');
    RegisterMethod(@TJvTLSelFrame.Assign, 'Assign');
    RegisterPropertyHelper(@TJvTLSelFramePen_R,@TJvTLSelFramePen_W,'Pen');
    RegisterPropertyHelper(@TJvTLSelFrameVisible_R,@TJvTLSelFrameVisible_W,'Visible');
    RegisterPropertyHelper(@TJvTLSelFrameOnChange_R,@TJvTLSelFrameOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvTMTL(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvTLSelFrame(CL);
  RIRegister_TJvCustomTMTimeline(CL);
  RIRegister_TJvTMTimeline(CL);
end;

 
 
{ TPSImport_JvTMTL }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTMTL.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvTMTL(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvTMTL.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvTMTL(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
