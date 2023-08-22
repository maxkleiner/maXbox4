{*******************************************************************}
{                                                                   }
{                      Liaison de données XML                       }
{                                                                   }
{         Généré le : 20/08/2010 15:20:13                           }
{       Généré depuis : http://www.topografix.com/GPX/1/1/gpx.xsd   }
{   Paramètres stockés dans : gpx.xdb                               }
{                                                                   }
{*******************************************************************}

unit GPX;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Décl. Forward }

  IXMLGpxType = interface;
  IXMLMetadataType = interface;
  IXMLPersonType = interface;
  IXMLEmailType = interface;
  IXMLLinkType = interface;
  IXMLLinkTypeList = interface;
  IXMLCopyrightType = interface;
  IXMLBoundsType = interface;
  IXMLExtensionsType = interface;
  IXMLWptType = interface;
  IXMLWptTypeList = interface;
  IXMLRteType = interface;
  IXMLRteTypeList = interface;
  IXMLTrkType = interface;
  IXMLTrkTypeList = interface;
  IXMLTrksegType = interface;
  IXMLTrksegTypeList = interface;
  IXMLPtType = interface;
  IXMLPtsegType = interface;

{ IXMLGpxType }

  IXMLGpxType = interface(IXMLNode)
    ['{C92A4C15-F128-4726-B856-2C525EB1786C}']
    { Accesseurs de propriétés }
    function Get_Version: WideString;
    function Get_Creator: WideString;
    function Get_Metadata: IXMLMetadataType;
    function Get_Wpt: IXMLWptTypeList;
    function Get_Rte: IXMLRteTypeList;
    function Get_Trk: IXMLTrkTypeList;
    function Get_Extensions: IXMLExtensionsType;
    procedure Set_Version(Value: WideString);
    procedure Set_Creator(Value: WideString);
    { Méthodes & propriétés }
    property Version: WideString read Get_Version write Set_Version;
    property Creator: WideString read Get_Creator write Set_Creator;
    property Metadata: IXMLMetadataType read Get_Metadata;
    property Wpt: IXMLWptTypeList read Get_Wpt;
    property Rte: IXMLRteTypeList read Get_Rte;
    property Trk: IXMLTrkTypeList read Get_Trk;
    property Extensions: IXMLExtensionsType read Get_Extensions;
  end;

{ IXMLMetadataType }

  IXMLMetadataType = interface(IXMLNode)
    ['{41961CD6-1E24-4DCE-9599-517AF2243A6D}']
    { Accesseurs de propriétés }
    function Get_Name: WideString;
    function Get_Desc: WideString;
    function Get_Author: IXMLPersonType;
    function Get_Copyright: IXMLCopyrightType;
    function Get_Link: IXMLLinkTypeList;
    function Get_Time: WideString;
    function Get_Keywords: WideString;
    function Get_Bounds: IXMLBoundsType;
    function Get_Extensions: IXMLExtensionsType;
    procedure Set_Name(Value: WideString);
    procedure Set_Desc(Value: WideString);
    procedure Set_Time(Value: WideString);
    procedure Set_Keywords(Value: WideString);
    { Méthodes & propriétés }
    property Name: WideString read Get_Name write Set_Name;
    property Desc: WideString read Get_Desc write Set_Desc;
    property Author: IXMLPersonType read Get_Author;
    property Copyright: IXMLCopyrightType read Get_Copyright;
    property Link: IXMLLinkTypeList read Get_Link;
    property Time: WideString read Get_Time write Set_Time;
    property Keywords: WideString read Get_Keywords write Set_Keywords;
    property Bounds: IXMLBoundsType read Get_Bounds;
    property Extensions: IXMLExtensionsType read Get_Extensions;
  end;

{ IXMLPersonType }

  IXMLPersonType = interface(IXMLNode)
    ['{05658EC5-4F29-48FE-99BE-C0E7099F831F}']
    { Accesseurs de propriétés }
    function Get_Name: WideString;
    function Get_Email: IXMLEmailType;
    function Get_Link: IXMLLinkType;
    procedure Set_Name(Value: WideString);
    { Méthodes & propriétés }
    property Name: WideString read Get_Name write Set_Name;
    property Email: IXMLEmailType read Get_Email;
    property Link: IXMLLinkType read Get_Link;
  end;

{ IXMLEmailType }

  IXMLEmailType = interface(IXMLNode)
    ['{6B1305CF-F3B3-4648-825A-D27EE921ADB3}']
    { Accesseurs de propriétés }
    function Get_Id: WideString;
    function Get_Domain: WideString;
    procedure Set_Id(Value: WideString);
    procedure Set_Domain(Value: WideString);
    { Méthodes & propriétés }
    property Id: WideString read Get_Id write Set_Id;
    property Domain: WideString read Get_Domain write Set_Domain;
  end;

{ IXMLLinkType }

  IXMLLinkType = interface(IXMLNode)
    ['{A4E5EC2D-8D1A-4E86-B74F-4E405891B386}']
    { Accesseurs de propriétés }
    function Get_Href: WideString;
    function Get_Text: WideString;
    function Get_Type_: WideString;
    procedure Set_Href(Value: WideString);
    procedure Set_Text(Value: WideString);
    procedure Set_Type_(Value: WideString);
    { Méthodes & propriétés }
    property Href: WideString read Get_Href write Set_Href;
    property Text: WideString read Get_Text write Set_Text;
    property Type_: WideString read Get_Type_ write Set_Type_;
  end;

{ IXMLLinkTypeList }

  IXMLLinkTypeList = interface(IXMLNodeCollection)
    ['{4808732C-3C53-4595-AA64-0316EFCBE8C8}']
    { Méthodes & propriétés }
    function Add: IXMLLinkType;
    function Insert(const Index: Integer): IXMLLinkType;
    function Get_Item(Index: Integer): IXMLLinkType;
    property Items[Index: Integer]: IXMLLinkType read Get_Item; default;
  end;

{ IXMLCopyrightType }

  IXMLCopyrightType = interface(IXMLNode)
    ['{454BF956-647B-4838-A628-B80B5D739A65}']
    { Accesseurs de propriétés }
    function Get_Author: WideString;
    function Get_Year: WideString;
    function Get_License: WideString;
    procedure Set_Author(Value: WideString);
    procedure Set_Year(Value: WideString);
    procedure Set_License(Value: WideString);
    { Méthodes & propriétés }
    property Author: WideString read Get_Author write Set_Author;
    property Year: WideString read Get_Year write Set_Year;
    property License: WideString read Get_License write Set_License;
  end;

