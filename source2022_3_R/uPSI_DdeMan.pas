unit uPSI_DdeMan;
{
  dde exchanger
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
  TPSImport_DdeMan = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TDdeMgr(CL: TPSPascalCompiler);
procedure SIRegister_TDdeServerItem(CL: TPSPascalCompiler);
procedure SIRegister_TDdeServerConv(CL: TPSPascalCompiler);
procedure SIRegister_TDdeClientItem(CL: TPSPascalCompiler);
procedure SIRegister_TDdeClientConv(CL: TPSPascalCompiler);
procedure SIRegister_DdeMan(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_DdeMan_Routines(S: TPSExec);
procedure RIRegister_TDdeMgr(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDdeServerItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDdeServerConv(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDdeClientItem(CL: TPSRuntimeClassImporter);
procedure RIRegister_TDdeClientConv(CL: TPSRuntimeClassImporter);
procedure RIRegister_DdeMan(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Forms
  ,Controls
  ,DDEml
  ,DdeMan
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_DdeMan]);
end;

procedure mIRCDDE(Service, Topic, Cmd: string);
var
  DDE: TDDEClientConv;
begin
  try
    DDE := TDDEClientConv.Create(nil);
    DDE.SetLink(Service, Topic);
    DDE.OpenLink;
    DDE.PokeData(Topic, PChar(Cmd));
  finally
    DDE.Free;
  end;
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TDdeMgr(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDdeMgr') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDdeMgr') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function GetExeName : string');
    RegisterProperty('DdeInstId', 'LongInt', iptrw);
    RegisterProperty('AppName', 'string', iptrw);
    RegisterProperty('LinkClipFmt', 'Word', iptr);
    //INVALID_FILE_ATTRIBUTES
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDdeServerItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDdeServerItem') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDdeServerItem') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function PokeData( Data : HDdeData) : LongInt');
    RegisterMethod('Procedure CopyToClipboard');
    RegisterMethod('Procedure Change');
    RegisterProperty('Fmt', 'Integer', iptr);
    RegisterProperty('ServerConv', 'TDdeServerConv', iptrw);
    RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Lines', 'TStrings', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
    RegisterProperty('OnPokeData', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDdeServerConv(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDdeServerConv') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDdeServerConv') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function ExecuteMacro( Data : HDdeData) : LongInt');
    RegisterProperty('OnOpen', 'TNotifyEvent', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnExecuteMacro', 'TMacroEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDdeClientItem(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDdeClientItem') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDdeClientItem') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterProperty('Text', 'string', iptrw);
    RegisterProperty('Lines', 'TStrings', iptrw);
    RegisterProperty('DdeConv', 'TDdeClientConv', iptrw);
    RegisterProperty('DdeItem', 'string', iptrw);
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TDdeClientConv(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TDdeClientConv') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TDdeClientConv') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
      RegisterMethod('Procedure Free');
     RegisterMethod('Function PasteLink : Boolean');
    RegisterMethod('Function OpenLink : Boolean');
    RegisterMethod('Function SetLink( const Service, Topic : string) : Boolean');
    RegisterMethod('Procedure CloseLink');
    RegisterMethod('Function StartAdvise : Boolean');
    RegisterMethod('Function PokeDataLines( const Item : string; Data : TStrings) : Boolean');
    RegisterMethod('Function PokeData( const Item : string; Data : PChar) : Boolean');
    RegisterMethod('Function ExecuteMacroLines( Cmd : TStrings; waitFlg : Boolean) : Boolean');
    RegisterMethod('Function ExecuteMacro( Cmd : PChar; waitFlg : Boolean) : Boolean');
    RegisterMethod('Function RequestData( const Item : string) : PChar');
    RegisterProperty('DdeFmt', 'Integer', iptr);
    RegisterProperty('WaitStat', 'Boolean', iptr);
    RegisterProperty('Conv', 'HConv', iptr);
    RegisterProperty('DataMode', 'TDataMode', iptrw);
    RegisterProperty('ServiceApplication', 'string', iptrw);
    RegisterProperty('DdeService', 'string', iptrw);
    RegisterProperty('DdeTopic', 'string', iptrw);
    RegisterProperty('ConnectMode', 'TDataMode', iptrw);
    RegisterProperty('FormatChars', 'Boolean', iptrw);
    RegisterProperty('OnClose', 'TNotifyEvent', iptrw);
    RegisterProperty('OnOpen', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_DdeMan(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TDataMode', '( ddeAutomatic, ddeManual )');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDdeServerConv');
  CL.AddTypeS('TMacroEvent', 'Procedure ( Sender : TObject; Msg : TStrings)');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TDdeClientItem');
  SIRegister_TDdeClientConv(CL);
  SIRegister_TDdeClientItem(CL);
  SIRegister_TDdeServerConv(CL);
  SIRegister_TDdeServerItem(CL);
  SIRegister_TDdeMgr(CL);
 CL.AddDelphiFunction('Function GetPasteLinkInfo( var Service : string; var Topic : string; var Item : string) : Boolean');
 CL.AddDelphiFunction('procedure mIRCDDE(Service, Topic, Cmd: string);');


 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TDdeMgrLinkClipFmt_R(Self: TDdeMgr; var T: Word);
begin T := Self.LinkClipFmt; end;

(*----------------------------------------------------------------------------*)
procedure TDdeMgrAppName_W(Self: TDdeMgr; const T: string);
begin Self.AppName := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeMgrAppName_R(Self: TDdeMgr; var T: string);
begin T := Self.AppName; end;

(*----------------------------------------------------------------------------*)
procedure TDdeMgrDdeInstId_W(Self: TDdeMgr; const T: LongInt);
begin Self.DdeInstId := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeMgrDdeInstId_R(Self: TDdeMgr; var T: LongInt);
begin T := Self.DdeInstId; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemOnPokeData_W(Self: TDdeServerItem; const T: TNotifyEvent);
begin Self.OnPokeData := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemOnPokeData_R(Self: TDdeServerItem; var T: TNotifyEvent);
begin T := Self.OnPokeData; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemOnChange_W(Self: TDdeServerItem; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemOnChange_R(Self: TDdeServerItem; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemLines_W(Self: TDdeServerItem; const T: TStrings);
begin Self.Lines := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemLines_R(Self: TDdeServerItem; var T: TStrings);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemText_W(Self: TDdeServerItem; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemText_R(Self: TDdeServerItem; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemServerConv_W(Self: TDdeServerItem; const T: TDdeServerConv);
begin Self.ServerConv := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemServerConv_R(Self: TDdeServerItem; var T: TDdeServerConv);
begin T := Self.ServerConv; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerItemFmt_R(Self: TDdeServerItem; var T: Integer);
begin T := Self.Fmt; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerConvOnExecuteMacro_W(Self: TDdeServerConv; const T: TMacroEvent);
begin Self.OnExecuteMacro := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerConvOnExecuteMacro_R(Self: TDdeServerConv; var T: TMacroEvent);
begin T := Self.OnExecuteMacro; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerConvOnClose_W(Self: TDdeServerConv; const T: TNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerConvOnClose_R(Self: TDdeServerConv; var T: TNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerConvOnOpen_W(Self: TDdeServerConv; const T: TNotifyEvent);
begin Self.OnOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeServerConvOnOpen_R(Self: TDdeServerConv; var T: TNotifyEvent);
begin T := Self.OnOpen; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemOnChange_W(Self: TDdeClientItem; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemOnChange_R(Self: TDdeClientItem; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemDdeItem_W(Self: TDdeClientItem; const T: string);
begin Self.DdeItem := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemDdeItem_R(Self: TDdeClientItem; var T: string);
begin T := Self.DdeItem; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemDdeConv_W(Self: TDdeClientItem; const T: TDdeClientConv);
begin Self.DdeConv := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemDdeConv_R(Self: TDdeClientItem; var T: TDdeClientConv);
begin T := Self.DdeConv; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemLines_W(Self: TDdeClientItem; const T: TStrings);
begin Self.Lines := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemLines_R(Self: TDdeClientItem; var T: TStrings);
begin T := Self.Lines; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemText_W(Self: TDdeClientItem; const T: string);
begin Self.Text := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientItemText_R(Self: TDdeClientItem; var T: string);
begin T := Self.Text; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvOnOpen_W(Self: TDdeClientConv; const T: TNotifyEvent);
begin Self.OnOpen := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvOnOpen_R(Self: TDdeClientConv; var T: TNotifyEvent);
begin T := Self.OnOpen; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvOnClose_W(Self: TDdeClientConv; const T: TNotifyEvent);
begin Self.OnClose := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvOnClose_R(Self: TDdeClientConv; var T: TNotifyEvent);
begin T := Self.OnClose; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvFormatChars_W(Self: TDdeClientConv; const T: Boolean);
begin Self.FormatChars := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvFormatChars_R(Self: TDdeClientConv; var T: Boolean);
begin T := Self.FormatChars; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvConnectMode_W(Self: TDdeClientConv; const T: TDataMode);
begin Self.ConnectMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvConnectMode_R(Self: TDdeClientConv; var T: TDataMode);
begin T := Self.ConnectMode; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvDdeTopic_W(Self: TDdeClientConv; const T: string);
begin Self.DdeTopic := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvDdeTopic_R(Self: TDdeClientConv; var T: string);
begin T := Self.DdeTopic; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvDdeService_W(Self: TDdeClientConv; const T: string);
begin Self.DdeService := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvDdeService_R(Self: TDdeClientConv; var T: string);
begin T := Self.DdeService; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvServiceApplication_W(Self: TDdeClientConv; const T: string);
begin Self.ServiceApplication := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvServiceApplication_R(Self: TDdeClientConv; var T: string);
begin T := Self.ServiceApplication; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvDataMode_W(Self: TDdeClientConv; const T: TDataMode);
begin Self.DataMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvDataMode_R(Self: TDdeClientConv; var T: TDataMode);
begin T := Self.DataMode; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvConv_R(Self: TDdeClientConv; var T: HConv);
begin T := Self.Conv; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvWaitStat_R(Self: TDdeClientConv; var T: Boolean);
begin T := Self.WaitStat; end;

(*----------------------------------------------------------------------------*)
procedure TDdeClientConvDdeFmt_R(Self: TDdeClientConv; var T: Integer);
begin T := Self.DdeFmt; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DdeMan_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@GetPasteLinkInfo, 'GetPasteLinkInfo', cdRegister);
 S.RegisterDelphiFunction(@mIRCDDE, 'mIRCDDE', cdRegister);


end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDdeMgr(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDdeMgr) do begin
    RegisterConstructor(@TDdeMgr.Create, 'Create');
       RegisterMethod(@TDdeMgr.Destroy, 'Free');
    RegisterMethod(@TDdeMgr.GetExeName, 'GetExeName');
    RegisterPropertyHelper(@TDdeMgrDdeInstId_R,@TDdeMgrDdeInstId_W,'DdeInstId');
    RegisterPropertyHelper(@TDdeMgrAppName_R,@TDdeMgrAppName_W,'AppName');
    RegisterPropertyHelper(@TDdeMgrLinkClipFmt_R,nil,'LinkClipFmt');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDdeServerItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDdeServerItem) do begin
    RegisterConstructor(@TDdeServerItem.Create, 'Create');
       RegisterMethod(@TDdeServerItem.Destroy, 'Free');
    RegisterMethod(@TDdeServerItem.PokeData, 'PokeData');
    RegisterMethod(@TDdeServerItem.CopyToClipboard, 'CopyToClipboard');
    RegisterVirtualMethod(@TDdeServerItem.Change, 'Change');
    RegisterPropertyHelper(@TDdeServerItemFmt_R,nil,'Fmt');
    RegisterPropertyHelper(@TDdeServerItemServerConv_R,@TDdeServerItemServerConv_W,'ServerConv');
    RegisterPropertyHelper(@TDdeServerItemText_R,@TDdeServerItemText_W,'Text');
    RegisterPropertyHelper(@TDdeServerItemLines_R,@TDdeServerItemLines_W,'Lines');
    RegisterPropertyHelper(@TDdeServerItemOnChange_R,@TDdeServerItemOnChange_W,'OnChange');
    RegisterPropertyHelper(@TDdeServerItemOnPokeData_R,@TDdeServerItemOnPokeData_W,'OnPokeData');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDdeServerConv(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDdeServerConv) do begin
    RegisterConstructor(@TDdeServerConv.Create, 'Create');
   RegisterMethod(@TDdeServerConv.Destroy, 'Free');
    RegisterMethod(@TDdeServerConv.ExecuteMacro, 'ExecuteMacro');
    RegisterPropertyHelper(@TDdeServerConvOnOpen_R,@TDdeServerConvOnOpen_W,'OnOpen');
    RegisterPropertyHelper(@TDdeServerConvOnClose_R,@TDdeServerConvOnClose_W,'OnClose');
    RegisterPropertyHelper(@TDdeServerConvOnExecuteMacro_R,@TDdeServerConvOnExecuteMacro_W,'OnExecuteMacro');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDdeClientItem(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDdeClientItem) do begin
    RegisterConstructor(@TDdeClientItem.Create, 'Create');
   RegisterMethod(@TDdeClientItem.Destroy, 'Free');
    RegisterPropertyHelper(@TDdeClientItemText_R,@TDdeClientItemText_W,'Text');
    RegisterPropertyHelper(@TDdeClientItemLines_R,@TDdeClientItemLines_W,'Lines');
    RegisterPropertyHelper(@TDdeClientItemDdeConv_R,@TDdeClientItemDdeConv_W,'DdeConv');
    RegisterPropertyHelper(@TDdeClientItemDdeItem_R,@TDdeClientItemDdeItem_W,'DdeItem');
    RegisterPropertyHelper(@TDdeClientItemOnChange_R,@TDdeClientItemOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TDdeClientConv(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDdeClientConv) do begin
    RegisterConstructor(@TDdeClientConv.Create, 'Create');
   RegisterMethod(@TDdeClientConv.Destroy, 'Free');
    RegisterMethod(@TDdeClientConv.PasteLink, 'PasteLink');
    RegisterMethod(@TDdeClientConv.OpenLink, 'OpenLink');
    RegisterMethod(@TDdeClientConv.SetLink, 'SetLink');
    RegisterMethod(@TDdeClientConv.CloseLink, 'CloseLink');
    RegisterMethod(@TDdeClientConv.StartAdvise, 'StartAdvise');
    RegisterMethod(@TDdeClientConv.PokeDataLines, 'PokeDataLines');
    RegisterMethod(@TDdeClientConv.PokeData, 'PokeData');
    RegisterMethod(@TDdeClientConv.ExecuteMacroLines, 'ExecuteMacroLines');
    RegisterMethod(@TDdeClientConv.ExecuteMacro, 'ExecuteMacro');
    RegisterMethod(@TDdeClientConv.RequestData, 'RequestData');
    RegisterPropertyHelper(@TDdeClientConvDdeFmt_R,nil,'DdeFmt');
    RegisterPropertyHelper(@TDdeClientConvWaitStat_R,nil,'WaitStat');
    RegisterPropertyHelper(@TDdeClientConvConv_R,nil,'Conv');
    RegisterPropertyHelper(@TDdeClientConvDataMode_R,@TDdeClientConvDataMode_W,'DataMode');
    RegisterPropertyHelper(@TDdeClientConvServiceApplication_R,@TDdeClientConvServiceApplication_W,'ServiceApplication');
    RegisterPropertyHelper(@TDdeClientConvDdeService_R,@TDdeClientConvDdeService_W,'DdeService');
    RegisterPropertyHelper(@TDdeClientConvDdeTopic_R,@TDdeClientConvDdeTopic_W,'DdeTopic');
    RegisterPropertyHelper(@TDdeClientConvConnectMode_R,@TDdeClientConvConnectMode_W,'ConnectMode');
    RegisterPropertyHelper(@TDdeClientConvFormatChars_R,@TDdeClientConvFormatChars_W,'FormatChars');
    RegisterPropertyHelper(@TDdeClientConvOnClose_R,@TDdeClientConvOnClose_W,'OnClose');
    RegisterPropertyHelper(@TDdeClientConvOnOpen_R,@TDdeClientConvOnOpen_W,'OnOpen');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_DdeMan(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TDdeServerConv) do
  with CL.Add(TDdeClientItem) do
  RIRegister_TDdeClientConv(CL);
  RIRegister_TDdeClientItem(CL);
  RIRegister_TDdeServerConv(CL);
  RIRegister_TDdeServerItem(CL);
  RIRegister_TDdeMgr(CL);
end;



{ TPSImport_DdeMan }
(*----------------------------------------------------------------------------*)
procedure TPSImport_DdeMan.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_DdeMan(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_DdeMan.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_DdeMan(ri);
  RIRegister_DdeMan_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
