{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10205: IdIMAP4.pas 
{
{   Rev 1.10    20/09/2003 20:09:38  CCostelloe
{ Support added for different servers; some restructuring also
}
{
{   Rev 1.9    12/08/2003 01:39:04  CCostelloe
{ Minor patches.
}
{
{   Rev 1.8    05/07/2003 23:55:22  CCostelloe
{ More bug fixes and improvements, also IFDEF INDY100's stripped out.
}
{
{   Rev 1.7    10/06/2003 21:04:20  CCostelloe
{ ReceiveBody added to resolve problems with some servers and
{ (UID)Receive(Peek) functions.  See comments starting "CC6".
}
{
{   Rev 1.6    29/05/2003 22:47:02  CCostelloe
{ Major update, most of code rewritten.  See comments in source.  Tested
{ against CommuniGate and Cyrus IMAP servers.
}
{
{   Rev 1.5    12/05/2003 00:03:52  CCostelloe
{ Bug fix between Windows 98 and Windows 2000 resolved
}
{
{   Rev 1.4    11/05/2003 23:14:18  CCostelloe
{ More bug fixes plus IMAP-specific code moved up from TIdRFCReply.
}
{
{   Rev 1.3    08/05/2003 02:31:28  CCostelloe
}
{
{   Rev 1.2    15/04/2003 00:46:50  CCostelloe
}
{
{   Rev 1.1    01/04/2003 21:54:10  CCostelloe
}
{
{   Rev 1.0    2002.11.12 10:42:04 PM  czhower
}
unit IdIMAP4;



{ ########********########********########********########********########********
            WARNING:
            KNOWN ISSUES AND WORKAROUNDS AS OF 20th July 2003:
            (UID)RetrievePart(Peek) functions occasionally cause erratic crashes,
              but only if invalid parameters are used (e.g. calling them with the
              wrong encoding specified).
            Some functions may still be susceptible to breakage by "unsolicited
              responses" from an IMAP server.  As an example, one server sends
              "* 93 EXISTS" and "* 1 RECENT" when a new message (number 93)
              arrives in the Inbox.
            The Indy 9 version of AppendMsg does not support attachments.
            The Indy 9 version of (UID)Retrieve(Peek) does not support body text
              lines longer than 16K (these can arise with long html messages).
            This is only for Windows, no work has been done on a Linux version.

            Ciaran Costelloe
            ccostelloe@flogas.ie
  ########********########********########********########********########********
}
{*

  IMAP 4 (Internet Message Access Protocol - Version 4 Rev 1)
  By Idan Cohen i_cohen@yahoo.com

  2001-FEB-27 IC: First version most of the IMAP features are implemented and
                  the core IdPOP3 features are implemented to allow a seamless
                  switch.
                  The unit is currently oriented to a session connection and not
                  to constant connection, because of that server events that are
                  raised from another user actions are not supported.

  2001-APR-18 IC: Added support for the session's connection state with a
                  special exception for commands preformed in wrong connection
                  states. Exceptions were also added for response errors.

  2001-MAY-05 IC:

  2001-Mar-13 DS: Fixed Bug # 494813 in CheckMsgSeen where LastCmdResult.Text
                  was not using the Ln index variable to access server
                  responses.

  2002-Apr-12 DS: fixed bug # 506026 in TIdIMAP4.ListSubscribedMailBoxes.  Call
                  ParseLSubResut instead of ParseListResult.

  2003-Mar-31 CC: Added GetUID and UIDSearchMailBox, sorted out some bugs (details
                  shown in comments in those functions which start with "CC:").

  2003-Apr-15 CC2:Sorted out some more bugs (details shown in comments in those
                  functions which start with "CC2:").  Set FMailBoxSeparator
                  in ParseListResult and ParseLSubResult.
                  Some IMAP servers generally return "OK completed" even if they
                  returned no data, such as passing a non-existent message
                  number to them: they possibly should return NO or BAD; the
                  functions here have been changed to return FALSE unless they
                  get good data back, even if the server answers OK.  Similar
                  change made for other functions.
                  There are a few exceptions, e.g. ListMailBoxes may only return
                  "OK completed" if the user has no mailboxes, these are noted.
                  Also, RetrieveStructure(), UIDRetrieveStructure, RetrievePart,
                  UIDRetrievePart, RetrievePartPeek and UIDRetrievePartPeek
                  added to allow user to find the structure of a message and
                  just retrieve the part or parts he needs.

  2003-Apr-30 CC3:Added functionality to retrieve the text of a message (only)
                  via RetrieveText / UIDRetrieveText / RetrieveTextPeek /
                  UIDRetrieveTextPeek.
                  Return codes now generally reflect if the function succeeded
                  instead of returning True even though function fails.

  2003-May-15 CC4:Added functionality to retrieve individual parts of a message
                  to a file, including the decoding of those parts.

  2003-May-29 CC5:Response of some servers to UID version of commands varies,
                  code changed to deal with those (UID position varies).
                  Some servers return NO such as when you request an envelope
                  for a message number that does not exist: functions return
                  False instead of throwing an exception, as was done for other
                  servers.  The general logic is that if a valid result is
                  returned from the IMAP server, return True;  if there is no
                  result (but the command is validly structured), return FALSE;
                  if the command is badly structured or if it gives a response
                  that this code does not expect, throw an exception (typically
                  when we get a BAD response instead of OK or NO).
                  Added IsNumberValid, IsUIDValid to prevent rubbishy parameters
                  being passed through to IMAP functions.
                  Sender field now filled in correctly in ParseEnvelope
                  functions.
                  All fields in ParseEnvelopeAddress are cleared out first,
                  avoids an unwitting error where some entries, such as CC list,
                  will append entries to existing entries.
                  Full test script now used that tests every TIdIMAP command,
                  more bugs eradicated.
                  First version to pass testing against both CommuniGate and
                  Cyrus IMAP servers.
                  Not tested against Microsoft Exchange, don't have an Exchange
                  account to test it against.

  2003-Jun-10 CC6:Added (UID)RetrieveEnvelopeRaw, in case the user wants to do
                  their own envelope parsing.
                  Code in RetrievePart altered to make it more consistent.
                  Altered to incorporate Indy 10's use of IdReplyIMAP4 (not
                  complete at this stage).
                  ReceiveBody added to IdIMAP4, due to the response of some
                  servers, which gets (UID)Receive(Peek) functions to work on
                  more servers.

  2003-Jun-20 CC7:ReceiveBody altered to work with Indy 10.  Made changes due to
                  LoginSASL moving from TIdMessageSASLClient to TIdSASLList.
                  Public variable FGreetingBanner added to help user identify
                  the IMAP server he is connected to (may help him decide the
                  best strategy).  Made AppendMsg work a bit better (now uses
                  platform-independent EOL and supports ExtraHeaders field).
                  Added 2nd version of AppendMsg.  Added "if Connected then "
                  to Destroy.  Attachment filenames now decoded if necessary.
                  Added support for multisection parts.

  2003-Jul-16 CC8:Added RemoveAnyAdditionalResponses.  Resolved issue of some
                  servers leaving out the trailing "NIL NIL NIL" at the end of
                  some body structures.  (UID)Retrieve(Peek) functions
                  integrated via InternalRetrieve, new method of implementing
                  these functions (all variations of Retrieve) added for Indy
                  10 based on getting message by the byte-count and then feeding
                  it into the standard message parser.
                  UIDRetrieveAllHeaders removed: it was never implemented anyway
                  but it makes no sense to retrieve a non-contiguous list which
                  would have gaps due to missing UIDs.
                  In the Indy 10 version, AppendMsg functions were altered to
                  support the sending of attachments (attachments had never
                  been supported in AppendMsg prior to this).
                  Added CopyMsg and UIDCopyMsgs to complete the command set.
  2003-Jul-30 CC9:Removed wDoublePoint so that the code is compliant with
                  the guidelines.  Allowed for servers that don't implement
                  search commands in Indy 9 (OK in 10).  InternalRetrieve
                  altered to (hopefully) deal with optional "FLAGS (\Seen)"
                  in response.
  2003-Aug-22 CCA:Yet another IMAP oddity - a server returns NIL for the
                  mailbox separator, ParseListResult modified.  Added "Length
                  (LLine) > 0)" test to stop GPF on empty line in ReceiveBody.
*}

{ TODO -oIC :
Change the mailbox list commands so that they receive TMailBoxTree
structures and so they can store in them the mailbox name and it's attributes. }

{ TODO -oIC :
Add support for \* special flag in messages, and check for \Recent
flag in STORE command because it cant be stored (will get no reply!!!) }

{ TODO -oIC :
5.1.2.  Mailbox Namespace Naming Convention
By convention, the first hierarchical element of any mailbox name
which begins with "#" identifies the "namespace" of the remainder of
the name.  This makes it possible to disambiguate between different
types of mailbox stores, each of which have their own namespaces.
For example, implementations which offer access to USENET
newsgroups MAY use the "#news" namespace to partition the USENET
newsgroup namespace from that of other mailboxes.  Thus, the
comp.mail.misc newsgroup would have an mailbox name of
"#news.comp.mail.misc", and the name "comp.mail.misc" could refer
to a different object (e.g. a user's private mailbox). }    {Do not Localize}

{ TO BE CONSIDERED -CC :
Double-quotes in mailbox names can cause major but subtle failures.  Maybe
add the automatic stripping of double-quotes if passed in mailbox names,
to avoid ending up with ""INBOX""
}
interface

{CC3: WARNING - if the following gives a "File not found" error on compilation,
you need to add the path "C:\Program Files\Borland\Delphi7\Source\Indy" in
Project -> Options -> Directories/Conditionals -> Search Path}
{$I IdCompilerDefines.inc}
uses
    IdMessage,
    Classes,
    SysUtils, {CC3: SysUtils added to support Exception}
    IdAssignedNumbers,
    IdGlobal,
    IdMailBox,
    IdTCPStream,
    IdMessageClient,
    IdComponent,     {CC6: Now needed for ReceiveBody}
    IdMessageCoder,  {CC2: Now needed for parsing BODYSTRUCTURE}
    IdHeaderList,    {CC7: Added for 2nd version of AppendMsg}
    IdCoderHeader,   {CC7: Needed for decoding filenames}
    IdCoderMIME,
    IdCoderQuotedPrintable,
    IdMessageCollection;

const
    wsOk  = 1;
    wsNo  = 2;
    wsBad = 3;
    wsPreAuth = 4;
    wsBye = 5;
    {CC4: For consistency, change wsSASLContinue to wsContinue..}
    {wsSASLContinue = 10;}
    wsContinue = 6;


{CC6: Moved to IdReplyIMAP4 for Indy 10...}
const
    VALID_TAGGEDREPLIES : array [0..5] of string =
      ('OK',    'NO',  'BAD',  'PREAUTH',  'BYE',  '+');  {Do not Localize}
    VALID_UNTAGGEDREPLIES : array [0..5] of string =
      ('* OK','* NO','* BAD','* PREAUTH','* BYE','* +');  {Do not Localize}

{CC7: TIdImapSubSection added for multisection parts - see TIdImapMessagePart
comment for explanation}
type
TIdImapSubSection = class(TObject)
  protected
    FBodyType: string;
    FBodySubType: string;
    FFileName: string;
    FDescription: string;
    FEncoding: string;
    FSize: integer;
    FSubSection: TIdImapSubSection; {Can link down to another here}
  public
    property BodyType : String read FBodyType write FBodyType;
    property BodySubType : String read FBodySubType write FBodySubType;
    property FileName : String read FFileName write FFileName;
    property Description : String read FDescription write FDescription;
    property Encoding : String read FEncoding write FEncoding;
    property Size : integer read FSize write FSize;
    property SubSection : TIdImapSubSection read FSubSection write FSubSection;
    constructor Create;
end;

{CC3: TIdImapMessagePart and TIdImapMessageParts added for retrieving
individual parts of a message via IMAP, because IMAP uses some additional
terms.
Note that (rarely) an IMAP can have two sub-"parts" in the one part -
they are sent in the one part by the server, typically a plain-text and
html version with a boundary at the start, in between, and at the end.
TIdIMAP fills in the boundary in that case, and the FSubpart holds the
info on the second part.  I call these multisection parts.}
TIdImapMessagePart = class(TCollectionItem)
  protected
    FBodyType: string;
    FBodySubType: string;
    FFileName: string;
    FDescription: string;
    FEncoding: string;
    FSize: integer;
    FUnparsedEntry: string; {Text returned from server: useful for debugging or workarounds}
    FBoundary: string; {Only used for multisection parts}
    FSubSection: TIdImapSubSection; {Second section of multisection part goes here}
  public
    property BodyType : String read FBodyType write FBodyType;
    property BodySubType : String read FBodySubType write FBodySubType;
    property FileName : String read FFileName write FFileName;
    property Description : String read FDescription write FDescription;
    property Encoding : String read FEncoding write FEncoding;
    property Size : integer read FSize write FSize;
    property UnparsedEntry : string read FUnparsedEntry write FUnparsedEntry;
    property Boundary : string read FBoundary write FBoundary;
    property SubSection : TIdImapSubSection read FSubSection write FSubSection;
    constructor Create(Collection: TCollection); override;
    destructor  Destroy; override;
end;

type
{CC3: Added for validating message number}
EIdNumberInvalid = class(Exception);

TIdImapMessageParts = class(TOwnedCollection)
  protected
    function  GetItem(Index: Integer): TIdImapMessagePart;
    procedure SetItem(Index: Integer; const Value: TIdImapMessagePart);
  public
    function  Add: TIdImapMessagePart;
    property  Items[Index: Integer]: TIdImapMessagePart read GetItem write SetItem; default;
end;

type
  TIdIMAP4Commands =
  ( cmdCAPABILITY,
    cmdNOOP,
    cmdLOGOUT,
    cmdAUTHENTICATE,
    cmdLOGIN,
    cmdSELECT,
    cmdEXAMINE,
    cmdCREATE,
    cmdDELETE,
    cmdRENAME,
    cmdSUBSCRIBE,
    cmdUNSUBSCRIBE,
    cmdLIST,
    cmdLSUB,
    cmdSTATUS,
    cmdAPPEND,
    cmdCHECK,
    cmdCLOSE,
    cmdEXPUNGE,
    cmdSEARCH,
    cmdFETCH,
    cmdSTORE,
    cmdCOPY,
    cmdUID,
    cmdXCmd );

  {CC3: Add csUnexpectedlyDisconnected for when we receive "Connection reset by peer"}
  TIdIMAP4ConnectionState = ( csAny, csNonAuthenticated, csAuthenticated, csSelected , csUnexpectedlyDisconnected );
  {****************************************************************************
  Universal commands CAPABILITY, NOOP, and LOGOUT
  Authenticated state commands SELECT, EXAMINE, CREATE, DELETE, RENAME,
  SUBSCRIBE, UNSUBSCRIBE, LIST, LSUB, STATUS, and APPEND
  Selected state commands CHECK, CLOSE, EXPUNGE, SEARCH, FETCH, STORE, COPY, and UID
  *****************************************************************************}

  TIdIMAP4SearchKey =
  ( skAll,       //All messages in the mailbox; the default initial key for ANDing.
    skAnswered,  //Messages with the \Answered flag set.
    skBcc,       //Messages that contain the specified string in the envelope structure's BCC field.    {Do not Localize}
    skBefore,    //Messages whose internal date is earlier than the specified date.
    skBody,      //Messages that contain the specified string in the body of the message.
    skCc,        //Messages that contain the specified string in the envelope structure's CC field.    {Do not Localize}
    skDeleted,   //Messages with the \Deleted flag set.
    skDraft,     //Messages with the \Draft flag set.
    skFlagged,   //Messages with the \Flagged flag set.
    skFrom,      //Messages that contain the specified string in the envelope structure's FROM field.    {Do not Localize}
    skHeader,    //Messages that have a header with the specified field-name (as defined in [RFC-822])
                 //and that contains the specified string in the [RFC-822] field-body.
    skKeyword,   //Messages with the specified keyword set.
    skLarger,    //Messages with an [RFC-822] size larger than the specified number of octets.
    skNew,       //Messages that have the \Recent flag set but not the \Seen flag.
                 //This is functionally equivalent to "(RECENT UNSEEN)".
    skNot,       //Messages that do not match the specified search key.
    skOld,       //Messages that do not have the \Recent flag set. This is functionally
                 //equivalent to "NOT RECENT" (as opposed to "NOT NEW").
    skOn,        //Messages whose internal date is within the specified date.
    skOr,        //Messages that match either search key.
    skRecent,    //Messages that have the \Recent flag set.
    skSeen,      //Messages that have the \Seen flag set.
    skSentBefore,//Messages whose [RFC-822] Date: header is earlier than the specified date.
    skSentOn,    //Messages whose [RFC-822] Date: header is within the specified date.
    skSentSince, //Messages whose [RFC-822] Date: header is within or later than the specified date.
    skSince,     //Messages whose internal date is within or later than the specified date.
    skSmaller,   //Messages with an [RFC-822] size smaller than the specified number of octets.
    skSubject,   //Messages that contain the specified string in the envelope structure's SUBJECT field.    {Do not Localize}
    skText,      //Messages that contain the specified string in the header or body of the message.
    skTo,        //Messages that contain the specified string in the envelope structure's TO field.    {Do not Localize}
    skUID,       //Messages with unique identifiers corresponding to the specified unique identifier set.
    skUnanswered,//Messages that do not have the \Answered flag set.
    skUndeleted, //Messages that do not have the \Deleted flag set.
    skUndraft,   //Messages that do not have the \Draft flag set.
    skUnflagged, //Messages that do not have the \Flagged flag set.
    skUnKeyWord, //Messages that do not have the specified keyword set.
    skUnseen );

  TIdIMAP4SearchKeyArray = array of TIdIMAP4SearchKey;

  TIdIMAP4SearchRec = record
    Date: TDateTime;
    Size: Integer;
    Text: String;
    SearchKey : TIdIMAP4SearchKey;
  end;

  TIdIMAP4SearchRecArray = array of TIdIMAP4SearchRec;

  TIdIMAP4StatusDataItem = ( mdMessages, mdRecent, mdUIDNext, mdUIDValidity, mdUnseen );

  TIdIMAP4StoreDataItem = ( sdReplace, sdReplaceSilent, sdAdd, sdAddSilent, sdRemove, sdRemoveSilent );

  TIdRetrieveOnSelect = ( rsDisabled, rsHeaders, rsMessages );

  TIdAlertEvent = procedure(ASender: TObject; const AAlertMsg: String) of object;

TIdIMAP4 = class(TIdMessageClient)
  private
    procedure SetMailBox(const Value: TIdMailBox);
  protected
    FCmdCounter : Integer;
    FConnectionState : TIdIMAP4ConnectionState;
    FMailBox : TIdMailBox;
    FMailBoxSeparator: Char;
    FOnAlert: TIdAlertEvent;
    FRetrieveOnSelect: TIdRetrieveOnSelect;
    procedure TaggedReplyConvertToConst;
    function GetCmdCounter: String;
    function GetConnectionStateName: String;
    function GetNewCmdCounter: String;
    property LastCmdCounter: String read GetCmdCounter;
    property NewCmdCounter: String read GetNewCmdCounter;
    { General Functions }
    function ArrayToNumberStr (const AMsgNumList: array of Integer): String;
    function MessageFlagSetToStr (const AFlags: TIdMessageFlagsSet): String;
    //This function is needed because when using the regular DateToStr with dd/MMM/yyyy
    //(which is the IMAP needed convension) may give the month as the local language
    //three letter month instead of the English month needed.
    function DateToIMAPDateStr (const ADate: TDateTime): String;
    procedure StripCRLFs(var AText: string);
    { General Functions }
    { Parser Functions }
    {CC2: ParseBodyStructureResult added to support individual part retreival...}
    procedure ParseBodyStructureResult(ABodyStructure: string; ATheParts: TIdMessageParts; AImapParts: TIdImapMessageParts);
    {CC3: ParseBodyStructurePart added to support individual part retreival...}
    {CC7: TIdImapSubSection added to ParseBodyStructurePart to support multisection parts...}
    procedure ParseBodyStructurePart(APartString: string; AThePart: TIdMessagePart; AImapPart: TIdImapMessagePart; AImapSubSection: TIdImapSubSection);
    procedure ParseTheLine(ALine: string; LPartsList: TStringList);
    procedure ParseIntoParts(APartString: string; AParams: TStringList);
    procedure ParseIntoImapParts(APartString: string; AParams: TStringList);
    procedure BreakApartParamsInQuotes(const AParam: string; var AParsedList: TStringList);
    function  GetNextWord(AParam: string): string;
    function  GetNextQuotedParam(AParam: string): string;
    procedure ParseExpungeResult (AMB: TIdMailBox; CmdResultDetails: TStrings);
    procedure ParseListResult (AMBList: TStringList; CmdResultDetails: TStrings);
    procedure ParseLSubResult(AMBList: TStringList; CmdResultDetails: TStrings);
    {CCA: InternalParseListResult added to resolve NIL mailbox separator and
    rationalise code between ParseLisTresult and ParseLSubResult}
    procedure InternalParseListResult(ACmd: string; AMBList: TStringList; CmdResultDetails: TStrings);
    procedure ParseMailBoxAttributeString(AAttributesList: String; var AAttributes: TIdMailBoxAttributesSet);
    procedure ParseMessageFlagString (AFlagsList: String; var AFlags: TIdMessageFlagsSet);
    procedure ParseSelectResult (AMB: TIdMailBox; CmdResultDetails: TStrings);
    procedure ParseStatusResult (AMB: TIdMailBox; CmdResultDetails: TStrings);
    procedure ParseSearchResult (AMB: TIdMailBox; CmdResultDetails: TStrings);
    procedure ParseEnvelopeResult (AMsg: TIdMessage; ACmdResultStr: String);
    {CC3: The following were moved up from IdRFCReply to implement the + response...}
    procedure ParseResponse(const AStrings: TStrings); overload;
    procedure ParseResponse(const ATag: String; const AStrings: TStrings); overload;
    procedure ParseLineResponse(const ATag: String; const AStrings: TStrings);
    {CC8: Following added to combine the (UID)Retrieve(Peek) functions...}
    function  InternalRetrieve(const AMsgNum: Integer; AUseUID: Boolean; AUsePeek: Boolean; AMsg: TIdMessage): Boolean;
    {CC2: Following added for retrieving individual parts of a message...}
    function  InternalRetrievePart(const AMsgNum: Integer; const APartNum: Integer;
      AUseUID: Boolean; AUsePeek: Boolean;
      var ABuffer: PChar; var ABufferLength: Integer; {NOTE: var args cannot have default params}
      ADestFileNameAndPath: string = '';  {Do not Localize}
      AEncoding: string = 'text'): Boolean;  {Do not Localize}
    function  ParseBodyStructureSectionAsEquates(AParam: string): string;
    function  ParseBodyStructureSectionAsEquates2(AParam: string): string;
    {CC3: Following added for retrieving the text-only part of a message...}
    function  InternalRetrieveText(const AMsgNum: Integer; var AText: string;
      AUseUID: Boolean; AUsePeek: Boolean; AUseFirstPartInsteadOfText: Boolean): Boolean;
    {CC3: Following added for TLS support..}
    function  IsCapabilityListed(ACapability: string):Boolean;
    {CC6: Added to support RetrieveEnvelopeRaw...}
    function  InternalRetrieveEnvelope(const AMsgNum: Integer; AMsg: TIdMessage; ADestList: TStringList): Boolean;
    {CC6: Added to support UIDRetrieveEnvelopeRaw...}
    function  UIDInternalRetrieveEnvelope(const AMsgUID: String; AMsg: TIdMessage; ADestList: TStringList): Boolean;
    {CC3: Need to validate message numbers (relative and UIDs), because otherwise
    the routines wait for a response that never arrives and so functions never return.
    Also used for validating part numbers.}
    function  IsNumberValid(const ANumber: Integer): Boolean;
    function  IsUIDValid(const AUID: string): Boolean;
    {CC6: Override IdMessageClient's ReceiveBody due to the responses from some
    servers...}
    procedure ReceiveBody(AMsg: TIdMessage; const ADelim: string = '.'); override;  {Do not Localize}
  public
    { TIdIMAP4 Commands }
    //Requests a listing of capabilities that the server supports.
    function  Capability (ASlCapability: TStrings): Boolean;
    procedure DoAlert (const AMsg: String);
    property  ConnectionState: TIdIMAP4ConnectionState read FConnectionState;
    property  MailBox: TIdMailBox read FMailBox write SetMailBox;
    {CC7: Two versions of AppendMsg are provided.  The first is the normal one you
    would use.  The second allows you to specify an alternative header list which
    will be used in place of AMsg.Headers.
    An email client may need the second type if it sends an email via IdSMTP and wants
    to copy it to a "Sent" IMAP folder.  In Indy 9, IdSMTP internally generates and
    transmits the headers but does not keep them, so what you may need to do is to
    subclass IdSMTP, override SendHeader so that the TIdHeaderList is returned (and
    also override both SendMsg and Send to get it back to you), then use the
    second version of AppendMsg to use the returned TIdHeaderList.  In Indy 10,
    IdSMTP puts the generated headers in the LastGeneratedHeaders field, so you
    can use the second version of AppendMsg, passing it AMsg.LastGeneratedHeaders as
    the AAlternativeHeaders field.  Note that IdSMTP puts both the Headers and
    the ExtraHeaders fields in LastGeneratedHeaders.}
    function  AppendMsg (const AMBName: String; AMsg: TIdMessage; const AFlags: TIdMessageFlagsSet = []): Boolean; overload;
    function  AppendMsg (const AMBName: String; AMsg: TIdMessage; AAlternativeHeaders: TIdHeaderList; const AFlags: TIdMessageFlagsSet = []): Boolean; overload;
    //Requests a checkpoint of the currently selected mailbox.  Does NOTHING on most servers.
    function  CheckMailBox: Boolean;
    //Checks if the message was read or not.
    function  CheckMsgSeen (const AMsgNum: Integer): Boolean;
    //Connects and logins to the IMAP4 account.
    procedure Connect(const ATimeout: Integer = IdTimeoutDefault); override;
    //Closes the current selected mailbox in the account.    {Do not Localize}
    function  CloseMailBox: Boolean;
    constructor Create(AOwner: TComponent); override;
    //Creates a new mailbox with the specified name in the account.    {Do not Localize}
    function  CreateMailBox (const AMBName: String): Boolean;
    //Deletes the specified mailbox from the account.    {Do not Localize}
    function  DeleteMailBox (const AMBName: String): Boolean;
    //Marks a message for deletion, it will be deleted when the mailbox will be purged.
    function  DeleteMsgs(const AMsgNumList: array of Integer): Boolean;
    destructor Destroy; override;
    //Logouts and disconnects from the IMAP account.
    procedure Disconnect; override;
    //Examines the specified mailbox and inserts the results to the TIdMailBox provided.    {Do not Localize}
    function  ExamineMailBox (const AMBName: String; AMB: TIdMailBox): Boolean;
    //Expunges (deletes the marked files) the current selected mailbox in the account.    {Do not Localize}
    function  ExpungeMailBox: Boolean;
    //Sends a NOOP (No Operation) to keep the account connection with the server alive.
    procedure KeepAlive;
    //Returns a list of all the child mailboxes (one level down) to the mailbox supplied.
    //This should be used when you fear that there are to many mailboxes and the listing of
    //all of them could be time consuming, so this should be used to retrieve specific mailboxes.
    function  ListInferiorMailBoxes (AMailBoxList, AInferiorMailBoxList: TStringList): Boolean;
    //Returns a list of all the mailboxes in the user account.
    function  ListMailBoxes (AMailBoxList: TStringList): Boolean;
    //Returns a list of all the subscribed mailboxes in the user account.
    function  ListSubscribedMailBoxes (AMailBoxList: TStringList): Boolean;
    //Renames the specified mailbox in the account.    {Do not Localize}
    function  RenameMailBox (const AOldMBName, ANewMBName: String): Boolean;
    //Searches the current selected mailbox for messages matching the SearchRec and
    //returnes the results to the mailbox SearchResults array.
    function  SearchMailBox (const ASearchInfo: array of TIdIMAP4SearchRec{Array}): Boolean;//array of TIdIMAP4SearchRec ) : Boolean;
    //Selects the current a mailbox in the account.    {Do not Localize}
    function  SelectMailBox (const AMBName: String): Boolean;
    //Retrieves the status of the indicated mailbox.
    {CC2: It is pointless calling StatusMailBox with AStatusDataItems set to []
    because you are asking the IMAP server to update none of the status flags.
    Instead, if called with no AStatusDataItems specified, use the standard flags
    returned by SelectMailBox, which allows the user to easily check if the mailbox
    has changed.  Overload the functions, since AStatusDataItems cannot be set
    to nil.}
    function  StatusMailBox (const AMBName: String; AMB: TIdMailBox): Boolean; overload;
    function  StatusMailBox (const AMBName: String; AMB: TIdMailBox; const AStatusDataItems: array of TIdIMAP4StatusDataItem): Boolean; overload;
    //Changes (adds or removes) message flags.
    function  StoreFlags (const AMsgNumList: array of Integer;
      const AStoreMethod: TIdIMAP4StoreDataItem; const AFlags: TIdMessageFlagsSet): Boolean;
    //Adds the specified mailbox name to the server's set of "active" or "subscribed"    {Do not Localize}
    //mailboxes as returned by the LSUB command.
    function  SubscribeMailBox (const AMBName: String): Boolean;
    {CC8: Added CopyMsg, should have always been there...}
    function  CopyMsg (const AMsgNum: Integer; const AMBName: String): Boolean;
    //Copies a message from the current selected mailbox to the specified mailbox.    {Do not Localize}
    function  CopyMsgs (const AMsgNumList: array of Integer; const AMBName: String): Boolean;
    //Retrieves a whole message while marking it read.
    function  Retrieve (const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
    //Retrieves all envelope of the selected mailbox to the specified TIdMessageCollection.
    function  RetrieveAllEnvelopes (AMsgList: TIdMessageCollection): Boolean;
    //Retrieves all headers of the selected mailbox to the specified TIdMessageCollection.
    function  RetrieveAllHeaders (AMsgList: TIdMessageCollection): Boolean;
    //Retrieves all messages of the selected mailbox to the specified TIdMessageCollection.
    function  RetrieveAllMsgs (AMsgList: TIdMessageCollection): Boolean;
    //Retrieves the message envelope, parses it, and discards the envelope.
    function  RetrieveEnvelope (const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
    //Retrieves the message envelope into a TStringList but does NOT parse it.
    function  RetrieveEnvelopeRaw(const AMsgNum: Integer; ADestList: TStringList): Boolean;
    //Returnes the message flag values.
    {CC: use "var" to get results returned}
    {function RetrieveFlags (const AMsgNum: Integer; AFlags: TIdMessageFlagsSet): Boolean;}
    function  RetrieveFlags (const AMsgNum: Integer; var AFlags: TIdMessageFlagsSet): Boolean;
    {CC2: Following added for retrieving individual parts of a message...}
    function  InternalRetrieveStructure(const AMsgNum: Integer; AMsg: TIdMessage; AParts: TIdImapMessageParts): Boolean;
    //Retrieve only the message structure (this tells you what parts are in the message).
    function  RetrieveStructure(const AMsgNum: Integer; AMsg: TIdMessage): Boolean; overload;
    function  RetrieveStructure(const AMsgNum: Integer; AParts: TIdImapMessageParts): Boolean; overload;
    {CC2: Following added for retrieving individual parts of a message...}
    {Retrieve a specific individual part of a message}
    function  RetrievePart(const AMsgNum: Integer; const APartNum: Integer;
      var ABuffer: PChar; var ABufferLength: Integer; AEncoding: string = 'text'): Boolean;  {Do not Localize}
    {CC2: Following added for retrieving individual parts of a message...}
    {Retrieve a specific individual part of a message}
    function  RetrievePartPeek(const AMsgNum: Integer; const APartNum: Integer;
      var ABuffer: PChar; var ABufferLength: Integer; AEncoding: string = 'text'): Boolean;  {Do not Localize}
    {CC2: Following added for retrieving individual parts of a message...}
    {Retrieve a specific individual part of a message}
    function  RetrievePartToFile(const AMsgNum: Integer; const APartNum: Integer;
      ALength: Integer; ADestFileNameAndPath: string; AEncoding: string): Boolean;
    {CC2: Following added for retrieving individual parts of a message...}
    {Retrieve a specific individual part of a message}
    function  RetrievePartToFilePeek(const AMsgNum: Integer; const APartNum: Integer;
      ALength: Integer; ADestFileNameAndPath: string; AEncoding: string): Boolean;
    {CC3: Following added for retrieving the text-only part of a message...}
    function  RetrieveText(const AMsgNum: Integer; var AText: string): Boolean;
    {CC4: An alternative for retrieving the text-only part of a message which
    may give a better response from some IMAP implementations...}
    function  RetrieveText2(const AMsgNum: Integer; var AText: string): Boolean;
    {CC3: Following added for retrieving the text-only part of a message...}
    function  RetrieveTextPeek(const AMsgNum: Integer; var AText: string): Boolean;
    function  RetrieveTextPeek2(const AMsgNum: Integer; var AText: string): Boolean;
    //Retrieves only the message header.
    function  RetrieveHeader (const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
    //Retrives the current selected mailbox size.
    function  RetrieveMailBoxSize: Integer;
    //Returnes the message size.
    function  RetrieveMsgSize(const AMsgNum: Integer): Integer;
    //Retrieves a whole message while keeping its Seen flag untucked    {Do not Localize}
    //(preserving the previous value).
    function  RetrievePeek (const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
    //Get the UID corresponding to a relative message number.
    function  GetUID(const AMsgNum: Integer; var AUID: string): Boolean;
    //Copies a message from the current selected mailbox to the specified mailbox.    {Do not Localize}
    function  UIDCopyMsg (const AMsgUID: String; const AMBName: String): Boolean;
    {CC8: Added UID version of CopyMsgs...}
    function  UIDCopyMsgs(const AMsgUIDList: TStringList; const AMBName: String): Boolean;
    //Checks if the message was read or not.
    function  UIDCheckMsgSeen (const AMsgUID: String): Boolean;
    //Marks a message for deletion, it will be deleted when the mailbox will be purged.
    function  UIDDeleteMsg(const AMsgUID: String): Boolean;
    //Retrieves all headers of the selected mailbox to the specified TIdMessageCollection.
    {CC5: This is not, and never was, implemented: why would you use it?}
    {CC8: UIDRetrieveAllHeaders is removed, it makes no sense when you think about it,
    because it would need a sparse array because of missing UIDs in sequence.}
    {function UIDRetrieveAllHeaders (AMsgList: TIdMessageCollection): Boolean;}
    //Retrieves all envelope and UID of the selected mailbox to the specified TIdMessageCollection.
    function  UIDRetrieveAllEnvelopes (AMsgList: TIdMessageCollection): Boolean;
    //Retrieves a whole message while marking it read.
    function  UIDRetrieve (const AMsgUID: String; AMsg: TIdMessage): Boolean;
    //Retrieves the message envelope, parses it, and discards the envelope.
    function  UIDRetrieveEnvelope (const AMsgUID: String; AMsg: TIdMessage): Boolean;
    //Retrieves the message envelope into a TStringList but does NOT parse it.
    function  UIDRetrieveEnvelopeRaw(const AMsgUID: String; ADestList: TStringList): Boolean;
    //Returnes the message flag values.
    {CC: use "var" to get results returned}
    {function UIDRetrieveFlags (const AMsgUID: String; AFlags: TIdMessageFlagsSet): Boolean;}
    function  UIDRetrieveFlags (const AMsgUID: String; var AFlags: TIdMessageFlagsSet): Boolean;
    {CC2: Following added for retrieving individual parts of a message...}
    function  UIDInternalRetrieveStructure(const AMsgUID: String; AMsg: TIdMessage; AParts: TIdImapMessageParts): Boolean;
    //Retrieve only the message structure (this tells you what parts are in the message).
    function  UIDRetrieveStructure(const AMsgUID: String; AMsg: TIdMessage): Boolean; overload;
    function  UIDRetrieveStructure(const AMsgUID: String; AParts: TIdImapMessageParts): Boolean; overload;
    {CC2: Following added for retrieving individual parts of a message...}
    {Retrieve a specific individual part of a message}
    function  UIDRetrievePart(const AMsgUID: String; const APartNum: Integer;
      var ABuffer: PChar; var ABufferLength: Integer; AEncoding: string = 'text'): Boolean;  {Do not Localize}
    {CC2: Following added for retrieving individual parts of a message...}
    {Retrieve a specific individual part of a message}
    function  UIDRetrievePartPeek(const AMsgUID: String; const APartNum: Integer;
      var ABuffer: PChar; var ABufferLength: Integer; AEncoding: string = 'text'): Boolean;  {Do not Localize}
    {CC2: Following added for retrieving individual parts of a message...}
    {Retrieve a specific individual part of a message}
    function  UIDRetrievePartToFile(const AMsgUID: String; const APartNum: Integer;
      ALength: Integer; ADestFileNameAndPath: string; AEncoding: string): Boolean;
    {CC2: Following added for retrieving individual parts of a message...}
    {Retrieve a specific individual part of a message}
    function  UIDRetrievePartToFilePeek(const AMsgUID: String; const APartNum: Integer;
      ALength: Integer; ADestFileNameAndPath: string; AEncoding: string): Boolean;
    {CC3: Following added for retrieving the text-only part of a message...}
    function  UIDRetrieveText(const AMsgUID: String; var AText: string): Boolean;
    function  UIDRetrieveText2(const AMsgUID: String; var AText: string): Boolean;
    {CC3: Following added for retrieving the text-only part of a message...}
    function  UIDRetrieveTextPeek(const AMsgUID: String; var AText: string): Boolean;
    function  UIDRetrieveTextPeek2(const AMsgUID: String; var AText: string): Boolean;
    //Retrieves only the message header.
    function  UIDRetrieveHeader (const AMsgUID: String; AMsg: TIdMessage): Boolean;
    //Retrives the current selected mailbox size.
    function  UIDRetrieveMailBoxSize: Integer;
    //Returnes the message size.
    function  UIDRetrieveMsgSize(const AMsgUID: String): Integer;
    //Retrieves a whole message while keeping its Seen flag untucked    {Do not Localize}
    //(preserving the previous value).
    function  UIDRetrievePeek (const AMsgUID: String; AMsg: TIdMessage): Boolean;
    //Searches the current selected mailbox for messages matching the SearchRec and
    //returnes the results as UIDs to the mailbox SearchResults array.
    function  UIDSearchMailBox (const ASearchInfo: array of TIdIMAP4SearchRec{Array}): Boolean;//array of TIdIMAP4SearchRec ) : Boolean;
    //Changes (adds or removes) message flags.
    function  UIDStoreFlags (const AMsgUID: String; const AStoreMethod: TIdIMAP4StoreDataItem; const AFlags: TIdMessageFlagsSet): Boolean;
    //Removes the specified mailbox name from the server's set of "active" or "subscribed"    {Do not Localize}
    //mailboxes as returned by the LSUB command.
    function  UnsubscribeMailBox (const AMBName: String): Boolean;
    { TIdIMAP4 Commands }
    { IdTCPConnection Commands }
    procedure GetInternalResponse (const ATag: String); overload;
    procedure GetInternalResponse; overload;
    function  GetResponse(const ATag: String; const AAllowedResponses: array of SmallInt): SmallInt; reintroduce; overload;
    function  GetResponse(const AAllowedResponses: array of SmallInt): SmallInt; reintroduce; overload;
    function  GetLineResponse(const ATag: String; const AAllowedResponses: array of SmallInt): SmallInt;
    procedure GetInternalLineResponse (const ATag: String);
    procedure RemoveAnyAdditionalResponses;
    function  SendCmd(const ATag, AOut: string; const AResponse: SmallInt = -1): SmallInt; overload;
    function  SendCmd(const ATag, AOut: string; const AResponse: array of SmallInt): SmallInt; overload;
    function  ReadLnWait: string;
    procedure WriteLn(AOut: string); reintroduce;
  { IdTCPConnection Commands }
  published
    property  OnAlert: TIdAlertEvent read FOnAlert write FOnAlert;
    property  Password;
    property  RetrieveOnSelect: TIdRetrieveOnSelect read FRetrieveOnSelect write FRetrieveOnSelect default rsDisabled;
    property  Port default IdPORT_IMAP4;
    property  Username;
    property  MailBoxSeparator: Char read FMailBoxSeparator write FMailBoxSeparator default '/';    {Do not Localize}
  end;

implementation

uses
    IdEMailAddress,
    IdException,
    IdResourceStrings,
    IdTCPConnection;

type
  TIdIMAP4FetchDataItem =
  ( fdAll,           //Macro equivalent to: (FLAGS INTERNALDATE RFC822.SIZE ENVELOPE)
    fdBody,          //Non-extensible form of BODYSTRUCTURE.
    fdBodyExtensible,
    fdBodyPeek,
    fdBodyStructure, //The [MIME-IMB] body structure of the message.  This
                     //is computed by the server by parsing the [MIME-IMB]
                     //header fields in the [RFC-822] header and [MIME-IMB] headers.
    fdEnvelope,      //The envelope structure of the message.  This is
                     //computed by the server by parsing the [RFC-822]
                     //header into the component parts, defaulting various
                     //fields as necessary.
    fdFast,          //Macro equivalent to: (FLAGS INTERNALDATE RFC822.SIZE)
    fdFlags,         //The flags that are set for this message.
    fdFull,          //Macro equivalent to: (FLAGS INTERNALDATE RFC822.SIZE ENVELOPE BODY)
    fdInternalDate,  //The internal date of the message.
    fdRFC822,        //Functionally equivalent to BODY[], differing in the
                     //syntax of the resulting untagged FETCH data (RFC822
                     //is returned).
    fdRFC822Header,  //Functionally equivalent to BODY.PEEK[HEADER],
                     //differing in the syntax of the resulting untagged
                     //FETCH data (RFC822.HEADER is returned).
    fdRFC822Size,    //The [RFC-822] size of the message.
    fdRFC822Text,    //Functionally equivalent to BODY[TEXT], differing in
                     //the syntax of the resulting untagged FETCH data
                     //(RFC822.TEXT is returned).
    fdUID );         //The unique identifier for the message.

const
   IMAP4Commands : array [cmdCapability..cmdXCmd] of String =
   (
    { Client Commands - Any State}
        'CAPABILITY',       {Do not Localize}
        'NOOP',             {Do not Localize}
        'LOGOUT',           {Do not Localize}
    { Client Commands - Non Authenticated State}
        'AUTHENTICATE',     {Do not Localize}
        'LOGIN',            {Do not Localize}
    { Client Commands - Authenticated State}
        'SELECT',           {Do not Localize}
        'EXAMINE',          {Do not Localize}
        'CREATE',           {Do not Localize}
        'DELETE',           {Do not Localize}
        'RENAME',           {Do not Localize}
        'SUBSCRIBE',        {Do not Localize}
        'UNSUBSCRIBE',      {Do not Localize}
        'LIST',             {Do not Localize}
        'LSUB',             {Do not Localize}
        'STATUS',           {Do not Localize}
        'APPEND',           {Do not Localize}
    { Client Commands - Selected State}
        'CHECK',            {Do not Localize}
        'CLOSE',            {Do not Localize}
        'EXPUNGE',          {Do not Localize}
        'SEARCH',           {Do not Localize}
        'FETCH',            {Do not Localize}
        'STORE',            {Do not Localize}
        'COPY',             {Do not Localize}
        'UID',              {Do not Localize}
    { Client Commands - Experimental/ Expansion}
        'X'                 {Do not Localize}
    );

   IMAP4FetchDataItem : array [fdAll..fdUID] of String =
   ( 'ALL',             {Do not Localize}   //Macro equivalent to: (FLAGS INTERNALDATE RFC822.SIZE ENVELOPE)
     'BODY',            {Do not Localize}   //Non-extensible form of BODYSTRUCTURE.
     'BODY[%s]<%s>',    {Do not Localize}
     'BODY.PEEK[]',     {Do not Localize}
     'BODYSTRUCTURE',   {Do not Localize}   //The [MIME-IMB] body structure of the message.  This
                                            //is computed by the server by parsing the [MIME-IMB]
                                            //header fields in the [RFC-822] header and [MIME-IMB] headers.
     'ENVELOPE',        {Do not Localize}   //The envelope structure of the message.  This is
                                            //computed by the server by parsing the [RFC-822]
                                            //header into the component parts, defaulting various
                                            //fields as necessary.
     'FAST',            {Do not Localize}   //Macro equivalent to: (FLAGS INTERNALDATE RFC822.SIZE)
     'FLAGS',           {Do not Localize}   //The flags that are set for this message.
     'FULL',            {Do not Localize}   //Macro equivalent to: (FLAGS INTERNALDATE RFC822.SIZE ENVELOPE BODY)
     'INTERNALDATE',    {Do not Localize}   //The internal date of the message.
     'RFC822',          {Do not Localize}   //Functionally equivalent to BODY[], differing in the
                                            //syntax of the resulting untagged FETCH data (RFC822
                                            //is returned).
     'RFC822.HEADER',   {Do not Localize}   //Functionally equivalent to BODY.PEEK[HEADER],
                                            //differing in the syntax of the resulting untagged
                                            //FETCH data (RFC822.HEADER is returned).
     'RFC822.SIZE',     {Do not Localize}   //The [RFC-822] size of the message.
     'RFC822.TEXT',     {Do not Localize}   //Functionally equivalent to BODY[TEXT], differing in
                                            //the syntax of the resulting untagged FETCH data
                                            //(RFC822.TEXT is returned).
     'UID' );           {Do not Localize}   //The unique identifier for the message.


   IMAP4SearchKeys : array [skAll..skUnseen] of String =
   ( 'ALL',         {Do not Localize}   //All messages in the mailbox; the default initial key for ANDing.
     'ANSWERED',    {Do not Localize}   //Messages with the \Answered flag set.
     'BCC',         {Do not Localize}   //Messages that contain the specified string in the envelope structure's BCC field.
     'BEFORE',      {Do not Localize}   //Messages whose internal date is earlier than the specified date.
     'BODY',        {Do not Localize}   //Messages that contain the specified string in the body of the message.
     'CC',          {Do not Localize}   //Messages that contain the specified string in the envelope structure's CC field.
     'DELETED',     {Do not Localize}   //Messages with the \Deleted flag set.
     'DRAFT',       {Do not Localize}   //Messages with the \Draft flag set.
     'FLAGGED',     {Do not Localize}   //Messages with the \Flagged flag set.
     'FROM',        {Do not Localize}   //Messages that contain the specified string in the envelope structure's FROM field.
     'HEADER',      {Do not Localize}   //Messages that have a header with the specified field-name (as defined in [RFC-822])
                                        //and that contains the specified string in the [RFC-822] field-body.
     'KEYWORD',     {Do not Localize}   //Messages with the specified keyword set.
     'LARGER',      {Do not Localize}   //Messages with an [RFC-822] size larger than the specified number of octets.
     'NEW',         {Do not Localize}   //Messages that have the \Recent flag set but not the \Seen flag.
                                        //This is functionally equivalent to "(RECENT UNSEEN)".
     'NOT',         {Do not Localize}   //Messages that do not match the specified search key.
     'OLD',         {Do not Localize}   //Messages that do not have the \Recent flag set. This is functionally
                                        //equivalent to "NOT RECENT" (as opposed to "NOT NEW").
     'ON',          {Do not Localize}   //Messages whose internal date is within the specified date.
     'OR',          {Do not Localize}   //Messages that match either search key.
     'RECENT',      {Do not Localize}   //Messages that have the \Recent flag set.
     'SEEN',        {Do not Localize}   //Messages that have the \Seen flag set.
     'SENTBEFORE',  {Do not Localize}   //Messages whose [RFC-822] Date: header is earlier than the specified date.
     'SENTON',      {Do not Localize}   //Messages whose [RFC-822] Date: header is within the specified date.
     'SENTSINCE',   {Do not Localize}   //Messages whose [RFC-822] Date: header is within or later than the specified date.
     'SINCE',       {Do not Localize}   //Messages whose internal date is within or later than the specified date.
     'SMALLER',     {Do not Localize}   //Messages with an [RFC-822] size smaller than the specified number of octets.
     'SUBJECT',     {Do not Localize}   //Messages that contain the specified string in the envelope structure's SUBJECT field.
     'TEXT',        {Do not Localize}   //Messages that contain the specified string in the header or body of the message.
     'TO',          {Do not Localize}   //Messages that contain the specified string in the envelope structure's TO field.
     'UID',         {Do not Localize}   //Messages with unique identifiers corresponding to the specified unique identifier set.
     'UNANSWERED',  {Do not Localize}   //Messages that do not have the \Answered flag set.
     'UNDELETED',   {Do not Localize}   //Messages that do not have the \Deleted flag set.
     'UNDRAFT',     {Do not Localize}   //Messages that do not have the \Draft flag set.
     'UNFLAGGED',   {Do not Localize}   //Messages that do not have the \Flagged flag set.
     'UNKEYWORD',   {Do not Localize}   //Messages that do not have the specified keyword set.
     'UNSEEN' );    {Do not Localize}

   IMAP4StoreDataItem : array [sdReplace..sdRemoveSilent] of String =
   ( 'FLAGS',               {Do not Localize}
     'FLAGS.SILENT',        {Do not Localize}
     '+FLAGS',              {Do not Localize}
     '+FLAGS.SILENT',       {Do not Localize}
     '-FLAGS',              {Do not Localize}
     '-FLAGS.SILENT' );     {Do not Localize}

   IMAP4StatusDataItem : array [mdMessages..mdUnseen] of String =
   ( 'MESSAGES',            {Do not Localize}
     'RECENT',              {Do not Localize}
     'UIDNEXT',             {Do not Localize}
     'UIDVALIDITY',         {Do not Localize}
     'UNSEEN' );            {Do not Localize}

{ TIdImapSubSection }

constructor TIdImapSubSection.Create;
begin
    {Make sure this are initialised properly...}
    FSubSection := nil;
end;

{ TIdImapMessageParts }

constructor TIdImapMessagePart.Create(Collection: TCollection);
begin
    {Make sure these are initialised properly...}
    inherited Create(Collection);
    FSubSection := nil;
    FBoundary := '';  {Do not Localize}
end;

destructor TIdImapMessagePart.Destroy;
var
    LSection, LPtr, LPtr2: TIdImapSubSection;
begin
    {Destroy any subsections from the bottom up...}
    while FSubSection <> nil do begin
        LSection := nil;
        LPtr := FSubSection;
        if LPtr <> nil then begin
            LPtr2 := LPtr.FSubSection;
            while LPtr2 <> nil do begin
                LSection := LPtr;
                LPtr := LPtr2;
                LPtr2 := LPtr.FSubSection;
            end;
            {We are at the bottom...}
            LPtr.Destroy;
            if LSection <> nil then begin
                LSection.FSubSection := nil;
            end else begin
                FSubSection := nil;
            end;
        end;
    end;
    inherited Destroy;
end;

function TIdImapMessageParts.GetItem(Index: Integer): TIdImapMessagePart;
begin
    Result := TIdImapMessagePart(inherited GetItem(Index));
end;

function TIdImapMessageParts.Add: TIdImapMessagePart;
begin
    Result := TIdImapMessagePart(inherited Add);
end;

procedure TIdImapMessageParts.SetItem(Index: Integer; const Value: TIdImapMessagePart);
begin
    inherited SetItem(Index, Value);
end;

{ TIdIMAP4 }

function TIdIMAP4.IsNumberValid(const ANumber: Integer): Boolean;
    {CC3: Need to validate message numbers (relative and UIDs), because otherwise
    the routines wait for a response that never arrives and so functions never return.}
begin
    if ANumber < 1 then begin
        raise EIdNumberInvalid.Create('Number passed as parameter is invalid, must be 1 or greater');
    end;
    Result := True;
end;

function TIdIMAP4.IsUIDValid(const AUID: string): Boolean;
    {CC3: Need to validate message numbers (relative and UIDs), because otherwise
    the routines wait for a response that never arrives and so functions never return.}
var
    LN: integer;
begin
    if AUID = '' then begin  {Do not Localize}
        raise EIdNumberInvalid.Create('Empty string passed as UID');
    end;
    for LN := 1 to length(AUID) do begin
        if ( (Ord(AUID[LN]) < Ord('0')) or (Ord(AUID[LN]) > Ord('9')) ) then begin  {Do not Localize}
            raise EIdNumberInvalid.Create('UID passed as parameter is invalid, contains non-digit');
        end;
    end;
    if StrToInt(AUID) < 1 then begin
        raise EIdNumberInvalid.Create('UID passed as parameter is invalid, must be 1 or greater');
    end;
    Result := True;
end;

function  TIdIMAP4.GetUID(const AMsgNum: Integer; var AUID: string): Boolean;
{This gets the message UID from the message relative number.  Based on the code
in "function TIdIMAP4.CheckMsgSeen(const AMsgNum: Integer): Boolean;"}
var
  Ln : Integer;
  LSlRetrieve : TStringList;
begin
    Result := False;
    AUID := '';  {Do not Localize}
    IsNumberValid(AMsgNum);

    if (FConnectionState = csSelected) then begin
        {Some servers return NO if the requested message number is not present
        (e.g. Cyrus), others return OK but no data (CommuniGate).}
        SendCmd(NewCmdCounter, (IMAP4Commands[cmdFetch] + ' ' + IntToStr(AMsgNum) + {Do not Localize}
          ' (' + IMAP4FetchDataItem[fdUID] + ')' ), [wsOk,wsNO]);                   {Do not Localize}
        if (LastCmdResult.NumericCode = wsOk) then begin
            for Ln := 0 to (LastCmdResult.Text.Count - 1) do begin
                LSlRetrieve := TStringList.Create;
                try
                    BreakApart(LastCmdResult.Text[Ln], ' ', LSlRetrieve);           {Do not Localize}
                    if LSlRetrieve.Count > 3 then begin
                        if (AnsiSameText(LSlRetrieve[0], IntToStr(AMsgNum)) and
                          AnsiSameText(LSlRetrieve[1], IMAP4Commands[cmdFetch]) and
                          AnsiSameText(LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdUID])) then begin {Do not Localize}
                            Result := True;
                            AUID := Copy(LSlRetrieve[3], 1, Pos(')', LSlRetrieve[3])-1); {Do not Localize}
                        end;
                    end;
                finally
                    LSlRetrieve.Free;
                end;
            end;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt(RSIMAP4ConnectionStateError, [GetConnectionStateName]);
    end;
end;


procedure TIdIMAP4.WriteLn(AOut: string);
begin
        inherited WriteLn(AOut);
end;

function  TIdIMAP4.ReadLnWait: string;
var sLine: string;
begin
        sLine := inherited ReadLnWait;    {This can have hit an exception of Connection Reset By Peer (timeout)}
    Result := sLine;
end;

{ IdTCPConnection Commands... }


function TIdIMAP4.GetResponse(const ATag: String; const AAllowedResponses: array of SmallInt): SmallInt;
begin
    GetInternalResponse (ATag);
    TaggedReplyConvertToConst;
    Result := CheckResponse(LastCmdResult.NumericCode, AAllowedResponses);
end;

function TIdIMAP4.GetResponse(const AAllowedResponses: array of SmallInt): SmallInt;
begin
    GetInternalResponse;
    {CC7: Following moved to IdReplyIMAP4...}
  {  case PosInStrarray(LastCmdResult.Code,VALID_UNTAGGEDREPLIES) of
        0 : LastCmdResult.NumericCode := wsOK;      {* OK}
  {      1 : LastCmdResult.NumericCode := wsNo;      {* NO}
  {      2 : LastCmdResult.NumericCode := wsBAD;     {* BAD}
  {      3 : LastCmdResult.NumericCode := wsPreAuth; {* PREAUTH}
  {      4 : LastCmdResult.NumericCode := wsBYE;     {* BYE}
  {      5 : LastCmdResult.NumericCode := wsContinue;{* +}
  {    else
  {      raise EIdException.Create(RSUnrecognizedIMAP4ResponseHeader);
    end;
  }
    {Result := CompareResponse2(LastCmdResult.Code, ['OK', '+']);}
  //  Result := LastCmdResult.NumericCode;
    case PosInStrarray(LastCmdResult.TextCode,VALID_UNTAGGEDREPLIES) of
        0 : LastCmdResult.NumericCode := wsOK;      {* OK}
        1 : LastCmdResult.NumericCode := wsNo;      {* NO}
        2 : LastCmdResult.NumericCode := wsBAD;     {* BAD}
        3 : LastCmdResult.NumericCode := wsPreAuth; {* PREAUTH}
        4 : LastCmdResult.NumericCode := wsBYE;     {* BYE}
        5 : LastCmdResult.NumericCode := wsContinue;{* +}
      else
        raise EIdException.Create(RSUnrecognizedIMAP4ResponseHeader);
    end;
    Result := CheckResponse(LastCmdResult.NumericCode, AAllowedResponses);
end;


function TIdIMAP4.GetLineResponse(const ATag: String; const AAllowedResponses: array of SmallInt): SmallInt;
begin
    GetInternalLineResponse (ATag);
    TaggedReplyConvertToConst;
    Result := CheckResponse(LastCmdResult.NumericCode, AAllowedResponses);
end;

procedure TIdIMAP4.GetInternalResponse (const ATag: String);
var LLine: String;
    LResponse: TStringList;
begin
    LResponse := TStringList.Create;
    try
        LLine := ReadLnWait;
        LResponse.Add(LLine);
        if ( LLine[1] = '*' ) then begin {Do not Localize} //Untagged response
            // Multi line response coming
            repeat
                LLine := ReadLnWait;
                LResponse.Add(LLine);
            until ( AnsiSameText (Copy (LLine, 1, Length (ATag)), ATag) );
        end;
        ParseResponse(ATag, LResponse);
        RemoveAnyAdditionalResponses;
    finally
        FreeAndNil (LResponse);
    end;
end;

procedure TIdIMAP4.GetInternalResponse;
var LLine: String;
    LResponse: TStringList;
begin
    LResponse := TStringList.Create;
    try
        LLine := ReadLnWait;
        LResponse.Add(LLine);
        ParseResponse(LResponse);
        RemoveAnyAdditionalResponses;
    finally
        FreeAndNil (LResponse);
    end;
end;

procedure TIdIMAP4.GetInternalLineResponse (const ATag: String);
var LLine: String;
    LResponse: TStringList;
begin
    LResponse := TStringList.Create;
    try
        LLine := ReadLnWait;
        LResponse.Add(LLine);
        if ( LLine[1] = '*' ) then begin {Do not Localize} //Untagged response
        end else begin // Maybe multi line response coming
            while not AnsiSameText (Copy (LLine, 1, Length (ATag)), ATag) do begin
                LLine := ReadLnWait;
                LResponse.Add(LLine);
            end;
        end;
        ParseLineResponse(ATag, LResponse);
        RemoveAnyAdditionalResponses;
    finally
        FreeAndNil (LResponse);
    end;
end;

procedure TIdIMAP4.RemoveAnyAdditionalResponses;
{CC8: Try to clean out any additional responses sent AFTER the result code,
e.g. a line like "* BAD parameter" after "C41 BAD" or whatever...}
var LLine: string;
    nChars: integer;
begin
    Exit;  {Does not work}
    nChars := InputBuffer.Size;
    while nChars > 0 {IOHandler.InternalBufferIsEmpty = False} do begin
        LLine := ReadLnWait;
        nChars := InputBuffer.Size;
    end;
end;


function TIdIMAP4.SendCmd(const ATag, AOut: string; const AResponse: array of SmallInt): SmallInt;
begin
    if ( AOut <> #0 ) then begin
        {CC3: Catch "Connection reset by peer"...}
        try
            WriteLn ( ATag + ' ' + AOut ); {Do not Localize}
        except
            //on E: Exception do begin
            on e:EIdSocketError do begin
                if e.LastError = 10054 then begin
                    //Connection reset by peer...
                    FConnectionState := csUnexpectedlyDisconnected;
                    raise;
                end;
            end;
        end;
    end;
    Result := GetResponse ( ATag, AResponse );
end;

function TIdIMAP4.SendCmd(const ATag, AOut: string; const AResponse: SmallInt): SmallInt;
begin
    if ( AResponse = -1 ) then begin
        result := SendCmd ( ATag, AOut, [] );
    end else begin
        result := SendCmd ( ATag, AOut, [AResponse] );
    end;
end;

{ ...IdTCPConnection Commands }

procedure TIdIMAP4.DoAlert(const AMsg: String);
begin
    if Assigned(OnAlert) then begin
        OnAlert(Self, AMsg);
    end;
end;

procedure TIdIMAP4.SetMailBox(const Value: TIdMailBox);
begin
    FMailBox.Assign(Value);
end;

procedure TIdIMAP4.Connect(const ATimeout: Integer = IdTimeoutDefault);
begin
    {CC2: Need to set FConnectionState to csNonAuthenticated here.  If not, then
    an unsuccessful connect after a previous successful connect (such as when a
    client program changes users) can leave it as csAuthenticated.}
    FConnectionState := csNonAuthenticated;
    {CC2: Don't call Connect if already connected, this could be just a change of user}
    if Connected = False then begin
        inherited Connect(ATimeout);
    end;
    try
        GetResponse ( [wsOk, wsPreAuth] );
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            FConnectionState := csNonAuthenticated;
            FCmdCounter := 0;
            if Password <> '' then begin  {Do not Localize}
                SendCmd ( NewCmdCounter, IMAP4Commands[cmdLogin] + ' ' + Username + ' ' + Password, wsOk ); {Do not Localize}
            end else begin
                SendCmd ( NewCmdCounter, IMAP4Commands[cmdLogin] + ' ' + Username, wsOk ); {Do not Localize}
            end;
            if ( LastCmdResult.NumericCode = wsOk ) then begin
                FConnectionState := csAuthenticated;
            end;
        end else if ( LastCmdResult.NumericCode = wsPreAuth ) then begin
            FConnectionState := csAuthenticated;
            FCmdCounter := 0;
        end;
    except
        Disconnect;
        raise;
    end;
end;

constructor TIdIMAP4.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FMailBox := TIdMailBox.Create (Self);
    Port := IdPORT_IMAP4;
    FCmdCounter := 0;
    FConnectionState := csNonAuthenticated;
    FRetrieveOnSelect := rsDisabled;
    {CC2: FMailBoxSeparator is now detected when a mailbox is selected, following
    line is probably redundant, but leave it there just in case.}
    FMailBoxSeparator := '/';    {Do not Localize}
end;

procedure TIdIMAP4.Disconnect;
begin
    //Available in any state.
    if Connected then begin
        try
            SendCmd ( NewCmdCounter, IMAP4Commands[cmdLogout], wsOk );
        finally
            inherited;
            FConnectionState := csNonAuthenticated;
        end;
    end else begin
        raise EIdClosedSocket.Create ( RSStatusDisconnected );
    end;
end;

procedure TIdIMAP4.KeepAlive;
begin
    //Avialable in any state.
    SendCmd(NewCmdCounter, IMAP4Commands[cmdNoop], wsOk);
end;

function TIdIMAP4.IsCapabilityListed(ACapability: string):Boolean;
var
    LCapabilities: TStringList;
    LN: Integer;
begin
    Result := False;
    LCapabilities := TStringList.Create;
    if Capability(LCapabilities) = False then begin
        LCapabilities.Destroy;
        Exit;
    end;
    for LN := 0 to LCapabilities.Count-1 do begin
        if UpperCase(ACapability) = UpperCase(LCapabilities.Strings[LN]) then begin
            Result := True;
            LCapabilities.Destroy;
            Exit;
        end;
    end;
    LCapabilities.Destroy;
end;


function TIdIMAP4.Capability(ASlCapability: TStrings): Boolean;
begin
    //Available in any state.
    Result := False;
    SendCmd ( NewCmdCounter, (IMAP4Commands[CmdCapability]), wsOk);
    if ( LastCmdResult.NumericCode = wsOk ) and Assigned (ASlCapability) then begin
        ASlCapability.Clear;
        BreakApart ( LastCmdResult.Text[0], ' ', ASlCapability ); {Do not Localize}
        ASlCapability.Delete(0);
        Result := True;
    end;
end;

function TIdIMAP4.GetCmdCounter: String;
begin
    Result := 'C' + IntToStr ( FCmdCounter ); {Do not Localize}
end;

function TIdIMAP4.GetNewCmdCounter: String;
begin
    Inc ( FCmdCounter );
    Result := 'C' + IntToStr ( FCmdCounter ); {Do not Localize}
end;

destructor TIdIMAP4.Destroy;
begin
    {CC2: Disconnect before we die}
    {CC7: Added "if Connected then" }
    if Connected then begin
        Disconnect;
    end;
    FreeAndNil(FMailBox);
    inherited;
end;

function TIdIMAP4.SelectMailBox(const AMBName: String): Boolean;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdSelect] + ' "' + AMBName + '"' ), wsOk); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            //Put the parse in the IMAP Class and send the MB;
            ParseSelectResult (FMailBox, LastCmdResult.Text );
            FMailBox.Name := AMBName;
            FConnectionState := csSelected;
            case RetrieveOnSelect of
                rsHeaders: RetrieveAllHeaders ( FMailBox.MessageList );
                rsMessages: RetrieveAllMsgs ( FMailBox.MessageList );
            end;
            {CC2: Only return TRUE if get to here...}
            Result := True; {LastCmdResult.NumericCode = wsOk;}
        end else begin
            FConnectionState := csAuthenticated;
        end;
    end else begin
        FConnectionState := csAuthenticated;
        raise EIdConnectionStateError.CreateFmt(RSIMAP4ConnectionStateError, [GetConnectionStateName]);
    end;
end;

function TIdIMAP4.ExamineMailBox(const AMBName: String; AMB: TIdMailBox): Boolean;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdExamine] + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            ParseSelectResult (AMB, LastCmdResult.Text );
            AMB.Name := AMBName;
            {CC2: Only return TRUE if get to here...}
            Result := True;
        end;
     end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.CloseMailBox: Boolean;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, IMAP4Commands[cmdClose], wsOk );
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            MailBox.Clear;
            FConnectionState := csAuthenticated;
            {CC2: Only return TRUE if get to here...}
            Result := True; {LastCmdResult.NumericCode = wsOk;}
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.CreateMailBox(const AMBName: String): Boolean;
begin
    {CC5: Recode to return False if NO returned rather than throwing an exception...}
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        {CC5: The NO response is typically due to Permission Denied}
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdCreate] + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.DeleteMailBox(const AMBName: String): Boolean;
begin
    {CC5: Recode to return False if NO returned rather than throwing an exception...}
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        {CC5: The NO response is typically due to Permission Denied}
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdDelete] + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.RenameMailBox(const AOldMBName, ANewMBName: String): Boolean;
begin
    {CC5: Recode to return False if NO returned rather than throwing an exception...}
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        {CC5: The NO response is typically due to Permission Denied}
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdRename] + ' "' +    {Do not Localize}
          AOldMBName + '" "' + ANewMBName + '"' ), [wsOk,wsNO]);        {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.StatusMailBox(const AMBName: String; AMB: TIdMailBox): Boolean;
    {CC2: It is pointless calling StatusMailBox with AStatusDataItems set to []
    because you are asking the IMAP server to update none of the status flags.
    Instead, if called with no AStatusDataItems specified, use the standard flags
    returned by SelectMailBox, which allows the user to easily check if the mailbox
    has changed.  Overload the functions, since AStatusDataItems cannot be set
    to nil.}
var
    AStatusDataItems: array[1..5] of TIdIMAP4StatusDataItem;
begin
    AStatusDataItems[1] := mdMessages;
    AStatusDataItems[2] := mdRecent;
    AStatusDataItems[3] := mdUIDNext;
    AStatusDataItems[4] := mdUIDValidity;
    AStatusDataItems[5] := mdUnseen;
    Result := StatusMailBox(AMBName, AMB, AStatusDataItems);
end;

function TIdIMAP4.StatusMailBox(const AMBName: String; AMB: TIdMailBox; const AStatusDataItems: array of TIdIMAP4StatusDataItem): Boolean;
var LDataItems : String;
    Ln : Integer;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        for Ln := Low ( AStatusDataItems ) to High ( AStatusDataItems ) do begin
            case AStatusDataItems[Ln] of
                mdMessages: LDataItems := LDataItems + IMAP4StatusDataItem[mdMessages] + ' ';       {Do not Localize}
                mdRecent: LDataItems := LDataItems + IMAP4StatusDataItem[mdRecent] + ' ';           {Do not Localize}
                mdUIDNext: LDataItems := LDataItems + IMAP4StatusDataItem[mdUIDNext] + ' ';         {Do not Localize}
                mdUIDValidity: LDataItems := LDataItems + IMAP4StatusDataItem[mdUIDValidity] + ' '; {Do not Localize}
                mdUnseen: LDataItems := LDataItems + IMAP4StatusDataItem[mdUnseen] + ' ';           {Do not Localize}
            end;
        end;
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdStatus] + ' "' + AMBName + '" (' +              {Do not Localize}
          Trim ( LDataItems ) + ')' ), [wsOk,wsNO]);                                                {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            ParseStatusResult ( AMB, LastCmdResult.Text );
            {CC2: Only return TRUE if get to here...}
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.CheckMailBox: Boolean;
begin
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, IMAP4Commands[cmdCheck], wsOk);
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            Result := True; {LastCmdResult.NumericCode = wsOk;}
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.ExpungeMailBox: Boolean;
begin
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, IMAP4Commands[cmdExpunge], wsOk);
        if ( LastCmdResult.NumericCode = wsOk ) then begin
             ParseExpungeResult ( FMailBox, LastCmdResult.Text );
             Result := True; {LastCmdResult.NumericCode = wsOk;}
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.SearchMailBox(
  const ASearchInfo: array of TIdIMAP4SearchRec{Array} ) : Boolean;
var LSearchStr : String;
    Ln : Integer;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    for Ln := Low ( ASearchInfo ) to High ( ASearchInfo ) do
        case ASearchInfo[Ln].SearchKey of
            skAnswered:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skAnswered] + ' ';                                                       {Do not Localize}
            skBcc:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skBcc] + ' "' + ASearchInfo[Ln].Text + '" ';                             {Do not Localize}
            skBefore:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skBefore] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';      {Do not Localize}
            skBody:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skBody] + ' "' + ASearchInfo[Ln].Text + '" ';                            {Do not Localize}
            skCc:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skCc] + ' "' + ASearchInfo[Ln].Text + '" ';                              {Do not Localize}
            skDeleted:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skDeleted] + ' ';                                                        {Do not Localize}
            skDraft:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skDraft] + ' ';                                                          {Do not Localize}
            skFlagged:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skFlagged] + ' ';                                                        {Do not Localize}
            skFrom:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skFrom] + ' "' + ASearchInfo[Ln].Text + '" ';                            {Do not Localize}
            skLarger:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skLarger] + ' ' + IntToStr ( ASearchInfo[Ln].Size ) + ' ';               {Do not Localize}
            skNew:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skNew] + ' ';                                                            {Do not Localize}
            skNot:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skNot] + ' ';                                                            {Do not Localize}
            skOld:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skOld] + ' ';                                                            {Do not Localize}
            skOn:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skOn] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';          {Do not Localize}
            skOr:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skOr] + ' ';                                                             {Do not Localize}
            skRecent:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skRecent] + ' ';                                                         {Do not Localize}
            skSeen:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSeen] + ' ';                                                           {Do not Localize}
            skSentBefore:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSentBefore] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';  {Do not Localize}
            skSentOn:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSentOn] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';      {Do not Localize}
            skSentSince:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSentSince] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';   {Do not Localize}
            skSince:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSince] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';       {Do not Localize}
            skSmaller:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSmaller] + ' ' + IntToStr ( ASearchInfo[Ln].Size ) + ' ';              {Do not Localize}
            skSubject:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSubject] + ' "' + ASearchInfo[Ln].Text + '" ';                         {Do not Localize}
            skText:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skText] + ' "' + ASearchInfo[Ln].Text + '" ';                            {Do not Localize}
            skTo:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skTo] + ' "' + ASearchInfo[Ln].Text + '" ';                              {Do not Localize}
            skUID:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUID] + ' ' + ASearchInfo[Ln].Text + ' ';                               {Do not Localize}
            skUnanswered:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUnanswered] + ' ';                                                     {Do not Localize}
            skUndeleted:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUndeleted] + ' ';                                                      {Do not Localize}
            skUndraft:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUndraft] + ' ';                                                        {Do not Localize}
            skUnflagged:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUnflagged] + ' ';                                                      {Do not Localize}
            skUnKeyWord:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUnKeyWord] + ' ';                                                      {Do not Localize}
            skUnseen:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUnseen] + ' ';                                                         {Do not Localize}
        end;
    if ( FConnectionState = csSelected ) then begin
        {CC9: Some servers (e.g. web.de) don't implement search, so added wsBad...}
        {SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdSearch] + ' ' + Trim (LSearchStr) ), [wsOk,wsNO] ); {Do not Localize}
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdSearch] + ' ' + Trim (LSearchStr) ), [wsOk,wsNO,wsBAD] ); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            ParseSearchResult (FMailBox, LastCmdResult.Text);
            {CC2: Only return TRUE if get to here...}
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UIDSearchMailBox(const ASearchInfo: array of TIdIMAP4SearchRec) : Boolean;
var LSearchStr : String;
    Ln : Integer;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    for Ln := Low ( ASearchInfo ) to High ( ASearchInfo ) do
        case ASearchInfo[Ln].SearchKey of
            skAnswered:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skAnswered] + ' ';                                                   {Do not Localize}
            skBcc:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skBcc] + ' "' + ASearchInfo[Ln].Text + '" ';                         {Do not Localize}
            skBefore:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skBefore] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';  {Do not Localize}
            skBody:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skBody] + ' "' + ASearchInfo[Ln].Text + '" ';                        {Do not Localize}
            skCc:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skCc] + ' "' + ASearchInfo[Ln].Text + '" ';                          {Do not Localize}
            skDeleted:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skDeleted] + ' ';                                                    {Do not Localize}
            skDraft:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skDraft] + ' ';                                                      {Do not Localize}
            skFlagged:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skFlagged] + ' ';                                                    {Do not Localize}
            skFrom:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skFrom] + ' "' + ASearchInfo[Ln].Text + '" ';                        {Do not Localize}
            //skHeader: //Need to check
            //skKeyword: //Need to check
            skLarger:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skLarger] + ' ' + IntToStr ( ASearchInfo[Ln].Size ) + ' '; {Do not Localize}
            skNew:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skNew] + ' '; {Do not Localize}
            skNot:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skNot] + ' '; {Do not Localize}
            skOld:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skOld] + ' '; {Do not Localize}
            skOn:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skOn] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' '; {Do not Localize}
            skOr:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skOr] + ' '; {Do not Localize}
            skRecent:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skRecent] + ' '; {Do not Localize}
            skSeen:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSeen] + ' '; {Do not Localize}
            skSentBefore:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSentBefore] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';  {Do not Localize}
            skSentOn:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSentOn] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';      {Do not Localize}
            skSentSince:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSentSince] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';   {Do not Localize}
            skSince:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSince] + ' ' + DateToIMAPDateStr ( ASearchInfo[Ln].Date ) + ' ';       {Do not Localize}
            skSmaller:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSmaller] + ' ' + IntToStr ( ASearchInfo[Ln].Size ) + ' ';              {Do not Localize}
            skSubject:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skSubject] + ' "' + ASearchInfo[Ln].Text + '" ';                         {Do not Localize}
            skText:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skText] + ' "' + ASearchInfo[Ln].Text + '" ';                            {Do not Localize}
            skTo:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skTo] + ' "' + ASearchInfo[Ln].Text + '" ';                              {Do not Localize}
            skUID:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUID] + ' ' + ASearchInfo[Ln].Text + ' ';                               {Do not Localize}
            skUnanswered:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUnanswered] + ' ';                                                     {Do not Localize}
            skUndeleted:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUndeleted] + ' ';                                                      {Do not Localize}
            skUndraft:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUndraft] + ' ';                                                        {Do not Localize}
            skUnflagged:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUnflagged] + ' ';                                                      {Do not Localize}
            skUnKeyWord:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUnKeyWord] + ' ';                                                      {Do not Localize}
            skUnseen:
            LSearchStr := LSearchStr + IMAP4SearchKeys[skUnseen] + ' ';                                                         {Do not Localize}
        end;
    if ( FConnectionState = csSelected ) then begin
        {CC9: Some servers (e.g. web.de) don't implement search, so added wsBad...}
        {SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdSearch] + ' ' + Trim (LSearchStr) ), [wsOk,wsNO] ); {Do not Localize}
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdSearch] + ' ' + Trim (LSearchStr) ), [wsOk,wsNO,wsBAD] ); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            ParseSearchResult (FMailBox, LastCmdResult.Text);
            {CC2: Only return TRUE if get to here...}
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.SubscribeMailBox(const AMBName: String): Boolean;
begin
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        SendCmd ( NewCmdCounter, (
        IMAP4Commands[cmdSubscribe] + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UnsubscribeMailBox(const AMBName: String): Boolean;
begin
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        SendCmd ( NewCmdCounter, (
          IMAP4Commands[cmdUnsubscribe] + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.ListMailBoxes(AMailBoxList: TStringList): Boolean;
begin
    Result := False;
    {CC2: This is one of the few cases where the server can return only "OK completed"
    meaning that the user has no mailboxes.}
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdList] + ' "" *' ), wsOk ); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            ParseListResult ( AMailBoxList, LastCmdResult.Text );
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.ListInferiorMailBoxes(AMailBoxList, AInferiorMailBoxList: TStringList): Boolean;
var Ln : Integer;
    LAuxMailBoxList : TStringList;
begin
    Result := False;
    {CC2: This is one of the few cases where the server can return only "OK completed"
    meaning that the user has no inferior mailboxes.}
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        if ( AMailBoxList = nil ) then begin
            SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdList] + ' "" %' ), wsOk ); {Do not Localize}
            if ( LastCmdResult.NumericCode = wsOk ) then begin
                ParseListResult ( AInferiorMailBoxList, LastCmdResult.Text );
                //The INBOX mailbox is added because I think it always has to exist
                //in an IMAP4 account (default) but it does not list it in this command.
                {AInferiorMailBoxList.Add ( 'INBOX' ); {Do not Localize}
                Result := True;
            end;
        end else begin
            LAuxMailBoxList := TStringList.Create;
            try
                AInferiorMailBoxList.Clear;
                for Ln := 0 to ( AMailBoxList.Count - 1 ) do begin
                    SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdList] + ' "" "' + {Do not Localize}
                      AMailBoxList[Ln] + FMailBoxSeparator + '%"' ), wsOk ); {Do not Localize}
                    if ( LastCmdResult.NumericCode = wsOk ) then begin
                        ParseListResult ( LAuxMailBoxList, LastCmdResult.Text );
                        AInferiorMailBoxList.AddStrings ( LAuxMailBoxList );
                        Result := True;
                    end else begin
                        Break;
                    end;
                end;
            finally
                LAuxMailBoxList.Free;
            end;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.ListSubscribedMailBoxes(AMailBoxList: TStringList): Boolean;
