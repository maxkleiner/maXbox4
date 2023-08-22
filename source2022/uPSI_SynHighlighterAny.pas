unit uPSI_SynHighlighterAny;
{
   to set found words in color
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
  TPSImport_SynHighlighterAny = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynAnySyn(CL: TPSPascalCompiler);
procedure SIRegister_TIniList(CL: TPSPascalCompiler);
procedure SIRegister_SynHighlighterAny(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynAnySyn(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIniList(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynHighlighterAny(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // FileUtil
  Controls
  //,Graphics
  //,Registry
  ,SynEditTypes
  ,SynEditHighlighter
  ,SynHighlighterAny
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynHighlighterAny]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynAnySyn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomHighlighter', 'TSynAnySyn') do
  with CL.AddClassN(CL.FindClass('TSynCustomHighlighter'),'TSynAnySyn') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetEol : Boolean');
    RegisterMethod('Function GetRange : Pointer');
    RegisterMethod('Function GetTokenID : TtkTokenKind');
    RegisterMethod('Function GetToken : String');
    RegisterMethod('Procedure GetTokenEx( out TokenStart : PChar; out TokenLength : integer)');
    RegisterMethod('Function GetTokenAttribute : TSynHighlighterAttributes');
    RegisterMethod('Function GetTokenKind : integer');
    RegisterMethod('Function GetTokenPos : Integer');
    RegisterMethod('Function IsKeyword( const AKeyword : string) : boolean');
    RegisterMethod('Function IsConstant( const AConstant : string) : boolean');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure ResetRange');
    RegisterMethod('Procedure SetRange( Value : Pointer)');
    RegisterMethod('Procedure SetLine( const NewValue : String; LineNumber : Integer)');
    RegisterMethod('Function SaveToRegistry( RootKey : HKEY; Key : string) : boolean');
    RegisterMethod('Function LoadFromRegistry( RootKey : HKEY; Key : string) : boolean');
    RegisterMethod('Procedure LoadHighLighter( aFile : string)');
    RegisterProperty('CommentAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('Comments', 'CommentStyles', iptrw);
    RegisterProperty('DetectPreprocessor', 'boolean', iptrw);
    RegisterProperty('IdentifierAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('IdentifierChars', 'string', iptrw);
    RegisterProperty('KeyAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('ConstantAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('ObjectAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('EntityAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('VariableAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('DotAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('KeyWords', 'TStrings', iptrw);
    RegisterProperty('Constants', 'TStrings', iptrw);
    RegisterProperty('Objects', 'TStrings', iptrw);
    RegisterProperty('NumberAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('PreprocessorAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SpaceAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('StringAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SymbolAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('StringDelim', 'TStringDelim', iptrw);
    RegisterProperty('Markup', 'boolean', iptrw);
    RegisterProperty('Entity', 'boolean', iptrw);
    RegisterProperty('DollarVariables', 'boolean', iptrw);
    RegisterProperty('ActiveDot', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIniList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TIniList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TIniList') do begin
    RegisterMethod('Function ReadString( asection, akey, adefault : string) : string');
    RegisterMethod('Function ReadInteger( asection, akey : string; adefault : integer) : integer');
    RegisterMethod('Function ReadBool( asection, akey : string; adefault : boolean) : boolean');
    RegisterMethod('Procedure ReadSectionNames( asection : string; alist : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynHighlighterAny(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TtkTokenKind', '( tkComment, tkIdentifier, tkKey, tkNull, tkNumb'
   +'er, tkPreprocessor, tkSpace, tkString, tkSymbol, tkUnknown, tkConstant, tk'
   +'Object, tkEntity, tkDollarVariable, tkDot )');
  CL.AddTypeS('TCommentStyle', '(csAnsiStyle, csPasStyle, csCStyle, csAsmStyle, csBasStyle, csVBStyle)');
  CL.AddTypeS('CommentStyles', 'set of TCommentStyle');
  CL.AddTypeS('TRangeState','(rsANil,rsAnsi,rsPasStyle,rsCStyle,rsUnKnown)');
  CL.AddTypeS('TStringDelim', '( sdSingleQuote, sdDoubleQuote )');
  CL.AddTypeS('TProcTableProc', 'Procedure');
  SIRegister_TIniList(CL);
  SIRegister_TSynAnySyn(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynAnySynActiveDot_W(Self: TSynAnySyn; const T: boolean);
begin Self.ActiveDot := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynActiveDot_R(Self: TSynAnySyn; var T: boolean);
begin T := Self.ActiveDot; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynDollarVariables_W(Self: TSynAnySyn; const T: boolean);
begin Self.DollarVariables := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynDollarVariables_R(Self: TSynAnySyn; var T: boolean);
begin T := Self.DollarVariables; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynEntity_W(Self: TSynAnySyn; const T: boolean);
begin Self.Entity := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynEntity_R(Self: TSynAnySyn; var T: boolean);
begin T := Self.Entity; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynMarkup_W(Self: TSynAnySyn; const T: boolean);
begin Self.Markup := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynMarkup_R(Self: TSynAnySyn; var T: boolean);
begin T := Self.Markup; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynStringDelim_W(Self: TSynAnySyn; const T: TStringDelim);
begin Self.StringDelim := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynStringDelim_R(Self: TSynAnySyn; var T: TStringDelim);
begin T := Self.StringDelim; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynSymbolAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.SymbolAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynSymbolAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.SymbolAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynStringAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.StringAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynStringAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.StringAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynSpaceAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.SpaceAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynSpaceAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.SpaceAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynPreprocessorAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.PreprocessorAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynPreprocessorAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.PreprocessorAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynNumberAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.NumberAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynNumberAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.NumberAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynObjects_W(Self: TSynAnySyn; const T: TStrings);
begin Self.Objects := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynObjects_R(Self: TSynAnySyn; var T: TStrings);
begin T := Self.Objects; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynConstants_W(Self: TSynAnySyn; const T: TStrings);
begin Self.Constants := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynConstants_R(Self: TSynAnySyn; var T: TStrings);
begin T := Self.Constants; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynKeyWords_W(Self: TSynAnySyn; const T: TStrings);
begin Self.KeyWords := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynKeyWords_R(Self: TSynAnySyn; var T: TStrings);
begin T := Self.KeyWords; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynDotAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.DotAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynDotAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.DotAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynVariableAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.VariableAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynVariableAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.VariableAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynEntityAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.EntityAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynEntityAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.EntityAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynObjectAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.ObjectAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynObjectAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.ObjectAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynConstantAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.ConstantAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynConstantAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.ConstantAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynKeyAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.KeyAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynKeyAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.KeyAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynIdentifierChars_W(Self: TSynAnySyn; const T: string);
begin Self.IdentifierChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynIdentifierChars_R(Self: TSynAnySyn; var T: string);
begin T := Self.IdentifierChars; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynIdentifierAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.IdentifierAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynIdentifierAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.IdentifierAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynDetectPreprocessor_W(Self: TSynAnySyn; const T: boolean);
begin Self.DetectPreprocessor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynDetectPreprocessor_R(Self: TSynAnySyn; var T: boolean);
begin T := Self.DetectPreprocessor; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynComments_W(Self: TSynAnySyn; const T: CommentStyles);
begin Self.Comments := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynComments_R(Self: TSynAnySyn; var T: CommentStyles);
begin T := Self.Comments; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynCommentAttri_W(Self: TSynAnySyn; const T: TSynHighlighterAttributes);
begin Self.CommentAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynAnySynCommentAttri_R(Self: TSynAnySyn; var T: TSynHighlighterAttributes);
begin T := Self.CommentAttri; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynAnySyn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynAnySyn) do begin
    RegisterConstructor(@TSynAnySyn.Create, 'Create');
    RegisterMethod(@TSynAnySyn.Destroy, 'Free');
    RegisterMethod(@TSynAnySyn.GetEol, 'GetEol');
    RegisterMethod(@TSynAnySyn.GetRange, 'GetRange');
    RegisterMethod(@TSynAnySyn.GetTokenID, 'GetTokenID');
    RegisterMethod(@TSynAnySyn.GetToken, 'GetToken');
    //RegisterMethod(@TSynAnySyn.GetTokenEx, 'GetTokenEx');
    RegisterMethod(@TSynAnySyn.GetTokenAttribute, 'GetTokenAttribute');
    RegisterMethod(@TSynAnySyn.GetTokenKind, 'GetTokenKind');
    RegisterMethod(@TSynAnySyn.GetTokenPos, 'GetTokenPos');
    RegisterMethod(@TSynAnySyn.IsKeyword, 'IsKeyword');
    RegisterMethod(@TSynAnySyn.IsConstant, 'IsConstant');
    RegisterMethod(@TSynAnySyn.Next, 'Next');
    RegisterMethod(@TSynAnySyn.ResetRange, 'ResetRange');
    RegisterMethod(@TSynAnySyn.SetRange, 'SetRange');
    RegisterMethod(@TSynAnySyn.SetLine, 'SetLine');
    RegisterMethod(@TSynAnySyn.SaveToRegistry, 'SaveToRegistry');
    RegisterMethod(@TSynAnySyn.LoadFromRegistry, 'LoadFromRegistry');
    RegisterMethod(@TSynAnySyn.LoadHighLighter, 'LoadHighLighter');
    RegisterPropertyHelper(@TSynAnySynCommentAttri_R,@TSynAnySynCommentAttri_W,'CommentAttri');
    RegisterPropertyHelper(@TSynAnySynComments_R,@TSynAnySynComments_W,'Comments');
    RegisterPropertyHelper(@TSynAnySynDetectPreprocessor_R,@TSynAnySynDetectPreprocessor_W,'DetectPreprocessor');
    RegisterPropertyHelper(@TSynAnySynIdentifierAttri_R,@TSynAnySynIdentifierAttri_W,'IdentifierAttri');
    RegisterPropertyHelper(@TSynAnySynIdentifierChars_R,@TSynAnySynIdentifierChars_W,'IdentifierChars');
    RegisterPropertyHelper(@TSynAnySynKeyAttri_R,@TSynAnySynKeyAttri_W,'KeyAttri');
    RegisterPropertyHelper(@TSynAnySynConstantAttri_R,@TSynAnySynConstantAttri_W,'ConstantAttri');
    RegisterPropertyHelper(@TSynAnySynObjectAttri_R,@TSynAnySynObjectAttri_W,'ObjectAttri');
    RegisterPropertyHelper(@TSynAnySynEntityAttri_R,@TSynAnySynEntityAttri_W,'EntityAttri');
    RegisterPropertyHelper(@TSynAnySynVariableAttri_R,@TSynAnySynVariableAttri_W,'VariableAttri');
    RegisterPropertyHelper(@TSynAnySynDotAttri_R,@TSynAnySynDotAttri_W,'DotAttri');
    RegisterPropertyHelper(@TSynAnySynKeyWords_R,@TSynAnySynKeyWords_W,'KeyWords');
    RegisterPropertyHelper(@TSynAnySynConstants_R,@TSynAnySynConstants_W,'Constants');
    RegisterPropertyHelper(@TSynAnySynObjects_R,@TSynAnySynObjects_W,'Objects');
    RegisterPropertyHelper(@TSynAnySynNumberAttri_R,@TSynAnySynNumberAttri_W,'NumberAttri');
    RegisterPropertyHelper(@TSynAnySynPreprocessorAttri_R,@TSynAnySynPreprocessorAttri_W,'PreprocessorAttri');
    RegisterPropertyHelper(@TSynAnySynSpaceAttri_R,@TSynAnySynSpaceAttri_W,'SpaceAttri');
    RegisterPropertyHelper(@TSynAnySynStringAttri_R,@TSynAnySynStringAttri_W,'StringAttri');
    RegisterPropertyHelper(@TSynAnySynSymbolAttri_R,@TSynAnySynSymbolAttri_W,'SymbolAttri');
    RegisterPropertyHelper(@TSynAnySynStringDelim_R,@TSynAnySynStringDelim_W,'StringDelim');
    RegisterPropertyHelper(@TSynAnySynMarkup_R,@TSynAnySynMarkup_W,'Markup');
    RegisterPropertyHelper(@TSynAnySynEntity_R,@TSynAnySynEntity_W,'Entity');
    RegisterPropertyHelper(@TSynAnySynDollarVariables_R,@TSynAnySynDollarVariables_W,'DollarVariables');
    RegisterPropertyHelper(@TSynAnySynActiveDot_R,@TSynAnySynActiveDot_W,'ActiveDot');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIniList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIniList) do begin
    RegisterMethod(@TIniList.ReadString, 'ReadString');
    RegisterMethod(@TIniList.ReadInteger, 'ReadInteger');
    RegisterMethod(@TIniList.ReadBool, 'ReadBool');
    RegisterMethod(@TIniList.ReadSectionNames, 'ReadSectionNames');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynHighlighterAny(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIniList(CL);
  RIRegister_TSynAnySyn(CL);
end;

 
 
{ TPSImport_SynHighlighterAny }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterAny.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynHighlighterAny(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterAny.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynHighlighterAny(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
