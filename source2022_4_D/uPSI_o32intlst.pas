unit uPSI_o32intlst;
{
    anotgher list ghost list
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
  TPSImport_o32intlst = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TO32IntList(CL: TPSPascalCompiler);
procedure SIRegister_o32intlst(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TO32IntList(CL: TPSRuntimeClassImporter);
procedure RIRegister_o32intlst(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   o32intlst
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_o32intlst]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TO32IntList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TO32IntList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TO32IntList') do begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free)');

    RegisterMethod('Function Add( aItem : integer) : integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Insert( aInx : Integer; aItem : Pointer)');
    RegisterProperty('AllowDups', 'boolean', iptrw);
    RegisterProperty('Capacity', 'integer', iptrw);
    RegisterProperty('Count', 'integer', iptrw);
    RegisterProperty('IsSorted', 'boolean', iptrw);
    RegisterProperty('Items', 'integer integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_o32intlst(CL: TPSPascalCompiler);
begin
  SIRegister_TO32IntList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TO32IntListItems_W(Self: TO32IntList; const T: integer; const t1: integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListItems_R(Self: TO32IntList; var T: integer; const t1: integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListIsSorted_W(Self: TO32IntList; const T: boolean);
begin Self.IsSorted := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListIsSorted_R(Self: TO32IntList; var T: boolean);
begin T := Self.IsSorted; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListCount_W(Self: TO32IntList; const T: integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListCount_R(Self: TO32IntList; var T: integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListCapacity_W(Self: TO32IntList; const T: integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListCapacity_R(Self: TO32IntList; var T: integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListAllowDups_W(Self: TO32IntList; const T: boolean);
begin Self.AllowDups := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32IntListAllowDups_R(Self: TO32IntList; var T: boolean);
begin T := Self.AllowDups; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TO32IntList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TO32IntList) do begin
    RegisterConstructor(@TO32IntList.Create, 'Create');
       RegisterMethod(@TO32IntList.Free, 'Free');
     RegisterMethod(@TO32IntList.Add, 'Add');
    RegisterMethod(@TO32IntList.Clear, 'Clear');
    RegisterMethod(@TO32IntList.Insert, 'Insert');
    RegisterPropertyHelper(@TO32IntListAllowDups_R,@TO32IntListAllowDups_W,'AllowDups');
    RegisterPropertyHelper(@TO32IntListCapacity_R,@TO32IntListCapacity_W,'Capacity');
    RegisterPropertyHelper(@TO32IntListCount_R,@TO32IntListCount_W,'Count');
    RegisterPropertyHelper(@TO32IntListIsSorted_R,@TO32IntListIsSorted_W,'IsSorted');
    RegisterPropertyHelper(@TO32IntListItems_R,@TO32IntListItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_o32intlst(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TO32IntList(CL);
end;

 
 
{ TPSImport_o32intlst }
(*----------------------------------------------------------------------------*)
procedure TPSImport_o32intlst.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_o32intlst(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_o32intlst.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_o32intlst(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
