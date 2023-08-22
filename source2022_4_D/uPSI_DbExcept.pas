unit uPSI_DbExcept;
{
   af form of form template lib
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
  TPSImport_DbExcept = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDbEngineErrorDlg(CL: TPSPascalCompiler);
procedure SIRegister_DbExcept(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TDbEngineErrorDlg(CL: TPSRuntimeClassImporter);
procedure RIRegister_DbExcept(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Forms
  ,Controls
  ,Buttons
  ,StdCtrls
  ,ExtCtrls
  ,DB
  ,DBTables
  ,DbExcept
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DbExcept]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDbEngineErrorDlg(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TDbEngineErrorDlg') do
  with CL.AddClassN(CL.FindClass('TForm'),'TDbEngineErrorDlg') do begin
    RegisterMethod('Constructor Create(AOwner: TComponent);');
    RegisterMethod('Procedure Free');
    RegisterProperty('BasicPanel', 'TPanel', iptrw);
    RegisterProperty('DetailsPanel', 'TPanel', iptrw);
    RegisterProperty('BDELabel', 'TLabel', iptrw);
    RegisterProperty('NativeLabel', 'TLabel', iptrw);
    RegisterProperty('DbMessageText', 'TMemo', iptrw);
    RegisterProperty('DbResult', 'TEdit', iptrw);
    RegisterProperty('DbCatSub', 'TEdit', iptrw);
    RegisterProperty('NativeResult', 'TEdit', iptrw);
    RegisterProperty('BackBtn', 'TButton', iptrw);
    RegisterProperty('NextBtn', 'TButton', iptrw);
    RegisterProperty('ButtonPanel', 'TPanel', iptrw);
    RegisterProperty('DetailsBtn', 'TButton', iptrw);
    RegisterProperty('OKBtn', 'TButton', iptrw);
    RegisterProperty('IconPanel', 'TPanel', iptrw);
    RegisterProperty('IconImage', 'TImage', iptrw);
    RegisterProperty('TopPanel', 'TPanel', iptrw);
    RegisterProperty('ErrorText', 'TLabel', iptrw);
    RegisterProperty('RightPanel', 'TPanel', iptrw);
    RegisterMethod('Procedure FormShow( Sender : TObject)');
    RegisterMethod('Procedure BackClick( Sender : TObject)');
    RegisterMethod('Procedure NextClick( Sender : TObject)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
    RegisterMethod('Procedure DetailsBtnClick( Sender : TObject)');
    RegisterMethod('Procedure FormDestroy( Sender : TObject)');
    RegisterMethod('Procedure HookExceptions');
    RegisterMethod('Function ShowException( Error : EDbEngineError) : TModalResult');
    RegisterProperty('DbException', 'EDbEngineError', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DbExcept(CL: TPSPascalCompiler);
begin
  SIRegister_TDbEngineErrorDlg(CL);
end;

//var
  //DbEngineErrorDlg: TDbEngineErrorDlg;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDbException_W(Self: TDbEngineErrorDlg; const T: EDbEngineError);
begin Self.DbException := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDbException_R(Self: TDbEngineErrorDlg; var T: EDbEngineError);
begin T := Self.DbException; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgRightPanel_W(Self: TDbEngineErrorDlg; const T: TPanel);
Begin Self.RightPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgRightPanel_R(Self: TDbEngineErrorDlg; var T: TPanel);
Begin T := Self.RightPanel; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgErrorText_W(Self: TDbEngineErrorDlg; const T: TLabel);
Begin Self.ErrorText := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgErrorText_R(Self: TDbEngineErrorDlg; var T: TLabel);
Begin T := Self.ErrorText; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgTopPanel_W(Self: TDbEngineErrorDlg; const T: TPanel);
Begin Self.TopPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgTopPanel_R(Self: TDbEngineErrorDlg; var T: TPanel);
Begin T := Self.TopPanel; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgIconImage_W(Self: TDbEngineErrorDlg; const T: TImage);
Begin Self.IconImage := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgIconImage_R(Self: TDbEngineErrorDlg; var T: TImage);
Begin T := Self.IconImage; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgIconPanel_W(Self: TDbEngineErrorDlg; const T: TPanel);
Begin Self.IconPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgIconPanel_R(Self: TDbEngineErrorDlg; var T: TPanel);
Begin T := Self.IconPanel; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgOKBtn_W(Self: TDbEngineErrorDlg; const T: TButton);
Begin Self.OKBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgOKBtn_R(Self: TDbEngineErrorDlg; var T: TButton);
Begin T := Self.OKBtn; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDetailsBtn_W(Self: TDbEngineErrorDlg; const T: TButton);
Begin Self.DetailsBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDetailsBtn_R(Self: TDbEngineErrorDlg; var T: TButton);
Begin T := Self.DetailsBtn; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgButtonPanel_W(Self: TDbEngineErrorDlg; const T: TPanel);
Begin Self.ButtonPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgButtonPanel_R(Self: TDbEngineErrorDlg; var T: TPanel);
Begin T := Self.ButtonPanel; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgNextBtn_W(Self: TDbEngineErrorDlg; const T: TButton);
Begin Self.NextBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgNextBtn_R(Self: TDbEngineErrorDlg; var T: TButton);
Begin T := Self.NextBtn; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgBackBtn_W(Self: TDbEngineErrorDlg; const T: TButton);
Begin Self.BackBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgBackBtn_R(Self: TDbEngineErrorDlg; var T: TButton);
Begin T := Self.BackBtn; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgNativeResult_W(Self: TDbEngineErrorDlg; const T: TEdit);
Begin Self.NativeResult := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgNativeResult_R(Self: TDbEngineErrorDlg; var T: TEdit);
Begin T := Self.NativeResult; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDbCatSub_W(Self: TDbEngineErrorDlg; const T: TEdit);
Begin Self.DbCatSub := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDbCatSub_R(Self: TDbEngineErrorDlg; var T: TEdit);
Begin T := Self.DbCatSub; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDbResult_W(Self: TDbEngineErrorDlg; const T: TEdit);
Begin Self.DbResult := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDbResult_R(Self: TDbEngineErrorDlg; var T: TEdit);
Begin T := Self.DbResult; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDbMessageText_W(Self: TDbEngineErrorDlg; const T: TMemo);
Begin Self.DbMessageText := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDbMessageText_R(Self: TDbEngineErrorDlg; var T: TMemo);
Begin T := Self.DbMessageText; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgNativeLabel_W(Self: TDbEngineErrorDlg; const T: TLabel);
Begin Self.NativeLabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgNativeLabel_R(Self: TDbEngineErrorDlg; var T: TLabel);
Begin T := Self.NativeLabel; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgBDELabel_W(Self: TDbEngineErrorDlg; const T: TLabel);
Begin Self.BDELabel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgBDELabel_R(Self: TDbEngineErrorDlg; var T: TLabel);
Begin T := Self.BDELabel; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDetailsPanel_W(Self: TDbEngineErrorDlg; const T: TPanel);
Begin Self.DetailsPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgDetailsPanel_R(Self: TDbEngineErrorDlg; var T: TPanel);
Begin T := Self.DetailsPanel; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgBasicPanel_W(Self: TDbEngineErrorDlg; const T: TPanel);
Begin Self.BasicPanel := T; end;

(*----------------------------------------------------------------------------*)
procedure TDbEngineErrorDlgBasicPanel_R(Self: TDbEngineErrorDlg; var T: TPanel);
Begin T := Self.BasicPanel; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDbEngineErrorDlg(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDbEngineErrorDlg) do begin
    RegisterConstructor(@TDbEngineErrorDlg.Create, 'Create');
   RegisterMethod(@TDbEngineErrorDlg.Free, 'Free');
     RegisterPropertyHelper(@TDbEngineErrorDlgBasicPanel_R,@TDbEngineErrorDlgBasicPanel_W,'BasicPanel');
    RegisterPropertyHelper(@TDbEngineErrorDlgDetailsPanel_R,@TDbEngineErrorDlgDetailsPanel_W,'DetailsPanel');
    RegisterPropertyHelper(@TDbEngineErrorDlgBDELabel_R,@TDbEngineErrorDlgBDELabel_W,'BDELabel');
    RegisterPropertyHelper(@TDbEngineErrorDlgNativeLabel_R,@TDbEngineErrorDlgNativeLabel_W,'NativeLabel');
    RegisterPropertyHelper(@TDbEngineErrorDlgDbMessageText_R,@TDbEngineErrorDlgDbMessageText_W,'DbMessageText');
    RegisterPropertyHelper(@TDbEngineErrorDlgDbResult_R,@TDbEngineErrorDlgDbResult_W,'DbResult');
    RegisterPropertyHelper(@TDbEngineErrorDlgDbCatSub_R,@TDbEngineErrorDlgDbCatSub_W,'DbCatSub');
    RegisterPropertyHelper(@TDbEngineErrorDlgNativeResult_R,@TDbEngineErrorDlgNativeResult_W,'NativeResult');
    RegisterPropertyHelper(@TDbEngineErrorDlgBackBtn_R,@TDbEngineErrorDlgBackBtn_W,'BackBtn');
    RegisterPropertyHelper(@TDbEngineErrorDlgNextBtn_R,@TDbEngineErrorDlgNextBtn_W,'NextBtn');
    RegisterPropertyHelper(@TDbEngineErrorDlgButtonPanel_R,@TDbEngineErrorDlgButtonPanel_W,'ButtonPanel');
    RegisterPropertyHelper(@TDbEngineErrorDlgDetailsBtn_R,@TDbEngineErrorDlgDetailsBtn_W,'DetailsBtn');
    RegisterPropertyHelper(@TDbEngineErrorDlgOKBtn_R,@TDbEngineErrorDlgOKBtn_W,'OKBtn');
    RegisterPropertyHelper(@TDbEngineErrorDlgIconPanel_R,@TDbEngineErrorDlgIconPanel_W,'IconPanel');
    RegisterPropertyHelper(@TDbEngineErrorDlgIconImage_R,@TDbEngineErrorDlgIconImage_W,'IconImage');
    RegisterPropertyHelper(@TDbEngineErrorDlgTopPanel_R,@TDbEngineErrorDlgTopPanel_W,'TopPanel');
    RegisterPropertyHelper(@TDbEngineErrorDlgErrorText_R,@TDbEngineErrorDlgErrorText_W,'ErrorText');
    RegisterPropertyHelper(@TDbEngineErrorDlgRightPanel_R,@TDbEngineErrorDlgRightPanel_W,'RightPanel');
    RegisterMethod(@TDbEngineErrorDlg.FormShow, 'FormShow');
    RegisterMethod(@TDbEngineErrorDlg.BackClick, 'BackClick');
    RegisterMethod(@TDbEngineErrorDlg.NextClick, 'NextClick');
    RegisterMethod(@TDbEngineErrorDlg.FormCreate, 'FormCreate');
    RegisterMethod(@TDbEngineErrorDlg.DetailsBtnClick, 'DetailsBtnClick');
    RegisterMethod(@TDbEngineErrorDlg.FormDestroy, 'FormDestroy');
    RegisterMethod(@TDbEngineErrorDlg.HookExceptions, 'HookExceptions');
    RegisterMethod(@TDbEngineErrorDlg.ShowException, 'ShowException');
    RegisterPropertyHelper(@TDbEngineErrorDlgDbException_R,@TDbEngineErrorDlgDbException_W,'DbException');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DbExcept(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TDbEngineErrorDlg(CL);
end;

 
 
{ TPSImport_DbExcept }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DbExcept.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DbExcept(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DbExcept.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DbExcept(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
