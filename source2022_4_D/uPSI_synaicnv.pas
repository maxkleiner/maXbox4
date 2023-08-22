unit uPSI_synaicnv;
{
   synapse to
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
  TPSImport_synaicnv = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_synaicnv(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synaicnv_Routines(S: TPSExec);

procedure Register;

implementation


uses
   synafpc
  ,Windows
  ,synaicnv
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synaicnv]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_synaicnv(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('DLLIconvName','String').SetString( 'libiconv.so');
 CL.AddConstantN('DLLIconvName','String').SetString( 'iconv.dll');
  CL.AddTypeS('size_t', 'Cardinal');
  CL.AddTypeS('iconv_t', 'Integer');
  //CL.AddTypeS('iconv_t', 'Pointer');
  CL.AddTypeS('argptr', 'iconv_t');
 CL.AddDelphiFunction('Function SynaIconvOpen( const tocode, fromcode : Ansistring) : iconv_t');
 CL.AddDelphiFunction('Function SynaIconvOpenTranslit( const tocode, fromcode : Ansistring) : iconv_t');
 CL.AddDelphiFunction('Function SynaIconvOpenIgnore( const tocode, fromcode : Ansistring) : iconv_t');
 CL.AddDelphiFunction('Function SynaIconv( cd : iconv_t; inbuf : AnsiString; var outbuf : AnsiString) : integer');
 CL.AddDelphiFunction('Function SynaIconvClose( var cd : iconv_t) : integer');
 CL.AddDelphiFunction('Function SynaIconvCtl( cd : iconv_t; request : integer; argument : argptr) : integer');
 CL.AddDelphiFunction('Function IsIconvloaded : Boolean');
 CL.AddDelphiFunction('Function InitIconvInterface : Boolean');
 CL.AddDelphiFunction('Function DestroyIconvInterface : Boolean');
 CL.AddConstantN('ICONV_TRIVIALP','LongInt').SetInt( 0);
 CL.AddConstantN('ICONV_GET_TRANSLITERATE','LongInt').SetInt( 1);
 CL.AddConstantN('ICONV_SET_TRANSLITERATE','LongInt').SetInt( 2);
 CL.AddConstantN('ICONV_GET_DISCARD_ILSEQ','LongInt').SetInt( 3);
 CL.AddConstantN('ICONV_SET_DISCARD_ILSEQ','LongInt').SetInt( 4);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_synaicnv_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SynaIconvOpen, 'SynaIconvOpen', cdRegister);
 S.RegisterDelphiFunction(@SynaIconvOpenTranslit, 'SynaIconvOpenTranslit', cdRegister);
 S.RegisterDelphiFunction(@SynaIconvOpenIgnore, 'SynaIconvOpenIgnore', cdRegister);
 S.RegisterDelphiFunction(@SynaIconv, 'SynaIconv', cdRegister);
 S.RegisterDelphiFunction(@SynaIconvClose, 'SynaIconvClose', cdRegister);
 S.RegisterDelphiFunction(@SynaIconvCtl, 'SynaIconvCtl', cdRegister);
 S.RegisterDelphiFunction(@IsIconvloaded, 'IsIconvloaded', cdRegister);
 S.RegisterDelphiFunction(@InitIconvInterface, 'InitIconvInterface', cdRegister);
 S.RegisterDelphiFunction(@DestroyIconvInterface, 'DestroyIconvInterface', cdRegister);
end;

 
 
{ TPSImport_synaicnv }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synaicnv.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synaicnv(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synaicnv.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_synaicnv(ri);
  RIRegister_synaicnv_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
