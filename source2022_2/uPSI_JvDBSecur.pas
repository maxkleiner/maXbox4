unit uPSI_JvDBSecur;
{
     on SQL
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
  TPSImport_JvDBSecur = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvDBSecurity(CL: TPSPascalCompiler);
procedure SIRegister_JvDBSecur(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvDBSecurity(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvDBSecur(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,DBTables
  ,JvxLogin
  ,JvxLoginDlg
  ,JvChPswDlg
  ,JvDBSecur
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvDBSecur]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvDBSecurity(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvCustomLogin', 'TJvDBSecurity') do
  with CL.AddClassN(CL.FindClass('TJvCustomLogin'),'TJvDBSecurity') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function ChangePassword : Boolean');
    RegisterProperty('Database', 'TDatabase', iptrw);
    RegisterProperty('LoginNameField', 'string', iptrw);
    RegisterProperty('SelectAlias', 'Boolean', iptrw);
    RegisterProperty('UsersTableName', 'TFileName', iptrw);
    RegisterProperty('OnCheckUser', 'TCheckUserEvent', iptrw);
    RegisterProperty('OnChangePassword', 'TChangePasswordEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvDBSecur(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCheckUserEvent','Function(UsersTable: TTable;const Password: string): Boolean');
  SIRegister_TJvDBSecurity(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityOnChangePassword_W(Self: TJvDBSecurity; const T: TChangePasswordEvent);
begin Self.OnChangePassword := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityOnChangePassword_R(Self: TJvDBSecurity; var T: TChangePasswordEvent);
begin T := Self.OnChangePassword; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityOnCheckUser_W(Self: TJvDBSecurity; const T: TCheckUserEvent);
begin Self.OnCheckUser := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityOnCheckUser_R(Self: TJvDBSecurity; var T: TCheckUserEvent);
begin T := Self.OnCheckUser; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityUsersTableName_W(Self: TJvDBSecurity; const T: TFileName);
begin Self.UsersTableName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityUsersTableName_R(Self: TJvDBSecurity; var T: TFileName);
begin T := Self.UsersTableName; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecuritySelectAlias_W(Self: TJvDBSecurity; const T: Boolean);
begin Self.SelectAlias := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecuritySelectAlias_R(Self: TJvDBSecurity; var T: Boolean);
begin T := Self.SelectAlias; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityLoginNameField_W(Self: TJvDBSecurity; const T: string);
begin Self.LoginNameField := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityLoginNameField_R(Self: TJvDBSecurity; var T: string);
begin T := Self.LoginNameField; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityDatabase_W(Self: TJvDBSecurity; const T: TDatabase);
begin Self.Database := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvDBSecurityDatabase_R(Self: TJvDBSecurity; var T: TDatabase);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvDBSecurity(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvDBSecurity) do begin
    RegisterConstructor(@TJvDBSecurity.Create, 'Create');
    RegisterMethod(@TJvDBSecurity.Destroy, 'Free');
    RegisterMethod(@TJvDBSecurity.ChangePassword, 'ChangePassword');
    RegisterPropertyHelper(@TJvDBSecurityDatabase_R,@TJvDBSecurityDatabase_W,'Database');
    RegisterPropertyHelper(@TJvDBSecurityLoginNameField_R,@TJvDBSecurityLoginNameField_W,'LoginNameField');
    RegisterPropertyHelper(@TJvDBSecuritySelectAlias_R,@TJvDBSecuritySelectAlias_W,'SelectAlias');
    RegisterPropertyHelper(@TJvDBSecurityUsersTableName_R,@TJvDBSecurityUsersTableName_W,'UsersTableName');
    RegisterPropertyHelper(@TJvDBSecurityOnCheckUser_R,@TJvDBSecurityOnCheckUser_W,'OnCheckUser');
    RegisterPropertyHelper(@TJvDBSecurityOnChangePassword_R,@TJvDBSecurityOnChangePassword_W,'OnChangePassword');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvDBSecur(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvDBSecurity(CL);
end;

 
 
{ TPSImport_JvDBSecur }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBSecur.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvDBSecur(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvDBSecur.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvDBSecur(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
