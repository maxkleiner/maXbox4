unit uPSI_JvHtControls;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_JvHtControls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvHTLabel(CL: TPSPascalCompiler);
procedure SIRegister_TJvHTComboBox(CL: TPSPascalCompiler);
procedure SIRegister_TJvHtListBox(CL: TPSPascalCompiler);
procedure SIRegister_JvHtControls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvHtControls_Routines(S: TPSExec);
procedure RIRegister_TJvHTLabel(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHTComboBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvHtListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvHtControls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,StdCtrls
  ,JvHtControls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvHtControls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHTLabel(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomLabel', 'TJvHTLabel') do
  with CL.AddClassN(CL.FindClass('TCustomLabel'),'TJvHTLabel') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHTComboBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComboBox', 'TJvHTComboBox') do
  with CL.AddClassN(CL.FindClass('TCustomComboBox'),'TJvHTComboBox') do
  begin
    RegisterProperty('PlainItems', 'string Integer', iptr);
    RegisterProperty('HideSel', 'Boolean', iptrw);
    RegisterProperty('DropWidth', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvHtListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomListBox', 'TJvHtListBox') do
  with CL.AddClassN(CL.FindClass('TCustomListBox'),'TJvHtListBox') do
  begin
    RegisterProperty('PlainItems', 'string Integer', iptr);
    RegisterProperty('HideSel', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvHtControls(CL: TPSPascalCompiler);
begin
  SIRegister_TJvHtListBox(CL);
  SIRegister_TJvHTComboBox(CL);
  SIRegister_TJvHTLabel(CL);
 CL.AddDelphiFunction('Procedure ItemHtDrawEx( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean; var PlainItem : string; var Width : Integer; CalcWidth : Boolean)');
 CL.AddDelphiFunction('Function ItemHtDraw( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean) : string');
 CL.AddDelphiFunction('Function ItemHtWidth( Canvas : TCanvas; Rect : TRect; const State : TOwnerDrawState; const Text : string; const HideSelColor : Boolean) : Integer');
 CL.AddDelphiFunction('Function ItemHtPlain( const Text : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvHTComboBoxDropWidth_W(Self: TJvHTComboBox; const T: Integer);
begin Self.DropWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTComboBoxDropWidth_R(Self: TJvHTComboBox; var T: Integer);
begin T := Self.DropWidth; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTComboBoxHideSel_W(Self: TJvHTComboBox; const T: Boolean);
begin Self.HideSel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTComboBoxHideSel_R(Self: TJvHTComboBox; var T: Boolean);
begin T := Self.HideSel; end;

(*----------------------------------------------------------------------------*)
procedure TJvHTComboBoxPlainItems_R(Self: TJvHTComboBox; var T: string; const t1: Integer);
begin T := Self.PlainItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvHtListBoxHideSel_W(Self: TJvHtListBox; const T: Boolean);
begin Self.HideSel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvHtListBoxHideSel_R(Self: TJvHtListBox; var T: Boolean);
begin T := Self.HideSel; end;

(*----------------------------------------------------------------------------*)
procedure TJvHtListBoxPlainItems_R(Self: TJvHtListBox; var T: string; const t1: Integer);
begin T := Self.PlainItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvHtControls_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ItemHtDrawEx, 'ItemHtDrawEx', cdRegister);
 S.RegisterDelphiFunction(@ItemHtDraw, 'ItemHtDraw', cdRegister);
 S.RegisterDelphiFunction(@ItemHtWidth, 'ItemHtWidth', cdRegister);
 S.RegisterDelphiFunction(@ItemHtPlain, 'ItemHtPlain', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHTLabel(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHTLabel) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHTComboBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHTComboBox) do
  begin
    RegisterPropertyHelper(@TJvHTComboBoxPlainItems_R,nil,'PlainItems');
    RegisterPropertyHelper(@TJvHTComboBoxHideSel_R,@TJvHTComboBoxHideSel_W,'HideSel');
    RegisterPropertyHelper(@TJvHTComboBoxDropWidth_R,@TJvHTComboBoxDropWidth_W,'DropWidth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvHtListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvHtListBox) do
  begin
    RegisterPropertyHelper(@TJvHtListBoxPlainItems_R,nil,'PlainItems');
    RegisterPropertyHelper(@TJvHtListBoxHideSel_R,@TJvHtListBoxHideSel_W,'HideSel');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvHtControls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvHtListBox(CL);
  RIRegister_TJvHTComboBox(CL);
  RIRegister_TJvHTLabel(CL);
end;

 
 
{ TPSImport_JvHtControls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvHtControls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvHtControls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvHtControls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvHtControls(ri);
  RIRegister_JvHtControls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
