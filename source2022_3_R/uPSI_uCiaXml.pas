unit uPSI_uCiaXml;
{
small XML config class

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
  TPSImport_uCiaXml = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXMLConfig(CL: TPSPascalCompiler);
procedure SIRegister_uCiaXml(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXMLConfig(CL: TPSRuntimeClassImporter);
procedure RIRegister_uCiaXml(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Forms
  ,Windows
  ,XmlIntf
  ,XMLDoc
  ,uCiaXml
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uCiaXml]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXMLConfig(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TXMLConfig') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLConfig') do begin
    RegisterMethod('Constructor Create( const FileName : string);');
    RegisterMethod('Constructor Create1;');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Save');
    RegisterMethod('Function ReadString( const Section, Key, default : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Key, Value : string)');
    RegisterMethod('Function ReadInteger( const Section, Key : string; default : Integer) : Integer');
    RegisterMethod('Procedure WriteInteger( const Section, Key : string; Value : Integer)');
    RegisterMethod('Function ReadBoolean( const Section, Key : string; default : Boolean) : Boolean');
    RegisterMethod('Procedure WriteBoolean( const Section, Key : string; Value : Boolean)');
    RegisterProperty('Backup', 'Boolean', iptrw);
    RegisterProperty('Version', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uCiaXml(CL: TPSPascalCompiler);
begin
  SIRegister_TXMLConfig(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXMLConfigVersion_R(Self: TXMLConfig; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TXMLConfigBackup_W(Self: TXMLConfig; const T: Boolean);
begin Self.Backup := T; end;

(*----------------------------------------------------------------------------*)
procedure TXMLConfigBackup_R(Self: TXMLConfig; var T: Boolean);
begin T := Self.Backup; end;

(*----------------------------------------------------------------------------*)
Function TXMLConfigCreate1_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TXMLConfig.Create; END;

(*----------------------------------------------------------------------------*)
Function TXMLConfigCreate_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : string):TObject;
Begin Result := TXMLConfig.Create(FileName); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXMLConfig(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXMLConfig) do begin
    RegisterConstructor(@TXMLConfigCreate_P, 'Create');
    RegisterConstructor(@TXMLConfigCreate1_P, 'Create1');
       RegisterMethod(@TXMLConfig.Destroy, 'Free');
     RegisterMethod(@TXMLConfig.Save, 'Save');
    RegisterMethod(@TXMLConfig.ReadString, 'ReadString');
    RegisterMethod(@TXMLConfig.WriteString, 'WriteString');
    RegisterMethod(@TXMLConfig.ReadInteger, 'ReadInteger');
    RegisterMethod(@TXMLConfig.WriteInteger, 'WriteInteger');
    RegisterMethod(@TXMLConfig.ReadBoolean, 'ReadBoolean');
    RegisterMethod(@TXMLConfig.WriteBoolean, 'WriteBoolean');
    RegisterPropertyHelper(@TXMLConfigBackup_R,@TXMLConfigBackup_W,'Backup');
    RegisterPropertyHelper(@TXMLConfigVersion_R,nil,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uCiaXml(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXMLConfig(CL);
end;

 
 
{ TPSImport_uCiaXml }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uCiaXml.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uCiaXml(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uCiaXml.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uCiaXml(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
