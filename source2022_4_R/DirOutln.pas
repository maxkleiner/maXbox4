unit DirOutln;

{ Directory outline component }

interface

uses Classes, Forms, Controls, Outline, SysUtils, Graphics, Grids, StdCtrls,
     Menus;

type
  TTextCase = (tcLowerCase, tcUpperCase, tcAsIs);
  TCaseFunction = function(const AString: string): string;

  TDirectoryOutline = class(TCustomOutline)
  private
    FDrive: Char;
    FDirectory: TFileName;
    FOnChange: TNotifyEvent;
    FTextCase: TTextCase;
    FCaseFunction: TCaseFunction;
  protected
    procedure SetDrive(NewDrive: Char);
    procedure SetDirectory(const NewDirectory: TFileName);
    procedure SetTextCase(NewTextCase: TTextCase);
    procedure AssignCaseProc;
    procedure BuildOneLevel(RootItem: Longint); virtual;
    procedure BuildTree; virtual;
    procedure BuildSubTree(RootItem: Longint); virtual;
    procedure Change; virtual;
    procedure Click; override;
    procedure CreateWnd; override;
    procedure Expand(Index: Longint); override;
    function FindIndex(RootNode: TOutLineNode; SearchName: TFileName): Longint;
    procedure Loaded; override;
    procedure WalkTree(const Dest: string);
  public
    constructor Create(AOwner: TComponent); override;
    function ForceCase(const AString: string): string;
    property Drive: Char  read FDrive write SetDrive;
    property Directory: TFileName  read FDirectory write SetDirectory;
    property Lines stored False;
  published
    property Align;
    property Anchors;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ItemHeight;
    property Options default [ooStretchBitmaps, ooDrawFocusRect];
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PictureClosed;
    property PictureLeaf;
    property PictureOpen;
    property PopupMenu;
    property ScrollBars;
    property Style;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TextCase: TTextCase  read FTextCase write SetTextCase default tcLowerCase;
    property Visible;
    property OnChange: TNotifyEvent  read FOnChange write FOnChange;
    property OnClick;
    property OnCollapse;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpand;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

function SameLetter(Letter1, Letter2: Char): Boolean;


implementation

const
  InvalidIndex = -1;

constructor TDirectoryOutline.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  PictureLeaf := PictureClosed;
  Options := [ooDrawFocusRect];
  TextCase := tcLowerCase;
  AssignCaseProc;
end;

procedure TDirectoryOutline.AssignCaseProc;
begin
  case TextCase of
    tcLowerCase: FCaseFunction := AnsiLowerCaseFileName;
    tcUpperCase: FCaseFunction := AnsiUpperCaseFileName;
    else FCaseFunction := nil;
  end;
end;

type
  PNodeInfo = ^TNodeInfo;
  TNodeInfo = record
    RootName: TFileName;
    SearchRec: TSearchRec;
    DosError: Integer;
    RootNode: TOutlineNode;
    TempChild, NewChild: Longint;
  end;

function TDirectoryOutline.FindIndex(RootNode: TOutLineNode;
  SearchName: TFileName): Longint;
var
  FirstChild, LastChild, TempChild: Longint;
begin
  FirstChild := RootNode.GetFirstChild;
  if (FirstChild = InvalidIndex) or
     (SearchName <= Items[FirstChild].Text) then
       FindIndex := FirstChild
  else
  begin
    LastChild := RootNode.GetLastChild;
    if (SearchName >= Items[LastChild].Text) then
      FindIndex := InvalidIndex
    else
    begin
      repeat
        TempChild := (FirstChild + LastChild) div 2; { binary search }
        if (TempChild = FirstChild) then Inc(TempChild);
        if (SearchName > Items[TempChild].Text) then
          FirstChild := TempChild
        else LastChild := TempChild
      until FirstChild >= (LastChild - 1);
      FindIndex := LastChild
    end
  end
end;

procedure TDirectoryOutline.BuildOneLevel(RootItem: Longint);
var
  NodeInfo: PNodeInfo;
  P: Integer;
