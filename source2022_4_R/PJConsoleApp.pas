{
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/
 *
 * Copyright (C) 2007-2013, Peter Johnson (www.delphidabbler.com).
 *
 * $Rev: 1351 $
 * $Date: 2013-03-25 01:53:03 +0000 (Mon, 25 Mar 2013) $
 *
 * Classes that encapsulate and executes a command line application and
 * optionally redirects the application's standard input, output and error.
}


unit PJConsoleApp;

{$UNDEF COMPILERSUPPORTED}
{$UNDEF RTLNAMESPACES}
{$UNDEF SUPPORTSTALPHACOLOR}
{$IFDEF CONDITIONALEXPRESSIONS}
  {$IF CompilerVersion >= 15.0}   // >= Delphi 7
    {$DEFINE COMPILERSUPPORTED}
  {$IFEND}
  {$IF CompilerVersion >= 23.0}   // >= Delphi XE2
    {$DEFINE RTLNAMESPACES}
    {$DEFINE SUPPORTSTALPHACOLOR}
  {$IFEND}
{$ENDIF}

{$IFNDEF COMPILERSUPPORTED}
  {$MESSAGE FATAL 'Minimum compiler version is Delphi 7'}
{$ENDIF}

{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}

interface


uses
  // Delphi
  {$IFNDEF RTLNAMESPACES}
  Classes, Windows, Graphics, Types;
  {$ELSE}
  System.Classes, Winapi.Windows, System.UITypes, System.Types;
  {$ENDIF}


const
  // Constants for working in milliseconds
  ///  <summary>One second in milliseconds.</summary>
  cOneSecInMS = 1000;
  ///  <summary>One minute in milliseconds.</summary>
  cOneMinInMS = 60 * cOneSecInMS;

  // Default values for some TPJConsoleApp properties
  ///  <summary>Default time slice allocated to console app.</summary>
  cDefTimeSlice = 50;
  ///  <summary>Console app's maximum execution time.</summary>
  cDefMaxExecTime = cOneMinInMS;

  ///  <summary>Mask that is ORd with application error codes.</summary>
  ///  <remarks>
  ///  <para>According to Windows API docs, error codes with bit 29 set are
  ///  reserved for application use.</para>
  ///  <para>Test for an app error code by and-ing the error code with this
  ///  mask.</para>
  ///  </remarks>
  cAppErrorMask = 1 shl 29;

  // Application errors
  ///  <summary>Application time-out error code.</summary>
  cAppErrorTimeOut = 1 or cAppErrorMask;
  ///  <summary>Application terminated error code.</summary>
  cAppErrorTerminated = 2 or cAppErrorMask;

///  <summary>Checks if given error code is an application defined error.
///  </summary>
///  <remarks>Application defined errors have bit 29 set.</remarks>
function IsApplicationError(const ErrCode: LongWord): Boolean;

type
  ///  <summary>
  ///  Enumeration of possible priorties for a console application.
  ///  </summary>
  TPJConsoleAppPriority = (
    cpDefault,    // use default priority (see Win API docs for details)
    cpHigh,       // use for time-critical tasks: processor intensive
    cpNormal,     // normal process with no specific scheduling needs
    cpIdle,       // run only when system idle
    cpRealTime    // highest possible priority: preempts all threads inc OS
  );

type
  ///  <summary>
  ///  Enumeration of possible colours to be used for a console's foreground and
  ///  background.
  ///  </summary>
  ///  <remarks>
  ///  <para>It is important that the assigned ordinal values are retained. They
  ///  relate to various combinations of the FOREGROUND_* constants declared in
  ///  the Windows unit.</para>
  ///  <para>Foreground colours are obtained directly from these ordinal values
  ///  while background colours are obtained by left shifting the values by 4.
  ///  </para>
  ///  <para>The value names are similar to the equivalent TColor constants, but
  ///  they have different numeric values.</para>
  ///  </remarks>
  TPJConsoleColor = (
    ccBlack   =  0,
    ccNavy    =  1,
    ccGreen   =  2,
    ccTeal    =  3,
    ccMaroon  =  4,
    ccPurple  =  5,
    ccOlive   =  6,
    ccSilver  =  7,
    ccGray    =  8,
    ccBlue    =  9,
    ccLime    = 10,
    ccAqua    = 11,
    ccRed     = 12,
    ccFuchsia = 13,
    ccYellow  = 14,
    ccWhite   = 15
  );

type
  ///  <summary>
  ///  Type of the TPJConsoleApp.ConsoleColors property. Records the console's
  ///  foreground and background colours.
  ///  </summary>
  TPJConsoleColors = record
    ///  <summary>Console's foreground colour.</summary>
    Foreground: TPJConsoleColor;
    ///  <summary>Console's background colour.</summary>
    Background: TPJConsoleColor;
  end;

