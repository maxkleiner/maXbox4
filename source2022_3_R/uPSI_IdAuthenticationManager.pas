unit uPSI_IdAuthenticationManager;
{
auzh man

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
  TPSImport_IdAuthenticationManager = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdAuthenticationManager(CL: TPSPascalCompiler);
procedure SIRegister_TIdAuthenticationCollection(CL: TPSPascalCompiler);
procedure SIRegister_TIdAuthenticationItem(CL: TPSPascalCompiler);
procedure SIRegister_IdAuthenticationManager(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdAuthenticationManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdAuthenticationCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdAuthenticationItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdAuthenticationManager(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAuthentication
  ,IdURI
  ,IdGlobal
  ,IdBaseComponent
  ,IdAuthenticationManager
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdAuthenticationManager]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdAuthenticationManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdAuthenticationManager') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdAuthenticationManager') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
         RegisterMethod('Procedure Free');
      RegisterMethod('Procedure AddAuthentication( AAuthtetication : TIdAuthentication; AURL : TIdURI)');
    RegisterProperty('Authentications', 'TIdAuthenticationCollection', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdAuthenticationCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TIdAuthenticationCollection') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TIdAuthenticationCollection') do
  begin
    RegisterMethod('Constructor Create( AOwner : Tpersistent)');
    RegisterMethod('Function Add : TIdAuthenticationItem');
    RegisterProperty('Items', 'TIdAuthenticationItem Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdAuthenticationItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TIdAuthenticationItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TIdAuthenticationItem') do begin
    RegisterMethod('Constructor Create( ACollection : TCOllection)');
         RegisterMethod('Procedure Free');
      RegisterProperty('URL', 'TIdURI', iptrw);
    RegisterProperty('Params', 'TStringList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdAuthenticationManager(CL: TPSPascalCompiler);
begin
  SIRegister_TIdAuthenticationItem(CL);
  SIRegister_TIdAuthenticationCollection(CL);
  SIRegister_TIdAuthenticationManager(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationManagerAuthentications_R(Self: TIdAuthenticationManager; var T: TIdAuthenticationCollection);
begin T := Self.Authentications; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationCollectionItems_W(Self: TIdAuthenticationCollection; const T: TIdAuthenticationItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationCollectionItems_R(Self: TIdAuthenticationCollection; var T: TIdAuthenticationItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationItemParams_W(Self: TIdAuthenticationItem; const T: TStringList);
begin Self.Params := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationItemParams_R(Self: TIdAuthenticationItem; var T: TStringList);
begin T := Self.Params; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationItemURL_W(Self: TIdAuthenticationItem; const T: TIdURI);
begin Self.URL := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAuthenticationItemURL_R(Self: TIdAuthenticationItem; var T: TIdURI);
begin T := Self.URL; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdAuthenticationManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdAuthenticationManager) do begin
    RegisterConstructor(@TIdAuthenticationManager.Create, 'Create');
             RegisterMethod(@TIdAuthenticationManager.Destroy, 'Free');
     RegisterMethod(@TIdAuthenticationManager.AddAuthentication, 'AddAuthentication');
    RegisterPropertyHelper(@TIdAuthenticationManagerAuthentications_R,nil,'Authentications');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdAuthenticationCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdAuthenticationCollection) do
  begin
    RegisterConstructor(@TIdAuthenticationCollection.Create, 'Create');
    RegisterMethod(@TIdAuthenticationCollection.Add, 'Add');
    RegisterPropertyHelper(@TIdAuthenticationCollectionItems_R,@TIdAuthenticationCollectionItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdAuthenticationItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdAuthenticationItem) do begin
    RegisterConstructor(@TIdAuthenticationItem.Create, 'Create');
             RegisterMethod(@TIdAuthenticationItem.Destroy, 'Free');

    RegisterPropertyHelper(@TIdAuthenticationItemURL_R,@TIdAuthenticationItemURL_W,'URL');
    RegisterPropertyHelper(@TIdAuthenticationItemParams_R,@TIdAuthenticationItemParams_W,'Params');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdAuthenticationManager(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdAuthenticationItem(CL);
  RIRegister_TIdAuthenticationCollection(CL);
  RIRegister_TIdAuthenticationManager(CL);
end;

 
 
{ TPSImport_IdAuthenticationManager }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdAuthenticationManager.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdAuthenticationManager(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdAuthenticationManager.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdAuthenticationManager(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
