unit uPSI_IdTime;
{

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
  TPSImport_IdTime = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdTime(CL: TPSPascalCompiler);
procedure SIRegister_IdTime(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdTime(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdTime(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdAssignedNumbers
  ,IdTCPClient
  ,IdTime
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdTime]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdTime(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdTCPClient', 'TIdTime') do
  with CL.AddClassN(CL.FindClass('TIdTCPClient'),'TIdTime') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Function SyncTime : Boolean');
    RegisterProperty('DateTimeCard', 'Cardinal', iptr);
    RegisterProperty('DateTime', 'TDateTime', iptr);
    RegisterProperty('RoundTripDelay', 'Cardinal', iptr);
    RegisterProperty('BaseDate', 'TDateTime', iptrw);
    RegisterProperty('Timeout', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdTime(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('TIME_BASEDATE','LongInt').SetInt( 2);
 CL.AddConstantN('TIME_TIMEOUT','LongInt').SetInt( 2500);
  SIRegister_TIdTime(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdTimeTimeout_W(Self: TIdTime; const T: Integer);
begin Self.Timeout := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeTimeout_R(Self: TIdTime; var T: Integer);
begin T := Self.Timeout; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeBaseDate_W(Self: TIdTime; const T: TDateTime);
begin Self.BaseDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeBaseDate_R(Self: TIdTime; var T: TDateTime);
begin T := Self.BaseDate; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeRoundTripDelay_R(Self: TIdTime; var T: Cardinal);
begin T := Self.RoundTripDelay; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeDateTime_R(Self: TIdTime; var T: TDateTime);
begin T := Self.DateTime; end;

(*----------------------------------------------------------------------------*)
procedure TIdTimeDateTimeCard_R(Self: TIdTime; var T: Cardinal);
begin T := Self.DateTimeCard; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdTime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdTime) do begin
    RegisterConstructor(@TIdTime.Create, 'Create');
    RegisterMethod(@TIdTime.Destroy, 'Free');
    RegisterMethod(@TIdTime.SyncTime, 'SyncTime');
    RegisterPropertyHelper(@TIdTimeDateTimeCard_R,nil,'DateTimeCard');
    RegisterPropertyHelper(@TIdTimeDateTime_R,nil,'DateTime');
    RegisterPropertyHelper(@TIdTimeRoundTripDelay_R,nil,'RoundTripDelay');
    RegisterPropertyHelper(@TIdTimeBaseDate_R,@TIdTimeBaseDate_W,'BaseDate');
    RegisterPropertyHelper(@TIdTimeTimeout_R,@TIdTimeTimeout_W,'Timeout');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdTime(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdTime(CL);
end;

 
 
{ TPSImport_IdTime }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTime.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdTime(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdTime.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdTime(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
