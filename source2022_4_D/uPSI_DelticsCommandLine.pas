unit uPSI_DelticsCommandLine;
{
Tanother shell hell for curl   needs delticsstrutils

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
  TPSImport_DelticsCommandLine = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TCommandLineSwitch(CL: TPSPascalCompiler);
procedure SIRegister_TCommandLine(CL: TPSPascalCompiler);
procedure SIRegister_DelticsCommandLine(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DelticsCommandLine_Routines(S: TPSExec);
procedure RIRegister_TCommandLineSwitch(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCommandLine(CL: TPSRuntimeClassImporter);
procedure RIRegister_DelticsCommandLine(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // Classes
  Types
  ,DelticsCommandLine
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DelticsCommandLine]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommandLineSwitch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCommandLineSwitch') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCommandLineSwitch') do
  begin
    RegisterProperty('Specified', 'Boolean', iptr);
    RegisterProperty('Value', 'String', iptr);
    RegisterProperty('Values', 'TStringList', iptr);
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCommandLine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCommandLine') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCommandLine') do
  begin
    RegisterMethod('Constructor Create( const aCommandLine : String)');
    RegisterMethod('Procedure AfterConstruction');
     RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Clear( const aReset : Boolean)');
    RegisterMethod('Procedure BeginSetup');
    RegisterMethod('Procedure EndSetup');
    RegisterMethod('Procedure DefineParameter( const aName : String; const aDefault : String)');
    RegisterMethod('Procedure DefineSwitch( const aSwitch : String);');
    RegisterMethod('Procedure DefineSwitch2( const aSwitch : String; const aDefault : String);');
    RegisterMethod('Procedure Parse( const aCommandLine : String)');
    RegisterProperty('EXEPath', 'String', iptr);
    RegisterProperty('EXEFilename', 'String', iptr);
    RegisterProperty('OtherCount', 'Integer', iptr);
    RegisterProperty('Other', 'String Integer', iptr);
    RegisterProperty('Parameter', 'String String', iptr);
    RegisterProperty('Switch', 'TCommandLineSwitch String', iptr);
    RegisterProperty('Text', 'String', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DelticsCommandLine(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCommandLine');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCommandLineSwitch');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidCommandLine');
  //CL.AddTypeS('PSwitchDef', '^TSwitchDef // will not work');
  CL.AddTypeS('TSwitchDef', 'record Name : String; Switch : String; Default : S'
   +'tring; MinValues : Integer; MaxValues : Integer; Separator : Char; end');
  SIRegister_TCommandLine(CL);
  SIRegister_TCommandLineSwitch(CL);
 CL.AddDelphiFunction('Procedure CommandLineToArgs( const aString : String; const aArgs : TStrings)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCommandLineSwitchValues_R(Self: TCommandLineSwitch; var T: TStringList);
begin T := Self.Values; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineSwitchValue_R(Self: TCommandLineSwitch; var T: String);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineSwitchSpecified_R(Self: TCommandLineSwitch; var T: Boolean);
begin T := Self.Specified; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineText_R(Self: TCommandLine; var T: String);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineSwitch_R(Self: TCommandLine; var T: TCommandLineSwitch; const t1: String);
begin T := Self.Switch[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineParameter_R(Self: TCommandLine; var T: String; const t1: String);
begin T := Self.Parameter[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineOther_R(Self: TCommandLine; var T: String; const t1: Integer);
begin T := Self.Other[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineOtherCount_R(Self: TCommandLine; var T: Integer);
begin T := Self.OtherCount; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineEXEFilename_R(Self: TCommandLine; var T: String);
begin T := Self.EXEFilename; end;

(*----------------------------------------------------------------------------*)
procedure TCommandLineEXEPath_R(Self: TCommandLine; var T: String);
begin T := Self.EXEPath; end;

(*----------------------------------------------------------------------------*)
Procedure TCommandLineDefineSwitch2_P(Self: TCommandLine;  const aSwitch : String; const aDefault : String);
Begin Self.DefineSwitch(aSwitch, aDefault); END;

(*----------------------------------------------------------------------------*)
Procedure TCommandLineDefineSwitch1_P(Self: TCommandLine;  const aSwitch : String);
Begin Self.DefineSwitch(aSwitch); END;

(*----------------------------------------------------------------------------*)
Procedure TCommandLineDefineSwitch_P(Self: TCommandLine;  const aName : String; const aSwitch : String; const aMinValues : Integer; const aMaxValues : Integer; const aValueSep : Char; const aDefault : String);
Begin //Self.DefineSwitch(aName, aSwitch, aMinValues, aMaxValues, aValueSep, aDefault);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DelticsCommandLine_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CommandLineToArgs, 'CommandLineToArgs', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommandLineSwitch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommandLineSwitch) do
  begin
    RegisterPropertyHelper(@TCommandLineSwitchSpecified_R,nil,'Specified');
    RegisterPropertyHelper(@TCommandLineSwitchValue_R,nil,'Value');
    RegisterPropertyHelper(@TCommandLineSwitchValues_R,nil,'Values');
    RegisterMethod(@TCommandLineSwitch.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCommandLine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommandLine) do begin
    RegisterConstructor(@TCommandLine.Create, 'Create');
    RegisterMethod(@TCommandLine.Destroy, 'Free');
    RegisterMethod(@TCommandLine.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TCommandLine.Clear, 'Clear');
    RegisterMethod(@TCommandLine.BeginSetup, 'BeginSetup');
    RegisterMethod(@TCommandLine.EndSetup, 'EndSetup');
    RegisterMethod(@TCommandLine.DefineParameter, 'DefineParameter');
    RegisterMethod(@TCommandLineDefineSwitch1_P, 'DefineSwitch');
    RegisterMethod(@TCommandLineDefineSwitch2_P, 'DefineSwitch2');
    RegisterMethod(@TCommandLine.Parse, 'Parse');
    RegisterPropertyHelper(@TCommandLineEXEPath_R,nil,'EXEPath');
    RegisterPropertyHelper(@TCommandLineEXEFilename_R,nil,'EXEFilename');
    RegisterPropertyHelper(@TCommandLineOtherCount_R,nil,'OtherCount');
    RegisterPropertyHelper(@TCommandLineOther_R,nil,'Other');
    RegisterPropertyHelper(@TCommandLineParameter_R,nil,'Parameter');
    RegisterPropertyHelper(@TCommandLineSwitch_R,nil,'Switch');
    RegisterPropertyHelper(@TCommandLineText_R,nil,'Text');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DelticsCommandLine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCommandLine) do
  with CL.Add(TCommandLineSwitch) do
  with CL.Add(EInvalidCommandLine) do
  RIRegister_TCommandLine(CL);
  RIRegister_TCommandLineSwitch(CL);
end;

 
 
{ TPSImport_DelticsCommandLine }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelticsCommandLine.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DelticsCommandLine(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelticsCommandLine.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DelticsCommandLine(ri);
  RIRegister_DelticsCommandLine_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
