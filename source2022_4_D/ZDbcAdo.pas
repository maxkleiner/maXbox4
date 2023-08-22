{*********************************************************}
{                                                         }
{                 Zeos Database Objects                   }
{               ADO Connectivity Classes                  }
{                                                         }
{        Originally written by Janos Fegyverneki          }
{                                                         }
{*********************************************************}

{@********************************************************}
{    Copyright (c) 1999-2012 Zeos Development Group       }
{                                                         }
{ License Agreement:                                      }
{                                                         }
{ This library is distributed in the hope that it will be }
{ useful, but WITHOUT ANY WARRANTY; without even the      }
{ implied warranty of MERCHANTABILITY or FITNESS FOR      }
{ A PARTICULAR PURPOSE.  See the GNU Lesser General       }
{ Public License for more details.                        }
{                                                         }
{ The source code of the ZEOS Libraries and packages are  }
{ distributed under the Library GNU General Public        }
{ License (see the file COPYING / COPYING.ZEOS)           }
{ with the following  modification:                       }
{ As a special exception, the copyright holders of this   }
{ library give you permission to link this library with   }
{ independent modules to produce an executable,           }
{ regardless of the license terms of these independent    }
{ modules, and to copy and distribute the resulting       }
{ executable under terms of your choice, provided that    }
{ you also meet, for each linked independent module,      }
{ the terms and conditions of the license of that module. }
{ An independent module is a module which is not derived  }
{ from or based on this library. If you modify this       }
{ library, you may extend this exception to your version  }
{ of the library, but you are not obligated to do so.     }
{ If you do not wish to do so, delete this exception      }
{ statement from your version.                            }
{                                                         }
{                                                         }
{ The project web site is located on:                     }
{   http://zeos.firmos.at  (FORUM)                        }
{   http://sourceforge.net/p/zeoslib/tickets/ (BUGTRACKER)}
{   svn://svn.code.sf.net/p/zeoslib/code-0/trunk (SVN)    }
{                                                         }
{   http://www.sourceforge.net/projects/zeoslib.          }
{                                                         }
{                                                         }
{                                 Zeos Development Group. }
{********************************************************@}

unit ZDbcAdo;

interface

{$I ZDbc.inc}

uses
  Types, Classes, ZDbcConnection, ZDbcIntfs, ZCompatibility, ZPlainDriver,
  ZPlainAdoDriver, ZPlainAdo, ZURL, ZTokenizer;

type
  {** Implements Ado Database Driver. }
  {$WARNINGS OFF}
  TZAdoDriver = class(TZAbstractDriver)
  public
    constructor Create; override;
    function Connect(const Url: TZURL): IZConnection; override;
    function GetMajorVersion: Integer; override;
    function GetMinorVersion: Integer; override;
    function GetTokenizer: IZTokenizer; override;
  end;
  {$WARNINGS ON}

  {** Represents an Ado specific connection interface. }
  IZAdoConnection = interface (IZConnection)
    ['{50D1AF76-0174-41CD-B90B-4FB770EFB14F}']
    function GetAdoConnection: ZPlainAdo.Connection;
    procedure InternalExecuteStatement(const SQL: string);
    procedure CheckAdoError;
  end;

  {** Implements a generic Ado Connection. }
  TZAdoConnection = class(TZAbstractConnection, IZAdoConnection)
  private
    procedure ReStartTransactionSupport;
  protected
    FAdoConnection: ZPlainAdo.Connection;
    function GetAdoConnection: ZPlainAdo.Connection;
    procedure InternalExecuteStatement(const SQL: string);
    procedure CheckAdoError;
    procedure StartTransaction;
    procedure InternalCreate; override;
  public
    destructor Destroy; override;

    function GetBinaryEscapeString(const Value: TByteDynArray): String; overload; override;
    function GetBinaryEscapeString(const Value: RawByteString): String; overload; override;
    function CreateRegularStatement(Info: TStrings): IZStatement; override;
    function CreatePreparedStatement(const SQL: string; Info: TStrings):
      IZPreparedStatement; override;
    function CreateCallableStatement(const SQL: string; Info: TStrings):
      IZCallableStatement; override;

    function NativeSQL(const SQL: string): string; override;

    procedure SetAutoCommit(AutoCommit: Boolean); override;
    procedure SetTransactionIsolation(Level: TZTransactIsolationLevel); override;

    procedure Commit; override;
    procedure Rollback; override;

    procedure Open; override;
    procedure Close; override;

    procedure SetReadOnly(ReadOnly: Boolean); override;

    procedure SetCatalog(const Catalog: string); override;
    function GetCatalog: string; override;

    function GetWarnings: EZSQLWarning; override;
    procedure ClearWarnings; override;
  end;

var
  {** The common driver manager object. }
  AdoDriver: IZDriver;

implementation

uses
  Variants,
  SysUtils, ActiveX, ZDbcUtils, ZDbcLogging, ZAdoToken, ZSysUtils,
  ZDbcAdoStatement, ZDbcAdoMetaData;

const                                                //adXactUnspecified
  IL: array[TZTransactIsolationLevel] of TOleEnum = (adXactChaos, adXactReadUncommitted, adXactReadCommitted, adXactRepeatableRead, adXactSerializable);

{ TZDBLibDriver }

{**
  Constructs this object with default properties.
}
constructor TZAdoDriver.Create;
begin
  inherited Create;
  AddSupportedProtocol(AddPlainDriverToCache(TZAdoPlainDriver.Create));
end;

{**
  Attempts to make a database connection to the given URL.
}
{$WARNINGS OFF}
function TZAdoDriver.Connect(const Url: TZURL): IZConnection;
begin
  Result := TZAdoConnection.Create(Url);
end;
{$WARNINGS ON}

{**
  Gets the driver's major version number. Initially this should be 1.
  @return this driver's major version number
}
function TZAdoDriver.GetMajorVersion: Integer;
begin
  Result := 1;
end;

{**
  Gets the driver's minor version number. Initially this should be 0.
  @return this driver's minor version number
}
function TZAdoDriver.GetMinorVersion: Integer;
begin
  Result := 0;
end;

function TZAdoDriver.GetTokenizer: IZTokenizer;
begin
  if Tokenizer = nil then
    Tokenizer := TZAdoSQLTokenizer.Create;
  Result := Tokenizer;
end;

{ TZAdoConnection }

procedure TZAdoConnection.InternalCreate;
begin
  FAdoConnection := CoConnection.Create;
  Self.FMetadata := TZAdoDatabaseMetadata.Create(Self, URL);
  Open;
end;

{**
  Destroys this object and cleanups the memory.
}
destructor TZAdoConnection.Destroy;
begin
  Close;
  FAdoConnection := nil;
  inherited Destroy;
end;

{**
  Just return the Ado Connection
}
function TZAdoConnection.GetAdoConnection: ZPlainAdo.Connection;
begin
  Result := FAdoConnection;
end;

{**
  Executes simple statements internally.
}
procedure TZAdoConnection.InternalExecuteStatement(const SQL: string);
var
  RowsAffected: OleVariant;
begin
  try
    FAdoConnection.Execute(SQL, RowsAffected, adExecuteNoRecords);
    DriverManager.LogMessage(lcExecute, PlainDriver.GetProtocol, SQL);
  except
    on E: Exception do
    begin
      DriverManager.LogError(lcExecute, PlainDriver.GetProtocol, SQL, 0, E.Message);
      raise;
    end;
  end;
end;

procedure TZAdoConnection.CheckAdoError;
begin
end;

{**
  Starts a transaction support.
}
procedure TZAdoConnection.ReStartTransactionSupport;
begin
  if Closed then Exit;

  if not (AutoCommit or (GetTransactionIsolation = tiNone)) then
    StartTransaction;
end;

{**
  Opens a connection to database server with specified parameters.
}
procedure TZAdoConnection.Open;
var
  LogMessage: string;
begin
  if not Closed then Exit;

  LogMessage := Format('CONNECT TO "%s" AS USER "%s"', [Database, User]);
  try
    if ReadOnly then
      FAdoConnection.Set_Mode(adModeRead)
    else
      FAdoConnection.Set_Mode(adModeUnknown);
    FAdoConnection.Open(Database, User, Password, -1{adConnectUnspecified});
    FAdoConnection.Set_CursorLocation(adUseClient);
    DriverManager.LogMessage(lcConnect, PLainDriver.GetProtocol, LogMessage);
    if FClientCodePage <> 'CP_ADO' then CheckCharEncoding('CP_ADO', True)
  except
    on E: Exception do
    begin
      DriverManager.LogError(lcConnect, PlainDriver.GetProtocol, LogMessage, 0, E.Message);
      raise;
    end;
  end;

  inherited Open;

  FAdoConnection.IsolationLevel := IL[GetTransactionIsolation];
  ReStartTransactionSupport;
end;

function TZAdoConnection.GetBinaryEscapeString(const Value: TByteDynArray): String;
begin
  Result := GetSQLHexString(PAnsiChar(Value), Length(Value), True);
  if GetAutoEncodeStrings then
    Result := GetDriver.GetTokenizer.GetEscapeString(Result)
end;

function TZAdoConnection.GetBinaryEscapeString(const Value: RawByteString): String;
begin
  Result := GetSQLHexString(PAnsiChar(Value), Length(Value), True);
  if GetAutoEncodeStrings then
    Result := GetDriver.GetTokenizer.GetEscapeString(Result)
end;

{**
  Creates a <code>Statement</code> object for sending
  SQL statements to the database.
  SQL statements without parameters are normally
  executed using Statement objects. If the same SQL statement
  is executed many times, it is more efficient to use a
  <code>PreparedStatement</code> object.
  <P>
  Result sets created using the returned <code>Statement</code>
  object will by default have forward-only type and read-only concurrency.

  @param Info a statement parameters.
  @return a new Statement object
}
function TZAdoConnection.CreateRegularStatement(Info: TStrings): IZStatement;
begin
  if IsClosed then Open;
  Result := TZAdoStatement.Create(PlainDriver, Self, '', Info);
end;

{**
  Creates a <code>PreparedStatement</code> object for sending
  parameterized SQL statements to the database.

  A SQL statement with or without IN parameters can be
  pre-compiled and stored in a PreparedStatement object. This
  object can then be used to efficiently execute this statement
  multiple times.

  <P><B>Note:</B> This method is optimized for handling
  parametric SQL statements that benefit from precompilation. If
  the driver supports precompilation,
  the method <code>prepareStatement</code> will send
  the statement to the database for precompilation. Some drivers
  may not support precompilation. In this case, the statement may
  not be sent to the database until the <code>PreparedStatement</code> is
  executed.  This has no direct effect on users; however, it does
  affect which method throws certain SQLExceptions.

  Result sets created using the returned PreparedStatement will have
  forward-only type and read-only concurrency, by default.

  @param sql a SQL statement that may contain one or more '?' IN
    parameter placeholders
  @param Info a statement parameters.
  @return a new PreparedStatement object containing the
    pre-compiled statement
}
function TZAdoConnection.CreatePreparedStatement(
  const SQL: string; Info: TStrings): IZPreparedStatement;
begin
  if IsClosed then Open;
  Result := TZAdoPreparedStatement.Create(PlainDriver, Self, SQL, Info);
end;

{**
  Creates a <code>CallableStatement</code> object for calling
  database stored procedures.
  The <code>CallableStatement</code> object provides
  methods for setting up its IN and OUT parameters, and
  methods for executing the call to a stored procedure.

  <P><B>Note:</B> This method is optimized for handling stored
  procedure call statements. Some drivers may send the call
  statement to the database when the method <code>prepareCall</code>
  is done; others
  may wait until the <code>CallableStatement</code> object
  is executed. This has no
  direct effect on users; however, it does affect which method
  throws certain SQLExceptions.

  Result sets created using the returned CallableStatement will have
  forward-only type and read-only concurrency, by default.

  @param sql a SQL statement that may contain one or more '?'
    parameter placeholders. Typically this  statement is a JDBC
    function call escape string.
  @param Info a statement parameters.
  @return a new CallableStatement object containing the
    pre-compiled SQL statement
}
function TZAdoConnection.CreateCallableStatement(const SQL: string; Info: TStrings):
  IZCallableStatement;
begin
  if IsClosed then Open;
  Result := TZAdoCallableStatement.Create(PlainDriver, Self, SQL, Info);
end;

{**
  Converts the given SQL statement into the system's native SQL grammar.
  A driver may convert the JDBC sql grammar into its system's
  native SQL grammar prior to sending it; this method returns the
  native form of the statement that the driver would have sent.

  @param sql a SQL statement that may contain one or more '?'
    parameter placeholders
  @return the native form of this statement
}
function TZAdoConnection.NativeSQL(const SQL: string): string;
begin
  Result := SQL;
end;

{**
  Sets this connection's auto-commit mode.
  If a connection is in auto-commit mode, then all its SQL
  statements will be executed and committed as individual
  transactions.  Otherwise, its SQL statements are grouped into
  transactions that are terminated by a call to either
  the method <code>commit</code> or the method <code>rollback</code>.
  By default, new connections are in auto-commit mode.

  The commit occurs when the statement completes or the next
  execute occurs, whichever comes first. In the case of
  statements returning a ResultSet, the statement completes when
  the last row of the ResultSet has been retrieved or the
  ResultSet has been closed. In advanced cases, a single
  statement may return multiple results as well as output
  parameter values. In these cases the commit occurs when all results and
  output parameter values have been retrieved.

  @param autoCommit true enables auto-commit; false disables auto-commit.
}
procedure TZAdoConnection.SetAutoCommit(AutoCommit: Boolean);
begin
  if GetAutoCommit = AutoCommit then  Exit;
  if not Closed and AutoCommit then
  begin
    if (FAdoConnection.State = adStateOpen) and
       (GetTransactionIsolation <> tiNone) then
      begin
        FAdoConnection.CommitTrans;
        DriverManager.LogMessage(lcExecute, PlainDriver.GetProtocol, 'COMMIT');
      end;
  end;
  inherited;
  ReStartTransactionSupport;
end;

{**
  Attempts to change the transaction isolation level to the one given.
  The constants defined in the interface <code>Connection</code>
  are the possible transaction isolation levels.

  <P><B>Note:</B> This method cannot be called while
  in the middle of a transaction.

  @param level one of the TRANSACTION_* isolation values with the
    exception of TRANSACTION_NONE; some databases may not support other values
  @see DatabaseMetaData#supportsTransactionIsolationLevel
}
procedure TZAdoConnection.SetTransactionIsolation(
  Level: TZTransactIsolationLevel);
begin
  if GetTransactionIsolation = Level then Exit;

  if not Closed and not AutoCommit and (GetTransactionIsolation <> tiNone) then
  begin
    FAdoConnection.CommitTrans;
    DriverManager.LogMessage(lcExecute, PlainDriver.GetProtocol, 'COMMIT');
  end;

  inherited;

  if not Closed then
    FAdoConnection.IsolationLevel := IL[Level];

  RestartTransactionSupport;
end;

{**
  Starts a new transaction. Used internally.
}
procedure TZAdoConnection.StartTransaction;
var
  LogMessage: string;
begin
  LogMessage := 'BEGIN TRANSACTION';
  try
    FAdoConnection.BeginTrans;
    DriverManager.LogMessage(lcExecute, PlainDriver.GetProtocol, LogMessage);
  except
    on E: Exception do
    begin
      DriverManager.LogError(lcExecute, PlainDriver.GetProtocol, LogMessage, 0, E.Message);
      raise;
    end;
  end;
end;

{**
  Makes all changes made since the previous
  commit/rollback permanent and releases any database locks
  currently held by the Connection. This method should be
  used only when auto-commit mode has been disabled.
  @see #setAutoCommit
}
procedure TZAdoConnection.Commit;
var
  LogMessage: string;
begin
  LogMessage := 'COMMIT';
  if not (AutoCommit or (GetTransactionIsolation = tiNone)) then
  try
    FAdoConnection.CommitTrans;
    DriverManager.LogMessage(lcExecute, PlainDriver.GetProtocol, LogMessage);
    StartTransaction;
  except
    on E: Exception do
    begin
      DriverManager.LogError(lcExecute, PlainDriver.GetProtocol, LogMessage, 0, E.Message);
      raise;
    end;
  end;
end;

{**
  Drops all changes made since the previous
  commit/rollback and releases any database locks currently held
  by this Connection. This method should be used only when auto-
  commit has been disabled.
  @see #setAutoCommit
}
procedure TZAdoConnection.Rollback;
var
  LogMessage: string;
begin
  LogMessage := 'ROLLBACK';
  if not (AutoCommit or (GetTransactionIsolation = tiNone)) then
  try
    FAdoConnection.RollbackTrans;
    DriverManager.LogMessage(lcExecute, PlainDriver.GetProtocol, LogMessage);
    StartTransaction;
  except
    on E: Exception do
    begin
      DriverManager.LogError(lcExecute, PlainDriver.GetProtocol, LogMessage, 0, E.Message);
      raise;
    end;
  end;
end;

{**
  Releases a Connection's database and JDBC resources
  immediately instead of waiting for
  them to be automatically released.

  <P><B>Note:</B> A Connection is automatically closed when it is
  garbage collected. Certain fatal errors also result in a closed
  Connection.
}
procedure TZAdoConnection.Close;
var
  LogMessage: string;
begin
  if Closed or (not Assigned(PlainDriver)) then
    Exit;

  SetAutoCommit(True);

  LogMessage := Format('CLOSE CONNECTION TO "%s"', [Database]);
  try
    if FAdoConnection.State = adStateOpen then
      FAdoConnection.Close;
    DriverManager.LogMessage(lcExecute, PlainDriver.GetProtocol, LogMessage);
  except
    on E: Exception do
    begin
      DriverManager.LogError(lcExecute, PlainDriver.GetProtocol, LogMessage, 0, E.Message);
      raise;
    end;
  end;

  inherited;
end;

{**
  Puts this connection in read-only mode as a hint to enable
  database optimizations.

  <P><B>Note:</B> This method cannot be called while in the
  middle of a transaction.

  @param readOnly true enables read-only mode; false disables
    read-only mode.
}
procedure TZAdoConnection.SetReadOnly(ReadOnly: Boolean);
begin
  inherited;
end;

{**
  Sets a catalog name in order to select
  a subspace of this Connection's database in which to work.
  If the driver does not support catalogs, it will
  silently ignore this request.
}
procedure TZAdoConnection.SetCatalog(const Catalog: string);
var
  LogMessage: string;
begin
  if Closed then Exit;

  LogMessage := Format('SET CATALOG %s', [Catalog]);
  try
    FAdoConnection.DefaultDatabase := Catalog;
    DriverManager.LogMessage(lcExecute, PlainDriver.GetProtocol, LogMessage);
  except
    on E: Exception do
    begin
      DriverManager.LogError(lcExecute, PlainDriver.GetProtocol, LogMessage, 0, E.Message);
      raise;
    end;
  end;
end;

{**
  Returns the Connection's current catalog name.
  @return the current catalog name or null
}
function TZAdoConnection.GetCatalog: string;
begin
  Result := FAdoConnection.DefaultDatabase;
end;

{**
  Returns the first warning reported by calls on this Connection.
  <P><B>Note:</B> Subsequent warnings will be chained to this
  SQLWarning.
  @return the first SQLWarning or null
}
function TZAdoConnection.GetWarnings: EZSQLWarning;
begin
  Result := nil;
end;

{**
  Clears all warnings reported for this <code>Connection</code> object.
  After a call to this method, the method <code>getWarnings</code>
    returns null until a new warning is reported for this Connection.
}
procedure TZAdoConnection.ClearWarnings;
begin
end;

initialization
  AdoDriver := TZAdoDriver.Create;
  DriverManager.RegisterDriver(AdoDriver);
finalization
  if Assigned(DriverManager) then
    DriverManager.DeregisterDriver(AdoDriver);
  AdoDriver := nil;
end.
