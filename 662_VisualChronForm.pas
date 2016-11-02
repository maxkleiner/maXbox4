{
  Visual Chron.

  Copyright (C) 1997, Earl F. Glynn, EFG Software.  All Rights Reserved
  
  #sign:Max: MAXBOX10: 18/05/2016 10:31:19 
}

unit VisualChronForm_mXTester;

interface

{uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons, Grids, ComCtrls, ExtCtrls,
  ChronCheck;    {TChron}
 
 
//TYPE
  //TFormVisualChron = class(TForm)
  
  TYPE
    //TCheck            = (chMinutes, chHours, chDays, chMonths, chWeekdays);
    TCheckIndex       = TCheck; //chMinutes..chWeekdays;
    //TCheckArrayIndex  = MinCheckArrayIndex..MaxCheckArrayIndex;
    //TCheckArraySpec   = ARRAY[0..4] OF STRING;
    
   // const 
   //ChurchDayCount = 21;
 
 var
    TimerChron              :  TTimer;
    PanelStatusMessage      :  TPanel;
    PageControlTabs         :  TPageControl;
    TabSheetAutoPage        :  TTabSheet;
    SpeedButtonAutoPagePlus :  TSpeedButton;
    SpeedButtonAutoPageMinus:  TSpeedButton;
    LabelCheckEvery         :  TLabel;
    LabelCheckSeconds       :  TLabel;
    SpeedButtonChronHelp    :  TSpeedButton;
    StringGridChronList     :  TStringGrid;
    CheckBoxTimerEnabled    :  TCheckBox;
    SpinEditCheckEvery      :  TSpinEdit;
    ButtonCheck             :  TButton;
    TabSheetSetup           :  TTabSheet;
    GroupBoxFiles           :  TGroupBox;
    LabelLogFile            :  TLabel;
    EditLogFile             :  TEdit;
    CheckBoxDebug           :  TCheckBox;
    Results                 :  TTabSheet;
    GroupBoxResults         :  TGroupBox;
    MemoResults             :  TMemo;
    GroupBox1: TGroupBox;
    LabelDOSPrefix: TLabel;
    EditDOSPrefix: TEdit;
    LabelNTPrefix: TLabel;
    EditNTPrefix: TEdit;
    EditToolPrefix: TEdit;
    EditUtilPrefix: TEdit;
    LabelToolPrefix: TLabel;
    LabelUtilPrefix: TLabel;
    LabelDOSComment: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;

       procedure FormCreate(Sender: TObject);
       procedure FormClose(Sender: TObject; var Action: TCloseAction);
   
       procedure StringGridDrawCell(Sender: TObject; Col,
         Row: Longint; Rect: TRect; State: TGridDrawState);
       procedure StringGridSelectCell(Sender: TObject; Col,
         Row: Longint; var CanSelect: Boolean);
       procedure SetGridModified(Sender: TObject; ACol, ARow: Longint;
         const Value: string);
   
       procedure AddBlankLineToStringGrid(Sender: TObject);
       procedure DeleteSelectedLine(Sender: TObject);
   
       procedure TimerChronTimer(Sender: TObject);
       procedure CheckBoxTimerEnabledClick(Sender: TObject);
       procedure SpinEditCheckEveryChange(Sender: TObject);
       procedure ButtonCheckClick(Sender: TObject);
       procedure SpeedButtonChronHelpClick(Sender: TObject);

  //private
    var 
    GridModified  :  BOOLEAN;
    ClockStartTime:  TDateTime;

       PROCEDURE CheckProgramList (CONST CheckTime:  TDateTime;
                                   CONST SingleRow:  BOOLEAN);
       PROCEDURE CheckTimeTrigger (CONST CheckTime:  TDateTime;
                                   CONST SingleRow:  BOOLEAN;
                                   CONST RowIndex :  INTEGER;
                                   CONST Chron    :  TChron);
       PROCEDURE MinusButtonCheck;
       PROCEDURE WriteToLog(CONST s:  STRING; CONST WriteToFile:  BOOLEAN);

  //public
    { Public declarations }
  //end;

var
  FormVisualChron: TForm; //VisualChron;

implementation
//{$R *.DFM}

  (*USES
    FileCtrl,           {DirectoryExists}
    Tokens,             {TTokens}
    REXX,               {Plural}
    StringGridLibrary,  {XCenter, YCenter, ReadGridFile, WriteGridFile}
    IniFiles,           {TIniFile}
    WinTools,           {WinExecAndWait}
    ChronHelpForm;
    *)
    
