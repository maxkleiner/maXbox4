unit uPSI_ODBC;
{
   at runtime set
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
  TPSImport_ODBC = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TODBC(CL: TPSPascalCompiler);
procedure SIRegister_ODBC(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ODBC_Routines(S: TPSExec);
procedure RIRegister_TODBC(CL: TPSRuntimeClassImporter);
procedure RIRegister_ODBC(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ODBC
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ODBC]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TODBC(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TODBC') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TODBC') do begin
    RegisterMethod('Procedure CompactDbForAccess');
    RegisterMethod('Procedure CreateDbForAccess');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterProperty('ODBCError', 'String', iptr);
    RegisterProperty('ODBCSourceType', 'FSrcTypeEx', iptrw);
    RegisterProperty('DatabaseFileName', 'string', iptrw);
    RegisterProperty('Description', 'string', iptrw);
    RegisterProperty('DSNName', 'string', iptrw);
    RegisterProperty('Apply', 'FApplyEx', iptrw);
    RegisterProperty('ODBCAction', 'FODBCActionEx', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ODBC(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('FApplyEx', '( False, True )');
  CL.AddTypeS('FODBCActionEx', '( ODBC_ADD_DSN, ODBC_CONFIG_DSN, ODBC_REMOVE_DS'
   +'N, ODBC_ADD_SYS_DSN, ODBC_CONFIG_SYS_DSN, ODBC_REMOVE_SYS_DSN )');
  CL.AddTypeS('FSrcTypeEx', '( Access, dBase, Paradox, Excel, FoxPro )');
  SIRegister_TODBC(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TODBCODBCAction_W(Self: TODBC; const T: FODBCActionEx);
begin Self.ODBCAction := T; end;

(*----------------------------------------------------------------------------*)
procedure TODBCODBCAction_R(Self: TODBC; var T: FODBCActionEx);
begin T := Self.ODBCAction; end;

(*----------------------------------------------------------------------------*)
procedure TODBCApply_W(Self: TODBC; const T: FApplyEx);
begin Self.Apply := T; end;

(*----------------------------------------------------------------------------*)
procedure TODBCApply_R(Self: TODBC; var T: FApplyEx);
begin T := Self.Apply; end;

(*----------------------------------------------------------------------------*)
procedure TODBCDSNName_W(Self: TODBC; const T: string);
begin Self.DSNName := T; end;

(*----------------------------------------------------------------------------*)
procedure TODBCDSNName_R(Self: TODBC; var T: string);
begin T := Self.DSNName; end;

(*----------------------------------------------------------------------------*)
procedure TODBCDescription_W(Self: TODBC; const T: string);
begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TODBCDescription_R(Self: TODBC; var T: string);
begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TODBCDatabaseFileName_W(Self: TODBC; const T: string);
begin Self.DatabaseFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TODBCDatabaseFileName_R(Self: TODBC; var T: string);
begin T := Self.DatabaseFileName; end;

(*----------------------------------------------------------------------------*)
procedure TODBCODBCSourceType_W(Self: TODBC; const T: FSrcTypeEx);
begin Self.ODBCSourceType := T; end;

(*----------------------------------------------------------------------------*)
procedure TODBCODBCSourceType_R(Self: TODBC; var T: FSrcTypeEx);
begin T := Self.ODBCSourceType; end;

(*----------------------------------------------------------------------------*)
procedure TODBCODBCError_R(Self: TODBC; var T: String);
begin T := Self.ODBCError; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ODBC_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TODBC(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TODBC) do begin
    RegisterMethod(@TODBC.CompactDbForAccess, 'CompactDbForAccess');
    RegisterMethod(@TODBC.CreateDbForAccess, 'CreateDbForAccess');
    RegisterConstructor(@TODBC.Create, 'Create');
     RegisterMethod(@TODBC.Destroy, 'Free');
      RegisterPropertyHelper(@TODBCODBCError_R,nil,'ODBCError');
    RegisterPropertyHelper(@TODBCODBCSourceType_R,@TODBCODBCSourceType_W,'ODBCSourceType');
    RegisterPropertyHelper(@TODBCDatabaseFileName_R,@TODBCDatabaseFileName_W,'DatabaseFileName');
    RegisterPropertyHelper(@TODBCDescription_R,@TODBCDescription_W,'Description');
    RegisterPropertyHelper(@TODBCDSNName_R,@TODBCDSNName_W,'DSNName');
    RegisterPropertyHelper(@TODBCApply_R,@TODBCApply_W,'Apply');
    RegisterPropertyHelper(@TODBCODBCAction_R,@TODBCODBCAction_W,'ODBCAction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ODBC(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TODBC(CL);
end;

 
 
{ TPSImport_ODBC }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ODBC.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ODBC(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ODBC.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ODBC(ri);
  RIRegister_ODBC_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
