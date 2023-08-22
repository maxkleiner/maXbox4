unit uPSI_JclIniFiles;
{
   also in jvapputils as TObject but now as unit  as files
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
  TPSImport_JclIniFiles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclIniFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclIniFiles_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // JclUnitVersioning
  IniFiles
  ,JclIniFiles
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclIniFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclIniFiles(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function JIniReadBool( const FileName, Section, Line : string) : Boolean');
 CL.AddDelphiFunction('Function JIniReadInteger( const FileName, Section, Line : string) : Integer');
 CL.AddDelphiFunction('Function JIniReadString( const FileName, Section, Line : string) : string');
 CL.AddDelphiFunction('Procedure JIniWriteBool( const FileName, Section, Line : string; Value : Boolean)');
 CL.AddDelphiFunction('Procedure JIniWriteInteger( const FileName, Section, Line : string; Value : Integer)');
 CL.AddDelphiFunction('Procedure JIniWriteString( const FileName, Section, Line, Value : string)');
 CL.AddDelphiFunction('Procedure JIniReadStrings( IniFile : TCustomIniFile; const Section : string; Strings : TStrings)');
 CL.AddDelphiFunction('Procedure JIniWriteStrings( IniFile : TCustomIniFile; const Section : string; Strings : TStrings)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_JclIniFiles_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IniReadBool, 'JIniReadBool', cdRegister);
 S.RegisterDelphiFunction(@IniReadInteger, 'JIniReadInteger', cdRegister);
 S.RegisterDelphiFunction(@IniReadString, 'JIniReadString', cdRegister);
 S.RegisterDelphiFunction(@IniWriteBool, 'JIniWriteBool', cdRegister);
 S.RegisterDelphiFunction(@IniWriteInteger, 'JIniWriteInteger', cdRegister);
 S.RegisterDelphiFunction(@IniWriteString, 'JIniWriteString', cdRegister);
 S.RegisterDelphiFunction(@IniReadStrings, 'JIniReadStrings', cdRegister);
 S.RegisterDelphiFunction(@IniWriteStrings, 'JIniWriteStrings', cdRegister);
end;

 
 
{ TPSImport_JclIniFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclIniFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclIniFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclIniFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JclIniFiles(ri);
  RIRegister_JclIniFiles_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
