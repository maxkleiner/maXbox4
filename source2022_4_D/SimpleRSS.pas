{
--------------------------------------------------------------------------------
SimpleRSS Version 0.4 (BlueHippo)

http://simplerss.sourceforge.net
Provides a simple methods for accessing, importing, exporting and working with RSS, RDF, Atom & iTunes Feeds

SimpleRSS Originally Created By Robert MacLean
SimpleRSS (C) Copyright 2003-2005 Robert MacLean. All Rights Reserved World Wide

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.
This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

This File Originally Created By Robert MacLean <dfantom@gmail.com> 2003
Additional work by:
 - Thomas Zangl <thomas@tzis.net> 2005
--------------------------------------------------------------------------------
}
unit SimpleRSS;

interface
uses
  SysUtils,
  Classes,
  SimpleRSSTypes,
  XMLDoc,
  XMLIntf,
  XMLDOM,
  Variants,
  idHTTP;

type
  TSimpleRSS = class(TComponent)
  private
    FChannel: TRSSChannel;
    FItems: TRSSItems;
    FVersion: string;
    FXMLType: TXMLType;
    FXMLFile: TXMLDocument;
    FIndyHTTP: TIdHTTP;
    FOnParseXML: TNotifyEvent;
    FOnCreate: TNotifyEvent;
    FOnGenerateXML: TNotifyEvent;
    Procedure SetChannel(const Value: TRSSChannel);
    Procedure SetItems(const Value: TRSSItems);
    Procedure SetVersion(const Value: string);
    Procedure SetIndyHTTP(const Value: TIdHTTP);
    function GetSimpleRSSVersion: String;
    procedure SetOnCreate(const Value: TNotifyEvent);
    procedure SetOnGenerateXML(const Value: TNotifyEvent);
    procedure SetOnParseXML(const Value: TNotifyEvent);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Procedure SaveToFile(Filename: string);
    Function SaveToString: string;
    Procedure SaveToStream(Stream: TStream);
    Function SaveToStrings: TStrings;
    Procedure LoadFromHTTP(URL:String);
    Procedure LoadFromString(S: string);
    Procedure LoadFromFile(Filename: string);
    Procedure LoadFromStream(Stream: TStream);
    Procedure LoadFromStrings(Strings: TStrings);
    Procedure GenerateXML;overload;
    Procedure GenerateXML(FeedType:TXMLType);overload;
    Procedure GenerateComponent;
    Procedure ClearXML;
  published
    { Published declarations }
    property Channel: TRSSChannel read FChannel write SetChannel;
    property Items: TRSSItems read FItems write SetItems;
    property Version: string read FVersion write SetVersion;
    property XMLType: TXMLType read FXMLType write FXMLType;
    property XMLFile: TXMLDocument read FXMLFile;
    Property IndyHTTP : TIdHTTP Read FIndyHTTP Write SetIndyHTTP;
    Property SimpleRSSVersion:String Read GetSimpleRSSVersion;
    Property OnCreate:TNotifyEvent Read FOnCreate Write SetOnCreate;
    Property OnGenerateXML:TNotifyEvent Read FOnGenerateXML Write SetOnGenerateXML;
    Property OnParseXML:TNotifyEvent Read FOnParseXML Write SetOnParseXML;
  end;

Procedure Register;

implementation

uses
  SimpleRSSConst,
  SimpleParserRDF,
  SimpleParserRSS,
  SimpleParserAtom,
  SimpleParserBase, SimpleParseriTunes;

Procedure Register;
begin
  RegisterComponents('WebTools', [TSimpleRSS]);
end;
{ TSimpleRSS }

Procedure TSimpleRSS.ClearXML;
begin
  FXMLFile.Active := False;
  FXMLFile.Free;
  FXMLFile := TXMLDocument.Create(Self);
  FXMLFile.Active := True;
end;

constructor TSimpleRSS.Create(AOwner: TComponent);
begin
  inherited;
  FChannel := TRSSChannel.Create;
  FItems := TRSSItems.Create(Self, TRSSItem);
  FXMLFile := TXMLDocument.Create(Self);
  FXMLFile.Active := True;
  FVersion := strRSSVersion;
  FXMLType := xtRSS;
  FXMLFile.Options := [doNodeAutoCreate,doAttrNull,doAutoPrefix,doNodeAutoIndent];
  If Assigned(FOnCreate) then
    FOnCreate(Self);
end;

destructor TSimpleRSS.Destroy;
begin
  if FChannel <> nil then
    FChannel.Free;
  if FItems <> nil then
    FItems.Free;
  if FXMLFile <> nil then
    FXMLFile.Free;
  inherited;
end;

Procedure TSimpleRSS.GenerateComponent;
var
  aParser: TSimpleParserBase;
