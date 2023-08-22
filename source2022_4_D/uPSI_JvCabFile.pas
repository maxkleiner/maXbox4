unit uPSI_JvCabFile;
{
   cab format
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
  TPSImport_JvCabFile = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJvCabFile(CL: TPSPascalCompiler);
procedure SIRegister_JvCabFile(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJvCabFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_JvCabFile(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Messages
  ,Graphics
  ,Controls
  ,JvTypes
  ,JvComponent
  ,JvCabFile
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JvCabFile]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJvCabFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJvComponent', 'TJvCabFile') do
  with CL.AddClassN(CL.FindClass('TJvComponent'),'TJvCabFile') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Function ExtractAll( DestPath : string) : Boolean');
    RegisterMethod('Function ExtractFile( FileName : string; DestPath : string) : Boolean');
    RegisterProperty('FileName', 'TFileName', iptrw);
    RegisterProperty('Files', 'TStringList', iptrw);
    RegisterProperty('OnCabInfo', 'TOnCabInfo', iptrw);
    RegisterProperty('OnFilesListed', 'TNotifyEvent', iptrw);
    RegisterProperty('OnFileExtracted', 'TOnExtracted', iptrw);
    RegisterProperty('OnStartFileExtraction', 'TOnExtractFile', iptrw);
    RegisterProperty('OnNeedNewCabinet', 'TOnNeedNewCabinet', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JvCabFile(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCabInfo', 'record CabinetPath : string; CabinetFile : string; D'
   +'iskName : string; Id : Shortint; CabinetNumber : Shortint; end');
  CL.AddTypeS('TOnCabInfo', 'Procedure ( Sender : TObject; CabInfo : TCabInfo)');
  CL.AddTypeS('TOnExtracted', 'Procedure ( Sender : TObject; Successed : Boolea'
   +'n; var Cont : Boolean; Source, Dest : string)');
  CL.AddTypeS('TOnExtractFile', 'Procedure ( Sender : TObject; FileName : strin'
   +'g; DestPath : string)');
  CL.AddTypeS('TOnNeedNewCabinet', 'Procedure ( Sender : TObject; var Cont : Bo'
   +'olean; CabInfo : TCabInfo; var NewPath : string)');
  SIRegister_TJvCabFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnNeedNewCabinet_W(Self: TJvCabFile; const T: TOnNeedNewCabinet);
begin Self.OnNeedNewCabinet := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnNeedNewCabinet_R(Self: TJvCabFile; var T: TOnNeedNewCabinet);
begin T := Self.OnNeedNewCabinet; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnStartFileExtraction_W(Self: TJvCabFile; const T: TOnExtractFile);
begin Self.OnStartFileExtraction := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnStartFileExtraction_R(Self: TJvCabFile; var T: TOnExtractFile);
begin T := Self.OnStartFileExtraction; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnFileExtracted_W(Self: TJvCabFile; const T: TOnExtracted);
begin Self.OnFileExtracted := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnFileExtracted_R(Self: TJvCabFile; var T: TOnExtracted);
begin T := Self.OnFileExtracted; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnFilesListed_W(Self: TJvCabFile; const T: TNotifyEvent);
begin Self.OnFilesListed := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnFilesListed_R(Self: TJvCabFile; var T: TNotifyEvent);
begin T := Self.OnFilesListed; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnCabInfo_W(Self: TJvCabFile; const T: TOnCabInfo);
begin Self.OnCabInfo := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileOnCabInfo_R(Self: TJvCabFile; var T: TOnCabInfo);
begin T := Self.OnCabInfo; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileFiles_W(Self: TJvCabFile; const T: TStringList);
begin Self.Files := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileFiles_R(Self: TJvCabFile; var T: TStringList);
begin T := Self.Files; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileFileName_W(Self: TJvCabFile; const T: TFileName);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TJvCabFileFileName_R(Self: TJvCabFile; var T: TFileName);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJvCabFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJvCabFile) do
  begin
    RegisterConstructor(@TJvCabFile.Create, 'Create');
    RegisterMethod(@TJvCabFile.ExtractAll, 'ExtractAll');
    RegisterMethod(@TJvCabFile.ExtractFile, 'ExtractFile');
    RegisterPropertyHelper(@TJvCabFileFileName_R,@TJvCabFileFileName_W,'FileName');
    RegisterPropertyHelper(@TJvCabFileFiles_R,@TJvCabFileFiles_W,'Files');
    RegisterPropertyHelper(@TJvCabFileOnCabInfo_R,@TJvCabFileOnCabInfo_W,'OnCabInfo');
    RegisterPropertyHelper(@TJvCabFileOnFilesListed_R,@TJvCabFileOnFilesListed_W,'OnFilesListed');
    RegisterPropertyHelper(@TJvCabFileOnFileExtracted_R,@TJvCabFileOnFileExtracted_W,'OnFileExtracted');
    RegisterPropertyHelper(@TJvCabFileOnStartFileExtraction_R,@TJvCabFileOnStartFileExtraction_W,'OnStartFileExtraction');
    RegisterPropertyHelper(@TJvCabFileOnNeedNewCabinet_R,@TJvCabFileOnNeedNewCabinet_W,'OnNeedNewCabinet');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JvCabFile(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJvCabFile(CL);
end;

 
 
{ TPSImport_JvCabFile }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCabFile.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JvCabFile(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JvCabFile.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JvCabFile(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
