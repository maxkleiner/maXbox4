unit uPSI_StSystem;
{
  systools4
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
  TPSImport_StSystem = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_StSystem(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_StSystem_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Windows
  ,FileCtrl
  ,StConst
  ,StBase
  ,StUtils
  ,StDate
  ,StStrL
  ,StSystem
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_StSystem]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_StSystem(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('StPathDelim','String').SetString( '\');
 CL.AddConstantN('StPathSep','String').SetString( ';');
 CL.AddConstantN('StDriveDelim','String').SetString( ':');
 CL.AddConstantN('StDosPathDelim','String').SetString( '\');
 CL.AddConstantN('StUnixPathDelim','String').SetString( '/');
 CL.AddConstantN('StDosPathSep','String').SetString( ';');
 CL.AddConstantN('StUnixPathSep','String').SetString( ':');
 CL.AddConstantN('StDosAnyFile','String').SetString( '*.*');
 CL.AddConstantN('StUnixAnyFile','String').SetString( '*');
 CL.AddConstantN('StAnyFile','String').SetString( '*.*');
 CL.AddConstantN('StThisDir','String').SetString( '.');
 CL.AddConstantN('StParentDir','String').SetString( '..');

  (*TStDateTimeRec =
    record
     {This record type simply combines the two basic date types defined by
      STDATE, Date and Time}
      D : TStDate;
      T : TStTime;
    end;*)
  (*MediaIDType = packed record
  {This type describes the information that DOS 4.0 or higher writes
   in the boot sector of a disk when it is formatted}
    InfoLevel : Word;                        {Reserved for future use}
    SerialNumber : LongInt;                  {Disk serial number}
    VolumeLabel : array[0..10] of AnsiChar;  {Disk volume label}
    FileSystemID : array[0..7] of AnsiChar;  {String for internal use by the OS}
  end;*)


  CL.AddTypeS('MediaIDType','record InfoLevel : Word; SerialNumber : LongInt; VolumeLabel : array[0..10] of Char; FileSystemID : array[0..7] of Char; end');

  CL.AddTypeS('TIncludeItemFunc','function (const SR : TSearchRec; ForInclusion : Boolean; var Abort : Boolean) : Boolean;');

 // TIncludeItemFunc = function (const SR : TSearchRec;
   //                            ForInclusion : Boolean; var Abort : Boolean) : Boolean;


  CL.AddTypeS('TStDateTimeRec','record D : TStDate;  T : TStTime; end');
   CL.AddTypeS('DiskClass', '( Floppy360, Floppy720, Floppy12, Floppy144, OtherF'
   +'loppy, HardDisk, RamDisk, UnknownDisk, InvalidDrive, RemoteDrive, CDRomDisk)');
 // CL.AddTypeS('PMediaIDType', '^MediaIDType // will not work');
 CL.AddDelphiFunction('Function StCopyFile( const SrcPath, DestPath : AnsiString) : Cardinal');
 CL.AddDelphiFunction('Function CreateTempFile( const aFolder : AnsiString; const aPrefix : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function DeleteVolumeLabel( Drive : Char) : Cardinal');
 CL.AddDelphiFunction('Procedure EnumerateDirectories( const StartDir : AnsiString; FL : TStrings; SubDirs : Boolean; IncludeItem : TIncludeItemFunc)');
 CL.AddDelphiFunction('Procedure EnumerateFiles( const StartDir : AnsiString; FL : TStrings; SubDirs : Boolean; IncludeItem : TIncludeItemFunc)');
 CL.AddDelphiFunction('Procedure EnumerateDirectories2( const StartDir : AnsiString; FL : TStrings; SubDirs : Boolean; IncludeItem : integer)');
 CL.AddDelphiFunction('Procedure EnumerateFiles2( const StartDir : AnsiString; FL : TStrings; SubDirs : Boolean; IncludeItem : integer)');

 CL.AddDelphiFunction('Function FileHandlesLeft( MaxHandles : Cardinal) : Cardinal');
 CL.AddDelphiFunction('Function FileMatchesMask( const FileName, FileMask : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function FileTimeToStDateTime( FileTime : LongInt) : TStDateTimeRec');
 CL.AddDelphiFunction('Function FindNthSlash( const Path : AnsiString; n : Integer) : Integer');
 CL.AddDelphiFunction('Function FlushOsBuffers( Handle : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetCurrentUser : AnsiString');
 CL.AddDelphiFunction('Function GetDiskClass( Drive : Char) : DiskClass');
 CL.AddDelphiFunction('Function GetDiskInfo( Drive : Char; var ClustersAvailable, TotalClusters, BytesPerSector, SectorsPerCluster : Cardinal) : Boolean');
 CL.AddDelphiFunction('Function GetDiskSpace( Drive : Char; var UserSpaceAvail : Double; var TotalSpaceAvail : Double; var DiskSize : Double) : Boolean');
 CL.AddDelphiFunction('Function GetDiskSpace( Drive : Char; var UserSpaceAvail : Comp; var TotalSpaceAvail : Comp; var DiskSize : Comp) : Boolean');
 CL.AddDelphiFunction('Function GetFileCreateDate( const FileName : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function StGetFileLastAccess( const FileName : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function GetFileLastModify( const FileName : AnsiString) : TDateTime');
 CL.AddDelphiFunction('Function GetHomeFolder( aForceSlash : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function GetLongPath( const APath : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function GetMachineName : AnsiString');
 CL.AddDelphiFunction('Function GetMediaID( Drive : Char; var MediaIDRec : MediaIDType) : Cardinal');
 CL.AddDelphiFunction('Function GetParentFolder( const APath : AnsiString; aForceSlash : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function GetShortPath( const APath : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function GetSystemFolder( aForceSlash : Boolean) : AnsiString');
 CL.AddDelphiFunction('Function GetTempFolder( aForceSlash : boolean) : AnsiString');
 CL.AddDelphiFunction('Function StGetWindowsFolder( aForceSlash : boolean) : AnsiString');
 CL.AddDelphiFunction('Function GetWorkingFolder( aForceSlash : boolean) : AnsiString');
 CL.AddDelphiFunction('Function GlobalDateTimeToLocal( const UTC : TStDateTimeRec; MinOffset : Integer) : TStDateTimeRec');
 CL.AddDelphiFunction('Function StIsDirectory( const DirName : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IsDirectoryEmpty( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function IsDriveReady( Drive : Char) : Boolean');
 CL.AddDelphiFunction('Function IsFile( const FileName : AnsiString) : Boolean');
 CL.AddDelphiFunction('Function IsFileArchive( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function IsFileHidden( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function IsFileReadOnly( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function IsFileSystem( const S : AnsiString) : Integer');
 CL.AddDelphiFunction('Function LocalDateTimeToGlobal( const DT1 : TStDateTimeRec; MinOffset : Integer) : TStDateTimeRec');
 CL.AddDelphiFunction('Function ReadVolumeLabel( var VolName : AnsiString; Drive : Char) : Cardinal');
 CL.AddDelphiFunction('Function SameFile( const FilePath1, FilePath2 : AnsiString; var ErrorCode : Integer) : Boolean');
 CL.AddDelphiFunction('Function SetMediaID( Drive : Char; var MediaIDRec : MediaIDType) : Cardinal');
 CL.AddDelphiFunction('Procedure SplitPath( const APath : AnsiString; Parts : TStrings)');
 CL.AddDelphiFunction('Function StDateTimeToFileTime( const FileTime : TStDateTimeRec) : LongInt');
 CL.AddDelphiFunction('Function StDateTimeToUnixTime( const DT1 : TStDateTimeRec) : Longint');
 CL.AddDelphiFunction('Function UnixTimeToStDateTime( UnixTime : Longint) : TStDateTimeRec');
 CL.AddDelphiFunction('Function ValidDrive( Drive : Char) : Boolean');
 CL.AddDelphiFunction('Function WriteVolumeLabel( const VolName : AnsiString; Drive : Char) : Cardinal');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_StSystem_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CopyFile, 'StCopyFile', cdRegister);
 S.RegisterDelphiFunction(@CreateTempFile, 'CreateTempFile', cdRegister);
 S.RegisterDelphiFunction(@DeleteVolumeLabel, 'DeleteVolumeLabel', cdRegister);
 S.RegisterDelphiFunction(@EnumerateDirectories, 'EnumerateDirectories', cdRegister);
 S.RegisterDelphiFunction(@EnumerateFiles, 'EnumerateFiles', cdRegister);
 S.RegisterDelphiFunction(@EnumerateDirectories, 'EnumerateDirectories2', cdRegister);
 S.RegisterDelphiFunction(@EnumerateFiles, 'EnumerateFiles2', cdRegister);

 S.RegisterDelphiFunction(@FileHandlesLeft, 'FileHandlesLeft', cdRegister);
 S.RegisterDelphiFunction(@FileMatchesMask, 'FileMatchesMask', cdRegister);
 S.RegisterDelphiFunction(@FileTimeToStDateTime, 'FileTimeToStDateTime', cdRegister);
 S.RegisterDelphiFunction(@FindNthSlash, 'FindNthSlash', cdRegister);
 S.RegisterDelphiFunction(@FlushOsBuffers, 'FlushOsBuffers', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentUser, 'GetCurrentUser', cdRegister);
 S.RegisterDelphiFunction(@GetDiskClass, 'GetDiskClass', cdRegister);
 S.RegisterDelphiFunction(@GetDiskInfo, 'GetDiskInfo', cdRegister);
 S.RegisterDelphiFunction(@GetDiskSpace, 'GetDiskSpace', cdRegister);
 S.RegisterDelphiFunction(@GetDiskSpace, 'GetDiskSpace', cdRegister);
 S.RegisterDelphiFunction(@GetFileCreateDate, 'GetFileCreateDate', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastAccess, 'StGetFileLastAccess', cdRegister);
 S.RegisterDelphiFunction(@GetFileLastModify, 'GetFileLastModify', cdRegister);
 S.RegisterDelphiFunction(@GetHomeFolder, 'GetHomeFolder', cdRegister);
 S.RegisterDelphiFunction(@GetLongPath, 'GetLongPath', cdRegister);
 S.RegisterDelphiFunction(@GetMachineName, 'GetMachineName', cdRegister);
 S.RegisterDelphiFunction(@GetMediaID, 'GetMediaID', cdRegister);
 S.RegisterDelphiFunction(@GetParentFolder, 'GetParentFolder', cdRegister);
 S.RegisterDelphiFunction(@GetShortPath, 'GetShortPath', cdRegister);
 S.RegisterDelphiFunction(@GetSystemFolder, 'GetSystemFolder', cdRegister);
 S.RegisterDelphiFunction(@GetTempFolder, 'GetTempFolder', cdRegister);
 S.RegisterDelphiFunction(@GetWindowsFolder, 'StGetWindowsFolder', cdRegister);
 S.RegisterDelphiFunction(@GetWorkingFolder, 'GetWorkingFolder', cdRegister);
 S.RegisterDelphiFunction(@GlobalDateTimeToLocal, 'GlobalDateTimeToLocal', cdRegister);
 S.RegisterDelphiFunction(@IsDirectory, 'StIsDirectory', cdRegister);
 S.RegisterDelphiFunction(@IsDirectoryEmpty, 'IsDirectoryEmpty', cdRegister);
 S.RegisterDelphiFunction(@IsDriveReady, 'IsDriveReady', cdRegister);
 S.RegisterDelphiFunction(@IsFile, 'IsFile', cdRegister);
 S.RegisterDelphiFunction(@IsFileArchive, 'IsFileArchive', cdRegister);
 S.RegisterDelphiFunction(@IsFileHidden, 'IsFileHidden', cdRegister);
 S.RegisterDelphiFunction(@IsFileReadOnly, 'IsFileReadOnly', cdRegister);
 S.RegisterDelphiFunction(@IsFileSystem, 'IsFileSystem', cdRegister);
 S.RegisterDelphiFunction(@LocalDateTimeToGlobal, 'LocalDateTimeToGlobal', cdRegister);
 S.RegisterDelphiFunction(@ReadVolumeLabel, 'ReadVolumeLabel', cdRegister);
 S.RegisterDelphiFunction(@SameFile, 'SameFile', cdRegister);
 S.RegisterDelphiFunction(@SetMediaID, 'SetMediaID', cdRegister);
 S.RegisterDelphiFunction(@SplitPath, 'SplitPath', cdRegister);
 S.RegisterDelphiFunction(@StDateTimeToFileTime, 'StDateTimeToFileTime', cdRegister);
 S.RegisterDelphiFunction(@StDateTimeToUnixTime, 'StDateTimeToUnixTime', cdRegister);
 S.RegisterDelphiFunction(@UnixTimeToStDateTime, 'UnixTimeToStDateTime', cdRegister);
 S.RegisterDelphiFunction(@ValidDrive, 'ValidDrive', cdRegister);
 S.RegisterDelphiFunction(@WriteVolumeLabel, 'WriteVolumeLabel', cdRegister);
end;



{ TPSImport_StSystem }
(*----------------------------------------------------------------------------*)
procedure TPSImport_StSystem.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_StSystem(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_StSystem.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_StSystem(ri);
  RIRegister_StSystem_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
