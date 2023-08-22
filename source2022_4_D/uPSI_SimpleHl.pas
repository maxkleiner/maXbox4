unit uPSI_SimpleHl;
{
  prepare to folder
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
  TPSImport_SimpleHl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynDemoHl(CL: TPSPascalCompiler);
procedure SIRegister_SimpleHl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynDemoHl(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimpleHl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Graphics
  ,SynEditTypes
  ,SynEditHighlighter
  ,SimpleHl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleHl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynDemoHl(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynCustomHighlighter', 'TSynDemoHl') do
  with CL.AddClassN(CL.FindClass('TSynCustomHighlighter'),'TSynDemoHl') do begin
    RegisterMethod('Procedure SetLine( const NewValue : String; LineNumber : Integer)');
    RegisterMethod('Procedure Next');
    RegisterMethod('Function GetEol : Boolean');
    RegisterMethod('Procedure GetTokenEx( out TokenStart : PChar; out TokenLength : integer)');
    RegisterMethod('Function GetTokenAttribute : TSynHighlighterAttributes');
    RegisterMethod('Function GetToken : String');
    RegisterMethod('Function GetTokenPos : Integer');
    RegisterMethod('Function GetTokenKind : integer');
    RegisterMethod('Function GetDefaultAttribute( Index : integer) : TSynHighlighterAttributes');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('SpecialAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('NotAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('IdentifierAttri', 'TSynHighlighterAttributes', iptrw);
    RegisterProperty('SpaceAttri', 'TSynHighlighterAttributes', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleHl(CL: TPSPascalCompiler);
begin
  SIRegister_TSynDemoHl(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSynDemoHlSpaceAttri_W(Self: TSynDemoHl; const T: TSynHighlighterAttributes);
begin Self.SpaceAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDemoHlSpaceAttri_R(Self: TSynDemoHl; var T: TSynHighlighterAttributes);
begin T := Self.SpaceAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDemoHlIdentifierAttri_W(Self: TSynDemoHl; const T: TSynHighlighterAttributes);
begin Self.IdentifierAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDemoHlIdentifierAttri_R(Self: TSynDemoHl; var T: TSynHighlighterAttributes);
begin T := Self.IdentifierAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDemoHlNotAttri_W(Self: TSynDemoHl; const T: TSynHighlighterAttributes);
begin Self.NotAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDemoHlNotAttri_R(Self: TSynDemoHl; var T: TSynHighlighterAttributes);
begin T := Self.NotAttri; end;

(*----------------------------------------------------------------------------*)
procedure TSynDemoHlSpecialAttri_W(Self: TSynDemoHl; const T: TSynHighlighterAttributes);
begin Self.SpecialAttri := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynDemoHlSpecialAttri_R(Self: TSynDemoHl; var T: TSynHighlighterAttributes);
begin T := Self.SpecialAttri; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynDemoHl(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynDemoHl) do begin
    RegisterMethod(@TSynDemoHl.SetLine, 'SetLine');
    RegisterMethod(@TSynDemoHl.Next, 'Next');
    RegisterMethod(@TSynDemoHl.GetEol, 'GetEol');
    //RegisterMethod(@TSynDemoHl.GetTokenEx, 'GetTokenEx');
    RegisterMethod(@TSynDemoHl.GetTokenAttribute, 'GetTokenAttribute');
    RegisterMethod(@TSynDemoHl.GetToken, 'GetToken');
    RegisterMethod(@TSynDemoHl.GetTokenPos, 'GetTokenPos');
    RegisterMethod(@TSynDemoHl.GetTokenKind, 'GetTokenKind');
    RegisterMethod(@TSynDemoHl.GetDefaultAttribute, 'GetDefaultAttribute');
    RegisterConstructor(@TSynDemoHl.Create, 'Create');
    RegisterPropertyHelper(@TSynDemoHlSpecialAttri_R,@TSynDemoHlSpecialAttri_W,'SpecialAttri');
    RegisterPropertyHelper(@TSynDemoHlNotAttri_R,@TSynDemoHlNotAttri_W,'NotAttri');
    RegisterPropertyHelper(@TSynDemoHlIdentifierAttri_R,@TSynDemoHlIdentifierAttri_W,'IdentifierAttri');
    RegisterPropertyHelper(@TSynDemoHlSpaceAttri_R,@TSynDemoHlSpaceAttri_W,'SpaceAttri');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleHl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynDemoHl(CL);
end;

 
 
{ TPSImport_SimpleHl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleHl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleHl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleHl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleHl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
