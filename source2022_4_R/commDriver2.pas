// Copyright 2008 Martin Herold und Toolbox Verlag


unit commDriver2;

interface

USES
  Classes,
  Contnrs,
  SyncObjs,
  Sysutils;

TYPE
  TCommDriver          = CLASS;
  TMetaData            = CLASS;
  TParameter2           = CLASS;
  TParameterType       = CLASS;
  TCommDriverClass     = CLASS OF TCommDriver;

  IDriverManager = INTERFACE
    ['{31EA77C6-546E-4ADE-900E-1F60367D2066}']
    FUNCTION InstallDriver( aClass : TCommDriverClass) : INTEGER;
    FUNCTION RemoveDriver( aClass : TCommDriverClass) : INTEGER;
  END;


  TParameterType = CLASS( tObject)
  private
    FUNCTION GetTypeName : STRING; VIRTUAL; ABSTRACT;
  public
    FUNCTION CheckData( aValue : VARIANT) : VARIANT; VIRTUAL; ABSTRACT;
    FUNCTION ValueToString( Value : VARIANT) : STRING; VIRTUAL; ABSTRACT;
    FUNCTION StringToValue( Value : STRING) : VARIANT; VIRTUAL; ABSTRACT;
    FUNCTION GetMetaString : STRING; VIRTUAL; ABSTRACT;
    PROPERTY TypeName : STRING read GetTypeName;
  END;

  TOrdinalType = CLASS( tParameterType)
  private
    FUNCTION GetTypeName : STRING; OVERRIDE;
  public
    FUNCTION Checkdata( aValue : VARIANT) : VARIANT; OVERRIDE;
    FUNCTION ValueToString( Value : VARIANT) : STRING; OVERRIDE;
    FUNCTION GetMetaString : STRING; OVERRIDE;
    FUNCTION StringToValue( Value : STRING) : VARIANT; OVERRIDE;
  END;

  TEnumerationType = CLASS( tParameterType)
  private
    FEnums : tStringList;
    FUNCTION GetTypeName : STRING; OVERRIDE;
  public
    CONSTRUCTOR Create;
    DESTRUCTOR  Destroy; OVERRIDE;
    FUNCTION    Checkdata( aValue : VARIANT) : VARIANT; OVERRIDE;
    FUNCTION    ValueToString( Value : VARIANT) : STRING; OVERRIDE;
    FUNCTION    StringToValue( Value : STRING) : VARIANT; OVERRIDE;
    FUNCTION    GetMetaString : STRING; OVERRIDE;
    PROPERTY    Enums : TStringList read FEnums;
  END;

  TStringType2 = CLASS( TParameterType)
  private
    FUNCTION GetTypeName : STRING; OVERRIDE;
  public
    FUNCTION Checkdata( aValue : VARIANT) : VARIANT; OVERRIDE;
    FUNCTION ValueToString( Value : VARIANT) : STRING; OVERRIDE;
    FUNCTION StringToValue( Value : STRING) : VARIANT; OVERRIDE;
    FUNCTION GetMetaString : STRING; OVERRIDE;
  END;

  TFloatType2  = CLASS( TParameterType)
  private
    FUNCTION GetTypeName : STRING; OVERRIDE;
  public
    FUNCTION Checkdata( aValue : VARIANT) : VARIANT; OVERRIDE;
    FUNCTION ValueToString( Value : VARIANT) : STRING; OVERRIDE;
    FUNCTION StringToValue( Value : STRING) : VARIANT; OVERRIDE;
    FUNCTION GetMetaString : STRING; OVERRIDE;
  END;


  TParameter2  = CLASS( tObject)
  private
    FName    : STRING;
    FPubName : STRING;
    FTyp     : TParameterType;
    FData    : VARIANT;
  protected
    FUNCTION    GetData : VARIANT;
    PROCEDURE   SetData( Value : Variant);
    FUNCTION    GetDataName : STRING;
    PROCEDURE   SetDataName( Value : STRING);
  public
    CONSTRUCTOR Create( aName : STRING; aType : TParameterType; aPubName : STRING = '');
    CONSTRUCTOR CreateValue( aName : STRING; aType : TParameterType; aValue : VARIANT; aPubName : STRING = '');
    FUNCTION    GetMetaString : STRING;
    PROPERTY    ParamType : TParameterType read FTyp;
    PROPERTY    PublicName : STRING read FPubName write FPubName;
    PROPERTY    Name : STRING read FName;
    PROPERTY    Data : VARIANT read GetData write SetData;
    PROPERTY    DataName : STRING read GetDataName write SetDataName;
  END;


  TMetaData   = CLASS( tObjectList)
  private
    FDriverClass : TCommDriverClass;
    FUNCTION    GetItems( i : INTEGER) : TParameter2;
  public
    CONSTRUCTOR Create( aClass : TCommDriverClass);
    FUNCTION    ParamByName( aName : STRING) : TParameter2;
    FUNCTION    GetValue( aName : STRING) : VARIANT;
    PROCEDURE   SetValue( aName : STRING; Value : VARIANT);
    PROCEDURE   GetMetaData( r : TStrings);
    PROPERTY    Items[ i : INTEGER] : TParameter2 read GetItems;
  END;

  TModule2     = CLASS( tObject)
  private
    FOwner    : TObjectList;
    FHandle   : THandle;
    FFilename : STRING;
    FFilePath : STRING;
    FVersion  : TStringList;
  public
    CONSTRUCTOR Create( aOwner : tObjectList);
    DESTRUCTOR  Destroy; OVERRIDE;
    PROPERTY    Owner : TObjectList read FOwner write Fowner;
    PROPERTY    Handle : THandle read FHandle write FHandle;
    PROPERTY    Filename : STRING read FFilename write FFilename;
    PROPERTY    FilePath : STRING read FFilepath write FFilepath;
    PROPERTY    Version : TStringlist read FVersion;
  END;

  TModuleList2 = CLASS( tObjectList)
  private
    FUNCTION GetItems( i : INTEGER) : TModule2;
    PROCEDURE SetItems( i : INTEGER; Value : TModule2);
  public
    PROPERTY Items[ i : INTEGER] : TModule2 read GetItems write SetItems;
  END;


  TWaiter = CLASS( TEvent)
  private
    FCurrent : INTEGER;
  public
    CONSTRUCTOR Create( aName : STRING);
    PROCEDURE   Using;
    PROCEDURE   Unusing;
  END;


  TCommDriver = CLASS( TThread)
  private
    FModule   : TModule2;
    FError    : BOOLEAN;
    FErrorMsg : STRING;
    FMetaData : TMetaData;
    FName     : STRING;
    FValue    : DOUBLE;
    FWaiter   : TWaiter;
    FRun      : BOOLEAN;
  protected
    FUNCTION  IsTerminated : BOOLEAN; VIRTUAL;
    PROCEDURE DoExecute; VIRTUAL;
    PROCEDURE DoInit; VIRTUAL;
    PROCEDURE DoExit; VIRTUAL;
    PROCEDURE HandleException( X : Exception); VIRTUAL;
    FUNCTION  GetValue : DOUBLE; VIRTUAL;
    PROCEDURE SetValue( aValue : DOUBLE); VIRTUAL;
    PROPERTY  MetaData : TMetaData read FMetaData;
  public
    CONSTRUCTOR Create( aName : STRING); VIRTUAL;
    DESTRUCTOR  Destroy; OVERRIDE;
    CLASS FUNCTION GetMetaData : TMetaData; VIRTUAL; ABSTRACT;
    CLASS FUNCTION PublicClassName : STRING; VIRTUAL; ABSTRACT;
    PROCEDURE SetData( aData : TStrings); VIRTUAL; ABSTRACT;
    PROCEDURE Execute; OVERRIDE;
    PROCEDURE Use; VIRTUAL;
    PROCEDURE UnUse; VIRTUAL;
    PROCEDURE CollectValues( s : tStringList); VIRTUAL;
    PROPERTY  Module : TModule2 read FModule write FModule;
    PROPERTY  Name : STRING read FName;
    PROPERTY  Error : BOOLEAN read FError;
    PROPERTY  ErrorMsg : STRING read FErrorMsg;
    PROPERTY  Value : DOUBLE read GetValue write SetValue;
    PROPERTY  Waiter : TWaiter read FWaiter;
  END;

