{
  KMemo Demo.  #locs:696

  
  #sign:Max: MAXBOX10: 18/05/2016 14:34:51 
  #tech:perf: 0:0:2.372 threads: 10 192.168.56.1 14:34:51 4.2.2.95
  #head>Max: MAXBOX10: 18/05/2016 14:34:51 C:\Program Files (x86)\maxbox3\Import\IPC\maxbox4\maxbox4\examples\696_kmemo_demo.pas 
}

program VisualChronForm_mXTester;

//interface

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

       procedure FormCreate(Sender: TObject); forward;
       procedure FormClose(Sender: TObject; var Action: TCloseAction); forward;
   
       procedure StringGridDrawCell(Sender: TObject; Col,
         Row: Longint; Rect: TRect; State: TGridDrawState); forward;
       procedure StringGridSelectCell(Sender: TObject; Col,
         Row: Longint; var CanSelect: Boolean); Forward;
       procedure SetGridModified(Sender: TObject; ACol, ARow: Longint;
         const Value: string); Forward;
   
       procedure AddBlankLineToStringGrid(Sender: TObject); Forward;
       procedure DeleteSelectedLine(Sender: TObject); Forward;
   
       procedure TimerChronTimer(Sender: TObject); Forward;
       procedure CheckBoxTimerEnabledClick(Sender: TObject); Forward;
       procedure SpinEditCheckEveryChange(Sender: TObject); Forward;
       procedure ButtonCheckClick(Sender: TObject); Forward;
       //procedure SpeedButtonChronHelpClick(Sender: TObject); Forward;

  //private
    var 
    GridModified  :  BOOLEAN;
    ClockStartTime:  TDateTime;

       PROCEDURE CheckProgramList (CONST CheckTime:  TDateTime;
                                   CONST SingleRow:  BOOLEAN); Forward;
       PROCEDURE CheckTimeTrigger (CONST CheckTime:  TDateTime;
                                   CONST SingleRow:  BOOLEAN;
                                   CONST RowIndex :  INTEGER;
                                   CONST Chron    :  TChron); Forward;
       PROCEDURE MinusButtonCheck; forward;
       PROCEDURE WriteToLog(CONST s:  STRING; CONST WriteToFile:  BOOLEAN); Forward;

  //public
    { Public declarations }
  //end;

var
  FormVisualChron: TForm; //VisualChron;

//implementation
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
        FOR Check := 0 TO 4 DO BEGIN
          SpecArray[Check] := Cells[ChronListFirstParmIndex  + ORD(Check), RowIndex];
        END;

        IF   Chron.SetSpecs(SpecArray)  then BEGIN
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
            Cells[ChronListFirstParmIndex + ORD(Check), RowIndex]:= 
                                          SpecArray[Check];
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

  WITH StringGridChronList DO BEGIN
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


type   TColors = (tRED,tBLUE,tGREEN);
    var afrm: Tform;
      colenum: TColors;
      //pp: pointer;
      KPrintSetupDialog1: TKPrintSetupDialog;
      kmemo: TKMemo;


begin 

  
  afrm:= getForm(650,700) 
  afrm.borderstyle:= bssizeable; //bsdialog;
   kmemo:= TKMemo.create(afrm); // do begin
     with kmemo do begin
     parent:= afrm;
     align:= alClient;
     height:= height-50;
     LoadFromRTF(Exepath+'\examples\kmemo_manual.rtf');
     Blocks.AddTextBlock('  Hello bitbox world!',3);
     Blocks.AddImageBlock(Exepath+'\examples\sylvestermax2016.jpg',5);  
     //Blocks.AddImageBlock(Exepath+'\examples\minestudycapture.png',6);
     //ExecuteCommand(ecSelectAllk,0);  
     SaveToRTF(Exepath+'\examples\kmemo_maxmanual_copy.rtf',false);
     KPrintSetupDialog1:= TKPrintSetupDialog.create(self);
     KPrintSetupDialog1.Control := kmemo; //TKMemo(self);
     KPrintSetupDialog1.Execute;
     KPrintSetupDialog1.Free;
     //Free;
     afrm.Release;
       
      //Blocks.AddTextBlock('Hello world!');
      //Blocks.AddImageBlock('penguins.jpg',4);
     //loadfromfile
     //free;
   end;  
   
   colenum:= tblue;
   sr:= IntToStr(Ord(colenum));
   
   Sr := 'BLUE has an ordinal value of ' + IntToStr(Ord(colenum)) + #13#10; 
   writeln(sr)  
   Sr := 'The ASCII code for "c" is ' + IntToStr(Ord('c')) +  ' decimal';
     // MessageDlg(Sr, mtInformation, [mbOk], 0); 


End.

