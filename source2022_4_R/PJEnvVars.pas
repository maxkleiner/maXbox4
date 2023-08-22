{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 1998-2014, Peter Johnson (www.delphidabbler.com).
 *
 * $Rev: 1749 $
 * $Date: 2014-01-30 14:27:08 +0000 (Thu, 30 Jan 2014) $
 *
 * DelphiDabbler Environment Variables unit. Contains classes for interrogating,
 * modifying and enumerating the environment variables belonging to the current
 * process.
 *
 * This unit also contains a component and stand-alone routines that are now
 * deprecated. These are provided for backward compatibility reasons. Note that
 * component registration code has been moved into the PJEnvVarsDsgn unit.
 *
 * Documented at http://www.delphidabbler.com/url/envvars-docs
 *
 * ACKNOWLEDGEMENTS
 *
 * Thanks to "e.e" for bug fix in v1.3.2
 *
 * ***** END LICENSE BLOCK *****
}


unit PJEnvVars;


// Set conditional symbols & switch off unsafe warnings where supported
{$UNDEF Has_Types_Unit}
{$UNDEF Supports_ENoConstructException}
{$UNDEF Supports_EOSError}
{$UNDEF Supports_Closures}
{$UNDEF Supports_Deprecated}
{$UNDEF Supports_Deprecated_Hints}
{$UNDEF Supports_RTLNamespaces}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 24.0} // Delphi XE3 and later
    {$LEGACYIFEND ON}  // NOTE: this must come before all $IFEND directives
  {$IFEND}
  {$IF CompilerVersion >= 23.0} // Delphi XE2 ad later
    {$DEFINE Supports_RTLNamespaces}
  {$IFEND}
  {$IF CompilerVersion >= 20.0} // Delphi 2009 and later
    {$DEFINE Supports_ENoConstructException}
    {$DEFINE Supports_Closures}
    {$DEFINE Supports_Deprecated_Hints}
  {$IFEND}
  {$IF CompilerVersion >= 15.0} // Delphi 7 and later
    // Switch off unsafe warnings
    {$WARN UNSAFE_TYPE OFF}
    {$WARN UNSAFE_CODE OFF}
  {$IFEND}
  {$IF CompilerVersion >= 14.0} // Delphi 6 and later
    {$DEFINE Supports_EOSError}
    {$DEFINE Has_Types_Unit}
    {$DEFINE Supports_Deprecated}
  {$IFEND}
{$ENDIF}


interface


uses
  // Delphi
  {$IFNDEF Supports_RTLNamespaces}
  SysUtils, Classes {$IFDEF Has_Types_Unit}, Types{$ENDIF};
  {$ELSE}
  System.SysUtils, System.Classes, System.Types;
  {$ENDIF}

{$IFNDEF Has_Types_Unit}
type
  // Dynamic array of strings. Defined in Types unit when compiled with versions
  // of Delphi that have it.
  TStringDynArray = array of string;
{$ENDIF}

///  <summary>Gets the value of an environment variable.</summary>
///  <remarks>This is an alias for
///  <see cref="PJEnvVars|TPJEnvironmentVars.GetValue"/> which should be used in
///  preference.</remarks>
function GetEnvVarValue(const VarName: string): string;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.GetValue instead'
  {$ENDIF}
  {$ENDIF};

///  <summary>Sets the value of an environment variable.</summary>
///  <remarks>This is an alias for
///  <see cref="PJEnvVars|TPJEnvironmentVars.SetValue"/> which should be used in
///  preference.</remarks>
function SetEnvVarValue(const VarName, VarValue: string): Integer;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.SetValue instead'
  {$ENDIF}
  {$ENDIF};

///  <summary>Deletes an environment variable.</summary>
///  <remarks>This is an alias for
///  <see cref="PJEnvVars|TPJEnvironmentVars.Delete"/> which should be used in
///  preference.</remarks>
function DeleteEnvVar(const VarName: string): Integer;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.Delete instead'
  {$ENDIF}
  {$ENDIF};

///  <summary>Creates a new custom environment block.</summary>
///  <remarks>This is an alias for
///  <see cref="PJEnvVars|TPJEnvironmentVars.CreateBlock"/> which should be used
///  in preference.</remarks>
function CreateEnvBlock(const NewEnv: TStrings; const IncludeCurrent: Boolean;
  const Buffer: Pointer; const BufSize: Integer): Integer;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.CreateBlock instead'
  {$ENDIF}
  {$ENDIF};

