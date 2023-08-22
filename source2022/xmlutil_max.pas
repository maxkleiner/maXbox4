{***************************************************************}
{                                                               }
{   Borland Delphi Visual Component Library                     }
{                                                               }
{   Copyright (c) 2000-2005 Borland Software Corporation        }
{                                                               }
{***************************************************************}

unit xmlutil_max;

interface

uses
  SysUtils, Classes {, xmldom};

{function SelectNode(Node: IDOMNode; Path: string): IDOMNode;
function SelectCreateNode(Node: IDOMNode; Path: string; var attrs: string): IDOMNode;
function SelectCreateSibling(Node: IDOMNode; CloneNode: IDOMNode): IDOMNode;

function NextCreateElement(El: IDOMNode; tag: string; var attr: string): IDOMNode;
function FindNode(CurrEl: IDOMNode; currtag: Integer; tags: TStrings): IDOMNode;

procedure PutValue(Node: IDOMNode; Path: string; value: string); }
function MapValues(Mapping: string; Value: string): string;
function MakeValueMap(Enumeration: string; ToCds: Boolean): string;

function MapDateTime(const DateFormatType: string; DateFormat: string; Value: string; ToCds: Boolean): string;
function XmlDateTimeToStr(const XmlDateTime: string; const Format: string): string;
function XmlTimeToStr(const XmlTime: string; const Format: string): string;
function StrToXmlDate(const DateStr: string; const Format: string): string;
function StrToXmlDateTime(const DateStr: string; const Format: string): string;
function StrToXmlTime(const TimeStr: string; const Format: string): string;
function getIndex_Attrs(tag: string; var idx: Integer; var Attrs: string):string;
{procedure SetEncoding(Doc: IDOMDocument; Encoding: string; OverWrite: Boolean);
function GetEncoding(Doc: IDOMDocument): string;
procedure SetStandalone(Doc: IDOMDocument; value: string);


function LoadDocFromFile(const XMLFile: string): IDOMDocument;
function LoadDocFromString(const XMLStr: string): IDOMDocument;
function CloneDoc(Doc: IDOMDocument): IDOMDocument;
function GetAttribute(Node: IDOMNode; const name: string): string; }
function Split0(Str: string; const substr: string): TStringList;
function Head(s: string; const subs: string; var tail: string): string;
{function CloneNodeToDoc(const SourceNode: IDOMNode; const TargetDoc: IDOMDocument;
  Deep: Boolean = True): IDOMNode; }

resourcestring
  SMissingSourceFile = 'XMLDataFile must be specified';
  SMissingTransform = 'TransformationFile must be specified';
  SOldVersion = 'Version of Transformation File not supported';
  sFileSaveError = 'Error saving file';
  sFileOpenError = 'Error opening file';
  sXMLFileOpenError = 'Could not open file ';
  sXMLLoadError = 'Error Loading XML';
  sLinePosError = 'Error on line %d, position %d';
  sReason = 'Reason: %s'#10#13;
  sParseError = 'XML Parse Error:'#10#13;
type
  DomException = class(Exception);

const
  mx_Root ='XmlTransformation';
  mx_Transform = 'Transform';
  mx_Skeleton ='Skeleton';
  mx_TranslateEach = 'SelectEach';
  mx_Translate = 'Select';
  mx_XmlSchema = 'XmlSchema';
  mx_CdsSkeleton = 'CdsSkeleton';
  mx_XmlSkeleton = 'XmlSkeleton';
  mx_XSLTransform = 'XslTransform';
  mx_Version = 'Version';
  mx_CurrVersion = '1.0';
  mx_RootName = 'RootName';
  mx_DataEncoding= 'DataEncoding';
  mx_Direction = 'Direction';
  mx_ToXml = 'ToXml';
  mx_ToCds = 'ToCds';
  mx_ID = 'id';
  mx_DEFAULT = 'Default';
  mx_VALUE = 'value';
  mx_OPTIONS = 'Options';
  mx_MAPVALUES = 'Map_Values';
  mx_BOOLFORMAT = 'Format_Bool';
  mx_OPTIONAL = 'Optional';
  mx_DEST = 'dest';
  mx_FROM = 'from';
  mx_DATETIMEFORMAT = 'Format_DateTime';
  mx_DATEFORMAT = 'Format_Date';
  mx_TIMEFORMAT = 'Format_Time';

  mx_Datapacket = 'DATAPACKET';
  mx_ROWDATA = 'ROWDATA';
  mx_ROW = 'ROW';
  mx_RowState = 'RowState';
  val_DateTimeDefault = 'Default Format';