//http://www.tmssoftware.com/site/tmslclhwpack.asp
//https://github.com/LaKraven/GPIO
//https://github.com/askarel/hsb-scripts/blob/master/io/pigpio.pas


{ @abstract(Multi line text editor base component). }
  TKCustomMemo = class(TKCustomControl, IKMemoNotifier)
  private
    FBackgroundImage: TPicture;
    FBlocks: TKMemoBlocks;
    FColors: TKMemoColors;
    FContentPadding: TKRect;
    FDisabledDrawStyle: TKEditDisabledDrawStyle;
    FKeyMapping: TKEditKeyMapping;
    FLeftPos: Integer;
    FListTable: TKMemoListTable;
    FMouseWheelAccumulator: Integer;
    FOptions: TKEditOptions;
    FParaStyle: TKMemoParaStyle;
    FRedoList: TKMemoChangeList;
    FRequiredContentWidth: Integer;
    FScrollBars: TScrollStyle;
    FScrollPadding: Integer;
    FScrollSpeed: Cardinal;
    FScrollTimer: TTimer;
    FStates: TKMemoStates;
    FTextStyle: TKMemoTextStyle;
    FTopPos: Integer;
    FUndoList: TKMemoChangeList;
    FUpdateLock: Integer;
    FWordBreaks: TKSysCharSet;
    FOnChange: TNotifyEvent;
    FOnDropFiles: TKEditDropFilesEvent;
    FOnReplaceText: TKEditReplaceTextEvent;
    function GetActiveBlock: TKMemoBlock;
    function GetActiveInnerBlock: TKMemoBlock;
    function GetActiveInnerBlocks: TKMemoBlocks;
    function GetCaretVisible: Boolean;
    function GetContentHeight: Integer;
    function GetContentLeft: Integer;
    function GetContentRect: TRect;
    function GetContentTop: Integer;
    function GetContentWidth: Integer;
    function GetEmpty: Boolean;
    function GetInsertMode: Boolean;
    function GetModified: Boolean;
    function GetReadOnly: Boolean;
    function GetRequiredContentWidth: Integer;
    function GetRTF: TKMemoRTFString;
    function GetSelAvail: Boolean;
    function GetSelectableLength: Integer;
    function GetSelectionHasPara: Boolean;
    function GetSelectionParaStyle: TKMemoParaStyle;
    function GetSelectionTextStyle: TKMemoTextStyle;
    function GetSelEnd: Integer;
    function GetSelLength: Integer;
    function GetSelStart: Integer;
    function GetSelText: TKString;
    function GetText: TKString;
    function GetUndoLimit: Integer;
    function IsOptionsStored: Boolean;
    procedure ScrollTimerHandler(Sender: TObject);
    procedure SetColors(Value: TKMemoColors);
    procedure SetDisabledDrawStyle(Value: TKEditDisabledDrawStyle);
    procedure SetLeftPos(Value: Integer);
    procedure SetModified(Value: Boolean);
    procedure SetOptions(const Value: TKEditOptions);
    procedure SetReadOnly(Value: Boolean);
    procedure SetRequiredContentWidth(const Value: Integer);
    procedure SetRTF(const Value: TKMemoRTFString);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetScrollPadding(Value: Integer);
    procedure SetScrollSpeed(Value: Cardinal);
    procedure SetSelectionParaStyle(const Value: TKMemoParaStyle);
    procedure SetSelectionTextStyle(const Value: TKMemoTextStyle);
    procedure SetSelEnd(Value: Integer);
    procedure SetSelLength(Value: Integer);
    procedure SetSelStart(Value: Integer);
    procedure SetText(const Value: TKString);
    procedure SetTopPos(Value: Integer);
    procedure SetUndoLimit(Value: Integer);
    procedure SetWordBreaks(const Value: TKSysCharSet);
    procedure CMEnabledChanged(var Msg: TLMessage); message CM_ENABLEDCHANGED;
    procedure CMSysColorChange(var Msg: TLMessage); message CM_SYSCOLORCHANGE;
  {$IFNDEF FPC}
    procedure EMGetSel(var Msg: TLMessage); message EM_GETSEL;
    procedure EMSetSel(var Msg: TLMessage); message EM_SETSEL;
  {$ENDIF}
    procedure WMClear(var Msg: TLMessage); message LM_CLEAR;
    procedure WMCopy(var Msg: TLMessage); message LM_COPY;
    procedure WMCut(var Msg: TLMessage); message LM_CUT;
  {$IFNDEF FPC}
    // no way to get filenames in Lazarus inside control (why??)
    procedure WMDropFiles(var Msg: TLMessage); message LM_DROPFILES;
  {$ENDIF}
    procedure WMEraseBkgnd(var Msg: TLMessage); message LM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg: TLMNoParams); message LM_GETDLGCODE;
    procedure WMHScroll(var Msg: TLMHScroll); message LM_HSCROLL;
    procedure WMKillFocus(var Msg: TLMKillFocus); message LM_KILLFOCUS;
    procedure WMPaste(var Msg: TLMessage); message LM_PASTE;
    procedure WMSetFocus(var Msg: TLMSetFocus); message LM_SETFOCUS;
    procedure WMVScroll(var Msg: TLMVScroll); message LM_VSCROLL;
    function GetNearestParagraph: TKMemoParagraph;
  protected
    FActiveBlocks: TKMemoBlocks;
    FCaretRect: TRect;
    FHorzExtent: Integer;
    FHorzScrollExtent: Integer;
    FHorzScrollStep: Integer;
    FLinePosition: TKMemoLinePosition;
    FOldCaretRect: TRect;
    FPrinting: Boolean;
    FPreferredCaretPos: Integer;
    FRequiredMouseCursor: TCursor;
    FVertExtent: Integer;
    FVertScrollExtent: Integer;
    FVertScrollStep: Integer;
    { Inserts a single crCaretPos item into undo list. Unless Force is set to True,
      this change will be inserted only if previous undo item is not crCaretPos. }
    procedure AddUndoCaretPos(Force: Boolean = True); virtual;
    { Inserts a single character change into undo list.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>AItemKind</I> - specifies the undo/redo item reason - most likely
      crInsertChar or crDeleteChar.</LI>
      <LI><I>AData</I> - specifies the character needed to restore the original
      text state</LI>
      <LI><I>AInserted</I> - for the urInsert* items, specifies the current
      @link(TKCustomMemo.InsertMode) status.</LI>
      </UL> }
    procedure AddUndoChar(AItemKind: TKMemoChangeKind; AData: TKChar; AInserted: Boolean = True); virtual;
    { Inserts a string change into undo list.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>AItemKind</I> - specifies the undo/redo item reason - crInsert* or
      crDelete*.</LI>
      <LI><I>AData</I> - specifies the text string needed to restore the original
      text state</LI>
      <LI><I>AInserted</I> - for the urInsert* items, specifies the current
      @link(TKCustomMemo.InsertMode) status.</LI>
      </UL> }
    procedure AddUndoString(AItemKind: TKMemoChangeKind; const AData: TKString; AInserted: Boolean = True); virtual;
    { Begins a new undo group. Use the GroupKind parameter to label it. }
    procedure BeginUndoGroup(AGroupKind: TKMemoChangeKind);
    { Converts a rectangle relative to active blocks to a rectangle relative to TKMemo. }
    function BlockRectToRect(const ARect: TRect): TRect; virtual;
    { IKMemoNotifier implementation. }
    procedure BlocksFreeNotification(ABlocks: TKMemoBlocks);
    { Update the editor after block changes. }
    procedure BlocksChanged(Reasons: TKMemoUpdateReasons);
    { Calls mouse move action for all blocks with current mouse coordinates and shift state. }
    procedure BlocksMouseMove; virtual;
    { Determines whether an ecScroll* command can be executed. }
    function CanScroll(ACommand: TKEditCommand): Boolean; virtual;
    { Called by ContentPadding class to update the memo control. }
    procedure ContentPaddingChanged(Sender: TObject); virtual;
    { Overriden method - window handle has been created. }
    procedure CreateHandle; override;
    { Overriden method - defines additional styles for the memo window (scrollbars etc.). }
    procedure CreateParams(var Params: TCreateParams); override;
    { Overriden method - adjusts file drag&drop functionality. }
    procedure CreateWnd; override;
    { Overriden method - adjusts file drag&drop functionality. }
    procedure DestroyWnd; override;
    { Calls the @link(TKCustomMemo.OnChange) event. }
    procedure DoChange; virtual;
    { Performs the Copy command. }
    function DoCopy: Boolean; virtual;
    { Overriden method - handles mouse wheel messages. }
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    { Performs the Paste command. }
    function DoPaste: Boolean; virtual;
    { Performs the Redo command. }
    function DoRedo: Boolean; virtual;
    { Perforns the Search or Replace command. }
    function DoSearchReplace(AReplace: Boolean): Boolean; virtual;
    { Performs the Undo command. }
    function DoUndo: Boolean; virtual;
    { Closes the undo group created by @link(TKCustomMemo.BeginUndoGroup). }
    procedure EndUndoGroup;
    { Notify blocks about memo font change. }
    procedure FontChange(Sender: TObject); virtual;
    { IKMemoNotifier implementation. }
    function GetDefaultTextStyle: TKMemoTextStyle;
    { IKMemoNotifier implementation. }
    function GetDefaultParaStyle: TKMemoParaStyle;
    { Returns actual scroll padding in horizontal direction. }
    function GetHorzScrollPadding: Integer; virtual;
    { IKMemoNotifier implementation. }
    function GetLinePosition: TKMemoLinePosition;
    { IKMemoNotifier implementation. }
    function GetListTable: TKMemoListTable;
    { IKMemoNotifier implementation. }
    function GetPaintSelection: Boolean;
    { IKMemoNotifier implementation. }
    function GetPrinting: Boolean;
    { IKMemoNotifier implementation. }
    procedure GetSelColors(out Foreground, Background: TColor);
    { IKMemoNotifier implementation. }
    function GetShowFormatting: Boolean;
    { Returns "real" selection end - with always higher index value than selection start value. }
    function GetRealSelEnd: Integer; virtual;
    { Returns "real" selection start - with always lower index value than selection end value. }
    function GetRealSelStart: Integer; virtual;
    { Returns actual scroll padding in vertical direction. }
    function GetVertScrollPadding: Integer; virtual;
    { IKMemoNotifier implementation. }
    function GetWordBreaks: TKSysCharSet;
    { Hides the caret. }
    procedure HideEditorCaret; virtual;
    { Overriden method - processes virtual key strokes according to current @link(TKCustomMemo.KeyMapping). }
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
 {$IFDEF FPC}
    { Overriden method - processes character key strokes - data editing. }
    procedure UTF8KeyPress(var Key: TUTF8Char); override;
 {$ELSE}
    { Overriden method - processes character key strokes - data editing. }
    procedure KeyPress(var Key: Char); override;
 {$ENDIF}
    { Overriden method - processes virtual key strokes. }
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    { Update the editor after list table changes. }
    procedure ListChanged(AList: TKMemoList; ALevel: TKMemoListLevel); virtual;
    { Updates information about printed shape. }
    procedure MeasurePages(var Info: TKPrintMeasureInfo); override;
    { Overriden method - updates caret position/selection. }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    { Overriden method - updates caret position/selection and initializes scrolling
      when needed. }
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    { Overriden method - releases mouse capture acquired by MouseDown. }
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    { Paints the document to specified canvas. }
    procedure PaintContent(ACanvas: TCanvas; const ARect: TRect; ALeftOfs, ATopOfs: Integer);
    { Paints a page to a printer/preview canvas. }
    procedure PaintPage; override;
    { Overriden method - calls PaintContent to paint the document into window client area. }
    procedure PaintToCanvas(ACanvas: TCanvas); override;
    { Reacts on default paragraph style changes and notifies all paragraph blocks. }
    procedure ParaStyleChanged(Sender: TObject; AReasons: TKMemoUpdateReasons); virtual;
    { Converts a point relative to TKMemo to a point relative to active blocks. }
    function PointToBlockPoint(const APoint: TPoint; ACalcActive: Boolean = True): TPoint; virtual;
    { Overriden method - calls MeasureExtent to update document metrics for printing. }
    procedure PrintPaintBegin; override;
    { Overriden method - calls necessary functions to update document metrics for normal painting. }
    procedure PrintPaintEnd; override;
    { Grants the input focus to the control when possible and the control has had none before. }
    procedure SafeSetFocus;
    { Scrolls the text either horizontally by DeltaHorz scroll units or vertically
      by DeltaVert scroll units (lines) or in both directions. CodeHorz and CodeVert
      are the codes coming from WM_HSCROLL or WM_VSCROLL messages. }
    function Scroll(CodeHorz, CodeVert, DeltaHorz, DeltaVert: Integer; ACallScrollWindow: Boolean): Boolean;
    { Scrolls the memo window horizontaly by DeltaHorz scroll units and/or
      vertically by DeltaVert scroll units (lines). }
    function ScrollBy(DeltaHorz, DeltaVert: Integer; ACallScrollWindow: Boolean): Boolean;
    { Determines if a cell specified by ACol and ARow should be scrolled, i.e. is
      not fully visible. }
    function ScrollNeeded(AMousePos: PPoint; out DeltaCol, DeltaRow: Integer): Boolean; virtual;
    { Scrolls the memo so that caret will be in the center of client area. }
    procedure ScrollToClientAreaCenter;
    { Expands the current selection and performs all necessary adjustments. }
    procedure SelectionExpand(ASelEnd: Integer; ADoScroll: Boolean = True; APosition: TKMemoLinePosition = eolInside); overload; virtual;
    { Expands the current selection and performs all necessary adjustments. }
    procedure SelectionExpand(const APoint: TPoint; ADoScroll: Boolean = True); overload; virtual;
    { Initializes the current selection and performs all necessary adjustments. }
    procedure SelectionInit(ASelStart: Integer; ADoScroll: Boolean = True; APosition: TKMemoLinePosition = eolInside); overload; virtual;
    { Initializes the current selection and performs all necessary adjustments. }
    procedure SelectionInit(const APoint: TPoint; ADoScroll: Boolean = True); overload; virtual;
    { IKMemoNotifier implementation. }
    procedure SetReqMouseCursor(ACursor: TCursor);
    { Updates mouse cursor according to the state determined from current mouse
      position. Returns True if cursor has been changed. }
    function SetMouseCursor(X, Y: Integer): Boolean; override;
    { Shows the caret. }
    procedure ShowEditorCaret; virtual;
    { Reacts on default text style changes and notifies all text blocks. }
    procedure TextStyleChanged(Sender: TObject); virtual;
    { Calls the @link(TKCustomMemo.DoChange) method. }
    procedure UndoChange(Sender: TObject; ItemKind: TKMemoChangeKind);
    { Updates caret position, shows/hides caret according to the input focus
      <UL>
      <LH>Parameters:</LH>
      <LI><I>Recreate</I> - set to True to recreate the caret after it has already
      been created and displayed</LI>
      </UL> }
    procedure UpdateEditorCaret(AShow: Boolean = True); virtual;
    { Update the preferred caret horizontal position. }
    procedure UpdatePreferredCaretPos; virtual;
    { Updates the scrolling range. }
    procedure UpdateScrollRange(CallInvalidate: Boolean); virtual;
    { Updates the grid size. }
    procedure UpdateSize; override;
    { Redo list manager - made accessible for descendant classes. }
    property RedoList: TKMemoChangeList read FRedoList;
    { States of this class - made accessible for descendant classes. }
    property States: TKMemoStates read FStates write FStates;
    { Undo list manager - made accessible for descendant classes. }
    property UndoList: TKMemoChangeList read FUndoList;
  public
    { Performs necessary initializations - default values to properties, create
      undo/redo list managers. }
    constructor Create(AOwner: TComponent); override;
    { Destroy instance, undo/redo list managers, dispose buffer... }
    destructor Destroy; override;
    { Takes property values from another TKCustomMemo class. }
    procedure Assign(Source: TPersistent); override;
    { Determines whether the caret is visible. }
    function CaretInView: Boolean; virtual;
    { Forces the caret position to become visible. }
    function ClampInView(AMousePos: PPoint; ACallScrollWindow: Boolean): Boolean; virtual;
    { Clears all blocks. Unlike @link(ecClearAll) clears everything inclusive undo a redo lists. }
    procedure Clear;
    { Deletes blocks or parts of blocks corresponding to the active selection.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>ATextOnly</I> - don't clear containers if True</LI>
      </UL> }
    procedure ClearSelection(ATextOnly: Boolean = True); virtual;
    { Clears undo (and redo) list. }
    procedure ClearUndo;
    { Determines whether given command can be executed at this time. Use this
      function in TAction.OnUpdate events.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>Command</I> - specifies the command to inspect</LI>
      </UL> }
    function CommandEnabled(Command: TKEditCommand): Boolean; virtual;
    { Delete all characters from beginning of line to position given by At. }
    procedure DeleteBOL(At: Integer);
    { Delete character at position At (Delete key). }
    procedure DeleteChar(At: Integer); virtual;
    { Delete all characters from position given by At to the end of line. }
    procedure DeleteEOL(At: Integer);
    { Delete character before position At (Backspace key). }
    procedure DeleteLastChar(At: Integer); virtual;
    { Delete whole line at position At. }
    procedure DeleteLine(At: Integer);
    { Executes given command. This function first calls CommandEnabled to
      assure given command can be executed.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>Command</I> - specifies the command to execute</LI>
      <LI><I>Data</I> - specifies the data needed for the command</LI>
      </UL> }
    function ExecuteCommand(Command: TKEditCommand; Data: Pointer = nil): Boolean; virtual;
    { Returns current maximum value for the @link(TKCustomMemo.LeftPos) property. }
    function GetMaxLeftPos: Integer; virtual;
    { Returns current maximum value for the @link(TKCustomMemo.TopPos) property. }
    function GetMaxTopPos: Integer; virtual;
    { Converts a text buffer index into client area rectangle.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>AValue</I> - index to convert</LI>
      <LI><I>ACaret</I> - return caret rectangle</LI>
      </UL> }
    function IndexToRect(AValue: Integer; ACaret: Boolean): TRect; virtual;
    { Inserts a character at specified position.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>At</I> - position where the character should be inserted.</LI>
      <LI><I>AValue</I> - character</LI>
      </UL> }
    procedure InsertChar(At: Integer; const AValue: TKChar); virtual;
    { Inserts new line at specified position.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>At</I> - position where the new line should be inserted.</LI>
      </UL> }
    procedure InsertNewLine(At: Integer); virtual;
    { Inserts a string at specified position.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>At</I> - position where the string should be inserted.</LI>
      <LI><I>AValue</I> - inserted string</LI>
      </UL> }
    procedure InsertString(At: Integer; const AValue: TKString); virtual;
    { Load contents from a file. Chooses format automatically by extension.
      Text file is default format. }
    procedure LoadFromFile(const AFileName: TKString); virtual;
    { Load contents from a RTF file. }
    procedure LoadFromRTF(const AFileName: TKString); virtual;
    { Load contents from a RTF stream. }
    procedure LoadFromRTFStream(AStream: TStream; AtIndex: Integer); virtual;
    { Load contents from a plain text file. }
    procedure LoadFromTXT(const AFileName: TKString); virtual;
    { Moves the caret nearest to current mouse position. }
    procedure MoveCaretToMouseCursor(AIfOutsideOfSelection: Boolean);
    { Converts client area coordinates into a text buffer index.
      <UL>
      <LH>Parameters:</LH>
      <LI><I>APoint</I> - window client area coordinates</LI>
      <LI><I>AOutOfArea</I> - set to True to compute selection even if the
      the supplied coordinates are outside of the text space</LI>
      </UL> }
    function PointToIndex(APoint: TPoint; AOutOfArea, ASelectionExpanding: Boolean; out ALinePos: TKMemoLinePosition): Integer; virtual;
    { Save contents to a file. Chooses format automatically by extension. Text file is default format. }
    procedure SaveToFile(const AFileName: TKString; ASelectedOnly: Boolean = False); virtual;
    { Save contents to a RTF file. }
    procedure SaveToRTF(const AFileName: TKString; ASelectedOnly: Boolean = False); virtual;
    { Save contents to a RTF stream. }
    procedure SaveToRTFStream(AStream: TStream; ASelectedOnly: Boolean = False); virtual;
    { Save contents to a plain text file. }
    procedure SaveToTXT(const AFileName: TKString; ASelectedOnly: Boolean = False); virtual;
    { Specifies the current selection. This is faster than combination of SelStart and SelLength. }
    procedure Select(ASelStart, ASelLength: Integer; ADoScroll: Boolean = True); virtual;
    { Prepare to insert a new block at given position. Returns requested block index. }
    function SplitAt(AIndex: Integer): Integer; virtual;
    { Gives access to active memo block (the outermost block at caret position within ActiveBlocks). }
    property ActiveBlock: TKMemoBlock read GetActiveBlock;
    { Gives access to innermost active memo block (the innermost block at caret position within ActiveBlocks). }
    property ActiveInnerBlock: TKMemoBlock read GetActiveInnerBlock;
    { Gives access to active memo blocks - containers of texts, images etc..
      ActiveBlocks might be different from Blocks when editing the embedded text box etc. }
    property ActiveBlocks: TKMemoBlocks read FActiveBlocks;
    { Gives access to innermost active memo blocks - containers of texts, images etc..
      ActiveInnerBlocks might be different from ActiveBlocks when inside of a table etc. }
    property ActiveInnerBlocks: TKMemoBlocks read GetActiveInnerBlocks;
    { Gives access to memo blocks - containers of texts, images etc.. }
    property Blocks: TKMemoBlocks read FBlocks;
    { Background image. }
    property BackgroundImage: TPicture read FBackgroundImage;
    { Returns current caret position = selection end. }
    property CaretPos: Integer read GetSelEnd;
    { Returns True if caret is visible. }
    property CaretVisible: Boolean read GetCaretVisible;
    { Makes it possible to take all color properties from another TKCustomMemo class. }
    property Colors: TKMemoColors read FColors write SetColors;
    { Specifies the padding around the memo contents. }
    property ContentPadding: TKRect read FContentPadding;
    { Returns height of the memo contents. }
    property ContentHeight: Integer read GetContentHeight;
    { Returns the left position of the memo contents. }
    property ContentLeft: Integer read GetContentLeft;
    { Returns the bounding rectangle of the memo contents. }
    property ContentRect: TRect read GetContentRect;
    { Returns the top position of the memo contents. }
    property ContentTop: Integer read GetContentTop;
    { Returns width of the memo contents. }
    property ContentWidth: Integer read GetContentWidth;
    { Specifies the style how the outline is drawn when editor is disabled. }
    property DisabledDrawStyle: TKEditDisabledDrawStyle read FDisabledDrawStyle write SetDisabledDrawStyle default cEditDisabledDrawStyleDef;
    { Returns True if text buffer is empty. }
    property Empty: Boolean read GetEmpty;
    { Returns horizontal scroll padding - relative to client width. }
    property HorzScrollPadding: Integer read GetHorzScrollPadding;
    { Returns True if insert mode is on. }
    property InsertMode: Boolean read GetInsertMode;
    { Specifies the current key stroke mapping scheme. }
    property KeyMapping: TKEditKeyMapping read FKeyMapping;
    { Specifies the horizontal scroll position. }
    property LeftPos: Integer read FLeftPos write SetLeftPos;
    { Returns the numbering list table. }
    property ListTable: TKMemoListTable read FListTable;
    { Returns True if the buffer was modified - @link(eoUndoAfterSave) taken into
      account. }
    property Modified: Boolean read GetModified write SetModified;
    { Returns nearest paragraph to caret location. }
    property NearestParagraph: TKMemoParagraph read GetNearestParagraph;
    { Specifies the editor options that do not affect painting. }
    property Options: TKEditOptions read FOptions write SetOptions stored IsOptionsStored;
    { Specifies default style for paragraphs. }
    property ParaStyle: TKMemoParaStyle read FParaStyle;
    { Specifies whether the editor has to be read only editor. }
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    { Returns "real" selection end - with always higher index value than selection start value. }
    property RealSelEnd: Integer read GetRealSelEnd;
    { Returns "real" selection start - with always lower index value than selection end value. }
    property RealSelStart: Integer read GetRealSelStart;
    { Specifies the required content width. }
    property RequiredContentWidth: Integer read GetRequiredContentWidth write SetRequiredContentWidth;
    { Allows to save and load the memo contents to/from RTF string.}
    property RTF: TKMemoRTFString read GetRTF write SetRTF;
    { Defines visible scrollbars - horizontal, vertical or both. }
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
    { Specifies how fast the scrolling by timer should be. }
    property ScrollSpeed: Cardinal read FScrollSpeed write SetScrollSpeed default cScrollSpeedDef;
    { Specifies the padding in pixels to overscroll to show caret position or selection end. }
    property ScrollPadding: Integer read FScrollPadding write SetScrollPadding default cScrollPaddingDef;
    { Determines whether a selection is available. }
    property SelAvail: Boolean read GetSelAvail;
    { Returns selectable length. }
    property SelectableLength: Integer read GetSelectableLength;
    { Determines whether a selection contains a paragraph. }
    property SelectionHasPara: Boolean read GetSelectionHasPara;
    { Specifies paragraph style for active selection. }
    property SelectionParaStyle: TKMemoParaStyle read GetSelectionParaStyle write SetSelectionParaStyle;
    { Specifies text style for active selection. }
    property SelectionTextStyle: TKMemoTextStyle read GetSelectionTextStyle write SetSelectionTextStyle;
    { Specifies the current selection end. }
    property SelEnd: Integer read GetSelEnd write SetSelEnd;
    { Specifies the current selection length. SelStart remains unchanged, SelEnd will be
      updated accordingly. To mark a selection, either set both SelStart and SelEnd properties
      or both SelStart and SelLength properties. }
    property SelLength: Integer read GetSelLength write SetSelLength;
    { Specifies the current selection start. }
    property SelStart: Integer read GetSelStart write SetSelStart;
    { Returns selected text. }
    property SelText: TKString read GetSelText;
    { If read, returns the textual part of the contents as a whole. If written, replace previous contents by a new one. }
    property Text: TKString read GetText write SetText;
    { Specifies default style for text. }
    property TextStyle: TKMemoTextStyle read FTextStyle;
    { Specifies the vertical scroll position. }
    property TopPos: Integer read FTopPos write SetTopPos;
    { Specifies the maximum number of undo items. Please note this value
      affects the undo item limit, not undo group limit. }
    property UndoLimit: Integer read GetUndoLimit write SetUndoLimit default cUndoLimitDef;
    { Returns vertical scroll padding - relative to client height. }
    property VertScrollPadding: Integer read GetVertScrollPadding;
    { Defines the characters that will be used to split text to breakable words. }
    property WordBreaks: TKSysCharSet read FWordBreaks write SetWordBreaks;
    { When assigned, this event will be invoked at each change made to the
      text buffer either by the user or programmatically by public functions. }
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    { When assigned, this event will be invoked when the user drops any files onto
      the window. }
    property OnDropFiles: TKEditDropFilesEvent read FOnDropFiles write FOnDropFiles;
    { When assigned, this event will be invoked at each prompt-forced search match. }
    property OnReplaceText: TKEditReplaceTextEvent read FOnReplaceText write FOnReplaceText;
  end;

  { @abstract(Memo design-time component) }
  TKMemo = class(TKCustomMemo)
  published
    { Inherited property - see Delphi help. }
    property Align;
    { Inherited property - see Delphi help. }
    property Anchors;
    { See TKCustomControl.@link(TKCustomControl.BorderStyle) for details. }
    property BorderStyle;
    { Inherited property - see Delphi help. }
    property BorderWidth;
    { See TKCustomMemo.@link(TKCustomMemo.Colors) for details. }
    property Colors;
    { Inherited property - see Delphi help. }
    property Constraints;
    { See TKCustomMemo.@link(TKCustomMemo.ContentPadding) for details. }
    property ContentPadding;
  {$IFNDEF FPC}
    { Inherited property - see Delphi help. }
    property Ctl3D;
  {$ENDIF}
    { See TKCustomMemo.@link(TKCustomMemo.DisabledDrawStyle) for details. }
    property DisabledDrawStyle;
    { Inherited property - see Delphi help. }
    property DragCursor;
    { Inherited property - see Delphi help. }
    property DragKind;
    { Inherited property - see Delphi help. }
    property DragMode;
    { Inherited property - see Delphi help. }
    property Enabled;
    { Inherited property - see Delphi help. Font pitch must always remain fpFixed
      - specify fixed fonts only. Font.Size will also be trimmed if too small or big. }
    property Font;
    { Inherited property - see Delphi help. }
    property Height default cHeight;
    { See TKCustomMemo.@link(TKCustomMemo.Options) for details. }
    property Options;
    { Inherited property - see Delphi help. }
    property ParentShowHint;
    { Inherited property - see Delphi help. }
    property PopupMenu;
    { See TKCustomMemo.@link(TKCustomMemo.ReadOnly) for details. }
    property ReadOnly;
    { See TKCustomMemo.@link(TKCustomMemo.ScrollBars) for details. }
    property ScrollBars;
    { See TKCustomMemo.@link(TKCustomMemo.ScrollPadding) for details. }
    property ScrollPadding;
    { See TKCustomMemo.@link(TKCustomMemo.ScrollSpeed) for details. }
    property ScrollSpeed;
    { Inherited property - see Delphi help. }
    property ShowHint;
    { Inherited property - see Delphi help. }
    property TabOrder;
    { Inherited property - see Delphi help. }
    property TabStop default True;
    { See TKCustomMemo.@link(TKCustomMemo.UndoLimit) for details. }
    property UndoLimit;
    { Inherited property - see Delphi help. }
    property Visible;
    { Inherited property - see Delphi help. }
    property Width default cWidth;
    { See TKCustomMemo.@link(TKCustomMemo.OnChange) for details. }
    property OnChange;
    { Inherited property - see Delphi help. }
    property OnClick;
    { Inherited property - see Delphi help. }
    property OnContextPopup;
    { Inherited property - see Delphi help. }
    property OnDblClick;
    { Inherited property - see Delphi help. }
    property OnDockDrop;
    { Inherited property - see Delphi help. }
    property OnDockOver;
    { Inherited property - see Delphi help. }
    property OnDragDrop;
    { Inherited property - see Delphi help. }
    property OnDragOver;
    { See TKCustomMemo.@link(TKCustomMemo.OnDropFiles) for details. }
    property OnDropFiles;
    { Inherited property - see Delphi help. }
    property OnEndDock;
    { Inherited property - see Delphi help. }
    property OnEndDrag;
    { Inherited property - see Delphi help. }
    property OnEnter;
    { Inherited property - see Delphi help. }
    property OnExit;
    { Inherited property - see Delphi help. }
    property OnGetSiteInfo;
    { Inherited property - see Delphi help. }
    property OnKeyDown;
    { Inherited property - see Delphi help. }
    property OnKeyPress;
    { Inherited property - see Delphi help. }
    property OnKeyUp;
    { Inherited property - see Delphi help. }
    property OnMouseDown;
  {$IFDEF COMPILER9_UP}
    { Inherited property - see Delphi help. }
    property OnMouseEnter;
    { Inherited property - see Delphi help. }
    property OnMouseLeave;
  {$ENDIF}
    { Inherited property - see Delphi help. }
    property OnMouseMove;
    { Inherited property - see Delphi help. }
    property OnMouseUp;
    { Inherited property - see Delphi help. }
    property OnMouseWheel;
    { Inherited property - see Delphi help. }
    property OnMouseWheelDown;
    { Inherited property - see Delphi help. }
    property OnMouseWheelUp;
    { See TKCustomMemo.@link(TKCustomMemo.OnReplaceText) for details. }
    property OnReplaceText;
    { Inherited property - see Delphi help. }
    property OnResize;
    { Inherited property - see Delphi help. }
    property OnStartDock;
    { Inherited property - see Delphi help. }
    property OnStartDrag;
    { Inherited property - see Delphi help. }
    property OnUnDock;
  end;

  