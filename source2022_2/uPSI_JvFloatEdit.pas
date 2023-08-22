unit uPSI_JvFloatEdit;
{
  float it form
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
  TPSImport_JvFloatEdit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvFloatEdit(CL: TPSPascalCompiler);
procedure SIRegister_JvFloatEdit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvFloatEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvFloatEdit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,JvTypes
  ,JvEdit
  ,JvFloatEdit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvFloatEdit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvFloatEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvEdit', 'TJvFloatEdit') do
  with CL.AddClassN(CL.FindClass('TJvEdit'),'TJvFloatEdit') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Text', 'string', iptr);
    RegisterProperty('Value', 'Extended', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvFloatEdit(CL: TPSPascalCompiler);
begin
  SIRegister_TJvFloatEdit(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvFloatEditValue_W(Self: TJvFloatEdit; const T: Extended);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvFloatEditValue_R(Self: TJvFloatEdit; var T: Extended);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJvFloatEditText_R(Self: TJvFloatEdit; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvFloatEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvFloatEdit) do begin
    RegisterConstructor(@TJvFloatEdit.Create, 'Create');
    RegisterPropertyHelper(@TJvFloatEditText_R,nil,'Text');
    RegisterPropertyHelper(@TJvFloatEditValue_R,@TJvFloatEditValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvFloatEdit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvFloatEdit(CL);
end;

 
 
{ TPSImport_JvFloatEdit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFloatEdit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvFloatEdit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvFloatEdit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvFloatEdit(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
