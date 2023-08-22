unit uPSI_IdUserAccounts;
{

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
  TPSImport_IdUserAccounts = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TIdUserManager(CL: TPSPascalCompiler);
procedure SIRegister_TIdUserAccounts(CL: TPSPascalCompiler);
procedure SIRegister_TIdUserAccount(CL: TPSPascalCompiler);
procedure SIRegister_IdUserAccounts(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdUserManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdUserAccounts(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdUserAccount(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdUserAccounts(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdException
  ,IdGlobal
  ,IdBaseComponent
  ,IdComponent
  ,IdStrings
  ,IdUserAccounts
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdUserAccounts]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdUserManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdUserManager') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdUserManager') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
    RegisterMethod('Function AuthenticateUser( const AUsername, APassword : String) : Boolean');
    RegisterProperty('Accounts', 'TIdUserAccounts', iptrw);
    RegisterProperty('CaseSensitiveUsernames', 'Boolean', iptrw);
    RegisterProperty('CaseSensitivePasswords', 'Boolean', iptrw);
    RegisterProperty('OnAfterAuthentication', 'TOnAfterAuthentication', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdUserAccounts(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TIdUserAccounts') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TIdUserAccounts') do
  begin
    RegisterMethod('Function Add : TIdUserAccount');
    RegisterMethod('Constructor Create( AOwner : TIdUserManager)');
    RegisterProperty('CaseSensitiveUsernames', 'Boolean', iptrw);
    RegisterProperty('CaseSensitivePasswords', 'Boolean', iptrw);
    RegisterProperty('UserNames', 'TIdUserAccount String', iptr);
    SetDefaultPropery('UserNames');
    RegisterProperty('Items', 'TIdUserAccount Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdUserAccount(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdUserAccount') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdUserAccount') do
  begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterMethod('Function CheckPassword( const APassword : String) : Boolean');
    RegisterProperty('Data', 'TObject', iptrw);
    RegisterProperty('Attributes', 'Tstrings', iptrw);
    RegisterProperty('UserName', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('RealName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdUserAccounts(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TIdUserManager');
  SIRegister_TIdUserAccount(CL);
  SIRegister_TIdUserAccounts(CL);
  CL.AddTypeS('TOnAfterAuthentication', 'Procedure ( const AUsername : String; '
   +'const APassword : String; AAuthenticationResult : Boolean)');
  SIRegister_TIdUserManager(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdUserManagerOnAfterAuthentication_W(Self: TIdUserManager; const T: TOnAfterAuthentication);
begin Self.OnAfterAuthentication := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserManagerOnAfterAuthentication_R(Self: TIdUserManager; var T: TOnAfterAuthentication);
begin T := Self.OnAfterAuthentication; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserManagerCaseSensitivePasswords_W(Self: TIdUserManager; const T: Boolean);
begin Self.CaseSensitivePasswords := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserManagerCaseSensitivePasswords_R(Self: TIdUserManager; var T: Boolean);
begin T := Self.CaseSensitivePasswords; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserManagerCaseSensitiveUsernames_W(Self: TIdUserManager; const T: Boolean);
begin Self.CaseSensitiveUsernames := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserManagerCaseSensitiveUsernames_R(Self: TIdUserManager; var T: Boolean);
begin T := Self.CaseSensitiveUsernames; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserManagerAccounts_W(Self: TIdUserManager; const T: TIdUserAccounts);
begin Self.Accounts := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserManagerAccounts_R(Self: TIdUserManager; var T: TIdUserAccounts);
begin T := Self.Accounts; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountsItems_W(Self: TIdUserAccounts; const T: TIdUserAccount; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountsItems_R(Self: TIdUserAccounts; var T: TIdUserAccount; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountsUserNames_R(Self: TIdUserAccounts; var T: TIdUserAccount; const t1: String);
begin T := Self.UserNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountsCaseSensitivePasswords_W(Self: TIdUserAccounts; const T: Boolean);
begin Self.CaseSensitivePasswords := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountsCaseSensitivePasswords_R(Self: TIdUserAccounts; var T: Boolean);
begin T := Self.CaseSensitivePasswords; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountsCaseSensitiveUsernames_W(Self: TIdUserAccounts; const T: Boolean);
begin Self.CaseSensitiveUsernames := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountsCaseSensitiveUsernames_R(Self: TIdUserAccounts; var T: Boolean);
begin T := Self.CaseSensitiveUsernames; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountRealName_W(Self: TIdUserAccount; const T: string);
begin Self.RealName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountRealName_R(Self: TIdUserAccount; var T: string);
begin T := Self.RealName; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountPassword_W(Self: TIdUserAccount; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountPassword_R(Self: TIdUserAccount; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountUserName_W(Self: TIdUserAccount; const T: string);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountUserName_R(Self: TIdUserAccount; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountAttributes_W(Self: TIdUserAccount; const T: Tstrings);
begin Self.Attributes := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountAttributes_R(Self: TIdUserAccount; var T: Tstrings);
begin T := Self.Attributes; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountData_W(Self: TIdUserAccount; const T: TObject);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdUserAccountData_R(Self: TIdUserAccount; var T: TObject);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdUserManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUserManager) do begin
    RegisterMethod(@TIdUserAccount.Create, 'Create');
    RegisterConstructor(@TIdUserAccount.Create, 'Create');
    RegisterPropertyHelper(@TIdUserManagerAccounts_R,@TIdUserManagerAccounts_W,'Accounts');
    RegisterPropertyHelper(@TIdUserManagerCaseSensitiveUsernames_R,@TIdUserManagerCaseSensitiveUsernames_W,'CaseSensitiveUsernames');
    RegisterPropertyHelper(@TIdUserManagerCaseSensitivePasswords_R,@TIdUserManagerCaseSensitivePasswords_W,'CaseSensitivePasswords');
    RegisterPropertyHelper(@TIdUserManagerOnAfterAuthentication_R,@TIdUserManagerOnAfterAuthentication_W,'OnAfterAuthentication');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdUserAccounts(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUserAccounts) do
  begin
    RegisterMethod(@TIdUserAccounts.Add, 'Add');
    RegisterConstructor(@TIdUserAccounts.Create, 'Create');
    RegisterPropertyHelper(@TIdUserAccountsCaseSensitiveUsernames_R,@TIdUserAccountsCaseSensitiveUsernames_W,'CaseSensitiveUsernames');
    RegisterPropertyHelper(@TIdUserAccountsCaseSensitivePasswords_R,@TIdUserAccountsCaseSensitivePasswords_W,'CaseSensitivePasswords');
    RegisterPropertyHelper(@TIdUserAccountsUserNames_R,nil,'UserNames');
    RegisterPropertyHelper(@TIdUserAccountsItems_R,@TIdUserAccountsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdUserAccount(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUserAccount) do
  begin
    RegisterConstructor(@TIdUserAccount.Create, 'Create');
    RegisterMethod(@TIdUserAccount.CheckPassword, 'CheckPassword');
    RegisterPropertyHelper(@TIdUserAccountData_R,@TIdUserAccountData_W,'Data');
    RegisterPropertyHelper(@TIdUserAccountAttributes_R,@TIdUserAccountAttributes_W,'Attributes');
    RegisterPropertyHelper(@TIdUserAccountUserName_R,@TIdUserAccountUserName_W,'UserName');
    RegisterPropertyHelper(@TIdUserAccountPassword_R,@TIdUserAccountPassword_W,'Password');
    RegisterPropertyHelper(@TIdUserAccountRealName_R,@TIdUserAccountRealName_W,'RealName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdUserAccounts(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdUserManager) do
  RIRegister_TIdUserAccount(CL);
  RIRegister_TIdUserAccounts(CL);
  RIRegister_TIdUserManager(CL);
end;

 
 
{ TPSImport_IdUserAccounts }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdUserAccounts.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdUserAccounts(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdUserAccounts.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdUserAccounts(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
