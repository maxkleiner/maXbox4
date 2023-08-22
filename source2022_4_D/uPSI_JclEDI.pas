unit uPSI_JclEDI;
{
   EDIFact base
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
  TPSImport_JclEDI = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TEDILoopStack(CL: TPSPascalCompiler);
procedure SIRegister_TEDIDataObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TEDIDataObjectListItem(CL: TPSPascalCompiler);
procedure SIRegister_TEDIObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TEDIObjectListItem(CL: TPSPascalCompiler);
procedure SIRegister_TEDIDataObjectGroup(CL: TPSPascalCompiler);
procedure SIRegister_TEDIDataObject(CL: TPSPascalCompiler);
procedure SIRegister_TEDIDelimiters(CL: TPSPascalCompiler);
procedure SIRegister_EJclEDIError(CL: TPSPascalCompiler);
procedure SIRegister_JclEDI(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclEDI_Routines(S: TPSExec);
procedure RIRegister_TEDILoopStack(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEDIDataObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEDIDataObjectListItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEDIObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEDIObjectListItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEDIDataObjectGroup(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEDIDataObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TEDIDelimiters(CL: TPSRuntimeClassImporter);
procedure RIRegister_EJclEDIError(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclEDI(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
  // JclUnitVersioning
  JclBase
  ,JclEDI
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclEDI]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TEDILoopStack(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEDIObject', 'TEDILoopStack') do
  with CL.AddClassN(CL.FindClass('TEDIObject'),'TEDILoopStack') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function Peek : TEDILoopStackRecord;');
    RegisterMethod('Function Peek1( Index : Integer) : TEDILoopStackRecord;');
    RegisterMethod('Procedure Pop( Index : Integer)');
    RegisterMethod('Function Push( SegmentId, OwnerLoopId, ParentLoopId : string; StartIndex : Integer; EDIObject : TEDIObject) : Integer');
    RegisterMethod('Function GetSafeStackIndex( Index : Integer) : Integer');
    RegisterMethod('Function SetStackPointer( OwnerLoopId, ParentLoopId : string) : Integer');
    RegisterMethod('Procedure UpdateStackObject( EDIObject : TEDIObject)');
    RegisterMethod('Procedure UpdateStackData( SegmentId, OwnerLoopId, ParentLoopId : string; StartIndex : Integer; EDIObject : TEDIObject)');
    RegisterMethod('Function ValidateLoopStack( SegmentId, OwnerLoopId, ParentLoopId : string; StartIndex : Integer; EDIObject : TEDIObject) : TEDILoopStackRecord');
    RegisterMethod('Function Debug : string');
    RegisterProperty('Stack', 'TEDILoopStackArray', iptr);
    RegisterProperty('Size', 'Integer', iptr);
    RegisterProperty('Flags', 'TEDILoopStackFlagSet', iptrw);
    RegisterProperty('OnAddLoop', 'TEDILoopStackOnAddLoopEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEDIDataObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEDIObjectList', 'TEDIDataObjectList') do
  with CL.AddClassN(CL.FindClass('TEDIObjectList'),'TEDIDataObjectList') do
  begin
    RegisterProperty('EDIDataObject', 'TEDIDataObject Integer', iptrw);
    SetDefaultPropery('EDIDataObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEDIDataObjectListItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEDIObjectListItem', 'TEDIDataObjectListItem') do
  with CL.AddClassN(CL.FindClass('TEDIObjectListItem'),'TEDIDataObjectListItem') do
  begin
    RegisterProperty('EDIDataObject', 'TEDIDataObject', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEDIObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEDIObject', 'TEDIObjectList') do
  with CL.AddClassN(CL.FindClass('TEDIObject'),'TEDIObjectList') do begin
    RegisterMethod('Constructor Create( OwnsObjects : Boolean)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Add( Item : TEDIObjectListItem; Name : string);');
    RegisterMethod('Function Add1( EDIObject : TEDIObject; Name : string) : TEDIObjectListItem;');
    RegisterMethod('Function CreateListItem( PriorItem : TEDIObjectListItem; EDIObject : TEDIObject) : TEDIObjectListItem');
    RegisterMethod('Function Find( Item : TEDIObjectListItem) : TEDIObjectListItem;');
    RegisterMethod('Function Find1( EDIObject : TEDIObject) : TEDIObjectListItem;');
    RegisterMethod('Function FindEDIObject( EDIObject : TEDIObject) : TEDIObject');
    RegisterMethod('Function Extract( Item : TEDIObjectListItem) : TEDIObjectListItem;');
    RegisterMethod('Function Extract1( EDIObject : TEDIObject) : TEDIObject;');
    RegisterMethod('Procedure Remove( Item : TEDIObjectListItem);');
    RegisterMethod('Procedure Remove1( EDIObject : TEDIObject);');
    RegisterMethod('Function Insert( Item, BeforeItem : TEDIObjectListItem) : TEDIObjectListItem;');
    RegisterMethod('Function Insert1( EDIObject, BeforeEDIObject : TEDIObject) : TEDIObjectListItem;');
    RegisterMethod('Function Insert1( BeforeItem : TEDIObjectListItem) : TEDIObjectListItem;');
    RegisterMethod('Function Insert2( BeforeEDIObject : TEDIObject) : TEDIObjectListItem;');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function First( Index : Integer) : TEDIObjectListItem');
    RegisterMethod('Function Next : TEDIObjectListItem');
    RegisterMethod('Function Prior : TEDIObjectListItem');
    RegisterMethod('Function Last : TEDIObjectListItem');
    RegisterMethod('Procedure UpdateCount');
    RegisterMethod('Function FindItemByName( Name : string; StartItem : TEDIObjectListItem) : TEDIObjectListItem');
    RegisterMethod('Function ReturnListItemsByName( Name : string) : TEDIObjectList');
    RegisterMethod('Function IndexOf( Item : TEDIObjectListItem) : Integer;');
    RegisterMethod('Function IndexOf1( EDIObject : TEDIObject) : Integer;');
    RegisterMethod('Function IndexIsValid( Index : Integer) : Boolean');
    RegisterMethod('Procedure Insert( InsertIndex : Integer; EDIObject : TEDIObject);');
    RegisterMethod('Procedure Delete( Index : Integer);');
    RegisterMethod('Procedure Delete1( EDIObject : TEDIObject);');
    RegisterMethod('Procedure UpdateIndexes( StartItem : TEDIObjectListItem)');
    RegisterProperty('Item', 'TEDIObjectListItem Integer', iptr);
    RegisterProperty('EDIObject', 'TEDIObject Integer', iptrw);
    SetDefaultPropery('EDIObject');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('OwnsObjects', 'Boolean', iptrw);
    RegisterProperty('Options', 'TEDIDataObjectListOptions', iptrw);
    RegisterProperty('CurrentItem', 'TEDIObjectListItem', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEDIObjectListItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEDIObject', 'TEDIObjectListItem') do
  with CL.AddClassN(CL.FindClass('TEDIObject'),'TEDIObjectListItem') do begin
    RegisterMethod('Constructor Create( Parent : TEDIObjectList; PriorItem : TEDIObjectListItem; EDIObject : TEDIObject)');
    RegisterMethod('Function GetIndexPositionFromParent : Integer');
    RegisterMethod('Procedure FreeAndNilEDIDataObject');
    RegisterProperty('ItemIndex', 'Integer', iptrw);
    RegisterProperty('PriorItem', 'TEDIObjectListItem', iptrw);
    RegisterProperty('NextItem', 'TEDIObjectListItem', iptrw);
    RegisterProperty('EDIObject', 'TEDIObject', iptrw);
    RegisterProperty('Name', 'string', iptrw);
    RegisterProperty('Parent', 'TEDIObjectList', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEDIDataObjectGroup(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEDIDataObject', 'TEDIDataObjectGroup') do
  with CL.AddClassN(CL.FindClass('TEDIDataObject'),'TEDIDataObjectGroup') do begin
    RegisterMethod('Constructor Create( Parent : TEDIDataObject; EDIDataObjectCount : Integer)');
    RegisterMethod('Function IndexIsValid( Index : Integer) : Boolean');
    RegisterMethod('Function AddEDIDataObject : Integer');
    RegisterMethod('Function AppendEDIDataObject( EDIDataObject : TEDIDataObject) : Integer');
    RegisterMethod('Function InsertEDIDataObject1( InsertIndex : Integer) : Integer;');
    RegisterMethod('Function InsertEDIDataObject2( InsertIndex : Integer; EDIDataObject : TEDIDataObject) : Integer;');
    RegisterMethod('Procedure DeleteEDIDataObject( Index : Integer);');
    RegisterMethod('Procedure DeleteEDIDataObject1( EDIDataObject : TEDIDataObject);');
    RegisterMethod('Function AddEDIDataObjects( Count : Integer) : Integer');
    RegisterMethod('Function AppendEDIDataObjects( EDIDataObjectArray : TEDIDataObjectArray) : Integer');
    RegisterMethod('Function InsertEDIDataObjects( InsertIndex, Count : Integer) : Integer;');
    RegisterMethod('Function InsertEDIDataObjects1( InsertIndex : Integer; EDIDataObjectArray : TEDIDataObjectArray) : Integer;');
    RegisterMethod('Procedure DeleteEDIDataObjects;');
    RegisterMethod('Procedure DeleteEDIDataObjects1( Index, Count : Integer);');
    RegisterMethod('Function GetIndexPositionFromParent : Integer');
    RegisterProperty('EDIDataObject', 'TEDIDataObject Integer', iptrw);
    SetDefaultPropery('EDIDataObject');
    RegisterProperty('EDIDataObjects', 'TEDIDataObjectList', iptr);
    RegisterProperty('CreateObjectType', 'TEDIDataObjectType', iptr);
    RegisterProperty('EDIDataObjectCount', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEDIDataObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEDIObject', 'TEDIDataObject') do
  with CL.AddClassN(CL.FindClass('TEDIObject'),'TEDIDataObject') do begin
    RegisterMethod('Constructor Create( Parent : TEDIDataObject)');
    RegisterMethod('Function Assemble : string');
    RegisterMethod('Procedure Disassemble');
    RegisterProperty('SpecPointer', 'TEDIObject', iptrw);
    RegisterProperty('CustomData1', 'TCustomData', iptrw);
    RegisterProperty('CustomData2', 'TCustomData', iptrw);
    RegisterProperty('State', 'TEDIDataObjectDataState', iptr);
    RegisterProperty('Data', 'string', iptrw);
    RegisterProperty('DataLength', 'Integer', iptr);
    RegisterProperty('Parent', 'TEDIDataObject', iptrw);
    RegisterProperty('Delimiters', 'TEDIDelimiters', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TEDIDelimiters(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEDIObject', 'TEDIDelimiters') do
  with CL.AddClassN(CL.FindClass('TEDIObject'),'TEDIDelimiters') do begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( const SD, ED, SS : string);');
    RegisterProperty('SD', 'string', iptrw);
    RegisterProperty('ED', 'string', iptrw);
    RegisterProperty('SS', 'string', iptrw);
    RegisterProperty('SDLen', 'Integer', iptr);
    RegisterProperty('EDLen', 'Integer', iptr);
    RegisterProperty('SSLen', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EJclEDIError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EJclError', 'EJclEDIError') do
  with CL.AddClassN(CL.FindClass('EJclError'),'EJclEDIError') do begin
    RegisterMethod('Constructor CreateID( ID : Cardinal)');
    RegisterMethod('Constructor CreateIDFmt( ID : Cardinal; const Args : array of const)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclEDI(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('NA_LoopId','String').SetString( 'N/A');
 CL.AddConstantN('ElementSpecId_Reserved','String').SetString( 'Reserved');
 CL.AddConstantN('EDIDataType_Numeric','String').SetString( 'N');
 CL.AddConstantN('EDIDataType_Decimal','String').SetString( 'R');
 CL.AddConstantN('EDIDataType_Identifier','String').SetString( 'ID');
 CL.AddConstantN('EDIDataType_String','String').SetString( 'AN');
 CL.AddConstantN('EDIDataType_Date','String').SetString( 'DT');
 CL.AddConstantN('EDIDataType_Time','String').SetString( 'TM');
 CL.AddConstantN('EDIDataType_Binary','String').SetString( 'B');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEDIObject');
  CL.AddTypeS('TEDIObjectArray', 'array of TEDIObject');
  SIRegister_EJclEDIError(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEDIDataObject');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEDIDataObjectGroup');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEDIObjectListItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEDIObjectList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEDIDataObjectListItem');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TEDIDataObjectList');
  SIRegister_TEDIDelimiters(CL);
  CL.AddTypeS('TEDIDataObjectType', '( ediUnknown, ediElement, ediCompositeElem'
   +'ent, ediSegment, ediLoop, ediTransactionSet, ediMessage, ediFunctionalGrou'
   +'p, ediInterchangeControl, ediFile, ediCustom )');
  CL.AddTypeS('TEDIDataObjectDataState', '( ediCreated, ediAssembled, ediDisassembled )');
  CL.AddTypeS('TCustomData', 'TObject');
  //CL.AddTypeS('TCustomData', 'Pointer');
  SIRegister_TEDIDataObject(CL);
  CL.AddTypeS('TEDIDataObjectArray', 'array of TEDIDataObject');
  SIRegister_TEDIDataObjectGroup(CL);
  CL.AddTypeS('TEDIDataObjectGroupArray', 'array of TEDIDataObjectGroup');
  SIRegister_TEDIObjectListItem(CL);
  //CL.AddTypeS('TEDIDataObjectListOptions', 'set of ( loAutoUpdateIndexes )');
  SIRegister_TEDIObjectList(CL);
  SIRegister_TEDIDataObjectListItem(CL);
  SIRegister_TEDIDataObjectList(CL);
  CL.AddTypeS('TEDILoopStackRecord', 'record SegmentId : string; SpecStartIndex'
   +' : Integer; OwnerLoopId: string; ParentLoopId: string; EDIObject: TEDIObject; EDISpecObject : TEDIObject; end');
  CL.AddTypeS('TEDILoopStackArray', 'array of TEDILoopStackRecord');
  CL.AddTypeS('TEDILoopStackFlags', '( ediAltStackPointer, ediStackResized, ediLoopRepeated )');
  CL.AddTypeS('TEDILoopStackFlagSet', 'set of TEDILoopStackFlags');
  CL.AddTypeS('TEDILoopStackOnAddLoopEvent', 'Procedure ( StackRecord : TEDILoo'
   +'pStackRecord; SegmentId, OwnerLoopId, ParentLoopId : string; var EDIObject: TEDIObject)');
  SIRegister_TEDILoopStack(CL);
 CL.AddDelphiFunction('Function StringRemove( const S, Pattern : string; Flags : TReplaceFlags) : string');
 CL.AddDelphiFunction('Function JStringReplace( const S, OldPattern, NewPattern : string; Flags : TReplaceFlags) : string');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TEDILoopStackOnAddLoop_W(Self: TEDILoopStack; const T: TEDILoopStackOnAddLoopEvent);
begin Self.OnAddLoop := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDILoopStackOnAddLoop_R(Self: TEDILoopStack; var T: TEDILoopStackOnAddLoopEvent);
begin T := Self.OnAddLoop; end;

(*----------------------------------------------------------------------------*)
procedure TEDILoopStackFlags_W(Self: TEDILoopStack; const T: TEDILoopStackFlagSet);
begin Self.Flags := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDILoopStackFlags_R(Self: TEDILoopStack; var T: TEDILoopStackFlagSet);
begin T := Self.Flags; end;

(*----------------------------------------------------------------------------*)
procedure TEDILoopStackSize_R(Self: TEDILoopStack; var T: Integer);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TEDILoopStackStack_R(Self: TEDILoopStack; var T: TEDILoopStackArray);
begin T := Self.Stack; end;

(*----------------------------------------------------------------------------*)
Function TEDILoopStackPeek1_P(Self: TEDILoopStack;  Index : Integer) : TEDILoopStackRecord;
Begin Result := Self.Peek(Index); END;

(*----------------------------------------------------------------------------*)
Function TEDILoopStackPeek_P(Self: TEDILoopStack) : TEDILoopStackRecord;
Begin Result := Self.Peek; END;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectListEDIDataObject_W(Self: TEDIDataObjectList; const T: TEDIDataObject; const t1: Integer);
begin Self.EDIDataObject[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectListEDIDataObject_R(Self: TEDIDataObjectList; var T: TEDIDataObject; const t1: Integer);
begin T := Self.EDIDataObject[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectListItemEDIDataObject_W(Self: TEDIDataObjectListItem; const T: TEDIDataObject);
begin Self.EDIDataObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectListItemEDIDataObject_R(Self: TEDIDataObjectListItem; var T: TEDIDataObject);
begin T := Self.EDIDataObject; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListCurrentItem_R(Self: TEDIObjectList; var T: TEDIObjectListItem);
begin T := Self.CurrentItem; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListOptions_W(Self: TEDIObjectList; const T: TEDIDataObjectListOptions);
begin Self.Options := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListOptions_R(Self: TEDIObjectList; var T: TEDIDataObjectListOptions);
begin T := Self.Options; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListOwnsObjects_W(Self: TEDIObjectList; const T: Boolean);
begin Self.OwnsObjects := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListOwnsObjects_R(Self: TEDIObjectList; var T: Boolean);
begin T := Self.OwnsObjects; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListCount_R(Self: TEDIObjectList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListEDIObject_W(Self: TEDIObjectList; const T: TEDIObject; const t1: Integer);
begin Self.EDIObject[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListEDIObject_R(Self: TEDIObjectList; var T: TEDIObject; const t1: Integer);
begin T := Self.EDIObject[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItem_R(Self: TEDIObjectList; var T: TEDIObjectListItem; const t1: Integer);
begin T := Self.Item[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TEDIObjectListDelete1_P(Self: TEDIObjectList;  EDIObject : TEDIObject);
Begin Self.Delete(EDIObject); END;

(*----------------------------------------------------------------------------*)
Procedure TEDIObjectListDelete_P(Self: TEDIObjectList;  Index : Integer);
Begin Self.Delete(Index); END;

(*----------------------------------------------------------------------------*)
Procedure TEDIObjectListInsert_P(Self: TEDIObjectList;  InsertIndex : Integer; EDIObject : TEDIObject);
Begin Self.Insert(InsertIndex, EDIObject); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListIndexOf1_P(Self: TEDIObjectList;  EDIObject : TEDIObject) : Integer;
Begin Result := Self.IndexOf(EDIObject); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListIndexOf_P(Self: TEDIObjectList;  Item : TEDIObjectListItem) : Integer;
Begin Result := Self.IndexOf(Item); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListInsert2_P(Self: TEDIObjectList;  BeforeEDIObject : TEDIObject) : TEDIObjectListItem;
Begin Result := Self.Insert(BeforeEDIObject); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListInsert1_P(Self: TEDIObjectList;  BeforeItem : TEDIObjectListItem) : TEDIObjectListItem;
Begin Result := Self.Insert(BeforeItem); END;

(*----------------------------------------------------------------------------*)
//Function TEDIObjectListInsert1_P(Self: TEDIObjectList;  EDIObject, BeforeEDIObject : TEDIObject) : TEDIObjectListItem;
//Begin Result := Self.Insert(EDIObject, BeforeEDIObject); END;

(*----------------------------------------------------------------------------*)
//Function TEDIObjectListInsert_P(Self: TEDIObjectList;  Item, BeforeItem : TEDIObjectListItem) : TEDIObjectListItem;
//Begin Result := Self.Insert(Item, BeforeItem); END;

(*----------------------------------------------------------------------------*)
Procedure TEDIObjectListRemove1_P(Self: TEDIObjectList;  EDIObject : TEDIObject);
Begin Self.Remove(EDIObject); END;

(*----------------------------------------------------------------------------*)
Procedure TEDIObjectListRemove_P(Self: TEDIObjectList;  Item : TEDIObjectListItem);
Begin Self.Remove(Item); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListExtract1_P(Self: TEDIObjectList;  EDIObject : TEDIObject) : TEDIObject;
Begin Result := Self.Extract(EDIObject); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListExtract_P(Self: TEDIObjectList;  Item : TEDIObjectListItem) : TEDIObjectListItem;
Begin Result := Self.Extract(Item); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListFind1_P(Self: TEDIObjectList;  EDIObject : TEDIObject) : TEDIObjectListItem;
Begin Result := Self.Find(EDIObject); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListFind_P(Self: TEDIObjectList;  Item : TEDIObjectListItem) : TEDIObjectListItem;
Begin Result := Self.Find(Item); END;

(*----------------------------------------------------------------------------*)
Function TEDIObjectListAdd1_P(Self: TEDIObjectList;  EDIObject : TEDIObject; Name : string) : TEDIObjectListItem;
Begin Result := Self.Add(EDIObject, Name); END;

(*----------------------------------------------------------------------------*)
Procedure TEDIObjectListAdd_P(Self: TEDIObjectList;  Item : TEDIObjectListItem; Name : string);
Begin Self.Add(Item, Name); END;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemParent_W(Self: TEDIObjectListItem; const T: TEDIObjectList);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemParent_R(Self: TEDIObjectListItem; var T: TEDIObjectList);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemName_W(Self: TEDIObjectListItem; const T: string);
begin Self.Name := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemName_R(Self: TEDIObjectListItem; var T: string);
begin T := Self.Name; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemEDIObject_W(Self: TEDIObjectListItem; const T: TEDIObject);
begin Self.EDIObject := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemEDIObject_R(Self: TEDIObjectListItem; var T: TEDIObject);
begin T := Self.EDIObject; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemNextItem_W(Self: TEDIObjectListItem; const T: TEDIObjectListItem);
begin Self.NextItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemNextItem_R(Self: TEDIObjectListItem; var T: TEDIObjectListItem);
begin T := Self.NextItem; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemPriorItem_W(Self: TEDIObjectListItem; const T: TEDIObjectListItem);
begin Self.PriorItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemPriorItem_R(Self: TEDIObjectListItem; var T: TEDIObjectListItem);
begin T := Self.PriorItem; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemItemIndex_W(Self: TEDIObjectListItem; const T: Integer);
begin Self.ItemIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIObjectListItemItemIndex_R(Self: TEDIObjectListItem; var T: Integer);
begin T := Self.ItemIndex; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectGroupEDIDataObjectCount_R(Self: TEDIDataObjectGroup; var T: Integer);
begin T := Self.EDIDataObjectCount; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectGroupCreateObjectType_R(Self: TEDIDataObjectGroup; var T: TEDIDataObjectType);
begin T := Self.CreateObjectType; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectGroupEDIDataObjects_R(Self: TEDIDataObjectGroup; var T: TEDIDataObjectList);
begin T := Self.EDIDataObjects; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectGroupEDIDataObject_W(Self: TEDIDataObjectGroup; const T: TEDIDataObject; const t1: Integer);
begin Self.EDIDataObject[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectGroupEDIDataObject_R(Self: TEDIDataObjectGroup; var T: TEDIDataObject; const t1: Integer);
begin T := Self.EDIDataObject[t1]; end;

(*----------------------------------------------------------------------------*)
Procedure TEDIDataObjectGroupDeleteEDIDataObjects1_P(Self: TEDIDataObjectGroup;  Index, Count : Integer);
Begin Self.DeleteEDIDataObjects(Index, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TEDIDataObjectGroupDeleteEDIDataObjects_P(Self: TEDIDataObjectGroup);
Begin Self.DeleteEDIDataObjects; END;

(*----------------------------------------------------------------------------*)
Function TEDIDataObjectGroupInsertEDIDataObjects1_P(Self: TEDIDataObjectGroup;  InsertIndex : Integer; EDIDataObjectArray : TEDIDataObjectArray) : Integer;
Begin Result := Self.InsertEDIDataObjects(InsertIndex, EDIDataObjectArray); END;

(*----------------------------------------------------------------------------*)
Function TEDIDataObjectGroupInsertEDIDataObjects_P(Self: TEDIDataObjectGroup;  InsertIndex, Count : Integer) : Integer;
Begin Result := Self.InsertEDIDataObjects(InsertIndex, Count); END;

(*----------------------------------------------------------------------------*)
Procedure TEDIDataObjectGroupDeleteEDIDataObject1_P(Self: TEDIDataObjectGroup;  EDIDataObject : TEDIDataObject);
Begin Self.DeleteEDIDataObject(EDIDataObject); END;

(*----------------------------------------------------------------------------*)
Procedure TEDIDataObjectGroupDeleteEDIDataObject_P(Self: TEDIDataObjectGroup;  Index : Integer);
Begin Self.DeleteEDIDataObject(Index); END;

(*----------------------------------------------------------------------------*)
Function TEDIDataObjectGroupInsertEDIDataObject2_P(Self: TEDIDataObjectGroup;  InsertIndex : Integer; EDIDataObject : TEDIDataObject) : Integer;
Begin Result := Self.InsertEDIDataObject(InsertIndex, EDIDataObject); END;

(*----------------------------------------------------------------------------*)
Function TEDIDataObjectGroupInsertEDIDataObject1_P(Self: TEDIDataObjectGroup;  InsertIndex : Integer) : Integer;
Begin Result := Self.InsertEDIDataObject(InsertIndex); END;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectDelimiters_W(Self: TEDIDataObject; const T: TEDIDelimiters);
begin Self.Delimiters := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectDelimiters_R(Self: TEDIDataObject; var T: TEDIDelimiters);
begin T := Self.Delimiters; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectParent_W(Self: TEDIDataObject; const T: TEDIDataObject);
begin Self.Parent := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectParent_R(Self: TEDIDataObject; var T: TEDIDataObject);
begin T := Self.Parent; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectDataLength_R(Self: TEDIDataObject; var T: Integer);
begin T := Self.DataLength; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectData_W(Self: TEDIDataObject; const T: string);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectData_R(Self: TEDIDataObject; var T: string);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectState_R(Self: TEDIDataObject; var T: TEDIDataObjectDataState);
begin T := Self.State; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectCustomData2_W(Self: TEDIDataObject; const T: TCustomData);
begin Self.CustomData2 := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectCustomData2_R(Self: TEDIDataObject; var T: TCustomData);
begin T := Self.CustomData2; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectCustomData1_W(Self: TEDIDataObject; const T: TCustomData);
begin Self.CustomData1 := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectCustomData1_R(Self: TEDIDataObject; var T: TCustomData);
begin T := Self.CustomData1; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectSpecPointer_W(Self: TEDIDataObject; const T: TEDIObject);
begin Self.SpecPointer := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDataObjectSpecPointer_R(Self: TEDIDataObject; var T: TEDIObject);
begin T := Self.SpecPointer; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersSSLen_R(Self: TEDIDelimiters; var T: Integer);
begin T := Self.SSLen; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersEDLen_R(Self: TEDIDelimiters; var T: Integer);
begin T := Self.EDLen; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersSDLen_R(Self: TEDIDelimiters; var T: Integer);
begin T := Self.SDLen; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersSS_W(Self: TEDIDelimiters; const T: string);
begin Self.SS := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersSS_R(Self: TEDIDelimiters; var T: string);
begin T := Self.SS; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersED_W(Self: TEDIDelimiters; const T: string);
begin Self.ED := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersED_R(Self: TEDIDelimiters; var T: string);
begin T := Self.ED; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersSD_W(Self: TEDIDelimiters; const T: string);
begin Self.SD := T; end;

(*----------------------------------------------------------------------------*)
procedure TEDIDelimitersSD_R(Self: TEDIDelimiters; var T: string);
begin T := Self.SD; end;

(*----------------------------------------------------------------------------*)
Function TEDIDelimitersCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const SD, ED, SS : string):TObject;
Begin Result := TEDIDelimiters.Create(SD, ED, SS); END;

(*----------------------------------------------------------------------------*)
Function TEDIDelimitersCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TEDIDelimiters.Create; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclEDI_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@StringRemove, 'StringRemove', cdRegister);
 S.RegisterDelphiFunction(@StringReplace, 'JStringReplace', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEDILoopStack(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDILoopStack) do begin
    RegisterConstructor(@TEDILoopStack.Create, 'Create');
    RegisterMethod(@TEDILoopStackPeek_P, 'Peek');
    RegisterMethod(@TEDILoopStackPeek1_P, 'Peek1');
    RegisterMethod(@TEDILoopStack.Pop, 'Pop');
    RegisterMethod(@TEDILoopStack.Push, 'Push');
    RegisterMethod(@TEDILoopStack.GetSafeStackIndex, 'GetSafeStackIndex');
    RegisterMethod(@TEDILoopStack.SetStackPointer, 'SetStackPointer');
    RegisterMethod(@TEDILoopStack.UpdateStackObject, 'UpdateStackObject');
    RegisterMethod(@TEDILoopStack.UpdateStackData, 'UpdateStackData');
    RegisterMethod(@TEDILoopStack.ValidateLoopStack, 'ValidateLoopStack');
    RegisterMethod(@TEDILoopStack.Debug, 'Debug');
    RegisterPropertyHelper(@TEDILoopStackStack_R,nil,'Stack');
    RegisterPropertyHelper(@TEDILoopStackSize_R,nil,'Size');
    RegisterPropertyHelper(@TEDILoopStackFlags_R,@TEDILoopStackFlags_W,'Flags');
    RegisterPropertyHelper(@TEDILoopStackOnAddLoop_R,@TEDILoopStackOnAddLoop_W,'OnAddLoop');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEDIDataObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDIDataObjectList) do
  begin
    RegisterPropertyHelper(@TEDIDataObjectListEDIDataObject_R,@TEDIDataObjectListEDIDataObject_W,'EDIDataObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEDIDataObjectListItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDIDataObjectListItem) do
  begin
    RegisterPropertyHelper(@TEDIDataObjectListItemEDIDataObject_R,@TEDIDataObjectListItemEDIDataObject_W,'EDIDataObject');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEDIObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDIObjectList) do begin
    RegisterConstructor(@TEDIObjectList.Create, 'Create');
    RegisterMethod(@TEDIObjectList.Destroy, 'Free');
    RegisterMethod(@TEDIObjectListAdd_P, 'Add');
    RegisterMethod(@TEDIObjectListAdd1_P, 'Add1');
    RegisterVirtualMethod(@TEDIObjectList.CreateListItem, 'CreateListItem');
    RegisterMethod(@TEDIObjectListFind_P, 'Find');
    RegisterMethod(@TEDIObjectListFind1_P, 'Find1');
    RegisterMethod(@TEDIObjectList.FindEDIObject, 'FindEDIObject');
    RegisterVirtualMethod(@TEDIObjectListExtract_P, 'Extract');
    RegisterVirtualMethod(@TEDIObjectListExtract1_P, 'Extract1');
    RegisterMethod(@TEDIObjectListRemove_P, 'Remove');
    RegisterMethod(@TEDIObjectListRemove1_P, 'Remove1');
    RegisterMethod(@TEDIObjectListInsert_P, 'Insert');
    RegisterMethod(@TEDIObjectListInsert1_P, 'Insert1');
    RegisterMethod(@TEDIObjectListInsert1_P, 'Insert1');
    RegisterMethod(@TEDIObjectListInsert2_P, 'Insert2');
    RegisterMethod(@TEDIObjectList.Clear, 'Clear');
    RegisterVirtualMethod(@TEDIObjectList.First, 'First');
    RegisterVirtualMethod(@TEDIObjectList.Next, 'Next');
    RegisterVirtualMethod(@TEDIObjectList.Prior, 'Prior');
    RegisterVirtualMethod(@TEDIObjectList.Last, 'Last');
    RegisterMethod(@TEDIObjectList.UpdateCount, 'UpdateCount');
    RegisterVirtualMethod(@TEDIObjectList.FindItemByName, 'FindItemByName');
    RegisterVirtualMethod(@TEDIObjectList.ReturnListItemsByName, 'ReturnListItemsByName');
    RegisterMethod(@TEDIObjectListIndexOf_P, 'IndexOf');
    RegisterMethod(@TEDIObjectListIndexOf1_P, 'IndexOf1');
    RegisterMethod(@TEDIObjectList.IndexIsValid, 'IndexIsValid');
    RegisterMethod(@TEDIObjectListInsert_P, 'Insert');
    RegisterMethod(@TEDIObjectListDelete_P, 'Delete');
    RegisterMethod(@TEDIObjectListDelete1_P, 'Delete1');
    RegisterMethod(@TEDIObjectList.UpdateIndexes, 'UpdateIndexes');
    RegisterPropertyHelper(@TEDIObjectListItem_R,nil,'Item');
    RegisterPropertyHelper(@TEDIObjectListEDIObject_R,@TEDIObjectListEDIObject_W,'EDIObject');
    RegisterPropertyHelper(@TEDIObjectListCount_R,nil,'Count');
    RegisterPropertyHelper(@TEDIObjectListOwnsObjects_R,@TEDIObjectListOwnsObjects_W,'OwnsObjects');
    RegisterPropertyHelper(@TEDIObjectListOptions_R,@TEDIObjectListOptions_W,'Options');
    RegisterPropertyHelper(@TEDIObjectListCurrentItem_R,nil,'CurrentItem');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEDIObjectListItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDIObjectListItem) do begin
    RegisterConstructor(@TEDIObjectListItem.Create, 'Create');
    RegisterMethod(@TEDIObjectListItem.GetIndexPositionFromParent, 'GetIndexPositionFromParent');
    RegisterMethod(@TEDIObjectListItem.FreeAndNilEDIDataObject, 'FreeAndNilEDIDataObject');
    RegisterPropertyHelper(@TEDIObjectListItemItemIndex_R,@TEDIObjectListItemItemIndex_W,'ItemIndex');
    RegisterPropertyHelper(@TEDIObjectListItemPriorItem_R,@TEDIObjectListItemPriorItem_W,'PriorItem');
    RegisterPropertyHelper(@TEDIObjectListItemNextItem_R,@TEDIObjectListItemNextItem_W,'NextItem');
    RegisterPropertyHelper(@TEDIObjectListItemEDIObject_R,@TEDIObjectListItemEDIObject_W,'EDIObject');
    RegisterPropertyHelper(@TEDIObjectListItemName_R,@TEDIObjectListItemName_W,'Name');
    RegisterPropertyHelper(@TEDIObjectListItemParent_R,@TEDIObjectListItemParent_W,'Parent');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEDIDataObjectGroup(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDIDataObjectGroup) do begin
    RegisterConstructor(@TEDIDataObjectGroup.Create, 'Create');
    RegisterMethod(@TEDIDataObjectGroup.IndexIsValid, 'IndexIsValid');
    RegisterMethod(@TEDIDataObjectGroup.AddEDIDataObject, 'AddEDIDataObject');
    RegisterMethod(@TEDIDataObjectGroup.AppendEDIDataObject, 'AppendEDIDataObject');
    RegisterMethod(@TEDIDataObjectGroupInsertEDIDataObject1_P, 'InsertEDIDataObject1');
    RegisterMethod(@TEDIDataObjectGroupInsertEDIDataObject2_P, 'InsertEDIDataObject2');
    RegisterMethod(@TEDIDataObjectGroupDeleteEDIDataObject_P, 'DeleteEDIDataObject');
    RegisterMethod(@TEDIDataObjectGroupDeleteEDIDataObject1_P, 'DeleteEDIDataObject1');
    RegisterMethod(@TEDIDataObjectGroup.AddEDIDataObjects, 'AddEDIDataObjects');
    RegisterMethod(@TEDIDataObjectGroup.AppendEDIDataObjects, 'AppendEDIDataObjects');
    RegisterMethod(@TEDIDataObjectGroupInsertEDIDataObjects_P, 'InsertEDIDataObjects');
    RegisterMethod(@TEDIDataObjectGroupInsertEDIDataObjects1_P, 'InsertEDIDataObjects1');
    RegisterMethod(@TEDIDataObjectGroupDeleteEDIDataObjects_P, 'DeleteEDIDataObjects');
    RegisterMethod(@TEDIDataObjectGroupDeleteEDIDataObjects1_P, 'DeleteEDIDataObjects1');
    RegisterVirtualMethod(@TEDIDataObjectGroup.GetIndexPositionFromParent, 'GetIndexPositionFromParent');
    RegisterPropertyHelper(@TEDIDataObjectGroupEDIDataObject_R,@TEDIDataObjectGroupEDIDataObject_W,'EDIDataObject');
    RegisterPropertyHelper(@TEDIDataObjectGroupEDIDataObjects_R,nil,'EDIDataObjects');
    RegisterPropertyHelper(@TEDIDataObjectGroupCreateObjectType_R,nil,'CreateObjectType');
    RegisterPropertyHelper(@TEDIDataObjectGroupEDIDataObjectCount_R,nil,'EDIDataObjectCount');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEDIDataObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDIDataObject) do begin
    RegisterConstructor(@TEDIDataObject.Create, 'Create');
    //RegisterVirtualAbstractMethod(@TEDIDataObject, @!.Assemble, 'Assemble');
    //RegisterVirtualAbstractMethod(@TEDIDataObject, @!.Disassemble, 'Disassemble');
    RegisterPropertyHelper(@TEDIDataObjectSpecPointer_R,@TEDIDataObjectSpecPointer_W,'SpecPointer');
    RegisterPropertyHelper(@TEDIDataObjectCustomData1_R,@TEDIDataObjectCustomData1_W,'CustomData1');
    RegisterPropertyHelper(@TEDIDataObjectCustomData2_R,@TEDIDataObjectCustomData2_W,'CustomData2');
    RegisterPropertyHelper(@TEDIDataObjectState_R,nil,'State');
    RegisterPropertyHelper(@TEDIDataObjectData_R,@TEDIDataObjectData_W,'Data');
    RegisterPropertyHelper(@TEDIDataObjectDataLength_R,nil,'DataLength');
    RegisterPropertyHelper(@TEDIDataObjectParent_R,@TEDIDataObjectParent_W,'Parent');
    RegisterPropertyHelper(@TEDIDataObjectDelimiters_R,@TEDIDataObjectDelimiters_W,'Delimiters');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEDIDelimiters(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDIDelimiters) do begin
    RegisterConstructor(@TEDIDelimitersCreate_P, 'Create');
    RegisterConstructor(@TEDIDelimitersCreate1_P, 'Create1');
    RegisterPropertyHelper(@TEDIDelimitersSD_R,@TEDIDelimitersSD_W,'SD');
    RegisterPropertyHelper(@TEDIDelimitersED_R,@TEDIDelimitersED_W,'ED');
    RegisterPropertyHelper(@TEDIDelimitersSS_R,@TEDIDelimitersSS_W,'SS');
    RegisterPropertyHelper(@TEDIDelimitersSDLen_R,nil,'SDLen');
    RegisterPropertyHelper(@TEDIDelimitersEDLen_R,nil,'EDLen');
    RegisterPropertyHelper(@TEDIDelimitersSSLen_R,nil,'SSLen');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EJclEDIError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclEDIError) do begin
    RegisterConstructor(@EJclEDIError.CreateID, 'CreateID');
    RegisterConstructor(@EJclEDIError.CreateIDFmt, 'CreateIDFmt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclEDI(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEDIObject) do
  RIRegister_EJclEDIError(CL);
  with CL.Add(TEDIDataObject) do
  with CL.Add(TEDIDataObjectGroup) do
  with CL.Add(TEDIObjectListItem) do
  with CL.Add(TEDIObjectList) do
  with CL.Add(TEDIDataObjectListItem) do
  with CL.Add(TEDIDataObjectList) do
  RIRegister_TEDIDelimiters(CL);
  RIRegister_TEDIDataObject(CL);
  RIRegister_TEDIDataObjectGroup(CL);
  RIRegister_TEDIObjectListItem(CL);
  RIRegister_TEDIObjectList(CL);
  RIRegister_TEDIDataObjectListItem(CL);
  RIRegister_TEDIDataObjectList(CL);
  RIRegister_TEDILoopStack(CL);
end;

 
 
{ TPSImport_JclEDI }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclEDI.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclEDI(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclEDI.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclEDI(ri);
  RIRegister_JclEDI_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
