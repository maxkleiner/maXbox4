unit uPSI_PythonEngine;
{
a monster template for P4D Tester
  TError as the same on TError = procedure (const Msg: string) of object; in namedpipesimpl
    TError = procedure (const Msg: string) of object;   fix dll bug    - alias execStr()

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
  TPSImport_PythonEngine = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPythonThread(CL: TPSPascalCompiler);
procedure SIRegister_TPyVar(CL: TPSPascalCompiler);
procedure SIRegister_TPythonDelphiVar(CL: TPSPascalCompiler);
procedure SIRegister_TPythonType(CL: TPSPascalCompiler);
procedure SIRegister_TTypeServices(CL: TPSPascalCompiler);
procedure SIRegister_TPyObject(CL: TPSPascalCompiler);
procedure SIRegister_TPythonModule(CL: TPSPascalCompiler);
procedure SIRegister_TErrors(CL: TPSPascalCompiler);
procedure SIRegister_TError(CL: TPSPascalCompiler);
procedure SIRegister_TParentClassError(CL: TPSPascalCompiler);
procedure SIRegister_TGetSetContainer(CL: TPSPascalCompiler);
procedure SIRegister_TMembersContainer(CL: TPSPascalCompiler);
procedure SIRegister_TMethodsContainer(CL: TPSPascalCompiler);
procedure SIRegister_TEventDefs(CL: TPSPascalCompiler);
procedure SIRegister_TEventDef(CL: TPSPascalCompiler);
procedure SIRegister_TEngineClient(CL: TPSPascalCompiler);
procedure SIRegister_TPythonEngine(CL: TPSPascalCompiler);
procedure SIRegister_TPythonTraceback(CL: TPSPascalCompiler);
procedure SIRegister_TTracebackItem(CL: TPSPascalCompiler);
procedure SIRegister_TPythonInterface(CL: TPSPascalCompiler);
procedure SIRegister_TDynamicDll(CL: TPSPascalCompiler);
procedure SIRegister_TPythonInputOutput(CL: TPSPascalCompiler);
procedure SIRegister_EPySyntaxError(CL: TPSPascalCompiler);
procedure SIRegister_EPythonError(CL: TPSPascalCompiler);
procedure SIRegister_EDLLImportError(CL: TPSPascalCompiler);
procedure SIRegister_PythonEngine(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PythonEngine_Routines(S: TPSExec);
procedure RIRegister_TPythonThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPyVar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPythonDelphiVar(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPythonType(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTypeServices(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPyObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPythonModule(CL: TPSRuntimeClassImporter);
procedure RIRegister_TErrors(CL: TPSRuntimeClassImporter);
procedure RIRegister_TError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TParentClassError(CL: TPSRuntimeClassImporter);
procedure RIRegister_TGetSetContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMembersContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMethodsContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEventDefs(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEventDef(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEngineClient(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPythonEngine(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPythonTraceback(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTracebackItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPythonInterface(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDynamicDll(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPythonInputOutput(CL: TPSRuntimeClassImporter);
procedure RIRegister_EPySyntaxError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EPythonError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EDLLImportError(CL: TPSRuntimeClassImporter);
procedure RIRegister_PythonEngine(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Types
  ,Windows
  //,Dl
  //,DynLibs
  ,SyncObjs
  ,Variants
  ,MethodCallBack
  ,PythonEngine
  ;

//type TPyObject = PPyObject;
//type PPyObject = TPyObject;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PythonEngine]);
end;


 {
procedure setgPythonEngine(mypyengine: TPythonEngine);
begin
  gPythonEngine := mypyengine;
end;

function getgPythonEngine: TPythonEngine;
begin
  result:= gPythonEngine;
end; }

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TThread', 'TPythonThread') do
  with CL.AddClassN(CL.FindClass('TThread'),'TPythonThread') do
  begin
    RegisterMethod('Procedure Py_Begin_Allow_Threads');
    RegisterMethod('Procedure Py_End_Allow_Threads');
    RegisterMethod('Procedure Py_Begin_Block_Threads');
    RegisterMethod('Procedure Py_Begin_Unblock_Threads');
    RegisterProperty('ThreadState', 'PPyThreadState', iptr);
    RegisterProperty('ThreadExecMode', 'TThreadExecMode', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPyVar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPyObject', 'TPyVar') do
  with CL.AddClassN(CL.FindClass('TPyObject'),'TPyVar') do begin
    RegisterProperty('dv_var', 'Variant', iptrw);
    RegisterProperty('dv_component', 'TPythonDelphiVar', iptrw);
    RegisterProperty('dv_object', 'PPyObject', iptrw);
    //RegisterMethod('Constructor Create');
    RegisterMethod('Constructor Create( APythonType : TPythonType)');
     RegisterMethod('Procedure Free;');
    //constructor Create( APythonType : TPythonType ); override;
    RegisterMethod('Function GetValue : PPyObject');
    RegisterMethod('Function GetValueAsVariant : Variant');
    RegisterMethod('Procedure SetValue( value : PPyObject)');
    RegisterMethod('Procedure SetValueFromVariant( const value : Variant)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonDelphiVar(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEngineClient', 'TPythonDelphiVar') do
  with CL.AddClassN(CL.FindClass('TEngineClient'),'TPythonDelphiVar') do  begin
    RegisterMethod('Function IsVariantOk( const v : Variant) : Boolean');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Value', 'Variant', iptrw);
    RegisterProperty('ValueObject', 'PPyObject', iptrw);
    RegisterProperty('ValueAsString', 'string', iptr);
    RegisterProperty('VarObject', 'PPyObject', iptrw);
    RegisterProperty('Module', 'AnsiString', iptrw);
    RegisterProperty('VarName', 'AnsiString', iptrw);
    RegisterProperty('OnGetData', 'TGetDataEvent', iptrw);
    RegisterProperty('OnSetData', 'TSetDataEvent', iptrw);
    RegisterProperty('OnExtGetData', 'TExtGetDataEvent', iptrw);
    RegisterProperty('OnExtSetData', 'TExtSetDataEvent', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TGetSetContainer', 'TPythonType') do
  with CL.AddClassN(CL.FindClass('TGetSetContainer'),'TPythonType') do
  begin
    RegisterMethod('Function CreateInstance : PPyObject');
    RegisterMethod('Function CreateInstanceWith( args : PPyObject) : PPyObject');
    RegisterMethod('Procedure AddTypeVar');
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterProperty('TheType', 'PyTypeObject', iptrw);
    RegisterProperty('TheTypePtr', 'PPyTypeObject', iptr);
    RegisterProperty('PyObjectClass', 'TPyObjectClass', iptrw);
    RegisterProperty('InstanceCount', 'Integer', iptr);
    RegisterProperty('CreateHits', 'Integer', iptr);
    RegisterProperty('DeleteHits', 'Integer', iptr);
    RegisterProperty('DocString', 'TStringList', iptrw);
    RegisterProperty('TypeName', 'AnsiString', iptrw);
    RegisterProperty('TypeFlags', 'TPFlags', iptrw);
    RegisterProperty('Prefix', 'AnsiString', iptrw);
    RegisterProperty('Module', 'TPythonModule', iptrw);
    RegisterProperty('Services', 'TTypeServices', iptrw);
    RegisterProperty('GenerateCreateFunction', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTypeServices(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TTypeServices') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TTypeServices') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('Basic', 'TBasicServices', iptrw);
    RegisterProperty('InplaceNumber', 'TInplaceNumberServices', iptrw);
    RegisterProperty('Number', 'TNumberServices', iptrw);
    RegisterProperty('Sequence', 'TSequenceServices', iptrw);
    RegisterProperty('Mapping', 'TMappingServices', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPyObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPyObject') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPyObject') do
  begin
    RegisterProperty('PythonType', 'TPythonType', iptrw);
    RegisterProperty('IsSubtype', 'Boolean', iptrw);
    RegisterProperty('PythonAlloc', 'Boolean', iptrw);
    RegisterMethod('Constructor Create( APythonType : TPythonType)');
    RegisterMethod('Constructor CreateWith( APythonType : TPythonType; args : PPyObject)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function GetSelf : PPyObject');
    RegisterMethod('Procedure IncRef');
    RegisterMethod('Procedure Adjust( PyPointer : Pointer)');
    RegisterMethod('Function GetModule : TPythonModule');
    RegisterProperty('ob_refcnt', 'NativeInt', iptrw);
    RegisterProperty('ob_type', 'PPyTypeObject', iptrw);
    RegisterMethod('Function Print( var f : file; i : integer) : Integer');
    RegisterMethod('Function GetAttr( key : PAnsiChar) : PPyObject');
    RegisterMethod('Function SetAttr( key : PAnsiChar; value : PPyObject) : Integer');
    RegisterMethod('Function Repr : PPyObject');
    RegisterMethod('Function Compare( obj : PPyObject) : Integer');
    RegisterMethod('Function Hash : NativeInt');
    RegisterMethod('Function Str : PPyObject');
    RegisterMethod('Function GetAttrO( key : PPyObject) : PPyObject');
    RegisterMethod('Function SetAttrO( key, value : PPyObject) : Integer');
    RegisterMethod('Function Call( ob1, ob2 : PPyObject) : PPyObject');
    RegisterMethod('Function Traverse( proc : visitproc; ptr : Pointer) : integer');
    RegisterMethod('Function Clear : integer');
    RegisterMethod('Function RichCompare( obj : PPyObject; Op : TRichComparisonOpcode) : PPyObject');
    RegisterMethod('Function Iter : PPyObject');
    RegisterMethod('Function IterNext : PPyObject');
    RegisterMethod('Function Init( args, kwds : PPyObject) : Integer');
    RegisterMethod('Function NbAdd( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbSubtract( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbMultiply( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbFloorDivide( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbTrueDivide( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbMatrixMultiply( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbRemainder( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbDivmod( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbPower( ob1, ob2 : PPyObject) : PPyObject');
    RegisterMethod('Function NbNegative : PPyObject');
    RegisterMethod('Function NbPositive : PPyObject');
    RegisterMethod('Function NbAbsolute : PPyObject');
    RegisterMethod('Function NbBool : Integer');
    RegisterMethod('Function NbInvert : PPyObject');
    RegisterMethod('Function NbLShift( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbRShift( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbAnd( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbXor( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbOr( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInt : PPyObject');
    RegisterMethod('Function NbFloat : PPyObject');
    RegisterMethod('Function NbInplaceAdd( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceSubtract( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceMultiply( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceDivide( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceFloorDivide( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceTrueDivide( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceRemainder( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplacePower( ob1, ob2 : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceLshift( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceRshift( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceAnd( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceXor( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceOr( obj : PPyObject) : PPyObject');
    RegisterMethod('Function NbInplaceMatrixMultiply( obj : PPyObject) : PPyObject');
    RegisterMethod('Function SqLength : NativeInt');
    RegisterMethod('Function SqConcat( obj : PPyObject) : PPyObject');
    RegisterMethod('Function SqRepeat( val : NativeInt) : PPyObject');
    RegisterMethod('Function SqItem( idx : NativeInt) : PPyObject');
    RegisterMethod('Function SqAssItem( idx : NativeInt; obj : PPyObject) : Integer');
    RegisterMethod('Function SqContains( obj : PPyObject) : integer');
    RegisterMethod('Function SqInplaceConcat( obj : PPyObject) : PPyObject');
    RegisterMethod('Function SqInplaceRepeat( i : NativeInt) : PPyObject');
    RegisterMethod('Function MpLength : NativeInt');
    RegisterMethod('Function MpSubscript( obj : PPyObject) : PPyObject');
    RegisterMethod('Function MpAssSubscript( obj1, obj2 : PPyObject) : Integer');
    RegisterMethod('Procedure RegisterMethods( APythonType : TPythonType)');
    RegisterMethod('Procedure RegisterMembers( APythonType : TPythonType)');
    RegisterMethod('Procedure RegisterGetSets( APythonType : TPythonType)');
    RegisterMethod('Procedure SetupType( APythonType : TPythonType)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMethodsContainer', 'TPythonModule') do
  with CL.AddClassN(CL.FindClass('TMethodsContainer'),'TPythonModule') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure MakeModule');
    RegisterMethod('Procedure DefineDocString');
    RegisterMethod('Procedure Initialize');
    RegisterMethod('Procedure InitializeForNewInterpreter');
    RegisterMethod('Procedure AddClient( client : TEngineClient)');
    RegisterMethod('Function ErrorByName( const AName : AnsiString) : TError');
    RegisterMethod('Procedure RaiseError( const error, msg : AnsiString)');
    RegisterMethod('Procedure RaiseErrorFmt( const error, format : AnsiString; const Args : array of const)');
    RegisterMethod('Procedure RaiseErrorObj( const error, msg : AnsiString; obj : PPyObject)');
    RegisterMethod('Procedure BuildErrors');
    RegisterMethod('Procedure SetVar( const varName : AnsiString; value : PPyObject)');
    RegisterMethod('Function GetVar( const varName : AnsiString) : PPyObject');
    RegisterMethod('Procedure DeleteVar( const varName : AnsiString)');
    RegisterMethod('Procedure ClearVars');
    RegisterMethod('Procedure SetVarFromVariant( const varName : AnsiString; const value : Variant)');
    RegisterMethod('Function GetVarAsVariant( const varName : AnsiString) : Variant');
    RegisterProperty('Module', 'PPyObject', iptr);
    RegisterProperty('Clients', 'TEngineClient Integer', iptr);
    RegisterProperty('ClientCount', 'Integer', iptr);
    RegisterProperty('DocString', 'TStringList', iptrw);
    RegisterProperty('ModuleName', 'AnsiString', iptrw);
    RegisterProperty('Errors', 'TErrors', iptrw);
    RegisterProperty('OnAfterInitialization', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TErrors(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TErrors') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TErrors') do begin
    RegisterMethod('Constructor Create( Module : TPythonModule)');
    RegisterMethod('Function Add : TError');
    RegisterMethod('Function Owner : TPythonModule');
    RegisterProperty('Items', 'TError Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TError') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TError') do begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Procedure BuildError( const ModuleName : AnsiString)');
    RegisterMethod('Procedure RaiseError( const msg : AnsiString)');
    RegisterMethod('Procedure RaiseErrorObj( const msg : AnsiString; obj : PPyObject)');
    RegisterMethod('Function Owner : TErrors');
    RegisterProperty('Error', 'PPyObject', iptrw);
    RegisterProperty('Name', 'AnsiString', iptrw);
    RegisterProperty('Text', 'AnsiString', iptrw);
    RegisterProperty('ErrorType', 'TErrorType', iptrw);
    RegisterProperty('ParentClass', 'TParentClassError', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TParentClassError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TParentClassError') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TParentClassError') do
  begin
    RegisterMethod('Procedure AssignTo( Dest : TPersistent)');
    RegisterProperty('Module', 'AnsiString', iptrw);
    RegisterProperty('Name', 'AnsiString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TGetSetContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMembersContainer', 'TGetSetContainer') do
  with CL.AddClassN(CL.FindClass('TMembersContainer'),'TGetSetContainer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AddGetSet( AName : PAnsiChar; AGet : getter; ASet : setter; ADoc : PAnsiChar; AClosure : Pointer)');
    RegisterMethod('Procedure ClearGetSets');
    RegisterProperty('GetSetCount', 'Integer', iptr);
    RegisterProperty('GetSet', 'PPyGetSetDef Integer', iptr);
    RegisterProperty('GetSetData', 'PPyGetSetDef', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMembersContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMethodsContainer', 'TMembersContainer') do
  with CL.AddClassN(CL.FindClass('TMethodsContainer'),'TMembersContainer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AddMember( MemberName : PAnsiChar; MemberType : TPyMemberType; MemberOffset : NativeInt; MemberFlags : TPyMemberFlag; MemberDoc : PAnsiChar)');
    RegisterMethod('Procedure ClearMembers');
    RegisterProperty('MemberCount', 'Integer', iptr);
    RegisterProperty('Members', 'PPyMemberDef Integer', iptr);
    RegisterProperty('MembersData', 'PPyMemberDef', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMethodsContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEngineClient', 'TMethodsContainer') do
  with CL.AddClassN(CL.FindClass('TEngineClient'),'TMethodsContainer') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Initialize');
    RegisterMethod('Procedure Finalize');
    RegisterMethod('Function AddMethod( AMethodName : PAnsiChar; AMethod : PyCFunction; ADocString : PAnsiChar) : PPyMethodDef');
    RegisterMethod('Function AddMethodWithKeywords( AMethodName : PAnsiChar; AMethod : PyCFunctionWithKW; ADocString : PAnsiChar) : PPyMethodDef');
    RegisterMethod('Function AddDelphiMethod( AMethodName : PAnsiChar; ADelphiMethod : TDelphiMethod; ADocString : PAnsiChar) : PPyMethodDef');
    RegisterMethod('Function AddDelphiMethodWithKeywords( AMethodName : PAnsiChar; ADelphiMethod : TDelphiMethodWithKW; ADocString : PAnsiChar) : PPyMethodDef');
    RegisterMethod('Procedure ClearMethods');
    RegisterProperty('MethodCount', 'Integer', iptr);
    RegisterProperty('Methods', 'PPyMethodDef Integer', iptr);
    RegisterProperty('MethodsData', 'PPyMethodDef', iptr);
    RegisterProperty('ModuleDef', 'PyModuleDef', iptr);
    RegisterProperty('Events', 'TEventDefs', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEventDefs(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TEventDefs') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TEventDefs') do
  begin
    RegisterMethod('Constructor Create( AMethodsContainer : TMethodsContainer)');
    RegisterMethod('Function Add : TEventDef');
    RegisterMethod('Procedure RegisterEvents');
    RegisterProperty('Items', 'TEventDef Integer', iptr);
    RegisterProperty('Container', 'TMethodsContainer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEventDef(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TEventDef') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TEventDef') do begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function GetDocString : AnsiString');
    RegisterMethod('Function PythonEvent( pself, args : PPyObject) : PPyObject');
    RegisterMethod('Function Owner : TEventDefs');
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('OnExecute', 'TPythonEvent', iptrw);
    RegisterProperty('DocString', 'TStringList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEngineClient(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TEngineClient') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TEngineClient') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Initialize');
    RegisterMethod('Procedure Finalize');
    RegisterMethod('Procedure ClearEngine');
    RegisterMethod('Procedure CheckEngine');
    RegisterProperty('Initialized', 'Boolean', iptr);
    RegisterProperty('Engine', 'TPythonEngine', iptrw);
    RegisterProperty('OnCreate', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDestroy', 'TNotifyEvent', iptrw);
    RegisterProperty('OnFinalization', 'TNotifyEvent', iptrw);
    RegisterProperty('OnInitialization', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonEngine(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPythonInterface', 'TPythonEngine') do
  with CL.AddClassN(CL.FindClass('TPythonInterface'),'TPythonEngine') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure SetPythonHome( const PythonHome : UnicodeString)');
    RegisterMethod('Procedure SetProgramName( const ProgramName : UnicodeString)');
    RegisterMethod('Function IsType( ob : PPyObject; obt : PPyTypeObject) : Boolean');
    RegisterMethod('Function Run_CommandAsString( const command : AnsiString; mode : Integer) : string');
    RegisterMethod('Function Run_CommandAsObject( const command : AnsiString; mode : Integer) : PPyObject');
    RegisterMethod('Function Run_CommandAsObjectWithDict( const command : AnsiString; mode : Integer; locals, globals : PPyObject) : PPyObject');
    RegisterMethod('Function EncodeString1( const str : UnicodeString) : AnsiString;');
    RegisterMethod('Function EncodeString( const str : UnicodeString) : AnsiString;');
    RegisterMethod('Function EncodeString2( const str : AnsiString) : AnsiString;');
    RegisterMethod('Function EncodeWindowsFilePath( const str : string) : AnsiString');
     RegisterMethod('Procedure Initialize2;');
     RegisterMethod('procedure DoOpenDll2(const aDllName : string);');
    RegisterMethod('procedure SetProgramArgs2;');

    RegisterMethod('Procedure ExecString3( const command : AnsiString);');
    RegisterMethod('Procedure ExecString( const command : AnsiString);');
    RegisterMethod('Procedure ExecStr( const command : AnsiString);');    //alias
    RegisterMethod('Procedure ExecStrings4( strings : TStrings);');
    RegisterMethod('Procedure ExecStrings( strings : TStrings);');
    RegisterMethod('Function EvalString5( const command : AnsiString) : PPyObject;');
    RegisterMethod('Function EvalStringAsStr( const command : AnsiString) : string');
    RegisterMethod('Function EvalStr( const command : AnsiString) : string');
    RegisterMethod('Function EvalStrings6( strings : TStrings) : PPyObject;');
    RegisterMethod('Procedure ExecString7( const command : AnsiString; locals, globals : PPyObject);');
    RegisterMethod('Procedure ExecStrings8( strings : TStrings; locals, globals : PPyObject);');
    RegisterMethod('Function EvalString9( const command : AnsiString; locals, globals : PPyObject) : PPyObject;');
    RegisterMethod('Function EvalStrings10( strings : TStrings; locals, globals : PPyObject) : PPyObject;');
    RegisterMethod('Function EvalStringsAsStr( strings : TStrings) : string');
    RegisterMethod('Function EvalPyFunction( pyfunc, pyargs : PPyObject) : Variant');
    RegisterMethod('Function EvalFunction( pyfunc : PPyObject; const args : array of const) : Variant');
    RegisterMethod('Function EvalFunctionNoArgs( pyfunc : PPyObject) : Variant');
    RegisterMethod('Function CheckEvalSyntax( const str : AnsiString) : Boolean');
    RegisterMethod('Function CheckExecSyntax( const str : AnsiString) : Boolean');
    RegisterMethod('Function CheckSyntax( const str : AnsiString; mode : Integer) : Boolean');
    RegisterMethod('Procedure RaiseError');
    RegisterMethod('Function PyObjectAsString( obj : PPyObject) : string');
    RegisterMethod('Procedure DoRedirectIO');
    RegisterMethod('Procedure AddClient( client : TEngineClient)');
    RegisterMethod('Procedure RemoveClient( client : TEngineClient)');
    RegisterMethod('Function FindClient( const aName : string) : TEngineClient');
    RegisterMethod('Function TypeByName( const aTypeName : AnsiString) : PPyTypeObject');
    RegisterMethod('Function ModuleByName( const aModuleName : AnsiString) : PPyObject');
    RegisterMethod('Function MethodsByName( const aMethodsContainer : string) : PPyMethodDef');
    RegisterMethod('Function VariantAsPyObject( const V : Variant) : PPyObject');
    RegisterMethod('Function PyObjectAsVariant( obj : PPyObject) : Variant');
    RegisterMethod('Function VarRecAsPyObject( const v : TVarRec) : PPyObject');
    RegisterMethod('Function MakePyTuple( const objects : array of PPyObject) : PPyObject');
    RegisterMethod('Function MakePyList( const objects : array of PPyObject) : PPyObject');
    RegisterMethod('Function ArrayToPyTuple( const items : array of const) : PPyObject');
    RegisterMethod('Function ArrayToPyList( const items : array of const) : PPyObject');
    RegisterMethod('Function ArrayToPyDict( const items : array of const) : PPyObject');
    RegisterMethod('Function StringsToPyList( strings : TStrings) : PPyObject');
    RegisterMethod('Function StringsToPyTuple( strings : TStrings) : PPyObject');
    RegisterMethod('Procedure PyListToStrings( list : PPyObject; strings : TStrings)');
    RegisterMethod('Procedure PyTupleToStrings( tuple : PPyObject; strings : TStrings)');
    RegisterMethod('Function ReturnNone : PPyObject');
    RegisterMethod('Function ReturnTrue : PPyObject');
    RegisterMethod('Function ReturnFalse : PPyObject');
    RegisterMethod('Function FindModule( const ModuleName : AnsiString) : PPyObject');
    RegisterMethod('Function FindFunction( const ModuleName, FuncName : AnsiString) : PPyObject');
    RegisterMethod('Function SetToList( data : Pointer; size : Integer) : PPyObject');
    RegisterMethod('Procedure ListToSet( List : PPyObject; data : Pointer; size : Integer)');
    RegisterMethod('Procedure CheckError( ACatchStopEx : Boolean)');
    RegisterMethod('Function GetMainModule : PPyObject');
    RegisterMethod('Function PyTimeStruct_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyDate_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyDate_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyDateTime_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyDateTime_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyTime_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyTime_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyDelta_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyDelta_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyTZInfo_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyTZInfo_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyUnicodeFromString11( const AString : UnicodeString) : PPyObject;');
    RegisterMethod('Function PyUnicodeFromString12( const AString : AnsiString) : PPyObject;');
    RegisterMethod('Function PyUnicodeAsString( obj : PPyObject) : UnicodeString');
    RegisterMethod('Function PyUnicodeAsUTF8String( obj : PPyObject) : RawByteString');
    RegisterMethod('Function PyBytesAsAnsiString( obj : PPyObject) : AnsiString');
    RegisterProperty('ClientCount', 'Integer', iptr);
    RegisterProperty('Clients', 'TEngineClient Integer', iptr);
    RegisterProperty('ExecModule', 'AnsiString', iptrw);
    RegisterProperty('ThreadState', 'PPyThreadState', iptr);
    RegisterProperty('Traceback', 'TPythonTraceback', iptr);
    RegisterProperty('LocalVars', 'PPyObject', iptrw);
    RegisterProperty('GlobalVars', 'PPyObject', iptrw);
    RegisterProperty('IOPythonModule', 'TObject', iptr);
    RegisterProperty('PythonHome', 'UnicodeString', iptrw);
    RegisterProperty('ProgramName', 'UnicodeString', iptrw);
    RegisterProperty('AutoFinalize', 'Boolean', iptrw);
    RegisterProperty('VenvPythonExe', 'string', iptrw);
    RegisterProperty('DatetimeConversionMode', 'TDatetimeConversionMode', iptrw);
    RegisterProperty('InitScript', 'TStrings', iptrw);
    RegisterProperty('InitThreads', 'Boolean', iptrw);
    RegisterProperty('IO', 'TPythonInputOutput', iptrw);
    RegisterProperty('PyFlags', 'TPythonFlags', iptrw);
    RegisterProperty('RedirectIO', 'Boolean', iptrw);
    RegisterProperty('UseWindowsConsole', 'Boolean', iptrw);
    RegisterProperty('OnAfterInit', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPathInitialization', 'TPathInitializationEvent', iptrw);
    RegisterProperty('OnSysPathInit', 'TSysPathInitEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonTraceback(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPythonTraceback') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPythonTraceback') do
  begin
    RegisterMethod('Constructor Create');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Refresh( pytraceback : PPyObject)');
    RegisterMethod('Procedure AddItem( const Context, FileName : string; LineNo : Integer)');
    RegisterProperty('ItemCount', 'Integer', iptr);
    RegisterProperty('Items', 'TTracebackItem Integer', iptr);
    RegisterProperty('Limit', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTracebackItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTracebackItem') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTracebackItem') do
  begin
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('LineNo', 'Integer', iptrw);
    RegisterProperty('Context', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonInterface(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TDynamicDll', 'TPythonInterface') do
  with CL.AddClassN(CL.FindClass('TDynamicDll'),'TPythonInterface') do
  begin
    RegisterProperty('Py_DebugFlag', 'PInteger', iptrw);
    RegisterProperty('Py_VerboseFlag', 'PInteger', iptrw);
    RegisterProperty('Py_InteractiveFlag', 'PInteger', iptrw);
    RegisterProperty('Py_OptimizeFlag', 'PInteger', iptrw);
    RegisterProperty('Py_NoSiteFlag', 'PInteger', iptrw);
    RegisterProperty('Py_FrozenFlag', 'PInteger', iptrw);
    RegisterProperty('Py_IgnoreEnvironmentFlag', 'PInteger', iptrw);
    RegisterProperty('PyImport_FrozenModules', 'PP_frozen', iptrw);
    RegisterProperty('Py_None', 'PPyObject', iptrw);
    RegisterProperty('Py_Ellipsis', 'PPyObject', iptrw);
    RegisterProperty('Py_False', 'PPyObject', iptrw);
    RegisterProperty('Py_True', 'PPyObject', iptrw);
    RegisterProperty('Py_NotImplemented', 'PPyObject', iptrw);
    RegisterProperty('PyExc_AttributeError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_EOFError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_IOError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_ImportError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_IndexError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_KeyError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_KeyboardInterrupt', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_MemoryError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_NameError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_OverflowError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_RuntimeError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_SyntaxError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_SystemError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_SystemExit', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_TypeError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_ValueError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_ZeroDivisionError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_ArithmeticError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_Exception', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_FloatingPointError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_LookupError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_AssertionError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_EnvironmentError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_IndentationError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_NotImplementedError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_OSError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_TabError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_UnboundLocalError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_UnicodeError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_WindowsError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_Warning', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_DeprecationWarning', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_RuntimeWarning', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_SyntaxWarning', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_UserWarning', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_ReferenceError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_StopIteration', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_FutureWarning', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_PendingDeprecationWarning', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_UnicodeDecodeError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_UnicodeEncodeError', 'PPPyObject', iptrw);
    RegisterProperty('PyExc_UnicodeTranslateError', 'PPPyObject', iptrw);
    RegisterProperty('PyCode_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyType_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyCFunction_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyComplex_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyDict_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyFloat_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyFrame_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyFunction_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyList_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyLong_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyMethod_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyModule_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyObject_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyRange_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PySlice_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyBytes_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyTuple_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyBaseObject_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyCallIter_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyCell_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyClassMethod_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyProperty_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PySeqIter_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyStaticMethod_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PySuper_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyTraceBack_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyUnicode_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyWrapperDescr_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('_PyWeakref_RefType', 'PPyTypeObject', iptrw);
    RegisterProperty('_PyWeakref_ProxyType', 'PPyTypeObject', iptrw);
    RegisterProperty('_PyWeakref_CallableProxyType', 'PPyTypeObject', iptrw);
    RegisterProperty('PyBool_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('PyEnum_Type', 'PPyTypeObject', iptrw);
    RegisterProperty('Py_GetBuildInfo', '', iptrw);
    RegisterProperty('PyImport_ExecCodeModule', '', iptrw);
    RegisterProperty('PyComplex_FromCComplex', '', iptrw);
    RegisterProperty('PyComplex_FromDoubles', '', iptrw);
    RegisterProperty('PyComplex_RealAsDouble', '', iptrw);
    RegisterProperty('PyComplex_ImagAsDouble', '', iptrw);
    RegisterProperty('PyComplex_AsCComplex', '', iptrw);
    RegisterProperty('PyCFunction_GetFunction', '', iptrw);
    RegisterProperty('PyCFunction_GetSelf', '', iptrw);
    RegisterProperty('PyCallable_Check', '', iptrw);
    RegisterProperty('PyModule_Create2', '', iptrw);
    RegisterProperty('PyErr_BadArgument', '', iptrw);
    RegisterProperty('PyErr_BadInternalCall', '', iptrw);
    RegisterProperty('PyErr_CheckSignals', '', iptrw);
    RegisterProperty('PyErr_Clear', '', iptrw);
    RegisterProperty('PyErr_Fetch', '', iptrw);
    RegisterProperty('PyErr_NoMemory', '', iptrw);
    RegisterProperty('PyErr_Occurred', '', iptrw);
    RegisterProperty('PyErr_Print', '', iptrw);
    RegisterProperty('PyErr_Restore', '', iptrw);
    RegisterProperty('PyErr_SetFromErrno', '', iptrw);
    RegisterProperty('PyErr_SetNone', '', iptrw);
    RegisterProperty('PyErr_SetObject', '', iptrw);
    RegisterProperty('PyErr_SetString', '', iptrw);
    RegisterProperty('PyErr_WarnEx', '', iptrw);
    RegisterProperty('PyErr_WarnExplicit', '', iptrw);
    RegisterProperty('PyImport_GetModuleDict', '', iptrw);
    RegisterProperty('PyArg_Parse', 'TPyArg_Parse', iptrw);
    RegisterProperty('PyArg_ParseTuple', 'TPyArg_Parse', iptrw);
    RegisterProperty('PyArg_ParseTupleAndKeywords', 'TPyArg_ParseTupleAndKeywords', iptrw);
    RegisterProperty('Py_BuildValue', 'TPy_BuildValue', iptrw);
    RegisterProperty('Py_Initialize', '', iptrw);
    RegisterProperty('Py_Exit', '', iptrw);
    RegisterProperty('PyEval_GetBuiltins', '', iptrw);
    RegisterProperty('PyDict_Copy', '', iptrw);
    RegisterProperty('PyDict_GetItem', '', iptrw);
    RegisterProperty('PyDict_SetItem', '', iptrw);
    RegisterProperty('PyDict_DelItem', '', iptrw);
    RegisterProperty('PyDict_Clear', '', iptrw);
    RegisterProperty('PyDict_Next', '', iptrw);
    RegisterProperty('PyDict_Keys', '', iptrw);
    RegisterProperty('PyDict_Values', '', iptrw);
    RegisterProperty('PyDict_Items', '', iptrw);
    RegisterProperty('PyDict_Size', '', iptrw);
    RegisterProperty('PyDict_Update', '', iptrw);
    RegisterProperty('PyDict_DelItemString', '', iptrw);
    RegisterProperty('PyDict_New', '', iptrw);
    RegisterProperty('PyDict_GetItemString', '', iptrw);
    RegisterProperty('PyDict_SetItemString', '', iptrw);
    RegisterProperty('PyDictProxy_New', '', iptrw);
    RegisterProperty('PyModule_GetDict', '', iptrw);
    RegisterProperty('PyObject_Str', '', iptrw);
    RegisterProperty('PyRun_String', '', iptrw);
    RegisterProperty('PyRun_SimpleString', '', iptrw);
    RegisterProperty('PyBytes_AsString', '', iptrw);
    RegisterProperty('PyBytes_AsStringAndSize', '', iptrw);
    RegisterProperty('PySys_SetArgv', '', iptrw);
    RegisterProperty('PyCFunction_NewEx', '', iptrw);
    RegisterProperty('PyEval_CallObjectWithKeywords', '', iptrw);
    RegisterProperty('PyEval_GetFrame', '', iptrw);
    RegisterProperty('PyEval_GetGlobals', '', iptrw);
    RegisterProperty('PyEval_GetLocals', '', iptrw);
    RegisterProperty('PyEval_InitThreads', '', iptrw);
    RegisterProperty('PyEval_RestoreThread', '', iptrw);
    RegisterProperty('PyEval_SaveThread', '', iptrw);
    RegisterProperty('PyFile_GetLine', '', iptrw);
    RegisterProperty('PyFile_WriteObject', '', iptrw);
    RegisterProperty('PyFile_WriteString', '', iptrw);
    RegisterProperty('PyFloat_AsDouble', '', iptrw);
    RegisterProperty('PyFloat_FromDouble', '', iptrw);
    RegisterProperty('PyFloat_FromString', '', iptrw);
    RegisterProperty('PyFunction_GetCode', '', iptrw);
    RegisterProperty('PyFunction_GetGlobals', '', iptrw);
    RegisterProperty('PyFunction_New', '', iptrw);
    RegisterProperty('PyImport_AddModule', '', iptrw);
    RegisterProperty('PyImport_GetMagicNumber', '', iptrw);
    RegisterProperty('PyImport_ImportFrozenModule', '', iptrw);
    RegisterProperty('PyImport_ImportModule', '', iptrw);
    RegisterProperty('PyImport_Import', '', iptrw);
    RegisterProperty('PyImport_ReloadModule', '', iptrw);
    RegisterProperty('PyList_Append', '', iptrw);
    RegisterProperty('PyList_AsTuple', '', iptrw);
    RegisterProperty('PyList_GetItem', '', iptrw);
    RegisterProperty('PyList_GetSlice', '', iptrw);
    RegisterProperty('PyList_Insert', '', iptrw);
    RegisterProperty('PyList_New', '', iptrw);
    RegisterProperty('PyList_Reverse', '', iptrw);
    RegisterProperty('PyList_SetItem', '', iptrw);
    RegisterProperty('PyList_SetSlice', '', iptrw);
    RegisterProperty('PyList_Size', '', iptrw);
    RegisterProperty('PyList_Sort', '', iptrw);
    RegisterProperty('PyLong_AsDouble', '', iptrw);
    RegisterProperty('PyLong_AsLong', '', iptrw);
    RegisterProperty('PyLong_FromDouble', '', iptrw);
    RegisterProperty('PyLong_FromLong', '', iptrw);
    RegisterProperty('PyLong_FromString', '', iptrw);
    RegisterProperty('PyLong_FromUnsignedLong', '', iptrw);
    RegisterProperty('PyLong_AsUnsignedLong', '', iptrw);
    RegisterProperty('PyLong_FromUnicodeObject', '', iptrw);
    RegisterProperty('PyLong_FromLongLong', '', iptrw);
    RegisterProperty('PyLong_FromUnsignedLongLong', '', iptrw);
    RegisterProperty('PyLong_AsLongLong', '', iptrw);
    RegisterProperty('PyLong_FromVoidPtr', '', iptrw);
    RegisterProperty('PyMapping_Check', '', iptrw);
    RegisterProperty('PyMapping_GetItemString', '', iptrw);
    RegisterProperty('PyMapping_HasKey', '', iptrw);
    RegisterProperty('PyMapping_HasKeyString', '', iptrw);
    RegisterProperty('PyMapping_Length', '', iptrw);
    RegisterProperty('PyMapping_SetItemString', '', iptrw);
    RegisterProperty('PyMethod_Function', '', iptrw);
    RegisterProperty('PyMethod_New', '', iptrw);
    RegisterProperty('PyMethod_Self', '', iptrw);
    RegisterProperty('PyModule_GetName', '', iptrw);
    RegisterProperty('PyModule_New', '', iptrw);
    RegisterProperty('PyNumber_Absolute', '', iptrw);
    RegisterProperty('PyNumber_Add', '', iptrw);
    RegisterProperty('PyNumber_And', '', iptrw);
    RegisterProperty('PyNumber_Check', '', iptrw);
    RegisterProperty('PyNumber_FloorDivide', '', iptrw);
    RegisterProperty('PyNumber_TrueDivide', '', iptrw);
    RegisterProperty('PyNumber_Divmod', '', iptrw);
    RegisterProperty('PyNumber_Float', '', iptrw);
    RegisterProperty('PyNumber_Invert', '', iptrw);
    RegisterProperty('PyNumber_Long', '', iptrw);
    RegisterProperty('PyNumber_Lshift', '', iptrw);
    RegisterProperty('PyNumber_Multiply', '', iptrw);
    RegisterProperty('PyNumber_Negative', '', iptrw);
    RegisterProperty('PyNumber_Or', '', iptrw);
    RegisterProperty('PyNumber_Positive', '', iptrw);
    RegisterProperty('PyNumber_Power', '', iptrw);
    RegisterProperty('PyNumber_Remainder', '', iptrw);
    RegisterProperty('PyNumber_Rshift', '', iptrw);
    RegisterProperty('PyNumber_Subtract', '', iptrw);
    RegisterProperty('PyNumber_Xor', '', iptrw);
    RegisterProperty('PyOS_InterruptOccurred', '', iptrw);
    RegisterProperty('PyObject_CallObject', '', iptrw);
    RegisterProperty('PyObject_RichCompare', '', iptrw);
    RegisterProperty('PyObject_RichCompareBool', '', iptrw);
    RegisterProperty('PyObject_GetAttr', '', iptrw);
    RegisterProperty('PyObject_GetAttrString', '', iptrw);
    RegisterProperty('PyObject_GetItem', '', iptrw);
    RegisterProperty('PyObject_DelItem', '', iptrw);
    RegisterProperty('PyObject_HasAttrString', '', iptrw);
    RegisterProperty('PyObject_Hash', '', iptrw);
    RegisterProperty('PyObject_IsTrue', '', iptrw);
    RegisterProperty('PyObject_Length', '', iptrw);
    RegisterProperty('PyObject_Repr', '', iptrw);
    RegisterProperty('PyObject_SetAttr', '', iptrw);
    RegisterProperty('PyObject_SetAttrString', '', iptrw);
    RegisterProperty('PyObject_SetItem', '', iptrw);
    RegisterProperty('PyObject_Init', '', iptrw);
    RegisterProperty('PyObject_InitVar', '', iptrw);
    RegisterProperty('PyObject_New', '', iptrw);
    RegisterProperty('PyObject_NewVar', '', iptrw);
    RegisterProperty('PyObject_Free', '', iptrw);
    RegisterProperty('PyObject_GetIter', '', iptrw);
    RegisterProperty('PyIter_Next', '', iptrw);
    RegisterProperty('PyObject_IsInstance', '', iptrw);
    RegisterProperty('PyObject_IsSubclass', '', iptrw);
    RegisterProperty('PyObject_Call', '', iptrw);
    RegisterProperty('PyObject_GenericGetAttr', '', iptrw);
    RegisterProperty('PyObject_GenericSetAttr', '', iptrw);
    RegisterProperty('PyObject_GC_Malloc', '', iptrw);
    RegisterProperty('PyObject_GC_New', '', iptrw);
    RegisterProperty('PyObject_GC_NewVar', '', iptrw);
    RegisterProperty('PyObject_GC_Resize', '', iptrw);
    RegisterProperty('PyObject_GC_Del', '', iptrw);
    RegisterProperty('PyObject_GC_Track', '', iptrw);
    RegisterProperty('PyObject_GC_UnTrack', '', iptrw);
    RegisterProperty('PySequence_Check', '', iptrw);
    RegisterProperty('PySequence_Concat', '', iptrw);
    RegisterProperty('PySequence_Count', '', iptrw);
    RegisterProperty('PySequence_GetItem', '', iptrw);
    RegisterProperty('PySequence_GetSlice', '', iptrw);
    RegisterProperty('PySequence_In', '', iptrw);
    RegisterProperty('PySequence_Index', '', iptrw);
    RegisterProperty('PySequence_Length', '', iptrw);
    RegisterProperty('PySequence_Repeat', '', iptrw);
    RegisterProperty('PySequence_SetItem', '', iptrw);
    RegisterProperty('PySequence_SetSlice', '', iptrw);
    RegisterProperty('PySequence_DelSlice', '', iptrw);
    RegisterProperty('PySequence_Tuple', '', iptrw);
    RegisterProperty('PySequence_Contains', '', iptrw);
    RegisterProperty('PySequence_List', '', iptrw);
    RegisterProperty('PySeqIter_New', '', iptrw);
    RegisterProperty('PySlice_GetIndices', '', iptrw);
    RegisterProperty('PySlice_GetIndicesEx', '', iptrw);
    RegisterProperty('PySlice_New', '', iptrw);
    RegisterProperty('PyBytes_Concat', '', iptrw);
    RegisterProperty('PyBytes_ConcatAndDel', '', iptrw);
    RegisterProperty('PyBytes_FromString', '', iptrw);
    RegisterProperty('PyBytes_FromStringAndSize', '', iptrw);
    RegisterProperty('PyBytes_Size', '', iptrw);
    RegisterProperty('PyBytes_DecodeEscape', '', iptrw);
    RegisterProperty('PyBytes_Repr', '', iptrw);
    RegisterProperty('PySys_GetObject', '', iptrw);
    RegisterProperty('PySys_SetObject', '', iptrw);
    RegisterProperty('PySys_SetPath', '', iptrw);
    RegisterProperty('PyTraceBack_Here', '', iptrw);
    RegisterProperty('PyTraceBack_Print', '', iptrw);
    RegisterProperty('PyTuple_GetItem', '', iptrw);
    RegisterProperty('PyTuple_GetSlice', '', iptrw);
    RegisterProperty('PyTuple_New', '', iptrw);
    RegisterProperty('PyTuple_SetItem', '', iptrw);
    RegisterProperty('PyTuple_Size', '', iptrw);
    RegisterProperty('PyType_IsSubtype', '', iptrw);
    RegisterProperty('PyType_GenericAlloc', '', iptrw);
    RegisterProperty('PyType_GenericNew', '', iptrw);
    RegisterProperty('PyType_Ready', '', iptrw);
    RegisterProperty('PyUnicode_FromWideChar', '', iptrw);
    RegisterProperty('PyUnicode_FromString', '', iptrw);
    RegisterProperty('PyUnicode_FromStringAndSize', '', iptrw);
    RegisterProperty('PyUnicode_FromKindAndData', '', iptrw);
    RegisterProperty('PyUnicode_AsWideChar', '', iptrw);
    RegisterProperty('PyUnicode_AsUTF8', '', iptrw);
    RegisterProperty('PyUnicode_AsUTF8AndSize', '', iptrw);
    RegisterProperty('PyUnicode_Decode', '', iptrw);
    RegisterProperty('PyUnicode_DecodeUTF16', '', iptrw);
    RegisterProperty('PyUnicode_AsEncodedString', '', iptrw);
    RegisterProperty('PyUnicode_FromOrdinal', '', iptrw);
    RegisterProperty('PyUnicode_GetSize', '', iptrw);
    RegisterProperty('PyWeakref_GetObject', '', iptrw);
    RegisterProperty('PyWeakref_NewProxy', '', iptrw);
    RegisterProperty('PyWeakref_NewRef', '', iptrw);
    RegisterProperty('PyWrapper_New', '', iptrw);
    RegisterProperty('PyBool_FromLong', '', iptrw);
    RegisterProperty('PyThreadState_SetAsyncExc', '', iptrw);
    RegisterProperty('Py_AtExit', '', iptrw);
    RegisterProperty('Py_CompileStringExFlags', '', iptrw);
    RegisterProperty('Py_FatalError', '', iptrw);
    RegisterProperty('_PyObject_New', '', iptrw);
    RegisterProperty('_PyBytes_Resize', '', iptrw);
    RegisterProperty('Py_Finalize', '', iptrw);
    RegisterProperty('PyErr_ExceptionMatches', '', iptrw);
    RegisterProperty('PyErr_GivenExceptionMatches', '', iptrw);
    RegisterProperty('PyEval_EvalCode', '', iptrw);
    RegisterProperty('Py_GetVersion', '', iptrw);
    RegisterProperty('Py_GetCopyright', '', iptrw);
    RegisterProperty('Py_GetExecPrefix', '', iptrw);
    RegisterProperty('Py_GetPath', '', iptrw);
    RegisterProperty('Py_SetPythonHome', '', iptrw);
    RegisterProperty('Py_GetPythonHome', '', iptrw);
    RegisterProperty('Py_GetPrefix', '', iptrw);
    RegisterProperty('Py_GetProgramName', '', iptrw);
    RegisterProperty('PyParser_SimpleParseStringFlags', '', iptrw);
    RegisterProperty('PyNode_Free', '', iptrw);
    RegisterProperty('PyErr_NewException', '', iptrw);
    RegisterProperty('PyMem_Malloc', '', iptrw);
    RegisterProperty('Py_SetProgramName', '', iptrw);
    RegisterProperty('Py_IsInitialized', '', iptrw);
    RegisterProperty('Py_GetProgramFullPath', '', iptrw);
    RegisterProperty('Py_NewInterpreter', '', iptrw);
    RegisterProperty('Py_EndInterpreter', '', iptrw);
    RegisterProperty('PyEval_AcquireLock', '', iptrw);
    RegisterProperty('PyEval_ReleaseLock', '', iptrw);
    RegisterProperty('PyEval_AcquireThread', '', iptrw);
    RegisterProperty('PyEval_ReleaseThread', '', iptrw);
    RegisterProperty('PyInterpreterState_New', '', iptrw);
    RegisterProperty('PyInterpreterState_Clear', '', iptrw);
    RegisterProperty('PyInterpreterState_Delete', '', iptrw);
    RegisterProperty('PyThreadState_New', '', iptrw);
    RegisterProperty('PyThreadState_Clear', '', iptrw);
    RegisterProperty('PyThreadState_Delete', '', iptrw);
    RegisterProperty('PyThreadState_Get', '', iptrw);
    RegisterProperty('PyThreadState_Swap', '', iptrw);
    RegisterProperty('PyErr_SetInterrupt', '', iptrw);
    RegisterProperty('PyGILState_Ensure', '', iptrw);
    RegisterProperty('PyGILState_Release', '', iptrw);
    RegisterMethod('Function PyParser_SimpleParseString( str : PAnsiChar; start : Integer) : PNode');
    RegisterMethod('Function Py_CompileString( str, filename : PAnsiChar; start : integer) : PPyObject');
    RegisterMethod('Procedure Py_INCREF( op : PPyObject)');
    RegisterMethod('Procedure Py_DECREF( op : PPyObject)');
    RegisterMethod('Procedure Py_XINCREF( op : PPyObject)');
    RegisterMethod('Procedure Py_XDECREF( op : PPyObject)');
    RegisterMethod('Procedure Py_CLEAR( var op : PPyObject)');
    RegisterMethod('Function PyBytes_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyBytes_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyFloat_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyFloat_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyLong_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyLong_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyTuple_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyTuple_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyClass_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyType_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyMethod_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyList_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyList_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyDict_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyDict_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyModule_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyModule_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PySlice_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyFunction_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyIter_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyUnicode_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyUnicode_CheckExact( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyType_IS_GC( t : PPyTypeObject) : Boolean');
    RegisterMethod('Function PyObject_IS_GC( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyWeakref_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyWeakref_CheckRef( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyWeakref_CheckProxy( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyBool_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyEnum_Check( obj : PPyObject) : Boolean');
    RegisterMethod('Function PyObject_TypeCheck( obj : PPyObject; t : PPyTypeObject) : Boolean');
    RegisterMethod('Function Py_InitModule( const md : PyModuleDef) : PPyObject');
    RegisterMethod('Procedure MapDll');
    RegisterProperty('Initialized', 'Boolean', iptr);
    RegisterProperty('Finalizing', 'Boolean', iptr);
    RegisterProperty('MajorVersion', 'integer', iptr);
    RegisterProperty('MinorVersion', 'integer', iptr);
    RegisterProperty('BuiltInModuleName', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDynamicDll(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDynamicDll') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDynamicDll') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure OpenDll( const aDllName : string)');
    RegisterMethod('Function IsHandleValid : Boolean');
    RegisterMethod('Procedure LoadDll');
    RegisterMethod('Procedure UnloadDll');
    RegisterMethod('Procedure Quit');
    RegisterProperty('AutoLoad', 'Boolean', iptrw);
    RegisterProperty('AutoUnload', 'Boolean', iptrw);
    RegisterProperty('DllName', 'string', iptrw);
    RegisterProperty('DllPath', 'string', iptrw);
    RegisterProperty('APIVersion', 'Integer', iptrw);
    RegisterProperty('RegVersion', 'string', iptrw);
    RegisterProperty('FatalAbort', 'Boolean', iptrw);
    RegisterProperty('FatalMsgDlg', 'Boolean', iptrw);
    RegisterProperty('UseLastKnownVersion', 'Boolean', iptrw);
    RegisterProperty('OnAfterLoad', 'TNotifyEvent', iptrw);
    RegisterProperty('OnBeforeLoad', 'TNotifyEvent', iptrw);
    RegisterProperty('OnBeforeUnload', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPythonInputOutput(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TPythonInputOutput') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TPythonInputOutput') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Write( const str : IOString)');
    RegisterMethod('Procedure WriteLine( const str : IOString)');
    RegisterProperty('MaxLines', 'Integer', iptrw);
    RegisterProperty('MaxLineLength', 'Integer', iptrw);
    RegisterProperty('DelayWrites', 'Boolean', iptrw);
    RegisterProperty('OnSendData', 'TSendDataEvent', iptrw);
    RegisterProperty('OnReceiveData', 'TReceiveDataEvent', iptrw);
    RegisterProperty('OnSendUniData', 'TSendUniDataEvent', iptrw);
    RegisterProperty('OnReceiveUniData', 'TReceiveUniDataEvent', iptrw);
    RegisterProperty('UnicodeIO', 'Boolean', iptrw);
    RegisterProperty('RawOutput', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EPySyntaxError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EPyStandardError', 'EPySyntaxError') do
  with CL.AddClassN(CL.FindClass('EPyStandardError'),'EPySyntaxError') do
  begin
    RegisterProperty('EFileName', 'UnicodeString', iptrw);
    RegisterProperty('ELineStr', 'UnicodeString', iptrw);
    RegisterProperty('ELineNumber', 'Integer', iptrw);
    RegisterProperty('EOffset', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EPythonError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EPythonError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EPythonError') do
  begin
    RegisterProperty('EName', 'string', iptrw);
    RegisterProperty('EValue', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EDLLImportError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EDLLImportError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EDLLImportError') do
  begin
    RegisterProperty('WrongFunc', 'AnsiString', iptrw);
    RegisterProperty('ErrorCode', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PythonEngine(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TPythonVersionProp', 'record DllName : string; RegVersion : string; APIVersion : Integer; end');
 CL.AddConstantN('PYT_METHOD_BUFFER_INCREASE','LongInt').SetInt( 10);
 CL.AddConstantN('PYT_MEMBER_BUFFER_INCREASE','LongInt').SetInt( 10);
 CL.AddConstantN('PYT_GETSET_BUFFER_INCREASE','LongInt').SetInt( 10);
 CL.AddConstantN('METH_VARARGS','LongWord').SetUInt( $0001);
 CL.AddConstantN('METH_KEYWORDS','LongWord').SetUInt( $0002);
 CL.AddConstantN('CO_OPTIMIZED','LongWord').SetUInt( $0001);
 CL.AddConstantN('CO_NEWLOCALS','LongWord').SetUInt( $0002);
 CL.AddConstantN('CO_VARARGS','LongWord').SetUInt( $0004);
 CL.AddConstantN('CO_VARKEYWORDS','LongWord').SetUInt( $0008);
 CL.AddConstantN('Py_LT','LongInt').SetInt( 0);
 CL.AddConstantN('Py_LE','LongInt').SetInt( 1);
 CL.AddConstantN('Py_EQ','LongInt').SetInt( 2);
 CL.AddConstantN('Py_NE','LongInt').SetInt( 3);
 CL.AddConstantN('Py_GT','LongInt').SetInt( 4);
 CL.AddConstantN('Py_GE','LongInt').SetInt( 5);
  CL.AddTypeS('TRichComparisonOpcode', '( pyLT, pyLE, pyEQ, pyNE, pyGT, pyGE )');
  CL.AddTypeS('C_Long', 'Integer');
  CL.AddTypeS('C_ULong', 'Cardinal');
  CL.AddTypeS('C_Long', 'NativeInt');
  CL.AddTypeS('C_ULong', 'NativeUInt');
  CL.AddTypeS('TPFlag', '( tpfHeapType, tpfBaseType, tpfReady, tpfReadying, tpf'
   +'HaveGC, tpVectorCall, tpMethodDescriptor, tpHaveVersionTag, tpValidVersion'
   +'Tag, tpIsAbstract, tpLongSubclass, tpListSubClass, tpTupleSubclass, tpByte'
   +'sSubclass, tpBaseExcSubclass, tpTypeSubclass )');
  CL.AddTypeS('TPFlags', 'set of TPFlag');
 CL.AddConstantN('TPFLAGS_DEFAULT','LongInt').Value.ts32 := ord(tpfBaseType) or ord(tpHaveVersionTag);
 CL.AddConstantN('single_input','LongInt').SetInt( 256);
 CL.AddConstantN('file_input','LongInt').SetInt( 257);
 CL.AddConstantN('eval_input','LongInt').SetInt( 258);
 CL.AddConstantN('PyUnicode_WCHAR_KIND','LongInt').SetInt( 0);
 CL.AddConstantN('PyUnicode_1BYTE_KIND','LongInt').SetInt( 1);
 CL.AddConstantN('PyUnicode_2BYTE_KIND','LongInt').SetInt( 2);
 CL.AddConstantN('PyUnicode_4BYTE_KIND','LongInt').SetInt( 4);
 CL.AddConstantN('T_SHORT','LongInt').SetInt( 0);
 CL.AddConstantN('T_INT','LongInt').SetInt( 1);
 CL.AddConstantN('T_LONG','LongInt').SetInt( 2);
 CL.AddConstantN('T_FLOAT','LongInt').SetInt( 3);
 CL.AddConstantN('T_DOUBLE','LongInt').SetInt( 4);
 CL.AddConstantN('T_STRING','LongInt').SetInt( 5);
 CL.AddConstantN('T_OBJECT','LongInt').SetInt( 6);
 CL.AddConstantN('T_CHAR','LongInt').SetInt( 7);
 CL.AddConstantN('T_BYTE','LongInt').SetInt( 8);
 CL.AddConstantN('T_UBYTE','LongInt').SetInt( 9);
 CL.AddConstantN('T_USHORT','LongInt').SetInt( 10);
 CL.AddConstantN('T_UINT','LongInt').SetInt( 11);
 CL.AddConstantN('T_ULONG','LongInt').SetInt( 12);
 CL.AddConstantN('T_STRING_INPLACE','LongInt').SetInt( 13);
 CL.AddConstantN('T_OBJECT_EX','LongInt').SetInt( 16);
 CL.AddConstantN('PY_READONLY','LongInt').SetInt( 1);
 //CL.AddConstantN('RO','').SetString( READONLY);
 CL.AddConstantN('READ_RESTRICTED','LongInt').SetInt( 2);
 CL.AddConstantN('PY_WRITE_RESTRICTED','LongInt').SetInt( 4);
  CL.AddTypeS('TPyMemberType', '( mtShort, mtInt, mtLong, mtFloat, mtDouble, mt'
   +'String, mtObject, mtChar, mtByte, mtUByte, mtUShort, mtUInt, mtULong, mtStringInplace, mtObjectEx )');
  CL.AddTypeS('TPyMemberFlag', '( mfDefault, mfReadOnly, mfReadRestricted, mfWriteRestricted, mfRestricted )');
 CL.AddConstantN('PY_CR','Char').SetString( #13);
 CL.AddConstantN('PY_LF','Char').SetString( #10);
 CL.AddConstantN('PY_TAB','Char').SetString( #09);
  //CL.AddTypeS('PP_frozen', '^P_frozen // will not work');
  //CL.AddTypeS('P_frozen', '^_frozen // will not work');
  //CL.AddTypeS('PPyObject', '^PyObject // will not work');
  //CL.AddTypeS('PPPyObject', '^PPyObject // will not work');
  //CL.AddTypeS('PPPPyObject', '^PPPyObject // will not work');
  //CL.AddTypeS('PPyTypeObject', '^PyTypeObject // will not work');
  //CL.AddTypeS('PPySliceObject', '^PySliceObject // will not work');
//  CL.AddTypeS('binaryfunc', 'integer// will not work');
  (*
  CL.AddTypeS('PyNumberMethods', 'record nb_add : binaryfunc; nb_subtract : bin'
   +'aryfunc; nb_multiply : binaryfunc; nb_remainder : binaryfunc; nb_divmod : '
   +'binaryfunc; nb_power : ternaryfunc; nb_negative : unaryfunc; nb_positive :'
   +' unaryfunc; nb_absolute : unaryfunc; nb_bool : inquiry; nb_invert : unaryf'
   +'unc; nb_lshift : binaryfunc; nb_rshift : binaryfunc; nb_and : binaryfunc; '
   +'nb_xor : binaryfunc; nb_or : binaryfunc; nb_int : unaryfunc; nb_reserved :'
   +' Pointer; nb_float : unaryfunc; nb_inplace_add : binaryfunc; nb_inplace_su'
   +'btract : binaryfunc; nb_inplace_multiply : binaryfunc; nb_inplace_remainde'
   +'r : binaryfunc; nb_inplace_power : ternaryfunc; nb_inplace_lshift : binary'
   +'func; nb_inplace_rshift : binaryfunc; nb_inplace_and : binaryfunc; nb_inpl'
   +'ace_xor : binaryfunc; nb_inplace_or : binaryfunc; nb_floor_divide : binary'
   +'func; nb_true_divide : binaryfunc; nb_inplace_floor_divide : binaryfunc; n'
   +'b_inplace_true_divide : binaryfunc; nb_index : unaryfunc; nb_matrix_multip'
   +'ly : binaryfunc; nb_inplace_matrix_multiply : binaryfunc; end');  //*)
  //CL.AddTypeS('PPyNumberMethods', '^PyNumberMethods // will not work');
 { CL.AddTypeS('PySequenceMethods', 'record sq_length : lenfunc; sq_concat : bin'
   +'aryfunc; sq_repeat : ssizeargfunc; sq_item : ssizeargfunc; was_sq_slice : '
   +'Pointer; sq_ass_item : ssizeobjargproc; was_sq_ass_slice : Pointer; sq_con'
   +'tains : objobjproc; sq_inplace_concat : binaryfunc; sq_inplace_repeat : ssizeargfunc; end');   }
  //CL.AddTypeS('PPySequenceMethods', '^PySequenceMethods // will not work');
  //CL.AddTypeS('PyMappingMethods', 'record mp_length : lenfunc; mp_subscript : b'
  // +'inaryfunc; mp_ass_subscript : objobjargproc; end');
  //CL.AddTypeS('PPyMappingMethods', '^PyMappingMethods // will not work');
  CL.AddTypeS('Py_complex', 'record real : double; imag : double; end');
  //CL.AddTypeS('PyObject', 'record ob_refcnt : NativeInt; ob_type : PPyTypeObject; end');
  //CL.AddTypeS('_frozen', 'record name : PAnsiChar; code : Byte; size : Integer; end');
  //CL.AddTypeS('PySliceObject', 'record ob_refcnt : NativeInt; ob_type : PPyType'
  // +'Object; start : PPyObject; stop : PPyObject; step : PPyObject; end');
  //CL.AddTypeS('PPyMethodDef', '^PyMethodDef // will not work');
  //CL.AddTypeS('PyMethodDef', 'record ml_name : PAnsiChar; ml_meth : PyCFunction'
   //+'; ml_flags : Integer; ml_doc : PAnsiChar; end');
  //CL.AddTypeS('PPyMemberDef', '^PyMemberDef // will not work');
  //CL.AddTypeS('PyMemberDef', 'record name : PAnsiChar; _type : integer; offset '
   //+': NativeInt; flags : integer; doc : PAnsiChar; end');
  //CL.AddTypeS('PPyGetSetDef', '^PyGetSetDef // will not work');
  //CL.AddTypeS('PyGetSetDef', 'record name : PAnsiChar; get : getter; _set : set'
  // +'ter; doc : PAnsiChar; closure : Pointer; end');
  //CL.AddTypeS('pwrapperbase', '^wrapperbase // will not work');
  //CL.AddTypeS('wrapperbase', 'record name : PAnsiChar; wrapper : wrapperfunc; doc : PAnsiChar; end');
  //CL.AddTypeS('PPyDescrObject', '^PyDescrObject // will not work');
  //CL.AddTypeS('PyDescrObject', 'record ob_refcnt : NativeInt; ob_type : PPyType'
   //+'Object; d_type : PPyTypeObject; d_name : PPyObject; end');
  //CL.AddTypeS('PPyMethodDescrObject', '^PyMethodDescrObject // will not work');
 (*
  CL.AddTypeS('PyMethodDescrObject', 'record ob_refcnt : NativeInt; ob_type : P'
   +'PyTypeObject; d_type : PPyTypeObject; d_name : PPyObject; d_method : PPyMethodDef; end');
  CL.AddTypeS('PPyMemberDescrObject', '^PyMemberDescrObject // will not work');
  CL.AddTypeS('PyMemberDescrObject', 'record ob_refcnt : NativeInt; ob_type : P'
   +'PyTypeObject; d_type : PPyTypeObject; d_name : PPyObject; d_member : PPyMemberDef; end');
  //CL.AddTypeS('PPyGetSetDescrObject', '^PyGetSetDescrObject // will not work');
  CL.AddTypeS('PyGetSetDescrObject', 'record ob_refcnt : NativeInt; ob_type : P'
   +'PyTypeObject; d_type : PPyTypeObject; d_name : PPyObject; d_getset : PPyGetSetDef; end');
  //CL.AddTypeS('PPyWrapperDescrObject', '^PyWrapperDescrObject // will not work');
  CL.AddTypeS('PyWrapperDescrObject', 'record ob_refcnt : NativeInt; ob_type : '
   +'PPyTypeObject; d_type : PPyTypeObject; d_name : PPyObject; d_base : pwrapp'
   +'erbase; d_wrapped : Pointer; end');
  //CL.AddTypeS('PPyModuleDef_Base', '^PyModuleDef_Base // will not work');
  CL.AddTypeS('PyModuleDef_Base', 'record ob_refcnt : NativeInt; ob_type : PPyT'
   +'ypeObject; m_index : NativeInt; m_copy : PPyObject; end');
  //CL.AddTypeS('PPyModuleDef', '^PyModuleDef // will not work');
  CL.AddTypeS('PyModuleDef', 'record m_base : PyModuleDef_Base; m_name : PAnsiC'
   +'har; m_doc : PAnsiChar; m_size : NativeInt; m_methods : PPyMethodDef; m_re'
   +'load : inquiry; m_traverse : traverseproc; m_clear : inquiry; m_free : inquiry; end');
  CL.AddTypeS('PyTypeObject', 'record ob_refcnt : NativeInt; ob_type : PPyTypeO'
   +'bject; ob_size : NativeInt; tp_name : PAnsiChar; tp_basicsize : NativeInt;'
   +' tp_itemsize : NativeInt; tp_dealloc : pydestructor; tp_vectorcall_offset '
   +': NativeInt; tp_getattr : getattrfunc; tp_setattr : setattrfunc; tp_as_asy'
   +'nc : Pointer; tp_repr : reprfunc; tp_as_number : PPyNumberMethods; tp_as_s'
   +'equence : PPySequenceMethods; tp_as_mapping : PPyMappingMethods; tp_hash :'
   +' hashfunc; tp_call : ternaryfunc; tp_str : reprfunc; tp_getattro : getattr'
   +'ofunc; tp_setattro : setattrofunc; tp_as_buffer : Pointer; tp_flags : C_UL'
   +'ong; tp_doc : PAnsiChar; tp_traverse : traverseproc; tp_clear : inquiry; t'
   +'p_richcompare : richcmpfunc; tp_weaklistoffset : NativeInt; tp_iter : geti'
   +'terfunc; tp_iternext : iternextfunc; tp_methods : PPyMethodDef; tp_members'
   +' : PPyMemberDef; tp_getset : PPyGetSetDef; tp_base : PPyTypeObject; tp_dic'
   +'t : PPyObject; tp_descr_get : descrgetfunc; tp_descr_set : descrsetfunc; t'
   +'p_dictoffset : NativeInt; tp_init : initproc; tp_alloc : allocfunc; tp_new'
   +' : newfunc; tp_free : pydestructor; tp_is_gc : inquiry; tp_bases : PPyObje'
   +'ct; tp_mro : PPyObject; tp_cache : PPyObject; tp_subclasses : PPyObject; t'
   +'p_weaklist : PPyObject; tp_del : PyDestructor; tp_version_tag : Cardinal; '
   +'tp_finalize : PyDestructor; tp_vectorcall : Pointer; tp_xxx1 : NativeInt; '
   +'tp_xxx2 : NativeInt; tp_xxx3 : NativeInt; tp_xxx4 : NativeInt; tp_xxx5 : N'
   +'ativeInt; tp_xxx6 : NativeInt; tp_xxx7 : NativeInt; tp_xxx8 : NativeInt; t'
   +'p_xxx9 : NativeInt; tp_xxx10 : NativeInt; end');
  CL.AddTypeS('PPyInterpreterState', '__Pointer');
  CL.AddTypeS('PPyThreadState', '__Pointer');
  //CL.AddTypeS('PNode', '^node // will not work');
  CL.AddTypeS('node', 'record n_type : smallint; n_str : PAnsiChar; n_lineno : '
   +'integer; n_col_offset : integer; n_nchildren : integer; n_child : PNode; end');
   *)
  //CL.AddTypeS('PPyCompilerFlags', '^PyCompilerFlags // will not work');
  CL.AddTypeS('PyCompilerFlags', 'record flags : integer; cf_feature_version : integer; end');
 CL.AddConstantN('_PyDateTime_DATE_DATASIZE','LongInt').SetInt( 4);
 CL.AddConstantN('_PyDateTime_TIME_DATASIZE','LongInt').SetInt( 6);
 CL.AddConstantN('_PyDateTime_DATETIME_DATASIZE','LongInt').SetInt( 10);
  (*
  CL.AddTypeS('PyDateTime_Delta', 'record ob_refcnt : NativeInt; ob_type : PPyT'
   +'ypeObject; hashcode : NativeInt; days : Integer; seconds : Integer; microseconds : Integer; end');
  //CL.AddTypeS('PPyDateTime_Delta', '^PyDateTime_Delta // will not work');
  CL.AddTypeS('PyDateTime_TZInfo', 'record ob_refcnt : NativeInt; ob_type : PPyTypeObject; end');
  //CL.AddTypeS('PPyDateTime_TZInfo', '^PyDateTime_TZInfo // will not work');
  CL.AddTypeS('_PyDateTime_BaseTZInfo', 'record ob_refcnt : NativeInt; ob_type '
   +': PPyTypeObject; hashcode : Integer; hastzinfo : Char; end');
  //CL.AddTypeS('_PPyDateTime_BaseTZInfo', '^_PyDateTime_BaseTZInfo // will not work');
  CL.AddTypeS('_PyDateTime_BaseTime', 'record ob_refcnt : NativeInt; ob_type : '
   +'PPyTypeObject; hashcode : Integer; hastzinfo : Char; end');
  //CL.AddTypeS('_PPyDateTime_BaseTime', '^_PyDateTime_BaseTime // will not work');
  CL.AddTypeS('PyDateTime_Time', 'record ob_refcnt : NativeInt; ob_type : PPyTy'
   +'peObject; hashcode : Integer; hastzinfo : Char; tzinfo : PPyObject; end');
  //CL.AddTypeS('PPyDateTime_Time', '^PyDateTime_Time // will not work');
  CL.AddTypeS('PyDateTime_Date', 'record ob_refcnt : NativeInt; ob_type : PPyTy'
   +'peObject; hashcode : Integer; hastzinfo : Char; end');
  //CL.AddTypeS('PPyDateTime_Date', '^PyDateTime_Date // will not work');
  CL.AddTypeS('_PyDateTime_BaseDateTime', 'record ob_refcnt : NativeInt; ob_typ'
   +'e : PPyTypeObject; hashcode : Integer; hastzinfo : Char; end');
  //CL.AddTypeS('_PPyDateTime_BaseDateTime', '^_PyDateTime_BaseDateTime // will not work');
  CL.AddTypeS('PyDateTime_DateTime', 'record ob_refcnt : NativeInt; ob_type : P'
   +'PyTypeObject; hashcode : Integer; hastzinfo : Char; tzinfo : PPyObject; end');
  //CL.AddTypeS('PPyDateTime_DateTime', '^PyDateTime_DateTime // will not work');
  *)
  CL.AddTypeS('PyGILState_STATE', '( PyGILState_LOCKED, PyGILState_UNLOCKED )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EDLLLoadError');
  SIRegister_EDLLImportError(CL);
  SIRegister_EPythonError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyExecError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyStandardError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyArithmeticError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyLookupError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyAssertionError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyAttributeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyEOFError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyFloatingPointError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyEnvironmentError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyIOError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyOSError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyImportError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyIndexError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyKeyError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyKeyboardInterrupt');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyMemoryError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyNameError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyOverflowError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyRuntimeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyNotImplementedError');
  SIRegister_EPySyntaxError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyIndentationError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyTabError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPySystemError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPySystemExit');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyTypeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyUnboundLocalError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyValueError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyUnicodeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'UnicodeEncodeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'UnicodeDecodeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'UnicodeTranslateError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyZeroDivisionError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyStopIteration');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyWarning');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyUserWarning');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyDeprecationWarning');
  CL.AddClassN(CL.FindClass('TOBJECT'),'PendingDeprecationWarning');
  CL.AddClassN(CL.FindClass('TOBJECT'),'FutureWarning');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPySyntaxWarning');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyRuntimeWarning');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyReferenceError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPyWindowsError');
 CL.AddConstantN('kMaxLines','LongInt').SetInt( 1000);
 CL.AddConstantN('kMaxLineLength','LongInt').SetInt( 256);
  CL.AddTypeS('TSendDataEvent', 'Procedure ( Sender : TObject; const Data : AnsiString)');
  CL.AddTypeS('TReceiveDataEvent', 'Procedure ( Sender : TObject; var Data : AnsiString)');
  CL.AddTypeS('TSendUniDataEvent', 'Procedure ( Sender : TObject; const Data : UnicodeString)');
  CL.AddTypeS('TReceiveUniDataEvent', 'Procedure ( Sender : TObject; var Data : UnicodeString)');
  CL.AddTypeS('IOChar', 'WideChar');
  CL.AddTypeS('IOString', 'UnicodeString');
  CL.AddTypeS('TIOStringList', 'TStringList');
  SIRegister_TPythonInputOutput(CL);
  SIRegister_TDynamicDll(CL);
  SIRegister_TPythonInterface(CL);
  CL.AddTypeS('TDatetimeConversionMode', '( dcmToTuple, dcmToDatetime )');
 //CL.AddConstantN('DEFAULT_DATETIME_CONVERSION_MODE','').SetString( dcmToTuple);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEngineClient');
  CL.AddTypeS('TPathInitializationEvent', 'Procedure ( Sender : TObject; var Path : string)');
  //CL.AddTypeS('TSysPathInitEvent', 'Procedure ( Sender : TObject; PathList : PPyObject)');
  CL.AddTypeS('TPythonFlag', '( pfDebug, pfInteractive, pfNoSite, pfOptimize, pfVerbose, pfFrozenFlag, pfIgnoreEnvironmentFlag )');
  CL.AddTypeS('TPythonFlags', 'set of TPythonFlag');
  SIRegister_TTracebackItem(CL);
  SIRegister_TPythonTraceback(CL);
  SIRegister_TPythonEngine(CL);
  SIRegister_TEngineClient(CL);
  //CL.AddTypeS('TDelphiMethod', 'Function ( self, args : PPyObject) : PPyObject');
  //CL.AddTypeS('TDelphiMethodWithKW', 'Function ( self, args, keywords : PPyObject) : PPyObject');
  //CL.AddTypeS('TPythonEvent', 'Procedure ( Sender : TObject; PSelf, Args : TPyObject; var Result : TPyObject)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TMethodsContainer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEventDefs');
  SIRegister_TEventDef(CL);
  SIRegister_TEventDefs(CL);
  SIRegister_TMethodsContainer(CL);
  SIRegister_TMembersContainer(CL);
  SIRegister_TGetSetContainer(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPythonModule');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TErrors');
  CL.AddTypeS('TErrorType', '( etString, etClass )');
  SIRegister_TParentClassError(CL);
  SIRegister_TError(CL);
  SIRegister_TErrors(CL);
  SIRegister_TPythonModule(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPythonType');
  SIRegister_TPyObject(CL);
  //CL.AddTypeS('TPyObjectClass', 'class of TPyObject');
  CL.AddTypeS('TPythonEvent', 'Procedure ( Sender : TObject; PSelf, Args : TPyObject; var Result : TPyObject)');
   CL.AddTypeS('TBasicService', '( pbsGetAttr, pbsSetAttr, pbsRepr, pbsCompa'
   +'re, pbsHash, pbsStr, pbsGetAttrO, pbsSetAttrO, pbsCall, pbsTraverse, pbsClear, pbs'
   +'RichCompare, pbsIter, pbsIterNext )');

  CL.AddTypeS('TBasicServices', 'set of TBasicService)');
  CL.AddTypeS('TNumberService', '( pnsAdd, pnsSubtract, pnsMultiply, pnsRem'
   +'ainder, pnsDivmod, pnsPower, pnsNegative, pnsPositive, pnsAbsolute, pnsInvert, pn'
   +'sLShift, pnsRShift, pnsAnd, pnsXor, pnsOr, pnsInt, pnsFloat, pnsFloorDivide, pnsTr'
   +'ueDivide, pnsMatrixMultiply, pnsBool )');
   CL.AddTypeS('TNumberServices', 'set of TNumberService');
  CL.AddTypeS('TInplaceNumberService', '( pnsInplaceAdd, pnsInplaceSubtra'
   +'ct, pnsInplaceMultiply, pnsInplaceRemainder, pnsInplacePower, pnsInplaceLShift'
   +', pnsInplaceRShift, pnsInplaceAnd, pnsInplaceXor, pnsInplaceOr, pnsInplaceFloor'
   +'Divide, pnsInplaceTrueDivide, pnsInplaceMatrixMultiply )');
   CL.AddTypeS('TInplaceNumberServices', 'set of TInplaceNumberService');

  CL.AddTypeS('TSequenceService', '( pssLength, pssConcat, pssRepeat, pssIt'
   +'em, pssAssItem, pssContains, pssInplaceConcat, pssInplaceRepeat )');   //  *)
   CL.AddTypeS('TSequenceServices', 'set of  TSequenceService)');     //*)
   CL.AddTypeS('TMappingService', '( msLength, msSubscript, msAssSubscript )');
  CL.AddTypeS('TMappingServices', 'set of TMappingService');
  //CL.AddTypeS('TJclEmailReadOptions', 'set of TJclEmailReadOption');
  SIRegister_TTypeServices(CL);
  SIRegister_TPythonType(CL);
  CL.AddTypeS('TGetDataEvent', 'Procedure ( Sender : TObject; var Data : Variant)');
  CL.AddTypeS('TSetDataEvent', 'Procedure ( Sender : TObject; Data : Variant)');
  //CL.AddTypeS('TExtGetDataEvent', 'Procedure ( Sender : TObject; var Data : PPyObject)');
  //CL.AddTypeS('TExtSetDataEvent', 'Procedure ( Sender : TObject; Data : PPyObject)');
  SIRegister_TPythonDelphiVar(CL);
  SIRegister_TPyVar(CL);
  CL.AddTypeS('TThreadExecMode', '( emNewState, emNewInterpreter )');
  SIRegister_TPythonThread(CL);
 {CL.AddDelphiFunction('Function pyio_write( self, args : PPyObject) : PPyObject');
 CL.AddDelphiFunction('Function pyio_read( self, args : PPyObject) : PPyObject');
 CL.AddDelphiFunction('Function pyio_SetDelayWrites( self, args : PPyObject) : PPyObject');
 CL.AddDelphiFunction('Function pyio_SetMaxLines( self, args : PPyObject) : PPyObject');
 CL.AddDelphiFunction('Function pyio_GetTypesStats( self, args : PPyObject) : PPyObject');  }
 CL.AddDelphiFunction('Function GetPythonEngine : TPythonEngine');
 CL.AddDelphiFunction('Function PythonOK : Boolean');
 //CL.AddDelphiFunction('Function PythonToDelphi( obj : PPyObject) : TPyObject');
 //CL.AddDelphiFunction('Function IsDelphiObject( obj : PPyObject) : Boolean');
// CL.AddDelphiFunction('Procedure PyObjectDestructor( pSelf : PPyObject)');
 //CL.AddDelphiFunction('Procedure FreeSubtypeInst( ob : PPyObject)');
 //CL.AddDelphiFunction('Procedure Register');
 //CL.AddDelphiFunction('Function PyType_HasFeature( AType : PPyTypeObject; AFlag : Integer) : Boolean');
 CL.AddDelphiFunction('Function SysVersionFromDLLName( const DLLFileName : string) : string');
 CL.AddDelphiFunction('Procedure PythonVersionFromDLLName( LibName : string; out MajorVersion, MinorVersion : integer)');
 CL.AddDelphiFunction('Function IsPythonVersionRegistered( PythonVersion : string; out InstallPath : string; out AllUserInstall : Boolean) : Boolean');
 CL.AddDelphiFunction('Procedure MaskFPUExceptions( ExceptionsMasked : boolean; MatchPythonPrecision : Boolean)');
 CL.AddDelphiFunction('Function CleanString13( const s : AnsiString; AppendLF : Boolean) : AnsiString;');
 CL.AddDelphiFunction('Function CleanString14( const s : UnicodeString; AppendLF : Boolean) : UnicodeString;');
 CL.AddDelphiFunction('procedure setgPythonEngine(mypyengine: TPythonEngine);');
 CL.AddDelphiFunction('function getgPythonEngine: TPythonEngine;');

 // procedure setgPythonEngine(mypyengine: TPythonEngine);
 // function getgPythonEngine: TPythonEngine;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function CleanString14_P( const s : UnicodeString; AppendLF : Boolean) : UnicodeString;
Begin Result := PythonEngine.CleanString(s, AppendLF); END;

(*----------------------------------------------------------------------------*)
Function CleanString13_P( const s : AnsiString; AppendLF : Boolean) : AnsiString;
Begin Result := PythonEngine.CleanString(s, AppendLF); END;

(*----------------------------------------------------------------------------*)
procedure TPythonThreadThreadExecMode_W(Self: TPythonThread; const T: TThreadExecMode);
begin Self.ThreadExecMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonThreadThreadExecMode_R(Self: TPythonThread; var T: TThreadExecMode);
begin T := Self.ThreadExecMode; end;

(*----------------------------------------------------------------------------*)
procedure TPythonThreadThreadState_R(Self: TPythonThread; var T: PPyThreadState);
begin T := Self.ThreadState; end;

(*----------------------------------------------------------------------------*)
procedure TPyVardv_object_W(Self: TPyVar; const T: PPyObject);
Begin Self.dv_object := T; end;

(*----------------------------------------------------------------------------*)
procedure TPyVardv_object_R(Self: TPyVar; var T: PPyObject);
Begin T := Self.dv_object; end;

(*----------------------------------------------------------------------------*)
procedure TPyVardv_component_W(Self: TPyVar; const T: TPythonDelphiVar);
Begin Self.dv_component := T; end;

(*----------------------------------------------------------------------------*)
procedure TPyVardv_component_R(Self: TPyVar; var T: TPythonDelphiVar);
Begin T := Self.dv_component; end;

(*----------------------------------------------------------------------------*)
procedure TPyVardv_var_W(Self: TPyVar; const T: Variant);
Begin Self.dv_var := T; end;

(*----------------------------------------------------------------------------*)
procedure TPyVardv_var_R(Self: TPyVar; var T: Variant);
Begin T := Self.dv_var; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnChange_W(Self: TPythonDelphiVar; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnChange_R(Self: TPythonDelphiVar; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnExtSetData_W(Self: TPythonDelphiVar; const T: TExtSetDataEvent);
begin Self.OnExtSetData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnExtSetData_R(Self: TPythonDelphiVar; var T: TExtSetDataEvent);
begin T := Self.OnExtSetData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnExtGetData_W(Self: TPythonDelphiVar; const T: TExtGetDataEvent);
begin Self.OnExtGetData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnExtGetData_R(Self: TPythonDelphiVar; var T: TExtGetDataEvent);
begin T := Self.OnExtGetData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnSetData_W(Self: TPythonDelphiVar; const T: TSetDataEvent);
begin Self.OnSetData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnSetData_R(Self: TPythonDelphiVar; var T: TSetDataEvent);
begin T := Self.OnSetData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnGetData_W(Self: TPythonDelphiVar; const T: TGetDataEvent);
begin Self.OnGetData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarOnGetData_R(Self: TPythonDelphiVar; var T: TGetDataEvent);
begin T := Self.OnGetData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarVarName_W(Self: TPythonDelphiVar; const T: AnsiString);
begin Self.VarName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarVarName_R(Self: TPythonDelphiVar; var T: AnsiString);
begin T := Self.VarName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarModule_W(Self: TPythonDelphiVar; const T: AnsiString);
begin Self.Module := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarModule_R(Self: TPythonDelphiVar; var T: AnsiString);
begin T := Self.Module; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarVarObject_W(Self: TPythonDelphiVar; const T: PPyObject);
begin Self.VarObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarVarObject_R(Self: TPythonDelphiVar; var T: PPyObject);
begin T := Self.VarObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarValueAsString_R(Self: TPythonDelphiVar; var T: string);
begin T := Self.ValueAsString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarValueObject_W(Self: TPythonDelphiVar; const T: PPyObject);
begin Self.ValueObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarValueObject_R(Self: TPythonDelphiVar; var T: PPyObject);
begin T := Self.ValueObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarValue_W(Self: TPythonDelphiVar; const T: Variant);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonDelphiVarValue_R(Self: TPythonDelphiVar; var T: Variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeGenerateCreateFunction_W(Self: TPythonType; const T: Boolean);
begin Self.GenerateCreateFunction := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeGenerateCreateFunction_R(Self: TPythonType; var T: Boolean);
begin T := Self.GenerateCreateFunction; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeServices_W(Self: TPythonType; const T: TTypeServices);
begin Self.Services := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeServices_R(Self: TPythonType; var T: TTypeServices);
begin T := Self.Services; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeModule_W(Self: TPythonType; const T: TPythonModule);
begin Self.Module := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeModule_R(Self: TPythonType; var T: TPythonModule);
begin T := Self.Module; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypePrefix_W(Self: TPythonType; const T: AnsiString);
begin Self.Prefix := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypePrefix_R(Self: TPythonType; var T: AnsiString);
begin T := Self.Prefix; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeTypeFlags_W(Self: TPythonType; const T: TPFlags);
begin Self.TypeFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeTypeFlags_R(Self: TPythonType; var T: TPFlags);
begin T := Self.TypeFlags; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeTypeName_W(Self: TPythonType; const T: AnsiString);
begin Self.TypeName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeTypeName_R(Self: TPythonType; var T: AnsiString);
begin T := Self.TypeName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeDocString_W(Self: TPythonType; const T: TStringList);
begin Self.DocString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeDocString_R(Self: TPythonType; var T: TStringList);
begin T := Self.DocString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeDeleteHits_R(Self: TPythonType; var T: Integer);
begin T := Self.DeleteHits; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeCreateHits_R(Self: TPythonType; var T: Integer);
begin T := Self.CreateHits; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeInstanceCount_R(Self: TPythonType; var T: Integer);
begin T := Self.InstanceCount; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypePyObjectClass_W(Self: TPythonType; const T: TPyObjectClass);
begin Self.PyObjectClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypePyObjectClass_R(Self: TPythonType; var T: TPyObjectClass);
begin T := Self.PyObjectClass; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeTheTypePtr_R(Self: TPythonType; var T: PPyTypeObject);
begin T := Self.TheTypePtr; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeTheType_W(Self: TPythonType; const T: PyTypeObject);
begin Self.TheType := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTypeTheType_R(Self: TPythonType; var T: PyTypeObject);
begin T := Self.TheType; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesMapping_W(Self: TTypeServices; const T: TMappingServices);
begin Self.Mapping := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesMapping_R(Self: TTypeServices; var T: TMappingServices);
begin T := Self.Mapping; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesSequence_W(Self: TTypeServices; const T: TSequenceServices);
begin Self.Sequence := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesSequence_R(Self: TTypeServices; var T: TSequenceServices);
begin T := Self.Sequence; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesNumber_W(Self: TTypeServices; const T: TNumberServices);
begin Self.Number := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesNumber_R(Self: TTypeServices; var T: TNumberServices);
begin T := Self.Number; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesInplaceNumber_W(Self: TTypeServices; const T: TInplaceNumberServices);
begin Self.InplaceNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesInplaceNumber_R(Self: TTypeServices; var T: TInplaceNumberServices);
begin T := Self.InplaceNumber; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesBasic_W(Self: TTypeServices; const T: TBasicServices);
begin Self.Basic := T; end;

(*----------------------------------------------------------------------------*)
procedure TTypeServicesBasic_R(Self: TTypeServices; var T: TBasicServices);
begin T := Self.Basic; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectob_type_W(Self: TPyObject; const T: PPyTypeObject);
begin Self.ob_type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectob_type_R(Self: TPyObject; var T: PPyTypeObject);
begin T := Self.ob_type; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectob_refcnt_W(Self: TPyObject; const T: NativeInt);
begin Self.ob_refcnt := T; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectob_refcnt_R(Self: TPyObject; var T: NativeInt);
begin T := Self.ob_refcnt; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectPythonAlloc_W(Self: TPyObject; const T: Boolean);
Begin Self.PythonAlloc := T; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectPythonAlloc_R(Self: TPyObject; var T: Boolean);
Begin T := Self.PythonAlloc; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectIsSubtype_W(Self: TPyObject; const T: Boolean);
Begin Self.IsSubtype := T; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectIsSubtype_R(Self: TPyObject; var T: Boolean);
Begin T := Self.IsSubtype; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectPythonType_W(Self: TPyObject; const T: TPythonType);
Begin Self.PythonType := T; end;

(*----------------------------------------------------------------------------*)
procedure TPyObjectPythonType_R(Self: TPyObject; var T: TPythonType);
Begin T := Self.PythonType; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleOnAfterInitialization_W(Self: TPythonModule; const T: TNotifyEvent);
begin Self.OnAfterInitialization := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleOnAfterInitialization_R(Self: TPythonModule; var T: TNotifyEvent);
begin T := Self.OnAfterInitialization; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleErrors_W(Self: TPythonModule; const T: TErrors);
begin Self.Errors := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleErrors_R(Self: TPythonModule; var T: TErrors);
begin T := Self.Errors; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleModuleName_W(Self: TPythonModule; const T: AnsiString);
begin Self.ModuleName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleModuleName_R(Self: TPythonModule; var T: AnsiString);
begin T := Self.ModuleName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleDocString_W(Self: TPythonModule; const T: TStringList);
begin Self.DocString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleDocString_R(Self: TPythonModule; var T: TStringList);
begin T := Self.DocString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleClientCount_R(Self: TPythonModule; var T: Integer);
begin T := Self.ClientCount; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleClients_R(Self: TPythonModule; var T: TEngineClient; const t1: Integer);
begin T := Self.Clients[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPythonModuleModule_R(Self: TPythonModule; var T: PPyObject);
begin T := Self.Module; end;

(*----------------------------------------------------------------------------*)
procedure TErrorsItems_W(Self: TErrors; const T: TError; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TErrorsItems_R(Self: TErrors; var T: TError; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TErrorParentClass_W(Self: TError; const T: TParentClassError);
begin Self.ParentClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TErrorParentClass_R(Self: TError; var T: TParentClassError);
begin T := Self.ParentClass; end;

(*----------------------------------------------------------------------------*)
procedure TErrorErrorType_W(Self: TError; const T: TErrorType);
begin Self.ErrorType := T; end;

(*----------------------------------------------------------------------------*)
procedure TErrorErrorType_R(Self: TError; var T: TErrorType);
begin T := Self.ErrorType; end;

(*----------------------------------------------------------------------------*)
procedure TErrorText_W(Self: TError; const T: AnsiString);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TErrorText_R(Self: TError; var T: AnsiString);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TErrorName_W(Self: TError; const T: AnsiString);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TErrorName_R(Self: TError; var T: AnsiString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TErrorError_W(Self: TError; const T: PPyObject);
begin Self.Error := T; end;

(*----------------------------------------------------------------------------*)
procedure TErrorError_R(Self: TError; var T: PPyObject);
begin T := Self.Error; end;

(*----------------------------------------------------------------------------*)
procedure TParentClassErrorName_W(Self: TParentClassError; const T: AnsiString);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TParentClassErrorName_R(Self: TParentClassError; var T: AnsiString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TParentClassErrorModule_W(Self: TParentClassError; const T: AnsiString);
begin Self.Module := T; end;

(*----------------------------------------------------------------------------*)
procedure TParentClassErrorModule_R(Self: TParentClassError; var T: AnsiString);
begin T := Self.Module; end;

(*----------------------------------------------------------------------------*)
procedure TGetSetContainerGetSetData_R(Self: TGetSetContainer; var T: PPyGetSetDef);
begin T := Self.GetSetData; end;

(*----------------------------------------------------------------------------*)
procedure TGetSetContainerGetSet_R(Self: TGetSetContainer; var T: PPyGetSetDef; const t1: Integer);
begin T := Self.GetSet[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TGetSetContainerGetSetCount_R(Self: TGetSetContainer; var T: Integer);
begin T := Self.GetSetCount; end;

(*----------------------------------------------------------------------------*)
procedure TMembersContainerMembersData_R(Self: TMembersContainer; var T: PPyMemberDef);
begin T := Self.MembersData; end;

(*----------------------------------------------------------------------------*)
procedure TMembersContainerMembers_R(Self: TMembersContainer; var T: PPyMemberDef; const t1: Integer);
begin T := Self.Members[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMembersContainerMemberCount_R(Self: TMembersContainer; var T: Integer);
begin T := Self.MemberCount; end;

(*----------------------------------------------------------------------------*)
procedure TMethodsContainerEvents_W(Self: TMethodsContainer; const T: TEventDefs);
begin Self.Events := T; end;

(*----------------------------------------------------------------------------*)
procedure TMethodsContainerEvents_R(Self: TMethodsContainer; var T: TEventDefs);
begin T := Self.Events; end;

(*----------------------------------------------------------------------------*)
procedure TMethodsContainerModuleDef_R(Self: TMethodsContainer; var T: PyModuleDef);
begin T := Self.ModuleDef; end;

(*----------------------------------------------------------------------------*)
procedure TMethodsContainerMethodsData_R(Self: TMethodsContainer; var T: PPyMethodDef);
begin T := Self.MethodsData; end;

(*----------------------------------------------------------------------------*)
procedure TMethodsContainerMethods_R(Self: TMethodsContainer; var T: PPyMethodDef; const t1: Integer);
begin T := Self.Methods[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TMethodsContainerMethodCount_R(Self: TMethodsContainer; var T: Integer);
begin T := Self.MethodCount; end;

(*----------------------------------------------------------------------------*)
procedure TEventDefsContainer_R(Self: TEventDefs; var T: TMethodsContainer);
begin T := Self.Container; end;

(*----------------------------------------------------------------------------*)
procedure TEventDefsItems_R(Self: TEventDefs; var T: TEventDef; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TEventDefDocString_W(Self: TEventDef; const T: TStringList);
begin Self.DocString := T; end;

(*----------------------------------------------------------------------------*)
procedure TEventDefDocString_R(Self: TEventDef; var T: TStringList);
begin T := Self.DocString; end;

(*----------------------------------------------------------------------------*)
procedure TEventDefOnExecute_W(Self: TEventDef; const T: TPythonEvent);
begin Self.OnExecute := T; end;

(*----------------------------------------------------------------------------*)
procedure TEventDefOnExecute_R(Self: TEventDef; var T: TPythonEvent);
begin T := Self.OnExecute; end;

(*----------------------------------------------------------------------------*)
procedure TEventDefName_W(Self: TEventDef; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TEventDefName_R(Self: TEventDef; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientOnInitialization_W(Self: TEngineClient; const T: TNotifyEvent);
begin Self.OnInitialization := T; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientOnInitialization_R(Self: TEngineClient; var T: TNotifyEvent);
begin T := Self.OnInitialization; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientOnFinalization_W(Self: TEngineClient; const T: TNotifyEvent);
begin Self.OnFinalization := T; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientOnFinalization_R(Self: TEngineClient; var T: TNotifyEvent);
begin T := Self.OnFinalization; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientOnDestroy_W(Self: TEngineClient; const T: TNotifyEvent);
begin Self.OnDestroy := T; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientOnDestroy_R(Self: TEngineClient; var T: TNotifyEvent);
begin T := Self.OnDestroy; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientOnCreate_W(Self: TEngineClient; const T: TNotifyEvent);
begin Self.OnCreate := T; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientOnCreate_R(Self: TEngineClient; var T: TNotifyEvent);
begin T := Self.OnCreate; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientEngine_W(Self: TEngineClient; const T: TPythonEngine);
begin Self.Engine := T; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientEngine_R(Self: TEngineClient; var T: TPythonEngine);
begin T := Self.Engine; end;

(*----------------------------------------------------------------------------*)
procedure TEngineClientInitialized_R(Self: TEngineClient; var T: Boolean);
begin T := Self.Initialized; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineOnSysPathInit_W(Self: TPythonEngine; const T: TSysPathInitEvent);
begin Self.OnSysPathInit := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineOnSysPathInit_R(Self: TPythonEngine; var T: TSysPathInitEvent);
begin T := Self.OnSysPathInit; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineOnPathInitialization_W(Self: TPythonEngine; const T: TPathInitializationEvent);
begin Self.OnPathInitialization := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineOnPathInitialization_R(Self: TPythonEngine; var T: TPathInitializationEvent);
begin T := Self.OnPathInitialization; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineOnAfterInit_W(Self: TPythonEngine; const T: TNotifyEvent);
begin Self.OnAfterInit := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineOnAfterInit_R(Self: TPythonEngine; var T: TNotifyEvent);
begin T := Self.OnAfterInit; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineUseWindowsConsole_W(Self: TPythonEngine; const T: Boolean);
begin Self.UseWindowsConsole := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineUseWindowsConsole_R(Self: TPythonEngine; var T: Boolean);
begin T := Self.UseWindowsConsole; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineRedirectIO_W(Self: TPythonEngine; const T: Boolean);
begin Self.RedirectIO := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineRedirectIO_R(Self: TPythonEngine; var T: Boolean);
begin T := Self.RedirectIO; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEnginePyFlags_W(Self: TPythonEngine; const T: TPythonFlags);
begin Self.PyFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEnginePyFlags_R(Self: TPythonEngine; var T: TPythonFlags);
begin T := Self.PyFlags; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineIO_W(Self: TPythonEngine; const T: TPythonInputOutput);
begin Self.IO := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineIO_R(Self: TPythonEngine; var T: TPythonInputOutput);
begin T := Self.IO; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineInitThreads_W(Self: TPythonEngine; const T: Boolean);
begin Self.InitThreads := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineInitThreads_R(Self: TPythonEngine; var T: Boolean);
begin T := Self.InitThreads; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineInitScript_W(Self: TPythonEngine; const T: TStrings);
begin Self.InitScript := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineInitScript_R(Self: TPythonEngine; var T: TStrings);
begin T := Self.InitScript; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineDatetimeConversionMode_W(Self: TPythonEngine; const T: TDatetimeConversionMode);
begin Self.DatetimeConversionMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineDatetimeConversionMode_R(Self: TPythonEngine; var T: TDatetimeConversionMode);
begin T := Self.DatetimeConversionMode; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineVenvPythonExe_W(Self: TPythonEngine; const T: string);
begin Self.VenvPythonExe := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineVenvPythonExe_R(Self: TPythonEngine; var T: string);
begin T := Self.VenvPythonExe; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineAutoFinalize_W(Self: TPythonEngine; const T: Boolean);
begin Self.AutoFinalize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineAutoFinalize_R(Self: TPythonEngine; var T: Boolean);
begin T := Self.AutoFinalize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineProgramName_W(Self: TPythonEngine; const T: UnicodeString);
begin Self.ProgramName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineProgramName_R(Self: TPythonEngine; var T: UnicodeString);
begin T := Self.ProgramName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEnginePythonHome_W(Self: TPythonEngine; const T: UnicodeString);
begin Self.PythonHome := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEnginePythonHome_R(Self: TPythonEngine; var T: UnicodeString);
begin T := Self.PythonHome; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineIOPythonModule_R(Self: TPythonEngine; var T: TObject);
begin T := Self.IOPythonModule; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineGlobalVars_W(Self: TPythonEngine; const T: PPyObject);
begin Self.GlobalVars := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineGlobalVars_R(Self: TPythonEngine; var T: PPyObject);
begin T := Self.GlobalVars; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineLocalVars_W(Self: TPythonEngine; const T: PPyObject);
begin Self.LocalVars := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineLocalVars_R(Self: TPythonEngine; var T: PPyObject);
begin T := Self.LocalVars; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineTraceback_R(Self: TPythonEngine; var T: TPythonTraceback);
begin T := Self.Traceback; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineThreadState_R(Self: TPythonEngine; var T: PPyThreadState);
begin T := Self.ThreadState; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineExecModule_W(Self: TPythonEngine; const T: AnsiString);
begin Self.ExecModule := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineExecModule_R(Self: TPythonEngine; var T: AnsiString);
begin T := Self.ExecModule; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineClients_R(Self: TPythonEngine; var T: TEngineClient; const t1: Integer);
begin T := Self.Clients[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPythonEngineClientCount_R(Self: TPythonEngine; var T: Integer);
begin T := Self.ClientCount; end;

(*----------------------------------------------------------------------------*)
Function TPythonEnginePyUnicodeFromString12_P(Self: TPythonEngine;  const AString : AnsiString) : PPyObject;
Begin Result := Self.PyUnicodeFromString(AString); END;

(*----------------------------------------------------------------------------*)
Function TPythonEnginePyUnicodeFromString11_P(Self: TPythonEngine;  const AString : UnicodeString) : PPyObject;
Begin Result := Self.PyUnicodeFromString(AString); END;

(*----------------------------------------------------------------------------*)
Function TPythonEngineEvalStrings10_P(Self: TPythonEngine;  strings : TStrings; locals, globals : PPyObject) : PPyObject;
Begin Result := Self.EvalStrings(strings, locals, globals); END;

(*----------------------------------------------------------------------------*)
Function TPythonEngineEvalString9_P(Self: TPythonEngine;  const command : AnsiString; locals, globals : PPyObject) : PPyObject;
Begin Result := Self.EvalString(command, locals, globals); END;

(*----------------------------------------------------------------------------*)
Procedure TPythonEngineExecStrings8_P(Self: TPythonEngine;  strings : TStrings; locals, globals : PPyObject);
Begin Self.ExecStrings(strings, locals, globals); END;

(*----------------------------------------------------------------------------*)
Procedure TPythonEngineExecString7_P(Self: TPythonEngine;  const command : AnsiString; locals, globals : PPyObject);
Begin Self.ExecString(command, locals, globals); END;

(*----------------------------------------------------------------------------*)
Function TPythonEngineEvalStrings6_P(Self: TPythonEngine;  strings : TStrings) : PPyObject;
Begin Result := Self.EvalStrings(strings); END;

(*----------------------------------------------------------------------------*)
Function TPythonEngineEvalString5_P(Self: TPythonEngine;  const command : AnsiString) : PPyObject;
Begin Result := Self.EvalString(command); END;

(*----------------------------------------------------------------------------*)
Procedure TPythonEngineExecStrings4_P(Self: TPythonEngine;  strings : TStrings);
Begin Self.ExecStrings(strings); END;

(*----------------------------------------------------------------------------*)
Procedure TPythonEngineExecString3_P(Self: TPythonEngine;  const command : AnsiString);
Begin Self.ExecString(command); END;

(*----------------------------------------------------------------------------*)
Function TPythonEngineEncodeString2_P(Self: TPythonEngine;  const str : AnsiString) : AnsiString;
Begin Result := Self.EncodeString(str); END;

(*----------------------------------------------------------------------------*)
Function TPythonEngineEncodeString01_P(Self: TPythonEngine;  const str : UnicodeString) : AnsiString;
Begin Result := Self.EncodeString(str);
END;

(*----------------------------------------------------------------------------*)
Function TPythonEngineEncodeString0_P(Self: TPythonEngine;  const str : UnicodeString) : AnsiString;
Begin Result := Self.EncodeString(str); END;

(*----------------------------------------------------------------------------*)
procedure TPythonTracebackLimit_W(Self: TPythonTraceback; const T: Integer);
begin Self.Limit := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTracebackLimit_R(Self: TPythonTraceback; var T: Integer);
begin T := Self.Limit; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTracebackItems_R(Self: TPythonTraceback; var T: TTracebackItem; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPythonTracebackItemCount_R(Self: TPythonTraceback; var T: Integer);
begin T := Self.ItemCount; end;

(*----------------------------------------------------------------------------*)
procedure TTracebackItemContext_W(Self: TTracebackItem; const T: string);
Begin Self.Context := T; end;

(*----------------------------------------------------------------------------*)
procedure TTracebackItemContext_R(Self: TTracebackItem; var T: string);
Begin T := Self.Context; end;

(*----------------------------------------------------------------------------*)
procedure TTracebackItemLineNo_W(Self: TTracebackItem; const T: Integer);
Begin Self.LineNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TTracebackItemLineNo_R(Self: TTracebackItem; var T: Integer);
Begin T := Self.LineNo; end;

(*----------------------------------------------------------------------------*)
procedure TTracebackItemFileName_W(Self: TTracebackItem; const T: string);
Begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTracebackItemFileName_R(Self: TTracebackItem; var T: string);
Begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfaceBuiltInModuleName_W(Self: TPythonInterface; const T: string);
begin Self.BuiltInModuleName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfaceBuiltInModuleName_R(Self: TPythonInterface; var T: string);
begin T := Self.BuiltInModuleName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfaceMinorVersion_R(Self: TPythonInterface; var T: integer);
begin T := Self.MinorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfaceMajorVersion_R(Self: TPythonInterface; var T: integer);
begin T := Self.MajorVersion; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfaceFinalizing_R(Self: TPythonInterface; var T: Boolean);
begin T := Self.Finalizing; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfaceInitialized_R(Self: TPythonInterface; var T: Boolean);
begin T := Self.Initialized; end;

{
(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyGILState_Release_W(Self: TPythonInterface; const T: );
Begin Self.PyGILState_Release := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyGILState_Release_R(Self: TPythonInterface; var T: );
Begin T := Self.PyGILState_Release; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyGILState_Ensure_W(Self: TPythonInterface; const T: );
Begin Self.PyGILState_Ensure := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyGILState_Ensure_R(Self: TPythonInterface; var T: );
Begin T := Self.PyGILState_Ensure; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetInterrupt_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_SetInterrupt := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetInterrupt_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_SetInterrupt; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_Swap_W(Self: TPythonInterface; const T: );
Begin Self.PyThreadState_Swap := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_Swap_R(Self: TPythonInterface; var T: );
Begin T := Self.PyThreadState_Swap; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_Get_W(Self: TPythonInterface; const T: );
Begin Self.PyThreadState_Get := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_Get_R(Self: TPythonInterface; var T: );
Begin T := Self.PyThreadState_Get; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_Delete_W(Self: TPythonInterface; const T: );
Begin Self.PyThreadState_Delete := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_Delete_R(Self: TPythonInterface; var T: );
Begin T := Self.PyThreadState_Delete; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_Clear_W(Self: TPythonInterface; const T: );
Begin Self.PyThreadState_Clear := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_Clear_R(Self: TPythonInterface; var T: );
Begin T := Self.PyThreadState_Clear; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_New_W(Self: TPythonInterface; const T: );
Begin Self.PyThreadState_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyThreadState_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyInterpreterState_Delete_W(Self: TPythonInterface; const T: );
Begin Self.PyInterpreterState_Delete := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyInterpreterState_Delete_R(Self: TPythonInterface; var T: );
Begin T := Self.PyInterpreterState_Delete; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyInterpreterState_Clear_W(Self: TPythonInterface; const T: );
Begin Self.PyInterpreterState_Clear := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyInterpreterState_Clear_R(Self: TPythonInterface; var T: );
Begin T := Self.PyInterpreterState_Clear; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyInterpreterState_New_W(Self: TPythonInterface; const T: );
Begin Self.PyInterpreterState_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyInterpreterState_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyInterpreterState_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_ReleaseThread_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_ReleaseThread := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_ReleaseThread_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_ReleaseThread; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_AcquireThread_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_AcquireThread := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_AcquireThread_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_AcquireThread; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_ReleaseLock_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_ReleaseLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_ReleaseLock_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_ReleaseLock; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_AcquireLock_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_AcquireLock := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_AcquireLock_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_AcquireLock; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_EndInterpreter_W(Self: TPythonInterface; const T: );
Begin Self.Py_EndInterpreter := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_EndInterpreter_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_EndInterpreter; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_NewInterpreter_W(Self: TPythonInterface; const T: );
Begin Self.Py_NewInterpreter := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_NewInterpreter_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_NewInterpreter; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetProgramFullPath_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetProgramFullPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetProgramFullPath_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetProgramFullPath; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_IsInitialized_W(Self: TPythonInterface; const T: );
Begin Self.Py_IsInitialized := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_IsInitialized_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_IsInitialized; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_SetProgramName_W(Self: TPythonInterface; const T: );
Begin Self.Py_SetProgramName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_SetProgramName_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_SetProgramName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMem_Malloc_W(Self: TPythonInterface; const T: );
Begin Self.PyMem_Malloc := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMem_Malloc_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMem_Malloc; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_NewException_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_NewException := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_NewException_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_NewException; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNode_Free_W(Self: TPythonInterface; const T: );
Begin Self.PyNode_Free := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNode_Free_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNode_Free; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyParser_SimpleParseStringFlags_W(Self: TPythonInterface; const T: );
Begin Self.PyParser_SimpleParseStringFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyParser_SimpleParseStringFlags_R(Self: TPythonInterface; var T: );
Begin T := Self.PyParser_SimpleParseStringFlags; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetProgramName_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetProgramName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetProgramName_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetProgramName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetPrefix_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetPrefix := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetPrefix_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetPrefix; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetPythonHome_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetPythonHome := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetPythonHome_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetPythonHome; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_SetPythonHome_W(Self: TPythonInterface; const T: );
Begin Self.Py_SetPythonHome := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_SetPythonHome_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_SetPythonHome; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetPath_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetPath_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetPath; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetExecPrefix_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetExecPrefix := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetExecPrefix_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetExecPrefix; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetCopyright_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetCopyright := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetCopyright_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetCopyright; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetVersion_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetVersion_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetVersion; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_EvalCode_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_EvalCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_EvalCode_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_EvalCode; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_GivenExceptionMatches_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_GivenExceptionMatches := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_GivenExceptionMatches_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_GivenExceptionMatches; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_ExceptionMatches_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_ExceptionMatches := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_ExceptionMatches_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_ExceptionMatches; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_Finalize_W(Self: TPythonInterface; const T: );
Begin Self.Py_Finalize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_Finalize_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_Finalize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyBytes_Resize_W(Self: TPythonInterface; const T: );
Begin Self._PyBytes_Resize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyBytes_Resize_R(Self: TPythonInterface; var T: );
Begin T := Self._PyBytes_Resize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyObject_New_W(Self: TPythonInterface; const T: );
Begin Self._PyObject_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyObject_New_R(Self: TPythonInterface; var T: );
Begin T := Self._PyObject_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_FatalError_W(Self: TPythonInterface; const T: );
Begin Self.Py_FatalError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_FatalError_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_FatalError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_CompileStringExFlags_W(Self: TPythonInterface; const T: );
Begin Self.Py_CompileStringExFlags := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_CompileStringExFlags_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_CompileStringExFlags; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_AtExit_W(Self: TPythonInterface; const T: );
Begin Self.Py_AtExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_AtExit_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_AtExit; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_SetAsyncExc_W(Self: TPythonInterface; const T: );
Begin Self.PyThreadState_SetAsyncExc := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyThreadState_SetAsyncExc_R(Self: TPythonInterface; var T: );
Begin T := Self.PyThreadState_SetAsyncExc; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBool_FromLong_W(Self: TPythonInterface; const T: );
Begin Self.PyBool_FromLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBool_FromLong_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBool_FromLong; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWrapper_New_W(Self: TPythonInterface; const T: );
Begin Self.PyWrapper_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWrapper_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyWrapper_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWeakref_NewRef_W(Self: TPythonInterface; const T: );
Begin Self.PyWeakref_NewRef := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWeakref_NewRef_R(Self: TPythonInterface; var T: );
Begin T := Self.PyWeakref_NewRef; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWeakref_NewProxy_W(Self: TPythonInterface; const T: );
Begin Self.PyWeakref_NewProxy := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWeakref_NewProxy_R(Self: TPythonInterface; var T: );
Begin T := Self.PyWeakref_NewProxy; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWeakref_GetObject_W(Self: TPythonInterface; const T: );
Begin Self.PyWeakref_GetObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWeakref_GetObject_R(Self: TPythonInterface; var T: );
Begin T := Self.PyWeakref_GetObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_GetSize_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_GetSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_GetSize_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_GetSize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromOrdinal_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_FromOrdinal := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromOrdinal_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_FromOrdinal; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_AsEncodedString_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_AsEncodedString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_AsEncodedString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_AsEncodedString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_DecodeUTF16_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_DecodeUTF16 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_DecodeUTF16_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_DecodeUTF16; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_Decode_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_Decode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_Decode_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_Decode; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_AsUTF8AndSize_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_AsUTF8AndSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_AsUTF8AndSize_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_AsUTF8AndSize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_AsUTF8_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_AsUTF8 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_AsUTF8_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_AsUTF8; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_AsWideChar_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_AsWideChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_AsWideChar_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_AsWideChar; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromKindAndData_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_FromKindAndData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromKindAndData_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_FromKindAndData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromStringAndSize_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_FromStringAndSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromStringAndSize_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_FromStringAndSize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromString_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_FromString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_FromString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromWideChar_W(Self: TPythonInterface; const T: );
Begin Self.PyUnicode_FromWideChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_FromWideChar_R(Self: TPythonInterface; var T: );
Begin T := Self.PyUnicode_FromWideChar; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_Ready_W(Self: TPythonInterface; const T: );
Begin Self.PyType_Ready := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_Ready_R(Self: TPythonInterface; var T: );
Begin T := Self.PyType_Ready; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_GenericNew_W(Self: TPythonInterface; const T: );
Begin Self.PyType_GenericNew := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_GenericNew_R(Self: TPythonInterface; var T: );
Begin T := Self.PyType_GenericNew; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_GenericAlloc_W(Self: TPythonInterface; const T: );
Begin Self.PyType_GenericAlloc := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_GenericAlloc_R(Self: TPythonInterface; var T: );
Begin T := Self.PyType_GenericAlloc; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_IsSubtype_W(Self: TPythonInterface; const T: );
Begin Self.PyType_IsSubtype := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_IsSubtype_R(Self: TPythonInterface; var T: );
Begin T := Self.PyType_IsSubtype; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_Size_W(Self: TPythonInterface; const T: );
Begin Self.PyTuple_Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_Size_R(Self: TPythonInterface; var T: );
Begin T := Self.PyTuple_Size; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_SetItem_W(Self: TPythonInterface; const T: );
Begin Self.PyTuple_SetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_SetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyTuple_SetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_New_W(Self: TPythonInterface; const T: );
Begin Self.PyTuple_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyTuple_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_GetSlice_W(Self: TPythonInterface; const T: );
Begin Self.PyTuple_GetSlice := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_GetSlice_R(Self: TPythonInterface; var T: );
Begin T := Self.PyTuple_GetSlice; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_GetItem_W(Self: TPythonInterface; const T: );
Begin Self.PyTuple_GetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_GetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyTuple_GetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTraceBack_Print_W(Self: TPythonInterface; const T: );
Begin Self.PyTraceBack_Print := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTraceBack_Print_R(Self: TPythonInterface; var T: );
Begin T := Self.PyTraceBack_Print; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTraceBack_Here_W(Self: TPythonInterface; const T: );
Begin Self.PyTraceBack_Here := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTraceBack_Here_R(Self: TPythonInterface; var T: );
Begin T := Self.PyTraceBack_Here; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySys_SetPath_W(Self: TPythonInterface; const T: );
Begin Self.PySys_SetPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySys_SetPath_R(Self: TPythonInterface; var T: );
Begin T := Self.PySys_SetPath; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySys_SetObject_W(Self: TPythonInterface; const T: );
Begin Self.PySys_SetObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySys_SetObject_R(Self: TPythonInterface; var T: );
Begin T := Self.PySys_SetObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySys_GetObject_W(Self: TPythonInterface; const T: );
Begin Self.PySys_GetObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySys_GetObject_R(Self: TPythonInterface; var T: );
Begin T := Self.PySys_GetObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_Repr_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_Repr := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_Repr_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_Repr; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_DecodeEscape_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_DecodeEscape := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_DecodeEscape_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_DecodeEscape; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_Size_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_Size_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_Size; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_FromStringAndSize_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_FromStringAndSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_FromStringAndSize_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_FromStringAndSize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_FromString_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_FromString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_FromString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_FromString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_ConcatAndDel_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_ConcatAndDel := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_ConcatAndDel_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_ConcatAndDel; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_Concat_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_Concat := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_Concat_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_Concat; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySlice_New_W(Self: TPythonInterface; const T: );
Begin Self.PySlice_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySlice_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PySlice_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySlice_GetIndicesEx_W(Self: TPythonInterface; const T: );
Begin Self.PySlice_GetIndicesEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySlice_GetIndicesEx_R(Self: TPythonInterface; var T: );
Begin T := Self.PySlice_GetIndicesEx; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySlice_GetIndices_W(Self: TPythonInterface; const T: );
Begin Self.PySlice_GetIndices := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySlice_GetIndices_R(Self: TPythonInterface; var T: );
Begin T := Self.PySlice_GetIndices; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySeqIter_New_W(Self: TPythonInterface; const T: );
Begin Self.PySeqIter_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySeqIter_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PySeqIter_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_List_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_List := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_List_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_List; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Contains_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_Contains := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Contains_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_Contains; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Tuple_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_Tuple := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Tuple_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_Tuple; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_DelSlice_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_DelSlice := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_DelSlice_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_DelSlice; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_SetSlice_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_SetSlice := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_SetSlice_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_SetSlice; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_SetItem_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_SetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_SetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_SetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Repeat_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_Repeat := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Repeat_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_Repeat; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Length_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_Length := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Length_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_Length; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Index_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_Index := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Index_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_Index; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_In_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_In := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_In_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_In; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_GetSlice_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_GetSlice := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_GetSlice_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_GetSlice; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_GetItem_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_GetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_GetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_GetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Count_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Count_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_Count; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Concat_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_Concat := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Concat_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_Concat; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Check_W(Self: TPythonInterface; const T: );
Begin Self.PySequence_Check := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySequence_Check_R(Self: TPythonInterface; var T: );
Begin T := Self.PySequence_Check; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_UnTrack_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GC_UnTrack := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_UnTrack_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GC_UnTrack; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_Track_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GC_Track := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_Track_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GC_Track; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_Del_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GC_Del := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_Del_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GC_Del; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_Resize_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GC_Resize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_Resize_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GC_Resize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_NewVar_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GC_NewVar := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_NewVar_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GC_NewVar; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_New_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GC_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GC_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_Malloc_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GC_Malloc := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GC_Malloc_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GC_Malloc; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GenericSetAttr_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GenericSetAttr := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GenericSetAttr_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GenericSetAttr; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GenericGetAttr_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GenericGetAttr := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GenericGetAttr_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GenericGetAttr; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Call_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_Call := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Call_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_Call; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_IsSubclass_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_IsSubclass := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_IsSubclass_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_IsSubclass; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_IsInstance_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_IsInstance := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_IsInstance_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_IsInstance; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyIter_Next_W(Self: TPythonInterface; const T: );
Begin Self.PyIter_Next := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyIter_Next_R(Self: TPythonInterface; var T: );
Begin T := Self.PyIter_Next; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GetIter_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GetIter := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GetIter_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GetIter; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Free_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_Free := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Free_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_Free; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_NewVar_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_NewVar := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_NewVar_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_NewVar; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_New_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_InitVar_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_InitVar := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_InitVar_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_InitVar; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Init_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_Init := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Init_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_Init; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_SetItem_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_SetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_SetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_SetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_SetAttrString_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_SetAttrString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_SetAttrString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_SetAttrString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_SetAttr_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_SetAttr := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_SetAttr_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_SetAttr; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Repr_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_Repr := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Repr_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_Repr; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Length_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_Length := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Length_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_Length; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_IsTrue_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_IsTrue := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_IsTrue_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_IsTrue; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Hash_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_Hash := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Hash_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_Hash; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_HasAttrString_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_HasAttrString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_HasAttrString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_HasAttrString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_DelItem_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_DelItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_DelItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_DelItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GetItem_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GetAttrString_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GetAttrString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GetAttrString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GetAttrString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GetAttr_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_GetAttr := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_GetAttr_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_GetAttr; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_RichCompareBool_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_RichCompareBool := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_RichCompareBool_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_RichCompareBool; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_RichCompare_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_RichCompare := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_RichCompare_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_RichCompare; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_CallObject_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_CallObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_CallObject_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_CallObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyOS_InterruptOccurred_W(Self: TPythonInterface; const T: );
Begin Self.PyOS_InterruptOccurred := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyOS_InterruptOccurred_R(Self: TPythonInterface; var T: );
Begin T := Self.PyOS_InterruptOccurred; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Xor_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Xor := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Xor_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Xor; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Subtract_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Subtract := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Subtract_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Subtract; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Rshift_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Rshift := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Rshift_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Rshift; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Remainder_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Remainder := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Remainder_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Remainder; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Power_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Power := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Power_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Power; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Positive_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Positive := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Positive_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Positive; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Or_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Or := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Or_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Or; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Negative_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Negative := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Negative_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Negative; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Multiply_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Multiply := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Multiply_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Multiply; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Lshift_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Lshift := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Lshift_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Lshift; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Long_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Long := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Long_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Long; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Invert_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Invert := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Invert_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Invert; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Float_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Float := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Float_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Float; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Divmod_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Divmod := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Divmod_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Divmod; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_TrueDivide_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_TrueDivide := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_TrueDivide_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_TrueDivide; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_FloorDivide_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_FloorDivide := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_FloorDivide_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_FloorDivide; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Check_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Check := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Check_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Check; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_And_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_And := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_And_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_And; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Add_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Add := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Add_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Add; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Absolute_W(Self: TPythonInterface; const T: );
Begin Self.PyNumber_Absolute := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyNumber_Absolute_R(Self: TPythonInterface; var T: );
Begin T := Self.PyNumber_Absolute; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_New_W(Self: TPythonInterface; const T: );
Begin Self.PyModule_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyModule_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_GetName_W(Self: TPythonInterface; const T: );
Begin Self.PyModule_GetName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_GetName_R(Self: TPythonInterface; var T: );
Begin T := Self.PyModule_GetName; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMethod_Self_W(Self: TPythonInterface; const T: );
Begin Self.PyMethod_Self := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMethod_Self_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMethod_Self; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMethod_New_W(Self: TPythonInterface; const T: );
Begin Self.PyMethod_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMethod_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMethod_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMethod_Function_W(Self: TPythonInterface; const T: );
Begin Self.PyMethod_Function := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMethod_Function_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMethod_Function; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_SetItemString_W(Self: TPythonInterface; const T: );
Begin Self.PyMapping_SetItemString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_SetItemString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMapping_SetItemString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_Length_W(Self: TPythonInterface; const T: );
Begin Self.PyMapping_Length := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_Length_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMapping_Length; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_HasKeyString_W(Self: TPythonInterface; const T: );
Begin Self.PyMapping_HasKeyString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_HasKeyString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMapping_HasKeyString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_HasKey_W(Self: TPythonInterface; const T: );
Begin Self.PyMapping_HasKey := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_HasKey_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMapping_HasKey; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_GetItemString_W(Self: TPythonInterface; const T: );
Begin Self.PyMapping_GetItemString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_GetItemString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMapping_GetItemString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_Check_W(Self: TPythonInterface; const T: );
Begin Self.PyMapping_Check := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMapping_Check_R(Self: TPythonInterface; var T: );
Begin T := Self.PyMapping_Check; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromVoidPtr_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_FromVoidPtr := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromVoidPtr_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_FromVoidPtr; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_AsLongLong_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_AsLongLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_AsLongLong_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_AsLongLong; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromUnsignedLongLong_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_FromUnsignedLongLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromUnsignedLongLong_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_FromUnsignedLongLong; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromLongLong_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_FromLongLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromLongLong_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_FromLongLong; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromUnicodeObject_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_FromUnicodeObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromUnicodeObject_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_FromUnicodeObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_AsUnsignedLong_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_AsUnsignedLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_AsUnsignedLong_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_AsUnsignedLong; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromUnsignedLong_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_FromUnsignedLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromUnsignedLong_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_FromUnsignedLong; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromString_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_FromString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_FromString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromLong_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_FromLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromLong_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_FromLong; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromDouble_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_FromDouble := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_FromDouble_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_FromDouble; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_AsLong_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_AsLong := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_AsLong_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_AsLong; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_AsDouble_W(Self: TPythonInterface; const T: );
Begin Self.PyLong_AsDouble := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_AsDouble_R(Self: TPythonInterface; var T: );
Begin T := Self.PyLong_AsDouble; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Sort_W(Self: TPythonInterface; const T: );
Begin Self.PyList_Sort := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Sort_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_Sort; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Size_W(Self: TPythonInterface; const T: );
Begin Self.PyList_Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Size_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_Size; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_SetSlice_W(Self: TPythonInterface; const T: );
Begin Self.PyList_SetSlice := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_SetSlice_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_SetSlice; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_SetItem_W(Self: TPythonInterface; const T: );
Begin Self.PyList_SetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_SetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_SetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Reverse_W(Self: TPythonInterface; const T: );
Begin Self.PyList_Reverse := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Reverse_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_Reverse; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_New_W(Self: TPythonInterface; const T: );
Begin Self.PyList_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Insert_W(Self: TPythonInterface; const T: );
Begin Self.PyList_Insert := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Insert_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_Insert; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_GetSlice_W(Self: TPythonInterface; const T: );
Begin Self.PyList_GetSlice := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_GetSlice_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_GetSlice; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_GetItem_W(Self: TPythonInterface; const T: );
Begin Self.PyList_GetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_GetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_GetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_AsTuple_W(Self: TPythonInterface; const T: );
Begin Self.PyList_AsTuple := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_AsTuple_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_AsTuple; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Append_W(Self: TPythonInterface; const T: );
Begin Self.PyList_Append := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Append_R(Self: TPythonInterface; var T: );
Begin T := Self.PyList_Append; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_ReloadModule_W(Self: TPythonInterface; const T: );
Begin Self.PyImport_ReloadModule := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_ReloadModule_R(Self: TPythonInterface; var T: );
Begin T := Self.PyImport_ReloadModule; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_Import_W(Self: TPythonInterface; const T: );
Begin Self.PyImport_Import := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_Import_R(Self: TPythonInterface; var T: );
Begin T := Self.PyImport_Import; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_ImportModule_W(Self: TPythonInterface; const T: );
Begin Self.PyImport_ImportModule := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_ImportModule_R(Self: TPythonInterface; var T: );
Begin T := Self.PyImport_ImportModule; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_ImportFrozenModule_W(Self: TPythonInterface; const T: );
Begin Self.PyImport_ImportFrozenModule := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_ImportFrozenModule_R(Self: TPythonInterface; var T: );
Begin T := Self.PyImport_ImportFrozenModule; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_GetMagicNumber_W(Self: TPythonInterface; const T: );
Begin Self.PyImport_GetMagicNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_GetMagicNumber_R(Self: TPythonInterface; var T: );
Begin T := Self.PyImport_GetMagicNumber; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_AddModule_W(Self: TPythonInterface; const T: );
Begin Self.PyImport_AddModule := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_AddModule_R(Self: TPythonInterface; var T: );
Begin T := Self.PyImport_AddModule; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFunction_New_W(Self: TPythonInterface; const T: );
Begin Self.PyFunction_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFunction_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFunction_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFunction_GetGlobals_W(Self: TPythonInterface; const T: );
Begin Self.PyFunction_GetGlobals := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFunction_GetGlobals_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFunction_GetGlobals; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFunction_GetCode_W(Self: TPythonInterface; const T: );
Begin Self.PyFunction_GetCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFunction_GetCode_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFunction_GetCode; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFloat_FromString_W(Self: TPythonInterface; const T: );
Begin Self.PyFloat_FromString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFloat_FromString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFloat_FromString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFloat_FromDouble_W(Self: TPythonInterface; const T: );
Begin Self.PyFloat_FromDouble := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFloat_FromDouble_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFloat_FromDouble; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFloat_AsDouble_W(Self: TPythonInterface; const T: );
Begin Self.PyFloat_AsDouble := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFloat_AsDouble_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFloat_AsDouble; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFile_WriteString_W(Self: TPythonInterface; const T: );
Begin Self.PyFile_WriteString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFile_WriteString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFile_WriteString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFile_WriteObject_W(Self: TPythonInterface; const T: );
Begin Self.PyFile_WriteObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFile_WriteObject_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFile_WriteObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFile_GetLine_W(Self: TPythonInterface; const T: );
Begin Self.PyFile_GetLine := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFile_GetLine_R(Self: TPythonInterface; var T: );
Begin T := Self.PyFile_GetLine; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_SaveThread_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_SaveThread := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_SaveThread_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_SaveThread; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_RestoreThread_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_RestoreThread := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_RestoreThread_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_RestoreThread; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_InitThreads_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_InitThreads := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_InitThreads_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_InitThreads; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_GetLocals_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_GetLocals := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_GetLocals_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_GetLocals; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_GetGlobals_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_GetGlobals := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_GetGlobals_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_GetGlobals; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_GetFrame_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_GetFrame := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_GetFrame_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_GetFrame; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_CallObjectWithKeywords_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_CallObjectWithKeywords := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_CallObjectWithKeywords_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_CallObjectWithKeywords; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCFunction_NewEx_W(Self: TPythonInterface; const T: );
Begin Self.PyCFunction_NewEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCFunction_NewEx_R(Self: TPythonInterface; var T: );
Begin T := Self.PyCFunction_NewEx; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySys_SetArgv_W(Self: TPythonInterface; const T: );
Begin Self.PySys_SetArgv := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySys_SetArgv_R(Self: TPythonInterface; var T: );
Begin T := Self.PySys_SetArgv; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_AsStringAndSize_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_AsStringAndSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_AsStringAndSize_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_AsStringAndSize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_AsString_W(Self: TPythonInterface; const T: );
Begin Self.PyBytes_AsString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_AsString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyBytes_AsString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyRun_SimpleString_W(Self: TPythonInterface; const T: );
Begin Self.PyRun_SimpleString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyRun_SimpleString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyRun_SimpleString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyRun_String_W(Self: TPythonInterface; const T: );
Begin Self.PyRun_String := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyRun_String_R(Self: TPythonInterface; var T: );
Begin T := Self.PyRun_String; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Str_W(Self: TPythonInterface; const T: );
Begin Self.PyObject_Str := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Str_R(Self: TPythonInterface; var T: );
Begin T := Self.PyObject_Str; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_GetDict_W(Self: TPythonInterface; const T: );
Begin Self.PyModule_GetDict := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_GetDict_R(Self: TPythonInterface; var T: );
Begin T := Self.PyModule_GetDict; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDictProxy_New_W(Self: TPythonInterface; const T: );
Begin Self.PyDictProxy_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDictProxy_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDictProxy_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_SetItemString_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_SetItemString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_SetItemString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_SetItemString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_GetItemString_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_GetItemString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_GetItemString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_GetItemString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_New_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_New := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_New_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_New; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_DelItemString_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_DelItemString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_DelItemString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_DelItemString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Update_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_Update := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Update_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_Update; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Size_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Size_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_Size; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Items_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_Items := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Items_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_Items; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Values_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_Values := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Values_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_Values; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Keys_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_Keys := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Keys_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_Keys; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Next_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_Next := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Next_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_Next; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Clear_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_Clear := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Clear_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_Clear; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_DelItem_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_DelItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_DelItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_DelItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_SetItem_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_SetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_SetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_SetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_GetItem_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_GetItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_GetItem_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_GetItem; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Copy_W(Self: TPythonInterface; const T: );
Begin Self.PyDict_Copy := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Copy_R(Self: TPythonInterface; var T: );
Begin T := Self.PyDict_Copy; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_GetBuiltins_W(Self: TPythonInterface; const T: );
Begin Self.PyEval_GetBuiltins := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEval_GetBuiltins_R(Self: TPythonInterface; var T: );
Begin T := Self.PyEval_GetBuiltins; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_Exit_W(Self: TPythonInterface; const T: );
Begin Self.Py_Exit := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_Exit_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_Exit; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_Initialize_W(Self: TPythonInterface; const T: );
Begin Self.Py_Initialize := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_Initialize_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_Initialize; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_BuildValue_W(Self: TPythonInterface; const T: TPy_BuildValue);
Begin Self.Py_BuildValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_BuildValue_R(Self: TPythonInterface; var T: TPy_BuildValue);
Begin T := Self.Py_BuildValue; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyArg_ParseTupleAndKeywords_W(Self: TPythonInterface; const T: TPyArg_ParseTupleAndKeywords);
Begin Self.PyArg_ParseTupleAndKeywords := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyArg_ParseTupleAndKeywords_R(Self: TPythonInterface; var T: TPyArg_ParseTupleAndKeywords);
Begin T := Self.PyArg_ParseTupleAndKeywords; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyArg_ParseTuple_W(Self: TPythonInterface; const T: TPyArg_Parse);
Begin Self.PyArg_ParseTuple := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyArg_ParseTuple_R(Self: TPythonInterface; var T: TPyArg_Parse);
Begin T := Self.PyArg_ParseTuple; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyArg_Parse_W(Self: TPythonInterface; const T: TPyArg_Parse);
Begin Self.PyArg_Parse := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyArg_Parse_R(Self: TPythonInterface; var T: TPyArg_Parse);
Begin T := Self.PyArg_Parse; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_GetModuleDict_W(Self: TPythonInterface; const T: );
Begin Self.PyImport_GetModuleDict := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_GetModuleDict_R(Self: TPythonInterface; var T: );
Begin T := Self.PyImport_GetModuleDict; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_WarnExplicit_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_WarnExplicit := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_WarnExplicit_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_WarnExplicit; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_WarnEx_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_WarnEx := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_WarnEx_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_WarnEx; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetString_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_SetString := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetString_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_SetString; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetObject_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_SetObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetObject_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_SetObject; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetNone_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_SetNone := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetNone_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_SetNone; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetFromErrno_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_SetFromErrno := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_SetFromErrno_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_SetFromErrno; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Restore_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_Restore := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Restore_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_Restore; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Print_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_Print := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Print_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_Print; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Occurred_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_Occurred := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Occurred_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_Occurred; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_NoMemory_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_NoMemory := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_NoMemory_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_NoMemory; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Fetch_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_Fetch := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Fetch_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_Fetch; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Clear_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_Clear := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_Clear_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_Clear; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_CheckSignals_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_CheckSignals := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_CheckSignals_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_CheckSignals; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_BadInternalCall_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_BadInternalCall := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_BadInternalCall_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_BadInternalCall; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_BadArgument_W(Self: TPythonInterface; const T: );
Begin Self.PyErr_BadArgument := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyErr_BadArgument_R(Self: TPythonInterface; var T: );
Begin T := Self.PyErr_BadArgument; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_Create2_W(Self: TPythonInterface; const T: );
Begin Self.PyModule_Create2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_Create2_R(Self: TPythonInterface; var T: );
Begin T := Self.PyModule_Create2; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCallable_Check_W(Self: TPythonInterface; const T: );
Begin Self.PyCallable_Check := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCallable_Check_R(Self: TPythonInterface; var T: );
Begin T := Self.PyCallable_Check; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCFunction_GetSelf_W(Self: TPythonInterface; const T: );
Begin Self.PyCFunction_GetSelf := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCFunction_GetSelf_R(Self: TPythonInterface; var T: );
Begin T := Self.PyCFunction_GetSelf; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCFunction_GetFunction_W(Self: TPythonInterface; const T: );
Begin Self.PyCFunction_GetFunction := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCFunction_GetFunction_R(Self: TPythonInterface; var T: );
Begin T := Self.PyCFunction_GetFunction; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_AsCComplex_W(Self: TPythonInterface; const T: );
Begin Self.PyComplex_AsCComplex := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_AsCComplex_R(Self: TPythonInterface; var T: );
Begin T := Self.PyComplex_AsCComplex; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_ImagAsDouble_W(Self: TPythonInterface; const T: );
Begin Self.PyComplex_ImagAsDouble := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_ImagAsDouble_R(Self: TPythonInterface; var T: );
Begin T := Self.PyComplex_ImagAsDouble; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_RealAsDouble_W(Self: TPythonInterface; const T: );
Begin Self.PyComplex_RealAsDouble := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_RealAsDouble_R(Self: TPythonInterface; var T: );
Begin T := Self.PyComplex_RealAsDouble; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_FromDoubles_W(Self: TPythonInterface; const T: );
Begin Self.PyComplex_FromDoubles := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_FromDoubles_R(Self: TPythonInterface; var T: );
Begin T := Self.PyComplex_FromDoubles; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_FromCComplex_W(Self: TPythonInterface; const T: );
Begin Self.PyComplex_FromCComplex := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_FromCComplex_R(Self: TPythonInterface; var T: );
Begin T := Self.PyComplex_FromCComplex; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_ExecCodeModule_W(Self: TPythonInterface; const T: );
Begin Self.PyImport_ExecCodeModule := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_ExecCodeModule_R(Self: TPythonInterface; var T: );
Begin T := Self.PyImport_ExecCodeModule; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetBuildInfo_W(Self: TPythonInterface; const T: );
Begin Self.Py_GetBuildInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_GetBuildInfo_R(Self: TPythonInterface; var T: );
Begin T := Self.Py_GetBuildInfo; end;

}

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEnum_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyEnum_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyEnum_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyEnum_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBool_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyBool_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBool_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyBool_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyWeakref_CallableProxyType_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self._PyWeakref_CallableProxyType := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyWeakref_CallableProxyType_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self._PyWeakref_CallableProxyType; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyWeakref_ProxyType_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self._PyWeakref_ProxyType := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyWeakref_ProxyType_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self._PyWeakref_ProxyType; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyWeakref_RefType_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self._PyWeakref_RefType := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterface_PyWeakref_RefType_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self._PyWeakref_RefType; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWrapperDescr_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyWrapperDescr_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyWrapperDescr_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyWrapperDescr_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyUnicode_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyUnicode_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyUnicode_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTraceBack_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyTraceBack_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTraceBack_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyTraceBack_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySuper_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PySuper_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySuper_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PySuper_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyStaticMethod_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyStaticMethod_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyStaticMethod_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyStaticMethod_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySeqIter_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PySeqIter_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySeqIter_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PySeqIter_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyProperty_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyProperty_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyProperty_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyProperty_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyClassMethod_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyClassMethod_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyClassMethod_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyClassMethod_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCell_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyCell_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCell_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyCell_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCallIter_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyCallIter_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCallIter_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyCallIter_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBaseObject_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyBaseObject_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBaseObject_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyBaseObject_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyTuple_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyTuple_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyTuple_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyBytes_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyBytes_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyBytes_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySlice_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PySlice_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePySlice_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PySlice_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyRange_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyRange_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyRange_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyRange_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyObject_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyObject_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyObject_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyModule_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyModule_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyModule_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMethod_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyMethod_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyMethod_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyMethod_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyLong_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyLong_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyLong_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyList_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyList_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyList_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFunction_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyFunction_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFunction_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyFunction_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFrame_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyFrame_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFrame_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyFrame_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFloat_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyFloat_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyFloat_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyFloat_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyDict_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyDict_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyDict_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyComplex_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyComplex_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyComplex_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCFunction_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyCFunction_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCFunction_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyCFunction_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyType_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyType_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyType_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCode_Type_W(Self: TPythonInterface; const T: PPyTypeObject);
Begin Self.PyCode_Type := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyCode_Type_R(Self: TPythonInterface; var T: PPyTypeObject);
Begin T := Self.PyCode_Type; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnicodeTranslateError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_UnicodeTranslateError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnicodeTranslateError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_UnicodeTranslateError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnicodeEncodeError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_UnicodeEncodeError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnicodeEncodeError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_UnicodeEncodeError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnicodeDecodeError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_UnicodeDecodeError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnicodeDecodeError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_UnicodeDecodeError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_PendingDeprecationWarning_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_PendingDeprecationWarning := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_PendingDeprecationWarning_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_PendingDeprecationWarning; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_FutureWarning_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_FutureWarning := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_FutureWarning_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_FutureWarning; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_StopIteration_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_StopIteration := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_StopIteration_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_StopIteration; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ReferenceError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_ReferenceError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ReferenceError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_ReferenceError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UserWarning_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_UserWarning := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UserWarning_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_UserWarning; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_SyntaxWarning_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_SyntaxWarning := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_SyntaxWarning_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_SyntaxWarning; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_RuntimeWarning_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_RuntimeWarning := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_RuntimeWarning_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_RuntimeWarning; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_DeprecationWarning_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_DeprecationWarning := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_DeprecationWarning_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_DeprecationWarning; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_Warning_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_Warning := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_Warning_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_Warning; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_WindowsError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_WindowsError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_WindowsError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_WindowsError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnicodeError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_UnicodeError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnicodeError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_UnicodeError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnboundLocalError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_UnboundLocalError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_UnboundLocalError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_UnboundLocalError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_TabError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_TabError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_TabError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_TabError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_OSError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_OSError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_OSError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_OSError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_NotImplementedError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_NotImplementedError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_NotImplementedError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_NotImplementedError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_IndentationError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_IndentationError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_IndentationError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_IndentationError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_EnvironmentError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_EnvironmentError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_EnvironmentError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_EnvironmentError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_AssertionError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_AssertionError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_AssertionError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_AssertionError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_LookupError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_LookupError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_LookupError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_LookupError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_FloatingPointError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_FloatingPointError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_FloatingPointError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_FloatingPointError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_Exception_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_Exception := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_Exception_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_Exception; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ArithmeticError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_ArithmeticError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ArithmeticError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_ArithmeticError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ZeroDivisionError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_ZeroDivisionError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ZeroDivisionError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_ZeroDivisionError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ValueError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_ValueError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ValueError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_ValueError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_TypeError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_TypeError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_TypeError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_TypeError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_SystemExit_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_SystemExit := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_SystemExit_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_SystemExit; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_SystemError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_SystemError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_SystemError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_SystemError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_SyntaxError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_SyntaxError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_SyntaxError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_SyntaxError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_RuntimeError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_RuntimeError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_RuntimeError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_RuntimeError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_OverflowError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_OverflowError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_OverflowError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_OverflowError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_NameError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_NameError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_NameError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_NameError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_MemoryError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_MemoryError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_MemoryError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_MemoryError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_KeyboardInterrupt_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_KeyboardInterrupt := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_KeyboardInterrupt_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_KeyboardInterrupt; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_KeyError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_KeyError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_KeyError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_KeyError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_IndexError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_IndexError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_IndexError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_IndexError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ImportError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_ImportError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_ImportError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_ImportError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_IOError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_IOError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_IOError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_IOError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_EOFError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_EOFError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_EOFError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_EOFError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_AttributeError_W(Self: TPythonInterface; const T: PPPyObject);
Begin Self.PyExc_AttributeError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyExc_AttributeError_R(Self: TPythonInterface; var T: PPPyObject);
Begin T := Self.PyExc_AttributeError; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_NotImplemented_W(Self: TPythonInterface; const T: PPyObject);
Begin Self.Py_NotImplemented := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_NotImplemented_R(Self: TPythonInterface; var T: PPyObject);
Begin T := Self.Py_NotImplemented; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_True_W(Self: TPythonInterface; const T: PPyObject);
Begin Self.Py_True := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_True_R(Self: TPythonInterface; var T: PPyObject);
Begin T := Self.Py_True; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_False_W(Self: TPythonInterface; const T: PPyObject);
Begin Self.Py_False := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_False_R(Self: TPythonInterface; var T: PPyObject);
Begin T := Self.Py_False; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_Ellipsis_W(Self: TPythonInterface; const T: PPyObject);
Begin Self.Py_Ellipsis := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_Ellipsis_R(Self: TPythonInterface; var T: PPyObject);
Begin T := Self.Py_Ellipsis; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_None_W(Self: TPythonInterface; const T: PPyObject);
Begin Self.Py_None := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_None_R(Self: TPythonInterface; var T: PPyObject);
Begin T := Self.Py_None; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_FrozenModules_W(Self: TPythonInterface; const T: PP_frozen);
Begin Self.PyImport_FrozenModules := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePyImport_FrozenModules_R(Self: TPythonInterface; var T: PP_frozen);
Begin T := Self.PyImport_FrozenModules; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_IgnoreEnvironmentFlag_W(Self: TPythonInterface; const T: PInteger);
Begin Self.Py_IgnoreEnvironmentFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_IgnoreEnvironmentFlag_R(Self: TPythonInterface; var T: PInteger);
Begin T := Self.Py_IgnoreEnvironmentFlag; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_FrozenFlag_W(Self: TPythonInterface; const T: PInteger);
Begin Self.Py_FrozenFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_FrozenFlag_R(Self: TPythonInterface; var T: PInteger);
Begin T := Self.Py_FrozenFlag; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_NoSiteFlag_W(Self: TPythonInterface; const T: PInteger);
Begin Self.Py_NoSiteFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_NoSiteFlag_R(Self: TPythonInterface; var T: PInteger);
Begin T := Self.Py_NoSiteFlag; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_OptimizeFlag_W(Self: TPythonInterface; const T: PInteger);
Begin Self.Py_OptimizeFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_OptimizeFlag_R(Self: TPythonInterface; var T: PInteger);
Begin T := Self.Py_OptimizeFlag; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_InteractiveFlag_W(Self: TPythonInterface; const T: PInteger);
Begin Self.Py_InteractiveFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_InteractiveFlag_R(Self: TPythonInterface; var T: PInteger);
Begin T := Self.Py_InteractiveFlag; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_VerboseFlag_W(Self: TPythonInterface; const T: PInteger);
Begin Self.Py_VerboseFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_VerboseFlag_R(Self: TPythonInterface; var T: PInteger);
Begin T := Self.Py_VerboseFlag; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_DebugFlag_W(Self: TPythonInterface; const T: PInteger);
Begin Self.Py_DebugFlag := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInterfacePy_DebugFlag_R(Self: TPythonInterface; var T: PInteger);
Begin T := Self.Py_DebugFlag; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllOnBeforeUnload_W(Self: TDynamicDll; const T: TNotifyEvent);
begin Self.OnBeforeUnload := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllOnBeforeUnload_R(Self: TDynamicDll; var T: TNotifyEvent);
begin T := Self.OnBeforeUnload; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllOnBeforeLoad_W(Self: TDynamicDll; const T: TNotifyEvent);
begin Self.OnBeforeLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllOnBeforeLoad_R(Self: TDynamicDll; var T: TNotifyEvent);
begin T := Self.OnBeforeLoad; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllOnAfterLoad_W(Self: TDynamicDll; const T: TNotifyEvent);
begin Self.OnAfterLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllOnAfterLoad_R(Self: TDynamicDll; var T: TNotifyEvent);
begin T := Self.OnAfterLoad; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllUseLastKnownVersion_W(Self: TDynamicDll; const T: Boolean);
begin Self.UseLastKnownVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllUseLastKnownVersion_R(Self: TDynamicDll; var T: Boolean);
begin T := Self.UseLastKnownVersion; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllFatalMsgDlg_W(Self: TDynamicDll; const T: Boolean);
begin Self.FatalMsgDlg := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllFatalMsgDlg_R(Self: TDynamicDll; var T: Boolean);
begin T := Self.FatalMsgDlg; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllFatalAbort_W(Self: TDynamicDll; const T: Boolean);
begin Self.FatalAbort := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllFatalAbort_R(Self: TDynamicDll; var T: Boolean);
begin T := Self.FatalAbort; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllRegVersion_W(Self: TDynamicDll; const T: string);
begin Self.RegVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllRegVersion_R(Self: TDynamicDll; var T: string);
begin T := Self.RegVersion; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllAPIVersion_W(Self: TDynamicDll; const T: Integer);
begin Self.APIVersion := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllAPIVersion_R(Self: TDynamicDll; var T: Integer);
begin T := Self.APIVersion; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllDllPath_W(Self: TDynamicDll; const T: string);
begin Self.DllPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllDllPath_R(Self: TDynamicDll; var T: string);
begin T := Self.DllPath; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllDllName_W(Self: TDynamicDll; const T: string);
begin Self.DllName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllDllName_R(Self: TDynamicDll; var T: string);
begin T := Self.DllName; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllAutoUnload_W(Self: TDynamicDll; const T: Boolean);
begin Self.AutoUnload := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllAutoUnload_R(Self: TDynamicDll; var T: Boolean);
begin T := Self.AutoUnload; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllAutoLoad_W(Self: TDynamicDll; const T: Boolean);
begin Self.AutoLoad := T; end;

(*----------------------------------------------------------------------------*)
procedure TDynamicDllAutoLoad_R(Self: TDynamicDll; var T: Boolean);
begin T := Self.AutoLoad; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputRawOutput_W(Self: TPythonInputOutput; const T: Boolean);
begin Self.RawOutput := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputRawOutput_R(Self: TPythonInputOutput; var T: Boolean);
begin T := Self.RawOutput; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputUnicodeIO_W(Self: TPythonInputOutput; const T: Boolean);
begin Self.UnicodeIO := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputUnicodeIO_R(Self: TPythonInputOutput; var T: Boolean);
begin T := Self.UnicodeIO; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputOnReceiveUniData_W(Self: TPythonInputOutput; const T: TReceiveUniDataEvent);
begin Self.OnReceiveUniData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputOnReceiveUniData_R(Self: TPythonInputOutput; var T: TReceiveUniDataEvent);
begin T := Self.OnReceiveUniData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputOnSendUniData_W(Self: TPythonInputOutput; const T: TSendUniDataEvent);
begin Self.OnSendUniData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputOnSendUniData_R(Self: TPythonInputOutput; var T: TSendUniDataEvent);
begin T := Self.OnSendUniData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputOnReceiveData_W(Self: TPythonInputOutput; const T: TReceiveDataEvent);
begin Self.OnReceiveData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputOnReceiveData_R(Self: TPythonInputOutput; var T: TReceiveDataEvent);
begin T := Self.OnReceiveData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputOnSendData_W(Self: TPythonInputOutput; const T: TSendDataEvent);
begin Self.OnSendData := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputOnSendData_R(Self: TPythonInputOutput; var T: TSendDataEvent);
begin T := Self.OnSendData; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputDelayWrites_W(Self: TPythonInputOutput; const T: Boolean);
begin Self.DelayWrites := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputDelayWrites_R(Self: TPythonInputOutput; var T: Boolean);
begin T := Self.DelayWrites; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputMaxLineLength_W(Self: TPythonInputOutput; const T: Integer);
begin Self.MaxLineLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputMaxLineLength_R(Self: TPythonInputOutput; var T: Integer);
begin T := Self.MaxLineLength; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputMaxLines_W(Self: TPythonInputOutput; const T: Integer);
begin Self.MaxLines := T; end;

(*----------------------------------------------------------------------------*)
procedure TPythonInputOutputMaxLines_R(Self: TPythonInputOutput; var T: Integer);
begin T := Self.MaxLines; end;

(*----------------------------------------------------------------------------*)
procedure EPySyntaxErrorEOffset_W(Self: EPySyntaxError; const T: Integer);
Begin Self.EOffset := T; end;

(*----------------------------------------------------------------------------*)
procedure EPySyntaxErrorEOffset_R(Self: EPySyntaxError; var T: Integer);
Begin T := Self.EOffset; end;

(*----------------------------------------------------------------------------*)
procedure EPySyntaxErrorELineNumber_W(Self: EPySyntaxError; const T: Integer);
Begin Self.ELineNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure EPySyntaxErrorELineNumber_R(Self: EPySyntaxError; var T: Integer);
Begin T := Self.ELineNumber; end;

(*----------------------------------------------------------------------------*)
procedure EPySyntaxErrorELineStr_W(Self: EPySyntaxError; const T: UnicodeString);
Begin Self.ELineStr := T; end;

(*----------------------------------------------------------------------------*)
procedure EPySyntaxErrorELineStr_R(Self: EPySyntaxError; var T: UnicodeString);
Begin T := Self.ELineStr; end;

(*----------------------------------------------------------------------------*)
procedure EPySyntaxErrorEFileName_W(Self: EPySyntaxError; const T: UnicodeString);
Begin Self.EFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure EPySyntaxErrorEFileName_R(Self: EPySyntaxError; var T: UnicodeString);
Begin T := Self.EFileName; end;

(*----------------------------------------------------------------------------*)
procedure EPythonErrorEValue_W(Self: EPythonError; const T: string);
Begin Self.EValue := T; end;

(*----------------------------------------------------------------------------*)
procedure EPythonErrorEValue_R(Self: EPythonError; var T: string);
Begin T := Self.EValue; end;

(*----------------------------------------------------------------------------*)
procedure EPythonErrorEName_W(Self: EPythonError; const T: string);
Begin Self.EName := T; end;

(*----------------------------------------------------------------------------*)
procedure EPythonErrorEName_R(Self: EPythonError; var T: string);
Begin T := Self.EName; end;

(*----------------------------------------------------------------------------*)
procedure EDLLImportErrorErrorCode_W(Self: EDLLImportError; const T: Integer);
Begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EDLLImportErrorErrorCode_R(Self: EDLLImportError; var T: Integer);
Begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure EDLLImportErrorWrongFunc_W(Self: EDLLImportError; const T: AnsiString);
Begin Self.WrongFunc := T; end;

(*----------------------------------------------------------------------------*)
procedure EDLLImportErrorWrongFunc_R(Self: EDLLImportError; var T: AnsiString);
Begin T := Self.WrongFunc; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PythonEngine_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@pyio_write, 'pyio_write', CdCdecl);
 S.RegisterDelphiFunction(@pyio_read, 'pyio_read', CdCdecl);
 S.RegisterDelphiFunction(@pyio_SetDelayWrites, 'pyio_SetDelayWrites', CdCdecl);
 S.RegisterDelphiFunction(@pyio_SetMaxLines, 'pyio_SetMaxLines', CdCdecl);
 S.RegisterDelphiFunction(@pyio_GetTypesStats, 'pyio_GetTypesStats', CdCdecl);
 S.RegisterDelphiFunction(@GetPythonEngine, 'GetPythonEngine', cdRegister);
 S.RegisterDelphiFunction(@PythonOK, 'PythonOK', cdRegister);
 S.RegisterDelphiFunction(@PythonToDelphi, 'PythonToDelphi', cdRegister);
 S.RegisterDelphiFunction(@IsDelphiObject, 'IsDelphiObject', cdRegister);
 S.RegisterDelphiFunction(@PyObjectDestructor, 'PyObjectDestructor', CdCdecl);
 S.RegisterDelphiFunction(@FreeSubtypeInst, 'FreeSubtypeInst', CdCdecl);
 S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
 S.RegisterDelphiFunction(@PyType_HasFeature, 'PyType_HasFeature', cdRegister);
 S.RegisterDelphiFunction(@SysVersionFromDLLName, 'SysVersionFromDLLName', cdRegister);
 S.RegisterDelphiFunction(@PythonVersionFromDLLName, 'PythonVersionFromDLLName', cdRegister);
 S.RegisterDelphiFunction(@IsPythonVersionRegistered, 'IsPythonVersionRegistered', cdRegister);
 S.RegisterDelphiFunction(@MaskFPUExceptions, 'MaskFPUExceptions', cdRegister);
 S.RegisterDelphiFunction(@CleanString13_P, 'CleanString13', cdRegister);
 S.RegisterDelphiFunction(@CleanString14_P, 'CleanString14', cdRegister);
 S.RegisterDelphiFunction(@setgPythonEngine, 'setgPythonEngine', cdRegister);
 S.RegisterDelphiFunction(@getgPythonEngine, 'getgPythonEngine', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonThread) do
  begin
    RegisterMethod(@TPythonThread.Py_Begin_Allow_Threads, 'Py_Begin_Allow_Threads');
    RegisterMethod(@TPythonThread.Py_End_Allow_Threads, 'Py_End_Allow_Threads');
    RegisterMethod(@TPythonThread.Py_Begin_Block_Threads, 'Py_Begin_Block_Threads');
    RegisterMethod(@TPythonThread.Py_Begin_Unblock_Threads, 'Py_Begin_Unblock_Threads');
    RegisterPropertyHelper(@TPythonThreadThreadState_R,nil,'ThreadState');
    RegisterPropertyHelper(@TPythonThreadThreadExecMode_R,@TPythonThreadThreadExecMode_W,'ThreadExecMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPyVar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPyVar) do begin
  RegisterConstructor(@TPyVar.Create, 'Create');
    RegisterPropertyHelper(@TPyVardv_var_R,@TPyVardv_var_W,'dv_var');
    RegisterPropertyHelper(@TPyVardv_component_R,@TPyVardv_component_W,'dv_component');
    RegisterPropertyHelper(@TPyVardv_object_R,@TPyVardv_object_W,'dv_object');
    RegisterMethod(@TPyVar.GetValue, 'GetValue');
    RegisterMethod(@TPyVar.GetValueAsVariant, 'GetValueAsVariant');
    RegisterMethod(@TPyVar.SetValue, 'SetValue');
    RegisterMethod(@TPyVar.SetValueFromVariant, 'SetValueFromVariant');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonDelphiVar(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonDelphiVar) do
  begin
    RegisterMethod(@TPythonDelphiVar.IsVariantOk, 'IsVariantOk');
    RegisterPropertyHelper(@TPythonDelphiVarValue_R,@TPythonDelphiVarValue_W,'Value');
    RegisterPropertyHelper(@TPythonDelphiVarValueObject_R,@TPythonDelphiVarValueObject_W,'ValueObject');
    RegisterPropertyHelper(@TPythonDelphiVarValueAsString_R,nil,'ValueAsString');
    RegisterPropertyHelper(@TPythonDelphiVarVarObject_R,@TPythonDelphiVarVarObject_W,'VarObject');
    RegisterPropertyHelper(@TPythonDelphiVarModule_R,@TPythonDelphiVarModule_W,'Module');
    RegisterPropertyHelper(@TPythonDelphiVarVarName_R,@TPythonDelphiVarVarName_W,'VarName');
    RegisterPropertyHelper(@TPythonDelphiVarOnGetData_R,@TPythonDelphiVarOnGetData_W,'OnGetData');
    RegisterPropertyHelper(@TPythonDelphiVarOnSetData_R,@TPythonDelphiVarOnSetData_W,'OnSetData');
    RegisterPropertyHelper(@TPythonDelphiVarOnExtGetData_R,@TPythonDelphiVarOnExtGetData_W,'OnExtGetData');
    RegisterPropertyHelper(@TPythonDelphiVarOnExtSetData_R,@TPythonDelphiVarOnExtSetData_W,'OnExtSetData');
    RegisterPropertyHelper(@TPythonDelphiVarOnChange_R,@TPythonDelphiVarOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonType) do begin
  RegisterConstructor(@TPythonType.Create, 'Create');
   RegisterMethod(@TPythonType.Destroy, 'Free');
    RegisterMethod(@TPythonType.CreateInstance, 'CreateInstance');
    RegisterMethod(@TPythonType.CreateInstanceWith, 'CreateInstanceWith');
    RegisterMethod(@TPythonType.AddTypeVar, 'AddTypeVar');
    RegisterPropertyHelper(@TPythonTypeTheType_R,@TPythonTypeTheType_W,'TheType');
    RegisterPropertyHelper(@TPythonTypeTheTypePtr_R,nil,'TheTypePtr');
    RegisterPropertyHelper(@TPythonTypePyObjectClass_R,@TPythonTypePyObjectClass_W,'PyObjectClass');
    RegisterPropertyHelper(@TPythonTypeInstanceCount_R,nil,'InstanceCount');
    RegisterPropertyHelper(@TPythonTypeCreateHits_R,nil,'CreateHits');
    RegisterPropertyHelper(@TPythonTypeDeleteHits_R,nil,'DeleteHits');
    RegisterPropertyHelper(@TPythonTypeDocString_R,@TPythonTypeDocString_W,'DocString');
    RegisterPropertyHelper(@TPythonTypeTypeName_R,@TPythonTypeTypeName_W,'TypeName');
    RegisterPropertyHelper(@TPythonTypeTypeFlags_R,@TPythonTypeTypeFlags_W,'TypeFlags');
    RegisterPropertyHelper(@TPythonTypePrefix_R,@TPythonTypePrefix_W,'Prefix');
    RegisterPropertyHelper(@TPythonTypeModule_R,@TPythonTypeModule_W,'Module');
    RegisterPropertyHelper(@TPythonTypeServices_R,@TPythonTypeServices_W,'Services');
    RegisterPropertyHelper(@TPythonTypeGenerateCreateFunction_R,@TPythonTypeGenerateCreateFunction_W,'GenerateCreateFunction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTypeServices(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTypeServices) do
  begin
    RegisterConstructor(@TTypeServices.Create, 'Create');
    RegisterPropertyHelper(@TTypeServicesBasic_R,@TTypeServicesBasic_W,'Basic');
    RegisterPropertyHelper(@TTypeServicesInplaceNumber_R,@TTypeServicesInplaceNumber_W,'InplaceNumber');
    RegisterPropertyHelper(@TTypeServicesNumber_R,@TTypeServicesNumber_W,'Number');
    RegisterPropertyHelper(@TTypeServicesSequence_R,@TTypeServicesSequence_W,'Sequence');
    RegisterPropertyHelper(@TTypeServicesMapping_R,@TTypeServicesMapping_W,'Mapping');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPyObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPyObject) do
  begin
    RegisterPropertyHelper(@TPyObjectPythonType_R,@TPyObjectPythonType_W,'PythonType');
    RegisterPropertyHelper(@TPyObjectIsSubtype_R,@TPyObjectIsSubtype_W,'IsSubtype');
    RegisterPropertyHelper(@TPyObjectPythonAlloc_R,@TPyObjectPythonAlloc_W,'PythonAlloc');
    RegisterVirtualConstructor(@TPyObject.Create, 'Create');
    RegisterVirtualConstructor(@TPyObject.CreateWith, 'CreateWith');
    RegisterMethod(@TPyObject.Destroy, 'Free');
    RegisterMethod(@TPyObject.GetSelf, 'GetSelf');
    RegisterMethod(@TPyObject.IncRef, 'IncRef');
    RegisterMethod(@TPyObject.Adjust, 'Adjust');
    RegisterMethod(@TPyObject.GetModule, 'GetModule');
    RegisterPropertyHelper(@TPyObjectob_refcnt_R,@TPyObjectob_refcnt_W,'ob_refcnt');
    RegisterPropertyHelper(@TPyObjectob_type_R,@TPyObjectob_type_W,'ob_type');
    RegisterVirtualMethod(@TPyObject.Print, 'Print');
    RegisterVirtualMethod(@TPyObject.GetAttr, 'GetAttr');
    RegisterVirtualMethod(@TPyObject.SetAttr, 'SetAttr');
    RegisterVirtualMethod(@TPyObject.Repr, 'Repr');
    RegisterVirtualMethod(@TPyObject.Compare, 'Compare');
    RegisterVirtualMethod(@TPyObject.Hash, 'Hash');
    RegisterVirtualMethod(@TPyObject.Str, 'Str');
    RegisterVirtualMethod(@TPyObject.GetAttrO, 'GetAttrO');
    RegisterVirtualMethod(@TPyObject.SetAttrO, 'SetAttrO');
    RegisterVirtualMethod(@TPyObject.Call, 'Call');
    RegisterVirtualMethod(@TPyObject.Traverse, 'Traverse');
    RegisterVirtualMethod(@TPyObject.Clear, 'Clear');
    RegisterVirtualMethod(@TPyObject.RichCompare, 'RichCompare');
    RegisterVirtualMethod(@TPyObject.Iter, 'Iter');
    RegisterVirtualMethod(@TPyObject.IterNext, 'IterNext');
    RegisterVirtualMethod(@TPyObject.Init, 'Init');
    RegisterVirtualMethod(@TPyObject.NbAdd, 'NbAdd');
    RegisterVirtualMethod(@TPyObject.NbSubtract, 'NbSubtract');
    RegisterVirtualMethod(@TPyObject.NbMultiply, 'NbMultiply');
    RegisterVirtualMethod(@TPyObject.NbFloorDivide, 'NbFloorDivide');
    RegisterVirtualMethod(@TPyObject.NbTrueDivide, 'NbTrueDivide');
    RegisterVirtualMethod(@TPyObject.NbMatrixMultiply, 'NbMatrixMultiply');
    RegisterVirtualMethod(@TPyObject.NbRemainder, 'NbRemainder');
    RegisterVirtualMethod(@TPyObject.NbDivmod, 'NbDivmod');
    RegisterVirtualMethod(@TPyObject.NbPower, 'NbPower');
    RegisterVirtualMethod(@TPyObject.NbNegative, 'NbNegative');
    RegisterVirtualMethod(@TPyObject.NbPositive, 'NbPositive');
    RegisterVirtualMethod(@TPyObject.NbAbsolute, 'NbAbsolute');
    RegisterVirtualMethod(@TPyObject.NbBool, 'NbBool');
    RegisterVirtualMethod(@TPyObject.NbInvert, 'NbInvert');
    RegisterVirtualMethod(@TPyObject.NbLShift, 'NbLShift');
    RegisterVirtualMethod(@TPyObject.NbRShift, 'NbRShift');
    RegisterVirtualMethod(@TPyObject.NbAnd, 'NbAnd');
    RegisterVirtualMethod(@TPyObject.NbXor, 'NbXor');
    RegisterVirtualMethod(@TPyObject.NbOr, 'NbOr');
    RegisterVirtualMethod(@TPyObject.NbInt, 'NbInt');
    RegisterVirtualMethod(@TPyObject.NbFloat, 'NbFloat');
    RegisterVirtualMethod(@TPyObject.NbInplaceAdd, 'NbInplaceAdd');
    RegisterVirtualMethod(@TPyObject.NbInplaceSubtract, 'NbInplaceSubtract');
    RegisterVirtualMethod(@TPyObject.NbInplaceMultiply, 'NbInplaceMultiply');
    RegisterVirtualMethod(@TPyObject.NbInplaceDivide, 'NbInplaceDivide');
    RegisterVirtualMethod(@TPyObject.NbInplaceFloorDivide, 'NbInplaceFloorDivide');
    RegisterVirtualMethod(@TPyObject.NbInplaceTrueDivide, 'NbInplaceTrueDivide');
    RegisterVirtualMethod(@TPyObject.NbInplaceRemainder, 'NbInplaceRemainder');
    RegisterVirtualMethod(@TPyObject.NbInplacePower, 'NbInplacePower');
    RegisterVirtualMethod(@TPyObject.NbInplaceLshift, 'NbInplaceLshift');
    RegisterVirtualMethod(@TPyObject.NbInplaceRshift, 'NbInplaceRshift');
    RegisterVirtualMethod(@TPyObject.NbInplaceAnd, 'NbInplaceAnd');
    RegisterVirtualMethod(@TPyObject.NbInplaceXor, 'NbInplaceXor');
    RegisterVirtualMethod(@TPyObject.NbInplaceOr, 'NbInplaceOr');
    RegisterVirtualMethod(@TPyObject.NbInplaceMatrixMultiply, 'NbInplaceMatrixMultiply');
    RegisterVirtualMethod(@TPyObject.SqLength, 'SqLength');
    RegisterVirtualMethod(@TPyObject.SqConcat, 'SqConcat');
    RegisterVirtualMethod(@TPyObject.SqRepeat, 'SqRepeat');
    RegisterVirtualMethod(@TPyObject.SqItem, 'SqItem');
    RegisterVirtualMethod(@TPyObject.SqAssItem, 'SqAssItem');
    RegisterVirtualMethod(@TPyObject.SqContains, 'SqContains');
    RegisterVirtualMethod(@TPyObject.SqInplaceConcat, 'SqInplaceConcat');
    RegisterVirtualMethod(@TPyObject.SqInplaceRepeat, 'SqInplaceRepeat');
    RegisterVirtualMethod(@TPyObject.MpLength, 'MpLength');
    RegisterVirtualMethod(@TPyObject.MpSubscript, 'MpSubscript');
    RegisterVirtualMethod(@TPyObject.MpAssSubscript, 'MpAssSubscript');
    RegisterVirtualMethod(@TPyObject.RegisterMethods, 'RegisterMethods');
    RegisterVirtualMethod(@TPyObject.RegisterMembers, 'RegisterMembers');
    RegisterVirtualMethod(@TPyObject.RegisterGetSets, 'RegisterGetSets');
    RegisterVirtualMethod(@TPyObject.SetupType, 'SetupType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonModule(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonModule) do
  begin
    RegisterConstructor(@TPythonModule.Create, 'Create');
    RegisterMethod(@TPythonModule.Destroy, 'Free');
    RegisterMethod(@TPythonModule.MakeModule, 'MakeModule');
    RegisterMethod(@TPythonModule.DefineDocString, 'DefineDocString');
    RegisterMethod(@TPythonModule.Initialize, 'Initialize');
    RegisterMethod(@TPythonModule.InitializeForNewInterpreter, 'InitializeForNewInterpreter');
    RegisterMethod(@TPythonModule.AddClient, 'AddClient');
    RegisterMethod(@TPythonModule.ErrorByName, 'ErrorByName');
    RegisterMethod(@TPythonModule.RaiseError, 'RaiseError');
    RegisterMethod(@TPythonModule.RaiseErrorFmt, 'RaiseErrorFmt');
    RegisterMethod(@TPythonModule.RaiseErrorObj, 'RaiseErrorObj');
    RegisterMethod(@TPythonModule.BuildErrors, 'BuildErrors');
    RegisterMethod(@TPythonModule.SetVar, 'SetVar');
    RegisterMethod(@TPythonModule.GetVar, 'GetVar');
    RegisterMethod(@TPythonModule.DeleteVar, 'DeleteVar');
    RegisterMethod(@TPythonModule.ClearVars, 'ClearVars');
    RegisterMethod(@TPythonModule.SetVarFromVariant, 'SetVarFromVariant');
    RegisterMethod(@TPythonModule.GetVarAsVariant, 'GetVarAsVariant');
    RegisterPropertyHelper(@TPythonModuleModule_R,nil,'Module');
    RegisterPropertyHelper(@TPythonModuleClients_R,nil,'Clients');
    RegisterPropertyHelper(@TPythonModuleClientCount_R,nil,'ClientCount');
    RegisterPropertyHelper(@TPythonModuleDocString_R,@TPythonModuleDocString_W,'DocString');
    RegisterPropertyHelper(@TPythonModuleModuleName_R,@TPythonModuleModuleName_W,'ModuleName');
    RegisterPropertyHelper(@TPythonModuleErrors_R,@TPythonModuleErrors_W,'Errors');
    RegisterPropertyHelper(@TPythonModuleOnAfterInitialization_R,@TPythonModuleOnAfterInitialization_W,'OnAfterInitialization');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TErrors(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TErrors) do
  begin
    RegisterConstructor(@TErrors.Create, 'Create');
    RegisterMethod(@TErrors.Add, 'Add');
    RegisterMethod(@TErrors.Owner, 'Owner');
    RegisterPropertyHelper(@TErrorsItems_R,@TErrorsItems_W,'Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TError) do
  begin
    RegisterConstructor(@TError.Create, 'Create');
    RegisterMethod(@TError.Destroy, 'Free');
    RegisterMethod(@TError.Assign, 'Assign');
    RegisterMethod(@TError.BuildError, 'BuildError');
    RegisterMethod(@TError.RaiseError, 'RaiseError');
    RegisterMethod(@TError.RaiseErrorObj, 'RaiseErrorObj');
    RegisterMethod(@TError.Owner, 'Owner');
    RegisterPropertyHelper(@TErrorError_R,@TErrorError_W,'Error');
    RegisterPropertyHelper(@TErrorName_R,@TErrorName_W,'Name');
    RegisterPropertyHelper(@TErrorText_R,@TErrorText_W,'Text');
    RegisterPropertyHelper(@TErrorErrorType_R,@TErrorErrorType_W,'ErrorType');
    RegisterPropertyHelper(@TErrorParentClass_R,@TErrorParentClass_W,'ParentClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TParentClassError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TParentClassError) do
  begin
    RegisterMethod(@TParentClassError.AssignTo, 'AssignTo');
    RegisterPropertyHelper(@TParentClassErrorModule_R,@TParentClassErrorModule_W,'Module');
    RegisterPropertyHelper(@TParentClassErrorName_R,@TParentClassErrorName_W,'Name');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TGetSetContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TGetSetContainer) do
  begin
    RegisterConstructor(@TGetSetContainer.Create, 'Create');
    RegisterMethod(@TGetSetContainer.Destroy, 'Free');
    RegisterMethod(@TGetSetContainer.AddGetSet, 'AddGetSet');
    RegisterMethod(@TGetSetContainer.ClearGetSets, 'ClearGetSets');
    RegisterPropertyHelper(@TGetSetContainerGetSetCount_R,nil,'GetSetCount');
    RegisterPropertyHelper(@TGetSetContainerGetSet_R,nil,'GetSet');
    RegisterPropertyHelper(@TGetSetContainerGetSetData_R,nil,'GetSetData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMembersContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMembersContainer) do
  begin
    RegisterConstructor(@TMembersContainer.Create, 'Create');
    RegisterMethod(@Tmemberscontainer.Destroy, 'Free');
    RegisterMethod(@TMembersContainer.AddMember, 'AddMember');
    RegisterMethod(@TMembersContainer.ClearMembers, 'ClearMembers');
    RegisterPropertyHelper(@TMembersContainerMemberCount_R,nil,'MemberCount');
    RegisterPropertyHelper(@TMembersContainerMembers_R,nil,'Members');
    RegisterPropertyHelper(@TMembersContainerMembersData_R,nil,'MembersData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMethodsContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMethodsContainer) do
  begin
    RegisterConstructor(@TMethodsContainer.Create, 'Create');
    RegisterMethod(@TMethodsContainer.Destroy, 'Free');
    RegisterMethod(@TMethodsContainer.Initialize, 'Initialize');
    RegisterMethod(@TMethodsContainer.Finalize, 'Finalize');
    RegisterMethod(@TMethodsContainer.AddMethod, 'AddMethod');
    RegisterMethod(@TMethodsContainer.AddMethodWithKeywords, 'AddMethodWithKeywords');
    RegisterMethod(@TMethodsContainer.AddDelphiMethod, 'AddDelphiMethod');
    RegisterMethod(@TMethodsContainer.AddDelphiMethodWithKeywords, 'AddDelphiMethodWithKeywords');
    RegisterMethod(@TMethodsContainer.ClearMethods, 'ClearMethods');
    RegisterPropertyHelper(@TMethodsContainerMethodCount_R,nil,'MethodCount');
    RegisterPropertyHelper(@TMethodsContainerMethods_R,nil,'Methods');
    RegisterPropertyHelper(@TMethodsContainerMethodsData_R,nil,'MethodsData');
    RegisterPropertyHelper(@TMethodsContainerModuleDef_R,nil,'ModuleDef');
    RegisterPropertyHelper(@TMethodsContainerEvents_R,@TMethodsContainerEvents_W,'Events');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEventDefs(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEventDefs) do
  begin
    RegisterConstructor(@TEventDefs.Create, 'Create');
    RegisterMethod(@TEventDefs.Add, 'Add');
    RegisterMethod(@TEventDefs.RegisterEvents, 'RegisterEvents');
    RegisterPropertyHelper(@TEventDefsItems_R,nil,'Items');
    RegisterPropertyHelper(@TEventDefsContainer_R,nil,'Container');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEventDef(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEventDef) do
  begin
    RegisterConstructor(@TEventDef.Create, 'Create');
    RegisterMethod(@TEventDef.Destroy, 'Free');
    RegisterMethod(@TEventDef.GetDocString, 'GetDocString');
    RegisterMethod(@TEventDef.PythonEvent, 'PythonEvent');
    RegisterMethod(@TEventDef.Owner, 'Owner');
    RegisterPropertyHelper(@TEventDefName_R,@TEventDefName_W,'Name');
    RegisterPropertyHelper(@TEventDefOnExecute_R,@TEventDefOnExecute_W,'OnExecute');
    RegisterPropertyHelper(@TEventDefDocString_R,@TEventDefDocString_W,'DocString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEngineClient(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEngineClient) do
  begin
    RegisterConstructor(@TEngineClient.Create, 'Create');
    RegisterMethod(@TEngineClient.Destroy, 'Free');
    RegisterVirtualMethod(@TEngineClient.Initialize, 'Initialize');
    RegisterVirtualMethod(@TEngineClient.Finalize, 'Finalize');
    RegisterMethod(@TEngineClient.ClearEngine, 'ClearEngine');
    RegisterMethod(@TEngineClient.CheckEngine, 'CheckEngine');
    RegisterPropertyHelper(@TEngineClientInitialized_R,nil,'Initialized');
    RegisterPropertyHelper(@TEngineClientEngine_R,@TEngineClientEngine_W,'Engine');
    RegisterPropertyHelper(@TEngineClientOnCreate_R,@TEngineClientOnCreate_W,'OnCreate');
    RegisterPropertyHelper(@TEngineClientOnDestroy_R,@TEngineClientOnDestroy_W,'OnDestroy');
    RegisterPropertyHelper(@TEngineClientOnFinalization_R,@TEngineClientOnFinalization_W,'OnFinalization');
    RegisterPropertyHelper(@TEngineClientOnInitialization_R,@TEngineClientOnInitialization_W,'OnInitialization');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonEngine) do begin
    RegisterConstructor(@TPythonEngine.Create, 'Create');
    RegisterMethod(@TPythonEngine.Destroy, 'Free');
    RegisterMethod(@TPythonEngine.Initialize2, 'Initialize2');
    RegisterMethod(@TPythonEngine.DoOpenDll2, 'DoOpenDll2');
   RegisterMethod(@TPythonEngine.SetProgramArgs2, 'SetProgramArgs2');

    RegisterMethod(@TPythonEngine.SetPythonHome, 'SetPythonHome');
    RegisterMethod(@TPythonEngine.SetProgramName, 'SetProgramName');
    RegisterMethod(@TPythonEngine.IsType, 'IsType');
    RegisterMethod(@TPythonEngine.Run_CommandAsString, 'Run_CommandAsString');
    RegisterMethod(@TPythonEngine.Run_CommandAsObject, 'Run_CommandAsObject');
    RegisterMethod(@TPythonEngine.Run_CommandAsObjectWithDict, 'Run_CommandAsObjectWithDict');
    RegisterMethod(@TPythonEngineEncodeString01_P, 'EncodeString1');
    RegisterMethod(@TPythonEngineEncodeString01_P, 'EncodeString');
    RegisterMethod(@TPythonEngineEncodeString2_P, 'EncodeString2');
    RegisterMethod(@TPythonEngine.EncodeWindowsFilePath, 'EncodeWindowsFilePath');
    RegisterMethod(@TPythonEngineExecString3_P, 'ExecString3');
    RegisterMethod(@TPythonEngineExecString3_P, 'ExecString');
    RegisterMethod(@TPythonEngineExecString3_P, 'ExecStr');       //alias

    RegisterMethod(@TPythonEngineExecStrings4_P, 'ExecStrings4');
     RegisterMethod(@TPythonEngineExecStrings4_P, 'ExecStrings');     //alias
       RegisterMethod(@TPythonEngineEvalString5_P, 'EvalString5');
    RegisterMethod(@TPythonEngine.EvalStringAsStr, 'EvalStringAsStr');
    RegisterMethod(@TPythonEngine.EvalStringAsStr, 'EvalStr');         //alias
    RegisterMethod(@TPythonEngineEvalStrings6_P, 'EvalStrings6');
    RegisterMethod(@TPythonEngineExecString7_P, 'ExecString7');
    RegisterMethod(@TPythonEngineExecStrings8_P, 'ExecStrings8');
    RegisterMethod(@TPythonEngineEvalString9_P, 'EvalString9');
    RegisterMethod(@TPythonEngineEvalStrings10_P, 'EvalStrings10');
    RegisterMethod(@TPythonEngine.EvalStringsAsStr, 'EvalStringsAsStr');
    RegisterMethod(@TPythonEngine.EvalPyFunction, 'EvalPyFunction');
    RegisterMethod(@TPythonEngine.EvalFunction, 'EvalFunction');
    RegisterMethod(@TPythonEngine.EvalFunctionNoArgs, 'EvalFunctionNoArgs');
    RegisterMethod(@TPythonEngine.CheckEvalSyntax, 'CheckEvalSyntax');
    RegisterMethod(@TPythonEngine.CheckExecSyntax, 'CheckExecSyntax');
    RegisterMethod(@TPythonEngine.CheckSyntax, 'CheckSyntax');
    RegisterMethod(@TPythonEngine.RaiseError, 'RaiseError');
    RegisterMethod(@TPythonEngine.PyObjectAsString, 'PyObjectAsString');
    RegisterMethod(@TPythonEngine.DoRedirectIO, 'DoRedirectIO');
    RegisterMethod(@TPythonEngine.AddClient, 'AddClient');
    RegisterMethod(@TPythonEngine.RemoveClient, 'RemoveClient');
    RegisterMethod(@TPythonEngine.FindClient, 'FindClient');
    RegisterMethod(@TPythonEngine.TypeByName, 'TypeByName');
    RegisterMethod(@TPythonEngine.ModuleByName, 'ModuleByName');
    RegisterMethod(@TPythonEngine.MethodsByName, 'MethodsByName');
    RegisterVirtualMethod(@TPythonEngine.VariantAsPyObject, 'VariantAsPyObject');
    RegisterVirtualMethod(@TPythonEngine.PyObjectAsVariant, 'PyObjectAsVariant');
    RegisterMethod(@TPythonEngine.VarRecAsPyObject, 'VarRecAsPyObject');
    RegisterMethod(@TPythonEngine.MakePyTuple, 'MakePyTuple');
    RegisterMethod(@TPythonEngine.MakePyList, 'MakePyList');
    RegisterMethod(@TPythonEngine.ArrayToPyTuple, 'ArrayToPyTuple');
    RegisterMethod(@TPythonEngine.ArrayToPyList, 'ArrayToPyList');
    RegisterMethod(@TPythonEngine.ArrayToPyDict, 'ArrayToPyDict');
    RegisterMethod(@TPythonEngine.StringsToPyList, 'StringsToPyList');
    RegisterMethod(@TPythonEngine.StringsToPyTuple, 'StringsToPyTuple');
    RegisterMethod(@TPythonEngine.PyListToStrings, 'PyListToStrings');
    RegisterMethod(@TPythonEngine.PyTupleToStrings, 'PyTupleToStrings');
    RegisterMethod(@TPythonEngine.ReturnNone, 'ReturnNone');
    RegisterMethod(@TPythonEngine.ReturnTrue, 'ReturnTrue');
    RegisterMethod(@TPythonEngine.ReturnFalse, 'ReturnFalse');
    RegisterMethod(@TPythonEngine.FindModule, 'FindModule');
    RegisterMethod(@TPythonEngine.FindFunction, 'FindFunction');
    RegisterMethod(@TPythonEngine.SetToList, 'SetToList');
    RegisterMethod(@TPythonEngine.ListToSet, 'ListToSet');
    RegisterMethod(@TPythonEngine.CheckError, 'CheckError');
    RegisterMethod(@TPythonEngine.GetMainModule, 'GetMainModule');
    RegisterMethod(@TPythonEngine.PyTimeStruct_Check, 'PyTimeStruct_Check');
    RegisterMethod(@TPythonEngine.PyDate_Check, 'PyDate_Check');
    RegisterMethod(@TPythonEngine.PyDate_CheckExact, 'PyDate_CheckExact');
    RegisterMethod(@TPythonEngine.PyDateTime_Check, 'PyDateTime_Check');
    RegisterMethod(@TPythonEngine.PyDateTime_CheckExact, 'PyDateTime_CheckExact');
    RegisterMethod(@TPythonEngine.PyTime_Check, 'PyTime_Check');
    RegisterMethod(@TPythonEngine.PyTime_CheckExact, 'PyTime_CheckExact');
    RegisterMethod(@TPythonEngine.PyDelta_Check, 'PyDelta_Check');
    RegisterMethod(@TPythonEngine.PyDelta_CheckExact, 'PyDelta_CheckExact');
    RegisterMethod(@TPythonEngine.PyTZInfo_Check, 'PyTZInfo_Check');
    RegisterMethod(@TPythonEngine.PyTZInfo_CheckExact, 'PyTZInfo_CheckExact');
    RegisterMethod(@TPythonEnginePyUnicodeFromString11_P, 'PyUnicodeFromString11');
    RegisterMethod(@TPythonEnginePyUnicodeFromString12_P, 'PyUnicodeFromString12');
    RegisterMethod(@TPythonEngine.PyUnicodeAsString, 'PyUnicodeAsString');
    //RegisterMethod(@TPythonEngine.PyUnicodeAsUTF8String, 'PyUnicodeAsUTF8String');
    RegisterMethod(@TPythonEngine.PyBytesAsAnsiString, 'PyBytesAsAnsiString');
    RegisterPropertyHelper(@TPythonEngineClientCount_R,nil,'ClientCount');
    RegisterPropertyHelper(@TPythonEngineClients_R,nil,'Clients');
    RegisterPropertyHelper(@TPythonEngineExecModule_R,@TPythonEngineExecModule_W,'ExecModule');
    RegisterPropertyHelper(@TPythonEngineThreadState_R,nil,'ThreadState');
    RegisterPropertyHelper(@TPythonEngineTraceback_R,nil,'Traceback');
    RegisterPropertyHelper(@TPythonEngineLocalVars_R,@TPythonEngineLocalVars_W,'LocalVars');
    RegisterPropertyHelper(@TPythonEngineGlobalVars_R,@TPythonEngineGlobalVars_W,'GlobalVars');
    RegisterPropertyHelper(@TPythonEngineIOPythonModule_R,nil,'IOPythonModule');
    RegisterPropertyHelper(@TPythonEnginePythonHome_R,@TPythonEnginePythonHome_W,'PythonHome');
    RegisterPropertyHelper(@TPythonEngineProgramName_R,@TPythonEngineProgramName_W,'ProgramName');
    RegisterPropertyHelper(@TPythonEngineAutoFinalize_R,@TPythonEngineAutoFinalize_W,'AutoFinalize');
    RegisterPropertyHelper(@TPythonEngineVenvPythonExe_R,@TPythonEngineVenvPythonExe_W,'VenvPythonExe');
    RegisterPropertyHelper(@TPythonEngineDatetimeConversionMode_R,@TPythonEngineDatetimeConversionMode_W,'DatetimeConversionMode');
    RegisterPropertyHelper(@TPythonEngineInitScript_R,@TPythonEngineInitScript_W,'InitScript');
    RegisterPropertyHelper(@TPythonEngineInitThreads_R,@TPythonEngineInitThreads_W,'InitThreads');
    RegisterPropertyHelper(@TPythonEngineIO_R,@TPythonEngineIO_W,'IO');
    RegisterPropertyHelper(@TPythonEnginePyFlags_R,@TPythonEnginePyFlags_W,'PyFlags');
    RegisterPropertyHelper(@TPythonEngineRedirectIO_R,@TPythonEngineRedirectIO_W,'RedirectIO');
    RegisterPropertyHelper(@TPythonEngineUseWindowsConsole_R,@TPythonEngineUseWindowsConsole_W,'UseWindowsConsole');
    RegisterPropertyHelper(@TPythonEngineOnAfterInit_R,@TPythonEngineOnAfterInit_W,'OnAfterInit');
    RegisterPropertyHelper(@TPythonEngineOnPathInitialization_R,@TPythonEngineOnPathInitialization_W,'OnPathInitialization');
    RegisterPropertyHelper(@TPythonEngineOnSysPathInit_R,@TPythonEngineOnSysPathInit_W,'OnSysPathInit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonTraceback(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonTraceback) do
  begin
    RegisterConstructor(@TPythonTraceback.Create, 'Create');
    RegisterMethod(@TPythonTraceback.Destroy, 'Free');
    RegisterMethod(@TPythonTraceback.Clear, 'Clear');
    RegisterMethod(@TPythonTraceback.Refresh, 'Refresh');
    RegisterMethod(@TPythonTraceback.AddItem, 'AddItem');
    RegisterPropertyHelper(@TPythonTracebackItemCount_R,nil,'ItemCount');
    RegisterPropertyHelper(@TPythonTracebackItems_R,nil,'Items');
    RegisterPropertyHelper(@TPythonTracebackLimit_R,@TPythonTracebackLimit_W,'Limit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTracebackItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTracebackItem) do
  begin
    RegisterPropertyHelper(@TTracebackItemFileName_R,@TTracebackItemFileName_W,'FileName');
    RegisterPropertyHelper(@TTracebackItemLineNo_R,@TTracebackItemLineNo_W,'LineNo');
    RegisterPropertyHelper(@TTracebackItemContext_R,@TTracebackItemContext_W,'Context');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonInterface(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonInterface) do
  begin
    RegisterPropertyHelper(@TPythonInterfacePy_DebugFlag_R,@TPythonInterfacePy_DebugFlag_W,'Py_DebugFlag');
    RegisterPropertyHelper(@TPythonInterfacePy_VerboseFlag_R,@TPythonInterfacePy_VerboseFlag_W,'Py_VerboseFlag');
    RegisterPropertyHelper(@TPythonInterfacePy_InteractiveFlag_R,@TPythonInterfacePy_InteractiveFlag_W,'Py_InteractiveFlag');
    RegisterPropertyHelper(@TPythonInterfacePy_OptimizeFlag_R,@TPythonInterfacePy_OptimizeFlag_W,'Py_OptimizeFlag');
    RegisterPropertyHelper(@TPythonInterfacePy_NoSiteFlag_R,@TPythonInterfacePy_NoSiteFlag_W,'Py_NoSiteFlag');
    RegisterPropertyHelper(@TPythonInterfacePy_FrozenFlag_R,@TPythonInterfacePy_FrozenFlag_W,'Py_FrozenFlag');
    RegisterPropertyHelper(@TPythonInterfacePy_IgnoreEnvironmentFlag_R,@TPythonInterfacePy_IgnoreEnvironmentFlag_W,'Py_IgnoreEnvironmentFlag');
    RegisterPropertyHelper(@TPythonInterfacePyImport_FrozenModules_R,@TPythonInterfacePyImport_FrozenModules_W,'PyImport_FrozenModules');
    RegisterPropertyHelper(@TPythonInterfacePy_None_R,@TPythonInterfacePy_None_W,'Py_None');
    RegisterPropertyHelper(@TPythonInterfacePy_Ellipsis_R,@TPythonInterfacePy_Ellipsis_W,'Py_Ellipsis');
    RegisterPropertyHelper(@TPythonInterfacePy_False_R,@TPythonInterfacePy_False_W,'Py_False');
    RegisterPropertyHelper(@TPythonInterfacePy_True_R,@TPythonInterfacePy_True_W,'Py_True');
    RegisterPropertyHelper(@TPythonInterfacePy_NotImplemented_R,@TPythonInterfacePy_NotImplemented_W,'Py_NotImplemented');
    RegisterPropertyHelper(@TPythonInterfacePyExc_AttributeError_R,@TPythonInterfacePyExc_AttributeError_W,'PyExc_AttributeError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_EOFError_R,@TPythonInterfacePyExc_EOFError_W,'PyExc_EOFError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_IOError_R,@TPythonInterfacePyExc_IOError_W,'PyExc_IOError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_ImportError_R,@TPythonInterfacePyExc_ImportError_W,'PyExc_ImportError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_IndexError_R,@TPythonInterfacePyExc_IndexError_W,'PyExc_IndexError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_KeyError_R,@TPythonInterfacePyExc_KeyError_W,'PyExc_KeyError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_KeyboardInterrupt_R,@TPythonInterfacePyExc_KeyboardInterrupt_W,'PyExc_KeyboardInterrupt');
    RegisterPropertyHelper(@TPythonInterfacePyExc_MemoryError_R,@TPythonInterfacePyExc_MemoryError_W,'PyExc_MemoryError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_NameError_R,@TPythonInterfacePyExc_NameError_W,'PyExc_NameError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_OverflowError_R,@TPythonInterfacePyExc_OverflowError_W,'PyExc_OverflowError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_RuntimeError_R,@TPythonInterfacePyExc_RuntimeError_W,'PyExc_RuntimeError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_SyntaxError_R,@TPythonInterfacePyExc_SyntaxError_W,'PyExc_SyntaxError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_SystemError_R,@TPythonInterfacePyExc_SystemError_W,'PyExc_SystemError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_SystemExit_R,@TPythonInterfacePyExc_SystemExit_W,'PyExc_SystemExit');
    RegisterPropertyHelper(@TPythonInterfacePyExc_TypeError_R,@TPythonInterfacePyExc_TypeError_W,'PyExc_TypeError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_ValueError_R,@TPythonInterfacePyExc_ValueError_W,'PyExc_ValueError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_ZeroDivisionError_R,@TPythonInterfacePyExc_ZeroDivisionError_W,'PyExc_ZeroDivisionError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_ArithmeticError_R,@TPythonInterfacePyExc_ArithmeticError_W,'PyExc_ArithmeticError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_Exception_R,@TPythonInterfacePyExc_Exception_W,'PyExc_Exception');
    RegisterPropertyHelper(@TPythonInterfacePyExc_FloatingPointError_R,@TPythonInterfacePyExc_FloatingPointError_W,'PyExc_FloatingPointError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_LookupError_R,@TPythonInterfacePyExc_LookupError_W,'PyExc_LookupError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_AssertionError_R,@TPythonInterfacePyExc_AssertionError_W,'PyExc_AssertionError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_EnvironmentError_R,@TPythonInterfacePyExc_EnvironmentError_W,'PyExc_EnvironmentError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_IndentationError_R,@TPythonInterfacePyExc_IndentationError_W,'PyExc_IndentationError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_NotImplementedError_R,@TPythonInterfacePyExc_NotImplementedError_W,'PyExc_NotImplementedError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_OSError_R,@TPythonInterfacePyExc_OSError_W,'PyExc_OSError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_TabError_R,@TPythonInterfacePyExc_TabError_W,'PyExc_TabError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_UnboundLocalError_R,@TPythonInterfacePyExc_UnboundLocalError_W,'PyExc_UnboundLocalError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_UnicodeError_R,@TPythonInterfacePyExc_UnicodeError_W,'PyExc_UnicodeError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_WindowsError_R,@TPythonInterfacePyExc_WindowsError_W,'PyExc_WindowsError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_Warning_R,@TPythonInterfacePyExc_Warning_W,'PyExc_Warning');
    RegisterPropertyHelper(@TPythonInterfacePyExc_DeprecationWarning_R,@TPythonInterfacePyExc_DeprecationWarning_W,'PyExc_DeprecationWarning');
    RegisterPropertyHelper(@TPythonInterfacePyExc_RuntimeWarning_R,@TPythonInterfacePyExc_RuntimeWarning_W,'PyExc_RuntimeWarning');
    RegisterPropertyHelper(@TPythonInterfacePyExc_SyntaxWarning_R,@TPythonInterfacePyExc_SyntaxWarning_W,'PyExc_SyntaxWarning');
    RegisterPropertyHelper(@TPythonInterfacePyExc_UserWarning_R,@TPythonInterfacePyExc_UserWarning_W,'PyExc_UserWarning');
    RegisterPropertyHelper(@TPythonInterfacePyExc_ReferenceError_R,@TPythonInterfacePyExc_ReferenceError_W,'PyExc_ReferenceError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_StopIteration_R,@TPythonInterfacePyExc_StopIteration_W,'PyExc_StopIteration');
    RegisterPropertyHelper(@TPythonInterfacePyExc_FutureWarning_R,@TPythonInterfacePyExc_FutureWarning_W,'PyExc_FutureWarning');
    RegisterPropertyHelper(@TPythonInterfacePyExc_PendingDeprecationWarning_R,@TPythonInterfacePyExc_PendingDeprecationWarning_W,'PyExc_PendingDeprecationWarning');
    RegisterPropertyHelper(@TPythonInterfacePyExc_UnicodeDecodeError_R,@TPythonInterfacePyExc_UnicodeDecodeError_W,'PyExc_UnicodeDecodeError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_UnicodeEncodeError_R,@TPythonInterfacePyExc_UnicodeEncodeError_W,'PyExc_UnicodeEncodeError');
    RegisterPropertyHelper(@TPythonInterfacePyExc_UnicodeTranslateError_R,@TPythonInterfacePyExc_UnicodeTranslateError_W,'PyExc_UnicodeTranslateError');
    RegisterPropertyHelper(@TPythonInterfacePyCode_Type_R,@TPythonInterfacePyCode_Type_W,'PyCode_Type');
    RegisterPropertyHelper(@TPythonInterfacePyType_Type_R,@TPythonInterfacePyType_Type_W,'PyType_Type');
    RegisterPropertyHelper(@TPythonInterfacePyCFunction_Type_R,@TPythonInterfacePyCFunction_Type_W,'PyCFunction_Type');
    RegisterPropertyHelper(@TPythonInterfacePyComplex_Type_R,@TPythonInterfacePyComplex_Type_W,'PyComplex_Type');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Type_R,@TPythonInterfacePyDict_Type_W,'PyDict_Type');
    RegisterPropertyHelper(@TPythonInterfacePyFloat_Type_R,@TPythonInterfacePyFloat_Type_W,'PyFloat_Type');
    RegisterPropertyHelper(@TPythonInterfacePyFrame_Type_R,@TPythonInterfacePyFrame_Type_W,'PyFrame_Type');
    RegisterPropertyHelper(@TPythonInterfacePyFunction_Type_R,@TPythonInterfacePyFunction_Type_W,'PyFunction_Type');
    RegisterPropertyHelper(@TPythonInterfacePyList_Type_R,@TPythonInterfacePyList_Type_W,'PyList_Type');
    RegisterPropertyHelper(@TPythonInterfacePyLong_Type_R,@TPythonInterfacePyLong_Type_W,'PyLong_Type');
    RegisterPropertyHelper(@TPythonInterfacePyMethod_Type_R,@TPythonInterfacePyMethod_Type_W,'PyMethod_Type');
    RegisterPropertyHelper(@TPythonInterfacePyModule_Type_R,@TPythonInterfacePyModule_Type_W,'PyModule_Type');
    RegisterPropertyHelper(@TPythonInterfacePyObject_Type_R,@TPythonInterfacePyObject_Type_W,'PyObject_Type');
    RegisterPropertyHelper(@TPythonInterfacePyRange_Type_R,@TPythonInterfacePyRange_Type_W,'PyRange_Type');
    RegisterPropertyHelper(@TPythonInterfacePySlice_Type_R,@TPythonInterfacePySlice_Type_W,'PySlice_Type');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_Type_R,@TPythonInterfacePyBytes_Type_W,'PyBytes_Type');
    RegisterPropertyHelper(@TPythonInterfacePyTuple_Type_R,@TPythonInterfacePyTuple_Type_W,'PyTuple_Type');
    RegisterPropertyHelper(@TPythonInterfacePyBaseObject_Type_R,@TPythonInterfacePyBaseObject_Type_W,'PyBaseObject_Type');
    RegisterPropertyHelper(@TPythonInterfacePyCallIter_Type_R,@TPythonInterfacePyCallIter_Type_W,'PyCallIter_Type');
    RegisterPropertyHelper(@TPythonInterfacePyCell_Type_R,@TPythonInterfacePyCell_Type_W,'PyCell_Type');
    RegisterPropertyHelper(@TPythonInterfacePyClassMethod_Type_R,@TPythonInterfacePyClassMethod_Type_W,'PyClassMethod_Type');
    RegisterPropertyHelper(@TPythonInterfacePyProperty_Type_R,@TPythonInterfacePyProperty_Type_W,'PyProperty_Type');
    RegisterPropertyHelper(@TPythonInterfacePySeqIter_Type_R,@TPythonInterfacePySeqIter_Type_W,'PySeqIter_Type');
    RegisterPropertyHelper(@TPythonInterfacePyStaticMethod_Type_R,@TPythonInterfacePyStaticMethod_Type_W,'PyStaticMethod_Type');
    RegisterPropertyHelper(@TPythonInterfacePySuper_Type_R,@TPythonInterfacePySuper_Type_W,'PySuper_Type');
    RegisterPropertyHelper(@TPythonInterfacePyTraceBack_Type_R,@TPythonInterfacePyTraceBack_Type_W,'PyTraceBack_Type');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_Type_R,@TPythonInterfacePyUnicode_Type_W,'PyUnicode_Type');
    RegisterPropertyHelper(@TPythonInterfacePyWrapperDescr_Type_R,@TPythonInterfacePyWrapperDescr_Type_W,'PyWrapperDescr_Type');
    RegisterPropertyHelper(@TPythonInterface_PyWeakref_RefType_R,@TPythonInterface_PyWeakref_RefType_W,'_PyWeakref_RefType');
    RegisterPropertyHelper(@TPythonInterface_PyWeakref_ProxyType_R,@TPythonInterface_PyWeakref_ProxyType_W,'_PyWeakref_ProxyType');
    RegisterPropertyHelper(@TPythonInterface_PyWeakref_CallableProxyType_R,@TPythonInterface_PyWeakref_CallableProxyType_W,'_PyWeakref_CallableProxyType');
    RegisterPropertyHelper(@TPythonInterfacePyBool_Type_R,@TPythonInterfacePyBool_Type_W,'PyBool_Type');
    RegisterPropertyHelper(@TPythonInterfacePyEnum_Type_R,@TPythonInterfacePyEnum_Type_W,'PyEnum_Type');
    //RegisterPropertyHelper(@TPythonInterfacePy_GetBuildInfo_R,@TPythonInterfacePy_GetBuildInfo_W,'Py_GetBuildInfo');
    //RegisterPropertyHelper(@TPythonInterfacePyImport_ExecCodeModule_R,@TPythonInterfacePyImport_ExecCodeModule_W,'PyImport_ExecCodeModule');
   { RegisterPropertyHelper(@TPythonInterfacePyComplex_FromCComplex_R,@TPythonInterfacePyComplex_FromCComplex_W,'PyComplex_FromCComplex');
    RegisterPropertyHelper(@TPythonInterfacePyComplex_FromDoubles_R,@TPythonInterfacePyComplex_FromDoubles_W,'PyComplex_FromDoubles');
    RegisterPropertyHelper(@TPythonInterfacePyComplex_RealAsDouble_R,@TPythonInterfacePyComplex_RealAsDouble_W,'PyComplex_RealAsDouble');
    RegisterPropertyHelper(@TPythonInterfacePyComplex_ImagAsDouble_R,@TPythonInterfacePyComplex_ImagAsDouble_W,'PyComplex_ImagAsDouble');
    RegisterPropertyHelper(@TPythonInterfacePyComplex_AsCComplex_R,@TPythonInterfacePyComplex_AsCComplex_W,'PyComplex_AsCComplex');
    RegisterPropertyHelper(@TPythonInterfacePyCFunction_GetFunction_R,@TPythonInterfacePyCFunction_GetFunction_W,'PyCFunction_GetFunction');
    RegisterPropertyHelper(@TPythonInterfacePyCFunction_GetSelf_R,@TPythonInterfacePyCFunction_GetSelf_W,'PyCFunction_GetSelf');
    RegisterPropertyHelper(@TPythonInterfacePyCallable_Check_R,@TPythonInterfacePyCallable_Check_W,'PyCallable_Check');
    RegisterPropertyHelper(@TPythonInterfacePyModule_Create2_R,@TPythonInterfacePyModule_Create2_W,'PyModule_Create2');
    RegisterPropertyHelper(@TPythonInterfacePyErr_BadArgument_R,@TPythonInterfacePyErr_BadArgument_W,'PyErr_BadArgument');
    RegisterPropertyHelper(@TPythonInterfacePyErr_BadInternalCall_R,@TPythonInterfacePyErr_BadInternalCall_W,'PyErr_BadInternalCall');
    RegisterPropertyHelper(@TPythonInterfacePyErr_CheckSignals_R,@TPythonInterfacePyErr_CheckSignals_W,'PyErr_CheckSignals');
    RegisterPropertyHelper(@TPythonInterfacePyErr_Clear_R,@TPythonInterfacePyErr_Clear_W,'PyErr_Clear');
    RegisterPropertyHelper(@TPythonInterfacePyErr_Fetch_R,@TPythonInterfacePyErr_Fetch_W,'PyErr_Fetch');
    RegisterPropertyHelper(@TPythonInterfacePyErr_NoMemory_R,@TPythonInterfacePyErr_NoMemory_W,'PyErr_NoMemory');
    RegisterPropertyHelper(@TPythonInterfacePyErr_Occurred_R,@TPythonInterfacePyErr_Occurred_W,'PyErr_Occurred');
    RegisterPropertyHelper(@TPythonInterfacePyErr_Print_R,@TPythonInterfacePyErr_Print_W,'PyErr_Print');
    RegisterPropertyHelper(@TPythonInterfacePyErr_Restore_R,@TPythonInterfacePyErr_Restore_W,'PyErr_Restore');
    RegisterPropertyHelper(@TPythonInterfacePyErr_SetFromErrno_R,@TPythonInterfacePyErr_SetFromErrno_W,'PyErr_SetFromErrno');
    RegisterPropertyHelper(@TPythonInterfacePyErr_SetNone_R,@TPythonInterfacePyErr_SetNone_W,'PyErr_SetNone');
    RegisterPropertyHelper(@TPythonInterfacePyErr_SetObject_R,@TPythonInterfacePyErr_SetObject_W,'PyErr_SetObject');
    RegisterPropertyHelper(@TPythonInterfacePyErr_SetString_R,@TPythonInterfacePyErr_SetString_W,'PyErr_SetString');
    RegisterPropertyHelper(@TPythonInterfacePyErr_WarnEx_R,@TPythonInterfacePyErr_WarnEx_W,'PyErr_WarnEx');
    RegisterPropertyHelper(@TPythonInterfacePyErr_WarnExplicit_R,@TPythonInterfacePyErr_WarnExplicit_W,'PyErr_WarnExplicit');
    RegisterPropertyHelper(@TPythonInterfacePyImport_GetModuleDict_R,@TPythonInterfacePyImport_GetModuleDict_W,'PyImport_GetModuleDict');
    RegisterPropertyHelper(@TPythonInterfacePyArg_Parse_R,@TPythonInterfacePyArg_Parse_W,'PyArg_Parse');
    RegisterPropertyHelper(@TPythonInterfacePyArg_ParseTuple_R,@TPythonInterfacePyArg_ParseTuple_W,'PyArg_ParseTuple');
    RegisterPropertyHelper(@TPythonInterfacePyArg_ParseTupleAndKeywords_R,@TPythonInterfacePyArg_ParseTupleAndKeywords_W,'PyArg_ParseTupleAndKeywords');
    RegisterPropertyHelper(@TPythonInterfacePy_BuildValue_R,@TPythonInterfacePy_BuildValue_W,'Py_BuildValue');
    RegisterPropertyHelper(@TPythonInterfacePy_Initialize_R,@TPythonInterfacePy_Initialize_W,'Py_Initialize');
    RegisterPropertyHelper(@TPythonInterfacePy_Exit_R,@TPythonInterfacePy_Exit_W,'Py_Exit');
    RegisterPropertyHelper(@TPythonInterfacePyEval_GetBuiltins_R,@TPythonInterfacePyEval_GetBuiltins_W,'PyEval_GetBuiltins');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Copy_R,@TPythonInterfacePyDict_Copy_W,'PyDict_Copy');
    RegisterPropertyHelper(@TPythonInterfacePyDict_GetItem_R,@TPythonInterfacePyDict_GetItem_W,'PyDict_GetItem');
    RegisterPropertyHelper(@TPythonInterfacePyDict_SetItem_R,@TPythonInterfacePyDict_SetItem_W,'PyDict_SetItem');
    RegisterPropertyHelper(@TPythonInterfacePyDict_DelItem_R,@TPythonInterfacePyDict_DelItem_W,'PyDict_DelItem');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Clear_R,@TPythonInterfacePyDict_Clear_W,'PyDict_Clear');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Next_R,@TPythonInterfacePyDict_Next_W,'PyDict_Next');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Keys_R,@TPythonInterfacePyDict_Keys_W,'PyDict_Keys');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Values_R,@TPythonInterfacePyDict_Values_W,'PyDict_Values');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Items_R,@TPythonInterfacePyDict_Items_W,'PyDict_Items');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Size_R,@TPythonInterfacePyDict_Size_W,'PyDict_Size');
    RegisterPropertyHelper(@TPythonInterfacePyDict_Update_R,@TPythonInterfacePyDict_Update_W,'PyDict_Update');
    RegisterPropertyHelper(@TPythonInterfacePyDict_DelItemString_R,@TPythonInterfacePyDict_DelItemString_W,'PyDict_DelItemString');
    RegisterPropertyHelper(@TPythonInterfacePyDict_New_R,@TPythonInterfacePyDict_New_W,'PyDict_New');
    RegisterPropertyHelper(@TPythonInterfacePyDict_GetItemString_R,@TPythonInterfacePyDict_GetItemString_W,'PyDict_GetItemString');
    RegisterPropertyHelper(@TPythonInterfacePyDict_SetItemString_R,@TPythonInterfacePyDict_SetItemString_W,'PyDict_SetItemString');
    RegisterPropertyHelper(@TPythonInterfacePyDictProxy_New_R,@TPythonInterfacePyDictProxy_New_W,'PyDictProxy_New');
    }
    {RegisterPropertyHelper(@TPythonInterfacePyModule_GetDict_R,@TPythonInterfacePyModule_GetDict_W,'PyModule_GetDict');
    RegisterPropertyHelper(@TPythonInterfacePyObject_Str_R,@TPythonInterfacePyObject_Str_W,'PyObject_Str');
    RegisterPropertyHelper(@TPythonInterfacePyRun_String_R,@TPythonInterfacePyRun_String_W,'PyRun_String');
    RegisterPropertyHelper(@TPythonInterfacePyRun_SimpleString_R,@TPythonInterfacePyRun_SimpleString_W,'PyRun_SimpleString');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_AsString_R,@TPythonInterfacePyBytes_AsString_W,'PyBytes_AsString');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_AsStringAndSize_R,@TPythonInterfacePyBytes_AsStringAndSize_W,'PyBytes_AsStringAndSize');
    RegisterPropertyHelper(@TPythonInterfacePySys_SetArgv_R,@TPythonInterfacePySys_SetArgv_W,'PySys_SetArgv');
    RegisterPropertyHelper(@TPythonInterfacePyCFunction_NewEx_R,@TPythonInterfacePyCFunction_NewEx_W,'PyCFunction_NewEx');
    RegisterPropertyHelper(@TPythonInterfacePyEval_CallObjectWithKeywords_R,@TPythonInterfacePyEval_CallObjectWithKeywords_W,'PyEval_CallObjectWithKeywords');
    RegisterPropertyHelper(@TPythonInterfacePyEval_GetFrame_R,@TPythonInterfacePyEval_GetFrame_W,'PyEval_GetFrame');
    RegisterPropertyHelper(@TPythonInterfacePyEval_GetGlobals_R,@TPythonInterfacePyEval_GetGlobals_W,'PyEval_GetGlobals');
    RegisterPropertyHelper(@TPythonInterfacePyEval_GetLocals_R,@TPythonInterfacePyEval_GetLocals_W,'PyEval_GetLocals');
    RegisterPropertyHelper(@TPythonInterfacePyEval_InitThreads_R,@TPythonInterfacePyEval_InitThreads_W,'PyEval_InitThreads');
    RegisterPropertyHelper(@TPythonInterfacePyEval_RestoreThread_R,@TPythonInterfacePyEval_RestoreThread_W,'PyEval_RestoreThread');
    RegisterPropertyHelper(@TPythonInterfacePyEval_SaveThread_R,@TPythonInterfacePyEval_SaveThread_W,'PyEval_SaveThread');
    RegisterPropertyHelper(@TPythonInterfacePyFile_GetLine_R,@TPythonInterfacePyFile_GetLine_W,'PyFile_GetLine');
    RegisterPropertyHelper(@TPythonInterfacePyFile_WriteObject_R,@TPythonInterfacePyFile_WriteObject_W,'PyFile_WriteObject');
    RegisterPropertyHelper(@TPythonInterfacePyFile_WriteString_R,@TPythonInterfacePyFile_WriteString_W,'PyFile_WriteString');
    RegisterPropertyHelper(@TPythonInterfacePyFloat_AsDouble_R,@TPythonInterfacePyFloat_AsDouble_W,'PyFloat_AsDouble');
    RegisterPropertyHelper(@TPythonInterfacePyFloat_FromDouble_R,@TPythonInterfacePyFloat_FromDouble_W,'PyFloat_FromDouble');
    RegisterPropertyHelper(@TPythonInterfacePyFloat_FromString_R,@TPythonInterfacePyFloat_FromString_W,'PyFloat_FromString');
    RegisterPropertyHelper(@TPythonInterfacePyFunction_GetCode_R,@TPythonInterfacePyFunction_GetCode_W,'PyFunction_GetCode');
    RegisterPropertyHelper(@TPythonInterfacePyFunction_GetGlobals_R,@TPythonInterfacePyFunction_GetGlobals_W,'PyFunction_GetGlobals');
    RegisterPropertyHelper(@TPythonInterfacePyFunction_New_R,@TPythonInterfacePyFunction_New_W,'PyFunction_New');
    RegisterPropertyHelper(@TPythonInterfacePyImport_AddModule_R,@TPythonInterfacePyImport_AddModule_W,'PyImport_AddModule');
    RegisterPropertyHelper(@TPythonInterfacePyImport_GetMagicNumber_R,@TPythonInterfacePyImport_GetMagicNumber_W,'PyImport_GetMagicNumber');
    RegisterPropertyHelper(@TPythonInterfacePyImport_ImportFrozenModule_R,@TPythonInterfacePyImport_ImportFrozenModule_W,'PyImport_ImportFrozenModule');
    RegisterPropertyHelper(@TPythonInterfacePyImport_ImportModule_R,@TPythonInterfacePyImport_ImportModule_W,'PyImport_ImportModule');
    RegisterPropertyHelper(@TPythonInterfacePyImport_Import_R,@TPythonInterfacePyImport_Import_W,'PyImport_Import');
    RegisterPropertyHelper(@TPythonInterfacePyImport_ReloadModule_R,@TPythonInterfacePyImport_ReloadModule_W,'PyImport_ReloadModule');
    RegisterPropertyHelper(@TPythonInterfacePyList_Append_R,@TPythonInterfacePyList_Append_W,'PyList_Append');
    RegisterPropertyHelper(@TPythonInterfacePyList_AsTuple_R,@TPythonInterfacePyList_AsTuple_W,'PyList_AsTuple');
    RegisterPropertyHelper(@TPythonInterfacePyList_GetItem_R,@TPythonInterfacePyList_GetItem_W,'PyList_GetItem');
    RegisterPropertyHelper(@TPythonInterfacePyList_GetSlice_R,@TPythonInterfacePyList_GetSlice_W,'PyList_GetSlice');
    RegisterPropertyHelper(@TPythonInterfacePyList_Insert_R,@TPythonInterfacePyList_Insert_W,'PyList_Insert');
    RegisterPropertyHelper(@TPythonInterfacePyList_New_R,@TPythonInterfacePyList_New_W,'PyList_New');
    RegisterPropertyHelper(@TPythonInterfacePyList_Reverse_R,@TPythonInterfacePyList_Reverse_W,'PyList_Reverse');
    RegisterPropertyHelper(@TPythonInterfacePyList_SetItem_R,@TPythonInterfacePyList_SetItem_W,'PyList_SetItem');
    RegisterPropertyHelper(@TPythonInterfacePyList_SetSlice_R,@TPythonInterfacePyList_SetSlice_W,'PyList_SetSlice');
    RegisterPropertyHelper(@TPythonInterfacePyList_Size_R,@TPythonInterfacePyList_Size_W,'PyList_Size');
    RegisterPropertyHelper(@TPythonInterfacePyList_Sort_R,@TPythonInterfacePyList_Sort_W,'PyList_Sort');
    RegisterPropertyHelper(@TPythonInterfacePyLong_AsDouble_R,@TPythonInterfacePyLong_AsDouble_W,'PyLong_AsDouble');
    RegisterPropertyHelper(@TPythonInterfacePyLong_AsLong_R,@TPythonInterfacePyLong_AsLong_W,'PyLong_AsLong');
    RegisterPropertyHelper(@TPythonInterfacePyLong_FromDouble_R,@TPythonInterfacePyLong_FromDouble_W,'PyLong_FromDouble');
    RegisterPropertyHelper(@TPythonInterfacePyLong_FromLong_R,@TPythonInterfacePyLong_FromLong_W,'PyLong_FromLong');
    RegisterPropertyHelper(@TPythonInterfacePyLong_FromString_R,@TPythonInterfacePyLong_FromString_W,'PyLong_FromString');
    RegisterPropertyHelper(@TPythonInterfacePyLong_FromUnsignedLong_R,@TPythonInterfacePyLong_FromUnsignedLong_W,'PyLong_FromUnsignedLong');
    RegisterPropertyHelper(@TPythonInterfacePyLong_AsUnsignedLong_R,@TPythonInterfacePyLong_AsUnsignedLong_W,'PyLong_AsUnsignedLong');
    RegisterPropertyHelper(@TPythonInterfacePyLong_FromUnicodeObject_R,@TPythonInterfacePyLong_FromUnicodeObject_W,'PyLong_FromUnicodeObject');
    RegisterPropertyHelper(@TPythonInterfacePyLong_FromLongLong_R,@TPythonInterfacePyLong_FromLongLong_W,'PyLong_FromLongLong');
    RegisterPropertyHelper(@TPythonInterfacePyLong_FromUnsignedLongLong_R,@TPythonInterfacePyLong_FromUnsignedLongLong_W,'PyLong_FromUnsignedLongLong');
    RegisterPropertyHelper(@TPythonInterfacePyLong_AsLongLong_R,@TPythonInterfacePyLong_AsLongLong_W,'PyLong_AsLongLong');
    RegisterPropertyHelper(@TPythonInterfacePyLong_FromVoidPtr_R,@TPythonInterfacePyLong_FromVoidPtr_W,'PyLong_FromVoidPtr');
    RegisterPropertyHelper(@TPythonInterfacePyMapping_Check_R,@TPythonInterfacePyMapping_Check_W,'PyMapping_Check');
    RegisterPropertyHelper(@TPythonInterfacePyMapping_GetItemString_R,@TPythonInterfacePyMapping_GetItemString_W,'PyMapping_GetItemString');
    RegisterPropertyHelper(@TPythonInterfacePyMapping_HasKey_R,@TPythonInterfacePyMapping_HasKey_W,'PyMapping_HasKey');
    RegisterPropertyHelper(@TPythonInterfacePyMapping_HasKeyString_R,@TPythonInterfacePyMapping_HasKeyString_W,'PyMapping_HasKeyString');
    RegisterPropertyHelper(@TPythonInterfacePyMapping_Length_R,@TPythonInterfacePyMapping_Length_W,'PyMapping_Length');
    RegisterPropertyHelper(@TPythonInterfacePyMapping_SetItemString_R,@TPythonInterfacePyMapping_SetItemString_W,'PyMapping_SetItemString');
    RegisterPropertyHelper(@TPythonInterfacePyMethod_Function_R,@TPythonInterfacePyMethod_Function_W,'PyMethod_Function');
    RegisterPropertyHelper(@TPythonInterfacePyMethod_New_R,@TPythonInterfacePyMethod_New_W,'PyMethod_New');
    RegisterPropertyHelper(@TPythonInterfacePyMethod_Self_R,@TPythonInterfacePyMethod_Self_W,'PyMethod_Self');
    RegisterPropertyHelper(@TPythonInterfacePyModule_GetName_R,@TPythonInterfacePyModule_GetName_W,'PyModule_GetName');
    RegisterPropertyHelper(@TPythonInterfacePyModule_New_R,@TPythonInterfacePyModule_New_W,'PyModule_New');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Absolute_R,@TPythonInterfacePyNumber_Absolute_W,'PyNumber_Absolute');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Add_R,@TPythonInterfacePyNumber_Add_W,'PyNumber_Add');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_And_R,@TPythonInterfacePyNumber_And_W,'PyNumber_And');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Check_R,@TPythonInterfacePyNumber_Check_W,'PyNumber_Check');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_FloorDivide_R,@TPythonInterfacePyNumber_FloorDivide_W,'PyNumber_FloorDivide');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_TrueDivide_R,@TPythonInterfacePyNumber_TrueDivide_W,'PyNumber_TrueDivide');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Divmod_R,@TPythonInterfacePyNumber_Divmod_W,'PyNumber_Divmod');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Float_R,@TPythonInterfacePyNumber_Float_W,'PyNumber_Float');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Invert_R,@TPythonInterfacePyNumber_Invert_W,'PyNumber_Invert');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Long_R,@TPythonInterfacePyNumber_Long_W,'PyNumber_Long');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Lshift_R,@TPythonInterfacePyNumber_Lshift_W,'PyNumber_Lshift');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Multiply_R,@TPythonInterfacePyNumber_Multiply_W,'PyNumber_Multiply');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Negative_R,@TPythonInterfacePyNumber_Negative_W,'PyNumber_Negative');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Or_R,@TPythonInterfacePyNumber_Or_W,'PyNumber_Or');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Positive_R,@TPythonInterfacePyNumber_Positive_W,'PyNumber_Positive');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Power_R,@TPythonInterfacePyNumber_Power_W,'PyNumber_Power');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Remainder_R,@TPythonInterfacePyNumber_Remainder_W,'PyNumber_Remainder');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Rshift_R,@TPythonInterfacePyNumber_Rshift_W,'PyNumber_Rshift');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Subtract_R,@TPythonInterfacePyNumber_Subtract_W,'PyNumber_Subtract');
    RegisterPropertyHelper(@TPythonInterfacePyNumber_Xor_R,@TPythonInterfacePyNumber_Xor_W,'PyNumber_Xor');
    RegisterPropertyHelper(@TPythonInterfacePyOS_InterruptOccurred_R,@TPythonInterfacePyOS_InterruptOccurred_W,'PyOS_InterruptOccurred');
    RegisterPropertyHelper(@TPythonInterfacePyObject_CallObject_R,@TPythonInterfacePyObject_CallObject_W,'PyObject_CallObject');
    RegisterPropertyHelper(@TPythonInterfacePyObject_RichCompare_R,@TPythonInterfacePyObject_RichCompare_W,'PyObject_RichCompare');
    RegisterPropertyHelper(@TPythonInterfacePyObject_RichCompareBool_R,@TPythonInterfacePyObject_RichCompareBool_W,'PyObject_RichCompareBool');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GetAttr_R,@TPythonInterfacePyObject_GetAttr_W,'PyObject_GetAttr');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GetAttrString_R,@TPythonInterfacePyObject_GetAttrString_W,'PyObject_GetAttrString');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GetItem_R,@TPythonInterfacePyObject_GetItem_W,'PyObject_GetItem');
    RegisterPropertyHelper(@TPythonInterfacePyObject_DelItem_R,@TPythonInterfacePyObject_DelItem_W,'PyObject_DelItem');
    RegisterPropertyHelper(@TPythonInterfacePyObject_HasAttrString_R,@TPythonInterfacePyObject_HasAttrString_W,'PyObject_HasAttrString');
    RegisterPropertyHelper(@TPythonInterfacePyObject_Hash_R,@TPythonInterfacePyObject_Hash_W,'PyObject_Hash');
    RegisterPropertyHelper(@TPythonInterfacePyObject_IsTrue_R,@TPythonInterfacePyObject_IsTrue_W,'PyObject_IsTrue');
    RegisterPropertyHelper(@TPythonInterfacePyObject_Length_R,@TPythonInterfacePyObject_Length_W,'PyObject_Length');
    RegisterPropertyHelper(@TPythonInterfacePyObject_Repr_R,@TPythonInterfacePyObject_Repr_W,'PyObject_Repr');
    RegisterPropertyHelper(@TPythonInterfacePyObject_SetAttr_R,@TPythonInterfacePyObject_SetAttr_W,'PyObject_SetAttr');
    RegisterPropertyHelper(@TPythonInterfacePyObject_SetAttrString_R,@TPythonInterfacePyObject_SetAttrString_W,'PyObject_SetAttrString');
    RegisterPropertyHelper(@TPythonInterfacePyObject_SetItem_R,@TPythonInterfacePyObject_SetItem_W,'PyObject_SetItem');
    RegisterPropertyHelper(@TPythonInterfacePyObject_Init_R,@TPythonInterfacePyObject_Init_W,'PyObject_Init');
    RegisterPropertyHelper(@TPythonInterfacePyObject_InitVar_R,@TPythonInterfacePyObject_InitVar_W,'PyObject_InitVar');
    RegisterPropertyHelper(@TPythonInterfacePyObject_New_R,@TPythonInterfacePyObject_New_W,'PyObject_New');
    RegisterPropertyHelper(@TPythonInterfacePyObject_NewVar_R,@TPythonInterfacePyObject_NewVar_W,'PyObject_NewVar');
    RegisterPropertyHelper(@TPythonInterfacePyObject_Free_R,@TPythonInterfacePyObject_Free_W,'PyObject_Free');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GetIter_R,@TPythonInterfacePyObject_GetIter_W,'PyObject_GetIter');
    RegisterPropertyHelper(@TPythonInterfacePyIter_Next_R,@TPythonInterfacePyIter_Next_W,'PyIter_Next');
    RegisterPropertyHelper(@TPythonInterfacePyObject_IsInstance_R,@TPythonInterfacePyObject_IsInstance_W,'PyObject_IsInstance');
    RegisterPropertyHelper(@TPythonInterfacePyObject_IsSubclass_R,@TPythonInterfacePyObject_IsSubclass_W,'PyObject_IsSubclass');
    RegisterPropertyHelper(@TPythonInterfacePyObject_Call_R,@TPythonInterfacePyObject_Call_W,'PyObject_Call');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GenericGetAttr_R,@TPythonInterfacePyObject_GenericGetAttr_W,'PyObject_GenericGetAttr');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GenericSetAttr_R,@TPythonInterfacePyObject_GenericSetAttr_W,'PyObject_GenericSetAttr');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GC_Malloc_R,@TPythonInterfacePyObject_GC_Malloc_W,'PyObject_GC_Malloc');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GC_New_R,@TPythonInterfacePyObject_GC_New_W,'PyObject_GC_New');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GC_NewVar_R,@TPythonInterfacePyObject_GC_NewVar_W,'PyObject_GC_NewVar');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GC_Resize_R,@TPythonInterfacePyObject_GC_Resize_W,'PyObject_GC_Resize');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GC_Del_R,@TPythonInterfacePyObject_GC_Del_W,'PyObject_GC_Del');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GC_Track_R,@TPythonInterfacePyObject_GC_Track_W,'PyObject_GC_Track');
    RegisterPropertyHelper(@TPythonInterfacePyObject_GC_UnTrack_R,@TPythonInterfacePyObject_GC_UnTrack_W,'PyObject_GC_UnTrack');
    RegisterPropertyHelper(@TPythonInterfacePySequence_Check_R,@TPythonInterfacePySequence_Check_W,'PySequence_Check');
    RegisterPropertyHelper(@TPythonInterfacePySequence_Concat_R,@TPythonInterfacePySequence_Concat_W,'PySequence_Concat');
    RegisterPropertyHelper(@TPythonInterfacePySequence_Count_R,@TPythonInterfacePySequence_Count_W,'PySequence_Count');
    RegisterPropertyHelper(@TPythonInterfacePySequence_GetItem_R,@TPythonInterfacePySequence_GetItem_W,'PySequence_GetItem');
    RegisterPropertyHelper(@TPythonInterfacePySequence_GetSlice_R,@TPythonInterfacePySequence_GetSlice_W,'PySequence_GetSlice');
    RegisterPropertyHelper(@TPythonInterfacePySequence_In_R,@TPythonInterfacePySequence_In_W,'PySequence_In');
    RegisterPropertyHelper(@TPythonInterfacePySequence_Index_R,@TPythonInterfacePySequence_Index_W,'PySequence_Index');
    RegisterPropertyHelper(@TPythonInterfacePySequence_Length_R,@TPythonInterfacePySequence_Length_W,'PySequence_Length');
    RegisterPropertyHelper(@TPythonInterfacePySequence_Repeat_R,@TPythonInterfacePySequence_Repeat_W,'PySequence_Repeat');
    RegisterPropertyHelper(@TPythonInterfacePySequence_SetItem_R,@TPythonInterfacePySequence_SetItem_W,'PySequence_SetItem');
    RegisterPropertyHelper(@TPythonInterfacePySequence_SetSlice_R,@TPythonInterfacePySequence_SetSlice_W,'PySequence_SetSlice');
    RegisterPropertyHelper(@TPythonInterfacePySequence_DelSlice_R,@TPythonInterfacePySequence_DelSlice_W,'PySequence_DelSlice');
    RegisterPropertyHelper(@TPythonInterfacePySequence_Tuple_R,@TPythonInterfacePySequence_Tuple_W,'PySequence_Tuple');
    RegisterPropertyHelper(@TPythonInterfacePySequence_Contains_R,@TPythonInterfacePySequence_Contains_W,'PySequence_Contains');
    RegisterPropertyHelper(@TPythonInterfacePySequence_List_R,@TPythonInterfacePySequence_List_W,'PySequence_List');
    RegisterPropertyHelper(@TPythonInterfacePySeqIter_New_R,@TPythonInterfacePySeqIter_New_W,'PySeqIter_New');
    RegisterPropertyHelper(@TPythonInterfacePySlice_GetIndices_R,@TPythonInterfacePySlice_GetIndices_W,'PySlice_GetIndices');
    RegisterPropertyHelper(@TPythonInterfacePySlice_GetIndicesEx_R,@TPythonInterfacePySlice_GetIndicesEx_W,'PySlice_GetIndicesEx');
    RegisterPropertyHelper(@TPythonInterfacePySlice_New_R,@TPythonInterfacePySlice_New_W,'PySlice_New');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_Concat_R,@TPythonInterfacePyBytes_Concat_W,'PyBytes_Concat');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_ConcatAndDel_R,@TPythonInterfacePyBytes_ConcatAndDel_W,'PyBytes_ConcatAndDel');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_FromString_R,@TPythonInterfacePyBytes_FromString_W,'PyBytes_FromString');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_FromStringAndSize_R,@TPythonInterfacePyBytes_FromStringAndSize_W,'PyBytes_FromStringAndSize');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_Size_R,@TPythonInterfacePyBytes_Size_W,'PyBytes_Size');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_DecodeEscape_R,@TPythonInterfacePyBytes_DecodeEscape_W,'PyBytes_DecodeEscape');
    RegisterPropertyHelper(@TPythonInterfacePyBytes_Repr_R,@TPythonInterfacePyBytes_Repr_W,'PyBytes_Repr');
    RegisterPropertyHelper(@TPythonInterfacePySys_GetObject_R,@TPythonInterfacePySys_GetObject_W,'PySys_GetObject');
    RegisterPropertyHelper(@TPythonInterfacePySys_SetObject_R,@TPythonInterfacePySys_SetObject_W,'PySys_SetObject');
    RegisterPropertyHelper(@TPythonInterfacePySys_SetPath_R,@TPythonInterfacePySys_SetPath_W,'PySys_SetPath');
    RegisterPropertyHelper(@TPythonInterfacePyTraceBack_Here_R,@TPythonInterfacePyTraceBack_Here_W,'PyTraceBack_Here');
    RegisterPropertyHelper(@TPythonInterfacePyTraceBack_Print_R,@TPythonInterfacePyTraceBack_Print_W,'PyTraceBack_Print');
    RegisterPropertyHelper(@TPythonInterfacePyTuple_GetItem_R,@TPythonInterfacePyTuple_GetItem_W,'PyTuple_GetItem');
    RegisterPropertyHelper(@TPythonInterfacePyTuple_GetSlice_R,@TPythonInterfacePyTuple_GetSlice_W,'PyTuple_GetSlice');
    RegisterPropertyHelper(@TPythonInterfacePyTuple_New_R,@TPythonInterfacePyTuple_New_W,'PyTuple_New');
    RegisterPropertyHelper(@TPythonInterfacePyTuple_SetItem_R,@TPythonInterfacePyTuple_SetItem_W,'PyTuple_SetItem');
    RegisterPropertyHelper(@TPythonInterfacePyTuple_Size_R,@TPythonInterfacePyTuple_Size_W,'PyTuple_Size');
    RegisterPropertyHelper(@TPythonInterfacePyType_IsSubtype_R,@TPythonInterfacePyType_IsSubtype_W,'PyType_IsSubtype');
    RegisterPropertyHelper(@TPythonInterfacePyType_GenericAlloc_R,@TPythonInterfacePyType_GenericAlloc_W,'PyType_GenericAlloc');
    RegisterPropertyHelper(@TPythonInterfacePyType_GenericNew_R,@TPythonInterfacePyType_GenericNew_W,'PyType_GenericNew');
    RegisterPropertyHelper(@TPythonInterfacePyType_Ready_R,@TPythonInterfacePyType_Ready_W,'PyType_Ready');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_FromWideChar_R,@TPythonInterfacePyUnicode_FromWideChar_W,'PyUnicode_FromWideChar');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_FromString_R,@TPythonInterfacePyUnicode_FromString_W,'PyUnicode_FromString');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_FromStringAndSize_R,@TPythonInterfacePyUnicode_FromStringAndSize_W,'PyUnicode_FromStringAndSize');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_FromKindAndData_R,@TPythonInterfacePyUnicode_FromKindAndData_W,'PyUnicode_FromKindAndData');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_AsWideChar_R,@TPythonInterfacePyUnicode_AsWideChar_W,'PyUnicode_AsWideChar');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_AsUTF8_R,@TPythonInterfacePyUnicode_AsUTF8_W,'PyUnicode_AsUTF8');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_AsUTF8AndSize_R,@TPythonInterfacePyUnicode_AsUTF8AndSize_W,'PyUnicode_AsUTF8AndSize');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_Decode_R,@TPythonInterfacePyUnicode_Decode_W,'PyUnicode_Decode');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_DecodeUTF16_R,@TPythonInterfacePyUnicode_DecodeUTF16_W,'PyUnicode_DecodeUTF16');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_AsEncodedString_R,@TPythonInterfacePyUnicode_AsEncodedString_W,'PyUnicode_AsEncodedString');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_FromOrdinal_R,@TPythonInterfacePyUnicode_FromOrdinal_W,'PyUnicode_FromOrdinal');
    RegisterPropertyHelper(@TPythonInterfacePyUnicode_GetSize_R,@TPythonInterfacePyUnicode_GetSize_W,'PyUnicode_GetSize');
    RegisterPropertyHelper(@TPythonInterfacePyWeakref_GetObject_R,@TPythonInterfacePyWeakref_GetObject_W,'PyWeakref_GetObject');
    RegisterPropertyHelper(@TPythonInterfacePyWeakref_NewProxy_R,@TPythonInterfacePyWeakref_NewProxy_W,'PyWeakref_NewProxy');
    RegisterPropertyHelper(@TPythonInterfacePyWeakref_NewRef_R,@TPythonInterfacePyWeakref_NewRef_W,'PyWeakref_NewRef');
    RegisterPropertyHelper(@TPythonInterfacePyWrapper_New_R,@TPythonInterfacePyWrapper_New_W,'PyWrapper_New');
    RegisterPropertyHelper(@TPythonInterfacePyBool_FromLong_R,@TPythonInterfacePyBool_FromLong_W,'PyBool_FromLong');
    RegisterPropertyHelper(@TPythonInterfacePyThreadState_SetAsyncExc_R,@TPythonInterfacePyThreadState_SetAsyncExc_W,'PyThreadState_SetAsyncExc');
    RegisterPropertyHelper(@TPythonInterfacePy_AtExit_R,@TPythonInterfacePy_AtExit_W,'Py_AtExit');
    RegisterPropertyHelper(@TPythonInterfacePy_CompileStringExFlags_R,@TPythonInterfacePy_CompileStringExFlags_W,'Py_CompileStringExFlags');
    RegisterPropertyHelper(@TPythonInterfacePy_FatalError_R,@TPythonInterfacePy_FatalError_W,'Py_FatalError');
    RegisterPropertyHelper(@TPythonInterface_PyObject_New_R,@TPythonInterface_PyObject_New_W,'_PyObject_New');
    RegisterPropertyHelper(@TPythonInterface_PyBytes_Resize_R,@TPythonInterface_PyBytes_Resize_W,'_PyBytes_Resize');
    RegisterPropertyHelper(@TPythonInterfacePy_Finalize_R,@TPythonInterfacePy_Finalize_W,'Py_Finalize');
    RegisterPropertyHelper(@TPythonInterfacePyErr_ExceptionMatches_R,@TPythonInterfacePyErr_ExceptionMatches_W,'PyErr_ExceptionMatches');
    RegisterPropertyHelper(@TPythonInterfacePyErr_GivenExceptionMatches_R,@TPythonInterfacePyErr_GivenExceptionMatches_W,'PyErr_GivenExceptionMatches');
    RegisterPropertyHelper(@TPythonInterfacePyEval_EvalCode_R,@TPythonInterfacePyEval_EvalCode_W,'PyEval_EvalCode');
    RegisterPropertyHelper(@TPythonInterfacePy_GetVersion_R,@TPythonInterfacePy_GetVersion_W,'Py_GetVersion');
    RegisterPropertyHelper(@TPythonInterfacePy_GetCopyright_R,@TPythonInterfacePy_GetCopyright_W,'Py_GetCopyright');
    RegisterPropertyHelper(@TPythonInterfacePy_GetExecPrefix_R,@TPythonInterfacePy_GetExecPrefix_W,'Py_GetExecPrefix');
    RegisterPropertyHelper(@TPythonInterfacePy_GetPath_R,@TPythonInterfacePy_GetPath_W,'Py_GetPath');
    RegisterPropertyHelper(@TPythonInterfacePy_SetPythonHome_R,@TPythonInterfacePy_SetPythonHome_W,'Py_SetPythonHome');
    RegisterPropertyHelper(@TPythonInterfacePy_GetPythonHome_R,@TPythonInterfacePy_GetPythonHome_W,'Py_GetPythonHome');
    RegisterPropertyHelper(@TPythonInterfacePy_GetPrefix_R,@TPythonInterfacePy_GetPrefix_W,'Py_GetPrefix');
    RegisterPropertyHelper(@TPythonInterfacePy_GetProgramName_R,@TPythonInterfacePy_GetProgramName_W,'Py_GetProgramName');
    RegisterPropertyHelper(@TPythonInterfacePyParser_SimpleParseStringFlags_R,@TPythonInterfacePyParser_SimpleParseStringFlags_W,'PyParser_SimpleParseStringFlags');
    RegisterPropertyHelper(@TPythonInterfacePyNode_Free_R,@TPythonInterfacePyNode_Free_W,'PyNode_Free');
    RegisterPropertyHelper(@TPythonInterfacePyErr_NewException_R,@TPythonInterfacePyErr_NewException_W,'PyErr_NewException');
    RegisterPropertyHelper(@TPythonInterfacePyMem_Malloc_R,@TPythonInterfacePyMem_Malloc_W,'PyMem_Malloc');
    RegisterPropertyHelper(@TPythonInterfacePy_SetProgramName_R,@TPythonInterfacePy_SetProgramName_W,'Py_SetProgramName');
    RegisterPropertyHelper(@TPythonInterfacePy_IsInitialized_R,@TPythonInterfacePy_IsInitialized_W,'Py_IsInitialized');
    RegisterPropertyHelper(@TPythonInterfacePy_GetProgramFullPath_R,@TPythonInterfacePy_GetProgramFullPath_W,'Py_GetProgramFullPath');
    RegisterPropertyHelper(@TPythonInterfacePy_NewInterpreter_R,@TPythonInterfacePy_NewInterpreter_W,'Py_NewInterpreter');
    RegisterPropertyHelper(@TPythonInterfacePy_EndInterpreter_R,@TPythonInterfacePy_EndInterpreter_W,'Py_EndInterpreter');
    RegisterPropertyHelper(@TPythonInterfacePyEval_AcquireLock_R,@TPythonInterfacePyEval_AcquireLock_W,'PyEval_AcquireLock');
    RegisterPropertyHelper(@TPythonInterfacePyEval_ReleaseLock_R,@TPythonInterfacePyEval_ReleaseLock_W,'PyEval_ReleaseLock');
    RegisterPropertyHelper(@TPythonInterfacePyEval_AcquireThread_R,@TPythonInterfacePyEval_AcquireThread_W,'PyEval_AcquireThread');
    RegisterPropertyHelper(@TPythonInterfacePyEval_ReleaseThread_R,@TPythonInterfacePyEval_ReleaseThread_W,'PyEval_ReleaseThread');
    RegisterPropertyHelper(@TPythonInterfacePyInterpreterState_New_R,@TPythonInterfacePyInterpreterState_New_W,'PyInterpreterState_New');
    RegisterPropertyHelper(@TPythonInterfacePyInterpreterState_Clear_R,@TPythonInterfacePyInterpreterState_Clear_W,'PyInterpreterState_Clear');
    RegisterPropertyHelper(@TPythonInterfacePyInterpreterState_Delete_R,@TPythonInterfacePyInterpreterState_Delete_W,'PyInterpreterState_Delete');
    RegisterPropertyHelper(@TPythonInterfacePyThreadState_New_R,@TPythonInterfacePyThreadState_New_W,'PyThreadState_New');
    RegisterPropertyHelper(@TPythonInterfacePyThreadState_Clear_R,@TPythonInterfacePyThreadState_Clear_W,'PyThreadState_Clear');
    RegisterPropertyHelper(@TPythonInterfacePyThreadState_Delete_R,@TPythonInterfacePyThreadState_Delete_W,'PyThreadState_Delete');
    RegisterPropertyHelper(@TPythonInterfacePyThreadState_Get_R,@TPythonInterfacePyThreadState_Get_W,'PyThreadState_Get');
    RegisterPropertyHelper(@TPythonInterfacePyThreadState_Swap_R,@TPythonInterfacePyThreadState_Swap_W,'PyThreadState_Swap');
    RegisterPropertyHelper(@TPythonInterfacePyErr_SetInterrupt_R,@TPythonInterfacePyErr_SetInterrupt_W,'PyErr_SetInterrupt');
    }
    //RegisterPropertyHelper(@TPythonInterfacePyGILState_Ensure_R,@TPythonInterfacePyGILState_Ensure_W,'PyGILState_Ensure');
    //RegisterPropertyHelper(@TPythonInterfacePyGILState_Release_R,@TPythonInterfacePyGILState_Release_W,'PyGILState_Release');


    RegisterMethod(@TPythonInterface.PyParser_SimpleParseString, 'PyParser_SimpleParseString');
    RegisterMethod(@TPythonInterface.Py_CompileString, 'Py_CompileString');
    RegisterMethod(@TPythonInterface.Py_INCREF, 'Py_INCREF');
    RegisterMethod(@TPythonInterface.Py_DECREF, 'Py_DECREF');
    RegisterMethod(@TPythonInterface.Py_XINCREF, 'Py_XINCREF');
    RegisterMethod(@TPythonInterface.Py_XDECREF, 'Py_XDECREF');
    RegisterMethod(@TPythonInterface.Py_CLEAR, 'Py_CLEAR');
    RegisterMethod(@TPythonInterface.PyBytes_Check, 'PyBytes_Check');
    RegisterMethod(@TPythonInterface.PyBytes_CheckExact, 'PyBytes_CheckExact');
    RegisterMethod(@TPythonInterface.PyFloat_Check, 'PyFloat_Check');
    RegisterMethod(@TPythonInterface.PyFloat_CheckExact, 'PyFloat_CheckExact');
    RegisterMethod(@TPythonInterface.PyLong_Check, 'PyLong_Check');
    RegisterMethod(@TPythonInterface.PyLong_CheckExact, 'PyLong_CheckExact');
    RegisterMethod(@TPythonInterface.PyTuple_Check, 'PyTuple_Check');
    RegisterMethod(@TPythonInterface.PyTuple_CheckExact, 'PyTuple_CheckExact');
    RegisterMethod(@TPythonInterface.PyClass_Check, 'PyClass_Check');
    RegisterMethod(@TPythonInterface.PyType_CheckExact, 'PyType_CheckExact');
    RegisterMethod(@TPythonInterface.PyMethod_Check, 'PyMethod_Check');
    RegisterMethod(@TPythonInterface.PyList_Check, 'PyList_Check');
    RegisterMethod(@TPythonInterface.PyList_CheckExact, 'PyList_CheckExact');
    RegisterMethod(@TPythonInterface.PyDict_Check, 'PyDict_Check');
    RegisterMethod(@TPythonInterface.PyDict_CheckExact, 'PyDict_CheckExact');
    RegisterMethod(@TPythonInterface.PyModule_Check, 'PyModule_Check');
    RegisterMethod(@TPythonInterface.PyModule_CheckExact, 'PyModule_CheckExact');
    RegisterMethod(@TPythonInterface.PySlice_Check, 'PySlice_Check');
    RegisterMethod(@TPythonInterface.PyFunction_Check, 'PyFunction_Check');
    RegisterMethod(@TPythonInterface.PyIter_Check, 'PyIter_Check');
    RegisterMethod(@TPythonInterface.PyUnicode_Check, 'PyUnicode_Check');
    RegisterMethod(@TPythonInterface.PyUnicode_CheckExact, 'PyUnicode_CheckExact');
    RegisterMethod(@TPythonInterface.PyType_IS_GC, 'PyType_IS_GC');
    RegisterMethod(@TPythonInterface.PyObject_IS_GC, 'PyObject_IS_GC');
    RegisterMethod(@TPythonInterface.PyWeakref_Check, 'PyWeakref_Check');
    RegisterMethod(@TPythonInterface.PyWeakref_CheckRef, 'PyWeakref_CheckRef');
    RegisterMethod(@TPythonInterface.PyWeakref_CheckProxy, 'PyWeakref_CheckProxy');
    RegisterMethod(@TPythonInterface.PyBool_Check, 'PyBool_Check');
    RegisterMethod(@TPythonInterface.PyEnum_Check, 'PyEnum_Check');
    RegisterMethod(@TPythonInterface.PyObject_TypeCheck, 'PyObject_TypeCheck');
    RegisterMethod(@TPythonInterface.Py_InitModule, 'Py_InitModule');
    RegisterMethod(@TPythonInterface.MapDll, 'MapDll');
    RegisterPropertyHelper(@TPythonInterfaceInitialized_R,nil,'Initialized');
    RegisterPropertyHelper(@TPythonInterfaceFinalizing_R,nil,'Finalizing');
    RegisterPropertyHelper(@TPythonInterfaceMajorVersion_R,nil,'MajorVersion');
    RegisterPropertyHelper(@TPythonInterfaceMinorVersion_R,nil,'MinorVersion');
    RegisterPropertyHelper(@TPythonInterfaceBuiltInModuleName_R,@TPythonInterfaceBuiltInModuleName_W,'BuiltInModuleName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDynamicDll(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDynamicDll) do
  begin
    RegisterConstructor(@TDynamicDll.Create, 'Create');
    RegisterMethod(@TDynamicDll.Destroy, 'Free');
    RegisterMethod(@TDynamicDll.OpenDll, 'OpenDll');
    RegisterMethod(@TDynamicDll.IsHandleValid, 'IsHandleValid');
    RegisterMethod(@TDynamicDll.LoadDll, 'LoadDll');
    RegisterMethod(@TDynamicDll.UnloadDll, 'UnloadDll');
    RegisterMethod(@TDynamicDll.Quit, 'Quit');
    RegisterPropertyHelper(@TDynamicDllAutoLoad_R,@TDynamicDllAutoLoad_W,'AutoLoad');
    RegisterPropertyHelper(@TDynamicDllAutoUnload_R,@TDynamicDllAutoUnload_W,'AutoUnload');
    RegisterPropertyHelper(@TDynamicDllDllName_R,@TDynamicDllDllName_W,'DllName');
    RegisterPropertyHelper(@TDynamicDllDllPath_R,@TDynamicDllDllPath_W,'DllPath');
    RegisterPropertyHelper(@TDynamicDllAPIVersion_R,@TDynamicDllAPIVersion_W,'APIVersion');
    RegisterPropertyHelper(@TDynamicDllRegVersion_R,@TDynamicDllRegVersion_W,'RegVersion');
    RegisterPropertyHelper(@TDynamicDllFatalAbort_R,@TDynamicDllFatalAbort_W,'FatalAbort');
    RegisterPropertyHelper(@TDynamicDllFatalMsgDlg_R,@TDynamicDllFatalMsgDlg_W,'FatalMsgDlg');
    RegisterPropertyHelper(@TDynamicDllUseLastKnownVersion_R,@TDynamicDllUseLastKnownVersion_W,'UseLastKnownVersion');
    RegisterPropertyHelper(@TDynamicDllOnAfterLoad_R,@TDynamicDllOnAfterLoad_W,'OnAfterLoad');
    RegisterPropertyHelper(@TDynamicDllOnBeforeLoad_R,@TDynamicDllOnBeforeLoad_W,'OnBeforeLoad');
    RegisterPropertyHelper(@TDynamicDllOnBeforeUnload_R,@TDynamicDllOnBeforeUnload_W,'OnBeforeUnload');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPythonInputOutput(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPythonInputOutput) do
  begin
    RegisterConstructor(@TPythonInputOutput.Create, 'Create');
    RegisterMethod(@TPythonInputOutput.Destroy, 'Free');
    RegisterMethod(@TPythonInputOutput.Write, 'Write');
    RegisterMethod(@TPythonInputOutput.WriteLine, 'WriteLine');
    RegisterPropertyHelper(@TPythonInputOutputMaxLines_R,@TPythonInputOutputMaxLines_W,'MaxLines');
    RegisterPropertyHelper(@TPythonInputOutputMaxLineLength_R,@TPythonInputOutputMaxLineLength_W,'MaxLineLength');
    RegisterPropertyHelper(@TPythonInputOutputDelayWrites_R,@TPythonInputOutputDelayWrites_W,'DelayWrites');
    RegisterPropertyHelper(@TPythonInputOutputOnSendData_R,@TPythonInputOutputOnSendData_W,'OnSendData');
    RegisterPropertyHelper(@TPythonInputOutputOnReceiveData_R,@TPythonInputOutputOnReceiveData_W,'OnReceiveData');
    RegisterPropertyHelper(@TPythonInputOutputOnSendUniData_R,@TPythonInputOutputOnSendUniData_W,'OnSendUniData');
    RegisterPropertyHelper(@TPythonInputOutputOnReceiveUniData_R,@TPythonInputOutputOnReceiveUniData_W,'OnReceiveUniData');
    RegisterPropertyHelper(@TPythonInputOutputUnicodeIO_R,@TPythonInputOutputUnicodeIO_W,'UnicodeIO');
    RegisterPropertyHelper(@TPythonInputOutputRawOutput_R,@TPythonInputOutputRawOutput_W,'RawOutput');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EPySyntaxError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EPySyntaxError) do
  begin
    RegisterPropertyHelper(@EPySyntaxErrorEFileName_R,@EPySyntaxErrorEFileName_W,'EFileName');
    RegisterPropertyHelper(@EPySyntaxErrorELineStr_R,@EPySyntaxErrorELineStr_W,'ELineStr');
    RegisterPropertyHelper(@EPySyntaxErrorELineNumber_R,@EPySyntaxErrorELineNumber_W,'ELineNumber');
    RegisterPropertyHelper(@EPySyntaxErrorEOffset_R,@EPySyntaxErrorEOffset_W,'EOffset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EPythonError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EPythonError) do
  begin
    RegisterPropertyHelper(@EPythonErrorEName_R,@EPythonErrorEName_W,'EName');
    RegisterPropertyHelper(@EPythonErrorEValue_R,@EPythonErrorEValue_W,'EValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EDLLImportError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDLLImportError) do
  begin
    RegisterPropertyHelper(@EDLLImportErrorWrongFunc_R,@EDLLImportErrorWrongFunc_W,'WrongFunc');
    RegisterPropertyHelper(@EDLLImportErrorErrorCode_R,@EDLLImportErrorErrorCode_W,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PythonEngine(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EDLLLoadError) do
  RIRegister_EDLLImportError(CL);
  RIRegister_EPythonError(CL);
  with CL.Add(EPyExecError) do
  with CL.Add(EPyException) do
  with CL.Add(EPyStandardError) do
  with CL.Add(EPyArithmeticError) do
  with CL.Add(EPyLookupError) do
  with CL.Add(EPyAssertionError) do
  with CL.Add(EPyAttributeError) do
  with CL.Add(EPyEOFError) do
  with CL.Add(EPyFloatingPointError) do
  with CL.Add(EPyEnvironmentError) do
  with CL.Add(EPyIOError) do
  with CL.Add(EPyOSError) do
  with CL.Add(EPyImportError) do
  with CL.Add(EPyIndexError) do
  with CL.Add(EPyKeyError) do
  with CL.Add(EPyKeyboardInterrupt) do
  with CL.Add(EPyMemoryError) do
  with CL.Add(EPyNameError) do
  with CL.Add(EPyOverflowError) do
  with CL.Add(EPyRuntimeError) do
  with CL.Add(EPyNotImplementedError) do
  RIRegister_EPySyntaxError(CL);
  with CL.Add(EPyIndentationError) do
  with CL.Add(EPyTabError) do
  with CL.Add(EPySystemError) do
  with CL.Add(EPySystemExit) do
  with CL.Add(EPyTypeError) do
  with CL.Add(EPyUnboundLocalError) do
  with CL.Add(EPyValueError) do
  with CL.Add(EPyUnicodeError) do
  with CL.Add(UnicodeEncodeError) do
  with CL.Add(UnicodeDecodeError) do
  with CL.Add(UnicodeTranslateError) do
  with CL.Add(EPyZeroDivisionError) do
  with CL.Add(EPyStopIteration) do
  with CL.Add(EPyWarning) do
  with CL.Add(EPyUserWarning) do
  with CL.Add(EPyDeprecationWarning) do
  with CL.Add(PendingDeprecationWarning) do
  with CL.Add(FutureWarning) do
  with CL.Add(EPySyntaxWarning) do
  with CL.Add(EPyRuntimeWarning) do
  with CL.Add(EPyReferenceError) do
  with CL.Add(EPyWindowsError) do
  RIRegister_TPythonInputOutput(CL);
  RIRegister_TDynamicDll(CL);
  RIRegister_TPythonInterface(CL);
  with CL.Add(TEngineClient) do
  RIRegister_TTracebackItem(CL);
  RIRegister_TPythonTraceback(CL);
  RIRegister_TPythonEngine(CL);
  RIRegister_TEngineClient(CL);
  with CL.Add(TMethodsContainer) do
  with CL.Add(TEventDefs) do
  RIRegister_TEventDef(CL);
  RIRegister_TEventDefs(CL);
  RIRegister_TMethodsContainer(CL);
  RIRegister_TMembersContainer(CL);
  RIRegister_TGetSetContainer(CL);
  with CL.Add(TPythonModule) do
  with CL.Add(TErrors) do
  RIRegister_TParentClassError(CL);
  RIRegister_TError(CL);
  RIRegister_TErrors(CL);
  RIRegister_TPythonModule(CL);
  with CL.Add(TPythonType) do
  RIRegister_TPyObject(CL);
  RIRegister_TTypeServices(CL);
  RIRegister_TPythonType(CL);
  RIRegister_TPythonDelphiVar(CL);
  RIRegister_TPyVar(CL);
  RIRegister_TPythonThread(CL);
end;

 
 
{ TPSImport_PythonEngine }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PythonEngine.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PythonEngine(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PythonEngine.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PythonEngine(ri);
  RIRegister_PythonEngine_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