begin
    {CC2: This is one of the few cases where the server can return only "OK completed"
    meaning that the user has no subscribed mailboxes.}
    Result := False;
    if ((FConnectionState = csAuthenticated) or (FConnectionState = csSelected)) then begin
        SendCmd(NewCmdCounter, (IMAP4Commands[cmdLSub] + ' "" *'), wsOk); {Do not Localize}
        if (LastCmdResult.NumericCode = wsOk) then begin
            // ds - fixed bug # 506026
            ParseLSubResult(AMailBoxList, LastCmdResult.Text);
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt(RSIMAP4ConnectionStateError, [GetConnectionStateName]);
    end;
end;

function TIdIMAP4.StoreFlags(const AMsgNumList: array of Integer;
  const AStoreMethod: TIdIMAP4StoreDataItem; const AFlags: TIdMessageFlagsSet): Boolean;
var LDataItem,
    LMsgSet,
    LFlags : String;
begin
    Result := False;
    if ( Length ( AMsgNumList ) = 0 ) then begin
         Exit;
    end;
    LMsgSet := ArrayToNumberStr ( AMsgNumList );
    case AStoreMethod of
        sdReplace: LDataItem := IMAP4StoreDataItem[sdReplaceSilent];
        sdAdd: LDataItem := IMAP4StoreDataItem[sdAddSilent];
        sdRemove: LDataItem := IMAP4StoreDataItem[sdRemoveSilent];
    end;
    LFlags := MessageFlagSetToStr(AFlags);
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdStore] + ' ' + LMsgSet + ' ' + {Do not Localize}
          LDataItem + ' (' + Trim ( LFlags ) + ')' ), [wsOk,wsNO]); {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UIDStoreFlags (const AMsgUID: String;
  const AStoreMethod: TIdIMAP4StoreDataItem; const AFlags: TIdMessageFlagsSet): Boolean;
var LDataItem,
    LFlags : String;
begin
    Result := False;
    IsUIDValid(AMsgUID);
    case AStoreMethod of
        sdReplace: LDataItem := IMAP4StoreDataItem[sdReplaceSilent];
        sdAdd: LDataItem := IMAP4StoreDataItem[sdAddSilent];
        sdRemove: LDataItem := IMAP4StoreDataItem[sdRemoveSilent];
    end;
    LFlags := MessageFlagSetToStr(AFlags);
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdStore] + ' ' +    {Do not Localize}
          AMsgUID + ' ' + LDataItem + ' (' + Trim ( LFlags ) + ')' ), [wsOk,wsNO]); {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.CopyMsgs(const AMsgNumList: array of Integer; const AMBName: String): Boolean;
var LMsgSet : String;
begin
    Result := False;
    if ( Length ( AMsgNumList ) = 0 ) then begin
        Exit;
    end;
    LMsgSet := ArrayToNumberStr ( AMsgNumList );
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdCopy] + ' ' + LMsgSet + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UIDCopyMsgs(const AMsgUIDList: TStringList; const AMBName: String): Boolean;
var LCmd : String;
    LN: integer;
