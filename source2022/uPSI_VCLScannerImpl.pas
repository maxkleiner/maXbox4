unit uPSI_VCLScannerImpl;
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
  TPSImport_VCLScannerImpl = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TVCLOrchestrator(CL: TPSPascalCompiler);
procedure SIRegister_TVCLScanner(CL: TPSPascalCompiler);
procedure SIRegister_VCLScannerImpl(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TVCLOrchestrator(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVCLScanner(CL: TPSRuntimeClassImporter);
procedure RIRegister_VCLScannerImpl(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   InvokeRegistry
  ,Types
  ,XSBuiltIns
  ,VCLScannerIntf
  ,VCLScannerImpl
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_VCLScannerImpl]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TVCLOrchestrator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInvokableClass', 'TVCLOrchestrator') do
  with CL.AddClassN(CL.FindClass('TInvokableClass'),'TVCLOrchestrator') do begin
    RegisterMethod('Function SetSequence( S, Localizar, Substituir : shortstring) : shortstring');
    RegisterMethod('Procedure lineToNumber( xmemo : String; met : boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVCLScanner(CL: TPSPascalCompiler);
begin
  //TVCLScanner = class(TInvokableClass, IVCLScanner)

  //with RegClassS(CL,'TInvokableClass', 'TVCLScanner') do
  with CL.AddClassN(CL.FindClass('TInvokableClass'),'TVCLScanner') do begin
    //CL.FindInterface('IVCLScanner');
    //CL.FindInterface('IInvokable'),IVCLScanner, 'IVCLScanner')
    RegisterMethod('Constructor Create;');
   //RegisterMethod('Constructor Create(AParent: TIdCustomHTTP);');
    RegisterMethod('Procedure Free;');
    //RegisterInterface
    RegisterMethod('Function PostData( const UserData : WideString; const CheckSum : integer): Boolean');
    RegisterMethod('Procedure PostUser( const Email, FirstName, LastName : WideString)');
    RegisterMethod('Function GetTicketNr : longint');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_VCLScannerImpl(CL: TPSPascalCompiler);
begin
  InvRegistry.RegisterInvokableClass(TVCLScanner);
  InvRegistry.RegisterInvokableClass(TVCLOrchestrator);
  SIRegister_TVCLScanner(CL);
  SIRegister_TVCLOrchestrator(CL);

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TVCLOrchestrator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVCLOrchestrator) do begin
    RegisterMethod(@TVCLOrchestrator.SetSequence, 'SetSequence');
    RegisterMethod(@TVCLOrchestrator.lineToNumber, 'lineToNumber');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVCLScanner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVCLScanner) do begin
    RegisterVirtualConstructor(@TVCLScanner.Create, 'Create');
    RegisterMethod(@TVCLScanner.Destroy, 'Free');

    RegisterMethod(@TVCLScanner.PostData, 'PostData');
    RegisterMethod(@TVCLScanner.PostUser, 'PostUser');
    RegisterMethod(@TVCLScanner.GetTicketNr, 'GetTicketNr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_VCLScannerImpl(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TVCLScanner(CL);
  RIRegister_TVCLOrchestrator(CL);
end;

 
 
{ TPSImport_VCLScannerImpl }
(*----------------------------------------------------------------------------*)
procedure TPSImport_VCLScannerImpl.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_VCLScannerImpl(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_VCLScannerImpl.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_VCLScannerImpl(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
