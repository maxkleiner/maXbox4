unit uPSI_U_HexView;
{
   a direct hex
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
  TPSImport_U_HexView = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TForm2(CL: TPSPascalCompiler);
procedure SIRegister_U_HexView(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TForm2(CL: TPSRuntimeClassImporter);
procedure RIRegister_U_HexView(CL: TPSRuntimeClassImporter);

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
  ,Buttons
  ,ComCtrls
  ,ExtCtrls
  ,Menus
  ,ShellApi
  ,U_HexView
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_U_HexView]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TForm2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TForm', 'TForm2') do
  with CL.AddClassN(CL.FindClass('TForm'),'THexForm2') do
  begin
    RegisterProperty('Memo1', 'TMemo', iptrw);
    RegisterProperty('OpenBtn', 'TButton', iptrw);
    RegisterProperty('OpenDialog1', 'TOpenDialog', iptrw);
    RegisterProperty('Label1', 'TLabel', iptrw);
    RegisterProperty('StaticText1', 'TStaticText', iptrw);
    RegisterProperty('Memo2', 'TMemo', iptrw);
    RegisterMethod('Procedure FormActivate( Sender : TObject)');
    RegisterMethod('Procedure FormKeyDown( Sender : TObject; var Key : Word; Shift : TShiftState)');
    RegisterMethod('Procedure FormResize( Sender : TObject)');
    RegisterMethod('Procedure FormDeactivate( Sender : TObject)');
    RegisterMethod('Procedure OpenBtnClick( Sender : TObject)');
    RegisterMethod('Procedure StaticText1Click( Sender : TObject)');
    RegisterMethod('Procedure FormCanResize( Sender : TObject; var NewWidth, NewHeight : Integer; var Resize : Boolean)');
    RegisterProperty('browsefilename', 'string', iptrw);
    RegisterProperty('f_in', 'TFileStream', iptrw);
    RegisterProperty('buffer', 'array of byte', iptrw);
    RegisterProperty('buflen', 'integer', iptrw);
    RegisterProperty('bytesread', 'integer', iptrw);
    RegisterProperty('curpage', 'integer', iptrw);
    RegisterProperty('maxpage', 'integer', iptrw);
    RegisterProperty('charsperline', 'integer', iptrw);
    RegisterProperty('list', 'TStringlist', iptrw);
    RegisterMethod('Procedure setupPage');
    RegisterMethod('Procedure showpage');
    RegisterMethod('Procedure resetbrowsefile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_U_HexView(CL: TPSPascalCompiler);
begin
  SIRegister_TForm2(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TForm2list_W(Self: THexForm2; const T: TStringlist);
Begin Self.list := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2list_R(Self: THexForm2; var T: TStringlist);
Begin T := Self.list; end;

(*----------------------------------------------------------------------------*)
procedure TForm2charsperline_W(Self: THexForm2; const T: integer);
Begin Self.charsperline := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2charsperline_R(Self: THexForm2; var T: integer);
Begin T := Self.charsperline; end;

(*----------------------------------------------------------------------------*)
procedure TForm2maxpage_W(Self: THexForm2; const T: integer);
Begin Self.maxpage := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2maxpage_R(Self: THexForm2; var T: integer);
Begin T := Self.maxpage; end;

(*----------------------------------------------------------------------------*)
procedure TForm2curpage_W(Self: THexForm2; const T: integer);
Begin Self.curpage := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2curpage_R(Self: THexForm2; var T: integer);
Begin T := Self.curpage; end;

(*----------------------------------------------------------------------------*)
procedure TForm2bytesread_W(Self: THexForm2; const T: integer);
Begin Self.bytesread := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2bytesread_R(Self: THexForm2; var T: integer);
Begin T := Self.bytesread; end;

(*----------------------------------------------------------------------------*)
procedure TForm2buflen_W(Self: THexForm2; const T: integer);
Begin Self.buflen := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2buflen_R(Self: THexForm2; var T: integer);
Begin T := Self.buflen; end;

(*----------------------------------------------------------------------------*)
procedure TForm2buffer_W(Self: THexForm2; const aT: array of byte);
Begin //Self.buffer:= aT;
end;

(*----------------------------------------------------------------------------*)
procedure TForm2buffer_R(Self: THexForm2; var aT: array of byte);
Begin //aT := Self.buffer;
end;

(*----------------------------------------------------------------------------*)
procedure TForm2f_in_W(Self: THexForm2; const T: TFileStream);
Begin Self.f_in := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2f_in_R(Self: THexForm2; var T: TFileStream);
Begin T := Self.f_in; end;

(*----------------------------------------------------------------------------*)
procedure TForm2browsefilename_W(Self: THexForm2; const T: string);
Begin Self.browsefilename := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2browsefilename_R(Self: THexForm2; var T: string);
Begin T := Self.browsefilename; end;

(*----------------------------------------------------------------------------*)
procedure TForm2Memo2_W(Self: THexForm2; const T: TMemo);
Begin Self.Memo2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2Memo2_R(Self: THexForm2; var T: TMemo);
Begin T := Self.Memo2; end;

(*----------------------------------------------------------------------------*)
procedure TForm2StaticText1_W(Self: THexForm2; const T: TStaticText);
Begin Self.StaticText1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2StaticText1_R(Self: THexForm2; var T: TStaticText);
Begin T := Self.StaticText1; end;

(*----------------------------------------------------------------------------*)
procedure TForm2Label1_W(Self: THexForm2; const T: TLabel);
Begin Self.Label1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2Label1_R(Self: THexForm2; var T: TLabel);
Begin T := Self.Label1; end;

(*----------------------------------------------------------------------------*)
procedure TForm2OpenDialog1_W(Self: THexForm2; const T: TOpenDialog);
Begin Self.OpenDialog1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2OpenDialog1_R(Self: THexForm2; var T: TOpenDialog);
Begin T := Self.OpenDialog1; end;

(*----------------------------------------------------------------------------*)
procedure TForm2OpenBtn_W(Self: THexForm2; const T: TButton);
Begin Self.OpenBtn := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2OpenBtn_R(Self: THexForm2; var T: TButton);
Begin T := Self.OpenBtn; end;

(*----------------------------------------------------------------------------*)
procedure TForm2Memo1_W(Self: THexForm2; const T: TMemo);
Begin Self.Memo1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TForm2Memo1_R(Self: THexForm2; var T: TMemo);
Begin T := Self.Memo1; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TForm2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THexForm2) do
  begin
    RegisterPropertyHelper(@TForm2Memo1_R,@TForm2Memo1_W,'Memo1');
    RegisterPropertyHelper(@TForm2OpenBtn_R,@TForm2OpenBtn_W,'OpenBtn');
    RegisterPropertyHelper(@TForm2OpenDialog1_R,@TForm2OpenDialog1_W,'OpenDialog1');
    RegisterPropertyHelper(@TForm2Label1_R,@TForm2Label1_W,'Label1');
    RegisterPropertyHelper(@TForm2StaticText1_R,@TForm2StaticText1_W,'StaticText1');
    RegisterPropertyHelper(@TForm2Memo2_R,@TForm2Memo2_W,'Memo2');
    RegisterMethod(@THexForm2.FormActivate, 'FormActivate');
    RegisterMethod(@THexForm2.FormKeyDown, 'FormKeyDown');
    RegisterMethod(@THexForm2.FormResize, 'FormResize');
    RegisterMethod(@THexForm2.FormDeactivate, 'FormDeactivate');
    RegisterMethod(@THexForm2.OpenBtnClick, 'OpenBtnClick');
    RegisterMethod(@THexForm2.StaticText1Click, 'StaticText1Click');
    RegisterMethod(@THexForm2.FormCanResize, 'FormCanResize');
    RegisterPropertyHelper(@TForm2browsefilename_R,@TForm2browsefilename_W,'browsefilename');
    RegisterPropertyHelper(@TForm2f_in_R,@TForm2f_in_W,'f_in');
    RegisterPropertyHelper(@TForm2buffer_R,@TForm2buffer_W,'buffer');
    RegisterPropertyHelper(@TForm2buflen_R,@TForm2buflen_W,'buflen');
    RegisterPropertyHelper(@TForm2bytesread_R,@TForm2bytesread_W,'bytesread');
    RegisterPropertyHelper(@TForm2curpage_R,@TForm2curpage_W,'curpage');
    RegisterPropertyHelper(@TForm2maxpage_R,@TForm2maxpage_W,'maxpage');
    RegisterPropertyHelper(@TForm2charsperline_R,@TForm2charsperline_W,'charsperline');
    RegisterPropertyHelper(@TForm2list_R,@TForm2list_W,'list');
    RegisterMethod(@THexForm2.setupPage, 'setupPage');
    RegisterMethod(@THexForm2.showpage, 'showpage');
    RegisterMethod(@THexForm2.resetbrowsefile, 'resetbrowsefile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_U_HexView(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TForm2(CL);
end;

 
 
{ TPSImport_U_HexView }
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_HexView.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_U_HexView(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_HexView.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_U_HexView(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