begin
    Result := False;
    if ( AMsgUIDList.Count = 0 ) then begin
        Exit;
    end;
    LCmd := IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdCopy] + ' ';  {Do not Localize}
    for LN := 0 to AMsgUIDList.Count-1 do begin
        if LN = 0 then begin
            LCmd := LCmd + AMsgUIDList.Strings[LN];
        end else begin
            LCmd := LCmd + ',' + AMsgUIDList.Strings[LN];  {Do not Localize}
        end;
    end;
    LCmd := LCmd + ' "' + AMBName + '"'; {Do not Localize}
    if ( FConnectionState = csSelected ) then begin
        {SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdCopy] + ' ' + LMsgSet + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        SendCmd ( NewCmdCounter, LCmd, [wsOk,wsNO]); {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.CopyMsg (const AMsgNum: Integer; const AMBName: String): Boolean;
//Copies a message from the current selected mailbox to the specified mailbox.    {Do not Localize}
begin
    Result := False;
    IsNumberValid(AMsgNum);
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdCopy] + ' ' + IntToStr(AMsgNum) + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UIDCopyMsg (const AMsgUID: String; const AMBName: String): Boolean;
//Copies a message from the current selected mailbox to the specified mailbox.    {Do not Localize}
begin
    Result := False;
    IsUIDValid(AMsgUID);
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdCopy] + ' ' + AMsgUID + ' "' + AMBName + '"' ), [wsOk,wsNO]); {Do not Localize}
        if LastCmdResult.NumericCode = wsOk then begin
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;


