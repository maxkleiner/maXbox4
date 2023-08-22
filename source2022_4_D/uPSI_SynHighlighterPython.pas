unit uPSI_SynHighlighterPython;
{
or for d4p and vcl4py_

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
  TPSImport_SynHighlighterPython = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynPythonSyn(CL: TPSPascalCompiler);
procedure SIRegister_SynHighlighterPython(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynPythonSyn(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynHighlighterPython(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  { QGraphics
  ,QSynEditHighlighter
  ,QSynEditTypes
  ,QSynUnicode    }
  Graphics
  ,SynEditHighlighter
  ,SynEditTypes
  //,SynUnicode
  ,SynHighlighterPython
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynHighlighterPython]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynPythonSyn(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomHighLighter', 'TSynPythonSyn') do
  with CL.AddClassN(CL.FindClass('TSynCustomHighLighter'),'TSynPythonSyn') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function GetDefaultAttribute( Index : integer) : TSynHighlighterAttributes');
    RegisterMethod('Function GetEol : Boolean');
    RegisterMethod('Function GetRange : Pointer');
    RegisterMethod('Function GetTokenID : TtkTokenKind');
    RegisterMethod('Function GetTokenAttribute : TSynHighlighterAttributes');
    RegisterMethod('Function GetTokenKind : integer');
    RegisterMethod('Procedure Next');
    RegisterMethod('Procedure SetRange( Value : Pointer)');
    RegisterMethod('Procedure ResetRange');
    RegisterMethod('Function GetSampleSource2 : string');
    //TSynPythonSyn.GetSampleSource2: string;
    RegisterProperty('CommentAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('IdentifierAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('KeyAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('NonKeyAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SystemAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('NumberAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('HexAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('OctalAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('FloatAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SpaceAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('StringAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('DocStringAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SymbolAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('ErrorAttri', 'TSynHighlighterAttributes', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynHighlighterPython(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TtkTokenKindpy', '( tkComment, tkIdentifier, tkKey, tkNull, tkNumb'
   +'er, tkSpace, tkString, tkSymbol, tkNonKeyword, tkTrippleQuotedString, tkSy'
   +'stemDefined, tkHex, tkOct, tkFloat, tkUnknown )');
  CL.AddTypeS('TRangeStatepy', '( rsANil, rsComment, rsUnKnown, rsMultilineString'
   +', rsMultilineString2, rsMultilineString3 )');
  SIRegister_TSynPythonSyn(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynPythonSynErrorAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.ErrorAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynErrorAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.ErrorAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynSymbolAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.SymbolAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynSymbolAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.SymbolAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynDocStringAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.DocStringAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynDocStringAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.DocStringAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynStringAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.StringAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynStringAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.StringAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynSpaceAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.SpaceAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynSpaceAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.SpaceAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynFloatAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.FloatAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynFloatAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.FloatAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynOctalAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.OctalAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynOctalAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.OctalAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynHexAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.HexAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynHexAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.HexAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynNumberAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.NumberAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynNumberAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.NumberAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynSystemAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.SystemAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynSystemAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.SystemAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynNonKeyAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.NonKeyAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynNonKeyAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.NonKeyAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynKeyAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.KeyAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynKeyAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.KeyAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynIdentifierAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.IdentifierAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynIdentifierAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.IdentifierAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynCommentAttri_W(Self: TSynPythonSyn; const T: TSynHighlighterAttributes);
begin Self.CommentAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPythonSynCommentAttri_R(Self: TSynPythonSyn; var T: TSynHighlighterAttributes);
begin T := Self.CommentAttri; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynPythonSyn(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynPythonSyn) do
  begin
    RegisterConstructor(@TSynPythonSyn.Create, 'Create');
     RegisterMethod(@TSynPythonSyn.Destroy, 'Free');
    RegisterMethod(@TSynPythonSyn.GetDefaultAttribute, 'GetDefaultAttribute');
    RegisterMethod(@TSynPythonSyn.GetEol, 'GetEol');
    RegisterMethod(@TSynPythonSyn.GetRange, 'GetRange');
    RegisterMethod(@TSynPythonSyn.GetTokenID, 'GetTokenID');
    RegisterMethod(@TSynPythonSyn.GetTokenAttribute, 'GetTokenAttribute');
    RegisterMethod(@TSynPythonSyn.GetTokenKind, 'GetTokenKind');
    RegisterMethod(@TSynPythonSyn.Next, 'Next');
    RegisterMethod(@TSynPythonSyn.SetRange, 'SetRange');
    RegisterMethod(@TSynPythonSyn.ResetRange, 'ResetRange');
    RegisterMethod(@TSynPythonSyn.GetSampleSource2, 'GetSampleSource2');
    RegisterPropertyHelper(@TSynPythonSynCommentAttri_R,@TSynPythonSynCommentAttri_W,'CommentAttri');
    RegisterPropertyHelper(@TSynPythonSynIdentifierAttri_R,@TSynPythonSynIdentifierAttri_W,'IdentifierAttri');
    RegisterPropertyHelper(@TSynPythonSynKeyAttri_R,@TSynPythonSynKeyAttri_W,'KeyAttri');
    RegisterPropertyHelper(@TSynPythonSynNonKeyAttri_R,@TSynPythonSynNonKeyAttri_W,'NonKeyAttri');
    RegisterPropertyHelper(@TSynPythonSynSystemAttri_R,@TSynPythonSynSystemAttri_W,'SystemAttri');
    RegisterPropertyHelper(@TSynPythonSynNumberAttri_R,@TSynPythonSynNumberAttri_W,'NumberAttri');
    RegisterPropertyHelper(@TSynPythonSynHexAttri_R,@TSynPythonSynHexAttri_W,'HexAttri');
    RegisterPropertyHelper(@TSynPythonSynOctalAttri_R,@TSynPythonSynOctalAttri_W,'OctalAttri');
    RegisterPropertyHelper(@TSynPythonSynFloatAttri_R,@TSynPythonSynFloatAttri_W,'FloatAttri');
    RegisterPropertyHelper(@TSynPythonSynSpaceAttri_R,@TSynPythonSynSpaceAttri_W,'SpaceAttri');
    RegisterPropertyHelper(@TSynPythonSynStringAttri_R,@TSynPythonSynStringAttri_W,'StringAttri');
    RegisterPropertyHelper(@TSynPythonSynDocStringAttri_R,@TSynPythonSynDocStringAttri_W,'DocStringAttri');
    RegisterPropertyHelper(@TSynPythonSynSymbolAttri_R,@TSynPythonSynSymbolAttri_W,'SymbolAttri');
    RegisterPropertyHelper(@TSynPythonSynErrorAttri_R,@TSynPythonSynErrorAttri_W,'ErrorAttri');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynHighlighterPython(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynPythonSyn(CL);
end;

 
 
{ TPSImport_SynHighlighterPython }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterPython.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynHighlighterPython(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynHighlighterPython.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynHighlighterPython(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
