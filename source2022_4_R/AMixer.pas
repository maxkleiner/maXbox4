unit AMixer;

//  NO! (nearly impossible) : Support for control on/off (alternative for mute)
//    - this is present on Audigy 2 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  MMSystem;

(*
 * TAudioMixer v1.70 (FREEWARE component)
 * -----------------
 * Released 6 Jun 2005
 *
 * This component can cache data from audio mixer. It has direct support for
 * getting/setting volume of any control (It can set also set state of that
 * "Selected" CheckBox in standard Windows Volume Control program). You can
 * better use other features of mixer, but that's more difficult than volume
 * setting and you must know something about audio mixer.
 *
 * The mixer has following structure (as it is in this component) :
 *
 * Destinations (destinations should be for example: Playback, Recording and Voice commands)
 *   |
 *   |--Destination[0]        (if you want to get volume of this call GeVolume (<ThisDestinationNum>,-1,...))
 *   |    |                                                                          (=0)           ----
 *   |    |--Data:TMixerLine
 *   |    |--Controls         (controls of the line, ex: Master volume, master mute)
 *   |    |    |
 *   |    |    |--Control[0]
 *   |    |    |--Control[1]
 *   |    |    |--Control[..]
 *   |    |
 *   |    |--Connections      (ex: Wave, MIDI, CD Audio, Line-In,...)
 *   |         |
 *   |         |--Connection[0]   (GetVolume (<ThisDestinationNum>,<ThisConnectionNum>,...))
 *   |         |    |                               (=0)                 (=0)
 *   |         |    |--Data:TMixerLine
 *   |         |    |--Controls   (here can be volume and mute)
 *   |         |         |
 *   |         |         |--Control[0]
 *   |         |         |--Control[1]
 *   |         |         |--Control[..]
 *   |         |
 *   |         |--Connection[1]
 *   |         |--Connection[..]
 *   |
 *   |--Destination[1]
 *   |--Destination[..]
 *
 *
 * There are many types of controls - checkbox, list, slider,... they are
 * described in Windows help. Common ones are volume slider, mute checkbox or
 * volume meter.
 *
 * This component is universal, so you can work with all controls through it,
 * but this is difficult. You can simply get/set volume level by procedures
 * GetVolume or SetVolume (description is near their declaration; use - see
 * example program).
 *
 *
 * What's New
 * ----------
 * 1.70 (6 Jun 2005)
 *      - fix: In the GetPeak method the allocated memory doesn't get released if the soundcard
 *        doesn't support peak levels.
 *        (by Thaddy de Koning - http://members.chello.nl/t.koning8/kolindex.htm )
 *      - new : Example now shows if connection is stereo or mono
 *      - fix: Problem with connections that have both "mute" and "selected" control, for example
 *        Conexant AMC Audio. Now the "selected" control is preffered over "mute", which
 *        is the opposite behaviour when compared to the previous version.
 *        Hopefully it will still work on other soundcards :-)
 *        (big thanks to Mike Versteeg, again :-) )
 * 1.60 (18 Nov 2001)
 *      - destinations will not be nil, when there is no mixer in the system
 *        (Mike Versteeg)
 *      - if mixerOpen function fails, it will try to call it again without
 *        (not needed) MIXER_OBJECTF_MIXER flag and if this will not work either,
 *        the component will call it once more without setting callback
 *        (we will lose [volume,...] change notification, but at least there
 *        is a possibility that it will work)
 *        (Mike Versteeg)
 *      - stereo mute is now working correctly (this was often problem
 *        on Windows XP) (Big thanks to Miroslav Flesko and several users of his
 *        program Radiator who informed me about an error and then helped me
 *        to find the solution)
 * 1.51 (6 May 2001)
 *      - corrected problem with infinite cycle and many small bugs,
 *        which could cause to report some control as "without mute"
 *        although they have it (this bug probably arose when
 *        I tried to correct SetVolume, GetVolume, ...)
 * 1.50 (not released, I knew there were some errors)
 *      - corrected SetVolume, GetVolume, SetMute, GetMute
 *      - added parameter in GetVolume - MuteIsSelect (by Ing. Ladislav Dolezel)
 * 1.43 (23 Oct 2000)
 *      - changes in example - now it fully supports multiple sound cards
 *        and it has better bass/treble dialog (by Hans-Georg Joepgen)
 * 1.42 (16 Oct 2000)
 *      - example corrections (there was an exception when closing Form4 and
 *        wrong text on one of the buttons) (by Hans-Georg Joepgen)
 * 1.41 (12 Jul 2000)
 *      - the component is more safe (you can query for destination
 *        number 100000 and you will receive nil insead of exception :-) )
 *        (by Sergey Kuzmin)
 *      - specifying wrong mixer number will cause procedure SetMixerID to fail
 *        instead finding nearest mixer
 *        (also thanks goes to Sergey Kuzmin)
 * 1.4  (2 Jun 2000)
 *      - added some examples
 *      - great improvements by Fabrice Fouqet :
 *          - added properties FDriverVersion, FManufacturer, FProductId,
 *            FNumberOfLine and FProductName
 *          - added functions GetMute/SetMute and GetPeak
 *          - changed function GetVolume (also returns if selected control
 *            is stereo or mono)
 * 1.16 (20 May 1999)
 *      - made compatible with Delphi 2.0 (this was done by Tom Lisjac)
 * 1.15 (17 May 1999)
 *      - corrected "Windows couldn't be shut down while TAudioMixer is being used" problem
 *            (many thanks to Jean Carlo Solis Ubago, who fixed this)
 *      - added example showing how to set bass / treble
 * 1.12 (24 Mar 1999)
 *      - corrected setting "selected" state
 * 1.11 (4 Jan 1999)
 *      - now it supports also MIXERCONTROL_CONTROLTYPE_MUX flag
 *        (I got SB Live! for Christmas (:-)) and my component didn't work
 *         properly, this corrects that problem)
 * 1.1  (16 Nov 1998)
 *      - made compatible with Delphi 4
 *      - corrected memory leaks (by Ishida Wataru)
 *      - some another minor changes (by Ishida Wataru)
 *      - added another example
 *      - added AMixer.dcr
 * 1.0  (18 Aug 1998)
 *      - initial version
 *
 *
 * You can use this component freely in your programs. But if you do so, please
 * send me an e-mail. I would like to know if it is useful.
 *
 * (C) Vit Kovalcik
 *
 * e-mail: vit.kovalcik@volny.cz
 * WWW: http://www.fi.muni.cz/~xkovalc
 * (if it will not work try http://www.geocities.com/vkovalcik )
 *)


