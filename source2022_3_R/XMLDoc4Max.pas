
{*******************************************************}
{                                                       }
{ Borland Delphi Visual Component Library               }
{ XML Document Support                                  }
{                                                       }
{ Copyright (c) 2001-2005 Borland Software Corporation  }
{                                                       }
{*******************************************************}

unit XMLDoc4Max;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, ActiveX,
{$ENDIF}
{$IFDEF LINUX}
  Types,
{$ENDIF}
  Variants, SysUtils, Classes, xmldom, XMLIntf;

type

// To disambiguate between IXMLDocument in msxml.h and the
// one defined in Xmlintf.pas and forward ref. some types
// that are referenced in the .HPP before they are declared.
(*$HPPEMIT 'namespace Xmldoc {'               *)
{$IFDEF MSWINDOWS}
(*$HPPEMIT 'using Xmlintf::IXMLDocument;'     *)
{$ENDIF}
(*$HPPEMIT 'struct TNodeClassInfo;'           *)
(*$HPPEMIT '__interface IXMLDocumentAccess;'  *)
(*$HPPEMIT '__interface IXMLNodeAccess;'      *)
(*$HPPEMIT '};'                               *)
(*$HPPEMIT 'using Xmldoc::TNodeClassInfo;'    *)


{ Forward Declarartions }

  TXMLNode = class;
  TXMLNodeList = class;
  TXMLNodeCollection = class;
  TXMLDocument = class;

{ TXMLNodeList }

  TNodeListOperation = (nlInsert, nlRemove, nlCreateNode);

  TNodeListNotification = procedure(Operation: TNodeListOperation;
    var Node: IXMLNode; const IndexOrName: OleVariant;
    BeforeOperation: Boolean) of Object;

  TXMLNodeList = class(TInterfacedObject, IXMLNodeList)
  private
    FList: IInterfaceList;
    FNotificationProc: TNodeListNotification;
    FOwner: TXMLNode;
    FUpdateCount: Integer;
    FDefaultNamespaceURI: DOMString;
  //protected
    { IXMLNodeList }
    public
    function Add(const Node: IXMLNode): Integer;
    procedure BeginUpdate;
    procedure Clear;
    function Delete(const Index: Integer): Integer; overload;
    function Delete(const Name: DOMString): Integer; overload;
    function Delete(const Name, NamespaceURI: DOMString): Integer; overload;
    procedure EndUpdate;
    function First: IXMLNode;
    function FindNode(NodeName: DOMString): IXMLNode; overload;
    function FindNode(NodeName, NamespaceURI: DOMString): IXMLNode; overload;
    function FindNode(ChildNodeType: TGuid): IXMLNode; overload;
    function FindSibling(const Node: IXMLNode; Delta: Integer): IXMLNode;
    function Get(Index: Integer): IXMLNode;
    function GetCount: Integer;
    function GetNode(const IndexOrName: OleVariant): IXMLNode;
    function GetUpdateCount: Integer;
    function IndexOf(const Node: IXMLNode): Integer; overload;
    function IndexOf(const Name: DOMString): Integer; overload;
    function IndexOf(const Name, NamespaceURI: DOMString): Integer; overload;
    procedure Insert(Index: Integer; const Node: IXMLNode);
    function Last: IXMLNode;
    function Remove(const Node: IXMLNode): Integer;
    function ReplaceNode(const OldNode, NewNode: IXMLNode): IXMLNode;
    property Count: Integer read GetCount;
    property UpdateCount: Integer read GetUpdateCount;
  protected
    function DoNotify(Operation: TNodeListOperation; const Node: IXMLNode;
      const IndexOrName: OleVariant; BeforeOperation: Boolean): IXMLNode;
    property DefaultNamespaceURI: DOMString read FDefaultNamespaceURI;
    function InternalInsert(Index: Integer; const Node: IXMLNode): Integer;
    property List: IInterfaceList read FList;
    property NotificationProc: TNodeListNotification read FNotificationProc;
    property Owner: TXMLNode read FOwner;
  public
    constructor Create(Owner: TXMLNode; const DefaultNamespaceURI: DOMString;
      NotificationProc: TNodeListNotification);
    destructor Destroy; override;
  end;

{ TXMLNode }

  TXMLNodeClass = class of TXMLNode;

  TXMLNodeArray = array of TXMLNode;

  TNodeClassInfo = record
    NodeName: DOMString;
    NamespaceURI: DOMString;
    NodeClass: TXMLNodeClass;
  end;
  TNodeClassArray = array of TNodeClassInfo;

  TXMLNodeCollectionClass = class of TXMLNodeCollection;

  TNodeChange = (ncUpdateValue, ncInsertChild, ncRemoveChild, ncAddAttribute,
    ncRemoveAttribute);

  IXMLNodeAccess = interface(IXMLNode)
    { Interface used to access additional methods & properties of TXMLNode }
    ['{6C819037-AB66-4AA8-B2A5-958EDA8627B7}']
    function AddChild(const TagName, NamespaceURI: DOMString;
      NodeClass: TXMLNodeClass; Index: Integer = -1): IXMLNode; overload;
    procedure CheckTextNode;
    procedure ClearDocumentRef;
    function CreateAttributeNode(const ADOMNode: IDOMNode): IXMLNode;
    function CreateChildNode(const ADOMNode: IDOMNode): IXMLNode;
    function CreateCollection(const CollectionClass: TXMLNodeCollectionClass;
      const ItemIterface: TGuid; const ItemTag: DOMString;
      ItemNS: DOMString = ''): TXMLNodeCollection;
    function DOMElement: IDOMElement;
    function FindHostedNode(const NodeClass: TXMLNodeClass): IXMLNode;
    function GetChildNodeClasses: TNodeClassArray;
    function GetHostNode: TXMLNode;
    function GetNodeObject: TXMLNode;
    function HasChildNode(const ChildTag: DOMString): Boolean; overload;
    function HasChildNode(const ChildTag, NamespaceURI: DOMString): Boolean; overload;
    function InternalAddChild(NodeClass: TXMLNodeClass;
      const NodeName, NamespaceURI: DOMString; Index: Integer): IXMLNode;
    function NestingLevel: Integer;
    procedure RegisterChildNode(const TagName: DOMString;
      ChildNodeClass: TXMLNodeClass; NamespaceURI: DOMString = '');
    procedure RegisterChildNodes(const TagNames: array of DOMString;
      const NodeClasses: array of TXMLNodeClass);
    procedure SetCollection(const Value: TXMLNodeCollection);
    procedure SetParentNode(const Value: TXMLNode);
    property ChildNodeClasses: TNodeClassArray read GetChildNodeClasses;
    property HostNode: TXMLNode read GetHostNode;
  end;

  TXMLNode = class(TInterfacedObject, IXMLNode, IXMLNodeAccess)
  private
    FAttributeNodes: IXMLNodeList;
    FChildNodes: IXMLNodeList;
    FChildNodeClasses: TNodeClassArray;
    FCollection: TXMLNodeCollection;
    FDocument: TXMLDocument;
    FDOMNode: IDOMNode;
    FHostNode: TXMLNode;
    FParentNode: TXMLNode;
    FHostedNodes: TXMLNodeArray;
    FIsDocElement: Boolean;
    FReadOnly: Boolean;
    FOnHostChildNotify: TNodeListNotification;
    FOnHostAttrNotify: TNodeListNotification;
  protected
    { IXMLNode - Property Accessors }
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    function GetAttribute(const AttrName: DOMString): OleVariant;
    function GetAttributeNodes: IXMLNodeList;
    function GetAttributeNS(const AttrName, NamespaceURI: DOMString): OleVariant;
    function GetChildNodes: IXMLNodeList;
    function GetChildValue(const IndexOrName: OleVariant): OleVariant;
    function GetCollection: IXMLNodeCollection;
    function GetDOMNode: IDOMNode;
    function GetHasChildNodes: Boolean;
    function GetIsTextElement: Boolean;
    function GetLocalName: DOMString;
    function GetNamespaceURI: DOMString;
    function GetNodeName: DOMString;
    function GetNodeType: TNodeType;
    function GetNodeValue: OleVariant;
    function GetOwnerDocument: IXMLDocument;
    function GetParentNode: IXMLNode;
    function GetPrefix: DOMString;
    function GetReadOnly: Boolean;
    function GetText: DOMString;
    function GetXML: DOMString;
    procedure SetAttribute(const AttrName: DOMString; const Value: OleVariant);
    procedure SetChildValue(const IndexOrName: OleVariant; const Value: OleVariant);
    procedure SetNodeValue(const Value: OleVariant);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetText(const Value: DOMString);
    { IXMLNode - Methods }
    public
    function AddChild(const TagName: DOMString; Index: Integer = -1): IXMLNode; overload;
    function AddChild(const TagName, NamespaceURI: DOMString;
      GenPrefix: Boolean = False; Index: Integer = -1): IXMLNode; overload;
    function CloneNode(Deep: Boolean): IXMLNode;
    procedure DeclareNamespace(const Prefix, URI: DOMString);
    function FindNamespaceDecl(const NamespaceURI: DOMString): IXMLNode;
    function FindNamespaceURI(const TagOrPrefix: DOMString): DOMString;
    function HasAttribute(const Name: DOMString): Boolean; overload;
    function HasAttribute(const Name, NamespaceURI: DOMString): Boolean; overload;
    function NextSibling: IXMLNode;
    procedure Normalize;
    function PreviousSibling: IXMLNode;
    procedure Resync;
    procedure SetAttributeNS(const AttrName, NamespaceURI: DOMString; const Value: OleVariant);
    procedure TransformNode(const stylesheet: IXMLNode; var output: WideString); overload;
    procedure TransformNode(const stylesheet: IXMLNode; const output: IXMLDocument); overload;
    { IXMLNodeAccess }
    function AddChild(const TagName, NamespaceURI: DOMString;
      NodeClass: TXMLNodeClass; Index: Integer = -1): IXMLNode; overload;
    procedure CheckTextNode;
    procedure ClearDocumentRef;
    function CreateAttributeNode(const ADOMNode: IDOMNode): IXMLNode; virtual;
    function CreateChildNode(const ADOMNode: IDOMNode): IXMLNode; virtual;
    function CreateCollection(const CollectionClass: TXMLNodeCollectionClass;
      const ItemInterface: TGuid; const ItemTag: DOMString;
      ItemNS: DOMString = ''): TXMLNodeCollection;
    function DOMElement: IDOMElement;
    function FindHostedNode(const NodeClass: TXMLNodeClass): IXMLNode;
    function GetChildNodeClasses: TNodeClassArray;
    function GetHostedNodes: TXMLNodeArray;
    function GetHostNode: TXMLNode;
    function GetNodeObject: TXMLNode;
    function HasChildNode(const ChildTag: DOMString): Boolean; overload;
    function HasChildNode(const ChildTag, NamespaceURI: DOMString): Boolean; overload;
    function InternalAddChild(NodeClass: TXMLNodeClass;
      const NodeName, NamespaceURI: DOMString; Index: Integer): IXMLNode;
    function NestingLevel: Integer;
    procedure RegisterChildNode(const TagName: DOMString;
      ChildNodeClass: TXMLNodeClass; NamespaceURI: DOMString = '');
    procedure RegisterChildNodes(const TagNames: array of DOMString;
      const NodeClasses: array of TXMLNodeClass);
    procedure SetCollection(const Value: TXMLNodeCollection);
    procedure SetParentNode(const Value: TXMLNode); virtual;
    property OnHostChildNotify: TNodeListNotification read FOnHostChildNotify write FOnHostChildNotify;
    property OnHostAttrNotify: TNodeListNotification read FOnHostAttrNotify write FOnHostAttrNotify;
  protected
    { Internal Methods }
    procedure AddHostedNode(Node: TXMLNode);
    procedure AttributeListNotify(Operation: TNodeListOperation;
      var Node: IXMLNode; const IndexOrName: OleVariant; BeforeOperation: Boolean);
    procedure CheckReadOnly;
    procedure ChildListNotify(Operation: TNodeListOperation; var Node: IXMLNode;
      const IndexOrName: OleVariant; BeforeOperation: Boolean); virtual;
    procedure CheckNotHosted;
    function CreateAttributeList: IXMLNodeList; dynamic;
    function CreateChildList: IXMLNodeList; dynamic;
    procedure DoNodeChange(ChangeType: TNodeChange; BeforeOperation: Boolean); virtual;
    function GetPrefixedName(const Name, NamespaceURI: DOMString): DOMString;
    procedure RemoveHostedNode(Node: TXMLNode);
    procedure SetAttributeNodes(const Value: IXMLNodeList); virtual;
    procedure SetChildNodes(const Value: IXMLNodeList); virtual;
    { Data member access }
   public 
    property AttributeNodes: IXMLNodeList read GetAttributeNodes;
    property ChildNodes: IXMLNodeList read GetChildNodes write SetChildNodes;
    property ChildNodeClasses: TNodeClassArray read GetChildNodeClasses;
    property Collection: TXMLNodeCollection read FCollection write FCollection;
    property DOMNode: IDOMNode read FDOMNode;
    property HostedNodes: TXMLNodeArray read GetHostedNodes;
    property HostNode: TXMLNode read FHostNode write FHostNode;
    property OwnerDocument: TXMLDocument read FDocument;
    property ParentNode: TXMLNode read FParentNode;
  public
    constructor Create(const ADOMNode: IDOMNode; const AParentNode: TXMLNode;
      const OwnerDoc: TXMLDocument);
    constructor CreateHosted(HostNode: TXMLNode);
    destructor Destroy; override;
  end;