begin
  FChannel.Free;
  FChannel := TRSSChannel.Create;
  FItems.Free;
  FItems := TRSSItems.Create(Self, TRSSItem);

  If (LowerCase(FXMLFile.DocumentElement.NodeName) = reFormatRDF) then
    Begin
      FXMLType := xtRDF
    end // if then
  else
    Begin
      if (LowerCase(FXMLFile.DocumentElement.NodeName) = reFormatRSS) then
        Begin
          If FXMLFile.DocumentElement.Attributes[ituneNS] <> null then
            FXMLType := xtiTunes
          else
            FXMLType := xtRSS
        end // if then
      else
        Begin
          if (LowerCase(FXMLFile.DocumentElement.NodeName) = reFormatAtom) then
            Begin
              FXMLType := xtAtom
            end // if then
          else
          raise ESimpleRSSException.CreateFmt(reFormatUnkown + ': %s', [FXMLFile.DocumentElement.NodeName]);
        end; // if else
    end; // if else

  if (not VarIsNull(FXMLFile.DocumentElement.Attributes[reVersion])) then
    FVersion := FXMLFile.DocumentElement.Attributes[reVersion];

  case FXMLType of
    xtRDF: aParser:=TSimpleParserRDF.Create(Self);
    xtRSS: aParser:=TSimpleParserRSS.Create(Self);
    xtAtom: aParser:=TSimpleParserAtom.Create(Self);
    xtiTunes : aParser := TSimpleParseriTunes.Create(Self);
  else
    aParser:=nil;
  end;

  if (aParser <> nil) then
    begin
      aParser.Parse;

      If Assigned(FOnParseXML) then
        FOnParseXML(Self);
    end
  else
    raise ESimpleRSSException.CreateFmt(reFormatUnkown+ ': %s', [FXMLFile.DocumentElement.NodeName]);
end;

Procedure TSimpleRSS.GenerateXML;
Begin
  GenerateXML(FXMLType);
end;

procedure TSimpleRSS.GenerateXML(FeedType: TXMLType);
Var
  aParser : TSimpleParserBase;
begin
  Case FeedType of
    xtRSS : aParser := TSimpleParserRSS.Create(Self);
    xtRDF : aParser := TSimpleParserRDF.Create(Self);
    xtAtom : aParser := TSimpleParserAtom.Create(Self);
    xtiTunes : aParser := TSimpleParseriTunes.Create(Self);
    else
      aParser := nil;
  end; // case of

  If aParser <> nil then
    Begin
      aParser.Generate;
      If Assigned(FOnGenerateXML) then
        FOnGenerateXML(Self);
    end
  else
    Raise ESimpleRSSException.Create(reFormatUnkown);
end;

function TSimpleRSS.GetSimpleRSSVersion: String;
begin
  Result := strSimpleRSSVersion;
end;

Procedure TSimpleRSS.LoadFromFile(Filename: string);
begin
  ClearXML;
  FXMLFile.LoadFromFile(Filename);
  GenerateComponent;
end;

Procedure TSimpleRSS.LoadFromHTTP(URL: String);
Var
  MemoryStream : TMemoryStream;
begin
  If FIndyHTTP = nil then
    Raise ESimpleRSSException.Create(emRequireComponentMissing+strIdHTTPComponent)
  else
    Begin
      MemoryStream := TMemoryStream.Create;
      Try
        FIndyHTTP.Get(URL,MemoryStream);
      Finally
        MemoryStream.Position := 0;
        LoadFromStream(MemoryStream);
        MemoryStream.Free;
      end; // try finally
    end; // if then
end;

Procedure TSimpleRSS.LoadFromStream(Stream: TStream);
begin
  ClearXML;
  FXMLFile.LoadFromStream(Stream);
  GenerateComponent;
end;

Procedure TSimpleRSS.LoadFromString(S: string);
begin
  FXMLFile.XML.Text := S;
end;

Procedure TSimpleRSS.LoadFromStrings(Strings: TStrings);
var
  MemoryStream: TMemoryStream;
begin
  MemoryStream := TMemoryStream.Create;
  Strings.SaveToStream(MemoryStream);
  FXMLFile.LoadFromStream(MemoryStream);
  MemoryStream.Free;
end;

Procedure TSimpleRSS.SaveToFile(Filename: string);
begin
  GenerateXML;
  FXMLFile.SaveToFile(Filename);
end;

Procedure TSimpleRSS.SaveToStream(Stream: TStream);
begin
  GenerateXML;
  FXMLFile.SaveToStream(Stream);
end;

Function TSimpleRSS.SaveToString: string;
begin
  GenerateXML;
  Result := FXMLFile.XML.Text;
end;

Function TSimpleRSS.SaveToStrings: TStrings;
begin
  GenerateXML;
  Result := FXMLFile.XML;
end;

Procedure TSimpleRSS.SetChannel(const Value: TRSSChannel);
begin
  FChannel := Value;
end;

Procedure TSimpleRSS.SetIndyHTTP(const Value: TIdHTTP);
begin
  FIndyHTTP := Value;
end;

Procedure TSimpleRSS.SetItems(const Value: TRSSItems);
begin
  FItems := Value;
end;

procedure TSimpleRSS.SetOnParseXML(const Value: TNotifyEvent);
begin
  FOnParseXML := Value;
end;

procedure TSimpleRSS.SetOnCreate(const Value: TNotifyEvent);
begin
  FOnCreate := Value;
end;

procedure TSimpleRSS.SetOnGenerateXML(const Value: TNotifyEvent);
begin
  FOnGenerateXML := Value;
end;

Procedure TSimpleRSS.SetVersion(const Value: string);
begin
  FVersion := Value;
end;

end.

