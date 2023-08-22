unit uPSI_JvProfiler32;
{
  profile to proof    add free
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
  TPSImport_JvProfiler32 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvProfiler(CL: TPSPascalCompiler);
procedure SIRegister_TProfReport(CL: TPSPascalCompiler);
procedure SIRegister_JvProfiler32(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvProfiler(CL: TPSRuntimeClassImporter);
procedure RIRegister_TProfReport(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvProfiler32(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Dialogs
  ,ComCtrls
  ,StdCtrls
  ,Controls
  ,ExtCtrls
  ,Forms
  ,JvComponent
  ,JvProfiler32
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvProfiler32]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvProfiler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvProfiler') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvProfiler') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Start');
    RegisterMethod('Procedure EnterID( ID : Integer)');
    RegisterMethod('Procedure EnterName( const Name : string)');
    RegisterMethod('Procedure ExitName( const Name : string)');
    RegisterMethod('Procedure ExitID( ID : Integer)');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure ShowReport');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('Names', 'TStrings', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('OnStart', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStop', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TProfReport(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TProfReport') do
  with CL.AddClassN(CL.FindClass('TForm'),'TProfReport') do
  begin
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('SaveBtn', 'TButton', iptrw);
    RegisterProperty('lvReport', 'TListView', iptrw);
    RegisterProperty('Panel2', 'TPanel', iptrw);
    RegisterProperty('OKBtn', 'TButton', iptrw);
    RegisterProperty('TrimBtn', 'TButton', iptrw);
    RegisterMethod('Procedure FormShow( Sender : TObject)');
    RegisterMethod('Procedure lvReportColumnClick( Sender : TObject; Column : TListColumn)');
    RegisterMethod('Procedure SaveBtnClick( Sender : TObject)');
    RegisterMethod('Procedure OKBtnClick( Sender : TObject)');
    RegisterMethod('Procedure TrimBtnClick( Sender : TObject)');
    RegisterProperty('StartTime', 'Integer', iptrw);
    RegisterProperty('EndTime', 'Integer', iptrw);
    RegisterProperty('LastProc', 'Integer', iptrw);
    RegisterProperty('ProfileInfo', 'TJvProfileInfo', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvProfiler32(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxProfEntries','LongInt').SetInt( 1024);
 CL.AddConstantN('MaxStackSize','LongInt').SetInt( 1024);
  SIRegister_TProfReport(CL);
  SIRegister_TJvProfiler(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvProfilerOnStop_W(Self: TJvProfiler; const T: TNotifyEvent);
begin Self.OnStop := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerOnStop_R(Self: TJvProfiler; var T: TNotifyEvent);
begin T := Self.OnStop; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerOnStart_W(Self: TJvProfiler; const T: TNotifyEvent);
begin Self.OnStart := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerOnStart_R(Self: TJvProfiler; var T: TNotifyEvent);
begin T := Self.OnStart; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerSorted_W(Self: TJvProfiler; const T: Boolean);
begin Self.Sorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerSorted_R(Self: TJvProfiler; var T: Boolean);
begin T := Self.Sorted; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerNames_W(Self: TJvProfiler; const T: TStrings);
begin Self.Names := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerNames_R(Self: TJvProfiler; var T: TStrings);
begin T := Self.Names; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerEnabled_W(Self: TJvProfiler; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvProfilerEnabled_R(Self: TJvProfiler; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportProfileInfo_W(Self: TProfReport; const T: TJvProfileInfo);
Begin Self.ProfileInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportProfileInfo_R(Self: TProfReport; var T: TJvProfileInfo);
Begin T := Self.ProfileInfo; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportLastProc_W(Self: TProfReport; const T: Integer);
Begin Self.LastProc := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportLastProc_R(Self: TProfReport; var T: Integer);
Begin T := Self.LastProc; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportEndTime_W(Self: TProfReport; const T: Integer);
Begin Self.EndTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportEndTime_R(Self: TProfReport; var T: Integer);
Begin T := Self.EndTime; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportStartTime_W(Self: TProfReport; const T: Integer);
Begin Self.StartTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportStartTime_R(Self: TProfReport; var T: Integer);
Begin T := Self.StartTime; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportTrimBtn_W(Self: TProfReport; const T: TButton);
Begin Self.TrimBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportTrimBtn_R(Self: TProfReport; var T: TButton);
Begin T := Self.TrimBtn; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportOKBtn_W(Self: TProfReport; const T: TButton);
Begin Self.OKBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportOKBtn_R(Self: TProfReport; var T: TButton);
Begin T := Self.OKBtn; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportPanel2_W(Self: TProfReport; const T: TPanel);
Begin Self.Panel2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportPanel2_R(Self: TProfReport; var T: TPanel);
Begin T := Self.Panel2; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportlvReport_W(Self: TProfReport; const T: TListView);
Begin Self.lvReport := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportlvReport_R(Self: TProfReport; var T: TListView);
Begin T := Self.lvReport; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportSaveBtn_W(Self: TProfReport; const T: TButton);
Begin Self.SaveBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportSaveBtn_R(Self: TProfReport; var T: TButton);
Begin T := Self.SaveBtn; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportPanel1_W(Self: TProfReport; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TProfReportPanel1_R(Self: TProfReport; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvProfiler(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvProfiler) do begin
    RegisterConstructor(@TJvProfiler.Create, 'Create');
    RegisterMethod(@TJvProfiler.Destroy, 'Free');
    RegisterMethod(@TJvProfiler.Start, 'Start');
    RegisterMethod(@TJvProfiler.EnterID, 'EnterID');
    RegisterMethod(@TJvProfiler.EnterName, 'EnterName');
    RegisterMethod(@TJvProfiler.ExitName, 'ExitName');
    RegisterMethod(@TJvProfiler.ExitID, 'ExitID');
    RegisterMethod(@TJvProfiler.Stop, 'Stop');
    RegisterMethod(@TJvProfiler.ShowReport, 'ShowReport');
    RegisterPropertyHelper(@TJvProfilerEnabled_R,@TJvProfilerEnabled_W,'Enabled');
    RegisterPropertyHelper(@TJvProfilerNames_R,@TJvProfilerNames_W,'Names');
    RegisterPropertyHelper(@TJvProfilerSorted_R,@TJvProfilerSorted_W,'Sorted');
    RegisterPropertyHelper(@TJvProfilerOnStart_R,@TJvProfilerOnStart_W,'OnStart');
    RegisterPropertyHelper(@TJvProfilerOnStop_R,@TJvProfilerOnStop_W,'OnStop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProfReport(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProfReport) do
  begin
    RegisterPropertyHelper(@TProfReportPanel1_R,@TProfReportPanel1_W,'Panel1');
    RegisterPropertyHelper(@TProfReportSaveBtn_R,@TProfReportSaveBtn_W,'SaveBtn');
    RegisterPropertyHelper(@TProfReportlvReport_R,@TProfReportlvReport_W,'lvReport');
    RegisterPropertyHelper(@TProfReportPanel2_R,@TProfReportPanel2_W,'Panel2');
    RegisterPropertyHelper(@TProfReportOKBtn_R,@TProfReportOKBtn_W,'OKBtn');
    RegisterPropertyHelper(@TProfReportTrimBtn_R,@TProfReportTrimBtn_W,'TrimBtn');
    RegisterMethod(@TProfReport.FormShow, 'FormShow');
    RegisterMethod(@TProfReport.lvReportColumnClick, 'lvReportColumnClick');
    RegisterMethod(@TProfReport.SaveBtnClick, 'SaveBtnClick');
    RegisterMethod(@TProfReport.OKBtnClick, 'OKBtnClick');
    RegisterMethod(@TProfReport.TrimBtnClick, 'TrimBtnClick');
    RegisterPropertyHelper(@TProfReportStartTime_R,@TProfReportStartTime_W,'StartTime');
    RegisterPropertyHelper(@TProfReportEndTime_R,@TProfReportEndTime_W,'EndTime');
    RegisterPropertyHelper(@TProfReportLastProc_R,@TProfReportLastProc_W,'LastProc');
    RegisterPropertyHelper(@TProfReportProfileInfo_R,@TProfReportProfileInfo_W,'ProfileInfo');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvProfiler32(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TProfReport(CL);
  RIRegister_TJvProfiler(CL);
end;

 
 
{ TPSImport_JvProfiler32 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvProfiler32.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvProfiler32(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvProfiler32.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvProfiler32(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