{ TXMLNodeCollection }

  TXMLNodeCollection = class(TXMLNode, IXMLNodeCollection)
  private
    FItemInterface: TGuid;
    FItemNS: DOMString;
    FItemTag: DOMString;
    FList: IXMLNodeList;
  protected
    { IXMLNodeCollection }
    procedure Clear;
    function GetCount: Integer;
    function GetList: IXMLNodeList; virtual;
    function GetNode(Index: Integer): IXMLNode;
    procedure Delete(Index: Integer);
    function Remove(const AItem: IXMLNode): Integer;
    procedure ChildListNotify(Operation: TNodeListOperation;
      var Node: IXMLNode; const IndexOrName: OleVariant; BeforeOperation: Boolean); override;
    procedure UpdateCollectionList(Operation: TNodeListOperation;
    var Node: IXMLNode; const IndexOrName: OleVariant;
    BeforeOperation: Boolean);
    property Count: Integer read GetCount;
  protected
    function AddItem(Index: Integer): IXMLNode; virtual;
    procedure CreateItemList(CheckFirst: Boolean = False);
    procedure InsertInCollection(Node: IXMLNode; Index: Integer);
    function IsCollectionItem(const Node: IXMLNode): Boolean;
    procedure SetChildNodes(const Value: IXMLNodeList); override;
    { Data member access }
    property ItemInterface: TGuid read FItemInterface write FItemInterface;
    property ItemNS: DOMString read FItemNS write FItemNS;
    property ItemTag: DOMString read FItemTag write FItemTag;
    property List: IXMLNodeList read GetList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDocument }

  TNodeChangeEvent = procedure(const Node: IXMLNode;
    ChangeType: TNodeChange) of object;

  TXMLPrologItem = (xpVersion, xpEncoding, xpStandalone);

  TXMLDocumentSource = (xdsNone, xdsXMLProperty, xdsXMLData, xdsFile, xdsStream);

  IXMLDocumentAccess = interface
    { Interface used to access protected properties of TXMLDocument }
    ['{933FDA52-B0D0-440C-B3E9-C37FFB4B906B}']
    { Property Accessors }
    function GetDocumentObject: TXMLDocument;
    function GetDOMPersist: IDOMPersist;
    { Properties }
    property DocumentObject: TXMLDocument read GetDocumentObject;
    property DOMPersist: IDOMPersist read GetDOMPersist;
  end;

  TXMLDocument = class(TComponent, IInterface, IXMLDocument, IXMLDocumentAccess)
  private
    FXMLData: DOMString;
    FSrcStream: TStream;
    FXMLStrings: TStringList;
    FDOMVendor: TDOMVendor;
    FRefCount: Integer;
    FDocBindingInfo: TNodeClassArray;
    FDOMPersist: IDOMPersist;
    FDOMDocument: IDOMDocument;
    FDOMImplementation: IDOMImplementation;
    FDOMParseOptions: IDOMParseOptions;
    FParseOptions: TParseOptions;
    FDocumentNode: IXMLNode;
    FFileName: DOMString;
    FOptions: TXMLDocOptions;
    FPrefixID: Integer;
    FNSPrefixBase: DOMString;
    FNodeIndentStr: DOMString;
    FStreamedActive: Boolean;
    FModified: Integer;
    FXMLStrRead: Integer;
    FDocSource: TXMLDocumentSource;
    FAfterClose: TNotifyEvent;
    FBeforeOpen: TNotifyEvent;
    FBeforeClose: TNotifyEvent;
    FAfterOpen: TNotifyEvent;
    FOwnerIsComponent: Boolean;
    FBeforeNodeChange: TNodeChangeEvent;
    FAfterNodeChange: TNodeChangeEvent;
    FOnAsyncLoad: TAsyncEventHandler;
    function GetDOMParseOptions: IDOMParseOptions;
    function IsXMLStored: Boolean;
    function NodeIndentStored: Boolean;
    procedure SetDOMImplementation(const Value: IDOMImplementation);
    procedure SetDOMVendor(const Value: TDOMVendor);
  protected
    { IInterface }
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IXMLDocument - Property Accessors only}
    function GetActive: Boolean; virtual;
    function GetAsyncLoadState: Integer;
    function GetChildNodes: IXMLNodeList;
    function GetDocumentElement: IXMLNode;
    function GetEncoding: DOMString;
    function GetDOMDocument: IDOMDocument;
    function GetDocumentNode: IXMLNode;
    function GetFileName: DOMString;
    function GetModified: Boolean;
    function GetNodeIndentStr: DOMString;
    function GetOptions: TXMLDocOptions;
    function GetParseOptions: TParseOptions;
    function GetSchemaRef: DOMString;
    function GetStandAlone: DOMString;
    function GetVersion: DOMString;
    function GetXML: TSTrings;
    procedure SetActive(const Value: Boolean); virtual;
    procedure SetDocumentElement(const Value: IXMLNode);
    procedure SetDOMDocument(const Value: IDOMDocument);
    procedure SetEncoding(const Value: DOMString);
    procedure SetNodeIndentStr(const Value: DOMString);
    procedure SetOnAsyncLoad(const Value: TAsyncEventHandler);
    procedure SetOptions(const Value: TXMLDocOptions);
    procedure SetParseOptions(const Value: TParseOptions);
    procedure SetStandAlone(const Value: DOMString);
    procedure SetVersion(const Value: DOMString);
    procedure SetXML(const Value: TStrings);
    { IXMLDocumentAccess }
    function GetDocumentObject: TXMLDocument;
    function GetDOMPersist: IDOMPersist;
  protected
    procedure AssignParseOptions;
    procedure CheckActive;
    procedure CheckAutoSave; dynamic;
    procedure CheckDOM; dynamic;
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoAfterClose; dynamic;
    procedure DoAfterOpen; dynamic;
    procedure DoBeforeClose; dynamic;
    procedure DoBeforeOpen; dynamic;
    procedure DoNodeChange(const Node: IXMLNode; ChangeType: TNodeChange;
      BeforeOperation: Boolean);
    function GetPrologNode: IXMLNode;
    function GetPrologValue(PrologItem: TXMLPrologItem;
      const Default: DOMString = ''): DOMString;
    function GetChildNodeClass(const Node: IDOMNode): TXMLNodeClass; virtual;
    function InternalSetPrologValue(const PrologNode: IXMLNode;
      const Value: Variant; PrologItem: TXMLPrologItem): string;
    procedure LoadData; dynamic;
    procedure Loaded; override;
    procedure ReadDOMVendor(Reader: TReader);
    procedure ReleaseDoc(const CheckSave: Boolean = True); dynamic;
    procedure SaveToXMLStrings;
    procedure SaveToUTF8String(var XML: string);
    procedure SetFileName(const Value: DOMString);
    procedure SetModified(const Value: Boolean);
    procedure SetPrologValue(const Value: Variant; PrologItem: TXMLPrologItem);
    procedure SetXMLStrings(const Value: string);
    procedure WriteDOMVendor(Writer: TWriter);
    procedure XMLStringsChanging(Sender: TObject);
    property DocBindingInfo: TNodeClassArray read FDocBindingInfo;
    property DocSource: TXMLDocumentSource read FDocSource write FDocSource;
    property DOMParseOptions: IDOMParseOptions read GetDOMParseOptions;
    property DOMPersist: IDOMPersist read GetDOMPersist;
    property PrefixID: Integer read FPrefixID write FPrefixID;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(const AFileName: DOMString); reintroduce; overload;
    class function NewInstance: TObject; override;
    procedure AfterConstruction; override;
    destructor Destroy; override;
    { IXMLDocument Methods }
    function AddChild(const TagName: DOMString): IXMLNode; overload;
    function AddChild(const TagName, NamespaceURI: DOMString): IXMLNode; overload;
    function CreateElement(const TagOrData, NamespaceURI: DOMString): IXMLNode;
    function CreateNode(const NameOrData: DOMString;
      NodeType: TNodeType = ntElement; const AddlData: DOMString = ''): IXMLNode;
    function GetDocBinding(const TagName: DOMString;
      DocNodeClass: TClass; NamespaceURI: DOMString = ''): IXMLNode;
    function IsEmptyDoc: Boolean;
    procedure LoadFromFile(const AFileName: DOMString = '');
    procedure LoadFromStream(const Stream: TStream; EncodingType:
      TXMLEncodingType = xetUnknown);
    procedure LoadFromXML(const XML: string); overload;
    procedure LoadFromXML(const XML: DOMString); overload;
    procedure Refresh;
    procedure RegisterDocBinding(const TagName: DOMString;
      DocNodeClass: TClass; NamespaceURI: DOMString = '');
    procedure Resync;
    procedure SaveToFile(const AFileName: DOMString = ''); dynamic;
    procedure SaveToStream(const Stream: TStream);
    procedure SaveToXML(var XML: DOMString); overload;
    procedure SaveToXML(var XML: string); overload;
    { Properties }
    property AsyncLoadState: Integer read GetAsyncLoadState;
    property ChildNodes: IXMLNodeList read GetChildNodes;
    property DOMDocument: IDOMDocument read GetDOMDocument write SetDOMDocument;
    property DOMImplementation: IDOMImplementation read FDOMImplementation write SetDOMImplementation;
    property DocumentElement: IXMLNode read GetDocumentElement write SetDocumentElement;
    property Encoding: DOMString read GetEncoding write SetEncoding;
    function GeneratePrefix(const Node: IXMLNode): DOMString;
    property Modified: Boolean read GetModified;
    property Node: IXMLNode read GetDocumentNode;
    property NSPrefixBase: DOMString read FNSPrefixBase write FNSPrefixBase;
    property SchemaRef: DOMString read GetSchemaRef;
    property StandAlone: DOMString read GetStandAlone write SetStandAlone;
    property Version: DOMString read GetVersion write SetVersion;
  published
    property Active: Boolean read GetActive write SetActive default False;
    property FileName: DOMString read GetFileName write SetFileName;
    property DOMVendor: TDOMVendor read FDOMVendor write SetDOMVendor;
    property NodeIndentStr: DOMString read GetNodeIndentStr write SetNodeIndentStr stored NodeIndentStored;
    property Options: TXMLDocOptions read GetOptions write SetOptions
      default [doNodeAutoCreate, doAttrNull, doAutoPrefix, doNamespaceDecl];
    property ParseOptions: TParseOptions read GetParseOptions write SetParseOptions default [];
    property XML: TStrings read GetXML write SetXML stored IsXMLStored;
    property BeforeOpen: TNotifyEvent read FBeforeOpen write FBeforeOpen;
    property AfterOpen: TNotifyEvent read FAfterOpen write FAfterOpen;
    property BeforeClose: TNotifyEvent read FBeforeClose write FBeforeClose;
    property AfterClose: TNotifyEvent read FAfterClose write FAfterClose;
    property BeforeNodeChange: TNodeChangeEvent read FBeforeNodeChange write FBeforeNodeChange;
    property AfterNodeChange: TNodeChangeEvent read FAfterNodeChange write FAfterNodeChange;
    property OnAsyncLoad: TAsyncEventHandler read FOnAsyncLoad write SetOnAsyncLoad;
  end;

{ Utility Routines }

function CreateDOMNode(Doc: IDOMDocument; const NameOrData: DOMString;
  NodeType: TNodeType = ntElement; const AddlData: DOMString = ''): IDOMNode;
function DetectCharEncoding(S: TStream): TXmlEncodingType;
procedure CheckEncoding(var XMLData: DOMString;
  const ValidEncodings: array of string);
function XMLStringToWideString(const XMLString: string): WideString;
function FormatXMLData(const XMLData: DOMString): DOMString;

function LoadXMLDocument(const FileName: DOMString): IXMLDocument;
function LoadXMLData(const XMLData: DOMString): IXMLDocument; overload;
function LoadXMLData(const XMLData: string): IXMLDocument; overload;
function NewXMLDocument(Version: DOMString = '1.0'): IXMLDocument;

procedure XMLDocError(const Msg: string); overload;
procedure XMLDocError(const Msg: string; const Args: array of const); overload;

var
  // For backwards compatibility set this to False to have boolean values stored as
  // "True" and "False" instead of in the W3C XML Schema standard "true" and "false"
  UseXSDBooleanStrings: Boolean = True;
  
implementation

uses
{$IFNDEF LINUX}
  Types,
{$ENDIF}
  XMLSchema, XMLConst;

const
  DefaultNodeIndent: WideString = '  '; { 2 spaces }
  AttrChangeTypeMap: array[Boolean] of TNodeChange =
    (ncAddAttribute, ncRemoveAttribute);
  XSDBoolStrs: array[Boolean] of DOMString = ('false', 'true'); // Do not localize

{ Utility Functions }

procedure XMLDocError(const Msg: string); overload;
begin
  raise EXMLDocError.Create(Msg);
end;

procedure XMLDocError(const Msg: string; const Args: array of const); overload;
begin
  raise EXMLDocError.CreateFmt(Msg, Args);
end;

function CreateDOMNode(Doc: IDOMDocument; const NameOrData: DOMString;
  NodeType: TNodeType = ntElement; const AddlData: DOMString = ''): IDOMNode;
begin
  case NodeType of
    ntElement:
      if AddlData = '' then
        Result := Doc.createElement(NameOrData) else
        Result := Doc.createElementNS(AddlData, NameOrData);
    ntAttribute:
      if AddlData = '' then
        Result := Doc.createAttribute(NameOrData) else
        Result := Doc.createAttributeNS(AddlData, NameOrData);
    ntText:
      Result := Doc.createTextNode(NameOrData);
    ntCData:
      Result := Doc.createCDATASection(NameOrData);
    ntEntityRef:
      Result := Doc.createEntityReference(NameOrData);
    ntProcessingInstr:
      Result := Doc.createProcessingInstruction(NameOrData, AddlData);
    ntComment:
      Result := Doc.createComment(NameOrData);
    ntDocFragment:
      Result := Doc.createDocumentFragment;
    ntReserved,
    ntEntity,
    ntDocument,
    ntDocType: XMLDocError(SInvalidNodeType);
  end;
