unit uPSI_IniFiles;
{
   check free
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
  TPSImport_IniFiles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TMemIniFile(CL: TPSPascalCompiler);
procedure SIRegister_THashedStringList(CL: TPSPascalCompiler);
procedure SIRegister_TStringHash(CL: TPSPascalCompiler);
procedure SIRegister_TCustomIniFile(CL: TPSPascalCompiler);
procedure SIRegister_IniFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMemIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_THashedStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringHash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_IniFiles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IniFiles
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IniFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIniFile', 'TIniFile') do
  //with CL.AddClassN(CL.FindClass('TCustomIniFile'),'TIniFile') do
  with CL.AddClassN(CL.FindClass('TCustomIniFile'),'TIniFile') do begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
    RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
    RegisterMethod('Procedure UpdateFile');
  end;
  //with RegClassS(CL,'TMemIniFile', 'TIniFile') do
 { with CL.AddClassN(CL.FindClass('TMemIniFile'),'TIniFile') do begin
    RegisterMethod('Procedure Free;');
  end; }
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMemIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIniFile', 'TMemIniFile') do
  with CL.AddClassN(CL.FindClass('TCustomIniFile'),'TMemIniFile') do begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Procedure GetStrings( List : TStrings)');
    RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
    RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
    RegisterMethod('Procedure Rename( const FileName : string; Reload : Boolean)');
    RegisterMethod('Procedure SetStrings( List : TStrings)');
    RegisterMethod('Procedure UpdateFile');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THashedStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'THashedStringList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'THashedStringList') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringHash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStringHash') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStringHash') do begin
    RegisterMethod('Constructor Create( Size : Cardinal)');
    RegisterMethod('Procedure Add( const Key : string; Value : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Remove( const Key : string)');
    RegisterMethod('Function Modify( const Key : string; Value : Integer) : Boolean');
    RegisterMethod('Function ValueOf( const Key : string) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCustomIniFile') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCustomIniFile') do begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function SectionExists( const Section : string) : Boolean');
    RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
    RegisterMethod('Function ReadInteger( const Section, Ident : string; Default : Longint) : Longint');
    RegisterMethod('Procedure WriteInteger( const Section, Ident : string; Value : Longint)');
    RegisterMethod('Function ReadBool( const Section, Ident : string; Default : Boolean) : Boolean');
    RegisterMethod('Procedure WriteBool( const Section, Ident : string; Value : Boolean)');
    RegisterMethod('Function ReadBinaryStream( const Section, Name : string; Value : TStream) : Integer');
    RegisterMethod('Function ReadDate( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadDateTime( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadFloat( const Section, Name : string; Default : Double) : Double');
    RegisterMethod('Function ReadTime( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Procedure WriteBinaryStream( const Section, Name : string; Value : TStream)');
    RegisterMethod('Procedure WriteDate( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteDateTime( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteFloat( const Section, Name : string; Value : Double)');
    RegisterMethod('Procedure WriteTime( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings);');
    RegisterMethod('Procedure ReadSections1( const Section : string; Strings : TStrings);');
    RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
    RegisterMethod('Procedure UpdateFile');
    RegisterMethod('Function ValueExists( const Section, Ident : string) : Boolean');
    RegisterProperty('FileName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IniFiles(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIniFileException');
  SIRegister_TCustomIniFile(CL);
  //CL.AddTypeS('PPHashItem', '^PHashItem // will not work');
  //CL.AddTypeS('PHashItem', '^THashItem // will not work');
  //CL.AddTypeS('THashItem', 'record Next : PHashItem; Key : string; Value : Inte'
  // +'ger; end');
  SIRegister_TStringHash(CL);
  SIRegister_THashedStringList(CL);
  SIRegister_TMemIniFile(CL);
  SIRegister_TIniFile(CL);
  //SIRegister_TIniFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMemIniFileCaseSensitive_W(Self: TMemIniFile; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TMemIniFileCaseSensitive_R(Self: TMemIniFile; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TCustomIniFileFileName_R(Self: TCustomIniFile; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
Procedure TCustomIniFileReadSections1_P(Self: TCustomIniFile;  const Section : string; Strings : TStrings);
Begin Self.ReadSections(Section, Strings); END;