type
  TAudioMixer=class;

  TPListFreeItemNotify=procedure (Pntr:Pointer) of object;
  TMixerChange=procedure (Sender:TObject;MixerH:HMixer;ID:Integer) of object;
    {MixerH is handle of mixer, which sent this message.
     ID is ID of changed item (line or control).}

  TPointerList=class(TObject)
  private
    FOnFreeItem:TPListFreeItemNotify;
    Items:Tlist;
  protected
    function GetPointer (Ind:Integer):Pointer;
    function GetCount :integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add (Pntr:Pointer);
    property Count:Integer read GetCount;
    property Pointer[Ind:Integer]:Pointer read GetPointer; default;
    property OnFreeItem:TPListFreeItemNotify read FOnFreeItem write FOnFreeItem;
  end;

  TMixerControls=class(TObject)
  private
    heap:pointer;
    FControls:TPointerList;
  protected
    function GetControl (Ind:Integer):PMixerControl;
    function GetCount:Integer;
  public
    constructor Create (AMixer:TAudioMixer; AData:TMixerLine);
    destructor Destroy; override;
    property Control[Ind:Integer]:PMixerControl read GetControl; default;
    property Count:Integer read GetCount;
  end;

  TMixerConnection=class(TObject)
  private
    XMixer:TAudioMixer;
    FData:TMixerLine;
    FControls:TMixerControls;
  public
    constructor Create (AMixer:TAudioMixer; AData:TMixerLine);
    destructor Destroy; override;
    property Controls:TMixerControls read FControls;
    property Data:TMixerLine read FData;
  end;

  TMixerConnections=class(TObject)
  private
    XMixer:TAudioMixer;
    FConnections:TPointerList;
  protected
    procedure DoFreeItem (Pntr:Pointer);
    function GetConnection (Ind:Integer):TMixerConnection;
    function GetCount:Integer;
  public
    constructor Create (AMixer:TAudioMixer; AData:TMixerLine);
    destructor Destroy; override;
    property Connection[Ind:Integer]:TMixerConnection read GetConnection; default;
    property Count:Integer read GetCount;
  end;

  TMixerDestination=class(TObject)
  private
    XMixer:TAudioMixer;
    FData:TMixerLine;
    FControls:TMixerControls;
    FConnections:TMixerConnections;
  public
    constructor Create (AMixer:TAudioMixer; AData:TMixerLine);
    destructor Destroy; override;
    property Connections:TMixerConnections read FConnections;
    property Controls:TMixerControls read FControls;
    property Data:TMixerLine read FData;
  end;

  TMixerDestinations=class(TObject)
  private
    FDestinations:TPointerList;
  protected
    function GetDestination (Ind:Integer):TMixerDestination;
    procedure DoFreeItem (Pntr:Pointer);
    function GetCount:Integer;
  public
    constructor Create (AMixer:TAudioMixer);
    destructor Destroy; override;
    property Count:Integer read GetCount;
    property Destination[Ind:Integer]:TMixerDestination read GetDestination; default;
  end;

  TAudioMixer = class(TComponent)
  private
    XWndHandle:HWnd;

    FDestinations:TMixerDestinations;
    FMixersCount:Integer;
    FMixerHandle:HMixer;
    FMixerId:Integer;
    FMixerCaps:TMixerCaps;
    FDriverVersion: MMVERSION;
    FManufacturer: String;
    FProductId: Word;
    FNumberOfLine: Integer;
    FProductName: String;
    FOnLineChange:TMixerChange;
    FOnControlChange:TMixerChange;
  protected
    procedure SetMixerId (Value:Integer);
    procedure MixerCallBack (var Msg:TMessage);
    procedure CloseMixer;
  published
    constructor Create (AOwner:TComponent); override;
    destructor Destroy; override;
    property DriverVersion: MMVERSION read FDriverVersion;
    property ProductId: WORD read FProductId;
    property NumberOfLine: Integer read FNumberOfLine;
    property Manufacturer: string read FManufacturer;
    property ProductName: string read FProductName;
    property MixerId:Integer read FMixerId write SetMixerId;
      {Opened mixer - value must be in range 0..MixersCount-1
       If no mixer is opened this value is  -1}
    property OnLineChange:TMixerChange read FOnLineChange write FOnLineChange;
    property OnControlChange:TMixerChange read FOnControlChange write FOnControlChange;
  public
    function GetVolume (ADestination, AConnection:Integer; var LeftVol, RightVol, Mute:Integer; var Stereo, VolDisabled, MuteDisabled, MuteIsSelect:Boolean):Boolean;
      {This function return volume of selected Destination and Connection.
       ADestination must be from range 0..Destinations.Count-1
       AConnection must be in range 0..Destinations[ADestination].Connections.Count-1
       If you want to read master volume of some Destination, you have to
         set AConnection to -1.
       If LeftVol, RightVol or Mute is not supported by queried connection,
         it's return value will be -1.

       LeftVol and RightVol are in range 0..65536

       If Mute is non-zero then the connection is silent (or vice-versa - see MuteIsSelect parameter)
       If specified line is recording source then Mute specifies if programs will
         record from this connection (it is copy of "Select" Checkbox in
         standard Windows Volume Control program)
       Stereo is true, then this control is stereo.
       VolDisabled or MuteDisabled is True when you cannot apply settings to this
         control (but can read it).
       MuteIsSelect returns True is "mute" work here as select - opposite of mute.

       Return value of the function is True if no error has occured,
         otherwise it returns False.}
    function SetVolume (ADestination, AConnection:Integer; LeftVol, RightVol, Mute:Integer):Boolean;
      {This function sets volume.
       If you set RightVol to -1 and connection is stereo then LeftVol will be
         copied to RightVol.
       If LeftVol or Mute is -1 then this value will not be set.
       Note that "Mute" can be "select" (which is reversed mute) - see function
         GetVolume, parameter MuteIsSelect.

       Return value is True if ADestination and AConnection are correct, otherwise False.}

    function GetPeak(ADestination, AConnection:Integer; var LeftPeak, RightPeak:Integer):Boolean;
    function GetMute(ADestination, AConnection:Integer; var Mute:Boolean):Boolean;
    function SetMute(ADestination, AConnection:Integer; Mute:Boolean):Boolean;

    property Destinations:TMixerDestinations read FDestinations;
      {Ind must be in range 0..DestinationsCount-1}
    property MixerCaps:TMixerCaps read FMixerCaps;
    property MixerCount:Integer read FMixersCount;
      {Number of mixers present in system; mostly 1}
    property MixerHandle:HMixer read FMixerHandle;
      {Handle of opened mixer}
  end;

