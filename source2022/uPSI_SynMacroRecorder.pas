unit uPSI_SynMacroRecorder;
{
  for macro and macrorecorder
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
  TPSImport_SynMacroRecorder = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSynMacroRecorder(CL: TPSPascalCompiler);
procedure SIRegister_TCustomSynMacroRecorder(CL: TPSPascalCompiler);
procedure SIRegister_TSynDataEvent(CL: TPSPascalCompiler);
procedure SIRegister_TSynPositionEvent(CL: TPSPascalCompiler);
procedure SIRegister_TSynStringEvent(CL: TPSPascalCompiler);
procedure SIRegister_TSynCharEvent(CL: TPSPascalCompiler);
procedure SIRegister_TSynBasicEvent(CL: TPSPascalCompiler);
procedure SIRegister_TSynMacroEvent(CL: TPSPascalCompiler);
procedure SIRegister_SynMacroRecorder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSynMacroRecorder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomSynMacroRecorder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynDataEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynPositionEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynStringEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynCharEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynBasicEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSynMacroEvent(CL: TPSRuntimeClassImporter);
procedure RIRegister_SynMacroRecorder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StdCtrls
  //,Controls
  //,Windows
  //,Messages
  //,Graphics
  //,Menus
  ,SynEdit
  ,SynEditKeyCmds
  ,SynEditPlugins
  ,SynEditTypes
  ,SynMacroRecorder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SynMacroRecorder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynMacroRecorder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomSynMacroRecorder', 'TSynMacroRecorder') do
  with CL.AddClassN(CL.FindClass('TCustomSynMacroRecorder'),'TSynMacroRecorder') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomSynMacroRecorder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAbstractSynHookerPlugin', 'TCustomSynMacroRecorder') do
  with CL.AddClassN(CL.FindClass('TAbstractSynHookerPlugin'),'TCustomSynMacroRecorder') do
  begin
    RegisterMethod('Constructor Create( aOwner : TComponent)');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Error( const aMsg : String)');
    RegisterMethod('Procedure AddEditor( aEditor : TCustomSynEdit)');
    RegisterMethod('Procedure RemoveEditor( aEditor : TCustomSynEdit)');
    RegisterMethod('Procedure RecordMacro( aEditor : TCustomSynEdit)');
    RegisterMethod('Procedure PlaybackMacro( aEditor : TCustomSynEdit)');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Procedure Pause');
    RegisterMethod('Procedure Resume');
    RegisterProperty('IsEmpty', 'boolean', iptr);
    RegisterProperty('State', 'TSynMacroState', iptr);
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure AddEvent( aCmd : TSynEditorCommand; aChar : char; aData : pointer)');
    RegisterMethod('Procedure InsertEvent( aIndex : integer; aCmd : TSynEditorCommand; aChar : char; aData : pointer)');
    RegisterMethod('Procedure AddCustomEvent( aEvent : TSynMacroEvent)');
    RegisterMethod('Procedure InsertCustomEvent( aIndex : integer; aEvent : TSynMacroEvent)');
    RegisterMethod('Procedure DeleteEvent( aIndex : integer)');
    RegisterMethod('Procedure LoadFromStream( aSrc : TStream)');
    RegisterMethod('Procedure LoadFromStreamEx( aSrc : TStream; aClear : boolean)');
    RegisterMethod('Procedure SaveToStream( aDest : TStream)');
    RegisterMethod('Procedure LoadFromFile( aFilename : string)');
    RegisterMethod('Procedure SaveToFile( aFilename : string)');
    RegisterProperty('EventCount', 'integer', iptr);
    RegisterProperty('Events', 'TSynMacroEvent integer', iptr);
    RegisterProperty('SaveMarkerPos', 'boolean', iptrw);
    RegisterProperty('AsString', 'string', iptrw);
    RegisterProperty('MacroName', 'string', iptrw);
    RegisterProperty('OnStateChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnUserCommand', 'TSynUserCommandEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynDataEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynBasicEvent', 'TSynDataEvent') do
  with CL.AddClassN(CL.FindClass('TSynBasicEvent'),'TSynDataEvent') do
  begin
    RegisterMethod('Procedure Initialize( aCmd : TSynEditorCommand; aChar : Char; aData : Pointer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynPositionEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynBasicEvent', 'TSynPositionEvent') do
  with CL.AddClassN(CL.FindClass('TSynBasicEvent'),'TSynPositionEvent') do begin
    RegisterMethod('Procedure Initialize( aCmd : TSynEditorCommand; aChar : Char; aData : Pointer)');
    RegisterProperty('Position', 'TBufferCoord', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynStringEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynMacroEvent', 'TSynStringEvent') do
  with CL.AddClassN(CL.FindClass('TSynMacroEvent'),'TSynStringEvent') do begin
    RegisterMethod('Procedure Initialize( aCmd : TSynEditorCommand; aChar : Char; aData : Pointer)');
    RegisterProperty('Value', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynCharEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynMacroEvent', 'TSynCharEvent') do
  with CL.AddClassN(CL.FindClass('TSynMacroEvent'),'TSynCharEvent') do begin
    RegisterMethod('Procedure Initialize( aCmd : TSynEditorCommand; aChar : Char; aData : Pointer)');
    RegisterProperty('Key', 'char', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynBasicEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TSynMacroEvent', 'TSynBasicEvent') do
  with CL.AddClassN(CL.FindClass('TSynMacroEvent'),'TSynBasicEvent') do begin
    RegisterMethod('Procedure Initialize( aCmd : TSynEditorCommand; aChar : Char; aData : Pointer)');
    RegisterProperty('Command', 'TSynEditorCommand', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSynMacroEvent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSynMacroEvent') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSynMacroEvent') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Initialize( aCmd : TSynEditorCommand; aChar : Char; aData : Pointer)');
    RegisterMethod('Procedure LoadFromStream( aStream : TStream)');
    RegisterMethod('Procedure SaveToStream( aStream : TStream)');
    RegisterMethod('Procedure Playback( aEditor : TCustomSynEdit)');
    RegisterProperty('AsString', 'string', iptr);
    RegisterProperty('RepeatCount', 'Byte', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SynMacroRecorder(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('sCannotRecord','String').SetString( 'Cannot record macro; already recording or playing');
 CL.AddConstantN('sCannotPlay','String').SetString( 'Cannot playback macro; already playing or recording');
 CL.AddConstantN('sCannotPause','String').SetString( 'Can only pause when recording');
 CL.AddConstantN('sCannotResume','String').SetString( 'Can only resume when paused');
  CL.AddTypeS('TSynMacroState', '( msStopped, msRecording, msPlaying, msPaused)');
  CL.AddTypeS('TSynMacroCommand', '( mcRecord, mcPlayback )');
  SIRegister_TSynMacroEvent(CL);
  SIRegister_TSynBasicEvent(CL);
  SIRegister_TSynCharEvent(CL);
  SIRegister_TSynStringEvent(CL);
  SIRegister_TSynPositionEvent(CL);
  SIRegister_TSynDataEvent(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCustomSynMacroRecorder');
 // CL.AddTypeS('TSynUserCommandEvent', 'Procedure ( aSender : TCustomSynMacroRec'
   //+'order; aCmd : TSynEditorCommand; var aEvent : TSynMacroEvent)');
  SIRegister_TCustomSynMacroRecorder(CL);
  SIRegister_TSynMacroRecorder(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderOnUserCommand_W(Self: TCustomSynMacroRecorder; const T: TSynUserCommandEvent);
begin Self.OnUserCommand := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderOnUserCommand_R(Self: TCustomSynMacroRecorder; var T: TSynUserCommandEvent);
begin T := Self.OnUserCommand; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderOnStateChange_W(Self: TCustomSynMacroRecorder; const T: TNotifyEvent);
begin Self.OnStateChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderOnStateChange_R(Self: TCustomSynMacroRecorder; var T: TNotifyEvent);
begin T := Self.OnStateChange; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderMacroName_W(Self: TCustomSynMacroRecorder; const T: string);
begin Self.MacroName := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderMacroName_R(Self: TCustomSynMacroRecorder; var T: string);
begin T := Self.MacroName; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderAsString_W(Self: TCustomSynMacroRecorder; const T: string);
begin Self.AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderAsString_R(Self: TCustomSynMacroRecorder; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderSaveMarkerPos_W(Self: TCustomSynMacroRecorder; const T: boolean);
begin Self.SaveMarkerPos := T; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderSaveMarkerPos_R(Self: TCustomSynMacroRecorder; var T: boolean);
begin T := Self.SaveMarkerPos; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderEvents_R(Self: TCustomSynMacroRecorder; var T: TSynMacroEvent; const t1: integer);
begin T := Self.Events[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderEventCount_R(Self: TCustomSynMacroRecorder; var T: integer);
begin T := Self.EventCount; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderState_R(Self: TCustomSynMacroRecorder; var T: TSynMacroState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TCustomSynMacroRecorderIsEmpty_R(Self: TCustomSynMacroRecorder; var T: boolean);
begin T := Self.IsEmpty; end;

(*----------------------------------------------------------------------------*)
procedure TSynPositionEventPosition_W(Self: TSynPositionEvent; const T: TBufferCoord);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynPositionEventPosition_R(Self: TSynPositionEvent; var T: TBufferCoord);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TSynStringEventValue_W(Self: TSynStringEvent; const T: string);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynStringEventValue_R(Self: TSynStringEvent; var T: string);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TSynCharEventKey_W(Self: TSynCharEvent; const T: char);
begin Self.Key := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynCharEventKey_R(Self: TSynCharEvent; var T: char);
begin T := Self.Key; end;

(*----------------------------------------------------------------------------*)
procedure TSynBasicEventCommand_W(Self: TSynBasicEvent; const T: TSynEditorCommand);
begin Self.Command := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynBasicEventCommand_R(Self: TSynBasicEvent; var T: TSynEditorCommand);
begin T := Self.Command; end;

(*----------------------------------------------------------------------------*)
procedure TSynMacroEventRepeatCount_W(Self: TSynMacroEvent; const T: Byte);
begin Self.RepeatCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TSynMacroEventRepeatCount_R(Self: TSynMacroEvent; var T: Byte);
begin T := Self.RepeatCount; end;

(*----------------------------------------------------------------------------*)
procedure TSynMacroEventAsString_R(Self: TSynMacroEvent; var T: string);
begin T := Self.AsString; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynMacroRecorder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynMacroRecorder) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomSynMacroRecorder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomSynMacroRecorder) do begin
    RegisterConstructor(@TCustomSynMacroRecorder.Create, 'Create');
    RegisterMethod(@TCustomSynMacroRecorder.Destroy, 'Free');
    RegisterMethod(@TCustomSynMacroRecorder.Error, 'Error');
    RegisterMethod(@TCustomSynMacroRecorder.AddEditor, 'AddEditor');
    RegisterMethod(@TCustomSynMacroRecorder.RemoveEditor, 'RemoveEditor');
    RegisterMethod(@TCustomSynMacroRecorder.RecordMacro, 'RecordMacro');
    RegisterMethod(@TCustomSynMacroRecorder.PlaybackMacro, 'PlaybackMacro');
    RegisterMethod(@TCustomSynMacroRecorder.Stop, 'Stop');
    RegisterMethod(@TCustomSynMacroRecorder.Pause, 'Pause');
    RegisterMethod(@TCustomSynMacroRecorder.Resume, 'Resume');
    RegisterPropertyHelper(@TCustomSynMacroRecorderIsEmpty_R,nil,'IsEmpty');
    RegisterPropertyHelper(@TCustomSynMacroRecorderState_R,nil,'State');
    RegisterMethod(@TCustomSynMacroRecorder.Clear, 'Clear');
    RegisterMethod(@TCustomSynMacroRecorder.AddEvent, 'AddEvent');
    RegisterMethod(@TCustomSynMacroRecorder.InsertEvent, 'InsertEvent');
    RegisterMethod(@TCustomSynMacroRecorder.AddCustomEvent, 'AddCustomEvent');
    RegisterMethod(@TCustomSynMacroRecorder.InsertCustomEvent, 'InsertCustomEvent');
    RegisterMethod(@TCustomSynMacroRecorder.DeleteEvent, 'DeleteEvent');
    RegisterMethod(@TCustomSynMacroRecorder.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TCustomSynMacroRecorder.LoadFromStreamEx, 'LoadFromStreamEx');
    RegisterMethod(@TCustomSynMacroRecorder.SaveToStream, 'SaveToStream');
    RegisterMethod(@TCustomSynMacroRecorder.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TCustomSynMacroRecorder.SaveToFile, 'SaveToFile');
    RegisterPropertyHelper(@TCustomSynMacroRecorderEventCount_R,nil,'EventCount');
    RegisterPropertyHelper(@TCustomSynMacroRecorderEvents_R,nil,'Events');
    RegisterPropertyHelper(@TCustomSynMacroRecorderSaveMarkerPos_R,@TCustomSynMacroRecorderSaveMarkerPos_W,'SaveMarkerPos');
    RegisterPropertyHelper(@TCustomSynMacroRecorderAsString_R,@TCustomSynMacroRecorderAsString_W,'AsString');
    RegisterPropertyHelper(@TCustomSynMacroRecorderMacroName_R,@TCustomSynMacroRecorderMacroName_W,'MacroName');
    RegisterPropertyHelper(@TCustomSynMacroRecorderOnStateChange_R,@TCustomSynMacroRecorderOnStateChange_W,'OnStateChange');
    RegisterPropertyHelper(@TCustomSynMacroRecorderOnUserCommand_R,@TCustomSynMacroRecorderOnUserCommand_W,'OnUserCommand');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynDataEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynDataEvent) do begin
    RegisterMethod(@TSynDataEvent.Initialize, 'Initialize');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynPositionEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynPositionEvent) do begin
    RegisterMethod(@TSynPositionEvent.Initialize, 'Initialize');
    RegisterPropertyHelper(@TSynPositionEventPosition_R,@TSynPositionEventPosition_W,'Position');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynStringEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynStringEvent) do begin
    RegisterMethod(@TSynStringEvent.Initialize, 'Initialize');
    RegisterPropertyHelper(@TSynStringEventValue_R,@TSynStringEventValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynCharEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynCharEvent) do begin
    RegisterMethod(@TSynCharEvent.Initialize, 'Initialize');
    RegisterPropertyHelper(@TSynCharEventKey_R,@TSynCharEventKey_W,'Key');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynBasicEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynBasicEvent) do begin
    RegisterMethod(@TSynBasicEvent.Initialize, 'Initialize');
    RegisterPropertyHelper(@TSynBasicEventCommand_R,@TSynBasicEventCommand_W,'Command');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSynMacroEvent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSynMacroEvent) do begin
    RegisterConstructor(@TSynMacroEvent.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TSynMacroEvent, @!.Initialize, 'Initialize');
    //RegisterVirtualAbstractMethod(@TSynMacroEvent, @!.LoadFromStream, 'LoadFromStream');
    //RegisterVirtualAbstractMethod(@TSynMacroEvent, @!.SaveToStream, 'SaveToStream');
    //RegisterVirtualAbstractMethod(@TSynMacroEvent, @!.Playback, 'Playback');
    RegisterPropertyHelper(@TSynMacroEventAsString_R,nil,'AsString');
    RegisterPropertyHelper(@TSynMacroEventRepeatCount_R,@TSynMacroEventRepeatCount_W,'RepeatCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SynMacroRecorder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSynMacroEvent(CL);
  RIRegister_TSynBasicEvent(CL);
  RIRegister_TSynCharEvent(CL);
  RIRegister_TSynStringEvent(CL);
  RIRegister_TSynPositionEvent(CL);
  RIRegister_TSynDataEvent(CL);
  with CL.Add(TCustomSynMacroRecorder) do
  RIRegister_TCustomSynMacroRecorder(CL);
  RIRegister_TSynMacroRecorder(CL);
end;



{ TPSImport_SynMacroRecorder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynMacroRecorder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SynMacroRecorder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SynMacroRecorder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SynMacroRecorder(ri);
end;
(*----------------------------------------------------------------------------*)


end.
