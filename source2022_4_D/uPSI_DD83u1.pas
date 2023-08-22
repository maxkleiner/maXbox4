unit uPSI_DD83u1;
{
    arduino tester
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
  TPSImport_DD83u1 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDD83f1(CL: TPSPascalCompiler);
procedure SIRegister_DD83u1(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDD83f1(CL: TPSRuntimeClassImporter);
procedure RIRegister_DD83u1(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,ExtCtrls
  ,DD83u1
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DD83u1]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDD83f1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TDD83f1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TDD83f1') do
  begin
    RegisterProperty('buQuit', 'TButton', iptrw);
    RegisterProperty('laVersion', 'TLabel', iptrw);
    RegisterProperty('Timer1', 'TTimer', iptrw);
    RegisterProperty('buLEDOn', 'TButton', iptrw);
    RegisterProperty('buLEDOff', 'TButton', iptrw);
    RegisterProperty('laLEDState', 'TLabel', iptrw);
    RegisterProperty('laSwitchState', 'TLabel', iptrw);
    RegisterProperty('laDebug', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('Label3', 'TLabel', iptrw);
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure buQuitClick( Sender : TObject)');
    RegisterMethod('Procedure Timer1Timer( Sender : TObject)');
    RegisterMethod('Procedure buLEDOnClick( Sender : TObject)');
    RegisterMethod('Procedure buLEDOffClick( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DD83u1(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('dd83ver','String').SetString( '3 Aug 10');
 CL.AddConstantN('RxBufferSize','LongInt').SetInt( 256);
 CL.AddConstantN('TxBufferSize','LongInt').SetInt( 256);
 CL.AddConstantN('dd83bTryIt','LongInt').SetInt( 2);
  SIRegister_TDD83f1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDD83f1Label3_W(Self: TDD83f1; const T: TLabel);
Begin Self.Label3 := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1Label3_R(Self: TDD83f1; var T: TLabel);
Begin T := Self.Label3; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1Label2_W(Self: TDD83f1; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1Label2_R(Self: TDD83f1; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1laDebug_W(Self: TDD83f1; const T: TLabel);
Begin Self.laDebug := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1laDebug_R(Self: TDD83f1; var T: TLabel);
Begin T := Self.laDebug; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1laSwitchState_W(Self: TDD83f1; const T: TLabel);
Begin Self.laSwitchState := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1laSwitchState_R(Self: TDD83f1; var T: TLabel);
Begin T := Self.laSwitchState; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1laLEDState_W(Self: TDD83f1; const T: TLabel);
Begin Self.laLEDState := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1laLEDState_R(Self: TDD83f1; var T: TLabel);
Begin T := Self.laLEDState; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1buLEDOff_W(Self: TDD83f1; const T: TButton);
Begin Self.buLEDOff := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1buLEDOff_R(Self: TDD83f1; var T: TButton);
Begin T := Self.buLEDOff; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1buLEDOn_W(Self: TDD83f1; const T: TButton);
Begin Self.buLEDOn := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1buLEDOn_R(Self: TDD83f1; var T: TButton);
Begin T := Self.buLEDOn; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1Timer1_W(Self: TDD83f1; const T: TTimer);
Begin Self.Timer1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1Timer1_R(Self: TDD83f1; var T: TTimer);
Begin T := Self.Timer1; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1laVersion_W(Self: TDD83f1; const T: TLabel);
Begin Self.laVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1laVersion_R(Self: TDD83f1; var T: TLabel);
Begin T := Self.laVersion; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1buQuit_W(Self: TDD83f1; const T: TButton);
Begin Self.buQuit := T; end;

(*----------------------------------------------------------------------------*)
procedure TDD83f1buQuit_R(Self: TDD83f1; var T: TButton);
Begin T := Self.buQuit; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDD83f1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDD83f1) do
  begin
    RegisterPropertyHelper(@TDD83f1buQuit_R,@TDD83f1buQuit_W,'buQuit');
    RegisterPropertyHelper(@TDD83f1laVersion_R,@TDD83f1laVersion_W,'laVersion');
    RegisterPropertyHelper(@TDD83f1Timer1_R,@TDD83f1Timer1_W,'Timer1');
    RegisterPropertyHelper(@TDD83f1buLEDOn_R,@TDD83f1buLEDOn_W,'buLEDOn');
    RegisterPropertyHelper(@TDD83f1buLEDOff_R,@TDD83f1buLEDOff_W,'buLEDOff');
    RegisterPropertyHelper(@TDD83f1laLEDState_R,@TDD83f1laLEDState_W,'laLEDState');
    RegisterPropertyHelper(@TDD83f1laSwitchState_R,@TDD83f1laSwitchState_W,'laSwitchState');
    RegisterPropertyHelper(@TDD83f1laDebug_R,@TDD83f1laDebug_W,'laDebug');
    RegisterPropertyHelper(@TDD83f1Label2_R,@TDD83f1Label2_W,'Label2');
    RegisterPropertyHelper(@TDD83f1Label3_R,@TDD83f1Label3_W,'Label3');
    RegisterMethod(@TDD83f1.FormCreate, 'FormCreate');
    RegisterMethod(@TDD83f1.FormClose, 'FormClose');
    RegisterMethod(@TDD83f1.buQuitClick, 'buQuitClick');
    RegisterMethod(@TDD83f1.Timer1Timer, 'Timer1Timer');
    RegisterMethod(@TDD83f1.buLEDOnClick, 'buLEDOnClick');
    RegisterMethod(@TDD83f1.buLEDOffClick, 'buLEDOffClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DD83u1(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDD83f1(CL);
end;

 
 
{ TPSImport_DD83u1 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DD83u1.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DD83u1(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DD83u1.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DD83u1(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
