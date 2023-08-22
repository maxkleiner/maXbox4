unit uPSI_AESPassWordDlg;
{
for AES and other crypt
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
  TPSImport_AESPassWordDlg = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPasswordDlg(CL: TPSPascalCompiler);
procedure SIRegister_AESPassWordDlg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPasswordDlg(CL: TPSRuntimeClassImporter);
procedure RIRegister_AESPassWordDlg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Forms
  ,Controls
  ,StdCtrls
  ,Buttons
  ,AESPassWordDlg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AESPassWordDlg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPasswordDlg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TPasswordDlg') do
  with CL.AddClassN(CL.FindClass('TForm'),'TPasswordDlg') do begin
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Password', 'TEdit', iptrw);
    RegisterProperty('OKBtn', 'TButton', iptrw);
    RegisterProperty('CancelBtn', 'TButton', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AESPassWordDlg(CL: TPSPascalCompiler);
begin
  SIRegister_TPasswordDlg(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPasswordDlgCancelBtn_W(Self: TPasswordDlg; const T: TButton);
Begin Self.CancelBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TPasswordDlgCancelBtn_R(Self: TPasswordDlg; var T: TButton);
Begin T := Self.CancelBtn; end;

(*----------------------------------------------------------------------------*)
procedure TPasswordDlgOKBtn_W(Self: TPasswordDlg; const T: TButton);
Begin Self.OKBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TPasswordDlgOKBtn_R(Self: TPasswordDlg; var T: TButton);
Begin T := Self.OKBtn; end;

(*----------------------------------------------------------------------------*)
procedure TPasswordDlgPassword_W(Self: TPasswordDlg; const T: TEdit);
Begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TPasswordDlgPassword_R(Self: TPasswordDlg; var T: TEdit);
Begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TPasswordDlgLabel1_W(Self: TPasswordDlg; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPasswordDlgLabel1_R(Self: TPasswordDlg; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPasswordDlg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPasswordDlg) do
  begin
    RegisterPropertyHelper(@TPasswordDlgLabel1_R,@TPasswordDlgLabel1_W,'Label1');
    RegisterPropertyHelper(@TPasswordDlgPassword_R,@TPasswordDlgPassword_W,'Password');
    RegisterPropertyHelper(@TPasswordDlgOKBtn_R,@TPasswordDlgOKBtn_W,'OKBtn');
    RegisterPropertyHelper(@TPasswordDlgCancelBtn_R,@TPasswordDlgCancelBtn_W,'CancelBtn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AESPassWordDlg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPasswordDlg(CL);
end;

 
 
{ TPSImport_AESPassWordDlg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AESPassWordDlg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AESPassWordDlg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AESPassWordDlg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AESPassWordDlg(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
