unit uPSI_AdSelCom;
{
  to another form templ
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
  TPSImport_AdSelCom = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TComSelectForm(CL: TPSPascalCompiler);
procedure SIRegister_AdSelCom(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AdSelCom_Routines(S: TPSExec);
procedure RIRegister_TComSelectForm(CL: TPSRuntimeClassImporter);
procedure RIRegister_AdSelCom(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,ExtCtrls
  ,Buttons
  ,OoMisc
  ,AwUser
  ,AwWin32
  ,AdSelCom
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AdSelCom]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TComSelectForm(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TComSelectForm') do
  with CL.AddClassN(CL.FindClass('TForm'),'TComSelectForm') do
  begin
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('Label2', 'TLabel', iptrw);
    RegisterProperty('OkBtn', 'TBitBtn', iptrw);
    RegisterProperty('AbortBtn', 'TBitBtn', iptrw);
    RegisterProperty('Bevel1', 'TBevel', iptrw);
    RegisterProperty('PortsComboBox', 'TComboBox', iptrw);
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Function SelectedCom : String');
    RegisterMethod('Function SelectedComNum : Word');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AdSelCom(CL: TPSPascalCompiler);
begin
  SIRegister_TComSelectForm(CL);
 CL.AddDelphiFunction('Function IsPortAvailable( ComNum : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function IsCOMPortReal( ComNum : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function IsCOM( ComNum : Cardinal) : Boolean');

 //CL.AddConstantN('UseDispatcherForAvail','Boolean').BoolToStr( True);
 //CL.AddConstantN('ShowPortsInUse','Boolean').BoolToStr( True);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TComSelectFormPortsComboBox_W(Self: TComSelectForm; const T: TComboBox);
Begin Self.PortsComboBox := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormPortsComboBox_R(Self: TComSelectForm; var T: TComboBox);
Begin T := Self.PortsComboBox; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormBevel1_W(Self: TComSelectForm; const T: TBevel);
Begin Self.Bevel1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormBevel1_R(Self: TComSelectForm; var T: TBevel);
Begin T := Self.Bevel1; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormAbortBtn_W(Self: TComSelectForm; const T: TBitBtn);
Begin Self.AbortBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormAbortBtn_R(Self: TComSelectForm; var T: TBitBtn);
Begin T := Self.AbortBtn; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormOkBtn_W(Self: TComSelectForm; const T: TBitBtn);
Begin Self.OkBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormOkBtn_R(Self: TComSelectForm; var T: TBitBtn);
Begin T := Self.OkBtn; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormLabel2_W(Self: TComSelectForm; const T: TLabel);
Begin Self.Label2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormLabel2_R(Self: TComSelectForm; var T: TLabel);
Begin T := Self.Label2; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormLabel1_W(Self: TComSelectForm; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TComSelectFormLabel1_R(Self: TComSelectForm; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AdSelCom_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsPortAvailable, 'IsPortAvailable', cdRegister);
  S.RegisterDelphiFunction(@IsPortAvailable, 'IsCOMPortReal', cdRegister);
  S.RegisterDelphiFunction(@IsPortAvailable, 'IsCOM', cdRegister);
 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TComSelectForm(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TComSelectForm) do begin
    RegisterPropertyHelper(@TComSelectFormLabel1_R,@TComSelectFormLabel1_W,'Label1');
    RegisterPropertyHelper(@TComSelectFormLabel2_R,@TComSelectFormLabel2_W,'Label2');
    RegisterPropertyHelper(@TComSelectFormOkBtn_R,@TComSelectFormOkBtn_W,'OkBtn');
    RegisterPropertyHelper(@TComSelectFormAbortBtn_R,@TComSelectFormAbortBtn_W,'AbortBtn');
    RegisterPropertyHelper(@TComSelectFormBevel1_R,@TComSelectFormBevel1_W,'Bevel1');
    RegisterPropertyHelper(@TComSelectFormPortsComboBox_R,@TComSelectFormPortsComboBox_W,'PortsComboBox');
    RegisterMethod(@TComSelectForm.FormCreate, 'FormCreate');
    RegisterMethod(@TComSelectForm.SelectedCom, 'SelectedCom');
    RegisterMethod(@TComSelectForm.SelectedComNum, 'SelectedComNum');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AdSelCom(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TComSelectForm(CL);
end;

 
 
{ TPSImport_AdSelCom }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdSelCom.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AdSelCom(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AdSelCom.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AdSelCom(ri);
  RIRegister_AdSelCom_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
