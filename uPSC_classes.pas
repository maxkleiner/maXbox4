{ Compiletime Classes support }
unit uPSC_classes;

{$I PascalScript.inc}
interface
uses
  uPSCompiler, uPSUtils;

{
  Will register files from:
    Classes (exception TPersistent and TComponent)
  //added clear from virtual abstract
  Register STD first   add delimiter & quotechar by max, linebreak, capacity , clear
   instance size , constructor of tcollection , some types and threads v3.8.6.4
   more applications 3.9 , add TBasicAction, TDataModule, TFiler , namepath
   memorystream with writebuffer as array of byte
       CL.AddTYpeS('TByteArray','array[0..32767] of byte');   in unit uPSI_StrUtils;
   from D2009
   TTextReader  , assign TStrings
       RegisterMethod(@TSTREAM.READBUFFER , 'READBUFFERAW');
    RegisterMethod(@TSTREAM.WRITEBUFFER, 'WRITEBUFFERAW');  add more stringstream
    custommemorystream.memory as TObject  strictdelimiter
    fix stream classes but with var
    add var streamable and more interfaces enumerators
       }

procedure SIRegister_Classes_TypesAndConsts(Cl: TPSPascalCompiler);

procedure SIRegisterTStrings(cl: TPSPascalCompiler; Streams: Boolean);
procedure SIRegisterTStringList(cl: TPSPascalCompiler);
{$IFNDEF PS_MINIVCL}
procedure SIRegisterTBITS(Cl: TPSPascalCompiler);
{$ENDIF}
procedure SIRegisterTSTREAM(Cl: TPSPascalCompiler);
procedure SIRegisterTHANDLESTREAM(Cl: TPSPascalCompiler);
{$IFNDEF PS_MINIVCL}
procedure SIRegisterTMEMORYSTREAM(Cl: TPSPascalCompiler);
{$ENDIF}
procedure SIRegisterTFILESTREAM(Cl: TPSPascalCompiler);
{$IFNDEF PS_MINIVCL}
procedure SIRegisterTCUSTOMMEMORYSTREAM(Cl: TPSPascalCompiler);
procedure SIRegisterTRESOURCESTREAM(Cl: TPSPascalCompiler);
procedure SIRegisterTPARSER(Cl: TPSPascalCompiler);
procedure SIRegisterTCOLLECTIONITEM(CL: TPSPascalCompiler);
procedure SIRegisterTCOLLECTION(CL: TPSPascalCompiler);
procedure SIRegister_TStringStream(CL: TPSPascalCompiler);
procedure SIRegister_TThread(CL: TPSPascalCompiler);
procedure SIRegister_TStreamAdapter(CL: TPSPascalCompiler);
//procedure SIRegister_TClassFinder(CL: TPSPascalCompiler);
procedure SIRegister_TThreadList(CL: TPSPascalCompiler);
procedure SIRegister_TBasicAction(CL: TPSPascalCompiler);
procedure SIRegister_TDataModule(CL: TPSPascalCompiler);
procedure SIRegister_TFiler(CL: TPSPascalCompiler);

// 4.2.4.60
procedure SIRegister_IVarStreamable(CL: TPSPascalCompiler);
//procedure SIRegister_TFiler(CL: TPSPascalCompiler);
procedure SIRegister_IInterfaceComponentReference(CL: TPSPascalCompiler);
procedure SIRegister_IVCLComObject(CL: TPSPascalCompiler);
procedure SIRegister_IStringsAdapter(CL: TPSPascalCompiler);
procedure SIRegister_TStringsEnumerator(CL: TPSPascalCompiler);

procedure SIRegister_TCollectionEnumerator(CL: TPSPascalCompiler);
//procedure SIRegister_TCollectionItem(CL: TPSPascalCompiler);
procedure SIRegister_TRecall(CL: TPSPascalCompiler);
procedure SIRegister_TInterfacedPersistent(CL: TPSPascalCompiler);
//procedure SIRegister_TPersistent(CL: TPSPascalCompiler);
procedure SIRegister_TInterfaceList(CL: TPSPascalCompiler);
procedure SIRegister_TInterfaceListEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_IInterfaceList(CL: TPSPascalCompiler);
procedure SIRegister_TComponentEnumerator(CL: TPSPascalCompiler);
//procedure SIRegister_IInterfaceComponentReference(CL: TPSPascalCompiler);
procedure SIRegister_EFileStreamError(CL: TPSPascalCompiler);
procedure SIRegister_IStreamPersist(CL: TPSPascalCompiler);
procedure SIRegister_IDesignerNotify(CL: TPSPascalCompiler);




{$IFDEF DELPHI3UP}
procedure SIRegisterTOWNEDCOLLECTION(CL: TPSPascalCompiler);
{$ENDIF}
{$ENDIF}

procedure SIRegister_Classes(Cl: TPSPascalCompiler; Streams: Boolean{$IFDEF D4PLUS}=True{$ENDIF});

implementation

  uses classes;


