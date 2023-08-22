unit uPSI_DebugBox;
{
  form prototyp
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
  TPSImport_DebugBox = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDebugBox(CL: TPSPascalCompiler);
procedure SIRegister_DebugBox(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DebugBox_Routines(S: TPSExec);
procedure RIRegister_TDebugBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_DebugBox(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  //,Messages
  //,Graphics
  //,Controls
  ,Forms
  //,Dialogs
  //,ExtCtrls
  ,StdCtrls
  ,DebugBox
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DebugBox]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDebugBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDebugBox') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDebugBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Add( A : String)');
    RegisterMethod('Procedure Clear');
    RegisterProperty('Caption', 'String', iptrw);
    RegisterProperty('Position', 'TPositions', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('Width', 'Integer', iptrw);
    RegisterProperty('Height', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DebugBox(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPositions', '( poTopLeft, poBottomLeft, poTopRight, poBottomRight )');
  SIRegister_TDebugBox(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDebugBoxHeight_W(Self: TDebugBox; const T: Integer);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxHeight_R(Self: TDebugBox; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxWidth_W(Self: TDebugBox; const T: Integer);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxWidth_R(Self: TDebugBox; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxVisible_W(Self: TDebugBox; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxVisible_R(Self: TDebugBox; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxPosition_W(Self: TDebugBox; const T: TPositions);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxPosition_R(Self: TDebugBox; var T: TPositions);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxCaption_W(Self: TDebugBox; const T: String);
begin Self.Caption := T; end;

(*----------------------------------------------------------------------------*)
procedure TDebugBoxCaption_R(Self: TDebugBox; var T: String);
begin T := Self.Caption; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DebugBox_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDebugBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDebugBox) do begin
    RegisterConstructor(@TDebugBox.Create, 'Create');
    RegisterMethod(@TDebugBox.Add, 'Add');
    RegisterMethod(@TDebugBox.Clear, 'Clear');
    RegisterPropertyHelper(@TDebugBoxCaption_R,@TDebugBoxCaption_W,'Caption');
    RegisterPropertyHelper(@TDebugBoxPosition_R,@TDebugBoxPosition_W,'Position');
    RegisterPropertyHelper(@TDebugBoxVisible_R,@TDebugBoxVisible_W,'Visible');
    RegisterPropertyHelper(@TDebugBoxWidth_R,@TDebugBoxWidth_W,'Width');
    RegisterPropertyHelper(@TDebugBoxHeight_R,@TDebugBoxHeight_W,'Height');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DebugBox(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDebugBox(CL);
end;

 
 
{ TPSImport_DebugBox }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DebugBox.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DebugBox(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DebugBox.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DebugBox(ri);
  RIRegister_DebugBox_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