///  <summary>"Constructor" function that creates a TPJConsoleColors record from
///  given foreground and background TPJConsoleColor colours.</summary>
///  <remarks>This function is provided because it is not possible to assign the
///  fields of the TPJConsoleApp.ConsoleColors property individually. Instead
///  assign the return value of this function to the property.</remarks>
function MakeConsoleColors(const AForeground, ABackground: TPJConsoleColor):
  TPJConsoleColors; overload;

///  <summary>"Constructor" function that creates a TPJConsoleColors record from
///  given foreground and background TColor colours.</summary>
///  <remarks>
///  <para>This function is provided as a convenience to enable normal TColor
///  values to be used to instantiate a TPJConsoleColours record without having
///  to manually convert to TPJConsoleColour values.</para>
///  <para>An exception is raised if either TColor value is not one of the 16
///  standard colours.</para>
///  </remarks>
function MakeConsoleColors(const AForeground, ABackground: TColor):
  TPJConsoleColors; overload;

{$IFDEF SUPPORTSTALPHACOLOR}
///  <summary>"Constructor" function that creates a TPJConsoleColors record from
///  given foreground and background TAlphaColor colours.</summary>
///  <remarks>
///  <para>This function is provided as a convenience to enable normal
///  TAlphaColor values to be used to instantiate a TPJConsoleColours record
///  without having to manually convert to TPJConsoleColour values.</para>
///  <para>An exception is raised if either TAlphaColor value is not one of the
///  16 standard colours.</para>
///  </remarks>
function MakeConsoleColors(const AForeground, ABackground: TAlphaColor):
  TPJConsoleColors; overload;
{$ENDIF}

///  <summary>"Constructor" function for TSize records.</summary>
///  <remarks>This function is provided because if is not possible to assign the
///  fields of properties of type TSize individually. Instead assign the return
///  value of this function to such properties.</remarks>
function MakeSize(const ACX, ACY: LongInt): TSize;