procedure SIRegister_IVarStreamable(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IVarStreamable') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IVarStreamable, 'IVarStreamable') do
  begin
    RegisterMethod('Procedure StreamIn( var Dest : TVarData; const Stream : TStream)', cdRegister);
    RegisterMethod('Procedure StreamOut( const Source : TVarData; const Stream : TStream)', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IDesignerNotify(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IDesignerNotify') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IDesignerNotify, 'IDesignerNotify') do
  begin
    RegisterMethod('Procedure Modified', cdRegister);
    RegisterMethod('Procedure Notification( AnObject : TPersistent; Operation : TOperation)', cdRegister);
  end;
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_IInterfaceComponentReference(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInterfaceComponentReference') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInterfaceComponentReference, 'IInterfaceComponentReference') do
  begin
    RegisterMethod('Function GetComponent : TComponent', cdRegister);
  end;
end;

procedure SIRegister_IStringsAdapter(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IStringsAdapter') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IStringsAdapter, 'IStringsAdapter') do
  begin
    RegisterMethod('Procedure ReferenceStrings( S : TStrings)', cdRegister);
    RegisterMethod('Procedure ReleaseStrings', cdRegister);
  end;
end;

procedure SIRegister_IVCLComObject(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IVCLComObject') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IVCLComObject, 'IVCLComObject') do
  begin
    RegisterMethod('Function GetTypeInfoCount( out Count : Integer) : HResult', CdStdCall);
    RegisterMethod('Function GetTypeInfo( Index, LocaleID : Integer; out TypeInfo) : HResult', CdStdCall);
    RegisterMethod('Function GetIDsOfNames( const IID : TGUID; Names : Pointer; NameCount, LocaleID : Integer; DispIDs : Pointer) : HResult', CdStdCall);
    RegisterMethod('Function Invoke( DispID : Integer; const IID : TGUID; LocaleID : Integer; Flags : Word; var Params, VarResult, ExcepInfo, ArgErr : Pointer) : HResult', CdStdCall);
    RegisterMethod('Function SafeCallException( ExceptObject : TObject; ExceptAddr : Pointer) : HResult', cdRegister);
    RegisterMethod('Procedure FreeOnRelease', cdRegister);
  end;
end;

procedure SIRegister_TStringsEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStringsEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStringsEnumerator') do
  begin
    RegisterMethod('Constructor Create( AStrings : TStrings)');
    RegisterMethod('Function GetCurrent : string');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'string', iptr);
  end;
end;

procedure SIRegister_IStreamPersist(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IStreamPersist') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IStreamPersist, 'IStreamPersist') do
  begin
    RegisterMethod('Procedure LoadFromStream( Stream : TStream)', cdRegister);
    RegisterMethod('Procedure SaveToStream( Stream : TStream)', cdRegister);
  end;
end;



procedure SIRegister_TCollectionEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TCollectionEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TCollectionEnumerator') do
  begin
    RegisterMethod('Constructor Create( ACollection : TCollection)');
    RegisterMethod('Function GetCurrent : TCollectionItem');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TCollectionItem', iptr);
  end;
end;

procedure SIRegister_TComponentEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TComponentEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TComponentEnumerator') do
  begin
    RegisterMethod('Constructor Create( AComponent : TComponent)');
    RegisterMethod('Function GetCurrent : TComponent');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'TComponent', iptr);
  end;
end;

{procedure SIRegister_IInterfaceComponentReference(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInterfaceComponentReference') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInterfaceComponentReference, 'IInterfaceComponentReference') do
  begin
    RegisterMethod('Function GetComponent : TComponent', cdRegister);
  end;
end;}

procedure SIRegister_EFileStreamError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EStreamError', 'EFileStreamError') do
  with CL.AddClassN(CL.FindClass('EStreamError'),'EFileStreamError') do
  begin
    RegisterMethod('Constructor Create( ResStringRec : string; const FileName : string)');
  end;
end;


(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure SIRegister_TRecall(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TRecall') do
  with CL.AddClassN(CL.FindClass('TObject'),'TRecall') do
  begin
    RegisterMethod('Constructor Create( AStorage, AReference : TPersistent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Store');
    RegisterMethod('Procedure Forget');
    RegisterProperty('Reference', 'TPersistent', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInterfacedPersistent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TInterfacedPersistent') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TInterfacedPersistent') do
  begin
    RegisterMethod('Function QueryInterface( const IID : TGUID; out Obj) : HResult');
  end;
end;


procedure SIRegister_TInterfaceList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TInterfaceList') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TInterfaceList') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Clear');
     RegisterMethod('Procedure Free');
       RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function Expand : TInterfaceList');
    RegisterMethod('Function First : IInterface');
    RegisterMethod('Function GetEnumerator : TInterfaceListEnumerator');
    RegisterMethod('Function IndexOf( const Item : IInterface) : Integer');
    RegisterMethod('Function Add( const Item : IInterface) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; const Item : IInterface)');
    RegisterMethod('Function Last : IInterface');
    RegisterMethod('Function Remove( const Item : IInterface) : Integer');
    RegisterMethod('Procedure Lock');
    RegisterMethod('Procedure Unlock');
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Items', 'IInterface Integer', iptrw);
    SetDefaultPropery('Items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInterfaceListEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TInterfaceListEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TInterfaceListEnumerator') do
  begin
    RegisterMethod('Constructor Create( AInterfaceList : TInterfaceList)');
    RegisterMethod('Function GetCurrent : IInterface');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'IInterface', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IInterfaceList(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IInterfaceList') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IInterfaceList, 'IInterfaceList') do
  begin
    RegisterMethod('Function Get( Index : Integer) : IInterface', cdRegister);
    RegisterMethod('Function GetCapacity : Integer', cdRegister);
    RegisterMethod('Function GetCount : Integer', cdRegister);
    RegisterMethod('Procedure Put( Index : Integer; const Item : IInterface)', cdRegister);
    RegisterMethod('Procedure SetCapacity( NewCapacity : Integer)', cdRegister);
    RegisterMethod('Procedure SetCount( NewCount : Integer)', cdRegister);
    RegisterMethod('Procedure Clear', cdRegister);
    RegisterMethod('Procedure Delete( Index : Integer)', cdRegister);
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)', cdRegister);
    RegisterMethod('Function First : IInterface', cdRegister);
    RegisterMethod('Function IndexOf( const Item : IInterface) : Integer', cdRegister);
    RegisterMethod('Function Add( const Item : IInterface) : Integer', cdRegister);
    RegisterMethod('Procedure Insert( Index : Integer; const Item : IInterface)', cdRegister);
    RegisterMethod('Function Last : IInterface', cdRegister);
    RegisterMethod('Function Remove( const Item : IInterface) : Integer', cdRegister);
    RegisterMethod('Procedure Lock', cdRegister);
    RegisterMethod('Procedure Unlock', cdRegister);
  end;
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_TBasicAction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TBasicAction') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TBasicAction') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function HandlesTarget( Target : TObject) : Boolean');
    RegisterMethod('Procedure UpdateTarget( Target : TObject)');
    RegisterMethod('Procedure ExecuteTarget( Target : TObject)');
    RegisterMethod('Function Execute : Boolean');
    RegisterMethod('Procedure RegisterChanges( Value : TBasicActionLink)');
    RegisterMethod('Procedure UnRegisterChanges( Value : TBasicActionLink)');
    RegisterMethod('Function Update : Boolean');
    RegisterProperty('ActionComponent', 'TComponent', iptrw);
    RegisterProperty('OnExecute', 'TNotifyEvent', iptrw);
    RegisterProperty('OnUpdate', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextReader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTextReader') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTextReader') do begin
    RegisterMethod('Procedure Close');
    RegisterMethod('Function Peek : Integer');
    RegisterMethod('Function Read : Integer;');
    RegisterMethod('Function Read( const Buffer : TCharArray; Index, Count : Integer) : Integer;');
    RegisterMethod('Function ReadBlock( const Buffer : TCharArray; Index, Count : Integer) : Integer');
    RegisterMethod('Function ReadLine : string');
    RegisterMethod('Function ReadToEnd : string');
  end;
end;



(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataModule(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDataModule') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDataModule') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Constructor CreateNew( AOwner : TComponent; Dummy : Integer)');
    RegisterMethod('Procedure AfterConstruction');
    RegisterMethod('Procedure BeforeDestruction');
    RegisterProperty('DesignOffset', 'TPoint', iptrw);
    RegisterProperty('DesignSize', 'TPoint', iptrw);
    RegisterProperty('OldCreateOrder', 'Boolean', iptrw);
    RegisterProperty('OnCreate', 'TNotifyEvent', iptrw);
    RegisterProperty('OnDestroy', 'TNotifyEvent', iptrw);
  end;
end;

procedure SIRegister_TFiler(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TFiler') do
  with CL.AddClassN(CL.FindClass('TObject'),'TFiler') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create( Stream : TStream; BufSize : Integer)');
    RegisterMethod('Procedure DefineProperty( const Name: string; ReadData: TReaderProc; WriteData: TWriterProc; HasData : Boolean)');
    RegisterMethod('Procedure DefineBinaryProperty( const Name : string; ReadData, WriteData : TStreamProc; HasData : Boolean)');
    RegisterMethod('Procedure FlushBuffer');
    RegisterProperty('Root', 'TComponent', iptrw);
    RegisterProperty('LookupRoot', 'TComponent', iptr);
    RegisterProperty('Ancestor', 'TPersistent', iptrw);
    RegisterProperty('IgnoreChildren', 'Boolean', iptrw);
  end;
end;




procedure SIRegisterTStrings(cl: TPSPascalCompiler; Streams: Boolean); // requires TPersistent
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TStrings') do begin
    IsAbstract:= True;
    RegisterMethod('function Add(S: string): Integer;');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure Append(S: string);');
    RegisterMethod('procedure Assign(Source: TPersistent)');
    RegisterMethod('procedure AddStrings(Strings: TStrings);');
    RegisterMethod('procedure Clear;');
    RegisterMethod('procedure Delete(Index: Integer);');
    RegisterMethod('function IndexOf(const S: string): Integer; ');
    RegisterMethod('procedure Insert(Index: Integer; const S: string); ');
    RegisterMethod('function InstanceSize: Longint');     //3.7
    RegisterProperty('Count', 'Integer', iptR);
    RegisterProperty('Text', 'String', iptrw);
    RegisterProperty('CommaText', 'String', iptrw);
    RegisterProperty('Delimiter', 'Char', iptrw);    //3.1
    RegisterProperty('QuoteChar', 'Char', iptrw);
    RegisterProperty('LineBreak','string',iptrw);   //3.5
    RegisterProperty('Capacity','Integer',iptrw);
    RegisterProperty('DelimitedText','String',iptrw);
    RegisterProperty('StrictDelimiter','boolean',iptrw);
    RegisterProperty('ValueFromIndex', 'string Integer', iptrw);
    RegisterProperty('NameValueSeparator', 'Char', iptrw);
     if Streams then begin
      RegisterMethod('procedure LoadFromFile(FileName: string); ');
      RegisterMethod('procedure SaveToFile(FileName: string); ');
    end;
    RegisterProperty('Strings', 'String Integer', iptRW);
    SetDefaultPropery('Strings');
    RegisterProperty('Objects', 'TObject Integer', iptRW);

    {$IFNDEF PS_MINIVCL}
    RegisterMethod('procedure BeginUpdate;');
    RegisterMethod('procedure EndUpdate;');
    RegisterMethod('function Equals(Strings: TStrings): Boolean;');
    RegisterMethod('procedure Exchange(Index1, Index2: Integer);');
    RegisterMethod('function IndexOfName(const Name: string): Integer;');
    if Streams then
      RegisterMethod('procedure LoadFromStream(Stream: TStream); ');
    RegisterMethod('procedure Move(CurIndex, NewIndex: Integer); ');
    if Streams then
      RegisterMethod('procedure SaveToStream(Stream: TStream); ');
    RegisterMethod('procedure SetText(Text: PChar); ');
    RegisterProperty('Names', 'String Integer', iptr);
    RegisterProperty('Values', 'String String', iptRW);
    RegisterProperty('Name', 'String String', iptRW);
    RegisterMethod('function AddObject(S:String;AObject:TObject):integer');
    RegisterMethod('function GetText:PChar');
    RegisterMethod('function IndexofObject(AObject:tObject):Integer');
    RegisterMethod('procedure InsertObject(Index:Integer;S:String;AObject:TObject)');
    RegisterMethod('Function GetEnumerator : TStringsEnumerator');
    RegisterProperty('StringsAdapter', 'IStringsAdapter', iptrw);
    //RegisterMethod('Function IndexOfName( const Name : string) : Integer');

  {$ENDIF}
  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TStreamAdapter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TInterfacedObject', 'TStreamAdapter') do
  with CL.AddClassN(CL.FindClass('TInterfacedObject'),'TStreamAdapter') do begin
    RegisterMethod('Constructor Create( Stream : TStream; Ownership : TStreamOwnership)');
    RegisterMethod('Function Read( pv : Pointer; cb : Longint; pcbRead : PLongint) : HResult');
    RegisterMethod('Function Write( pv : Pointer; cb : Longint; pcbWritten : PLongint) : HResult');
    RegisterMethod('Function Seek( dlibMove : Largeint; dwOrigin : Longint; out libNewPosition : Largeint) : HResult');
    RegisterMethod('Function SetSize( libNewSize : Largeint) : HResult');
    RegisterMethod('Function CopyTo( stm : IStream; cb : Largeint; out cbRead : Largeint; out cbWritten : Largeint) : HResult');
    RegisterMethod('Function Commit( grfCommitFlags : Longint) : HResult');
    RegisterMethod('Function Revert : HResult');
    RegisterMethod('Function LockRegion( libOffset : Largeint; cb : Largeint; dwLockType : Longint) : HResult');
    RegisterMethod('Function UnlockRegion( libOffset : Largeint; cb : Largeint; dwLockType : Longint) : HResult');
    RegisterMethod('Function Stat( out statstg : TStatStg; grfStatFlag : Longint) : HResult');
    RegisterMethod('Function Clone( out stm : IStream) : HResult');
    RegisterProperty('Stream', 'TStream', iptr);
    RegisterProperty('StreamOwnership', 'TStreamOwnership', iptrw);
  end;
end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_TStringStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TStringStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TStringStream') do begin
    RegisterMethod('Constructor Create( const AString : string)');
    RegisterMethod('Function ReadString( Count : Longint) : string');
    RegisterMethod('Procedure WriteString( const AString : string)');
    RegisterMethod('function Read(Buffer: string; Count: Longint): Longint');
    RegisterMethod('function Write(const Buffer; Count: Longint): Longint;');
    RegisterMethod('function Seek(Offset: Longint; Origin: Word): Longint;');
    RegisterProperty('DataString', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TThread(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TThread') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TThread') do begin
    RegisterMethod('Constructor Create( CreateSuspended : Boolean)');
    RegisterMethod('Procedure Resume');
    RegisterMethod('Procedure Suspend');
    RegisterMethod('Procedure Terminate');
    RegisterMethod('Function WaitFor : LongWord');
    RegisterMethod('Procedure Queue( AThread : TThread; AMethod : TThreadMethod);');
    RegisterMethod('Procedure RemoveQueuedEvents( AThread : TThread; AMethod : TThreadMethod)');
    RegisterMethod('Procedure StaticQueue( AThread : TThread; AMethod : TThreadMethod)');
    RegisterMethod('Procedure Synchronize( AThread : TThread; AMethod : TThreadMethod);');
    RegisterMethod('Procedure StaticSynchronize( AThread : TThread; AMethod : TThreadMethod)');
    RegisterProperty('FatalException', 'TObject', iptr);
    RegisterProperty('FreeOnTerminate', 'Boolean', iptrw);
    RegisterProperty('Handle', 'THandle', iptr);
    RegisterProperty('Priority', 'TThreadPriority', iptrw);
    RegisterProperty('Priority', 'Integer', iptrw);
    RegisterProperty('Policy', 'Integer', iptrw);
    RegisterProperty('Suspended', 'Boolean', iptrw);
    RegisterProperty('ThreadID', 'THandle', iptr);
    RegisterProperty('ThreadID', 'Cardinal', iptr);
    RegisterProperty('OnTerminate', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TThreadList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TThreadList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TThreadList') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Add( Item : Pointer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Function LockList : TList');
    RegisterMethod('Procedure Remove( Item : Pointer)');
    RegisterMethod('Procedure UnlockList');
    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
  end;
end;


procedure SIRegisterTSTRINGLIST(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TStrings'), 'TStringList') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure Destroy');
    RegisterMethod('function Find(S:String;var Index:Integer):Boolean');
    RegisterMethod('procedure Sort');
    RegisterMethod('procedure Clear');   //3.6
    RegisterMethod('procedure Exchange(Index1, Index2: Integer);');  //3.9
    RegisterMethod('procedure Delete(Index: Integer);');
    RegisterMethod('function IndexOf(const S: string): Integer; ');
    RegisterMethod('function Add(S: string): Integer;');
    RegisterMethod('function AddObject(S:String;AObject:TObject):integer');
    RegisterMethod('procedure Insert(Index: Integer; const S: string); ');
    RegisterMethod('procedure InsertObject(Index:Integer;S:String;AObject:TObject)');
    RegisterMethod('Procedure CustomSort(Compare : TStringListSortCompare)');
    RegisterProperty('Duplicates', 'TDuplicates', iptrw);
    RegisterProperty('Sorted', 'Boolean', iptrw);
    RegisterProperty('CaseSensitive', 'Boolean', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnChanging', 'TNotifyEvent', iptrw);
  end;
end;

{$IFNDEF PS_MINIVCL}
procedure SIRegisterTBITS(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TObject'), 'TBits') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('function OpenBit:Integer');
    RegisterMethod('function InstanceSize: Longint');     //3.7
    RegisterProperty('Bits', 'Boolean Integer', iptrw);
    RegisterProperty('Size', 'Integer', iptrw);
  end;
end;
{$ENDIF}

//type tarraybyte = array of byte;

procedure SIRegisterTSTREAM(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TOBJECT'), 'TStream') do begin
    IsAbstract := True;
   //RegisterMethod('Function Read( var Buffer, Count : Longint) : Longint');
   // RegisterMethod('Function Write( const Buffer, Count : Longint) : Longint');
    RegisterMethod('function Read(Buffer:String;Count:LongInt):LongInt');
    RegisterMethod('function Write(const Buffer:String;Count:LongInt):LongInt');
    RegisterMethod('function ReadInt(var Buffer:Integer;Count:LongInt):LongInt');
    RegisterMethod('function WriteInt(const Buffer:Integer;Count:LongInt):LongInt');
    RegisterMethod('function ReadByte(var Buffer:Byte;Count:LongInt):LongInt');
    RegisterMethod('function WriteByte(const Buffer:Byte;Count:LongInt):LongInt');
    RegisterMethod('function ReadChar(var Buffer:Char;Count:LongInt):LongInt');
    RegisterMethod('function WriteChar(const Buffer:Char;Count:LongInt):LongInt');
    RegisterMethod('function ReadBufferChar(Buffer:Char;Count:LongInt):LongInt');
    RegisterMethod('function ReadByte2(var Buffer:Byte;Count:LongInt):LongInt');
    RegisterMethod('function WriteByte2(const Buffer:Byte;Count:LongInt):LongInt');

     RegisterMethod('function ReadStr(var Buffer:Integer;Count:LongInt):LongInt');
    RegisterMethod('function WriteStr(const Buffer:Integer;Count:LongInt):LongInt');


    RegisterMethod('function ReadByteArray(Buffer:TByteArray;Count:LongInt):LongInt');
    RegisterMethod('function WriteByteArray(Buffer:TByteArray;Count:LongInt):LongInt');
    RegisterMethod('function READBYTEArray2(var Buffer:TByteArray;Count:LongInt):LongInt');
    RegisterMethod('function WriteBYTEArray2(const Buffer:TByteArray;Count:LongInt):LongInt');

    RegisterMethod('procedure ReadAB(var Buffer: TByteArray;Count:LongInt)');
    RegisterMethod('procedure WriteAB(Buffer: TByteArray;Count:LongInt)');
    RegisterMethod('procedure ReadABD(var Buffer: TByteDynArray;Count:LongInt)');
    RegisterMethod('procedure WriteABD(Buffer: TByteDynArray;Count:LongInt)');
    RegisterMethod('procedure ReadAC(var Buffer: TCharArray;Count:LongInt)');
    RegisterMethod('procedure WriteAC(Buffer: TCharArray;Count:LongInt)');
    RegisterMethod('procedure ReadACD(var Buffer: TCharDynArray;Count:LongInt)');
    RegisterMethod('procedure WriteACD(Buffer: TCharDynArray;Count:LongInt)');

    RegisterMethod('function Seek(Offset:LongInt;Origin:Word):LongInt');
    RegisterMethod('procedure ReadBuffer(Buffer:String;Count:LongInt)');
    RegisterMethod('procedure WriteBuffer(Buffer:String;Count:LongInt)');
    RegisterMethod('procedure ReadBufferString(var Buffer:String;Count:LongInt)');
    RegisterMethod('procedure WriteBufferString(Buffer:String;Count:LongInt)');

    RegisterMethod('procedure ReadBufferInt(var Buffer:Integer;Count:LongInt)');
    RegisterMethod('procedure WriteBufferInt(Buffer:Integer;Count:LongInt)');
    RegisterMethod('procedure ReadBufferFloat(var Buffer:Double;Count:LongInt)');
    RegisterMethod('procedure WriteBufferFloat(Buffer:Double;Count:LongInt)');

    RegisterMethod('procedure ReadBufferAB(var Buffer: TByteArray;Count:LongInt)');
    RegisterMethod('procedure WriteBufferAB(Buffer: TByteArray;Count:LongInt)');
    RegisterMethod('procedure ReadBufferABD(var Buffer: TByteDynArray;Count:LongInt)');
    RegisterMethod('procedure WriteBufferABD(Buffer: TByteDynArray;Count:LongInt)');
    RegisterMethod('procedure ReadBufferAW(var Buffer: TWordArray;Count:LongInt)');
    RegisterMethod('procedure WriteBufferAW(Buffer: TWordArray;Count:LongInt)');

    RegisterMethod('procedure ReadBufferAC(var Buffer: TCharArray;Count:LongInt)');
    RegisterMethod('procedure WriteBufferAC(Buffer: TCharArray;Count:LongInt)');
    RegisterMethod('procedure ReadBufferACD(var Buffer: TCharDynArray;Count:LongInt)');
    RegisterMethod('procedure WriteBufferACD(Buffer: TCharDynArray;Count:LongInt)');
    RegisterMethod('procedure ReadBufferAWD(var Buffer: TWordDynArray;Count:LongInt)');
    RegisterMethod('procedure WriteBufferAWD(Buffer: TWordDynArray;Count:LongInt)');

    RegisterMethod('procedure ReadBufferP(var Buffer: PChar;Count:LongInt)');
    RegisterMethod('procedure WriteBufferP(Buffer: PChar;Count:LongInt)');

    RegisterMethod('procedure ReadBufferO(var Buffer: TObject;Count:LongInt)');
    RegisterMethod('procedure WriteBufferO(Buffer: TObject;Count:LongInt)');

     RegisterMethod('function InstanceSize: Longint');
    RegisterMethod('Procedure FixupResourceHeader( FixupInfo : Integer)');
    RegisterMethod('Procedure ReadResHeader');

     RegisterMethod('function ReadComponent(Instance: TComponent): TComponent)');
    RegisterMethod('function ReadComponentRes(Instance: TComponent): TComponent)');
    RegisterMethod('Procedure WriteComponent(Instance: TComponent)');
    RegisterMethod('Procedure WriteComponentRes(const ResName: string; Instance: TComponent)');


    {$IFDEF DELPHI4UP}
    RegisterMethod('function CopyFrom(Source:TStream;Count:Int64):LongInt');
    {$ELSE}
    RegisterMethod('function CopyFrom(Source:TStream;Count:Integer):LongInt');
    {$ENDIF}
    RegisterProperty('Position', 'LongInt', iptrw);
    RegisterProperty('Size', 'LongInt', iptrw);
  end;
end;

procedure SIRegisterTHANDLESTREAM(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TSTREAM'), 'THandleStream') do begin
    RegisterMethod('constructor Create(AHandle:Integer)');
    RegisterProperty('Handle', 'Integer', iptr);
    RegisterMethod('function Read(Buffer: string; Count: Longint): Longint');
    RegisterMethod('function Write(const Buffer: string; Count: Longint): Longint');
    RegisterMethod('function ReadInt(var Buffer:Integer;Count:LongInt):LongInt');
    RegisterMethod('function WriteInt(const aBuffer:Integer;Count:integer): integer');
    RegisterMethod('function ReadString(Buffer:string;Count:LongInt):LongInt');
    RegisterMethod('function WriteString(Buffer:string;Count:LongInt):LongInt');
    RegisterMethod('function ReadByteArray(var Buffer:TByteArray;Count:LongInt):LongInt');
    RegisterMethod('function WriteByteArray(const Buffer:TByteArray;Count:LongInt):LongInt');

    RegisterMethod('function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;');
  end;
end;

{$IFNDEF PS_MINIVCL}
procedure SIRegisterTMEMORYSTREAM(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMMEMORYSTREAM'), 'TMemoryStream') do begin
    RegisterMethod('procedure Clear');
    RegisterMethod('Procedure Free');
    RegisterMethod('procedure LoadFromStream(Stream:TStream)');
    RegisterMethod('procedure LoadFromFile(FileName:String)');
    RegisterMethod('procedure SetSize(NewSize:LongInt)');
    RegisterMethod('function InstanceSize: Longint');
    RegisterMethod('function Write(const Buffer: string; Count: Longint): Longint;');
    RegisterMethod('function WriteByteArray(Buffer:TByteArray;Count:LongInt):LongInt');
     //RegisterMethod('procedure ReadBufferAB(Buffer: array of byte;Count:LongInt)');
    //RegisterMethod('procedure WriteBufferAB(Buffer: array of byte;Count:LongInt)');
   end;
end;
{$ENDIF}


procedure SIRegisterTFILESTREAM(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('THandleStream'), 'TFileStream') do begin
    RegisterMethod('constructor Create(FileName:String;Mode:Word)');
    RegisterMethod('constructor Create1(FileName:String;Mode:Word;Rights: Cardinal)');
 // constructor Create(const AFileName: string; Mode: Word; Rights: Cardinal); overload;
    //RegisterMethod('function ReadInt(var Buffer;Count:LongInt):LongInt');
    //RegisterMethod('function WriteInt(const Buffer: integer;Count:integer):integer');
    RegisterMethod('function WriteByteArray(const Buffer:TByteArray;Count:LongInt):LongInt');
    RegisterMethod('function ReadByteArray(var Buffer: TByteArray;Count:LongInt):LongInt');
    RegisterMethod('function Testint(aint: integer): integer');

    RegisterMethod('Procedure Free');
    RegisterProperty('FileName', 'string', iptr);
    //property FileName: string read FFileName;
  end;
end;

{$IFNDEF PS_MINIVCL}
procedure SIRegisterTCUSTOMMEMORYSTREAM(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TSTREAM'), 'TCustomMemoryStream') do begin
    IsAbstract := True;
    RegisterMethod('procedure SaveToStream(Stream:TStream)');
    RegisterMethod('procedure SaveToFile(FileName:String)');
    RegisterProperty('Memory', 'TObject', iptr);
    RegisterMethod('function Read(Buffer: string; Count: Longint): Longint');
    RegisterMethod('function ReadString(var Buffer: string; Count: Longint): Longint');
    RegisterMethod('function Seek(Offset: Longint; Origin: Word): Longint;');
    RegisterMethod('function ReadByteArray(Buffer:TByteArray;Count:LongInt):LongInt');
       //property Memory: Pointer read FMemory;
 end;
end;

procedure SIRegisterTRESOURCESTREAM(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TCUSTOMMEMORYSTREAM'), 'TResourceStream') do begin
    RegisterMethod('Procedure Free');
    RegisterMethod('constructor Create(Instance:THandle;ResName:String;ResType:PChar)');
    RegisterMethod('constructor CreateFromId(Instance:THandle;ResId:Integer;ResType:PChar)');
    RegisterMethod('function Write(const Buffer; Count: Longint): Longint)');
  end;
end;

procedure SIRegisterTPARSER(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TOBJECT'), 'TParser') do begin
   // RegisterMethod('constructor Create(Stream:TStream)');
      RegisterMethod('Constructor Create( Stream : TStream; AOnError : TParserErrorEvent)');
      RegisterMethod('Procedure Free');
    RegisterMethod('procedure CheckToken(t:char)');
    RegisterMethod('procedure CheckTokenSymbol(s:string)');
    RegisterMethod('procedure Error(Ident:Integer)');
    RegisterMethod('procedure ErrorStr(Message:String)');
    RegisterMethod('Procedure ErrorFmt( const Ident : string; const Args : array of const)');
    RegisterMethod('procedure HexToBinary(Stream:TStream)');
    RegisterMethod('function NextToken:Char');
    RegisterMethod('function SourcePos:LongInt');
    RegisterMethod('function TokenComponentIdent:String');
    RegisterMethod('function TokenFloat:Extended');
    RegisterMethod('function TokenInt:LongInt');
    RegisterMethod('function TokenString:String');
      RegisterMethod('Function TokenWideString : WideString');
     RegisterMethod('function TokenSymbolIs(S:String):Boolean');
    RegisterProperty('SourceLine', 'Integer', iptr);
    RegisterProperty('LinePos', 'Integer', iptr); //3.8.6
    RegisterProperty('FloatType', 'Char', iptr);
    RegisterProperty('Token', 'Char', iptr);
        RegisterProperty('OnError', 'TParserErrorEvent', iptrw);

  end;

end;

procedure SIRegisterTCOLLECTIONITEM(CL: TPSPascalCompiler);
Begin
  if cl.FindClass('TCOLLECTION') = nil then cl.AddClassN(cl.FindClass('TPERSISTENT'), 'TCollection');
  With cl.AddClassN(cl.FindClass('TPERSISTENT'),'TCollectionItem') do
  begin
  RegisterMethod('Constructor Create( Collection : TCollection)');
  RegisterMethod('Procedure Free');
  RegisterMethod('function GetNamePath: string;');
  RegisterProperty('Collection', 'TCollection', iptrw);
{$IFDEF DELPHI3UP}  RegisterProperty('Id', 'Integer', iptr); {$ENDIF}
  RegisterProperty('Index', 'Integer', iptrw);
{$IFDEF DELPHI3UP}  RegisterProperty('DisplayName', 'String', iptrw); {$ENDIF}
  end;
end;

procedure SIRegisterTCOLLECTION(CL: TPSPascalCompiler);
var
  cr: TPSCompileTimeClass;
Begin
  cr:= CL.FindClass('TCOLLECTION');
  if cr = nil then cr := cl.AddClassN(cl.FindClass('TPERSISTENT'), 'TCollection');
With cr do begin
//  RegisterMethod('constructor Create( ItemClass : TCollectionItemClass)');
 RegisterMethod('Constructor Create(Collection : TCollectionItem)');
 {$IFDEF DELPHI3UP}  RegisterMethod('function Owner : TPersistent'); {$ENDIF}
 RegisterMethod('Procedure Free');
 RegisterMethod('procedure Assign(Source: TPersistent)');
  RegisterMethod('function Add : TCollectionItem');
  RegisterMethod('procedure BeginUpdate');
  RegisterMethod('procedure Clear');
{$IFDEF DELPHI5UP}  RegisterMethod('procedure Delete( Index : Integer)'); {$ENDIF}
  RegisterMethod('procedure EndUpdate');
{$IFDEF DELPHI3UP}  RegisterMethod('function FindItemId( Id : Integer) : TCollectionItem'); {$ENDIF}
{$IFDEF DELPHI3UP}  RegisterMethod('function Insert( Index : Integer) : TCollectionItem'); {$ENDIF}
  RegisterProperty('Count', 'Integer', iptr);
{$IFDEF DELPHI3UP}  RegisterProperty('ItemClass', 'TCollectionItemClass', iptr); {$ENDIF}
  RegisterProperty('Items', 'TCollectionItem Integer', iptrw);
  end;
end;

{$IFDEF DELPHI3UP}
procedure SIRegisterTOWNEDCOLLECTION(CL: TPSPascalCompiler);
Begin
With Cl.AddClassN(cl.FindClass('TCOLLECTION'),'TOwnedCollection') do
  begin
//  RegisterMethod('Constructor CREATE( AOWNER : TPERSISTENT; ITEMCLASS : TCOLLECTIONITEMCLASS)');
  end;
end;
{$ENDIF}
{$ENDIF}

procedure SIRegister_Classes_TypesAndConsts(Cl: TPSPascalCompiler);
begin
  cl.AddConstantN('soFromBeginning', 'Longint').Value.ts32 := 0;
  cl.AddConstantN('soFromCurrent', 'Longint').Value.ts32 := 1;
  cl.AddConstantN('soFromEnd', 'Longint').Value.ts32 := 2;
  // CL.AddConstantN('toEOF','LongInt').SetInt( Char ( 0 ));
  CL.AddConstantN('MaxListSize','LongInt').SetInt(Maxint div 16);

  cl.AddConstantN('toEOF', 'Char').SetString(#0);
  cl.AddConstantN('toSymbol', 'Char').SetString(#1);
  cl.AddConstantN('toString', 'Char').SetString(#2);
  cl.AddConstantN('toInteger', 'Char').SetString(#3);
  cl.AddConstantN('toFloat', 'Char').SetString(#4);
   CL.AddConstantN('toWString','Char').SetString(#5);
  CL.AddTypeS('TSeekOrigin', '( soBeginning, soCurrent, soEnd )');

  cl.AddConstantN('fmCreate', 'Longint').Value.ts32 := $FFFF;
  cl.AddConstantN('fmOpenRead', 'Longint').Value.ts32 := 0;
  cl.AddConstantN('fmOpenWrite', 'Longint').Value.ts32 := 1;
  cl.AddConstantN('fmOpenReadWrite', 'Longint').Value.ts32 := 2;
  cl.AddConstantN('fmShareCompat', 'Longint').Value.ts32 := 0;
  cl.AddConstantN('fmShareExclusive', 'Longint').Value.ts32 := $10;
  cl.AddConstantN('fmShareDenyWrite', 'Longint').Value.ts32 := $20;
  cl.AddConstantN('fmShareDenyRead', 'Longint').Value.ts32 := $30;
  cl.AddConstantN('fmShareDenyNone', 'Longint').Value.ts32 := $40;
  cl.AddConstantN('SecsPerDay', 'Longint').Value.ts32 := 86400;
  cl.AddConstantN('MSecPerDay', 'Longint').Value.ts32 := 86400000;
  cl.AddConstantN('DateDelta', 'Longint').Value.ts32 := 693594;
  CL.AddConstantN('scShift','LongWord').SetUInt( $2000);
  CL.AddConstantN('scCtrl','LongWord').SetUInt( $4000);
  CL.AddConstantN('scAlt','LongWord').SetUInt( $8000);
  CL.AddConstantN('scNone','LongInt').SetInt( 0);
  CL.AddTypeS('TAlignment', '( taLeftJustify, taRightJustify, taCenter )');
  CL.AddTypeS('TBiDiMode', '( bdLeftToRight, bdRightToLeft, bdRightToLeftNoAlig'
   +'n, bdRightToLeftReadingOnly )');
  CL.AddTypeS('TVerticalAlignment', '( taAlignTop, taAlignBottom, taVerticalCenter )');
  //CL.AddTypeS('TShiftState', 'set of ( ssShift, ssAlt, ssCtrl, ssLeft, ssRight,'
  // +' ssMiddle, ssDouble )');

  // TStringListSortCompare = function(List: TStringList; Index1, Index2: Integer): Integer;
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStringList');
  CL.AddTypeS('TStringListSortCompare','function(List: TStringList; Index1, Index2: Integer): Integer');

  CL.AddTypeS('TValueType', '( vaNull, vaList, vaInt8, vaInt16, vaInt32, vaExte'
   +'nded, vaString, vaIdent, vaFalse, vaTrue, vaBinary, vaSet, vaLString, vaNi'
   +'l, vaCollection, vaSingle, vaCurrency, vaDate, vaWString, vaInt64, vaUTF8S'
   +'tring, vaDouble )');
 CL.AddClassN(CL.FindClass('TOBJECT'),'TStrings');
  CL.AddTypeS('TGetModuleProc', 'Procedure ( const FileName, UnitName, FormName'
   +', DesignClass : string; CoClasses : TStrings)');

  CL.AddTypeS('TThreadMethod', 'Procedure');
  CL.AddTypeS('TThreadPriority', '( tpIdle, tpLowest, tpLower, tpNormal, tpHigh'
   +'er, tpHighest, tpTimeCritical )');
  CL.AddTypeS('TSynchronizeRecord', 'record FThread : TObject; FMethod : TThrea'
   +'dMethod; FSynchronizeException : TObject; end');
  //SIRegister_TThread(CL);

  CL.AddTypeS('THelpType', '( htKeyword, htContext )');
  CL.AddTypeS('TNotifyEvent', 'Procedure ( Sender : TObject)');
  CL.AddTypeS('TGetStrProc', 'Procedure ( const S : string)');
  CL.AddTypeS('TFilerFlag', '( ffInherited, ffChildPos, ffInline )');
  CL.AddTypeS('TFilerFlags', 'set of TFilerFlag');
  CL.AddTypeS('TParserErrorEvent', 'procedure (Sender: TObject; const Message: string; var Handled: Boolean) of object;');



  CL.AddClassN(CL.FindClass('TOBJECT'),'TParser');

    CL.AddClassN(CL.FindClass('TOBJECT'),'TFiler');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TReader');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TWriter');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStream');
  CL.AddTypeS('TReaderProc', 'Procedure ( Reader : TReader)');
  CL.AddTypeS('TWriterProc', 'Procedure ( Writer : TWriter)');
  CL.AddTypeS('TStreamProc', 'Procedure ( Stream : TStream)');
  //CL.AddTypeS('TWndMethod', 'procedure(var Message: TMessage) of object');

  //type
  //TWndMethod = procedure(var Message: TMessage) of object;


  CL.AddTypeS('TListNotification', '( lnAdded, lnExtracted, lnDeleted )');
  CL.AddTypeS('TListAssignOp', '(laCopy, laAnd, laOr, laXor, laSrcUnique, laDestUnique )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TList');
    CL.AddTypeS('TOperation', '( opInsert, opRemove )');
  CL.AddTypeS('TComponentState', '( csLoading, csReading, csWriting, csD'
   +'estroying, csDesigning, csAncestor, csUpdating, csFixups, csFreeNotificati'
   +'on, csInline, csDesignInstance )');
  CL.AddTypeS('TComponentStyle', '( csInheritable, csCheckPropAvail, csS'
   +'ubComponent, csTransient )');

  cl.AddTypeS('TAlignment', '(taLeftJustify, taRightJustify, taCenter)');
  cl.AddTypeS('THelpEvent', 'function (Command: Word; Data: Longint; var CallHelp: Boolean): Boolean');
  cl.AddTypeS('TGetStrProc', 'procedure(const S: string)');
  cl.AddTypeS('TDuplicates', '(dupIgnore, dupAccept, dupError)');
  cl.AddTypeS('TOperation', '(opInsert, opRemove)');
  cl.AddTypeS('THANDLE', 'Longint');

  cl.AddTypeS('TNotifyEvent', 'procedure (Sender: TObject)');
    CL.AddClassN(CL.FindClass('TOBJECT'),'EFCreateError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EFOpenError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EFilerError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EReadError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EWriteError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EClassNotFound');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMethodNotFound');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidImage');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EResNotFound');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EListError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EBitsError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStringListError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EComponentError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EParserError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOutOfResources');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidOperation');


end;

procedure SIRegister_Classes(Cl: TPSPascalCompiler; Streams: Boolean);
begin
  SIRegister_Classes_TypesAndConsts(Cl);
  if Streams then begin
    CL.AddTYpeS('TByteArray','array[0..32767] of byte');
    CL.AddTypeS('TByteDynArray', 'array of Byte');    //of upsi_types
    CL.AddTypeS('TCharDynArray', 'array of Char');
    CL.AddTypeS('TCharArray', 'array[0..32767] of Char;');   //ifsi_sysutils
  end;

  SIRegisterTSTREAM(Cl);
  SIRegisterTStrings(cl, Streams);
  SIRegisterTStringList(cl);
  SIRegister_TStringStream(CL);
  SIRegister_TThread(CL);
  SIRegister_TThreadList(CL);
  SIRegister_TBasicAction(CL); //3.9.3
  SIRegister_TDataModule(CL);
  SIRegister_TFiler(CL);
   SIRegister_IStreamPersist(CL);
  SIRegister_IDesignerNotify(CL);
  

  SIRegister_TTextReader(CL);
   SIRegister_IVarStreamable(CL);
//procedure SIRegister_TFiler(CL: TPSPascalCompiler);
 SIRegister_IInterfaceComponentReference(CL);
 SIRegister_IVCLComObject(CL);
 SIRegister_IStringsAdapter(CL);
 SIRegister_TStringsEnumerator(CL);

  SIRegister_TCollectionEnumerator(CL);
//procedure SIRegister_TCollectionItem(CL: TPSPascalCompiler);
 SIRegister_TRecall(CL);
 SIRegister_TInterfacedPersistent(CL);
//procedure SIRegister_TPersistent(CL: TPSPascalCompiler);
 SIRegister_TInterfaceList(CL);
 SIRegister_TInterfaceListEnumerator(CL);
 SIRegister_IInterfaceList(CL);
  SIRegister_IInterfaceComponentReference(CL);
  SIRegister_TComponentEnumerator(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStreamError');

    CL.AddTypeS('TStreamOwnership', '( soReference, soOwned )');
  SIRegister_TStreamAdapter(CL);
  {$IFNDEF PS_MINIVCL}
  SIRegisterTBITS(cl);
  {$ENDIF}
  if Streams then
  begin
    SIRegisterTHANDLESTREAM(Cl);
    SIRegisterTFILESTREAM(Cl);
    {$IFNDEF PS_MINIVCL}
    SIRegisterTCUSTOMMEMORYSTREAM(Cl);
    SIRegisterTMEMORYSTREAM(Cl);
    SIRegisterTRESOURCESTREAM(Cl);
    {$ENDIF}
  end;
  {$IFNDEF PS_MINIVCL}
  SIRegisterTPARSER(Cl);
  SIRegisterTCOLLECTIONITEM(Cl);
  SIRegisterTCOLLECTION(Cl);
  {$IFDEF DELPHI3UP}
  SIRegisterTOWNEDCOLLECTION(Cl);
  {$ENDIF}
  {$ENDIF}
end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


end.
