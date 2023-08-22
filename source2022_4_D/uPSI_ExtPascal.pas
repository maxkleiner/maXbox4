unit uPSI_ExtPascal;
{
 base class no indy

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
  TPSImport_ExtPascal = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TExtObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TExtObject(CL: TPSPascalCompiler);
procedure SIRegister_TExtThread(CL: TPSPascalCompiler);
procedure SIRegister_ExtPascal(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TExtObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtThread(CL: TPSRuntimeClassImporter);
procedure RIRegister_ExtPascal(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   FCGIApp
  //,IdExtHTTPServer
  ,ExtPascalUtils
  ,ExtPascal
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ExtPascal]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtObjectList') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtObjectList') do begin
    RegisterProperty('Objects', 'TExtObject integer', iptr);
    SetDefaultPropery('Objects');
    RegisterMethod('Constructor CreateSingleton( pAttribute : string)');
    RegisterMethod('Constructor Create( pOwner : TExtObject; pAttribute : string)');
    RegisterMethod('Procedure Add( Obj : TExtObject)');
    RegisterMethod('Function Count : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TExtObject') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TExtObject') do
  begin
    RegisterProperty('IsChild', 'boolean', iptrw);
    RegisterMethod('Constructor CreateInternal( Owner : TExtObject; Attribute : string)');
    RegisterMethod('Constructor Create( Owner : TExtObject)');
    RegisterMethod('Constructor CreateSingleton( Attribute : string)');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Constructor Init5( Method : TExtFunction);');
    RegisterMethod('Constructor Init6( Command : string);');
    RegisterMethod('Function DestroyJS : TExtFunction');
    RegisterMethod('Procedure Free( CallDestroyJS : boolean)');
    RegisterMethod('Procedure Delete');
    RegisterMethod('Procedure DeleteFromGarbage');
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Function JSArray( JSON : string; SquareBracket : boolean) : TExtObjectList');
    RegisterMethod('Function JSObject( JSON : string; ObjectConstructor : string; CurlyBracket : boolean) : TExtObject');
    RegisterMethod('Function JSFunction7( Params, Body : string) : TExtFunction;');
    RegisterMethod('Procedure JSFunction8( Name, Params, Body : string);');
    RegisterMethod('Function JSFunction9( Body : string) : TExtFunction;');
    RegisterMethod('Function JSFunction10( Method : TExtProcedure; Silent : boolean) : TExtFunction;');
    RegisterMethod('Function JSExpression11( Expression : string; MethodsValues : array of const) : integer;');
    RegisterMethod('Function JSExpression12( Method : TExtFunction) : integer;');
    RegisterMethod('Function JSString13( Expression : string; MethodsValues : array of const) : string;');
    RegisterMethod('Function JSString14( Method : TExtFunction) : string;');
    RegisterMethod('Function JSMethod( Method : TExtFunction) : string');
    RegisterMethod('Procedure JSCode( JS : string; pJSName : string; pOwner : string)');
    RegisterMethod('Function Ajax15( MethodName : string; Params : array of const; IsEvent : boolean) : TExtFunction;');
    RegisterMethod('Function Ajax16( Method : TExtProcedure) : TExtFunction;');
    RegisterMethod('Function Ajax17( Method : TExtProcedure; Params : array of const) : TExtFunction;');
    RegisterMethod('Function AjaxExtFunction18( Method : TExtProcedure; Params : array of TExtFunction) : TExtFunction;');
    RegisterMethod('Function AjaxSelection( Method : TExtProcedure; SelectionModel : TExtObject; Attribute, TargetQuery : string; Params : array of const) : TExtFunction');
    RegisterMethod('Function AjaxForms( Method : TExtProcedure; Forms : array of TExtObject) : TExtFunction');
    RegisterMethod('Function RequestDownload19( Method : TExtProcedure) : TExtFunction;');
    RegisterMethod('Function RequestDownload20( Method : TExtProcedure; Params : array of const) : TExtFunction;');
    RegisterMethod('Function MethodURI21( Method : TExtProcedure; Params : array of const) : string;');
    RegisterMethod('Function MethodURI22( Method : TExtProcedure) : string;');
    RegisterMethod('Function MethodURI23( MethodName : string; Params : array of const) : string;');
    RegisterMethod('Function MethodURI24( MethodName : string) : string;');
    RegisterMethod('Function CharsToPixels( Chars : integer) : integer');
    RegisterMethod('Function LinesToPixels( Lines : integer) : integer');
    RegisterProperty('JSName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TFCGIThread', 'TExtThread') do
  with CL.AddClassN(CL.FindClass('TFCGIThread'),'TExtThread') do
  begin
    RegisterProperty('HTMLQuirksMode', 'boolean', iptrw);
    RegisterProperty('Theme', 'string', iptrw);
    RegisterProperty('ExtPath', 'string', iptrw);
    RegisterProperty('ImagePath', 'string', iptrw);
    RegisterProperty('ExtBuild', 'string', iptrw);
    RegisterProperty('Charset', 'string', iptrw);
    RegisterProperty('Language', 'string', iptrw);
    RegisterMethod('Constructor Create( NewSocket : integer)');
    RegisterMethod('Procedure JSCode( JS : string; JSClassName : string; JSName : string; Owner : string)');
    RegisterMethod('Procedure SetStyle( pStyle : string)');
    RegisterMethod('Procedure SetLibrary( pLibrary : string; CSS : boolean; HasDebug : boolean)');
    RegisterMethod('Procedure SetCSS( pCSS : string; Check : boolean)');
    RegisterMethod('Procedure SetIconCls( Cls : array of string)');
    RegisterMethod('Procedure SetCustomJS( JS : string)');
    RegisterMethod('Procedure ErrorMessage( Msg : string; Action : string);');
    RegisterMethod('Procedure ErrorMessage1( Msg : string; Action : TExtFunction);');
    RegisterMethod('Procedure DownloadFile( Name : string; pContentType : string)');
    RegisterMethod('Procedure HandleEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ExtPascal(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TArrayOfString', 'array of string');
  CL.AddTypeS('TArrayOfInteger2', 'array of Integer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtObjectList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtFunction');
  SIRegister_TExtThread(CL);
  SIRegister_TExtObject(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtFunction');
  SIRegister_TExtObjectList(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'THTMLElement');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStyleSheet');
  CL.AddTypeS('TRegExp', 'string');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TCSSRule');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TXMLDocument2');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNodeList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtDataNode');
  CL.AddTypeS('TRegion', 'string');
  CL.AddTypeS('TNativeMenu', 'TExtObject');
  CL.AddTypeS('Tel', 'string');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEvent');
  CL.AddTypeS('TEventObject', 'TEvent');
  CL.AddTypeS('TExtEventObject', 'TEventObject');
  CL.AddTypeS('THTMLNode', 'TExtObject');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TConstructor');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtLibRegion');
  CL.AddTypeS('TvisMode', 'Integer');
  CL.AddTypeS('TThe', 'TExtObject');
  CL.AddTypeS('TThis', 'TExtObject');
  CL.AddTypeS('TairNativeMenu', 'TExtObject');
  CL.AddTypeS('TX1', 'TExtObject');
  CL.AddTypeS('TN1', 'TExtObject');
  CL.AddTypeS('TN2', 'TExtObject');
  CL.AddTypeS('TLayout', 'TExtObject');
  CL.AddTypeS('TId', 'TExtObject');
  CL.AddTypeS('TiPageX', 'TExtObject');
  CL.AddTypeS('TiPageY', 'TExtObject');
  CL.AddTypeS('TExtGridGrid', 'TExtObject');
  CL.AddTypeS('TTreeSelectionModel', 'TExtObject');
  CL.AddTypeS('TSelectionModel', 'TExtObject');
  CL.AddTypeS('TDataSource2', 'TExtObject');
  CL.AddTypeS('TAirNotificationType', 'TExtObject');
  CL.AddTypeS('TIterable', 'TExtObjectList');
  CL.AddTypeS('TAnything', 'TExtObject');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TNodeLists');
  CL.AddTypeS('TArrays', 'TExtObjectList');
  CL.AddTypeS('TExtDirectExceptionEvent', 'TEvent');
  CL.AddTypeS('TExtDirectEvent', 'TEvent');
  CL.AddTypeS('TExtDirectTransaction', 'TExtObject');
  CL.AddTypeS('TDOMElement2', 'TExtObject');
  CL.AddTypeS('TRecord', 'TExtObject');
  CL.AddTypeS('TNull', 'TExtObject');
  CL.AddTypeS('TMisc', 'TExtObject');
  CL.AddTypeS('THashExtObject', 'TExtObject');
  CL.AddTypeS('TXMLElement', 'TExtObject');
  CL.AddTypeS('TExtListView', 'TExtObject');
  CL.AddTypeS('TExtSlider', 'TExtObject');
 CL.AddConstantN('DeclareJS','String').SetString( '/*var*/ ');
 CL.AddConstantN('CommandDelim','Char').SetString( #3);
 CL.AddConstantN('IdentDelim','Char').SetString( #4);
 CL.AddConstantN('JSDelim','Char').SetString( #5);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TExtObjectListObjects_R(Self: TExtObjectList; var T: TExtObject; const t1: integer);
begin T := Self.Objects[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TExtObjectJSName_R(Self: TExtObject; var T: string);
begin T := Self.JSName; end;

(*----------------------------------------------------------------------------*)
Function TExtObjectMethodURI24_P(Self: TExtObject;  MethodName : string) : string;
Begin Result := Self.MethodURI(MethodName); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectMethodURI23_P(Self: TExtObject;  MethodName : string; Params : array of const) : string;
Begin Result := Self.MethodURI(MethodName, Params); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectMethodURI22_P(Self: TExtObject;  Method : TExtProcedure) : string;
Begin Result := Self.MethodURI(Method); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectMethodURI21_P(Self: TExtObject;  Method : TExtProcedure; Params : array of const) : string;
Begin Result := Self.MethodURI(Method, Params); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectRequestDownload20_P(Self: TExtObject;  Method : TExtProcedure; Params : array of const) : TExtFunction;
Begin Result := Self.RequestDownload(Method, Params); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectRequestDownload19_P(Self: TExtObject;  Method : TExtProcedure) : TExtFunction;
Begin Result := Self.RequestDownload(Method); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectAjaxExtFunction18_P(Self: TExtObject;  Method : TExtProcedure; Params : array of TExtFunction) : TExtFunction;
Begin Result := Self.AjaxExtFunction(Method, Params); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectAjax17_P(Self: TExtObject;  Method : TExtProcedure; Params : array of const) : TExtFunction;
Begin Result := Self.Ajax(Method, Params); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectAjax16_P(Self: TExtObject;  Method : TExtProcedure) : TExtFunction;
Begin Result := Self.Ajax(Method); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectAjax15_P(Self: TExtObject;  MethodName : string; Params : array of const; IsEvent : boolean) : TExtFunction;
Begin Result := Self.Ajax(MethodName, Params, IsEvent); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectJSString14_P(Self: TExtObject;  Method : TExtFunction) : string;
Begin Result := Self.JSString(Method); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectJSString13_P(Self: TExtObject;  Expression : string; MethodsValues : array of const) : string;
Begin Result := Self.JSString(Expression, MethodsValues); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectJSExpression12_P(Self: TExtObject;  Method : TExtFunction) : integer;
Begin Result := Self.JSExpression(Method); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectJSExpression11_P(Self: TExtObject;  Expression : string; MethodsValues : array of const) : integer;
Begin Result := Self.JSExpression(Expression, MethodsValues); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectJSFunction10_P(Self: TExtObject;  Method : TExtProcedure; Silent : boolean) : TExtFunction;
Begin Result := Self.JSFunction(Method, Silent); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectJSFunction9_P(Self: TExtObject;  Body : string) : TExtFunction;
Begin Result := Self.JSFunction(Body); END;

(*----------------------------------------------------------------------------*)
Procedure TExtObjectJSFunction8_P(Self: TExtObject;  Name, Params, Body : string);
Begin Self.JSFunction(Name, Params, Body); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectJSFunction7_P(Self: TExtObject;  Params, Body : string) : TExtFunction;
Begin Result := Self.JSFunction(Params, Body); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectInit6_P(Self: TClass; CreateNewInstance: Boolean;  Command : string):TObject;
Begin Result := TExtObject.Init(Command); END;

(*----------------------------------------------------------------------------*)
Function TExtObjectInit5_P(Self: TClass; CreateNewInstance: Boolean;  Method : TExtFunction):TObject;
Begin Result := TExtObject.Init(Method); END;

(*----------------------------------------------------------------------------*)
procedure TExtObjectIsChild_W(Self: TExtObject; const T: boolean);
Begin Self.IsChild := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtObjectIsChild_R(Self: TExtObject; var T: boolean);
Begin T := Self.IsChild; end;

(*----------------------------------------------------------------------------*)
Function TExtObjectVarToJSON4_P(Self: TExtObject;  Exts : TExtObjectList) : string;
Begin //Result := Self.VarToJSON(Exts);
END;

(*----------------------------------------------------------------------------*)
Function TExtObjectVarToJSON3_P(Self: TExtObject;  A : array of const) : string;
Begin //Result := Self.VarToJSON(A);
END;

(*----------------------------------------------------------------------------*)
Function TExtObjectAjax2_P(Self: TExtObject;  Method : TExtProcedure; Params : string) : TExtFunction;
Begin //Result := Self.Ajax(Method, Params);
END;

(*----------------------------------------------------------------------------*)
Procedure TExtThreadErrorMessage1_P(Self: TExtThread;  Msg : string; Action : TExtFunction);
Begin Self.ErrorMessage(Msg, Action); END;

(*----------------------------------------------------------------------------*)
Procedure TExtThreadErrorMessage_P(Self: TExtThread;  Msg : string; Action : string);
Begin Self.ErrorMessage(Msg, Action); END;

(*----------------------------------------------------------------------------*)
procedure TExtThreadLanguage_W(Self: TExtThread; const T: string);
begin Self.Language := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadLanguage_R(Self: TExtThread; var T: string);
begin T := Self.Language; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadCharset_W(Self: TExtThread; const T: string);
Begin Self.Charset := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadCharset_R(Self: TExtThread; var T: string);
Begin T := Self.Charset; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadExtBuild_W(Self: TExtThread; const T: string);
Begin Self.ExtBuild := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadExtBuild_R(Self: TExtThread; var T: string);
Begin T := Self.ExtBuild; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadImagePath_W(Self: TExtThread; const T: string);
Begin Self.ImagePath := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadImagePath_R(Self: TExtThread; var T: string);
Begin T := Self.ImagePath; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadExtPath_W(Self: TExtThread; const T: string);
Begin Self.ExtPath := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadExtPath_R(Self: TExtThread; var T: string);
Begin T := Self.ExtPath; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadTheme_W(Self: TExtThread; const T: string);
Begin Self.Theme := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadTheme_R(Self: TExtThread; var T: string);
Begin T := Self.Theme; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadHTMLQuirksMode_W(Self: TExtThread; const T: boolean);
Begin Self.HTMLQuirksMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtThreadHTMLQuirksMode_R(Self: TExtThread; var T: boolean);
Begin T := Self.HTMLQuirksMode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtObjectList) do begin
    RegisterPropertyHelper(@TExtObjectListObjects_R,nil,'Objects');
    RegisterConstructor(@TExtObjectList.CreateSingleton, 'CreateSingleton');
    RegisterConstructor(@TExtObjectList.Create, 'Create');
       RegisterMethod(@TExtObjectList.Destroy, 'Free');
      RegisterMethod(@TExtObjectList.Add, 'Add');
    RegisterMethod(@TExtObjectList.Count, 'Count');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtObject) do
  begin
    RegisterPropertyHelper(@TExtObjectIsChild_R,@TExtObjectIsChild_W,'IsChild');
    RegisterConstructor(@TExtObject.CreateInternal, 'CreateInternal');
    RegisterConstructor(@TExtObject.Create, 'Create');
    RegisterConstructor(@TExtObject.CreateSingleton, 'CreateSingleton');
    RegisterConstructor(@TExtObject.AddTo, 'AddTo');
    RegisterConstructor(@TExtObjectInit5_P, 'Init5');
    RegisterConstructor(@TExtObjectInit6_P, 'Init6');
    RegisterVirtualMethod(@TExtObject.DestroyJS, 'DestroyJS');
    RegisterMethod(@TExtObject.Free, 'Free');
    RegisterMethod(@TExtObject.Delete, 'Delete');
    RegisterMethod(@TExtObject.DeleteFromGarbage, 'DeleteFromGarbage');
    RegisterVirtualMethod(@TExtObject.JSClassName, 'JSClassName');
    RegisterMethod(@TExtObject.JSArray, 'JSArray');
    RegisterMethod(@TExtObject.JSObject, 'JSObject');
    RegisterMethod(@TExtObjectJSFunction7_P, 'JSFunction7');
    RegisterMethod(@TExtObjectJSFunction8_P, 'JSFunction8');
    RegisterMethod(@TExtObjectJSFunction9_P, 'JSFunction9');
    RegisterMethod(@TExtObjectJSFunction10_P, 'JSFunction10');
    RegisterMethod(@TExtObjectJSExpression11_P, 'JSExpression11');
    RegisterMethod(@TExtObjectJSExpression12_P, 'JSExpression12');
    RegisterMethod(@TExtObjectJSString13_P, 'JSString13');
    RegisterMethod(@TExtObjectJSString14_P, 'JSString14');
    RegisterMethod(@TExtObject.JSMethod, 'JSMethod');
    RegisterMethod(@TExtObject.JSCode, 'JSCode');
    RegisterMethod(@TExtObjectAjax15_P, 'Ajax15');
    RegisterMethod(@TExtObjectAjax16_P, 'Ajax16');
    RegisterMethod(@TExtObjectAjax17_P, 'Ajax17');
    RegisterMethod(@TExtObjectAjaxExtFunction18_P, 'AjaxExtFunction18');
    RegisterMethod(@TExtObject.AjaxSelection, 'AjaxSelection');
    RegisterMethod(@TExtObject.AjaxForms, 'AjaxForms');
    RegisterMethod(@TExtObjectRequestDownload19_P, 'RequestDownload19');
    RegisterMethod(@TExtObjectRequestDownload20_P, 'RequestDownload20');
    RegisterMethod(@TExtObjectMethodURI21_P, 'MethodURI21');
    RegisterMethod(@TExtObjectMethodURI22_P, 'MethodURI22');
    RegisterMethod(@TExtObjectMethodURI23_P, 'MethodURI23');
    RegisterMethod(@TExtObjectMethodURI24_P, 'MethodURI24');
    RegisterMethod(@TExtObject.CharsToPixels, 'CharsToPixels');
    RegisterMethod(@TExtObject.LinesToPixels, 'LinesToPixels');
    RegisterPropertyHelper(@TExtObjectJSName_R,nil,'JSName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtThread(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtThread) do
  begin
    RegisterPropertyHelper(@TExtThreadHTMLQuirksMode_R,@TExtThreadHTMLQuirksMode_W,'HTMLQuirksMode');
    RegisterPropertyHelper(@TExtThreadTheme_R,@TExtThreadTheme_W,'Theme');
    RegisterPropertyHelper(@TExtThreadExtPath_R,@TExtThreadExtPath_W,'ExtPath');
    RegisterPropertyHelper(@TExtThreadImagePath_R,@TExtThreadImagePath_W,'ImagePath');
    RegisterPropertyHelper(@TExtThreadExtBuild_R,@TExtThreadExtBuild_W,'ExtBuild');
    RegisterPropertyHelper(@TExtThreadCharset_R,@TExtThreadCharset_W,'Charset');
    RegisterPropertyHelper(@TExtThreadLanguage_R,@TExtThreadLanguage_W,'Language');
    RegisterConstructor(@TExtThread.Create, 'Create');
    RegisterMethod(@TExtThread.JSCode, 'JSCode');
    RegisterMethod(@TExtThread.SetStyle, 'SetStyle');
    RegisterMethod(@TExtThread.SetLibrary, 'SetLibrary');
    RegisterMethod(@TExtThread.SetCSS, 'SetCSS');
    RegisterMethod(@TExtThread.SetIconCls, 'SetIconCls');
    RegisterMethod(@TExtThread.SetCustomJS, 'SetCustomJS');
    RegisterMethod(@TExtThreadErrorMessage_P, 'ErrorMessage');
    RegisterMethod(@TExtThreadErrorMessage1_P, 'ErrorMessage1');
    RegisterMethod(@TExtThread.DownloadFile, 'DownloadFile');
    RegisterVirtualMethod(@TExtThread.HandleEvent, 'HandleEvent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ExtPascal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtObjectList) do
  with CL.Add(TExtFunction) do
  RIRegister_TExtThread(CL);
  RIRegister_TExtObject(CL);
  with CL.Add(TExtFunction) do
  RIRegister_TExtObjectList(CL);
  with CL.Add(THTMLElement) do
  with CL.Add(TStyleSheet) do
  with CL.Add(TCSSRule) do
  //with CL.Add(TXMLDocument) do
  with CL.Add(TNodeList) do
  with CL.Add(TExtDataNode) do
  //with CL.Add(TEvent) do
  with CL.Add(TConstructor) do
  with CL.Add(TExtLibRegion) do
  with CL.Add(TNodeLists) do
end;

 
 
{ TPSImport_ExtPascal }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtPascal.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ExtPascal(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtPascal.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ExtPascal(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
