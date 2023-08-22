unit uPSI_StringsW;
{
going to unicode  hash map bucket list

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
  TPSImport_StringsW = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TComponentHash(CL: TPSPascalCompiler);
procedure SIRegister_TObjectHash(CL: TPSPascalCompiler);
procedure SIRegister_THashedStringListW(CL: TPSPascalCompiler);
procedure SIRegister_TStringHashW(CL: TPSPascalCompiler);
procedure SIRegister_TStringListW(CL: TPSPascalCompiler);
procedure SIRegister_TStringsW(CL: TPSPascalCompiler);
procedure SIRegister_StringsW(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TComponentHash(CL: TPSRuntimeClassImporter);
procedure RIRegister_TObjectHash(CL: TPSRuntimeClassImporter);
procedure RIRegister_THashedStringListW(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringHashW(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringListW(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStringsW(CL: TPSRuntimeClassImporter);
procedure RIRegister_StringsW(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   FileStreamW
  ,Windows
  ,StringsW
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StringsW]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TComponentHash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectHash', 'TComponentHash') do
  with CL.AddClassN(CL.FindClass('TObjectHash'),'TComponentHash') do begin
       RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TObjectHash(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'THash', 'TObjectHash') do
  with CL.AddClassN(CL.FindClass('THashW'),'TObjectHash') do begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create11( OwnsObjects : Boolean);');
         RegisterMethod('Procedure Free');
    RegisterMethod('Function Extract( Index : Integer) : TObject');
    RegisterMethod('Function Delete( Obj : TObject) : Boolean');
    RegisterProperty('OwnsObjects', 'Boolean', iptrw);
    RegisterProperty('ObjectByStr', 'TObject WideString', iptrw);
    SetDefaultPropery('ObjectByStr');
    RegisterProperty('ObjectByName', 'TObject WideString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THashedStringListW(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringListW', 'THashedStringListW') do
  with CL.AddClassN(CL.FindClass('TStringListW'),'THashedStringListW') do begin
   RegisterMethod('Procedure Free');
       RegisterMethod('Function IndexOf( const S : WideString) : Integer');
    RegisterMethod('Function IndexOfName( const Name : WideString) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringHashW(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStringHashW') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStringHashW') do begin
    RegisterMethod('Constructor Create( Size : DWord)');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Add( const Key : WideString; Value : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Remove( const Key : WideString)');
    RegisterMethod('Function Modify( const Key : WideString; Value : Integer) : Boolean');
    RegisterMethod('Function ValueOf( const Key : WideString) : Integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringListW(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringsW', 'TStringListW') do
  with CL.AddClassN(CL.FindClass('TStringsW'),'TStringListW') do begin
    RegisterMethod('Function Add( const S : WideString; Tag : DWord) : Integer');
    RegisterMethod('Function AddObject( const S : WideString; AObject : TObject) : Integer');
    RegisterMethod('Procedure Clear');
     RegisterMethod('Procedure Free');

    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function Find( const S : WideString; var Index : Integer) : Boolean');
    RegisterMethod('Function IndexOf( const S : WideString) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const S : WideString; Tag : DWord)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const S : WideString; AObject : TObject)');
    RegisterMethod('Procedure Sort');
    RegisterMethod('Procedure CustomSort( Compare : TStringListSortCompare)');
    RegisterProperty('Duplicates', 'TDuplicatesEx', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringsW(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TStringsW') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TStringsW') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Add( const S : WideString; Tag : DWord) : Integer');
    RegisterMethod('Function AddObject( const S : WideString; AObject : TObject) : Integer');
    RegisterMethod('Procedure Append( const S : WideString)');
    RegisterMethod('Procedure AddStrings( Strings : TStringsW);');
    RegisterMethod('Procedure AddStrings1( Strings : TStrings);');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Delete( Index : Integer);');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Function Equals( Strings : TStringsW) : Boolean');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function GetText : PWideChar');
    RegisterMethod('Function IndexOf( const S : WideString) : Integer;');
    RegisterMethod('Function IndexOf4( AObject : TObject) : Integer;');
    RegisterMethod('Function IndexOfName( const Name : WideString) : Integer');
    RegisterMethod('Function IndexOfValue( const Value : WideString) : Integer');
    RegisterMethod('Function IndexOfObject( AObject : TObject) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const S : WideString; Tag : DWord)');
    RegisterMethod('Procedure InsertObject( Index : Integer; const S : WideString; AObject : TObject)');
    RegisterMethod('Procedure LoadFromFile( const FileName : WideString)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream; SkipEmptyLines : Boolean)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Procedure SaveToFile( const FileName : WideString; WriteUtfSignature : Boolean)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure SetText( Text : PWideChar; SkipEmptyLines : Boolean)');
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('CommaText', 'WideString', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Delimiter', 'WideChar', iptrw);
    RegisterProperty('DelimitedText', 'WideString', iptrw);
    RegisterProperty('Names', 'WideString Integer', iptr);
    RegisterProperty('Objects', 'TObject Integer', iptrw);
    RegisterProperty('Tags', 'DWord Integer', iptrw);
    RegisterProperty('QuoteChar', 'WideChar', iptrw);
    RegisterProperty('Values', 'WideString WideString', iptrw);
    RegisterProperty('ValueFromIndex', 'WideString Integer', iptrw);
    RegisterProperty('NameValueSeparator', 'WideChar', iptrw);
    RegisterProperty('Strings', 'WideString Integer', iptrw);
    SetDefaultPropery('Strings');
    RegisterProperty('Text', 'WideString', iptrw);
    RegisterProperty('LineBreak', 'WideString', iptrw);
    RegisterMethod('Procedure AppendTo( const Other : TStrings);');
    RegisterMethod('Procedure AppendTo6( const Other : TStringsW);');
    RegisterMethod('Procedure CopyTo( const Other : TStrings);');
    RegisterMethod('Procedure CopyTo8( const Other : TStringsW);');
    RegisterMethod('Function NameList : TStringListW');
    RegisterProperty('AsString', 'WideString', iptr);
    RegisterMethod('Function Extract( Index : Integer) : TObject');
    RegisterMethod('Function IndexOfInstanceOf( AClass : TClass; CanInherit : Boolean; StartAt : Integer) : Integer');
    RegisterMethod('Function IsEmpty : Boolean');
    RegisterMethod('Function Delete9( Str : WideString) : Boolean;');
    RegisterMethod('Function DeleteByName( Name : WideString) : Boolean');
    RegisterMethod('Function JoinNames( const Delim : WideString) : WideString');
    RegisterMethod('Function JoinValues( const Delim : WideString) : WideString');
    RegisterMethod('Function Join( const Delim : WideString) : WideString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StringsW(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDuplicatesEx', '( dupIgnore, dupAccept, dupReplace, dupError )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStringListW');
  SIRegister_TStringsW(CL);
  //CL.AddTypeS('PStringItemW', '^TStringItemW // will not work');
  CL.AddTypeS('TStringItemW', 'record FString : WideString; FObject : TObject; end');
  //CL.AddTypeS('PStringItemListW', '^TStringItemListW // will not work');
  CL.AddTypeS('TStringListSortCompare', 'Function ( List : TStringListW; Index1, Index2 : Integer) : Integer');
  SIRegister_TStringListW(CL);
  //CL.AddTypeS('PPHashItem', '^PHashItem // will not work');
  //CL.AddTypeS('PHashItem', '^THashItem // will not work');
  //CL.AddTypeS('THashItem', 'record Next : PHashItem; Key : WideString; Value : Integer; end');
  SIRegister_TStringHashW(CL);
  SIRegister_THashedStringListW(CL);
  CL.AddTypeS('THashW', 'THashedStringListW');
  SIRegister_TObjectHash(CL);
  SIRegister_TComponentHash(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TObjectHashObjectByName_W(Self: TObjectHash; const T: TObject; const t1: WideString);
begin Self.ObjectByName[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectHashObjectByName_R(Self: TObjectHash; var T: TObject; const t1: WideString);
begin T := Self.ObjectByName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TObjectHashObjectByStr_W(Self: TObjectHash; const T: TObject; const t1: WideString);
begin Self.ObjectByStr[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectHashObjectByStr_R(Self: TObjectHash; var T: TObject; const t1: WideString);
begin T := Self.ObjectByStr[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TObjectHashOwnsObjects_W(Self: TObjectHash; const T: Boolean);
begin Self.OwnsObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TObjectHashOwnsObjects_R(Self: TObjectHash; var T: Boolean);
begin T := Self.OwnsObjects; end;

(*----------------------------------------------------------------------------*)
Function TObjectHashCreate11_P(Self: TClass; CreateNewInstance: Boolean;  OwnsObjects : Boolean):TObject;
Begin Result := TObjectHash.Create(OwnsObjects); END;

(*----------------------------------------------------------------------------*)
Function TObjectHashCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TObjectHash.Create; END;

(*----------------------------------------------------------------------------*)
procedure TStringListWOnChanging_W(Self: TStringListW; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWOnChanging_R(Self: TStringListW; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWOnChange_W(Self: TStringListW; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWOnChange_R(Self: TStringListW; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWCaseSensitive_W(Self: TStringListW; const T: Boolean);
begin Self.CaseSensitive := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWCaseSensitive_R(Self: TStringListW; var T: Boolean);
begin T := Self.CaseSensitive; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWSorted_W(Self: TStringListW; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWSorted_R(Self: TStringListW; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWDuplicates_W(Self: TStringListW; const T: TDuplicatesEx);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringListWDuplicates_R(Self: TStringListW; var T: TDuplicatesEx);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
Function TStringsWDelete9_P(Self: TStringsW;  Str : WideString) : Boolean;
Begin Result := Self.Delete(Str); END;

(*----------------------------------------------------------------------------*)
procedure TStringsWAsString_R(Self: TStringsW; var T: WideString);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
Procedure TStringsWCopyTo8_P(Self: TStringsW;  const Other : TStringsW);
Begin Self.CopyTo(Other); END;

(*----------------------------------------------------------------------------*)
Procedure TStringsWCopyTo_P(Self: TStringsW;  const Other : TStrings);
Begin Self.CopyTo(Other); END;

(*----------------------------------------------------------------------------*)
Procedure TStringsWAppendTo6_P(Self: TStringsW;  const Other : TStringsW);
Begin Self.AppendTo(Other); END;

(*----------------------------------------------------------------------------*)
Procedure TStringsWAppendTo_P(Self: TStringsW;  const Other : TStrings);
Begin Self.AppendTo(Other); END;

(*----------------------------------------------------------------------------*)
procedure TStringsWLineBreak_W(Self: TStringsW; const T: WideString);
begin Self.LineBreak := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWLineBreak_R(Self: TStringsW; var T: WideString);
begin T := Self.LineBreak; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWText_W(Self: TStringsW; const T: WideString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWText_R(Self: TStringsW; var T: WideString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWStrings_W(Self: TStringsW; const T: WideString; const t1: Integer);
begin Self.Strings[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWStrings_R(Self: TStringsW; var T: WideString; const t1: Integer);
begin T := Self.Strings[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWNameValueSeparator_W(Self: TStringsW; const T: WideChar);
begin Self.NameValueSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWNameValueSeparator_R(Self: TStringsW; var T: WideChar);
begin T := Self.NameValueSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWValueFromIndex_W(Self: TStringsW; const T: WideString; const t1: Integer);
begin Self.ValueFromIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWValueFromIndex_R(Self: TStringsW; var T: WideString; const t1: Integer);
begin T := Self.ValueFromIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWValues_W(Self: TStringsW; const T: WideString; const t1: WideString);
begin Self.Values[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWValues_R(Self: TStringsW; var T: WideString; const t1: WideString);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWQuoteChar_W(Self: TStringsW; const T: WideChar);
begin Self.QuoteChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWQuoteChar_R(Self: TStringsW; var T: WideChar);
begin T := Self.QuoteChar; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWTags_W(Self: TStringsW; const T: DWord; const t1: Integer);
begin Self.Tags[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWTags_R(Self: TStringsW; var T: DWord; const t1: Integer);
begin T := Self.Tags[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWObjects_W(Self: TStringsW; const T: TObject; const t1: Integer);
begin Self.Objects[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWObjects_R(Self: TStringsW; var T: TObject; const t1: Integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWNames_R(Self: TStringsW; var T: WideString; const t1: Integer);
begin T := Self.Names[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWDelimitedText_W(Self: TStringsW; const T: WideString);
begin Self.DelimitedText := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWDelimitedText_R(Self: TStringsW; var T: WideString);
begin T := Self.DelimitedText; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWDelimiter_W(Self: TStringsW; const T: WideChar);
begin Self.Delimiter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWDelimiter_R(Self: TStringsW; var T: WideChar);
begin T := Self.Delimiter; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWCount_R(Self: TStringsW; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWCommaText_W(Self: TStringsW; const T: WideString);
begin Self.CommaText := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWCommaText_R(Self: TStringsW; var T: WideString);
begin T := Self.CommaText; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWCapacity_W(Self: TStringsW; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TStringsWCapacity_R(Self: TStringsW; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
Function TStringsWIndexOf4_P(Self: TStringsW;  AObject : TObject) : Integer;
Begin Result := Self.IndexOf(AObject); END;

(*----------------------------------------------------------------------------*)
Function TStringsWIndexOf_P(Self: TStringsW;  const S : WideString) : Integer;
Begin Result := Self.IndexOf(S); END;

(*----------------------------------------------------------------------------*)
Procedure TStringsWDelete_P(Self: TStringsW;  Index : Integer);
Begin Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
Procedure TStringsWAddStrings1_P(Self: TStringsW;  Strings : TStrings);
Begin Self.AddStrings(Strings); END;

(*----------------------------------------------------------------------------*)
Procedure TStringsWAddStrings_P(Self: TStringsW;  Strings : TStringsW);
Begin Self.AddStrings(Strings); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComponentHash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComponentHash) do begin
    RegisterMethod(@TComponentHash.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TObjectHash(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TObjectHash) do begin
    RegisterConstructor(@TObjectHashCreate_P, 'Create');
      RegisterMethod(@TObjectHash.Destroy, 'Free');
      RegisterConstructor(@TObjectHashCreate11_P, 'Create11');
    RegisterMethod(@TObjectHash.Extract, 'Extract');
    RegisterMethod(@TObjectHash.Delete, 'Delete');
    RegisterPropertyHelper(@TObjectHashOwnsObjects_R,@TObjectHashOwnsObjects_W,'OwnsObjects');
    RegisterPropertyHelper(@TObjectHashObjectByStr_R,@TObjectHashObjectByStr_W,'ObjectByStr');
    RegisterPropertyHelper(@TObjectHashObjectByName_R,@TObjectHashObjectByName_W,'ObjectByName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THashedStringListW(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THashedStringListW) do begin
    RegisterMethod(@THashedStringListW.IndexOf, 'IndexOf');
    RegisterMethod(@THashedStringListW.IndexOfName, 'IndexOfName');
      RegisterMethod(@THashedStringListW.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringHashW(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringHashW) do begin
    RegisterConstructor(@TStringHashW.Create, 'Create');
      RegisterMethod(@TStringHashW.Destroy, 'Free');

    RegisterMethod(@TStringHashW.Add, 'Add');
    RegisterMethod(@TStringHashW.Clear, 'Clear');
    RegisterMethod(@TStringHashW.Remove, 'Remove');
    RegisterMethod(@TStringHashW.Modify, 'Modify');
    RegisterMethod(@TStringHashW.ValueOf, 'ValueOf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringListW(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringListW) do begin
    RegisterMethod(@TStringListW.Add, 'Add');
      RegisterMethod(@TStringListW.Destroy, 'Free');

    RegisterMethod(@TStringListW.AddObject, 'AddObject');
    RegisterMethod(@TStringListW.Clear, 'Clear');
    RegisterMethod(@TStringListW.Delete, 'Delete');
    RegisterMethod(@TStringListW.Exchange, 'Exchange');
    RegisterVirtualMethod(@TStringListW.Find, 'Find');
    RegisterMethod(@TStringListW.IndexOf, 'IndexOf');
    RegisterMethod(@TStringListW.Insert, 'Insert');
    RegisterMethod(@TStringListW.InsertObject, 'InsertObject');
    RegisterVirtualMethod(@TStringListW.Sort, 'Sort');
    RegisterVirtualMethod(@TStringListW.CustomSort, 'CustomSort');
    RegisterPropertyHelper(@TStringListWDuplicates_R,@TStringListWDuplicates_W,'Duplicates');
    RegisterPropertyHelper(@TStringListWSorted_R,@TStringListWSorted_W,'Sorted');
    RegisterPropertyHelper(@TStringListWCaseSensitive_R,@TStringListWCaseSensitive_W,'CaseSensitive');
    RegisterPropertyHelper(@TStringListWOnChange_R,@TStringListWOnChange_W,'OnChange');
    RegisterPropertyHelper(@TStringListWOnChanging_R,@TStringListWOnChanging_W,'OnChanging');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStringsW(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringsW) do
  begin
    RegisterVirtualConstructor(@TStringsW.Create, 'Create');
    RegisterVirtualMethod(@TStringsW.Add, 'Add');
    RegisterVirtualMethod(@TStringsW.AddObject, 'AddObject');
    RegisterMethod(@TStringsW.Append, 'Append');
    RegisterVirtualMethod(@TStringsWAddStrings_P, 'AddStrings');
    RegisterMethod(@TStringsWAddStrings1_P, 'AddStrings1');
    RegisterMethod(@TStringsW.Assign, 'Assign');
    RegisterMethod(@TStringsW.BeginUpdate, 'BeginUpdate');
    //RegisterVirtualAbstractMethod(@TStringsW, @!.Clear, 'Clear');
    //RegisterVirtualAbstractMethod(@TStringsW, @!.Delete, 'Delete');
    RegisterMethod(@TStringsW.EndUpdate, 'EndUpdate');
    RegisterMethod(@TStringsW.Equals, 'Equals');
    RegisterVirtualMethod(@TStringsW.Exchange, 'Exchange');
    RegisterVirtualMethod(@TStringsW.GetText, 'GetText');
    RegisterVirtualMethod(@TStringsWIndexOf_P, 'IndexOf');
    RegisterVirtualMethod(@TStringsWIndexOf4_P, 'IndexOf4');
    RegisterVirtualMethod(@TStringsW.IndexOfName, 'IndexOfName');
    RegisterVirtualMethod(@TStringsW.IndexOfValue, 'IndexOfValue');
    RegisterVirtualMethod(@TStringsW.IndexOfObject, 'IndexOfObject');
    //RegisterVirtualAbstractMethod(@TStringsW, @!.Insert, 'Insert');
    RegisterVirtualMethod(@TStringsW.InsertObject, 'InsertObject');
    RegisterVirtualMethod(@TStringsW.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TStringsW.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TStringsW.Move, 'Move');
    RegisterMethod(@TStringsW.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TStringsW.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TStringsW.SetText, 'SetText');
    RegisterPropertyHelper(@TStringsWCapacity_R,@TStringsWCapacity_W,'Capacity');
    RegisterPropertyHelper(@TStringsWCommaText_R,@TStringsWCommaText_W,'CommaText');
    RegisterPropertyHelper(@TStringsWCount_R,nil,'Count');
    RegisterPropertyHelper(@TStringsWDelimiter_R,@TStringsWDelimiter_W,'Delimiter');
    RegisterPropertyHelper(@TStringsWDelimitedText_R,@TStringsWDelimitedText_W,'DelimitedText');
    RegisterPropertyHelper(@TStringsWNames_R,nil,'Names');
    RegisterPropertyHelper(@TStringsWObjects_R,@TStringsWObjects_W,'Objects');
    RegisterPropertyHelper(@TStringsWTags_R,@TStringsWTags_W,'Tags');
    RegisterPropertyHelper(@TStringsWQuoteChar_R,@TStringsWQuoteChar_W,'QuoteChar');
    RegisterPropertyHelper(@TStringsWValues_R,@TStringsWValues_W,'Values');
    RegisterPropertyHelper(@TStringsWValueFromIndex_R,@TStringsWValueFromIndex_W,'ValueFromIndex');
    RegisterPropertyHelper(@TStringsWNameValueSeparator_R,@TStringsWNameValueSeparator_W,'NameValueSeparator');
    RegisterPropertyHelper(@TStringsWStrings_R,@TStringsWStrings_W,'Strings');
    RegisterPropertyHelper(@TStringsWText_R,@TStringsWText_W,'Text');
    RegisterPropertyHelper(@TStringsWLineBreak_R,@TStringsWLineBreak_W,'LineBreak');
    RegisterMethod(@TStringsWAppendTo_P, 'AppendTo');
    RegisterMethod(@TStringsWAppendTo6_P, 'AppendTo6');
    RegisterMethod(@TStringsWCopyTo_P, 'CopyTo');
    RegisterMethod(@TStringsWCopyTo8_P, 'CopyTo8');
    RegisterVirtualMethod(@TStringsW.NameList, 'NameList');
    RegisterPropertyHelper(@TStringsWAsString_R,nil,'AsString');
    RegisterVirtualMethod(@TStringsW.Extract, 'Extract');
    RegisterMethod(@TStringsW.IndexOfInstanceOf, 'IndexOfInstanceOf');
    RegisterMethod(@TStringsW.IsEmpty, 'IsEmpty');
    RegisterMethod(@TStringsWDelete9_P, 'Delete9');
    RegisterMethod(@TStringsW.DeleteByName, 'DeleteByName');
    RegisterMethod(@TStringsW.JoinNames, 'JoinNames');
    RegisterMethod(@TStringsW.JoinValues, 'JoinValues');
    RegisterMethod(@TStringsW.Join, 'Join');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StringsW(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStringListW) do
  RIRegister_TStringsW(CL);
  RIRegister_TStringListW(CL);
  RIRegister_TStringHashW(CL);
  RIRegister_THashedStringListW(CL);
  RIRegister_TObjectHash(CL);
  RIRegister_TComponentHash(CL);
end;

 
 
{ TPSImport_StringsW }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StringsW.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StringsW(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StringsW.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StringsW(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
