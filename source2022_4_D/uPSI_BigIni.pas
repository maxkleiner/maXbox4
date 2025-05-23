unit uPSI_BigIni;
{
  from hinzen of import
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
  TPSImport_BigIni = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TLibIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TAppIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TBiggerIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TBigIniFile(CL: TPSPascalCompiler);
procedure SIRegister_TSectionList(CL: TPSPascalCompiler);
procedure SIRegister_TCommaSeparatedInfo(CL: TPSPascalCompiler);
procedure SIRegister_BigIni(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BigIni_Routines(S: TPSExec);
procedure RIRegister_TLibIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAppIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBiggerIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBigIniFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSectionList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCommaSeparatedInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_BigIni(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   BigIni
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BigIni]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TLibIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBiggerIniFile', 'TLibIniFile') do
  with CL.AddClassN(CL.FindClass('TBiggerIniFile'),'TLibIniFile') do
  begin
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAppIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBiggerIniFile', 'TAppIniFile') do
  with CL.AddClassN(CL.FindClass('TBiggerIniFile'),'TAppIniFile') do
  begin
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBiggerIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TBigIniFile', 'TBiggerIniFile') do
  with CL.AddClassN(CL.FindClass('TBigIniFile'),'TBiggerIniFile') do
  begin
    RegisterMethod('Function ReadBinaryData( const aSection, aKey : String; var Buffer, BufSize : Integer) : Integer');
    RegisterMethod('Procedure ReadNumberedList( const Section : string; aStrings : TStrings; Deflt : string; aPrefix : String; IndexStart : Integer)');
    RegisterMethod('Procedure RenameKey( const aSection, OldKey, NewKey : String)');
    RegisterMethod('Procedure RenameSection( const OldSection, NewSection : String)');
    RegisterMethod('Procedure WriteBinaryData( const aSection, aKey : String; var Buffer, BufSize : Integer)');
    RegisterMethod('Procedure WriteNumberedList( const Section : string; aStrings : TStrings; aPrefix : String; IndexStart : Integer)');
    RegisterMethod('Procedure WriteSectionValues( const aSection : string; const aStrings : TStrings)');
    RegisterProperty('HasChanged', 'Boolean', iptrw);
    RegisterProperty('TextBufferSize', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBigIniFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TBigIniFile') do
  with CL.AddClassN(CL.FindClass('TObject'),'TBigIniFile') do
  begin
    RegisterMethod('Constructor Create( const FileName : string)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AppendFromFile( const aName : string)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure DeleteKey( const aSection, aKey : string)');
    RegisterMethod('Procedure EraseSection( const aSection : string)');
    RegisterMethod('Procedure FlushFile');
    RegisterMethod('Function HasSection( const aSection : String) : Boolean');
    RegisterMethod('Function ReadAnsiString( const aSection, aKey, aDefault : string) : AnsiString');
    RegisterMethod('Procedure ReadAll( aStrings : TStrings)');
    RegisterMethod('Function ReadBool( const aSection, aKey : string; aDefault : Boolean) : Boolean');
    RegisterMethod('Function ReadDate( const aSection, aKey : string; aDefault : TDateTime) : TDateTime');
    RegisterMethod('Function ReadDateTime( const aSection, aKey : string; aDefault : TDateTime) : TDateTime');
    RegisterMethod('Function ReadFloat( const aSection, aKey : string; aDefault : Double) : Double');
    RegisterMethod('Function ReadInteger( const aSection, aKey : string; aDefault : Longint) : Longint');
    RegisterMethod('Procedure ReadSection( const aSection : string; aStrings : TStrings)');
    RegisterMethod('Procedure ReadSections( aStrings : TStrings)');
    RegisterMethod('Procedure ReadSectionValues( const aSection : string; aStrings : TStrings)');
    RegisterMethod('Function ReadString( const aSection, aKey, aDefault : string) : string');
    RegisterMethod('Function ReadTime( const aSection, aKey : string; aDefault : TDateTime) : TDateTime');
    RegisterMethod('Function SectionExists( const aSection : String) : Boolean');
    RegisterMethod('Procedure UpdateFile');
    RegisterMethod('Function ValueExists( const aSection, aValue : string) : Boolean');
    RegisterMethod('Procedure WriteAnsiString( const aSection, aKey, aValue : AnsiString)');
    RegisterMethod('Procedure WriteBool( const aSection, aKey : string; aValue : Boolean)');
    RegisterMethod('Procedure WriteDate( const aSection, aKey : string; aValue : TDateTime)');
    RegisterMethod('Procedure WriteDateTime( const aSection, aKey : string; aValue : TDateTime)');
    RegisterMethod('Procedure WriteFloat( const aSection, aKey : string; aValue : Double)');
    RegisterMethod('Procedure WriteInteger( const aSection, aKey : string; aValue : Longint)');
    RegisterMethod('Procedure WriteString( const aSection, aKey, aValue : string)');
    RegisterMethod('Procedure WriteTime( const aSection, aKey : string; aValue : TDateTime)');
    RegisterProperty('EraseSectionCallback', 'TEraseSectionCallback', iptrw);
    RegisterProperty('FlagClearOnReadSectionValues', 'Boolean', iptrw);
    RegisterProperty('FlagDropApostrophes', 'Boolean', iptrw);
    RegisterProperty('FlagDropCommentLines', 'Boolean', iptrw);
    RegisterProperty('FlagDropWhiteSpace', 'Boolean', iptrw);
    RegisterProperty('FlagFilterOutInvalid', 'Boolean', iptrw);
    RegisterProperty('FlagTrimRight', 'Boolean', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('SectionNames', 'TSectionList', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSectionList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TSectionList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TSectionList') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function EraseDuplicates( callBackProc : TEraseSectionCallback) : Boolean');
    RegisterMethod('Function GetSectionItems( index : Integer) : TStringList');
    RegisterMethod('Function IndexOf( const S : AnsiString) : Integer');
    RegisterMethod('Function IndexOfName( const name : string) : Integer');
    RegisterProperty('SectionItems', 'TStringList Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommaSeparatedInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCommaSeparatedInfo') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCommaSeparatedInfo') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterProperty('Value', 'String', iptrw);
    RegisterProperty('Element', 'String Integer', iptrw);
    SetDefaultPropery('Element');
    RegisterProperty('AsInteger', 'Integer Integer', iptrw);
    RegisterProperty('AsBoolean', 'Boolean Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BigIni(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IniTextBufferSize','LongWord').SetUInt( $7000);
 CL.AddConstantN('cIniCount','String').SetString( 'Count');
  CL.AddTypeS('TEraseSectionCallback', 'Function ( const sectionName : string; '
   +'const sl1, sl2 : TStringList) : Boolean');
  SIRegister_TCommaSeparatedInfo(CL);
  SIRegister_TSectionList(CL);
  SIRegister_TBigIniFile(CL);
  SIRegister_TBiggerIniFile(CL);
  SIRegister_TAppIniFile(CL);
  SIRegister_TLibIniFile(CL);
 CL.AddDelphiFunction('Function ModuleName( getLibraryName : Boolean) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBiggerIniFileTextBufferSize_W(Self: TBiggerIniFile; const T: Integer);
begin Self.TextBufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TBiggerIniFileTextBufferSize_R(Self: TBiggerIniFile; var T: Integer);
begin T := Self.TextBufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TBiggerIniFileHasChanged_W(Self: TBiggerIniFile; const T: Boolean);
begin Self.HasChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TBiggerIniFileHasChanged_R(Self: TBiggerIniFile; var T: Boolean);
begin T := Self.HasChanged; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileSectionNames_R(Self: TBigIniFile; var T: TSectionList);
begin T := Self.SectionNames; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFileName_W(Self: TBigIniFile; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFileName_R(Self: TBigIniFile; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagTrimRight_W(Self: TBigIniFile; const T: Boolean);
begin Self.FlagTrimRight := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagTrimRight_R(Self: TBigIniFile; var T: Boolean);
begin T := Self.FlagTrimRight; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagFilterOutInvalid_W(Self: TBigIniFile; const T: Boolean);
begin Self.FlagFilterOutInvalid := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagFilterOutInvalid_R(Self: TBigIniFile; var T: Boolean);
begin T := Self.FlagFilterOutInvalid; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagDropWhiteSpace_W(Self: TBigIniFile; const T: Boolean);
begin Self.FlagDropWhiteSpace := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagDropWhiteSpace_R(Self: TBigIniFile; var T: Boolean);
begin T := Self.FlagDropWhiteSpace; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagDropCommentLines_W(Self: TBigIniFile; const T: Boolean);
begin Self.FlagDropCommentLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagDropCommentLines_R(Self: TBigIniFile; var T: Boolean);
begin T := Self.FlagDropCommentLines; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagDropApostrophes_W(Self: TBigIniFile; const T: Boolean);
begin Self.FlagDropApostrophes := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagDropApostrophes_R(Self: TBigIniFile; var T: Boolean);
begin T := Self.FlagDropApostrophes; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagClearOnReadSectionValues_W(Self: TBigIniFile; const T: Boolean);
begin Self.FlagClearOnReadSectionValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileFlagClearOnReadSectionValues_R(Self: TBigIniFile; var T: Boolean);
begin T := Self.FlagClearOnReadSectionValues; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileEraseSectionCallback_W(Self: TBigIniFile; const T: TEraseSectionCallback);
begin Self.EraseSectionCallback := T; end;

(*----------------------------------------------------------------------------*)
procedure TBigIniFileEraseSectionCallback_R(Self: TBigIniFile; var T: TEraseSectionCallback);
begin T := Self.EraseSectionCallback; end;

(*----------------------------------------------------------------------------*)
procedure TSectionListSectionItems_R(Self: TSectionList; var T: TStringList; const t1: Integer);
begin T := Self.SectionItems[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommaSeparatedInfoAsBoolean_W(Self: TCommaSeparatedInfo; const T: Boolean; const t1: Integer);
begin Self.AsBoolean[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommaSeparatedInfoAsBoolean_R(Self: TCommaSeparatedInfo; var T: Boolean; const t1: Integer);
begin T := Self.AsBoolean[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommaSeparatedInfoAsInteger_W(Self: TCommaSeparatedInfo; const T: Integer; const t1: Integer);
begin Self.AsInteger[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommaSeparatedInfoAsInteger_R(Self: TCommaSeparatedInfo; var T: Integer; const t1: Integer);
begin T := Self.AsInteger[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommaSeparatedInfoElement_W(Self: TCommaSeparatedInfo; const T: String; const t1: Integer);
begin Self.Element[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommaSeparatedInfoElement_R(Self: TCommaSeparatedInfo; var T: String; const t1: Integer);
begin T := Self.Element[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommaSeparatedInfoValue_W(Self: TCommaSeparatedInfo; const T: String);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TCommaSeparatedInfoValue_R(Self: TCommaSeparatedInfo; var T: String);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BigIni_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ModuleName, 'ModuleName', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLibIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLibIniFile) do
  begin
    RegisterConstructor(@TLibIniFile.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAppIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAppIniFile) do
  begin
    RegisterConstructor(@TAppIniFile.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBiggerIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBiggerIniFile) do
  begin
    RegisterVirtualMethod(@TBiggerIniFile.ReadBinaryData, 'ReadBinaryData');
    RegisterVirtualMethod(@TBiggerIniFile.ReadNumberedList, 'ReadNumberedList');
    RegisterVirtualMethod(@TBiggerIniFile.RenameKey, 'RenameKey');
    RegisterVirtualMethod(@TBiggerIniFile.RenameSection, 'RenameSection');
    RegisterVirtualMethod(@TBiggerIniFile.WriteBinaryData, 'WriteBinaryData');
    RegisterVirtualMethod(@TBiggerIniFile.WriteNumberedList, 'WriteNumberedList');
    RegisterVirtualMethod(@TBiggerIniFile.WriteSectionValues, 'WriteSectionValues');
    RegisterPropertyHelper(@TBiggerIniFileHasChanged_R,@TBiggerIniFileHasChanged_W,'HasChanged');
    RegisterPropertyHelper(@TBiggerIniFileTextBufferSize_R,@TBiggerIniFileTextBufferSize_W,'TextBufferSize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBigIniFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBigIniFile) do
  begin
    RegisterConstructor(@TBigIniFile.Create, 'Create');
    RegisterMethod(@TBigIniFile.Destroy, 'Free');
    RegisterVirtualMethod(@TBigIniFile.AppendFromFile, 'AppendFromFile');
    RegisterVirtualMethod(@TBigIniFile.Clear, 'Clear');
    RegisterVirtualMethod(@TBigIniFile.DeleteKey, 'DeleteKey');
    RegisterVirtualMethod(@TBigIniFile.EraseSection, 'EraseSection');
    RegisterVirtualMethod(@TBigIniFile.FlushFile, 'FlushFile');
    RegisterVirtualMethod(@TBigIniFile.HasSection, 'HasSection');
    RegisterVirtualMethod(@TBigIniFile.ReadAnsiString, 'ReadAnsiString');
    RegisterVirtualMethod(@TBigIniFile.ReadAll, 'ReadAll');
    RegisterVirtualMethod(@TBigIniFile.ReadBool, 'ReadBool');
    RegisterVirtualMethod(@TBigIniFile.ReadDate, 'ReadDate');
    RegisterVirtualMethod(@TBigIniFile.ReadDateTime, 'ReadDateTime');
    RegisterVirtualMethod(@TBigIniFile.ReadFloat, 'ReadFloat');
    RegisterVirtualMethod(@TBigIniFile.ReadInteger, 'ReadInteger');
    RegisterVirtualMethod(@TBigIniFile.ReadSection, 'ReadSection');
    RegisterVirtualMethod(@TBigIniFile.ReadSections, 'ReadSections');
    RegisterVirtualMethod(@TBigIniFile.ReadSectionValues, 'ReadSectionValues');
    RegisterVirtualMethod(@TBigIniFile.ReadString, 'ReadString');
    RegisterVirtualMethod(@TBigIniFile.ReadTime, 'ReadTime');
    RegisterVirtualMethod(@TBigIniFile.SectionExists, 'SectionExists');
    RegisterVirtualMethod(@TBigIniFile.UpdateFile, 'UpdateFile');
    RegisterVirtualMethod(@TBigIniFile.ValueExists, 'ValueExists');
    RegisterVirtualMethod(@TBigIniFile.WriteAnsiString, 'WriteAnsiString');
    RegisterVirtualMethod(@TBigIniFile.WriteBool, 'WriteBool');
    RegisterVirtualMethod(@TBigIniFile.WriteDate, 'WriteDate');
    RegisterVirtualMethod(@TBigIniFile.WriteDateTime, 'WriteDateTime');
    RegisterVirtualMethod(@TBigIniFile.WriteFloat, 'WriteFloat');
    RegisterVirtualMethod(@TBigIniFile.WriteInteger, 'WriteInteger');
    RegisterVirtualMethod(@TBigIniFile.WriteString, 'WriteString');
    RegisterVirtualMethod(@TBigIniFile.WriteTime, 'WriteTime');
    RegisterPropertyHelper(@TBigIniFileEraseSectionCallback_R,@TBigIniFileEraseSectionCallback_W,'EraseSectionCallback');
    RegisterPropertyHelper(@TBigIniFileFlagClearOnReadSectionValues_R,@TBigIniFileFlagClearOnReadSectionValues_W,'FlagClearOnReadSectionValues');
    RegisterPropertyHelper(@TBigIniFileFlagDropApostrophes_R,@TBigIniFileFlagDropApostrophes_W,'FlagDropApostrophes');
    RegisterPropertyHelper(@TBigIniFileFlagDropCommentLines_R,@TBigIniFileFlagDropCommentLines_W,'FlagDropCommentLines');
    RegisterPropertyHelper(@TBigIniFileFlagDropWhiteSpace_R,@TBigIniFileFlagDropWhiteSpace_W,'FlagDropWhiteSpace');
    RegisterPropertyHelper(@TBigIniFileFlagFilterOutInvalid_R,@TBigIniFileFlagFilterOutInvalid_W,'FlagFilterOutInvalid');
    RegisterPropertyHelper(@TBigIniFileFlagTrimRight_R,@TBigIniFileFlagTrimRight_W,'FlagTrimRight');
    RegisterPropertyHelper(@TBigIniFileFileName_R,@TBigIniFileFileName_W,'FileName');
    RegisterPropertyHelper(@TBigIniFileSectionNames_R,nil,'SectionNames');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSectionList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSectionList) do
  begin
    RegisterConstructor(@TSectionList.Create, 'Create');
    RegisterMethod(@TSectionList.EraseDuplicates, 'EraseDuplicates');
    RegisterMethod(@TSectionList.GetSectionItems, 'GetSectionItems');
    RegisterMethod(@TSectionList.IndexOf, 'IndexOf');
    RegisterMethod(@TSectionList.IndexOfName, 'IndexOfName');
    RegisterPropertyHelper(@TSectionListSectionItems_R,nil,'SectionItems');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommaSeparatedInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommaSeparatedInfo) do
  begin
    RegisterConstructor(@TCommaSeparatedInfo.Create, 'Create');
     RegisterMethod(@TCommaSeparatedInfo.Destroy, 'Free');
       RegisterPropertyHelper(@TCommaSeparatedInfoValue_R,@TCommaSeparatedInfoValue_W,'Value');
    RegisterPropertyHelper(@TCommaSeparatedInfoElement_R,@TCommaSeparatedInfoElement_W,'Element');
    RegisterPropertyHelper(@TCommaSeparatedInfoAsInteger_R,@TCommaSeparatedInfoAsInteger_W,'AsInteger');
    RegisterPropertyHelper(@TCommaSeparatedInfoAsBoolean_R,@TCommaSeparatedInfoAsBoolean_W,'AsBoolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BigIni(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCommaSeparatedInfo(CL);
  RIRegister_TSectionList(CL);
  RIRegister_TBigIniFile(CL);
  RIRegister_TBiggerIniFile(CL);
  RIRegister_TAppIniFile(CL);
  RIRegister_TLibIniFile(CL);
end;

 
 
{ TPSImport_BigIni }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BigIni.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BigIni(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BigIni.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BigIni(ri);
  RIRegister_BigIni_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
