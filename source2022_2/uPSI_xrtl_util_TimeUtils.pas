unit uPSI_xrtl_util_TimeUtils;
{
 time on time
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
  TPSImport_xrtl_util_TimeUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_xrtl_util_TimeUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_xrtl_util_TimeUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,xrtl_util_TimeUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_TimeUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_TimeUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function XFileTimeToDateTime( FileTime : TFileTime) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToFileTime( DateTime : TDateTime) : TFileTime');
 CL.AddDelphiFunction('Function GMTNow : TDateTime');
 CL.AddDelphiFunction('Function GMTToLocalTime( GMT : TDateTime) : TDateTime');
 CL.AddDelphiFunction('Function LocalTimeToGMT( LocalTime : TDateTime) : TDateTime');
 CL.AddConstantN('HoursPerDay','LongInt').SetInt( 24);
 CL.AddConstantN('MinsPerDay','LongInt').SetInt( HoursPerDay * 60);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_TimeUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FileTimeToDateTime, 'XFileTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToFileTime, 'DateTimeToFileTime', cdRegister);
 S.RegisterDelphiFunction(@GMTNow, 'GMTNow', cdRegister);
 S.RegisterDelphiFunction(@GMTToLocalTime, 'GMTToLocalTime', cdRegister);
 S.RegisterDelphiFunction(@LocalTimeToGMT, 'LocalTimeToGMT', cdRegister);
end;

 
 
{ TPSImport_xrtl_util_TimeUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_TimeUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_TimeUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_TimeUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_xrtl_util_TimeUtils(ri);
  RIRegister_xrtl_util_TimeUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
