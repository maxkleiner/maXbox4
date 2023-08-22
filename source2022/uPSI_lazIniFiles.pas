unit uPSI_lazIniFiles;
{
   standard and extension  diff with TLInifile from Borland
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
  TPSImport_lazIniFiles = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLMemIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TLIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TLCustomIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TIniFileSectionList(CL: TPSPascalCompiler);
procedure SIRegister_TIniFileSection(CL: TPSPascalCompiler);
procedure SIRegister_TIniFileKeyList(CL: TPSPascalCompiler);
procedure SIRegister_TIniFileKey(CL: TPSPascalCompiler);
procedure SIRegister_lazIniFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TLMemIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TLCustomIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIniFileSectionList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIniFileSection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIniFileKeyList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIniFileKey(CL: TPSRuntimeClassImporter);
procedure RIRegister_lazIniFiles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   lazIniFiles
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_lazIniFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLMemIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TLIniFile', 'TLMemIniFile') do
  with CL.AddClassN(CL.FindClass('TLIniFile'),'TLMemIniFile') do
  begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure GetStrings( List : TStrings)');
    RegisterMethod('Procedure Rename( const AFileName : string; Reload : Boolean)');
    RegisterMethod('Procedure SetStrings( List : TStrings)');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TLCustomIniFile', 'TLIniFile') do
  with CL.AddClassN(CL.FindClass('TLCustomIniFile'),'TLIniFile') do begin
    RegisterProperty('FStream', 'TStream', iptrw);
    RegisterMethod('Constructor Create( const AFileName : string)');
    RegisterMethod('Constructor Create1( AStream : TStream)');
    RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
    RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionRaw( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
    RegisterMethod('Procedure UpdateFile');
    RegisterProperty('Stream', 'TStream', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLCustomIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLCustomIniFile') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLCustomIniFile') do begin
    RegisterProperty('FFileName', 'string', iptrw);
    RegisterProperty('FSectionList', 'TIniFileSectionList', iptrw);
    RegisterProperty('FEscapeLineFeeds', 'boolean', iptrw);
    RegisterMethod('Constructor Create( const AFileName : string)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function SectionExists( const Section : string) : Boolean');
    RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
    RegisterMethod('Function ReadInteger( const Section, Ident : string; Default : Longint) : Longint');
    RegisterMethod('Procedure WriteInteger( const Section, Ident : string; Value : Longint)');
    RegisterMethod('Function ReadBool( const Section, Ident : string; Default : Boolean) : Boolean');
    RegisterMethod('Procedure WriteBool( const Section, Ident : string; Value : Boolean)');
    RegisterMethod('Function ReadDate( const Section, Ident : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadDateTime( const Section, Ident : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadFloat( const Section, Ident : string; Default : Double) : Double');
    RegisterMethod('Function ReadTime( const Section, Ident : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Procedure WriteDate( const Section, Ident : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteDateTime( const Section, Ident : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteFloat( const Section, Ident : string; Value : Double)');
    RegisterMethod('Procedure WriteTime( const Section, Ident : string; Value : TDateTime)');
    RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
    RegisterMethod('Procedure UpdateFile');
    RegisterMethod('Function ValueExists( const Section, Ident : string) : Boolean');
    RegisterProperty('FileName', 'string', iptr);
    RegisterProperty('EscapeLineFeeds', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIniFileSectionList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TIniFileSectionList') do
  with CL.AddClassN(CL.FindClass('TList'),'TIniFileSectionList') do begin
    RegisterMethod('Procedure Clear');
        RegisterMethod('Procedure Free');
     RegisterProperty('Items', 'TIniFileSection integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIniFileSection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIniFileSection') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIniFileSection') do begin
    RegisterProperty('FName', 'string', iptrw);
    RegisterProperty('FKeyList', 'TIniFileKeyList', iptrw);
    RegisterMethod('Constructor Create( AName : string)');
        RegisterMethod('Procedure Free');
     RegisterProperty('Name', 'string', iptr);
    RegisterProperty('KeyList', 'TIniFileKeyList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIniFileKeyList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TIniFileKeyList') do
  with CL.AddClassN(CL.FindClass('TList'),'TIniFileKeyList') do begin
    RegisterMethod('Procedure Clear');
     RegisterMethod('Procedure Free');
     RegisterProperty('Items', 'TIniFileKey integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIniFileKey(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TIniFileKey') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TIniFileKey') do
  begin
    RegisterProperty('FIdent', 'string', iptrw);
    RegisterProperty('FValue', 'string', iptrw);
    RegisterMethod('Constructor Create( AIdent, AValue : string)');
    RegisterProperty('Ident', 'string', iptrw);
    RegisterProperty('Value', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_lazIniFiles(CL: TPSPascalCompiler);
begin
  SIRegister_TIniFileKey(CL);
  SIRegister_TIniFileKeyList(CL);
  SIRegister_TIniFileSection(CL);
  SIRegister_TIniFileSectionList(CL);
  SIRegister_TLCustomIniFile(CL);
  SIRegister_TLIniFile(CL);
  SIRegister_TLMemIniFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TLIniFileStream_R(Self: TLIniFile; var T: TStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure TLIniFileFStream_W(Self: TLIniFile; const T: TStream);
Begin Self.FStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TLIniFileFStream_R(Self: TLIniFile; var T: TStream);
Begin T := Self.FStream; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileEscapeLineFeeds_W(Self: TLCustomIniFile; const T: boolean);
begin Self.EscapeLineFeeds := T; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileEscapeLineFeeds_R(Self: TLCustomIniFile; var T: boolean);
begin T := Self.EscapeLineFeeds; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileFileName_R(Self: TLCustomIniFile; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileFEscapeLineFeeds_W(Self: TLCustomIniFile; const T: boolean);
Begin Self.FEscapeLineFeeds := T; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileFEscapeLineFeeds_R(Self: TLCustomIniFile; var T: boolean);
Begin T := Self.FEscapeLineFeeds; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileFSectionList_W(Self: TLCustomIniFile; const T: TIniFileSectionList);
Begin Self.FSectionList := T; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileFSectionList_R(Self: TLCustomIniFile; var T: TIniFileSectionList);
Begin T := Self.FSectionList; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileFFileName_W(Self: TLCustomIniFile; const T: string);
Begin Self.FFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TLCustomIniFileFFileName_R(Self: TLCustomIniFile; var T: string);
Begin T := Self.FFileName; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileSectionListItems_R(Self: TIniFileSectionList; var T: TIniFileSection; const t1: integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileSectionKeyList_R(Self: TIniFileSection; var T: TIniFileKeyList);
begin T := Self.KeyList; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileSectionName_R(Self: TIniFileSection; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileSectionFKeyList_W(Self: TIniFileSection; const T: TIniFileKeyList);
Begin Self.FKeyList := T; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileSectionFKeyList_R(Self: TIniFileSection; var T: TIniFileKeyList);
Begin T := Self.FKeyList; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileSectionFName_W(Self: TIniFileSection; const T: string);
Begin Self.FName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileSectionFName_R(Self: TIniFileSection; var T: string);
Begin T := Self.FName; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyListItems_R(Self: TIniFileKeyList; var T: TIniFileKey; const t1: integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyValue_W(Self: TIniFileKey; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyValue_R(Self: TIniFileKey; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyIdent_W(Self: TIniFileKey; const T: string);
begin Self.Ident := T; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyIdent_R(Self: TIniFileKey; var T: string);
begin T := Self.Ident; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyFValue_W(Self: TIniFileKey; const T: string);
Begin Self.FValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyFValue_R(Self: TIniFileKey; var T: string);
Begin T := Self.FValue; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyFIdent_W(Self: TIniFileKey; const T: string);
Begin Self.FIdent := T; end;

(*----------------------------------------------------------------------------*)
procedure TIniFileKeyFIdent_R(Self: TIniFileKey; var T: string);
Begin T := Self.FIdent; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLMemIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLMemIniFile) do begin
    RegisterMethod(@TLMemIniFile.Clear, 'Clear');
    RegisterMethod(@TLMemIniFile.GetStrings, 'GetStrings');
    RegisterMethod(@TLMemIniFile.Rename, 'Rename');
    RegisterMethod(@TLMemIniFile.SetStrings, 'SetStrings');
    RegisterMethod(@TLMemIniFile.WriteString, 'WriteString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLIniFile) do begin
    RegisterPropertyHelper(@TLIniFileFStream_R,@TLIniFileFStream_W,'FStream');
    RegisterConstructor(@TLIniFile.Create, 'Create');
    RegisterConstructor(@TLIniFile.Create1, 'Create1');   //stream
    RegisterMethod(@TLIniFile.ReadString, 'ReadString');
    RegisterMethod(@TLIniFile.WriteString, 'WriteString');
    RegisterMethod(@TLIniFile.ReadSection, 'ReadSection');
    RegisterMethod(@TLIniFile.ReadSectionRaw, 'ReadSectionRaw');
    RegisterMethod(@TLIniFile.ReadSections, 'ReadSections');
    RegisterMethod(@TLIniFile.ReadSectionValues, 'ReadSectionValues');
    RegisterMethod(@TLIniFile.EraseSection, 'EraseSection');
    RegisterMethod(@TLIniFile.DeleteKey, 'DeleteKey');
    RegisterMethod(@TLIniFile.UpdateFile, 'UpdateFile');
    RegisterPropertyHelper(@TLIniFileStream_R,nil,'Stream');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLCustomIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLCustomIniFile) do begin
    RegisterPropertyHelper(@TLCustomIniFileFFileName_R,@TLCustomIniFileFFileName_W,'FFileName');
    RegisterPropertyHelper(@TLCustomIniFileFSectionList_R,@TLCustomIniFileFSectionList_W,'FSectionList');
    RegisterPropertyHelper(@TLCustomIniFileFEscapeLineFeeds_R,@TLCustomIniFileFEscapeLineFeeds_W,'FEscapeLineFeeds');
    RegisterConstructor(@TLCustomIniFile.Create, 'Create');
     RegisterMethod(@TLCustomIniFile.Destroy, 'Free');
      RegisterVirtualMethod(@TLCustomIniFile.SectionExists, 'SectionExists');
    //RegisterVirtualAbstractMethod(@TLCustomIniFile, @!.ReadString, 'ReadString');
    //RegisterVirtualAbstractMethod(@TLCustomIniFile, @!.WriteString, 'WriteString');
    RegisterVirtualMethod(@TLCustomIniFile.ReadInteger, 'ReadInteger');
    RegisterVirtualMethod(@TLCustomIniFile.WriteInteger, 'WriteInteger');
    RegisterVirtualMethod(@TLCustomIniFile.ReadBool, 'ReadBool');
    RegisterVirtualMethod(@TLCustomIniFile.WriteBool, 'WriteBool');
    RegisterVirtualMethod(@TLCustomIniFile.ReadDate, 'ReadDate');
    RegisterVirtualMethod(@TLCustomIniFile.ReadDateTime, 'ReadDateTime');
    RegisterVirtualMethod(@TLCustomIniFile.ReadFloat, 'ReadFloat');
    RegisterVirtualMethod(@TLCustomIniFile.ReadTime, 'ReadTime');
    RegisterVirtualMethod(@TLCustomIniFile.WriteDate, 'WriteDate');
    RegisterVirtualMethod(@TLCustomIniFile.WriteDateTime, 'WriteDateTime');
    RegisterVirtualMethod(@TLCustomIniFile.WriteFloat, 'WriteFloat');
    RegisterVirtualMethod(@TLCustomIniFile.WriteTime, 'WriteTime');
    {RegisterVirtualAbstractMethod(@TLCustomIniFile, @!.ReadSection, 'ReadSection');
    RegisterVirtualAbstractMethod(@TLCustomIniFile, @!.ReadSections, 'ReadSections');
    RegisterVirtualAbstractMethod(@TLCustomIniFile, @!.ReadSectionValues, 'ReadSectionValues');
    RegisterVirtualAbstractMethod(@TLCustomIniFile, @!.EraseSection, 'EraseSection');
    RegisterVirtualAbstractMethod(@TLCustomIniFile, @!.DeleteKey, 'DeleteKey');
    RegisterVirtualAbstractMethod(@TLCustomIniFile, @!.UpdateFile, 'UpdateFile');}
    RegisterVirtualMethod(@TLCustomIniFile.ValueExists, 'ValueExists');
    RegisterPropertyHelper(@TLCustomIniFileFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TLCustomIniFileEscapeLineFeeds_R,@TLCustomIniFileEscapeLineFeeds_W,'EscapeLineFeeds');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIniFileSectionList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIniFileSectionList) do begin
    RegisterMethod(@TIniFileSectionList.Clear, 'Clear');
       RegisterMethod(@TIniFileSectionList.Destroy, 'Free');
       RegisterPropertyHelper(@TIniFileSectionListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIniFileSection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIniFileSection) do begin
    RegisterPropertyHelper(@TIniFileSectionFName_R,@TIniFileSectionFName_W,'FName');
    RegisterPropertyHelper(@TIniFileSectionFKeyList_R,@TIniFileSectionFKeyList_W,'FKeyList');
    RegisterConstructor(@TIniFileSection.Create, 'Create');
    RegisterMethod(@TIniFileSection.Destroy, 'Free');

    RegisterPropertyHelper(@TIniFileSectionName_R,nil,'Name');
    RegisterPropertyHelper(@TIniFileSectionKeyList_R,nil,'KeyList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIniFileKeyList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIniFileKeyList) do begin
    RegisterMethod(@TIniFileKeyList.Clear, 'Clear');
       RegisterMethod(@TIniFileKeyList.Destroy, 'Free');
     RegisterPropertyHelper(@TIniFileKeyListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIniFileKey(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIniFileKey) do
  begin
    RegisterPropertyHelper(@TIniFileKeyFIdent_R,@TIniFileKeyFIdent_W,'FIdent');
    RegisterPropertyHelper(@TIniFileKeyFValue_R,@TIniFileKeyFValue_W,'FValue');
    RegisterConstructor(@TIniFileKey.Create, 'Create');
    RegisterPropertyHelper(@TIniFileKeyIdent_R,@TIniFileKeyIdent_W,'Ident');
    RegisterPropertyHelper(@TIniFileKeyValue_R,@TIniFileKeyValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_lazIniFiles(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIniFileKey(CL);
  RIRegister_TIniFileKeyList(CL);
  RIRegister_TIniFileSection(CL);
  RIRegister_TIniFileSectionList(CL);
  RIRegister_TLCustomIniFile(CL);
  RIRegister_TLIniFile(CL);
  RIRegister_TLMemIniFile(CL);
end;

 
 
{ TPSImport_lazIniFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_lazIniFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_lazIniFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_lazIniFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_lazIniFiles(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
