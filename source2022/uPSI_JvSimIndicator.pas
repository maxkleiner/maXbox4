unit uPSI_JvSimIndicator;
{
   less margins from tjvrect
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
  TPSImport_JvSimIndicator = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJvSimIndicator(CL: TPSPascalCompiler);
procedure SIRegister_JvSimIndicator(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSimIndicator(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSimIndicator(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  Windows
  ,Graphics
  //,Controls
  ,ExtCtrls
  ,JvComponent
  //,JvJVCLUtils
  ,JvSimIndicator
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSimIndicator]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimIndicator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TJvSimIndicator') do
  with CL.AddClassN(CL.FindClass('TJvGraphicControl'),'TJvSimIndicator') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Paint');
    RegisterProperty('Value', 'Integer', iptrw);
    RegisterProperty('Minimum', 'Integer', iptrw);
    RegisterProperty('Maximum', 'Integer', iptrw);
    RegisterProperty('BarColor', 'TColor', iptrw);
    RegisterProperty('BackColor', 'TColor', iptrw);
    RegisterProperty('Margins', 'TJvRect', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSimIndicator(CL: TPSPascalCompiler);
begin
  SIRegister_TJvSimIndicator(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorMargins_W(Self: TJvSimIndicator; const T: TRect);
begin Self.Margins := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorMargins_R(Self: TJvSimIndicator; var T: TRect);
begin T := Self.Margins; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorBackColor_W(Self: TJvSimIndicator; const T: TColor);
begin Self.BackColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorBackColor_R(Self: TJvSimIndicator; var T: TColor);
begin T := Self.BackColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorBarColor_W(Self: TJvSimIndicator; const T: TColor);
begin Self.BarColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorBarColor_R(Self: TJvSimIndicator; var T: TColor);
begin T := Self.BarColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorMaximum_W(Self: TJvSimIndicator; const T: Integer);
begin Self.Maximum := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorMaximum_R(Self: TJvSimIndicator; var T: Integer);
begin T := Self.Maximum; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorMinimum_W(Self: TJvSimIndicator; const T: Integer);
begin Self.Minimum := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorMinimum_R(Self: TJvSimIndicator; var T: Integer);
begin T := Self.Minimum; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorValue_W(Self: TJvSimIndicator; const T: Integer);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimIndicatorValue_R(Self: TJvSimIndicator; var T: Integer);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimIndicator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimIndicator) do begin
    RegisterConstructor(@TJvSimIndicator.Create, 'Create');
    RegisterMethod(@TJvSimIndicator.Paint, 'Paint');
    RegisterPropertyHelper(@TJvSimIndicatorValue_R,@TJvSimIndicatorValue_W,'Value');
    RegisterPropertyHelper(@TJvSimIndicatorMinimum_R,@TJvSimIndicatorMinimum_W,'Minimum');
    RegisterPropertyHelper(@TJvSimIndicatorMaximum_R,@TJvSimIndicatorMaximum_W,'Maximum');
    RegisterPropertyHelper(@TJvSimIndicatorBarColor_R,@TJvSimIndicatorBarColor_W,'BarColor');
    RegisterPropertyHelper(@TJvSimIndicatorBackColor_R,@TJvSimIndicatorBackColor_W,'BackColor');
    RegisterPropertyHelper(@TJvSimIndicatorMargins_R,@TJvSimIndicatorMargins_W,'Margins');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSimIndicator(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvSimIndicator(CL);
end;

 
 
{ TPSImport_JvSimIndicator }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimIndicator.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSimIndicator(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimIndicator.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSimIndicator(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