type
  ///  <summary>
  ///  Base class for classe that execute a command line (console) application.
  ///  </summary>
  ///  <remarks>
  ///  <para>Many properties are available to customise how the console app is
  ///  executed and how the console appears.</para>
  ///  <para>All properties are declared protected. Descendant classes can make
  ///  required properties public.</para>
  ///  </remarks>
  TPJCustomConsoleApp = class(TObject)
  private
    ///  <summary>Reference to OnWork event handler.</summary>
    fOnWork: TNotifyEvent;
    ///  <summary>Reference to OnComplete event handler.</summary>
    fOnComplete: TNotifyEvent;
    ///  <summary>Reference to OnStart event handler.</summary>
    fOnStart: TNotifyEvent;
    ///  <summary>Handle of console app's redirected standard input. 0 if not
    ///  redirected.</summary>
    fStdIn: THandle;
    ///  <summary>Handle of console app's redirected standard output. 0 if not
    ///  redirected.</summary>
    fStdOut: THandle;
    ///  <summary>Handle of console app's redirected standard error. 0 if not
    ///  redirected.</summary>
    fStdErr: THandle;
    ///  <summary>Command line used to execute application.</summary>
    fCommandLine: string;
    ///  <summary>Specifies console application's current directory.</summary>
    fCurrentDir: string;
    ///  <summary>Exit code returned by console app.</summary>
    fExitCode: LongWord;
    ///  <summary>Maximum execution time of console app (in ms).</summary>
    fMaxExecTime: LongWord;
    ///  <summary>Description of any error that occured while trying to execute
    ///  console app.</summary>
    fErrorMessage: string;
    ///  <summary>Code of any error that occured while trying to execute console
    ///  app.</summary>
    fErrorCode: LongWord;
    ///  <summary>Determines whether console app is to be visible or hidden.
    ///  </summary>
    fVisible: Boolean;
    ///  <summary>Time console app can run between OnWork events (in ms).
    ///  </summary>
    fTimeSlice: LongWord;
    ///  <summary>Determines whether a timed out process is killed.</summary>
    fKillTimedOutProcess: Boolean;
    ///  <summary>Time remaining before console app times out (in ms).</summary>
    fTimeToLive: LongWord;
    ///  <summary>Time since console app started running (in ms).</summary>
    fElapsedTime: LongWord;
    ///  <summary>Flag set by Terminate method to request that a console app is
    ///  terminated.</summary>
    fRequestTerminate: Boolean;
    ///  <summary>Pointer to process security and inheritance attributes.
    ///  </summary>
    fProcessAttrs: PSecurityAttributes;
    ///  <summary>Pointer to thread security and inheritance attributes.
    ///  </summary>
    fThreadAttrs: PSecurityAttributes;
    ///  <summary>Indicates whether console app should be started in a new
    ///  console window.</summary>
    fUseNewConsole: Boolean;
    ///  <summary>Title to be displayed in a new console window. If '' default
    ///  window title is used.</summary>
    fConsoleTitle: string;
    ///  <summary>Colours to be used in a console window.</summary>
    fConsoleColors: TPJConsoleColors;
    ///  <summary>Size of console's screen buffer in character columns and rows.
    ///  </summary>
    fScreenBufferSize: TSize;
    ///  <summary>Size of console's window in pixels.</summary>
    fWindowSize: TSize;
    ///  <summary>Position of console's window in pixel co-oridinates relative
    ///  to the screen.</summary>
    fWindowPosition: TPoint;
    ///  <summary>Pointer to environment block to be passed to console app.
    ///  </summary>
    fEnvironment: Pointer;
    ///  <summary>Information about running console app process. All values are
    ///  zero when no process is running.</summary>
    fProcessInfo: TProcessInformation;
    ///  <summary>Priority with which console app is started.</summary>
    fPriority: TPJConsoleAppPriority;
    ///  <summary>Monitors a running process, triggering events at the end of
    ///  each timeslice and when the process completes.</summary>
    function MonitorProcess: Boolean;
    ///  <summary>Sets ExitCode property to value returned from console app on
    ///  completion.</summary>
    ///  <returns>Boolean. True if exit code retrieved OK and False if not.
    ///  </returns>
    ///  <remarks>Sets ErrorCode if exit code is not retrieved.</remarks>
    function SetExitCode: Boolean;
    ///  <summary>Setter for MaxExecTime property.</summary>
    procedure SetMaxExecTime(const Value: LongWord);
    ///  <summary>Setter for TimeSlice property.</summary>
    procedure SetTimeSlice(const Value: LongWord);
    ///  <summary>Zeroes the process information structure.</summary>
    procedure ZeroProcessInfo;
    ///  <summary>Gets process handle from process info structure.</summary>
    ///  <returns>THandle. Required process handle or 0 if no process is
    ///  running.</returns>
    function GetProcessHandle: THandle;
    ///  <summary>Updates or clears stored security attributes.</summary>
    ///  <param name="OldValue">PSecurityAttributes [in/out] Passed a pointer
    ///  to attributes to be updated. On return set to point to a copy of
    ///  NewValue structure unless NewValue is nil when OldValue is set to nil.
    ///  </param>
    ///  <param name="NewValue">PSecurityAttributes [in] Pointer to new
    ///  security attributes. May be nil if attributes storage is to be cleared.
    ///  </param>
    procedure UpdateSecurityAttrs(var OldValue: PSecurityAttributes;
      const NewValue: PSecurityAttributes);
    ///  <summary>Frees memory of a security attributes structure.</summary>
    ///  <param name="Attrs">PSecurityAttributes [in/out] Points to security
    ///  attributes to be freed. Set to nil on return.</param>
    ///  <remarks>Attrs may be nil, in which case no actions is taken.</remarks>
    procedure FreeSecurityAttrs(var Attrs: PSecurityAttributes);
    ///  <summary>Setter for ProcessAttrs property. Makes a copy of new value if
    ///  non-nil.</summary>
    procedure SetProcessAttrs(const Value: PSecurityAttributes);
    ///  <summary>Setter for ThreadAttrs property. Makes a copy of new value if
    ///  non-nil.</summary>
    procedure SetThreadAttrs(const Value: PSecurityAttributes);
  protected
    ///  <summary>Starts a process and gets information about it from OS.
    ///  </summary>
    ///  <param name="CmdLine">string [in] Command line to be executed.
    ///  </param>
    ///  <param name="CurrentDir">string [in] Application's current directory.
    ///  Pass '' to use same current directory as parent application.</param>
    ///  <param name="ProcessInfo">TProcessInformation [out] Passes process
    ///  information back to caller.</param>
    ///  <returns>Boolean. True if process was created OK, False if process
    ///  couldn't be started.</returns>
    function StartProcess(const CmdLine, CurrentDir: string;
      out ProcessInfo: TProcessInformation): Boolean;
    ///  <summary>Triggers OnStart event.</summary>
    procedure DoStart; virtual;
    ///  <summary>Triggers OnWork event.</summary>
    procedure DoWork; virtual;
    ///  <summary>Triggers OnComplete event.</summary>
    procedure DoComplete; virtual;
    ///  <summary>Sets error code and message to a class-defined error.
    ///  </summary>
    ///  <param name="Code">LongWord [in] Error code. Must have bit 29 set to
    ///  indicate an application error code.</param>
    ///  <param name="Msg">string [in] Error message.</param>
    procedure RecordAppError(const Code: LongWord; const Msg: string);
    ///  <summary>Sets error code and message to the last-reported Windows
    ///  error.</summary>
    procedure RecordWin32Error;
    ///  <summary>Resets error code and message to indicate no error.</summary>
    procedure ResetError;
    ///  <summary>Inheritable handle of console app's redirected standard input
    ///  Must be zero if standard input not redirected.</summary>
    property StdIn: THandle read fStdIn write fStdIn default 0;
    ///  <summary>Inheritable handle of console app's redirected standard output
    ///  Must be zero if standard output not redirected.</summary>
    property StdOut: THandle read fStdOut write fStdOut default 0;
    ///  <summary>Inheritable handle of console app's redirected standard error
    ///  Must be zero if standard error not redirected.</summary>
    property StdErr: THandle read fStdErr write fStdErr default 0;
    ///  <summary>Command line to execute. Includes program name and any
    ///  parameters. Paths containing spaces must be quoted.</summary>
    property CommandLine: string read fCommandLine write fCommandLine;
    ///  <summary>Application's current directory. Set to '' to use same current
    ///  directory as parent application.</summary>
    property CurrentDir: string read fCurrentDir write fCurrentDir;
    ///  <summary>Determines whether console app's console is to be displayed
    ///  (True) or hidden (False).</summary>
    property Visible: Boolean read fVisible write fVisible default False;
    ///  <summary>Maximum execution time of console app in ms. Set to INFINITE
    ///  if no execution time limit is required.</summary>
    property MaxExecTime: LongWord read fMaxExecTime write SetMaxExecTime
      default cDefMaxExecTime;
    ///  <summary>Time console app executes between OnWork events, in ms.
    ///  </summary>
    ///  <remarks>
    ///  <para>The app is paused at the end of each time slice while OnWork
    ///  executes.</para>
    ///  <para>Setting TimeSlice to INFINITE means that the app never pauses and
    ///  the OnWork event is never triggered.</para>
    /// </remarks>
    property TimeSlice: LongWord read fTimeSlice write SetTimeSlice
      default cDefTimeSlice;
    ///  <summary>Determines whether timed out console apps are forcible
    ///  terminated.</summary>
    ///  <remarks>When False the Execute method returns when the console app
    ///  times out but leaves the app to run to completion. When true the
    ///  console app is killed when Execute returns.</remarks>
    property KillTimedOutProcess: Boolean
      read fKillTimedOutProcess write fKillTimedOutProcess
      default True;
    ///  <summary>Points to a record of security and inheritance attributes for
    ///  a console app process.</summary>
    ///  <remarks>
    ///  <para>When nil the process handle can't be inherited.</para>
    ///  <para>When set to a non nil pointer a copy of the referenced structure
    ///  is made.</para>
    ///  </remarks>
    property ProcessAttrs: PSecurityAttributes
      read fProcessAttrs write SetProcessAttrs default nil;
    ///  <summary>Points to a record of security and inheritance attributes for
    ///  the console app's primary thread.</summary>
    ///  <remarks>
    ///  <para>When nil the thread handle can't be inherited.</para>
    ///  <para>When set to a non nil pointer a copy of the referenced structure
    ///  is made.</para>
    ///  </remarks>
    property ThreadAttrs: PSecurityAttributes
      read fThreadAttrs write SetThreadAttrs default nil;
    ///  <summary>Determines if a console app opens a new console window (True)
    ///  or uses any existing console (False).</summary>
    property UseNewConsole: Boolean
      read fUseNewConsole write fUseNewConsole default False;
    ///  <summary>Title to be displayed in any new console window. If set to the
    ///  empty string the window's default title is displayed.</summary>
    ///  <remarks>If a console app shares a console this property has no effect.
    ///  </remarks>
    property ConsoleTitle: string
      read fConsoleTitle write fConsoleTitle;
    ///  <summary>Specifies the foreground and background colours of a new
    ///  console window.</summary>
    ///  <remarks>If a console app shares a console this property has no effect.
    ///  </remarks>
    property ConsoleColors: TPJConsoleColors
      read fConsoleColors write fConsoleColors;
    ///  <summary>Specifies the size of a console's screen buffer in character
    ///  columns and rows. If either dimension is zero or negative the default
    ///  buffer size is used.</summary>
    ///  <remarks>If a console app shares a console this property has no effect.
    ///  </remarks>
    property ScreenBufferSize: TSize
      read fScreenBufferSize write fScreenBufferSize;
    ///  <summary>Position of top left of console window in pixel co-ordinates
    ///  relative to the screen. If either co-ordinate is negative or zero the
    ///  default window position is used.</summary>
    ///  <remarks>If a console app shares a console this property has no effect.
    ///  </remarks>
    property WindowPosition: TPoint
      read fWindowPosition write fWindowPosition;
    ///  <summary>Size of console window in pixels. If either dimension is
    ///  negative and the default window size is used.</summary>
    ///  <remarks>If a console app shares a console this property has no effect.
    ///  </remarks>
    property WindowSize: TSize
      read fWindowSize write fWindowSize;
    ///  <summary>Pointer to the environment block to be used by a console app.
    ///  </summary>
    ///  <remarks>The caller is responsible for allocating and freeing the
    ///  memory used for the environment block. This memory must remain
    ///  allocated while the console app is running.</remarks>
    property Environment: Pointer
      read fEnvironment write fEnvironment;
    ///  <summary>Priority with which a console app is executed.</summary>
    property Priority: TPJConsoleAppPriority
      read fPriority write fPriority default cpDefault;
    ///  <summary>Amount of time, in ms, a console app has remaining before
    ///  it times out.</summary>
    ///  <remarks>This value will be INFINITE if MaxExecTime is INFINITE.
    ///  </remarks>
    property TimeToLive: LongWord
      read fTimeToLive;
    ///  <summary>Amount of time, in ms, since a console app started.</summary>
    ///  <remarks>Not updated after the app completes or times out.</remarks>
    property ElapsedTime: LongWord
      read fElapsedTime;
    ///  <summary>Provides information about the executing process.</summary>
    ///  <remarks>All fields are zero when no process is executing.</remarks>
    property ProcessInfo: TProcessInformation
      read fProcessInfo;
    ///  <summary>Records the console app's exit code.</summary>
    ///  <remarks>
    ///  <para>The meaning of exit codes is application dependant.</para>
    ///  <para>ExitCode is not valid if ErrorCode is non-zero.</para>
    ///  </remarks>
    property ExitCode: LongWord
      read fExitCode;
    ///  <summary>Code indicating if a console app was executed successfully.
    ///  Zero indicates success, non-zero indicates a problem.</summary>
    ///  <remarks>Error codes are either Windows error codes or are set by the
    ///  class (e.g. application timed out or was terminated). Class specific
    ///  error codes have bit 29 set.</remarks>
    property ErrorCode: LongWord
      read fErrorCode;
    ///  <summary>Error message corresponding to the value of ErrorCode. Empty
    ///  string if ErrorCode is zero.</summary>
    property ErrorMessage: string
      read fErrorMessage;
    ///  <summary>Event triggered just after console application process is
    ///  created, just before it starts executing.</summary>
    ///  <remarks>ProcessInfo has valid data during this event.</remarks>
    property OnStart: TNotifyEvent read fOnStart write fOnStart;
    ///  <summary>Event triggered periodically while a console app is executing.
    ///  </summary>
    ///  <remarks>
    ///  <para>The frequency this event is triggered depends on the value of the
    ///  TimeSlice property. If TimeSlice is INFINITE then the event is never
    ///  triggered.</para>
    ///  <para>ProcessInfo has valid data during this event.</para>
    ///  </remarks>
    property OnWork: TNotifyEvent
      read fOnWork write fOnWork;
    ///  <summary>Event triggered when application completes or times out. Can
    ///  be used to tidy up after a process has completed.</summary>
    ///  <remarks>
    ///  <para>This event is always triggered. It fires after the last OnWork
    ///  event.</para>
    ///  <para>ErrorCode will have been set and can be used to check how the
    ///  process terminated.</para>
    ///  <para>ProcessInfo has valid data during this event.</para>
    ///  </remarks>
    property OnComplete: TNotifyEvent
      read fOnComplete write fOnComplete;
  public
    ///  <summary>Object constructor. Instantiates object and sets default
    ///  properties.</summary>
    constructor Create;
    ///  <summary>Object destructor. Tears down object.</summary>
    destructor Destroy; override;
    ///  <summary>Executes a console app.</summary>
    ///  <param name="CmdLine">string [in] Command line to execute. Includes
    ///  program name and any parameters. Paths containing spaces must be
    ///  quoted.</param>
    ///  <param name="CurrentDir">string [in] Application's current directory.
    ///  Pass '' to use same current directory as parent application.</param>
    ///  <returns>Boolean. True if console app runs successfully or False if
    ///  it fails to run.</returns>
    ///  <remarks>The CommandLine and CurrentDir properties are set to the
    ///  values of the CmdLine and CurrentDir parameters respectively.</remarks>
    function Execute(const CmdLine: string; const CurrentDir: string = ''):
      Boolean; overload;
    ///  <summary>Executes a console app specified by the CommandLine property
    ///  with the current directory specified by the CurrentDir property.
    ///  </summary>
    ///  <returns>Boolean. True if console app runs successfully or False if
    ///  it fails to run.</returns>
    function Execute: Boolean; overload;
    ///  <summary>Attempts to terminate the current console app.</summary>
    ///  <remarks>Calling this method causes the Execute method to return after
    ///  the next OnWork event. If KillTimedOutProcess is true the console
    ///  application will be halted. The method has no effect when TimeSlice is
    ///  INFINITE.</remarks>
    procedure Terminate;
  end;

  ///  <summary>
  ///  Class that execute a command line (console) application.
  ///  </summary>
  ///  <remarks>
  ///  <para>Many properties are available to customise how the console app is
  ///  executed and how the console appears.</para>
  ///  <para>This class simply makes public all the protected properties of
  ///  TPJCustomConsoleApp.</para>
  ///  </remarks>
  TPJConsoleApp = class(TPJCustomConsoleApp)
  public
    // Make all inherited protected properties public
    property StdIn;
    property StdOut;
    property StdErr;
    property CommandLine;
    property CurrentDir;
    property Visible;
    property MaxExecTime;
    property TimeSlice;
    property KillTimedOutProcess;
    property ProcessAttrs;
    property ThreadAttrs;
    property UseNewConsole;
    property ConsoleTitle;
    property ConsoleColors;
    property ScreenBufferSize;
    property WindowPosition;
    property WindowSize;
    property Environment;
    property Priority;
    property TimeToLive;
    property ElapsedTime;
    property ProcessInfo;
    property ExitCode;
    property ErrorCode;
    property ErrorMessage;
    property OnStart;
    property OnWork;
    property OnComplete;
  end;


