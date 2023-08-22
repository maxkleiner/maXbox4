unit uPSI_LibTar;
{
   ARCHIVE BOX
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
  TPSImport_LibTar = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TTarWriter(CL: TPSPascalCompiler);
procedure SIRegister_TTarArchive(CL: TPSPascalCompiler);
procedure SIRegister_LibTar(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_LibTar_Routines(S: TPSExec);
procedure RIRegister_TTarWriter(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTarArchive(CL: TPSRuntimeClassImporter);
procedure RIRegister_LibTar(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  //,Sysutils 
  ,LibTar
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_LibTar]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TTarWriter(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TTarWriter') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTarWriter') do begin
    RegisterMethod('Constructor Create( TargetStream : TStream);');
    RegisterMethod('Constructor Create1( TargetFilename : STRING; Mode : INTEGER);');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure AddFile( Filename : STRING; TarFilename : STRING)');
    RegisterMethod('Procedure AddStream( Stream : TStream; TarFilename : STRING; FileDateGmt : TDateTime)');
    RegisterMethod('Procedure AddString( Contents : STRING; TarFilename : STRING; FileDateGmt : TDateTime)');
    RegisterMethod('Procedure AddDir( Dirname : STRING; DateGmt : TDateTime; MaxDirSize : INT64)');
    RegisterMethod('Procedure AddSymbolicLink( Filename, Linkname : STRING; DateGmt : TDateTime)');
    RegisterMethod('Procedure AddLink( Filename, Linkname : STRING; DateGmt : TDateTime)');
    RegisterMethod('Procedure AddVolumeHeader( VolumeId : STRING; DateGmt : TDateTime)');
    RegisterMethod('Procedure Finalize');
    RegisterProperty('Permissions', 'TTarPermissions', iptrw);
    RegisterProperty('UID', 'INTEGER', iptrw);
    RegisterProperty('GID', 'INTEGER', iptrw);
    RegisterProperty('UserName', 'STRING', iptrw);
    RegisterProperty('GroupName', 'STRING', iptrw);
    RegisterProperty('Mode', 'TTarModes', iptrw);
    RegisterProperty('Magic', 'STRING', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTarArchive(CL: TPSPascalCompiler);
begin

  //fmOpenRead       = $0000;
  //fmOpenWrite      = $0001;
  //fmOpenReadWrite  = $0002;
  // fmShareDenyWrite = $0020;


  //with RegClassS(CL,'TOBJECT', 'TTarArchive') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TTarArchive') do begin
    RegisterProperty('FStream', 'TStream', iptrw);
    RegisterMethod('Constructor Create( Stream : TStream);');
    RegisterMethod('Constructor Create1( Filename : STRING; FileMode : WORD);');
    RegisterMethod('Procedure Reset');
    RegisterMethod('Function FindNext( var DirRec : TTarDirRec) : BOOLEAN');
    RegisterMethod('Procedure ReadFile( Buffer : ___POINTER);');
    RegisterMethod('Procedure ReadFile1( Stream : TStream);');
    RegisterMethod('Procedure ReadFile2( Filename : STRING);');
    RegisterMethod('Function ReadFile3 : STRING;');
    RegisterMethod('Procedure GetFilePos( var Current, Size : INT64)');
    RegisterMethod('Procedure SetFilePos( NewPos : INT64)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_LibTar(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTarPermission', '( tpReadByOwner, tpWriteByOwner, tpExecuteByOw'
   +'ner, tpReadByGroup, tpWriteByGroup, tpExecuteByGroup, tpReadByOther, tpWri'
   +'teByOther, tpExecuteByOther )');
  CL.AddTypeS('TTarPermissions', 'set of TTarPermission');
  CL.AddTypeS('TTarFileType', '( ftNormal, ftLink, ftSymbolicLink, ftCharacter, ft'
   +'Block, ftDirectory, ftFifo, ftContiguous, ftDumpDir, ftMultiVolume, ftVolumeHeader )');
  CL.AddTypeS('TTarMode', '( tmSetUid, tmSetGid, tmSaveText )');
  CL.AddTypeS('TTarModes', 'set of TTarMode');
  CL.AddTypeS('TTarDirRec', 'record Name : STRING; Size : INT64; DateTime : TDa'
   +'teTime; Permissions : TTarPermissions; FileType : TTarFileType; LinkName : ST'
   +'RING; UID : INTEGER; GID : INTEGER; UserName : STRING; GroupName : STRING;'
   +' ChecksumOK : BOOLEAN; Mode : TTarModes; Magic : STRING; MajorDevNo : INTE'
   +'GER; MinorDevNo : INTEGER; FilePos : INT64; end');
  SIRegister_TTarArchive(CL);
  SIRegister_TTarWriter(CL);
 CL.AddConstantN('ALL_PERMISSIONS','LongInt').Value.ts32 := ord(tpReadByOwner) or ord(tpWriteByOwner) or ord(tpExecuteByOwner) or ord(tpReadByGroup) or ord(tpWriteByGroup) or ord(tpExecuteByGroup) or ord(tpReadByOther) or ord(tpWriteByOther) or ord(tpExecuteByOther);
 CL.AddConstantN('READ_PERMISSIONS','LongInt').Value.ts32 := ord(tpReadByOwner) or ord(tpReadByGroup) or ord(tpReadByOther);
 CL.AddConstantN('WRITE_PERMISSIONS','LongInt').Value.ts32 := ord(tpWriteByOwner) or ord(tpWriteByGroup) or ord(tpWriteByOther);
 CL.AddConstantN('EXECUTE_PERMISSIONS','LongInt').Value.ts32 := ord(tpExecuteByOwner) or ord(tpExecuteByGroup) or ord(tpExecuteByOther);
 CL.AddDelphiFunction('Function PermissionString( Permissions : TTarPermissions) : STRING');
 CL.AddDelphiFunction('Function ConvertFilename( Filename : STRING) : STRING');
 CL.AddDelphiFunction('Function FileTimeGMT( FileName : STRING) : TDateTime;');
 CL.AddDelphiFunction('Function FileTimeGMT1( SearchRec : TSearchRec) : TDateTime;');
 CL.AddDelphiFunction('Procedure ClearDirRec( var DirRec : TTarDirRec)');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function FileTimeGMT1_P( SearchRec : TSearchRec) : TDateTime;
Begin Result := LibTar.FileTimeGMT(SearchRec); END;

(*----------------------------------------------------------------------------*)
Function FileTimeGMT_P( FileName : STRING) : TDateTime;
Begin Result := LibTar.FileTimeGMT(FileName); END;

(*----------------------------------------------------------------------------*)
procedure TTarWriterMagic_W(Self: TTarWriter; const T: STRING);
begin Self.Magic := T; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterMagic_R(Self: TTarWriter; var T: STRING);
begin T := Self.Magic; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterMode_W(Self: TTarWriter; const T: TTarModes);
begin Self.Mode := T; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterMode_R(Self: TTarWriter; var T: TTarModes);
begin T := Self.Mode; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterGroupName_W(Self: TTarWriter; const T: STRING);
begin Self.GroupName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterGroupName_R(Self: TTarWriter; var T: STRING);
begin T := Self.GroupName; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterUserName_W(Self: TTarWriter; const T: STRING);
begin Self.UserName := T; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterUserName_R(Self: TTarWriter; var T: STRING);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterGID_W(Self: TTarWriter; const T: INTEGER);
begin Self.GID := T; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterGID_R(Self: TTarWriter; var T: INTEGER);
begin T := Self.GID; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterUID_W(Self: TTarWriter; const T: INTEGER);
begin Self.UID := T; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterUID_R(Self: TTarWriter; var T: INTEGER);
begin T := Self.UID; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterPermissions_W(Self: TTarWriter; const T: TTarPermissions);
begin Self.Permissions := T; end;

(*----------------------------------------------------------------------------*)
procedure TTarWriterPermissions_R(Self: TTarWriter; var T: TTarPermissions);
begin T := Self.Permissions; end;

(*----------------------------------------------------------------------------*)
Function TTarWriterCreate1_P(Self: TClass; CreateNewInstance: Boolean;  TargetFilename : STRING; Mode : INTEGER):TObject;
Begin Result := TTarWriter.Create(TargetFilename, Mode); END;

(*----------------------------------------------------------------------------*)
Function TTarWriterCreate_P(Self: TClass; CreateNewInstance: Boolean;  TargetStream : TStream):TObject;
Begin Result := TTarWriter.Create(TargetStream); END;

(*----------------------------------------------------------------------------*)
Function TTarArchiveReadFile3_P(Self: TTarArchive) : STRING;
Begin Result := Self.ReadFile; END;

(*----------------------------------------------------------------------------*)
Procedure TTarArchiveReadFile2_P(Self: TTarArchive;  Filename : STRING);
Begin Self.ReadFile(Filename); END;

(*----------------------------------------------------------------------------*)
Procedure TTarArchiveReadFile1_P(Self: TTarArchive;  Stream : TStream);
Begin Self.ReadFile(Stream); END;

(*----------------------------------------------------------------------------*)
Procedure TTarArchiveReadFile_P(Self: TTarArchive;  Buffer : POINTER);
Begin Self.ReadFile(Buffer); END;

(*----------------------------------------------------------------------------*)
Function TTarArchiveCreate1_P(Self: TClass; CreateNewInstance: Boolean;  Filename : STRING; FileMode : integer):TObject;
Begin Result := TTarArchive.Create(Filename, FileMode); END;

(*----------------------------------------------------------------------------*)
Function TTarArchiveCreate_P(Self: TClass; CreateNewInstance: Boolean;  Stream : TStream):TObject;
Begin Result := TTarArchive.Create(Stream); END;

(*----------------------------------------------------------------------------*)
procedure TTarArchiveFStream_W(Self: TTarArchive; const T: TStream);
Begin Self.FStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TTarArchiveFStream_R(Self: TTarArchive; var T: TStream);
Begin T := Self.FStream; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LibTar_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PermissionString, 'PermissionString', cdRegister);
 S.RegisterDelphiFunction(@ConvertFilename, 'ConvertFilename', cdRegister);
 S.RegisterDelphiFunction(@FileTimeGMT, 'FileTimeGMT', cdRegister);
 S.RegisterDelphiFunction(@FileTimeGMT, 'FileTimeGMT1', cdRegister);
 S.RegisterDelphiFunction(@ClearDirRec, 'ClearDirRec', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTarWriter(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTarWriter) do begin
    RegisterConstructor(@TTarWriterCreate_P, 'Create');
    RegisterConstructor(@TTarWriterCreate1_P, 'Create1');
    RegisterMethod(@TTarWriter.Destroy, 'Free');
    RegisterMethod(@TTarWriter.AddFile, 'AddFile');
    RegisterMethod(@TTarWriter.AddStream, 'AddStream');
    RegisterMethod(@TTarWriter.AddString, 'AddString');
    RegisterMethod(@TTarWriter.AddDir, 'AddDir');
    RegisterMethod(@TTarWriter.AddSymbolicLink, 'AddSymbolicLink');
    RegisterMethod(@TTarWriter.AddLink, 'AddLink');
    RegisterMethod(@TTarWriter.AddVolumeHeader, 'AddVolumeHeader');
    RegisterMethod(@TTarWriter.Finalize, 'Finalize');
    RegisterPropertyHelper(@TTarWriterPermissions_R,@TTarWriterPermissions_W,'Permissions');
    RegisterPropertyHelper(@TTarWriterUID_R,@TTarWriterUID_W,'UID');
    RegisterPropertyHelper(@TTarWriterGID_R,@TTarWriterGID_W,'GID');
    RegisterPropertyHelper(@TTarWriterUserName_R,@TTarWriterUserName_W,'UserName');
    RegisterPropertyHelper(@TTarWriterGroupName_R,@TTarWriterGroupName_W,'GroupName');
    RegisterPropertyHelper(@TTarWriterMode_R,@TTarWriterMode_W,'Mode');
    RegisterPropertyHelper(@TTarWriterMagic_R,@TTarWriterMagic_W,'Magic');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTarArchive(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTarArchive) do
  begin
    RegisterPropertyHelper(@TTarArchiveFStream_R,@TTarArchiveFStream_W,'FStream');
    RegisterConstructor(@TTarArchiveCreate_P, 'Create');
    RegisterConstructor(@TTarArchiveCreate1_P, 'Create1');
    RegisterMethod(@TTarArchive.Reset, 'Reset');
    RegisterMethod(@TTarArchive.FindNext, 'FindNext');
    RegisterMethod(@TTarArchiveReadFile_P, 'ReadFile');
    RegisterMethod(@TTarArchiveReadFile1_P, 'ReadFile1');
    RegisterMethod(@TTarArchiveReadFile2_P, 'ReadFile2');
    RegisterMethod(@TTarArchiveReadFile3_P, 'ReadFile3');
    RegisterMethod(@TTarArchive.GetFilePos, 'GetFilePos');
    RegisterMethod(@TTarArchive.SetFilePos, 'SetFilePos');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_LibTar(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TTarArchive(CL);
  RIRegister_TTarWriter(CL);
end;

 
 
{ TPSImport_LibTar }
(*----------------------------------------------------------------------------*)
procedure TPSImport_LibTar.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_LibTar(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_LibTar.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_LibTar(ri);
  RIRegister_LibTar_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
