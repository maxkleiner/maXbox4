unit uPSI_HList;
{
   warken
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
  TPSImport_HList = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_THistoryCombo(CL: TPSPascalCompiler);
procedure SIRegister_THistoryList(CL: TPSPascalCompiler);
procedure SIRegister_HList(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_HList_Routines(S: TPSExec);
procedure RIRegister_THistoryCombo(CL: TPSRuntimeClassImporter);
procedure RIRegister_THistoryList(CL: TPSRuntimeClassImporter);
procedure RIRegister_HList(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   WinTypes
  ,WinProcs
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,StdCtrls
  ,Registry
  ,IniFiles
  ,Menus
  ,HList
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HList]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THistoryCombo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComboBox', 'THistoryCombo') do
  with CL.AddClassN(CL.FindClass('TComboBox'),'THistoryCombo') do
  begin
    RegisterProperty('HistoryList', 'THistoryList', iptr);
    RegisterMethod('Procedure UpdateList');
    RegisterProperty('RegistryPath', 'string', iptrw);
    RegisterProperty('IniFileName', 'string', iptrw);
    RegisterProperty('IniSection', 'string', iptrw);
    RegisterProperty('ManualUpdate', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_THistoryList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'THistoryList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'THistoryList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
     RegisterProperty('MaxLen', 'integer', iptrw);
    RegisterMethod('Procedure AddString( s : string)');
    RegisterMethod('Procedure SaveToIni( IniName, IniSection : string)');
    RegisterMethod('Procedure LoadFromIni( IniName, IniSection : string)');
    RegisterProperty('MenuItem', 'TMenuItem', iptrw);
    RegisterProperty('Menu', 'TMenuItem', iptrw);
    RegisterProperty('OnAutoItemClick', 'TListMenuEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HList(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TListMenuEvent', 'Procedure ( Sender : TObject; MenuText : string)');
  SIRegister_THistoryList(CL);
  SIRegister_THistoryCombo(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THistoryComboManualUpdate_W(Self: THistoryCombo; const T: boolean);
begin Self.ManualUpdate := T; end;

(*----------------------------------------------------------------------------*)
procedure THistoryComboManualUpdate_R(Self: THistoryCombo; var T: boolean);
begin T := Self.ManualUpdate; end;

(*----------------------------------------------------------------------------*)
procedure THistoryComboIniSection_W(Self: THistoryCombo; const T: string);
begin Self.IniSection := T; end;

(*----------------------------------------------------------------------------*)
procedure THistoryComboIniSection_R(Self: THistoryCombo; var T: string);
begin T := Self.IniSection; end;

(*----------------------------------------------------------------------------*)
procedure THistoryComboIniFileName_W(Self: THistoryCombo; const T: string);
begin Self.IniFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure THistoryComboIniFileName_R(Self: THistoryCombo; var T: string);
begin T := Self.IniFileName; end;

(*----------------------------------------------------------------------------*)
procedure THistoryComboRegistryPath_W(Self: THistoryCombo; const T: string);
begin Self.RegistryPath := T; end;

(*----------------------------------------------------------------------------*)
procedure THistoryComboRegistryPath_R(Self: THistoryCombo; var T: string);
begin T := Self.RegistryPath; end;

(*----------------------------------------------------------------------------*)
procedure THistoryComboHistoryList_R(Self: THistoryCombo; var T: THistoryList);
begin T := Self.HistoryList; end;

(*----------------------------------------------------------------------------*)
procedure THistoryListOnAutoItemClick_W(Self: THistoryList; const T: TListMenuEvent);
begin Self.OnAutoItemClick := T; end;

(*----------------------------------------------------------------------------*)
procedure THistoryListOnAutoItemClick_R(Self: THistoryList; var T: TListMenuEvent);
begin T := Self.OnAutoItemClick; end;

(*----------------------------------------------------------------------------*)
procedure THistoryListMenu_W(Self: THistoryList; const T: TMenuItem);
begin Self.Menu := T; end;

(*----------------------------------------------------------------------------*)
procedure THistoryListMenu_R(Self: THistoryList; var T: TMenuItem);
begin T := Self.Menu; end;

(*----------------------------------------------------------------------------*)
procedure THistoryListMenuItem_W(Self: THistoryList; const T: TMenuItem);
begin Self.MenuItem := T; end;

(*----------------------------------------------------------------------------*)
procedure THistoryListMenuItem_R(Self: THistoryList; var T: TMenuItem);
begin T := Self.MenuItem; end;

(*----------------------------------------------------------------------------*)
procedure THistoryListMaxLen_W(Self: THistoryList; const T: integer);
begin Self.MaxLen := T; end;

(*----------------------------------------------------------------------------*)
procedure THistoryListMaxLen_R(Self: THistoryList; var T: integer);
begin T := Self.MaxLen; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HList_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THistoryCombo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THistoryCombo) do
  begin
    RegisterPropertyHelper(@THistoryComboHistoryList_R,nil,'HistoryList');
    RegisterMethod(@THistoryCombo.UpdateList, 'UpdateList');
    RegisterPropertyHelper(@THistoryComboRegistryPath_R,@THistoryComboRegistryPath_W,'RegistryPath');
    RegisterPropertyHelper(@THistoryComboIniFileName_R,@THistoryComboIniFileName_W,'IniFileName');
    RegisterPropertyHelper(@THistoryComboIniSection_R,@THistoryComboIniSection_W,'IniSection');
    RegisterPropertyHelper(@THistoryComboManualUpdate_R,@THistoryComboManualUpdate_W,'ManualUpdate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THistoryList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THistoryList) do begin
    RegisterConstructor(@THistoryList.Create, 'Create');
      RegisterMethod(@THistoryList.Destroy, 'Free');
       RegisterPropertyHelper(@THistoryListMaxLen_R,@THistoryListMaxLen_W,'MaxLen');
    RegisterMethod(@THistoryList.AddString, 'AddString');
    RegisterMethod(@THistoryList.SaveToIni, 'SaveToIni');
    RegisterMethod(@THistoryList.LoadFromIni, 'LoadFromIni');
    RegisterPropertyHelper(@THistoryListMenuItem_R,@THistoryListMenuItem_W,'MenuItem');
    RegisterPropertyHelper(@THistoryListMenu_R,@THistoryListMenu_W,'Menu');
    RegisterPropertyHelper(@THistoryListOnAutoItemClick_R,@THistoryListOnAutoItemClick_W,'OnAutoItemClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HList(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THistoryList(CL);
  RIRegister_THistoryCombo(CL);
end;

 
 
{ TPSImport_HList }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HList.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HList(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HList.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HList(ri);
  RIRegister_HList_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