implementation


uses
  // Delphi
  {$IFNDEF RTLNAMESPACES}
  SysUtils, DateUtils;
  {$ELSE}
  System.SysUtils, System.DateUtils;
  {$ENDIF}


resourcestring
  // Error messages
  sErrTimeout = 'Application timed out';
  sTerminated = 'Application terminated';

function IsApplicationError(const ErrCode: LongWord): Boolean;
begin
  Result := (ErrCode and cAppErrorMask) <> 0;
end;

function MakeConsoleColors(const AForeground, ABackground: TPJConsoleColor):
  TPJConsoleColors;
begin
  Result.Foreground := AForeground;
  Result.Background := ABackground;
end;

function MakeConsoleColors(const AForeground, ABackground: TColor):
  TPJConsoleColors;
  // ---------------------------------------------------------------------------
  // Converts a TColor into equivalent TPJConsoleColor. Raises exception if
  // TColor value is not one of the 16 standard colours.
  function ConvertColor(Color: TColor): TPJConsoleColor;
  resourcestring
    sUnsupportedColour = 'Invalid console window colour';
  begin
    case Color of
      {$IFDEF RTLNAMESPACES}
      // Using RTL Namespaces => using System.UITypes instead of Vcl.Graphics,
      // so we don't have clXXX colour constant and must use equivalent TColors
      // constants instead.
      TColors.Black:    Result := ccBlack;
      TColors.Navy:     Result := ccNavy;
      TColors.Green:    Result := ccGreen;
      TColors.Teal:     Result := ccTeal;
      TColors.Maroon:   Result := ccMaroon;
      TColors.Purple:   Result := ccPurple;
      TColors.Olive:    Result := ccOlive;
      TColors.Silver:   Result := ccSilver;
      TColors.Gray:     Result := ccGray;
      TColors.Blue:     Result := ccBlue;
      TColors.Lime:     Result := ccLime;
      TColors.Aqua:     Result := ccAqua;
      TColors.Red:      Result := ccRed;
      TColors.Fuchsia:  Result := ccFuchsia;
      TColors.Yellow:   Result := ccYellow;
      TColors.White:    Result := ccWhite;
      {$ELSE}
      // Not using RTL Namespaces means we are using Graphics unit and can use
      // normal clXXX TColor constants
      clBlack:          Result := ccBlack;
      clNavy:           Result := ccNavy;
      clGreen:          Result := ccGreen;
      clTeal:           Result := ccTeal;
      clMaroon:         Result := ccMaroon;
      clPurple:         Result := ccPurple;
      clOlive:          Result := ccOlive;
      clSilver:         Result := ccSilver;
      clGray:           Result := ccGray;
      clBlue:           Result := ccBlue;
      clLime:           Result := ccLime;
      clAqua:           Result := ccAqua;
      clRed:            Result := ccRed;
      clFuchsia:        Result := ccFuchsia;
      clYellow:         Result := ccYellow;
      clWhite:          Result := ccWhite;
      {$ENDIF}
      else raise Exception.Create(sUnsupportedColour);
    end;
  end;
  // ---------------------------------------------------------------------------
