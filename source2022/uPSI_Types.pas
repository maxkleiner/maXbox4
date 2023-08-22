unit uPSI_Types;
{
   Types_Routines(S: TPSExec); are also in StrUtils
   add array of char   - equals value
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
  TPSImport_Types = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_IStream(CL: TPSPascalCompiler);
procedure SIRegister_ISequentialStream(CL: TPSPascalCompiler);
procedure SIRegister_IClassFactory(CL: TPSPascalCompiler);
procedure SIRegister_Types(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Types_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Types
  ;

Type

  IClassFactory = interface(IUnknown)
     ['{00000001-0000-0000-C000-000000000046}']
    function CreateInstance(const unkOuter: IUnknown; const iid: TGUID;
      out obj): HResult; stdcall;
    function LockServer(fLock: LongBool): HResult; stdcall;
  end;


  ISequentialStream = interface(IUnknown)
    ['{0c733a30-2a1c-11ce-ade5-00aa0044773d}']
    function Read(pv: Pointer; cb: Longint; pcbRead: PLongint): HResult;
      stdcall;
    function Write(pv: Pointer; cb: Longint; pcbWritten: PLongint): HResult;
      stdcall;
  end;

  IStream = interface(ISequentialStream)
    ['{0000000C-0000-0000-C000-000000000046}']
    function Seek(dlibMove: Longint; dwOrigin: Longint;
      out libNewPosition: Longint): HResult; stdcall;
    function SetSize(libNewSize: Longint): HResult; stdcall;
    function CopyTo(stm: IStream; cb: Longint; out cbRead: Longint;
      out cbWritten: Longint): HResult; stdcall;
    function Commit(grfCommitFlags: Longint): HResult; stdcall;
    function Revert: HResult; stdcall;
    function LockRegion(libOffset: Longint; cb: Longint;
      dwLockType: Longint): HResult; stdcall;
    function UnlockRegion(libOffset: Longint; cb: Longint;
      dwLockType: Longint): HResult; stdcall;
    //function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult;
      //stdcall;
    function Clone(out stm: IStream): HResult; stdcall;
  end;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Types]);
end;



