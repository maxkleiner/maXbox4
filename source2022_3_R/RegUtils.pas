{********************************************************************}
{                                                                    }
{        Routine work with TRegistry                                 }
{     Copyright (c) 04.1999-01.2001 by Serge Buzadzhy                }
{     email:  serge_buzadzhy@mail.ru,buzz@ukr.net                    }
{                                                                    }
{********************************************************************}

unit RegUtils;

interface
 uses Windows,SysUtils,Classes,registry, variants;

 procedure DefWriteToRegistry( const OtherKeys , ParamNames: array of string;
  const Values: array of Variant
 );

 procedure WriteToRegistry(aRootKey:HKEY; const OtherKeys,ParamNames: array of string;
  const Values: array of Variant
 );

 function ReadFromRegistry(aRootKey:HKEY;
  const OtherKeys,  ParamNames: array of string
 ):Variant;

 function DefReadFromRegistry(const OtherKeys, ParamNames: array of string):Variant;

 function AllSubKey(aRootKey:HKEY; const ForPath: array of string):Variant;
 function DefAllSubKey(const ForPath: array of string):Variant;

 function SaveRegKey(const FileName: String; const ForKey: array of string): Boolean;
 function LoadRegKey(const FileName: String; const ForKey: array of string): Boolean;

 function AltSaveRegKey(const FileName: String; const ForKey: array of string): Boolean;
 function AltLoadRegKey(const FileName: String; const ForKey: array of string): Boolean;
 function GetKeyForParValue(const aRootKey,ParName,ParValue:string):string;

implementation
uses inifiles,StrUtil;

{ HKEY  VALUES :
  HKEY_CURRENT_USER // Default
  HKEY_LOCAL_MACHINE
  HKEY_CLASSES_ROOT
  HKEY_USERS
  HKEY_PERFORMANCE_DATA
  HKEY_CURRENT_CONFIG
  HKEY_DYN_DATA
}
 var RegObj:TRegistry;

 procedure DefWriteToRegistry( const OtherKeys , ParamNames: array of string;
  const   Values: array of Variant
 );
 begin
  WriteToRegistry(HKEY_CURRENT_USER,OtherKeys,ParamNames,Values)
 end;

 procedure WriteToRegistry(aRootKey:HKEY;const  OtherKeys,ParamNames: array of string;
  const Values: array of Variant
 );
 var  i,minPar:integer;
 begin
//   RegObj:=TRegistry.Create;
   with RegObj do
   try
    RootKey:=aRootKey;
    for i:=Low(OtherKeys) to High(OtherKeys) do   OpenKey(OtherKeys[i],true);
    minPar:=High(ParamNames);
    if minPar>High(Values) then minPar:=High(Values);
    for i:=0 to minPar do
     case VarType(Values[i]) of
      varSmallint,varInteger:WriteInteger(ParamNames[i],Values[i]);
      varSingle,  varDouble :WriteFloat(ParamNames[i],Values[i]);
      varCurrency           :WriteCurrency(ParamNames[i],Values[i]);
      varBoolean            :WriteBool(ParamNames[i],Values[i]);
      varString             :WriteString(ParamNames[i],Values[i]);
      varDate               :WriteDateTime(ParamNames[i],Values[i]);
     end
   finally
    CloseKey;
   end;
end;

function ReadFromRegistry(aRootKey:HKEY;
 const  OtherKeys,  ParamNames: array of string
):Variant;
var     i,cPar:integer;
begin
   RegObj:=TRegistry.Create;
   with RegObj do
   try
    Result:=false;
    RootKey:=aRootKey;
    for i:=Low(OtherKeys) to High(OtherKeys) do
     if not OpenKey(OtherKeys[i],false) then  Exit;
    cPar:=High(ParamNames);
    Result:=VarArrayCreate([0, 1, 0, cPar], varVariant);
    for i:=0 to cPar do try
     Result[0,i]:=ReadString(ParamNames[i]);
     Result[1,i]:=Result[0,i]<>'';
    except
     Result[1,i]:=false //can't read as string
    end;
   finally
    CloseKey;
   end;
end;



function DefReadFromRegistry(const OtherKeys, ParamNames: array of string):Variant;
begin
 Result:=ReadFromRegistry(HKEY_CURRENT_USER,OtherKeys,ParamNames)
end;

function AllSubKey(aRootKey:HKEY; const ForPath: array of string):Variant;
var
    i:integer;
    SubKeys:TStrings;
