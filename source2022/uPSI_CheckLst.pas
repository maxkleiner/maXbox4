unit uPSI_CheckLst;
{
       with free    add itemheight, columns etc.
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
  TPSImport_CheckLst = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCheckListBox(CL: TPSPascalCompiler);
procedure SIRegister_CheckLst(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TCheckListBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_CheckLst(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,StdCtrls
  ,CheckLst
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CheckLst]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCheckListBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomListBox', 'TCheckListBox') do
  with CL.AddClassN(CL.FindClass('TCustomListBox'),'TCheckListBox') do begin
   RegisterMethod('Procedure Free');
     RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Checked', 'Boolean Integer', iptrw);
    RegisterProperty('ItemEnabled', 'Boolean Integer', iptrw);
    RegisterProperty('State', 'TCheckBoxState Integer', iptrw);
    RegisterProperty('Header', 'Boolean Integer', iptrw);
    RegisterProperty('OnClickCheck', 'TNotifyEvent', iptrw);
    RegisterProperty('AllowGrayed', 'Boolean', iptrw);
    RegisterProperty('Flat', 'Boolean', iptrw);
    RegisterProperty('HeaderColor', 'TColor', iptrw);
    RegisterProperty('HeaderBackgroundColor', 'TColor', iptrw);
    RegisterPublishedProperties;
    RegisterProperty('ItemHeight', 'Integer', iptrw);
    RegisterProperty('IntegralHeight', 'Boolean', iptrw);
    RegisterProperty('SORTED', 'Boolean', iptrw);
    RegisterProperty('STYLE', 'TListBoxStyle', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('AutoComplete', 'Boolean', iptrw);
    RegisterProperty('Columns', 'Integer', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('ONCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONDBLCLICK', 'TNotifyEvent', iptrw);
    RegisterProperty('ONENTER', 'TNotifyEvent', iptrw);
    RegisterProperty('ONEXIT', 'TNotifyEvent', iptrw);
    RegisterProperty('ONKEYDOWN', 'TKeyEvent', iptrw);
    RegisterProperty('ONKEYPRESS', 'TKeyPressEvent', iptrw);
    RegisterProperty('ONKEYUP', 'TKeyEvent', iptrw);
     RegisterProperty('PARENTCTL3D', 'Boolean', iptrw);
    RegisterProperty('PARENTSHOWHINT', 'Boolean', iptrw);
    RegisterProperty('POPUPMENU', 'TPopupMenu', iptrw);
    RegisterProperty('TABWIDTH', 'Integer', iptrw);
    RegisterProperty('ONDRAGDROP', 'TDragDropEvent', iptrw);
    RegisterProperty('ONDRAGOVER', 'TDragOverEvent', iptrw);
    RegisterProperty('ONDRAWITEM', 'TDrawItemEvent', iptrw);
    RegisterProperty('ONENDDRAG', 'TEndDragEvent', iptrw);
    RegisterProperty('ONMEASUREITEM', 'TMeasureItemEvent', iptrw);
    RegisterProperty('ONMOUSEDOWN', 'TMouseEvent', iptrw);
    RegisterProperty('ONMOUSEMOVE', 'TMouseMoveEvent', iptrw);
    RegisterProperty('ONMOUSEUP', 'TMouseEvent', iptrw);
    RegisterProperty('ONSTARTDRAG', 'TStartDragEvent', iptrw);
    RegisterProperty('OnData', 'TLBGetDataEvent', iptrw);
    RegisterProperty('OnDataFind', 'TLBFindDataEvent', iptrw);
    //RegisterProperty('OnData', 'TLVOwnerDataEvent', iptrw);
   //RegisterProperty('OnDataFind', 'TLVOwnerDataEvent', iptrw);
    //property OnData;
    //property OnDataFind;
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CheckLst(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('TLBGetDataEvent', 'procedure(Control: TWinControl; Index: Integer; var Data: string)');
   //CL.AddTypeS('TLBFindDataEvent', 'function(Control: TWinControl; FindString: string): Integer)');
  //TLBFindDataEvent = function(Control: TWinControl; FindString: string): Integer of object;
  SIRegister_TCheckListBox(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCheckListBoxHeaderBackgroundColor_W(Self: TCheckListBox; const T: TColor);
begin Self.HeaderBackgroundColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxHeaderBackgroundColor_R(Self: TCheckListBox; var T: TColor);
begin T := Self.HeaderBackgroundColor; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxHeaderColor_W(Self: TCheckListBox; const T: TColor);
begin Self.HeaderColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxHeaderColor_R(Self: TCheckListBox; var T: TColor);
begin T := Self.HeaderColor; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxFlat_W(Self: TCheckListBox; const T: Boolean);
begin Self.Flat := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxFlat_R(Self: TCheckListBox; var T: Boolean);
begin T := Self.Flat; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxAllowGrayed_W(Self: TCheckListBox; const T: Boolean);
begin Self.AllowGrayed := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxAllowGrayed_R(Self: TCheckListBox; var T: Boolean);
begin T := Self.AllowGrayed; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxOnClickCheck_W(Self: TCheckListBox; const T: TNotifyEvent);
begin Self.OnClickCheck := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxOnClickCheck_R(Self: TCheckListBox; var T: TNotifyEvent);
begin T := Self.OnClickCheck; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxHeader_W(Self: TCheckListBox; const T: Boolean; const t1: Integer);
begin Self.Header[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxHeader_R(Self: TCheckListBox; var T: Boolean; const t1: Integer);
begin T := Self.Header[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxState_W(Self: TCheckListBox; const T: TCheckBoxState; const t1: Integer);
begin Self.State[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxState_R(Self: TCheckListBox; var T: TCheckBoxState; const t1: Integer);
begin T := Self.State[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxItemEnabled_W(Self: TCheckListBox; const T: Boolean; const t1: Integer);
begin Self.ItemEnabled[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxItemEnabled_R(Self: TCheckListBox; var T: Boolean; const t1: Integer);
begin T := Self.ItemEnabled[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxChecked_W(Self: TCheckListBox; const T: Boolean; const t1: Integer);
begin Self.Checked[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TCheckListBoxChecked_R(Self: TCheckListBox; var T: Boolean; const t1: Integer);
begin T := Self.Checked[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCheckListBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCheckListBox) do begin
    RegisterConstructor(@TCheckListBox.Create, 'Create');
     RegisterMethod(@TCheckListBox.Free, 'Free');
    RegisterPropertyHelper(@TCheckListBoxChecked_R,@TCheckListBoxChecked_W,'Checked');
    RegisterPropertyHelper(@TCheckListBoxItemEnabled_R,@TCheckListBoxItemEnabled_W,'ItemEnabled');
    RegisterPropertyHelper(@TCheckListBoxState_R,@TCheckListBoxState_W,'State');
    RegisterPropertyHelper(@TCheckListBoxHeader_R,@TCheckListBoxHeader_W,'Header');
    RegisterPropertyHelper(@TCheckListBoxOnClickCheck_R,@TCheckListBoxOnClickCheck_W,'OnClickCheck');
    RegisterPropertyHelper(@TCheckListBoxAllowGrayed_R,@TCheckListBoxAllowGrayed_W,'AllowGrayed');
    RegisterPropertyHelper(@TCheckListBoxFlat_R,@TCheckListBoxFlat_W,'Flat');
    RegisterPropertyHelper(@TCheckListBoxHeaderColor_R,@TCheckListBoxHeaderColor_W,'HeaderColor');
    RegisterPropertyHelper(@TCheckListBoxHeaderBackgroundColor_R,@TCheckListBoxHeaderBackgroundColor_W,'HeaderBackgroundColor');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CheckLst(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TCheckListBox(CL);
end;

 
 
{ TPSImport_CheckLst }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CheckLst.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CheckLst(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CheckLst.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CheckLst(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