begin
  Result := MakeConsoleColors(
    ConvertColor(AForeground), ConvertColor(ABackground)
  );
end;

{$IFDEF SUPPORTSTALPHACOLOR}
function MakeConsoleColors(const AForeground, ABackground: TAlphaColor):
  TPJConsoleColors;
var
  FG, BG: TColor;
begin
  FG := TColor(
    RGB(
      TAlphaColorRec(AForeground).R,
      TAlphaColorRec(AForeground).G,
      TAlphaColorRec(AForeground).B
    )
  );
  BG := TColor(
    RGB(
      TAlphaColorRec(ABackground).R,
      TAlphaColorRec(ABackground).G,
      TAlphaColorRec(ABackground).B
    )
  );
  Result := MakeConsoleColors(FG, BG);
end;
{$ENDIF}

function MakeSize(const ACX, ACY: LongInt): TSize;
begin
  Result.cx := ACX;
  Result.cy := ACY;
end;

{ TPJCustomConsoleApp }

constructor TPJCustomConsoleApp.Create;
begin
  inherited Create;
  // Set default property values
  fMaxExecTime := cDefMaxExecTime;
  fTimeSlice := cDefTimeSlice;
  fVisible := False;
  fStdIn := 0;
  fStdOut := 0;
  fStdErr := 0;
  fKillTimedOutProcess := True;
  ZeroProcessInfo;
  fProcessAttrs := nil;
  fThreadAttrs := nil;
  fUseNewConsole := False;
  fEnvironment := nil;
  fPriority := cpDefault;
  fConsoleTitle := '';
  fScreenBufferSize := MakeSize(0, 0);
  fConsoleColors := MakeConsoleColors(ccWhite, ccBlack);
  fWindowPosition := Point(-1, -1);
  fWindowSize := MakeSize(0, 0);