{ IXMLBoundsType }

  IXMLBoundsType = interface(IXMLNode)
    ['{B47A9908-B72B-4849-BBF5-A5939EB0BB92}']
    { Accesseurs de propriétés }
    function Get_Minlat: WideString;
    function Get_Minlon: WideString;
    function Get_Maxlat: WideString;
    function Get_Maxlon: WideString;
    procedure Set_Minlat(Value: WideString);
    procedure Set_Minlon(Value: WideString);
    procedure Set_Maxlat(Value: WideString);
    procedure Set_Maxlon(Value: WideString);
    { Méthodes & propriétés }
    property Minlat: WideString read Get_Minlat write Set_Minlat;
    property Minlon: WideString read Get_Minlon write Set_Minlon;
    property Maxlat: WideString read Get_Maxlat write Set_Maxlat;
    property Maxlon: WideString read Get_Maxlon write Set_Maxlon;
  end;

{ IXMLExtensionsType }

  IXMLExtensionsType = interface(IXMLNode)
    ['{FA1DE5D5-7A7A-4AB4-9A93-C2D19FF5AE07}']
  end;

{ IXMLWptType }

  IXMLWptType = interface(IXMLNode)
    ['{5733BE81-FBC3-484C-8FFB-6C710A92BB8C}']
    { Accesseurs de propriétés }
    function Get_Lat: WideString;
    function Get_Lon: WideString;
    function Get_Ele: WideString;
    function Get_Time: WideString;
    function Get_Magvar: WideString;
    function Get_Geoidheight: WideString;
    function Get_Name: WideString;
    function Get_Cmt: WideString;
    function Get_Desc: WideString;
    function Get_Src: WideString;
    function Get_Link: IXMLLinkTypeList;
    function Get_Sym: WideString;
    function Get_Type_: WideString;
    function Get_Fix: WideString;
    function Get_Sat: LongWord;
    function Get_Hdop: WideString;
    function Get_Vdop: WideString;
    function Get_Pdop: WideString;
    function Get_Ageofdgpsdata: WideString;
    function Get_Dgpsid: Integer;
    function Get_Extensions: IXMLExtensionsType;
    procedure Set_Lat(Value: WideString);
    procedure Set_Lon(Value: WideString);
    procedure Set_Ele(Value: WideString);
    procedure Set_Time(Value: WideString);
    procedure Set_Magvar(Value: WideString);
    procedure Set_Geoidheight(Value: WideString);
    procedure Set_Name(Value: WideString);
    procedure Set_Cmt(Value: WideString);
    procedure Set_Desc(Value: WideString);
    procedure Set_Src(Value: WideString);
    procedure Set_Sym(Value: WideString);
    procedure Set_Type_(Value: WideString);
    procedure Set_Fix(Value: WideString);
    procedure Set_Sat(Value: LongWord);
    procedure Set_Hdop(Value: WideString);
    procedure Set_Vdop(Value: WideString);
    procedure Set_Pdop(Value: WideString);
    procedure Set_Ageofdgpsdata(Value: WideString);
    procedure Set_Dgpsid(Value: Integer);
    { Méthodes & propriétés }
    property Lat: WideString read Get_Lat write Set_Lat;
    property Lon: WideString read Get_Lon write Set_Lon;
    property Ele: WideString read Get_Ele write Set_Ele;
    property Time: WideString read Get_Time write Set_Time;
    property Magvar: WideString read Get_Magvar write Set_Magvar;
    property Geoidheight: WideString read Get_Geoidheight write Set_Geoidheight;
    property Name: WideString read Get_Name write Set_Name;
    property Cmt: WideString read Get_Cmt write Set_Cmt;
    property Desc: WideString read Get_Desc write Set_Desc;
    property Src: WideString read Get_Src write Set_Src;
    property Link: IXMLLinkTypeList read Get_Link;
    property Sym: WideString read Get_Sym write Set_Sym;
    property Type_: WideString read Get_Type_ write Set_Type_;
    property Fix: WideString read Get_Fix write Set_Fix;
    property Sat: LongWord read Get_Sat write Set_Sat;
    property Hdop: WideString read Get_Hdop write Set_Hdop;
    property Vdop: WideString read Get_Vdop write Set_Vdop;
    property Pdop: WideString read Get_Pdop write Set_Pdop;
    property Ageofdgpsdata: WideString read Get_Ageofdgpsdata write Set_Ageofdgpsdata;
    property Dgpsid: Integer read Get_Dgpsid write Set_Dgpsid;
    property Extensions: IXMLExtensionsType read Get_Extensions;
  end;

{ IXMLWptTypeList }

  IXMLWptTypeList = interface(IXMLNodeCollection)
    ['{A0F068C3-2F99-4ACA-917F-1B1F4A189C01}']
    { Méthodes & propriétés }
    function Add: IXMLWptType;
    function Insert(const Index: Integer): IXMLWptType;
    function Get_Item(Index: Integer): IXMLWptType;
    property Items[Index: Integer]: IXMLWptType read Get_Item; default;
  end;

{ IXMLRteType }

  IXMLRteType = interface(IXMLNode)
    ['{23431091-030D-4145-B85A-08749F2C23FF}']
    { Accesseurs de propriétés }
    function Get_Name: WideString;
    function Get_Cmt: WideString;
    function Get_Desc: WideString;
    function Get_Src: WideString;
    function Get_Link: IXMLLinkTypeList;
    function Get_Number: LongWord;
    function Get_Type_: WideString;
    function Get_Extensions: IXMLExtensionsType;
    function Get_Rtept: IXMLWptTypeList;
    procedure Set_Name(Value: WideString);
    procedure Set_Cmt(Value: WideString);
    procedure Set_Desc(Value: WideString);
    procedure Set_Src(Value: WideString);
    procedure Set_Number(Value: LongWord);
    procedure Set_Type_(Value: WideString);
    { Méthodes & propriétés }
    property Name: WideString read Get_Name write Set_Name;
    property Cmt: WideString read Get_Cmt write Set_Cmt;
    property Desc: WideString read Get_Desc write Set_Desc;
    property Src: WideString read Get_Src write Set_Src;
    property Link: IXMLLinkTypeList read Get_Link;
    property Number: LongWord read Get_Number write Set_Number;
    property Type_: WideString read Get_Type_ write Set_Type_;
    property Extensions: IXMLExtensionsType read Get_Extensions;
    property Rtept: IXMLWptTypeList read Get_Rtept;
  end;