function TIdIMAP4.AppendMsg(const AMBName: String; AMsg: TIdMessage; const AFlags: TIdMessageFlagsSet = []): Boolean;
begin
    Result := AppendMsg(AMBName, AMsg, nil, AFlags);
end;

function TIdIMAP4.AppendMsg (const AMBName: String; AMsg: TIdMessage; AAlternativeHeaders: TIdHeaderList; const AFlags: TIdMessageFlagsSet = []): Boolean;
var LFlags,
    LMsgLiteral: String;
    Ln: Integer;
    LCmd: string;
    LLength: integer;
    LHeadersAsString: string;
begin
    Result := False;
    if ( ( FConnectionState = csAuthenticated ) or ( FConnectionState = csSelected ) ) then begin
        if ( {Assigned (AMsg) and} ( AMBName <> '' ) ) then begin   {Do not Localize}
            LFlags := MessageFlagSetToStr(AFlags);
            if ( LFlags <> '' ) then begin   {Do not Localize}
                LFlags := '(' + Trim (LFlags) + ')'; {Do not Localize}
            end;
            {We are better off making up the headers as a string first rather than predicting
            its length.  Slightly wasteful of memory, but it will not take up much.}
            LHeadersAsString := '';  {Do not Localize}
            if AAlternativeHeaders = nil then begin
                {Use the headers that are in the message AMsg...}
                for Ln := 0 to Pred (AMsg.Headers.Count) do begin
                    LHeadersAsString := LHeadersAsString + AMsg.Headers[Ln] + EOL;          {Do not Localize}
                end;
                for Ln := 0 to Pred (AMsg.ExtraHeaders.Count) do begin
                    LHeadersAsString := LHeadersAsString + AMsg.ExtraHeaders[Ln] + EOL;     {Do not Localize}
                end;
            end else begin
                {Use the headers that the user has passed to us...}
                for Ln := 0 to Pred (AAlternativeHeaders.Count) do begin
                    LHeadersAsString := LHeadersAsString + AAlternativeHeaders[Ln] + EOL;   {Do not Localize}
                end;
            end;
            LLength := Length(LHeadersAsString) + Length(EOL) + Length(AMsg.Body.Text) + Length(EOL) + Length(EOL);
            LMsgLiteral := '{' + IntToStr ( LLength ) + '}';  {Do not Localize}
            {CC: The original code sent the APPEND command first, then followed it with the
            message.  Maybe this worked with some server, but most send a
            response like "+ Send the additional command..." between the two,
            which was not expected by the client and caused an exception.}

            //CC: Added double quotes around mailbox name, else mailbox names with spaces will cause server parsing error
            LCmd := IMAP4Commands[cmdAppend] + ' "' + AMBName + '" ';  {Do not Localize}
            if LFlags <> '' then begin                                 {Do not Localize}
                LCmd := LCmd + LFlags + ' ';                           {Do not Localize}
            end;
            LCmd := LCmd + LMsgLiteral; {Do not Localize}

            {Used to add the message to LCmd here.  Try sending the APPEND command, get
            the + response, then send the message...}
            SendCmd (NewCmdCounter, LCmd, [wsOK,wsNO,wsBAD,wsContinue]);
            if LastCmdResult.NumericCode = wsContinue then begin
                WriteLn(LHeadersAsString);
                WriteLn('');  {Do not Localize}
                WriteLn(AMsg.Body.Text);
                WriteLn('');  {Do not Localize}
                GetResponse(LastCmdCounter, [wsOK,wsBAD]);
                if ( LastCmdResult.NumericCode = wsOk ) then begin
                    Result := True;
                end;
            end;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.RetrieveEnvelope(const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
begin
    Result := InternalRetrieveEnvelope(AMsgNum, AMsg, nil);
end;

function TIdIMAP4.RetrieveEnvelopeRaw(const AMsgNum: Integer; ADestList: TStringList): Boolean;
begin
    Result := InternalRetrieveEnvelope(AMsgNum, nil, ADestList);
end;

function TIdIMAP4.InternalRetrieveEnvelope(const AMsgNum: Integer; AMsg: TIdMessage; ADestList: TStringList): Boolean;
var LSlRetrieve : TStringList;
    LStr: String;
    Ln: Integer;
begin
    {CC2: Return False if message number is invalid...}
    IsNumberValid(AMsgNum);
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        LSlRetrieve := TStringList.Create;
        try
            {Some servers return NO if the requested message number is not present
            (e.g. Cyrus), others return OK but no data (CommuniGate).}
            SendCmd (NewCmdCounter, ( IMAP4Commands[cmdFetch] + ' ' +    {Do not Localize}
            IntToStr ( AMsgNum ) + ' (' + {Do not Localize}
            {IMAP4FetchDataItem[fdEnvelope] + ')'), wsOK); {Do not Localize}
            IMAP4FetchDataItem[fdEnvelope] + ')'), [wsOK,wsNO]); {Do not Localize}
            if ( LastCmdResult.NumericCode = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                {CC: Make sure we have enough words}
                if ( (LSlRetrieve.Count > 2) and
                  AnsiSameText ( LSlRetrieve[0], IntToStr ( AMsgNum ) ) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdEnvelope] ) ) then begin {Do not Localize}
                    LStr := Copy ( LastCmdResult.Text[0],
                      ( Pos ( IMAP4FetchDataItem[fdEnvelope] + ' (', LastCmdResult.Text[0] ) + {Do not Localize}
                      Length ( IMAP4FetchDataItem[fdEnvelope] + ' (' ) ), {Do not Localize}
                      Length ( LastCmdResult.Text[0] ) );
                    if ( LastCmdResult.Text.Count > 2 ) then begin
                        for Ln := 1 to Pred (Pred (LastCmdResult.Text.Count)) do begin
                            LStr := LStr + LastCmdResult.Text[Ln];
                        end;
                    end;
                    LStr := Copy (LStr, 1, Length (LStr) - 2);
                    {CC6: Altered to support Raw option...}
                    if ADestList <> nil then begin
                        ADestList.Clear;
                        for Ln := 0 to LastCmdResult.Text.Count-1 do begin
                             ADestList.Add(LastCmdResult.Text[Ln]);
                        end;
                    end;
                    if AMsg <> nil then begin
                        ParseEnvelopeResult (AMsg, LStr);
                    end;
                    {CC2: Only return True if get to here, a valid response...}
                    Result := True; {LastCmdResult.NumericCode = wsOk;}
                end;
            end;
        finally
            LSlRetrieve.Free;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UIDRetrieveEnvelope(const AMsgUID: String; AMsg: TIdMessage): Boolean;
begin
    Result := UIDInternalRetrieveEnvelope(AMsgUID, AMsg, nil);
end;

function TIdIMAP4.UIDRetrieveEnvelopeRaw(const AMsgUID: String; ADestList: TStringList): Boolean;
begin
    Result := UIDInternalRetrieveEnvelope(AMsgUID, nil, ADestList);
end;

function TIdIMAP4.UIDInternalRetrieveEnvelope(const AMsgUID: String; AMsg: TIdMessage; ADestList: TStringList): Boolean;
var LSlRetrieve : TStringList;
    LStr: String;
    Ln: Integer;
begin
    IsUIDValid(AMsgUID);
    {CC2: Return False if message number is invalid...}
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        LSlRetrieve := TStringList.Create;
        try
            {Some servers return NO if the requested message number is not present
            (e.g. Cyrus), others return OK but no data (CommuniGate).}
            SendCmd (NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdFetch] + ' ' +    {Do not Localize}
              AMsgUID + ' (' + IMAP4FetchDataItem[fdEnvelope] + ')'), [wsOK,wsNO]);    {Do not Localize}
            if ( LastCmdResult.NumericCode = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                {CC: Make sure we have enough words}
                {CC2: Sort out correct server response...}
                if LSlRetrieve.Count > 4 then begin
                    if ( (AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                          AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdEnvelope] ) {Do not Localize}
                      ) or (
                          AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                          AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdUid] ) and {Do not Localize}
                          AnsiSameText ( LSlRetrieve[4], IMAP4FetchDataItem[fdEnvelope] )
                      ) ) then begin
                        LStr := Copy ( LastCmdResult.Text[0],
                          ( Pos ( IMAP4FetchDataItem[fdEnvelope] + ' (', LastCmdResult.Text[0] ) + {Do not Localize}
                          Length ( IMAP4FetchDataItem[fdEnvelope] + ' (' ) ), {Do not Localize}
                          Length ( LastCmdResult.Text[0] ) );
                        if ( LastCmdResult.Text.Count > 2 ) then begin
                            for Ln := 1 to Pred (Pred (LastCmdResult.Text.Count)) do begin
                                LStr := LStr + LastCmdResult.Text[Ln];
                            end;
                        end;
                        LStr := Copy (LStr, 1, Length (LStr) - 2);
                        {CC6: Altered to support Raw option...}
                        if ADestList <> nil then begin
                            ADestList.Clear;
                            for Ln := 0 to LastCmdResult.Text.Count-1 do begin
                                ADestList.Add(LastCmdResult.Text[Ln]);
                            end;
                        end;
                        if AMsg <> nil then begin
                            ParseEnvelopeResult (AMsg, LStr);
                        end;
                        {CC2: Only return True if get to here, a valid response...}
                        Result := True;
                    end;
                end;
            end;
        finally
            LSlRetrieve.Free;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.RetrieveAllEnvelopes(AMsgList: TIdMessageCollection): Boolean;
var LStr: String;
    Ln: Integer;
    LMsgItem: TIdMessageItem;
