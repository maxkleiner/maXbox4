unit uPSI_SynHighlighterPas;
{
   at last the box of box pas
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
  TPSImport_SynHighlighterPas = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynPasSyn(CL: TPSPascalCompiler);
procedure SIRegister_SynHighlighterPas(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynPasSyn(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynHighlighterPas(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   {QGraphics
  ,QSynEditTypes
  ,QSynEditHighlighter  }
  //,Windows
  Graphics
  ,SynEditTypes
  ,SynEditHighlighter
  ,SynHighlighterPas
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynHighlighterPas]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynPasSyn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomHighlighter', 'TSynPasSyn') do
  with CL.AddClassN(CL.FindClass('TSynCustomHighlighter'),'TSynPasSyn') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    //RegisterMethod('Procedure Free');
    RegisterMethod('function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes');
    RegisterMethod('Function GetEol : Boolean');
    RegisterMethod('Function GetRange : Pointer');
    RegisterMethod('Function GetToken : string');
    RegisterMethod('Function GetTokenAttribute : TSynHighlighterAttributes');
    RegisterMethod('Function GetTokenID : TtkTokenKind');
    RegisterMethod('Function GetTokenKind : integer');
    RegisterMethod('Function GetTokenPos : Integer');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure ResetRange');
    RegisterMethod('Procedure SetLine( NewValue : string; LineNumber : Integer)');
    RegisterMethod('Procedure SetRange( Value : Pointer)');
    RegisterMethod('Function UseUserSettings( VersionIndex : integer) : boolean');
    RegisterMethod('Procedure EnumUserSettings( DelphiVersions : TStrings)');
    RegisterProperty('AsmAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('CommentAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('DirectiveAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('IdentifierAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('KeyAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('NumberAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('FloatAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('HexAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SpaceAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('StringAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('CharAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SymbolAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('DelphiVersion', 'TDelphiVersion', iptrw);
    RegisterProperty('PackageSource', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynHighlighterPas(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TtkTokenKind', '( tkAsm, tkComment, tkIdentifier, tkKey, tkNull,'
   +' tkNumber, tkSpace, tkString, tkSymbol, tkUnknown, tkFloat, tkHex, tkDirec, tkChar )');
  CL.AddTypeS('TRangeState', '( rsANil, rsAnsi, rsAnsiAsm, rsAsm, rsBor, rsBorA'
   +'sm, rsProperty, rsExports, rsDirective, rsDirectiveAsm, rsUnKnown )');
  CL.AddTypeS('TProcTableProc', 'Procedure');
  //CL.AddTypeS('PIdentFuncTableFunc', '^TIdentFuncTableFunc // will not work');
  CL.AddTypeS('TIdentFuncTableFunc', 'Function  : TtkTokenKind');
  CL.AddTypeS('TDelphiVersion', '( dvDelphi1, dvDelphi2, dvDelphi3, dvDelphi4, '
   +'dvDelphi5, dvDelphi6, dvDelphi7, dvDelphi8, dvDelphi2005 )');
 //CL.AddConstantN('LastDelphiVersion','').SetString( dvDelphi2005);
  SIRegister_TSynPasSyn(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynPasSynPackageSource_W(Self: TSynPasSyn; const T: Boolean);
begin Self.PackageSource := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynPackageSource_R(Self: TSynPasSyn; var T: Boolean);
begin T := Self.PackageSource; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynDelphiVersion_W(Self: TSynPasSyn; const T: TDelphiVersion);
begin Self.DelphiVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynDelphiVersion_R(Self: TSynPasSyn; var T: TDelphiVersion);
begin T := Self.DelphiVersion; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynSymbolAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.SymbolAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynSymbolAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.SymbolAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynCharAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.CharAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynCharAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.CharAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynStringAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.StringAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynStringAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.StringAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynSpaceAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.SpaceAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynSpaceAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.SpaceAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynHexAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.HexAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynHexAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.HexAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynFloatAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.FloatAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynFloatAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.FloatAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynNumberAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.NumberAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynNumberAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.NumberAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynKeyAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.KeyAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynKeyAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.KeyAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynIdentifierAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.IdentifierAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynIdentifierAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.IdentifierAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynDirectiveAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.DirectiveAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynDirectiveAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.DirectiveAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynCommentAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.CommentAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynCommentAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.CommentAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynAsmAttri_W(Self: TSynPasSyn; const T: TSynHighlighterAttributes);
begin Self.AsmAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPasSynAsmAttri_R(Self: TSynPasSyn; var T: TSynHighlighterAttributes);
begin T := Self.AsmAttri; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynPasSyn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynPasSyn) do begin
    RegisterConstructor(@TSynPasSyn.Create, 'Create');
    RegisterMethod(@TSynPasSyn.GetDefaultAttribute,'GetDefaultAttribute');
    RegisterMethod(@TSynPasSyn.GetEol, 'GetEol');
    RegisterMethod(@TSynPasSyn.GetRange, 'GetRange');
    RegisterMethod(@TSynPasSyn.GetToken, 'GetToken');
    RegisterMethod(@TSynPasSyn.GetTokenAttribute, 'GetTokenAttribute');
    RegisterMethod(@TSynPasSyn.GetTokenID, 'GetTokenID');
    RegisterMethod(@TSynPasSyn.GetTokenKind, 'GetTokenKind');
    RegisterMethod(@TSynPasSyn.GetTokenPos, 'GetTokenPos');
    RegisterMethod(@TSynPasSyn.Next, 'Next');
    RegisterMethod(@TSynPasSyn.ResetRange, 'ResetRange');
    RegisterMethod(@TSynPasSyn.SetLine, 'SetLine');
    RegisterMethod(@TSynPasSyn.SetRange, 'SetRange');
    RegisterMethod(@TSynPasSyn.UseUserSettings, 'UseUserSettings');
    RegisterMethod(@TSynPasSyn.EnumUserSettings, 'EnumUserSettings');
    RegisterPropertyHelper(@TSynPasSynAsmAttri_R,@TSynPasSynAsmAttri_W,'AsmAttri');
    RegisterPropertyHelper(@TSynPasSynCommentAttri_R,@TSynPasSynCommentAttri_W,'CommentAttri');
    RegisterPropertyHelper(@TSynPasSynDirectiveAttri_R,@TSynPasSynDirectiveAttri_W,'DirectiveAttri');
    RegisterPropertyHelper(@TSynPasSynIdentifierAttri_R,@TSynPasSynIdentifierAttri_W,'IdentifierAttri');
    RegisterPropertyHelper(@TSynPasSynKeyAttri_R,@TSynPasSynKeyAttri_W,'KeyAttri');
    RegisterPropertyHelper(@TSynPasSynNumberAttri_R,@TSynPasSynNumberAttri_W,'NumberAttri');
    RegisterPropertyHelper(@TSynPasSynFloatAttri_R,@TSynPasSynFloatAttri_W,'FloatAttri');
    RegisterPropertyHelper(@TSynPasSynHexAttri_R,@TSynPasSynHexAttri_W,'HexAttri');
    RegisterPropertyHelper(@TSynPasSynSpaceAttri_R,@TSynPasSynSpaceAttri_W,'SpaceAttri');
    RegisterPropertyHelper(@TSynPasSynStringAttri_R,@TSynPasSynStringAttri_W,'StringAttri');
    RegisterPropertyHelper(@TSynPasSynCharAttri_R,@TSynPasSynCharAttri_W,'CharAttri');
    RegisterPropertyHelper(@TSynPasSynSymbolAttri_R,@TSynPasSynSymbolAttri_W,'SymbolAttri');
    RegisterPropertyHelper(@TSynPasSynDelphiVersion_R,@TSynPasSynDelphiVersion_W,'DelphiVersion');
    RegisterPropertyHelper(@TSynPasSynPackageSource_R,@TSynPasSynPackageSource_W,'PackageSource');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynHighlighterPas(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynPasSyn(CL);
end;

 
 
{ TPSImport_SynHighlighterPas }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterPas.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynHighlighterPas(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterPas.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynHighlighterPas(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