implementation

{procedure DocParseError(Doc: IDOMDocument);
var
  Line, LinePos: Integer;
  Url, Reason: WideString;
  ErrMsg: string;
  ParseError: IDOMParseError;
begin
  ErrMsg := '';
  ParseError := (Doc as IDomParseError);
  if ParseError.errorCode <> 0 then
  begin
    Line := ParseError.Line;
    Linepos := ParseError.LinePos;
    Reason := ParseError.Reason;
    Url := ParseError.url;
    ErrMsg := Format(sReason, [Reason ]);
    if Line > 0 then
    begin
      ErrMsg := ErrMsg + Format(sLinePosError,[Line, LinePos, URL]);
    end;
    ErrMsg := sParseError  + ErrMsg;
    raise DomException.Create(ErrMsg);
  end;
end;

function LoadDocFromFile(const XMLFile: string): IDOMDocument;
begin
  Result := GetDom.createDocument('', '', nil);
  (Result as IDOMParseoptions).validate:= false;
  (Result as IDomPersist).Load(XMLFile);
  if (Result as IDOMParseError).errorCode <> 0 then
  begin
    DocParseError(Result);
    Result:= nil;
  end;
end;

function LoadDocFromString(const XMLStr: string): IDOMDocument;
var
  vonparse: boolean;
begin
  Result := GetDom.createDocument('', '', nil);
  vonparse:= (Result as IDOMParseoptions).validate;
  (Result as IDOMParseoptions).validate:= false;
  (Result as IDomPersist).loadXML(XMLStr);
  if (Result as IDOMParseError).errorCode <> 0 then
  begin
    DocParseError(Result);
    Result:= nil;
  end;
  if vonparse <> false then
    (Result as IDOMParseoptions).validate:= vonparse;
end;  }

function getIndex_Attrs(Tag: string; var Idx: Integer; var Attrs: string): string;
var
  I, Iend: Integer;
  SIdx: string;
begin
  Attrs := '';
  I := ansipos('@', tag);
  if I > 0 then
  begin
    Attrs := tag;
    delete(Attrs, 1, I);
    delete(Tag, I, length(Tag));
  end;
  I := ansipos('[', Tag);
  if (I > 0) then
  begin
    SIdx := tag;
    delete(SIdx, 1, I);
    IEnd := ansipos(']', SIdx);
    delete(SIdx, IEnd, length(SIdx));
    if SIdx = '*' then
      Idx := -3
    else
      Idx := strtoint(SIdx);
    delete(Tag, I, length(Tag));
  end;
  Result := Tag;
end;

