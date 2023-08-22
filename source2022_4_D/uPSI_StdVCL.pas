unit uPSI_StdVCL;
{
   for ole and activex to base intf
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
  TPSImport_StdVCL = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IDataBroker(CL: TPSPascalCompiler);
procedure SIRegister_IStrings(CL: TPSPascalCompiler);
procedure SIRegister_IProvider(CL: TPSPascalCompiler);
procedure SIRegister_StdVCL(CL: TPSPascalCompiler);

{ run-time registration functions }

procedure Register;

implementation


uses
   StdVCL
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StdVCL]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IDataBroker(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IDataBroker') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IDataBroker, 'IDataBroker') do
  begin
    RegisterMethod('Function GetProviderNames : OleVariant', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IStrings(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IStrings') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IStrings, 'IStrings') do begin
    RegisterMethod('Function Get_ControlDefault( Index : Integer) : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_ControlDefault( Index : Integer; Value : OleVariant)', CdStdCall);
    RegisterMethod('Function Count : Integer', CdStdCall);
    RegisterMethod('Function Get_Item( Index : Integer) : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Item( Index : Integer; Value : OleVariant)', CdStdCall);
    RegisterMethod('Procedure Remove( Index : Integer)', CdStdCall);
    RegisterMethod('Procedure Clear', CdStdCall);
    RegisterMethod('Function Add( Item : OleVariant) : Integer', CdStdCall);
    RegisterMethod('Function _NewEnum : IUnknown', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IProvider(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'IProvider') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),IProvider, 'IProvider') do begin
    RegisterMethod('Function Get_Data : OleVariant', CdStdCall);
    RegisterMethod('Function ApplyUpdates( Delta : OleVariant; MaxErrors : Integer; out ErrorCount : Integer) : OleVariant', CdStdCall);
    RegisterMethod('Function GetMetaData : OleVariant', CdStdCall);
    RegisterMethod('Function GetRecords( Count : Integer; out RecsOut : Integer) : OleVariant', CdStdCall);
    RegisterMethod('Function DataRequest( Input : OleVariant) : OleVariant', CdStdCall);
    RegisterMethod('Function Get_Constraints : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_Constraints( Value : WordBool)', CdStdCall);
    RegisterMethod('Procedure Reset( MetaData : WordBool)', CdStdCall);
    RegisterMethod('Procedure SetParams( Values : OleVariant)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StdVCL(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('LIBID_StdVCL','string').SetString( '{EE05DFE0-5549-11D0-9EA9-0020AF3D82DA}');
 CL.AddConstantN('IID_IProvider','string').SetString( '{6E644935-51F7-11D0-8D41-00A0248E4B9A}');
 CL.AddConstantN('IID_IStrings','string').SetString( '{EE05DFE2-5549-11D0-9EA9-0020AF3D82DA}');
 CL.AddConstantN('IID_IDataBroker','string').SetString( '{6539BF65-6FE7-11D0-9E8C-00A02457621F}');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IProvider, 'IProvider');
  //CL.AddTypeS('IProviderDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IStrings, 'IStrings');
  //CL.AddTypeS('IStringsDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDataBroker, 'IDataBroker');
  //CL.AddTypeS('IDataBrokerDisp', 'dispinterface');
  SIRegister_IProvider(CL);
  SIRegister_IStrings(CL);
  SIRegister_IDataBroker(CL);
end;

(* === run-time registration functions === *)
 
 
{ TPSImport_StdVCL }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StdVCL.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StdVCL(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StdVCL.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