///  <summary>Replaces any environment variable names in a string with their
///  values.</summary>
///  <remarks>This is an alias for
///  <see cref="PJEnvVars|TPJEnvironmentVars.Expand"/> which should be used in
///  preference.</remarks>
function ExpandEnvVars(const Str: string): string;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.Expand instead'
  {$ENDIF}
  {$ENDIF};

///  <summary>Gets a list of all the environment variables available to the
///  current process in <c>Name=Value</c> format.</summary>
///  <remarks>This is an alias for
///  <see cref="PJEnvVars|TPJEnvironmentVars.GetAll"/> which should be used in
///  preference.</remarks>
function GetAllEnvVars(const Vars: TStrings): Integer;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.GetAll instead'
  {$ENDIF}
  {$ENDIF};

///  <summary>Gets a list of names of all environment variables in the current
///  process.</summary>
///  <remarks>This is an alias for
///  <see cref="PJEnvVars|TPJEnvironmentVars.GetAllNames"/> which should be used
///  in preference.</remarks>
procedure GetAllEnvVarNames(const Names: TStrings); overload;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.GetAllNames instead'
  {$ENDIF}
  {$ENDIF};

///  <remarks>This is an alias for the <c>TStringDynArray</c> overload of
///  <see cref="PJEnvVars|TPJEnvironmentVars.GetAllNames"/> which should be used
///  in preference.</remarks>
function GetAllEnvVarNames: TStringDynArray; overload;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.GetAllNames instead'
  {$ENDIF}
  {$ENDIF};

///  <summary>Calculates the size of the current process' environment block.
///  </summary>
///  <remarks>This is an alias for
///  <see cref="PJEnvVars|TPJEnvironmentVars.BlockSize"/> which should be used
///  in preference.</remarks>
function EnvBlockSize: Integer;
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars.BlockSize instead'
  {$ENDIF}
  {$ENDIF};

