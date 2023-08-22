unit uPSI_ovcstate;
{
   state gate
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
  TPSImport_ovcstate = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcPersistentState(CL: TPSPascalCompiler);
procedure SIRegister_TOvcComponentState(CL: TPSPascalCompiler);
procedure SIRegister_TOvcFormState(CL: TPSPascalCompiler);
procedure SIRegister_TOvcAbstractState(CL: TPSPascalCompiler);
procedure SIRegister_ovcstate(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ovcstate_Routines(S: TPSExec);
procedure RIRegister_TOvcPersistentState(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcComponentState(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcFormState(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcAbstractState(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcstate(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,Forms
  ,Messages
  ,OvcBase
  ,OvcData
  ,OvcMisc
  ,OvcFiler
  ,OvcExcpt
  ,OvcConst
  ,ovcstate
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcstate]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcPersistentState(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcComponent', 'TOvcPersistentState') do
  with CL.AddClassN(CL.FindClass('TOvcComponent'),'TOvcPersistentState') do begin
    RegisterMethod('Procedure RestoreState( AnObject : TPersistent; const ASection : string)');
    RegisterMethod('Procedure SaveState( AnObject : TPersistent; const ASection : string)');
    RegisterProperty('Storage', 'TOvcAbstractStore', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcComponentState(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcAbstractState', 'TOvcComponentState') do
  with CL.AddClassN(CL.FindClass('TOvcAbstractState'),'TOvcComponentState') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure SetNotification');
    RegisterMethod('Procedure UpdateStoredProperties');
    RegisterProperty('StoredProperties', 'TStrings', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcFormState(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcAbstractState', 'TOvcFormState') do
  with CL.AddClassN(CL.FindClass('TOvcAbstractState'),'TOvcFormState') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Options', 'TOvcFormStateOptions', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcAbstractState(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcComponent', 'TOvcAbstractState') do
  with CL.AddClassN(CL.FindClass('TOvcComponent'),'TOvcAbstractState') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure RestoreState');
    RegisterMethod('Procedure SaveState');
    RegisterProperty('SpecialValue', 'string string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcstate(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcFormStateOption', '( fsState, fsPosition, fsNoSize, fsColor,'
   +' fsActiveControl, fsDefaultMonitor )');
  CL.AddTypeS('TOvcFormStateOptions', 'set of TOvcFormStateOption');
  SIRegister_TOvcAbstractState(CL);
  SIRegister_TOvcFormState(CL);
  SIRegister_TOvcComponentState(CL);
  SIRegister_TOvcPersistentState(CL);
 CL.AddDelphiFunction('Function ovGetDefaultSection( Component : TComponent) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcPersistentStateStorage_W(Self: TOvcPersistentState; const T: TOvcAbstractStore);
begin Self.Storage := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcPersistentStateStorage_R(Self: TOvcPersistentState; var T: TOvcAbstractStore);
begin T := Self.Storage; end;

(*----------------------------------------------------------------------------*)
procedure TOvcComponentStateStoredProperties_W(Self: TOvcComponentState; const T: TStrings);
begin Self.StoredProperties := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcComponentStateStoredProperties_R(Self: TOvcComponentState; var T: TStrings);
begin T := Self.StoredProperties; end;

(*----------------------------------------------------------------------------*)
procedure TOvcFormStateOptions_W(Self: TOvcFormState; const T: TOvcFormStateOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcFormStateOptions_R(Self: TOvcFormState; var T: TOvcFormStateOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TOvcAbstractStateSpecialValue_W(Self: TOvcAbstractState; const T: string; const t1: string);
begin Self.SpecialValue[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcAbstractStateSpecialValue_R(Self: TOvcAbstractState; var T: string; const t1: string);
begin T := Self.SpecialValue[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcstate_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetDefaultSection, 'ovGetDefaultSection', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcPersistentState(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcPersistentState) do begin
    RegisterMethod(@TOvcPersistentState.RestoreState, 'RestoreState');
    RegisterMethod(@TOvcPersistentState.SaveState, 'SaveState');
    RegisterPropertyHelper(@TOvcPersistentStateStorage_R,@TOvcPersistentStateStorage_W,'Storage');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcComponentState(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcComponentState) do begin
    RegisterConstructor(@TOvcComponentState.Create, 'Create');
    RegisterMethod(@TOvcComponentState.SetNotification, 'SetNotification');
    RegisterMethod(@TOvcComponentState.UpdateStoredProperties, 'UpdateStoredProperties');
    RegisterPropertyHelper(@TOvcComponentStateStoredProperties_R,@TOvcComponentStateStoredProperties_W,'StoredProperties');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcFormState(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcFormState) do
  begin
    RegisterConstructor(@TOvcFormState.Create, 'Create');
    RegisterPropertyHelper(@TOvcFormStateOptions_R,@TOvcFormStateOptions_W,'Options');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcAbstractState(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcAbstractState) do
  begin
    RegisterConstructor(@TOvcAbstractState.Create, 'Create');
    RegisterMethod(@TOvcAbstractState.RestoreState, 'RestoreState');
    RegisterMethod(@TOvcAbstractState.SaveState, 'SaveState');
    RegisterPropertyHelper(@TOvcAbstractStateSpecialValue_R,@TOvcAbstractStateSpecialValue_W,'SpecialValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcstate(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcAbstractState(CL);
  RIRegister_TOvcFormState(CL);
  RIRegister_TOvcComponentState(CL);
  RIRegister_TOvcPersistentState(CL);
end;

 
 
{ TPSImport_ovcstate }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcstate.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcstate(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcstate.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcstate(ri);
  RIRegister_ovcstate_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
