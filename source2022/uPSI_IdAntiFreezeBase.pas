unit uPSI_IdAntiFreezeBase;
{
  run time checker  - add free
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
  TPSImport_IdAntiFreezeBase = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdAntiFreezeBase(CL: TPSPascalCompiler);
procedure SIRegister_IdAntiFreezeBase(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdAntiFreezeBase(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdAntiFreezeBase(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdBaseComponent
  ,IdAntiFreezeBase
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdAntiFreezeBase]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function BoolToStr(value : boolean) : string;
Begin If value then Result := 'TRUE' else Result := 'FALSE' End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdAntiFreezeBase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdBaseComponent', 'TIdAntiFreezeBase') do
  with CL.AddClassN(CL.FindClass('TIdBaseComponent'),'TIdAntiFreezeBase') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure DoProcess( const AIdle : boolean; const AOverride : boolean)');
    RegisterMethod('Procedure Process');
    RegisterMethod('Function ShouldUse : boolean');
    RegisterMethod('Procedure Sleep( ATimeout : Integer)');
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('ApplicationHasPriority', 'Boolean', iptrw);
    RegisterProperty('IdleTimeOut', 'integer', iptrw);
    RegisterProperty('OnlyWhenIdle', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdAntiFreezeBase(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('ID_Default_TIdAntiFreezeBase_Active','Boolean').SetInt(1);
 CL.AddConstantN('ID_Default_TIdAntiFreezeBase_ApplicationHasPriority','Boolean').SetInt(1);
 CL.AddConstantN('ID_Default_TIdAntiFreezeBase_IdleTimeOut','LongInt').SetInt( 250);
 CL.AddConstantN('ID_Default_TIdAntiFreezeBase_OnlyWhenIdle','Boolean').SetInt( 250);
  SIRegister_TIdAntiFreezeBase(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdAntiFreezeBaseOnlyWhenIdle_W(Self: TIdAntiFreezeBase; const T: Boolean);
begin Self.OnlyWhenIdle := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAntiFreezeBaseOnlyWhenIdle_R(Self: TIdAntiFreezeBase; var T: Boolean);
begin T := Self.OnlyWhenIdle; end;

(*----------------------------------------------------------------------------*)
procedure TIdAntiFreezeBaseIdleTimeOut_W(Self: TIdAntiFreezeBase; const T: integer);
begin Self.IdleTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAntiFreezeBaseIdleTimeOut_R(Self: TIdAntiFreezeBase; var T: integer);
begin T := Self.IdleTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TIdAntiFreezeBaseApplicationHasPriority_W(Self: TIdAntiFreezeBase; const T: Boolean);
begin Self.ApplicationHasPriority := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAntiFreezeBaseApplicationHasPriority_R(Self: TIdAntiFreezeBase; var T: Boolean);
begin T := Self.ApplicationHasPriority; end;

(*----------------------------------------------------------------------------*)
procedure TIdAntiFreezeBaseActive_W(Self: TIdAntiFreezeBase; const T: boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdAntiFreezeBaseActive_R(Self: TIdAntiFreezeBase; var T: boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdAntiFreezeBase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdAntiFreezeBase) do begin
    RegisterConstructor(@TIdAntiFreezeBase.Create, 'Create');
          RegisterMethod(@TIdAntiFreezeBase.Destroy, 'Free');
    RegisterMethod(@TIdAntiFreezeBase.DoProcess, 'DoProcess');
    //RegisterVirtualAbstractMethod(@TIdAntiFreezeBase, @!.Process, 'Process');
    RegisterMethod(@TIdAntiFreezeBase.ShouldUse, 'ShouldUse');
    RegisterMethod(@TIdAntiFreezeBase.Sleep, 'Sleep');
    RegisterPropertyHelper(@TIdAntiFreezeBaseActive_R,@TIdAntiFreezeBaseActive_W,'Active');
    RegisterPropertyHelper(@TIdAntiFreezeBaseApplicationHasPriority_R,@TIdAntiFreezeBaseApplicationHasPriority_W,'ApplicationHasPriority');
    RegisterPropertyHelper(@TIdAntiFreezeBaseIdleTimeOut_R,@TIdAntiFreezeBaseIdleTimeOut_W,'IdleTimeOut');
    RegisterPropertyHelper(@TIdAntiFreezeBaseOnlyWhenIdle_R,@TIdAntiFreezeBaseOnlyWhenIdle_W,'OnlyWhenIdle');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdAntiFreezeBase(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdAntiFreezeBase(CL);
end;

 
 
{ TPSImport_IdAntiFreezeBase }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdAntiFreezeBase.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdAntiFreezeBase(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdAntiFreezeBase.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdAntiFreezeBase(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
