unit uPSI_StPtrns;
{
This file has been generated by UnitParser v0.7, written by M. Knight
and updated by NP. v/d Spek and George Birbilis. 
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ROPS are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok's conv utility

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
  TPSImport_StPtrns = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStChain(CL: TPSPascalCompiler);
procedure SIRegister_TStObserver(CL: TPSPascalCompiler);
procedure SIRegister_TStMediator(CL: TPSPascalCompiler);
procedure SIRegister_TStSingleton(CL: TPSPascalCompiler);
procedure SIRegister_StPtrns(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStChain(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStObserver(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStMediator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStSingleton(CL: TPSRuntimeClassImporter);
procedure RIRegister_StPtrns(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StPtrns
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StPtrns]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStChain(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStChain') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStChain') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Add( aHandler : TStChainAction)');
    RegisterMethod('Procedure Remove( aIndex : Integer)');
    RegisterMethod('Procedure Handle( aInputData, aResultData : TObject)');
    RegisterMethod('Procedure Insert( aIndex : Integer; aHandler : TStChainAction)');
    RegisterProperty('Handler', 'TStChainAction Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStObserver(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStObserver') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStObserver') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Add( aHandler : TStObserverAction)');
    RegisterMethod('Procedure Remove( aIndex : Integer)');
    RegisterMethod('Procedure Notify( aInputData : TObject)');
    RegisterProperty('Handler', 'TStObserverAction Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStMediator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStMediator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStMediator') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Add( const aEventName : string; aHandler : TStMediatorAction)');
    RegisterMethod('Procedure Remove( const aEventName : string)');
    RegisterMethod('Procedure Handle( const aEventName : string; aInputData, aResultData : TObject)');
    RegisterMethod('Function IsHandled( const aEventName : string) : boolean');
    RegisterProperty('Count', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStSingleton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TStSingleton') do
  with CL.AddClassN(CL.FindClass('TObject'),'TStSingleton') do begin
    RegisterMethod('Function NewInstance : TObject');
    RegisterMethod('procedure FreeInstance');
    RegisterMethod('Procedure AllocResources');
    RegisterMethod('Procedure FreeResources');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StPtrns(CL: TPSPascalCompiler);
begin
  SIRegister_TStSingleton(CL);
  CL.AddTypeS('TStMediatorAction', 'Procedure ( aInputData, aResultData : TObject)');
  SIRegister_TStMediator(CL);
  CL.AddTypeS('TStObserverAction', 'Procedure ( aInputData : TObject)');
  SIRegister_TStObserver(CL);
  CL.AddTypeS('TStChainAction', 'Procedure ( aInputData, aResultData : TObject; var aStopNow : boolean)');
  SIRegister_TStChain(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStChainCount_R(Self: TStChain; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStChainHandler_W(Self: TStChain; const T: TStChainAction; const t1: Integer);
begin Self.Handler[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStChainHandler_R(Self: TStChain; var T: TStChainAction; const t1: Integer);
begin T := Self.Handler[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStObserverCount_R(Self: TStObserver; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStObserverHandler_W(Self: TStObserver; const T: TStObserverAction; const t1: Integer);
begin Self.Handler[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TStObserverHandler_R(Self: TStObserver; var T: TStObserverAction; const t1: Integer);
begin T := Self.Handler[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TStMediatorCount_R(Self: TStMediator; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStChain(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStChain) do begin
    RegisterConstructor(@TStChain.Create, 'Create');
      RegisterMethod(@TStChain.Destroy, 'Free');
      RegisterMethod(@TStChain.Add, 'Add');
    RegisterMethod(@TStChain.Remove, 'Remove');
    RegisterMethod(@TStChain.Handle, 'Handle');
    RegisterMethod(@TStChain.Insert, 'Insert');
    RegisterPropertyHelper(@TStChainHandler_R,@TStChainHandler_W,'Handler');
    RegisterPropertyHelper(@TStChainCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStObserver(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStObserver) do begin
    RegisterConstructor(@TStObserver.Create, 'Create');
      RegisterMethod(@TStObserver.Destroy, 'Free');
      RegisterMethod(@TStObserver.Add, 'Add');
    RegisterMethod(@TStObserver.Remove, 'Remove');
    RegisterMethod(@TStObserver.Notify, 'Notify');
    RegisterPropertyHelper(@TStObserverHandler_R,@TStObserverHandler_W,'Handler');
    RegisterPropertyHelper(@TStObserverCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStMediator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStMediator) do begin
    RegisterConstructor(@TStMediator.Create, 'Create');
      RegisterMethod(@TStMediator.Destroy, 'Free');
      RegisterMethod(@TStMediator.Add, 'Add');
    RegisterMethod(@TStMediator.Remove, 'Remove');
    RegisterMethod(@TStMediator.Handle, 'Handle');
    RegisterMethod(@TStMediator.IsHandled, 'IsHandled');
    RegisterPropertyHelper(@TStMediatorCount_R,nil,'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStSingleton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStSingleton) do begin
    RegisterMethod(@TStSingleton.NewInstance, 'NewInstance');
    RegisterMethod(@TStSingleton.FreeInstance, 'FreeInstance');
     RegisterMethod(@TStSingleton.Destroy, 'Free');
      RegisterVirtualMethod(@TStSingleton.AllocResources, 'AllocResources');
    RegisterVirtualMethod(@TStSingleton.FreeResources, 'FreeResources');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StPtrns(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStSingleton(CL);
  RIRegister_TStMediator(CL);
  RIRegister_TStObserver(CL);
  RIRegister_TStChain(CL);
end;

 
 
{ TPSImport_StPtrns }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StPtrns.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StPtrns(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StPtrns.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StPtrns(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
