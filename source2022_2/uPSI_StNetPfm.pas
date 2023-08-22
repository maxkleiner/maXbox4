unit uPSI_StNetPfm;
{
    with netcon and netmsg

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
  TPSImport_StNetPfm = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStNetPerformance(CL: TPSPascalCompiler);
procedure SIRegister_StNetPfm(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStNetPerformance(CL: TPSRuntimeClassImporter);
procedure RIRegister_StNetPfm(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,StBase
  ,StNetPfm
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StNetPfm]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNetPerformance(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStComponent', 'TStNetPerformance') do
  with CL.AddClassN(CL.FindClass('TStComponent'),'TStNetPerformance') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure QueryPerformance');
    RegisterProperty('Flags', 'TStCPFlagsSet', iptr);
    RegisterProperty('Speed', 'DWord', iptr);
    RegisterProperty('Delay', 'DWord', iptr);
    RegisterProperty('OptDataSize', 'DWord', iptr);
    RegisterProperty('LocalName', 'string', iptrw);
    RegisterProperty('RemoteName', 'string', iptrw);
    RegisterProperty('ProviderName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StNetPfm(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TStCPFlags', '( cpfForNetCard, cpfNotRouted, cpfSlowLink, cpfDynamic )');
  CL.AddTypeS('TStCPFlagsSet', 'set of TStCPFlags');
  SIRegister_TStNetPerformance(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceProviderName_W(Self: TStNetPerformance; const T: string);
begin Self.ProviderName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceProviderName_R(Self: TStNetPerformance; var T: string);
begin T := Self.ProviderName; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceRemoteName_W(Self: TStNetPerformance; const T: string);
begin Self.RemoteName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceRemoteName_R(Self: TStNetPerformance; var T: string);
begin T := Self.RemoteName; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceLocalName_W(Self: TStNetPerformance; const T: string);
begin Self.LocalName := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceLocalName_R(Self: TStNetPerformance; var T: string);
begin T := Self.LocalName; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceOptDataSize_R(Self: TStNetPerformance; var T: DWord);
begin T := Self.OptDataSize; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceDelay_R(Self: TStNetPerformance; var T: DWord);
begin T := Self.Delay; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceSpeed_R(Self: TStNetPerformance; var T: DWord);
begin T := Self.Speed; end;

(*----------------------------------------------------------------------------*)
procedure TStNetPerformanceFlags_R(Self: TStNetPerformance; var T: TStCPFlagsSet);
begin T := Self.Flags; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNetPerformance(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNetPerformance) do begin
    RegisterConstructor(@TStNetPerformance.Create, 'Create');
    RegisterMethod(@TStNetPerformance.Destroy, 'Free');
    RegisterMethod(@TStNetPerformance.QueryPerformance, 'QueryPerformance');
    RegisterPropertyHelper(@TStNetPerformanceFlags_R,nil,'Flags');
    RegisterPropertyHelper(@TStNetPerformanceSpeed_R,nil,'Speed');
    RegisterPropertyHelper(@TStNetPerformanceDelay_R,nil,'Delay');
    RegisterPropertyHelper(@TStNetPerformanceOptDataSize_R,nil,'OptDataSize');
    RegisterPropertyHelper(@TStNetPerformanceLocalName_R,@TStNetPerformanceLocalName_W,'LocalName');
    RegisterPropertyHelper(@TStNetPerformanceRemoteName_R,@TStNetPerformanceRemoteName_W,'RemoteName');
    RegisterPropertyHelper(@TStNetPerformanceProviderName_R,@TStNetPerformanceProviderName_W,'ProviderName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StNetPfm(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStNetPerformance(CL);
end;

 
 
{ TPSImport_StNetPfm }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNetPfm.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StNetPfm(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StNetPfm.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StNetPfm(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