{function FindNode(CurrEl: IDOMNode; CurrTag: Integer; Tags: TStrings): IDOMNode;
var
  Tag: string;
  Childs: IDOMNodeList;
  I, Idx, CompareIdx: Integer;
  Attrs: string;
begin
  Result := CurrEl;
  if CurrTag < Tags.count then
  begin
    Result := nil;
    Tag := Tags[CurrTag];
    Idx := -2;
    CompareIdx := 0;
    Tag := getIndex_Attrs(Tag, Idx, Attrs);
    if (Tag <> '') and (CurrEl <> nil) then
    begin
      Childs := CurrEl.childNodes;
      if (Idx <> -2) then
      begin
        for I := 0 to Childs.length-1 do
        begin
          if (ExtractLocalName(Childs.item[I].localName) = Tag) or (Childs.item[I].NodeName = Tag) then
          begin
            if (Idx = -3) or (Idx = CompareIdx) then
            begin
              Result := FindNode(Childs.item[i], CurrTag + 1, Tags);
              break;
            end
            else
              CompareIdx := CompareIdx + 1;
          end
        end;
      end
      else //Try each, until found
      begin
        if Tag = '..' then //Special case, go back one step
          Result := FindNode(CurrEl.parentNode, CurrTag + 1, Tags)
        else
        begin
          for I := 0 to Childs.length-1 do
          begin
            if (ExtractLocalName(Childs.item[I].localName) = Tag) or (Childs.item[I].NodeName = Tag) then
            begin
              Result := FindNode(Childs.item[I], CurrTag + 1, Tags);
              if (Result <> nil) then
                break;
            end;
          end
        end;
      end;
    end
    else
      if (Tag = '') and (length(Attrs) > 0) then
        Result := CurrEl;
    if Result <> nil then
      if length(Attrs) <> 0  then
        Result := Result.attributes.getNamedItem(Attrs);
  end;
end;

function NextCreateElement(El: IDOMNode; Tag: string; var Attr: string): IDOMNode;
var
  Childs: IDOMNodeList;
  Child: IDOMNode;
  I, Idx, CompareIdx: Integer;
  Attrs: string;
  Found: Boolean;
begin
  Result := El;
  Idx := 0;
  CompareIdx := 0;
  Tag := getIndex_Attrs(Tag, Idx, Attrs);
  Attr := '';
  if (Tag <> '') and (El <> nil) then
  begin
    Childs := El.childNodes;
    Found := false;
    for I := 0 to Childs.length - 1 do
    begin
      if (ExtractLocalName(Childs.item[I].localName) = Tag) or (Childs.item[I].NodeName = Tag) then
      begin
        if (Idx = -3) or (Idx = CompareIdx) then
        begin
          Result := Childs.item[I];
          Found := true;
          break;
        end
        else
          CompareIdx := CompareIdx + 1;
      end;
    end;
    if (Found = false) and (Tag <> '') then
    begin
      Child := El.ownerDocument.createElement(Tag);
      if Child <> nil then
      begin
        El.appendChild(Child);
        Result := Child;
      end
    end;
  end;
  if Result <> nil then
  begin
    if length(Attrs) <> 0  then
      Attr := Attrs;
  end;
end;

function SelectCreateNode(Node: IDOMNode; Path: string; var Attrs: string): IDOMNode;
var
  Tags: TStringList;
  I, Istart: Integer;
begin
  Tags := Split0(Path, '\');
  try
    if Tags.Count = 0 then
    begin
      Result := nil;
      exit;
    end;
    IStart := 0;
    if ExtractLocalName(Node.NodeName) = Tags.Strings[0] then
      IStart := 1;

    for I := istart to Tags.Count-1 do
      Node := NextCreateElement(Node, Tags.Strings[I], Attrs);
  finally
    Tags.Free;
  end;
  Result := Node;
end;

function SelectNode(Node: IDOMNode; Path: string): IDOMNode;
var
  Tags: TStringList;
  IStart: Integer;
begin
  if (Path = '') or (Node = nil) then
    Result := Node
  else
  begin
    Tags := Split0(Path, '\');
    try
      IStart := 0;
      if ExtractLocalName(Node.NodeName) = Tags.Strings[0] then //sync tag with node..special case
        IStart := 1;
      Node := FindNode(Node, IStart, Tags);
    finally
      Tags.Free;
    end;
    Result := Node;
  end;
end;

function SelectCreateSibling(Node: IDOMNode; CloneNode: IDOMNode): IDOMNode;
var
  Parent, NewNode: IDOMNode;
begin
  Parent := Node.parentNode;
  if Parent.nodeType = Document_Node then
    Result := nil
  else
  begin
    if CLoneNode = nil then
      newNode := Node.ownerDocument.createElement(Node.nodeName)
    else
      newNode := CloneNode.cloneNode(true);
    Parent.appendChild(newNode);
    Result := NewNode;
  end;
end;

procedure PutValue(Node: IDOMNode; Path: string; Value: string);
var
  TxtNode, AttrNode: IDOMNode;
  Tags: TStringList;
  I, IStart: Integer;
  Attr: string;
begin
  Tags := Split0(Path, '\');
  try
    IStart := 0;
    if ExtractLocalName(Node.NodeName) = Tags.Strings[0] then
      IStart := 1;
    for I := istart to Tags.Count-1 do
    begin
      Node := NextCreateElement(Node, Tags.Strings[I], attr);
    end;
    if Node <> nil then
    begin
      if Attr <> '' then
      begin
        AttrNode := Node.ownerDocument.createAttribute(attr);
        AttrNode.nodeValue := Value;
        Node.attributes.setNamedItem(AttrNode);
      end
      else
      begin
        TxtNode:=Node.ownerDocument.createTextNode(value);
        Node.appendChild(TxtNode);
      end;
    end;
  finally
    Tags.Free;
  end;
end;

function CloneDoc(Doc: IDOMDocument): IDOMDocument;
begin
  Result := LoadDocFromString((Doc as IDOMPersist).xml);
end; }

function Split0(Str: string; const SubStr: string): TStringList;
var
  S, Tmp: string;
  Slist: TStringList;
  I: Integer;
begin
  Slist := TStringList.Create;
  S := Str;
  while (length(S) > 0) do
  begin
    I := ansipos(substr, S);
    if (I = 0) then
    begin
      Slist.Add(s);
      delete(S, 1, length(S));
    end
    else
    begin
      if (I = 1) then
      begin
        delete(S, 1, length(SubStr));
      end
      else
      begin
        Tmp := S;
        delete(Tmp, I, length(Tmp));
        slist.Add(Tmp);
        delete(S, 1, I + length(SubStr)-1);
      end;
    end;
  end;
  Result := Slist;
end;

function Head(S: string; const Subs: string; var Tail: string): string;
var
  I: Integer;
begin
  I:= ansipos(Subs, S);
  if  I = 0 then
  begin
    Result := S;
    Tail := '';
  end
  else
  begin
    Tail := S;
    delete(Tail, 1, I + length(Subs) - 1);
    delete(S, I, length(S));
    Result := S;
  end;
end;

function replace(S: string; const Find: string; const Replace: string): string;
begin
  Result := '';
  while ansipos(Find, S) > 0 do
  begin
    Result := Result + Head(S, Find, S) + Replace
  end;
  Result := Result + S;
end;

{function GetAttribute(Node: IDOMNode; const Name: string): string;
var
  Attr: IDOMNode;
begin
  Result := '';
  if (Node <> nil) and (Node.attributes <> nil) then
  begin
    Attr := Node.attributes.GetNamedItem(Name);
    if Attr <> nil then
      Result := Attr.nodeValue;
  end;
end; }

function EncodeXmlDate(Y: Word; M: Word; D: Word): string;
begin
  Result := '';
  if Y < 1000 then
  begin
    Result := Result + '0';
    if Y < 100 then
    begin
      Result := Result + '0';
      if Y < 10 then
        Result := Result + '0'
    end
  end;
  Result := Result + IntToStr(Y);
  if M < 10 then
    Result := Result + '0';
  Result := Result + IntToStr(M);
  if D < 10 then
    Result := Result + '0';
  Result := Result + IntToStr(D);
end;

function EncodeXmlTime(H: Word; M: Word; S: Word; MS: Word): string;
begin
  Result := '';
  if H < 10 then
     Result := Result+'0';
  Result := Result+IntToStr(H) + ':';
  if M < 10 then
     Result := Result + '0';
  Result := Result + IntToStr(M) + ':';
  if S < 10 then
     Result := Result + '0';
  Result := Result + IntToStr(S) + ':';
  if MS < 1000 then
  begin
    if MS < 100 then
    begin
       if MS < 10 then
          Result := Result + '000'
       else
          Result := Result + '00';
    end
    else
      Result := Result + '0';
  end;
  Result := Result + IntToStr(MS);
end;

function StrToXmlDate(const DateStr: string; const Format: string): string;
var
  Date: TDateTime;
  Y, M, D: Word;
  Store: string;
begin
try
  if Format <> '' then
  begin
    Store := ShortDateFormat;
    ShortDateFormat := Format;
  end;
  try
    Date := StrToDate(DateStr);
    DecodeDate(Date, Y, M, D);
    Result := EncodeXmlDate(Y, M, D);
  except
    Result := '';
  end;
finally
  if Format <> '' then
  begin
    ShortDateFormat := Store;
  end;
end;
end;

function StrToXmlDateTime(const DateStr: string; const Format: string): string;
var
  Date: TDateTime;
  Y, M, D: Word;
  H, Min, S, MS: Word;
  TimeStr, Store: string;
begin
  try
    if Format <> '' then
    begin
      Store := ShortDateFormat;
      ShortDateFormat := Format;
    end;
    try
      Date := StrToDateTime(DateStr);
      DecodeDate(Date, Y, M, D);
      Result := EncodeXmlDate(Y, M, D);
      DecodeTime(Date, H, Min, S, MS);
      TimeStr := EncodeXmlTime(H, Min, S, MS);
      Result := Result + 'T' + TimeStr;
    except
      Result := '';
    end;
  finally
    if Format <> '' then
      ShortDateFormat := Store;
  end;
end;

function StrToXmlTime(const TimeStr: string; const Format: string): string;
var
  Date: TDateTime;
  H, Min, S, MS: Word;
  Store: string;
begin
  try
    if (Format <> '') then
    begin
      Store := LongTimeFormat;
      LongTimeFormat := Format;
    end;
    try
      Date := StrToTime(TimeStr);
      DecodeTime(Date, H, Min, S, MS);
      Result := EncodeXmlTime(H, Min, S, MS);
    except
      Result := '';
    end;
  finally
    if Format <> '' then
    begin
      LongTimeFormat := Store;
    end;
  end;
end;


function DecodeXmlDate(XmlDate: string): TDateTime;
var
  YStr, MStr, DStr: string;
  p: Word;
begin
  if XmlDate = '' then
    Result := 0
  else
    try
      YStr := Copy(XmlDate, 1, 4);
      p :=5;
      if (XmlDate[5] > '9') or (XmlDate[5] < '0') then
        p := p + 1;
      MStr := Copy(Xmldate, p, 2);
      p := p+2;
      if (XmlDate[p] > '9') or (XmlDate[p] < '0') then
        p := p + 1;
      DStr := Copy(XmlDate, p, 2);
      Result := EncodeDate(StrToInt(YStr), StrToInt(MStr), StrToInt(DStr));
    except
      Result := 0;
    end;
end;

function DecodeXmlTime(XmlTime: string): TDateTime;
var
  HStr, MStr, SStr, MSStr: string;
  p: Word;
begin
  if XmlTime = '' then
    Result := 0
  else
    try
      p := 1;
      HStr:= Copy(XmlTime, p, 2);
      if HStr = '' then HStr:= '0';
      p := p+2;
      if (XmlTime[p]>'9') or (XmlTime[p]< '0') then
        p := p+1;
      MStr:= Copy(XmlTime, p, 2);
      if MStr = '' then MStr:= '0';
      p:= p+2;
      if (XmlTime[p]>'9') or (XmlTime[p]< '0') then
        p:= p+1;
      SStr:= Copy(XmlTime, p, 2);
      if SStr = '' then SStr:= '0';
      p := p+2;
      if (XmlTime[p]>'9') or (XmlTime[p]< '0') then
        p := p+1;
      MSStr := Copy(XmlTime, p, 4); //5 ?
      if MSStr = '' then
        MSStr:= '0';
      Result:= EncodeTime(StrToInt(HStr), StrToInt(MStr), StrToInt(SStr), StrToInt(MSStr));
    except
      Result:= 0;
    end;
end;

function XmlDateTimeToStr(const XmlDateTime: string; const Format: string): string;
var
  Date: TDateTime;
  Time: TDateTime;
  DateStr, TimeStr: string;
begin
  DateStr := Head(XmldateTime, 'T', TimeStr);
  Date := DecodeXmlDate(DateStr);
  if TimeStr <> '' then
  begin
    Time := DecodeXmlTime(TimeStr);
    Date := Date + Time;
  end;
  if Format <> '' then
    DateTimeToString(Result, Format, Date)
  else
    Result := DateTimeToStr(Date);
end;

function XmlTimeToStr(const XmlTime: string; const Format: string): string;
var
  Time: TDateTime;
  Store: string;
begin
  Time := DecodeXmlTime(XmlTime);
  if Format <> '' then
  begin
    Store := LongTimeFormat;
    LongTimeFormat := Format;
  end;
  try
    Result :=  TimeToStr(Time);
  finally
    if Format <> '' then
      LongTimeFormat := Store;
  end
end;

function MapValue(StrList: string; KeyName: string):string;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.CommaText := StrList;
    Result := List.Values[KeyName];
  finally
    List.Free;
  end;
end;

function MapDateTime(const DateFormatType: string; DateFormat:string; Value: string; ToCds: Boolean):string;
begin
  if DateFormat = val_DateTimeDefault then
    DateFormat := '';
  if DateFormatType = mx_DATETIMEFORMAT then
  begin
    if ToCds then
      Result := StrToXmlDateTime(Value, DateFormat)
    else
      Result := XmlDateTimeToStr(Value, DateFormat);
  end
  else
  if DateFormatType = mx_DATEFORMAT then
  begin
    if ToCds then
      Result := StrToXmlDate(Value, DateFormat)
    else
      Result := XmlDateTimeToStr(Value, DateFormat);
  end
  else
  if DateFormatType = mx_TIMEFORMAT then
  begin
    if ToCds then
      Result := StrToXmlTime(Value, DateFormat)
    else
      Result := XmlTimeToStr(Value, DateFormat);
  end
  else
    Result := '';
end;

function MakeValueMap(Enumeration : string; ToCds: Boolean): string;
var
  List, ListInvert: TStringList;
  I: Integer;
begin
  Enumeration := Replace(Enumeration,'= ', '=');
  Enumeration := Replace(Enumeration,' =', '=');
  if not ToCds then
  begin
    List := TStringList.Create;
    ListInvert := TStringList.Create;
    try
      List.CommaText := Enumeration;
      for I := 0 to List.Count-1 do
      begin
        if ansipos('=', List.Strings[I]) > 0 then
          ListInvert.Add(List.Values[List.Names[I]]+'='+ List.Names[I])
        else
          ListInvert.Add(List.Strings[I]);
      end;
      Result := ListInvert.CommaText;
    finally
      List.Free;
      ListInvert.Free;
    end;
  end
  else
  begin
    List := TStringList.Create;
    try
      List.CommaText := Enumeration;
      Result := List.CommaText;
    finally
      List.Free;
    end;
  end;
end;

function MapValues(Mapping: string; Value: string): string;
var
  Map: TStringList;
  I: Integer;
begin
  Map := TStringList.Create;
  try
    Map.CommaText := Mapping;
    Result := Map.Values[Value];
    if Result = '' then
    begin
      I := Map.IndexOf(Value);
      if I >= 0 then
        Result := Map.Strings[I]
      else
        Result := ''; // Not in the list
    end
  finally
    Map.Free;
  end;
end;

{function GetEncoding(Doc: IDOMDocument): string;
var
  I, P: Integer;
  Node: IDOMNode;
  Value, S: string;
  PrologInfo: IDOMXMLProlog;
begin
  if Assigned(Doc) and (Doc.QueryInterface(IDOMXMLProlog, PrologInfo) = S_OK) then
    Result := PrologInfo.Encoding
  else
  begin
    Result := '';
    if (Doc <> nil) and (Doc.ChildNodes.Length > 0) then
      for I := 0 to Doc.ChildNodes.Length-1 do
      begin
        Node := Doc.ChildNodes[I];
        if Node.NodeType = 7 then // NODE_PROCESSING_INSTRUCTION
        begin
          if Node.nodeName = 'xml' then
          begin
            Value := Node.NodeValue;
            P := ansipos('encoding="', Value);
            if P > 0 then
            begin
              S := copy(Value, P + Length('encoding="'), Length(Value));
              P := ansipos('"', S);
              S := copy(S, 0, P-1);
              Result := S;
              Exit;
            end;
          end;
        end;
      end;
  end;
end;

procedure SetEncoding(Doc: IDOMDocument; Encoding: string; OverWrite: Boolean);
var
  I, P: Integer;
  Node, NodeNew: IDOMNode;
  Value: string;
  CurrEncoding: string;
  PrologInfo: IDOMXMLProlog;
begin
  CurrEncoding:= GetEncoding(Doc);
  if (CurrEncoding <> '') and (not OverWrite) then exit;
  if (CurrEncoding = '') and (Encoding = '' ) then exit;
  if Assigned(Doc) and (Doc.QueryInterface(IDOMXMLProlog, PrologInfo) = S_OK) then
    PrologInfo.Encoding := Encoding
  else if (Doc <> nil) and (Doc.ChildNodes.Length > 0) then
  begin
    for I := 0 to Doc.ChildNodes.Length-1 do
    begin
      Node := Doc.ChildNodes[I];
      if Node.NodeType = 7 then // NODE_PROCESSING_INSTRUCTION
      begin
        if Node.nodeName = 'xml' then
        begin
          Value := Node.NodeValue;
          if CurrEncoding = '' then
          begin
            Value := Value + ' '+ 'encoding="' + Encoding + '"';
          end
          else
          begin
            P := ansipos(CurrEncoding, Value);
            if P = 0 then
              continue;
            if Encoding = '' then
              Value := Replace(Value,'encoding="' + CurrEncoding + '"' , ' ')
            else
              Value := Replace(Value,'encoding="' + CurrEncoding + '"', 'encoding="' + Encoding + '"');
          end;
          if Value <> Node.nodeValue then
          begin
             NodeNew := Doc.createProcessingInstruction('xml', Value);
             Doc.ReplaceChild(NodeNew, Node);
          end;
          break;
        end;
      end;
    end;
  end;
end;

procedure SetStandalone(Doc: IDOMDocument; value: string);
var
  PrologInfo: IDOMXMLProlog;
begin
  if Assigned(Doc) and (Doc.QueryInterface(IDOMXMLProlog, PrologInfo) = S_OK) then
    PrologInfo.Standalone := value;
end;

function CloneNodeToDoc(const SourceNode: IDOMNode; const TargetDoc: IDOMDocument;
  Deep: Boolean = True): IDOMNode;
var
  I: Integer;
begin
  case SourceNode.nodeType of
    ELEMENT_NODE:
      with SourceNode as IDOMElement do
      begin
        if NamespaceURI <> '' then
          Result := TargetDoc.createElementNS(namespaceURI, tagName)
        else
          Result := TargetDoc.createElement(tagName);
        for I := 0 to attributes.length - 1 do
          (Result as IDOMElement).setAttributeNode(CloneNodeToDoc(attributes[I], TargetDoc, False) as IDOMAttr);
        if Deep then
          for I := 0 to childNodes.length - 1 do
            (Result as IDOMElement).appendChild(CloneNodeToDoc(childNodes[I], TargetDoc, Deep));
      end;
    ATTRIBUTE_NODE:
      with SourceNode as IDOMAttr do
      begin
        if NamespaceURI <> '' then
          Result := TargetDoc.createAttributeNS(namespaceURI, NodeName)
        else
          Result := TargetDoc.createAttribute(NodeName);
        Result.nodeValue := NodeValue;
        // More to do here?
      end;
    TEXT_NODE:
      begin
        Result := TargetDoc.createTextNode(SourceNode.nodeValue);
      end;
    CDATA_SECTION_NODE:
      begin
        Result := TargetDoc.createCDATASection(SourceNode.nodeValue);
      end;
    ENTITY_REFERENCE_NODE:
      begin
        Result := TargetDoc.createEntityReference(SourceNode.nodeName);
      end;
    PROCESSING_INSTRUCTION_NODE:
      with SourceNode as IDOMProcessingInstruction do
      begin
        Result := TargetDoc.createProcessingInstruction(target, data);
      end;
    COMMENT_NODE:
      begin
        Result := TargetDoc.createComment(SourceNode.nodeValue);
      end;
    DOCUMENT_FRAGMENT_NODE:
      with SourceNode as IDOMDocumentFragment do
      begin
        Result := TargetDoc.createDocumentFragment;
        if Deep then
          for I := 0 to childNodes.length - 1 do
            (Result as IDOMElement).appendChild(CloneNodeToDoc(childNodes[I], TargetDoc, Deep));
      end;
  else
    raise Exception.Create('SCannotClone');
  end;
end;}

end.
