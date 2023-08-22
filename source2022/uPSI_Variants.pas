unit uPSI_Variants;
{
  in win32/rtl/sys
    vararraycreate

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
  TPSImport_Variants = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IVarInstanceReference(CL: TPSPascalCompiler);
procedure SIRegister_TInvokeableVariantType(CL: TPSPascalCompiler);
procedure SIRegister_IVarInvokeable(CL: TPSPascalCompiler);
procedure SIRegister_TCustomVariantType(CL: TPSPascalCompiler);
procedure SIRegister_Variants(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TInvokeableVariantType(CL: TPSRuntimeClassImporter);
procedure RIRegister_TCustomVariantType(CL: TPSRuntimeClassImporter);
procedure RIRegister_Variants_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  ,Variants
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Variants]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IVarInstanceReference(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IVarInstanceReference') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IVarInstanceReference, 'IVarInstanceReference') do
  begin
    RegisterMethod('Function GetInstance( const V : TVarData) : TObject', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInvokeableVariantType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomVariantType', 'TInvokeableVariantType') do
  with CL.AddClassN(CL.FindClass('TCustomVariantType'),'TInvokeableVariantType') do begin
    RegisterMethod('Function DoFunction( var Dest : TVarData; const V : TVarData; const Name : string; const Arguments : TVarDataArray) : Boolean');
    RegisterMethod('Function DoProcedure( const V : TVarData; const Name : string; const Arguments : TVarDataArray) : Boolean');
    RegisterMethod('Function GetProperty( var Dest : TVarData; const V : TVarData; const Name : string) : Boolean');
    RegisterMethod('Function SetProperty( const V : TVarData; const Name : string; const Value : TVarData) : Boolean');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IVarInvokeable(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IVarInvokeable') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IVarInvokeable, 'IVarInvokeable') do begin
    RegisterMethod('Function DoFunction( var Dest : TVarData; const V : TVarData; const Name : string; const Arguments : TVarDataArray) : Boolean', cdRegister);
    RegisterMethod('Function DoProcedure( const V : TVarData; const Name : string; const Arguments : TVarDataArray) : Boolean', cdRegister);
    RegisterMethod('Function GetProperty( var Dest : TVarData; const V : TVarData; const Name : string) : Boolean', cdRegister);
    RegisterMethod('Function SetProperty( const V : TVarData; const Name : string; const Value : TVarData) : Boolean', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomVariantType(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCustomVariantType') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCustomVariantType') do begin
    RegisterMethod('Constructor Create;');
    RegisterMethod('Constructor Create1( RequestedVarType : TVarType);');
    RegisterProperty('VarType', 'TVarType', iptr);
    RegisterMethod('Function IsClear( const V : TVarData) : Boolean');
    RegisterMethod('Procedure Cast( var Dest : TVarData; const Source : TVarData)');
    RegisterMethod('Procedure CastTo( var Dest : TVarData; const Source : TVarData; const AVarType : TVarType)');
    RegisterMethod('Procedure CastToOle( var Dest : TVarData; const Source : TVarData)');
    RegisterMethod('Procedure Clear( var V : TVarData)');
    RegisterMethod('Procedure Copy( var Dest : TVarData; const Source : TVarData; const Indirect : Boolean)');
    RegisterMethod('Procedure BinaryOp( var Left : TVarData; const Right : TVarData; const Operator : TVarOp)');
    RegisterMethod('Procedure UnaryOp( var Right : TVarData; const Operator : TVarOp)');
    RegisterMethod('Function CompareOp( const Left, Right : TVarData; const Operator : TVarOp) : Boolean');
    RegisterMethod('Procedure Compare( const Left, Right : TVarData; var Relationship : TVarCompareResult)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Variants(CL: TPSPascalCompiler);
begin
  //TVarType = Word;
  // CL.AddTypeS('TVarType', 'Word');  in upscompiler!

  { TVarData = packed record
    case Integer of
      0: (VType: TVarType;
          case Integer of
            0: (Reserved1: Word;
                case Integer of
                  0: (Reserved2, Reserved3: Word;
                      case Integer of
                        varSmallInt: (VSmallInt: SmallInt);
                        varInteger:  (VInteger: Integer);
                        varSingle:   (VSingle: Single);
                        varDouble:   (VDouble: Double);
                        varCurrency: (VCurrency: Currency);
                        varDate:     (VDate: TDateTime);
                        varOleStr:   (VOleStr: PWideChar);
                        varDispatch: (VDispatch: Pointer);
                        varError:    (VError: HRESULT);
                        varBoolean:  (VBoolean: WordBool);
                        varUnknown:  (VUnknown: Pointer);
                        varShortInt: (VShortInt: ShortInt);
                        varByte:     (VByte: Byte);
                        varWord:     (VWord: Word);
                        varLongWord: (VLongWord: LongWord);
                        varInt64:    (VInt64: Int64);
                        varString:   (VString: Pointer);
                        varAny:      (VAny: Pointer);
                        varArray:    (VArray: PVarArray);
                        varByRef:    (VPointer: Pointer);
                     );
                  1: (VLongs: array[0..2] of LongInt);
               );
            2: (VWords: array [0..6] of Word);
            3: (VBytes: array [0..13] of Byte);
          );
      1: (RawData: array [0..3] of LongInt);}


 CL.AddTypeS('TVarData2', 'record vtype: tvartype; RawData: array [0..3] of LongInt; end;');
 CL.AddTypeS('TVarData3', 'record vtype: tvartype; end;');
 CL.AddTypeS('TVarData', 'record vtype: word; reserved1, reserved2, reserved3: word; varword: tvartype; end;');

 CL.AddDelphiFunction('Function VarType( const V : Variant) : TVarType');
 CL.AddDelphiFunction('Function VarAsType( const V : Variant; AVarType : TVarType) : Variant');
 CL.AddDelphiFunction('Function VarIsType( const V : Variant; AVarType : TVarType) : Boolean;');
 CL.AddDelphiFunction('Function VarIsType1( const V : Variant; const AVarTypes : array of TVarType) : Boolean;');
 CL.AddDelphiFunction('Function VarIsByRef( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarIsEmpty( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Procedure VarCheckEmpty( const V : Variant)');
 CL.AddDelphiFunction('Function VarIsNull( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarIsClear( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarIsCustom( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarIsOrdinal( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarIsFloat( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarIsNumeric( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarIsStr( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarToStr( const V : Variant) : string');
 CL.AddDelphiFunction('Function VarToStrDef( const V : Variant; const ADefault : string) : string');
 CL.AddDelphiFunction('Function VarToWideStr( const V : Variant) : WideString');
 CL.AddDelphiFunction('Function VarToWideStrDef( const V : Variant; const ADefault : WideString) : WideString');
 CL.AddDelphiFunction('Function VarToDateTime( const V : Variant) : TDateTime');
 CL.AddDelphiFunction('Function VarFromDateTime( const DateTime : TDateTime) : Variant');
 CL.AddDelphiFunction('Function VarInRange( const AValue, AMin, AMax : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarEnsureRange( const AValue, AMin, AMax : Variant) : Variant');
  CL.AddTypeS('TVariantRelationship', '( vrEqual, vrLessThan, vrGreaterThan, vrNotEqual )');
 CL.AddDelphiFunction('Function VarSameValue( const A, B : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarCompareValue( const A, B : Variant) : TVariantRelationship');
 CL.AddDelphiFunction('Function VarIsEmptyParam( const V : Variant) : Boolean');
 CL.AddDelphiFunction('Function VarIsError( const V : Variant; out AResult : HRESULT) : Boolean;');
 CL.AddDelphiFunction('Function VarIsError1( const V : Variant) : Boolean;');
 CL.AddDelphiFunction('Function VarAsError( AResult : HRESULT) : Variant');
// CL.AddDelphiFunction('Function VarSupports( const V : Variant; const IID : TGUID; out Intf) : Boolean;');
// CL.AddDelphiFunction('Function VarSupports1( const V : Variant; const IID : TGUID) : Boolean;');
 CL.AddDelphiFunction('Procedure VarCopyNoInd( var Dest : Variant; const Source : Variant)');
 CL.AddDelphiFunction('Function VarIsArray( const A : Variant) : Boolean;');
 CL.AddDelphiFunction('Function VarIsArray1( const A : Variant; AResolveByRef : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function VarArrayCreate(const Bounds : array of Integer; AVarType : TVarType): Variant;');
 CL.AddDelphiFunction('Function VarArrayOf( const Values : array of Variant) : Variant');
 CL.AddDelphiFunction('Function VarArrayRef( const A : Variant) : Variant');
 CL.AddDelphiFunction('Function VarTypeIsValidArrayType( const AVarType : TVarType) : Boolean');
 CL.AddDelphiFunction('Function VarTypeIsValidElementType( const AVarType : TVarType) : Boolean');
 CL.AddDelphiFunction('Function VarArrayDimCount( const A : Variant) : Integer');
 CL.AddDelphiFunction('Function VarArrayLowBound( const A : Variant; Dim : Integer) : Integer');
 CL.AddDelphiFunction('Function VarArrayHighBound( const A : Variant; Dim : Integer) : Integer');
 CL.AddDelphiFunction('Function VarArrayLock( const A : Variant) : ___Pointer');
 CL.AddDelphiFunction('Procedure VarArrayUnlock( const A : Variant)');
 //CL.AddDelphiFunction('Function VarArrayAsPSafeArray( const A : Variant) : PVarArray');
 CL.AddDelphiFunction('Function VarArrayGet( const A : Variant; const Indices : array of Integer) : Variant;');
 CL.AddDelphiFunction('Procedure VarArrayPut( var A : Variant; const Value : Variant; const Indices : array of Integer)');
 CL.AddDelphiFunction('Procedure DynArrayToVariant( var V : Variant; const DynArray : ___Pointer; TypeInfo : ___Pointer)');
 CL.AddDelphiFunction('Procedure DynArrayFromVariant( var DynArray : ___Pointer; const V : Variant; TypeInfo : ___Pointer)');
 CL.AddDelphiFunction('Function Unassigned : Variant');
 CL.AddDelphiFunction('Function Null : Variant');
  CL.AddTypeS('TVarCompareResult', '( crLessThan, crEqual, crGreaterThan )');
  SIRegister_TCustomVariantType(CL);
  //CL.AddTypeS('TCustomVariantTypeClass', 'class of TCustomVariantType');
  CL.AddTypeS('TVarDataArray', 'array of TVarData');
  SIRegister_IVarInvokeable(CL);
  SIRegister_TInvokeableVariantType(CL);
  SIRegister_IVarInstanceReference(CL);
 CL.AddDelphiFunction('Function FindCustomVariantType( const AVarType : TVarType; out CustomVariantType : TCustomVariantType) : Boolean;');
 CL.AddDelphiFunction('Function FindCustomVariantType1( const TypeName : string; out CustomVariantType : TCustomVariantType) : Boolean;');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantInvalidOpError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantTypeCastError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantOverflowError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantInvalidArgError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantBadVarTypeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantBadIndexError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantArrayLockedError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantNotAnArrayError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantArrayCreateError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantNotImplError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantOutOfMemoryError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantUnexpectedError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantDispatchError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantRangeCheckError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantInvalidNullOpError');
 CL.AddDelphiFunction('Procedure VarCastError;');
 CL.AddDelphiFunction('Procedure VarCastError1( const ASourceType, ADestType : TVarType);');
 CL.AddDelphiFunction('Procedure VarInvalidOp');
 CL.AddDelphiFunction('Procedure VarInvalidNullOp');
 CL.AddDelphiFunction('Procedure VarOverflowError( const ASourceType, ADestType : TVarType)');
 CL.AddDelphiFunction('Procedure VarRangeCheckError( const ASourceType, ADestType : TVarType)');
 CL.AddDelphiFunction('Procedure VarArrayCreateError');
 CL.AddDelphiFunction('Procedure VarResultCheck( AResult : HRESULT);');
 CL.AddDelphiFunction('Procedure VarResultCheck1( AResult : HRESULT; ASourceType, ADestType : TVarType);');
 CL.AddDelphiFunction('Procedure HandleConversionException( const ASourceType, ADestType : TVarType)');
 CL.AddDelphiFunction('Function VarTypeAsText( const AType : TVarType) : string');
 //CL.AddDelphiFunction('Function FindVarData( const V : Variant) : PVarData');
  CL.AddTypeS('TNullCompareRule', '( ncrError, ncrStrict, ncrLoose )');
  CL.AddTypeS('TBooleanToStringRule', '( bsrAsIs, bsrLower, bsrUpper )');
 CL.AddDelphiFunction('Procedure _VarClear( var V : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCopy( var Dest : TVarData; const Source : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCopyNoInd( var Dest : TVarData; const Source : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCast( var Dest : TVarData; const Source : TVarData; AVarType : Integer)');
 CL.AddDelphiFunction('Procedure VarCast( var Dest : TVarData; const Source : TVarData; AVarType : Integer)');
 //CL.AddDelphiFunction('Procedure VarCopy( var Dest : TVarData; const Source : TVarData)');

 CL.AddDelphiFunction('Procedure _VarCastOle( var Dest : TVarData; const Source : TVarData; AVarType : Integer)');
 CL.AddDelphiFunction('Procedure _VarClr( var V : TVarData)');
 CL.AddDelphiFunction('Function _VarToInteger( const V : TVarData) : Integer');
 CL.AddDelphiFunction('Function _VarToInt64( const V : TVarData) : Int64');
 CL.AddDelphiFunction('Function _VarToBool( const V : TVarData) : LongBool');
 CL.AddDelphiFunction('Function _VarToReal( const V : TVarData) : Extended');
 CL.AddDelphiFunction('Function _VarToCurrency( const V : TVarData) : Currency');
 CL.AddDelphiFunction('Procedure _VarToLStr( var S : string; const V : TVarData)');
 CL.AddDelphiFunction('Procedure _VarToWStr( var S : WideString; const V : TVarData)');
 CL.AddDelphiFunction('Procedure _VarToIntf( var Intf : IInterface; const V : TVarData)');
 CL.AddDelphiFunction('Procedure _VarToDisp( var Dispatch : IDispatch; const V : TVarData)');
// CL.AddDelphiFunction('Procedure _VarToDynArray( var DynArray : Pointer; const V : TVarData; TypeInfo : Pointer)');
 CL.AddDelphiFunction('Procedure _VarFromInt( var V : TVarData; const Value : Integer; const Range : ShortInt)');
 CL.AddDelphiFunction('Procedure _VarFromInt64( var V : TVarData; const Value : Int64)');
 CL.AddDelphiFunction('Procedure _VarFromBool( var V : TVarData; const Value : Boolean)');
 CL.AddDelphiFunction('Procedure _VarFromReal');
 CL.AddDelphiFunction('Procedure _VarFromTDateTime');
 CL.AddDelphiFunction('Procedure _VarFromCurr');
 CL.AddDelphiFunction('Procedure _VarFromPStr( var V : TVarData; const Value : ShortString)');
 CL.AddDelphiFunction('Procedure _VarFromLStr( var V : TVarData; const Value : string)');
 CL.AddDelphiFunction('Procedure _VarFromWStr( var V : TVarData; const Value : WideString)');
 CL.AddDelphiFunction('Procedure _VarFromIntf( var V : TVarData; const Value : IInterface)');
 CL.AddDelphiFunction('Procedure _VarFromDisp( var V : TVarData; const Value : IDispatch)');
 //CL.//AddDelphiFunction('Procedure _VarFromDynArray( var V : TVarData; const DynArray : Pointer; TypeInfo : Pointer)');
 CL.AddDelphiFunction('Procedure _OleVarFromPStr( var V : TVarData; const Value : ShortString)');
 CL.AddDelphiFunction('Procedure _OleVarFromLStr( var V : TVarData; const Value : string)');
 CL.AddDelphiFunction('Procedure _OleVarFromVar( var Dest : TVarData; const Source : TVarData)');
 CL.AddDelphiFunction('Procedure _OleVarFromInt( var V : TVarData; const Value : Integer; const Range : ShortInt)');
 CL.AddDelphiFunction('Procedure _OleVarFromInt64( var V : TVarData; const Value : Int64)');
 CL.AddDelphiFunction('Procedure _VarAdd( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarSub( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarMul( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarDiv( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarMod( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarAnd( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarOr( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarXor( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarShl( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarShr( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarRDiv( var Left : TVarData; const Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCmpEQ( const Left, Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCmpNE( const Left, Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCmpLT( const Left, Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCmpLE( const Left, Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCmpGT( const Left, Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarCmpGE( const Left, Right : TVarData)');
 CL.AddDelphiFunction('Procedure _VarNeg( var Dest : TVarData)');
 CL.AddDelphiFunction('Procedure _VarNot( var Dest : TVarData)');
 //CL.AddDelphiFunction('Procedure _DispInvoke( Dest : PVarData; const Source : TVarData; CallDesc : PCallDesc; Params : Pointer)');
 CL.AddDelphiFunction('Procedure _VarAddRef( var V : TVarData)');
 CL.AddDelphiFunction('Procedure _VarArrayRedim( var A : TVarData; HighBound : Integer)');
// CL.AddDelphiFunction('Function _VarArrayGet( var A : TVarData; IndexCount : Integer; const Indices : TVarArrayCoorArray) : TVarData');
// CL.AddDelphiFunction('Procedure _VarArrayPut( var A : TVarData; const Value : TVarData; IndexCount : Integer; const Indices : TVarArrayCoorArray)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure VarResultCheck1_P( AResult : HRESULT; ASourceType, ADestType : TVarType);
Begin Variants.VarResultCheck(AResult, ASourceType, ADestType); END;

(*----------------------------------------------------------------------------*)
Procedure VarResultCheck_P( AResult : HRESULT);
Begin Variants.VarResultCheck(AResult); END;

(*----------------------------------------------------------------------------*)
Procedure VarCastError1_P( const ASourceType, ADestType : TVarType);
Begin Variants.VarCastError(ASourceType, ADestType); END;

(*----------------------------------------------------------------------------*)
Procedure VarCastError_P;
Begin Variants.VarCastError; END;

(*----------------------------------------------------------------------------*)
Function FindCustomVariantType1_P( const TypeName : string; out CustomVariantType : TCustomVariantType) : Boolean;
Begin Result := Variants.FindCustomVariantType(TypeName, CustomVariantType); END;

(*----------------------------------------------------------------------------*)
Function FindCustomVariantType_P( const AVarType : TVarType; out CustomVariantType : TCustomVariantType) : Boolean;
Begin Result := Variants.FindCustomVariantType(AVarType, CustomVariantType); END;

(*----------------------------------------------------------------------------*)
procedure TCustomVariantTypeVarType_R(Self: TCustomVariantType; var T: TVarType);
begin T := Self.VarType; end;

(*----------------------------------------------------------------------------*)
Function TCustomVariantTypeCreate1_P(Self: TClass; CreateNewInstance: Boolean;  RequestedVarType : TVarType):TObject;
Begin Result := TCustomVariantType.Create(RequestedVarType); END;

(*----------------------------------------------------------------------------*)
Function TCustomVariantTypeCreate_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TCustomVariantType.Create; END;

(*----------------------------------------------------------------------------*)
Procedure TCustomVariantTypeVarDataCastTo1_P(Self: TCustomVariantType;  var Dest : TVarData; const AVarType : TVarType);
Begin
  //Self.VarDataCastTo(Dest, AVarType);
END;

(*----------------------------------------------------------------------------*)
Procedure TCustomVariantTypeVarDataCastTo_P(Self: TCustomVariantType;  var Dest : TVarData; const Source : TVarData; const AVarType : TVarType);
Begin
  //Self.VarDataCastTo(Dest, Source, AVarType);
END;

(*----------------------------------------------------------------------------*)
Function VarIsArray1_P( const A : Variant; AResolveByRef : Boolean) : Boolean;
Begin Result := Variants.VarIsArray(A, AResolveByRef); END;

(*----------------------------------------------------------------------------*)
Function VarIsArray_P( const A : Variant) : Boolean;
Begin Result := Variants.VarIsArray(A); END;

(*----------------------------------------------------------------------------*)
Function VarSupports1_P( const V : Variant; const IID : TGUID) : Boolean;
Begin Result := Variants.VarSupports(V, IID); END;

(*----------------------------------------------------------------------------*)
Function VarSupports_P( const V : Variant; const IID : TGUID; out Intf) : Boolean;
Begin Result := Variants.VarSupports(V, IID, Intf); END;

(*----------------------------------------------------------------------------*)
Function VarIsError1_P( const V : Variant) : Boolean;
Begin Result := Variants.VarIsError(V); END;

(*----------------------------------------------------------------------------*)
Function VarIsError_P( const V : Variant; out AResult : HRESULT) : Boolean;
Begin Result := Variants.VarIsError(V, AResult); END;

(*----------------------------------------------------------------------------*)
Function VarIsType1_P( const V : Variant; const AVarTypes : array of TVarType) : Boolean;
Begin Result := Variants.VarIsType(V, AVarTypes); END;

(*----------------------------------------------------------------------------*)
Function VarIsType_P( const V : Variant; AVarType : TVarType) : Boolean;
Begin Result := Variants.VarIsType(V, AVarType); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInvokeableVariantType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInvokeableVariantType) do begin
    RegisterVirtualMethod(@TInvokeableVariantType.DoFunction, 'DoFunction');
    RegisterVirtualMethod(@TInvokeableVariantType.DoProcedure, 'DoProcedure');
    RegisterVirtualMethod(@TInvokeableVariantType.GetProperty, 'GetProperty');
    RegisterVirtualMethod(@TInvokeableVariantType.SetProperty, 'SetProperty');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomVariantType(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TCustomVariantType) do begin
    RegisterConstructor(@TCustomVariantTypeCreate_P, 'Create');
    RegisterConstructor(@TCustomVariantTypeCreate1_P, 'Create1');
    RegisterPropertyHelper(@TCustomVariantTypeVarType_R,nil,'VarType');
    RegisterVirtualMethod(@TCustomVariantType.IsClear, 'IsClear');
    RegisterVirtualMethod(@TCustomVariantType.Cast, 'Cast');
    RegisterVirtualMethod(@TCustomVariantType.CastTo, 'CastTo');
    RegisterVirtualMethod(@TCustomVariantType.CastToOle, 'CastToOle');
    //RegisterVirtualAbstractMethod(@TCustomVariantType, @!.Clear, 'Clear');
    //RegisterVirtualAbstractMethod(@TCustomVariantType, @!.Copy, 'Copy');
    RegisterVirtualMethod(@TCustomVariantType.BinaryOp, 'BinaryOp');
    RegisterVirtualMethod(@TCustomVariantType.UnaryOp, 'UnaryOp');
    RegisterVirtualMethod(@TCustomVariantType.CompareOp, 'CompareOp');
    RegisterVirtualMethod(@TCustomVariantType.Compare, 'Compare');
  end;
   RIRegister_TCustomVariantType(CL);
  RIRegister_TInvokeableVariantType(CL);
    with CL.Add(EVariantInvalidOpError) do
  with CL.Add(EVariantTypeCastError) do
  with CL.Add(EVariantOverflowError) do
  with CL.Add(EVariantInvalidArgError) do
  with CL.Add(EVariantBadVarTypeError) do
  with CL.Add(EVariantBadIndexError) do
  with CL.Add(EVariantArrayLockedError) do
  with CL.Add(EVariantNotAnArrayError) do
  with CL.Add(EVariantArrayCreateError) do
  with CL.Add(EVariantNotImplError) do
  with CL.Add(EVariantOutOfMemoryError) do
  with CL.Add(EVariantUnexpectedError) do
  with CL.Add(EVariantDispatchError) do
  with CL.Add(EVariantRangeCheckError) do
  with CL.Add(EVariantInvalidNullOpError) do


end;

procedure myvarClear(var aV : TVarData);
begin
  //varClear(TVarData(aV));
end;

procedure myvarCopy(var Dest: TVarData; const Source: TVarData);
begin
  //_VarCopy(Dest, Source);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Variants_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@VarType, 'VarType', cdRegister);
 S.RegisterDelphiFunction(@VarAsType, 'VarAsType', cdRegister);
 S.RegisterDelphiFunction(@VarIsType, 'VarIsType', cdRegister);
 S.RegisterDelphiFunction(@VarIsType1_P, 'VarIsType1', cdRegister);
 S.RegisterDelphiFunction(@VarIsByRef, 'VarIsByRef', cdRegister);
 S.RegisterDelphiFunction(@VarIsEmpty, 'VarIsEmpty', cdRegister);
 S.RegisterDelphiFunction(@VarCheckEmpty, 'VarCheckEmpty', cdRegister);
 S.RegisterDelphiFunction(@VarIsNull, 'VarIsNull', cdRegister);
 S.RegisterDelphiFunction(@VarIsClear, 'VarIsClear', cdRegister);
 S.RegisterDelphiFunction(@VarIsCustom, 'VarIsCustom', cdRegister);
 S.RegisterDelphiFunction(@VarIsOrdinal, 'VarIsOrdinal', cdRegister);
 S.RegisterDelphiFunction(@VarIsFloat, 'VarIsFloat', cdRegister);
 S.RegisterDelphiFunction(@VarIsNumeric, 'VarIsNumeric', cdRegister);
 S.RegisterDelphiFunction(@VarIsStr, 'VarIsStr', cdRegister);
 S.RegisterDelphiFunction(@VarToStr, 'VarToStr', cdRegister);
 S.RegisterDelphiFunction(@VarToStrDef, 'VarToStrDef', cdRegister);
 S.RegisterDelphiFunction(@VarToWideStr, 'VarToWideStr', cdRegister);
 S.RegisterDelphiFunction(@VarToWideStrDef, 'VarToWideStrDef', cdRegister);
 S.RegisterDelphiFunction(@VarToDateTime, 'VarToDateTime', cdRegister);
 S.RegisterDelphiFunction(@VarFromDateTime, 'VarFromDateTime', cdRegister);
 S.RegisterDelphiFunction(@VarInRange, 'VarInRange', cdRegister);
 S.RegisterDelphiFunction(@VarEnsureRange, 'VarEnsureRange', cdRegister);
 S.RegisterDelphiFunction(@VarSameValue, 'VarSameValue', cdRegister);
 S.RegisterDelphiFunction(@VarCompareValue, 'VarCompareValue', cdRegister);
 S.RegisterDelphiFunction(@VarIsEmptyParam, 'VarIsEmptyParam', cdRegister);
 S.RegisterDelphiFunction(@VarIsError, 'VarIsError', cdRegister);
 S.RegisterDelphiFunction(@VarIsError1_P, 'VarIsError1', cdRegister);
 S.RegisterDelphiFunction(@VarAsError, 'VarAsError', cdRegister);
 S.RegisterDelphiFunction(@VarSupports, 'VarSupports', cdRegister);
 S.RegisterDelphiFunction(@VarSupports1_P, 'VarSupports1', cdRegister);
 S.RegisterDelphiFunction(@VarCopyNoInd, 'VarCopyNoInd', cdRegister);
 S.RegisterDelphiFunction(@VarIsArray, 'VarIsArray', cdRegister);
 S.RegisterDelphiFunction(@VarIsArray1_P, 'VarIsArray1', cdRegister);
 S.RegisterDelphiFunction(@VarArrayCreate, 'VarArrayCreate', cdRegister);
 S.RegisterDelphiFunction(@VarArrayOf, 'VarArrayOf', cdRegister);
 S.RegisterDelphiFunction(@VarArrayRef, 'VarArrayRef', cdRegister);
 S.RegisterDelphiFunction(@VarTypeIsValidArrayType, 'VarTypeIsValidArrayType', cdRegister);
 S.RegisterDelphiFunction(@VarTypeIsValidElementType, 'VarTypeIsValidElementType', cdRegister);
 S.RegisterDelphiFunction(@VarArrayDimCount, 'VarArrayDimCount', cdRegister);
 S.RegisterDelphiFunction(@VarArrayLowBound, 'VarArrayLowBound', cdRegister);
 S.RegisterDelphiFunction(@VarArrayHighBound, 'VarArrayHighBound', cdRegister);
 S.RegisterDelphiFunction(@VarArrayLock, 'VarArrayLock', cdRegister);
 S.RegisterDelphiFunction(@VarArrayUnlock, 'VarArrayUnlock', cdRegister);
 S.RegisterDelphiFunction(@VarArrayAsPSafeArray, 'VarArrayAsPSafeArray', cdRegister);
 S.RegisterDelphiFunction(@VarArrayGet, 'VarArrayGet', cdRegister);
 S.RegisterDelphiFunction(@VarArrayPut, 'VarArrayPut', cdRegister);
 S.RegisterDelphiFunction(@DynArrayToVariant, 'DynArrayToVariant', cdRegister);
 S.RegisterDelphiFunction(@DynArrayFromVariant, 'DynArrayFromVariant', cdRegister);
 S.RegisterDelphiFunction(@Unassigned, 'Unassigned', cdRegister);
 S.RegisterDelphiFunction(@Null, 'Null', cdRegister);
 // RIRegister_TCustomVariantType(CL);
 // RIRegister_TInvokeableVariantType(CL);
 S.RegisterDelphiFunction(@FindCustomVariantType, 'FindCustomVariantType', cdRegister);
 S.RegisterDelphiFunction(@FindCustomVariantType1_P, 'FindCustomVariantType1', cdRegister);
 S.RegisterDelphiFunction(@VarCastError, 'VarCastError', cdRegister);
 S.RegisterDelphiFunction(@VarCastError1_P, 'VarCastError1', cdRegister);
 S.RegisterDelphiFunction(@VarInvalidOp, 'VarInvalidOp', cdRegister);
 S.RegisterDelphiFunction(@VarInvalidNullOp, 'VarInvalidNullOp', cdRegister);
 S.RegisterDelphiFunction(@VarOverflowError, 'VarOverflowError', cdRegister);
 S.RegisterDelphiFunction(@VarRangeCheckError, 'VarRangeCheckError', cdRegister);
 S.RegisterDelphiFunction(@VarArrayCreateError, 'VarArrayCreateError', cdRegister);
 S.RegisterDelphiFunction(@VarResultCheck, 'VarResultCheck', cdRegister);
 S.RegisterDelphiFunction(@VarResultCheck1_P, 'VarResultCheck1', cdRegister);
 S.RegisterDelphiFunction(@HandleConversionException, 'HandleConversionException', cdRegister);
 S.RegisterDelphiFunction(@VarTypeAsText, 'VarTypeAsText', cdRegister);
 S.RegisterDelphiFunction(@FindVarData, 'FindVarData', cdRegister);
 S.RegisterDelphiFunction(@myVarClear, '_VarClear', cdRegister);
 //S.RegisterDelphiFunction(@myVarCopy, 'VarCopy', cdRegister);
 //S.RegisterDelphiFunction(@_VarCopyNoInd, '_VarCopyNoInd', cdRegister);

 (*S.RegisterDelphiFunction(@_VarCopy, '_VarCopy', cdRegister);
 S.RegisterDelphiFunction(@_VarCopyNoInd, '_VarCopyNoInd', cdRegister);
 S.RegisterDelphiFunction(@_VarCast, '_VarCast', cdRegister);
 S.RegisterDelphiFunction(@_VarCastOle, '_VarCastOle', cdRegister);
 S.RegisterDelphiFunction(@_VarClr, '_VarClr', cdRegister);
 S.RegisterDelphiFunction(@_VarToInteger, '_VarToInteger', cdRegister);
 S.RegisterDelphiFunction(@_VarToInt64, '_VarToInt64', cdRegister);
 S.RegisterDelphiFunction(@_VarToBool, '_VarToBool', cdRegister);
 S.RegisterDelphiFunction(@_VarToReal, '_VarToReal', cdRegister);
 S.RegisterDelphiFunction(@_VarToCurrency, '_VarToCurrency', cdRegister);
 S.RegisterDelphiFunction(@_VarToLStr, '_VarToLStr', cdRegister);
 S.RegisterDelphiFunction(@_VarToWStr, '_VarToWStr', cdRegister);
 S.RegisterDelphiFunction(@_VarToIntf, '_VarToIntf', cdRegister);
 S.RegisterDelphiFunction(@_VarToDisp, '_VarToDisp', cdRegister);
 S.RegisterDelphiFunction(@_VarToDynArray, '_VarToDynArray', cdRegister);
 S.RegisterDelphiFunction(@_VarFromInt, '_VarFromInt', cdRegister);
 S.RegisterDelphiFunction(@_VarFromInt64, '_VarFromInt64', cdRegister);
 S.RegisterDelphiFunction(@_VarFromBool, '_VarFromBool', cdRegister);
 S.RegisterDelphiFunction(@_VarFromReal, '_VarFromReal', cdRegister);
 S.RegisterDelphiFunction(@_VarFromTDateTime, '_VarFromTDateTime', cdRegister);
 S.RegisterDelphiFunction(@_VarFromCurr, '_VarFromCurr', cdRegister);
 S.RegisterDelphiFunction(@_VarFromPStr, '_VarFromPStr', cdRegister);
 S.RegisterDelphiFunction(@_VarFromLStr, '_VarFromLStr', cdRegister);
 S.RegisterDelphiFunction(@_VarFromWStr, '_VarFromWStr', cdRegister);
 S.RegisterDelphiFunction(@_VarFromIntf, '_VarFromIntf', cdRegister);
 S.RegisterDelphiFunction(@_VarFromDisp, '_VarFromDisp', cdRegister);
 S.RegisterDelphiFunction(@_VarFromDynArray, '_VarFromDynArray', cdRegister);
 S.RegisterDelphiFunction(@_OleVarFromPStr, '_OleVarFromPStr', cdRegister);
 S.RegisterDelphiFunction(@_OleVarFromLStr, '_OleVarFromLStr', cdRegister);
 S.RegisterDelphiFunction(@_OleVarFromVar, '_OleVarFromVar', cdRegister);
 S.RegisterDelphiFunction(@_OleVarFromInt, '_OleVarFromInt', cdRegister);
 S.RegisterDelphiFunction(@_OleVarFromInt64, '_OleVarFromInt64', cdRegister);
 S.RegisterDelphiFunction(@_VarAdd, '_VarAdd', cdRegister);
 S.RegisterDelphiFunction(@_VarSub, '_VarSub', cdRegister);
 S.RegisterDelphiFunction(@_VarMul, '_VarMul', cdRegister);
 S.RegisterDelphiFunction(@_VarDiv, '_VarDiv', cdRegister);
 S.RegisterDelphiFunction(@_VarMod, '_VarMod', cdRegister);
 S.RegisterDelphiFunction(@_VarAnd, '_VarAnd', cdRegister);
 S.RegisterDelphiFunction(@_VarOr, '_VarOr', cdRegister);
 S.RegisterDelphiFunction(@_VarXor, '_VarXor', cdRegister);
 S.RegisterDelphiFunction(@_VarShl, '_VarShl', cdRegister);
 S.RegisterDelphiFunction(@_VarShr, '_VarShr', cdRegister);
 S.RegisterDelphiFunction(@_VarRDiv, '_VarRDiv', cdRegister);
 S.RegisterDelphiFunction(@_VarCmpEQ, '_VarCmpEQ', cdRegister);
 S.RegisterDelphiFunction(@_VarCmpNE, '_VarCmpNE', cdRegister);
 S.RegisterDelphiFunction(@_VarCmpLT, '_VarCmpLT', cdRegister);
 S.RegisterDelphiFunction(@_VarCmpLE, '_VarCmpLE', cdRegister);
 S.RegisterDelphiFunction(@_VarCmpGT, '_VarCmpGT', cdRegister);
 S.RegisterDelphiFunction(@_VarCmpGE, '_VarCmpGE', cdRegister);
 S.RegisterDelphiFunction(@_VarNeg, '_VarNeg', cdRegister);
 S.RegisterDelphiFunction(@_VarNot, '_VarNot', cdRegister);
 S.RegisterDelphiFunction(@_DispInvoke, '_DispInvoke', CdCdecl);
 S.RegisterDelphiFunction(@_VarAddRef, '_VarAddRef', cdRegister);
 S.RegisterDelphiFunction(@_VarArrayRedim, '_VarArrayRedim', cdRegister);
 S.RegisterDelphiFunction(@_VarArrayGet, '_VarArrayGet', CdCdecl);
 S.RegisterDelphiFunction(@_VarArrayPut, '_VarArrayPut', CdCdecl);*)
end;



{ TPSImport_Variants }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Variants.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Variants(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Variants.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Variants_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
