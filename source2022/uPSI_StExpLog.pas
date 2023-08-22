unit uPSI_StExpLog;
{
  SysTools4
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
  TPSImport_StExpLog = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStExceptionLog(CL: TPSPascalCompiler);
procedure SIRegister_StExpLog(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStExceptionLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_StExpLog(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StExpLog
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StExpLog]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStExceptionLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStExceptionLog') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStExceptionLog') do begin
    RegisterMethod('Constructor Create( Owner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure DoExceptionFilter( E : Exception; var PutInLog : Boolean)');
    RegisterProperty('Enabled', 'Boolean', iptrw);
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('RipInfo', 'string', iptrw);
    RegisterProperty('OnExceptionFilter', 'TStOnExceptionFilter', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StExpLog(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStOnExceptionFilter', 'Procedure ( Sender : TObject; E : Except'
   +'ion; var PutInLog : Boolean)');
  SIRegister_TStExceptionLog(CL);
 //CL.AddConstantN('ExpLog','TStExceptionLog').SetString('NIL');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStExceptionLogOnExceptionFilter_W(Self: TStExceptionLog; const T: TStOnExceptionFilter);
begin Self.OnExceptionFilter := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExceptionLogOnExceptionFilter_R(Self: TStExceptionLog; var T: TStOnExceptionFilter);
begin T := Self.OnExceptionFilter; end;

(*----------------------------------------------------------------------------*)
procedure TStExceptionLogRipInfo_W(Self: TStExceptionLog; const T: string);
begin Self.RipInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExceptionLogRipInfo_R(Self: TStExceptionLog; var T: string);
begin T := Self.RipInfo; end;

(*----------------------------------------------------------------------------*)
procedure TStExceptionLogFileName_W(Self: TStExceptionLog; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExceptionLogFileName_R(Self: TStExceptionLog; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TStExceptionLogEnabled_W(Self: TStExceptionLog; const T: Boolean);
begin Self.Enabled := T; end;

(*----------------------------------------------------------------------------*)
procedure TStExceptionLogEnabled_R(Self: TStExceptionLog; var T: Boolean);
begin T := Self.Enabled; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStExceptionLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStExceptionLog) do begin
    RegisterConstructor(@TStExceptionLog.Create, 'Create');
      RegisterMethod(@TStExceptionLog.Destroy, 'Free');
      RegisterVirtualMethod(@TStExceptionLog.DoExceptionFilter, 'DoExceptionFilter');
    RegisterPropertyHelper(@TStExceptionLogEnabled_R,@TStExceptionLogEnabled_W,'Enabled');
    RegisterPropertyHelper(@TStExceptionLogFileName_R,@TStExceptionLogFileName_W,'FileName');
    RegisterPropertyHelper(@TStExceptionLogRipInfo_R,@TStExceptionLogRipInfo_W,'RipInfo');
    RegisterPropertyHelper(@TStExceptionLogOnExceptionFilter_R,@TStExceptionLogOnExceptionFilter_W,'OnExceptionFilter');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StExpLog(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStExceptionLog(CL);
end;

 
 
{ TPSImport_StExpLog }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StExpLog.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StExpLog(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StExpLog.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StExpLog(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
