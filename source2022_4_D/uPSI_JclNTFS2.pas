unit uPSI_JclNTFS2;
{
    second one  in progress
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
procedure SIRegister_TJclJpegSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclImageInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclQuerySummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclLinkSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclShareSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclVolumeSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclControlPanelSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclAudioSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclVideoSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclDRMSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclMusicSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclWebViewSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclMiscSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclBriefCaseSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclDisplacedSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclImageSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclStorageSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclShellSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclMSISummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclMediaFileSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclDocSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileSummaryInformation(CL: TPSPascalCompiler);
procedure SIRegister_TJclFileSummary(CL: TPSPascalCompiler);
procedure SIRegister_TJclFilePropertySet(CL: TPSPascalCompiler);
procedure SIRegister_JclNTFS2(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJclJpegSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclImageInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclQuerySummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclLinkSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclShareSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclVolumeSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclControlPanelSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclAudioSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclVideoSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDRMSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMusicSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclWebViewSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMiscSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclBriefCaseSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDisplacedSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclImageSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclStorageSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclShellSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMSISummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclMediaFileSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclDocSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileSummaryInformation(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFileSummary(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclFilePropertySet(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclNTFS2_Routines(S: TPSExec);
procedure RIRegister_JclNTFS2(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //JclUnitVersioning
  Windows
  ,ActiveX
  ,JclBase
  ,JclWin32
  ,JclNTFS2
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclNTFS]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclJpegSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclJpegSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclJpegSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclImageInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclImageInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclImageInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclQuerySummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclQuerySummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclQuerySummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclLinkSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclLinkSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclLinkSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclShareSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclShareSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclShareSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclVolumeSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclVolumeSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclVolumeSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclControlPanelSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclControlPanelSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclControlPanelSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclAudioSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclAudioSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclAudioSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
    RegisterProperty('Format', 'WideString', iptrw);
    RegisterProperty('TimeLength', 'Cardinal', iptrw);
    RegisterProperty('AverageDataRate', 'Cardinal', iptrw);
    RegisterProperty('SampleRate', 'Cardinal', iptrw);
    RegisterProperty('SampleSize', 'Cardinal', iptrw);
    RegisterProperty('ChannelCount', 'Cardinal', iptrw);
    RegisterProperty('StreamNumber', 'Word', iptrw);
    RegisterProperty('StreamName', 'WideString', iptrw);
    RegisterProperty('Compression', 'WideString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclVideoSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclVideoSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclVideoSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
    RegisterProperty('StreamName', 'WideString', iptrw);
    RegisterProperty('Width', 'Cardinal', iptrw);
    RegisterProperty('Height', 'Cardinal', iptrw);
    RegisterProperty('TimeLength', 'Cardinal', iptrw);
    RegisterProperty('FrameCount', 'Cardinal', iptrw);
    RegisterProperty('FrameRate', 'Cardinal', iptrw);
    RegisterProperty('DataRate', 'Cardinal', iptrw);
    RegisterProperty('SampleSize', 'Cardinal', iptrw);
    RegisterProperty('Compression', 'WideString', iptrw);
    RegisterProperty('StreamNumber', 'Word', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDRMSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclDRMSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclDRMSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMusicSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclMusicSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclMusicSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclWebViewSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclWebViewSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclWebViewSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMiscSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclMiscSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclMiscSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclBriefCaseSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclBriefCaseSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclBriefCaseSummaryInformation') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDisplacedSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclDisplacedSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclDisplacedSummaryInformation') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclImageSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclImageSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclImageSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclStorageSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclStorageSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclStorageSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclShellSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclShellSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclShellSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMSISummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclMSISummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclMSISummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
    RegisterProperty('Version', 'Integer', iptrw);
    RegisterProperty('Source', 'Integer', iptrw);
    RegisterProperty('Restrict', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclMediaFileSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclMediaFileSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclMediaFileSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
    RegisterProperty('Editor', 'WideString', iptrw);
    RegisterProperty('Supplier', 'WideString', iptrw);
    RegisterProperty('Source', 'WideString', iptrw);
    RegisterProperty('SequenceNo', 'WideString', iptrw);
    RegisterProperty('Project', 'WideString', iptrw);
    RegisterProperty('Status', 'Cardinal', iptrw);
    RegisterProperty('Owner', 'WideString', iptrw);
    RegisterProperty('Rating', 'WideString', iptrw);
    RegisterProperty('Production', 'TFileTime', iptrw);
    RegisterProperty('Copyright', 'WideString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclDocSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclDocSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclDocSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
    RegisterProperty('Category', 'AnsiString', iptrw);
    RegisterProperty('PresFormat', 'AnsiString', iptrw);
    RegisterProperty('ByteCount', 'Integer', iptrw);
    RegisterProperty('LineCount', 'Integer', iptrw);
    RegisterProperty('ParCount', 'Integer', iptrw);
    RegisterProperty('SlideCount', 'Integer', iptrw);
    RegisterProperty('NoteCount', 'Integer', iptrw);
    RegisterProperty('HiddenCount', 'Integer', iptrw);
    RegisterProperty('MMClipCount', 'Integer', iptrw);
    RegisterProperty('Scale', 'Boolean', iptrw);
    RegisterProperty('HeadingPair', 'TCAPROPVARIANT', iptrw);
    RegisterProperty('DocParts', 'TCALPSTR', iptrw);
    RegisterProperty('Manager', 'AnsiString', iptrw);
    RegisterProperty('Company', 'AnsiString', iptrw);
    RegisterProperty('LinksDirty', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileSummaryInformation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclFilePropertySet', 'TJclFileSummaryInformation') do
  with CL.AddClassN(CL.FindClass('TJclFilePropertySet'),'TJclFileSummaryInformation') do
  begin
    RegisterMethod('Function GetFMTID : TGUID');
    RegisterProperty('Title', 'AnsiString', iptrw);
    RegisterProperty('Subject', 'AnsiString', iptrw);
    RegisterProperty('Author', 'AnsiString', iptrw);
    RegisterProperty('KeyWords', 'AnsiString', iptrw);
    RegisterProperty('Comments', 'AnsiString', iptrw);
    RegisterProperty('Template', 'AnsiString', iptrw);
    RegisterProperty('LastAuthor', 'AnsiString', iptrw);
    RegisterProperty('RevNumber', 'AnsiString', iptrw);
    RegisterProperty('EditTime', 'TFileTime', iptrw);
    RegisterProperty('LastPrintedTime', 'TFileTime', iptrw);
    RegisterProperty('CreationTime', 'TFileTime', iptrw);
    RegisterProperty('LastSaveTime', 'TFileTime', iptrw);
    RegisterProperty('PageCount', 'Integer', iptrw);
    RegisterProperty('WordCount', 'Integer', iptrw);
    RegisterProperty('CharCount', 'Integer', iptrw);
    RegisterProperty('Thumnail', 'PClipData', iptrw);
    RegisterProperty('AppName', 'AnsiString', iptrw);
    RegisterProperty('Security', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFileSummary(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJclFileSummary') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJclFileSummary') do begin
    RegisterMethod('Constructor Create( AFileName : WideString; AAccessMode : TJclFileSummaryAccess; AShareMode : TJclFileSummaryShare; AsDocument : Boolean; ACreate : Boolean)');
     RegisterMethod('Procedure Free;');
    RegisterMethod('Function CreatePropertySet( AClass : TJclFilePropertySetClass; ResetExisting : Boolean) : TJclFilePropertySet');
    RegisterMethod('Procedure GetPropertySet( AClass : TJclFilePropertySetClass; out Instance);');
    RegisterMethod('Procedure GetPropertySet1( const FMTID : TGUID; out Instance);');
    RegisterMethod('Function GetPropertySet2( const FMTID : TGUID) : IPropertyStorage;');
    RegisterMethod('Procedure DeletePropertySet( const FMTID : TGUID);');
    RegisterMethod('Procedure DeletePropertySet1( AClass : TJclFilePropertySetClass);');
    RegisterMethod('Function EnumPropertySet( Proc : TJclFileSummaryPropSetCallback) : Boolean');
    RegisterProperty('FileName', 'WideString', iptr);
    RegisterProperty('AccessMode', 'TJclFileSummaryAccess', iptr);
    RegisterProperty('ShareMode', 'TJclFileSummaryShare', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclFilePropertySet(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TJclFilePropertySet') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TJclFilePropertySet') do
  begin
    RegisterMethod('Constructor Create( APropertyStorage : IPropertyStorage)');
    RegisterMethod('Function GetFMTID : TGUID');
    RegisterMethod('Function GetProperty( ID : TPropID) : TPropVariant;');
    RegisterMethod('Function GetProperty1( const Name : WideString) : TPropVariant;');
    RegisterMethod('Procedure SetProperty( ID : TPropID; const Value : TPropVariant);');
    RegisterMethod('Procedure SetProperty1( const Name : WideString; const Value : TPropVariant; AllocationBase : TPropID);');
    RegisterMethod('Procedure DeleteProperty( ID : TPropID);');
    RegisterMethod('Procedure DeleteProperty1( const Name : WideString);');
    RegisterMethod('Function EnumProperties( Proc : TJclFileSummaryPropCallback) : Boolean');
    RegisterMethod('Function GetWideStringProperty( const ID : Integer) : WideString');
    RegisterMethod('Procedure SetWideStringProperty( const ID : Integer; const Value : WideString)');
    RegisterMethod('Function GetAnsiStringProperty( const ID : Integer) : AnsiString');
    RegisterMethod('Procedure SetAnsiStringProperty( const ID : Integer; const Value : AnsiString)');
    RegisterMethod('Function GetIntegerProperty( const ID : Integer) : Integer');
    RegisterMethod('Procedure SetIntegerProperty( const ID : Integer; const Value : Integer)');
    RegisterMethod('Function GetCardinalProperty( const ID : Integer) : Cardinal');
    RegisterMethod('Procedure SetCardinalProperty( const ID : Integer; const Value : Cardinal)');
    RegisterMethod('Function GetFileTimeProperty( const ID : Integer) : TFileTime');
    RegisterMethod('Procedure SetFileTimeProperty( const ID : Integer; const Value : TFileTime)');
    RegisterMethod('Function GetClipDataProperty( const ID : Integer) : PClipData');
    RegisterMethod('Procedure SetClipDataProperty( const ID : Integer; const Value : PClipData)');
    RegisterMethod('Function GetBooleanProperty( const ID : Integer) : Boolean');
    RegisterMethod('Procedure SetBooleanProperty( const ID : Integer; const Value : Boolean)');
    RegisterMethod('Function GetTCAPROPVARIANTProperty( const ID : Integer) : TCAPROPVARIANT');
    RegisterMethod('Procedure SetTCAPROPVARIANTProperty( const ID : Integer; const Value : TCAPROPVARIANT)');
    RegisterMethod('Function GetTCALPSTRProperty( const ID : Integer) : TCALPSTR');
    RegisterMethod('Procedure SetTCALPSTRProperty( const ID : Integer; const Value : TCALPSTR)');
    RegisterMethod('Function GetWordProperty( const ID : Integer) : Word');
    RegisterMethod('Procedure SetWordProperty( const ID : Integer; const Value : Word)');
    RegisterMethod('Function GetBSTRProperty( const ID : Integer) : WideString');
    RegisterMethod('Procedure SetBSTRProperty( const ID : Integer; const Value : WideString)');
    RegisterMethod('Function GetPropertyName( ID : TPropID) : WideString');
    RegisterMethod('Procedure SetPropertyName( ID : TPropID; const Name : WideString)');
    RegisterMethod('Procedure DeletePropertyName( ID : TPropID)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclNTFS2(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclNtfsError');
  CL.AddTypeS('TFileCompressionState', '( fcNoCompression, fcDefaultCompression, fcLZNT1Compression )');
 CL.AddDelphiFunction('Function NtfsGetCompression2( const FileName : TFileName; var State : Short) : Boolean;');
 CL.AddDelphiFunction('Function NtfsGetCompression12( const FileName : TFileName) : TFileCompressionState;');
 CL.AddDelphiFunction('Function NtfsSetCompression2( const FileName : TFileName; const State : Short) : Boolean');
 CL.AddDelphiFunction('Procedure NtfsSetFileCompression2( const FileName : TFileName; const State : TFileCompressionState)');
 CL.AddDelphiFunction('Procedure NtfsSetDirectoryTreeCompression2( const Directory : string; const State : TFileCompressionState)');
 CL.AddDelphiFunction('Procedure NtfsSetDefaultFileCompression2( const Directory : string; const State : TFileCompressionState)');
 CL.AddDelphiFunction('Procedure NtfsSetPathCompression2( const Path : string; const State : TFileCompressionState; Recursive : Boolean)');
 // CL.AddTypeS('TNtfsAllocRanges', 'record Entries : Integer; Data : PFileAllocatedRangeBuffer; MoreData : Boolean; end');
 CL.AddDelphiFunction('Function NtfsSetSparse2( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsZeroDataByHandle2( const Handle : THandle; const First, Last : Int64) : Boolean');
 CL.AddDelphiFunction('Function NtfsZeroDataByName2( const FileName : string; const First, Last : Int64) : Boolean');
 //CL.AddDelphiFunction('Function NtfsQueryAllocRanges( const FileName : string; Offset, Count : Int64; var Ranges : TNtfsAllocRanges) : Boolean');
 //CL.AddDelphiFunction('Function NtfsGetAllocRangeEntry( const Ranges : TNtfsAllocRanges; Index : Integer) : TFileAllocatedRangeBuffer');
 CL.AddDelphiFunction('Function NtfsSparseStreamsSupported2( const Volume : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsGetSparse2( const FileName : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsDeleteReparsePoint2( const FileName : string; ReparseTag : DWORD) : Boolean');
 CL.AddDelphiFunction('Function NtfsSetReparsePoint2( const FileName : string; var ReparseData, Size : Longword) : Boolean');
 //CL.AddDelphiFunction('Function NtfsGetReparsePoint( const FileName : string; var ReparseData : TReparseGuidDataBuffer) : Boolean');
 CL.AddDelphiFunction('Function NtfsGetReparseTag2( const Path : string; var Tag : DWORD) : Boolean');
 CL.AddDelphiFunction('Function NtfsReparsePointsSupported2( const Volume : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsFileHasReparsePoint2( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsIsFolderMountPoint2( const Path : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsMountDeviceAsDrive2( const Device : WideString; Drive : Char) : Boolean');
 CL.AddDelphiFunction('Function NtfsMountVolume2( const Volume : WideChar; const MountPoint : WideString) : Boolean');
  CL.AddTypeS('TOpLock', '( olExclusive, olReadOnly, olBatch, olFilter )');
 CL.AddDelphiFunction('Function NtfsOpLockAckClosePending2( Handle : THandle; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsOpLockBreakAckNo22( Handle : THandle; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsOpLockBreakAcknowledge2( Handle : THandle; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsOpLockBreakNotify2( Handle : THandle; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsRequestOpLock2( Handle : THandle; Kind : TOpLock; Overlapped : TOverlapped) : Boolean');
 CL.AddDelphiFunction('Function NtfsCreateJunctionPoint2( const Source, Destination : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsDeleteJunctionPoint2( const Source : string) : Boolean');
 CL.AddDelphiFunction('Function NtfsGetJunctionPointDestination2( const Source : string; var Destination : string) : Boolean');
  CL.AddTypeS('TStreamId', '( siInvalid, siStandard, siExtendedAttribute, siSec'
   +'urity, siAlternate, siHardLink, siProperty, siObjectIdentifier, siReparsePoints, siSparseFile )');
  CL.AddTypeS('TStreamIds', 'set of TStreamId');
  CL.AddTypeS('TInternalFindStreamData', 'record FileHandle : THandle; Context: TObject; StreamIds : TStreamIds; end');
  CL.AddTypeS('TFindStreamData', 'record Internal : TInternalFindStreamData; At'
  +'tributes : DWORD; StreamID : TStreamId; Name : WideString; Size : Int64; end');
 CL.AddDelphiFunction('Function NtfsFindFirstStream2( const FileName : string; StreamIds : TStreamIds; var Data : TFindStreamData) : Boolean');
 CL.AddDelphiFunction('Function NtfsFindNextStream2( var Data : TFindStreamData) : Boolean');
 CL.AddDelphiFunction('Function NtfsFindStreamClose2( var Data : TFindStreamData) : Boolean');
 CL.AddDelphiFunction('Function NtfsCreateHardLink2( const LinkFileName, ExistingFileName : String) : Boolean');
 CL.AddDelphiFunction('Function NtfsCreateHardLinkA2( const LinkFileName, ExistingFileName : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function NtfsCreateHardLinkW2( const LinkFileName, ExistingFileName : WideString) : Boolean');
  CL.AddTypeS('TNtfsHardLinkInfo', 'record LinkCount : Cardinal; FileIndex : Int64; end');
 CL.AddDelphiFunction('Function NtfsGetHardLinkInfo2( const FileName : string; var Info : TNtfsHardLinkInfo) : Boolean');
 CL.AddDelphiFunction('Function NtfsFindHardLinks2( const Path : string; const FileIndexHigh, FileIndexLow : Cardinal; const List : TStrings) : Boolean');
 CL.AddDelphiFunction('Function NtfsDeleteHardLinks2( const FileName : string) : Boolean');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EJclFileSummaryError');
  CL.AddTypeS('TJclFileSummaryAccess', '( fsaRead, fsaWrite, fsaReadWrite )');
  CL.AddTypeS('TJclFileSummaryShare', '( fssDenyNone, fssDenyRead, fssDenyWrite, fssDenyAll )');
  CL.AddTypeS('TJclFileSummaryPropSetCallback', 'Function ( const FMTID : TGUID) : Boolean');
 // CL.AddTypeS('TJclFileSummaryPropCallback', 'Function ( const Name : WideString; ID : TPropID; Vt : TVarType) : Boolean');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclFileSummary');
  SIRegister_TJclFilePropertySet(CL);
  //CL.AddTypeS('TJclFilePropertySetClass', 'class of TJclFilePropertySet');
  CL.AddTypeS('TJclFilePropertySetClass', 'TJclFilePropertySet');
  SIRegister_TJclFileSummary(CL);
  SIRegister_TJclFileSummaryInformation(CL);
  SIRegister_TJclDocSummaryInformation(CL);
  SIRegister_TJclMediaFileSummaryInformation(CL);
  SIRegister_TJclMSISummaryInformation(CL);
  SIRegister_TJclShellSummaryInformation(CL);
  SIRegister_TJclStorageSummaryInformation(CL);
  SIRegister_TJclImageSummaryInformation(CL);
  SIRegister_TJclDisplacedSummaryInformation(CL);
  SIRegister_TJclBriefCaseSummaryInformation(CL);
  SIRegister_TJclMiscSummaryInformation(CL);
  SIRegister_TJclWebViewSummaryInformation(CL);
  SIRegister_TJclMusicSummaryInformation(CL);
  SIRegister_TJclDRMSummaryInformation(CL);
  SIRegister_TJclVideoSummaryInformation(CL);
  SIRegister_TJclAudioSummaryInformation(CL);
  SIRegister_TJclControlPanelSummaryInformation(CL);
  SIRegister_TJclVolumeSummaryInformation(CL);
  SIRegister_TJclShareSummaryInformation(CL);
  SIRegister_TJclLinkSummaryInformation(CL);
  SIRegister_TJclQuerySummaryInformation(CL);
  SIRegister_TJclImageInformation(CL);
  SIRegister_TJclJpegSummaryInformation(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
{procedure TJclAudioSummaryInformationCompression_W(Self: TJclAudioSummaryInformation; const T: WideString);
begin Self.Compression := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationCompression_R(Self: TJclAudioSummaryInformation; var T: WideString);
begin T := Self.Compression; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationStreamName_W(Self: TJclAudioSummaryInformation; const T: WideString);
begin Self.StreamName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationStreamName_R(Self: TJclAudioSummaryInformation; var T: WideString);
begin T := Self.StreamName; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationStreamNumber_W(Self: TJclAudioSummaryInformation; const T: Word);
begin Self.StreamNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationStreamNumber_R(Self: TJclAudioSummaryInformation; var T: Word);
begin T := Self.StreamNumber; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationChannelCount_W(Self: TJclAudioSummaryInformation; const T: Cardinal);
begin Self.ChannelCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationChannelCount_R(Self: TJclAudioSummaryInformation; var T: Cardinal);
begin T := Self.ChannelCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationSampleSize_W(Self: TJclAudioSummaryInformation; const T: Cardinal);
begin Self.SampleSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationSampleSize_R(Self: TJclAudioSummaryInformation; var T: Cardinal);
begin T := Self.SampleSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationSampleRate_W(Self: TJclAudioSummaryInformation; const T: Cardinal);
begin Self.SampleRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationSampleRate_R(Self: TJclAudioSummaryInformation; var T: Cardinal);
begin T := Self.SampleRate; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationAverageDataRate_W(Self: TJclAudioSummaryInformation; const T: Cardinal);
begin Self.AverageDataRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationAverageDataRate_R(Self: TJclAudioSummaryInformation; var T: Cardinal);
begin T := Self.AverageDataRate; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationTimeLength_W(Self: TJclAudioSummaryInformation; const T: Cardinal);
begin Self.TimeLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationTimeLength_R(Self: TJclAudioSummaryInformation; var T: Cardinal);
begin T := Self.TimeLength; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationFormat_W(Self: TJclAudioSummaryInformation; const T: WideString);
begin Self.Format := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclAudioSummaryInformationFormat_R(Self: TJclAudioSummaryInformation; var T: WideString);
begin T := Self.Format; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationStreamNumber_W(Self: TJclVideoSummaryInformation; const T: Word);
begin Self.StreamNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationStreamNumber_R(Self: TJclVideoSummaryInformation; var T: Word);
begin T := Self.StreamNumber; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationCompression_W(Self: TJclVideoSummaryInformation; const T: WideString);
begin Self.Compression := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationCompression_R(Self: TJclVideoSummaryInformation; var T: WideString);
begin T := Self.Compression; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationSampleSize_W(Self: TJclVideoSummaryInformation; const T: Cardinal);
begin Self.SampleSize := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationSampleSize_R(Self: TJclVideoSummaryInformation; var T: Cardinal);
begin T := Self.SampleSize; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationDataRate_W(Self: TJclVideoSummaryInformation; const T: Cardinal);
begin Self.DataRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationDataRate_R(Self: TJclVideoSummaryInformation; var T: Cardinal);
begin T := Self.DataRate; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationFrameRate_W(Self: TJclVideoSummaryInformation; const T: Cardinal);
begin Self.FrameRate := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationFrameRate_R(Self: TJclVideoSummaryInformation; var T: Cardinal);
begin T := Self.FrameRate; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationFrameCount_W(Self: TJclVideoSummaryInformation; const T: Cardinal);
begin Self.FrameCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationFrameCount_R(Self: TJclVideoSummaryInformation; var T: Cardinal);
begin T := Self.FrameCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationTimeLength_W(Self: TJclVideoSummaryInformation; const T: Cardinal);
begin Self.TimeLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationTimeLength_R(Self: TJclVideoSummaryInformation; var T: Cardinal);
begin T := Self.TimeLength; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationHeight_W(Self: TJclVideoSummaryInformation; const T: Cardinal);
begin Self.Height := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationHeight_R(Self: TJclVideoSummaryInformation; var T: Cardinal);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationWidth_W(Self: TJclVideoSummaryInformation; const T: Cardinal);
begin Self.Width := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationWidth_R(Self: TJclVideoSummaryInformation; var T: Cardinal);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationStreamName_W(Self: TJclVideoSummaryInformation; const T: WideString);
begin Self.StreamName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclVideoSummaryInformationStreamName_R(Self: TJclVideoSummaryInformation; var T: WideString);
begin T := Self.StreamName; end;

(*----------------------------------------------------------------------------*)
procedure TJclMSISummaryInformationRestrict_W(Self: TJclMSISummaryInformation; const T: Integer);
begin Self.Restrict := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMSISummaryInformationRestrict_R(Self: TJclMSISummaryInformation; var T: Integer);
begin T := Self.Restrict; end;

(*----------------------------------------------------------------------------*)
procedure TJclMSISummaryInformationSource_W(Self: TJclMSISummaryInformation; const T: Integer);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMSISummaryInformationSource_R(Self: TJclMSISummaryInformation; var T: Integer);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TJclMSISummaryInformationVersion_W(Self: TJclMSISummaryInformation; const T: Integer);
begin Self.Version := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMSISummaryInformationVersion_R(Self: TJclMSISummaryInformation; var T: Integer);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationCopyright_W(Self: TJclMediaFileSummaryInformation; const T: WideString);
begin Self.Copyright := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationCopyright_R(Self: TJclMediaFileSummaryInformation; var T: WideString);
begin T := Self.Copyright; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationProduction_W(Self: TJclMediaFileSummaryInformation; const T: TFileTime);
begin Self.Production := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationProduction_R(Self: TJclMediaFileSummaryInformation; var T: TFileTime);
begin T := Self.Production; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationRating_W(Self: TJclMediaFileSummaryInformation; const T: WideString);
begin Self.Rating := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationRating_R(Self: TJclMediaFileSummaryInformation; var T: WideString);
begin T := Self.Rating; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationOwner_W(Self: TJclMediaFileSummaryInformation; const T: WideString);
begin Self.Owner := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationOwner_R(Self: TJclMediaFileSummaryInformation; var T: WideString);
begin T := Self.Owner; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationStatus_W(Self: TJclMediaFileSummaryInformation; const T: Cardinal);
begin Self.Status := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationStatus_R(Self: TJclMediaFileSummaryInformation; var T: Cardinal);
begin T := Self.Status; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationProject_W(Self: TJclMediaFileSummaryInformation; const T: WideString);
begin Self.Project := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationProject_R(Self: TJclMediaFileSummaryInformation; var T: WideString);
begin T := Self.Project; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationSequenceNo_W(Self: TJclMediaFileSummaryInformation; const T: WideString);
begin Self.SequenceNo := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationSequenceNo_R(Self: TJclMediaFileSummaryInformation; var T: WideString);
begin T := Self.SequenceNo; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationSource_W(Self: TJclMediaFileSummaryInformation; const T: WideString);
begin Self.Source := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationSource_R(Self: TJclMediaFileSummaryInformation; var T: WideString);
begin T := Self.Source; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationSupplier_W(Self: TJclMediaFileSummaryInformation; const T: WideString);
begin Self.Supplier := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationSupplier_R(Self: TJclMediaFileSummaryInformation; var T: WideString);
begin T := Self.Supplier; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationEditor_W(Self: TJclMediaFileSummaryInformation; const T: WideString);
begin Self.Editor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclMediaFileSummaryInformationEditor_R(Self: TJclMediaFileSummaryInformation; var T: WideString);
begin T := Self.Editor; end;      // }

(*----------------------------------------------------------------------------*)
{procedure TJclDocSummaryInformationLinksDirty_W(Self: TJclDocSummaryInformation; const T: Boolean);
begin Self.LinksDirty := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationLinksDirty_R(Self: TJclDocSummaryInformation; var T: Boolean);
begin T := Self.LinksDirty; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationCompany_W(Self: TJclDocSummaryInformation; const T: AnsiString);
begin Self.Company := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationCompany_R(Self: TJclDocSummaryInformation; var T: AnsiString);
begin T := Self.Company; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationManager_W(Self: TJclDocSummaryInformation; const T: AnsiString);
begin Self.Manager := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationManager_R(Self: TJclDocSummaryInformation; var T: AnsiString);
begin T := Self.Manager; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationDocParts_W(Self: TJclDocSummaryInformation; const T: TCALPSTR);
begin Self.DocParts := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationDocParts_R(Self: TJclDocSummaryInformation; var T: TCALPSTR);
begin T := Self.DocParts; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationHeadingPair_W(Self: TJclDocSummaryInformation; const T: TCAPROPVARIANT);
begin Self.HeadingPair := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationHeadingPair_R(Self: TJclDocSummaryInformation; var T: TCAPROPVARIANT);
begin T := Self.HeadingPair; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationScale_W(Self: TJclDocSummaryInformation; const T: Boolean);
begin Self.Scale := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationScale_R(Self: TJclDocSummaryInformation; var T: Boolean);
begin T := Self.Scale; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationMMClipCount_W(Self: TJclDocSummaryInformation; const T: Integer);
begin Self.MMClipCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationMMClipCount_R(Self: TJclDocSummaryInformation; var T: Integer);
begin T := Self.MMClipCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationHiddenCount_W(Self: TJclDocSummaryInformation; const T: Integer);
begin Self.HiddenCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationHiddenCount_R(Self: TJclDocSummaryInformation; var T: Integer);
begin T := Self.HiddenCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationNoteCount_W(Self: TJclDocSummaryInformation; const T: Integer);
begin Self.NoteCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationNoteCount_R(Self: TJclDocSummaryInformation; var T: Integer);
begin T := Self.NoteCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationSlideCount_W(Self: TJclDocSummaryInformation; const T: Integer);
begin Self.SlideCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationSlideCount_R(Self: TJclDocSummaryInformation; var T: Integer);
begin T := Self.SlideCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationParCount_W(Self: TJclDocSummaryInformation; const T: Integer);
begin Self.ParCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationParCount_R(Self: TJclDocSummaryInformation; var T: Integer);
begin T := Self.ParCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationLineCount_W(Self: TJclDocSummaryInformation; const T: Integer);
begin Self.LineCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationLineCount_R(Self: TJclDocSummaryInformation; var T: Integer);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationByteCount_W(Self: TJclDocSummaryInformation; const T: Integer);
begin Self.ByteCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationByteCount_R(Self: TJclDocSummaryInformation; var T: Integer);
begin T := Self.ByteCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationPresFormat_W(Self: TJclDocSummaryInformation; const T: AnsiString);
begin Self.PresFormat := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationPresFormat_R(Self: TJclDocSummaryInformation; var T: AnsiString);
begin T := Self.PresFormat; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationCategory_W(Self: TJclDocSummaryInformation; const T: AnsiString);
begin Self.Category := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclDocSummaryInformationCategory_R(Self: TJclDocSummaryInformation; var T: AnsiString);
begin T := Self.Category; end;    }

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationSecurity_W(Self: TJclFileSummaryInformation; const T: Integer);
begin Self.Security := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationSecurity_R(Self: TJclFileSummaryInformation; var T: Integer);
begin T := Self.Security; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationAppName_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.AppName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationAppName_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.AppName; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationThumnail_W(Self: TJclFileSummaryInformation; const T: PClipData);
begin Self.Thumnail := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationThumnail_R(Self: TJclFileSummaryInformation; var T: PClipData);
begin T := Self.Thumnail; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationCharCount_W(Self: TJclFileSummaryInformation; const T: Integer);
begin Self.CharCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationCharCount_R(Self: TJclFileSummaryInformation; var T: Integer);
begin T := Self.CharCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationWordCount_W(Self: TJclFileSummaryInformation; const T: Integer);
begin Self.WordCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationWordCount_R(Self: TJclFileSummaryInformation; var T: Integer);
begin T := Self.WordCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationPageCount_W(Self: TJclFileSummaryInformation; const T: Integer);
begin Self.PageCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationPageCount_R(Self: TJclFileSummaryInformation; var T: Integer);
begin T := Self.PageCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationLastSaveTime_W(Self: TJclFileSummaryInformation; const T: TFileTime);
begin Self.LastSaveTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationLastSaveTime_R(Self: TJclFileSummaryInformation; var T: TFileTime);
begin T := Self.LastSaveTime; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationCreationTime_W(Self: TJclFileSummaryInformation; const T: TFileTime);
begin Self.CreationTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationCreationTime_R(Self: TJclFileSummaryInformation; var T: TFileTime);
begin T := Self.CreationTime; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationLastPrintedTime_W(Self: TJclFileSummaryInformation; const T: TFileTime);
begin Self.LastPrintedTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationLastPrintedTime_R(Self: TJclFileSummaryInformation; var T: TFileTime);
begin T := Self.LastPrintedTime; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationEditTime_W(Self: TJclFileSummaryInformation; const T: TFileTime);
begin Self.EditTime := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationEditTime_R(Self: TJclFileSummaryInformation; var T: TFileTime);
begin T := Self.EditTime; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationRevNumber_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.RevNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationRevNumber_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.RevNumber; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationLastAuthor_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.LastAuthor := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationLastAuthor_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.LastAuthor; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationTemplate_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.Template := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationTemplate_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.Template; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationComments_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.Comments := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationComments_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.Comments; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationKeyWords_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.KeyWords := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationKeyWords_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.KeyWords; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationAuthor_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.Author := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationAuthor_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.Author; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationSubject_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.Subject := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationSubject_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.Subject; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationTitle_W(Self: TJclFileSummaryInformation; const T: AnsiString);
begin Self.Title := T; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryInformationTitle_R(Self: TJclFileSummaryInformation; var T: AnsiString);
begin T := Self.Title; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryShareMode_R(Self: TJclFileSummary; var T: TJclFileSummaryShare);
begin T := Self.ShareMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryAccessMode_R(Self: TJclFileSummary; var T: TJclFileSummaryAccess);
begin T := Self.AccessMode; end;

(*----------------------------------------------------------------------------*)
procedure TJclFileSummaryFileName_R(Self: TJclFileSummary; var T: WideString);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
Procedure TJclFileSummaryDeletePropertySet1_P(Self: TJclFileSummary;  AClass : TJclFilePropertySetClass);
Begin Self.DeletePropertySet(AClass); END;

(*----------------------------------------------------------------------------*)
Procedure TJclFileSummaryDeletePropertySet_P(Self: TJclFileSummary;  const FMTID : TGUID);
Begin Self.DeletePropertySet(FMTID); END;

(*----------------------------------------------------------------------------*)
Function TJclFileSummaryGetPropertySet2_P(Self: TJclFileSummary;  const FMTID : TGUID) : IPropertyStorage;
Begin Result := Self.GetPropertySet(FMTID); END;

(*----------------------------------------------------------------------------*)
Procedure TJclFileSummaryGetPropertySet1_P(Self: TJclFileSummary;  const FMTID : TGUID; out Instance);
Begin Self.GetPropertySet(FMTID, Instance); END;

(*----------------------------------------------------------------------------*)
Procedure TJclFileSummaryGetPropertySet_P(Self: TJclFileSummary;  AClass : TJclFilePropertySetClass; out Instance);
Begin Self.GetPropertySet(AClass, Instance); END;

(*----------------------------------------------------------------------------*)
Procedure TJclFilePropertySetDeleteProperty1_P(Self: TJclFilePropertySet;  const Name : WideString);
Begin Self.DeleteProperty(Name); END;

(*----------------------------------------------------------------------------*)
Procedure TJclFilePropertySetDeleteProperty_P(Self: TJclFilePropertySet;  ID : TPropID);
Begin Self.DeleteProperty(ID); END;

(*----------------------------------------------------------------------------*)
Procedure TJclFilePropertySetSetProperty1_P(Self: TJclFilePropertySet;  const Name : WideString; const Value : TPropVariant; AllocationBase : TPropID);
Begin Self.SetProperty(Name, Value, AllocationBase); END;

(*----------------------------------------------------------------------------*)
Procedure TJclFilePropertySetSetProperty_P(Self: TJclFilePropertySet;  ID : TPropID; const Value : TPropVariant);
Begin Self.SetProperty(ID, Value); END;

(*----------------------------------------------------------------------------*)
Function TJclFilePropertySetGetProperty1_P(Self: TJclFilePropertySet;  const Name : WideString) : TPropVariant;
Begin Result := Self.GetProperty(Name); END;

(*----------------------------------------------------------------------------*)
Function TJclFilePropertySetGetProperty_P(Self: TJclFilePropertySet;  ID : TPropID) : TPropVariant;
Begin Result := Self.GetProperty(ID); END;

(*----------------------------------------------------------------------------*)
Function NtfsGetCompression1_P( const FileName : TFileName) : TFileCompressionState;
Begin Result := JclNTFS2.NtfsGetCompression(FileName); END;

(*----------------------------------------------------------------------------*)
Function NtfsGetCompression_P( const FileName : TFileName; var State : Short) : Boolean;
Begin Result := JclNTFS2.NtfsGetCompression(FileName, State); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclJpegSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclJpegSummaryInformation) do
  begin
    RegisterMethod(@TJclJpegSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclImageInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclImageInformation) do
  begin
    RegisterMethod(@TJclImageInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclQuerySummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclQuerySummaryInformation) do
  begin
    RegisterMethod(@TJclQuerySummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclLinkSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclLinkSummaryInformation) do
  begin
    RegisterMethod(@TJclLinkSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclShareSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclShareSummaryInformation) do
  begin
    RegisterMethod(@TJclShareSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclVolumeSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclVolumeSummaryInformation) do
  begin
    RegisterMethod(@TJclVolumeSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclControlPanelSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclControlPanelSummaryInformation) do
  begin
    RegisterMethod(@TJclControlPanelSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclAudioSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  {with CL.Add(TJclAudioSummaryInformation) do
  begin
    RegisterMethod(@TJclAudioSummaryInformation.GetFMTID, 'GetFMTID');
    RegisterPropertyHelper(@TJclAudioSummaryInformationFormat_R,@TJclAudioSummaryInformationFormat_W,'Format');
    RegisterPropertyHelper(@TJclAudioSummaryInformationTimeLength_R,@TJclAudioSummaryInformationTimeLength_W,'TimeLength');
    RegisterPropertyHelper(@TJclAudioSummaryInformationAverageDataRate_R,@TJclAudioSummaryInformationAverageDataRate_W,'AverageDataRate');
    RegisterPropertyHelper(@TJclAudioSummaryInformationSampleRate_R,@TJclAudioSummaryInformationSampleRate_W,'SampleRate');
    RegisterPropertyHelper(@TJclAudioSummaryInformationSampleSize_R,@TJclAudioSummaryInformationSampleSize_W,'SampleSize');
    RegisterPropertyHelper(@TJclAudioSummaryInformationChannelCount_R,@TJclAudioSummaryInformationChannelCount_W,'ChannelCount');
    RegisterPropertyHelper(@TJclAudioSummaryInformationStreamNumber_R,@TJclAudioSummaryInformationStreamNumber_W,'StreamNumber');
    RegisterPropertyHelper(@TJclAudioSummaryInformationStreamName_R,@TJclAudioSummaryInformationStreamName_W,'StreamName');
    RegisterPropertyHelper(@TJclAudioSummaryInformationCompression_R,@TJclAudioSummaryInformationCompression_W,'Compression');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclVideoSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  {with CL.Add(TJclVideoSummaryInformation) do
  begin
    RegisterMethod(@TJclVideoSummaryInformation.GetFMTID, 'GetFMTID');
    RegisterPropertyHelper(@TJclVideoSummaryInformationStreamName_R,@TJclVideoSummaryInformationStreamName_W,'StreamName');
    RegisterPropertyHelper(@TJclVideoSummaryInformationWidth_R,@TJclVideoSummaryInformationWidth_W,'Width');
    RegisterPropertyHelper(@TJclVideoSummaryInformationHeight_R,@TJclVideoSummaryInformationHeight_W,'Height');
    RegisterPropertyHelper(@TJclVideoSummaryInformationTimeLength_R,@TJclVideoSummaryInformationTimeLength_W,'TimeLength');
    RegisterPropertyHelper(@TJclVideoSummaryInformationFrameCount_R,@TJclVideoSummaryInformationFrameCount_W,'FrameCount');
    RegisterPropertyHelper(@TJclVideoSummaryInformationFrameRate_R,@TJclVideoSummaryInformationFrameRate_W,'FrameRate');
    RegisterPropertyHelper(@TJclVideoSummaryInformationDataRate_R,@TJclVideoSummaryInformationDataRate_W,'DataRate');
    RegisterPropertyHelper(@TJclVideoSummaryInformationSampleSize_R,@TJclVideoSummaryInformationSampleSize_W,'SampleSize');
    RegisterPropertyHelper(@TJclVideoSummaryInformationCompression_R,@TJclVideoSummaryInformationCompression_W,'Compression');
    RegisterPropertyHelper(@TJclVideoSummaryInformationStreamNumber_R,@TJclVideoSummaryInformationStreamNumber_W,'StreamNumber');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDRMSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclDRMSummaryInformation) do
  begin
    RegisterMethod(@TJclDRMSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMusicSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMusicSummaryInformation) do
  begin
    RegisterMethod(@TJclMusicSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclWebViewSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclWebViewSummaryInformation) do
  begin
    RegisterMethod(@TJclWebViewSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMiscSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclMiscSummaryInformation) do
  begin
    RegisterMethod(@TJclMiscSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclBriefCaseSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclBriefCaseSummaryInformation) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDisplacedSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclDisplacedSummaryInformation) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclImageSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclImageSummaryInformation) do
  begin
    RegisterMethod(@TJclImageSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclStorageSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclStorageSummaryInformation) do
  begin
    RegisterMethod(@TJclStorageSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclShellSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclShellSummaryInformation) do
  begin
    RegisterMethod(@TJclShellSummaryInformation.GetFMTID, 'GetFMTID');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMSISummaryInformation(CL: TPSRuntimeClassImporter);
begin
  {with CL.Add(TJclMSISummaryInformation) do
  begin
    RegisterMethod(@TJclMSISummaryInformation.GetFMTID, 'GetFMTID');
    RegisterPropertyHelper(@TJclMSISummaryInformationVersion_R,@TJclMSISummaryInformationVersion_W,'Version');
    RegisterPropertyHelper(@TJclMSISummaryInformationSource_R,@TJclMSISummaryInformationSource_W,'Source');
    RegisterPropertyHelper(@TJclMSISummaryInformationRestrict_R,@TJclMSISummaryInformationRestrict_W,'Restrict');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclMediaFileSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  {with CL.Add(TJclMediaFileSummaryInformation) do
  begin
    RegisterMethod(@TJclMediaFileSummaryInformation.GetFMTID, 'GetFMTID');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationEditor_R,@TJclMediaFileSummaryInformationEditor_W,'Editor');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationSupplier_R,@TJclMediaFileSummaryInformationSupplier_W,'Supplier');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationSource_R,@TJclMediaFileSummaryInformationSource_W,'Source');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationSequenceNo_R,@TJclMediaFileSummaryInformationSequenceNo_W,'SequenceNo');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationProject_R,@TJclMediaFileSummaryInformationProject_W,'Project');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationStatus_R,@TJclMediaFileSummaryInformationStatus_W,'Status');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationOwner_R,@TJclMediaFileSummaryInformationOwner_W,'Owner');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationRating_R,@TJclMediaFileSummaryInformationRating_W,'Rating');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationProduction_R,@TJclMediaFileSummaryInformationProduction_W,'Production');
    RegisterPropertyHelper(@TJclMediaFileSummaryInformationCopyright_R,@TJclMediaFileSummaryInformationCopyright_W,'Copyright');
  end;}
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclDocSummaryInformation(CL: TPSRuntimeClassImporter);
begin
 { with CL.Add(TJclDocSummaryInformation) do
  begin
    RegisterMethod(@TJclDocSummaryInformation.GetFMTID, 'GetFMTID');
    RegisterPropertyHelper(@TJclDocSummaryInformationCategory_R,@TJclDocSummaryInformationCategory_W,'Category');
    RegisterPropertyHelper(@TJclDocSummaryInformationPresFormat_R,@TJclDocSummaryInformationPresFormat_W,'PresFormat');
    RegisterPropertyHelper(@TJclDocSummaryInformationByteCount_R,@TJclDocSummaryInformationByteCount_W,'ByteCount');
    RegisterPropertyHelper(@TJclDocSummaryInformationLineCount_R,@TJclDocSummaryInformationLineCount_W,'LineCount');
    RegisterPropertyHelper(@TJclDocSummaryInformationParCount_R,@TJclDocSummaryInformationParCount_W,'ParCount');
    RegisterPropertyHelper(@TJclDocSummaryInformationSlideCount_R,@TJclDocSummaryInformationSlideCount_W,'SlideCount');
    RegisterPropertyHelper(@TJclDocSummaryInformationNoteCount_R,@TJclDocSummaryInformationNoteCount_W,'NoteCount');
    RegisterPropertyHelper(@TJclDocSummaryInformationHiddenCount_R,@TJclDocSummaryInformationHiddenCount_W,'HiddenCount');
    RegisterPropertyHelper(@TJclDocSummaryInformationMMClipCount_R,@TJclDocSummaryInformationMMClipCount_W,'MMClipCount');
    RegisterPropertyHelper(@TJclDocSummaryInformationScale_R,@TJclDocSummaryInformationScale_W,'Scale');
    RegisterPropertyHelper(@TJclDocSummaryInformationHeadingPair_R,@TJclDocSummaryInformationHeadingPair_W,'HeadingPair');
    RegisterPropertyHelper(@TJclDocSummaryInformationDocParts_R,@TJclDocSummaryInformationDocParts_W,'DocParts');
    RegisterPropertyHelper(@TJclDocSummaryInformationManager_R,@TJclDocSummaryInformationManager_W,'Manager');
    RegisterPropertyHelper(@TJclDocSummaryInformationCompany_R,@TJclDocSummaryInformationCompany_W,'Company');
    RegisterPropertyHelper(@TJclDocSummaryInformationLinksDirty_R,@TJclDocSummaryInformationLinksDirty_W,'LinksDirty');
  end; }
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileSummaryInformation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileSummaryInformation) do
  begin
    RegisterMethod(@TJclFileSummaryInformation.GetFMTID, 'GetFMTID');
    RegisterPropertyHelper(@TJclFileSummaryInformationTitle_R,@TJclFileSummaryInformationTitle_W,'Title');
    RegisterPropertyHelper(@TJclFileSummaryInformationSubject_R,@TJclFileSummaryInformationSubject_W,'Subject');
    RegisterPropertyHelper(@TJclFileSummaryInformationAuthor_R,@TJclFileSummaryInformationAuthor_W,'Author');
    RegisterPropertyHelper(@TJclFileSummaryInformationKeyWords_R,@TJclFileSummaryInformationKeyWords_W,'KeyWords');
    RegisterPropertyHelper(@TJclFileSummaryInformationComments_R,@TJclFileSummaryInformationComments_W,'Comments');
    RegisterPropertyHelper(@TJclFileSummaryInformationTemplate_R,@TJclFileSummaryInformationTemplate_W,'Template');
    RegisterPropertyHelper(@TJclFileSummaryInformationLastAuthor_R,@TJclFileSummaryInformationLastAuthor_W,'LastAuthor');
    RegisterPropertyHelper(@TJclFileSummaryInformationRevNumber_R,@TJclFileSummaryInformationRevNumber_W,'RevNumber');
    RegisterPropertyHelper(@TJclFileSummaryInformationEditTime_R,@TJclFileSummaryInformationEditTime_W,'EditTime');
    RegisterPropertyHelper(@TJclFileSummaryInformationLastPrintedTime_R,@TJclFileSummaryInformationLastPrintedTime_W,'LastPrintedTime');
    RegisterPropertyHelper(@TJclFileSummaryInformationCreationTime_R,@TJclFileSummaryInformationCreationTime_W,'CreationTime');
    RegisterPropertyHelper(@TJclFileSummaryInformationLastSaveTime_R,@TJclFileSummaryInformationLastSaveTime_W,'LastSaveTime');
    RegisterPropertyHelper(@TJclFileSummaryInformationPageCount_R,@TJclFileSummaryInformationPageCount_W,'PageCount');
    RegisterPropertyHelper(@TJclFileSummaryInformationWordCount_R,@TJclFileSummaryInformationWordCount_W,'WordCount');
    RegisterPropertyHelper(@TJclFileSummaryInformationCharCount_R,@TJclFileSummaryInformationCharCount_W,'CharCount');
    RegisterPropertyHelper(@TJclFileSummaryInformationThumnail_R,@TJclFileSummaryInformationThumnail_W,'Thumnail');
    RegisterPropertyHelper(@TJclFileSummaryInformationAppName_R,@TJclFileSummaryInformationAppName_W,'AppName');
    RegisterPropertyHelper(@TJclFileSummaryInformationSecurity_R,@TJclFileSummaryInformationSecurity_W,'Security');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFileSummary(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFileSummary) do
  begin
    RegisterConstructor(@TJclFileSummary.Create, 'Create');
    RegisterMethod(@TJclFileSummary.Destroy, 'Free');
    RegisterMethod(@TJclFileSummary.CreatePropertySet, 'CreatePropertySet');
    RegisterMethod(@TJclFileSummaryGetPropertySet_P, 'GetPropertySet');
    RegisterMethod(@TJclFileSummaryGetPropertySet1_P, 'GetPropertySet1');
    RegisterMethod(@TJclFileSummaryGetPropertySet2_P, 'GetPropertySet2');
    RegisterMethod(@TJclFileSummaryDeletePropertySet_P, 'DeletePropertySet');
    RegisterMethod(@TJclFileSummaryDeletePropertySet1_P, 'DeletePropertySet1');
    RegisterMethod(@TJclFileSummary.EnumPropertySet, 'EnumPropertySet');
    RegisterPropertyHelper(@TJclFileSummaryFileName_R,nil,'FileName');
    RegisterPropertyHelper(@TJclFileSummaryAccessMode_R,nil,'AccessMode');
    RegisterPropertyHelper(@TJclFileSummaryShareMode_R,nil,'ShareMode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclFilePropertySet(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclFilePropertySet) do
  begin
    RegisterConstructor(@TJclFilePropertySet.Create, 'Create');
    RegisterVirtualMethod(@TJclFilePropertySet.GetFMTID, 'GetFMTID');
    RegisterMethod(@TJclFilePropertySetGetProperty_P, 'GetProperty');
    RegisterMethod(@TJclFilePropertySetGetProperty1_P, 'GetProperty1');
    RegisterMethod(@TJclFilePropertySetSetProperty_P, 'SetProperty');
    RegisterMethod(@TJclFilePropertySetSetProperty1_P, 'SetProperty1');
    RegisterMethod(@TJclFilePropertySetDeleteProperty_P, 'DeleteProperty');
    RegisterMethod(@TJclFilePropertySetDeleteProperty1_P, 'DeleteProperty1');
    RegisterMethod(@TJclFilePropertySet.EnumProperties, 'EnumProperties');
    RegisterMethod(@TJclFilePropertySet.GetWideStringProperty, 'GetWideStringProperty');
    RegisterMethod(@TJclFilePropertySet.SetWideStringProperty, 'SetWideStringProperty');
    RegisterMethod(@TJclFilePropertySet.GetAnsiStringProperty, 'GetAnsiStringProperty');
    RegisterMethod(@TJclFilePropertySet.SetAnsiStringProperty, 'SetAnsiStringProperty');
    RegisterMethod(@TJclFilePropertySet.GetIntegerProperty, 'GetIntegerProperty');
    RegisterMethod(@TJclFilePropertySet.SetIntegerProperty, 'SetIntegerProperty');
    RegisterMethod(@TJclFilePropertySet.GetCardinalProperty, 'GetCardinalProperty');
    RegisterMethod(@TJclFilePropertySet.SetCardinalProperty, 'SetCardinalProperty');
    RegisterMethod(@TJclFilePropertySet.GetFileTimeProperty, 'GetFileTimeProperty');
    RegisterMethod(@TJclFilePropertySet.SetFileTimeProperty, 'SetFileTimeProperty');
    RegisterMethod(@TJclFilePropertySet.GetClipDataProperty, 'GetClipDataProperty');
    RegisterMethod(@TJclFilePropertySet.SetClipDataProperty, 'SetClipDataProperty');
    RegisterMethod(@TJclFilePropertySet.GetBooleanProperty, 'GetBooleanProperty');
    RegisterMethod(@TJclFilePropertySet.SetBooleanProperty, 'SetBooleanProperty');
    RegisterMethod(@TJclFilePropertySet.GetTCAPROPVARIANTProperty, 'GetTCAPROPVARIANTProperty');
    RegisterMethod(@TJclFilePropertySet.SetTCAPROPVARIANTProperty, 'SetTCAPROPVARIANTProperty');
    RegisterMethod(@TJclFilePropertySet.GetTCALPSTRProperty, 'GetTCALPSTRProperty');
    RegisterMethod(@TJclFilePropertySet.SetTCALPSTRProperty, 'SetTCALPSTRProperty');
    RegisterMethod(@TJclFilePropertySet.GetWordProperty, 'GetWordProperty');
    RegisterMethod(@TJclFilePropertySet.SetWordProperty, 'SetWordProperty');
    RegisterMethod(@TJclFilePropertySet.GetBSTRProperty, 'GetBSTRProperty');
    RegisterMethod(@TJclFilePropertySet.SetBSTRProperty, 'SetBSTRProperty');
    RegisterMethod(@TJclFilePropertySet.GetPropertyName, 'GetPropertyName');
    RegisterMethod(@TJclFilePropertySet.SetPropertyName, 'SetPropertyName');
    RegisterMethod(@TJclFilePropertySet.DeletePropertyName, 'DeletePropertyName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclNTFS2_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@NtfsGetCompression, 'NtfsGetCompression2', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetCompression1_P, 'NtfsGetCompression12', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetCompression, 'NtfsSetCompression2', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetFileCompression, 'NtfsSetFileCompression2', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetDirectoryTreeCompression, 'NtfsSetDirectoryTreeCompression2', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetDefaultFileCompression, 'NtfsSetDefaultFileCompression2', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetPathCompression, 'NtfsSetPathCompression2', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetSparse, 'NtfsSetSparse2', cdRegister);
 S.RegisterDelphiFunction(@NtfsZeroDataByHandle, 'NtfsZeroDataByHandle2', cdRegister);
 S.RegisterDelphiFunction(@NtfsZeroDataByName, 'NtfsZeroDataByName2', cdRegister);
 S.RegisterDelphiFunction(@NtfsQueryAllocRanges, 'NtfsQueryAllocRanges2', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetAllocRangeEntry, 'NtfsGetAllocRangeEntry2', cdRegister);
 S.RegisterDelphiFunction(@NtfsSparseStreamsSupported, 'NtfsSparseStreamsSupported2', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetSparse, 'NtfsGetSparse2', cdRegister);
 S.RegisterDelphiFunction(@NtfsDeleteReparsePoint, 'NtfsDeleteReparsePoint2', cdRegister);
 S.RegisterDelphiFunction(@NtfsSetReparsePoint, 'NtfsSetReparsePoint2', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetReparsePoint, 'NtfsGetReparsePoint2', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetReparseTag, 'NtfsGetReparseTag2', cdRegister);
 S.RegisterDelphiFunction(@NtfsReparsePointsSupported, 'NtfsReparsePointsSupported2', cdRegister);
 S.RegisterDelphiFunction(@NtfsFileHasReparsePoint, 'NtfsFileHasReparsePoint2', cdRegister);
 S.RegisterDelphiFunction(@NtfsIsFolderMountPoint, 'NtfsIsFolderMountPoint2', cdRegister);
 S.RegisterDelphiFunction(@NtfsMountDeviceAsDrive, 'NtfsMountDeviceAsDrive2', cdRegister);
 S.RegisterDelphiFunction(@NtfsMountVolume, 'NtfsMountVolume2', cdRegister);
 S.RegisterDelphiFunction(@NtfsOpLockAckClosePending, 'NtfsOpLockAckClosePending2', cdRegister);
 S.RegisterDelphiFunction(@NtfsOpLockBreakAckNo2, 'NtfsOpLockBreakAckNo22', cdRegister);
 S.RegisterDelphiFunction(@NtfsOpLockBreakAcknowledge, 'NtfsOpLockBreakAcknowledge2', cdRegister);
 S.RegisterDelphiFunction(@NtfsOpLockBreakNotify, 'NtfsOpLockBreakNotify2', cdRegister);
 S.RegisterDelphiFunction(@NtfsRequestOpLock, 'NtfsRequestOpLock2', cdRegister);
 S.RegisterDelphiFunction(@NtfsCreateJunctionPoint, 'NtfsCreateJunctionPoint2', cdRegister);
 S.RegisterDelphiFunction(@NtfsDeleteJunctionPoint, 'NtfsDeleteJunctionPoint2', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetJunctionPointDestination, 'NtfsGetJunctionPointDestination2', cdRegister);
 S.RegisterDelphiFunction(@NtfsFindFirstStream, 'NtfsFindFirstStream2', cdRegister);
 S.RegisterDelphiFunction(@NtfsFindNextStream, 'NtfsFindNextStream2', cdRegister);
 S.RegisterDelphiFunction(@NtfsFindStreamClose, 'NtfsFindStreamClose2', cdRegister);
 S.RegisterDelphiFunction(@NtfsCreateHardLink, 'NtfsCreateHardLink2', cdRegister);
 S.RegisterDelphiFunction(@NtfsCreateHardLinkA, 'NtfsCreateHardLinkA2', cdRegister);
 S.RegisterDelphiFunction(@NtfsCreateHardLinkW, 'NtfsCreateHardLinkW2', cdRegister);
 S.RegisterDelphiFunction(@NtfsGetHardLinkInfo, 'NtfsGetHardLinkInfo2', cdRegister);
 S.RegisterDelphiFunction(@NtfsFindHardLinks, 'NtfsFindHardLinks2', cdRegister);
 S.RegisterDelphiFunction(@NtfsDeleteHardLinks, 'NtfsDeleteHardLinks2', cdRegister);
  //with CL.Add(EJclFileSummaryError) do
  //with CL.Add(TJclFileSummary) do
  {RIRegister_TJclFilePropertySet(CL); }
 // RIRegister_TJclFileSummary(CL);
 // RIRegister_TJclFileSummaryInformation(CL);
 { RIRegister_TJclDocSummaryInformation(CL);
  RIRegister_TJclMediaFileSummaryInformation(CL);
  RIRegister_TJclMSISummaryInformation(CL);
  RIRegister_TJclShellSummaryInformation(CL);
  RIRegister_TJclStorageSummaryInformation(CL);
  RIRegister_TJclImageSummaryInformation(CL);
  RIRegister_TJclDisplacedSummaryInformation(CL);
  RIRegister_TJclBriefCaseSummaryInformation(CL);
  RIRegister_TJclMiscSummaryInformation(CL);
  RIRegister_TJclWebViewSummaryInformation(CL);
  RIRegister_TJclMusicSummaryInformation(CL);
  RIRegister_TJclDRMSummaryInformation(CL);
  RIRegister_TJclVideoSummaryInformation(CL);
  RIRegister_TJclAudioSummaryInformation(CL);
  RIRegister_TJclControlPanelSummaryInformation(CL);
  RIRegister_TJclVolumeSummaryInformation(CL);
  RIRegister_TJclShareSummaryInformation(CL);
  RIRegister_TJclLinkSummaryInformation(CL);
  RIRegister_TJclQuerySummaryInformation(CL);
  RIRegister_TJclImageInformation(CL);
  RIRegister_TJclJpegSummaryInformation(CL); }
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclNTFS2(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EJclNtfsError) do
  RIRegister_TJclFileSummary(CL);
  RIRegister_TJclFileSummaryInformation(CL);
   RIRegister_TJclDocSummaryInformation(CL);
  RIRegister_TJclMediaFileSummaryInformation(CL);
  RIRegister_TJclMSISummaryInformation(CL);
  RIRegister_TJclShellSummaryInformation(CL);
  RIRegister_TJclStorageSummaryInformation(CL);
  RIRegister_TJclImageSummaryInformation(CL);
  RIRegister_TJclDisplacedSummaryInformation(CL);
  RIRegister_TJclBriefCaseSummaryInformation(CL);
  RIRegister_TJclMiscSummaryInformation(CL);
  RIRegister_TJclWebViewSummaryInformation(CL);
  RIRegister_TJclMusicSummaryInformation(CL);
  RIRegister_TJclDRMSummaryInformation(CL);
  RIRegister_TJclVideoSummaryInformation(CL);
  RIRegister_TJclAudioSummaryInformation(CL);
  RIRegister_TJclControlPanelSummaryInformation(CL);
  RIRegister_TJclVolumeSummaryInformation(CL);
  RIRegister_TJclShareSummaryInformation(CL);
  RIRegister_TJclLinkSummaryInformation(CL);
  RIRegister_TJclQuerySummaryInformation(CL);
  RIRegister_TJclImageInformation(CL);
  RIRegister_TJclJpegSummaryInformation(CL); //}
end;



{ TPSImport_JclNTFS }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclNTFS.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclNTFS2(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclNTFS.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclNTFS2(ri);
  RIRegister_JclNTFS2_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
