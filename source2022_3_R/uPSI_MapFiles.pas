unit uPSI_MapFiles;
{
   a last map of map gap    - string based buffer
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
  TPSImport_MapFiles = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TRecordMap(CL: TPSPascalCompiler);
procedure SIRegister_TTextMap(CL: TPSPascalCompiler);
procedure SIRegister_TMapStream(CL: TPSPascalCompiler);
procedure SIRegister_MapFiles(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TRecordMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTextMap(CL: TPSRuntimeClassImporter);
procedure RIRegister_TMapStream(CL: TPSRuntimeClassImporter);
procedure RIRegister_MapFiles(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,MapFiles
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_MapFiles]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TRecordMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMapStream', 'TRecordMap') do
  with CL.AddClassN(CL.FindClass('TMapStream'),'TRecordMap') do
  begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Procedure AppendRec( const Rec)');
    RegisterMethod('Procedure First');
    RegisterMethod('Procedure Last');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTextMap(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TMapStream', 'TTextMap') do
  with CL.AddClassN(CL.FindClass('TMapStream'),'TTextMap') do
  begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Function Read( var Buffer : string; Count : Longint) : Longint');
    RegisterMethod('Function ReadChar : Char');
    RegisterMethod('Function ReadInteger : LongInt');
    RegisterMethod('Function ReadFloat : Extended');
    RegisterMethod('Function ReadLine : string');
    RegisterMethod('Function Write( const Buffer : string; Count : Longint) : Longint');
    RegisterMethod('Procedure WriteStr( const Str : string)');
    RegisterMethod('Procedure WriteStrFmt( const Fmt : string; Args : array of const)');
    RegisterMethod('Procedure WriteLineFmt( const Fmt : string; Args : array of const)');
    RegisterMethod('Procedure WriteLine( Str : string)');
    RegisterProperty('AutoGrow', 'boolean', iptrw);
    RegisterProperty('UseEncryption', 'boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TMapStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TStream', 'TMapStream') do
  with CL.AddClassN(CL.FindClass('TStream'),'TMapStream') do begin
    RegisterMethod('Constructor Create( const FileName : string)');
       RegisterMethod('Procedure Free');
    RegisterMethod('Function Read( var Buffer : string; Count : Longint) : Longint');
    RegisterMethod('Function Seek( Offset : Longint; Origin : Word) : Longint');
    RegisterMethod('Function Write( const Buffer : string; Count : Longint) : Longint');
    RegisterProperty('Active', 'boolean', iptrw);
    RegisterProperty('FileName', 'string', iptrw);
    RegisterProperty('FileOptions', 'TFileOptions', iptrw);
    RegisterProperty('MapName', 'string', iptrw);
    RegisterProperty('MutexName', 'string', iptrw);
    RegisterProperty('Position', 'cardinal', iptrw);
    RegisterProperty('ReadOnly', 'boolean', iptrw);
    RegisterProperty('ResizeOpenWarning', 'boolean', iptrw);
    RegisterProperty('Size', 'cardinal', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_MapFiles(CL: TPSPascalCompiler);
begin
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMemoryMappedFile');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EMMEndOfFile');
  CL.AddTypeS('TFileOptions', '( foCreateNew, foCreateAlways, foOpenExisting, foOpenAlways, foTruncateExisting )');
  CL.AddTypeS('TmapFileType', '( ftUnspecified, ftRandomAccess, ftSequentialAccess)');
  SIRegister_TMapStream(CL);
  SIRegister_TTextMap(CL);
  SIRegister_TRecordMap(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TTextMapUseEncryption_W(Self: TTextMap; const T: boolean);
begin Self.UseEncryption := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextMapUseEncryption_R(Self: TTextMap; var T: boolean);
begin T := Self.UseEncryption; end;

(*----------------------------------------------------------------------------*)
procedure TTextMapAutoGrow_W(Self: TTextMap; const T: boolean);
begin Self.AutoGrow := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextMapAutoGrow_R(Self: TTextMap; var T: boolean);
begin T := Self.AutoGrow; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamSize_W(Self: TMapStream; const T: cardinal);
begin Self.Size := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamSize_R(Self: TMapStream; var T: cardinal);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamResizeOpenWarning_W(Self: TMapStream; const T: boolean);
begin Self.ResizeOpenWarning := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamResizeOpenWarning_R(Self: TMapStream; var T: boolean);
begin T := Self.ResizeOpenWarning; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamReadOnly_W(Self: TMapStream; const T: boolean);
begin Self.ReadOnly := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamReadOnly_R(Self: TMapStream; var T: boolean);
begin T := Self.ReadOnly; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamPosition_W(Self: TMapStream; const T: cardinal);
begin Self.Position := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamPosition_R(Self: TMapStream; var T: cardinal);
begin T := Self.Position; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamMutexName_W(Self: TMapStream; const T: string);
begin Self.MutexName := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamMutexName_R(Self: TMapStream; var T: string);
begin T := Self.MutexName; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamMapName_W(Self: TMapStream; const T: string);
begin Self.MapName := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamMapName_R(Self: TMapStream; var T: string);
begin T := Self.MapName; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamFileOptions_W(Self: TMapStream; const T: TFileOptions);
begin Self.FileOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamFileOptions_R(Self: TMapStream; var T: TFileOptions);
begin T := Self.FileOptions; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamFileName_W(Self: TMapStream; const T: string);
begin Self.FileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamFileName_R(Self: TMapStream; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamActive_W(Self: TMapStream; const T: boolean);
begin Self.Active := T; end;

(*----------------------------------------------------------------------------*)
procedure TMapStreamActive_R(Self: TMapStream; var T: boolean);
begin T := Self.Active; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TRecordMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TRecordMap) do
  begin
    RegisterConstructor(@TRecordMap.Create, 'Create');
    RegisterMethod(@TRecordMap.AppendRec, 'AppendRec');
    RegisterMethod(@TRecordMap.First, 'First');
    RegisterMethod(@TRecordMap.Last, 'Last');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextMap(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextMap) do
  begin
    RegisterConstructor(@TTextMap.Create, 'Create');
    RegisterMethod(@TTextMap.Read, 'Read');
    RegisterMethod(@TTextMap.ReadChar, 'ReadChar');
    RegisterMethod(@TTextMap.ReadInteger, 'ReadInteger');
    RegisterMethod(@TTextMap.ReadFloat, 'ReadFloat');
    RegisterMethod(@TTextMap.ReadLine, 'ReadLine');
    RegisterMethod(@TTextMap.Write, 'Write');
    RegisterMethod(@TTextMap.WriteStr, 'WriteStr');
    RegisterMethod(@TTextMap.WriteStrFmt, 'WriteStrFmt');
    RegisterMethod(@TTextMap.WriteLineFmt, 'WriteLineFmt');
    RegisterMethod(@TTextMap.WriteLine, 'WriteLine');
    RegisterPropertyHelper(@TTextMapAutoGrow_R,@TTextMapAutoGrow_W,'AutoGrow');
    RegisterPropertyHelper(@TTextMapUseEncryption_R,@TTextMapUseEncryption_W,'UseEncryption');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMapStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TMapStream) do begin
    RegisterConstructor(@TMapStream.Create, 'Create');
    RegisterMethod(@TMapStream.Destroy, 'Free');
    RegisterMethod(@TMapStream.Read, 'Read');
    RegisterMethod(@TMapStream.Seek, 'Seek');
    RegisterMethod(@TMapStream.Write, 'Write');
    RegisterPropertyHelper(@TMapStreamActive_R,@TMapStreamActive_W,'Active');
    RegisterPropertyHelper(@TMapStreamFileName_R,@TMapStreamFileName_W,'FileName');
    RegisterPropertyHelper(@TMapStreamFileOptions_R,@TMapStreamFileOptions_W,'FileOptions');
    RegisterPropertyHelper(@TMapStreamMapName_R,@TMapStreamMapName_W,'MapName');
    RegisterPropertyHelper(@TMapStreamMutexName_R,@TMapStreamMutexName_W,'MutexName');
    RegisterPropertyHelper(@TMapStreamPosition_R,@TMapStreamPosition_W,'Position');
    RegisterPropertyHelper(@TMapStreamReadOnly_R,@TMapStreamReadOnly_W,'ReadOnly');
    RegisterPropertyHelper(@TMapStreamResizeOpenWarning_R,@TMapStreamResizeOpenWarning_W,'ResizeOpenWarning');
    RegisterPropertyHelper(@TMapStreamSize_R,@TMapStreamSize_W,'Size');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_MapFiles(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EMemoryMappedFile) do
  with CL.Add(EMMEndOfFile) do
  RIRegister_TMapStream(CL);
  RIRegister_TTextMap(CL);
  RIRegister_TRecordMap(CL);
end;

 
 
{ TPSImport_MapFiles }
(*----------------------------------------------------------------------------*)
procedure TPSImport_MapFiles.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_MapFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_MapFiles.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_MapFiles(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
