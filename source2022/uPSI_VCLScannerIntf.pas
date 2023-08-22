unit uPSI_VCLScannerIntf;
{
template framework for ws in maXbox

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
  TPSImport_VCLScannerIntf = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IVCLOrchestrator(CL: TPSPascalCompiler);
procedure SIRegister_IVCLScanner(CL: TPSPascalCompiler);
procedure SIRegister_VCLScannerIntf(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure Register;

implementation


uses
   InvokeRegistry
  ,Types
  ,XSBuiltIns
  ,VCLScannerIntf
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VCLScannerIntf]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IVCLOrchestrator(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInvokable', 'IVCLOrchestrator') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IVCLOrchestrator, 'IVCLOrchestrator') do
  begin
    RegisterMethod('Function SetSequence( S, Localizar, Substituir : shortstring) : shortstring', CdStdCall);
    RegisterMethod('Procedure lineToNumber( xmemo : String; met : boolean)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IVCLScanner(CL: TPSPascalCompiler);
begin
   //TVCLScanner = class(TInvokableClass, IVCLScanner)

  //with RegInterfaceS(CL,'IInvokable', 'IVCLScanner') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IVCLScanner, 'IVCLScanner') do begin
    RegisterMethod('Function PostData( const UserData : WideString; const CheckSum : DWORD) : Boolean', CdStdCall);
    RegisterMethod('Procedure PostUser( const Email, FirstName, LastName : WideString)', CdStdCall);
    RegisterMethod('Function GetTicketNr : longint', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_VCLScannerIntf(CL: TPSPascalCompiler);
begin
  InvRegistry.RegisterInterface(TypeInfo(IVCLScanner),'','',SintfDocScan);
  InvRegistry.RegisterInterface(TypeInfo(IVCLOrchestrator),'','',SintfDocOrch);
  SIRegister_IVCLScanner(CL);
  SIRegister_IVCLOrchestrator(CL);

end;

(* === run-time registration functions === *)
 
 
{ TPSImport_VCLScannerIntf }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VCLScannerIntf.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VCLScannerIntf(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VCLScannerIntf.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
