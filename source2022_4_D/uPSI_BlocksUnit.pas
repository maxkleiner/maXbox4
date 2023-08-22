unit uPSI_BlocksUnit;
{
https://docwiki.embarcadero.com/Libraries/Sydney/en/System.Hash.THashSHA2
and PascalCoin
//change TInput Toutput TInputs Toutputs to TInputbc  - T32 --> T32se

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
  TPSImport_BlocksUnit = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 

{ compile-time registration functions }
procedure SIRegister_TBlocks(CL: TPSPascalCompiler);
procedure SIRegister_TBlockRecord(CL: TPSPascalCompiler);
procedure SIRegister_TBlockTransactions(CL: TPSPascalCompiler);
procedure SIRegister_TTransaction(CL: TPSPascalCompiler);
procedure SIRegister_TOutputsbc(CL: TPSPascalCompiler);
procedure SIRegister_TInputsbc(CL: TPSPascalCompiler);
procedure SIRegister_TOutputbc(CL: TPSPascalCompiler);
procedure SIRegister_TInputbc(CL: TPSPascalCompiler);
procedure SIRegister_TBlockFile(CL: TPSPascalCompiler);
procedure SIRegister_BlocksUnit(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TBlocks(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBlockRecord(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBlockTransactions(CL: TPSRuntimeClassImporter);
procedure RIRegister_TTransaction(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOutputsbc(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInputsbc(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOutputbc(CL: TPSRuntimeClassImporter);
procedure RIRegister_TInputbc(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBlockFile(CL: TPSRuntimeClassImporter);
procedure RIRegister_BlocksUnit(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Contnrs
  ,SeSHA256
  ,BlocksUnit
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_BlocksUnit]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlocks(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TBlocks') do
  with CL.AddClassN(CL.FindClass('TObject'),'TBlocks') do
  begin
    RegisterProperty('BlocksDir', 'string', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure ParseBlockFiles( const aBlocksDirectory : string)');
    RegisterMethod('Procedure ProcessBlock( const aBlockFile : TBlockFile)');
    RegisterProperty('OnStartParsing', 'TNotifyEvent', iptrw);
    RegisterProperty('OnEndParsing', 'TNotifyEvent', iptrw);
    RegisterProperty('OnStartProcessFiles', 'TStartFileBlockFoundNotify', iptrw);
    RegisterProperty('OnBeforeFileBlockProcess', 'TFoundFileBlockNotify', iptrw);
    RegisterProperty('OnAfterFileBlockProcessed', 'TFoundFileBlockNotify', iptrw);
    RegisterProperty('OnMagicBlockFound', 'TFoundBlockNotify', iptrw);
    RegisterProperty('OnBlockProcessStep', 'TBlockProcessStepNotify', iptrw);
    RegisterProperty('OnEndProcessBlockFile', 'TEndProcessBlockFile', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlockRecord(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TBlockRecord') do
  with CL.AddClassN(CL.FindClass('TObject'),'TBlockRecord') do
  begin
    RegisterProperty('nblock', 'uint64', iptrw);
    RegisterProperty('blocktype', 'TCrypto', iptrw);
    RegisterProperty('network', 'TNetbc', iptrw);
    RegisterProperty('headerLenght', 'UInt32', iptrw);
    RegisterProperty('hash', 'string', iptrw);
    RegisterProperty('header', 'TBlockHeader', iptrw);
    RegisterProperty('transactions', 'TBlockTransactions', iptrw);
    RegisterProperty('ninputs', 'uint64', iptrw);
    RegisterProperty('noutputs', 'uint64', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlockTransactions(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TBlockTransactions') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TBlockTransactions') do
  begin
    RegisterMethod('Function NewTransaction : TTransaction');
    RegisterProperty('items', 'TTransaction integer', iptr);
    SetDefaultPropery('items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TTransaction(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTransaction') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTransaction') do
  begin
    RegisterProperty('version', 'UInt32', iptrw);
    RegisterProperty('inputs', 'TInputsbc', iptrw);
    RegisterProperty('outputs', 'TOutputsbc', iptrw);
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOutputsbc(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TOutputs') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TOutputsbc') do
  begin
    RegisterMethod('Function NewOutput : TOutputbc');
    RegisterProperty('items', 'TOutputbc integer', iptr);
    SetDefaultPropery('items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInputsbc(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObjectList', 'TInputsbc') do
  with CL.AddClassN(CL.FindClass('TObjectList'),'TInputsbc') do
  begin
    RegisterMethod('Function NewInput : TInputbc');
    RegisterProperty('items', 'TInputbc integer', iptr);
    SetDefaultPropery('items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOutputbc(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TOutputbc') do
  with CL.AddClassN(CL.FindClass('TObject'),'TOutputbc') do
  begin
    RegisterProperty('nValue', 'uint64', iptrw);
    RegisterProperty('OutputScriptLength', 'uint64', iptrw);
    RegisterProperty('OutputScript', 'PByte', iptrw);
    RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TInputbc(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TInput') do
  with CL.AddClassN(CL.FindClass('TObject'),'TInputbc') do
  begin
    RegisterProperty('aTXID', 'T32se', iptrw);
    RegisterProperty('aVOUT', 'UInt32', iptrw);
    RegisterProperty('CoinBaseLength', 'uint64', iptrw);
    RegisterProperty('CoinBase', 'PByte', iptrw);
    RegisterMethod('Procedure Free;');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBlockFile(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TBlockFile') do
  with CL.AddClassN(CL.FindClass('TObject'),'TBlockFile') do
  begin
    RegisterProperty('aFileName', 'string', iptrw);
    RegisterProperty('afs', 'TBufferedFileStream', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_BlocksUnit(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TCrypto', '( tcBitcoin,tcPascalCoin )');
  CL.AddTypeS('TNetbc', '( tnMainNet, tnTestNet )');
  CL.AddTypeS('PByte', 'Byte');
  SIRegister_TBlockFile(CL);
  CL.AddTypeS('TBlockHeader', 'record versionNumber : UInt32; aPreviousBlockHas'
   +'h : T32se; aMerkleRoot : T32se; time : UInt32; DifficultyTarget : UInt32; nonce : UInt32; end');
  SIRegister_TInputbc(CL);
  SIRegister_TOutputbc(CL);
  SIRegister_TInputsbc(CL);
  SIRegister_TOutputsbc(CL);
  SIRegister_TTransaction(CL);
  SIRegister_TBlockTransactions(CL);
  SIRegister_TBlockRecord(CL);
  CL.AddTypeS('TStartFileBlockFoundNotify', 'Procedure ( const aBlockFiles : tstringlist)');
  CL.AddTypeS('TFoundFileBlockNotify', 'Procedure ( const aBlockFile : TBlockFi'
   +'le; const actualFileBlockNumber, totalBlockFiles : integer; var next : boolean)');
  CL.AddTypeS('TEndFilesBlockFoundNotify', 'Procedure ( const aBlockFiles : tstringlist)');
  CL.AddTypeS('TFoundBlockNotify', 'Procedure ( const aBlock : TBlockRecord; var findnext : boolean)');
  CL.AddTypeS('TBlockProcessStepNotify', 'Procedure ( const aPos, asize : int64)');
  CL.AddTypeS('TEndProcessBlockFile', 'Procedure ( const aBlockFile : TBlockFile)');
  SIRegister_TBlocks(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TBlocksOnEndProcessBlockFile_W(Self: TBlocks; const T: TEndProcessBlockFile);
begin Self.OnEndProcessBlockFile := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnEndProcessBlockFile_R(Self: TBlocks; var T: TEndProcessBlockFile);
begin T := Self.OnEndProcessBlockFile; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnBlockProcessStep_W(Self: TBlocks; const T: TBlockProcessStepNotify);
begin Self.OnBlockProcessStep := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnBlockProcessStep_R(Self: TBlocks; var T: TBlockProcessStepNotify);
begin T := Self.OnBlockProcessStep; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnMagicBlockFound_W(Self: TBlocks; const T: TFoundBlockNotify);
begin Self.OnMagicBlockFound := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnMagicBlockFound_R(Self: TBlocks; var T: TFoundBlockNotify);
begin T := Self.OnMagicBlockFound; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnAfterFileBlockProcessed_W(Self: TBlocks; const T: TFoundFileBlockNotify);
begin Self.OnAfterFileBlockProcessed := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnAfterFileBlockProcessed_R(Self: TBlocks; var T: TFoundFileBlockNotify);
begin T := Self.OnAfterFileBlockProcessed; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnBeforeFileBlockProcess_W(Self: TBlocks; const T: TFoundFileBlockNotify);
begin Self.OnBeforeFileBlockProcess := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnBeforeFileBlockProcess_R(Self: TBlocks; var T: TFoundFileBlockNotify);
begin T := Self.OnBeforeFileBlockProcess; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnStartProcessFiles_W(Self: TBlocks; const T: TStartFileBlockFoundNotify);
begin Self.OnStartProcessFiles := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnStartProcessFiles_R(Self: TBlocks; var T: TStartFileBlockFoundNotify);
begin T := Self.OnStartProcessFiles; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnEndParsing_W(Self: TBlocks; const T: TNotifyEvent);
begin Self.OnEndParsing := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnEndParsing_R(Self: TBlocks; var T: TNotifyEvent);
begin T := Self.OnEndParsing; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnStartParsing_W(Self: TBlocks; const T: TNotifyEvent);
begin Self.OnStartParsing := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksOnStartParsing_R(Self: TBlocks; var T: TNotifyEvent);
begin T := Self.OnStartParsing; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksBlocksDir_W(Self: TBlocks; const T: string);
Begin Self.BlocksDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlocksBlocksDir_R(Self: TBlocks; var T: string);
Begin T := Self.BlocksDir; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordnoutputs_W(Self: TBlockRecord; const T: uint64);
Begin Self.noutputs := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordnoutputs_R(Self: TBlockRecord; var T: uint64);
Begin T := Self.noutputs; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordninputs_W(Self: TBlockRecord; const T: uint64);
Begin Self.ninputs := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordninputs_R(Self: TBlockRecord; var T: uint64);
Begin T := Self.ninputs; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordtransactions_W(Self: TBlockRecord; const T: TBlockTransactions);
Begin Self.transactions := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordtransactions_R(Self: TBlockRecord; var T: TBlockTransactions);
Begin T := Self.transactions; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordheader_W(Self: TBlockRecord; const T: TBlockHeader);
Begin Self.header := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordheader_R(Self: TBlockRecord; var T: TBlockHeader);
Begin T := Self.header; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordhash_W(Self: TBlockRecord; const T: string);
Begin Self.hash := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordhash_R(Self: TBlockRecord; var T: string);
Begin T := Self.hash; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordheaderLenght_W(Self: TBlockRecord; const T: UInt32);
Begin Self.headerLenght := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordheaderLenght_R(Self: TBlockRecord; var T: UInt32);
Begin T := Self.headerLenght; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordnetwork_W(Self: TBlockRecord; const T: TNetbc);
Begin Self.network := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordnetwork_R(Self: TBlockRecord; var T: TNetbc);
Begin T := Self.network; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordblocktype_W(Self: TBlockRecord; const T: TCrypto);
Begin Self.blocktype := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordblocktype_R(Self: TBlockRecord; var T: TCrypto);
Begin T := Self.blocktype; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordnblock_W(Self: TBlockRecord; const T: uint64);
Begin Self.nblock := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockRecordnblock_R(Self: TBlockRecord; var T: uint64);
Begin T := Self.nblock; end;

(*----------------------------------------------------------------------------*)
procedure TBlockTransactionsitems_R(Self: TBlockTransactions; var T: TTransaction; const t1: integer);
begin T := Self.items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TTransactionoutputs_W(Self: TTransaction; const T: TOutputsbc);
Begin Self.outputs := T; end;

(*----------------------------------------------------------------------------*)
procedure TTransactionoutputs_R(Self: TTransaction; var T: TOutputsbc);
Begin T := Self.outputs; end;

(*----------------------------------------------------------------------------*)
procedure TTransactioninputs_W(Self: TTransaction; const T: TInputsbc);
Begin Self.inputs := T; end;

(*----------------------------------------------------------------------------*)
procedure TTransactioninputs_R(Self: TTransaction; var T: TInputsbc);
Begin T := Self.inputs; end;

(*----------------------------------------------------------------------------*)
procedure TTransactionversion_W(Self: TTransaction; const T: UInt32);
Begin Self.version := T; end;

(*----------------------------------------------------------------------------*)
procedure TTransactionversion_R(Self: TTransaction; var T: UInt32);
Begin T := Self.version; end;

(*----------------------------------------------------------------------------*)
procedure TOutputsitems_R(Self: TOutputsbc; var T: TOutputbc; const t1: integer);
begin T := Self.items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TInputsitems_R(Self: TInputsbc; var T: TInputbc; const t1: integer);
begin T := Self.items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TOutputOutputScript_W(Self: TOutputbc; const T: PByte);
Begin Self.OutputScript := T; end;

(*----------------------------------------------------------------------------*)
procedure TOutputOutputScript_R(Self: TOutputbc; var T: PByte);
Begin T := Self.OutputScript; end;

(*----------------------------------------------------------------------------*)
procedure TOutputOutputScriptLength_W(Self: TOutputbc; const T: uint64);
Begin Self.OutputScriptLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TOutputOutputScriptLength_R(Self: TOutputbc; var T: uint64);
Begin T := Self.OutputScriptLength; end;

(*----------------------------------------------------------------------------*)
procedure TOutputnValue_W(Self: TOutputbc; const T: uint64);
Begin Self.nValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TOutputnValue_R(Self: TOutputbc; var T: uint64);
Begin T := Self.nValue; end;

(*----------------------------------------------------------------------------*)
procedure TInputCoinBase_W(Self: TInputbc; const T: PByte);
Begin Self.CoinBase := T; end;

(*----------------------------------------------------------------------------*)
procedure TInputCoinBase_R(Self: TInputbc; var T: PByte);
Begin T := Self.CoinBase; end;

(*----------------------------------------------------------------------------*)
procedure TInputCoinBaseLength_W(Self: TInputbc; const T: uint64);
Begin Self.CoinBaseLength := T; end;

(*----------------------------------------------------------------------------*)
procedure TInputCoinBaseLength_R(Self: TInputbc; var T: uint64);
Begin T := Self.CoinBaseLength; end;

(*----------------------------------------------------------------------------*)
procedure TInputaVOUT_W(Self: TInputbc; const T: UInt32);
Begin Self.aVOUT := T; end;

(*----------------------------------------------------------------------------*)
procedure TInputaVOUT_R(Self: TInputbc; var T: UInt32);
Begin T := Self.aVOUT; end;

(*----------------------------------------------------------------------------*)
procedure TInputaTXID_W(Self: TInputbc; const T: T32);
Begin Self.aTXID := T; end;

(*----------------------------------------------------------------------------*)
procedure TInputaTXID_R(Self: TInputbc; var T: T32);
Begin T := Self.aTXID; end;

(*----------------------------------------------------------------------------*)
procedure TBlockFileafs_W(Self: TBlockFile; const T: TFileStream);
Begin Self.afs := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockFileafs_R(Self: TBlockFile; var T: TFileStream);
Begin T := Self.afs; end;

(*----------------------------------------------------------------------------*)
procedure TBlockFileaFileName_W(Self: TBlockFile; const T: string);
Begin Self.aFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TBlockFileaFileName_R(Self: TBlockFile; var T: string);
Begin T := Self.aFileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlocks(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlocks) do
  begin
    RegisterPropertyHelper(@TBlocksBlocksDir_R,@TBlocksBlocksDir_W,'BlocksDir');
    RegisterConstructor(@TBlocks.Create, 'Create');
    RegisterMethod(@TBlocks.ParseBlockFiles, 'ParseBlockFiles');
    RegisterMethod(@TBlocks.ProcessBlock, 'ProcessBlock');
    RegisterPropertyHelper(@TBlocksOnStartParsing_R,@TBlocksOnStartParsing_W,'OnStartParsing');
    RegisterPropertyHelper(@TBlocksOnEndParsing_R,@TBlocksOnEndParsing_W,'OnEndParsing');
    RegisterPropertyHelper(@TBlocksOnStartProcessFiles_R,@TBlocksOnStartProcessFiles_W,'OnStartProcessFiles');
    RegisterPropertyHelper(@TBlocksOnBeforeFileBlockProcess_R,@TBlocksOnBeforeFileBlockProcess_W,'OnBeforeFileBlockProcess');
    RegisterPropertyHelper(@TBlocksOnAfterFileBlockProcessed_R,@TBlocksOnAfterFileBlockProcessed_W,'OnAfterFileBlockProcessed');
    RegisterPropertyHelper(@TBlocksOnMagicBlockFound_R,@TBlocksOnMagicBlockFound_W,'OnMagicBlockFound');
    RegisterPropertyHelper(@TBlocksOnBlockProcessStep_R,@TBlocksOnBlockProcessStep_W,'OnBlockProcessStep');
    RegisterPropertyHelper(@TBlocksOnEndProcessBlockFile_R,@TBlocksOnEndProcessBlockFile_W,'OnEndProcessBlockFile');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlockRecord(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlockRecord) do
  begin
    RegisterPropertyHelper(@TBlockRecordnblock_R,@TBlockRecordnblock_W,'nblock');
    RegisterPropertyHelper(@TBlockRecordblocktype_R,@TBlockRecordblocktype_W,'blocktype');
    RegisterPropertyHelper(@TBlockRecordnetwork_R,@TBlockRecordnetwork_W,'network');
    RegisterPropertyHelper(@TBlockRecordheaderLenght_R,@TBlockRecordheaderLenght_W,'headerLenght');
    RegisterPropertyHelper(@TBlockRecordhash_R,@TBlockRecordhash_W,'hash');
    RegisterPropertyHelper(@TBlockRecordheader_R,@TBlockRecordheader_W,'header');
    RegisterPropertyHelper(@TBlockRecordtransactions_R,@TBlockRecordtransactions_W,'transactions');
    RegisterPropertyHelper(@TBlockRecordninputs_R,@TBlockRecordninputs_W,'ninputs');
    RegisterPropertyHelper(@TBlockRecordnoutputs_R,@TBlockRecordnoutputs_W,'noutputs');
    RegisterConstructor(@TBlockRecord.Create, 'Create');
    RegisterMethod(@TBlockRecord.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlockTransactions(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlockTransactions) do
  begin
    RegisterMethod(@TBlockTransactions.NewTransaction, 'NewTransaction');
    RegisterPropertyHelper(@TBlockTransactionsitems_R,nil,'items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTransaction(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTransaction) do
  begin
    RegisterPropertyHelper(@TTransactionversion_R,@TTransactionversion_W,'version');
    RegisterPropertyHelper(@TTransactioninputs_R,@TTransactioninputs_W,'inputs');
    RegisterPropertyHelper(@TTransactionoutputs_R,@TTransactionoutputs_W,'outputs');
    RegisterConstructor(@TTransaction.Create, 'Create');
    RegisterMethod(@TTransaction.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOutputsbc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOutputsbc) do
  begin
    RegisterMethod(@TOutputsbc.NewOutput, 'NewOutput');
    RegisterPropertyHelper(@TOutputsitems_R,nil,'items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInputsbc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInputsbc) do
  begin
    RegisterMethod(@TInputsbc.NewInput, 'NewInput');
    RegisterPropertyHelper(@TInputsitems_R,nil,'items');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOutputbc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOutputbc) do
  begin
    RegisterPropertyHelper(@TOutputnValue_R,@TOutputnValue_W,'nValue');
    RegisterPropertyHelper(@TOutputOutputScriptLength_R,@TOutputOutputScriptLength_W,'OutputScriptLength');
    RegisterPropertyHelper(@TOutputOutputScript_R,@TOutputOutputScript_W,'OutputScript');
    RegisterMethod(@TOutputbc.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TInputbc(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TInputbc) do
  begin
    RegisterPropertyHelper(@TInputaTXID_R,@TInputaTXID_W,'aTXID');
    RegisterPropertyHelper(@TInputaVOUT_R,@TInputaVOUT_W,'aVOUT');
    RegisterPropertyHelper(@TInputCoinBaseLength_R,@TInputCoinBaseLength_W,'CoinBaseLength');
    RegisterPropertyHelper(@TInputCoinBase_R,@TInputCoinBase_W,'CoinBase');
    RegisterMethod(@TInputbc.Destroy, 'Free');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBlockFile(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBlockFile) do
  begin
    RegisterPropertyHelper(@TBlockFileaFileName_R,@TBlockFileaFileName_W,'aFileName');
    RegisterPropertyHelper(@TBlockFileafs_R,@TBlockFileafs_W,'afs');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_BlocksUnit(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBlockFile(CL);
  RIRegister_TInputbc(CL);
  RIRegister_TOutputbc(CL);
  RIRegister_TInputsbc(CL);
  RIRegister_TOutputsbc(CL);
  RIRegister_TTransaction(CL);
  RIRegister_TBlockTransactions(CL);
  RIRegister_TBlockRecord(CL);
  RIRegister_TBlocks(CL);
end;

 
 
{ TPSImport_BlocksUnit }
(*----------------------------------------------------------------------------*)
procedure TPSImport_BlocksUnit.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_BlocksUnit(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_BlocksUnit.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_BlocksUnit(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
