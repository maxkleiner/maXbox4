unit uPSI_PersistentClasses;
{
   pesistence dance     add free
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
  TPSImport_PersistentClasses = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_EFilerException(CL: TPSPascalCompiler);
procedure SIRegister_EInvalidFileSignature(CL: TPSPascalCompiler);
procedure SIRegister_TTextWriter(CL: TPSPascalCompiler);
procedure SIRegister_TTextReader(CL: TPSPascalCompiler);
procedure SIRegister_TBinaryWriter(CL: TPSPascalCompiler);
procedure SIRegister_TBinaryReader(CL: TPSPascalCompiler);
procedure SIRegister_TPersistentObjectList(CL: TPSPascalCompiler);
procedure SIRegister_TPersistentObject(CL: TPSPascalCompiler);
procedure SIRegister_IPersistentObject(CL: TPSPascalCompiler);
procedure SIRegister_TVirtualWriter(CL: TPSPascalCompiler);
procedure SIRegister_TVirtualReader(CL: TPSPascalCompiler);
procedure SIRegister_PersistentClasses(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_PersistentClasses_Routines(S: TPSExec);
procedure RIRegister_EFilerException(CL: TPSRuntimeClassImporter);
procedure RIRegister_EInvalidFileSignature(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBinaryWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBinaryReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPersistentObjectList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPersistentObject(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVirtualWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TVirtualReader(CL: TPSRuntimeClassImporter);
procedure RIRegister_PersistentClasses(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   PersistentClasses
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_PersistentClasses]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EFilerException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EFilerException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EFilerException') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EInvalidFileSignature(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EInvalidFileSignature') do
  with CL.AddClassN(CL.FindClass('Exception'),'EInvalidFileSignature') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVirtualWriter', 'TTextWriter') do
  with CL.AddClassN(CL.FindClass('TVirtualWriter'),'TTextWriter') do begin
    RegisterMethod('Constructor Create( Stream : TStream)');
    RegisterMethod('procedure WriteInteger(anInteger : Integer);');
    RegisterMethod('procedure WriteBoolean(aBoolean : Boolean);');
  RegisterMethod('procedure WriteString(const aString : String);');
  RegisterMethod('procedure WriteFloat(const aFloat : Extended);');
  RegisterMethod('procedure writeListBegin;');
  RegisterMethod('procedure writeListEnd;');
  RegisterMethod('function EndofList : boolean;');
  RegisterMethod('function NextValue : TValueType;');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVirtualReader', 'TTextReader') do
  with CL.AddClassN(CL.FindClass('TVirtualReader'),'TXTextReader') do begin
      RegisterMethod('function ReadInteger : Integer;');
    RegisterMethod('function ReadBoolean : Boolean;');
  RegisterMethod('function ReadString : String;');
  RegisterMethod('function ReadFloat : Extended;');
  RegisterMethod('procedure ReadListBegin;');
  RegisterMethod('procedure ReadListEnd;');
  RegisterMethod('function EndofList : boolean;');
  RegisterMethod('function NextValue : TValueType;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBinaryWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVirtualWriter', 'TBinaryWriter') do
  with CL.AddClassN(CL.FindClass('TVirtualWriter'),'TBinaryWriter') do begin
      RegisterMethod('procedure WriteInteger(anInteger : Integer);');
    RegisterMethod('procedure WriteBoolean(aBoolean : Boolean);');
  RegisterMethod('procedure WriteString(const aString : String);');
  RegisterMethod('procedure WriteFloat(const aFloat : Extended);');
  RegisterMethod('procedure writeListBegin;');
  RegisterMethod('procedure writeListEnd;');
  RegisterMethod('function EndofList : boolean;');
  RegisterMethod('function NextValue : TValueType;');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBinaryReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TVirtualReader', 'TBinaryReader') do
  with CL.AddClassN(CL.FindClass('TVirtualReader'),'TBinaryReader') do begin
    RegisterMethod('function ReadInteger : Integer;');
    RegisterMethod('function ReadBoolean : Boolean;');
  RegisterMethod('function ReadString : String;');
  RegisterMethod('function ReadFloat : Extended;');
  RegisterMethod('procedure ReadListBegin;');
  RegisterMethod('procedure ReadListEnd;');
  RegisterMethod('function EndofList : boolean;');
  RegisterMethod('function NextValue : TValueType;');

     {  function ReadInteger : Integer; override;
         function ReadBoolean : Boolean; override;
         function ReadString : String; override;
         function ReadFloat : Extended; override;
              procedure ReadListBegin; override;
         procedure ReadListEnd; override;
         function EndOfList : Boolean; override;
         function NextValue : TValueType; override;
      }
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPersistentObjectList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistentObject', 'TPersistentObjectList') do
  with CL.AddClassN(CL.FindClass('TPersistentObject'),'TPersistentObjectList') do begin

    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure WriteToFiler(writer : TVirtualWriter);');
   RegisterMethod('procedure ReadFromFiler(reader : TVirtualReader);');
    RegisterMethod('Procedure ReadFromFilerWithEvent( reader : TVirtualReader; afterSenderObjectCreated : TNotifyEvent)');
    RegisterMethod('Function Add( const item : TObject) : Integer');
    RegisterMethod('Procedure AddNils( nbVals : Cardinal)');
    RegisterMethod('Procedure Delete( index : Integer)');
    RegisterMethod('Procedure DeleteItems( index : Integer; nbVals : Cardinal)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Procedure Insert( Index : Integer; Item : TObject)');
    RegisterMethod('Procedure InsertNils( index : Integer; nbVals : Cardinal)');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Function Remove( Item : TObject) : Integer');
    RegisterMethod('Procedure DeleteAndFree( index : Integer)');
    RegisterMethod('Procedure DeleteAndFreeItems( index : Integer; nbVals : Cardinal)');
    RegisterMethod('Function RemoveAndFree( item : TObject) : Integer');
    RegisterProperty('GrowthDelta', 'integer', iptrw);
    RegisterMethod('Function Expand : TPersistentObjectList');
    RegisterProperty('Items', 'TObject Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('List', 'PPointerObjectList', iptr);
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterMethod('Procedure RequiredCapacity( aCapacity : Integer)');
    RegisterMethod('Procedure Pack');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Clean');
    RegisterMethod('Procedure CleanFree');
    RegisterMethod('Function IndexOf( Item : TObject) : Integer');
    RegisterProperty('First', 'TObject', iptrw);
    RegisterProperty('Last', 'TObject', iptrw);
    RegisterMethod('Procedure Push( item : TObject)');
    RegisterMethod('Function Pop : TObject');
    RegisterMethod('Procedure PopAndFree');
    RegisterMethod('Function AddObjects( const objectList : TPersistentObjectList) : Integer');
    RegisterMethod('Procedure RemoveObjects( const objectList : TPersistentObjectList)');
    RegisterMethod('Procedure Sort( compareFunc : TObjectListSortCompare)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPersistentObject(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TPersistentObject') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TPersistentObject') do begin
    RegisterMethod('Constructor Create');
            RegisterMethod('Procedure Free');
      RegisterMethod('Constructor CreateFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure Assign( source : TPersistent)');
    RegisterMethod('Function CreateClone : TPersistentObject');
    RegisterMethod('Function FileSignature : String');
    RegisterMethod('Function FileVirtualWriter : TVirtualWriterClass');
    RegisterMethod('Function FileVirtualReader : TVirtualReaderClass');
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)');
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)');
    RegisterMethod('Procedure SaveToStream( stream : TStream; writerClass : TVirtualWriterClass)');
    RegisterMethod('Procedure LoadFromStream( stream : TStream; readerClass : TVirtualReaderClass)');
    RegisterMethod('Procedure SaveToFile( const fileName : String; writerClass : TVirtualWriterClass)');
    RegisterMethod('Procedure LoadFromFile( const fileName : String; readerClass : TVirtualReaderClass)');
    RegisterMethod('Function SaveToString( writerClass : TVirtualWriterClass) : String');
    RegisterMethod('Procedure LoadFromString( const data : String; readerClass : TVirtualReaderClass)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IPersistentObject(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IPersistentObject') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IPersistentObject, 'IPersistentObject') do
  begin
    RegisterMethod('Procedure WriteToFiler( writer : TVirtualWriter)', cdRegister);
    RegisterMethod('Procedure ReadFromFiler( reader : TVirtualReader)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVirtualWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TVirtualWriter') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TVirtualWriter') do begin
    RegisterMethod('Constructor Create( Stream : TStream)');
            RegisterMethod('Procedure Free');
      RegisterProperty('Stream', 'TStream', iptr);
    RegisterMethod('Procedure Write( const Buf, Count : Longint)');
    RegisterMethod('Procedure WriteInteger( anInteger : Integer)');
    RegisterMethod('Procedure WriteBoolean( aBoolean : Boolean)');
    RegisterMethod('Procedure WriteString( const aString : String)');
    RegisterMethod('Procedure WriteFloat( const aFloat : Extended)');
    RegisterMethod('Procedure WriteListBegin');
    RegisterMethod('Procedure WriteListEnd');
    RegisterMethod('Procedure WriteTStrings( const aStrings : TStrings; storeObjects : Boolean)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TVirtualReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TVirtualReader') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TVirtualReader') do begin
    RegisterMethod('Constructor Create( Stream : TStream)');
            RegisterMethod('Procedure Free');
      RegisterProperty('Stream', 'TStream', iptr);
    RegisterMethod('Procedure ReadTypeError');
    RegisterMethod('Procedure Read( var Buf, Count : Longint)');
    RegisterMethod('Function NextValue : TValueType');
    RegisterMethod('Function ReadInteger : Integer');
    RegisterMethod('Function ReadBoolean : Boolean');
    RegisterMethod('Function ReadString : String');
    RegisterMethod('Function ReadFloat : Extended');
    RegisterMethod('Procedure ReadListBegin');
    RegisterMethod('Procedure ReadListEnd');
    RegisterMethod('Function EndOfList : Boolean');
    RegisterMethod('Procedure ReadTStrings( aStrings : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_PersistentClasses(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PObject', '^TObject // will not work');
  SIRegister_TVirtualReader(CL);
  SIRegister_TVirtualWriter(CL);
  //CL.AddTypeS('TVirtualReaderClass', 'class of TVirtualReader');
  //CL.AddTypeS('TVirtualWriterClass', 'class of TVirtualWriter');
  SIRegister_IPersistentObject(CL);
  SIRegister_TPersistentObject(CL);
  //CL.AddTypeS('TPersistentObjectClass', 'class of TPersistentObject');
  //CL.AddTypeS('PPointerObjectList', '^TPointerObjectList // will not work');
  SIRegister_TPersistentObjectList(CL);
  SIRegister_TBinaryReader(CL);
  SIRegister_TBinaryWriter(CL);
  SIRegister_TTextReader(CL);
  SIRegister_TTextWriter(CL);
  SIRegister_EInvalidFileSignature(CL);
  SIRegister_EFilerException(CL);
 //CL.AddDelphiFunction('Procedure RaiseFilerException( aClass : TClass; archiveVersion : Integer)');
 //CL.AddDelphiFunction('Function UTF8ToWideString( const s : AnsiString) : WideString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListLast_W(Self: TPersistentObjectList; const T: TObject);
begin Self.Last := T; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListLast_R(Self: TPersistentObjectList; var T: TObject);
begin T := Self.Last; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListFirst_W(Self: TPersistentObjectList; const T: TObject);
begin Self.First := T; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListFirst_R(Self: TPersistentObjectList; var T: TObject);
begin T := Self.First; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListCapacity_W(Self: TPersistentObjectList; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListCapacity_R(Self: TPersistentObjectList; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListList_R(Self: TPersistentObjectList; var T: PPointerObjectList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListCount_W(Self: TPersistentObjectList; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListCount_R(Self: TPersistentObjectList; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListItems_W(Self: TPersistentObjectList; const T: TObject; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListItems_R(Self: TPersistentObjectList; var T: TObject; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListGrowthDelta_W(Self: TPersistentObjectList; const T: integer);
begin Self.GrowthDelta := T; end;

(*----------------------------------------------------------------------------*)
procedure TPersistentObjectListGrowthDelta_R(Self: TPersistentObjectList; var T: integer);
begin T := Self.GrowthDelta; end;

(*----------------------------------------------------------------------------*)
procedure TVirtualWriterStream_R(Self: TVirtualWriter; var T: TStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure TVirtualReaderStream_R(Self: TVirtualReader; var T: TStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PersistentClasses_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@RaiseFilerException, 'RaiseFilerException', cdRegister);
 S.RegisterDelphiFunction(@UTF8ToWideString, 'UTF8ToWideString', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EFilerException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EFilerException) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EInvalidFileSignature(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidFileSignature) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextWriter) do begin
    RegisterConstructor(@TTextWriter.Create, 'Create');
   RegisterMethod(@TTextWriter.writeInteger, 'writeInteger');
    RegisterMethod(@TTextWriter.writeBoolean, 'writeBoolean');
    RegisterMethod(@TTextWriter.writeString, 'writeString');
    RegisterMethod(@TTextWriter.writeFloat, 'writeFloat');
  RegisterMethod(@TTextWriter.writeListBegin, 'writeListBegin');
    RegisterMethod(@TTextWriter.writeListEnd, 'writeListEnd');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TXTextReader) do begin
    RegisterMethod(@TXTextReader.ReadInteger, 'ReadInteger');
    RegisterMethod(@TXTextReader.ReadBoolean, 'ReadBoolean');
    RegisterMethod(@TXTextReader.ReadString, 'ReadString');
    RegisterMethod(@TXTextReader.ReadFloat, 'ReadFloat');
    RegisterMethod(@TXTextReader.ReadListBegin, 'ReadListBegin');
    RegisterMethod(@TXTextReader.ReadListEnd, 'ReadListEnd');
    RegisterMethod(@TXTextReader.EndOfList, 'EndOfList');
    RegisterMethod(@TXTextReader.NextValue, 'NextValue');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBinaryWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBinaryWriter) do  begin
   RegisterMethod(@TBinaryWriter.writeInteger, 'writeInteger');
    RegisterMethod(@TBinaryWriter.writeBoolean, 'writeBoolean');
    RegisterMethod(@TBinaryWriter.writeString, 'writeString');
    RegisterMethod(@TBinaryWriter.writeFloat, 'writeFloat');
  RegisterMethod(@TBinaryWriter.writeListBegin, 'writeListBegin');
    RegisterMethod(@TBinaryWriter.writeListEnd, 'writeListEnd');

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBinaryReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBinaryReader) do begin
    RegisterMethod(@TBinaryReader.ReadInteger, 'ReadInteger');
    RegisterMethod(@TBinaryReader.ReadBoolean, 'ReadBoolean');
    RegisterMethod(@TBinaryReader.ReadString, 'ReadString');
    RegisterMethod(@TBinaryReader.ReadFloat, 'ReadFloat');
    RegisterMethod(@TBinaryReader.ReadListBegin, 'ReadListBegin');
    RegisterMethod(@TBinaryReader.ReadListEnd, 'ReadListEnd');
    RegisterMethod(@TBinaryReader.EndOfList, 'EndOfList');
    RegisterMethod(@TBinaryReader.NextValue, 'NextValue');

    {  function ReadInteger : Integer; override;
         function ReadBoolean : Boolean; override;
         function ReadString : String; override;
         function ReadFloat : Extended; override;
              procedure ReadListBegin; override;
         procedure ReadListEnd; override;
         function EndOfList : Boolean; override;
         function NextValue : TValueType; override;
      }

  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPersistentObjectList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPersistentObjectList) do begin
    RegisterMethod(@TPersistentObjectList.ReadFromFilerWithEvent, 'ReadFromFilerWithEvent');
    RegisterMethod(@TPersistentObjectList.Add, 'Add');
   RegisterConstructor(@TPersistentObjectList.Create, 'Create');
   RegisterMethod(@TPersistentObjectList.Destroy, 'Free');
    RegisterMethod(@TPersistentObjectList.WriteToFiler, 'WriteToFiler');
    RegisterMethod(@TPersistentObjectList.ReadFromFiler, 'ReadFromFiler');

   // RegisterMethod('procedure WriteToFiler(writer : TVirtualWriter);');
   //RegisterMethod('procedure ReadFromFiler(reader : TVirtualReader);');

    RegisterMethod(@TPersistentObjectList.AddNils, 'AddNils');
    RegisterMethod(@TPersistentObjectList.Delete, 'Delete');
    RegisterMethod(@TPersistentObjectList.DeleteItems, 'DeleteItems');
    RegisterMethod(@TPersistentObjectList.Exchange, 'Exchange');
    RegisterMethod(@TPersistentObjectList.Insert, 'Insert');
    RegisterMethod(@TPersistentObjectList.InsertNils, 'InsertNils');
    RegisterMethod(@TPersistentObjectList.Move, 'Move');
    RegisterMethod(@TPersistentObjectList.Remove, 'Remove');
    RegisterMethod(@TPersistentObjectList.DeleteAndFree, 'DeleteAndFree');
    RegisterMethod(@TPersistentObjectList.DeleteAndFreeItems, 'DeleteAndFreeItems');
    RegisterMethod(@TPersistentObjectList.RemoveAndFree, 'RemoveAndFree');
    RegisterPropertyHelper(@TPersistentObjectListGrowthDelta_R,@TPersistentObjectListGrowthDelta_W,'GrowthDelta');
    RegisterMethod(@TPersistentObjectList.Expand, 'Expand');
    RegisterPropertyHelper(@TPersistentObjectListItems_R,@TPersistentObjectListItems_W,'Items');
    RegisterPropertyHelper(@TPersistentObjectListCount_R,@TPersistentObjectListCount_W,'Count');
    RegisterPropertyHelper(@TPersistentObjectListList_R,nil,'List');
    RegisterPropertyHelper(@TPersistentObjectListCapacity_R,@TPersistentObjectListCapacity_W,'Capacity');
    RegisterMethod(@TPersistentObjectList.RequiredCapacity, 'RequiredCapacity');
    RegisterMethod(@TPersistentObjectList.Pack, 'Pack');
    RegisterVirtualMethod(@TPersistentObjectList.Clear, 'Clear');
    RegisterVirtualMethod(@TPersistentObjectList.Clean, 'Clean');
    RegisterMethod(@TPersistentObjectList.CleanFree, 'CleanFree');
    RegisterMethod(@TPersistentObjectList.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TPersistentObjectListFirst_R,@TPersistentObjectListFirst_W,'First');
    RegisterPropertyHelper(@TPersistentObjectListLast_R,@TPersistentObjectListLast_W,'Last');
    RegisterMethod(@TPersistentObjectList.Push, 'Push');
    RegisterMethod(@TPersistentObjectList.Pop, 'Pop');
    RegisterMethod(@TPersistentObjectList.PopAndFree, 'PopAndFree');
    RegisterMethod(@TPersistentObjectList.AddObjects, 'AddObjects');
    RegisterMethod(@TPersistentObjectList.RemoveObjects, 'RemoveObjects');
    RegisterMethod(@TPersistentObjectList.Sort, 'Sort');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPersistentObject(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPersistentObject) do begin
    RegisterConstructor(@TPersistentObject.Create, 'Create');
      RegisterMethod(@TPersistentObject.Destroy, 'Free');
      RegisterConstructor(@TPersistentObject.CreateFromFiler, 'CreateFromFiler');
    RegisterMethod(@TPersistentObject.Assign, 'Assign');
    RegisterVirtualMethod(@TPersistentObject.CreateClone, 'CreateClone');
    RegisterVirtualMethod(@TPersistentObject.FileSignature, 'FileSignature');
    RegisterVirtualMethod(@TPersistentObject.FileVirtualWriter, 'FileVirtualWriter');
    RegisterVirtualMethod(@TPersistentObject.FileVirtualReader, 'FileVirtualReader');
    RegisterVirtualMethod(@TPersistentObject.WriteToFiler, 'WriteToFiler');
    RegisterVirtualMethod(@TPersistentObject.ReadFromFiler, 'ReadFromFiler');
    RegisterVirtualMethod(@TPersistentObject.SaveToStream, 'SaveToStream');
    RegisterVirtualMethod(@TPersistentObject.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TPersistentObject.SaveToFile, 'SaveToFile');
    RegisterVirtualMethod(@TPersistentObject.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TPersistentObject.SaveToString, 'SaveToString');
    RegisterVirtualMethod(@TPersistentObject.LoadFromString, 'LoadFromString');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVirtualWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVirtualWriter) do  begin
    RegisterVirtualConstructor(@TVirtualWriter.Create, 'Create');
    RegisterPropertyHelper(@TVirtualWriterStream_R,nil,'Stream');
      RegisterMethod(@TVirtualWriter.Destroy, 'Free');
      {RegisterVirtualAbstractMethod(@TVirtualWriter, @!.Write, 'Write');
    RegisterVirtualAbstractMethod(@TVirtualWriter, @!.WriteInteger, 'WriteInteger');
    RegisterVirtualAbstractMethod(@TVirtualWriter, @!.WriteBoolean, 'WriteBoolean');
    RegisterVirtualAbstractMethod(@TVirtualWriter, @!.WriteString, 'WriteString');
    RegisterVirtualAbstractMethod(@TVirtualWriter, @!.WriteFloat, 'WriteFloat');
    RegisterVirtualAbstractMethod(@TVirtualWriter, @!.WriteListBegin, 'WriteListBegin');
    RegisterVirtualAbstractMethod(@TVirtualWriter, @!.WriteListEnd, 'WriteListEnd');}
    RegisterMethod(@TVirtualWriter.WriteTStrings, 'WriteTStrings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TVirtualReader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TVirtualReader) do begin
    RegisterConstructor(@TVirtualReader.Create, 'Create');
      RegisterMethod(@TVirtualReader.Destroy, 'Free');
      RegisterPropertyHelper(@TVirtualReaderStream_R,nil,'Stream');
    RegisterMethod(@TVirtualReader.ReadTypeError, 'ReadTypeError');
    {RegisterVirtualAbstractMethod(@TVirtualReader, @!.Read, 'Read');
    RegisterVirtualAbstractMethod(@TVirtualReader, @!.NextValue, 'NextValue');
    RegisterVirtualAbstractMethod(@TVirtualReader, @!.ReadInteger, 'ReadInteger');
    RegisterVirtualAbstractMethod(@TVirtualReader, @!.ReadBoolean, 'ReadBoolean');
    RegisterVirtualAbstractMethod(@TVirtualReader, @!.ReadString, 'ReadString');
    RegisterVirtualAbstractMethod(@TVirtualReader, @!.ReadFloat, 'ReadFloat');
    RegisterVirtualAbstractMethod(@TVirtualReader, @!.ReadListBegin, 'ReadListBegin');
    RegisterVirtualAbstractMethod(@TVirtualReader, @!.ReadListEnd, 'ReadListEnd');
    RegisterVirtualAbstractMethod(@TVirtualReader, @!.EndOfList, 'EndOfList');}
    RegisterMethod(@TVirtualReader.ReadTStrings, 'ReadTStrings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_PersistentClasses(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TVirtualReader(CL);
  RIRegister_TVirtualWriter(CL);
  RIRegister_TPersistentObject(CL);
  RIRegister_TPersistentObjectList(CL);
  RIRegister_TBinaryReader(CL);
  RIRegister_TBinaryWriter(CL);
  RIRegister_TTextReader(CL);
  RIRegister_TTextWriter(CL);
  RIRegister_EInvalidFileSignature(CL);
  RIRegister_EFilerException(CL);
end;

 
 
{ TPSImport_PersistentClasses }
(*----------------------------------------------------------------------------*)
procedure TPSImport_PersistentClasses.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_PersistentClasses(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_PersistentClasses.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_PersistentClasses_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
