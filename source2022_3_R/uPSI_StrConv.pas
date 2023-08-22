unit uPSI_StrConv;
{
Ttcodepage conv utility

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
  TPSImport_StrConv = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StrConv(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StrConv_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,StrConv
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StrConv]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StrConv(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCodepage', 'DWord');
 CL.AddConstantN('CP_INVALID','LongInt').SetInt( TCodepage ( - 1 ));
 CL.AddConstantN('CP_ASIS','LongInt').SetInt( TCodepage ( - 2 ));
 CL.AddConstantN('CP_ANSI','longint').SetInt(0);
 CL.AddConstantN('CP_OEM','longint').SetInt(1);
 CL.AddConstantN('CP_SHIFTJIS','LongInt').SetInt( 932);
 CL.AddConstantN('CP_LATIN1','LongInt').SetInt( 1250);
 CL.AddConstantN('CP_UNICODE','LongInt').SetInt( 1200);
 CL.AddConstantN('CP_UTF8','LongInt').SetInt( 65001);
 CL.AddDelphiFunction('Function MinStrConvBufSize( SrcCodepage : TCodepage; Str : String) : Integer;');
 CL.AddDelphiFunction('Function MinStrConvBufSize1( DestCodepage : TCodepage; Wide : WideString) : Integer;');
 CL.AddDelphiFunction('Function ToWideString( SrcCodepage : TCodepage; Str : String; BufSize : Integer) : WideString');
 CL.AddDelphiFunction('Function FromWideString( DestCodepage : TCodepage; Str : WideString; BufSize : Integer; Fail : Boolean) : String');
 CL.AddDelphiFunction('Function CharsetToID( Str : String) : TCodepage');
 CL.AddDelphiFunction('Function IdToCharset( ID : TCodepage; GetDescription : Boolean) : String');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function MinStrConvBufSize1_P( DestCodepage : TCodepage; Wide : WideString) : Integer;
Begin Result := StrConv.MinStrConvBufSize(DestCodepage, Wide); END;

(*----------------------------------------------------------------------------*)
Function MinStrConvBufSize_P( SrcCodepage : TCodepage; Str : String) : Integer;
Begin Result := StrConv.MinStrConvBufSize(SrcCodepage, Str); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StrConv_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MinStrConvBufSize, 'MinStrConvBufSize', cdRegister);
 S.RegisterDelphiFunction(@MinStrConvBufSize1_P, 'MinStrConvBufSize1', cdRegister);
 S.RegisterDelphiFunction(@ToWideString, 'ToWideString', cdRegister);
 S.RegisterDelphiFunction(@FromWideString, 'FromWideString', cdRegister);
 S.RegisterDelphiFunction(@CharsetToID, 'CharsetToID', cdRegister);
 S.RegisterDelphiFunction(@IdToCharset, 'IdToCharset', cdRegister);
end;

 
 
{ TPSImport_StrConv }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StrConv.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StrConv(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StrConv.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StrConv_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
