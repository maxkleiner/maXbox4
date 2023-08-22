unit uPSI_JvSimPID;
{
  direct utils
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
  TPSImport_JvSimPID = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvSimPID(CL: TPSPascalCompiler);
procedure SIRegister_JvSimPID(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvSimPID(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvSimPID(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,Messages
  ,Graphics
  //,Controls
  ,JvComponent
  ,JvSimPID
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvSimPID]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvSimPID(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvGraphicControl', 'TJvSimPID') do
  with CL.AddClassN(CL.FindClass('TJvGraphicControl'),'TJvSimPID') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Execute');
    RegisterProperty('SymFunc', 'TJvSymFunc', iptrw);
    RegisterProperty('Source', 'TJvSimPID', iptrw);
    RegisterProperty('MV', 'Extended', iptrw);
    RegisterProperty('MVColor', 'TColor', iptrw);
    RegisterProperty('SP', 'Extended', iptrw);
    RegisterProperty('SPColor', 'TColor', iptrw);
    RegisterProperty('CV', 'Extended', iptrw);
    RegisterProperty('CVColor', 'TColor', iptrw);
    RegisterProperty('KP', 'Extended', iptrw);
    RegisterProperty('KI', 'Extended', iptrw);
    RegisterProperty('KD', 'Extended', iptrw);
    RegisterProperty('Direct', 'Boolean', iptrw);
    RegisterProperty('Manual', 'Boolean', iptrw);
    RegisterProperty('Active', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvSimPID(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TJvSymFunc', '( sfPid, sfAdd, sfCompare, sfRamp, sfMul )');
  SIRegister_TJvSimPID(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvSimPIDActive_W(Self: TJvSimPID; const T: Boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDActive_R(Self: TJvSimPID; var T: Boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDManual_W(Self: TJvSimPID; const T: Boolean);
begin Self.Manual := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDManual_R(Self: TJvSimPID; var T: Boolean);
begin T := Self.Manual; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDDirect_W(Self: TJvSimPID; const T: Boolean);
begin Self.Direct := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDDirect_R(Self: TJvSimPID; var T: Boolean);
begin T := Self.Direct; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDKD_W(Self: TJvSimPID; const T: Extended);
begin Self.KD := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDKD_R(Self: TJvSimPID; var T: Extended);
begin T := Self.KD; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDKI_W(Self: TJvSimPID; const T: Extended);
begin Self.KI := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDKI_R(Self: TJvSimPID; var T: Extended);
begin T := Self.KI; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDKP_W(Self: TJvSimPID; const T: Extended);
begin Self.KP := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDKP_R(Self: TJvSimPID; var T: Extended);
begin T := Self.KP; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDCVColor_W(Self: TJvSimPID; const T: TColor);
begin Self.CVColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDCVColor_R(Self: TJvSimPID; var T: TColor);
begin T := Self.CVColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDCV_W(Self: TJvSimPID; const T: Extended);
begin Self.CV := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDCV_R(Self: TJvSimPID; var T: Extended);
begin T := Self.CV; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDSPColor_W(Self: TJvSimPID; const T: TColor);
begin Self.SPColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDSPColor_R(Self: TJvSimPID; var T: TColor);
begin T := Self.SPColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDSP_W(Self: TJvSimPID; const T: Extended);
begin Self.SP := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDSP_R(Self: TJvSimPID; var T: Extended);
begin T := Self.SP; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDMVColor_W(Self: TJvSimPID; const T: TColor);
begin Self.MVColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDMVColor_R(Self: TJvSimPID; var T: TColor);
begin T := Self.MVColor; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDMV_W(Self: TJvSimPID; const T: Extended);
begin Self.MV := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDMV_R(Self: TJvSimPID; var T: Extended);
begin T := Self.MV; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDSource_W(Self: TJvSimPID; const T: TJvSimPID);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDSource_R(Self: TJvSimPID; var T: TJvSimPID);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDSymFunc_W(Self: TJvSimPID; const T: TJvSymFunc);
begin Self.SymFunc := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvSimPIDSymFunc_R(Self: TJvSimPID; var T: TJvSymFunc);
begin T := Self.SymFunc; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvSimPID(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvSimPID) do begin
    RegisterConstructor(@TJvSimPID.Create, 'Create');
    RegisterMethod(@TJvSimPID.Execute, 'Execute');
    RegisterPropertyHelper(@TJvSimPIDSymFunc_R,@TJvSimPIDSymFunc_W,'SymFunc');
    RegisterPropertyHelper(@TJvSimPIDSource_R,@TJvSimPIDSource_W,'Source');
    RegisterPropertyHelper(@TJvSimPIDMV_R,@TJvSimPIDMV_W,'MV');
    RegisterPropertyHelper(@TJvSimPIDMVColor_R,@TJvSimPIDMVColor_W,'MVColor');
    RegisterPropertyHelper(@TJvSimPIDSP_R,@TJvSimPIDSP_W,'SP');
    RegisterPropertyHelper(@TJvSimPIDSPColor_R,@TJvSimPIDSPColor_W,'SPColor');
    RegisterPropertyHelper(@TJvSimPIDCV_R,@TJvSimPIDCV_W,'CV');
    RegisterPropertyHelper(@TJvSimPIDCVColor_R,@TJvSimPIDCVColor_W,'CVColor');
    RegisterPropertyHelper(@TJvSimPIDKP_R,@TJvSimPIDKP_W,'KP');
    RegisterPropertyHelper(@TJvSimPIDKI_R,@TJvSimPIDKI_W,'KI');
    RegisterPropertyHelper(@TJvSimPIDKD_R,@TJvSimPIDKD_W,'KD');
    RegisterPropertyHelper(@TJvSimPIDDirect_R,@TJvSimPIDDirect_W,'Direct');
    RegisterPropertyHelper(@TJvSimPIDManual_R,@TJvSimPIDManual_W,'Manual');
    RegisterPropertyHelper(@TJvSimPIDActive_R,@TJvSimPIDActive_W,'Active');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvSimPID(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvSimPID(CL);
end;

 
 
{ TPSImport_JvSimPID }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimPID.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvSimPID(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvSimPID.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvSimPID(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