end;

destructor TPJCustomConsoleApp.Destroy;
begin
  FreeSecurityAttrs(fProcessAttrs);
  FreeSecurityAttrs(fThreadAttrs);
  inherited;
end;

procedure TPJCustomConsoleApp.DoComplete;
begin
  if Assigned(fOnComplete) then
    fOnComplete(Self);
end;

procedure TPJCustomConsoleApp.DoStart;
begin
  if Assigned(fOnStart) then
    fOnStart(Self);
end;

procedure TPJCustomConsoleApp.DoWork;
begin
  if Assigned(fOnWork) then
    fOnWork(Self);
end;

function TPJCustomConsoleApp.Execute: Boolean;
var
  ProcessInfo: TProcessInformation; // information about process
begin
  fExitCode := 0;
  ResetError;
  ZeroProcessInfo;
  Result := StartProcess(fCommandLine, fCurrentDir, ProcessInfo);
  if Result then
  begin
    // Process started: monitor its progress
    try
      fProcessInfo := ProcessInfo;
      DoStart;
      Result := MonitorProcess and SetExitCode;
    finally
      // Process ended: tidy up
      ZeroProcessInfo;
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ProcessInfo.hThread);
    end;
  end
  else
  begin
    // Couldn't start process: error
    RecordWin32Error;
    ZeroProcessInfo;
  end;
