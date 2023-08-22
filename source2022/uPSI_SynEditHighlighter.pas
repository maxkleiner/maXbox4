unit uPSI_SynEditHighlighter;
{
  for box in the box
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
  TPSImport_SynEditHighlighter = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynHighlighterList(CL: TPSPascalCompiler);
procedure SIRegister_TSynCustomHighlighter(CL: TPSPascalCompiler);
procedure SIRegister_TSynHighlighterAttributes(CL: TPSPascalCompiler);
procedure SIRegister_SynEditHighlighter(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynEditHighlighter_Routines(S: TPSExec);
procedure RIRegister_TSynHighlighterList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynCustomHighlighter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynHighlighterAttributes(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynEditHighlighter(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { kTextDrawer
  ,Types
  ,QGraphics
  ,QSynEditTypes
  ,QSynEditMiscClasses}
  Graphics
  //,Windows
  //,Registry
  //,IniFiles
  ,SynEditTypes
  ,SynEditMiscClasses
  ,SynEditHighlighter
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditHighlighter]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynHighlighterList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TSynHighlighterList') do
  with CL.AddClassN(CL.FindClass('TList'),'TSynHighlighterList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free'); //CL.AddClassN(CL.FindClass('TList')
    RegisterMethod('Function Count : integer');
    RegisterMethod('Function FindByName( name : string) : integer');
    RegisterMethod('Function FindByClass( comp : TComponent) : integer');
    RegisterProperty('Items', 'TSynCustomHighlighterClass integer', iptr);
    //SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynCustomHighlighter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSynCustomHighlighter') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSynCustomHighlighter') do begin
    RegisterMethod('Function GetCapabilities : TSynHighlighterCapabilities');
    RegisterMethod('Function GetLanguageName : string');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure BeginUpdate');
    RegisterMethod('Procedure EndUpdate');
    RegisterMethod('Function GetEol : Boolean');
    RegisterMethod('Function GetRange : Pointer');
    RegisterMethod('Function GetToken : String');
    RegisterMethod('Function GetTokenAttribute : TSynHighlighterAttributes');
    RegisterMethod('Function GetTokenKind : integer');
    RegisterMethod('Function GetTokenPos : Integer');
    RegisterMethod('Function IsKeyword( const AKeyword : string) : boolean');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure NextToEol');
    RegisterMethod('Procedure SetLine( NewValue : String; LineNumber : Integer)');
    RegisterMethod('Procedure SetRange( Value : Pointer)');
    RegisterMethod('Procedure ResetRange');
    RegisterMethod('Function UseUserSettings( settingIndex : integer) : boolean');
    RegisterMethod('Procedure EnumUserSettings( Settings : TStrings)');
    RegisterMethod('Function LoadFromRegistry( RootKey : HKEY; Key : string) : boolean');
    RegisterMethod('Function SaveToRegistry( RootKey : HKEY; Key : string) : boolean');
    RegisterMethod('Function LoadFromFile( AFileName : String) : boolean');
    RegisterMethod('Function SaveToFile( AFileName : String) : boolean');
    RegisterMethod('Procedure HookAttrChangeEvent( ANotifyEvent : TNotifyEvent)');
    RegisterMethod('Procedure UnhookAttrChangeEvent( ANotifyEvent : TNotifyEvent)');
    RegisterProperty('IdentChars', 'TSynIdentChars', iptr);
    RegisterProperty('WordBreakChars', 'TSynIdentChars', iptrw);
    RegisterProperty('LanguageName', 'string', iptr);
    RegisterProperty('AttrCount', 'integer', iptr);
    RegisterProperty('Attribute', 'TSynHighlighterAttributes integer', iptr);
    RegisterProperty('Capabilities', 'TSynHighlighterCapabilities', iptr);
    RegisterProperty('SampleSource', 'string', iptrw);
    RegisterProperty('CommentAttribute', 'TSynHighlighterAttributes', iptr);
    RegisterProperty('IdentifierAttribute', 'TSynHighlighterAttributes', iptr);
    RegisterProperty('KeywordAttribute', 'TSynHighlighterAttributes', iptr);
    RegisterProperty('StringAttribute', 'TSynHighlighterAttributes', iptr);
    RegisterProperty('SymbolAttribute', 'TSynHighlighterAttributes', iptr);
    RegisterProperty('WhitespaceAttribute', 'TSynHighlighterAttributes', iptr);
    RegisterProperty('DefaultFilter', 'string', iptrw);
    RegisterProperty('Enabled', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynHighlighterAttributes(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSynHighlighterAttributes') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSynHighlighterAttributes') do
  begin
    RegisterMethod('Procedure AssignColorAndStyle( Source : TSynHighlighterAttributes)');
    RegisterMethod('Constructor Create( attribName : string)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure InternalSaveDefaultValues');
    RegisterMethod('Function LoadFromBorlandRegistry( rootKey : HKEY; attrKey, attrName : string; oldStyle : boolean) : boolean');
    RegisterMethod('Function LoadFromRegistry( Reg : TBetterRegistry) : boolean');
    RegisterMethod('Function SaveToRegistry( Reg : TBetterRegistry) : boolean');
    RegisterMethod('Function LoadFromFile( Ini : TIniFile) : boolean');
    RegisterMethod('Function SaveToFile( Ini : TIniFile) : boolean');
    RegisterProperty('IntegerStyle', 'integer', iptrw);
    RegisterProperty('Name', 'string', iptr);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('Background', 'TColor', iptrw);
    RegisterProperty('Foreground', 'TColor', iptrw);
    RegisterProperty('Style', 'TFontStyles', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditHighlighter(CL: TPSPascalCompiler);
begin
  SIRegister_TSynHighlighterAttributes(CL);
  CL.AddTypeS('TSynHighlighterCapability', '( hcUserSettings, hcRegistry )');
  CL.AddTypeS('TSynHighlighterCapabilities', 'set of TSynHighlighterCapability');
 CL.AddConstantN('SYN_ATTR_COMMENT','LongInt').SetInt( 0);
 CL.AddConstantN('SYN_ATTR_IDENTIFIER','LongInt').SetInt( 1);
 CL.AddConstantN('SYN_ATTR_KEYWORD','LongInt').SetInt( 2);
 CL.AddConstantN('SYN_ATTR_STRING','LongInt').SetInt( 3);
 CL.AddConstantN('SYN_ATTR_WHITESPACE','LongInt').SetInt( 4);
 CL.AddConstantN('SYN_ATTR_SYMBOL','LongInt').SetInt( 5);
  SIRegister_TSynCustomHighlighter(CL);
  //CL.AddTypeS('TSynCustomHighlighterClass', 'class of TSynCustomHighlighter');
  SIRegister_TSynHighlighterList(CL);
 //CL.AddDelphiFunction('Procedure RegisterPlaceableHighlighter( highlighter : TSynCustomHighlighterClass)');
 //CL.AddDelphiFunction('Function GetPlaceableHighlighters : TSynHighlighterList');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynHighlighterListItems_R(Self: TSynHighlighterList; var T: TSynCustomHighlighterClass; const t1: integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterEnabled_W(Self: TSynCustomHighlighter; const T: boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterEnabled_R(Self: TSynCustomHighlighter; var T: boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterDefaultFilter_W(Self: TSynCustomHighlighter; const T: string);
begin Self.DefaultFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterDefaultFilter_R(Self: TSynCustomHighlighter; var T: string);
begin T := Self.DefaultFilter; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterWhitespaceAttribute_R(Self: TSynCustomHighlighter; var T: TSynHighlighterAttributes);
begin T := Self.WhitespaceAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterSymbolAttribute_R(Self: TSynCustomHighlighter; var T: TSynHighlighterAttributes);
begin T := Self.SymbolAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterStringAttribute_R(Self: TSynCustomHighlighter; var T: TSynHighlighterAttributes);
begin T := Self.StringAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterKeywordAttribute_R(Self: TSynCustomHighlighter; var T: TSynHighlighterAttributes);
begin T := Self.KeywordAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterIdentifierAttribute_R(Self: TSynCustomHighlighter; var T: TSynHighlighterAttributes);
begin T := Self.IdentifierAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterCommentAttribute_R(Self: TSynCustomHighlighter; var T: TSynHighlighterAttributes);
begin T := Self.CommentAttribute; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterSampleSource_W(Self: TSynCustomHighlighter; const T: string);
begin Self.SampleSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterSampleSource_R(Self: TSynCustomHighlighter; var T: string);
begin T := Self.SampleSource; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterCapabilities_R(Self: TSynCustomHighlighter; var T: TSynHighlighterCapabilities);
begin T := Self.Capabilities; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterAttribute_R(Self: TSynCustomHighlighter; var T: TSynHighlighterAttributes; const t1: integer);
begin T := Self.Attribute[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterAttrCount_R(Self: TSynCustomHighlighter; var T: integer);
begin T := Self.AttrCount; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterLanguageName_R(Self: TSynCustomHighlighter; var T: string);
begin T := Self.LanguageName; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterWordBreakChars_W(Self: TSynCustomHighlighter; const T: TSynIdentChars);
begin Self.WordBreakChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterWordBreakChars_R(Self: TSynCustomHighlighter; var T: TSynIdentChars);
begin T := Self.WordBreakChars; end;

(*----------------------------------------------------------------------------*)
procedure TSynCustomHighlighterIdentChars_R(Self: TSynCustomHighlighter; var T: TSynIdentChars);
begin T := Self.IdentChars; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesStyle_W(Self: TSynHighlighterAttributes; const T: TFontStyles);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesStyle_R(Self: TSynHighlighterAttributes; var T: TFontStyles);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesForeground_W(Self: TSynHighlighterAttributes; const T: TColor);
begin Self.Foreground := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesForeground_R(Self: TSynHighlighterAttributes; var T: TColor);
begin T := Self.Foreground; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesBackground_W(Self: TSynHighlighterAttributes; const T: TColor);
begin Self.Background := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesBackground_R(Self: TSynHighlighterAttributes; var T: TColor);
begin T := Self.Background; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesOnChange_W(Self: TSynHighlighterAttributes; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesOnChange_R(Self: TSynHighlighterAttributes; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesName_R(Self: TSynHighlighterAttributes; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesIntegerStyle_W(Self: TSynHighlighterAttributes; const T: integer);
begin Self.IntegerStyle := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynHighlighterAttributesIntegerStyle_R(Self: TSynHighlighterAttributes; var T: integer);
begin T := Self.IntegerStyle; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditHighlighter_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RegisterPlaceableHighlighter, 'RegisterPlaceableHighlighter', cdRegister);
 S.RegisterDelphiFunction(@GetPlaceableHighlighters, 'GetPlaceableHighlighters', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynHighlighterList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynHighlighterList) do begin
    RegisterConstructor(@TSynHighlighterList.Create, 'Create');
    RegisterMethod(@TSynHighlighterList.Destroy, 'Free');
    RegisterMethod(@TSynHighlighterList.Count, 'Count');
    RegisterMethod(@TSynHighlighterList.FindByName, 'FindByName');
    RegisterMethod(@TSynHighlighterList.FindByClass, 'FindByClass');
    RegisterPropertyHelper(@TSynHighlighterListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynCustomHighlighter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynCustomHighlighter) do begin
    RegisterVirtualMethod(@TSynCustomHighlighter.GetCapabilities, 'GetCapabilities');
    RegisterVirtualMethod(@TSynCustomHighlighter.GetLanguageName, 'GetLanguageName');
    RegisterConstructor(@TSynCustomHighlighter.Create, 'Create');
    RegisterMethod(@TSynCustomHighlighter.Destroy, 'Free');
    RegisterMethod(@TSynCustomHighlighter.Assign, 'Assign');
    RegisterMethod(@TSynCustomHighlighter.BeginUpdate, 'BeginUpdate');
    RegisterMethod(@TSynCustomHighlighter.EndUpdate, 'EndUpdate');
    //RegisterVirtualAbstractMethod(@TSynCustomHighlighter, @!.GetEol, 'GetEol');
    RegisterVirtualMethod(@TSynCustomHighlighter.GetRange, 'GetRange');
    //RegisterVirtualAbstractMethod(@TSynCustomHighlighter, @!.GetToken, 'GetToken');
    //RegisterVirtualAbstractMethod(@TSynCustomHighlighter, @!.GetTokenAttribute, 'GetTokenAttribute');
    //RegisterVirtualAbstractMethod(@TSynCustomHighlighter, @!.GetTokenKind, 'GetTokenKind');
    //RegisterVirtualAbstractMethod(@TSynCustomHighlighter, @!.GetTokenPos, 'GetTokenPos');
    RegisterVirtualMethod(@TSynCustomHighlighter.IsKeyword, 'IsKeyword');
    //RegisterVirtualAbstractMethod(@TSynCustomHighlighter, @!.Next, 'Next');
    RegisterMethod(@TSynCustomHighlighter.NextToEol, 'NextToEol');
    //RegisterVirtualAbstractMethod(@TSynCustomHighlighter, @!.SetLine, 'SetLine');
    RegisterVirtualMethod(@TSynCustomHighlighter.SetRange, 'SetRange');
    RegisterVirtualMethod(@TSynCustomHighlighter.ResetRange, 'ResetRange');
    RegisterVirtualMethod(@TSynCustomHighlighter.UseUserSettings, 'UseUserSettings');
    RegisterVirtualMethod(@TSynCustomHighlighter.EnumUserSettings, 'EnumUserSettings');
    RegisterVirtualMethod(@TSynCustomHighlighter.LoadFromRegistry, 'LoadFromRegistry');
    RegisterVirtualMethod(@TSynCustomHighlighter.SaveToRegistry, 'SaveToRegistry');
    RegisterMethod(@TSynCustomHighlighter.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TSynCustomHighlighter.SaveToFile, 'SaveToFile');
    RegisterMethod(@TSynCustomHighlighter.HookAttrChangeEvent, 'HookAttrChangeEvent');
    RegisterMethod(@TSynCustomHighlighter.UnhookAttrChangeEvent, 'UnhookAttrChangeEvent');
    RegisterPropertyHelper(@TSynCustomHighlighterIdentChars_R,nil,'IdentChars');
    RegisterPropertyHelper(@TSynCustomHighlighterWordBreakChars_R,@TSynCustomHighlighterWordBreakChars_W,'WordBreakChars');
    RegisterPropertyHelper(@TSynCustomHighlighterLanguageName_R,nil,'LanguageName');
    RegisterPropertyHelper(@TSynCustomHighlighterAttrCount_R,nil,'AttrCount');
    RegisterPropertyHelper(@TSynCustomHighlighterAttribute_R,nil,'Attribute');
    RegisterPropertyHelper(@TSynCustomHighlighterCapabilities_R,nil,'Capabilities');
    RegisterPropertyHelper(@TSynCustomHighlighterSampleSource_R,@TSynCustomHighlighterSampleSource_W,'SampleSource');
    RegisterPropertyHelper(@TSynCustomHighlighterCommentAttribute_R,nil,'CommentAttribute');
    RegisterPropertyHelper(@TSynCustomHighlighterIdentifierAttribute_R,nil,'IdentifierAttribute');
    RegisterPropertyHelper(@TSynCustomHighlighterKeywordAttribute_R,nil,'KeywordAttribute');
    RegisterPropertyHelper(@TSynCustomHighlighterStringAttribute_R,nil,'StringAttribute');
    RegisterPropertyHelper(@TSynCustomHighlighterSymbolAttribute_R,nil,'SymbolAttribute');
    RegisterPropertyHelper(@TSynCustomHighlighterWhitespaceAttribute_R,nil,'WhitespaceAttribute');
    RegisterPropertyHelper(@TSynCustomHighlighterDefaultFilter_R,@TSynCustomHighlighterDefaultFilter_W,'DefaultFilter');
    RegisterPropertyHelper(@TSynCustomHighlighterEnabled_R,@TSynCustomHighlighterEnabled_W,'Enabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynHighlighterAttributes(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynHighlighterAttributes) do begin
    RegisterMethod(@TSynHighlighterAttributes.AssignColorAndStyle, 'AssignColorAndStyle');
    RegisterConstructor(@TSynHighlighterAttributes.Create, 'Create');
    RegisterMethod(@TSynHighlighterAttributes.Destroy, 'Free');
    RegisterMethod(@TSynHighlighterAttributes.InternalSaveDefaultValues, 'InternalSaveDefaultValues');
    RegisterVirtualMethod(@TSynHighlighterAttributes.LoadFromBorlandRegistry, 'LoadFromBorlandRegistry');
    RegisterMethod(@TSynHighlighterAttributes.LoadFromRegistry, 'LoadFromRegistry');
    RegisterMethod(@TSynHighlighterAttributes.SaveToRegistry, 'SaveToRegistry');
    RegisterMethod(@TSynHighlighterAttributes.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TSynHighlighterAttributes.SaveToFile, 'SaveToFile');
    RegisterPropertyHelper(@TSynHighlighterAttributesIntegerStyle_R,@TSynHighlighterAttributesIntegerStyle_W,'IntegerStyle');
    RegisterPropertyHelper(@TSynHighlighterAttributesName_R,nil,'Name');
    RegisterPropertyHelper(@TSynHighlighterAttributesOnChange_R,@TSynHighlighterAttributesOnChange_W,'OnChange');
    RegisterPropertyHelper(@TSynHighlighterAttributesBackground_R,@TSynHighlighterAttributesBackground_W,'Background');
    RegisterPropertyHelper(@TSynHighlighterAttributesForeground_R,@TSynHighlighterAttributesForeground_W,'Foreground');
    RegisterPropertyHelper(@TSynHighlighterAttributesStyle_R,@TSynHighlighterAttributesStyle_W,'Style');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditHighlighter(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynHighlighterAttributes(CL);
  RIRegister_TSynCustomHighlighter(CL);
  RIRegister_TSynHighlighterList(CL);
end;

 
 
{ TPSImport_SynEditHighlighter }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditHighlighter.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditHighlighter(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditHighlighter.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynEditHighlighter(ri);
  RIRegister_SynEditHighlighter_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