type

  ///  <summary>Record encapsulating the name and value of an environment
  ///  variable.</summary>
  TPJEnvironmentVar = record
    ///  <summary>Environment variable name.</summary>
    Name: string;
    ///  <summary>Environment variable value.</summary>
    Value: string;
  end;

  ///  <summary>Dynamic array of <see cref="PJEnvVars|TPJEnvironmentVar"/>
  ///  records.</summary>
  TPJEnvironmentVarArray = array of TPJEnvironmentVar;

  ///  <summary>Type of callback method passed to the
  ///  <see cref="PJEnvVars|TPJEnvironmentVars.EnumNames"/> method, to be called
  ///  for each enumerated environment variable.</summary>
  ///  <param name="VarName">string [in] Name of the current environment
  ///  variable in the enumeration.</param>
  ///  <param name="Data">Pointer [in] User-specified value that was passed to
  ///  <see cref="PJEnvVars|TPJEnvironmentVars.EnumNames"/></param>
  ///  <remarks>When compiled with a compiler that supports anonymous methods
  ///  <c>TPJEnvVarsEnum</c> is an anonymous method type, otherwise it is a
  ///  normal method type. NOTE: normal methods can be assigned to
  ///  <c>TPJEnvVarsEnum</c> even when it is compiled as an anonymous type.
  ///  </remarks>
  TPJEnvVarsEnum =
    {$IFNDEF Supports_Closures}
    procedure(const VarName: string; Data: Pointer) of object;
    {$ELSE}
    reference to procedure(const VarName: string; Data: Pointer);
    {$ENDIF}

  ///  <summary>Type of callback method passed to the
  ///  <see cref="PJEnvVars|TPJEnvironmentVars.EnumVars"/> method, to be called
  ///  for each enumerated environment variable.</summary>
  ///  <param name="EnvVar"><see cref="PJEnvVars|TPJEnvironmentVar"/> [in]
  ///  Information about the current environment variable in the enumeration.
  ///  </param>
  ///  <param name="Data">Pointer [in] User-specified value that was passed to
  ///  <see cref="PJEnvVars|TPJEnvironmentVars.EnumVars"/></param>
  ///  <remarks>When compiled with a compiler that supports anonymous methods
  ///  <c>TPJEnvVarsEnumEx</c> is an anonymous method type, otherwise it is a
  ///  normal method type. NOTE: normal methods can be assigned to
  ///  <c>TPJEnvVarsEnumEx</c> even when it is compiled as an anonymous type.
  ///  </remarks>
  TPJEnvVarsEnumEx =
    {$IFNDEF Supports_Closures}
    procedure(const EnvVar: TPJEnvironmentVar; Data: Pointer) of object;
    {$ELSE}
    reference to procedure(const EnvVar: TPJEnvironmentVar; Data: Pointer);
    {$ENDIF}

  ///  <summary>Static class providing class methods for interrogating,
  ///  manipulating and modifying the environment variables available to the
  ///  current process.</summary>
  ///  <remarks>This class cannot be constructed.</remarks>
  TPJEnvironmentVars = class(TObject)
  public
    ///  <summary>Prevents construction of instances of this static class.
    ///  </summary>
    ///  <exception cref="ENoConstructException">Always raised.</exception>
    constructor Create;
    ///  <summary>Returns the number of environment variables in the current
    ///  process.</summary>
    class function Count: Integer;
    ///  <summary>Checks if an environment variable with the given name exists.
    ///  </summary>
    class function Exists(const VarName: string): Boolean;
    ///  <summary>Returns the value of the environment variable with the given
    ///  name or the empty string if the variable does not exist.</summary>
    class function GetValue(const VarName: string): string;
    ///  <summary>Sets the value of the environment variable with the given name
    ///  to the given value.</summary>
    ///  <remarks>Returns <c>0</c> on success or a Windows error code on
    ///  failure.</remarks>
    class function SetValue(const VarName, VarValue: string): Integer;
    ///  <summary>Deletes the environment variable with the given name.
    ///  </summary>
    ///  <remarks>Returns <c>0</c> on success or a Windows error code on
    ///  failure.</remarks>
    class function Delete(const VarName: string): Integer;
    ///  <summary>Creates a new custom environment block.</summary>
    ///  <param name="NewEnv">TStrings [in] List of environment variables in
    ///  <c>Name=Value</c> format to be included in the new environment block.
    ///  If <c>nil</c> then no new environment variables are included in the
    ///  block.</param>
    ///  <param name="IncludeCurrent">Boolean [in] Flag indicating whether the
    ///  environment variables from the current process are included in the new
    ///  environment block.</param>
    ///  <param name="Buffer">Pointer [in] Pointer to a memory block that
    ///  receives the new environment block. If <c>nil</c> then no block is
    ///  created. If none-<c>nil</c> the buffer must be at least <c>BufSize *
    ///  SizeOf(Char)</c> bytes.</param>
    ///  <param name="BufSize">Integer [in] The number of characters that can be
    ///  stored in the memory pointed to by <c>Buffer</c> or <c>0</c> if
    ///  <c>Buffer</c> is <c>nil</c>.</param>
    ///  <returns>Integer. The size of the environment block in characters. If
    ///  <c>Buffer</c> is <c>nil</c> this is the required size of the buffer, in
    ///  characters. Multiply this value by <c>SizeOf(Char)</c> to find the
    ///  required buffer size in bytes.</returns>
    ///  <remarks>
    ///  <para>To find the required buffer size call this method with <c>Buffer
    ///  = nil</c> and it will return the required block size, in characters.
    ///  Now allocate a buffer large enough to hold the required number of
    ///  characters and call this method again, this time passing the buffer and
    ///  its size in characters.</para>
    ///  <para>The environment blocks created by this method are suitable for
    ///  passing to processes created with the <c>CreateProcess</c> API
    ///  function. How this is done depends on whether the block is Unicode (as
    ///  created with Unicode Delphis) or ANSI (as created by non-Unicode
    ///  Delphis). To see how see
    ///  http://delphidabbler.com/articles?article=6#createenvblock</para>
    ///  </remarks>
    class function CreateBlock(const NewEnv: TStrings;
      const IncludeCurrent: Boolean; const Buffer: Pointer;
      const BufSize: Integer): Integer;
    ///  <summary>Calculates and returns the size of the current process'
    ///  environment block in characters.</summary>
    ///  <remarks>Multiply the returned size by <c>SizeOf(Char)</c> to get the
    ///  block size in bytes.</remarks>
    class function BlockSize: Integer;
    ///  <summary>Expands a string containing environment variables by replacing
    ///  each environment variable name with its value.</summary>
    ///  <param name="Str">string [in] String containing environment variables
    ///  to be expanded. Each environment variable name must be enclosed by
    ///  single <c>%</c> characters, e.g. <c>%FOO%</c>.</param>
    ///  <returns>string. The expanded string.</returns>
    class function Expand(const Str: string): string;
    ///  <summary>Gets all the environment variables available to the current
    ///  process and returns the size of the environment block.</summary>
    ///  <param name="Vars">TStrings [in] Receives all environment variables in
    ///  Name=Value format. Any previous contents are discarded. If <c>nil</c>
    ///  is passed to this parameter no environment variables are fetched.
    ///  </param>
    ///  <returns>Integer. The minimum size of a environment block that contains
    ///  all the environment variables, in characters. Multiply by
    ///  <c>SizeOf(Char)</c> to get the size in bytes.</returns>
    ///  <remarks>If you need to find the block size without fetching any
    ///  environment variables just call the method and pass nil as the
    ///  parameter.</remarks>
    class function GetAll(const Vars: TStrings): Integer; overload;
    ///  <summary>Gets all the environment variables available to the current
    ///  process.</summary>
    ///  <returns><see cref="PJEnvVars|TPJEnvironmentVarArray"/>. A dynamic
    ///  array of records containing the names and values of each environment
    ///  variable.</returns>
    class function GetAll: TPJEnvironmentVarArray; overload;
    ///  <summary>Gets the names of all environment variables available to the
    ///  current process.</summary>
    ///  <param name="Names">TStrings [in] Receives all the environment variable
    ///  names. Any existing content is discarded. Must not be nil.</param>
    class procedure GetAllNames(const Names: TStrings); overload;
    ///  <summary>Gets the names of all environment variables available to the
    ///  current process.</summary>
    ///  <returns>TStringDynArray. Dynamic array containing the environment
    ///  variable names.</returns>
    class function GetAllNames: TStringDynArray; overload;
    ///  <summary>Enumerates the names of all environment variables in the
    ///  current process.</summary>
    ///  <param name="Callback"><see cref="PJEnvVars|TPJEnvVarsEnum"/> [in]
    ///  Callback method called once for each environment variable, passing its
    ///  name and the value of the <c>Data</c> pointer as parameters.</param>
    ///  <param name="Data">Pointer [in] Data to be passed to <c>Callback</c>
    ///  method each time it is called.</param>
    class procedure EnumNames(Callback: TPJEnvVarsEnum; Data: Pointer);
    ///  <summary>Enumerates all the environment variables available to the
    ///  current process.</summary>
    ///  <param name="Callback"><see cref="PJEnvVars|TPJEnvVarsEnumEx"/> [in]
    ///  Callback method called once for each environment variable, passing a
    ///  record containing its name and value along with the the value of the
    ///  <c>Data</c> pointer as parameters.</param>
    ///  <param name="Data">Pointer [in] Data to be passed to <c>Callback</c>
    ///  method each time it is called.</param>
    class procedure EnumVars(Callback: TPJEnvVarsEnumEx; Data: Pointer);
  end;

  ///  <summary>Enumerator for all environment variables names in the current
  ///  process.</summary>
  ///  <remarks>This class may be used on its own. Instances of this type are
  ///  returned by <see cref="PJEnvVars|TPJEnvVars.GetEnumerator"/>.</remarks>
  TPJEnvVarsEnumerator = class(TObject)
  private
    ///  <summary>List of environment variable names being enumerated.</summary>
    fEnvVarNames: TStrings;
    ///  <summary>Index of current name in enumeration.</summary>
    fIndex: Integer;
  public
    ///  <summary>Constructs and initialises a new enumeration object.
    ///  </summary>
    constructor Create;
    ///  <summary>Destroys enumerator instance.</summary>
    destructor Destroy; override;
    ///  <summary>Returns name of current environment variable in enumeration.
    ///  </summary>
    function GetCurrent: string;
    ///  <summary>Moves to next environment variable name in enumeration if
    ///  present.</summary>
    ///  <returns>Boolean. <c>True</c> if there is a next item or <c>False</c>
    ///  there are no more items in the enumeration.</returns>
    function MoveNext: Boolean;
    ///  <summary>Name of current environment variable in enumeration.</summary>
    property Current: string read GetCurrent;
  end;

  ///  <summary>Component that encapsulates environment variables available to
  ///  the current process and enables them to be queried and modified.
  ///  </summary>
  ///  <remarks>
  ///  <para>WARNING: Only one instance of the component can be placed on a form
  ///  or owned by another control.</para>
  ///  <para>NOTE: This component is deprecated. The
  ///  <see cref="PJEnvVars|TPJEnvironmentVars"/> static class should be used
  ///  instead.</para>
  ///  </remarks>
  TPJEnvVars = class(TComponent)
  private
    ///  <summary>Read accessor for the <c>Count</c> property.</summary>
    function GetCount: Integer;
    ///  <summary>Read accessor for the <c>Values[]</c> property.</summary>
    function GetValue(Name: string): string;
    ///  <summary>Write accessor for the <c>Values[]</c> property.</summary>
    ///  <exception cref="PJEnvVars|EPJEnvVars">Raised if the named environment
    ///  variable can't be set.</exception>
    procedure SetValue(Name: string; const Value: string);
    ///  <summary>Checks the given OS error code, and if it is non-zero, raises
    ///  an exception.</summary>
    ///  <exception cref="PJEnvVars|EPJEnvVars">Raise if <c>Code</c> is not
    ///  zero. Exception <c>Code</c> property is set to the given code and its
    ///  <c>Message</c> property is the corresponding error message obtained
    ///  from the operating system.</exception>
    procedure ErrorCheck(Code: Integer);
  public
    ///  <summary>Creates a new instance of the component.</summary>
    ///  <param name="AOwner">TComponent [in] Owning component. May be
    ///  <c>nil</c> if no owner.</param>
    ///  <exception cref="Exception">Raised if a <c>TPJEnvVars</c> component is
    ///  already has the same owner.</exception>
    constructor Create(AOwner: TComponent); override;
    ///  <summary>Enumerates names of all environment variables in current
    ///  process.</summary>
    ///  <param name="Callback"><see cref="PJEnvVars|TPJEnvVarsEnum"/> [in]
    ///  Method called once for each environment variable, passing it the
    ///  environment variable's name and the value of the <c>Data</c> parameter.
    ///  </param>
    ///  <param name="Data">Pointer [in] User defined value passed to every call
    ///  to the <c>Callback</c> method.</param>
    ///  <remarks>Deprecated. Use
    ///  <see cref="PJEnvVars|TPJEnvironmentVars.EnumNames"/> instead.</remarks>
    procedure EnumNames(Callback: TPJEnvVarsEnum; Data: Pointer);
    ///  <summary>Creates and returns a new enumerator of all environment
    ///  variable names in the current process.</summary>
    ///  <returns><see cref="PJEnvVars|TPJEnvVarsEnumerator"/>. Required
    ///  enumerator.</returns>
    ///  <remarks>
    ///  <para>Caller is responsible for freeing the enumerator.</para>
    ///  <para>Deprecated. Create instances of
    ///  <see cref="PJEnvVars|TPJEnvVarsEnumerator"/> directly or use
    ///  <see cref="PJEnvVars|TPJEnvironmentVars.EnumNames"/> instead.</para>
    ///  </remarks>
    function GetEnumerator: TPJEnvVarsEnumerator;
    ///  <summary>Deletes the environment variable with the given name.
    ///  </summary>
    ///  <exception cref="PJEnvVars|EPJEnvVars">Raised if the named environment
    ///  variable can't be deleted.</exception>
    ///  <remarks>Deprecated. Use
    ///  <see cref="PJEnvVars|TPJEnvironmentVars.Delete"/> instead.</remarks>
    procedure DeleteVar(const Name: string);
    ///  <summary>Count of the number of environment variables in the current
    ///  process.</summary>
    ///  <remarks>Deprecated. Use
    ///  <see cref="PJEnvVars|TPJEnvironmentVars.Count"/> instead.</remarks>
    property Count: Integer read GetCount;
    ///  <summary>Array of values of each environment variable in the current
    ///  process, indexed by its name.</summary>
    ///  <exception cref="PJEnvVars|EPJEnvVars">Raised when writing to
    ///  <c>Values[]</c> if the named environment variable can't be set.
    ///  </exception>
    ///  <remarks>
    ///  <para>Getting the value of an unknown environment variable returns
    ///  the empty string. Setting the value of an unknown environment variable
    ///  creates it.</para>
    ///  <para>Deprecated. Use
    ///  <see cref="PJEnvVars|TPJEnvironmentVars.GetValue"/> and
    ///  <see cref="PJEnvVars|TPJEnvironmentVars.SetValue"/> instead.</para>
    ///  </remarks>
    property Values[Name: string]: string read GetValue write SetValue;
  end
  {$IFDEF Supports_Deprecated}
  deprecated
  {$IFDEF Supports_Deprecated_Hints}
  'Use TPJEnvironmentVars static class instead'
  {$ENDIF}
  {$ENDIF};

  ///  <summary>Exception raised by <see cref="PJEnvVars|TPJEnvVars"/> when an
  ///  error is encountered.</summary>
  {$IFDEF Supports_EOSError}
  EPJEnvVars = class(EOSError);
  {$ELSE}
  EPJEnvVars = class(EWin32Error);
  {$ENDIF}

  {$IFNDEF Supports_ENoConstructException}
  // Exception class for use with versions of Delphi that don't define the
  // class in SysUtils
  ENoConstructException = class(Exception);
  {$ENDIF}


