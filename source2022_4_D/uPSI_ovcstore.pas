unit uPSI_ovcstore;
{
  store the more with TElement
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
  TPSImport_ovcstore = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TO32XMLFileStore(CL: TPSPascalCompiler);
procedure SIRegister_TElement(CL: TPSPascalCompiler);
procedure SIRegister_TOvcIniFileStore(CL: TPSPascalCompiler);
procedure SIRegister_TOvcRegistryStore(CL: TPSPascalCompiler);
procedure SIRegister_TOvcVirtualStore(CL: TPSPascalCompiler);
procedure SIRegister_ovcstore(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TO32XMLFileStore(CL: TPSRuntimeClassImporter);
procedure RIRegister_TElement(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcIniFileStore(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcRegistryStore(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOvcVirtualStore(CL: TPSRuntimeClassImporter);
procedure RIRegister_ovcstore(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Registry
  ,Controls
  ,Forms
  ,IniFiles
  ,OvcFiler
  ,OvcStr
  ,StrUtils
  ,OvcData
  ,OvcConst
  ,ovcstore
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ovcstore]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TO32XMLFileStore(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcAbstractStore', 'TO32XMLFileStore') do
  with CL.AddClassN(CL.FindClass('TOvcAbstractStore'),'TO32XMLFileStore') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
   RegisterMethod('Procedure Free');
     RegisterMethod('Function ReadString( const Section, Item, DefaultValue : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Item, Value : string)');
    RegisterMethod('Procedure WriteBoolean( const Parent, Element : string; Value : Boolean)');
    RegisterMethod('Procedure WriteInteger( const Parent, Element : string; Value : Integer)');
    RegisterMethod('Procedure WriteStr( const Parent, Element : string; const Value : string)');
    RegisterMethod('Function ReadBoolean( const Parent, Element : string) : Boolean');
    RegisterMethod('Function ReadInteger( const Parent, Element : string) : Integer');
    RegisterMethod('Function ReadStr( const Parent, Element, DefaultValue : string) : string');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterProperty('XMLFileName', 'string', iptrw);
    RegisterProperty('UseExeDir', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TElement(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TElement') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TElement') do begin
    RegisterProperty('ElementName', 'String', iptrw);
    RegisterProperty('Index', 'Integer', iptrw);
    RegisterProperty('ParentIndex', 'Integer', iptrw);
    RegisterProperty('Indent', 'String', iptrw);
    RegisterProperty('Value', 'String', iptrw);
    RegisterProperty('EndingTag', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcIniFileStore(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcAbstractStore', 'TOvcIniFileStore') do
  with CL.AddClassN(CL.FindClass('TOvcAbstractStore'),'TOvcIniFileStore') do begin
    RegisterMethod('Function ReadString( const Section, Item, DefaultValue : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Item, Value : string)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterProperty('IniFileName', 'string', iptrw);
    RegisterProperty('UseExeDir', 'Boolean', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcRegistryStore(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcAbstractStore', 'TOvcRegistryStore') do
  with CL.AddClassN(CL.FindClass('TOvcAbstractStore'),'TOvcRegistryStore') do begin
    RegisterMethod('Function ReadString( const Section, Item, DefaultValue : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Item, Value : string)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterProperty('KeyName', 'string', iptrw);
    RegisterProperty('RegistryRoot', 'TOvcRegistryRoot', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOvcVirtualStore(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOvcAbstractStore', 'TOvcVirtualStore') do
  with CL.AddClassN(CL.FindClass('TOvcAbstractStore'),'TOvcVirtualStore') do begin
    RegisterMethod('Function ReadString( const Section, Item, DefaultValue : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Item, Value : string)');
    RegisterProperty('OnCloseStore', 'TNotifyEvent', iptrw);
    RegisterProperty('OnOpenStore', 'TNotifyEvent', iptrw);
    RegisterProperty('OnReadString', 'TOvcReadStrEvent', iptrw);
    RegisterProperty('OnWriteString', 'TOvcWriteStrEvent', iptrw);
    RegisterProperty('OnEraseSection', 'TOvcEraseSectEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ovcstore(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TOvcReadStrEvent', 'Procedure ( const Section, Item : string; var Value : string)');
  CL.AddTypeS('TOvcWriteStrEvent', 'Procedure ( const Section, Item, Value : string)');
  CL.AddTypeS('TOvcEraseSectEvent', 'Procedure ( const Section : string)');
  SIRegister_TOvcVirtualStore(CL);
  CL.AddTypeS('TOvcRegistryRoot', '( rrCurrentUser, rrLocalMachine )');
  SIRegister_TOvcRegistryStore(CL);
  SIRegister_TOvcIniFileStore(CL);
  SIRegister_TElement(CL);
  SIRegister_TO32XMLFileStore(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TO32XMLFileStoreUseExeDir_W(Self: TO32XMLFileStore; const T: Boolean);
begin Self.UseExeDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32XMLFileStoreUseExeDir_R(Self: TO32XMLFileStore; var T: Boolean);
begin T := Self.UseExeDir; end;

(*----------------------------------------------------------------------------*)
procedure TO32XMLFileStoreXMLFileName_W(Self: TO32XMLFileStore; const T: string);
begin Self.XMLFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TO32XMLFileStoreXMLFileName_R(Self: TO32XMLFileStore; var T: string);
begin T := Self.XMLFileName; end;

(*----------------------------------------------------------------------------*)
procedure TElementEndingTag_W(Self: TElement; const T: Boolean);
Begin Self.EndingTag := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementEndingTag_R(Self: TElement; var T: Boolean);
Begin T := Self.EndingTag; end;

(*----------------------------------------------------------------------------*)
procedure TElementValue_W(Self: TElement; const T: String);
Begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementValue_R(Self: TElement; var T: String);
Begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TElementIndent_W(Self: TElement; const T: String);
Begin Self.Indent := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementIndent_R(Self: TElement; var T: String);
Begin T := Self.Indent; end;

(*----------------------------------------------------------------------------*)
procedure TElementParentIndex_W(Self: TElement; const T: Integer);
Begin Self.ParentIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementParentIndex_R(Self: TElement; var T: Integer);
Begin T := Self.ParentIndex; end;

(*----------------------------------------------------------------------------*)
procedure TElementIndex_W(Self: TElement; const T: Integer);
Begin Self.Index := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementIndex_R(Self: TElement; var T: Integer);
Begin T := Self.Index; end;

(*----------------------------------------------------------------------------*)
procedure TElementElementName_W(Self: TElement; const T: String);
Begin Self.ElementName := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementElementName_R(Self: TElement; var T: String);
Begin T := Self.ElementName; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIniFileStoreUseExeDir_W(Self: TOvcIniFileStore; const T: Boolean);
begin Self.UseExeDir := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIniFileStoreUseExeDir_R(Self: TOvcIniFileStore; var T: Boolean);
begin T := Self.UseExeDir; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIniFileStoreIniFileName_W(Self: TOvcIniFileStore; const T: string);
begin Self.IniFileName := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcIniFileStoreIniFileName_R(Self: TOvcIniFileStore; var T: string);
begin T := Self.IniFileName; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRegistryStoreRegistryRoot_W(Self: TOvcRegistryStore; const T: TOvcRegistryRoot);
begin Self.RegistryRoot := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRegistryStoreRegistryRoot_R(Self: TOvcRegistryStore; var T: TOvcRegistryRoot);
begin T := Self.RegistryRoot; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRegistryStoreKeyName_W(Self: TOvcRegistryStore; const T: string);
begin Self.KeyName := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcRegistryStoreKeyName_R(Self: TOvcRegistryStore; var T: string);
begin T := Self.KeyName; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnEraseSection_W(Self: TOvcVirtualStore; const T: TOvcEraseSectEvent);
begin Self.OnEraseSection := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnEraseSection_R(Self: TOvcVirtualStore; var T: TOvcEraseSectEvent);
begin T := Self.OnEraseSection; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnWriteString_W(Self: TOvcVirtualStore; const T: TOvcWriteStrEvent);
begin Self.OnWriteString := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnWriteString_R(Self: TOvcVirtualStore; var T: TOvcWriteStrEvent);
begin T := Self.OnWriteString; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnReadString_W(Self: TOvcVirtualStore; const T: TOvcReadStrEvent);
begin Self.OnReadString := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnReadString_R(Self: TOvcVirtualStore; var T: TOvcReadStrEvent);
begin T := Self.OnReadString; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnOpenStore_W(Self: TOvcVirtualStore; const T: TNotifyEvent);
begin Self.OnOpenStore := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnOpenStore_R(Self: TOvcVirtualStore; var T: TNotifyEvent);
begin T := Self.OnOpenStore; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnCloseStore_W(Self: TOvcVirtualStore; const T: TNotifyEvent);
begin Self.OnCloseStore := T; end;

(*----------------------------------------------------------------------------*)
procedure TOvcVirtualStoreOnCloseStore_R(Self: TOvcVirtualStore; var T: TNotifyEvent);
begin T := Self.OnCloseStore; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TO32XMLFileStore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TO32XMLFileStore) do begin
    RegisterConstructor(@TO32XMLFileStore.Create, 'Create');
    RegisterMethod(@TO32XMLFileStore.Destroy, 'Free');
    RegisterMethod(@TO32XMLFileStore.ReadString, 'ReadString');
    RegisterMethod(@TO32XMLFileStore.WriteString, 'WriteString');
    RegisterMethod(@TO32XMLFileStore.WriteBoolean, 'WriteBoolean');
    RegisterMethod(@TO32XMLFileStore.WriteInteger, 'WriteInteger');
    RegisterMethod(@TO32XMLFileStore.WriteStr, 'WriteStr');
    RegisterMethod(@TO32XMLFileStore.ReadBoolean, 'ReadBoolean');
    RegisterMethod(@TO32XMLFileStore.ReadInteger, 'ReadInteger');
    RegisterMethod(@TO32XMLFileStore.ReadStr, 'ReadStr');
    RegisterMethod(@TO32XMLFileStore.EraseSection, 'EraseSection');
    RegisterPropertyHelper(@TO32XMLFileStoreXMLFileName_R,@TO32XMLFileStoreXMLFileName_W,'XMLFileName');
    RegisterPropertyHelper(@TO32XMLFileStoreUseExeDir_R,@TO32XMLFileStoreUseExeDir_W,'UseExeDir');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TElement(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TElement) do
  begin
    RegisterPropertyHelper(@TElementElementName_R,@TElementElementName_W,'ElementName');
    RegisterPropertyHelper(@TElementIndex_R,@TElementIndex_W,'Index');
    RegisterPropertyHelper(@TElementParentIndex_R,@TElementParentIndex_W,'ParentIndex');
    RegisterPropertyHelper(@TElementIndent_R,@TElementIndent_W,'Indent');
    RegisterPropertyHelper(@TElementValue_R,@TElementValue_W,'Value');
    RegisterPropertyHelper(@TElementEndingTag_R,@TElementEndingTag_W,'EndingTag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcIniFileStore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcIniFileStore) do
  begin
    RegisterMethod(@TOvcIniFileStore.ReadString, 'ReadString');
    RegisterMethod(@TOvcIniFileStore.WriteString, 'WriteString');
    RegisterMethod(@TOvcIniFileStore.EraseSection, 'EraseSection');
    RegisterPropertyHelper(@TOvcIniFileStoreIniFileName_R,@TOvcIniFileStoreIniFileName_W,'IniFileName');
    RegisterPropertyHelper(@TOvcIniFileStoreUseExeDir_R,@TOvcIniFileStoreUseExeDir_W,'UseExeDir');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcRegistryStore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcRegistryStore) do
  begin
    RegisterMethod(@TOvcRegistryStore.ReadString, 'ReadString');
    RegisterMethod(@TOvcRegistryStore.WriteString, 'WriteString');
    RegisterMethod(@TOvcRegistryStore.EraseSection, 'EraseSection');
    RegisterPropertyHelper(@TOvcRegistryStoreKeyName_R,@TOvcRegistryStoreKeyName_W,'KeyName');
    RegisterPropertyHelper(@TOvcRegistryStoreRegistryRoot_R,@TOvcRegistryStoreRegistryRoot_W,'RegistryRoot');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOvcVirtualStore(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOvcVirtualStore) do
  begin
    RegisterMethod(@TOvcVirtualStore.ReadString, 'ReadString');
    RegisterMethod(@TOvcVirtualStore.WriteString, 'WriteString');
    RegisterPropertyHelper(@TOvcVirtualStoreOnCloseStore_R,@TOvcVirtualStoreOnCloseStore_W,'OnCloseStore');
    RegisterPropertyHelper(@TOvcVirtualStoreOnOpenStore_R,@TOvcVirtualStoreOnOpenStore_W,'OnOpenStore');
    RegisterPropertyHelper(@TOvcVirtualStoreOnReadString_R,@TOvcVirtualStoreOnReadString_W,'OnReadString');
    RegisterPropertyHelper(@TOvcVirtualStoreOnWriteString_R,@TOvcVirtualStoreOnWriteString_W,'OnWriteString');
    RegisterPropertyHelper(@TOvcVirtualStoreOnEraseSection_R,@TOvcVirtualStoreOnEraseSection_W,'OnEraseSection');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ovcstore(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TOvcVirtualStore(CL);
  RIRegister_TOvcRegistryStore(CL);
  RIRegister_TOvcIniFileStore(CL);
  RIRegister_TElement(CL);
  RIRegister_TO32XMLFileStore(CL);
end;

 
 
{ TPSImport_ovcstore }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcstore.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ovcstore(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ovcstore.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ovcstore(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
