unit uPSI_Clipbrd;
{
  runtime support 
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
  TPSImport_Clipbrd = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TClipboard(CL: TPSPascalCompiler);
procedure SIRegister_Clipbrd(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Clipbrd_Routines(S: TPSExec);
procedure RIRegister_TClipboard(CL: TPSRuntimeClassImporter);
procedure RIRegister_Clipbrd(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //WinUtils
  Windows
  ,Messages
  ,Graphics
  ,Clipbrd
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Clipbrd]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TClipboard(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TClipboard') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TClipboard') do begin
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure Assign(Source: TPersistent)');
    RegisterMethod('Procedure Close');
    RegisterMethod('Function GetComponent( Owner, Parent : TComponent) : TComponent');
    RegisterMethod('Function GetAsHandle( Format : Word) : THandle');
    RegisterMethod('Function GetTextBuf( Buffer : PChar; BufSize : Integer) : Integer');
    RegisterMethod('Function HasFormat( Format : Word) : Boolean');
    RegisterMethod('Procedure Open');
    RegisterMethod('Procedure SetComponent( Component : TComponent)');
    RegisterMethod('Procedure SetAsHandle( Format : Word; Value : THandle)');
    RegisterMethod('Procedure SetTextBuf( Buffer : PChar)');
    RegisterProperty('AsText', 'string', iptrw);
    RegisterProperty('FormatCount', 'Integer', iptr);
    RegisterProperty('Formats', 'Word Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Clipbrd(CL: TPSPascalCompiler);
begin
  SIRegister_TClipboard(CL);
 CL.AddDelphiFunction('Function Clipboard : TClipboard');
 CL.AddDelphiFunction('Function SetClipboard( NewClipboard : TClipboard) : TClipboard');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TClipboardFormats_R(Self: TClipboard; var T: Word; const t1: Integer);
begin T := Self.Formats[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TClipboardFormatCount_R(Self: TClipboard; var T: Integer);
begin T := Self.FormatCount; end;

(*----------------------------------------------------------------------------*)
procedure TClipboardAsText_W(Self: TClipboard; const T: string);
begin Self.AsText := T; end;

(*----------------------------------------------------------------------------*)
procedure TClipboardAsText_R(Self: TClipboard; var T: string);
begin T := Self.AsText; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Clipbrd_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Clipboard, 'Clipboard', cdRegister);
 S.RegisterDelphiFunction(@SetClipboard, 'SetClipboard', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TClipboard(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TClipboard) do begin
    RegisterVirtualMethod(@TClipboard.Clear, 'Clear');
    RegisterMethod(@TClipboard.Destroy, 'Free');
    RegisterVirtualMethod(@TClipboard.Assign, 'Assign');
    RegisterVirtualMethod(@TClipboard.Close, 'Close');
    RegisterMethod(@TClipboard.GetComponent, 'GetComponent');
    RegisterMethod(@TClipboard.GetAsHandle, 'GetAsHandle');
    RegisterMethod(@TClipboard.GetTextBuf, 'GetTextBuf');
    RegisterMethod(@TClipboard.HasFormat, 'HasFormat');
    RegisterVirtualMethod(@TClipboard.Open, 'Open');
    RegisterMethod(@TClipboard.SetComponent, 'SetComponent');
    RegisterMethod(@TClipboard.SetAsHandle, 'SetAsHandle');
    RegisterMethod(@TClipboard.SetTextBuf, 'SetTextBuf');
    RegisterPropertyHelper(@TClipboardAsText_R,@TClipboardAsText_W,'AsText');
    RegisterPropertyHelper(@TClipboardFormatCount_R,nil,'FormatCount');
    RegisterPropertyHelper(@TClipboardFormats_R,nil,'Formats');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Clipbrd(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TClipboard(CL);
end;

 
 
{ TPSImport_Clipbrd }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Clipbrd.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Clipbrd(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Clipbrd.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Clipbrd(ri);
  RIRegister_Clipbrd_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
