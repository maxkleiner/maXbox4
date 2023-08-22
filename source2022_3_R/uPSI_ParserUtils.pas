unit uPSI_ParserUtils;
{
   from box to box
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
  TPSImport_ParserUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ParserUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ParserUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   uPSUtils
  ,ParserUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ParserUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ParserUtils(CL: TPSPascalCompiler);
begin

 CL.AddTypeS('TPSPasToken', '( CSTI_EOF, CSTIINT_Comment, CSTIINT_WhiteSpace, '
   +'CSTI_Identifier, CSTI_SemiColon, CSTI_Comma, CSTI_Period, CSTI_Colon, CSTI'
   +'_OpenRound, CSTI_CloseRound, CSTI_OpenBlock, CSTI_CloseBlock, CSTI_Assignm'
   +'ent, CSTI_Equal, CSTI_NotEqual, CSTI_Greater, CSTI_GreaterEqual, CSTI_Less'
   +', CSTI_LessEqual, CSTI_Plus, CSTI_Minus, CSTI_Divide, CSTI_Multiply, CSTI_'
   +'Integer, CSTI_Real, CSTI_String, CSTI_Char, CSTI_HexInt, CSTI_AddressOf, C'
   +'STI_Dereference, CSTI_TwoDots, CSTII_and, CSTII_array, CSTII_begin, CSTII_'
   +'case, CSTII_const, CSTII_div, CSTII_do, CSTII_downto, CSTII_else, CSTII_en'
   +'d, CSTII_for, CSTII_function, CSTII_if, CSTII_in, CSTII_mod, CSTII_not, CS'
   +'TII_of, CSTII_or, CSTII_procedure, CSTII_program, CSTII_repeat, CSTII_reco'
   +'rd, CSTII_set, CSTII_shl, CSTII_shr, CSTII_then, CSTII_to, CSTII_type, CST'
   +'II_until, CSTII_uses, CSTII_var, CSTII_while, CSTII_with, CSTII_xor, CSTII'
   +'_exit, CSTII_class, CSTII_constructor, CSTII_destructor, CSTII_inherited, '
   +'CSTII_private, CSTII_public, CSTII_published, CSTII_protected, CSTII_prope'
   +'rty, CSTII_virtual, CSTII_override, CSTII_As, CSTII_Is, CSTII_Unit, CSTII_'
   +'Try, CSTII_Except, CSTII_Finally, CSTII_External, CSTII_Forward, CSTII_Exp'
   +'ort, CSTII_Label, CSTII_Goto, CSTII_Chr, CSTII_Ord, CSTII_Interface, CSTII'
   +'_Implementation, CSTII_initialization, CSTII_finalization, CSTII_out, CSTI'
   +'I_nil )');

 //CL.AddConstantN('version','String').SetString( 'v0.7');
 CL.AddDelphiFunction('Procedure RaiseError( const errormsg : string; row, col : integer)');
 CL.AddDelphiFunction('Function GetLicence : string');
 CL.AddDelphiFunction('Function GetUsedUnitList( list : Tstringlist) : string');
 CL.AddDelphiFunction('Function GetTokenName( TokenID : TPSPasToken) : string');
 CL.AddConstantN('NewLine2','String').SetString( #13#10);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_ParserUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RaiseError, 'RaiseError', cdRegister);
 S.RegisterDelphiFunction(@GetLicence, 'GetLicence', cdRegister);
 S.RegisterDelphiFunction(@GetUsedUnitList, 'GetUsedUnitList', cdRegister);
 S.RegisterDelphiFunction(@GetTokenName, 'GetTokenName', cdRegister);
end;

 
 
{ TPSImport_ParserUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ParserUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ParserUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ParserUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ParserUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