  CONST
    TimeFormat    = 'mm/dd/yyyy hh:nn:ss';
    ChronListFile = 'VisualChron.DAT';

    ErrorStatus   = 'Error';
    OKStatus      = 'OK';
    IgnoreStatus  = 'Ignore';

    ChronListIDIndex          =  1;
    ChronListFirstParmIndex   =  2;
    ChronListStatusIndex      =  7;
    ChronListProgramNameIndex =  8;

{---------------------------------------------------------------------------}

PROCEDURE CheckProgramList (CONST CheckTime:  TDateTime;
                                             CONST SingleRow:  BOOLEAN);
  VAR
    Check      :  byte; //TCheck;//TCheckIndex;
    Chron      :  TChron;
    RowIndex   :  INTEGER;
    RowFirst   :  INTEGER;
    RowLast    :  INTEGER;
    SpecArray  :  TCheckArraySpec;
BEGIN
  {Create Chron only once per invocation
   (instead of once for each minute that is considered)}
  Chron := TChron.Create;

  IF  SingleRow
  THEN BEGIN
    RowFirst := StringGridChronList.Row;
    RowLast  := StringGridChronList.Row;
  END
  ELSE BEGIN
    RowFirst := 1;   {Skip over headings in row 0}
    RowLast  := StringGridChronList.RowCount-1;
  END;

  FOR RowIndex := RowFirst TO RowLast DO
  BEGIN
    WITH   StringGridChronList DO
    BEGIN
      IF  (UpperCase(Cells[ChronListStatusIndex, RowIndex]) <> UpperCase(ErrorStatus))
      THEN BEGIN

        {Program cannot be blank, but no other check is made}
        IF   Trim(StringGridChronList.Cells[ChronListProgramNameIndex, RowIndex]) = ''
        THEN Cells[ChronListStatusIndex, RowIndex] :=  ErrorStatus;

      //  FOR Check := Low(TCheck) TO High(TCheck) DO
        FOR Check := 0 TO 4 DO
    
        BEGIN
          SpecArray[Check] := Cells[ChronListFirstParmIndex  + ORD(Check), RowIndex];
        END;

        IF   Chron.SetSpecs(SpecArray)  then
        BEGIN
          {Write to log (and then only screen) only for SingleRow option}
          IF   SingleRow
          THEN WriteToLog (FormatDateTime(TimeFormat, Now) +
                          ' Successful Check:  ' +
                          Cells[ChronListIDIndex, RowIndex],
                          FALSE);

        END
        ELSE BEGIN
          //FOR Check := Low(TCheckIndex) TO High(TCheckIndex) DO
          //Begin
          FOR Check := 0 TO 4 DO
          
          BEGIN
            Cells[ChronListFirstParmIndex + ORD(Check), RowIndex]:= SpecArray[Check];
          END;

          Cells[ChronListStatusIndex, RowIndex] :=  ErrorStatus;

          {Note every error}
          WriteToLog (FormatDateTime(TimeFormat, Now) + ' ' +
                      Cells[ChronListIDIndex, RowIndex] +
             ' Check Failed.  Correct Field(s) enclosed in angle brackets, <>.',
                      TRUE);
    PanelStatusMessage.Caption:= '  Correct Field(s) enclosed in angle brackets, <>.'
        END;

        IF   (UpperCase(Cells[ChronListStatusIndex, RowIndex]) <> UpperCase(ErrorStatus)) AND
             (UpperCase(Cells[ChronListStatusIndex, RowIndex]) <> UpperCase(IgnoreStatus))
        THEN CheckTimeTrigger (CheckTime, SingleRow, RowIndex, Chron)

      END

    END

  END;

  Chron.Free

END {CheckProgramList};


  CONST
    MinutesPerDay = 1440;

    FUNCTION TruncatedMinute (VAR DateTime:  TDateTime):  TDateTime;
    VAR
      Day         :  WORD;
      Hours       :  WORD;
      Milliseconds:  WORD;
      Minutes     :  WORD;
      Month       :  WORD;
      Year        :  WORD;   {will be ingored}
      Seconds     :  WORD;   {will be ignored}
      MilliSec    :  WORD;   {will be ignored}

  BEGIN
    DecodeDate(DateTime, Year, Month, Day);
    DecodeTime(DateTime, Hours, Minutes, Seconds, MilliSeconds);