begin
    Result := False;
    {CC2: This is one of the few cases where the server can return only "OK completed"
    meaning that the user has no envelopes.}
    if ( FConnectionState = csSelected ) then begin
        SendCmd (NewCmdCounter, ( IMAP4Commands[cmdFetch] + ' 1:* (' + {Do not Localize}
          IMAP4FetchDataItem[fdEnvelope] + ')'), [wsOK,wsNO]); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            for Ln := 0 to LastCmdResult.Text.Count-1 do begin
                if ( ( Pos ( IMAP4Commands[cmdFetch], LastCmdResult.Text[Ln] ) > 0 ) and
                  ( Pos ( IMAP4FetchDataItem[fdEnvelope] + ' (', LastCmdResult.Text[Ln] ) > 0 ) ) then begin   {Do not Localize}
                    LStr := Copy ( LastCmdResult.Text[Ln],
                      ( Pos ( IMAP4FetchDataItem[fdEnvelope] + ' (', LastCmdResult.Text[Ln] ) + {Do not Localize}
                      Length ( IMAP4FetchDataItem[fdEnvelope] + ' (' ) ), {Do not Localize}
                      Length ( LastCmdResult.Text[Ln] ) );
                    while ( not ( Pos ( IMAP4Commands[cmdFetch], LastCmdResult.Text[Ln] ) = 1 ) and
                      not ( Pos ( IMAP4FetchDataItem[fdEnvelope] + ' (', LastCmdResult.Text[Ln] ) > 0 ) ) do begin   {Do not Localize}
                        LStr := LStr + LastCmdResult.Text[Ln];
                    end;
                    LStr := Copy (LStr, 1, Length (LStr) - 2);
                    LMsgItem := AMsgList.Add;
                    ParseEnvelopeResult (LMsgItem.IdMessage, LStr);
                end;
            end;
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt(RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UIDRetrieveAllEnvelopes(AMsgList: TIdMessageCollection): Boolean;
var LStr: String;
    Ln: Integer;
    LMsgItem: TIdMessageItem;
begin
    Result := False;
    {CC2: This is one of the few cases where the server can return only "OK completed"
    meaning that the user has no envelopes.}
    if ( FConnectionState = csSelected ) then
    begin
        SendCmd (NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdFetch] + ' 1:* (' + {Do not Localize}
          IMAP4FetchDataItem[fdEnvelope] + ')'), [wsOK,wsNO]); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            {Ln := 0;}
            {while Ln < Pred (LastCmdResult.Text.Count) do}
            for Ln := 0 to LastCmdResult.Text.Count-1 do begin
                if ( ( Pos ( IMAP4Commands[cmdFetch], LastCmdResult.Text[Ln] ) > 0 ) and
                  ( Pos ( IMAP4FetchDataItem[fdEnvelope] + ' (', LastCmdResult.Text[Ln] ) > 0 ) and    {Do not Localize}
                  ( Pos ( IMAP4FetchDataItem[fdUID], LastCmdResult.Text[Ln] ) > 0 ) ) then begin
                    LMsgItem := AMsgList.Add;
                    //Get UID
                    LStr := Trim ( Copy ( LastCmdResult.Text[Ln],
                    ( Pos ( IMAP4FetchDataItem[fdUID], LastCmdResult.Text[Ln] ) +
                    Length ( IMAP4FetchDataItem[fdUID] ) ), MaxInt ) );
                    LStr := Trim (Copy (LStr, 1,
                    Pos ( ' ', LStr ) - 1));    {Do not Localize}
                    LMsgItem.IdMessage.UID := LStr;
                    //Get envelope
                    LStr := Copy ( LastCmdResult.Text[Ln],
                    ( Pos ( IMAP4FetchDataItem[fdEnvelope] + ' (', LastCmdResult.Text[Ln] ) + {Do not Localize}
                    Length ( IMAP4FetchDataItem[fdEnvelope] + ' (' ) ), {Do not Localize}
                    Length ( LastCmdResult.Text[Ln] ) );
                    {Inc (Ln);}
                    while ( not ( Pos ( IMAP4Commands[cmdFetch], LastCmdResult.Text[Ln] ) = 1 ) and
                      not ( Pos ( IMAP4FetchDataItem[fdUID], LastCmdResult.Text[Ln] ) > 0 ) ) do begin
                        LStr := LStr + LastCmdResult.Text[Ln];
                    end;
                    LStr := Copy (LStr, 1, Length (LStr) - 2);
                    ParseEnvelopeResult (LMsgItem.IdMessage, LStr);
                end;
            end;
            Result := True;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt(RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.RetrieveText(const AMsgNum: Integer; var AText: string): Boolean;
    //Retrieve a specific individual part of a message
begin
    IsNumberValid(AMsgNum);
    Result := InternalRetrieveText(AMsgNum, AText, False, False, False);
end;

function TIdIMAP4.RetrieveText2(const AMsgNum: Integer; var AText: string): Boolean;
    //Retrieve a specific individual part of a message
begin
    IsNumberValid(AMsgNum);
    Result := InternalRetrieveText(AMsgNum, AText, False, False, True);
end;

function TIdIMAP4.RetrieveTextPeek(const AMsgNum: Integer; var AText: string): Boolean;
    {CC3: Added: Retrieve the text part of the message...}
begin
    IsNumberValid(AMsgNum);
    Result := InternalRetrieveText(AMsgNum, AText, False, True, False);
end;

function TIdIMAP4.RetrieveTextPeek2(const AMsgNum: Integer; var AText: string): Boolean;
    {CC3: Added: Retrieve the text part of the message...}
begin
    IsNumberValid(AMsgNum);
    Result := InternalRetrieveText(AMsgNum, AText, False, True, True);
end;

function TIdIMAP4.UIDRetrieveText(const AMsgUID: String; var AText: string): Boolean;
    {CC3: Added: Retrieve the text part of the message...}
begin
    IsUIDValid(AMsgUID);
    Result := InternalRetrieveText(StrToInt(AMsgUID), AText, True, False, False);
end;

function TIdIMAP4.UIDRetrieveText2(const AMsgUID: String; var AText: string): Boolean;
    {CC3: Added: Retrieve the text part of the message...}
begin
    IsUIDValid(AMsgUID);
    Result := InternalRetrieveText(StrToInt(AMsgUID), AText, True, False, True);
end;

function TIdIMAP4.UIDRetrieveTextPeek(const AMsgUID: String; var AText: string): Boolean;
    {CC3: Added: Retrieve the text part of the message...}
begin
    IsUIDValid(AMsgUID);
    Result := InternalRetrieveText(StrToInt(AMsgUID), AText, True, True, False);
end;

function TIdIMAP4.UIDRetrieveTextPeek2(const AMsgUID: String; var AText: string): Boolean;
    {CC3: Added: Retrieve the text part of the message...}
begin
    IsUIDValid(AMsgUID);
    Result := InternalRetrieveText(StrToInt(AMsgUID), AText, True, True, True);
end;

function TIdIMAP4.InternalRetrieveText(const AMsgNum: Integer; var AText: string;
  AUseUID: Boolean; AUsePeek: Boolean; AUseFirstPartInsteadOfText: Boolean): Boolean;
    {CC3: Added: Retrieve the text part of the message...}
label TryAgain, UnexpectedResponse;
var
    LSlRetrieve : TStringList;
    LText: string;
    LCmd: string;
    LTextLength: Integer;
    LParts: TIdImapMessageParts;
    LThePart: TIdImapMessagePart;
    LEncoding: string;
    LSourceStream: TIdTCPStream;
    LBase64Decoder: TIdDecoderMIME;
    LQuotedPrintableDecoder: TIdDecoderQuotedPrintable;
    LTextPart: integer;
    LSizeIndex: integer;
begin
    Result := False;
    AText := '';  {Do not Localize}
    if ( FConnectionState = csSelected ) then begin
        LTextPart := 0;  {The text part is usually part 1 but could be part 2}
        if AUseFirstPartInsteadOfText = True then begin
            {In this case, we need the body structure to find out what
            encoding has been applied to part 1...}
            LParts := TIdImapMessageParts.Create(nil, TIdImapMessagePart);
            if AUseUID = True then begin
                if UIDRetrieveStructure(IntToStr(AMsgNum), LParts) = False then Exit;
            end else begin
                if RetrieveStructure(AMsgNum, LParts) = False then Exit;
            end;
            {Get the info we want out of LParts...}
          TryAgain:
            LThePart := LParts.Items[LTextPart];   {Part 1 is index 0}
            if LThePart.FSize = 0 then begin
                {Some emails have part 0 empty, they intend you to use part 1}
                if LTextPart = 0 then begin
                  LTextPart := 1;
                  goto TryAgain;
                end;
            end;
            LEncoding := LThePart.Encoding;
            LParts.Destroy;
        end;
        LSlRetrieve := TStringList.Create;
        try
            LCmd :=  NewCmdCounter + ' ';  {Do not Localize}
            if AUseUID = True then begin
                LCmd := LCmd + IMAP4Commands[cmdUID] + ' '; {Do not Localize}
            end;
            LCmd := LCmd + IMAP4Commands[cmdFetch] + ' ' + IntToStr ( AMsgNum ) + ' ('; {Do not Localize}
            if AUsePeek = True then begin
                LCmd := LCmd + IMAP4FetchDataItem[fdBody]+'.PEEK'; {Do not Localize}
            end else begin
                LCmd := LCmd + IMAP4FetchDataItem[fdBody];
            end;
            if AUseFirstPartInsteadOfText = False then begin
                LCmd := LCmd + '[TEXT])'; {Do not Localize}
            end else begin
                {LCmd := LCmd + '[' + '1' + '])'; {Do not Localize}
                LCmd := LCmd + '[' +IntToStr(LTextPart+1)+ '])'; {Do not Localize}
            end;
            WriteLn(LCmd);
            if ( GetLineResponse ( GetCmdCounter, [wsOk,wsNO] ) = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                if ( (LSlRetrieve.Count > 3) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  (((AUseFirstPartInsteadOfText = False) and (AnsiSameText(LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdBody] + '[' + 'TEXT' + ']'))) or {Do not Localize}
                  ((AUseFirstPartInsteadOfText = True)  and (AnsiSameText(LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdBody] + '[' + IntToStr(LTextPart+1) + ']')))) ) then begin {Do not Localize}
                    {Do nothing, drop thru...}
                    LSizeIndex := 3;
                end else if ( (LSlRetrieve.Count > 5) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  (
                  ((AUseFirstPartInsteadOfText = False) and (AnsiSameText(LSlRetrieve[4], IMAP4FetchDataItem[fdBody] + '[' + 'TEXT' + ']'))) or {Do not Localize}
                  ((AUseFirstPartInsteadOfText = True)  and (AnsiSameText(LSlRetrieve[4], IMAP4FetchDataItem[fdBody] + '[' + IntToStr(LTextPart+1) + ']'))))  {Do not Localize}
                  ) then begin {Do not Localize}
                    {Do nothing, drop thru...}
                    LSizeIndex := 5;
                end else begin
                    goto UnexpectedResponse;
                end;
                {For an invalid request (non-existent part or message), NIL is
                returned as the size...}
                if ((UpperCase(LSlRetrieve[LSizeIndex]) = 'NIL)') or (UpperCase(LSlRetrieve[LSizeIndex]) = 'NIL') or (UpperCase(LSlRetrieve[LSizeIndex]) = '{NIL}')) then begin {Do not Localize}
                    GetResponse ( GetCmdCounter, [wsOk] );
                    Result := False;
                end else begin
                    {CC4: Some messages have an empty first part.  These respond as:
                      17 FETCH (BODY[1] "" UID 20)
                    instead of the more normal:
                      17 FETCH (BODY[1] {11}              {This bracket is not part of the response!
                      ...
                      UID 20)
                    }
                    if LSlRetrieve[LSizeIndex] <> '""' then begin {Do not Localize}
                        LTextLength := StrToInt(Copy(LSlRetrieve[LSizeIndex], 2, Length(LSlRetrieve[LSizeIndex])-2));
                        SetLength(LText, LTextLength);
                        LSourceStream := TIdTCPStream.Create(Self);
                        LSourceStream.ReadBuffer(LText[1], LTextLength);
                        LSourceStream.Destroy;
                        if LowerCase(LEncoding) = 'base64' then begin {Do not Localize}
                            LBase64Decoder := TIdDecoderMIME.Create(Self);
                            {Strip out any embedded CRLFs which are inserted by MTAs to ensure
                            the line-length limit is not exceeded...}
                            StripCRLFs(LText);
                            AText := LBase64Decoder.DecodeToString(LText);
                            LBase64Decoder.Destroy;
                            end else if LowerCase(LEncoding) = 'quoted-printable' then begin {Do not Localize}
                                LQuotedPrintableDecoder := TIdDecoderQuotedPrintable.Create(Self);
                                AText := LQuotedPrintableDecoder.DecodeToString(LText);
                                LQuotedPrintableDecoder.Destroy;
                            end else begin
                                AText := LText;
                            end;
                            ReadLnWait();  {Remove last line, ')' or 'UID 1)'}
                        end;
                        GetResponse ( GetCmdCounter, [wsOk,wsNO] );
                        if LastCmdResult.NumericCode = wsOk then begin
                        {Only return TRUE if get to here...}
                            Result := True;
                        end;
                    end;
                  UnexpectedResponse:
                end;
            finally
                LSlRetrieve.Free;
            end;
    end else begin
        raise EIdConnectionStateError.CreateFmt(RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.RetrieveStructure(const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
begin
    IsNumberValid(AMsgNum);
    Result := InternalRetrieveStructure(AMsgNum, AMsg, nil);
end;

function TIdIMAP4.RetrieveStructure(const AMsgNum: Integer; AParts: TIdImapMessageParts): Boolean;
begin
    IsNumberValid(AMsgNum);
    Result := InternalRetrieveStructure(AMsgNum, nil, AParts);
end;

function TIdIMAP4.InternalRetrieveStructure(const AMsgNum: Integer; AMsg: TIdMessage; AParts: TIdImapMessageParts): Boolean;
var
    LSlRetrieve : TStringList;
    LStr: string;
    LPartsList: TStringList;
    LTheParts: TIdMessageParts;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    LPartsList := TStringList.Create;
    if ( FConnectionState = csSelected ) then begin
        LSlRetrieve := TStringList.Create;
        try
            WriteLn ( NewCmdCounter + ' ' + ( {Do not Localize}
              IMAP4Commands[cmdFetch] + ' ' + IntToStr ( AMsgNum ) + ' (' + {Do not Localize}
              IMAP4FetchDataItem[fdBodyStructure] + ')' ) ); {Do not Localize}
            if ( GetLineResponse ( GetCmdCounter, [wsOk,wsNO] ) = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                if ( (LSlRetrieve.Count > 2) and
                  AnsiSameText ( LSlRetrieve[0], IntToStr ( AMsgNum ) ) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdBodyStructure] ) ) then begin {Do not Localize}
                    LStr := Copy ( LastCmdResult.Text[0],
                      Pos ( IMAP4FetchDataItem[fdBodyStructure] + ' (',   {Do not Localize}
                      LastCmdResult.Text[0] ) +    {Do not Localize}
                      Length ( IMAP4FetchDataItem[fdBodyStructure] + ' (' ), {Do not Localize}
                      MaxInt );
                    LStr := Copy ( LStr, 1, Length( LStr ) - 2 ); {Do not Localize}
                    if AMsg <> nil then begin
                        LTheParts := AMsg.MessageParts;
                        ParseBodyStructureResult(LStr, LTheParts, nil);
                    end;
                    if AParts <> nil then begin
                        ParseBodyStructureResult(LStr, nil, AParts);
                    end;
                    GetResponse ( GetCmdCounter, [wsOk,wsNO] );
                    if LastCmdResult.NumericCode = wsOk then begin
                        {Only return TRUE if get to here...}
                        Result := True;
                    end;
                end;
            end;
            finally
                LSlRetrieve.Free;
            end;
        end else begin
            raise EIdConnectionStateError.CreateFmt(RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
    LPartsList.Destroy;
end;

function TIdIMAP4.RetrievePart(const AMsgNum: Integer; const APartNum: Integer;
  var ABuffer: PChar; var ABufferLength: Integer; AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
begin
    IsNumberValid(AMsgNum);
    IsNumberValid(APartNum);
    Result := InternalRetrievePart(AMsgNum, APartNum, False, False, ABuffer, ABufferLength, '', AEncoding);  {Do not Localize}
end;

function TIdIMAP4.RetrievePartPeek(const AMsgNum: Integer; const APartNum: Integer;
  var ABuffer: PChar; var ABufferLength: Integer; AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
begin
    IsNumberValid(AMsgNum);
    IsNumberValid(APartNum);
    Result := InternalRetrievePart(AMsgNum, APartNum, False, True, ABuffer, ABufferLength, '', AEncoding);  {Do not Localize}
end;

function TIdIMAP4.UIDRetrievePart(const AMsgUID: String; const APartNum: Integer;
  var ABuffer: PChar; var ABufferLength: Integer; AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
begin
    IsUIDValid(AMsgUID);
    IsNumberValid(APartNum);
    Result := InternalRetrievePart(StrToInt(AMsgUID), APartNum, True, False, ABuffer, ABufferLength, '', AEncoding);  {Do not Localize}
end;

function TIdIMAP4.UIDRetrievePartPeek(const AMsgUID: String; const APartNum: Integer;
  var ABuffer: PChar; var ABufferLength: Integer; AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
begin
    IsUIDValid(AMsgUID);
    IsNumberValid(APartNum);
    Result := InternalRetrievePart(StrToInt(AMsgUID), APartNum, True, True, ABuffer, ABufferLength, '', AEncoding);  {Do not Localize}
end;

function TIdIMAP4.RetrievePartToFile(const AMsgNum: Integer; const APartNum: Integer;
  ALength: Integer; ADestFileNameAndPath: string; AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
var
    LDummy1: PChar;
begin
    IsNumberValid(AMsgNum);
    IsNumberValid(APartNum);
    if ADestFileNameAndPath = '' then begin  {Do not Localize}
        Result := False;
        Exit;
    end;
    Result := InternalRetrievePart(AMsgNum, APartNum, False, False,
      LDummy1, ALength, ADestFileNameAndPath, AEncoding);
end;

function TIdIMAP4.RetrievePartToFilePeek(const AMsgNum: Integer; const APartNum: Integer;
  ALength: Integer; ADestFileNameAndPath: string; AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
var
    LDummy1: PChar;
begin
    IsNumberValid(AMsgNum);
    IsNumberValid(APartNum);
    if ADestFileNameAndPath = '' then begin  {Do not Localize}
        Result := False;
        Exit;
    end;
    Result := InternalRetrievePart(AMsgNum, APartNum, False, True,
      LDummy1, ALength, ADestFileNameAndPath, AEncoding);
end;

function TIdIMAP4.UIDRetrievePartToFile(const AMsgUID: String; const APartNum: Integer;
  ALength: Integer; ADestFileNameAndPath: string; AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
var
    LDummy1: PChar;
begin
    IsUIDValid(AMsgUID);
    IsNumberValid(APartNum);
    if ADestFileNameAndPath = '' then begin  {Do not Localize}
        Result := False;
        Exit;
    end;
    Result := InternalRetrievePart(StrToInt(AMsgUID), APartNum, True, False,
      LDummy1, ALength, ADestFileNameAndPath, AEncoding);
end;

function TIdIMAP4.UIDRetrievePartToFilePeek(const AMsgUID: String; const APartNum: Integer;
  ALength: Integer; ADestFileNameAndPath: string; AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
var
    LDummy1: PChar;
begin
    IsUIDValid(AMsgUID);
    IsNumberValid(APartNum);
    if ADestFileNameAndPath = '' then begin  {Do not Localize}
        Result := False;
        Exit;
    end;
    Result := InternalRetrievePart(StrToInt(AMsgUID), APartNum, True, True,
      LDummy1, ALength, ADestFileNameAndPath, AEncoding);
end;

function TIdIMAP4.InternalRetrievePart(const AMsgNum: Integer; const APartNum: Integer;
  AUseUID: Boolean; AUsePeek: Boolean;
  var ABuffer: PChar; var ABufferLength: Integer; {NOTE: var args cannot have default params}
  ADestFileNameAndPath: string;
  AEncoding: string): Boolean;
    //Retrieve a specific individual part of a message
var
    LSlRetrieve : TStringList;
    LCmd: string;
    LSourceStream: TIdTCPStream;
    LDestStream: TFileStream;
    LIntermediateStream: TStringStream;
    LBase64Decoder: TIdDecoderMIME;
    LQuotedPrintableDecoder: TIdDecoderQuotedPrintable;
    LMemoryStream: TMemoryStream;
    LBuffer: string;
    LPartSizeParam: string;
    //LStringForTesting: string;
    LN: integer;
    LPtr: PChar;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    ABuffer := nil;
    ABufferLength := 0;
    if ( FConnectionState = csSelected ) then begin
        LSlRetrieve := TStringList.Create;
        try
            LCmd :=  NewCmdCounter + ' ';  {Do not Localize}
            if AUseUID = True then begin
                LCmd := LCmd + IMAP4Commands[cmdUID] + ' ';  {Do not Localize}
            end;
            LCmd := LCmd + IMAP4Commands[cmdFetch] + ' ' + IntToStr ( AMsgNum ) + ' ('; {Do not Localize}
            if AUsePeek = True then begin
                LCmd := LCmd + IMAP4FetchDataItem[fdBody]+'.PEEK'; {Do not Localize}
            end else begin
                LCmd := LCmd + IMAP4FetchDataItem[fdBody];
            end;
            LCmd := LCmd + '[' + IntToStr ( APartNum ) + '])'; {Do not Localize}
            WriteLn(LCmd);
            {CC7: wsBAD added because Ipswitch's IMAP server sometimes returns it here...}
            if ( GetLineResponse ( GetCmdCounter, [wsOk,wsNO,wsBAD] ) = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                LPartSizeParam := '';  {Do not Localize}
                if ( (LSlRetrieve.Count > 3) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdBody] + '[' + IntToStr ( APartNum ) + ']' ) ) then begin {Do not Localize}
                    LPartSizeParam := LSlRetrieve[3];
                end else if ( (LSlRetrieve.Count > 5) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[4], IMAP4FetchDataItem[fdBody] + '[' + IntToStr ( APartNum ) + ']' ) ) then begin {Do not Localize}
                    LPartSizeParam := LSlRetrieve[5];
                end;
                if LPartSizeParam <> '' then begin  {Do not Localize}
                    {For an invalid request (non-existent part or message), NIL
                    can be returned as the size...}
                    if ((UpperCase(LPartSizeParam) = 'NIL)') or (UpperCase(LPartSizeParam) = 'NIL') or (UpperCase(LPartSizeParam) = '{NIL}')) then begin {Do not Localize}
                        GetResponse ( GetCmdCounter, [wsOk,wsNO] );
                        Result := False;
                    end else begin
                        {CC4: Some messages have an empty first part.  These respond as:
                             17 FETCH (BODY[1] "" UID 20)
                         instead of the more normal:
                             17 FETCH (BODY[1] {11}              {This bracket is not part of the response!
                             ...
                             UID 20)
                        }
                        if LPartSizeParam <> '""' then begin  {Do not Localize}
                            ABufferLength := StrToInt(Copy(LPartSizeParam, 2, Length(LPartSizeParam)-2));
                            if ADestFileNameAndPath = '' then begin  {Do not Localize}
                                {User wants to write it to a memory block...}
                                LSourceStream := TIdTCPStream.Create(Self);
                                if LowerCase(AEncoding) = 'base64' then begin  {Do not Localize}
                                    LMemoryStream := TMemoryStream.Create;
                                    SetLength(LBuffer, ABufferLength);
                                    LSourceStream.ReadBuffer(LBuffer[1], ABufferLength);
                                    {This is more complicated than quoted-printable because we
                                    have to strip CRLFs that have been inserted by the MTA to
                                    avoid overly long lines...}
                                    StripCRLFs(LBuffer);
                                    LBase64Decoder := TIdDecoderMIME.Create(Self);
                                    LBase64Decoder.DecodeToStream(LBuffer, LMemoryStream);
                                    LBase64Decoder.Destroy;
                                    ABufferLength := LMemoryStream.Size;
                                    GetMem(ABuffer, ABufferLength);
                                    //LMemoryStream.Write(ABuffer, ABufferLength);  {Does not work}
                                    LPtr := LMemoryStream.Memory;
                                    for LN := 0 to ABufferLength-1 do begin
                                        ABuffer[LN] := LPtr^;
                                        Inc(LPtr);
                                    end;
                                    LMemoryStream.Destroy;
                                end else if LowerCase(AEncoding) = 'quoted-printable' then begin  {Do not Localize}
                                    LMemoryStream := TMemoryStream.Create;
                                    SetLength(LBuffer, ABufferLength);
                                    LSourceStream.ReadBuffer(LBuffer[1], ABufferLength);
                                    LQuotedPrintableDecoder := TIdDecoderQuotedPrintable.Create(Self);
                                    {Testing - will it decode OK into a string?}
                                    LQuotedPrintableDecoder.DecodeToStream(LBuffer, LMemoryStream);
                                    LQuotedPrintableDecoder.Destroy;
                                    ABufferLength := LMemoryStream.Size;
                                    GetMem(ABuffer, ABufferLength);
                                    LPtr := LMemoryStream.Memory;
                                    for LN := 0 to ABufferLength-1 do begin
                                        ABuffer[LN] := LPtr^;
                                        Inc(LPtr);
                                    end;
                                    LMemoryStream.Destroy;
                                end else begin
                                    {Assume no encoding or something we cannot decode.}
                                    {Get a block of memory to read the part into...}
                                    GetMem(ABuffer, ABufferLength);
                                    LSourceStream.Read(ABuffer[0], ABufferLength);
                                end;
                                LSourceStream.Destroy;
                            end else begin
                                {User wants to write it to a file...}
                                LSourceStream := TIdTCPStream.Create(Self);
                                LDestStream := TFileStream.Create(ADestFileNameAndPath, fmCreate);
                                if LowerCase(AEncoding) = 'base64' then begin  {Do not Localize}
                                    SetLength(LBuffer, ABufferLength);
                                    LSourceStream.ReadBuffer(LBuffer[1], ABufferLength);
                                    {Strip out any embedded CRLFs which are inserted by MTAs to ensure
                                    the line-length limit is not exceeded...}
                                    StripCRLFs(LBuffer);
                                    LBase64Decoder := TIdDecoderMIME.Create(nil);
                                    LBase64Decoder.DecodeToStream(LBuffer, LDestStream);
                                    LBase64Decoder.Destroy;
                                end else if LowerCase(AEncoding) = 'quoted-printable' then begin  {Do not Localize}
                                    LIntermediateStream := TStringStream.Create('');  {Do not Localize}
                                    LIntermediateStream.CopyFrom(LSourceStream, ABufferLength);
                                    LQuotedPrintableDecoder := TIdDecoderQuotedPrintable.Create(nil);
                                    LQuotedPrintableDecoder.DecodeToStream(LIntermediateStream.DataString, LDestStream);
                                    LQuotedPrintableDecoder.Destroy;
                                    LIntermediateStream.Destroy;
                                end else begin
                                    {Assume no encoding or something we cannot decode...}
                                    LDestStream.CopyFrom(LSourceStream, ABufferLength);
                                end;
                                LSourceStream.Destroy;
                                LDestStream.Destroy;
                            end;
                            ReadLnWait();  {Remove last line, ')' or 'UID 1)'}
                        end;
                        GetResponse ( GetCmdCounter, [wsOk,wsNO] );
                        if LastCmdResult.NumericCode = wsOk then begin
                            {Only return TRUE if get to here...}
                            Result := True;
                        end;
                    end;
                end;
            end;
        finally
            LSlRetrieve.Free;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UIDRetrieveStructure(const AMsgUID: String; AMsg: TIdMessage): Boolean;
begin
    IsUIDValid(AMsgUID);
    Result := UIDInternalRetrieveStructure(AMsgUID, AMsg, nil);
end;

function TIdIMAP4.UIDRetrieveStructure(const AMsgUID: String; AParts: TIdImapMessageParts): Boolean;
begin
    IsUIDValid(AMsgUID);
    Result := UIDInternalRetrieveStructure(AMsgUID, nil, AParts);
end;

function TIdIMAP4.UIDInternalRetrieveStructure(const AMsgUID: String; AMsg: TIdMessage; AParts: TIdImapMessageParts): Boolean;
label
    UnexpectedResponse;
var
    LSlRetrieve : TStringList;
    LStr: string;
    LPartsList: TStringList;
    LTheParts: TIdMessageParts;
begin
    {CC2: Default to returning False at this point...}
    Result := False;
    LPartsList := TStringList.Create;
    if ( FConnectionState = csSelected ) then begin
        LSlRetrieve := TStringList.Create;
        try
            WriteLn ( NewCmdCounter + ' ' + ( IMAP4Commands[cmdUID] + ' ' + {Do not Localize}
            IMAP4Commands[cmdFetch] + ' ' + AMsgUID + ' (' + {Do not Localize}
            IMAP4FetchDataItem[fdBodyStructure] + ')' ) ); {Do not Localize}
            if ( GetLineResponse ( GetCmdCounter, [wsOk,wsNO] ) = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                if ( (LSlRetrieve.Count > 2) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdBodyStructure] ) ) then begin {Do not Localize}
                    LStr := Copy ( LastCmdResult.Text[0],
                    Pos ( IMAP4FetchDataItem[fdBodyStructure] + ' (',   {Do not Localize}
                    LastCmdResult.Text[0] ) +    {Do not Localize}
                    Length ( IMAP4FetchDataItem[fdBodyStructure] + ' (' ), {Do not Localize}
                    MaxInt );
                    LStr := Copy ( LStr, 1, Pos( ') '+IMAP4Commands[cmdUID]+' '+AMsgUID+')', LStr ) - 1); {Do not Localize}
                end else if ( (LSlRetrieve.Count > 2) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4Commands[cmdUID] ) ) then begin {Do not Localize}
                    LStr := Copy ( LastCmdResult.Text[0],
                      Pos ( IMAP4FetchDataItem[fdBodyStructure] + ' (',   {Do not Localize}
                      LastCmdResult.Text[0] ) +    {Do not Localize}
                      Length ( IMAP4FetchDataItem[fdBodyStructure] + ' (' ), {Do not Localize}
                      MaxInt );
                    LStr := Copy ( LStr, 1, Length ( LStr ) - 2); {Do not Localize}
                end else begin
                    goto UnexpectedResponse;
                end;
                if AMsg <> nil then begin
                    LTheParts := AMsg.MessageParts;
                    ParseBodyStructureResult(LStr, LTheParts, nil);
                end;
                if AParts <> nil then begin
                    ParseBodyStructureResult(LStr, nil, AParts);
                end;
                GetResponse ( GetCmdCounter, [wsOk,wsNO] );
                if LastCmdResult.NumericCode = wsOk then begin
                    {Only return TRUE if get to here...}
                    Result := True;
                end;
              UnexpectedResponse:
            end;
        finally
            LSlRetrieve.Free;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
    LPartsList.Destroy;
end;

function TIdIMAP4.RetrieveHeader(const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
var LSlRetrieve : TStringList;
begin
    IsNumberValid(AMsgNum);
    {CC2: Default to returning False at this point...}
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        LSlRetrieve := TStringList.Create;
        try
            WriteLn ( NewCmdCounter + ' ' + ( {Do not Localize}
            IMAP4Commands[cmdFetch] + ' ' + IntToStr ( AMsgNum ) + ' (' + {Do not Localize}
            IMAP4FetchDataItem[fdRFC822Header] + ')' ) ); {Do not Localize}
            if ( GetLineResponse ( GetCmdCounter, [wsOk,wsNO] ) = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                {CC: Make sure we have enough words}
                if ( (LSlRetrieve.Count > 2) and
                  AnsiSameText ( LSlRetrieve[0], IntToStr ( AMsgNum ) ) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdRFC822Header] ) ) then begin {Do not Localize}
                    {CC2: Clear out body so don't get multiple copies of bodies}
                    AMsg.Headers.Clear;
                    ReceiveHeader ( AMsg, ')' ); {Do not Localize}
                    GetResponse ( GetCmdCounter, [wsOk,wsNO] );
                    if LastCmdResult.NumericCode = wsOk then begin
                        {CC2: Only return TRUE if get to here...}
                        Result := True;
                    end;
                end;
            end;
        finally
               LSlRetrieve.Free;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.UIDRetrieveHeader(const AMsgUID: String; AMsg: TIdMessage): Boolean;
label
    UnexpectedResponse;
var
    LSlRetrieve : TStringList;
    LExpectedResponse: string;
begin
    IsUIDValid(AMsgUID);
    {CC2: Default to returning False at this point...}
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        LSlRetrieve := TStringList.Create;
        try
            WriteLn ( NewCmdCounter + ' ' + ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdFetch] + ' ' +    {Do not Localize}
              AMsgUID + ' (' + IMAP4FetchDataItem[fdRFC822Header] + ')' ) );    {Do not Localize}
            if ( GetLineResponse ( GetCmdCounter, [wsOk,wsNO] ) = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                {CC: Make sure we have enough words}
                {CC: Format of response is 1 FETCH (RFC812.HEADER {953} {, this is decoding incorrectly}
                {CC5: or else 1 FETCH (UID 123 RFC812.HEADER {953} {, this is decoding incorrectly}
                if ( (LSlRetrieve.Count > 2) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdRFC822Header] ) ) then begin  {Do not Localize}
                    LExpectedResponse := ' '+IMAP4Commands[cmdUID]+' '+AMsgUID+')';  {Do not Localize}
                end else if ( (LSlRetrieve.Count > 2) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4Commands[cmdUID] ) ) then begin {Do not Localize}
                    LExpectedResponse := ')';  {Do not Localize}
                end else begin
                    goto UnexpectedResponse;
                end;
                {CC2: Trap the correct UID response}
                {CC2: Clear out body so don't get multiple copies of bodies}
                AMsg.Headers.Clear;
                ReceiveHeader ( AMsg, LExpectedResponse ); {Do not Localize}
                GetResponse ( GetCmdCounter, [wsOk,wsNO] );
                if LastCmdResult.NumericCode = wsOk then begin
                    {CC2: Only return TRUE if get to here...}
                    Result := True;
                end;
              UnexpectedResponse:
            end;
        finally
            LSlRetrieve.Free;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

{CC8: UIDREtrieveAllHeaders removed, makes no sense to implement this.}
{function TIdIMAP4.UIDRetrieveAllHeaders(AMsgList: TIdMessageCollection): Boolean;}
    {CC5: This is not, and never was, implemented: why would you use it?}
{begin}
{    Result := False;
end;}

function TIdIMAP4.Retrieve(const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
begin
    IsNumberValid(AMsgNum);
    Result := InternalRetrieve(AMsgNum, False, False, AMsg);
end;

function TIdIMAP4.RetrievePeek(const AMsgNum: Integer; AMsg: TIdMessage): Boolean;
begin
    IsNumberValid(AMsgNum);
    Result := InternalRetrieve(AMsgNum, False, True, AMsg);
end;

function TIdIMAP4.UIDRetrieve(const AMsgUID: String; AMsg: TIdMessage): Boolean;
begin
    IsUIDValid(AMsgUID);
    Result := InternalRetrieve(StrToInt(AMsgUID), True, False, AMsg);
end;

function TIdIMAP4.UIDRetrievePeek(const AMsgUID: String; AMsg: TIdMessage): Boolean;
begin
    IsUIDValid(AMsgUID);
    Result := InternalRetrieve(StrToInt(AMsgUID), True, True, AMsg);
end;

function TIdIMAP4.InternalRetrieve(const AMsgNum: Integer; AUseUID: Boolean; AUsePeek: Boolean; AMsg: TIdMessage): Boolean;
var LSlRetrieve : TStringList;
    LStr: String;
    Fn: Integer;
    LFlags: TIdMessageFlagsSet;
    LCmd: string;
    LExpectedResponse: string;
    LPartSizeParam: string;
begin
    {Default to returning False at this point...}
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        LSlRetrieve := TStringList.Create;
        try
            LCmd := NewCmdCounter + ' ';
            if AUseUID = True then begin
                LCmd := LCmd + IMAP4Commands[cmdUID] + ' ';  {Do not Localize}
            end;
            LCmd := LCmd + IMAP4Commands[cmdFetch] + ' ' + IntToStr ( AMsgNum ) + ' ('; {Do not Localize}
            if AUsePeek = True then begin
                LCmd := LCmd + IMAP4FetchDataItem[fdBodyPeek]; {Do not Localize}
            end else begin
                LCmd := LCmd + IMAP4FetchDataItem[fdRFC822]; {Do not Localize}
            end;
            LCmd := LCmd + ')';
            WriteLn(LCmd);
            if ( GetLineResponse ( GetCmdCounter, [wsOk,wsNO] ) = wsOk ) then begin
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                {CC9: Modified the following to hopefully deal with an optional "FLAGS (\Seen)"
                which can appear in response, but only in the "Retrieve" case.  Examples:
                Without flags param:
                  * 5 FETCH (RFC822 (7105)
                With flags param:
                  * 5 FETCH (FLAGS (\Seen) RFC822 (7105)
                }
                LPartSizeParam := '';  {Do not Localize}
                if ((AUseUID = False) and (AUsePeek = False)) then begin                {Retrieve}
                    if ( (LSlRetrieve.Count > 2) and
                      AnsiSameText ( LSlRetrieve[0], IntToStr ( AMsgNum ) ) and
                      AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) {and
                      AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdRFC822] )} ) then begin {Do not Localize}
                        LExpectedResponse := ')';
                        LPartSizeParam := LSlRetrieve[{3} LSlRetrieve.Count-1];
                    end else begin
                        Exit;
                    end;
                end else if ((AUseUID = False) and (AUsePeek = True)) then begin        {RetrievePeek}
                    if ( (LSlRetrieve.Count > 2) and
                      AnsiSameText ( LSlRetrieve[0], IntToStr ( AMsgNum ) ) and
                      AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                      ( AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdBodyPeek] ) or {Do not Localize}
                      AnsiSameText ( LSlRetrieve[2], '(BODY[]' ) ) {Do not Localize}
                      ) then begin
                        LExpectedResponse := ')';
                        LPartSizeParam := LSlRetrieve[{3} LSlRetrieve.Count-1];
                    end else begin
                        Exit;
                    end;
                end else if ((AUseUID = True) and (AUsePeek = False)) then begin        {UIDRetrieve}
                    if ( (LSlRetrieve.Count > 3) and
                      AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                      AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdRFC822] ) ) then begin {Do not Localize}
                        LExpectedResponse := ' '+IMAP4Commands[cmdUID]+' '+IntToStr(AMsgNum)+')';
                        LPartSizeParam := LSlRetrieve[{3} LSlRetrieve.Count-1];
                    end else if ( (LSlRetrieve.Count > 4) and
                      AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                      AnsiSameText ( LSlRetrieve[4], IMAP4FetchDataItem[fdRFC822] ) and {Do not Localize}
                      AnsiSameText ( LSlRetrieve[2], '(' + IMAP4Commands[cmdUID] ) ) then begin {Do not Localize}
                        LExpectedResponse := ')';  {Do not Localize}
                        LPartSizeParam := LSlRetrieve[{5} LSlRetrieve.Count-1];
                    end else begin
                        Exit;
                    end;
                end else {if ((AUseUID = True) and (AUsePeek = True)) then} begin       {UIDRetrievePeek}
                    if ( (LSlRetrieve.Count > 3) and
                      AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                      ( AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdBodyPeek] ) or {Do not Localize}
                      AnsiSameText ( LSlRetrieve[2], '(BODY[]' ) ) {Do not Localize}
                      ) then begin
                        LExpectedResponse := ' '+IMAP4Commands[cmdUID]+' '+IntToStr(AMsgNum)+')';  {Do not Localize}
                        LPartSizeParam := LSlRetrieve[{3} LSlRetrieve.Count-1];
                    end else if ( (LSlRetrieve.Count > 4) and
                      AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                      ( ( AnsiSameText ( LSlRetrieve[4], IMAP4FetchDataItem[fdBodyPeek] ) ) or {Do not Localize}
                      ( AnsiSameText ( LSlRetrieve[4], 'BODY[]' ) ) ) {Do not Localize}
                      and AnsiSameText ( LSlRetrieve[2], '(' + IMAP4Commands[cmdUID] ) ) then begin {Do not Localize}
                        LExpectedResponse := ')';  {Do not Localize}
                        LPartSizeParam := LSlRetrieve[{5} LSlRetrieve.Count-1];
                    end else begin
                        Exit;
                    end;
                end;
                {CC2: Clear out headers so don't get multiple copies of headers}
                AMsg.Headers.Clear;
                if ReceiveHeader(AMsg) = '' then begin {Do not Localize} // Only retreive the body if we do not already have a full RFC
                    {CC2: Clear out body so don't get multiple copies of bodies}
                    AMsg.Body.Clear;
                    {CC2: Clear out parts so don't get multiple copies of parts}
                    AMsg.MessageParts.Clear;
                    {CC3: Change delimiter to implement checking for optional IMAP flags at end of message...}
                    ReceiveBody ( AMsg, 'IMAP'+LExpectedResponse ); {Do not Localize}
                end;
                GetResponse ( GetCmdCounter, [wsOk,wsNO] );
                if LastCmdResult.NumericCode = wsOk then begin
                    {CC2: Only return TRUE if get to here...}
                    Result := True;
                end else begin
                    Exit;
                end;
                {CC8: TO CHECK: Original code (in ReceiveBody) looked for the
                flags before now, maybe the following code won't work now?
                Look in ReceiveBody for LCheckForOptionalImapFlags.}
                for Fn := 0 to ( LastCmdResult.Text.Count - 1 ) do begin
                    if ( Pos ( ( IntToStr ( AMsgNum ) + ' FETCH (FLAGS ' ), {Do not Localize}
                      LastCmdResult.Text[Fn] ) > 0 ) then begin
                        LStr := Copy ( LastCmdResult.Text[Fn],
                          ( Pos ( 'FLAGS (', LastCmdResult.Text[Fn] ) + {Do not Localize}
                          Length ( 'FLAGS (' ) ), {Do not Localize}
                          Length ( LastCmdResult.Text[Fn] ) );
                        if AUseUID = False then begin
                            LStr := Copy ( LStr, 1, ( Pos ( '))', LStr ) - 1 ) ); {Do not Localize}
                        end else begin
                            LStr := Copy ( LStr, 1, ( Pos ( ')', LStr ) - 1 ) ); {Do not Localize}
                        end;
                        ParseMessageFlagString ( LStr, LFlags );
                        AMsg.Flags := LFlags;
                    end;
                end;
            end;
        finally
            LSlRetrieve.Free;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
    end;
end;

function TIdIMAP4.RetrieveAllHeaders(AMsgList: TIdMessageCollection): Boolean;
var
    LMsgItem : TIdMessageItem;
    Ln : Integer;
begin
    {CC2: This may get a response of "OK completed" if there are no messages}
    if ( FConnectionState = csSelected ) then begin
        if ( AMsgList <> nil ) then begin
            Result := True;
            for Ln := 1 to FMailBox.TotalMsgs do begin
                LMsgItem := AMsgList.Add;
                if not RetrieveHeader ( Ln, LMsgItem.IdMessage ) then begin
                    Result := False;
                    Break;
                end;
            end;
        end else begin
            Result := False;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := False;
    end;
end;

function TIdIMAP4.RetrieveAllMsgs(AMsgList: TIdMessageCollection): Boolean;
var LMsgItem : TIdMessageItem;
    Ln : Integer;
begin
    {CC2: This may get a response of "OK completed" if there are no messages}
    if ( FConnectionState = csSelected ) then begin
        if ( AMsgList <> nil ) then begin
            Result := True;
            for Ln := 1 to FMailBox.TotalMsgs do begin
                LMsgItem := AMsgList.Add;
                if not Retrieve ( Ln, LMsgItem.IdMessage ) then begin
                    Result := False;
                    Break;
                end;
            end;
        end else begin
            Result := False;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := False;
    end;
end;

function TIdIMAP4.DeleteMsgs(const AMsgNumList: array of Integer): Boolean;
begin
    Result := StoreFlags (AMsgNumList, sdAdd, [mfDeleted]);
end;

function TIdIMAP4.UIDDeleteMsg(const AMsgUID: String): Boolean;
begin
    IsUIDValid(AMsgUID);
    Result := UIDStoreFlags (AMsgUID, sdAdd, [mfDeleted]);
end;

function TIdIMAP4.RetrieveMailBoxSize: Integer;
var LSlRetrieve : TStringList;
    Ln : Integer;
begin
    if ( FConnectionState = csSelected ) then  begin
        {CC2: This should not be checking FMailBox.TotalMsgs because the server may
        have added messages to the mailbox unknown to us, and we are going to ask the
        server anyway (if it's empty, we will return 0 anyway}
        {if ( FMailBox.TotalMsgs > 0 ) then
        begin}
            {CC5: Remove dependancy on FMailBox.TotalMsgs}
            {SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdFetch] + ' 1:' + IntToStr ( FMailBox.TotalMsgs ) + {Do not Localize}
            SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdFetch] + ' 1:*' + {Do not Localize}
            ' (' + IMAP4FetchDataItem[fdRFC822Size] + ')' ), [wsOk,wsNO] ); {Do not Localize}
            if ( LastCmdResult.NumericCode = wsOk ) then begin
                Result := 0;
                LSlRetrieve := TStringList.Create;
                try
                    for Ln := 0 to ( FMailBox.TotalMsgs - 1 )do begin
                        BreakApart ( LastCmdResult.Text[Ln], ' ', LSlRetrieve ); {Do not Localize}
                        {CC: Make sure we have enough words}
                        {CC2: Change LSlRetrieve.Count > 2 to 3 since we use LSlRetrieve[3] later}
                        if ( (LSlRetrieve.Count > 3) and
                          AnsiSameText ( LSlRetrieve[0], IntToStr ( Ln + 1 ) ) and
                          AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                          AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdRFC822Size] ) ) then begin {Do not Localize}
                            Result := Result + StrToInt (Copy ( LSlRetrieve[3], 1, ( Length ( LSlRetrieve[3] ) - 1 ) ) );
                        end else begin
                            {CC2: Return -1, not 0, if we cannot parse the result...}
                            Result := -1;
                            Break;
                        end;
                        LSlRetrieve.Clear;
                    end;
                finally
                    LSlRetrieve.Free;
                end;
            end else begin
                Result := -1;
            end;
        {end
        else
            Result := 0;}
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := -1;
    end;
end;

function TIdIMAP4.UIDRetrieveMailBoxSize: Integer;
var LSlRetrieve : TStringList;
    Ln : Integer;
    LTemp: string;
begin
    if ( FConnectionState = csSelected ) then begin
        {CC2: This should not be checking FMailBox.TotalMsgs because the server may
        have added messages to the mailbox unknown to us, and we are going to ask the
        server anyway (if it's empty, we will return 0 anyway}
        {if ( FMailBox.TotalMsgs > 0 ) then
        begin}
            SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdFetch] + ' 1:*' +    {Do not Localize}
            ' (' + IMAP4FetchDataItem[fdRFC822Size] + ')' ), [wsOk,wsOK] ); {Do not Localize}
            if ( LastCmdResult.NumericCode = wsOk ) then begin
                Result := 0;
                LSlRetrieve := TStringList.Create;
                try
                    for Ln := 0 to ( FMailBox.TotalMsgs - 1 )do begin
                        BreakApart ( LastCmdResult.Text[Ln], ' ', LSlRetrieve ); {Do not Localize}
                        {CC: Make sure we have enough words}
                        {CC2: Change LSlRetrieve.Count > 4 to 5 since we use LSlRetrieve[5] later}
                        {CC2: Correct the parsing of the return value, add begin/end as per guidelines}
                        if ( (LSlRetrieve.Count > 5) and
                          AnsiSameText ( LSlRetrieve[0], IntToStr ( Ln + 1 ) ) and
                          AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                          AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdRFC822Size] ) ) then begin {Do not Localize}
                            {CC5: Change parsing, watch out for possible trailing bracket...}
                            LTemp := Copy ( LSlRetrieve[3], 1, MaxInt );
                            if LTemp[Length(LTemp)] = ')' then begin  {Do not Localize}
                                LTemp := Copy(LTemp, 1, Length(LTemp)-1);
                            end;
                            Result := Result + StrToInt ( LTemp );
                        end else if ( (LSlRetrieve.Count > 5) and
                          AnsiSameText ( LSlRetrieve[0], IntToStr ( Ln + 1 ) ) and
                          AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                          AnsiSameText ( LSlRetrieve[4], IMAP4FetchDataItem[fdRFC822Size] ) ) then begin {Do not Localize}
                            {CC5: Change parsing, watch out for possible trailing bracket...}
                            LTemp := Copy ( LSlRetrieve[5], 1, MaxInt );
                            if LTemp[Length(LTemp)] = ')' then begin  {Do not Localize}
                                LTemp := Copy(LTemp, 1, Length(LTemp)-1);
                            end;
                            Result := Result + StrToInt ( LTemp );
                        end else begin
                            {Result := 0;}
                            {CC2: Return -1, not 0, if we cannot parse the result...}
                            Result := -1;
                            Break;
                        end;
                        LSlRetrieve.Clear;
                    end;
                finally
                    LSlRetrieve.Free;
                end;
            end else begin
                 Result := -1;
            end;
        {end
        else
            Result := 0;}
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := -1;
    end;
end;

function TIdIMAP4.RetrieveMsgSize(const AMsgNum: Integer): Integer;
var LSlRetrieve : TStringList;
begin
    IsNumberValid(AMsgNum);
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdFetch] + ' ' + IntToStr ( AMsgNum ) + {Do not Localize}
        ' (' + IMAP4FetchDataItem[fdRFC822Size] + ')' ), [wsOk,wsNO] ); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            LSlRetrieve := TStringList.Create;
            try
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                {CC: Make sure we have enough words}
                {CC2: Change LSlRetrieve.Count > 2 to 3 since we use LSlRetrieve[3] later}
                if ( (LSlRetrieve.Count > 3) and
                  AnsiSameText ( LSlRetrieve[0], IntToStr ( AMsgNum ) ) and
                  AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                  AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdRFC822Size] ) ) then begin {Do not Localize}
                    Result := StrToInt (Copy ( LSlRetrieve[3], 1, ( Length ( LSlRetrieve[3] ) - 1 ) ) );
                end else begin
                    Result := -1;
                end;
            finally
                LSlRetrieve.Free;
            end;
        end else begin
            Result := -1;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := -1;
    end;
