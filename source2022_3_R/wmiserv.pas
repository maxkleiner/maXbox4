unit wmiserv;
// WMI service sample written by Glenn9999 at tek-tips.com
// add wmiconnect 2 /3
// https://www.tek-tips.com/faqs.cfm?fid=7316

interface
  uses comobj, activex, WbemScripting_TLB;

  const
    EOAC_NONE = 0;
    RPC_C_AUTHN_WINNT = 10;
    RPC_C_AUTHZ_NONE = 0;
    RPC_E_CHANGED_MODE = -2147417850;

function WMIStart: ISWBemLocator;
function WMIConnect(WBemLocator: ISWBemLocator; Server, account, password: string): ISWBemServices;
function WMIConnect2(WBemLocator: ISWBemLocator; namespace, Server, account, password: string): ISWBemServices;
function WMIConnect3(WBemLocator: ISWBemLocator; Server, namespace,  account, password: string): ISWBemServices;

function WMIExecQuery(WBemServices: ISWBemServices; query: string): ISWbemObjectSet;
function WMIRowFindFirst(ObjectSet: ISWbemObjectSet; var ENum: IEnumVariant; var tempobj: OleVariant): boolean;
function WMIRowFindNext(ENum: IENumVariant; var tempobj: OleVariant): boolean;
function WMIColFindFirst(var propENum: IENumVariant; var tempObj: OleVariant): boolean;
function WMIColFindNext(propENum: IENumVariant; var tempobj: OleVariant): boolean;
function WMIGetValue(wbemservices: ISWBemServices; tablename, fieldname: string): string;
function WMIConvValue(tempobj: OleVariant; var keyname: string): string;

function WMIRegConnect(WBemLocator: ISWBemLocator; Server, account, password: string): ISWBemServices;
procedure WMIGetMethodInfo(srv: ISWbemServices; objname, method: string;  var regobject, inparms: ISWBemObject);
procedure WMISetValue(InParam: ISWBemObject; keyvalue: string; invalue: OleVariant);


implementation
  uses sysutils, variants;

function WMIStart: ISWBemLocator;
  // creates the WMI instance along with any error checking
  var
    HRes: HResult;
  begin
    Result := nil;
    HRes := CoCreateInstance(Class_SWbemLocator, nil, CLSCTX_INPROC_SERVER,
              ISWbemLocator, Result);
    if HRes <> 0 then
      raise EOleException.Create('Locator instance not created.', 1, '', '', 0);
  end;

function WMIConnect(WBemLocator: ISWBemLocator; Server, account, password: string): ISWBemServices;
 // connects to a machine for WMI usage.
  begin
    Result := nil;
    try
      Result := WBEMLocator.ConnectServer(Server, 'root\CIMV2', '', Account,
               Password, '', 0, nil);
    except
      on EOleException do
        raise EOleException.Create('incorrect credentials.  WMI connection failed.', 1, '', '', 0);
    end;
    CoSetProxyBlanket(Result, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE,
             nil,
             wbemAuthenticationLevelCall, wbemImpersonationLevelImpersonate,
             nil, EOAC_NONE);
  end;

  function WMIConnect2(WBemLocator: ISWBemLocator; namespace, Server, account, password: string): ISWBemServices;
 // connects to a machine for WMI usage.
  begin
    Result := nil;
    try
      Result := WBEMLocator.ConnectServer(Server, namespace, '', Account,
               Password, '', 0, nil);
    except
      on EOleException do
        raise EOleException.Create('incorrect credentials.  WMI connection failed.', 1, '', '', 0);
    end;
    CoSetProxyBlanket(Result, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE,
             nil,
             wbemAuthenticationLevelCall, wbemImpersonationLevelImpersonate,
             nil, EOAC_NONE);
  end;

   function WMIConnect3(WBemLocator: ISWBemLocator; Server, namespace, account, password: string): ISWBemServices;
 // connects to a machine for WMI usage.
  begin
    Result := nil;
    try
      Result := WBEMLocator.ConnectServer(Server, namespace, '', Account,
               Password, '', 0, nil);
    except
      on EOleException do
        raise EOleException.Create('incorrect credentials.  WMI connection failed.', 1, '', '', 0);
    end;
    CoSetProxyBlanket(Result, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE,
             nil,
             wbemAuthenticationLevelCall, wbemImpersonationLevelImpersonate,
             nil, EOAC_NONE);
  end;

  function WMIExecQuery(WBemServices: ISWBemServices; query: string): ISWbemObjectSet;
  // executes a WQL query.
  begin
    Result := nil;
    try
      Result := WBEmServices.ExecQuery(query, 'WQL',
             wbemFlagReturnImmediately,
             nil);
    except
      on EOleException do
        raise EOleException.Create('Invalid statement.  Please resubmit.', 1, '', '', 0);
    end;
  end;

function WMIRowFindFirst(ObjectSet: ISWbemObjectSet; var ENum: IEnumVariant; var tempobj: OleVariant): boolean;
// finds the first row in a result set.
  var
    aValue: Cardinal;
  begin
    Enum :=  (ObjectSet._NewEnum) as IEnumVariant;
    //ENum.Next(1, tempObj, avalue);
    Result := (ENum.Next(1, tempObj, aValue) = 0);
  end;

function WMIRowFindNext(ENum: IENumVariant; var tempobj: OleVariant): boolean;
// finds the next row in a result set.
  var
    Value: cardinal;
  begin
    Result := (ENum.Next(1, tempObj, Value) = 0);
  end;

