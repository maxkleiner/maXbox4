unit uPSI_JvHighlighter;
{
   just to test REST
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
  TPSImport_JvHighlighter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvHighlighter(CL: TPSPascalCompiler);
procedure SIRegister_JvHighlighter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvHighlighter(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvHighlighter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Graphics
  ,Controls
  ,JVCLVer
  ,JvHighlighter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvHighlighter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHighlighter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGraphicControl', 'TJvHighlighter') do
  with CL.AddClassN(CL.FindClass('TGraphicControl'),'TJvHighlighter') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterProperty('AboutJVCL', 'TJVCLAboutInfo', iptrw);
    RegisterProperty('FocusControl', 'TWinControl', iptrw);
    RegisterProperty('ExtraBorder', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvHighlighter(CL: TPSPascalCompiler);
begin
  SIRegister_TJvHighlighter(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvHighlighterExtraBorder_W(Self: TJvHighlighter; const T: Integer);
begin Self.ExtraBorder := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHighlighterExtraBorder_R(Self: TJvHighlighter; var T: Integer);
begin T := Self.ExtraBorder; end;

(*----------------------------------------------------------------------------*)
procedure TJvHighlighterFocusControl_W(Self: TJvHighlighter; const T: TWinControl);
begin Self.FocusControl := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHighlighterFocusControl_R(Self: TJvHighlighter; var T: TWinControl);
begin T := Self.FocusControl; end;

(*----------------------------------------------------------------------------*)
procedure TJvHighlighterAboutJVCL_W(Self: TJvHighlighter; const T: TJVCLAboutInfo);
begin Self.AboutJVCL := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHighlighterAboutJVCL_R(Self: TJvHighlighter; var T: TJVCLAboutInfo);
begin T := Self.AboutJVCL; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHighlighter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHighlighter) do
  begin
    RegisterConstructor(@TJvHighlighter.Create, 'Create');
    RegisterMethod(@TJvHighlighter.Paint, 'Paint');
    RegisterPropertyHelper(@TJvHighlighterAboutJVCL_R,@TJvHighlighterAboutJVCL_W,'AboutJVCL');
    RegisterPropertyHelper(@TJvHighlighterFocusControl_R,@TJvHighlighterFocusControl_W,'FocusControl');
    RegisterPropertyHelper(@TJvHighlighterExtraBorder_R,@TJvHighlighterExtraBorder_W,'ExtraBorder');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvHighlighter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvHighlighter(CL);
end;

 
 
{ TPSImport_JvHighlighter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvHighlighter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvHighlighter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvHighlighter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvHighlighter(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
