unit uPSI_ApplicationFileIO;
{
  another file wrapper
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
  TPSImport_ApplicationFileIO = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDataFile(CL: TPSPascalCompiler);
procedure SIRegister_TApplicationFileIO(CL: TPSPascalCompiler);
procedure SIRegister_ApplicationFileIO(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ApplicationFileIO_Routines(S: TPSExec);
procedure RIRegister_TDataFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_TApplicationFileIO(CL: TPSRuntimeClassImporter);
procedure RIRegister_ApplicationFileIO(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   ApplicationFileIO
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ApplicationFileIO]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDataFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TPersistent', 'TDataFile') do
  with CL.AddClassN(CL.FindClass('TPersistent'),'TDataFile') do begin
    RegisterMethod('Constructor Create( AOwner : TPersistent)');
         RegisterMethod('Procedure Free');
      RegisterMethod('Function Capabilities : TDataFileCapabilities');
    RegisterMethod('Function CreateCopy( AOwner : TPersistent) : TDataFile');
    RegisterMethod('Procedure LoadFromFile( const fileName : String)');
    RegisterMethod('Procedure SaveToFile( const fileName : String)');
    RegisterMethod('Procedure LoadFromStream( stream : TStream)');
    RegisterMethod('Procedure SaveToStream( stream : TStream)');
    RegisterProperty('ResourceName', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TApplicationFileIO(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TApplicationFileIO') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TApplicationFileIO') do begin
    RegisterProperty('OnFileStream', 'TAFIOFileStreamEvent', iptrw);
    RegisterProperty('OnFileStreamExists', 'TAFIOFileStreamExistsEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ApplicationFileIO(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TAFIOFileStreamEvent', 'Function ( const fileName : String; mode: Word) : TStream');
  CL.AddTypeS('TAFIOFileStreamExistsEvent', 'Function ( const fileName : String) : Boolean');
  SIRegister_TApplicationFileIO(CL);
  CL.AddTypeS('TDataFileCapability', '( dfcRead, dfcWrite )');
  CL.AddTypeS('TDataFileCapabilities', 'set of TDataFileCapability');
  SIRegister_TDataFile(CL);
  //CL.AddTypeS('TDataFileClass', 'class of TDataFile');
 CL.AddDelphiFunction('Function ApplicationFileIODefined : Boolean');
                           //mode : Word = fmOpenRead+fmShareDenyNone) : TStream;
 CL.AddDelphiFunction('Function CreateFileStream(const fileName : String; mode : Word) : TStream');
 CL.AddDelphiFunction('Function FileStreamExists( const fileName : String) : Boolean');
 //CL.AddDelphiFunction('Procedure Register');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDataFileResourceName_W(Self: TDataFile; const T: String);
begin Self.ResourceName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDataFileResourceName_R(Self: TDataFile; var T: String);
begin T := Self.ResourceName; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationFileIOOnFileStreamExists_W(Self: TApplicationFileIO; const T: TAFIOFileStreamExistsEvent);
begin Self.OnFileStreamExists := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationFileIOOnFileStreamExists_R(Self: TApplicationFileIO; var T: TAFIOFileStreamExistsEvent);
begin T := Self.OnFileStreamExists; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationFileIOOnFileStream_W(Self: TApplicationFileIO; const T: TAFIOFileStreamEvent);
begin Self.OnFileStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TApplicationFileIOOnFileStream_R(Self: TApplicationFileIO; var T: TAFIOFileStreamEvent);
begin T := Self.OnFileStream; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ApplicationFileIO_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@ApplicationFileIODefined, 'ApplicationFileIODefined', cdRegister);
 S.RegisterDelphiFunction(@CreateFileStream, 'CreateFileStream', cdRegister);
 S.RegisterDelphiFunction(@FileStreamExists, 'FileStreamExists', cdRegister);
 //S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDataFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDataFile) do begin
    RegisterVirtualConstructor(@TDataFile.Create, 'Create');
       RegisterMethod(@TDataFile.Destroy, 'Free');
      RegisterVirtualMethod(@TDataFile.Capabilities, 'Capabilities');
    RegisterVirtualMethod(@TDataFile.CreateCopy, 'CreateCopy');
    RegisterVirtualMethod(@TDataFile.LoadFromFile, 'LoadFromFile');
    RegisterVirtualMethod(@TDataFile.SaveToFile, 'SaveToFile');
    //RegisterVirtualAbstractMethod(@TDataFile, @!.LoadFromStream, 'LoadFromStream');
    RegisterVirtualMethod(@TDataFile.SaveToStream, 'SaveToStream');
    RegisterPropertyHelper(@TDataFileResourceName_R,@TDataFileResourceName_W,'ResourceName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TApplicationFileIO(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TApplicationFileIO) do
  begin
    RegisterPropertyHelper(@TApplicationFileIOOnFileStream_R,@TApplicationFileIOOnFileStream_W,'OnFileStream');
    RegisterPropertyHelper(@TApplicationFileIOOnFileStreamExists_R,@TApplicationFileIOOnFileStreamExists_W,'OnFileStreamExists');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ApplicationFileIO(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TApplicationFileIO(CL);
  RIRegister_TDataFile(CL);
end;

 
 
{ TPSImport_ApplicationFileIO }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ApplicationFileIO.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ApplicationFileIO(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ApplicationFileIO.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ApplicationFileIO(ri);
  RIRegister_ApplicationFileIO_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
