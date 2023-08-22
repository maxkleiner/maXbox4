unit uPSI_ALStringList;
{
   another list st
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
  TPSImport_ALStringList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TALAVLStringList(CL: TPSPascalCompiler);
procedure SIRegister_TALAVLStringListBinaryTreeNode(CL: TPSPascalCompiler);
procedure SIRegister_TALStringList(CL: TPSPascalCompiler);
procedure SIRegister_TALStrings(CL: TPSPascalCompiler);
procedure SIRegister_TALStringsEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_ALStringList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TALAVLStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALAVLStringListBinaryTreeNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALStrings(CL: TPSRuntimeClassImporter);
procedure RIRegister_TALStringsEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_ALStringList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,AlAvlBinaryTRee
  ,ALStringList
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ALStringList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TALAVLStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALStrings', 'TALAVLStringList') do
  with CL.AddClassN(CL.FindClass('TALStrings'),'TALAVLStringList') do begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( OwnsObjects : Boolean);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function ExtractObject( Index : Integer) : TObject;');
    RegisterMethod('Procedure CustomSort( Compare : TALAVLStringListSortCompare)');
     RegisterMethod('Function Add( const S : AnsiString) : Integer');
    RegisterMethod('Function AddObject( const S : AnsiString; AObject : TObject) : Integer');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Delete( Index : Integer)');
    //RegisterMethod('Function ExtractObject8( Index : Integer) : TObject;');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function IndexOf( const S : AnsiString) : Integer');
    RegisterMethod('Function IndexOfName( const Name : AnsiString) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const S : AnsiString)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const S : AnsiString; AObject : TObject)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    //RegisterMethod('Procedure CustomSort( Compare : TALAVLStringListSortCompare)');
    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
    RegisterProperty('OwnsObjects', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALAVLStringListBinaryTreeNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALStringKeyAVLBinaryTreeNode', 'TALAVLStringListBinaryTreeNode') do
  with CL.AddClassN(CL.FindClass('TALStringKeyAVLBinaryTreeNode'),'TALAVLStringListBinaryTreeNode') do
  begin
    RegisterProperty('Val', 'AnsiString', iptrw);
    RegisterProperty('Obj', 'Tobject', iptrw);
    RegisterProperty('Idx', 'integer', iptrw);
    RegisterProperty('Nvs', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TALStrings', 'TALStringList') do
  with CL.AddClassN(CL.FindClass('TALStrings'),'TALStringList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create1( OwnsObjects : Boolean);');
    RegisterMethod('Function ExtractObject( Index : Integer) : TObject;');
    RegisterMethod('Function Find( const S : AnsiString; var Index : Integer) : Boolean');
    RegisterMethod('Function FindName( const S : AnsiString; var Index : Integer) : Boolean');
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure CustomSort( Compare : TALStringListSortCompare)');
    RegisterMethod('Function AddObject( const S : AnsiString; AObject : TObject) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer)');
    //RegisterMethod('Function ExtractObject5( Index : Integer) : TObject;');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    //RegisterMethod('Function Find( const S : AnsiString; var Index : Integer) : Boolean');
    //RegisterMethod('Function FindName( const S : AnsiString; var Index : Integer) : Boolean');
    RegisterMethod('Function IndexOfName( const Name : AnsiString) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const S : AnsiString)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const S : AnsiString; AObject : TObject)');
    //RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    //RegisterMethod('Procedure Sort');
    //RegisterMethod('Procedure CustomSort( Compare : TALStringListSortCompare)');

    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
    RegisterProperty('OwnsObjects', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALStrings(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TALStrings') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TALStrings') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( const S : AnsiString) : Integer');
    RegisterMethod('Function AddObject( const S : AnsiString; AObject : TObject) : Integer');
    RegisterMethod('Procedure Append( const S : AnsiString)');
    RegisterMethod('Procedure AddStrings( Strings : TALStrings);');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure BeginUpdate');
    //RegisterMethod('Procedure Clear');
    //RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Function Equals( Strings : TALStrings) : Boolean');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function GetEnumerator : TALStringsEnumerator');
    RegisterMethod('Function GetText : PAnsiChar');
    RegisterMethod('Function IndexOf( const S : AnsiString) : Integer');
    RegisterMethod('Function IndexOfName( const Name : AnsiString) : Integer');
    RegisterMethod('Function IndexOfObject( AObject : TObject) : Integer');
    //RegisterMethod('Procedure Insert( Index : Integer; const S : AnsiString)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const S : AnsiString; AObject : TObject)');
    RegisterMethod('Procedure LoadFromFile( const FileName : AnsiString)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Procedure SaveToFile( const FileName : AnsiString)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure SetText( Text : PAnsiChar)');
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('CommaText', 'AnsiString', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Delimiter', 'AnsiChar', iptrw);
    RegisterProperty('DelimitedText', 'AnsiString', iptrw);
    RegisterProperty('LineBreak', 'AnsiString', iptrw);
    RegisterProperty('Names', 'AnsiString Integer', iptr);
    RegisterProperty('StrictNames', 'AnsiString Integer', iptr);
    RegisterProperty('Objects', 'TObject Integer', iptrw);
    RegisterProperty('QuoteChar', 'AnsiChar', iptrw);
    RegisterProperty('Values', 'AnsiString AnsiString', iptrw);
    RegisterProperty('ValueFromIndex', 'AnsiString Integer', iptrw);
    RegisterProperty('PersistentValues', 'AnsiString AnsiString', iptrw);
    RegisterProperty('PersistentValueFromIndex', 'AnsiString Integer', iptrw);
    RegisterProperty('NameValueSeparator', 'AnsiChar', iptrw);
    RegisterProperty('StrictDelimiter', 'Boolean', iptrw);
    RegisterProperty('Strings', 'AnsiString Integer', iptrw);
    SetDefaultPropery('Strings');
    RegisterProperty('Text', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TALStringsEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TALStringsEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TALStringsEnumerator') do
  begin
    RegisterMethod('Constructor Create( AStrings : TALStrings)');
    RegisterMethod('Function GetCurrent : AnsiString');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'AnsiString', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ALStringList(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStringDefined', '( sdDelimiter, sdQuoteChar, sdNameValueSeparator, sdLineBreak, sdStrictDelimiter)');
  CL.AddTypeS('TStringsDefined', 'set of TStringDefined');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALStrings');
  SIRegister_TALStringsEnumerator(CL);
  SIRegister_TALStrings(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALStringList');
  //CL.AddTypeS('PALStringItem', '^TALStringItem // will not work');
  CL.AddTypeS('TALStringItem', 'record FString : AnsiString; FObject : TObject; end');
  CL.AddTypeS('TALStringItemList', 'array of TALStringItem');
  SIRegister_TALStringList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TALAVLStringList');
  SIRegister_TALAVLStringListBinaryTreeNode(CL);
  SIRegister_TALAVLStringList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TALAVLStringListOwnsObjects_W(Self: TALAVLStringList; const T: Boolean);
begin Self.OwnsObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListOwnsObjects_R(Self: TALAVLStringList; var T: Boolean);
begin T := Self.OwnsObjects; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListOnChanging_W(Self: TALAVLStringList; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListOnChanging_R(Self: TALAVLStringList; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListOnChange_W(Self: TALAVLStringList; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListOnChange_R(Self: TALAVLStringList; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListCaseSensitive_W(Self: TALAVLStringList; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListCaseSensitive_R(Self: TALAVLStringList; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListDuplicates_W(Self: TALAVLStringList; const T: TDuplicates);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListDuplicates_R(Self: TALAVLStringList; var T: TDuplicates);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
Function TALAVLStringListExtractObject_P(Self: TALAVLStringList;  Index : Integer) : TObject;
Begin Result := Self.ExtractObject(Index); END;

(*----------------------------------------------------------------------------*)
Function TALAVLStringListCreate1_P(Self: TClass; CreateNewInstance: Boolean;  OwnsObjects : Boolean):TObject;
Begin Result := TALAVLStringList.Create(OwnsObjects); END;

(*----------------------------------------------------------------------------*)
Function TALAVLStringListCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TALAVLStringList.Create; END;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListBinaryTreeNodeNvs_W(Self: TALAVLStringListBinaryTreeNode; const T: Boolean);
Begin Self.Nvs := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListBinaryTreeNodeNvs_R(Self: TALAVLStringListBinaryTreeNode; var T: Boolean);
Begin T := Self.Nvs; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListBinaryTreeNodeIdx_W(Self: TALAVLStringListBinaryTreeNode; const T: integer);
Begin Self.Idx := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListBinaryTreeNodeIdx_R(Self: TALAVLStringListBinaryTreeNode; var T: integer);
Begin T := Self.Idx; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListBinaryTreeNodeObj_W(Self: TALAVLStringListBinaryTreeNode; const T: Tobject);
Begin Self.Obj := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListBinaryTreeNodeObj_R(Self: TALAVLStringListBinaryTreeNode; var T: Tobject);
Begin T := Self.Obj; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListBinaryTreeNodeVal_W(Self: TALAVLStringListBinaryTreeNode; const T: AnsiString);
Begin Self.Val := T; end;

(*----------------------------------------------------------------------------*)
procedure TALAVLStringListBinaryTreeNodeVal_R(Self: TALAVLStringListBinaryTreeNode; var T: AnsiString);
Begin T := Self.Val; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListOwnsObjects_W(Self: TALStringList; const T: Boolean);
begin Self.OwnsObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListOwnsObjects_R(Self: TALStringList; var T: Boolean);
begin T := Self.OwnsObjects; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListOnChanging_W(Self: TALStringList; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListOnChanging_R(Self: TALStringList; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListOnChange_W(Self: TALStringList; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListOnChange_R(Self: TALStringList; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListCaseSensitive_W(Self: TALStringList; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListCaseSensitive_R(Self: TALStringList; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListSorted_W(Self: TALStringList; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListSorted_R(Self: TALStringList; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListDuplicates_W(Self: TALStringList; const T: TDuplicates);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringListDuplicates_R(Self: TALStringList; var T: TDuplicates);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
Function TALStringListExtractObject_P(Self: TALStringList;  Index : Integer) : TObject;
Begin Result := Self.ExtractObject(Index); END;

(*----------------------------------------------------------------------------*)
Function TALStringListCreate_P(Self: TClass; CreateNewInstance: Boolean;  OwnsObjects : Boolean):TObject;
Begin Result := TALStringList.Create(OwnsObjects); END;

(*----------------------------------------------------------------------------*)
procedure TALStringsText_W(Self: TALStrings; const T: AnsiString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsText_R(Self: TALStrings; var T: AnsiString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsStrings_W(Self: TALStrings; const T: AnsiString; const t1: Integer);
begin Self.Strings[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsStrings_R(Self: TALStrings; var T: AnsiString; const t1: Integer);
begin T := Self.Strings[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsStrictDelimiter_W(Self: TALStrings; const T: Boolean);
begin Self.StrictDelimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsStrictDelimiter_R(Self: TALStrings; var T: Boolean);
begin T := Self.StrictDelimiter; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsNameValueSeparator_W(Self: TALStrings; const T: AnsiChar);
begin Self.NameValueSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsNameValueSeparator_R(Self: TALStrings; var T: AnsiChar);
begin T := Self.NameValueSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsPersistentValueFromIndex_W(Self: TALStrings; const T: AnsiString; const t1: Integer);
begin Self.PersistentValueFromIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsPersistentValueFromIndex_R(Self: TALStrings; var T: AnsiString; const t1: Integer);
begin T := Self.PersistentValueFromIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsPersistentValues_W(Self: TALStrings; const T: AnsiString; const t1: AnsiString);
begin Self.PersistentValues[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsPersistentValues_R(Self: TALStrings; var T: AnsiString; const t1: AnsiString);
begin T := Self.PersistentValues[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsValueFromIndex_W(Self: TALStrings; const T: AnsiString; const t1: Integer);
begin Self.ValueFromIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsValueFromIndex_R(Self: TALStrings; var T: AnsiString; const t1: Integer);
begin T := Self.ValueFromIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsValues_W(Self: TALStrings; const T: AnsiString; const t1: AnsiString);
begin Self.Values[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsValues_R(Self: TALStrings; var T: AnsiString; const t1: AnsiString);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsQuoteChar_W(Self: TALStrings; const T: AnsiChar);
begin Self.QuoteChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsQuoteChar_R(Self: TALStrings; var T: AnsiChar);
begin T := Self.QuoteChar; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsObjects_W(Self: TALStrings; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsObjects_R(Self: TALStrings; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsStrictNames_R(Self: TALStrings; var T: AnsiString; const t1: Integer);
begin T := Self.StrictNames[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsNames_R(Self: TALStrings; var T: AnsiString; const t1: Integer);
begin T := Self.Names[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsLineBreak_W(Self: TALStrings; const T: AnsiString);
begin Self.LineBreak := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsLineBreak_R(Self: TALStrings; var T: AnsiString);
begin T := Self.LineBreak; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsDelimitedText_W(Self: TALStrings; const T: AnsiString);
begin Self.DelimitedText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsDelimitedText_R(Self: TALStrings; var T: AnsiString);
begin T := Self.DelimitedText; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsDelimiter_W(Self: TALStrings; const T: AnsiChar);
begin Self.Delimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsDelimiter_R(Self: TALStrings; var T: AnsiChar);
begin T := Self.Delimiter; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsCount_R(Self: TALStrings; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsCommaText_W(Self: TALStrings; const T: AnsiString);
begin Self.CommaText := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsCommaText_R(Self: TALStrings; var T: AnsiString);
begin T := Self.CommaText; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsCapacity_W(Self: TALStrings; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TALStringsCapacity_R(Self: TALStrings; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
Procedure TALStringsAddStrings_P(Self: TALStrings;  Strings : TALStrings);
Begin Self.AddStrings(Strings); END;

(*----------------------------------------------------------------------------*)
Procedure TALStringsError1_P(Self: TALStrings;  Msg : PResStringRec; Data : Integer);
Begin //Self.Error(Msg, Data);
END;

(*----------------------------------------------------------------------------*)
Procedure TALStringsError_P(Self: TALStrings;  const Msg : String; Data : Integer);
Begin //Self.Error(Msg, Data);
END;

(*----------------------------------------------------------------------------*)
procedure TALStringsEnumeratorCurrent_R(Self: TALStringsEnumerator; var T: AnsiString);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALAVLStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALAVLStringList) do begin
    RegisterConstructor(@TALAVLStringListCreate_P, 'Create');
    RegisterConstructor(@TALAVLStringListCreate1_P, 'Create1');
    RegisterMethod(@TALAVLStringList.Destroy,'Free');
    RegisterVirtualMethod(@TALAVLStringListExtractObject_P, 'ExtractObject');
    RegisterVirtualMethod(@TALAVLStringList.CustomSort, 'CustomSort');
    RegisterMethod(@TALAVLStringList.Add, 'Add');
  RegisterMethod(@TALAVLStringList.AddObject, 'AddObject');
  RegisterMethod(@TALAVLStringList.Assign, 'Assign');
  RegisterMethod(@TALAVLStringList.Delete, 'Delete');
  RegisterMethod(@TALAVLStringList.Exchange, 'Exchange');
  RegisterMethod(@TALAVLStringList.IndexOf, 'IndexOf');
  RegisterMethod(@TALAVLStringList.IndexOfName, 'IndexOfName');
  RegisterMethod(@TALAVLStringList.Insert, 'Insert');
  RegisterMethod(@TALAVLStringList.InsertObject, 'InsertObject');
  RegisterMethod(@TALAVLStringList.Move, 'Move');
    RegisterPropertyHelper(@TALAVLStringListDuplicates_R,@TALAVLStringListDuplicates_W,'Duplicates');
    RegisterPropertyHelper(@TALAVLStringListCaseSensitive_R,@TALAVLStringListCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TALAVLStringListOnChange_R,@TALAVLStringListOnChange_W,'OnChange');
    RegisterPropertyHelper(@TALAVLStringListOnChanging_R,@TALAVLStringListOnChanging_W,'OnChanging');
    RegisterPropertyHelper(@TALAVLStringListOwnsObjects_R,@TALAVLStringListOwnsObjects_W,'OwnsObjects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALAVLStringListBinaryTreeNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALAVLStringListBinaryTreeNode) do
  begin
    RegisterPropertyHelper(@TALAVLStringListBinaryTreeNodeVal_R,@TALAVLStringListBinaryTreeNodeVal_W,'Val');
    RegisterPropertyHelper(@TALAVLStringListBinaryTreeNodeObj_R,@TALAVLStringListBinaryTreeNodeObj_W,'Obj');
    RegisterPropertyHelper(@TALAVLStringListBinaryTreeNodeIdx_R,@TALAVLStringListBinaryTreeNodeIdx_W,'Idx');
    RegisterPropertyHelper(@TALAVLStringListBinaryTreeNodeNvs_R,@TALAVLStringListBinaryTreeNodeNvs_W,'Nvs');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALStringList) do begin
    RegisterConstructor(@TALStringList.Create, 'Create');
    RegisterConstructor(@TALStringListCreate_P, 'Create1');
    RegisterMethod(@TALStringList.Destroy,'Free');
    RegisterVirtualMethod(@TALStringListExtractObject_P, 'ExtractObject');
    RegisterVirtualMethod(@TALStringList.Find, 'Find');
    RegisterMethod(@TALStringList.FindName, 'FindName');
    RegisterVirtualMethod(@TALStringList.Sort, 'Sort');
    RegisterVirtualMethod(@TALStringList.CustomSort, 'CustomSort');

     RegisterMethod(@TALStringList.AddObject, 'AddObject');
     RegisterMethod(@TALStringList.Clear, 'Clear');
   RegisterMethod(@TALStringList.Delete, 'Delete');
   RegisterMethod(@TALStringList.Exchange, 'Exchange');
   RegisterMethod(@TALStringList.IndexOfName, 'IndexOfName');
   RegisterMethod(@TALStringList.Insert, 'Insert');
   RegisterMethod(@TALStringList.InsertObject, 'InsertObject');

    RegisterPropertyHelper(@TALStringListDuplicates_R,@TALStringListDuplicates_W,'Duplicates');
    RegisterPropertyHelper(@TALStringListSorted_R,@TALStringListSorted_W,'Sorted');
    RegisterPropertyHelper(@TALStringListCaseSensitive_R,@TALStringListCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TALStringListOnChange_R,@TALStringListOnChange_W,'OnChange');
    RegisterPropertyHelper(@TALStringListOnChanging_R,@TALStringListOnChanging_W,'OnChanging');
    RegisterPropertyHelper(@TALStringListOwnsObjects_R,@TALStringListOwnsObjects_W,'OwnsObjects');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALStrings(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALStrings) do begin
    RegisterConstructor(@TALStrings.Create, 'Create');
    RegisterVirtualMethod(@TALStrings.Add, 'Add');
    RegisterVirtualMethod(@TALStrings.AddObject, 'AddObject');
    RegisterMethod(@TALStrings.Append, 'Append');
    RegisterVirtualMethod(@TALStringsAddStrings_P, 'AddStrings');
    RegisterMethod(@TALStrings.Assign, 'Assign');
    RegisterMethod(@TALStrings.BeginUpdate, 'BeginUpdate');
    //RegisterVirtualAbstractMethod(@TALStrings, @!.Clear, 'Clear');
    //RegisterVirtualAbstractMethod(@TALStrings, @!.Delete, 'Delete');
    RegisterMethod(@TALStrings.EndUpdate, 'EndUpdate');
    RegisterMethod(@TALStrings.Equals, 'Equals');
    RegisterVirtualMethod(@TALStrings.Exchange, 'Exchange');
    RegisterMethod(@TALStrings.GetEnumerator, 'GetEnumerator');
    RegisterVirtualMethod(@TALStrings.GetText, 'GetText');
    RegisterVirtualMethod(@TALStrings.IndexOf, 'IndexOf');
    RegisterVirtualMethod(@TALStrings.IndexOfName, 'IndexOfName');
    RegisterVirtualMethod(@TALStrings.IndexOfObject, 'IndexOfObject');
    //RegisterVirtualAbstractMethod(@TALStrings, @!.Insert, 'Insert');
    RegisterVirtualMethod(@TALStrings.InsertObject, 'InsertObject');
    RegisterVirtualMethod(@TALStrings.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TALStrings.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TALStrings.Move, 'Move');
    RegisterVirtualMethod(@TALStrings.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TALStrings.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TALStrings.SetText, 'SetText');
    RegisterPropertyHelper(@TALStringsCapacity_R,@TALStringsCapacity_W,'Capacity');
    RegisterPropertyHelper(@TALStringsCommaText_R,@TALStringsCommaText_W,'CommaText');
    RegisterPropertyHelper(@TALStringsCount_R,nil,'Count');
    RegisterPropertyHelper(@TALStringsDelimiter_R,@TALStringsDelimiter_W,'Delimiter');
    RegisterPropertyHelper(@TALStringsDelimitedText_R,@TALStringsDelimitedText_W,'DelimitedText');
    RegisterPropertyHelper(@TALStringsLineBreak_R,@TALStringsLineBreak_W,'LineBreak');
    RegisterPropertyHelper(@TALStringsNames_R,nil,'Names');
    RegisterPropertyHelper(@TALStringsStrictNames_R,nil,'StrictNames');
    RegisterPropertyHelper(@TALStringsObjects_R,@TALStringsObjects_W,'Objects');
    RegisterPropertyHelper(@TALStringsQuoteChar_R,@TALStringsQuoteChar_W,'QuoteChar');
    RegisterPropertyHelper(@TALStringsValues_R,@TALStringsValues_W,'Values');
    RegisterPropertyHelper(@TALStringsValueFromIndex_R,@TALStringsValueFromIndex_W,'ValueFromIndex');
    RegisterPropertyHelper(@TALStringsPersistentValues_R,@TALStringsPersistentValues_W,'PersistentValues');
    RegisterPropertyHelper(@TALStringsPersistentValueFromIndex_R,@TALStringsPersistentValueFromIndex_W,'PersistentValueFromIndex');
    RegisterPropertyHelper(@TALStringsNameValueSeparator_R,@TALStringsNameValueSeparator_W,'NameValueSeparator');
    RegisterPropertyHelper(@TALStringsStrictDelimiter_R,@TALStringsStrictDelimiter_W,'StrictDelimiter');
    RegisterPropertyHelper(@TALStringsStrings_R,@TALStringsStrings_W,'Strings');
    RegisterPropertyHelper(@TALStringsText_R,@TALStringsText_W,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TALStringsEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALStringsEnumerator) do
  begin
    RegisterConstructor(@TALStringsEnumerator.Create, 'Create');
    RegisterMethod(@TALStringsEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TALStringsEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TALStringsEnumeratorCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ALStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TALStrings) do
  RIRegister_TALStringsEnumerator(CL);
  RIRegister_TALStrings(CL);
  with CL.Add(TALStringList) do
  RIRegister_TALStringList(CL);
  with CL.Add(TALAVLStringList) do
  RIRegister_TALAVLStringListBinaryTreeNode(CL);
  RIRegister_TALAVLStringList(CL);
end;

 
 
{ TPSImport_ALStringList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALStringList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ALStringList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ALStringList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ALStringList(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
