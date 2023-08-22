unit uPSI_DBLogDlg;
{
DB Enhanced
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
  TPSImport_DBLogDlg = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLoginDialog(CL: TPSPascalCompiler);
procedure SIRegister_DBLogDlg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DBLogDlg_Routines(S: TPSExec);
procedure RIRegister_TLoginDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_DBLogDlg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,StdCtrls
  ,ExtCtrls
  ,DB
  ,DBLogDlg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DBLogDlg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLoginDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TLoginDialog') do
  with CL.AddClassN(CL.FindClass('TForm'),'TLoginDialog') do begin
    RegisterProperty('Panel', 'TPanel', iptrw);
    RegisterProperty('Bevel', 'TBevel', iptrw);
    RegisterProperty('DatabaseName', 'TLabel', iptrw);
    RegisterProperty('OKButton', 'TButton', iptrw);
    RegisterProperty('CancelButton', 'TButton', iptrw);
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterProperty('Password', 'TEdit', iptrw);
    RegisterProperty('UserName', 'TEdit', iptrw);
    RegisterMethod('Procedure FormShow( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DBLogDlg(CL: TPSPascalCompiler);
begin
  SIRegister_TLoginDialog(CL);
 CL.AddDelphiFunction('Function LoginDialog( const ADatabaseName : string; var AUserName, APassword : string) : Boolean');
 CL.AddDelphiFunction('Function LoginDialogEx( const ADatabaseName : string; var AUserName, APassword : string; NameReadOnly : Boolean) : Boolean');
 CL.AddDelphiFunction('Function RemoteLoginDialog( var AUserName, APassword : string) : Boolean');
 CL.AddDelphiFunction('Procedure SetCursorType( const CurIndex : Integer)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLoginDialogUserName_W(Self: TLoginDialog; const T: TEdit);
Begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogUserName_R(Self: TLoginDialog; var T: TEdit);
Begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogPassword_W(Self: TLoginDialog; const T: TEdit);
Begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogPassword_R(Self: TLoginDialog; var T: TEdit);
Begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogLabel3_W(Self: TLoginDialog; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogLabel3_R(Self: TLoginDialog; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogLabel2_W(Self: TLoginDialog; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogLabel2_R(Self: TLoginDialog; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogLabel1_W(Self: TLoginDialog; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogLabel1_R(Self: TLoginDialog; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogPanel1_W(Self: TLoginDialog; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogPanel1_R(Self: TLoginDialog; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogCancelButton_W(Self: TLoginDialog; const T: TButton);
Begin Self.CancelButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogCancelButton_R(Self: TLoginDialog; var T: TButton);
Begin T := Self.CancelButton; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogOKButton_W(Self: TLoginDialog; const T: TButton);
Begin Self.OKButton := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogOKButton_R(Self: TLoginDialog; var T: TButton);
Begin T := Self.OKButton; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogDatabaseName_W(Self: TLoginDialog; const T: TLabel);
Begin Self.DatabaseName := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogDatabaseName_R(Self: TLoginDialog; var T: TLabel);
Begin T := Self.DatabaseName; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogBevel_W(Self: TLoginDialog; const T: TBevel);
Begin Self.Bevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogBevel_R(Self: TLoginDialog; var T: TBevel);
Begin T := Self.Bevel; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogPanel_W(Self: TLoginDialog; const T: TPanel);
Begin Self.Panel := T; end;

(*----------------------------------------------------------------------------*)
procedure TLoginDialogPanel_R(Self: TLoginDialog; var T: TPanel);
Begin T := Self.Panel; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBLogDlg_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LoginDialog, 'LoginDialog', cdRegister);
 S.RegisterDelphiFunction(@LoginDialogEx, 'LoginDialogEx', cdRegister);
 S.RegisterDelphiFunction(@RemoteLoginDialog, 'RemoteLoginDialog', cdRegister);
 S.RegisterDelphiFunction(@SetCursorType, 'SetCursorType', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLoginDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLoginDialog) do begin
    RegisterPropertyHelper(@TLoginDialogPanel_R,@TLoginDialogPanel_W,'Panel');
    RegisterPropertyHelper(@TLoginDialogBevel_R,@TLoginDialogBevel_W,'Bevel');
    RegisterPropertyHelper(@TLoginDialogDatabaseName_R,@TLoginDialogDatabaseName_W,'DatabaseName');
    RegisterPropertyHelper(@TLoginDialogOKButton_R,@TLoginDialogOKButton_W,'OKButton');
    RegisterPropertyHelper(@TLoginDialogCancelButton_R,@TLoginDialogCancelButton_W,'CancelButton');
    RegisterPropertyHelper(@TLoginDialogPanel1_R,@TLoginDialogPanel1_W,'Panel1');
    RegisterPropertyHelper(@TLoginDialogLabel1_R,@TLoginDialogLabel1_W,'Label1');
    RegisterPropertyHelper(@TLoginDialogLabel2_R,@TLoginDialogLabel2_W,'Label2');
    RegisterPropertyHelper(@TLoginDialogLabel3_R,@TLoginDialogLabel3_W,'Label3');
    RegisterPropertyHelper(@TLoginDialogPassword_R,@TLoginDialogPassword_W,'Password');
    RegisterPropertyHelper(@TLoginDialogUserName_R,@TLoginDialogUserName_W,'UserName');
    RegisterMethod(@TLoginDialog.FormShow, 'FormShow');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DBLogDlg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TLoginDialog(CL);
end;

 
 
{ TPSImport_DBLogDlg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBLogDlg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DBLogDlg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DBLogDlg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DBLogDlg(ri);
  RIRegister_DBLogDlg_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
