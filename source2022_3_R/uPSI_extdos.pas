unit uPSI_extdos;
{
my time on dos boss file type    TFileStats

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
  TPSImport_extdos = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_extdos(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_extdos_Routines(S: TPSExec);

procedure Register;

implementation


uses
  // tpautils
  //,fpautils
  //,dpautils
  //,vpautils
  xutils
  //,unicode
  //,dateutil
  ,windows
  //,posix
  //,fileio
  //,dos
  ,extdos
  ;
 

procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_extdos]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_extdos(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('EXTDOS_STATUS_OK','LongInt').SetInt( 0);
 CL.AddConstantN('EXTDOS_STATUS_UNSUPPORTED','LongInt').SetInt( - 1);
 CL.AddConstantN('EXTDOS_STATUS_DATE_CONVERT_ERROR','LongInt').SetInt( - 2);
 CL.AddConstantN('EXTDOS_STATUS_DATE_UNSUPPORTED','LongInt').SetInt( - 3);
 CL.AddConstantN('MIN_FILE_YEAR','LongInt').SetInt( 1601);
 CL.AddConstantN('MAX_UNICODE_BUFSIZE','LongInt').SetInt( 63);
// CL.AddConstantN('MAX_PATH','LongInt').SetInt( 255);
 CL.AddConstantN('FILE_ATTRIBUTE_READONLY','LongWord').SetUInt( $00000001);
 CL.AddConstantN('FILE_ATTRIBUTE_HIDDEN','LongWord').SetUInt( $00000002);
 CL.AddConstantN('FILE_ATTRIBUTE_SYSTEM','LongWord').SetUInt( $00000004);
 CL.AddConstantN('FILE_ATTRIBUTE_DIRECTORY','LongWord').SetUInt( $00000010);
 CL.AddConstantN('FILE_ATTRIBUTE_ARCHIVE','LongWord').SetUInt( $00000020);
 CL.AddConstantN('FILE_ATTRIBUTE_DEVICE','LongWord').SetUInt( $00000040);
 CL.AddConstantN('FILE_ATTRIBUTE_NORMAL','LongWord').SetUInt( $00000080);
 CL.AddConstantN('FILE_ATTRIBUTE_TEMPORARY','LongWord').SetUInt( $00000100);
 CL.AddConstantN('FILE_ATTRIBUTE_SPARSE_FILE','LongWord').SetUInt( $00000200);
 CL.AddConstantN('FILE_ATTRIBUTE_REPARSE_POINT','LongWord').SetUInt( $00000400);
 CL.AddConstantN('FILE_ATTRIBUTE_COMPRESSED','LongWord').SetUInt( $00000800);
 CL.AddConstantN('FILE_ATTRIBUTE_OFFLINE','LongWord').SetUInt( $00001000);
 CL.AddConstantN('FILE_ATTRIBUTE_NOT_CONTENT_INDEXED','LongWord').SetUInt( $00002000);
 CL.AddConstantN('FILE_ATTRIBUTE_ENCRYPTED','LongWord').SetUInt( $00004000);
 CL.AddConstantN('ASSOCF_INIT_NOREMAPCLSID','LongWord').SetUInt( $00000001);
 CL.AddConstantN('ASSOCF_INIT_BYEXENAME','LongWord').SetUInt( $00000002);
 CL.AddConstantN('ASSOCF_OPEN_BYEXENAME','LongWord').SetUInt( $00000002);
 CL.AddConstantN('ASSOCF_INIT_DEFAULTTOSTAR','LongWord').SetUInt( $00000004);
 CL.AddConstantN('ASSOCF_INIT_DEFAULTTOFOLDER','LongWord').SetUInt( $00000008);
 CL.AddConstantN('ASSOCF_NOUSERSETTINGS','LongWord').SetUInt( $00000010);
 CL.AddConstantN('ASSOCF_NOTRUNCATE','LongWord').SetUInt( $00000020);
 CL.AddConstantN('ASSOCF_VERIFY','LongWord').SetUInt( $00000040);
 CL.AddConstantN('ASSOCF_REMAPRUNDLL','LongWord').SetUInt( $00000080);
 CL.AddConstantN('ASSOCF_NOFIXUPS','LongWord').SetUInt( $00000100);
 CL.AddConstantN('ASSOCF_IGNOREBASECLASS','LongWord').SetUInt( $00000200);
 CL.AddConstantN('FILE_READ_ATTRIBUTES','LongWord').SetUInt( $080);
 CL.AddConstantN('SHGFP_TYPE_CURRENT','LongInt').SetInt( 0);
 CL.AddConstantN('SHGFP_TYPE_DEFAULT','LongInt').SetInt( 1);
 CL.AddConstantN('CSIDL_PROGRAMS','LongWord').SetUInt( $0002);
 CL.AddConstantN('CSIDL_PERSONAL','LongWord').SetUInt( $0005);
 CL.AddConstantN('CSIDL_FAVORITES','LongWord').SetUInt( $0006);
 CL.AddConstantN('CSIDL_STARTUP','LongWord').SetUInt( $0007);
 CL.AddConstantN('CSIDL_RECENT','LongWord').SetUInt( $0008);
 CL.AddConstantN('CSIDL_SENDTO','LongWord').SetUInt( $0009);
 CL.AddConstantN('CSIDL_STARTMENU','LongWord').SetUInt( $000B);
 CL.AddConstantN('CSIDL_MYMUSIC','LongWord').SetUInt( $000D);
 CL.AddConstantN('CSIDL_MYVIDEO','LongWord').SetUInt( $000E);
 CL.AddConstantN('CSIDL_DESKTOPDIRECTORY','LongWord').SetUInt( $0010);
 CL.AddConstantN('CSIDL_NETHOOD','LongWord').SetUInt( $0013);
 CL.AddConstantN('CSIDL_TEMPLATES','LongWord').SetUInt( $0015);
 CL.AddConstantN('CSIDL_COMMON_STARTMENU','LongWord').SetUInt( $0016);
 CL.AddConstantN('CSIDL_COMMON_PROGRAMS','LongWord').SetUInt( $0017);
 CL.AddConstantN('CSIDL_COMMON_STARTUP','LongWord').SetUInt( $0018);
 CL.AddConstantN('CSIDL_COMMON_DESKTOPDIRECTORY','LongWord').SetUInt( $0019);
 CL.AddConstantN('CSIDL_APPDATA','LongWord').SetUInt( $001A);
 CL.AddConstantN('CSIDL_PRINTHOOD','LongWord').SetUInt( $001B);
 CL.AddConstantN('CSIDL_LOCAL_APPDATA','LongWord').SetUInt( $001C);
 CL.AddConstantN('CSIDL_COMMON_FAVORITES','LongWord').SetUInt( $001F);
 CL.AddConstantN('CSIDL_INTERNET_CACHE','LongWord').SetUInt( $0020);
 CL.AddConstantN('CSIDL_COOKIES','LongWord').SetUInt( $0021);
 CL.AddConstantN('CSIDL_HISTORY','LongWord').SetUInt( $0022);
 CL.AddConstantN('CSIDL_COMMON_APPDATA','LongWord').SetUInt( $0023);
 CL.AddConstantN('CSIDL_WINDOWS','LongWord').SetUInt( $0024);
 CL.AddConstantN('CSIDL_SYSTEM','LongWord').SetUInt( $0025);
 CL.AddConstantN('CSIDL_PROGRAM_FILES','LongWord').SetUInt( $0026);
 CL.AddConstantN('CSIDL_MYPICTURES','LongWord').SetUInt( $0027);
 CL.AddConstantN('CSIDL_PROFILE','LongWord').SetUInt( $0028);
 CL.AddConstantN('CSIDL_PROGRAM_FILES_COMMON','LongWord').SetUInt( $002B);
 CL.AddConstantN('CSIDL_COMMON_TEMPLATES','LongWord').SetUInt( $002D);
 CL.AddConstantN('CSIDL_COMMON_DOCUMENTS','LongWord').SetUInt( $002E);
 CL.AddConstantN('CSIDL_COMMON_ADMINTOOLS','LongWord').SetUInt( $002F);
 CL.AddConstantN('CSIDL_ADMINTOOLS','LongWord').SetUInt( $0030);
 CL.AddConstantN('CSIDL_COMMON_MUSIC','LongWord').SetUInt( $0035);
 CL.AddConstantN('CSIDL_COMMON_PICTURES','LongWord').SetUInt( $0036);
 CL.AddConstantN('CSIDL_COMMON_VIDEO','LongWord').SetUInt( $0037);
 CL.AddConstantN('CSIDL_CDBURN_AREA','LongWord').SetUInt( $003B);
 CL.AddConstantN('CSIDL_PROFILES','LongWord').SetUInt( $003E);
 CL.AddConstantN('CSIDL_FLAG_CREATE','LongWord').SetUInt( $8000);
 CL.AddConstantN('MAX_STRING_LENGTH','LongInt').SetInt( 2048);
  CL.AddTypeS('utf8char', 'char');
  CL.AddTypeS('putf8char', 'pchar');
  CL.AddTypeS('utf16char', 'word');
  CL.AddTypeS('ucs4char', 'longword');
  //CL.AddTypeS('pucs4char', '^ucs4char // will not work');
  CL.AddTypeS('ucs2char', 'word');
  CL.AddTypeS('pucs2char', 'ucs2char'); // will not work');

  //CL.AddTypeS('pucs2char', '^ucs2char // will not work');
  CL.AddTypeS('utf8string', 'string');
 // CL.AddTypeS('putf8shortstring', '^shortstring // will not work');
  CL.AddTypeS('_USER_INFO_2', 'record usri2_name : pucs2char; usri2_password : '
   +'pucs2char; usri2_password_age : DWORD; usri2_priv : DWORD; usri2_home_dir '
   +': pucs2char; usri2_comment : pucs2char; usri2_flags : DWORD; usri2_script_'
   +'path : pucs2char; usri2_auth_flags : DWORD; usri2_full_name : pucs2char; u'
   +'sri2_usr_comment : pucs2char; usri2_parms : pucs2char; usri2_workstations '
   +': pucs2char; usri2_last_logon : DWORD; usri2_last_logoff : DWORD; usri2_ac'
   +'ct_expires : DWORD; usri2_max_storage : DWORD; usri2_units_per_week : DWOR'
   +'D; usri2_logon_hours : pchar; usri2_bad_pw_count : DWORD; usri2_num_logons'
   +' : DWORD; usri2_logon_server : pucs2char; usri2_country_code : DWORD; usri2_code_page : DWORD; end');
  //CL.AddTypeS('P_USER_INFO_2', '^_USER_INFO_2 // will not work');
  CL.AddTypeS('SE_OBJECT_TYPE', '( SE_UNKNOWN_OBJECT_TYPE, SE_FILE_OBJECT, SE_S'
   +'ERVICE, SE_PRINTER, SE_REGISTRY_KEY, SE_LMSHARE, SE_KERNEL_OBJECT, SE_WIND'
   +'OW_OBJECT, SE_DS_OBJECT, SE_DS_OBJECT_ALL, SE_PROVIDER_DEFINED_OBJECT, SE_'
   +'WMIGUID_OBJECT )');
  //CL.AddTypeS('PPSID', '^PSID // will not work');
  CL.AddTypeS('ASSOCF', 'DWORD');
  CL.AddTypeS('ASSOCSTR', '( ASSOCSTR_NONE, ASSOCSTR_COMMAND, ASSOCSTR_EXECUTAB'
   +'LE, ASSOCSTR_FRIENDLYDOCNAME, ASSOCSTR_FRIENDLYAPPNAME, ASSOCSTR_NOOPEN, A'
   +'SSOCSTR_SHELLNEWVALUE, ASSOCSTR_DDECOMMAND, ASSOCSTR_DDEIFEXEC, ASSOCSTR_DDEAPPLICATION, ASSOCSTR_DDETOPIC )');
  CL.AddTypeS('TCHAR', 'ucs2char');
  {CL.AddTypeS('TFileTime', 'FILETIME');
  CL.AddTypeS('TWin32FindDataW', '_WIN32_FIND_DATAW');
  CL.AddTypeS('TCHAR', 'ucs2char');
  CL.AddTypeS('TFileTime', 'FILETIME');
  CL.AddTypeS('TWin32FindDataW', '_WIN32_FIND_DATAW');   }

   //dev: array[0..127] of char;
    {** Unique file serial number, this may change from
        one boot to the next.}
    //ino: array[0..127] of char;

  CL.AddTypeS('tresourceattribute', '( attr_any, attr_readonly, attr_hidden, at'
   +'tr_system, attr_archive, attr_link, attr_directory, attr_temporary, attr_e'
   +'ncrypted, attr_no_indexing, attr_device, attr_extended, attr_compressed, attr_offline, attr_sparse )');
  CL.AddTypeS('TFileAssociation', 'record appname : utf8string; exename : utf8string; end');
  CL.AddTypeS('tresourceattributes', 'set of tresourceattribute');
  CL.AddTypeS('TFileStats', 'record name : utf8string; size : big_integer_t; ow'
   +'ner : utf8string; ctime : TDateTime; mtime : TDateTime; atime : TDateTime;'
   +' nlink : integer; attributes : tresourceattributes; association : tfileass'
   +'ociation; streamcount : integer; accesses : integer; utc : boolean; dev: array[0..127] of char; '
   +'ino: array[0..127] of char; comment : utf8string; dirstr : utf8string; end');

   CL.AddTypeS('TSearchRecExt', 'record Stats : TFileStats; FindHandle : THandle'
   +'; W32FindData : TWin32FindData; IncludeAttr : longint; SearchAttr : TResourceAttributes; end');

 CL.AddDelphiFunction('Function GetFileOwner( fname : putf8char) : utf8string');
 CL.AddDelphiFunction('Function GetFileATime( fname : putf8char; var atime : TDateTime) : integer');
 CL.AddDelphiFunction('Function GetFileMTime( fname : putf8char; var mtime : TDateTime) : integer');
 CL.AddDelphiFunction('Function GetFileCTime( fname : putf8char; var ctime : TDateTime) : integer');
 CL.AddDelphiFunction('Function GetFilesizeext( fname : putf8char) : big_integer_t');
 CL.AddDelphiFunction('Function GetFileAttributesext( fname : putf8char) : tresourceattributes');
 CL.AddDelphiFunction('Function GetFilestats( fname : putf8char; var stats : TFileStats) : integer');
 CL.AddDelphiFunction('Function DirectoryExistsext( DName : utf8string) : Boolean');
 CL.AddDelphiFunction('Function FileExistsext( const FName : utf8string) : Boolean');
 CL.AddDelphiFunction('Function GetCurrentDirectoryext( var DirStr : utf8string) : boolean');
 CL.AddDelphiFunction('Function SetCurrentDirectoryext( const DirStr : utf8string) : boolean');
 CL.AddDelphiFunction('Function SetFileATime( fname : putf8char; newatime : tdatetime) : integer');
 CL.AddDelphiFunction('Function SetFileMTime( fname : putf8char; newmtime : tdatetime) : integer');
 CL.AddDelphiFunction('Function SetFileCTime( fname : putf8char; newctime : tdatetime) : integer');
 CL.AddDelphiFunction('Function FindFirstEx( path : putf8char; attr : tresourceattributes; var SearchRec : TSearchRecExt) : integer');
 CL.AddDelphiFunction('Function FindNextEx( var SearchRec : TSearchRecExt) : integer');
 CL.AddDelphiFunction('Procedure FindCloseEx( var SearchRec : TSearchRecExt)');
 CL.AddDelphiFunction('Function GetUserFullName( account : utf8string) : utf8string');
 CL.AddDelphiFunction('Function GetLoginConfigDirectory : utf8string');
 CL.AddDelphiFunction('Function GetGlobalConfigDirectory : utf8string');
 CL.AddDelphiFunction('Function GetLoginHomeDirectory : utf8string');

 //CL.AddDelphiFunction('function ucs4strnewstr(str: string; srctype: string): pucs4char;');
 //CL.AddDelphiFunction('function ucs4strnewucs4(src: pucs4char): pucs4char;');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_extdos_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetFileOwner, 'GetFileOwner', cdRegister);
 S.RegisterDelphiFunction(@GetFileATime, 'GetFileATime', cdRegister);
 S.RegisterDelphiFunction(@GetFileMTime, 'GetFileMTime', cdRegister);
 S.RegisterDelphiFunction(@GetFileCTime, 'GetFileCTime', cdRegister);
 S.RegisterDelphiFunction(@GetFilesize, 'GetFilesizeext', cdRegister);
 S.RegisterDelphiFunction(@GetFileAttributes, 'GetFileAttributesext', cdRegister);
 S.RegisterDelphiFunction(@GetFilestats, 'GetFilestats', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'DirectoryExistsext', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'FileExistsext', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentDirectory, 'GetCurrentDirectoryext', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentDirectory, 'SetCurrentDirectoryext', cdRegister);
 S.RegisterDelphiFunction(@SetFileATime, 'SetFileATime', cdRegister);
 S.RegisterDelphiFunction(@SetFileMTime, 'SetFileMTime', cdRegister);
 S.RegisterDelphiFunction(@SetFileCTime, 'SetFileCTime', cdRegister);
 S.RegisterDelphiFunction(@FindFirstEx, 'FindFirstEx', cdRegister);
 S.RegisterDelphiFunction(@FindNextEx, 'FindNextEx', cdRegister);
 S.RegisterDelphiFunction(@FindCloseEx, 'FindCloseEx', cdRegister);
 S.RegisterDelphiFunction(@GetUserFullName, 'GetUserFullName', cdRegister);
 S.RegisterDelphiFunction(@GetLoginConfigDirectory, 'GetLoginConfigDirectory', cdRegister);
 S.RegisterDelphiFunction(@GetGlobalConfigDirectory, 'GetGlobalConfigDirectory', cdRegister);
 S.RegisterDelphiFunction(@GetLoginHomeDirectory, 'GetLoginHomeDirectory', cdRegister);

// S.RegisterDelphiFunction(@ucs4strnewstr, 'ucs4strnewstr', cdRegister);
// S.RegisterDelphiFunction(@ucs4strnewucs4, 'ucs4strnewucs4', cdRegister);


end;

 
 
{ TPSImport_extdos }
(*----------------------------------------------------------------------------*)
procedure TPSImport_extdos.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_extdos(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_extdos.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_extdos_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
