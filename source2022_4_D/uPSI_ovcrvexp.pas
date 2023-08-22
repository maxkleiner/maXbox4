unit uPSI_ovcrvexp;
{
    cond logic  add free
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
  TPSImport_ovcrvexp = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TOvcRvExp(CL: TPSPascalCompiler);
procedure SIRegister_TOvcRvExpScanner(CL: TPSPascalCompiler);
procedure SIRegister_ovcrvexp(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TOvcRvExp(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcRvExpScanner(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcrvexp(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   OvcCoco
  ,OvcRvExpDef
  ,ovcrvexp
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcrvexp]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcRvExp(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCocoRGrammar', 'TOvcRvExp') do
  with CL.AddClassN(CL.FindClass('TCocoRGrammar'),'TOvcRvExp') do begin
    RegisterMethod('Procedure Execute');
    RegisterMethod('Constructor Create');
    RegisterMethod('function ErrorStr(const ErrorCode : integer; const Data : string) : string;');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function GetScanner : TOvcRvExpScanner');
    RegisterMethod('Procedure Parse');
    RegisterProperty('MajorVersion', 'integer', iptr);
    RegisterProperty('MinorVersion', 'integer', iptr);
    RegisterProperty('Release', 'integer', iptr);
    RegisterProperty('Build', 'integer', iptr);
    RegisterProperty('BuildDate', 'TDateTime', iptr);
    RegisterProperty('RootNode', 'TOvcRvExpression', iptrw);
    RegisterProperty('Version', 'string', iptrw);
   RegisterPublishedProperties;
    RegisterProperty('FOnFailure', 'TFailureEvent', iptrw);
    RegisterProperty('FOnStatusUpdate', 'TStatusUpdateProc', iptrw);
   RegisterProperty('FOnSuccess', 'TFailureEvent', iptrw);
  RegisterProperty('FScanner', 'TCocoRScanner', iptrw);
    RegisterProperty('SourceFileName', 'string', iptrw);
    RegisterProperty('ClearSourceStream', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcRvExpScanner(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCocoRScanner', 'TOvcRvExpScanner') do
  with CL.AddClassN(CL.FindClass('TCocoRScanner'),'TOvcRvExpScanner') do begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Owner', 'TOvcRvExp', iptrw);
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure Get(var sym : integer);');


    //procedure Get(var sym : integer); override; // Gets next symbol from source file

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcrvexp(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('maxT','LongInt').SetInt( 60);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOvcRvExp');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TOvcRvExp');
  SIRegister_TOvcRvExpScanner(CL);
  SIRegister_TOvcRvExp(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TOvcRvExpVersion_W(Self: TOvcRvExp; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpVersion_R(Self: TOvcRvExp; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpRootNode_W(Self: TOvcRvExp; const T: TOvcRvExpression);
begin Self.RootNode := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpRootNode_R(Self: TOvcRvExp; var T: TOvcRvExpression);
begin T := Self.RootNode; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpBuildDate_R(Self: TOvcRvExp; var T: TDateTime);
begin T := Self.BuildDate; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpBuild_R(Self: TOvcRvExp; var T: integer);
begin T := Self.Build; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpRelease_R(Self: TOvcRvExp; var T: integer);
begin T := Self.Release; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpMinorVersion_R(Self: TOvcRvExp; var T: integer);
begin T := Self.MinorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpMajorVersion_R(Self: TOvcRvExp; var T: integer);
begin T := Self.MajorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpScannerOwner_W(Self: TOvcRvExpScanner; const T: TOvcRvExp);
begin Self.Owner := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRvExpScannerOwner_R(Self: TOvcRvExpScanner; var T: TOvcRvExp);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcRvExp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcRvExp) do begin
    RegisterConstructor(@TOvcRvExp.Create, 'Create');
    RegisterMethod(@TOvcRvExp.Execute, 'Execute');
    RegisterMethod(@TOvcRvExp.GetScanner, 'GetScanner');
    RegisterMethod(@TOvcRvExp.Parse, 'Parse');
    RegisterMethod(@TOvcRvExp.ErrorStr, 'ErrorStr');
    RegisterMethod(@TOvcRvExp.Destroy, 'Free');
    RegisterPropertyHelper(@TOvcRvExpMajorVersion_R,nil,'MajorVersion');
    RegisterPropertyHelper(@TOvcRvExpMinorVersion_R,nil,'MinorVersion');
    RegisterPropertyHelper(@TOvcRvExpRelease_R,nil,'Release');
    RegisterPropertyHelper(@TOvcRvExpBuild_R,nil,'Build');
    RegisterPropertyHelper(@TOvcRvExpBuildDate_R,nil,'BuildDate');
    RegisterPropertyHelper(@TOvcRvExpRootNode_R,@TOvcRvExpRootNode_W,'RootNode');
    RegisterPropertyHelper(@TOvcRvExpVersion_R,@TOvcRvExpVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcRvExpScanner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcRvExpScanner) do begin
    RegisterConstructor(@TOvcRvExpScanner.Create, 'Create');
       RegisterMethod(@TOvcRvExpScanner.Destroy, 'Free');
       RegisterMethod(@TOvcRvExpScanner.Get, 'Get');
      RegisterPropertyHelper(@TOvcRvExpScannerOwner_R,@TOvcRvExpScannerOwner_W,'Owner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcrvexp(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOvcRvExp) do
  with CL.Add(TOvcRvExp) do
  RIRegister_TOvcRvExpScanner(CL);
  RIRegister_TOvcRvExp(CL);
end;

 
 
{ TPSImport_ovcrvexp }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcrvexp.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcrvexp(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcrvexp.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcrvexp(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
