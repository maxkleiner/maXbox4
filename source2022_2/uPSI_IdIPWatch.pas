unit uPSI_IdIPWatch;
{
  3.9.6.3
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
  TPSImport_IdIPWatch = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdIPWatch(CL: TPSPascalCompiler);
procedure SIRegister_TIdIPWatchThread(CL: TPSPascalCompiler);
procedure SIRegister_IdIPWatch(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdIPWatch(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdIPWatchThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdIPWatch(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdComponent
  ,IdThread
  ,IdIPWatch
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdIPWatch]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIPWatch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdIPWatch') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdIPWatch') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function ForceCheck : Boolean');
    RegisterMethod('Procedure LoadHistory');
    RegisterMethod('Function LocalIP : string');
    RegisterMethod('Procedure SaveHistory');
    RegisterProperty('CurrentIP', 'string', iptr);
    RegisterProperty('IPHistoryList', 'TStringList', iptr);
    RegisterProperty('IsOnline', 'Boolean', iptr);
    RegisterProperty('PreviousIP', 'string', iptr);
    RegisterProperty('Active', 'Boolean', iptrw);
    RegisterProperty('HistoryEnabled', 'Boolean', iptrw);
    RegisterProperty('HistoryFilename', 'string', iptrw);
    RegisterProperty('MaxHistoryEntries', 'Integer', iptrw);
    RegisterProperty('OnStatusChanged', 'TNotifyEvent', iptrw);
    RegisterProperty('WatchInterval', 'Cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdIPWatchThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdThread', 'TIdIPWatchThread') do
  with CL.AddClassN(CL.FindClass('TIdThread'),'TIdIPWatchThread') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdIPWatch(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('IP_WATCH_HIST_MAX','LongInt').SetInt( 25);
 CL.AddConstantN('IP_WATCH_HIST_FILENAME','String').SetString( 'iphist.dat');
 CL.AddConstantN('IP_WATCH_INTERVAL','LongInt').SetInt( 1000);
  SIRegister_TIdIPWatchThread(CL);
  SIRegister_TIdIPWatch(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdIPWatchWatchInterval_W(Self: TIdIPWatch; const T: Cardinal);
begin Self.WatchInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchWatchInterval_R(Self: TIdIPWatch; var T: Cardinal);
begin T := Self.WatchInterval; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchOnStatusChanged_W(Self: TIdIPWatch; const T: TNotifyEvent);
begin Self.OnStatusChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchOnStatusChanged_R(Self: TIdIPWatch; var T: TNotifyEvent);
begin T := Self.OnStatusChanged; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchMaxHistoryEntries_W(Self: TIdIPWatch; const T: Integer);
begin Self.MaxHistoryEntries := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchMaxHistoryEntries_R(Self: TIdIPWatch; var T: Integer);
begin T := Self.MaxHistoryEntries; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchHistoryFilename_W(Self: TIdIPWatch; const T: string);
begin Self.HistoryFilename := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchHistoryFilename_R(Self: TIdIPWatch; var T: string);
begin T := Self.HistoryFilename; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchHistoryEnabled_W(Self: TIdIPWatch; const T: Boolean);
begin Self.HistoryEnabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchHistoryEnabled_R(Self: TIdIPWatch; var T: Boolean);
begin T := Self.HistoryEnabled; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchActive_W(Self: TIdIPWatch; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchActive_R(Self: TIdIPWatch; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchPreviousIP_R(Self: TIdIPWatch; var T: string);
begin T := Self.PreviousIP; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchIsOnline_R(Self: TIdIPWatch; var T: Boolean);
begin T := Self.IsOnline; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchIPHistoryList_R(Self: TIdIPWatch; var T: TStringList);
begin T := Self.IPHistoryList; end;

(*----------------------------------------------------------------------------*)
procedure TIdIPWatchCurrentIP_R(Self: TIdIPWatch; var T: string);
begin T := Self.CurrentIP; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIPWatch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIPWatch) do begin
    RegisterConstructor(@TIdIPWatch.Create, 'Create');
    RegisterMethod(@TIdIPWatch.ForceCheck, 'ForceCheck');
    RegisterMethod(@TIdIPWatch.LoadHistory, 'LoadHistory');
    RegisterMethod(@TIdIPWatch.LocalIP, 'LocalIP');
    RegisterMethod(@TIdIPWatch.SaveHistory, 'SaveHistory');
    RegisterPropertyHelper(@TIdIPWatchCurrentIP_R,nil,'CurrentIP');
    RegisterPropertyHelper(@TIdIPWatchIPHistoryList_R,nil,'IPHistoryList');
    RegisterPropertyHelper(@TIdIPWatchIsOnline_R,nil,'IsOnline');
    RegisterPropertyHelper(@TIdIPWatchPreviousIP_R,nil,'PreviousIP');
    RegisterPropertyHelper(@TIdIPWatchActive_R,@TIdIPWatchActive_W,'Active');
    RegisterPropertyHelper(@TIdIPWatchHistoryEnabled_R,@TIdIPWatchHistoryEnabled_W,'HistoryEnabled');
    RegisterPropertyHelper(@TIdIPWatchHistoryFilename_R,@TIdIPWatchHistoryFilename_W,'HistoryFilename');
    RegisterPropertyHelper(@TIdIPWatchMaxHistoryEntries_R,@TIdIPWatchMaxHistoryEntries_W,'MaxHistoryEntries');
    RegisterPropertyHelper(@TIdIPWatchOnStatusChanged_R,@TIdIPWatchOnStatusChanged_W,'OnStatusChanged');
    RegisterPropertyHelper(@TIdIPWatchWatchInterval_R,@TIdIPWatchWatchInterval_W,'WatchInterval');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdIPWatchThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdIPWatchThread) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdIPWatch(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdIPWatchThread(CL);
  RIRegister_TIdIPWatch(CL);
end;

 
 
{ TPSImport_IdIPWatch }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIPWatch.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdIPWatch(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdIPWatch.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdIPWatch(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
