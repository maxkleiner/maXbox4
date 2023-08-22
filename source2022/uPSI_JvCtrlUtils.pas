unit uPSI_JvCtrlUtils;
{
 JVCL
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
  TPSImport_JvCtrlUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JvCtrlUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvCtrlUtils_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  //,ComCtrls
  ,Menus
  //,Math
  //,JclBase
  //,JclSysUtils
  //,JclStrings
  ,JvCtrlUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCtrlUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCtrlUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function IntToExtended( I : Integer) : Extended');
 //CL.AddDelphiFunction('Procedure JvCreateToolBarMenu( AForm : TForm; AToolBar : TToolBar; AMenu : TMainMenu)');
  //CL.AddTypeS('PJvLVItemStateData', '^TJvLVItemStateData // will not work');
  CL.AddTypeS('TJvLVItemStateData', 'record Caption : string; Data : ___Pointer; F'
   +'ocused : boolean; Selected : Boolean; end');
 //CL.AddDelphiFunction('Procedure JvListViewToStrings( ListView : TListView; Strings : TStrings; SelectedOnly : Boolean; Headers : Boolean)');
 //CL.AddDelphiFunction('Function JvListViewSafeSubItemString( Item : TListItem; SubItemIndex : Integer) : string');
{ CL.AddDelphiFunction('Procedure JvListViewSortClick( Column : TListColumn; AscendingSortImage : Integer; DescendingSortImage : Integer)');
 CL.AddDelphiFunction('Procedure JvListViewCompare( ListView : TListView; Item1, Item2 : TListItem; var Compare : Integer)');
 CL.AddDelphiFunction('Procedure JvListViewSelectAll( ListView : TListView; Deselect : Boolean)');
 CL.AddDelphiFunction('Function JvListViewSaveState( ListView : TListView) : TJvLVItemStateData');
 CL.AddDelphiFunction('Function JvListViewRestoreState( ListView : TListView; Data : TJvLVItemStateData; MakeVisible : Boolean; FocusFirst : Boolean) : Boolean');
 CL.AddDelphiFunction('Function JvListViewGetOrderedColumnIndex( Column : TListColumn) : Integer');
 CL.AddDelphiFunction('Procedure JvListViewSetSystemImageList( ListView : TListView)'); }
 CL.AddDelphiFunction('Function JvMessageBox( const Text, Caption : string; Flags : DWORD) : Integer;');
 CL.AddDelphiFunction('Function JvMessageBox1( const Text : string; Flags : DWORD) : Integer;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function JvMessageBox1_P( const Text : string; Flags : DWORD) : Integer;
Begin Result := JvCtrlUtils.JvMessageBox(Text, Flags); END;

(*----------------------------------------------------------------------------*)
Function JvMessageBox_P( const Text, Caption : string; Flags : DWORD) : Integer;
Begin Result := JvCtrlUtils.JvMessageBox(Text, Caption, Flags); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCtrlUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IntToExtended, 'IntToExtended', cdRegister);
 S.RegisterDelphiFunction(@JvCreateToolBarMenu, 'JvCreateToolBarMenu', cdRegister);
 S.RegisterDelphiFunction(@JvListViewToStrings, 'JvListViewToStrings', cdRegister);
 S.RegisterDelphiFunction(@JvListViewSafeSubItemString, 'JvListViewSafeSubItemString', cdRegister);
 S.RegisterDelphiFunction(@JvListViewSortClick, 'JvListViewSortClick', cdRegister);
 S.RegisterDelphiFunction(@JvListViewCompare, 'JvListViewCompare', cdRegister);
 S.RegisterDelphiFunction(@JvListViewSelectAll, 'JvListViewSelectAll', cdRegister);
 S.RegisterDelphiFunction(@JvListViewSaveState, 'JvListViewSaveState', cdRegister);
 S.RegisterDelphiFunction(@JvListViewRestoreState, 'JvListViewRestoreState', cdRegister);
 S.RegisterDelphiFunction(@JvListViewGetOrderedColumnIndex, 'JvListViewGetOrderedColumnIndex', cdRegister);
 S.RegisterDelphiFunction(@JvListViewSetSystemImageList, 'JvListViewSetSystemImageList', cdRegister);
 S.RegisterDelphiFunction(@JvMessageBox1_P, 'JvMessageBox', cdRegister);
 S.RegisterDelphiFunction(@JvMessageBox_P, 'JvMessageBox1', cdRegister);
end;

 
 
{ TPSImport_JvCtrlUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCtrlUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCtrlUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCtrlUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_JvCtrlUtils(ri);
  RIRegister_JvCtrlUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
