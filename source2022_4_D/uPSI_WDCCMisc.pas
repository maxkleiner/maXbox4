unit uPSI_WDCCMisc;
{
asa the last one for check for updates

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
  TPSImport_WDCCMisc = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_WDCCMisc(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WDCCMisc_Routines(S: TPSExec);

procedure Register;

implementation


uses
   DBGrids
  ,ComObj
  ,Windows
  ,Forms
  ,Graphics
  ,WDCCMisc
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WDCCMisc]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_WDCCMisc(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TProcLog', 'Procedure ( const Log : string)');
 CL.AddDelphiFunction('Procedure wdc_CaptureConsoleOutput( const lpCommandLine : string; OutPutList : TStrings)');
 CL.AddDelphiFunction('Procedure wdc_MsgWarning( const Msg : string)');
 CL.AddDelphiFunction('Procedure wdc_MsgInformation( const Msg : string)');
 CL.AddDelphiFunction('Function wdc_MsgQuestion( const Msg : string) : Boolean');
 CL.AddDelphiFunction('Function wdc_GetFileVersion( const FileName : string) : string');
 CL.AddDelphiFunction('Function wdc_GetFileDescription( const FileName : string) : string');
 CL.AddDelphiFunction('Function wdc_GetTempDirectory : string');
 CL.AddDelphiFunction('Function wdc_GetWindowsDirectory : string');
 CL.AddDelphiFunction('Function wdc_GetSpecialFolder( const CSIDL : integer) : string');
 CL.AddDelphiFunction('Function wdc_IsWow64 : Boolean');
 CL.AddDelphiFunction('Function wdc_CopyDir( const fromDir, toDir : string) : Boolean');
 CL.AddDelphiFunction('Procedure wdc_SetGridColumnWidths( DbGrid : TDBGrid)');
 CL.AddDelphiFunction('Function wdc_Ping( const Address : string; Retries, BufferSize : Word; Log : TStrings) : Boolean');
 CL.AddDelphiFunction('Procedure wdc_ScaleImage32( const SourceBitmap, ResizedBitmap : TBitmap; const ScaleAmount : Double)');
 CL.AddDelphiFunction('Procedure wdc_ExtractIconFile( Icon : TIcon; const FileName : string; IconType : Cardinal)');
 CL.AddDelphiFunction('Procedure wdc_ExtractBitmapFile( Bmp : TBitmap; const FileName : string; IconType : Cardinal)');
 CL.AddDelphiFunction('Procedure wdc_ExtractBitmapFile32( Bmp : TBitmap; const FileName : string; IconType : Cardinal)');
 CL.AddDelphiFunction('Procedure wdc_CheckForUpdates( Silent : Boolean)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_WDCCMisc_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CaptureConsoleOutput, 'wdc_CaptureConsoleOutput', cdRegister);
 S.RegisterDelphiFunction(@MsgWarning, 'wdc_MsgWarning', cdRegister);
 S.RegisterDelphiFunction(@MsgInformation, 'wdc_MsgInformation', cdRegister);
 S.RegisterDelphiFunction(@MsgQuestion, 'wdc_MsgQuestion', cdRegister);
 S.RegisterDelphiFunction(@GetFileVersion, 'wdc_GetFileVersion', cdRegister);
 S.RegisterDelphiFunction(@GetFileDescription, 'wdc_GetFileDescription', cdRegister);
 S.RegisterDelphiFunction(@GetTempDirectory, 'wdc_GetTempDirectory', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsDirectory, 'wdc_GetWindowsDirectory', cdRegister);
 S.RegisterDelphiFunction(@GetSpecialFolder, 'wdc_GetSpecialFolder', cdRegister);
 S.RegisterDelphiFunction(@IsWow64, 'wdc_IsWow64', cdRegister);
 S.RegisterDelphiFunction(@CopyDir, 'wdc_CopyDir', cdRegister);
 S.RegisterDelphiFunction(@SetGridColumnWidths, 'wdc_SetGridColumnWidths', cdRegister);
 S.RegisterDelphiFunction(@Ping, 'wdc_Ping', cdRegister);
 S.RegisterDelphiFunction(@ScaleImage32, 'wdc_ScaleImage32', cdRegister);
 S.RegisterDelphiFunction(@ExtractIconFile, 'wdc_ExtractIconFile', cdRegister);
 S.RegisterDelphiFunction(@ExtractBitmapFile, 'wdc_ExtractBitmapFile', cdRegister);
 S.RegisterDelphiFunction(@ExtractBitmapFile32, 'wdc_ExtractBitmapFile32', cdRegister);
 S.RegisterDelphiFunction(@CheckForUpdates, 'wdc_CheckForUpdates', cdRegister);
end;

 
 
{ TPSImport_WDCCMisc }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDCCMisc.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WDCCMisc(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDCCMisc.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WDCCMisc_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