implementation


uses
  // Delphi
  {$IFNDEF Supports_RTLNamespaces}
  {$IFDEF Supports_ENoConstructException}RTLConsts,{$ENDIF} Windows;
  {$ELSE}
  System.RTLConsts, Winapi.Windows;
  {$ENDIF}

{$IFNDEF Supports_ENoConstructException}
resourcestring
  sNoConstruct = 'Class %s is not intended to be constructed';
{$ENDIF}

function GetEnvVarValue(const VarName: string): string;
begin
  Result := TPJEnvironmentVars.GetValue(VarName);
end;

function SetEnvVarValue(const VarName, VarValue: string): Integer;
begin
  Result := TPJEnvironmentVars.SetValue(VarName, VarValue);
end;

function DeleteEnvVar(const VarName: string): Integer;
begin
  Result := TPJEnvironmentVars.Delete(VarName);
end;

function CreateEnvBlock(const NewEnv: TStrings; const IncludeCurrent: Boolean;
  const Buffer: Pointer; const BufSize: Integer): Integer;
begin
  Result := TPJEnvironmentVars.CreateBlock(
    NewEnv, IncludeCurrent, Buffer, BufSize
  );
end;

function ExpandEnvVars(const Str: string): string;
begin
  Result := TPJEnvironmentVars.Expand(Str);
