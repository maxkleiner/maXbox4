unit uPSI_JclNTFS;
{
  filesystem
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
  TPSImport_JclNTFS = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_JclNTFS(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_JclNTFS_Routines(S: TPSExec);
procedure RIRegister_JclNTFS(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,JclBase
  ,JclWin32
  ,JclNTFS
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclNTFS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_JclNTFS(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclNtfsError');
  CL.AddTypeS('TFileCompressionState', '( fcNoCompression, fcDefaultCompression, fcLZNT1Compression )');
 CL.AddDelphiFunction('Function NtfsGetCompression( const FileName : string; var State : Short) : Boolean;');
 CL.AddDelphiFunction('Function NtfsGetCompression1( const FileName : string) : TFileCompressionState;');
 CL.AddDelphiFunction('Function NtfsSetCompression( const FileName : string; const State : Short) : Boolean');
 CL.AddDelphiFunction('Procedure NtfsSetFileCompression( const FileName : string; const State : TFileCompressionState)');
 CL.AddDelphiFunction('Procedure NtfsSetDirectoryTreeCompression( const Directory : string; const State : TFileCompressionState)');
 CL.AddDelphiFunction('Procedure NtfsSetDefaultFileCompression( const Directory : string; const State : TFileCompressionState)');
 CL.AddDelphiFunction('Procedure NtfsSetPathCompression( const Path : string; const State : TFileCompressionState; Recursive : Boolean)');
  //CL.AddTypeS('TNtfsAllocRanges', 'record Entries : Integer; Data : PFileAlloca'
   //+'tedRangeBuffer; MoreData : Boolean; end');
 CL.AddDelphiFunction('Function NtfsSetSparse( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsZeroDataByHandle( const Handle : THandle; const First, Last : Int64) : Boolean');
 CL.AddDelphiFunction('Function NtfsZeroDataByName( const FileName : string; const First, Last : Int64) : Boolean');
 //CL.AddDelphiFunction('Function NtfsQueryAllocRanges( const FileName : string; Offset, Count : Int64; var Ranges : TNtfsAllocRanges) : Boolean');
 //CL.AddDelphiFunction('Function NtfsGetAllocRangeEntry( const Ranges : TNtfsAllocRanges; Index : Integer) : TFileAllocatedRangeBuffer');
 CL.AddDelphiFunction('Function NtfsSparseStreamsSupported( const Volume : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsGetSparse( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsDeleteReparsePoint( const FileName : string; ReparseTag : DWORD) : Boolean');
 CL.AddDelphiFunction('Function NtfsSetReparsePoint( const FileName : string; var ReparseData, Size : Longword) : Boolean');
 //CL.AddDelphiFunction('Function NtfsGetReparsePoint( const FileName : string; var ReparseData : TReparseGuidDataBuffer) : Boolean');
 CL.AddDelphiFunction('Function NtfsGetReparseTag( const Path : string; var Tag : DWORD) : Boolean');
 CL.AddDelphiFunction('Function NtfsReparsePointsSupported( const Volume : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsFileHasReparsePoint( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsIsFolderMountPoint( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsMountDeviceAsDrive( const Device : string; Drive : Char) : Boolean');
 CL.AddDelphiFunction('Function NtfsMountVolume( const Volume : Char; const MountPoint : string) : Boolean');
  CL.AddTypeS('TOpLock', '( olExclusive, olReadOnly, olBatch, olFilter )');
 CL.AddDelphiFunction('Function NtfsOpLockAckClosePending( Handle : THandle; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsOpLockBreakAckNo2( Handle : THandle; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsOpLockBreakAcknowledge( Handle : THandle; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsOpLockBreakNotify( Handle : THandle; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsRequestOpLock( Handle : THandle; Kind : TOpLock; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsCreateJunctionPoint( const Source, Destination : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsDeleteJunctionPoint( const Source : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsGetJunctionPointDestination( const Source : string; var Destination : string) : Boolean');
  CL.AddTypeS('TStreamId', '( siInvalid, siStandard, siExtendedAttribute, siSec'
   +'urity, siAlternate, siHardLink, siProperty, siObjectIdentifier, siReparsePoints, siSparseFile )');
  CL.AddTypeS('TStreamIds', 'set of TStreamId');
  CL.AddTypeS('TInternalFindStreamData', 'record FileHandle : THandle; Context '
   +': ___Pointer; StreamIds : TStreamIds; end');
  CL.AddTypeS('TFindStreamData', 'record Internal : TInternalFindStreamData; At'
   +'tributes : DWORD; StreamID : TStreamId; Name : WideString; Size : Int64; end');
 CL.AddDelphiFunction('Function NtfsFindFirstStream( const FileName : string; StreamIds : TStreamIds; var Data : TFindStreamData) : Boolean');
 CL.AddDelphiFunction('Function NtfsFindNextStream( var Data : TFindStreamData) : Boolean');
 CL.AddDelphiFunction('Function NtfsFindStreamClose( var Data : TFindStreamData) : Boolean');
 CL.AddDelphiFunction('Function NtfsCreateHardLink( const LinkFileName, ExistingFileName : string) : Boolean');
  CL.AddTypeS('TNtfsHardLinkInfo', 'record LinkCount : Cardinal; FileIndex : Int64; end');
 CL.AddDelphiFunction('Function NtfsGetHardLinkInfo( const FileName : string; var Info : TNtfsHardLinkInfo) : Boolean');
 CL.AddDelphiFunction('Function NtfsFindHardLinks( const Path : string; const FileIndexHigh, FileIndexLow : Cardinal; const List : TStrings) : Boolean');
 CL.AddDelphiFunction('Function NtfsDeleteHardLinks( const FileName : string) : Boolean');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function NtfsGetCompression1_P( const FileName : string) : TFileCompressionState;
Begin Result := JclNTFS.NtfsGetCompression(FileName); END;

(*----------------------------------------------------------------------------*)
Function NtfsGetCompression_P( const FileName : string; var State : Short) : Boolean;
Begin Result := JclNTFS.NtfsGetCompression(FileName, State); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclNTFS_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NtfsGetCompression, 'NtfsGetCompression', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetCompression1_P, 'NtfsGetCompression1', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetCompression, 'NtfsSetCompression', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetFileCompression, 'NtfsSetFileCompression', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetDirectoryTreeCompression, 'NtfsSetDirectoryTreeCompression', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetDefaultFileCompression, 'NtfsSetDefaultFileCompression', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetPathCompression, 'NtfsSetPathCompression', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetSparse, 'NtfsSetSparse', cdRegister);
 S.RegisterDelphiFunction(@NtfsZeroDataByHandle, 'NtfsZeroDataByHandle', cdRegister);
 S.RegisterDelphiFunction(@NtfsZeroDataByName, 'NtfsZeroDataByName', cdRegister);
 S.RegisterDelphiFunction(@NtfsQueryAllocRanges, 'NtfsQueryAllocRanges', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetAllocRangeEntry, 'NtfsGetAllocRangeEntry', cdRegister);
 S.RegisterDelphiFunction(@NtfsSparseStreamsSupported, 'NtfsSparseStreamsSupported', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetSparse, 'NtfsGetSparse', cdRegister);
 S.RegisterDelphiFunction(@NtfsDeleteReparsePoint, 'NtfsDeleteReparsePoint', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetReparsePoint, 'NtfsSetReparsePoint', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetReparsePoint, 'NtfsGetReparsePoint', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetReparseTag, 'NtfsGetReparseTag', cdRegister);
 S.RegisterDelphiFunction(@NtfsReparsePointsSupported, 'NtfsReparsePointsSupported', cdRegister);
 S.RegisterDelphiFunction(@NtfsFileHasReparsePoint, 'NtfsFileHasReparsePoint', cdRegister);
 S.RegisterDelphiFunction(@NtfsIsFolderMountPoint, 'NtfsIsFolderMountPoint', cdRegister);
 S.RegisterDelphiFunction(@NtfsMountDeviceAsDrive, 'NtfsMountDeviceAsDrive', cdRegister);
 S.RegisterDelphiFunction(@NtfsMountVolume, 'NtfsMountVolume', cdRegister);
 S.RegisterDelphiFunction(@NtfsOpLockAckClosePending, 'NtfsOpLockAckClosePending', cdRegister);
 S.RegisterDelphiFunction(@NtfsOpLockBreakAckNo2, 'NtfsOpLockBreakAckNo2', cdRegister);
 S.RegisterDelphiFunction(@NtfsOpLockBreakAcknowledge, 'NtfsOpLockBreakAcknowledge', cdRegister);
 S.RegisterDelphiFunction(@NtfsOpLockBreakNotify, 'NtfsOpLockBreakNotify', cdRegister);
 S.RegisterDelphiFunction(@NtfsRequestOpLock, 'NtfsRequestOpLock', cdRegister);
 S.RegisterDelphiFunction(@NtfsCreateJunctionPoint, 'NtfsCreateJunctionPoint', cdRegister);
 S.RegisterDelphiFunction(@NtfsDeleteJunctionPoint, 'NtfsDeleteJunctionPoint', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetJunctionPointDestination, 'NtfsGetJunctionPointDestination', cdRegister);
 S.RegisterDelphiFunction(@NtfsFindFirstStream, 'NtfsFindFirstStream', cdRegister);
 S.RegisterDelphiFunction(@NtfsFindNextStream, 'NtfsFindNextStream', cdRegister);
 S.RegisterDelphiFunction(@NtfsFindStreamClose, 'NtfsFindStreamClose', cdRegister);
 S.RegisterDelphiFunction(@NtfsCreateHardLink, 'NtfsCreateHardLink', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetHardLinkInfo, 'NtfsGetHardLinkInfo', cdRegister);
 S.RegisterDelphiFunction(@NtfsFindHardLinks, 'NtfsFindHardLinks', cdRegister);
 S.RegisterDelphiFunction(@NtfsDeleteHardLinks, 'NtfsDeleteHardLinks', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclNTFS(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclNtfsError) do
end;

 
 
{ TPSImport_JclNTFS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclNTFS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclNTFS(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclNTFS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclNTFS(ri);
  RIRegister_JclNTFS_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
