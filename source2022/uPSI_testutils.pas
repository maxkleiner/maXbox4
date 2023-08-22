unit uPSI_testutils;
{
   from lazarus   just a beta to experiment
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
  TPSImport_testutils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TNoRefCountObject(CL: TPSPascalCompiler);
procedure SIRegister_testutils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_testutils_Routines(S: TPSExec);
procedure RIRegister_TNoRefCountObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_testutils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   testutils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_testutils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TNoRefCountObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TNoRefCountObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TNoRefCountObject') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_testutils(CL: TPSPascalCompiler);
begin
  SIRegister_TNoRefCountObject(CL);
 CL.AddDelphiFunction('Procedure FreeObjects( List : TList)');
 CL.AddDelphiFunction('Procedure GetMethodList( AObject : TObject; AList : TStrings);');
 CL.AddDelphiFunction('Procedure GetMethodList1( AClass : TClass; AList : TStrings);');
 CL.AddDelphiFunction('procedure FreeObjectList(List: TObjectList);');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure GetMethodList1_P( AClass : TClass; AList : TStrings);
Begin testutils.GetMethodList(AClass, AList); END;

(*----------------------------------------------------------------------------*)
Procedure GetMethodList_P( AObject : TObject; AList : TStrings);
Begin testutils.GetMethodList(AObject, AList); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_testutils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@FreeObjects, 'FreeObjects', cdRegister);
 S.RegisterDelphiFunction(@FreeObjectList, 'FreeObjectlist', cdRegister);
 S.RegisterDelphiFunction(@GetMethodList, 'GetMethodList', cdRegister);
 S.RegisterDelphiFunction(@GetMethodList1_P, 'GetMethodList1', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNoRefCountObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNoRefCountObject) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_testutils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TNoRefCountObject(CL);
end;

 
 
{ TPSImport_testutils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_testutils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_testutils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_testutils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_testutils(ri);
  RIRegister_testutils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