end;

function GetAllEnvVars(const Vars: TStrings): Integer;
begin
  Result := TPJEnvironmentVars.GetAll(Vars);
end;

procedure GetAllEnvVarNames(const Names: TStrings); overload;
begin
  TPJEnvironmentVars.GetAllNames(Names);
end;

function GetAllEnvVarNames: TStringDynArray; overload;
begin
  Result := TPJEnvironmentVars.GetAllNames;
end;

function EnvBlockSize: Integer;
begin
  Result := TPJEnvironmentVars.BlockSize;
end;

{ TPJEnvVars }

resourcestring
  sSingleInstanceErr = 'Only one %1:s component is permitted for any owner: ' +
    '%1:s is already owned by %2:s';

constructor TPJEnvVars.Create(AOwner: TComponent);
var
  Idx: Integer; // loops through components of AOwner
begin
  if Assigned(AOwner) then
  begin
    // Ensure that component is unique
    for Idx := 0 to Pred(AOwner.ComponentCount) do
      if AOwner.Components[Idx] is ClassType then
        raise Exception.CreateFmt(sSingleInstanceErr,
          [ClassName, AOwner.Components[Idx].Name, AOwner.Name]);
  end;
  // All OK: go ahead and create component
  inherited;
end;

procedure TPJEnvVars.DeleteVar(const Name: string);
begin
  ErrorCheck(TPJEnvironmentVars.Delete(Name));
