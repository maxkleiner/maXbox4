unit uPSI_SysInfoCtrls;
{
old for baseline

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
  TPSImport_SysInfoCtrls = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TSystemInfo2(CL: TPSPascalCompiler);
procedure SIRegister_TWinInfo(CL: TPSPascalCompiler);
procedure SIRegister_TOtherInfo(CL: TPSPascalCompiler);
procedure SIRegister_SysInfoCtrls(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SysInfoCtrls_Routines(S: TPSExec);
procedure RIRegister_TSystemInfo2(CL: TPSRuntimeClassImporter);
procedure RIRegister_TWinInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOtherInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_SysInfoCtrls(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Messages
  ,Windows
  ,Registry
  ,SysInfoCtrls
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SysInfoCtrls]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSystemInfo2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TSystemInfo') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TSystemInfo2') do begin
    RegisterProperty('ComputerName', 'string', iptr);
    RegisterProperty('CPUIdentifier', 'string', iptr);
    RegisterProperty('CPUVendor', 'string', iptr);
    RegisterProperty('SerialPorts', 'string', iptr);
    RegisterProperty('AdapterType', 'string', iptr);
    RegisterProperty('NetworkPrimaryProvider', 'string', iptr);
    RegisterProperty('NetworkUsername', 'string', iptr);
    RegisterProperty('Printer', 'string', iptr);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TWinInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TWinInfo') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TWinInfo') do begin
    RegisterProperty('UserName', 'string', iptr);
    RegisterProperty('CompanyName', 'string', iptr);
    RegisterProperty('WinVer', 'string', iptr);
    RegisterProperty('WinVerNo', 'string', iptr);
    RegisterProperty('ProductName', 'string', iptr);
    RegisterProperty('ProductID', 'string', iptr);
    RegisterProperty('ProductKey', 'string', iptr);
    RegisterProperty('CfgPath', 'string', iptr);
    RegisterProperty('ProgramDir', 'string', iptr);
    RegisterProperty('SysRoot', 'string', iptr);
    RegisterProperty('PlusVer', 'string', iptr);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOtherInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TOtherInfo') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TOtherInfo') do begin
    RegisterProperty('Date', 'string', iptr);
    RegisterProperty('Resolution', 'string', iptr);
    RegisterProperty('DirectXVer', 'string', iptr);
    RegisterProperty('About', 'string', iptr);
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SysInfoCtrls(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('About','String').SetString( 'InfoCtrl component written by Simone Di Cicco');
 CL.AddConstantN('DateFormatEU','String').SetString( 'dd/mm/yyyy');
  SIRegister_TOtherInfo(CL);
  SIRegister_TWinInfo(CL);
  SIRegister_TSystemInfo2(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSystemInfoPrinter_R(Self: TSystemInfo2; var T: string);
begin T := Self.Printer; end;

(*----------------------------------------------------------------------------*)
procedure TSystemInfoNetworkUsername_R(Self: TSystemInfo2; var T: string);
begin T := Self.NetworkUsername; end;

(*----------------------------------------------------------------------------*)
procedure TSystemInfoNetworkPrimaryProvider_R(Self: TSystemInfo2; var T: string);
begin T := Self.NetworkPrimaryProvider; end;

(*----------------------------------------------------------------------------*)
procedure TSystemInfoAdapterType_R(Self: TSystemInfo2; var T: string);
begin T := Self.AdapterType; end;

(*----------------------------------------------------------------------------*)
procedure TSystemInfoSerialPorts_R(Self: TSystemInfo2; var T: string);
begin T := Self.SerialPorts; end;

(*----------------------------------------------------------------------------*)
procedure TSystemInfoCPUVendor_R(Self: TSystemInfo2; var T: string);
begin T := Self.CPUVendor; end;

(*----------------------------------------------------------------------------*)
procedure TSystemInfoCPUIdentifier_R(Self: TSystemInfo2; var T: string);
begin T := Self.CPUIdentifier; end;

(*----------------------------------------------------------------------------*)
procedure TSystemInfoComputerName_R(Self: TSystemInfo2; var T: string);
begin T := Self.ComputerName; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoPlusVer_R(Self: TWinInfo; var T: string);
begin T := Self.PlusVer; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoSysRoot_R(Self: TWinInfo; var T: string);
begin T := Self.SysRoot; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoProgramDir_R(Self: TWinInfo; var T: string);
begin T := Self.ProgramDir; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoCfgPath_R(Self: TWinInfo; var T: string);
begin T := Self.CfgPath; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoProductKey_R(Self: TWinInfo; var T: string);
begin T := Self.ProductKey; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoProductID_R(Self: TWinInfo; var T: string);
begin T := Self.ProductID; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoProductName_R(Self: TWinInfo; var T: string);
begin T := Self.ProductName; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoWinVerNo_R(Self: TWinInfo; var T: string);
begin T := Self.WinVerNo; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoWinVer_R(Self: TWinInfo; var T: string);
begin T := Self.WinVer; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoCompanyName_R(Self: TWinInfo; var T: string);
begin T := Self.CompanyName; end;

(*----------------------------------------------------------------------------*)
procedure TWinInfoUserName_R(Self: TWinInfo; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TOtherInfoAbout_R(Self: TOtherInfo; var T: string);
begin T := Self.About; end;

(*----------------------------------------------------------------------------*)
procedure TOtherInfoDirectXVer_R(Self: TOtherInfo; var T: string);
begin T := Self.DirectXVer; end;

(*----------------------------------------------------------------------------*)
procedure TOtherInfoResolution_R(Self: TOtherInfo; var T: string);
begin T := Self.Resolution; end;

(*----------------------------------------------------------------------------*)
procedure TOtherInfoDate_R(Self: TOtherInfo; var T: string);
begin T := Self.Date; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SysInfoCtrls_Routines(S: TPSExec);
begin
// S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSystemInfo2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSystemInfo2) do
  begin
    RegisterPropertyHelper(@TSystemInfoComputerName_R,nil,'ComputerName');
    RegisterPropertyHelper(@TSystemInfoCPUIdentifier_R,nil,'CPUIdentifier');
    RegisterPropertyHelper(@TSystemInfoCPUVendor_R,nil,'CPUVendor');
    RegisterPropertyHelper(@TSystemInfoSerialPorts_R,nil,'SerialPorts');
    RegisterPropertyHelper(@TSystemInfoAdapterType_R,nil,'AdapterType');
    RegisterPropertyHelper(@TSystemInfoNetworkPrimaryProvider_R,nil,'NetworkPrimaryProvider');
    RegisterPropertyHelper(@TSystemInfoNetworkUsername_R,nil,'NetworkUsername');
    RegisterPropertyHelper(@TSystemInfoPrinter_R,nil,'Printer');
    RegisterConstructor(@TSystemInfo2.Create, 'Create');
     RegisterMethod(@TSystemInfo2.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TWinInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TWinInfo) do
  begin
    RegisterPropertyHelper(@TWinInfoUserName_R,nil,'UserName');
    RegisterPropertyHelper(@TWinInfoCompanyName_R,nil,'CompanyName');
    RegisterPropertyHelper(@TWinInfoWinVer_R,nil,'WinVer');
    RegisterPropertyHelper(@TWinInfoWinVerNo_R,nil,'WinVerNo');
    RegisterPropertyHelper(@TWinInfoProductName_R,nil,'ProductName');
    RegisterPropertyHelper(@TWinInfoProductID_R,nil,'ProductID');
    RegisterPropertyHelper(@TWinInfoProductKey_R,nil,'ProductKey');
    RegisterPropertyHelper(@TWinInfoCfgPath_R,nil,'CfgPath');
    RegisterPropertyHelper(@TWinInfoProgramDir_R,nil,'ProgramDir');
    RegisterPropertyHelper(@TWinInfoSysRoot_R,nil,'SysRoot');
    RegisterPropertyHelper(@TWinInfoPlusVer_R,nil,'PlusVer');
    RegisterConstructor(@TWinInfo.Create, 'Create');
     RegisterMethod(@TWinInfo.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOtherInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOtherInfo) do
  begin
    RegisterPropertyHelper(@TOtherInfoDate_R,nil,'Date');
    RegisterPropertyHelper(@TOtherInfoResolution_R,nil,'Resolution');
    RegisterPropertyHelper(@TOtherInfoDirectXVer_R,nil,'DirectXVer');
    RegisterPropertyHelper(@TOtherInfoAbout_R,nil,'About');
    RegisterConstructor(@TOtherInfo.Create, 'Create');
     RegisterMethod(@TOtherInfo.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SysInfoCtrls(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOtherInfo(CL);
  RIRegister_TWinInfo(CL);
  RIRegister_TSystemInfo2(CL);
end;

 
 
{ TPSImport_SysInfoCtrls }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysInfoCtrls.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SysInfoCtrls(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysInfoCtrls.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SysInfoCtrls(ri);
  RIRegister_SysInfoCtrls_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