{ IXMLRteTypeList }

  IXMLRteTypeList = interface(IXMLNodeCollection)
    ['{EAC07268-534E-4E10-865D-5F46E165FCC7}']
    { Méthodes & propriétés }
    function Add: IXMLRteType;
    function Insert(const Index: Integer): IXMLRteType;
    function Get_Item(Index: Integer): IXMLRteType;
    property Items[Index: Integer]: IXMLRteType read Get_Item; default;
  end;

{ IXMLTrkType }

  IXMLTrkType = interface(IXMLNode)
    ['{AE6445A0-CCDD-4E0D-8EFE-42127467ED0E}']
    { Accesseurs de propriétés }
    function Get_Name: WideString;
    function Get_Cmt: WideString;
    function Get_Desc: WideString;
    function Get_Src: WideString;
    function Get_Link: IXMLLinkTypeList;
    function Get_Number: LongWord;
    function Get_Type_: WideString;
    function Get_Extensions: IXMLExtensionsType;
    function Get_Trkseg: IXMLTrksegTypeList;
    procedure Set_Name(Value: WideString);
    procedure Set_Cmt(Value: WideString);
    procedure Set_Desc(Value: WideString);
    procedure Set_Src(Value: WideString);
    procedure Set_Number(Value: LongWord);
    procedure Set_Type_(Value: WideString);
    { Méthodes & propriétés }
    property Name: WideString read Get_Name write Set_Name;
    property Cmt: WideString read Get_Cmt write Set_Cmt;
    property Desc: WideString read Get_Desc write Set_Desc;
    property Src: WideString read Get_Src write Set_Src;
    property Link: IXMLLinkTypeList read Get_Link;
    property Number: LongWord read Get_Number write Set_Number;
    property Type_: WideString read Get_Type_ write Set_Type_;
    property Extensions: IXMLExtensionsType read Get_Extensions;
    property Trkseg: IXMLTrksegTypeList read Get_Trkseg;
  end;

{ IXMLTrkTypeList }

  IXMLTrkTypeList = interface(IXMLNodeCollection)
    ['{25989FDA-E815-4545-B7A2-63D6F730126A}']
    { Méthodes & propriétés }
    function Add: IXMLTrkType;
    function Insert(const Index: Integer): IXMLTrkType;
    function Get_Item(Index: Integer): IXMLTrkType;
    property Items[Index: Integer]: IXMLTrkType read Get_Item; default;
  end;

{ IXMLTrksegType }

  IXMLTrksegType = interface(IXMLNode)
    ['{A24F7479-6110-410F-9355-E3DE68110C7B}']
    { Accesseurs de propriétés }
    function Get_Trkpt: IXMLWptTypeList;
    function Get_Extensions: IXMLExtensionsType;
    { Méthodes & propriétés }
    property Trkpt: IXMLWptTypeList read Get_Trkpt;
    property Extensions: IXMLExtensionsType read Get_Extensions;
  end;

{ IXMLTrksegTypeList }

  IXMLTrksegTypeList = interface(IXMLNodeCollection)
    ['{BDB5C38E-A55E-4CAC-8C6A-423C4C1D5F1F}']
    { Méthodes & propriétés }
    function Add: IXMLTrksegType;
    function Insert(const Index: Integer): IXMLTrksegType;
    function Get_Item(Index: Integer): IXMLTrksegType;
    property Items[Index: Integer]: IXMLTrksegType read Get_Item; default;
  end;

{ IXMLPtType }

  IXMLPtType = interface(IXMLNode)
    ['{2AECB0A8-0F91-4CFA-92CF-14AD9079D847}']
    { Accesseurs de propriétés }
    function Get_Lat: WideString;
    function Get_Lon: WideString;
    function Get_Ele: WideString;
    function Get_Time: WideString;
    procedure Set_Lat(Value: WideString);
    procedure Set_Lon(Value: WideString);
    procedure Set_Ele(Value: WideString);
    procedure Set_Time(Value: WideString);
    { Méthodes & propriétés }
    property Lat: WideString read Get_Lat write Set_Lat;
    property Lon: WideString read Get_Lon write Set_Lon;
    property Ele: WideString read Get_Ele write Set_Ele;
    property Time: WideString read Get_Time write Set_Time;
  end;

{ IXMLPtsegType }

  IXMLPtsegType = interface(IXMLNodeCollection)
    ['{4A5C5A4F-D613-435F-8B6E-820E66AEFC04}']
    { Accesseurs de propriétés }
    function Get_Pt(Index: Integer): IXMLPtType;
    { Méthodes & propriétés }
    function Add: IXMLPtType;
    function Insert(const Index: Integer): IXMLPtType;
    property Pt[Index: Integer]: IXMLPtType read Get_Pt; default;
  end;

{ Décl. Forward }

  TXMLGpxType = class;
  TXMLMetadataType = class;
  TXMLPersonType = class;
  TXMLEmailType = class;
  TXMLLinkType = class;
  TXMLLinkTypeList = class;
  TXMLCopyrightType = class;
  TXMLBoundsType = class;
  TXMLExtensionsType = class;
  TXMLWptType = class;
  TXMLWptTypeList = class;
  TXMLRteType = class;
  TXMLRteTypeList = class;
  TXMLTrkType = class;
  TXMLTrkTypeList = class;
  TXMLTrksegType = class;
  TXMLTrksegTypeList = class;
  TXMLPtType = class;
  TXMLPtsegType = class;

{ TXMLGpxType }

  TXMLGpxType = class(TXMLNode, IXMLGpxType)
  private
    FWpt: IXMLWptTypeList;
    FRte: IXMLRteTypeList;
    FTrk: IXMLTrkTypeList;
  protected
    { IXMLGpxType }
    function Get_Version: WideString;
    function Get_Creator: WideString;
    function Get_Metadata: IXMLMetadataType;
    function Get_Wpt: IXMLWptTypeList;
    function Get_Rte: IXMLRteTypeList;
    function Get_Trk: IXMLTrkTypeList;
    function Get_Extensions: IXMLExtensionsType;
    procedure Set_Version(Value: WideString);
    procedure Set_Creator(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMetadataType }

  TXMLMetadataType = class(TXMLNode, IXMLMetadataType)
  private
    FLink: IXMLLinkTypeList;
  protected
    { IXMLMetadataType }
    function Get_Name: WideString;
    function Get_Desc: WideString;
    function Get_Author: IXMLPersonType;
    function Get_Copyright: IXMLCopyrightType;
    function Get_Link: IXMLLinkTypeList;
    function Get_Time: WideString;
    function Get_Keywords: WideString;
    function Get_Bounds: IXMLBoundsType;
    function Get_Extensions: IXMLExtensionsType;
    procedure Set_Name(Value: WideString);
    procedure Set_Desc(Value: WideString);
    procedure Set_Time(Value: WideString);
    procedure Set_Keywords(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPersonType }

  TXMLPersonType = class(TXMLNode, IXMLPersonType)
  protected
    { IXMLPersonType }
    function Get_Name: WideString;
    function Get_Email: IXMLEmailType;
    function Get_Link: IXMLLinkType;
    procedure Set_Name(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLEmailType }

  TXMLEmailType = class(TXMLNode, IXMLEmailType)
  protected
    { IXMLEmailType }
    function Get_Id: WideString;
    function Get_Domain: WideString;
    procedure Set_Id(Value: WideString);
    procedure Set_Domain(Value: WideString);
  end;

