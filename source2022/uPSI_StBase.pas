unit uPSI_StBase;
{
  base container
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
  TPSImport_StBase = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStBaseEdit(CL: TPSPascalCompiler);
procedure SIRegister_TStComponent(CL: TPSPascalCompiler);
procedure SIRegister_TStContainer(CL: TPSPascalCompiler);
procedure SIRegister_TStNode(CL: TPSPascalCompiler);
procedure SIRegister_EStExprError(CL: TPSPascalCompiler);
procedure SIRegister_EStException(CL: TPSPascalCompiler);
procedure SIRegister_StBase(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StBase_Routines(S: TPSExec);
procedure RIRegister_TStBaseEdit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStComponent(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStContainer(CL: TPSRuntimeClassImporter);
procedure RIRegister_TStNode(CL: TPSRuntimeClassImporter);
procedure RIRegister_EStExprError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EStException(CL: TPSRuntimeClassImporter);
procedure RIRegister_StBase(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,StdCtrls
  ,StConst
  ,StBase
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StBase]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStBaseEdit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TEdit', 'TStBaseEdit') do
  with CL.AddClassN(CL.FindClass('TEdit'),'TStBaseEdit') do
  begin
    RegisterProperty('Version', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStComponent(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TStComponent') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TStComponent') do begin
    RegisterProperty('Version', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStContainer(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TStContainer') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TStContainer') do begin
    RegisterMethod('Constructor CreateContainer( NodeClass : TStNodeClass; Dummy : Integer)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure Free');
     RegisterMethod('Procedure DisposeNodeData( P : TStNode)');
    RegisterMethod('Function DoCompare( Data1, Data2 : Pointer) : Integer');
    RegisterMethod('Procedure DoDisposeData( Data : Pointer)');
    RegisterMethod('Function DoLoadData( Reader : TReader) : Pointer');
    RegisterMethod('Procedure DoStoreData( Writer : TWriter; Data : Pointer)');
    RegisterMethod('Procedure LoadFromFile( const FileName : string)');
    RegisterMethod('Procedure LoadFromStream( S : TStream)');
    RegisterMethod('Procedure StoreToFile( const FileName : string)');
    RegisterMethod('Procedure StoreToStream( S : TStream)');
    RegisterProperty('Count', 'LongInt', iptr);
    RegisterProperty('Compare', 'TCompareFunc', iptrw);
    RegisterProperty('DisposeData', 'TDisposeDataProc', iptrw);
    RegisterProperty('LoadData', 'TLoadDataFunc', iptrw);
    RegisterProperty('StoreData', 'TStoreDataProc', iptrw);
    RegisterProperty('OnCompare', 'TStCompareEvent', iptrw);
    RegisterProperty('OnDisposeData', 'TStDisposeDataEvent', iptrw);
    RegisterProperty('OnLoadData', 'TStLoadDataEvent', iptrw);
    RegisterProperty('OnStoreData', 'TStStoreDataEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TStNode(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TStNode') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TStNode') do begin
    RegisterMethod('Constructor Create( AData : Pointer)');
    RegisterProperty('Data', 'Pointer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EStExprError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EStException', 'EStExprError') do
  with CL.AddClassN(CL.FindClass('EStException'),'EStExprError') do begin
    RegisterMethod('Constructor CreateResTPCol( Ident : Longint; Column : Integer; Dummy : Integer)');
    RegisterProperty('ErrorColumn', 'Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EStException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EStException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EStException') do begin
    RegisterMethod('Constructor CreateResTP( Ident : LongInt; Dummy : Word)');
    RegisterMethod('Constructor CreateResFmtTP( Ident : Longint; const Args : array of const; Dummy : Word)');
    RegisterProperty('ErrorCode', 'LongInt', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_StBase(CL: TPSPascalCompiler);
begin
 //CL.AddConstantN('StMaxBlockSize','').SetString( MaxLongInt);
  CL.AddTypeS('TStLineTerminator', '( ltNone, ltCR, ltLF, ltCRLF, ltOther )');
  CL.AddTypeS('TStHwnd', 'Integer');
  CL.AddTypeS('TStHwnd', 'HWND');
  CL.AddTypeS('TUntypedCompareFunc', 'function(const El1, El2: byte): Integer;');
  SIRegister_EStException(CL);
  //CL.AddTypeS('EStExceptionClass', 'class of EStException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStContainerError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStSortError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStRegIniError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStBCDError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStStringError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStVersionInfoError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStNetException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStBarCodeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStPNBarCodeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStStatError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStFinError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStMimeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStToHTMLError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStSpawnError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStMMFileError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStBufStreamError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStRegExError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStDecMathError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EStPRNGError');
  SIRegister_EStExprError(CL);
 CL.AddConstantN('StMaxFileLen','LongInt').SetInt( 260);
 CL.AddConstantN('StRLEMaxCount','LongInt').SetInt( 127);
 CL.AddConstantN('StRLERunMode','LongWord').SetUInt( $80);
 CL.AddConstantN('StHexDigitsW','WideString').SetString( '0123456789ABCDEF');
 CL.AddConstantN('DosDelimSetW','WideString').SetString( '\:');
  //CL.AddTypeS('PDouble', '^Double // will not work');
  CL.AddTypeS('TStFloat', 'Extended');
  //CL.AddTypeS('TStFloat', 'Real');
 CL.AddConstantN('WMCOPYID','DWORD').SetInt($AFAF);
  SIRegister_TStNode(CL);
  //CL.AddTypeS('TStNodeClass', 'class of TStNode');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TStContainer');
  CL.AddTypeS('TStCompareEvent', 'Procedure ( Sender : TObject; Data1, Data2 : '
   +'___Pointer; var Compare : Integer)');
  CL.AddTypeS('TStDisposeDataEvent', 'Procedure ( Sender : TObject; Data : ___Pointer)');
  CL.AddTypeS('TStLoadDataEvent', 'Procedure ( Sender : TObject; Reader : TReader; var Data : ___Pointer)');
  CL.AddTypeS('TStStoreDataEvent', 'Procedure ( Sender : TObject; Writer : TWriter; Data : ___Pointer)');
  CL.AddTypeS('TStStringCompareEvent', 'Procedure ( Sender : TObject; const String1, String2 : string; var Compare : Integer)');
  SIRegister_TStContainer(CL);
  SIRegister_TStComponent(CL);
  SIRegister_TStBaseEdit(CL);
 CL.AddDelphiFunction('Function DestroyNode( Container : TStContainer; Node : TStNode; OtherData : ___Pointer) : Boolean');
 CL.AddDelphiFunction('Function AnsiUpperCaseShort32( const S : string) : string');
 CL.AddDelphiFunction('Function AnsiCompareTextShort32( const S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function AnsiCompareStrShort32( const S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function HugeCompressRLE( const InBuffer, InLen : Longint; var OutBuffer: Longint) : Longint');
 CL.AddDelphiFunction('Function HugeDecompressRLE( const InBuffer, InLen : Longint; var OutBuffer, OutLen : LongInt) : Longint');
 CL.AddDelphiFunction('Procedure HugeFillChar( var Dest, Count : Longint; Value : Byte)');
 CL.AddDelphiFunction('Procedure HugeFillStruc( var Dest, Count : Longint; const Value, ValSize : Cardinal)');
 //CL.AddDelphiFunction('Function Upcase( C : AnsiChar) : AnsiChar');
 //CL.AddDelphiFunction('Function LoCase( C : AnsiChar) : AnsiChar');
 CL.AddDelphiFunction('Function CompareLetterSets( Set1, Set2 : LongInt) : Cardinal');
 CL.AddDelphiFunction('Function CompStruct( const S1, S2, Size : Cardinal) : Integer');
 CL.AddDelphiFunction('Function StSearch( const Buffer, BufLength : Cardinal; const Match, MatLength : Cardinal; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function SearchUC( const Buffer, BufLength : Cardinal; const Match, MatLength : Cardinal; var Pos : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function IsOrInheritsFrom( Root, Candidate : TClass) : boolean');
 CL.AddDelphiFunction('Procedure RaiseContainerError( Code : longint)');
 CL.AddDelphiFunction('Procedure RaiseContainerErrorFmt( Code : Longint; Data : array of const)');
 CL.AddDelphiFunction('Function ProductOverflow( A, B : LongInt) : Boolean');
 //CL.AddDelphiFunction('Function StNewStr( S : string) : PShortString');
// CL.AddDelphiFunction('Procedure StDisposeStr( PS : PShortString)');
 CL.AddDelphiFunction('Procedure ValLongInt( S : ShortString; var LI : Longint; var ErrorCode : integer)');
 CL.AddDelphiFunction('Procedure ValSmallint( const S : ShortString; var SI : smallint; var ErrorCode : integer)');
 CL.AddDelphiFunction('Procedure ValWord( const S : ShortString; var Wd : word; var ErrorCode : integer)');
 //CL.AddDelphiFunction('Procedure RaiseStError( ExceptionClass : EStExceptionClass; Code : LongInt)');
 //CL.AddDelphiFunction('Procedure RaiseStWin32Error( ExceptionClass : EStExceptionClass; Code : LongInt)');
 //CL.AddDelphiFunction('Procedure RaiseStWin32ErrorEx( ExceptionClass : EStExceptionClass; Code : LongInt; Info : string)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStBaseEditVersion_W(Self: TStBaseEdit; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TStBaseEditVersion_R(Self: TStBaseEdit; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TStComponentVersion_W(Self: TStComponent; const T: string);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TStComponentVersion_R(Self: TStComponent; var T: string);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerOnStoreData_W(Self: TStContainer; const T: TStStoreDataEvent);
begin Self.OnStoreData := T; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerOnStoreData_R(Self: TStContainer; var T: TStStoreDataEvent);
begin T := Self.OnStoreData; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerOnLoadData_W(Self: TStContainer; const T: TStLoadDataEvent);
begin Self.OnLoadData := T; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerOnLoadData_R(Self: TStContainer; var T: TStLoadDataEvent);
begin T := Self.OnLoadData; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerOnDisposeData_W(Self: TStContainer; const T: TStDisposeDataEvent);
begin Self.OnDisposeData := T; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerOnDisposeData_R(Self: TStContainer; var T: TStDisposeDataEvent);
begin T := Self.OnDisposeData; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerOnCompare_W(Self: TStContainer; const T: TStCompareEvent);
begin Self.OnCompare := T; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerOnCompare_R(Self: TStContainer; var T: TStCompareEvent);
begin T := Self.OnCompare; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerStoreData_W(Self: TStContainer; const T: TStoreDataProc);
begin Self.StoreData := T; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerStoreData_R(Self: TStContainer; var T: TStoreDataProc);
begin T := Self.StoreData; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerLoadData_W(Self: TStContainer; const T: TLoadDataFunc);
begin Self.LoadData := T; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerLoadData_R(Self: TStContainer; var T: TLoadDataFunc);
begin T := Self.LoadData; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerDisposeData_W(Self: TStContainer; const T: TDisposeDataProc);
begin Self.DisposeData := T; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerDisposeData_R(Self: TStContainer; var T: TDisposeDataProc);
begin T := Self.DisposeData; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerCompare_W(Self: TStContainer; const T: TCompareFunc);
begin Self.Compare := T; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerCompare_R(Self: TStContainer; var T: TCompareFunc);
begin T := Self.Compare; end;

(*----------------------------------------------------------------------------*)
procedure TStContainerCount_R(Self: TStContainer; var T: LongInt);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TStNodeData_W(Self: TStNode; const T: Pointer);
begin Self.Data := T; end;

(*----------------------------------------------------------------------------*)
procedure TStNodeData_R(Self: TStNode; var T: Pointer);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure EStExprErrorErrorColumn_R(Self: EStExprError; var T: Integer);
begin T := Self.ErrorColumn; end;

(*----------------------------------------------------------------------------*)
procedure EStExceptionErrorCode_W(Self: EStException; const T: LongInt);
begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EStExceptionErrorCode_R(Self: EStException; var T: LongInt);
begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StBase_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DestroyNode, 'DestroyNode', cdRegister);
 //S.RegisterDelphiFunction(@AnsiUpperCaseShort32, 'AnsiUpperCaseShort32', cdRegister);
 //S.RegisterDelphiFunction(@AnsiCompareTextShort32, 'AnsiCompareTextShort32', cdRegister);
 //S.RegisterDelphiFunction(@AnsiCompareStrShort32, 'AnsiCompareStrShort32', cdRegister);
 S.RegisterDelphiFunction(@HugeCompressRLE, 'HugeCompressRLE', cdRegister);
 S.RegisterDelphiFunction(@HugeDecompressRLE, 'HugeDecompressRLE', cdRegister);
 S.RegisterDelphiFunction(@HugeFillChar, 'HugeFillChar', cdRegister);
 S.RegisterDelphiFunction(@HugeFillStruc, 'HugeFillStruc', cdRegister);
 //S.RegisterDelphiFunction(@Upcase, 'Upcase', cdRegister);
 //S.RegisterDelphiFunction(@LoCase, 'LoCase', cdRegister);
 S.RegisterDelphiFunction(@CompareLetterSets, 'CompareLetterSets', cdRegister);
 S.RegisterDelphiFunction(@CompStruct, 'CompStruct', cdRegister);
 S.RegisterDelphiFunction(@Search, 'StSearch', cdRegister);
 S.RegisterDelphiFunction(@SearchUC, 'SearchUC', cdRegister);
 S.RegisterDelphiFunction(@IsOrInheritsFrom, 'IsOrInheritsFrom', cdRegister);
 S.RegisterDelphiFunction(@RaiseContainerError, 'RaiseContainerError', cdRegister);
 S.RegisterDelphiFunction(@RaiseContainerErrorFmt, 'RaiseContainerErrorFmt', cdRegister);
 S.RegisterDelphiFunction(@ProductOverflow, 'ProductOverflow', cdRegister);
 //S.RegisterDelphiFunction(@StNewStr, 'StNewStr', cdRegister);
 //S.RegisterDelphiFunction(@StDisposeStr, 'StDisposeStr', cdRegister);
 S.RegisterDelphiFunction(@ValLongInt, 'ValLongInt', cdRegister);
 S.RegisterDelphiFunction(@ValSmallint, 'ValSmallint', cdRegister);
 S.RegisterDelphiFunction(@ValWord, 'ValWord', cdRegister);
 //S.RegisterDelphiFunction(@RaiseStError, 'RaiseStError', cdRegister);
 S.RegisterDelphiFunction(@RaiseStWin32Error, 'RaiseStWin32Error', cdRegister);
 S.RegisterDelphiFunction(@RaiseStWin32ErrorEx, 'RaiseStWin32ErrorEx', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStBaseEdit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStBaseEdit) do
  begin
    RegisterPropertyHelper(@TStBaseEditVersion_R,@TStBaseEditVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStComponent(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStComponent) do
  begin
    RegisterPropertyHelper(@TStComponentVersion_R,@TStComponentVersion_W,'Version');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStContainer(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStContainer) do begin
    RegisterConstructor(@TStContainer.CreateContainer, 'CreateContainer');
    //RegisterVirtualAbstractMethod(@TStContainer, @!.Clear, 'Clear');
    RegisterMethod(@TStContainer.Destroy, 'Free');
    RegisterMethod(@TStContainer.DisposeNodeData, 'DisposeNodeData');
    RegisterVirtualMethod(@TStContainer.DoCompare, 'DoCompare');
    RegisterVirtualMethod(@TStContainer.DoDisposeData, 'DoDisposeData');
    RegisterVirtualMethod(@TStContainer.DoLoadData, 'DoLoadData');
    RegisterVirtualMethod(@TStContainer.DoStoreData, 'DoStoreData');
    RegisterVirtualMethod(@TStContainer.LoadFromFile, 'LoadFromFile');
    //RegisterVirtualAbstractMethod(@TStContainer, @!.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TStContainer.StoreToFile, 'StoreToFile');
    //RegisterVirtualAbstractMethod(@TStContainer, @!.StoreToStream, 'StoreToStream');
    RegisterPropertyHelper(@TStContainerCount_R,nil,'Count');
    RegisterPropertyHelper(@TStContainerCompare_R,@TStContainerCompare_W,'Compare');
    RegisterPropertyHelper(@TStContainerDisposeData_R,@TStContainerDisposeData_W,'DisposeData');
    RegisterPropertyHelper(@TStContainerLoadData_R,@TStContainerLoadData_W,'LoadData');
    RegisterPropertyHelper(@TStContainerStoreData_R,@TStContainerStoreData_W,'StoreData');
    RegisterPropertyHelper(@TStContainerOnCompare_R,@TStContainerOnCompare_W,'OnCompare');
    RegisterPropertyHelper(@TStContainerOnDisposeData_R,@TStContainerOnDisposeData_W,'OnDisposeData');
    RegisterPropertyHelper(@TStContainerOnLoadData_R,@TStContainerOnLoadData_W,'OnLoadData');
    RegisterPropertyHelper(@TStContainerOnStoreData_R,@TStContainerOnStoreData_W,'OnStoreData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStNode(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStNode) do begin
    RegisterConstructor(@TStNode.Create, 'Create');
    RegisterPropertyHelper(@TStNodeData_R,@TStNodeData_W,'Data');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EStExprError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EStExprError) do begin
    RegisterConstructor(@EStExprError.CreateResTPCol, 'CreateResTPCol');
    RegisterPropertyHelper(@EStExprErrorErrorColumn_R,nil,'ErrorColumn');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EStException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EStException) do begin
    RegisterConstructor(@EStException.CreateResTP, 'CreateResTP');
    RegisterConstructor(@EStException.CreateResFmtTP, 'CreateResFmtTP');
    RegisterPropertyHelper(@EStExceptionErrorCode_R,@EStExceptionErrorCode_W,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_StBase(CL: TPSRuntimeClassImporter);
begin
  RIRegister_EStException(CL);
  with CL.Add(EStContainerError) do
  with CL.Add(EStSortError) do
  with CL.Add(EStRegIniError) do
  with CL.Add(EStBCDError) do
  with CL.Add(EStStringError) do
  with CL.Add(EStVersionInfoError) do
  with CL.Add(EStNetException) do
  with CL.Add(EStBarCodeError) do
  with CL.Add(EStPNBarCodeError) do
  with CL.Add(EStStatError) do
  with CL.Add(EStFinError) do
  with CL.Add(EStMimeError) do
  with CL.Add(EStToHTMLError) do
  with CL.Add(EStSpawnError) do
  with CL.Add(EStMMFileError) do
  with CL.Add(EStBufStreamError) do
  with CL.Add(EStRegExError) do
  with CL.Add(EStDecMathError) do
  with CL.Add(EStPRNGError) do
  RIRegister_EStExprError(CL);
  RIRegister_TStNode(CL);
  with CL.Add(TStContainer) do
  RIRegister_TStContainer(CL);
  RIRegister_TStComponent(CL);
  RIRegister_TStBaseEdit(CL);
end;

 
 
{ TPSImport_StBase }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StBase.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StBase(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StBase.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_StBase(ri);
  RIRegister_StBase_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