end;

function TIdIMAP4.UIDRetrieveMsgSize(const AMsgUID: String): Integer;
var LSlRetrieve : TStringList;
begin
    IsUIDValid(AMsgUID);
    if ( FConnectionState = csSelected ) then
    begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdFetch] +    {Do not Localize}
        ' ' + AMsgUID + ' (' + IMAP4FetchDataItem[fdRFC822Size] + ')' ), [wsOk,wsNO] ); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            LSlRetrieve := TStringList.Create;
            try
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                {CC: Make sure we have enough words}
                {CC2: Change LSlRetrieve.Count > 4 to 5 since we use LSlRetrieve[5] later}
                {CC2: sort out the response properly}
                if ( (LSlRetrieve.Count > 5) and
                  AnsiSameText (LSlRetrieve[1], IMAP4Commands[cmdFetch]) and
                  AnsiSameText (LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdRfc822Size]) ) then begin {Do not Localize}
                    Result := StrToInt (Copy (LSlRetrieve[3], 1, MaxInt));
                end else if ( (LSlRetrieve.Count > 5) and
                  AnsiSameText (LSlRetrieve[1], IMAP4Commands[cmdFetch]) and
                  AnsiSameText (LSlRetrieve[2], '(' + IMAP4Commands[cmdUID]) ) then begin {Do not Localize}
                    Result := StrToInt (Copy (LSlRetrieve[5], 1, Length(LSlRetrieve[5])-1));
                end else begin
                    Result := -1;
                end;
            finally
                LSlRetrieve.Free;
            end;
        end else begin
            Result := -1;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := -1;
    end;
end;

function TIdIMAP4.CheckMsgSeen(const AMsgNum: Integer): Boolean;
var
    Ln : Integer;
    LSlRetrieve : TStringList;
begin
    IsNumberValid(AMsgNum);
    Result := False;
    if (FConnectionState = csSelected) then begin
        SendCmd(NewCmdCounter, (IMAP4Commands[cmdFetch] + ' ' + IntToStr(AMsgNum) + {Do not Localize}
          ' (' + IMAP4FetchDataItem[fdFlags] + ')' ), [wsOk,wsNO]); {Do not Localize}
        if (LastCmdResult.NumericCode = wsOk) then begin
            for Ln := 0 to (LastCmdResult.Text.Count - 1) do begin
                LSlRetrieve := TStringList.Create;
                try
                    // DS 13-Mar-2001 Fix Bug # 494813
                    BreakApart(LastCmdResult.Text[Ln], ' ', LSlRetrieve); {Do not Localize}
                    {CC: Make sure we have enough words}
                    if ( (LSlRetrieve.Count > 2) and
                      AnsiSameText(LSlRetrieve[0], IntToStr(AMsgNum)) and
                      AnsiSameText(LSlRetrieve[1], IMAP4Commands[cmdFetch]) and
                      AnsiSameText(LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdFlags])) then begin {Do not Localize}
                        Result := (Pos(MessageFlags[mfSeen], LastCmdResult.Text[Ln]) > 0);
                    end;
                finally
                    LSlRetrieve.Free;
                end;
            end;
        end else begin
            Result := False;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt(RSIMAP4ConnectionStateError, [GetConnectionStateName]);
        Result := False;
    end;
end;

function TIdIMAP4.UIDCheckMsgSeen(const AMsgUID: String): Boolean;
var LSlRetrieve : TStringList;
begin
    IsUIDValid(AMsgUID);
    Result := False;
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdFetch] + ' ' +    {Do not Localize}
        AMsgUID + ' (' + IMAP4FetchDataItem[fdFlags] + ')' ), [wsOk,wsNO] ); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            LSlRetrieve := TStringList.Create;
            try
                BreakApart ( LastCmdResult.Text[0], ' ', LSlRetrieve ); {Do not Localize}
                {CC: Check LSlRetrieve.Count > 4 (otherwise, last line (which only has a count of 1) gives a "List index out of bounds" error)
                {CC: Testing against LSlRetrieve[3] and LSlRetrieve[4] does not work if multiple flags returned (if you really wanted to sort it, they would be LSlRetrieve[LS1Retrieve.Count-X])}
                {CC: LSlRetrieve[2] should be  '(' + IMAP4FetchDataItem[fdFlags], not '(' + IMAP4FetchDataItem[fdUID]}
                if ( (LSlRetrieve.Count > 4) and
                  AnsiSameText (LSlRetrieve[1], IMAP4Commands[cmdFetch]) and
                  AnsiSameText (LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdFlags]) ) then begin  {Do not Localize}
                    if ( Pos ( MessageFlags[mfSeen], LastCmdResult.Text[0] ) > 0 ) then begin
                        Result := True;
                    end else begin
                        Result := False;
                    end;
                end;
            finally
                LSlRetrieve.Free;
            end;
        end else begin
            Result := False;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := False;
    end;
end;

{CC: use "var" to get results returned}
function TIdIMAP4.RetrieveFlags(const AMsgNum: Integer; var AFlags: {Pointer}TIdMessageFlagsSet): Boolean;
var Ln: Integer;
    LStr: String;
    LSlRetrieve: TStringList;
begin
    IsNumberValid(AMsgNum);
    Result := False;
    {CC: Empty set to avoid returning resuts from a previous call if call fails}
    AFlags := [];
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdFetch] + ' ' + IntToStr ( AMsgNum ) + {Do not Localize}
          ' (' + IMAP4FetchDataItem[fdFlags] + ')' ), [wsOk,wsNO] ); {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            for Ln := 0 to ( LastCmdResult.Text.Count - 1 ) do begin
                LSlRetrieve := TStringList.Create;
                try
                    {CC: Loop on [Ln] (was [0]) }
                    BreakApart ( LastCmdResult.Text[Ln], ' ', LSlRetrieve ); {Do not Localize}
                    {CC: Make sure we have enough params - if we requested a non-existent message number,
                    server may return nothing except the OK response}
                    if ( (LSlRetrieve.Count > 2) and
                      AnsiSameText ( LSlRetrieve[0], IntToStr ( AMsgNum ) ) and
                      AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                      AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdFlags] ) ) then begin {Do not Localize}
                        LStr := Copy ( LastCmdResult.Text[Ln],
                          ( Pos ( IMAP4FetchDataItem[fdFlags] + ' (', LastCmdResult.Text[Ln] ) +    {Do not Localize}
                          Length ( IMAP4FetchDataItem[fdFlags] + ' (' ) ), {Do not Localize}
                          Length ( LastCmdResult.Text[Ln] ) );
                        LStr := Copy ( LStr, 1, ( Pos ( '))', LStr ) - 1 ) ); {Do not Localize}
                        ParseMessageFlagString ( LStr, AFlags );
                        Result := True;
                    end;
                finally
                    LSlRetrieve.Free;
                end;
            end;
        end else begin
            Result := False;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := False;
    end;
end;

{CC: use "var" to get results returned}
function TIdIMAP4.UIDRetrieveFlags(const AMsgUID: String; var AFlags: TIdMessageFlagsSet): Boolean;
var Ln: Integer;
    LStr: String;
    LSlRetrieve: TStringList;