(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_IStream(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'ISequentialStream', 'IStream') do
  with CL.AddInterface(CL.FindInterface('ISequentialStream'),IStream, 'IStream') do
  begin
    RegisterMethod('Function Seek( dlibMove : Longint; dwOrigin : Longint; out libNewPosition : Largeint) : HResult', CdStdCall);
    RegisterMethod('Function SetSize( libNewSize : Longint) : HResult', CdStdCall);
    RegisterMethod('Function CopyTo( stm : IStream; cb : Largeint; out cbRead : Largeint; out cbWritten : Largeint) : HResult', CdStdCall);
    RegisterMethod('Function Commit( grfCommitFlags : Longint) : HResult', CdStdCall);
    RegisterMethod('Function Revert : HResult', CdStdCall);
    RegisterMethod('Function LockRegion( libOffset : Longint; cb : Largeint; dwLockType : Longint) : HResult', CdStdCall);
    RegisterMethod('Function UnlockRegion( libOffset : Longint; cb : Largeint; dwLockType : Longint) : HResult', CdStdCall);
    //RegisterMethod('Function Stat( out statstg : TStatStg; grfStatFlag : Longint) : HResult', CdStdCall);
    RegisterMethod('Function Clone( out stm : IStream) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ISequentialStream(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'ISequentialStream') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),ISequentialStream, 'ISequentialStream') do
  begin
    RegisterMethod('Function Read( pv : Pointer; cb : Longint; pcbRead : PLongint) : HResult', CdStdCall);
    RegisterMethod('Function Write( pv : Pointer; cb : Longint; pcbWritten : PLongint) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IClassFactory(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IUnknown', 'IClassFactory') do
  with CL.AddInterface(CL.FindInterface('IUnknown'),IClassFactory, 'IClassFactory') do begin
    RegisterMethod('Function CreateInstance( const unkOuter : IUnknown; const iid : TGUID; out obj) : HResult', CdStdCall);
    RegisterMethod('Function LockServer( fLock : LongBool) : HResult', CdStdCall);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Types(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIntegerDynArray', 'array of Integer');
  CL.AddTypeS('TCardinalDynArray', 'array of Cardinal');
  CL.AddTypeS('TWordDynArray', 'array of Word');
  CL.AddTypeS('TSmallIntDynArray', 'array of SmallInt');
  CL.AddTypeS('TByteDynArray', 'array of Byte');
  CL.AddTypeS('TCharDynArray', 'array of Char');
  CL.AddTypeS('TShortIntDynArray', 'array of ShortInt');
  CL.AddTypeS('TInt64DynArray', 'array of Int64');
  CL.AddTypeS('TLongWordDynArray', 'array of LongWord');
  CL.AddTypeS('TSingleDynArray', 'array of Single');
  CL.AddTypeS('TDoubleDynArray', 'array of Double');
  CL.AddTypeS('TBooleanDynArray', 'array of Boolean');
  CL.AddTypeS('TStringDynArray', 'array of string');
  CL.AddTypeS('TWideStringDynArray', 'array of WideString');
  //CL.AddTypeS('TSize', 'tagSIZE');
  //CL.AddTypeS('SIZE', 'tagSIZE');
  CL.AddTypeS('Longword', 'Cardinal');   //unsigned integer to cardinal
  CL.AddTypeS('DWORD', 'Cardinal');
 //CL.AddConstantN('RT_RCDATA','LongInt').SetInt( PChar ( 10 ));
  //CL.AddTypeS('PDisplay', 'Pointer');
  //CL.AddTypeS('PEvent', 'Pointer');
  //CL.AddTypeS('TXrmOptionDescRec', 'record end');
  //CL.AddTypeS('XrmOptionDescRec', 'TXrmOptionDescRec');
  //CL.AddTypeS('PXrmOptionDescRec', '^TXrmOptionDescRec // will not work');
  //CL.AddTypeS('Widget', 'Pointer');
  //CL.AddTypeS('WidgetClass', 'Pointer');
  //CL.AddTypeS('ArgList', 'Pointer');
  //CL.AddTypeS('Region', 'Pointer');
 CL.AddConstantN('STGTY_STORAGE','LongInt').SetInt( 1);
 CL.AddConstantN('STGTY_STREAM','LongInt').SetInt( 2);
 CL.AddConstantN('STGTY_LOCKBYTES','LongInt').SetInt( 3);
 CL.AddConstantN('STGTY_PROPERTY','LongInt').SetInt( 4);
 CL.AddConstantN('STREAM_SEEK_SET','LongInt').SetInt( 0);
 CL.AddConstantN('STREAM_SEEK_CUR','LongInt').SetInt( 1);
 CL.AddConstantN('STREAM_SEEK_END','LongInt').SetInt( 2);
 CL.AddConstantN('LOCK_WRITE','LongInt').SetInt( 1);
 CL.AddConstantN('LOCK_EXCLUSIVE','LongInt').SetInt( 2);
 CL.AddConstantN('LOCK_ONLYONCE','LongInt').SetInt( 4);
 //CL.AddConstantN('E_FAIL','LongWord').SetUInt( HRESULT ( $80004005 ));
 CL.AddConstantN('STG_S_MONITORING','LongWord').SetUInt( $00030203);
 //CL.AddConstantN('GUID_NULL','TGUID').SetString( '{00000000-0000-0000-0000-000000000000}');
  CL.AddTypeS('TOleChar', 'WideChar');
  //CL.AddTypeS('POleStr', 'PWideChar');
  //CL.AddTypeS('PPOleStr', '^POleStr // will not work');
  //CL.AddTypeS('PCLSID', 'PGUID');
  //CL.AddTypeS('TCLSID', 'TGUID');
  CL.AddTypeS('Largeint', 'Int64');
  //CL.AddTypeS('PDWORD', '^DWORD // will not work');
  //CL.AddTypeS('TFileTime', '_FILETIME');
  //CL.AddTypeS('FILETIME', '_FILETIME');
  //CL.AddTypeS('TStatStg', 'tagSTATSTG');
  //CL.AddTypeS('STATSTG', 'TStatStg');
  SIRegister_IClassFactory(CL);
  SIRegister_ISequentialStream(CL);
  SIRegister_IStream(CL);
    CL.AddTypeS('TPointArray', 'array of TPoint');
  //   CL.FindType('TPoint');
 //Cl.AddTypeS('TPoint', 'record X, Y: LongInt; end;');

 CL.AddDelphiFunction('Function EqualRect( const R1, R2 : TRect) : Boolean');
 CL.AddDelphiFunction('Function Rect( Left, Top, Right, Bottom : Integer) : TRect');

 CL.AddDelphiFunction('Function Bounds( ALeft, ATop, AWidth, AHeight : Integer) : TRect');
 CL.AddDelphiFunction('Function Point( X, Y : Integer) : TPoint');
 CL.AddDelphiFunction('Function Rect2(const ATopLeft, ABottomRight: TPoint): TRect;');

 //CL.AddDelphiFunction('Function SmallPoint( X, Y : Integer) : TSmallPoint;');  in strutils
 //CL.AddDelphiFunction('Function SmallPoint1( XY : LongWord) : TSmallPoint;');
 CL.AddDelphiFunction('Function PtInRect( const Rect : TRect; const P : TPoint) : Boolean');
 CL.AddDelphiFunction('Function IntersectRect( out Rect : TRect; const R1, R2 : TRect) : Boolean');
 CL.AddDelphiFunction('Function UnionRect( out Rect : TRect; const R1, R2 : TRect) : Boolean');
 CL.AddDelphiFunction('Function IsRectEmpty( const Rect : TRect) : Boolean');
 CL.AddDelphiFunction('Function OffsetRect( var Rect : TRect; DX : Integer; DY : Integer) : Boolean');
 CL.AddDelphiFunction('Function CenterPoint( const Rect : TRect) : TPoint');
 CL.AddDelphiFunction('Function PointsEqual( const P1, P2 : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function InvalidPoint( X, Y : Integer) : Boolean;');
 CL.AddDelphiFunction('Function InvalidPoint2( const At : TPoint) : Boolean;');
 CL.AddDelphiFunction('Function CollectionsEqual( C1, C2 : TCollection; Owner1, Owner2 : TComponent) : Boolean');

  CL.AddConstantN('EqualsValue','LongInt').SetInt(0);
  CL.AddConstantN('LessThanValue','LongInt').SetInt(-1);
  CL.AddConstantN('GreaterThanValue','LongInt').SetInt(1);

 // LessThanValue:=-1;
 // GreaterThanValue:=1
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function SmallPoint1_P( XY : LongWord) : TSmallPoint;
Begin Result := Types.SmallPoint(XY); END;

(*----------------------------------------------------------------------------*)
Function SmallPoint_P( X, Y : Integer) : TSmallPoint;
Begin Result := Types.SmallPoint(X, Y); END;

function InvalidPoint2(const At: TPoint): Boolean;
begin
  Result := (At.X = -1) and (At.Y = -1);
end;

function Rect2(const ATopLeft, ABottomRight: TPoint): TRect;
begin
  Result := Types.Rect(ATopLeft.X, ATopLeft.Y, ABottomRight.X, ABottomRight.Y);
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_Types_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@EqualRect, 'EqualRect', cdRegister);
 S.RegisterDelphiFunction(@Rect, 'Rect', cdRegister);
 S.RegisterDelphiFunction(@Rect2, 'Rect2', cdRegister);

 S.RegisterDelphiFunction(@Bounds, 'Bounds', cdRegister);
 S.RegisterDelphiFunction(@Point, 'Point', cdRegister);
 S.RegisterDelphiFunction(@SmallPoint_P, 'SmallPoint', cdRegister);
 S.RegisterDelphiFunction(@SmallPoint1_P, 'SmallPoint1', cdRegister);
 S.RegisterDelphiFunction(@PtInRect, 'PtInRect', cdRegister);
 S.RegisterDelphiFunction(@IntersectRect, 'IntersectRect', cdRegister);
 S.RegisterDelphiFunction(@UnionRect, 'UnionRect', cdRegister);
 S.RegisterDelphiFunction(@IsRectEmpty, 'IsRectEmpty', cdRegister);
 S.RegisterDelphiFunction(@OffsetRect, 'OffsetRect', cdRegister);
 S.RegisterDelphiFunction(@CenterPoint, 'CenterPoint', cdRegister);
 S.RegisterDelphiFunction(@PointsEqual, 'PointsEqual', cdRegister);
 S.RegisterDelphiFunction(@InvalidPoint, 'InvalidPoint', cdRegister);
 S.RegisterDelphiFunction(@InvalidPoint2, 'InvalidPoint2', cdRegister);
 S.RegisterDelphiFunction(@CollectionsEqual, 'CollectionsEqual', cdRegister);

end;

 
 
{ TPSImport_Types }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Types.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Types(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Types.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Types_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
