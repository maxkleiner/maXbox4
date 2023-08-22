unit uPSI_Numedit;
{
a last piece to trap the map     - add change  and value

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
  TPSImport_Numedit = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNumEdit(CL: TPSPascalCompiler);
procedure SIRegister_Numedit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Numedit_Routines(S: TPSExec);
procedure RIRegister_TNumEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_Numedit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StdCtrls
  ,Numedit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Numedit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNumEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEdit', 'TNumEdit') do
  with CL.AddClassN(CL.FindClass('TEdit'),'TNumEdit') do
  begin
    RegisterProperty('HasValidNumber', 'boolean', iptrw);
    RegisterProperty('RealValue', 'real', iptrw);
    RegisterProperty('Value', 'real', iptrw);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure KeyPress( var Key : Char)');
    RegisterMethod('procedure Change;');
    //procedure Change; override;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Numedit(CL: TPSPascalCompiler);
begin
  SIRegister_TNumEdit(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TNumEditRealValue_W(Self: TNumEdit; const T: real);
Begin Self.RealValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TNumEditRealValue_R(Self: TNumEdit; var T: real);
Begin T := Self.RealValue; end;

(*----------------------------------------------------------------------------*)
procedure TNumEditHasValidNumber_W(Self: TNumEdit; const T: boolean);
Begin Self.HasValidNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TNumEditHasValidNumber_R(Self: TNumEdit; var T: boolean);
Begin T := Self.HasValidNumber; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Numedit_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNumEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNumEdit) do
  begin
    RegisterPropertyHelper(@TNumEditHasValidNumber_R,@TNumEditHasValidNumber_W,'HasValidNumber');
    RegisterPropertyHelper(@TNumEditRealValue_R,@TNumEditRealValue_W,'RealValue');
     RegisterPropertyHelper(@TNumEditRealValue_R,@TNumEditRealValue_W,'Value');  //alias
    RegisterConstructor(@TNumEdit.Create, 'Create');
    RegisterMethod(@TNumEdit.KeyPress, 'KeyPress');
    RegisterMethod(@TNumEdit.Change, 'Change');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Numedit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNumEdit(CL);
end;

 
 
{ TPSImport_Numedit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Numedit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Numedit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Numedit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Numedit(ri);
  RIRegister_Numedit_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