procedure Register;

implementation

{------------}
{TPointerList}
{------------}

constructor TPointerList.Create;
begin
  Items := TList.Create;
end;

destructor TPointerList.Destroy;
begin
  Clear;
  Items.Free;
end;

procedure TPointerList.Add (Pntr:Pointer);
begin
  Items.Add (Pntr);
end;

function TPointerList.GetPointer (Ind:Integer):Pointer;
begin
  Result := nil;
  If (Ind < Count) then
    Result := Items[Ind];
end;

procedure TPointerList.Clear;
var I:Integer;
begin
  for I := 0 to Items.Count-1 do begin
    If Assigned (FOnFreeItem) then
      FOnFreeItem (Items[I])
  end;
  Items.Clear;
end;

function TPointerList.GetCount:Integer;
begin
  Result := Items.Count;
end;

{--------------}
{TMixerControls}
{--------------}

constructor TMixerControls.Create (AMixer:TAudioMixer; AData:TMixerLine);
var MLC:TMixerLineControls;
    A,B:Integer;
    P:PMixerControl;
begin
  FControls := TPointerList.Create;
  GetMem (P, SizeOf(TMixerControl)*AData.cControls);
  heap := P;
  MLC.cbStruct := SizeOf(MLC);
  MLC.dwLineID := AData.dwLineID;
  MLC.cbmxctrl := SizeOf(TMixerControl);
  MLC.cControls := AData.cControls;
  MLC.pamxctrl := P;
  A := MixerGetLineControls(AMixer.MixerHandle, @MLC, MIXER_GETLINECONTROLSF_ALL);
  If A = MMSYSERR_NOERROR then
  begin
    For B := 0 to AData.cControls-1 do
    begin
      FControls.Add (P);
      P := PMixerControl (DWORD(P) + sizeof (TMixerControl));
    end;
  end;
end;

destructor TMixerControls.Destroy;
begin
  FControls.free;
  freemem(heap);
  inherited;
end;

function TMixerControls.GetControl (Ind:Integer):PMixerControl;
begin
  Result := FControls.Pointer[Ind];
end;

function TMixerControls.GetCount:Integer;
begin
  Result := FControls.Count;
end;

{----------------}
{TMixerConnection}
{----------------}

constructor TMixerConnection.Create (AMixer:TAudioMixer; AData:TMixerLine);
begin
  FData := AData;
  XMixer := AMixer;
  FControls := TMixerControls.Create (AMixer, AData);
end;

destructor TMixerConnection.Destroy;
begin
  FControls.Free;
  inherited;
end;

{-----------------}
{TMixerConnections}
{-----------------}

constructor TMixerConnections.Create (AMixer:TAudioMixer; AData:TMixerLine);
var A,B:Integer;
    ML:TMixerLine;
begin
  XMixer := AMixer;
  FConnections := TPointerList.Create;
  FConnections.OnFreeItem := Dofreeitem;
  ML.cbStruct := SizeOf(TMixerLine);
  ML.dwDestination := AData.dwDestination;
  For A := 0 to AData.cConnections-1 do
  begin
    ML.dwSource := A;
    B := MixerGetLineInfo (AMixer.MixerHandle, @ML, MIXER_GETLINEINFOF_SOURCE);
    If B = MMSYSERR_NOERROR then
      FConnections.Add (Pointer(TMixerConnection.Create (XMixer, ML)));
  end;
end;

destructor TMixerConnections.Destroy;
begin
  FConnections.Free;
  inherited;
end;

procedure TMixerConnections.DoFreeItem (Pntr:Pointer);
begin
  TMixerConnection(Pntr).Free;
end;

function TMixerConnections.GetConnection (Ind:Integer):TMixerConnection;
begin
  Result := FConnections.Pointer[Ind];
end;

function TMixerConnections.GetCount:Integer;
begin
  Result := FConnections.Count;
end;

{-----------------}
{TMixerDestination}
{-----------------}

constructor TMixerDestination.Create (AMixer:TAudioMixer; AData:TMixerLine);
begin
  FData := AData;
  XMixer := AMixer;
  FConnections := TMixerConnections.Create (XMixer, FData);
  FControls := TMixerControls.Create (XMixer, AData);
end;

destructor TMixerDestination.Destroy;
begin
  Fcontrols.Free;
  FConnections.Free;
  inherited;
end;

{------------------}
{TMixerDestinations}
{------------------}

constructor TMixerDestinations.Create (AMixer:TAudioMixer);
var A,B:Integer;
    ML:TMixerLine;
begin
  FDestinations := TPointerList.Create;
  FDestinations.OnFreeItem := DoFreeItem;
  if (AMixer = nil) then
    Exit;
  For A := 0 to AMixer.MixerCaps.cDestinations-1 do
  begin
    ML.cbStruct := SizeOf(TMixerLine);
    ML.dwDestination := A;
    B := MixerGetLineInfo (AMixer.MixerHandle, @ML, MIXER_GETLINEINFOF_DESTINATION);
    If B = MMSYSERR_NOERROR then
      FDestinations.Add (Pointer(TMixerDestination.Create (AMixer, ML)));
  end;