function WMIColFindFirst(var propENum: IENumVariant; var tempObj: OleVariant): boolean;
 // finds the first column in a row.
  var
    Value: cardinal;
    propSet: ISWBemPropertySet;
    SObject: ISWbemObject;
  begin
    SObject := IUnknown(tempObj) as ISWBemObject;
    propSet := SObject.Properties_;

    propEnum := (propSet._NewEnum) as IEnumVariant;
    Result := (propEnum.Next(1, tempObj, Value) = 0);
  end;

function WMIColFindNext(propENum: IENumVariant; var tempobj: OleVariant): boolean;
  // finds the next column in a row.
  var
    Value: cardinal;
  begin
    Result := (propENum.Next(1, tempObj, Value) = 0);
  end;

function WMIGetValue(wbemservices: ISWBemServices; tablename, fieldname: string): string;
  { this will return the value of the first fieldname that occurs in tablename }
  var
    statement: string;
    RowENum: IENumVariant;
    ObjectSet:  ISWbemObjectSet;
    tempobj: OleVariant;
    SObject: ISWbemObject;
    Sprop: ISWBemProperty;
  begin
    Result := '';
    statement := 'SELECT ' + fieldname + ' FROM ' + tablename;
    ObjectSet := WMIExecQuery(WbemServices, statement);
    if WMIRowFindFirst(ObjectSet, RowENum, tempobj) then
      begin
        SObject := IUnknown(tempObj) as ISWBemObject;
        SProp := SObject.Properties_.Item(fieldname, 0); // specific field property
        Result := WMIConvValue(SProp, fieldname);
      end;
  end;

function WMIConvValue(tempobj: OleVariant; var keyname: string): string;
  { generic WMI value to string conversion of "valuename".
    Returns the field name into "keyname".  Adapted from Denis Blondeau 's SWBEM example. }
  var
    Count: Longint;
    SProp: ISWbemProperty;
    valuename: string;
  begin
    SProp := IUnknown(tempObj) as ISWBemProperty;
    ValueName := '';
    if VarIsNull(SProp.Get_Value) then
      ValueName := '<empty>'
    else
      case SProp.CIMType of
         wbemCimtypeSint8, wbemCimtypeUint8, wbemCimtypeSint16, wbemCimtypeUint16,
         wbemCimtypeSint32, wbemCimtypeUint32, wbemCimtypeSint64:
           if VarIsArray(SProp.Get_Value) then
              begin
                if VarArrayHighBound(SProp.Get_Value, 1) > 0 then
                  for Count := 1 to VarArrayHighBound(SProp.Get_Value, 1) do
                    ValueName := ValueName + ' ' + IntToStr(SProp.Get_Value[Count]);
              end
           else
             ValueName := IntToStr(SProp.Get_Value);
         wbemCimtypeReal32, wbemCimtypeReal64:
           ValueName := FloatToStr(SProp.Get_Value);
         wbemCimtypeBoolean:
           if SProp.Get_Value then
             ValueName := 'True'
           else
             ValueName := 'False';
         wbemCimtypeString, wbemCimtypeUint64:
           if VarIsArray(SProp.Get_Value) then
              begin
                if VarArrayHighBound(SProp.Get_Value, 1) > 0 then
                  for Count := 1 to VarArrayHighBound(SProp.Get_Value, 1) do
                    ValueName := ValueName + ' ' + SProp.Get_Value[Count];
              end
           else
              ValueName :=  SProp.Get_Value;
         wbemCimtypeDatetime:
           ValueName :=  SProp.Get_Value;
         wbemCimtypeReference:
           ValueName := SProp.Get_Value;
         wbemCimtypeChar16:
           ValueName := '<16-bit character>';
         wbemCimtypeObject:
           ValueName := '<CIM Object>';
      else
        ValueName := '<Unknown type>';
      end; {case}
      keyname := String(SProp.Name);
      Result := ValueName;
end;

 const
    regobjstring = 'StdRegProv';

function WMIRegConnect(WBemLocator: ISWBemLocator; Server, account, password: string): ISWBemServices;
// connects to the default area 
  begin
    Result := nil;
    try
      Result := WBEMLocator.ConnectServer(Server, 'root\default', '', Account,
               Password, '', 0, nil);
    except
      on EOleException do
        raise EOleException.Create('incorrect credentials.  WMI connection failed.', 1, '', '', 0);
    end;
    CoSetProxyBlanket(Result, RPC_C_AUTHN_WINNT, RPC_C_AUTHZ_NONE,
             nil,
             wbemAuthenticationLevelCall, wbemImpersonationLevelImpersonate,
             nil, EOAC_NONE);
  end;

procedure WMIGetMethodInfo(srv: ISWbemServices; objname, method: string;  var regobject, inparms: ISWBemObject);
// gets method info and parms, this is useful if an object method is *NOT* tied to a specific record.
  begin
    regobject := srv.Get(objname, 0, nil);
    InParms := regobject.Methods_.Item(method, 0).InParameters;
  end;

procedure WMISetValue(InParam: ISWBemObject; keyvalue: string; invalue: OleVariant);
// sets a parm value.  Calls my modified set_value.
// remove the @ if you wish to make the default call.
  begin
    InParam.Properties_.Item(keyvalue, 0).Set_Value(InValue);
  end;


end.
//----code_cleared_checked_clean----