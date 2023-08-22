unit uPSI_IdLPR;
{
   print unit
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
  TPSImport_IdLPR = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdLPR(CL: TPSPascalCompiler);
procedure SIRegister_TIdLPRControlFile(CL: TPSPascalCompiler);
procedure SIRegister_IdLPR(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdLPR(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdLPRControlFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdLPR(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdException
  ,IdGlobal
  ,IdTCPClient
  ,IdComponent
  ,IdLPR
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdLPR]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdLPR(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdLPR') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdLPR') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Print( AText : String);');
    RegisterMethod('Procedure Print1( ABuffer : array of Byte);');
    RegisterMethod('Procedure PrintFile( AFileName : String)');
    RegisterMethod('Function GetQueueState( const AShortFormat : Boolean; const AList : String) : String');
    RegisterMethod('Procedure PrintWaitingJobs');
    RegisterMethod('Procedure RemoveJobList( AList : String; const AAsRoot : Boolean)');
    RegisterProperty('JobId', 'String', iptrw);
    RegisterProperty('Queue', 'String', iptrw);
    RegisterProperty('ControlFile', 'TIdLPRControlFile', iptrw);
    RegisterProperty('OnLPRStatus', 'TIdLPRStatusEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdLPRControlFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TIdLPRControlFile') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TIdLPRControlFile') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterProperty('HostName', 'String', iptrw);
    RegisterProperty('BannerClass', 'String', iptrw);
    RegisterProperty('IndentCount', 'Integer', iptrw);
    RegisterProperty('JobName', 'String', iptrw);
    RegisterProperty('BannerPage', 'Boolean', iptrw);
    RegisterProperty('UserName', 'String', iptrw);
    RegisterProperty('OutputWidth', 'Integer', iptrw);
    RegisterProperty('FileFormat', 'TIdLPRFileFormat', iptrw);
    RegisterProperty('TroffRomanFont', 'String', iptrw);
    RegisterProperty('TroffItalicFont', 'String', iptrw);
    RegisterProperty('TroffBoldFont', 'String', iptrw);
    RegisterProperty('TroffSpecialFont', 'String', iptrw);
    RegisterProperty('MailWhenPrinted', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdLPR(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdLPRFileFormat', '( ffCIF, ffDVI, ffFormattedText, ffPlot, ffC'
   +'ontrolCharText, ffDitroff, ffPostScript, ffPR, ffFORTRAM, ffTroff, ffSunRaster )');
 CL.AddConstantN('DEF_FILEFORMAT','String').SetString('ffControlCharText');
 CL.AddConstantN('DEF_INDENTCOUNT','LongInt').SetInt( 0);
 CL.AddConstantN('DEF_BANNERPAGE','Boolean').SetInt(0);
 CL.AddConstantN('DEF_OUTPUTWIDTH','LongInt').SetInt( 0);
 CL.AddConstantN('DEF_MAILWHENPRINTED','Boolean').SetInt( 0);
  SIRegister_TIdLPRControlFile(CL);
  CL.AddTypeS('TIdLPRStatus', '( psPrinting, psJobCompleted, psError, psGetting'
   +'QueueState, psGotQueueState, psDeletingJobs, psJobsDeleted, psPrintingWait'
   +'ingJobs, psPrintedWaitingJobs )');
  CL.AddTypeS('TIdLPRStatusEvent', 'Procedure ( ASender : TObject; const AStatu'
   +'s : TIdLPRStatus; const AStatusText : String)');
  SIRegister_TIdLPR(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIdLPRErrorException');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdLPROnLPRStatus_W(Self: TIdLPR; const T: TIdLPRStatusEvent);
begin Self.OnLPRStatus := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPROnLPRStatus_R(Self: TIdLPR; var T: TIdLPRStatusEvent);
begin T := Self.OnLPRStatus; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFile_W(Self: TIdLPR; const T: TIdLPRControlFile);
begin Self.ControlFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFile_R(Self: TIdLPR; var T: TIdLPRControlFile);
begin T := Self.ControlFile; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRQueue_W(Self: TIdLPR; const T: String);
begin Self.Queue := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRQueue_R(Self: TIdLPR; var T: String);
begin T := Self.Queue; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRJobId_W(Self: TIdLPR; const T: String);
begin Self.JobId := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRJobId_R(Self: TIdLPR; var T: String);
begin T := Self.JobId; end;

(*----------------------------------------------------------------------------*)
Procedure TIdLPRPrint1_P(Self: TIdLPR;  ABuffer : array of Byte);
Begin Self.Print(ABuffer); END;

(*----------------------------------------------------------------------------*)
Procedure TIdLPRPrint_P(Self: TIdLPR;  AText : String);
Begin Self.Print(AText); END;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileMailWhenPrinted_W(Self: TIdLPRControlFile; const T: Boolean);
begin Self.MailWhenPrinted := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileMailWhenPrinted_R(Self: TIdLPRControlFile; var T: Boolean);
begin T := Self.MailWhenPrinted; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileTroffSpecialFont_W(Self: TIdLPRControlFile; const T: String);
begin Self.TroffSpecialFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileTroffSpecialFont_R(Self: TIdLPRControlFile; var T: String);
begin T := Self.TroffSpecialFont; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileTroffBoldFont_W(Self: TIdLPRControlFile; const T: String);
begin Self.TroffBoldFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileTroffBoldFont_R(Self: TIdLPRControlFile; var T: String);
begin T := Self.TroffBoldFont; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileTroffItalicFont_W(Self: TIdLPRControlFile; const T: String);
begin Self.TroffItalicFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileTroffItalicFont_R(Self: TIdLPRControlFile; var T: String);
begin T := Self.TroffItalicFont; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileTroffRomanFont_W(Self: TIdLPRControlFile; const T: String);
begin Self.TroffRomanFont := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileTroffRomanFont_R(Self: TIdLPRControlFile; var T: String);
begin T := Self.TroffRomanFont; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileFileFormat_W(Self: TIdLPRControlFile; const T: TIdLPRFileFormat);
begin Self.FileFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileFileFormat_R(Self: TIdLPRControlFile; var T: TIdLPRFileFormat);
begin T := Self.FileFormat; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileOutputWidth_W(Self: TIdLPRControlFile; const T: Integer);
begin Self.OutputWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileOutputWidth_R(Self: TIdLPRControlFile; var T: Integer);
begin T := Self.OutputWidth; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileUserName_W(Self: TIdLPRControlFile; const T: String);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileUserName_R(Self: TIdLPRControlFile; var T: String);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileBannerPage_W(Self: TIdLPRControlFile; const T: Boolean);
begin Self.BannerPage := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileBannerPage_R(Self: TIdLPRControlFile; var T: Boolean);
begin T := Self.BannerPage; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileJobName_W(Self: TIdLPRControlFile; const T: String);
begin Self.JobName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileJobName_R(Self: TIdLPRControlFile; var T: String);
begin T := Self.JobName; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileIndentCount_W(Self: TIdLPRControlFile; const T: Integer);
begin Self.IndentCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileIndentCount_R(Self: TIdLPRControlFile; var T: Integer);
begin T := Self.IndentCount; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileBannerClass_W(Self: TIdLPRControlFile; const T: String);
begin Self.BannerClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileBannerClass_R(Self: TIdLPRControlFile; var T: String);
begin T := Self.BannerClass; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileHostName_W(Self: TIdLPRControlFile; const T: String);
begin Self.HostName := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdLPRControlFileHostName_R(Self: TIdLPRControlFile; var T: String);
begin T := Self.HostName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdLPR(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdLPR) do begin
    RegisterConstructor(@TIdLPR.Create, 'Create');
   RegisterMethod(@TIdLPR.Destroy, 'Free');
    RegisterMethod(@TIdLPRPrint_P, 'Print');
    RegisterMethod(@TIdLPRPrint1_P, 'Print1');
    RegisterMethod(@TIdLPR.PrintFile, 'PrintFile');
    RegisterMethod(@TIdLPR.GetQueueState, 'GetQueueState');
    RegisterMethod(@TIdLPR.PrintWaitingJobs, 'PrintWaitingJobs');
    RegisterMethod(@TIdLPR.RemoveJobList, 'RemoveJobList');
    RegisterPropertyHelper(@TIdLPRJobId_R,@TIdLPRJobId_W,'JobId');
    RegisterPropertyHelper(@TIdLPRQueue_R,@TIdLPRQueue_W,'Queue');
    RegisterPropertyHelper(@TIdLPRControlFile_R,@TIdLPRControlFile_W,'ControlFile');
    RegisterPropertyHelper(@TIdLPROnLPRStatus_R,@TIdLPROnLPRStatus_W,'OnLPRStatus');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdLPRControlFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdLPRControlFile) do
  begin
    RegisterConstructor(@TIdLPRControlFile.Create, 'Create');
      RegisterMethod(@TIdLPRControlFile.Destroy, 'Free');
     RegisterMethod(@TIdLPRControlFile.Assign, 'Assign');
    RegisterPropertyHelper(@TIdLPRControlFileHostName_R,@TIdLPRControlFileHostName_W,'HostName');
    RegisterPropertyHelper(@TIdLPRControlFileBannerClass_R,@TIdLPRControlFileBannerClass_W,'BannerClass');
    RegisterPropertyHelper(@TIdLPRControlFileIndentCount_R,@TIdLPRControlFileIndentCount_W,'IndentCount');
    RegisterPropertyHelper(@TIdLPRControlFileJobName_R,@TIdLPRControlFileJobName_W,'JobName');
    RegisterPropertyHelper(@TIdLPRControlFileBannerPage_R,@TIdLPRControlFileBannerPage_W,'BannerPage');
    RegisterPropertyHelper(@TIdLPRControlFileUserName_R,@TIdLPRControlFileUserName_W,'UserName');
    RegisterPropertyHelper(@TIdLPRControlFileOutputWidth_R,@TIdLPRControlFileOutputWidth_W,'OutputWidth');
    RegisterPropertyHelper(@TIdLPRControlFileFileFormat_R,@TIdLPRControlFileFileFormat_W,'FileFormat');
    RegisterPropertyHelper(@TIdLPRControlFileTroffRomanFont_R,@TIdLPRControlFileTroffRomanFont_W,'TroffRomanFont');
    RegisterPropertyHelper(@TIdLPRControlFileTroffItalicFont_R,@TIdLPRControlFileTroffItalicFont_W,'TroffItalicFont');
    RegisterPropertyHelper(@TIdLPRControlFileTroffBoldFont_R,@TIdLPRControlFileTroffBoldFont_W,'TroffBoldFont');
    RegisterPropertyHelper(@TIdLPRControlFileTroffSpecialFont_R,@TIdLPRControlFileTroffSpecialFont_W,'TroffSpecialFont');
    RegisterPropertyHelper(@TIdLPRControlFileMailWhenPrinted_R,@TIdLPRControlFileMailWhenPrinted_W,'MailWhenPrinted');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdLPR(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdLPRControlFile(CL);
  RIRegister_TIdLPR(CL);
  with CL.Add(EIdLPRErrorException) do
end;

 
 
{ TPSImport_IdLPR }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdLPR.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdLPR(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdLPR.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdLPR(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
