unit uPSI_Debug;
{
   richedit debug
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
  TPSImport_Debug = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TfrmDebug(CL: TPSPascalCompiler);
procedure SIRegister_Debug(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TfrmDebug(CL: TPSRuntimeClassImporter);
procedure RIRegister_Debug(CL: TPSRuntimeClassImporter);

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
  ,ComCtrls
  ,Debug
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Debug]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TfrmDebug(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TfrmDebug') do
  with CL.AddClassN(CL.FindClass('TForm'),'TfrmDebug') do begin
    RegisterProperty('RichEdit1', 'TRichEdit', iptrw);
    RegisterMethod('Procedure FormClose( Sender : TObject; var Action : TCloseAction)');
    RegisterMethod('Procedure FormCreate( Sender : TObject)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Debug(CL: TPSPascalCompiler);
begin
  SIRegister_TfrmDebug(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TfrmDebugRichEdit1_W(Self: TfrmDebug; const T: TRichEdit);
Begin Self.RichEdit1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TfrmDebugRichEdit1_R(Self: TfrmDebug; var T: TRichEdit);
Begin T := Self.RichEdit1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TfrmDebug(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TfrmDebug) do begin
    RegisterPropertyHelper(@TfrmDebugRichEdit1_R,@TfrmDebugRichEdit1_W,'RichEdit1');
    RegisterMethod(@TfrmDebug.FormClose, 'FormClose');
    RegisterMethod(@TfrmDebug.FormCreate, 'FormCreate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Debug(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TfrmDebug(CL);
end;

 
 
{ TPSImport_Debug }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Debug.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Debug(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Debug.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Debug(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
