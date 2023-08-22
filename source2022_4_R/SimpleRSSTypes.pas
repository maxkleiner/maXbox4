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
 for maXbox 2020
--------------------------------------------------------------------------------
}
unit SimpleRSSTypes;

interface

uses
  Classes, SysUtils, iTunesTypes;

type
  ESimpleRSSException = class(Exception);

type
  TLanguages = (langAF, langSQ, langEU, langBE, langBG, langCA, langZH_CN, langZH_TW, langHR, langCS, langDA, langNL, langNL_BE,
    langNL_NL, langEN, langEN_AU, langEN_BZ, langEN_CA, langEN_IE, langEN_JM, langEN_NZ, langEN_PH, langEN_ZA,
    langEN_TT, langEN_GB, langEN_US, langEN_ZW, langET, langFO, langFI, langFR, langFR_BE, langFR_CA, langFR_FR,
    langFR_LU, langFR_MC, langFR_CH, langGL, langGD, langDE, langDE_AT, langDE_DE, langDE_LI, langDE_LU, langDE_CH,
    langEL, langHAW, langHU, langIS, langIN, langGA, langIT, langIT_IT, langIT_CH, langJA, langKO, langMK, langNO, langPL,
    langPT, langPT_BR, langPT_PT, langRO, langRO_MO, langRO_RP, langRU, langRU_MO, langRU_RU, langSR, langSK, langSL,
    langES, langES_AR, langES_BO, langES_CL, langES_CO, langES_CR, langES_DO, langES_EC, langES_SV, langES_GT,
    langES_HN, langES_MX, langES_NI, langES_PA, langES_PY, langES_PE, langES_PR, langES_ES, langES_UY, langES_VE,
    langSV, langSV_FI, langSV_SE, langTR, langUK, langX);
    
type
  TXMLTypeRSS = (xtRDFrss, xtRSSrss, xtAtomrss, xtiTunesrss);

type
  TContentTypeRSS = (ctTextrss, ctHTMLrss, ctXHTMLrss);
  
type
  TEncodingTypeRSS = (etBase64rss,etEscapedrss,etXMLrss);

