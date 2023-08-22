unit DD83u1;

(*Written with Delphi7

  See "if (sTmp<>'h') and.." for a bug to chase.


  DD83 derived from DD82
  Complements Arduino program "SerialArdAsSlave2"

DD82 derived from DD81.

DD81 derived from DD80, from which many rems may remain.
DD81 done with Delphi 7. Note that the 3rd party .dll "Inpout32"
is not used by either.

If you are merely looking for a Windows freeware "Hyperterminal"
replacement, have a look at PuTTY.exe. There's more on that
and other good Windows stuff at....

http://www.arunet.co.uk/tkboyd/hh.htm




Make note in Tuts for DD80 and DD81 (Dt4q and DT4r respectively) that
"Cannot open port" can arise merely because someone else is
already using it... PuTTY, for instance, if you've been using
that to see what Arduino is sending?

*)

(*DD81 dervied from DD80, which was
an extension of DD55, which is subject of DT4k. In DD55,
we can send to a serial device from Delphi. Now we're
trying to add reading incoming serial data, too.

DD80, ver 2 Apr 10, was developed under Delphi 4, using XP.

DD55 elements tested in early Apr 2010, using Windows XP and Delphi4.
Worked fine to send text to an Arduino. See....
http://sheepdogguides.com/arduino/art4SeIntro.htm
or...
http://sheepdogguides.com/arduino/ahttoc.htm
(Probably in "Level 4" for more information on the
Arduino end of things.)

Original simple-minded premise of DD55 to DD80 flawed... I'd hoped I
could open the port once, and then do a mixture of reads and writes.

Problem still "exists" in DD81, but I think I've worked around it...
somewhat.

Turns out I either have to master multiple threads, or keep closing
and opening the port, for read and for write, by turns. Sigh.

Thus, in DD80 & DD18, there is no "Open Connection" button.

In DD80, the SendHello, SendBye routines have had "open the connection"
and, afterwards, "close" it built into them. DD81 may do similar, or
take different tack. <<QEDIT

Even that wasn't a satisfactory answer... either the system wasn't
watching for input when the handle wasn't open for read, or it flushes
the buffers when it is opened, so went to Plan C....

Open port for read when program boots.

Build into every write....

   1)close port for read
   2)Re-open for write
   3)Do writing
   4)Close port for write
   5)Reopen for read, and leave like that.

(I should probably add to the write function a preliminary
"check for/ deal with any incoming data in buffer")

2 Apr 10: I am endebted to http://www.delphi-central.com/serial.aspx
for most of the material which has added reading from the serial port
to DD80, the principal change between DD55 (only writes to it) and DD80.

TO DO: At http://www.delphi-central.com/serial.aspx
we are admonished:

BEGIN QUOTE
Closing the serial port
The following code closes the serial port. Your application should
be coded with proper exception handling so that once the serial port
has been opened it is properly closed when an error occurs.

    CloseHandle(ComFile);     (hCommFile in my (tkb) code)

END QUOTE. I believe that coding has been completed...

N.B. from help file: "Closing an invalid handle raises an
exception. This includes closing a handle twice, not checking
the return value and closing an invalid handle"

TO DO.... in DD81, still. (Notes were carried forward from DD80)

Clear up the interaction between the Windows Control Panel port settings
and the settings established here.

Permit set-by-ini-file of.... baud, COM port, stop bits, etc.

*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const ver='3 Aug 10';

