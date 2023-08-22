unit uPSI_oysUtils;
{
  to build a config helper
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
  TPSImport_oysUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ToysStringList(CL: TPSPascalCompiler);
procedure SIRegister_oysUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_oysUtils_Routines(S: TPSExec);
procedure RIRegister_ToysStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_oysUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   oysUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_oysUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ToysStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'ToysStringList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'ToysStringList') do begin
    RegisterMethod('Procedure Appendfmt( s : string; const args : array of const)');
    RegisterMethod('Function IndexofValue( Value : string) : integer');
    RegisterMethod('Function Addfmt( s : string; const args : array of const) : integer');
    RegisterProperty('Values', 'string integer', iptrw);
    RegisterProperty('Value', 'string string', iptrw);
    RegisterProperty('Names', 'string integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_oysUtils(CL: TPSPascalCompiler);
begin
  SIRegister_ToysStringList(CL);
 CL.AddDelphiFunction('Function ReadBoolStr( Value : string) : boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure ToysStringListNames_W(Self: ToysStringList; const T: string; const t1: integer);
begin Self.Names[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure ToysStringListNames_R(Self: ToysStringList; var T: string; const t1: integer);
begin T := Self.Names[t1]; end;

(*----------------------------------------------------------------------------*)
procedure ToysStringListValue_W(Self: ToysStringList; const T: string; const t1: string);
begin Self.Value[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure ToysStringListValue_R(Self: ToysStringList; var T: string; const t1: string);
begin T := Self.Value[t1]; end;

(*----------------------------------------------------------------------------*)
procedure ToysStringListValues_W(Self: ToysStringList; const T: string; const t1: integer);
begin Self.Values[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure ToysStringListValues_R(Self: ToysStringList; var T: string; const t1: integer);
begin T := Self.Values[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_oysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ReadBoolStr, 'ReadBoolStr', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ToysStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ToysStringList) do begin
    RegisterMethod(@ToysStringList.Appendfmt, 'Appendfmt');
    RegisterMethod(@ToysStringList.IndexofValue, 'IndexofValue');
    RegisterMethod(@ToysStringList.Addfmt, 'Addfmt');
    RegisterPropertyHelper(@ToysStringListValues_R,@ToysStringListValues_W,'Values');
    RegisterPropertyHelper(@ToysStringListValue_R,@ToysStringListValue_W,'Value');
    RegisterPropertyHelper(@ToysStringListNames_R,@ToysStringListNames_W,'Names');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_oysUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_ToysStringList(CL);
end;

 
 
{ TPSImport_oysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_oysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_oysUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_oysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_oysUtils(ri);
  RIRegister_oysUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
