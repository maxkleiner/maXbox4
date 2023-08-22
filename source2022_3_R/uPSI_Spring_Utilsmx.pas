unit uPSI_Spring_Utilsmx;
{
   al lot of win work has to be gone
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
  TPSImport_Spring_Utilsmx = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TEnvironmentClass(CL: TPSPascalCompiler);
procedure SIRegister_TOperatingSystem(CL: TPSPascalCompiler);
procedure SIRegister_Spring_Utilsmx(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_Spring_Utilsmx_Routines(S: TPSExec);
procedure RIRegister_TEnvironmentClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOperatingSystem(CL: TPSRuntimeClassImporter);
procedure RIRegister_Spring_Utilsmx(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,DateUtils
  ,StrUtils
  ,Variants
  ,TypInfo
  ,Types
  ,ShlObj
  ,ShellAPI
  ,ActiveX
  ,ComObj
  ,Registry
  ,Spring_Utilsmx
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_Spring_Utilsmx]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TEnvironmentClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TEnvironmentClass') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TEnvironmentClass') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function GetCommandLineArgs0 : TStringDynArray;');
    RegisterMethod('Procedure GetCommandLineArgs1( list : TStrings);');
    RegisterMethod('Function GetLogicalDrives2 : TStringDynArray;');
    RegisterMethod('Procedure GetLogicalDrives3( list : TStrings);');
    RegisterMethod('Function GetFolderPath( const folder : TSpecialFolder) : string');
    RegisterMethod('Function GetEnvironmentVariable4( const variable : string) : string;');
    RegisterMethod('Function GetEnvironmentVariable5( const variable : string; target : TEnvironmentVariableTarget) : string;');
    RegisterMethod('Procedure GetEnvironmentVariables6( list : TStrings);');
    RegisterMethod('Procedure GetEnvironmentVariables7( list : TStrings; target : TEnvironmentVariableTarget);');
    RegisterMethod('Procedure SetEnvironmentVariable8( const variable, value : string);');
    RegisterMethod('Procedure SetEnvironmentVariable9( const variable, value : string; target : TEnvironmentVariableTarget);');
    RegisterMethod('Function ExpandEnvironmentVariables( const variable : string) : string');
    RegisterProperty('ApplicationPath', 'string', iptr);
    RegisterProperty('ApplicationVersion', 'TVersion', iptr);
    RegisterProperty('ApplicationVersionInfo', 'TFileVersionInfo', iptr);
    RegisterProperty('ApplicationVersionString', 'string', iptr);
    RegisterProperty('CommandLine', 'string', iptr);
    RegisterProperty('CurrentDirectory', 'string', iptrw);
    RegisterProperty('IsAdmin', 'Boolean', iptr);
    RegisterProperty('MachineName', 'string', iptr);
    RegisterProperty('NewLine', 'string', iptr);
    RegisterProperty('OperatingSystem', 'TOperatingSystem', iptr);
    RegisterProperty('ProcessorCount', 'Integer', iptr);
    RegisterProperty('ProcessorArchitecture', 'TProcessorArchitecture', iptr);
    RegisterProperty('RegisteredOrganization', 'string', iptr);
    RegisterProperty('RegisteredOwner', 'string', iptr);
    RegisterProperty('SystemDirectory', 'string', iptr);
    RegisterProperty('TickCount', 'Cardinal', iptr);
    RegisterProperty('UserDomainName', 'string', iptr);
    RegisterProperty('UserName', 'string', iptr);
    RegisterProperty('UserInteractive', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOperatingSystem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TOperatingSystem') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TOperatingSystem') do
  begin
    RegisterMethod('Constructor Create');
    RegisterProperty('IsWin3x', 'Boolean', iptr);
    RegisterProperty('IsWin9x', 'Boolean', iptr);
    RegisterProperty('IsWinNT', 'Boolean', iptr);
    RegisterProperty('ProductType', 'TOSProductType', iptr);
    RegisterProperty('ServicePack', 'string', iptr);
    RegisterProperty('Version', 'TVersion', iptr);
    RegisterProperty('VersionString', 'string', iptr);
    RegisterProperty('VersionType', 'TOSVersionType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Spring_Utilsmx(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOSPlatformType', '( ptUnknown, ptWin3x, ptWin9x, ptWinNT )');
  SIRegister_TOperatingSystem(CL);
  SIRegister_TEnvironmentClass(CL);
  CL.AddTypeS('Environment', 'TEnvironment');
 CL.AddDelphiFunction('Function ApplicationPath : string');
 //CL.AddDelphiFunction('Function ApplicationVersion : TVersion');
 CL.AddDelphiFunction('Function ApplicationVersionString : string');
 CL.AddDelphiFunction('Function GetLastErrorMessage : string');
 //CL.AddDelphiFunction('Function CreateCallback( obj : TObject; methodAddress : Pointer) : TCallbackFunc');
 CL.AddDelphiFunction('Function ConvertFileTimeToDateTime( const fileTime : TFileTime; useLocalTimeZone : Boolean) : TDateTime;');
 CL.AddDelphiFunction('Function ConvertDateTimeToFileTime( const datetime : TDateTime; useLocalTimeZone : Boolean) : TFileTime;');
 {CL.AddDelphiFunction('Procedure Synchronize( threadProc : TThreadProcedure)');
 CL.AddDelphiFunction('Procedure Queue( threadProc : TThreadProcedure)');
 CL.AddDelphiFunction('Function TryGetPropInfo( instance : TObject; const propertyName : string; out propInfo : PPropInfo) : Boolean');
 CL.AddDelphiFunction('Procedure Lock12( obj : TObject; const proc : TProc);');
 CL.AddDelphiFunction('Procedure Lock13( const intf : IInterface; const proc : TProc);');
 CL.AddDelphiFunction('Procedure UpdateStrings( strings : TStrings; proc : TProc)'); }
 CL.AddDelphiFunction('Function IsCtrlPressed : Boolean');
 CL.AddDelphiFunction('Function IsShiftPressed : Boolean');
 CL.AddDelphiFunction('Function IsAltPressed : Boolean');
 CL.AddDelphiFunction('Procedure CheckFileExists( const fileName : string)');
 CL.AddDelphiFunction('Procedure CheckDirectoryExists( const directory : string)');
 CL.AddConstantN('COneKB','Int64').SetInt64( 1024);
 CL.AddConstantN('COneMB','Int64').SetInt64( 1048576);
 CL.AddConstantN('COneGB','Int64').SetInt64( 1073741824);
 CL.AddConstantN('COneTB','Int64').SetInt64( 1099511627776);

 CL.AddDelphiFunction('function TryConvertStrToDateTime(const s, format: string; out value: TDateTime): Boolean;');
 CL.AddDelphiFunction('function ConvertStrToDateTime(const s, format: string): TDateTime;');



end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
{Procedure Lock13_P( const intf : IInterface; const proc : TProc);
Begin Spring_Utilsmx.Lock(intf, proc); END;

(*----------------------------------------------------------------------------*)
Procedure Lock12_P( obj : TObject; const proc : TProc);
Begin Spring_Utilsmx.Lock(obj, proc); END;       }

(*----------------------------------------------------------------------------*)
Function ConvertDateTimeToFileTime11_P( const datetime : TDateTime; useLocalTimeZone : Boolean) : TFileTime;
Begin Result := Spring_Utilsmx.ConvertDateTimeToFileTime(datetime, useLocalTimeZone); END;

(*----------------------------------------------------------------------------*)
Function ConvertFileTimeToDateTime10_P( const fileTime : TFileTime; useLocalTimeZone : Boolean) : TDateTime;
Begin Result := Spring_Utilsmx.ConvertFileTimeToDateTime(fileTime, useLocalTimeZone); END;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassUserInteractive_R(Self: TEnvironmentClass; var T: Boolean);
begin T := Self.UserInteractive; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassUserName_R(Self: TEnvironmentClass; var T: string);
begin T := Self.UserName; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassUserDomainName_R(Self: TEnvironmentClass; var T: string);
begin T := Self.UserDomainName; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassTickCount_R(Self: TEnvironmentClass; var T: Cardinal);
begin T := Self.TickCount; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassSystemDirectory_R(Self: TEnvironmentClass; var T: string);
begin T := Self.SystemDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassRegisteredOwner_R(Self: TEnvironmentClass; var T: string);
begin T := Self.RegisteredOwner; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassRegisteredOrganization_R(Self: TEnvironmentClass; var T: string);
begin T := Self.RegisteredOrganization; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassProcessorArchitecture_R(Self: TEnvironmentClass; var T: TProcessorArchitecture);
begin T := Self.ProcessorArchitecture; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassProcessorCount_R(Self: TEnvironmentClass; var T: Integer);
begin T := Self.ProcessorCount; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassOperatingSystem_R(Self: TEnvironmentClass; var T: TOperatingSystem);
begin T := Self.OperatingSystem; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassNewLine_R(Self: TEnvironmentClass; var T: string);
begin T := Self.NewLine; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassMachineName_R(Self: TEnvironmentClass; var T: string);
begin T := Self.MachineName; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassIsAdmin_R(Self: TEnvironmentClass; var T: Boolean);
begin T := Self.IsAdmin; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassCurrentDirectory_W(Self: TEnvironmentClass; const T: string);
begin Self.CurrentDirectory := T; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassCurrentDirectory_R(Self: TEnvironmentClass; var T: string);
begin T := Self.CurrentDirectory; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassCommandLine_R(Self: TEnvironmentClass; var T: string);
begin T := Self.CommandLine; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassApplicationVersionString_R(Self: TEnvironmentClass; var T: string);
begin T := Self.ApplicationVersionString; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassApplicationVersionInfo_R(Self: TEnvironmentClass; var T: TFileVersionInfo);
begin T := Self.ApplicationVersionInfo; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassApplicationVersion_R(Self: TEnvironmentClass; var T: TVersion);
begin T := Self.ApplicationVersion; end;

(*----------------------------------------------------------------------------*)
procedure TEnvironmentClassApplicationPath_R(Self: TEnvironmentClass; var T: string);
begin T := Self.ApplicationPath; end;

(*----------------------------------------------------------------------------*)
Procedure TEnvironmentClassSetEnvironmentVariable9_P(Self: TEnvironmentClass;  const variable, value : string; target : TEnvironmentVariableTarget);
Begin Self.SetEnvironmentVariable(variable, value, target); END;

(*----------------------------------------------------------------------------*)
Procedure TEnvironmentClassSetEnvironmentVariable8_P(Self: TEnvironmentClass;  const variable, value : string);
Begin Self.SetEnvironmentVariable(variable, value); END;

(*----------------------------------------------------------------------------*)
Procedure TEnvironmentClassGetEnvironmentVariables7_P(Self: TEnvironmentClass;  list : TStrings; target : TEnvironmentVariableTarget);
Begin Self.GetEnvironmentVariables(list, target); END;

(*----------------------------------------------------------------------------*)
Procedure TEnvironmentClassGetEnvironmentVariables6_P(Self: TEnvironmentClass;  list : TStrings);
Begin Self.GetEnvironmentVariables(list); END;

(*----------------------------------------------------------------------------*)
Function TEnvironmentClassGetEnvironmentVariable5_P(Self: TEnvironmentClass;  const variable : string; target : TEnvironmentVariableTarget) : string;
Begin Result := Self.GetEnvironmentVariable(variable, target); END;

(*----------------------------------------------------------------------------*)
Function TEnvironmentClassGetEnvironmentVariable4_P(Self: TEnvironmentClass;  const variable : string) : string;
Begin Result := Self.GetEnvironmentVariable(variable); END;

(*----------------------------------------------------------------------------*)
{Procedure TEnvironmentClassGetLogicalDrives3_P(Self: TEnvironmentClass;  list : TStrings);
Begin Self.GetLogicalDrives(list); END;

(*----------------------------------------------------------------------------*)
Function TEnvironmentClassGetLogicalDrives2_P(Self: TEnvironmentClass) : TStringDynArray;
Begin Result := Self.GetLogicalDrives; END;  }

(*----------------------------------------------------------------------------*)
{Procedure TEnvironmentClassGetCommandLineArgs1_P(Self: TEnvironmentClass;  list : TStrings);
Begin Self.GetCommandLineArgs(list); END;

(*----------------------------------------------------------------------------*)
Function TEnvironmentClassGetCommandLineArgs0_P(Self: TEnvironmentClass) : TStringDynArray;
Begin Result := Self.GetCommandLineArgs; END;    }

(*----------------------------------------------------------------------------*)
procedure TOperatingSystemVersionType_R(Self: TOperatingSystem; var T: TOSVersionType);
begin T := Self.VersionType; end;

(*----------------------------------------------------------------------------*)
procedure TOperatingSystemVersionString_R(Self: TOperatingSystem; var T: string);
begin T := Self.VersionString; end;

(*----------------------------------------------------------------------------*)
procedure TOperatingSystemVersion_R(Self: TOperatingSystem; var T: TVersion);
begin T := Self.Version; end;

(*----------------------------------------------------------------------------*)
procedure TOperatingSystemServicePack_R(Self: TOperatingSystem; var T: string);
begin T := Self.ServicePack; end;

(*----------------------------------------------------------------------------*)
procedure TOperatingSystemProductType_R(Self: TOperatingSystem; var T: TOSProductType);
begin //T := Self.ProductType;
end;

(*----------------------------------------------------------------------------*)
procedure TOperatingSystemIsWinNT_R(Self: TOperatingSystem; var T: Boolean);
begin T := Self.IsWinNT; end;

(*----------------------------------------------------------------------------*)
procedure TOperatingSystemIsWin9x_R(Self: TOperatingSystem; var T: Boolean);
begin T := Self.IsWin9x; end;

(*----------------------------------------------------------------------------*)
procedure TOperatingSystemIsWin3x_R(Self: TOperatingSystem; var T: Boolean);
begin T := Self.IsWin3x; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Spring_Utilsmx_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ApplicationPath, 'ApplicationPath', cdRegister);
 S.RegisterDelphiFunction(@ApplicationVersion, 'ApplicationVersion', cdRegister);
 S.RegisterDelphiFunction(@ApplicationVersionString, 'ApplicationVersionString', cdRegister);
 S.RegisterDelphiFunction(@GetLastErrorMessage, 'GetLastErrorMessage', cdRegister);
 //S.RegisterDelphiFunction(@CreateCallback, 'CreateCallback', cdRegister);
 S.RegisterDelphiFunction(@ConvertFileTimeToDateTime10_P, 'ConvertFileTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@ConvertDateTimeToFileTime11_P, 'ConvertDateTimeToFileTime', cdRegister);
 //S.RegisterDelphiFunction(@Synchronize, 'Synchronize', cdRegister);
 //S.RegisterDelphiFunction(@Queue, 'Queue', cdRegister);
 S.RegisterDelphiFunction(@TryGetPropInfo, 'TryGetPropInfo', cdRegister);
 //S.RegisterDelphiFunction(@Lock12, 'Lock12', cdRegister);
 //S.RegisterDelphiFunction(@Lock13, 'Lock13', cdRegister);
 //S.RegisterDelphiFunction(@UpdateStrings, 'UpdateStrings', cdRegister);
 S.RegisterDelphiFunction(@IsCtrlPressed, 'IsCtrlPressed', cdRegister);
 S.RegisterDelphiFunction(@IsShiftPressed, 'IsShiftPressed', cdRegister);
 S.RegisterDelphiFunction(@IsAltPressed, 'IsAltPressed', cdRegister);
 S.RegisterDelphiFunction(@CheckFileExists, 'CheckFileExists', cdRegister);
 S.RegisterDelphiFunction(@CheckDirectoryExists, 'CheckDirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@TryConvertStrToDateTime, 'TryConvertStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@ConvertStrToDateTime, 'ConvertStrToDateTime', cdRegister);

 //CL.AddDelphiFunction('function TryConvertStrToDateTime(const s, format: string; out value: TDateTime): Boolean;');
 //CL.AddDelphiFunction('function ConvertStrToDateTime(const s, format: string): TDateTime;');

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TEnvironmentClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TEnvironmentClass) do begin
    RegisterConstructor(@TEnvironmentClass.Create, 'Create');
       RegisterMethod(@TEnvironmentClass.Destroy, 'Free');
 {RegisterMethod(@TEnvironmentClassGetCommandLineArgs0_P, 'GetCommandLineArgs0');
    RegisterMethod(@TEnvironmentClassGetCommandLineArgs1_P, 'GetCommandLineArgs1');
    RegisterMethod(@TEnvironmentClassGetLogicalDrives2_P, 'GetLogicalDrives2');
    RegisterMethod(@TEnvironmentClassGetLogicalDrives3_P, 'GetLogicalDrives3');   }
    RegisterMethod(@TEnvironmentClass.GetFolderPath, 'GetFolderPath');
    RegisterMethod(@TEnvironmentClassGetEnvironmentVariable4_P, 'GetEnvironmentVariable4');
    RegisterMethod(@TEnvironmentClassGetEnvironmentVariable5_P, 'GetEnvironmentVariable5');
    RegisterMethod(@TEnvironmentClassGetEnvironmentVariables6_P, 'GetEnvironmentVariables6');
    RegisterMethod(@TEnvironmentClassGetEnvironmentVariables7_P, 'GetEnvironmentVariables7');
    RegisterMethod(@TEnvironmentClassSetEnvironmentVariable8_P, 'SetEnvironmentVariable8');
    RegisterMethod(@TEnvironmentClassSetEnvironmentVariable9_P, 'SetEnvironmentVariable9');
    RegisterMethod(@TEnvironmentClass.ExpandEnvironmentVariables, 'ExpandEnvironmentVariables');
    RegisterPropertyHelper(@TEnvironmentClassApplicationPath_R,nil,'ApplicationPath');
    RegisterPropertyHelper(@TEnvironmentClassApplicationVersion_R,nil,'ApplicationVersion');
    RegisterPropertyHelper(@TEnvironmentClassApplicationVersionInfo_R,nil,'ApplicationVersionInfo');
    RegisterPropertyHelper(@TEnvironmentClassApplicationVersionString_R,nil,'ApplicationVersionString');
    RegisterPropertyHelper(@TEnvironmentClassCommandLine_R,nil,'CommandLine');
    RegisterPropertyHelper(@TEnvironmentClassCurrentDirectory_R,@TEnvironmentClassCurrentDirectory_W,'CurrentDirectory');
    RegisterPropertyHelper(@TEnvironmentClassIsAdmin_R,nil,'IsAdmin');
    RegisterPropertyHelper(@TEnvironmentClassMachineName_R,nil,'MachineName');
    RegisterPropertyHelper(@TEnvironmentClassNewLine_R,nil,'NewLine');
    RegisterPropertyHelper(@TEnvironmentClassOperatingSystem_R,nil,'OperatingSystem');
    RegisterPropertyHelper(@TEnvironmentClassProcessorCount_R,nil,'ProcessorCount');
    RegisterPropertyHelper(@TEnvironmentClassProcessorArchitecture_R,nil,'ProcessorArchitecture');
    RegisterPropertyHelper(@TEnvironmentClassRegisteredOrganization_R,nil,'RegisteredOrganization');
    RegisterPropertyHelper(@TEnvironmentClassRegisteredOwner_R,nil,'RegisteredOwner');
    RegisterPropertyHelper(@TEnvironmentClassSystemDirectory_R,nil,'SystemDirectory');
    RegisterPropertyHelper(@TEnvironmentClassTickCount_R,nil,'TickCount');
    RegisterPropertyHelper(@TEnvironmentClassUserDomainName_R,nil,'UserDomainName');
    RegisterPropertyHelper(@TEnvironmentClassUserName_R,nil,'UserName');
    RegisterPropertyHelper(@TEnvironmentClassUserInteractive_R,nil,'UserInteractive');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOperatingSystem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOperatingSystem) do
  begin
    RegisterConstructor(@TOperatingSystem.Create, 'Create');
    RegisterPropertyHelper(@TOperatingSystemIsWin3x_R,nil,'IsWin3x');
    RegisterPropertyHelper(@TOperatingSystemIsWin9x_R,nil,'IsWin9x');
    RegisterPropertyHelper(@TOperatingSystemIsWinNT_R,nil,'IsWinNT');
    RegisterPropertyHelper(@TOperatingSystemProductType_R,nil,'ProductType');
    RegisterPropertyHelper(@TOperatingSystemServicePack_R,nil,'ServicePack');
    RegisterPropertyHelper(@TOperatingSystemVersion_R,nil,'Version');
    RegisterPropertyHelper(@TOperatingSystemVersionString_R,nil,'VersionString');
    RegisterPropertyHelper(@TOperatingSystemVersionType_R,nil,'VersionType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Spring_Utilsmx(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOperatingSystem(CL);
  RIRegister_TEnvironmentClass(CL);
end;

 
 
{ TPSImport_Spring_Utilsmx }
(*----------------------------------------------------------------------------*)
procedure TPSImport_Spring_Utilsmx.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_Spring_Utilsmx(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_Spring_Utilsmx.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_Spring_Utilsmx(ri);
  RIRegister_Spring_Utilsmx_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