end;

procedure TMixerDestinations.DoFreeItem (Pntr:Pointer);
begin
  TMixerDestination(Pntr).Free;
end;

destructor TMixerDestinations.Destroy;
begin
  FDestinations.Free;
  inherited;
end;

function TMixerDestinations.GetDestination (Ind:Integer):TMixerDestination;
begin
  Result := nil;
  If (Assigned (FDestinations)) then
    Result := FDestinations.Pointer[Ind];
end;

function TMixerDestinations.GetCount:Integer;
begin
  Result := FDestinations.Count;
end;

{-----------}
{TAudioMixer}
{-----------}

constructor TAudioMixer.Create (AOwner:TComponent);
begin
  inherited Create (AOwner);
  XWndHandle := AllocateHWnd (MixerCallBack);
  FMixersCount := mixerGetNumDevs;
  FMixerId := -1;
  if (FMixersCount = 0) then
    FDestinations := TMixerDestinations.Create (nil)
  else
  begin
    FDestinations := nil;
    SetMixerId (0);
  end;
end;

destructor TAudioMixer.Destroy;
begin
  CloseMixer;
  if XWndHandle <> 0 then
    DeAllocateHwnd (XWndHandle);
  inherited;
end;

procedure TAudioMixer.CloseMixer;
begin
  If FMixerId >= 0 then
  begin
    mixerClose (FMixerHandle);
    FMixerId := -1;
  end;
  FDestinations.Free;
  FDestinations := nil;
end;

procedure TAudioMixer.SetMixerId (Value:Integer);
label AllOK;
begin
  If (Value < 0) OR (Value >= FMixersCount) then
    Exit;
  CloseMixer;

  If mixerOpen (@FMixerHandle, Value, XWndHandle, 0, CALLBACK_WINDOW OR MIXER_OBJECTF_MIXER) = MMSYSERR_NOERROR then
    goto AllOK;

  // we will go here very rarely, but sometimes it could help 
  If mixerOpen (@FMixerHandle, Value, XWndHandle, 0, CALLBACK_WINDOW) = MMSYSERR_NOERROR then
    goto AllOK;
  If mixerOpen (@FMixerHandle, Value, 0, 0, 0) = MMSYSERR_NOERROR then
    goto AllOK;

  // an error has occured
  FMixerId := -1;
  FDestinations := TMixerDestinations.Create (nil);

  Exit;

AllOK:
  FMixerId := Value;
  mixerGetDevCaps (MixerId, @FMixerCaps, SizeOf (TMixerCaps));

  if FMixerCaps.wMid = MM_MICROSOFT then
    FManufacturer := 'Microsoft'
  else
    FManufacturer := IntToStr(FMixerCaps.wMid) + ' = Unknown';
  FDriverVersion := FMixerCaps.vDriverVersion;
  FProductId := FMixerCaps.wPid;
  FProductName := StrPas(FMixerCaps.szPName);
  FNumberOfLine := FMixerCaps.cDestinations;

  FDestinations := TMixerDestinations.Create (Self);
end;

procedure TAudioMixer.MixerCallBack (var Msg:TMessage);
begin
  case Msg.Msg of
    MM_MIXM_LINE_CHANGE:
        If Assigned (OnLineChange) then
          OnLineChange (Self, Msg.wParam, Msg.lParam);
    MM_MIXM_CONTROL_CHANGE:
        If Assigned (OnControlChange) then
          OnControlChange (Self, Msg.wParam, Msg.lParam);
    else
      Msg.Result := DefWindowProc (XWndHandle, Msg.Msg, Msg.WParam, Msg.LParam);
  end;
end;


const MIXER_LONG_NAME_CHARS = 64;

type MIXERCONTROLDETAILS_LISTTEXT = record
       dwParam1:DWORD;
       dwParam2:DWORD;
       szName:Array [0..MIXER_LONG_NAME_CHARS-1] of Char;
     end;

type ListTextArray = array [0..1000] of MIXERCONTROLDETAILS_LISTTEXT;

function TAudioMixer.GetVolume (ADestination,AConnection:Integer;var LeftVol, RightVol, Mute:Integer;var Stereo, VolDisabled, MuteDisabled, MuteIsSelect:Boolean):Boolean;
var MD:TMixerDestination;
    MC:TMixerConnection;
    Cntrls:TMixerControls;
    MCD:TMixerControlDetails;
    Cntrl:PMixerControl;
    A,B:Integer;
    ML:TMixerLine;
    details:array [0..100] of Integer;
    ltext:^ListTextArray;
    MCDText:TMixerControlDetails;

begin
  Result := False;
  If (not Assigned (FDestinations)) then
    Exit;
  Stereo := False;
  MuteDisabled := True;
  VolDisabled := True;
  LeftVol := -1;
  RightVol := -1;
  Mute := -1;
  MuteIsSelect := False;
  MD := Destinations[ADestination];
  MC := nil;
  If AConnection <> -1 then
    MC := MD.Connections[AConnection];




  If MD <> nil then
  begin



    Result := True;


//      If Mute = -1 then
    begin
      If AConnection <> -1 then
      begin
        Cntrls := MD.Controls;
        ML := MD.Data;
        If (MC <> nil) AND (Cntrls <> nil) then
        begin
          A := 0;
          while (Mute = -1) AND (A < Cntrls.Count) do
          begin
            Cntrl := Cntrls[A];
//              If (Cntrl.dwControlType AND MIXERCONTROL_CONTROLTYPE_MIXER = MIXERCONTROL_CONTROLTYPE_MIXER) OR
//                 (Cntrl.dwControlType AND MIXERCONTROL_CONTROLTYPE_MUX = MIXERCONTROL_CONTROLTYPE_MUX) then