{ TXMLLinkType }

  TXMLLinkType = class(TXMLNode, IXMLLinkType)
  protected
    { IXMLLinkType }
    function Get_Href: WideString;
    function Get_Text: WideString;
    function Get_Type_: WideString;
    procedure Set_Href(Value: WideString);
    procedure Set_Text(Value: WideString);
    procedure Set_Type_(Value: WideString);
  end;

{ TXMLLinkTypeList }

  TXMLLinkTypeList = class(TXMLNodeCollection, IXMLLinkTypeList)
  protected
    { IXMLLinkTypeList }
    function Add: IXMLLinkType;
    function Insert(const Index: Integer): IXMLLinkType;
    function Get_Item(Index: Integer): IXMLLinkType;
  end;

{ TXMLCopyrightType }

  TXMLCopyrightType = class(TXMLNode, IXMLCopyrightType)
  protected
    { IXMLCopyrightType }
    function Get_Author: WideString;
    function Get_Year: WideString;
    function Get_License: WideString;
    procedure Set_Author(Value: WideString);
    procedure Set_Year(Value: WideString);
    procedure Set_License(Value: WideString);
  end;

{ TXMLBoundsType }

  TXMLBoundsType = class(TXMLNode, IXMLBoundsType)
  protected
    { IXMLBoundsType }
    function Get_Minlat: WideString;
    function Get_Minlon: WideString;
    function Get_Maxlat: WideString;
    function Get_Maxlon: WideString;
    procedure Set_Minlat(Value: WideString);
    procedure Set_Minlon(Value: WideString);
    procedure Set_Maxlat(Value: WideString);
    procedure Set_Maxlon(Value: WideString);
  end;

{ TXMLExtensionsType }

  TXMLExtensionsType = class(TXMLNode, IXMLExtensionsType)
  protected
    { IXMLExtensionsType }
  end;

{ TXMLWptType }

  TXMLWptType = class(TXMLNode, IXMLWptType)
  private
    FLink: IXMLLinkTypeList;
  protected
    { IXMLWptType }
    function Get_Lat: WideString;
    function Get_Lon: WideString;
    function Get_Ele: WideString;
    function Get_Time: WideString;
    function Get_Magvar: WideString;
    function Get_Geoidheight: WideString;
    function Get_Name: WideString;
    function Get_Cmt: WideString;
    function Get_Desc: WideString;
    function Get_Src: WideString;
    function Get_Link: IXMLLinkTypeList;
    function Get_Sym: WideString;
    function Get_Type_: WideString;
    function Get_Fix: WideString;
    function Get_Sat: LongWord;
    function Get_Hdop: WideString;
    function Get_Vdop: WideString;
    function Get_Pdop: WideString;
    function Get_Ageofdgpsdata: WideString;
    function Get_Dgpsid: Integer;
    function Get_Extensions: IXMLExtensionsType;
    procedure Set_Lat(Value: WideString);
    procedure Set_Lon(Value: WideString);
    procedure Set_Ele(Value: WideString);
    procedure Set_Time(Value: WideString);
    procedure Set_Magvar(Value: WideString);
    procedure Set_Geoidheight(Value: WideString);
    procedure Set_Name(Value: WideString);
    procedure Set_Cmt(Value: WideString);
    procedure Set_Desc(Value: WideString);
    procedure Set_Src(Value: WideString);
    procedure Set_Sym(Value: WideString);
    procedure Set_Type_(Value: WideString);
    procedure Set_Fix(Value: WideString);
    procedure Set_Sat(Value: LongWord);
    procedure Set_Hdop(Value: WideString);
    procedure Set_Vdop(Value: WideString);
    procedure Set_Pdop(Value: WideString);
    procedure Set_Ageofdgpsdata(Value: WideString);
    procedure Set_Dgpsid(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWptTypeList }

  TXMLWptTypeList = class(TXMLNodeCollection, IXMLWptTypeList)
  protected
    { IXMLWptTypeList }
    function Add: IXMLWptType;
    function Insert(const Index: Integer): IXMLWptType;
    function Get_Item(Index: Integer): IXMLWptType;
  end;

{ TXMLRteType }

  TXMLRteType = class(TXMLNode, IXMLRteType)
  private
    FLink: IXMLLinkTypeList;
    FRtept: IXMLWptTypeList;
  protected
    { IXMLRteType }
    function Get_Name: WideString;
    function Get_Cmt: WideString;
    function Get_Desc: WideString;
    function Get_Src: WideString;
    function Get_Link: IXMLLinkTypeList;
    function Get_Number: LongWord;
    function Get_Type_: WideString;
    function Get_Extensions: IXMLExtensionsType;
    function Get_Rtept: IXMLWptTypeList;
    procedure Set_Name(Value: WideString);
    procedure Set_Cmt(Value: WideString);
    procedure Set_Desc(Value: WideString);
    procedure Set_Src(Value: WideString);
    procedure Set_Number(Value: LongWord);
    procedure Set_Type_(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRteTypeList }

  TXMLRteTypeList = class(TXMLNodeCollection, IXMLRteTypeList)
  protected
    { IXMLRteTypeList }
    function Add: IXMLRteType;
    function Insert(const Index: Integer): IXMLRteType;
    function Get_Item(Index: Integer): IXMLRteType;
  end;