end;

procedure TPJEnvVars.EnumNames(Callback: TPJEnvVarsEnum; Data: Pointer);
begin
  TPJEnvironmentVars.EnumNames(Callback, Data);
end;

procedure TPJEnvVars.ErrorCheck(Code: Integer);
var
  Err: EPJEnvVars;  // reference to exception being raised
begin
  if Code <> 0 then
  begin
    Err := EPJEnvVars.Create(SysErrorMessage(Code));
    Err.ErrorCode := Code;
    raise Err;
  end;
end;

function TPJEnvVars.GetCount: Integer;
begin
  Result := TPJEnvironmentVars.Count;
end;

function TPJEnvVars.GetEnumerator: TPJEnvVarsEnumerator;
begin
  Result := TPJEnvVarsEnumerator.Create;
end;

function TPJEnvVars.GetValue(Name: string): string;
begin
  Result := TPJEnvironmentVars.GetValue(Name);
end;

procedure TPJEnvVars.SetValue(Name: string; const Value: string);
begin
  ErrorCheck(TPJEnvironmentVars.SetValue(Name, Value));
end;

{ TPJEnvVarsEnumerator }

constructor TPJEnvVarsEnumerator.Create;
begin
  fEnvVarNames := TStringList.Create;
  TPJEnvironmentVars.GetAllNames(fEnvVarNames);
  fIndex := -1;
end;

destructor TPJEnvVarsEnumerator.Destroy;
begin
  fEnvVarNames.Free;
  inherited;
