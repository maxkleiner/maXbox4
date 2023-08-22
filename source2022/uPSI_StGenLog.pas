unit uPSI_StGenLog;
{
   with one func hexify
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
  TPSImport_StGenLog = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TStGeneralLog(CL: TPSPascalCompiler);
procedure SIRegister_StGenLog(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StGenLog_Routines(S: TPSExec);
procedure RIRegister_TStGeneralLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_StGenLog(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StGenLog
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StGenLog]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStGeneralLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStGeneralLog') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStGeneralLog') do begin
    RegisterMethod('Constructor Create( Owner : TComponent)');
        RegisterMethod('Procedure Free');
      RegisterMethod('Procedure AddLogEntry( const D1, D2, D3, D4 : DWORD)');
    RegisterMethod('Procedure ClearBuffer');
    RegisterMethod('Procedure DumpLog');
    RegisterMethod('Procedure WriteLogString( const LogString : string)');
    RegisterProperty('BufferEmpty', 'Boolean', iptr);
    RegisterProperty('BufferFree', 'DWORD', iptr);
    RegisterProperty('BufferSize', 'DWORD', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('HighLevel', 'Byte', iptrw);
    RegisterProperty('LogFileFooter', 'string', iptrw);
    RegisterProperty('LogFileHeader', 'string', iptrw);
    RegisterProperty('LogOptions', 'StGenOptionSet', iptrw);
    RegisterProperty('WriteMode', 'TStWriteMode', iptrw);
    RegisterProperty('OnHighLevel', 'TNotifyEvent', iptrw);
    RegisterProperty('OnGetLogString', 'TStGetLogStringEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StGenLog(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('StDefBufferSize','LongInt').SetInt( 65536);
 CL.AddConstantN('StDefHighLevel','LongInt').SetInt( 0);
 CL.AddConstantN('StMaxLogSize','LongInt').SetInt( 16000000);
 CL.AddConstantN('StCRLF','String').SetString( #13#10);
 CL.AddConstantN('StLogFileFooter','String').SetString( '');
 CL.AddConstantN('leEnabled','LongInt').SetInt( 1);
 CL.AddConstantN('leDisabled','LongInt').SetInt( 2);
 CL.AddConstantN('leString','LongWord').SetUInt( DWORD ( $80000000 ));
  CL.AddTypeS('TStGetLogStringEvent', 'Procedure ( Sender : TObject; const D1, '
   +'D2, D3, D4 : DWORD; var LogString : string)');
  CL.AddTypeS('TStWriteMode', '( wmOverwrite, wmAppend )');
  //CL.AddTypeS('PStLogRec', '^TStLogRec // will not work');
  CL.AddTypeS('TStLogRec', 'record lrTime : DWORD; lrData1 : DWORD; lrData2 : D'
   +'WORD; lrData3 : DWORD; lrData4 : DWORD; end');
  //CL.AddTypeS('PStLogBuffer', '^TStLogBuffer // will not work');
  CL.AddTypeS('StGenOptions', '( goSuppressEnableMsg, goSuppressDisableMsg )');
  CL.AddTypeS('StGenOptionSet', 'set of StGenOptions');
  SIRegister_TStGeneralLog(CL);
 CL.AddDelphiFunction('Function HexifyBlock( var Buffer, BufferSize : Integer) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStGeneralLogOnGetLogString_W(Self: TStGeneralLog; const T: TStGetLogStringEvent);
begin Self.OnGetLogString := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogOnGetLogString_R(Self: TStGeneralLog; var T: TStGetLogStringEvent);
begin T := Self.OnGetLogString; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogOnHighLevel_W(Self: TStGeneralLog; const T: TNotifyEvent);
begin Self.OnHighLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogOnHighLevel_R(Self: TStGeneralLog; var T: TNotifyEvent);
begin T := Self.OnHighLevel; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogWriteMode_W(Self: TStGeneralLog; const T: TStWriteMode);
begin Self.WriteMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogWriteMode_R(Self: TStGeneralLog; var T: TStWriteMode);
begin T := Self.WriteMode; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogLogOptions_W(Self: TStGeneralLog; const T: StGenOptionSet);
begin Self.LogOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogLogOptions_R(Self: TStGeneralLog; var T: StGenOptionSet);
begin T := Self.LogOptions; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogLogFileHeader_W(Self: TStGeneralLog; const T: string);
begin Self.LogFileHeader := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogLogFileHeader_R(Self: TStGeneralLog; var T: string);
begin T := Self.LogFileHeader; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogLogFileFooter_W(Self: TStGeneralLog; const T: string);
begin Self.LogFileFooter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogLogFileFooter_R(Self: TStGeneralLog; var T: string);
begin T := Self.LogFileFooter; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogHighLevel_W(Self: TStGeneralLog; const T: Byte);
begin Self.HighLevel := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogHighLevel_R(Self: TStGeneralLog; var T: Byte);
begin T := Self.HighLevel; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogFileName_W(Self: TStGeneralLog; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogFileName_R(Self: TStGeneralLog; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogEnabled_W(Self: TStGeneralLog; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogEnabled_R(Self: TStGeneralLog; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogBufferSize_W(Self: TStGeneralLog; const T: DWORD);
begin Self.BufferSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogBufferSize_R(Self: TStGeneralLog; var T: DWORD);
begin T := Self.BufferSize; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogBufferFree_R(Self: TStGeneralLog; var T: DWORD);
begin T := Self.BufferFree; end;

(*----------------------------------------------------------------------------*)
procedure TStGeneralLogBufferEmpty_R(Self: TStGeneralLog; var T: Boolean);
begin T := Self.BufferEmpty; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StGenLog_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@HexifyBlock, 'HexifyBlock', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStGeneralLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStGeneralLog) do begin
    RegisterConstructor(@TStGeneralLog.Create, 'Create');
      RegisterMethod(@TStGeneralLog.Destroy, 'Free');
      RegisterMethod(@TStGeneralLog.AddLogEntry, 'AddLogEntry');
    RegisterMethod(@TStGeneralLog.ClearBuffer, 'ClearBuffer');
    RegisterVirtualMethod(@TStGeneralLog.DumpLog, 'DumpLog');
    RegisterMethod(@TStGeneralLog.WriteLogString, 'WriteLogString');
    RegisterPropertyHelper(@TStGeneralLogBufferEmpty_R,nil,'BufferEmpty');
    RegisterPropertyHelper(@TStGeneralLogBufferFree_R,nil,'BufferFree');
    RegisterPropertyHelper(@TStGeneralLogBufferSize_R,@TStGeneralLogBufferSize_W,'BufferSize');
    RegisterPropertyHelper(@TStGeneralLogEnabled_R,@TStGeneralLogEnabled_W,'Enabled');
    RegisterPropertyHelper(@TStGeneralLogFileName_R,@TStGeneralLogFileName_W,'FileName');
    RegisterPropertyHelper(@TStGeneralLogHighLevel_R,@TStGeneralLogHighLevel_W,'HighLevel');
    RegisterPropertyHelper(@TStGeneralLogLogFileFooter_R,@TStGeneralLogLogFileFooter_W,'LogFileFooter');
    RegisterPropertyHelper(@TStGeneralLogLogFileHeader_R,@TStGeneralLogLogFileHeader_W,'LogFileHeader');
    RegisterPropertyHelper(@TStGeneralLogLogOptions_R,@TStGeneralLogLogOptions_W,'LogOptions');
    RegisterPropertyHelper(@TStGeneralLogWriteMode_R,@TStGeneralLogWriteMode_W,'WriteMode');
    RegisterPropertyHelper(@TStGeneralLogOnHighLevel_R,@TStGeneralLogOnHighLevel_W,'OnHighLevel');
    RegisterPropertyHelper(@TStGeneralLogOnGetLogString_R,@TStGeneralLogOnGetLogString_W,'OnGetLogString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StGenLog(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStGeneralLog(CL);
end;

 
 
{ TPSImport_StGenLog }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StGenLog.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StGenLog(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StGenLog.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StGenLog(ri);
  RIRegister_StGenLog_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
