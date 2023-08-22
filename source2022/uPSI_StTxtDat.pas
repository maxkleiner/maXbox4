unit uPSI_StTxtDat;
{
TStTextDataRecordSet      add free
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
  TPSImport_StTxtDat = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStTextDataRecordSet(CL: TPSPascalCompiler);
procedure SIRegister_TStTextDataRecord(CL: TPSPascalCompiler);
procedure SIRegister_TStTextDataSchema(CL: TPSPascalCompiler);
procedure SIRegister_TStDataFieldList(CL: TPSPascalCompiler);
procedure SIRegister_TStDataField(CL: TPSPascalCompiler);
procedure SIRegister_StTxtDat(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StTxtDat_Routines(S: TPSExec);
procedure RIRegister_TStTextDataRecordSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStTextDataRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStTextDataSchema(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStDataFieldList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStDataField(CL: TPSRuntimeClassImporter);
procedure RIRegister_StTxtDat(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   TypInfo
  ,StConst
  ,StBase
  ,StStrms
  ,StStrL
  ,StTxtDat
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StTxtDat]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStTextDataRecordSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStTextDataRecordSet') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStTextDataRecordSet') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Append');
    RegisterMethod('Procedure AppendArray( Values : array of const)');
    RegisterMethod('Procedure AppendList( Items : TStrings)');
    RegisterMethod('Procedure AppendValues( Values : TStrings)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Procedure Insert( Index : Integer)');
    RegisterMethod('Procedure InsertArray( Index : Integer; Values : array of const)');
    RegisterMethod('Procedure InsertList( Index : Integer; Items : TStrings)');
    RegisterMethod('Procedure InsertValues( Index : Integer; Values : TStrings)');
    RegisterMethod('Function BOF : Boolean');
    RegisterMethod('Function EOF : Boolean');
    RegisterMethod('Procedure First');
    RegisterMethod('Procedure Last');
    RegisterMethod('Function Next : Boolean');
    RegisterMethod('Function Prior : Boolean');
    RegisterMethod('Procedure LoadFromFile( const AFile : TFileName)');
    RegisterMethod('Procedure LoadFromStream( AStream : TStream)');
    RegisterMethod('Procedure SaveToFile( const AFile : TFileName)');
    RegisterMethod('Procedure SaveToStream( AStream : TStream)');
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('CurrentRecord', 'TStTextDataRecord', iptrw);
    RegisterProperty('IsDirty', 'Boolean', iptr);
    RegisterProperty('Records', 'TStTextDataRecord Integer', iptrw);
    RegisterProperty('Schema', 'TStTextDataSchema', iptrw);
    RegisterProperty('IgnoreStartingLines', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStTextDataRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStTextDataRecord') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStTextDataRecord') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure BuildRecord( Values : TStrings; var NewRecord : AnsiString)');
    RegisterMethod('Function GetRecord : AnsiString');
    RegisterMethod('Procedure DoQuote( var Value : AnsiString)');
    RegisterMethod('Procedure FillRecordFromArray( Values : array of const)');
    RegisterMethod('Procedure FillRecordFromList( Items : TStrings)');
    RegisterMethod('Procedure FillRecordFromValues( Values : TStrings)');
    RegisterMethod('Procedure MakeEmpty');
    RegisterProperty('AsString', 'AnsiString', iptr);
    RegisterProperty('FieldByName', 'AnsiString AnsiString', iptrw);
    RegisterProperty('FieldCount', 'Integer', iptr);
    RegisterProperty('FieldList', 'TStrings', iptr);
    RegisterProperty('Fields', 'AnsiString Integer', iptrw);
    RegisterProperty('QuoteAlways', 'Boolean', iptrw);
    RegisterProperty('QuoteIfSpaces', 'Boolean', iptrw);
    RegisterProperty('Schema', 'TStTextDataSchema', iptrw);
    RegisterProperty('Values', 'TStrings', iptr);
    RegisterProperty('OnQuoteField', 'TStOnQuoteFieldEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStTextDataSchema(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStTextDataSchema') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStTextDataSchema') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Assign( ASchema : TStTextDataSchema)');
    RegisterMethod('Procedure AddField( const FieldName : AnsiString; FieldType : TStSchemaFieldType; FieldLen, FieldDecimals : Integer)');
    RegisterMethod('Function IndexOf( const FieldName : AnsiString) : Integer');
    RegisterMethod('Procedure RemoveField( const FieldName : AnsiString)');
    RegisterMethod('Procedure Update( AList : TStrings)');
    RegisterMethod('Procedure ClearFields');
    RegisterMethod('Procedure BuildSchema( AList : TStrings)');
    RegisterMethod('Procedure LoadFromFile( const AFileName : TFileName)');
    RegisterMethod('Procedure LoadFromStream( AStream : TStream)');
    RegisterMethod('Procedure SaveToFile( const AFileName : TFileName)');
    RegisterMethod('Procedure SaveToStream( AStream : TStream)');
    RegisterProperty('Captions', 'TStrings', iptr);
    RegisterProperty('CommentDelimiter', 'AnsiChar', iptrw);
    RegisterProperty('FieldByName', 'TStDataField AnsiString', iptrw);
    RegisterProperty('FieldCount', 'Integer', iptr);
    RegisterProperty('FieldDelimiter', 'AnsiChar', iptrw);
    RegisterProperty('Fields', 'TStDataField Integer', iptrw);
    SetDefaultPropery('Fields');
    RegisterProperty('LayoutType', 'TStSchemaLayoutType', iptrw);
    RegisterProperty('LineTermChar', 'AnsiChar', iptrw);
    RegisterProperty('LineTerminator', 'TStLineTerminator', iptrw);
    RegisterProperty('QuoteDelimiter', 'AnsiChar', iptrw);
    RegisterProperty('FixedSeparator', 'AnsiChar', iptrw);
    RegisterProperty('Schema', 'TStrings', iptrw);
    RegisterProperty('SchemaName', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDataFieldList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStDataFieldList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStDataFieldList') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure AddField( const FieldName : AnsiString; FieldType : TStSchemaFieldType; FieldLen, FieldDecimals, FieldOffset : Integer)');
    RegisterMethod('Procedure AddFieldStr( const FieldDef : AnsiString)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure RemoveField( const FieldName : AnsiString)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Fields', 'TStDataField Integer', iptrw);
    SetDefaultPropery('Fields');
    RegisterProperty('FieldByName', 'TStDataField AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStDataField(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStDataField') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStDataField') do begin
    RegisterProperty('AsString', 'AnsiString', iptr);
    RegisterProperty('FieldDecimals', 'Integer', iptrw);
    RegisterProperty('FieldLen', 'Integer', iptrw);
    RegisterProperty('FieldName', 'AnsiString', iptrw);
    RegisterProperty('FieldOffset', 'Integer', iptrw);
    RegisterProperty('FieldType', 'TStSchemaFieldType', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StTxtDat(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('StDefaultDelim','String').SetString( ',');
 CL.AddConstantN('StDefaultQuote','String').SetString( '"');
 CL.AddConstantN('StDefaultComment','String').SetString( ';');
 CL.AddConstantN('StDefaultFixedSep','String').SetString( ' ');
 CL.AddConstantN('StDefaultLineTerm','String').SetString( #13#10);
 CL.AddConstantN('St_WhiteSpace','String').SetString( #8#9#10#13);
  CL.AddTypeS('TStSchemaLayoutType', '( ltUnknown, ltFixed, ltVarying )');
  CL.AddTypeS('TStSchemaFieldType', '( sftUnknown, sftChar, sftFloat, sftNumber'
   +', sftBool, sftLongInt, sftDate, sftTime, sftTimeStamp )');
  CL.AddTypeS('TStOnQuoteFieldEvent', 'Procedure ( Sender : TObject; var Field : AnsiString)');
  SIRegister_TStDataField(CL);
  SIRegister_TStDataFieldList(CL);
  SIRegister_TStTextDataSchema(CL);
  SIRegister_TStTextDataRecord(CL);
  SIRegister_TStTextDataRecordSet(CL);
 CL.AddDelphiFunction('Procedure StParseLine( const Data : AnsiString; Schema : TStTextDataSchema; Result : TStrings)');
 CL.AddDelphiFunction('Function StFieldTypeToStr( FieldType : TStSchemaFieldType) : AnsiString');
 CL.AddDelphiFunction('Function StStrToFieldType( const S : AnsiString) : TStSchemaFieldType');
 CL.AddDelphiFunction('Function StDeEscape( const EscStr : AnsiString) : Char');
 CL.AddDelphiFunction('Function StDoEscape( Delim : Char) : AnsiString');
 CL.AddDelphiFunction('Function StTrimTrailingChars( const S : AnsiString; Trailer : Char) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetIgnoreStartingLines_W(Self: TStTextDataRecordSet; const T: Integer);
begin Self.IgnoreStartingLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetIgnoreStartingLines_R(Self: TStTextDataRecordSet; var T: Integer);
begin T := Self.IgnoreStartingLines; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetSchema_W(Self: TStTextDataRecordSet; const T: TStTextDataSchema);
begin Self.Schema := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetSchema_R(Self: TStTextDataRecordSet; var T: TStTextDataSchema);
begin T := Self.Schema; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetRecords_W(Self: TStTextDataRecordSet; const T: TStTextDataRecord; const t1: Integer);
begin Self.Records[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetRecords_R(Self: TStTextDataRecordSet; var T: TStTextDataRecord; const t1: Integer);
begin T := Self.Records[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetIsDirty_R(Self: TStTextDataRecordSet; var T: Boolean);
begin T := Self.IsDirty; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetCurrentRecord_W(Self: TStTextDataRecordSet; const T: TStTextDataRecord);
begin Self.CurrentRecord := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetCurrentRecord_R(Self: TStTextDataRecordSet; var T: TStTextDataRecord);
begin T := Self.CurrentRecord; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetCount_R(Self: TStTextDataRecordSet; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetActive_W(Self: TStTextDataRecordSet; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSetActive_R(Self: TStTextDataRecordSet; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordOnQuoteField_W(Self: TStTextDataRecord; const T: TStOnQuoteFieldEvent);
begin Self.OnQuoteField := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordOnQuoteField_R(Self: TStTextDataRecord; var T: TStOnQuoteFieldEvent);
begin T := Self.OnQuoteField; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordValues_R(Self: TStTextDataRecord; var T: TStrings);
begin T := Self.Values; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSchema_W(Self: TStTextDataRecord; const T: TStTextDataSchema);
begin Self.Schema := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordSchema_R(Self: TStTextDataRecord; var T: TStTextDataSchema);
begin T := Self.Schema; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordQuoteIfSpaces_W(Self: TStTextDataRecord; const T: Boolean);
begin Self.QuoteIfSpaces := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordQuoteIfSpaces_R(Self: TStTextDataRecord; var T: Boolean);
begin T := Self.QuoteIfSpaces; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordQuoteAlways_W(Self: TStTextDataRecord; const T: Boolean);
begin Self.QuoteAlways := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordQuoteAlways_R(Self: TStTextDataRecord; var T: Boolean);
begin T := Self.QuoteAlways; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordFields_W(Self: TStTextDataRecord; const T: AnsiString; const t1: Integer);
begin Self.Fields[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordFields_R(Self: TStTextDataRecord; var T: AnsiString; const t1: Integer);
begin T := Self.Fields[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordFieldList_R(Self: TStTextDataRecord; var T: TStrings);
begin T := Self.FieldList; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordFieldCount_R(Self: TStTextDataRecord; var T: Integer);
begin T := Self.FieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordFieldByName_W(Self: TStTextDataRecord; const T: AnsiString; const t1: AnsiString);
begin Self.FieldByName[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordFieldByName_R(Self: TStTextDataRecord; var T: AnsiString; const t1: AnsiString);
begin T := Self.FieldByName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataRecordAsString_R(Self: TStTextDataRecord; var T: AnsiString);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaSchemaName_W(Self: TStTextDataSchema; const T: AnsiString);
begin Self.SchemaName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaSchemaName_R(Self: TStTextDataSchema; var T: AnsiString);
begin T := Self.SchemaName; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaSchema_W(Self: TStTextDataSchema; const T: TStrings);
begin Self.Schema := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaSchema_R(Self: TStTextDataSchema; var T: TStrings);
begin T := Self.Schema; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFixedSeparator_W(Self: TStTextDataSchema; const T: AnsiChar);
begin Self.FixedSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFixedSeparator_R(Self: TStTextDataSchema; var T: AnsiChar);
begin T := Self.FixedSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaQuoteDelimiter_W(Self: TStTextDataSchema; const T: AnsiChar);
begin Self.QuoteDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaQuoteDelimiter_R(Self: TStTextDataSchema; var T: AnsiChar);
begin T := Self.QuoteDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaLineTerminator_W(Self: TStTextDataSchema; const T: TStLineTerminator);
begin Self.LineTerminator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaLineTerminator_R(Self: TStTextDataSchema; var T: TStLineTerminator);
begin T := Self.LineTerminator; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaLineTermChar_W(Self: TStTextDataSchema; const T: AnsiChar);
begin Self.LineTermChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaLineTermChar_R(Self: TStTextDataSchema; var T: AnsiChar);
begin T := Self.LineTermChar; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaLayoutType_W(Self: TStTextDataSchema; const T: TStSchemaLayoutType);
begin Self.LayoutType := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaLayoutType_R(Self: TStTextDataSchema; var T: TStSchemaLayoutType);
begin T := Self.LayoutType; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFields_W(Self: TStTextDataSchema; const T: TStDataField; const t1: Integer);
begin Self.Fields[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFields_R(Self: TStTextDataSchema; var T: TStDataField; const t1: Integer);
begin T := Self.Fields[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFieldDelimiter_W(Self: TStTextDataSchema; const T: AnsiChar);
begin Self.FieldDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFieldDelimiter_R(Self: TStTextDataSchema; var T: AnsiChar);
begin T := Self.FieldDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFieldCount_R(Self: TStTextDataSchema; var T: Integer);
begin T := Self.FieldCount; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFieldByName_W(Self: TStTextDataSchema; const T: TStDataField; const t1: AnsiString);
begin Self.FieldByName[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaFieldByName_R(Self: TStTextDataSchema; var T: TStDataField; const t1: AnsiString);
begin T := Self.FieldByName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaCommentDelimiter_W(Self: TStTextDataSchema; const T: AnsiChar);
begin Self.CommentDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaCommentDelimiter_R(Self: TStTextDataSchema; var T: AnsiChar);
begin T := Self.CommentDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TStTextDataSchemaCaptions_R(Self: TStTextDataSchema; var T: TStrings);
begin T := Self.Captions; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldListFieldByName_W(Self: TStDataFieldList; const T: TStDataField; const t1: AnsiString);
begin Self.FieldByName[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldListFieldByName_R(Self: TStDataFieldList; var T: TStDataField; const t1: AnsiString);
begin T := Self.FieldByName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldListFields_W(Self: TStDataFieldList; const T: TStDataField; const t1: Integer);
begin Self.Fields[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldListFields_R(Self: TStDataFieldList; var T: TStDataField; const t1: Integer);
begin T := Self.Fields[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldListCount_R(Self: TStDataFieldList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldType_W(Self: TStDataField; const T: TStSchemaFieldType);
begin Self.FieldType := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldType_R(Self: TStDataField; var T: TStSchemaFieldType);
begin T := Self.FieldType; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldOffset_W(Self: TStDataField; const T: Integer);
begin Self.FieldOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldOffset_R(Self: TStDataField; var T: Integer);
begin T := Self.FieldOffset; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldName_W(Self: TStDataField; const T: AnsiString);
begin Self.FieldName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldName_R(Self: TStDataField; var T: AnsiString);
begin T := Self.FieldName; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldLen_W(Self: TStDataField; const T: Integer);
begin Self.FieldLen := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldLen_R(Self: TStDataField; var T: Integer);
begin T := Self.FieldLen; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldDecimals_W(Self: TStDataField; const T: Integer);
begin Self.FieldDecimals := T; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldFieldDecimals_R(Self: TStDataField; var T: Integer);
begin T := Self.FieldDecimals; end;

(*----------------------------------------------------------------------------*)
procedure TStDataFieldAsString_R(Self: TStDataField; var T: AnsiString);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StTxtDat_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StParseLine, 'StParseLine', cdRegister);
 S.RegisterDelphiFunction(@StFieldTypeToStr, 'StFieldTypeToStr', cdRegister);
 S.RegisterDelphiFunction(@StStrToFieldType, 'StStrToFieldType', cdRegister);
 S.RegisterDelphiFunction(@StDeEscape, 'StDeEscape', cdRegister);
 S.RegisterDelphiFunction(@StDoEscape, 'StDoEscape', cdRegister);
 S.RegisterDelphiFunction(@StTrimTrailingChars, 'StTrimTrailingChars', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStTextDataRecordSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStTextDataRecordSet) do begin
    RegisterConstructor(@TStTextDataRecordSet.Create, 'Create');
     RegisterMethod(@TStTextDataRecordSet.Destroy, 'Free');
       RegisterMethod(@TStTextDataRecordSet.Append, 'Append');
    RegisterMethod(@TStTextDataRecordSet.AppendArray, 'AppendArray');
    RegisterMethod(@TStTextDataRecordSet.AppendList, 'AppendList');
    RegisterMethod(@TStTextDataRecordSet.AppendValues, 'AppendValues');
    RegisterMethod(@TStTextDataRecordSet.Clear, 'Clear');
    RegisterMethod(@TStTextDataRecordSet.Delete, 'Delete');
    RegisterMethod(@TStTextDataRecordSet.Insert, 'Insert');
    RegisterMethod(@TStTextDataRecordSet.InsertArray, 'InsertArray');
    RegisterMethod(@TStTextDataRecordSet.InsertList, 'InsertList');
    RegisterMethod(@TStTextDataRecordSet.InsertValues, 'InsertValues');
    RegisterMethod(@TStTextDataRecordSet.BOF, 'BOF');
    RegisterMethod(@TStTextDataRecordSet.EOF, 'EOF');
    RegisterMethod(@TStTextDataRecordSet.First, 'First');
    RegisterMethod(@TStTextDataRecordSet.Last, 'Last');
    RegisterMethod(@TStTextDataRecordSet.Next, 'Next');
    RegisterMethod(@TStTextDataRecordSet.Prior, 'Prior');
    RegisterMethod(@TStTextDataRecordSet.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TStTextDataRecordSet.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStTextDataRecordSet.SaveToFile, 'SaveToFile');
    RegisterMethod(@TStTextDataRecordSet.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TStTextDataRecordSetActive_R,@TStTextDataRecordSetActive_W,'Active');
    RegisterPropertyHelper(@TStTextDataRecordSetCount_R,nil,'Count');
    RegisterPropertyHelper(@TStTextDataRecordSetCurrentRecord_R,@TStTextDataRecordSetCurrentRecord_W,'CurrentRecord');
    RegisterPropertyHelper(@TStTextDataRecordSetIsDirty_R,nil,'IsDirty');
    RegisterPropertyHelper(@TStTextDataRecordSetRecords_R,@TStTextDataRecordSetRecords_W,'Records');
    RegisterPropertyHelper(@TStTextDataRecordSetSchema_R,@TStTextDataRecordSetSchema_W,'Schema');
    RegisterPropertyHelper(@TStTextDataRecordSetIgnoreStartingLines_R,@TStTextDataRecordSetIgnoreStartingLines_W,'IgnoreStartingLines');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStTextDataRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStTextDataRecord) do begin
    RegisterConstructor(@TStTextDataRecord.Create, 'Create');
     RegisterMethod(@TStTextDataRecord.Destroy, 'Free');
       RegisterVirtualMethod(@TStTextDataRecord.BuildRecord, 'BuildRecord');
    RegisterMethod(@TStTextDataRecord.GetRecord, 'GetRecord');
    RegisterVirtualMethod(@TStTextDataRecord.DoQuote, 'DoQuote');
    RegisterMethod(@TStTextDataRecord.FillRecordFromArray, 'FillRecordFromArray');
    RegisterMethod(@TStTextDataRecord.FillRecordFromList, 'FillRecordFromList');
    RegisterMethod(@TStTextDataRecord.FillRecordFromValues, 'FillRecordFromValues');
    RegisterVirtualMethod(@TStTextDataRecord.MakeEmpty, 'MakeEmpty');
    RegisterPropertyHelper(@TStTextDataRecordAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TStTextDataRecordFieldByName_R,@TStTextDataRecordFieldByName_W,'FieldByName');
    RegisterPropertyHelper(@TStTextDataRecordFieldCount_R,nil,'FieldCount');
    RegisterPropertyHelper(@TStTextDataRecordFieldList_R,nil,'FieldList');
    RegisterPropertyHelper(@TStTextDataRecordFields_R,@TStTextDataRecordFields_W,'Fields');
    RegisterPropertyHelper(@TStTextDataRecordQuoteAlways_R,@TStTextDataRecordQuoteAlways_W,'QuoteAlways');
    RegisterPropertyHelper(@TStTextDataRecordQuoteIfSpaces_R,@TStTextDataRecordQuoteIfSpaces_W,'QuoteIfSpaces');
    RegisterPropertyHelper(@TStTextDataRecordSchema_R,@TStTextDataRecordSchema_W,'Schema');
    RegisterPropertyHelper(@TStTextDataRecordValues_R,nil,'Values');
    RegisterPropertyHelper(@TStTextDataRecordOnQuoteField_R,@TStTextDataRecordOnQuoteField_W,'OnQuoteField');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStTextDataSchema(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStTextDataSchema) do begin
    RegisterConstructor(@TStTextDataSchema.Create, 'Create');
     RegisterMethod(@TStTextDataSchema.Destroy, 'Free');
       RegisterMethod(@TStTextDataSchema.Assign, 'Assign');
    RegisterMethod(@TStTextDataSchema.AddField, 'AddField');
    RegisterMethod(@TStTextDataSchema.IndexOf, 'IndexOf');
    RegisterMethod(@TStTextDataSchema.RemoveField, 'RemoveField');
    RegisterMethod(@TStTextDataSchema.Update, 'Update');
    RegisterMethod(@TStTextDataSchema.ClearFields, 'ClearFields');
    RegisterMethod(@TStTextDataSchema.BuildSchema, 'BuildSchema');
    RegisterMethod(@TStTextDataSchema.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TStTextDataSchema.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TStTextDataSchema.SaveToFile, 'SaveToFile');
    RegisterMethod(@TStTextDataSchema.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TStTextDataSchemaCaptions_R,nil,'Captions');
    RegisterPropertyHelper(@TStTextDataSchemaCommentDelimiter_R,@TStTextDataSchemaCommentDelimiter_W,'CommentDelimiter');
    RegisterPropertyHelper(@TStTextDataSchemaFieldByName_R,@TStTextDataSchemaFieldByName_W,'FieldByName');
    RegisterPropertyHelper(@TStTextDataSchemaFieldCount_R,nil,'FieldCount');
    RegisterPropertyHelper(@TStTextDataSchemaFieldDelimiter_R,@TStTextDataSchemaFieldDelimiter_W,'FieldDelimiter');
    RegisterPropertyHelper(@TStTextDataSchemaFields_R,@TStTextDataSchemaFields_W,'Fields');
    RegisterPropertyHelper(@TStTextDataSchemaLayoutType_R,@TStTextDataSchemaLayoutType_W,'LayoutType');
    RegisterPropertyHelper(@TStTextDataSchemaLineTermChar_R,@TStTextDataSchemaLineTermChar_W,'LineTermChar');
    RegisterPropertyHelper(@TStTextDataSchemaLineTerminator_R,@TStTextDataSchemaLineTerminator_W,'LineTerminator');
    RegisterPropertyHelper(@TStTextDataSchemaQuoteDelimiter_R,@TStTextDataSchemaQuoteDelimiter_W,'QuoteDelimiter');
    RegisterPropertyHelper(@TStTextDataSchemaFixedSeparator_R,@TStTextDataSchemaFixedSeparator_W,'FixedSeparator');
    RegisterPropertyHelper(@TStTextDataSchemaSchema_R,@TStTextDataSchemaSchema_W,'Schema');
    RegisterPropertyHelper(@TStTextDataSchemaSchemaName_R,@TStTextDataSchemaSchemaName_W,'SchemaName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDataFieldList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDataFieldList) do begin
    RegisterConstructor(@TStDataFieldList.Create, 'Create');
     RegisterMethod(@TStDataFieldList.Destroy, 'Free');
       RegisterMethod(@TStDataFieldList.AddField, 'AddField');
    RegisterMethod(@TStDataFieldList.AddFieldStr, 'AddFieldStr');
    RegisterMethod(@TStDataFieldList.Clear, 'Clear');
    RegisterMethod(@TStDataFieldList.RemoveField, 'RemoveField');
    RegisterPropertyHelper(@TStDataFieldListCount_R,nil,'Count');
    RegisterPropertyHelper(@TStDataFieldListFields_R,@TStDataFieldListFields_W,'Fields');
    RegisterPropertyHelper(@TStDataFieldListFieldByName_R,@TStDataFieldListFieldByName_W,'FieldByName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStDataField(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStDataField) do
  begin
    RegisterPropertyHelper(@TStDataFieldAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TStDataFieldFieldDecimals_R,@TStDataFieldFieldDecimals_W,'FieldDecimals');
    RegisterPropertyHelper(@TStDataFieldFieldLen_R,@TStDataFieldFieldLen_W,'FieldLen');
    RegisterPropertyHelper(@TStDataFieldFieldName_R,@TStDataFieldFieldName_W,'FieldName');
    RegisterPropertyHelper(@TStDataFieldFieldOffset_R,@TStDataFieldFieldOffset_W,'FieldOffset');
    RegisterPropertyHelper(@TStDataFieldFieldType_R,@TStDataFieldFieldType_W,'FieldType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StTxtDat(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStDataField(CL);
  RIRegister_TStDataFieldList(CL);
  RIRegister_TStTextDataSchema(CL);
  RIRegister_TStTextDataRecord(CL);
  RIRegister_TStTextDataRecordSet(CL);
end;

 
 
{ TPSImport_StTxtDat }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StTxtDat.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StTxtDat(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StTxtDat.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StTxtDat(ri);
  RIRegister_StTxtDat_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
