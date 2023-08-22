unit uPSI_uMRU;
{
with standard ini files

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
  TPSImport_uMRU = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMRUList(CL: TPSPascalCompiler);
procedure SIRegister_uMRU(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TMRUList(CL: TPSRuntimeClassImporter);
procedure RIRegister_uMRU(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  IniFiles
  ,uMRU
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uMRU]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMRUList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TMRUList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TMRUList') do
  begin
    RegisterMethod('Constructor Create( aMyIniFile : TIniFile; aLimit : Integer; aIniSection : String)');
    RegisterMethod('Procedure Add( Item : String)');
    RegisterMethod('Procedure Clear');
         RegisterMethod('Procedure Free');
    RegisterProperty('AllItems', 'TStringList', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Items', 'String Integer', iptr);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uMRU(CL: TPSPascalCompiler);
begin
  SIRegister_TMRUList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMRUListItems_R(Self: TMRUList; var T: String; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMRUListCount_R(Self: TMRUList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TMRUListAllItems_R(Self: TMRUList; var T: TStringList);
begin T := Self.AllItems; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMRUList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMRUList) do begin
    RegisterConstructor(@TMRUList.Create, 'Create');
    RegisterMethod(@TMRUList.Add, 'Add');
    RegisterMethod(@TMRUList.Clear, 'Clear');
    RegisterMethod(@TMRUList.Destroy, 'Free');

    RegisterPropertyHelper(@TMRUListAllItems_R,nil,'AllItems');
    RegisterPropertyHelper(@TMRUListCount_R,nil,'Count');
    RegisterPropertyHelper(@TMRUListItems_R,nil,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uMRU(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMRUList(CL);
end;

 
 
{ TPSImport_uMRU }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uMRU.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uMRU(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uMRU.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uMRU(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