(* DD83 started 1Aug2010 (Peg's birthday.. spoke to her on phone in Cotuit)
  Had "working" version (with rough edges, but working) by 2:30am,
  early 2nd.... with "final flat clear" day with JulieF ahead of me
  in daylight hours of 2nd. Wasn't late!
  DD83 came hard on the heels of DD81, DD82 in creative frenzy when
  I should have been getting ready for trip to SX!*)


  RxBufferSize = 256;
  TxBufferSize = 256;
  //These constants are concerned with setting space
  //aside for buffering data to and from the serial
  //port. Make them too large, and space is wasted;
  //too small, and the buffers won't be adequate to
  //tide you over times when the computer's attention
  //is elsewhere. It may be that there are places in
  //the program where absolute values, or numbers from
  //other sources were used which should be replaced
  //with these constants.

  bTryIt=2;//How many times the TurnLEDOn and TurnLEDOff
     //messages should be sent, when the button is clicked.'n'

type
  TDD83f1 = class(TForm)
    buQuit: TButton;
    laVersion: TLabel;
    Timer1: TTimer;
    buLEDOn: TButton;
    buLEDOff: TButton;
    laLEDState: TLabel;
    laSwitchState: TLabel;
    laDebug: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure buQuitClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure buLEDOnClick(Sender: TObject);
    procedure buLEDOffClick(Sender: TObject);
  private
    { Private declarations }
     sPortState:set of (c,w,r);//For closed, open for write, open for read
     hCommFile: THandle;
     bTmp,bMar:byte;
     sLineBuff:string;
     wCurrMemoLine:word;
     boLEDShouldBeOn:boolean;//This will flag the most recent
       //"request", i.e be set true if "Turn LED On" clicked, false
       //if "Turn LED Off" clicked. The REQUEST TO THE ARDUINO to
       //turn LED on or off goes at a different time.
     bLEDChangeRequestsLeft:byte;//This is set to, say, 2 when TurnLEDOn
       //or TurnLEDOff clicked, and decremented each time a request
       //for LED set/clear is sent to Arduino. Once bLEDChangeReq...
       //reaches 0, no more requests are sent until one of the
       //buttons is clicked again.
     procedure WriteString(sToSend:string);
     procedure SendChars(sToSend:string);
     function sLookForDataInBuffer:string;
     function SetUpSerPort:byte;
     function OpenForRead:byte;
     function OpenForWrite:byte;
  public
    { Public declarations }
  end;

var
  DD83f1: TDD83f1;

implementation

{$R *.DFM}
{$R+}

procedure TDD83f1.FormCreate(Sender: TObject);
begin
laVersion.Caption:='Version: '+ver;
caption:='DD82, SheepdogSoftware.co.uk';
top:=100;
left:=100;
sPortState:=[c];//Changed to [r] if handle set up
//to read from the port, or [w] if
//handle set up to write to the port
bTmp:=OpenForRead;
if bTmp<>0 then showmessage('Could not open port during form create... '+
  'This can arise if another app is using the port.');
  //Yes.. it can display this showmessage if necessary.
end;

procedure TDD83f1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if sPortState<>[c] then closehandle(hCommFile);
//showmessage('x');//For testing that closehandle is done regardless
// of whether app closed with buQuit or red X. It is, as long as
// the buQuitClick handler is "close", not "application.terminate"
end;

procedure TDD83f1.buQuitClick(Sender: TObject);
begin
close;//close, not "application.terminate"... to get
// the "if sPortState<>[c]... processed.
end;

procedure TDD83f1.WriteString(sToSend:string);
//While in THIS program, we only write strings,
//  this procedure is perfectly capable of sending a
//  "string" consisting of a single character.
var NumberWritten : dWord;
  //The type of NumberWritten is problematic... some
  //posts online say use dWord, others say use longint.
  //Perhaps it is a matter of what version of Windows
  //   and/or Delphi you have? For XP + Delphi 4, dWord is right.
begin
if WriteFile(hCommFile,
               PChar(sToSend)^,
               Length(sToSend),
               NumberWritten,
               nil)=false then
      showmessage('Unable to send');
end;//WriteString

procedure TDD83f1.SendChars(sToSend:string);
//A low level routine to send bytes might
// seem a better thing to have, but the Windows
// API function we are calling expects to be
// given a string to send, so our procedure
// takes a string as an arguement. If you want
// to send numbers, convert them to strings first.
begin
//On entry, port should already be open for reading
//... but we want it open for writing, so...
if sPortState=[r] then begin
   closehandle(hCommFile);
   sPortState:=[c];
   end;

bTmp:=0;//in case port already open for writing
if sPortState=[c] then bTmp:=OpenForWrite;

if bTmp<>0 then showmessage('Could not open port '+
     'during attempt to write')//no ; here
  else begin //1- big block...

sPortState:=[w];

WriteString(sToSend);
closehandle(hCommFile);//Get ready to go back to being ready to read
sPortState:=[c];

bTmp:=OpenForRead;
if bTmp=0 then sPortState:=[r]//no ; here
  else begin //2
    showmessage('Was not able to re-open for read after a write');
    sPortState:=[c];//untangle inconsistencies re: where sPortState set
    end;//2
end;//1
end;//SendChars

function TDD83f1.SetUpSerPort:byte;
//Call AFTER establishing hCommFile. Returns 0 if setup goes okay.

var
   DCB: TDCB;
   Config : string;
   CommTimeouts : TCommTimeouts;
   bErrCode:byte;

begin
bErrCode:=0;//Will eventually be returned. If zero, no error seen
if not SetupComm(hCommFile, RxBufferSize, TxBufferSize) then
   bErrCode:=1;
   { Raise an exception --- these comments
       all scraps of source material... will try to use exceptions in
       due course!}

if bErrCode=0 then //no "begin" here...  (this is part of kludge avoiding exceptions)
if not GetCommState(hCommFile, DCB) then
   bErrCode:=2;
   { Raise an exception }

Config := 'baud=9600 parity=n data=8 stop=1' + chr(0);

if bErrCode=0 then //no "begin" here...  (this is part of avoiding exceptions)
if not BuildCommDCB(@Config[1], DCB) then
   bErrCode:=3;
   { Raise an exception }

if bErrCode=0 then //no "begin" here...  (this is part of avoiding exceptions)
if not SetCommState(hCommFile, DCB) then
   bErrCode:=4;
   { Raise an exception }

if bErrCode=0 then //no "begin" here...  (this is part of avoiding exceptions)
with CommTimeouts do
begin
   ReadIntervalTimeout := 0;
   ReadTotalTimeoutMultiplier := 0;
   ReadTotalTimeoutConstant := 200;//This determines(?) how long
      //you stay in an attempt to read from serial port. milliseconds
      //I hope these routines are reading from a buffer managed by
      //the OS independently of these routines.
   WriteTotalTimeoutMultiplier := 0;
   WriteTotalTimeoutConstant := 1000;
end;

if bErrCode=0 then //no "begin" here...  (this is part of avoiding exceptions)
if not SetCommTimeouts(hCommFile, CommTimeouts) then
   bErrCode:=5;
   { Raise an exception }

result:=bErrCode;
end;//function SetUpSerPort:byte;

function TDD83f1.OpenForRead:byte;
//Set up a handle for reading from serial stream.
//Returns zero if successful.
//Only enter with port closed.
//Uses global variable hCommFile to return handle created
//Fills global variable sPortState with appropriate value.
var
  CommPort : string;
  bTmp:byte;//important to keep THIS "extra" bTmp.
begin
bTmp:=0;//Will be returned. If still zero, open was successful
sPortState:=[r];//presumption. Change to c if open fails.
//Only enter with port not open for read or write.
  CommPort := 'COM1';
  hCommFile := CreateFile(PChar(CommPort),
                          GENERIC_READ,
                          0,
                          nil,
                          OPEN_EXISTING,
                          FILE_ATTRIBUTE_NORMAL,
                          0);
  if hCommFile=INVALID_HANDLE_VALUE then begin
      ShowMessage('Unable to open for write '+ CommPort);
      sPortState:=[c];
      bTmp:=1;//Error flag of "1" can arise here, or at SetUpUserPort
      end// no ; here
      else begin //else 1
      bTmp:=SetUpSerPort;
      if bTmp<>0 then begin
         showmessage('Failed to setup serial port, error:'+inttostr(bTmp));
         sPortState:=[c];
         end//no ; here
      end; //else 1
result:=bTmp;
end;//buOpenForRead

function TDD83f1.OpenForWrite:byte;
//Set up a handle for writing to serial stream.
//Returns zero if successful.
//Uses global variable hCommFile to hold handle created
var
  CommPort : string;
  bTmp:byte;//important to keep THIS "extra" bTmp.
begin
  CommPort := 'COM1';
  hCommFile := CreateFile(PChar(CommPort),
                          GENERIC_WRITE,
                          0,
                          nil,
                          OPEN_EXISTING,
                          FILE_ATTRIBUTE_NORMAL,
                          0);
  if hCommFile=INVALID_HANDLE_VALUE then begin
      ShowMessage('Unable to open for write '+ CommPort);
      bTmp:=1;
      end// no ; here
      else begin //else 1
      bTmp:=SetUpSerPort;
      if bTmp<>0 then showmessage('Failed to setup serial port, error:'+inttostr(bTmp))//no ; here
      end; //else 1
result:=bTmp;
end;//buOpenForWrite

function TDD83f1.sLookForDataInBuffer:string;
//Returns the data that was in the buffer. This version
//  works best if the data is all printable ASCII
//Returns rogue, "qrogueNothingWaiting" if buffer empty
//  when checked.
var
   d: array[1..RxBufferSize] of Char;//Should this match the number in
   //"SetUpSerPort"?
   var i: Integer;
   BytesRead,nNumBytesToRead:dword;
   sReturn:string;
   //You will find various versions of the ReadFile call
   //on the internet. Getting the types right appears to
   //be a problem... perhaps what is "right" varies from
   //one version of Windows or Delphi to another??

   //Note also that there are TWO DIFFERENT routines for
   //setting up hCommFile, the handle to the data stream,
   //one for creating a stream to be read from, one for
   //a stream to write to. And they can't, in a simple
   //world, both be open at once. And opening the handle
   //for reading a stream seems to flush any incoming data
   //which might be in the buffer... if it was even collected
   //to the buffer while the handle wasn't valid.

  function sReadNReturnWhatsWaiting:string;//SR of sLookForDataInBuffer
  var sTmpL:string;
  i:byte;//BytesRead is of type dword, but by here has been cut
      //down to 0-255

begin
    sTmpL:='';
    for i:=1 to BytesRead do sTmpL:= sTmpL + d[i];
    result:=sTmpL;
    end;//End sReadNReturnWhatsWaiting, a sub-routine
             //of sLookForDataInBuffer;

begin //sLookForDataInBuffer;
sReturn:='qrogueNothingWaiting';
if sPortState<>[r] then showmessage('Could not read')//no ; here
else begin //1
 nNumBytesToRead:=sizeof(d);
 if (ReadFile(hCommFile, d, nNumBytesToRead, BytesRead, nil))=false then
   {ORIGINAL FROM WHICH THIS IS ADAPTED HAD "Raise an exception" here,
   no begin..else structure }
   begin showmessage('Problem with ReadFile call');
   end//no ; here
  else begin
    BytesRead:=BytesRead AND $FF;//Kludge.. getting weird values in BytesRead
    //if BytesRead>0 then showmessage(inttostr(BytesRead));
    if BytesRead>0 then sReturn:=sReadNReturnWhatsWaiting;
    end;//else
  //leave open, in case another read is next. Write starts with a close. closehandle(hCommFile);
 end;//1
//sReturn[1]:='f';
result:=sReturn[1];
end;//sLookForDataInBuffer;

procedure TDD83f1.buLEDOnClick(Sender: TObject);
begin
boLEDShouldBeOn:=true;//see declaration of variable
bLEDChangeRequestsLeft:=bTryIt;//ditto
laLEDState.caption:='LED Should be on, or go on shortly.';
end;

procedure TDD83f1.buLEDOffClick(Sender: TObject);
begin
boLEDShouldBeOn:=false;//see declaration of variable
bLEDChangeRequestsLeft:=bTryIt;//ditto
laLEDState.caption:='LED Should be off, or go off shortly.';
end;

procedure TDD83f1.Timer1Timer(Sender: TObject);
(*HEART of DD83's interaction with Ardino...
Sends "n" or "f" for "turn LED on" or "turn LED off"
Sends '?' to say "Send me state of switch", to
which it expects "h" or "w" for "High" or "loW" as
a reply.

The reply is picked up the next time Timer1Timer executes

*)
var sTmp:string;

begin
//Start by picking up answer to "?" which may have arrived
//following enquiry at end of previous execution of this
//routine
sTmp:=sLookForDataInBuffer;

if sTmp='h' then begin
    laSwitchState.Caption:=
      'Input due to switch was high, when last checked.';
    laDebug.caption:=sTmp;
    end;
if sTmp='w' then begin
    laSwitchState.Caption:=
      'Input due to switch was low, when last checked.';
    laDebug.caption:=sTmp;
    end;

if (sTmp<>'h') and (sTmp<>'w') then begin
    //N.B. THIS CASE WAS ARISING SOMETIMES, 03 Aug 2010, 9:43
    //Make laDebug visible to watch. (Made not visible at design level)
    //Perhaps arising because I'm polling serial read too quickly?
    laDebug.caption:='SOMETHING ODD';
    end;

if bLEDChangeRequestsLeft>0 then begin
    if boLEDShouldBeOn then
       SendChars('n')//no ; here
       else SendChars('f');//
    dec(bLEDChangeRequestsLeft);
    end;//End of if bLEDChange...

//Next should send a "?" to the slave, which should trigger
    //it to send state of switch...
SendChars('?');

end;//Timer1Timer

end.