//            If (Cntrl.dwControlType AND MIXERCONTROL_CT_CLASS_MASK = MIXERCONTROL_CT_CLASS_LIST) then

            If (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUX) then
               // Mux is similar to mixer, but only one line can be selected at a time
            begin
              MCD.cbStruct := SizeOf(TMixerControlDetails);
              MCD.dwControlID := Cntrl.dwControlID;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_UNIFORM > 0 then
                MCD.cChannels := 1
              else
                MCD.cChannels := ML.cChannels;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE = MIXERCONTROL_CONTROLF_MULTIPLE then
                MCD.cMultipleItems := Cntrl.cMultipleItems
              else
                MCD.cMultipleItems := 0;
              MCD.cbDetails := 4;
              MCD.paDetails := @Details;
              B := mixerGetControlDetails (FMixerHandle,@MCD,MIXER_GETCONTROLDETAILSF_VALUE);
              If B <> MMSYSERR_NOERROR then
              begin
                Inc (A);
                continue;
              end;

              MCDText.cbStruct := sizeof (MCDText);
              MCDText.dwControlID := Cntrl.dwControlID;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_UNIFORM > 0 then
                MCDText.cChannels := 1
              else
                MCDText.cChannels := ML.cChannels;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE = MIXERCONTROL_CONTROLF_MULTIPLE then
                MCDText.cMultipleItems := Cntrl.cMultipleItems
              else
                MCDText.cMultipleItems := 0;
              GetMem (ltext, MCDText.cChannels * MCDText.cMultipleItems * sizeof (MIXERCONTROLDETAILS_LISTTEXT));
              MCDText.cbDetails := sizeof (MIXERCONTROLDETAILS_LISTTEXT);
              MCDText.paDetails := ltext;
              B := mixerGetControlDetails (FMixerHandle, @MCDText, MIXER_GETCONTROLDETAILSF_LISTTEXT);
              If B <> MMSYSERR_NOERROR then
              begin
                FreeMem (ltext);
                Inc (A);
                continue;
              end;
              B := MCD.cChannels - 1;
              while (B < integer(MCD.cMultipleItems)) do
              begin
                if (ltext[B].dwParam1 = MC.Data.dwLineID) then
                  break;
                Inc (B, MCD.cChannels);
              end;
              FreeMem (ltext);

              If (B < integer (MCD.cMultipleItems)) then
              begin
                Mute := Details[B];
                MuteDisabled := Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_DISABLED > 0;
                MuteIsSelect := True;
                break;
              end;
            end;
            Inc (A);
          end;
        end;
      end;
    end;







    If AConnection = -1 then
    begin
      Cntrls := MD.Controls;
      ML := MD.Data;
    end
    else
    begin
      If MC <> nil then
      begin
        Cntrls := MC.Controls;
        ML := MC.Data;
      end
      else
        Cntrls := nil;
    end;
    If Cntrls <> nil then
    begin
      A := 0;
      while ((LeftVol = -1) OR (Mute = -1)) AND (A < Cntrls.Count) do
      begin
        Cntrl := Cntrls[A];
        If Cntrl <> nil then
        begin
          If ((Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME) OR
              ((Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE) AND (Mute = -1))) AND
             (Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE <> MIXERCONTROL_CONTROLF_MULTIPLE)
             then
          begin
            if (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE) then
              MCD.cbStruct := SizeOf(TMixerControlDetails)
            else
              MCD.cbStruct := SizeOf(TMixerControlDetails);
            MCD.dwControlID := Cntrl.dwControlID;
            If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_UNIFORM > 0 then
              MCD.cChannels := 1
            else
              MCD.cChannels := ML.cChannels;
            MCD.cMultipleItems := 0;
            MCD.cbDetails := SizeOf(Integer);
            MCD.paDetails := @details;
            B := mixerGetControlDetails (FMixerHandle, @MCD, MIXER_GETCONTROLDETAILSF_VALUE);
            If B = MMSYSERR_NOERROR then
            begin
              If (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME) AND (LeftVol = -1) then
              begin
                VolDisabled := Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_DISABLED > 0;
                LeftVol := details[0];
                If MCD.cChannels > 1 then
                begin
                  RightVol := Details[1];
                  Stereo := True;
                end
                else
                  RightVol := LeftVol;
              end
              else If (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE) AND (Mute = -1) then
              begin
                MuteDisabled := Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_DISABLED > 0;
                If Details[0] <> 0 then
                  Mute := 1
                else
                  Mute := 0;
              end
// NEW ->
(*              else If (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_ONOFF) AND (Mute = -1) then
              begin
                MuteDisabled := Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_DISABLED > 0;
                If Details[0] <> 0 then
                  Mute := 1
                else
                  Mute := 0;
                MuteIsSelect := True;
              end;*)
// <- NEW
            end;
          end;
        end;
        Inc (A);
      end;

{      If LeftVol = -1 then
        VolDisabled := True;
      If Mute = -1 then
        MuteDisabled := True;}
    end;
  end;
end;

function TAudioMixer.SetVolume (ADestination, AConnection:Integer; LeftVol, RightVol, Mute:Integer):Boolean;
var MD:TMixerDestination;
    MC:TMixerConnection;
    Cntrls:TMixerControls;
    MCD:TMixerControlDetails;
    Cntrl:PMixerControl;
    A,B:Integer;
    ML:TMixerLine;
    details:array [0..100] of Integer;
    VolSet,MuteSet:Boolean;
    ltext:^ListTextArray;
    MCDText:TMixerControlDetails;
