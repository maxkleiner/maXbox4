unit uPSI_AfDataDispatcher;
{
   async free
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
  TPSImport_AfDataDispatcher = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAfDataDispatcher(CL: TPSPascalCompiler);
procedure SIRegister_TAfCustomDataDispatcher(CL: TPSPascalCompiler);
procedure SIRegister_TAfDataDispatcherLink(CL: TPSPascalCompiler);
procedure SIRegister_TAfDataDispConnComponent(CL: TPSPascalCompiler);
procedure SIRegister_AfDataDispatcher(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAfDataDispatcher(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfCustomDataDispatcher(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfDataDispatcherLink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfDataDispConnComponent(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfDataDispatcher(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,AfCircularBuffer
  ,AfSafeSync
  ,AfDataDispatcher
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfDataDispatcher]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfDataDispatcher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TAfCustomDataDispatcher', 'TAfDataDispatcher') do
  with CL.AddClassN(CL.FindClass('TAfCustomDataDispatcher'),'TAfDataDispatcher') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfCustomDataDispatcher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAfCustomDataDispatcher') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAfCustomDataDispatcher') do begin
    RegisterMethod('Procedure AbortWriteStream');
    RegisterMethod('Function BufFree : Integer');
    RegisterMethod('Function BufUsed : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure ClearBuffer');
    RegisterMethod('Procedure Dispatcher_WriteBufFree');
    RegisterMethod('Procedure Dispatcher_WriteTo( const Data, Size : Integer)');
    RegisterMethod('Function ReadChar : Char');
    RegisterMethod('Procedure ReadData( var Buf, Size : Integer)');
    RegisterMethod('Function ReadString : String');
    RegisterMethod('Procedure WriteChar( C : Char)');
    RegisterMethod('Procedure WriteData( const Data, Size : Integer)');
    RegisterMethod('Procedure WriteString( const S : String)');
    RegisterMethod('Procedure WriteStream( Stream : TStream; FreeAtferWrite : Boolean)');
    RegisterProperty('LinksList', 'TList', iptr);
    RegisterProperty('ReceivedBytes', 'Integer', iptr);
    RegisterProperty('SentBytes', 'Integer', iptr);
    RegisterProperty('StreamWriting', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfDataDispatcherLink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TAfDataDispatcherLink') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TAfDataDispatcherLink') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Notify( EventKind : TAfDispEventKind)');
    RegisterProperty('Dispatcher', 'TAfCustomDataDispatcher', iptrw);
    RegisterProperty('OnNotify', 'TAfDispLinkEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfDataDispConnComponent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TAfDataDispConnComponent') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TAfDataDispConnComponent') do begin
    RegisterMethod('Procedure Close');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure WriteData( const Data, Size : Integer)');
    RegisterProperty('Dispatcher', 'TAfCustomDataDispatcher', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfDataDispatcher(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAfDispatcherError');
  CL.AddTypeS('TAfDispEventKind', '( deData, deWriteBufFree, deClear )');
  CL.AddTypeS('TAfDispEventKinds', 'set of TAfDispEventKind');
  CL.AddTypeS('TAfDispLineEvent', 'Procedure ( Sender : TObject; const TextLine: String)');
  CL.AddTypeS('TAfDispLinkEvent', 'Procedure ( Sender : TObject; EventKind : TAfDispEventKind)');
  CL.AddTypeS('TAfDispStreamEvent', 'Procedure ( Sender : TObject; const Position, Size : Integer)');
  CL.AddTypeS('TAfDispWriteToEvent', 'Procedure ( Sender : TObject; const Data, Size : Integer)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TAfCustomDataDispatcher');
  SIRegister_TAfDataDispConnComponent(CL);
  SIRegister_TAfDataDispatcherLink(CL);
  SIRegister_TAfCustomDataDispatcher(CL);
  SIRegister_TAfDataDispatcher(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfCustomDataDispatcherStreamWriting_R(Self: TAfCustomDataDispatcher; var T: Boolean);
begin T := Self.StreamWriting; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomDataDispatcherSentBytes_R(Self: TAfCustomDataDispatcher; var T: Integer);
begin T := Self.SentBytes; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomDataDispatcherReceivedBytes_R(Self: TAfCustomDataDispatcher; var T: Integer);
begin T := Self.ReceivedBytes; end;

(*----------------------------------------------------------------------------*)
procedure TAfCustomDataDispatcherLinksList_R(Self: TAfCustomDataDispatcher; var T: TList);
begin T := Self.LinksList; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataDispatcherLinkOnNotify_W(Self: TAfDataDispatcherLink; const T: TAfDispLinkEvent);
begin Self.OnNotify := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataDispatcherLinkOnNotify_R(Self: TAfDataDispatcherLink; var T: TAfDispLinkEvent);
begin T := Self.OnNotify; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataDispatcherLinkDispatcher_W(Self: TAfDataDispatcherLink; const T: TAfCustomDataDispatcher);
begin Self.Dispatcher := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataDispatcherLinkDispatcher_R(Self: TAfDataDispatcherLink; var T: TAfCustomDataDispatcher);
begin T := Self.Dispatcher; end;

(*----------------------------------------------------------------------------*)
procedure TAfDataDispConnComponentDispatcher_R(Self: TAfDataDispConnComponent; var T: TAfCustomDataDispatcher);
begin T := Self.Dispatcher; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfDataDispatcher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfDataDispatcher) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfCustomDataDispatcher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfCustomDataDispatcher) do begin
    RegisterMethod(@TAfCustomDataDispatcher.AbortWriteStream, 'AbortWriteStream');
    RegisterMethod(@TAfCustomDataDispatcher.BufFree, 'BufFree');
    RegisterMethod(@TAfCustomDataDispatcher.BufUsed, 'BufUsed');
    RegisterMethod(@TAfCustomDataDispatcher.Clear, 'Clear');
    RegisterMethod(@TAfCustomDataDispatcher.ClearBuffer, 'ClearBuffer');
    RegisterMethod(@TAfCustomDataDispatcher.Dispatcher_WriteBufFree, 'Dispatcher_WriteBufFree');
    RegisterMethod(@TAfCustomDataDispatcher.Dispatcher_WriteTo, 'Dispatcher_WriteTo');
    RegisterMethod(@TAfCustomDataDispatcher.ReadChar, 'ReadChar');
    RegisterMethod(@TAfCustomDataDispatcher.ReadData, 'ReadData');
    RegisterMethod(@TAfCustomDataDispatcher.ReadString, 'ReadString');
    RegisterMethod(@TAfCustomDataDispatcher.WriteChar, 'WriteChar');
    RegisterMethod(@TAfCustomDataDispatcher.WriteData, 'WriteData');
    RegisterMethod(@TAfCustomDataDispatcher.WriteString, 'WriteString');
    RegisterMethod(@TAfCustomDataDispatcher.WriteStream, 'WriteStream');
    RegisterPropertyHelper(@TAfCustomDataDispatcherLinksList_R,nil,'LinksList');
    RegisterPropertyHelper(@TAfCustomDataDispatcherReceivedBytes_R,nil,'ReceivedBytes');
    RegisterPropertyHelper(@TAfCustomDataDispatcherSentBytes_R,nil,'SentBytes');
    RegisterPropertyHelper(@TAfCustomDataDispatcherStreamWriting_R,nil,'StreamWriting');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfDataDispatcherLink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfDataDispatcherLink) do
  begin
    RegisterConstructor(@TAfDataDispatcherLink.Create, 'Create');
    RegisterMethod(@TAfDataDispatcherLink.Notify, 'Notify');
    RegisterPropertyHelper(@TAfDataDispatcherLinkDispatcher_R,@TAfDataDispatcherLinkDispatcher_W,'Dispatcher');
    RegisterPropertyHelper(@TAfDataDispatcherLinkOnNotify_R,@TAfDataDispatcherLinkOnNotify_W,'OnNotify');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfDataDispConnComponent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfDataDispConnComponent) do
  begin
    RegisterVirtualMethod(@TAfDataDispConnComponent.Close, 'Close');
    RegisterVirtualMethod(@TAfDataDispConnComponent.Open, 'Open');
    //RegisterVirtualAbstractMethod(@TAfDataDispConnComponent, @!.WriteData, 'WriteData');
    RegisterPropertyHelper(@TAfDataDispConnComponentDispatcher_R,nil,'Dispatcher');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfDataDispatcher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EAfDispatcherError) do
  with CL.Add(TAfCustomDataDispatcher) do
  RIRegister_TAfDataDispConnComponent(CL);
  RIRegister_TAfDataDispatcherLink(CL);
  RIRegister_TAfCustomDataDispatcher(CL);
  RIRegister_TAfDataDispatcher(CL);
end;

 
 
{ TPSImport_AfDataDispatcher }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfDataDispatcher.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfDataDispatcher(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfDataDispatcher.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfDataDispatcher(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
