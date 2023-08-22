unit uPSI_JclTD32;
{
   to inspect and test
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
  TPSImport_JclTD32 = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TJclPeBorTD32Image(CL: TPSPascalCompiler);
procedure SIRegister_TJclTD32InfoScanner(CL: TPSPascalCompiler);
procedure SIRegister_TJclTD32InfoParser(CL: TPSPascalCompiler);
procedure SIRegister_TJclProcSymbolInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJclSymbolInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJclSourceModuleInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJclLineInfo(CL: TPSPascalCompiler);
procedure SIRegister_TJclModuleInfo(CL: TPSPascalCompiler);
procedure SIRegister_JclTD32(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TJclPeBorTD32Image(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclTD32InfoScanner(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclTD32InfoParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclProcSymbolInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSymbolInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclSourceModuleInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclLineInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TJclModuleInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_JclTD32(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Contnrs
  ,JclBase
  ,JclFileUtils
  ,JclPeImage
  ,JclTD32
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_JclTD32]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclPeBorTD32Image(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclPeBorImage', 'TJclPeBorTD32Image') do
  with CL.AddClassN(CL.FindClass('TJclPeBorImage'),'TJclPeBorTD32Image') do
  begin
    RegisterProperty('IsTD32DebugPresent', 'Boolean', iptr);
    RegisterProperty('TD32DebugData', 'TCustomMemoryStream', iptr);
    RegisterProperty('TD32Scanner', 'TJclTD32InfoScanner', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclTD32InfoScanner(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclTD32InfoParser', 'TJclTD32InfoScanner') do
  with CL.AddClassN(CL.FindClass('TJclTD32InfoParser'),'TJclTD32InfoScanner') do
  begin
    RegisterMethod('Function LineNumberFromAddr( AAddr : DWORD; var Offset : Integer) : Integer;');
    RegisterMethod('Function LineNumberFromAddr1( AAddr : DWORD) : Integer;');
    RegisterMethod('Function ProcNameFromAddr( AAddr : DWORD) : string;');
    RegisterMethod('Function ProcNameFromAddr1( AAddr : DWORD; var Offset : Integer) : string;');
    RegisterMethod('Function ModuleNameFromAddr( AAddr : DWORD) : string');
    RegisterMethod('Function SourceNameFromAddr( AAddr : DWORD) : string');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclTD32InfoParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclTD32InfoParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclTD32InfoParser') do
  begin
    RegisterMethod('Constructor Create( const ATD32Data : TCustomMemoryStream)');
    RegisterMethod('Function FindModule( const AAddr : DWORD; var AMod : TJclModuleInfo) : Boolean');
    RegisterMethod('Function FindSourceModule( const AAddr : DWORD; var ASrcMod : TJclSourceModuleInfo) : Boolean');
    RegisterMethod('Function FindProc( const AAddr : DWORD; var AProc : TJclProcSymbolInfo) : Boolean');
    RegisterMethod('Function IsTD32Sign( const Sign : TJclTD32FileSignature) : Boolean');
    RegisterMethod('Function IsTD32DebugInfoValid( const DebugData : Pointer; const DebugDataSize : LongWord) : Boolean');
    RegisterProperty('Data', 'TCustomMemoryStream', iptr);
    RegisterProperty('Names', 'string Integer', iptr);
    RegisterProperty('NameCount', 'Integer', iptr);
    RegisterProperty('Symbols', 'TJclSymbolInfo Integer', iptr);
    RegisterProperty('SymbolCount', 'Integer', iptr);
    RegisterProperty('Modules', 'TJclModuleInfo Integer', iptr);
    RegisterProperty('ModuleCount', 'Integer', iptr);
    RegisterProperty('SourceModules', 'TJclSourceModuleInfo Integer', iptr);
    RegisterProperty('SourceModuleCount', 'Integer', iptr);
    RegisterProperty('ValidData', 'Boolean', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclProcSymbolInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TJclSymbolInfo', 'TJclProcSymbolInfo') do
  with CL.AddClassN(CL.FindClass('TJclSymbolInfo'),'TJclProcSymbolInfo') do
  begin
    RegisterProperty('NameIndex', 'DWORD', iptr);
    RegisterProperty('Offset', 'DWORD', iptr);
    RegisterProperty('Size', 'DWORD', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSymbolInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSymbolInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSymbolInfo') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclSourceModuleInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclSourceModuleInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclSourceModuleInfo') do
  begin
    RegisterMethod('Function FindLine( const AAddr : DWORD; var ALine : TJclLineInfo) : Boolean');
    RegisterProperty('NameIndex', 'DWORD', iptr);
    RegisterProperty('LineCount', 'Integer', iptr);
    RegisterProperty('Line', 'TJclLineInfo Integer', iptr);
    SetDefaultPropery('Line');
    RegisterProperty('SegmentCount', 'Integer', iptr);
    RegisterProperty('Segment', 'TOffsetPair Integer', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclLineInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclLineInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclLineInfo') do
  begin
    RegisterProperty('LineNo', 'DWORD', iptr);
    RegisterProperty('Offset', 'DWORD', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TJclModuleInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TJclModuleInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TJclModuleInfo') do
  begin
    RegisterProperty('NameIndex', 'DWORD', iptr);
    RegisterProperty('SegmentCount', 'Integer', iptr);
    RegisterProperty('Segment', 'TSegmentInfo Integer', iptr);
    SetDefaultPropery('Segment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_JclTD32(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('Borland32BitSymbolFileSignatureForDelphi','LongWord').SetUInt( $39304246);
 CL.AddConstantN('Borland32BitSymbolFileSignatureForBCB','LongWord').SetUInt( $41304246);
  //CL.AddTypeS('PJclTD32FileSignature', '^TJclTD32FileSignature // will not work');
  CL.AddTypeS('TJclTD32FileSignature', 'record Signature : DWORD; Offset : DWORD; end');
 CL.AddConstantN('SUBSECTION_TYPE_MODULE','LongWord').SetUInt( $120);
 CL.AddConstantN('SUBSECTION_TYPE_TYPES','LongWord').SetUInt( $121);
 CL.AddConstantN('SUBSECTION_TYPE_SYMBOLS','LongWord').SetUInt( $124);
 CL.AddConstantN('SUBSECTION_TYPE_ALIGN_SYMBOLS','LongWord').SetUInt( $125);
 CL.AddConstantN('SUBSECTION_TYPE_SOURCE_MODULE','LongWord').SetUInt( $127);
 CL.AddConstantN('SUBSECTION_TYPE_GLOBAL_SYMBOLS','LongWord').SetUInt( $129);
 CL.AddConstantN('SUBSECTION_TYPE_GLOBAL_TYPES','LongWord').SetUInt( $12B);
 CL.AddConstantN('SUBSECTION_TYPE_NAMES','LongWord').SetUInt( $130);
  //CL.AddTypeS('PDirectoryEntry', '^TDirectoryEntry // will not work');
  CL.AddTypeS('TDirectoryEntry', 'record SubsectionType : Word; ModuleIndex : W'
   +'ord; Offset : DWORD; Size : DWORD; end');
  //CL.AddTypeS('PDirectoryHeader', '^TDirectoryHeader // will not work');
  //CL.AddTypeS('PSegmentInfo', '^TSegmentInfo // will not work');
  CL.AddTypeS('TSegmentInfo', 'record Segment : Word; Flags : Word; Offset : DWORD; Size : DWORD; end');
  //CL.AddTypeS('PSegmentInfoArray', '^TSegmentInfoArray // will not work');
  //CL.AddTypeS('PModuleInfo', '^TModuleInfo // will not work');
  //CL.AddTypeS('PLineMappingEntry', '^TLineMappingEntry // will not work');
  CL.AddTypeS('TOffsetPair', 'record StartOffset : DWORD; EndOffset : DWORD; end');
  //CL.AddTypeS('POffsetPairArray', '^TOffsetPairArray // will not work');
  //CL.AddTypeS('PSourceFileEntry', '^TSourceFileEntry // will not work');
  //CL.AddTypeS('PSourceModuleInfo', '^TSourceModuleInfo // will not work');
  //CL.AddTypeS('PGlobalTypeInfo', '^TGlobalTypeInfo // will not work');
 CL.AddConstantN('SYMBOL_TYPE_COMPILE','LongWord').SetUInt( $0001);
 CL.AddConstantN('SYMBOL_TYPE_REGISTER','LongWord').SetUInt( $0002);
 CL.AddConstantN('SYMBOL_TYPE_CONST','LongWord').SetUInt( $0003);
 CL.AddConstantN('SYMBOL_TYPE_UDT','LongWord').SetUInt( $0004);
 CL.AddConstantN('SYMBOL_TYPE_SSEARCH','LongWord').SetUInt( $0005);
 CL.AddConstantN('SYMBOL_TYPE_END','LongWord').SetUInt( $0006);
 CL.AddConstantN('SYMBOL_TYPE_SKIP','LongWord').SetUInt( $0007);
 CL.AddConstantN('SYMBOL_TYPE_CVRESERVE','LongWord').SetUInt( $0008);
 CL.AddConstantN('SYMBOL_TYPE_OBJNAME','LongWord').SetUInt( $0009);
 CL.AddConstantN('SYMBOL_TYPE_BPREL16','LongWord').SetUInt( $0100);
 CL.AddConstantN('SYMBOL_TYPE_LDATA16','LongWord').SetUInt( $0101);
 CL.AddConstantN('SYMBOL_TYPE_GDATA16','LongWord').SetUInt( $0102);
 CL.AddConstantN('SYMBOL_TYPE_PUB16','LongWord').SetUInt( $0103);
 CL.AddConstantN('SYMBOL_TYPE_LPROC16','LongWord').SetUInt( $0104);
 CL.AddConstantN('SYMBOL_TYPE_GPROC16','LongWord').SetUInt( $0105);
 CL.AddConstantN('SYMBOL_TYPE_THUNK16','LongWord').SetUInt( $0106);
 CL.AddConstantN('SYMBOL_TYPE_BLOCK16','LongWord').SetUInt( $0107);
 CL.AddConstantN('SYMBOL_TYPE_WITH16','LongWord').SetUInt( $0108);
 CL.AddConstantN('SYMBOL_TYPE_LABEL16','LongWord').SetUInt( $0109);
 CL.AddConstantN('SYMBOL_TYPE_CEXMODEL16','LongWord').SetUInt( $010A);
 CL.AddConstantN('SYMBOL_TYPE_VFTPATH16','LongWord').SetUInt( $010B);
 CL.AddConstantN('SYMBOL_TYPE_BPREL32','LongWord').SetUInt( $0200);
 CL.AddConstantN('SYMBOL_TYPE_LDATA32','LongWord').SetUInt( $0201);
 CL.AddConstantN('SYMBOL_TYPE_GDATA32','LongWord').SetUInt( $0202);
 CL.AddConstantN('SYMBOL_TYPE_PUB32','LongWord').SetUInt( $0203);
 CL.AddConstantN('SYMBOL_TYPE_LPROC32','LongWord').SetUInt( $0204);
 CL.AddConstantN('SYMBOL_TYPE_GPROC32','LongWord').SetUInt( $0205);
 CL.AddConstantN('SYMBOL_TYPE_THUNK32','LongWord').SetUInt( $0206);
 CL.AddConstantN('SYMBOL_TYPE_BLOCK32','LongWord').SetUInt( $0207);
 CL.AddConstantN('SYMBOL_TYPE_WITH32','LongWord').SetUInt( $0208);
 CL.AddConstantN('SYMBOL_TYPE_LABEL32','LongWord').SetUInt( $0209);
 CL.AddConstantN('SYMBOL_TYPE_CEXMODEL32','LongWord').SetUInt( $020A);
 CL.AddConstantN('SYMBOL_TYPE_VFTPATH32','LongWord').SetUInt( $020B);
  CL.AddTypeS('TSymbolProcInfo', 'record pParent : DWORD; pEnd : DWORD; pNext :'
   +' DWORD; Size : DWORD; DebugStart : DWORD; DebugEnd : DWORD; Offset : DWORD'
   +'; Segment : Word; ProcType : DWORD; NearFar : Byte; Reserved : Byte; NameIndex : DWORD; end');
  //CL.AddTypeS('PSymbolInfo', '^TSymbolInfo // will not work');
  CL.AddTypeS('TSymbolInfo', 'record Size : Word; SymbolType : Word; end');
  //CL.AddTypeS('PSymbolInfos', '^TSymbolInfos // will not work');
  SIRegister_TJclModuleInfo(CL);
  SIRegister_TJclLineInfo(CL);
  SIRegister_TJclSourceModuleInfo(CL);
  SIRegister_TJclSymbolInfo(CL);
  SIRegister_TJclProcSymbolInfo(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclLocalProcSymbolInfo');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TJclGlobalProcSymbolInfo');
  SIRegister_TJclTD32InfoParser(CL);
  SIRegister_TJclTD32InfoScanner(CL);
  SIRegister_TJclPeBorTD32Image(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TJclPeBorTD32ImageTD32Scanner_R(Self: TJclPeBorTD32Image; var T: TJclTD32InfoScanner);
begin T := Self.TD32Scanner; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorTD32ImageTD32DebugData_R(Self: TJclPeBorTD32Image; var T: TCustomMemoryStream);
begin T := Self.TD32DebugData; end;

(*----------------------------------------------------------------------------*)
procedure TJclPeBorTD32ImageIsTD32DebugPresent_R(Self: TJclPeBorTD32Image; var T: Boolean);
begin T := Self.IsTD32DebugPresent; end;

(*----------------------------------------------------------------------------*)
Function TJclTD32InfoScannerProcNameFromAddr1_P(Self: TJclTD32InfoScanner;  AAddr : DWORD; var Offset : Integer) : string;
Begin Result := Self.ProcNameFromAddr(AAddr, Offset); END;

(*----------------------------------------------------------------------------*)
Function TJclTD32InfoScannerProcNameFromAddr_P(Self: TJclTD32InfoScanner;  AAddr : DWORD) : string;
Begin Result := Self.ProcNameFromAddr(AAddr); END;

(*----------------------------------------------------------------------------*)
Function TJclTD32InfoScannerLineNumberFromAddr1_P(Self: TJclTD32InfoScanner;  AAddr : DWORD) : Integer;
Begin Result := Self.LineNumberFromAddr(AAddr); END;

(*----------------------------------------------------------------------------*)
Function TJclTD32InfoScannerLineNumberFromAddr_P(Self: TJclTD32InfoScanner;  AAddr : DWORD; var Offset : Integer) : Integer;
Begin Result := Self.LineNumberFromAddr(AAddr, Offset); END;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserValidData_R(Self: TJclTD32InfoParser; var T: Boolean);
begin T := Self.ValidData; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserSourceModuleCount_R(Self: TJclTD32InfoParser; var T: Integer);
begin T := Self.SourceModuleCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserSourceModules_R(Self: TJclTD32InfoParser; var T: TJclSourceModuleInfo; const t1: Integer);
begin T := Self.SourceModules[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserModuleCount_R(Self: TJclTD32InfoParser; var T: Integer);
begin T := Self.ModuleCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserModules_R(Self: TJclTD32InfoParser; var T: TJclModuleInfo; const t1: Integer);
begin T := Self.Modules[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserSymbolCount_R(Self: TJclTD32InfoParser; var T: Integer);
begin T := Self.SymbolCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserSymbols_R(Self: TJclTD32InfoParser; var T: TJclSymbolInfo; const t1: Integer);
begin T := Self.Symbols[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserNameCount_R(Self: TJclTD32InfoParser; var T: Integer);
begin T := Self.NameCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserNames_R(Self: TJclTD32InfoParser; var T: string; const t1: Integer);
begin T := Self.Names[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclTD32InfoParserData_R(Self: TJclTD32InfoParser; var T: TCustomMemoryStream);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure TJclProcSymbolInfoSize_R(Self: TJclProcSymbolInfo; var T: DWORD);
begin T := Self.Size; end;

(*----------------------------------------------------------------------------*)
procedure TJclProcSymbolInfoOffset_R(Self: TJclProcSymbolInfo; var T: DWORD);
begin T := Self.Offset; end;

(*----------------------------------------------------------------------------*)
procedure TJclProcSymbolInfoNameIndex_R(Self: TJclProcSymbolInfo; var T: DWORD);
begin T := Self.NameIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclSourceModuleInfoSegment_R(Self: TJclSourceModuleInfo; var T: TOffsetPair; const t1: Integer);
begin T := Self.Segment[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSourceModuleInfoSegmentCount_R(Self: TJclSourceModuleInfo; var T: Integer);
begin T := Self.SegmentCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclSourceModuleInfoLine_R(Self: TJclSourceModuleInfo; var T: TJclLineInfo; const t1: Integer);
begin T := Self.Line[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclSourceModuleInfoLineCount_R(Self: TJclSourceModuleInfo; var T: Integer);
begin T := Self.LineCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclSourceModuleInfoNameIndex_R(Self: TJclSourceModuleInfo; var T: DWORD);
begin T := Self.NameIndex; end;

(*----------------------------------------------------------------------------*)
procedure TJclLineInfoOffset_R(Self: TJclLineInfo; var T: DWORD);
begin T := Self.Offset; end;

(*----------------------------------------------------------------------------*)
procedure TJclLineInfoLineNo_R(Self: TJclLineInfo; var T: DWORD);
begin T := Self.LineNo; end;

(*----------------------------------------------------------------------------*)
procedure TJclModuleInfoSegment_R(Self: TJclModuleInfo; var T: TSegmentInfo; const t1: Integer);
begin T := Self.Segment[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TJclModuleInfoSegmentCount_R(Self: TJclModuleInfo; var T: Integer);
begin T := Self.SegmentCount; end;

(*----------------------------------------------------------------------------*)
procedure TJclModuleInfoNameIndex_R(Self: TJclModuleInfo; var T: DWORD);
begin T := Self.NameIndex; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclPeBorTD32Image(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclPeBorTD32Image) do
  begin
    RegisterPropertyHelper(@TJclPeBorTD32ImageIsTD32DebugPresent_R,nil,'IsTD32DebugPresent');
    RegisterPropertyHelper(@TJclPeBorTD32ImageTD32DebugData_R,nil,'TD32DebugData');
    RegisterPropertyHelper(@TJclPeBorTD32ImageTD32Scanner_R,nil,'TD32Scanner');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclTD32InfoScanner(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclTD32InfoScanner) do
  begin
    RegisterMethod(@TJclTD32InfoScannerLineNumberFromAddr_P, 'LineNumberFromAddr');
    RegisterMethod(@TJclTD32InfoScannerLineNumberFromAddr1_P, 'LineNumberFromAddr1');
    RegisterMethod(@TJclTD32InfoScannerProcNameFromAddr_P, 'ProcNameFromAddr');
    RegisterMethod(@TJclTD32InfoScannerProcNameFromAddr1_P, 'ProcNameFromAddr1');
    RegisterMethod(@TJclTD32InfoScanner.ModuleNameFromAddr, 'ModuleNameFromAddr');
    RegisterMethod(@TJclTD32InfoScanner.SourceNameFromAddr, 'SourceNameFromAddr');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclTD32InfoParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclTD32InfoParser) do
  begin
    RegisterConstructor(@TJclTD32InfoParser.Create, 'Create');
    RegisterMethod(@TJclTD32InfoParser.FindModule, 'FindModule');
    RegisterMethod(@TJclTD32InfoParser.FindSourceModule, 'FindSourceModule');
    RegisterMethod(@TJclTD32InfoParser.FindProc, 'FindProc');
    RegisterMethod(@TJclTD32InfoParser.IsTD32Sign, 'IsTD32Sign');
    RegisterMethod(@TJclTD32InfoParser.IsTD32DebugInfoValid, 'IsTD32DebugInfoValid');
    RegisterPropertyHelper(@TJclTD32InfoParserData_R,nil,'Data');
    RegisterPropertyHelper(@TJclTD32InfoParserNames_R,nil,'Names');
    RegisterPropertyHelper(@TJclTD32InfoParserNameCount_R,nil,'NameCount');
    RegisterPropertyHelper(@TJclTD32InfoParserSymbols_R,nil,'Symbols');
    RegisterPropertyHelper(@TJclTD32InfoParserSymbolCount_R,nil,'SymbolCount');
    RegisterPropertyHelper(@TJclTD32InfoParserModules_R,nil,'Modules');
    RegisterPropertyHelper(@TJclTD32InfoParserModuleCount_R,nil,'ModuleCount');
    RegisterPropertyHelper(@TJclTD32InfoParserSourceModules_R,nil,'SourceModules');
    RegisterPropertyHelper(@TJclTD32InfoParserSourceModuleCount_R,nil,'SourceModuleCount');
    RegisterPropertyHelper(@TJclTD32InfoParserValidData_R,nil,'ValidData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclProcSymbolInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclProcSymbolInfo) do
  begin
    RegisterPropertyHelper(@TJclProcSymbolInfoNameIndex_R,nil,'NameIndex');
    RegisterPropertyHelper(@TJclProcSymbolInfoOffset_R,nil,'Offset');
    RegisterPropertyHelper(@TJclProcSymbolInfoSize_R,nil,'Size');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSymbolInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSymbolInfo) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclSourceModuleInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclSourceModuleInfo) do
  begin
    RegisterMethod(@TJclSourceModuleInfo.FindLine, 'FindLine');
    RegisterPropertyHelper(@TJclSourceModuleInfoNameIndex_R,nil,'NameIndex');
    RegisterPropertyHelper(@TJclSourceModuleInfoLineCount_R,nil,'LineCount');
    RegisterPropertyHelper(@TJclSourceModuleInfoLine_R,nil,'Line');
    RegisterPropertyHelper(@TJclSourceModuleInfoSegmentCount_R,nil,'SegmentCount');
    RegisterPropertyHelper(@TJclSourceModuleInfoSegment_R,nil,'Segment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclLineInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclLineInfo) do
  begin
    RegisterPropertyHelper(@TJclLineInfoLineNo_R,nil,'LineNo');
    RegisterPropertyHelper(@TJclLineInfoOffset_R,nil,'Offset');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TJclModuleInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TJclModuleInfo) do
  begin
    RegisterPropertyHelper(@TJclModuleInfoNameIndex_R,nil,'NameIndex');
    RegisterPropertyHelper(@TJclModuleInfoSegmentCount_R,nil,'SegmentCount');
    RegisterPropertyHelper(@TJclModuleInfoSegment_R,nil,'Segment');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_JclTD32(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TJclModuleInfo(CL);
  RIRegister_TJclLineInfo(CL);
  RIRegister_TJclSourceModuleInfo(CL);
  RIRegister_TJclSymbolInfo(CL);
  RIRegister_TJclProcSymbolInfo(CL);
  with CL.Add(TJclLocalProcSymbolInfo) do
  with CL.Add(TJclGlobalProcSymbolInfo) do
  RIRegister_TJclTD32InfoParser(CL);
  RIRegister_TJclTD32InfoScanner(CL);
  RIRegister_TJclPeBorTD32Image(CL);
end;

 
 
{ TPSImport_JclTD32 }
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclTD32.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_JclTD32(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_JclTD32.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_JclTD32(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