begin
  Result := False;
  If (not Assigned (FDestinations)) then
    Exit;
  MC := nil;
  MD := Destinations[ADestination];
  If MD <> nil then
  begin
    If AConnection <> -1 then
      MC := MD.Connections[AConnection];


    VolSet := LeftVol = -1;
    MuteSet := Mute = -1;
    Result := True;


    If not MuteSet then
    begin
      If AConnection <> -1 then
      begin
        Cntrls := MD.Controls;
        ML := MD.Data;
        If (MC <> nil) AND (Cntrls <> nil) then
        begin
          A := 0;
          while not MuteSet AND (A < Cntrls.Count) do
          begin
            Cntrl := Cntrls[A];
            If (*(Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MIXER) OR*)
               (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUX) then
            begin
              MCD.cbStruct := SizeOf(TMixerControlDetails);
              MCD.dwControlID := Cntrl.dwControlID;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_UNIFORM > 0 then
                MCD.cChannels := 1
              else
                MCD.cChannels := ML.cChannels;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE = MIXERCONTROL_CONTROLF_MULTIPLE then
                MCD.cMultipleItems := Cntrl.cMultipleItems
              else
                MCD.cMultipleItems := 0;
              MCD.cbDetails := 4;
              MCD.paDetails := @Details;
              MuteSet := True;
              mixerGetControlDetails (FMixerHandle, @MCD, MIXER_GETCONTROLDETAILSF_VALUE);
              if (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUX) then
                For B := 0 to Cntrl.cMultipleItems-1 do
                  Details[B] := 0;

              GetMem (ltext, MCD.cChannels * MCD.cMultipleItems * sizeof (MIXERCONTROLDETAILS_LISTTEXT));
              MCDText.cbStruct := sizeof (MCDText);
              MCDText.dwControlID := Cntrl.dwControlID;
              MCDText.cChannels := MCD.cChannels;
              MCDText.cMultipleItems := MCD.cMultipleItems;
              MCDText.cbDetails := sizeof (MIXERCONTROLDETAILS_LISTTEXT);
              MCDText.paDetails := ltext;
              mixerGetControlDetails (FMixerHandle, @MCDText, MIXER_GETCONTROLDETAILSF_LISTTEXT);
              B := MCD.cChannels - 1;
              while (B < integer (MCD.cMultipleItems)) do
              begin
                if (ltext[B].dwParam1 = MC.Data.dwLineID) then
                  break;
                Inc (B, MCD.cChannels);
              end;
              FreeMem (ltext);

              If (B < integer (MCD.cMultipleItems)) then
              begin
                Details[B] := Mute;
                mixerSetControlDetails (FMixerHandle, @MCD, MIXER_GETCONTROLDETAILSF_VALUE);
                break;
              end;
            end;
            Inc (A);
          end;
        end;
      end;
    end;



    If AConnection = -1 then
    begin
      Cntrls := MD.Controls;
      ML := MD.Data;
    end
    else
    begin
      If MC <> nil then
      begin
        Cntrls := MC.Controls;
        ML := MC.Data;
      end
      else
        Cntrls := nil;
    end;
    If Cntrls <> nil then
    begin

      A := 0;
      while (not VolSet OR not MuteSet) AND (A < Cntrls.Count) do
      begin
        Cntrl := Cntrls[A];
        If Cntrl <> nil then
        begin
          If (((Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME) AND not VolSet) OR
              ((Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE) AND not MuteSet) (* NEW -> *) (*OR
              ((Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_ONOFF) AND not MuteSet)*) (* <- NEW *)) AND
             (Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE <> MIXERCONTROL_CONTROLF_MULTIPLE)
             then
          begin
            MCD.cbStruct := SizeOf(TMixerControlDetails);
            MCD.dwControlID := Cntrl.dwControlID;
            If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_UNIFORM > 0 then
              MCD.cChannels := 1
            else
              MCD.cChannels := ML.cChannels;
            MCD.cMultipleItems := 0;
            MCD.cbDetails := SizeOf(Integer);
            MCD.paDetails := @Details;
            If (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_VOLUME) then
            begin
              Details[0] := LeftVol;
              If RightVol = -1 then
                Details[1] := LeftVol
              else
                Details[1] := RightVol;
              VolSet := True;
            end
            else if ((Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUTE) (* NEW -> *) (* OR
                     (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_ONOFF) *) (* <- NEW *)) then
            begin
              For B := 0 to MCD.cChannels - 1 do
                Details[B] := Mute;
              MuteSet := True;
            end;
            mixerSetControlDetails (FMixerHandle, @MCD, MIXER_GETCONTROLDETAILSF_VALUE);
          end;
        end;
        Inc (A);
      end;

    end;
  end;
end;

function TAudioMixer.GetMute(ADestination, AConnection: Integer; var Mute: Boolean):Boolean;
var
  MD : TMixerDestination;
  MC : TMixerConnection;
  mlcMixerLineControlsMute : TMIXERLINECONTROLS;
  mcdMixerDataMute : TMIXERCONTROLDETAILS;
  pmcMixerControlMute : PMIXERCONTROL;
  pmcdsMixerDataUnsignedMute : PMIXERCONTROLDETAILSBOOLEAN;
  mlMixerLine : TMixerLine;
  Cntrl:PMixerControl;
  Cntrls:TMixerControls;
  ML:TMixerLine;
  A,B:Integer;
  details:array [0..100] of Integer;
  ltext:^ListTextArray;
  MCDText:TMixerControlDetails;
