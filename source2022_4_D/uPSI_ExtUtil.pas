unit uPSI_ExtUtil;
{
  for extpascal

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
  TPSImport_ExtUtil = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TExtUtilMixedCollection(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilClickRepeater(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilDelayedTask(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilCookiesSingleton(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilCSSSingleton(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilFormatSingleton(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilTaskRunner(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilTextMetricsSingleton(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilJSONSingleton(CL: TPSPascalCompiler);
procedure SIRegister_TExtUtilObservable(CL: TPSPascalCompiler);
procedure SIRegister_ExtUtil(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TExtUtilMixedCollection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilClickRepeater(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilDelayedTask(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilCookiesSingleton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilCSSSingleton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilFormatSingleton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilTaskRunner(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilTextMetricsSingleton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilJSONSingleton(CL: TPSRuntimeClassImporter);
procedure RIRegister_TExtUtilObservable(CL: TPSRuntimeClassImporter);
procedure RIRegister_ExtUtil(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   StrUtils
  ,ExtPascal
  ,ExtPascalUtils
  ,ExtUtil
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ExtUtil]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilMixedCollection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtUtilObservable', 'TExtUtilMixedCollection') do
  with CL.AddClassN(CL.FindClass('TExtUtilObservable'),'TExtUtilMixedCollection') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Constructor Create( AllowFunctions : Boolean; KeyFn : TExtFunction)');
    RegisterMethod('Function Add( Key : String; O : TExtObject) : TExtFunction');
    RegisterMethod('Function AddAll22( Objs : TExtObject) : TExtFunction;');
    RegisterMethod('Function AddAll23( Objs : TExtObjectList) : TExtFunction;');
    RegisterMethod('Function Clear : TExtFunction');
    RegisterMethod('Function Clone : TExtFunction');
    RegisterMethod('Function Contains( O : TExtObject) : TExtFunction');
    RegisterMethod('Function ContainsKey( Key : String) : TExtFunction');
    RegisterMethod('Function Each( Fn : TExtFunction; Scope : TExtObject) : TExtFunction');
    RegisterMethod('Function EachKey( Fn : TExtFunction; Scope : TExtObject) : TExtFunction');
    RegisterMethod('Function Filter24( PropertyJS : String; Value : String; AnyMatch : Boolean; CaseSensitive : Boolean) : TExtFunction;');
    RegisterMethod('Function Filter25( PropertyJS : String; Value : TRegExp; AnyMatch : Boolean; CaseSensitive : Boolean) : TExtFunction;');
    RegisterMethod('Function FilterBy( Fn : TExtFunction; Scope : TExtObject) : TExtFunction');
    RegisterMethod('Function Find( Fn : TExtFunction; Scope : TExtObject) : TExtFunction');
    RegisterMethod('Function FindIndex26( PropertyJS : String; Value : String; Start : Integer; AnyMatch : Boolean; CaseSensitive : Boolean) : TExtFunction;');
    RegisterMethod('Function FindIndex27( PropertyJS : String; Value : TRegExp; Start : Integer; AnyMatch : Boolean; CaseSensitive : Boolean) : TExtFunction;');
    RegisterMethod('Function FindIndexBy( Fn : TExtFunction; Scope : TExtObject; Start : Integer) : TExtFunction');
    RegisterMethod('Function First : TExtFunction');
    RegisterMethod('Function Get28( Key : String) : TExtFunction;');
    RegisterMethod('Function Get29( Key : Integer) : TExtFunction;');
    RegisterMethod('Function GetCount : TExtFunction');
    RegisterMethod('Function GetKey( Item : TExtObject) : TExtFunction');
    RegisterMethod('Function GetRange( StartIndex : Integer; EndIndex : Integer) : TExtFunction');
    RegisterMethod('Function IndexOf( O : TExtObject) : TExtFunction');
    RegisterMethod('Function IndexOfKey( Key : String) : TExtFunction');
    RegisterMethod('Function Insert( Index : Integer; Key : String; O : TExtObject) : TExtFunction');
    RegisterMethod('Function Item30( Key : String) : TExtFunction;');
    RegisterMethod('Function Item31( Key : Integer) : TExtFunction;');
    RegisterMethod('Function ItemAt( Index : Integer) : TExtFunction');
    RegisterMethod('Function Key32( Key : String) : TExtFunction;');
    RegisterMethod('Function Key33( Key : Integer) : TExtFunction;');
    RegisterMethod('Function KeySort( Direction : String; Fn : TExtFunction) : TExtFunction');
    RegisterMethod('Function Last : TExtFunction');
    RegisterMethod('Function Remove( O : TExtObject) : TExtFunction');
    RegisterMethod('Function RemoveAt( Index : Integer) : TExtFunction');
    RegisterMethod('Function RemoveKey( Key : String) : TExtFunction');
    RegisterMethod('Function Reorder( Mapping : TExtObject) : TExtFunction');
    RegisterMethod('Function Replace( Key : String; O : TExtObject) : TExtFunction');
    RegisterMethod('Function Sort( Direction : String; Fn : TExtFunction) : TExtFunction');
    RegisterProperty('AllowFunctions', 'Boolean', iptrw);
    RegisterProperty('OnAdd', 'TExtUtilMixedCollectionOnAdd', iptrw);
    RegisterProperty('OnClear', 'TExtUtilMixedCollectionOnClear', iptrw);
    RegisterProperty('OnRemove', 'TExtUtilMixedCollectionOnRemove', iptrw);
    RegisterProperty('OnReplace', 'TExtUtilMixedCollectionOnReplace', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilClickRepeater(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtUtilObservable', 'TExtUtilClickRepeater') do
  with CL.AddClassN(CL.FindClass('TExtUtilObservable'),'TExtUtilClickRepeater') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Constructor Create( El : String; Config : TExtObject)');
    RegisterMethod('Function Disable : TExtFunction');
    RegisterMethod('Function Enable : TExtFunction');
    RegisterMethod('Function SetDisabled( Disabled : Boolean) : TExtFunction');
    RegisterProperty('Accelerate', 'Boolean', iptrw);
    RegisterProperty('Delay', 'Integer', iptrw);
    RegisterProperty('El', 'String', iptrw);
    RegisterProperty('Interval', 'Integer', iptrw);
    RegisterProperty('PressClass', 'String', iptrw);
    RegisterProperty('PreventDefault', 'Boolean', iptrw);
    RegisterProperty('StopDefault', 'Boolean', iptrw);
    RegisterProperty('OnClick', 'TExtUtilClickRepeaterOnClick', iptrw);
    RegisterProperty('OnMousedown', 'TExtUtilClickRepeaterOnMousedown', iptrw);
    RegisterProperty('OnMouseup', 'TExtUtilClickRepeaterOnMouseup', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilDelayedTask(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtUtilDelayedTask') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtUtilDelayedTask') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Constructor Create( Fn : TExtFunction; Scope : TExtObject; Args : TExtObjectList)');
    RegisterMethod('Function Cancel : TExtFunction');
    RegisterMethod('Function Delay( Delay : Integer; NewFn : TExtFunction; NewScope : TExtObject; NewArgs : TExtObjectList) : TExtFunction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilCookiesSingleton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtUtilCookiesSingleton') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtUtilCookiesSingleton') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Function Clear( Name : String) : TExtFunction');
    RegisterMethod('Function Get( Name : String) : TExtFunction');
    RegisterMethod('Function SetJS( Name : String; Value : String; Expires : TExtObject; Path : String; Domain : String; Secure : Boolean) : TExtFunction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilCSSSingleton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtUtilCSSSingleton') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtUtilCSSSingleton') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Function CreateStyleSheet( CssText : String; Id : String) : TExtFunction');
    RegisterMethod('Function GetRule18( Selector : String; RefreshCache : Boolean) : TExtFunction;');
    RegisterMethod('Function GetRule19( Selector : TExtObjectList; RefreshCache : Boolean) : TExtFunction;');
    RegisterMethod('Function GetRules( RefreshCache : Boolean) : TExtFunction');
    RegisterMethod('Function RefreshCache : TExtFunction');
    RegisterMethod('Function RemoveStyleSheet( Id : String) : TExtFunction');
    RegisterMethod('Function SwapStyleSheet( Id : String; Url : String) : TExtFunction');
    RegisterMethod('Function UpdateRule20( Selector : String; PropertyJS : String; Value : String) : TExtFunction;');
    RegisterMethod('Function UpdateRule21( Selector : TExtObjectList; PropertyJS : String; Value : String) : TExtFunction;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilFormatSingleton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtUtilFormatSingleton') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtUtilFormatSingleton') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Function Capitalize( Value : String) : TExtFunction');
    RegisterMethod('Function Date10( Value : String; Format : String) : TExtFunction;');
    RegisterMethod('Function Date11( Value : TDateTime; Format : String) : TExtFunction;');
    RegisterMethod('Function DateRenderer( Format : String) : TExtFunction');
    RegisterMethod('Function DefaultValue( Value : String; DefaultValue : String) : TExtFunction');
    RegisterMethod('Function Ellipsis( Value : String; Length : Integer; Word : Boolean) : TExtFunction');
    RegisterMethod('Function FileSize12( Size : Integer) : TExtFunction;');
    RegisterMethod('Function FileSize13( Size : String) : TExtFunction;');
    RegisterMethod('Function HtmlDecode( Value : String) : TExtFunction');
    RegisterMethod('Function HtmlEncode( Value : String) : TExtFunction');
    RegisterMethod('Function Lowercase( Value : String) : TExtFunction');
    RegisterMethod('Function Math : TExtFunction');
    RegisterMethod('Function Nl2br( The : String) : TExtFunction');
    RegisterMethod('Function Number( V : Integer; Format : String) : TExtFunction');
    RegisterMethod('Function NumberRenderer( Format : String) : TExtFunction');
    RegisterMethod('Function Plural( Value : Integer; Singular : String; Plural : String) : TExtFunction');
    RegisterMethod('Function Round14( Value : Integer; Precision : Integer) : TExtFunction;');
    RegisterMethod('Function Round15( Value : String; Precision : Integer) : TExtFunction;');
    RegisterMethod('Function StripScripts( Value : String) : TExtFunction');
    RegisterMethod('Function StripTags( Value : String) : TExtFunction');
    RegisterMethod('Function Substr( Value : String; Start : Integer; Length : Integer) : TExtFunction');
    RegisterMethod('Function Trim( Value : String) : TExtFunction');
    RegisterMethod('Function Undef( Value : String) : TExtFunction');
    RegisterMethod('Function Uppercase( Value : String) : TExtFunction');
    RegisterMethod('Function UsMoney16( Value : Integer) : TExtFunction;');
    RegisterMethod('Function UsMoney17( Value : String) : TExtFunction;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilTaskRunner(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtUtilTaskRunner') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtUtilTaskRunner') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Constructor Create( Interval : Integer)');
    RegisterMethod('Function Start( Task : TExtObject) : TExtFunction');
    RegisterMethod('Function Stop( Task : TExtObject) : TExtFunction');
    RegisterMethod('Function StopAll : TExtFunction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilTextMetricsSingleton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtUtilTextMetricsSingleton') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtUtilTextMetricsSingleton') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Function Bind4( El : String) : TExtFunction;');
    RegisterMethod('Function Bind5( El : THTMLElement) : TExtFunction;');
    RegisterMethod('Function CreateInstance6( El : String; FixedWidth : Integer) : TExtFunction;');
    RegisterMethod('Function CreateInstance7( El : THTMLElement; FixedWidth : Integer) : TExtFunction;');
    RegisterMethod('Function GetHeight( Text : String) : TExtFunction');
    RegisterMethod('Function GetSize( Text : String) : TExtFunction');
    RegisterMethod('Function GetWidth( Text : String) : TExtFunction');
    RegisterMethod('Function Measure8( El : String; Text : String; FixedWidth : Integer) : TExtFunction;');
    RegisterMethod('Function Measure9( El : THTMLElement; Text : String; FixedWidth : Integer) : TExtFunction;');
    RegisterMethod('Function SetFixedWidth( Width : Integer) : TExtFunction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilJSONSingleton(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtUtilJSONSingleton') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtUtilJSONSingleton') do
  begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Function Decode( Json : String) : TExtFunction');
    RegisterMethod('Function Encode( O : String) : TExtFunction');
    RegisterMethod('Function EncodeDate( D : TDateTime) : TExtFunction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TExtUtilObservable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TExtFunction', 'TExtUtilObservable') do
  with CL.AddClassN(CL.FindClass('TExtFunction'),'TExtUtilObservable') do begin
    RegisterMethod('Function JSClassName : string');
    RegisterMethod('Constructor AddTo( List : TExtObjectList)');
    RegisterMethod('Constructor Create');
   RegisterMethod('Procedure Free');
     RegisterMethod('Function ObservableCapture( O : TExtUtilObservable; Fn : TExtFunction; Scope : TExtObject) : TExtFunction');
    RegisterMethod('Function ObservableObserveClass( C : TExtFunction; Listeners : TExtObject) : TExtFunction');
    RegisterMethod('Function ObservableReleaseCapture( O : TExtUtilObservable) : TExtFunction');
    RegisterMethod('Function AddEvents0( O : TExtObject; Optional : String) : TExtFunction;');
    RegisterMethod('Function AddEvents1( O : String; Optional : String) : TExtFunction;');
    RegisterMethod('Function AddListener( EventName : String; Handler : TExtFunction; Scope : TExtObject; Options : TExtObject) : TExtFunction');
    RegisterMethod('Function EnableBubble2( Events : String) : TExtFunction;');
    RegisterMethod('Function EnableBubble3( Events : TExtObjectList) : TExtFunction;');
    RegisterMethod('Function FireEvent( EventName : String; Args : TExtObjectList) : TExtFunction');
    RegisterMethod('Function HasListener( EventName : String) : TExtFunction');
    RegisterMethod('Function On( EventName : String; Handler : TExtFunction; Scope : TExtObject; Options : TExtObject) : TExtFunction');
    RegisterMethod('Function PurgeListeners : TExtFunction');
    RegisterMethod('Function RelayEvents( O : TExtObject; Events : TExtObjectList) : TExtFunction');
    RegisterMethod('Function RemoveListener( EventName : String; Handler : TExtFunction; Scope : TExtObject) : TExtFunction');
    RegisterMethod('Function ResumeEvents : TExtFunction');
    RegisterMethod('Function SuspendEvents( QueueSuspended : Boolean) : TExtFunction');
    RegisterMethod('Function Un( EventName : String; Handler : TExtFunction; Scope : TExtObject) : TExtFunction');
    RegisterProperty('Listeners', 'TExtObject', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ExtUtil(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilObservable');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilJSONSingleton');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilTextMetricsSingleton');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilTaskRunner');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilFormatSingleton');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilCSSSingleton');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilCookiesSingleton');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilDelayedTask');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilClickRepeater');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TExtUtilMixedCollection');
  SIRegister_TExtUtilObservable(CL);
  SIRegister_TExtUtilJSONSingleton(CL);
  SIRegister_TExtUtilTextMetricsSingleton(CL);
  SIRegister_TExtUtilTaskRunner(CL);
  SIRegister_TExtUtilFormatSingleton(CL);
  SIRegister_TExtUtilCSSSingleton(CL);
  SIRegister_TExtUtilCookiesSingleton(CL);
  SIRegister_TExtUtilDelayedTask(CL);
  CL.AddTypeS('TExtUtilClickRepeaterOnClick', 'Procedure ( This : TExtUtilClickRepeater)');
  CL.AddTypeS('TExtUtilClickRepeaterOnMousedown', 'Procedure ( This : TExtUtilClickRepeater)');
  CL.AddTypeS('TExtUtilClickRepeaterOnMouseup', 'Procedure ( This : TExtUtilClickRepeater)');
  SIRegister_TExtUtilClickRepeater(CL);
  CL.AddTypeS('TExtUtilMixedCollectionOnAdd', 'Procedure ( Index : Integer; O : TExtObject; Key : String)');
  CL.AddTypeS('TExtUtilMixedCollectionOnClear', 'Procedure');
  CL.AddTypeS('TExtUtilMixedCollectionOnRemove', 'Procedure ( O : TExtObject; Key : String)');
  CL.AddTypeS('TExtUtilMixedCollectionOnReplace', 'Procedure ( Key : String; Old : TExtObject; New : TExtObject)');
  SIRegister_TExtUtilMixedCollection(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionOnReplace_W(Self: TExtUtilMixedCollection; const T: TExtUtilMixedCollectionOnReplace);
begin Self.OnReplace := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionOnReplace_R(Self: TExtUtilMixedCollection; var T: TExtUtilMixedCollectionOnReplace);
begin T := Self.OnReplace; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionOnRemove_W(Self: TExtUtilMixedCollection; const T: TExtUtilMixedCollectionOnRemove);
begin Self.OnRemove := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionOnRemove_R(Self: TExtUtilMixedCollection; var T: TExtUtilMixedCollectionOnRemove);
begin T := Self.OnRemove; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionOnClear_W(Self: TExtUtilMixedCollection; const T: TExtUtilMixedCollectionOnClear);
begin Self.OnClear := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionOnClear_R(Self: TExtUtilMixedCollection; var T: TExtUtilMixedCollectionOnClear);
begin T := Self.OnClear; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionOnAdd_W(Self: TExtUtilMixedCollection; const T: TExtUtilMixedCollectionOnAdd);
begin Self.OnAdd := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionOnAdd_R(Self: TExtUtilMixedCollection; var T: TExtUtilMixedCollectionOnAdd);
begin T := Self.OnAdd; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionAllowFunctions_W(Self: TExtUtilMixedCollection; const T: Boolean);
begin Self.AllowFunctions := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilMixedCollectionAllowFunctions_R(Self: TExtUtilMixedCollection; var T: Boolean);
begin T := Self.AllowFunctions; end;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionKey33_P(Self: TExtUtilMixedCollection;  Key : Integer) : TExtFunction;
Begin Result := Self.Key(Key); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionKey32_P(Self: TExtUtilMixedCollection;  Key : String) : TExtFunction;
Begin Result := Self.Key(Key); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionItem31_P(Self: TExtUtilMixedCollection;  Key : Integer) : TExtFunction;
Begin Result := Self.Item(Key); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionItem30_P(Self: TExtUtilMixedCollection;  Key : String) : TExtFunction;
Begin Result := Self.Item(Key); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionGet29_P(Self: TExtUtilMixedCollection;  Key : Integer) : TExtFunction;
Begin Result := Self.Get(Key); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionGet28_P(Self: TExtUtilMixedCollection;  Key : String) : TExtFunction;
Begin Result := Self.Get(Key); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionFindIndex27_P(Self: TExtUtilMixedCollection;  PropertyJS : String; Value : TRegExp; Start : Integer; AnyMatch : Boolean; CaseSensitive : Boolean) : TExtFunction;
Begin //Result := Self.FindIndex(PropertyJS, Value, Start, AnyMatch, CaseSensitive);
END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionFindIndex26_P(Self: TExtUtilMixedCollection;  PropertyJS : String; Value : String; Start : Integer; AnyMatch : Boolean; CaseSensitive : Boolean) : TExtFunction;
Begin //Result := Self.FindIndex(PropertyJS, Value, Start, AnyMatch, CaseSensitive);
END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionFilter25_P(Self: TExtUtilMixedCollection;  PropertyJS : String; Value : TRegExp; AnyMatch : Boolean; CaseSensitive : Boolean) : TExtFunction;
Begin //Result := Self.Filter(PropertyJS, Value, AnyMatch, CaseSensitive);
END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionFilter24_P(Self: TExtUtilMixedCollection;  PropertyJS : String; Value : String; AnyMatch : Boolean; CaseSensitive : Boolean) : TExtFunction;
Begin //Result := Self.Filter(PropertyJS, Value, AnyMatch, CaseSensitive);
END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionAddAll23_P(Self: TExtUtilMixedCollection;  Objs : TExtObjectList) : TExtFunction;
Begin Result := Self.AddAll(Objs); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilMixedCollectionAddAll22_P(Self: TExtUtilMixedCollection;  Objs : TExtObject) : TExtFunction;
Begin Result := Self.AddAll(Objs); END;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterOnMouseup_W(Self: TExtUtilClickRepeater; const T: TExtUtilClickRepeaterOnMouseup);
begin Self.OnMouseup := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterOnMouseup_R(Self: TExtUtilClickRepeater; var T: TExtUtilClickRepeaterOnMouseup);
begin T := Self.OnMouseup; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterOnMousedown_W(Self: TExtUtilClickRepeater; const T: TExtUtilClickRepeaterOnMousedown);
begin Self.OnMousedown := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterOnMousedown_R(Self: TExtUtilClickRepeater; var T: TExtUtilClickRepeaterOnMousedown);
begin T := Self.OnMousedown; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterOnClick_W(Self: TExtUtilClickRepeater; const T: TExtUtilClickRepeaterOnClick);
begin Self.OnClick := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterOnClick_R(Self: TExtUtilClickRepeater; var T: TExtUtilClickRepeaterOnClick);
begin T := Self.OnClick; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterStopDefault_W(Self: TExtUtilClickRepeater; const T: Boolean);
begin Self.StopDefault := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterStopDefault_R(Self: TExtUtilClickRepeater; var T: Boolean);
begin T := Self.StopDefault; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterPreventDefault_W(Self: TExtUtilClickRepeater; const T: Boolean);
begin Self.PreventDefault := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterPreventDefault_R(Self: TExtUtilClickRepeater; var T: Boolean);
begin T := Self.PreventDefault; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterPressClass_W(Self: TExtUtilClickRepeater; const T: String);
begin Self.PressClass := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterPressClass_R(Self: TExtUtilClickRepeater; var T: String);
begin T := Self.PressClass; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterInterval_W(Self: TExtUtilClickRepeater; const T: Integer);
begin Self.Interval := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterInterval_R(Self: TExtUtilClickRepeater; var T: Integer);
begin T := Self.Interval; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterEl_W(Self: TExtUtilClickRepeater; const T: String);
begin Self.El := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterEl_R(Self: TExtUtilClickRepeater; var T: String);
begin T := Self.El; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterDelay_W(Self: TExtUtilClickRepeater; const T: Integer);
begin Self.Delay := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterDelay_R(Self: TExtUtilClickRepeater; var T: Integer);
begin T := Self.Delay; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterAccelerate_W(Self: TExtUtilClickRepeater; const T: Boolean);
begin Self.Accelerate := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilClickRepeaterAccelerate_R(Self: TExtUtilClickRepeater; var T: Boolean);
begin T := Self.Accelerate; end;

(*----------------------------------------------------------------------------*)
Function TExtUtilCSSSingletonUpdateRule21_P(Self: TExtUtilCSSSingleton;  Selector : TExtObjectList; PropertyJS : String; Value : String) : TExtFunction;
Begin Result := Self.UpdateRule(Selector, PropertyJS, Value); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilCSSSingletonUpdateRule20_P(Self: TExtUtilCSSSingleton;  Selector : String; PropertyJS : String; Value : String) : TExtFunction;
Begin Result := Self.UpdateRule(Selector, PropertyJS, Value); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilCSSSingletonGetRule19_P(Self: TExtUtilCSSSingleton;  Selector : TExtObjectList; RefreshCache : Boolean) : TExtFunction;
Begin Result := Self.GetRule(Selector, RefreshCache); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilCSSSingletonGetRule18_P(Self: TExtUtilCSSSingleton;  Selector : String; RefreshCache : Boolean) : TExtFunction;
Begin Result := Self.GetRule(Selector, RefreshCache); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilFormatSingletonUsMoney17_P(Self: TExtUtilFormatSingleton;  Value : String) : TExtFunction;
Begin Result := Self.UsMoney(Value); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilFormatSingletonUsMoney16_P(Self: TExtUtilFormatSingleton;  Value : Integer) : TExtFunction;
Begin Result := Self.UsMoney(Value); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilFormatSingletonRound15_P(Self: TExtUtilFormatSingleton;  Value : String; Precision : Integer) : TExtFunction;
Begin Result := Self.Round(Value, Precision); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilFormatSingletonRound14_P(Self: TExtUtilFormatSingleton;  Value : Integer; Precision : Integer) : TExtFunction;
Begin Result := Self.Round(Value, Precision); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilFormatSingletonFileSize13_P(Self: TExtUtilFormatSingleton;  Size : String) : TExtFunction;
Begin Result := Self.FileSize(Size); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilFormatSingletonFileSize12_P(Self: TExtUtilFormatSingleton;  Size : Integer) : TExtFunction;
Begin Result := Self.FileSize(Size); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilFormatSingletonDate11_P(Self: TExtUtilFormatSingleton;  Value : TDateTime; Format : String) : TExtFunction;
Begin Result := Self.Date(Value, Format); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilFormatSingletonDate10_P(Self: TExtUtilFormatSingleton;  Value : String; Format : String) : TExtFunction;
Begin Result := Self.Date(Value, Format); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilTextMetricsSingletonMeasure9_P(Self: TExtUtilTextMetricsSingleton;  El : THTMLElement; Text : String; FixedWidth : Integer) : TExtFunction;
Begin Result := Self.Measure(El, Text, FixedWidth); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilTextMetricsSingletonMeasure8_P(Self: TExtUtilTextMetricsSingleton;  El : String; Text : String; FixedWidth : Integer) : TExtFunction;
Begin Result := Self.Measure(El, Text, FixedWidth); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilTextMetricsSingletonCreateInstance7_P(Self: TExtUtilTextMetricsSingleton;  El : THTMLElement; FixedWidth : Integer) : TExtFunction;
Begin Result := Self.CreateInstance(El, FixedWidth); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilTextMetricsSingletonCreateInstance6_P(Self: TExtUtilTextMetricsSingleton;  El : String; FixedWidth : Integer) : TExtFunction;
Begin Result := Self.CreateInstance(El, FixedWidth); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilTextMetricsSingletonBind5_P(Self: TExtUtilTextMetricsSingleton;  El : THTMLElement) : TExtFunction;
Begin Result := Self.Bind(El); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilTextMetricsSingletonBind4_P(Self: TExtUtilTextMetricsSingleton;  El : String) : TExtFunction;
Begin Result := Self.Bind(El); END;

(*----------------------------------------------------------------------------*)
procedure TExtUtilObservableListeners_W(Self: TExtUtilObservable; const T: TExtObject);
begin Self.Listeners := T; end;

(*----------------------------------------------------------------------------*)
procedure TExtUtilObservableListeners_R(Self: TExtUtilObservable; var T: TExtObject);
begin T := Self.Listeners; end;

(*----------------------------------------------------------------------------*)
Function TExtUtilObservableEnableBubble3_P(Self: TExtUtilObservable;  Events : TExtObjectList) : TExtFunction;
Begin Result := Self.EnableBubble(Events); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilObservableEnableBubble2_P(Self: TExtUtilObservable;  Events : String) : TExtFunction;
Begin Result := Self.EnableBubble(Events); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilObservableAddEvents1_P(Self: TExtUtilObservable;  O : String; Optional : String) : TExtFunction;
Begin Result := Self.AddEvents(O, Optional); END;

(*----------------------------------------------------------------------------*)
Function TExtUtilObservableAddEvents0_P(Self: TExtUtilObservable;  O : TExtObject; Optional : String) : TExtFunction;
Begin Result := Self.AddEvents(O, Optional); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilMixedCollection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilMixedCollection) do
  begin
    RegisterMethod(@TExtUtilMixedCollection.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilMixedCollection.AddTo, 'AddTo');
    RegisterConstructor(@TExtUtilMixedCollection.Create, 'Create');
    RegisterMethod(@TExtUtilMixedCollection.Add, 'Add');
    RegisterMethod(@TExtUtilMixedCollectionAddAll22_P, 'AddAll22');
    RegisterMethod(@TExtUtilMixedCollectionAddAll23_P, 'AddAll23');
    RegisterMethod(@TExtUtilMixedCollection.Clear, 'Clear');
    RegisterMethod(@TExtUtilMixedCollection.Clone, 'Clone');
    RegisterMethod(@TExtUtilMixedCollection.Contains, 'Contains');
    RegisterMethod(@TExtUtilMixedCollection.ContainsKey, 'ContainsKey');
    RegisterMethod(@TExtUtilMixedCollection.Each, 'Each');
    RegisterMethod(@TExtUtilMixedCollection.EachKey, 'EachKey');
    RegisterMethod(@TExtUtilMixedCollectionFilter24_P, 'Filter24');
    RegisterMethod(@TExtUtilMixedCollectionFilter25_P, 'Filter25');
    RegisterMethod(@TExtUtilMixedCollection.FilterBy, 'FilterBy');
    RegisterMethod(@TExtUtilMixedCollection.Find, 'Find');
    RegisterMethod(@TExtUtilMixedCollectionFindIndex26_P, 'FindIndex26');
    RegisterMethod(@TExtUtilMixedCollectionFindIndex27_P, 'FindIndex27');
    RegisterMethod(@TExtUtilMixedCollection.FindIndexBy, 'FindIndexBy');
    RegisterMethod(@TExtUtilMixedCollection.First, 'First');
    RegisterMethod(@TExtUtilMixedCollectionGet28_P, 'Get28');
    RegisterMethod(@TExtUtilMixedCollectionGet29_P, 'Get29');
    RegisterMethod(@TExtUtilMixedCollection.GetCount, 'GetCount');
    RegisterMethod(@TExtUtilMixedCollection.GetKey, 'GetKey');
    RegisterMethod(@TExtUtilMixedCollection.GetRange, 'GetRange');
    RegisterMethod(@TExtUtilMixedCollection.IndexOf, 'IndexOf');
    RegisterMethod(@TExtUtilMixedCollection.IndexOfKey, 'IndexOfKey');
    RegisterMethod(@TExtUtilMixedCollection.Insert, 'Insert');
    RegisterMethod(@TExtUtilMixedCollectionItem30_P, 'Item30');
    RegisterMethod(@TExtUtilMixedCollectionItem31_P, 'Item31');
    RegisterMethod(@TExtUtilMixedCollection.ItemAt, 'ItemAt');
    RegisterMethod(@TExtUtilMixedCollectionKey32_P, 'Key32');
    RegisterMethod(@TExtUtilMixedCollectionKey33_P, 'Key33');
    RegisterMethod(@TExtUtilMixedCollection.KeySort, 'KeySort');
    RegisterMethod(@TExtUtilMixedCollection.Last, 'Last');
    RegisterMethod(@TExtUtilMixedCollection.Remove, 'Remove');
    RegisterMethod(@TExtUtilMixedCollection.RemoveAt, 'RemoveAt');
    RegisterMethod(@TExtUtilMixedCollection.RemoveKey, 'RemoveKey');
    RegisterMethod(@TExtUtilMixedCollection.Reorder, 'Reorder');
    RegisterMethod(@TExtUtilMixedCollection.Replace, 'Replace');
    RegisterMethod(@TExtUtilMixedCollection.Sort, 'Sort');
    RegisterPropertyHelper(@TExtUtilMixedCollectionAllowFunctions_R,@TExtUtilMixedCollectionAllowFunctions_W,'AllowFunctions');
    RegisterPropertyHelper(@TExtUtilMixedCollectionOnAdd_R,@TExtUtilMixedCollectionOnAdd_W,'OnAdd');
    RegisterPropertyHelper(@TExtUtilMixedCollectionOnClear_R,@TExtUtilMixedCollectionOnClear_W,'OnClear');
    RegisterPropertyHelper(@TExtUtilMixedCollectionOnRemove_R,@TExtUtilMixedCollectionOnRemove_W,'OnRemove');
    RegisterPropertyHelper(@TExtUtilMixedCollectionOnReplace_R,@TExtUtilMixedCollectionOnReplace_W,'OnReplace');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilClickRepeater(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilClickRepeater) do
  begin
    RegisterMethod(@TExtUtilClickRepeater.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilClickRepeater.AddTo, 'AddTo');
    RegisterConstructor(@TExtUtilClickRepeater.Create, 'Create');
    RegisterMethod(@TExtUtilClickRepeater.Disable, 'Disable');
    RegisterMethod(@TExtUtilClickRepeater.Enable, 'Enable');
    RegisterMethod(@TExtUtilClickRepeater.SetDisabled, 'SetDisabled');
    RegisterPropertyHelper(@TExtUtilClickRepeaterAccelerate_R,@TExtUtilClickRepeaterAccelerate_W,'Accelerate');
    RegisterPropertyHelper(@TExtUtilClickRepeaterDelay_R,@TExtUtilClickRepeaterDelay_W,'Delay');
    RegisterPropertyHelper(@TExtUtilClickRepeaterEl_R,@TExtUtilClickRepeaterEl_W,'El');
    RegisterPropertyHelper(@TExtUtilClickRepeaterInterval_R,@TExtUtilClickRepeaterInterval_W,'Interval');
    RegisterPropertyHelper(@TExtUtilClickRepeaterPressClass_R,@TExtUtilClickRepeaterPressClass_W,'PressClass');
    RegisterPropertyHelper(@TExtUtilClickRepeaterPreventDefault_R,@TExtUtilClickRepeaterPreventDefault_W,'PreventDefault');
    RegisterPropertyHelper(@TExtUtilClickRepeaterStopDefault_R,@TExtUtilClickRepeaterStopDefault_W,'StopDefault');
    RegisterPropertyHelper(@TExtUtilClickRepeaterOnClick_R,@TExtUtilClickRepeaterOnClick_W,'OnClick');
    RegisterPropertyHelper(@TExtUtilClickRepeaterOnMousedown_R,@TExtUtilClickRepeaterOnMousedown_W,'OnMousedown');
    RegisterPropertyHelper(@TExtUtilClickRepeaterOnMouseup_R,@TExtUtilClickRepeaterOnMouseup_W,'OnMouseup');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilDelayedTask(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilDelayedTask) do
  begin
    RegisterMethod(@TExtUtilDelayedTask.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilDelayedTask.AddTo, 'AddTo');
    RegisterConstructor(@TExtUtilDelayedTask.Create, 'Create');
    RegisterMethod(@TExtUtilDelayedTask.Cancel, 'Cancel');
    RegisterMethod(@TExtUtilDelayedTask.Delay, 'Delay');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilCookiesSingleton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilCookiesSingleton) do
  begin
    RegisterMethod(@TExtUtilCookiesSingleton.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilCookiesSingleton.AddTo, 'AddTo');
    RegisterMethod(@TExtUtilCookiesSingleton.Clear, 'Clear');
    RegisterMethod(@TExtUtilCookiesSingleton.Get, 'Get');
    RegisterMethod(@TExtUtilCookiesSingleton.SetJS, 'SetJS');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilCSSSingleton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilCSSSingleton) do
  begin
    RegisterMethod(@TExtUtilCSSSingleton.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilCSSSingleton.AddTo, 'AddTo');
    RegisterMethod(@TExtUtilCSSSingleton.CreateStyleSheet, 'CreateStyleSheet');
    RegisterMethod(@TExtUtilCSSSingletonGetRule18_P, 'GetRule18');
    RegisterMethod(@TExtUtilCSSSingletonGetRule19_P, 'GetRule19');
    RegisterMethod(@TExtUtilCSSSingleton.GetRules, 'GetRules');
    RegisterMethod(@TExtUtilCSSSingleton.RefreshCache, 'RefreshCache');
    RegisterMethod(@TExtUtilCSSSingleton.RemoveStyleSheet, 'RemoveStyleSheet');
    RegisterMethod(@TExtUtilCSSSingleton.SwapStyleSheet, 'SwapStyleSheet');
    RegisterMethod(@TExtUtilCSSSingletonUpdateRule20_P, 'UpdateRule20');
    RegisterMethod(@TExtUtilCSSSingletonUpdateRule21_P, 'UpdateRule21');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilFormatSingleton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilFormatSingleton) do
  begin
    RegisterMethod(@TExtUtilFormatSingleton.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilFormatSingleton.AddTo, 'AddTo');
    RegisterMethod(@TExtUtilFormatSingleton.Capitalize, 'Capitalize');
    RegisterMethod(@TExtUtilFormatSingletonDate10_P, 'Date10');
    RegisterMethod(@TExtUtilFormatSingletonDate11_P, 'Date11');
    RegisterMethod(@TExtUtilFormatSingleton.DateRenderer, 'DateRenderer');
    RegisterMethod(@TExtUtilFormatSingleton.DefaultValue, 'DefaultValue');
    RegisterMethod(@TExtUtilFormatSingleton.Ellipsis, 'Ellipsis');
    RegisterMethod(@TExtUtilFormatSingletonFileSize12_P, 'FileSize12');
    RegisterMethod(@TExtUtilFormatSingletonFileSize13_P, 'FileSize13');
    RegisterMethod(@TExtUtilFormatSingleton.HtmlDecode, 'HtmlDecode');
    RegisterMethod(@TExtUtilFormatSingleton.HtmlEncode, 'HtmlEncode');
    RegisterMethod(@TExtUtilFormatSingleton.Lowercase, 'Lowercase');
    RegisterMethod(@TExtUtilFormatSingleton.Math, 'Math');
    RegisterMethod(@TExtUtilFormatSingleton.Nl2br, 'Nl2br');
    RegisterMethod(@TExtUtilFormatSingleton.Number, 'Number');
    RegisterMethod(@TExtUtilFormatSingleton.NumberRenderer, 'NumberRenderer');
    RegisterMethod(@TExtUtilFormatSingleton.Plural, 'Plural');
    RegisterMethod(@TExtUtilFormatSingletonRound14_P, 'Round14');
    RegisterMethod(@TExtUtilFormatSingletonRound15_P, 'Round15');
    RegisterMethod(@TExtUtilFormatSingleton.StripScripts, 'StripScripts');
    RegisterMethod(@TExtUtilFormatSingleton.StripTags, 'StripTags');
    RegisterMethod(@TExtUtilFormatSingleton.Substr, 'Substr');
    RegisterMethod(@TExtUtilFormatSingleton.Trim, 'Trim');
    RegisterMethod(@TExtUtilFormatSingleton.Undef, 'Undef');
    RegisterMethod(@TExtUtilFormatSingleton.Uppercase, 'Uppercase');
    RegisterMethod(@TExtUtilFormatSingletonUsMoney16_P, 'UsMoney16');
    RegisterMethod(@TExtUtilFormatSingletonUsMoney17_P, 'UsMoney17');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilTaskRunner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilTaskRunner) do
  begin
    RegisterMethod(@TExtUtilTaskRunner.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilTaskRunner.AddTo, 'AddTo');
    RegisterConstructor(@TExtUtilTaskRunner.Create, 'Create');
    RegisterMethod(@TExtUtilTaskRunner.Start, 'Start');
    RegisterMethod(@TExtUtilTaskRunner.Stop, 'Stop');
    RegisterMethod(@TExtUtilTaskRunner.StopAll, 'StopAll');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilTextMetricsSingleton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilTextMetricsSingleton) do
  begin
    RegisterMethod(@TExtUtilTextMetricsSingleton.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilTextMetricsSingleton.AddTo, 'AddTo');
    RegisterMethod(@TExtUtilTextMetricsSingletonBind4_P, 'Bind4');
    RegisterMethod(@TExtUtilTextMetricsSingletonBind5_P, 'Bind5');
    RegisterMethod(@TExtUtilTextMetricsSingletonCreateInstance6_P, 'CreateInstance6');
    RegisterMethod(@TExtUtilTextMetricsSingletonCreateInstance7_P, 'CreateInstance7');
    RegisterMethod(@TExtUtilTextMetricsSingleton.GetHeight, 'GetHeight');
    RegisterMethod(@TExtUtilTextMetricsSingleton.GetSize, 'GetSize');
    RegisterMethod(@TExtUtilTextMetricsSingleton.GetWidth, 'GetWidth');
    RegisterMethod(@TExtUtilTextMetricsSingletonMeasure8_P, 'Measure8');
    RegisterMethod(@TExtUtilTextMetricsSingletonMeasure9_P, 'Measure9');
    RegisterMethod(@TExtUtilTextMetricsSingleton.SetFixedWidth, 'SetFixedWidth');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilJSONSingleton(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilJSONSingleton) do
  begin
    RegisterMethod(@TExtUtilJSONSingleton.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilJSONSingleton.AddTo, 'AddTo');
    RegisterMethod(@TExtUtilJSONSingleton.Decode, 'Decode');
    RegisterMethod(@TExtUtilJSONSingleton.Encode, 'Encode');
    RegisterMethod(@TExtUtilJSONSingleton.EncodeDate, 'EncodeDate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TExtUtilObservable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilObservable) do begin
    RegisterMethod(@TExtUtilObservable.JSClassName, 'JSClassName');
    RegisterConstructor(@TExtUtilObservable.AddTo, 'AddTo');
    RegisterConstructor(@TExtUtilObservable.Create, 'Create');
    RegisterMethod(@TExtUtilObservable.Destroy, 'Free');

    RegisterMethod(@TExtUtilObservable.ObservableCapture, 'ObservableCapture');
    RegisterMethod(@TExtUtilObservable.ObservableObserveClass, 'ObservableObserveClass');
    RegisterMethod(@TExtUtilObservable.ObservableReleaseCapture, 'ObservableReleaseCapture');
    RegisterMethod(@TExtUtilObservableAddEvents0_P, 'AddEvents0');
    RegisterMethod(@TExtUtilObservableAddEvents1_P, 'AddEvents1');
    RegisterMethod(@TExtUtilObservable.AddListener, 'AddListener');
    RegisterMethod(@TExtUtilObservableEnableBubble2_P, 'EnableBubble2');
    RegisterMethod(@TExtUtilObservableEnableBubble3_P, 'EnableBubble3');
    RegisterMethod(@TExtUtilObservable.FireEvent, 'FireEvent');
    RegisterMethod(@TExtUtilObservable.HasListener, 'HasListener');
    RegisterMethod(@TExtUtilObservable.On, 'On');
    RegisterMethod(@TExtUtilObservable.PurgeListeners, 'PurgeListeners');
    RegisterMethod(@TExtUtilObservable.RelayEvents, 'RelayEvents');
    RegisterMethod(@TExtUtilObservable.RemoveListener, 'RemoveListener');
    RegisterMethod(@TExtUtilObservable.ResumeEvents, 'ResumeEvents');
    RegisterMethod(@TExtUtilObservable.SuspendEvents, 'SuspendEvents');
    RegisterMethod(@TExtUtilObservable.Un, 'Un');
    RegisterPropertyHelper(@TExtUtilObservableListeners_R,@TExtUtilObservableListeners_W,'Listeners');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ExtUtil(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TExtUtilObservable) do
  with CL.Add(TExtUtilJSONSingleton) do
  with CL.Add(TExtUtilTextMetricsSingleton) do
  with CL.Add(TExtUtilTaskRunner) do
  with CL.Add(TExtUtilFormatSingleton) do
  with CL.Add(TExtUtilCSSSingleton) do
  with CL.Add(TExtUtilCookiesSingleton) do
  with CL.Add(TExtUtilDelayedTask) do
  with CL.Add(TExtUtilClickRepeater) do
  with CL.Add(TExtUtilMixedCollection) do
  RIRegister_TExtUtilObservable(CL);
  RIRegister_TExtUtilJSONSingleton(CL);
  RIRegister_TExtUtilTextMetricsSingleton(CL);
  RIRegister_TExtUtilTaskRunner(CL);
  RIRegister_TExtUtilFormatSingleton(CL);
  RIRegister_TExtUtilCSSSingleton(CL);
  RIRegister_TExtUtilCookiesSingleton(CL);
  RIRegister_TExtUtilDelayedTask(CL);
  RIRegister_TExtUtilClickRepeater(CL);
  RIRegister_TExtUtilMixedCollection(CL);
end;

 
 
{ TPSImport_ExtUtil }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtUtil.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ExtUtil(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ExtUtil.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ExtUtil(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
