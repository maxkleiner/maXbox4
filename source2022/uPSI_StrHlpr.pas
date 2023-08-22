unit uPSI_StrHlpr;
{
after wideStr and StrUtils

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
  TPSImport_StrHlpr = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_StrHlpr(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StrHlpr_Routines(S: TPSExec);

procedure Register;

implementation


uses
   StrHlpr
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StrHlpr]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StrHlpr(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function AnsiCat( const x, y : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function AnsiCopy( const src : AnsiString; index, count : Integer) : AnsiString');
 CL.AddDelphiFunction('Function AnsiPos( const src, sub : AnsiString) : Integer');
 CL.AddDelphiFunction('Procedure AnsiAppend( var dst : AnsiString; const src : AnsiString)');
 CL.AddDelphiFunction('Procedure AnsiDelete( var dst : AnsiString; index, count : Integer)');
 //CL.AddDelphiFunction('Procedure AnsiFromPWideChar( var dst : AnsiString; src : PWideChar)');
 CL.AddDelphiFunction('Procedure AnsiFromWide( var dst : AnsiString; const src : WideString)');
 CL.AddDelphiFunction('Procedure AnsiInsert( var dst : AnsiString; const src : AnsiString; index : Integer)');
 CL.AddDelphiFunction('Procedure AnsiSetLength( var dst : AnsiString; len : Integer)');
 CL.AddDelphiFunction('Procedure AnsiFree( var s : AnsiString)');
 CL.AddDelphiFunction('Procedure AnsiAssign( var dst : AnsiString; var src : AnsiString)');
 CL.AddDelphiFunction('Procedure WideAppend( var dst : WideString; const src : WideString)');
 CL.AddDelphiFunction('Function WideCat( const x, y : WideString) : WideString');
 CL.AddDelphiFunction('Function WideCopy( const src : WideString; index, count : Integer) : WideString');
 CL.AddDelphiFunction('Function WideEqual( const x, y : WideString) : Boolean');
 CL.AddDelphiFunction('Function WideGreater( const x, y : WideString) : Boolean');
 CL.AddDelphiFunction('Function WideLength( const src : WideString) : Integer');
 CL.AddDelphiFunction('Function WideLess( const x, y : WideString) : Boolean');
 CL.AddDelphiFunction('Function WidePos( const src, sub : WideString) : Integer');
 CL.AddDelphiFunction('Procedure WideDelete( var dst : WideString; index, count : Integer)');
 CL.AddDelphiFunction('Procedure WideFree( var s : WideString)');
 CL.AddDelphiFunction('Procedure WideFromAnsi( var dst : WideString; const src : AnsiString)');
 CL.AddDelphiFunction('Procedure WideFromPChar( var dst : WideString; src : PChar)');
 CL.AddDelphiFunction('Procedure WideInsert( var dst : WideString; const src : WideString; index : Integer)');
 CL.AddDelphiFunction('Procedure WideSetLength( var dst : WideString; len : Integer)');
 CL.AddDelphiFunction('Procedure WideAssign( var dst : WideString; var src : WideString)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StrHlpr_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AnsiCat, 'AnsiCat', cdRegister);
 S.RegisterDelphiFunction(@AnsiCopy, 'AnsiCopy', cdRegister);
 S.RegisterDelphiFunction(@AnsiPos, 'AnsiPos', cdRegister);
 S.RegisterDelphiFunction(@AnsiAppend, 'AnsiAppend', cdRegister);
 S.RegisterDelphiFunction(@AnsiDelete, 'AnsiDelete', cdRegister);
 S.RegisterDelphiFunction(@AnsiFromPWideChar, 'AnsiFromPWideChar', cdRegister);
 S.RegisterDelphiFunction(@AnsiFromWide, 'AnsiFromWide', cdRegister);
 S.RegisterDelphiFunction(@AnsiInsert, 'AnsiInsert', cdRegister);
 S.RegisterDelphiFunction(@AnsiSetLength, 'AnsiSetLength', cdRegister);
 S.RegisterDelphiFunction(@AnsiFree, 'AnsiFree', cdRegister);
 S.RegisterDelphiFunction(@AnsiAssign, 'AnsiAssign', cdRegister);
 S.RegisterDelphiFunction(@WideAppend, 'WideAppend', cdRegister);
 S.RegisterDelphiFunction(@WideCat, 'WideCat', cdRegister);
 S.RegisterDelphiFunction(@WideCopy, 'WideCopy', cdRegister);
 S.RegisterDelphiFunction(@WideEqual, 'WideEqual', cdRegister);
 S.RegisterDelphiFunction(@WideGreater, 'WideGreater', cdRegister);
 S.RegisterDelphiFunction(@WideLength, 'WideLength', cdRegister);
 S.RegisterDelphiFunction(@WideLess, 'WideLess', cdRegister);
 S.RegisterDelphiFunction(@WidePos, 'WidePos', cdRegister);
 S.RegisterDelphiFunction(@WideDelete, 'WideDelete', cdRegister);
 S.RegisterDelphiFunction(@WideFree, 'WideFree', cdRegister);
 S.RegisterDelphiFunction(@WideFromAnsi, 'WideFromAnsi', cdRegister);
 S.RegisterDelphiFunction(@WideFromPChar, 'WideFromPChar', cdRegister);
 S.RegisterDelphiFunction(@WideInsert, 'WideInsert', cdRegister);
 S.RegisterDelphiFunction(@WideSetLength, 'WideSetLength', cdRegister);
 S.RegisterDelphiFunction(@WideAssign, 'WideAssign', cdRegister);
end;



{ TPSImport_StrHlpr }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StrHlpr.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StrHlpr(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StrHlpr.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StrHlpr(ri);
  RIRegister_StrHlpr_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
