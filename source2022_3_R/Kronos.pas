unit Kronos;

{
****************************************************************************
           A brief overview over the TKronos component source code
****************************************************************************

The TKronos source code can be viewed in two parts

1. The basic datastructures and methods that read, write and compute
   raw calendaric data.
2. The designtime and runtime interface structures and methods

1. Basic data structures and methods
------------------------------------------------
The most elementary structures in TKronus is the Cal and Daycode tables.
These are simple arrays, indexed from 1..366, i.e. within the
range of a year. The Cal array stores dates on the form
monthnumber * 100 + monthday. The Daycode array has two dimentions,
the first stores codes for daynames (1 = Monday, 2 = Tuesday, etc),
the second dimention store codes for the predefined TKronos churchdays.

Every time the year changes or there is a need to retrieve data about
a particular year, TKronos fills the Cal and Daycode table by means of a
set of calculating procedures. These are

MakeCal
  which all start the filling process
SetFirstDay
  which computes the weekday that starts the year
MakeDates
  which fills the Cal table with dates
SetFixedCodes
  which fills the Daycode table with wekday name codes and churchcodes
  that are static dates
SetRelCodes
  which computes daycodes for easter and related days

In addition to the Cal and Daycode table, TKronos maintans a help table,
ChurchdayIndex, which simply is an index to the dates which contain
churchday codes.

To read and compute data from the Cal and Daycode tables TKronos uses
five basic record types and reading methods:
TKron
TDay
TWeek
TMonth
TYear

The corresponding reading methods are
MakeKron/ChangeKron
ReadDay
ReadWeek
ReadMonth
ReadYear

These methods make up the connection between the low level calendaric
structures and the design and runtime interfaces of the component.


2. The design- and runtime interface structures and methods
------------------------------------------------------------
All the property setting methods use the ReadXXX
procedures to provide data for the properties. Data delivered by the
ReadXX methods might furthemore be refined before finding their way
to the properties.

To control the flow of the OnChange events in connection with change
transactions there is a private table named FEventBuf, into which
event flags are bufferd until events actually are exceuted at end of a
transaction.

The daytype list
++++++++++++++++
The daytype list is a three level indexed list, indexed on daytype name,
daytype date and daytype id. It is implemented by means of three
separate stringslists, where the object fields point to the daytype
class. The lists are:

IdList
NameList
DateList

It is quite necessary to index the list, as a common task for the Kronos
component is to look up daytype objects by means of a name, a date or an
id key. If no index, the look up process would become slow when the list
gets big. It is possible to turn off indexing with the DisableIndexing
method. This is done before loading daytypes from a file in order to
speed up the loading prosess. As soon as loading is done, indexing is
turned on again.

The DateList has some specialites that you must be aware of:

Daytypes can be user calculated, that is they get no date attached to
them upon creation.
TKronos stores user calculated daytypes with
0010 in the date field.

Daytypes can be defined as relative to churchdays and are computed
on he "fly".
TKronos stores theese daytypes with
0100 in the date field.

Daytypes can be "yeartypes". Date information is irrelevant.
TKronos stores yeartypes with
0000 in the date field.

This ensures that specialties come first in the list. Regular dates
start on 0101, january 1.

******************************************************************************
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

const

     ChurchDayCount = 21;
     CommonDayCount = 4;

     {Daytype constants}
     chAdvent1 = 1;
     chAdvent2 = 2;
     chAdvent3 = 3;
     chAdvent4 = 4;
     chChristmasEve = 5;
     chChristmasDay = 6;
     chBoxingDay = 7;

     chNewYearEve = 8;
     chNewYearDay = 9;

     chShroveTuesday = 10;
     chAshWednesday = 11;

     chPalmSunday = 12;
     chMaundyThursday = 13;
     chGoodFriday = 14;
     chEasterEve = 15;
     chEasterSunday = 16;
     chEasterMonday = 17;

     chWhitEve = 18;
     chWhitSunday = 19;
     chWhitMonday = 20;
     chAscensionDay = 21;

     coUNDay = 22;
     coWomensDay = 23;
     coMayDay = 24;
     coLiteracyDay = 25;

     UserDayType = ChurchDayCount + CommonDayCount + 1;

type
    TNameStr = string[50];
    {Internal types}
    TCal = array[1..366] of integer;
    {Internal calendar with dates. Dates are formattted as
    month * 100 + monthdays number}
    TDaycodes = array[1..366,1..2] of word;
    {Daycodes for churchdays (2) and internal dow-numbers (1)
    dow-numbers are 1 for monday, 2 for tuesday, etc. The churchdays codes
    corresponds to the churchday constants}

    TFirstLastNumber = array[1..2] of word;
    {General type used to keep track of first and last daynumbers for
    months and weeks}
    TChurchdayIndex = array[1..ChurchdayCount] of word;
    {Keeps the indexes of the churchdays in the daycodes array}

{The following structures are used to hold extracts from the internal
calendar and code table}
    TDay = record
    {Day information}
      Daynum : Word;
      MonthDate : word;
      DOWNum : word;
      Month : word;
      Week : word;
      DayCode : Word;
    end;

    TWeek = record
    // Week information
      WeekNum : word;
      WhichDays : TFirstLastNumber;
    end;

    TMonth = record
    // Month information
      Month : word;
      Daycount : Word;
      WeekCount : Word; {Number of weeks comprised by the month}
      WhichWeeks : TFirstLastNumber;
      WhichDays : TFirstLastNumber;
    end;

    TYear = record
    // Year information
      WeekCount : word;
      DayCount : Word;
    end;

    TKron = record
    // Tracks which year that is loaded into the internal calendar
      ActiveYear : Word;
      IsInitialized : boolean;
    end;

  {TKronos types:}
  TDaytypeID = array[1..255] of word;

  TYearExt = record
     Year : word;
     NumDays : word;
     NumWeeks : word;
     LeapYear : boolean;
     YeartypeCount : word;
  end;

  TDateExt = record
     Year : word;
     DayOfWeekNumber : word;
     DayName : string;
     MonthDay : Word;
     DayNumber : word;
     DaytypeCount : word;
     DaytypeID : TDaytypeID;
     MonthNumber : word;
     WeekNumber : word;
     Holiday : boolean;
     ChurchDay : Boolean;
     Flagday : Boolean;
  end;

  TMonthImage = array[1..6, 0..7] of smallint;
  {Index 0 in second dimention contains weeknumbers, else daynumbers}

  TMonthExt = record
     Year : word;
     MonthNumber : word;
     MonthName : string;
     FirstDay, LastDay : word;
     NumDays : word;
     NumWeeks : word;
     FirstWeek, LastWeek : word;
     MonthImage : TMonthImage;
  end;

  TWeekExt = record
     Year : word;
     WeekNumber : word;
     FirstDay, LastDay : word;
  end;

  TForeignKey = record
    KeyName : string;
    KeyValue : Variant;
  end;

  TDaytypeDef = record // The record representation of TDaytype
     AName : TNameStr;
     ADate : word;
     ARelDayType : word;
     AnOffset : integer;
     AFirstShowUp : word;
     ALastShowUp : word;
     AShowUpFrequency : word;
     AChurchDay : boolean;
     AHoliday : boolean;
     AFlagday : boolean;
     AUserCalc : boolean;
     ATag : integer;
  end;

  TDaytype = class(TPersistent)
  //Class to hold the daytypes
  private
     FId : word;
  protected
     FName : TNameStr;
     FDate : word;
     FRelDayType : word;
     FOffset : integer;
     FFirstShowUp : word;
     FLastShowUp : word;
     FShowUpFrequency : word;
     FChurchDay : boolean;
     FHoliday : boolean;
     FFlagday : boolean;
     FUserCalc : boolean;
     FTag : integer;

  published
     property TheDate : word read FDate;
     property TheName : TNameStr read FName;
     property Id : word read FId;
     property FirstShowUp : word read FFirstShowUp;
     property LastShowUp : word read FLastShowUp;
     property ShowUpFrequency : word read FShowupFrequency;
     property RelDaytype : word read FRelDayType;
     property Offset : integer read FOffset;
     property ChurchDay : boolean read FChurchday;
     property Holiday : boolean read FHoliday;
     property Flagday : boolean read FFlagday;
     property UserCalc : boolean read FUserCalc;
     property Tag : integer read FTag;
  public
     constructor Create
     (DaytypeDef : TDaytypeDef);
     procedure Update(DaytypeDef : TDaytypeDef; StartUserId : word);
     procedure SetId(AnId : word);
  end;


  TWeekDay = (Sunday, Monday, Tuesday, Wednesday, Thursday, Friday,
  Saturday);
  TWeekHolidays = set of TWeekDay;
  {To adjust the Kronos component to countryspesific settings the user
  can choose between to strategies:

  1: In the Form's constructor either load a
     calendar profile from file (LoadFromFile) or call the methods :
   * AddDaytype to define country spesific daytypes
   * SpecifyStandardDay to name the std church and common daytypes and
     set their status
   * SetFirstWeekday to set the day that starts the week.
   * UpdateInfo to aussure that the current info is properly updated

  2: Derive a new componet based on Kronos and override the method
   SetCountrySpecifics. Here the user should call the above
   mentioned methods except UpdateInfo.}

  // Event classification type. Use to iterate over the event buffer
  TOcEVent = (ocYear, ocMonth, ocMonthnumber, ocWeek,
  ocWeeknumber, ocMonthDay, ocWeekday, ocDate, ocToday, ocCalcDaytype);

  // Event types
  TCalcDaytypeEvent = procedure(Sender : TObject; Daytype : TDaytype;
  ADateExt : TDateExt; IsCurrentDate : boolean;
  var Accept : boolean) of object;

  TLoadDaytypeEvent = procedure(Sender : TObject;
  const DaytypeDef : TDaytypeDef; const DescKeys: String;
  ClassId : Integer; var LoadIt : boolean) of object;

  TSaveDaytypeEvent = procedure(Sender : TObject;
  Daytype : TDaytype; var DescKeys : String;
  var ClassID : Integer; var SaveIt : boolean) of object;

  TKronos = class(TComponent)
  private
    { Private declarations }

    // Property fields
    FYear : word;
    FMonth : word;
    FMonthDay : word;
    FWeek : word;
    FDayNumber : word;
    FYearExt : TYearExt;
    FMonthExt : TMonthExt;
    FWeekExt : TWeekExt;
    FDateExt : TDateExt;
    FDayTypeCount : word;
    FWeekDay : TWeekDay;
    FWeekHolidays : TWeekHolidays;
    FFirstWeekDay : TWeekday;
    FMinYear, FMaxYear : word;
    FDefaultToPresentDay : boolean;
    FAllowUserCalc : boolean;
    FHidePredefineds : boolean;
    FFirstUserId : word;

    // Internal fields
    FEventsDisabled : boolean;
    {True if event triggering is disabled}
    FCalcDisabled : boolean;
    {True if user calc computing is disabled}
    FSavedYear : word;
    {Year saved with the SaveCD method}
    FSavedDayNumber : word;
    {Daynumber saved with the SaveCD method}
    FIntYear : word;
    {Year saved with the SaveIntCD private method}
    FIntDayNumber : word;
    {Daynumber saved with the SaveCD private method}
    FChanging : boolean;
    {True if a date transaction is active}
    FEndChange : boolean;
    FCalculating : boolean;
    {True if calls form a OnCaculateDaytype event handler is processing}
    FEventBuf : array[ocYear..ocCalcDaytype] of boolean;
    {Buffer for storing events during a date transaction}
    FTransYear : word;
    {The year that was the current year when a date transaction started}
    FTransDayNr : word;
    {The daynumber that was the current daynumber when a date
    transaction started}
    FTransError : boolean;
    {True if an error occured during a date transaction}

    // Internal calendar variables
    Kron : TKron;
    IntFirstWeekday : word; //First weekday of year
    DayCodes : TDaycodes; //Daycodes for churchdays
    ChurchdayIndex : TChurchdayIndex;
    Cal : TCal;

    // Events
    FOnChangeYear,
    FOnChangeMonth,
    FOnChangeMonthNumber,
    FOnChangeWeek,
    FOnChangeWeekNumber,
    FOnChangeMonthDay,
    FOnChangeWeekday,
    FOnChangeDate,
    FOnToday : TNotifyEvent;
    FOnCalcDaytype : TCalcDaytypeEvent;
    FOnLoadDayType : TLoadDaytypeEvent;
    FOnSaveDaytype : TSaveDaytypeEvent;

    // Property setting procedures
    procedure SetYear (Value : word);
    procedure SetMonth (Value : word);
    procedure SetMonthDay (Value : word);
    procedure SetDayNumber (Value : word);
    procedure SetWeek (Value : word);
    procedure SetWeekDay(Value : TWeekDay);
    procedure SetFirstWeekDay(Value : TWeekday);
    procedure SetWeekHolidays(Value : TWeekHolidays);
    procedure SetMinYear(Value : word);
    procedure SetMaxYear(Value : word);
    procedure SetHidePredefineds(Value : boolean);

    procedure SetYearExt;
    procedure SetMonthExt;
    procedure SetWeekExt;
    procedure SetDateExt(AYear, AMonth, AMonthDay, ADaynr : word;
    ACal : TCal; ADayC : TDaycodes);

    {Sets default attributes of standard churchdays and common days}
    procedure SetDefaults;
    //procedure SetCommonDaysDate;

    {Low level internal routines operating on the basic
    calendar structures}
    function SeekDate(MonthDate: Word; Leap : Boolean) : Word;
    procedure MakeKron(AYear : word);
    procedure SetFirstDay(AYear: Word; var F : Integer);
    procedure MakeDates(AYear : Word; var CalTab : TCal);
    procedure SetFixedCodes(AYear : Integer);
    procedure SetRelCodes(FullMoonDate:Integer);
    procedure MakeCal(AYear:Integer);

    //High level internal routines
    function GetDayType(AnIndex : word) : TDaytype;
    function GetMonthImage : TMonthImage;
    function FindDayType(DayTypeName : string) : word;
    function FindDayTypeId(DayTypeId : word) : word;
    procedure FindOffsetDay(var TheYear, TheDayNumber : word;
    OffsetValue : integer; WorkdaysOnly : Boolean);
    procedure FindOffsetWeek(var TheYear, TheDayNumber : word;
    OffsetValue : integer);
    procedure FindOffsetMonth(var TheYear, TheDayNumber : word;
    OffsetValue : integer);

    {Other internal routines}
    function ConvertWeekday(DayOfWeekNumber : word) : TWeekDay;
    procedure SaveIntCD;
    procedure RestoreIntCd;
    function GetDOW(DNr : word) : word;
    function ShowUp(F,L,Sf,Y : word) : boolean;

  protected
    { Protected declarations }

    {User daytype definitions. Three level index. The object fields
    references a TDaytype object}

    Datelist : TStringList;
    {Date sort. 4 digit string
    Fixed dates:
    0101 = jan. 1., 0102, jan 2., etc
    Dates relative to churchdays:
    0100
    User calculated dates:
    0010
    Yeartypes:
    0000}

    NameList : TStringList;
    {Name sort}

    IdList : TStringList;
    {Id sort. 6 digit string (000001 = 1, etc}

    NextId : word;
    {Next id to be assigned to a userdefined daytype}

    FCSpIndex : integer;
    {The index of the IdList that is the last predefined daytype}

    procedure DisableIndexing(Disable : boolean);
    {Turns off sorting (Disable = true for all lists).
    Used in connection with loading from file, to speed up daytype creation.
    Call with Disable = false to turn on indexing and resort the lists}

    procedure Loaded; override;
    procedure SetCountrySpecifics; virtual;
    procedure ChangeYear; dynamic;
    procedure ChangeMonth; dynamic;
    procedure ChangeMonthNumber; dynamic;
    procedure ChangeWeek; dynamic;
    procedure ChangeWeekNumber; dynamic;
    procedure ChangeMonthDay; dynamic;
    procedure ChangeWeekday; dynamic;
    procedure ChangeDate; dynamic;
    procedure Today; dynamic;
    procedure CalcDaytype(Daytype : TDaytype; ADateExt : TDateExt;
    IsCurrentDate : boolean; var Accepted : boolean); dynamic;
    procedure LoadDaytype(DaytypeDef : TDaytypeDef;
    const DescKeys : String; const ClassID : Integer;
    var LoadIt : boolean); dynamic;
    procedure SaveDaytype(Daytype : TDaytype;
    var DescKeys : String; var ClassID : Integer;
    var SaveIt : boolean); dynamic;

    {Functions operating directly on the internal calendar structures:}
    procedure ChangeKron(AYear : word);
    {Changes the internal calendar to AYear}
    function ReadYear : TYear;
    {Reads year information}
    function ReadDay(DNr : word) : TDay;
    {Reads day information}
    function ReadWeek(WNr, Dnr : word) : TWeek;
    {Reads week information}
    function ReadMonth(MNr : word) : TMonth;
    {Reads month information}
    function ReadDayNr(ADate : word) : word;
    {Reads daynumber. ADate = Month * 100 + Monthday}
    procedure GetWeekOfFirstDays(TheYear : TYear;
    var WeekNo, FirstStartday : word);
    procedure GetWeekOfLastDays(TheYear : TYear;
    var WeekNo, LastStartday : word);

    procedure DisableUserCalc(Disable : boolean);
    {Disables user calculation of daytypes, i.e. disables triggering
    of the OnCalcDaytype event}
    procedure ClearLists;
    {Clears the daytype lists, except the predefined daytypes}
    function GetDaytypeObject(AnId : word; AName : string) : TDaytype;
    {Retrievs a daytype from the daytype list}

  public
    { Public declarations }

    Daynames : array[1..7] of string;
    Monthnames : array[1..12] of string;

    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    //Configuration methods
    function AddDaytype(DayType: TDaytype) : Word;
    {Add one user defined spesific day to the daytype list}
    procedure ClearUserDaytypes;
    {Clears all user defined spesific days from the daytype list,
    except the ones prefefined}
    function DeleteUserDayType(AnId : word; AName : string) : boolean;
    {Deletes a user daytype}
    procedure UpdateDaytype(AnId : word; AName : string;
    DaytypeDef : TDaytypeDef);
    {Changes the definition of a user daytype}
    function GetDaytypeDef(AnId : word; AName : string) : TDaytypeDef;
    {Retrieves a user daytype definition}
    function GetNextDaytype(var NextIndex : word) : TDaytype;
    {Retrievs a daytype from the daytype list}
    function GetNextDaytypeName(AName : string; var Count : word) : TDaytype;
    {Retrievs a daytype from the daytype list, matching AName and Count}
    function GetNextDaytypeDate(ADate : word; var Count : word) : TDaytype;
    {Retrievs a daytype from the daytype list, matching ADate and Count}
    procedure SpecifyStandardDay(AnId : word; AName : string;
    IsHoliday, IsFlagday : boolean);
    {Specifies the standard predefined days with native names and status}
    procedure LoadFromFile(AFilename : string; LoadAll : boolean);
    {Loads a calendar definition from file}
    procedure SaveToFile(AFilename : string);
    {Saves a calendar definition to file}

    //Stores information about the current date
    property YearExt : TYearExt read FYearExt;
    property MonthExt : TMonthExt read FMonthExt;
    property WeekExt : TWeekExt read FWeekExt;
    property DateExt : TDateExt read FDateExt;
    property DayTypeCount : word read FDayTypeCount;
    property DayTypes[AnIndex : word] : TDaytype read GetDayType;
    property FirstUserId : Word read FFirstUserId;

    //Fetches information without changing the current day
    function FetchYearExt(AYear : word) : TYearExt;
    function FetchMonthExt(AYear, AMonth : word) : TMonthExt;
    function FetchWeekExt(AYear, AWeek : word ) : TWeekExt;
    function FetchDateExt(AYear, AMonth, AMonthDay : word) : TDateExt;
    function FetchDateExtDt(ADate : TDateTime) : TDateExt;
    function FetchDateExtDn(AYear, ADayNumber : word) : TDateExt;
    function FetchDaytype(ADateExt : TDateExt; AnIndex : word) : TDaytype;
    function FetchYeartype(AYearExt : TYearExt; AnIndex : word) : TDaytype;
    function IsLeapYear(AYear : word) : boolean;
    function GetNumWeeks(AYear : word) : word;
    function IsLastDayOfMonth(AYear, AMonth, AMonthDay : word) : boolean;
    function IsLastWeekOfYear(AYear, AWeek : word) : boolean;

    //Interval functions
    function MonthsInInterval(Year1, Month1, Year2, Month2: word) : integer;
    {Calculates the number of months between 1 and 2}
    function WeeksInInterval(Year1, Week1, Year2, Week2: word) : integer;
    {Calculates the number of weeks between 1 and 2}
    function DaysInInterval(Year1, Month1, MonthDay1,
    Year2, Month2, MonthDay2 : word; WorkdaysOnly : boolean) : integer;
    {Calculates the number of days between 1 and 2}
    function DaysInIntervalDn(Year1, Daynumber1, Year2, Daynumber2 : word;
    WorkdaysOnly : boolean) : integer;
    function DaysInIntervalDt(Date1, Date2 : TDateTime;
    WorkdaysOnly : boolean) : integer;

    //Search- and offset calculating procedures
    function DaynumberByTypeName(AYear : word; DayTypeName : string) : word;
    {Returns the daynumber in AYear that contains Daytypename}
    function DaynumberByTypeId(AYear : word; ADayTypeId : word) : word;
    {Returns then daynumber in AYear that matches a DaytypeId}
    procedure DateByDayOffset(var TheYear, TheDayNumber : word;
    OffsetValue : integer; WorkdaysOnly : Boolean);
    {Returns the year and daynumber by counting offsetvalue days from
    current date}
    procedure DateByWeekOffset(var TheYear, TheDayNumber : word;
    OffsetValue : integer);
    {Returns the year and daynumber by counting offsetvalue weeks from
    current date}
    procedure DateByMonthOffset(var TheYear, TheDayNumber : word;
    OffsetValue : integer);
    {Returns the year and daynumber by counting offsetvalue months from
    current date}

    //Retrievs information about the current date
    function IsToday(var AYear, ADayNumber : word) : boolean;
    function IsTomorrow(var AYear, ADayNumber : word) : boolean;
    function IsYesterday(var AYear, ADayNumber : word) : boolean;
    function IsThisWeek(var AYear, AWeekNumber : word) : boolean;
    function IsNextWeek(var AYear, AWeekNumber : word) : boolean;
    function IsLastWeek(var AYear, AWeekNumber : word) : boolean;
    function IsThisMonth(var AYear, AMonthNumber : word) : boolean;
    function IsNextMonth(var AYear, AMonthNumber : word) : boolean;
    function IsLastMonth(var AYear, AMonthNumber : word) : boolean;
    function IsThisYear(var AYear : word) : boolean;
    function IsNextYear(var AYear : word) : boolean;
    function IsLastYear(var AYear : word) : boolean;

    //Changes the current date by calculating or searching
    procedure GotoDate(AYear, AMonth, AMonthDay : word);
    procedure GotoDateDt(ADate : TDateTime);
    procedure GotoDateDn(AYear, ADayNumber : word);
    procedure GotoToday;
    procedure GotoTomorrow;
    procedure GotoYesterday;
    procedure GotoThisWeek;
    procedure GotoNextWeek;
    procedure GotoLastWeek;
    procedure GotoThisMonth;
    procedure GotoNextMonth;
    procedure GotoLastMonth;
    procedure GotoDayType(AYear : word; AnId : word; DayTypeName : string);
    {Moves to the daynumber in AYear that contains Daytypename/id}
    procedure GoToOffsetDay(OffsetValue : integer;
    WorkdaysOnly : boolean);
    {Moves to Year/Daynumber that results from the number of days in
    OffsetValue. Startingpoint is current date}
    procedure GoToOffsetWeek(OffsetValue : integer);
    {Moves to Year/Daynumber that results from the number of weeks in
    OffsetValue. Startingpoint is current date}
    procedure GoToOffsetMonth(OffsetValue : integer);
    {Moves to Year/Daynumber that results from the number of months in
    OffsetValue. Startingpoint is current date}

    //Converting functions
    function DOWtoWeekday(ADayOfWeekNumber : word) : TWeekDay;
    {Converts a day of week number to a TWeekday type}
    function DOWtoDayNameIndex(ADayOfWeekNumber:word) : word;
    {Converts a day of week number to an index that can be used to
    access Daynames array}
    function CDtoDateTime : TDateTime;
    {Converts the current date to Datetime-format}

    //Functions operating on MonthImage
    procedure GetMIDayCell(ADayNumber : word; var ARow, ACol : Longint);
    {Returns the row and column in the current MonthImage that contains
    ADaynumber}
    function GetMIWeekRow(AWeekNumber : word) : word;
    {Returns the row in the current MonthImage that contains
    AWeekNumber}
    procedure GetFirstMIDayCell(var ARow, ACol : Longint);
    {Returns the row and column in the current MonthImage that contains
    the first daynumber}
    procedure GetLastMIDayCell(var ARow, ACol : Longint);
    {Returns the row and column in the current MonthImage that contains
    the last daynumber}

    //Misc
    procedure DisableEvents(Disable : boolean);
    {Turns off event triggering}
    procedure SaveCD;
    {Saves the current date}
    procedure RestoreCD;
    {Restores the current date}
    procedure UpdateInfo;
    {Updates ext-properties with latest changes}
    procedure BeginChange;
    {Starts a date transaction}
    procedure EndChange;
    {Ends a date transaction}
    function ExistsDaytype(DaytypeName : string) : Word;
    {Checks for duplicate daytype names}
    procedure Rechange;
    {Retriggers all change eventhandlers}
    function GetDescKey(var Index : Integer; Keys : string;
    var KeyName, Value : string) : Boolean;

  published
    { Published declarations }
    property Year : word read FYear write SetYear;
    property Month : word read FMonth write SetMonth;
    property MonthDay : word read FMonthDay write SetMonthDay;
    property FirstWeekDay : TWeekDay read FFirstWeekday
       write SetFirstWeekday;
    property WeekDay : TWeekDay read FWeekDay write SetWeekDay;
    property Week : word read FWeek write SetWeek;
    property DayNumber : word read FDayNumber write SetDayNumber;
    property WeekHolidays : TWeekHolidays read FWeekHolidays
       write SetWeekHolidays;
    property DefaultToPresentDay : boolean read FDefaultToPresentDay
       write FDefaultToPresentDay;
    property MinYear : word read FMinYear write SetMinYear;
    property MaxYear : word read FMaxYear write SetMaxYear;
    property AllowUserCalc : boolean read FAllowUserCalc
       write FAllowUserCalc;
    property HidePredefineds : boolean read FHidePredefineds
       write SetHidePredefineds;

    property OnChangeYear : TNotifyEvent read FOnChangeYear
       write FOnChangeYear;
    property OnChangeMonth : TNotifyEvent read FOnChangeMonth
       write FOnChangeMonth;
    property OnChangeMonthNumber : TNotifyEvent read FOnChangeMonthNumber
       write FOnChangeMonthNumber;
    property OnChangeWeek : TNotifyEvent read FOnChangeWeek
       write FOnChangeWeek;
    property OnChangeWeekNumber : TNotifyEvent read FOnChangeWeekNumber
       write FOnChangeWeekNumber;
    property OnChangeMonthDay : TNotifyEvent read FOnChangeMonthDay
       write FOnChangeMonthDay;
    property OnChangeWeekDay : TNotifyEvent read FOnChangeWeekDay
       write FOnChangeWeekDay;
    property OnChangeDate : TNotifyEvent read FOnChangeDate
       write FOnChangeDate;
    property OnToday : TNotifyEvent read FOnToday
       write FOnToday;
    property OnCalcDaytype : TCalcDaytypeEvent read FOnCalcDaytype
       write FOnCalcDaytype;
    property OnLoadDaytype : TLoadDaytypeEvent read FOnLoadDaytype
       write FOnLoadDaytype;
    property OnSaveDaytype : TSaveDaytypeEvent read FOnSaveDaytype
       write FOnSaveDaytype;
  end;

  EKronosError = class(Exception);

procedure Register;

implementation

const
     // Error messages
     c_YearOutOfBounds = 'Year out of bounds';
     c_MonthOutOfBounds = 'Month out of bounds';
     c_WeekOutOfBounds = 'Week out of bounds';
     c_MonthdayOutOfBounds = 'Monthday out of bounds';
     c_DaynumberOutOfBounds = 'Daynumber out of bounds';
     c_DayOfWeekNumberOutOfBounds = 'DayOfWeekNumber out of bounds';
     c_ShowFreqTooBig = 'Showup frequency too big';
     c_MinYearOutofBounds = 'Min year out of bounds';
     c_MaxYearOutofBounds = 'Max year out of bounds';
     c_MinYearOutofCurrentYear = 'Cannot set. ' +
     'Value of MinYear conflicts with current year';
     c_MaxYearOutofCurrentYear = 'Cannot set. ' +
     'Value of MaxYear conflicts with current year';
     c_DaytypeIndexOutOfRange = 'Daytype index out of range';
     c_DuplicateName = 'Duplicate daytype name';
     c_TooManyDaytypes = 'Too many daytypes';
     c_CannotDeleteStableDaytype = 'Cannot delete stable daytype';


procedure Register;
begin
  RegisterComponents('Samples', [TKronos]);
end;

{*************************** Local procs *****************************}

procedure GetDate(var Aar, Month, Day, Wd : word);
var
   D : TDateTime;
begin
     D := Date;
     DecodeDate(D, Aar, Month, Day);
     Wd := DayOfWeek(D);
end;

function IsLeap(aar : Integer) : Boolean;
// Check for leapyear

begin
   Result := false;
   Result := (aar mod 4 = 0) and (aar mod 100 = 0) and (aar mod 400 = 0);
   if Result then exit;
   if (aar mod 4 = 0) and (aar mod 100 = 0) then exit;
   Result := (aar mod 4 = 0);
end; {IsLeap}


{************************** TDaytype methods ****************************}

constructor TDaytype.Create;
begin
     inherited Create;
     with DaytypeDef do
     begin
          FName := AName;
          FDate := ADate;
          FRelDaytype := ARelDayType;
          FOffset := AnOffset;
          FFirstShowUp := AFirstShowUp;
          FLastShowUp := ALastShowUp;
          FShowUpFrequency:= AShowUpFrequency;
          FChurchday := AChurchDay;
          FHoliday := AHoliday;
          FFlagDay := AFlagday;
          FUserCalc := AUserCalc;
          FTag := ATag;
     end;
end;

procedure TDayType.Update;
begin
     with DaytypeDef do
     begin
          FName := AName;
          if FId >= StartUserId then
          {These properties are not etidable for predefined daytypes:}
          begin
             FDate := ADate;
             FRelDayType := ARelDaytype;
             FOffset := AnOffset;
             FFirstShowUp := AFirstShowUp;
             FLastShowUp := ALastShowUp;
             FShowUpFrequency := AShowUpFrequency;
             FUserCalc := AUserCalc;
             FTag := ATag;
          end;
          FChurchDay := AChurchDay;
          FHoliday := AHoliday;
          FFlagday := AFlagday;
     end;
end;

procedure TDaytype.SetId;
begin
     FId := AnId;
end;

{*************************** TKronos methods **************************}

constructor TKronos.Create;
var
   Y, M, D, Wd : word;
begin
     inherited Create(AOwner);
     DateList := TStringList.Create;
     DateList.Sorted := true;
     DateList.Duplicates := dupAccept;
     NameList := TStringlist.Create;
     NameList.Sorted := true;
     NameList.Duplicates := dupAccept;
     IdList := TStringlist.Create;
     IdList.Sorted := true;
     IdList.Duplicates := dupError;
     NextId := 1;
     SetDefaults;
     SetCountrySpecifics;
     FCSpIndex := DateList.Count - 1;
     FFirstUserId := FCspIndex + 2;
     FDefaultToPresentDay := true;
     GetDate(Y, M, D, Wd);
     dec(Wd);
     if Wd = 0 then
        Wd := 7;
     MakeKron(Y);
     FirstWeekDay := Sunday;
     FYear := Y;
     FMonth := M;
     FMonthDay := D;
     FDayNumber := ReadDayNr(M * 100 + D);
     FWeekDay := ConvertWeekday(Wd);
     FWeekHolidays := [Saturday, Sunday];
     FMaxYear := 9999;
     FMinYear := 1;

     IntFirstWeekday := Ord(FFirstWeekday);
     if IntFirstWeekday = 0 then IntFirstWeekday := 7;

     SetYearExt;
     SetMonthExt;
     SetDateExt(0,0,0,0, Cal, DayCodes);
     FWeek := FDateExt.WeekNumber;
     SetWeekExt;
     FEventsDisabled := false;
end;

procedure TKronos.Loaded;
var
   Y, M, D, Wd : word;
begin
     inherited Loaded;

     GetDate(Y, M, D, Wd);
     if FDefaultToPresentDay then
     begin
          if Kron.ActiveYear <> Y then
             ChangeKron(Y);
          dec(Wd);
          if Wd = 0 then
             Wd := 7;
          FYear := Y;
          FMonth := M;
          FMonthDay := D;
          FDayNumber := ReadDayNr(M * 100 + D);
          FWeekDay := ConvertWeekday(Wd);
     end
     else
     begin
          if FYear <> Kron.ActiveYear then
             ChangeKron(FYear);
     end;

     SetYearExt;
     SetMonthExt;
     SetDateExt(0,0,0,0, Cal, DayCodes);
     FWeek := FDateExt.WeekNumber;
     SetWeekExt;
end;

destructor TKronos.Destroy;
var
   i : integer;
begin
     for i := 0 to DateList.Count - 1 do
         DateList.Objects[i].Free;
     DateList.Free;
     NameList.Free;
     IdList.Free;
     inherited Destroy;
end;

function TKronos.GetNumWeeks;
{Finds number of weeks in a year}
var
   T : TDateTime;
   Dow : integer;
begin
     T := EncodeDate(AYear,1,1);
     Dow := DayOfWeek(T);
     dec(Dow);
     if Dow = 0 then Dow := 7;

     {Map the dow-number accordning to first weekday}
     Dow := GetDow(Dow);

     if (Dow = 3) and IsLeap(AYear) then
        Result := 53
     else if (Dow = 4) then
        Result := 53
     else
        Result := 52;
end;

function TKronos.SeekDate;
{Seeks a date in the internal calendar. Binary search}
var
   First,Last,Current,TestMonthDate : word;
   Found, Stop : boolean;
begin
     if Leap then Last := 366 else Last := 365;
     First := 1;
     Current := Last div 2;
     TestMonthDate := Cal[Current];
     Stop := TestMonthDate = MonthDate;
     Found := Stop;
     while not stop do
     begin
          if MonthDate < TestMonthDate then Last := Current - 1
          else First := Current + 1;
          Current := (Last + First) div 2;
          TestMonthDate := Cal[Current];
          Found := TestMonthDate = MonthDate;
          Stop := Found or (First >= Last)
     end;
     if not Found then Result := 0
     else Result := Current;
end;

{** The following procedures loads the basic information structures*****}

procedure TKronos.GetWeekOfFirstDays;
{Computes the weeknumber of the day(s) that start a year}
var
   i : integer;
begin
     i := 0;
     {Find daynumber of first day(s) that starts the week}
     repeat
        inc(i);
        if DayCodes[i,1] = IntFirstWeekday then
           FirstStartday := i;
     until (DayCodes[i,1] = IntFirstWeekday);

     {Decide weeknumber of possible partial week at start of year}
     if FirstStartday < 5 then
       WeekNo := GetNumWeeks(Kron.ActiveYear - 1)
     else
       WeekNo := 1;
end;


procedure TKronos.GetWeekOfLastDays;
{Computes the weeknumber of the day(s) that ends a year}
var
   i : integer;
begin
     i := TheYear.Daycount + 1;
     {Find daynumber of last start day}
     repeat
        dec(I);
        if DayCodes[I,1] = IntFirstWeekday then
           LastStartday := I;
     until (DayCodes[I,1] = IntFirstWeekday);

     {Decide weeknumber of possible partial week at end of year}
     if (TheYear.Daycount - LastStartday + 1) > 3 then
        WeekNo := TheYear.WeekCount
     else
        WeekNo := 1;
end;

function TKronos.ReadYear : TYear;
// Load Year-info
var
   YearNumber : word;
   TheYear : TYear;
   I : integer;
   StartWeekday, EndWeekday : integer;
begin
   YearNumber := Kron.ActiveYear;
   with TheYear do
     begin
     if IsLeap(YearNumber) then
        Daycount := 366
     else
        Daycount := 365;
     WeekCount := GetNumWeeks(Kron.ActiveYear);
     Result := TheYear;
   end;
end;

function TKronos.ReadDay(DNr : word) : TDay;
// Load Day-info
var
   Day : TDay;
   I, StartWeek : integer;
   TheYear : TYear;
   StartWeekday, EndWeekday : word;
   WeekNumFirstDays : word;
   WeekNumLastDays : word;
begin

  with Day do begin
     Daynum := DNr;

     MonthDate := Cal[Daynum];
     Month := MonthDate div 100;
     DOWNum := DayCodes[Daynum,1];
     DayCode := DayCodes[Daynum,2];
     TheYear := ReadYear;

     {The following computes the weeknumber in which daynumber resides}
     GetWeekOfFirstDays(TheYear, WeekNumFirstDays, StartWeekDay);
     GetWeekOfLastDays(TheYear, WeekNumLastDays, EndWeekDay);

     if (DNr < StartWeekday) then
          Week := WeekNumFirstDays
     else if DNr >= EndWeekday then
          Week := WeekNumLastDays
     else
     begin
       if WeekNumFirstDays = 1 then
          StartWeek := 2
       else
          StartWeek := 1;

       i := StartWeekday;
       Week := 0;
       repeat
             inc(i, 7);
             if DNr < i then
             begin
                  Week := StartWeek;
                  break;
             end;
             inc(StartWeek);
       until Week = StartWeek;
     end;
  end;

  Result := Day;
end;

function TKronos.ReadWeek;
// Load Week-info
var
   StartWeekday, EndWeekDay : Word;
   WeekNumLastDays, WeekNumFirstdays : word;
   Week : TWeek;
   WeekNumber : integer;
   TheYear : TYear;

begin
   TheYear := ReadYear;
   WeekNumber := Wnr;
   GetWeekOfFirstDays(TheYear, WeekNumFirstDays, StartWeekDay);
   GetWeekOfLastDays(TheYear, WeekNumLastDays, EndWeekDay);

   {The following computes first and last daynumber of week. Weeks
   that are part of two years must be spotted an treated specially}
   with Week do
   begin
      if (WeekNumber = 1) and (StartWeekday = 1) and (DNr < 100) then
     {The year starts with first weekday}
     begin
          WhichDays[1] := 1;
          WhichDays[2] := 7;
     end
     {--------------------------------------------------------------------}
     else if (WeekNumber = 1)
     and (WeekNumFirstDays = 1)
     and (DNr < 100) then
     {Some of week number 1 lies i previous year}
     begin
          if IsLeap(Kron.ActiveYear - 1) then
             WhichDays[1] := 366 - (7 - StartWeekDay)
          else
             WhichDays[1] := 365 - (7 - StartWeekDay);

          WhichDays[2] := StartWeekday - 1;
     end
     {--------------------------------------------------------------------}
     else if (WeekNumber = 1)
     and (DNr > 100) then
     {Some of week number 1 lies i next year}
     begin
          WhichDays[1] := EndWeekday;
          if IsLeap(Kron.ActiveYear) then
             WhichDays[2] := 6 - (366 - EndWeekDay)
          else
             WhichDays[2] := 6 - (365 - EndWeekDay);
     end
     {--------------------------------------------------------------------}
     else if (WeekNumber = 1) then
     {The first days in the year represents the weeknumber of last year}
     begin
             Whichdays[1] := StartWeekDay;
             Whichdays[2] := StartWeekday + 6;
     end
     {--------------------------------------------------------------------}
     else if (Weeknumber > 50) and (Dnr < 100) then
     {Week is partial week from previous year}
     begin
          if IsLeap(Kron.ActiveYear - 1) then
             WhichDays[1] := 366 - (7 - StartWeekDay)
          else
             WhichDays[1] := 365 - (7 - StartWeekDay);

          WhichDays[2] := StartWeekday - 1;
     end
     {--------------------------------------------------------------------}
     else if (Weeknumber = TheYear.WeekCount)
     and (TheYear.WeekCount = WeeknumLastDays) then
     {Week is last of year and there is no number 1 week at end  of year.
     Som weekdays might belong to next year}
     begin
          WhichDays[1] := EndWeekday;
          if IsLeap(Kron.ActiveYear) then
             WhichDays[2] := 6 - (366 - EndWeekDay)
          else
             WhichDays[2] := 6 - (365 - EndWeekDay);

     end
     {--------------------------------------------------------------------}
     else if (Weeknumber = TheYear.WeekCount) then
     {Week is last of year and there is a week number 1 at end  of year.
     All weekdays belong to this year}
     begin
          Whichdays[1] := EndWeekDay - 7;
          Whichdays[2] := EndWeekDay - 1;
     end
     {--------------------------------------------------------------------}
     else
     begin
     {Week is somewhere in the middle of the year}
          if WeekNumFirstdays <> 1 then
             Whichdays[1] := 7 * (Weeknumber - 1) + StartWeekday
          else
             Whichdays[1] := 7 * (Weeknumber - 2) + StartWeekday;
          Whichdays[2] := Whichdays[1] + 6;
     end;
   end;
   Week.WeekNum := WNr;
   Result := Week;
end;

function TKronos.ReadMonth;
// Load MonthInfo
var
   I,Rest : Integer;
   WeekNum : Integer;
   FirstDay : Integer;
   Mnd : TMonth;
   Day : TDay;
   Test : integer;
begin
   with Mnd do
   begin
     if Mnr In[1, 3, 5, 7, 8, 10, 12] then Daycount := 31
     else if Mnr = 2 then
     begin
         if IsLeap(Kron.ActiveYear) then Daycount := 29
         else Daycount := 28;
     end
     else Daycount := 30;
     i := 0;
     repeat inc(i) until (Cal[i] div 100 = MNr);
{->  First Day of month}
     WhichDays[1] := i;
     WhichDays[2] := i + Daycount - 1;
     i := 0;
     repeat inc(i) until (DayCodes[i,1] = IntFirstWeekday);
{->  Daynumber of first weekday}

     Day := ReadDay(WhichDays[1]);
     WhichWeeks[1] := Day.Week;
     Day := ReadDay(WhichDays[2]);
     WhichWeeks[2] := Day.Week;
     if WhichWeeks[1] > WhichWeeks[2] then
     begin
       Test := GetNumWeeks(Kron.ActiveYear - 1) - WhichWeeks[1];
       WeekCount := WhichWeeks[2] + Test + 1;
     end
     else
       WeekCount := WhichWeeks[2] - WhichWeeks[1] + 1;
   end;
   Result := Mnd;
end;

function TKronos.ReadDayNr;
{Returns Daynumber tied to MonthDate}
begin
     Result := SeekDate(ADate,IsLeap(Kron.ActiveYear));
end;

procedure TKronos.MakeKron;
begin
     Kron.ActiveYear := AYear;
     MakeCal(AYear);
     Kron.IsInitialized := true;
end;

procedure TKronos.ChangeKron;
begin
     MakeKron(AYear);
end;

{********Procedures to create the internal calendar for a year *************}

procedure TKronos.SetFirstDay;
{Computes first weekday of yaer}

var
   m,d : word;
   T : TDateTime;
   DOW : word;

begin
    m := 1; d := 1;
    T := EncodeDate(AYear,m,d);
    DOW := DayOfWeek(T);
    dec(DOW);
    if DOW = 0 then DOW := 7;
    f := DOW;
end;

procedure TKronos.MakeDates;
{Fills the calendar table with dates}

var
i, j, l, MonthDays : Integer;

begin
      l := 0;
      for i := 1 to 12 do
      begin
         if i in[1, 3, 5, 7, 8, 10, 12] then MonthDays := 31
         else if i = 2 then
         begin
            if IsLeap(AYear) then MonthDays := 29
            else MonthDays := 28;
         end
         else MonthDays := 30;
         for j := 1 to MonthDays do
         begin
            inc(l);
            CalTab[l] := (i * 100) + j;
         end;
      end;
end; {MakeDates}


procedure TKronos.SetFixedCodes;
{Sets DayCodes: fixed predefined churchdays}

var
   Christm_1,Christm_2 : Integer;
   ChristmEve, Adv : Integer;
   FirstDay, MaxDays,Daycount : Integer;
   j,i : Integer;

begin
   SetFirstDay(AYear, FirstDay);
   if IsLeap(AYear) then
   begin
        ChristmEve := 359;
        Christm_1 := 360;
        Christm_2 := 361;

        MaxDays := 366;
    end
    else
    begin
        ChristmEve := 358;
        Christm_1 := 359;
        Christm_2 := 360;
        MaxDays := 365;
    end;

    Daycount := 0;
    repeat
         j := FirstDay;
         i := 1;
         repeat
              inc(Daycount);
              DayCodes[Daycount,1] := j;
              // DOW-number in a Monday-first based system

              if (Daycount = 1) then
              begin
                   DayCodes[Daycount,2] := chNewYearDay;
                   ChurchdayIndex[chNewYearDay] := 1;
              end
              else if (Daycount = ChristmEve) then
              begin
                   DayCodes[Daycount,2] := chChristmasEve;
                   ChurchdayIndex[chChristmasEve] := Daycount;
              end
              else if (Daycount = Christm_1) then
              begin
                   DayCodes[Daycount,2] := chChristmasday;
                   ChurchdayIndex[chChristmasDay] := Daycount;
              end
              else if (Daycount = Christm_2) then
              begin
                   ChurchdayIndex[chBoxingDay] := Daycount;
                   DayCodes[Daycount,2] := chBoxingDay;
              end
              else if (Daycount = MaxDays) then
              begin
                   DayCodes[Daycount,2] := chNewYearEve;
                   ChurchdayIndex[chNewYearEve] := Daycount;
              end
              else DayCodes[Daycount,2] := 0;
              inc(j);
              if j = 8 then j := 1;
              inc(i);
         until (i = 8) or (Daycount = MaxDays);
   until Daycount = MaxDays;

   {Computes churchdays related to Christmas}
   adv := ChristmEve - 21;
   adv := adv - (7- (7 - DayCodes[adv,1]));
   {Now first sunday advent}
   DayCodes[adv,2] := chadvent1;
   ChurchdayIndex[chadvent1] := adv;

   DayCodes[adv+7,2] := chadvent2;
   ChurchdayIndex[chadvent2] := adv+7;

   DayCodes[adv+14,2] := chadvent3;
   ChurchdayIndex[chadvent3] := adv+14;

   DayCodes[adv+21,2] := chadvent4;
   ChurchdayIndex[chadvent4] := adv+21;

end;

procedure TKronos.SetRelCodes;
{Computes Easter and related days. Input is the Easter full moon}
var
   i : Integer;
begin
     i := 0;
     repeat inc(i) until Cal[i] = Fullmoondate;
     if DayCodes[i,1] = 7 then inc(i,4)
     else
     begin
          repeat inc(i) until DayCodes[i,1] = 7;
          dec(i,3);
     end;
{->  Day is now Maundy Thursday}

     DayCodes[i,2] := chMaundyThursday;
     ChurchdayIndex[chMaundyThursday] := i;
     inc(i);
     DayCodes[i,2] := chGoodFriday;
     ChurchdayIndex[chGoodFriday] := i;
     inc(i);
     DayCodes[i,2] := chEasterEve;
     ChurchdayIndex[chEasterEve] := i;
     inc(i);
     DayCodes[i,2] := chEasterSunday;
     ChurchdayIndex[chEasterSunday] := i;
     DayCodes[i-7,2] := chPalmSunday;
     ChurchdayIndex[chPalmSunday] := i-7;
     DayCodes[i+1,2] := chEasterMonday;
     ChurchdayIndex[chEasterMonday] := i+1;
     DayCodes[i+48,2] := chWhitEve;
     ChurchdayIndex[chWhitEve] := i+48;
     DayCodes[i+49,2] := chWhitSunday;
     ChurchdayIndex[chWhitSunday] := i+49;
     DayCodes[i+50,2] := chWhitMonday;
     ChurchdayIndex[chWhitMonday] := i+50;
{->  Whit}

     DayCodes[i-46,2] := chAshWednesday;
     ChurchdayIndex[chAshWednesday] := i-46;
     DayCodes[i-47,2] := chShroveTuesday;
     ChurchdayIndex[chShroveTuesday] := i-47;
{->  Lent}

     DayCodes[i+39,2] := chAscensionDay;
     ChurchdayIndex[chAscensionDay] := i+39;
{->  Ascension day}

end;

procedure TKronos.MakeCal;
{Creates a full calendar with dates and daycodes}
var
   G, C, M : integer;
   Cent : integer;

begin
     MakeDates(AYear,Cal);
     SetFixedCodes(AYear);

     // Calculates Easter full moon
     Cent := AYear div 100;
     G := (AYear mod 19) + 1;
     C := -Cent + Trunc(Cent/4) + Trunc(8*(Cent+11)/25);
     M := 50-((11*G)+ C) mod 30;
     if M > 31 then
     begin
        M := 400 + (M-31);
        if M = 419 then M := 418;
        if (M = 418) and (G >=12) then M := 417;
     end
     else
        M := 300 + M;
     SetRelCodes(M);
end;

procedure TKronos.SetYearExt;
var
   A : TYear;
   i : integer;
   DT : TDaytype;
begin
     A := ReadYear;
     with FYearExt do
     begin
          Year := FYear;
          NumWeeks := A.WeekCount;
          NumDays := A.Daycount;
          LeapYear := IsLeap(FYear);
          YeartypeCount := 0;
          I := 0;
          if DateList.Count = 0 then exit;
          while (i <= (DateList.Count - 1))
          and (DateList[i] = '0000') do
          begin
               DT := TDaytype(DateList.Objects[i]);
               if (DT.Id >= Userdaytype)
               and (Year >= DT.FirstShowup)
               and (Year <= DT.LastShowup)
               and ((Year - DT.FirstShowUp) mod
               DT.ShowupFrequency = 0) then
               inc(YeartypeCount);
               inc(i);
          end;
     end;
end;

procedure TKronos.SetMonthExt;
var
   M : TMonth;
begin
     M := ReadMonth(FMonth);
     with FMonthExt do
     begin
          Year := FYear;
          MonthNumber := FMonth;
          MonthName := Monthnames[MonthNumber];
          NumDays := M.Daycount;
          NumWeeks := M.WeekCount;
          FirstDay := M.WhichDays[1];
          LastDay := M.WhichDays[2];
          FirstWeek := M.WhichWeeks[1];
          LastWeek := M.WhichWeeks[2];
          MonthImage := GetMonthImage;
     end;
end;

procedure TKronos.SetWeekExt;
var
   W : TWeek;
begin
     W := ReadWeek(FWeek, FDayNumber);
     with FWeekExt do
     begin
          Year := FYear;
          WeekNumber := FWeek;
          FirstDay := W.WhichDays[1];
          LastDay := W.WhichDays[2];
     end;
end;

function TKronos.ShowUp(F,L,Sf,Y : word) : boolean;
begin
        Result := false;
        if (F > 9999)
        or (L > 9999) then
           raise EKronosError.Create(c_YearOutOfBounds);

        if (Y < F)
        or (Y > L) then
          exit;

        if SF = 0 then exit;
        if SF > 9999 then
           raise EKronosError.Create(c_ShowFreqTooBig);

        if (Y - F) mod SF <> 0 then
          exit;
        Result := true;
end;


procedure TKronos.SetDateExt;
var
   D : TDay;
   DayType : word;
   I, Ind : integer;
   NameIndex : word;
   Wd : TWeekDay;
   Fs : word;
   Key : string;
   OldDateExt : TDateExt;
   OldCount : Word;

   procedure CountFixedDates(AKey : string; AnInd : integer);
   var
      DT : TDaytype;
   begin
        while (AnInd <= DateList.Count - 1)
        and (DateList[AnInd] = AKey) do
        begin
              DT := TDaytype(DateList.Objects[AnInd]);
              if FHidePredefineds and
              (DT.Id < FFirstUserId) then
              begin
                 inc(AnInd);
                 continue;
              end;
              if not ShowUp(DT.FirstShowUp,
              DT.FLastShowUp, DT.ShowUpFrequency, FYear) then
              begin
                 inc(AnInd);
                 continue;
              end;
              if FDaytypeCount = 255 then
                raise EKronosError.Create(c_TooManyDaytypes);

              inc(FDayTypeCount);
              with FDateExt do
              begin
                   DaytypeId[FDayTypeCount] := DT.ID;
                   if DT.Holiday then Holiday := true;
                   if DT.Flagday then Flagday := true;
                   if DT.ChurchDay then ChurchDay := true;
              end;
              inc(AnInd);
        end;
   end;

   procedure CountReldays(AnInd : integer);
   //Relative to churchday
   var
      DT : TDaytype;
      TestDayNr : word;
   begin
        while (AnInd <= DateList.Count - 1)
        and (DateList[AnInd] = '0100') do
        begin
             DT := TDaytype(DateList.Objects[AnInd]);
             if FHidePredefineds and
             (DT.Id < FFirstUserId) then
             begin
                 inc(AnInd);
                 continue;
             end;
             if not ShowUp(DT.FirstShowUp,
             DT.LastShowUp, DT.ShowUpFrequency, FYear) then
             begin
                  inc(AnInd);
                  continue;
             end;
             if not (DT.ReldayType in [1..ChurchdayCount]) then
             begin
                inc(AnInd);
                continue;
             end;

             TestDayNr := ChurchdayIndex[DT.RelDayType] +
             DT.Offset;
             if TestDayNr = FDateExt.DayNumber then
             with FDateExt do
             begin
                  inc(FDayTypeCount);
                  DaytypeId[FDayTypeCount] := DT.Id;
                  if DT.Holiday then Holiday := true;
                  if DT.Flagday then Flagday := true;
                  if DT.ChurchDay then ChurchDay := true;
             end;
             inc(AnInd);
        end;
   end;

   procedure CountCalcdays(AnInd : integer);
   //User calculated date. Trigger the OnCalcDaytype event
   var
      DT : TDaytype;
      Accepted : boolean;
      DExt : TDateExt;
      Y : Word;
   begin
        Y := FYear;
        FDateExt.DaytypeCount := FDaytypeCount;
        if AYear <> 0 then
        {Restore to idle before calling event handler. AYear is <> 0 when
        SetDateExt is called from FetchDateExt}
        begin
             FYear := AYear;
             FMonth := AMonth;
             FMonthDay := AMonthDay;
             FDayNumber := ADayNr;
             if AYear <> Kron.ActiveYear then
             begin
                  Cal := ACal;
                  Daycodes := ADayC;
                  Kron.ActiveYear := AYear;
             end;
        end;

        while (AnInd <= DateList.Count - 1)
        and (DateList[AnInd] = '0010') do
        begin
             DT := TDaytype(DateList.Objects[AnInd]);
             if not ShowUp(DT.FirstShowUp,
             DT.LastShowUp, DT.ShowUpFrequency, Y) then
             begin
                  inc(AnInd);
                  continue;
             end;

             {Save state of FDateext}
             DExt := FDateExt;

             if AYear <> 0 then
             {Release idle state to user}
             begin
                FDateExt := OldDateExt;
                FDayTypeCount := OldCount;
             end;

             CalcDaytype(DT, DExt, (AYear = 0), Accepted);

             FDateExt := DExt;

             if Accepted then
             with FDateExt do
             begin
                  inc(DayTypeCount);
                  DaytypeId[DayTypeCount] := DT.Id;
                  if DT.Holiday then Holiday := true;
                  if DT.Flagday then Flagday := true;
                  if DT.ChurchDay then ChurchDay := true;
             end;
             inc(AnInd);
        end;
        FDaytypeCount := FDateExt.DaytypeCount;
   end;

begin
     OldDateExt := FDateExt;
     OldCount := FDaytypeCount;
     D := ReadDay(FDayNumber);
     with FDateExt do
     begin
          Year := FYear;
          Wd := ConvertWeekday(D.DOWNum);
          Holiday := (Wd in FWeekHolidays);
          ChurchDay := false;
          Flagday := false;

          DayNumber := D.Daynum;

          DayOfWeekNumber := GetDOW(D.DOWNum);
          NameIndex := DOWtoDayNameIndex(DayOfWeekNumber);

          DayName := Daynames[NameIndex];
          MonthDay := FMonthDay;

          MonthNumber := D.Month;
          WeekNumber := D.Week;

          FDayTypeCount := 0;
          FDateExt.DaytypeCount := 0;

          DayType := D.DayCode;

          if (DayType in [1..ChurchDayCount])
          and not FHidePredefineds then
          with IdList.Objects[Daytype-1] as
          TDaytype do
          begin
               inc(FDayTypeCount);
               DaytypeId[FDayTypeCount] := DayType;
               if Holiday then FDateExt.Holiday := true;
               if Flagday then FDateExt.Flagday := true;
          end;

          with DateList do
          //Check userdefined daytypes
          begin
               Key := IntToStr(FMonth * 100 + FMonthDay);
               if Length(Key) = 3 then Key := '0' + Key;
               if Find(Key, Ind) then
               begin
                    CountFixedDates(Key, Ind)
               end;
               Key := '0100';
               if Find(Key, Ind) then
                   CountReldays(Ind);

               if FAllowUserCalc
               and not FCalcDisabled then
               begin
                    Key := '0010';
                    if Find(Key, Ind) then
                       CountCalcdays(Ind);
               end;
          end;

          FDateExt.DaytypeCount := FDaytypeCount;
     end;
end;

procedure TKronos.SetYear;
var
   Daynum : integer;
   Day : TDay;
   Wd : TWeekDay;
   TrWeekNum, TrMonthDay, TrWeekday : boolean;
   A, D : word;
begin
     if Value = FYear then exit;
     if Value > FMaxYear then
     begin
        if csDesigning in ComponentState then
           Value := FMaxYear
        else
        begin
           FTransError := FChanging;
           raise EKronosError.Create(c_YearOutOfBounds);
        end
     end;
     if Value < FMinYear then
     begin
        if csDesigning in ComponentState then
           Value := FMinYear
        else
        begin
           FTransError := FChanging;
           raise EKronosError.Create(c_YearOutOfBounds);
        end;
     end;

     FYear := Value;

     TrWeekNum := false;
     TrMonthDay := false;
     TrWeekDay := false;

     if (FMonthDay = 29) and (FMonth = 2) and not IsLeap(FYear) then
     begin
          FMonthDay := 28;
          TrMonthDay := true;
     end;
     ChangeKron(FYear);
     Daynum := ReadDayNr(FMonth * 100 + FMonthDay);
     if Daynum <> FDayNumber then
     begin
          FDayNumber := Daynum;
     end;
     Day := ReadDay(Daynum);
     if Day.Week <> FWeek then
     begin
          FWeek := Day.Week;
          TrWeekNum := true;
     end;
     Wd := ConvertWeekday(Day.DOWNum);
     if Wd <> FWeekday then
     begin
          FWeekDay := Wd;
          TrWeekDay := true;
     end;

     SetYearExt;
     SetMonthExt;
     SetWeekExt;
     SetDateExt(0,0,0,0, Cal, DayCodes);

     ChangeYear;
     ChangeMonth;
     ChangeWeek;
     if TrWeekNum then
        ChangeWeekNumber;
     ChangeDate;
     if TrMonthDay then
        ChangeMonthDay;
     if TrWeekDay then
        ChangeWeekday;
     if IsToday(A, D) then
        Today;
end;

procedure TKronos.SetMinYear;
begin
     if Value < 1 then Value := 1;
     if Value = FMinYear then exit;
     if Value > FMaxYear then
     begin
        if csDesigning in ComponentState then
           Value := FMinYear
        else
        begin
           FTransError := FChanging;
           raise EKronosError.Create(c_MinYearOutOfBounds);
        end;
     end;
     if Value > FYear then
     begin
          if csDesigning in ComponentState then
             Year := Value
          else
          begin
             FTransError := FChanging;
             raise EKronosError.Create(c_MinYearOutOfCurrentYear);
          end;
     end;
     FMinYear := Value;
end;

procedure TKronos.SetMaxYear;
begin
     if Value = FMaxYear then exit;
     if Value > 9999 then Value := 9999;
     if Value < FMinYear then
     begin
        if csDesigning in ComponentState then
           Value := FMaxYear
        else
        begin
           FTransError := FChanging;
           raise EKronosError.Create(c_MaxYearOutOfBounds);
        end;
     end;
     if Value < FYear then
     begin
          if csDesigning in ComponentState then
             Year := Value
          else
          begin
             FTransError := FChanging;
             raise EKronosError.Create(c_MaxYearOutOfCurrentYear);
          end;
     end;
     FMaxYear := Value;
end;

procedure TKronos.SetHidePredefineds;
begin
     FHidePredefineds := Value;
     UpdateInfo;
end;

procedure TKronos.SetMonth;
var
   M : TMonth;
   D : TDay;
   Wd : TWeekDay;
   TrWeek, TrWeekday, TrMonthDay : boolean;
   A, DNr : word;
begin
     if Value = FMonth then exit;
     if not (Value in [1..12]) then
     begin
          if csDesigning in ComponentState then
          begin
               if Value < 1 then
                  Value := 1
               else
                  Value := 12;
          end
          else
          begin
              FTransError := FChanging;
              raise EKronosError.Create(c_MonthOutOfBounds);
          end;
     end;

     FMonth := Value;
     M := ReadMonth(FMonth);

     TrWeek := false;
     TrWeekday := false;
     TrMonthDay := false;

     with M do
     begin
          if FMonthDay > Daycount then
          begin
             FMonthDay := Daycount;
             TrMonthDay := true;
          end;
          FDayNumber := ReadDayNr(FMonth * 100 + FMonthDay);
          D := ReadDay(FDayNumber);
          if FWeek <> D.Week then
          begin
               FWeek := D.Week;
               TrWeek := true;
          end;
          Wd := ConvertWeekDay(D.DOWNum);
          if Wd <> FWeekday then
          begin
               TrWeekDay := true;
               FWeekday := Wd;
          end;
     end;
     SetMonthExt;
     if TrWeek then
        SetWeekExt;
     SetDateExt(0,0,0,0, Cal, DayCodes);

     ChangeMonth;
     ChangeMonthNumber;
     if TrWeek then
     begin
        ChangeWeek;
        ChangeWeekNumber;
     end;
     ChangeDate;
     if TrMonthDay then
        ChangeMonthDay;
     if TrWeekday then
        ChangeWeekDay;
     if IsToday(A, DNr) then
        ToDay;

end;

procedure TKronos.SetMonthDay;
var
   D : TDay;
   Daynum : word;
   TrWeek, TrWeekDay : boolean;
   Wd : TWeekDay;
   A, Dnr : word;
begin
     if Value = FMonthDay then exit;
     if (Value > MonthExt.NumDays) or (Value < 1) then
     begin
          if csDesigning in ComponentState then
          begin
               if Value < 1 then
                  Value := 1
               else
                  Value := MonthExt.Numdays;
          end
          else
          begin
              FTransError := FChanging;
              raise EKronosError.Create(c_MonthdayOutOfBounds);
          end;
     end;

     FMonthDay := Value;

     Daynum := ReadDayNr(100 * FMonth + FMonthDay);
     D := ReadDay(Daynum);

     TrWeek := false;
     TrWeekday := false;

     with D do
     begin
          if FWeek <> Week then
          begin
             FWeek := Week;
             TrWeek := true;
          end;
          Wd := ConvertWeekday(DOWNum);
          if Wd <> FWeekday then
          begin
               FWeekday := Wd;
               TrWeekDay := true;
          end;
          FDayNumber := Daynum;
     end;
     if TrWeek then
        SetWeekExt;
     SetDateExt(0,0,0,0, Cal, DayCodes);

     if TrWeek then
     begin
        ChangeWeek;
        ChangeWeekNumber;
     end;
     ChangeDate;
     ChangeMonthDay;
     if TrWeekDay then
        ChangeWeekday;
     if IsToday(A, DNr) then
        ToDay;
end;

procedure TKronos.SetDayNumber;
var
   D : TDay;
   TrMonth, TrWeek, TrWeekday, TrMonthDay : boolean;
   Wd : TWeekDay;
   A, Dnr : word;
begin
     if Value = FDayNumber then exit;

     if (Value > FYearExt.NumDays) or (Value < 1) then
     begin
          if csDesigning in ComponentState then
          begin
               if Value < 1 then
                   Value := 1
               else
                   Value := FYearExt.NumDays;
          end
          else
          begin
              FTransError := FChanging;
              raise EKronosError.Create(c_DaynumberOutOfBounds +
              ' ' + IntTostr(Value));
          end;
     end;

     FDayNumber := Value;
     D := ReadDay(FDayNumber);

     TrMonth := false;
     TrWeek := false;
     TrWeekDay := false;
     TrMonthDay := false;

     with D do
     begin
          if FMonth <> Month then
          begin
               FMonth := Month;
               TrMonth := true;
          end;
          if FWeek <> Week then
          begin
               FWeek := Week;
               TrWeek := true;
          end;
          Wd := ConvertWeekday(DOWNum);
          if FWeekday <> Wd then
          begin
               FWeekday := Wd;
               TrWeekDay := true;
          end;
          if FMonthday <> (MonthDate mod 100) then
          begin
               FMonthDay := MonthDate mod 100;
               TrMonthDay := true;
          end;
     end;
     if TrMonth then
        SetMonthExt;
     if TrWeek then
        SetWeekExt;
     SetDateExt(0,0,0,0, Cal, DayCodes);

     if TrMonth then
     begin
        ChangeMonth;
        ChangeMonthNumber;
     end;
     if TrWeek then
     begin
        ChangeWeek;
        ChangeWeekNumber;
     end;
     ChangeDate;
     if TrMonthday then
         ChangeMonthDay;
     if TrWeekday then
        ChangeWeekday;
     if IsToday(A, Dnr) then
        Today;
end;

procedure TKronos.SetWeekDay;
var
   D : TDay;
   TrMonth, TrWeek, TrYear : boolean;
   Diff : shortint;
   NewWd, OldWd : word;
   Daynum : integer;
   AntDager : integer;
   Ud1, Ud2 : word;
   A, Dnr : word;
begin
     if Value = FWeekday then exit;
     OldWd := ord(FWeekday);
     NewWd := ord(Value);
     if OldWd = 0 then OldWd := 7;
     if NewWd = 0 then NewWd := 7;
     Ud1 := GetDow(OldWd);
     Ud2 := GetDow(NewWd);

     //Sunday = 1, Monday = 2, etc

     Diff := Ud2 - Ud1;

     TrMonth := false;
     TrWeek := false;
     TrYear := false;

     if IsLeap(FYear) then
         AntDager := 366
     else
         AntDager := 365;

     FWeekday := Value;

     if csLoading in Componentstate then
        exit;

     Daynum := FDayNumber + Diff;
     if Daynum < 1 then
     begin
          if FYear - 1 < FMinYear then
          begin
             FTransError := FChanging;
             raise EKronosError.Create(c_YearOutOfBounds);
          end;

          if IsLeap(FYear - 1) then
             Daynum := 366 + Daynum
          else
             Daynum := 365 + Daynum;
          FYear := FYear - 1;
          FMonth := 12;
          FDayNumber := Daynum;
          ChangeKron(FYear);
          D := ReadDay(FDayNumber);
          FMonthDay := D.MonthDate mod 100;
          FWeek := D.Week;
          TrYear := true;
          TrWeek := true;
          TrMonth := true;
     end
     else if Daynum > AntDager then
     begin
          if FYear + 1 > FMaxYear then
          begin
             FTransError := FChanging;
             raise EKronosError.Create(c_YearOutOfBounds);
          end;

          Daynum := Daynum - AntDager;
          FYear := FYear + 1;
          FMonth := 1;
          FDayNumber := Daynum;
          ChangeKron(FYear);
          D := ReadDay(FDayNumber);
          FWeek := D.Week;
          FMonthDay := D.MonthDate mod 100;
          TrYear := true;
          TrWeek := true;
          TrMonth := true;
     end
     else
     begin
          FDayNumber := Daynum;
          D := ReadDay(FDayNumber);
          if D.Week <> FWeek then
          begin
               FWeek := D.Week;
               TrWeek := true;
          end;
          if D.Month <> FMonth then
          begin
               FMonth := D.Month;
               TrMonth := true;
          end;
          FMonthDay := D.MonthDate mod 100;
     end;

     if TrYear then
        SetYearExt;
     if TrMonth then
        SetMonthExt;
     if TrWeek then
        SetWeekExt;
     SetDateExt(0,0,0,0, Cal, DayCodes);

     if TrYear then
        ChangeYear;
     if TrMonth then
     begin
        ChangeMonth;
        ChangeMonthNumber;
     end;
     if TrWeek then
     begin
        ChangeWeek;
        ChangeWeekNumber;
     end;
     ChangeDate;
     ChangeMonthDay;
     ChangeWeekday;
     if IsToday(A, Dnr) then
        Today;
end;

procedure TKronos.SetWeek;
var
   W : TWeek;
   D : TDay;
   TrMonth, TrYear : boolean;
   Wd : word;
   TheYear : TYear;
   LastWeek : word;
   A,Dnr : word;
   StartWeekday, EndWeekday : word;
   WeekNum1, WeekNum2 : word;
   DayCnt : word;
   Previous, Next : boolean;
begin
     if Value = FWeek then exit;
     if (Value > FYearExt.NumWeeks) or (Value < 1) then
     begin
          if csDesigning in ComponentState then
          begin
               if Value < 1 then
                  Value := 1
               else
                  Value := FYearExt.NumWeeks;
          end
          else
          begin
              FTransError := FChanging;
              raise EKronosError.Create(c_WeekOutOfBounds);
          end;
     end;

     FWeek := Value;

     if csLoading in Componentstate then
     begin
        SetWeekExt;
        exit;
     end;

     LastWeek := FYearExt.NumWeeks;
     W := ReadWeek(FWeek, FDaynumber);
     TheYear := ReadYear;

     TrMonth := false;
     TrYear := false;
     Previous := false;
     Next := false;

     GetWeekOfFirstDays(TheYear,WeekNum1, StartWeekday);
     GetWeekOfLastDays(TheYear,WeekNum2, EndWeekday);

     Wd := FDateExt.DayOfWeekNumber;
     with W do
     begin
          if Fweek = 1 then
          begin
            {Check to see if current weekday forces a change to
            previous year}
            if IsLeap(FDateExt.Year - 1) then
                DayCnt := 366
            else
                DayCnt := 365;
            if Whichdays[1] >= 360 then
            begin
                 {Some of week 1 lies in last year}
                 Dnr := Whichdays[1] + Wd - 1;
                 if Dnr <= DayCnt then
                    Previous := true;
            end;
          end
          else if FWeek = LastWeek then
          begin
            {Check to see if current weekday forces a change to
            next year}
            if Whichdays[2] <= 7 then
            begin
                {Some of last week lies in next year}
                Dnr := Whichdays[1] + Wd - 1;
                if Dnr > FYearExt.NumDays then
                begin
                    Next := true;
                    Dnr := Dnr - FYearExt.Numdays;
                end;
            end;
          end;

          if Next then
          begin
               if FYear + 1 > FMaxYear then
               begin
                 FTransError := FChanging;
                 raise EKronosError.Create(c_YearOutOfBounds);
               end;
               FYear := FYear + 1;
               ChangeKron(FYear);
               FWeek := Weeknum2;
               FMonth := 1;
               TrMonth := true;
               TrYear := true;
               FDayNumber := Dnr;
          end
          else if Previous then
          {Weekday of current date belongs to last Week of previous
          year}
          begin
               if FYear - 1 < FMinYear then
               begin
                 FTransError := FChanging;
                 raise EKronosError.Create(c_YearOutOfBounds);
               end;
               FYear := FYear - 1;
               ChangeKron(FYear);
               TheYear := ReadYear;
               FWeek := WeekNum1;
               FMonth := 12;
               TrMonth := true;
               TrYear := true;
               FDayNumber := Dnr;
          end
          else
          begin
              FDayNumber := WhichDays[1] + Wd - 1;
              if FDayNumber > FYearExt.Numdays then
                 FDayNumber := FDayNumber - FYearExt.Numdays;
          end;

          D := ReadDay(FDayNumber);
          if FMonth <> D.Month then
          begin
               FMonth := D.Month;
               TrMonth := true;
          end;
          FMonthDay := D.MonthDate mod 100;
     end;

     if TrYear then
        SetYearExt;
     if TrMonth then
        SetMonthExt;
     SetWeekExt;
     SetDateExt(0,0,0,0, Cal, DayCodes);

     if TrYear then
        ChangeYear;
     if TrMonth then
     begin
        ChangeMonth;
        ChangeMonthNumber;
     end;
     ChangeWeek;
     ChangeWeekNumber;
     ChangeDate;
     ChangeMonthDay;
     if IsToday(A, Dnr) then
        Today;
end;

procedure TKronos.ChangeYear;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocYear] := true;
          exit;
     end;
     if Assigned(FOnChangeYear) then FOnChangeYear(Self);
end;

procedure TKronos.ChangeMonth;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocMonth] := true;
          exit;
     end;
     if Assigned(FOnChangeMonth) then FOnChangeMonth(Self);
