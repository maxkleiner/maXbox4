unit uPSI_ovcmru;
{
  list for mX scripts also
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
  TPSImport_ovcmru = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcMenuMRU(CL: TPSPascalCompiler);
procedure SIRegister_ovcmru(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcMenuMRU(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcmru(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Graphics
  ,Menus
  ,Forms
  ,Controls
  ,OvcBase
  ,OvcExcpt
  ,OvcConst
  ,OvcFiler
  ,OvcMisc
  ,ovcmru
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcmru]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcMenuMRU(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcComponent', 'TOvcMenuMRU') do
  with CL.AddClassN(CL.FindClass('TOvcComponent'),'TOvcMenuMRU') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Loaded');
    RegisterMethod('Procedure Notification( Component : TComponent; Operation : TOperation)');
    RegisterMethod('Procedure Add( const Value : string)');
    RegisterMethod('Procedure AddSplit( const Value : string; Position : TOvcMRUAddPosition)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Remove( const Value : string)');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('AddPosition', 'TOvcMRUAddPosition', iptrw);
    RegisterProperty('AnchorItem', 'TMenuItem', iptrw);
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('GroupIndex', 'Integer', iptrw);
    RegisterProperty('Hint', 'string', iptrw);
    RegisterProperty('Items', 'TStrings', iptrw);
    RegisterProperty('MaxItems', 'Integer', iptrw);
    RegisterProperty('MaxMenuWidth', 'Integer', iptrw);
    RegisterProperty('MenuItem', 'TMenuItem', iptrw);
    RegisterProperty('Options', 'TOvcMRUOptions', iptrw);
    RegisterProperty('Store', 'TOvcAbstractStore', iptrw);
    RegisterProperty('Style', 'TOvcMRUStyle', iptrw);
    RegisterProperty('Visible', 'Boolean', iptrw);
    RegisterProperty('OnClick', 'TOvcMRUClickEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcmru(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcMRUOption', '( moAddAccelerators, moStripPath, moAddSeparator )');
  CL.AddTypeS('TOvcMRUAddPosition', '( apAnchor, apTop, apBottom )');
  CL.AddTypeS('TOvcMRUStyle', '( msNormal, msSplit )');
  CL.AddTypeS('TOvcMRUClickAction', '( caMoveToTop, caRemove, caNoAction )');
  CL.AddTypeS('TOvcMRUOptions', 'set of TOvcMRUOption');
  CL.AddTypeS('TOvcMRUClickEvent', 'Procedure ( Sender : TObject; const ItemTex'
   +'t : string; var Action : TOvcMRUClickAction)');
  CL.AddTypeS('TOvcMRUAddPositions', 'set of TOvcMRUAddPosition');
  SIRegister_TOvcMenuMRU(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUOnClick_W(Self: TOvcMenuMRU; const T: TOvcMRUClickEvent);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUOnClick_R(Self: TOvcMenuMRU; var T: TOvcMRUClickEvent);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUVisible_W(Self: TOvcMenuMRU; const T: Boolean);
begin Self.Visible := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUVisible_R(Self: TOvcMenuMRU; var T: Boolean);
begin T := Self.Visible; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUStyle_W(Self: TOvcMenuMRU; const T: TOvcMRUStyle);
begin Self.Style := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUStyle_R(Self: TOvcMenuMRU; var T: TOvcMRUStyle);
begin T := Self.Style; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUStore_W(Self: TOvcMenuMRU; const T: TOvcAbstractStore);
begin Self.Store := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUStore_R(Self: TOvcMenuMRU; var T: TOvcAbstractStore);
begin T := Self.Store; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUOptions_W(Self: TOvcMenuMRU; const T: TOvcMRUOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUOptions_R(Self: TOvcMenuMRU; var T: TOvcMRUOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUMenuItem_W(Self: TOvcMenuMRU; const T: TMenuItem);
begin Self.MenuItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUMenuItem_R(Self: TOvcMenuMRU; var T: TMenuItem);
begin T := Self.MenuItem; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUMaxMenuWidth_W(Self: TOvcMenuMRU; const T: Integer);
begin Self.MaxMenuWidth := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUMaxMenuWidth_R(Self: TOvcMenuMRU; var T: Integer);
begin T := Self.MaxMenuWidth; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUMaxItems_W(Self: TOvcMenuMRU; const T: Integer);
begin Self.MaxItems := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUMaxItems_R(Self: TOvcMenuMRU; var T: Integer);
begin T := Self.MaxItems; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUItems_W(Self: TOvcMenuMRU; const T: TStrings);
begin Self.Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUItems_R(Self: TOvcMenuMRU; var T: TStrings);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUHint_W(Self: TOvcMenuMRU; const T: string);
begin Self.Hint := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUHint_R(Self: TOvcMenuMRU; var T: string);
begin T := Self.Hint; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUGroupIndex_W(Self: TOvcMenuMRU; const T: Integer);
begin Self.GroupIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUGroupIndex_R(Self: TOvcMenuMRU; var T: Integer);
begin T := Self.GroupIndex; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUEnabled_W(Self: TOvcMenuMRU; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUEnabled_R(Self: TOvcMenuMRU; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUAnchorItem_W(Self: TOvcMenuMRU; const T: TMenuItem);
begin Self.AnchorItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUAnchorItem_R(Self: TOvcMenuMRU; var T: TMenuItem);
begin T := Self.AnchorItem; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUAddPosition_W(Self: TOvcMenuMRU; const T: TOvcMRUAddPosition);
begin Self.AddPosition := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUAddPosition_R(Self: TOvcMenuMRU; var T: TOvcMRUAddPosition);
begin T := Self.AddPosition; end;

(*----------------------------------------------------------------------------*)
procedure TOvcMenuMRUCount_R(Self: TOvcMenuMRU; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcMenuMRU(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcMenuMRU) do begin
    RegisterConstructor(@TOvcMenuMRU.Create, 'Create');
    RegisterMethod(@TOvcMenuMRU.Destroy, 'Free');
    RegisterMethod(@TOvcMenuMRU.Loaded, 'Loaded');
    RegisterMethod(@TOvcMenuMRU.Notification, 'Notification');
    RegisterMethod(@TOvcMenuMRU.Add, 'Add');
    RegisterMethod(@TOvcMenuMRU.AddSplit, 'AddSplit');
    RegisterMethod(@TOvcMenuMRU.Clear, 'Clear');
    RegisterMethod(@TOvcMenuMRU.Remove, 'Remove');
    RegisterPropertyHelper(@TOvcMenuMRUCount_R,nil,'Count');
    RegisterPropertyHelper(@TOvcMenuMRUAddPosition_R,@TOvcMenuMRUAddPosition_W,'AddPosition');
    RegisterPropertyHelper(@TOvcMenuMRUAnchorItem_R,@TOvcMenuMRUAnchorItem_W,'AnchorItem');
    RegisterPropertyHelper(@TOvcMenuMRUEnabled_R,@TOvcMenuMRUEnabled_W,'Enabled');
    RegisterPropertyHelper(@TOvcMenuMRUGroupIndex_R,@TOvcMenuMRUGroupIndex_W,'GroupIndex');
    RegisterPropertyHelper(@TOvcMenuMRUHint_R,@TOvcMenuMRUHint_W,'Hint');
    RegisterPropertyHelper(@TOvcMenuMRUItems_R,@TOvcMenuMRUItems_W,'Items');
    RegisterPropertyHelper(@TOvcMenuMRUMaxItems_R,@TOvcMenuMRUMaxItems_W,'MaxItems');
    RegisterPropertyHelper(@TOvcMenuMRUMaxMenuWidth_R,@TOvcMenuMRUMaxMenuWidth_W,'MaxMenuWidth');
    RegisterPropertyHelper(@TOvcMenuMRUMenuItem_R,@TOvcMenuMRUMenuItem_W,'MenuItem');
    RegisterPropertyHelper(@TOvcMenuMRUOptions_R,@TOvcMenuMRUOptions_W,'Options');
    RegisterPropertyHelper(@TOvcMenuMRUStore_R,@TOvcMenuMRUStore_W,'Store');
    RegisterPropertyHelper(@TOvcMenuMRUStyle_R,@TOvcMenuMRUStyle_W,'Style');
    RegisterPropertyHelper(@TOvcMenuMRUVisible_R,@TOvcMenuMRUVisible_W,'Visible');
    RegisterPropertyHelper(@TOvcMenuMRUOnClick_R,@TOvcMenuMRUOnClick_W,'OnClick');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcmru(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcMenuMRU(CL);
end;

 
 
{ TPSImport_ovcmru }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcmru.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcmru(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcmru.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcmru(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