end;

function TPJCustomConsoleApp.Execute(const CmdLine, CurrentDir: string):
  Boolean;
begin
  fCommandLine := CmdLine;
  fCurrentDir := CurrentDir;
  Result := Execute;
end;

procedure TPJCustomConsoleApp.FreeSecurityAttrs(var Attrs: PSecurityAttributes);
begin
  if Assigned(Attrs) then
  begin
    FreeMem(Attrs);
    Attrs := nil;
  end;
end;

function TPJCustomConsoleApp.GetProcessHandle: THandle;
begin
  Result := fProcessInfo.hProcess;
end;

function TPJCustomConsoleApp.MonitorProcess: Boolean;
var
  AppState: DWORD;        // State of app after last wait
  StartTime: TDateTime;   // Time application starts
begin
  Result := True;
  StartTime := Now;
  fRequestTerminate := False;
  fTimeToLive := fMaxExecTime;
  fElapsedTime := 0;
  repeat
    // Pause and wait for app - length determined by TimeSlice property
    AppState := WaitForSingleObject(GetProcessHandle, fTimeSlice);
    fElapsedTime := Int64Rec(MilliSecondsBetween(StartTime, Now)).Lo;
    if fMaxExecTime <> INFINITE then
      if fElapsedTime >= fMaxExecTime then
        fTimeToLive := 0
      else
        fTimeToLive := fMaxExecTime - fElapsedTime;
    if AppState = WAIT_FAILED then
    begin
      RecordWin32Error;
      Result := False;
    end
    else if fTimeSlice <> INFINITE then
      // All OK: do inter-timeslice processing
      DoWork;
  until (AppState <> WAIT_TIMEOUT) or (fTimeToLive <= 0) or fRequestTerminate;
  fTimeToLive := 0;
  // App halted or timed out: check which
  if (AppState = WAIT_TIMEOUT) or fRequestTerminate then
  begin
    if fRequestTerminate then
      RecordAppError(cAppErrorTerminated, sTerminated)
    else
      RecordAppError(cAppErrorTimeOut, sErrTimeout);
    DoComplete;   // trigger OnComplete before possibly terminating process
    Result := False;
    if KillTimedOutProcess then
      TerminateProcess(GetProcessHandle, fErrorCode);
  end
  else
    DoComplete;
end;

procedure TPJCustomConsoleApp.RecordAppError(const Code: LongWord;
  const Msg: string);
begin
  Assert(IsApplicationError(Code));
  fErrorCode := Code;
  fErrorMessage := Msg;
end;

procedure TPJCustomConsoleApp.RecordWin32Error;
begin
  fErrorCode := GetLastError;
  fErrorMessage := SysErrorMessage(fErrorCode);
end;

procedure TPJCustomConsoleApp.ResetError;
begin
  fErrorCode := 0;
  fErrorMessage := '';
end;

function TPJCustomConsoleApp.SetExitCode: Boolean;
begin
  Result := GetExitCodeProcess(GetProcessHandle, fExitCode);
  if not Result then
    RecordWin32Error;
end;

procedure TPJCustomConsoleApp.SetMaxExecTime(const Value: LongWord);
begin
  if Value = 0 then
    fMaxExecTime := cDefMaxExecTime
  else
    fMaxExecTime := Value;
