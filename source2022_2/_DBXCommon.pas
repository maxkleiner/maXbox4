{ *********************************************************************** }
{                                                                         }
{ Delphi DBX Framework                                                    }
{                                                                         }
{ Copyright (c) 1997-2006 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

/// <summary> DBX database driver framework </summary>
/// <remarks>
///  Design Goals.
///  <para>
///
///  Open.  Support for all popular database vendors.
///  <para>
///
///  Lightweight.  Emphasis on the most commonly needed database driver functionality
///  for a "set" oriented database application.
///  <para>
///
///  Versatile.  The DBX framework must be leveraged in a broad variety of
///  application contexts.  Managed, native, 32 bit and 64 bit platforms are
///  supported.  The dbExpress VCL has been greatly simplified by refactoring
///  to use the new DBX framework.  The DBX framework is easy to bridge to and
///  from ADO.NET.  Cross language support for both managed and native platforms,
///  for languages such as Object Pascal, C++, C# and Visual Basic.  Since the
///  framework is authored in Object Pascal, it is also now possible to create
///  100% Object Pascal drivers as well.
///  <para>
///
///  Performant.  Critical design goal is to ensure there are no significant
///  performance issues introduced by the framework.  The significant performance
///  issues should occur in the application, driver network protocol or the
///  database server itself.
///  <para>
///
///  Simple.  Nothing should be any more complicated than it needs to be.
///  In the initial development, this framework has been refactored many
///  times at various levels to simplify usage and overall organization.
///  <para>
///
///  Strongly typed.  A strongly typed framework is more reliable and in many
///  cases it is as performant or even more performant than a framework that
///  makes heavy use of pointers.  For example, on the .net platform, the pinvoke
///  layer can optimize marshaling of an integer parameter much better
///  than a pointer to an integer.  There are situations where processing data
///  as an array of bytes is more performant.  TDataSet's use of record buffers
///  is a good example of this.  For bulk read operations the DBX framework will
///  support a byte reader using byte arrays instead of pointers.  Array of byte
///  is safer and more portable  data structure than a pointer.
///  <para>
///
///  Inteface versioning.  Abstract base classes are used instead of Interfaces
///  for DBX to facilitate less brittle versioning of DBX.  Objects or value
///  types (packed records) are used for parameters of methods, events, and
///  constructors that could potentially need additional parameters in the future.
///  A dbx properties object is used for connection creation and
///  metadata constraint specification to make these interfaces less brittle and
///  more extensible.
///  <para>
///
///  Interface delegation.  All public methods of DBX classes are
///  virtual.  Public Property getter and setters are virtual methods and
///  not fields.  These two practices facilitate support of DBX delegation
///  drivers which are useful for driver profiling, tracing and auditing.
///  Another interesting application of driver delegation would be to create a
///  "thread safe" driver delegate. Such a delegate could provide thread
///  synchronized access to all public methods.
///  <para>
///
///  Thread safe.  Absolute thread safety is left to applications using DBX.
///  However, some thread safety issues are best handled by the DBX framework.
///  DBX thread safe operations include:
///    Loading and unloading of drivers.
///    Creation of connections
///  As mentioned above, a delegate Driver can be created to make the entire
///  public interface of DBX thread safe if needed.
///  <para>
///
///  Warning free.  No compiler warnings.
///  <para>
///
///  Driver loading.
///  <para>
///
///  If your application uses the DbExpress VCL, most everything should work the
///  way it always has.  Currently there is one exception.  The interface for native
///  drivers not written in pascal has changed.  The new interface is the
///  DynalinkExports.  DBX 3 used a weakly typed com based interface.  DBX4 is more
///  strongly typed (No pointers in the DBXCommon unit).  DBXDynalink uses a "flat export"
///  approach.  The use of flat exports will make it easier to version the interface going forward.
///  So for now there is a dbxadapter30.dll that adapts any dbx3 driver to look like
///  a dbx4 driver.  Eventuallly the dbxadapter30.dll will not be needed for native
///  deployments.  Managed deployments are a bit more trouble.  We use pinvoke
///  to call into native drivers on the .net platform.  Currently we use static
///  pinvoke to the dbxadapter30.dll.  Dotnet 2 has better support for dynamic
///  pinvoke.  Eventually we will switch to this.  At that point dbxadapter30.dll
///  will only be needed to connect to older dbx3 drivers.
///  <para>
///
///  The DBX4 driver can also statically or dynamically link drivers built as 100%
///  delphi packages.  The easiest way to link a driver package is to just include
///  it in a "uses" clause.  The driver loader will also load packages specified
///  in a config or ini file using the "LoadPackage" method.  This allows dynamic
///  loading of drivers that are never specified in a uses clause of any units
///  used by an applicaiton.  Note that the LoadPackage approach will only
///  be employed for applications that are built to use packages.
///  <para>
///
///  The DBXCommon unit contains base classes used by all DBX4 drivers.  Functionality
///  common to all drivers is implemented in DBXCommon.  Driver specific
///  functionality is implemented in classes that extend the DBXCommon classes and
///  implement the abstract virtual methods of the DBXCommon classes.
///  <para>
///
///  The DBXDynalink unit contains a DBX4 driver.
///  This driver delegates to non-pascal drivers that implement the DBXDynalinkExport
///  flat export interface discussed above.  DBXTrace is a delegate driver used for tracing.
///  The DbExpress VCL uses DBXCommon, DBXDynalink and DbxTrace as "default" drivers.
///  However this can be changed for statically linked applications
///  without modifying dbExpress vcl source code (SQLExpr.pas).  SQLExpr.pas uses
///  the unit DBXDefaultDrivers.  The DBXDefaultDrivers unit only contains a uses clause.
///  The DBXDefaultDrivers uses clause contains DBXCommon, DBXDynalink, and
///  DBXTrace.  DBXCommon must always be used.  However a statically linked
///  application could remove DBXTrace and replace DBXDynalink with a different
///  driver.
///  <para>
///
///  DBX4 driver writers will want to look at the initialization sections of
///  DBXDynalink and/or DBXTrace units.  These sections register themselves
///  with a singleton unit called the ClassRegistry.  The ClassRegistry is used
///  by the DBX4 driver loader to instantiate driver loader classes by name (a String).
///  The use of TPersistent was considered, however TPersistent is more for
///  streamable components.  The ClassRegistry is a simple, lightweight mechanism.
///  <para>
///
///
///  Areas subject to change/improve before the first release:
///  <para>
///
///  1) dbxadapter30.dll will not be used for native apps, but will probably
///  be used for managed apps due to the use of static pinvoke.
///  <para>
///
///  2) The ability to link the existing c/c++ drivers statically into a delphi
///  app needs to be reenabled.  This can be done again.  Its just work.
/// </remarks>

unit DBXCommon;

{$Z+}


interface
uses
  DBXPlatform, DBPlatform,
  Windows, Classes, IniFiles, SysUtils,
  DBCommonTypes, FMTBcd, SqlTimSt, ClassRegistry, Contnrs,
  Registry
{$IF DEFINED(CLR)}
  , System.Web
  , System.Web.Hosting
  , System.Reflection
  , System.Runtime.Serialization
{$ELSE}
  , WideStrings
{$IFEND}
;

const

  DBXVersion25     = '2.5';
  DBXVersion30     = '3.0';
  DBXVersion40     = '4.0';

  ///<summary>
  ///  Default row buffering size to use for drivers that return true
  ///  for TDBXDatabaseMetaData.SupportsRowSetSize.
  ///  </summary>
  DBXDefaultRowSetSize  = 20;

//{$IFDEF LINUX}
//  SDBEXPRESSREG_USERPATH = '/.borland/';          { Do not localize }
//  SDBEXPRESSREG_GLOBALPATH = '/usr/local/etc/';   { Do not localize }
//  SDriverConfigFile = 'dbxdrivers';                  { Do not localize }
//  SConnectionConfigFile = 'dbxconnections';          { Do not localize }
//  SConfExtension = '.conf';                       { Do not localize }
//{$ELSE}
//{$ENDIF}
  TDBXRegistryKey               = '\Software\Borland\BDS\5.0\dbExpress'; { Do not localize }
  TDBXRegistryDriverValue       = 'Driver Registry File';           { Do not localize }
  TDBXRegistryConnectionValue   = 'Connection Registry File';   { Do not localize }

  TDBXDriverFile          = 'dbxdrivers.ini';            { Do not localize }
  TDBXConnectionFile      = 'dbxconnections.ini';    { Do not localize }

type

  // Forward declarations.
  //
  TDBXContext = class;
  TDBXValue = class;
  TDBXByteReader = class;
  TDBXConnection = class;
  TDBXDriverLoader = class;
  TDBXDelegateDriver = class;
  TDBXDelegateItem = class;
  TDBXConnectionFactory = class;
  TDBXAnsiStringValue = class;
  TDBXDateValue = class;
  TDBXBooleanValue = class;
  TDBXTimeValue = class;
  TDBXWideStringValue = class;
  TDBXInt16Value = class;
  TDBXInt32Value = class;
  TDBXInt64Value = class;
  TDBXDoubleValue = class;
  TDBXByteArrayValue = class;
  TDBXTimeStampValue = class;
  TDBXBcdValue = class;
  TDBXRow = class;
  TDBXCommand = class;
  TDBXValueList = class;
  TDBXConnectionBuilder = class;
  TDBXValueType = class;
  TDBXWritableValue = class;
  TDBXProperties = class;
  TDBXTransaction = class;
  TDBXDatabaseMetaData = class;
  TDBXPropertiesItem = class;
  TDBXDriver = class;
  TDBXParameterList = class;
  TDBXReader = class;
  TDBXParameter = class;
  TDBXCommandFactory = class;

  ///  <summary>Data types supported by DBX.</summary>
  TDBXDataTypes = class
    const
      ///<summary></summary>
      UnknownType         = 0;
      ///<summary>8 bit Ansi String</summary>
      AnsiStringType         = 1;
      ///<summary>32 bit Date</summary>
      DateType            = 2;
      ///<summary>Blob with a subtype</summary>
      BlobType            = 3;
      ///<summary>16 big Boolean</summary>
      BooleanType            = 4;
      ///<summary>16 bit signed integer</summary>
      Int16Type           = 5;
      ///<summary>32 bit signed integer</summary>
      Int32Type           = 6;
      ///<summary>64 bit floating point</summary>
      DoubleType           = 7;
      ///<summary>TBcd decimal from the FMTBcd unit</summary>
      BcdType             = 8;               { BCD }
      ///<summary>Fixed length byte array</summary>
      BytesType           = 9;
      ///<summary>32 bit Time</summary>
      TimeType            = 10;
//      ///<summary>TSql</summary>
//      DATETIME       = 11;              { Time-stamp  (64 bit) }
      ///<summary>Unsigned 16 bit integer</summary>
      UInt16Type          = 12;
      ///<summary>Unsigned 32 bit integer</summary>
      Uint32Type          = 13;
//      ///<summary></summary>
//      FLOATIEEE       = 14;              { 80-bit IEEE float }
      ///<summary>Variable length byte array with maximum length of 64 kilobytes</summary>
      VarBytesType        = 15;
//      ///<summary></summary>
//      LOCKINFO        = 16;              { Look for LOCKINFO typedef }
      ///<summary>Oracle cursor type</summary>
      CursorType          = 17;
      ///<summary>64 bit integer</summary>
      Int64Type           = 18;
      ///<summary>unsigned 64 bit integer</summary>
      Uint64Type          = 19;
      ///<summary>Abstract data type</summary>
      AdtType             = 20;
      ///<summary>Array data type</summary>
      ArrayType           = 21;
      ///<summary>Reference data type</summary>
      RefType             = 22;
      ///<summary>Nested table data type</summary>
      TableType           = 23;
      ///<summary>TSQLTimeStamp in the SqlTimSt unit</summary>
      TimeStampType       = 24;
      ///<summary></summary>
//      FMTBCD          = 25;              { BCD Variant type: required by Midas, same as BCD for DBExpress}
      ///<summary>UCS2 unicode string</summary>
      WideStringType      = 26;

      ///<summary>Maximum number of base types excluding sub types</summary>
      MaxBaseTypes  = 27;


      ///<summary>Monetary sub type</summary>
      MoneySubType         = 21;

    { BLOB subtypes }

      ///<summary>8 bit char blob</summary>
      MemoSubType          = 22;
      ///<summary>Binary blob</summary>
      BinarySubType        = 23;
      ///<summary></summary>
//      SUB_TYPE_FMTMEMO       = 24;              { Formatted Text }
      ///<summary></summary>
//      SUB_TYPE_OLEOBJ        = 25;              { OLE object (Paradox) }
      ///<summary></summary>
//      SUB_TYPE_GRAPHIC       = 26;              { Graphics object }
      ///<summary></summary>
//      SUB_TYPE_DBSOLEOBJ     = 27;              { dBASE OLE object }
      ///<summary></summary>
//      SUB_TYPE_TYPEDBINARY   = 28;              { Typed Binary data }
      ///<summary></summary>
//      SUB_TYPE_ACCOLEOBJ     = 30;              { Access OLE object }
      ///<summary>Unicode blob</summary>
      WideMemoSubType      = 32;
      ///<summary>CLOB</summary>
      HMemoSubType         = 33;
      ///<summary>BLOB</summary>
      HBinarySubType       = 34;
      ///<summary>BFILE</summary>
      BFileSubType         = 36;

    { AnsiString / WideString subtype }

//      SUB_TYPE_PASSWORD      = 1;               { Password }

      ///<summary>Fixed length char</summary>
      FixedSubType         = 31;

      ///<summary>32 bit integer autoincrement</summary>
      AutoIncSubType       = 29;

    { ADT subtype }

      ///<summary>ADT for nested table (has no name)</summary>
      AdtNestedTableSubType = 35;

      ///<summary>DATE (OCIDate) with in an ADT</summary>
      AdtDateSubType       = 37;

      ///<summary>Oracle TimeStamp</summary>
      OracleTimeStampSubType  = 38;
      ///<summary>Oracle Interval</summary>
      OracleIntervalSubType   = 39;
  end;

  ///  <summary>Data types supported by DBX.</summary>
  TDBXDataTypesEx = class
    const
      ///<summary>32 bit floating point</summary>
      SingleType         = 27;
      ///<summary>8 bit signed integer</summary>
      Int8Type           = 28;
      ///<summary>8 bit unsigned integer</summary>
      Uint8Type          = 29;
      ///<summary>Object serialization</summary>
      ObjectType         = 30;
      ///<summary>Character array</summary>
      CharArrayType      = 31;
      ///<summary>Time Interval</summary>
      IntervalType       = 32;
  end;

  ///<summary>Type for TDBXDataTypes</summary>
  TDBXType = TInt32;
  ///<summary>Type for TDBXDataTypes.Date</summary>
  TDBXDate  = TInt32;
  ///<summary>Type for TDBXDataTypes.Date</summary>
  TDBXTime  = TInt32;

///  <summary>Error codes for DBXError exceptions</summary>

  TDBXErrorCodes =  class
    const
      ///<summary>Successful completion.</summary>
      None                                = $0000;
      ///<summary>Non fatal warning.  Currently not used.</summary>
      Warning                             = $0001;
      ///<summary>Insuffucient memory to complete the operation.</summary>
      NoMemory                            = $0002;
      ///<summary>Field type is not supported by this driver.</summary>
      UnsupportedFieldType                    = $0003;
      ///<summary>
      /// Unexpected internal error. DBX Object such as a connection,
      ///  command or reader may already be closed.
      ///</summary>
      InvalidHandle                       = $0004;
      ///<summary>
      ///  Unsupported feature for the driver in use.  Typical for unsupported
      ///  metadata related requests.
      ///</summary>
      NotSupported                        = $0005;
      ///<summary>Invalid value for a TDBXDataTypes.TIME field.</summary>
      InvalidTime                         = $0006;
      ///<summary>
      ///  Invalid value read operation attempted for a TDBXReader
      ///  or a TDBXParameter field.
      ///  Use a get method of the correct type for this field.
      ///</summary>
      InvalidType                         = $0007;
      ///<summary>
      ///  Ordinal used to access a DBXReader
      ///  column or a TDBXParameter is out of range.
      ///</summary>
      InvalidOrdinal                      = $0008;
      ///<summary>
      ///  Invalid use of a parameter.  Common causes include:  1) Parameter already
      ///  bound.
      ///  2) TDBXParameterDirections setting used is not supported by this driver.
      ///</summary>
      InvalidParameter       = $0009;
      ///<summary>
      ////  Used internally by dynalink drivers to indicate that
      ///   a TDBXReader has no more rows.
      ///</summary>
      EOF                                 = $000A;
      ///<summary>
      ///  One or more parameters for a TDBXCommand has not been set.
      ///</summary>
      ParameterNotSet                         = $000B;
      ///<summary>User or the password provided for a TDBXConnection are not valid.</summary>
      InvalidUserOrPassword                     = $000C;
      ///<summary>
      ///  Attempt to set a TDBXParameter with an invalid precision or
      ///  read a value with a TDBXDataTypes value that is not large enough.
      ///</summary>
      InvalidPrecision                    = $000D;
      ///<summary>
      ///  Unexpected error.  Insufficient storage provided to retrieve a TDBXParameter value.
      ///</summary>
      InvalidLength                       = $000E;
      ///<summary>
      ///  TDBXIsolations level used is not valid for this driver.
      ///</summary>
      InvalidIsolationLevel               = $000F;
      ///<summary>
      ///  Unexepected internal error.  Transaction
      ///  id is either expired or invalid.
      ///</summary>
      InvalidTransactionId                = $0010;
      ///<summary>
      ///  Unexepected internal error.  Transaction id is already in use by
      ///  an active transaction.
      ///</summary>
      DuplicateTransactionId              = $0011;
      ///<summary>
      ///  This driver is not available for the Delphi SKU purchased.
      ///</summary>
      DriverRestricted                    = $0012;
      ///<summary>
      ///  Operation cannot be completed with a transaction active for the
      ///  TDBXConnection.
      ///</summary>
      TransactionActive              = $0013;
      ///<summary>
      ///  Support for multiple transactions is not enabled for this driver.
      ///</summary>
      MultipleTransactionNotEnabled       = $0014;
      ///<summary>
      ///  TDXConnection.Open connect operation failed.
      ///</summary>
      ConnectionFailed                    = $0015;
      ///<summary>
      ///  Driver could not be properly intialized.  Client library may be missing
      ///  not installed properly or of the wrong version.
      ///</summary>
      DriverInitFailed                    = $0016;
      ///<summary>
      ///  Optimistic lock failed.  Oracle driver will return this for
      ///  "OCI-21700: object does not exist or is marked for delete"
      ///</summary>
      OptimisticLockFailed                = $0017;
      ///<summary>
      ///  Unexpected internal error accessing an Oracle REF object.
      ///</summary>
      InvalidReference                    = $0018;
      ///<summary>
      ///  Unexpected internal error accessing an Oracle REF object.
      ///</summary>
      NoTable                             = $0019;
      ///<summary>
      ///  Parametized query is missing a '?' parameter marker.
      ///</summary>
      MissingParameterMarker              = $001A;
      ///<summary>
      ///  Feature not implemented.
      ///</summary>
      NotImplemented                      = $001B;
      ///<summary>
      ///  Deprecated.  Driver is not compatible with version of VCL data access
      ///  components in use.  In the future this should be managed by the components
      ///  not the drivers.
      ///</summary>
      DriverIncompatible                  = $001C;
      ///<summary>
      ///  Argument used for an operation is invalid.
      ///</summary>
      InvalidArgument                     = $001D;
      ///<summary>
      ///  Attempted operation is invalid.
      ///</summary>
      InvalidOperation                     = $001E;
      ///<summary>
      ///  Used internally by Dynalink drivers.  This is not an error.  It is used
      ///  to indicate that there either no more rows for a TDBXReader and also
      ///  to indicate that there is no more data when reading blob fields.
      ///</summary>
      NoData                              = $0064;
      ///<summary>
      ///  Max common errors.
      ///</summary>
      MaxCommonErrors                     = $0064;

      ///<summary>
      ///  Vendor specific error.
      ///</summary>
      VendorError                         = $0065;
  end;

  ///<summary></summary>
  TDBXErrorCode = TInt32;
  ///  <summary>Isolation levels supported by TDBXTransaction</summary>
//{$SCOPEDENUMS ON}
  TDBXIsolations       = class
    const
      ///<summary>
      /// Current transaction sees only changes that have been committed,
      /// but can receive an inconsistent view of the data if additional changes are committed before the transaction ends.
      ///</summary>
      ReadCommitted = 0;
      ///<summary>
      /// Current transaction is guaranteed a consistent view of the data,
      /// which includes only changes committed by other transactions at the start of the transaction.
      ///</summary>
      RepeatableRead = 1;
      ///<summary>
      /// Current transaction sees all changes made by other transactions,
      /// even if they have not yet been committed. This option is not available for the Oracle driver.
      ///</summary>
      DirtyRead = 2;
      ///<summary>
      /// Since DBX 4.
      /// Current transaction sees no changes made by other transactions including phantoms.
      ///</summary>
      Serializable = 3;
      ///<summary>
      /// Since DBX 4.
      /// Read only transaction that provides a transactionally consistent snapshot of the database.
      ///</summary>
      SnapShot = 4;
  end;
//{$SCOPEDENUMS OFF}
  TDBXIsolation = TInt32;

  ///  <summary>Parameter types supported by TDBXParameter</summary>
//{$SCOPEDENUMS ON}
  TDBXParameterDirections = class
    const
      ///<summary>
      /// The parameter type is unknown (generates an error).
      ///</summary>
        Unknown = 0;
      ///<summary>
      /// Input parameter.
      ///</summary>
        InParameter = 1;
      ///<summary>
      /// Output parameter.
      ///</summary>
        OutParameter = 2;
      ///<summary>
      /// Input/Output parameter.
      ///</summary>
        InOutParameter = 3;
      ///<summary>
      /// Return parameter.
      ///</summary>
        ReturnParameter = 4;
  end;
//{$SCOPEDENUMS OFF}
  TDBXParameterDirection = TInt32;

  ///<summary>Used internally by TDBXValuType bit fields.</summary>
  TDBXValueTypeFlags = class
    const
    ///<summary>Value is nullable</summary>
      Nullable        = $01;
    ///<summary>Value is read only</summary>
      ReadOnly        = $02;
    ///<summary>Value is searchable </summary>
      Searchable      = $04;
    ///<summary>Value is autoincrement</summary>
      AutoIncrement   = $08;
//    ///<summary>Value is exact blob</summary>
//      BlobSizeExact   = $10;
    ///<summary>Value tpye is readonly</summary>
      ReadOnlyType    = $20;
  end;
  TDBXValueTypeFlagsEx = class(TDBXValueTypeFlags)
    const
      /// <summary>
      ///   Used internally to indicate that most recent value types should
      ///   be used if applicable.  Only used by the most up to date driver
      ///   implementations since use of these types breaks old interfaces.
      ///  </summary>
      ExtendedType    = $40;
  end;

  ///<summary>
  ///
  ///</summary>
  ///<remarks> Better to use bits than a set because some drivers are written
  ///  in c/c++ </remarks>
  ///
  TDBXTraceFlags = class
    const
    ///<summary>Trace nothing.</summary>
      None        = $0000;
    ///<summary>prepared query statements</summary>
      Prepare     = $0001;
    ///<summary>executed query statements</summary>
      Execute     = $0002;
    ///<summary>errors</summary>
      Error       = $0004;
    ///<summary>command related operations.</summary>
      Command     = $0008;
    ///<summary>connect and disconnect</summary>
      Connect     = $0010;
    ///<summary>transaction commit, rollback</summary>
      Transact    = $0020;
    ///<summary>blob access</summary>
      Blob        = $0040;
    ///<summary>Miscellaneos</summary>
      Misc        = $0080;
    ///<summary>Vendor specific operations</summary>
      Vendor      = $0100;
    ///<summary>TDBXParamter access</summary>
      Parameter   = $0200;
    ///<summary>TDBXReader operations</summary>
      Reader      = $0400;
    ///<summary>Driver loading operations.</summary>
      DriverLoad = $0800;
    ///<summary>Meta data access operations.</summary>
      MetaData    = $1000;
    ///<summary>Driver operations.</summary>
      Driver      = $2000;
  end;
    ///<summary>Type used for TDBXTraceFlags</summary>
  TDBXTraceFlag = TInt32;


  ///  <remarks> Common property names for both connections and drivers</remarks>
  TDBXPropertyNames = class
  const
    ///<summary>
    ///  Name of connection.  If connection properties are read from an ini file,
    ///  this is the ini file section name.
    ///  AdoDbxClient can use this property setting for a simple one property connection string.
    ///  Connection names can also be used to load a connection from a
    ///  TDBXConnectionFactory instance.
    ///</summary>
    ConnectionName              = 'ConnectionName';     { Do not localize }
    ///<summary>dbxdrivers.ini section that specifies what drivers are enabled.</summary>
    InstalledDrivers            = 'Installed Drivers';  { Do not localize }
    ///<summary>
    ///  Used by pre-DBX4 Dynalink drivers to specify exported entry point
    ///  for loading a pre-DBX4 driver.
    ///</summary>
    GetDriverFunc               = 'GetDriverFunc';      { Do not localize }
    ///<summary>
    ///  Used by Dynalink drivers.  Name of a vendor specific client library.
    ///</summary>
    VendorLib                   = 'VendorLib';          { Do not localize }
    ///<summary>
    ///  Currently only used by older linux versions of DbExpress to specify
    ///  localized error message file.
    ///</summary>
    ErrorResourceFile           = 'ErrorResourceFile';  { Do not localize }
    ///<summary>
    ///  Used by Dynalink drivers to specify the name of the Dynalink dll.
    ///</summary>
    LibraryName                 = 'LibraryName';        { Do not localize }
    ///<summary>
    /// Unique name for a DBX driver.  Used by dbxconnections.ini to refer
    ///  to a connections driver in the dbxdrivers.ini file.
    ///</summary>
    DriverName                  = 'DriverName';         { Do not localize }
    ///<summary>
    ///  Hostname of a database server that a driver connects to.
    ///</summary>
    HostName                        = 'HostName';           { Do not localize }
    ///<summary>
    ///  Port number of a database server that a driver connects to.
    ///</summary>
    Port                        = 'Port';               { Do not localize }
    ///<summary>
    ///  Name of a database to connect to.
    ///</summary>
    Database                    = 'Database';           { Do not localize }
    ///<summary>
    ///  Login user name used to connect to a database.
    ///</summary>
    UserName                    = 'User_Name';          { Do not localize }
    ///<summary>
    ///  Login password name used to connect to a database.
    ///</summary>
    Password                    = 'Password';           { Do not localize }
    ///<summary>
    ///  Login role used to connect to a database.
    ///</summary>
    Role                        = 'Role';               { Do not localize }
    ///<summary>
    ///  Initial transaction isolation to use when connecting to a database.
    ///  Transaction isolation can also be specified when a transaction is
    ///  started.
    ///</summary>
    IsolationLevel              = 'IsolationLevel';     { Do not localize }
    ///<summary>
    /// Maximum blog size.  Set to -1 to specify no limit.
    ///</summary>
    MaxBlobSize                 = 'MaxBlobSize';        { Do not localize }
    ///<summary>
    ///  Delegate connection used by this connection.  Delegate connections
    ///  implement the DBX4 driver framework.  They can perform pre or post
    ///  processing of all public and protected methods, events and properties
    ///  before delegating to the real connection or another delegate connection.
    ///</summary>
    DelegateConnection          = 'DelegateConnection'; { Do not localize }
    ///  <remarks> Used to provide informative error message when driver cannot be loaded</remarks>
    DriverUnit                  = 'DriverUnit';         { Do not localize }
    ///  <summary>deprecated.  Preferable to just add the a comma plus the package
    ///   name to the end of the DriverPackageLoader property setting.
    ///  </smmary>
    ///  <remarks> Used to load a native driver dynamically</remarks>
    DriverPackage               = 'DriverPackage';      { Do not localize }
    ///  <summary>deprecated.  Preferable to just add the a comma plus the assembly
    ///   name to the end of the DriverAssemblyLoader property setting.
    ///  </smmary>
    ///  <remarks> Used to load a managed driver dynamically. </remarks>
    DriverAssembly              = 'DriverAssembly';      { Do not localize }
    ///  <summary>Comma separated class and package name.
    ///  </summary>
    ///  <remarks> Native Driver loader class used to load a native driver dynamically from a package</remarks>
    DriverPackageLoader         = 'DriverPackageLoader';      { Do not localize }
    ///  <summary>Comma separated class and package name.
    ///  </summary>
    ///  <remarks> Managed Driver loader class used to load a managed driver dynamically from an assembly </remarks>
    DriverAssemblyLoader        = 'DriverAssemblyLoader';      { Do not localize }
    ///<remarks>
    ///  Indicates that this driver is a delegate and can only be used in conjunction
    ///  with a non-delegate driver.
    ///</remarks>
    DelegateDriver              = 'DelegateDriver';      { Do not localize }
    /// <remarks>
    ///  Most applications should not need to use this property.
    ///  Provided for backwards compatibility of the dbExpress vcl.
    ///  The vcl components will use this setting to scope metadata requests.
    ///  This property should be set to <user-name>.<override-schema-name>.
    ///  For example, tables created by the MSSQL sa user are placed in the dbo
    ///  schema.  In this case SchemaOverride can be set to 'sa.dbo'.  This
    ///  will cause the vcl to specify the 'dbo' schema for metadata requests
    ///  when a connection is made using the 'sa' user.  SQL '%' like pattern
    ///  can also be used for the user-name and the override-schema-name.
    ///  For example, '%.%' would cause the schema to not be specified at
    ///  all for all users.
    ///</remarks>
    SchemaOverride              = 'SchemaOverride';      { Do not localize }
  end;

  ///  <remarks> Common property names for both connections and drivers</remarks>
  TDBXPropertyNamesEx = class
    const
    ///  <remarks> Native MetaData loader class used to load a native driver dynamically from a package</remarks>
    MetaDataPackageLoader       = 'MetaDataPackageLoader';      { Do not localize }
    ///  <remarks> Managed MetaData loader class used to load a managed driver dynamically from an assembly </remarks>
    MetaDataAssemblyLoader      = 'MetaDataAssemblyLoader';      { Do not localize }
    ///<remarks>
    ///  Can be specified as a driver property as an override of the
    ///  <c>TDBXConnection.ProductVersion</c> property.  This may be necessary
    ///  for drivers that do not have the ability to report the product
    ///  version.
    ///  The ProductVersion is a number in the format nn.nn.nnnn
    ///</remarks>
    ProductVersion               = 'ProductVersion';      { Do not localize }
    ///<summary>
    ///  Provides the product name for the DBX4 metadata.
    ///  </summary>
    ProductName                  = 'ProductName';      { Do not localize }
  end;

  ///<summary>The type of command to be executed by a command</summary>
  TDBXCommandTypes = class
    const
      ///<summary>Used for any SQL statement including selects, inserts, updates, deletes, etc</summary>
      DbxSQL                 = 'Dbx.SQL';
      ///<summary>Used for any stored procedure</summary>
      DbxStoredProcedure     = 'Dbx.StoredProcedure';
      ///<summary>Used to retrieve all rows an columns of a table</summary>
      DbxTable              = 'Dbx.Table';
      ///<summary>
      ///  Used to retrieve metadata of objects such as tables and columns
      ///  that ar accessible from a <c>TDBXConnection</c>
      ///</summary>
      DbxMetaData            = 'Dbx.MetaData';
      ///<summary>deprecated.  Do not use.</summary>
      DbxCommand             = 'Dbx.Command';
      ///<summary>
      /// Command type for <c>TDBXPool</c> commands
      ///</summary>
      DbxPool               = 'Dbx.Pool'; { do not localize }
  end;


  ///<summary>
  ///  List of "show" commands that can be executed when the <c>TDBXCommand.CommandType</c>
  ///  property is set to <c>TDBXCommandTypes.DBXMetadata</c>
  ///</summary>
  TDBXMetaDataCommands = class
    const
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetDatabase'.  When the command is executed
      ///  a <c>TDBXReader</c> instance is returned with a single row of database
      ///  specific metadata.
      ///</summary>
      GetDatabase                  = 'GetDatabase';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetDataTypes'.  When the command is executed
      ///  a <c>TDBXReader</c> instance is returned with metadata for the data
      ///  types supported by the driver.
      ///</summary>
      GetDataTypes                 = 'GetDataTypes';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetTables [[[catalog.]schema.]table [table-types]]'.
      ///  'table-types' is a space separated list of one or more of the constants
      ///  in <c>TDBXMetadataTypeTypes</c>.
      ///  When the command is executed
      ///  a <c>TDBXReader</c> instance is returned with metadata
      ///  for the specified table(s).
      ///</summary>
      GetTables                    = 'GetTables';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetColumns [[[catalog.]schema.]table]'.
      ///  When the command is executed
      ///  a <c>TDBXReader</c> instance is returned with metadata for the
      ///  columns of the specified table(s).
      ///</summary>
      GetColumns                   = 'GetColumns';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetForeignKeys [[[catalog.]schema.]table]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the foreign keys of the specified table(s).
      ///</summary>
      GetForeignKeys               = 'GetForeignKeys';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetForeignKeyColumns [[[catalog.]schema.]table [foreign-key] [PrimaryKey|ForeignKey]]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for each column pair in the foreign keys of the specified table(s).
      ///</summary>
      GetForeignKeyColumns          = 'GetForeignKeyColumns';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetIndexes [[[catalog.]schema.]table]'.
      ///  When the command is executed
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the indexes of the specified table(s).
      ///</summary>
      GetIndexes                   = 'GetIndexes';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetIndexColumns [[[catalog.]schema.]table [index]]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the columns in the indexes of the specified table(s).
      ///</summary>
      GetIndexColumns              = 'GetIndexColumns';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetPackages [[[catalog.]schema.]package]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  metadata for the specified package(s).
      ///</summary>
      GetPackages                  = 'GetPackages';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetProcedures [[[catalog.]schema.]procedure [procedure-type]]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the specified procedure(s).
      ///</summary>
      GetProcedures                = 'GetProcedures';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetProcedureParameters [[[catalog.]schema.]procedure]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the parameters of the specified procedure(s).
      ///</summary>
      GetProcedureParameters       = 'GetProcedureParameters';
      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetUsers'.  When the command is executed
      ///  a <c>TDBXReader</c> instance is returned metadata for the
      ///  specified user(s).
      ///</summary>
      GetUsers                     = 'GetUsers';
  end;

  TDBXMetaDataCommandsEx = class
    const

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetViews [[[catalog.]schema.]view]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the view(s) specified.
      ///</summary>
      ///<remarks>DBX 4</remarks>
      GetViews                     = 'GetViews';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetSynonyms [[[catalog.]schema.]synonym]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the synonym(s) specified.
      ///</summary>
      ///<remarks>DBX 4</remarks>
      GetSynonyms                  = 'GetSynonyms';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetCatalogs'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with a list of existings catalogs in the database.
      ///</summary>
      ///<remarks>DBX 4</remarks>
      GetCatalogs                  = 'GetCatalogs';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetSchemas [catalog]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with a list of existings schemas in the specified catalog(s).
      ///</summary>
      ///<remarks>DBX 4</remarks>
      GetSchemas                   = 'GetSchemas';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetProcedureSources [[[catalog.]schema.]procedure]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with the source of the specified procedure(s).
      ///</summary>
      ///<remarks>DBX 4</remarks>
      GetProcedureSources          = 'GetProcedureSources';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetPackageProcedures [[[[[catalog.]schema.]package].procedure] [procedure-type]]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the specified package procedure(s).
      ///</summary>
      ///<remarks>DBX 4</remarks>
      GetPackageProcedures         = 'GetPackageProcedures';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetPackageProcedureParameters [[[[catalog.]schema.]package].procedure]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with metadata for the parameters of the specified package procedure(s).
      ///</summary>
      ///<remarks>DBX 4</remarks>
      GetPackageProcedureParameters = 'GetPackageProcedureParameters';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetPackageSources [[[catalog.]schema.]package]'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with the source of the specified package(s).
      ///</summary>
      ///<remarks>DBX 4</remarks>
      GetPackageSources            = 'GetPackageSources';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetRoles'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with a list of existings role(s).
      ///</summary>
      GetRoles                     = 'GetRoles';

      ///<summary>
      ///  Set <c>TDBXCommand.Text' to 'GetReservedWords'.
      ///  When the command is executed a <c>TDBXReader</c> instance is returned
      ///  with a list of reserved words for the database.
      ///</summary>
      GetReservedWords             = 'GetReservedWords';
  end;


  TDBXMetaDataKeyword = class
  const
    PrimaryKey = 'PrimaryKey';
    ForeignKey = 'ForeignKey';
  end;

  TDBXMetaDatabaseColumnNames = class
  const
    ///<summary>
    ///  deprecated.  Use <c>QuotePrefix</c> and <c>QuoteSuffix</c>
    ///</summary>
    QuoteChar                    = 'QuoteChar';
    ProcedureQuoteChar           = 'ProcedureQuoteChar';
    MaxCommands                  = 'MaxCommands';
    SupportsTransactions         = 'SupportsTransactions';
    SupportsNestedTransactions   = 'SupportsNestedTransactions';
    SupportsRowSetSize           = 'SupportsRowSetSize';
    ProductVersion               = 'ProductVersion';
    ProductName                  = 'ProductName';
    QuotePrefix                  = 'QuotePrefix';
    QuoteSuffix                  = 'QuoteSuffix';
    SupportsLowerCaseIdentifiers = 'SupportsLowerCaseIdentifiers';
    SupportsUpperCaseIdentifiers = 'SupportsUpperCaseIdentifiers';
  end;



  ///<summary>
  ///  One or more of these contants may be passed to the 'GetTables' metadata
  ///  command.
  ///</summary>
  ///  <seealso>
  ///  <c>TDBXMetaDataCommands.Tables</c>
  ///  </seeAlso>
  TDBXMetaDataTableTypes = class
    const
      ///<summary>
      ///  Get tables.
      ///</summary>
      Table                    = 'Table';
      ///<summary>
      ///  Get Views
      ////</summary>
      View                     = 'View';
      ///<summary>
      ///  Get System tables
      ///</summary>
      SystemTable              = 'SystemTable';
      ///<summary>
      ///  Get synonyms
      ///</summary>
      Synonym                  = 'Synonym';
  end;

  TDBXMetaDataTableTypesEx = class
    const
      ///  Get System views
      ///</summary>
      SystemView               = 'SystemView';
      ///<summary>
  end;

  ///<summary>
  ///  One or more of these contants may be passed to the 'GetProcedures' metadata
  ///  command.
  ///</summary>
  ///  <seealso>
  ///  <c>TDBXMetaDataCommands.Tables</c>
  ///  </seeAlso>
  TDBXMetaDataProcedureTypes = class
    const
      ///<summary>
      ///  Get procedures.
      ///</summary>
      ProcedureType            = 'Procedure';
      ///<summary>
      ///  Get functions.
      ////</summary>
      FunctionType             = 'Function';
  end;



//{$IF DEFINED(CLR)}
//  TWideStringList = TStringList;
//{$IFEND}
  TDBXChars = array of Char;
  TWideStringArray = array of WideString;
  TDBXValueArray = array of TDBXValue;

  ///<summary>
  ///  Exception type for all DBX errors.
  ///</summary>

{$IF DEFINED(CLR)}
  [Serializable]
{$IFEND}
  TDBXError = class(Exception)
    private
      FErrorCode:     TDBXErrorCode;
      FErrorMessage:  WideString;
{$IF DEFINED(CLR)}
    protected
      constructor Create(Info: SerializationInfo; Context: StreamingContext); overload;
    public
      procedure GetObjectData(Info: SerializationInfo; Context: StreamingContext); override;
{$IFEND}
    public
      constructor Create(ErrorCode: TDBXErrorCode; const ErrorMessage: WideString);
{$IF DEFINED(CLR)}
      overload;
{$IFEND}
      ///<summary>
      ///  Convert known error codes to a String.
      ///</summary>
      class function ErrorCodeToString(ErrorCode: TDBXErrorCode): WideString; static;
      ///<summary>
      ///  TDBXErrorCode for this error.  See the const section of TDBXErrorCodes
      ///  for a list of common error codes with explanations.
      ///</summary>
      property ErrorCode: TDBXErrorCode read FErrorCode;
      ///<summary>
      ///  WideString containing an explanation of the error.
      ///</summary>
      property Message: WideString read FErrorMessage;

  end;

  ///<summary>
  ///  Event handler that can be set on the TDBXConnection.OnErrorEvent property
  ///  This event is called just before a TDBXError exception is raised.
  ///  This allows implementors to perform processing before the exception is
  ///  raised.  The DbExpress vcl components use this event to raise an exception
  ///  of a different type.
  ///</summary>
  TDBXErrorEvent = procedure(DBXError: TDBXError) of object;


  ///<summary>
  ///  TDBXTraceInfo is passed in to TDBXTraceEvent handlers.
  ///</summary>
  TDBXTraceInfo = packed record
    private
      FTraceMessage:    WideString;
      FTraceFlag:       TDBXTraceFlag;
    public
      ///<summary>
      ///  Trace information for a trace TDBXTraceEvent.
      ///</summary>
      property Message: WideString read FTraceMessage write FTraceMessage;
      ///<summary>
      ///  One of TDBXTracFlag tracing categories for a TDBXTraceEvent.
      ///</summary>
      property TraceFlag: TDBXTraceFlag read FTraceFlag write FTraceFlag;
  end;

  ///<summary>
  ///  This event provides tracing information for DBX database drivers.
  ///  TDBXConnection has a TDBXTraceEvent property called OnTrace.
  ///  The TDBXTrace delegate uses this event to provide DBX framework level
  ///  tracing.
  ///</summary>
  TDBXTraceEvent = function (TraceInfo: TDBXTraceInfo): CBRType of object;


  ///<summary>
  ///  Simple class to manage connection and driver level name/value pair
  ///  property settings.
  ///</summary>
  TDBXProperties = class
  private
    FDBXContext:        TDBXContext;
    FProperties:        TWideStrings;
    function GetValue(const Name: WideString): WideString;
    procedure SetValue(const Name, Value: WideString);
  protected
    constructor Create(DBXContext: TDBXContext); overload;
  public
    constructor Create; overload;
    ///<summary>
    ///  Get property value as a Boolean.
    ///</summary>
    function GetBoolean(const Name: WideString): Boolean;
    ///<summary>
    ///  Get property value as an Integer.
    ///</summary>
    function GetInteger(const Name: WideString): Integer;
    ///<summary>
    ///  Get property value as a string.  Throws an exception
    ///  if this TDBXProperties instance does not contain a property with the
    ///  given name.
    ///</summary>
    function GetRequiredValue(const Name: WideString): WideString;
    destructor Destroy; override;
    ///<summary>
    ///  Creates a new instance of TDBXProperties with a copy of the same name/value pairs
    ///</summary>
    function Clone: TDBXProperties;
    ///<summary>
    ///  Add the name/value pairs from List into this instance of TDBXProperties.
    ///</summary>
    procedure AddProperties(List: TWideStrings); overload;
    ///<summary>
    ///  Set the semicolon separated name/value pairs from ConnectionString into
    ///  this instance of TDBXProperties.
    ///</summary>
    procedure SetProperties(const ConnectionString: WideString); overload;
    ///<summary>
    ///  Add a name/value pair.
    ///</summary>
    procedure Add(const Name, Value: WideString);
    ///<summary>
    ///  Get the Names and Values as two separete TWideStringArray lists.
    ///</summary>
    procedure GetLists(var Names, Values: TWideStringArray);
    ///<summary>
    ///  String index property accessor.
    ///</summary>
    property Values[const Name: WideString]: WideString read GetValue write SetValue; default;
    ///<summary>
    ///  Get Name/Value pairs as a TWideStrings.
    ///</summary>
    property Properties: TWideStrings read FProperties;
  end;

  ///<summary>
  ///  Abstract base class used for creating new instances of <c>TDBXConnection</c>
  ///  <c>TDBXConnectionFactory.GetConnectionFactory</c> is a class static method
  ///  that returns a <c>TDBXConnectionFactory</c> singleton.  Currently this
  ///  singleton instance defaults to a <c>TDBXIniFileConnectionFactory</c>
  ///  The ini files are loaded from the file names specified under the
  ///   <c>HKEY_CURRENT_USER\TDBXRegistryKey</c> windows registry setting.  If this registry
  ///  key is not set, then the ini files are loaded from the location of
  ///  the application exe file.
  ///  <para>
  ///  A <c>TDBXConnectionFactory</c> manages a collection of named driver and
  ///  connection property sets.  A separate<c>TDBXProperties</c> object is
  ///  used for each driver and connection property set.  The driver properties
  ///  contain enough information to load and instantiate a driver implementation.
  ///  The connection properties include driver properties and contain enought
  ///  information to instantiate a connection.
  ///</summary>
  TDBXConnectionFactory = class
  private

    class function  OpenConnectionFactory(const DriverFileName, ConnectionFileName: WideString): TDBXConnectionFactory;

    function CreateDelegatePath(const ConnectionName: WideString; DBXProperties: TDBXProperties): TDBXDelegateItem; overload;
    function CreateDelegatePath(Depth: Integer; DelegateItem:   TDBXDelegateItem; DBXProperties: TDBXProperties): TDBXDelegateItem; overload;
    function GetConnectionPropertiesItem(const ConnectionName : WideString) : TDBXPropertiesItem;

  private
    class var
      ConnectionFactorySingleton: TDBXConnectionFactory;
    var
      FDrivers:               TWideStringList;
      FConnectionProperties:  TWideStringList;

    function GetDriver(const DriverName: WideString; DriverProperties: TDBXProperties) : TDBXDelegateDriver; overload;
    function getDriverName(ConnectionProperties: TDBXProperties): WideString;

  strict protected
    FDBXContext:  TDBXContext;

    procedure CreateDelegatePaths;


  protected
    function  GetTraceInfoEvent: TDBXTraceEvent; virtual;
    procedure SetTraceInfoEvent(TraceInfoEvent: TDBXTraceEvent); virtual;
    function  GetErrorEvent: TDBXErrorEvent; virtual;
    procedure SetErrorEvent(ErrorEvent: TDBXErrorEvent); virtual;
    function  GetTraceFlags: TDBXTraceFlag; virtual;
    procedure SetTraceFlags(TraceFlags: TDBXTraceFlag); virtual;

    procedure DerivedOpen; virtual; abstract;
    procedure DerivedClose; virtual; abstract;

  public
    constructor Create();
    destructor Destroy; override;
    ///<summary>
    ///  Opens the factory making it ready for use.
    ///</summary>
    procedure Open; virtual;
    ///<summary>
    ///  Closes the factory.  A call to Close and then Open can be used to
    ///  reload the contents of a factory.
    ///</summary>
    procedure Close; virtual;

    ///  <summary>
    ///  Adds the names of all connections in the factory to the Items list.
    ///  </summary>
    procedure GetConnectionItems(Items: TStrings);


    ///<returns><c>TDBXProperties</c> instance of connection properties for <c>ConnectionName</c>
    function GetConnectionProperties(const ConnectionName : WideString) : TDBXProperties;
    ///<returns><c>TDBXProperties</c> instance of driver properties for <c>DriverName</c>
    function GetDriverProperties(const DriverName : WideString) : TDBXProperties;
    ///<remarks>Call TDBXDriver.Free when the returned value is no longer needed.</remarks>
    ///<returns><c>TDBXDriver</c> instance for <c>DriverName</c></returns>
    function GetDriver(const DriverName : WideString) : TDBXDriver; overload;
    ///<remarks>Call TDBXDriver.Free when the returned value is no longer needed.</remarks>
    ///<returns><c>TDBXDriver</c> instance for <c>ConnectionName</c></returns>
    function GetConnectionDriver(const ConnectionName : WideString) : TDBXDelegateDriver; overload;
    ///<remarks>
    ///  Call TDBXConnection.Free when the returned value is no longer needed.
    ///  If <c>UserName</c> is set to an empty string,
    ///  then <c>ConnectionName</c>s associated <c>TDBXProperties</c> setting for
    ///  <c>TDBXPropertyNames.UserName</c> will be used.
    ///  If <c>Password</c> is set to an empty string,
    ///  then <c>ConnectionName</c>s associated <c>TDBXProperties</c> setting for
    ///  <c>TDBXPropertyNames.Password</c> will be used.
    ///</remarks>
    ///<returns><c>TDBXConnection</c> instance.</returns>
    function GetConnection( const ConnectionName : WideString;
                            const UserName: WideString;
                            const Password: WideString) : TDBXConnection; overload;
    ///<remarks>
    ///  Call TDBXConneciton.Free when the returned value is no longer needed.
    ///</remarks>
    ///<returns><c>TDBXConnection</c> instance.</returns>
    function GetConnection(ConnectionProperties : TDBXProperties) : TDBXConnection; overload;

    ///<summary>
    ///  This method can be called only once when an application is initialized
    ///  to change the default <c>TDBXConnectionFactory</c> singleton that
    ///  is returned by the class static <c>GetConnectionFactory</c> method.
    ///</summary>
    class procedure SetConnectionFactory(ConnectionFactory: TDBXConnectionFactory); static;
    ///<returns>
    ///  The class static <c>TDBXConnectionFactory</c> singleton that can
    ///  be used to create new <c>TDBXConnection</c> instances.
    ///</returns>
    class function  GetConnectionFactory: TDBXConnectionFactory; static;

    ///<summary>
    ///  The <c>TDBXErrorEvent</c> handler is called before a <c>TDBXError</c> exception is
    ///  raised.  This <c>TDBXErrorEvent</c> will be propagated to all <c>TDBXConnection</c>
    ///  and <c>TDBXDriver</c> instances created by this <c>TDBXConnectionFactory</c>
    ///<summary>
    ///<returns><c>TDBXErrorEvent</c> handler.</returns>
    property OnError: TDBXErrorEvent read GetErrorEvent write SetErrorEvent;
    ///<summary>
    ///  The <c>TDBXTraceInfoEvent</c> handler is called for driver trace events
    ///  This <c>TDBXTraceInfoEvent</c> will be propagated to all <c>TDBXConnection</c>
    ///  and <c>TDBXDriver</c> instances created by this <c>TDBXConnectionFactory</c>
    ///<summary>
    ///<returns><c>TDBXTraceInfoEvent</c> handler.</returns>
    property OnTrace: TDBXTraceEvent read GetTraceInfoEvent write SetTraceInfoEvent;
    ///<returns>The <c>TDBXTraceFlags</c> that tracing should be enabled for.</returns>
    property TraceFlags: TDBXTraceFlag read GetTraceFlags write SetTraceFlags;
//    property ConnectionFactory: TDBXConnectionFactory read GetConnectionFactory write SetConnectionFactory;

  end;


  ///<summary>
  ///  Implementation of <c>TDBXConnectionFactory</c> that loads driver
  ///  and connection properties from the dbxdrivers.ini and dbxconnections.ini
  ///  files.
  ///</summary>
  TDBXIniFileConnectionFactory = class(TDBXConnectionFactory)
  private
    FConnectionsFile:   WideString;
    FDriversFile:       WideString;

    function LoadSectionProperties(IniFile: TMemIniFile; Section: String;
                                      LoadConnection: Boolean) : TDBXProperties;
    function LoadDriver(DriverIni: TMemIniFile; const DriverName:  WideString) : TDBXProperties;
    procedure LoadDrivers;
    procedure LoadConnections;

  protected
    procedure DerivedOpen; override;
    procedure DerivedClose; override;

  public
    constructor Create();
    destructor Destroy; override;

    ///<returns>File name for the drivers ini file.</returns>
    property DriversFile: WideString
      read  FDriversFile
      write FDriversFile;
    ///<returns>File name for the connections ini file.</returns>
    property ConnectionsFile: WideString
      read  FConnectionsFile
      write FConnectionsFile;

  end;

  TDBXIniFileConnectionFactoryEx = class(TDBXIniFileConnectionFactory)
  public
    ///  <summary>
    ///  Adds the names of all Drivers in the factory to the Items list.
    ///  </summary>
    procedure GetDriverItems(Items: TStrings);
  end;

  ///<summary>
  ///  Implementation of <c>TDBXConnectionFactory</c> that does not
  ///  loads driver and connection properties.  Used by vcl when
  ///  the dbxconnections.ini and dbxdrivers.ini files cannot be found.
  ///</summary>
  TDBXMemoryConnectionFactory = class(TDBXConnectionFactory)
  private
  protected
    procedure DerivedOpen; override;
    procedure DerivedClose; override;

  public
    constructor Create();
    destructor Destroy; override;
  end;

  TDBXCreateCommandEvent = function (DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand of object;

  ///<summary>
  ///  Driver class for DBX framework.  Loads client libraries if needed.
  ///  <para>
  ///  The DBX framework manages reference counts for all drivers that are
  ///  loaded.  When all <c>TDBXConnection</c> and <c>TDBXDriver</c> instances
  ///  are freed, the driver is unloaded.  So if an application holds on to
  ///  an instance of TDBXConnection or TDBXDriver, that driver will not
  ///  be unloaded.
  ///</summary>
  TDBXDriver = class
  private
    FReferenceCount:      TInt32;
    FDriverName:          WideString;
    FDriverProperties:    TDBXProperties;
    procedure AddReference;
    procedure RemoveReference;

  strict protected
    procedure CacheUntilFinalization;
  protected
    FDBXContext:              TDBXContext;
    FDriverLoader:            TDBXDriverLoader;

    function  GetDriverProperties: TDBXProperties; virtual;
    procedure SetDriverProperties(DriverProperties: TDBXProperties); virtual;
    function  GetDriverName: WideString; virtual;
    procedure SetDriverName(const DriverName: WideString); virtual;

    ///<summary>
    /// Used by TDBXConnectionFactory to create instances of TDBXConnection.
    ///</summary>
    function  CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection; virtual; abstract;
    procedure Close; virtual; abstract;
  public
    destructor Destroy; override;
    ///<summary>
    /// Returns version information for this driver.
    ///</summary>
    function GetDriverVersion: WideString; virtual; abstract;
    ///<summary>
    ///  Returns a driver specific properties for this TDBXDriver instance.
    ///</summary>
    property DriverProperties: TDBXProperties
      read GetDriverProperties;
    ///<summary>
    ///  Returns a unique name for this driver.
    ///</summary>
    property DriverName: WideString Read GetDriverName;
  end;

  TDBXDriverEx = class(TDBXDriver)
  private
    FMetaDataCommandFactory: TDBXCommandFactory;
//  private
//    function HasDBX4MetaData: Boolean;
  protected
    FCommandFactories:        TWidestrings;
    function  CreateMorphCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand; virtual;
    procedure LoadMetaDataCommandFactory(const MetaDataCommandFactoryClassName: WideString; const MetaDataCommandFactoryPackageName: WideString);
    procedure AddCommandFactory(Name: WideString; OnCreateCommand: TDBXCreateCommandEvent);
  public
    constructor Create;
    destructor Destroy; override;
  end;

  TDBXStateItem = class
    public
      procedure Close; virtual; abstract;
  end;

  TDBXStateItemList = class
//    private
//      FItems: TWideStrings;
    public
      destructor Destroy; override;
      function GetStateItem(Name: WideString): TDBXStateItem;
      procedure AddStateItem(Name: WideString; Item: TDBXStateItem);
      procedure RemoveAndFreeStateItem(Name: WideString);
  end;
  ///<summary>
  ///  Connection for the DBX framework.  Provides support for creating
  ///  commands, retrieving database related metadata and transaction
  ///  management.
  ///</summary>
  TDBXConnection = class
  private
    FDriverDelegate:                TDBXDriver;
    FTransactionStack:              TDBXTransaction;
    FDatabaseMetaData:              TDBXDatabaseMetaData;
    FOpen:                          Boolean;

    function HasTransaction(Transaction: TDBXTransaction): Boolean;
    procedure CheckTransaction(Transaction: TDBXTransaction);
    procedure FreeTransactions(StartTransaction: TDBXTransaction);

  strict protected
    FIsolationLevel:    TDBXIsolation;

  protected
    FDBXContext:       TDBXContext;
    FConnectionProperties : TDBXProperties;

    function  CreateAndBeginTransaction(Isolation: TDBXIsolation): TDBXTransaction; virtual; abstract;
    procedure Commit(Transaction: TDBXTransaction); virtual; abstract;
    procedure Rollback(Transaction: TDBXTransaction); virtual; abstract;
    procedure Close; virtual;

    // protected virtual property accessors that can be delegated
    // by a descendent.
    //
    function  GetDatabaseMetaData: TDBXDatabaseMetaData; virtual;
    function  GetConnectionProperties: TDBXProperties; virtual;
    procedure SetConnectionProperties(const Value: TDBXProperties); virtual;
    function  GetTraceInfoEvent: TDBXTraceEvent; virtual;
    procedure SetTraceInfoEvent(TraceInfoEvent: TDBXTraceEvent); virtual;
    function  GetTraceFlags: TDBXTraceFlag; virtual;
    procedure SetTraceFlags(TraceFlags: TDBXTraceFlag); virtual;
    function  GetErrorEvent: TDBXErrorEvent; virtual;
    procedure SetErrorEvent(ErrorEvent: TDBXErrorEvent); virtual;
    function  GetIsOpen: Boolean; virtual;
    procedure Open(); virtual;

    function  DerivedCreateCommand: TDBXCommand; virtual; abstract;
    procedure DerivedOpen(); virtual; abstract;
    procedure DerivedGetCommandTypes(List: TWideStrings); virtual; abstract;
    procedure DerivedGetCommands(CommandType: WideString; List: TWideStrings); virtual; abstract;

    constructor Create(ConnectionBuilder:  TDBXConnectionBuilder);

  public
    destructor Destroy; override;

    ///<remarks>
    ///  When the work for the transaction is complete, call <c>CommitAndFree</c>,
    ///  <c>RollbackAndFree</c>, or <c>RollbackIncompleteAndFree</c>.
    ///</remarks>
    ///<returns> <c>TDBXTransaction</c> instance for the new transaction</returns>
    function  BeginTransaction(Isolation: TDBXIsolation): TDBXTransaction; overload; virtual;
    ///<remarks>
    ///  When the work for the transaction is complete, call <c>CommitAndFree</c>,
    ///  <c>RollbackAndFree</c>, or <c>RollbackIncompleteAndFree</c>.
    ///</remarks>
    ///<returns> <c>TDBXTransaction</c> instance for the new transaction</returns>
    function  BeginTransaction: TDBXTransaction; overload; virtual;
    ///<summary>
    ///  Commits the work for the <c>Transaction</c>.  Any active transactions
    ///  that were begun after this transaction will be freed and effectively
    ///  committed as well.  The var <c>Transaction</c> instance is set to nil.
    ///</summary>
    ///<exception>Raises an exception if <c>Transaction</c> is not an active transaction</exception>
    procedure CommitFreeAndNil(var Transaction: TDBXTransaction); virtual;
    ///<summary>
    ///  Rollbacks the work for the <c>Transaction</c>.  Any active transactions
    ///  that were begun after this transaction will be freed and effectively
    ///  rolledback as well.  The var <c>Transaction</c> instance is set to nil.
    ///</summary>
    ///<exception>Raises an exception if <c>Transaction</c> is not an active transaction</exception>
    procedure RollbackFreeAndNil(var Transaction: TDBXTransaction); virtual;
    ///<remarks>
    ///  Unlike <c>RollbackFreeAndNil</c> procedure, this procedure does not
    ///  throw an exception if <c>Transaction</c> is invalid or set to nil.
    ///  This method is ideally used in a finally (or except) block.  The try block will
    ///  use either <c>CommitFreeAndNil</c> or <c>RollbackFreeAndNil</c>,
    ///  the <c>Transaction</c> will have already been completed, freed
    ///  and set to nil.  If an exception is not raised in the try block,
    ///  a call to <c>RollbackIncompleteAndFree</c> in the finally block
    ///  will do nothing because the <c>Transaction</c> instance is no longer
    ///  valid.  If an exception is raised, then a call to <c>RollbackIncompleteAndFree</c>
    ///  in the finally block will rollback, free and nill the <c>Transaction</c>
    ///  instance.
    ///</remarks>
    ///<summary>
    ///  Rollbacks the work for the <c>Transaction</c>.  Any active transactions
    ///  that were begun after this transaction will be freed and effectively
    ///  rolledback as well.  The var <c>Transaction</c> instance is set to nil.
    ///</summary>
    procedure RollbackIncompleteFreeAndNil(var Transaction: TDBXTransaction); virtual;

    ///<remarks>
    ///  Default <c>CommandType</c> property setting is <c>TDBXCommandTypes.SQLStatement</c>.
    ///  Call <c>Free</c> when the <c>TDBXCommand</c> is no longer needed.
    ///</remarks>
    ///<returns>A <c>TDBXCommand</c> that can be used to execute commands.</returns>
    function CreateCommand: TDBXCommand; overload; virtual;
    ///<summary>
    ///  Populates the list will the supported command types for this connection.
    ///  <c>TDBXCommandTypes</c> provides constant names for the most common
    ///  command types.
    ///</summary>
    procedure GetCommandTypes(List: TWideStrings); overload;
{$IF NOT DEFINED(CLR)}
    ///<summary>
    ///  Populates the list will the supported command types for this connection.
    ///  <c>TDBXCommandTypes</c> provides constant names for the most common
    ///  command types.
    ///</summary>
    procedure GetCommandTypes(List: TStrings); overload;
{$IFEND}
    ///<summary>
    ///  Populates the list with the known commands for <c>CommandType</c>
    ///</summary>
    procedure GetCommands(const CommandType: WideString; List: TWideStrings); overload;
{$IF NOT DEFINED(CLR)}
    ///<summary>
    ///  Populates the list with the known commands for <c>CommandType</c>
    ///</summary>
    procedure GetCommands(const CommandType: WideString; List: TStrings); overload;
{$IFEND}
    ///<returns>
    ///  <c>TDBXProperties</c> containing connection properties used to create
    /// this connection.
    ///</returns>
    property ConnectionProperties: TDBXProperties read GetConnectionProperties write SetConnectionProperties;
    ///<returns>
    ///  <c>TDBXDatabaseMetaData</c> instance for this connection.
    ///</returns>
    property DatabaseMetaData: TDBXDatabaseMetaData read GetDatabaseMetaData;
    ///<returns>
    ///  Event handler used for receiving trace events.
    ///</returns>
    property OnTrace: TDBXTraceEvent read GetTraceInfoEvent write SetTraceInfoEvent;
    ///<returns>
    ///  Trace flags that can be used to enable or disable tracing categories.
    ///</returns>
    property TraceFlags: TDBXTraceFlag read GetTraceFlags write SetTraceFlags;
    ///<returns>
    ///  Error handling event that will be called just before any DBX
    ///  <c>TDBXError</c> exception is raised.
    ///</returns>
    property OnErrorEvent: TDBXErrorEvent read GetErrorEvent write SetErrorEvent;
    ///<returns>
    ///  Is this connection open.
    ///</returns>
    property IsOpen: Boolean read GetIsOpen;

  end;

  TDBXConnectionEx = class(TDBXConnection)
  private
    FProductVersion:                WideString;
    FProductVersionInitialized:     Boolean;
    FMetaDataReader:                TObject;
  protected

    function  CreateMorphCommand(MorphicCommand: TDBXCommand): TDBXCommand; virtual;
    ///<summary>
    ///  Drivers should return an empty string if this is not implemented.
    ///  Otherwise the return value should be in the format specified
    ///  in the documentation for <c>TDBXConnection.ProductVersion</c>
    ///  This property can also be overriden by setting the
    ///  <c>TDBXPropertyNames.ProductVersion</c> connection property.
    ///  <seealso>
    ///  <c>TDBXDatabaseMetadata.ProductVersion</c>  This is the method applications
    ///  should use to obtain the product version.
    ///  </seealso>
    ///  </summary>
    function GetProductVersion: WideString; virtual;

    function GetProductName: WideString; virtual;

    function GetConnectionProperty(const Name: WideString): WideString; virtual;

  public
    destructor Destroy; override;

    ///  <summary
    ///  Driver vendors can implement this method to provide driver specific
    ///  property access.  Returns an empty string if not implemented.
    ///  Currently used by <c>GetProductVersion</c> to obtain the product
    ///  version.
    ///  </summary>
    function GetVendorProperty(const Name: WideString): WideString; virtual;
    ///  <summary
    ///  Return empty string if not implemented.  Otherwise a
    ///  string is returned with the format ##.##.#### where the first two digits are
    ///  the major version, the second two digits are the minor version,
    ///  and the last four digits are the release version.  This value
    ///  can be overridden by setting the <c>TDBXPropertyNames.ProductVersion</c>
    ///  connection property.
    ///  </summary>
    property ProductVersion: WideString read GetProductVersion;
    ///<summary>
    ///  Provide product name if supported.
    /// The default implementation will look at the <c>TDBXPropertyNames.ProductName</c>
    /// driver property first.  It will Call <c>GetVendorProperty</c> second.
    /// <c>TDBXPropertyNames.DriverName</c> property will be used as a last resort.
    ///  </summary>
    property ProductName: WideString read GetProductName;

    property ConnectionProperty[const Name: WideString]: WideString read GetConnectionProperty;

    property MetaDataReader: TObject read FMetaDataReader write FMetaDataReader;
  end;


  ///<summary>
  ///  A <c>TDBXTransaction</c> is created by calling <c>TDBXConnection.BeginTransaction</c>
  ///  <c>TDBXConnection.CommitFreeAndNil</c>, <c>TDBXConnection.RollbackFreeAndNil,
  ///  or <c>TDBXConnection.RollbackIncompleteFreeAndNil must be called to complete
  ///  a transaction.  The <c>TDBXIsolation</c> transaction isoaltion level can be set
  ///  when the transaction is begun.  <c>TDBXConnection.TDBXDatabaseMetadata.SupportsTransactions</c>
  ///  must be true for an application to be able to use transactions.
  ///  Nested transactions can be used if <c>TDBXConnection.TDBXDatabaseMetadata.SupportsTransactions</c>
  ///  is true.
  ///</summary>
  TDBXTransaction = class
    private
      FNext:        TDBXTransaction;
      FConnection:  TDBXConnection;
    strict protected
      FIsolationLevel:    TDBXIsolation;
    protected
      constructor Create(Connection:  TDBXConnection);
    public
      destructor Destroy(); override;
  ///<returns>
  ///  The <c>TDBXConnection</c> instance that created this <c>TDBXTransaction</c> instance.
  ///</returns>
    property Connection: TDBXConnection read FConnection;
  end;

  ///<summary>
  ///  <c>TDBXDatabaseMetadata</c> provides convenient access to common
  ///  database specific metadata.  This metadata can also be retrieved
  ///  by creating a <c>TDBXCommand</c> with a <c>TDBXCommandType.DbxMetadata</c>
  ///  setting the <c>TDBXCommand.Text</c> property to 'GetDatabase' and then
  ///  calling <c>TDBXCommand.ExecuteQuery</c>.  For most applications it is
  ///  more efficient to retrieve this metadata from <c>TDBXDatabaseMetaData</c>
  ///  because <TDBXDatabaseMetadata</c> executes the 'GetDatabase' command once
  ///  and caches the retrieved metadata.
  ///</summary>
  TDBXDatabaseMetaData = class
    private
    FQuoteChar:                     WideString;
    FProcedureQuoteChar:            WideString;
    FSupportsTransactions:          Boolean;
    FSupportsNestedTransactions:    Boolean;
    FMaxCommands:                   TInt32;
    FSupportsRowSetSize:            Boolean;

    procedure Init(Connection: TDBXConnection);

  protected
    FDBXContext:           TDBXContext;
    constructor Create(DBXContext: TDBXContext);
  public

    ///<summary>
    ///  deprecated.  Use <c>QuotePrefix</c> and <c>QuoteSuffix</c>
    ///</summary>
    ///<returns>Quote character used for quoting identifiers in the TDBXCommand.Text property.</returns>
    property QuoteChar: WideString read FQuoteChar;
    ///<returns>Quote character used for quoting identifiers for stored procedures in the TDBXCommand.Text property.</returns>
    property ProcedureQuoteChar: WideString read FProcedureQuoteChar;
    ///<returns>Does the driver support transactions.</returns>
    property SupportsTransactions: Boolean read FSupportsTransactions;
    ///<returns>Does the driver support nested transactions.</returns>
    property SupportsNestedTransactions: Boolean read FSupportsNestedTransactions;
    ///<returns>Maximum number of commands that can be created.</returns>
    property MaxCommands: TInt32 read FMaxCommands;
    ///<returns>Is <c>TDBXCommand.RowSetSize</c> property supported to control row buffering when executing queries.</returns>
    property SupportsRowSetSize: Boolean read FSupportsRowSetSize;
  end;

  TDBXDatabaseMetaDataEx = class(TDBXDatabaseMetaData)
  private
    FQuotePrefix:                   WideString;
    FQuoteSuffix:                   WideString;
    FSupportsLowerCaseIdentifiers:  Boolean;
    FSupportsUpperCaseIdentifiers:  Boolean;
    FMetaDataVersion:               String;
  protected
    constructor Create(DBXContext: TDBXContext);
  public
    ///<returns>Character to start a quoted identifier.</returns>
    property QuotePrefix: WideString read FQuotePrefix;
    ///<returns>Character to end a quoted identifier.</returns>
    property QuoteSuffix: WideString read FQuoteSuffix;
    ///<returns>Lowercase identifiers are stored in lowercase characters on the database.</returns>
    property SupportsLowerCaseIdentifiers: Boolean read FSupportsLowerCaseIdentifiers;
    ///<returns>Uppercase identifiers are stored in uppercase characters on the database.</returns>
    property SupportsUpperCaseIdentifiers: Boolean read FSupportsUpperCaseIdentifiers;
    ///<returns>Returns DBX version of metadata supported.
    ///Curently this value is either <c>DBXVersion30</c> or <c>DBXVersion40</c>.
    ///</returns>
    property MetaDataVersion: String read FMetaDataVersion;
  end;

  ///<summary>
  ///  <c>TDBXCommand</c> is typically used to execute sql statements and
  ///  stored procedures.  The desired command to execute is specfied with
  ///  the <c>TDBXCommand.Text</c> property.  Parameters can be added and
  ///  accessed through the <c>TDBXCommand.Parameters</c> property.
  ///  Parameters can be created by calling the <c>TDBXCommand.CreateParameter</c> method.
  ///  <c>TDBXCommand</c> can alo be used to execute other types of commands.
  ///  <c>TDBXCommandTypes</c> contains constants for common command types.
  ///  Because the command type is represented as a String, Driver implementations
  ///  can use this as a namespace to create additional types of commands.
  ///  For example, the <c>TDBXPool</c> delegate driver has a command type that allows
  ///  a command to return a <c>TDBXReader</c> with information on the
  ///  active connection pools.
  ///  <c>TDBXCommand</c> instances can be created by calling one of the
  ///  <c>TDBXConnection.CreateCommand</c> methods.  As soon as an application
  ///  is finished using a command, the <c>TDBXCommand.Free</c> method
  ///  must be called.  This will release the memory for the command and
  ///  any associated resources.
  ///</summary>
  TDBXCommand = class
  private
    FCommandType:     WideString;
    FText:            WideString;
    FLastReader:      TDBXReader;
    FOpen:            Boolean;
    FPrepared:        Boolean;

    procedure         CommandExecuting;
    procedure         CommandExecuted;
    procedure         SetParameters;
    procedure         CloseReader;

  strict protected
    FParameters:      TDBXParameterList;

    procedure NotImplemented;

  protected
    FDBXContext: TDBXContext;

    constructor Create(DBXContext: TDBXContext);
    procedure SetCommandType(const CommandType: WideString); virtual;
    function  GetCommandType: WideString; virtual;
    function  GetText: WideString; virtual;
    procedure SetText(const Value: WideString); virtual;

    procedure SetRowSetSize(const RowSetSize: Int64); virtual; abstract;
    procedure SetMaxBlobSize(const MaxBlobSize: Int64); virtual; abstract;
    function  GetRowsAffected: Int64; virtual; abstract;

    function  GetErrorEvent: TDBXErrorEvent; virtual;
    function  CreateParameterRow: TDBXRow; virtual;
    procedure CreateParameters(Command: TDBXCommand); virtual;
    function  GetParameters: TDBXParameterList; virtual;
    procedure Open; virtual;
    procedure Close; virtual;

    function  DerivedGetNextReader: TDBXReader; virtual; abstract;
    procedure DerivedOpen; virtual; abstract;
    procedure DerivedClose; virtual; abstract;
    procedure DerivedPrepare; virtual; abstract;
    function  DerivedExecuteQuery: TDBXReader; virtual; abstract;
    procedure DerivedExecuteUpdate; virtual; abstract;

  public

    destructor Destroy; override;

    ///<summary>
    ///  This method should be called before calling any of the <c>Execute*</c>
    ///  methods.
    ///</summary>
    procedure Prepare; virtual;
    ///<summary>
    ///  Executes a command that returns an instance of <c>TDBXReader</c>.
    ///  methods.  As soon as an application is done with a reader, the
    ///  <c>TDBXReader.Free</c> method should be called to free up resources.
    ///</summary>
    function  ExecuteQuery: TDBXReader; virtual;
    ///<summary>
    ///  Executes a command that performs an update operation.
    ///</summary>
    procedure ExecuteUpdate; virtual;
    ///<summary>
    ///  For commands that return more then one reader.
    ///</summary>
    ///<returns>The next instance of <c>TDBXReader</c>.  If there are no more <c>TDBXReader</c> instances, nil is returned.</returns>
    function  GetNextReader: TDBXReader; virtual;
    ///<summary>
    ///  Create a parameter that can be added to the <c>Parameters</c> list.
    ///</summary>
    ///<returns>Allocates a new instance of <c>TDBXParameter</c>.</returns>
    function  CreateParameter: TDBXParameter; virtual;

    ///<returns>
    /// The number of rows updated from the last call to <c>ExecuteUpdate</c>.
    ///</returns>
    property RowsAffected: Int64 read GetRowsAffected;

    ///<summary>
    ///  command to execute.  when <c>CommandType</c> is set to
    ///  <c>TDBXCommandTypes.SQLStatement</c>, <c>Text</c> can be set to
    ///  sql statements such as select, insert, update, and delete.
    ///</summary>
    property Text: WideString read GetText write SetText;
    ///<summary>
    ///  Row buffering property used to optimize reading data from <c>TDBXReader</c> instances.
    ///  returned from <c>ExecuteQuery</c>
    ///  Only takes affect for database vendors that return true from the
    ///  <c>TDBXDataBaseMetadata.SupportsRowSetSize</c> property.
    ///</summary>
    property RowSetSize: Int64 write SetRowSetSize;
    ///<summary>
    ///  Set the maximum blob size allowed for <c>TDBXReader</c> instances
    ///  returned from <c>ExecuteQuery</c>.
    ///</summary>
    property MaxBlobSize: Int64 write SetMaxBlobSize;
    ///<summary>
    ///  Typically set to one of the constant strings specified in
    ///  <c>TDBXCommandTypes</c>.  However, driver implmentors can
    ///  used this property as a namespace to create new types of commands.
    ///</summary>
    property CommandType: WideString read GetCommandType write SetCommandType;
    ///<summary>
    ///  Get the <c>TDBXParametersList</c> list of parameters that will
    ///  be used to get and set parameters for <c>Text</c> commands that
    ///  contain '?' parameter markers.
    ///</summary>
    property Parameters: TDBXParameterList read GetParameters;
    ///<summary>
    ///  Get the error handling event provide by the <c>TDBXConnection</c>
    ///  that created this command.
    ///</summary>
    property OnErrorEvent: TDBXErrorEvent read GetErrorEvent;
    ///<returns>
    /// true if this has been prepared.
    ///</returns>
    property IsPrepared: Boolean read FPrepared;

  end;
  TDBXCommandEx = class(TDBXCommand)
  private
    FCommandTimeout: Integer;
    procedure SetReader(const Value: TDBXReader);
  strict protected
    procedure SetLastReader(Reader: TDBXReader);
    property LastReader: TDBXReader write SetReader;
  protected
    procedure SetCommandTimeout(Timeout: Integer); virtual;
    function GetCommandTimeout: Integer; virtual;
  public
    /// <summary> Timeout value for the execution of a command.
    ///  </summary>
    ///  <remarks>
    ///  Not all drivers support this.  Time in seconds to wait for
    ///  a command to execute.
    ///  </remarks>
    property CommandTimeout: Integer read GetCommandTimeout write SetCommandTimeout;
  end;


  ///<summary>
  ///  <c>TDBXReader</c> is returned from <c>TDBXCommand.ExecuteQuery</c>.
  ///  <c>TDBXReader</c> provides a forward only cursor throw a collection
  ///  or rows.  Call the <c>TDBXReader.Next</c> method to access the first
  ///  and successive rows in the collection.  When an application is no longer needs a <c>TDBXReader</c> instance
  ///  it should call the <c>TDBXReader.Free</c> method.  This will ensure that all resources associated
  ///  with the <c>TDBXReader</c> are released.
  ///  <para>
  ///  Row values can be accessed using the <c>TDBXReaderValue</c> array property.
  ///  This <c>TDBXReader.Value</c> property is overloaded so that it can be
  ///  indexed either by ordinal position or by column name.
  ///  </para>
  ///</summary>
TDBXReader = class
  private
    FValues:      TDBXValueArray;
    FValueCount:  TInt32;
    FByteReader:  TDBXByteReader;
    FClosed:      Boolean;
    FLastOrdinal: TInt32;
    FCommand:   TDBXCommand;


    function FindOrdinal(const Name: WideString; const StartOrdinal, EndOrdinal: TInt32): TInt32; overload; virtual;
    procedure InvalidOrdinal(const Ordinal: TInt32);
    procedure InvalidName(const Name: WideString; const Ordinal: TInt32);
    procedure   Close;

  strict protected
    FDbxRow:      TDBXRow;
    FDBXContext:  TDBXContext;

    procedure FailIfClosed;
    function  GetErrorEvent: TDBXErrorEvent;

  protected
    constructor Create(DBXContext: TDBXContext; DbxRow: TDBXRow; ByteReader: TDBXByteReader);
    procedure SetValues(Values: TDBXValueArray); virtual;

    function GetValue(const Ordinal: TInt32): TDBXValue; virtual;
    function GetValueByName(const Name: WideString): TDBXValue; virtual;
    function GetValueType(const Ordinal: TInt32): TDBXValueType; virtual;

    function  DerivedNext: Boolean; virtual; abstract;
    procedure DerivedClose; virtual; abstract;

    function GetByteReader: TDBXByteReader; virtual;

    function GetColumnCount: TInt32; virtual;

  public
    destructor Destroy; override;

    ///<summary>
    ///  This method must be called to navigate to the first and successive
    ///  rows.
    ///  <returns>false then there are no more rows</returns>
    ///</summary>
    function Next: Boolean; virtual;

    ///<returns>
    ///  Return the object type name for ADT and Array Types.
    ///  The Oracle driver supports these data types.
    ///</returns>
    function GetObjectTypeName(Ordinal: TInt32): WideString; virtual;

    ///  <returns>Ordinal position in the <c>Value</c> array property for the <c>Name</c> column.</returns>
    function GetOrdinal(const Name: WideString): TInt32; overload; virtual;
    ///  <returns>Ordinal position in the <c>Value</c> array property for the <c>Name</c> column.</returns>
//    function GetOrdinal(Name: String): TInt32; overload; virtual;

    ///<summary>
    ///  Must call <c>Next</c> at least once for this property to
    ///  return a meaningful result.
    ///  <returns>true if there are no more rows</returns>
    ///</summary>
    property Closed: Boolean read FClosed;
    ///<summary>
    ///  Used by TDataSet to read values from a byte array instead
    ///  of as distinct scalar values.
    ///  <returns><c>TDBXByteReader</c></returns>
    ///</summary>
    property ByteReader: TDBXByteReader read GetByteReader;
    ///  <returns>Number of columns that can be accessed from the <c>Value</c> array property.</returns>
    property ColumnCount: TInt32 read GetColumnCount;

    ///  <returns><c>TDBXErrorEvent</c> error handling event for this <c>TDBXReader</c>.</returns>
    property OnErrorEvent: TDBXErrorEvent read GetErrorEvent;

    ///  <returns>Returns the instance of <c>TDBXValueType</c> at the <c>Ordinal</c> position.</returns>
    property ValueType[const Ordinal: TInt32]: TDBXValueType read GetValueType;
//    property ValueType[const Name: WideString]: TDBXValueType read GetValueTypeByName; overload;

    ///  <returns>Returns the instance of <c>TDBXValue</c> at the <c>Ordinal</c> position.</returns>
    property Value[const Ordinal: TInt32]: TDBXValue read GetValue; default;
    ///  <returns>Returns the instance of <c>TDBXValue</c> at the <c>Name</c> position.</returns>
    property Value[const Name: WideString]: TDBXValue read GetValueByName; default;

  end;


  ///<summary>
  ///  Metadata for TDBXReader columns and TDBXParameter parameters.
  ///</summary>
  TDBXValueType = class
    private
      FName:                WideString;
      FOrdinal:             TInt32;
      FDataType:            TDBXType;
      FSubType:             TDBXType;
      FSize:                Int64;
      FPrecision:           Int64;
      FScale:               TInt32;
      FChildPosition:       TInt32;
      FFlags:               TInt32;
      FParameterDirection:  TDBXParameterDirection;

    private
      FDbxRow:            TDBXRow;

      function IsNullable: Boolean;
      function IsReadOnly: Boolean;
      function IsSearchable: Boolean;
      function IsAutoIncrement: Boolean;
//      function IsBlobSizeExact: Boolean;
      function IsReadOnlyType: Boolean;

    strict protected
      FDBXContext:        TDBXContext;


    protected

      procedure SetParameterDirection(ParameterDirection: TDBXParameterDirection); virtual;

      procedure SetName(const Name: WideString); virtual;
      procedure SetOrdinal(Ordinal: TInt32); virtual;
      procedure SetDataType(DataType: TDBXType); virtual;
      procedure SetSubType(SubType: TDBXType); virtual;
      procedure SetPrecision(Precision: Int64); virtual;
      procedure SetScale(Scale: TInt32); virtual;
      procedure SetChildPosition(ChildPosition: TInt32); virtual;
      procedure SetFlags(Flags: TInt32); virtual;
      procedure SetNullable(NullableValue: Boolean); virtual;
      procedure SetSize(Size: Int64); virtual;

      function  GetParameterDirection: TDBXParameterDirection; virtual;
      function  GetName: WideString; virtual;
      function  GetOrdinal: TInt32 ; virtual;
      function  GetDataType: TDBXType; virtual;
      function  GetSubType: TDBXType; virtual;
      function  GetPrecision: Int64; virtual;
      function  GetScale: TInt32; virtual;
      function  GetChildPosition: TInt32; virtual;
      function  GetFlags: TInt32; virtual;
      function  GetSize: Int64; virtual;

    private
      FModified:          Boolean;


      procedure FailIfReadOnly;
      procedure FailIfReadOnlyType;
      // Once set, this should never be possible to unset.
      // Used by values that belong to a reader.
      //
      procedure SetReadOnlyType;

      property DBXContext: TDBXContext read FDBXContext;

  protected
      constructor Create(DBXContext: TDBXContext);

  public


    ///<returns>
    ///  Name for this value.  This value can be used as an index
    ///  TDBXReader.Value and TDBXParameterList.Parameter array properties.
    ///</returns>
    property Name: WideString read FName write SetName;
    ///<returns>
    ///  Value data type.  Returns one of the const values from TDBXDataTypes.
    ///</returns>
    property DataType: TDBXType read GetDataType write SetDataType;
    ///<returns>
    ///  Ordinal position of this value for a TDBXReader or TDBXParameterList.
    ///</returns>
    property Ordinal: TInt32 read GetOrdinal write SetOrdinal;
    ///<returns>
    ///  Value sub type.  Returns one of the "sub type" const values from TDBXDataTypes.
    ///</returns>
    property SubType: TInt32 read GetSubType write SetSubType;
    ///<returns>
    ///  The maximum number of digits allowed in the parameter, including both significant
    ///  and fractional.
    ///</returns>
    property Precision: Int64 read GetPrecision write SetPrecision;
    ///<returns>
    ///  Gets or sets the maximum number of digits used to represent the Value property.
    ///</returns>
    property Scale: TInt32 read GetScale write SetScale;
    ///<returns>
    ///  Used by TDBXParameter instances.  Child position of Oracle ADT and Array types
    ///</returns>
    property ChildPosition: TInt32 read GetChildPosition write SetChildPosition;
    ///<returns>
    ///  Used by drivers to set TDBXValue metadata for TDBXReaders.
    ///</returns>
    property ValueTypeFlags: TInt32  read GetFlags write SetFlags;
    ///<returns>
    ///  Gets and sets the size of the parameter value in bytes.
    ///  For string data this gets or sets the size of the parameter in characters.
    ///</returns>
    property Size: Int64  read GetSize write SetSize;

    ///<returns>
    ///  Gets or sets the value that determines whether or not a value can be set to null.
    ///</returns>
    property Nullable: Boolean read IsNullable write SetNullable;
    ///<returns>
    ///  Gets or sets the value that determines whether or this value can be set.
    ///</returns>
    property ReadOnly: Boolean read IsReadOnly;
    ///<returns>
    ///  Gets or sets the value that determines whether or this value is searchable.
    ///</returns>
    property Searchable: Boolean read IsSearchable;
    ///<returns>
    ///Gets or sets the value that determines whether or not this is an autoincrement value
    ///</returns>
    property AutoIncrement: Boolean read IsAutoIncrement;
//    property BlobSizeExact: Boolean read IsBlobSizeExact;
    ///<returns>
    ///  Gets or sets the direction of a parameter.  This parameter can be set to one
    ///  of the TDBXParameterDirections const values.
    ///</returns>
    property ParameterDirection: TDBXParameterDirection read GetParameterDirection write SetParameterDirection;

  end;

  TDBXValueTypeEx = class(TDBXValueType)
    class function DataTypeName(DataType: TDBXType): WideString; static;
    class procedure InvalidTypeAccess(ExpectedDataType, DataType: TDBXType); static;
  end;

  ///<summary>
  ///  <c>TDBXParameter</c> should be created by calling <c>TDBXCommand.CreateParameter</c>
  ///  for each "?" parameter marker specfied in the <c>TDBXCommand.Text</c>
  ///  property.  Once a <c>TDBXParameter</c> is created, it must be added to
  ///  a <c>TDBXCommand</c> parameter list by calling <c>TDBXCommand.Parameters.AddParameter</c> method.
  ///</summary>
  TDBXParameter = class(TDBXValueType)
    private
//      FDbxContext:            TDBXContext;
      FValue:                 TDBXWritableValue;
      procedure UpdateParameterType(SetDataType: TDBXType);
    protected
      constructor Create(DbxContext: TDBXContext);
      procedure SetDbxRow(DbxRow: TDBXRow); virtual;
      function  GetValue: TDBXWritableValue; virtual;
      procedure SetParameter; virtual;
    public
      destructor Destroy; override;
      ///<returns>Returns a <c>TDBXWritableValue</c> instance that can be used to read and write parameter values.</returns>
      property Value: TDBXWritableValue read GetValue;
  end;

  TDBXParameterEx = class(TDBXParameter)
    private
      procedure CopyByteValue(Source: TDBXValue; Dest: TDBXWritableValue);
      procedure AssignValue(Source: TDBXValue);
    public
      ///<summary>Copies field values from Source into this object.
      ///  </summary>
      procedure Assign(Source: TDBXParameter); virtual;
      ///<summary>
      /// Creates a new parameter instance with the same field values as
      /// this object has.
      ///  </summary>
      function Clone: TObject; virtual;
  end;



  ///<summary>
  ///  The <c>TDBXCommand.Parameters</c> property returns an instance of <c>TDBXParameterList</c>
  ///  The <c>TDBXParameterList</c> manages a collection of <c>TDBXParameter</c>
  ///  instances that can be used to get and set parameters for a <c>TDBXCommand</c>.
  ///  The lifetime of all <c>TDBXParameter</c> instances added to this list will
  ///  be managed by this list.  So when <c>TDBXParameterList.Free</c> is called,
  ///  <c>TDBXParameter.Free</c> will also be called for all items in the list.
  ///</summary>
  TDBXParameterList = class
    private
      FValueTypes:    TDBXValueList;
      FCommand:       TDBXCommand;
      FParameterRow:  TDBXRow;

      function GetParameterByName(const Name: WideString): TDBXParameter;
      procedure InvalidOrdinal(Ordinal: TInt32);


    protected
      FDBXContext:    TDBXContext;

      constructor Create(DBXContext: TDBXContext; Command: TDBXCommand);
      function GetParameterByOrdinal(const Ordinal: TInt32): TDBXParameter; virtual;
      function GetCount: TInt32; virtual;


    public
      destructor  Destroy; override;

      ///<summary>
      ///  Set the length of the list to <c>Count</c> size.  If this grows the list,
      ///  new items will be set to null.  If this shrinks the list, items
      ///  beyond the new length will be released by calling the <c>Free</c> method.
      ///</summary>
      procedure   SetCount(Count: TInt32); virtual;
      ///<summary>
      ///  Add a <c>TDBXParameter</c> instance to this list.
      ///</summary>
      procedure   AddParameter(Parameter: TDBXParameter); virtual;
      ///<summary>
      ///  Add a <c>TDBXParameter</c> instance to this list at the <c>Ordinal</c> position.
      ///</summary>
      procedure   SetParameter(Ordinal: Integer; Parameter: TDBXParameter); virtual;
      ///<summary>
      ///  Insert a <c>TDBXParameter</c> instance to this list at the <c>Ordinal</c> position.
      ///</summary>
      procedure   InsertParameter(Ordinal: Integer; Parameter: TDBXParameter); virtual;
      ///<summary>
      ///  Remove the <c>TDBXParameter</c> instance from this list at the <c>Ordinal</c> position.
      ///  The <c>Free</c> method will be called for the removed parameter.
      ///</summary>
      procedure   RemoveParameter(Ordinal: Integer); overload; virtual;
      ///<summary>
      ///  Remove the <c>TDBXParameter</c> instance from this list.
      ///  The <c>Free</c> method will be called for the removed parameter.
      ///</summary>
      procedure   RemoveParameter(Parameter: TDBXParameter); overload; virtual;
      ///<summary>
      ///  Remove and and call <c>Free</c> for all parameters.
      ///</summary>
      procedure   ClearParameters; overload; virtual;

      ///<returns>
      ///  The ordinal for the <c>Name</c>parameter.
      ///</returns>
      function    GetOrdinal(const Name: WideString): Integer; virtual;
      ///<returns>
      ///  The number of parameters in this list.
      ///</returns>
      property    Count: TInt32 read GetCount;
      ///<returns>
      ///  <c>TDBXParameter</c> instance at the <c>Ordinal</c> postion in the list.
      ///</returns>
      property    Parameter[const Ordinal: TInt32]: TDBXParameter read GetParameterByOrdinal; default;
      ///<returns>
      ///  <c>TDBXParameter</c> instance that has the <c>Name</c> property provided.
      ///</returns>
      property    Parameter[const Name: WideString]: TDBXParameter read GetParameterByName; default;
  end;


  ///<summary>
  ///  This class is to get and set values for both TDBXReader.Value and
  ///  TDBXParameterList.Value properties.
  ///</summary>
  TDBXValue = class
    private
      FValueType:       TDBXValueType;
      FDbxRow:          TDBXRow;
      FGeneration:      TInt32;
      FIsNull:          LongBool;
      FOwnsType:        Boolean;

      procedure InvalidOperation; virtual;

    protected
      constructor Create(ValueType: TDBXValueType);
      function GetDbxContext: TDBXContext;
      property DbxContext: TDBXContext read GetDbxContext;

    public
      destructor Destroy(); override;

      ///<summary>
      ///  This class is to get and set values for both TDBXReader.Value and
      ///  TDBXParameterList.Value properties.
      ///</summary>
      class function CreateValue(DBXContext: TDBXContext; ValueType: TDBXValueType; DbxRow: TDBXRow; ReadOnlyType: Boolean): TDBXValue;

      ///<summary>
      ///  Returns true if the value is null.  This method should be called
      ///  before calling any of the TDBXValue.Get methods.  If the value
      ///  is null, the TDBXValue.Get methods will throw an TDBXError
      ///  exception if they are called.
      ///</summary>
      function IsNull: Boolean; virtual; abstract;

      ///<summary>
      ///  Gets the size in bytes for a TDBXValue.  For string TDBXDataTypes
      ///  the number of characters is returned.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetValueSize: Int64; virtual;
      ///<summary>
      ///  Gets the String value for TDBXValues with a TDBXDataType of TDBXDataTypes.AnsiStringType.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetAnsiString: String; virtual;
      ///<summary>
      ///  Gets the TDBXDate value for TDBXValues with a TDBXDataType of TDBXDataTypes.DateType.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetDate: TDBXDate; virtual;
      ///<summary>
      ///  Gets the Boolean value for TDBXValues with a TDBXDataType of TDBXDataTypes.BooleanType
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetBoolean: Boolean; virtual;
      ///<summary>
      ///  Gets the TDBXTime value for TDBXValues with a TDBXDataType of TDBXDataTypes.TimeType.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetTime: TDBXTime; virtual;
      ///<summary>
      ///  Gets the WideString value for TDBXValues with a TDBXDataType of TDBXDataTypes.WideString.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetWideString: WideString; virtual;
      ///<summary>
      ///  Gets the SmallInt value for TDBXValues with a TDBXDataType of TDBXDataTypes.Int16Type.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetInt16: SmallInt; virtual;
      ///<summary>
      ///  Gets the TInt32 value for TDBXValues with a TDBXDataType of TDBXDataTypes.Int32Type.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetInt32: TInt32; virtual;
      ///<summary>
      ///  Gets the Int64 value for TDBXValues with a TDBXDataType of TDBXDataTypes.Int64Type.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetInt64: Int64; virtual;
      ///<summary>
      ///  Gets the Double value for TDBXValues with a TDBXDataType of TDBXDataTypes.DoubleType.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetDouble: Double; virtual;
      ///<summary>
      ///  Gets the byte array value for TDBXValues with a TDBXDataType of TDBXDataTypes.BytesType
      ///  and TDBXDataType.BlobType.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetBytes(Offset: Int64; const Buffer: TBytes; BufferOffset, Length: Int64): Int64; overload; virtual;
      ///<summary>
      ///  Gets the TSQLTimeStamp value for TDBXValues with a TDBXDataType of TDBXDataTypes.TimeStampType.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetTimeStamp: TSQLTimeStamp; virtual;
      ///<summary>
      ///  Gets the TBcd value for TDBXValues with a TDBXDataType of TDBXDataTypes.BcdType.
      ///  Throws an TDBXError exception if TDBXValue.IsNull is true.
      ///</summary>
      function GetBcd: TBcd; virtual;
      ///<summary>
      ///  Gets the TDBXValueType for this TDBXValue.
      ///</summary>
      property ValueType: TDBXValueType read FValueType;
  end;

  ///<summary>
  ///  Extension of TDBXValue that adds the ability to set a value.
  ///  This is only used by TDBXParameter.Value.  TDBXReader.Value array
  ///  property uses the readonly TDBXValue.
  ///</summary>
  TDBXWritableValue = class(TDBXValue)
    private
      FSetPending:      Boolean;

      procedure UpdateType; virtual;
      procedure SetRowValue; virtual;


    protected
      constructor Create(ValueType: TDBXValueType);
      procedure SetPendingValue; virtual;

    public

      destructor Destroy(); override;

      ///<summary>
      ///  Sets a TDBXWritable of any type to null.
      ///</summary>
      procedure SetNull; virtual;
      ///<summary>
      ///  Sets the TSQLTimeStamp Value for TDBXValues with a TDBXDataType of TDBXDataTypes.TimeStampType.
      ///</summary>
      procedure SetTimeStamp(const Value: TSQLTimeStamp); virtual;
      ///<summary>
      ///  Sets the TBcd Value for TDBXValues with a TDBXDataType of TDBXDataTypes.BcdType.
      ///</summary>
      procedure SetBcd(const Value: TBcd); virtual;
      ///<summary>
      ///  Sets the String Value for TDBXValues with a TDBXDataType of TDBXDataTypes.AnsiStringType.
      ///</summary>
      procedure SetAnsiString(const Value: String); virtual;
      ///<summary>
      ///  Sets the Boolean Value for TDBXValues with a TDBXDataType of TDBXDataTypes.BooleanType.
      ///</summary>
      procedure SetBoolean(Value: Boolean); virtual;
      ///<summary>
      ///  Sets the TDBXDate Value for TDBXValues with a TDBXDataType of TDBXDataTypes.DateType.
      ///</summary>
      procedure SetDate(Value: TDBXDate); virtual;
      ///<summary>
      ///  Sets the TDBXTime Value for TDBXValues with a TDBXDataType of TDBXDataTypes.TimeType.
      ///</summary>
      procedure SetTime(Value: TDBXTime); virtual;
      ///<summary>
      ///  Sets the WideString Value for TDBXValues with a TDBXDataType of TDBXDataTypes.WideString.
      ///</summary>
      procedure SetWideString(const Value: WideString); virtual;
      ///<summary>
      ///  Sets the SmallInt Value for TDBXValues with a TDBXDataType of TDBXDataTypes.WideStringType.
      ///</summary>
      procedure SetInt16(Value: SmallInt); virtual;
      ///<summary>
      ///  Sets the TInt32 Value for TDBXValues with a TDBXDataType of TDBXDataTypes.Int32Type.
      ///</summary>
      procedure SetInt32(Value: TInt32); virtual;
      ///<summary>
      ///  Sets the Int64 Value for TDBXValues with a TDBXDataType of TDBXDataTypes.Int64Type.
      ///</summary>
      procedure SetInt64(Value: Int64); virtual;
      ///<summary>
      ///  Sets the Double Value for TDBXValues with a TDBXDataType of TDBXDataTypes.DoubleType.
      ///</summary>
      procedure SetDouble(Value: Double); virtual;
      ///<summary>
      ///  Sets the open array Value for TDBXValues with a TDBXDataType of TDBXDataTypes.BytesType
      ///  or TDBXTypes.BlobType.
      ///</summary>
      procedure SetStaticBytes( Offset:       Int64;
                          const Buffer: array of Byte;
                          BufferOffset: Int64;
                          Length:       Int64); virtual;
      ///<summary>
      ///  Sets the dynamic array Value for TDBXValues with a TDBXDataType of TDBXDataTypes.BytesType
      ///  or TDBXTypes.BlobType.
      ///</summary>
      procedure SetDynamicBytes( Offset:       Int64;
                          const Buffer:   TBytes;
                          BufferOffset: Int64;
                          Length:       Int64); virtual;

  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for Parameters that have no type.
  ///</summary>
  TDBXNullValue = class(TDBXWritableValue)
    private
    protected
      constructor Create(ValueType: TDBXValueType);
    public
      destructor Destroy; override;
      function IsNull:Boolean; override;
  end;
  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.AnsiStringType</c> values.
  ///</summary>
  TDBXAnsiStringValue = class(TDBXWritableValue)
    private
      FStringBuilder:   TDBXAnsiStringBuilder;
      FString:          String;
      procedure SetRowValue; override;
      procedure UpdateType; override;
    protected
      constructor Create(ValueType: TDBXValueType);
    public
      destructor Destroy; override;
      function IsNull:Boolean; override;
      function GetAnsiString: String; override;
      procedure SetAnsiString(const Value: String); override;
  end;


  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.DateType</c> values.
  ///</summary>
  TDBXDateValue = class(TDBXWritableValue)
    private
      FDate:          TInt32;
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
      function GetDate: TDBXDate; override;
      procedure SetDate(Value: TDBXDate); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.CursorType</c>.
  ///  Used for Oracle drivers to specify that a Reader (Oracle Cursor) will be returned
  ///  from the execution of a stored procedure.
  ///</summary>
  TDBXCursorValue = class(TDBXWritableValue)
    private
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.BooleanType</c> values.
  ///</summary>
  TDBXBooleanValue = class(TDBXWritableValue)
    private
      FBoolean:          LongBool;
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
      function GetBoolean: Boolean; override;
      procedure SetBoolean(Value: Boolean); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.TimeType</c> values.
  ///</summary>
  TDBXTimeValue = class(TDBXWritableValue)
    private
      FTime:          TInt32;
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
      function GetTime: TDBXTime; override;
      procedure SetTime(Value: TDBXTime); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.WideStringType</c> values.
  ///</summary>
  TDBXWideStringValue = class(TDBXWritableValue)
    private
      FWideStringBuilder:   TDBXWideStringBuilder;
      FWideString:          WideString;
      procedure UpdateType; override;
      procedure SetRowValue; override;
    protected
      constructor Create(ValueType: TDBXValueType);
    public
      destructor Destroy; override;
      function IsNull: Boolean; override;
      function GetWideString: WideString; override;
      procedure SetWideString(const Value: WideString); override;
  end;


  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.Int16Type</c> values.
  ///</summary>
  TDBXInt16Value = class(TDBXWritableValue)
    private
      FInt16:     SmallInt;
      procedure SetRowValue; override;
    public
      function GetInt16: SmallInt; override;
      function IsNull: Boolean; override;
      procedure SetInt16(Value: SmallInt); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.Int32Type</c> values.
  ///</summary>
  TDBXInt32Value = class(TDBXWritableValue)
    private
      FInt32:     TInt32;
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
      function GetInt32: TInt32; override;
      procedure SetInt32(Value: TInt32); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.Int64Type</c> values.
  ///</summary>
  TDBXInt64Value = class(TDBXWritableValue)
    private
      FInt64:     Int64;
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
      function GetInt64: Int64; override;
      procedure SetInt64(Value: Int64); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.DoubleType</c> values.
  ///</summary>
  TDBXDoubleValue = class(TDBXWritableValue)
    private
      FDouble:     Double;
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
      function GetDouble: Double; override;
      procedure SetDouble(Value: Double); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.BcdType</c> values.
  ///</summary>
  TDBXBcdValue = class(TDBXWritableValue)
    private
      FBcd: TBcd;
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
      function GetBcd: TBcd; override;
      procedure SetBcd(const Value: TBcd); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.ByteArrayType</c> values.
  ///</summary>
  TDBXByteArrayValue = class(TDBXWritableValue)
    private
      FBytes:         TBytes;
      FByteLength:    Int64;
      FOffset:        Int64;
      FBufferOffset:  Int64;

      procedure SetRowValue; override;
    public
      destructor Destroy; override;
      function IsNull: Boolean; override;
      function GetBytes(Offset: Int64; const Buffer: TBytes; BufferOffset, Length: Int64): Int64; override;
      function GetValueSize: Int64; override;
      procedure SetStaticBytes( Offset:       Int64;
                          const Buffer: array of Byte;
                          BufferOffset: Int64;
                          Length:       Int64); override;
      procedure SetDynamicBytes( Offset:       Int64;
                          const Buffer:   TBytes;
                          BufferOffset: Int64;
                          Length:       Int64); override;
  end;


  ///<summary>
  ///  Used internally by driver implementations and <c>TDBXStreamValue</c>
  ///</summary>
  TDBXStreamReader = class abstract
  public
    function Read(const Buffer: TBytes; Offset: Integer; Size: Integer): Integer; virtual; abstract;
    function Eos: Boolean; virtual; abstract;
    function Size: Int64; virtual; abstract;
  end;
  ///<summary>
  ///  Used internally by driver implementations and <c>TDBXStreamValue</c>
  ///</summary>
  TDBXLookAheadStreamReader = class(TDBXStreamReader)
    private
      FStream:            TStream;
      FEOS:               Boolean;
      FHasLookAheadByte:  Boolean;
      FLookAheadByte:     Byte;
    public
      destructor Destroy; override;
      procedure SetStream(Stream: TStream);
      function Read(const Buffer: TBytes; Offset: Integer; Count: Integer): Integer; override;
      function Eos: Boolean; override;
      function Size: Int64; override;
      function ConvertToMemoryStream: TStream;
  end;
  ///<summary>
  ///  Used internally by driver implementations and <c>TDBXStreamValue</c>
  ///</summary>
  TDBXByteStreamReader = class(TDBXStreamReader)
    FBytes:             TBytes;
    FOffset:            Integer;
    FCount:             Integer;
    FPosition:          Integer;
    FEOS:               Boolean;
    private
    public
      constructor Create(Bytes: TBytes; Offset: Integer; Count: Integer);
      destructor Destroy; override;
      function Read(const Buffer: TBytes; Offset: Integer; Count: Integer): Integer; override;
      function Eos: Boolean; override;
      function Size: Int64; override;
  end;

  ///<summary>
///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.ByteArrayType</c> values.
  ///</summary>
  TDBXStreamValue = class(TDBXByteArrayValue)
    private
      FStreamStreamReader:    TDBXLookAheadStreamReader;
      FByteStreamReader:      TDBXByteStreamReader;
      FExtendedType:          Boolean;

      procedure SetRowValue; override;
    public
      constructor Create(ValueType: TDBXValueType);
      procedure UpdateType; override;
      destructor Destroy; override;
//      function  IsNull: Boolean; override;
      function  GetStream: TStream; virtual;//override;
      function  GetValueSize: Int64; override;
      procedure SetDynamicBytes( Offset:       Int64;
                          const Buffer:   TBytes;
                          BufferOffset: Int64;
                          Count:       Int64); override;
      procedure SetStream(const Stream: TStream); virtual;//override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.WideStringType</c> values.
  ///</summary>
  TDBXWideCharsValue = class(TDBXWideStringValue)
    private
      FCount:               Integer;
      FWideChars:           TDBXWideChars;
      FExtendedType:        Boolean;
      procedure UpdateType; override;
      procedure SetRowValue; override;
    public
      constructor Create(ValueType: TDBXValueType);
      destructor Destroy; override;
      function IsNull: Boolean; override;
      procedure SetWideString(const Value: WideString); override;
      function GetWideString: WideString; override;
      function  GetStream: TStream; virtual;//override;
  end;

  TDBXWideCharsValueEx = class(TDBXWideCharsValue)
    protected
      property WideCharsCount: Integer Read FCount;
      property WideChars: TDBXWideChars read FWideChars;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.TimeStampType</c> values.
  ///</summary>
  TDBXTimeStampValue = class(TDBXWritableValue)
    private
      FTimeStamp: TSQLTimeStamp;
      procedure SetRowValue; override;
    public
      function IsNull: Boolean; override;
      function GetTimeStamp: TSQLTimeStamp; override;
      procedure SetTimeStamp(const Value: TSQLTimeStamp); override;
  end;



  ///<summary>
  ///  A context object mostly of use to DBX driver writers.  Access to a TDBXContext
  ///  instance should not be provided applications using the DBX framework.  The TDBXContext
  ///  contains members that need to be shared across a single TDBXConnection
  ///  and all of the objects such as a TDBXCommand or a TDBXReader.
  ///  All objects created directly or indirectly from a TDBXConnection use
  ///  the same instance of TDBXContext as the TDBXConnection they were created
  ///  by.
  ///</summary>
  TDBXContext = class
    private
      FOnError:               TDBXErrorEvent;
      FOnTrace:               TDBXTraceEvent;
      FTraceFlags:            TDBXTraceFlag;

      FClosedByteReader:      TDBXByteReader;

      procedure SetOnError(const Value: TDBXErrorEvent);
      procedure SetOnTrace(const Value: TDBXTraceEvent);
      procedure SetTraceFlags(const Value: TDBXTraceFlag);

    protected
      FOnErrorDBXContext:     TDBXContext;
      FOnTraceDBXContext:     TDBXContext;

      constructor Create(DBXContext: TDBXContext); overload;
      constructor Create; overload;
    public
      destructor Destroy; override;

      ///<summary>
      ///  Is tracing enabled for the TDBXTraceFlag
      ///</summary>
      function IsTracing(TraceFlags:  TDBXTraceFlag): Boolean;
      ///<summary>
      ///  Call the TDBXTraceEvent handler with TraceFlag and TraceMessage.
      ///</summary>
      function Trace(TraceFlag: TDBXTraceFlag; TraceMessage: WideString): CBRType;
      ///<summary>
      ///  Call hte TDBXErrorEvent with ErrorCode and ErrorMessage.
      ///</summary>
      procedure Error(ErrorCode: TDBXErrorCode; ErrorMessage: WideString);

      ///<summary>
      ///  Get or set the TDBXErrorEvent handler.
      ///</summary>
      property OnError:    TDBXErrorEvent read FOnError write SetOnError;
      ///<summary>
      ///  Get or set the TDBXTraceEvent handler.
      ///</summary>
      property OnTrace:    TDBXTraceEvent read FOnTrace write SetOnTrace;
      ///<summary>
      ///  Get or set the collection of TDBXTraceFlags constants to enable
      ///  tracing for.
      ///</summary>
      property TraceFlags: TDBXTraceFlag read FTraceFlags write SetTraceFlags;
      ///<summary>
      ///  Used by the framework to mark TDBXByteReaders that have no more rows
      ///  as being closed.
      ///</summary>
      property ClosedByteReader: TDBXByteReader read FClosedByteReader;
  end;

  ///<summary>
  ///  Used by dbExpress related TDataSet components.
  ///  Allows for primitive retrieval of data using byte arrays.
  ///  Not for general usage.
  ///</summary>
  TDBXByteReader = class
    strict protected
      FDBXContext: TDBXContext;

    protected
      constructor Create(DBXContext: TDBXContext);

    public
      procedure GetAnsiString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetWideString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetInt16(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetInt32(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetInt64(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetDouble(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetBcd(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetTimeStamp(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetTime(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;
      procedure GetDate(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual; abstract;

      procedure GetByteLength(Ordinal: TInt32; var Length: Int64; var IsNull: LongBool); virtual; abstract;
      function  GetBytes(Ordinal: TInt32; Offset: Int64; const Value: TBytes;
                                 ValueOffset, Length: Int64; var IsNull: LongBool): Int64; virtual; abstract;
  end;
  TDBXByteReaderEx = class(TDBXByteReader)
      procedure GetBoolean(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); virtual;
  end;

  ///<summary>
  ///  Used by driver implementors that do not want to provide an optimized
  ///  TDBXByteReader implementation.  This is an implemntation of
  ///  TDBXByteReader on top of a TDBXReader implementation.
  ///</summary>
  TDBXReaderByteReader = class(TDBXByteReader)
    private
      FDbxReader:  TDBXReader;
    public
      constructor Create(DBXContext: TDBXContext; DbxReader: TDBXReader);

      procedure GetAnsiString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetWideString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt16(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt32(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt64(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetDouble(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetBcd(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetTimeStamp(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetTime(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetDate(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;

      procedure GetByteLength(Ordinal: TInt32; var Length: Int64; var IsNull: LongBool); override;
      function  GetBytes(Ordinal: TInt32; Offset: Int64; const Value: TBytes;
                                 ValueOffset, Length: Int64; var IsNull: LongBool): Int64; override;
  end;

  ///<summary>
  ///  Used internally by <c>TDBXParameterList</c> to manage a list of
  ///  <c>TDBXValueType</c> instances.
  ///</summary>
  TDBXValueList = class
    strict private
      FValueTypeArray:  array of TDBXValueType;
      FLastOrdinal:     Integer;

      function FindOrdinal(const Name: WideString; StartOrdinal, EndOrdinal: TInt32): TInt32; virtual;

    private

      function  GetValueType(const Ordinal: TInt32): TDBXValueType; inline;
      function  GetOrdinal(const Name: WideString): TInt32; virtual;
      procedure SetCount(Count: TInt32);
      function  GetCount: TInt32;
      procedure Add(ValueType: TDBXValueType);
      procedure Insert(Ordinal: TInt32; ValueType: TDBXValueType);
      procedure Remove(ValueType: TDBXValueType); overload;
      procedure Remove(Ordinal: TInt32); overload;
      procedure SetValueType(Ordinal: TInt32; ValueType: TDBXValueType);
      procedure Clear;

      property Count: TInt32 read GetCount;
      property Values[const Ordinal: TInt32]: TDBXValueType read GetValueType; default;
    public
      destructor  Destroy; override;

  end;

//------------------------------------------------------------------------------
// Classes below should only be of interest to driver implementors.
//------------------------------------------------------------------------------

  ///<summary>
  ///  Only used by driver implementors to have access to private or protected
  ///  constructors, procedures or functions.
  ///</summary>
TDBXDriverHelp = class
  public
    class function CreateTDBXParameter(DBXContext: TDBXContext): TDBXParameter; static;
    class function CreateTDBXValueType(DBXContext: TDBXContext): TDBXValueType; static;
    class function CreateTDBXProperties(DBXContext: TDBXContext): TDBXProperties; static;
    class function CreateConnectionBuilder(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnectionBuilder; static;
    class function CreateTDBXContext: TDBXContext; static;
end;
TDBXDriverHelpEx = class(TDBXDriverHelp)
  public
    class function CreateTDBXValueType(DBXContext: TDBXContext; DBXRow: TDBXRow): TDBXValueType; overload; static;
    class function GetStreamReader(Value: TDBXStreamValue): TDBXStreamReader; overload; static;
    class procedure UpdateParameterType(Parameter: TDBXParameter);
    class function IsReadOnlyValueType(ValueType: TDBXValueType): Boolean; static;
end;

  ///<summary>
  ///  Used by driver implementors.
  ///  Collection of parameters needed when loading a driver.  By collecting
  ///  these in a single record, parameters can be added without necessarily
  ///  breaking older drivers.
  ///</summary>
  TDBXDriverDef = packed record
    FDriverName:        WideString;
    FDriverProperties:  TDBXProperties;
    FDBXContext:        TDBXContext;
  end;

  ///<summary>
  ///  Used by driver implementors.
  ///  <c>TDBXDriverLoader</c> implementations can be registered with the
  ///  <c>TDBXDriverRegistry</c> to load a driver by a string based name.
  ///</summary>
  TDBXDriverLoader = class(TClassRegistryObject)
    protected
      FLoaderName:            WideString;
    public
  ///<summary>
  ///  Load the driver using the provided parameters in <c>DriverDef</c>.
  ///</summary>
      function Load(DriverDef: TDBXDriverDef): TDBXDriver; virtual; abstract;
  end;

  TDBXDriverLoaderClass = class of TDBXDriverLoader;

  ///<summary>
  ///  Used by driver implementors.
  ///  A registry of <c>TDBXDriverLoader</c>s that is keyed by a string
  ///  name for the driver.
  ///</summary>
  TDBXDriverRegistry = class
    private
      class var
        DBXDriverRegistry: TDBXDriverRegistry;
      var
    private
      FDriverLoaders:         TWideStringList;
//      FDriverLoaderClasses:   TWideStringList;
      FCounter: Integer;

      function  FindDriver(List: TList; const DriverName: WideString): Integer;
      procedure FreeAllDrivers(Loader: TDBXDriverLoader);
      procedure FreeAllLoaders();
      procedure InternalRegisterLoader(const LoaderClassName: WideString; Loader: TDBXDriverLoader);
//      procedure InternalRegisterLoaderClass(LoaderName: WideString; LoaderClass: TDBXDriverLoaderClass);
//      procedure InternalUnregisterLoader(Loader: TDBXDriverLoader);
      function  LoadDriver(DriverDef: TDBXDriverDef; List: TList): TDBXDriver;

    private
      FDrivers:       TThreadList;
      function  GetDriver(DriverDef: TDBXDriverDef): TDBXDriver;
      procedure DriverLoadError(DriverDef: TDBXDriverDef; PackageName: WideString);
      procedure FreeDriver(Driver: TDBXDriver);
      procedure CloseAllDrivers;
    public
      constructor Create;
      destructor Destroy; override;
//      class procedure RegisterLoaderClass(LoaderClassName: WideString; LoaderClass: TDBXDriverLoaderClass);
//      class procedure UnregisterLoader(Loader: TDBXDriverLoader);
  end;

  ///<summary>
  ///  Delegate driver base class.
  ///  The TDBXConnectionFactory.GetDriver method also returns an instance
  ///  of TDBXDelegateDriver so that it can control the loading and unloading
  ///  of drivers.
  ///</summary>
  TDBXDelegateDriver = class(TDBXDriverEx)
  private
    FDriver:    TDBXDriver;
  protected
    constructor Create(Driver: TDBXDriver);
    function  GetDriverProperties: TDBXProperties; override;
    procedure SetDriverProperties(DriverProperties: TDBXProperties); override;
    function  GetDriverName: WideString; override;
    procedure SetDriverName(const DriverName: WideString); override;
    function  CreateConnection(ConnectionBuilder:  TDBXConnectionBuilder): TDBXConnection; override;
    procedure Close; override;
    function  CreateMorphCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand; override;
  public
    destructor Destroy; override;
    function GetDriverVersion: WideString; override;
  end;

  ///<summary>
  ///  Used by driver implementors.
  ///</summary>
  TDBXDelegateItem = class
    FName:        WideString;
    FProperties:  TDBXProperties;
    FNext:        TDBXDelegateItem;
    destructor Destroy; override;
  end;

  ///<summary>
  ///  Used by driver implementors.
  ///</summary>
  TDBXPropertiesItem = class
    FProperties:    TDBXProperties;
    FDeletgatePath: TDBXDelegateItem;
    constructor Create(Properties: TDBXProperties);
    destructor Destroy; override;
  end;

  ///<summary>
  ///  Utility class used by driver writers when connections are created.
  ///  Particularly important for chaining delegate connections in front
  ///  of a database connection.
  ///</summary>
  TDBXConnectionBuilder = class
    private

      FInputConnectionProperties: TDBXProperties;
      FInputConnectionName:       WideString;
      FInputUserName:             WideString;
      FInputPassword:             WideString;

      FConnectionFactory:         TDBXConnectionFactory;
      FOwnsDelegatePath:          Boolean;
      FDelegatePath:              TDBXDelegateItem;
      FDBXContext:                TDBXContext;

      FDelegateDriver:            TDBXDelegateDriver;

      function GetConnectionProperties: TDBXProperties;
      function GetDelegationSignature: WideString;
      procedure Assign(Source: TDBXConnectionBuilder);
      function CreateConnection: TDBXConnection;
    protected
      constructor Create; overload;
      constructor Create(Source: TDBXConnectionBuilder); overload;
    public
      destructor Destroy; override;
      ///<summary>
      ///  Used by delegate driver implementations to request the creation
      ///  of the connection the delegate connection delegates to.
      ///</summary>
      function CreateDelegateeConnection: TDBXConnection;
      ///<summary>
      ///  TDBXConnection properties provided by the current delegate or database
      ///  connection being created.
      ///</summary>
      property ConnectionProperties: TDBXProperties read GetConnectionProperties;
      ///<summary>
      ///  A '/' slash separated list of the delegate delegate drivers and the database
      ///  dirver used to create a connection by this TDBXConnectionBuilder instance.
      ///</summary>
      property DelegationSignature: WideString read GetDelegationSignature;

      ///<summary>
      ///  First database TDBXProperties when a connection was requested from
      ///  a TDBXConnectionFactory.
      ///</summary>
      property InputConnectionProperties: TDBXProperties read FInputConnectionProperties;
      ///<summary>
      ///  First database connection name when a connection was requested from
      ///  a TDBXConnectionFactory.
      ///</summary>
      property InputConnectionName: WideString read FInputConnectionName;
      ///<summary>
      ///  First database user name when a connection was requested from
      ///  a TDBXConnectionFactory.
      ///</summary>
      property InputUserName: WideString read FInputUserName;
      ///<summary>
      ///  First database password when a connection was requested from
      ///  a TDBXConnectionFactory.
      ///</summary>
      property InputPassword: WideString read FInputPassword;
      ///<summary>
      ///  DBXContext to be used for the database connection.  Delegate connections
      ///  should not use this instance of DbxContext.  They should create their
      ///  own instead.
      ///</summary>
      property DbxContext: TDBXContext read FDbxContext;

  end;


  ///<summary>
  ///  Implemented by Driver implementations.  This is not used directly by applications.
  ///</summary>
  TDBXRow = class
    strict protected
      FDBXContext:      TDBXContext;

      procedure NotImplemented;
    protected
      FGeneration:      TInt32;
      procedure GetAnsiString(DbxValue: TDBXAnsiStringValue; var AnsiStringBuilder: TDBXAnsiStringBuilder; var IsNull: LongBool); virtual;
      procedure GetWideString(DbxValue: TDBXWideStringValue; var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool); virtual;
      procedure GetBoolean(DbxValue: TDBXBooleanValue; var Value: LongBool; var IsNull: LongBool); virtual;
      procedure GetInt16(DbxValue: TDBXInt16Value; var Value: SmallInt; var IsNull: LongBool); virtual;
      procedure GetInt32(DbxValue: TDBXInt32Value; var Value: TInt32; var IsNull: LongBool); virtual;
      procedure GetInt64(DbxValue: TDBXInt64Value; var Value: Int64; var IsNull: LongBool); virtual;
      procedure GetDouble(DbxValue: TDBXDoubleValue; var Value: Double; var IsNull: LongBool); virtual;
      procedure GetBcd(DbxValue: TDBXBcdValue; var Value: TBcd; var IsNull: LongBool); virtual;
      procedure GetDate(DbxValue: TDBXDateValue; var Value: TDBXDate; var IsNull: LongBool); virtual;
      procedure GetTime(DbxValue: TDBXTimeValue; var Value: TDBXTime; var IsNull: LongBool); virtual;
      procedure GetTimeStamp(DbxValue: TDBXTimeStampValue; var Value: TSQLTimeStamp; var IsNull: LongBool); virtual;
      procedure GetBytes(DbxValue: TDBXByteArrayValue; Offset: Int64; const Buffer: TBytes; BufferOffset, Length: Int64; var ReturnLength: Int64; var IsNull: LongBool); virtual;
      procedure GetByteLength(DbxValue: TDBXByteArrayValue; var ByteLength: Int64; var IsNull: LongBool); virtual;

      procedure SetNull(DbxValue: TDBXValue); virtual;
      procedure SetString(DbxValue: TDBXAnsiStringValue; const Value: String); virtual;
      procedure SetWideString(DbxValue: TDBXWideStringValue; const Value: WideString); virtual;
      procedure SetBoolean(DbxValue: TDBXBooleanValue; Value: Boolean); virtual;
      procedure SetInt16(DbxValue: TDBXInt16Value; Value: SmallInt); virtual;
      procedure SetInt32(DbxValue: TDBXInt32Value; Value: TInt32); virtual;
      procedure SetInt64(DbxValue: TDBXInt64Value; Value: Int64); virtual;
      procedure SetDouble(DbxValue: TDBXDoubleValue; Value: Double); virtual;

      procedure SetBCD(DbxValue: TDBXBcdValue; var Value: TBcd); virtual;

      procedure SetDate(DbxValue: TDBXDateValue; Value: TDBXDate); virtual;
      procedure SetTime(DbxValue: TDBXTimeValue; Value: TDBXTime); virtual;

      procedure SetTimestamp(DbxValue: TDBXTimeStampValue; var Value: TSQLTimeStamp); virtual;

      procedure SetDynamicBytes( DbxValue:     TDBXValue;
                          Offset:       Int64;
                          const Buffer: TBytes;
                          BufferOffset: Int64;
                          Length:       Int64); virtual;



      function GetObjectTypeName(Ordinal: TInt32): WideString; virtual;
      procedure SetValueType(ValueType: TDBXValueType); virtual;

      property Generation: TInt32 read FGeneration;
    protected
      constructor Create(DBXContext: TDBXContext);
  end;

  TDBXRowEx = class(TDBXRow)
  protected
      function  UseExtendedTypes: Boolean; virtual;
      procedure GetWideChars(DbxValue: TDBXWideStringValue; var WideChars: TDBXWideChars; var Count: Integer; var IsNull: LongBool); virtual;
      procedure GetStream(DbxValue: TDBXStreamValue; var Stream: TStream; var IsNull: LongBool); overload; virtual;
      procedure GetStream(DbxValue: TDBXWideStringValue; var Stream: TStream; var IsNull: LongBool); overload; virtual;
      procedure GetStreamBytes(DbxValue: TDBXStreamValue; const Buffer: TBytes; BufferOffset, Length, ReturnLength: Int64; var IsNull: LongBool); virtual;
      procedure GetStreamLength(DbxValue: TDBXStreamValue; StreamLength: Int64; var IsNull: LongBool); virtual;

      procedure SetWideChars(DbxValue: TDBXWideStringValue; const Value: WideString); virtual;
      procedure SetStream(DbxValue:     TDBXStreamValue;
                          StreamReader: TDBXStreamReader); overload; virtual;
      procedure GetLength(DbxValue: TDBXValue; var ByteLength: Int64; var IsNull: LongBool); virtual;
      function  CreateCustomValue(ValueType: TDBXValueType): TDBXValue; virtual;

  end;

  TDBXCommandFactory = class
  public
    function CreateCommand(DbxContext: TDBXContext; Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand; virtual; abstract;
  end;

resourcestring
  SDllLoadError       = 'Unable to load %s (ErrorCode %d).  It may be missing from the system path.';
  SDllProcLoadError   = 'Unable to find procedure %s';
  SUnknownDriver      = 'Unknown driver:  %s';
  SInvalidArgument    = 'Invalid argument:  %s';
  SInvalidTransaction = 'Invalid transaction Object';
  SNotImplemented     = 'Feature not implemented';
  SRequiredProperty   = '%s property not set';
  SDriverLoadError    = '%s driver cannot be loaded.  Make sure your project either uses the %s unit or uses packages so the %s package can be loaded dynamically';
  SReaderNew          = 'Reader Next method has not been called';
  SReaderClosed       = 'Reader has no more rows';
  SReadOnlyType       = '%s type cannot be modified';
  SReadOnlyParameter  = '%s parameter cannot be modified';
  SSetFactoryOnce     = 'Cannot set the ConnectionFactory singleton more than once';
  SConnectionFactoryInitFailed  = 'Cannot find connection files from application directory (%s) or the system registry (%s).';
  SInvalidDelegationDepth       = 'Cannot delegate a connection more than 16 times:  %s';
  SInvalidOrdinal     = 'Invalid Ordinal:  %d';
  SDefaultErrorMessage          = 'DBX Error:  %s';
  SAlreadyPrepared    = 'Command can only be prepared once';
  SInvalidTypeAccess  = '%s value type cannot be accessed as %s value type';

implementation

const
  // Set TDBXReader.FCount to NewReaderCount to trigger error message
  // that TDBXReader.Next needs to be called.
  //
  NewReaderCount    = -1;
  // Set TDBXReader.FCount to ClosedReadercount to trigger error message
  // that a TDBXReader can no longer be used.  This will occur when
  // TDBXReader.Next returns false.
  //
  ClosedReaderCount = -2;

  // Use DefaultDriverClassName and DefaultDriverPackageName if
  // proper definitions are missing from the driver section.
{$IFDEF CLR}
  DefaultDriverClassName = 'Borland.Data.TDBXDynalinkDriverLoader'; // Do not localize
  DefaultDriverPackageName =  'Borland.Data.DbxDynalinkDriver,Version=11.0.5000.0,Culture=neutral,PublicKeyToken=91d62ebb5b0d1b1b'; // Do not localize
{$ELSE}
  DefaultDriverClassName = 'TDBXDynalinkDriverLoader'; // Do not localize
  DefaultDriverPackageName = 'DbxDynalinkDriver100.bpl'; // Do not localize
{$ENDIF}

resourcestring
  SNoStatementToExecute = 'No statement to execute';

type

  TDBXAnsiStringBuilderValue = class(TDBXAnsiStringValue)
    private
      procedure SetRowValue; override;
      procedure UpdateType; override;
    protected
      constructor Create(ValueType: TDBXValueType);
    public
      destructor Destroy; override;
      function IsNull:Boolean; override;
      function GetAnsiString: String; override;
      procedure SetAnsiString(const Value: String); override;
  end;

    TDBXWideStringBuilderValue = class(TDBXWideStringValue)
    private
      procedure UpdateType; override;
      procedure SetRowValue; override;
    protected
      constructor Create(ValueType: TDBXValueType);
    public
      destructor Destroy; override;
      function IsNull: Boolean; override;
      function GetWideString: WideString; override;
      procedure SetWideString(const Value: WideString); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.MemoSubType</c> values.
  ///</summary>
  TDBXAnsiMemoValue = class(TDBXByteArrayValue)
    private
      procedure GetFBytes;
    protected
      constructor Create(ValueType: TDBXValueType);
    public
      destructor Destroy; override;
      function IsNull: Boolean; override;
      function GetAnsiString: String; override;
      procedure SetAnsiString(const Value: String); override;
  end;

  ///<summary>
  ///  Implementation of <c>TDBXWritableValue</c> for <c>TDBXDataTypes.MemoSubType</c> values.
  ///</summary>
  TDBXWideMemoValue = class(TDBXByteArrayValue)
    private
      procedure GetFBytes;
    protected
      constructor Create(ValueType: TDBXValueType);
    public
      destructor Destroy; override;
      function IsNull: Boolean; override;
      function GetWideString: WideString; override;
      procedure SetWideString(const Value: WideString); override;
  end;

  TDBXCreateCommand = class
    private
      FOnCreateCommand: TDBXCreateCommandEvent;
  end;


  TDBXClosedByteReader = class(TDBXByteReader)

    private
      procedure InvalidOperation;

    protected
      constructor Create(DBXContext: TDBXContext);

    public
      procedure GetAnsiString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetWideString(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt16(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt32(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetInt64(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetDouble(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetBcd(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetTimeStamp(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetTime(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;
      procedure GetDate(Ordinal: TInt32; const Value: TBytes; Offset: TInt32; var IsNull: LongBool); override;

      procedure GetByteLength(Ordinal: TInt32; var Length: Int64; var IsNull: LongBool); override;
      function  GetBytes(Ordinal: TInt32; Offset: Int64; const Value: TBytes;
                                 ValueOffset, Length: Int64; var IsNull: LongBool): Int64; override;

  end;


procedure TDBXConnectionFactory.Close;
var
  Index: Integer;
begin
  if FDrivers <> nil then
  begin
    for Index := 0 to FDrivers.Count - 1 do
      FDrivers.Objects[Index].Free;
    FreeAndNil(FDrivers);
  end;
  if FConnectionProperties <> nil then
  begin
    for Index := 0 to FConnectionProperties.Count - 1 do
      FConnectionProperties.Objects[Index].Free;
    FreeAndNil(FConnectionProperties);
  end;
  FreeAndNil(FDBXContext);
  DerivedClose;
end;

constructor TDBXConnectionFactory.Create;
begin
  inherited Create;
end;

destructor TDBXConnectionFactory.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TDBXConnectionFactory.GetConnection(
  const ConnectionName: WideString;
  const UserName: WideString;
  const Password: WideString): TDBXConnection;
var
  ConnectionBuilder:    TDBXConnectionBuilder;
  DelegatePath:         TDBXDelegateItem;
  PropertyItem:         TDBXPropertiesItem;
  Connection:           TDBXConnection;
  Properties:           TDBXProperties;
  OwnsDelegatePath:     Boolean;
begin
  PropertyItem      := GetConnectionPropertiesItem(ConnectionName);
  Properties        := PropertyItem.FProperties;
  if (UserName <> '') or (Password <> '') then
  begin
    Properties := Properties.Clone;
    DelegatePath := CreateDelegatePath('', Properties);
    if UserName <> '' then
      Properties[TDBXPropertyNames.UserName] := UserName;
    if Password <> '' then
      Properties[TDBXPropertyNames.Password] := Password;
    OwnsDelegatePath  := true;
  end else
  begin
    DelegatePath      := PropertyItem.FDeletgatePath;
    OwnsDelegatePath  := false;
  end;
  ConnectionBuilder := TDBXConnectionBuilder.Create;
  Connection        := nil;
  try
    ConnectionBuilder.FOwnsDelegatePath           := OwnsDelegatePath;
    ConnectionBuilder.FDelegatePath               := DelegatePath;
    ConnectionBuilder.FConnectionFactory          := Self;
    ConnectionBuilder.FDBXContext                 := TDBXContext.Create(FDBXContext);
    ConnectionBuilder.FInputConnectionName        := ConnectionName;
    ConnectionBuilder.FInputConnectionProperties  := Properties;
    ConnectionBuilder.FInputUserName              := Properties[TDBXPropertyNames.UserName];
    ConnectionBuilder.FInputPassword              := Properties[TDBXPropertyNames.Password];
    Connection := ConnectionBuilder.CreateConnection;
    Connection.Open;
    Result     := Connection;
    Connection := nil;
  finally
    Connection.Free;
    ConnectionBuilder.Free;
  end;
end;

function TDBXConnectionFactory.GetConnection(
  ConnectionProperties: TDBXProperties): TDBXConnection;
var
  ConnectionBuilder:  TDBXConnectionBuilder;
  DelegatePath:       TDBXDelegateItem;
  Connection:         TDBXConnection;
begin
  DelegatePath := CreateDelegatePath('', ConnectionProperties);
  ConnectionBuilder := TDBXConnectionBuilder.Create;
  Connection        := nil;
  try
    ConnectionBuilder.FOwnsDelegatePath           := true;
    ConnectionBuilder.FDelegatePath               := DelegatePath;
    ConnectionBuilder.FConnectionFactory          := Self;
    ConnectionBuilder.FDBXContext                 := TDBXContext.Create(FDBXContext);
    ConnectionBuilder.FInputConnectionName        := ConnectionProperties[TDBXPropertyNames.ConnectionName];
    ConnectionBuilder.FInputConnectionProperties  := ConnectionProperties;
    ConnectionBuilder.FInputUserName              := ConnectionProperties[TDBXPropertyNames.UserName];
    ConnectionBuilder.FInputPassword              := ConnectionProperties[TDBXPropertyNames.Password];
    Connection := ConnectionBuilder.CreateConnection;
    Connection.Open;
    Result     := Connection;
    Connection := nil;
  finally
    Connection.Free;
    ConnectionBuilder.Free;
  end;
end;


function TDBXConnectionFactory.CreateDelegatePath(
  Depth:          Integer;
  DelegateItem:   TDBXDelegateItem;
  DBXProperties:  TDBXProperties): TDBXDelegateItem;
var
  DelegateName:     WideString;
  NewDelegateItem:  TDBXDelegateItem;
  NewProperties:    TDBXProperties;
  StringList:       TWideStringList;
begin
  if Depth > 16 then
  begin
    StringList := TWideStringList.Create;
    while DelegateItem <> nil do
    begin
      StringList.Add(DelegateItem.FName);
      DelegateItem := DelegateItem.FNext;
    end;

    FDBXContext.Error(TDBXErrorCodes.DriverInitFailed, WideFormat(SInvalidDelegationDepth, [StringList.DelimitedText]));
  end;
  DelegateName := DBXProperties[TDBXPropertyNames.DelegateConnection];
  if DelegateName = '' then
    Result := DelegateItem
  else
  begin
    NewProperties   := GetConnectionProperties(DelegateName);
    NewDelegateItem := nil;
    try
      NewDelegateItem             := TDBXDelegateItem.Create;
      NewDelegateItem.FNext       := DelegateItem;
      NewDelegateItem.FName       := DelegateName;
      NewDelegateItem.FProperties := NewProperties;
      Result := CreateDelegatePath(Depth+1, NewDelegateItem, NewDelegateItem.FProperties);
      NewDelegateItem := nil;
    finally
      NewDelegateItem.Free;
    end;
  end;
end;

function TDBXConnectionFactory.CreateDelegatePath(
  const ConnectionName: WideString;
  DBXProperties: TDBXProperties): TDBXDelegateItem;
var
  Depth:              Integer;
  FirstDelegateItem:  TDBXDelegateItem;
begin
  Depth                         := 0;
  FirstDelegateItem             := TDBXDelegateItem.Create;
  try
    FirstDelegateItem.FName       := ConnectionName;
    FirstDelegateItem.FProperties := DBXProperties;
    Result := CreateDelegatePath(Depth, FirstDelegateItem, DBXProperties);
    FirstDelegateItem := nil;
  finally
    FirstDelegateItem.Free;
  end;

end;

procedure TDBXConnectionFactory.CreateDelegatePaths;
var
  PropertiesItem: TDBXPropertiesItem;
  Index:          Integer;
  Count:          Integer;
begin
  Count := FConnectionProperties.Count;
  for Index := 0 to Count - 1 do
  begin
    PropertiesItem  := TDBXPropertiesItem(FConnectionProperties.Objects[Index]);
    PropertiesItem.FDeletgatePath := CreateDelegatePath(FConnectionProperties.Names[Index], PropertiesItem.FProperties);
  end;

end;


function TDBXConnectionFactory.GetConnectionDriver(
  const ConnectionName: WideString): TDBXDelegateDriver;
var
  DriverName: WideString;
  ConnectionProperties: TDBXProperties;
begin

  ConnectionProperties  := GetConnectionProperties(ConnectionName);
  DriverName            := GetDriverName(ConnectionProperties);
  Result := GetDriver(DriverName, GetDriverProperties(DriverName));
end;

function TDBXConnectionFactory.GetConnectionProperties(
  const ConnectionName: WideString): TDBXProperties;
begin
  Result := GetConnectionPropertiesItem(ConnectionName).FProperties;
end;

function TDBXConnectionFactory.GetConnectionPropertiesItem(
  const ConnectionName: WideString): TDBXPropertiesItem;
var
  Index : TInt32;
begin
  Index  := FConnectionProperties.IndexOf(ConnectionName);
  if Index < 0 then
    FDBXContext.Error(TDBXErrorCodes.InvalidArgument, WideFormat(sInvalidArgument, [ConnectionName]));
  Result := TDBXPropertiesItem(FConnectionProperties.Objects[Index]);
end;

function TDBXConnectionFactory.GetDriver(
  const DriverName: WideString;
  DriverProperties: TDBXProperties): TDBXDelegateDriver;
var
  DriverDef:  TDBXDriverDef;
begin
  DriverDef.FDriverName       := DriverName;
  DriverDef.FDriverProperties := DriverProperties;
  DriverDef.FDBXContext  := FDBXContext;
  Result := TDBXDelegateDriver.Create(TDBXDriverRegistry.DBXDriverRegistry.GetDriver(DriverDef));
end;

function TDBXConnectionFactory.getDriverName(
  ConnectionProperties: TDBXProperties): WideString;
begin
  Result := ConnectionProperties[TDBXPropertyNames.DriverName];
end;

function TDBXConnectionFactory.GetDriverProperties(
  const DriverName: WideString): TDBXProperties;
var
  Index : TInt32;
begin
  Index  := FDrivers.IndexOf(DriverName);

  if Index < 0 then
    FDBXContext.Error(TDBXErrorCodes.DriverInitFailed, WideFormat(sUnknownDriver, [DriverName]));

  Result := TDBXProperties(FDrivers.Objects[Index]);
end;

function TDBXConnectionFactory.GetErrorEvent: TDBXErrorEvent;
begin
  Result := FDBXContext.OnError;
end;


function TDBXConnectionFactory.GetTraceFlags: TDBXTraceFlag;
begin
  Result := FDBXContext.TraceFlags;
end;

function TDBXConnectionFactory.GetTraceInfoEvent: TDBXTraceEvent;
begin
  Result := FDBXContext.OnTrace;
end;

function TDBXConnectionFactory.GetDriver(const DriverName: WideString): TDBXDriver;
begin
  Result := GetDriver(DriverName, GetDriverProperties(DriverName));
end;


procedure TDBXConnectionFactory.Open;
var
  Complete: Boolean;
begin
  if FDrivers = nil then
  begin
    Complete := false;
    try
      FDrivers              := TWideStringList.Create;
      FConnectionProperties := TWideStringList.Create;
      FDBXContext           := TDBXContext.Create;
      DerivedOpen;
      Complete := true;
    finally
      if not Complete then
        Close;
    end;
  end;
end;

class function TDBXConnectionFactory.OpenConnectionFactory(
  const DriverFileName, ConnectionFileName: WideString): TDBXConnectionFactory;
var
  ConnectionFactory:  TDBXIniFileConnectionFactory;
begin
  if FileExists(ConnectionFileName) then
  begin
    ConnectionFactory := TDBXIniFileConnectionFactoryEx.Create;
    try
      ConnectionFactory.ConnectionsFile := ConnectionFileName;
      ConnectionFactory.DriversFile     := DriverFileName;

      ConnectionFactory.Open;
      Result := ConnectionFactory;
    except
      ConnectionFactory.Free;
      Result := nil;
    end;
  end else
    Result := nil;
end;


class function TDBXConnectionFactory.GetConnectionFactory: TDBXConnectionFactory;
var
  AppName:            WideString;
  AppDir:             WideString;
  RegistryDriver:     WideString;
  RegistryConnection: WideString;
  Registry:           TRegistry;
begin
  if ConnectionFactorySingleton = nil then
  begin
    Registry := TRegistry.Create;
    try
      Registry.RootKey := HKEY_CURRENT_USER;
      if Registry.OpenKeyReadOnly(TDBXRegistryKey) then
      begin
        RegistryDriver      := Registry.ReadString(TDBXRegistryDriverValue);
        RegistryConnection  := Registry.ReadString(TDBXRegistryConnectionValue);
        ConnectionFactorySingleton
        := OpenConnectionFactory(RegistryDriver, RegistryConnection);
      end;
      if ConnectionFactorySingleton = nil then
      begin
        AppName := ParamStr(0);
        if AppName <> '' then
        begin
          AppDir := ExtractFileDir(AppName);
          ConnectionFactorySingleton
          := OpenConnectionFactory(AppDir+'/'+TDBXDriverFile, AppDir+'/'+TDBXConnectionFile);
        end;
      end;
{$IF DEFINED(CLR)}
      if ConnectionFactorySingleton = nil then
          if HostingEnvironment.IsHosted then
          begin
            AppDir := HttpRuntime.AppDomainAppPath;
            ConnectionFactorySingleton
              := OpenConnectionFactory(AppDir+'/'+TDBXDriverFile, AppDir+'/'+TDBXConnectionFile);
          end;
{$IFEND}

      if ConnectionFactorySingleton = nil then
        raise TDBXError.Create(TDBXErrorCodes.DriverInitFailed,
                               WideFormat(SConnectionFactoryInitFailed, [AppDir, TDBXRegistryKey]));
    finally
      Registry.Destroy;
    end;
  end;
  Result := ConnectionFactorySingleton;
end;

procedure TDBXConnectionFactory.GetConnectionItems(Items: TStrings);
var
  Index: Integer;
begin
  for Index := 0 to FConnectionProperties.Count - 1 do
    Items.Add(FConnectionProperties[Index]);
end;

class procedure TDBXConnectionFactory.SetConnectionFactory(
  ConnectionFactory: TDBXConnectionFactory);
begin
  if ConnectionFactorySingleton <> nil then
    raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, SSetFactoryOnce);
  ConnectionFactorySingleton := ConnectionFactory;
end;

procedure TDBXConnectionFactory.SetErrorEvent(ErrorEvent: TDBXErrorEvent);
begin
  FDBXContext.OnError := ErrorEvent;
end;

procedure TDBXConnectionFactory.SetTraceFlags(TraceFlags: TDBXTraceFlag);
begin
  FDBXContext.TraceFlags := TraceFlags;
end;

procedure TDBXConnectionFactory.SetTraceInfoEvent(
  TraceInfoEvent: TDBXTraceEvent);
begin
  FDBXContext.OnTrace := TraceInfoEvent;
end;

procedure TDBXIniFileConnectionFactory.DerivedOpen;
begin
  inherited Open;

  if FDriversFile <> '' then
    LoadDrivers;
  if FConnectionsFile <> '' then
    LoadConnections;
  CreateDelegatePaths;
end;


function TDBXIniFileConnectionFactory.LoadSectionProperties(IniFile: TMemIniFile;
  Section: String;
  LoadConnection: Boolean): TDBXProperties;
var
  ConnectionProperties: TDBXProperties;
  Properties : TStringList;
  TrimProperties : TWideStringList;
  index: TInt32;
begin
  Properties := nil;
  ConnectionProperties := nil;
  TrimProperties := nil;
  try
    ConnectionProperties := TDBXProperties.Create;
    Properties := TStringList.Create;
    IniFile.ReadSectionValues(Section, Properties);

    TrimProperties := TWideStringList.Create;

{
    if LoadConnection then
    begin
      Index :=Properties.IndexOfName(TDBXPropertyNames.DriverName);
      if Index >= 0 then
      begin
        DriverProperties := GetDriverProperties(Properties.ValueFromIndex[Index]);

        for index := 0 to DriverProperties.FProperties.Count - 1 do
          TrimProperties.Add(DriverProperties.FProperties.Names[index] + '=' + DriverProperties.FProperties.ValueFromIndex[index]);
      end;
    end;
}

    for index := 0 to Properties.Count - 1 do
      TrimProperties.Add(Properties.Names[index] + '=' + Trim(Properties.ValueFromIndex[index]));

    if LoadConnection then
      TrimProperties.Add(TDBXPropertyNames.ConnectionName + '=' + Section);

    FreeAndNil(ConnectionProperties.FProperties);
    ConnectionProperties.FProperties := TrimProperties;
    TrimProperties := nil;
    Result := ConnectionProperties;
    ConnectionProperties := nil;
  finally
    Properties.Free;
    TrimProperties.Free;
    ConnectionProperties.Free;
  end;
end;

procedure TDBXIniFileConnectionFactory.LoadConnections;
var
  ConnectionFile        : TMemIniFile;
  SectionList           : TStringList;
  index                 : TInt32;
  DBXProperties         : TDBXProperties;
begin
  ConnectionFile := nil;
  SectionList    := nil;
  try
    ConnectionFile := TMemIniFile.Create(FConnectionsFile);
    SectionList   := TStringList.Create;
    ConnectionFile.ReadSections(SectionList);

    for index := 0 to SectionList.Count - 1 do
    begin
      DBXProperties := LoadSectionProperties(ConnectionFile, SectionList.Strings[index], true);
      FConnectionProperties.AddObject(SectionList.Strings[index], TDBXPropertiesItem.Create(DbxProperties));
    end;

//    for index := 0 to SectionList.Count - 1 do
//      Writeln('|' + SectionList.Strings[index] + '|');

  finally
    ConnectionFile.Free;
    SectionList.Free;
  end;

end;

function TDBXIniFileConnectionFactory.LoadDriver(DriverIni : TMemIniFile; const DriverName: WideString) : TDBXProperties;
begin
  Result := LoadSectionProperties(DriverIni, DriverName, false);
end;

procedure TDBXIniFileConnectionFactory.LoadDrivers;
var
  DriverFile        : TMemIniFile;
  EnabledDriverList : TStringList;
  index             : TInt32;
begin
  EnabledDriverList := nil;
  DriverFile        := nil;
  try
    DriverFile := TMemIniFile.Create(FDriversFile);
    EnabledDriverList := TStringList.Create;
    DriverFile.ReadSection(TDBXPropertyNames.InstalledDrivers, EnabledDriverList);

    if EnabledDriverList.Count = 0 then
      FDBXContext.Error(TDBXErrorCodes.DriverInitFailed, WideFormat('No "%s" defined in %s', [TDBXPropertyNames.InstalledDrivers, FDriversFile]));

    for index := 0 to EnabledDriverList.Count - 1 do
      FDrivers.AddObject(EnabledDriverList.Strings[index], LoadDriver(DriverFile, EnabledDriverList.Strings[index]));

  finally
    EnabledDriverList.Free;
    DriverFile.Free;
  end;
end;


procedure TDBXIniFileConnectionFactory.DerivedClose;
begin

end;

constructor TDBXIniFileConnectionFactory.Create;
begin
  inherited Create;
  FConnectionsFile := '';
  FDriversFile := '';
end;

destructor TDBXIniFileConnectionFactory.Destroy;
begin
  inherited Destroy;
  FConnectionsFile := '';
  FDriversFile := '';
end;


{ TConnectionProperties }

procedure TDBXProperties.Add(const Name, Value: WideString);
begin
//  if Value <> '' then
    FProperties.Add(Name+'='+Value);
end;

procedure TDBXProperties.AddProperties(List: TWideStrings);
var
  Index: Integer;
begin
//  for Index := 0 to List.Count - 1 do
//    begin
//    Writeln(List.Names[index] + '=' + List.ValueFromIndex[index]);
//    end;
  for Index := 0 to List.Count - 1 do
    FProperties.Add(List.Names[index] + '=' + Trim(List.ValueFromIndex[index]));

end;

procedure TDBXProperties.SetProperties(const ConnectionString: WideString);
begin
  FProperties.Delimiter := ';';
  FProperties.StrictDelimiter := True;
  FProperties.DelimitedText := ConnectionString;
end;

function TDBXProperties.Clone: TDBXProperties;
begin
  Result := TDBXProperties.Create;
  Result.AddProperties(Properties);
end;

constructor TDBXProperties.Create(DBXContext: TDBXContext);
begin
  inherited Create;
  FDBXContext := DBXContext;
end;

constructor TDBXProperties.Create;
begin
  inherited;
  FProperties := TWideStringList.Create;
end;

destructor TDBXProperties.Destroy;
var
  index : TInt32;
begin
  inherited;
  for index := 0 to FProperties.Count - 1 do
    FProperties.Objects[index].Free;

  FreeAndNil(FProperties);
end;


function TDBXProperties.GetBoolean(const Name: WideString): Boolean;
var
  Value: WideString;
begin
  Result := false;
  Value := Values[Name];
  if Value <> '' then
  begin
    if (value[1] = 't') or (value[1] = 'T') then
      Result := true;
  end;
end;

function TDBXProperties.GetInteger(const Name: WideString): Integer;
var
  Value: WideString;
begin
  Result := -1;
  Value := Values[Name];
  if Value <> '' then
    Result := StrToInt(Value);
end;
procedure TDBXProperties.GetLists(var Names, Values: TWideStringArray);
var
  Index: Integer;
  Count: Integer;
begin
  Count := FProperties.Count;
  SetLength(Names, Count);
  SetLength(Values, Count);
  for Index := 0 to Count - 1 do
    begin
      Names[Index]  := FProperties.Names[Index];
      Values[Index] := FProperties.ValueFromIndex[Index];
    end;
end;

function TDBXProperties.GetRequiredValue(const Name: WideString): WideString;
var
  Message: WideString;
begin
  Result := FProperties.Values[Name];
  if Result = '' then
  begin
    Message := WideFormat(SRequiredProperty, [Name]);
    if FDBXContext <> nil then
      FDBXContext.Error(TDBXErrorCodes.InvalidArgument, message)
    else
      raise TDBXError.Create(TDBXErrorCodes.InvalidArgument, message);
  end;
end;

function TDBXProperties.GetValue(const Name: WideString): WideString;
begin
  Result := FProperties.Values[Name];
end;

procedure TDBXProperties.SetValue(const Name, Value: WideString);
begin
  FProperties.Values[Name] := Value;
end;


procedure TDBXDriverEx.AddCommandFactory(Name: WideString;
  OnCreateCommand: TDBXCreateCommandEvent);
var
  CreateCommandObject: TDBXCreateCommand;
begin
  CreateCommandObject := TDBXCreateCommand.Create;
  CreateCommandObject.FOnCreateCommand := OnCreateCommand;
  FCommandFactories.AddObject(Name, CreateCommandObject);
end;

procedure TDBXDriverEx.LoadMetaDataCommandFactory(const MetaDataCommandFactoryClassName: WideString; const MetaDataCommandFactoryPackageName: WideString);
var
  ClassRegistry: TClassRegistry;
begin
  ClassRegistry := TClassRegistry.GetClassRegistry;
  if ClassRegistry.HasClass(MetaDataCommandFactoryClassName) then
  begin
    FMetaDataCommandFactory := TDBXCommandFactory(ClassRegistry.CreateInstance(MetaDataCommandFactoryClassName));
    AddCommandFactory(TDBXCommandTypes.DbxMetaData, FMetaDataCommandFactory.CreateCommand);
  end
  else
  begin
    // TODO: proper error message:
    raise Exception.Create('Could not find metadata: '+MetaDataCommandFactoryClassName+'; package: '+MetaDataCommandFactoryPackageName);
  end;
end;

procedure TDBXDriver.AddReference;
begin
  TDBXDriverRegistry.DBXDriverRegistry.FDrivers.LockList;
  try
    inc(FReferenceCount);
  finally
    TDBXDriverRegistry.DBXDriverRegistry.FDrivers.UnLockList;
  end;
end;


procedure TDBXDriver.CacheUntilFinalization;
begin
  AddReference;
end;

destructor TDBXDriver.Destroy;
begin

  inherited;
end;

constructor TDBXDriverEx.Create;
begin
  inherited Create;
  FCommandFactories := TWideStringList.Create;
end;

function TDBXDriverEx.CreateMorphCommand(DbxContext: TDBXContext;
  Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
var
  Index: Integer;
  CommandFactory:  TDBXCreateCommand;
begin
  Index := FCommandFactories.IndexOf(MorphicCommand.CommandType);
  // See if there is a default.
  //
  if Index < 0 then
    Index := FCommandFactories.IndexOf('');

  if Index < 0 then
    Result := nil
  else
  begin
    CommandFactory := TDBXCreateCommand(FCommandFactories.Objects[Index]);
    Result := CommandFactory.FOnCreateCommand(DbxContext, Connection, MorphicCommand);
  end;
end;

destructor TDBXDriverEx.Destroy;
var
  Index: Integer;
begin
  for Index := 0 to FCommandFactories.Count - 1 do
    FCommandFactories.Objects[index].Free;
  FreeAndNil(FCommandFactories);
  FreeAndNil(FMetaDataCommandFactory);
  inherited;
end;

function TDBXDriver.GetDriverName: WideString;
begin
  Result := FDriverName;
end;

function TDBXDriver.GetDriverProperties: TDBXProperties;
begin
  Result := FDriverProperties;
end;

procedure TDBXDriver.RemoveReference;
begin
  TDBXDriverRegistry.DBXDriverRegistry.FDrivers.LockList;
  try
    dec(FReferenceCount);
    if FReferenceCount < 1 then
      TDBXDriverRegistry.DBXDriverRegistry.FreeDriver(Self);
  finally
    TDBXDriverRegistry.DBXDriverRegistry.FDrivers.UnLockList;
  end;
end;

procedure TDBXDriver.SetDriverName(const DriverName: WideString);
begin
  FDriverName := DriverName;
end;

procedure TDBXDriver.SetDriverProperties(DriverProperties: TDBXProperties);
begin
  FDriverProperties := DriverProperties;
end;

//function TDBXDriverEx.HasDBX4MetaData: Boolean;
//begin
//  Result := (FMetaDataCommandFactory <> nil);
//end;

{ TDBXError }

{$IF DEFINED(CLR)}
constructor TDBXError.Create(Info: SerializationInfo; Context: StreamingContext);
begin
  inherited Create(Info,Context);
  FErrorCode := Info.GetInt32('ErrorCode');
  FErrorMessage := inherited Message;
end;

procedure TDBXError.GetObjectData(Info: SerializationInfo; Context: StreamingContext);
begin
  inherited GetObjectData(Info,Context);
  Info.AddValue('ErrorCode',FErrorCode);
end;

{$IFEND}

constructor TDBXError.Create(ErrorCode: TDBXErrorCode; const ErrorMessage: WideString);
begin
  if ErrorMessage = '' then
    FErrorMessage := WideFormat(SDefaultErrorMessage, [ErrorCodeToString(ErrorCode)])
  else
    FErrorMessage := ErrorMessage;
  inherited Create(FErrorMessage);
  FErrorCode    := ErrorCode;
end;

class function TDBXError.ErrorCodeToString(ErrorCode: TDBXErrorCode): WideString;
begin
  case ErrorCode of
    TDBXErrorCodes.None:                              Result := 'None';
    TDBXErrorCodes.Warning:                           Result := 'Warning';
    TDBXErrorCodes.NoMemory:                          Result := 'NoMemory';
    TDBXErrorCodes.UnsupportedFieldType:              Result := 'UnsupportedFieldType';
    TDBXErrorCodes.InvalidHandle:                     Result := 'InvalidHandle';
    TDBXErrorCodes.NotSupported:                      Result := 'NotSupported';
    TDBXErrorCodes.InvalidTime:                       Result := 'InvalidTime';
    TDBXErrorCodes.InvalidType:                       Result := 'InvalidType';
    TDBXErrorCodes.InvalidOrdinal:                    Result := 'InvalidOrdinal';
    TDBXErrorCodes.InvalidParameter:                  Result := 'InvalidParameter';
    TDBXErrorCodes.EOF:                               Result := 'EOF';
    TDBXErrorCodes.ParameterNotSet:                   Result := 'ParameterNotSet';
    TDBXErrorCodes.InvalidUserOrPassword:             Result := 'InvalidUserOrPassword';
    TDBXErrorCodes.InvalidPrecision:                  Result := 'InvalidPrecision';
    TDBXErrorCodes.InvalidLength:                     Result := 'InvalidLength';
    TDBXErrorCodes.InvalidIsolationLevel:             Result := 'InvalidIsolationLevel';
    TDBXErrorCodes.InvalidTransactionId:              Result := 'InvalidTransactionId';
    TDBXErrorCodes.DuplicateTransactionId:            Result := 'DuplicateTransactionId';
    TDBXErrorCodes.DriverRestricted:                  Result := 'DriverRestricted';
    TDBXErrorCodes.TransactionActive:                 Result := 'TransactionActive';
    TDBXErrorCodes.MultipleTransactionNotEnabled:     Result := 'MultipleTransactionNotEnabled';
    TDBXErrorCodes.ConnectionFailed:                  Result := 'ConnectionFailed';
    TDBXErrorCodes.DriverInitFailed:                  Result := 'DriverInitFailed';
    TDBXErrorCodes.OptimisticLockFailed:              Result := 'OptimisticLockFailed';
    TDBXErrorCodes.InvalidReference:                  Result := 'InvalidReference';
    TDBXErrorCodes.NoTable:                           Result := 'NoTable';
    TDBXErrorCodes.MissingParameterMarker:            Result := 'MissingParameterMarker';
    TDBXErrorCodes.NotImplemented:                    Result := 'MissingParameterMarker';
    TDBXErrorCodes.DriverIncompatible:                Result := 'DriverIncompatible';
    TDBXErrorCodes.InvalidArgument:                   Result := 'InvalidArgument';
    TDBXErrorCodes.NoData:                            Result := 'NoData';
    TDBXErrorCodes.VendorError:                       Result := 'VendorError';
    else
      Result := 'Error Code:  ' + IntToStr(Integer(ErrorCode));
  end;
end;

{ TDBXValueType }

constructor TDBXValueType.Create(DBXContext: TDBXContext);
begin
  inherited Create;
  FDBXContext := DBXContext;
end;

procedure TDBXValueType.FailIfReadOnly;
begin
// Ado drivers allow this.
//  if      (ParameterDirection <> TDBXParameterDirections.InParameter)
//     and  (ParameterDirection <> TDBXParameterDirections.InOutParameter) then
//  begin
//    FDBXContext.Error(TDBXErrorCodes.InvalidParameter,
//      WideFormat(SReadOnlyParameter, [FName]));
//  end;
end;

procedure TDBXValueType.FailIfReadOnlyType;
begin
  if IsReadOnlyType then
    FDBXContext.Error(TDBXErrorCodes.InvalidParameter,
      WideFormat(SReadOnlyType, [FName]));
end;

function TDBXValueType.GetChildPosition: TInt32;
begin
  Result := FChildPosition;
end;

function TDBXValueType.GetDataType: TDBXType;
begin
  Result := FDataType;
end;

function TDBXValueType.GetFlags: TInt32;
begin
  Result := FFlags;
end;

function TDBXValueType.GetName: WideString;
begin
  Result := FName;
end;


function TDBXValueType.GetOrdinal: TInt32;
begin
  Result := FOrdinal;
end;

function TDBXValueType.GetParameterDirection: TDBXParameterDirection;
begin
  Result := FParameterDirection;
end;

function TDBXValueType.GetPrecision: Int64;
begin
  Result := FPrecision;
end;

function TDBXValueType.GetScale: TInt32;
begin
  Result := FScale;
end;

function TDBXValueType.GetSize: Int64;
begin
  Result := FSize;
end;

function TDBXValueType.GetSubType: TDBXType;
begin
  Result := FSubType;
end;

function TDBXValueType.IsAutoIncrement: Boolean;
begin
  Result := (GetFlags and TInt32(TDBXValueTypeFlags.AutoIncrement)) <> 0;
end;

//function TDBXValueType.IsBlobSizeExact: Boolean;
//begin
//  Result := (GetFlags and TInt32(TDBXValueTypeFlags.BlobSizeExact)) <> 0;
//end;

function TDBXValueType.IsNullable: Boolean;
begin
  Result := (GetFlags and TInt32(TDBXValueTypeFlags.Nullable)) <> 0;
end;

function TDBXValueType.IsReadOnly: Boolean;
begin
  Result := (GetFlags and TInt32(TDBXValueTypeFlags.ReadOnly)) <> 0;
end;

function TDBXValueType.IsReadOnlyType: Boolean;
begin
  Result := (GetFlags and TInt32(TDBXValueTypeFlags.ReadOnlyType)) <> 0;
end;

function TDBXValueType.IsSearchable: Boolean;
begin
  Result := (GetFlags and TInt32(TDBXValueTypeFlags.Searchable)) <> 0;
end;

procedure TDBXValueType.SetChildPosition(ChildPosition: TInt32);
begin
  FailIfReadOnlyType;
  if ChildPosition <> FChildPosition then
  begin
    FChildPosition := ChildPosition;
    FModified := true;
  end;
end;

procedure TDBXValueType.SetDataType(DataType: TInt32);
begin
  FailIfReadOnlyType;
  if FDataType <> DataType then
  begin
    FDataType := DataType;
    FModified := true;
  end;
end;


procedure TDBXValueType.SetFlags(Flags: TInt32);
begin
  FailIfReadOnlyType;
  if FFlags <> Flags then
  begin
    FFlags := Flags;
    FModified := true;
  end;
end;

procedure TDBXValueType.SetSize(Size: Int64);
begin
  FailIfReadOnlyType;
  if FSize <> Size then
  begin
    FSize := Size;
    FModified := true;
  end;
end;

procedure TDBXValueType.SetPrecision(Precision: Int64);
begin
  FailIfReadOnlyType;
  FPrecision := Precision;
end;

procedure TDBXValueType.SetReadOnlyType;
begin
  SetFlags(FFlags or TDBXValueTypeFlags.ReadOnlyType);
end;

procedure TDBXValueType.SetScale(Scale: TInt32);
begin
  FailIfReadOnlyType;
  FScale := Scale;
end;

procedure TDBXValueType.SetName(const Name: WideString);
begin
  FailIfReadOnlyType;
  FName := Name;
end;


procedure TDBXValueType.SetNullable(NullableValue: Boolean);
begin
  FailIfReadOnlyType;
  if Nullable <> NullableValue then
  begin
    if NullableValue then
      FFlags := FFlags + TDBXValueTypeFlags.Nullable
    else
      FFlags := FFlags - TDBXValueTypeFlags.Nullable;

    FModified := true;
  end;

end;

procedure TDBXValueType.SetOrdinal(Ordinal: TInt32);
begin
  FailIfReadOnlyType;
  if FOrdinal <> Ordinal then
  begin
    FOrdinal := Ordinal;
    FModified := true;
  end;
end;

procedure TDBXValueType.SetSubType(SubType: TInt32);
begin
  FailIfReadOnlyType;
  FSubType := SubType;
end;

class function TDBXValueTypeEx.DataTypeName(DataType: TDBXType): WideString;
begin
  with TDBXDataTypes do
    case DataType of
      UnknownType         : Result := 'UNKNOWN';
      AnsiStringType      : Result := 'ZSTRING';
      DateType            : Result := 'DATE';
      BlobType            : Result := 'BLOB';
      BooleanType         : Result := 'BOOL';
      Int16Type           : Result := 'INT16';
      Int32Type           : Result := 'INT32';
      DoubleType          : Result := 'FLOAT';
      BcdType             : Result := 'BCD';
      BytesType           : Result := 'BYTES';
      TimeType            : Result := 'TIME';
//      DATETIME          : Result := 'DATETIME';
//      UINT16            : Result := 'UINT16';
      Uint32Type          : Result := 'UINT32';
//      FLOATIEEE         : Result := 'FLOATIEE';
      VarBytesType        : Result := 'VARBYTES';
//      LOCKINFO          : Result := 'LOCKINFO';
      CursorType          : Result := 'CURSOR';
      Int64Type           : Result := 'INT64';
      Uint64Type          : Result := 'UINT64';
      AdtType             : Result := 'ADT';
      ArrayType           : Result := 'ARRAY_TYPE';
      RefType             : Result := 'REF';
      TableType           : Result := 'TABLE';
      TimeStampType       : Result := 'TIMESTAMP';
//      FMTBCD            : Result := 'FMTBCD';
      WideStringType      : Result := 'WIDESTRING';
      else
        Result := 'UNKNOWN('+IntToStr(DataType)+')';
    end;
    Result := 'TDBXTypes.' + Result;
end;

class procedure TDBXValueTypeEx.InvalidTypeAccess(ExpectedDataType, DataType: TDBXType);
begin
  raise TDBXError.Create(
    TDBXErrorCodes.InvalidType,
    WideFormat(SInvalidTypeAccess,
                [ TDBXValueTypeEx.DataTypeName(ExpectedDataType),
                  TDBXValueTypeEx.DataTypeName(DataType)
                ]
              )
    );
end;


{ TDBXDriverRegistry }




constructor TDBXDriverRegistry.Create;
begin
  inherited Create;
  FDriverLoaders    := TWideStringList.Create;
  FDrivers          := TThreadList.Create;
end;

destructor TDBXDriverRegistry.Destroy;
begin
  inherited;
  FreeAllLoaders;
  FreeAndNil(FDriverLoaders);
  FreeAndNil(FDrivers);
end;


function TDBXDriverRegistry.FindDriver(List: TList;
  const DriverName: WideString): Integer;
var
  Index: TInt32;
  Driver: TDBXDriver;
begin
  Result := -1;
  for Index := 0 to List.Count - 1 do
  begin
    Driver := TDBXDriver(List[Index]);
    if SameText(Driver.DriverName, DriverName) then
    begin
      Result := Index;
      exit;
    end;
  end;
end;

procedure TDBXDriverRegistry.DriverLoadError(DriverDef: TDBXDriverDef; PackageName: WideString);
var
  UnitName: WideString;
  DBXContext: TDBXContext;
begin
  DBXContext := DriverDef.FDBXContext;


{$IF DEFINED(CLR)}
  DriverDef.FDriverProperties.GetRequiredValue(TDBXPropertyNames.DriverAssemblyLoader);
{$ELSE}
  DriverDef.FDriverProperties.GetRequiredValue(TDBXPropertyNames.DriverPackageLoader);
{$IFEND}
  UnitName := DriverDef.FDriverProperties
  .GetRequiredValue(TDBXPropertyNames.DriverUnit);

  DBXContext.Error(TDBXErrorCodes.DriverInitFailed,
  WideFormat(SDriverLoadError, [DriverDef.FDriverName, UnitName, PackageName]));
end;

procedure SplitTypeIntoClassAndPackage(var ClassName: WideString; var PackageName: WideString);
var
  Pos: Integer;
begin
  for Pos := 1 to Length(ClassName) do
  begin
    if ClassName[Pos] = ',' then
    begin
      PackageName := Copy(ClassName,Pos+1,Length(ClassName)-Pos);
      ClassName := Copy(ClassName,1,Pos-1);
      break;
    end;
  end;
end;

function RegisterClassLoader(DriverDef: TDBXDriverDef; ClassNameProp: WideString; ClassNameDefault: WideString; PackageNameProp: WideString; PackageDefault: WideString; out ResultPackageName: WideString): WideString;
var
  ClassRegistry: TClassRegistry;
  ClassName: WideString;
  PackageName: WideString;
begin
  ClassName := DriverDef.FDriverProperties.GetValue(ClassNameProp);
  PackageName := DriverDef.FDriverProperties.GetValue(PackageNameProp);
  SplitTypeIntoClassAndPackage(ClassName, PackageName);
  if ClassName = '' then
    ClassName := ClassNameDefault;
  if PackageName = '' then
    PackageName := PackageDefault;

  if ClassName <> '' then
  begin
    ClassRegistry := TClassRegistry.GetClassRegistry;
    if not ClassRegistry.HasClass(ClassName) then
    begin
{$IF DEFINED(CLR)}
      ClassRegistry.RegisterPackageClass(ClassName, PackageName);
{$ELSE}
      if ModuleIsPackage then
      begin
        ClassRegistry.RegisterPackageClass(ClassName, PackageName);
      end;
{$IFEND}
    end;
  end;

  Result := ClassName;
  ResultPackageName := PackageName;
end;

function TDBXDriverRegistry.LoadDriver(DriverDef: TDBXDriverDef; List: TList): TDBXDriver;
var
  Index: Integer;
  DriverLoader: TDBXDriverLoader;
  MetaDataClassName: WideString;
  MetaDataPackageName: WideString;
begin
  Result := nil;
  for Index := 0 to FDriverLoaders.Count - 1 do
  begin
    DriverLoader := TDBXDriverLoader(FDriverLoaders.Objects[Index]);
    Result := DriverLoader.Load(DriverDef);
    if Result <> nil then
      begin
        Result.FDriverLoader := DriverLoader;
        Result.SetDriverName(DriverDef.FDriverName);
        Result.SetDriverProperties(DriverDef.FDriverProperties);
{$IF DEFINED(CLR)}
        MetaDataClassName := RegisterClassLoader(DriverDef, TDBXPropertyNamesEx.MetaDataAssemblyLoader, '', '', '', MetaDataPackageName);
{$ELSE}
        MetaDataClassName := RegisterClassLoader(DriverDef, TDBXPropertyNamesEx.MetaDataPackageLoader, '', '', '', MetaDataPackageName);
{$IFEND}
        if MetaDataClassName <> '' then
          TDBXDriverEx(Result).LoadMetaDataCommandFactory(MetaDataClassName, MetaDataPackageName);
        List.Add(Result);
        break;
      end;
  end;
end;

function TDBXDriverRegistry.GetDriver(DriverDef: TDBXDriverDef): TDBXDriver;
var
  List: TList;
  Index: Integer;
  ClassName: WideString;
  PackageName: WideString;
  ClassRegistry: TClassRegistry;
  LoaderObject: TObject;
begin
  List := FDrivers.LockList;
  try
    Index := FindDriver(List, DriverDef.FDriverName);
    if Index < 0 then begin
      Result := LoadDriver(DriverDef, List);
      if Result = nil then begin
        ClassRegistry := TClassRegistry.GetClassRegistry;
{$IF DEFINED(CLR)}
        ClassName := RegisterClassLoader(DriverDef, TDBXPropertyNames.DriverAssemblyLoader, DefaultDriverClassName, TDBXPropertyNames.DriverAssembly, DefaultDriverPackageName, PackageName);
{$ELSE}
        ClassName := RegisterClassLoader(DriverDef, TDBXPropertyNames.DriverPackageLoader, DefaultDriverClassName, TDBXPropertyNames.DriverPackage, DefaultDriverPackageName, PackageName);
{$IFEND}
        if ClassRegistry.HasClass(ClassName) then begin
          LoaderObject := ClassRegistry.CreateInstance(ClassName);
//        InternalRegisterLoader(ClassName, TDBXDriverLoader(ClassRegistry.CreateInstance(ClassName)));
          InternalRegisterLoader(ClassName, LoaderObject as TDBXDriverLoader);
          Result := LoadDriver(DriverDef, List);
        end;
      end;

      Index := FindDriver(List, DriverDef.FDriverName);
    end;
    Result := nil;
    if Index >= 0 then
    begin
      Result := TDBXDriver(List[Index]);
      Result.SetDriverProperties(DriverDef.FDriverProperties);
    end;
  finally
    FDrivers.UnlockList;
  end;

  if Result = nil then
    DriverLoadError(DriverDef, PackageName);
end;

//procedure TDBXDriverRegistry.InternalRegisterLoaderClass(LoaderName: WideString;
//LoaderClass: TDBXDriverLoaderClass);
//var
//  Index: Integer;
//  LoaderItem: TDBXLoaderClassItem;
//begin
//  inc(FCounter);
//  FDrivers.LockList;
//  try
//    Index := FDriverLoaderClasses.IndexOf(LoaderName);
//    if Index >= 0 then
//      raise TDBXError.Create(TDBXErrorCodes.DRIVER_INIT_FAILED, 'Driver already registered:  ' + LoaderName);
//    LoaderItem := TDBXLoaderClassItem.Create;
//    LoaderItem.FClassName := LoaderName;
//    LoaderItem.FClass     := LoaderClass;
//    FDriverLoaderClasses.AddObject(LoaderName, LoaderItem);
//  finally
//    FDrivers.UnlockList;
//  end;
//end;

procedure TDBXDriverRegistry.InternalRegisterLoader(const LoaderClassName: WideString; Loader: TDBXDriverLoader);
var
  Index: Integer;
begin
  inc(FCounter);
  FDrivers.LockList;
  try
    Index := FDriverLoaders.IndexOf(Loader.FLoaderName);
    if Index >= 0 then
      raise TDBXError.Create(TDBXErrorCodes.DriverInitFailed, 'Driver already registered:  ' + Loader.FLoaderName);
    Loader.FLoaderName := LoaderClassName;
    FDriverLoaders.AddObject(Loader.FLoaderName, Loader);
  finally
    FDrivers.UnlockList;
  end;
end;

procedure TDBXDriverRegistry.FreeDriver(Driver: TDBXDriver);
var
  Index: Integer;
  List: TList;
begin
  List := FDrivers.LockList;
  try
    Index := FindDriver(List, Driver.DriverName);
    Assert(Index > -1);
    if Index > -1 then
    begin
      List.Delete(Index);
      Driver.Close;
      Driver.Free;
    end;
  finally
    FDrivers.UnlockList;
  end;
end;

procedure TDBXDriverRegistry.CloseAllDrivers;
var
  List: TList;
  Index: TInt32;
  Driver: TDBXDriver;
begin
  List := FDrivers.LockList;
  try
    Index := 0;
    while Index < List.Count do
      begin
        Driver := TDBXDriver(List[Index]);
        Driver.Close;
        inc(Index);
      end;
  finally
    FDrivers.UnlockList;
  end;
end;

procedure TDBXDriverRegistry.FreeAllDrivers(Loader: TDBXDriverLoader);
var
  List: TList;
  Index: TInt32;
  Driver: TDBXDriver;
begin
  List := FDrivers.LockList;
  try
    Index := 0;
    while Index < List.Count do
      begin
        Driver := TDBXDriver(List[Index]);
        if Driver.FDriverLoader = Loader then
        begin
          List.Delete(Index);
          Driver.Free;
        end else
          inc(Index);
      end;
  finally
    FDrivers.UnlockList;
  end;
end;

procedure TDBXDriverRegistry.FreeAllLoaders;
begin
  FDrivers.LockList;
  try

    while FDriverLoaders.Count > 0 do
    begin
      FreeAllDrivers(TDBXDriverLoader(FDriverLoaders.Objects[FDriverLoaders.Count-1]));
      FDriverLoaders.Objects[FDriverLoaders.Count-1].Free;
      FDriverLoaders.Delete(FDriverLoaders.Count-1);
    end;
  finally
    FDrivers.UnlockList;
  end;

end;


//class procedure TDBXDriverRegistry.UnregisterLoader(Loader: TDBXDriverLoader);
//begin
//  if DBXDriverRegistry <> nil then
//    DBXDriverRegistry.InternalUnregisterLoader(Loader);
//end;

//procedure TDBXDriverRegistry.InternalUnregisterLoader(Loader: TDBXDriverLoader);
//var
//  Index: Integer;
//begin
//  Index := FDriverLoaders.IndexOf(Loader.FLoaderName);
//  if Index >= 0 then
//    FDriverLoaders.Delete(Index);
//end;

//class procedure TDBXDriverRegistry.RegisterLoaderClass(LoaderClassName: WideString; LoaderClass: TDBXDriverLoaderClass);
//begin
//  if DBXDriverRegistry = nil then
//    DBXDriverRegistry := TDBXDriverRegistry.Create;
//  DBXDriverRegistry.InternalRegisterLoaderClass(LoaderClassName, LoaderClass);
//end;

{ TDBXConnection }

constructor TDBXConnection.Create(ConnectionBuilder:  TDBXConnectionBuilder);
begin
  inherited Create;
  FDriverDelegate       := ConnectionBuilder.FDelegateDriver;
  FConnectionProperties := ConnectionBuilder.ConnectionProperties;
  FDBXContext      := TDBXContext.Create;
  if ConnectionBuilder.FDBXContext <> nil then
  begin
    FDBXContext.OnError := ConnectionBuilder.FDBXContext.OnError;
    FDBXContext.OnTrace := ConnectionBuilder.FDBXContext.OnTrace;
    FDBXContext.TraceFlags := ConnectionBuilder.FDBXContext.TraceFlags;
//    FDBXContext.FOnErrorDBXContext := ConnectionBuilder.FDBXContext.FOnErrorDBXContext;
//    FDBXContext.FOnTraceDBXContext := ConnectionBuilder.FDBXContext.FOnTraceDBXContext;
  end;
end;



destructor TDBXConnectionEx.Destroy;
begin
  FreeAndNil(FMetaDataReader);
  inherited Destroy;
end;

function TDBXConnectionEx.CreateMorphCommand(MorphicCommand: TDBXCommand): TDBXCommand;
begin
  Result := TDBXDriverEx(FDriverDelegate).CreateMorphCommand(FDBXContext, Self, MorphicCommand);
end;

function TDBXConnection.CreateCommand: TDBXCommand;
begin
  Result := DerivedCreateCommand;
  if DatabaseMetaData.SupportsRowSetSize then
    Result.SetRowSetSize(DBXDefaultRowSetSize);
end;


procedure TDBXConnection.Open;
begin
  DerivedOpen;
  DatabaseMetaData;
  FOpen := true;
end;

procedure TDBXConnection.Close;
begin
  while FTransactionStack <> nil do
    RollbackFreeAndNil(FTransactionStack);
  SetTraceInfoEvent(nil);
  FreeAndNil(FDatabaseMetaData);
  FOpen := false;
end;

destructor TDBXConnection.Destroy;
begin
  Close;
  FreeAndNil(FDriverDelegate);
  FreeAndNil(FDBXContext);
  inherited;
end;


function TDBXConnection.HasTransaction(Transaction: TDBXTransaction): Boolean;
var
  Current: TDBXTransaction;
begin
  Current := FTransactionStack;
  while Current <> nil do
  begin
    if Current = Transaction then
    begin
      Result := true;
      exit;
    end;
    Current := Current.FNext;
  end;
  Result := False;
end;


procedure TDBXConnection.CheckTransaction(Transaction: TDBXTransaction);
begin
  if HasTransaction(Transaction) = False then
    FDBXContext.Error(TDBXErrorCodes.InvalidArgument, sInvalidTransaction);
end;

procedure TDBXConnection.FreeTransactions(StartTransaction: TDBXTransaction);
var
  Current: TDBXTransaction;
  Next:   TDBXTransaction;
begin
  Current := FTransactionStack;
  while (Current <> nil)  do
  begin
    Next := Current.FNext;
    Current.FConnection := nil;
    Current.Free;
    if (Current = StartTransaction) then
    begin
      Current := Next;
      break;
    end;
    Current := Next;
  end;
  FTransactionStack := Current;
end;

function TDBXConnection.GetDatabaseMetaData: TDBXDatabaseMetaData;
begin
  if FDatabaseMetaData = nil then
  begin
    FDatabaseMetaData := TDBXDatabaseMetaDataEx.Create(FDBXContext);
    FDatabaseMetaData.Init(Self);
  end;
  Result := FDatabaseMetaData;
end;

function TDBXConnection.GetTraceFlags: TDBXTraceFlag;
begin
  Result := FDBXContext.TraceFlags;
end;

function TDBXConnection.GetTraceInfoEvent: TDBXTraceEvent;
begin
  Result := FDBXContext.OnTrace;
end;


function TDBXConnection.BeginTransaction(
  Isolation: TDBXIsolation): TDBXTransaction;
begin
  Result := CreateAndBeginTransaction(Isolation);
  Result.FConnection := Self;
  if FTransactionStack <> nil then
    Result.FNext := FTransactionStack;
  FTransactionStack := Result;
end;

function TDBXConnection.BeginTransaction: TDBXTransaction;
begin
  Result := BeginTransaction(FIsolationLevel);
end;

procedure TDBXConnection.CommitFreeAndNil(var Transaction: TDBXTransaction);
begin
  CheckTransaction(Transaction);
  Commit(Transaction);
  FreeTransactions(Transaction);
  Transaction := nil;
end;

procedure TDBXConnection.RollbackFreeAndNil(var Transaction: TDBXTransaction);
begin
  CheckTransaction(Transaction);
  Rollback(Transaction);
  FreeTransactions(Transaction);
  Transaction := nil;
end;
procedure TDBXConnection.RollbackIncompleteFreeAndNil(var Transaction: TDBXTransaction);
begin
  if HasTransaction(Transaction) then
    RollbackFreeAndNil(Transaction);
  Transaction := nil;
end;



procedure TDBXConnection.GetCommandTypes(List: TWideStrings);
begin
  // The minimum types that must be supported by a driver.
  //
  List.Add(TDBXCommandTypes.DbxSQL);
  List.Add(TDBXCommandTypes.DbxStoredProcedure);
  List.Add(TDBXCommandTypes.DbxTable);
  List.Add(TDBXCommandTypes.DbxMetaData);
  DerivedGetCommandTypes(List);
end;

procedure TDBXConnection.GetCommands(const CommandType: WideString;
  List: TWideStrings);
begin
  if CommandType = TDBXCommandTypes.DbxMetaData then
  begin
    List.Add(TDBXMetaDataCommands.GetDatabase);
    List.Add(TDBXMetaDataCommands.GetTables);
    List.Add(TDBXMetaDataCommands.GetColumns);
    List.Add(TDBXMetaDataCommands.GetIndexes);
    List.Add(TDBXMetaDataCommands.GetPackages);
    List.Add(TDBXMetaDataCommands.GetProcedures);
    List.Add(TDBXMetaDataCommands.GetProcedureParameters);
    List.Add(TDBXMetaDataCommands.GetUsers);
    if Self is TDBXConnectionEx then
//     FDriverDelegate.HasDBX4MetaData then
    begin
      List.Add(TDBXMetaDataCommands.GetDataTypes);
      List.Add(TDBXMetaDataCommandsEx.GetCatalogs);
      List.Add(TDBXMetaDataCommandsEx.GetSchemas);
      List.Add(TDBXMetaDataCommandsEx.GetViews);
      List.Add(TDBXMetaDataCommandsEx.GetSynonyms);
      List.Add(TDBXMetaDataCommands.GetForeignKeys);
      List.Add(TDBXMetaDataCommands.GetForeignKeyColumns);
      List.Add(TDBXMetaDataCommands.GetIndexColumns);
      List.Add(TDBXMetaDataCommandsEx.GetPackageSources);
      List.Add(TDBXMetaDataCommandsEx.GetProcedureSources);
      List.Add(TDBXMetaDataCommandsEx.GetRoles);
      List.Add(TDBXMetaDataCommandsEx.GetReservedWords);
    end;
  end;
  DerivedGetCommands(CommandType, List);
end;

function TDBXConnection.GetConnectionProperties: TDBXProperties;
begin
  Result := FConnectionProperties;
end;

function TDBXConnection.GetErrorEvent: TDBXErrorEvent;
begin
  Result := FDBXContext.OnError;
end;

function TDBXConnection.GetIsOpen: Boolean;
begin
  Result := FOpen;
end;

function TDBXConnectionEx.GetProductVersion: WideString;
var
  ProductVersionProperty: WideString;
begin
  if not FProductVersionInitialized then
  begin
    ProductVersionProperty := FDriverDelegate.DriverProperties[TDBXPropertyNamesEx.ProductVersion];
    if ProductVersionProperty <> '' then
      FProductVersion := ProductVersionProperty
    else
      FProductVersion := GetVendorProperty(TDBXPropertyNamesEx.ProductVersion);
    FProductVersionInitialized := true;
  end;
  Result := FProductVersion;
end;

function TDBXConnectionEx.GetProductName: WideString;
begin
  Result := FDriverDelegate.DriverProperties[TDBXPropertyNamesEx.ProductName];
  if Result = '' then
  begin
    Result := GetVendorProperty(TDBXPropertyNamesEx.ProductName);
    if Result = '' then
      Result := FConnectionProperties[TDBXPropertyNames.DriverName];
  end;
end;

function TDBXConnectionEx.GetConnectionProperty(const Name: WideString): WideString;
begin
  Result := FConnectionProperties[Name];
end;

function TDBXConnectionEx.GetVendorProperty(const Name: WideString): WideString;
begin
  Result := '';
end;

procedure TDBXConnection.SetErrorEvent(ErrorEvent: TDBXErrorEvent);
begin
  FDBXContext.OnError := ErrorEvent;
end;

procedure TDBXConnection.SetConnectionProperties(const Value: TDBXProperties);
begin
  FConnectionProperties := Value;
end;

procedure TDBXConnection.SetTraceFlags(TraceFlags: TDBXTraceFlag);
begin
  FDBXContext.TraceFlags := TraceFlags;
end;

procedure TDBXConnection.SetTraceInfoEvent(TraceInfoEvent: TDBXTraceEvent);
begin
  FDBXContext.OnTrace := TraceInfoEvent;
end;

{$IF NOT DEFINED(CLR)}
procedure TDBXConnection.GetCommands(const CommandType: WideString;
  List: TStrings);
var
  WideStrings: TWideStrings;
  I: Integer;
begin
  WideStrings := TWideStringList.Create;
  try
    GetCommands(CommandType, WideStrings);
    for I := 0 to WideStrings.Count - 1 do
      List.Add(WideStrings[I]);
  finally
    WideStrings.Free;
  end;

end;
{$IFEND}

{$IF NOT DEFINED(CLR)}
procedure TDBXConnection.GetCommandTypes(List: TStrings);
var
  WideStrings: TWideStrings;
  I: Integer;
begin
  WideStrings := TWideStringList.Create;
  try
    GetCommandTypes(WideStrings);
    for I := 0 to WideStrings.Count - 1 do
      List.Add(WideStrings[I]);
  finally
    WideStrings.Free;
  end;

end;
{$IFEND}

{ TDBXCommand }

function TDBXCommand.CreateParameter: TDBXParameter;
begin
  Result := TDBXParameterEx.Create(FDbxContext);
end;

function TDBXCommand.CreateParameterRow: TDBXRow;
begin
  NotImplemented;
  Result := nil;
end;

procedure TDBXCommand.CreateParameters(Command: TDBXCommand);
begin
  FParameters   := TDBXParameterList.Create(FDBXContext, Command);
end;

constructor TDBXCommand.Create(DBXContext: TDBXContext);
begin
  inherited Create;
  FCommandType := TDBXCommandTypes.DbxSQL;
  FDBXContext  := DBXContext;
end;

destructor TDBXCommand.Destroy;
begin
  Close;
  inherited;
end;

procedure TDBXCommand.SetCommandType(const CommandType: WideString);
begin
  if FCommandType <> CommandType then
  begin
    if FOpen then
      Close;
    FCommandType := CommandType;
  end;
end;

procedure TDBXCommand.SetParameters;
var
  HighParam:    Integer;
  Ordinal:      Integer;
begin
  HighParam := FParameters.Count -1;
  for Ordinal := 0 to HighParam do
    FParameters[Ordinal].SetParameter;
end;

function TDBXCommand.ExecuteQuery: TDBXReader;
begin
  if FText = '' then
    FDBXContext.Error(TDBXErrorCodes.InvalidOperation, SNoStatementToExecute);
  CommandExecuting;
  Result := DerivedExecuteQuery;
  if Result <> nil then
    Result.FCommand := Self;
  FLastReader := Result;
  CommandExecuted;
end;

procedure TDBXCommand.ExecuteUpdate;
begin
  if FText = '' then
    FDBXContext.Error(TDBXErrorCodes.InvalidOperation, SNoStatementToExecute);
  CommandExecuting;
  DerivedExecuteUpdate;
  CommandExecuted;
end;

procedure TDBXCommand.CloseReader;
begin
  if FLastReader <> nil then
  begin
    FLastReader.FCommand := nil;
    FLastReader.Close;
    FLastReader := nil;
  end;
end;

procedure TDBXCommand.CommandExecuted;
begin
  if (FParameters <> nil) and (FParameters.FParameterRow <> nil) then
    inc(FParameters.FParameterRow.FGeneration);
end;

procedure TDBXCommand.CommandExecuting;
begin
  Open;
  CloseReader;
  if (FParameters <> nil) and (FParameters.Count > 0) then
  begin
    if not FPrepared then
      Prepare;
    SetParameters;
  end;
end;

function TDBXCommand.GetCommandType: WideString;
begin
  Result := FCommandType;
end;

function TDBXCommand.GetErrorEvent: TDBXErrorEvent;
begin
  Result := FDBXContext.OnError;
end;


function TDBXCommand.GetNextReader: TDBXReader;
begin
  CloseReader;
  Result := DerivedGetNextReader;
  if Assigned(Result) then
    Result.FCommand := Self;
end;

function TDBXCommand.GetParameters: TDBXParameterList;
begin
  Open;
  if FParameters = nil then
    CreateParameters(Self);
  Result := FParameters;
end;

function TDBXCommand.GetText: WideString;
begin
  Result := FText;
end;


procedure TDBXCommand.Prepare;
begin
  Open;
  if FPrepared then
    FDBXContext.Error(TDBXErrorCodes.InvalidOperation, SAlreadyPrepared);

  DerivedPrepare;
  FPrepared := true;
end;

procedure TDBXCommand.SetText(const Value: WideString);
begin
    if FOpen then
  begin
    if    (FPrepared)
      and (FParameters <> nil)
      and (FParameters.Count > 0)
      and (FText <> Value) then
    begin
//      if FText <> '' then
        Close;
    end;
  end;
  FPrepared := false;
  FText := Value;
end;


procedure TDBXCommand.NotImplemented;
begin
  FDBXContext.Error(TDBXErrorCodes.NotImplemented, sNotImplemented);
end;

procedure TDBXCommand.Open;
begin
  if not FOpen then
  begin
    DerivedOpen;
    FOpen := true;
  end;
end;

procedure TDBXCommand.Close;
begin
  CloseReader;
  FreeAndNil(FParameters);
  if FOpen then
  begin
    DerivedClose;
    FOpen := false;
    FPrepared := false;
  end;
end;

{ TDBXReader }

procedure TDBXReader.Close;
var
  Ordinal:      TInt32;
begin
  DerivedClose;
  if not FClosed then
  begin
    if FByteReader <> FDBXContext.ClosedByteReader then
      FreeAndNil(FByteReader);
    FByteReader := FDBXContext.ClosedByteReader;
    if Length(FValues) > 0 then
    begin
      for Ordinal := 0 to High(FValues) do
        begin
          FValues[Ordinal].Free;
          FValues[Ordinal] := nil;
        end;
    end;
    FValueCount := ClosedReaderCount;
  end;
  FClosed := true;
end;

constructor TDBXReader.Create(DBXContext: TDBXContext; DbxRow: TDBXRow; ByteReader: TDBXByteReader);
begin
  inherited Create;
  FDBXContext := DBXContext;
  FDbxRow     := DbxRow;
  FByteReader := ByteReader;
  FValueCount := NewReaderCount
end;

destructor TDBXReader.Destroy;
begin
  if FCommand <> nil then
  begin
    FCommand.CloseReader;
    FCommand := nil;
  end;
  FreeAndNil(FDbxRow);
  FValues := nil;
  inherited;
end;

procedure TDBXReader.FailIfClosed;
begin
  if FClosed then
    FDBXContext.Error(TDBXErrorCodes.NoData, SReaderClosed);
end;

function TDBXReader.Next: Boolean;
begin
  if FValueCount < 0 then
  begin
    if FValueCount = NewReaderCount then
      FValueCount := Length(FValues)
    else
    begin
      Result := false;
      Exit;
    end;
  end;
  if DerivedNext then
    begin
      inc(FDbxRow.FGeneration);
      Result := true;
    end
  else
    begin
      // Unidirectional so free up underlying resources.
      //
      FCommand.CloseReader;
      Result := false;
    end;
end;


//procedure TDBXReader.SetColumnCount(ColumnCount: TInt32);
//begin
//  FValues := Values;
//end;

procedure TDBXReader.SetValues(Values: TDBXValueArray);
begin
  FValues := Values;
end;

{ TDBXTransaction }

constructor TDBXTransaction.Create;
begin
  inherited Create;
end;

destructor TDBXTransaction.Destroy;
begin
  if FConnection <> nil then
  begin
    try
      FConnection.RollbackIncompleteFreeAndNil(Self);
    except
      // Ignore it.  We tried to clean up resources.
      //
      on Error : Exception do
        ;
    end;
  end;
  inherited;
end;

{ TDBXParameters }

procedure TDBXParameterList.AddParameter(Parameter: TDBXParameter);
begin
  if FParameterRow = nil then
    FParameterRow := FCommand.CreateParameterRow;
  Parameter.SetDbxRow(FParameterRow);
  FValueTypes.Add(Parameter);
end;

procedure TDBXParameterList.SetParameter(Ordinal: Integer;
  Parameter: TDBXParameter);
begin
  if FParameterRow = nil then
    FParameterRow := FCommand.CreateParameterRow;
  Parameter.SetDbxRow(FParameterRow);
  FValueTypes.SetValueType(Ordinal, Parameter);
end;


procedure TDBXParameterList.SetCount(Count: TInt32);
begin
  FValueTypes.SetCount(Count);
end;


procedure TDBXParameterList.ClearParameters;
begin
  if Assigned(FValueTypes) then
    FValueTypes.Clear;
end;

constructor TDBXParameterList.Create(DBXContext: TDBXContext; Command: TDBXCommand);
begin
  inherited Create;
  FDBXContext       := DBXContext;
  FCommand          := Command;
  FValueTypes           := TDBXValueList.Create;
end;

destructor TDBXParameterList.Destroy;
begin
  FreeAndNil(FParameterRow);
  FreeAndNil(FValueTypes);
  inherited;
end;

{ TDBXValue }

constructor TDBXValue.Create(ValueType: TDBXValueType);
begin
  inherited Create;
  FValueType  := ValueType;
  FGeneration := -1;
  FOwnsType   := ValueType.IsReadOnlyType;
  FIsNull     := true;
  assert((FOwnsType) or (ValueType is TDBXParameter));
end;

class function TDBXValue.CreateValue(DBXContext: TDBXContext;
  ValueType: TDBXValueType; DbxRow: TDBXRow; ReadOnlyType: Boolean): TDBXValue;
begin
    if ReadOnlyType then
      ValueType.SetReadOnlyType;

    Result := nil;
    // Because parameters can be created and their values set before they are
    // associated with a command, we may not be able to create a custom value object
    // object at first.  When the command is eventually associated with
    // the command, any custom value object will be created if needed.
    //
    if DbxRow <> nil then
    begin
      if DbxRow is TDBXRowEx then
        Result := TDBXRowEx(DbxRow).CreateCustomValue(ValueType);
    end;

    if Result = nil then
    begin
      case ValueType.DataType of
        TDBXDataTypes.AnsiStringType:
            Result := TDBXAnsiStringBuilderValue.Create(ValueType);
        TDBXDataTypes.DateType:
            Result := TDBXDateValue.Create(ValueType);
        TDBXDataTypes.BooleanType:
            Result := TDBXBooleanValue.Create(ValueType);
        TDBXDataTypes.TimeType:
            Result := TDBXTimeValue.Create(ValueType);
        TDBXDataTypes.WideStringType:
            Result := TDBXWideStringBuilderValue.Create(ValueType);
        TDBXDataTypes.Int16Type:
            Result := TDBXInt16Value.Create(ValueType);
        TDBXDataTypes.Int32Type:
            Result := TDBXInt32Value.Create(ValueType);
        TDBXDataTypes.Int64Type:
            Result := TDBXInt64Value.Create(ValueType);
        TDBXDataTypes.DoubleType:
            Result := TDBXDoubleValue.Create(ValueType);
        TDBXDataTypes.BcdType:
            Result := TDBXBcdValue.Create(ValueType);
        TDBXDataTypes.VarBytesType,
        TDBXDataTypes.BytesType,
        TDBXDataTypes.AdtType,
        TDBXDataTypes.ArrayType,
        TDBXDataTypes.BlobType:
            case ValueType.SubType of
              TDBXDataTypes.HMemoSubType,
              TDBXDataTypes.MemoSubType:
                Result := TDBXAnsiMemoValue.Create(ValueType);
              TDBXDataTypes.WideMemoSubType:
                Result := TDBXWideMemoValue.Create(ValueType);
              else
                Result := TDBXStreamValue.Create(ValueType);
            end;
        TDBXDataTypes.CursorType:
            Result := TDBXCursorValue.Create(ValueType);
        TDBXDataTypes.TimeStampType:
            Result := TDBXTimeStampValue.Create(ValueType);
        else
          Result := nil;
          DBXContext.Error(TDBXErrorCodes.UnsupportedFieldType, WideFormat('Unexpected data type %s', [IntToStr(ValueType.DataType)]));
      end;
    end;
    ValueType.FDbxRow := DbxRow;
    Result.FDbxRow    := DbxRow;

end;

destructor TDBXValue.Destroy;
begin
  if FOwnsType then
    FValueType.Free;
  FValueType := nil;
  inherited;
end;


procedure TDBXValue.InvalidOperation;
begin
  // Should never get here.
  //
  ValueType.DBXContext.Error(TDBXErrorCodes.NotImplemented, sNotImplemented);
end;

constructor TDBXWritableValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
end;


destructor TDBXWritableValue.Destroy;
begin
  inherited;
end;

procedure TDBXWritableValue.SetBcd(const Value: TBcd);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.BcdType);
end;

procedure TDBXWritableValue.SetStaticBytes(Offset: Int64; const Buffer: array of Byte;
  BufferOffset, Length: Int64);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.BytesType);
end;

procedure TDBXWritableValue.SetDynamicBytes(Offset: Int64; const Buffer: TBytes; BufferOffset,
  Length: Int64);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.BytesType);
end;

procedure TDBXWritableValue.SetBoolean(Value: Boolean);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.BooleanType);
end;

procedure TDBXWritableValue.SetDate(Value: TDBXDate);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.DateType);
end;

//procedure TDBXWritableValue.SetDbxRow(DbxRow: TDBXRow);
//begin
//    FDbxRow := DbxRow;
//end;

procedure TDBXWritableValue.SetDouble(Value: Double);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.DoubleType);
end;

procedure TDBXWritableValue.SetInt16(Value: SmallInt);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.Int16Type);
end;

procedure TDBXWritableValue.SetInt32(Value: TInt32);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.Int32Type);
end;

procedure TDBXWritableValue.SetInt64(Value: Int64);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.Int64Type);
end;


procedure TDBXWritableValue.SetNull;
begin
  FIsNull := true;
  FSetPending := true;
end;

procedure TDBXWritableValue.SetPendingValue;
begin
  if FSetPending then
  begin
    if FIsNull then
      FDbxRow.SetNull(Self)
    else
      SetRowValue;
  end;
end;

procedure TDBXWritableValue.SetRowValue;
begin
  InvalidOperation;
end;

procedure TDBXWritableValue.SetAnsiString(const Value: String);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.AnsiStringType);
end;

procedure TDBXWritableValue.SetTime(Value: TDBXTime);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.TimeType);
end;

procedure TDBXWritableValue.SetTimeStamp(const Value: TSQLTimeStamp);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.TimeStampType);
end;

procedure TDBXWritableValue.SetWideString(const Value: WideString);
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.WideStringType);
end;

function TDBXValue.GetBcd: TBcd;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.BcdType);
  Result := NullBcd;
end;

function TDBXValue.GetBoolean: Boolean;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.BooleanType);
  Result := false;
end;

function TDBXValue.GetBytes(Offset: Int64; const Buffer: TBytes;
  BufferOffset, Length: Int64): Int64;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.BytesType);
  Result := 0;
end;

function TDBXValue.GetDate: TDBXDate;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.DateType);
  Result := 0;
end;

function TDBXValue.GetDbxContext: TDBXContext;
begin
  Result := FValueType.DBXContext;
end;

function TDBXValue.GetDouble: Double;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.DoubleType);
  Result := 0;
end;

function TDBXValue.GetInt16: SmallInt;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.Int16Type);
  Result := 0;
end;

function TDBXValue.GetInt32: TInt32;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.Int32Type);
  Result := 0;
end;

function TDBXValue.GetInt64: Int64;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.Int64Type);
  Result := 0;
end;

function TDBXValue.GetAnsiString: String;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.AnsiStringType);
  Result := '';
end;

function TDBXValue.GetTimeStamp: TSQLTimeStamp;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.TimeStampType);
  Result := NullSQLTimeStamp;
end;

function TDBXValue.GetValueSize: Int64;
begin
  Result := ValueType.Size;
end;

function TDBXValue.GetTime: TDBXTime;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.TimeType);
  Result := 0;
end;


function TDBXValue.GetWideString: WideString;
begin
  TDBXValueTypeEx.InvalidTypeAccess(ValueType.DataType, TDBXDataTypes.WideStringType);
  Result := '';
end;

procedure TDBXWritableValue.UpdateType;
begin
end;


function TDBXReader.GetByteReader: TDBXByteReader;
begin
  Result := FByteReader;
end;

function TDBXReader.GetColumnCount: TInt32;
begin
  Result := Length(FValues);
end;

function TDBXReader.GetErrorEvent: TDBXErrorEvent;
begin
  Result := FDBXContext.OnError;
end;


// place this in a separate method to avoid the hit
// of string finalization in frequently called method(s).
//
procedure TDBXReader.InvalidName(const Name: WideString; const Ordinal: TInt32);
begin
  raise TDBXError.Create(TDBXErrorCodes.InvalidOrdinal,
                          WideFormat(SInvalidOrdinal, [Ordinal]));

end;

procedure TDBXReader.InvalidOrdinal(const Ordinal: TInt32);
begin
  if Ordinal = ClosedReaderCount then
    FDBXContext.Error(TDBXErrorCodes.NoData, SReaderClosed);

  if Ordinal = NewReaderCount then
    FDBXContext.Error(TDBXErrorCodes.NoData, SReaderNew);

  raise TDBXError.Create(TDBXErrorCodes.InvalidOrdinal,
                             WideFormat(SInvalidOrdinal, [Ordinal]));
end;

function TDBXReader.GetValue(const Ordinal: TInt32): TDBXValue;
begin
  if (Ordinal < 0) or (Ordinal >= FValueCount) then
    InvalidOrdinal(Ordinal);
  Result := FValues[Ordinal];
end;

function TDBXReader.GetValueByName(const Name: WideString): TDBXValue;
begin
  Result := FValues[GetOrdinal(Name)];
end;

function TDBXReader.GetValueType(const Ordinal: TInt32): TDBXValueType;
begin
  FailIfClosed;
  if (Ordinal < 0) or (Ordinal >= Length(FValues)) then
    InvalidOrdinal(Ordinal);
  Result := FValues[Ordinal].FValueType;
end;

//function TDBXReader.GetValueTypeByName(const Name: WideString): TDBXValueType;
//begin
//  Result := GetValueType(GetOrdinal(Name));
//end;

function TDBXReader.GetObjectTypeName(Ordinal: TInt32): WideString;
begin
  Result := FDbxRow.GetObjectTypeName(Ordinal);
end;

function TDBXReader.GetOrdinal(const Name: WideString): TInt32;
begin
  // Simple optimization that always starts scanning from the Ordinal
  // position of the last found name.
  //
  Result := FindOrdinal(Name, FLastOrdinal, Length(FValues));
  if (Result < 0) then
  begin
    if (FLastordinal > 0) then
      Result := FindOrdinal(Name, 0, FLastOrdinal);
    if (Result < 0) then
      InvalidName(Name, Result);
  end;
end;

function TDBXReader.FindOrdinal(const Name: WideString; const StartOrdinal,
  EndOrdinal: TInt32): TInt32;
var
  Ordinal:      Integer;
begin
  for Ordinal := StartOrdinal to EndOrdinal - 1 do
  begin
    if WideCompareText(FValues[Ordinal].ValueType.Name, Name) = 0 then
    begin
      FLastOrdinal := Ordinal;
      Result := Ordinal;
      exit;
    end;
  end;
  Result := -1;
end;

function TDBXValueList.FindOrdinal(const Name: WideString; StartOrdinal,
  EndOrdinal: TInt32): TInt32;
var
  Ordinal:      Integer;
  CurrentName:  WideString;
begin
  for Ordinal := StartOrdinal to EndOrdinal - 1 do
  begin
    CurrentName := Values[Ordinal].Name;
    if WideCompareText(CurrentName, Name) = 0 then
    begin
      FLastOrdinal := Ordinal;
      Result := Ordinal;
      exit;
    end;
  end;
  Result := -1;
end;

procedure TDBXValueList.Add(ValueType: TDBXValueType);
var
  Count: TInt32;
begin
  Count := Length(FValueTypeArray);
  ValueType.Ordinal := Count;
  SetLength(FValueTypeArray, Count+1);
  FValueTypeArray[Count] := ValueType;
end;

procedure TDBXValueList.Clear;
var
  Index: Integer;
begin
  for Index := Low(FValueTypeArray) to High(FValueTypeArray) do
    FValueTypeArray[Index].Free;
  SetLength(FValueTypeArray, 0);
end;

destructor TDBXValueList.Destroy;
begin
  Clear;
  FValueTypeArray := nil;


  inherited;
end;

function TDBXValueList.GetCount: TInt32;
begin
  Result := Length(FValueTypeArray);
end;

function TDBXValueList.GetOrdinal(const Name: WideString): TInt32;
begin
  // Simple optimization that always starts scanning from the Ordinal
  // position of the last found name.
  //
  Result := FindOrdinal(Name, FLastOrdinal, Count);
  if (Result < 0) and (FLastordinal > 0) then
    Result := FindOrdinal(Name, 0, FLastOrdinal);
end;

function TDBXValueList.GetValueType(const Ordinal: TInt32): TDBXValueType;
begin
  Result := FValueTypeArray[Ordinal];
end;

procedure TDBXValueList.Insert(Ordinal: TInt32; ValueType: TDBXValueType);
var
  SourceOrdinal:    Integer;
  DestOrdinal:      Integer;
  Count:            Integer;
begin

  Count         := Length(FValueTypeArray);
  if (Ordinal < 0) or (Ordinal > Count) then
    raise ERangeError.Create('');
    
  SetLength(FValueTypeArray, Count+1);
  if Count > 0 then
  begin
    DestOrdinal   := Count;
    SourceOrdinal := DestOrdinal -1;
    while DestOrdinal > Ordinal do
    begin
      FValueTypeArray[DestOrdinal] := FValueTypeArray[SourceOrdinal];
      dec(DestOrdinal);
      dec(SourceOrdinal);
    end;
  end;
  FValueTypeArray[Ordinal] := ValueType;
end;

procedure TDBXValueList.Remove(ValueType: TDBXValueType);
begin
  Assert(ValueType = FValueTypeArray[ValueType.Ordinal]);
  Remove(ValueType.Ordinal);
end;

procedure TDBXValueList.Remove(Ordinal: TInt32);
var
  SourceOrdinal:    Integer;
  DestOrdinal:      Integer;
  Count:            Integer;
begin
  DestOrdinal   := Ordinal;
  SourceOrdinal := Ordinal+1;
  Count         := Length(FValueTypeArray);
  if (Ordinal < 0) or (Ordinal >= Count) then
    raise ERangeError.Create('');
  while SourceOrdinal < Count do
  begin
    FValueTypeArray[DestOrdinal] := FValueTypeArray[SourceOrdinal];
    inc(DestOrdinal);
    inc(SourceOrdinal);
  end;
  SetLength(FValueTypeArray, Count-1);
end;

procedure TDBXValueList.SetCount(Count: TInt32);
var
  Ordinal: Integer;
begin
  if FValueTypeArray <> nil then
  begin
    for Ordinal := Count to High(FValueTypeArray) do
      FValueTypeArray[Ordinal].Free;
  end;

  SetLength(FValueTypeArray, Count);
end;

procedure TDBXValueList.SetValueType(Ordinal: TInt32; ValueType: TDBXValueType);
begin
  ValueType.Ordinal := Ordinal;
  FValueTypeArray[Ordinal] := ValueType;
end;



{ TDBXDatabaseMetaData }

constructor TDBXDatabaseMetaData.Create(DBXContext: TDBXContext);
begin
  inherited Create;
  FDBXContext := DBXContext;
end;

procedure TDBXDatabaseMetaData.Init(Connection: TDBXConnection);
var
  Reader:   TDBXReader;
  Command:  TDBXCommand;
begin
  inherited Create;
  Reader    := nil;
  Command   := nil;
  try
    Command             := Connection.DerivedCreateCommand;
    Command.CommandType := TDBXCommandTypes.DbxMetaData;
    Command.Text        := TDBXMetaDataCommands.GetDatabase;
    Reader              := Command.ExecuteQuery;

    Reader.Next;

    FQuoteChar                  := Reader[TDBXMetaDatabaseColumnNames.QuoteChar].GetWideString;
    FProcedureQuoteChar         := Reader[TDBXMetaDatabaseColumnNames.ProcedureQuoteChar].GetWideString;
    FMaxCommands                := Reader[TDBXMetaDatabaseColumnNames.MaxCommands].GetInt32;
    FSupportsTransactions       := Reader[TDBXMetaDatabaseColumnNames.SupportsTransactions].GetBoolean;
    FSupportsNestedTransactions := Reader[TDBXMetaDatabaseColumnNames.SupportsNestedTransactions].GetBoolean;
    FSupportsRowSetSize         := Reader[TDBXMetaDatabaseColumnNames.SupportsRowSetSize].GetBoolean;

    // MetaData from a MetaDataProvider has more information:
    if Reader.ColumnCount >= 10 then
    begin
      TDBXDataBaseMetadataEx(Self).FMetaDataVersion              := DBXVersion40;
      TDBXDataBaseMetadataEx(Self).FQuotePrefix                  := Reader[TDBXMetaDatabaseColumnNames.QuotePrefix].GetWideString;
      TDBXDataBaseMetadataEx(Self).FQuoteSuffix                  := Reader[TDBXMetaDatabaseColumnNames.QuoteSuffix].GetWideString;
      TDBXDataBaseMetadataEx(Self).FSupportsLowerCaseIdentifiers := Reader[TDBXMetaDatabaseColumnNames.SupportsLowerCaseIdentifiers].GetBoolean;
      TDBXDataBaseMetadataEx(Self).FSupportsUpperCaseIdentifiers := Reader[TDBXMetaDatabaseColumnNames.SupportsUpperCaseIdentifiers].GetBoolean;
    end else if Self Is TDBXDataBaseMetadataEx then
      TDBXDataBaseMetadataEx(Self).FMetaDataVersion              := DBXVersion30;


  finally
    Reader.Free;
    Command.Free;
  end;
end;




{ TDBXParameterRow }


{ TDBXParameter }


constructor TDBXParameter.Create(DbxContext: TDBXContext);
begin
  inherited Create(DbxContext);
  ParameterDirection := TDBXParameterDirections.InParameter;
  FModified   := true;
end;

destructor TDBXParameter.Destroy;
begin
  Assert(     (FValue = nil)
          or (FValue.FValueType = nil)
          or  ((FValue.FValueType = Self) and (not FValue.FOwnsType))
          );
  FreeAndNil(FValue);
  inherited;
end;


function TDBXParameter.GetValue: TDBXWritableValue;
begin
  if FModified then
    UpdateParameterType(DataType);
  Result := FValue;
end;



procedure TDBXParameter.SetDbxRow(DbxRow: TDBXRow);
begin
  if FDbxRow <> DbxRow then
  begin
    FDbxRow := DbxRow;
    FModified := true;
  end;
end;

procedure TDBXParameter.SetParameter;
begin
  if FModified then
  begin
    UpdateParameterType(DataType);
  end;
  Value.SetPendingValue;
end;

procedure TDBXParameterEx.CopyByteValue(Source: TDBXValue; Dest: TDBXWritableValue);
var
  Buf: TBytes;
  Count: Integer;
begin
  Count := Integer(Source.GetValueSize);
  SetLength(Buf, Count);
  Source.GetBytes(0, Buf, 0, Count);
  Dest.SetDynamicBytes(0, Buf, 0, Count);
end;

procedure TDBXParameterEx.AssignValue(Source: TDBXValue);
begin
  if Assigned(Source) then
  begin
    if Source.IsNull then
      FValue.SetNull
    else
    begin
      // This should be more virtual, but I am not allowed to make interface
      // breaking changes in this release.
      //
      case DataType of
        TDBXDataTypes.AnsiStringType:
            FValue.SetAnsiString(Source.GetAnsiString);
        TDBXDataTypes.DateType:
            FValue.SetDate(Source.GetDate);
        TDBXDataTypes.BooleanType:
            FValue.SetBoolean(Source.GetBoolean);
        TDBXDataTypes.TimeType:
            FValue.SetTime(Source.GetTime);
        TDBXDataTypes.WideStringType:
            FValue.SetWideString(Source.GetWideString);
        TDBXDataTypes.Int16Type:
            FValue.SetInt16(Source.GetInt16);
        TDBXDataTypes.Int32Type:
            FValue.SetInt32(Source.GetInt32);
        TDBXDataTypes.Int64Type:
            FValue.SetInt64(Source.GetInt64);
        TDBXDataTypes.DoubleType:
            FValue.SetDouble(Source.GetDouble);
        TDBXDataTypes.BcdType:
            FValue.SetBcd(Source.GetBcd);
        TDBXDataTypes.VarBytesType,
        TDBXDataTypes.BytesType,
        TDBXDataTypes.AdtType,
        TDBXDataTypes.ArrayType,
        TDBXDataTypes.BlobType:
        begin
          case SubType of
            TDBXDataTypes.MemoSubType:
              FValue.SetAnsiString(Source.GetAnsiString);
            TDBXDataTypes.WideMemoSubType:
              FValue.SetWideString(Source.GetWideString);
            else
              CopyByteValue(Source, FValue);
          end;
        end;
        TDBXDataTypes.CursorType:
          ;
        TDBXDataTypes.TimeStampType:
            FValue.SetTimeStamp(Source.GetTimeStamp);
      end;
    end;
  end;
end;

function TDBXParameterEx.Clone: TObject;
var
  Copy: TDBXParameterEx;
begin
  Copy := TDBXParameterEx.Create(FDBXContext);
  Copy.Assign(Self);
  Result := Copy;
end;

procedure TDBXParameterEx.Assign(Source: TDBXParameter);
begin
  FName               := Source.FName;
  FOrdinal            := -1;
  FDataType           := Source.DataType;
  FSubType            := Source.SubType;
  FSize               := Source.FSize;
  FPrecision          := Source.FPrecision;
  FScale              := Source.FScale;
  FChildPosition      := 0;
  FFlags              := Source.FFlags;
  FParameterDirection := Source.FParameterDirection;
  FDbxRow             := nil;
  FModified           := true;
  FDBXContext         := Source.DBXContext;
  if Assigned(Source) then
  begin
    FValue              := TDBXWritableValue(TDBXValue.CreateValue(Source.DBXContext, Self, nil, false));
    AssignValue(Source.GetValue);
  end;
end;

procedure TDBXValueType.SetParameterDirection(ParameterDirection: TDBXParameterDirection);
begin
  FailIfReadOnlyType;
  if ParameterDirection <> FParameterDirection then
  begin
    FParameterDirection := ParameterDirection;
    FModified := true;
  end
end;

procedure TDBXParameter.UpdateParameterType(SetDataType: TDBXType);
var
  NewValue: TDBXValue;
  OldValue: TDBXWritableValue;
begin

  if DataType = TDBXDataTypes.UnknownType then
    DataType := SetDataType;

  if (FValue = nil) then
  begin
    if (DataType = TDBXDataTypes.UnknownType) then
      FValue := TDBXNullValue.Create(Self)
    else
      FValue := TDBXWritableValue(TDBXValue.CreateValue(FDBXContext, Self, FDbxRow, false));
  end;

  NewValue := nil;
  if FDbxRow <> nil then
  begin
    if FValue.FDbxRow = nil then
    begin
      FValue.FDbxRow := FDbxRow;
      if FDBXRow is TDBXRowEx then
      begin
        NewValue := TDBXRowEx(FDBXRow).CreateCustomValue(Self);
        if NewValue <> nil then
        begin
          OldValue := FValue;
          FValue := TDBXWritableValue(NewValue);
          FValue.FDbxRow := FDbxRow;
        end;
      end;
    end;
    FDbxRow.SetValueType(FValue.ValueType);
  end;

  FValue.UpdateType;

  if FDBXRow <> nil then
    FModified := false;

  if NewValue <> nil then
  begin
    try
      TDBXParameterEx(Self).AssignValue(OldValue);
    finally
      FreeAndNil(OldValue);
    end;
  end;

end;



function TDBXParameterList.GetCount: TInt32;
begin
  if Assigned(FValueTypes) then
    Result := FValueTypes.Count
  else
    Result := 0;
end;

function TDBXParameterList.GetOrdinal(const Name: WideString): Integer;
begin
  Result := FValueTypes.GetOrdinal(Name);
end;

function TDBXParameterList.GetParameterByName(
  const Name: WideString): TDBXParameter;
begin
  Result := GetParameterByOrdinal(GetOrdinal(Name));
end;

procedure TDBXParameterList.InvalidOrdinal(Ordinal: TInt32);
begin
    raise TDBXError.Create(TDBXErrorCodes.InvalidOrdinal,
                               WideFormat(SInvalidOrdinal, [Ordinal]));
end;

function TDBXParameterList.GetParameterByOrdinal(
  const Ordinal: TInt32): TDBXParameter;
var
  ValueType: TDBXValueType;
begin
  if (Ordinal < 0) or (Ordinal >= Count) then
    InvalidOrdinal(Ordinal);
  ValueType := FValueTypes[Ordinal];
  if ValueType = nil then
    Result := nil
  else
    Result := TDBXParameter(ValueType);
end;



procedure TDBXParameterList.InsertParameter(Ordinal: Integer;
  Parameter: TDBXParameter);
begin
  FValueTypes.Insert(Ordinal, Parameter);
end;


procedure TDBXParameterList.RemoveParameter(Parameter: TDBXParameter);
begin
  FValueTypes.Remove(Parameter.Ordinal);
end;

procedure TDBXParameterList.RemoveParameter(Ordinal: Integer);
begin
  FValueTypes.Remove(FValueTypes[Ordinal]);
end;

{ TDBXByteReader }

constructor TDBXByteReader.Create(DBXContext: TDBXContext);
begin
  inherited Create;
  FDBXContext := DBXContext;
end;


{ TDBXContext }


constructor TDBXContext.Create;
begin
  inherited Create;
  FTraceFlags := TDBXTraceFlags.Prepare
                  or TDBXTraceFlags.Execute
                  or TDBXTraceFlags.Error
                  or TDBXTraceFlags.Command
                  or TDBXTraceFlags.Connect
                  or TDBXTraceFlags.Blob
                  or TDBXTraceFlags.Misc
//                  or TDBXTraceFlags.VENDOR
                  or TDBXTraceFlags.Parameter
                  or TDBXTraceFlags.Reader
                  or TDBXTraceFlags.DriverLoad
                  ;
  FClosedByteReader   := TDBXClosedByteReader.Create(Self);
end;

constructor TDBXContext.Create(DBXContext: TDBXContext);
begin
  inherited Create;
  FOnError            := DBXContext.FOnError;
  FOnTrace            := DBXContext.FOnTrace;
  FTraceFlags         := DBXContext.FTraceFlags;
  FOnErrorDBXContext  := DBXContext.FOnErrorDBXContext;
  FOnTraceDBXContext  := DBXContext.FOnTraceDBXContext;
end;

destructor TDBXContext.Destroy;
begin
  FreeAndNil(FClosedByteReader);
  inherited;
end;

procedure TDBXContext.Error(ErrorCode: TDBXErrorCode;
  ErrorMessage: WideString);
var
  DBXError: TDBXError;
begin
  DBXError := TDBXError.Create(ErrorCode, ErrorMessage);

  if FOnErrorDBXContext <> nil then
    if Assigned(FOnErrorDBXContext.FOnError) then
    begin
      FOnErrorDBXContext.FOnError(DBXError);
    end;
  raise DBXError;
end;

function TDBXContext.isTracing(TraceFlags: TDBXTraceFlag): Boolean;
begin
  if FOnTraceDBXContext <> nil then
  begin
    if (FOnTraceDBXContext.FOnTraceDBXContext <> nil) and ((TraceFlags and FTraceFlags) <> 0) then
      Result := true
    else
      Result := false;
  end else
    Result := false;
end;

procedure TDBXContext.SetOnError(const Value: TDBXErrorEvent);
begin
  FOnError := Value;
  if Assigned(Value) then
    FOnErrorDBXContext := Self
  else
    FOnErrorDBXContext := nil;
end;

procedure TDBXContext.SetOnTrace(const Value: TDBXTraceEvent);
begin
  FOnTrace := Value;
  if Assigned(Value) then
    FOnTraceDBXContext := Self
  else
    FOnTraceDBXContext := nil;
end;

procedure TDBXContext.SetTraceFlags(const Value: TDBXTraceFlag);
begin
  FTraceFlags         := Value;
  FOnTraceDBXContext  := Self;
end;

function TDBXContext.Trace(TraceFlag: TDBXTraceFlag;
  TraceMessage: WideString): CBRType;
var
  TraceInfo:  TDBXTraceInfo;
begin
  if FOnTraceDBXContext <> nil then
  begin
    TraceInfo.Message   := TraceMessage;
    TraceInfo.TraceFlag := TraceFlag;
    Result := FOnTraceDBXContext.FOnTrace(TraceInfo);
  end else
    Result := cbrCONTINUE;
end;

{ TDBXDelegateDriver }

procedure TDBXDelegateDriver.Close;
begin

end;

constructor TDBXDelegateDriver.Create(Driver: TDBXDriver);
begin
  inherited Create;
  FDriver := Driver;
  Driver.AddReference;
end;

destructor TDBXDelegateDriver.Destroy;
begin
  if FDriver <> nil then
    FDriver.RemoveReference;
  FDriver := nil;
  inherited;
end;

function TDBXDelegateDriver.CreateMorphCommand(DbxContext: TDBXContext;
  Connection: TDBXConnection; MorphicCommand: TDBXCommand): TDBXCommand;
begin
  Result := TDBXDriverEx(FDriver).CreateMorphCommand(DbxContext, Connection, MorphicCommand);
end;

function TDBXDelegateDriver.CreateConnection(ConnectionBuilder: TDBXConnectionBuilder): TDBXConnection;
begin
  Result := FDriver.CreateConnection(ConnectionBuilder);
end;

function TDBXDelegateDriver.GetDriverName: WideString;
begin
  Result := FDriver.GetDriverName;
end;

function TDBXDelegateDriver.GetDriverProperties: TDBXProperties;
begin
  Result := FDriver.GetDriverProperties;
end;

function TDBXDelegateDriver.GetDriverVersion: WideString;
begin
  Result := FDriver.GetDriverVersion;
end;

procedure TDBXDelegateDriver.SetDriverName(const DriverName: WideString);
begin
  FDriver.SetDriverName(DriverName);
end;

procedure TDBXDelegateDriver.SetDriverProperties(DriverProperties: TDBXProperties);
begin
  FDriver.SetDriverProperties(DriverProperties);
end;

{ TDBXAnsiStringValue }

procedure TDBXAnsiStringBuilderValue.SetRowValue;
begin
  FDbxRow.SetString(Self, FString);
end;

procedure TDBXAnsiStringBuilderValue.SetAnsiString(const Value: String);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FString := Value;
  FSetPending := true;
end;

procedure TDBXAnsiStringBuilderValue.UpdateType;
begin
  // Add one because dynalink drivers will always set a null byte
  // even if the length is 0.
  //
  TDBXPlatform.ResizeStringBuilder(FStringBuilder, ValueType.Size+1);
end;

constructor TDBXAnsiStringBuilderValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
  // Add one because dynalink drivers will always set a null byte
  // even if the length is 0.
  //
  FStringBuilder      := TDBXPlatform.CreateStringBuilder(ValueType.Size+1);

end;

function TDBXAnsiStringBuilderValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetAnsiString(Self, FStringBuilder, FIsNull);
    TDBXPlatform.CopyStringBuilder(FStringBuilder, FString);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXAnsiStringBuilderValue.GetAnsiString: String;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetAnsiString(Self, FStringBuilder, FIsNull);
    TDBXPlatform.CopyStringBuilder(FStringBuilder, FString);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FString;
end;

destructor TDBXAnsiStringBuilderValue.Destroy;
begin
  TDBXPlatform.FreeAndNilStringBuilder(FStringBuilder);
  inherited;
end;


procedure TDBXAnsiStringValue.SetRowValue;
begin
  inherited;
end;

procedure TDBXAnsiStringValue.SetAnsiString(const Value: String);
begin
  inherited;
end;

procedure TDBXAnsiStringValue.UpdateType;
begin
  inherited;
end;

constructor TDBXAnsiStringValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
end;

function TDBXAnsiStringValue.IsNull: Boolean;
begin
  InvalidOperation;
  Result := false;
end;

destructor TDBXAnsiStringValue.Destroy;
begin
  inherited;
end;

function TDBXAnsiStringValue.GetAnsiString: String;
begin
  Result := '';
end;

{ TDBXAnsiMemoValue }

procedure TDBXAnsiMemoValue.SetAnsiString(const Value: String);
begin
  SetDynamicBytes(0, TDBXPlatform.StrToBytes(Value), 0, Length(Value));
end;


constructor TDBXAnsiMemoValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
end;


destructor TDBXAnsiMemoValue.Destroy;
begin
  FBytes := nil;
  inherited;
end;

function TDBXAnsiMemoValue.GetAnsiString: String;
begin
  GetFBytes;
  Result := string(FBytes);
end;

procedure TDBXAnsiMemoValue.GetFBytes;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetByteLength(Self, FByteLength, FIsNull);
    FGeneration := FDbxRow.Generation;
    if FIsNull then
      SetLength(FBytes, 0)
    else
    begin
      // Most of the drivers don't fail with no data if you ask for
      // the blob more than once.  If string is asked for, save it like
      // we do for other data types.
      //
      SetLength(FBytes, FByteLength);
      GetBytes(0, FBytes, 0, FByteLength);
      // ASA driver appends null for datatype=3 subtype=22.
      //
      if (FByteLength > 0) and (FBytes[FByteLength-1] = Byte(0)) then
        SetLength(FBytes, FByteLength-1);

      FGeneration := FDbxRow.Generation;
    end;
  end;
end;

function TDBXAnsiMemoValue.IsNull: Boolean;
begin
  GetFBytes;
  Result := FIsNull;
end;

{ TDBXDateValue }


procedure TDBXDateValue.SetDate(Value: TDBXDate);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FDate := Value;
  FSetPending := true;
end;

procedure TDBXDateValue.SetRowValue;
begin
  FDbxRow.SetDate(Self, FDate);
end;

function TDBXDateValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetDate(Self, FDate, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXDateValue.GetDate: TDBXDate;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetDate(Self, FDate, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FDate;
end;

{ TDBXBooleanValue }


procedure TDBXBooleanValue.SetBoolean(Value: Boolean);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FBoolean := Value;
  FSetPending := true;
end;

procedure TDBXBooleanValue.SetRowValue;
begin
  FDbxRow.SetBoolean(Self, FBoolean);
end;

function TDBXBooleanValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetBoolean(Self, FBoolean, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXBooleanValue.GetBoolean: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetBoolean(Self, FBoolean, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FBoolean;
end;

{ TDBXTimeValue }

function TDBXTimeValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetTime(Self, FTime, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

procedure TDBXTimeValue.SetRowValue;
begin
  FDbxRow.SetTime(Self, FTime);
end;

procedure TDBXTimeValue.SetTime(Value: TDBXTime);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FTime := Value;
  FSetPending := true;
end;

function TDBXTimeValue.GetTime: TDBXTime;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetTime(Self, FTime, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FTime;
end;

{ TDBXWideStringValue }

procedure TDBXWideStringValue.SetRowValue;
begin
end;

procedure TDBXWideStringValue.SetWideString(const Value: WideString);
begin
end;

procedure TDBXWideStringValue.UpdateType;
begin
end;

constructor TDBXWideStringValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
end;

function TDBXWideStringValue.IsNull: Boolean;
begin
  Result := true;
end;

destructor TDBXWideStringValue.Destroy;
begin
  TDBXPlatform.FreeAndNilWideStringBuilder(FWideStringBuilder);
  inherited;
end;

function TDBXWideStringValue.GetWideString: WideString;
begin
  Result := '';
end;

{ TDBXWideMemoValue }


procedure TDBXWideMemoValue.SetWideString(const Value: WideString);
begin
  SetDynamicBytes(0, TDBXPlatform.WideStrToBytes(Value), 0, Length(Value)*2);
end;


constructor TDBXWideMemoValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
  // Add one because dynalink drivers will always set a null byte
  // even if the length is 0.
  //
//  FStringBuilder      := TDBXPlatform.CreateStringBuilder(ValueType.Size+1);

end;

destructor TDBXWideMemoValue.Destroy;
begin
  FBytes := nil;
  inherited;
end;

function TDBXWideMemoValue.GetWideString: WideString;
begin
  GetFBytes;
//    Result := WideString(Buffer);
  Result := WideString(TDBXPlatform.BytesToWideStr(FBytes));
end;

function TDBXWideMemoValue.IsNull: Boolean;
begin
  GetFBytes;
  Result := FIsNull;
end;

procedure TDBXWideMemoValue.GetFBytes;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetByteLength(Self, FByteLength, FIsNull);
    if FIsNull then
      SetLength(FBytes, 0)
    else
    begin
      SetLength(FBytes, FByteLength);
      GetBytes(0, FBytes, 0, FByteLength);
      // ASA driver appends null for datatype=3 subtype=22. See TDBXAnsiMemoValue.getAnsiString.
      // Do it for wide strings also just in case.
      //
      if (FByteLength > 1)
      and (FBytes[FByteLength-1] = Byte(0))
      and (FBytes[FByteLength-2] = Byte(0)) then
      begin
        SetLength(FBytes, FByteLength-2);
      end;
    end;
    FGeneration := FDbxRow.Generation;
  end;
end;



procedure TDBXWideStringBuilderValue.SetRowValue;
begin
  FDbxRow.SetWideString(Self, FWideString);
end;

procedure TDBXWideStringBuilderValue.SetWideString(const Value: WideString);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FWideString := Value;
  FSetPending := true;
end;

procedure TDBXWideStringBuilderValue.UpdateType;
begin
  // Add one because dynalink drivers will always set a null byte
  // even if the length is 0.
  //
  TDBXPlatform.ResizeWideStringBuilder(FWideStringBuilder, ValueType.Size+1);
end;

constructor TDBXWideStringBuilderValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
  if (ValueType.GetFlags and TDBXValueTypeFlagsEx.ExtendedType) = 0 then
  begin
    // Add one because dynalink drivers will always set a null byte
    // even if the length is 0.
    //
    FWideStringBuilder  := TDBXPlatform.CreateWideStringBuilder(ValueType.Size+1);
  end;
end;

function TDBXWideStringBuilderValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetWideString(Self, FWideStringBuilder, FIsNull);
    TDBXPlatform.CopyWideStringBuilder(FWideStringBuilder, FWideString);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

destructor TDBXWideStringBuilderValue.Destroy;
begin
  TDBXPlatform.FreeAndNilWideStringBuilder(FWideStringBuilder);
  inherited;
end;

function TDBXWideStringBuilderValue.GetWideString: WideString;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetWideString(Self, FWideStringBuilder, FIsNull);
    TDBXPlatform.CopyWideStringBuilder(FWideStringBuilder, FWideString);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FWideString;
end;

{ TDBXInt16Value }


procedure TDBXInt16Value.SetInt16(Value: SmallInt);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FInt16 := Value;
  FSetPending := true;
end;

procedure TDBXInt16Value.SetRowValue;
begin
  FDbxRow.SetInt16(Self, FInt16);
end;

function TDBXInt16Value.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetInt16(Self, FInt16, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXInt16Value.GetInt16: SmallInt;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetInt16(Self, FInt16, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FInt16;
end;

{ TDBXInt32Value }


procedure TDBXInt32Value.SetInt32(Value: TInt32);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FInt32 := Value;
  FSetPending := true;
end;

procedure TDBXInt32Value.SetRowValue;
begin
  FDbxRow.SetInt32(Self, FInt32);
end;

function TDBXInt32Value.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetInt32(Self, FInt32, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXInt32Value.GetInt32: TInt32;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetInt32(Self, FInt32, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FInt32;
end;

{ TDBXInt64Value }


procedure TDBXInt64Value.SetInt64(Value: Int64);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FInt64 := Value;
  FSetPending := true;
end;

procedure TDBXInt64Value.SetRowValue;
begin
  FDbxRow.SetInt64(Self, FInt64);
end;

function TDBXInt64Value.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetInt64(Self, FInt64, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXInt64Value.GetInt64: Int64;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetInt64(Self, FInt64, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FInt64;
end;

{ TDBXDoubleValue }


procedure TDBXDoubleValue.SetDouble(Value: Double);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FDouble := Value;
  FSetPending := true;
end;

procedure TDBXDoubleValue.SetRowValue;
begin
  FDbxRow.SetDouble(Self, FDouble);
end;

function TDBXDoubleValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetDouble(Self, FDouble, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXDoubleValue.GetDouble: Double;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetDouble(Self, FDouble, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FDouble;
end;

{ TDBXByteArrayValue }

destructor TDBXByteArrayValue.Destroy;
begin
  FBytes := nil;
  inherited;
end;

function TDBXByteArrayValue.GetBytes(Offset: Int64; const Buffer: TBytes;
  BufferOffset, Length: Int64): Int64;
begin
  if FSetPending then
  begin
    Result := Length;
    if Result > FByteLength then
      Result := FByteLength;
    TDBXPlatform.CopyByteArray(FBytes, FBufferOffset, Buffer, BufferOffset, Result);
  end else
  begin
    Result := 0;
    FDbxRow.GetBytes(Self, Offset, Buffer, BufferOffset, Length, Result, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
end;


procedure TDBXByteArrayValue.SetStaticBytes(Offset: Int64;
  const Buffer: array of Byte; BufferOffset, Length: Int64);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
    FOffset       := Offset;
Assert(false, 'Need a copy method');//    FBytes        := Copy(Buffer);//, BufferOffset, Length);
    FBufferOffset := BufferOffset;
    FByteLength   := Length;
    FSetPending := true;
end;

procedure TDBXByteArrayValue.SetDynamicBytes(Offset: Int64; const Buffer: TBytes;
  BufferOffset, Length: Int64);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FOffset       := Offset;
  FBytes        := Buffer;
  FBufferOffset := BufferOffset;
  FByteLength   := Length;
  FSetPending := true;

end;

procedure TDBXByteArrayValue.SetRowValue;
begin
  FDbxRow.SetDynamicBytes(Self, FOffset, FBytes, FBufferOffset, FByteLength);
end;

function TDBXByteArrayValue.GetValueSize: Int64;
begin
  if IsNull then
    Result := -1
  else
    Result := FByteLength;
end;

function TDBXByteArrayValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetByteLength(Self, FByteLength, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

{ TDBXTimeStampValue }


procedure TDBXTimeStampValue.SetRowValue;
begin
  FDbxRow.SetTimestamp(Self, FTimeStamp);
end;

procedure TDBXTimeStampValue.SetTimeStamp(const Value: TSQLTimeStamp);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FTimeStamp := Value;
  FSetPending := true;
end;

function TDBXTimeStampValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetTimeStamp(Self, FTimeStamp, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXTimeStampValue.GetTimeStamp: TSQLTimeStamp;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetTimeStamp(Self, FTimeStamp, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FTimeStamp;
end;

{ TDBXBcdValue }


procedure TDBXBcdValue.SetBcd(const Value: TBcd);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FBcd := Value;
  FSetPending := true;
end;

procedure TDBXBcdValue.SetRowValue;
begin
  FDbxRow.SetBCD(Self, FBcd);
end;

function TDBXBcdValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetBcd(Self, FBcd, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FIsNull;
end;

function TDBXBcdValue.GetBcd: TBcd;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    FDbxRow.GetBcd(Self, FBcd, FIsNull);
    FGeneration := FDbxRow.Generation;
  end;
  Result := FBcd;
end;



{ TDBXClosedByteReader }

constructor TDBXClosedByteReader.Create(DBXContext: TDBXContext);
begin
  inherited Create(DBXContext);
end;

procedure TDBXClosedByteReader.GetBcd(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

function TDBXClosedByteReader.GetBytes(Ordinal: TInt32; Offset: Int64;
  const Value: TBytes; ValueOffset, Length: Int64;
  var IsNull: LongBool): Int64;
begin
  InvalidOperation;
  Result := 0;
end;

procedure TDBXClosedByteReader.GetByteLength(Ordinal: TInt32; var Length: Int64;
  var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.GetDate(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.GetDouble(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;


procedure TDBXClosedByteReader.GetInt16(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.GetInt32(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.GetInt64(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.GetAnsiString(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.GetTime(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.GetTimeStamp(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.GetWideString(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  InvalidOperation;
end;

procedure TDBXClosedByteReader.InvalidOperation;
begin
  FDBXContext.Error(TDBXErrorCodes.NoData, SReaderClosed);
end;

{ TDBXRow }

constructor TDBXRow.Create(DBXContext: TDBXContext);
begin
  inherited Create;
  FDBXContext := DBXContext;
  FGeneration := -1;
end;


procedure TDBXRow.GetBcd(DbxValue: TDBXBcdValue; var Value: TBcd;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetBoolean(DbxValue: TDBXBooleanValue; var Value,
  IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetByteLength(DbxValue: TDBXByteArrayValue;
  var ByteLength: Int64; var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetBytes(DbxValue: TDBXByteArrayValue; Offset: Int64;
  const Buffer: TBytes; BufferOffset, Length: Int64; var ReturnLength: Int64;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetDate(DbxValue: TDBXDateValue; var Value: TDBXDate;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetDouble(DbxValue: TDBXDoubleValue; var Value: Double;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetInt16(DbxValue: TDBXInt16Value; var Value: SmallInt;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetInt32(DbxValue: TDBXInt32Value; var Value: TInt32;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetInt64(DbxValue: TDBXInt64Value; var Value: Int64;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

function TDBXRow.GetObjectTypeName(Ordinal: TInt32): WideString;
begin
  NotImplemented;
end;

procedure TDBXRowEx.GetStream(DbxValue: TDBXStreamValue; var Stream: TStream;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

function TDBXRowEx.CreateCustomValue(ValueType: TDBXValueType): TDBXValue;
begin
  Result := nil;
end;


procedure TDBXRowEx.GetLength(DbxValue: TDBXValue; var ByteLength: Int64;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRowEx.GetStream(DbxValue: TDBXWideStringValue; var Stream: TStream;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRowEx.GetStreamBytes(DbxValue: TDBXStreamValue;
  const Buffer: TBytes; BufferOffset, Length, ReturnLength: Int64;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRowEx.GetStreamLength(DbxValue: TDBXStreamValue;
  StreamLength: Int64; var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetAnsiString(DbxValue: TDBXAnsiStringValue;
  var AnsiStringBuilder: TDBXAnsiStringBuilder; var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetTime(DbxValue: TDBXTimeValue; var Value: TDBXTime;
  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetTimeStamp(DbxValue: TDBXTimeStampValue;
  var Value: TSQLTimeStamp; var IsNull: LongBool);
begin
  NotImplemented;
end;


procedure TDBXRowEx.GetWideChars(DbxValue: TDBXWideStringValue;
  var WideChars: TDBXWideChars; var Count: Integer;  var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.GetWideString(DbxValue: TDBXWideStringValue;
  var WideStringBuilder: TDBXWideStringBuilder; var IsNull: LongBool);
begin
  NotImplemented;
end;

procedure TDBXRow.NotImplemented;
begin
  FDBXContext.Error(TDBXErrorCodes.NotImplemented, sNotImplemented);
end;

procedure TDBXRow.SetBCD(DbxValue: TDBXBcdValue; var Value: TBcd);
begin
  NotImplemented;
end;

procedure TDBXRow.SetBoolean(DbxValue: TDBXBooleanValue; Value: Boolean);
begin
  NotImplemented;
end;

procedure TDBXRow.SetDate(DbxValue: TDBXDateValue; Value: TDBXDate);
begin
  NotImplemented;
end;

procedure TDBXRow.SetDouble(DbxValue: TDBXDoubleValue; Value: Double);
begin
  NotImplemented;
end;

procedure TDBXRow.SetDynamicBytes(DbxValue: TDBXValue; Offset: Int64;
  const Buffer: TBytes; BufferOffset, Length: Int64);
begin
  NotImplemented;
end;

procedure TDBXRow.SetInt16(DbxValue: TDBXInt16Value; Value: SmallInt);
begin
  NotImplemented;
end;

procedure TDBXRow.SetInt32(DbxValue: TDBXInt32Value; Value: TInt32);
begin
  NotImplemented;
end;

procedure TDBXRow.SetInt64(DbxValue: TDBXInt64Value; Value: Int64);
begin
  NotImplemented;
end;

procedure TDBXRow.SetNull(DbxValue: TDBXValue);
begin
  NotImplemented;
end;

procedure TDBXRowEx.SetStream(DbxValue: TDBXStreamValue; StreamReader: TDBXStreamReader);
begin
  NotImplemented;
end;

procedure TDBXRowEx.SetWideChars(DbxValue: TDBXWideStringValue;
  const Value: WideString);
begin
  NotImplemented;
end;

function TDBXRowEx.UseExtendedTypes: Boolean;
begin
  Result := false;
end;

procedure TDBXRow.SetString(DbxValue: TDBXAnsiStringValue; const Value: String);
begin
 NotImplemented;
end;

procedure TDBXRow.SetTime(DbxValue: TDBXTimeValue; Value: TDBXTime);
begin
  NotImplemented;
end;

procedure TDBXRow.SetTimestamp(DbxValue: TDBXTimeStampValue;
  var Value: TSQLTimeStamp);
begin
  NotImplemented;
end;

procedure TDBXRow.SetValueType(ValueType: TDBXValueType);
begin
  NotImplemented;
end;

procedure TDBXRow.SetWideString(DbxValue: TDBXWideStringValue;
  const Value: WideString);
begin
  NotImplemented;
end;

{ TDBXConnectionBuilder }

procedure TDBXConnectionBuilder.Assign(Source: TDBXConnectionBuilder);
var
  SourceDelegateItem: TDBXDelegateItem;
  DestDelegateItem: TDBXDelegateItem;
begin
  FDBXContext          := TDBXContext.Create(Source.FDBXContext);
  FInputConnectionName := Source.FInputConnectionName;
  FInputUserName       := Source.FInputUserName;
  FInputPassword       := Source.FInputPassword;
  FConnectionFactory   := Source.FConnectionFactory;
  FInputConnectionProperties  := Source.FInputConnectionProperties;
  if not Source.FOwnsDelegatePath then
  begin
    FOwnsDelegatePath := true;
    if Source.FDelegatePath <> nil then
    begin
      FreeAndNil(FDelegatePath);
      SourceDelegateItem    := Source.FDelegatePath;
      DestDelegateItem      := TDBXDelegateItem.Create;
      FDelegatePath         := DestDelegateItem;
      while SourceDelegateItem <> nil do
      begin
        DestDelegateItem.FName        := SourceDelegateItem.FName;
        DestDelegateItem.FProperties  := SourceDelegateItem.FProperties;
        if SourceDelegateItem.FNext <> nil then
          DestDelegateItem.FNext := TDBXDelegateItem.Create;
        DestDelegateItem              := DestDelegateItem.FNext;
        SourceDelegateItem            := SourceDelegateItem.FNext;
      end;
    end;
  end else
  begin
    FDelegatePath               := Source.FDelegatePath;
  end;
end;

destructor TDBXConnectionBuilder.Destroy;
begin
  FreeAndNil(FDBXContext);
  FreeAndNil(FDelegateDriver);
  if FOwnsDelegatePath then
    FreeAndNil(FDelegatePath)
  else
    FDelegatePath := nil;
  inherited;
end;


constructor TDBXConnectionBuilder.Create(Source: TDBXConnectionBuilder);
begin
  inherited Create;
  Assign(Source);
end;

constructor TDBXConnectionBuilder.Create;
begin
  inherited;
end;

function TDBXConnectionBuilder.CreateConnection: TDBXConnection;
var
  DriverName:             WideString;
  Index:                  TInt32;
  DriverProperties:       TDBXProperties;
  ConnectionProperties:   TDBXProperties;
  NextConnectionBuilder:  TDBXConnectionBuilder;
begin
    ConnectionProperties := FDelegatePath.FProperties;
    DriverName     := FConnectionFactory.GetDriverName(ConnectionProperties);
    Index  := FConnectionFactory.FDrivers.IndexOf(DriverName);
    if Index < 0 then
      DriverProperties := ConnectionProperties
    else
      DriverProperties := FConnectionFactory.GetDriverProperties(DriverName);

    NextConnectionBuilder := nil;
    try
      NextConnectionBuilder := TDBXConnectionBuilder.Create(Self);
      NextConnectionBuilder.FDelegateDriver := FConnectionFactory.GetDriver(DriverName, DriverProperties);
      Result := NextConnectionBuilder.FDelegateDriver.CreateConnection(NextConnectionBuilder);
      //Gets taken by the TDBXConnection.Create.
      //
      NextConnectionBuilder.FDelegateDriver := nil;
    finally
      NextConnectionBuilder.Free;
    end;
end;

function TDBXConnectionBuilder.CreateDelegateeConnection: TDBXConnection;
var
  SaveDelegatePath:   TDBXDelegateItem;
begin
  SaveDelegatePath := FDelegatePath;
  FDelegatePath := FDelegatePath.FNext;
  try
    Result := CreateConnection;
  finally
    FDelegatePath := SaveDelegatePath;
  end;
end;


function TDBXConnectionBuilder.GetConnectionProperties: TDBXProperties;
begin
  Result := FDelegatePath.FProperties;
end;

function TDBXConnectionBuilder.GetDelegationSignature: WideString;
var
  DelegateItem: TDBXDelegateItem;
begin
  Result := FDelegatePath.FName;
  DelegateItem := FDelegatePath.FNext;;
  while DelegateItem <> nil do
  begin
    Result        := Result + '/' + DelegateItem.FName; { Do not localize }
    DelegateItem  := DelegateItem.FNext;
  end;
end;

{ TDBXDelegateItem }

destructor TDBXDelegateItem.Destroy;
begin
  FreeAndNil(FNext);
  inherited;
end;

{ TDBXPropertiesItem }

constructor TDBXPropertiesItem.Create(Properties: TDBXProperties);
begin
  inherited Create;
  FProperties := Properties;
end;

destructor TDBXPropertiesItem.Destroy;
begin
  FreeAndNil(FProperties);
  FreeandNil(FDeletgatePath);
  inherited;
end;


{ TDBXReaderByteReader }

constructor TDBXReaderByteReader.Create(DBXContext: TDBXContext;
  DbxReader: TDBXReader);
begin
  inherited Create(DBXContext);
  FDbxReader := DbxReader;
end;

procedure TDBXReaderByteReader.GetBcd(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopyBcd(ValueObject.GetBcd, Value, 0);
  end;
end;

procedure TDBXReaderByteReader.GetByteLength(Ordinal: TInt32; var Length: Int64;
  var IsNull: LongBool);
begin
  isNull := FDbxReader.Value[Ordinal].IsNull;
  if not IsNull then
    Length := FDbxReader.Value[Ordinal].GetValueSize;
end;

function TDBXReaderByteReader.GetBytes(Ordinal: TInt32; Offset: Int64;
  const Value: TBytes; ValueOffset, Length: Int64;
  var IsNull: LongBool): Int64;
begin
  if FDBXReader.Value[Ordinal].IsNull then
  begin
    Result := -1;
    IsNull := True;
  end
  else
  begin
    Result := FDbxReader.Value[Ordinal].GetBytes(Offset, Value, ValueOffset, Length);
    IsNull := False;
  end;
end;

procedure TDBXReaderByteReader.GetDate(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopyInt32(ValueObject.GetDate, Value, 0);
  end;
end;

procedure TDBXReaderByteReader.GetDouble(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopyInt64(TDBXPlatform.DoubleToInt64Bits(ValueObject.GetDouble), Value, 0);
  end;
end;

procedure TDBXReaderByteReader.GetInt16(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    if ValueObject.GetBoolean then    
      TDBXPlatform.CopyInt16(1, Value, 0)
    else
      TDBXPlatform.CopyInt16(0, Value, 0);
  end;
end;

procedure TDBXReaderByteReader.GetInt32(Ordinal: TInt32;
   const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopyInt32(ValueObject.GetInt32, Value, 0);
  end;
end;

procedure TDBXReaderByteReader.GetInt64(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopyInt64(ValueObject.GetInt64, Value, 0);
  end;
end;

procedure TDBXReaderByteReader.GetAnsiString(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
begin

end;

procedure TDBXReaderByteReader.GetTime(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopyInt32(ValueObject.GetTime, Value, 0);
  end;
end;

procedure TDBXReaderByteReader.GetTimeStamp(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  ValueObject: TDBXValue;
begin
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    TDBXPlatform.CopySqlTimeStamp(ValueObject.GetTimeStamp, Value, 0);
  end;
end;

procedure TDBXReaderByteReader.GetWideString(Ordinal: TInt32;
  const Value: TBytes; Offset: TInt32; var IsNull: LongBool);
var
  Index: Integer;
  WideStringValue: WideString;
  Count: Integer;
  Ch: WideChar;
  ValueObject: TDBXValue;
begin
  // Need to optimize this in a cross platform way.
  // However, this particular method is not heavily used at this time.
  //
  ValueObject := FDbxReader[Ordinal];
  if ValueObject.IsNull then
    IsNull := true
  else
  begin
    IsNull := false;
    WideStringValue := FDbxReader[Ordinal].GetWideString;
    Count := Length(WideStringValue);
    Index := Offset;
    while Count > 0 do
    begin
      Ch := WideStringValue[1+(Index div 2)];
      Value[Index] := Byte(Ch);
      inc(Index);
      Value[Index] := Byte(Integer(Ch) shr 8);
      inc(Index);
      dec(Count);
    end;
    Value[Index] := Byte(0);
    Value[Index+1] := Byte(0);
  end;
end;

{ TDBXDriverHelp }

class function TDBXDriverHelp.CreateConnectionBuilder(
  ConnectionBuilder: TDBXConnectionBuilder): TDBXConnectionBuilder;
begin
    Result  := TDBXConnectionBuilder.Create(ConnectionBuilder);
end;

class function TDBXDriverHelp.CreateTDBXContext: TDBXContext;
begin
  Result := TDBXContext.Create;
end;

class function TDBXDriverHelp.CreateTDBXParameter(
  DBXContext: TDBXContext): TDBXParameter;
begin
  Result := TDBXParameterEx.Create(DBXContext);
end;

class function TDBXDriverHelp.CreateTDBXProperties(
  DBXContext: TDBXContext): TDBXProperties;
begin
  Result := TDBXProperties.Create(DBXContext);
end;

class function TDBXDriverHelp.CreateTDBXValueType(
  DBXContext: TDBXContext): TDBXValueType;
begin
  Result := TDBXValueType.Create(DBXContext);
end;

class function TDBXDriverHelpEx.CreateTDBXValueType(
  DBXContext: TDBXContext; DBXRow: TDBXRow): TDBXValueType;
begin
  Result := TDBXValueType.Create(DBXContext);
  Result.FDbxRow := DBXRow;
end;

class function TDBXDriverHelpEx.GetStreamReader(
  Value: TDBXStreamValue): TDBXStreamReader;
begin
  if Value.FStreamStreamReader <> nil then
    Result := Value.FStreamStreamReader
  else
    Result := Value.FByteStreamReader;
end;

class function TDBXDriverHelpEx.IsReadOnlyValueType(
  ValueType: TDBXValueType): Boolean;
begin
  Result := ValueType.IsReadOnlyType;
end;

{ TDBXCursorValue }

function TDBXCursorValue.IsNull: Boolean;
begin
  Result := true;
end;

procedure TDBXCursorValue.SetRowValue;
begin
  inherited;

end;

{ TDBXMemoryConnectionFactory }

constructor TDBXMemoryConnectionFactory.Create;
begin
  inherited Create;
end;

procedure TDBXMemoryConnectionFactory.DerivedClose;
begin

end;

procedure TDBXMemoryConnectionFactory.DerivedOpen;
begin

end;

destructor TDBXMemoryConnectionFactory.Destroy;
begin

  inherited;
end;

{ TDBXWideCharsValue }

constructor TDBXWideCharsValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
  UpdateType;
end;

destructor TDBXWideCharsValue.Destroy;
begin
  SetLength(FWideChars, 0);
  inherited Destroy;
end;

function TDBXWideCharsValue.GetStream: TStream;
begin
  TDBXRowEx(FDbxRow).GetStream(Self, Result, FIsNull);
end;

procedure TDBXWideCharsValue.SetWideString(const Value: WideString);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FWideString := Value;
  FSetPending := true;
end;

function TDBXWideCharsValue.GetWideString: WideString;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    TDBXRowEx(FDbxRow).GetWideChars(Self, FWideChars, FCount, FIsNull);
    FGeneration := FDbxRow.Generation;
    FWideString := TDBXPlatform.CreateWideString(FWideChars, FCount);
  end;
  Result := FWideString
end;

function TDBXWideCharsValue.IsNull: Boolean;
begin
  if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
  begin
    TDBXRowEx(FDbxRow).GetWideChars(Self, FWideChars, FCount, FIsNull);
    FGeneration := FDbxRow.Generation;
    FWideString := TDBXPlatform.CreateWideString(FWideChars, FCount);
  end;
  Result := FIsNull;
end;

procedure TDBXWideCharsValue.SetRowValue;
begin
  TDBXRowEx(FDbxRow).SetWideChars(Self, FWideString)
end;


procedure TDBXWideCharsValue.UpdateType;
begin
  if ((ValueType.GetFlags and TDBXValueTypeFlagsEx.ExtendedType) <> 0)
      or ((FDbxRow <> nil) and TDBXRowEx(FDbxRow).UseExtendedTypes) then
  begin
    // Add one because dynalink drivers will always set a null byte
    // even if the length is 0.
    //
    SetLength(FWideChars, ValueType.Size+1);
    FExtendedType := true;
  end else
  begin
    inherited UpdateType;
    FExtendedType := false;
  end;
end;


{ TDBXBinaryValue }

constructor TDBXStreamValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
  UpdateType;
end;

destructor TDBXStreamValue.Destroy;
begin
  FreeAndNil(FStreamStreamReader);
  FreeAndNil(FByteStreamReader);
  inherited;
end;


function TDBXStreamValue.GetStream: TStream;
begin
  if FSetPending then
  begin
    Result := FStreamStreamReader.ConvertToMemoryStream;
  end else
  begin
    TDBXRowEx(FDbxRow).GetStream(Self, Result, FIsNull);
  end;
end;

function TDBXStreamValue.GetValueSize: Int64;
begin
  if FExtendedType then
  begin
    if IsNull then
      Result := -1
    else
      Result := FByteLength;
  end
  else
    Result := inherited GetValueSize;
end;

//function TDBXStreamValue.IsNull: Boolean;
//begin
//  if FExtendedType then
//  begin
//    if (FDbxRow <> nil) and (FGeneration <> FDbxRow.Generation) then
//    begin
//      Assert(false);
////      TDBXRowEx(FDbxRow).GetStream(Self, nil, FIsNull);
//      FGeneration := FDbxRow.Generation;
//    end;
//    Result := FIsNull;
//  end else
//    Result := inherited IsNull;
//end;

procedure TDBXStreamValue.SetDynamicBytes(Offset: Int64; const Buffer: TBytes; BufferOffset,
  Count: Int64);
begin
  if FExtendedType then
  begin
  //  ValueType.FailIfReadOnly;
    FIsNull := false;
    FreeAndNil(FStreamStreamReader);
    FreeAndNil(FByteStreamReader);
    FByteStreamReader := TDBXByteStreamReader.Create(Buffer, BufferOffset, Count);
    FSetPending := true;
  end else
    inherited SetDynamicBytes(Offset, Buffer, BufferOffset, Count);
end;

procedure TDBXStreamValue.SetRowValue;
begin
  if FExtendedType then
  begin
    if FStreamStreamReader <> nil then
      TDBXRowEx(FDbxRow).SetStream(Self, FStreamStreamReader)
    else
      TDBXRowEx(FDbxRow).SetStream(Self, FByteStreamReader)
  end else
    inherited SetRowValue;
end;

procedure TDBXStreamValue.SetStream(const Stream: TStream);
begin
//  ValueType.FailIfReadOnly;
  FIsNull := false;
  FreeAndNil(FByteStreamReader);
  if FStreamStreamReader = nil then
    FStreamStreamReader := TDBXLookAheadStreamReader.Create;
  FStreamStreamReader.SetStream(Stream);
  FSetPending := true;
end;


procedure TDBXStreamValue.UpdateType;
begin
  if ((ValueType.GetFlags and TDBXValueTypeFlagsEx.ExtendedType) <> 0)
      or ((FDbxRow <> nil) and (FDBXRow is TDBXRowEx) and TDBXRowEx(FDbxRow).UseExtendedTypes) then
    FExtendedType := true
  else
    FExtendedType := false;
end;

{ TDBXLookAheadStreamReader }

// A MemoryStream can always seeek to the start.
//
function TDBXLookAheadStreamReader.ConvertToMemoryStream: TStream;
var
  Stream: TMemoryStream;
  StreamTemp: TStream;
  Count: Integer;
  Buffer: TBytes;
  ReadBytes: Integer;
begin
  if FStream = nil then
    Result := nil
  else
  begin
    Count := Size;
    if not (FStream is TMemoryStream) then
    begin
      Stream := TMemoryStream.Create;
      Stream.SetSize(Count);
      if FHasLookAheadByte then
        Stream.Write(FLookAheadByte, 1);
      SetLength(Buffer, 256);
      while true do
      begin
        ReadBytes := FStream.Read(Buffer, Length(Buffer));
        if ReadBytes > 0 then        
          Stream.Write(Buffer, ReadBytes)
        else
          Break;
      end;
      StreamTemp := FStream;
      FStream := Stream;
      FreeAndNil(StreamTemp);
    end;
    FStream.Seek(0, soFromBeginning);
    FHasLookAheadByte := false;

    Result := FStream;
//    Stream := TMemoryStream.Create;
//    Stream.LoadFromStream(FStream);
//    FStream.Seek(0, soFromBeginning);
//    Result := Stream;
  end;
end;

destructor TDBXLookAheadStreamReader.Destroy;
begin
  FreeAndNil(FStream);
  inherited;
end;

function TDBXLookAheadStreamReader.EOS: Boolean;
begin
  if (not FEOS) and (not FHasLookAheadByte) then
  begin
    if FStream.Read(FLookAheadByte, 1) = 1 then
      FHasLookAheadByte := true
    else
      FEOS := true;
  end;
  Result := FEOS;
end;

function TDBXLookAheadStreamReader.Read(const Buffer: TBytes; Offset,
  Count: Integer): Integer;
begin
  if FHasLookAheadByte then
  begin
    Buffer[Offset] := FLookAheadByte;
    FHasLookAheadByte := false;
    Result := FStream.Read(buffer[Offset+1], Count) + 1;
  end else
    Result := FStream.Read(Buffer[Offset], Count);

  if Result < Count then
    FEOS := true;
end;

procedure TDBXLookAheadStreamReader.SetStream(Stream: TStream);
begin
  FEOS              := false;
  FHasLookAheadByte := false;
  FStream           := Stream;
end;

function TDBXLookAheadStreamReader.Size: Int64;
begin
  Result := -1;
end;

{ TDBXCommandEX }

function TDBXCommandEx.GetCommandTimeout: Integer;
begin
  Result := FCommandTimeout;
end;

procedure TDBXCommandEx.SetCommandTimeout(Timeout: Integer);
begin
  FCommandTimeout := Timeout;
end;

procedure TDBXCommandEX.SetLastReader(Reader: TDBXReader);
begin

end;

procedure TDBXCommandEX.SetReader(const Value: TDBXReader);
begin

end;

{ TDBXDatabaseMetaDataEx }

constructor TDBXDatabaseMetaDataEx.Create(DBXContext: TDBXContext);
begin
  inherited Create(DBXContext);
end;

{ TDBXByteReaderEx }

procedure TDBXByteReaderEx.GetBoolean(Ordinal: TInt32; const Value: TBytes;
  Offset: TInt32; var IsNull: LongBool);
begin
  GetInt16(Ordinal, Value, Offset, IsNull);
end;

{ TDBXByteStreamReader }

destructor TDBXByteStreamReader.Destroy;
begin
  FBytes := nil;
  inherited;
end;

function TDBXByteStreamReader.EOS: Boolean;
begin
  Result := (FCount = FPosition);
end;

function TDBXByteStreamReader.Read(const Buffer: TBytes; Offset,
  Count: Integer): Integer;
var
  Available : Integer;
begin
  Result := Count;
  Available := FCount - FPosition;
  if Result > Available then
    Result := Available;
  TDBXPlatform.CopyByteArray(FBytes, FPosition, Buffer, Offset, Result);
  FPosition := FPosition + Result;
end;

constructor TDBXByteStreamReader.Create(Bytes: TBytes; Offset, Count: Integer);
begin
  inherited Create;
  FBytes := Bytes;
  FOffset := Offset;
  FCount := Count;
  FPosition := 0;
end;

function TDBXByteStreamReader.Size: Int64;
begin
  Result := FCount;
end;

{ TDBXStateItemList }

procedure TDBXStateItemList.AddStateItem(Name: WideString; Item: TDBXStateItem);
begin

end;

destructor TDBXStateItemList.Destroy;
begin

  inherited;
end;

function TDBXStateItemList.GetStateItem(Name: WideString): TDBXStateItem;
begin
  Result := nil;
end;

procedure TDBXStateItemList.RemoveAndFreeStateItem(Name: WideString);
begin

end;


class procedure TDBXDriverHelpEx.UpdateParameterType(Parameter: TDBXParameter);
begin
  Parameter.UpdateParameterType(Parameter.DataType);
end;

{ TDBXConnectionFactoryEx }

procedure TDBXIniFileConnectionFactoryEx.GetDriverItems(Items: TStrings);
var
  Index: Integer;
begin
  for Index := 0 to FDrivers.Count - 1 do
    Items.Add(FDrivers[Index]);
end;


{ TDBXNullValue }

constructor TDBXNullValue.Create(ValueType: TDBXValueType);
begin
  inherited Create(ValueType);
  FIsNull     := true;
  FSetPending := true;
end;

destructor TDBXNullValue.Destroy;
begin

  inherited;
end;

function TDBXNullValue.IsNull: Boolean;
begin
  Result := true;
end;

initialization
  if TDBXDriverRegistry.DBXDriverRegistry = nil then
    TDBXDriverRegistry.DBXDriverRegistry := TDBXDriverRegistry.Create;
finalization
  TDBXDriverRegistry.DBXDriverRegistry.CloseAllDrivers();
  FreeAndNil(TDBXDriverRegistry.DBXDriverRegistry);
  FreeAndNil(TDBXConnectionFactory.ConnectionFactorySingleton);

end.

