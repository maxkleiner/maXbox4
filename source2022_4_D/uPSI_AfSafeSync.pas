unit uPSI_AfSafeSync;
{
  of free async
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
  TPSImport_AfSafeSync = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_AfSafeSync(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_AfSafeSync_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Forms
  ,AfSafeSync
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_AfSafeSync]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_AfSafeSync(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('AfMaxSyncSlots','LongInt').SetInt( 64);
 CL.AddConstantN('AfSynchronizeTimeout','LongInt').SetInt( 2000);
  CL.AddTypeS('TAfSyncSlotID', 'DWORD');
  CL.AddTypeS('TAfSyncStatistics', 'record MessagesCount : Integer; TimeoutMess'
   +'ages : Integer; DisabledMessages : Integer; end');
  CL.AddTypeS('TAfSafeSyncEvent', 'Procedure ( ID : TAfSyncSlotID)');
  CL.AddTypeS('TAfSafeDirectSyncEvent', 'Procedure');
 CL.AddDelphiFunction('Function AfNewSyncSlot( const AEvent : TAfSafeSyncEvent) : TAfSyncSlotID');
 CL.AddDelphiFunction('Function AfReleaseSyncSlot( const ID : TAfSyncSlotID) : Boolean');
 CL.AddDelphiFunction('Function AfEnableSyncSlot( const ID : TAfSyncSlotID; Enable : Boolean) : Boolean');
 CL.AddDelphiFunction('Function AfValidateSyncSlot( const ID : TAfSyncSlotID) : Boolean');
 CL.AddDelphiFunction('Function AfSyncEvent( const ID : TAfSyncSlotID; Timeout : DWORD) : Boolean');
 CL.AddDelphiFunction('Function AfDirectSyncEvent( Event : TAfSafeDirectSyncEvent; Timeout : DWORD) : Boolean');
 CL.AddDelphiFunction('Function AfIsSyncMethod : Boolean');
 CL.AddDelphiFunction('Function AfSyncWnd : HWnd');
 CL.AddDelphiFunction('Function AfSyncStatistics : TAfSyncStatistics');
 CL.AddDelphiFunction('Procedure AfClearSyncStatistics');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_AfSafeSync_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@AfNewSyncSlot, 'AfNewSyncSlot', cdRegister);
 S.RegisterDelphiFunction(@AfReleaseSyncSlot, 'AfReleaseSyncSlot', cdRegister);
 S.RegisterDelphiFunction(@AfEnableSyncSlot, 'AfEnableSyncSlot', cdRegister);
 S.RegisterDelphiFunction(@AfValidateSyncSlot, 'AfValidateSyncSlot', cdRegister);
 S.RegisterDelphiFunction(@AfSyncEvent, 'AfSyncEvent', cdRegister);
 S.RegisterDelphiFunction(@AfDirectSyncEvent, 'AfDirectSyncEvent', cdRegister);
 S.RegisterDelphiFunction(@AfIsSyncMethod, 'AfIsSyncMethod', cdRegister);
 S.RegisterDelphiFunction(@AfSyncWnd, 'AfSyncWnd', cdRegister);
 S.RegisterDelphiFunction(@AfSyncStatistics, 'AfSyncStatistics', cdRegister);
 S.RegisterDelphiFunction(@AfClearSyncStatistics, 'AfClearSyncStatistics', cdRegister);
end;

 
 
{ TPSImport_AfSafeSync }
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfSafeSync.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_AfSafeSync(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_AfSafeSync.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_AfSafeSync(ri);
  RIRegister_AfSafeSync_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
