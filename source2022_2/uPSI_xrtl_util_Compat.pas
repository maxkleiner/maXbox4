unit uPSI_xrtl_util_Compat;
{
  COM extensions as fallback to COMobj and OLE
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
  TPSImport_xrtl_util_Compat = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_util_Compat(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_Compat_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,xrtl_util_Compat
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_Compat]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_Compat(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function xWideCompareStr( const S1, S2 : WideString) : Integer');
 CL.AddDelphiFunction('Function xWideSameStr( const S1, S2 : WideString) : Boolean');
 CL.AddDelphiFunction('Function xGUIDToString( const ClassID : TGUID) : string');
 CL.AddDelphiFunction('Function xStringToGUID( const S : string) : TGUID');
 CL.AddDelphiFunction('Function xGetModuleName( Module : HMODULE) : string');
 CL.AddDelphiFunction('Function xAcquireExceptionObject : TObject');
 CL.AddDelphiFunction('Function xIfThen( AValue : Boolean; const ATrue : Integer; const AFalse : Integer) : Integer');
 CL.AddDelphiFunction('Function xUtf8Encode( const WS : WideString) : UTF8String');
 CL.AddDelphiFunction('Function xUtf8Decode( const S : UTF8String) : WideString');
 CL.AddDelphiFunction('Function xExcludeTrailingPathDelimiter( const S : string) : string');
 CL.AddDelphiFunction('Function xIncludeTrailingPathDelimiter( const S : string) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_Compat_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@WideCompareStr, 'xWideCompareStr', cdRegister);
 S.RegisterDelphiFunction(@WideSameStr, 'xWideSameStr', cdRegister);
 S.RegisterDelphiFunction(@GUIDToString, 'xGUIDToString', cdRegister);
 S.RegisterDelphiFunction(@StringToGUID, 'xStringToGUID', cdRegister);
 S.RegisterDelphiFunction(@GetModuleName, 'xGetModuleName', cdRegister);
 S.RegisterDelphiFunction(@AcquireExceptionObject, 'xAcquireExceptionObject', cdRegister);
 S.RegisterDelphiFunction(@IfThen, 'xIfThen', cdRegister);
 S.RegisterDelphiFunction(@Utf8Encode, 'xUtf8Encode', cdRegister);
 S.RegisterDelphiFunction(@Utf8Decode, 'xUtf8Decode', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter, 'xExcludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiter, 'xIncludeTrailingPathDelimiter', cdRegister);
end;

 
 
{ TPSImport_xrtl_util_Compat }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Compat.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_Compat(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_Compat.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xrtl_util_Compat(ri);
  RIRegister_xrtl_util_Compat_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
