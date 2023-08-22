unit vwebMod;

interface

uses
  SysUtils, Classes, HTTPApp, WSDLPub, SOAPPasInv, SOAPHTTPPasInv,
  SOAPHTTPDisp, WebBrokerSOAP, InvokeRegistry, WSDLIntf, TypInfo, WebServExp,
  WSDLBind, XMLSchema, DBXpress, DB, SqlExpr, DBWeb;

type
  TWebModule1 = class(TWebModule)
    HTTPSoapDispatcher1: THTTPSoapDispatcher;
    HTTPSoapPascalInvoker1: THTTPSoapPascalInvoker;
    WSDLHTMLPublish1: TWSDLHTMLPublish;
    DataSetTableProducer1: TDataSetTableProducer;
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModule1runQueryAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    FdbPath: ShortString;
    FfilePath: ShortString;
    function getIBQueryDataset(myConnect: TSQLConnection;
                                 myDataSet: TSQLDataSet): TSQLDataSet;
  public
    procedure getFile_DatabasePath;
    procedure letSQLConnection(aConnect: TSQLConnection);
    property dbPath: ShortString read FdbPath;
    property filePath: ShortString read FfilePath;
  end;

var
  WebModule1: TWebModule1;

implementation

resourcestring
  StrSOADataSetScanner2 = 'SOA DataSet ScannerService 2007';
const
  StrPathinfotxt = 'pathinfo.txt';
  StrSELECTFROMKINGS = 'SELECT * FROM KINGS';

{$R *.DFM}

procedure TWebModule1.getFile_DatabasePath;
var
  F: TextFile;
  fName: ShortString;
begin
  fName:= StrPathinfotxt;
  if FileExists(fName) then begin
    assignFile(F,fName);
    reset(F);
    readln(F); //first line return
    readln(F, FFilePath);
    readln(F, FDBPath);
    closeFile(F)
  end else
     Response.Content:=
              Format('<html><body><b>File "%s" not found!'
                       + '</b></body></html>',[FName]);
end;

function TWebModule1.getIBQueryDataset(myConnect: TSQLConnection;
                                        myDataSet: TSQLDataSet): TSQLDataSet;
begin
  letSQLConnection(myconnect);
  with myDataSet do begin
      SQLConnection:= myconnect;
    paramCheck:= false;
    getmetaData:= false;
    CommandType:= ctQuery;
    CommandText:= StrSELECTFROMKINGS;
    try
      active:= true;
      result:= myDataSet;
    //silent cause of CGI or reraise after message
    except
    //to get a html userdefined Error
      webmodule1.Response.Content:= Format('<html><body><b>query "%s" not opened!'
          + '</b></body></html>', [commandtext]);
      raise
    end;
  end;
end;

procedure TWebModule1.letSQLConnection(aConnect: TSQLConnection);
begin
  with aConnect do begin
    ConnectionName:= 'VCLScanner';
    DriverName:= 'INTERBASE';
    //LibraryName:= 'dbexpint.dll' in D6;
    LibraryName:= 'dbxint30.dll';
    VendorLib:= 'GDS32.DLL';
    GetDriverFunc:= 'getSQLDriverINTERBASE';
    Params.Add('User_Name=SYSDBA');
    Params.Add('Password=masterkey');
    //Params.Add('Database=myserver:X:\vclscanner.gdb');
    Params.Add(dbPath);
    LoginPrompt:= False;
    try
      Open;
    except
      Response.Content:= Format('<html><body><b>connection "%s" NOK!'
          + '</b></body></html>', [connectionName]);
      raise
    end;
  end;

end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
           Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  //WSDLHTMLPublish1.DispatchRequest(Sender, Request, Response);
  //publish the path in url info !!! from path info soap*
  //you get the response by http://apsn21/cgi-bin/VCLScannerServer.exe
  Response.Content:= Format('<html><body><b>WebMod connection VCLS "%s" is OK!'
          + '</b></body></html>', ['default']);
end;

procedure TWebModule1.WebModule1runQueryAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  SQLConnection1: TSQLConnection;
  vDataSet: TSQLDataSet;
begin
   //start with: http://apsn21/cgi-bin/VCLScannerServer.exe/show
   //tableproducer is set by designtime
  SQLConnection1:= TSQLConnection.Create(NIL);
  vDataSet := TSQLDataSet.Create(NIL);
  //getFile_DatabasePath;
  with DataSetTableProducer1 do begin
    try
      dataSet:= getIBQueryDataset(SQLConnection1, vDataSet);
      //webmodule1.pproducercontent:= datasettableproducer1.Content;
      response.Content:= content;
    except
      Response.Content:= Format('<html><body><b>database "%s" /query not found!'
                           + '</b></body></html>', [dbpath]);
    end;
  end;
    SQLConnection1.Close;
    vDataSet.Free;
    SQLConnection1.Free;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  with dataSetTableProducer1 do begin
    MaxRows:= 50;
    tableAttributes.width:= 60;
    caption:= StrSOADataSetScanner2
  end;
  getFile_DatabasePath;
end;

end.
