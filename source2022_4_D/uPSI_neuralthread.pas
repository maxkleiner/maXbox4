unit uPSI_neuralthread;
{
the very last of CAI    - InitCriticalSection  - startproc

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
  TPSImport_neuralthread = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNeuralThreadList(CL: TPSPascalCompiler);
procedure SIRegister_TNeuralThread(CL: TPSPascalCompiler);
procedure SIRegister_neuralthread(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_neuralthread_Routines(S: TPSExec);
procedure RIRegister_TNeuralThreadList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNeuralThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_neuralthread(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  //fgl
  //,MTPCPU
  windows
 //,BaseUnix
  ,syncobjs
  ,neuralthread
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_neuralthread]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuralThreadList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TNeuralThreadList') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TNeuralThreadList') do
  begin
    RegisterMethod('Constructor Create( pSize : integer)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure CalculateWorkingRange( pIndex, pThreadnum, pSize : integer; out StartPos, FinishPos : integer)');
    RegisterMethod('Function GetRandomNumberOnWorkingRange( pIndex, pThreadnum, pSize : integer) : integer;');
    RegisterMethod('Function GetRandomNumberOnWorkingRange1( pIndex, pThreadnum, pSize : integer; out MaxLen : integer) : integer;');
    RegisterMethod('Procedure StartEngine( )');
    RegisterMethod('Procedure StopEngine( )');
    RegisterMethod('Procedure StartProc( pProc : TNeuralProc; pBlock : boolean)');
    RegisterMethod('Procedure WaitForProc( )');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNeuralThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TNeuralThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TNeuralThread') do
  begin
    RegisterMethod('Constructor Create( CreateSuspended : boolean; pIndex : integer)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure StartProc( pProc : TNeuralProc; pIndex, pThreadNum : integer)');
    RegisterMethod('Procedure WaitForProc( )');
    RegisterMethod('Procedure DoSomething( )');
    RegisterProperty('ShouldStart', 'boolean', iptr);
    RegisterProperty('Running', 'boolean', iptr);
    RegisterProperty('ProcFinished', 'boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_neuralthread(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TNeuralProc', 'Procedure ( index, threadnum : integer)');
  SIRegister_TNeuralThread(CL);
  SIRegister_TNeuralThreadList(CL);
 CL.AddDelphiFunction('Procedure NeuralThreadListCreate( pSize : integer)');
 CL.AddDelphiFunction('Procedure NeuralThreadListFree( )');
 CL.AddDelphiFunction('Function fNTL : TNeuralThreadList');
 CL.AddDelphiFunction('Procedure CreateNeuralThreadListIfRequired( )');
 CL.AddDelphiFunction('Function NeuralDefaultThreadCount : integer');
 CL.AddDelphiFunction('Procedure NeuralInitCriticalSection( var pCritSec : TRTLCriticalSection)');
 CL.AddDelphiFunction('Procedure NeuralDoneCriticalSection( var pCritSec : TRTLCriticalSection)');
 CL.AddDelphiFunction('Procedure InitCriticalSection( var pCritSec : TRTLCriticalSection)');
 CL.AddDelphiFunction('Procedure DoneCriticalSection( var pCritSec : TRTLCriticalSection)');
 CL.AddDelphiFunction('Function neuralGetProcessId( ) : integer');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TNeuralThreadListGetRandomNumberOnWorkingRange1_P(Self: TNeuralThreadList;  pIndex, pThreadnum, pSize : integer; out MaxLen : integer) : integer;
Begin Result := Self.GetRandomNumberOnWorkingRange(pIndex, pThreadnum, pSize, MaxLen); END;

(*----------------------------------------------------------------------------*)
Function TNeuralThreadListGetRandomNumberOnWorkingRange_P(Self: TNeuralThreadList;  pIndex, pThreadnum, pSize : integer) : integer;
Begin Result := Self.GetRandomNumberOnWorkingRange(pIndex, pThreadnum, pSize); END;

(*----------------------------------------------------------------------------*)
procedure TNeuralThreadProcFinished_R(Self: TNeuralThread; var T: boolean);
begin T := Self.ProcFinished; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralThreadRunning_R(Self: TNeuralThread; var T: boolean);
begin T := Self.Running; end;

(*----------------------------------------------------------------------------*)
procedure TNeuralThreadShouldStart_R(Self: TNeuralThread; var T: boolean);
begin T := Self.ShouldStart; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralthread_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NeuralThreadListCreate, 'NeuralThreadListCreate', cdRegister);
 S.RegisterDelphiFunction(@NeuralThreadListFree, 'NeuralThreadListFree', cdRegister);
 S.RegisterDelphiFunction(@fNTL, 'fNTL', cdRegister);
 S.RegisterDelphiFunction(@CreateNeuralThreadListIfRequired, 'CreateNeuralThreadListIfRequired', cdRegister);
 S.RegisterDelphiFunction(@NeuralDefaultThreadCount, 'NeuralDefaultThreadCount', cdRegister);
 S.RegisterDelphiFunction(@NeuralInitCriticalSection, 'NeuralInitCriticalSection', cdRegister);
 S.RegisterDelphiFunction(@NeuralDoneCriticalSection, 'NeuralDoneCriticalSection', cdRegister);
 S.RegisterDelphiFunction(@NeuralInitCriticalSection, 'InitCriticalSection', cdRegister);
 S.RegisterDelphiFunction(@NeuralDoneCriticalSection, 'DoneCriticalSection', cdRegister);
 S.RegisterDelphiFunction(@GetProcessId, 'neuralGetProcessId', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuralThreadList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNeuralThreadList) do
  begin
    RegisterConstructor(@TNeuralThreadList.Create, 'Create');
    RegisterMethod(@TNeuralThreadList.Destroy, 'Free');
    RegisterMethod(@TNeuralThreadList.CalculateWorkingRange, 'CalculateWorkingRange');
    RegisterMethod(@TNeuralThreadListGetRandomNumberOnWorkingRange_P, 'GetRandomNumberOnWorkingRange');
    RegisterMethod(@TNeuralThreadListGetRandomNumberOnWorkingRange1_P, 'GetRandomNumberOnWorkingRange1');
    RegisterMethod(@TNeuralThreadList.StartEngine, 'StartEngine');
    RegisterMethod(@TNeuralThreadList.StopEngine, 'StopEngine');
    RegisterMethod(@TNeuralThreadList.StartProc, 'StartProc');
    RegisterMethod(@TNeuralThreadList.WaitForProc, 'WaitForProc');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNeuralThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNeuralThread) do
  begin
    RegisterConstructor(@TNeuralThread.Create, 'Create');
    RegisterMethod(@TNeuralThread.Destroy, 'Free');
    RegisterMethod(@TNeuralThread.StartProc, 'StartProc');
    RegisterMethod(@TNeuralThread.WaitForProc, 'WaitForProc');
    RegisterMethod(@TNeuralThread.DoSomething, 'DoSomething');
    RegisterPropertyHelper(@TNeuralThreadShouldStart_R,nil,'ShouldStart');
    RegisterPropertyHelper(@TNeuralThreadRunning_R,nil,'Running');
    RegisterPropertyHelper(@TNeuralThreadProcFinished_R,nil,'ProcFinished');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_neuralthread(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNeuralThread(CL);
  RIRegister_TNeuralThreadList(CL);
end;

 
 
{ TPSImport_neuralthread }
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralthread.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_neuralthread(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_neuralthread.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_neuralthread(ri);
  RIRegister_neuralthread_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