(*----------------------------------------------------------------------------*)
Procedure TCustomIniFileReadSections_P(Self: TCustomIniFile;  Strings : TStrings);
Begin Self.ReadSections(Strings); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIniFile) do begin
    RegisterConstructor(@TIniFile.Create, 'Create');
    RegisterMethod(@TIniFile.Destroy, 'Free');
    RegisterMethod(@TIniFile.ReadString, 'ReadString');
    RegisterMethod(@TIniFile.WriteString, 'WriteString');
    RegisterMethod(@TIniFile.ReadSection, 'ReadSection');
    RegisterMethod(@TIniFile.ReadSections, 'ReadSections');
    RegisterMethod(@TIniFile.ReadSectionValues, 'ReadSectionValues');
    RegisterMethod(@TIniFile.EraseSection, 'EraseSection');
    RegisterMethod(@TIniFile.DeleteKey, 'DeleteKey');
    RegisterMethod(@TIniFile.UpdateFile, 'UpdateFile');
  end;
 { with CL.Add(TIniFile) do
  begin
    //RegisterMethod(@TCustomIniFile.Destroy, 'Free');
    RegisterMethod(@TIniFile.Destroy, 'Free');

  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMemIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMemIniFile) do begin
    RegisterConstructor(@TMemIniFile.Create, 'Create');
    RegisterMethod(@TMemIniFile.Destroy, 'Free');
    RegisterMethod(@TMemIniFile.Clear, 'Clear');
    RegisterMethod(@TMemIniFile.DeleteKey, 'DeleteKey');
    RegisterMethod(@TMemIniFile.EraseSection, 'EraseSection');
    RegisterMethod(@TMemIniFile.GetStrings, 'GetStrings');
    RegisterMethod(@TMemIniFile.ReadSection, 'ReadSection');
    RegisterMethod(@TMemIniFile.ReadSections, 'ReadSections');
    RegisterMethod(@TMemIniFile.ReadSectionValues, 'ReadSectionValues');
    RegisterMethod(@TMemIniFile.ReadString, 'ReadString');
    RegisterMethod(@TMemIniFile.Rename, 'Rename');
    RegisterMethod(@TMemIniFile.SetStrings, 'SetStrings');
    RegisterMethod(@TMemIniFile.UpdateFile, 'UpdateFile');
    RegisterMethod(@TMemIniFile.WriteString, 'WriteString');
    RegisterPropertyHelper(@TMemIniFileCaseSensitive_R,@TMemIniFileCaseSensitive_W,'CaseSensitive');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THashedStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THashedStringList) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringHash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringHash) do begin
    RegisterConstructor(@TStringHash.Create, 'Create');
    RegisterMethod(@TStringHash.Add, 'Add');
    RegisterMethod(@TStringHash.Clear, 'Clear');
    RegisterMethod(@TStringHash.Remove, 'Remove');
    RegisterMethod(@TStringHash.Modify, 'Modify');
    RegisterMethod(@TStringHash.ValueOf, 'ValueOf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomIniFile) do begin
    RegisterConstructor(@TCustomIniFile.Create, 'Create');
    RegisterMethod(@TCustomIniFile.SectionExists, 'SectionExists');
    RegisterMethod(@TCustomIniFile.Destroy, 'Free');
    //RegisterVirtualAbstractMethod(@TCustomIniFile, 'ReadString');
    //RegisterVirtualAbstractMethod(@TCustomIniFile, 'WriteString');
    RegisterVirtualMethod(@TCustomIniFile.ReadInteger, 'ReadInteger');
    RegisterVirtualMethod(@TCustomIniFile.WriteInteger, 'WriteInteger');
    RegisterVirtualMethod(@TCustomIniFile.ReadBool, 'ReadBool');
    RegisterVirtualMethod(@TCustomIniFile.WriteBool, 'WriteBool');
    RegisterVirtualMethod(@TCustomIniFile.ReadBinaryStream, 'ReadBinaryStream');
    RegisterVirtualMethod(@TCustomIniFile.ReadDate, 'ReadDate');
    RegisterVirtualMethod(@TCustomIniFile.ReadDateTime, 'ReadDateTime');
    RegisterVirtualMethod(@TCustomIniFile.ReadFloat, 'ReadFloat');
    RegisterVirtualMethod(@TCustomIniFile.ReadTime, 'ReadTime');
    RegisterVirtualMethod(@TCustomIniFile.WriteBinaryStream, 'WriteBinaryStream');
    RegisterVirtualMethod(@TCustomIniFile.WriteDate, 'WriteDate');
    RegisterVirtualMethod(@TCustomIniFile.WriteDateTime, 'WriteDateTime');
    RegisterVirtualMethod(@TCustomIniFile.WriteFloat, 'WriteFloat');
    RegisterVirtualMethod(@TCustomIniFile.WriteTime, 'WriteTime');
    //RegisterVirtualAbstractMethod(@TCustomIniFile, @ReadSection, 'ReadSection');
    //RegisterVirtualAbstractMethod(@TCustomIniFile, @ReadSections, 'ReadSections');
    RegisterVirtualMethod(@TCustomIniFileReadSections1_P, 'ReadSections1');
    //RegisterVirtualAbstractMethod(@TCustomIniFile, @!.ReadSectionValues, 'ReadSectionValues');
    //RegisterVirtualAbstractMethod(@TCustomIniFile, @!.EraseSection, 'EraseSection');
    //RegisterVirtualAbstractMethod(@TCustomIniFile, @!.DeleteKey, 'DeleteKey');
    //RegisterVirtualAbstractMethod(@TCustomIniFile, @!.UpdateFile, 'UpdateFile');
    RegisterVirtualMethod(@TCustomIniFile.ValueExists, 'ValueExists');
    RegisterPropertyHelper(@TCustomIniFileFileName_R,nil,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IniFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EIniFileException) do
  RIRegister_TCustomIniFile(CL);
  RIRegister_TStringHash(CL);
  RIRegister_THashedStringList(CL);
  RIRegister_TMemIniFile(CL);
  RIRegister_TIniFile(CL);
  //RIRegister_TIniFile(CL);
end;

 
 
{ TPSImport_IniFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IniFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IniFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IniFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IniFiles(ri);
end;
(*----------------------------------------------------------------------------*)

 
end.