implementation

USES
  LocaleConst,
  Variants;


CONSTRUCTOR TWaiter.Create( aName : STRING);
BEGIN
  INHERITED Create( NIL, TRUE, FALSE, aName);
  FCurrent:=0;
END;

PROCEDURE   TWaiter.Using;
BEGIN
  WITH TCriticalSection.Create DO BEGIN
    Enter;
    Inc( FCurrent);
    Leave;
    Free;
  END;
  IF FCurrent>0 THEN SetEvent;
END;

PROCEDURE   TWaiter.Unusing;
BEGIN
  WITH TCriticalSection.Create DO BEGIN
    Enter;
    IF (FCurrent>0) THEN Dec( FCurrent);
    Leave;
    Free;
  END;
  IF FCurrent=0 THEN ResetEvent;
END;




CONSTRUCTOR TModule2.Create( aOwner : tObjectList);
BEGIN
  INHERITED Create;
  FVersion:=TStringList.Create;
END;

DESTRUCTOR  TModule2.Destroy;
BEGIN
  FVersion.Free;
  INHERITED Destroy;
END;


FUNCTION  TModuleList2.GetItems( i : INTEGER) : TModule2;
BEGIN
  Result:=TModule2( INHERITED Items[ i]);
END;


PROCEDURE TModuleList2.SetItems( i : INTEGER; Value : TModule2);
BEGIN
  INHERITED Items[i]:=Value;
