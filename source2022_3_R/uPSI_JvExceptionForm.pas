unit uPSI_JvExceptionForm;
{
  a last form to except
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
  TPSImport_JvExceptionForm = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJvErrorDialog(CL: TPSPascalCompiler);
procedure SIRegister_JvExceptionForm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvExceptionForm_Routines(S: TPSExec);
procedure RIRegister_TJvErrorDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvExceptionForm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Messages
  ,ComObj
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,ExtCtrls
  //,JvLabel
  ,JvComponent
  ,JvExControls
  ,JvExceptionForm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvExceptionForm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvErrorDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvForm', 'TJvErrorDialog') do
  with CL.AddClassN(CL.FindClass('TJvForm'),'TJvErrorDialog') do begin
    RegisterProperty('BasicPanel', 'TPanel', iptrw);
    RegisterProperty('ErrorText', 'TLabel', iptrw);
    RegisterProperty('IconPanel', 'TPanel', iptrw);
    RegisterProperty('IconImage', 'TImage', iptrw);
    RegisterProperty('TopPanel', 'TPanel', iptrw);
    RegisterProperty('RightPanel', 'TPanel', iptrw);
    RegisterProperty('DetailsPanel', 'TPanel', iptrw);
    RegisterProperty('MessageText', 'TMemo', iptrw);
    RegisterProperty('ErrorAddress', 'TEdit', iptrw);
    RegisterProperty('ErrorType', 'TEdit', iptrw);
    RegisterProperty('ButtonPanel', 'TPanel', iptrw);
    RegisterProperty('DetailsBtn', 'TButton', iptrw);
    RegisterProperty('OKBtn', 'TButton', iptrw);
    RegisterProperty('AddrLabel', 'TJvLabel', iptrw);
    RegisterProperty('TypeLabel', 'TJvLabel', iptrw);
    RegisterProperty('BottomPanel', 'TPanel', iptrw);
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure FormShow( Sender : TObject)');
    RegisterMethod('Procedure DetailsBtnClick( Sender : TObject)');
    RegisterMethod('Procedure ErrorInfo( var LogicalAddress : Pointer; var ModuleName : string)');
    RegisterMethod('Procedure FormKeyUp( Sender : TObject; var Key : Word; Shift : TShiftState)');
    RegisterMethod('Procedure ShowException( Sender : TObject; E : Exception)');
    RegisterProperty('OnErrorMsg', 'TJvErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvExceptionForm(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvErrorEvent', 'Procedure ( Error : Exception; var Msg : string)');
  SIRegister_TJvErrorDialog(CL);
 CL.AddDelphiFunction('Procedure JvErrorIntercept');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogOnErrorMsg_W(Self: TJvErrorDialog; const T: TJvErrorEvent);
begin Self.OnErrorMsg := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogOnErrorMsg_R(Self: TJvErrorDialog; var T: TJvErrorEvent);
begin T := Self.OnErrorMsg; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogBottomPanel_W(Self: TJvErrorDialog; const T: TPanel);
Begin Self.BottomPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogBottomPanel_R(Self: TJvErrorDialog; var T: TPanel);
Begin T := Self.BottomPanel; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogTypeLabel_W(Self: TJvErrorDialog; const T: TLabel);
Begin Self.TypeLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogTypeLabel_R(Self: TJvErrorDialog; var T: TLabel);
Begin T := Self.TypeLabel; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogAddrLabel_W(Self: TJvErrorDialog; const T: TLabel);
Begin Self.AddrLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogAddrLabel_R(Self: TJvErrorDialog; var T: TLabel);
Begin T := Self.AddrLabel; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogOKBtn_W(Self: TJvErrorDialog; const T: TButton);
Begin Self.OKBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogOKBtn_R(Self: TJvErrorDialog; var T: TButton);
Begin T := Self.OKBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogDetailsBtn_W(Self: TJvErrorDialog; const T: TButton);
Begin Self.DetailsBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogDetailsBtn_R(Self: TJvErrorDialog; var T: TButton);
Begin T := Self.DetailsBtn; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogButtonPanel_W(Self: TJvErrorDialog; const T: TPanel);
Begin Self.ButtonPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogButtonPanel_R(Self: TJvErrorDialog; var T: TPanel);
Begin T := Self.ButtonPanel; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogErrorType_W(Self: TJvErrorDialog; const T: TEdit);
Begin Self.ErrorType := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogErrorType_R(Self: TJvErrorDialog; var T: TEdit);
Begin T := Self.ErrorType; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogErrorAddress_W(Self: TJvErrorDialog; const T: TEdit);
Begin Self.ErrorAddress := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogErrorAddress_R(Self: TJvErrorDialog; var T: TEdit);
Begin T := Self.ErrorAddress; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogMessageText_W(Self: TJvErrorDialog; const T: TMemo);
Begin Self.MessageText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogMessageText_R(Self: TJvErrorDialog; var T: TMemo);
Begin T := Self.MessageText; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogDetailsPanel_W(Self: TJvErrorDialog; const T: TPanel);
Begin Self.DetailsPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogDetailsPanel_R(Self: TJvErrorDialog; var T: TPanel);
Begin T := Self.DetailsPanel; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogRightPanel_W(Self: TJvErrorDialog; const T: TPanel);
Begin Self.RightPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogRightPanel_R(Self: TJvErrorDialog; var T: TPanel);
Begin T := Self.RightPanel; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogTopPanel_W(Self: TJvErrorDialog; const T: TPanel);
Begin Self.TopPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogTopPanel_R(Self: TJvErrorDialog; var T: TPanel);
Begin T := Self.TopPanel; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogIconImage_W(Self: TJvErrorDialog; const T: TImage);
Begin Self.IconImage := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogIconImage_R(Self: TJvErrorDialog; var T: TImage);
Begin T := Self.IconImage; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogIconPanel_W(Self: TJvErrorDialog; const T: TPanel);
Begin Self.IconPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogIconPanel_R(Self: TJvErrorDialog; var T: TPanel);
Begin T := Self.IconPanel; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogErrorText_W(Self: TJvErrorDialog; const T: TLabel);
Begin Self.ErrorText := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogErrorText_R(Self: TJvErrorDialog; var T: TLabel);
Begin T := Self.ErrorText; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogBasicPanel_W(Self: TJvErrorDialog; const T: TPanel);
Begin Self.BasicPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvErrorDialogBasicPanel_R(Self: TJvErrorDialog; var T: TPanel);
Begin T := Self.BasicPanel; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvExceptionForm_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JvErrorIntercept, 'JvErrorIntercept', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvErrorDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvErrorDialog) do
  begin
    RegisterPropertyHelper(@TJvErrorDialogBasicPanel_R,@TJvErrorDialogBasicPanel_W,'BasicPanel');
    RegisterPropertyHelper(@TJvErrorDialogErrorText_R,@TJvErrorDialogErrorText_W,'ErrorText');
    RegisterPropertyHelper(@TJvErrorDialogIconPanel_R,@TJvErrorDialogIconPanel_W,'IconPanel');
    RegisterPropertyHelper(@TJvErrorDialogIconImage_R,@TJvErrorDialogIconImage_W,'IconImage');
    RegisterPropertyHelper(@TJvErrorDialogTopPanel_R,@TJvErrorDialogTopPanel_W,'TopPanel');
    RegisterPropertyHelper(@TJvErrorDialogRightPanel_R,@TJvErrorDialogRightPanel_W,'RightPanel');
    RegisterPropertyHelper(@TJvErrorDialogDetailsPanel_R,@TJvErrorDialogDetailsPanel_W,'DetailsPanel');
    RegisterPropertyHelper(@TJvErrorDialogMessageText_R,@TJvErrorDialogMessageText_W,'MessageText');
    RegisterPropertyHelper(@TJvErrorDialogErrorAddress_R,@TJvErrorDialogErrorAddress_W,'ErrorAddress');
    RegisterPropertyHelper(@TJvErrorDialogErrorType_R,@TJvErrorDialogErrorType_W,'ErrorType');
    RegisterPropertyHelper(@TJvErrorDialogButtonPanel_R,@TJvErrorDialogButtonPanel_W,'ButtonPanel');
    RegisterPropertyHelper(@TJvErrorDialogDetailsBtn_R,@TJvErrorDialogDetailsBtn_W,'DetailsBtn');
    RegisterPropertyHelper(@TJvErrorDialogOKBtn_R,@TJvErrorDialogOKBtn_W,'OKBtn');
    RegisterPropertyHelper(@TJvErrorDialogAddrLabel_R,@TJvErrorDialogAddrLabel_W,'AddrLabel');
    RegisterPropertyHelper(@TJvErrorDialogTypeLabel_R,@TJvErrorDialogTypeLabel_W,'TypeLabel');
    RegisterPropertyHelper(@TJvErrorDialogBottomPanel_R,@TJvErrorDialogBottomPanel_W,'BottomPanel');
    RegisterMethod(@TJvErrorDialog.FormCreate, 'FormCreate');
    RegisterMethod(@TJvErrorDialog.FormDestroy, 'FormDestroy');
    RegisterMethod(@TJvErrorDialog.FormShow, 'FormShow');
    RegisterMethod(@TJvErrorDialog.DetailsBtnClick, 'DetailsBtnClick');
    RegisterMethod(@TJvErrorDialog.ErrorInfo, 'ErrorInfo');
    RegisterMethod(@TJvErrorDialog.FormKeyUp, 'FormKeyUp');
    RegisterMethod(@TJvErrorDialog.ShowException, 'ShowException');
    RegisterPropertyHelper(@TJvErrorDialogOnErrorMsg_R,@TJvErrorDialogOnErrorMsg_W,'OnErrorMsg');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvExceptionForm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvErrorDialog(CL);
end;

 
 
{ TPSImport_JvExceptionForm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvExceptionForm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvExceptionForm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvExceptionForm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvExceptionForm(ri);
  RIRegister_JvExceptionForm_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
