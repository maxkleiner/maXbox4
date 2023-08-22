unit uPSI_uJSON;
{
   maXSon
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
  TPSImport_uJSON = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_NULL(CL: TPSPascalCompiler);
procedure SIRegister__String(CL: TPSPascalCompiler);
procedure SIRegister__Integer(CL: TPSPascalCompiler);
procedure SIRegister__Double(CL: TPSPascalCompiler);
procedure SIRegister__Boolean(CL: TPSPascalCompiler);
procedure SIRegister__Number(CL: TPSPascalCompiler);
procedure SIRegister_TJSONArray(CL: TPSPascalCompiler);
procedure SIRegister_TJSONObject(CL: TPSPascalCompiler);
procedure SIRegister_JSONTokener(CL: TPSPascalCompiler);
procedure SIRegister_ParseException(CL: TPSPascalCompiler);
procedure SIRegister_NotImplmentedFeature(CL: TPSPascalCompiler);
procedure SIRegister_NullPointerException(CL: TPSPascalCompiler);
procedure SIRegister_NumberFormatException(CL: TPSPascalCompiler);
procedure SIRegister_NoSuchElementException(CL: TPSPascalCompiler);
procedure SIRegister_ClassCastException(CL: TPSPascalCompiler);
procedure SIRegister_TZAbstractObject(CL: TPSPascalCompiler);
procedure SIRegister_uJSON(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_NULL(CL: TPSRuntimeClassImporter);
procedure RIRegister__String(CL: TPSRuntimeClassImporter);
procedure RIRegister__Integer(CL: TPSRuntimeClassImporter);
procedure RIRegister__Double(CL: TPSRuntimeClassImporter);
procedure RIRegister__Boolean(CL: TPSRuntimeClassImporter);
procedure RIRegister__Number(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJSONArray(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJSONObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_JSONTokener(CL: TPSRuntimeClassImporter);
procedure RIRegister_ParseException(CL: TPSRuntimeClassImporter);
procedure RIRegister_NotImplmentedFeature(CL: TPSRuntimeClassImporter);
procedure RIRegister_NullPointerException(CL: TPSRuntimeClassImporter);
procedure RIRegister_NumberFormatException(CL: TPSRuntimeClassImporter);
procedure RIRegister_NoSuchElementException(CL: TPSRuntimeClassImporter);
procedure RIRegister_ClassCastException(CL: TPSRuntimeClassImporter);
procedure RIRegister_TZAbstractObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_uJSON(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,TypInfo
  ,uJSON
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uJSON]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_NULL(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'NULL') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'NULL') do
  begin
    RegisterMethod('Function Equals( const Value : TZAbstractObject) : Boolean');
    RegisterMethod('Function toString( ) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__String(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', '_String') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'_String') do
  begin
    RegisterMethod('Constructor create( s : string)');
    RegisterMethod('Function equalsIgnoreCase( s : string) : boolean');
    RegisterMethod('Function Equals( const Value : TZAbstractObject) : Boolean');
    RegisterMethod('Function toString( ) : string');
    RegisterMethod('Function clone : TZAbstractObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Integer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'_Number', '_Integer') do
  with CL.AddClassN(CL.FindClass('_Number'),'_Integer') do
  begin
    RegisterMethod('Function parseInt( s : string; i : integer) : integer;');
    RegisterMethod('Function parseInt1( s : _String) : integer;');
    RegisterMethod('Function toHexString( c : char) : string');
    RegisterMethod('Constructor create( i : integer);');
    RegisterMethod('Constructor create1( s : string);');
    RegisterMethod('Function doubleValue : double');
    RegisterMethod('Function intValue : integer');
    RegisterMethod('Function toString( ) : string');
    RegisterMethod('Function clone : TZAbstractObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Double(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'_Number', '_Double') do
  with CL.AddClassN(CL.FindClass('_Number'),'_Double') do
  begin
    RegisterMethod('Constructor create( s : string);');
    RegisterMethod('Constructor create1( s : _String);');
    RegisterMethod('Constructor create2( d : double);');
    RegisterMethod('Function NaN : double');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Boolean(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', '_Boolean') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'_Boolean') do
  begin
    RegisterMethod('Function _TRUE( ) : _Boolean');
    RegisterMethod('Function _FALSE( ) : _Boolean');
    RegisterMethod('Function valueOf( b : boolean) : _Boolean');
    RegisterMethod('Constructor create( b : boolean)');
    RegisterMethod('Function toString( ) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister__Number(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', '_Number') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'_Number') do
  begin
    RegisterMethod('Function doubleValue : double');
    RegisterMethod('Function intValue : integer');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJSONArray(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'TJSONArray') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'TJSONArray') do
  begin
    RegisterMethod('Constructor create;');
    RegisterMethod('Constructor create1( collection : TList);');
    RegisterMethod('Constructor create2( x : JSONTokener);');
    RegisterMethod('Constructor create3( s : string);');
    RegisterMethod('Function get( index : integer) : TZAbstractObject');
    RegisterMethod('Function getBoolean( index : integer) : boolean');
    RegisterMethod('Function getDouble( index : integer) : double');
    RegisterMethod('Function getInt( index : integer) : integer');
    RegisterMethod('Function getJSONArray( index : integer) : TJSONArray');
    RegisterMethod('Function getJSONObject( index : integer) : TJSONObject');
    RegisterMethod('Function getString( index : integer) : string');
    RegisterMethod('Function isNull( index : integer) : boolean');
    RegisterMethod('Function join( separator : string) : string');
    RegisterMethod('Function length : integer');
    RegisterMethod('Function opt( index : integer) : TZAbstractObject');
    RegisterMethod('Function optBoolean( index : integer) : boolean;');
    RegisterMethod('Function optBoolean1( index : integer; defaultValue : boolean) : boolean;');
    RegisterMethod('Function optDouble( index : integer) : double;');
    RegisterMethod('Function optDouble1( index : integer; defaultValue : double) : double;');
    RegisterMethod('Function optInt( index : integer) : integer;');
    RegisterMethod('Function optInt1( index : integer; defaultValue : integer) : integer;');
    RegisterMethod('Function optJSONArray( index : integer) : TJSONArray;');
    RegisterMethod('Function optJSONObject( index : integer) : TJSONObject;');
    RegisterMethod('Function optString( index : integer) : string;');
    RegisterMethod('Function optString1( index : integer; defaultValue : string) : string;');
    RegisterMethod('Function put( value : boolean) : TJSONArray;');
    RegisterMethod('Function put1( value : double) : TJSONArray;');
    RegisterMethod('Function put2( value : integer) : TJSONArray;');
    RegisterMethod('Function put3( value : TZAbstractObject) : TJSONArray;');
    RegisterMethod('Function put4( value : string) : TJSONArray;');
    RegisterMethod('Function put5( index : integer; value : boolean) : TJSONArray;');
    RegisterMethod('Function put6( index : integer; value : double) : TJSONArray;');
    RegisterMethod('Function put7( index : integer; value : integer) : TJSONArray;');
    RegisterMethod('Function put8( index : integer; value : TZAbstractObject) : TJSONArray;');
    RegisterMethod('Function put9( index : integer; value : string) : TJSONArray;');
    RegisterMethod('Function toJSONObject( names : TJSONArray) : TJSONObject;');
    RegisterMethod('Function toString1( indentFactor : integer) : string;');
    RegisterMethod('Function toString2( indentFactor, indent : integer) : string;');
    RegisterMethod('Function toList( ) : TList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJSONObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'TJSONObject') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'TJSONObject') do
  begin
    RegisterMethod('Constructor create;');
    RegisterMethod('Constructor create1( jo : TJSONObject; sa : array of string);');
    RegisterMethod('Constructor create2( x : JSONTokener);');
    RegisterMethod('Constructor create3( map : TStringList);');
    RegisterMethod('Constructor create4( s : string);');
    RegisterMethod('Procedure clean');
    RegisterMethod('Function clone : TZAbstractObject');
    RegisterMethod('Function accumulate( key : string; value : TZAbstractObject) : TJSONObject');
    RegisterMethod('Function get( key : string) : TZAbstractObject');
    RegisterMethod('Function getBoolean( key : string) : boolean');
    RegisterMethod('Function getDouble( key : string) : double');
    RegisterMethod('Function getInt( key : string) : integer');
    RegisterMethod('Function getJSONArray( key : string) : TJSONArray');
    RegisterMethod('Function getJSONObject( key : string) : TJSONObject');
    RegisterMethod('Function getString( key : string) : string');
    RegisterMethod('Function has( key : string) : boolean');
    RegisterMethod('Function isNull( key : string) : boolean');
    RegisterMethod('Function keys : TStringList');
    RegisterMethod('Function length : integer');
    RegisterMethod('Function names : TJSONArray');
    RegisterMethod('Function numberToString( n : _Number) : string');
    RegisterMethod('Function valueToString( value : TZAbstractObject) : string;');
    RegisterMethod('Function valueToString1( value : TZAbstractObject; indentFactor, indent : integer) : string;');
    RegisterMethod('Function opt( key : string) : TZAbstractObject');
    RegisterMethod('Function optBoolean( key : string) : boolean;');
    RegisterMethod('Function optBoolean1( key : string; defaultValue : boolean) : boolean;');
    RegisterMethod('Function optDouble( key : string) : double;');
    RegisterMethod('Function optDouble1( key : string; defaultValue : double) : double;');
    RegisterMethod('Function optInt( key : string) : integer;');
    RegisterMethod('Function optInt1( key : string; defaultValue : integer) : integer;');
    RegisterMethod('Function optString( key : string) : string;');
    RegisterMethod('Function optString1( key : string; defaultValue : string) : string;');
    RegisterMethod('Function optJSONArray( key : string) : TJSONArray;');
    RegisterMethod('Function optJSONObject( key : string) : TJSONObject;');
    RegisterMethod('Function put( key : string; value : boolean) : TJSONObject;');
    RegisterMethod('Function put1( key : string; value : double) : TJSONObject;');
    RegisterMethod('Function put2( key : string; value : integer) : TJSONObject;');
    RegisterMethod('Function put3( key : string; value : string) : TJSONObject;');
    RegisterMethod('Function put4( key : string; value : TZAbstractObject) : TJSONObject;');
    RegisterMethod('Function putOpt( key : string; value : TZAbstractObject) : TJSONObject');
    RegisterMethod('Function quote( s : string) : string');
    RegisterMethod('Function remove( key : string) : TZAbstractObject');
    RegisterMethod('Procedure assignTo( json : TJSONObject)');
    RegisterMethod('Function toJSONArray( names : TJSONArray) : TJSONArray');
    RegisterMethod('Function toString1( indentFactor : integer) : string;');
    RegisterMethod('Function toString2( indentFactor, indent : integer) : string;');
    RegisterMethod('Function NULL : NULL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JSONTokener(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TZAbstractObject', 'JSONTokener') do
  with CL.AddClassN(CL.FindClass('TZAbstractObject'),'JSONTokener') do
  begin
    RegisterMethod('Constructor create( s : string)');
    RegisterMethod('Procedure back( )');
    RegisterMethod('Function dehexchar( c : char) : integer');
    RegisterMethod('Function more : boolean');
    RegisterMethod('Function next( ) : char;');
    RegisterMethod('Function next1( c : char) : char;');
    RegisterMethod('Function next2( n : integer) : string;');
    RegisterMethod('Function nextClean( ) : char');
    RegisterMethod('Function nextString( quote : char) : string');
    RegisterMethod('Function nextTo( d : char) : string;');
    RegisterMethod('Function nextTo1( delimiters : string) : char;');
    RegisterMethod('Function nextValue( ) : TZAbstractObject');
    RegisterMethod('Procedure skipPast( _to : string)');
    RegisterMethod('Function skipTo( _to : char) : char');
    RegisterMethod('Function syntaxError( _message : string) : ParseException');
    RegisterMethod('Function toString : string');
    RegisterMethod('Function unescape( s : string) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ParseException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ParseException') do
  with CL.AddClassN(CL.FindClass('Exception'),'ParseException') do
  begin
    RegisterMethod('Constructor create( _message : string; index : integer)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NotImplmentedFeature(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'NotImplmentedFeature') do
  with CL.AddClassN(CL.FindClass('Exception'),'NotImplmentedFeature') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NullPointerException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'NullPointerException') do
  with CL.AddClassN(CL.FindClass('Exception'),'NullPointerException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NumberFormatException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'NumberFormatException') do
  with CL.AddClassN(CL.FindClass('Exception'),'NumberFormatException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_NoSuchElementException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'NoSuchElementException') do
  with CL.AddClassN(CL.FindClass('Exception'),'NoSuchElementException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ClassCastException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ClassCastException') do
  with CL.AddClassN(CL.FindClass('Exception'),'ClassCastException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TZAbstractObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TZAbstractObject') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TZAbstractObject') do
  begin
    RegisterMethod('Function equals( const Value : TZAbstractObject) : Boolean');
    RegisterMethod('Function hash : LongInt');
    RegisterMethod('Function Clone : TZAbstractObject');
    RegisterMethod('Function toString : string');
    RegisterMethod('Function instanceOf( const Value : TZAbstractObject) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uJSON(CL: TPSPascalCompiler);
begin
  SIRegister_TZAbstractObject(CL);
  SIRegister_ClassCastException(CL);
  SIRegister_NoSuchElementException(CL);
  SIRegister_NumberFormatException(CL);
  SIRegister_NullPointerException(CL);
  SIRegister_NotImplmentedFeature(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJSONArray');
  CL.AddClassN(CL.FindClass('TOBJECT'),'_Number');
  CL.AddClassN(CL.FindClass('TOBJECT'),'_String');
  CL.AddClassN(CL.FindClass('TOBJECT'),'_Double');
  CL.AddClassN(CL.FindClass('TOBJECT'),'NULL');
  SIRegister_ParseException(CL);
  SIRegister_JSONTokener(CL);
  SIRegister_TJSONObject(CL);
  SIRegister_TJSONArray(CL);
  SIRegister__Number(CL);
  SIRegister__Boolean(CL);
  SIRegister__Double(CL);
  SIRegister__Integer(CL);
  SIRegister__String(CL);
  SIRegister_NULL(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function _Integercreate1_P(Self: TClass; CreateNewInstance: Boolean;  s : string):TObject;
Begin Result := _Integer.create(s); END;

(*----------------------------------------------------------------------------*)
Function _Integercreate_P(Self: TClass; CreateNewInstance: Boolean;  i : integer):TObject;
Begin Result := _Integer.create(i); END;

(*----------------------------------------------------------------------------*)
Function _IntegerparseInt1_P(Self: _Integer;  s : _String) : integer;
Begin Result := Self.parseInt(s); END;

(*----------------------------------------------------------------------------*)
Function _IntegerparseInt_P(Self: _Integer;  s : string; i : integer) : integer;
Begin Result := Self.parseInt(s, i); END;

(*----------------------------------------------------------------------------*)
Function _Doublecreate2_P(Self: TClass; CreateNewInstance: Boolean;  d : double):TObject;
Begin Result := _Double.create(d); END;

(*----------------------------------------------------------------------------*)
Function _Doublecreate1_P(Self: TClass; CreateNewInstance: Boolean;  s : _String):TObject;
Begin Result := _Double.create(s); END;

(*----------------------------------------------------------------------------*)
Function _Doublecreate_P(Self: TClass; CreateNewInstance: Boolean;  s : string):TObject;
Begin Result := _Double.create(s); END;

(*----------------------------------------------------------------------------*)
Function TJSONArraytoString2_P(Self: TJSONArray;  indentFactor, indent : integer) : string;
Begin Result := Self.toString(indentFactor, indent); END;

(*----------------------------------------------------------------------------*)
Function TJSONArraytoString1_P(Self: TJSONArray;  indentFactor : integer) : string;
Begin Result := Self.toString(indentFactor); END;

(*----------------------------------------------------------------------------*)
Function TJSONArraytoString_P(Self: TJSONArray) : string;
Begin Result := Self.toString; END;

(*----------------------------------------------------------------------------*)
Function TJSONArraytoJSONObject_P(Self: TJSONArray;  names : TJSONArray) : TJSONObject;
Begin Result := Self.toJSONObject(names); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput9_P(Self: TJSONArray;  index : integer; value : string) : TJSONArray;
Begin Result := Self.put(index, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput8_P(Self: TJSONArray;  index : integer; value : TZAbstractObject) : TJSONArray;
Begin Result := Self.put(index, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput7_P(Self: TJSONArray;  index : integer; value : integer) : TJSONArray;
Begin Result := Self.put(index, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput6_P(Self: TJSONArray;  index : integer; value : double) : TJSONArray;
Begin Result := Self.put(index, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput5_P(Self: TJSONArray;  index : integer; value : boolean) : TJSONArray;
Begin Result := Self.put(index, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput4_P(Self: TJSONArray;  value : string) : TJSONArray;
Begin Result := Self.put(value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput3_P(Self: TJSONArray;  value : TZAbstractObject) : TJSONArray;
Begin Result := Self.put(value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput2_P(Self: TJSONArray;  value : integer) : TJSONArray;
Begin Result := Self.put(value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput1_P(Self: TJSONArray;  value : double) : TJSONArray;
Begin Result := Self.put(value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayput_P(Self: TJSONArray;  value : boolean) : TJSONArray;
Begin Result := Self.put(value); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptString1_P(Self: TJSONArray;  index : integer; defaultValue : string) : string;
Begin Result := Self.optString(index, defaultValue); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptString_P(Self: TJSONArray;  index : integer) : string;
Begin Result := Self.optString(index); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptJSONObject_P(Self: TJSONArray;  index : integer) : TJSONObject;
Begin Result := Self.optJSONObject(index); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptJSONArray_P(Self: TJSONArray;  index : integer) : TJSONArray;
Begin Result := Self.optJSONArray(index); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptInt1_P(Self: TJSONArray;  index : integer; defaultValue : integer) : integer;
Begin Result := Self.optInt(index, defaultValue); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptInt_P(Self: TJSONArray;  index : integer) : integer;
Begin Result := Self.optInt(index); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptDouble1_P(Self: TJSONArray;  index : integer; defaultValue : double) : double;
Begin Result := Self.optDouble(index, defaultValue); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptDouble_P(Self: TJSONArray;  index : integer) : double;
Begin Result := Self.optDouble(index); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptBoolean1_P(Self: TJSONArray;  index : integer; defaultValue : boolean) : boolean;
Begin Result := Self.optBoolean(index, defaultValue); END;

(*----------------------------------------------------------------------------*)
Function TJSONArrayoptBoolean_P(Self: TJSONArray;  index : integer) : boolean;
Begin Result := Self.optBoolean(index); END;

(*----------------------------------------------------------------------------*)
Function TJSONArraycreate3_P(Self: TClass; CreateNewInstance: Boolean;  s : string):TObject;
Begin Result := TJSONArray.create(s); END;

(*----------------------------------------------------------------------------*)
Function TJSONArraycreate2_P(Self: TClass; CreateNewInstance: Boolean;  x : JSONTokener):TObject;
Begin Result := TJSONArray.create(x); END;

(*----------------------------------------------------------------------------*)
Function TJSONArraycreate1_P(Self: TClass; CreateNewInstance: Boolean;  collection : TList):TObject;
Begin Result := TJSONArray.create(collection); END;

(*----------------------------------------------------------------------------*)
Function TJSONArraycreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TJSONArray.create; END;

(*----------------------------------------------------------------------------*)
Function TJSONObjecttoString2_P(Self: TJSONObject;  indentFactor, indent : integer) : string;
Begin Result := Self.toString(indentFactor, indent); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjecttoString1_P(Self: TJSONObject;  indentFactor : integer) : string;
Begin Result := Self.toString(indentFactor); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjecttoString_P(Self: TJSONObject) : string;
Begin Result := Self.toString; END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectput4_P(Self: TJSONObject;  key : string; value : TZAbstractObject) : TJSONObject;
Begin Result := Self.put(key, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectput3_P(Self: TJSONObject;  key : string; value : string) : TJSONObject;
Begin Result := Self.put(key, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectput2_P(Self: TJSONObject;  key : string; value : integer) : TJSONObject;
Begin Result := Self.put(key, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectput1_P(Self: TJSONObject;  key : string; value : double) : TJSONObject;
Begin Result := Self.put(key, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectput_P(Self: TJSONObject;  key : string; value : boolean) : TJSONObject;
Begin Result := Self.put(key, value); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptJSONObject_P(Self: TJSONObject;  key : string) : TJSONObject;
Begin Result := Self.optJSONObject(key); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptJSONArray_P(Self: TJSONObject;  key : string) : TJSONArray;
Begin Result := Self.optJSONArray(key); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptString1_P(Self: TJSONObject;  key : string; defaultValue : string) : string;
Begin Result := Self.optString(key, defaultValue); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptString_P(Self: TJSONObject;  key : string) : string;
Begin Result := Self.optString(key); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptInt1_P(Self: TJSONObject;  key : string; defaultValue : integer) : integer;
Begin Result := Self.optInt(key, defaultValue); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptInt_P(Self: TJSONObject;  key : string) : integer;
Begin Result := Self.optInt(key); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptDouble1_P(Self: TJSONObject;  key : string; defaultValue : double) : double;
Begin Result := Self.optDouble(key, defaultValue); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptDouble_P(Self: TJSONObject;  key : string) : double;
Begin Result := Self.optDouble(key); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptBoolean1_P(Self: TJSONObject;  key : string; defaultValue : boolean) : boolean;
Begin Result := Self.optBoolean(key, defaultValue); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectoptBoolean_P(Self: TJSONObject;  key : string) : boolean;
Begin Result := Self.optBoolean(key); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectvalueToString1_P(Self: TJSONObject;  value : TZAbstractObject; indentFactor, indent : integer) : string;
Begin Result := Self.valueToString(value, indentFactor, indent); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectvalueToString_P(Self: TJSONObject;  value : TZAbstractObject) : string;
Begin Result := Self.valueToString(value); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectcreate4_P(Self: TClass; CreateNewInstance: Boolean;  s : string):TObject;
Begin Result := TJSONObject.create(s); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectcreate3_P(Self: TClass; CreateNewInstance: Boolean;  map : TStringList):TObject;
Begin Result := TJSONObject.create(map); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectcreate2_P(Self: TClass; CreateNewInstance: Boolean;  x : JSONTokener):TObject;
Begin Result := TJSONObject.create(x); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectcreate1_P(Self: TClass; CreateNewInstance: Boolean;  jo : TJSONObject; sa : array of string):TObject;
Begin Result := TJSONObject.create(jo, sa); END;

(*----------------------------------------------------------------------------*)
Function TJSONObjectcreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TJSONObject.create; END;

(*----------------------------------------------------------------------------*)
Function JSONTokenernextTo1_P(Self: JSONTokener;  delimiters : string) : char;
Begin Result := Self.nextTo(delimiters); END;

(*----------------------------------------------------------------------------*)
Function JSONTokenernextTo_P(Self: JSONTokener;  d : char) : string;
Begin Result := Self.nextTo(d); END;

(*----------------------------------------------------------------------------*)
Function JSONTokenernext2_P(Self: JSONTokener;  n : integer) : string;
Begin Result := Self.next(n); END;

(*----------------------------------------------------------------------------*)
Function JSONTokenernext1_P(Self: JSONTokener;  c : char) : char;
Begin Result := Self.next(c); END;

(*----------------------------------------------------------------------------*)
Function JSONTokenernext_P(Self: JSONTokener) : char;
Begin Result := Self.next; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NULL(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(NULL) do
  begin
    RegisterMethod(@NULL.Equals, 'Equals');
    RegisterMethod(@NULL.toString, 'toString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister__String(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(_String) do
  begin
    RegisterConstructor(@_String.create, 'create');
    RegisterMethod(@_String.equalsIgnoreCase, 'equalsIgnoreCase');
    RegisterMethod(@_String.Equals, 'Equals');
    RegisterMethod(@_String.toString, 'toString');
    RegisterMethod(@_String.clone, 'clone');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister__Integer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(_Integer) do
  begin
    RegisterMethod(@_IntegerparseInt_P, 'parseInt');
    RegisterMethod(@_IntegerparseInt1_P, 'parseInt1');
    RegisterMethod(@_Integer.toHexString, 'toHexString');
    RegisterConstructor(@_Integercreate_P, 'create');
    RegisterConstructor(@_Integercreate1_P, 'create1');
    RegisterMethod(@_Integer.doubleValue, 'doubleValue');
    RegisterMethod(@_Integer.intValue, 'intValue');
    RegisterMethod(@_Integer.toString, 'toString');
    RegisterMethod(@_Integer.clone, 'clone');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister__Double(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(_Double) do
  begin
    RegisterConstructor(@_Doublecreate_P, 'create');
    RegisterConstructor(@_Doublecreate1_P, 'create1');
    RegisterConstructor(@_Doublecreate2_P, 'create2');
    RegisterMethod(@_Double.NaN, 'NaN');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister__Boolean(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(_Boolean) do
  begin
    RegisterMethod(@_Boolean._TRUE, '_TRUE');
    RegisterMethod(@_Boolean._FALSE, '_FALSE');
    RegisterMethod(@_Boolean.valueOf, 'valueOf');
    RegisterConstructor(@_Boolean.create, 'create');
    RegisterMethod(@_Boolean.toString, 'toString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister__Number(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(_Number) do begin
    //RegisterVirtualAbstractMethod(@_Number, @!.doubleValue, 'doubleValue');
    //RegisterVirtualAbstractMethod(@_Number, @!.intValue, 'intValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJSONArray(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJSONArray) do begin
    RegisterConstructor(@TJSONArraycreate_P, 'create');
    RegisterConstructor(@TJSONArraycreate1_P, 'create1');
    RegisterConstructor(@TJSONArraycreate2_P, 'create2');
    RegisterConstructor(@TJSONArraycreate3_P, 'create3');
    RegisterMethod(@TJSONArray.get, 'get');
    RegisterMethod(@TJSONArray.getBoolean, 'getBoolean');
    RegisterMethod(@TJSONArray.getDouble, 'getDouble');
    RegisterMethod(@TJSONArray.getInt, 'getInt');
    RegisterMethod(@TJSONArray.getJSONArray, 'getJSONArray');
    RegisterMethod(@TJSONArray.getJSONObject, 'getJSONObject');
    RegisterMethod(@TJSONArray.getString, 'getString');
    RegisterMethod(@TJSONArray.isNull, 'isNull');
    RegisterMethod(@TJSONArray.join, 'join');
    RegisterMethod(@TJSONArray.length, 'length');
    RegisterMethod(@TJSONArray.opt, 'opt');
    RegisterMethod(@TJSONArrayoptBoolean_P, 'optBoolean');
    RegisterMethod(@TJSONArrayoptBoolean1_P, 'optBoolean1');
    RegisterMethod(@TJSONArrayoptDouble_P, 'optDouble');
    RegisterMethod(@TJSONArrayoptDouble1_P, 'optDouble1');
    RegisterMethod(@TJSONArrayoptInt_P, 'optInt');
    RegisterMethod(@TJSONArrayoptInt1_P, 'optInt1');
    RegisterMethod(@TJSONArrayoptJSONArray_P, 'optJSONArray');
    RegisterMethod(@TJSONArrayoptJSONObject_P, 'optJSONObject');
    RegisterMethod(@TJSONArrayoptString_P, 'optString');
    RegisterMethod(@TJSONArrayoptString1_P, 'optString1');
    RegisterMethod(@TJSONArrayput_P, 'put');
    RegisterMethod(@TJSONArrayput1_P, 'put1');
    RegisterMethod(@TJSONArrayput2_P, 'put2');
    RegisterMethod(@TJSONArrayput3_P, 'put3');
    RegisterMethod(@TJSONArrayput4_P, 'put4');
    RegisterMethod(@TJSONArrayput5_P, 'put5');
    RegisterMethod(@TJSONArrayput6_P, 'put6');
    RegisterMethod(@TJSONArrayput7_P, 'put7');
    RegisterMethod(@TJSONArrayput8_P, 'put8');
    RegisterMethod(@TJSONArrayput9_P, 'put9');
    RegisterMethod(@TJSONArraytoJSONObject_P, 'toJSONObject');
    RegisterMethod(@TJSONArraytoString1_P, 'toString1');
    RegisterMethod(@TJSONArraytoString2_P, 'toString2');
    RegisterMethod(@TJSONArray.toList, 'toList');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJSONObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJSONObject) do
  begin
    RegisterConstructor(@TJSONObjectcreate_P, 'create');
    RegisterConstructor(@TJSONObjectcreate1_P, 'create1');
    RegisterConstructor(@TJSONObjectcreate2_P, 'create2');
    RegisterConstructor(@TJSONObjectcreate3_P, 'create3');
    RegisterConstructor(@TJSONObjectcreate4_P, 'create4');
    RegisterMethod(@TJSONObject.clean, 'clean');
    RegisterMethod(@TJSONObject.clone, 'clone');
    RegisterMethod(@TJSONObject.accumulate, 'accumulate');
    RegisterMethod(@TJSONObject.get, 'get');
    RegisterMethod(@TJSONObject.getBoolean, 'getBoolean');
    RegisterMethod(@TJSONObject.getDouble, 'getDouble');
    RegisterMethod(@TJSONObject.getInt, 'getInt');
    RegisterMethod(@TJSONObject.getJSONArray, 'getJSONArray');
    RegisterMethod(@TJSONObject.getJSONObject, 'getJSONObject');
    RegisterMethod(@TJSONObject.getString, 'getString');
    RegisterMethod(@TJSONObject.has, 'has');
    RegisterMethod(@TJSONObject.isNull, 'isNull');
    RegisterMethod(@TJSONObject.keys, 'keys');
    RegisterMethod(@TJSONObject.length, 'length');
    RegisterMethod(@TJSONObject.names, 'names');
    RegisterMethod(@TJSONObject.numberToString, 'numberToString');
    RegisterMethod(@TJSONObjectvalueToString_P, 'valueToString');
    RegisterMethod(@TJSONObjectvalueToString1_P, 'valueToString1');
    RegisterMethod(@TJSONObject.opt, 'opt');
    RegisterMethod(@TJSONObjectoptBoolean_P, 'optBoolean');
    RegisterMethod(@TJSONObjectoptBoolean1_P, 'optBoolean1');
    RegisterMethod(@TJSONObjectoptDouble_P, 'optDouble');
    RegisterMethod(@TJSONObjectoptDouble1_P, 'optDouble1');
    RegisterMethod(@TJSONObjectoptInt_P, 'optInt');
    RegisterMethod(@TJSONObjectoptInt1_P, 'optInt1');
    RegisterMethod(@TJSONObjectoptString_P, 'optString');
    RegisterMethod(@TJSONObjectoptString1_P, 'optString1');
    RegisterMethod(@TJSONObjectoptJSONArray_P, 'optJSONArray');
    RegisterMethod(@TJSONObjectoptJSONObject_P, 'optJSONObject');
    RegisterMethod(@TJSONObjectput_P, 'put');
    RegisterMethod(@TJSONObjectput1_P, 'put1');
    RegisterMethod(@TJSONObjectput2_P, 'put2');
    RegisterMethod(@TJSONObjectput3_P, 'put3');
    RegisterMethod(@TJSONObjectput4_P, 'put4');
    RegisterMethod(@TJSONObject.putOpt, 'putOpt');
    RegisterMethod(@TJSONObject.quote, 'quote');
    RegisterMethod(@TJSONObject.remove, 'remove');
    RegisterMethod(@TJSONObject.assignTo, 'assignTo');
    RegisterMethod(@TJSONObject.toJSONArray, 'toJSONArray');
    RegisterMethod(@TJSONObjecttoString1_P, 'toString1');
    RegisterMethod(@TJSONObjecttoString2_P, 'toString2');
    RegisterMethod(@TJSONObject.NULL, 'NULL');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JSONTokener(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(JSONTokener) do
  begin
    RegisterConstructor(@JSONTokener.create, 'create');
    RegisterMethod(@JSONTokener.back, 'back');
    RegisterMethod(@JSONTokener.dehexchar, 'dehexchar');
    RegisterMethod(@JSONTokener.more, 'more');
    RegisterMethod(@JSONTokenernext_P, 'next');
    RegisterMethod(@JSONTokenernext1_P, 'next1');
    RegisterMethod(@JSONTokenernext2_P, 'next2');
    RegisterMethod(@JSONTokener.nextClean, 'nextClean');
    RegisterMethod(@JSONTokener.nextString, 'nextString');
    RegisterMethod(@JSONTokenernextTo_P, 'nextTo');
    RegisterMethod(@JSONTokenernextTo1_P, 'nextTo1');
    RegisterMethod(@JSONTokener.nextValue, 'nextValue');
    RegisterMethod(@JSONTokener.skipPast, 'skipPast');
    RegisterMethod(@JSONTokener.skipTo, 'skipTo');
    RegisterMethod(@JSONTokener.syntaxError, 'syntaxError');
    RegisterMethod(@JSONTokener.toString, 'toString');
    RegisterMethod(@JSONTokener.unescape, 'unescape');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ParseException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ParseException) do
  begin
    RegisterConstructor(@ParseException.create, 'create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NotImplmentedFeature(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(NotImplmentedFeature) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NullPointerException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(NullPointerException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NumberFormatException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(NumberFormatException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_NoSuchElementException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(NoSuchElementException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ClassCastException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ClassCastException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TZAbstractObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TZAbstractObject) do
  begin
    RegisterVirtualMethod(@TZAbstractObject.equals, 'equals');
    RegisterMethod(@TZAbstractObject.hash, 'hash');
    RegisterVirtualMethod(@TZAbstractObject.Clone, 'Clone');
    RegisterVirtualMethod(@TZAbstractObject.toString, 'toString');
    RegisterMethod(@TZAbstractObject.instanceOf, 'instanceOf');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uJSON(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TZAbstractObject(CL);
  RIRegister_ClassCastException(CL);
  RIRegister_NoSuchElementException(CL);
  RIRegister_NumberFormatException(CL);
  RIRegister_NullPointerException(CL);
  RIRegister_NotImplmentedFeature(CL);
  with CL.Add(TJSONArray) do
  with CL.Add(_Number) do
  with CL.Add(_String) do
  with CL.Add(_Double) do
  with CL.Add(NULL) do
  RIRegister_ParseException(CL);
  RIRegister_JSONTokener(CL);
  RIRegister_TJSONObject(CL);
  RIRegister_TJSONArray(CL);
  RIRegister__Number(CL);
  RIRegister__Boolean(CL);
  RIRegister__Double(CL);
  RIRegister__Integer(CL);
  RIRegister__String(CL);
  RIRegister_NULL(CL);
end;

 
 
{ TPSImport_uJSON }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uJSON.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uJSON(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uJSON.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uJSON(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