end;

procedure TKronos.ChangeMonthNumber;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocMonthNumber] := true;
          exit;
     end;
     if Assigned(FOnChangeMonthNumber) then FOnChangeMonthNumber(Self);
end;

procedure TKronos.ChangeWeek;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocWeek] := true;
          exit;
     end;
     if Assigned(FOnChangeWeek) then FOnChangeWeek(Self);
end;

procedure TKronos.ChangeWeekNumber;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocWeeknumber] := true;
          exit;
     end;
     if Assigned(FOnChangeWeekNumber) then FOnChangeWeekNumber(Self);
end;

procedure TKronos.ChangeMonthday;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocMonthday] := true;
          exit;
     end;
     if Assigned(FOnChangeMonthDay) then FOnChangeMonthDay(Self);
end;

procedure TKronos.ChangeWeekDay;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocWeekDay] := true;
          exit;
     end;
     if Assigned(FOnChangeWeekDay) then FOnChangeWeekDay(Self);
end;


procedure TKronos.ChangeDate;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocDate] := true;
          exit;
     end;
     if Assigned(FOnChangeDate) then FOnChangeDate(Self);
end;

procedure TKronos.Today;
begin
     if FEventsDisabled then exit;
     if FChanging then
     begin
          FEventBuf[ocToday] := true;
          exit;
     end;
     if Assigned(FOnToday) then FOnToday(Self);
