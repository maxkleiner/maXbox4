//////////// WARNING:  May not conform to offical NMEA specifications //////////
//                                                                            //
//             National Marine Electronics Association (NMEA)                 //
//             Component to process NMEA formatted sentences                  //
//                                                                            //
//                      Embedded ComPort from AsyncPro                        //
//                                                                            //
//                      CHARLES SEITZ   September 2006                        //
////////////////////////////////////////////////////////////////////////////////

{Decodes GPRMC, GPGGA, GPGSA sentences provided by modern GPS receivers}

{GPS Events:

 1) OnSentence for every sentence that passes the checksum test.
     Parameter A is an array of the sentence field strings that facilitates
     writing handlers for special sentences.
 2) OnError when a checksum fails or when sentence decoding fails.
 3) OnValidFix after every GPRMC sentence that provides a valid fix. West Lon
     and South Lat are negative.  Call properties UTCTime, LatAsStr, LonAsStr
     from within the OnValidFix handler.
 4) OnFixLoss when fix changes from valid to invalid.  An alarm will sound if
     FixLossAlarm is True.
 5) OnFixProgress when No, 2D, 3D fix changes.
 6) OnFixQuality when None, SPS, DGPS changes.
 7) OnComLoss when a valid sentence is not received during ComTimeOut interval}

{Other data:

 1) Many receivers do not provide Magnetic data so you should always test
     HasMagVar before applying Magnetic Declination when computing compass
     headings.  Consider computing Magnetic Declination yourself because the
     the data for its computation is updated every five years which might cause
     receiver firmware to become outdated.
 2) Some recivers do not compute the altitude above MSL properly. Test
     HasGeoidDelta to determine if a receiver is modeling the earth geoid.
 3) Test IsDGPS to determine if accuracy is augmented.  Some receivers indicate
     DGPS when WAAS is active}

{Embedded ComPort:

 1) When ComNumber is set to zero and ComOpen is True, the Select Port dialog
     will activate to user initialize the embedded ComPort.  Otherwise you are
     responsible for specifying a valid comport before setting ComOpen to True.
 2) Standard NMEA0183 is 4800 baud but NMEA multiplexers and Bluetooth often
     operate at higer rates.  A property editor sets standard baud rates}



                              UNIT GPS2;

                              INTERFACE

uses
  // DsgnIntf, AdPEditBR,
  Windows, Classes, ExtCtrls, SysUtils, AdPort, NavUtils, NMEA;

