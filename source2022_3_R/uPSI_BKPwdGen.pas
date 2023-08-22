unit uPSI_BKPwdGen;
{
passphrase teer man
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
  TPSImport_BKPwdGen = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TBKPwdGen(CL: TPSPascalCompiler);
procedure SIRegister_BKPwdGen(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_BKPwdGen_Routines(S: TPSExec);
procedure RIRegister_TBKPwdGen(CL: TPSRuntimeClassImporter);
procedure RIRegister_BKPwdGen(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,Forms
  ,Dialogs
  ,BKPwdGen
  ;
 
 
procedure Register;
begin
  //RegisterComponents('Pascal Script', [TPSImport_BKPwdGen]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBKPwdGen(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TBKPwdGen') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TBKPwdGen') do begin
    RegisterProperty('PassWord', 'string', iptr);
    RegisterMethod('Procedure CreatePassword');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Length', 'integer', iptrw);
    RegisterProperty('Digits', 'Boolean', iptrw);
    RegisterProperty('Special', 'Boolean', iptrw);
    RegisterProperty('SmallLetters', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BKPwdGen(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWrongLength');
  SIRegister_TBKPwdGen(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBKPwdGenSmallLetters_W(Self: TBKPwdGen; const T: Boolean);
begin Self.SmallLetters := T; end;

(*----------------------------------------------------------------------------*)
procedure TBKPwdGenSmallLetters_R(Self: TBKPwdGen; var T: Boolean);
begin T := Self.SmallLetters; end;

(*----------------------------------------------------------------------------*)
procedure TBKPwdGenSpecial_W(Self: TBKPwdGen; const T: Boolean);
begin Self.Special := T; end;

(*----------------------------------------------------------------------------*)
procedure TBKPwdGenSpecial_R(Self: TBKPwdGen; var T: Boolean);
begin T := Self.Special; end;

(*----------------------------------------------------------------------------*)
procedure TBKPwdGenDigits_W(Self: TBKPwdGen; const T: Boolean);
begin Self.Digits := T; end;

(*----------------------------------------------------------------------------*)
procedure TBKPwdGenDigits_R(Self: TBKPwdGen; var T: Boolean);
begin T := Self.Digits; end;

(*----------------------------------------------------------------------------*)
procedure TBKPwdGenLength_W(Self: TBKPwdGen; const T: integer);
begin Self.Length := T; end;

(*----------------------------------------------------------------------------*)
procedure TBKPwdGenLength_R(Self: TBKPwdGen; var T: integer);
begin T := Self.Length; end;

(*----------------------------------------------------------------------------*)
procedure TBKPwdGenPassWord_R(Self: TBKPwdGen; var T: string);
begin T := Self.PassWord; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BKPwdGen_Routines(S: TPSExec);
begin
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBKPwdGen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBKPwdGen) do
  begin
    RegisterPropertyHelper(@TBKPwdGenPassWord_R,nil,'PassWord');
    RegisterMethod(@TBKPwdGen.CreatePassword, 'CreatePassword');
    RegisterConstructor(@TBKPwdGen.Create, 'Create');
    RegisterPropertyHelper(@TBKPwdGenLength_R,@TBKPwdGenLength_W,'Length');
    RegisterPropertyHelper(@TBKPwdGenDigits_R,@TBKPwdGenDigits_W,'Digits');
    RegisterPropertyHelper(@TBKPwdGenSpecial_R,@TBKPwdGenSpecial_W,'Special');
    RegisterPropertyHelper(@TBKPwdGenSmallLetters_R,@TBKPwdGenSmallLetters_W,'SmallLetters');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BKPwdGen(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EWrongLength) do
  RIRegister_TBKPwdGen(CL);
end;

 
 
{ TPSImport_BKPwdGen }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BKPwdGen.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BKPwdGen(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BKPwdGen.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BKPwdGen(ri);
  RIRegister_BKPwdGen_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