END;



CONSTRUCTOR TCommDriver.Create( aName : STRING);
BEGIN
  INHERITED Create( TRUE);
  FName:=aName;
  FWaiter:=TWaiter.Create( aName+'/waiter');
  FMetaData:=GetMetaData;
  FreeOnTerminate:=FALSE;
END;

DESTRUCTOR  TCommDriver.Destroy;
BEGIN
  FWaiter.Free;
  FMetaData.Free;
  INHERITED Destroy;
END;

PROCEDURE TCommDriver.Use;
BEGIN
  FWaiter.Using;
END;

PROCEDURE TCommDriver.UnUse;
BEGIN
  FWaiter.Unusing;
END;



PROCEDURE TCommDriver.HandleException( X : Exception);
BEGIN
  Terminate;
  FError:=TRUE;
  FerrorMsg:=X.Message;
END;


FUNCTION  TCommDriver.IsTerminated : BOOLEAN;
BEGIN
  Result:=FALSE;
END;

PROCEDURE TCommDriver.DoExecute;
BEGIN
END;

PROCEDURE TCommDriver.DoInit;
BEGIN
  FRun:=TRUE;
END;

PROCEDURE TCommDriver.DoExit;
BEGIN
  FRun:=FALSE;
END;

PROCEDURE TCommDriver.Execute;
BEGIN
  DoInit;
  WHILE NOT Terminated DO BEGIN
    CASE FWaiter.WaitFor(100) OF
      wrSignaled : BEGIN
                     DoExecute;
                   END;
      wrAbandoned,
      wrError    : Terminate;
    END;
    Sleep( 20);
  END;
  DoExit;
END;

FUNCTION  TCommDriver.GetValue : DOUBLE;
BEGIN
  Result:=FValue;
END;

PROCEDURE TCommDriver.SetValue( aValue : DOUBLE);
BEGIN
  FValue:=aValue;
END;

PROCEDURE TCommDriver.CollectValues( s : tStringList);
BEGIN
  s.Add( FName+'/value='+FloatToStr( Value));
  s.Add( FName+'/time='+FormatDateTime( 'dddddd', Now)+' '+GetTimeZone);
END;






CONSTRUCTOR TMetaData.Create( aClass : TCommDriverClass);
BEGIN
  INHERITED Create;
  FDriverClass:=aClass;
END;

FUNCTION    TMetaData.GetItems( i : INTEGER) : TParameter2;
BEGIN
  Result:=TParameter2( INHERITED Items[i]);
END;

FUNCTION    TMetaData.ParamByName( aName : STRING) : TParameter2;
VAR
  i : INTEGER;
BEGIN
  Result:=NIL;
  FOR i:=1 TO Count DO BEGIN
    IF SameText( aName, Items[i-1].Name) THEN BEGIN
      Result:=Items[i-1];
      Break;
    END;
  END;
END;

FUNCTION    TMetaData.GetValue( aName : STRING) : VARIANT;
BEGIN
  Result:=ParamByname( aName).Data;
END;


PROCEDURE   TMetaData.SetValue( aName : STRING; Value : VARIANT);
BEGIN
  ParamByName( aName).Data:=Value;
END;

PROCEDURE   TMetaData.GetMetaData( r : TStrings);
VAR
  i : INTEGER;
BEGIN
  FOR i:=1 TO Count DO BEGIN
    r.Add( Items[i-1].GetMetaString);
  END;
END;



CONSTRUCTOR TParameter2.Create( aName : STRING; aType : TParameterType; aPubName : STRING = '');
BEGIN
  INHERITED Create;
  FName:=aName;
  FTyp:=aType;
  FPubName:=aPubName;
  IF FPubName='' THEN FPubName:=FName;
  FData:=NULL;
END;

