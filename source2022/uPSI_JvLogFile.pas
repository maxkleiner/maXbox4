unit uPSI_JvLogFile;
{
  with log form
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
  TPSImport_JvLogFile = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvLogFile(CL: TPSPascalCompiler);
procedure SIRegister_TJvLogRecord(CL: TPSPascalCompiler);
procedure SIRegister_JvLogFile(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvLogFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvLogRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvLogFile(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Controls
  ,Forms
  ,JvComponent
  ,JvLogFile
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvLogFile]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLogFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvLogFile') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvLogFile') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure LoadFromFile( FileName : TFileName)');
    RegisterMethod('Procedure SaveToFile( FileName : TFileName)');
    RegisterMethod('Procedure SaveToStream( Stream : TStream)');
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)');
    RegisterMethod('Procedure Add( const Time, Title : string; const Description : string);');
    RegisterMethod('Procedure Add1( const Title : string; const Description : string);');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Count : Integer');
    RegisterProperty('Elements', 'TJvLogRecord Integer', iptr);
    SetDefaultPropery('Elements');
    RegisterMethod('Procedure ShowLog( Title : string)');
    RegisterProperty('OnShow', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvLogRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJvLogRecord') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJvLogRecord') do begin
    RegisterProperty('Time', 'string', iptrw);
    RegisterProperty('Title', 'string', iptrw);
    RegisterProperty('Description', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvLogFile(CL: TPSPascalCompiler);
begin
  SIRegister_TJvLogRecord(CL);
  SIRegister_TJvLogFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvLogFileOnClose_W(Self: TJvLogFile; const T: TNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogFileOnClose_R(Self: TJvLogFile; var T: TNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogFileOnShow_W(Self: TJvLogFile; const T: TNotifyEvent);
begin Self.OnShow := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogFileOnShow_R(Self: TJvLogFile; var T: TNotifyEvent);
begin T := Self.OnShow; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogFileElements_R(Self: TJvLogFile; var T: TJvLogRecord; const t1: Integer);
begin T := Self.Elements[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TJvLogFileAdd1_P(Self: TJvLogFile;  const Title : string; const Description : string);
Begin Self.Add(Title, Description); END;

(*----------------------------------------------------------------------------*)
Procedure TJvLogFileAdd_P(Self: TJvLogFile;  const Time, Title : string; const Description : string);
Begin Self.Add(Time, Title, Description); END;

(*----------------------------------------------------------------------------*)
procedure TJvLogRecordDescription_W(Self: TJvLogRecord; const T: string);
Begin Self.Description := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogRecordDescription_R(Self: TJvLogRecord; var T: string);
Begin T := Self.Description; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogRecordTitle_W(Self: TJvLogRecord; const T: string);
Begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogRecordTitle_R(Self: TJvLogRecord; var T: string);
Begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogRecordTime_W(Self: TJvLogRecord; const T: string);
Begin Self.Time := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvLogRecordTime_R(Self: TJvLogRecord; var T: string);
Begin T := Self.Time; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLogFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLogFile) do begin
    RegisterConstructor(@TJvLogFile.Create, 'Create');
    RegisterMethod(@TJvLogFile.Destroy, 'Free');
    RegisterMethod(@TJvLogFile.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TJvLogFile.SaveToFile, 'SaveToFile');
    RegisterMethod(@TJvLogFile.SaveToStream, 'SaveToStream');
    RegisterMethod(@TJvLogFile.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TJvLogFileAdd_P, 'Add');
    RegisterMethod(@TJvLogFileAdd1_P, 'Add1');
    RegisterMethod(@TJvLogFile.Delete, 'Delete');
    RegisterMethod(@TJvLogFile.Clear, 'Clear');
    RegisterMethod(@TJvLogFile.Count, 'Count');
    RegisterPropertyHelper(@TJvLogFileElements_R,nil,'Elements');
    RegisterMethod(@TJvLogFile.ShowLog, 'ShowLog');
    RegisterPropertyHelper(@TJvLogFileOnShow_R,@TJvLogFileOnShow_W,'OnShow');
    RegisterPropertyHelper(@TJvLogFileOnClose_R,@TJvLogFileOnClose_W,'OnClose');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvLogRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvLogRecord) do begin
    RegisterPropertyHelper(@TJvLogRecordTime_R,@TJvLogRecordTime_W,'Time');
    RegisterPropertyHelper(@TJvLogRecordTitle_R,@TJvLogRecordTitle_W,'Title');
    RegisterPropertyHelper(@TJvLogRecordDescription_R,@TJvLogRecordDescription_W,'Description');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvLogFile(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvLogRecord(CL);
  RIRegister_TJvLogFile(CL);
end;

 
 
{ TPSImport_JvLogFile }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvLogFile.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvLogFile(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvLogFile.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvLogFile(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
