unit uPSI_KMessageBox;
{
kleiner box

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
  TPSImport_KMessageBox = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_KMessageBox(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_KMessageBox_Routines(S: TPSExec);

procedure Register;

implementation


uses
   {LCLType
  ,LCLIntf
  ,LMessages
  ,LCLProc
  ,LResources}
  Windows
  ,Messages
  ,Controls
  ,Forms
  ,KFunctions
  //,KEdits
  ,Themes
  ,UxTheme
  ,KMessageBox
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_KMessageBox]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_KMessageBox(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ACCESS_STICKYKEYS','LongWord').SetUInt( $0001);
 CL.AddConstantN('ACCESS_FILTERKEYS','LongWord').SetUInt( $0002);
 CL.AddConstantN('ACCESS_MOUSEKEYS','LongWord').SetUInt( $0003);
 CL.AddConstantN('KEY_WRITE','LongWord').SetUInt( $20006);
  CL.AddConstantN('IDANI_OPEN','LongInt').SetInt( 1);
 CL.AddConstantN('IDANI_CLOSE','LongInt').SetInt( 2);
 CL.AddConstantN('IDANI_CAPTION','LongInt').SetInt( 3);
   CL.AddTypeS('TPosProc','function(const Substr, S: string): Integer)');
    CL.AddTypeS('TKMsgBoxButton', '( mbYes, mbNo, mbOK, mbCancel, mbClose, mbAbor'
   +'t, mbRetry, mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp )');
  CL.AddTypeS('TKMsgBoxIcon', '( miNone, miInformation, miQuestion, miWarning, miStop )');
 //CL.AddDelphiFunction('Function CreateMsgBox( const Caption, Text : string; const Buttons : array of TKMsgBoxButton; Icon : TKMsgBoxIcon; Def : integer) : TForm');
 CL.AddDelphiFunction('Function CreateMsgBoxEx( const Caption, Text : string; const Btns : array of string; Icon : TKMsgBoxIcon; Def : integer) : TForm');
 CL.AddDelphiFunction('Procedure FreeMsgBox( AMsgBox : TCustomForm)');
 //CL.AddDelphiFunction('Function KMsgBox( const Caption, Text : string; const Buttons : array of TKMsgBoxButton; Icon : TKMsgBoxIcon; Def : integer) : integer');
 CL.AddDelphiFunction('Function KMsgBoxEx( const Caption, Text : string; const Buttons : array of string; Icon : TKMsgBoxIcon; Def : integer) : integer');
 CL.AddDelphiFunction('Function KInputBox( const Caption, Prompt : string; var Text : string) : TModalResult');
 //CL.AddDelphiFunction('Function KNumberInputBox( const ACaption, APrompt : string; var AValue : double; AMin, AMax : double; AFormats : TKNumberEditAcceptedFormats) : TModalResult');
  CL.AddTypeS('TKMsgBoxButtons', '( mbAbortRetryIgnore, mbOkOnly, mbOkCancel, mbRetryCancel, mbYesNo, mbYesNoCancel )');
 CL.AddDelphiFunction('Function MsgBox2( const Caption, Text : string; const Buttons : TKMsgBoxButtons; Icon : TKMsgBoxIcon) : integer');
 CL.AddDelphiFunction('Function AppMsgBox( const Caption, Text : string; Flags : integer) : integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_KMessageBox_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@CreateMsgBox, 'CreateMsgBox', cdRegister);
 S.RegisterDelphiFunction(@CreateMsgBoxEx, 'CreateMsgBoxEx', cdRegister);
 S.RegisterDelphiFunction(@FreeMsgBox, 'FreeMsgBox', cdRegister);
 //S.RegisterDelphiFunction(@KMsgBox, 'KMsgBox', cdRegister);
 S.RegisterDelphiFunction(@KMsgBoxEx, 'KMsgBoxEx', cdRegister);
 S.RegisterDelphiFunction(@KInputBox, 'KInputBox', cdRegister);
 //S.RegisterDelphiFunction(@KNumberInputBox, 'KNumberInputBox', cdRegister);
 S.RegisterDelphiFunction(@MsgBox, 'MsgBox2', cdRegister);
 S.RegisterDelphiFunction(@AppMsgBox, 'AppMsgBox', cdRegister);
end;



{ TPSImport_KMessageBox }
(*----------------------------------------------------------------------------*)
procedure TPSImport_KMessageBox.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_KMessageBox(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_KMessageBox.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_KMessageBox_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
