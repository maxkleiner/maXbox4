unit uPSI_WbemScripting_TLB;
{
  to do direct typed wmi
  iole enumvariant!  SIRegister_ISIEnumVARIANT

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
  TPSImport_WbemScripting_TLB = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_CoSWbemRefreshableItem(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemPrivilegeSet(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemPrivilege(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemSecurity(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemEventSource(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemMethodSet(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemMethod(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemPropertySet(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemProperty(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemQualifierSet(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemQualifier(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemNamedValue(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemObjectSet(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemObjectEx(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemObject(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemServicesEx(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemServices(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemRefresherProperties(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemRefresher(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemRefresher(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemDateTimeProperties(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemDateTime(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemDateTime(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemSinkProperties(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemSink(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemSink(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemLastErrorProperties(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemLastError(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemLastError(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemObjectPathProperties(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemObjectPath(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemObjectPath(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemNamedValueSetProperties(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemNamedValueSet(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemNamedValueSet(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemLocatorProperties(CL: TPSPascalCompiler);
procedure SIRegister_TSWbemLocator(CL: TPSPascalCompiler);
procedure SIRegister_CoSWbemLocator(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemRefreshableItem(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemRefresher(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemDateTime(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemObjectEx(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemServicesEx(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemSink(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemLastError(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemLocator(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemEventSource(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemMethod(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemMethodSet(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemProperty(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemPropertySet(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemQualifier(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemQualifierSet(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemObjectSet(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemPrivilege(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemPrivilegeSet(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemSecurity(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemNamedValue(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemNamedValueSet(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemObjectPath(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemObject(CL: TPSPascalCompiler);
procedure SIRegister_ISWbemServices(CL: TPSPascalCompiler);
procedure SIRegister_WbemScripting_TLB(CL: TPSPascalCompiler);
procedure SIRegister_ISIEnumVARIANT(CL: TPSPascalCompiler);


{ run-time registration functions }
procedure RIRegister_WbemScripting_TLB_Routines(S: TPSExec);
procedure RIRegister_CoSWbemRefreshableItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemPrivilegeSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemPrivilege(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemSecurity(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemEventSource(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemMethodSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemMethod(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemPropertySet(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemProperty(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemQualifierSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemQualifier(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemNamedValue(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemObjectSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemObjectEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemServicesEx(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemServices(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemRefresherProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemRefresher(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemRefresher(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemDateTimeProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemDateTime(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemDateTime(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemSinkProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemSink(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemSink(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemLastErrorProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemLastError(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemLastError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemObjectPathProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemObjectPath(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemObjectPath(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemNamedValueSetProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemNamedValueSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemNamedValueSet(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemLocatorProperties(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSWbemLocator(CL: TPSRuntimeClassImporter);
procedure RIRegister_CoSWbemLocator(CL: TPSRuntimeClassImporter);
procedure RIRegister_WbemScripting_TLB(CL: TPSRuntimeClassImporter);
procedure RIRegister_ISIEnumVARIANT(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,ActiveX
  ,Graphics
  ,OleServer
  ,StdVCL
  ,Variants
  ,WbemScripting_TLB
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WbemScripting_TLB]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemRefreshableItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemRefreshableItem') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemRefreshableItem') do
  begin
    RegisterMethod('Function Create : ISWbemRefreshableItem');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemRefreshableItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemPrivilegeSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemPrivilegeSet') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemPrivilegeSet') do
  begin
    RegisterMethod('Function Create : ISWbemPrivilegeSet');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemPrivilegeSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemPrivilege(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemPrivilege') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemPrivilege') do
  begin
    RegisterMethod('Function Create : ISWbemPrivilege');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemPrivilege');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemSecurity(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemSecurity') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemSecurity') do
  begin
    RegisterMethod('Function Create : ISWbemSecurity');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemSecurity');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemEventSource(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemEventSource') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemEventSource') do
  begin
    RegisterMethod('Function Create : ISWbemEventSource');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemEventSource');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemMethodSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemMethodSet') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemMethodSet') do
  begin
    RegisterMethod('Function Create : ISWbemMethodSet');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemMethodSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemMethod(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemMethod') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemMethod') do
  begin
    RegisterMethod('Function Create : ISWbemMethod');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemMethod');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemPropertySet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemPropertySet') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemPropertySet') do
  begin
    RegisterMethod('Function Create : ISWbemPropertySet');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemPropertySet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemProperty(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemProperty') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemProperty') do
  begin
    RegisterMethod('Function Create : ISWbemProperty');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemProperty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemQualifierSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemQualifierSet') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemQualifierSet') do
  begin
    RegisterMethod('Function Create : ISWbemQualifierSet');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemQualifierSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemQualifier(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemQualifier') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemQualifier') do
  begin
    RegisterMethod('Function Create : ISWbemQualifier');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemQualifier');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemNamedValue(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemNamedValue') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemNamedValue') do
  begin
    RegisterMethod('Function Create : ISWbemNamedValue');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemNamedValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemObjectSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemObjectSet') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemObjectSet') do
  begin
    RegisterMethod('Function Create : ISWbemObjectSet');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemObjectSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemObjectEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemObjectEx') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemObjectEx') do
  begin
    RegisterMethod('Function Create : ISWbemObjectEx');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemObjectEx');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemObject') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemObject') do
  begin
    RegisterMethod('Function Create : ISWbemObject');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemServicesEx(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemServicesEx') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemServicesEx') do
  begin
    RegisterMethod('Function Create : ISWbemServicesEx');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemServicesEx');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemServices(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemServices') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemServices') do
  begin
    RegisterMethod('Function Create : ISWbemServices');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemServices');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemRefresherProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSWbemRefresherProperties') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSWbemRefresherProperties') do
  begin
    RegisterProperty('DefaultInterface', 'ISWbemRefresher', iptr);
    RegisterProperty('AutoReconnect', 'WordBool', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemRefresher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TSWbemRefresher') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TSWbemRefresher') do
  begin
    RegisterMethod('Procedure ConnectTo( svrIntf : ISWbemRefresher)');
    RegisterMethod('Function Item( iIndex : Integer) : ISWbemRefreshableItem');
    RegisterMethod('Function Add( const objWbemServices : ISWbemServicesEx; const bsInstancePath : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemRefreshableItem');
    RegisterMethod('Function AddEnum( const objWbemServices : ISWbemServicesEx; const bsClassName : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemRefreshableItem');
    RegisterMethod('Procedure Remove( iIndex : Integer; iFlags : Integer)');
    RegisterMethod('Procedure Refresh( iFlags : Integer)');
    RegisterMethod('Procedure DeleteAll');
    RegisterProperty('DefaultInterface', 'ISWbemRefresher', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('AutoReconnect', 'WordBool', iptrw);
    RegisterProperty('Server', 'TSWbemRefresherProperties', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemRefresher(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemRefresher') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemRefresher') do
  begin
    RegisterMethod('Function Create : ISWbemRefresher');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemRefresher');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemDateTimeProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSWbemDateTimeProperties') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSWbemDateTimeProperties') do
  begin
    RegisterProperty('DefaultInterface', 'ISWbemDateTime', iptr);
    RegisterProperty('Value', 'WideString', iptrw);
    RegisterProperty('Year', 'Integer', iptrw);
    RegisterProperty('YearSpecified', 'WordBool', iptrw);
    RegisterProperty('Month', 'Integer', iptrw);
    RegisterProperty('MonthSpecified', 'WordBool', iptrw);
    RegisterProperty('Day', 'Integer', iptrw);
    RegisterProperty('DaySpecified', 'WordBool', iptrw);
    RegisterProperty('Hours', 'Integer', iptrw);
    RegisterProperty('HoursSpecified', 'WordBool', iptrw);
    RegisterProperty('Minutes', 'Integer', iptrw);
    RegisterProperty('MinutesSpecified', 'WordBool', iptrw);
    RegisterProperty('Seconds', 'Integer', iptrw);
    RegisterProperty('SecondsSpecified', 'WordBool', iptrw);
    RegisterProperty('Microseconds', 'Integer', iptrw);
    RegisterProperty('MicrosecondsSpecified', 'WordBool', iptrw);
    RegisterProperty('UTC', 'Integer', iptrw);
    RegisterProperty('UTCSpecified', 'WordBool', iptrw);
    RegisterProperty('IsInterval', 'WordBool', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemDateTime(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TSWbemDateTime') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TSWbemDateTime') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure ConnectTo( svrIntf : ISWbemDateTime)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function GetVarDate( bIsLocal : WordBool) : TDateTime');
    RegisterMethod('Procedure SetVarDate( dVarDate : TDateTime; bIsLocal : WordBool)');
    RegisterMethod('Function GetFileTime( bIsLocal : WordBool) : WideString');
    RegisterMethod('Procedure SetFileTime( const strFileTime : WideString; bIsLocal : WordBool)');
    RegisterProperty('DefaultInterface', 'ISWbemDateTime', iptr);
    RegisterProperty('Value', 'WideString', iptrw);
    RegisterProperty('Year', 'Integer', iptrw);
    RegisterProperty('YearSpecified', 'WordBool', iptrw);
    RegisterProperty('Month', 'Integer', iptrw);
    RegisterProperty('MonthSpecified', 'WordBool', iptrw);
    RegisterProperty('Day', 'Integer', iptrw);
    RegisterProperty('DaySpecified', 'WordBool', iptrw);
    RegisterProperty('Hours', 'Integer', iptrw);
    RegisterProperty('HoursSpecified', 'WordBool', iptrw);
    RegisterProperty('Minutes', 'Integer', iptrw);
    RegisterProperty('MinutesSpecified', 'WordBool', iptrw);
    RegisterProperty('Seconds', 'Integer', iptrw);
    RegisterProperty('SecondsSpecified', 'WordBool', iptrw);
    RegisterProperty('Microseconds', 'Integer', iptrw);
    RegisterProperty('MicrosecondsSpecified', 'WordBool', iptrw);
    RegisterProperty('UTC', 'Integer', iptrw);
    RegisterProperty('UTCSpecified', 'WordBool', iptrw);
    RegisterProperty('IsInterval', 'WordBool', iptrw);
    RegisterProperty('Server', 'TSWbemDateTimeProperties', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemDateTime(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemDateTime') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemDateTime') do
  begin
    RegisterMethod('Function Create : ISWbemDateTime');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemDateTime');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemSinkProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSWbemSinkProperties') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSWbemSinkProperties') do
  begin
    RegisterProperty('DefaultInterface', 'ISWbemSink', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemSink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TSWbemSink') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TSWbemSink') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure ConnectTo( svrIntf : ISWbemSink)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure Cancel');
    RegisterProperty('DefaultInterface', 'ISWbemSink', iptr);
    RegisterProperty('Server', 'TSWbemSinkProperties', iptr);
    RegisterProperty('OnObjectReady', 'TSWbemSinkOnObjectReady', iptrw);
    RegisterProperty('OnCompleted', 'TSWbemSinkOnCompleted', iptrw);
    RegisterProperty('OnProgress', 'TSWbemSinkOnProgress', iptrw);
    RegisterProperty('OnObjectPut', 'TSWbemSinkOnObjectPut', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemSink(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemSink') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemSink') do
  begin
    RegisterMethod('Function Create : ISWbemSink');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemSink');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemLastErrorProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSWbemLastErrorProperties') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSWbemLastErrorProperties') do
  begin
    RegisterProperty('DefaultInterface', 'ISWbemLastError', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemLastError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TSWbemLastError') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TSWbemLastError') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure ConnectTo( svrIntf : ISWbemLastError)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function Put_( iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectPath');
    RegisterMethod('Procedure PutAsync_( const objWbemSink : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)');
    RegisterMethod('Procedure Delete_( iFlags : Integer; const objWbemNamedValueSet : IDispatch)');
    RegisterMethod('Procedure DeleteAsync_( const objWbemSink : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)');
    RegisterMethod('Function Instances_( iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet');
    RegisterMethod('Procedure InstancesAsync_( const objWbemSink : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)');
    RegisterMethod('Function Subclasses_( iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet');
    RegisterMethod('Procedure SubclassesAsync_( const objWbemSink : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)');
    RegisterMethod('Function Associators_( const strAssocClass : WideString; const strResultClass : WideString; const strResultRole : WideString; const strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : WordBoo' +
      'l; const strRequiredAssocQualifier : WideString; const strRequiredQualifier : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet');
    RegisterMethod('Procedure AssociatorsAsync_( const objWbemSink : IDispatch; const strAssocClass : WideString; const strResultClass : WideString; const strResultRole : WideString; const strRole : WideString; bClassesO' +
      'nly : WordBool; bSchemaOnly : WordBool; const strRequiredAssocQualifier : WideString; const strRequiredQualifier : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAs' +
      'yncContext : IDispatch)');
    RegisterMethod('Function References_( const strResultClass : WideString; const strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : WordBool; const strRequiredQualifier : WideString; iFlags : Integer; const o' +
      'bjWbemNamedValueSet : IDispatch) : ISWbemObjectSet');
    RegisterMethod('Procedure ReferencesAsync_( const objWbemSink : IDispatch; const strResultClass : WideString; const strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : WordBool; const strRequiredQualifier : ' +
      'WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)');
    RegisterMethod('Function ExecMethod_( const strMethodName : WideString; const objWbemInParameters : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObject');
    RegisterMethod('Procedure ExecMethodAsync_( const objWbemSink : IDispatch; const strMethodName : WideString; const objWbemInParameters : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objW' +
      'bemAsyncContext : IDispatch)');
    RegisterMethod('Function Clone_ : ISWbemObject');
    RegisterMethod('Function GetObjectText_( iFlags : Integer) : WideString');
    RegisterMethod('Function SpawnDerivedClass_( iFlags : Integer) : ISWbemObject');
    RegisterMethod('Function SpawnInstance_( iFlags : Integer) : ISWbemObject');
    RegisterMethod('Function CompareTo_( const objWbemObject : IDispatch; iFlags : Integer) : WordBool');
    RegisterProperty('DefaultInterface', 'ISWbemLastError', iptr);
    RegisterProperty('Qualifiers_', 'ISWbemQualifierSet', iptr);
    RegisterProperty('Properties_', 'ISWbemPropertySet', iptr);
    RegisterProperty('Methods_', 'ISWbemMethodSet', iptr);
    RegisterProperty('Derivation_', 'OleVariant', iptr);
    RegisterProperty('Path_', 'ISWbemObjectPath', iptr);
    RegisterProperty('Security_', 'ISWbemSecurity', iptr);
    RegisterProperty('Server', 'TSWbemLastErrorProperties', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemLastError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemLastError') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemLastError') do
  begin
    RegisterMethod('Function Create : ISWbemLastError');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemLastError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemObjectPathProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSWbemObjectPathProperties') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSWbemObjectPathProperties') do
  begin
    RegisterProperty('DefaultInterface', 'ISWbemObjectPath', iptr);
    RegisterProperty('Path', 'WideString', iptrw);
    RegisterProperty('RelPath', 'WideString', iptrw);
    RegisterProperty('Server', 'WideString', iptrw);
    RegisterProperty('Namespace', 'WideString', iptrw);
    RegisterProperty('DisplayName', 'WideString', iptrw);
    RegisterProperty('Class_', 'WideString', iptrw);
    RegisterProperty('Locale', 'WideString', iptrw);
    RegisterProperty('Authority', 'WideString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemObjectPath(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TSWbemObjectPath') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TSWbemObjectPath') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure ConnectTo( svrIntf : ISWbemObjectPath)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Procedure SetAsClass');
    RegisterMethod('Procedure SetAsSingleton');
    RegisterProperty('DefaultInterface', 'ISWbemObjectPath', iptr);
    RegisterProperty('ParentNamespace', 'WideString', iptr);
    RegisterProperty('IsClass', 'WordBool', iptr);
    RegisterProperty('IsSingleton', 'WordBool', iptr);
    RegisterProperty('Keys', 'ISWbemNamedValueSet', iptr);
    RegisterProperty('Security_', 'ISWbemSecurity', iptr);
    RegisterProperty('Path', 'WideString', iptrw);
    RegisterProperty('RelPath', 'WideString', iptrw);
    RegisterProperty('Server', 'WideString', iptrw);
    RegisterProperty('Namespace', 'WideString', iptrw);
    RegisterProperty('DisplayName', 'WideString', iptrw);
    RegisterProperty('Class_', 'WideString', iptrw);
    RegisterProperty('Locale', 'WideString', iptrw);
    RegisterProperty('Authority', 'WideString', iptrw);
    RegisterProperty('Server', 'TSWbemObjectPathProperties', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemObjectPath(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemObjectPath') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemObjectPath') do
  begin
    RegisterMethod('Function Create : ISWbemObjectPath');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemObjectPath');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemNamedValueSetProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSWbemNamedValueSetProperties') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSWbemNamedValueSetProperties') do
  begin
    RegisterProperty('DefaultInterface', 'ISWbemNamedValueSet', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemNamedValueSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TSWbemNamedValueSet') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TSWbemNamedValueSet') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Procedure Connect');
    RegisterMethod('Procedure ConnectTo( svrIntf : ISWbemNamedValueSet)');
    RegisterMethod('Procedure Disconnect');
    RegisterMethod('Function Item( const strName : WideString; iFlags : Integer) : ISWbemNamedValue');
    RegisterMethod('Function Add( const strName : WideString; var varValue : OleVariant; iFlags : Integer) : ISWbemNamedValue');
    RegisterMethod('Procedure Remove( const strName : WideString; iFlags : Integer)');
    RegisterMethod('Function Clone : ISWbemNamedValueSet');
    RegisterMethod('Procedure DeleteAll');
    RegisterProperty('DefaultInterface', 'ISWbemNamedValueSet', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Server', 'TSWbemNamedValueSetProperties', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemNamedValueSet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemNamedValueSet') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemNamedValueSet') do
  begin
    RegisterMethod('Function Create : ISWbemNamedValueSet');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemNamedValueSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemLocatorProperties(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TSWbemLocatorProperties') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TSWbemLocatorProperties') do
  begin
    RegisterProperty('DefaultInterface', 'ISWbemLocator', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TSWbemLocator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOleServer', 'TSWbemLocator') do
  with CL.AddClassN(CL.FindClass('TOleServer'),'TSWbemLocator') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Connect');
   RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ConnectTo( svrIntf : ISWbemLocator)');
    RegisterMethod('Function ConnectServer( const strServer : WideString; const strNamespace : WideString; const strUser : WideString; const strPassword : WideString; const strLocale : WideString; const strAuthority : Wi' +
      'deString; iSecurityFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemServices');
    RegisterProperty('DefaultInterface', 'ISWbemLocator', iptr);
    RegisterProperty('Security_', 'ISWbemSecurity', iptr);
    RegisterProperty('Server', 'TSWbemLocatorProperties', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CoSWbemLocator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'CoSWbemLocator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'CoSWbemLocator') do
  begin
    RegisterMethod('Function Create : ISWbemLocator');
    RegisterMethod('Function CreateRemote( const MachineName : string) : ISWbemLocator');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemRefreshableItem(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemRefreshableItem') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemRefreshableItem, 'ISWbemRefreshableItem') do
  begin
    RegisterMethod('Function Get_Index : Integer', CdStdCall);
    RegisterMethod('Function Get_Refresher : ISWbemRefresher', CdStdCall);
    RegisterMethod('Function Get_IsSet : WordBool', CdStdCall);
    RegisterMethod('Function Get_Object_ : ISWbemObjectEx', CdStdCall);
    RegisterMethod('Function Get_ObjectSet : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure Remove( iFlags : Integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemRefresher(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemRefresher') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemRefresher, 'ISWbemRefresher') do
  begin
    RegisterMethod('Function Get__NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Function Item( iIndex : Integer) : ISWbemRefreshableItem', CdStdCall);
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function Add( const objWbemServices : ISWbemServicesEx; const bsInstancePath : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemRefreshableItem', CdStdCall);
    RegisterMethod('Function AddEnum( const objWbemServices : ISWbemServicesEx; const bsClassName : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemRefreshableItem', CdStdCall);
    RegisterMethod('Procedure Remove( iIndex : Integer; iFlags : Integer)', CdStdCall);
    RegisterMethod('Procedure Refresh( iFlags : Integer)', CdStdCall);
    RegisterMethod('Function Get_AutoReconnect : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_AutoReconnect( bCount : WordBool)', CdStdCall);
    RegisterMethod('Procedure DeleteAll', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemDateTime(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemDateTime') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemDateTime, 'ISWbemDateTime') do
  begin
    RegisterMethod('Function Get_Value : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Value( const strValue : WideString)', CdStdCall);
    RegisterMethod('Function Get_Year : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Year( iYear : Integer)', CdStdCall);
    RegisterMethod('Function Get_YearSpecified : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_YearSpecified( bYearSpecified : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Month : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Month( iMonth : Integer)', CdStdCall);
    RegisterMethod('Function Get_MonthSpecified : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_MonthSpecified( bMonthSpecified : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Day : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Day( iDay : Integer)', CdStdCall);
    RegisterMethod('Function Get_DaySpecified : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_DaySpecified( bDaySpecified : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Hours : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Hours( iHours : Integer)', CdStdCall);
    RegisterMethod('Function Get_HoursSpecified : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_HoursSpecified( bHoursSpecified : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Minutes : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Minutes( iMinutes : Integer)', CdStdCall);
    RegisterMethod('Function Get_MinutesSpecified : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_MinutesSpecified( bMinutesSpecified : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Seconds : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Seconds( iSeconds : Integer)', CdStdCall);
    RegisterMethod('Function Get_SecondsSpecified : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_SecondsSpecified( bSecondsSpecified : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Microseconds : Integer', CdStdCall);
    RegisterMethod('Procedure Set_Microseconds( iMicroseconds : Integer)', CdStdCall);
    RegisterMethod('Function Get_MicrosecondsSpecified : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_MicrosecondsSpecified( bMicrosecondsSpecified : WordBool)', CdStdCall);
    RegisterMethod('Function Get_UTC : Integer', CdStdCall);
    RegisterMethod('Procedure Set_UTC( iUTC : Integer)', CdStdCall);
    RegisterMethod('Function Get_UTCSpecified : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_UTCSpecified( bUTCSpecified : WordBool)', CdStdCall);
    RegisterMethod('Function Get_IsInterval : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_IsInterval( bIsInterval : WordBool)', CdStdCall);
    RegisterMethod('Function GetVarDate( bIsLocal : WordBool) : TDateTime', CdStdCall);
    RegisterMethod('Procedure SetVarDate( dVarDate : TDateTime; bIsLocal : WordBool)', CdStdCall);
    RegisterMethod('Function GetFileTime( bIsLocal : WordBool) : WideString', CdStdCall);
    RegisterMethod('Procedure SetFileTime( const strFileTime : WideString; bIsLocal : WordBool)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemObjectEx(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ISWbemObject', 'ISWbemObjectEx') do
  with CL.AddInterface(CL.FindInterface('ISWbemObject'),ISWbemObjectEx, 'ISWbemObjectEx') do
  begin
    RegisterMethod('Procedure Refresh_( iFlags : Integer; const objWbemNamedValueSet : IDispatch)', CdStdCall);
    RegisterMethod('Function Get_SystemProperties_ : ISWbemPropertySet', CdStdCall);
    RegisterMethod('Function GetText_( iObjectTextFormat : WbemObjectTextFormatEnum; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : WideString', CdStdCall);
    RegisterMethod('Procedure SetFromText_( const bsText : WideString; iObjectTextFormat : WbemObjectTextFormatEnum; iFlags : Integer; const objWbemNamedValueSet : IDispatch)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemServicesEx(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ISWbemServices', 'ISWbemServicesEx') do
  with CL.AddInterface(CL.FindInterface('ISWbemServices'),ISWbemServicesEx, 'ISWbemServicesEx') do
  begin
    RegisterMethod('Function Put( const objWbemObject : ISWbemObjectEx; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectPath', CdStdCall);
    RegisterMethod('Procedure PutAsync( const objWbemSink : ISWbemSink; const objWbemObject : ISWbemObjectEx; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemSink(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemSink') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemSink, 'ISWbemSink') do
  begin
    RegisterMethod('Procedure Cancel', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemLastError(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ISWbemObject', 'ISWbemLastError') do
  with CL.AddInterface(CL.FindInterface('ISWbemObject'),ISWbemLastError, 'ISWbemLastError') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemLocator(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemLocator') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemLocator, 'ISWbemLocator') do
  begin
    RegisterMethod('Function ConnectServer( const strServer : WideString; const strNamespace : WideString; const strUser : WideString; const strPassword : WideString; const strLocale : WideString; const strAuthority : Wi' +
      'deString; iSecurityFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemServices', CdStdCall);
    RegisterMethod('Function Get_Security_ : ISWbemSecurity', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemEventSource(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemEventSource') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemEventSource, 'ISWbemEventSource') do
  begin
    RegisterMethod('Function NextEvent( iTimeoutMs : Integer) : ISWbemObject', CdStdCall);
    RegisterMethod('Function Get_Security_ : ISWbemSecurity', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemMethod(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemMethod') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemMethod, 'ISWbemMethod') do
  begin
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Function Get_Origin : WideString', CdStdCall);
    RegisterMethod('Function Get_InParameters : ISWbemObject', CdStdCall);
    RegisterMethod('Function Get_OutParameters : ISWbemObject', CdStdCall);
    RegisterMethod('Function Get_Qualifiers_ : ISWbemQualifierSet', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemMethodSet(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemMethodSet') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemMethodSet, 'ISWbemMethodSet') do
  begin
    RegisterMethod('Function Get__NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Function Item( const strName : WideString; iFlags : Integer) : ISWbemMethod', CdStdCall);
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
  end;
end;

procedure SIRegister_ISIEnumVARIANT(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemMethodSet') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IEnumVARIANT, 'IEnumVARIANT') do begin
    RegisterMethod('Function Next(celt: LongWord; var rgvar : OleVariant; out pceltFetched: LongWord) : HResult', CdStdCall);
    RegisterMethod('Function Skip(celt: LongWord) : HResult', CdStdCall);
    RegisterMethod('Function Reset : HResult', CdStdCall);
    RegisterMethod('function Clone(out Enum: IEnumVARIANT): HResult;', CdStdCall);

    //function Clone(out Enum: IEnumVARIANT): HResult; stdcall;
  end;
end;


(*{$EXTERNALSYM IEnumVARIANT}
  IEnumVARIANT = interface(IUnknown)
    ['{00020404-0000-0000-C000-000000000046}']
    function Next(celt: LongWord; var rgvar : OleVariant;
      out pceltFetched: LongWord): HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out Enum: IEnumVARIANT): HResult; stdcall;
  end;
  *)

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemProperty(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemProperty') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemProperty, 'ISWbemProperty') do
  begin
    RegisterMethod('Function Get_Value : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Value( var varValue : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Function Get_IsLocal : WordBool', CdStdCall);
    RegisterMethod('Function Get_Origin : WideString', CdStdCall);
    RegisterMethod('Function Get_CIMType : WbemCimtypeEnum', CdStdCall);
    RegisterMethod('Function Get_Qualifiers_ : ISWbemQualifierSet', CdStdCall);
    RegisterMethod('Function Get_IsArray : WordBool', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemPropertySet(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemPropertySet') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemPropertySet, 'ISWbemPropertySet') do
  begin
    RegisterMethod('Function Get__NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Function Item( const strName : WideString; iFlags : Integer) : ISWbemProperty', CdStdCall);
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function Add( const strName : WideString; iCimType : WbemCimtypeEnum; bIsArray : WordBool; iFlags : Integer) : ISWbemProperty', CdStdCall);
    RegisterMethod('Procedure Remove( const strName : WideString; iFlags : Integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemQualifier(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemQualifier') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemQualifier, 'ISWbemQualifier') do
  begin
    RegisterMethod('Function Get_Value : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Value( var varValue : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Function Get_IsLocal : WordBool', CdStdCall);
    RegisterMethod('Function Get_PropagatesToSubclass : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_PropagatesToSubclass( bPropagatesToSubclass : WordBool)', CdStdCall);
    RegisterMethod('Function Get_PropagatesToInstance : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_PropagatesToInstance( bPropagatesToInstance : WordBool)', CdStdCall);
    RegisterMethod('Function Get_IsOverridable : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_IsOverridable( bIsOverridable : WordBool)', CdStdCall);
    RegisterMethod('Function Get_IsAmended : WordBool', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemQualifierSet(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemQualifierSet') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemQualifierSet, 'ISWbemQualifierSet') do
  begin
    RegisterMethod('Function Get__NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Function Item( const Name : WideString; iFlags : Integer) : ISWbemQualifier', CdStdCall);
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function Add( const strName : WideString; var varVal : OleVariant; bPropagatesToSubclass : WordBool; bPropagatesToInstance : WordBool; bIsOverridable : WordBool; iFlags : Integer) : ISWbemQualifier', CdStdCall);
    RegisterMethod('Procedure Remove( const strName : WideString; iFlags : Integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemObjectSet(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemObjectSet') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemObjectSet, 'ISWbemObjectSet') do
  begin
    RegisterMethod('Function Get__NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Function Item( const strObjectPath : WideString; iFlags : Integer) : ISWbemObject', CdStdCall);
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function Get_Security_ : ISWbemSecurity', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemPrivilege(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemPrivilege') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemPrivilege, 'ISWbemPrivilege') do
  begin
    RegisterMethod('Function Get_IsEnabled : WordBool', CdStdCall);
    RegisterMethod('Procedure Set_IsEnabled( bIsEnabled : WordBool)', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
    RegisterMethod('Function Get_DisplayName : WideString', CdStdCall);
    RegisterMethod('Function Get_Identifier : WbemPrivilegeEnum', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemPrivilegeSet(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemPrivilegeSet') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemPrivilegeSet, 'ISWbemPrivilegeSet') do
  begin
    RegisterMethod('Function Get__NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Function Item( iPrivilege : WbemPrivilegeEnum) : ISWbemPrivilege', CdStdCall);
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function Add( iPrivilege : WbemPrivilegeEnum; bIsEnabled : WordBool) : ISWbemPrivilege', CdStdCall);
    RegisterMethod('Procedure Remove( iPrivilege : WbemPrivilegeEnum)', CdStdCall);
    RegisterMethod('Procedure DeleteAll', CdStdCall);
    RegisterMethod('Function AddAsString( const strPrivilege : WideString; bIsEnabled : WordBool) : ISWbemPrivilege', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemSecurity(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemSecurity') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemSecurity, 'ISWbemSecurity') do
  begin
    RegisterMethod('Function Get_ImpersonationLevel : WbemImpersonationLevelEnum', CdStdCall);
    RegisterMethod('Procedure Set_ImpersonationLevel( iImpersonationLevel : WbemImpersonationLevelEnum)', CdStdCall);
    RegisterMethod('Function Get_AuthenticationLevel : WbemAuthenticationLevelEnum', CdStdCall);
    RegisterMethod('Procedure Set_AuthenticationLevel( iAuthenticationLevel : WbemAuthenticationLevelEnum)', CdStdCall);
    RegisterMethod('Function Get_Privileges : ISWbemPrivilegeSet', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemNamedValue(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemNamedValue') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemNamedValue, 'ISWbemNamedValue') do
  begin
    RegisterMethod('Function Get_Value : OleVariant', CdStdCall);
    RegisterMethod('Procedure Set_Value( var varValue : OleVariant)', CdStdCall);
    RegisterMethod('Function Get_Name : WideString', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemNamedValueSet(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemNamedValueSet') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemNamedValueSet, 'ISWbemNamedValueSet') do
  begin
    RegisterMethod('Function Get__NewEnum : IUnknown', CdStdCall);
    RegisterMethod('Function Item( const strName : WideString; iFlags : Integer) : ISWbemNamedValue', CdStdCall);
    RegisterMethod('Function Get_Count : Integer', CdStdCall);
    RegisterMethod('Function Add( const strName : WideString; var varValue : OleVariant; iFlags : Integer) : ISWbemNamedValue', CdStdCall);
    RegisterMethod('Procedure Remove( const strName : WideString; iFlags : Integer)', CdStdCall);
    RegisterMethod('Function Clone : ISWbemNamedValueSet', CdStdCall);
    RegisterMethod('Procedure DeleteAll', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemObjectPath(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemObjectPath') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemObjectPath, 'ISWbemObjectPath') do
  begin
    RegisterMethod('Function Get_Path : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Path( const strPath : WideString)', CdStdCall);
    RegisterMethod('Function Get_RelPath : WideString', CdStdCall);
    RegisterMethod('Procedure Set_RelPath( const strRelPath : WideString)', CdStdCall);
    RegisterMethod('Function Get_Server : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Server( const strServer : WideString)', CdStdCall);
    RegisterMethod('Function Get_Namespace : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Namespace( const strNamespace : WideString)', CdStdCall);
    RegisterMethod('Function Get_ParentNamespace : WideString', CdStdCall);
    RegisterMethod('Function Get_DisplayName : WideString', CdStdCall);
    RegisterMethod('Procedure Set_DisplayName( const strDisplayName : WideString)', CdStdCall);
    RegisterMethod('Function Get_Class_ : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Class_( const strClass : WideString)', CdStdCall);
    RegisterMethod('Function Get_IsClass : WordBool', CdStdCall);
    RegisterMethod('Procedure SetAsClass', CdStdCall);
    RegisterMethod('Function Get_IsSingleton : WordBool', CdStdCall);
    RegisterMethod('Procedure SetAsSingleton', CdStdCall);
    RegisterMethod('Function Get_Keys : ISWbemNamedValueSet', CdStdCall);
    RegisterMethod('Function Get_Security_ : ISWbemSecurity', CdStdCall);
    RegisterMethod('Function Get_Locale : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Locale( const strLocale : WideString)', CdStdCall);
    RegisterMethod('Function Get_Authority : WideString', CdStdCall);
    RegisterMethod('Procedure Set_Authority( const strAuthority : WideString)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemObject(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemObject') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemObject, 'ISWbemObject') do
  begin
    RegisterMethod('Function Put_( iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectPath', CdStdCall);
    RegisterMethod('Procedure PutAsync_( const objWbemSink : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Procedure Delete_( iFlags : Integer; const objWbemNamedValueSet : IDispatch)', CdStdCall);
    RegisterMethod('Procedure DeleteAsync_( const objWbemSink : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function Instances_( iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure InstancesAsync_( const objWbemSink : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function Subclasses_( iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure SubclassesAsync_( const objWbemSink : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function Associators_( const strAssocClass : WideString; const strResultClass : WideString; const strResultRole : WideString; const strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : WordBoo' +
      'l; const strRequiredAssocQualifier : WideString; const strRequiredQualifier : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure AssociatorsAsync_( const objWbemSink : IDispatch; const strAssocClass : WideString; const strResultClass : WideString; const strResultRole : WideString; const strRole : WideString; bClassesO' +
      'nly : WordBool; bSchemaOnly : WordBool; const strRequiredAssocQualifier : WideString; const strRequiredQualifier : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAs' +
      'yncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function References_( const strResultClass : WideString; const strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : WordBool; const strRequiredQualifier : WideString; iFlags : Integer; const o' +
      'bjWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure ReferencesAsync_( const objWbemSink : IDispatch; const strResultClass : WideString; const strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : WordBool; const strRequiredQualifier : ' +
      'WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function ExecMethod_( const strMethodName : WideString; const objWbemInParameters : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObject', CdStdCall);
    RegisterMethod('Procedure ExecMethodAsync_( const objWbemSink : IDispatch; const strMethodName : WideString; const objWbemInParameters : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objW' +
      'bemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function Clone_ : ISWbemObject', CdStdCall);
    RegisterMethod('Function GetObjectText_( iFlags : Integer) : WideString', CdStdCall);
    RegisterMethod('Function SpawnDerivedClass_( iFlags : Integer) : ISWbemObject', CdStdCall);
    RegisterMethod('Function SpawnInstance_( iFlags : Integer) : ISWbemObject', CdStdCall);
    RegisterMethod('Function CompareTo_( const objWbemObject : IDispatch; iFlags : Integer) : WordBool', CdStdCall);
    RegisterMethod('Function Get_Qualifiers_ : ISWbemQualifierSet', CdStdCall);
    RegisterMethod('Function Get_Properties_ : ISWbemPropertySet', CdStdCall);
    RegisterMethod('Function Get_Methods_ : ISWbemMethodSet', CdStdCall);
    RegisterMethod('Function Get_Derivation_ : OleVariant', CdStdCall);
    RegisterMethod('Function Get_Path_ : ISWbemObjectPath', CdStdCall);
    RegisterMethod('Function Get_Security_ : ISWbemSecurity', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISWbemServices(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemServices') do
  with CL.AddInterface(CL.FindInterface('IDispatch'),ISWbemServices, 'ISWbemServices') do
  begin
    RegisterMethod('Function Get( const strObjectPath : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObject', CdStdCall);
    RegisterMethod('Procedure GetAsync( const objWbemSink : IDispatch; const strObjectPath : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Procedure Delete( const strObjectPath : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch)', CdStdCall);
    RegisterMethod('Procedure DeleteAsync( const objWbemSink : IDispatch; const strObjectPath : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function InstancesOf( const strClass : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure InstancesOfAsync( const objWbemSink : IDispatch; const strClass : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function SubclassesOf( const strSuperclass : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure SubclassesOfAsync( const objWbemSink : IDispatch; const strSuperclass : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function ExecQuery( const strQuery : WideString; const strQueryLanguage : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure ExecQueryAsync( const objWbemSink : IDispatch; const strQuery : WideString; const strQueryLanguage : WideString; lFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncC' +
      'ontext : IDispatch)', CdStdCall);
    RegisterMethod('Function AssociatorsOf( const strObjectPath : WideString; const strAssocClass : WideString; const strResultClass : WideString; const strResultRole : WideString; const strRole : WideString; bClassesOnl' +
      'y : WordBool; bSchemaOnly : WordBool; const strRequiredAssocQualifier : WideString; const strRequiredQualifier : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure AssociatorsOfAsync( const objWbemSink : IDispatch; const strObjectPath : WideString; const strAssocClass : WideString; const strResultClass : WideString; const strResultRole : WideString; co' +
      'nst strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : WordBool; const strRequiredAssocQualifier : WideString; const strRequiredQualifier : WideString; iFlags : Integer; const objWbemNamedVa' +
      'lueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function ReferencesTo( const strObjectPath : WideString; const strResultClass : WideString; const strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : WordBool; const strRequiredQualifier : Wi' +
      'deString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObjectSet', CdStdCall);
    RegisterMethod('Procedure ReferencesToAsync( const objWbemSink : IDispatch; const strObjectPath : WideString; const strResultClass : WideString; const strRole : WideString; bClassesOnly : WordBool; bSchemaOnly : Word' +
      'Bool; const strRequiredQualifier : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function ExecNotificationQuery( const strQuery : WideString; const strQueryLanguage : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemEventSource', CdStdCall);
    RegisterMethod('Procedure ExecNotificationQueryAsync( const objWbemSink : IDispatch; const strQuery : WideString; const strQueryLanguage : WideString; iFlags : Integer; const objWbemNamedValueSet : IDispatch; const o' +
      'bjWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function ExecMethod( const strObjectPath : WideString; const strMethodName : WideString; const objWbemInParameters : IDispatch; iFlags : Integer; const objWbemNamedValueSet : IDispatch) : ISWbemObject', CdStdCall);
    RegisterMethod('Procedure ExecMethodAsync( const objWbemSink : IDispatch; const strObjectPath : WideString; const strMethodName : WideString; const objWbemInParameters : IDispatch; iFlags : Integer; const objWbemName' +
      'dValueSet : IDispatch; const objWbemAsyncContext : IDispatch)', CdStdCall);
    RegisterMethod('Function Get_Security_ : ISWbemSecurity', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WbemScripting_TLB(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('WbemScriptingMajorVersion','LongInt').SetInt( 1);
 CL.AddConstantN('WbemScriptingMinorVersion','LongInt').SetInt( 2);
 (*CL.AddConstantN('LIBID_WbemScripting','TGUID').SetString( '{565783C6-CB41-11D1-8B02-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemServices','TGUID').SetString( '{76A6415C-CB41-11D1-8B02-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemObject','TGUID').SetString( '{76A6415A-CB41-11D1-8B02-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemObjectPath','TGUID').SetString( '{5791BC27-CE9C-11D1-97BF-0000F81E849C}');
 CL.AddConstantN('IID_ISWbemNamedValueSet','TGUID').SetString( '{CF2376EA-CE8C-11D1-8B05-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemNamedValue','TGUID').SetString( '{76A64164-CB41-11D1-8B02-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemSecurity','TGUID').SetString( '{B54D66E6-2287-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemPrivilegeSet','TGUID').SetString( '{26EE67BF-5804-11D2-8B4A-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemPrivilege','TGUID').SetString( '{26EE67BD-5804-11D2-8B4A-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemObjectSet','TGUID').SetString( '{76A6415F-CB41-11D1-8B02-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemQualifierSet','TGUID').SetString( '{9B16ED16-D3DF-11D1-8B08-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemQualifier','TGUID').SetString( '{79B05932-D3B7-11D1-8B06-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemPropertySet','TGUID').SetString( '{DEA0A7B2-D4BA-11D1-8B09-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemProperty','TGUID').SetString( '{1A388F98-D4BA-11D1-8B09-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemMethodSet','TGUID').SetString( '{C93BA292-D955-11D1-8B09-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemMethod','TGUID').SetString( '{422E8E90-D955-11D1-8B09-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemEventSource','TGUID').SetString( '{27D54D92-0EBE-11D2-8B22-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemLocator','TGUID').SetString( '{76A6415B-CB41-11D1-8B02-00600806D9B6}');
 CL.AddConstantN('IID_ISWbemLastError','TGUID').SetString( '{D962DB84-D4BB-11D1-8B09-00600806D9B6}');
 CL.AddConstantN('DIID_ISWbemSinkEvents','TGUID').SetString( '{75718CA0-F029-11D1-A1AC-00C04FB6C223}');
 CL.AddConstantN('IID_ISWbemSink','TGUID').SetString( '{75718C9F-F029-11D1-A1AC-00C04FB6C223}');
 CL.AddConstantN('IID_ISWbemServicesEx','TGUID').SetString( '{D2F68443-85DC-427E-91D8-366554CC754C}');
 CL.AddConstantN('IID_ISWbemObjectEx','TGUID').SetString( '{269AD56A-8A67-4129-BC8C-0506DCFE9880}');
 CL.AddConstantN('IID_ISWbemDateTime','TGUID').SetString( '{5E97458A-CF77-11D3-B38F-00105A1F473A}');
 CL.AddConstantN('IID_ISWbemRefresher','TGUID').SetString( '{14D8250E-D9C2-11D3-B38F-00105A1F473A}');
 CL.AddConstantN('IID_ISWbemRefreshableItem','TGUID').SetString( '{5AD4BF92-DAAB-11D3-B38F-00105A1F473A}');
 CL.AddConstantN('CLASS_SWbemLocator','TGUID').SetString( '{76A64158-CB41-11D1-8B02-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemNamedValueSet','TGUID').SetString( '{9AED384E-CE8B-11D1-8B05-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemObjectPath','TGUID').SetString( '{5791BC26-CE9C-11D1-97BF-0000F81E849C}');
 CL.AddConstantN('CLASS_SWbemLastError','TGUID').SetString( '{C2FEEEAC-CFCD-11D1-8B05-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemSink','TGUID').SetString( '{75718C9A-F029-11D1-A1AC-00C04FB6C223}');
 CL.AddConstantN('CLASS_SWbemDateTime','TGUID').SetString( '{47DFBE54-CF76-11D3-B38F-00105A1F473A}');
 CL.AddConstantN('CLASS_SWbemRefresher','TGUID').SetString( '{D269BF5C-D9C1-11D3-B38F-00105A1F473A}');
 CL.AddConstantN('CLASS_SWbemServices','TGUID').SetString( '{04B83D63-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemServicesEx','TGUID').SetString( '{62E522DC-8CF3-40A8-8B2E-37D595651E40}');
 CL.AddConstantN('CLASS_SWbemObject','TGUID').SetString( '{04B83D62-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemObjectEx','TGUID').SetString( '{D6BDAFB2-9435-491F-BB87-6AA0F0BC31A2}');
 CL.AddConstantN('CLASS_SWbemObjectSet','TGUID').SetString( '{04B83D61-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemNamedValue','TGUID').SetString( '{04B83D60-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemQualifier','TGUID').SetString( '{04B83D5F-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemQualifierSet','TGUID').SetString( '{04B83D5E-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemProperty','TGUID').SetString( '{04B83D5D-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemPropertySet','TGUID').SetString( '{04B83D5C-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemMethod','TGUID').SetString( '{04B83D5B-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemMethodSet','TGUID').SetString( '{04B83D5A-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemEventSource','TGUID').SetString( '{04B83D58-21AE-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemSecurity','TGUID').SetString( '{B54D66E9-2287-11D2-8B33-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemPrivilege','TGUID').SetString( '{26EE67BC-5804-11D2-8B4A-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemPrivilegeSet','TGUID').SetString( '{26EE67BE-5804-11D2-8B4A-00600806D9B6}');
 CL.AddConstantN('CLASS_SWbemRefreshableItem','TGUID').SetString( '{8C6854BC-DE4B-11D3-B390-00105A1F473A}');
 *)

  CL.AddTypeS('WbemImpersonationLevelEnum', 'TOleEnum');
 CL.AddConstantN('wbemImpersonationLevelAnonymous','LongWord').SetUInt( $00000001);
 CL.AddConstantN('wbemImpersonationLevelIdentify','LongWord').SetUInt( $00000002);
 CL.AddConstantN('wbemImpersonationLevelImpersonate','LongWord').SetUInt( $00000003);
 CL.AddConstantN('wbemImpersonationLevelDelegate','LongWord').SetUInt( $00000004);
  CL.AddTypeS('WbemAuthenticationLevelEnum', 'TOleEnum');
 CL.AddConstantN('wbemAuthenticationLevelDefault','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemAuthenticationLevelNone','LongWord').SetUInt( $00000001);
 CL.AddConstantN('wbemAuthenticationLevelConnect','LongWord').SetUInt( $00000002);
 CL.AddConstantN('wbemAuthenticationLevelCall','LongWord').SetUInt( $00000003);
 CL.AddConstantN('wbemAuthenticationLevelPkt','LongWord').SetUInt( $00000004);
 CL.AddConstantN('wbemAuthenticationLevelPktIntegrity','LongWord').SetUInt( $00000005);
 CL.AddConstantN('wbemAuthenticationLevelPktPrivacy','LongWord').SetUInt( $00000006);
  CL.AddTypeS('WbemPrivilegeEnum', 'TOleEnum');
 CL.AddConstantN('wbemPrivilegeCreateToken','LongWord').SetUInt( $00000001);
 CL.AddConstantN('wbemPrivilegePrimaryToken','LongWord').SetUInt( $00000002);
 CL.AddConstantN('wbemPrivilegeLockMemory','LongWord').SetUInt( $00000003);
 CL.AddConstantN('wbemPrivilegeIncreaseQuota','LongWord').SetUInt( $00000004);
 CL.AddConstantN('wbemPrivilegeMachineAccount','LongWord').SetUInt( $00000005);
 CL.AddConstantN('wbemPrivilegeTcb','LongWord').SetUInt( $00000006);
 CL.AddConstantN('wbemPrivilegeSecurity','LongWord').SetUInt( $00000007);
 CL.AddConstantN('wbemPrivilegeTakeOwnership','LongWord').SetUInt( $00000008);
 CL.AddConstantN('wbemPrivilegeLoadDriver','LongWord').SetUInt( $00000009);
 CL.AddConstantN('wbemPrivilegeSystemProfile','LongWord').SetUInt( $0000000A);
 CL.AddConstantN('wbemPrivilegeSystemtime','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('wbemPrivilegeProfileSingleProcess','LongWord').SetUInt( $0000000C);
 CL.AddConstantN('wbemPrivilegeIncreaseBasePriority','LongWord').SetUInt( $0000000D);
 CL.AddConstantN('wbemPrivilegeCreatePagefile','LongWord').SetUInt( $0000000E);
 CL.AddConstantN('wbemPrivilegeCreatePermanent','LongWord').SetUInt( $0000000F);
 CL.AddConstantN('wbemPrivilegeBackup','LongWord').SetUInt( $00000010);
 CL.AddConstantN('wbemPrivilegeRestore','LongWord').SetUInt( $00000011);
 CL.AddConstantN('wbemPrivilegeShutdown','LongWord').SetUInt( $00000012);
 CL.AddConstantN('wbemPrivilegeDebug','LongWord').SetUInt( $00000013);
 CL.AddConstantN('wbemPrivilegeAudit','LongWord').SetUInt( $00000014);
 CL.AddConstantN('wbemPrivilegeSystemEnvironment','LongWord').SetUInt( $00000015);
 CL.AddConstantN('wbemPrivilegeChangeNotify','LongWord').SetUInt( $00000016);
 CL.AddConstantN('wbemPrivilegeRemoteShutdown','LongWord').SetUInt( $00000017);
 CL.AddConstantN('wbemPrivilegeUndock','LongWord').SetUInt( $00000018);
 CL.AddConstantN('wbemPrivilegeSyncAgent','LongWord').SetUInt( $00000019);
 CL.AddConstantN('wbemPrivilegeEnableDelegation','LongWord').SetUInt( $0000001A);
 CL.AddConstantN('wbemPrivilegeManageVolume','LongWord').SetUInt( $0000001B);
  CL.AddTypeS('WbemCimtypeEnum', 'TOleEnum');
 CL.AddConstantN('wbemCimtypeSint8','LongWord').SetUInt( $00000010);
 CL.AddConstantN('wbemCimtypeUint8','LongWord').SetUInt( $00000011);
 CL.AddConstantN('wbemCimtypeSint16','LongWord').SetUInt( $00000002);
 CL.AddConstantN('wbemCimtypeUint16','LongWord').SetUInt( $00000012);
 CL.AddConstantN('wbemCimtypeSint32','LongWord').SetUInt( $00000003);
 CL.AddConstantN('wbemCimtypeUint32','LongWord').SetUInt( $00000013);
 CL.AddConstantN('wbemCimtypeSint64','LongWord').SetUInt( $00000014);
 CL.AddConstantN('wbemCimtypeUint64','LongWord').SetUInt( $00000015);
 CL.AddConstantN('wbemCimtypeReal32','LongWord').SetUInt( $00000004);
 CL.AddConstantN('wbemCimtypeReal64','LongWord').SetUInt( $00000005);
 CL.AddConstantN('wbemCimtypeBoolean','LongWord').SetUInt( $0000000B);
 CL.AddConstantN('wbemCimtypeString','LongWord').SetUInt( $00000008);
 CL.AddConstantN('wbemCimtypeDatetime','LongWord').SetUInt( $00000065);
 CL.AddConstantN('wbemCimtypeReference','LongWord').SetUInt( $00000066);
 CL.AddConstantN('wbemCimtypeChar16','LongWord').SetUInt( $00000067);
 CL.AddConstantN('wbemCimtypeObject','LongWord').SetUInt( $0000000D);
  CL.AddTypeS('WbemErrorEnum', 'TOleEnum');
 CL.AddConstantN('wbemNoErr','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemErrFailed','LongWord').SetUInt( $80041001);
 CL.AddConstantN('wbemErrNotFound','LongWord').SetUInt( $80041002);
 CL.AddConstantN('wbemErrAccessDenied','LongWord').SetUInt( $80041003);
 CL.AddConstantN('wbemErrProviderFailure','LongWord').SetUInt( $80041004);
 CL.AddConstantN('wbemErrTypeMismatch','LongWord').SetUInt( $80041005);
 CL.AddConstantN('wbemErrOutOfMemory','LongWord').SetUInt( $80041006);
 CL.AddConstantN('wbemErrInvalidContext','LongWord').SetUInt( $80041007);
 CL.AddConstantN('wbemErrInvalidParameter','LongWord').SetUInt( $80041008);
 CL.AddConstantN('wbemErrNotAvailable','LongWord').SetUInt( $80041009);
 CL.AddConstantN('wbemErrCriticalError','LongWord').SetUInt( $8004100A);
 CL.AddConstantN('wbemErrInvalidStream','LongWord').SetUInt( $8004100B);
 CL.AddConstantN('wbemErrNotSupported','LongWord').SetUInt( $8004100C);
 CL.AddConstantN('wbemErrInvalidSuperclass','LongWord').SetUInt( $8004100D);
 CL.AddConstantN('wbemErrInvalidNamespace','LongWord').SetUInt( $8004100E);
 CL.AddConstantN('wbemErrInvalidObject','LongWord').SetUInt( $8004100F);
 CL.AddConstantN('wbemErrInvalidClass','LongWord').SetUInt( $80041010);
 CL.AddConstantN('wbemErrProviderNotFound','LongWord').SetUInt( $80041011);
 CL.AddConstantN('wbemErrInvalidProviderRegistration','LongWord').SetUInt( $80041012);
 CL.AddConstantN('wbemErrProviderLoadFailure','LongWord').SetUInt( $80041013);
 CL.AddConstantN('wbemErrInitializationFailure','LongWord').SetUInt( $80041014);
 CL.AddConstantN('wbemErrTransportFailure','LongWord').SetUInt( $80041015);
 CL.AddConstantN('wbemErrInvalidOperation','LongWord').SetUInt( $80041016);
 CL.AddConstantN('wbemErrInvalidQuery','LongWord').SetUInt( $80041017);
 CL.AddConstantN('wbemErrInvalidQueryType','LongWord').SetUInt( $80041018);
 CL.AddConstantN('wbemErrAlreadyExists','LongWord').SetUInt( $80041019);
 CL.AddConstantN('wbemErrOverrideNotAllowed','LongWord').SetUInt( $8004101A);
 CL.AddConstantN('wbemErrPropagatedQualifier','LongWord').SetUInt( $8004101B);
 CL.AddConstantN('wbemErrPropagatedProperty','LongWord').SetUInt( $8004101C);
 CL.AddConstantN('wbemErrUnexpected','LongWord').SetUInt( $8004101D);
 CL.AddConstantN('wbemErrIllegalOperation','LongWord').SetUInt( $8004101E);
 CL.AddConstantN('wbemErrCannotBeKey','LongWord').SetUInt( $8004101F);
 CL.AddConstantN('wbemErrIncompleteClass','LongWord').SetUInt( $80041020);
 CL.AddConstantN('wbemErrInvalidSyntax','LongWord').SetUInt( $80041021);
 CL.AddConstantN('wbemErrNondecoratedObject','LongWord').SetUInt( $80041022);
 CL.AddConstantN('wbemErrReadOnly','LongWord').SetUInt( $80041023);
 CL.AddConstantN('wbemErrProviderNotCapable','LongWord').SetUInt( $80041024);
 CL.AddConstantN('wbemErrClassHasChildren','LongWord').SetUInt( $80041025);
 CL.AddConstantN('wbemErrClassHasInstances','LongWord').SetUInt( $80041026);
 CL.AddConstantN('wbemErrQueryNotImplemented','LongWord').SetUInt( $80041027);
 CL.AddConstantN('wbemErrIllegalNull','LongWord').SetUInt( $80041028);
 CL.AddConstantN('wbemErrInvalidQualifierType','LongWord').SetUInt( $80041029);
 CL.AddConstantN('wbemErrInvalidPropertyType','LongWord').SetUInt( $8004102A);
 CL.AddConstantN('wbemErrValueOutOfRange','LongWord').SetUInt( $8004102B);
 CL.AddConstantN('wbemErrCannotBeSingleton','LongWord').SetUInt( $8004102C);
 CL.AddConstantN('wbemErrInvalidCimType','LongWord').SetUInt( $8004102D);
 CL.AddConstantN('wbemErrInvalidMethod','LongWord').SetUInt( $8004102E);
 CL.AddConstantN('wbemErrInvalidMethodParameters','LongWord').SetUInt( $8004102F);
 CL.AddConstantN('wbemErrSystemProperty','LongWord').SetUInt( $80041030);
 CL.AddConstantN('wbemErrInvalidProperty','LongWord').SetUInt( $80041031);
 CL.AddConstantN('wbemErrCallCancelled','LongWord').SetUInt( $80041032);
 CL.AddConstantN('wbemErrShuttingDown','LongWord').SetUInt( $80041033);
 CL.AddConstantN('wbemErrPropagatedMethod','LongWord').SetUInt( $80041034);
 CL.AddConstantN('wbemErrUnsupportedParameter','LongWord').SetUInt( $80041035);
 CL.AddConstantN('wbemErrMissingParameter','LongWord').SetUInt( $80041036);
 CL.AddConstantN('wbemErrInvalidParameterId','LongWord').SetUInt( $80041037);
 CL.AddConstantN('wbemErrNonConsecutiveParameterIds','LongWord').SetUInt( $80041038);
 CL.AddConstantN('wbemErrParameterIdOnRetval','LongWord').SetUInt( $80041039);
 CL.AddConstantN('wbemErrInvalidObjectPath','LongWord').SetUInt( $8004103A);
 CL.AddConstantN('wbemErrOutOfDiskSpace','LongWord').SetUInt( $8004103B);
 CL.AddConstantN('wbemErrBufferTooSmall','LongWord').SetUInt( $8004103C);
 CL.AddConstantN('wbemErrUnsupportedPutExtension','LongWord').SetUInt( $8004103D);
 CL.AddConstantN('wbemErrUnknownObjectType','LongWord').SetUInt( $8004103E);
 CL.AddConstantN('wbemErrUnknownPacketType','LongWord').SetUInt( $8004103F);
 CL.AddConstantN('wbemErrMarshalVersionMismatch','LongWord').SetUInt( $80041040);
 CL.AddConstantN('wbemErrMarshalInvalidSignature','LongWord').SetUInt( $80041041);
 CL.AddConstantN('wbemErrInvalidQualifier','LongWord').SetUInt( $80041042);
 CL.AddConstantN('wbemErrInvalidDuplicateParameter','LongWord').SetUInt( $80041043);
 CL.AddConstantN('wbemErrTooMuchData','LongWord').SetUInt( $80041044);
 CL.AddConstantN('wbemErrServerTooBusy','LongWord').SetUInt( $80041045);
 CL.AddConstantN('wbemErrInvalidFlavor','LongWord').SetUInt( $80041046);
 CL.AddConstantN('wbemErrCircularReference','LongWord').SetUInt( $80041047);
 CL.AddConstantN('wbemErrUnsupportedClassUpdate','LongWord').SetUInt( $80041048);
 CL.AddConstantN('wbemErrCannotChangeKeyInheritance','LongWord').SetUInt( $80041049);
 CL.AddConstantN('wbemErrCannotChangeIndexInheritance','LongWord').SetUInt( $80041050);
 CL.AddConstantN('wbemErrTooManyProperties','LongWord').SetUInt( $80041051);
 CL.AddConstantN('wbemErrUpdateTypeMismatch','LongWord').SetUInt( $80041052);
 CL.AddConstantN('wbemErrUpdateOverrideNotAllowed','LongWord').SetUInt( $80041053);
 CL.AddConstantN('wbemErrUpdatePropagatedMethod','LongWord').SetUInt( $80041054);
 CL.AddConstantN('wbemErrMethodNotImplemented','LongWord').SetUInt( $80041055);
 CL.AddConstantN('wbemErrMethodDisabled','LongWord').SetUInt( $80041056);
 CL.AddConstantN('wbemErrRefresherBusy','LongWord').SetUInt( $80041057);
 CL.AddConstantN('wbemErrUnparsableQuery','LongWord').SetUInt( $80041058);
 CL.AddConstantN('wbemErrNotEventClass','LongWord').SetUInt( $80041059);
 CL.AddConstantN('wbemErrMissingGroupWithin','LongWord').SetUInt( $8004105A);
 CL.AddConstantN('wbemErrMissingAggregationList','LongWord').SetUInt( $8004105B);
 CL.AddConstantN('wbemErrPropertyNotAnObject','LongWord').SetUInt( $8004105C);
 CL.AddConstantN('wbemErrAggregatingByObject','LongWord').SetUInt( $8004105D);
 CL.AddConstantN('wbemErrUninterpretableProviderQuery','LongWord').SetUInt( $8004105F);
 CL.AddConstantN('wbemErrBackupRestoreWinmgmtRunning','LongWord').SetUInt( $80041060);
 CL.AddConstantN('wbemErrQueueOverflow','LongWord').SetUInt( $80041061);
 CL.AddConstantN('wbemErrPrivilegeNotHeld','LongWord').SetUInt( $80041062);
 CL.AddConstantN('wbemErrInvalidOperator','LongWord').SetUInt( $80041063);
 CL.AddConstantN('wbemErrLocalCredentials','LongWord').SetUInt( $80041064);
 CL.AddConstantN('wbemErrCannotBeAbstract','LongWord').SetUInt( $80041065);
 CL.AddConstantN('wbemErrAmendedObject','LongWord').SetUInt( $80041066);
 CL.AddConstantN('wbemErrClientTooSlow','LongWord').SetUInt( $80041067);
 CL.AddConstantN('wbemErrNullSecurityDescriptor','LongWord').SetUInt( $80041068);
 CL.AddConstantN('wbemErrTimeout','LongWord').SetUInt( $80041069);
 CL.AddConstantN('wbemErrInvalidAssociation','LongWord').SetUInt( $8004106A);
 CL.AddConstantN('wbemErrAmbiguousOperation','LongWord').SetUInt( $8004106B);
 CL.AddConstantN('wbemErrQuotaViolation','LongWord').SetUInt( $8004106C);
 CL.AddConstantN('wbemErrTransactionConflict','LongWord').SetUInt( $8004106D);
 CL.AddConstantN('wbemErrForcedRollback','LongWord').SetUInt( $8004106E);
 CL.AddConstantN('wbemErrUnsupportedLocale','LongWord').SetUInt( $8004106F);
 CL.AddConstantN('wbemErrHandleOutOfDate','LongWord').SetUInt( $80041070);
 CL.AddConstantN('wbemErrConnectionFailed','LongWord').SetUInt( $80041071);
 CL.AddConstantN('wbemErrInvalidHandleRequest','LongWord').SetUInt( $80041072);
 CL.AddConstantN('wbemErrPropertyNameTooWide','LongWord').SetUInt( $80041073);
 CL.AddConstantN('wbemErrClassNameTooWide','LongWord').SetUInt( $80041074);
 CL.AddConstantN('wbemErrMethodNameTooWide','LongWord').SetUInt( $80041075);
 CL.AddConstantN('wbemErrQualifierNameTooWide','LongWord').SetUInt( $80041076);
 CL.AddConstantN('wbemErrRerunCommand','LongWord').SetUInt( $80041077);
 CL.AddConstantN('wbemErrDatabaseVerMismatch','LongWord').SetUInt( $80041078);
 CL.AddConstantN('wbemErrVetoPut','LongWord').SetUInt( $80041079);
 CL.AddConstantN('wbemErrVetoDelete','LongWord').SetUInt( $8004107A);
 CL.AddConstantN('wbemErrInvalidLocale','LongWord').SetUInt( $80041080);
 CL.AddConstantN('wbemErrProviderSuspended','LongWord').SetUInt( $80041081);
 CL.AddConstantN('wbemErrSynchronizationRequired','LongWord').SetUInt( $80041082);
 CL.AddConstantN('wbemErrNoSchema','LongWord').SetUInt( $80041083);
 CL.AddConstantN('wbemErrProviderAlreadyRegistered','LongWord').SetUInt( $80041084);
 CL.AddConstantN('wbemErrProviderNotRegistered','LongWord').SetUInt( $80041085);
 CL.AddConstantN('wbemErrFatalTransportError','LongWord').SetUInt( $80041086);
 CL.AddConstantN('wbemErrEncryptedConnectionRequired','LongWord').SetUInt( $80041087);
 CL.AddConstantN('wbemErrRegistrationTooBroad','LongWord').SetUInt( $80042001);
 CL.AddConstantN('wbemErrRegistrationTooPrecise','LongWord').SetUInt( $80042002);
 CL.AddConstantN('wbemErrTimedout','LongWord').SetUInt( $80043001);
 CL.AddConstantN('wbemErrResetToDefault','LongWord').SetUInt( $80043002);
  CL.AddTypeS('WbemObjectTextFormatEnum', 'TOleEnum');
 CL.AddConstantN('wbemObjectTextFormatCIMDTD20','LongWord').SetUInt( $00000001);
 CL.AddConstantN('wbemObjectTextFormatWMIDTD20','LongWord').SetUInt( $00000002);
  CL.AddTypeS('WbemChangeFlagEnum', 'TOleEnum');
 CL.AddConstantN('wbemChangeFlagCreateOrUpdate','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemChangeFlagUpdateOnly','LongWord').SetUInt( $00000001);
 CL.AddConstantN('wbemChangeFlagCreateOnly','LongWord').SetUInt( $00000002);
 CL.AddConstantN('wbemChangeFlagUpdateCompatible','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemChangeFlagUpdateSafeMode','LongWord').SetUInt( $00000020);
 CL.AddConstantN('wbemChangeFlagUpdateForceMode','LongWord').SetUInt( $00000040);
 CL.AddConstantN('wbemChangeFlagStrongValidation','LongWord').SetUInt( $00000080);
 CL.AddConstantN('wbemChangeFlagAdvisory','LongWord').SetUInt( $00010000);
  CL.AddTypeS('WbemFlagEnum', 'TOleEnum');
 CL.AddConstantN('wbemFlagReturnImmediately','LongWord').SetUInt( $00000010);
 CL.AddConstantN('wbemFlagReturnWhenComplete','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemFlagBidirectional','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemFlagForwardOnly','LongWord').SetUInt( $00000020);
 CL.AddConstantN('wbemFlagNoErrorObject','LongWord').SetUInt( $00000040);
 CL.AddConstantN('wbemFlagReturnErrorObject','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemFlagSendStatus','LongWord').SetUInt( $00000080);
 CL.AddConstantN('wbemFlagDontSendStatus','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemFlagEnsureLocatable','LongWord').SetUInt( $00000100);
 CL.AddConstantN('wbemFlagDirectRead','LongWord').SetUInt( $00000200);
 CL.AddConstantN('wbemFlagSendOnlySelected','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemFlagUseAmendedQualifiers','LongWord').SetUInt( $00020000);
 CL.AddConstantN('wbemFlagGetDefault','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemFlagSpawnInstance','LongWord').SetUInt( $00000001);
 CL.AddConstantN('wbemFlagUseCurrentTime','LongWord').SetUInt( $00000001);
  CL.AddTypeS('WbemQueryFlagEnum', 'TOleEnum');
 CL.AddConstantN('wbemQueryFlagDeep','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemQueryFlagShallow','LongWord').SetUInt( $00000001);
 CL.AddConstantN('wbemQueryFlagPrototype','LongWord').SetUInt( $00000002);
  CL.AddTypeS('WbemTextFlagEnum', 'TOleEnum');
 CL.AddConstantN('wbemTextFlagNoFlavors','LongWord').SetUInt( $00000001);
  CL.AddTypeS('WbemTimeout', 'TOleEnum');
 CL.AddConstantN('wbemTimeoutInfinite','LongWord').SetUInt( $FFFFFFFF);
  CL.AddTypeS('WbemComparisonFlagEnum', 'TOleEnum');
 CL.AddConstantN('wbemComparisonFlagIncludeAll','LongWord').SetUInt( $00000000);
 CL.AddConstantN('wbemComparisonFlagIgnoreQualifiers','LongWord').SetUInt( $00000001);
 CL.AddConstantN('wbemComparisonFlagIgnoreObjectSource','LongWord').SetUInt( $00000002);
 CL.AddConstantN('wbemComparisonFlagIgnoreDefaultValues','LongWord').SetUInt( $00000004);
 CL.AddConstantN('wbemComparisonFlagIgnoreClass','LongWord').SetUInt( $00000008);
 CL.AddConstantN('wbemComparisonFlagIgnoreCase','LongWord').SetUInt( $00000010);
 CL.AddConstantN('wbemComparisonFlagIgnoreFlavor','LongWord').SetUInt( $00000020);
  CL.AddTypeS('WbemConnectOptionsEnum', 'TOleEnum');
 CL.AddConstantN('wbemConnectFlagUseMaxWait','LongWord').SetUInt( $00000080);
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemServices, 'ISWbemServices');
  //CL.AddTypeS('ISWbemServicesDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemObject, 'ISWbemObject');
  //CL.AddTypeS('ISWbemObjectDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemObjectPath, 'ISWbemObjectPath');
  //CL.AddTypeS('ISWbemObjectPathDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemNamedValueSet, 'ISWbemNamedValueSet');
  //CL.AddTypeS('ISWbemNamedValueSetDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemNamedValue, 'ISWbemNamedValue');
  //CL.AddTypeS('ISWbemNamedValueDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemSecurity, 'ISWbemSecurity');
  //CL.AddTypeS('ISWbemSecurityDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemPrivilegeSet, 'ISWbemPrivilegeSet');
  //CL.AddTypeS('ISWbemPrivilegeSetDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemPrivilege, 'ISWbemPrivilege');
  //CL.AddTypeS('ISWbemPrivilegeDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemObjectSet, 'ISWbemObjectSet');
  //CL.AddTypeS('ISWbemObjectSetDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemQualifierSet, 'ISWbemQualifierSet');
  //CL.AddTypeS('ISWbemQualifierSetDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemQualifier, 'ISWbemQualifier');
  //CL.AddTypeS('ISWbemQualifierDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemPropertySet, 'ISWbemPropertySet');
  //CL.AddTypeS('ISWbemPropertySetDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemProperty, 'ISWbemProperty');
  //CL.AddTypeS('ISWbemPropertyDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemMethodSet, 'ISWbemMethodSet');
  //CL.AddTypeS('ISWbemMethodSetDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemMethod, 'ISWbemMethod');
  //CL.AddTypeS('ISWbemMethodDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemEventSource, 'ISWbemEventSource');
  //CL.AddTypeS('ISWbemEventSourceDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemLocator, 'ISWbemLocator');
  //CL.AddTypeS('ISWbemLocatorDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemLastError, 'ISWbemLastError');
  //CL.AddTypeS('ISWbemLastErrorDisp', 'dispinterface');
  //CL.AddTypeS('ISWbemSinkEvents', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemSink, 'ISWbemSink');
  //CL.AddTypeS('ISWbemSinkDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemServicesEx, 'ISWbemServicesEx');
  //CL.AddTypeS('ISWbemServicesExDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemObjectEx, 'ISWbemObjectEx');
  //CL.AddTypeS('ISWbemObjectExDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemDateTime, 'ISWbemDateTime');
  //CL.AddTypeS('ISWbemDateTimeDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemRefresher, 'ISWbemRefresher');
  //CL.AddTypeS('ISWbemRefresherDisp', 'dispinterface');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),ISWbemRefreshableItem, 'ISWbemRefreshableItem');
  CL.AddInterface(CL.FindInterface('IUNKNOWN'),IENumVariant, 'IENumVariant');

  //CL.AddTypeS('ISWbemRefreshableItemDisp', 'dispinterface');
  CL.AddTypeS('SWbemLocator', 'ISWbemLocator');
  CL.AddTypeS('SWbemNamedValueSet', 'ISWbemNamedValueSet');
  CL.AddTypeS('SWbemObjectPath', 'ISWbemObjectPath');
  CL.AddTypeS('SWbemLastError', 'ISWbemLastError');
  CL.AddTypeS('SWbemSink', 'ISWbemSink');
  CL.AddTypeS('SWbemDateTime', 'ISWbemDateTime');
  CL.AddTypeS('SWbemRefresher', 'ISWbemRefresher');
  CL.AddTypeS('SWbemServices', 'ISWbemServices');
  CL.AddTypeS('SWbemServicesEx', 'ISWbemServicesEx');
  CL.AddTypeS('SWbemObject', 'ISWbemObject');
  CL.AddTypeS('SWbemObjectEx', 'ISWbemObjectEx');
  CL.AddTypeS('SWbemObjectSet', 'ISWbemObjectSet');
  CL.AddTypeS('SWbemNamedValue', 'ISWbemNamedValue');
  CL.AddTypeS('SWbemQualifier', 'ISWbemQualifier');
  CL.AddTypeS('SWbemQualifierSet', 'ISWbemQualifierSet');
  CL.AddTypeS('SWbemProperty', 'ISWbemProperty');
  CL.AddTypeS('SWbemPropertySet', 'ISWbemPropertySet');
  CL.AddTypeS('SWbemMethod', 'ISWbemMethod');
  CL.AddTypeS('SWbemMethodSet', 'ISWbemMethodSet');
  CL.AddTypeS('SWbemEventSource', 'ISWbemEventSource');
  CL.AddTypeS('SWbemSecurity', 'ISWbemSecurity');
  CL.AddTypeS('SWbemPrivilege', 'ISWbemPrivilege');
  CL.AddTypeS('SWbemPrivilegeSet', 'ISWbemPrivilegeSet');
  CL.AddTypeS('SWbemRefreshableItem', 'ISWbemRefreshableItem');
  SIRegister_ISWbemServices(CL);
  SIRegister_ISWbemObject(CL);
  SIRegister_ISWbemObjectPath(CL);
  SIRegister_ISWbemNamedValueSet(CL);
  SIRegister_ISWbemNamedValue(CL);
  SIRegister_ISWbemSecurity(CL);
  SIRegister_ISWbemPrivilegeSet(CL);
  SIRegister_ISWbemPrivilege(CL);
  SIRegister_ISWbemObjectSet(CL);
  SIRegister_ISWbemQualifierSet(CL);
  SIRegister_ISWbemQualifier(CL);
  SIRegister_ISWbemPropertySet(CL);
  SIRegister_ISWbemProperty(CL);
  SIRegister_ISWbemMethodSet(CL);
  SIRegister_ISWbemMethod(CL);
  SIRegister_ISWbemEventSource(CL);
  SIRegister_ISWbemLocator(CL);
  SIRegister_ISWbemLastError(CL);
  SIRegister_ISWbemSink(CL);
  SIRegister_ISWbemServicesEx(CL);
  SIRegister_ISWbemObjectEx(CL);
  SIRegister_ISWbemDateTime(CL);
  SIRegister_ISWbemRefresher(CL);
  SIRegister_ISWbemRefreshableItem(CL);
  SIRegister_CoSWbemLocator(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSWbemLocatorProperties');
  SIRegister_TSWbemLocator(CL);
  SIRegister_TSWbemLocatorProperties(CL);
  SIRegister_CoSWbemNamedValueSet(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSWbemNamedValueSetProperties');
  SIRegister_TSWbemNamedValueSet(CL);
  SIRegister_TSWbemNamedValueSetProperties(CL);
  SIRegister_CoSWbemObjectPath(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSWbemObjectPathProperties');
  SIRegister_TSWbemObjectPath(CL);
  SIRegister_TSWbemObjectPathProperties(CL);
  SIRegister_CoSWbemLastError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSWbemLastErrorProperties');
  SIRegister_TSWbemLastError(CL);
  SIRegister_TSWbemLastErrorProperties(CL);
  SIRegister_CoSWbemSink(CL);
  CL.AddTypeS('TSWbemSinkOnObjectReady', 'Procedure ( Sender : TObject; var obj'
   +'WbemObject : OleVariant; var objWbemAsyncContext : OleVariant)');
  CL.AddTypeS('TSWbemSinkOnCompleted', 'Procedure ( Sender : TObject; iHResult '
   +': WbemErrorEnum; var objWbemErrorObject : OleVariant; var objWbemAsyncCont'
   +'ext : OleVariant)');
  CL.AddTypeS('TSWbemSinkOnProgress', 'Procedure ( Sender : TObject; iUpperBoun'
   +'d : Integer; iCurrent : Integer; var strMessage : OleVariant; var objWbemA'
   +'syncContext : OleVariant)');
  CL.AddTypeS('TSWbemSinkOnObjectPut', 'Procedure ( Sender : TObject; var objWb'
   +'emObjectPath : OleVariant; var objWbemAsyncContext : OleVariant)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSWbemSinkProperties');
  SIRegister_TSWbemSink(CL);
  SIRegister_TSWbemSinkProperties(CL);
  SIRegister_CoSWbemDateTime(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSWbemDateTimeProperties');
  SIRegister_TSWbemDateTime(CL);
  SIRegister_TSWbemDateTimeProperties(CL);
  SIRegister_CoSWbemRefresher(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TSWbemRefresherProperties');
  SIRegister_TSWbemRefresher(CL);
  SIRegister_TSWbemRefresherProperties(CL);
  SIRegister_CoSWbemServices(CL);
  SIRegister_CoSWbemServicesEx(CL);
  SIRegister_CoSWbemObject(CL);
  SIRegister_CoSWbemObjectEx(CL);
  SIRegister_CoSWbemObjectSet(CL);
  SIRegister_CoSWbemNamedValue(CL);
  SIRegister_CoSWbemQualifier(CL);
  SIRegister_CoSWbemQualifierSet(CL);
  SIRegister_CoSWbemProperty(CL);
  SIRegister_CoSWbemPropertySet(CL);
  SIRegister_CoSWbemMethod(CL);
  SIRegister_CoSWbemMethodSet(CL);
  SIRegister_CoSWbemEventSource(CL);
  SIRegister_CoSWbemSecurity(CL);
  SIRegister_CoSWbemPrivilege(CL);
  SIRegister_CoSWbemPrivilegeSet(CL);
  SIRegister_CoSWbemRefreshableItem(CL);
  SIRegister_ISIEnumVARIANT(CL);

 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
{procedure TSWbemRefresherPropertiesAutoReconnect_W(Self: TSWbemRefresherProperties; const T: WordBool);
begin Self.AutoReconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemRefresherPropertiesAutoReconnect_R(Self: TSWbemRefresherProperties; var T: WordBool);
begin T := Self.AutoReconnect; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemRefresherPropertiesDefaultInterface_R(Self: TSWbemRefresherProperties; var T: ISWbemRefresher);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemRefresherServer_R(Self: TSWbemRefresher; var T: TSWbemRefresherProperties);
begin T := Self.Server; end;  }

(*----------------------------------------------------------------------------*)
procedure TSWbemRefresherAutoReconnect_W(Self: TSWbemRefresher; const T: WordBool);
begin Self.AutoReconnect := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemRefresherAutoReconnect_R(Self: TSWbemRefresher; var T: WordBool);
begin T := Self.AutoReconnect; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemRefresherCount_R(Self: TSWbemRefresher; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemRefresherDefaultInterface_R(Self: TSWbemRefresher; var T: ISWbemRefresher);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
{procedure TSWbemDateTimePropertiesIsInterval_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.IsInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesIsInterval_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.IsInterval; end;
}
 {
(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesUTCSpecified_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.UTCSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesUTCSpecified_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.UTCSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesUTC_W(Self: TSWbemDateTimeProperties; const T: Integer);
begin Self.UTC := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesUTC_R(Self: TSWbemDateTimeProperties; var T: Integer);
begin T := Self.UTC; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMicrosecondsSpecified_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.MicrosecondsSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMicrosecondsSpecified_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.MicrosecondsSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMicroseconds_W(Self: TSWbemDateTimeProperties; const T: Integer);
begin Self.Microseconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMicroseconds_R(Self: TSWbemDateTimeProperties; var T: Integer);
begin T := Self.Microseconds; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesSecondsSpecified_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.SecondsSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesSecondsSpecified_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.SecondsSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesSeconds_W(Self: TSWbemDateTimeProperties; const T: Integer);
begin Self.Seconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesSeconds_R(Self: TSWbemDateTimeProperties; var T: Integer);
begin T := Self.Seconds; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMinutesSpecified_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.MinutesSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMinutesSpecified_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.MinutesSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMinutes_W(Self: TSWbemDateTimeProperties; const T: Integer);
begin Self.Minutes := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMinutes_R(Self: TSWbemDateTimeProperties; var T: Integer);
begin T := Self.Minutes; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesHoursSpecified_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.HoursSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesHoursSpecified_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.HoursSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesHours_W(Self: TSWbemDateTimeProperties; const T: Integer);
begin Self.Hours := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesHours_R(Self: TSWbemDateTimeProperties; var T: Integer);
begin T := Self.Hours; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesDaySpecified_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.DaySpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesDaySpecified_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.DaySpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesDay_W(Self: TSWbemDateTimeProperties; const T: Integer);
begin Self.Day := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesDay_R(Self: TSWbemDateTimeProperties; var T: Integer);
begin T := Self.Day; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMonthSpecified_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.MonthSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMonthSpecified_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.MonthSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMonth_W(Self: TSWbemDateTimeProperties; const T: Integer);
begin Self.Month := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesMonth_R(Self: TSWbemDateTimeProperties; var T: Integer);
begin T := Self.Month; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesYearSpecified_W(Self: TSWbemDateTimeProperties; const T: WordBool);
begin Self.YearSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesYearSpecified_R(Self: TSWbemDateTimeProperties; var T: WordBool);
begin T := Self.YearSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesYear_W(Self: TSWbemDateTimeProperties; const T: Integer);
begin Self.Year := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesYear_R(Self: TSWbemDateTimeProperties; var T: Integer);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesValue_W(Self: TSWbemDateTimeProperties; const T: WideString);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimePropertiesValue_R(Self: TSWbemDateTimeProperties; var T: WideString);
begin T := Self.Value; end;
}

(*----------------------------------------------------------------------------*)
{procedure TSWbemDateTimePropertiesDefaultInterface_R(Self: TSWbemDateTimeProperties; var T: ISWbemDateTime);
begin T := Self.DefaultInterface; end;
   }
{
(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeServer_R(Self: TSWbemDateTime; var T: TSWbemDateTimeProperties);
begin T := Self.Server; end;
    }
(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeIsInterval_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.IsInterval := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeIsInterval_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.IsInterval; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeUTCSpecified_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.UTCSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeUTCSpecified_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.UTCSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeUTC_W(Self: TSWbemDateTime; const T: Integer);
begin Self.UTC := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeUTC_R(Self: TSWbemDateTime; var T: Integer);
begin T := Self.UTC; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMicrosecondsSpecified_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.MicrosecondsSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMicrosecondsSpecified_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.MicrosecondsSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMicroseconds_W(Self: TSWbemDateTime; const T: Integer);
begin Self.Microseconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMicroseconds_R(Self: TSWbemDateTime; var T: Integer);
begin T := Self.Microseconds; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeSecondsSpecified_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.SecondsSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeSecondsSpecified_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.SecondsSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeSeconds_W(Self: TSWbemDateTime; const T: Integer);
begin Self.Seconds := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeSeconds_R(Self: TSWbemDateTime; var T: Integer);
begin T := Self.Seconds; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMinutesSpecified_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.MinutesSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMinutesSpecified_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.MinutesSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMinutes_W(Self: TSWbemDateTime; const T: Integer);
begin Self.Minutes := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMinutes_R(Self: TSWbemDateTime; var T: Integer);
begin T := Self.Minutes; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeHoursSpecified_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.HoursSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeHoursSpecified_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.HoursSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeHours_W(Self: TSWbemDateTime; const T: Integer);
begin Self.Hours := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeHours_R(Self: TSWbemDateTime; var T: Integer);
begin T := Self.Hours; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeDaySpecified_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.DaySpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeDaySpecified_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.DaySpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeDay_W(Self: TSWbemDateTime; const T: Integer);
begin Self.Day := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeDay_R(Self: TSWbemDateTime; var T: Integer);
begin T := Self.Day; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMonthSpecified_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.MonthSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMonthSpecified_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.MonthSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMonth_W(Self: TSWbemDateTime; const T: Integer);
begin Self.Month := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeMonth_R(Self: TSWbemDateTime; var T: Integer);
begin T := Self.Month; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeYearSpecified_W(Self: TSWbemDateTime; const T: WordBool);
begin Self.YearSpecified := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeYearSpecified_R(Self: TSWbemDateTime; var T: WordBool);
begin T := Self.YearSpecified; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeYear_W(Self: TSWbemDateTime; const T: Integer);
begin Self.Year := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeYear_R(Self: TSWbemDateTime; var T: Integer);
begin T := Self.Year; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeValue_W(Self: TSWbemDateTime; const T: WideString);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeValue_R(Self: TSWbemDateTime; var T: WideString);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemDateTimeDefaultInterface_R(Self: TSWbemDateTime; var T: ISWbemDateTime);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
{procedure TSWbemSinkPropertiesDefaultInterface_R(Self: TSWbemSinkProperties; var T: ISWbemSink);
begin T := Self.DefaultInterface; end;
 }
(*--- -------------------------------------------------------------------------*)
procedure TSWbemSinkOnObjectPut_W(Self: TSWbemSink; const T: TSWbemSinkOnObjectPut);
begin Self.OnObjectPut := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemSinkOnObjectPut_R(Self: TSWbemSink; var T: TSWbemSinkOnObjectPut);
begin T := Self.OnObjectPut; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemSinkOnProgress_W(Self: TSWbemSink; const T: TSWbemSinkOnProgress);
begin Self.OnProgress := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemSinkOnProgress_R(Self: TSWbemSink; var T: TSWbemSinkOnProgress);
begin T := Self.OnProgress; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemSinkOnCompleted_W(Self: TSWbemSink; const T: TSWbemSinkOnCompleted);
begin Self.OnCompleted := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemSinkOnCompleted_R(Self: TSWbemSink; var T: TSWbemSinkOnCompleted);
begin T := Self.OnCompleted; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemSinkOnObjectReady_W(Self: TSWbemSink; const T: TSWbemSinkOnObjectReady);
begin Self.OnObjectReady := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemSinkOnObjectReady_R(Self: TSWbemSink; var T: TSWbemSinkOnObjectReady);
begin T := Self.OnObjectReady; end;

(*----------------------------------------------------------------------------*)
//procedure TSWbemSinkServer_R(Self: TSWbemSink; var T: TSWbemSinkProperties);
//begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemSinkDefaultInterface_R(Self: TSWbemSink; var T: ISWbemSink);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
//procedure TSWbemLastErrorPropertiesDefaultInterface_R(Self: TSWbemLastErrorProperties; var T: ISWbemLastError);
//begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
//procedure TSWbemLastErrorServer_R(Self: TSWbemLastError; var T: TSWbemLastErrorProperties);
//begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLastErrorSecurity__R(Self: TSWbemLastError; var T: ISWbemSecurity);
begin T := Self.Security_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLastErrorPath__R(Self: TSWbemLastError; var T: ISWbemObjectPath);
begin T := Self.Path_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLastErrorDerivation__R(Self: TSWbemLastError; var T: OleVariant);
begin T := Self.Derivation_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLastErrorMethods__R(Self: TSWbemLastError; var T: ISWbemMethodSet);
begin T := Self.Methods_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLastErrorProperties__R(Self: TSWbemLastError; var T: ISWbemPropertySet);
begin T := Self.Properties_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLastErrorQualifiers__R(Self: TSWbemLastError; var T: ISWbemQualifierSet);
begin T := Self.Qualifiers_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLastErrorDefaultInterface_R(Self: TSWbemLastError; var T: ISWbemLastError);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
{procedure TSWbemObjectPathPropertiesAuthority_W(Self: TSWbemObjectPathProperties; const T: WideString);
begin Self.Authority := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesAuthority_R(Self: TSWbemObjectPathProperties; var T: WideString);
begin T := Self.Authority; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesLocale_W(Self: TSWbemObjectPathProperties; const T: WideString);
begin Self.Locale := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesLocale_R(Self: TSWbemObjectPathProperties; var T: WideString);
begin T := Self.Locale; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesClass__W(Self: TSWbemObjectPathProperties; const T: WideString);
begin Self.Class_ := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesClass__R(Self: TSWbemObjectPathProperties; var T: WideString);
begin T := Self.Class_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesDisplayName_W(Self: TSWbemObjectPathProperties; const T: WideString);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesDisplayName_R(Self: TSWbemObjectPathProperties; var T: WideString);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesNamespace_W(Self: TSWbemObjectPathProperties; const T: WideString);
begin Self.Namespace := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesNamespace_R(Self: TSWbemObjectPathProperties; var T: WideString);
begin T := Self.Namespace; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesServer_W(Self: TSWbemObjectPathProperties; const T: WideString);
begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesServer_R(Self: TSWbemObjectPathProperties; var T: WideString);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesRelPath_W(Self: TSWbemObjectPathProperties; const T: WideString);
begin Self.RelPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesRelPath_R(Self: TSWbemObjectPathProperties; var T: WideString);
begin T := Self.RelPath; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesPath_W(Self: TSWbemObjectPathProperties; const T: WideString);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesPath_R(Self: TSWbemObjectPathProperties; var T: WideString);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPropertiesDefaultInterface_R(Self: TSWbemObjectPathProperties; var T: ISWbemObjectPath);
begin T := Self.DefaultInterface; end;    }

(*----------------------------------------------------------------------------*)
//procedure TSWbemObjectPathServer_R(Self: TSWbemObjectPath; var T: TSWbemObjectPathProperties);
//begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathAuthority_W(Self: TSWbemObjectPath; const T: WideString);
begin Self.Authority := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathAuthority_R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.Authority; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathLocale_W(Self: TSWbemObjectPath; const T: WideString);
begin Self.Locale := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathLocale_R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.Locale; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathClass__W(Self: TSWbemObjectPath; const T: WideString);
begin Self.Class_ := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathClass__R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.Class_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathDisplayName_W(Self: TSWbemObjectPath; const T: WideString);
begin Self.DisplayName := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathDisplayName_R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.DisplayName; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathNamespace_W(Self: TSWbemObjectPath; const T: WideString);
begin Self.Namespace := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathNamespace_R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.Namespace; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathServer_W(Self: TSWbemObjectPath; const T: WideString);
begin Self.Server := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathServer_R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.Server; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathRelPath_W(Self: TSWbemObjectPath; const T: WideString);
begin Self.RelPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathRelPath_R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.RelPath; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPath_W(Self: TSWbemObjectPath; const T: WideString);
begin Self.Path := T; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathPath_R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.Path; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathSecurity__R(Self: TSWbemObjectPath; var T: ISWbemSecurity);
begin T := Self.Security_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathKeys_R(Self: TSWbemObjectPath; var T: ISWbemNamedValueSet);
begin T := Self.Keys; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathIsSingleton_R(Self: TSWbemObjectPath; var T: WordBool);
begin T := Self.IsSingleton; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathIsClass_R(Self: TSWbemObjectPath; var T: WordBool);
begin T := Self.IsClass; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathParentNamespace_R(Self: TSWbemObjectPath; var T: WideString);
begin T := Self.ParentNamespace; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemObjectPathDefaultInterface_R(Self: TSWbemObjectPath; var T: ISWbemObjectPath);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
{procedure TSWbemNamedValueSetPropertiesDefaultInterface_R(Self: TSWbemNamedValueSetProperties; var T: ISWbemNamedValueSet);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemNamedValueSetServer_R(Self: TSWbemNamedValueSet; var T: TSWbemNamedValueSetProperties);
begin T := Self.Server; end;
}

(*----------------------------------------------------------------------------*)
procedure TSWbemNamedValueSetCount_R(Self: TSWbemNamedValueSet; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemNamedValueSetDefaultInterface_R(Self: TSWbemNamedValueSet; var T: ISWbemNamedValueSet);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
{procedure TSWbemLocatorPropertiesDefaultInterface_R(Self: TSWbemLocatorProperties; var T: ISWbemLocator);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLocatorServer_R(Self: TSWbemLocator; var T: TSWbemLocatorProperties);
begin T := Self.Server; end;
}

(*----------------------------------------------------------------------------*)
procedure TSWbemLocatorSecurity__R(Self: TSWbemLocator; var T: ISWbemSecurity);
begin T := Self.Security_; end;

(*----------------------------------------------------------------------------*)
procedure TSWbemLocatorDefaultInterface_R(Self: TSWbemLocator; var T: ISWbemLocator);
begin T := Self.DefaultInterface; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WbemScripting_TLB_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemRefreshableItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemRefreshableItem) do
  begin
    RegisterMethod(@CoSWbemRefreshableItem.Create, 'Create');
    RegisterMethod(@CoSWbemRefreshableItem.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemPrivilegeSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemPrivilegeSet) do
  begin
    RegisterMethod(@CoSWbemPrivilegeSet.Create, 'Create');
    RegisterMethod(@CoSWbemPrivilegeSet.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemPrivilege(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemPrivilege) do
  begin
    RegisterMethod(@CoSWbemPrivilege.Create, 'Create');
    RegisterMethod(@CoSWbemPrivilege.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemSecurity(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemSecurity) do
  begin
    RegisterMethod(@CoSWbemSecurity.Create, 'Create');
    RegisterMethod(@CoSWbemSecurity.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemEventSource(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemEventSource) do
  begin
    RegisterMethod(@CoSWbemEventSource.Create, 'Create');
    RegisterMethod(@CoSWbemEventSource.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemMethodSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemMethodSet) do
  begin
    RegisterMethod(@CoSWbemMethodSet.Create, 'Create');
    RegisterMethod(@CoSWbemMethodSet.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemMethod(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemMethod) do
  begin
    RegisterMethod(@CoSWbemMethod.Create, 'Create');
    RegisterMethod(@CoSWbemMethod.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemPropertySet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemPropertySet) do
  begin
    RegisterMethod(@CoSWbemPropertySet.Create, 'Create');
    RegisterMethod(@CoSWbemPropertySet.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemProperty(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemProperty) do
  begin
    RegisterMethod(@CoSWbemProperty.Create, 'Create');
    RegisterMethod(@CoSWbemProperty.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemQualifierSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemQualifierSet) do
  begin
    RegisterMethod(@CoSWbemQualifierSet.Create, 'Create');
    RegisterMethod(@CoSWbemQualifierSet.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemQualifier(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemQualifier) do
  begin
    RegisterMethod(@CoSWbemQualifier.Create, 'Create');
    RegisterMethod(@CoSWbemQualifier.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemNamedValue(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemNamedValue) do
  begin
    RegisterMethod(@CoSWbemNamedValue.Create, 'Create');
    RegisterMethod(@CoSWbemNamedValue.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemObjectSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemObjectSet) do
  begin
    RegisterMethod(@CoSWbemObjectSet.Create, 'Create');
    RegisterMethod(@CoSWbemObjectSet.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemObjectEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemObjectEx) do
  begin
    RegisterMethod(@CoSWbemObjectEx.Create, 'Create');
    RegisterMethod(@CoSWbemObjectEx.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemObject) do
  begin
    RegisterMethod(@CoSWbemObject.Create, 'Create');
    RegisterMethod(@CoSWbemObject.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemServicesEx(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemServicesEx) do
  begin
    RegisterMethod(@CoSWbemServicesEx.Create, 'Create');
    RegisterMethod(@CoSWbemServicesEx.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemServices(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemServices) do
  begin
    RegisterMethod(@CoSWbemServices.Create, 'Create');
    RegisterMethod(@CoSWbemServices.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemRefresherProperties(CL: TPSRuntimeClassImporter);
begin
 { with CL.Add(TSWbemRefresherProperties) do
  begin
    RegisterPropertyHelper(@TSWbemRefresherPropertiesDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemRefresherPropertiesAutoReconnect_R,@TSWbemRefresherPropertiesAutoReconnect_W,'AutoReconnect');
  end;  }
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemRefresher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSWbemRefresher) do
  begin
    RegisterMethod(@TSWbemRefresher.ConnectTo, 'ConnectTo');
    RegisterMethod(@TSWbemRefresher.Item, 'Item');
    RegisterMethod(@TSWbemRefresher.Add, 'Add');
    RegisterMethod(@TSWbemRefresher.AddEnum, 'AddEnum');
    RegisterMethod(@TSWbemRefresher.Remove, 'Remove');
    RegisterMethod(@TSWbemRefresher.Refresh, 'Refresh');
    RegisterMethod(@TSWbemRefresher.DeleteAll, 'DeleteAll');
    RegisterPropertyHelper(@TSWbemRefresherDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemRefresherCount_R,nil,'Count');
    RegisterPropertyHelper(@TSWbemRefresherAutoReconnect_R,@TSWbemRefresherAutoReconnect_W,'AutoReconnect');
    //RegisterPropertyHelper(@TSWbemRefresherServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemRefresher(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemRefresher) do
  begin
    RegisterMethod(@CoSWbemRefresher.Create, 'Create');
    RegisterMethod(@CoSWbemRefresher.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemDateTimeProperties(CL: TPSRuntimeClassImporter);
begin
 { with CL.Add(TSWbemDateTimeProperties) do
  begin
    RegisterPropertyHelper(@TSWbemDateTimePropertiesDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesValue_R,@TSWbemDateTimePropertiesValue_W,'Value');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesYear_R,@TSWbemDateTimePropertiesYear_W,'Year');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesYearSpecified_R,@TSWbemDateTimePropertiesYearSpecified_W,'YearSpecified');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesMonth_R,@TSWbemDateTimePropertiesMonth_W,'Month');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesMonthSpecified_R,@TSWbemDateTimePropertiesMonthSpecified_W,'MonthSpecified');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesDay_R,@TSWbemDateTimePropertiesDay_W,'Day');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesDaySpecified_R,@TSWbemDateTimePropertiesDaySpecified_W,'DaySpecified');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesHours_R,@TSWbemDateTimePropertiesHours_W,'Hours');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesHoursSpecified_R,@TSWbemDateTimePropertiesHoursSpecified_W,'HoursSpecified');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesMinutes_R,@TSWbemDateTimePropertiesMinutes_W,'Minutes');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesMinutesSpecified_R,@TSWbemDateTimePropertiesMinutesSpecified_W,'MinutesSpecified');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesSeconds_R,@TSWbemDateTimePropertiesSeconds_W,'Seconds');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesSecondsSpecified_R,@TSWbemDateTimePropertiesSecondsSpecified_W,'SecondsSpecified');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesMicroseconds_R,@TSWbemDateTimePropertiesMicroseconds_W,'Microseconds');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesMicrosecondsSpecified_R,@TSWbemDateTimePropertiesMicrosecondsSpecified_W,'MicrosecondsSpecified');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesUTC_R,@TSWbemDateTimePropertiesUTC_W,'UTC');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesUTCSpecified_R,@TSWbemDateTimePropertiesUTCSpecified_W,'UTCSpecified');
    RegisterPropertyHelper(@TSWbemDateTimePropertiesIsInterval_R,@TSWbemDateTimePropertiesIsInterval_W,'IsInterval');
  end; }
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemDateTime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSWbemDateTime) do
  begin
    RegisterConstructor(@TSWbemDateTime.Create, 'Create');
    RegisterMethod(@TSWbemDateTime.Connect, 'Connect');
    RegisterMethod(@TSWbemDateTime.ConnectTo, 'ConnectTo');
    RegisterMethod(@TSWbemDateTime.Disconnect, 'Disconnect');
    RegisterMethod(@TSWbemDateTime.GetVarDate, 'GetVarDate');
    RegisterMethod(@TSWbemDateTime.SetVarDate, 'SetVarDate');
    RegisterMethod(@TSWbemDateTime.GetFileTime, 'GetFileTime');
    RegisterMethod(@TSWbemDateTime.SetFileTime, 'SetFileTime');
    RegisterPropertyHelper(@TSWbemDateTimeDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemDateTimeValue_R,@TSWbemDateTimeValue_W,'Value');
    RegisterPropertyHelper(@TSWbemDateTimeYear_R,@TSWbemDateTimeYear_W,'Year');
    RegisterPropertyHelper(@TSWbemDateTimeYearSpecified_R,@TSWbemDateTimeYearSpecified_W,'YearSpecified');
    RegisterPropertyHelper(@TSWbemDateTimeMonth_R,@TSWbemDateTimeMonth_W,'Month');
    RegisterPropertyHelper(@TSWbemDateTimeMonthSpecified_R,@TSWbemDateTimeMonthSpecified_W,'MonthSpecified');
    RegisterPropertyHelper(@TSWbemDateTimeDay_R,@TSWbemDateTimeDay_W,'Day');
    RegisterPropertyHelper(@TSWbemDateTimeDaySpecified_R,@TSWbemDateTimeDaySpecified_W,'DaySpecified');
    RegisterPropertyHelper(@TSWbemDateTimeHours_R,@TSWbemDateTimeHours_W,'Hours');
    RegisterPropertyHelper(@TSWbemDateTimeHoursSpecified_R,@TSWbemDateTimeHoursSpecified_W,'HoursSpecified');
    RegisterPropertyHelper(@TSWbemDateTimeMinutes_R,@TSWbemDateTimeMinutes_W,'Minutes');
    RegisterPropertyHelper(@TSWbemDateTimeMinutesSpecified_R,@TSWbemDateTimeMinutesSpecified_W,'MinutesSpecified');
    RegisterPropertyHelper(@TSWbemDateTimeSeconds_R,@TSWbemDateTimeSeconds_W,'Seconds');
    RegisterPropertyHelper(@TSWbemDateTimeSecondsSpecified_R,@TSWbemDateTimeSecondsSpecified_W,'SecondsSpecified');
    RegisterPropertyHelper(@TSWbemDateTimeMicroseconds_R,@TSWbemDateTimeMicroseconds_W,'Microseconds');
    RegisterPropertyHelper(@TSWbemDateTimeMicrosecondsSpecified_R,@TSWbemDateTimeMicrosecondsSpecified_W,'MicrosecondsSpecified');
    RegisterPropertyHelper(@TSWbemDateTimeUTC_R,@TSWbemDateTimeUTC_W,'UTC');
    RegisterPropertyHelper(@TSWbemDateTimeUTCSpecified_R,@TSWbemDateTimeUTCSpecified_W,'UTCSpecified');
    RegisterPropertyHelper(@TSWbemDateTimeIsInterval_R,@TSWbemDateTimeIsInterval_W,'IsInterval');
    //RegisterPropertyHelper(@TSWbemDateTimeServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemDateTime(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemDateTime) do
  begin
    RegisterMethod(@CoSWbemDateTime.Create, 'Create');
    RegisterMethod(@CoSWbemDateTime.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemSinkProperties(CL: TPSRuntimeClassImporter);
begin
  {with CL.Add(TSWbemSinkProperties) do
  begin
    RegisterPropertyHelper(@TSWbemSinkPropertiesDefaultInterface_R,nil,'DefaultInterface');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemSink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSWbemSink) do
  begin
    RegisterConstructor(@TSWbemSink.Create, 'Create');
    RegisterMethod(@TSWbemSink.Connect, 'Connect');
    RegisterMethod(@TSWbemSink.ConnectTo, 'ConnectTo');
    RegisterMethod(@TSWbemSink.Disconnect, 'Disconnect');
    RegisterMethod(@TSWbemSink.Cancel, 'Cancel');
    RegisterPropertyHelper(@TSWbemSinkDefaultInterface_R,nil,'DefaultInterface');
  //  RegisterPropertyHelper(@TSWbemSinkServer_R,nil,'Server');
    RegisterPropertyHelper(@TSWbemSinkOnObjectReady_R,@TSWbemSinkOnObjectReady_W,'OnObjectReady');
    RegisterPropertyHelper(@TSWbemSinkOnCompleted_R,@TSWbemSinkOnCompleted_W,'OnCompleted');
    RegisterPropertyHelper(@TSWbemSinkOnProgress_R,@TSWbemSinkOnProgress_W,'OnProgress');
    RegisterPropertyHelper(@TSWbemSinkOnObjectPut_R,@TSWbemSinkOnObjectPut_W,'OnObjectPut');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemSink(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemSink) do
  begin
    RegisterMethod(@CoSWbemSink.Create, 'Create');
    RegisterMethod(@CoSWbemSink.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemLastErrorProperties(CL: TPSRuntimeClassImporter);
begin
 { with CL.Add(TSWbemLastErrorProperties) do
  begin
    RegisterPropertyHelper(@TSWbemLastErrorPropertiesDefaultInterface_R,nil,'DefaultInterface');
  end; }
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemLastError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSWbemLastError) do
  begin
    RegisterConstructor(@TSWbemLastError.Create, 'Create');
    RegisterMethod(@TSWbemLastError.Connect, 'Connect');
    RegisterMethod(@TSWbemLastError.ConnectTo, 'ConnectTo');
    RegisterMethod(@TSWbemLastError.Disconnect, 'Disconnect');
    RegisterMethod(@TSWbemLastError.Put_, 'Put_');
    RegisterMethod(@TSWbemLastError.PutAsync_, 'PutAsync_');
    RegisterMethod(@TSWbemLastError.Delete_, 'Delete_');
    RegisterMethod(@TSWbemLastError.DeleteAsync_, 'DeleteAsync_');
    RegisterMethod(@TSWbemLastError.Instances_, 'Instances_');
    RegisterMethod(@TSWbemLastError.InstancesAsync_, 'InstancesAsync_');
    RegisterMethod(@TSWbemLastError.Subclasses_, 'Subclasses_');
    RegisterMethod(@TSWbemLastError.SubclassesAsync_, 'SubclassesAsync_');
    RegisterMethod(@TSWbemLastError.Associators_, 'Associators_');
    RegisterMethod(@TSWbemLastError.AssociatorsAsync_, 'AssociatorsAsync_');
    RegisterMethod(@TSWbemLastError.References_, 'References_');
    RegisterMethod(@TSWbemLastError.ReferencesAsync_, 'ReferencesAsync_');
    RegisterMethod(@TSWbemLastError.ExecMethod_, 'ExecMethod_');
    RegisterMethod(@TSWbemLastError.ExecMethodAsync_, 'ExecMethodAsync_');
    RegisterMethod(@TSWbemLastError.Clone_, 'Clone_');
    RegisterMethod(@TSWbemLastError.GetObjectText_, 'GetObjectText_');
    RegisterMethod(@TSWbemLastError.SpawnDerivedClass_, 'SpawnDerivedClass_');
    RegisterMethod(@TSWbemLastError.SpawnInstance_, 'SpawnInstance_');
    RegisterMethod(@TSWbemLastError.CompareTo_, 'CompareTo_');
    RegisterPropertyHelper(@TSWbemLastErrorDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemLastErrorQualifiers__R,nil,'Qualifiers_');
    RegisterPropertyHelper(@TSWbemLastErrorProperties__R,nil,'Properties_');
    RegisterPropertyHelper(@TSWbemLastErrorMethods__R,nil,'Methods_');
    RegisterPropertyHelper(@TSWbemLastErrorDerivation__R,nil,'Derivation_');
    RegisterPropertyHelper(@TSWbemLastErrorPath__R,nil,'Path_');
    RegisterPropertyHelper(@TSWbemLastErrorSecurity__R,nil,'Security_');
    //RegisterPropertyHelper(@TSWbemLastErrorServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemLastError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemLastError) do
  begin
    RegisterMethod(@CoSWbemLastError.Create, 'Create');
    RegisterMethod(@CoSWbemLastError.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemObjectPathProperties(CL: TPSRuntimeClassImporter);
begin
  {with CL.Add(TSWbemObjectPathProperties) do
  begin
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesPath_R,@TSWbemObjectPathPropertiesPath_W,'Path');
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesRelPath_R,@TSWbemObjectPathPropertiesRelPath_W,'RelPath');
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesServer_R,@TSWbemObjectPathPropertiesServer_W,'Server');
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesNamespace_R,@TSWbemObjectPathPropertiesNamespace_W,'Namespace');
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesDisplayName_R,@TSWbemObjectPathPropertiesDisplayName_W,'DisplayName');
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesClass__R,@TSWbemObjectPathPropertiesClass__W,'Class_');
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesLocale_R,@TSWbemObjectPathPropertiesLocale_W,'Locale');
    RegisterPropertyHelper(@TSWbemObjectPathPropertiesAuthority_R,@TSWbemObjectPathPropertiesAuthority_W,'Authority');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemObjectPath(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSWbemObjectPath) do begin
    RegisterConstructor(@TSWbemObjectPath.Create, 'Create');
    RegisterMethod(@TSWbemObjectPath.Connect, 'Connect');
    RegisterMethod(@TSWbemObjectPath.ConnectTo, 'ConnectTo');
    RegisterMethod(@TSWbemObjectPath.Disconnect, 'Disconnect');
    RegisterMethod(@TSWbemObjectPath.SetAsClass, 'SetAsClass');
       RegisterMethod(@TSWbemObjectPath.Destroy, 'Free');

    RegisterMethod(@TSWbemObjectPath.SetAsSingleton, 'SetAsSingleton');
    RegisterPropertyHelper(@TSWbemObjectPathDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemObjectPathParentNamespace_R,nil,'ParentNamespace');
    RegisterPropertyHelper(@TSWbemObjectPathIsClass_R,nil,'IsClass');
    RegisterPropertyHelper(@TSWbemObjectPathIsSingleton_R,nil,'IsSingleton');
    RegisterPropertyHelper(@TSWbemObjectPathKeys_R,nil,'Keys');
    RegisterPropertyHelper(@TSWbemObjectPathSecurity__R,nil,'Security_');
    RegisterPropertyHelper(@TSWbemObjectPathPath_R,@TSWbemObjectPathPath_W,'Path');
    RegisterPropertyHelper(@TSWbemObjectPathRelPath_R,@TSWbemObjectPathRelPath_W,'RelPath');
    RegisterPropertyHelper(@TSWbemObjectPathServer_R,@TSWbemObjectPathServer_W,'Server');
    RegisterPropertyHelper(@TSWbemObjectPathNamespace_R,@TSWbemObjectPathNamespace_W,'Namespace');
    RegisterPropertyHelper(@TSWbemObjectPathDisplayName_R,@TSWbemObjectPathDisplayName_W,'DisplayName');
    RegisterPropertyHelper(@TSWbemObjectPathClass__R,@TSWbemObjectPathClass__W,'Class_');
    RegisterPropertyHelper(@TSWbemObjectPathLocale_R,@TSWbemObjectPathLocale_W,'Locale');
    RegisterPropertyHelper(@TSWbemObjectPathAuthority_R,@TSWbemObjectPathAuthority_W,'Authority');
    RegisterPropertyHelper(@TSWbemObjectPathServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemObjectPath(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemObjectPath) do
  begin
    RegisterMethod(@CoSWbemObjectPath.Create, 'Create');
    RegisterMethod(@CoSWbemObjectPath.CreateRemote, 'CreateRemote');
  end;
end;

procedure RIRegister_ISIEnumVARIANT(CL: TPSRuntimeClassImporter);
begin
  //with CL.Add(IEnumVARIANT) do
  {  with CL.AddInterface(CL.FindInterface('IDispatch'),IEnumVARIANT, 'IEnumVARIANT') do begin
    RegisterMethod(@Next, 'Next');
    RegisterMethod(@Skip, 'Skip');
    RegisterMethod(@Reset, 'Reset');

  end; }
end;


{procedure SIRegister_ISIEnumVARIANT(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IDispatch', 'ISWbemMethodSet') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IEnumVARIANT, 'IEnumVARIANT') do
  begin
    RegisterMethod('Function Next(celt: LongWord; var rgvar : OleVariant; out pceltFetched: LongWord) : HResult', CdStdCall);
    RegisterMethod('Function Skip(celt: LongWord) : HResult', CdStdCall);
    RegisterMethod('Function Reset : HResult', CdStdCall);
  end;
end;  }


(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemNamedValueSetProperties(CL: TPSRuntimeClassImporter);
begin
{  with CL.Add(TSWbemNamedValueSetProperties) do
  begin
    RegisterPropertyHelper(@TSWbemNamedValueSetPropertiesDefaultInterface_R,nil,'DefaultInterface');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemNamedValueSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSWbemNamedValueSet) do begin
    RegisterConstructor(@TSWbemNamedValueSet.Create, 'Create');
    RegisterMethod(@TSWbemNamedValueSet.Connect, 'Connect');
    RegisterMethod(@TSWbemNamedValueSet.ConnectTo, 'ConnectTo');
    RegisterMethod(@TSWbemNamedValueSet.Disconnect, 'Disconnect');
       RegisterMethod(@TSWbemNamedValueSet.Destroy, 'Free');

    RegisterMethod(@TSWbemNamedValueSet.Item, 'Item');
    RegisterMethod(@TSWbemNamedValueSet.Add, 'Add');
    RegisterMethod(@TSWbemNamedValueSet.Remove, 'Remove');
    RegisterMethod(@TSWbemNamedValueSet.Clone, 'Clone');
    RegisterMethod(@TSWbemNamedValueSet.DeleteAll, 'DeleteAll');
    RegisterPropertyHelper(@TSWbemNamedValueSetDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemNamedValueSetCount_R,nil,'Count');
   // RegisterPropertyHelper(@TSWbemNamedValueSetServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemNamedValueSet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemNamedValueSet) do
  begin
    RegisterMethod(@CoSWbemNamedValueSet.Create, 'Create');
    RegisterMethod(@CoSWbemNamedValueSet.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemLocatorProperties(CL: TPSRuntimeClassImporter);
begin
{  with CL.Add(TSWbemLocatorProperties) do
  begin
    RegisterPropertyHelper(@TSWbemLocatorPropertiesDefaultInterface_R,nil,'DefaultInterface');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSWbemLocator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSWbemLocator) do begin
    RegisterConstructor(@TSWbemLocator.Create, 'Create');
      RegisterMethod(@TSWbemLocator.Destroy, 'Free');
       RegisterMethod(@TSWbemLocator.Connect, 'Connect');
    RegisterMethod(@TSWbemLocator.ConnectTo, 'ConnectTo');
    RegisterMethod(@TSWbemLocator.ConnectServer, 'ConnectServer');
    RegisterPropertyHelper(@TSWbemLocatorDefaultInterface_R,nil,'DefaultInterface');
    RegisterPropertyHelper(@TSWbemLocatorSecurity__R,nil,'Security_');
   // RegisterPropertyHelper(@TSWbemLocatorServer_R,nil,'Server');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CoSWbemLocator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(CoSWbemLocator) do
  begin
    RegisterMethod(@CoSWbemLocator.Create, 'Create');
    RegisterMethod(@CoSWbemLocator.CreateRemote, 'CreateRemote');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WbemScripting_TLB(CL: TPSRuntimeClassImporter);
begin
  RIRegister_CoSWbemLocator(CL);
  //with CL.Add(TSWbemLocatorProperties) do
  RIRegister_TSWbemLocator(CL);
  //RIRegister_TSWbemLocatorProperties(CL);
  RIRegister_CoSWbemNamedValueSet(CL);
  //with CL.Add(TSWbemNamedValueSetProperties) do
  RIRegister_TSWbemNamedValueSet(CL);
  ///RIRegister_TSWbemNamedValueSetProperties(CL);
  RIRegister_CoSWbemObjectPath(CL);
  //with CL.Add(TSWbemObjectPathProperties) do
  RIRegister_TSWbemObjectPath(CL);
 // RIRegister_TSWbemObjectPathProperties(CL);
  RIRegister_CoSWbemLastError(CL);
  //with CL.Add(TSWbemLastErrorProperties) do
  RIRegister_TSWbemLastError(CL);
  //RIRegister_TSWbemLastErrorProperties(CL);
  RIRegister_CoSWbemSink(CL);
  //with CL.Add(TSWbemSinkProperties) do
  RIRegister_TSWbemSink(CL);
  RIRegister_TSWbemSinkProperties(CL);
  RIRegister_CoSWbemDateTime(CL);
 // with CL.Add(TSWbemDateTimeProperties) do
  RIRegister_TSWbemDateTime(CL);
  //RIRegister_TSWbemDateTimeProperties(CL);
  RIRegister_CoSWbemRefresher(CL);
  //with CL.Add(TSWbemRefresherProperties) do
  RIRegister_TSWbemRefresher(CL);
  //RIRegister_TSWbemRefresherProperties(CL);
  RIRegister_CoSWbemServices(CL);
  RIRegister_CoSWbemServicesEx(CL);
  RIRegister_CoSWbemObject(CL);
  RIRegister_CoSWbemObjectEx(CL);
  RIRegister_CoSWbemObjectSet(CL);
  RIRegister_CoSWbemNamedValue(CL);
  RIRegister_CoSWbemQualifier(CL);
  RIRegister_CoSWbemQualifierSet(CL);
  RIRegister_CoSWbemProperty(CL);
  RIRegister_CoSWbemPropertySet(CL);
  RIRegister_CoSWbemMethod(CL);
  RIRegister_CoSWbemMethodSet(CL);
  RIRegister_CoSWbemEventSource(CL);
  RIRegister_CoSWbemSecurity(CL);
  RIRegister_CoSWbemPrivilege(CL);
  RIRegister_CoSWbemPrivilegeSet(CL);
  RIRegister_CoSWbemRefreshableItem(CL);
  //RIRegister_ISIEnumVARIANT(CL);
end;



{ TPSImport_WbemScripting_TLB }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WbemScripting_TLB.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WbemScripting_TLB(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WbemScripting_TLB.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WbemScripting_TLB(ri);
  RIRegister_WbemScripting_TLB_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
