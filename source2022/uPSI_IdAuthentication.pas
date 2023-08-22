unit uPSI_IdAuthentication;
{
  constructor
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
  TPSImport_IdAuthentication = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdBasicAuthentication(CL: TPSPascalCompiler);
procedure SIRegister_TIdAuthentication(CL: TPSPascalCompiler);
procedure SIRegister_IdAuthentication(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_IdAuthentication_Routines(S: TPSExec);
procedure RIRegister_TIdBasicAuthentication(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdAuthentication(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdAuthentication(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdHeaderList
  ,IdGlobal
  ,IdException
  ,IdAuthentication
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdAuthentication]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdBasicAuthentication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdAuthentication', 'TIdBasicAuthentication') do
  with CL.AddClassN(CL.FindClass('TIdAuthentication'),'TIdBasicAuthentication') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Function Authentication : String');
    RegisterMethod('Function KeepAlive : Boolean');
    RegisterMethod('Procedure Reset');
    RegisterProperty('Realm', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdAuthentication(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIdAuthentication') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIdAuthentication') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Function Authentication : String');
    RegisterMethod('Function KeepAlive : Boolean');
    RegisterMethod('Function Next : TIdAuthWhatsNext');
    RegisterProperty('AuthRetries', 'Integer', iptr);
    RegisterProperty('AuthParams', 'TIdHeaderList', iptrw);
    RegisterProperty('Params', 'TIdHeaderList', iptr);
    RegisterProperty('Username', 'String', iptrw);
    RegisterProperty('Password', 'String', iptrw);
    RegisterProperty('Steps', 'Integer', iptr);
    RegisterProperty('CurrentStep', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdAuthentication(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdAuthenticationSchemes', '( asBasic, asDigest, asNTLM, asUnknown )');
  CL.AddTypeS('TIdAuthSchemeSet', 'set of TIdAuthenticationSchemes');
  CL.AddTypeS('TIdAuthWhatsNext', '( wnAskTheProgram, wnDoRequest, wnFail )');
  SIRegister_TIdAuthentication(CL);
  CL.AddClassN(CL.FindClass('Class of TIdAuthentication'),'TIdAuthenticationClass');   //3.8
  //CL.AddTypeS('TIdAuthenticationClass', 'class of TIdAuthentication');
  //CL.AddTypeS('TIdAuthenticationClass', 'class of TIdAuthentication');
  SIRegister_TIdBasicAuthentication(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdAlreadyRegisteredAuthenticationMethod');
 CL.AddDelphiFunction('Procedure RegisterAuthenticationMethod( MethodName : String; AuthClass : TIdAuthenticationClass)');
 CL.AddDelphiFunction('Function FindAuthClass( AuthName : String) : TIdAuthenticationClass');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdBasicAuthenticationRealm_W(Self: TIdBasicAuthentication; const T: String);
begin Self.Realm := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdBasicAuthenticationRealm_R(Self: TIdBasicAuthentication; var T: String);
begin T := Self.Realm; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationCurrentStep_R(Self: TIdAuthentication; var T: Integer);
begin T := Self.CurrentStep; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationSteps_R(Self: TIdAuthentication; var T: Integer);
begin T := Self.Steps; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationPassword_W(Self: TIdAuthentication; const T: String);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationPassword_R(Self: TIdAuthentication; var T: String);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationUsername_W(Self: TIdAuthentication; const T: String);
begin Self.Username := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationUsername_R(Self: TIdAuthentication; var T: String);
begin T := Self.Username; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationParams_R(Self: TIdAuthentication; var T: TIdHeaderList);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationAuthParams_W(Self: TIdAuthentication; const T: TIdHeaderList);
begin Self.AuthParams := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationAuthParams_R(Self: TIdAuthentication; var T: TIdHeaderList);
begin T := Self.AuthParams; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationAuthRetries_R(Self: TIdAuthentication; var T: Integer);
begin T := Self.AuthRetries; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdAuthentication_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RegisterAuthenticationMethod, 'RegisterAuthenticationMethod', cdRegister);
 S.RegisterDelphiFunction(@FindAuthClass, 'FindAuthClass', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdBasicAuthentication(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdBasicAuthentication) do begin
    RegisterConstructor(@TIdBasicAuthentication.Create, 'Create');
    RegisterMethod(@TIdBasicAuthentication.Destroy, 'Free');
    RegisterMethod(@TIdBasicAuthentication.Authentication, 'Authentication');
    RegisterMethod(@TIdBasicAuthentication.KeepAlive, 'KeepAlive');
    RegisterMethod(@TIdBasicAuthentication.Reset, 'Reset');
    RegisterPropertyHelper(@TIdBasicAuthenticationRealm_R,@TIdBasicAuthenticationRealm_W,'Realm');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdAuthentication(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdAuthentication) do begin
    RegisterConstructor(@TIdAuthentication.Create, 'Create');
    RegisterMethod(@TIdAuthentication.Destroy, 'Free');
    RegisterVirtualMethod(@TIdAuthentication.Reset, 'Reset');
    //RegisterVirtualAbstractMethod(@TIdAuthentication, @!.Authentication, 'Authentication');
    //RegisterVirtualAbstractMethod(@TIdAuthentication, @!.KeepAlive, 'KeepAlive');
    RegisterMethod(@TIdAuthentication.Next, 'Next');
    RegisterPropertyHelper(@TIdAuthenticationAuthRetries_R,nil,'AuthRetries');
    RegisterPropertyHelper(@TIdAuthenticationAuthParams_R,@TIdAuthenticationAuthParams_W,'AuthParams');
    RegisterPropertyHelper(@TIdAuthenticationParams_R,nil,'Params');
    RegisterPropertyHelper(@TIdAuthenticationUsername_R,@TIdAuthenticationUsername_W,'Username');
    RegisterPropertyHelper(@TIdAuthenticationPassword_R,@TIdAuthenticationPassword_W,'Password');
    RegisterPropertyHelper(@TIdAuthenticationSteps_R,nil,'Steps');
    RegisterPropertyHelper(@TIdAuthenticationCurrentStep_R,nil,'CurrentStep');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdAuthentication(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdAuthentication(CL);
  RIRegister_TIdBasicAuthentication(CL);
  with CL.Add(EIdAlreadyRegisteredAuthenticationMethod) do
end;

 
 
{ TPSImport_IdAuthentication }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdAuthentication.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdAuthentication(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdAuthentication.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdAuthentication(ri);
  RIRegister_IdAuthentication_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