end;

function CloneNodeToDoc(const SourceNode: IXMLNode; const TargetDoc: IXMLDocument;
  Deep: Boolean = True): IXMLNode;
var
  I: Integer;
begin
  with SourceNode do
    case nodeType of
      ntElement:
        begin
          Result := TargetDoc.CreateElement(NodeName, NamespaceURI);
          for I := 0 to AttributeNodes.Count - 1 do
            Result.AttributeNodes.Add(CloneNodeToDoc(AttributeNodes[I], TargetDoc, False));
          if Deep then
            for I := 0 to ChildNodes.Count - 1 do
              Result.ChildNodes.Add(CloneNodeToDoc(ChildNodes[I], TargetDoc, Deep));
        end;
      ntAttribute:
        begin
          Result := TargetDoc.CreateNode(NodeName, ntAttribute, NamespaceURI);
          Result.NodeValue := NodeValue;
        end;
      ntText, ntCData, ntComment:
          Result := TargetDoc.CreateNode(NodeValue, NodeType);
      ntEntityRef:
          Result := TargetDoc.createNode(nodeName, NodeType);
      ntProcessingInstr:
          Result := TargetDoc.CreateNode(NodeName, ntProcessingInstr, NodeValue);
      ntDocFragment:
        begin
          Result := TargetDoc.CreateNode('', ntDocFragment);
          if Deep then
            for I := 0 to ChildNodes.Count - 1 do
              Result.ChildNodes.Add(CloneNodeToDoc(ChildNodes[I], TargetDoc, Deep));
        end;
      else
       {ntReserved, ntEntity, ntDocument, ntDocType:}
        XMLDocError(SInvalidNodeType);
    end;
end;

function FormatXMLData(const XMLData: DOMString): DOMString;
var
  SrcDoc,
  DestDoc: IXMLDocument;

  procedure RemoveDeclNode;
  var
    FirstNode: IXMLNode;
  begin
    FirstNode := SrcDoc.Node.ChildNodes[0];
    if (FirstNode.NodeName = 'xml') or (FirstNode.NodeName = '#xmldecl') then
      SrcDoc.ChildNodes.Delete(0);
  end;

  procedure CopyChildNodes(SrcNode, DestNode: IXMLNode);
  var
    I: Integer;
    SrcChild, DestChild: IXMLNode;
  begin
    for I := 0 to SrcNode.ChildNodes.Count - 1 do
    begin
      SrcChild := SrcNode.ChildNodes[I];
      DestChild := CloneNodeToDoc(SrcChild, DestDoc, False);
      { Note this fails on documents with DOCTYPE nodes }
      DestNode.ChildNodes.Add(DestChild);
      if SrcChild.HasChildNodes then
        CopyChildNodes(SrcChild, DestChild);
    end;
  end;

begin
  SrcDoc := LoadXMLData(XMLData);
  DestDoc := NewXMLDocument('');
  if SrcDoc.Version <> '' then
    DestDoc.Version := SrcDoc.Version;
  if SrcDoc.StandAlone <> '' then
    DestDoc.StandAlone := SrcDoc.StandAlone;
  if SrcDoc.Encoding <> '' then
    DestDoc.Encoding := SrcDoc.Encoding;
  if (SrcDoc.ChildNodes.Count > 1) then
    RemoveDeclNode;
  DestDoc.Options := DestDoc.Options + [doNodeAutoIndent];
  CopyChildNodes(SrcDoc.Node, DestDoc.Node);
  DestDoc.SaveToXML(Result);
end;

function LoadXMLDocument(const FileName: DOMString): IXMLDocument;
begin
  Result := TXMLDocument.Create(FileName);
end;

function LoadXMLData(const XMLData: DOMString): IXMLDocument; overload;
begin
  Result := TXMLDocument.Create(nil);
  Result.LoadFromXML(XMLData);
end;

function LoadXMLData(const XMLData: string): IXMLDocument; overload;
begin
  Result := TXMLDocument.Create(nil);
  Result.LoadFromXML(XMLData);
end;

function NewXMLDocument(Version: DOMString = '1.0'): IXMLDocument;
begin
  Result := TXMLDocument.Create(nil);
  Result.Active := True;
  if Version <> '' then
    Result.Version := Version;
end;

function ExtractAttrValue(const AttrName, AttrLine: string;
  const Default: DOMString = ''): DOMString;
var
  LineLen, ItemPos, ItemEnd: Integer;