begin
    IsUIDValid(AMsgUID);
    Result := False;
    {BUG FIX: Empty set to avoid returning resuts from a previous call if call fails}
    AFlags := [];
    if ( FConnectionState = csSelected ) then begin
        SendCmd ( NewCmdCounter, ( IMAP4Commands[cmdUID] + ' ' + IMAP4Commands[cmdFetch] + ' ' +    {Do not Localize}
        AMsgUID + ' (' + IMAP4FetchDataItem[fdFlags] + ')' ), [wsOk,wsNO] );    {Do not Localize}
        if ( LastCmdResult.NumericCode = wsOk ) then begin
            for Ln := 0 to ( LastCmdResult.Text.Count - 1 ) do begin
                LSlRetrieve := TStringList.Create;
                try
                    {CC: Scan on [Ln] (was [0] }
                    BreakApart ( LastCmdResult.Text[Ln], ' ', LSlRetrieve ); {Do not Localize}
                    {CC: Check LSlRetrieve.Count > 4 (otherwise, last line (which only has a count of 1) gives a "List index out of bounds" error)
                    {CC: Testing against LSlRetrieve[3] and LSlRetrieve[4] does not work if multiple flags returned (if you really wanted to sort it, they would be LSlRetrieve[LS1Retrieve.Count-X])}
                    {CC: LSlRetrieve[2] should be  '(' + IMAP4FetchDataItem[fdFlags], not '(' + IMAP4FetchDataItem[fdUID]}
                    if ( (LSlRetrieve.Count > 4) and
                      AnsiSameText ( LSlRetrieve[1], IMAP4Commands[cmdFetch] ) and
                      AnsiSameText ( LSlRetrieve[2], '(' + IMAP4FetchDataItem[fdFlags] ) ) then begin {Do not Localize}
                        LStr := Copy ( LastCmdResult.Text[Ln],
                        ( Pos ( IMAP4FetchDataItem[fdFlags] + ' (', LastCmdResult.Text[Ln] ) +    {Do not Localize}
                        Length ( IMAP4FetchDataItem[fdFlags] + ' (' ) ), {Do not Localize}
                        Length ( LastCmdResult.Text[Ln] ) );
                        {CC: On the UID version, check for ')' rather than '))'}
                        LStr := Copy ( LStr, 1, ( Pos ( ')', LStr ) - 1 ) ); {Do not Localize}
                        ParseMessageFlagString ( LStr, AFlags );
                        Result := True;
                    end;
                finally
                    LSlRetrieve.Free;
                end;
            end;
        end else begin
            Result := False;
        end;
    end else begin
        raise EIdConnectionStateError.CreateFmt (RSIMAP4ConnectionStateError, [GetConnectionStateName] );
        Result := False;
    end;
end;

function TIdIMAP4.GetConnectionStateName: String;
begin
    case FConnectionState of
      csAny : Result := RSIMAP4ConnectionStateAny;
      csNonAuthenticated : Result := RSIMAP4ConnectionStateNonAuthenticated;
      csAuthenticated : Result := RSIMAP4ConnectionStateAuthenticated;
      csSelected : Result := RSIMAP4ConnectionStateSelected;
    end;
end;

{ ...TIdIMAP4 Commands }

{ Parser Functions... }

procedure TIdIMAP4.ParseBodyStructureResult(ABodyStructure: string; ATheParts: TIdMessageParts;
  AImapParts: TIdImapMessageParts);
    {CC2: Function added to support individual part retreival}
var
    Ln: Integer;
    Lm: Integer;
    LSections: integer;
    LWord: string;
    LLine: string;
    LPartsList: TStringList;
    LTempList: TStringList;
    LThePart: TIdMessagePart;
    LImapPart: TIdImapMessagePart;
    LSubSectionPtr: TIdImapSubSection;
begin
    {
    If it's a single-part message, it won't be enclosed in brackets - it will be:
    "body type": "TEXT", "application", "image", "MESSAGE" (followed by subtype RFC822 for envelopes, ignore)
    "body subtype": "PLAIN", "octet-stream", "tiff", "html"
    "body parameter parenthesized list": bracketted list of pairs ("CHARSET" "US-ASCII" "NAME" "cc.tif" "format" "flowed"), ("charset" "ISO-8859-1")
    "body id": NIL, 986767766767887@fg.com
    "body description": NIL, "Compiler diff"
    "body encoding": "7bit" "8bit" "binary" (NO encoding used with these), "quoted-printable" "base64" "ietf-token" "x-token"
    "body size" 2279
    "body lines" 48 (only present for some types, only those with "body type=text" and "body subtype=plain" that I found, if not present it WONT be a NIL, it just won't be there!  However, it won't be needed)
    <don't know> NIL
    <don't know> ("inline" ("filename" "classbd.h")), ("attachment" ("filename" "DEGDAY.WB3"))
    <don't know> NIL
    Example:
    * 4 FETCH (BODYSTRUCTURE ("text" "plain" ("charset" "ISO-8859-1") NIL NIL "7bit" 40 1 NIL NIL NIL))
    ---------------------------------------------------------------------------
    For most multi-part messages, each part will be bracketted:
    ( (part 1 stuff) (part 2 stuff) "mixed" (boundary) NIL NIL )
    Example:
    * 1 FETCH (BODYSTRUCTURE (("text" "plain" ("charset" "us-ascii" "format" "flowed")
    NIL NIL "7bit" 52 3 NIL NIL NIL)("text" "plain" ("name" "tnkin.txt") NIL NIL
    "7bit" 28421 203 NIL ("inline" ("filename" "tnkin.txt")) NIL) "mixed"
    ("boundary" "------------070105030104060407030601") NIL NIL))
    ---------------------------------------------------------------------------
    Some multiparts are bracketted again.  This is the "alternative" encoding,
    part 1 has two parts, a plain-text part and a html part:
    ( ( (part 1a stuff) (part 1b stuff) "alternative"  (boundary) NIL NIL ) (part 2 stuff) "mixed" (boundary) NIL NIL )
    1 2                                                                 2                                           1
    Example:
    * 50 FETCH (BODYSTRUCTURE ((("text" "plain" ("charset" "ISO-8859-1") NIL NIL
    "quoted-printable" 415 12 NIL NIL NIL)("text" "html" ("charset" "ISO-8859-1")
    NIL NIL "quoted-printable" 1034 25 NIL NIL NIL) "alternative" ("boundary"
    "----=_NextPart_001_0027_01C33A37.33CFE220") NIL NIL)("application" "x-zip-compressed"
    ("name" "IdIMAP4.zip") NIL NIL "base64" 20572 NIL ("attachment" ("filename"
    "IdIMAP4.zip")) NIL) "mixed" ("boundary" "----=_NextPart_000_0026_01C33A37.33CFE220")
    NIL NIL) UID 62)
    }
    LPartsList := TStringList.Create;
    {CC7: New code uses a different parsing method that allows for multisection parts.}
    Trim(ABodyStructure);
    if ABodyStructure[1] <> '(' then begin  {Do not Localize}
        {This has no bracketting, a single-part message...}
        LPartsList.Add(ABodyStructure);
    end else begin
        {Recursively parse it.  Need recursion to ensure the parts are extracted
        in the right order...}
        ParseTheLine(ABodyStructure, LPartsList);
    end;
    LTempList := TStringList.Create;
    if ATheParts <> nil then begin
        ATheParts.Clear;
        for Ln := 0 to LPartsList.Count-1 do begin
            {To add a message part, you need the following synthax...}
            TIdAttachment.Create(ATheParts);
            LThePart := ATheParts[Ln];
            if Copy(LPartsList.Strings[Ln], 1, 1) = '(' then begin  {Do not Localize}
                {Multisection part - parse it again...}
                ParseTheLine(LPartsList.Strings[Ln], LTempList);
                for Lm := 0 to LTempList.Count-1 do begin
                    LWord := LowerCase(GetNextWord(LTempList.Strings[Lm]));
                    {CC7: If using TIdMessageParts, only have room for the first entry,
                    but this is usually "text" so it should be OK - multisection parts
                    are usually text plus html, this part will then be parsed as text,
                    so the user will just see the html after the text.}
                    if ((LWord = '"text"') or (LWord = '"image"') or (LWord = '"application"')) then begin  {Do not Localize}
                        ParseBodyStructurePart(LTempList.Strings[Lm], LThePart, nil, nil);
                        break;  {Can only have one entry}
                    end;
                end;
            end else begin
                ParseBodyStructurePart(LPartsList.Strings[Ln], LThePart, nil, nil);
            end;
        end;
    end;
    LSections := 0;
    if AImapParts <> nil then begin
        AImapParts.Clear;
        for Ln := 0 to LPartsList.Count-1 do begin
            LImapPart := AImapParts.Add;
            if Copy(LPartsList.Strings[Ln], 1, 1) = '(' then begin  {Do not Localize}
                LImapPart.FUnparsedEntry := LPartsList.Strings[Ln];
                {Multisection part - parse it again...}
                ParseTheLine(LPartsList.Strings[Ln], LTempList);
                for Lm := 0 to LTempList.Count-1 do begin
                    LWord := LowerCase(GetNextWord(LTempList.Strings[Lm]));
                    {CC7: If using TIdImapMessageParts, we can add more than the
                    first entry.  We need to set the boundary also.}
                    if ((LWord = '"text"') or (LWord = '"image"') or (LWord = '"application"')) then begin  {Do not Localize}
                        if LSections = 0 then begin
                            ParseBodyStructurePart(LTempList.Strings[Lm], nil, LImapPart, nil);
                            LSections := LSections + 1;
                        end else begin
                            LSubSectionPtr := LImapPart.FSubSection;
                            while LSubSectionPtr<> nil do begin
                                LSubSectionPtr := LSubSectionPtr.FSubSection;
                            end;
                            LSubSectionPtr := TIdImapSubSection.Create;
                            ParseBodyStructurePart(LTempList.Strings[Lm], nil, nil, LSubSectionPtr);
                            LSections := LSections + 1;
                        end;
                    end else if LWord = '"boundary"' then begin  {Do not Localize}
                        LLine := LTempList.Strings[Lm];
                        LLine := Copy(LLine, Length('"boundary"')+1, MaxInt);  {Do not Localize}
                        LImapPart.FBoundary := GetNextQuotedParam(LLine);
                    end;
                end;
            end else begin
                LImapPart.FUnparsedEntry := LPartsList.Strings[Ln];
                ParseBodyStructurePart(LPartsList.Strings[Ln], nil, LImapPart, nil);
            end;
        end;
    end;
end;

procedure TIdIMAP4.ParseTheLine(ALine: string; LPartsList: TStringList);
var
    LTempList: TStringList;
    LN: integer;
    LStr, LWord: string;
begin
    {Parse it and see what we get...}
    LTempList := TStringList.Create;
    ParseIntoParts(ALine, LTempList);
    {Copy any parts from LTempList into the list of parts LPartsList...}
    for LN := 0 to LTempList.Count-1 do begin
        LStr := LTempList.Strings[LN];
        LWord := LowerCase(GetNextWord(LStr));
        if ((LStr[1] = '(') or (LWord = '"text"') or (LWord = '"image"') or (LWord = '"application"')) then begin  {Do not Localize}
            LPartsList.Add(LStr);
        end;
    end;
end;

procedure TIdIMAP4.ParseBodyStructurePart(APartString: string; AThePart: TIdMessagePart; AImapPart: TIdImapMessagePart; AImapSubSection: TIdImapSubSection);
    {CC3: Function added to support individual part retreival}
var
    LParams: TStringList;
    LContentDispositionStuff: string;
    LFilename: string;
    LDescription: string;
    LTemp: string;
    LSize: integer;
begin
    {Individual parameters may be strings like "text", NIL, a number, or bracketted pairs like
    ("CHARSET" "US-ASCII" "NAME" "cc.tif" "format" "flowed")...}
    {There are three common line formats, with differing numbers of parameters:
    (a) "TEXT" "HTML" ("CHARSET" "iso-8859-1") NIL NIL "QUOTED-PRINTABLE" 2879 69 NIL NIL NIL
    (a) "TEXT" "HTML" ("CHARSET" "iso-8859-1") NIL NIL "QUOTED-PRINTABLE" 2879 69 NIL NIL
    (c) "TEXT" "HTML" ("CHARSET" "iso-8859-1") NIL NIL "QUOTED-PRINTABLE" 2879 69
    Note the last one only has 7 parameters, need to watch we don't index past the 7th!}
    LParams := TStringList.Create;
    ParseIntoParts(APartString, LParams);
    {Content Disposition: If present, may be at index 8 or 9...}
    {CC8: Altered to allow for case where it may not be present at all (get "List
    index out of bounds" error if try to access non-existent LParams[9])...}
    LContentDispositionStuff := '';                 {Do not Localize}
    if LParams.Count > 9 then begin  {Have an LParams[9]}
        if LParams[9] = 'NIL' then begin            {Do not Localize}
            {It's NIL at 9, must be at 8...}
            if LParams[8] = 'NIL' then begin        {Do not Localize}
                LContentDispositionStuff := LParams[8];
            end;
        end else begin
            {It's not NIL, must be valid...}
            LContentDispositionStuff := LParams[9];
        end;
    end else if LParams.Count > 8 then begin  {Have an LParams[8]}
        if LParams[8] = 'NIL' then begin            {Do not Localize}
            LContentDispositionStuff := LParams[8];
        end;
    end;

    {Find and clean up the filename, if present...}
    LFilename := ''; {Do not Localize}
    if IndyPos('NAME', UpperCase(APartString)) > 0 then begin {Do not Localize}
        LTemp := Copy(APartString, IndyPos('"NAME" ', UpperCase(APartString))+7, MaxInt); {Do not Localize}
        LFilename := GetNextQuotedParam(LTemp);
    end else if IndyPos('FILENAME', UpperCase(APartString)) > 0 then begin {Do not Localize}
        LTemp := Copy(APartString, IndyPos('"FILENAME" ', UpperCase(APartString))+11, MaxInt); {Do not Localize}
        LFilename := GetNextQuotedParam(LTemp);
    end;
    {If the filename starts and ends with double-quotes, remove them...}
    if Length(LFilename) > 1 then begin
        if ( (LFilename[1] = '"') and (LFilename[Length(LFilename)] = '"') ) then begin  {Do not Localize}
            LFilename := Copy(LFilename, 2, Length(LFilename)-2);
        end;
    end;
    {CC7: The filename may be encoded, so decode it...}
    if Length(LFilename) > 1 then begin
        LFilename := DecodeHeader(LFilename);
    end;

    LSize := 0;
    if ((LParams[6] <> 'NIL') and (LParams[6] <> '')) then LSize := StrToInt(LParams[6]); {Do not Localize}

    LDescription := '';  {Do not Localize}
    if ((LParams.Count > 9) and (LParams[9] <> 'NIL')) then begin  {Do not Localize}
        LDescription := GetNextQuotedParam(LParams[9]);
    end else if ((LParams.Count > 8) and (LParams[8] <> 'NIL')) then begin  {Do not Localize}
        LDescription := GetNextQuotedParam(LParams[8]);
    end;
    if AThePart <> nil then begin
        {Put into the same format as TIdMessage MessageParts...}
        AThePart.ContentType := LParams[0]+'/'+LParams[1]+ParseBodyStructureSectionAsEquates(LParams[2]);  {Do not Localize}
        AThePart.ContentTransfer := LParams[5];
        AThePart.StoredPathName := LFilename;
    end;
    if AImapPart <> nil then begin
        AImapPart.FBodyType := LParams[0];
        AImapPart.FBodySubType := LParams[1];
        AImapPart.FFileName := LFilename;
        AImapPart.FDescription := LDescription;
        AImapPart.FEncoding := LParams[5];
        AImapPart.FSize := LSize;
    end;
    if AImapSubSection <> nil then begin
        AImapSubSection.FBodyType := LParams[0];
        AImapSubSection.FBodySubType := LParams[1];
        AImapSubSection.FFileName := LFilename;
        AImapSubSection.FDescription := LDescription;
        AImapSubSection.FEncoding := LParams[5];
        AImapSubSection.FSize := LSize;
    end;
    LParams.Free;
end;

procedure TIdIMAP4.ParseIntoParts(APartString: string; AParams: TStringList);
var
    LInPart: Integer;
    LStartPos: Integer;
    LParam: string;
    LBracketLevel: Integer;
    Ln: Integer;
begin
    LStartPos := 0; {Stop compiler whining}
    LBracketLevel := 0; {Stop compiler whining}
    LInPart := 0;   {0 is not in a part, 1 is in a quote-delimited part, 2 is in a bracketted parameter-pair list}
    for Ln := 1 to Length(APartString) do begin
        if LInPart = 1 then begin
            if APartString[Ln] = '"' then begin {Do not Localize}
                LParam := Copy(APartString, LStartPos+1, Ln-LStartPos-1);
                AParams.Add(LParam);
                LInPart := 0;
            end;
        end else if LInPart = 2 then begin
            if APartString[Ln] = '(' then begin {Do not Localize}
                Inc(LBracketLevel);
            end else if APartString[Ln] = ')' then begin {Do not Localize}
                Dec(LBracketLevel);
                if LBracketLevel = 0 then begin
                    LParam := Copy(APartString, LStartPos+1, Ln-LStartPos-1);
                    AParams.Add(LParam);
                    LInPart := 0;
                end;
            end;
        end else if LInPart = 3 then begin
            if APartString[Ln] = 'L' then begin {Do not Localize}
                LParam := Copy(APartString, LStartPos, Ln-LStartPos+1);
                AParams.Add(LParam);
                LInPart := 0;
            end;
        end else if LInPart = 4 then begin
            if ((Ord(APartString[Ln]) < Ord('0')) or (Ord(APartString[Ln]) > Ord('9'))) then begin {Do not Localize}
                LParam := Copy(APartString, LStartPos, Ln-LStartPos);
                AParams.Add(LParam);
                LInPart := 0;
            end;
        end else if APartString[Ln] = '"' then begin {Do not Localize}
            {Start of a quoted param like "text"}
            LStartPos := Ln;
            LInPart := 1;
        end else if APartString[Ln] = '(' then begin {Do not Localize}
            {Start of a set of paired parameter/value strings within brackets,
            such as ("charset" "us-ascii").  Note these can be nested (bracket pairs
            within bracket pairs) }
            LStartPos := Ln;
            LInPart := 2;
            LBracketLevel := 1;
        end else if APartString[Ln] = 'N' then begin {Do not Localize}
            {Start of a NIL entry}
            LStartPos := Ln;
            LInPart := 3;
        end else if ((Ord(APartString[Ln]) >= Ord('0')) and (Ord(APartString[Ln]) <= Ord('9'))) then begin {Do not Localize}
            {Start of a numeric entry like 12345}
            LStartPos := Ln;
            LInPart := 4;
        end;
    end;
    {We could be in a numeric entry when we hit the end of the line...}
    if LInPart = 4 then begin
        LParam := Copy(APartString, LStartPos, MaxInt);
        AParams.Add(LParam);
    end;
end;

procedure TIdIMAP4.ParseIntoImapParts(APartString: string; AParams: TStringList);
var
    LInPart: Integer;
    LStartPos: Integer;
    LParam: string;
    LBracketLevel: Integer;
    Ln: Integer;
begin
    {Break:
      * LIST (\UnMarked \AnotherFlag) "/" "Mailbox name"
    into:
      *
      LIST
      (\UnMarked \AnotherFlag)
      "/"
      "Mailbox name"
    }
    AParams.Clear;
    LStartPos := 0; {Stop compiler whining}
    LBracketLevel := 0; {Stop compiler whining}
    LInPart := 0;   {0 is not in a part, 1 is in a quote-delimited part, 2 is in a bracketted part, 3 is a word}
    for Ln := 1 to Length(APartString) do begin
        if LInPart = 1 then begin
            if APartString[Ln] = '"' then begin {Do not Localize}
                LParam := Copy(APartString, LStartPos+1, Ln-LStartPos-1);
                AParams.Add(LParam);
                LInPart := 0;
            end;
        end else if LInPart = 2 then begin
            if APartString[Ln] = '(' then begin {Do not Localize}
                Inc(LBracketLevel);
            end else if APartString[Ln] = ')' then begin {Do not Localize}
                Dec(LBracketLevel);
                if LBracketLevel = 0 then begin
                    LParam := Copy(APartString, LStartPos+1, Ln-LStartPos-1);
                    AParams.Add(LParam);
                    LInPart := 0;
                end;
            end;
        end else if LInPart = 3 then begin
            if APartString[Ln] = ' ' then begin
                LParam := Copy(APartString, LStartPos, Ln-LStartPos);
                AParams.Add(LParam);
                LInPart := 0;
            end;
        end else if APartString[Ln] = '"' then begin {Do not Localize}
            {Start of a quoted param like "text"}
            LStartPos := Ln;
            LInPart := 1;
        end else if APartString[Ln] = '(' then begin {Do not Localize}
            {Start of a set of paired parameter/value strings within brackets,
            such as ("charset" "us-ascii").  Note these can be nested (bracket pairs
            within bracket pairs) }
            LStartPos := Ln;
            LInPart := 2;
            LBracketLevel := 1;
        end else if APartString[Ln] <> ' ' then begin {Do not Localize}
            {Start of an entry like 12345}
            LStartPos := Ln;
            LInPart := 3;
        end;
    end;
    {We could be in an entry when we hit the end of the line...}
    if LInPart > 0 then begin
        //TODO: This does not check for a closing ) or "
        LParam := Copy(APartString, LStartPos, MaxInt);
        AParams.Add(LParam);
    end;
end;

function TIdIMAP4.ParseBodyStructureSectionAsEquates(AParam: string): string;
    {Convert:
     "Name1" "Value1" "Name2" "Value2"
     to:
     ; Name1="Value1"; Name2="Value2"
    }
var
    LParse: TStringList;
    LN: integer;
begin
    Result := '';  {Do not Localize}
    if ((AParam = '') or (AParam = 'NIL')) then begin {Do not Localize}
        Exit;
    end;
    LParse := TStringList.Create;
    BreakApartParamsInQuotes(AParam, LParse); {Do not Localize}
    if LParse.Count < 2 then begin
        Exit;
    end;
    if ((LParse.Count mod 2) <> 0) then begin
        Exit;
    end;
    for LN := 0 to ((LParse.Count div 2)-1) do begin
        Result := Result + '; ' + Copy(LParse[LN*2], 2, Length(LParse[LN*2])-2) + '=' + LParse[(LN*2)+1]; {Do not Localize}
    end;
    LParse.Free;
end;

function TIdIMAP4.ParseBodyStructureSectionAsEquates2(AParam: string): string;
    {Convert:
     "Name1" ("Name2" "Value2")
     to:
     Name1; Name2="Value2"
    }
var
    LParse: TStringList;
    LParams: string;
begin
    Result := ''; {Do not Localize}
    if ((AParam = '') or (AParam = 'NIL')) then begin {Do not Localize}
        Exit;
    end;
    LParse := TStringList.Create;
    BreakApart(AParam, ' ', LParse); {Do not Localize}
    if LParse.Count < 3 then begin
        Exit;
    end;
    LParams := Copy(AParam, Pos('(', AParam)+1, MaxInt); {Do not Localize}
    LParams := Copy(LParams, 1, Length(LParams)-1);
    LParams := ParseBodyStructureSectionAsEquates(LParams);
    if LParams <> '' then begin {Do not Localize}
        Result := Copy(LParse[0], 2, Length(LParse[0])-2) + LParams;
    end;
    LParse.Free;
end;

function TIdIMAP4.GetNextWord(AParam: string): string;
var
    LPos: integer;
begin
    Result := '';  {Do not Localize}
    Trim(AParam);
    LPos := Pos(' ', AParam);  {Do not Localize}
    if LPos = 0 then begin
        Exit;
    end;
    Result := Copy(AParam, 1, LPos-1);
end;

function TIdIMAP4.GetNextQuotedParam(AParam: string): string;
var
    LN: integer;
begin
    LN := 1;
    while AParam[LN] <> '"' do begin  {Do not Localize}
        LN := LN + 1;
    end;
    AParam := Copy(AParam, LN, MaxInt);
    LN := 2;
    while AParam[LN] <> '"' do begin  {Do not Localize}
        LN := LN + 1;
    end;
    Result := Copy(AParam, 1, LN);
end;

procedure TIdIMAP4.BreakApartParamsInQuotes(const AParam: string; var AParsedList: TStringList);
var
    Ln : Integer;
    LStartPos: Integer;
begin
    LStartPos := -1;
    AParsedList.Clear;
    for Ln := 1 to Length(AParam) do begin
        if AParam[LN] = '"' then begin {Do not Localize}
            if LStartPos > -1 then begin
                {The end of a quoted parameter...}
                AParsedList.Add(Copy(AParam, LStartPos, LN-LStartPos+1));
                LStartPos := -1;
            end else begin
                {The start of a quoted parameter...}
                LStartPos := Ln;
            end;
        end;
    end;
end;

procedure TIdIMAP4.ParseExpungeResult(AMB: TIdMailBox; CmdResultDetails: TStrings);
var
    Ln : Integer;
    LSlExpunge : TStringList;
begin
    LSlExpunge := TStringList.Create;
    SetLength ( AMB.DeletedMsgs, 0 );
    try
        if ( CmdResultDetails.Count > 1 ) then begin
            for Ln := 0 to ( CmdResultDetails.Count - 2 ) do begin
                 BreakApart ( CmdResultDetails[Ln], ' ', LSlExpunge ); {Do not Localize}
                 if AnsiSameText ( LSlExpunge[1], IMAP4Commands[cmdExpunge] ) then begin
                      SetLength ( AMB.DeletedMsgs, ( Length ( AMB.DeletedMsgs ) + 1 ) );
                      AMB.DeletedMsgs[Length ( AMB.DeletedMsgs ) - 1] := StrToInt ( LSlExpunge[0] );
                 end;
                 LSlExpunge.Clear;
            end;
        end;
    finally
        LSlExpunge.Free;
    end;
end;

procedure TIdIMAP4.ParseMessageFlagString(AFlagsList: String; var AFlags: TIdMessageFlagsSet);
    {CC5: Note this only supports the system flags defined in RFC 2060.}
var LSlFlags : TStringList;
    Ln : Integer;
begin
    LSlFlags := TStringList.Create;
    AFlags := [];
    BreakApart ( AFlagsList, ' ', LSlFlags ); {Do not Localize}
    try
        for Ln := 0 to ( LSlFlags.Count - 1 ) do begin
            if AnsiSameText ( LSlFlags[Ln], MessageFlags[mfAnswered] ) then begin
                AFlags := AFlags + [mfAnswered];
            end else if AnsiSameText ( LSlFlags[Ln], MessageFlags[mfFlagged] ) then begin
                AFlags := AFlags + [mfFlagged];
            end else if AnsiSameText ( LSlFlags[Ln], MessageFlags[mfDeleted] ) then begin
                AFlags := AFlags + [mfDeleted];
            end else if AnsiSameText ( LSlFlags[Ln], MessageFlags[mfDraft] ) then begin
                AFlags := AFlags + [mfDraft];
            end else if AnsiSameText ( LSlFlags[Ln], MessageFlags[mfSeen] ) then begin
                AFlags := AFlags + [mfSeen];
            end else if AnsiSameText ( LSlFlags[Ln], MessageFlags[mfRecent] ) then begin
                AFlags := AFlags + [mfRecent];
            end;
        end;
    finally
        LSlFlags.Free;
    end;
end;

procedure TIdIMAP4.ParseMailBoxAttributeString(AAttributesList: String; var AAttributes: TIdMailBoxAttributesSet);
var LSlAttributes : TStringList;
    Ln : Integer;
begin
    LSlAttributes := TStringList.Create;
    AAttributes := [];
    BreakApart ( AAttributesList, ' ', LSlAttributes ); {Do not Localize}
    try
        for Ln := 0 to ( LSlAttributes.Count - 1 ) do begin
            if AnsiSameText ( LSlAttributes[Ln], MailBoxAttributes[maNoinferiors] ) then begin
                AAttributes := AAttributes + [maNoinferiors];
            end else if AnsiSameText ( LSlAttributes[Ln], MailBoxAttributes[maNoselect] ) then begin
                AAttributes := AAttributes + [maNoselect];
            end else if AnsiSameText ( LSlAttributes[Ln], MailBoxAttributes[maMarked] ) then begin
                AAttributes := AAttributes + [maMarked];
            end else if AnsiSameText ( LSlAttributes[Ln], MailBoxAttributes[maUnmarked] ) then begin
                AAttributes := AAttributes + [maUnmarked];
            end;
        end;
    finally
        LSlAttributes.Free;
    end;
end;

procedure TIdIMAP4.ParseSearchResult(AMB: TIdMailBox; CmdResultDetails: TStrings);
var Ln: Integer;
    LSlSearch: TStringList;
begin
    LSlSearch := TStringList.Create;
    SetLength ( AMB.SearchResult, 0 );
    try
        if ( ( Pos ( IMAP4Commands[cmdSearch], CmdResultDetails[0] ) > 0 ) and
          ( CmdResultDetails.Count > 1 ) ) then begin
            BreakApart ( CmdResultDetails[0], ' ', LSlSearch ); {Do not Localize}
            for Ln := 1 to ( LSlSearch.Count - 1 ) do begin
                 SetLength ( AMB.SearchResult, ( Length ( AMB.SearchResult ) + 1 ) );
                 AMB.SearchResult[Length ( AMB.SearchResult ) - 1] := StrToInt ( LSlSearch[Ln] );
            end;
        end;
    finally
        LSlSearch.Free;
    end;
end;

procedure TIdIMAP4.ParseStatusResult(AMB: TIdMailBox; CmdResultDetails: TStrings);
var Ln : Integer;
    LStr : String;
    LSlStatus : TStringList;
begin
    LSlStatus := TStringList.Create;
    try
        if ( ( Pos ( IMAP4Commands[cmdStatus], CmdResultDetails[0] ) > 0 ) and
          ( CmdResultDetails.Count > 1 ) ) then begin
            LStr := Copy ( CmdResultDetails[0],
            ( Pos ( IMAP4Commands[cmdStatus], CmdResultDetails[0] ) +
            Length ( IMAP4Commands[cmdStatus] ) ),
            Length ( CmdResultDetails[0] ) );
            AMB.Name := Trim ( Copy ( LStr, 1, ( Pos ( '(', LStr ) - 1 ) ) ); {Do not Localize}
            LStr := Copy ( LStr, ( Pos ( '(', LStr ) + 1 ), {Do not Localize}
            ( Length ( LStr ) - Pos ( '(', LStr ) - 1 ) ); {Do not Localize}
            BreakApart ( LStr, ' ', LSlStatus ); {Do not Localize}
            Ln := 0;
            while ( Ln < LSlStatus.Count ) do begin
                if AnsiSameText ( LSlStatus[Ln], IMAP4StatusDataItem[mdMessages] ) then begin
                    AMB.TotalMsgs := StrToInt ( LSlStatus[Ln + 1] );
                    Ln := Ln + 2;
                end else if AnsiSameText ( LSlStatus[Ln], IMAP4StatusDataItem[mdRecent] ) then begin
                    AMB.RecentMsgs := StrToInt ( LSlStatus[Ln + 1] );
                    Ln := Ln + 2;
                end else if AnsiSameText ( LSlStatus[Ln], IMAP4StatusDataItem[mdUnseen] ) then begin
                    AMB.UnseenMsgs := StrToInt ( LSlStatus[Ln + 1] );
                    Ln := Ln + 2;
                end else if AnsiSameText ( LSlStatus[Ln], IMAP4StatusDataItem[mdUIDNext] ) then begin
                    AMB.UIDNext := LSlStatus[Ln + 1];
                    Ln := Ln + 2;
                end else if AnsiSameText ( LSlStatus[Ln], IMAP4StatusDataItem[mdUIDValidity] ) then begin
                    AMB.UIDValidity := LSlStatus[Ln + 1];
                    Ln := Ln + 2;
                end;
            end;
        end;
    finally
        LSlStatus.Free;
    end;
end;

procedure TIdIMAP4.ParseSelectResult(AMB : TIdMailBox; CmdResultDetails: TStrings);
var Ln : Integer;
    LStr : String;
    LFlags: TIdMessageFlagsSet;
begin
    AMB.Clear;
    for Ln := 0 to ( CmdResultDetails.Count - 1 ) do begin
        if ( Pos ( 'EXISTS', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            AMB.TotalMsgs := StrToInt ( Trim ( Copy ( CmdResultDetails[Ln], 0,
             ( Pos ( 'EXISTS', CmdResultDetails[Ln] ) - 1 ) ) ) ); {Do not Localize}
        end;
        if ( Pos ( 'RECENT', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            AMB.RecentMsgs := StrToInt ( Trim ( Copy ( CmdResultDetails[Ln], 0,
             ( Pos ( 'RECENT', CmdResultDetails[Ln] ) - 1 ) ) ) ); {Do not Localize}
        end;
        if ( Pos ( '[UIDVALIDITY', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            AMB.UIDValidity := Trim ( Copy ( CmdResultDetails[Ln],
             ( Pos ( '[UIDVALIDITY', CmdResultDetails[Ln] ) + {Do not Localize}
             Length ( '[UIDVALIDITY' ) ), {Do not Localize}
             ( Pos ( ']', CmdResultDetails[Ln] ) -    {Do not Localize}
             ( Pos ( '[UIDVALIDITY', CmdResultDetails[Ln] ) +    {Do not Localize}
             Length ( '[UIDVALIDITY' ) ) ) ) ); {Do not Localize}
        end;
        if ( Pos ( '[UIDNEXT', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            AMB.UIDNext := Trim ( Copy ( CmdResultDetails[Ln],
             ( Pos ( '[UIDNEXT', CmdResultDetails[Ln] ) + {Do not Localize}
             Length ( '[UIDNEXT' ) ), {Do not Localize}
             ( Pos ( ']', CmdResultDetails[Ln] ) -    {Do not Localize}
             ( Pos ( '[UIDNEXT', CmdResultDetails[Ln] ) +    {Do not Localize}
             Length ( '[UIDNEXT' ) ) - 1 ) ) ); {Do not Localize}
        end;
        if ( Pos ( 'FLAGS', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            ParseMessageFlagString ( Copy ( CmdResultDetails[Ln],
             ( Pos ( '(', CmdResultDetails[Ln] ) + 1 ), {Do not Localize}
             ( Pos ( ')', CmdResultDetails[Ln] ) -    {Do not Localize}
             Pos ( '(', CmdResultDetails[Ln] ) - 1 ) ), LFlags ); {Do not Localize}
            AMB.Flags := LFlags;
        end;
        if ( Pos ( '[PERMANENTFLAGS', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            ParseMessageFlagString ( Copy ( CmdResultDetails[Ln],
             ( Pos ( '(', CmdResultDetails[Ln] ) + 1 ), {Do not Localize}
             ( Pos ( ')', CmdResultDetails[Ln] ) -    {Do not Localize}
             Pos ( '(', CmdResultDetails[Ln] ) - 1 ) ), {Do not Localize}
             LFlags );
            AMB.ChangeableFlags := LFlags;
        end;
        if ( Pos ( '[UNSEEN', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            AMB.FirstUnseenMsg := StrToInt ( Trim ( Copy ( CmdResultDetails[Ln],
             ( Pos ( '[UNSEEN', CmdResultDetails[Ln] ) + {Do not Localize}
             Length ( '[UNSEEN' ) ), {Do not Localize}
             ( Pos ( ']', CmdResultDetails[Ln] ) -    {Do not Localize}
             ( Pos ( '[UNSEEN', CmdResultDetails[Ln] ) +    {Do not Localize}
             Length ( '[UNSEEN' ) ) ) ) ) ); {Do not Localize}
        end;
        if ( Pos ( '[READ-', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            LStr := Trim ( Copy ( CmdResultDetails[Ln],
             ( Pos ( '[', CmdResultDetails[Ln] ) ), {Do not Localize}
             ( Pos ( ']', CmdResultDetails[Ln] ) - Pos ( '[', CmdResultDetails[Ln] ) + 1 ) ) ); {Do not Localize}
            if AnsiSameText ( LStr, '[READ-WRITE]' ) then begin {Do not Localize}
                AMB.State := msReadWrite;
            end else if AnsiSameText ( LStr, '[READ-ONLY]' ) then begin {Do not Localize}
                AMB.State := msReadOnly;
            end;
        end;
        if ( Pos ( '[ALERT]', CmdResultDetails[Ln] ) > 0 ) then begin {Do not Localize}
            LStr := Trim ( Copy ( CmdResultDetails[Ln],
             ( Pos ( '[ALERT]', CmdResultDetails[Ln] ) + {Do not Localize}
             Length ( '[ALERT]' ) ), MaxInt ) ); {Do not Localize}
            if ( LStr <> '' ) then begin    {Do not Localize}
                DoAlert ( LStr );
            end;
        end;
    end;
end;

procedure TIdIMAP4.ParseListResult(AMBList: TStringList; CmdResultDetails: TStrings);
begin
    InternalParseListResult(IMAP4Commands[cmdList], AMBList, CmdResultDetails);
end;

procedure TIdIMAP4.InternalParseListResult(ACmd: string; AMBList: TStringList; CmdResultDetails: TStrings);
var Ln : Integer;
    LSlRetrieve : TStringList;
    LStr : String;
    //LPos: Integer;
    LWord: string;
begin
    AMBList.Clear;
    LSlRetrieve := TStringList.Create;
    try
        for Ln := 0 to ( CmdResultDetails.Count - 2 ) do begin
            LStr := CmdResultDetails[Ln];
            //if ( Pos ( IMAP4Commands[cmdList], LStr ) = 1 ) then begin
                //TODO: Get mail box attributes here
                {CC2: Could put mailbox attributes in AMBList's Objects property?}
                {The line is of the form:
                * LIST (\UnMarked \AnotherFlag) "/" "Mailbox name"
                }
                {CCA: code modified because some servers return NIL as the mailbox
                separator, i.e.:
                * LIST (\UnMarked \AnotherFlag) NIL "Mailbox name"
                }


                //BreakApart ( LStr, ' ', LSlRetrieve ); {Do not Localize}
                ParseIntoImapParts(LStr, LSlRetrieve);
                if LSlRetrieve.Count > 3 then begin
                    //Make sure 1st word is LIST (may be an unsolicited response)...
                    if AnsiSameText ( LSlRetrieve[0], {IMAP4Commands[cmdList]} ACmd ) then begin
                        {Get the mailbox separator...}
                        LWord := Trim(LSlRetrieve[LSlRetrieve.Count-2]);
                        if ( AnsiSameText(LWord, 'NIL')
                          or AnsiSameText(LWord, '') ) then begin
                            FMailBoxSeparator := #0;
                        end else begin
                            FMailBoxSeparator := LWord[1];
                        end;
                        {Now get the mailbox name...}
                        LWord := Trim(LSlRetrieve[LSlRetrieve.Count-1]);
                        AMBList.Add ( LWord );
                    end;
                end;

            //end;
        end;
    finally
        LSlRetrieve.Free;
    end;
end;

procedure TIdIMAP4.ParseLSubResult(AMBList: TStringList; CmdResultDetails: TStrings);
begin
    InternalParseListResult(IMAP4Commands[cmdLSub], AMBList, CmdResultDetails);
end;

procedure TIdIMAP4.ParseEnvelopeResult(AMsg: TIdMessage; ACmdResultStr: String);

    procedure DecodeEnvelopeAddress (const AAddressStr: String; AEmailAddressItem: TIdEmailAddressItem); overload;
    var LStr: String;
        LPChar: PChar;
    begin
        if ( ( AAddressStr[1] = '(' ) and    {Do not Localize}
          ( AAddressStr[Length (AAddressStr)] = ')' ) and    {Do not Localize}
          Assigned (AEmailAddressItem) ) then begin
            LStr := Copy (AAddressStr, 2, Length (AAddressStr) - 2);
            //Gets the name part
            if AnsiSameText (Copy (LStr, 1, Pos (' ', LStr) - 1), 'NIL') then begin    {Do not Localize}
                LStr := Copy (LStr, Pos (' ', LStr) + 1, MaxInt);    {Do not Localize}
            end else begin
                if ( LStr[1] = '{' ) then begin    {Do not Localize}
                    LStr := Copy (LStr, Pos ('}', LStr) + 1, MaxInt);    {Do not Localize}
                    AEmailAddressItem.Name := Copy (LStr, 1, Pos ('" ', LStr) - 1);    {Do not Localize}
                    LStr := Copy (LStr, Pos ('" ', LStr) + 2, MaxInt);    {Do not Localize}
                end else begin
                    LPChar := PChar (Copy (LStr, 1, Pos ('" ', LStr)));    {Do not Localize}
                    AEmailAddressItem.Name := AnsiExtractQuotedStr ( LPChar, '"' );    {Do not Localize}
                    LStr := Copy (LStr, Pos ('" ', LStr) + 2, MaxInt);    {Do not Localize}
                end;
            end;
            //Gets the source root part
            if AnsiSameText (Copy (LStr, 1, Pos (' ', LStr) - 1), 'NIL') then begin    {Do not Localize}
                LStr := Copy (LStr, Pos (' ', LStr) + 1, MaxInt);    {Do not Localize}
            end else begin
                LPChar := PChar (Copy (LStr, 1, Pos ('" ', LStr)));    {Do not Localize}
                AEmailAddressItem.Name := AnsiExtractQuotedStr ( LPChar, '"' );    {Do not Localize}
                LStr := Copy (LStr, Pos ('" ', LStr) + 2, MaxInt);    {Do not Localize}
            end;
            //Gets the mailbox name part
            if AnsiSameText (Copy (LStr, 1, Pos (' ', LStr) - 1), 'NIL') then begin    {Do not Localize}
                LStr := Copy (LStr, Pos (' ', LStr) + 1, MaxInt);    {Do not Localize}
            end else begin
                LPChar := PChar (Copy (LStr, 1, Pos ('" ', LStr)));    {Do not Localize}
                AEmailAddressItem.Address := AnsiExtractQuotedStr ( LPChar, '"' );    {Do not Localize}
                LStr := Copy (LStr, Pos ('" ', LStr) + 2, MaxInt);    {Do not Localize}
            end;
            //Gets the host name part
            if not AnsiSameText (Copy (LStr, 1, MaxInt), 'NIL') then begin    {Do not Localize}
                LPChar := PChar (Copy (LStr, 1, MaxInt));
                AEmailAddressItem.Address := AEmailAddressItem.Address + '@' +    {Do not Localize}
                AnsiExtractQuotedStr ( LPChar, '"' );    {Do not Localize}
            end;
        end;
    end;

    procedure DecodeEnvelopeAddress (const AAddressStr: String; AEmailAddressList: TIdEmailAddressList); overload;
    var LStr: String;
    begin
        if ( ( AAddressStr[1] = '(' ) and    {Do not Localize}
          ( AAddressStr[Length (AAddressStr)] = ')' ) and    {Do not Localize}
          Assigned (AEmailAddressList) ) then begin
            LStr := Copy (AAddressStr, 2, Length (AAddressStr) - 2);
            while ( Pos (')', LStr) > 0 ) do begin    {Do not Localize}
                DecodeEnvelopeAddress (Copy (LStr, 1, Pos (')', LStr)), AEmailAddressList.Add);    {Do not Localize}
                LStr := Trim (Copy (LStr, Pos (')', LStr) + 1, MaxInt));    {Do not Localize}
            end;
        end;
    end;
var LStr: String;
    LPChar: PChar;
begin
    //The fields of the envelope structure are in the
    //following order: date, subject, from, sender,
    //reply-to, to, cc, bcc, in-reply-to, and message-id.
    //The date, subject, in-reply-to, and message-id
    //fields are strings.  The from, sender, reply-to,
    //to, cc, and bcc fields are parenthesized lists of
    //address structures.

    //An address structure is a parenthesized list that
    //describes an electronic mail address.  The fields
    //of an address structure are in the following order:
    //personal name, [SMTP] at-domain-list (source
    //route), mailbox name, and host name.

    //* 4 FETCH (ENVELOPE ("Sun, 15 Jul 2001 02:56:45 -0700 (PDT)" "Your Borland Commu
    //nity Account Activation Code" (("Borland Community" NIL "mailbot" "borland.com")
    //) NIL NIL (("" NIL "name" "company.com")) NIL NIL NIL "<200107150956.CAA1
    //8152@borland.com>"))

    {CC5: Cleared out any existing fields to avoid mangling new entries with old/stale ones.}
    //Extract envelope date field
    AMsg.Date := 0;
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        LPChar := PChar (Copy (ACmdResultStr, 1, Pos ('" ', ACmdResultStr)));                       {Do not Localize}
        LStr := AnsiExtractQuotedStr (LPChar, '"');                                                 {Do not Localize}
        AMsg.Date := GMTToLocalDateTime (LStr);
        ACmdResultStr := Copy (ACmdResultStr, Pos ('" ', ACmdResultStr) + 2, MaxInt);               {Do not Localize}
    end;
    //Extract envelope subject field
    AMsg.Subject := '';                                                                             {Do not Localize}
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        if ( ACmdResultStr[1] = '{' ) then begin                                                    {Do not Localize}
            ACmdResultStr := Copy (ACmdResultStr, Pos ('}', ACmdResultStr) + 1, MaxInt);            {Do not Localize}
            LStr := Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1);                          {Do not Localize}
            AMsg.Subject := LStr;
            ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);            {Do not Localize}
        end else begin
            LPChar := PChar (Copy (ACmdResultStr, 1, Pos ('" ', ACmdResultStr)));                   {Do not Localize}
            LStr := AnsiExtractQuotedStr (LPChar, '"');                                             {Do not Localize}
            AMsg.Subject := LStr;
            ACmdResultStr := Copy (ACmdResultStr, Pos ('" ', ACmdResultStr) + 2, MaxInt);           {Do not Localize}
        end;
    end;
    //Extract envelope from field
    AMsg.From.Name := '';                                                                           {Do not Localize}
    AMsg.From.Address := '';                                                                        {Do not Localize}
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        LStr := Copy (ACmdResultStr, 2, Pos (')) ', ACmdResultStr) - 1);                            {Do not Localize}
        DecodeEnvelopeAddress (LStr, AMsg.From);
        ACmdResultStr := Copy (ACmdResultStr, Pos (')) ', ACmdResultStr) + 3, MaxInt);              {Do not Localize}
    end;
    //Extract envelope sender field
    AMsg.Sender.Name := '';                                                                         {Do not Localize}
    AMsg.Sender.Address := '';                                                                      {Do not Localize}
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        {CC5: Fix parsing of sender...}
        {LStr := Copy (ACmdResultStr, 1, Pos (')) ', ACmdResultStr) + 1);                           {Do not Localize}
        LStr := Copy (ACmdResultStr, 2, Pos (')) ', ACmdResultStr) - 1);                            {Do not Localize}
        DecodeEnvelopeAddress (LStr, AMsg.Sender);
        ACmdResultStr := Copy (ACmdResultStr, Pos (')) ', ACmdResultStr) + 3, MaxInt);              {Do not Localize}
    end;
    //Extract envelope reply-to field
    AMsg.ReplyTo.Clear;
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        LStr := Copy (ACmdResultStr, 1, Pos (')) ', ACmdResultStr) + 1);                            {Do not Localize}
        DecodeEnvelopeAddress (LStr, AMsg.ReplyTo);
        ACmdResultStr := Copy (ACmdResultStr, Pos (')) ', ACmdResultStr) + 3, MaxInt);              {Do not Localize}
    end;
    //Extract envelope to field
    AMsg.Recipients.Clear;
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        LStr := Copy (ACmdResultStr, 1, Pos (')) ', ACmdResultStr) + 1);                            {Do not Localize}
        DecodeEnvelopeAddress (LStr, AMsg.Recipients);
        ACmdResultStr := Copy (ACmdResultStr, Pos (')) ', ACmdResultStr) + 3, MaxInt);              {Do not Localize}
    end;
    //Extract envelope cc field
    AMsg.CCList.Clear;
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        LStr := Copy (ACmdResultStr, 1, Pos (')) ', ACmdResultStr) + 1);                            {Do not Localize}
        DecodeEnvelopeAddress (LStr, AMsg.CCList);
        ACmdResultStr := Copy (ACmdResultStr, Pos (')) ', ACmdResultStr) + 3, MaxInt);              {Do not Localize}
    end;
    //Extract envelope bcc field
    AMsg.BccList.Clear;
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        LStr := Copy (ACmdResultStr, 1, Pos (')) ', ACmdResultStr) + 1);                            {Do not Localize}
        DecodeEnvelopeAddress (LStr, AMsg.BccList);
        ACmdResultStr := Copy (ACmdResultStr, Pos (')) ', ACmdResultStr) + 3, MaxInt);              {Do not Localize}
    end;
    //Extract envelope in-reply-to field
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        LPChar := PChar (Copy (ACmdResultStr, 1, Pos ('" ', ACmdResultStr)));                       {Do not Localize}
        LStr := AnsiExtractQuotedStr (LPChar, '"');                                                 {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos ('" ', ACmdResultStr) + 2, MaxInt);               {Do not Localize}
    end;
    //Extract envelope message-id field
    AMsg.MsgId := '';  {Do not Localize}
    if AnsiSameText (Copy (ACmdResultStr, 1, Pos (' ', ACmdResultStr) - 1), 'NIL') then begin       {Do not Localize}
        ACmdResultStr := Copy (ACmdResultStr, Pos (' ', ACmdResultStr) + 1, MaxInt);                {Do not Localize}
    end else begin
        LPChar := PChar (ACmdResultStr);
        LStr := AnsiExtractQuotedStr (LPChar, '"');                                                 {Do not Localize}
        AMsg.MsgId := Trim (LStr);
    end;
end;

{ ...Parser Functions }

function TIdIMAP4.ArrayToNumberStr (const AMsgNumList: array of Integer): String;
var Ln : Integer;
begin
    for Ln := 0 to ( Length ( AMsgNumList ) - 1 ) do begin
        Result := Result + IntToStr ( AMsgNumList[Ln] ) + ',';                                      {Do not Localize}
    end;
    SetLength ( Result, ( Length ( Result ) - 1 ) );
end;

function TIdIMAP4.MessageFlagSetToStr(const AFlags: TIdMessageFlagsSet): String;
begin
    Result := '';                                                                                   {Do not Localize}
    if mfAnswered in AFlags then begin
        Result := Result + MessageFlags[mfAnswered] + ' ';                                          {Do not Localize}
    end;
    if mfFlagged in AFlags then begin
        Result := Result + MessageFlags[mfFlagged] + ' ';                                           {Do not Localize}
    end;
    if mfDeleted in AFlags then begin
        Result := Result + MessageFlags[mfDeleted] + ' ';                                           {Do not Localize}
    end;
    if mfDraft in AFlags then begin
        Result := Result + MessageFlags[mfDraft] + ' ';                                             {Do not Localize}
    end;
    if mfSeen in AFlags then begin
        Result := Result + MessageFlags[mfSeen] + ' '; {Do not Localize}
    end;
end;

function TIdIMAP4.DateToIMAPDateStr(const ADate: TDateTime): String;
var LDay, LMonth, LYear : Word;
begin
    {Do not use the global settings from the system unit here because:
    1) It might not be thread safe
    2) Changing the settings could create problems for a user who's local date conventions
    are diffrent than dd-mm-yyyy.  Some people prefer mm-dd-yyy.  Don't mess with a user's display settings.
    3) Using the display settings for dates may not always work as expected if a user
    changes their settings at a time between whn you do it but before the date is formatted.
    }
    DecodeDate(ADate,LYear,LMonth,LDay);
    Result := Format('%2.d',[LDay]) + '-' + UpperCase(monthnames[LMonth]) + '-' + Format('%4.d',[LYear]);    {Do not Localize}
end;

procedure TIdIMAP4.StripCRLFs(var AText: string);
var
    LPos: integer;
    LLen: integer;
begin
    LPos := 1;
    LLen := Length(AText);
    while LPos < LLen do begin
        if ( (AText[LPos] = #13) and (AText[LPos+1] = #10) ) then begin
            AText := Copy(AText, 1, LPos-1) + Copy(AText, LPos+2, MaxInt);
            LLen := LLen-2;
        end else begin
            LPos := LPos + 1;
        end;
    end;
end;

procedure TIdIMAP4.ParseResponse(const AStrings: TStrings);
var
  i: Integer;
  s: string;
  LPos: integer;
  LBuf : String;
begin
    FLastCmdResult.Clear;
    if AStrings.Count > 0 then begin
        LPos := Pos(' ', AStrings[0]); {Do not Localize}
        if LPos <> 0 then begin
            s := Trim(Copy(AStrings[0], 1, LPos-1));
            if s = '*' then begin {Do not Localize}
                LBuf := TrimLeft(AStrings[0]);
                s := Fetch(LBuf);
                if PosInStrArray(Fetch(LBuf,' ',False),VALID_TAGGEDREPLIES)>-1 then begin {Do not Localize}
                    s := s + ' '+Fetch(LBuf); {Do not Localize}
                    FLastCmdResult.TextCode := s;
                    FLastCmdResult.Text.Add(LBuf);
                    //Exit;
                end;
            end;
        end;
        FLastCmdResult.TextCode := s;
        for i := 0 to AStrings.Count - 1 do begin
          {FLastCmdResult.Text.Add(Copy(AStrings[i], 5, MaxInt));}
          FLastCmdResult.Text.Add(Copy(AStrings[i], Length(s)+1, MaxInt));
        end;
    end;
end;

procedure TIdIMAP4.ParseLineResponse(const ATag: String; const AStrings: TStrings);
var
    LN: Integer;
    LStr: string;
    LResponse: string;
begin
    FLastCmdResult.Clear;
    LResponse := '';  {Do not Localize}
    if AStrings.Count > 0 then begin
        {CC4: Recoded this section to return the response properly}
        LStr := Trim (AStrings[AStrings.Count - 1]);
        {CC4: Unlike the other responses, the continuation response of + does
        NOT have an ATag (like C61) in front of it.  Also note the text after the +
        varies from server to server.}
        if ( (LStr[1] = '+') and (LStr[2] = ' ') ) then begin {Do not Localize}
            FLastCmdResult.TextCode := '+'; {Do not Localize}
            {Need the response we trapped later...}
            LResponse := '+ '; {Do not Localize}
        end else if ( (LStr[1] = '*') and (LStr[2] = ' ') ) then begin {Do not Localize}
            {CC4: This was in the original code, but I don't know if a * response gets to here}
            FLastCmdResult.TextCode := 'OK'; {Do not Localize}
            {Need the response we trapped later...}
            LResponse := '* '; {Do not Localize}
        end else begin
            {CC4: Don't assume the response is 3 chars long, get the response as a word...}
            {s := Trim (Copy (AStrings[AStrings.Count - 1], Length (ATag) + 2, 3));}
            LStr := Trim (Copy (AStrings[AStrings.Count - 1], Length (ATag) + 2, MaxInt));
            LStr := Copy(LStr, 1, Pos(' ', LStr)-1); {Do not Localize}
            FLastCmdResult.TextCode := LStr;
            {Need the response we trapped later...}
            LResponse := ATag+' '+LStr+' ' ;  {Do not Localize}
        end;
        for LN := 0 to AStrings.Count - 1 do begin
            {CC4: Correct the copying of the response...}
            {if ( AnsiSameText (Copy (AStrings[LN], 1, Length (ATag)), ATag) ) then}
            if ( AnsiSameText (Copy (AStrings[LN], 1, Length (LResponse)), LResponse) ) then begin
                {FLastCmdResult.Text.Add (Trim (Copy (AStrings[LN], Length (ATag) + 5, MaxInt)));}
                FLastCmdResult.Text.Add (Trim (Copy (AStrings[LN], Length (LResponse)+1, MaxInt)));
            end else begin
                FLastCmdResult.Text.Add(Copy(AStrings[LN], 3, MaxInt));
            end;
        end;
    end;
end;

procedure TIdIMAP4.ParseResponse(const ATag: String; const AStrings: TStrings);
var
    LN: Integer;
    LStr: string;
    LResponse: string;
begin
    FLastCmdResult.Clear;
    LResponse := '';  {Do not Localize}
    if AStrings.Count > 0 then begin
        {CC4: Recoded this section to return the response properly}
        {CC4: Unlike the other responses, the continuation response of + does
        NOT have an ATag (like C61) in front of it.  Also note the text after the +
        varies from server to server.}
        {if AnsiSameText (Trim (AStrings[AStrings.Count - 1]), '+ Ready for argument') then {Do not Localize}
        LStr := Trim (AStrings[AStrings.Count - 1]);
        if ( (LStr[1] = '+') and (LStr[2] = ' ') ) then begin {Do not Localize}
            {CC4: Rubbish, return + if it is a continuation, not OK...}
            {FLastCmdResult.TextCode := 'OK'; {Do not Localize}
            FLastCmdResult.TextCode := '+'; {Do not Localize}
            {Need the response we trapped later...}
            LResponse := '+ '; {Do not Localize}
        end else begin
            {CC4: Don't assume the response is 3 chars long, get the response as a word...}
            {s := Trim (Copy (AStrings[AStrings.Count - 1], Length (ATag) + 2, 3));}
            LStr := Trim (Copy (AStrings[AStrings.Count - 1], Length (ATag) + 2, MaxInt));
            LStr := Copy(LStr, 1, Pos(' ', LStr)-1); {Do not Localize}
            FLastCmdResult.TextCode := LStr;
            {Need the response we trapped later...}
            LResponse := ATag+' '+LStr+' ' ; {Do not Localize}
        end;
        for LN := 0 to AStrings.Count - 1 do begin
            {CC4: Correct the copying of the response...}
            {if ( AnsiSameText (Copy (AStrings[LN], 1, Length (ATag)), ATag) ) then}
            if ( AnsiSameText (Copy (AStrings[LN], 1, Length (LResponse)), LResponse) ) then begin
                {FLastCmdResult.Text.Add (Trim (Copy (AStrings[LN], Length (ATag) + 5, MaxInt)));}
                FLastCmdResult.Text.Add (Trim (Copy (AStrings[LN], Length (LResponse)+1, MaxInt)));
            end else begin
                FLastCmdResult.Text.Add(Copy(AStrings[LN], 3, MaxInt));
            end;
        end;
    end;
end;

procedure TIdIMAP4.TaggedReplyConvertToConst;
begin
    case PosInStrarray(LastCmdResult.TextCode,VALID_TAGGEDREPLIES) of
      0 : LastCmdResult.NumericCode := wsOK;      {OK}
      1 : LastCmdResult.NumericCode := wsNo;      {NO}
      2 : LastCmdResult.NumericCode := wsBAD;     {BAD}
      3 : LastCmdResult.NumericCode := wsPreAuth; {PREAUTH}
      4 : LastCmdResult.NumericCode := wsBYE;     {BYE}
      5 : LastCmdResult.NumericCode := wsContinue;{+}
    else
      raise EIdException.Create(RSUnrecognizedIMAP4ResponseHeader);
    end;
end;

procedure TIdIMAP4.ReceiveBody(AMsg: TIdMessage; const ADelim: string = '.');  {Do not Localize}
var
    LMsgEnd: Boolean;
    LActiveDecoder: TIdMessageDecoder;
    LLine: string;
    LCheckForOptionalImapFlags: Boolean;
    LDelim: string;

    {CC7: The following define SContentType is from IdMessageClient.  It is defined here also
    (with only local scope) because the one in IdMessageClient is defined locally
    there also, so we cannot get at it.}
const
    SContentType = 'Content-Type'; {do not localize}

    function ProcessTextPart(ADecoder: TIdMessageDecoder): TIdMessageDecoder;
    var
        LDestStream: TStringStream;
    begin
        LDestStream := TStringStream.Create('');  {Do not Localize}
        try
            Result := ADecoder.ReadBody(LDestStream, LMsgEnd);
            with TIdText.Create(AMsg.MessageParts) do begin
                ContentType := ADecoder.Headers.Values['Content-Type'];  {Do not Localize}
                ContentTransfer := ADecoder.Headers.Values['Content-Transfer-Encoding'];  {Do not Localize}
                Body.Text := LDestStream.DataString;
            end;
            ADecoder.Free;
        finally
            FreeAndNil(LDestStream);
        end;
    end;

    function ProcessAttachment(ADecoder: TIdMessageDecoder): TIdMessageDecoder;
    var
        LDestStream: TFileStream;
        LTempPathname: string;
    begin
        LTempPathname := MakeTempFilename;
        LDestStream := TFileStream.Create(LTempPathname, fmCreate);
        try
            Result := ADecoder.ReadBody(LDestStream, LMsgEnd);
            with TIdAttachment.Create(AMsg.MessageParts) do begin
                ContentType := ADecoder.Headers.Values['Content-Type'];  {Do not Localize}
                ContentTransfer := ADecoder.Headers.Values['Content-Transfer-Encoding'];  {Do not Localize}

                // dsiders 2001.12.01
                ContentDisposition := ADecoder.Headers.Values['Content-Disposition'];  {Do not Localize}

                Filename := ADecoder.Filename;
                StoredPathname := LTempPathname;
            end;
            ADecoder.Free;
        finally
            FreeAndNil(LDestStream);
        end;
  end;

{CC9: Recoded wDoublePoint to make it compliant with guidelines}
{const
    wDoublePoint = ord('.') shl 8 + ord('.');  {Do not Localize}

Begin
    {CC3: If IMAP calls this ReceiveBody, it prepends IMAP to delim, e.g. 'IMAP)',
    to flag that this routine should expect IMAP FLAGS entries.}
    LCheckForOptionalImapFlags := False;     {CC3: IMAP hack inserted lines start here...}
    LDelim := ADelim;
    if Copy(ADelim, 1, 4) = 'IMAP' then begin {do not localize}
        LCheckForOptionalImapFlags := True;
        LDelim := Copy(ADelim, 5, MaxInt);
    end;                                     {CC3: ...IMAP hack inserted lines end here}
    LMsgEnd := False;
    if AMsg.NoDecode then begin
        Capture(AMsg.Body, ADelim);
    end else begin
        BeginWork(wmRead);
        try
            LActiveDecoder := nil;
            repeat
                LLine := ReadLn;
                {CC3: Check for optional flags before delimiter in the case of IMAP...}
                {if LLine = ADelim then}
                if LLine = LDelim then begin  {CC3: IMAP hack ADelim -> LDelim}
                    Break;
                end else begin                     {CC3: IMAP hack inserted lines start here...}
                    if LCheckForOptionalImapFlags = True then begin
                        if ( (Copy(LLine, 1, 9) = ' FLAGS (\') {do not localize}
                          and  (Length(LLine) > Length(LDelim))
                          and (LDelim = Copy(LLine, Length(LLine)-Length(LDelim)+1, Length(LDelim))) ) then begin
                            Break;
                        end;
                    end;                   {CC3: ...IMAP hack inserted lines end here}
                end;
                if LActiveDecoder = nil then begin
                    LActiveDecoder := TIdMessageDecoderList.CheckForStart(AMsg, LLine);
                end;
                if LActiveDecoder = nil then begin
                    {CC9: Recoded wDoublePoint to make it compliant with guidelines}
                    {if PWord(PChar(LLine))^= wDoublePoint then begin}
                    {CC9: Per RFC821, the sender is required to add a prefixed '.' to any
                    line in an email that starts with '.' and the receiver is
                    required to strip it off.  This ensures that the end-of-message
                    line '.' cannot appear in the message body.}
                    {CCA: Added "Length (LLine) > 0)" test to stop GPF on empty line}
                    //if LLine[1] = '.' then begin
                    if ((Length (LLine) > 0) and (LLine[1] = '.')) then begin
                        Delete(LLine,1,1);
                    end;
                    AMsg.Body.Add(LLine);
                end else begin
                    while LActiveDecoder <> nil do begin
                        LActiveDecoder.SourceStream := TIdTCPStream.Create(Self);
                        LActiveDecoder.ReadHeader;
                        case LActiveDecoder.PartType of
                          mcptUnknown:
                            begin
                                raise EIdException.Create(RSMsgClientUnkownMessagePartType);
                            end;
                          mcptText:
                            begin
                                LActiveDecoder := ProcessTextPart(LActiveDecoder);
                            end;
                          mcptAttachment:
                            begin
                                LActiveDecoder := ProcessAttachment(LActiveDecoder);
                            end;
                        end;
                    end;
                end;
            until LMsgEnd;
        finally
            EndWork(wmRead);
        end;
    end;
end;


end.


