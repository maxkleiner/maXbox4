unit uPSI_JvStringHolder;
{
   macros
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
  TPSImport_JvStringHolder = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvMultiStringHolder(CL: TPSPascalCompiler);
procedure SIRegister_TJvMultiStringHolderCollection(CL: TPSPascalCompiler);
procedure SIRegister_TJvMultiStringHolderCollectionItem(CL: TPSPascalCompiler);
procedure SIRegister_TJvStrHolder(CL: TPSPascalCompiler);
procedure SIRegister_TJvMacros(CL: TPSPascalCompiler);
procedure SIRegister_TJvMacro(CL: TPSPascalCompiler);
procedure SIRegister_JvStringHolder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvMultiStringHolder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMultiStringHolderCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMultiStringHolderCollectionItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvStrHolder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMacros(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvMacro(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvStringHolder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Variants
  ,RTLConsts
  ,JvStringHolder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvStringHolder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMultiStringHolder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvMultiStringHolder') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvMultiStringHolder') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ItemByName', 'TJvMultiStringHolderCollectionItem string', iptr);
    RegisterProperty('StringsByName', 'TStrings string', iptr);
    RegisterProperty('MultipleStrings', 'TJvMultiStringHolderCollection', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMultiStringHolderCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TJvMultiStringHolderCollection') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TJvMultiStringHolderCollection') do
  begin
    RegisterMethod('Function DoesNameExist( const Name : string) : Boolean');
    RegisterProperty('Items', 'TJvMultiStringHolderCollectionItem Integer', iptrw);
    RegisterMethod('Function Add : TJvMultiStringHolderCollectionItem');
    RegisterMethod('Function Insert( Index : Integer) : TJvMultiStringHolderCollectionItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMultiStringHolderCollectionItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TJvMultiStringHolderCollectionItem') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TJvMultiStringHolderCollectionItem') do
  begin
    RegisterMethod('Constructor Create(Collection: TCollection)');
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Strings', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvStrHolder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TJvStrHolder') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TJvStrHolder') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function MacroCount : Integer');
    RegisterMethod('Function MacroByName( const MacroName : string) : TJvMacro');
    RegisterMethod('Function ExpandMacros : string');
    RegisterProperty('CommaText', 'string', iptrw);
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('MacroChar', 'Char', iptrw);
    RegisterProperty('Macros', 'TJvMacros', iptrw);
    RegisterProperty('OnExpandMacros', 'TNotifyEvent', iptrw);
    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
    RegisterProperty('KeyString', 'string', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('Strings', 'TStrings', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMacros(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOwnedCollection', 'TJvMacros') do
  with CL.AddClassN(CL.FindClass('TOwnedCollection'),'TJvMacros') do
  begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
    RegisterMethod('Procedure AssignValues( Value : TJvMacros)');
    RegisterMethod('Procedure AddMacro( Value : TJvMacro)');
    RegisterMethod('Procedure RemoveMacro( Value : TJvMacro)');
    RegisterMethod('Function CreateMacro( const MacroName : string) : TJvMacro');
    RegisterMethod('Procedure GetMacroList( List : TList; const MacroNames : string)');
    RegisterMethod('Function IndexOf( const AName : string) : Integer');
    RegisterMethod('Function IsEqual( Value : TJvMacros) : Boolean');
    RegisterMethod('Function ParseString( const Value : string; DoCreate : Boolean; SpecialChar : Char) : string');
    RegisterMethod('Function MacroByName( const Value : string) : TJvMacro');
    RegisterMethod('Function FindMacro( const Value : string) : TJvMacro');
    RegisterProperty('Items', 'TJvMacro Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('MacroValues', 'Variant string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvMacro(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TJvMacro') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TJvMacro') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function IsEqual( Value : TJvMacro) : Boolean');
    RegisterProperty('Macros', 'TJvMacros', iptr);
    RegisterProperty('Text', 'string', iptr);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Value', 'Variant', iptrw);
    RegisterProperty('OnGetText', 'TMacroTextEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvStringHolder(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJvMacros');
  CL.AddTypeS('TMacroTextEvent', 'Procedure ( Sender : TObject; Data : Variant;'
   +' var Text : string)');
  SIRegister_TJvMacro(CL);
  SIRegister_TJvMacros(CL);
  SIRegister_TJvStrHolder(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvMultiStringHolderException');
  SIRegister_TJvMultiStringHolderCollectionItem(CL);
  SIRegister_TJvMultiStringHolderCollection(CL);
  SIRegister_TJvMultiStringHolder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderMultipleStrings_W(Self: TJvMultiStringHolder; const T: TJvMultiStringHolderCollection);
begin Self.MultipleStrings := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderMultipleStrings_R(Self: TJvMultiStringHolder; var T: TJvMultiStringHolderCollection);
begin T := Self.MultipleStrings; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderStringsByName_R(Self: TJvMultiStringHolder; var T: TStrings; const t1: string);
begin T := Self.StringsByName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderItemByName_R(Self: TJvMultiStringHolder; var T: TJvMultiStringHolderCollectionItem; const t1: string);
begin T := Self.ItemByName[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderCollectionItems_W(Self: TJvMultiStringHolderCollection; const T: TJvMultiStringHolderCollectionItem; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderCollectionItems_R(Self: TJvMultiStringHolderCollection; var T: TJvMultiStringHolderCollectionItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderCollectionItemStrings_W(Self: TJvMultiStringHolderCollectionItem; const T: TStrings);
begin Self.Strings := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderCollectionItemStrings_R(Self: TJvMultiStringHolderCollectionItem; var T: TStrings);
begin T := Self.Strings; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderCollectionItemName_W(Self: TJvMultiStringHolderCollectionItem; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMultiStringHolderCollectionItemName_R(Self: TJvMultiStringHolderCollectionItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderOnChanging_W(Self: TJvStrHolder; const T: TNotifyEvent);
begin Self.OnChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderOnChanging_R(Self: TJvStrHolder; var T: TNotifyEvent);
begin T := Self.OnChanging; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderOnChange_W(Self: TJvStrHolder; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderOnChange_R(Self: TJvStrHolder; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderStrings_W(Self: TJvStrHolder; const T: TStrings);
begin Self.Strings := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderStrings_R(Self: TJvStrHolder; var T: TStrings);
begin T := Self.Strings; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderSorted_W(Self: TJvStrHolder; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderSorted_R(Self: TJvStrHolder; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderKeyString_W(Self: TJvStrHolder; const T: string);
begin Self.KeyString := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderKeyString_R(Self: TJvStrHolder; var T: string);
begin T := Self.KeyString; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderDuplicates_W(Self: TJvStrHolder; const T: TDuplicates);
begin Self.Duplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderDuplicates_R(Self: TJvStrHolder; var T: TDuplicates);
begin T := Self.Duplicates; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderOnExpandMacros_W(Self: TJvStrHolder; const T: TNotifyEvent);
begin Self.OnExpandMacros := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderOnExpandMacros_R(Self: TJvStrHolder; var T: TNotifyEvent);
begin T := Self.OnExpandMacros; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderMacros_W(Self: TJvStrHolder; const T: TJvMacros);
begin Self.Macros := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderMacros_R(Self: TJvStrHolder; var T: TJvMacros);
begin T := Self.Macros; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderMacroChar_W(Self: TJvStrHolder; const T: Char);
begin Self.MacroChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderMacroChar_R(Self: TJvStrHolder; var T: Char);
begin T := Self.MacroChar; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderCapacity_W(Self: TJvStrHolder; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderCapacity_R(Self: TJvStrHolder; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderCommaText_W(Self: TJvStrHolder; const T: string);
begin Self.CommaText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvStrHolderCommaText_R(Self: TJvStrHolder; var T: string);
begin T := Self.CommaText; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacrosMacroValues_W(Self: TJvMacros; const T: Variant; const t1: string);
begin Self.MacroValues[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacrosMacroValues_R(Self: TJvMacros; var T: Variant; const t1: string);
begin T := Self.MacroValues[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacrosItems_W(Self: TJvMacros; const T: TJvMacro; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacrosItems_R(Self: TJvMacros; var T: TJvMacro; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacroOnGetText_W(Self: TJvMacro; const T: TMacroTextEvent);
begin Self.OnGetText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacroOnGetText_R(Self: TJvMacro; var T: TMacroTextEvent);
begin T := Self.OnGetText; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacroValue_W(Self: TJvMacro; const T: Variant);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacroValue_R(Self: TJvMacro; var T: Variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacroName_W(Self: TJvMacro; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacroName_R(Self: TJvMacro; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacroText_R(Self: TJvMacro; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TJvMacroMacros_R(Self: TJvMacro; var T: TJvMacros);
begin T := Self.Macros; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMultiStringHolder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMultiStringHolder) do begin
    RegisterConstructor(@TJvMultiStringHolder.Create, 'Create');
    RegisterPropertyHelper(@TJvMultiStringHolderItemByName_R,nil,'ItemByName');
    RegisterPropertyHelper(@TJvMultiStringHolderStringsByName_R,nil,'StringsByName');
    RegisterPropertyHelper(@TJvMultiStringHolderMultipleStrings_R,@TJvMultiStringHolderMultipleStrings_W,'MultipleStrings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMultiStringHolderCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMultiStringHolderCollection) do
  begin
    RegisterMethod(@TJvMultiStringHolderCollection.DoesNameExist, 'DoesNameExist');
    RegisterPropertyHelper(@TJvMultiStringHolderCollectionItems_R,@TJvMultiStringHolderCollectionItems_W,'Items');
    RegisterMethod(@TJvMultiStringHolderCollection.Add, 'Add');
    RegisterMethod(@TJvMultiStringHolderCollection.Insert, 'Insert');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMultiStringHolderCollectionItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMultiStringHolderCollectionItem) do begin
    RegisterConstructor(@TJvMultiStringHolderCollectionItem.Create, 'Create');
    RegisterPropertyHelper(@TJvMultiStringHolderCollectionItemName_R,@TJvMultiStringHolderCollectionItemName_W,'Name');
    RegisterPropertyHelper(@TJvMultiStringHolderCollectionItemStrings_R,@TJvMultiStringHolderCollectionItemStrings_W,'Strings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvStrHolder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvStrHolder) do begin
    RegisterConstructor(@TJvStrHolder.Create, 'Create');
    RegisterMethod(@TJvStrHolder.Destroy, 'Free');
    RegisterMethod(@TJvStrHolder.Assign, 'Assign');
    RegisterMethod(@TJvStrHolder.Clear, 'Clear');
    RegisterMethod(@TJvStrHolder.MacroCount, 'MacroCount');
    RegisterMethod(@TJvStrHolder.MacroByName, 'MacroByName');
    RegisterMethod(@TJvStrHolder.ExpandMacros, 'ExpandMacros');
    RegisterPropertyHelper(@TJvStrHolderCommaText_R,@TJvStrHolderCommaText_W,'CommaText');
    RegisterPropertyHelper(@TJvStrHolderCapacity_R,@TJvStrHolderCapacity_W,'Capacity');
    RegisterPropertyHelper(@TJvStrHolderMacroChar_R,@TJvStrHolderMacroChar_W,'MacroChar');
    RegisterPropertyHelper(@TJvStrHolderMacros_R,@TJvStrHolderMacros_W,'Macros');
    RegisterPropertyHelper(@TJvStrHolderOnExpandMacros_R,@TJvStrHolderOnExpandMacros_W,'OnExpandMacros');
    RegisterPropertyHelper(@TJvStrHolderDuplicates_R,@TJvStrHolderDuplicates_W,'Duplicates');
    RegisterPropertyHelper(@TJvStrHolderKeyString_R,@TJvStrHolderKeyString_W,'KeyString');
    RegisterPropertyHelper(@TJvStrHolderSorted_R,@TJvStrHolderSorted_W,'Sorted');
    RegisterPropertyHelper(@TJvStrHolderStrings_R,@TJvStrHolderStrings_W,'Strings');
    RegisterPropertyHelper(@TJvStrHolderOnChange_R,@TJvStrHolderOnChange_W,'OnChange');
    RegisterPropertyHelper(@TJvStrHolderOnChanging_R,@TJvStrHolderOnChanging_W,'OnChanging');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMacros(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMacros) do begin
    RegisterConstructor(@TJvMacros.Create, 'Create');
    RegisterMethod(@TJvMacros.AssignValues, 'AssignValues');
    RegisterMethod(@TJvMacros.AddMacro, 'AddMacro');
    RegisterMethod(@TJvMacros.RemoveMacro, 'RemoveMacro');
    RegisterMethod(@TJvMacros.CreateMacro, 'CreateMacro');
    RegisterMethod(@TJvMacros.GetMacroList, 'GetMacroList');
    RegisterMethod(@TJvMacros.IndexOf, 'IndexOf');
    RegisterMethod(@TJvMacros.IsEqual, 'IsEqual');
    RegisterMethod(@TJvMacros.ParseString, 'ParseString');
    RegisterMethod(@TJvMacros.MacroByName, 'MacroByName');
    RegisterMethod(@TJvMacros.FindMacro, 'FindMacro');
    RegisterPropertyHelper(@TJvMacrosItems_R,@TJvMacrosItems_W,'Items');
    RegisterPropertyHelper(@TJvMacrosMacroValues_R,@TJvMacrosMacroValues_W,'MacroValues');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvMacro(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMacro) do begin
    RegisterConstructor(@TJvMacro.Create, 'Create');
    RegisterMethod(@TJvMacro.Assign, 'Assign');
    RegisterMethod(@TJvMacro.Clear, 'Clear');
    RegisterMethod(@TJvMacro.IsEqual, 'IsEqual');
    RegisterPropertyHelper(@TJvMacroMacros_R,nil,'Macros');
    RegisterPropertyHelper(@TJvMacroText_R,nil,'Text');
    RegisterPropertyHelper(@TJvMacroName_R,@TJvMacroName_W,'Name');
    RegisterPropertyHelper(@TJvMacroValue_R,@TJvMacroValue_W,'Value');
    RegisterPropertyHelper(@TJvMacroOnGetText_R,@TJvMacroOnGetText_W,'OnGetText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvStringHolder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvMacros) do
  RIRegister_TJvMacro(CL);
  RIRegister_TJvMacros(CL);
  RIRegister_TJvStrHolder(CL);
  with CL.Add(EJvMultiStringHolderException) do
  RIRegister_TJvMultiStringHolderCollectionItem(CL);
  RIRegister_TJvMultiStringHolderCollection(CL);
  RIRegister_TJvMultiStringHolder(CL);
end;

 
 
{ TPSImport_JvStringHolder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStringHolder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvStringHolder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvStringHolder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvStringHolder(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
