unit uPSI_TomDBQue;
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
  TPSImport_TomDBQue = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTomBackgroundQuery(CL: TPSPascalCompiler);
procedure SIRegister_TTomQueryThread(CL: TPSPascalCompiler);
procedure SIRegister_TomDBQue(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TTomBackgroundQuery(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTomQueryThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TomDBQue(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,Messages
  //,Graphics
  //,Controls
  //,Forms
  //,Dialogs
  ,DB
  ,DBTables
  ,TomDBQue
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TomDBQue]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTomBackgroundQuery(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TTomBackgroundQuery') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TTomBackgroundQuery') do begin
    RegisterMethod('Procedure Execute');
    RegisterProperty('Query', 'TQuery', iptrw);
    RegisterProperty('OnQueryReady', 'Tnotifyevent', iptrw);
    RegisterProperty('OnQueryError', 'Tnotifyevent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTomQueryThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TTomQueryThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TTomQueryThread') do begin
    RegisterMethod('Constructor Create( Query : TQuery)');
    RegisterProperty('OnQueryThreadReady', 'Tnotifyevent', iptrw);
    RegisterProperty('OnQueryThreadError', 'Tnotifyevent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TomDBQue(CL: TPSPascalCompiler);
begin
  SIRegister_TTomQueryThread(CL);
  SIRegister_TTomBackgroundQuery(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTomBackgroundQueryOnQueryError_W(Self: TTomBackgroundQuery; const T: Tnotifyevent);
begin Self.OnQueryError := T; end;

(*----------------------------------------------------------------------------*)
procedure TTomBackgroundQueryOnQueryError_R(Self: TTomBackgroundQuery; var T: Tnotifyevent);
begin T := Self.OnQueryError; end;

(*----------------------------------------------------------------------------*)
procedure TTomBackgroundQueryOnQueryReady_W(Self: TTomBackgroundQuery; const T: Tnotifyevent);
begin Self.OnQueryReady := T; end;

(*----------------------------------------------------------------------------*)
procedure TTomBackgroundQueryOnQueryReady_R(Self: TTomBackgroundQuery; var T: Tnotifyevent);
begin T := Self.OnQueryReady; end;

(*----------------------------------------------------------------------------*)
procedure TTomBackgroundQueryQuery_W(Self: TTomBackgroundQuery; const T: TQuery);
begin Self.Query := T; end;

(*----------------------------------------------------------------------------*)
procedure TTomBackgroundQueryQuery_R(Self: TTomBackgroundQuery; var T: TQuery);
begin T := Self.Query; end;

(*----------------------------------------------------------------------------*)
procedure TTomQueryThreadOnQueryThreadError_W(Self: TTomQueryThread; const T: Tnotifyevent);
begin Self.OnQueryThreadError := T; end;

(*----------------------------------------------------------------------------*)
procedure TTomQueryThreadOnQueryThreadError_R(Self: TTomQueryThread; var T: Tnotifyevent);
begin T := Self.OnQueryThreadError; end;

(*----------------------------------------------------------------------------*)
procedure TTomQueryThreadOnQueryThreadReady_W(Self: TTomQueryThread; const T: Tnotifyevent);
begin Self.OnQueryThreadReady := T; end;

(*----------------------------------------------------------------------------*)
procedure TTomQueryThreadOnQueryThreadReady_R(Self: TTomQueryThread; var T: Tnotifyevent);
begin T := Self.OnQueryThreadReady; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTomBackgroundQuery(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTomBackgroundQuery) do
  begin
    RegisterMethod(@TTomBackgroundQuery.Execute, 'Execute');
    RegisterPropertyHelper(@TTomBackgroundQueryQuery_R,@TTomBackgroundQueryQuery_W,'Query');
    RegisterPropertyHelper(@TTomBackgroundQueryOnQueryReady_R,@TTomBackgroundQueryOnQueryReady_W,'OnQueryReady');
    RegisterPropertyHelper(@TTomBackgroundQueryOnQueryError_R,@TTomBackgroundQueryOnQueryError_W,'OnQueryError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTomQueryThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTomQueryThread) do
  begin
    RegisterConstructor(@TTomQueryThread.Create, 'Create');
    RegisterPropertyHelper(@TTomQueryThreadOnQueryThreadReady_R,@TTomQueryThreadOnQueryThreadReady_W,'OnQueryThreadReady');
    RegisterPropertyHelper(@TTomQueryThreadOnQueryThreadError_R,@TTomQueryThreadOnQueryThreadError_W,'OnQueryThreadError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TomDBQue(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTomQueryThread(CL);
  RIRegister_TTomBackgroundQuery(CL);
end;

 
 
{ TPSImport_TomDBQue }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TomDBQue.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TomDBQue(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TomDBQue.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_TomDBQue(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.