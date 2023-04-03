{ for the BlaisePascal Magazine #103}
Unit Geocoding_mX47610_VII_WinAPIDownload;

//{$mode objfpc}{$H+}

interface

implementation
//{$R *.lfm}

                                                                       
function TAddressGeoCodeOSM(faddress: string): string;
var
  url, res, display: string;
  jo, location: TJSONObject;
  urlid: TIduri; windown: TWinApiDownload;
 begin
  urlid:= TIdURI.create('');
  url:= urlid.URLEncode('https://nominatim.openstreetmap.org/search?format=json&q='+
                                                                fAddress);
  writeln(url)
  windown:= TWinApiDownload.create;
  windown.useragent:= 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1'; 
  windown.url:= url;
  writeln('check url '+itoa(windown.CheckURL(url)));      
  windown.download1(res);
  //windown.OnWorkStart
  StrReplace(res, '[{', '{');
  jo:= TJSONObject.create4(res);                   
  try
    if jo.getString('place_id') <> ' ' then               
      display:= jo.getstring('display_name');
    result:= Format('Coords: lat %2.5f  lng %2.5f  :%s  importance: %2.4f',
                  [jo.getdouble('lat'),jo.getdouble('lon'),display,
                                       jo.getdouble('importance')]);       
  except
    writeln('E: '+ExceptiontoString(exceptiontype, exceptionparam));                 
  finally                                  
    jo.Free;    
    urlid.free;
    windown.free;
  end; 
end;  


function TAddressGeoCoding4(faddr, fcountry: string): String;
var
  Url,API_KEY, source: string;
  jo, locate: TJSONObject;
  urlid: TIdURI; 
  fLat,fLong: double;
begin
  urlid:= TIdURI.create('');
  API_KEY:='785b4141b...................'; //get your own one please
  if fcountry <> '' then
    Url:= urlid.URLEncode('https://api.geocod.io/v1.7/geocode?q='+
                          fAddr+'&country='+fcountry+'&api_key='+API_KEY) else
    Url:= urlid.URLEncode('https://api.geocod.io/v1.7/geocode?q='+
                          fAddr+'&api_key='+API_KEY);                                      
   
  jo:= TJSONObject.Create4(wdc_WinInet_HttpGet2(Url,Nil));
  try
    jo.getString('input')
    locate:= jo.getJSONArray('results').getJSONObject(0).getJSONObject('location');
    source:= jo.getJSONArray('results').getJSONObject(0).getString('source');
    //geometry.getJSONObject('coordinates');
    fLat:= locate.getDouble('lat') 
    fLong:= locate.getDouble('lng');
    result:=Format('Coordinates: lat %2.3f lng %2.3f :%s',[flat,flong,source]);
  except
    Xraise(Exception.Create(jo.getString('error')));
  finally                                      
    jo.Free;       
    urlid.free;
  end;  
end;  

               
begin  //@main

  writeln('CPUSpeed '+cpuspeed);
 //the hash trash smash
  maXcalcf('2^160'); maXcalcf('16^40');

  writeln('res back_: '+TAddressGeoCodeOSM('Winkelriedstrasse, Bern, Switzerland')); 
  
  writeln('res back_: '+TAddressGeoCodeOSM('Bonnaud, France'));
  writeln('res back_: '+TAddressGeoCodeOSM('Munich, Germany'));   
  
  OpenWeb('https://www.latlong.net/c/?lat=48.13711&long=11.57538');

 End.
end.

ref:
 {hnd:=InternetOpen('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; InfoPath.1)',
            INTERNET_OPEN_TYPE_PRECONFIG, '','',1);  }
  
 TWinApiDownload = class(TObject)
  private
    fEventWorkStart : TEventWorkStart;
    fEventWork : TEventWork;
    fEventWorkEnd : TEventWorkEnd;
    fEventError : TEventError;
    fURL : string;
    fUserAgent : string;
    fStop : Boolean;
    fActive : Boolean;
    fCachingEnabled : Boolean;
    fProgressUpdateInterval : Cardinal;
    function GetIsActive : Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function CheckURL(aURL: string) : Integer;
    function Download(Stream : TStream) : Integer; overload;
    function Download(var res : string) : Integer; overload;
    function ErrorCodeToMessageString(aErrorCode : Integer) : string;
    procedure Stop;
    procedure Clear;
    property UserAgent : string read fUserAgent write fUserAgent;
    property URL : string read fURL write fURL;
    property DownloadActive : Boolean read GetIsActive;
    property CachingEnabled : Boolean read fCachingEnabled write fCachingEnabled;
    property UpdateInterval:Cardinal read fProgressUpdateInterval write fProgressUpdateInterval;
    property OnWorkStart : TEventWorkStart read fEventWorkStart write fEventWorkStart;
    property OnWork : TEventWork read fEventWork write fEventWork;
    property OnWorkEnd : TEventWorkEnd read fEventWorkEnd write fEventWorkEnd;
    property OnError : TEventError read fEventError write fEventError;
  end;
  
  TEventWorkStart;
  TEventWork = procedure(Sender: TObject; iBytesTransfered: Int64) of object;
  TEventWorkEnd = procedure(Sender: TObject; iBytesTransfered: Int64;
                             ErrorCode: Integer) of object;
  TEventError = procedure(Sender : TObject; iErrorCode : Integer;
                         sURL : string) of object;
  
  
constructor TWinApiDownload.Create;
begin
  inherited;
  fUserAgent:= 'Mozilla/5.001(windows; U; NT4.0; en-US; rv:1.0) Gecko/25250101';
  fProgressUpdateInterval:= 100;
  fCachingEnabled:= True;
  fStop:= False;
  fActive:= False;
end;


-----_____
                   _____------           __      ----_
            ___----             ___------              \
               ----________        ----                 \
                           -----__    |             _____)
                                __-                /     \
                    _______-----    ___--          \    /)\
              ------_______      ---____            \__/  /
                           -----__    \ --    _          /\
                                  --__--__     \_____/   \_/\
                                          ----|   /          |
                                              |  |___________|
                                              |  | ((_(_)| )_)
                                              |  \_((_(_)|/(_)
                                              \             (
                                               \_____________)



https://dateandtime.info/citycoordinates.php?id=2661552
https://api.geocod.io/v1.7/geocode?q=cologne&api_key=785b4141b66646f4f421e5216e611b4e611f215
https://www.geocod.io/docs/?python#geocoding
https://github.com/Geocodio/openapi-spec/blob/master/geocodio-api.yml
tests online:
https://www.geoapify.com/geocoding-api

Geocodio provides bulk geocoding and reverse lookup services through a REST API. The API is able to process a single address, as well as handle bulk requests of up to 10,000 addresses. Geocoded results are returned with an accuracy score indicating the confidence Geocodio has in the accuracy of the result. Geocodio is also able to parse addresses into individual components.

Geographic coordinates of Delphi, Greece
Latitude: 38°28'45" N
Longitude: 22°29'36" E
Elevation above sea level: 560 m = 1837 ft

Geographic coordinates of Bern, Switzerland
Latitude: 46°56'53" N
Longitude: 7°26'50" E
Elevation above sea level: 549 m = 1801 ft

geo(address = c("Tokyo, Japan", "Lima, Peru", "Nairobi, Kenya"),
 method = 'osm')
#> Passing 3 addresses to the Nominatim single address geocoder
#> Query completed in: 3 seconds
#> # A tibble: 3 × 3
#>   address           lat  long
#>   <chr>           <dbl> <dbl>
#> 1 Tokyo, Japan    35.7  140. 
#> 2 Lima, Peru     -12.1  -77.0
#> 3 Nairobi, Kenya  -1.28  36.8


  
  