begin
  Result := False;
  If (not Assigned (FDestinations)) then
    Exit;
  MC := nil;
  Mute := False;
  MD := Destinations[ADestination];
  if MD <> nil then
  begin
    if AConnection = -1 then
      mlMixerLine := MD.Data
    else
    begin
      MC := MD.Connections[AConnection];
      if MC <> nil then
        mlMixerLine := MC.Data
      else
        Exit;
    end;

    GetMem(pmcMixerControlMute, SizeOf(TMIXERCONTROL));
    GetMem(pmcdsMixerDataUnsignedMute, SizeOf(TMIXERCONTROLDETAILSBOOLEAN));

    with mlcMixerLineControlsMute do
    begin
      cbStruct := SizeOf(TMIXERLINECONTROLS);
      dwLineID := mlMixerLine.dwLineID;
      dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
      cControls := 1;
      cbmxctrl := SizeOf(TMIXERCONTROL);
      pamxctrl := pmcMixerControlMute;
    end;

    if (mixerGetLineControls(FMixerHandle, @mlcMixerLineControlsMute, MIXER_GETLINECONTROLSF_ONEBYTYPE) = MMSYSERR_NOERROR) then
    begin
      with mcdMixerDataMute do
      begin
        cbStruct := SizeOf(TMIXERCONTROLDETAILS);
        dwControlID := pmcMixerControlMute^.dwControlID;
        cChannels := 1;
        cMultipleItems := 0;
        cbDetails := SizeOf(TMIXERCONTROLDETAILSBOOLEAN);
        paDetails := pmcdsMixerDataUnsignedMute;
      end;

      if mixerGetControlDetails(FMixerHandle, @mcdMixerDataMute, MIXER_GETCONTROLDETAILSF_VALUE) = MMSYSERR_NOERROR then
      begin
        Mute := pmcdsMixerDataUnsignedMute^.fValue = 1;
        Result := True;
      end;
    end
    else
    begin
      If (AConnection <> -1) then
      begin
        Cntrls := MD.Controls;
        ML := MD.Data;
        If (MC <> nil) AND (Cntrls <> nil) then
        begin
          A := 0;
          while (Result = False) AND (A < Cntrls.Count) do
          begin
            Cntrl := Cntrls[A];
            If (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MIXER) OR
               (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUX) then
            begin
              mcdMixerDataMute.cbStruct := SizeOf(TMixerControlDetails);
              mcdMixerDataMute.dwControlID := Cntrl.dwControlID;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_UNIFORM > 0 then
                mcdMixerDataMute.cChannels := 1
              else
                mcdMixerDataMute.cChannels := ML.cChannels;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE = MIXERCONTROL_CONTROLF_MULTIPLE then
                mcdMixerDataMute.cMultipleItems := Cntrl.cMultipleItems
              else
                mcdMixerDataMute.cMultipleItems := 0;
              mcdMixerDataMute.cbDetails := 4;
              mcdMixerDataMute.paDetails := @Details;
              mixerGetControlDetails (FMixerHandle, @mcdMixerDataMute, MIXER_GETCONTROLDETAILSF_VALUE);

              GetMem (ltext, mcdMixerDataMute.cChannels * mcdMixerDataMute.cMultipleItems * sizeof (MIXERCONTROLDETAILS_LISTTEXT));
              MCDText.cbStruct := sizeof (MCDText);
              MCDText.dwControlID := Cntrl.dwControlID;
              MCDText.cChannels := mcdMixerDataMute.cChannels;
              MCDText.cMultipleItems := mcdMixerDataMute.cMultipleItems;
              MCDText.cbDetails := sizeof (MIXERCONTROLDETAILS_LISTTEXT);
              MCDText.paDetails := ltext;
              mixerGetControlDetails (FMixerHandle, @MCDText, MIXER_GETCONTROLDETAILSF_LISTTEXT);
              B := mcdMixerDataMute.cChannels - 1;
              while (B < integer (mcdMixerDataMute.cMultipleItems)) do
              begin
                if (ltext[B].dwParam1 = MC.Data.dwLineID) then
                  break;
                Inc (B, mcdMixerDataMute.cChannels);
              end;
              FreeMem (ltext);

              If (B < integer (mcdMixerDataMute.cMultipleItems)) then
              begin
                Result := True;
                Mute := Details[B] <> 0;
                break;
              end;
            end;
            Inc (A);
          end;
        end;
      end;
    end;

    FreeMem(pmcdsMixerDataUnsignedMute);
    FreeMem(pmcMixerControlMute);
  end;
end;

function TAudioMixer.SetMute(ADestination, AConnection: Integer; Mute: Boolean):Boolean;
var
  MD : TMixerDestination;
  MC : TMixerConnection;
  mlcMixerLineControlsMute : TMIXERLINECONTROLS;
  mcdMixerDataMute : TMIXERCONTROLDETAILS;
  pmcMixerControlMute : PMIXERCONTROL;
  pmcdsMixerDataUnsignedMute : PMIXERCONTROLDETAILSBOOLEAN;
  mlMixerLine : TMixerLine;
  Cntrl:PMixerControl;
  Cntrls:TMixerControls;
  ML:TMixerLine;
  A,B:Integer;
  details:array [0..100] of Integer;
  ltext:^ListTextArray;
  MCDText:TMixerControlDetails;