end;

procedure TKronos.CalcDaytype;
begin
     Accepted := false;
     if FCalcDisabled or not FAllowUserCalc then exit;
     if FChanging then
     begin
          FEventBuf[ocCalcDaytype] := true;
          exit;
     end;
     if Assigned(FOnCalcDaytype) then
     begin
          try
             FAllowUserCalc := false;
             FCalculating := True;
             {Turn off user calc. Necessary to prevent user from
             eternalnally triggering the OnCalDaytype event}
             FOnCalcDaytype(Self, Daytype, ADateExt,
             IsCurrentDate, Accepted);
          finally
             FAllowUserCalc := true;
             FCalculating := false;
          end;
     end;
end;

procedure TKronos.LoadDaytype;
begin
     LoadIt := true;
     if Assigned(FOnLoadDaytype) then
        FOnLoadDaytype(Self,DaytypeDef,DescKeys, ClassID, LoadIt);
end;

procedure TKronos.SaveDaytype;
begin
     SaveIt := true;
     if Assigned(FOnSaveDaytype) then
        FOnSaveDaytype(Self,Daytype,DescKeys, ClassID, SaveIt);
end;


function TKronos.AddDaytype;
var
   Key : string;
   Ind : integer;
   i : integer;
begin
    Result := NextId;
    Ind := NameList.Add(AnsiUppercase(Daytype.TheName));
    Daytype.SetId(NextId);

    NameList.Objects[Ind] := Daytype;
    if Daytype.UserCalc then
         Key := '0010'
    else if Daytype.TheDate <> 0 then
    begin
        Key := IntToStr(Daytype.TheDate);
        if Length(Key) = 3 then
           Key := '0' + Key;
    end
    else if (Daytype.TheDate = 0) and (Daytype.RelDaytype = 0) then
        Key := '0000'
    else
        Key := '0100';

    Ind := DateList.Add(Key);
    DateList.Objects[Ind] := Daytype;

    Key := IntToStr(NextId);
    for i := 1 to 6 - Length(Key) do Key := '0' + Key;
    Ind := IdList.Add(Key);
    IdList.Objects[Ind] := Daytype;
    Inc(NextId);