end;

function TPJEnvVarsEnumerator.GetCurrent: string;
begin
  Result := fEnvVarNames[fIndex];
end;

function TPJEnvVarsEnumerator.MoveNext: Boolean;
begin
  Result := fIndex < Pred(fEnvVarNames.Count);
  if Result then
    Inc(fIndex);
end;

{ TPJEnvironmentVars }

class function TPJEnvironmentVars.BlockSize: Integer;
begin
  Result := GetAll(nil); // this function returns required block size
end;

class function TPJEnvironmentVars.Count: Integer;
var
  EnvList: TStringList; // list of all environment variables
begin
  EnvList := TStringList.Create;
  try
    GetAll(EnvList);
    Result := EnvList.Count;
  finally
    EnvList.Free;
  end;
end;

constructor TPJEnvironmentVars.Create;
begin
  raise ENoConstructException.CreateFmt(sNoConstruct, [ClassName]);
end;

class function TPJEnvironmentVars.CreateBlock(const NewEnv: TStrings;
  const IncludeCurrent: Boolean; const Buffer: Pointer;
  const BufSize: Integer): Integer;
var
  EnvVars: TStringList;
  EnvName: string;
  EnvValue: string;
  EnvNameIdx: Integer;
  Idx: Integer;
  PBuf: PChar;
begin
  EnvVars := TStringList.Create;
  try
    // Include copy of current environment block if required: current block is
    // assumed not to have duplicates.
    if IncludeCurrent then
      GetAll(EnvVars);
    // Include any additional environment variables in NewEnv. If there any
    // duplicate names in NewEnv only the entry with the greatest index is used.
    // If the current environment block is included and an environment variable
    // in NewEnv has the same name as one in the current block, then the value
    // from NewEnv is used.
    if Assigned(NewEnv) then
    begin
      for Idx := 0 to Pred(NewEnv.Count) do
      begin
        if AnsiPos('=', NewEnv[Idx]) = 0 then
          Continue; // not a valid environment variable - skip it
        EnvValue := NewEnv.ValueFromIndex[Idx];
        EnvName := NewEnv.Names[Idx];
        EnvNameIdx := EnvVars.IndexOfName(EnvName);
        if EnvNameIdx >= 0 then
          // environment variable with this name already exists: overwrite value
          EnvVars.ValueFromIndex[EnvNameIdx] := EnvValue
        else
          // environment variable with this name doesn't exist: add it
          EnvVars.Add(EnvName + '=' + EnvValue);
      end;
    end;
    // Calculate size of new environment block: block consists of #0 separated
    // list of environment variables terminated by #0#0, e.g.
    // Foo=Lorem#0Bar=Ipsum#0Raboof=Dolore#0#0
    Result := 0;
    for Idx := 0 to Pred(EnvVars.Count) do
      Inc(Result, Length(EnvVars[Idx]) + 1);  // +1 allows for #0 separator
    Inc(Result);  // allow for terminating #0
    // Check if provided buffer is large enough and create block in it if so
    if (Buffer <> nil) and (BufSize >= Result) then
    begin
      // new environment blocks are always sorted
      EnvVars.Sorted := True;
      // do the copying
      PBuf := Buffer;
      for Idx := 0 to Pred(EnvVars.Count) do
      begin
        StrPCopy(PBuf, EnvVars[Idx]);   // includes terminating #0
        Inc(PBuf, Length(EnvVars[Idx]) + 1);
      end;
      // terminate block with additional #0
      PBuf^ := #0;
    end;
  finally
    EnvVars.Free;
  end;
end;

class function TPJEnvironmentVars.Delete(const VarName: string): Integer;
begin
  if SetEnvironmentVariable(PChar(VarName), nil) then
    Result := 0
  else
    Result := GetLastError;
end;

class procedure TPJEnvironmentVars.EnumNames(Callback: TPJEnvVarsEnum;
  Data: Pointer);
var
  Idx: Integer;
  EnvList: TStringList;
begin
  Assert(Assigned(Callback));
  EnvList := TStringList.Create;
  try
    GetAll(EnvList);
    for Idx := 0 to Pred(EnvList.Count) do
      Callback(EnvList.Names[Idx], Data);
  finally
    EnvList.Free;
  end;
end;

class procedure TPJEnvironmentVars.EnumVars(Callback: TPJEnvVarsEnumEx;
  Data: Pointer);
var
  Idx: Integer;
  AllEnvVars: TPJEnvironmentVarArray;