    RESULT := EncodeDate(Year, Month, Day) +
              EncodeTime(Hours, Minutes, 0, 0);
  END {TruncatedMinute};


PROCEDURE CheckTimeTrigger (CONST CheckTime:  TDateTime;
                                             CONST SingleRow:  BOOLEAN;
                                             CONST RowIndex:  INTEGER;
                                             CONST Chron:  TChron);


  VAR
    Buffer        :  ARRAY[0..200] OF CHAR;
    Command       :  STRING;
    InputRecord   :  STRING;
    PageFileSpec  :  STRING;
    MessageStrings:  STRING;
    Minute        :  WORD;
    MinuteCount   :  WORD;
    OKExec        :  BOOLEAN;
    PagerIDs      :  STRING;
    position      :  INTEGER;
    SearchRec     :  TSearchRec;
    SearchResult  :  INTEGER;
    StartTime     :  TDateTime;
    StopTime      :  TDateTime;
    TriggerFired  :  BOOLEAN;

  (*FUNCTION TruncatedMinute (VAR DateTime:  TDateTime):  TDateTime;
    VAR
      Day         :  WORD;
      Hours       :  WORD;
      Milliseconds:  WORD;
      Minutes     :  WORD;
      Month       :  WORD;
      Year        :  WORD;   {will be ingored}
      Seconds     :  WORD;   {will be ignored}
      MilliSec    :  WORD;   {will be ignored}

  BEGIN
    DecodeDate(DateTime, Year, Month, Day);
    DecodeTime(DateTime, Hours, Minutes, Seconds, MilliSeconds);

    RESULT := EncodeDate(Year, Month, Day) +
              EncodeTime(Hours, Minutes, 0, 0);
  END {TruncatedMinute};
    *)

BEGIN
  StartTime := TruncatedMinute(ClockStartTime);
  StopTime  := TruncatedMinute(ClockStartTime);

  MinuteCount := ROUND( (StopTime - StartTime) * MinutesPerDay );

  TriggerFired := FALSE;
  Minute := 0;

  {Look at each minute since last time checked.
   Pages are triggered a maximum of one time}
  WHILE (Minute <= MinuteCount) AND (NOT TriggerFired) DO
  BEGIN
    IF  Chron.IsMatch(CheckTime + Minute / MinutesPerDay)
    THEN BEGIN
      TriggerFired := TRUE;

      Command:= Trim(StringGridChronList.Cells[ChronListProgramNameIndex, RowIndex]) 
                                 + ' ';

      IF   Uppercase(COPY(Command,1,4)) = 'DOS '
      THEN BEGIN
        Delete(Command, 1, 3);  {Keep the space}
        Command := EditDOSPrefix.Text + Command
      END
      ELSE
        IF   Uppercase(COPY(Command,1,3)) = 'NT '
        THEN BEGIN
          Delete(Command, 1, 2);  {Keep the space}
          Command := EditNTPrefix.Text + Command
        END
        ELSE
          IF   Uppercase(COPY(Command,1,5)) = 'TOOL '
          THEN BEGIN
            Delete(Command, 1, 5);  {Drop the space}
            Command := EditToolPrefix.Text + Command
          END
          ELSE
            IF   Uppercase(COPY(Command,1,5)) = 'UTIL '
            THEN BEGIN
              Delete(Command, 1, 5);  {Drop  the space}
              Command := EditUtilPrefix.Text + Command
            END;

      //StrPCopy(buffer, Command);
      
      //OKExec :=  WinExecAndWait(buffer, SW_HIDE);
      RunExecutable(exepath+'maxbox4.exe',true)
      writeln('wait after')
      WriteToLog (FormatDateTime(TimeFormat, Now) +
                  ' OK ' + StringGridChronList.Cells[ChronListIDIndex, RowIndex],
                  NOT OKExec)   {only write failures to log}
    END;

    INC (Minute)
  END

END {CheckTimeTrigger};


procedure {TFormVisualChron.}FormCreate(Sender: TObject);
  VAR
    Filename    :  STRING;
    IniFile     :  TIniFile;
    WindowStatus:  INTEGER;
    TimerOn     :  BOOLEAN;
begin
  {Read .INI file with defaults}
  Filename := ChangeFileExt(ParamStr(0), '.INI');
  IniFile := TIniFile.Create(Filename);

  WindowStatus := IniFile.ReadInteger('Form', 'WindowStatus', 0);
   CASE WindowStatus OF
    1:  FormVisualChron.WindowState := wsNormal;  {default}
    2:  FormVisualChron.WindowState := wsMinimized;
    3:  FormVisualChron.WindowState := wsMaximized
  END;