{ TXMLTrkType }

  TXMLTrkType = class(TXMLNode, IXMLTrkType)
  private
    FLink: IXMLLinkTypeList;
    FTrkseg: IXMLTrksegTypeList;
  protected
    { IXMLTrkType }
    function Get_Name: WideString;
    function Get_Cmt: WideString;
    function Get_Desc: WideString;
    function Get_Src: WideString;
    function Get_Link: IXMLLinkTypeList;
    function Get_Number: LongWord;
    function Get_Type_: WideString;
    function Get_Extensions: IXMLExtensionsType;
    function Get_Trkseg: IXMLTrksegTypeList;
    procedure Set_Name(Value: WideString);
    procedure Set_Cmt(Value: WideString);
    procedure Set_Desc(Value: WideString);
    procedure Set_Src(Value: WideString);
    procedure Set_Number(Value: LongWord);
    procedure Set_Type_(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTrkTypeList }

  TXMLTrkTypeList = class(TXMLNodeCollection, IXMLTrkTypeList)
  protected
    { IXMLTrkTypeList }
    function Add: IXMLTrkType;
    function Insert(const Index: Integer): IXMLTrkType;
    function Get_Item(Index: Integer): IXMLTrkType;
  end;

{ TXMLTrksegType }

  TXMLTrksegType = class(TXMLNode, IXMLTrksegType)
  private
    FTrkpt: IXMLWptTypeList;
  protected
    { IXMLTrksegType }
    function Get_Trkpt: IXMLWptTypeList;
    function Get_Extensions: IXMLExtensionsType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTrksegTypeList }

  TXMLTrksegTypeList = class(TXMLNodeCollection, IXMLTrksegTypeList)
  protected
    { IXMLTrksegTypeList }
    function Add: IXMLTrksegType;
    function Insert(const Index: Integer): IXMLTrksegType;
    function Get_Item(Index: Integer): IXMLTrksegType;
  end;

{ TXMLPtType }

  TXMLPtType = class(TXMLNode, IXMLPtType)
  protected
    { IXMLPtType }
    function Get_Lat: WideString;
    function Get_Lon: WideString;
    function Get_Ele: WideString;
    function Get_Time: WideString;
    procedure Set_Lat(Value: WideString);
    procedure Set_Lon(Value: WideString);
    procedure Set_Ele(Value: WideString);
    procedure Set_Time(Value: WideString);
  end;

{ TXMLPtsegType }

  TXMLPtsegType = class(TXMLNodeCollection, IXMLPtsegType)
  protected
    { IXMLPtsegType }
    function Get_Pt(Index: Integer): IXMLPtType;
    function Add: IXMLPtType;
    function Insert(const Index: Integer): IXMLPtType;
  public
    procedure AfterConstruction; override;
  end;

{ Fonctions globales }

function Getgpx(Doc: IXMLDocument): IXMLGpxType;
function Loadgpx(const FileName: WideString): IXMLGpxType;
function Newgpx: IXMLGpxType;

const
  TargetNamespace = 'http://www.topografix.com/GPX/1/1';

implementation

{ Fonctions globales }

function Getgpx(Doc: IXMLDocument): IXMLGpxType;
begin
  Result := Doc.GetDocBinding('gpx', TXMLGpxType, TargetNamespace) as IXMLGpxType;
end;

function Loadgpx(const FileName: WideString): IXMLGpxType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('gpx', TXMLGpxType, TargetNamespace) as IXMLGpxType;
end;

function Newgpx: IXMLGpxType;
begin
  Result := NewXMLDocument.GetDocBinding('gpx', TXMLGpxType, TargetNamespace) as IXMLGpxType;
end;

{ TXMLGpxType }

procedure TXMLGpxType.AfterConstruction;
begin
  RegisterChildNode('metadata', TXMLMetadataType);
  RegisterChildNode('wpt', TXMLWptType);
  RegisterChildNode('rte', TXMLRteType);
  RegisterChildNode('trk', TXMLTrkType);
  RegisterChildNode('extensions', TXMLExtensionsType);
  FWpt := CreateCollection(TXMLWptTypeList, IXMLWptType, 'wpt') as IXMLWptTypeList;
  FRte := CreateCollection(TXMLRteTypeList, IXMLRteType, 'rte') as IXMLRteTypeList;
  FTrk := CreateCollection(TXMLTrkTypeList, IXMLTrkType, 'trk') as IXMLTrkTypeList;
  inherited;
end;

function TXMLGpxType.Get_Version: WideString;
begin
  Result := AttributeNodes['version'].Text;
end;

procedure TXMLGpxType.Set_Version(Value: WideString);
begin
  SetAttribute('version', Value);
end;

function TXMLGpxType.Get_Creator: WideString;
begin
  Result := AttributeNodes['creator'].Text;
end;

procedure TXMLGpxType.Set_Creator(Value: WideString);
begin
  SetAttribute('creator', Value);
end;

function TXMLGpxType.Get_Metadata: IXMLMetadataType;
begin
  Result := ChildNodes['metadata'] as IXMLMetadataType;
end;

function TXMLGpxType.Get_Wpt: IXMLWptTypeList;
begin
  Result := FWpt;
end;

function TXMLGpxType.Get_Rte: IXMLRteTypeList;
begin
  Result := FRte;
end;

function TXMLGpxType.Get_Trk: IXMLTrkTypeList;
begin
  Result := FTrk;
end;

function TXMLGpxType.Get_Extensions: IXMLExtensionsType;
begin
  Result := ChildNodes['extensions'] as IXMLExtensionsType;
end;

{ TXMLMetadataType }

procedure TXMLMetadataType.AfterConstruction;
begin
  RegisterChildNode('author', TXMLPersonType);
  RegisterChildNode('copyright', TXMLCopyrightType);
  RegisterChildNode('link', TXMLLinkType);
  RegisterChildNode('bounds', TXMLBoundsType);
  RegisterChildNode('extensions', TXMLExtensionsType);
  FLink := CreateCollection(TXMLLinkTypeList, IXMLLinkType, 'link') as IXMLLinkTypeList;
  inherited;
end;

function TXMLMetadataType.Get_Name: WideString;
begin
  Result := ChildNodes['name'].Text;
end;

procedure TXMLMetadataType.Set_Name(Value: WideString);
begin
  ChildNodes['name'].NodeValue := Value;
end;

function TXMLMetadataType.Get_Desc: WideString;
begin
  Result := ChildNodes['desc'].Text;
end;

procedure TXMLMetadataType.Set_Desc(Value: WideString);
begin
  ChildNodes['desc'].NodeValue := Value;
end;

function TXMLMetadataType.Get_Author: IXMLPersonType;
begin
  Result := ChildNodes['author'] as IXMLPersonType;
end;

function TXMLMetadataType.Get_Copyright: IXMLCopyrightType;
begin
  Result := ChildNodes['copyright'] as IXMLCopyrightType;
end;

function TXMLMetadataType.Get_Link: IXMLLinkTypeList;
begin
  Result := FLink;
end;

function TXMLMetadataType.Get_Time: WideString;
begin
  Result := ChildNodes['time'].Text;
end;

