unit uPSI_interface2_so;
{
  interface tester
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
  TPSImport_interface2_so = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIncomeRealSuper(CL: TPSPascalCompiler);
procedure SIRegister_TIncomeRealIntf(CL: TPSPascalCompiler);
procedure SIRegister_IIncomeInt(CL: TPSPascalCompiler);
procedure SIRegister_interface2_so(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIncomeRealSuper(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIncomeRealIntf(CL: TPSRuntimeClassImporter);
procedure RIRegister_interface2_so(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // QDialogs
  TypInfo, interface2_so;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_interface2_so]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIncomeRealSuper2(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TIncomeRealSuper2') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TIncomeRealSuper2') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function GetIncome( const aNetto : Currency) : Currency');
    RegisterMethod('Function queryDLLInterface( var queryList : TStringList) : TStringList');
    RegisterMethod('Function queryDLLInterfaceTwo( var queryList : TStringList) : TStringList');
    RegisterMethod('Procedure SetRate( const aPercent, aYear : integer)');
    RegisterProperty('Rate', 'Double', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIncomeRealSuper(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TIncomeRealSuper') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TIncomeRealSuper') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function GetIncome(const aNetto : Extended) : Extended');
    RegisterMethod('Function queryDLLInterface( var queryList : TStringList) : TStringList');
    RegisterMethod('Function queryDLLInterfaceTwo( var queryList : TStringList) : TStringList');
    RegisterMethod('Procedure SetRate( const aPercent, aYear : integer)');
    RegisterProperty('Rate', 'Double', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIncomeRealIntf(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TIncomeRealIntf') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TIncomeRealIntf') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function GetIncome2( const aNetto : Currency) : Currency');
    RegisterMethod('Function GetIncome( const aNetto : Extended) : Extended');
    RegisterMethod('Function queryDLLInterface( var queryList : TStringList) : TStringList');
    RegisterMethod('Function queryDLLInterfaceTwo( var queryList : TStringList) : TStringList');
    RegisterMethod('Procedure SetRate( const aPercent, aYear : integer)');
    RegisterProperty('Rate', 'Double', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IIncomeInt(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IIncomeInt') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IIncomeInt, 'IIncomeInt') do begin
    RegisterMethod('Function GetIncome2( const aNetto : Currency): Currency',CdStdCall);
    RegisterMethod('Function GetIncome( const aNetto : Extended): Extended',CdStdCall);
    RegisterMethod('Function GetRate : Double', cdRegister);
    RegisterMethod('Function queryDLLInterface( var queryList : TStringList) : TStringList', CdStdCall);
    RegisterMethod('Function queryDLLInterfaceTwo( var queryList : TStringList) : TStringList', CdStdCall);
    RegisterMethod('Procedure SetRate( const aPercent, aYear : integer)', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_interface2_so(CL: TPSPascalCompiler);
begin

  SIRegister_IIncomeInt(CL);
  SIRegister_TIncomeRealIntf(CL);
  SIRegister_TIncomeRealSuper(CL);
  SIRegister_TIncomeRealSuper2(CL);
  CL.AddTypeS('IIncome', 'IIncomeInt');
  CL.AddTypeS('TIncome', 'TIncomeRealIntf');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure TIncomeRealSuperRate_R(Self: TIncomeRealSuper; var T: Single);
begin T := Self.Rate; end;

(*----------------------------------------------------------------------------*)
procedure TIncomeRealIntfRate_R(Self: TIncomeRealIntf; var T: Single);
begin T := Self.Rate; end;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIncomeRealSuper(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIncomeRealSuper) do begin
    RegisterConstructor(@TIncomeRealSuper.Create, 'Create');
    RegisterMethod(@TIncomeRealSuper.GetIncome, 'GetIncome');
    RegisterMethod(@TIncomeRealSuper.queryDLLInterface, 'queryDLLInterface');
    RegisterMethod(@TIncomeRealSuper.queryDLLInterfaceTwo, 'queryDLLInterfaceTwo');
    RegisterMethod(@TIncomeRealSuper.SetRate, 'SetRate');
    RegisterPropertyHelper(@TIncomeRealSuperRate_R,nil,'Rate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIncomeRealIntf(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIncomeRealIntf) do begin
    RegisterConstructor(@TIncomeRealIntf.Create, 'Create');
    RegisterMethod(@TIncomeRealIntf.GetIncome, 'GetIncome');
    RegisterMethod(@TIncomeRealIntf.queryDLLInterface, 'queryDLLInterface');
    RegisterMethod(@TIncomeRealIntf.queryDLLInterfaceTwo, 'queryDLLInterfaceTwo');
    RegisterMethod(@TIncomeRealIntf.SetRate, 'SetRate');
    RegisterPropertyHelper(@TIncomeRealIntfRate_R,nil,'Rate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_interface2_so(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIncomeRealIntf(CL);
  RIRegister_TIncomeRealSuper(CL);
end;



{ TPSImport_interface2_so }
(*----------------------------------------------------------------------------*)
procedure TPSImport_interface2_so.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_interface2_so(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_interface2_so.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
end;
(*----------------------------------------------------------------------------*)
 
 
end.