begin
  Assert(Assigned(Callback));
  AllEnvVars := GetAll;
  for Idx := Low(AllEnvVars) to High(AllEnvVars) do
    Callback(AllEnvVars[Idx], Data);
end;

class function TPJEnvironmentVars.Exists(const VarName: string): Boolean;
begin
  Result := GetEnvironmentVariable(PChar(VarName), nil, 0) > 0;
end;

class function TPJEnvironmentVars.Expand(const Str: string): string;
var
  BufSize: Integer;
begin
  // Get required buffer size (including terminal #0)
  BufSize := ExpandEnvironmentStrings(PChar(Str), nil, 0);
  if BufSize > 1 then
  begin
    SetLength(Result, BufSize - 1); // space for terminal #0 automatically added
    ExpandEnvironmentStrings(PChar(Str), PChar(Result), BufSize);
  end
  else
    Result := ''; // tried to expand an empty string
end;

class function TPJEnvironmentVars.GetAll: TPJEnvironmentVarArray;
var
  AllEnvVars: TStringList;
  Idx: Integer;
  EnvVar: TPJEnvironmentVar;
begin
  AllEnvVars := TStringList.Create;
  try
    GetAll(AllEnvVars);
    SetLength(Result, AllEnvVars.Count);
    for Idx := 0 to Pred(AllEnvVars.Count) do
    begin
      EnvVar.Name := AllEnvVars.Names[Idx];
      EnvVar.Value := AllEnvVars.ValueFromIndex[Idx];
      Result[Idx] := EnvVar;
    end;
  finally
    AllEnvVars.Free;
  end;
end;

class function TPJEnvironmentVars.GetAll(const Vars: TStrings): Integer;
var
  PEnvVars: PChar;    // pointer to start of environment block
  PEnvEntry: PChar;   // pointer to an environment string in block
begin
  // Clear any list
  if Assigned(Vars) then
    Vars.Clear;
  // Get reference to environment block for this process
  PEnvVars := GetEnvironmentStrings;
  if PEnvVars <> nil then
  begin
    // We have a block: extract strings from it
    // Env strings are #0 terminated and list ends an additional #0, e.g.:
    // Foo=Lorem#0Bar=Ipsum#0Raboof=Dolore#0#0
    PEnvEntry := PEnvVars;
    try
      while PEnvEntry^ <> #0 do
      begin
        if Assigned(Vars) then
          Vars.Add(PEnvEntry);
        Inc(PEnvEntry, StrLen(PEnvEntry) + 1);  // +1 to skip terminating #0
      end;
      // Calculate length of block
      Result := (PEnvEntry - PEnvVars) + 1;     // + 1 to allow for final #0
    finally
      FreeEnvironmentStrings(PEnvVars);
    end;
  end
  else
    // No block => zero length
    Result := 0;
end;

class procedure TPJEnvironmentVars.GetAllNames(const Names: TStrings);
var
  AllEnvVars: TStrings;
  Idx: Integer;
begin
  Assert(Assigned(Names));
  Names.Clear;
  AllEnvVars := TStringList.Create;
  try
    GetAll(AllEnvVars);
    for Idx := 0 to Pred(AllEnvVars.Count) do
      Names.Add(AllEnvVars.Names[Idx]);
  finally
    AllEnvVars.Free;
  end;
end;

class function TPJEnvironmentVars.GetAllNames: TStringDynArray;
var
  Names: TStrings;
  Idx: Integer;
begin
  Names := TStringList.Create;
  try
    GetAllNames(Names);
    SetLength(Result, Names.Count);
    for Idx := 0 to Pred(Names.Count) do
      Result[Idx] := Names[Idx];
  finally
    Names.Free;
  end;
end;

class function TPJEnvironmentVars.GetValue(const VarName: string): string;
var
  BufSize: Integer;
begin
  // Get required buffer size (including terminal #0)
  BufSize := GetEnvironmentVariable(PChar(VarName), nil, 0);
  if BufSize > 1 then
  begin
    // Env var exists and is non-empty: read value into result string
    SetLength(Result, BufSize - 1); // space for terminal #0 automatically added
    GetEnvironmentVariable(PChar(VarName), PChar(Result), BufSize);
  end
  else
    Result := '';
end;

class function TPJEnvironmentVars.SetValue(const VarName, VarValue: string):
  Integer;
begin
  if SetEnvironmentVariable(PChar(VarName), PChar(VarValue)) then
    Result := 0
  else
    Result := GetLastError;
end;

end.

