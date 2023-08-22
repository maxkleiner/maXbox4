unit uPSI_uWebcam;
{
Tn no umain     get a list

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
  TPSImport_uWebcam = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_uWebcam(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uWebcam_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,jpeg
  ,graphics
  //,uMain
  ,uWebcam
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uWebcam]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_uWebcam(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WM_CAP_START','LongWord').SetUInt( $0400);
 CL.AddConstantN('WM_CAP_DRIVER_CONNECT','LongInt').SetInt( $0400 + 10);
 CL.AddConstantN('WM_CAP_DRIVER_DISCONNECT','LongInt').SetInt( $0400 + 11);
 CL.AddConstantN('WM_CAP_SAVEDIB','LongInt').SetInt( $0400 + 25);
 CL.AddConstantN('WM_CAP_GRAB_FRAME','LongInt').SetInt( $0400 + 60);
 CL.AddConstantN('WM_CAP_STOP','LongInt').SetInt( $0400 + 68);
 CL.AddDelphiFunction('Function Connectwebcam( WebcamID : integer) : boolean');
 CL.AddDelphiFunction('Procedure CaptureWebCam( FilePath : String)');
 CL.AddDelphiFunction('Procedure CloseWebcam( )');
 CL.AddDelphiFunction('Procedure WebcamInit');
 CL.AddDelphiFunction('Function WebcamList: TStringlist');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_uWebcam_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Connectwebcam, 'Connectwebcam', cdRegister);
 S.RegisterDelphiFunction(@CaptureWebCam, 'CaptureWebCam', cdRegister);
 S.RegisterDelphiFunction(@CloseWebcam, 'CloseWebcam', cdRegister);
 S.RegisterDelphiFunction(@WebcamInit, 'WebcamInit', cdRegister);
 S.RegisterDelphiFunction(@WebcamList, 'WebcamList', cdRegister);
end;

 
 
{ TPSImport_uWebcam }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uWebcam.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uWebcam(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uWebcam.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uWebcam_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
