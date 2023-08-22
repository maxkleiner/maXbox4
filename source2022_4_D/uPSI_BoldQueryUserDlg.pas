unit uPSI_BoldQueryUserDlg;
{
  just dialog
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
  TPSImport_BoldQueryUserDlg = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TfrmBoldQueryUser(CL: TPSPascalCompiler);
procedure SIRegister_BoldQueryUserDlg(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BoldQueryUserDlg_Routines(S: TPSExec);
procedure RIRegister_TfrmBoldQueryUser(CL: TPSRuntimeClassImporter);
procedure RIRegister_BoldQueryUserDlg(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Controls
  ,Forms
  ,Dialogs
  ,Graphics
  ,StdCtrls
  ,BoldQueryUserDlg
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BoldQueryUserDlg]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TfrmBoldQueryUser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TfrmBoldQueryUser') do
  with CL.AddClassN(CL.FindClass('TForm'),'TfrmBoldQueryUser') do begin
    RegisterProperty('cmdYesAll', 'TButton', iptrw);
    RegisterProperty('cmdYes', 'TButton', iptrw);
    RegisterProperty('cmdNo', 'TButton', iptrw);
    RegisterProperty('cmdNoAll', 'TButton', iptrw);
    RegisterProperty('lblQuestion', 'TLabel', iptrw);
    RegisterMethod('Procedure cmdYesAllClick( Sender : TObject)');
    RegisterMethod('Procedure cmdYesClick( Sender : TObject)');
    RegisterMethod('Procedure cmdNoClick( Sender : TObject)');
    RegisterMethod('Procedure cmdNoAllClick( Sender : TObject)');
    RegisterProperty('QueryResult', 'TBoldQueryResult', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BoldQueryUserDlg(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TBoldQueryResult', '( qrYesAll, qrYes, qrNo, qrNoAll )');
  SIRegister_TfrmBoldQueryUser(CL);
 CL.AddDelphiFunction('Function QueryUser( const Title, Query : string) : TBoldQueryResult');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUserQueryResult_R(Self: TfrmBoldQueryUser; var T: TBoldQueryResult);
begin T := Self.QueryResult; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUserlblQuestion_W(Self: TfrmBoldQueryUser; const T: TLabel);
Begin Self.lblQuestion := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUserlblQuestion_R(Self: TfrmBoldQueryUser; var T: TLabel);
Begin T := Self.lblQuestion; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUsercmdNoAll_W(Self: TfrmBoldQueryUser; const T: TButton);
Begin Self.cmdNoAll := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUsercmdNoAll_R(Self: TfrmBoldQueryUser; var T: TButton);
Begin T := Self.cmdNoAll; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUsercmdNo_W(Self: TfrmBoldQueryUser; const T: TButton);
Begin Self.cmdNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUsercmdNo_R(Self: TfrmBoldQueryUser; var T: TButton);
Begin T := Self.cmdNo; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUsercmdYes_W(Self: TfrmBoldQueryUser; const T: TButton);
Begin Self.cmdYes := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUsercmdYes_R(Self: TfrmBoldQueryUser; var T: TButton);
Begin T := Self.cmdYes; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUsercmdYesAll_W(Self: TfrmBoldQueryUser; const T: TButton);
Begin Self.cmdYesAll := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmBoldQueryUsercmdYesAll_R(Self: TfrmBoldQueryUser; var T: TButton);
Begin T := Self.cmdYesAll; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldQueryUserDlg_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@QueryUser, 'QueryUser', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TfrmBoldQueryUser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TfrmBoldQueryUser) do
  begin
    RegisterPropertyHelper(@TfrmBoldQueryUsercmdYesAll_R,@TfrmBoldQueryUsercmdYesAll_W,'cmdYesAll');
    RegisterPropertyHelper(@TfrmBoldQueryUsercmdYes_R,@TfrmBoldQueryUsercmdYes_W,'cmdYes');
    RegisterPropertyHelper(@TfrmBoldQueryUsercmdNo_R,@TfrmBoldQueryUsercmdNo_W,'cmdNo');
    RegisterPropertyHelper(@TfrmBoldQueryUsercmdNoAll_R,@TfrmBoldQueryUsercmdNoAll_W,'cmdNoAll');
    RegisterPropertyHelper(@TfrmBoldQueryUserlblQuestion_R,@TfrmBoldQueryUserlblQuestion_W,'lblQuestion');
    RegisterMethod(@TfrmBoldQueryUser.cmdYesAllClick, 'cmdYesAllClick');
    RegisterMethod(@TfrmBoldQueryUser.cmdYesClick, 'cmdYesClick');
    RegisterMethod(@TfrmBoldQueryUser.cmdNoClick, 'cmdNoClick');
    RegisterMethod(@TfrmBoldQueryUser.cmdNoAllClick, 'cmdNoAllClick');
    RegisterPropertyHelper(@TfrmBoldQueryUserQueryResult_R,nil,'QueryResult');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BoldQueryUserDlg(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TfrmBoldQueryUser(CL);
end;

 
 
{ TPSImport_BoldQueryUserDlg }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldQueryUserDlg.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BoldQueryUserDlg(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BoldQueryUserDlg.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BoldQueryUserDlg(ri);
  RIRegister_BoldQueryUserDlg_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