type
  TRFC822DateTime = class(TPersistent)
  private
    FTimeZone: string;
    FDateTime: TDateTime;
    FChanged: Boolean;
    procedure SetDateTime(const Value: TDateTime);
    procedure SetTimeZone(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    function GetDateTime: string;
    procedure LoadDateTime(S: string);
    procedure LoadDCDateTime(S: string);
    constructor Create;
    function Changed: Boolean;
    function LastSpace(S: string): Integer;
  published
    { Published declarations }
    property DateTime: TDateTime read FDateTime write SetDateTime;
    property TimeZone: string read FTimeZone write SetTimeZone;
  end;

type
  TRSSChannelReq = class(TPersistent)
  private
    FTitle: string;
    FDesc: string;
    FLink: string;
    procedure SetDesc(const Value: string);
    procedure SetLink(const Value: string);
    procedure SetTitle(const Value: string);
    function GetDesc: string;
    function GetLink: string;
    function GetTitle: string;
  published
    property Title: string read GetTitle write SetTitle;
    property Link: string read GetLink write SetLink;
    property Desc: string read GetDesc write SetDesc;
  end; // TRSSChannelReq

type
  TRSSImageReq = class(TPersistent)
  private
    FTitle: string;
    FURL: string;
    FLink: string;
    procedure SetLink(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetURL(const Value: string);
    function GetLink: string;
    function GetTitle: string;
    function GetURL: string;
  published
    property URL: string read GetURL write SetURL;
    property Title: string read GetTitle write SetTitle;
    property Link: string read GetLink write SetLink;
  end; // TRSSImageReq

type
  TRSSImageOpt = class(TPersistent)
  private
    FHeight: Integer;
    FWidth: Integer;
    FDescription: string;
    FDescriptionChanged: Boolean;
    FHeightChanged: Boolean;
    FWidthChanged: Boolean;
    procedure SetDescription(const Value: string);
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  public
    function DescriptionChanged: Boolean;
    function HeightChanged: Boolean;
    function WidthChanged: Boolean;
    constructor Create;
  published
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property Description: string read FDescription write SetDescription;
  end; // TRSSImageOpt

type
  TRSSImage = class(TPersistent)
  private
    FOptional: TRSSImageOpt;
    FRequired: TRSSImageReq;
    FInclude: Boolean;
    procedure SetOptional(const Value: TRSSImageOpt);
    procedure SetRequired(const Value: TRSSImageReq);
    procedure SetInclude(const Value: Boolean);
  public
    constructor Create;
    Destructor Destroy;override;
  published
    property Include: Boolean read FInclude write SetInclude;
    property Required: TRSSImageReq read FRequired write SetRequired;
    property Optional: TRSSImageOpt read FOptional write SetOptional;
  end; // TRSSImage

type
  TRSSCloud = class(TPersistent)
  private
    FPort: Integer;
    FProtocol: string;
    FDomain: string;
    FRegisterProcedure: string;
    FPath: string;
    FInclude: Boolean;
    procedure SetDomain(const Value: string);
    procedure SetPath(const Value: string);
    procedure SetPort(const Value: Integer);
    procedure SetProtocol(const Value: string);
    procedure SetRegisterProcedure(const Value: string);
    procedure SetInclude(const Value: Boolean);
  published
    property Domain: string read FDomain write SetDomain;
    property Port: Integer read FPort write SetPort;
    property Path: string read FPath write SetPath;
    property RegisterProcedure: string read FRegisterProcedure write SetRegisterProcedure;
    property Protocol: string read FProtocol write SetProtocol;
    property Include: Boolean read FInclude write SetInclude default False;
  end; // TRSSCloud

type
  TRSSTextInput = class(TPersistent)
  private
    FTitle: string;
    FDescription: string;
    FLink: string;
    FTextInputName: string;
    FInclude: Boolean;
    procedure SetDescription(const Value: string);
    procedure SetLink(const Value: string);
    procedure SetTextInputName(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetInclude(const Value: Boolean);
  published
    property Title: string read FTitle write SetTitle;
    property Description: string read FDescription write SetDescription;
    property TextInputName: string read FTextInputName write SetTextInputName;
    property Link: string read FLink write SetLink;
    property Include: Boolean read FInclude write SetInclude default False;
  end; // TRSSTextInput

type
  TRSSChannelCategory = class(TCollectionItem)
  private
    FCategory: string;
    FDomain: string;
    FDomainChanged: Boolean;
    procedure SetCategory(const Value: string);
    procedure SetDomain(const Value: string);
  public
    constructor Create(Collection: TCollection); override;
    function DomainChanged: Boolean;
  published
    property Category: string read FCategory write SetCategory;
    property Domain: string read FDomain write SetDomain;
  end;

type
  TRSSChannelCategories = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TRSSChannelCategory;
    procedure SetItem(Index: Integer; Value: TRSSChannelCategory);
  public
    function Add: TRSSChannelCategory;
    function Insert(Index: Integer): TRSSChannelCategory;
    property Items[Index: Integer]: TRSSChannelCategory read GetItem write SetItem; default;
  end;

type
  TRSSChannelSkipHours = class(TPersistent)
  private
    F17: Boolean;
    F21: Boolean;
    F03: Boolean;
    F12: Boolean;
    F20: Boolean;
    F23: Boolean;
    F02: Boolean;
    F04: Boolean;
    F06: Boolean;
    F10: Boolean;
    F11: Boolean;
    F01: Boolean;
    F00: Boolean;
    F07: Boolean;
    F13: Boolean;
    F16: Boolean;
    F15: Boolean;
    F22: Boolean;
    F18: Boolean;
    F19: Boolean;
    F05: Boolean;
    F08: Boolean;
    F14: Boolean;
    F09: Boolean;
    procedure Set01(const Value: Boolean);
    procedure Set02(const Value: Boolean);
    procedure Set03(const Value: Boolean);
    procedure Set04(const Value: Boolean);
    procedure Set05(const Value: Boolean);
    procedure Set06(const Value: Boolean);
    procedure Set07(const Value: Boolean);
    procedure Set08(const Value: Boolean);
    procedure Set09(const Value: Boolean);
    procedure Set10(const Value: Boolean);
    procedure Set11(const Value: Boolean);
    procedure Set12(const Value: Boolean);
    procedure Set13(const Value: Boolean);
    procedure Set14(const Value: Boolean);
    procedure Set15(const Value: Boolean);
    procedure Set16(const Value: Boolean);
    procedure Set17(const Value: Boolean);
    procedure Set18(const Value: Boolean);
    procedure Set19(const Value: Boolean);
    procedure Set20(const Value: Boolean);
    procedure Set21(const Value: Boolean);
    procedure Set22(const Value: Boolean);
    procedure Set23(const Value: Boolean);
    procedure Set24(const Value: Boolean);
  published
    property h01: Boolean read F01 write Set01 default False;
    property h02: Boolean read F02 write Set02 default False;
    property h03: Boolean read F03 write Set03 default False;
    property h04: Boolean read F04 write Set04 default False;
    property h05: Boolean read F05 write Set05 default False;
    property h06: Boolean read F06 write Set06 default False;
    property h07: Boolean read F07 write Set07 default False;
    property h08: Boolean read F08 write Set08 default False;
    property h09: Boolean read F09 write Set09 default False;
    property h10: Boolean read F10 write Set10 default False;
    property h11: Boolean read F11 write Set11 default False;
    property h12: Boolean read F12 write Set12 default False;
    property h13: Boolean read F13 write Set13 default False;
    property h14: Boolean read F14 write Set14 default False;
    property h15: Boolean read F15 write Set15 default False;
    property h16: Boolean read F16 write Set16 default False;
    property h17: Boolean read F17 write Set17 default False;
    property h18: Boolean read F18 write Set18 default False;
    property h19: Boolean read F19 write Set19 default False;
    property h20: Boolean read F20 write Set20 default False;
    property h21: Boolean read F21 write Set21 default False;
    property h22: Boolean read F22 write Set22 default False;
    property h23: Boolean read F23 write Set23 default False;
    property h00: Boolean read F00 write Set24 default False;
  end;

type
  TRSSChannelSkipDays = class(TPersistent)
  private
    FFriday: Boolean;
    FTuesday: Boolean;
    FThursday: Boolean;
    FSaturday: Boolean;
    FMonday: Boolean;
    FWednesday: Boolean;
    FSunday: Boolean;
    procedure SetFriday(const Value: Boolean);
    procedure SetMonday(const Value: Boolean);
    procedure SetSaturday(const Value: Boolean);
    procedure SetSunday(const Value: Boolean);
    procedure SetThursday(const Value: Boolean);
    procedure SetTuesday(const Value: Boolean);
    procedure SetWednesday(const Value: Boolean);
  published
    property Monday: Boolean read FMonday write SetMonday;
    property Tuesday: Boolean read FTuesday write SetTuesday;
    property Wednesday: Boolean read FWednesday write SetWednesday;
    property Thursday: Boolean read FThursday write SetThursday;
    property Friday: Boolean read FFriday write SetFriday;
    property Saturday: Boolean read FSaturday write SetSaturday;
    property Sunday: Boolean read FSunday write SetSunday;
  end;

type
  TRSSChannelOpt = class(TPersistent)
  private
    FTTL: Integer;
    FGenerator: string;
    FManagingEditor: string;
    FWebMaster: string;
    FCopyright: string;
    FLastBuildDate: TRFC822DateTime;
    FPubDate: TRFC822DateTime;
    FImage: TRSSImage;
    FLanguage: TLanguages;
    FCloud: TRSSCloud;
    FCopyrightChanged: Boolean;
    FManagingEditorChanged: Boolean;
    FWebMasterChanged: Boolean;
    FTTLChanged: Boolean;
    FGeneratorChanged: Boolean;
    FCategories: TRSSChannelCategories;
    FSkipHours: TRSSChannelSkipHours;
    FSkipDays: TRSSChannelSkipDays;
    FTextInput: TRSSTextInput;
    FDocs: string;
    FOwner: TPersistent;
    FRatingChanged: Boolean;
    FRating: string;
    FXLang: string;
    procedure SetCopyright(const Value: string);
    procedure SetGenerator(const Value: string);
    procedure SetLastBuildDate(const Value: TRFC822DateTime);
    procedure SetManagingEditor(const Value: string);
    procedure SetPubDate(const Value: TRFC822DateTime);
    procedure SetTTL(const Value: Integer);
    procedure SetWebMaster(const Value: string);
    procedure SetImage(const Value: TRSSImage);
    procedure SetCould(const Value: TRSSCloud);
    procedure SetLanguage(const Value: TLanguages);
    procedure SetCategories(const Value: TRSSChannelCategories);
    procedure SetSkipHours(const Value: TRSSChannelSkipHours);
    procedure SetSkipDays(const Value: TRSSChannelSkipDays);
    procedure SetTextInput(const Value: TRSSTextInput);
    procedure SetDocs(const Value: string);
    procedure SetOwner(const Value: TPersistent);
    procedure SetRating(const Value: string);
    procedure SetXLang(const Value: string);
  protected
    property Owner: TPersistent read FOwner write SetOwner;
  public
    constructor Create;
    function CopyrightChanged: Boolean;
    function ManagingEditorChanged: Boolean;
    function WebMasterChanged: Boolean;
    function GeneratorChanged: Boolean;
    function TTLChanged: Boolean;
    function RatingChanged: Boolean;
    Destructor Destroy;override;
  published
    property Language: TLanguages read FLanguage write SetLanguage;
    property XLang: string read FXLang write SetXLang;
    property Copyright: string read FCopyright write SetCopyright;
    property ManagingEditor: string read FManagingEditor write SetManagingEditor;
    property WebMaster: string read FWebMaster write SetWebMaster;
    property PubDate: TRFC822DateTime read FPubDate write SetPubDate;
    property LastBuildDate: TRFC822DateTime read FLastBuildDate write SetLastBuildDate;
    property Categories: TRSSChannelCategories read FCategories write SetCategories;
    property Generator: string read FGenerator write SetGenerator;
    property Docs: string read FDocs write SetDocs;
    property Cloud: TRSSCloud read FCloud write SetCould;
    property TTL: Integer read FTTL write SetTTL;
    property Image: TRSSImage read FImage write SetImage;
    {todo: make rating an intellegent system}
    property Rating: string read FRating write SetRating;
    property TextInput: TRSSTextInput read FTextInput write SetTextInput;
    property SkipHours: TRSSChannelSkipHours read FSkipHours write SetSkipHours;
    property SkipDays: TRSSChannelSkipDays read FSkipDays write SetSkipDays;
  end; // TRSSChannelOpt

type
  TRSSChannel = class(TPersistent)
  private
    FOptional: TRSSChannelOpt;
    FRequired: TRSSChannelReq;
    FOwner: TPersistent;
    FAboutURL: String;
    FiTunes: TiTunesChannelExtra;
    procedure SetOptional(const Value: TRSSChannelOpt);
    procedure SetRequired(const Value: TRSSChannelReq);
    procedure SetOwner(const Value: TPersistent);
    procedure SetAboutURL(const Value: String);
    procedure SetiTunes(const Value: TiTunesChannelExtra);
  protected
    property Owner: TPersistent read FOwner write SetOwner;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Required: TRSSChannelReq read FRequired write SetRequired;
    property Optional: TRSSChannelOpt read FOptional write SetOptional;
    Property iTunes:TiTunesChannelExtra Read FiTunes Write SetiTunes;
    property AboutURL : String Read FAboutURL Write SetAboutURL;
  end;

type
  TRSSItemSource = class(TPersistent)
  private
    FURL: string;
    FTitle: string;
    FInclude: Boolean;
    procedure SetTitle(const Value: string);
    procedure SetURL(const Value: string);
    procedure SetInclude(const Value: Boolean);
  public
    constructor Create;
  published
    property Title: string read FTitle write SetTitle;
    property URL: string read FURL write SetURL;
    property Include: Boolean read FInclude write SetInclude default False;
  end; //TRSSItemSource
type
  TRSSItemEnclosure = class(TPersistent)
  private
    FLength: Integer;
    FEnclosureType: string;
    FURL: string;
    FInclude: Boolean;
    procedure SetEnclosureType(const Value: string);
    procedure SetLength(const Value: Integer);
    procedure SetURL(const Value: string);
    procedure SetInclude(const Value: Boolean);
  published
    property URL: string read FURL write SetURL;
    property Length: Integer read FLength write SetLength;
    property EnclosureType: string read FEnclosureType write SetEnclosureType;
    property Include: Boolean read FInclude write SetInclude default False;
  end; // TRSSItemEnclosure
type
  TRSSItemCategory = class(TCollectionItem)
  private
    FTitle: string;
    FDomainChanged: Boolean;
    FDomain: string;
    procedure SetTitle(const Value: string);
    procedure SetDomain(const Value: string);
  public
    constructor Create(Collection: TCollection); override;
    function DomainChanged: Boolean;
  published
    property Title: string read FTitle write SetTitle;
    property Domain: string read FDomain write SetDomain;
  end; // TRSSItemCategory
type
  TRSSItemCategories = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TRSSItemCategory;
    procedure SetItem(Index: Integer; Value: TRSSItemCategory);
  public
    function Add: TRSSItemCategory;
    function Insert(Index: Integer): TRSSItemCategory;
    property Items[Index: Integer]: TRSSItemCategory read GetItem write SetItem; default;
  end;
type
  TRSSItemGUID = class(TPersistent)
  private
    FIsPermaLink: Boolean;
    FGUID: string;
    FInclude: Boolean;
    procedure SetGUID(const Value: string);
    procedure SetIsPermaLink(const Value: Boolean);
    procedure SetInclude(const Value: Boolean);
  public
    constructor Create;
  published
    property GUID: string read FGUID write SetGUID;
    property IsPermaLink: Boolean read FIsPermaLink write SetIsPermaLink default False;
    property Include: Boolean read FInclude write SetInclude default False;
  end; // TRSSItemGUID
type
  TRSSAuthor = class(TPersistent)
  private
    FName: string;
    FEMail: string;
    FURL: string;
  published
    property Name: string read FName write FName;
    property EMail: string read FEMail write FEMail;
    property URL: string read FURL write FURL;
  end; // TRSSAuthor
type
  TRSSItem = class(TCollectionItem)
  private
    FComments: string;
    FAuthor: TRSSAuthor;
    FLink: string;
    FDescription: string;
    FTitle: string;
    FPubDate: TRFC822DateTime;
    FEnclosure: TRSSItemEnclosure;
    FGUID: TRSSITemGUID;
    FSource: TRSSItemSource;
    FCommentsChanged: Boolean;
    FAuthorChanged: Boolean;
    FTitleChanged: Boolean;
    FLinkChanged: Boolean;
    FDescriptionChanged: Boolean;
    FCategory: TRSSItemCategories;
    FContentType: TContentTypeRSS;
    FiTunes: TiTunesItemExtra;
    procedure SetComments(const Value: string);
    procedure SetDescription(const Value: string);
    procedure SetEnclosure(const Value: TRSSItemEnclosure);
    procedure SetGUID(const Value: TRSSITemGUID);
    procedure SetLink(const Value: string);
    procedure SetPubDate(const Value: TRFC822DateTime);
    procedure SetSource(const Value: TRSSItemSource);
    procedure SetTitle(const Value: string);
    procedure SetCategories(const Value: TRSSItemCategories);
    procedure SetiTunes(const Value: TiTunesItemExtra);
  public
    constructor Create(Collection: TCollection); override;
    function CommentsChanged: Boolean;
    function AuthorChanged: Boolean;
    function TitleChanged: Boolean;
    function LinkChanged: Boolean;
    function DescriptionChanged: Boolean;
  published
    property Title: string read FTitle write SetTitle;
    property Link: string read FLink write SetLink;
    property Description: string read FDescription write SetDescription;
    property Author: TRSSAuthor read FAuthor write FAuthor;
    property Categories: TRSSItemCategories read FCategory write SetCategories;
    property Comments: string read FComments write SetComments;
    property Enclosure: TRSSItemEnclosure read FEnclosure write SetEnclosure;
    property GUID: TRSSITemGUID read FGUID write SetGUID;
    property PubDate: TRFC822DateTime read FPubDate write SetPubDate;
    property Source: TRSSItemSource read FSource write SetSource;
    property ContentType: TContentTypeRSS read FContentType write FContentType;
    Property iTunes:TiTunesItemExtra Read FiTunes Write SetiTunes;
  end;

type
  TRSSItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TRSSItem;
    procedure SetItem(Index: Integer; Value: TRSSItem);
  public
    function Add: TRSSItem;
    function Insert(Index: Integer): TRSSItem;
    property Items[Index: Integer]: TRSSItem read GetItem write SetItem; default;
  end;

type
  TFormatSettings = record
    ShortDateFormat: string;
    LongDateFormat: string;
    LongTimeFormat: string;
    ShortTimeFormat: string;
  end;
  
implementation

uses
  IdGlobal,
  {$IFDEF VER170}
  IdGlobalProtocols,
  {$ENDIF}
  SimpleRSSConst;

{$IFNDEF LINUX}
var
  FormatSettings: TFormatSettings;
{$ENDIF}

function TRSSChannelOpt.CopyrightChanged: Boolean;
begin
  Result := FCopyrightChanged;
end;

constructor TRSSChannelOpt.Create;
begin
  inherited;
  FGenerator := strSimpleRSS+' '+strSimpleRSSVersion;
  FLastBuildDate := TRFC822DateTime.Create;
  FPubDate := TRFC822DateTime.Create;
  FImage := TRSSImage.Create;
  FCloud := TRSSCloud.Create;
  FTTL := 60;
  FLanguage := langEN;
  FCopyrightChanged := False;
  FManagingEditorChanged := False;
  FWebMasterChanged := False;
  FRatingChanged := False;
  FTTLChanged := False;
  FGeneratorChanged := False;
  FCategories := TRSSChannelCategories.Create(Self, TRSSChannelCategory);
  FSkipHours := TRSSChannelSkipHours.Create;
  FSkipDays := TRSSChannelSkipDays.Create;
  FTextInput := TRSSTextInput.Create;
  FDocs := strDocs;
end;

destructor TRSSChannelOpt.Destroy;
begin
  FTextInput.Free;
  FSkipDays.Free;
  FSkipHours.Free;
  FCategories.Free;
  FCloud.Free;
  FImage.Free;
  FLastBuildDate.Free;
  FPubDate.Free;
  inherited;
end;

function TRSSChannelOpt.GeneratorChanged: Boolean;
begin
  Result := FGeneratorChanged;
end;

function TRSSChannelOpt.ManagingEditorChanged: Boolean;
begin
  Result := FManagingEditorChanged;
end;

function TRSSChannelOpt.RatingChanged: Boolean;
begin
  Result := FRatingChanged;
end;

procedure TRSSChannelOpt.SetCategories(const Value: TRSSChannelCategories);
begin
  FCategories := Value;
end;

procedure TRSSChannelOpt.SetCopyright(const Value: string);
begin
  if Value <> FCopyright then
    begin
      FCopyright := Value;
      If Value <> '' then
        FCopyrightChanged := True
      else
        FCopyrightChanged := False;
    end; // if tehn
end;

procedure TRSSChannelOpt.SetCould(const Value: TRSSCloud);
begin
  FCloud := Value;
end;

procedure TRSSChannelOpt.SetDocs(const Value: string);
begin
  FDocs := Value;
end;

procedure TRSSChannelOpt.SetGenerator(const Value: string);
begin
  if FGenerator <> Value then
    begin
      FGenerator := Value;
      If Value <> '' then
        FGeneratorChanged := True
      else
        FGeneratorChanged := False;
    end;
end;

procedure TRSSChannelOpt.SetImage(const Value: TRSSImage);
begin
  FImage := Value;
end;

procedure TRSSChannelOpt.SetLanguage(const Value: TLanguages);
begin
  if FLanguage <> Value then
    begin
      FLanguage := Value;
    end; // if then
end;

procedure TRSSChannelOpt.SetLastBuildDate(const Value: TRFC822DateTime);
begin
  FLastBuildDate := Value;
end;

procedure TRSSChannelOpt.SetManagingEditor(const Value: string);
begin
  if FManagingEditor <> Value then
    begin
      FManagingEditor := Value;
      If Value <> '' then
        FManagingEditorChanged := True
      else
        FManagingEditorChanged := False;
    end;
end;

procedure TRSSChannelOpt.SetOwner(const Value: TPersistent);
begin
  FOwner := Value;
end;

procedure TRSSChannelOpt.SetPubDate(const Value: TRFC822DateTime);
begin
  FPubDate := Value;
end;

procedure TRSSChannelOpt.SetRating(const Value: string);
begin
  if Value <> FRating then
    begin
      FRating := Value;
      If Value <> '' then
        FRatingChanged := True
      else
        FRatingChanged := False;
    end; // if then
end;

procedure TRSSChannelOpt.SetSkipDays(const Value: TRSSChannelSkipDays);
begin
  FSkipDays := Value;
end;

procedure TRSSChannelOpt.SetSkipHours(const Value: TRSSChannelSkipHours);
begin
  FSkipHours := Value;
end;

procedure TRSSChannelOpt.SetTextInput(const Value: TRSSTextInput);
begin
  FTextInput := Value;
end;

procedure TRSSChannelOpt.SetTTL(const Value: Integer);
begin
  if Value <> FTTL then begin
    if Value > 0 then
      FTTL := Value
    else
      FTTL := 0;
    FTTLChanged := True;
  end; // if then
end;

procedure TRSSChannelOpt.SetWebMaster(const Value: string);
begin
  if FWebMaster <> Value then
    begin
      FWebMaster := Value;
      If Value <> '' then
        FWebMasterChanged := True
      else
        FWebMasterChanged := False;
    end; // if ten
end;
{ TRSSChannelReq }

function TRSSChannelReq.GetDesc: string;
begin
  if Length(Trim(FDesc)) = 0 then
    Result := strDescReq
  else
    Result := FDesc;
end;

function TRSSChannelReq.GetLink: string;
begin
  if Length(Trim(FLink)) = 0 then
    Result := strLinkReq
  else
    Result := FLink;
end;

function TRSSChannelReq.GetTitle: string;
begin
  if Length(Trim(FTitle)) = 0 then
    Result := strTitleReq
  else
    Result := FTitle;
end;

procedure TRSSChannelReq.SetDesc(const Value: string);
begin
  FDesc := Value;
end;

procedure TRSSChannelReq.SetLink(const Value: string);
begin
  FLink := Value;
end;

procedure TRSSChannelReq.SetTitle(const Value: string);
begin
  FTitle := Value;
end;
{ TRSSImageReq }
{ TRSSChannel }

constructor TRSSChannel.Create;
begin
  inherited;
  FOptional := TRSSChannelOpt.Create;
  FRequired := TRSSChannelReq.Create;
  FiTunes := TiTunesChannelExtra.Create;
{$IFNDEF LINUX}
  //GetLocaleFormatSettings(SysLocale.DefaultLCID,FormatSettings);
  FormatSettings.ShortDateFormat := strShortDateFormat;
  FormatSettings.LongDateFormat := FormatSettings.ShortDateFormat;
  FormatSettings.LongTimeFormat := strLongTimeFormat;
  FormatSettings.ShortTimeFormat := FormatSettings.LongTimeFormat;
{$ENDIF}
end;

destructor TRSSChannel.Destroy;
begin
  FiTunes.Free;
  FOptional.Free;
  FRequired.Free;
  inherited;
end;

procedure TRSSChannel.SetAboutURL(const Value: String);
begin
  FAboutURL := Value;
end;

procedure TRSSChannel.SetiTunes(const Value: TiTunesChannelExtra);
begin
  FiTunes := Value;
end;

procedure TRSSChannel.SetOptional(const Value: TRSSChannelOpt);
begin
  FOptional := Value;
end;

procedure TRSSChannel.SetOwner(const Value: TPersistent);
begin
  FOwner := Value;
end;

procedure TRSSChannel.SetRequired(const Value: TRSSChannelReq);
begin
  FRequired := Value;
end;
{ TRSSImageReq }

function TRSSImageReq.GetLink: string;
begin
  if Length(Trim(FLink)) = 0 then
    Result := strLinkReq
  else
    Result := FLink;
end;

function TRSSImageReq.GetTitle: string;
begin
  if Length(Trim(FTitle)) = 0 then
    Result := strTitleReq
  else
    Result := FTitle;
end;

function TRSSImageReq.GetURL: string;
begin
  if Length(Trim(FURL)) = 0 then
    Result := strURLReq
  else
    Result := FURL;
end;

procedure TRSSImageReq.SetLink(const Value: string);
begin
  FLink := Value;
end;

procedure TRSSImageReq.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TRSSImageReq.SetURL(const Value: string);
begin
  FURL := Value;
end;
{ TRSSImageOpt }

constructor TRSSImageOpt.Create;
begin
  inherited;
  FDescriptionChanged := False;
  FHeightChanged := False;
  FWidthChanged := False;
end;

function TRSSImageOpt.DescriptionChanged: Boolean;
begin
  Result := FDescriptionChanged;
end;

function TRSSImageOpt.HeightChanged: Boolean;
begin
  Result := FHeightChanged;
end;

procedure TRSSImageOpt.SetDescription(const Value: string);
begin
  if Value <> FDescription then
    begin
      FDescription := Value;
      If Value <> '' then
        FDescriptionChanged := True
      else
        FDescriptionChanged := False;
    end; // if then
end;

procedure TRSSImageOpt.SetHeight(const Value: Integer);
begin
  if Value <> FHeight then begin
    if (Value > -1) and (Value < 401) then
      FHeight := Value
    else begin
      if Value < 0 then
        FHeight := 0;
      if Value > 400 then
        FHeight := 400;
    end; // if then
    FHeightChanged := True;
  end; // if then
end;

procedure TRSSImageOpt.SetWidth(const Value: Integer);
begin
  if Value <> FWidth then begin
    if (Value > -1) and (Value < 145) then
      FWidth := Value
    else begin
      if Value < 0 then
        FWidth := 0;
      if Value > 144 then
        FWidth := 144;
    end; // if then
    FWidthChanged := True;
  end; // if then
end;

function TRSSImageOpt.WidthChanged: Boolean;
begin
  Result := FWidthChanged;
end;
{ TRSSImage }

constructor TRSSImage.Create;
begin
  inherited;
  FOptional := TRSSImageOpt.Create;
  FRequired := TRSSImageReq.Create;
  FInclude := False;
end;

destructor TRSSImage.Destroy;
begin
  FOptional.Free;
  FRequired.Free;
  inherited;
end;

procedure TRSSImage.SetInclude(const Value: Boolean);
begin
  FInclude := Value;
end;

procedure TRSSImage.SetOptional(const Value: TRSSImageOpt);
begin
  FOptional := Value;
end;

procedure TRSSImage.SetRequired(const Value: TRSSImageReq);
begin
  FRequired := Value;
end;
{ TRSSCloud }

procedure TRSSCloud.SetDomain(const Value: string);
begin
  FDomain := Value;
end;

procedure TRSSCloud.SetInclude(const Value: Boolean);
begin
  FInclude := Value;
end;

procedure TRSSCloud.SetPath(const Value: string);
begin
  FPath := Value;
end;

procedure TRSSCloud.SetPort(const Value: Integer);
begin
  if Value > 1 then
    FPort := Value
  else
    FPort := 1;
end;

procedure TRSSCloud.SetProtocol(const Value: string);
begin
  FProtocol := Value;
end;

procedure TRSSCloud.SetRegisterProcedure(const Value: string);
begin
  FRegisterProcedure := Value;
end;
{ TRSSTextInput }

procedure TRSSTextInput.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TRSSTextInput.SetInclude(const Value: Boolean);
begin
  FInclude := Value;
end;

procedure TRSSTextInput.SetLink(const Value: string);
begin
  FLink := Value;
end;

procedure TRSSTextInput.SetTextInputName(const Value: string);
begin
  FTextInputName := Value;
end;

procedure TRSSTextInput.SetTitle(const Value: string);
begin
  FTitle := Value;
end;
{ TRSSItemSource }

constructor TRSSItemSource.Create;
begin
  inherited;
end;

procedure TRSSItemSource.SetInclude(const Value: Boolean);
begin
  FInclude := Value;
end;

procedure TRSSItemSource.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TRSSItemSource.SetURL(const Value: string);
begin
  if FURL <> Value then begin
    FURL := Value;
  end; // if then
end;

{ TRSSItemEnclosure }

procedure TRSSItemEnclosure.SetEnclosureType(const Value: string);
begin
  FEnclosureType := Value;
end;

procedure TRSSItemEnclosure.SetInclude(const Value: Boolean);
begin
  FInclude := Value;
end;

procedure TRSSItemEnclosure.SetLength(const Value: Integer);
begin
  FLength := Value;
end;

procedure TRSSItemEnclosure.SetURL(const Value: string);
begin
  FURL := Value;
end;
{ TRSSItemCategory }

constructor TRSSItemCategory.Create(Collection: TCollection);
begin
  inherited;
  FDomainChanged := False;
end;

function TRSSItemCategory.DomainChanged: Boolean;
begin
  Result := FDomainChanged;
end;

procedure TRSSItemCategory.SetDomain(const Value: string);
begin
  if FDomain <> Value then
    begin
      FDomain := Value;
      If Value <> '' then
        FDomainChanged := True
      else
        FDomainChanged := False;
    end; // if then
end;

procedure TRSSItemCategory.SetTitle(const Value: string);
begin
  FTitle := Value;
end;
{ TRSSItemGUID }

constructor TRSSItemGUID.Create;
Var
  GUID : TGUID;
begin
  inherited;
  CreateGUID(GUID);
  FGUID := GUIDToString(GUID);
  FIsPermaLink := False;
end;

procedure TRSSItemGUID.SetGUID(const Value: string);
begin
  FGUID := Value;
end;

procedure TRSSItemGUID.SetInclude(const Value: Boolean);
begin
  FInclude := Value;
end;

procedure TRSSItemGUID.SetIsPermaLink(const Value: Boolean);
begin
  if Value <> FIsPermaLink then begin
    FIsPermaLink := Value;
  end; // if then
end;
{ TRSSItem }

function TRSSItem.AuthorChanged: Boolean;
begin
  Result := FAuthorChanged;
end;

function TRSSItem.CommentsChanged: Boolean;
begin
  Result := FCommentsChanged;
end;

constructor TRSSItem.Create(Collection: TCollection);
begin
  inherited;
  FCategory := TRSSItemCategories.Create(Self, TRSSItemCategory);
  FPubDate := TRFC822DateTime.Create;
  FEnclosure := TRSSItemEnclosure.Create;
  FGUID := TRSSItemGUID.Create;
  FSource := TRSSItemSource.Create;
  FAuthor := TRSSAuthor.Create;
  FiTunes := TiTunesItemExtra.Create;
  FAuthorChanged := False;
  FCommentsChanged := False;
  FTitleChanged := False;
  FLinkChanged := False;
  FDescriptionChanged := False;
end;

function TRSSItem.DescriptionChanged: Boolean;
begin
  Result := FDescriptionChanged;
end;

function TRSSItem.LinkChanged: Boolean;
begin
  Result := FLinkChanged;
end;

procedure TRSSItem.SetCategories(const Value: TRSSItemCategories);
begin
  FCategory := Value;
end;

procedure TRSSItem.SetComments(const Value: string);
begin
  if FComments <> Value then
    begin
      FComments := Value;
      If Value <> '' then
        FCommentsChanged := True
      else
        FCommentsChanged := False;
    end; // if then
end;

procedure TRSSItem.SetDescription(const Value: string);
begin
  if FDescription <> Value then
    begin
      FDescription := Value;
      If Value <> '' then
        FDescriptionChanged := True
      else
        FDescriptionChanged := False;
    end; // if then
end;

procedure TRSSItem.SetEnclosure(const Value: TRSSItemEnclosure);
begin
  FEnclosure := Value;
end;

procedure TRSSItem.SetGUID(const Value: TRSSITemGUID);
begin
  FGUID := Value;
end;

procedure TRSSItem.SetiTunes(const Value: TiTunesItemExtra);
begin
  FiTunes := Value;
end;

procedure TRSSItem.SetLink(const Value: string);
begin
  if FLink <> Value then
    begin
      FLink := Value;
      If Value <> '' then
        FLinkChanged := True
      else
        FLinkChanged := False;
    end;
end;

procedure TRSSItem.SetPubDate(const Value: TRFC822DateTime);
begin
  FPubDate := Value;
end;

procedure TRSSItem.SetSource(const Value: TRSSItemSource);
begin
  FSource := Value;
end;

procedure TRSSItem.SetTitle(const Value: string);
begin
  if FTitle <> Value then
    begin
      FTitle := Value;
      If Value <> '' then
        FTitleChanged := True
      else
        FTitleChanged := False;
    end;
end;

procedure TRSSChannelOpt.SetXLang(const Value: string);
begin
  FXLang := Value;
end;

function TRSSChannelOpt.TTLChanged: Boolean;
begin
  Result := FTTLChanged;
end;

function TRSSChannelOpt.WebMasterChanged: Boolean;
begin
  Result := FWebMasterChanged;
end;

function TRSSItem.TitleChanged: Boolean;
begin
  Result := FTitleChanged;
end;
{ TRSSItemCategories }

function TRSSItemCategories.Add: TRSSItemCategory;
begin
  Result := TRSSItemCategory(inherited Add);
end;

function TRSSItemCategories.GetItem(Index: Integer): TRSSItemCategory;
begin
  Result := TRSSItemCategory(inherited GetItem(Index));
end;

function TRSSItemCategories.Insert(Index: Integer): TRSSItemCategory;
begin
  Result := TRSSItemCategory(inherited Insert(Index));
end;

procedure TRSSItemCategories.SetItem(Index: Integer;
  Value: TRSSItemCategory);
begin
  inherited SetItem(Index, Value);
end;
{ TRSSChannelCategory }

constructor TRSSChannelCategory.Create(Collection: TCollection);
begin
  inherited;
  FDomainChanged := False;
end;

function TRSSChannelCategory.DomainChanged: Boolean;
begin
  Result := FDomainChanged;
end;

procedure TRSSChannelCategory.SetCategory(const Value: string);
begin
  FCategory := Value;
end;

procedure TRSSChannelCategory.SetDomain(const Value: string);
begin
  if FDomain <> Value then
    begin
      FDomain := Value;
      If Value <> '' then
        FDomainChanged := True
      else
        FDomainChanged := False;
    end; // if then
end;
{ TRSSChannelCategories }

function TRSSChannelCategories.Add: TRSSChannelCategory;
begin
  Result := TRSSChannelCategory(inherited Add);
end;

function TRSSChannelCategories.GetItem(
  Index: Integer): TRSSChannelCategory;
begin
  Result := TRSSChannelCategory(inherited GetItem(Index));
end;

function TRSSChannelCategories.Insert(Index: Integer): TRSSChannelCategory;
begin
  Result := TRSSChannelCategory(inherited Insert(Index));
end;

procedure TRSSChannelCategories.SetItem(Index: Integer;
  Value: TRSSChannelCategory);
begin
  inherited SetItem(Index, Value);
end;
{ TRSSItems }

function TRSSItems.Add: TRSSItem;
begin
  Result := TRSSItem(inherited Add);
end;

function TRSSItems.GetItem(Index: Integer): TRSSItem;
begin
  Result := TRSSItem(inherited GetItem(Index));
end;

function TRSSItems.Insert(Index: Integer): TRSSItem;
begin
  Result := TRSSItem(inherited Insert(Index));
end;

procedure TRSSItems.SetItem(Index: Integer; Value: TRSSItem);
begin
  inherited SetItem(Index, Value);
end;
{ TRSSChannelSkipHours }

procedure TRSSChannelSkipHours.Set01(const Value: Boolean);
begin
  F01 := Value;
end;

procedure TRSSChannelSkipHours.Set02(const Value: Boolean);
begin
  F02 := Value;
end;

procedure TRSSChannelSkipHours.Set03(const Value: Boolean);
begin
  F03 := Value;
end;

procedure TRSSChannelSkipHours.Set04(const Value: Boolean);
begin
  F04 := Value;
end;

procedure TRSSChannelSkipHours.Set05(const Value: Boolean);
begin
  F05 := Value;
end;

procedure TRSSChannelSkipHours.Set06(const Value: Boolean);
begin
  F06 := Value;
end;

procedure TRSSChannelSkipHours.Set07(const Value: Boolean);
begin
  F07 := Value;
end;

procedure TRSSChannelSkipHours.Set08(const Value: Boolean);
begin
  F08 := Value;
end;

procedure TRSSChannelSkipHours.Set09(const Value: Boolean);
begin
  F09 := Value;
end;

procedure TRSSChannelSkipHours.Set10(const Value: Boolean);
begin
  F10 := Value;
end;

procedure TRSSChannelSkipHours.Set11(const Value: Boolean);
begin
  F11 := Value;
end;

procedure TRSSChannelSkipHours.Set12(const Value: Boolean);
begin
  F12 := Value;
end;

procedure TRSSChannelSkipHours.Set13(const Value: Boolean);
begin
  F13 := Value;
end;

procedure TRSSChannelSkipHours.Set14(const Value: Boolean);
begin
  F14 := Value;
end;

procedure TRSSChannelSkipHours.Set15(const Value: Boolean);
begin
  F15 := Value;
end;

procedure TRSSChannelSkipHours.Set16(const Value: Boolean);
begin
  F16 := Value;
end;

procedure TRSSChannelSkipHours.Set17(const Value: Boolean);
begin
  F17 := Value;
end;

procedure TRSSChannelSkipHours.Set18(const Value: Boolean);
begin
  F18 := Value;
end;

procedure TRSSChannelSkipHours.Set19(const Value: Boolean);
begin
  F19 := Value;
end;

procedure TRSSChannelSkipHours.Set20(const Value: Boolean);
begin
  F20 := Value;
end;

procedure TRSSChannelSkipHours.Set21(const Value: Boolean);
begin
  F21 := Value;
end;

procedure TRSSChannelSkipHours.Set22(const Value: Boolean);
begin
  F22 := Value;
end;

procedure TRSSChannelSkipHours.Set23(const Value: Boolean);
begin
  F23 := Value;
end;

procedure TRSSChannelSkipHours.Set24(const Value: Boolean);
begin
  F00 := Value;
end;
{ TRSSChannelSkipDays }

procedure TRSSChannelSkipDays.SetFriday(const Value: Boolean);
begin
  FFriday := Value;
end;

procedure TRSSChannelSkipDays.SetMonday(const Value: Boolean);
begin
  FMonday := Value;
end;

procedure TRSSChannelSkipDays.SetSaturday(const Value: Boolean);
begin
  FSaturday := Value;
end;

procedure TRSSChannelSkipDays.SetSunday(const Value: Boolean);
begin
  FSunday := Value;
end;

procedure TRSSChannelSkipDays.SetThursday(const Value: Boolean);
begin
  FThursday := Value;
end;

procedure TRSSChannelSkipDays.SetTuesday(const Value: Boolean);
begin
  FTuesday := Value;
end;

procedure TRSSChannelSkipDays.SetWednesday(const Value: Boolean);
begin
  FWednesday := Value;
end;

function TRFC822DateTime.Changed: Boolean;
begin
  Result := FChanged;
end;

constructor TRFC822DateTime.Create;
begin
  inherited;
  FTimeZone := strGMT;
  FDateTime := Now;
  FChanged := False;
end;

function TRFC822DateTime.GetDateTime: string;
begin
{$IFDEF LINUX}
  Result := FormatDateTime(strDateFormat, FDateTime) + ' ' + FTimeZone;
{$ELSE}
  Result := FormatDateTime(strDateFormat, FDateTime) + ' ' + FTimeZone;
{$ENDIF}
end;

procedure TRFC822DateTime.SetDateTime(const Value: TDateTime);
begin
  if Value <> FDateTime then
    begin
      FDateTime := Value;
      FChanged := True;
    end;
end;
// parses a date as in http://www.w3.org/TR/NOTE-datetime

procedure TRFC822DateTime.LoadDCDateTime(S: string);
var
  Year, Month, Day: Word;
  Hour, Minute, Second: Word;
  Date, Time: TDateTime;
begin
  Year := StrToIntDef(Fetch(S, '-'), 0);
  if (S <> '') then
    Month := StrToIntDef(Fetch(S, '-'), 0)
  else
    Month := 0;
  if (S <> '') then
    Day := StrToIntDef(Fetch(S, 'T'), 0)
  else
    Day := 0;
  if (S <> '') then
    Hour := StrToIntDef(Fetch(S, ':'), 0)
  else
    Hour := 0;
  if (S <> '') then
    Minute := StrToIntDef(Fetch(S, ':'), 0)
  else
    Minute := 0;
  if (S <> '') then begin
    Second := StrToIntDef(Copy(S, 1, 2), 0);
    Delete(S, 1, 2);
  end
  else
    Second := 0;
  if (S <> '') then
    FTimeZone := S;
  try
    Date := EncodeDate(Year, Month, Day);
    Time := EncodeTime(Hour, Minute, Second, 0);
    SetDateTime(Date + Time);
  except
    SetDateTime(now);
  end;
end;

procedure TRFC822DateTime.LoadDateTime(S: string);
var
  aDate: TDateTime;
begin
  try
    aDate := StrInternetToDateTime(S);
  except
    aDate := now;
  end;
  SetDateTime(aDate);
end;

procedure TRFC822DateTime.SetTimeZone(const Value: string);
begin
  if Value <> FTimeZone then begin
    FTimeZone := Value;
    FChanged := True;
  end;
end;

function TRFC822DateTime.LastSpace(S: string): Integer;
var
  Counter: Integer;
begin
  Result := 0;
  for Counter := Length(S) downto 1 do begin
    if (Result = 0) and (S[Counter] = #32) then
      Result := Counter;
  end; // for 2 do
end;

end.

