unit uPSI_ExtDlgs;
{
  2 free and one execute method added
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
  TPSImport_ExtDlgs = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSaveTextFileDialog(CL: TPSPascalCompiler);
procedure SIRegister_TOpenTextFileDialog(CL: TPSPascalCompiler);
procedure SIRegister_TSavePictureDialog(CL: TPSPascalCompiler);
procedure SIRegister_TOpenPictureDialog(CL: TPSPascalCompiler);
procedure SIRegister_ExtDlgs(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TSaveTextFileDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOpenTextFileDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSavePictureDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOpenPictureDialog(CL: TPSRuntimeClassImporter);
procedure RIRegister_ExtDlgs(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Windows
  ,Controls
  ,StdCtrls
  ,Graphics
  ,ExtCtrls
  ,Buttons
  ,Dialogs
  ,Consts
  ,ExtDlgs
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ExtDlgs]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSaveTextFileDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenTextFileDialog', 'TSaveTextFileDialog') do
  with CL.AddClassN(CL.FindClass('TOpenTextFileDialog'),'TSaveTextFileDialog') do  begin
    RegisterMethod('Function Execute : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOpenTextFileDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenDialog', 'TOpenTextFileDialog') do
  with CL.AddClassN(CL.FindClass('TOpenDialog'),'TOpenTextFileDialog') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Execute( ParentWnd : HWND) : Boolean');
    RegisterProperty('Encodings', 'TStrings', iptrw);
    RegisterProperty('EncodingIndex', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSavePictureDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenPictureDialog', 'TSavePictureDialog') do
  with CL.AddClassN(CL.FindClass('TOpenPictureDialog'),'TSavePictureDialog') do begin
    RegisterMethod('Function Execute : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOpenPictureDialog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOpenDialog', 'TOpenPictureDialog') do
  with CL.AddClassN(CL.FindClass('TOpenDialog'),'TOpenPictureDialog') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function Execute( ParentWnd : HWND) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ExtDlgs(CL: TPSPascalCompiler);
begin
  SIRegister_TOpenPictureDialog(CL);
  SIRegister_TSavePictureDialog(CL);
  SIRegister_TOpenTextFileDialog(CL);
  SIRegister_TSaveTextFileDialog(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOpenTextFileDialogEncodingIndex_W(Self: TOpenTextFileDialog; const T: Integer);
begin Self.EncodingIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenTextFileDialogEncodingIndex_R(Self: TOpenTextFileDialog; var T: Integer);
begin T := Self.EncodingIndex; end;

(*----------------------------------------------------------------------------*)
procedure TOpenTextFileDialogEncodings_W(Self: TOpenTextFileDialog; const T: TStrings);
begin Self.Encodings := T; end;

(*----------------------------------------------------------------------------*)
procedure TOpenTextFileDialogEncodings_R(Self: TOpenTextFileDialog; var T: TStrings);
begin T := Self.Encodings; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSaveTextFileDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSaveTextFileDialog) do
  begin
    RegisterMethod(@TSaveTextFileDialog.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOpenTextFileDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOpenTextFileDialog) do begin
    RegisterConstructor(@TOpenTextFileDialog.Create, 'Create');
   RegisterMethod(@TOpenTextFileDialog.Destroy, 'Free');
   RegisterMethod(@TOpenTextFileDialog.Execute, 'Execute');
    RegisterPropertyHelper(@TOpenTextFileDialogEncodings_R,@TOpenTextFileDialogEncodings_W,'Encodings');
    RegisterPropertyHelper(@TOpenTextFileDialogEncodingIndex_R,@TOpenTextFileDialogEncodingIndex_W,'EncodingIndex');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSavePictureDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSavePictureDialog) do begin
    RegisterMethod(@TSavePictureDialog.Execute, 'Execute');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOpenPictureDialog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOpenPictureDialog) do
  begin
    RegisterConstructor(@TOpenPictureDialog.Create, 'Create');
    RegisterMethod(@TOpenPictureDialog.Execute, 'Execute');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ExtDlgs(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOpenPictureDialog(CL);
  RIRegister_TSavePictureDialog(CL);
  RIRegister_TOpenTextFileDialog(CL);
  RIRegister_TSaveTextFileDialog(CL);
end;

 
 
{ TPSImport_ExtDlgs }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtDlgs.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ExtDlgs(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtDlgs.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ExtDlgs(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
