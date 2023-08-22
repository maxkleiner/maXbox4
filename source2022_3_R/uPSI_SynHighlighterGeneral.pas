unit uPSI_SynHighlighterGeneral;
{
  for script executor
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
  TPSImport_SynHighlighterGeneral = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynGeneralSyn(CL: TPSPascalCompiler);
procedure SIRegister_SynHighlighterGeneral(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynGeneralSyn(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynHighlighterGeneral(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // QGraphics
  //,QSynEditTypes
  //,QSynEditHighlighter
  Windows
  ,Graphics
  ,SynEditTypes
  ,SynEditHighlighter
  ,SynHighlighterGeneral
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynHighlighterGeneral]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynGeneralSyn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomHighlighter', 'TSynGeneralSyn') do
  with CL.AddClassN(CL.FindClass('TSynCustomHighlighter'),'TSynGeneralSyn') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetDefaultAttribute( Index : integer) : TSynHighlighterAttributes');
    RegisterMethod('Function GetEol : Boolean');
    RegisterMethod('Function GetRange : Pointer');
    RegisterMethod('Function GetTokenID : TtkTokenKind');
    RegisterMethod('Function GetToken : String');
    RegisterMethod('Function GetTokenAttribute : TSynHighlighterAttributes');
    RegisterMethod('Function GetTokenKind : integer');
    RegisterMethod('Function GetTokenPos : Integer');
    RegisterMethod('Function IsKeyword( const AKeyword : string) : boolean');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure ResetRange');
    RegisterMethod('Procedure SetRange( Value : Pointer)');
    RegisterMethod('Procedure SetLine( NewValue : String; LineNumber : Integer)');
    RegisterProperty('CommentAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('Comments', 'TCommentStylesG', iptrw);
    RegisterProperty('DetectPreprocessor', 'boolean', iptrw);
    RegisterProperty('IdentifierAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('IdentifierChars', 'string', iptrw);
    RegisterProperty('KeyAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('KeyWords', 'TStrings', iptrw);
    RegisterProperty('NumberAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('PreprocessorAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SpaceAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('StringAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SymbolAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('StringDelim', 'TStringDelimG', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynHighlighterGeneral(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TtkTokenKindG', '( tkComment, tkIdentifier, tkKey, tkNull, tkNumb'
   +'er, tkPreprocessor, tkSpace, tkString, tkSymbol, tkUnknown )');
  CL.AddTypeS('TCommentStyleG', '( csAnsiStyle, csPasStyle, csCStyle, csAsmStyle, csBasStyle, csCPPStyle )');
  CL.AddTypeS('TCommentStyles', 'set of TCommentStyleG');
  CL.AddTypeS('TRangeStateG', '( rsANil, rsAnsi, rsPasStyle, rsCStyle, rsUnKnown)');
  CL.AddTypeS('TStringDelimG', '( sdSingleQuote, sdDoubleQuote )');
  CL.AddTypeS('TProcTableProcG', 'Procedure');
  SIRegister_TSynGeneralSyn(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynStringDelim_W(Self: TSynGeneralSyn; const T: TStringDelim);
begin Self.StringDelim := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynStringDelim_R(Self: TSynGeneralSyn; var T: TStringDelim);
begin T := Self.StringDelim; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynSymbolAttri_W(Self: TSynGeneralSyn; const T: TSynHighlighterAttributes);
begin Self.SymbolAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynSymbolAttri_R(Self: TSynGeneralSyn; var T: TSynHighlighterAttributes);
begin T := Self.SymbolAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynStringAttri_W(Self: TSynGeneralSyn; const T: TSynHighlighterAttributes);
begin Self.StringAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynStringAttri_R(Self: TSynGeneralSyn; var T: TSynHighlighterAttributes);
begin T := Self.StringAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynSpaceAttri_W(Self: TSynGeneralSyn; const T: TSynHighlighterAttributes);
begin Self.SpaceAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynSpaceAttri_R(Self: TSynGeneralSyn; var T: TSynHighlighterAttributes);
begin T := Self.SpaceAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynPreprocessorAttri_W(Self: TSynGeneralSyn; const T: TSynHighlighterAttributes);
begin Self.PreprocessorAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynPreprocessorAttri_R(Self: TSynGeneralSyn; var T: TSynHighlighterAttributes);
begin T := Self.PreprocessorAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynNumberAttri_W(Self: TSynGeneralSyn; const T: TSynHighlighterAttributes);
begin Self.NumberAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynNumberAttri_R(Self: TSynGeneralSyn; var T: TSynHighlighterAttributes);
begin T := Self.NumberAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynKeyWords_W(Self: TSynGeneralSyn; const T: TStrings);
begin Self.KeyWords := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynKeyWords_R(Self: TSynGeneralSyn; var T: TStrings);
begin T := Self.KeyWords; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynKeyAttri_W(Self: TSynGeneralSyn; const T: TSynHighlighterAttributes);
begin Self.KeyAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynKeyAttri_R(Self: TSynGeneralSyn; var T: TSynHighlighterAttributes);
begin T := Self.KeyAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynIdentifierChars_W(Self: TSynGeneralSyn; const T: string);
begin Self.IdentifierChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynIdentifierChars_R(Self: TSynGeneralSyn; var T: string);
begin T := Self.IdentifierChars; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynIdentifierAttri_W(Self: TSynGeneralSyn; const T: TSynHighlighterAttributes);
begin Self.IdentifierAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynIdentifierAttri_R(Self: TSynGeneralSyn; var T: TSynHighlighterAttributes);
begin T := Self.IdentifierAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynDetectPreprocessor_W(Self: TSynGeneralSyn; const T: boolean);
begin Self.DetectPreprocessor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynDetectPreprocessor_R(Self: TSynGeneralSyn; var T: boolean);
begin T := Self.DetectPreprocessor; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynComments_W(Self: TSynGeneralSyn; const T: TCommentStyles);
begin Self.Comments := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynComments_R(Self: TSynGeneralSyn; var T: TCommentStyles);
begin T := Self.Comments; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynCommentAttri_W(Self: TSynGeneralSyn; const T: TSynHighlighterAttributes);
begin Self.CommentAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynGeneralSynCommentAttri_R(Self: TSynGeneralSyn; var T: TSynHighlighterAttributes);
begin T := Self.CommentAttri; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynGeneralSyn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynGeneralSyn) do
  begin
    RegisterConstructor(@TSynGeneralSyn.Create, 'Create');
    RegisterMethod(@TSynGeneralSyn.GetDefaultAttribute, 'GetDefaultAttribute');
    RegisterMethod(@TSynGeneralSyn.GetEol, 'GetEol');
    RegisterMethod(@TSynGeneralSyn.GetRange, 'GetRange');
    RegisterMethod(@TSynGeneralSyn.GetTokenID, 'GetTokenID');
    RegisterMethod(@TSynGeneralSyn.GetToken, 'GetToken');
    RegisterMethod(@TSynGeneralSyn.GetTokenAttribute, 'GetTokenAttribute');
    RegisterMethod(@TSynGeneralSyn.GetTokenKind, 'GetTokenKind');
    RegisterMethod(@TSynGeneralSyn.GetTokenPos, 'GetTokenPos');
    RegisterMethod(@TSynGeneralSyn.IsKeyword, 'IsKeyword');
    RegisterMethod(@TSynGeneralSyn.Next, 'Next');
    RegisterMethod(@TSynGeneralSyn.ResetRange, 'ResetRange');
    RegisterMethod(@TSynGeneralSyn.SetRange, 'SetRange');
    RegisterMethod(@TSynGeneralSyn.SetLine, 'SetLine');
    RegisterPropertyHelper(@TSynGeneralSynCommentAttri_R,@TSynGeneralSynCommentAttri_W,'CommentAttri');
    RegisterPropertyHelper(@TSynGeneralSynComments_R,@TSynGeneralSynComments_W,'Comments');
    RegisterPropertyHelper(@TSynGeneralSynDetectPreprocessor_R,@TSynGeneralSynDetectPreprocessor_W,'DetectPreprocessor');
    RegisterPropertyHelper(@TSynGeneralSynIdentifierAttri_R,@TSynGeneralSynIdentifierAttri_W,'IdentifierAttri');
    RegisterPropertyHelper(@TSynGeneralSynIdentifierChars_R,@TSynGeneralSynIdentifierChars_W,'IdentifierChars');
    RegisterPropertyHelper(@TSynGeneralSynKeyAttri_R,@TSynGeneralSynKeyAttri_W,'KeyAttri');
    RegisterPropertyHelper(@TSynGeneralSynKeyWords_R,@TSynGeneralSynKeyWords_W,'KeyWords');
    RegisterPropertyHelper(@TSynGeneralSynNumberAttri_R,@TSynGeneralSynNumberAttri_W,'NumberAttri');
    RegisterPropertyHelper(@TSynGeneralSynPreprocessorAttri_R,@TSynGeneralSynPreprocessorAttri_W,'PreprocessorAttri');
    RegisterPropertyHelper(@TSynGeneralSynSpaceAttri_R,@TSynGeneralSynSpaceAttri_W,'SpaceAttri');
    RegisterPropertyHelper(@TSynGeneralSynStringAttri_R,@TSynGeneralSynStringAttri_W,'StringAttri');
    RegisterPropertyHelper(@TSynGeneralSynSymbolAttri_R,@TSynGeneralSynSymbolAttri_W,'SymbolAttri');
    RegisterPropertyHelper(@TSynGeneralSynStringDelim_R,@TSynGeneralSynStringDelim_W,'StringDelim');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynHighlighterGeneral(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynGeneralSyn(CL);
end;

 
 
{ TPSImport_SynHighlighterGeneral }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterGeneral.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynHighlighterGeneral(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterGeneral.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynHighlighterGeneral(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