procedure TXMLMetadataType.Set_Time(Value: WideString);
begin
  ChildNodes['time'].NodeValue := Value;
end;

function TXMLMetadataType.Get_Keywords: WideString;
begin
  Result := ChildNodes['keywords'].Text;
end;

procedure TXMLMetadataType.Set_Keywords(Value: WideString);
begin
  ChildNodes['keywords'].NodeValue := Value;
end;

function TXMLMetadataType.Get_Bounds: IXMLBoundsType;
begin
  Result := ChildNodes['bounds'] as IXMLBoundsType;
end;

function TXMLMetadataType.Get_Extensions: IXMLExtensionsType;
begin
  Result := ChildNodes['extensions'] as IXMLExtensionsType;
end;

{ TXMLPersonType }

procedure TXMLPersonType.AfterConstruction;
begin
  RegisterChildNode('email', TXMLEmailType);
  RegisterChildNode('link', TXMLLinkType);
  inherited;
end;

function TXMLPersonType.Get_Name: WideString;
begin
  Result := ChildNodes['name'].Text;
end;

procedure TXMLPersonType.Set_Name(Value: WideString);
begin
  ChildNodes['name'].NodeValue := Value;
end;

function TXMLPersonType.Get_Email: IXMLEmailType;
begin
  Result := ChildNodes['email'] as IXMLEmailType;
end;

function TXMLPersonType.Get_Link: IXMLLinkType;
begin
  Result := ChildNodes['link'] as IXMLLinkType;
end;

{ TXMLEmailType }

function TXMLEmailType.Get_Id: WideString;
begin
  Result := AttributeNodes['id'].Text;
end;

procedure TXMLEmailType.Set_Id(Value: WideString);
begin
  SetAttribute('id', Value);
end;

function TXMLEmailType.Get_Domain: WideString;
begin
  Result := AttributeNodes['domain'].Text;
end;

procedure TXMLEmailType.Set_Domain(Value: WideString);
begin
  SetAttribute('domain', Value);
end;

{ TXMLLinkType }

function TXMLLinkType.Get_Href: WideString;
begin
  Result := AttributeNodes['href'].Text;
end;

procedure TXMLLinkType.Set_Href(Value: WideString);
begin
  SetAttribute('href', Value);
end;

function TXMLLinkType.Get_Text: WideString;
begin
  Result := ChildNodes['text'].Text;
end;

procedure TXMLLinkType.Set_Text(Value: WideString);
begin
  ChildNodes['text'].NodeValue := Value;
end;

function TXMLLinkType.Get_Type_: WideString;
begin
  Result := ChildNodes['type'].Text;
end;

procedure TXMLLinkType.Set_Type_(Value: WideString);
begin
  ChildNodes['type'].NodeValue := Value;
end;

{ TXMLLinkTypeList }

function TXMLLinkTypeList.Add: IXMLLinkType;
begin
  Result := AddItem(-1) as IXMLLinkType;
end;

function TXMLLinkTypeList.Insert(const Index: Integer): IXMLLinkType;
begin
  Result := AddItem(Index) as IXMLLinkType;
end;
function TXMLLinkTypeList.Get_Item(Index: Integer): IXMLLinkType;
begin
  Result := List[Index] as IXMLLinkType;
end;

{ TXMLCopyrightType }

function TXMLCopyrightType.Get_Author: WideString;
begin
  Result := AttributeNodes['author'].Text;
end;

procedure TXMLCopyrightType.Set_Author(Value: WideString);
begin
  SetAttribute('author', Value);
end;

function TXMLCopyrightType.Get_Year: WideString;
begin
  Result := ChildNodes['year'].Text;
end;

procedure TXMLCopyrightType.Set_Year(Value: WideString);
begin
  ChildNodes['year'].NodeValue := Value;
end;

function TXMLCopyrightType.Get_License: WideString;
begin
  Result := ChildNodes['license'].Text;
end;

procedure TXMLCopyrightType.Set_License(Value: WideString);
begin
  ChildNodes['license'].NodeValue := Value;
end;

{ TXMLBoundsType }

function TXMLBoundsType.Get_Minlat: WideString;
begin
  Result := AttributeNodes['minlat'].Text;
end;

procedure TXMLBoundsType.Set_Minlat(Value: WideString);
begin
  SetAttribute('minlat', Value);
end;

function TXMLBoundsType.Get_Minlon: WideString;
begin
  Result := AttributeNodes['minlon'].Text;
end;

procedure TXMLBoundsType.Set_Minlon(Value: WideString);
begin
  SetAttribute('minlon', Value);
end;

function TXMLBoundsType.Get_Maxlat: WideString;
begin
  Result := AttributeNodes['maxlat'].Text;
end;

procedure TXMLBoundsType.Set_Maxlat(Value: WideString);
begin
  SetAttribute('maxlat', Value);
end;

function TXMLBoundsType.Get_Maxlon: WideString;
begin
  Result := AttributeNodes['maxlon'].Text;
end;

procedure TXMLBoundsType.Set_Maxlon(Value: WideString);
begin
  SetAttribute('maxlon', Value);
end;

{ TXMLExtensionsType }

{ TXMLWptType }

procedure TXMLWptType.AfterConstruction;
begin
  RegisterChildNode('link', TXMLLinkType);
  RegisterChildNode('extensions', TXMLExtensionsType);
  FLink := CreateCollection(TXMLLinkTypeList, IXMLLinkType, 'link') as IXMLLinkTypeList;
  inherited;
end;

function TXMLWptType.Get_Lat: WideString;
begin
  Result := AttributeNodes['lat'].Text;
end;

procedure TXMLWptType.Set_Lat(Value: WideString);
begin
  SetAttribute('lat', Value);
end;

function TXMLWptType.Get_Lon: WideString;
begin
  Result := AttributeNodes['lon'].Text;
end;

procedure TXMLWptType.Set_Lon(Value: WideString);
begin
  SetAttribute('lon', Value);
end;

function TXMLWptType.Get_Ele: WideString;
begin
  Result := ChildNodes['ele'].Text;
end;

procedure TXMLWptType.Set_Ele(Value: WideString);
begin
  ChildNodes['ele'].NodeValue := Value;
end;

function TXMLWptType.Get_Time: WideString;
begin
  Result := ChildNodes['time'].Text;
end;

procedure TXMLWptType.Set_Time(Value: WideString);
begin
  ChildNodes['time'].NodeValue := Value;
end;

function TXMLWptType.Get_Magvar: WideString;
begin
  Result := ChildNodes['magvar'].Text;
end;

procedure TXMLWptType.Set_Magvar(Value: WideString);
begin
  ChildNodes['magvar'].NodeValue := Value;
