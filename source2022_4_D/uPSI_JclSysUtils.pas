unit uPSI_JclSysUtils;
{
   back up  to jcl sys         with JExecute2
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
  TPSImport_JclSysUtils = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_TJclSimpleLog(CL: TPSPascalCompiler);
procedure SIRegister_TJclIntfCriticalSection(CL: TPSPascalCompiler);
procedure SIRegister_TJclNumericFormat(CL: TPSPascalCompiler);
procedure SIRegister_TJclReferenceMemoryStream(CL: TPSPascalCompiler);
procedure SIRegister_JclSysUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJclSimpleLog(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclIntfCriticalSection(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclNumericFormat(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclReferenceMemoryStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclSysUtils_Routines(S: TPSExec);
procedure RIRegister_JclSysUtils(CL: TPSRuntimeClassImporter);


procedure Register;

implementation


uses
  // JclUnitVersioning
  Variants
  ,Windows
  ,TypInfo
  ,SyncObjs
  ,JclBase
  ,JclSysUtils_max, fMain
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclSysUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSimpleLog(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSimpleLog') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSimpleLog') do begin
    RegisterMethod('Constructor Create( const ALogFileName : string)');
     RegisterMethod('Procedure Free');
     RegisterMethod('Procedure ClearLog');
    RegisterMethod('Procedure CloseLog');
    RegisterMethod('Procedure OpenLog');
    RegisterMethod('Procedure Write( const Text : string; Indent : Integer);');
    RegisterMethod('Procedure Write1( Strings : TStrings; Indent : Integer);');
    RegisterMethod('Procedure TimeWrite( const Text : string; Indent : Integer);');
    RegisterMethod('Procedure TimeWrite1( Strings : TStrings; Indent : Integer);');
    RegisterMethod('Procedure WriteStamp( SeparatorLen : Integer)');
    RegisterProperty('LogFileName', 'string', iptr);
    RegisterProperty('LogOpen', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclIntfCriticalSection(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclIntfCriticalSection') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclIntfCriticalSection') do begin
    RegisterMethod('Constructor Create');
            RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclNumericFormat(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclNumericFormat') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclNumericFormat') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function Digit( DigitValue : TDigitValue) : Char');
    RegisterMethod('Function DigitValue( Digit : Char) : TDigitValue');
    RegisterMethod('Function IsDigit( Value : Char) : Boolean');
    RegisterMethod('Function Sign( Value : Char) : Integer');
    RegisterMethod('Procedure GetMantissaExp( const Value : Float; out Mantissa : string; out Exponent : Integer)');
    RegisterMethod('Function FloatToHTML( const Value : Float) : string');
    RegisterMethod('Function IntToStr1( const Value : Int64) : string;');
    RegisterMethod('Function FloatToStr( const Value : Float) : string;');
    RegisterMethod('Function StrToInt( const Value : string) : Int64');
    RegisterProperty('Base', 'TNumericSystemBase', iptrw);
    RegisterProperty('Precision', 'TDigitCount', iptrw);
    RegisterProperty('NumberOfFractionalDigits', 'TDigitCount', iptrw);
    RegisterProperty('ExponentDivision', 'Integer', iptrw);
    RegisterProperty('DigitBlockSize', 'TDigitCount', iptrw);
    RegisterProperty('DigitBlockSeparator', 'Char', iptrw);
    RegisterProperty('FractionalPartSeparator', 'Char', iptrw);
    RegisterProperty('Multiplier', 'string', iptrw);
    RegisterProperty('PaddingChar', 'Char', iptrw);
    RegisterProperty('ShowPositiveSign', 'Boolean', iptrw);
    RegisterProperty('Width', 'TDigitCount', iptrw);
    RegisterProperty('NegativeSign', 'Char', iptrw);
    RegisterProperty('PositiveSign', 'Char', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclReferenceMemoryStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomMemoryStream', 'TJclReferenceMemoryStream') do
  with CL.AddClassN(CL.FindClass('TCustomMemoryStream'),'TJclReferenceMemoryStream') do
  begin
    RegisterMethod('Constructor Create( const Ptr : TObject; Size : Longint)');
              RegisterMethod('Procedure Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclSysUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure GetAndFillMem( var P : TObject; const Size : Integer; const Value : Byte)');
 CL.AddDelphiFunction('Procedure FreeMemAndNil( var P : TObject)');
 CL.AddDelphiFunction('Function PCharOrNil( const S : string) : PChar');
 {CL.AddDelphiFunction('Function PAnsiCharOrNil( const S : AnsiString) : PAnsiChar');
 CL.AddDelphiFunction('Function PWideCharOrNil( const W : WideString) : PWideChar');
 CL.AddDelphiFunction('Function SizeOfMem( const APointer : Pointer) : Integer');
 CL.AddDelphiFunction('Function WriteProtectedMemory( BaseAddress, Buffer : Pointer; Size : Cardinal; out WrittenBytes : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function SearchSortedList( List : TList; SortFunc : TListSortCompare; Item : Pointer; Nearest : Boolean) : Integer');
 CL.AddDelphiFunction('Function SearchSortedUntyped( Param : Pointer; ItemCount : Integer; SearchFunc : TUntypedSearchCompare; const Value, Nearest : Boolean) : Integer');
 CL.AddDelphiFunction('Procedure SortDynArray( const ArrayPtr : Pointer; ElementSize : Cardinal; SortFunc : TDynArraySortCompare)');
 CL.AddDelphiFunction('Function SearchDynArray( const ArrayPtr : Pointer; ElementSize : Cardinal; SortFunc : TDynArraySortCompare; ValuePtr : Pointer; Nearest : Boolean) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareByte( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareShortInt( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareWord( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareSmallInt( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareInteger( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareCardinal( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareInt64( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareSingle( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareDouble( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareExtended( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareFloat( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareAnsiString( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareAnsiText( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareString( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Function DynArrayCompareText( Item1, Item2 : Pointer) : Integer');
 CL.AddDelphiFunction('Procedure ClearObjectList( List : TList)');
 CL.AddDelphiFunction('Procedure FreeObjectList( var List : TList)'); }
  SIRegister_TJclReferenceMemoryStream(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclVMTError');
 {CL.AddDelphiFunction('Function GetVirtualMethodCount( AClass : TClass) : Integer');
 CL.AddDelphiFunction('Function GetVirtualMethod( AClass : TClass; const Index : Integer) : Pointer');
 CL.AddDelphiFunction('Procedure SetVirtualMethod( AClass : TClass; const Index : Integer; const Method : Pointer)');
  CL.AddTypeS('PDynamicIndexList', '^TDynamicIndexList // will not work');
  CL.AddTypeS('PDynamicAddressList', '^TDynamicAddressList // will not work');
 CL.AddDelphiFunction('Function GetDynamicMethodCount( AClass : TClass) : Integer');
 CL.AddDelphiFunction('Function GetDynamicIndexList( AClass : TClass) : PDynamicIndexList');
 CL.AddDelphiFunction('Function GetDynamicAddressList( AClass : TClass) : PDynamicAddressList');
 CL.AddDelphiFunction('Function HasDynamicMethod( AClass : TClass; Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetDynamicMethod( AClass : TClass; Index : Integer) : Pointer');
 CL.AddDelphiFunction('Function GetInitTable( AClass : TClass) : PTypeInfo');
  CL.AddTypeS('PFieldEntry', '^TFieldEntry // will not work');}
  CL.AddTypeS('TFieldEntry', 'record OffSet : Integer; IDX : Word; Name : Short'
   +'String; end');
  {CL.AddTypeS('PFieldClassTable', '^TFieldClassTable // will not work');
  CL.AddTypeS('PFieldTable', '^TFieldTable // will not work');   }
  {CL.AddTypeS('TFieldTable', 'record EntryCount : Word; FieldClassTable : PFiel'
   +'dClassTable; FirstEntry : TFieldEntry; end');
 CL.AddDelphiFunction('Function GetFieldTable( AClass : TClass) : PFieldTable');
  CL.AddTypeS('PMethodEntry', '^TMethodEntry // will not work');
  CL.AddTypeS('TMethodEntry', 'record EntrySize : Word; Address : Pointer; Name'
   +' : ShortString; end');
  CL.AddTypeS('PMethodTable', '^TMethodTable // will not work');
  CL.AddTypeS('TMethodTable', 'record Count : Word; FirstEntry : TMethodEntry; end');
 CL.AddDelphiFunction('Function GetMethodTable( AClass : TClass) : PMethodTable');
 CL.AddDelphiFunction('Function GetMethodEntry( MethodTable : PMethodTable; Index : Integer) : PMethodEntry');
 CL.AddDelphiFunction('Procedure SetClassParent( AClass : TClass; NewClassParent : TClass)');
 CL.AddDelphiFunction('Function GetClassParent( AClass : TClass) : TClass');}
 CL.AddDelphiFunction('Function JIsClass( Address : ___Pointer) : Boolean');
 CL.AddDelphiFunction('Function JIsObject( Address : ___Pointer) : Boolean');
 CL.AddDelphiFunction('Function GetImplementorOfInterface( const I : IInterface) : TObject');
  CL.AddTypeS('TDigitCount', 'Integer');
  SIRegister_TJclNumericFormat(CL);
 CL.AddDelphiFunction('Function JIntToStrZeroPad( Value, Count : Integer) : AnsiString');
  CL.AddTypeS('TTextHandler', 'Procedure ( const Text : string)');
// CL.AddConstantN('ABORT_EXIT_CODE','LongInt').SetInt( ERROR_CANCELLED 1223);
 CL.AddDelphiFunction('Function JExecute( const CommandLine : string; OutputLineCallback : TTextHandler; RawOutput : Boolean; AbortPtr : Boolean) : Cardinal;');
CL.AddDelphiFunction('Function JExecute1( const CommandLine : string; var Output : string; RawOutput : Boolean; AbortPtr : Boolean) : Cardinal;');
 CL.AddDelphiFunction('Function JExecute2( const CommandLine : string; OutputLineCallback : TTextHandler; RawOutput : Boolean; AbortPtr : Boolean) : Cardinal;');
 CL.AddDelphiFunction('Function JExecute3( const CommandLine : string; OutputLineCallback : TTextHandler; RawOutput : Boolean; AbortPtr : Boolean) : Cardinal;');

 CL.AddDelphiFunction('Function ReadKey : Char');
  CL.AddTypeS('TModuleHandle', 'HINST');
  //CL.AddTypeS('TModuleHandle', 'Pointer');
 CL.AddConstantN('INVALID_MODULEHANDLE_VALUE','LongInt').SetInt( TModuleHandle ( 0 ));
 CL.AddDelphiFunction('Function LoadModule( var Module : TModuleHandle; FileName : string) : Boolean');
 CL.AddDelphiFunction('Function LoadModuleEx( var Module : TModuleHandle; FileName : string; Flags : Cardinal) : Boolean');
 CL.AddDelphiFunction('Procedure UnloadModule( var Module : TModuleHandle)');
 CL.AddDelphiFunction('Function GetModuleSymbol( Module : TModuleHandle; SymbolName : string) : TObject');
 CL.AddDelphiFunction('Function GetModuleSymbolEx( Module : TModuleHandle; SymbolName : string; var Accu : Boolean) : TObject');
 CL.AddDelphiFunction('Function ReadModuleData( Module : TModuleHandle; SymbolName : string; var Buffer, Size : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function WriteModuleData( Module : TModuleHandle; SymbolName : string; var Buffer, Size : Cardinal) : Boolean');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclConversionError');
 CL.AddDelphiFunction('Function JStrToBoolean( const S : string) : Boolean');
 CL.AddDelphiFunction('Function JBooleanToStr( B : Boolean) : string');
 CL.AddDelphiFunction('Function JIntToBool( I : Integer) : Boolean');
 CL.AddDelphiFunction('Function JBoolToInt( B : Boolean) : Integer');
 CL.AddConstantN('ListSeparator','String').SetString( ';');
 CL.AddConstantN('ListSeparator1','String').SetString( ':');
 CL.AddDelphiFunction('Procedure ListAddItems( var List : string; const Separator, Items : string)');
 CL.AddDelphiFunction('Procedure ListIncludeItems( var List : string; const Separator, Items : string)');
 CL.AddDelphiFunction('Procedure ListRemoveItems( var List : string; const Separator, Items : string)');
 CL.AddDelphiFunction('Procedure ListDelItem( var List : string; const Separator : string; const Index : Integer)');
 CL.AddDelphiFunction('Function ListItemCount( const List, Separator : string) : Integer');
 CL.AddDelphiFunction('Function ListGetItem( const List, Separator : string; const Index : Integer) : string');
 CL.AddDelphiFunction('Procedure ListSetItem( var List : string; const Separator : string; const Index : Integer; const Value : string)');
 CL.AddDelphiFunction('Function ListItemIndex( const List, Separator, Item : string) : Integer');
 CL.AddDelphiFunction('Function SystemTObjectInstance : LongWord');
 CL.AddDelphiFunction('Function IsCompiledWithPackages : Boolean');
 CL.AddDelphiFunction('Function JJclGUIDToString( const GUID : TGUID) : string');
 CL.AddDelphiFunction('Function JJclStringToGUID( const S : string) : TGUID');
  SIRegister_TJclIntfCriticalSection(CL);
  SIRegister_TJclSimpleLog(CL);
 CL.AddDelphiFunction('Procedure InitSimpleLog( const ALogFileName : string)');
 CL.AddDelphiFunction('function TryStrToBool(const S: string; out Value: Boolean): Boolean;)');
  //comparevalue
   //assignprn
 //function TryStrToBool(const S: string; out Value: Boolean): Boolean;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclSimpleLogLogOpen_R(Self: TJclSimpleLog; var T: Boolean);
begin T := Self.LogOpen; end;

(*----------------------------------------------------------------------------*)
procedure TJclSimpleLogLogFileName_R(Self: TJclSimpleLog; var T: string);
begin T := Self.LogFileName; end;

(*----------------------------------------------------------------------------*)
Procedure TJclSimpleLogTimeWrite1_P(Self: TJclSimpleLog;  Strings : TStrings; Indent : Integer);
Begin Self.TimeWrite(Strings, Indent); END;

(*----------------------------------------------------------------------------*)
Procedure TJclSimpleLogTimeWrite_P(Self: TJclSimpleLog;  const Text : string; Indent : Integer);
Begin Self.TimeWrite(Text, Indent); END;

(*----------------------------------------------------------------------------*)
Procedure TJclSimpleLogWrite1_P(Self: TJclSimpleLog;  Strings : TStrings; Indent : Integer);
Begin Self.Write(Strings, Indent); END;

(*----------------------------------------------------------------------------*)
Procedure TJclSimpleLogWrite_P(Self: TJclSimpleLog;  const Text : string; Indent : Integer);
Begin Self.Write(Text, Indent); END;

(*----------------------------------------------------------------------------*)
Function Execute1_P( const CommandLine : string; var Output : string; RawOutput : Boolean; AbortPtr : PBoolean) : Cardinal;
Begin Result := JclSysUtils_max.Execute(CommandLine, Output, RawOutput, AbortPtr); END;

Function Execute1( const CommandLine : string; var Output : string; RawOutput : Boolean; AbortPtr : PBoolean) : Cardinal;
Begin Result := JclSysUtils_max.Execute(CommandLine, Output, RawOutput, AbortPtr); END;


type
  Tfoohandler = class(TComponent)
    procedure TTextHandlerQ1(const aText: string);
   end;

{type TTextHandler =} procedure Tfoohandler.TTextHandlerQ1(const aText: string);
begin
  //memo2.lines.add(atext);
  maxform1.Memo2.Lines.add(aText);
end;      // *)

//type  TTextHandler =  procedure (const aText: string);

Function Execute1_P2( const CommandLine: string; OutputLineCallback: TTextHandler; RawOutput: Boolean; AbortPtr: PBoolean) : Cardinal;
var atexthandler: Tfoohandler;
Begin
//atexthandler:= @Tfoohandler.TTextHandlerQ;
  Result:= JclSysUtils_max.Execute(CommandLine, atexthandler.ttexthandlerq1, RawOutput, AbortPtr);

END;

Function Execute1_P3( const CommandLine: string; OutputLineCallback: TTextHandler; RawOutput: Boolean; AbortPtr: PBoolean) : Cardinal;
var atexthandler: Tfoohandler;
Begin
//atexthandler:= @Tfoohandler.TTextHandlerQ;
 if not assigned(OutputLineCallback) then
    Result:= JclSysUtils_max.Execute(CommandLine, atexthandler.ttexthandlerq1, RawOutput, AbortPtr) else
    Result:= JclSysUtils_max.Execute(CommandLine, OutputLineCallback, RawOutput, AbortPtr);
END;

(*----------------------------------------------------------------------------*)
Function Execute_P( const CommandLine : string; OutputLineCallback : TTextHandler; RawOutput : Boolean; AbortPtr : PBoolean) : Cardinal;
Begin Result := JclSysUtils_max.Execute(CommandLine, OutputLineCallback, RawOutput, AbortPtr); END;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatPositiveSign_W(Self: TJclNumericFormat; const T: Char);
begin Self.PositiveSign := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatPositiveSign_R(Self: TJclNumericFormat; var T: Char);
begin T := Self.PositiveSign; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatNegativeSign_W(Self: TJclNumericFormat; const T: Char);
begin Self.NegativeSign := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatNegativeSign_R(Self: TJclNumericFormat; var T: Char);
begin T := Self.NegativeSign; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatWidth_W(Self: TJclNumericFormat; const T: TDigitCount);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatWidth_R(Self: TJclNumericFormat; var T: TDigitCount);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatShowPositiveSign_W(Self: TJclNumericFormat; const T: Boolean);
begin Self.ShowPositiveSign := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatShowPositiveSign_R(Self: TJclNumericFormat; var T: Boolean);
begin T := Self.ShowPositiveSign; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatPaddingChar_W(Self: TJclNumericFormat; const T: Char);
begin Self.PaddingChar := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatPaddingChar_R(Self: TJclNumericFormat; var T: Char);
begin T := Self.PaddingChar; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatMultiplier_W(Self: TJclNumericFormat; const T: string);
begin Self.Multiplier := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatMultiplier_R(Self: TJclNumericFormat; var T: string);
begin T := Self.Multiplier; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatFractionalPartSeparator_W(Self: TJclNumericFormat; const T: Char);
begin Self.FractionalPartSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatFractionalPartSeparator_R(Self: TJclNumericFormat; var T: Char);
begin T := Self.FractionalPartSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatDigitBlockSeparator_W(Self: TJclNumericFormat; const T: Char);
begin Self.DigitBlockSeparator := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatDigitBlockSeparator_R(Self: TJclNumericFormat; var T: Char);
begin T := Self.DigitBlockSeparator; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatDigitBlockSize_W(Self: TJclNumericFormat; const T: TDigitCount);
begin Self.DigitBlockSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatDigitBlockSize_R(Self: TJclNumericFormat; var T: TDigitCount);
begin T := Self.DigitBlockSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatExponentDivision_W(Self: TJclNumericFormat; const T: Integer);
begin Self.ExponentDivision := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatExponentDivision_R(Self: TJclNumericFormat; var T: Integer);
begin T := Self.ExponentDivision; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatNumberOfFractionalDigits_W(Self: TJclNumericFormat; const T: TDigitCount);
begin Self.NumberOfFractionalDigits := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatNumberOfFractionalDigits_R(Self: TJclNumericFormat; var T: TDigitCount);
begin T := Self.NumberOfFractionalDigits; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatPrecision_W(Self: TJclNumericFormat; const T: TDigitCount);
begin Self.Precision := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatPrecision_R(Self: TJclNumericFormat; var T: TDigitCount);
begin T := Self.Precision; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatBase_W(Self: TJclNumericFormat; const T: TNumericSystemBase);
begin Self.Base := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclNumericFormatBase_R(Self: TJclNumericFormat; var T: TNumericSystemBase);
begin T := Self.Base; end;

(*----------------------------------------------------------------------------*)
Function TJclNumericFormatFloatToStr_P(Self: TJclNumericFormat;  const Value : Float) : string;
Begin Result := Self.FloatToStr(Value); END;

(*----------------------------------------------------------------------------*)
Function TJclNumericFormatIntToStr1_P(Self: TJclNumericFormat;  const Value : Int64) : string;
Begin Result := Self.IntToStr(Value); END;

(*----------------------------------------------------------------------------*)
Function TJclNumericFormatSignChar1_P(Self: TJclNumericFormat;  const Value : Int64) : Char;
Begin //Result := Self.SignChar(Value);
END;

(*----------------------------------------------------------------------------*)
Function TJclNumericFormatSignChar_P(Self: TJclNumericFormat;  const Value : Float) : Char;
Begin //Result := Self.SignChar(Value);
END;

(*----------------------------------------------------------------------------*)
Function TJclNumericFormatShowSign1_P(Self: TJclNumericFormat;  const Value : Int64) : Boolean;
Begin //Result := Self.ShowSign(Value);
END;

(*----------------------------------------------------------------------------*)
Function TJclNumericFormatShowSign_P(Self: TJclNumericFormat;  const Value : Float) : Boolean;
Begin //Result := Self.ShowSign(Value);
END;

(*----------------------------------------------------------------------------*)
Function TJclNumericFormatIntToStr_P(Self: TJclNumericFormat;  const Value : Int64; out FirstDigitPos : Integer) : string;
Begin //Result := Self.IntToStr(Value, FirstDigitPos);
END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSimpleLog(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSimpleLog) do begin
    RegisterConstructor(@TJclSimpleLog.Create, 'Create');
         RegisterMethod(@TJclSimpleLog.Destroy, 'Free');
    RegisterMethod(@TJclSimpleLog.ClearLog, 'ClearLog');
    RegisterMethod(@TJclSimpleLog.CloseLog, 'CloseLog');
    RegisterMethod(@TJclSimpleLog.OpenLog, 'OpenLog');
    RegisterMethod(@TJclSimpleLogWrite_P, 'Write');
    RegisterMethod(@TJclSimpleLogWrite1_P, 'Write1');
    RegisterMethod(@TJclSimpleLogTimeWrite_P, 'TimeWrite');
    RegisterMethod(@TJclSimpleLogTimeWrite1_P, 'TimeWrite1');
    RegisterMethod(@TJclSimpleLog.WriteStamp, 'WriteStamp');
    RegisterPropertyHelper(@TJclSimpleLogLogFileName_R,nil,'LogFileName');
    RegisterPropertyHelper(@TJclSimpleLogLogOpen_R,nil,'LogOpen');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclIntfCriticalSection(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclIntfCriticalSection) do begin
    RegisterConstructor(@TJclIntfCriticalSection.Create, 'Create');
         RegisterMethod(@TJclIntfCriticalSection.Destroy, 'Free');
   end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclNumericFormat(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclNumericFormat) do begin
    RegisterConstructor(@TJclNumericFormat.Create, 'Create');
    RegisterMethod(@TJclNumericFormat.Destroy, 'Free');
    RegisterMethod(@TJclNumericFormat.Digit, 'Digit');
    RegisterMethod(@TJclNumericFormat.DigitValue, 'DigitValue');
    RegisterMethod(@TJclNumericFormat.IsDigit, 'IsDigit');
    RegisterMethod(@TJclNumericFormat.Sign, 'Sign');
    RegisterMethod(@TJclNumericFormat.GetMantissaExp, 'GetMantissaExp');
    RegisterMethod(@TJclNumericFormat.FloatToHTML, 'FloatToHTML');
    RegisterMethod(@TJclNumericFormatIntToStr1_P, 'IntToStr1');
    RegisterMethod(@TJclNumericFormatFloatToStr_P, 'FloatToStr');
    RegisterMethod(@TJclNumericFormat.StrToInt, 'StrToInt');
    RegisterPropertyHelper(@TJclNumericFormatBase_R,@TJclNumericFormatBase_W,'Base');
    RegisterPropertyHelper(@TJclNumericFormatPrecision_R,@TJclNumericFormatPrecision_W,'Precision');
    RegisterPropertyHelper(@TJclNumericFormatNumberOfFractionalDigits_R,@TJclNumericFormatNumberOfFractionalDigits_W,'NumberOfFractionalDigits');
    RegisterPropertyHelper(@TJclNumericFormatExponentDivision_R,@TJclNumericFormatExponentDivision_W,'ExponentDivision');
    RegisterPropertyHelper(@TJclNumericFormatDigitBlockSize_R,@TJclNumericFormatDigitBlockSize_W,'DigitBlockSize');
    RegisterPropertyHelper(@TJclNumericFormatDigitBlockSeparator_R,@TJclNumericFormatDigitBlockSeparator_W,'DigitBlockSeparator');
    RegisterPropertyHelper(@TJclNumericFormatFractionalPartSeparator_R,@TJclNumericFormatFractionalPartSeparator_W,'FractionalPartSeparator');
    RegisterPropertyHelper(@TJclNumericFormatMultiplier_R,@TJclNumericFormatMultiplier_W,'Multiplier');
    RegisterPropertyHelper(@TJclNumericFormatPaddingChar_R,@TJclNumericFormatPaddingChar_W,'PaddingChar');
    RegisterPropertyHelper(@TJclNumericFormatShowPositiveSign_R,@TJclNumericFormatShowPositiveSign_W,'ShowPositiveSign');
    RegisterPropertyHelper(@TJclNumericFormatWidth_R,@TJclNumericFormatWidth_W,'Width');
    RegisterPropertyHelper(@TJclNumericFormatNegativeSign_R,@TJclNumericFormatNegativeSign_W,'NegativeSign');
    RegisterPropertyHelper(@TJclNumericFormatPositiveSign_R,@TJclNumericFormatPositiveSign_W,'PositiveSign');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclReferenceMemoryStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclReferenceMemoryStream) do begin
    RegisterConstructor(@TJclReferenceMemoryStream.Create, 'Create');
            RegisterMethod(@TJclReferenceMemoryStream.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclSysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetAndFillMem, 'GetAndFillMem', cdRegister);
 S.RegisterDelphiFunction(@FreeMemAndNil, 'FreeMemAndNil', cdRegister);
 S.RegisterDelphiFunction(@PCharOrNil, 'PCharOrNil', cdRegister);
 {S.RegisterDelphiFunction(@PAnsiCharOrNil, 'PAnsiCharOrNil', cdRegister);
 S.RegisterDelphiFunction(@PWideCharOrNil, 'PWideCharOrNil', cdRegister);
 S.RegisterDelphiFunction(@SizeOfMem, 'SizeOfMem', cdRegister);
 S.RegisterDelphiFunction(@WriteProtectedMemory, 'WriteProtectedMemory', cdRegister);
 S.RegisterDelphiFunction(@SearchSortedList, 'SearchSortedList', cdRegister);
 S.RegisterDelphiFunction(@SearchSortedUntyped, 'SearchSortedUntyped', cdRegister);
 S.RegisterDelphiFunction(@SortDynArray, 'SortDynArray', cdRegister);
 S.RegisterDelphiFunction(@SearchDynArray, 'SearchDynArray', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareByte, 'DynArrayCompareByte', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareShortInt, 'DynArrayCompareShortInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareWord, 'DynArrayCompareWord', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareSmallInt, 'DynArrayCompareSmallInt', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareInteger, 'DynArrayCompareInteger', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareCardinal, 'DynArrayCompareCardinal', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareInt64, 'DynArrayCompareInt64', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareSingle, 'DynArrayCompareSingle', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareDouble, 'DynArrayCompareDouble', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareExtended, 'DynArrayCompareExtended', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareFloat, 'DynArrayCompareFloat', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareAnsiString, 'DynArrayCompareAnsiString', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareAnsiText, 'DynArrayCompareAnsiText', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareString, 'DynArrayCompareString', cdRegister);
 S.RegisterDelphiFunction(@DynArrayCompareText, 'DynArrayCompareText', cdRegister);
 S.RegisterDelphiFunction(@ClearObjectList, 'ClearObjectList', cdRegister);
 S.RegisterDelphiFunction(@FreeObjectList, 'FreeObjectList', cdRegister);  }
//  RIRegister_TJclReferenceMemoryStream(CL);
  //with CL.Add(EJclVMTError) do
 {S.RegisterDelphiFunction(@GetVirtualMethodCount, 'GetVirtualMethodCount', cdRegister);
 S.RegisterDelphiFunction(@GetVirtualMethod, 'GetVirtualMethod', cdRegister);
 S.RegisterDelphiFunction(@SetVirtualMethod, 'SetVirtualMethod', cdRegister);
 S.RegisterDelphiFunction(@GetDynamicMethodCount, 'GetDynamicMethodCount', cdRegister);
 S.RegisterDelphiFunction(@GetDynamicIndexList, 'GetDynamicIndexList', cdRegister);
 S.RegisterDelphiFunction(@GetDynamicAddressList, 'GetDynamicAddressList', cdRegister);
 S.RegisterDelphiFunction(@HasDynamicMethod, 'HasDynamicMethod', cdRegister);
 S.RegisterDelphiFunction(@GetDynamicMethod, 'GetDynamicMethod', cdRegister);
 S.RegisterDelphiFunction(@GetInitTable, 'GetInitTable', cdRegister);
 S.RegisterDelphiFunction(@GetFieldTable, 'GetFieldTable', cdRegister);
 S.RegisterDelphiFunction(@GetMethodTable, 'GetMethodTable', cdRegister);
 S.RegisterDelphiFunction(@GetMethodEntry, 'GetMethodEntry', cdRegister);
 S.RegisterDelphiFunction(@SetClassParent, 'SetClassParent', cdRegister);
 S.RegisterDelphiFunction(@GetClassParent, 'GetClassParent', cdRegister); }
 S.RegisterDelphiFunction(@IsClass, 'JIsClass', cdRegister);
 S.RegisterDelphiFunction(@IsObject, 'JIsObject', cdRegister);
 S.RegisterDelphiFunction(@GetImplementorOfInterface, 'GetImplementorOfInterface', cdRegister);
 // RIRegister_TJclNumericFormat(CL);
 S.RegisterDelphiFunction(@IntToStrZeroPad, 'JIntToStrZeroPad', cdRegister);
 S.RegisterDelphiFunction(@Execute_P, 'JExecute', cdRegister);
 S.RegisterDelphiFunction(@Execute1_P, 'JExecute1', cdRegister);
 S.RegisterDelphiFunction(@Execute1_P2, 'JExecute2', cdRegister);
 S.RegisterDelphiFunction(@Execute1_P3, 'JExecute3', cdRegister);
 S.RegisterDelphiFunction(@ReadKey, 'ReadKey', cdRegister);
 S.RegisterDelphiFunction(@LoadModule, 'LoadModule', cdRegister);
 S.RegisterDelphiFunction(@LoadModuleEx, 'LoadModuleEx', cdRegister);
 S.RegisterDelphiFunction(@UnloadModule, 'UnloadModule', cdRegister);
 S.RegisterDelphiFunction(@GetModuleSymbol, 'GetModuleSymbol', cdRegister);
 S.RegisterDelphiFunction(@GetModuleSymbolEx, 'GetModuleSymbolEx', cdRegister);
 S.RegisterDelphiFunction(@ReadModuleData, 'ReadModuleData', cdRegister);
 S.RegisterDelphiFunction(@WriteModuleData, 'WriteModuleData', cdRegister);
 // with CL.Add(EJclConversionError) do
 S.RegisterDelphiFunction(@StrToBoolean, 'JStrToBoolean', cdRegister);
 S.RegisterDelphiFunction(@BooleanToStr, 'JBooleanToStr', cdRegister);
 S.RegisterDelphiFunction(@IntToBool, 'JIntToBool', cdRegister);
 S.RegisterDelphiFunction(@BoolToInt, 'JBoolToInt', cdRegister);
 S.RegisterDelphiFunction(@ListAddItems, 'ListAddItems', cdRegister);
 S.RegisterDelphiFunction(@ListIncludeItems, 'ListIncludeItems', cdRegister);
 S.RegisterDelphiFunction(@ListRemoveItems, 'ListRemoveItems', cdRegister);
 S.RegisterDelphiFunction(@ListDelItem, 'ListDelItem', cdRegister);
 S.RegisterDelphiFunction(@ListItemCount, 'ListItemCount', cdRegister);
 S.RegisterDelphiFunction(@ListGetItem, 'ListGetItem', cdRegister);
 S.RegisterDelphiFunction(@ListSetItem, 'ListSetItem', cdRegister);
 S.RegisterDelphiFunction(@ListItemIndex, 'ListItemIndex', cdRegister);
 S.RegisterDelphiFunction(@SystemTObjectInstance, 'SystemTObjectInstance', cdRegister);
 S.RegisterDelphiFunction(@IsCompiledWithPackages, 'IsCompiledWithPackages', cdRegister);
 S.RegisterDelphiFunction(@JclGUIDToString, 'JJclGUIDToString', cdRegister);
 S.RegisterDelphiFunction(@JclStringToGUID, 'JJclStringToGUID', cdRegister);
  //RIRegister_TJclIntfCriticalSection(CL);
  //RIRegister_TJclSimpleLog(CL);
 S.RegisterDelphiFunction(@InitSimpleLog, 'InitSimpleLog', cdRegister);
end;

procedure RIRegister_JclSysUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclReferenceMemoryStream(CL);
  with CL.Add(EJclVMTError) do
  RIRegister_TJclNumericFormat(CL);
  with CL.Add(EJclConversionError) do
  RIRegister_TJclIntfCriticalSection(CL);
  RIRegister_TJclSimpleLog(CL);
 end;


{ TPSImport_JclSysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclSysUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclSysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclSysUtils(ri);
  RIRegister_JclSysUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
