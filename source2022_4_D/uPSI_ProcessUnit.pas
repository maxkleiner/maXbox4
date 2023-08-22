unit uPSI_ProcessUnit;
{
   the big list with an open string array - fork for folk
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
  TPSImport_ProcessUnit = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TProcessManager(CL: TPSPascalCompiler);
procedure SIRegister_ProcessUnit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TProcessManager(CL: TPSRuntimeClassImporter);
procedure RIRegister_ProcessUnit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,TlHelp32
  ,ProcessUnit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ProcessUnit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TProcessManager(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TProcessManager') do
   CL.AddTypeS('TStringArray', 'array of string');

  with CL.AddClassN(CL.FindClass('TObject'),'TProcessManager') do
  begin
    RegisterProperty('Count', 'integer', iptrw);
    RegisterProperty('ExePathList', 'TStringArray', iptrw);
    RegisterProperty('PIDList', 'TStringArray', iptrw);
    RegisterProperty('PriorityList', 'TStringArray', iptrw);
    RegisterProperty('ThreadList', 'TStringArray', iptrw);
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ListProcesses');
    RegisterMethod('Procedure KillProcessByPID( PID : string)');
    RegisterMethod('Procedure KillProcessByExePath( ExePath : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ProcessUnit(CL: TPSPascalCompiler);
begin
  SIRegister_TProcessManager(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TProcessManagerThreadList_W(Self: TProcessManager; const T: TStringArray; id: integer);
Begin Self.ThreadList[id]:= T[id];
end;

(*----------------------------------------------------------------------------*)
procedure TProcessManagerThreadList_R(Self: TProcessManager; var T: TStringArray);
Begin T:= self.ThreadList;
end;

(*----------------------------------------------------------------------------*)
procedure TProcessManagerPriorityList_W(Self: TProcessManager; const T: TStringArray);
Begin Self.PriorityList := T;
end;

(*----------------------------------------------------------------------------*)
procedure TProcessManagerPriorityList_R(Self: TProcessManager; var T: TStringArray);
Begin T := Self.PriorityList;
end;

(*----------------------------------------------------------------------------*)
procedure TProcessManagerPIDList_W(Self: TProcessManager; const T: TStringArray);
Begin Self.PIDList := T;
end;

(*----------------------------------------------------------------------------*)
procedure TProcessManagerPIDList_R(Self: TProcessManager; var T: TStringArray);
Begin T := Self.PIDList;
end;

(*----------------------------------------------------------------------------*)
{procedure TProcessManagerExePathList_W(Self: TProcessManager; const T: TStringArray; const id: integer);
Begin Self.ExePathList[id] := T[id];
end;
(*----------------------------------------------------------------------------*)
procedure TProcessManagerExePathList_R(Self: TProcessManager; var T: TStringArray; const id: integer);
Begin T[id] := Self.ExePathList[id];
end;}

procedure TProcessManagerExePathList_W(Self: TProcessManager; const T: TStringArray);
Begin Self.ExePathList:= T;
end;
(*----------------------------------------------------------------------------*)
procedure TProcessManagerExePathList_R(Self: TProcessManager; var T: TStringArray);
Begin T:= Self.ExePathList;
end;


(*----------------------------------------------------------------------------*)
procedure TProcessManagerCount_W(Self: TProcessManager; const T: integer);
Begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TProcessManagerCount_R(Self: TProcessManager; var T: integer);
Begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TProcessManager(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TProcessManager) do begin
    RegisterPropertyHelper(@TProcessManagerCount_R,@TProcessManagerCount_W,'Count');
    RegisterPropertyHelper(@TProcessManagerExePathList_R,@TProcessManagerExePathList_W,'ExePathList');
    RegisterPropertyHelper(@TProcessManagerPIDList_R,@TProcessManagerPIDList_W,'PIDList');
    RegisterPropertyHelper(@TProcessManagerPriorityList_R,@TProcessManagerPriorityList_W,'PriorityList');
    RegisterPropertyHelper(@TProcessManagerThreadList_R,@TProcessManagerThreadList_W,'ThreadList');
    RegisterConstructor(@TProcessManager.Create, 'Create');
     RegisterMethod(@TProcessManager.Destroy, 'Free');
      RegisterMethod(@TProcessManager.ListProcesses, 'ListProcesses');
    RegisterMethod(@TProcessManager.KillProcessByPID, 'KillProcessByPID');
    RegisterMethod(@TProcessManager.KillProcessByExePath, 'KillProcessByExePath');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ProcessUnit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TProcessManager(CL);
end;

 
 
{ TPSImport_ProcessUnit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ProcessUnit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ProcessUnit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ProcessUnit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ProcessUnit(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