begin
  Result := False;
  If (not Assigned (FDestinations)) then
    Exit;
  MC := nil;
  MD := Destinations[ADestination];
  if MD <> nil then
  begin
    if AConnection = -1 then
      mlMixerLine := MD.Data
    else
    begin
      MC := MD.Connections[AConnection];
      if MC <> nil then
        mlMixerLine := MC.Data
      else
        Exit;
    end;

    GetMem(pmcMixerControlMute, SizeOf(TMIXERCONTROL));
    GetMem(pmcdsMixerDataUnsignedMute, SizeOf(TMIXERCONTROLDETAILSBOOLEAN));

    with mlcMixerLineControlsMute do
    begin
      cbStruct := SizeOf(TMIXERLINECONTROLS);
      dwLineID := mlMixerLine.dwLineID;
      dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
      cControls := 0;
      cbmxctrl := SizeOf(TMIXERCONTROL);
      pamxctrl := pmcMixerControlMute;
    end;

    if (mixerGetLineControls(FMixerHandle, @mlcMixerLineControlsMute, MIXER_GETLINECONTROLSF_ONEBYTYPE) = MMSYSERR_NOERROR) then
    begin
      with mcdMixerDataMute do
      begin
        cbStruct := SizeOf(TMixerControlDetails);
        dwControlID := pmcMixerControlMute^.dwControlID;
        cChannels := 1;
        cMultipleItems := 0;
        cbDetails := SizeOf(TMIXERCONTROLDETAILSBOOLEAN);
        paDetails := pmcdsMixerDataUnsignedMute;
      end;

      if Mute then
        pmcdsMixerDataUnsignedMute^.fValue := 1
      else
        pmcdsMixerDataUnsignedMute^.fValue := 0;

      if (mixerSetControlDetails(FMixerHandle,@mcdMixerDataMute,MIXER_SETCONTROLDETAILSF_VALUE) = MMSYSERR_NOERROR) then
        Result := True;
    end
    else
    begin
      If (AConnection <> -1) then
      begin
        Cntrls := MD.Controls;
        ML := MD.Data;
        If (MC <> nil) AND (Cntrls <> nil) then
        begin
          A := 0;
          while (Result = False) AND (A < Cntrls.Count) do
          begin
            Cntrl := Cntrls[A];
            If (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MIXER) OR
               (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUX) then
            begin
              mcdMixerDataMute.cbStruct := SizeOf(TMixerControlDetails);
              mcdMixerDataMute.dwControlID := Cntrl.dwControlID;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_UNIFORM > 0 then
                mcdMixerDataMute.cChannels := 1
              else
                mcdMixerDataMute.cChannels := ML.cChannels;
              If Cntrl.fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE = MIXERCONTROL_CONTROLF_MULTIPLE then
                mcdMixerDataMute.cMultipleItems := Cntrl.cMultipleItems
              else
                mcdMixerDataMute.cMultipleItems := 0;
              mcdMixerDataMute.cbDetails := 4;
              mcdMixerDataMute.paDetails := @Details;
              if (mixerGetControlDetails (FMixerHandle, @mcdMixerDataMute, MIXER_GETCONTROLDETAILSF_VALUE) <> MMSYSERR_NOERROR) then
              begin
                Inc (A);
                continue;
              end;
              if (Cntrl.dwControlType = MIXERCONTROL_CONTROLTYPE_MUX) then
                For B := 0 to Cntrl.cMultipleItems-1 do
                  Details[B] := 0;
              If Mute then
              begin
                GetMem (ltext, mcdMixerDataMute.cChannels * mcdMixerDataMute.cMultipleItems * sizeof (MIXERCONTROLDETAILS_LISTTEXT));
                MCDText.cbStruct := sizeof (MCDText);
                MCDText.dwControlID := Cntrl.dwControlID;
                MCDText.cChannels := mcdMixerDataMute.cChannels;
                MCDText.cMultipleItems := mcdMixerDataMute.cMultipleItems;
                MCDText.cbDetails := sizeof (MIXERCONTROLDETAILS_LISTTEXT);
                MCDText.paDetails := ltext;
                mixerGetControlDetails (FMixerHandle, @MCDText, MIXER_GETCONTROLDETAILSF_LISTTEXT);
                B := mcdMixerDataMute.cChannels - 1;
                while (B < integer (mcdMixerDataMute.cMultipleItems)) do
                begin
                  if (ltext[B].dwParam1 = MC.Data.dwLineID) then
                    break;
                  Inc (B, mcdMixerDataMute.cChannels);
                end;
                FreeMem (ltext);

                If (B < integer (mcdMixerDataMute.cMultipleItems)) then
                  Details[B] := 1;
              end;
              if (mixerSetControlDetails (FMixerHandle, @mcdMixerDataMute, MIXER_GETCONTROLDETAILSF_VALUE) = MMSYSERR_NOERROR) then
              begin
                Result := True;
                break;
              end;
            end;
            Inc (A);
          end;
        end;
      end;
    end;

    FreeMem(pmcdsMixerDataUnsignedMute);
    FreeMem(pmcMixerControlMute);
  end;
end;


function TAudioMixer.GetPeak (ADestination, AConnection:Integer; var LeftPeak, RightPeak:Integer): Boolean;
var
  MD : TMixerDestination;
  MC : TMixerConnection;
  mcdMixerDataPeak : TMIXERCONTROLDETAILS;
  pmcMixerControlPeak : PMIXERCONTROL;
{  pmcdsMixerDataSignedPeak : PMIXERCONTROLDETAILSSIGNED;}
  mlMixerLine : TMixerLine;
  A:Integer;
  Cntrls:TMixerControls;
  Details:Array [1..100] of Integer;
begin
  Result := False;
  If (not Assigned (FDestinations)) then
    Exit;
  LeftPeak := 0;
  RightPeak := 0;
  MD := Destinations[ADestination];
  if MD <> nil then
  begin
    if AConnection = -1 then
    begin
      mlMixerLine := MD.Data;
      Cntrls := MD.Controls;
    end
    else
    begin
      MC := MD.Connections[AConnection];
      if MC <> nil then
      begin
        mlMixerLine := MC.Data;
        Cntrls := MC.Controls;
      end
      else
        Exit;
    end;

    GetMem(pmcMixerControlPeak, SizeOf(TMIXERCONTROL));

    A := 0;
    while (A < Cntrls.Count) do
    begin
      If (Cntrls[A].dwControlType AND MIXERCONTROL_CT_CLASS_MASK) = MIXERCONTROL_CT_CLASS_METER then
        break;
      Inc (A);
    end;
    If A = Cntrls.Count then
    begin
      FreeMem(pmcMixerControlPeak);
      Exit;
    end;

    with mcdMixerDataPeak do
    begin
      cbStruct := SizeOf(TMIXERCONTROLDETAILS);
      dwControlID := Cntrls[A].dwControlID;
      cChannels := mlMixerLine.cChannels;
      If (Cntrls[A].fdwControl AND MIXERCONTROL_CONTROLF_MULTIPLE) = MIXERCONTROL_CONTROLF_MULTIPLE then
        cMultipleItems:=Cntrls[A].cMultipleItems
      else
        cMultipleItems:=0;
      cbDetails := SizeOf(TMIXERCONTROLDETAILSSIGNED);
      paDetails := @Details;
    end;

    if (mixerGetControlDetails(FMixerHandle,@mcdMixerDataPeak,MIXER_GETCONTROLDETAILSF_VALUE) = MMSYSERR_NOERROR) then
    begin
      LeftPeak := Details[1];
      if mlMixerLine.cChannels = 2 then
        RightPeak := Details[2]
      else
        RightPeak := LeftPeak;
      Result := True;
    end;

    FreeMem(pmcMixerControlPeak);
   end;
end;

procedure Register;
begin
  //RegisterComponents('Samples', [TAudioMixer]);
end;

end.
