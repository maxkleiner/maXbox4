{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  10241: IdLPR.pas 
{
{   Rev 1.1    7/23/04 6:12:02 PM  RLebeau
{ Added try...finally block to PrintFile()
}
{
{   Rev 1.0    2002.11.12 10:44:46 PM  czhower
}
unit IdLPR;

(*******************************************************}
{                                                       }
{       Indy Line Print Remote TIdLPR                   }
{                                                       }
{       Version 9.1.0                                   }
{                                                       }
{       Original author Mario Mueller                   }
{                                                       }
{       home: www.hemasoft.de                           }
{       mail: babelfisch@daybyday.de                    }
{                                                       }
{       27.07. rewrite component for integration        }
{              in Indy core library                     }
{                                                       }
{*******************************************************)

interface

uses
  Classes,
  IdAssignedNumbers, IdException, IdGlobal, IdTCPClient, IdComponent, SysUtils;

type
  TIdLPRFileFormat =
    (ffCIF, // CalTech Intermediate Form
     ffDVI, //   DVI (TeX output).
     ffFormattedText, //add formatting as needed to text file
     ffPlot, //   Berkeley Unix plot library
     ffControlCharText, //text file with control charactors
     ffDitroff, // ditroff output
     ffPostScript, //Postscript output file
     ffPR,//'pr' format    {Do not Localize}
     ffFORTRAM, // FORTRAN carriage control
     ffTroff, //Troff output
     ffSunRaster); //  Sun raster format file

const
  DEF_FILEFORMAT = ffControlCharText;
  DEF_INDENTCOUNT = 0;
  DEF_BANNERPAGE = False;
  DEF_OUTPUTWIDTH = 0;
  DEF_MAILWHENPRINTED = False;
type
  TIdLPRControlFile = class(TPersistent)
  protected
    FBannerClass: String;			// 'C'    {Do not Localize}
    FHostName: String;				// 'H'    {Do not Localize}
    FIndentCount: Integer;		// 'I'    {Do not Localize}
    FJobName: String;					// 'J'    {Do not Localize}
    FBannerPage: Boolean;			// 'L'    {Do not Localize}
    FUserName: String;					// 'P'    {Do not Localize}
    FOutputWidth: Integer;		// 'W'    {Do not Localize}

    FFileFormat : TIdLPRFileFormat;
    FTroffRomanFont : String; //substitue the Roman font with the font in file
    FTroffItalicFont : String;//substitue the Italic font with the font in file
    FTroffBoldFont : String;  //substitue the bold font with the font in file
    FTroffSpecialFont : String; //substitue the special font with the font
                                //in this file
    FMailWhenPrinted : Boolean; //mail me when you have printed the job
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property HostName: String read FHostName write FHostName;
  published
    property BannerClass: String read FBannerClass write FBannerClass;
    property IndentCount: Integer read FIndentCount write FIndentCount
      default DEF_INDENTCOUNT;
    property JobName: String read FJobName write FJobName;
    property BannerPage: Boolean read FBannerPage write FBannerPage
      default DEF_BANNERPAGE;
    property UserName: String read FUserName write FUserName;
    property OutputWidth: Integer read FOutputWidth write FOutputWidth
      default DEF_OUTPUTWIDTH;
    property FileFormat: TIdLPRFileFormat read FFileFormat write FFileFormat
      default DEF_FILEFORMAT;
    {font data }
    property TroffRomanFont : String read FTroffRomanFont write FTroffRomanFont;
    property TroffItalicFont : String read FTroffItalicFont
      write FTroffItalicFont;
    property TroffBoldFont : String read FTroffBoldFont write FTroffBoldFont;
    property TroffSpecialFont : String read FTroffSpecialFont
      write FTroffSpecialFont;
    {misc}
    property MailWhenPrinted : Boolean read FMailWhenPrinted
      write FMailWhenPrinted default DEF_MAILWHENPRINTED;

  end;

type
  TIdLPRStatus = (psPrinting, psJobCompleted, psError, psGettingQueueState,
    psGotQueueState, psDeletingJobs, psJobsDeleted, psPrintingWaitingJobs,
    psPrintedWaitingJobs);

type
  TIdLPRStatusEvent = procedure(ASender: TObject;
    const AStatus: TIdLPRStatus;
    const AStatusText: String) of object;

type
  TIdLPR = class(TIdTCPClient)
  protected
    FOnLPRStatus: TIdLPRStatusEvent;
    FQueue: String;
    FJobId: Integer;
    FControlFile: TIdLPRControlFile;
    procedure DoOnLPRStatus(const AStatus: TIdLPRStatus;
    const AStatusText: String);
    procedure SeTIdLPRControlFile(const Value: TIdLPRControlFile);
    procedure CheckReply;
    function GetJobId: String;
    procedure SetJobId(JobId: String);
    procedure InternalPrint(Data: TStream);
    function GetControlData: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Print(AText: String); overload;
    procedure Print(ABuffer: array of Byte); overload;
    procedure PrintFile(AFileName: String);
    function GetQueueState(const AShortFormat: Boolean = false;
      const AList : String = '') : String;    {Do not Localize}
    procedure PrintWaitingJobs;
    procedure RemoveJobList(AList : String; const AAsRoot: Boolean =False);
    property JobId: String read GetJobId write SetJobId;
  published
    property Queue: String read FQueue write FQueue;
    property ControlFile: TIdLPRControlFile read FControlFile write SeTIdLPRControlFile;
    property OnLPRStatus: TIdLPRStatusEvent read FOnLPRStatus write FOnLPRStatus;
  end;

type EIdLPRErrorException = class(EIdException);

implementation
uses IdResourceStrings, IdStack;

{*********************** TIdLPR **********************}
constructor TIdLPR.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);

  Port := IdPORT_LPD;
  Queue := 'pr1';    {Do not Localize}
  FJobId := 1;
  FControlFile := TIdLPRControlFile.Create;

  // Restriction in RFC 1179
  // The source port must be in the range 721 to 731, inclusive.

//  known -problem with this some trouble while multible printjobs are running
//  This is the FD_WAIT port problem where a port is in a FD_WAIT state
//  but you can bind to it.  You get a port reuse error.
  BoundPortMin:=721;
  BoundPortMax:=731;

end;


procedure TIdLPR.Print(AText: String);
var ds: TMemoryStream;
begin
  ds:=TMemoryStream.Create;
  if Length(AText) > 0 then
  begin
    ds.Write(AText[1], Length(AText));
  end;
  InternalPrint(ds);
  FreeAndNil(ds);
end;

procedure TIdLPR.Print(ABuffer: array of Byte);
var ds: TMemoryStream;
begin
  ds:=TMemoryStream.Create;
  ds.Write(ABuffer[0], Length(ABuffer));
  InternalPrint(ds);
  FreeAndNil(ds);
end;

procedure TIdLPR.PrintFile(AFileName: String);
var fs: TFileStream;
  p: Integer;
begin
  p := RPos(GPathDelim, AFileName);
  ControlFile.JobName:=Copy(AFileName, p+1, Length(AFileName)-p);
  fs := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    InternalPrint(fs);
  finally
    FreeAndNil(fs);
  end;
end;


function TIdLPR.GetJobId: String;
begin
  Result:=Format('%.3d', [FJobId]);    {Do not Localize}
end;

procedure TIdLPR.SetJobId(JobId: String);
begin
  if StrToInt(JobId) < 999 then
    FJobId:=StrToInt(JobId);
end;

procedure TIdLPR.InternalPrint(Data: TStream);

begin
  try
    if Connected then
    begin
      Inc(FJobID);
      if FJobID > 999 then
      begin
        FJobID:=1;
      end;
      DoOnLPRStatus(psPrinting, JobID);
      try
       	ControlFile.HostName:=Self.IOHandler.LocalName;
      except
       	ControlFile.HostName:='localhost';    {Do not Localize}
      end;

      // Receive a printer job
      Write(#02 + Queue + LF);
      CheckReply;
      // Receive control file
      Write(#02 + IntToStr(Length(GetControlData)) +
        ' cfA' + JobId + ControlFile.HostName + LF);    {Do not Localize}
      CheckReply;
      // Send control file
      Write(GetControlData);
      Write(#0);
      CheckReply;
      // Send data file
      Write(#03 + IntToStr(Data.Size) +	' dfA'  + JobId +    {Do not Localize}
        ControlFile.HostName + LF);
      CheckReply;
      // Send data
      WriteStream(Data);
      Write(#0);
      CheckReply;
      DoOnLPRStatus(psJobCompleted, JobID);
    end; // if connected
  except
    on E: Exception do
      DoOnLPRStatus(psError, E.Message);
  end;
end;

function TIdLPR.GetQueueState(const AShortFormat: Boolean = false;
      const AList : String = '') : String;    {Do not Localize}
begin
  DoOnLPRStatus(psGettingQueueState, AList);
  if AShortFormat then
    Write(#03 + Queue + ' ' + AList + LF)    {Do not Localize}
  else
    Write(#04 + Queue + ' ' + AList + LF);    {Do not Localize}
//  This was the original code - problematic as this is more than one line
//  read until I close the connection
//  result:=ReadLn(LF);
  Result := AllData;
  DoOnLPRStatus(psGotQueueState, result);
end;

function TIdLPR.GetControlData: String;
var Data: String;
begin
  try
    Data:='';    {Do not Localize}
    with ControlFile do
    begin
      // H - Host name
      Data:=Data + 'H' + HostName + LF;    {Do not Localize}
      // P - User identification
      Data:=Data + 'P' + UserName + LF;    {Do not Localize}
      // J - Job name for banner page
      if Length(JobName) > 0 then
      begin
        Data:=Data + 'J' + JobName + LF;    {Do not Localize}
      end
      else
      begin
        Data:=Data + 'JcfA' + JobId + HostName + LF;    {Do not Localize}
      end;
      //mail when printed
      if FMailWhenPrinted then
      begin
        Data:=Data + 'M' + UserName + LF;    {Do not Localize}
      end;
      case FFileFormat of
         ffCIF : // CalTech Intermediate Form
         begin
           Data:=Data + 'cdfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffDVI : //   DVI (TeX output).
         begin
           Data:=Data + 'ddfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffFormattedText : //add formatting as needed to text file
         begin
           Data:=Data + 'fdfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffPlot : //   Berkeley Unix plot library
         begin
           Data:=Data + 'gdfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffControlCharText : //text file with control charactors
         begin
           Data:=Data + 'ldfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffDitroff : // ditroff output
         begin
           Data:=Data + 'ndfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffPostScript : //Postscript output file
         begin
           Data:=Data + 'odfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffPR : //'pr' format    {Do not Localize}
         begin
           Data:=Data + 'pdfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffFORTRAM : // FORTRAN carriage control
         begin
           Data:=Data + 'rdfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffTroff : //Troff output
         begin
           Data:=Data + 'ldfA' + JobId + HostName + LF;    {Do not Localize}
         end;
         ffSunRaster : //  Sun raster format file
         begin
         end;
      end;
      // U - Unlink data file
      Data:=Data + 'UdfA' + JobId + HostName + LF;    {Do not Localize}

      // N - Name of source file
      Data:=Data + 'NcfA' + JobId + HostName + LF;    {Do not Localize}

      if (FFileFormat = ffFormattedText) then
      begin
        if (IndentCount > 0) then
        begin
          Data:=Data + 'I' + IntToStr(IndentCount) + LF;    {Do not Localize}
        end;
        if (OutputWidth > 0) then
        begin
          Data:=Data + 'W' + IntToStr(OutputWidth) + LF;    {Do not Localize}
        end;
      end;
      if Length(BannerClass) > 0 then
      begin
        Data:=Data + 'C' + BannerClass + LF;    {Do not Localize}
      end;
      if BannerPage then
      begin
        Data:=Data + 'L' + UserName + LF;    {Do not Localize}
      end;
      if Length(TroffRomanFont)>0 then
      begin
        Data:=Data + '1' + TroffRomanFont+LF;    {Do not Localize}
      end;
      if Length(TroffItalicFont)>0 then
      begin
        Data:=Data + '2' + TroffItalicFont+LF;    {Do not Localize}
      end;
      if Length(TroffBoldFont)>0 then
      begin
        Data:=Data + '3' + TroffBoldFont+LF;    {Do not Localize}
      end;
      if Length(TroffSpecialFont)>0 then
      begin
        Data:=Data + '4' + TroffSpecialFont+LF;    {Do not Localize}
      end;
    end;

    Result:=data;

  except
    Result:='error';    {Do not Localize}
  end;
end;

procedure TIdLPR.SeTIdLPRControlFile(const Value: TIdLPRControlFile);
begin
  FControlFile.Assign(Value);
end;

destructor TIdLPR.Destroy;
begin
  FreeAndNil(FControlFile);
  inherited;
end;

procedure TIdLPR.PrintWaitingJobs;
begin
  try
    DoOnLPRStatus(psPrintingWaitingJobs, '');    {Do not Localize}
    Write(#03 + Queue + LF);
    CheckReply;
    DoOnLPRStatus(psPrintedWaitingJobs, '');    {Do not Localize}
  except
    on E: Exception do
      DoOnLPRStatus(psError, E.Message);
  end;
end;

procedure TIdLPR.RemoveJobList(AList: String; const AAsRoot: Boolean =False);
begin
  try
    DoOnLPRStatus(psDeletingJobs, JobID);
    if AAsRoot then
    begin
      {Only root can delete other people's print jobs}    {Do not Localize}
      Write(#05 + Queue + ' root ' + AList + LF);    {Do not Localize}
    end
    else
    begin
      Write(#05 + Queue + ' ' + ControlFile.UserName + ' ' + AList + LF);    {Do not Localize}
    end;
    CheckReply;
    DoOnLPRStatus(psJobsDeleted, JobID);
  except
    on E: Exception do
      DoOnLPRStatus(psError, E.Message);
  end;
end;

procedure TIdLPR.CheckReply;
var ret : String;
begin
  ret:=ReadString(1);
  if (Length(ret) > 0) and (ret[1] <> #00) then
  begin
    raise EIdLPRErrorException.Create(Format(RSLPRError,[ret[1],JobID]));
  end;
end;

procedure TIdLPR.DoOnLPRStatus(const AStatus: TIdLPRStatus;
  const AStatusText: String);
begin
  if Assigned(FOnLPRStatus) then
    FOnLPRStatus(Self,AStatus,AStatusText);
end;

{ TIdLPRControlFile }
procedure TIdLPRControlFile.Assign(Source: TPersistent);
var cnt : TIdLPRControlFile;
begin
  if Source is TIdLPRControlFile then
  begin
    cnt := Source as TIdLPRControlFile;
    FBannerClass := cnt.BannerClass;
    FIndentCount := cnt.IndentCount;
    FJobName := cnt.JobName;
    FBannerPage := cnt.BannerPage;
    FUserName := cnt.UserName;
    FOutputWidth := cnt.OutputWidth;
    FFileFormat := cnt.FileFormat;
    FTroffRomanFont := cnt.TroffRomanFont;
    FTroffItalicFont := cnt.TroffItalicFont;
    FTroffBoldFont := cnt.TroffBoldFont;
    FTroffSpecialFont := cnt.TroffSpecialFont;
    FMailWhenPrinted := cnt.MailWhenPrinted;
  end
  else
  begin
    inherited Assign(Source);
  end;
end;

constructor TIdLPRControlFile.Create;
begin
  inherited Create;
  try
    HostName := GStack.LocalAddress;
  except
    HostName:=RSLPRUnknown;   
  end;
  FFileFormat := DEF_FILEFORMAT;
  FIndentCount := DEF_INDENTCOUNT;
  FBannerPage := DEF_BANNERPAGE;
  FOutputWidth := DEF_OUTPUTWIDTH;
end;

end.
