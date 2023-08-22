{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{           Copyright (c) 1995-2008 CodeGear            }
{                                                       }
{*******************************************************}

unit HelpIntfs;

{ *************************************************************************  }
{                                                                            }
{  This unit is the primary unit for the combined VCL/CLX Help System.       }
{  TApplication contains a pointer to an IHelpSystem, through which it       }
{  calls into the Help System Manager. The Help System Manager maintains     }
{  a list of custom Help Viewers, which implement ICustomHelpViewer and,     }
{  if desired, one of several extended help interfaces derived from it.      }
{  Help Viewers talk to the Help System Manager through the IHelpManager     }
{  interface, which is returned to them when they register.                  }
{                                                                            }
{  Code wishing to invoke the Help System can go through Application, or     }
{  can call the flat function GetHelpSystem, which will return an            }
{  IHelpSystem if one is available. Viewers register by calling              }
{  RegisterViewer, which returns an IHelpManager.                            }
{                                                                            }
{  The same mechanism will work for design packages wishing to integrate     }
{  with the IDE Help System; calling HelpIntfs.RegisterViewer() in the       }
{  Register() procedure will cause the Viewer to be registered.              }
{                                                                            }
{ *************************************************************************  }

interface

uses SysUtils, Classes;

type
  { IHelpSelector. IHelpSelector is used by the HelpSystem to ask the
    application to decide which keyword, out of multiple matches returned
    by multiple different Help Viewers, it wishes to support. If an application
    wishes to support this, it passes an IHelpSelector interface into
    IHelpSystem.AssignHelpSelector. }
  IHelpSelector = interface(IInterface)
    ['{B0FC9358-5F0E-11D3-A3B9-00C04F79AD3A}']
    function SelectKeyword(Keywords: TStrings) : Integer;
    function TableOfContents(Contents: TStrings): Integer;
  end;

  IHelpSelector2 = interface(IHelpSelector)
    ['{F65368F4-CA3B-482C-ABD2-3FC23F801D8B}']
    function SelectContext(Viewers: TStrings): Integer;
  end;

  { IHelpSystem. IHelpSystem is the interface through which an application
    request that help be displayed. ShowHelp() uses functionality which is
    guaranteed to be supported by all Help Viewers. ShowContextHelp() and
    ShowTopicHelp() are supported only by extended Help Viewers. In the
    event that there are no extended Viewers installed, ShowTableOfContents asks
    the System to display a table of contents; either the first registered
    Viewer's table of contents will be displayed, a dialog will be displayed to
    ask the user to pick one, or, if no Viewer supports tables of contents,
    an exception will be thrown. When appropriate, these procedures
    will raise an EHelpSystemException. Hook() is the mechanism by which
    the application asks the Help System to package winhelp-specific commands
    into something understood by the Help Viewers. }
  IHelpSystem = interface(IInterface)
    ['{B0FC9353-5F0E-11D3-A3B9-00C04F79AD3A}']
    procedure ShowHelp(const HelpKeyword, HelpFileName: string);
    procedure ShowContextHelp(const ContextID: Longint; const HelpFileName: string);
    procedure ShowTableOfContents;
    procedure ShowTopicHelp(const Topic, HelpFileName: string);
    procedure AssignHelpSelector(const Selector: IHelpSelector);
    function Hook(Handle: Longint; const HelpFile: string; Comand: Word; Data: Longint): Boolean;
  end;

  { IHelpSystem2. UnderstandsKeyword() allows you to query the help viewers to see
    if they understand the given keyword }
  IHelpSystem2 = interface(IHelpSystem)
    ['{48C5336E-71E2-4406-A08E-F915FBA5C9D4}']
    function UnderstandsKeyword(const HelpKeyword, HelpFileName: string): Boolean;
  end;

  { IHelpSystem3. Allows you to show the index and search fields.  Also has an
    overloaded version of ShowTopicHelp that allows you to utilize anchors for
    MS HTML Help. Get/SetFilter allow you to adjust the filters for MS HTML Help2 }
  IHelpSystem3 = interface(IHelpSystem2)
    ['{006A65EE-9A5E-4EB1-828F-A7F1D79DD202}']
    procedure ShowIndex(const Topic, HelpFileName: string);
    procedure ShowSearch(const Topic, HelpFileName: string);
    procedure ShowTopicHelp(const Topic, Anchor, HelpFileName: string); overload;
    function GetFilter: string;
    procedure SetFilter(const Filter: string);
  end;

  { ICustomHelpViewer. The Help System talks to Help Viewers through
    this interface. If there is *more* than one Help Viewer registered,
    the Help System calls UnderstandsKeyword() on each Viewer, which is required
    to return the number of available keyword matches. If more than one
    Viewer has help available for a particular keyword, then each Viewer
    is asked to supply a list of keyword strings through GetHelpStrings();
    the Help Manager allows the user to choose one, and then calls ShowHelp()
    only on the selected Viewer. At the time of registration, the Help
    Manager will call NotifyID to give the Viewer a cookie; if the Viewer
    disconnects, it must pass that cookie back to the Manager in the Release()
    call. If the Manager is disconnecting, it will call ShutDown() on all Viewers,
    to notify them that the System is going away and the application will be
    shutting down. If the Manager receives a request that it terminate all
    externally visible manifestations of the Help System, it will call
    SoftShutDown() on all Viewers. }
  ICustomHelpViewer = interface(IInterface)
    ['{B0FC9364-5F0E-11D3-A3B9-00C04F79AD3A}']
    function  GetViewerName: string;
    function  UnderstandsKeyword(const HelpString: string): Integer;
    function  GetHelpStrings(const HelpString: string): TStringList;
    function  CanShowTableOfContents : Boolean;
    procedure ShowTableOfContents;
    procedure ShowHelp(const HelpString: string);
    procedure NotifyID(const ViewerID: Integer);
    procedure SoftShutDown;
    procedure ShutDown;
  end;

  { IExtendedHelpViewer.  Help Viewers which wish to support context-ids and
    topics may do so. Unlike standard keyword help, the Help Manager will
    only invoke the *first* registered Viewer which supports a particular
    context id or topic; this limitation is necessary in order to make
    interaction with WinHelp more efficient. }
  IExtendedHelpViewer = interface(ICustomHelpViewer)
    ['{B0FC9366-5F0E-11D3-A3B9-00C04F79AD3A}']
    function UnderstandsTopic(const Topic: string): Boolean;
    procedure DisplayTopic(const Topic: string);
    function UnderstandsContext(const ContextID: Integer;
      const HelpFileName: string): Boolean;
    procedure DisplayHelpByContext(const ContextID: Integer;
      const HelpFileName: string);
  end;

  IExtendedHelpViewer2 = interface(IExtendedHelpViewer)
    ['{DD46A379-569A-46AA-89E5-8AACA764304B}']
    procedure DisplayIndex(const Topic: string);
    procedure DisplaySearch(const Topic: string);
    procedure DisplayTopic(const Topic, Anchor: string); overload;
  end;

  { IFilteredHelpViewer. Used to set and get the current filter of the viewer.
    This concept applies to the MS Help2 Viewer. }
  IFilteredHelpViewer = interface(IExtendedHelpViewer2)
    ['{991F8E1A-2E3F-4ACB-91A8-4B9587BBA878}']
    function GetFilter: string;
    procedure SetFilter(const Filter: string);
  end;

  { ISpecialWinHelpViewer. Certain Help System messages are difficult
    if not impossible to unpackage into commands that do not depend on
    WinHelp syntax. Help Viewers wishing to recieve such messages may
    implement this interface. Note that this interface is primarily
    intended for use in Windows-based applications and should only
    be implemented under Linux under extreme circumstances. }
  ISpecialWinHelpViewer = interface(IExtendedHelpViewer)
    ['{1A7B2224-1EAE-4313-BAD6-3C32F8F77085}']
    function CallWinHelp(Handle: LongInt; const HelpFile: string; Command: Word;
      Data: LongInt): Boolean;
  end;

  { IHelpSystemFlags. Help System can optionally implement this
    interface to alter default help system behavior.
    If GetUseDefaultTopic is True then UnderstandsKeyword
    always returns True even if real topic is not found.
    It forces ShowHelp call to show 'default' topic instead of raising
    an Exception. }
  IHelpSystemFlags = interface(IExtendedHelpViewer)
    ['{69418F09-5E49-4899-9E13-9FE3C1497566}']
    function GetUseDefaultTopic: Boolean;
    procedure SetUseDefaultTopic(AValue: Boolean);
  end;

  { IHelpManager. IHelpManager provides a mechanism for Help Viewers to
    talk to the Help System. Release() must be called by any Help Viewer
    when it is shutting down *unless* it is shutting down in response to
    a ShutDown() call. }
  IHelpManager = interface
    ['{6B0CDB05-C30A-414B-99C4-F11CD195385E}']
    function  GetHandle: LongInt; { sizeof(LongInt) = sizeof (HWND) }
    function GetHelpFile: string;
    procedure Release(const ViewerID: Integer);
  end;

  { All help-specific error messages should be thrown as this type. }
  EHelpSystemException = class(Exception);

  { NOTE: RegisterViewer raises an exception on failure. }
  function RegisterViewer(const newViewer: ICustomHelpViewer;
    out Manager: IHelpManager): Integer;

  { NOTE: GetHelpSystem does not raise on failure. }
  function GetHelpSystem(out System: IHelpSystem): Boolean; overload;
  function GetHelpSystem(out System: IHelpSystem2): Boolean; overload;
  function GetHelpSystem(out System: IHelpSystem3): Boolean; overload;

{$IFDEF LINUX}

 { Constants used by the windows help system. Needed here to understand
   messages that come from, or are intended for, windows-based systems
   or emulations thereof. }

const
  HELP_CONTEXT = 1;
  HELP_QUIT = 2;
  HELP_INDEX = 3;
  HELP_CONTENTS = HELP_INDEX;
  HELP_HELPONHELP = 4;
  HELP_SETINDEX = 5;
  HELP_SETCONTENTS = HELP_SETINDEX;
  HELP_CONTEXTPOPUP = 8;
  HELP_FORCEFILE = 9;
  HELP_CONTEXTMENU = 10;
  HELP_FINDER = 11;
  HELP_WM_HELP = 12;
  HELP_SETPOPUP_POS = 13;
  HELP_TCARD_OTHER_CALLER = 17;
  HELP_KEY = 257;
  HELP_COMMAND = 258;
  HELP_PARTIALKEY = 261;
  HELP_MULTIKEY = 513;
  HELP_SETWINPOS = 515;
  HELP_TCARD_DATA = $10;
  HELP_TCARD = $8000;
{$ENDIF}

implementation

{$IFDEF MSWINDOWS}
uses Contnrs, Windows, RTLConsts;
{$ENDIF}
{$IFDEF LINUX}
uses Libc, Contnrs, RTLConsts;
{$ENDIF}

type
  IInternalHelpManager = interface
    ['{4CF9EA88-BD20-4045-B9BE-1F23BA11335C}']
    function RegisterViewer(const newViewer: ICustomHelpViewer): IHelpManager;
  end;

  { THelpManager.
    THelpManager implements the IHelpSystem and IHelpManager interfaces. }
  THelpManager = class(TInterfacedObject, IInternalHelpManager, IHelpSystem,
    IHelpSystem2, IHelpSystem3, IHelpManager)
  private
    FHelpSelector: IHelpSelector;
    FViewerList: TList;
    FExtendedViewerList: TList;
    FMinCookie: Integer;
    FHandle: LongInt;
    FHelpFile: string;

    function SelectViewer(ViewerNames: TStringList): ICustomHelpViewer;
    procedure DoSoftShutDown;
//TODO: make CallSpecialWinHelp's parameters encompass sizes needed by HTMLHelp, and defer shrinking them to the WinHelpViewer.
    function CallSpecialWinHelp(Handle: LongInt; const HelpFile: string;
      Command: Word; Data: LongInt): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    { IInternalHelpManager }
    function RegisterViewer(const newViewer: ICustomHelpViewer): IHelpManager;
    { IHelpSystem }
    procedure ShowHelp(const HelpKeyword, HelpFileName: string);
    procedure ShowContextHelp(const ContextID: Longint;
      const HelpFileName: string);
    procedure ShowTableOfContents;
    procedure ShowTopicHelp(const Topic, HelpFileName: string); overload;
    procedure AssignHelpSelector(const Selector: IHelpSelector);
//TODO: make Hook() handle HtmlHelp *and* WinHelp hooks.
    function Hook(Handle: Longint; const HelpFile: string;
      Command: Word; Data: Longint): Boolean;
    { IHelpSystem2 }
    function UnderstandsKeyword(const HelpKeyword, HelpFileName: string): Boolean;
    { IHelpSystem3 }
    procedure ShowIndex(const Topic, HelpFileName: string);
    procedure ShowSearch(const Topic, HelpFileName: string);
    procedure ShowTopicHelp(const Topic, Anchor, HelpFileName: string); overload;
    function GetFilter: string;
    procedure SetFilter(const Filter: string);
    { IHelpManager }
    function GetHandle: LongInt;
    function GetHelpFile: string;
    procedure Release(const ViewerID: Integer);
    { properties }
    property Handle: Longint read FHandle write FHandle;
    property HelpFile: string read FHelpFile write FHelpFile;
  end;

  { THelpViewerNode.
    THelpViewerNode is a small wrapper class which links a Help Viewer to
    its associated Viewer ID. }
  THelpViewerNode = class(TObject)
  private
    FViewer: ICustomHelpViewer;
    FViewerID: Integer;
  public
    constructor Create(const Viewer: ICustomHelpViewer);
    property Viewer: ICustomHelpViewer read FViewer;
    property ViewerID : Integer read FViewerID write FViewerID;
  end;

{ global instance of THelpManager which TApplication can talk to. }
var
  HelpManager: IHelpManager;

{ Warning: resource strings will be moved to RtlConst in the next revision. }
resourcestring
    hNoContext = 'Keine kontextsensitive Hilfe installiert';
    hNoContextFound = 'Keine Hilfe für Kontext gefunden';
    hNoIndex = 'Index kann nicht geöffnet werden';
    hNoSearch = 'Suche kann nicht geöffnet werden';
    hNoTableOfContents = 'Inhaltsverzeichnis nicht gefunden';
    hNoTopics = 'Kein themenbezogenes Hilfesystem installiert';
    hNothingFound = 'Keine Hilfe für %s gefunden';

{ Exported flat functions }

procedure EnsureHelpManager;
begin
  if HelpManager = nil then
    HelpManager := THelpManager.Create;
end;

function RegisterViewer(const newViewer: ICustomHelpViewer;
  out Manager: IHelpManager): Integer;
begin
  EnsureHelpManager;
  Manager := (HelpManager as IInternalHelpManager).RegisterViewer(newViewer);
  Result := 0;
end;

function GetHelpSystem(out System: IHelpSystem): Boolean;
begin
  EnsureHelpManager;
  System := HelpManager as IHelpSystem;
  Result := System <> nil;
end;

function GetHelpSystem(out System: IHelpSystem2): Boolean;
begin
  EnsureHelpManager;
  System := HelpManager as IHelpSystem2;
  Result := System <> nil;
end;

function GetHelpSystem(out System: IHelpSystem3): Boolean;
begin
  EnsureHelpManager;
  System := HelpManager as IHelpSystem3;
  Result := System <> nil;
end;

{ THelpViewerNode }

constructor THelpViewerNode.Create(const Viewer: ICustomHelpViewer);
begin
  inherited Create;
  FViewer := Viewer;
end;

{ THelpManager }

constructor THelpManager.Create;
begin
  inherited Create;
  FViewerList := TList.Create;
  FExtendedViewerList := TList.Create;
  FHelpFile := '';
  FMinCookie := 1;
end;

destructor THelpManager.Destroy;
var
  HelpNode: THelpViewerNode;
  I: Integer;
begin
  for I := 0 to FViewerList.Count - 1 do
  begin
    HelpNode := THelpViewerNode(FViewerList[FViewerList.Count - 1]);
    HelpNode.Viewer.ShutDown;
    HelpNode.Free;
  end;

  if FHelpSelector <> nil then
    FHelpSelector := nil;

  FExtendedViewerList.Free;
  FViewerList.Free;
  inherited Destroy;
end;

function THelpManager.RegisterViewer(const NewViewer: ICustomHelpViewer): IHelpManager;
var
  ExtendedViewer: IExtendedHelpViewer;
  NewNode: THelpViewerNode;
begin
  NewNode := THelpViewerNode.Create(NewViewer);
  NewNode.ViewerID := FMinCookie;
  FViewerList.Add(NewNode);
  NewViewer.NotifyID(FMinCookie);

  if Supports(NewViewer, IExtendedHelpViewer, ExtendedViewer) then
    FExtendedViewerList.Add(NewNode);

  Inc(FMinCookie);
  Result := Self as IHelpManager;
end;

function THelpManager.SelectViewer(ViewerNames: TStringList): ICustomHelpViewer;
var
  I: Integer;
begin
  Result := nil;

  if ViewerNames.Count = 1 then
  begin
    // If there is only one TOC provider then use it.
    Result := THelpViewerNode(ViewerNames.Objects[0]).Viewer;
  end
  else if (ViewerNames.Count > 0) and (FHelpSelector <> nil) then
  begin
    // If there is more than one Viewer, let the user choose the one to use.
    ViewerNames.Sort;
    I := FHelpSelector.TableOfContents(ViewerNames);
    Result := THelpViewerNode(ViewerNames.Objects[I]).Viewer;
  end;
end;

procedure THelpManager.DoSoftShutDown;
var
  I: Integer;
begin
  // This procedure is called when an application wants to shut down any
  // *externally visible* evidence of help invocation, but does not want
  // to terminate the Help Viewer.
  for I := 0 to FViewerList.Count - 1 do
    THelpViewerNode(FViewerList[I]).Viewer.SoftShutDown;
end;

function THelpManager.CallSpecialWinHelp(Handle: LongInt; const HelpFile: string;
  Command: Word; Data: LongInt): Boolean;
var
  SpecialViewer: ISpecialWinHelpViewer;
  I: Integer;
begin
  Result := False;

  if HelpFile <> '' then
    FHelpFile := HelpFile;

  // There should only be one special winhelp viwer. If there are more then
  // something strange is going on.
  // Note: THis may someday be delegatable to an IHelpSElector2 interface.
  for I  := 0 to FViewerList.Count - 1 do
  begin
    if Supports(THelpViewerNode(FViewerList[I]).Viewer, ISpecialWinHelpViewer,
      SpecialViewer) then
    begin
      Result := SpecialViewer.CallWinHelp(Handle, HelpFile, Command, Data);
      Break;
    end;
  end;
end;

{ THelpManager - IHelpSystem }

procedure THelpManager.ShowHelp(const HelpKeyword, HelpFileName: string);
var
  I, J: Integer;
  AvailableHelp: Integer;
  AvailableHelpList: TStringList;
  ViewerHelpList: TStringList;
  HelpNode: THelpViewerNode;
  KeywordIndex: Integer;
  Obj: TObject;
  ObjString: string;
  Viewers: TList;
begin
  { if the invoker passed in a help file name, use it; otherwise, assume
    that Application.HelpFile is correct, and use it. }
  if HelpFileName <> ''  then
    HelpFile := HelpFileName;

  { ask everyone how much help they have on this token, and maintain count;
    keep track of the last guy who said they had any help at all, in case
    they're the only one. }
  if FViewerList.Count > 0 then
  begin
    Viewers := TList.Create;

    try
      for I := 0 to FViewerList.Count - 1 do
      begin
        HelpNode := THelpViewerNode(FViewerList[I]);
        AvailableHelp := HelpNode.Viewer.UnderstandsKeyword(HelpKeyword);
        if AvailableHelp > 0 then
          Viewers.Add(HelpNode);
      end;

      { if nobody can help, game over. }
      if Viewers.Count = 0 then
        raise EHelpSystemException.CreateResFmt(@hNothingFound, [PChar(HelpKeyword)])
      { if one guy can help, go ahead. }
      else if Viewers.Count = 1 then
        THelpViewerNode(Viewers[0]).Viewer.ShowHelp(HelpKeyword)
      else
      begin
        { do complicated processing if more than one guy offers to help. }
        AvailableHelpList := TStringList.Create;
        try
          { Ask each Viewer if it can supply help. If it can, then get the help
            strings and build a string list which maps help strings to the
            supplying Viewer. } { note: it may be more efficient to do this
            by caching the original responses to UnderstandsKeyword() in an array and
            then iterating through it. }
          for I := 0 to Viewers.Count - 1 do
          begin
            HelpNode := THelpViewerNode(Viewers[I]);
            ViewerHelpList := HelpNode.Viewer.GetHelpStrings(HelpKeyword);

            if ViewerHelpList <> nil then
            begin
              try
                for J := 0 to ViewerHelpList.Count - 1 do
                  AvailableHelpList.AddObject(ViewerHelpList.Strings[J], TObject(HelpNode));
              finally
                ViewerHelpList.Free;
              end;
            end;
          end;

          if Assigned(FHelpSelector) then
          begin
            AvailableHelpList.Sort;

            { pass the list off to some display mechanism. }
            KeywordIndex := FHelpSelector.SelectKeyword(AvailableHelpList);

            { God help us if the number doesn't mean what we think it did, ie.,
              if the client reordered and didn't maintain the original order. }
            if KeywordIndex >= 0 then
            begin
              Obj := AvailableHelpList.Objects[KeywordIndex];
              ObjString := AvailableHelpList.Strings[KeywordIndex];
              THelpViewerNode(Obj).Viewer.ShowHelp(ObjString);
            end;
            { if KeywordIndex is negative, they cancelled out of the help
              selection dialog; the right thing to do is silently fall through. }
          end
          else
          begin
            { The programmer doesn't want to override the default behavior,
            so just pick the first one and hope it was right. }
            Obj := AvailableHelpList.Objects[0];
            ObjString := AvailableHelpList.Strings[0];
            THelpViewerNode(Obj).Viewer.ShowHelp(ObjString);
          end;
        finally
          AvailableHelpList.Free;
        end;
      end;
    finally
      Viewers.Free;
    end;
  end;
end;

procedure THelpManager.ShowContextHelp(const ContextID: Longint; const HelpFileName: string);
var
  I: Integer;
  HelpCount: Integer;
  View: ICustomHelpViewer;
  Selector: IHelpSelector2;
  SystemNames: TStringList;
  SelectedContext : Integer;
  HelpNode: THelpViewerNode;
  Obj: TObject;
  LastGoodViewer: Integer;

  procedure DefaultContextHelp(const ContextId: LongInt;
                               const HelpFileName: string);
  var
    View: ICustomHelpViewer;
  begin
    View := THelpViewerNode(FExtendedViewerList[LastGoodViewer]).Viewer;
    (View as IExtendedHelpViewer).DisplayHelpByContext(ContextId, HelpFileName);
  end;

begin
  HelpCount := 0;

  if HelpFileName <> '' then
    HelpFile := HelpFileName;

  { if nobody handles context-sensitive help, then bail. }
  if FExtendedViewerList.Count = 0 then
    raise EHelpSystemException.CreateRes(@hNoContext)

 { if multiple people handle context-sensitive help, hand it off to the first
   handler. This will lead to some subtle annoying behavior, but the opposite
   is worse. Note that contexts depend on file names, while tokens do not;
   that's a wierd winhelpism. }
  else
  begin
    for I := 0 to FExtendedViewerList.Count -1 do
    begin
      View := THelpViewerNode(FExtendedViewerList[I]).Viewer;
      if (View as IExtendedHelpViewer).UnderstandsContext(ContextID, HelpFileName) then
      begin
        HelpCount := HelpCount + 1;
        LastGoodViewer := I;
      end;
    end;
  end;

  if HelpCount = 0 then
    raise EHelpSystemException.CreateRes(@hNoContextFound);

  if HelpCount = 1 then
  begin
    DefaultContextHelp(ContextId, HelpFileName);
  end
  else
  begin
    if Assigned(FHelpSelector) then
    begin
      Selector := FHelpSelector as IHelpSelector2;
      if Assigned(Selector) then
      begin
        SystemNames := TStringList.Create;
        try
          for I := 0 to FExtendedViewerList.Count - 1 do
          begin
            HelpNode := THelpViewerNode(FExtendedViewerList[I]);
            View := HelpNode.Viewer;
            if (View as IExtendedHelpViewer).UnderstandsContext(ContextId, HelpFileName) then
            begin
             SystemNames.AddObject(HelpNode.Viewer.GetViewerName, TObject(HelpNode));
            end;
          end;
          SelectedContext := Selector.SelectContext(SystemNames);
          if SelectedContext >= 0 then
          begin
            Obj := SystemNames.Objects[SelectedContext];
            View := THelpViewerNode(Obj).Viewer;
            (View as IExtendedHelpViewer).DisplayHelpByContext(ContextId, HelpFileName);
          end
          else
          begin
            DefaultContextHelp(ContextId, HelpFileName);
          end;
        finally
          SystemNames.Free;
        end;
      end
      else
      begin
        DefaultContextHelp(ContextId, HelpFileName);
      end;
    end else
    begin
      DefaultContextHelp(ContextId, HelpFileName);
    end;
  end;
end;

procedure THelpManager.ShowTableOfContents;
var
  ViewerNames: TStringList;
  I: Integer;
  HelpNode: THelpViewerNode;
  Viewer: ICustomHelpViewer;
begin
  ViewerNames := TStringList.Create;
  try
    // Ask each viewer which supports TOC to provide its name.
    for I := 0 to FViewerList.Count -1 do
    begin
      HelpNode := THelpViewerNode(FViewerList[I]);
      if HelpNode.Viewer.CanShowTableOfContents then
         ViewerNames.AddObject(HelpNode.Viewer.GetViewerName, TObject(HelpNode));
    end;

    Viewer := SelectViewer(ViewerNames);
  finally
    ViewerNames.Free;
  end;

  if Viewer <> nil then
    Viewer.ShowTableOfContents
  else
    raise EHelpSystemException.CreateRes(@hNoTableOfContents);
end;

procedure THelpManager.ShowTopicHelp(const Topic, HelpFileName: string);
var
  I: Integer;
  View: ICustomHelpViewer;
  ExtendedViewer: IExtendedHelpViewer;
begin
  if HelpFileName <> '' then
    HelpFile := HelpFileName;

  if FExtendedViewerList.Count = 0 then
    raise EHelpSystemException.CreateRes(@hNoTopics);

  for I := 0 to FExtendedViewerList.Count - 1 do
  begin
    View := THelpViewerNode(FExtendedViewerList[I]).Viewer;
    ExtendedViewer := View as IExtendedHelpViewer;
    if ExtendedViewer.UnderstandsTopic(Topic) then
    begin
      ExtendedViewer.DisplayTopic(Topic);
      Break;
    end;
  end;
end;

procedure THelpManager.AssignHelpSelector(const Selector: IHelpSelector);
begin
  FHelpSelector := Selector;
end;

function THelpManager.Hook(Handle: Longint; const HelpFile: string;
  Command: Word; Data: Longint): Boolean;
begin
  if HelpFile <> '' then
    Self.HelpFile := HelpFile;
  case Command of
    HELP_CONTEXT:
      ShowContextHelp(Data, HelpFile);
    { note -- the following subtly turns HELP_CONTEXTPOPUP into HELP_CONTEXT.
      This is consistent with D5 behavior but may not be ideal. }
    HELP_CONTEXTPOPUP:
      ShowContextHelp(Data, HelpFile);
    HELP_QUIT:
      DoSoftShutDown;
    HELP_CONTENTS:
      ShowTableOfContents;
  else
    CallSpecialWinHelp(Handle, HelpFile, Command, Data);
  end;
  Result := true;
end;

{ THelpManager - IHelpSystem2 }

function THelpManager.UnderstandsKeyword(const HelpKeyword, HelpFileName: string): Boolean;
var
  Index: Integer;
  Viewer: ICustomHelpViewer;
  Flags: IHelpSystemFlags;
  UseDefaultTopic: Boolean;
begin
  Result := False;
  UseDefaultTopic := False;

  // If the invoker passed in a help file name, use it; otherwise, assume
  // that Application.HelpFile is correct, and use it.
  if HelpFileName <> ''  then
    HelpFile := HelpFileName;

  // Ask everyone how much help they have on this token;
  // break as soon as we found first viewer which knows about 'HelpKeyword'.
  for Index := 0 to FViewerList.Count - 1 do
  begin
    Viewer := THelpViewerNode(FViewerList[Index]).Viewer;

    try
      // Turn UseDefaultTopic flag to False, otherwise UnderstandsKeyword
      // always returns True.
      if Supports(Viewer, IHelpSystemFlags, Flags) then
      begin
        UseDefaultTopic := Flags.GetUseDefaultTopic;
        Flags.SetUseDefaultTopic(False);
      end;

      if Viewer.UnderstandsKeyword(HelpKeyword) > 0 then
      begin
        Result := True;
        Break;
      end;
    finally
      // Set UseDefaultTopic flag back to what it was before the call to
      // UnderstandsKeyword.
      if Flags <> nil then
        Flags.SetUseDefaultTopic(UseDefaultTopic);
    end;
  end;
end;

{ THelpManager - IHelpSystem3 }

procedure THelpManager.ShowIndex(const Topic, HelpFileName: string);
var
  ViewerNames: TStringList;
  I: Integer;
  HelpNode: THelpViewerNode;
  Viewer: ICustomHelpViewer;
begin
  if HelpFileName <> '' then
    HelpFile := HelpFileName;

  ViewerNames := TStringList.Create;
  try
    // Ask each viewer which supports IExtendedHelpViewer2 to provide its name.
    for I := 0 to FViewerList.Count -1 do
    begin
      HelpNode := THelpViewerNode(FViewerList[I]);
      if Supports(HelpNode.FViewer, IExtendedHelpViewer2, Viewer) then
         ViewerNames.AddObject(HelpNode.Viewer.GetViewerName, TObject(HelpNode));
    end;

    Viewer := SelectViewer(ViewerNames);
  finally
    ViewerNames.Free;
  end;

  if Viewer <> nil then
    (Viewer as IExtendedHelpViewer2).DisplayIndex(Topic)
  else
    raise EHelpSystemException.CreateRes(@hNoIndex);
end;

procedure THelpManager.ShowSearch(const Topic, HelpFileName: string);
var
  ViewerNames: TStringList;
  I: Integer;
  HelpNode: THelpViewerNode;
  Viewer: ICustomHelpViewer;
begin
  if HelpFileName <> '' then
    HelpFile := HelpFileName;

  ViewerNames := TStringList.Create;
  try
    // Ask each viewer which supports IExtendedHelpViewer2 to provide its name.
    for I := 0 to FViewerList.Count -1 do
    begin
      HelpNode := THelpViewerNode(FViewerList[I]);
      if Supports(HelpNode.FViewer, IExtendedHelpViewer2, Viewer) then
         ViewerNames.AddObject(HelpNode.Viewer.GetViewerName, TObject(HelpNode));
    end;

    Viewer := SelectViewer(ViewerNames);
  finally
    ViewerNames.Free;
  end;

  if Viewer <> nil then
    (Viewer as IExtendedHelpViewer2).DisplaySearch(Topic)
  else
    raise EHelpSystemException.CreateRes(@hNoSearch);
end;

procedure THelpManager.ShowTopicHelp(const Topic, Anchor, HelpFileName: string);
var
  I: Integer;
  Viewer: ICustomHelpViewer;
  ExtendedViewer: IExtendedHelpViewer2;
begin
  if HelpFileName <> '' then
    HelpFile := HelpFileName;

  if FExtendedViewerList.Count = 0 then
    raise EHelpSystemException.CreateRes(@hNoTopics);

  for I := 0 to FExtendedViewerList.Count - 1 do
  begin
    Viewer := THelpViewerNode(FExtendedViewerList[I]).Viewer;
    if Supports(Viewer, IExtendedHelpViewer2, ExtendedViewer) and
       ExtendedViewer.UnderstandsTopic(Topic) then
    begin
      ExtendedViewer.DisplayTopic(Topic, Anchor);
      Break;
    end
    else
      raise EHelpSystemException.CreateRes(@hNoTopics);
  end;
end;

function THelpManager.GetFilter: string;
var
  I: Integer;
  Viewer: ICustomHelpViewer;
  FilteredViewer: IFilteredHelpViewer;
begin
  Result := '';

  if FExtendedViewerList.Count = 0 then
    raise EHelpSystemException.CreateRes(@hNoFilterViewer);

  for I := 0 to FExtendedViewerList.Count - 1 do
  begin
    Viewer := THelpViewerNode(FExtendedViewerList[I]).Viewer;
    if Supports(Viewer, IFilteredHelpViewer, FilteredViewer) then
    begin
      Result := FilteredViewer.GetFilter;
      Break;
    end
    else
      raise EHelpSystemException.CreateRes(@hNoFilterViewer);
  end;
end;

procedure THelpManager.SetFilter(const Filter: string);
var
  I: Integer;
  Viewer: ICustomHelpViewer;
  FilteredViewer: IFilteredHelpViewer;
begin
  if FExtendedViewerList.Count = 0 then
    raise EHelpSystemException.CreateRes(@hNoFilterViewer);

  for I := 0 to FExtendedViewerList.Count - 1 do
  begin
    Viewer := THelpViewerNode(FExtendedViewerList[I]).Viewer;
    if Supports(Viewer, IFilteredHelpViewer, FilteredViewer) then
    begin
      FilteredViewer.SetFilter(Filter);
      Break;
    end
    else
      raise EHelpSystemException.CreateRes(@hNoFilterViewer);
  end;
end;

{ THelpManager --- IHelpManager }

function THelpManager.GetHandle: LongInt;
begin
  Result := Handle;
end;

function THelpManager.GetHelpFile: string;
begin
  Result := HelpFile;
end;

procedure THelpManager.Release(const ViewerID: Integer);
var
  I: Integer;
  HelpNode: THelpViewerNode;
begin
  for I := FExtendedViewerList.Count - 1 downto 0 do
  begin
    if THelpViewerNode(FExtendedViewerList[I]).ViewerID = ViewerID then
    begin
      FExtendedViewerList.Delete(I);
      Break;
    end;
  end;

  for I := FViewerList.Count - 1 downto 0 do
  begin
    HelpNode := THelpViewerNode(FViewerList[I]);

    if HelpNode.ViewerID = ViewerID then
    begin
      FViewerList.Delete(I);
      HelpNode.Free;
      Break;
    end;
  end;
end;

end.