type

  TPrnSet = set of 1..31;
  TUnits = (Nautical, Statute, Metric);
  TStrFormat = (DDMMSS, DDMMmm, DDddd);
  TFloatUnits = (Deg, Min, Sec, Rad);
  TDataArray = array [0..20] of string;

  TRecEvent =
    procedure(Sender: TObject; SenID: string; A: TDataArray) of object;
  TFixEvent =
    procedure(Sender: TObject; Lat, Lon, SOG, COG: Double) of object;
  TProgEvent =
    procedure(Sender: TObject; Progress: string; FixD: Integer) of object;
  TQalEvent =
    procedure(Sender: TObject; Quality: string; FixQ: Integer) of object;
  TErrEvent =
    procedure(Sender: TObject; ErrMsg: string) of object;

  TGPS2 = class(TComponent)
  private
    A: TDataArray;                        // Parsed sentence fields
    fTimer: TTimer;
    fApdComPort: TApdComPort;             // Embedded AsynPro ComPort
    fMsgBuffer: string;
    fNmeaSen: string;
    fError: string;
    fFixValid: Boolean;
    fLatInDeg: Double;                    // Lat Lon of Last fix    {RMC}
    fLonInDeg: Double;                    // DDD.dddd               {RMC}
    fDateTime: TDateTime;                                           {RMC}
    fSOG: Double;                                                   {RMC}
    fCOG: Double;                         // True course            {RMC}
    fHasMagVar: Boolean;                                            {RMC}
    fMagVar: Double;                      // Negative West          {RMC}
    fFixQalIdx: Integer;                  // None, SPS, DGPS, PPS   {GGA}
    fFixSatCount: Integer;                // Number SVs in fix      {GGA}
    fAltitude: Double;                    // Height AMSL            {GGA}
    fAltUnits: Char;                      // M or F                 {GGA}
    fHasGeoidDelta: Boolean;
    fGeoidDelta: Double;                  // Height above WGS84     {GGA}
    fDeltaUnits: Char;                    // M or F                 {GGA}
    fIsDGPS: Boolean;
    fAgeDGPS: Double;                                               {GGA}
    fStnDGPS: string;                                               {GGA}
    fFixMode: string;                     // Auto, Manual           {GSA}
    fFixProgIdx: Integer;                 // None, 2D, 3D           {GSA}
    fHDOP: Double;                                                  {GSA}
    fVDOP: Double;                                                  {GSA}
    fPDOP: Double;                                                  {GSA}
    fFixPrnSet: TPrnSet;                  // List of PRNs in fix    {GSA}

    fTimeout: Integer;
    fAlarm: Boolean;
    fBeep: Boolean;
    fStrFormat: tStrFormat;
    fFloatUnits: tFloatUnits;
    fUnits: tUnits;
    fVersion: string;

    fOnSen: TRecEvent;
    fOnFix: TFixEvent;
    fOnFixLoss: TNotifyEvent;
    fOnProg: TProgEvent;
    fOnQal: TQalEvent;
    fOnErr: TErrEvent;
    fOnComLoss: TNotifyEvent;

    function RMC: Boolean;
    function GGA: Boolean;
    function GSA: Boolean;
    function LatInPosUnits: Double;
    function LonInPosUnits: Double;
    function LatInStrFmt: string;
    function LonInStrFmt: string;
    function AltInUnits: Double;
    function SOGInUnits: Double;
    function GetOpen: Boolean;
    procedure SetOpen(const Open: Boolean);
    function GetBaud: Integer;
    procedure SetBaud(const NewBaud: Integer);
    function GetComNumber: Word;
    procedure SetComNumber(const NewComNum: Word);
    procedure SetTimeOut(const Interval: Integer);
    procedure SetVersion(const Version: string);
    procedure ComTimedOut(Sender: TObject);
    procedure ApdComPortTriggerAvail(CP: TObject; Count: Word);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Accepted(const sNmea: string): Boolean;
  published
    procedure SendStr(const S: string);
    function SetSysClock: Boolean;
    function FixSatSet: TPrnSet;
    procedure GDOP(out HDOP, VDOP, PDOP: Double);
    property NmeaSentence: string read fNmeaSen;
    property UTCTime: TDateTime read fDateTime;
    property LatAsStr: string read LatInStrFmt;
    property LonAsStr: string read LonInStrFmt;
    property HasMagVar: Boolean read fHasMagVar;
    property MagVar: Double read fMagVar;
    property Altitude: Double read AltInUnits;
    property AltUnits: Char read fAltUnits;
    property HasGeoidDelta: Boolean read fHasGeoidDelta;
    property GeoidDelta: Double read fGeoidDelta;
    property DeltaUnits: Char read fDeltaUnits;
    property IsDGPS: Boolean read fIsDGPS;
    property AgeDGPS: Double read fAgeDGPS;
    property StnDGPS: string read fStnDGPS;
    property FixMode: string read fFixMode;
    property FixSatCount: Integer read fFixSatCount;
    {Object Inspector -- See Notes}
    property ComBaud: Integer read GetBaud write SetBaud;
    property ComNumber: Word read GetComNumber write SetComNumber;
    property ComOpen: Boolean read GetOpen write SetOpen;
    property ComTimeOut: Integer read fTimeOut write SetTimeOut;
    property Units: tUnits read fUnits write fUnits;
    property StrFormat: tStrFormat read fStrFormat write fStrFormat;
    property PosUnits: tFloatUnits read fFloatUnits write fFloatUnits;
    property FixLossAlarm: Boolean read fAlarm write fAlarm;
    property ErrorBeep: Boolean read fBeep write fBeep;
    property Version: string read fVersion write SetVersion;
    {Events}
    property OnSentence: TRecEvent read fOnSen write fOnSen;
    property OnValidFix: TFixEvent read fonFix write fOnFix;
    property OnFixLoss: TNotifyEvent read fOnFixLoss write fOnFixLoss;
    property OnFixProgress: TProgEvent read fOnProg write fOnProg;
    property OnFixQuality: TQalEvent read fonQal write fOnQal;
    property OnError: TErrEvent read fOnErr write fOnErr;
    property OnComLoss: TNotifyEvent read fOnComLoss write fOnComLoss;
  end;

