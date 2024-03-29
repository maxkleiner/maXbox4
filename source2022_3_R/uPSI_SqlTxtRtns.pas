unit uPSI_SqlTxtRtns;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_SqlTxtRtns = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_SqlTxtRtns(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SqlTxtRtns_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StrUtil
  ,SqlTxtRtns
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SqlTxtRtns]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_SqlTxtRtns(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('space2','String').SetString( '    ');
 CL.AddConstantN('QuotMarks','Char').SetString( #39);
 CL.AddDelphiFunction('Function DispositionFrom( const SQLText : string) : TPoint');
 CL.AddDelphiFunction('Procedure AllTables( const SQLText : string; FTables : Tstrings)');
 CL.AddDelphiFunction('Function TableByAlias( const SQLText, Alias : string) : string');
 CL.AddDelphiFunction('Function FullFieldName( const SQLText, FieldName : string) : string');
 CL.AddDelphiFunction('Function AddToWhereClause( const SQLText, NewClause : string) : string');
 CL.AddDelphiFunction('Function GetWhereClause( SQLText : string; N : integer; var StartPos, EndPos : integer) : string');
 CL.AddDelphiFunction('Function WhereCount( SQLText : string) : integer');
 CL.AddDelphiFunction('Function GetOrderInfo( SQLText : string) : variant');
 CL.AddDelphiFunction('Function OrderStringTxt( SQLText : string; var StartPos, EndPos : integer) : String');
 CL.AddDelphiFunction('Function PrepareConstraint( Src : Tstrings) : string');
 CL.AddDelphiFunction('Procedure DeleteEmptyStr( Src : Tstrings)');
 CL.AddDelphiFunction('Function NormalizeSQLText( const SQL : string; MacroChar : Char) : string');
 CL.AddDelphiFunction('Function CountSelect( const SrcSQL : string) : string');
 CL.AddDelphiFunction('Function GetModifyTable( const SQLText : string; AlreadyNormal : boolean) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_SqlTxtRtns_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DispositionFrom, 'DispositionFrom', cdRegister);
 S.RegisterDelphiFunction(@AllTables, 'AllTables', cdRegister);
 S.RegisterDelphiFunction(@TableByAlias, 'TableByAlias', cdRegister);
 S.RegisterDelphiFunction(@FullFieldName, 'FullFieldName', cdRegister);
 S.RegisterDelphiFunction(@AddToWhereClause, 'AddToWhereClause', cdRegister);
 S.RegisterDelphiFunction(@GetWhereClause, 'GetWhereClause', cdRegister);
 S.RegisterDelphiFunction(@WhereCount, 'WhereCount', cdRegister);
 S.RegisterDelphiFunction(@GetOrderInfo, 'GetOrderInfo', cdRegister);
 S.RegisterDelphiFunction(@OrderStringTxt, 'OrderStringTxt', cdRegister);
 S.RegisterDelphiFunction(@PrepareConstraint, 'PrepareConstraint', cdRegister);
 S.RegisterDelphiFunction(@DeleteEmptyStr, 'DeleteEmptyStr', cdRegister);
 S.RegisterDelphiFunction(@NormalizeSQLText, 'NormalizeSQLText', cdRegister);
 S.RegisterDelphiFunction(@CountSelect, 'CountSelect', cdRegister);
 S.RegisterDelphiFunction(@GetModifyTable, 'GetModifyTable', cdRegister);
end;

 
 
{ TPSImport_SqlTxtRtns }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SqlTxtRtns.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SqlTxtRtns(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SqlTxtRtns.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SqlTxtRtns_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
