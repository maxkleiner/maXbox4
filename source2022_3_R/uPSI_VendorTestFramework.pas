unit uPSI_VendorTestFramework;
{
  for test tutor
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
  TPSImport_VendorTestFramework = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDataGenerator(CL: TPSPascalCompiler);
procedure SIRegister_TBaseDialect(CL: TPSPascalCompiler);
procedure SIRegister_TTypeRegistry(CL: TPSPascalCompiler);
procedure SIRegister_TColumnInfo(CL: TPSPascalCompiler);
procedure SIRegister_TTypeInfo(CL: TPSPascalCompiler);
procedure SIRegister_VendorTestFramework(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDataGenerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBaseDialect(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTypeRegistry(CL: TPSRuntimeClassImporter);
procedure RIRegister_TColumnInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTypeInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_VendorTestFramework(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   DB
  ,Variants
  ,SqlTimSt
  ,FMTBcd
  ,VendorTestFramework
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VendorTestFramework]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataGenerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TDataGenerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDataGenerator') do
  begin
    RegisterMethod('Constructor Create( ADialect : TBaseDialect)');
    RegisterMethod('Function GetString( Length : Integer) : String');
    RegisterMethod('Function GetBoolean : Boolean');
    RegisterMethod('Function GetDateTime : TDatetime');
    RegisterMethod('Function GetDate : TDateTime');
    RegisterMethod('Function GetTime : TDateTime');
    RegisterMethod('Function GetTimeStamp : TSQLTimeStamp');
    RegisterMethod('Function GetWideString( Length : Integer) : WideString');
    RegisterMethod('Function GetInt16 : Smallint');
    RegisterMethod('Function GetInt32 : Integer');
    RegisterMethod('Function GetInt64 : Int64');
    RegisterMethod('Function GetDouble : Double');
    RegisterMethod('Function GetFMTBcd( Precision : Integer; Scale : Integer) : TBCD');
    RegisterMethod('Function GetByteArray( Length : Integer) : TBytes');
    RegisterMethod('Function GetValueForType( const SQLType : TSQLType) : Variant');
    RegisterMethod('Function GenerateValuesForRow8( const ColumnTypes : array of TSQLType) : TVariantArray;');
    RegisterMethod('Procedure AssignParamValue( AParam : TParam; AColumn : TColumnInfo)');
    RegisterMethod('Procedure ResetSeed');
    RegisterMethod('Procedure LockSeed');
    RegisterMethod('Procedure UnlockSeed');
    RegisterMethod('Procedure Next');
    RegisterProperty('SeedValue', 'LongWord', iptrw);
    RegisterProperty('GeneratorMode', 'TDataGenMode', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBaseDialect(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBaseDialect') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBaseDialect') do begin
    RegisterMethod('Constructor Create');
         RegisterMethod('Procedure Free');
      RegisterMethod('Function MakeCreateStatementForTypes( TableName : WideString; Columns : array of TColumnInfo) : WideString');
    RegisterMethod('Function MakeCreateStatementForSQLTypes( TableName : WideString; SQLTypes : array of TSQLType) : WideString');
    RegisterMethod('Function DropTableCommand( TableName : WideString) : WideString');
    RegisterMethod('Function InsertIntoStatement( TableName : WideString; Columns : TColumnInfoArray; GenMode : TSQLGenMode) : WideString');
    RegisterMethod('Function Compare( Recieved, Expected : Variant; SQLType : TSQLType) : Integer');
    RegisterMethod('Function GetTypeInfo( const VendorType : WideString) : TDBTypeInfo');
    RegisterMethod('Function QuoteStr( const AValue : String) : WideString');
    RegisterProperty('RegisteredTypes', 'TTypeRegistry', iptr);
    RegisterProperty('MasterRowCount', 'Integer', iptrw);
    RegisterProperty('DefaultLength', 'Integer', iptrw);
    RegisterProperty('DefaultPrecision', 'Integer', iptrw);
    RegisterProperty('DefaultScale', 'Integer', iptrw);
    RegisterProperty('DefaultSeed', 'LongWord', iptrw);
    RegisterProperty('ConnectionName', 'WideString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTypeRegistry(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTypeRegistry') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTypeRegistry') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure RegisterSQLType( ASQLType : TSQLType; SQLKeyword : WideString; FieldMapping : TFieldType)');
    RegisterMethod('Procedure UnregisterSQLType( ASQLType : TSQLType)');
    RegisterMethod('Function GetTypeDDL5( ASQLType : TSQLType) : WideString;');
    RegisterMethod('Function GetTypeDDL6( ASQLType : TSQLType; Length : Integer) : WideString;');
    RegisterMethod('Function GetTypeDDL7( ASQLType : TSQLType; Precision : Integer; Scale : Integer) : WideString;');
    RegisterMethod('Function GetSQLType( SQLKeyword : WideString) : TSQLType');
    RegisterProperty('TypeInfo', 'TDBTypeInfo TSQLType', iptr);
    RegisterProperty('MapsTo', 'TFieldType TSQLType', iptr);
    RegisterProperty('SQLKeyword', 'WideString TSQLType', iptr);
    RegisterProperty('KnownSQLTypes', 'TSQLTypeSet', iptr);
    RegisterProperty('TypesRequiringQuotes', 'TSQLTypeSet', iptr);
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TColumnInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TColumnInfo') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TColumnInfo') do
  begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( ASqlType : TSQLType);');
    RegisterMethod('Constructor Create2( ASqlType : TSQLType; ALength : Integer);');
    RegisterMethod('Constructor Create3( ASqlType : TSQLType; APrecision : Integer; AScale : Integer);');
    RegisterMethod('Constructor Create4( AColumn : TColumnInfo);');
    RegisterProperty('FieldName', 'WideString', iptrw);
    RegisterProperty('SQLType', 'TSQLType', iptr);
    RegisterProperty('Length', 'Integer', iptr);
    RegisterProperty('Precision', 'Integer', iptr);
    RegisterProperty('Scale', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTypeInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTypeInfo') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TDBTypeInfo') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('HasSimpleTypeDDL', 'Boolean', iptrw);
    RegisterProperty('SupportsPrecision', 'Boolean', iptrw);
    RegisterProperty('SupportsScale', 'Boolean', iptrw);
    RegisterProperty('SupportsLength', 'Boolean', iptrw);
    RegisterProperty('RequiresQuotes', 'Boolean', iptrw);
    RegisterProperty('UsesParenthesis', 'Boolean', iptrw);
    RegisterProperty('IsNullable', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_VendorTestFramework(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DBXCTSSEEDField','String').SetString( 'SEED_ID');
 CL.AddConstantN('DBXCTSGenFieldSuffix','String').SetString( '_FIELD');
 CL.AddConstantN('DBXNOTNULL','String').SetString( ' NOT NULL');
 CL.AddConstantN('DEFAULT_SEED','LongInt').SetInt( 111);
 CL.AddConstantN('HIRAGANA_L_a','Char').SetString( #$3042);
 CL.AddConstantN('HIRAGANA_U_A','Char').SetString( #$3041);
 CL.AddConstantN('HIRAGANA_L_i','Char').SetString( #$3043);
 CL.AddConstantN('HIRAGANA_U_I','Char').SetString( #$3044);
 CL.AddConstantN('HIRAGANA_L_tu','Char').SetString( #$3063);
 CL.AddConstantN('HIRAGANA_U_TU','Char').SetString( #$3064);
 CL.AddConstantN('HIRAGANA_U_NI','Char').SetString( #$306B);
 CL.AddConstantN('HIRAGANA_U_ZO','Char').SetString( #$305E);
 CL.AddConstantN('HIRAGANA_U_SO','Char').SetString( #$305D);
 CL.AddConstantN('HIRAGANA_U_MO','Char').SetString( #$3080);
 CL.AddConstantN('HIRAGANA_U_YU','Char').SetString( #$3086);
 CL.AddConstantN('SQUARE_DAASU','Char').SetString( #$3324);
 CL.AddConstantN('GEORGIAN_DON','Char').SetString( #$10A3);
 CL.AddConstantN('GEORGIAN_FI','Char').SetString( #$10F6);
  CL.AddTypeS('TSQLType', '( sqlUnknown, sqlBoolean, sqlVarchar, sqlFixedChar, '
   +'sqlFixedWideChar, sqlWideVarchar, sqlSmallint, sqlInteger, sqlWord, sqlLar'
   +'geInt, sqlFloat, sqlCurrency, sqlDouble, sqlNumeric, sqlDecimal, sqlAutoIn'
   +'c, sqlTimeStamp, sqlTime, sqlDateTime, sqlDate, sqlBytes, sqlVarBytes, sql'
   +'Blob, sqlMemo, sqlWideMemo, sqlGraphic, sqlFmtMemo, sqlTypedBinary, sqlCur'
   +'sor, sqlADT, sqlArray, sqlOraBlob, sqlOraClob, sqlRaw, sqlVariant, sqlGuid)');
  CL.AddTypeS('TSQLTypeArray', 'array of TSQLType');
  //CL.AddTypeS('TVariantArray', 'array of Variant');
 CL.AddConstantN('AllSqlTypes','LongInt').Value.ts32 := ord(sqlUnknown) or ord(sqlBoolean) or ord(sqlVarchar) or ord(sqlFixedChar) or ord(sqlFixedWideChar) or ord(sqlWideVarchar) or ord(sqlSmallint) or ord(sqlInteger) or ord(sqlWord) or ord(sqlLargeint) or ord(sqlFloat) or ord(sqlCurrency) or ord(sqlDouble) or ord(sqlNumeric) or ord(sqlDecimal) or ord(sqlAutoInc) or ord(sqlTimeStamp) or ord(sqlTime) or ord(sqlDateTime) or ord(sqlDate) or ord(sqlBytes) or ord(sqlVarBytes) or ord(sqlBlob) or ord(sqlMemo) or ord(sqlGraphic) or ord(sqlFmtMemo) or ord(sqlTypedBinary) or ord(sqlCursor) or ord(sqlADT) or ord(sqlArray) or ord(sqlOraBlob) or ord(sqlOraClob) or ord(sqlVariant) or ord(sqlGuid);
  //CL.AddTypeS('TBytes', 'array of Byte');
  CL.AddTypeS('TSQLTypeSet', 'set of TSQLType');
  SIRegister_TTypeInfo(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TColumnInfo');
  CL.AddTypeS('TColumnInfoArray', 'array of TColumnInfo');
  SIRegister_TColumnInfo(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ETypeRegistryException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidRegistrationException');
  SIRegister_TTypeRegistry(CL);
  CL.AddTypeS('TSQLGenMode', '( sgmSQLExpr, sgmTDBX )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TBaseDialect');
  //CL.AddTypeS('TBaseDialectClass', 'class of TBaseDialect');
  CL.AddTypeS('EDialectException', 'Exception');
  CL.AddTypeS('EInvalidDialect', 'EDialectException');
  SIRegister_TBaseDialect(CL);
  CL.AddTypeS('TDataGenMode', '( dgmNone, dgmUnlocked, dgmLocked )');
  SIRegister_TDataGenerator(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDataGeneratorGeneratorMode_R(Self: TDataGenerator; var T: TDataGenMode);
begin T := Self.GeneratorMode; end;

(*----------------------------------------------------------------------------*)
procedure TDataGeneratorSeedValue_W(Self: TDataGenerator; const T: LongWord);
begin Self.SeedValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataGeneratorSeedValue_R(Self: TDataGenerator; var T: LongWord);
begin T := Self.SeedValue; end;

(*----------------------------------------------------------------------------*)
Function TDataGeneratorGenerateValuesForRow8_P(Self: TDataGenerator;  const ColumnTypes : array of TSQLType) : TVariantArray;
Begin Result := Self.GenerateValuesForRow(ColumnTypes); END;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectConnectionName_W(Self: TBaseDialect; const T: WideString);
begin Self.ConnectionName := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectConnectionName_R(Self: TBaseDialect; var T: WideString);
begin T := Self.ConnectionName; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectDefaultSeed_W(Self: TBaseDialect; const T: LongWord);
begin Self.DefaultSeed := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectDefaultSeed_R(Self: TBaseDialect; var T: LongWord);
begin T := Self.DefaultSeed; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectDefaultScale_W(Self: TBaseDialect; const T: Integer);
begin Self.DefaultScale := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectDefaultScale_R(Self: TBaseDialect; var T: Integer);
begin T := Self.DefaultScale; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectDefaultPrecision_W(Self: TBaseDialect; const T: Integer);
begin Self.DefaultPrecision := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectDefaultPrecision_R(Self: TBaseDialect; var T: Integer);
begin T := Self.DefaultPrecision; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectDefaultLength_W(Self: TBaseDialect; const T: Integer);
begin Self.DefaultLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectDefaultLength_R(Self: TBaseDialect; var T: Integer);
begin T := Self.DefaultLength; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectMasterRowCount_W(Self: TBaseDialect; const T: Integer);
begin Self.MasterRowCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectMasterRowCount_R(Self: TBaseDialect; var T: Integer);
begin T := Self.MasterRowCount; end;

(*----------------------------------------------------------------------------*)
procedure TBaseDialectRegisteredTypes_R(Self: TBaseDialect; var T: TTypeRegistry);
begin T := Self.RegisteredTypes; end;

(*----------------------------------------------------------------------------*)
procedure TTypeRegistryCount_R(Self: TTypeRegistry; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TTypeRegistryTypesRequiringQuotes_R(Self: TTypeRegistry; var T: TSQLTypeSet);
begin T := Self.TypesRequiringQuotes; end;

(*----------------------------------------------------------------------------*)
procedure TTypeRegistryKnownSQLTypes_R(Self: TTypeRegistry; var T: TSQLTypeSet);
begin T := Self.KnownSQLTypes; end;

(*----------------------------------------------------------------------------*)
procedure TTypeRegistrySQLKeyword_R(Self: TTypeRegistry; var T: WideString; const t1: TSQLType);
begin T := Self.SQLKeyword[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTypeRegistryMapsTo_R(Self: TTypeRegistry; var T: TFieldType; const t1: TSQLType);
begin T := Self.MapsTo[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTypeRegistryTypeInfo_R(Self: TTypeRegistry; var T: TDBTypeInfo; const t1: TSQLType);
begin T := Self.TypeInfo[t1]; end;

(*----------------------------------------------------------------------------*)
Function TTypeRegistryGetTypeDDL7_P(Self: TTypeRegistry;  ASQLType : TSQLType; Precision : Integer; Scale : Integer) : WideString;
Begin Result := Self.GetTypeDDL(ASQLType, Precision, Scale); END;

(*----------------------------------------------------------------------------*)
Function TTypeRegistryGetTypeDDL6_P(Self: TTypeRegistry;  ASQLType : TSQLType; Length : Integer) : WideString;
Begin Result := Self.GetTypeDDL(ASQLType, Length); END;

(*----------------------------------------------------------------------------*)
Function TTypeRegistryGetTypeDDL5_P(Self: TTypeRegistry;  ASQLType : TSQLType) : WideString;
Begin Result := Self.GetTypeDDL(ASQLType); END;

(*----------------------------------------------------------------------------*)
procedure TColumnInfoScale_R(Self: TColumnInfo; var T: Integer);
begin T := Self.Scale; end;

(*----------------------------------------------------------------------------*)
procedure TColumnInfoPrecision_R(Self: TColumnInfo; var T: Integer);
begin T := Self.Precision; end;

(*----------------------------------------------------------------------------*)
procedure TColumnInfoLength_R(Self: TColumnInfo; var T: Integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TColumnInfoSQLType_R(Self: TColumnInfo; var T: TSQLType);
begin T := Self.SQLType; end;

(*----------------------------------------------------------------------------*)
procedure TColumnInfoFieldName_W(Self: TColumnInfo; const T: WideString);
begin Self.FieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure TColumnInfoFieldName_R(Self: TColumnInfo; var T: WideString);
begin T := Self.FieldName; end;

(*----------------------------------------------------------------------------*)
Function TColumnInfoCreate4_P(Self: TClass; CreateNewInstance: Boolean;  AColumn : TColumnInfo):TObject;
Begin Result := TColumnInfo.Create(AColumn); END;

(*----------------------------------------------------------------------------*)
Function TColumnInfoCreate3_P(Self: TClass; CreateNewInstance: Boolean;  ASqlType : TSQLType; APrecision : Integer; AScale : Integer):TObject;
Begin Result := TColumnInfo.Create(ASqlType, APrecision, AScale); END;

(*----------------------------------------------------------------------------*)
Function TColumnInfoCreate2_P(Self: TClass; CreateNewInstance: Boolean;  ASqlType : TSQLType; ALength : Integer):TObject;
Begin Result := TColumnInfo.Create(ASqlType, ALength); END;

(*----------------------------------------------------------------------------*)
Function TColumnInfoCreate1_P(Self: TClass; CreateNewInstance: Boolean;  ASqlType : TSQLType):TObject;
Begin Result := TColumnInfo.Create(ASqlType); END;

(*----------------------------------------------------------------------------*)
Function TColumnInfoCreate0_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TColumnInfo.Create; END;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoIsNullable_W(Self: TDBTypeInfo; const T: Boolean);
begin Self.IsNullable := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoIsNullable_R(Self: TDBTypeInfo; var T: Boolean);
begin T := Self.IsNullable; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoUsesParenthesis_W(Self: TDBTypeInfo; const T: Boolean);
begin Self.UsesParenthesis := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoUsesParenthesis_R(Self: TDBTypeInfo; var T: Boolean);
begin T := Self.UsesParenthesis; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoRequiresQuotes_W(Self: TDBTypeInfo; const T: Boolean);
begin Self.RequiresQuotes := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoRequiresQuotes_R(Self: TDBTypeInfo; var T: Boolean);
begin T := Self.RequiresQuotes; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoSupportsLength_W(Self: TDBTypeInfo; const T: Boolean);
begin Self.SupportsLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoSupportsLength_R(Self: TDBTypeInfo; var T: Boolean);
begin T := Self.SupportsLength; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoSupportsScale_W(Self: TDBTypeInfo; const T: Boolean);
begin Self.SupportsScale := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoSupportsScale_R(Self: TDBTypeInfo; var T: Boolean);
begin T := Self.SupportsScale; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoSupportsPrecision_W(Self: TDBTypeInfo; const T: Boolean);
begin Self.SupportsPrecision := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoSupportsPrecision_R(Self: TDBTypeInfo; var T: Boolean);
begin T := Self.SupportsPrecision; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoHasSimpleTypeDDL_W(Self: TDBTypeInfo; const T: Boolean);
begin Self.HasSimpleTypeDDL := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeInfoHasSimpleTypeDDL_R(Self: TDBTypeInfo; var T: Boolean);
begin T := Self.HasSimpleTypeDDL; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataGenerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataGenerator) do begin
    RegisterConstructor(@TDataGenerator.Create, 'Create');
    RegisterVirtualMethod(@TDataGenerator.GetString, 'GetString');
    RegisterVirtualMethod(@TDataGenerator.GetBoolean, 'GetBoolean');
    RegisterVirtualMethod(@TDataGenerator.GetDateTime, 'GetDateTime');
    RegisterVirtualMethod(@TDataGenerator.GetDate, 'GetDate');
    RegisterVirtualMethod(@TDataGenerator.GetTime, 'GetTime');
    RegisterVirtualMethod(@TDataGenerator.GetTimeStamp, 'GetTimeStamp');
    RegisterVirtualMethod(@TDataGenerator.GetWideString, 'GetWideString');
    RegisterVirtualMethod(@TDataGenerator.GetInt16, 'GetInt16');
    RegisterVirtualMethod(@TDataGenerator.GetInt32, 'GetInt32');
    RegisterVirtualMethod(@TDataGenerator.GetInt64, 'GetInt64');
    RegisterVirtualMethod(@TDataGenerator.GetDouble, 'GetDouble');
    RegisterVirtualMethod(@TDataGenerator.GetFMTBcd, 'GetFMTBcd');
    RegisterVirtualMethod(@TDataGenerator.GetByteArray, 'GetByteArray');
    RegisterMethod(@TDataGenerator.GetValueForType, 'GetValueForType');
    RegisterMethod(@TDataGeneratorGenerateValuesForRow8_P, 'GenerateValuesForRow8');
    RegisterMethod(@TDataGenerator.AssignParamValue, 'AssignParamValue');
    RegisterMethod(@TDataGenerator.ResetSeed, 'ResetSeed');
    RegisterMethod(@TDataGenerator.LockSeed, 'LockSeed');
    RegisterMethod(@TDataGenerator.UnlockSeed, 'UnlockSeed');
    RegisterMethod(@TDataGenerator.Next, 'Next');
    RegisterPropertyHelper(@TDataGeneratorSeedValue_R,@TDataGeneratorSeedValue_W,'SeedValue');
    RegisterPropertyHelper(@TDataGeneratorGeneratorMode_R,nil,'GeneratorMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBaseDialect(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBaseDialect) do begin
    RegisterConstructor(@TBaseDialect.Create, 'Create');
     RegisterMethod(@TBaseDialect.Destroy, 'Free');
     RegisterMethod(@TBaseDialect.MakeCreateStatementForTypes, 'MakeCreateStatementForTypes');
    RegisterMethod(@TBaseDialect.MakeCreateStatementForSQLTypes, 'MakeCreateStatementForSQLTypes');
    RegisterVirtualMethod(@TBaseDialect.DropTableCommand, 'DropTableCommand');
    RegisterVirtualMethod(@TBaseDialect.InsertIntoStatement, 'InsertIntoStatement');
    RegisterVirtualMethod(@TBaseDialect.Compare, 'Compare');
    RegisterVirtualMethod(@TBaseDialect.GetTypeInfo, 'GetTypeInfo');
    RegisterVirtualMethod(@TBaseDialect.QuoteStr, 'QuoteStr');
    RegisterPropertyHelper(@TBaseDialectRegisteredTypes_R,nil,'RegisteredTypes');
    RegisterPropertyHelper(@TBaseDialectMasterRowCount_R,@TBaseDialectMasterRowCount_W,'MasterRowCount');
    RegisterPropertyHelper(@TBaseDialectDefaultLength_R,@TBaseDialectDefaultLength_W,'DefaultLength');
    RegisterPropertyHelper(@TBaseDialectDefaultPrecision_R,@TBaseDialectDefaultPrecision_W,'DefaultPrecision');
    RegisterPropertyHelper(@TBaseDialectDefaultScale_R,@TBaseDialectDefaultScale_W,'DefaultScale');
    RegisterPropertyHelper(@TBaseDialectDefaultSeed_R,@TBaseDialectDefaultSeed_W,'DefaultSeed');
    RegisterPropertyHelper(@TBaseDialectConnectionName_R,@TBaseDialectConnectionName_W,'ConnectionName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTypeRegistry(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTypeRegistry) do begin
    RegisterConstructor(@TTypeRegistry.Create, 'Create');
    RegisterMethod(@TTypeRegistry.RegisterSQLType, 'RegisterSQLType');
    RegisterMethod(@TTypeRegistry.UnregisterSQLType, 'UnregisterSQLType');
    RegisterMethod(@TTypeRegistryGetTypeDDL5_P, 'GetTypeDDL5');
    RegisterMethod(@TTypeRegistryGetTypeDDL6_P, 'GetTypeDDL6');
    RegisterMethod(@TTypeRegistryGetTypeDDL7_P, 'GetTypeDDL7');
    RegisterMethod(@TTypeRegistry.GetSQLType, 'GetSQLType');
    RegisterPropertyHelper(@TTypeRegistryTypeInfo_R,nil,'TypeInfo');
    RegisterPropertyHelper(@TTypeRegistryMapsTo_R,nil,'MapsTo');
    RegisterPropertyHelper(@TTypeRegistrySQLKeyword_R,nil,'SQLKeyword');
    RegisterPropertyHelper(@TTypeRegistryKnownSQLTypes_R,nil,'KnownSQLTypes');
    RegisterPropertyHelper(@TTypeRegistryTypesRequiringQuotes_R,nil,'TypesRequiringQuotes');
    RegisterPropertyHelper(@TTypeRegistryCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TColumnInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TColumnInfo) do begin
    RegisterConstructor(@TColumnInfoCreate0_P, 'Create');
    RegisterConstructor(@TColumnInfoCreate1_P, 'Create1');
    RegisterConstructor(@TColumnInfoCreate2_P, 'Create2');
    RegisterConstructor(@TColumnInfoCreate3_P, 'Create3');
    RegisterConstructor(@TColumnInfoCreate4_P, 'Create4');
    RegisterPropertyHelper(@TColumnInfoFieldName_R,@TColumnInfoFieldName_W,'FieldName');
    RegisterPropertyHelper(@TColumnInfoSQLType_R,nil,'SQLType');
    RegisterPropertyHelper(@TColumnInfoLength_R,nil,'Length');
    RegisterPropertyHelper(@TColumnInfoPrecision_R,nil,'Precision');
    RegisterPropertyHelper(@TColumnInfoScale_R,nil,'Scale');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTypeInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDBTypeInfo) do begin
    RegisterConstructor(@TDBTypeInfo.Create, 'Create');
    RegisterPropertyHelper(@TTypeInfoHasSimpleTypeDDL_R,@TTypeInfoHasSimpleTypeDDL_W,'HasSimpleTypeDDL');
    RegisterPropertyHelper(@TTypeInfoSupportsPrecision_R,@TTypeInfoSupportsPrecision_W,'SupportsPrecision');
    RegisterPropertyHelper(@TTypeInfoSupportsScale_R,@TTypeInfoSupportsScale_W,'SupportsScale');
    RegisterPropertyHelper(@TTypeInfoSupportsLength_R,@TTypeInfoSupportsLength_W,'SupportsLength');
    RegisterPropertyHelper(@TTypeInfoRequiresQuotes_R,@TTypeInfoRequiresQuotes_W,'RequiresQuotes');
    RegisterPropertyHelper(@TTypeInfoUsesParenthesis_R,@TTypeInfoUsesParenthesis_W,'UsesParenthesis');
    RegisterPropertyHelper(@TTypeInfoIsNullable_R,@TTypeInfoIsNullable_W,'IsNullable');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VendorTestFramework(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTypeInfo(CL);
  with CL.Add(TColumnInfo) do
  RIRegister_TColumnInfo(CL);
  with CL.Add(ETypeRegistryException) do
  with CL.Add(EInvalidRegistrationException) do
  RIRegister_TTypeRegistry(CL);
  with CL.Add(TBaseDialect) do
  RIRegister_TBaseDialect(CL);
  RIRegister_TDataGenerator(CL);
end;

 
 
{ TPSImport_VendorTestFramework }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VendorTestFramework.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VendorTestFramework(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VendorTestFramework.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_VendorTestFramework(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
