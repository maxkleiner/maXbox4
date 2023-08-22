unit uPSI_DelticsSysUtils;
{
the last for the past  - with delt prefix

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
  TPSImport_DelticsSysUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_ENotImplemented(CL: TPSPascalCompiler);
procedure SIRegister_IAutoFree(CL: TPSPascalCompiler);
procedure SIRegister_DelticsSysUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DelticsSysUtils_Routines(S: TPSExec);
procedure RIRegister_ENotImplemented(CL: TPSRuntimeClassImporter);
procedure RIRegister_DelticsSysUtils(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   TlHelp32
  //,DelticsStrings
  //,DelticsTypes
  ,DelticsSysUtils
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DelticsSysUtils]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_ENotImplemented(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'ENotImplemented') do
  with CL.AddClassN(CL.FindClass('Exception'),'ENotImplemented') do
  begin
    RegisterMethod('Constructor Create( const aClass : TClass; const aSignature : String);');
    RegisterMethod('Constructor Create1( const aObject : TObject; const aSignature : String);');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IAutoFree(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUNKNOWN', 'IAutoFree') do
  with CL.AddInterface(CL.FindInterface('IUNKNOWN'),IAutoFree, 'IAutoFree') do
  begin
    RegisterMethod('Procedure Add( const aReferences : array of PObject);', cdRegister);
    RegisterMethod('Procedure Add1( const aObjects : array of TObject);', cdRegister);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DelticsSysUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('delticsEmptyStr','String').SetString( '');
 CL.AddConstantN('NullGUID','string').SetString( '{00000000-0000-0000-0000-000000000000}');
  SIRegister_IAutoFree(CL);
  //CL.AddTypeS('Exception', 'Exception');
  SIRegister_ENotImplemented(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAccessDenied');
  CL.AddTypeS('TGUIDFormat', '( gfDefault, gfNoBraces, gfNoHyphens, gfDigitsOnly )');
  CL.AddTypeS('TRoundingStrategy', '( rsDefault, rsAwayFromZero, rsTowardsZero )');
  CL.AddTypeS('TriBoolean', '( tbUnknown, tbTRUE, tbFALSE )');
 CL.AddDelphiFunction('Procedure deltCloneList( const aSource : TStringList; const aDest : TStringList)');
 //CL.AddDelphiFunction('Function AutoFree( const aReference : PObject) : IUnknown;');
 //CL.AddDelphiFunction('Function AutoFree5( const aReferences : array of PObject) : IUnknown;');
 CL.AddDelphiFunction('Procedure deltFreeAndNIL( var aObject: Tstrings);');
 //CL.AddDelphiFunction('Procedure NILRefs( const aObjects : array of PObject)');
 CL.AddDelphiFunction('Function deltIfThen7( aValue : Boolean; aTrue, aFalse : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function deltIfThen8( aValue : Boolean; aTrue, aFalse : TObject) : TObject;');
 CL.AddDelphiFunction('Function deltIfThen9( aValue : Boolean; aTrue, aFalse : Integer) : Integer;');
 CL.AddDelphiFunction('Function deltIfThen10( aValue : Boolean; aTrue, aFalse : ANSIString) : ANSIString;');
 CL.AddDelphiFunction('Function deltIfThen11( aValue : Boolean; aTrue, aFalse : String) : String;');
 CL.AddDelphiFunction('Function deltIfThenInt( aValue : Boolean; aTrue, aFalse : Integer) : Integer');
 CL.AddDelphiFunction('Function deltStringIndex( const aString : String; const aCases : array of String) : Integer');
 CL.AddDelphiFunction('Function deltTextIndex( const aString : String; const aCases : array of String) : Integer');
 CL.AddDelphiFunction('Function deltMin64( ValueA, ValueB : Int64) : Int64');
 CL.AddDelphiFunction('Function deltMin12( ValueA, ValueB : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function deltMin13( ValueA, ValueB : Integer) : Integer;');
 CL.AddDelphiFunction('Function deltMax64( ValueA, ValueB : Int64) : Int64');
 CL.AddDelphiFunction('Function deltMax14( ValueA, ValueB : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function deltMax15( ValueA, ValueB : Integer) : Integer;');
 CL.AddDelphiFunction('Procedure deltExchange( var A, B, aSize : LongWord)');
 CL.AddDelphiFunction('Function deltGUIDToString( const aGUID : TGUID; const aFormat : TGUIDFormat) : String');
 CL.AddDelphiFunction('Function deltStringToGUID( const aString : String) : TGUID');
 CL.AddDelphiFunction('Function deltTryStringToGUID( const aString : String; var aGUID : TGUID) : Boolean');
 CL.AddDelphiFunction('Function deltIsNull( const aValue : TGUID) : Boolean');
 CL.AddDelphiFunction('Function deltNewGUID : TGUID');
 CL.AddDelphiFunction('Function deltSameGUID( const GUIDA, GUIDB : TGUID) : Boolean');
 CL.AddDelphiFunction('Procedure deltAddTrailingBackslash( var aString : String)');
 CL.AddDelphiFunction('Procedure deltRemoveTrailingBackslash( var aString : String)');
 CL.AddDelphiFunction('Function deltBinToHex( const aBuf : string; const aSize : Integer) : String');
 CL.AddDelphiFunction('Function deltReverseBytes16( const aValue : Word) : Word;');
 CL.AddDelphiFunction('Function deltReverseBytes17( const aValue : LongWord) : LongWord;');
 CL.AddDelphiFunction('Function deltReverseBytes18( const aValue : Int64) : Int64;');
 CL.AddDelphiFunction('Function deltRound( const aValue : Extended; const aStrategy : TRoundingStrategy) : Integer');
 //CL.AddDelphiFunction('Procedure ForEachComponent( const aComponent : TComponent; const aProc : TComponentProc; const aRecursive : Boolean; const aClass : TComponentClass)');
 CL.AddDelphiFunction('Function deltExec( const aEXE : String; const aCommandLine : String) : Cardinal');
 CL.AddDelphiFunction('Procedure deltExecAndWait( const aEXE : String; const aCommandLine : String)');
 CL.AddDelphiFunction('Function deltFindProcess( const aEXEName : String; var aProcess : TProcessEntry32) : Boolean');
 CL.AddDelphiFunction('Function deltProcessExists( const aEXEName : String) : Boolean');
 CL.AddDelphiFunction('Function deltRegisterDLL( const aFileName : String; const aRegistrationProc : String) : Boolean');
 CL.AddDelphiFunction('Function deltIsTRUE( const aTri : TriBoolean) : Boolean');
 CL.AddDelphiFunction('Function deltIsFALSE( const aTri : TriBoolean) : Boolean');
 CL.AddDelphiFunction('Function deltIsKnown( const aTri : TriBoolean) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function ReverseBytes18_P( const aValue : Int64) : Int64;
Begin Result := DelticsSysUtils.ReverseBytes(aValue); END;

(*----------------------------------------------------------------------------*)
Function ReverseBytes17_P( const aValue : LongWord) : LongWord;
Begin Result := DelticsSysUtils.ReverseBytes(aValue); END;

(*----------------------------------------------------------------------------*)
Function ReverseBytes16_P( const aValue : Word) : Word;
Begin Result := DelticsSysUtils.ReverseBytes(aValue); END;

(*----------------------------------------------------------------------------*)
Function Max15_P( ValueA, ValueB : Integer) : Integer;
Begin Result := DelticsSysUtils.Max(ValueA, ValueB); END;

(*----------------------------------------------------------------------------*)
Function Max14_P( ValueA, ValueB : Cardinal) : Cardinal;
Begin Result := DelticsSysUtils.Max(ValueA, ValueB); END;

(*----------------------------------------------------------------------------*)
Function Min13_P( ValueA, ValueB : Integer) : Integer;
Begin Result := DelticsSysUtils.Min(ValueA, ValueB); END;

(*----------------------------------------------------------------------------*)
Function Min12_P( ValueA, ValueB : Cardinal) : Cardinal;
Begin Result := DelticsSysUtils.Min(ValueA, ValueB); END;

(*----------------------------------------------------------------------------*)
Function IfThen11_P( aValue : Boolean; aTrue, aFalse : String) : String;
Begin Result := DelticsSysUtils.IfThen(aValue, aTrue, aFalse); END;

(*----------------------------------------------------------------------------*)
Function IfThen10_P( aValue : Boolean; aTrue, aFalse : ANSIString) : ANSIString;
Begin Result := DelticsSysUtils.IfThen(aValue, aTrue, aFalse); END;

(*----------------------------------------------------------------------------*)
Function IfThen9_P( aValue : Boolean; aTrue, aFalse : Integer) : Integer;
Begin Result := DelticsSysUtils.IfThen(aValue, aTrue, aFalse); END;

(*----------------------------------------------------------------------------*)
Function IfThen8_P( aValue : Boolean; aTrue, aFalse : TObject) : TObject;
Begin Result := DelticsSysUtils.IfThen(aValue, aTrue, aFalse); END;

(*----------------------------------------------------------------------------*)
Function IfThen7_P( aValue : Boolean; aTrue, aFalse : Boolean) : Boolean;
Begin Result := DelticsSysUtils.IfThen(aValue, aTrue, aFalse); END;

(*----------------------------------------------------------------------------*)
Procedure FreeAndNIL_P( var aObject);
Begin DelticsSysUtils.FreeAndNIL(aObject); END;

(*----------------------------------------------------------------------------*)
Function AutoFree5_P( const aReferences : array of PObject) : IUnknown;
Begin Result := DelticsSysUtils.AutoFree(aReferences); END;

(*----------------------------------------------------------------------------*)
Function AutoFree_P( const aReference : PObject) : IUnknown;
Begin Result := DelticsSysUtils.AutoFree(aReference); END;

(*----------------------------------------------------------------------------*)
Function ENotImplementedCreate1_P(Self: TClass; CreateNewInstance: Boolean;  const aObject : TObject; const aSignature : String):TObject;
Begin Result := ENotImplemented.Create(aObject, aSignature); END;

(*----------------------------------------------------------------------------*)
Function ENotImplementedCreate_P(Self: TClass; CreateNewInstance: Boolean;  const aClass : TClass; const aSignature : String):TObject;
Begin Result := ENotImplemented.Create(aClass, aSignature); END;

(*----------------------------------------------------------------------------*)
Procedure IAutoFreeAdd1_P(Self: IAutoFree;  const aObjects : array of TObject);
Begin Self.Add(aObjects); END;

(*----------------------------------------------------------------------------*)
Procedure IAutoFreeAdd_P(Self: IAutoFree;  const aReferences : array of PObject);
Begin Self.Add(aReferences); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DelticsSysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CloneList, 'deltCloneList', cdRegister);
 S.RegisterDelphiFunction(@AutoFree_P, 'deltAutoFree', cdRegister);
 S.RegisterDelphiFunction(@AutoFree5_P, 'deltAutoFree5', cdRegister);
 S.RegisterDelphiFunction(@FreeAndNIL, 'deltFreeAndNIL', cdRegister);
 S.RegisterDelphiFunction(@NILRefs, 'deltNILRefs', cdRegister);
 S.RegisterDelphiFunction(@IfThen7_P, 'deltIfThen7', cdRegister);
 S.RegisterDelphiFunction(@IfThen8_P, 'deltIfThen8', cdRegister);
 S.RegisterDelphiFunction(@IfThen9_P, 'deltIfThen9', cdRegister);
 S.RegisterDelphiFunction(@IfThen10_P, 'deltIfThen10', cdRegister);
 S.RegisterDelphiFunction(@IfThen11_P, 'deltIfThen11', cdRegister);
 S.RegisterDelphiFunction(@IfThenInt, 'deltIfThenInt', cdRegister);
 S.RegisterDelphiFunction(@StringIndex, 'deltStringIndex', cdRegister);
 S.RegisterDelphiFunction(@TextIndex, 'deltTextIndex', cdRegister);
 S.RegisterDelphiFunction(@Min64, 'deltMin64', cdRegister);
 S.RegisterDelphiFunction(@Min12_P, 'deltMin12', cdRegister);
 S.RegisterDelphiFunction(@Min13_P, 'deltMin13', cdRegister);
 S.RegisterDelphiFunction(@Max64, 'deltMax64', cdRegister);
 S.RegisterDelphiFunction(@Max14_P, 'deltMax14', cdRegister);
 S.RegisterDelphiFunction(@Max15_P, 'deltMax15', cdRegister);
 S.RegisterDelphiFunction(@Exchange, 'deltExchange', cdRegister);
 S.RegisterDelphiFunction(@GUIDToString, 'deltGUIDToString', cdRegister);
 S.RegisterDelphiFunction(@StringToGUID, 'deltStringToGUID', cdRegister);
 S.RegisterDelphiFunction(@TryStringToGUID, 'deltTryStringToGUID', cdRegister);
 S.RegisterDelphiFunction(@IsNull, 'deltIsNull', cdRegister);
 S.RegisterDelphiFunction(@NewGUID, 'deltNewGUID', cdRegister);
 S.RegisterDelphiFunction(@SameGUID, 'deltSameGUID', cdRegister);
 S.RegisterDelphiFunction(@AddTrailingBackslash, 'deltAddTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@RemoveTrailingBackslash, 'deltRemoveTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@BinToHex, 'deltBinToHex', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes16_P, 'deltReverseBytes16', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes17_P, 'deltReverseBytes17', cdRegister);
 S.RegisterDelphiFunction(@ReverseBytes18_P, 'deltReverseBytes18', cdRegister);
 S.RegisterDelphiFunction(@Round, 'deltRound', cdRegister);
 S.RegisterDelphiFunction(@ForEachComponent, 'deltForEachComponent', cdRegister);
 S.RegisterDelphiFunction(@Exec, 'deltExec', cdRegister);
 S.RegisterDelphiFunction(@ExecAndWait, 'deltExecAndWait', cdRegister);
 S.RegisterDelphiFunction(@FindProcess, 'deltFindProcess', cdRegister);
 S.RegisterDelphiFunction(@ProcessExists, 'deltProcessExists', cdRegister);
 S.RegisterDelphiFunction(@RegisterDLL, 'deltRegisterDLL', cdRegister);
 S.RegisterDelphiFunction(@IsTRUE, 'deltIsTRUE', cdRegister);
 S.RegisterDelphiFunction(@IsFALSE, 'deltIsFALSE', cdRegister);
 S.RegisterDelphiFunction(@IsKnown, 'deltIsKnown', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ENotImplemented(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(ENotImplemented) do
  begin
    RegisterConstructor(@ENotImplementedCreate_P, 'Create');
    RegisterConstructor(@ENotImplementedCreate1_P, 'Create1');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DelticsSysUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_ENotImplemented(CL);
  with CL.Add(EAccessDenied) do
end;

 
 
{ TPSImport_DelticsSysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelticsSysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DelticsSysUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DelticsSysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DelticsSysUtils(ri);
  RIRegister_DelticsSysUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
