unit uPSI_RestJsonUtils;
{
Twith timecodes routine

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
  TPSImport_RestJsonUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJsonUtil(CL: TPSPascalCompiler);
procedure SIRegister_ENoSerializableClass(CL: TPSPascalCompiler);
procedure SIRegister_RestJsonUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_RestJsonUtils_Routines(S: TPSExec);
procedure RIRegister_TJsonUtil(CL: TPSRuntimeClassImporter);
procedure RIRegister_ENoSerializableClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_RestJsonUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // RestJsonGenerics
  //,RestJsonOldRTTI
  DateUtils
  ,TypInfo
  ,RestJsonUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_RestJsonUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJsonUtil(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJsonUtil') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJsonUtil') do
  begin
    RegisterMethod('Function Marshal( entity : TObject) : string');
    RegisterMethod('Function UnMarshal( AClassType : TClass; AJsonText : String) : TObject;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ENoSerializableClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ENoSerializableClass') do
  with CL.AddClassN(CL.FindClass('Exception'),'ENoSerializableClass') do
  begin
    RegisterMethod('Constructor Create( AClass : TClass)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_RestJsonUtils(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJsonInvalidValue');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJsonInvalidValueForField');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJsonInvalidSyntax');
  SIRegister_ENoSerializableClass(CL);
  SIRegister_TJsonUtil(CL);
 CL.AddDelphiFunction('Function JavaToDelphiDateTime2( const dt : int64) : TDateTime');
 CL.AddDelphiFunction('Function DelphiToJavaDateTime2( const dt : TDateTime) : int64');
 CL.AddDelphiFunction('Function ISO8601DateToJavaDateTime( const str : String; var ms : Int64) : Boolean');
 CL.AddDelphiFunction('Function ISO8601DateToDelphiDateTime( const str : string; var dt : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function DelphiDateTimeToISO8601Date2( dt : TDateTime) : string');
 CL.AddDelphiFunction('procedure FindFiles2List(StartDir, FileMask: string; rec: boolean; var FilesList: TStringList);');
  CL.AddDelphiFunction('Function TCtoFrames( S : String) : Integer');
 CL.AddDelphiFunction('Function FramestoTC( Fi : Integer) : String');
 CL.AddDelphiFunction('Function DFtoFrames( S : String) : Integer');
 CL.AddDelphiFunction('Function FramestoDF( Fi : Integer) : String');
 CL.AddDelphiFunction('Function ValidDropFrame( S : String) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TJsonUtilUnMarshal_P(Self: TJsonUtil;  AClassType : TClass; AJsonText : String) : TObject;
Begin Result := Self.UnMarshal(AClassType, AJsonText); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RestJsonUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@JavaToDelphiDateTime, 'JavaToDelphiDateTime2', cdRegister);
 S.RegisterDelphiFunction(@DelphiToJavaDateTime, 'DelphiToJavaDateTime2', cdRegister);
 S.RegisterDelphiFunction(@ISO8601DateToJavaDateTime, 'ISO8601DateToJavaDateTime', cdRegister);
 S.RegisterDelphiFunction(@ISO8601DateToDelphiDateTime, 'ISO8601DateToDelphiDateTime', cdRegister);
 S.RegisterDelphiFunction(@DelphiDateTimeToISO8601Date, 'DelphiDateTimeToISO8601Date2', cdRegister);
 S.RegisterDelphiFunction(@FindFiles2List, 'FindFiles2List', cdRegister);
 S.RegisterDelphiFunction(@TCtoFrames, 'TCtoFrames', cdRegister);
 S.RegisterDelphiFunction(@FramestoTC, 'FramestoTC', cdRegister);
 S.RegisterDelphiFunction(@DFtoFrames, 'DFtoFrames', cdRegister);
 S.RegisterDelphiFunction(@FramestoDF, 'FramestoDF', cdRegister);
 S.RegisterDelphiFunction(@ValidDropFrame, 'ValidDropFrame', cdRegister);

 end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJsonUtil(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJsonUtil) do
  begin
    RegisterMethod(@TJsonUtil.Marshal, 'Marshal');
    RegisterMethod(@TJsonUtilUnMarshal_P, 'UnMarshal');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ENoSerializableClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ENoSerializableClass) do
  begin
    RegisterConstructor(@ENoSerializableClass.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_RestJsonUtils(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJsonInvalidValue) do
  with CL.Add(EJsonInvalidValueForField) do
  with CL.Add(EJsonInvalidSyntax) do
  RIRegister_ENoSerializableClass(CL);
  RIRegister_TJsonUtil(CL);
end;

 
 
{ TPSImport_RestJsonUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_RestJsonUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_RestJsonUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_RestJsonUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_RestJsonUtils(ri);
  RIRegister_RestJsonUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
