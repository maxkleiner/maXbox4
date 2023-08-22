unit uPSI_WDCCOleVariantEnum;
{
//set intf: 1C06BCF6-1C6D-473E-993F-2B231B17D4F5
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
  TPSImport_WDCCOleVariantEnum = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOleVariantArrayEnum(CL: TPSPascalCompiler);
procedure SIRegister_TOleVariantEnum(CL: TPSPascalCompiler);
procedure SIRegister_IGetOleVariantEnum(CL: TPSPascalCompiler);
procedure SIRegister_IOleVariantEnum(CL: TPSPascalCompiler);
procedure SIRegister_WDCCOleVariantEnum(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_WDCCOleVariantEnum_Routines(S: TPSExec);
procedure RIRegister_TOleVariantArrayEnum(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOleVariantEnum(CL: TPSRuntimeClassImporter);
procedure RIRegister_WDCCOleVariantEnum(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ActiveX
  ,WDCCOleVariantEnum
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_WDCCOleVariantEnum]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOleVariantArrayEnum(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TOleVariantArrayEnum') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TOleVariantArrayEnum') do
  begin
    RegisterMethod('Function GetEnumerator : IOleVariantEnum');
    RegisterMethod('Constructor Create( Collection : OLEVariant)');
    RegisterMethod('Function GetCurrent : OLEVariant');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'OLEVariant', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOleVariantEnum(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TOleVariantEnum') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TOleVariantEnum') do
  begin
    RegisterMethod('Function GetEnumerator : IOleVariantEnum');
    RegisterMethod('Constructor Create( Collection : OLEVariant)');
    RegisterMethod('Function GetCurrent : OLEVariant');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'OLEVariant', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IGetOleVariantEnum(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IGetOleVariantEnum') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IGetOleVariantEnum, 'IGetOleVariantEnum') do
  begin
    RegisterMethod('Function GetEnumerator : IOleVariantEnum', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IOleVariantEnum(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IOleVariantEnum') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IOleVariantEnum, 'IOleVariantEnum') do
  begin
    RegisterMethod('Function GetCurrent : OLEVariant', cdRegister);
    RegisterMethod('Function MoveNext : Boolean', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_WDCCOleVariantEnum(CL: TPSPascalCompiler);
begin
  SIRegister_IOleVariantEnum(CL);
  SIRegister_IGetOleVariantEnum(CL);
  SIRegister_TOleVariantEnum(CL);
  SIRegister_TOleVariantArrayEnum(CL);
 CL.AddDelphiFunction('Function GetOleVariantEnum( Collection : OLEVariant) : IGetOleVariantEnum');
 CL.AddDelphiFunction('Function GetOleVariantArrEnum( Collection : OLEVariant) : IGetOleVariantEnum');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOleVariantArrayEnumCurrent_R(Self: TOleVariantArrayEnum; var T: OLEVariant);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure TOleVariantEnumCurrent_R(Self: TOleVariantEnum; var T: OLEVariant);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WDCCOleVariantEnum_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetOleVariantEnum, 'GetOleVariantEnum', cdRegister);
 S.RegisterDelphiFunction(@GetOleVariantArrEnum, 'GetOleVariantArrEnum', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOleVariantArrayEnum(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOleVariantArrayEnum) do
  begin
    RegisterMethod(@TOleVariantArrayEnum.GetEnumerator, 'GetEnumerator');
    RegisterConstructor(@TOleVariantArrayEnum.Create, 'Create');
    RegisterMethod(@TOleVariantArrayEnum.GetCurrent, 'GetCurrent');
    RegisterMethod(@TOleVariantArrayEnum.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TOleVariantArrayEnumCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOleVariantEnum(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOleVariantEnum) do
  begin
    RegisterMethod(@TOleVariantEnum.GetEnumerator, 'GetEnumerator');
    RegisterConstructor(@TOleVariantEnum.Create, 'Create');
    RegisterMethod(@TOleVariantEnum.GetCurrent, 'GetCurrent');
    RegisterMethod(@TOleVariantEnum.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TOleVariantEnumCurrent_R,nil,'Current');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_WDCCOleVariantEnum(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOleVariantEnum(CL);
  RIRegister_TOleVariantArrayEnum(CL);
end;

 
 
{ TPSImport_WDCCOleVariantEnum }
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDCCOleVariantEnum.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_WDCCOleVariantEnum(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_WDCCOleVariantEnum.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_WDCCOleVariantEnum(ri);
  RIRegister_WDCCOleVariantEnum_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