begin
  ItemPos := Pos(AttrName, AttrLine);
  LineLen := Length(AttrLine);
  if ItemPos > 0 then
  begin
    Inc(ItemPos, Length(AttrName));
    while (ItemPos < LineLen) and not (AttrLine[ItemPos] in ['''','"']) do
      Inc(ItemPos);
    if ItemPos < LineLen then
    begin
      ItemEnd := ItemPos + 1;
      while (ItemEnd < LineLen) and not (AttrLine[ItemEnd] in ['''','"']) do
        Inc(ItemEnd);
      Result := Copy(AttrLine, ItemPos+1, ItemEnd-ItemPos-1);
    end;
  end
  else
    Result := Default;
end;

function DetectCharEncoding(S: TStream): TXmlEncodingType;
type
  TBytesRead = array [0..3] of Byte;
const
  SizeOfBytesRead = SizeOf(TBytesRead);
var
  APosition, AIndex, AMod: Integer;
  ARead: TBytesRead;

  function ReadAtPos(At: LongInt): LongInt;
  begin
    S.Seek(At, soFromBeginning);
    Result := S.Read(ARead, SizeOfBytesRead);
  end;

  function CompareToRead(const AArray: array of Byte): Boolean;
  begin
    case Length(AArray) of
      1:
        Result := (ARead[0] = AArray[0]);
      2:
        Result := (ARead[0] = AArray[0]) and
                  (ARead[1] = AArray[1]);
      3:
        Result := (ARead[0] = AArray[0]) and
                  (ARead[1] = AArray[1]) and
                  (ARead[2] = AArray[2]);
      4:
        Result := (ARead[0] = AArray[0]) and
                  (ARead[1] = AArray[1]) and
                  (ARead[2] = AArray[2]) and
                  (ARead[3] = AArray[3]);
      else
        Result := False;
    end;
  end;

  function CheckIntegerValue: TXmlEncodingType;
  begin
    Result := xetUnknown;
    if CompareToRead([$00, $00, $FE, $FF]) then
      Result := xetUCS_4BE
    else if CompareToRead([$FF, $FE, $00, $00]) then
        Result := xetUCS_4LE
    else if CompareToRead([$00, $00, $FF, $FE]) then
        Result := xetUCS_4Order2134
    else if CompareToRead([$FE, $FF, $00, $00]) then
        Result := xetUCS_4Order3412
    else if CompareToRead([$00, $3C, $00, $3F]) then
        Result := xetUTF_16BELike
    else if CompareToRead([$3C, $00, $3F, $00]) then
        Result := xetUTF_16LELike
    else if CompareToRead([$3C, $3F, $78, $6D]) then
        Result := xetUTF_8Like
    else if CompareToRead([$4C, $6F, $A7, $94]) then
        Result := xetEBCDICLike
    else if CompareToRead([$00, $00, $00, $3C]) then
    begin
      if (ReadAtPos(AIndex +  4) = SizeOfBytesRead) and CompareToRead([$00, $00, $00, $3F]) then
        Result := xetUCS_4BE
      else if (ReadAtPos(AIndex +  4) = SizeOfBytesRead) and CompareToRead([$3C, $00, $00, $00]) and
              (ReadAtPos(AIndex +  8) = SizeOfBytesRead) and CompareToRead([$00, $00, $3C, $00]) and
              (ReadAtPos(AIndex + 12) = SizeOfBytesRead) and CompareToRead([$00, $3C, $00, $00]) then
        Result := xetUCS_4Like;
    end
    else if CompareToRead([$3C, $00, $00, $00]) then
    begin
      if (ReadAtPos(AIndex + 4) = SizeOfBytesRead) and CompareToRead([$3F, $00, $00, $00]) then
        Result := xetUCS_4LE
    end;
  end;

  function CheckWordValue: TXmlEncodingType;
  begin
    if CompareToRead([$FE, $FF, $00, $00]) then
      Result := xetUTF_16BE
    else if CompareToRead([$FF, $FE, $00, $00]) then
        Result := xetUTF_16LE
    else
      Result := xetUnknown;
  end;

begin
  Result := xetUnknown;
  APosition := S.Position;
  try
    AIndex := 0;
    while (Result = xetUnknown) and
          (ReadAtPos(AIndex) = SizeOfBytesRead) do
    begin
      AMod := AIndex mod 4;

      if (AMod = 0) then
        Result := CheckIntegerValue
      else if (AMod = 2) then
      begin
        Result := CheckIntegerValue;
        if Result = xetUnknown then
          Result := CheckWordValue;
      end;
      if Result = xetUnknown then
      begin
        if CompareToRead([$EF, $BB, $BF])then
          Result := xetUTF_8;
      end;

      Inc(AIndex);
    end;
  finally
    S.Position := APosition;
  end;
end;

function EncodingMatches(const Encoding: string;
  const EncodingList: array of string): Boolean;
var
  I: Integer;
begin
  for I := 0 to High(EncodingList) do
    if SameText(EncodingList[I], Encoding) then
    begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

procedure CheckEncoding(var XMLData: DOMString;
  const ValidEncodings: array of string);
var
  Encoding: string;
  EncodingPos, EncodingLen: Integer;
begin
  { Check if the XML data has an encoding, if so it must match one of the
    valid encodings, or we will remove it. }
  Encoding := ExtractAttrValue(SEncoding, Copy(XMLData, 1, 50), '');
  if (Encoding <> '') and not EncodingMatches(Encoding, ValidEncodings) then
  begin
    EncodingPos := Pos(SEncoding, XMLData);
    EncodingLen := Length(Encoding) + 12;
    Delete(XMLData, EncodingPos - 1, EncodingLen);
  end;
end;

function XMLStringToWideString(const XMLString: string): WideString;
const
  AnsiEncodings: array[0..1] of string = ('ISO-8859-1', 'US-ASCII');
  UnicodeEncodings: array[0..2] of string = ('UTF-16', 'UCS-2', 'UNICODE');
var
  Encoding: string;
begin
  Encoding := ExtractAttrValue(SEncoding, Copy(XMLString, 1, 50), '');
  { No Encoding is assumed to be UTF-8 }
  if (Encoding = '') or SameText(Encoding, 'UTF-8') then
    Result := UTF8Decode(XMLString)
  { Latin1 and ASCII can use standard AnsiString->WideString conversion }
  else if EncodingMatches(Encoding, AnsiEncodings) then
    Result := XMLString
  else
  { All others fail }
    XMLDocError(SUnsupportedEncoding, [Encoding]);
  CheckEncoding(Result, UnicodeEncodings);
end;

procedure AddNodeClassInfo(var NodeClasses: TNodeClassArray;
  const NodeClass: TXMLNodeClass; const TagName, NamespaceURI: DOMString);
var
  I, J, OldLength: Integer;
begin
  OldLength := Length(NodeClasses);
  { Check if there is already a node registered, and replace the class if so }
  for I := 0 to OldLength - 1 do
    if (NodeClasses[I].NodeName = TagName) and
       (NodeClasses[I].NamespaceURI = NamespaceURI) then
    begin
      if Assigned(NodeClass) then
        NodeClasses[I].NodeClass := NodeClass
      else
      begin
        { If ChildNodeClass = nil, then unregister the entry }
        for J := I to OldLength - 2 do
          NodeClasses[J] := NodeClasses[J+1];
        SetLength(NodeClasses, OldLength-1);
      end;
      Exit;
    end;
  { Othwise append the entry }
  SetLength(NodeClasses, OldLength + 1);
  NodeClasses[OldLength].NodeName := TagName;
  NodeClasses[OldLength].NodeClass := NodeClass;
  NodeClasses[OldLength].NamespaceURI := NamespaceURI;
end;

procedure AppendItem(var AttrStr: string; const AttrName, AttrValue: string);
begin
  if AttrValue <> '' then
  begin
    if AttrStr <> '' then
      AttrStr := AttrStr + ' ';
    AttrStr := AttrStr + Format('%s="%s"', [AttrName, AttrValue]);
  end;
end;

// TODO: Move this routine into the RTL.
type
   TStringSplitOption = (ssNone, ssRemoveEmptyEntries);
   TStringSplitOptions = set of TStringSplitOption;

function SplitString(const S: WideString; Delimiter: WideChar;
   const StringSplitOptions: TStringSplitOptions = []): TWideStringDynArray;
var
  LInputLength, LResultCapacity, LResultCount, LCurPos, LSplitStartPos: Integer;
begin
  {Get the current capacity of the result array}
  LResultCapacity := Length(Result);
  {Reset the number of results already set}
  LResultCount := 0;
  {Start at the first character}
  LSplitStartPos := 1;
  {Save the length of the input}
  LInputLength := Length(S);
  {Step through the entire string}
  for LCurPos := 1 to LInputLength do
  begin
    {Find a delimiter}
    if S[LCurPos] = Delimiter then
    begin
      {Is the split non-empty, or are empty strings allowed?}
      if (LSplitStartPos < LCurPos)
        or not (ssRemoveEmptyEntries in StringSplitOptions) then
      begin
        {Split must be added - is there enough capacity in the result array?}
        if LResultCount = LResultCapacity then
        begin
          {Grow the result array - make it slightly more than double the
           current size}
          LResultCapacity := LResultCapacity * 2 + 8;
          SetLength(Result, LResultCapacity);
        end;
        {Set the string}
        SetString(Result[LResultCount], PWideChar(@S[LSplitStartPos]),
          LCurPos - LSplitStartPos);
        {Increment the result count}
        Inc(LResultCount);
      end;
      {Set the next split start position}
      LSplitStartPos := LCurPos + 1;
    end;
  end;
  {Add the final split}
  if (LSplitStartPos <= LInputLength)
    or not (ssRemoveEmptyEntries in StringSplitOptions) then
  begin
    {Correct the output length}
    if LResultCount + 1 <> LResultCapacity then
      SetLength(Result, LResultCount + 1);
    {Set the string}
    SetString(Result[LResultCount], PWideChar(@S[LSplitStartPos]),
      LInputLength - LSplitStartPos + 1);
  end
  else
  begin
    {No final split - correct the output length}
    if LResultCount <> LResultCapacity then
      SetLength(Result, LResultCount);
  end;
end;

{ TXMLNodeList }

constructor TXMLNodeList.Create(Owner: TXMLNode;
  const DefaultNamespaceURI: DOMString; NotificationProc: TNodeListNotification);
begin
  FList := TInterfaceList.Create;
  FOwner := Owner;
  FNotificationProc := NotificationProc;
  FDefaultNamespaceURI := DefaultNamespaceURI;
  inherited Create;
end;

destructor TXMLNodeList.Destroy;
begin
  inherited;
end;

procedure TXMLNodeList.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TXMLNodeList.EndUpdate;
begin
  Dec(FUpdateCount);
end;

function TXMLNodeList.DoNotify(Operation: TNodeListOperation; const Node: IXMLNode;
  const IndexOrName: OleVariant; BeforeOperation: Boolean): IXMLNode;
begin
  Result := Node;
  if Assigned(NotificationProc) then
    NotificationProc(Operation, Result, IndexOrName, BeforeOperation);
end;

function TXMLNodeList.GetCount: Integer;
begin
  Result := List.Count;
end;

function TXMLNodeList.IndexOf(const Node: IXMLNode): Integer;
begin
  Result := List.IndexOf(Node as IXMLNode)
end;

function TXMLNodeList.IndexOf(const Name: DOMString): Integer;
begin
  Result := IndexOf(Name, DefaultNamespaceURI);
end;

function TXMLNodeList.IndexOf(const Name, NamespaceURI: DOMString): Integer;
begin
  for Result := 0 to Count - 1 do
    if NodeMatches(Get(Result).DOMNode, Name, NamespaceURI) then Exit;
  Result := -1;
end;

function TXMLNodeList.FindNode(NodeName: DOMString): IXMLNode;
begin
  Result := FindNode(NodeName, DefaultNamespaceURI);
end;

function TXMLNodeList.FindNode(NodeName, NamespaceURI: DOMString): IXMLNode;
var
  Index: Integer;
begin
  Index := IndexOf(NodeName, NamespaceURI);
  if Index >= 0 then
    Result := Get(Index)
  else
    Result := nil;
end;

function TXMLNodeList.FindNode(ChildNodeType: TGuid): IXMLNode;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
    if Supports(Get(I), ChildNodeType, Result) then Exit;
  Result := nil;
end;

function TXMLNodeList.First: IXMLNode;
begin
  if List.Count > 0 then
    Result := List.First as IXMLNode else
    Result := nil;
end;

function TXMLNodeList.Last: IXMLNode;
begin
  if List.Count > 0 then
    Result := List.Last as IXMLNode else
    Result := nil;
end;

function TXMLNodeList.FindSibling(const Node: IXMLNode; Delta: Integer): IXMLNode;
var
  Index: Integer;
begin
  Index := IndexOf(Node);
  Index := Index + Delta;
  if (Index >= 0) and (Index < list.Count) then
    Result := Get(Index) else
    Result := nil;
end;

function TXMLNodeList.Get(Index: Integer): IXMLNode;
begin
  Result := List.Get(Index) as IXMLNode;
end;

function TXMLNodeList.GetNode(const IndexOrName: OleVariant): IXMLNode;
begin
  if VarIsOrdinal(IndexOrName) then
    Result := List.Get(IndexOrName) as IXMLNode
  else
  begin
    Result := FindNode(DOMString(IndexOrName));
    if not Assigned(Result) and
      ( (doNodeAutoCreate in Owner.OwnerDocument.Options) and not
        // Don't try to autocreate a second document element !
        ( (FOwner.GetNodeType = ntDocument) and (FOwner.OwnerDocument.DocumentElement <> nil) )
      ) then
      Result := DoNotify(nlCreateNode, nil, IndexOrName, True);
    if not Assigned(Result) then
      XMLDocError(SNodeNotFound, [IndexOrName]);
  end;
end;

function TXMLNodeList.Add(const Node: IXMLNode): Integer;
begin
  Insert(-1, Node);
  Result := Count - 1;
end;

function TXMLNodeList.InternalInsert(Index: Integer;
  const Node: IXMLNode): Integer;
begin
  DoNotify(nlInsert, Node, Index, True);
  if Index <> -1 then
  begin
     List.Insert(Index, Node as IXMLNode);
     Result := Index;
  end
  else
    Result := List.Add(Node as IXMLNode);
  DoNotify(nlInsert, Node, Index, False);
end;

procedure TXMLNodeList.Insert(Index: Integer; const Node: IXMLNode);

  procedure InsertFormattingNode(const Len, Index: Integer;
    Break: Boolean = True);
  var
    I: Integer;
    IndentNode: IXMLNode;
    IndentStr: DOMString;
  begin
    for I := 1 to Len do
      IndentStr := IndentStr + Owner.OwnerDocument.NodeIndentStr;
    if Break then
      IndentStr := SLineBreak + IndentStr;
    with Owner do
      IndentNode := TXMLNode.Create(CreateDOMNode(OwnerDocument.DOMDocument,
        IndentStr, ntText), nil, OwnerDocument);
    InternalInsert(Index, IndentNode);
  end;

var
  TrailIndent, NewIndex: Integer;
begin
  { Determine if we should add do formatting here }
  if Assigned(Owner.ParentNode) and (Owner.HostNode = nil) and
     (doNodeAutoIndent in Owner.OwnerDocument.Options) and
     not (Node.NodeType in [ntText, ntAttribute]) then
  begin
    { Insert formatting before the node }
    if Count = 0 then
      InsertFormattingNode(Owner.ParentNode.NestingLevel, -1);
    if Index = -1 then
      InsertFormattingNode(1, -1, False);
    { Insert the actual node }
    NewIndex := InternalInsert(Index, Node);
    { Insert formatting after the node }
    if Index = -1 then
      TrailIndent := Owner.ParentNode.NestingLevel else
      TrailIndent := Owner.NestingLevel;
    if (NewIndex >= Count-1) or (Get(NewIndex+1).NodeType <> ntText) then
      InsertFormattingNode(TrailIndent, NewIndex + 1)
  end else
    InternalInsert(Index, Node);
end;

function TXMLNodeList.Delete(const Index: Integer): Integer;
begin
  Result := Remove(Get(Index));
end;

function TXMLNodeList.Delete(const Name: DOMString): Integer;
begin
  Result := Delete(Name, DefaultNamespaceURI);
end;

function TXMLNodeList.Delete(const Name, NamespaceURI: DOMString): Integer;
var
  Node: IXMLNode;
begin
  Node := FindNode(Name, NamespaceURI);
  if Assigned(Node) then
    Result := Remove(Node)
  else
   { No error when named nodes doesn't exist }
    Result := -1;
end;

function TXMLNodeList.Remove(const Node: IXMLNode): Integer;
begin
  DoNotify(nlRemove, Node, -1, True);
  Result := List.Remove(Node as IXMLNode);
  DoNotify(nlRemove, Node, -1, False);
end;

function TXMLNodeList.ReplaceNode(const OldNode, NewNode: IXMLNode): IXMLNode;
var
  Index: Integer;
begin
  Index := Remove(OldNode);
  Insert(Index, NewNode);
  Result := OldNode;
end;

procedure TXMLNodeList.Clear;
begin
  List.Lock;
  try
    while Count > 0 do
      Remove(Get(0));
  finally
    List.Unlock;
  end;
end;

function TXMLNodeList.GetUpdateCount: Integer;
begin
  Result := FUpdateCount;
end;

{ TXMLNode }

constructor TXMLNode.Create(const ADOMNode: IDOMNode;
  const AParentNode: TXMLNode; const OwnerDoc: TXMLDocument);
begin
  inherited Create;
  if not Assigned(ADOMNode) then
    XMLDocError(SMissingNode);
  FDOMNode := ADOMNode;
  FParentNode := AParentNode;
  FDocument := OwnerDoc;
  FIsDocElement := Assigned(FParentNode) and
    (FParentNode.GetNodeType = ntDocument) and (GetNodeType = ntElement);
end;

constructor TXMLNode.CreateHosted(HostNode: TXMLNode);
begin
  { First find the ultimate host node }
  while HostNode.HostNode <> nil do
    HostNode := HostNode.HostNode;
  Create(HostNode.DOMNode, HostNode.ParentNode, HostNode.OwnerDocument);
  FIsDocElement := False;
  FHostNode := HostNode;
  FHostNode.AddHostedNode(Self);
end;

destructor TXMLNode.Destroy;
var
  I: Integer;
begin
  inherited;
  if Assigned(FHostedNodes) then
  begin
    for I := 0 to Length(FHostedNodes) - 1 do
      FHostedNodes[I].FHostNode := nil;
    FHostedNodes := nil;
  end;
  if FHostNode <> nil then
    FHostNode.RemoveHostedNode(Self);
end;

function TXMLNode._AddRef: Integer;
begin
  Result := inherited _AddRef;
  { A reference to the document element will keep the document object alive.
    However, to avoid a circular reference, we ignore the first ref which is
    the one held by the nodelist of the document node. }
  if FIsDocElement and (Result > 1) and (FDocument <> nil) then
    FDocument._AddRef;
end;


function TXMLNode._Release: Integer;
begin
  Result := inherited _Release;
  if (Result > 0) and FIsDocElement and (FDocument <> nil) then
    FDocument._Release;
end;

procedure TXMLNode.ClearDocumentRef;
var
  I: Integer;
begin
  FDocument := nil;
  if Assigned(FChildNodes) then
    for I := 0 to FChildNodes.Count - 1 do
      (FChildNodes[I] as IXMLNodeAccess).ClearDocumentRef;
  if Assigned(FAttributeNodes) then
    for I := 0 to FAttributeNodes.Count - 1 do
      (FAttributeNodes[I] as IXMLNodeAccess).ClearDocumentRef;
end;

{ Attributes }

function TXMLNode.CreateAttributeList: IXMLNodeList;
var
  I: Integer;
  NodeList: TXMLNodeList;
begin
  NodeList := TXMLNodeList.Create(Self, '', AttributeListNotify);
  { Writing directly to the List property of the NodeList class below to
    avoid AttributeListNotify calls for improved performance }

  if Assigned(DOMNode.attributes) then
    for I := 0 to DOMNode.attributes.length - 1 do
      NodeList.List.Add(CreateAttributeNode(DOMNode.attributes[I]));

  Result := NodeList;
end;

function TXMLNode.GetAttributeNodes: IXMLNodeList;
begin
  if Assigned(HostNode) then
    Result := HostNode.GetAttributeNodes
  else
  begin
    if not Assigned(FAttributeNodes) then
      SetAttributeNodes(CreateAttributeList);
    Result := FAttributeNodes;
  end;
end;

procedure TXMLNode.SetAttributeNodes(const Value: IXMLNodeList);
var
  I: Integer;
begin
  if not Assigned(HostNode) then
  begin
    FAttributeNodes := Value;
    if Assigned(FHostedNodes) then
      for I := 0 to Length(FHostedNodes) - 1 do
        FHostedNodes[I].SetAttributeNodes(Value);
  end;
end;

function TXMLNode.HasAttribute(const Name: DOMString): Boolean;
begin
  if GetNodeType = ntElement then
    Result := DOMElement.hasAttribute(Name)
  else
    Result := GetAttributeNodes.IndexOf(Name) <> -1;
end;

function TXMLNode.HasAttribute(const Name, NamespaceURI: DOMString): Boolean;
begin
  if GetNodeType = ntElement then
    Result := DOMElement.hasAttributeNS(NamespaceURI, Name)
  else
    Result := GetAttributeNodes.IndexOf(Name, NamespaceURI) <> -1;
end;

function TXMLNode.CreateAttributeNode(const ADOMNode: IDOMNode): IXMLNode;
begin
  Result := TXMLNode.Create(ADOMNode, nil, OwnerDocument)
end;

function TXMLNode.GetAttribute(const AttrName: DOMString): OleVariant;
begin
  if hasAttribute(AttrName) then
  begin
    if GetNodeType = ntElement then
      Result := DOMElement.getAttribute(AttrName)
    else
      { For non-elements, we can still get the attribute another way }
      Result := AttributeNodes.FindNode(AttrName).NodeValue;
  end
  else if not Assigned(OwnerDocument) or (doAttrNull in OwnerDocument.Options) then
    Result := Null
  else
    Result := '';
end;

function TXMLNode.GetAttributeNS(const AttrName, NamespaceURI: DOMString): OleVariant;
begin
  if DOMElement.hasAttributeNS(NamespaceURI, AttrName) then
    Result := DOMElement.getAttributeNS(NamespaceURI, AttrName)
  else if not Assigned(OwnerDocument) or (doAttrNull in OwnerDocument.Options) then
    Result := Null
  else
    Result := '';
end;

procedure TXMLNode.SetAttribute(const AttrName: DOMString; const Value: OleVariant);
var
  ChangeType: TNodeChange;
  AttrNode: IDOMNode;
  NewValue: OleVariant;
begin
  ChangeType := AttrChangeTypeMap[VarIsNull(Value)];
  if UseXSDBooleanStrings and (ChangeType = ncAddAttribute) and
    (VarType(Value) = VT_BOOL) then
    NewValue := XSDBoolStrs[Boolean(Value)]
  else
    NewValue := Value;
  DoNodeChange(ChangeType, True);
  if (GetNodeType <> ntElement) and Assigned(DOMNode.Attributes) then
  begin
    { Some DOMs allow you to set attributes on things other than elements }
    if ChangeType = ncAddAttribute then
    begin
      AttrNode := OwnerDocument.DOMDocument.createAttribute(AttrName);
      AttrNode.nodeValue := NewValue;
      DOMNode.Attributes.setNamedItem(AttrNode)
    end else
      DOMNode.attributes.removeNamedItem(AttrName);
  end
  else
  begin
    if ChangeType = ncAddAttribute then
      DOMElement.setAttribute(AttrName, NewValue) else
      DOMElement.removeAttribute(AttrName);
  end;
  { If an attribute was added or removed, then force the list to be reloaded }
  SetAttributeNodes(nil);
  DoNodeChange(ChangeType, False);
end;

procedure TXMLNode.SetAttributeNS(const AttrName, NamespaceURI: DOMString;
  const Value: OleVariant);
var
  NodeName: WideString;
  ChangeType: TNodeChange;
begin
{ This method uses an explicit namespaceURI. }
  NodeName := GetPrefixedName(AttrName, NamespaceURI);
  ChangeType := AttrChangeTypeMap[VarIsNull(Value)];
  DoNodeChange(ChangeType, True);
  if ChangeType = ncAddAttribute then
  begin
    if UseXSDBooleanStrings and (VarType(Value) = VT_BOOL) then
      DOMElement.setAttributeNS(NamespaceURI, NodeName, XSDBoolStrs[Boolean(Value)])
    else
      DOMElement.setAttributeNS(NamespaceURI, NodeName, Value)
  end
  else
    DOMElement.removeAttributeNS(NamespaceURI, NodeName);
  SetAttributeNodes(nil);
  DoNodeChange(ChangeType, False);
end;

procedure TXMLNode.AttributeListNotify(Operation: TNodeListOperation;
  var Node: IXMLNode; const IndexOrName: OleVariant; BeforeOperation: Boolean);
const
  NodeChangeMap: array[TNodeListOperation] of TNodeChange = (ncAddAttribute,
    ncRemoveAttribute, ncAddAttribute);
var
  I: Integer;
  HostedNode: TXMLNode;
begin
  DoNodeChange(NodeChangeMap[Operation], BeforeOperation);
  if BeforeOperation and (AttributeNodes.UpdateCount = 0) then
    case Operation of
      nlRemove: DOMElement.removeAttributeNode(Node.DOMNode as IDOMAttr);
      nlInsert: DOMElement.setAttributeNode(Node.DOMNode as IDOMAttr);
      nlCreateNode:
        begin
          Node := OwnerDocument.CreateNode(IndexOrName, ntAttribute);
          AttributeNodes.Add(Node);
        end;
    end;
  if Assigned(FHostedNodes) then
    for I := 0 to Length(FHostedNodes) - 1 do
    begin
      HostedNode := FHostedNodes[I];
      if Assigned(HostedNode.OnHostAttrNotify) then
          HostedNode.OnHostAttrNotify(Operation, Node, IndexOrName, BeforeOperation);
    end;
end;

{ ChildNode List Management }

function TXMLNode.CreateChildList: IXMLNodeList;
var
  I: Integer;
  NodeList: TXMLNodeList;
begin
  NodeList := TXMLNodeList.Create(Self, GetNamespaceURI, ChildListNotify);
  { Writing directly to the List property of the NodeList class below to
    avoid ChildListNotify calls for improved performance }
  for I := 0 to DOMNode.childNodes.length - 1 do
    NodeList.List.Add(CreateChildNode(DOMNode.childNodes[I]));
  Result := NodeList;
end;

function TXMLNode.GetHasChildNodes: Boolean;
begin
  Result := DOMNode.hasChildNodes;
end;

function TXMLNode.GetChildNodes: IXMLNodeList;
begin
  if Assigned(HostNode) then
    Result := HostNode.GetChildNodes
  else
  begin
    if not Assigned(FChildNodes) then
      SetChildNodes(CreateChildList);
    Result := FChildNodes;
  end;
end;

procedure TXMLNode.SetChildNodes(const Value: IXMLNodeList);
var
  I: Integer;
begin
  if not Assigned(HostNode) then
  begin
    FChildNodes := Value;
    if Assigned(FHostedNodes) then
      for I := 0 to Length(FHostedNodes) - 1 do
        FHostedNodes[I].SetChildNodes(Value);
  end;
end;

function TXMLNode.HasChildNode(const ChildTag: DOMString): Boolean;
begin
  Result := HasChildNode(ChildTag, GetNamespaceURI);
end;

function TXMLNode.HasChildNode(const ChildTag, NamespaceURI: DOMString): Boolean;
var
  I: Integer;
begin
  { This routine uses the DOMNode to avoid creating the childnodes list if
    there are no children }
  Result := False;
  for I := 0 to DOMNode.childnodes.length - 1 do
    if NodeMatches(DOMNode.childNodes[I], ChildTag, NamespaceURI) then
    begin
      Result := True;
      Break;
    end;
end;

function TXMLNode.AddChild(const TagName: DOMString; Index: Integer = -1): IXMLNode;
var
  NodeName, NamespaceURI: WideString;
begin
{ This method assumes we should use the same namespace as the parent node.
  If a different namespace is needed then use the overloaded version with
  a namespace parameter.  If the TagName includes a prefix then the
  existing namespace for that prefix will be used.  Otherwise, if there is
  a prefix associated with this node it will be used automatically. }
  if IsPrefixed(TagName) then
  begin
    NodeName := TagName;
    NamespaceURI := FindNamespaceURI(TagName);
  end else
  begin
    NodeName := MakeNodeName(GetPrefix, TagName);
    NamespaceURI := GetNamespaceURI;
  end;
  Result := InternalAddChild(nil, NodeName, NamespaceURI, Index);
end;

function TXMLNode.AddChild(const TagName, NamespaceURI: DOMString;
  GenPrefix: Boolean = False; Index: Integer = -1): IXMLNode;
var
  NSDecl: IXMLNode;
  NodeName, Prefix: WideString;
begin
{ This method uses an explicit namespaceURI. }
  NodeName := TagName;
  NSDecl := FindNamespaceDecl(NamespaceURI);
  if Assigned(NSDecl) then
    NodeName := GetPrefixedName(TagName, NamespaceURI)
  else
  begin
    { No existing Namespace was found }
    if not IsPrefixed(TagName) then
    begin
      { User requests a new unique prefix be created automaticaly }
      if GenPrefix then
      begin
        Prefix := OwnerDocument.GeneratePrefix(Self);
        NodeName :=  MakeNodeName(Prefix, NodeName);
      end
    end else
      { Use the prefix from the passed TagName }
      Prefix := ExtractPrefix(TagName);
  end;
  Result := InternalAddChild(nil, NodeName, NamespaceURI, Index);
  { Automatically declare the namespace once the node is created }
  if not Assigned(NSDecl) and Assigned(OwnerDocument) and
     (NamespaceURI <> '') and (doNamespaceDecl in OwnerDocument.Options) then
    Result.DeclareNamespace(Prefix, NamespaceURI);
end;

function TXMLNode.AddChild(const TagName, NamespaceURI: DOMString;
  NodeClass: TXMLNodeClass; Index: Integer = -1): IXMLNode;
begin
  { This method uses an explicit node class, but doesn't do any special
    processing of the namespace information.  It not part of IXMLNode. }
  Result := InternalAddChild(NodeClass, TagName,
    NamespaceURI, Index);
end;

function TXMLNode.CreateCollection(const CollectionClass: TXMLNodeCollectionClass;
  const ItemInterface: TGuid; const ItemTag: DOMString;
  ItemNS: DOMString = ''): TXMLNodeCollection;
begin
  { This function creates a hosted collection node }
  Result := CollectionClass.CreateHosted(Self);
  if ItemNS = '' then
    ItemNS := GetNamespaceURI;
  Result.ItemInterface := ItemInterface;
  Result.ItemTag := ItemTag;
  Result.ItemNS := ItemNS;
  if Assigned(FChildNodes) then
    Result.SetChildNodes(FChildNodes);
end;

procedure TXMLNode.ChildListNotify(Operation: TNodeListOperation;
      var Node: IXMLNode; const IndexOrName: OleVariant; BeforeOperation: Boolean);
const
  NodeChangeMap: array[TNodeListOperation] of TNodeChange = (ncInsertChild,
    ncRemoveChild, ncInsertChild);
var
  I: Integer;
  HostedNode: TXMLNode;
begin
  DoNodeChange(NodeChangeMap[Operation], BeforeOperation);
  if BeforeOperation and (ChildNodes.UpdateCount = 0) then
  begin
    case Operation of
      nlRemove:
        begin
          DOMNode.removeChild(Node.DOMNode);
          (Node as IXMLNodeAccess).SetParentNode(nil);
        end;
      nlInsert:
        begin
          Assert(DOMNode.childNodes.length = FChildNodes.Count);
          if LongWord(IndexOrName) >= LongWord(DOMNode.ChildNodes.length) then
            DOMNode.appendChild(Node.DOMNode)
          else
            DOMNode.insertBefore(Node.DOMNode, DOMNode.childNodes[IndexOrName]);
          (Node as IXMLNodeAccess).SetParentNode(Self);
        end;
      nlCreateNode:
        Node := AddChild(DOMString(IndexOrName));
    end;
  end;
  if Assigned(FHostedNodes) then
    for I := 0 to Length(FHostedNodes) - 1 do
    begin
      HostedNode := FHostedNodes[I];
      if Assigned(HostedNode.OnHostChildNotify) then
          HostedNode.OnHostChildNotify(Operation, Node, IndexOrName, BeforeOperation);
    end;
end;

{ ChildNode Creation & Registration }

function TXMLNode.CreateChildNode(const ADOMNode: IDOMNode): IXMLNode;
var
  I: Integer;
  ChildNodeClass: TXMLNodeClass;
begin
  if Assigned(HostNode) then
    Result := HostNode.CreateChildNode(ADOMNode)
  else
  begin
    ChildNodeClass := OwnerDocument.GetChildNodeClass(ADOMNode);
    if ChildNodeClass = nil then
    begin
      ChildNodeClass := TXMLNode;
      for I := 0 to Length(ChildNodeClasses) - 1 do
        with ChildNodeClasses[I] do
          if NodeMatches(ADOMNode, NodeName, NamespaceURI) then
          begin
            ChildNodeClass := NodeClass;
            Break;
           end;
    end;
    Result := ChildNodeClass.Create(ADOMNode, Self, OwnerDocument);
  end;
end;

procedure TXMLNode.RegisterChildNode(const TagName: DOMString;
  ChildNodeClass: TXMLNodeClass; NamespaceURI: DOMString = '');
begin
  if Assigned(HostNode) then
    HostNode.RegisterChildNode(TagName, ChildNodeClass, NamespaceURI)
  else
  begin
    if NamespaceURI = '' then
      NamespaceURI := Self.GetNamespaceURI;
    AddNodeClassInfo(FChildNodeClasses, ChildNodeClass, TagName, NamespaceURI);
    FChildNodes := nil;
  end;
end;

function TXMLNode.InternalAddChild(NodeClass: TXMLNodeClass;
  const NodeName, NamespaceURI: DOMString; Index: Integer): IXMLNode;
var
  DOMDoc: IDOMDocument;
  NewNode: IDOMNode;
begin
  { Special handling for when we are the TXMLNode of the DOMDocument }
  if GetNodeType = ntDocument then
    DOMDoc := DOMNode as IDOMDocument else
    DOMDoc := DOMNode.ownerDocument;
  NewNode := CreateDOMNode(DOMDoc, NodeName, ntElement, NamespaceURI);
  if not Assigned(NodeClass) then
    Result := CreateChildNode(NewNode) else
    Result := NodeClass.Create(NewNode, Self, OwnerDocument);
  ChildNodes.Insert(Index, Result);
end;

{ Namespace support }

function TXMLNode.FindNamespaceURI(const TagOrPrefix: DOMString): DOMString;
var
  I: Integer;
  Node: TXMLNode;
  Prefix: DOMString;
begin
  Result := '';
  if IsPrefixed(TagOrPrefix) then
    Prefix := ExtractPrefix(TagOrPrefix) else
    Prefix := TagOrPrefix;
  Node := Self;
  while (Result = '') and Assigned(Node) do
  begin
    for I := 0 to Node.AttributeNodes.Count - 1 do
      if (Node.AttributeNodes[I].Prefix = SXMLNS) and
        (Prefix = ExtractLocalName(Node.AttributeNodes[I].NodeName)) then
      begin
        Result := Node.AttributeNodes[I].NodeValue;
        Break;
      end;
    Node := Node.FParentNode;
  end;
end;

function TXMLNode.FindNamespaceDecl(const NamespaceURI: DOMString): IXMLNode;
var
  I: Integer;
  Attr: IXMLNode;
begin
  Result := nil;
  for I := 0 to AttributeNodes.Count - 1 do
  begin
    Attr := AttributeNodes[I];
    if SameNamespace(VarToStr(Attr.NodeValue), NamespaceURI) and
       ((Attr.Prefix = SXMLNS) or (Attr.NodeName = SXMLNS)) then
    begin
      Result := AttributeNodes[I];
      Break;
    end;
  end;
  if (Result = nil) and Assigned(FParentNode) then
    Result := FParentNode.FindNamespaceDecl(NamespaceURI);
end;

procedure TXMLNode.DeclareNamespace(const Prefix, URI: DOMString);
begin
  if Prefix <> '' then
    SetAttributeNS(SXMLNS+NSDelim+Prefix, SXMLNamespaceURI, URI) else
    SetAttributeNS(SXMLNS, SXMLNamespaceURI, URI);
end;

function TXMLNode.GetPrefixedName(const Name, NamespaceURI: DOMString): DOMString;
var
  NSDecl: IXMLNode;
begin
  { The method adds a prefix to a localname based on the specified URI.
    If there is no corresponding namespace already declared or if
    the name is already prefixed, then nothing is done. }
  if (doAutoPrefix in OwnerDocument.Options) and not IsPrefixed(Name) then
  begin
    NSDecl := FindNamespaceDecl(NamespaceURI);
    if Assigned(NSDecl) and (NSDecl.NodeName <> SXMLNS) then
      Result := MakeNodeName(NSDecl.LocalName, Name)
    else
      Result := Name;
  end else
    Result := Name;
end;

{ Other IXMLNode Methods }

function TXMLNode.CloneNode(Deep: Boolean): IXMLNode;
begin
  Result := TXMLNodeClass(ClassType).Create(DOMNode.cloneNode(Deep), nil, OwnerDocument);
end;

procedure TXMLNode.Resync;
begin
  { Force all child nodes to be re-read from the DOM }
  SetAttributeNodes(nil);
  SetChildNodes(nil);
end;

function TXMLNode.FindHostedNode(const NodeClass: TXMLNodeClass): IXMLNode;
var
  I: Integer;
begin
  Result := nil;
  if Assigned(FHostedNodes) then
    for I := 0 to Length(FHostedNodes) - 1 do
      if FHostedNodes[I] is NodeClass then
      begin
        Result := FHostedNodes[I];
        Break;
      end;
end;

procedure TXMLNode.AddHostedNode(Node: TXMLNode);
begin
  SetLength(FHostedNodes, Length(FHostedNodes)+1);
  FHostedNodes[High(FHostedNodes)] := Node;
end;

procedure TXMLNode.RemoveHostedNode(Node: TXMLNode);
var
  Count, I, J: Integer;
begin
  Count := Length(FHostedNodes);
  for I := 0 to Count - 1 do
  begin
    if FHostedNodes[I] = Node then
    begin
      for J := I to Count - 2 do
        FHostedNodes[J] := FHostedNodes[J+1];
      SetLength(FHostedNodes, Count-1);
      Break;
    end;
  end;
end;


function TXMLNode.NextSibling: IXMLNode;
begin
  if Assigned(ParentNode) then
    Result := ParentNode.ChildNodes.FindSibling(Self as IXMLNode, 1) else
    Result := nil;
end;

function TXMLNode.PreviousSibling: IXMLNode;
begin
  if Assigned(ParentNode) then
    Result := ParentNode.ChildNodes.FindSibling(Self as IXMLNode, -1) else
    Result := nil;
end;

procedure TXMLNode.TransformNode(const stylesheet: IXMLNode;
  var output: WideString);
begin
  GetDOMNodeEx(DOMNode).transformNode(stylesheet.DOMNode, output);
end;

procedure TXMLNode.TransformNode(const stylesheet: IXMLNode;
  const output: IXMLDocument);
begin
  GetDOMNodeEx(DOMNode).transformNode(stylesheet.DOMNode, output.DOMDocument);
end;

procedure TXMLNode.CheckNotHosted;
begin
  if Assigned(HostNode) then
    XMLDocError(SNotOnHostedNode);
end;

function TXMLNode.NestingLevel: Integer;
var
  PNode: IXMLNode;
begin
  Result := 0;
  PNode := ParentNode;
  while PNode <> nil do
  begin
    Inc(Result);
    PNode := PNode.ParentNode;
  end;
end;

procedure TXMLNode.Normalize;
begin
  DOMNode.normalize;
  SetChildNodes(nil);
end;

{ Node Data Access }

procedure TXMLNode.CheckReadOnly;
begin
  if FReadOnly then
    XMLDocError(SNodeReadOnly);
end;

procedure TXMLNode.CheckTextNode;
begin
  { Create the actual text node when none already exists }
  if not DOMNode.hasChildNodes then
  begin
    DOMNode.appendChild(DOMNode.ownerDocument.createTextNode(''));
    SetChildNodes(nil);
  end
  else if (DOMNode.childNodes.length > 1) or
    not (DOMNode.childNodes[0].nodeType in [TEXT_NODE, CDATA_SECTION_NODE]) then
    XMLDocError(SNotSingleTextNode, [DOMNode.nodeName]);
end;

function TXMLNode.GetText: DOMString;
begin
  if GetNodeType = ntElement then
  begin
    CheckTextNode;
    Result := DOMNode.childNodes[0].nodeValue;
  end else
    Result := DOMNode.nodeValue;
end;

procedure TXMLNode.SetText(const Value: DOMString);
begin
  DoNodeChange(ncUpdateValue, True);
  if GetNodeType = ntElement then
  begin
    CheckTextNode;
    DOMNode.childNodes[0].nodeValue := Value;
  end else
    DOMNode.nodeValue := Value;
  DoNodeChange(ncUpdateValue, False);
end;

function TXMLNode.GetNodeValue: OleVariant;
begin
  Result := GetText;
  if Result = '' then
    Result := Null;
end;

procedure TXMLNode.SetNodeValue(const Value: OleVariant);
begin
  // The Variant conversion of boolean to strings is not W3C XML Schema boolean type compatible
  //  so we have to manually override it here.
  if UseXSDBooleanStrings and (VarType(Value) = VT_BOOL) then
    SetText(XSDBoolStrs[Boolean(Value)])
  else
    SetText(VarToWideStr(Value));
end;

function TXMLNode.GetChildValue(const IndexOrName: OleVariant): OleVariant;
var
  Node: IXMLNode;
begin
  Node := ChildNodes.FindNode(DOMString(IndexOrName));
  if Assigned(Node) then
    Result := Node.NodeValue else
    Result := Null;
end;

procedure TXMLNode.SetChildValue(const IndexOrName, Value: OleVariant);
begin
  ChildNodes[IndexOrName].NodeValue := Value;
end;

function TXMLNode.GetXML: DOMString;
begin
  Result := GetDOMNodeEx(DOMNode).get_xml;
end;

{ Other Node Props }

function TXMLNode.GetDOMNode: IDOMNode;
begin
  Result := FDOMNode;
end;

function TXMLNode.DOMElement: IDOMElement;
begin
  if GetNodeType <> ntElement then
    XMLDocError(SNoAttributes);
  Result := DOMNode as IDOMElement;
end;

function TXMLNode.GetNodeType: TNodeType;
begin
  Result := TNodeType(Byte(DOMNode.NodeType));
end;

function TXMLNode.GetLocalName: DOMString;
begin
  Result := DOMNode.LocalName;
end;

function TXMLNode.GetNamespaceURI: DOMString;
begin
  Result := DOMNode.get_namespaceURI;
end;

function TXMLNode.GetNodeName: DOMString;
begin
  Result := DOMNode.nodeName;
end;

function TXMLNode.GetPrefix: DOMString;
begin
  Result := DOMNode.prefix;
end;

function TXMLNode.GetIsTextElement: Boolean;
begin
  Result := (GetNodeType = ntElement) and (DOMNode.childNodes.length = 1) and
     (DOMNode.childNodes[0].nodeType = TEXT_NODE);
end;

function TXMLNode.GetOwnerDocument: IXMLDocument;
begin
  if Assigned(FDocument) then
    FDocument.GetInterface(IXMLDocument, Result);
end;

function TXMLNode.GetCollection: IXMLNodeCollection;
begin
  Result := FCollection;
end;

function TXMLNode.GetParentNode: IXMLNode;
begin
  Result := FParentNode;
end;

function TXMLNode.GetChildNodeClasses: TNodeClassArray;
begin
  if Assigned(HostNode) then
    Result := HostNode.GetChildNodeClasses
  else
    Result := FChildNodeClasses;
end;

function TXMLNode.GetHostedNodes: TXMLNodeArray;
begin
  Result := FHostedNodes;
end;

function TXMLNode.GetHostNode: TXMLNode;
begin
  Result := FHostNode;
end;

function TXMLNode.GetNodeObject: TXMLNode;
begin
  Result := Self;
end;

procedure TXMLNode.SetCollection(const Value: TXMLNodeCollection);
begin
  FCollection := Value;
end;

procedure TXMLNode.SetParentNode(const Value: TXMLNode);
var
  RefCountSave: Integer;
begin
  FParentNode := Value;
  if Assigned(Value) and (FDocument <> Value.FDocument) then
  begin
    { Before switching documents need to adjust the refcount }
    RefCountSave := FRefCount;
    while FRefCount > 1 do
      _Release;
    FDocument := Value.FDocument;
    while FRefCount < RefCountSave do
      _AddRef;
  end;
end;

function TXMLNode.GetReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TXMLNode.SetReadOnly(const Value: Boolean);
begin
  FReadOnly := Value;
end;

{ Event Helpers }

procedure TXMLNode.DoNodeChange(ChangeType: TNodeChange; BeforeOperation: Boolean);
begin
  if Assigned(OwnerDocument) then
    OwnerDocument.DoNodeChange(Self, ChangeType, BeforeOperation);
  if BeforeOperation then
    CheckReadOnly;
end;

procedure TXMLNode.RegisterChildNodes(const TagNames: array of DOMString;
  const NodeClasses: array of TXMLNodeClass);
var
  I: Integer;
begin
  if High(TagNames) <> High(NodeClasses) then
    XMLDocError(SMismatchedRegItems);
  { This method assumes the current node's NamespaceURI is to be used }
  for I := Low(TagNames) to High(TagNames) do
    RegisterChildNode(TagNames[I], NodeClasses[I], GetNamespaceURI);
end;

{ TXMLNodeCollection }

procedure TXMLNodeCollection.AfterConstruction;
begin
  OnHostChildNotify := UpdateCollectionList;
  ItemNS := GetNamespaceURI;
  inherited;
end;

{ Collection List Management }

function TXMLNodeCollection.GetList: IXMLNodeList;
begin
  if not Assigned(FList) then
    GetChildNodes;
  Assert(Assigned(FList));
  Result := FList;
end;

procedure TXMLNodeCollection.SetChildNodes(const Value: IXMLNodeList);
begin
  inherited;
  FList := Value;
  CreateItemList(True);
end;

procedure TXMLNodeCollection.CreateItemList(CheckFirst: Boolean = False);
var
  I: Integer;
  DoCreate: Boolean;
begin
  if CheckFirst then
  begin
    DoCreate := False;
    for I := 0 to ChildNodes.Count - 1 do
      if not IsCollectionItem(ChildNodes[I]) then
      begin
        DoCreate := True;
        Break;
      end else
        (ChildNodes[I] as IXMLNodeAccess).SetCollection(Self);
    if not DoCreate then Exit;
  end;
  FList := TXMLNodeList.Create(Self, FItemNS, nil);
  for I := 0 to ChildNodes.Count - 1 do
    if IsCollectionItem(ChildNodes[I]) then
    begin
      (ChildNodes[I] as IXMLNodeAccess).SetCollection(Self);
      FList.Add(ChildNodes[I]);
    end;
end;

function TXMLNodeCollection.IsCollectionItem(const Node: IXMLNode): Boolean;
var
  I: Integer;
  LocalName: DOMString;
  FItemTags: TWideStringDynArray;
begin
  Result := False;
  if Supports(Node, ItemInterface) then
  begin
    LocalName := ExtractLocalName(Node.NodeName);
    Result := (LocalName = FItemTag);
    // If FItemTag has semicolons in it, then there are multiple valid names and we must check each one
    if not Result and (Pos(';', FItemTag) > 0) then
    begin
      FItemTags := SplitString(FItemTag, ';', [ssRemoveEmptyEntries]);
      for I := Low(FItemTags) to High(FItemTags) do
        if LocalName = FItemTags[I] then
        begin
          Result := True;
          Break;
        end;
    end;
  end;
end;

procedure TXMLNodeCollection.InsertInCollection(Node: IXMLNode; Index: Integer);
var
  I: Integer;
begin
  if IsCollectionItem(Node) then
  begin
    (Node as IXMLNodeAccess).SetCollection(Self);
    { If the child node list contains only collection items, then there is
      no separate list of collection items so we have nothing further to do.
      However, if there are non-collection items in the child nodes, we need
      to insert this node into the the collection item list. }
    if List <> ChildNodes then
    begin
      if LongWord(Index) >= LongWord(List.Count) then
        List.Add(Node)
      else
      begin
        { Determine where to insert into the collection list }
        if Index > 0 then
          for I := Index + 1 to ChildNodes.Count - 1 do
             if IsCollectionItem(ChildNodes[I]) then
             begin
               Index := List.IndexOf(ChildNodes[I]);
               Break;
             end;
        List.Insert(Index, Node);
      end;
    end;
  end
  { If the node being added is not a collection item, then we need to create
    the separate list of just collection items at this point. }
  else if List = ChildNodes then
    CreateItemList;
end;

procedure TXMLNodeCollection.ChildListNotify(Operation: TNodeListOperation;
  var Node: IXMLNode; const IndexOrName: OleVariant; BeforeOperation: Boolean);
begin
  inherited;
  UpdateCollectionList(Operation, Node, IndexOrName, BeforeOperation);
end;

procedure TXMLNodeCollection.UpdateCollectionList(Operation: TNodeListOperation;
  var Node: IXMLNode; const IndexOrName: OleVariant; BeforeOperation: Boolean);
begin
  if BeforeOperation then
    CheckReadOnly
  else
    case Operation of
      nlRemove:
        { If we have a separate collection item list,
          then remove this node from it as well. }
        if (List <> ChildNodes) then
           List.Remove(Node);
      nlInsert:
        InsertInCollection(Node, Integer(IndexOrName));
    end;
end;

{ IXMLNodeCollection Methods and Property Accessors }

function TXMLNodeCollection.AddItem(Index: Integer): IXMLNode;
begin
  if ItemTag = '' then
    XMLDocError(SMissingItemTag);
  Result := AddChild(ItemTag, ItemNS, False, Index);
end;

procedure TXMLNodeCollection.Delete(Index: Integer);
begin
  Remove(List[Index] as IXMLNode);
end;

function TXMLNodeCollection.Remove(const AItem: IXMLNode): Integer;
begin
  Result := List.IndexOf(AItem);
  Assert(Result >=0);
  ChildNodes.Remove(AItem);
end;

procedure TXMLNodeCollection.Clear;
begin
  while List.Count > 0 do
    Remove(GetNode(0));
end;

function TXMLNodeCollection.GetCount: Integer;
begin
  Result := List.Count;
end;

function TXMLNodeCollection.GetNode(Index: Integer): IXMLNode;
begin
  Result := List[Index] as IXMLNode;
end;

{ TXMLDocument }

constructor TXMLDocument.Create(AOwner: TComponent);
begin
  { Need to have this to make this constructor visible to C++ classes }
  inherited;
end;

constructor TXMLDocument.Create(const AFileName: DOMString);
begin
  inherited Create(nil);
  FFileName := AFileName;
end;

destructor TXMLDocument.Destroy;
begin
  Destroying;
  if FOwnerIsComponent and Active and Assigned(FDocumentNode) and (FRefCount > 1) then
    (FDocumentNode as IXMLNodeAccess).ClearDocumentRef;
  SetActive(False);
  FreeAndNil(FXMLStrings);
  inherited;
end;

class function TXMLDocument.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TXMLDocument(Result).FRefCount := 1;
end;

procedure TXMLDocument.AfterConstruction;
begin
  inherited;
  if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
    DOMVendor := GetDOMVendor(DefaultDOMVendor);
  FOptions := [doNodeAutoCreate, doAttrNull, doAutoPrefix, doNamespaceDecl];
  NSPrefixBase := 'NS';
  NodeIndentStr := DefaultNodeIndent;
  FOwnerIsComponent := Assigned(Owner) and (Owner is TComponent);
  FXMLStrings := TStringList.Create;
  FXMLStrings.OnChanging := XMLStringsChanging;
  if FFileName <> '' then
    SetActive(True);
  InterlockedDecrement(FRefCount);
end;

{ IInterface }

function TXMLDocument._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount)
end;

function TXMLDocument._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  { If we are not being used as a TComponent, then use refcount to manage our
    lifetime as with TInterfacedObject. }
  if (Result = 0) and not FOwnerIsComponent then
    Destroy;
end;

{ Streaming }

procedure TXMLDocument.Loaded;
begin
  inherited;
  try
    if FStreamedActive then SetActive(True);
  except
    if csDesigning in ComponentState then
      if Assigned(Classes.ApplicationHandleException) then
        Classes.ApplicationHandleException(ExceptObject)
      else
        ShowException(ExceptObject, ExceptAddr)
    else
      raise;
  end;
end;

procedure TXMLDocument.ReadDOMVendor(Reader: TReader);
var
  DOMVendorDesc: string;
begin
  DOMVendorDesc := Reader.ReadString;
  if DOMVendorDesc <> '' then
  try
    DOMVendor := GetDOMVendor(DOMVendorDesc);
  except
    if csDesigning in ComponentState then
      if Assigned(Classes.ApplicationHandleException) then
        Classes.ApplicationHandleException(ExceptObject)
      else
        ShowException(ExceptObject, ExceptAddr)
    else
      raise;
  end;
end;

procedure TXMLDocument.WriteDOMVendor(Writer: TWriter);
begin
  if Assigned(DOMVendor) then
    Writer.WriteString(DOMVendor.Description);
end;

procedure TXMLDocument.DefineProperties(Filer: TFiler);

  function DOMVendorStored: Boolean;
  begin
    if Assigned(Filer.Ancestor) then
      Result := DOMVendor <> TXMLDocument(Filer.Ancestor).DOMVendor else
      Result := Assigned(DOMVendor);
  end;

begin
  inherited;
  Filer.DefineProperty('DOMVendorDesc', ReadDOMVendor, { Do not localize }
    WriteDOMVendor, DOMVendorStored);
end;

function TXMLDocument.IsXMLStored: Boolean;
begin
  Result := (Active and (DocSource = xdsXMLProperty)) or
	    ((not Active) and (FXMLStrings.Count > 0));
end;

function TXMLDocument.NodeIndentStored: Boolean;
begin
  Result := NodeIndentStr <> DefaultNodeIndent;
end;

{ Activation }

function TXMLDocument.GetActive: Boolean;
begin
  Result := Assigned(FDOMDocument);
end;

procedure TXMLDocument.SetActive(const Value: Boolean);
begin
  if (csReading in ComponentState) then
  begin
    FStreamedActive := Value;
  end
  else if Value <> GetActive then
  begin
    if Value then
    begin
      DoBeforeOpen;
      CheckDOM;
      FDOMDocument := DOMImplementation.createDocument('', '', nil);
      try
        LoadData;
      except
        ReleaseDoc(False);
        raise;
      end;
      DoAfterOpen;
    end
    else
    begin
      DoBeforeClose;
      ReleaseDoc;
      DoAfterClose;
    end;
  end;
end;

procedure TXMLDocument.LoadData;
const
  UnicodeEncodings: array[0..2] of string = ('UTF-16', 'UCS-2', 'UNICODE');
var
  Status: Boolean;
  ParseError: IDOMParseError;
  StringStream: TStringStream;
  Msg: string;
begin
  { Data loading precedence:
     - XML Property (FXMLStrings)
     - LoadFromStream/LoadFromXML (FXMLData)
     - FileName Property/LoadFromFile (FFileName)
  }
  DocSource := xdsNone;
  FXMLStrRead := -1;
  AssignParseOptions;
  if (FXMLStrings.Count > 0) then
  begin
    StringStream := TStringStream.Create(FXMLStrings.Text);
    try
      Status := DOMPersist.loadFromStream(StringStream);
    finally
      StringStream.Free;
    end;
    DocSource := xdsXMLProperty;
    FXMLStrRead := 0;
  end
  else if FXMLData <> '' then
  begin
    CheckEncoding(FXMLData, UnicodeEncodings);
    { Strip encoding flag word if present }
    if Word(FXMLData[1]) = $FEFF then
      System.Delete(FXMLData, 1, 1);
    Status := DOMPersist.loadxml(FXMLData);
    FXMLData := '';
    if DocSource = xdsNone then
      DocSource := xdsXMLData;
  end
  else if Assigned(FSrcStream) then
  begin
    FSrcStream.Seek(0, 0);
    Status := DOMPersist.loadFromStream(FSrcStream);
    DocSource := xdsStream;
    FSrcStream := nil;
  end
  else if FFileName <> '' then
  begin
    Status := DOMPersist.load(FFileName);
    DocSource := xdsFile;
  end
  else
    Status := True; { No load, just create empty doc. }
  if not Status then
  begin
    DocSource := xdsNone;
    ParseError := DOMDocument as IDOMParseError;
    with ParseError do
      Msg := Format('%s%s%s: %d%s%s', [Reason, SLineBreak, SLine,
        Line, SLineBreak, Copy(SrcText, 1, 40)]);
    raise EDOMParseError.Create(ParseError, Msg);
  end;
  SetModified(False);
end;

procedure TXMLDocument.ReleaseDoc(const CheckSave: Boolean = True);
begin
  if CheckSave then
    CheckAutoSave;
  FDocumentNode := nil;
  FDOMPersist := nil;
  FDOMDocument := nil;
  FDOMParseOptions := nil;
  FPrefixID := 0;
  SetModified(False);
  if not (DocSource in [xdsNone, xdsXMLProperty]) then
    SetXMLStrings('');
end;

procedure TXMLDocument.Refresh;
begin
  CheckActive;
  ReleaseDoc(False);
  if not (DocSource in [xdsXMLProperty, xdsFile]) then
    XMLDocError(SNoRefresh);
  LoadData;
end;

procedure TXMLDocument.Resync;
begin
  CheckActive;
  FDocumentNode := nil;
end;

{ Persistence }

procedure TXMLDocument.LoadFromFile(const AFileName: DOMString = '');
begin
  SetActive(False);
  if AFileName <> '' then
    FileName := AFileName;
  if FileName = '' then
    XMLDocError(SMissingFileName);
  FXMLData := '';
  SetXMLStrings('');
  SetActive(True);
end;

procedure TXMLDocument.SaveToFile(const AFileName: DOMString = '');
begin
  CheckActive;
  if AFileName = '' then
    DOMPersist.save(FFileName) else
    DOMPersist.save(AFileName);
  SetModified(False);
end;

procedure TXMLDocument.XMLStringsChanging(Sender: TObject);
begin
  if not (csLoading in ComponentState) and Active then
    SetActive(False);
  FFileName := '';
end;

procedure TXMLDocument.SetXMLStrings(const Value: string);
begin
  { Unhook the OnChanging event so we don't close the doc when refreshing }
  FXMLStrings.OnChanging := nil;
  try
    FXMLStrings.Text := Value;
  finally
    FXMLStrings.OnChanging := XMLStringsChanging;
  end;
end;

procedure TXMLDocument.SaveToXMLStrings;
var
  XMLData: string;
begin
  if FXMLStrRead <> FModified then
  begin
    SaveToXML(XMLData);
    SetXMLStrings(XMLData);
    FXMLStrRead := FModified;
  end;
end;

function TXMLDocument.GetXML: TStrings;
begin
  { When active, make sure the string list is up to date with what is in the DOM }
  if Active then
    SaveToXMLStrings;
  Result := FXMLStrings;
end;

procedure TXMLDocument.SetXML(const Value: TStrings);
begin
  FXMLStrings.Assign(Value);
end;

procedure TXMLDocument.LoadFromStream(const Stream: TStream;
  EncodingType: TXMLEncodingType = xetUnknown);
begin
  SetActive(False);
  SetXMLStrings('');
  FXMLData := '';
  FSrcStream := Stream;
  SetActive(True);
end;

procedure TXMLDocument.SaveToStream(const Stream: TStream);
begin
  CheckActive;
  DomPersist.saveToStream(Stream);
end;

procedure TXMLDocument.LoadFromXML(const XML: DOMString);
begin
  SetActive(False);
  SetXMLStrings('');
  FXMLData := XML;
  SetActive(True);
end;

procedure TXMLDocument.LoadFromXML(const XML: string);
var
  StringStream: TStringSTream;
begin
  StringStream := TStringStream.Create(XML);
  try
    LoadFromStream(StringStream);
  finally
    StringStream.Free;
  end;
end;

procedure TXMLDocument.SaveToXML(var XML: DOMString);
begin
  CheckActive;
  XML := DOMPersist.xml;
end;

procedure TXMLDocument.SaveToUTF8String(var XML: string);
var
  UnicodeXML: DOMString;
  PrologNode: IXMLNode;
  PrologAttrs, PrologNodeStr: string;
  PrologInfo: IDOMXMLProlog;
begin
  SaveToXML(UnicodeXML);
  XML := UTF8Encode(UnicodeXML);
  if GetDOMDocument.QueryInterface(IDOMXMLProlog, PrologInfo) = S_OK then
  begin
    AppendItem(PrologAttrs, SVersion, PrologInfo.Version);
    AppendItem(PrologAttrs, SStandalone, PrologInfo.StandAlone);
    AppendItem(PrologAttrs, SEncoding, 'UTF-8');
  end
  else
  begin
    PrologNode := GetPrologNode;
    PrologAttrs := InternalSetPrologValue(PrologNode, 'UTF-8', xpEncoding);
  end;
  PrologNodeStr := '<?xml ' + PrologAttrs + '?>';
  if Copy(XML, 1, 5) = '<?xml' then
    System.Delete(XML, 1, Pos('>', XML))
  else
    PrologNodeStr := PrologNodeStr + SLineBreak;
  XML := PrologNodeStr + XML;
end;

procedure TXMLDocument.SaveToXML(var XML: string);
var
  StringStream: TStringStream;
begin
  if not IsEmptyDoc then
  begin
    StringStream := TStringStream.Create('');
    try
      SaveToStream(StringStream);
      if DetectCharEncoding(StringStream) in [xetUTF_8, xetUTF_8Like, xetUnknown] then
        XML := StringStream.DataString
      else
        SaveToUTF8String(XML);
    finally
      StringStream.Free;
    end;
  end
  else
    XML := '';
end;

{ Misc. Helpers }

procedure TXMLDocument.CheckDOM;
begin
  if not Assigned(FDOMImplementation) then
    if Assigned(FDOMVendor) then
      FDOMImplementation := FDOMVendor.DOMImplementation
    else
      FDOMImplementation := GetDOM(DefaultDOMVendor);
end;

function TXMLDocument.GetDOMParseOptions: IDOMParseOptions;
begin
  if Assigned(FDOMDocument) and not Assigned(FDOMParseOptions) then
    FDOMDocument.QueryInterface(IDOMParseOptions, FDOMParseOptions);
  Result := FDOMParseOptions;
end;

function TXMLDocument.GetDOMPersist: IDOMPersist;
begin
  if not Assigned(FDOMPersist) then
    FDOMPersist := FDOMDocument as IDOMPersist;
  Result := FDOMPersist;
end;

procedure TXMLDocument.CheckActive;
begin
  CheckDOM;
  if not Assigned(FDOMDocument) then
    XMLDocError(SNotActive);
end;

procedure TXMLDocument.CheckAutoSave;
begin
  if (doAutoSave in FOptions) and Modified then
    case DocSource of
      xdsXMLProperty: SaveToXMLStrings;
      xdsFile: SaveToFile(FileName);
    end;
end;

procedure TXMLDocument.AssignParseOptions;
begin
  if Assigned(DOMParseOptions) then
  begin
    DOMParseOptions.preserveWhiteSpace := (poPreserveWhiteSpace in FParseOptions);
    DOMParseOptions.resolveExternals := (poResolveExternals in FParseOptions);
    DOMParseOptions.validate := (poValidateOnParse in FParseOptions);
    DOMParseOptions.async := (poAsyncLoad in FParseOptions);
    if Assigned(FOnAsyncLoad) then
      DOMPersist.set_OnAsyncLoad(Self, FOnAsyncLoad);
  end else if (FParseOptions <> []) then
    XMLDocError(SNoDOMParseOptions);
end;

function TXMLDocument.GeneratePrefix(const Node: IXMLNode): DOMString;
begin
  repeat
    Inc(FPrefixID);
    Result := NSPrefixBase + IntToStr(PrefixID);
  until (Node.FindNamespaceURI(Result) = '');
end;

function TXMLDocument.GetChildNodeClass(const Node: IDOMNode): TXMLNodeClass;
begin
  Result := nil;
end;

{ IXMLDocument Methods }

function TXMLDocument.AddChild(const TagName: DOMString): IXMLNode;
begin
  Result := Node.AddChild(TagName);
end;

function TXMLDocument.AddChild(const TagName, NamespaceURI: DOMString): IXMLNode;
begin
  Result := Node.AddChild(TagName, NamespaceURI);
end;

function TXMLDocument.CreateElement(const TagOrData, NamespaceURI: DOMString): IXMLNode;
begin
  Result := CreateNode(TagOrData, ntElement, NamespaceURI);
end;

function TXMLDocument.CreateNode(const NameOrData: DOMString;
  NodeType: TNodeType = ntElement; const AddlData: DOMString = ''): IXMLNode;
begin
  Result := TXMLNode.Create(CreateDOMNode(FDOMDocument, NameOrData,
    NodeType, AddlData), nil, Self);
end;

function TXMLDocument.GetChildNodes: IXMLNodeList;
begin
  Result := Node.ChildNodes;
end;

function TXMLDocument.IsEmptyDoc: Boolean;
begin
  Result := not (Assigned(FDOMDocument) and FDOMDocument.hasChildNodes);
end;

function TXMLDocument.GetDocBinding(const TagName: DOMString;
  DocNodeClass: TClass; NamespaceURI: DOMString = ''): IXMLNode;
begin
  RegisterDocBinding(TagName, DocNodeClass, NamespaceURI);
  if not Active then
    SetActive(True)
  else
    FDocumentNode := nil;
  { If no existing document element then always create one }
  if (DOMDocument.documentElement = nil) then
    if NamespaceURI <> '' then
      Node.AddChild(Tagname, NamespaceURI)
    else
      Node.AddChild(Tagname);
  Result := DocumentElement;
end;

procedure TXMLDocument.RegisterDocBinding(const TagName: DOMString;
  DocNodeClass: TClass; NamespaceURI: DOMString = '');
begin
  FDocumentNode := nil;
  AddNodeClassInfo(FDocBindingInfo, TXMLNodeClass(DocNodeClass), TagName, NamespaceURI);
end;

{ Property Accessors }

function TXMLDocument.GetAsyncLoadState: Integer;
begin
  Result := GetDOMPersist.asyncLoadState;
end;

function TXMLDocument.GetDOMDocument: IDOMDocument;
begin
  Result := FDOMDocument;
end;

procedure TXMLDocument.SetDOMDocument(const Value: IDOMDocument);
begin
  SetActive(False);
  DoBeforeOpen;
  FDOMDocument := Value;
  DoAfterOpen;
end;

function TXMLDocument.GetDocumentNode: IXMLNode;
var
  DocNodeObject: TXMLNode;
begin
  CheckActive;
  if not Assigned(FDocumentNode) then
  begin
    DocNodeObject := TXMLNode.Create(DOMDocument, nil, Self);
    FDocumentNode := DocNodeObject;
    DocNodeObject.FChildNodeClasses := FDocBindingInfo;
  end;
  Result := FDocumentNode;
end;

function TXMLDocument.GetDocumentElement: IXMLNode;
begin
  CheckActive;
  Result := nil;
  if Node.HasChildNodes then
  begin
    Result := Node.ChildNodes.Last;
    while Assigned(Result) and (Result.NodeType <> ntElement) do
      Result := Result.PreviousSibling;
  end;
end;

procedure TXMLDocument.SetDocumentElement(const Value: IXMLNode);
var
  OldDocElement: IXMLNode;
begin
  CheckActive;
  OldDocElement := GetDocumentElement;
  if Assigned(OldDocElement) then
    Node.ChildNodes.ReplaceNode(OldDocElement, Value)
  else
    Node.ChildNodes.Add(Value);
end;

procedure TXMLDocument.SetDOMImplementation(const Value: IDOMImplementation);
begin
  if Value <> FDOMImplementation then
  begin
    SetActive(False);
    FDOMImplementation := Value;
  end;
end;

procedure TXMLDocument.SetDOMVendor(const Value: TDOMVendor);
begin
  if Value <> FDOMVendor then
  begin
    FDOMVendor := Value;
    SetDOMImplementation(nil);
  end;
end;

function TXMLDocument.GetFileName: DOMString;
begin
  Result := FFileName;
end;

procedure TXMLDocument.SetFileName(const Value: DOMString);
begin
  if Value <> FFileName then
  begin
    if Active and (DocSource = xdsFile) then
      SetActive(False)
    else
      SetXMLStrings('');
    FFileName := Value;
  end;
end;

function TXMLDocument.GetModified: Boolean;
begin
  Result := FModified <> 0;
end;

procedure TXMLDocument.SetModified(const Value: Boolean);
begin
  if Value then
    Inc(FModified)
  else
    FModified := 0;
end;

function TXMLDocument.GetNodeIndentStr: DOMString;
begin
  Result := FNodeIndentStr;
end;

procedure TXMLDocument.SetNodeIndentStr(const Value: DOMString);
begin
  FNodeIndentStr := Value;
end;

function TXMLDocument.GetOptions: TXMLDocOptions;
begin
  Result := FOptions;
end;

procedure TXMLDocument.SetOptions(const Value: TXMLDocOptions);
begin
  FOptions := Value;
end;

function TXMLDocument.GetParseOptions: TParseOptions;
begin
  Result := FParseOptions;
end;

procedure TXMLDocument.SetParseOptions(const Value: TParseOptions);
begin
  FParseOptions := Value;
end;

procedure TXMLDocument.SetOnAsyncLoad(const Value: TAsyncEventHandler);
begin
  FOnAsyncLoad := Value;
  if Active then
    DOMPersist.set_OnAsyncLoad(Self, FOnAsyncLoad);
end;

function TXMLDocument.GetSchemaRef: DOMString;

  procedure CheckForDTD;
  var
    I, J: Integer;
    Node: IXMLNode;
  begin
    Result := '';
    for I := 0 to ChildNodes.Count - 1 do
      if (ChildNodes[I].NodeType = ntDocType) then
      begin
        Node := ChildNodes[I];
        for J := 0 to Node.AttributeNodes.Count - 1 do
          if (Node.AttributeNodes[J].NodeName = 'SYSTEM') then
          begin
            Result := VarToWideStr(Node.AttributeNodes[J].NodeValue);
            Break;
          end;
        Break;
      end;
  end;

  function FindLocationHint(const AttrName: DOMString;
    var SchemaLoc: DOMString): Boolean;
  var
    LocLen, HintStart: Integer;
  begin
    SchemaLoc := VarToStr(DocumentElement.GetAttributeNS(AttrName, SXMLSchemaInstURI));
    if SchemaLoc <> '' then
    begin
      LocLen := Length(SchemaLoc);
      HintStart := 1;
      while (HintStart < LocLen) do
      begin
        if SchemaLoc[HintStart] <= ' ' then
        begin
          SchemaLoc := TrimLeft(Copy(SchemaLoc, HintStart, MAXINT));
          Break;
        end;
        Inc(HintStart);
      end;
    end;
    Result := SchemaLoc <> '';
  end;

  procedure CheckForXMLSchema;
  begin
    if Assigned(DocumentElement) then
    begin
      if not FindLocationHint(SXMLSchemaLocation, Result) then
        FindLocationHint(SXMLNoNSSchemaLocation, Result);
    end;
  end;

begin
  Result := '';
  CheckForDTD;
  if Result = '' then
    CheckForXMLSchema;
end;

function TXMLDocument.GetDocumentObject: TXMLDocument;
begin
  Result := Self;
end;

function TXMLDocument.GetPrologNode: IXMLNode;
begin
  CheckActive;
  if (Node.ChildNodes.Count > 0) and
     (Node.ChildNodes[0].NodeType = ntProcessingInstr) and
     (Node.ChildNodes[0].NodeName = SXML) then
    Result := Node.ChildNodes[0]
  else
    Result := nil;
end;

function TXMLDocument.GetPrologValue(PrologItem: TXMLPrologItem;
  const Default: DOMString = ''): DOMString;
var
  PrologNode: IXMLNode;
  PrologAttrs: string;
  PrologInfo: IDOMXMLProlog;
begin
  if GetDOMDocument.QueryInterface(IDOMXMLProlog, PrologInfo) = S_OK then
  begin
    case PrologItem of
      xpVersion:
        Result := PrologInfo.Version;
      xpEncoding:
        Result := PrologInfo.Encoding;
      xpStandalone:
        Result := PrologInfo.StandAlone;
    end;
    if Result = '' then
      Result := Default;
  end
  else
  begin
    PrologNode := GetPrologNode;
    if Assigned(PrologNode) then
    begin
      PrologAttrs := PrologNode.NodeValue;
      case PrologItem of
        xpVersion:
          Result := ExtractAttrValue(SVersion, PrologAttrs, Default);
        xpEncoding:
          Result := ExtractAttrValue(SEncoding, PrologAttrs, Default);
        xpStandalone:
          Result := ExtractAttrValue(SStandalone, PrologAttrs, Default);
      end
    end
    else
      Result := Default;
  end;
end;

function TXMLDocument.InternalSetPrologValue(const PrologNode: IXMLNode;
  const Value: Variant; PrologItem: TXMLPrologItem): string;
var
  Version, Encoding, Standalone: string;
begin
  if Assigned(PrologNode) then
  begin
    { Initialize values from existing prolog entry }
    Version := GetPrologValue(xpVersion, '1.0');
    Encoding := GetPrologValue(xpEncoding);
    Standalone := GetPrologValue(xpStandalone);
  end else
    Version := '1.0';
  { Set the new value }
  case PrologItem of
    xpVersion: Version := Value;
    xpEncoding: Encoding := Value;
    xpStandalone: Standalone := Value;
  end;
  { Build a string with all of the values }
  Result := '';
  AppendItem(Result, SVersion, Version);
  AppendItem(Result, SEncoding, Encoding);
  AppendItem(Result, SStandalone, Standalone);
end;

procedure TXMLDocument.SetPrologValue(const Value: Variant;
  PrologItem: TXMLPrologItem);
var
  PrologAttrs: string;
  NewPrologNode, PrologNode: IXMLNode;
  PrologInfo: IDOMXMLProlog;
begin
  if GetDOMDocument.QueryInterface(IDOMXMLProlog, PrologInfo) = S_OK then
  begin
    case PrologItem of
      xpVersion:
        PrologInfo.Version := Value;
      xpEncoding:
        PrologInfo.Encoding := Value;
      xpStandalone:
        PrologInfo.StandAlone := Value;
    end;
  end
  else
  begin
    PrologNode := GetPrologNode;
    PrologAttrs := InternalSetPrologValue(PrologNode, Value, PrologItem);
    NewPrologNode := CreateNode('xml', ntProcessingInstr, PrologAttrs);
    if Assigned(PrologNode) then
      Node.ChildNodes.ReplaceNode(PrologNode, NewPrologNode)
    else
      ChildNodes.Insert(0, NewPrologNode);
  end;
end;

function TXMLDocument.GetEncoding: DOMString;
begin
  Result := GetPrologValue(xpEncoding);
end;

procedure TXMLDocument.SetEncoding(const Value: DOMString);
begin
  SetPrologValue(Value, xpEncoding);
end;

function TXMLDocument.GetVersion: DOMString;
begin
  Result := GetPrologValue(xpVersion);
end;

procedure TXMLDocument.SetVersion(const Value: DOMString);
begin
  SetPrologValue(Value, xpVersion);
end;

function TXMLDocument.GetStandAlone: DOMString;
begin
  Result := GetPrologValue(xpStandalone);
end;

procedure TXMLDocument.SetStandAlone(const Value: DOMString);
begin
  SetPrologValue(Value, xpStandalone);
end;

{ Event Helpers }

procedure TXMLDocument.DoAfterClose;
begin
  if Assigned(FAfterClose) then FAfterClose(Self);
end;

procedure TXMLDocument.DoAfterOpen;
begin
  if Assigned(FAfterOpen) then FAfterOpen(Self);
end;

procedure TXMLDocument.DoBeforeClose;
begin
  if Assigned(FBeforeClose) then FBeforeClose(Self);
end;

procedure TXMLDocument.DoBeforeOpen;
begin
  if Assigned(FBeforeOpen) then FBeforeOpen(Self);
end;

procedure TXMLDocument.DoNodeChange(const Node: IXMLNode;
  ChangeType: TNodeChange; BeforeOperation: Boolean);
begin
  SetModified(True);
  if BeforeOperation then
  begin
    if Assigned(BeforeNodeChange) then
      BeforeNodeChange(Node, ChangeType);
  end else
    if Assigned(AfterNodeChange) then
      AfterNodeChange(Node, ChangeType);
end;

end.
