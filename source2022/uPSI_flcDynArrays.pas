unit uPSI_flcDynArrays;
{
Tone last compile for a while

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
  TPSImport_flcDynArrays = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_flcDynArrays(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_flcDynArrays_Routines(S: TPSExec);

procedure Register;

implementation


uses
   flcStdTypes
  ,cfundamentutils //flcUtils
  ,flcDynArrays
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_flcDynArrays]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_flcDynArrays(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function DynArrayAppend0( var V : ByteArray; const R : Byte) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend1( var V : Word16Array; const R : Word16) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend2( var V : Word32Array; const R : Word32) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend3( var V : Word64Array; const R : Word64) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend4( var V : LongWordArray; const R : LongWord) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend5( var V : CardinalArray; const R : Cardinal) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend6( var V : NativeUIntArray; const R : NativeUInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend7( var V : ShortIntArray; const R : ShortInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend8( var V : SmallIntArray; const R : SmallInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend9( var V : LongIntArray; const R : LongInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend10( var V : IntegerArray; const R : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend11( var V : Int32Array; const R : Int32) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend12( var V : Int64Array; const R : Int64) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend13( var V : NativeIntArray; const R : NativeInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend14( var V : SingleArray; const R : Single) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend15( var V : DoubleArray; const R : Double) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend16( var V : ExtendedArray; const R : Extended) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend17( var V : CurrencyArray; const R : Currency) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend18( var V : BooleanArray; const R : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendA19( var V : AnsiStringArray; const R : AnsiString) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendB20( var V : RawByteStringArray; const R : RawByteString) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendU21( var V : UnicodeStringArray; const R : UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend22( var V : StringArray; const R : String) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend23( var V : PointerArray; const R : Pointer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend24( var V : ObjectArray; const R : TObject) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend25( var V : InterfaceArray; const R : IInterface) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend26( var V : ByteSetArray; const R : ByteSet) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppend27( var V : ByteCharSetArray; const R : ByteCharSet) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendByteArray28( var V : ByteArray; const R : array of Byte) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendWord16Array29( var V : Word16Array; const R : array of Word16) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendWord32Array30( var V : Word32Array; const R : array of Word32) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendWord64Array31( var V : Word64Array; const R : array of Word64) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendCardinalArray32( var V : CardinalArray; const R : array of Cardinal) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendNativeUIntArray33( var V : NativeUIntArray; const R : array of NativeUInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendShortIntArray34( var V : ShortIntArray; const R : array of ShortInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendSmallIntArray35( var V : SmallIntArray; const R : array of SmallInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendLongIntArray36( var V : LongIntArray; const R : array of LongInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendIntegerArray37( var V : IntegerArray; const R : array of Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendInt32Array38( var V : Int32Array; const R : array of Int32) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendInt64Array39( var V : Int64Array; const R : array of Int64) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendNativeIntArray40( var V : NativeIntArray; const R : array of NativeInt) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendSingleArray41( var V : SingleArray; const R : array of Single) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendDoubleArray42( var V : DoubleArray; const R : array of Double) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendExtendedArray43( var V : ExtendedArray; const R : array of Extended) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendAnsiStringArray44( var V : AnsiStringArray; const R : array of AnsiString) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendRawByteStringArray45( var V : RawByteStringArray; const R : array of RawByteString) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendUnicodeStringArray46( var V : UnicodeStringArray; const R : array of UnicodeString) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendStringArray47( var V : StringArray; const R : array of String) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendCurrencyArray48( var V : CurrencyArray; const R : array of Currency) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendPointerArray49( var V : PointerArray; const R : array of Pointer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendByteCharSetArray50( var V : ByteCharSetArray; const R : array of ByteCharSet) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendByteSetArray51( var V : ByteSetArray; const R : array of ByteSet) : Integer;');
 CL.AddDelphiFunction('Function DynArrayAppendObjectArray52( var V : ObjectArray; const R : ObjectArray) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove53( var V : ByteArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove54( var V : Word16Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove55( var V : Word32Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove56( var V : Word64Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove57( var V : LongWordArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove58( var V : CardinalArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove59( var V : NativeUIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove60( var V : ShortIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove61( var V : SmallIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove62( var V : LongIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove63( var V : IntegerArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove64( var V : Int32Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove65( var V : Int64Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove66( var V : NativeIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove67( var V : SingleArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove68( var V : DoubleArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove69( var V : ExtendedArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemoveA70( var V : AnsiStringArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemoveB71( var V : RawByteStringArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemoveU72( var V : UnicodeStringArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove73( var V : StringArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove74( var V : PointerArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove75( var V : CurrencyArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove76( var V : ObjectArray; const Idx : Integer; const Count : Integer; const FreeObjects : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayRemove77( var V : InterfaceArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates78( var V : ByteArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates79( var V : Word16Array; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates80( var V : LongWordArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates81( var V : ShortIntArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates82( var V : SmallIntArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates83( var V : LongIntArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates84( var V : Int64Array; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates85( var V : SingleArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates86( var V : DoubleArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates87( var V : ExtendedArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicatesA88( var V : AnsiStringArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicatesU89( var V : UnicodeStringArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates90( var V : StringArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveDuplicates91( var V : PointerArray; const IsSorted : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft92( var S : ByteArray; const TrimList : array of Byte);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft93( var S : Word16Array; const TrimList : array of Word16);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft94( var S : LongWordArray; const TrimList : array of LongWord);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft95( var S : ShortIntArray; const TrimList : array of ShortInt);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft96( var S : SmallIntArray; const TrimList : array of SmallInt);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft97( var S : LongIntArray; const TrimList : array of LongInt);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft98( var S : Int64Array; const TrimList : array of Int64);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft99( var S : SingleArray; const TrimList : array of Single);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft100( var S : DoubleArray; const TrimList : array of Double);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft101( var S : ExtendedArray; const TrimList : array of Extended);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeftA102( var S : AnsiStringArray; const TrimList : array of AnsiString);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeftU103( var S : UnicodeStringArray; const TrimList : array of UnicodeString);');
 CL.AddDelphiFunction('Procedure DynArrayTrimLeft104( var S : PointerArray; const TrimList : array of Pointer);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight105( var S : ByteArray; const TrimList : array of Byte);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight106( var S : Word16Array; const TrimList : array of Word16);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight107( var S : LongWordArray; const TrimList : array of LongWord);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight108( var S : ShortIntArray; const TrimList : array of ShortInt);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight109( var S : SmallIntArray; const TrimList : array of SmallInt);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight110( var S : LongIntArray; const TrimList : array of LongInt);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight111( var S : Int64Array; const TrimList : array of Int64);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight112( var S : SingleArray; const TrimList : array of Single);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight113( var S : DoubleArray; const TrimList : array of Double);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight114( var S : ExtendedArray; const TrimList : array of Extended);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRightA115( var S : AnsiStringArray; const TrimList : array of AnsiString);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRightU116( var S : UnicodeStringArray; const TrimList : array of UnicodeString);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight117( var S : StringArray; const TrimList : array of String);');
 CL.AddDelphiFunction('Procedure DynArrayTrimRight118( var S : PointerArray; const TrimList : array of Pointer);');
 CL.AddDelphiFunction('Function DynArrayInsert119( var V : ByteArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert120( var V : Word16Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert121( var V : Word32Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert122( var V : Word64Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert123( var V : LongWordArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert124( var V : NativeUIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert125( var V : ShortIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert126( var V : SmallIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert127( var V : LongIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert128( var V : Int32Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert129( var V : Int64Array; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert130( var V : NativeIntArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert131( var V : SingleArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert132( var V : DoubleArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert133( var V : ExtendedArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert134( var V : CurrencyArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsertA135( var V : AnsiStringArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsertB136( var V : RawByteStringArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsertU137( var V : UnicodeStringArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert138( var V : StringArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert139( var V : PointerArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert140( var V : ObjectArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayInsert141( var V : InterfaceArray; const Idx : Integer; const Count : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext142( const Find : Byte; const V : ByteArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext143( const Find : Word16; const V : Word16Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext144( const Find : Word32; const V : Word32Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext145( const Find : Word64; const V : Word64Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext146( const Find : LongWord; const V : LongWordArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext147( const Find : Cardinal; const V : CardinalArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext148( const Find : NativeUInt; const V : NativeUIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext149( const Find : ShortInt; const V : ShortIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext150( const Find : SmallInt; const V : SmallIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext151( const Find : LongInt; const V : LongIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext152( const Find : Integer; const V : IntegerArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext153( const Find : Int32; const V : Int32Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext154( const Find : Int64; const V : Int64Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext155( const Find : NativeInt; const V : NativeIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext156( const Find : Single; const V : SingleArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext157( const Find : Double; const V : DoubleArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext158( const Find : Extended; const V : ExtendedArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext159( const Find : Boolean; const V : BooleanArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNextA160( const Find : AnsiString; const V : AnsiStringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNextB161( const Find : RawByteString; const V : RawByteStringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNextU162( const Find : UnicodeString; const V : UnicodeStringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext163( const Find : String; const V : StringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext164( const Find : Pointer; const V : PointerArray; const PrevPos : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext165( const Find : TObject; const V : ObjectArray; const PrevPos : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext166( const ClassType : TClass; const V : ObjectArray; const PrevPos : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayPosNext167( const ClassName : String; const V : ObjectArray; const PrevPos : Integer) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount168( const Find : Byte; const V : ByteArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount169( const Find : Word16; const V : Word16Array; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount170( const Find : LongWord; const V : LongWordArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount171( const Find : ShortInt; const V : ShortIntArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount172( const Find : SmallInt; const V : SmallIntArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount173( const Find : LongInt; const V : LongIntArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount174( const Find : Int64; const V : Int64Array; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount175( const Find : Single; const V : SingleArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount176( const Find : Double; const V : DoubleArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount177( const Find : Extended; const V : ExtendedArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCountA178( const Find : AnsiString; const V : AnsiStringArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCountB179( const Find : RawByteString; const V : RawByteStringArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCountU180( const Find : UnicodeString; const V : UnicodeStringArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount181( const Find : String; const V : StringArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Function DynArrayCount182( const Find : Boolean; const V : BooleanArray; const IsSortedAscending : Boolean) : Integer;');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll183( const Find : Byte; var V : ByteArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll184( const Find : Word16; var V : Word16Array; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll185( const Find : LongWord; var V : LongWordArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll186( const Find : ShortInt; var V : ShortIntArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll187( const Find : SmallInt; var V : SmallIntArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll188( const Find : LongInt; var V : LongIntArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll189( const Find : Int64; var V : Int64Array; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll190( const Find : Single; var V : SingleArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll191( const Find : Double; var V : DoubleArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll192( const Find : Extended; var V : ExtendedArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAllA193( const Find : AnsiString; var V : AnsiStringArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAllU194( const Find : UnicodeString; var V : UnicodeStringArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Procedure DynArrayRemoveAll195( const Find : String; var V : StringArray; const IsSortedAscending : Boolean);');
 CL.AddDelphiFunction('Function DynArrayIntersection196( const V1, V2 : ByteArray; const IsSortedAscending : Boolean) : ByteArray;');
 CL.AddDelphiFunction('Function DynArrayIntersection197( const V1, V2 : Word16Array; const IsSortedAscending : Boolean) : Word16Array;');
 CL.AddDelphiFunction('Function DynArrayIntersection198( const V1, V2 : LongWordArray; const IsSortedAscending : Boolean) : LongWordArray;');
 CL.AddDelphiFunction('Function DynArrayIntersection199( const V1, V2 : ShortIntArray; const IsSortedAscending : Boolean) : ShortIntArray;');
 CL.AddDelphiFunction('Function DynArrayIntersection200( const V1, V2 : SmallIntArray; const IsSortedAscending : Boolean) : SmallIntArray;');
 CL.AddDelphiFunction('Function DynArrayIntersection201( const V1, V2 : LongIntArray; const IsSortedAscending : Boolean) : LongIntArray;');
 CL.AddDelphiFunction('Function DynArrayIntersection202( const V1, V2 : Int64Array; const IsSortedAscending : Boolean) : Int64Array;');
 CL.AddDelphiFunction('Function DynArrayIntersection203( const V1, V2 : SingleArray; const IsSortedAscending : Boolean) : SingleArray;');
 CL.AddDelphiFunction('Function DynArrayIntersection204( const V1, V2 : DoubleArray; const IsSortedAscending : Boolean) : DoubleArray;');
 CL.AddDelphiFunction('Function DynArrayIntersection205( const V1, V2 : ExtendedArray; const IsSortedAscending : Boolean) : ExtendedArray;');
 CL.AddDelphiFunction('Function DynArrayIntersectionA206( const V1, V2 : AnsiStringArray; const IsSortedAscending : Boolean) : AnsiStringArray;');
 CL.AddDelphiFunction('Function DynArrayIntersectionU207( const V1, V2 : UnicodeStringArray; const IsSortedAscending : Boolean) : UnicodeStringArray;');
 CL.AddDelphiFunction('Function DynArrayIntersection208( const V1, V2 : StringArray; const IsSortedAscending : Boolean) : StringArray;');
 CL.AddDelphiFunction('Function DynArrayDifference209( const V1, V2 : ByteArray; const IsSortedAscending : Boolean) : ByteArray;');
 CL.AddDelphiFunction('Function DynArrayDifference210( const V1, V2 : Word16Array; const IsSortedAscending : Boolean) : Word16Array;');
 CL.AddDelphiFunction('Function DynArrayDifference211( const V1, V2 : LongWordArray; const IsSortedAscending : Boolean) : LongWordArray;');
 CL.AddDelphiFunction('Function DynArrayDifference212( const V1, V2 : ShortIntArray; const IsSortedAscending : Boolean) : ShortIntArray;');
 CL.AddDelphiFunction('Function DynArrayDifference213( const V1, V2 : SmallIntArray; const IsSortedAscending : Boolean) : SmallIntArray;');
 CL.AddDelphiFunction('Function DynArrayDifference214( const V1, V2 : LongIntArray; const IsSortedAscending : Boolean) : LongIntArray;');
 CL.AddDelphiFunction('Function DynArrayDifference215( const V1, V2 : Int64Array; const IsSortedAscending : Boolean) : Int64Array;');
 CL.AddDelphiFunction('Function DynArrayDifference216( const V1, V2 : SingleArray; const IsSortedAscending : Boolean) : SingleArray;');
 CL.AddDelphiFunction('Function DynArrayDifference217( const V1, V2 : DoubleArray; const IsSortedAscending : Boolean) : DoubleArray;');
 CL.AddDelphiFunction('Function DynArrayDifference218( const V1, V2 : ExtendedArray; const IsSortedAscending : Boolean) : ExtendedArray;');
 CL.AddDelphiFunction('Function DynArrayDifferenceA219( const V1, V2 : AnsiStringArray; const IsSortedAscending : Boolean) : AnsiStringArray;');
 CL.AddDelphiFunction('Function DynArrayDifferenceU220( const V1, V2 : UnicodeStringArray; const IsSortedAscending : Boolean) : UnicodeStringArray;');
 CL.AddDelphiFunction('Function DynArrayDifference221( const V1, V2 : StringArray; const IsSortedAscending : Boolean) : StringArray;');
 CL.AddDelphiFunction('Procedure DynArrayReverse222( var V : ByteArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse223( var V : Word16Array);');
 CL.AddDelphiFunction('Procedure DynArrayReverse224( var V : LongWordArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse225( var V : ShortIntArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse226( var V : SmallIntArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse227( var V : LongIntArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse228( var V : Int64Array);');
 CL.AddDelphiFunction('Procedure DynArrayReverse229( var V : SingleArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse230( var V : DoubleArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse231( var V : ExtendedArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverseA232( var V : AnsiStringArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverseU233( var V : UnicodeStringArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse234( var V : StringArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse235( var V : PointerArray);');
 CL.AddDelphiFunction('Procedure DynArrayReverse236( var V : ObjectArray);');
 CL.AddDelphiFunction('Function AsBooleanArray237( const V : array of Boolean) : BooleanArray;');
 CL.AddDelphiFunction('Function AsByteArray238( const V : array of Byte) : ByteArray;');
 CL.AddDelphiFunction('Function AsWord16Array239( const V : array of Word16) : Word16Array;');
 CL.AddDelphiFunction('Function AsWord32Array240( const V : array of Word32) : Word32Array;');
 CL.AddDelphiFunction('Function AsWord64Array241( const V : array of Word64) : Word64Array;');
 CL.AddDelphiFunction('Function AsLongWordArray242( const V : array of LongWord) : LongWordArray;');
 CL.AddDelphiFunction('Function AsCardinalArray243( const V : array of Cardinal) : CardinalArray;');
 CL.AddDelphiFunction('Function AsNativeUIntArray244( const V : array of NativeUInt) : NativeUIntArray;');
 CL.AddDelphiFunction('Function AsShortIntArray245( const V : array of ShortInt) : ShortIntArray;');
 CL.AddDelphiFunction('Function AsSmallIntArray246( const V : array of SmallInt) : SmallIntArray;');
 CL.AddDelphiFunction('Function AsLongIntArray247( const V : array of LongInt) : LongIntArray;');
 CL.AddDelphiFunction('Function AsIntegerArray248( const V : array of Integer) : IntegerArray;');
 CL.AddDelphiFunction('Function AsInt32Array249( const V : array of Int32) : Int32Array;');
 CL.AddDelphiFunction('Function AsInt64Array250( const V : array of Int64) : Int64Array;');
 CL.AddDelphiFunction('Function AsNativeIntArray251( const V : array of NativeInt) : NativeIntArray;');
 CL.AddDelphiFunction('Function AsSingleArray252( const V : array of Single) : SingleArray;');
 CL.AddDelphiFunction('Function AsDoubleArray253( const V : array of Double) : DoubleArray;');
 CL.AddDelphiFunction('Function AsExtendedArray254( const V : array of Extended) : ExtendedArray;');
 CL.AddDelphiFunction('Function AsCurrencyArray255( const V : array of Currency) : CurrencyArray;');
 CL.AddDelphiFunction('Function AsAnsiStringArray256( const V : array of AnsiString) : AnsiStringArray;');
 CL.AddDelphiFunction('Function AsRawByteStringArray257( const V : array of RawByteString) : RawByteStringArray;');
 CL.AddDelphiFunction('Function AsUnicodeStringArray258( const V : array of UnicodeString) : UnicodeStringArray;');
 CL.AddDelphiFunction('Function AsStringArray259( const V : array of String) : StringArray;');
 CL.AddDelphiFunction('Function AsPointerArray260( const V : array of Pointer) : PointerArray;');
 CL.AddDelphiFunction('Function AsByteCharSetArray261( const V : array of ByteCharSet) : ByteCharSetArray;');
 CL.AddDelphiFunction('Function AsObjectArray262( const V : array of TObject) : ObjectArray;');
 CL.AddDelphiFunction('Function AsInterfaceArray263( const V : array of IInterface) : InterfaceArray;');
 CL.AddDelphiFunction('Function DynArrayRangeByte( const First : Byte; const Count : Integer; const Increment : Byte) : ByteArray');
 CL.AddDelphiFunction('Function DynArrayRangeWord16( const First : Word16; const Count : Integer; const Increment : Word16) : Word16Array');
 CL.AddDelphiFunction('Function DynArrayRangeLongWord( const First : LongWord; const Count : Integer; const Increment : LongWord) : LongWordArray');
 CL.AddDelphiFunction('Function DynArrayRangeCardinal( const First : Cardinal; const Count : Integer; const Increment : Cardinal) : CardinalArray');
 CL.AddDelphiFunction('Function DynArrayRangeShortInt( const First : ShortInt; const Count : Integer; const Increment : ShortInt) : ShortIntArray');
 CL.AddDelphiFunction('Function DynArrayRangeSmallInt( const First : SmallInt; const Count : Integer; const Increment : SmallInt) : SmallIntArray');
 CL.AddDelphiFunction('Function DynArrayRangeLongInt( const First : LongInt; const Count : Integer; const Increment : LongInt) : LongIntArray');
 CL.AddDelphiFunction('Function DynArrayRangeInteger( const First : Integer; const Count : Integer; const Increment : Integer) : IntegerArray');
 CL.AddDelphiFunction('Function DynArrayRangeInt64( const First : Int64; const Count : Integer; const Increment : Int64) : Int64Array');
 CL.AddDelphiFunction('Function DynArrayRangeSingle( const First : Single; const Count : Integer; const Increment : Single) : SingleArray');
 CL.AddDelphiFunction('Function DynArrayRangeDouble( const First : Double; const Count : Integer; const Increment : Double) : DoubleArray');
 CL.AddDelphiFunction('Function DynArrayRangeExtended( const First : Extended; const Count : Integer; const Increment : Extended) : ExtendedArray');
 CL.AddDelphiFunction('Function DynArrayDupByte( const V : Byte; const Count : Integer) : ByteArray');
 CL.AddDelphiFunction('Function DynArrayDupWord16( const V : Word16; const Count : Integer) : Word16Array');
 CL.AddDelphiFunction('Function DynArrayDupLongWord( const V : LongWord; const Count : Integer) : LongWordArray');
 CL.AddDelphiFunction('Function DynArrayDupCardinal( const V : Cardinal; const Count : Integer) : CardinalArray');
 CL.AddDelphiFunction('Function DynArrayDupNativeUInt( const V : NativeUInt; const Count : Integer) : NativeUIntArray');
 CL.AddDelphiFunction('Function DynArrayDupShortInt( const V : ShortInt; const Count : Integer) : ShortIntArray');
 CL.AddDelphiFunction('Function DynArrayDupSmallInt( const V : SmallInt; const Count : Integer) : SmallIntArray');
 CL.AddDelphiFunction('Function DynArrayDupLongInt( const V : LongInt; const Count : Integer) : LongIntArray');
 CL.AddDelphiFunction('Function DynArrayDupInteger( const V : Integer; const Count : Integer) : IntegerArray');
 CL.AddDelphiFunction('Function DynArrayDupInt64( const V : Int64; const Count : Integer) : Int64Array');
 CL.AddDelphiFunction('Function DynArrayDupNativeInt( const V : NativeInt; const Count : Integer) : NativeIntArray');
 CL.AddDelphiFunction('Function DynArrayDupSingle( const V : Single; const Count : Integer) : SingleArray');
 CL.AddDelphiFunction('Function DynArrayDupDouble( const V : Double; const Count : Integer) : DoubleArray');
 CL.AddDelphiFunction('Function DynArrayDupExtended( const V : Extended; const Count : Integer) : ExtendedArray');
 CL.AddDelphiFunction('Function DynArrayDupCurrency( const V : Currency; const Count : Integer) : CurrencyArray');
 CL.AddDelphiFunction('Function DynArrayDupAnsiString( const V : AnsiString; const Count : Integer) : AnsiStringArray');
 CL.AddDelphiFunction('Function DynArrayDupUnicodeString( const V : UnicodeString; const Count : Integer) : UnicodeStringArray');
 CL.AddDelphiFunction('Function DynArrayDupString( const V : String; const Count : Integer) : StringArray');
 CL.AddDelphiFunction('Function DynArrayDupByteCharSet( const V : ByteCharSet; const Count : Integer) : ByteCharSetArray');
 CL.AddDelphiFunction('Function DynArrayDupObject( const V : TObject; const Count : Integer) : ObjectArray');
 CL.AddDelphiFunction('Procedure SetLengthAndZero264( var V : ByteArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero265( var V : Word16Array; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero266( var V : Word32Array; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero267( var V : Word64Array; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero268( var V : LongWordArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero269( var V : CardinalArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero270( var V : NativeUIntArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero271( var V : ShortIntArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero272( var V : SmallIntArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero273( var V : LongIntArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero274( var V : IntegerArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero275( var V : Int32Array; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero276( var V : Int64Array; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero277( var V : NativeIntArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero278( var V : SingleArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero279( var V : DoubleArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero280( var V : ExtendedArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero281( var V : CurrencyArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero282( var V : ByteCharSetArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero283( var V : BooleanArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero284( var V : PointerArray; const NewLength : Integer);');
 CL.AddDelphiFunction('Procedure SetLengthAndZero285( var V : ObjectArray; const NewLength : Integer; const FreeObjects : Boolean);');
 CL.AddDelphiFunction('Function DynArrayIsEqual286( const V1, V2 : ByteArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual287( const V1, V2 : Word16Array) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual288( const V1, V2 : LongWordArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual289( const V1, V2 : ShortIntArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual290( const V1, V2 : SmallIntArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual291( const V1, V2 : LongIntArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual292( const V1, V2 : Int64Array) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual293( const V1, V2 : SingleArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual294( const V1, V2 : DoubleArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual295( const V1, V2 : ExtendedArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual296( const V1, V2 : CurrencyArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqualA297( const V1, V2 : AnsiStringArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqualB298( const V1, V2 : RawByteStringArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqualU299( const V1, V2 : UnicodeStringArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual300( const V1, V2 : StringArray) : Boolean;');
 CL.AddDelphiFunction('Function DynArrayIsEqual301( const V1, V2 : ByteCharSetArray) : Boolean;');
 CL.AddDelphiFunction('Function ByteArrayToLongIntArray( const V : ByteArray) : LongIntArray');
 CL.AddDelphiFunction('Function Word16ArrayToLongIntArray( const V : Word16Array) : LongIntArray');
 CL.AddDelphiFunction('Function ShortIntArrayToLongIntArray( const V : ShortIntArray) : LongIntArray');
 CL.AddDelphiFunction('Function SmallIntArrayToLongIntArray( const V : SmallIntArray) : LongIntArray');
 CL.AddDelphiFunction('Function LongIntArrayToInt64Array( const V : LongIntArray) : Int64Array');
 CL.AddDelphiFunction('Function LongIntArrayToSingleArray( const V : LongIntArray) : SingleArray');
 CL.AddDelphiFunction('Function LongIntArrayToDoubleArray( const V : LongIntArray) : DoubleArray');
 CL.AddDelphiFunction('Function LongIntArrayToExtendedArray( const V : LongIntArray) : ExtendedArray');
 CL.AddDelphiFunction('Function SingleArrayToDoubleArray( const V : SingleArray) : DoubleArray');
 CL.AddDelphiFunction('Function SingleArrayToExtendedArray( const V : SingleArray) : ExtendedArray');
 CL.AddDelphiFunction('Function SingleArrayToCurrencyArray( const V : SingleArray) : CurrencyArray');
 CL.AddDelphiFunction('Function SingleArrayToLongIntArray( const V : SingleArray) : LongIntArray');
 CL.AddDelphiFunction('Function SingleArrayToInt64Array( const V : SingleArray) : Int64Array');
 CL.AddDelphiFunction('Function DoubleArrayToExtendedArray( const V : DoubleArray) : ExtendedArray');
 CL.AddDelphiFunction('Function DoubleArrayToCurrencyArray( const V : DoubleArray) : CurrencyArray');
 CL.AddDelphiFunction('Function DoubleArrayToLongIntArray( const V : DoubleArray) : LongIntArray');
 CL.AddDelphiFunction('Function DoubleArrayToInt64Array( const V : DoubleArray) : Int64Array');
 CL.AddDelphiFunction('Function ExtendedArrayToCurrencyArray( const V : ExtendedArray) : CurrencyArray');
 CL.AddDelphiFunction('Function ExtendedArrayToLongIntArray( const V : ExtendedArray) : LongIntArray');
 CL.AddDelphiFunction('Function ExtendedArrayToInt64Array( const V : ExtendedArray) : Int64Array');
 CL.AddDelphiFunction('Function ByteArrayFromIndexes( const V : ByteArray; const Indexes : IntegerArray) : ByteArray');
 CL.AddDelphiFunction('Function Word16ArrayFromIndexes( const V : Word16Array; const Indexes : IntegerArray) : Word16Array');
 CL.AddDelphiFunction('Function LongWordArrayFromIndexes( const V : LongWordArray; const Indexes : IntegerArray) : LongWordArray');
 CL.AddDelphiFunction('Function CardinalArrayFromIndexes( const V : CardinalArray; const Indexes : IntegerArray) : CardinalArray');
 CL.AddDelphiFunction('Function ShortIntArrayFromIndexes( const V : ShortIntArray; const Indexes : IntegerArray) : ShortIntArray');
 CL.AddDelphiFunction('Function SmallIntArrayFromIndexes( const V : SmallIntArray; const Indexes : IntegerArray) : SmallIntArray');
 CL.AddDelphiFunction('Function LongIntArrayFromIndexes( const V : LongIntArray; const Indexes : IntegerArray) : LongIntArray');
 CL.AddDelphiFunction('Function IntegerArrayFromIndexes( const V : IntegerArray; const Indexes : IntegerArray) : IntegerArray');
 CL.AddDelphiFunction('Function Int64ArrayFromIndexes( const V : Int64Array; const Indexes : IntegerArray) : Int64Array');
 CL.AddDelphiFunction('Function SingleArrayFromIndexes( const V : SingleArray; const Indexes : IntegerArray) : SingleArray');
 CL.AddDelphiFunction('Function DoubleArrayFromIndexes( const V : DoubleArray; const Indexes : IntegerArray) : DoubleArray');
 CL.AddDelphiFunction('Function ExtendedArrayFromIndexes( const V : ExtendedArray; const Indexes : IntegerArray) : ExtendedArray');
 CL.AddDelphiFunction('Function StringArrayFromIndexes( const V : StringArray; const Indexes : IntegerArray) : StringArray');
 CL.AddDelphiFunction('Procedure DynArraySort302( const V : ByteArray);');
 CL.AddDelphiFunction('Procedure DynArraySort303( const V : Word16Array);');
 CL.AddDelphiFunction('Procedure DynArraySort304( const V : LongWordArray);');
 CL.AddDelphiFunction('Procedure DynArraySort305( const V : CardinalArray);');
 CL.AddDelphiFunction('Procedure DynArraySort306( const V : NativeUIntArray);');
 CL.AddDelphiFunction('Procedure DynArraySort307( const V : ShortIntArray);');
 CL.AddDelphiFunction('Procedure DynArraySort308( const V : SmallIntArray);');
 CL.AddDelphiFunction('Procedure DynArraySort309( const V : LongIntArray);');
 CL.AddDelphiFunction('Procedure DynArraySort310( const V : IntegerArray);');
 CL.AddDelphiFunction('Procedure DynArraySort311( const V : Int64Array);');
 CL.AddDelphiFunction('Procedure DynArraySort312( const V : NativeIntArray);');
 CL.AddDelphiFunction('Procedure DynArraySort313( const V : SingleArray);');
 CL.AddDelphiFunction('Procedure DynArraySort314( const V : DoubleArray);');
 CL.AddDelphiFunction('Procedure DynArraySort315( const V : ExtendedArray);');
 CL.AddDelphiFunction('Procedure DynArraySortA316( const V : AnsiStringArray);');
 CL.AddDelphiFunction('Procedure DynArraySortB317( const V : RawByteStringArray);');
 CL.AddDelphiFunction('Procedure DynArraySortU318( const V : UnicodeStringArray);');
 CL.AddDelphiFunction('Procedure DynArraySort319( const V : StringArray);');
 CL.AddDelphiFunction('Procedure DynArraySort320( const Key : IntegerArray; const Data : IntegerArray);');
 CL.AddDelphiFunction('Procedure DynArraySort321( const Key : IntegerArray; const Data : Int64Array);');
 CL.AddDelphiFunction('Procedure DynArraySort322( const Key : IntegerArray; const Data : AnsiStringArray);');
 CL.AddDelphiFunction('Procedure DynArraySort323( const Key : IntegerArray; const Data : ExtendedArray);');
 CL.AddDelphiFunction('Procedure DynArraySort324( const Key : IntegerArray; const Data : PointerArray);');
 CL.AddDelphiFunction('Procedure DynArraySort325( const Key : AnsiStringArray; const Data : IntegerArray);');
 CL.AddDelphiFunction('Procedure DynArraySort326( const Key : AnsiStringArray; const Data : Int64Array);');
 CL.AddDelphiFunction('Procedure DynArraySort327( const Key : AnsiStringArray; const Data : AnsiStringArray);');
 CL.AddDelphiFunction('Procedure DynArraySort328( const Key : AnsiStringArray; const Data : ExtendedArray);');
 CL.AddDelphiFunction('Procedure DynArraySort329( const Key : AnsiStringArray; const Data : PointerArray);');
 CL.AddDelphiFunction('Procedure DynArraySort330( const Key : ExtendedArray; const Data : IntegerArray);');
 CL.AddDelphiFunction('Procedure DynArraySort331( const Key : ExtendedArray; const Data : Int64Array);');
 CL.AddDelphiFunction('Procedure DynArraySort332( const Key : ExtendedArray; const Data : AnsiStringArray);');
 CL.AddDelphiFunction('Procedure DynArraySort333( const Key : ExtendedArray; const Data : ExtendedArray);');
 CL.AddDelphiFunction('Procedure DynArraySort334( const Key : ExtendedArray; const Data : PointerArray);');
 CL.AddDelphiFunction('Procedure TestDynArray');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure DynArraySort334_P( const Key : ExtendedArray; const Data : PointerArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort333_P( const Key : ExtendedArray; const Data : ExtendedArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort332_P( const Key : ExtendedArray; const Data : AnsiStringArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort331_P( const Key : ExtendedArray; const Data : Int64Array);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort330_P( const Key : ExtendedArray; const Data : IntegerArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort329_P( const Key : AnsiStringArray; const Data : PointerArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort328_P( const Key : AnsiStringArray; const Data : ExtendedArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort327_P( const Key : AnsiStringArray; const Data : AnsiStringArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort326_P( const Key : AnsiStringArray; const Data : Int64Array);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort325_P( const Key : AnsiStringArray; const Data : IntegerArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort324_P( const Key : IntegerArray; const Data : PointerArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort323_P( const Key : IntegerArray; const Data : ExtendedArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort322_P( const Key : IntegerArray; const Data : AnsiStringArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort321_P( const Key : IntegerArray; const Data : Int64Array);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort320_P( const Key : IntegerArray; const Data : IntegerArray);
Begin flcDynArrays.DynArraySort(Key, Data); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort319_P( const V : StringArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySortU318_P( const V : UnicodeStringArray);
Begin flcDynArrays.DynArraySortU(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySortB317_P( const V : RawByteStringArray);
Begin flcDynArrays.DynArraySortB(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySortA316_P( const V : AnsiStringArray);
Begin flcDynArrays.DynArraySortA(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort315_P( const V : ExtendedArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort314_P( const V : DoubleArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort313_P( const V : SingleArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort312_P( const V : NativeIntArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort311_P( const V : Int64Array);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort310_P( const V : IntegerArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort309_P( const V : LongIntArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort308_P( const V : SmallIntArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort307_P( const V : ShortIntArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort306_P( const V : NativeUIntArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort305_P( const V : CardinalArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort304_P( const V : LongWordArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort303_P( const V : Word16Array);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArraySort302_P( const V : ByteArray);
Begin flcDynArrays.DynArraySort(V); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual301_P( const V1, V2 : ByteCharSetArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual300_P( const V1, V2 : StringArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqualU299_P( const V1, V2 : UnicodeStringArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqualU(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqualB298_P( const V1, V2 : RawByteStringArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqualB(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqualA297_P( const V1, V2 : AnsiStringArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqualA(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual296_P( const V1, V2 : CurrencyArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual295_P( const V1, V2 : ExtendedArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual294_P( const V1, V2 : DoubleArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual293_P( const V1, V2 : SingleArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual292_P( const V1, V2 : Int64Array) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual291_P( const V1, V2 : LongIntArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual290_P( const V1, V2 : SmallIntArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual289_P( const V1, V2 : ShortIntArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual288_P( const V1, V2 : LongWordArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual287_P( const V1, V2 : Word16Array) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIsEqual286_P( const V1, V2 : ByteArray) : Boolean;
Begin Result := flcDynArrays.DynArrayIsEqual(V1, V2); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero285_P( var V : ObjectArray; const NewLength : Integer; const FreeObjects : Boolean);
Begin flcDynArrays.SetLengthAndZero(V, NewLength, FreeObjects); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero284_P( var V : PointerArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero283_P( var V : BooleanArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero282_P( var V : ByteCharSetArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero281_P( var V : CurrencyArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero280_P( var V : ExtendedArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero279_P( var V : DoubleArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero278_P( var V : SingleArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero277_P( var V : NativeIntArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero276_P( var V : Int64Array; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero275_P( var V : Int32Array; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero274_P( var V : IntegerArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero273_P( var V : LongIntArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero272_P( var V : SmallIntArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero271_P( var V : ShortIntArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero270_P( var V : NativeUIntArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero269_P( var V : CardinalArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero268_P( var V : LongWordArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero267_P( var V : Word64Array; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero266_P( var V : Word32Array; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero265_P( var V : Word16Array; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Procedure SetLengthAndZero264_P( var V : ByteArray; const NewLength : Integer);
Begin flcDynArrays.SetLengthAndZero(V, NewLength); END;

(*----------------------------------------------------------------------------*)
Function AsInterfaceArray263_P( const V : array of IInterface) : InterfaceArray;
Begin Result := flcDynArrays.AsInterfaceArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsObjectArray262_P( const V : array of TObject) : ObjectArray;
Begin Result := flcDynArrays.AsObjectArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsByteCharSetArray261_P( const V : array of ByteCharSet) : ByteCharSetArray;
Begin Result := flcDynArrays.AsByteCharSetArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsPointerArray260_P( const V : array of Pointer) : PointerArray;
Begin Result := flcDynArrays.AsPointerArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsStringArray259_P( const V : array of String) : StringArray;
Begin Result := flcDynArrays.AsStringArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsUnicodeStringArray258_P( const V : array of UnicodeString) : UnicodeStringArray;
Begin Result := flcDynArrays.AsUnicodeStringArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsRawByteStringArray257_P( const V : array of RawByteString) : RawByteStringArray;
Begin Result := flcDynArrays.AsRawByteStringArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsAnsiStringArray256_P( const V : array of AnsiString) : AnsiStringArray;
Begin Result := flcDynArrays.AsAnsiStringArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsCurrencyArray255_P( const V : array of Currency) : CurrencyArray;
Begin Result := flcDynArrays.AsCurrencyArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsExtendedArray254_P( const V : array of Extended) : ExtendedArray;
Begin Result := flcDynArrays.AsExtendedArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsDoubleArray253_P( const V : array of Double) : DoubleArray;
Begin Result := flcDynArrays.AsDoubleArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsSingleArray252_P( const V : array of Single) : SingleArray;
Begin Result := flcDynArrays.AsSingleArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsNativeIntArray251_P( const V : array of NativeInt) : NativeIntArray;
Begin Result := flcDynArrays.AsNativeIntArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsInt64Array250_P( const V : array of Int64) : Int64Array;
Begin Result := flcDynArrays.AsInt64Array(V); END;

(*----------------------------------------------------------------------------*)
Function AsInt32Array249_P( const V : array of Int32) : Int32Array;
Begin Result := flcDynArrays.AsInt32Array(V); END;

(*----------------------------------------------------------------------------*)
Function AsIntegerArray248_P( const V : array of Integer) : IntegerArray;
Begin Result := flcDynArrays.AsIntegerArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsLongIntArray247_P( const V : array of LongInt) : LongIntArray;
Begin Result := flcDynArrays.AsLongIntArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsSmallIntArray246_P( const V : array of SmallInt) : SmallIntArray;
Begin Result := flcDynArrays.AsSmallIntArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsShortIntArray245_P( const V : array of ShortInt) : ShortIntArray;
Begin Result := flcDynArrays.AsShortIntArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsNativeUIntArray244_P( const V : array of NativeUInt) : NativeUIntArray;
Begin Result := flcDynArrays.AsNativeUIntArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsCardinalArray243_P( const V : array of Cardinal) : CardinalArray;
Begin Result := flcDynArrays.AsCardinalArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsLongWordArray242_P( const V : array of LongWord) : LongWordArray;
Begin Result := flcDynArrays.AsLongWordArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsWord64Array241_P( const V : array of Word64) : Word64Array;
Begin Result := flcDynArrays.AsWord64Array(V); END;

(*----------------------------------------------------------------------------*)
Function AsWord32Array240_P( const V : array of Word32) : Word32Array;
Begin Result := flcDynArrays.AsWord32Array(V); END;

(*----------------------------------------------------------------------------*)
Function AsWord16Array239_P( const V : array of Word16) : Word16Array;
Begin Result := flcDynArrays.AsWord16Array(V); END;

(*----------------------------------------------------------------------------*)
Function AsByteArray238_P( const V : array of Byte) : ByteArray;
Begin Result := flcDynArrays.AsByteArray(V); END;

(*----------------------------------------------------------------------------*)
Function AsBooleanArray237_P( const V : array of Boolean) : BooleanArray;
Begin Result := flcDynArrays.AsBooleanArray(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse236_P( var V : ObjectArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse235_P( var V : PointerArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse234_P( var V : StringArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverseU233_P( var V : UnicodeStringArray);
Begin flcDynArrays.DynArrayReverseU(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverseA232_P( var V : AnsiStringArray);
Begin flcDynArrays.DynArrayReverseA(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse231_P( var V : ExtendedArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse230_P( var V : DoubleArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse229_P( var V : SingleArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse228_P( var V : Int64Array);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse227_P( var V : LongIntArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse226_P( var V : SmallIntArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse225_P( var V : ShortIntArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse224_P( var V : LongWordArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse223_P( var V : Word16Array);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayReverse222_P( var V : ByteArray);
Begin flcDynArrays.DynArrayReverse(V); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference221_P( const V1, V2 : StringArray; const IsSortedAscending : Boolean) : StringArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifferenceU220_P( const V1, V2 : UnicodeStringArray; const IsSortedAscending : Boolean) : UnicodeStringArray;
Begin Result := flcDynArrays.DynArrayDifferenceU(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifferenceA219_P( const V1, V2 : AnsiStringArray; const IsSortedAscending : Boolean) : AnsiStringArray;
Begin Result := flcDynArrays.DynArrayDifferenceA(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference218_P( const V1, V2 : ExtendedArray; const IsSortedAscending : Boolean) : ExtendedArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference217_P( const V1, V2 : DoubleArray; const IsSortedAscending : Boolean) : DoubleArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference216_P( const V1, V2 : SingleArray; const IsSortedAscending : Boolean) : SingleArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference215_P( const V1, V2 : Int64Array; const IsSortedAscending : Boolean) : Int64Array;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference214_P( const V1, V2 : LongIntArray; const IsSortedAscending : Boolean) : LongIntArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference213_P( const V1, V2 : SmallIntArray; const IsSortedAscending : Boolean) : SmallIntArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference212_P( const V1, V2 : ShortIntArray; const IsSortedAscending : Boolean) : ShortIntArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference211_P( const V1, V2 : LongWordArray; const IsSortedAscending : Boolean) : LongWordArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference210_P( const V1, V2 : Word16Array; const IsSortedAscending : Boolean) : Word16Array;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayDifference209_P( const V1, V2 : ByteArray; const IsSortedAscending : Boolean) : ByteArray;
Begin Result := flcDynArrays.DynArrayDifference(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection208_P( const V1, V2 : StringArray; const IsSortedAscending : Boolean) : StringArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersectionU207_P( const V1, V2 : UnicodeStringArray; const IsSortedAscending : Boolean) : UnicodeStringArray;
Begin Result := flcDynArrays.DynArrayIntersectionU(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersectionA206_P( const V1, V2 : AnsiStringArray; const IsSortedAscending : Boolean) : AnsiStringArray;
Begin Result := flcDynArrays.DynArrayIntersectionA(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection205_P( const V1, V2 : ExtendedArray; const IsSortedAscending : Boolean) : ExtendedArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection204_P( const V1, V2 : DoubleArray; const IsSortedAscending : Boolean) : DoubleArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection203_P( const V1, V2 : SingleArray; const IsSortedAscending : Boolean) : SingleArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection202_P( const V1, V2 : Int64Array; const IsSortedAscending : Boolean) : Int64Array;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection201_P( const V1, V2 : LongIntArray; const IsSortedAscending : Boolean) : LongIntArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection200_P( const V1, V2 : SmallIntArray; const IsSortedAscending : Boolean) : SmallIntArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection199_P( const V1, V2 : ShortIntArray; const IsSortedAscending : Boolean) : ShortIntArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection198_P( const V1, V2 : LongWordArray; const IsSortedAscending : Boolean) : LongWordArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection197_P( const V1, V2 : Word16Array; const IsSortedAscending : Boolean) : Word16Array;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayIntersection196_P( const V1, V2 : ByteArray; const IsSortedAscending : Boolean) : ByteArray;
Begin Result := flcDynArrays.DynArrayIntersection(V1, V2, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll195_P( const Find : String; var V : StringArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAllU194_P( const Find : UnicodeString; var V : UnicodeStringArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAllU(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAllA193_P( const Find : AnsiString; var V : AnsiStringArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAllA(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll192_P( const Find : Extended; var V : ExtendedArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll191_P( const Find : Double; var V : DoubleArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll190_P( const Find : Single; var V : SingleArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll189_P( const Find : Int64; var V : Int64Array; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll188_P( const Find : LongInt; var V : LongIntArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll187_P( const Find : SmallInt; var V : SmallIntArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll186_P( const Find : ShortInt; var V : ShortIntArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll185_P( const Find : LongWord; var V : LongWordArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll184_P( const Find : Word16; var V : Word16Array; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveAll183_P( const Find : Byte; var V : ByteArray; const IsSortedAscending : Boolean);
Begin flcDynArrays.DynArrayRemoveAll(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount182_P( const Find : Boolean; const V : BooleanArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount181_P( const Find : String; const V : StringArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCountU180_P( const Find : UnicodeString; const V : UnicodeStringArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCountU(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCountB179_P( const Find : RawByteString; const V : RawByteStringArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCountB(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCountA178_P( const Find : AnsiString; const V : AnsiStringArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCountA(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount177_P( const Find : Extended; const V : ExtendedArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount176_P( const Find : Double; const V : DoubleArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount175_P( const Find : Single; const V : SingleArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount174_P( const Find : Int64; const V : Int64Array; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount173_P( const Find : LongInt; const V : LongIntArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount172_P( const Find : SmallInt; const V : SmallIntArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount171_P( const Find : ShortInt; const V : ShortIntArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount170_P( const Find : LongWord; const V : LongWordArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount169_P( const Find : Word16; const V : Word16Array; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayCount168_P( const Find : Byte; const V : ByteArray; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayCount(Find, V, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext167_P( const ClassName : String; const V : ObjectArray; const PrevPos : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(ClassName, V, PrevPos); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext166_P( const ClassType : TClass; const V : ObjectArray; const PrevPos : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(ClassType, V, PrevPos); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext165_P( const Find : TObject; const V : ObjectArray; const PrevPos : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext164_P( const Find : Pointer; const V : PointerArray; const PrevPos : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext163_P( const Find : String; const V : StringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNextU162_P( const Find : UnicodeString; const V : UnicodeStringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNextU(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNextB161_P( const Find : RawByteString; const V : RawByteStringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNextB(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNextA160_P( const Find : AnsiString; const V : AnsiStringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNextA(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext159_P( const Find : Boolean; const V : BooleanArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext158_P( const Find : Extended; const V : ExtendedArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext157_P( const Find : Double; const V : DoubleArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext156_P( const Find : Single; const V : SingleArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext155_P( const Find : NativeInt; const V : NativeIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext154_P( const Find : Int64; const V : Int64Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext153_P( const Find : Int32; const V : Int32Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext152_P( const Find : Integer; const V : IntegerArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext151_P( const Find : LongInt; const V : LongIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext150_P( const Find : SmallInt; const V : SmallIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext149_P( const Find : ShortInt; const V : ShortIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext148_P( const Find : NativeUInt; const V : NativeUIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext147_P( const Find : Cardinal; const V : CardinalArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext146_P( const Find : LongWord; const V : LongWordArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext145_P( const Find : Word64; const V : Word64Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext144_P( const Find : Word32; const V : Word32Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext143_P( const Find : Word16; const V : Word16Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayPosNext142_P( const Find : Byte; const V : ByteArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayPosNext(Find, V, PrevPos, IsSortedAscending); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert141_P( var V : InterfaceArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert140_P( var V : ObjectArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert139_P( var V : PointerArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert138_P( var V : StringArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsertU137_P( var V : UnicodeStringArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsertU(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsertB136_P( var V : RawByteStringArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsertB(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsertA135_P( var V : AnsiStringArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsertA(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert134_P( var V : CurrencyArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert133_P( var V : ExtendedArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert132_P( var V : DoubleArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert131_P( var V : SingleArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert130_P( var V : NativeIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert129_P( var V : Int64Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert128_P( var V : Int32Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert127_P( var V : LongIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert126_P( var V : SmallIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert125_P( var V : ShortIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert124_P( var V : NativeUIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert123_P( var V : LongWordArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert122_P( var V : Word64Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert121_P( var V : Word32Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert120_P( var V : Word16Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayInsert119_P( var V : ByteArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayInsert(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight118_P( var S : PointerArray; const TrimList : array of Pointer);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight117_P( var S : StringArray; const TrimList : array of String);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRightU116_P( var S : UnicodeStringArray; const TrimList : array of UnicodeString);
Begin flcDynArrays.DynArrayTrimRightU(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRightA115_P( var S : AnsiStringArray; const TrimList : array of AnsiString);
Begin flcDynArrays.DynArrayTrimRightA(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight114_P( var S : ExtendedArray; const TrimList : array of Extended);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight113_P( var S : DoubleArray; const TrimList : array of Double);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight112_P( var S : SingleArray; const TrimList : array of Single);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight111_P( var S : Int64Array; const TrimList : array of Int64);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight110_P( var S : LongIntArray; const TrimList : array of LongInt);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight109_P( var S : SmallIntArray; const TrimList : array of SmallInt);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight108_P( var S : ShortIntArray; const TrimList : array of ShortInt);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight107_P( var S : LongWordArray; const TrimList : array of LongWord);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight106_P( var S : Word16Array; const TrimList : array of Word16);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimRight105_P( var S : ByteArray; const TrimList : array of Byte);
Begin flcDynArrays.DynArrayTrimRight(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft104_P( var S : PointerArray; const TrimList : array of Pointer);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeftU103_P( var S : UnicodeStringArray; const TrimList : array of UnicodeString);
Begin flcDynArrays.DynArrayTrimLeftU(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeftA102_P( var S : AnsiStringArray; const TrimList : array of AnsiString);
Begin flcDynArrays.DynArrayTrimLeftA(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft101_P( var S : ExtendedArray; const TrimList : array of Extended);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft100_P( var S : DoubleArray; const TrimList : array of Double);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft99_P( var S : SingleArray; const TrimList : array of Single);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft98_P( var S : Int64Array; const TrimList : array of Int64);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft97_P( var S : LongIntArray; const TrimList : array of LongInt);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft96_P( var S : SmallIntArray; const TrimList : array of SmallInt);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft95_P( var S : ShortIntArray; const TrimList : array of ShortInt);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft94_P( var S : LongWordArray; const TrimList : array of LongWord);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft93_P( var S : Word16Array; const TrimList : array of Word16);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayTrimLeft92_P( var S : ByteArray; const TrimList : array of Byte);
Begin flcDynArrays.DynArrayTrimLeft(S, TrimList); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates91_P( var V : PointerArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates90_P( var V : StringArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicatesU89_P( var V : UnicodeStringArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicatesU(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicatesA88_P( var V : AnsiStringArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicatesA(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates87_P( var V : ExtendedArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates86_P( var V : DoubleArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates85_P( var V : SingleArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates84_P( var V : Int64Array; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates83_P( var V : LongIntArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates82_P( var V : SmallIntArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates81_P( var V : ShortIntArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates80_P( var V : LongWordArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates79_P( var V : Word16Array; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Procedure DynArrayRemoveDuplicates78_P( var V : ByteArray; const IsSorted : Boolean);
Begin flcDynArrays.DynArrayRemoveDuplicates(V, IsSorted); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove77_P( var V : InterfaceArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove76_P( var V : ObjectArray; const Idx : Integer; const Count : Integer; const FreeObjects : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count, FreeObjects); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove75_P( var V : CurrencyArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove74_P( var V : PointerArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove73_P( var V : StringArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemoveU72_P( var V : UnicodeStringArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemoveU(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemoveB71_P( var V : RawByteStringArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemoveB(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemoveA70_P( var V : AnsiStringArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemoveA(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove69_P( var V : ExtendedArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove68_P( var V : DoubleArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove67_P( var V : SingleArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove66_P( var V : NativeIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove65_P( var V : Int64Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove64_P( var V : Int32Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove63_P( var V : IntegerArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove62_P( var V : LongIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove61_P( var V : SmallIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove60_P( var V : ShortIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove59_P( var V : NativeUIntArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove58_P( var V : CardinalArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove57_P( var V : LongWordArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove56_P( var V : Word64Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove55_P( var V : Word32Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove54_P( var V : Word16Array; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayRemove53_P( var V : ByteArray; const Idx : Integer; const Count : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayRemove(V, Idx, Count); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendObjectArray52_P( var V : ObjectArray; const R : ObjectArray) : Integer;
Begin Result := flcDynArrays.DynArrayAppendObjectArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendByteSetArray51_P( var V : ByteSetArray; const R : array of ByteSet) : Integer;
Begin Result := flcDynArrays.DynArrayAppendByteSetArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendByteCharSetArray50_P( var V : ByteCharSetArray; const R : array of ByteCharSet) : Integer;
Begin Result := flcDynArrays.DynArrayAppendByteCharSetArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendPointerArray49_P( var V : PointerArray; const R : array of Pointer) : Integer;
Begin Result := flcDynArrays.DynArrayAppendPointerArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendCurrencyArray48_P( var V : CurrencyArray; const R : array of Currency) : Integer;
Begin Result := flcDynArrays.DynArrayAppendCurrencyArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendStringArray47_P( var V : StringArray; const R : array of String) : Integer;
Begin Result := flcDynArrays.DynArrayAppendStringArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendUnicodeStringArray46_P( var V : UnicodeStringArray; const R : array of UnicodeString) : Integer;
Begin Result := flcDynArrays.DynArrayAppendUnicodeStringArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendRawByteStringArray45_P( var V : RawByteStringArray; const R : array of RawByteString) : Integer;
Begin Result := flcDynArrays.DynArrayAppendRawByteStringArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendAnsiStringArray44_P( var V : AnsiStringArray; const R : array of AnsiString) : Integer;
Begin Result := flcDynArrays.DynArrayAppendAnsiStringArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendExtendedArray43_P( var V : ExtendedArray; const R : array of Extended) : Integer;
Begin Result := flcDynArrays.DynArrayAppendExtendedArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendDoubleArray42_P( var V : DoubleArray; const R : array of Double) : Integer;
Begin Result := flcDynArrays.DynArrayAppendDoubleArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendSingleArray41_P( var V : SingleArray; const R : array of Single) : Integer;
Begin Result := flcDynArrays.DynArrayAppendSingleArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendNativeIntArray40_P( var V : NativeIntArray; const R : array of NativeInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppendNativeIntArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendInt64Array39_P( var V : Int64Array; const R : array of Int64) : Integer;
Begin Result := flcDynArrays.DynArrayAppendInt64Array(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendInt32Array38_P( var V : Int32Array; const R : array of Int32) : Integer;
Begin Result := flcDynArrays.DynArrayAppendInt32Array(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendIntegerArray37_P( var V : IntegerArray; const R : array of Integer) : Integer;
Begin Result := flcDynArrays.DynArrayAppendIntegerArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendLongIntArray36_P( var V : LongIntArray; const R : array of LongInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppendLongIntArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendSmallIntArray35_P( var V : SmallIntArray; const R : array of SmallInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppendSmallIntArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendShortIntArray34_P( var V : ShortIntArray; const R : array of ShortInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppendShortIntArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendNativeUIntArray33_P( var V : NativeUIntArray; const R : array of NativeUInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppendNativeUIntArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendCardinalArray32_P( var V : CardinalArray; const R : array of Cardinal) : Integer;
Begin Result := flcDynArrays.DynArrayAppendCardinalArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendWord64Array31_P( var V : Word64Array; const R : array of Word64) : Integer;
Begin Result := flcDynArrays.DynArrayAppendWord64Array(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendWord32Array30_P( var V : Word32Array; const R : array of Word32) : Integer;
Begin Result := flcDynArrays.DynArrayAppendWord32Array(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendWord16Array29_P( var V : Word16Array; const R : array of Word16) : Integer;
Begin Result := flcDynArrays.DynArrayAppendWord16Array(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendByteArray28_P( var V : ByteArray; const R : array of Byte) : Integer;
Begin Result := flcDynArrays.DynArrayAppendByteArray(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend27_P( var V : ByteCharSetArray; const R : ByteCharSet) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend26_P( var V : ByteSetArray; const R : ByteSet) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend25_P( var V : InterfaceArray; const R : IInterface) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend24_P( var V : ObjectArray; const R : TObject) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend23_P( var V : PointerArray; const R : Pointer) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend22_P( var V : StringArray; const R : String) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendU21_P( var V : UnicodeStringArray; const R : UnicodeString) : Integer;
Begin Result := flcDynArrays.DynArrayAppendU(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendB20_P( var V : RawByteStringArray; const R : RawByteString) : Integer;
Begin Result := flcDynArrays.DynArrayAppendB(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppendA19_P( var V : AnsiStringArray; const R : AnsiString) : Integer;
Begin Result := flcDynArrays.DynArrayAppendA(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend18_P( var V : BooleanArray; const R : Boolean) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend17_P( var V : CurrencyArray; const R : Currency) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend16_P( var V : ExtendedArray; const R : Extended) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend15_P( var V : DoubleArray; const R : Double) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend14_P( var V : SingleArray; const R : Single) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend13_P( var V : NativeIntArray; const R : NativeInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend12_P( var V : Int64Array; const R : Int64) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend11_P( var V : Int32Array; const R : Int32) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend10_P( var V : IntegerArray; const R : Integer) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend9_P( var V : LongIntArray; const R : LongInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend8_P( var V : SmallIntArray; const R : SmallInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend7_P( var V : ShortIntArray; const R : ShortInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend6_P( var V : NativeUIntArray; const R : NativeUInt) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend5_P( var V : CardinalArray; const R : Cardinal) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend4_P( var V : LongWordArray; const R : LongWord) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend3_P( var V : Word64Array; const R : Word64) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend2_P( var V : Word32Array; const R : Word32) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend1_P( var V : Word16Array; const R : Word16) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
Function DynArrayAppend0_P( var V : ByteArray; const R : Byte) : Integer;
Begin Result := flcDynArrays.DynArrayAppend(V, R); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_flcDynArrays_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DynArrayAppend0, 'DynArrayAppend0', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend1, 'DynArrayAppend1', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend2, 'DynArrayAppend2', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend3, 'DynArrayAppend3', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend4, 'DynArrayAppend4', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend5, 'DynArrayAppend5', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend6, 'DynArrayAppend6', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend7, 'DynArrayAppend7', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend8, 'DynArrayAppend8', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend9, 'DynArrayAppend9', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend10, 'DynArrayAppend10', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend11, 'DynArrayAppend11', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend12, 'DynArrayAppend12', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend13, 'DynArrayAppend13', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend14, 'DynArrayAppend14', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend15, 'DynArrayAppend15', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend16, 'DynArrayAppend16', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend17, 'DynArrayAppend17', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend18, 'DynArrayAppend18', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendA19, 'DynArrayAppendA19', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendB20, 'DynArrayAppendB20', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendU21, 'DynArrayAppendU21', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend22, 'DynArrayAppend22', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend23, 'DynArrayAppend23', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend24, 'DynArrayAppend24', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend25, 'DynArrayAppend25', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend26, 'DynArrayAppend26', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppend27, 'DynArrayAppend27', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendByteArray28, 'DynArrayAppendByteArray28', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendWord16Array29, 'DynArrayAppendWord16Array29', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendWord32Array30, 'DynArrayAppendWord32Array30', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendWord64Array31, 'DynArrayAppendWord64Array31', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendCardinalArray32, 'DynArrayAppendCardinalArray32', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendNativeUIntArray33, 'DynArrayAppendNativeUIntArray33', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendShortIntArray34, 'DynArrayAppendShortIntArray34', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendSmallIntArray35, 'DynArrayAppendSmallIntArray35', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendLongIntArray36, 'DynArrayAppendLongIntArray36', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendIntegerArray37, 'DynArrayAppendIntegerArray37', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendInt32Array38, 'DynArrayAppendInt32Array38', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendInt64Array39, 'DynArrayAppendInt64Array39', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendNativeIntArray40, 'DynArrayAppendNativeIntArray40', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendSingleArray41, 'DynArrayAppendSingleArray41', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendDoubleArray42, 'DynArrayAppendDoubleArray42', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendExtendedArray43, 'DynArrayAppendExtendedArray43', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendAnsiStringArray44, 'DynArrayAppendAnsiStringArray44', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendRawByteStringArray45, 'DynArrayAppendRawByteStringArray45', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendUnicodeStringArray46, 'DynArrayAppendUnicodeStringArray46', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendStringArray47, 'DynArrayAppendStringArray47', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendCurrencyArray48, 'DynArrayAppendCurrencyArray48', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendPointerArray49, 'DynArrayAppendPointerArray49', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendByteCharSetArray50, 'DynArrayAppendByteCharSetArray50', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendByteSetArray51, 'DynArrayAppendByteSetArray51', cdRegister);
 S.RegisterDelphiFunction(@DynArrayAppendObjectArray52, 'DynArrayAppendObjectArray52', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove53, 'DynArrayRemove53', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove54, 'DynArrayRemove54', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove55, 'DynArrayRemove55', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove56, 'DynArrayRemove56', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove57, 'DynArrayRemove57', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove58, 'DynArrayRemove58', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove59, 'DynArrayRemove59', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove60, 'DynArrayRemove60', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove61, 'DynArrayRemove61', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove62, 'DynArrayRemove62', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove63, 'DynArrayRemove63', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove64, 'DynArrayRemove64', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove65, 'DynArrayRemove65', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove66, 'DynArrayRemove66', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove67, 'DynArrayRemove67', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove68, 'DynArrayRemove68', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove69, 'DynArrayRemove69', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveA70, 'DynArrayRemoveA70', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveB71, 'DynArrayRemoveB71', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveU72, 'DynArrayRemoveU72', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove73, 'DynArrayRemove73', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove74, 'DynArrayRemove74', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove75, 'DynArrayRemove75', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove76, 'DynArrayRemove76', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemove77, 'DynArrayRemove77', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates78, 'DynArrayRemoveDuplicates78', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates79, 'DynArrayRemoveDuplicates79', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates80, 'DynArrayRemoveDuplicates80', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates81, 'DynArrayRemoveDuplicates81', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates82, 'DynArrayRemoveDuplicates82', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates83, 'DynArrayRemoveDuplicates83', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates84, 'DynArrayRemoveDuplicates84', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates85, 'DynArrayRemoveDuplicates85', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates86, 'DynArrayRemoveDuplicates86', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates87, 'DynArrayRemoveDuplicates87', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicatesA88, 'DynArrayRemoveDuplicatesA88', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicatesU89, 'DynArrayRemoveDuplicatesU89', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates90, 'DynArrayRemoveDuplicates90', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveDuplicates91, 'DynArrayRemoveDuplicates91', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft92, 'DynArrayTrimLeft92', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft93, 'DynArrayTrimLeft93', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft94, 'DynArrayTrimLeft94', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft95, 'DynArrayTrimLeft95', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft96, 'DynArrayTrimLeft96', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft97, 'DynArrayTrimLeft97', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft98, 'DynArrayTrimLeft98', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft99, 'DynArrayTrimLeft99', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft100, 'DynArrayTrimLeft100', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft101, 'DynArrayTrimLeft101', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeftA102, 'DynArrayTrimLeftA102', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeftU103, 'DynArrayTrimLeftU103', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimLeft104, 'DynArrayTrimLeft104', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight105, 'DynArrayTrimRight105', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight106, 'DynArrayTrimRight106', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight107, 'DynArrayTrimRight107', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight108, 'DynArrayTrimRight108', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight109, 'DynArrayTrimRight109', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight110, 'DynArrayTrimRight110', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight111, 'DynArrayTrimRight111', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight112, 'DynArrayTrimRight112', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight113, 'DynArrayTrimRight113', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight114, 'DynArrayTrimRight114', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRightA115, 'DynArrayTrimRightA115', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRightU116, 'DynArrayTrimRightU116', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight117, 'DynArrayTrimRight117', cdRegister);
 S.RegisterDelphiFunction(@DynArrayTrimRight118, 'DynArrayTrimRight118', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert119, 'DynArrayInsert119', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert120, 'DynArrayInsert120', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert121, 'DynArrayInsert121', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert122, 'DynArrayInsert122', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert123, 'DynArrayInsert123', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert124, 'DynArrayInsert124', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert125, 'DynArrayInsert125', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert126, 'DynArrayInsert126', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert127, 'DynArrayInsert127', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert128, 'DynArrayInsert128', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert129, 'DynArrayInsert129', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert130, 'DynArrayInsert130', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert131, 'DynArrayInsert131', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert132, 'DynArrayInsert132', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert133, 'DynArrayInsert133', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert134, 'DynArrayInsert134', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsertA135, 'DynArrayInsertA135', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsertB136, 'DynArrayInsertB136', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsertU137, 'DynArrayInsertU137', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert138, 'DynArrayInsert138', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert139, 'DynArrayInsert139', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert140, 'DynArrayInsert140', cdRegister);
 S.RegisterDelphiFunction(@DynArrayInsert141, 'DynArrayInsert141', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext142, 'DynArrayPosNext142', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext143, 'DynArrayPosNext143', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext144, 'DynArrayPosNext144', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext145, 'DynArrayPosNext145', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext146, 'DynArrayPosNext146', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext147, 'DynArrayPosNext147', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext148, 'DynArrayPosNext148', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext149, 'DynArrayPosNext149', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext150, 'DynArrayPosNext150', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext151, 'DynArrayPosNext151', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext152, 'DynArrayPosNext152', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext153, 'DynArrayPosNext153', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext154, 'DynArrayPosNext154', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext155, 'DynArrayPosNext155', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext156, 'DynArrayPosNext156', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext157, 'DynArrayPosNext157', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext158, 'DynArrayPosNext158', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext159, 'DynArrayPosNext159', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNextA160, 'DynArrayPosNextA160', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNextB161, 'DynArrayPosNextB161', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNextU162, 'DynArrayPosNextU162', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext163, 'DynArrayPosNext163', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext164, 'DynArrayPosNext164', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext165, 'DynArrayPosNext165', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext166, 'DynArrayPosNext166', cdRegister);
 S.RegisterDelphiFunction(@DynArrayPosNext167, 'DynArrayPosNext167', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount168, 'DynArrayCount168', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount169, 'DynArrayCount169', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount170, 'DynArrayCount170', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount171, 'DynArrayCount171', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount172, 'DynArrayCount172', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount173, 'DynArrayCount173', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount174, 'DynArrayCount174', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount175, 'DynArrayCount175', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount176, 'DynArrayCount176', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount177, 'DynArrayCount177', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCountA178, 'DynArrayCountA178', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCountB179, 'DynArrayCountB179', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCountU180, 'DynArrayCountU180', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount181, 'DynArrayCount181', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCount182, 'DynArrayCount182', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll183, 'DynArrayRemoveAll183', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll184, 'DynArrayRemoveAll184', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll185, 'DynArrayRemoveAll185', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll186, 'DynArrayRemoveAll186', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll187, 'DynArrayRemoveAll187', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll188, 'DynArrayRemoveAll188', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll189, 'DynArrayRemoveAll189', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll190, 'DynArrayRemoveAll190', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll191, 'DynArrayRemoveAll191', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll192, 'DynArrayRemoveAll192', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAllA193, 'DynArrayRemoveAllA193', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAllU194, 'DynArrayRemoveAllU194', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRemoveAll195, 'DynArrayRemoveAll195', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection196, 'DynArrayIntersection196', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection197, 'DynArrayIntersection197', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection198, 'DynArrayIntersection198', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection199, 'DynArrayIntersection199', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection200, 'DynArrayIntersection200', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection201, 'DynArrayIntersection201', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection202, 'DynArrayIntersection202', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection203, 'DynArrayIntersection203', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection204, 'DynArrayIntersection204', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection205, 'DynArrayIntersection205', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersectionA206, 'DynArrayIntersectionA206', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersectionU207, 'DynArrayIntersectionU207', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIntersection208, 'DynArrayIntersection208', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference209, 'DynArrayDifference209', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference210, 'DynArrayDifference210', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference211, 'DynArrayDifference211', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference212, 'DynArrayDifference212', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference213, 'DynArrayDifference213', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference214, 'DynArrayDifference214', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference215, 'DynArrayDifference215', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference216, 'DynArrayDifference216', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference217, 'DynArrayDifference217', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference218, 'DynArrayDifference218', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifferenceA219, 'DynArrayDifferenceA219', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifferenceU220, 'DynArrayDifferenceU220', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDifference221, 'DynArrayDifference221', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse222, 'DynArrayReverse222', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse223, 'DynArrayReverse223', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse224, 'DynArrayReverse224', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse225, 'DynArrayReverse225', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse226, 'DynArrayReverse226', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse227, 'DynArrayReverse227', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse228, 'DynArrayReverse228', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse229, 'DynArrayReverse229', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse230, 'DynArrayReverse230', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse231, 'DynArrayReverse231', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverseA232, 'DynArrayReverseA232', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverseU233, 'DynArrayReverseU233', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse234, 'DynArrayReverse234', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse235, 'DynArrayReverse235', cdRegister);
 S.RegisterDelphiFunction(@DynArrayReverse236, 'DynArrayReverse236', cdRegister);
 S.RegisterDelphiFunction(@AsBooleanArray237, 'AsBooleanArray237', cdRegister);
 S.RegisterDelphiFunction(@AsByteArray238, 'AsByteArray238', cdRegister);
 S.RegisterDelphiFunction(@AsWord16Array239, 'AsWord16Array239', cdRegister);
 S.RegisterDelphiFunction(@AsWord32Array240, 'AsWord32Array240', cdRegister);
 S.RegisterDelphiFunction(@AsWord64Array241, 'AsWord64Array241', cdRegister);
 S.RegisterDelphiFunction(@AsLongWordArray242, 'AsLongWordArray242', cdRegister);
 S.RegisterDelphiFunction(@AsCardinalArray243, 'AsCardinalArray243', cdRegister);
 S.RegisterDelphiFunction(@AsNativeUIntArray244, 'AsNativeUIntArray244', cdRegister);
 S.RegisterDelphiFunction(@AsShortIntArray245, 'AsShortIntArray245', cdRegister);
 S.RegisterDelphiFunction(@AsSmallIntArray246, 'AsSmallIntArray246', cdRegister);
 S.RegisterDelphiFunction(@AsLongIntArray247, 'AsLongIntArray247', cdRegister);
 S.RegisterDelphiFunction(@AsIntegerArray248, 'AsIntegerArray248', cdRegister);
 S.RegisterDelphiFunction(@AsInt32Array249, 'AsInt32Array249', cdRegister);
 S.RegisterDelphiFunction(@AsInt64Array250, 'AsInt64Array250', cdRegister);
 S.RegisterDelphiFunction(@AsNativeIntArray251, 'AsNativeIntArray251', cdRegister);
 S.RegisterDelphiFunction(@AsSingleArray252, 'AsSingleArray252', cdRegister);
 S.RegisterDelphiFunction(@AsDoubleArray253, 'AsDoubleArray253', cdRegister);
 S.RegisterDelphiFunction(@AsExtendedArray254, 'AsExtendedArray254', cdRegister);
 S.RegisterDelphiFunction(@AsCurrencyArray255, 'AsCurrencyArray255', cdRegister);
 S.RegisterDelphiFunction(@AsAnsiStringArray256, 'AsAnsiStringArray256', cdRegister);
 S.RegisterDelphiFunction(@AsRawByteStringArray257, 'AsRawByteStringArray257', cdRegister);
 S.RegisterDelphiFunction(@AsUnicodeStringArray258, 'AsUnicodeStringArray258', cdRegister);
 S.RegisterDelphiFunction(@AsStringArray259, 'AsStringArray259', cdRegister);
 S.RegisterDelphiFunction(@AsPointerArray260, 'AsPointerArray260', cdRegister);
 S.RegisterDelphiFunction(@AsByteCharSetArray261, 'AsByteCharSetArray261', cdRegister);
 S.RegisterDelphiFunction(@AsObjectArray262, 'AsObjectArray262', cdRegister);
 S.RegisterDelphiFunction(@AsInterfaceArray263, 'AsInterfaceArray263', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeByte, 'DynArrayRangeByte', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeWord16, 'DynArrayRangeWord16', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeLongWord, 'DynArrayRangeLongWord', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeCardinal, 'DynArrayRangeCardinal', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeShortInt, 'DynArrayRangeShortInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeSmallInt, 'DynArrayRangeSmallInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeLongInt, 'DynArrayRangeLongInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeInteger, 'DynArrayRangeInteger', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeInt64, 'DynArrayRangeInt64', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeSingle, 'DynArrayRangeSingle', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeDouble, 'DynArrayRangeDouble', cdRegister);
 S.RegisterDelphiFunction(@DynArrayRangeExtended, 'DynArrayRangeExtended', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupByte, 'DynArrayDupByte', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupWord16, 'DynArrayDupWord16', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupLongWord, 'DynArrayDupLongWord', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupCardinal, 'DynArrayDupCardinal', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupNativeUInt, 'DynArrayDupNativeUInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupShortInt, 'DynArrayDupShortInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupSmallInt, 'DynArrayDupSmallInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupLongInt, 'DynArrayDupLongInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupInteger, 'DynArrayDupInteger', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupInt64, 'DynArrayDupInt64', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupNativeInt, 'DynArrayDupNativeInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupSingle, 'DynArrayDupSingle', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupDouble, 'DynArrayDupDouble', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupExtended, 'DynArrayDupExtended', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupCurrency, 'DynArrayDupCurrency', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupAnsiString, 'DynArrayDupAnsiString', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupUnicodeString, 'DynArrayDupUnicodeString', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupString, 'DynArrayDupString', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupByteCharSet, 'DynArrayDupByteCharSet', cdRegister);
 S.RegisterDelphiFunction(@DynArrayDupObject, 'DynArrayDupObject', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero264, 'SetLengthAndZero264', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero265, 'SetLengthAndZero265', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero266, 'SetLengthAndZero266', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero267, 'SetLengthAndZero267', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero268, 'SetLengthAndZero268', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero269, 'SetLengthAndZero269', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero270, 'SetLengthAndZero270', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero271, 'SetLengthAndZero271', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero272, 'SetLengthAndZero272', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero273, 'SetLengthAndZero273', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero274, 'SetLengthAndZero274', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero275, 'SetLengthAndZero275', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero276, 'SetLengthAndZero276', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero277, 'SetLengthAndZero277', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero278, 'SetLengthAndZero278', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero279, 'SetLengthAndZero279', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero280, 'SetLengthAndZero280', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero281, 'SetLengthAndZero281', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero282, 'SetLengthAndZero282', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero283, 'SetLengthAndZero283', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero284, 'SetLengthAndZero284', cdRegister);
 S.RegisterDelphiFunction(@SetLengthAndZero285, 'SetLengthAndZero285', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual286, 'DynArrayIsEqual286', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual287, 'DynArrayIsEqual287', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual288, 'DynArrayIsEqual288', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual289, 'DynArrayIsEqual289', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual290, 'DynArrayIsEqual290', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual291, 'DynArrayIsEqual291', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual292, 'DynArrayIsEqual292', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual293, 'DynArrayIsEqual293', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual294, 'DynArrayIsEqual294', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual295, 'DynArrayIsEqual295', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual296, 'DynArrayIsEqual296', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqualA297, 'DynArrayIsEqualA297', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqualB298, 'DynArrayIsEqualB298', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqualU299, 'DynArrayIsEqualU299', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual300, 'DynArrayIsEqual300', cdRegister);
 S.RegisterDelphiFunction(@DynArrayIsEqual301, 'DynArrayIsEqual301', cdRegister);
 S.RegisterDelphiFunction(@ByteArrayToLongIntArray, 'ByteArrayToLongIntArray', cdRegister);
 S.RegisterDelphiFunction(@Word16ArrayToLongIntArray, 'Word16ArrayToLongIntArray', cdRegister);
 S.RegisterDelphiFunction(@ShortIntArrayToLongIntArray, 'ShortIntArrayToLongIntArray', cdRegister);
 S.RegisterDelphiFunction(@SmallIntArrayToLongIntArray, 'SmallIntArrayToLongIntArray', cdRegister);
 S.RegisterDelphiFunction(@LongIntArrayToInt64Array, 'LongIntArrayToInt64Array', cdRegister);
 S.RegisterDelphiFunction(@LongIntArrayToSingleArray, 'LongIntArrayToSingleArray', cdRegister);
 S.RegisterDelphiFunction(@LongIntArrayToDoubleArray, 'LongIntArrayToDoubleArray', cdRegister);
 S.RegisterDelphiFunction(@LongIntArrayToExtendedArray, 'LongIntArrayToExtendedArray', cdRegister);
 S.RegisterDelphiFunction(@SingleArrayToDoubleArray, 'SingleArrayToDoubleArray', cdRegister);
 S.RegisterDelphiFunction(@SingleArrayToExtendedArray, 'SingleArrayToExtendedArray', cdRegister);
 S.RegisterDelphiFunction(@SingleArrayToCurrencyArray, 'SingleArrayToCurrencyArray', cdRegister);
 S.RegisterDelphiFunction(@SingleArrayToLongIntArray, 'SingleArrayToLongIntArray', cdRegister);
 S.RegisterDelphiFunction(@SingleArrayToInt64Array, 'SingleArrayToInt64Array', cdRegister);
 S.RegisterDelphiFunction(@DoubleArrayToExtendedArray, 'DoubleArrayToExtendedArray', cdRegister);
 S.RegisterDelphiFunction(@DoubleArrayToCurrencyArray, 'DoubleArrayToCurrencyArray', cdRegister);
 S.RegisterDelphiFunction(@DoubleArrayToLongIntArray, 'DoubleArrayToLongIntArray', cdRegister);
 S.RegisterDelphiFunction(@DoubleArrayToInt64Array, 'DoubleArrayToInt64Array', cdRegister);
 S.RegisterDelphiFunction(@ExtendedArrayToCurrencyArray, 'ExtendedArrayToCurrencyArray', cdRegister);
 S.RegisterDelphiFunction(@ExtendedArrayToLongIntArray, 'ExtendedArrayToLongIntArray', cdRegister);
 S.RegisterDelphiFunction(@ExtendedArrayToInt64Array, 'ExtendedArrayToInt64Array', cdRegister);
 S.RegisterDelphiFunction(@ByteArrayFromIndexes, 'ByteArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@Word16ArrayFromIndexes, 'Word16ArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@LongWordArrayFromIndexes, 'LongWordArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@CardinalArrayFromIndexes, 'CardinalArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@ShortIntArrayFromIndexes, 'ShortIntArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@SmallIntArrayFromIndexes, 'SmallIntArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@LongIntArrayFromIndexes, 'LongIntArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@IntegerArrayFromIndexes, 'IntegerArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@Int64ArrayFromIndexes, 'Int64ArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@SingleArrayFromIndexes, 'SingleArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@DoubleArrayFromIndexes, 'DoubleArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@ExtendedArrayFromIndexes, 'ExtendedArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@StringArrayFromIndexes, 'StringArrayFromIndexes', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort302, 'DynArraySort302', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort303, 'DynArraySort303', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort304, 'DynArraySort304', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort305, 'DynArraySort305', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort306, 'DynArraySort306', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort307, 'DynArraySort307', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort308, 'DynArraySort308', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort309, 'DynArraySort309', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort310, 'DynArraySort310', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort311, 'DynArraySort311', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort312, 'DynArraySort312', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort313, 'DynArraySort313', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort314, 'DynArraySort314', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort315, 'DynArraySort315', cdRegister);
 S.RegisterDelphiFunction(@DynArraySortA316, 'DynArraySortA316', cdRegister);
 S.RegisterDelphiFunction(@DynArraySortB317, 'DynArraySortB317', cdRegister);
 S.RegisterDelphiFunction(@DynArraySortU318, 'DynArraySortU318', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort319, 'DynArraySort319', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort320, 'DynArraySort320', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort321, 'DynArraySort321', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort322, 'DynArraySort322', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort323, 'DynArraySort323', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort324, 'DynArraySort324', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort325, 'DynArraySort325', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort326, 'DynArraySort326', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort327, 'DynArraySort327', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort328, 'DynArraySort328', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort329, 'DynArraySort329', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort330, 'DynArraySort330', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort331, 'DynArraySort331', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort332, 'DynArraySort332', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort333, 'DynArraySort333', cdRegister);
 S.RegisterDelphiFunction(@DynArraySort334, 'DynArraySort334', cdRegister);
 S.RegisterDelphiFunction(@Test, 'TestDynArray', cdRegister);
end;

 
 
{ TPSImport_flcDynArrays }
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcDynArrays.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_flcDynArrays(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_flcDynArrays.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_flcDynArrays_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
