unit uPSI_ovcuser;
{
   set usr
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
  TPSImport_ovcuser = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcUserData(CL: TPSPascalCompiler);
procedure SIRegister_ovcuser(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcUserData(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcuser(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   OvcData
  ,ovcuser
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcuser]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcUserData(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TOvcUserData') do
  with CL.AddClassN(CL.FindClass('TObject'),'TOvcUserData') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('ForceCase', 'TCaseChange TForceCaseRange', iptrw);
    RegisterProperty('SubstChars', 'Char TSubstCharRange', iptrw);
    RegisterProperty('UserCharSet', 'TCharSet TUserSetRange', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcuser(CL: TPSPascalCompiler);
begin
  SIRegister_TOvcUserData(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcUserDataUserCharSet_W(Self: TOvcUserData; const T: TCharSet; const t1: TUserSetRange);
begin Self.UserCharSet[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcUserDataUserCharSet_R(Self: TOvcUserData; var T: TCharSet; const t1: TUserSetRange);
begin T := Self.UserCharSet[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcUserDataSubstChars_W(Self: TOvcUserData; const T: Char; const t1: TSubstCharRange);
begin Self.SubstChars[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcUserDataSubstChars_R(Self: TOvcUserData; var T: Char; const t1: TSubstCharRange);
begin T := Self.SubstChars[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOvcUserDataForceCase_W(Self: TOvcUserData; const T: TCaseChange; const t1: TForceCaseRange);
begin Self.ForceCase[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcUserDataForceCase_R(Self: TOvcUserData; var T: TCaseChange; const t1: TForceCaseRange);
begin T := Self.ForceCase[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcUserData(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcUserData) do begin
    RegisterConstructor(@TOvcUserData.Create, 'Create');
    RegisterPropertyHelper(@TOvcUserDataForceCase_R,@TOvcUserDataForceCase_W,'ForceCase');
    RegisterPropertyHelper(@TOvcUserDataSubstChars_R,@TOvcUserDataSubstChars_W,'SubstChars');
    RegisterPropertyHelper(@TOvcUserDataUserCharSet_R,@TOvcUserDataUserCharSet_W,'UserCharSet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcuser(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcUserData(CL);
end;

 
 
{ TPSImport_ovcuser }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcuser.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcuser(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcuser.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcuser(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
