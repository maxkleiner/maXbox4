unit uPSI_ZConnection;
{
T   Z

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
  TPSImport_ZConnection = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TZConnection(CL: TPSPascalCompiler);
procedure SIRegister_ZConnection(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TZConnection(CL: TPSRuntimeClassImporter);
procedure RIRegister_ZConnection(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // ZAbstractConnection
  ZClasses
  ,ZConnection
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ZConnection]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TZConnection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractConnection', 'TZConnection') do
  with CL.AddClassN(CL.FindClass('TZAbstractConnection'),'TZConnection') do
  begin
    RegisterProperty('HostName', 'string', iptrw);
    RegisterProperty('Port', 'Integer', iptrw);
    RegisterProperty('Database', 'string', iptrw);
    RegisterProperty('User', 'string', iptrw);
    RegisterProperty('Password', 'string', iptrw);
    RegisterProperty('Protocol', 'string', iptrw);
    RegisterProperty('Catalog', 'string', iptrw);
    RegisterProperty('LibraryLocation', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ZConnection(CL: TPSPascalCompiler);
begin
  SIRegister_TZConnection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TZConnectionLibraryLocation_W(Self: TZConnection; const T: String);
begin Self.LibraryLocation := T; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionLibraryLocation_R(Self: TZConnection; var T: String);
begin T := Self.LibraryLocation; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionCatalog_W(Self: TZConnection; const T: string);
begin Self.Catalog := T; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionCatalog_R(Self: TZConnection; var T: string);
begin T := Self.Catalog; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionProtocol_W(Self: TZConnection; const T: string);
begin Self.Protocol := T; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionProtocol_R(Self: TZConnection; var T: string);
begin T := Self.Protocol; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionPassword_W(Self: TZConnection; const T: string);
begin Self.Password := T; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionPassword_R(Self: TZConnection; var T: string);
begin T := Self.Password; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionUser_W(Self: TZConnection; const T: string);
begin Self.User := T; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionUser_R(Self: TZConnection; var T: string);
begin T := Self.User; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionDatabase_W(Self: TZConnection; const T: string);
begin Self.Database := T; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionDatabase_R(Self: TZConnection; var T: string);
begin T := Self.Database; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionPort_W(Self: TZConnection; const T: Integer);
begin Self.Port := T; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionPort_R(Self: TZConnection; var T: Integer);
begin T := Self.Port; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionHostName_W(Self: TZConnection; const T: string);
begin Self.HostName := T; end;

(*----------------------------------------------------------------------------*)
procedure TZConnectionHostName_R(Self: TZConnection; var T: string);
begin T := Self.HostName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZConnection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZConnection) do
  begin
    RegisterPropertyHelper(@TZConnectionHostName_R,@TZConnectionHostName_W,'HostName');
    RegisterPropertyHelper(@TZConnectionPort_R,@TZConnectionPort_W,'Port');
    RegisterPropertyHelper(@TZConnectionDatabase_R,@TZConnectionDatabase_W,'Database');
    RegisterPropertyHelper(@TZConnectionUser_R,@TZConnectionUser_W,'User');
    RegisterPropertyHelper(@TZConnectionPassword_R,@TZConnectionPassword_W,'Password');
    RegisterPropertyHelper(@TZConnectionProtocol_R,@TZConnectionProtocol_W,'Protocol');
    RegisterPropertyHelper(@TZConnectionCatalog_R,@TZConnectionCatalog_W,'Catalog');
    RegisterPropertyHelper(@TZConnectionLibraryLocation_R,@TZConnectionLibraryLocation_W,'LibraryLocation');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ZConnection(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TZConnection(CL);
end;

 
 
{ TPSImport_ZConnection }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZConnection.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ZConnection(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ZConnection.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ZConnection(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
