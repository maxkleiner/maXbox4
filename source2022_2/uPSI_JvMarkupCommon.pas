unit uPSI_JvMarkupCommon;
{
   to set hyperlinks
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
  TPSImport_JvMarkupCommon = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvHTMLElementStack(CL: TPSPascalCompiler);
procedure SIRegister_TJvHTMLElement(CL: TPSPascalCompiler);
procedure SIRegister_JvMarkupCommon(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvHTMLElementStack(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHTMLElement(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvMarkupCommon(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  //,Windows
  //,Controls
  Graphics
  ,JvMarkupCommon
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvMarkupCommon]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHTMLElementStack(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TJvHTMLElementStack') do
  with CL.AddClassN(CL.FindClass('TList'),'TJvHTMLElementStack') do begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Push( Element : TJvHTMLElement)');
    RegisterMethod('Function Pop : TJvHTMLElement');
    RegisterMethod('Function Peek : TJvHTMLElement');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHTMLElement(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvHTMLElement') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvHTMLElement') do begin
    RegisterMethod('Procedure Breakup( ACanvas : TCanvas; Available : Integer)');
    RegisterMethod('Procedure Free');
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('SolText', 'string', iptrw);
    RegisterProperty('EolText', 'string', iptrw);
    RegisterProperty('FontName', 'string', iptrw);
    RegisterProperty('FontSize', 'Integer', iptrw);
    RegisterProperty('FontStyle', 'TFontStyles', iptrw);
    RegisterProperty('FontColor', 'TColor', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('Ascent', 'Integer', iptrw);
    RegisterProperty('BreakLine', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvMarkupCommon(CL: TPSPascalCompiler);
begin
  SIRegister_TJvHTMLElement(CL);
  SIRegister_TJvHTMLElementStack(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementBreakLine_W(Self: TJvHTMLElement; const T: Boolean);
begin Self.BreakLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementBreakLine_R(Self: TJvHTMLElement; var T: Boolean);
begin T := Self.BreakLine; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementAscent_W(Self: TJvHTMLElement; const T: Integer);
begin Self.Ascent := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementAscent_R(Self: TJvHTMLElement; var T: Integer);
begin T := Self.Ascent; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementWidth_W(Self: TJvHTMLElement; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementWidth_R(Self: TJvHTMLElement; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementHeight_W(Self: TJvHTMLElement; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementHeight_R(Self: TJvHTMLElement; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementFontColor_W(Self: TJvHTMLElement; const T: TColor);
begin Self.FontColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementFontColor_R(Self: TJvHTMLElement; var T: TColor);
begin T := Self.FontColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementFontStyle_W(Self: TJvHTMLElement; const T: TFontStyles);
begin Self.FontStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementFontStyle_R(Self: TJvHTMLElement; var T: TFontStyles);
begin T := Self.FontStyle; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementFontSize_W(Self: TJvHTMLElement; const T: Integer);
begin Self.FontSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementFontSize_R(Self: TJvHTMLElement; var T: Integer);
begin T := Self.FontSize; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementFontName_W(Self: TJvHTMLElement; const T: string);
begin Self.FontName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementFontName_R(Self: TJvHTMLElement; var T: string);
begin T := Self.FontName; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementEolText_W(Self: TJvHTMLElement; const T: string);
begin Self.EolText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementEolText_R(Self: TJvHTMLElement; var T: string);
begin T := Self.EolText; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementSolText_W(Self: TJvHTMLElement; const T: string);
begin Self.SolText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementSolText_R(Self: TJvHTMLElement; var T: string);
begin T := Self.SolText; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementText_W(Self: TJvHTMLElement; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTMLElementText_R(Self: TJvHTMLElement; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHTMLElementStack(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHTMLElementStack) do begin
    RegisterMethod(@TJvHTMLElementStack.Clear, 'Clear');
    RegisterMethod(@TJvHTMLElementStack.Destroy, 'Free');
    RegisterMethod(@TJvHTMLElementStack.Push, 'Push');
    RegisterMethod(@TJvHTMLElementStack.Pop, 'Pop');
    RegisterMethod(@TJvHTMLElementStack.Peek, 'Peek');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHTMLElement(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHTMLElement) do begin
    RegisterMethod(@TJvHTMLElement.Breakup, 'Breakup');
    RegisterPropertyHelper(@TJvHTMLElementText_R,@TJvHTMLElementText_W,'Text');
    RegisterPropertyHelper(@TJvHTMLElementSolText_R,@TJvHTMLElementSolText_W,'SolText');
    RegisterPropertyHelper(@TJvHTMLElementEolText_R,@TJvHTMLElementEolText_W,'EolText');
    RegisterPropertyHelper(@TJvHTMLElementFontName_R,@TJvHTMLElementFontName_W,'FontName');
    RegisterPropertyHelper(@TJvHTMLElementFontSize_R,@TJvHTMLElementFontSize_W,'FontSize');
    RegisterPropertyHelper(@TJvHTMLElementFontStyle_R,@TJvHTMLElementFontStyle_W,'FontStyle');
    RegisterPropertyHelper(@TJvHTMLElementFontColor_R,@TJvHTMLElementFontColor_W,'FontColor');
    RegisterPropertyHelper(@TJvHTMLElementHeight_R,@TJvHTMLElementHeight_W,'Height');
    RegisterPropertyHelper(@TJvHTMLElementWidth_R,@TJvHTMLElementWidth_W,'Width');
    RegisterPropertyHelper(@TJvHTMLElementAscent_R,@TJvHTMLElementAscent_W,'Ascent');
    RegisterPropertyHelper(@TJvHTMLElementBreakLine_R,@TJvHTMLElementBreakLine_W,'BreakLine');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvMarkupCommon(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvHTMLElement(CL);
  RIRegister_TJvHTMLElementStack(CL);
end;

 
 
{ TPSImport_JvMarkupCommon }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMarkupCommon.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvMarkupCommon(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvMarkupCommon.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvMarkupCommon(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
