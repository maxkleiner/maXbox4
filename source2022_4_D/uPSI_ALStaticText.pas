unit uPSI_ALStaticText;
{
  another static
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
  TPSImport_ALStaticText = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TALStaticText(CL: TPSPascalCompiler);
procedure SIRegister_TALCustomStaticText(CL: TPSPascalCompiler);
procedure SIRegister_ALStaticText(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ALStaticText_Routines(S: TPSExec);
procedure RIRegister_TALStaticText(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALCustomStaticText(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALStaticText(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Controls
  //,AlFcnSkin
  ,ALStaticText
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALStaticText]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALStaticText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALCustomStaticText', 'TALStaticText') do
  with CL.AddClassN(CL.FindClass('TALCustomStaticText'),'TALStaticText') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALCustomStaticText(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TWinControl', 'TALCustomStaticText') do
  with CL.AddClassN(CL.FindClass('TWinControl'),'TALCustomStaticText') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('MouseInControl', 'Boolean', iptr);
    RegisterProperty('MouseIsDown', 'Boolean', iptr);
    RegisterProperty('KeyIsDown', 'Boolean', iptr);
    RegisterMethod('Procedure Click');
    RegisterMethod('Function AdjustBounds : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALStaticText(CL: TPSPascalCompiler);
begin
  SIRegister_TALCustomStaticText(CL);
  SIRegister_TALStaticText(CL);
 CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALCustomStaticTextKeyIsDown_R(Self: TALCustomStaticText; var T: Boolean);
begin T := Self.KeyIsDown; end;

(*----------------------------------------------------------------------------*)
procedure TALCustomStaticTextMouseIsDown_R(Self: TALCustomStaticText; var T: Boolean);
begin T := Self.MouseIsDown; end;

(*----------------------------------------------------------------------------*)
procedure TALCustomStaticTextMouseInControl_R(Self: TALCustomStaticText; var T: Boolean);
begin T := Self.MouseInControl; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALStaticText_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALStaticText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALStaticText) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALCustomStaticText(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALCustomStaticText) do
  begin
    RegisterConstructor(@TALCustomStaticText.Create, 'Create');
    RegisterPropertyHelper(@TALCustomStaticTextMouseInControl_R,nil,'MouseInControl');
    RegisterPropertyHelper(@TALCustomStaticTextMouseIsDown_R,nil,'MouseIsDown');
    RegisterPropertyHelper(@TALCustomStaticTextKeyIsDown_R,nil,'KeyIsDown');
    RegisterMethod(@TALCustomStaticText.Click, 'Click');
    RegisterMethod(@TALCustomStaticText.AdjustBounds, 'AdjustBounds');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALStaticText(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TALCustomStaticText(CL);
  RIRegister_TALStaticText(CL);
end;

 
 
{ TPSImport_ALStaticText }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALStaticText.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALStaticText(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALStaticText.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALStaticText(ri);
  RIRegister_ALStaticText_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
