unit uPSI_MultilangTranslator;
{
  from mX4
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
  TPSImport_MultilangTranslator = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TMultiLangSC(CL: TPSPascalCompiler);
procedure SIRegister_MultilangTranslator(CL: TPSPascalCompiler);

{ run-time registration functions }
//procedure RIRegister_MultilangTranslator_Routines(S: TPSExec);
procedure RIRegister_TMultiLangSC(CL: TPSRuntimeClassImporter);
procedure RIRegister_MultilangTranslator(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,MultilangTranslator
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MultilangTranslator]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMultiLangSC(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TMultiLangSC') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TMultiLangSC') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function GetResourceString( const number : integer) : string');
    RegisterMethod('Function currentLanguage : integer');
    RegisterMethod('Function currentSystemLanguage( mylid : word) : integer');
    RegisterMethod('Function currentUserLanguage : integer');
    RegisterProperty('LanguageOffset', 'integer', iptrw);
    RegisterProperty('ResDLL', 'string', iptrw);
    RegisterProperty('OnLangChanging', 'tLangChanging', iptrw);
    RegisterProperty('OnLangChanged', 'tLangChanged', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MultilangTranslator(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('tLangChanging', 'Procedure (Sender: TObject; theComponent : TComponent)');
  CL.AddTypeS('tLangChanged', 'Procedure ( Sender : TObject)');
  SIRegister_TMultiLangSC(CL);
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TMultiLangSCOnLangChanged_W(Self: TMultiLangSC; const T: tLangChanged);
begin Self.OnLangChanged := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultiLangSCOnLangChanged_R(Self: TMultiLangSC; var T: tLangChanged);
begin T := Self.OnLangChanged; end;

(*----------------------------------------------------------------------------*)
procedure TMultiLangSCOnLangChanging_W(Self: TMultiLangSC; const T: tLangChanging);
begin Self.OnLangChanging := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultiLangSCOnLangChanging_R(Self: TMultiLangSC; var T: tLangChanging);
begin T := Self.OnLangChanging; end;

(*----------------------------------------------------------------------------*)
procedure TMultiLangSCResDLL_W(Self: TMultiLangSC; const T: string);
begin Self.ResDLL := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultiLangSCResDLL_R(Self: TMultiLangSC; var T: string);
begin T := Self.ResDLL; end;

(*----------------------------------------------------------------------------*)
procedure TMultiLangSCLanguageOffset_W(Self: TMultiLangSC; const T: integer);
begin Self.LanguageOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure TMultiLangSCLanguageOffset_R(Self: TMultiLangSC; var T: integer);
begin T := Self.LanguageOffset; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MultilangTranslator_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMultiLangSC(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMultiLangSC) do
  begin
    RegisterConstructor(@TMultiLangSC.Create, 'Create');
    RegisterMethod(@TMultiLangSC.GetResourceString, 'GetResourceString');
    RegisterMethod(@TMultiLangSC.currentLanguage, 'currentLanguage');
    RegisterMethod(@TMultiLangSC.currentSystemLanguage, 'currentSystemLanguage');
    RegisterMethod(@TMultiLangSC.currentUserLanguage, 'currentUserLanguage');
    RegisterPropertyHelper(@TMultiLangSCLanguageOffset_R,@TMultiLangSCLanguageOffset_W,'LanguageOffset');
    RegisterPropertyHelper(@TMultiLangSCResDLL_R,@TMultiLangSCResDLL_W,'ResDLL');
    RegisterPropertyHelper(@TMultiLangSCOnLangChanging_R,@TMultiLangSCOnLangChanging_W,'OnLangChanging');
    RegisterPropertyHelper(@TMultiLangSCOnLangChanged_R,@TMultiLangSCOnLangChanged_W,'OnLangChanged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MultilangTranslator(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TMultiLangSC(CL);
end;

 
 
{ TPSImport_MultilangTranslator }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MultilangTranslator.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MultilangTranslator(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MultilangTranslator.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MultilangTranslator(ri);
  //RIRegister_MultilangTranslator_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