CONSTRUCTOR TParameter2.CreateValue( aName : STRING; aType : TParameterType; aValue : VARIANT; aPubName : STRING = '');
BEGIN
  Create( aName, aType, aPubName);
  FData:=aValue;
END;

FUNCTION    TParameter2.GetData : VARIANT;
BEGIN
  Result:=FData;
END;

PROCEDURE   TParameter2.SetData( Value : Variant);
BEGIN
  FData:=FTyp.CheckData( Value);
END;

FUNCTION    TParameter2.GetDataName : STRING;
BEGIN
  Result:=FTyp.ValueToString( FData);
END;

PROCEDURE   TParameter2.SetDataName( Value : STRING);
BEGIN
  FData:=FTyp.StringToValue( Value);
END;

FUNCTION    TParameter2.GetMetaString : STRING;
BEGIN
  Result:=FName+'='+FTyp.GetMetaString+' "desc:'+FPubname+'"';
END;



FUNCTION TOrdinalType.GetTypeName : STRING;
BEGIN
  Result:='Ordinal';
END;

FUNCTION TOrdinalType.GetMetaString : STRING;
BEGIN
  Result:='type:ord';
END;



FUNCTION TOrdinalType.Checkdata( aValue : VARIANT) : VARIANT;
BEGIN
  TRY
    Result:=INTEGER( aValue);
  EXCEPT
    Result:=0;
  END;
END;

FUNCTION TOrdinalType.ValueToString( Value : VARIANT) : STRING;
BEGIN
  Result:=IntToStr( Value);
END;

FUNCTION TOrdinalType.StringToValue( Value : STRING) : VARIANT;
BEGIN
  Result:=StrToInt( Value);
END;


CONSTRUCTOR TEnumerationType.Create;
BEGIN
  INHERITED Create;
  FEnums:=tStringList.Create;
END;

DESTRUCTOR  TEnumerationType.Destroy;
BEGIN
  FEnums.Free;
  INHERITED Destroy;
END;

FUNCTION TEnumerationType.GetTypeName : STRING;
BEGIN
  Result:='Enumeration';
END;

FUNCTION TEnumerationType.GetMetaString : STRING;
BEGIN
  Result:='type:enum enums:';
  Result:=Result+Enums.CommaText;
  Result:=Result+'';
END;

FUNCTION    TEnumerationType.Checkdata( aValue : VARIANT) : VARIANT;
VAR
  Ix : INTEGER;
BEGIN
  Ix:=INHERITED CheckData( aValue);
  IF (Ix<0) OR (Ix>=FEnums.Count) THEN RAISE Exception.Create( 'Index ist nicht innerhalb der erlaubten Grenzen');
END;

FUNCTION    TEnumerationType.ValueToString( Value : VARIANT) : STRING;
BEGIN
  Result:=FEnums[ Value];
END;

FUNCTION    TEnumerationType.StringToValue( Value : STRING) : VARIANT;
BEGIN
  Result:=FEnums.IndexOf( Value);
END;


FUNCTION TStringType2.GetTypeName : STRING;
BEGIN
  Result:='String';
END;


FUNCTION TStringType2.Checkdata( aValue : VARIANT) : VARIANT;
BEGIN
  IF VarIsType( aValue, varString) THEN Result:=aValue
  ELSE Result:=VarToStr( aValue);
END;

FUNCTION TStringType2.ValueToString( Value : VARIANT) : STRING;
BEGIN
  IF VarIsType( Value, varString) THEN Result:=Value
  ELSE Result:=VarToStr( Value);
END;

FUNCTION TStringType2.StringToValue( Value : STRING) : VARIANT;
BEGIN
  Result:=Value;
END;

FUNCTION TStringType2.GetMetaString : STRING;
BEGIN
  Result:='type:str';
END;


FUNCTION TFloatType2.GetTypeName : STRING;
BEGIN
  Result:='Float';
END;

FUNCTION TFloatType2.Checkdata( aValue : VARIANT) : VARIANT;
BEGIN
  IF VarIsType( aValue, varDouble) THEN Result:=aValue
  ELSE Result:=VarAsType( aValue, varDouble);
END;


FUNCTION TFloatType2.ValueToString( Value : VARIANT) : STRING;
BEGIN
  Result:=VarToStr( Value);
END;

FUNCTION TFloatType2.StringToValue( Value : STRING) : VARIANT;
BEGIN
  Result:=StrToFloat( Value);
END;

FUNCTION TFloatType2.GetMetaString : STRING;
BEGIN
  Result:='type:flt';
END;



end.
