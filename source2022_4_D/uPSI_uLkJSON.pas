unit uPSI_uLkJSON;
{
   another JSOM  with hash table
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
  TPSImport_uLkJSON = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TlkJSONstreamed(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSON(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONobject(CL: TPSPascalCompiler);
procedure SIRegister_TlkBalTree(CL: TPSPascalCompiler);
procedure SIRegister_TlkHashTable(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONobjectmethod(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONlist(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONcustomlist(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONnull(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONboolean(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONstring(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONnumber(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONbase(CL: TPSPascalCompiler);
procedure SIRegister_TlkJSONdotnetclass(CL: TPSPascalCompiler);
procedure SIRegister_uLkJSON(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_uLkJSON_Routines(S: TPSExec);
procedure RIRegister_TlkJSONstreamed(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSON(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONobject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkBalTree(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkHashTable(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONobjectmethod(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONlist(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONcustomlist(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONnull(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONboolean(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONstring(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONnumber(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONbase(CL: TPSRuntimeClassImporter);
procedure RIRegister_TlkJSONdotnetclass(CL: TPSRuntimeClassImporter);
procedure RIRegister_uLkJSON(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   windows
  //,kol
  ,variants
  ,uLkJSON
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uLkJSON]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONstreamed(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSON', 'TlkJSONstreamed') do
  with CL.AddClassN(CL.FindClass('TlkJSON'),'TlkJSONstreamed') do begin
    RegisterMethod('Function LoadFromStream( src : TStream) : TlkJSONbase');
    RegisterMethod('Procedure SaveToStream( obj : TlkJSONbase; dst : TStream)');
    RegisterMethod('Function LoadFromFile( srcname : string) : TlkJSONbase');
    RegisterMethod('Procedure SaveToFile( obj : TlkJSONbase; dstname : string)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSON(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TlkJSON') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TlkJSON') do begin
    RegisterMethod('Function ParseText( const txt : string) : TlkJSONbase');
    RegisterMethod('Function GenerateText( obj : TlkJSONbase) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONobject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONcustomlist', 'TlkJSONobject') do
  with CL.AddClassN(CL.FindClass('TlkJSONcustomlist'),'TlkJSONobject') do begin
    RegisterProperty('UseHash', 'Boolean', iptr);
    RegisterProperty('HashTable', 'TlkHashTable', iptr);
    //RegisterProperty('HashTable', 'TlkBalTree', iptr);
    RegisterMethod('Function Add6( const aname : WideString; aobj : TlkJSONbase) : Integer;');
    RegisterMethod('Function Add( const aname : WideString; aobj : TlkJSONbase) : Integer;');
    RegisterMethod('Function OldGetField( nm : WideString) : TlkJSONbase');
    RegisterMethod('Procedure OldSetField( nm : WideString; const AValue : TlkJSONbase)');
    RegisterMethod('Function Add1( const aname : WideString; aboolean : Boolean) : Integer;');
    RegisterMethod('Function Add7( const aname : WideString; aboolean : Boolean) : Integer;');
    RegisterMethod('Function Add8( const aname : WideString; nmb : double) : Integer;');
    RegisterMethod('Function Add9( const aname : WideString; s : string) : Integer;');
    RegisterMethod('Function Add10( const aname : WideString; const ws : WideString) : Integer;');
    RegisterMethod('Function Add11( const aname : WideString; inmb : Integer) : Integer;');
    RegisterMethod('Procedure Delete( idx : Integer)');
    RegisterMethod('Function IndexOfName( const aname : WideString) : Integer');
    RegisterMethod('Function IndexOfObject( aobj : TlkJSONbase) : Integer');
    RegisterProperty('Field', 'TlkJSONbase WideString', iptrw);
    SetDefaultPropery('Field');
    RegisterMethod('Constructor Create( bUseHash : Boolean)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Generate( AUseHash : Boolean) : TlkJSONobject');
    RegisterMethod('Function SelfType : TlkJSONtypes');
    RegisterMethod('Function SelfTypeName : string');
    RegisterProperty('FieldByIndex', 'TlkJSONbase Integer', iptrw);
    RegisterProperty('NameOf', 'WideString Integer', iptr);
    RegisterMethod('Function getDouble( idx : Integer) : Double;');
    RegisterMethod('Function getInt( idx : Integer) : Integer;');
    RegisterMethod('Function getString( idx : Integer) : string;');
    RegisterMethod('Function getWideString( idx : Integer) : WideString;');
    RegisterMethod('Function getBoolean( idx : Integer) : Boolean;');
    RegisterMethod('Function getDouble1( nm : string) : Double;');
    RegisterMethod('Function getInt1( nm : string) : Integer;');
    RegisterMethod('Function getString1( nm : string) : string;');
    RegisterMethod('Function getWideString1( nm : string) : WideString;');
    RegisterMethod('Function getBoolean1( nm : string) : Boolean;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkBalTree(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TlkBalTree') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TlkBalTree') do begin
    RegisterMethod('Function counters : string');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function Insert( const ws : WideString; x : Integer) : Boolean');
    RegisterMethod('Function Delete( const ws : WideString) : Boolean');
    RegisterMethod('Function IndexOf( const ws : WideString) : Integer');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkHashTable(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TlkHashTable') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TlkHashTable') do begin
    RegisterMethod('Function counters : string');
    RegisterMethod('Function DefaultHashOf( const ws : WideString) : cardinal');
    RegisterMethod('Function SimpleHashOf( const ws : WideString) : cardinal');
    RegisterProperty('HashOf', 'TlkHashFunction', iptrw);
    RegisterMethod('Function IndexOf( const ws : WideString) : Integer');
    RegisterMethod('Procedure AddPair( const ws : WideString; idx : Integer)');
    RegisterMethod('Procedure Delete( const ws : WideString)');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONobjectmethod(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONbase', 'TlkJSONobjectmethod') do
  with CL.AddClassN(CL.FindClass('TlkJSONbase'),'TlkJSONobjectmethod') do begin
    RegisterProperty('ObjValue', 'TlkJSONbase', iptr);
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Procedure BeforeDestruction');
    RegisterProperty('Name', 'WideString', iptrw);
    RegisterMethod('Function Generate( const aname : WideString; aobj : TlkJSONbase) : TlkJSONobjectmethod');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONlist(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONcustomlist', 'TlkJSONlist') do
  with CL.AddClassN(CL.FindClass('TlkJSONcustomlist'),'TlkJSONlist') do begin
    RegisterMethod('Function Add( obj : TlkJSONbase) : Integer;');
    RegisterMethod('Function Add1( aboolean : Boolean) : Integer;');
    RegisterMethod('Function Add2( nmb : double) : Integer;');
    RegisterMethod('Function Add3( s : string) : Integer;');
    RegisterMethod('Function Add4( const ws : WideString) : Integer;');
    RegisterMethod('Function Add5( inmb : Integer) : Integer;');
    RegisterMethod('Procedure Delete( idx : Integer)');
    RegisterMethod('Function IndexOf( obj : TlkJSONbase) : Integer');
    RegisterMethod('Function Generate : TlkJSONlist');
    RegisterMethod('Function SelfType : TlkJSONtypes');
    RegisterMethod('Function SelfTypeName : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONcustomlist(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONbase', 'TlkJSONcustomlist') do
  with CL.AddClassN(CL.FindClass('TlkJSONbase'),'TlkJSONcustomlist') do begin
    RegisterMethod('Procedure ForEach( fnCallBack : TlkJSONFuncEnum; pUserData : pointer)');
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Procedure BeforeDestruction');
    RegisterMethod('Function getInt( idx : Integer) : Integer');
    RegisterMethod('Function getString( idx : Integer) : string');
    RegisterMethod('Function getWideString( idx : Integer) : WideString');
    RegisterMethod('Function getDouble( idx : Integer) : Double');
    RegisterMethod('Function getBoolean( idx : Integer) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONnull(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONbase', 'TlkJSONnull') do
  with CL.AddClassN(CL.FindClass('TlkJSONbase'),'TlkJSONnull') do
  begin
    RegisterMethod('Function SelfType : TlkJSONtypes');
    RegisterMethod('Function SelfTypeName : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONboolean(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONbase', 'TlkJSONboolean') do
  with CL.AddClassN(CL.FindClass('TlkJSONbase'),'TlkJSONboolean') do begin
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Function Generate( AValue : Boolean) : TlkJSONboolean');
    RegisterMethod('Function SelfType : TlkJSONtypes');
    RegisterMethod('Function SelfTypeName : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONstring(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONbase', 'TlkJSONstring') do
  with CL.AddClassN(CL.FindClass('TlkJSONbase'),'TlkJSONstring') do begin
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Function Generate( const wsValue : WideString) : TlkJSONstring');
    RegisterMethod('Function SelfType : TlkJSONtypes');
    RegisterMethod('Function SelfTypeName : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONnumber(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONbase', 'TlkJSONnumber') do
  with CL.AddClassN(CL.FindClass('TlkJSONbase'),'TlkJSONnumber') do begin
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Function Generate( AValue : extended) : TlkJSONnumber');
    RegisterMethod('Function SelfType : TlkJSONtypes');
    RegisterMethod('Function SelfTypeName : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONbase(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TlkJSONdotnetclass', 'TlkJSONbase') do
  with CL.AddClassN(CL.FindClass('TlkJSONdotnetclass'),'TlkJSONbase') do begin
    RegisterProperty('Field', 'TlkJSONbase Variant', iptr);
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Child', 'TlkJSONbase Integer', iptrw);
    RegisterProperty('Value', 'variant', iptrw);
    RegisterMethod('Function SelfType : TlkJSONtypes');
    RegisterMethod('Function SelfTypeName : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TlkJSONdotnetclass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TlkJSONdotnetclass') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TlkJSONdotnetclass') do begin
    RegisterMethod('Constructor Create');
    //RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Procedure BeforeDestruction');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uLkJSON(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TlkJSONtypes', '( jsBase, jsNumber, jsString, jsBoolean, jsNull,'
   +' jsList, jsObject )');
  SIRegister_TlkJSONdotnetclass(CL);
  SIRegister_TlkJSONbase(CL);
  SIRegister_TlkJSONnumber(CL);
  SIRegister_TlkJSONstring(CL);
  SIRegister_TlkJSONboolean(CL);
  SIRegister_TlkJSONnull(CL);
  CL.AddTypeS('TlkJSONFuncEnum', 'Procedure ( ElName : string; Elem : TlkJSONba'
   +'se; data : TObject; var Continue : Boolean)');
  SIRegister_TlkJSONcustomlist(CL);
  SIRegister_TlkJSONlist(CL);
  SIRegister_TlkJSONobjectmethod(CL);
 // CL.AddTypeS('PlkHashItem', '^TlkHashItem // will not work');
  CL.AddTypeS('TlkHashItem', 'record hash : cardinal; index : Integer; end');
  CL.AddTypeS('TlkHashFunction', 'Function ( const ws : WideString) : cardinal');
  SIRegister_TlkHashTable(CL);
  //CL.AddTypeS('PlkBalNode', '^TlkBalNode // will not work');
  //CL.AddTypeS('TlkBalNode', 'record left : PlkBalNode; right : PlkBalNode; leve'
   //+'l : byte; key : Integer; nm : WideString; end');
  SIRegister_TlkBalTree(CL);
  SIRegister_TlkJSONobject(CL);
  SIRegister_TlkJSON(CL);
  SIRegister_TlkJSONstreamed(CL);
 CL.AddDelphiFunction('Function GenerateReadableText( vObj : TlkJSONbase; var vLevel : Integer) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetBoolean1_P(Self: TlkJSONobject;  nm : string) : Boolean;
Begin Result := Self.getBoolean(nm); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetWideString1_P(Self: TlkJSONobject;  nm : string) : WideString;
Begin Result := Self.getWideString(nm); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetString1_P(Self: TlkJSONobject;  nm : string) : string;
Begin Result := Self.getString(nm); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetInt1_P(Self: TlkJSONobject;  nm : string) : Integer;
Begin Result := Self.getInt(nm); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetDouble1_P(Self: TlkJSONobject;  nm : string) : Double;
Begin Result := Self.getDouble(nm); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetBoolean_P(Self: TlkJSONobject;  idx : Integer) : Boolean;
Begin Result := Self.getBoolean(idx); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetWideString_P(Self: TlkJSONobject;  idx : Integer) : WideString;
Begin Result := Self.getWideString(idx); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetString_P(Self: TlkJSONobject;  idx : Integer) : string;
Begin Result := Self.getString(idx); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetInt_P(Self: TlkJSONobject;  idx : Integer) : Integer;
Begin Result := Self.getInt(idx); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectgetDouble_P(Self: TlkJSONobject;  idx : Integer) : Double;
Begin Result := Self.getDouble(idx); END;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectNameOf_R(Self: TlkJSONobject; var T: WideString; const t1: Integer);
begin T := Self.NameOf[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectFieldByIndex_W(Self: TlkJSONobject; const T: TlkJSONbase; const t1: Integer);
begin Self.FieldByIndex[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectFieldByIndex_R(Self: TlkJSONobject; var T: TlkJSONbase; const t1: Integer);
begin T := Self.FieldByIndex[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectField_W(Self: TlkJSONobject; const T: TlkJSONbase; const t1: WideString);
begin Self.Field[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectField_R(Self: TlkJSONobject; var T: TlkJSONbase; const t1: WideString);
begin T := Self.Field[t1]; end;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectAdd11_P(Self: TlkJSONobject;  const aname : WideString; inmb : Integer) : Integer;
Begin Result := Self.Add(aname, inmb); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectAdd10_P(Self: TlkJSONobject;  const aname : WideString; const ws : WideString) : Integer;
Begin Result := Self.Add(aname, ws); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectAdd9_P(Self: TlkJSONobject;  const aname : WideString; s : string) : Integer;
Begin Result := Self.Add(aname, s); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectAdd8_P(Self: TlkJSONobject;  const aname : WideString; nmb : double) : Integer;
Begin Result := Self.Add(aname, nmb); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectAdd7_P(Self: TlkJSONobject;  const aname : WideString; aboolean : Boolean) : Integer;
Begin Result := Self.Add(aname, aboolean); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONobjectAdd6_P(Self: TlkJSONobject;  const aname : WideString; aobj : TlkJSONbase) : Integer;
Begin Result := Self.Add(aname, aobj); END;

(*----------------------------------------------------------------------------*)
//procedure TlkJSONobjectHashTable_R(Self: TlkJSONobject; var T: TlkBalTree);
//begin T := Self.HashTable; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectHashTable_R(Self: TlkJSONobject; var T: TlkHashTable);
begin T := Self.HashTable; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectUseHash_R(Self: TlkJSONobject; var T: Boolean);
begin T := Self.UseHash; end;

(*----------------------------------------------------------------------------*)
procedure TlkHashTableHashOf_W(Self: TlkHashTable; const T: TlkHashFunction);
begin Self.HashOf := T; end;

(*----------------------------------------------------------------------------*)
procedure TlkHashTableHashOf_R(Self: TlkHashTable; var T: TlkHashFunction);
begin T := Self.HashOf; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectmethodName_W(Self: TlkJSONobjectmethod; const T: WideString);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectmethodName_R(Self: TlkJSONobjectmethod; var T: WideString);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONobjectmethodObjValue_R(Self: TlkJSONobjectmethod; var T: TlkJSONbase);
begin T := Self.ObjValue; end;

(*----------------------------------------------------------------------------*)
Function TlkJSONlistAdd5_P(Self: TlkJSONlist;  inmb : Integer) : Integer;
Begin Result := Self.Add(inmb); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONlistAdd4_P(Self: TlkJSONlist;  const ws : WideString) : Integer;
Begin Result := Self.Add(ws); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONlistAdd3_P(Self: TlkJSONlist;  s : string) : Integer;
Begin Result := Self.Add(s); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONlistAdd2_P(Self: TlkJSONlist;  nmb : double) : Integer;
Begin Result := Self.Add(nmb); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONlistAdd1_P(Self: TlkJSONlist;  aboolean : Boolean) : Integer;
Begin Result := Self.Add(aboolean); END;

(*----------------------------------------------------------------------------*)
Function TlkJSONlistAdd_P(Self: TlkJSONlist;  obj : TlkJSONbase) : Integer;
Begin Result := Self.Add(obj); END;

(*----------------------------------------------------------------------------*)
procedure TlkJSONbaseValue_W(Self: TlkJSONbase; const T: variant);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONbaseValue_R(Self: TlkJSONbase; var T: variant);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONbaseChild_W(Self: TlkJSONbase; const T: TlkJSONbase; const t1: Integer);
begin Self.Child[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONbaseChild_R(Self: TlkJSONbase; var T: TlkJSONbase; const t1: Integer);
begin T := Self.Child[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONbaseCount_R(Self: TlkJSONbase; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TlkJSONbaseField_R(Self: TlkJSONbase; var T: TlkJSONbase; const t1: Variant);
begin T := Self.Field[t1]; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uLkJSON_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GenerateReadableText, 'GenerateReadableText', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONstreamed(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONstreamed) do
  begin
    RegisterMethod(@TlkJSONstreamed.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TlkJSONstreamed.SaveToStream, 'SaveToStream');
    RegisterMethod(@TlkJSONstreamed.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TlkJSONstreamed.SaveToFile, 'SaveToFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSON(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSON) do begin
    RegisterMethod(@TlkJSON.ParseText, 'ParseText');
    RegisterMethod(@TlkJSON.GenerateText, 'GenerateText');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONobject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONobject) do begin
    RegisterPropertyHelper(@TlkJSONobjectUseHash_R,nil,'UseHash');
    RegisterPropertyHelper(@TlkJSONobjectHashTable_R,nil,'HashTable');
    RegisterPropertyHelper(@TlkJSONobjectHashTable_R,nil,'HashTable');
    RegisterMethod(@TlkJSONobjectAdd6_P, 'Add');    //alias
    RegisterMethod(@TlkJSONobjectAdd6_P, 'Add6');
    RegisterMethod(@TlkJSONobject.OldGetField, 'OldGetField');
    RegisterMethod(@TlkJSONobject.OldSetField, 'OldSetField');
    RegisterMethod(@TlkJSONobjectAdd7_P, 'Add7');
    RegisterMethod(@TlkJSONobjectAdd7_P, 'Add1');
    RegisterMethod(@TlkJSONobjectAdd8_P, 'Add8');
    RegisterMethod(@TlkJSONobjectAdd9_P, 'Add9');
    RegisterMethod(@TlkJSONobjectAdd10_P, 'Add10');
    RegisterMethod(@TlkJSONobjectAdd11_P, 'Add11');
    RegisterMethod(@TlkJSONobject.Delete, 'Delete');
    RegisterMethod(@TlkJSONobject.IndexOfName, 'IndexOfName');
    RegisterMethod(@TlkJSONobject.IndexOfObject, 'IndexOfObject');
    RegisterPropertyHelper(@TlkJSONobjectField_R,@TlkJSONobjectField_W,'Field');
    RegisterConstructor(@TlkJSONobject.Create, 'Create');
    RegisterMethod(@TlkJSONobject.Destroy, 'Free');
    RegisterMethod(@TlkJSONobject.Generate, 'Generate');
    RegisterMethod(@TlkJSONobject.SelfType, 'SelfType');
    RegisterMethod(@TlkJSONobject.SelfTypeName, 'SelfTypeName');
    RegisterPropertyHelper(@TlkJSONobjectFieldByIndex_R,@TlkJSONobjectFieldByIndex_W,'FieldByIndex');
    RegisterPropertyHelper(@TlkJSONobjectNameOf_R,nil,'NameOf');
    RegisterMethod(@TlkJSONobjectgetDouble_P, 'getDouble');
    RegisterMethod(@TlkJSONobjectgetInt_P, 'getInt');
    RegisterMethod(@TlkJSONobjectgetString_P, 'getString');
    RegisterMethod(@TlkJSONobjectgetWideString_P, 'getWideString');
    RegisterMethod(@TlkJSONobjectgetBoolean_P, 'getBoolean');
    RegisterMethod(@TlkJSONobjectgetDouble1_P, 'getDouble1');
    RegisterMethod(@TlkJSONobjectgetInt1_P, 'getInt1');
    RegisterMethod(@TlkJSONobjectgetString1_P, 'getString1');
    RegisterMethod(@TlkJSONobjectgetWideString1_P, 'getWideString1');
    RegisterMethod(@TlkJSONobjectgetBoolean1_P, 'getBoolean1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkBalTree(CL: TPSRuntimeClassImporter);
begin
  (*with CL.Add(TlkBalTree) do begin
    RegisterMethod(@TlkBalTree.counters, 'counters');
    RegisterMethod(@TlkBalTree.Clear, 'Clear');
    RegisterMethod(@TlkBalTree.Insert, 'Insert');
    RegisterMethod(@TlkBalTree.Delete, 'Delete');
    RegisterMethod(@TlkBalTree.IndexOf, 'IndexOf');
    RegisterConstructor(@TlkBalTree.Create, 'Create');
  end;*)
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkHashTable(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkHashTable) do begin
    RegisterMethod(@TlkHashTable.counters, 'counters');
    RegisterMethod(@TlkHashTable.DefaultHashOf, 'DefaultHashOf');
    RegisterMethod(@TlkHashTable.SimpleHashOf, 'SimpleHashOf');
    RegisterPropertyHelper(@TlkHashTableHashOf_R,@TlkHashTableHashOf_W,'HashOf');
    RegisterMethod(@TlkHashTable.IndexOf, 'IndexOf');
    RegisterMethod(@TlkHashTable.AddPair, 'AddPair');
    RegisterMethod(@TlkHashTable.Delete, 'Delete');
    RegisterConstructor(@TlkHashTable.Create, 'Create');
    RegisterMethod(@TlkHashTable.Destroy, 'Free');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONobjectmethod(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONobjectmethod) do begin
    RegisterPropertyHelper(@TlkJSONobjectmethodObjValue_R,nil,'ObjValue');
    RegisterMethod(@TlkJSONobjectmethod.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TlkJSONobjectmethod.BeforeDestruction, 'BeforeDestruction');
    RegisterPropertyHelper(@TlkJSONobjectmethodName_R,@TlkJSONobjectmethodName_W,'Name');
    RegisterMethod(@TlkJSONobjectmethod.Generate, 'Generate');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONlist(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONlist) do begin
    RegisterMethod(@TlkJSONlistAdd_P, 'Add');
    RegisterMethod(@TlkJSONlistAdd1_P, 'Add1');
    RegisterMethod(@TlkJSONlistAdd2_P, 'Add2');
    RegisterMethod(@TlkJSONlistAdd3_P, 'Add3');
    RegisterMethod(@TlkJSONlistAdd4_P, 'Add4');
    RegisterMethod(@TlkJSONlistAdd5_P, 'Add5');
    RegisterMethod(@TlkJSONlist.Delete, 'Delete');
    RegisterMethod(@TlkJSONlist.IndexOf, 'IndexOf');
    RegisterMethod(@TlkJSONlist.Generate, 'Generate');
    RegisterMethod(@TlkJSONlist.SelfType, 'SelfType');
    RegisterMethod(@TlkJSONlist.SelfTypeName, 'SelfTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONcustomlist(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONcustomlist) do begin
    RegisterMethod(@TlkJSONcustomlist.ForEach, 'ForEach');
    RegisterMethod(@TlkJSONcustomlist.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TlkJSONcustomlist.BeforeDestruction, 'BeforeDestruction');
    RegisterVirtualMethod(@TlkJSONcustomlist.getInt, 'getInt');
    RegisterVirtualMethod(@TlkJSONcustomlist.getString, 'getString');
    RegisterVirtualMethod(@TlkJSONcustomlist.getWideString, 'getWideString');
    RegisterVirtualMethod(@TlkJSONcustomlist.getDouble, 'getDouble');
    RegisterVirtualMethod(@TlkJSONcustomlist.getBoolean, 'getBoolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONnull(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONnull) do
  begin
    RegisterMethod(@TlkJSONnull.SelfType, 'SelfType');
    RegisterMethod(@TlkJSONnull.SelfTypeName, 'SelfTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONboolean(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONboolean) do
  begin
    RegisterMethod(@TlkJSONboolean.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TlkJSONboolean.Generate, 'Generate');
    RegisterMethod(@TlkJSONboolean.SelfType, 'SelfType');
    RegisterMethod(@TlkJSONboolean.SelfTypeName, 'SelfTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONstring(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONstring) do
  begin
    RegisterMethod(@TlkJSONstring.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TlkJSONstring.Generate, 'Generate');
    RegisterMethod(@TlkJSONstring.SelfType, 'SelfType');
    RegisterMethod(@TlkJSONstring.SelfTypeName, 'SelfTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONnumber(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONnumber) do begin
    RegisterMethod(@TlkJSONnumber.AfterConstruction, 'AfterConstruction');
    RegisterMethod(@TlkJSONnumber.Generate, 'Generate');
    RegisterMethod(@TlkJSONnumber.SelfType, 'SelfType');
    RegisterMethod(@TlkJSONnumber.SelfTypeName, 'SelfTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONbase(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TlkJSONbase) do begin
    RegisterPropertyHelper(@TlkJSONbaseField_R,nil,'Field');
    RegisterPropertyHelper(@TlkJSONbaseCount_R,nil,'Count');
    RegisterPropertyHelper(@TlkJSONbaseChild_R,@TlkJSONbaseChild_W,'Child');
    RegisterPropertyHelper(@TlkJSONbaseValue_R,@TlkJSONbaseValue_W,'Value');
    RegisterVirtualMethod(@TlkJSONbase.SelfType, 'SelfType');
    RegisterVirtualMethod(@TlkJSONbase.SelfTypeName, 'SelfTypeName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TlkJSONdotnetclass(CL: TPSRuntimeClassImporter);
begin
 (* with CL.Add(TlkJSONdotnetclass) do
  begin
    RegisterConstructor(@TlkJSONdotnetclass.Create, 'Create');
    RegisterVirtualMethod(@TlkJSONdotnetclass.AfterConstruction, 'AfterConstruction');
    RegisterVirtualMethod(@TlkJSONdotnetclass.BeforeDestruction, 'BeforeDestruction');
  end; *)
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_uLkJSON(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TlkJSONdotnetclass(CL);
  RIRegister_TlkJSONbase(CL);
  RIRegister_TlkJSONnumber(CL);
  RIRegister_TlkJSONstring(CL);
  RIRegister_TlkJSONboolean(CL);
  RIRegister_TlkJSONnull(CL);
  RIRegister_TlkJSONcustomlist(CL);
  RIRegister_TlkJSONlist(CL);
  RIRegister_TlkJSONobjectmethod(CL);
  RIRegister_TlkHashTable(CL);
  RIRegister_TlkBalTree(CL);
  RIRegister_TlkJSONobject(CL);
  RIRegister_TlkJSON(CL);
  RIRegister_TlkJSONstreamed(CL);
end;

 
 
{ TPSImport_uLkJSON }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uLkJSON.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uLkJSON(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uLkJSON.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uLkJSON(ri);
  RIRegister_uLkJSON_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