procedure Register;



                             IMPLEMENTATION

{$Include GPS2.inc}


constructor TGPS2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fApdComPort := TApdComPort.Create(Self);
  fApdComPort.Baud := 4800;
  fApdComPort.OnTriggerAvail := ApdComPortTriggerAvail;
  fTimeout := 3000;
  fTimer := TTimer.Create(Self);
  fTimer.Interval := fTimeOut;
  fTimer.OnTimer := ComTimedOut;
  fVersion := '1.0.0';
end;


destructor TGPS2.Destroy;
begin
  fApdComPort.Open := False;
  inherited Destroy;
end;


procedure TGPS2.ComTimedOut(Sender: TObject);
begin
  fTimer.Enabled := False;
  if Assigned(OnComLoss) then OnComLoss(Self);
end;


{A sentence can be accepted if it passes the Checksum test even if a fix is not
 valid because the GPS is most likely awaiting a fix.  When the fix is valid,
 additional validation of the data fields is enforced before the sentence is
 accepted. Nav parameters cannot be trusted until the fix is valid }

function TGPS2.Accepted(const sNmea: string): Boolean;
var OldProgIdx, OldQalIdx: Integer; OldValid: Boolean;
    sId: string;
begin
  Result := True;
  fTimer.Enabled := False;                // Reset the ComTimeOut timer
  fTimer.Enabled := True;
  OldProgIdx := fFixProgIdx;              // To determine if fix progress
  OldQalIdx := fFixQalIdx;                // or fix quality changed
  OldValid := fFixValid;
  if ChkValidNMEA(sNmea) then             // Basic test passed
    begin
      fNmeaSen := sNmea;
      A := Parse(fNmeaSen);
      sId := A[0];
      if sId = 'GPRMC' then               // Nav fields will be set
        Result := RMC;                    // Result true if processing was OK
      if sId = 'GPGSA' then               // otherwise set an error string
        Result := GSA;                    // and result is false
      if sId = 'GPGGA' then
        Result := GGA;
     end
  else
    begin
      fError := 'Checksum failed';        // Usually happens on startup
      Result := False;
    end;

  if OldValid and not fFixValid then
    begin
      if Assigned(OnFixLoss) then OnFixLoss(Self);
      if FixLossAlarm then SoundAlarm;
    end;

  if (Result = False) then
    begin
      if Assigned(OnError) then OnError(Self, fError);
      if fBeep then Beep;
    end;  

  if Assigned(OnSentence) and (Result = True) then
    OnSentence(Self, sId, A);

  if Assigned(OnValidFix) and (sID = 'GPRMC') and (fFixValid) then
    OnValidFix(Self, LatInPosUnits, LonInPosUnits, SOGInUnits, fCOG);

  if Assigned(OnFixProgress) and (OldProgIdx <> fFixProgIdx) then
    OnFixProgress(Self, FixProgress(fFixProgIdx), fFixProgIdx);

  if Assigned(OnFixQuality) and (OldQalIdx <> fFixQalIdx) then
    OnFixQuality(Self, FixQuality(fFixQalIdx), fFixQalIdx);
end;


procedure TGPS2.ApdComPortTriggerAvail(CP: TObject; Count: Word);
var
  n: Word;
  C: Char;
