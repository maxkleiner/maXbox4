unit uPSI_SimplePortMain;
{
   formtemplate   portform
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
  TPSImport_SimplePortMain = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
procedure SIRegister_SimplePortMain(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimplePortMain(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,ExtCtrls
  ,AfViewers
  ,StdCtrls
  ,AfPortControls
  ,AfDataDispatcher
  ,AfComPort
  ,SimplePortMain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimplePortMain]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TForm1(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TForm1') do
  with CL.AddClassN(CL.FindClass('TForm'),'TPortForm1') do begin
    RegisterProperty('Panel1', 'TPanel', iptrw);
    RegisterProperty('AfTerminal1', 'TAfTerminal', iptrw);
    RegisterProperty('AfComPort1', 'TAfComPort', iptrw);
    RegisterProperty('Button1', 'TButton', iptrw);
    RegisterProperty('AfPortRadioGroup1', 'TAfPortRadioGroup', iptrw);
    RegisterMethod('Procedure AfTerminal1SendChar( Sender : TObject; var Key : Char)');
    RegisterMethod('Procedure AfComPort1DataRecived( Sender : TObject; Count : Integer)');
    RegisterMethod('Procedure Button1Click( Sender : TObject)');
    RegisterMethod('Procedure AfPortRadioGroup1Click( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimplePortMain(CL: TPSPascalCompiler);
begin
  SIRegister_TForm1(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TForm1AfPortRadioGroup1_W(Self: TPortForm1; const T: TAfPortRadioGroup);
Begin Self.AfPortRadioGroup1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AfPortRadioGroup1_R(Self: TPortForm1; var T: TAfPortRadioGroup);
Begin T := Self.AfPortRadioGroup1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button1_W(Self: TPortForm1; const T: TButton);
Begin Self.Button1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Button1_R(Self: TPortForm1; var T: TButton);
Begin T := Self.Button1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AfComPort1_W(Self: TPortForm1; const T: TAfComPort);
Begin Self.AfComPort1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AfComPort1_R(Self: TPortForm1; var T: TAfComPort);
Begin T := Self.AfComPort1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AfTerminal1_W(Self: TPortForm1; const T: TAfTerminal);
Begin Self.AfTerminal1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1AfTerminal1_R(Self: TPortForm1; var T: TAfTerminal);
Begin T := Self.AfTerminal1; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Panel1_W(Self: TPortForm1; const T: TPanel);
Begin Self.Panel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm1Panel1_R(Self: TPortForm1; var T: TPanel);
Begin T := Self.Panel1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPortForm1) do begin
    RegisterPropertyHelper(@TForm1Panel1_R,@TForm1Panel1_W,'Panel1');
    RegisterPropertyHelper(@TForm1AfTerminal1_R,@TForm1AfTerminal1_W,'AfTerminal1');
    RegisterPropertyHelper(@TForm1AfComPort1_R,@TForm1AfComPort1_W,'AfComPort1');
    RegisterPropertyHelper(@TForm1Button1_R,@TForm1Button1_W,'Button1');
    RegisterPropertyHelper(@TForm1AfPortRadioGroup1_R,@TForm1AfPortRadioGroup1_W,'AfPortRadioGroup1');
    RegisterMethod(@TPortForm1.AfTerminal1SendChar, 'AfTerminal1SendChar');
    RegisterMethod(@TPortForm1.AfComPort1DataRecived, 'AfComPort1DataRecived');
    RegisterMethod(@TPortForm1.Button1Click, 'Button1Click');
    RegisterMethod(@TPortForm1.AfPortRadioGroup1Click, 'AfPortRadioGroup1Click');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimplePortMain(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TForm1(CL);
end;



{ TPSImport_SimplePortMain }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimplePortMain.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimplePortMain(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimplePortMain.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimplePortMain(ri);
end;
(*----------------------------------------------------------------------------*)


end.