end;

procedure TPJCustomConsoleApp.SetProcessAttrs(const Value: PSecurityAttributes);
begin
  UpdateSecurityAttrs(fProcessAttrs, Value);
end;

procedure TPJCustomConsoleApp.SetThreadAttrs(const Value: PSecurityAttributes);
begin
  UpdateSecurityAttrs(fThreadAttrs, Value);
end;

procedure TPJCustomConsoleApp.SetTimeSlice(const Value: LongWord);
begin
  if Value > 0 then
    fTimeSlice := Value
  else
    fTimeSlice := cDefTimeSlice;
end;

function TPJCustomConsoleApp.StartProcess(const CmdLine, CurrentDir: string;
  out ProcessInfo: TProcessInformation): Boolean;
const
  // Maps Visible property to required wondows flags
  cShowFlags: array[Boolean] of Integer = (SW_HIDE, SW_SHOW);
  // Maps Priority property to creation flags
  cPriorityFlags: array[TPJConsoleAppPriority] of DWORD = (
    0, HIGH_PRIORITY_CLASS, NORMAL_PRIORITY_CLASS, IDLE_PRIORITY_CLASS,
    REALTIME_PRIORITY_CLASS
  );
var
  StartInfo: TStartupInfo;  // information about process from OS
  CurDir: PChar;            // stores current directory
  CreateFlags: DWORD;       // creation flags
  SafeCmdLine: string;      // stores unique string containing command line
begin
  // Prepare work-around for Unicode CreateProcess API function "feature"
  // See http://bit.ly/adgQ8H
  SafeCmdLine := CmdLine;
  UniqueString(SafeCmdLine);

  // Set up startup information structure
  FillChar(StartInfo, Sizeof(StartInfo),#0);
  with StartInfo do
  begin
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW or STARTF_USEFILLATTRIBUTE;
    if (fStdIn <> 0) or (fStdOut <> 0) or (fStdErr <> 0) then
      dwFlags := dwFlags or STARTF_USESTDHANDLES;                 // redirecting
    if (fScreenBufferSize.cx > 0) and (fScreenBufferSize.cy > 0) then
    begin
      dwFlags := dwFlags or STARTF_USECOUNTCHARS;  // setting screen buffer size
      dwXCountChars := fScreenBufferSize.cx;
      dwYCountChars := fScreenBufferSize.cy;
    end;
    if (fWindowSize.cx > 0) and (fWindowSize.cy > 0) then
    begin
      dwFlags := dwFlags or STARTF_USESIZE;               // setting window size
      dwXSize := fWindowSize.cx;
      dwYSize := fWindowSize.cy;
    end;
    if (fWindowPosition.X >= 0) and (fWindowPosition.Y >= 0) then
    begin
      dwFlags := dwFlags or STARTF_USEPOSITION;       // setting window position
      dwX := fWindowPosition.X;
      dwY := fWindowPosition.Y;
    end;
    dwFillAttribute := Ord(fConsoleColors.Foreground)   // set fg and bg colours
      or (Ord(fConsoleColors.Background) shl 4);
    if fConsoleTitle <> '' then
      lpTitle := PChar(fConsoleTitle);
    hStdInput := fStdIn;
    hStdOutput := fStdOut;
    hStdError := fStdErr;
    wShowWindow := cShowFlags[fVisible];
  end;

  // Set up process info structure
  ZeroProcessInfo;

  // Set creation flags
  CreateFlags := cPriorityFlags[fPriority];
  if fUseNewConsole then
    CreateFlags := CreateFlags or CREATE_NEW_CONSOLE;

  // Set current directory
  CurDir := nil;
  if CurrentDir <> '' then
    CurDir := PChar(CurrentDir);

  // Try to create the process
  Result := CreateProcess(
    nil,                  // no application name: we use command line instead
    PChar(SafeCmdLine),   // command line
    fProcessAttrs,        // security attributes for process
    fThreadAttrs,         // security attributes for thread
    True,                 // we inherit inheritable handles from calling process
    CreateFlags,          // creation flags
    fEnvironment,         // environment block for new process
    CurDir,               // current directory
    StartInfo,            // informs how new process' window should appear
    ProcessInfo           // receives info about new process
  );
end;

procedure TPJCustomConsoleApp.Terminate;
begin
  fRequestTerminate := True;
end;

procedure TPJCustomConsoleApp.UpdateSecurityAttrs(
  var OldValue: PSecurityAttributes; const NewValue: PSecurityAttributes);
begin
  if Assigned(NewValue) then
  begin
    if not Assigned(OldValue) then
      GetMem(OldValue, SizeOf(TSecurityAttributes));
    OldValue^ := NewValue^;
  end
  else
    FreeSecurityAttrs(OldValue);
end;

procedure TPJCustomConsoleApp.ZeroProcessInfo;
begin
  FillChar(fProcessInfo, SizeOf(fProcessInfo), 0);
end;

end.