begin
  New(NodeInfo);
  try
    with NodeInfo^ do
    begin
      RootName := Items[RootItem].FullPath;
      P := AnsiPos(':\\', RootName);
      if P <> 0 then System.Delete(RootName, P + 2, 1);
      if (RootName <> '') and (AnsiLastChar(RootName) <> '\') then
        RootName := Concat(RootName, '\');
      RootName := Concat(RootName, '*.*');
      DosError := FindFirst(RootName, faDirectory, SearchRec);
      try
        while DosError = 0 do
        begin
          if (SearchRec.Attr and faDirectory = faDirectory) and (SearchRec.Name[1] <> '.') then
          begin
            SearchRec.Name := ForceCase(SearchRec.Name);
            RootNode := Items[RootItem];
            if RootNode.HasItems then { if has children, must alphabetize }
            begin
              TempChild := FindIndex(RootNode, SearchRec.Name);
              if TempChild <> InvalidIndex then
                NewChild := Insert(TempChild, SearchRec.Name)
              else NewChild := Add(RootNode.GetLastChild, SearchRec.Name);
            end
            else NewChild := AddChild(RootItem, SearchRec.Name); { if first child, just add }
          end;
          DosError := FindNext(SearchRec);
        end;
      finally
        FindClose(SearchRec);
      end;
    end;
    Items[RootItem].Data := Pointer(1); { make non-nil so we know we've been here }
  finally
    Dispose(NodeInfo);
  end;
end;

procedure TDirectoryOutline.BuildTree;
begin
  Clear;
  AddChild(0, ForceCase(Drive + ':\'));
  WalkTree(FDirectory);
  Change;
end;

procedure TDirectoryOutline.BuildSubTree(RootItem: Longint);
var
  TempRoot: Longint;
  RootNode: TOutlineNode;
begin
  BuildOneLevel(RootItem);
  RootNode := Items[RootItem];
  TempRoot := RootNode.GetFirstChild;
  while TempRoot <> InvalidIndex do
  begin
    BuildSubTree(TempRoot);
    TempRoot := RootNode.GetNextChild(TempRoot);
  end;
end;

procedure TDirectoryOutline.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TDirectoryOutline.Click;
var
  P: Integer;
  S: string;
begin
  inherited Click;
  S := Items[SelectedItem].FullPath;
  P := AnsiPos(':\\', S);
  if P <> 0 then System.Delete(S, P + 2, 1);
  Directory := S;
end;

procedure TDirectoryOutline.CreateWnd;
var
  CurrentPath: string;
begin
  inherited CreateWnd;
  if FDrive = #0 then
  begin
    GetDir(0, CurrentPath);
    FDrive := ForceCase(CurrentPath)[1];
    FDirectory := ForceCase(CurrentPath);
  end;
  if (not (csLoading in ComponentState)) and
    (csDesigning in ComponentState) then BuildTree;
end;

procedure TDirectoryOutline.Expand(Index: Longint);
begin
  if Items[Index].Data = nil then { if we've not previously expanded }
    BuildOneLevel(Index);
  inherited Expand(Index); { call the event handler }
end;

function TDirectoryOutline.ForceCase(const AString: string): string;
begin
  if Assigned(FCaseFunction) then
    Result := FCaseFunction(AString)
  else Result := AString;
end;

procedure TDirectoryOutline.Loaded;
begin
  inherited Loaded;
  AssignCaseProc;
  BuildTree;
end;

procedure TDirectoryOutline.SetDirectory(const NewDirectory: TFileName);
var
  TempPath: TFileName;
begin
  if Length(NewDirectory) > 0 then  { ignore empty directory }
  begin
    if Copy(NewDirectory, Length(NewDirectory) - 1, 2) = ':\' then
      TempPath := ForceCase(NewDirectory)
    else
      TempPath := ForceCase(ExpandFileName(NewDirectory)); { expand to full path }
    if (Length(TempPath) > 3) and (AnsiLastChar(TempPath) = '\') then
      SetLength(TempPath, Length(TempPath) - 1);
    if AnsiCompareFileName(TempPath, FDirectory) <> 0 then { is it a dir change? }
    begin
      FDirectory := TempPath; { set new directory }
      ChDir(FDirectory); { go there }
      if TempPath[1] <> Drive then { check to see if we changed drives, too }
        Drive := TempPath[1] { change drive/build list if needed }
      else
      begin
        if Copy(FDirectory, Length(FDirectory) - 1, 2) = ':\' then
          WalkTree(TempPath);
        Change; { otherwise, we're done }
      end;
    end;
  end;
end;

procedure TDirectoryOutline.SetDrive(NewDrive: Char);
var
  TempPath: string;
begin
  if UpCase(NewDrive) in ['A'..'Z'] then { disallow all but drive letters}
  begin
    if (FDrive = #0) or not SameLetter(NewDrive, FDrive) then { update if no current drive or change }
    begin
      FDrive := NewDrive;
      ChDir(FDrive + ':\');
      GetDir(0, TempPath);
      FDirectory := ForceCase(TempPath); { use correct case }
      if not (csLoading in ComponentState) then BuildTree; { this ends up calling Change }
    end;
  end;
end;

procedure TDirectoryOutline.SetTextCase(NewTextCase: TTextCase);
var
  CurrentPath: string;
begin
  if NewTextCase <> FTextCase then
  begin
    FTextCase := NewTextCase;
    AssignCaseProc;
    if NewTextCase = tcAsIs then
    begin
      GetDir(0, CurrentPath);
      FDrive := CurrentPath[1];
      FDirectory := CurrentPath;
    end;
    if not (csLoading in ComponentState) then BuildTree;
  end;
end;

procedure TDirectoryOutline.WalkTree(const Dest: string);
var
  TempPath, NextDir: TFileName;
  SlashPos: Integer;
  TempItem: Longint;

  function GetChildNamed(const Name: string): Longint;
  begin
    Items[TempItem].Expanded := True;
    Result := Items[TempItem].GetFirstChild;
    while Result <> InvalidIndex do
    begin
      if Items[Result].Text = Name then Exit;
      Result := Items[TempItem].GetNextChild(Result);
    end;
  end;

begin
  TempItem := 1; { start at root }
  TempPath := ForceCase(Dest);
  if Pos(':', TempPath) > 0 then
    TempPath := Copy(TempPath, Pos(':', TempPath) + 1, Length(TempPath));
  if TempPath[1] = '\' then System.Delete(TempPath, 1, 1);
  NextDir := TempPath;
  while Length(TempPath) > 0 do
  begin
    SlashPos := AnsiPos('\', TempPath);
    if SlashPos > 0 then
    begin
      NextDir := Copy(TempPath, 1, SlashPos - 1);
      TempPath := Copy(TempPath, SlashPos + 1, Length(TempPath));
    end
    else
    begin
      NextDir := TempPath;
      TempPath := '';
    end;
    TempItem := GetChildNamed(NextDir);
  end;
  SelectedItem := TempItem;
end;

function SameLetter(Letter1, Letter2: Char): Boolean;
begin
  Result := UpCase(Letter1) = UpCase(Letter2);
end;

end.
