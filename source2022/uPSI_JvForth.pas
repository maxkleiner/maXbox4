unit uPSI_JvForth;
{
  code forth with XML Helper
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
  TPSImport_JvForth = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvForthScript(CL: TPSPascalCompiler);
procedure SIRegister_TAtomList(CL: TPSPascalCompiler);
procedure SIRegister_TAtom(CL: TPSPascalCompiler);
procedure SIRegister_TVariantList(CL: TPSPascalCompiler);
procedure SIRegister_TVariantObject(CL: TPSPascalCompiler);
procedure SIRegister_TJvJanXMLList(CL: TPSPascalCompiler);
procedure SIRegister_TJvJanDSOList(CL: TPSPascalCompiler);
procedure SIRegister_TJvJanDSO(CL: TPSPascalCompiler);
procedure SIRegister_JvForth(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JvForth_Routines(S: TPSExec);
procedure RIRegister_TJvForthScript(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAtomList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TAtom(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVariantList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVariantObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvJanXMLList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvJanDSOList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJvJanDSO(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvForth(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  ShellAPI
  ,Windows
  //,Messages
  //,Forms
  //,Dialogs
  ,FileCtrl
  ,Variants
  ,JvXMLTree
  ,JvComponentBase
  ,JvStrings
  ,JvTypes
  ,JvForth
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvForth]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvForthScript(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvForthScript') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvForthScript') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Execute : Variant');
    RegisterMethod('Function PopValue : Variant');
    RegisterMethod('Function CanPopValue : Boolean');
    RegisterMethod('Procedure PushValue( AValue : Variant)');
    RegisterMethod('Function CanPushValue : Boolean');
    RegisterProperty('Script', 'string', iptrw);
    RegisterProperty('ScriptTimeOut', 'Integer', iptrw);
    RegisterProperty('OnGetVariable', 'TOnGetVariable', iptrw);
    RegisterProperty('OnSetVariable', 'TOnSetVariable', iptrw);
    RegisterProperty('OnSetSystem', 'TOnSetSystem', iptrw);
    RegisterProperty('OnGetSystem', 'TOnGetSystem', iptrw);
    RegisterProperty('OnInclude', 'TOnInclude', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAtomList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TList', 'TAtomList') do
  with CL.AddClassN(CL.FindClass('TList'),'TAtomList') do begin
    RegisterMethod('Procedure ClearObjects');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TAtom(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TAtom') do
  with CL.AddClassN(CL.FindClass('TObject'),'TAtomF') do begin
    RegisterProperty('Token', 'TToken', iptrw);
    RegisterProperty('Proc', 'TProcVar', iptrw);
    RegisterProperty('Symbol', 'string', iptrw);
    RegisterProperty('Value', 'Variant', iptrw);
    RegisterProperty('IsOperand', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVariantList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TVariantList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TVariantList') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ClearObjects');
    RegisterMethod('Procedure SetVariable( const Symbol : string; AValue : Variant)');
    RegisterMethod('Function GetVariable( const Symbol : string) : Variant');
    RegisterMethod('Function GetObject( const Symbol : string) : TVariantObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVariantObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TVariantObject') do
  with CL.AddClassN(CL.FindClass('TObject'),'TVariantObject') do begin
    RegisterProperty('Value', 'Variant', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvJanXMLList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TJvJanXMLList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TJvJanXMLList') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure ClearXMLS');
    RegisterMethod('Function Xml( const AName : string) : TJvXMLTree');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvJanDSOList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TJvJanDSOList') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TJvJanDSOList') do begin
    RegisterMethod('Procedure ClearTables');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Table( const AName : string) : TJvJanDSO');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvJanDSO(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStringList', 'TJvJanDSO') do
  with CL.AddClassN(CL.FindClass('TStringList'),'TJvJanDSO') do begin
    RegisterMethod('Procedure SetValue( AKey : Variant; const AField, AValue : string)');
    RegisterMethod('Function GetValue( AKey : Variant; const AField : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvForth(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('StackMax','LongInt').SetInt( 1000);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJvJanScriptError');
  CL.AddTypeS('TToken', '( dfoError, dfoNop, dfoIf, dfoElse, dfoEndIf, dfoRepea'
   +'t, dfoUntil, dfoSub, dfoEndSub, dfoCall, dfoDup, dfoDrop, dfoSwap, dfoCstr'
   +', dfoDSO, dfoSelDir, dfoDSOBase, dfoXML, dfoSystem, dfoIntVar, dfoExtVar, '
   +'dfoInteger, dfoFloat, dfoSet, dfoString, dfoBoolean, dfoDate, dfoEq, dfoNe'
   +', dfoGt, dfoLt, dfoGe, dfoLe, dfoLike, dfoUnlike, dfoNot, dfoAnd, dfoXor, '
   +'dfoOr, dfoIn, dfoAdd, dfoSubtract, dfoMultiply, dfoDivide, dfoPower, dfoAb'
   +'s, dfoCrLf, dfoSin, dfoCos, dfoPi, dfoTan, dfoArcSin, dfoArcCos, dfoArcTan'
   +', dfoArcTan2, dfoNegate, dfoSqr, dfoSqrt, dfoLeft, dfoRight, dfoShellExecu'
   +'te, dfoNow, dfoTime, dfoDateStr, dfoTimeStr )');
  CL.AddTypeS('TProcVar', 'Procedure');
  CL.AddTypeS('TOnGetVariable', 'Procedure ( Sender : TObject; Symbol : string;'
   +' var Value : Variant; var Handled : Boolean; var ErrorStr : string)');
  CL.AddTypeS('TOnSetVariable', 'Procedure ( Sender : TObject; Symbol : string;'
   +' Value : Variant; var Handled : Boolean; var ErrorStr : string)');
  CL.AddTypeS('TOnGetSystem', 'Procedure ( Sender : TObject; Symbol, Prompt : s'
   +'tring; var Value : Variant; var Handled : Boolean; var ErrorStr : string)');
  CL.AddTypeS('TOnSetSystem', 'Procedure ( Sender : TObject; Symbol : string; V'
   +'alue : Variant; var Handled : Boolean; var ErrorStr : string)');
  CL.AddTypeS('TOnInclude', 'Procedure ( Sender : TObject; IncludeFile : string'
   +'; var Value : string; var Handled : Boolean; var ErrorStr : string)');
  SIRegister_TJvJanDSO(CL);
  SIRegister_TJvJanDSOList(CL);
  SIRegister_TJvJanXMLList(CL);
  SIRegister_TVariantObject(CL);
  SIRegister_TVariantList(CL);
  SIRegister_TAtom(CL);
  SIRegister_TAtomList(CL);
  SIRegister_TJvForthScript(CL);
 CL.AddDelphiFunction('Procedure Launch( const AFile : string)');
 CL.AddDelphiFunction('Procedure LaunchFile( const AFile : string)');
 CL.AddDelphiFunction('Function IndexOfInteger( AList : TStringList; Value : Variant) : Integer');
 CL.AddDelphiFunction('Function IndexOfFloat( AList : TStringList; Value : Variant) : Integer');
 CL.AddDelphiFunction('Function IndexOfDate( AList : TStringList; Value : Variant) : Integer');
 CL.AddDelphiFunction('Function IndexOfString( AList : TStringList; Value : Variant) : Integer');
 CL.AddDelphiFunction('function FuncIn(AValue: Variant; ASet: Variant): Boolean;');
 CL.AddDelphiFunction('function ValueInSet(AValue: Variant; ASet: Variant): Boolean;');

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnInclude_W(Self: TJvForthScript; const T: TOnInclude);
begin Self.OnInclude := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnInclude_R(Self: TJvForthScript; var T: TOnInclude);
begin T := Self.OnInclude; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnGetSystem_W(Self: TJvForthScript; const T: TOnGetSystem);
begin Self.OnGetSystem := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnGetSystem_R(Self: TJvForthScript; var T: TOnGetSystem);
begin T := Self.OnGetSystem; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnSetSystem_W(Self: TJvForthScript; const T: TOnSetSystem);
begin Self.OnSetSystem := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnSetSystem_R(Self: TJvForthScript; var T: TOnSetSystem);
begin T := Self.OnSetSystem; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnSetVariable_W(Self: TJvForthScript; const T: TOnSetVariable);
begin Self.OnSetVariable := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnSetVariable_R(Self: TJvForthScript; var T: TOnSetVariable);
begin T := Self.OnSetVariable; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnGetVariable_W(Self: TJvForthScript; const T: TOnGetVariable);
begin Self.OnGetVariable := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptOnGetVariable_R(Self: TJvForthScript; var T: TOnGetVariable);
begin T := Self.OnGetVariable; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptScriptTimeOut_W(Self: TJvForthScript; const T: Integer);
begin Self.ScriptTimeOut := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptScriptTimeOut_R(Self: TJvForthScript; var T: Integer);
begin T := Self.ScriptTimeOut; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptScript_W(Self: TJvForthScript; const T: string);
begin Self.Script := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvForthScriptScript_R(Self: TJvForthScript; var T: string);
begin T := Self.Script; end;

(*----------------------------------------------------------------------------*)
procedure TAtomIsOperand_W(Self: TAtomF; const T: Boolean);
begin Self.IsOperand := T; end;

(*----------------------------------------------------------------------------*)
procedure TAtomIsOperand_R(Self: TAtomF; var T: Boolean);
begin T := Self.IsOperand; end;

(*----------------------------------------------------------------------------*)
procedure TAtomValue_W(Self: TAtomF; const T: Variant);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TAtomValue_R(Self: TAtomF; var T: Variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TAtomSymbol_W(Self: TAtomF; const T: string);
begin Self.Symbol := T; end;

(*----------------------------------------------------------------------------*)
procedure TAtomSymbol_R(Self: TAtomF; var T: string);
begin T := Self.Symbol; end;

(*----------------------------------------------------------------------------*)
procedure TAtomProc_W(Self: TAtomF; const T: TProcVar);
begin Self.Proc := T; end;

(*----------------------------------------------------------------------------*)
procedure TAtomProc_R(Self: TAtomF; var T: TProcVar);
begin T := Self.Proc; end;

(*----------------------------------------------------------------------------*)
procedure TAtomToken_W(Self: TAtomF; const T: TToken);
begin Self.Token := T; end;

(*----------------------------------------------------------------------------*)
procedure TAtomToken_R(Self: TAtomF; var T: TToken);
begin T := Self.Token; end;

(*----------------------------------------------------------------------------*)
procedure TVariantObjectValue_W(Self: TVariantObject; const T: Variant);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TVariantObjectValue_R(Self: TVariantObject; var T: Variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvForth_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@Launch, 'Launch', cdRegister);
 S.RegisterDelphiFunction(@Launch, 'LaunchFile', cdRegister);
 S.RegisterDelphiFunction(@IndexOfInteger, 'IndexOfInteger', cdRegister);
 S.RegisterDelphiFunction(@IndexOfFloat, 'IndexOfFloat', cdRegister);
 S.RegisterDelphiFunction(@IndexOfDate, 'IndexOfDate', cdRegister);
 S.RegisterDelphiFunction(@IndexOfString, 'IndexOfString', cdRegister);
 S.RegisterDelphiFunction(@FuncIn, 'FuncIn', cdRegister);
 S.RegisterDelphiFunction(@FuncIn, 'ValueInSet', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvForthScript(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvForthScript) do begin
    RegisterConstructor(@TJvForthScript.Create, 'Create');
    RegisterMethod(@TJvForthScript.Destroy, 'Free');
    RegisterMethod(@TJvForthScript.Execute, 'Execute');
    RegisterMethod(@TJvForthScript.PopValue, 'PopValue');
    RegisterMethod(@TJvForthScript.CanPopValue, 'CanPopValue');
    RegisterMethod(@TJvForthScript.PushValue, 'PushValue');
    RegisterMethod(@TJvForthScript.CanPushValue, 'CanPushValue');
    RegisterPropertyHelper(@TJvForthScriptScript_R,@TJvForthScriptScript_W,'Script');
    RegisterPropertyHelper(@TJvForthScriptScriptTimeOut_R,@TJvForthScriptScriptTimeOut_W,'ScriptTimeOut');
    RegisterPropertyHelper(@TJvForthScriptOnGetVariable_R,@TJvForthScriptOnGetVariable_W,'OnGetVariable');
    RegisterPropertyHelper(@TJvForthScriptOnSetVariable_R,@TJvForthScriptOnSetVariable_W,'OnSetVariable');
    RegisterPropertyHelper(@TJvForthScriptOnSetSystem_R,@TJvForthScriptOnSetSystem_W,'OnSetSystem');
    RegisterPropertyHelper(@TJvForthScriptOnGetSystem_R,@TJvForthScriptOnGetSystem_W,'OnGetSystem');
    RegisterPropertyHelper(@TJvForthScriptOnInclude_R,@TJvForthScriptOnInclude_W,'OnInclude');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAtomList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAtomList) do  begin
    RegisterMethod(@TAtomList.ClearObjects, 'ClearObjects');
   RegisterMethod(@TAtomList.Destroy, 'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TAtom(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TAtomF) do begin
    RegisterPropertyHelper(@TAtomToken_R,@TAtomToken_W,'Token');
    RegisterPropertyHelper(@TAtomProc_R,@TAtomProc_W,'Proc');
    RegisterPropertyHelper(@TAtomSymbol_R,@TAtomSymbol_W,'Symbol');
    RegisterPropertyHelper(@TAtomValue_R,@TAtomValue_W,'Value');
    RegisterPropertyHelper(@TAtomIsOperand_R,@TAtomIsOperand_W,'IsOperand');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVariantList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVariantList) do begin
    RegisterMethod(@TVariantList.Destroy, 'Free');
    RegisterMethod(@TVariantList.ClearObjects, 'ClearObjects');
    RegisterMethod(@TVariantList.SetVariable, 'SetVariable');
    RegisterMethod(@TVariantList.GetVariable, 'GetVariable');
    RegisterMethod(@TVariantList.GetObject, 'GetObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVariantObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVariantObject) do begin
    RegisterPropertyHelper(@TVariantObjectValue_R,@TVariantObjectValue_W,'Value');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvJanXMLList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvJanXMLList) do begin
    RegisterMethod(@TJvJanXMLList.Destroy, 'Free');
    RegisterMethod(@TJvJanXMLList.ClearXMLS, 'ClearXMLS');
    RegisterMethod(@TJvJanXMLList.Xml, 'Xml');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvJanDSOList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvJanDSOList) do begin
    RegisterMethod(@TJvJanDSOList.Destroy, 'Free');
    RegisterMethod(@TJvJanDSOList.ClearTables, 'ClearTables');
    RegisterMethod(@TJvJanDSOList.Table, 'Table');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvJanDSO(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvJanDSO) do begin
    RegisterMethod(@TJvJanDSO.SetValue, 'SetValue');
    RegisterMethod(@TJvJanDSO.GetValue, 'GetValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvForth(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJvJanScriptError) do
  RIRegister_TJvJanDSO(CL);
  RIRegister_TJvJanDSOList(CL);
  RIRegister_TJvJanXMLList(CL);
  RIRegister_TVariantObject(CL);
  RIRegister_TVariantList(CL);
  RIRegister_TAtom(CL);
  RIRegister_TAtomList(CL);
  RIRegister_TJvForthScript(CL);
end;



{ TPSImport_JvForth }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvForth.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvForth(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvForth.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvForth(ri);
  RIRegister_JvForth_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
