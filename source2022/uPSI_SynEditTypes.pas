unit uPSI_SynEditTypes;
{
  for Tools API
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
  TPSImport_SynEditTypes = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_SynEditTypes(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SynEditTypes_Routines(S: TPSExec);

procedure Register;

implementation


uses
   SynEditTypes
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynEditTypes]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SynEditTypes(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('TSynWordBreakChars','String').SetString( '.' or  ',' or  ';' or  ':' or  '"' or  '''' or  '!' or  '?' or  '[' or  ']' or  '(' or  ')' or  '{' or  '}' or  '^' or  '-' or  '=' or  '+' or  '-' or  '*' or  '/' or  '\' or  '|');
 CL.AddConstantN('TSynTabChar','Char').SetString( #9);
 CL.AddConstantN('SynTabGlyph','Char').SetString('»');
 CL.AddConstantN('SynSoftBreakGlyph','Char').SetString('¬'); //chr( $AC));
 CL.AddConstantN('SynLineBreakGlyph','Char').SetString('¶'); //chr( $B6));
 CL.AddConstantN('SynSpaceGlyph','Char').SetString('·');  //chr( $B7));
 //CL.AddConstantN('SLineBreak','String').SetString( #13#10#10);
  CL.AddTypeS('TSynSearchOption', '( ssoMatchCase, ssoWholeWord, ssoBackwards, '
   +'ssoEntireScope, ssoSelectedOnly, ssoReplace, ssoReplaceAll, ssoPrompt )');
  CL.AddTypeS('TSynSearchOptions', 'set of TSynSearchOption');
  CL.AddTypeS('TSynIdentChars', 'set of char');
  //CL.AddTypeS('PSynSelectionMode', '^TSynSelectionMode // will not work');
  CL.AddTypeS('TSynSelectionMode', '( smNormal, smLine, smColumn )');
  CL.AddTypeS('TBufferCoord', 'record Char : integer; Line : integer; end');
  CL.AddTypeS('TDisplayCoord', 'record Column : integer; Row : integer; end');
 CL.AddDelphiFunction('Function DisplayCoord( AColumn, ARow : Integer) : TDisplayCoord');
 CL.AddDelphiFunction('Function BufferCoord( AChar, ALine : Integer) : TBufferCoord');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_SynEditTypes_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DisplayCoord, 'DisplayCoord', cdRegister);
 S.RegisterDelphiFunction(@BufferCoord, 'BufferCoord', cdRegister);
end;

 
 
{ TPSImport_SynEditTypes }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditTypes.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynEditTypes(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynEditTypes.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_SynEditTypes(ri);
  RIRegister_SynEditTypes_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