end;

procedure TKronos.ClearUserDaytypes;
begin
     ClearLists;
     UpdateInfo;
end;

function TKronos.DeleteUserdaytype;
var
   IdInd : integer;
   Found : boolean;
   DT : TDaytype;
   Id, ADate, Rel : Integer;
   Key : string;
   I, Ind : integer;
   IsCalc : boolean;

begin
     Result := true;
     DT := GetDaytypeObject(AnId, AName);
     if DT = nil then
     begin
          Result := false;
          exit;
     end;
     AName := DT.TheName;
     AnId := DT.Id;

     Key := IntToStr(DT.ID);
     for I := 1 to 6 - Length(Key) do Key := '0' + Key;
     IdList.Find(Key,IdInd);

     if IdInd <= FCspIndex then
     {Predfined daytype. Can't delete}
        raise EKronosError.Create(c_CannotDeleteStableDaytype + ' ' +
        DT.TheName);

     Id := DT.ID;
     ADate := DT.TheDate;
     Rel := DT.RelDaytype;
     IsCalc := DT.UserCalc;

     if not NameList.Find(AnsiUppercase(Trim(AName)), Ind) then
       raise EKronosError.Create('Internal error');
     NameList.Delete(Ind);

     Key := IntToStr(Id);
     for i := 1 to 6 - Length(Key) do Key := '0' + Key;
     if not IdList.Find(Key, Ind) then
        raise EKronosError.Create('Internal error');
     IdList.Delete(Ind);

     if IsCalc then
         Key := '0010'
     else if ADate <> 0 then
     begin
          Key := IntToStr(ADate);
          if Length(Key) = 3 then
             Key := '0' + Key;
     end
     else if (ADate = 0) and (Rel = 0) then
          Key := '0000'
     else
          Key := '0100';

     if not DateList.Find(Key, Ind) then
        raise EKronosError.Create('Internal error');
     DT := TDaytype(DateList.Objects[Ind]);
     Found := (DT.Id = Id);
     while not Found and (Ind < DateList.Count-1) do
     begin
          inc(Ind);
          DT := TDaytype(DateList.Objects[Ind]);
          Found := (DT.Id = Id)
     end;
     if not Found then
          raise EKronosError.Create('Internal error');
     DateList.Objects[ind].Free;
     DateList.Delete(Ind);
     UpdateInfo;
end;

procedure TKronos.UpdateDaytype;
var
   DT : TDaytype;
   OldKey, NewKey : string;
   IDKey : string;
   Ind : integer;

   function GetKey(ADate, AReldaytype : word; IsCalc : boolean) : string;
   begin
        if IsCalc then
           Result := '0010'
        else if (ADate = 0) and (ARelDaytype = 0) then
           Result := '0000'
        else if ADate = 0 then
           Result := '0100'
        else
           Result := IntToStr(DT.TheDate);
        if Length(Result) = 3 then
           Result := '0' + Result;
    end;

begin
     DT := GetDaytypeObject(AnId, AName);
     AName := DT.TheName;
     OldKey := GetKey(DT.TheDate, DT.Reldaytype, DT.UserCalc);

     DT.Update(DaytypeDef, FFirstUserId);
     AnId := DT.Id;

     NewKey := GetKey(DT.TheDate, DT.Reldaytype, DT.UserCalc);

     if not NameList.Find(AnsiUppercase(Trim(AName)), Ind) then
        raise EKronosError.Create('Internal error');

     if AnsiUpperCase(DaytypeDef.AName) <> NameList[Ind] then
     begin
           NameList.Delete(Ind);
           Ind := NameList.Add(AnsiUpperCase(DaytypeDef.AName));
           NameList.Objects[Ind] := DT;
     end;

     if (OldKey <> NewKey)
     and (DT.Id >= FFirstUserId) then
     begin
          DateList.Find(OldKey, Ind);
          DateList.Delete(Ind);
          Ind := DateList.Add(NewKey);
          DateList.Objects[Ind] := DT;
     end;

     UpdateInfo;
end;

function TKronos.GetDaytypeDef;
var
   DT : TDaytype;
begin
     DT := GetDaytypeObject(AnId, AName);
     with Result do
     begin
          AName := DT.TheName;
          ADate := DT.TheDate;
          ARelDayType := DT.Reldaytype;
          AnOffset := DT.Offset;
          AFirstShowUp := DT.FirstShowUp;
          ALastShowUp := DT.LastShowUp;
          AShowUpFrequency := DT.ShowUpFrequency;
          AChurchDay := DT.Churchday;
          AHoliday := DT.Holiday;
          AFlagday := DT.FlagDay;
          AUserCalc := DT.UserCalc;
          ATag := DT.Tag;
     end;
end;

function TKronos.GetDayTypeObject;
var
   Ind : integer;
   Sid : string;
   i : integer;
begin
     Result := nil;
     if AnId <> 0 then
      begin
           Sid := IntToStr(AnId);
           for i := 1 to 6-Length(Sid) do Sid := '0' + Sid;
           if not IdList.Find(Sid, Ind) then
              raise EKronosError.Create
              ('DayType ' + Sid + ' not found');
           Result := TDaytype(IdList.Objects[Ind]);
      end
      else
      begin
           if NameList.Find(AnsiUppercase(Trim(AName)), Ind) then
           Result := TDaytype(NameList.Objects[Ind]);
      end;
end;

function TKronos.GetNextDaytype;
begin
     Result := nil;
     if (NextIndex < 1) or (NextIndex > IdList.Count) then
         exit;
     Result := TDaytype(IdList.Objects[NextIndex - 1]);
     inc(NextIndex);
end;

function TKronos.GetNextDaytypeName;
{Retrievs a daytype from the daytype list, matching AName and Count}
var
   Ind : integer;
begin
     Result := nil;
     if not Namelist.Find(AnsiUpperCase(AName), Ind) then
     begin
         exit;
     end;
     Ind := Ind + Count - 1;
     if Ind > (NameList.Count-1) then exit;
     if AnsiUpperCase(AName) = Namelist[Ind] then
     begin
          Result := TDaytype(Namelist.Objects[Ind]);
     end;
     inc(Count);
end;

function TKronos.GetNextDaytypeDate;
{Retrievs a daytype from the daytype list, matching ADate and Count}
var
   Ind : integer;
   StrD : string;
begin
     Result := nil;
     StrD := IntTostr(ADate);
     if length(Strd) = 3 then StrD := '0' + Strd;
     if not Datelist.Find(Strd, Ind) then
     begin
         exit;
     end;
     Ind := Ind + Count - 1;
     if Ind > (DateList.Count-1) then exit;
     if Strd = Datelist[Ind] then
     begin
          Result := TDaytype(Datelist.Objects[Ind]);
     end;
     inc(Count);
end;


procedure TKronos.SpecifyStandardDay;
var
   Def : TDayTypeDef;
begin
     Def := GetDaytypeDef(AnId, '');
     Def.AName := AName;
     with Def do
     begin
          Def.AHoliday := IsHoliday;
          Def.AFlagday := IsFlagday;
     end;
     UpdateDaytype(AnId, '', Def);
end;

procedure TKronos.SaveToFile;
var
   F : TextFile;
   i : integer;
   DT : TDaytype;
   Accept : boolean;
   S : string[20];
   ClassID : integer;
   DescKeys : String;
   Key, Value : string;
   Index : integer;
   KeyFound : boolean;
begin
     AssignFile(F, AFilename);
     Rewrite(F);

     try
     Writeln(F,'[Daynames]');
     Writeln(F,'Sun='+Daynames[1]);
     Writeln(F,'Mon='+Daynames[2]);
     Writeln(F,'Tue='+Daynames[3]);
     Writeln(F,'Wed='+Daynames[4]);
     Writeln(F,'Thu='+Daynames[5]);
     Writeln(F,'Fri='+Daynames[6]);
     Writeln(F,'Sat='+Daynames[7]);

     Writeln(F);
     Writeln(F,'[Monthnames]');
     Writeln(F,'Jan='+Monthnames[1]);
     Writeln(F,'Feb='+Monthnames[2]);
     Writeln(F,'Mar='+Monthnames[3]);
     Writeln(F,'Apr='+Monthnames[4]);
     Writeln(F,'May='+Monthnames[5]);
     Writeln(F,'Jun='+Monthnames[6]);
     Writeln(F,'Jul='+Monthnames[7]);
     Writeln(F,'Aug='+Monthnames[8]);
     Writeln(F,'Sep='+Monthnames[9]);
     Writeln(F,'Oct='+Monthnames[10]);
     Writeln(F,'Nov='+Monthnames[11]);
     Writeln(F,'Dec='+Monthnames[12]);
     Writeln(F);

     Writeln(F, ';Week');
     Writeln(F,'[Week]');
     if FFirstWeekDay <> Sunday then
         Writeln(F,'FirstWeekday='+ IntToStr(Ord(FFirstWeekday)));

     if FWeekHolidays <> [Sunday,Saturday] then
     begin
          Write(F,'WeekHolidays=');
          if FWeekHolidays = [] then
             Write(F,'-');
          if Sunday in FWeekHolidays then
              Write(F,IntToStr(Ord(Sunday)));
          if Monday in FWeekHolidays then
              Write(F,IntToStr(Ord(Monday)));
          if Tuesday in FWeekHolidays then
              Write(F,IntToStr(Ord(Tuesday)));
          if Wednesday in FWeekHolidays then
              Write(F,IntToStr(Ord(Wednesday)));
          if Thursday in FWeekHolidays then
              Write(F,IntToStr(Ord(Thursday)));
          if Friday in FWeekHolidays then
              Write(F,IntToStr(Ord(Friday)));
          if Saturday in FWeekHolidays then
              Write(F,IntToStr(Ord(Saturday)));
          Writeln(F);
     end;
     Writeln(F);

     Writeln(F,';Churchdays');
     for i := 0 to ChurchDayCount - 1 do
     with IdList.Objects[i]
     as TDaytype do
     begin
          Writeln(F, '[ch' + intToStr(i+1) + ']');
          Writeln(F, 'Name=' + TheName);
          if Holiday then
             Writeln(F, 'Holiday=' + IntToStr(byte(Holiday)));
          if FlagDay then
             Writeln(F, 'Flagday=' + IntToStr(byte(Flagday)));
          Writeln(F);
     end;

     Writeln(F,';Commondays');
     for i := ChurchdayCount to
     ChurchDayCount + CommondayCount -1 do
     with IdList.Objects[i] as TDaytype do
     begin
          Writeln(F, '[co' + intToStr(i+1) + ']');
          Writeln(F, 'Name=' + TheName);
          if Holiday then
             Writeln(F, 'Holiday=' + IntToStr(byte(Holiday)));
          if Flagday then
             Writeln(F, 'Flagday=' + IntToStr(byte(Flagday)));
          Writeln(F);
     end;

     Writeln(F,';Userdefined days');

     for i := Userdaytype-1 to IdList.Count - 1 do
     begin
          DescKeys := '';
          ClassID := 0;
          DT := TDaytype(IdList.Objects[i]);
          if i > FCspIndex then
          begin
               SaveDaytype(DT,DescKeys,ClassID,Accept);
               if not Accept then continue;
          end;

          with DT do
          begin
               if i <= FCspIndex then
                  Writeln(F, '[cs' + intToStr(i+1) + ']')
               else
                  Writeln(F, '[ud' + intToStr(i+1) + ']');
               if TheName <> '' then
                  Writeln(F, 'Name=' + TheName);
               if TheDate <> 0 then
                  Writeln(F, 'Date=' + IntToStr(TheDate));
               if Reldaytype <> 0 then
                  Writeln(F, 'RelDayType=' + IntToStr(RelDayType));
               if Offset <> 0 then
                  Writeln(F, 'Offset=' + IntToStr(Offset));
               if FirstShowUp <> 1 then
                  Writeln(F, 'FirstShow=' + IntToStr(FirstShowup));
               if LastShowUp <> 9999 then
                  Writeln(F, 'LastShow=' + IntToStr(LastShowup));
               if ShowUpFrequency <> 1 then
                  Writeln(F, 'ShowUpFreq=' + IntToStr(ShowUpFrequency));
               if Churchday then
                  Writeln(F, 'Churchday=' + IntToStr(byte(Churchday)));
               if Holiday then
                  Writeln(F, 'Holiday=' + IntToStr(byte(Holiday)));
               if Flagday then
                  Writeln(F, 'Flagday=' + IntToStr(byte(Flagday)));
               if UserCalc then
                  Writeln(F, 'Calc=' + IntToStr(byte(UserCalc)));
               if Tag <> 0 then
                  Writeln(F, 'Tag=' + IntToStr(Tag));
               if DescKeys <> '' then
               begin
                    Index := 1;
                    KeyFound := GetDescKey(Index,DescKeys, Key, Value);
                    while KeyFound do
                    begin
                         Writeln(F, Key + '=' + Value);
                         KeyFound := GetDescKey
                         (Index,DescKeys, Key, Value);
                    end;
               end;
               Writeln(F, 'Class=' + IntToStr(ClassID));
               Writeln(F);
          end;
     end;
     finally
        CloseFile(F);
     end;

end;

procedure TKronos.LoadFromFile;
var
   F : TextFile;
   i : integer;
   L : string;
   Stopp : boolean;
   SectionType : string;
   SectionNumber : word;
   SectionSpec : string;

   procedure GetValues(S : string; var K, V : string);
   var
      Ind : integer;
   begin
        S := Trim(S);
        K := '';
        V := '';
        if (S = '') or (Pos(';',S) = 1) then
             exit;

        if (Pos('[',S) = 1) and (Pos(']',S) = length(S)) then
        begin
             K := '%NEXT';
             exit;
        end;

        Ind := Pos('=',S);
        if (Ind in [1,0]) or (Ind = Length(S)) then
             exit;

        K := Trim(AnsiUpperCase(copy(S,1,Ind -1)));
        V := Trim(copy(S, Ind + 1, length(S) - ind));
   end;

   procedure GetSectionSpec(S : string; var SType : string;
   {Retrieves the alfacode and the index number of a section.
   Ex: ch5 = CH and 5}
   var Number : word);
   var
      i : integer;
      SNumber : string;
   begin
        Stype := '';
        SNumber := '';
        Number := 0;
        S := AnsiUpperCase(S);
        for i := 1 to length(S) do
        begin
             if S[i] in['A'..'Z'] then
               SType := SType + S[I]
             else if S[i] in['0'..'9'] then
               SNumber := SNumber + S[I];

        end;
        if SNumber <> '' then
           Number := StrToInt(SNumber);
   end;

   function DefineDaynames : string;
   //Returns next section
   var
      S : string;
      Key, Value : string;
   begin
        Result := '';
        repeat
          if Eof(F) then
          begin
               Result := '';
               break;
          end;
          ReadLn(F, S);
          GetValues(S, Key, Value);
          if Key = '' then
            continue
          else if Key = '%NEXT' then
          begin
               Result := S;
               break;
          end;
          if Key = 'SUN' then
             Daynames[1] := Value
          else if Key = 'MON' then
             Daynames[2] := Value
          else if Key = 'TUE' then
             Daynames[3] := Value
          else if Key = 'WED' then
             Daynames[4] := Value
          else if Key = 'THU' then
             Daynames[5] := Value
          else if Key = 'FRI' then
             Daynames[6] := Value
          else if Key = 'SAT' then
             Daynames[7] := Value
        until false;
   end;

   function DefineMonthnames : string;
   //Returns next section
   var
      S : string;
      Key, Value : string;
   begin
        Result := '';
        repeat
          if Eof(F) then
          begin
               Result := '';
               break;
          end;
          ReadLn(F, S);
          GetValues(S, Key, Value);
          if Key = '' then
            continue
          else if Key = '%NEXT' then
          begin
               Result := S;
               break;
          end;
          if Key = 'JAN' then
             Monthnames[1] := Value
          else if Key = 'FEB' then
             Monthnames[2] := Value
          else if Key = 'MAR' then
             Monthnames[3] := Value
          else if Key = 'APR' then
             Monthnames[4] := Value
          else if Key = 'MAY' then
             Monthnames[5] := Value
          else if Key = 'JUN' then
             Monthnames[6] := Value
          else if Key = 'JUL' then
             Monthnames[7] := Value
          else if Key = 'AUG' then
             Monthnames[8] := Value
          else if Key = 'SEP' then
             Monthnames[9] := Value
          else if Key = 'OCT' then
             Monthnames[10] := Value
          else if Key = 'NOV' then
             Monthnames[11] := Value
          else if Key = 'DEC' then
             Monthnames[12] := Value;
        until false;
   end;

   function DefineWeek : string;
   //Returns next section
   var
      S : string;
      Key, Value : string;
      i : integer;
      n : byte;

   begin
        Result := '';
        FWeekHolidays := [Sunday,Saturday];
        FFirstWeekday := Sunday;
        repeat
          if Eof(F) then
          begin
               Result := '';
               break;
          end;
          ReadLn(F, S);
          GetValues(S, Key, Value);
          if Key = '' then
            continue
          else if Key = '%NEXT' then
          begin
               Result := S;
               break;
          end;
          if Key = 'WEEKHOLIDAYS' then
          begin
               Value := Trim(Value);
               FWeekHolidays := [];
               if Value = '-' then
                   continue;
                   {Hypen means no week holidays}
               for i := 1 to length(Value) do
               begin
                    if Value[I] in ['0'..'6'] then
                    begin
                        n := StrToInt(Value[i]);
                        FWeekHolidays := FWeekHolidays + [TWeekDay(n)];
                    end;
               end;
          end
          else if Key = 'FIRSTWEEKDAY' then
          begin
               Value := Trim(Value);
               if length(Value) = 1 then
                  if Value[1] in ['0'..'6'] then
                      FFirstWeekDay := TWeekDay(StrToInt(Value[1]));
          end;
        until false;
   end;

   function DefineStd(Number : word) : string;
   //Returns next section
   var
      S : string;
      Key, Value : string;
      AName : string;
      Flagd, Holid : boolean;

   begin
        Result := '';
        Flagd := False;
        Holid := False;
        with IdList.Objects[Number-1] as TDaytype do
        begin
             //Flagd := FlagDay;
             //Holid := Holiday;
             AName := TheName;
        end;
        repeat
          if Eof(F) then
          begin
               Result := '';
               break;
          end;
          ReadLn(F, S);
          GetValues(S, Key, Value);
          if Key = '' then
            continue
          else if Key = '%NEXT' then
          begin
               Result := S;
               break;
          end;
          if Key = 'NAME' then
          begin
             AName := Value
          end
          else if Key = 'HOLIDAY' then
             Holid := boolean(strToInt(Value))
          else if Key = 'FLAGDAY' then
             FlagD := boolean(strToInt(Value));
        until false;
        SpecifyStandardDay(Number, AName, Holid, Flagd);
   end;

   function DefineUd(Number : word; SecType : string) : string;
   //Returns next section
   var
      S : string;
      Key, Value : string;
      Def : TDaytypeDef;
      i : integer;
      SId : string;
      DT : TDaytype;
      Upd : boolean;
      Ind : integer;
      Accept : boolean;
      DescKeys : string;
      ClassID : Integer;

   begin
        Result := '';
        DescKeys := '';
        with Def do
        begin
         AName := '';
         ADate := 0;
         ARelDayType := 0;
         AnOffset := 0;
         AFirstShowUp := 1;
         ALastShowUp := 9999;
         AShowupFrequency := 1;
         ATag := 0;
         AChurchday := false;
         AHoliday := false;
         AFlagDay := false;
         AUserCalc := false;
         Upd := false;

         if (Number <= FFirstUserId)
         and LoadAll
         and (SecType = 'CS') then
         // Updating exisiting country spesific
         begin
              Upd := true;
              SId := IntToStr(Number);
              for i := 1 to 6 - Length(Sid) do Sid := '0' + Sid;
              if not IdList.Find(Sid, Ind) then
                 raise EKronosError.Create('Internal error');
              DT :=  TDaytype(IdList.Objects[Ind]);
         end;

         repeat
          if Eof(F) then
          begin
               Result := '';
               break;
          end;
          ReadLn(F, S);
          GetValues(S, Key, Value);
          if Key = '' then
            continue
          else if Key = '%NEXT' then
          begin
               Result := S;
               break;
          end;

          if Key = 'NAME' then
          begin
             AName := Value;
             if Upd then
             begin
                  if AnsiUpperCase(Trim(Value)) <>
                  AnsiUpperCase(DT.TheName) then
                  begin
                       NameList.Delete(Ind);
                       Ind := NameList.Add(AnsiUpperCase(Value));
                       NameList.Objects[Ind] := DT;
                  end;
             end;
          end
          else if Key = 'HOLIDAY' then
          begin
             AHoliday := boolean(strToInt(Value));
          end
          else if Key = 'FLAGDAY' then
          begin
             AFlagDay := boolean(strToInt(Value));
          end
          else if Key = 'CHURCHDAY' then
          begin
             AChurchDay := boolean(strToInt(Value));
          end
          else if Key = 'DATE' then
          begin
             if not Upd then ADate := StrToInt(Value);
          end
          else if Key = 'RELDAYTYPE' then
          begin
             if not Upd then AReldayType := StrToInt(Value);
          end
          else if Key = 'OFFSET' then
          begin
             if not Upd then AnOffset := StrToInt(Value);
          end
          else if Key = 'FIRSTSHOW' then
          begin
             if not Upd then AFirstShowUp := StrToInt(Value);
          end
          else if Key = 'LASTSHOW' then
          begin
             if not Upd then ALastShowUp := StrToInt(Value);
          end
          else if Key = 'SHOWUPFREQ' then
          begin
             if not Upd then AShowupFrequency := StrToInt(Value);
          end
          else if Key = 'TAG' then
          begin
             ATag := StrToInt(Value);
          end
          else if Key = 'CLASS' then
          begin
              ClassId := StrToInt(Value);
          end
          else if Key = 'CALC' then
          begin
              if not Upd then AUserCalc := boolean(strToInt(Value));
          end
          else
          begin
               if DescKeys <> '' then DescKeys := DescKeys + ';';
               DescKeys := DescKeys + Key + '=' + Value;
          end;
         until false;
        end;

        if Sectype = 'UD' then
        begin
           LoadDaytype(Def, DescKeys, ClassID, Accept);
           if Accept then
              AddDaytype(TDaytype.Create(Def))
        end
        else
           UpdateDaytype(Number,'',Def);
   end;

begin
     AssignFile(F, AFilename);
     Reset(F);
     Stopp := false;

     ClearLists;
     try
        while not Stopp and not Eof(F) do
        begin
             ReadLn(F, L);
             L := Trim(L);
             Stopp := (Pos('[',L) = 1) and (Pos(']',L) = length(L));
        end;
        if not Stopp then exit;

        GetSectionSpec(L,SectionType, SectionNumber);
        SectionSpec := L;
        try
        repeat
              if SectionType = 'CH' then
              begin
                 if not (SectionNumber in [1..ChurchdayCount]) then
                    raise EKronosError.Create('Invalid section (' +
                   SectionSpec + ') in inputfile');
                 if not Namelist.Sorted then
                    DisableIndexing(False);
                 SectionSpec := DefineStd(SectionNumber);
              end
              else if SectionType = 'CO' then
              begin
                 if not (SectionNumber in [ChurchdayCount +
                 1..UserDayType-1]) then
                    raise EKronosError.Create('Invalid section (' +
                   SectionSpec + ') in inputfile');
                 if not NameList.Sorted then
                    DisableIndexing(False);
                 SectionSpec := DefineStd(SectionNumber);
              end
              else if (SectionType = 'CS') then
              begin
                   if not ((SectionNumber >= Userdaytype)
                   and (SectionNumber < FFirstUserId)) then
                    raise EKronosError.Create('Invalid section (' +
                   SectionSpec + ') in inputfile');
                   if not NameList.Sorted then
                    DisableIndexing(False);
                   SectionSpec := DefineUd(SectionNumber, SectionType);
              end
              else if SectionType = 'UD' then
              begin
                 if Namelist.Sorted then
                     DisableIndexing(True);
                 SectionSpec := DefineUd(SectionNumber, SectionType);
              end
              else if SectionType = 'DAYNAMES' then
                 SectionSpec := DefineDaynames
              else if SectionType = 'MONTHNAMES' then
                 SectionSpec := DefineMonthnames
              else if SectionType = 'WEEK' then
                 SectionSpec := DefineWeek
              else
              begin
                   raise EKronosError.Create('Invalid section (' +
                   SectionSpec + ') in inputfile');
              end;

              if SectionSpec <> '' then
                 GetSectionSpec(SectionSpec, SectionType, SectionNumber);
        until SectionSpec = '';
        finally
              if not Namelist.Sorted then
               DisableIndexing(False);
        end;
     finally
        closeFile(F);
     end;
     UpdateInfo;
end;

procedure TKronos.SetFirstWeekDay;
begin
     if FFirstWeekDay = Value then exit;
     FFirstWeekDay := Value;

     IntFirstWeekday := Ord(FFirstWeekday);
     if IntFirstWeekday = 0 then IntFirstWeekday := 7;

     UpdateInfo;
     if DateExt.Weeknumber <> FWeek then
     begin
          Fweek := DateExt.WeekNumber;
          SetWeekExt;
          ChangeWeek;
          ChangeWeekNumber;
     end;
end;

procedure TKronos.SetWeekHoliDays;
begin
     FWeekHolidays := Value;
     UpdateInfo;
end;

procedure TKronos.UpdateInfo;
{Updates YearExt, DateExt and MonthExt after calls to
AddDaytype, SpecifyCommonday, SpecifiyChurchDay}
begin
     if FYear <> 0 then SetYearExt;
     if FMonth <> 0 then SetMonthExt;
     if FDaynumber <> 0 then SetDateExt(0,0,0,0, Cal, DayCodes);
end;

procedure TKronos.SetCountrySpecifics;
begin
     {Nothing. Use to derive a new component from TKronos}
end;

procedure TKronos.SetDefaults;
var
   i : integer;
   Def : TDaytypeDef;
   TheDaytype : TDaytype;
{Sets Defaults. Necessary to protect standard daytypes
from remaining undefined}
begin

   // Country spesifications for churchdays and commondays
   with Def do
   begin
     AName :='1. Advent Sunday';
     ADate := 0;
     ARelDayType := 0;
     AnOffset := 0;
     AFirstShowUp := 1;
     ALastShowUp := 9999;
     AShowUpFrequency := 1;
     AChurchDay := true;
     AHoliday := false;
     AFlagday := false;
     AUserCalc := false;
     ATag := 0;
     AddDaytype(TDayType.Create(Def));
     AName :='2. Advent Sunday';
     AddDaytype(TDayType.Create(Def));
     AName :='3. Advent Sunday';
     AddDaytype(TDayType.Create(Def));
     AName :='4. Advent Sunday';
     AddDaytype(TDayType.Create(Def));
     AName :='Christmas Eve';
     AddDaytype(TDayType.Create(Def));
     AName :='Christmas Day';
     AddDaytype(TDayType.Create(Def));
     AName :='Boxing Day';
     AddDaytype(TDayType.Create(Def));
     AName :='New Year' + '''' + 's Eve';
     AddDaytype(TDayType.Create(Def));
     AName :='New Year' + '''' + 's Day';
     AddDaytype(TDayType.Create(Def));
     AName :='Shrove Tuesday';
     AddDaytype(TDayType.Create(Def));
     AName :='Ash Wednesday';
     AddDaytype(TDayType.Create(Def));
     AName :='Palm Sunday';
     AddDaytype(TDayType.Create(Def));
     AName :='Maundy Thursday';
     AddDaytype(TDayType.Create(Def));
     AName :='Good Friday';
     AddDaytype(TDayType.Create(Def));
     AName :='EasterEve';
     AddDaytype(TDayType.Create(Def));
     AName :='Easter Sunday';
     AddDaytype(TDayType.Create(Def));
     AName :='Easter Monday';
     AddDaytype(TDayType.Create(Def));
     AName :='Whit Eve';
     AddDaytype(TDayType.Create(Def));
     AName :='Whit Sunday';
     AddDaytype(TDayType.Create(Def));
     AName :='Whit Monday';
     AddDaytype(TDayType.Create(Def));
     AName :='Ascension Day';
     AddDaytype(TDayType.Create(Def));

     AName := 'United Nations Day';
     ADate := 1023;
     AFirstShowUp := 1945;
     AddDaytype(TDayType.Create(Def));
     AName := 'International Womens Day';
     ADate := 308;
     AFirstShowUp := 1910;
     AddDaytype(TDayType.Create(Def));
     AName := 'May Day';
     ADate := 501;
     AFirstShowUp := 1900;
     AChurchday := false;
     AddDaytype(TDayType.Create(Def));
     AName := 'International Literacy Day';
     ADate := 908;
     AFirstShowUp := 1962;
     AddDaytype(TDayType.Create(Def));
   end;

   //Daynames
   for i := 1 to 7 do
       Daynames[i] := LongDaynames[i];
   for i := 1 to 12 do
       Monthnames[i] := LongMonthnames[i];
end;

function TKronos.GetDaytype;
var
   DT : TDaytype;
   ADayTypeId : word;
   I : integer;
   Sid : string;
begin
     if (AnIndex > FDaytypeCount) or (AnIndex < 0) then
        raise EKronosError.Create(c_DayTypeIndexOutOfRange);

     ADayTypeId := FDateExt.DaytypeId[AnIndex];
     with IdList do
     begin
          Sid := IntToStr(ADaytypeId);
          for i := 1 to 6 - Length(Sid) do Sid := '0' + Sid;
          if not Find(Sid, i) then
             raise EKronosError.Create('Internal error');
          Result := TDaytype(Objects[i]);
     end;
end;

function TKronos.GetMonthImage;
// Creates the MonthImage
var
   I,J : integer;
   DayCnt, Daynum : word;
   MndImage : TMonthImage;
   Day : TDay;
   UdIndeks : word;
   WeekNum : word;
   MonthDate : word;
   M : TMonth;
   A : TYear;
begin
    I := 1;
    Daynum := FMonthExt.Firstday;
    DayCnt := FYearExt.NumDays;

    FillChar(MndImage,SizeOf(MndImage), 0);

    while (Cal[Daynum] <= ((Month * 100) + 31))
    and not (Daynum > DayCnt) do
    begin
         Day := ReadDay(Daynum);
         WeekNum := Day.Week;
         UdIndeks := GetDOW(Day.DOWNum);
         MndImage[I, UdIndeks] := Daynum;
         MndImage[I, 0] := WeekNum;
         if UdIndeks = 7 then inc(I);
         inc(Daynum);
         if Daynum > DayCnt then break;
    end;

    //Fill holes with dates from previous and next month
    I := 1;
    while MndImage[1, I] = 0 do
      inc(I);
    dec(I);
    if FMonth = 1 then
       MonthDate := 31
    else
    begin
         M := ReadMonth(FMonth-1);
         MonthDate := M.Daycount;
    end;
    for J := I downto 1 do
    begin
           MndImage[1, J] := -MonthDate;
           dec(MonthDate);
    end;

    I := 1;
    while (MndImage[FMonthExt.NumWeeks, I]) <> 0 do
    begin
      inc(I);
      if I = 8 then
         break;
    end;
    MonthDate := 1;
    for J := I to 7 do
    begin
         MndImage[FMonthExt.NumWeeks, J] := -MonthDate;
         inc(MonthDate);
    end;

    // Fill weeks that belongs to next month
    for I := FMonthExt.NumWeeks + 1 to 6 do
    begin
         for J := 1 to 7 do
         begin
              MndImage[I, J] := -MonthDate;
              inc(MonthDate);
         end;
         if WeekNum = FYearExt.NumWeeks then
            WeekNum := 1
         else
            WeekNum := WeekNum + 1;
         MndImage[I, 0] := -WeekNum;
    end;
    Result := MndImage;
end;

procedure TKronos.DisableIndexing;
begin
     NameList.Sorted := not Disable;
     IdList.Sorted := not Disable;
     DateList.Sorted := not Disable;
end;

procedure TKronos.ClearLists;
var
   I : integer;
begin
     for i := 0 to DateList.Count - 1 do
         DateList.Objects[I].Free;
     DateList.Clear;
     Namelist.Clear;
     IdList.Clear;
     NextId := 1;
     SetDefaults;
     SetCountrySpecifics;
end;


procedure TKronos.DisableEvents;
begin
     FEventsDisabled := Disable;
end;

procedure TKronos.DisableUserCalc;
begin
     FCalcDisabled := Disable;
     if not Disable and FAllowUserCalc then
        SetDateExt(0,0,0,0, Cal, DayCodes);
     {When reenabling Daytype processing it is necessary to recalculate
     the current DateExt when UserCalc is active.}
end;


procedure TKronos.BeginChange;
begin
     if FChanging or FEndChange or FEventsDisabled then exit;

     FTransYear := FYear;
     FTransDayNr := FDayNumber;
     FTransError := false;
     FillChar(FEventBuf,SizeOf(FEventBuf),false);
     FChanging := true;
end;

procedure TKronos.EndChange;
var
   e : TOcEvent;
   de, dt : boolean;
begin
     if not FChanging or FEndChange or FEventsDisabled then exit;
     FChanging := false;
     if FTransError then
     begin
          de := FEventsDisabled;
          Dt := FCalcDisabled;
          DisableEvents(true);
          DisableUserCalc(true);
          Year := FTransYear;
          Daynumber := FTransDayNr;
          DisableEvents(de);
          DisableUserCalc(dt);
          FTransError := false;
          exit;
     end;
     FEndChange := true;
     try
     for e := ocYear to ocCalcDaytype do
     begin
          if FEventBuf[e] then
          case e of
          ocYear : ChangeYear;
          ocMonth : ChangeMonth;
          ocMonthnumber : ChangeMonthnumber;
          ocWeek : ChangeWeek;
          ocWeeknumber : ChangeWeekNumber;
          ocMonthDay : ChangeMonthDay;
          ocWeekday : ChangeWeekday;
          ocDate : ChangeDate;
          ocToday : Today;
          ocCalcDaytype : SetDateExt(0,0,0,0, Cal, DayCodes);
          end;
     end;
     finally
         FEndChange := false;
     end;
end;

function TKronos.IsToday;
var
   A, M, D, Wd : word;
   T1, T2 : TDateTime;
begin
     GetDate(A, M, D, Wd);
     Result :=
     (FYear = A)
     and (FMonth = M)
     and (FMonthDay = D);
     AYear := A;
     T1 := EncodeDate(A,1,1);
     T2 := EncodeDate(A,M,D);
     ADaynumber := Trunc(T2) - Trunc(T1) + 1;
end;

function TKronos.IsTomorrow;
var
   A, M, D : word;
   T1, T2 : TDatetime;
begin
     T2 := Date + 1;
     DecodeDate(T2, A, M, D);
     T1 := EncodeDate(A,1,1);
     Result := (FYear = A)
     and (FMonth = M )
     and (FMonthDay = D);
     AYear := A;
     ADayNumber := Trunc(T2)-Trunc(T1) + 1;
end;

function TKronos.IsYesterday;
var
   A, M, D : word;
   T1, T2 : TDatetime;
begin
     T2 := Date - 1;
     DecodeDate(T2, A, M, D);
     T1 := EncodeDate(A,1,1);
     Result := (FYear = A)
     and (FMonth = M )
     and (FMonthDay = D);
     AYear := A;
     ADayNumber := Trunc(T2)-Trunc(T1) + 1;
end;

function TKronos.IsThisWeek;
var
   A, M, D, Wd : word;
   T : TDatetime;
   DExt : TDateExt;
begin
     T := Date;
     DecodeDate(T, A, M, D);
     DExt := FetchDateExt(A, M, D);
     Result := (FYear = A)
     and (FWeek = DExt.WeekNumber);
     AYear := A;
     AWeeknumber := DExt.WeekNumber;
end;

function TKronos.IsNextWeek;
var
   Y, Dnr : Word;
   YExt : TYearExt;
   DExt : TDateExt;
   WExt : TWeekExt;
   TestWeek, TestYear : word;
   Dt : boolean;
begin
     IsToday(Y, Dnr);
     Dt := FCalcDisabled;
     DisableUserCalc(True);
     try
        DExt := FetchDateExtDn(Y, Dnr);
     finally
        DisableUserCalc(Dt);
     end;

     YExt := FetchYearExt(DExt.Year);
     if DExt.Weeknumber = YExt.NumWeeks then
     begin
          TestYear := YExt.Year + 1;
          TestWeek := 1;
     end
     else
     begin
          TestYear := YExt.Year;
          TestWeek := DExt.Weeknumber + 1;
     end;
     AYear := TestYear;
     AWeeknumber := TestWeek;
     Result :=
     (FYear = TestYear)
     and (FWeek = TestWeek);
end;

function TKronos.IsLastWeek;
var
   Y, Dnr : Word;
   YExt : TYearExt;
   DExt : TDateExt;
   WExt : TWeekExt;
   TestWeek, TestYear : word;
   Dt : boolean;
begin
     IsToday(Y, Dnr);
     Dt := FCalcDisabled;
     DisableUserCalc(True);
     try
        DExt := FetchDateExtDn(Y, Dnr);
     finally
        DisableUserCalc(Dt);
     end;
     if DExt.Weeknumber = 1 then
     begin
          TestYear := Y - 1;
          YExt := FetchYearExt(TestYear);
          TestWeek := YExt.NumWeeks;
     end
     else
     begin
          TestYear := Y;
          TestWeek := DExt.Weeknumber - 1;
     end;
     AYear := TestYear;
     AWeeknumber := TestWeek;
     Result :=
     (FYear = TestYear)
     and (FWeek = TestWeek);
end;

function TKronos.IsThisMonth;
var
   A, M, D, Wd : word;
   T : TDatetime;
   DExt : TDateExt;
   Dt : boolean;
begin
     T := Date;
     DecodeDate(T, A, M, D);
     Dt := FCalcDisabled;
     DisableUserCalc(True);
     try
        DExt := FetchDateExt(A, M, D);
     finally
        DisableUserCalc(Dt);
     end;
     Result := (FYear = A)
     and (FMonth = DExt.MonthNumber);
     AYear := A;
     AMonthnumber := DExt.MonthNumber;
end;

function TKronos.IsNextMonth;
var
   TestYear, TestMonth : word;
   Y, Dnr : word;
   Dt : boolean;
   DExt : TDateExt;
begin
     IsToday(Y, Dnr);
     Dt := FCalcDisabled;
     DisableUserCalc(True);
     try
        DExt := FetchDateExtDn(Y, Dnr);
     finally
        DisableUserCalc(Dt);
     end;
     if DExt.Monthnumber = 12 then
     begin
          TestYear := Y + 1;
          TestMonth := 1;
     end
     else
     begin
          TestYear := Y;
          TestMonth := DExt.Monthnumber + 1;
     end;
     AYear := TestYear;
     AMonthnumber := TestMonth;
     Result :=
     (FYear = TestYear)
     and (FMonth = TestMonth);
end;

function TKronos.IsLastMonth;
var
   TestYear, TestMonth : word;
   Y, Dnr : word;
   Dt : boolean;
   DExt : TDateExt;
begin
     IsToday(Y, Dnr);
     Dt := FCalcDisabled;
     DisableUserCalc(True);
     try
        DExt := FetchDateExtDn(Y, Dnr);
     finally
        DisableUserCalc(Dt);
     end;
     if DExt.Monthnumber = 1 then
     begin
          TestYear := Y - 1;
          TestMonth := 12;
     end
     else
     begin
          TestYear := Y;
          TestMonth := DExt.Monthnumber - 1;
     end;
     AYear := TestYear;
     AMonthnumber := TestMonth;
     Result :=
     (FYear = TestYear)
     and (FMonth = TestMonth);
end;

function TKronos.IsThisYear;
var
   A, M, D : word;
   T : TDatetime;
begin
     T := Date;
     DecodeDate(T, A, M, D);
     Result := (FYear = A);
     AYear := A;
end;

function TKronos.IsNextYear;
var
   A, M, D : word;
   T : TDatetime;
begin
     T := Date;
     DecodeDate(T, A, M, D);
     Result := (FYear = (A + 1));
     AYear := A + 1;
end;

function TKronos.IsLastYear;
var
   A, M, D : word;
   T : TDatetime;
begin
     T := Date;
     DecodeDate(T, A, M, D);
     Result := (FYear = (A-1));
     AYear := A-1;
end;

function TKronos.IsLeapYear;
begin
     Result := IsLeap(AYear);
end;

function TKronos.IsLastDayOfMonth;
var
   M : TMonthExt;
begin
     Result := false;
     M := FetchMonthExt(AYear, AMonth);
     Result := (AMonthday = M.Numdays);
end;


function TKronos.IsLastWeekOfYear;
var
   Y : TYearExt;
begin
     Result := false;
     Y := FetchYearExt(AYear);
     Result := (AWeek = Y.NumWeeks);
end;


function TKronos.FindDayTypeId;
var
   i : integer;
   DT : TDaytype;
   Key : string;
begin
     Result := 0;
     Key := IntToStr(DaytypeId);
     for i := 1 to 6 - Length(Key) do Key := '0' + Key;
     if IdList.Find(Key,i) then
     begin
          DT := TDaytype(IdList.Objects[i]);
          if DT.UserCalc then
          begin
               Result := 367;
               exit;
          end;
          if DT.TheDate <> 0 then
          begin
               Result := ReadDaynr(DT.TheDate);
          end
          else if DT.Reldaytype <> 0 then
          begin
               Result := ChurchdayIndex[DT.RelDayType] +
               DT.Offset;
          end
          else if DT.Id in [1..ChurchdayCount] then
               Result := ChurchdayIndex[DT.Id];
     end;
end;

function TKronos.FindDayType;
{Returns the daynumber}
var
   i : integer;
   DT : TDaytype;
begin
     Result := 0;
     if NameList.Find(Trim(AnsiUpperCase(DayTypeName)),i) then
     begin
          DT := TDaytype(NameList.Objects[i]);
          if DT.UserCalc then
          begin
               Result := 367;
               exit;
          end;
          if DT.TheDate <> 0 then
          begin
               Result := ReadDaynr(DT.TheDate);
          end
          else if DT.Reldaytype <> 0 then
          begin
               Result := ChurchdayIndex[DT.RelDayType] +
               DT.Offset;
          end;
     end;
end;

function TKronos.ExistsDaytype;
var
   i, ind : integer;
   DT : TDaytype;
   Found : boolean;

begin
     Result := 0;
     if NameList.Find(AnsiUppercase(Trim(DaytypeName)), Ind) then
     begin
          inc(Result);
          inc(Ind);
          Found := true;
          while Found and (Ind <= NameList.Count - 1) do
          begin
               DT := TDaytype(NameList.Objects[Ind]);
               if (AnsiUppercase(DT.TheName) =
               AnsiUpperCase(DayTypeName)) then
               begin
                    inc(Result);
                    inc(Ind);
               end
               else
                   Found := false;
          end;
     end;
end;

procedure TKronos.ReChange;
var
   D, A : word;
begin
     ChangeYear;
     ChangeMonth;
     ChangeMonthNumber;
     ChangeWeek;
     ChangeWeekNumber;
     ChangeDate;
     ChangeMonthDay;
     ChangeWeekday;
     if IsToDay(A, D) then
        Today;
end;

function TKronos.DaynumberByTypeName;
{Returns the daynumber of DayTypeName in AYear}
var
  De, Dt : boolean;
  OrigYear, OrigDayNr : word;
begin
     Result := 0;
     OrigYear := FYear;
     OrigDayNr := DayNumber;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     try
        Year := AYear;
        Result := FindDayType(DayTypeName);
     finally
        Year := OrigYear;
        DayNumber := OrigDayNr;
        DisableUserCalc(Dt);
        DisableEvents(De);
     end;
end;

function TKronos.DaynumberByTypeId;
{Returns the daynumber of ADayTypeConst in AYear}
var
  De, Dt : boolean;
  OrigYear, OrigDayNr : word;
begin
     Result := 0;

     OrigYear := FYear;
     OrigDayNr := DayNumber;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     try
        Year := AYear;
        Result := FindDayTypeId(ADayTypeId);
     finally
        Year := OrigYear;
        DayNumber := OrigDayNr;
        DisableEvents(De);
        DisableUserCalc(Dt);
     end;
end;


procedure TKronos.GotoDate;
var
   ic : boolean;
begin
     ic := FChanging;
     BeginChange;
     try
        Year := AYear;
        Month := AMonth;
        Monthday := AMonthday;
     finally
        if not ic then
          EndChange;
     end;
     // if there is a transaction already running don't end
end;

procedure TKronos.GotoDateDt;
var
   Y, M, D, Wd : word;
begin
     DecodeDate(ADate, Y, M, D);
     GotoDate(Y, M, D);
end;

procedure TKronos.GotoDateDn;
var
   ic : boolean;
begin
     ic := FChanging;
     BeginChange;
     try
        Year := AYear;
        Daynumber := ADaynumber;
     finally
        if not ic then
           EndChange;
     end;
end;

procedure TKronos.GotoToday;
var
   Y, M, D, Wd : word;
   ic : boolean;
  begin
     if IsToday(Y,D) then exit;
     GetDate(Y, M, D, Wd);
     ic := FChanging;
     BeginChange;
     try
        Year := Y;
        Month := M;
        MonthDay := D;
     finally
        if not ic then
           EndChange;
     end;
end;

procedure TKronos.GotoTomorrow;
var
   De, Dt, ic : boolean;
   Dnr, Y : word;
begin
     if IsTomorrow(Y, Dnr) then exit;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     SaveIntCD;
     DisableEvents(True);
     DisableUserCalc(True);
     try
        GotoToDay;
        GotoOffsetDay(1, false);
        DNr := DayNumber;
        Y := Year;
     finally
        RestoreIntCD;
        DisableEvents(De);
        DisableUserCalc(Dt);
     end;
     GotoDateDn(Y, Dnr);
end;

procedure TKronos.GotoYesterday;
var
   De, Dt : boolean;
   Dnr, Y : word;
begin
     if IsYesterday(Y, Dnr) then exit;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     SaveIntCD;
     DisableEvents(True);
     DisableUserCalc(True);
     try
        GotoToDay;
        GotoOffsetDay(-1, false);
        DNr := DayNumber;
        Y := Year;
     finally
        RestoreIntCD;
        DisableEvents(De);
        DisableUserCalc(Dt);
     end;
     GotoDateDn(Y, Dnr);
end;

procedure TKronos.GotoThisWeek;
var
   De, Dt : boolean;
   TestWeek,TestYear : word;
   WeekCount : integer;
   A, W : word;
begin
     if IsThisWeek(A, W) then exit;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     SaveIntCD;
     try
        try
           GotoToDay;
           TestWeek := FWeek;
           TestYear := FYear;
        finally
            RestoreIntCD;
            DisableEvents(De);
        end;
        WeekCount := WeeksInInterval(FYear, FWeek, TestYear, TestWeek);
     finally
        DisableUserCalc(Dt);
     end;
     GotoOffsetWeek(WeekCount);
end;

procedure TKronos.GotoNextWeek;
var
   De, Dt : boolean;
   TestWeek, TestYear : word;
   WeekCount : integer;
   A, W : word;
begin
     if IsNextWeek(A,W) then exit;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     SaveIntCD;
     try
        GotoToDay;
        GotoOffsetWeek(1);
        TestWeek := FWeek;
        TestYear := FYear;
     finally
        RestoreIntCD;
        DisableEvents(De);
     end;
     WeekCount := WeeksInInterval(FYear, FWeek, TestYear, TestWeek);
     GotoOffsetWeek(WeekCount);
end;

procedure TKronos.GotoLastWeek;
var
   De, Dt : boolean;
   OrigYear, OrigWeek, TestWeek,
   TestYear, OrigDayNr : word;
   WeekCount : integer;
   A, W : word;
begin
     if IsLastWeek(A, W) then exit;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     SaveIntCD;
     try
        try
           GotoToDay;
           GotoOffsetWeek(-1);
           TestWeek := FWeek;
           TestYear := FYear;
        finally
           RestoreIntCD;
           DisableEvents(De);
        end;
        WeekCount := WeeksInInterval(FYear, FWeek, TestYear, TestWeek);
     finally
        DisableUserCalc(Dt);
     end;
     GotoOffsetWeek(WeekCount);
end;

procedure TKronos.GotoThisMonth;
var
   De, Dt : boolean;
   OrigYear, OrigMonth, TestMonth,
   TestYear, OrigDayNr : word;
   MonthCount : integer;
   A, M : word;
begin
     if IsThisMonth(A, M) then exit;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     OrigYear := FYear;
     OrigMonth := FMonth;
     OrigDayNr := FDayNumber;
     try
        try
           GotoToDay;
           TestMonth := FMonth;
           TestYear := FYear;
        finally
           Year := OrigYear;
           DayNumber := OrigDayNr;
           DisableEvents(De);
        end;
        MonthCount := MonthsInInterval
        (FYear, FMonth, TestYear, TestMonth);
     finally
        DisableUserCalc(Dt);
     end;
     GotoOffsetMonth(MonthCount);
end;

procedure TKronos.GotoNextMonth;
var
   De, Dt : boolean;
   OrigYear, OrigMonth, TestMonth,
   TestYear, OrigDayNr : word;
   MonthCount : integer;
   A, M : word;
begin
     if IsNextMonth(A, M) then exit;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     OrigYear := FYear;
     OrigMonth := FMonth;
     OrigDayNr := FDayNumber;
     try
        try
           GotoToDay;
           GotoOffsetMonth(1);
           TestMonth := FMonth;
           TestYear := FYear;
        finally
           Year := OrigYear;
           DayNumber := OrigDayNr;
           DisableEvents(De);
        end;
        MonthCount := MonthsInInterval
        (FYear, FMonth, TestYear, TestMonth);
     finally
        DisableUserCalc(Dt);
     end;
     GotoOffsetMonth(MonthCount);
end;

procedure TKronos.GotoLastMonth;
var
   De, Dt : boolean;
   OrigYear, OrigMonth, TestMonth,
   TestYear, OrigDayNr : word;
   MonthCount : integer;
   A, M : word;
begin
     if IsLastMonth(A, M) then exit;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     OrigYear := FYear;
     OrigMonth := FMonth;
     OrigDayNr := FDayNumber;
     try
        try
           GotoToDay;
           GotoOffsetMonth(-1);
           TestMonth := FMonth;
           TestYear := FYear;
        finally
            Year := OrigYear;
            DayNumber := OrigDayNr;
            DisableEvents(De);
        end;
        MonthCount := MonthsInInterval
        (FYear, FMonth, TestYear, TestMonth);
     finally
         DisableUserCalc(Dt);
     end;
     GotoOffsetMonth(MonthCount);
end;

procedure TKronos.GotoDayType;
{Moves to the daynumber of DayTypeName/Id}
var
   De, Dt, ic : boolean;
   DayNr : word;
   TrYear : boolean;
   OrigDayNr, OrigYear : word;
begin
     OrigYear := FYear;
     OrigDayNr := FDayNumber;
     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     TrYear := false;
     try
        if AYear <> Year then
        begin
          Year := AYear;
          TrYear := true;
        end;
        if AnId = 0 then
           DayNr := FindDayType(DayTypeName)
        else
           DayNr := FindDaytypeId(AnId);

        if (DayNr = 0)
        or (Daynr = 367) then
        begin
          Year := OrigYear;
          DayNumber := OrigDayNr;
          DisableEvents(De);
          DisableUserCalc(Dt);
          FTransError := FChanging;
          if FTransError then EndChange;
          if Daynr = 0 then
             raise EKronosError.Create
             ('Daytype ' + DayTypeName +  ' not found')
          else
             raise EKronosError.Create
             ('Daytype ' + DayTypeName +  ' is calculated by user');
        end;
     finally
        DisableEvents(De);
        DisableUserCalc(Dt);
     end;

     ic := FChanging;
     BeginChange;
     if TrYear then
     begin
        ChangeYear;
        ChangeMonth;
        ChangeWeek;
     end;
     try
        DayNumber := DayNr;
     finally
        if not ic then
          EndChange;
     end;
end;

function TKronos.DaysInInterval;
{Count number of days between Year1, Monthday1 and Year2, Monthday2.}
var
   Factor : shortint;
   Counter : integer;
   Antall : integer;
   Dt : boolean;
   T1, T2 : TDateTime;
   DE : TDateExt;
   YE : TYearExt;
   Y : Word;
   DayNr : word;
begin
     Result := 0;
     Antall := 0;

     T1 := EncodeDate(Year1,Month1,MonthDay1);
     T2 := EncodeDate(Year2,Month2,MonthDay2);
     Antall := Trunc(T2) - Trunc(T1);

     if not WorkdaysOnly then
     begin
          Result := Antall;
          exit;
     end;

     if Antall = 0 then exit;
     if (Antall < 0) then
         Factor := -1
     else
         Factor := 1;

     Counter := 0;

     Dt := FCalcDisabled;
     DisableUserCalc(True);

     if T2 > T1 then
     begin
        DE := FetchDateExtDt(T1);
        YE := FetchYearExt(Year1);
     end

     else
     begin
        DE := FetchDateExtDt(T2);
        YE := FetchYearExt(Year2);
     end;
     Y := YE.Year;
     DayNr := DE.DayNumber;

     try
        while Counter <> Antall do
        begin
          if (DayNr + Factor) > YE.NumDays then
          begin
               Y := Y + Factor;
               YE := FetchYearExt(Y);
               DE := FetchDateExtDn(Y,1);
               DayNr := 1;
          end
          else if (DayNr + Factor) < 1 then
          begin
               Y := Y + Factor;
               YE := FetchYearExt(Y);
               DayNr := YE.NumDays;
               DE := FetchDateExtDn(Y,DayNr);
          end
          else
          begin
              DayNr := DayNr + Factor;
              DE := FetchDateExtDn(Y,DayNr);
          end;
          if not DE.Holiday then
             Result := Result + Factor;
          Counter := Counter + Factor;
        end;

     finally
            DisableUserCalc(Dt);
     end;
end;

function TKronos.DaysInIntervalDt;
var
   AYear1, AMonth1, ADate1 : word;
   AYear2, AMonth2, ADate2 : word;
begin
     DecodeDate(Date1, Ayear1, AMonth1, ADate1);
     DecodeDate(Date2, Ayear2, AMonth2, ADate2);
     Result := DaysInInterval(AYear1, AMonth1, ADate1,
     AYear2, AMonth2, ADate2, WorkdaysOnly);
end;

function TKronos.DaysInIntervalDn;
var
   AMonth1, ADate1 : word;
   AMonth2, ADate2 : word;
   DExt1, DExt2 : TDateExt;
begin
     DExt1 := FetchDateExtDn(Year1, Daynumber1);
     AMonth1 := DExt1.MonthNumber;
     ADate1 := DExt1.MonthDay;
     DExt2 := FetchDateExtDn(Year2, Daynumber2);
     AMonth2 := DExt2.MonthNumber;
     ADate2 := DExt2.MonthDay;

     Result := DaysInInterval(Year1, AMonth1, ADate1,
     Year2, AMonth2, ADate2, WorkdaysOnly);
end;


function TKronos.WeeksInInterval;
{Count number of weeks between Year1, Week1 and Year2, Week2.}
var
   Factor : shortint;
   Y1, Y2, W1, W2 : word;
   WExt1, WExt2 : TWeekExt;
   YExt : TYearExt;
   DaysInt : Integer;
begin
     Result := 0;

     if Year2 < Year1 then
     begin
          Y1 := Year2;
          Y2 := Year1;
          W2 := Week1;
          W1 := Week2;
          Factor := -1;
     end
     else if (Year2 = Year1) and (Week2 < Week1) then
     begin
          Y1 := Year1;
          Y2 := Year2;
          W1 := Week2;
          W2 := Week1;
          Factor := -1;
     end
     else
     begin
          Y1 := Year1;
          Y2 := Year2;
          W1 := Week1;
          W2 := Week2;
          Factor := 1;
     end;

     WExt1 := FetchWeekExt(Y1, W1);
     WExt2 := FetchWeekExt(Y2, W2);
     if (WExt1.LastDay < Wext1.Firstday)
     and (W1 = 1) then
          dec(Y1);
     if (WExt2.LastDay < Wext2.Firstday)
     and (W2 = 1) then
          dec(Y2);
     DaysInt := DaysInIntervalDn(Y1, WExt1.FirstDay,
     Y2, WExt2.FirstDay, false);
     Result := (DaysInt div 7) * Factor;
end;

function TKronos.MonthsInInterval;
{Count number of months between Year1, Month1 and Year2, Month2.}
var
   Factor : shortint;
   Y1, Y2, M1, M2 : word;
   MndNr : word;
   Aar : word;
   Antall, AntMnd : integer;
begin
     Result := 0;
     Antall := 0;

     if Year2 < Year1 then
     begin
          Y1 := Year2;
          Y2 := Year1;
          M1 := Month2;
          M2 := Month1;
          Factor := -1;
     end
     else if (Year2 = Year1) and (Month2 < Month1) then
     begin
          Y1 := Year1;
          Y2 := Year2;
          M1 := Month2;
          M2 := Month1;
          Factor := -1;
     end
     else
     begin
          Y1 := Year1;
          Y2 := Year2;
          M1 := Month1;
          M2 := Month2;
          Factor := 1;
     end;

     Aar := Y1;

     if ((M1 > 12) or (M1 = 0))
     or  ((M2 > 12) or (M2 = 0)) then
     begin
          raise EKronosError.Create(c_MonthOutofBounds);
     end;

     MndNr := M1;

     while not ((Aar = Y2) and (MndNr = M2)) do
     begin
           inc(Antall);
           if MndNr = 12 then
           begin
                inc(Aar);
                MndNr := 1;
           end
           else
           begin
                inc(MndNr);
           end;
     end;

     Result := Antall * Factor;
end;


procedure TKronos.FindOffsetDay;
{Returns the day and year by counting offset-days from current day}
var
   Factor : shortint;
   Antall : integer;
   Counter : integer;
   T : TDateTime;
   M, D : word;
   DE : TDateExt;
   YE : TYearExt;
   DayNr : word;
   Y : word;
   OrigYear, OrigDaynr : word;
   Dsbl, Dt : Boolean;
begin
     Dsbl := FEventsDisabled;
     Dt := FCalcDisabled;
     if not WorkdaysOnly then
     begin
          T := CDToDateTime;
          T := T + OffsetValue;
          DecodeDate(T, TheYear, M, D);
          if (TheYear > FMaxYear)
          or (TheYear < FMinYear) then
          begin
               raise EKronosError.Create(c_YearOutOfBounds);
          end;
          DE := FetchDateExtDt(T);
          TheDayNumber := DE.DayNumber;
          exit;
     end;

     if (OffsetValue < 0) then
         Factor := -1
     else
         Factor := 1;

     OrigYear := FYear;
     OrigDayNr := FDaynumber;

     DE := FDateExt;
     YE := FYearExt;
     DayNr := FDaynumber;
     Y := FYear;
     Counter := 0;

     DisableEvents(True);
     DisableUserCalc(True);
     try
     while Counter <> OffsetValue do
     begin
          if (DayNr + Factor) > YE.NumDays then
          begin
               Y := Y + Factor;
               Year := Y;
               YE := FYearExt;
               DE := FetchDateExtDn(FYear,1);
               DayNr := 1;
          end
          else if (DayNr + Factor) < 1 then
          begin
               Y := Y + Factor;
               Year := Year + Factor;
               YE := FYearExt;
               DayNr := YE.NumDays;
               DE := FetchDateExtDn(FYear,YE.Numdays);
          end
          else
          begin
              DayNr := DayNr + Factor;
              DE := FetchDateExtDn(Y,Daynr);
          end;
          if not DE.Holiday then
             Counter := Counter + Factor;
     end;
     finally
          Year := OrigYear;
          Daynumber := OrigDayNr;
          DisableEvents(Dsbl);
          DisableUserCalc(Dt);
     end;
     TheYear := Y;
     TheDayNumber := DayNr;
end;

procedure TKronos.FindOffsetWeek;
var
   nDays : integer;
begin
     nDays := OffsetValue * 7;
     FindOffsetDay(TheYear, TheDayNumber, nDays, false);
end;

procedure TKronos.FindOffsetMonth;
var
   Rest : integer;
   Factor : integer;
   Y, M : word;
   IsLeft : integer;
   OrigYear, OrigDayNr : word;
   De, Dt : boolean;
begin
     if OffsetValue < 0 then
        Factor := -1
     else
        Factor := 1;

     if Factor < 0 then
        Rest := FMonth - 1
     else
        Rest := 12 - FMonth;

     OrigYear := Year;
     OrigDayNr := DayNumber;

     De := FEventsDisabled;
     Dt := FCalcDisabled;
     DisableEvents(True);
     DisableUserCalc(True);
     try
       IsLeft := Abs(OffsetValue) - Rest;
       //Gjenstående utover inneværende år
       if IsLeft <= 0 then
       begin
          Month := Month + OffsetValue;
       end
       else
       begin
          Y := IsLeft div 12;
          //Antall hele år i Gjenstående
          Year := Year + (Y * Factor);
          M := IsLeft mod 12;
          //Antall måneder utover hele år
          if M > 0 then
          begin
               Year := Year + Factor;
               if Factor < 0 then
                  Month := 13 - M
               else
                  Month := M;
          end
          else
          begin
              if Factor > 0 then
                 Month := 12
              else
                 Month := 1;
          end;
       end;

       TheYear := Year;
       TheDayNumber := DayNumber;
     finally
       Year := OrigYear;
       DayNumber := OrigDayNr;
       DisableEvents(De);
       DisableUserCalc(Dt);
     end;
end;

function TKronos.GetDow;
var
   FirstDay : word;
begin
     FirstDay := Ord(FFirstWeekDay);
     if FirstDay = 0 then FirstDay := 7;
     Result := 7 - (FirstDay - DNr) + 1;
     if Result > 7 then
     Result := Result -7;
end;

function TKronos.ConvertWeekday;
{Converts a dow number of type 1=Monday, 2=Sunday to type TWeekDay}
begin
     Result := Sunday;
     if DayOfWeekNumber <> 7 then
        Result := TWeekDay(DayOfWeekNumber);
end;

procedure TKronos.GoToOffsetWeek;
var
   TheYear, TheDayNumber : word;
   ic : boolean;
begin
     FindOffsetWeek(TheYear, TheDayNumber, OffsetValue);

     ic := FChanging;
     BeginChange;
     if Year <> TheYear then
     begin
          Year := TheYear;
          if DayNumber <> TheDayNumber then
             DayNumber := TheDayNumber;
     end
     else if DayNumber <> TheDayNumber then
          DayNumber := TheDayNumber;
     if not ic then
        EndChange;
end;

procedure TKronos.GotoOffsetMonth;
var
   TheYear, TheDayNumber : word;
   ic : boolean;
begin
     FindOffsetMonth(TheYear, TheDayNumber, OffsetValue);

     ic := FChanging;
     BeginChange;
     try
        if Year <> TheYear then
        begin
          Year := TheYear;
          if DayNumber <> TheDayNumber then
             DayNumber := TheDayNumber;
        end
        else if DayNumber <> TheDayNumber then
          DayNumber := TheDayNumber;
     finally
        if not ic then
           EndChange;
     end;
end;

procedure TKronos.GoToOffsetDay;
{Sets the current day acc. to OffsetValue with starting point in current date}
var
   AYear, ADayNr : word;
   ic : boolean;
begin
     try
        FindOffsetDay(AYear, ADayNr, OffsetValue, WorkdaysOnly);
     except
        FTransError := FChanging;
        //if FTransError then EndChange;
        raise;
     end;

     ic := FChanging;
     BeginChange;
     try
        if AYear <> Year then
        begin
             Year := AYear;
             DayNumber := ADayNr;
        end
        else if ADayNr <> DayNumber then
             DayNumber := ADayNr;
     finally
        if not ic then
           EndChange;
     end;
end;

procedure TKronos.DateByWeekOffset;
begin
     FindOffsetWeek(TheYear, TheDayNumber, OffsetValue);
end;

procedure TKronos.DateByMonthOffset;
begin
     FindOffsetMonth(TheYear, TheDayNumber, OffsetValue);
end;

procedure TKronos.DateByDayOffset;
{Counts the days acc. to OffsetValue with starting point in current date.
Returns year and daynumber}
begin
     FindOffsetDay(TheYear, TheDayNumber, OffsetValue, WorkDaysOnly);
end;

function TKronos.FetchYearExt;
var
   OrigYear : word;
   DayC : TDayCodes;
   Cl : TCal;
begin
     OrigYear := Year;
     if (AYear > FMaxYear)
     or (AYear < FMinYear) then
        raise EKronosError.Create(c_YearOutOfBounds);
     if AYear <> FYear then
     begin
          Cl := Cal;
          DayC := DayCodes;
          ChangeKron(AYear);
          FYear := AYear;
          SetYearExt;
     end;
     Result := FYearExt;

     if (OrigYear <> FYear) then
     begin
           //ChangeKron(OrigYear);
           DayCodes := DayC;
           Cal := Cl;
           Kron.ActiveYear := OrigYear;
           FYear := OrigYear;
           SetYearExt;
     end;
end;

function TKronos.FetchMonthExt;
var
   OrigYear, OrigMonth : word;
   Cl :TCal;
   DayC : TDayCodes;
begin
     OrigYear := FYear;
     OrigMonth := FMonth;
     if (AYear > FMaxYear)
     or (AYear < FMinYear) then
        raise EKronosError.Create(c_YearOutOfBounds);
     if (AMonth > 12) or (AMonth < 1) then
        raise EKronosError.Create(c_MonthOutOfBounds);

     if AYear <> FYear then
     begin
          Cl := Cal;
          DayC := DayCodes;
          ChangeKron(AYear);
          FYear := AYear;
          SetYearExt;
     end;

     try
        FMonth := AMonth;
        SetMonthExt;
        Result := FMonthExt;
     finally
        if OrigYear <> FYear then
        begin
             //ChangeKron(OrigYear);
             Cal := Cl;
             DayCodes := Dayc;
             Kron.ActiveYear := OrigYear;
             FYear := OrigYear;
             SetYearExt;
        end;
        FMonth := OrigMonth;
        SetMonthExt;
     end;
end;

function TKronos.FetchWeekExt;
var
   OrigYear, OrigWeek : word;
   A : TYear;
   Cl : TCal;
   DayC : TDayCodes;
begin
     OrigYear := FYear;
     OrigWeek := FWeek;
     if (AYear > FMaxYear)
     or (AYear < FMinYear) then
        raise EKronosError.Create(c_YearOutOfBounds);
     if AYear <> FYear then
     begin
        Cl := Cal;
        DayC := DayCodes;
        ChangeKron(AYear);
     end;
     A := ReadYear;
     try
        if (AWeek > A.WeekCount) or (AWeek < 1) then
           raise EKronosError.Create(c_WeekOutOfBounds);
        FWeek := AWeek;
        FYear := AYear;
        SetWeekExt;
        Result := FWeekExt;
     finally
        if OrigYear <> FYear then
        begin
             //ChangeKron(FYear);
             Cal := Cl;
             DayCodes := DayC;
             Kron.ActiveYear := OrigYear;
        end;
        FWeek := OrigWeek;
        FYear := OrigYear;
        SetWeekext;
     end;
end;

function TKronos.FetchDateExt;
var
   OrigYear, OrigDayNr : word;
   origMonth, OrigMonthDay : word;
   OrigDateExt : TDateExt;
   M : TMonth;
   DayC : TDayCodes;
   Cl : TCal;
begin
     OrigYear := FYear;
     OrigDayNr := FDayNumber;
     OrigMonth := FMonth;
     OrigMonthday := FMonthday;
     OrigDateExt := FDateExt;

     if (AYear > FMaxYear)
     or (AYear < FMinYear) then
        raise EKronosError.Create(c_YearOutOfBounds);
     if (AMonth > 12)
     or (AMonth < 1) then
        raise EKronosError.Create(c_MonthOutOfBounds);

     try
        if FYear <> AYear then
        begin
           Cl := Cal;
           DayC := DayCodes;
           ChangeKron(AYear);
        end;
        M := ReadMonth(AMonth);
        if AMonthday > M.Daycount then
        begin
           raise EKronosError.Create(c_MonthdayOutofBounds);
        end;
        FYear := AYear;
        FMonth := AMonth;
        FMonthDay := AMonthDay;
        FDaynumber := ReadDayNr(AMonth*100+AMonthday);
        SetDateExt(OrigYear, OrigMonth, OrigMonthDay, OrigDaynr,
        Cl, DayC);
        Result := FDateExt;
     finally
        if OrigYear <> FYear then
        begin
             Cal := Cl;
             DayCodes := DayC;
             Kron.ActiveYear := OrigYear;
        end;
        FYear := OrigYear;
        FMonth := OrigMonth;
        FMonthDay := OrigMonthday;
        FDaynumber := OrigDaynr;
        FDateExt := OrigDateExt;
        FDaytypeCount := OrigDateExt.DaytypeCount;
        //SetDateExt(0,0,0,0, Cal, DayCodes);
     end;
end;

function TKronos.FetchDateExtDt;
var
   AYear, AMonth, AnDate : word;
begin
     DecodeDate(ADate, Ayear, AMonth, AnDate);
     Result := FetchDateExt(AYear, AMonth, AnDate);
end;

function TKronos.FetchDateExtDn;
var
   M, Md : word;
   T1, T2 : TDatetime;
begin
     if (AYear > FMaxYear)
     or (AYear < FMinYear) then
        raise EKronosError.Create(c_YearOutOfBounds);
     if IsLeap(AYear) then
     begin
          if (ADaynumber > 366) or (ADaynumber < 1) then
             raise EKronosError.Create(c_DaynumberOutOfBounds + ' ' +
             intToStr(ADaynumber));
     end
     else
          if (ADaynumber > 365) or (ADaynumber < 1) then
             raise EKronosError.Create(c_DaynumberOutOfBounds + ' ' +
             intToStr(ADaynumber));

     T1 := EncodeDate(AYear,1,1);
     T2 := T1 + ADayNumber - 1;
     DecodeDate(T2, AYear, M, Md);

     Result := FetchDateExt(AYear, M, Md);
end;

function TKronos.FetchYearType;
var
   I : Integer;
   IndCount : word;
   DT : TDaytype;
begin
      IndCount := 0;
      I := 0;
      Result := nil;
      if DateList.Count = 0 then exit;
      while (i <= DateList.Count - 1)
      and (DateList[I] = '0000') do
      begin
           DT := TDaytype(DateList.Objects[i]);
           if (DT.Id >= UserDaytype)
           and (AYearExt.Year >= DT.FirstShowup)
           and (AYearExt.Year <= DT.LastShowup)
           and ((AYearExt.Year - DT.FirstShowUp) mod
           DT.ShowupFrequency = 0) then
           begin
                inc(IndCount);
                if IndCount = AnIndex then
                   Result := DT;
           end;
           inc(I);
      end;
end;

function TKronos.FetchDaytype;
var
   OrigCount : Word;
   OrigIds : TDaytypeID;
begin
     OrigCount := FDaytypeCount;
     OrigIds := FDateExt.DaytypeId;
     FDaytypeCount := ADateExt.DaytypeCount;
     FDateExt.DaytypeID := ADateExt.DaytypeID;
     try
        Result := GetDaytype(AnIndex);
     finally
        FDaytypeCount := OrigCount;
        FDateExt.DaytypeId := OrigIds;
     end;
end;


procedure TKronos.SaveCD;
begin
     FSavedYear := FYear;
     FSavedDayNumber := FDaynumber;
end;

procedure TKronos.RestoreCD;
begin
     if FSavedYear = 0 then exit;
     Year := FSavedYear;
     DayNumber := FSavedDayNumber;
     FSavedDayNumber := 0;
     FSavedYear := 0;
end;

procedure TKronos.SaveIntCD;
begin
     FIntYear := FYear;
     FIntDayNumber := FDaynumber;
end;

procedure TKronos.RestoreIntCD;
begin
     if FIntYear = 0 then exit;
     Year := FIntYear;
     DayNumber := FIntDayNumber;
     FSavedDayNumber := 0;
     FSavedYear := 0;
end;

function TKronos.DOWtoWeekDay;
{Converts a day of week number to Tweekday type}
var
   Nr : word;
begin
     if not (ADayOfWeekNumber in [1..7]) then
        raise EKronosError.Create(c_DayOfWeekNumberOutOfBounds);
     Nr := (ADayOfWeekNumber + Ord(FFirstWeekDay) - 1);
     if Nr > 7 then Nr := Nr -7;
     Result := TWeekday(Nr);

end;

function TKronos.DOWtoDaynameIndex;
{Converts a day of week number to an index that can be used to
access the Daynames array}
var
   FirstDay : word;
begin
     if not (ADayOfWeekNumber in [1..7]) then
        raise EKronosError.Create(c_DayOfWeekNumberOutOfBounds);

     FirstDay := Ord(FFirstWeekday);

     inc(ADayOfWeekNumber, FirstDay);
     if ADayOfWeekNumber > 7 then
        ADayOfWeekNumber := ADayOfWeeknumber - 7;
     Result := ADayOfWeekNumber;
end;

function TKronos.CDtoDateTime;
begin
     Result := EncodeDate(FYear, FMonth, FMonthDay);
end;

procedure TKronos.GetMIDayCell;
{Returns the row and column in the current MonthImage that contains
ADaynumber}
var
   i, j : word;
begin
     ARow := 0;
     ACol := 0;
     for i := 1 to MonthExt.NumWeeks do
     begin
          for j := 1 to 7 do
          begin
               if MonthExt.MonthImage[i,j] = ADayNumber then
               begin
                    ARow := i;
                    ACol := j;
                    exit;
               end;
          end;
     end;
end;

function TKronos.GetMIWeekRow;
{Returns the row in the current MonthImage that contains
AWeekNumber}
var
   I : integer;
begin
     Result := 0;
     for i := 1 to MonthExt.NumWeeks do
     begin
          if MonthExt.MonthImage[I,0] = AWeekNumber then
          begin
               Result := I;
               exit;
          end;
     end;
end;

procedure TKronos.GetFirstMIDayCell;
{Returns the row and column in the current MonthImage that contains
the first daynumber}
var
   I : integer;
begin
     ACol := 0;
     ARow := 0;
     for i := 1 to 7 do
     begin
          if MonthExt.MonthImage[1, i] > 0 then
          begin
               ARow := 1;
               ACol := I;
               exit;
          end;
     end;
end;

procedure TKronos.GetLastMIDayCell;
{Returns the row and column in the current MonthImage that contains
the last daynumber}
var
   I : integer;
begin
     ACol := 0;
     ARow := 0;
     for i := 1 to 7 do
     with MonthExt do
     begin
          if MonthImage[NumWeeks, i] < 0 then
          begin
               ARow := Numweeks;
               ACol := I-1;
               exit;
          end;
     end;
     with MonthExt do
     begin
          ARow := NumWeeks;
          ACol := 7;
     end;
end;

function TKronos.GetDescKey;
var
   Element : string;
   I : integer;
   DP, FP : integer;
   StartPos, EndPos : integer;

   procedure SetValues(AKey : string);
   var
      P : integer;
   begin
        P := Pos('=', AKey);
        if P = 0 then
        begin
              Result := false;
              exit;
        end;
        KeyName := Trim(copy(AKey, 1, P-1));
        Value := Trim(copy(AKey, P + 1, Length(AKey) - P));
   end;
begin
     Result := true;
     if Index = -1 then
     begin
          Result := false;
          exit;
     end;
     FP := 0;
     if Keys = '' then
     begin
          Result := false;
          exit;
     end;
     DP := 0;
     FP := 0;
     for i := 1 to Index do
     begin
          FP := DP;
          DP := Pos(';', Keys);
          if DP <> 0 then
             Keys[DP] := #9;
     end;
     if (DP = 0) and (FP = 0) then //One element only
     begin
        SetValues(Keys);
        Index := - 1;
     end
     else if DP = 0 then //Last element
     begin
        SetValues(copy(Keys, FP+1, Length(Keys) - FP));
        Index := -1;
     end
     else
     begin
        SetValues(copy(Keys, FP+1, DP - FP - 1));
        inc(Index);
     end;
end;




end.