begin
   SubKeys:=TStringList.Create;
   Result:=false;
   with RegObj do
   try
    Result:=false;
    RootKey:=aRootKey;
    for i:=Low(ForPath) to High(ForPath) do
     if not OpenKey(ForPath[i],false) then  Exit;
    GetKeyNames(SubKeys);
    if SubKeys.Count=0 then Exit;
    Result:=VarArrayCreate([0,Pred(SubKeys.Count)], varOleStr);
    for i:=0 to Pred(SubKeys.Count) do   Result[i]:=SubKeys[i];
   finally
    SubKeys.Free;
    CloseKey;
   end;
end;

function DefAllSubKey(const ForPath: array of string):Variant;
begin
 Result:=AllSubKey(HKEY_CURRENT_USER,ForPath)
end;



function SaveRegKey(const FileName: String;
  const ForKey: array of string): Boolean;
var   i:integer;
      s:string;
begin
 with RegObj do
 try
   RootKey:=HKEY_CURRENT_USER;
   s:='';
   if FileExists(FileName) then DeleteFile(FileName);
   for i:=Low(ForKey) to High(ForKey) do
    s:=s+'\'+ForKey[i];
   Result:=SaveKey(s,FileName);
 finally
    CloseKey;
 end;
end;

function LoadRegKey(const FileName: String; const ForKey: array of string): Boolean;
var   i:integer;
      s:string;
begin
 with RegObj do
 try
   RootKey:=HKEY_CURRENT_USER;
   s:='';
   for i:=Low(ForKey) to High(ForKey) do
    s:=s+'\'+ForKey[i];
   Result:=ReplaceKey(s,FileName,'');
 finally
    CloseKey;
 end;
end;

function AltSaveRegKey(const FileName: String;
 const ForKey: array of string): Boolean;
var v:Variant;
    i,c:integer;
    Ini:TIniFile;
    PathKey:string;
    pv:string;
begin
 v:=DefAllSubKey(ForKey);
 if VarType(v)=varBoolean then
  Result:=false
 else
 with RegObj do
 begin
   PathKey:='';
   for i:=Low(ForKey) to High(ForKey) do
    PathKey:=PathKey+'\'+ForKey[i];

   if FileExists(FileName) then DeleteFile(FileName);
   Ini:=TIniFile.Create(FileName);
  try
   c:=VarArrayHighBound(v, 1);
   for i :=0  to c do
   begin
    if OpenKey(PathKey+'\'+v[i],false) then begin
     Ini.WriteString(v[i], 'Name'  ,ReadString('Name') );
     pv:=ReplaceStr(ReadString('Params'),#13#10,'#');
     Ini.WriteString(v[i], 'Params', pv);
    end;
   end;
   Result:=true;
  finally
   Ini.Free
  end;
 end;
end;

function AltLoadRegKey(const FileName: String;
 const ForKey: array of string): Boolean;
var v:Variant;
    i,c:integer;
    Ini:TIniFile;
    PathKey:string;
    ts:TStrings;
begin
 v:=DefAllSubKey(ForKey);
 with RegObj do
 begin
   PathKey:='';
   for i:=Low(ForKey) to High(ForKey) do
    PathKey:=PathKey+'\'+ForKey[i];
   Ini:=TIniFile.Create(FileName);
   ts :=TStringList.Create;
  try
   if VarType(v)<>varBoolean then begin
    c:=VarArrayHighBound(v, 1);
    for i :=0  to c do
    if OpenKey(PathKey+'\'+v[i],false) then
     DeleteKey(PathKey+'\'+v[i]);
   end;
   Ini.ReadSections(ts);
   c:=ts.Count-1;
   for i :=0  to c do
    if OpenKey(PathKey+'\'+ts[i],true) then   
    begin
     WriteString('Name',Ini.ReadString(ts[i],'Name',''));
     WriteString('Params',
      ReplaceStr(Ini.ReadString(ts[i],'Params',''),'#',#13#10)
     );
    end;
   Result:=true;    
  finally
   ts.Free;
   Ini.Free;
   CloseKey
  end;
 end;
end;

function GetKeyForParValue(const aRootKey,ParName,ParValue:string):string;
var v:variant;
    i,c:integer;
    pv:string;
begin
 Result:='';
 v:=DefAllSubKey(aRootKey);
 if VarType(v)=varBoolean then Exit;
 c:=VarArrayHighBound(v, 1);
 with RegObj do try
 for i:=0 to c do
  if OpenKey(aRootKey+'\'+v[i],false) then begin
   pv:=ReadString(ParName);
   if pv=ParValue then begin
    Result:=v[i]; Exit;
   end;
   CloseKey
  end;
 finally
  CloseKey
 end;
end;

initialization
 RegObj:=TRegistry.Create;
finalization
 RegObj.Free
end.



