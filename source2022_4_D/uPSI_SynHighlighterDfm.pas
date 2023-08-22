unit uPSI_SynHighlighterDfm;
{
   two super functions
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
  TPSImport_SynHighlighterDfm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynDfmSyn(CL: TPSPascalCompiler);
procedure SIRegister_SynHighlighterDfm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynHighlighterDfm_Routines(S: TPSExec);
procedure RIRegister_TSynDfmSyn(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynHighlighterDfm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  Graphics
  ,SynEditTypes
  ,SynEditHighlighter
  ,SynHighlighterDfm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynHighlighterDfm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynDfmSyn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomHighlighter', 'TSynDfmSyn') do
  with CL.AddClassN(CL.FindClass('TSynCustomHighlighter'),'TSynDfmSyn') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetEol : Boolean');
    RegisterMethod('Function GetRange : Pointer');
    RegisterMethod('Function GetTokenID : TtkTokenKind');
    RegisterMethod('Procedure SetLine( NewValue : String; LineNumber : Integer)');
    RegisterMethod('Function GetToken : String');
    RegisterMethod('Function GetTokenAttribute : TSynHighlighterAttributes');
    RegisterMethod('Function GetTokenKind : integer');
    RegisterMethod('Function GetTokenPos : Integer');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure SetRange( Value : Pointer)');
    RegisterMethod('Procedure ResetRange');
    RegisterProperty('CommentAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('IdentifierAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('KeyAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('NumberAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SpaceAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('StringAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SymbolAttri', 'TSynHighlighterAttributes', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynHighlighterDfm(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TtkTokenKind', '( tkComment, tkIdentifier, tkKey, tkNull, tkNumb'
  // +'er, tkSpace, tkString, tkSymbol, tkUnknown )');
  //CL.AddTypeS('TRangeState', '( rsANil, rsComment, rsUnKnown )');
  //CL.AddTypeS('TProcTableProc', 'Procedure');
  SIRegister_TSynDfmSyn(CL);
 CL.AddDelphiFunction('Function LoadDFMFile2Strings( const AFile : string; AStrings : TStrings; var WasText : boolean) : integer');
 CL.AddDelphiFunction('Function SaveStrings2DFMFile( AStrings : TStrings; const AFile : string) : integer');

 CL.AddDelphiFunction('procedure GetHighlighters(AOwner: TComponent; AHighlighters: TStringList;'+
                        'AppendToList: boolean)');
CL.AddDelphiFunction('function GetHighlightersFilter(AHighlighters: TStringList): string;');
CL.AddDelphiFunction('function GetHighlighterFromFileExt(AHighlighters: TStringList; Extension: string): TSynCustomHighlighter;');


 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynDfmSynSymbolAttri_W(Self: TSynDfmSyn; const T: TSynHighlighterAttributes);
begin Self.SymbolAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynSymbolAttri_R(Self: TSynDfmSyn; var T: TSynHighlighterAttributes);
begin T := Self.SymbolAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynStringAttri_W(Self: TSynDfmSyn; const T: TSynHighlighterAttributes);
begin Self.StringAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynStringAttri_R(Self: TSynDfmSyn; var T: TSynHighlighterAttributes);
begin T := Self.StringAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynSpaceAttri_W(Self: TSynDfmSyn; const T: TSynHighlighterAttributes);
begin Self.SpaceAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynSpaceAttri_R(Self: TSynDfmSyn; var T: TSynHighlighterAttributes);
begin T := Self.SpaceAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynNumberAttri_W(Self: TSynDfmSyn; const T: TSynHighlighterAttributes);
begin Self.NumberAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynNumberAttri_R(Self: TSynDfmSyn; var T: TSynHighlighterAttributes);
begin T := Self.NumberAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynKeyAttri_W(Self: TSynDfmSyn; const T: TSynHighlighterAttributes);
begin Self.KeyAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynKeyAttri_R(Self: TSynDfmSyn; var T: TSynHighlighterAttributes);
begin T := Self.KeyAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynIdentifierAttri_W(Self: TSynDfmSyn; const T: TSynHighlighterAttributes);
begin Self.IdentifierAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynIdentifierAttri_R(Self: TSynDfmSyn; var T: TSynHighlighterAttributes);
begin T := Self.IdentifierAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynCommentAttri_W(Self: TSynDfmSyn; const T: TSynHighlighterAttributes);
begin Self.CommentAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDfmSynCommentAttri_R(Self: TSynDfmSyn; var T: TSynHighlighterAttributes);
begin T := Self.CommentAttri; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynHighlighterDfm_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@LoadDFMFile2Strings, 'LoadDFMFile2Strings', cdRegister);
 S.RegisterDelphiFunction(@SaveStrings2DFMFile, 'SaveStrings2DFMFile', cdRegister);
 S.RegisterDelphiFunction(@GetHighlighters, 'GetHighlighters', cdRegister);
 S.RegisterDelphiFunction(@GetHighlightersFilter, 'GetHighlightersFilter', cdRegister);
 S.RegisterDelphiFunction(@GetHighlighterFromFileExt, 'GetHighlighterFromFileExt', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynDfmSyn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynDfmSyn) do begin
    RegisterConstructor(@TSynDfmSyn.Create, 'Create');
    RegisterMethod(@TSynDfmSyn.GetEol, 'GetEol');
    RegisterMethod(@TSynDfmSyn.GetRange, 'GetRange');
    RegisterMethod(@TSynDfmSyn.GetTokenID, 'GetTokenID');
    RegisterMethod(@TSynDfmSyn.SetLine, 'SetLine');
    RegisterMethod(@TSynDfmSyn.GetToken, 'GetToken');
    RegisterMethod(@TSynDfmSyn.GetTokenAttribute, 'GetTokenAttribute');
    RegisterMethod(@TSynDfmSyn.GetTokenKind, 'GetTokenKind');
    RegisterMethod(@TSynDfmSyn.GetTokenPos, 'GetTokenPos');
    RegisterMethod(@TSynDfmSyn.Next, 'Next');
    RegisterMethod(@TSynDfmSyn.SetRange, 'SetRange');
    RegisterMethod(@TSynDfmSyn.ResetRange, 'ResetRange');
    RegisterPropertyHelper(@TSynDfmSynCommentAttri_R,@TSynDfmSynCommentAttri_W,'CommentAttri');
    RegisterPropertyHelper(@TSynDfmSynIdentifierAttri_R,@TSynDfmSynIdentifierAttri_W,'IdentifierAttri');
    RegisterPropertyHelper(@TSynDfmSynKeyAttri_R,@TSynDfmSynKeyAttri_W,'KeyAttri');
    RegisterPropertyHelper(@TSynDfmSynNumberAttri_R,@TSynDfmSynNumberAttri_W,'NumberAttri');
    RegisterPropertyHelper(@TSynDfmSynSpaceAttri_R,@TSynDfmSynSpaceAttri_W,'SpaceAttri');
    RegisterPropertyHelper(@TSynDfmSynStringAttri_R,@TSynDfmSynStringAttri_W,'StringAttri');
    RegisterPropertyHelper(@TSynDfmSynSymbolAttri_R,@TSynDfmSynSymbolAttri_W,'SymbolAttri');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynHighlighterDfm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynDfmSyn(CL);
end;

 
 
{ TPSImport_SynHighlighterDfm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterDfm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynHighlighterDfm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterDfm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynHighlighterDfm(ri);
  RIRegister_SynHighlighterDfm_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