begin
  for n := 1 to Count do
    begin
      C := fApdComPort.GetChar;
      if C = '$' then fMsgBuffer := '';
      if C = #10 then Continue;
      if C = #13 then
        Accepted(fMsgBuffer)
      else
        fMsgBuffer := fMsgBuffer + C;
    end;
end;


function TGPS2.SetSysClock: Boolean;       // System clock keeps UTC
var
  WinTimeRec: TSystemTime;
begin
  Result := False;
  if not fFixValid then Exit;
  DateTimeToSystemTime(fDateTime, WinTimeRec);
  Result := SetSystemTime(WinTimeRec);
end;


procedure TGPS2.SendStr(const s: string);
begin
  with fApdComPort do
    if Open then PutString(s);
end;


function TGPS2.GetComNumber: Word;
begin  Result := fApdComPort.ComNumber  end;


procedure TGPS2.SetComNumber(const NewComNum: word);
var
  WasOpen: Boolean;
begin    
  with fApdComPort do
    begin
      if ComNumber = NewComNum then Exit;
      WasOpen := Open;
      if WasOpen then Open := False;
      ComNumber := NewComNum;
      if WasOpen then Open := True;
    end;
end;


function TGPS2.GetBaud: Integer;
begin  Result := fApdComPort.Baud  end;


procedure TGPS2.SetBaud(const NewBaud: Integer);
begin
  with fApdComPort do
   if (Baud <> NewBaud) then Baud := NewBaud;
end;


function TGPS2.GetOpen: Boolean;
begin  Result := fApdComPort.Open  end;


procedure TGPS2.SetOpen(const Open: Boolean);
begin
  if (fApdComPort.Open <> Open) then
    fApdComPort.Open := Open;
end;


procedure TGPS2.SetTimeOut(const Interval: Integer);
begin
  fTimeOut := Interval;
  fTimer.Interval := fTimeOut;
end;


procedure TGPS2.SetVersion(const Version: string);
begin   { Do Nothing }  end;


function TGPS2.LatInPosUnits: Double;
begin
  case fFloatUnits of
    Deg: Result := fLatInDeg;
    Min: Result := fLatInDeg*60;
    Sec: Result := fLatInDeg*3600;
  else
    Result := fLatInDeg*(pi/180);
  end;
end;


function TGPS2.LonInPosUnits: Double;
begin
  case fFloatUnits of
    Deg: Result := fLonInDeg;
    Min: Result := fLonInDeg*60;
    Sec: Result := fLonInDeg*3600;
  else
    Result := fLonInDeg*(pi/180);
  end;
end;


function TGPS2.LatInStrFmt: string;
begin
  if fFixValid then
    Result := CoordinateStr(Ord(fStrFormat), fLatInDeg*3600, tLat)
  else
    Result := '--';
end;


function TGPS2.LonInStrFmt: string;
begin
  if fFixValid then
    Result := CoordinateStr(Ord(fStrFormat), fLonInDeg*3600, tLon)
  else
    Result := '--';
end;


function TGPS2.SOGInUnits: Double;
begin
  case fUnits of
    Statute: Result := fSOG * 1.150779;
    Metric : Result := fSOG * 1.852000;
  else
    Result := fSOG;                       // Nautical
  end;
end;


function TGPS2.AltInUnits: Double;
begin
  if (fAltUnits = 'M') and (fUnits = Metric) then
    Result := fAltitude
  else
    Result := fAltitude*3.2808;
end;


function TGPS2.FixSatSet: TPrnSet;
begin  Result := fFixPrnSet  end;


procedure TGPS2.GDOP(out HDOP, VDOP, PDOP: Double);
begin
  HDOP := fHDOP;
  VDOP := fVDOP;
  PDOP := fPDOP;
end;


procedure register;
begin
  RegisterComponents('Additional', [TGPS2]);
  //RegisterPropertyEditor(TypeInfo(Integer), TGPS, 'ComBaud', TBaudRateProperty);
end;

end.  // GPS Component




// Notes:
//  Last modified -- 21 Sept 2006

//  Properties load from form in declared order so ComNumber must precede
//  ComOpen for PromptForPort to work properly