end;

function TXMLWptType.Get_Geoidheight: WideString;
begin
  Result := ChildNodes['geoidheight'].Text;
end;

procedure TXMLWptType.Set_Geoidheight(Value: WideString);
begin
  ChildNodes['geoidheight'].NodeValue := Value;
end;

function TXMLWptType.Get_Name: WideString;
begin
  Result := ChildNodes['name'].Text;
end;

procedure TXMLWptType.Set_Name(Value: WideString);
begin
  ChildNodes['name'].NodeValue := Value;
end;

function TXMLWptType.Get_Cmt: WideString;
begin
  Result := ChildNodes['cmt'].Text;
end;

procedure TXMLWptType.Set_Cmt(Value: WideString);
begin
  ChildNodes['cmt'].NodeValue := Value;
end;

function TXMLWptType.Get_Desc: WideString;
begin
  Result := ChildNodes['desc'].Text;
end;

procedure TXMLWptType.Set_Desc(Value: WideString);
begin
  ChildNodes['desc'].NodeValue := Value;
end;

function TXMLWptType.Get_Src: WideString;
begin
  Result := ChildNodes['src'].Text;
end;

procedure TXMLWptType.Set_Src(Value: WideString);
begin
  ChildNodes['src'].NodeValue := Value;
end;

function TXMLWptType.Get_Link: IXMLLinkTypeList;
begin
  Result := FLink;
end;

function TXMLWptType.Get_Sym: WideString;
begin
  Result := ChildNodes['sym'].Text;
end;

procedure TXMLWptType.Set_Sym(Value: WideString);
begin
  ChildNodes['sym'].NodeValue := Value;
end;

function TXMLWptType.Get_Type_: WideString;
begin
  Result := ChildNodes['type'].Text;
end;

procedure TXMLWptType.Set_Type_(Value: WideString);
begin
  ChildNodes['type'].NodeValue := Value;
end;

function TXMLWptType.Get_Fix: WideString;
begin
  Result := ChildNodes['fix'].Text;
end;

procedure TXMLWptType.Set_Fix(Value: WideString);
begin
  ChildNodes['fix'].NodeValue := Value;
end;

function TXMLWptType.Get_Sat: LongWord;
begin
  Result := ChildNodes['sat'].NodeValue;
end;

procedure TXMLWptType.Set_Sat(Value: LongWord);
begin
  ChildNodes['sat'].NodeValue := Value;
end;

function TXMLWptType.Get_Hdop: WideString;
begin
  Result := ChildNodes['hdop'].Text;
end;

procedure TXMLWptType.Set_Hdop(Value: WideString);
begin
  ChildNodes['hdop'].NodeValue := Value;
end;

function TXMLWptType.Get_Vdop: WideString;
begin
  Result := ChildNodes['vdop'].Text;
end;

procedure TXMLWptType.Set_Vdop(Value: WideString);
begin
  ChildNodes['vdop'].NodeValue := Value;
end;

function TXMLWptType.Get_Pdop: WideString;
begin
  Result := ChildNodes['pdop'].Text;
end;

procedure TXMLWptType.Set_Pdop(Value: WideString);
begin
  ChildNodes['pdop'].NodeValue := Value;
end;

function TXMLWptType.Get_Ageofdgpsdata: WideString;
begin
  Result := ChildNodes['ageofdgpsdata'].Text;
end;

procedure TXMLWptType.Set_Ageofdgpsdata(Value: WideString);
begin
  ChildNodes['ageofdgpsdata'].NodeValue := Value;
end;

function TXMLWptType.Get_Dgpsid: Integer;
begin
  Result := ChildNodes['dgpsid'].NodeValue;
end;

procedure TXMLWptType.Set_Dgpsid(Value: Integer);
begin
  ChildNodes['dgpsid'].NodeValue := Value;
end;

function TXMLWptType.Get_Extensions: IXMLExtensionsType;
begin
  Result := ChildNodes['extensions'] as IXMLExtensionsType;
end;

{ TXMLWptTypeList }

function TXMLWptTypeList.Add: IXMLWptType;
begin
  Result := AddItem(-1) as IXMLWptType;
end;

function TXMLWptTypeList.Insert(const Index: Integer): IXMLWptType;
begin
  Result := AddItem(Index) as IXMLWptType;
end;
function TXMLWptTypeList.Get_Item(Index: Integer): IXMLWptType;
begin
  Result := List[Index] as IXMLWptType;
end;

{ TXMLRteType }

procedure TXMLRteType.AfterConstruction;
begin
  RegisterChildNode('link', TXMLLinkType);
  RegisterChildNode('extensions', TXMLExtensionsType);
  RegisterChildNode('rtept', TXMLWptType);
  FLink := CreateCollection(TXMLLinkTypeList, IXMLLinkType, 'link') as IXMLLinkTypeList;
  FRtept := CreateCollection(TXMLWptTypeList, IXMLWptType, 'rtept') as IXMLWptTypeList;
  inherited;
end;

function TXMLRteType.Get_Name: WideString;
begin
  Result := ChildNodes['name'].Text;
end;

procedure TXMLRteType.Set_Name(Value: WideString);
begin
  ChildNodes['name'].NodeValue := Value;
end;

function TXMLRteType.Get_Cmt: WideString;
begin
  Result := ChildNodes['cmt'].Text;
end;

procedure TXMLRteType.Set_Cmt(Value: WideString);
begin
  ChildNodes['cmt'].NodeValue := Value;
end;

function TXMLRteType.Get_Desc: WideString;
begin
  Result := ChildNodes['desc'].Text;
end;

procedure TXMLRteType.Set_Desc(Value: WideString);
begin
  ChildNodes['desc'].NodeValue := Value;
end;

function TXMLRteType.Get_Src: WideString;
begin
  Result := ChildNodes['src'].Text;
end;

procedure TXMLRteType.Set_Src(Value: WideString);
begin
  ChildNodes['src'].NodeValue := Value;
end;

function TXMLRteType.Get_Link: IXMLLinkTypeList;
begin
  Result := FLink;
end;

function TXMLRteType.Get_Number: LongWord;
begin
  Result := ChildNodes['number'].NodeValue;
end;

procedure TXMLRteType.Set_Number(Value: LongWord);
begin
  ChildNodes['number'].NodeValue := Value;
end;

function TXMLRteType.Get_Type_: WideString;
begin
  Result := ChildNodes['type'].Text;
end;

procedure TXMLRteType.Set_Type_(Value: WideString);
begin
  ChildNodes['type'].NodeValue := Value;
