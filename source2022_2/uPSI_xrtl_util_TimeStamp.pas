unit uPSI_xrtl_util_TimeStamp;
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
  TPSImport_xrtl_util_TimeStamp = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TXRTLTimeStamp(CL: TPSPascalCompiler);
procedure SIRegister_xrtl_util_TimeStamp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TXRTLTimeStamp(CL: TPSRuntimeClassImporter);
procedure RIRegister_xrtl_util_TimeStamp(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,xrtl_util_Compare
  ,xrtl_util_TimeStamp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_xrtl_util_TimeStamp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TXRTLTimeStamp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TXRTLTimeStamp') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TXRTLTimeStamp') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure SetCurrentTime');
    RegisterMethod('Function Compare( const ATimeStamp : TXRTLTimeStamp) : TXRTLValueRelationship');
    RegisterProperty('UTCSystemTime', 'TSystemTime', iptrw);
    RegisterProperty('LocalSystemTime', 'TSystemTime', iptrw);
    RegisterProperty('UTCFileTime', 'TFileTime', iptrw);
    RegisterProperty('LocalFileTime', 'TFileTime', iptrw);
    RegisterProperty('UTCDateTime', 'TDateTime', iptrw);
    RegisterProperty('LocalDateTime', 'TDateTime', iptrw);
    RegisterProperty('UTCAge', 'Integer', iptrw);
    RegisterProperty('LocalAge', 'Integer', iptrw);
    RegisterProperty('UTCTimeStamp', 'TTimeStamp', iptrw);
    RegisterProperty('LocalTimeStamp', 'TTimeStamp', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_xrtl_util_TimeStamp(CL: TPSPascalCompiler);
begin
  SIRegister_TXRTLTimeStamp(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalTimeStamp_W(Self: TXRTLTimeStamp; const T: TTimeStamp);
begin Self.LocalTimeStamp := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalTimeStamp_R(Self: TXRTLTimeStamp; var T: TTimeStamp);
begin T := Self.LocalTimeStamp; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCTimeStamp_W(Self: TXRTLTimeStamp; const T: TTimeStamp);
begin Self.UTCTimeStamp := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCTimeStamp_R(Self: TXRTLTimeStamp; var T: TTimeStamp);
begin T := Self.UTCTimeStamp; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalAge_W(Self: TXRTLTimeStamp; const T: Integer);
begin Self.LocalAge := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalAge_R(Self: TXRTLTimeStamp; var T: Integer);
begin T := Self.LocalAge; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCAge_W(Self: TXRTLTimeStamp; const T: Integer);
begin Self.UTCAge := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCAge_R(Self: TXRTLTimeStamp; var T: Integer);
begin T := Self.UTCAge; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalDateTime_W(Self: TXRTLTimeStamp; const T: TDateTime);
begin Self.LocalDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalDateTime_R(Self: TXRTLTimeStamp; var T: TDateTime);
begin T := Self.LocalDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCDateTime_W(Self: TXRTLTimeStamp; const T: TDateTime);
begin Self.UTCDateTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCDateTime_R(Self: TXRTLTimeStamp; var T: TDateTime);
begin T := Self.UTCDateTime; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalFileTime_W(Self: TXRTLTimeStamp; const T: TFileTime);
begin Self.LocalFileTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalFileTime_R(Self: TXRTLTimeStamp; var T: TFileTime);
begin T := Self.LocalFileTime; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCFileTime_W(Self: TXRTLTimeStamp; const T: TFileTime);
begin Self.UTCFileTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCFileTime_R(Self: TXRTLTimeStamp; var T: TFileTime);
begin T := Self.UTCFileTime; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalSystemTime_W(Self: TXRTLTimeStamp; const T: TSystemTime);
begin Self.LocalSystemTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampLocalSystemTime_R(Self: TXRTLTimeStamp; var T: TSystemTime);
begin T := Self.LocalSystemTime; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCSystemTime_W(Self: TXRTLTimeStamp; const T: TSystemTime);
begin Self.UTCSystemTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TXRTLTimeStampUTCSystemTime_R(Self: TXRTLTimeStamp; var T: TSystemTime);
begin T := Self.UTCSystemTime; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TXRTLTimeStamp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXRTLTimeStamp) do begin
    RegisterConstructor(@TXRTLTimeStamp.Create, 'Create');
    RegisterMethod(@TXRTLTimeStamp.SetCurrentTime, 'SetCurrentTime');
    RegisterMethod(@TXRTLTimeStamp.Compare, 'Compare');
    RegisterPropertyHelper(@TXRTLTimeStampUTCSystemTime_R,@TXRTLTimeStampUTCSystemTime_W,'UTCSystemTime');
    RegisterPropertyHelper(@TXRTLTimeStampLocalSystemTime_R,@TXRTLTimeStampLocalSystemTime_W,'LocalSystemTime');
    RegisterPropertyHelper(@TXRTLTimeStampUTCFileTime_R,@TXRTLTimeStampUTCFileTime_W,'UTCFileTime');
    RegisterPropertyHelper(@TXRTLTimeStampLocalFileTime_R,@TXRTLTimeStampLocalFileTime_W,'LocalFileTime');
    RegisterPropertyHelper(@TXRTLTimeStampUTCDateTime_R,@TXRTLTimeStampUTCDateTime_W,'UTCDateTime');
    RegisterPropertyHelper(@TXRTLTimeStampLocalDateTime_R,@TXRTLTimeStampLocalDateTime_W,'LocalDateTime');
    RegisterPropertyHelper(@TXRTLTimeStampUTCAge_R,@TXRTLTimeStampUTCAge_W,'UTCAge');
    RegisterPropertyHelper(@TXRTLTimeStampLocalAge_R,@TXRTLTimeStampLocalAge_W,'LocalAge');
    RegisterPropertyHelper(@TXRTLTimeStampUTCTimeStamp_R,@TXRTLTimeStampUTCTimeStamp_W,'UTCTimeStamp');
    RegisterPropertyHelper(@TXRTLTimeStampLocalTimeStamp_R,@TXRTLTimeStampLocalTimeStamp_W,'LocalTimeStamp');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_xrtl_util_TimeStamp(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TXRTLTimeStamp(CL);
end;

 
 
{ TPSImport_xrtl_util_TimeStamp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_TimeStamp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_xrtl_util_TimeStamp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_xrtl_util_TimeStamp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_xrtl_util_TimeStamp(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
