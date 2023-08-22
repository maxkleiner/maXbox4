unit uPSI_WDosDrivers;
{
Tjust for TKeboard and externals  - mapvirtualkey

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
  TPSImport_WDosDrivers = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMouse2(CL: TPSPascalCompiler);
procedure SIRegister_TKeyboard(CL: TPSPascalCompiler);
procedure SIRegister_TInputQueue(CL: TPSPascalCompiler);
procedure SIRegister_WDosDrivers(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMouse2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TKeyboard(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInputQueue(CL: TPSRuntimeClassImporter);
procedure RIRegister_WDosDrivers(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
 {  WDosWindows
  ,WDosMessages
  ,WDosSysUtils
  ,WDosClasses
  ,WDosForms
  ,WDosInterrupts
  ,WDosDriverConst  }
  WDosDrivers2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WDosDrivers]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMouse2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TMouse2') do
  with CL.AddClassN(CL.FindClass('TObject'),'TMouse2') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
       RegisterMethod('Procedure Init');
    RegisterMethod('Procedure Done');
    RegisterMethod('Procedure Show');
    RegisterMethod('Procedure Hide');
    RegisterMethod('Procedure SetScreenSize( Width, Height : Byte)');
    RegisterProperty('ButtonCount', 'Integer', iptr);
    RegisterProperty('Reverse', 'Boolean', iptrw);
    RegisterProperty('DoubleDelay', 'Integer', iptrw);
    RegisterProperty('Visible', 'Boolean', iptr);
    RegisterProperty('Enabled', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TKeyboard(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TKeyboard') do
  with CL.AddClassN(CL.FindClass('TObject'),'TKeyboard') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
     RegisterMethod('Procedure Init');
    RegisterMethod('Procedure Done');
    RegisterMethod('Function AsyncKeyChecked( VirtualKeyEx : Integer) : Boolean');
    RegisterMethod('Function AsyncKeyPressed( VirtualKeyEx : Integer) : Boolean');
    RegisterMethod('Function GetAsyncKeyState( VirtualKeyEx : Integer) : SmallInt');
    RegisterMethod('Function GetKeyboardState : TKeyboardState');
    RegisterMethod('Function GetKeyState( VirtualKeyEx : Integer) : SmallInt');
    RegisterMethod('Function KeyChecked( VirtualKeyEx : Integer) : Boolean');
    RegisterMethod('Procedure KeyEvent( VirtualKeyEx : Integer; ScanCode : Byte; Flags : TKeyEvents)');
    RegisterMethod('Function KeyPressed( VirtualKeyEx : Integer) : Boolean');
    RegisterMethod('Function MapVirtualKey( Code : Integer; MapType : TMapType) : Integer');
    RegisterMethod('Function SetIndicators( const AScrollLock, ANumLock, ACapsLock : Boolean) : Boolean');
    RegisterMethod('Procedure SetKeyboardState( const KeyboardState : TKeyboardState)');
    RegisterMethod('Function SetTypematic( Delay : TKeyboardDelay; Speed : TKeyboardSpeed) : Boolean');
    RegisterProperty('CapitalShift', 'Boolean', iptrw);
    RegisterProperty('CapsLock', 'Boolean', iptrw);
    RegisterProperty('Delay', 'TKeyboardDelay', iptrw);
    RegisterProperty('NumLock', 'Boolean', iptrw);
    RegisterProperty('ScrollLock', 'Boolean', iptrw);
    RegisterProperty('Speed', 'TKeyboardSpeed', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInputQueue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TInputQueue') do
  with CL.AddClassN(CL.FindClass('TObject'),'TInputQueue') do begin
    RegisterMethod('Procedure PeekAuxMsg( var AMsg : TMessage; var Handled : Boolean)');
    RegisterMethod('Procedure PeekInpMsg( var AMsg : TMessage; var Handled : Boolean)');
    RegisterMethod('Procedure TranslateMessage( Sender, Dest : TObject; var Msg : TMessage)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WDosDrivers(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('AuxMsgBuffSize','LongInt').SetInt( 8);
 CL.AddConstantN('InpMsgBuffSize','LongInt').SetInt( 32);
  CL.AddTypeS('TAuxMsgBuffRange', 'Integer');
  CL.AddTypeS('TInpMsgBuffRange', 'Integer');
  CL.AddTypeS('TInpMsg', 'record Msg : TMessage; AuxData : Integer; end');
  CL.AddTypeS('TKeyAuxData', 'record VirtualKeyEx : SmallInt; IsKeyboardKey : Boolean; Dummy : Byte; end');
  SIRegister_TInputQueue(CL);
  CL.AddTypeS('TKeyFlag', '( kfExtendedKey, kf1, kf2,kf3,kf4, kfContextCode,kfPreviousKeyState, kfTransitionState )');
  CL.AddTypeS('TKeyFlags', 'set of TKeyFlag');
  CL.AddTypeS('TKeyEvent2', '( keExtendedKey, keKeyUp )');
  CL.AddTypeS('TKeyEvents2', 'set of TKeyEvent2');
  CL.AddTypeS('TKeyData', 'record RepeatCount : Word; ScanCode : Byte; KeyFlags : TKeyFlags; end');
  CL.AddTypeS('TKeyboardDelay', 'Integer');
  CL.AddTypeS('TKeyboardSpeed', 'Integer');
  CL.AddTypeS('TMapType', '( mtVirtualToScan, mtScanToVirtual, mtVirtualToChar, mtScanToVirtualEx )');
  SIRegister_TKeyboard(CL);
  SIRegister_TMouse2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMouse2Enabled_W(Self: TMouse2; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TMouse2Enabled_R(Self: TMouse2; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TMouse2Visible_R(Self: TMouse2; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TMouse2DoubleDelay_W(Self: TMouse2; const T: Integer);
begin Self.DoubleDelay := T; end;

(*----------------------------------------------------------------------------*)
procedure TMouse2DoubleDelay_R(Self: TMouse2; var T: Integer);
begin T := Self.DoubleDelay; end;

(*----------------------------------------------------------------------------*)
procedure TMouse2Reverse_W(Self: TMouse2; const T: Boolean);
begin Self.Reverse := T; end;

(*----------------------------------------------------------------------------*)
procedure TMouse2Reverse_R(Self: TMouse2; var T: Boolean);
begin T := Self.Reverse; end;

(*----------------------------------------------------------------------------*)
procedure TMouse2ButtonCount_R(Self: TMouse2; var T: Integer);
begin T := Self.ButtonCount; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardEnabled_W(Self: TKeyboard; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardEnabled_R(Self: TKeyboard; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardSpeed_W(Self: TKeyboard; const T: TKeyboardSpeed);
begin Self.Speed := T; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardSpeed_R(Self: TKeyboard; var T: TKeyboardSpeed);
begin T := Self.Speed; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardScrollLock_W(Self: TKeyboard; const T: Boolean);
begin Self.ScrollLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardScrollLock_R(Self: TKeyboard; var T: Boolean);
begin T := Self.ScrollLock; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardNumLock_W(Self: TKeyboard; const T: Boolean);
begin Self.NumLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardNumLock_R(Self: TKeyboard; var T: Boolean);
begin T := Self.NumLock; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardDelay_W(Self: TKeyboard; const T: TKeyboardDelay);
begin Self.Delay := T; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardDelay_R(Self: TKeyboard; var T: TKeyboardDelay);
begin T := Self.Delay; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardCapsLock_W(Self: TKeyboard; const T: Boolean);
begin Self.CapsLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardCapsLock_R(Self: TKeyboard; var T: Boolean);
begin T := Self.CapsLock; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardCapitalShift_W(Self: TKeyboard; const T: Boolean);
begin Self.CapitalShift := T; end;

(*----------------------------------------------------------------------------*)
procedure TKeyboardCapitalShift_R(Self: TKeyboard; var T: Boolean);
begin T := Self.CapitalShift; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMouse2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMouse2) do begin
    RegisterConstructor(@TMouse2.Create, 'Create');
      RegisterMethod(@TMouse2.Destroy, 'Free');
      RegisterMethod(@TMouse2.Init, 'Init');
    RegisterMethod(@TMouse2.Done, 'Done');
    RegisterMethod(@TMouse2.Show, 'Show');
    RegisterMethod(@TMouse2.Hide, 'Hide');
    RegisterMethod(@TMouse2.SetScreenSize, 'SetScreenSize');
    RegisterPropertyHelper(@TMouse2ButtonCount_R,nil,'ButtonCount');
    RegisterPropertyHelper(@TMouse2Reverse_R,@TMouse2Reverse_W,'Reverse');
    RegisterPropertyHelper(@TMouse2DoubleDelay_R,@TMouse2DoubleDelay_W,'DoubleDelay');
    RegisterPropertyHelper(@TMouse2Visible_R,nil,'Visible');
    RegisterPropertyHelper(@TMouse2Enabled_R,@TMouse2Enabled_W,'Enabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TKeyboard(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TKeyboard) do begin
    RegisterConstructor(@TKeyboard.Create, 'Create');
         RegisterMethod(@TKeyboard.Destroy, 'Free');
     RegisterMethod(@TKeyboard.Init, 'Init');
    RegisterMethod(@TKeyboard.Done, 'Done');
    RegisterMethod(@TKeyboard.AsyncKeyChecked, 'AsyncKeyChecked');
    RegisterMethod(@TKeyboard.AsyncKeyPressed, 'AsyncKeyPressed');
    RegisterMethod(@TKeyboard.GetAsyncKeyState, 'GetAsyncKeyState');
    RegisterMethod(@TKeyboard.GetKeyboardState, 'GetKeyboardState');
    RegisterMethod(@TKeyboard.GetKeyState, 'GetKeyState');
    RegisterMethod(@TKeyboard.KeyChecked, 'KeyChecked');
    RegisterMethod(@TKeyboard.KeyEvent, 'KeyEvent');
    RegisterMethod(@TKeyboard.KeyPressed, 'KeyPressed');
    RegisterMethod(@TKeyboard.MapVirtualKey, 'MapVirtualKey');
    RegisterMethod(@TKeyboard.SetIndicators, 'SetIndicators');
    RegisterMethod(@TKeyboard.SetKeyboardState, 'SetKeyboardState');
    RegisterMethod(@TKeyboard.SetTypematic, 'SetTypematic');
    RegisterPropertyHelper(@TKeyboardCapitalShift_R,@TKeyboardCapitalShift_W,'CapitalShift');
    RegisterPropertyHelper(@TKeyboardCapsLock_R,@TKeyboardCapsLock_W,'CapsLock');
    RegisterPropertyHelper(@TKeyboardDelay_R,@TKeyboardDelay_W,'Delay');
    RegisterPropertyHelper(@TKeyboardNumLock_R,@TKeyboardNumLock_W,'NumLock');
    RegisterPropertyHelper(@TKeyboardScrollLock_R,@TKeyboardScrollLock_W,'ScrollLock');
    RegisterPropertyHelper(@TKeyboardSpeed_R,@TKeyboardSpeed_W,'Speed');
    RegisterPropertyHelper(@TKeyboardEnabled_R,@TKeyboardEnabled_W,'Enabled');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInputQueue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInputQueue) do
  begin
    RegisterMethod(@TInputQueue.PeekAuxMsg, 'PeekAuxMsg');
    RegisterMethod(@TInputQueue.PeekInpMsg, 'PeekInpMsg');
    RegisterMethod(@TInputQueue.TranslateMessage, 'TranslateMessage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WDosDrivers(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TInputQueue(CL);
  RIRegister_TKeyboard(CL);
  RIRegister_TMouse2(CL);
end;

 
 
{ TPSImport_WDosDrivers }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosDrivers.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WDosDrivers(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDosDrivers.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WDosDrivers(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