end;

function TXMLRteType.Get_Extensions: IXMLExtensionsType;
begin
  Result := ChildNodes['extensions'] as IXMLExtensionsType;
end;

function TXMLRteType.Get_Rtept: IXMLWptTypeList;
begin
  Result := FRtept;
end;

{ TXMLRteTypeList }

function TXMLRteTypeList.Add: IXMLRteType;
begin
  Result := AddItem(-1) as IXMLRteType;
end;

function TXMLRteTypeList.Insert(const Index: Integer): IXMLRteType;
begin
  Result := AddItem(Index) as IXMLRteType;
end;
function TXMLRteTypeList.Get_Item(Index: Integer): IXMLRteType;
begin
  Result := List[Index] as IXMLRteType;
end;

{ TXMLTrkType }

procedure TXMLTrkType.AfterConstruction;
begin
  RegisterChildNode('link', TXMLLinkType);
  RegisterChildNode('extensions', TXMLExtensionsType);
  RegisterChildNode('trkseg', TXMLTrksegType);
  FLink := CreateCollection(TXMLLinkTypeList, IXMLLinkType, 'link') as IXMLLinkTypeList;
  FTrkseg := CreateCollection(TXMLTrksegTypeList, IXMLTrksegType, 'trkseg') as IXMLTrksegTypeList;
  inherited;
end;

function TXMLTrkType.Get_Name: WideString;
begin
  Result := ChildNodes['name'].Text;
end;

procedure TXMLTrkType.Set_Name(Value: WideString);
begin
  ChildNodes['name'].NodeValue := Value;
end;

function TXMLTrkType.Get_Cmt: WideString;
begin
  Result := ChildNodes['cmt'].Text;
end;

procedure TXMLTrkType.Set_Cmt(Value: WideString);
begin
  ChildNodes['cmt'].NodeValue := Value;
end;

function TXMLTrkType.Get_Desc: WideString;
begin
  Result := ChildNodes['desc'].Text;
end;

procedure TXMLTrkType.Set_Desc(Value: WideString);
begin
  ChildNodes['desc'].NodeValue := Value;
end;

function TXMLTrkType.Get_Src: WideString;
begin
  Result := ChildNodes['src'].Text;
end;

procedure TXMLTrkType.Set_Src(Value: WideString);
begin
  ChildNodes['src'].NodeValue := Value;
end;

function TXMLTrkType.Get_Link: IXMLLinkTypeList;
begin
  Result := FLink;
end;

function TXMLTrkType.Get_Number: LongWord;
begin
  Result := ChildNodes['number'].NodeValue;
end;

procedure TXMLTrkType.Set_Number(Value: LongWord);
begin
  ChildNodes['number'].NodeValue := Value;
end;

function TXMLTrkType.Get_Type_: WideString;
begin
  Result := ChildNodes['type'].Text;
end;

procedure TXMLTrkType.Set_Type_(Value: WideString);
begin
  ChildNodes['type'].NodeValue := Value;
end;

function TXMLTrkType.Get_Extensions: IXMLExtensionsType;
begin
  Result := ChildNodes['extensions'] as IXMLExtensionsType;
end;

function TXMLTrkType.Get_Trkseg: IXMLTrksegTypeList;
begin
  Result := FTrkseg;
end;

{ TXMLTrkTypeList }

function TXMLTrkTypeList.Add: IXMLTrkType;
begin
  Result := AddItem(-1) as IXMLTrkType;
end;

function TXMLTrkTypeList.Insert(const Index: Integer): IXMLTrkType;
begin
  Result := AddItem(Index) as IXMLTrkType;
end;
function TXMLTrkTypeList.Get_Item(Index: Integer): IXMLTrkType;
begin
  Result := List[Index] as IXMLTrkType;
end;

{ TXMLTrksegType }

procedure TXMLTrksegType.AfterConstruction;
begin
  RegisterChildNode('trkpt', TXMLWptType);
  RegisterChildNode('extensions', TXMLExtensionsType);
  FTrkpt := CreateCollection(TXMLWptTypeList, IXMLWptType, 'trkpt') as IXMLWptTypeList;
  inherited;
end;

function TXMLTrksegType.Get_Trkpt: IXMLWptTypeList;
begin
  Result := FTrkpt;
end;

function TXMLTrksegType.Get_Extensions: IXMLExtensionsType;
begin
  Result := ChildNodes['extensions'] as IXMLExtensionsType;
end;

{ TXMLTrksegTypeList }

function TXMLTrksegTypeList.Add: IXMLTrksegType;
begin
  Result := AddItem(-1) as IXMLTrksegType;
end;

function TXMLTrksegTypeList.Insert(const Index: Integer): IXMLTrksegType;
begin
  Result := AddItem(Index) as IXMLTrksegType;
end;
function TXMLTrksegTypeList.Get_Item(Index: Integer): IXMLTrksegType;
begin
  Result := List[Index] as IXMLTrksegType;
end;

{ TXMLPtType }

function TXMLPtType.Get_Lat: WideString;
begin
  Result := AttributeNodes['lat'].Text;
end;

procedure TXMLPtType.Set_Lat(Value: WideString);
begin
  SetAttribute('lat', Value);
end;

function TXMLPtType.Get_Lon: WideString;
begin
  Result := AttributeNodes['lon'].Text;
end;

procedure TXMLPtType.Set_Lon(Value: WideString);
begin
  SetAttribute('lon', Value);
end;

function TXMLPtType.Get_Ele: WideString;
begin
  Result := ChildNodes['ele'].Text;
end;

procedure TXMLPtType.Set_Ele(Value: WideString);
begin
  ChildNodes['ele'].NodeValue := Value;
end;

function TXMLPtType.Get_Time: WideString;
begin
  Result := ChildNodes['time'].Text;
end;

procedure TXMLPtType.Set_Time(Value: WideString);
begin
  ChildNodes['time'].NodeValue := Value;
end;

{ TXMLPtsegType }

procedure TXMLPtsegType.AfterConstruction;
begin
  RegisterChildNode('pt', TXMLPtType);
  ItemTag := 'pt';
  ItemInterface := IXMLPtType;
  inherited;
end;

function TXMLPtsegType.Get_Pt(Index: Integer): IXMLPtType;
begin
  Result := List[Index] as IXMLPtType;
end;

function TXMLPtsegType.Add: IXMLPtType;
begin
  Result := AddItem(-1) as IXMLPtType;
end;

function TXMLPtsegType.Insert(const Index: Integer): IXMLPtType;
begin
  Result := AddItem(Index) as IXMLPtType;
end;

end. 