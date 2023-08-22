unit uPSI_MakeApp;
{
  pvket for android
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
  TPSImport_MakeApp = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_MakeApp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_MakeApp_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,MakeApp
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MakeApp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_MakeApp(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('aZero','LongInt').SetInt( 0);
 CL.AddConstantN('makeappDEF','LongInt').SetInt( - 1);
  CL.AddConstantN('CS_VREDRAW','LongInt').SetInt( DWORD ( 1 ));
 CL.AddConstantN('CS_HREDRAW','LongInt').SetInt( DWORD ( 2 ));
 CL.AddConstantN('CS_KEYCVTWINDOW','LongInt').SetInt( 4);
 CL.AddConstantN('CS_DBLCLKS','LongInt').SetInt( 8);
 CL.AddConstantN('CS_OWNDC','LongWord').SetUInt( $20);
 CL.AddConstantN('CS_CLASSDC','LongWord').SetUInt( $40);
 CL.AddConstantN('CS_PARENTDC','LongWord').SetUInt( $80);
 CL.AddConstantN('CS_NOKEYCVT','LongWord').SetUInt( $100);
 CL.AddConstantN('CS_NOCLOSE','LongWord').SetUInt( $200);
 CL.AddConstantN('CS_SAVEBITS','LongWord').SetUInt( $800);
 CL.AddConstantN('CS_BYTEALIGNCLIENT','LongWord').SetUInt( $1000);
 CL.AddConstantN('CS_BYTEALIGNWINDOW','LongWord').SetUInt( $2000);
 CL.AddConstantN('CS_GLOBALCLASS','LongWord').SetUInt( $4000);
 CL.AddConstantN('CS_IME','LongWord').SetUInt( $10000);
 CL.AddConstantN('CS_DROPSHADOW','LongWord').SetUInt( $20000);
  //CL.AddTypeS('PPanelFunc', '^TPanelFunc // will not work');
 CL.AddTypeS('TPanelFunc', 'function(iMsg, wParam, lParam: Integer): Integer)'); // will not work');

 CL.AddTypeS('TMessagefunc','function(hWnd,iMsg,wParam,lParam:Integer):Integer)');

 //   TPanelFunc = function(iMsg, wParam, lParam: Integer): Integer;

  CL.AddTypeS('TPanelStyle', '(psEdge, psTabEdge, psBorder, psTabBorder, psTab, psNone )');
  CL.AddTypeS('TFontLook', '( flBold, flItalic, flUnderLine, flStrikeOut )');
  CL.AddTypeS('TFontLooks', 'set of TFontLook');
 CL.AddDelphiFunction('Function SetWinClass( const ClassName : String; pMessFunc : Tmessagefunc; wcStyle : Integer) : Word');
 CL.AddDelphiFunction('Function SetWinClassO( const ClassName : String; pMessFunc : TObject; wcStyle : Integer) : Word');

 CL.AddDelphiFunction('Function MakeForm( Left, Top, Width, Height : Integer; const Caption : String; WinStyle : Integer) : Integer');
 CL.AddDelphiFunction('Procedure RunMsgLoop( Show : Boolean)');
 CL.AddDelphiFunction('Function MakeFont( Height, Width : Integer; const FontName : String; Look : TFontLooks; Roman : Boolean) : Integer');
 CL.AddDelphiFunction('Function MakeButton( Left, Top, Width, Height : Integer; pCaption : PChar; hParent, ID_Number : Cardinal; hFont : Integer) : Integer');
 CL.AddDelphiFunction('Function MakeListBox( Left, Top, Width, Height, Parent : Integer; const ListItems : String; WinStyle : Integer) : Integer');
 CL.AddDelphiFunction('Function MakeComboBox( Left, Top, Width, Height, Parent : Integer; const ListItems : String; WinStyle : Integer) : Integer');
 CL.AddDelphiFunction('Function MakePanel( Left, Top, Width, Height, hParent : Integer; WndFunc : TPanelFunc; ID_Number : Cardinal; Style : TPanelStyle) : Integer');
 CL.AddDelphiFunction('Function MakeSubMenu( const ItemList : String; ID1, ID2 : Cardinal; hMenu : Integer) : Integer');
 CL.AddDelphiFunction('Function id4menu( a, b : Byte; c : Byte; d : Byte) : Cardinal');
 CL.AddDelphiFunction('Procedure DoInitMakeApp');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_MakeApp_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@SetWinClass, 'SetWinClass', cdRegister);
 S.RegisterDelphiFunction(@SetWinClass, 'SetWinClassO', cdRegister);
 S.RegisterDelphiFunction(@MakeForm, 'MakeForm', cdRegister);
 S.RegisterDelphiFunction(@RunMsgLoop, 'RunMsgLoop', cdRegister);
 S.RegisterDelphiFunction(@MakeFont, 'MakeFont', cdRegister);
 S.RegisterDelphiFunction(@MakeButton, 'MakeButton', cdRegister);
 S.RegisterDelphiFunction(@MakeListBox, 'MakeListBox', cdRegister);
 S.RegisterDelphiFunction(@MakeComboBox, 'MakeComboBox', cdRegister);
 S.RegisterDelphiFunction(@MakePanel, 'MakePanel', cdRegister);
 S.RegisterDelphiFunction(@MakeSubMenu, 'MakeSubMenu', cdRegister);
 S.RegisterDelphiFunction(@id4menu, 'id4menu', cdRegister);
  S.RegisterDelphiFunction(@DoInitMakeApp, 'DoInitMakeApp', cdRegister);

 end;

 
 
{ TPSImport_MakeApp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MakeApp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MakeApp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MakeApp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_MakeApp(ri);
  RIRegister_MakeApp_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
