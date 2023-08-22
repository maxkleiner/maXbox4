unit uPSI_AfPortControls;
{
  port sort host
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
  TPSImport_AfPortControls = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TAfPortRadioGroup(CL: TPSPascalCompiler);
procedure SIRegister_TAfPortComboBox(CL: TPSPascalCompiler);
procedure SIRegister_AfPortControls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TAfPortRadioGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAfPortComboBox(CL: TPSRuntimeClassImporter);
procedure RIRegister_AfPortControls(CL: TPSRuntimeClassImporter);

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
  ,ExtCtrls
  ,AfComPort
  ,AfPortControls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfPortControls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfPortRadioGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomRadioGroup', 'TAfPortRadioGroup') do
  with CL.AddClassN(CL.FindClass('TCustomRadioGroup'),'TAfPortRadioGroup') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ComNumber', 'Word', iptrw);
    RegisterMethod('Procedure UpdatePortList');
    RegisterProperty('ComPort', 'TAfComPort', iptrw);
    RegisterProperty('MaxComPorts', 'SmallInt', iptrw);
    RegisterProperty('Options', 'TAfPortCtlOptions', iptrw);
    RegisterpublishedProperties;
    RegisterProperty('OnClick', 'TNotifyEvent', iptrw);
    RegisterProperty('Caption', 'string', iptrw);
      RegisterProperty('ItemIndex', 'Integer', iptrw);
    RegisterProperty('Items', 'TStrings', iptrw);
    //RegisterProperty('Items', 'TStrings Integer', iptrw);
     RegisterProperty('Columns', 'Integer', iptrw);
       RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     //RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);


   { SetDefaultPropery('Items');
    property Columns: Integer read FColumns write SetColumns default 1;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItems write SetItems;}



  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAfPortComboBox(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomComboBox', 'TAfPortComboBox') do
  with CL.AddClassN(CL.FindClass('TCustomComboBox'),'TAfPortComboBox') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('ComNumber', 'Word', iptrw);
    RegisterProperty('ComPort', 'TAfComPort', iptrw);
    RegisterProperty('Options', 'TAfPortCtlOptions', iptrw);
    RegisterProperty('MaxComPorts', 'SmallInt', iptrw);
     RegisterpublishedProperties;
        RegisterProperty('CAPTION', 'String', iptrw);
    RegisterProperty('CHECKED', 'BOOLEAN', iptrw);
    RegisterProperty('COLOR', 'TColor', iptrw);
    RegisterProperty('FONT', 'TFont', iptrw);
    RegisterProperty('PARENTCOLOR', 'Boolean', iptrw);
    RegisterProperty('PARENTFONT', 'Boolean', iptrw);
     RegisterProperty('CTL3D', 'Boolean', iptrw);
     RegisterProperty('FONT', 'TFont', iptrw);
     RegisterProperty('SORTED', 'Boolean', iptrw);
     RegisterProperty('Visible', 'Boolean', iptrw);
     RegisterProperty('TEXT', 'String', iptrw);
    RegisterProperty('BORDERSTYLE', 'TBorderStyle', iptrw);

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_AfPortControls(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TAfPortCtlOption', '( pcCheckExist, pcDisableOpen, pcHighlightOpen )');
   CL.AddTypeS('TAfPortCtlOptions', 'set of TAfPortCtlOption');
  //CL.AddTypeS('TAfPortCtlOptions', 'set of ( pcCheckExist, pcDisableOpen, pcHighlightOpen )');
  SIRegister_TAfPortComboBox(CL);
  SIRegister_TAfPortRadioGroup(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupOptions_W(Self: TAfPortRadioGroup; const T: TAfPortCtlOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupOptions_R(Self: TAfPortRadioGroup; var T: TAfPortCtlOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupitems_W(Self: TRadioGroup; const T: TStrings);
begin Self.items:= T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupitems_R(Self: TRadioGroup; var T: TStrings);
begin T := Self.Items; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupitemindex_W(Self: TRadioGroup; const T: integer);
begin Self.itemindex:= T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupitemindex_R(Self: TRadioGroup; var T: integer);
begin T := Self.Itemindex; end;


(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupMaxComPorts_W(Self: TAfPortRadioGroup; const T: SmallInt);
begin Self.MaxComPorts := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupMaxComPorts_R(Self: TAfPortRadioGroup; var T: SmallInt);
begin T := Self.MaxComPorts; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupComPort_W(Self: TAfPortRadioGroup; const T: TAfComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupComPort_R(Self: TAfPortRadioGroup; var T: TAfComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupComNumber_W(Self: TAfPortRadioGroup; const T: Word);
begin Self.ComNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortRadioGroupComNumber_R(Self: TAfPortRadioGroup; var T: Word);
begin T := Self.ComNumber; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortComboBoxMaxComPorts_W(Self: TAfPortComboBox; const T: SmallInt);
begin Self.MaxComPorts := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortComboBoxMaxComPorts_R(Self: TAfPortComboBox; var T: SmallInt);
begin T := Self.MaxComPorts; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortComboBoxOptions_W(Self: TAfPortComboBox; const T: TAfPortCtlOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortComboBoxOptions_R(Self: TAfPortComboBox; var T: TAfPortCtlOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortComboBoxComPort_W(Self: TAfPortComboBox; const T: TAfComPort);
begin Self.ComPort := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortComboBoxComPort_R(Self: TAfPortComboBox; var T: TAfComPort);
begin T := Self.ComPort; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortComboBoxComNumber_W(Self: TAfPortComboBox; const T: Word);
begin Self.ComNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TAfPortComboBoxComNumber_R(Self: TAfPortComboBox; var T: Word);
begin T := Self.ComNumber; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfPortRadioGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfPortRadioGroup) do
  begin
    RegisterConstructor(@TAfPortRadioGroup.Create, 'Create');
    RegisterPropertyHelper(@TAfPortRadioGroupComNumber_R,@TAfPortRadioGroupComNumber_W,'ComNumber');
    RegisterMethod(@TAfPortRadioGroup.UpdatePortList, 'UpdatePortList');
    RegisterPropertyHelper(@TAfPortRadioGroupComPort_R,@TAfPortRadioGroupComPort_W,'ComPort');
    RegisterPropertyHelper(@TAfPortRadioGroupMaxComPorts_R,@TAfPortRadioGroupMaxComPorts_W,'MaxComPorts');
    RegisterPropertyHelper(@TAfPortRadioGroupOptions_R,@TAfPortRadioGroupOptions_W,'Options');
    RegisterPropertyHelper(@TAfPortRadioGroupItems_R,@TAfPortRadioGroupitems_W,'Items');
    RegisterPropertyHelper(@TAfPortRadioGroupItemindex_R,@TAfPortRadioGroupitemindex_W,'Itemindex');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAfPortComboBox(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAfPortComboBox) do
  begin
    RegisterConstructor(@TAfPortComboBox.Create, 'Create');
    RegisterPropertyHelper(@TAfPortComboBoxComNumber_R,@TAfPortComboBoxComNumber_W,'ComNumber');
    RegisterPropertyHelper(@TAfPortComboBoxComPort_R,@TAfPortComboBoxComPort_W,'ComPort');
    RegisterPropertyHelper(@TAfPortComboBoxOptions_R,@TAfPortComboBoxOptions_W,'Options');
    RegisterPropertyHelper(@TAfPortComboBoxMaxComPorts_R,@TAfPortComboBoxMaxComPorts_W,'MaxComPorts');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_AfPortControls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TAfPortComboBox(CL);
  RIRegister_TAfPortRadioGroup(CL);
end;

 
 
{ TPSImport_AfPortControls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfPortControls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfPortControls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfPortControls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_AfPortControls(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
