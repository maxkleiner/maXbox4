unit uPSI_ALIniFiles;
{
   ini for pub              - fix updatekey
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
  TPSImport_ALIniFiles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TALCustomIniFile(CL: TPSPascalCompiler);
procedure SIRegister_ALIniFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALCustomIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALIniFiles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // ALFcnString
  ALStringList, AlFcnMisc,ALIniFiles;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALIniFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALCustomIniFile', 'TALIniFile') do
  with CL.AddClassN(CL.FindClass('TALCustomIniFile'),'TALIniFile') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALCustomIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TALCustomIniFile') do
  with CL.AddClassN(CL.FindClass('TObject'),'TALCustomIniFile') do begin
    RegisterMethod('Constructor Create( const FileName : AnsiString)');
    RegisterMethod('Function SectionExists( const Section : AnsiString) : Boolean');
    RegisterMethod('Function ReadString( const Section, Ident, Default : AnsiString) : AnsiString');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : AnsiString)');
    RegisterMethod('Function ReadInteger( const Section, Ident : AnsiString; Default : Longint) : Longint');
    RegisterMethod('Procedure WriteInteger( const Section, Ident : AnsiString; Value : Longint)');
    RegisterMethod('Function ReadBool( const Section, Ident : AnsiString; Default : Boolean) : Boolean');
    RegisterMethod('Procedure WriteBool( const Section, Ident : AnsiString; Value : Boolean)');
    RegisterMethod('Function ReadBinaryStream( const Section, Name : AnsiString; Value : TStream) : Integer');
    RegisterMethod('Function ReadDate( const Section, Name : AnsiString; Default : TDateTime; const AFormatSettings : TALFormatSettings) : TDateTime');
    RegisterMethod('Function ReadDateTime( const Section, Name : AnsiString; Default : TDateTime; const AFormatSettings : TALFormatSettings) : TDateTime');
    RegisterMethod('Function ReadFloat( const Section, Name : AnsiString; Default : Double; const AFormatSettings : TALFormatSettings) : Double');
    RegisterMethod('Function ReadTime( const Section, Name : AnsiString; Default : TDateTime; const AFormatSettings : TALFormatSettings) : TDateTime');
    RegisterMethod('Procedure WriteBinaryStream( const Section, Name : AnsiString; Value : TStream)');
    RegisterMethod('Procedure WriteDate( const Section, Name : AnsiString; Value : TDateTime; const AFormatSettings : TALFormatSettings)');
    RegisterMethod('Procedure WriteDateTime( const Section, Name : AnsiString; Value : TDateTime; const AFormatSettings : TALFormatSettings)');
    RegisterMethod('Procedure WriteFloat( const Section, Name : AnsiString; Value : Double; const AFormatSettings : TALFormatSettings)');
    RegisterMethod('Procedure WriteTime( const Section, Name : AnsiString; Value : TDateTime; const AFormatSettings : TALFormatSettings)');
    RegisterMethod('Procedure ReadSection( const Section : AnsiString; Strings : TALStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TALStrings);');
    RegisterMethod('Procedure ReadSections1( const Section : AnsiString; Strings : TALStrings);');
    RegisterMethod('Procedure ReadSubSections( const Section : AnsiString; Strings : TALStrings; Recurse : Boolean)');
    RegisterMethod('Procedure ReadSectionValues( const Section : AnsiString; Strings : TALStrings)');
    RegisterMethod('Procedure EraseSection( const Section : AnsiString)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : AnsiString)');
    RegisterMethod('Procedure UpdateFile');
    RegisterMethod('Function ValueExists( const Section, Ident : AnsiString) : Boolean');
    RegisterProperty('FileName', 'AnsiString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALIniFiles(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EALIniFileException');
  SIRegister_TALCustomIniFile(CL);
  SIRegister_TALIniFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALCustomIniFileFileName_R(Self: TALCustomIniFile; var T: AnsiString);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
Procedure TALCustomIniFileReadSections1_P(Self: TALCustomIniFile;  const Section : AnsiString; Strings : TALStrings);
Begin Self.ReadSections(Section, Strings); END;

(*----------------------------------------------------------------------------*)
Procedure TALCustomIniFileReadSections_P(Self: TALCustomIniFile;  Strings : TALStrings);
Begin Self.ReadSections(Strings); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALIniFile) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALCustomIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALCustomIniFile) do begin
    RegisterConstructor(@TALCustomIniFile.Create, 'Create');
    RegisterMethod(@TALCustomIniFile.SectionExists, 'SectionExists');
    RegisterMethod(@TALCustomIniFile.ReadString, 'ReadString');
    RegisterMethod(@TALCustomIniFile.WriteString, 'WriteString');
    RegisterVirtualMethod(@TALCustomIniFile.ReadInteger, 'ReadInteger');
    RegisterVirtualMethod(@TALCustomIniFile.WriteInteger, 'WriteInteger');
    RegisterVirtualMethod(@TALCustomIniFile.ReadBool, 'ReadBool');
    RegisterVirtualMethod(@TALCustomIniFile.WriteBool, 'WriteBool');
    RegisterVirtualMethod(@TALCustomIniFile.ReadBinaryStream, 'ReadBinaryStream');
    RegisterVirtualMethod(@TALCustomIniFile.ReadDate, 'ReadDate');
    RegisterVirtualMethod(@TALCustomIniFile.ReadDateTime, 'ReadDateTime');
    RegisterVirtualMethod(@TALCustomIniFile.ReadFloat, 'ReadFloat');
    RegisterVirtualMethod(@TALCustomIniFile.ReadTime, 'ReadTime');
    RegisterVirtualMethod(@TALCustomIniFile.WriteBinaryStream, 'WriteBinaryStream');
    RegisterVirtualMethod(@TALCustomIniFile.WriteDate, 'WriteDate');
    RegisterVirtualMethod(@TALCustomIniFile.WriteDateTime, 'WriteDateTime');
    RegisterVirtualMethod(@TALCustomIniFile.WriteFloat, 'WriteFloat');
    RegisterVirtualMethod(@TALCustomIniFile.WriteTime, 'WriteTime');
    RegisterMethod(@TALCustomIniFile.ReadSection, 'ReadSection');
    RegisterMethod(@TALCustomIniFile.ReadSections, 'ReadSections');
    RegisterMethod(@TALCustomIniFileReadSections1_P, 'ReadSections1');
    RegisterMethod(@TALCustomIniFile.ReadSubSections, 'ReadSubSections');
    RegisterMethod(@TALCustomIniFile.ReadSectionValues, 'ReadSectionValues');
    RegisterMethod(@TALCustomIniFile.EraseSection, 'EraseSection');
    RegisterMethod(@TALCustomIniFile.DeleteKey, 'DeleteKey');
    RegisterMethod(@TALCustomIniFile.UpdateFile, 'UpdateFile');
    RegisterVirtualMethod(@TALCustomIniFile.ValueExists, 'ValueExists');
    RegisterPropertyHelper(@TALCustomIniFileFileName_R,nil,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALIniFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EALIniFileException) do
  RIRegister_TALCustomIniFile(CL);
  RIRegister_TALIniFile(CL);
end;

 
 
{ TPSImport_ALIniFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALIniFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALIniFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALIniFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALIniFiles(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