  FormVisualChron.Top := IniFile.ReadInteger('Form', 'Top',    FormVisualChron.Top);
  FormVisualChron.Left:= IniFile.ReadInteger('Form', 'Left',   FormVisualChron.Left);

  CheckBoxTimerEnabled.Checked := IniFile.ReadBool('Parm', 'TimerEnabled', TRUE);
  CheckBoxDebug.Checked        := IniFile.ReadBool('Parm', 'Debug', FALSE);

  EditDOSPrefix.Text := IniFile.ReadString('Parm', 'DOSprefix',
                        'C:\command.com /c');
  EditNTPrefix.Text  := IniFile.ReadString('Parm', 'NTprefix',
                        'C:\winnt35\system32\cmd.exe /c');
  EditToolPrefix.Text  := IniFile.ReadString('Parm', 'Toolprefix',
                          'C:\Tools\');
  EditUtilPrefix.Text  := IniFile.ReadString('Parm', 'Utilprefix',
                          'C:\Util\');

  EditLogFile.Text     := IniFile.ReadString('Parm', 'LogFile',
                          '.Log');

  IniFile.Free;

  {----------------------------------------------------------------------------}
  {Set Certain Values}

  WITH StringGridChronList DO
  BEGIN
    ColWidths[ChronListIDIndex]          :=  55;
    ColWidths[ChronListFirstParmIndex]   :=  40;
    ColWidths[ChronListFirstParmIndex+1] :=  40;
    ColWidths[ChronListFirstParmIndex+2] :=  40;
    ColWidths[ChronListFirstParmIndex+3] :=  40;
    ColWidths[ChronListFirstParmIndex+4] :=  55;
    ColWidths[ChronListStatusIndex]      :=  40;
    ColWidths[ChronListProgramNameIndex] := 200;

    Cells[ChronListIDIndex,         0] := 'ID';
    Cells[ChronListFirstParmIndex,  0] := 'Minute';
    Cells[ChronListFirstParmIndex+1,0] := 'Hour';
    Cells[ChronListFirstParmIndex+2,0] := 'Day';
    Cells[ChronListFirstParmIndex+3,0] := 'Month';
    Cells[ChronListFirstParmIndex+4,0] := 'Weekday';
    Cells[ChronListStatusIndex,     0] := 'Status';
    Cells[ChronListProgramNameIndex,0] := 'Program Name';
  END;

  {----------------------------------------------------------------------------}

  StringGridChronList.RowCount := 2;
  StringGridChronList.Row := 1;
  GridModified := FALSE;

  IF   FileExists(ChronListFile)
  THEN ReadGridFile (StringGridChronList, ChronListFile);

  MinusButtonCheck;

  SpinEditCheckEvery.Value := TimerChron.Interval DIV (60 * 1000);
  ClockStartTime := Now;
end;


procedure FormClose(Sender: TObject;
                                     var Action: TCloseAction);
  var
    Filename    :  STRING;
    IniFile     :  TIniFile;
    WindowStatus:  INTEGER;
    Success     :  BOOLEAN;
begin
  {Re-write .INI file with current information}
  Filename := ChangeFileExt(ParamStr(0), '.INI');
  IniFile := TIniFile.Create(Filename);
  CASE FormVisualChron.WindowState OF
    wsNormal:
      BEGIN
        IniFile.WriteInteger ('Form', 'Top',    FormVisualChron.Top);
        IniFile.WriteInteger ('Form', 'Left',   FormVisualChron.Left);
        WindowStatus := 1
      END;
    wsMinimized:  WindowStatus := 2;
    wsMaximized:  WindowStatus := 3
  END;

  IF   NOT FormVisualChron.Active
  THEN WindowStatus := 2;

  IniFile.WriteInteger ('Form', 'WindowStatus', WindowStatus);
  IniFile.WriteBool('Parm', 'TimerEnabled', CheckBoxTimerEnabled.Checked);
  IniFile.WriteBool('Parm', 'Debug', CheckboxDebug.Checked);

  IniFile.WriteString('Parm', 'DOSprefix', EditDOSPrefix.Text);
  IniFile.WriteString('Parm', 'NTprefix', EditNTPrefix.Text);
  IniFile.WriteString('Parm', 'Toolprefix', EditToolPrefix.Text);
  IniFile.WriteString('Parm', 'Utilprefix', EditUtilPrefix.Text);

  IniFile.WriteString('Parm', 'LogFile', EditLogFile.Text);

  IniFile.Free{Destroy};

  IF   GridModified
  THEN WriteGridFile (StringGridChronList, ChronListFile);
end;


procedure {TFormVisualChron.}StringGridDrawCell(Sender: TObject; Col,
  Row: longint; Rect: TRect; State: TGridDrawState);

  VAR
    s:  STRING;
    col1, row1, twidth: longint;
    seltop: Trect;
begin
  s := (Sender AS TStringGrid).Cells[col,row];

  (Sender AS TStringGrid).Canvas.Font.Color := clBlack;

  col1:= (Sender AS TStringGrid).FixedCols;
  IF   col < col1 {(Sender AS TStringGrid).FixedCols }
  THEN (Sender AS TStringGrid).Canvas.Brush.Color := clBtnFace
  ELSE BEGIN
    row1:= (Sender AS TStringGrid).FixedRows;
    IF   row < row1 {(Sender AS TStringGrid).FixedRows}
    THEN (Sender AS TStringGrid).Canvas.Brush.Color := clBtnFace
    ELSE BEGIN
    seltop:= (Sender AS TStringGrid).Selection;
      //row1:= (Sender AS TStringGrid).Selection.left
      IF   row = seltop.Top
      THEN (Sender AS TStringGrid).Canvas.Brush.Color := clYellow
      ELSE (Sender AS TStringGrid).Canvas.Brush.Color := clWhite
    END
  END;

  (Sender AS TStringGrid).Canvas.FillRect(Rect);

  IF   row = 0
  THEN (Sender AS TStringGrid).Canvas.TextRect(Rect,
                   XCenter(Rect, (Sender AS TStringGrid).Canvas, s),
                   YCenter(Rect, (Sender AS TStringGrid).Canvas, s), s)
  ELSE 
    begin
    twidth:=  (Sender AS TStringGrid).Canvas.TextWidth('X');
    (Sender AS TStringGrid).Canvas.TextRect(Rect,
                   Rect.Left + twidth div 2,
                   YCenter(Rect, (Sender AS TStringGrid).Canvas, s), s)
   end     
end;


procedure StringGridSelectCell(Sender: TObject;
  Col, Row: Longint; var CanSelect: Boolean);
  var seltop: TRect;
begin
  seltop:= (Sender AS TStringGrid).Selection;
  IF   (Row <> seltop.top)
  THEN BEGIN
    (Sender AS TDrawGrid).Invalidate;
    GridModified := TRUE;
  END;
end;


procedure AddBlankLineToStringGrid(Sender: TObject);
begin
  AddBlankRowToTop (StringGridChronList);
  CheckBoxTimerEnabled.Checked := FALSE;
  MinusButtonCheck;
  GridModified := TRUE;
end;

procedure DeleteSelectedLine(Sender: TObject);
  VAR
    j        :  INTEGER;
    position :  INTEGER;
    Nicknames:  STRING;
    target   :  STRING;
begin
  DeleteSelectedRow (StringGridChronList);
  MinusButtonCheck;
  GridModified := TRUE;
end;

procedure SetGridModified(Sender: TObject; ACol,
  ARow: Longint; const Value: string);
begin
  GridModified := TRUE;
end;


PROCEDURE MinusButtonCheck;
BEGIN
  SpeedButtonAutoPageMinus.Enabled := (StringGridChronList.RowCount > 2)
END {MinusButtonCheck};


PROCEDURE {TFormVisualChron.}WriteToLog(CONST s:  STRING;
                                      CONST WriteToFile:  BOOLEAN);
  VAR
    LogFile:  TextFile;
    Filename:  STRING;
BEGIN
  {Always write message to bottom panel}
  PanelStatusMessage.Caption := ' ' + s;

  {Only keep last 500 lines in Memo; Delete 100 when needed}
  IF   MemoResults.Lines.Count > 600
  THEN BEGIN
    MemoResults.Lines.BeginUpdate;

      WHILE MemoResults.Lines.Count > 500 DO
        MemoResults.Lines.Delete(0);
    MemoResults.Lines.EndUpdate;
  END;

  {Always write message to Memo Log}
  MemoResults.Lines.Add(s);

  IF   WriteToFile OR  CheckBoxDebug.Checked
  THEN BEGIN
    Filename := FormatDateTime('mmmyy', Now) + EditLogFile.Text;
    AssignFile (LogFile, Filename);

    TRY
      IF   FileExists(Filename)
      THEN Append (LogFile)
      ELSE Rewrite (LogFile);

      //WRITELN(LogFile, s);

      CloseFile (LogFile)
    EXCEPT
      //On EinOutError DO
        MessageDlg ('Error writing Log file "' + EditLogFile.Text +'"',
                   mtError, [mbOK], 0);
    END

  END

END {WriteToLog};


procedure {TFormVisualChron.}TimerChronTimer(Sender: TObject);
  VAR
    CurrentTime :  TDateTime;
    MessageText :  STRING;

    hour        :  WORD;
    minute      :  WORD;
    milliseconds:  WORD;
    second      :  WORD;
    present     :  TDateTime;
begin
  MessageText := FormatDateTime(TimeFormat, Now) + ' Auto Page Check';
  PanelStatusMessage.Caption := '  ' + MessageText;
  IF   CheckBoxDebug.Checked
  THEN WriteToLog (MessageText, TRUE);
  CurrentTime := Now;

  CheckProgramList (CurrentTime, FALSE); {FALSE -> use all rows in StringGrid}
  ClockStartTime := CurrentTime;       {Save for next call}

  present := Now;
  DecodeTime(present, hour, minute, second, milliseconds);

  {Adjust interval if not in range 2..4}
  CASE second OF
    0..1 :  TimerChron.interval := 60250;
    2..4 :  TimerChron.interval := 60000;
    5..59:  TimerChron.interval := 59750;
  END

end;


procedure {TFormVisualChron.}CheckBoxTimerEnabledClick(Sender: TObject);
begin
  TimerChron.Enabled := NOT TimerChron.Enabled;
  IF   TimerChron.Enabled
  THEN BEGIN
    ClockStartTime := Now;
    WriteToLog (FormatDateTime(TimeFormat, Now) +
                ' Clock Started.', TRUE)
  END
  ELSE WriteToLog (FormatDateTime(TimeFormat, Now) +
                ' Clock Stopped.', TRUE)
end;


procedure SpinEditCheckEveryChange(Sender: TObject);
begin
  CheckBoxTimerEnabled.Checked := FALSE;
  TimerChron.Interval := 1000 {ms/sec} * 60 {sec/min} *
                                            SpinEditCheckEvery.Value {min};
  LabelCheckSeconds.Caption := Plural(SpinEditCheckEvery.Value, 'minute', '');
end;


procedure {TFormVisualChron.}ButtonCheckClick(Sender: TObject);
begin
  CheckBoxTimerEnabled.Checked := FALSE;

  {By resetting ClockStartTime and passing this value to CheckProgramList,
   only a single minute will be checked for the currently selected row.}
  ClockStartTime := Now;
  CheckProgramList (ClockStartTime, TRUE)
end;

procedure {TFormVisualChron.}SpeedButtonChronHelpClick(Sender: TObject);
begin
 //FormHelpChron.ShowModal;
 //MsgBoxK
    //AppMsgBox
     //CreateMsgBox( const Caption, Text : string; const Buttons : array of TKMsgBoxButton; Icon : TKMsgBoxIcon; Def : integer) : TCustomForm');
  //CreateMsgBoxEx( const Caption, Text : string; const Btns : array of string; Icon : TKMsgBoxIcon; Def : integer) : TCustomForm');
  //FreeMsgBox( AMsgBox : TCustomForm)');
  //KMsgBox( const Caption, Text : string; const Buttons : array of TKMsgBoxButton; Icon : TKMsgBoxIcon; Def : integer) : integer');
  //KMsgBoxEx( const Caption, Text : string; const Buttons : array of string; Icon : TKMsgBoxIcon; Def : integer) : integer');
  //KInputBox( const Caption, Prompt : string; var Text : string) : TModalResult');
  //KNumberInputBox( const ACaption, APrompt : string; var AValue : double; AMin, AMax : double; AFormats : TKNumberEditAcceptedFormats) : TModalResult');
  //TKMsgBoxButtons', '( mbAbortRetryIgnore, mbOkOnly, mbOkCancel, m'
   //+'bRetryCancel, mbYesNo, mbYesNoCancel )');
  //MsgBoxK( const Caption, Text : string; const Buttons : TKMsgBoxButtons; Icon : TKMsgBoxIcon) : integer');
  //AppMsgBox( const Caption, Text : string; Flags : integer) : integer');
end;

begin 

  with TKBrowseFolderDialog.create(self) do begin
    writeln('TKBrowseFolderDialog: '+botoStr(execute))
    free
  end;  

End.

//http://www.tmssoftware.com/site/tmslclhwpack.asp
//https://github.com/LaKraven/GPIO
//https://github.com/askarel/hsb-scripts/blob/master/io/pigpio.pas
