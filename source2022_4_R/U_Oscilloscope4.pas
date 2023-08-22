unit U_Oscilloscope4;
{Copyright 2002-2014, Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A simple Oscilloscope using  TWaveIn class.
 More info at http://www.delphiforfun.org/programs/oscilloscope.htm
}
{
This simple oscilloscope uses the, Menus, ufrmOscilloscope4, StdCtrls,
  ComCtrls, Buttons, Controls, Forms, ufrmInputControl4, Classes, ExtCtrls Windows Wavein API to capture data from
a sound card and display it in the screen area above.   Use the Windows
"Volume Controls - Options - Properties"  dialog and select "Recording
Controls" to select input source(s) to be displayed.    After the Start button
is clicked, any messages describing capture problems will be displayed here.

Version  2: A "Trigger" capability has been added.  Each scan is triggered
when the signal rises above (+) or below (-) the preset trigger level.  To
improve the image capture of transient events, there is now a "Capture
Single Frame" button.  Use he "Trigger" feature to control when the frame
will be captured.

Version 3  Spectrum analysis of Captured frames.  User selectable Sample
rates.  Time scale ref.lines on display.

Version 4:  Dual trace function added.  Improved visual layout.   Improved
controls.  Input signal selectable via buttons.    Settings saved from run to
run.  Many thanks to "Krille", a very sharp Delphi programmer from Sweden.
enhanced to maXbox by maXboy
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UWaveIn4 ,mmsystem,  ExtCtrls, ComCtrls, shellApi, Menus, Buttons,
  ufrmOscilloscope4, ufrmInputControl4;

type
  PBufArray=PByteARRAY;
  TOscfrmMain = class(TForm)
    Label2: TLabel;
    SweepEdt: TEdit;
    SweepUD: TUpDown;
    Label3: TLabel;
    TrigLevelBar: TTrackBar;
    Label4: TLabel;
    ScaleLbl: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    menuSaveImage1: TMenuItem;
    N1: TMenuItem;
    menuExit: TMenuItem;
    statustext: TPanel;
    btnRun: TSpeedButton;
    Panel3: TPanel;
    GrpChannel1: TGroupBox;
    Panel5: TPanel;
    Panel6: TPanel;
    grpChannel2: TGroupBox;
    btnDual: TSpeedButton;
    btnTriggCh1: TSpeedButton;
    btnTriggCh2: TSpeedButton;
    btnTrigPositiv: TSpeedButton;
    btnTrigNegativ: TSpeedButton;
    GroupBox1: TGroupBox;
    btnTrigerOn: TSpeedButton;
    trOfsCh1: TTrackBar;
    trOfsCh2: TTrackBar;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    upGainCh1: TUpDown;
    upGainCh2: TUpDown;
    edtGainCh1: TEdit;
    edtGainCh2: TEdit;
    GroupBox2: TGroupBox;
    sp11025Sample: TSpeedButton;
    sp22050Sample: TSpeedButton;
    sp44100Sample: TSpeedButton;
    Panel1: TPanel;
    Panel4: TPanel;
    frmOscilloscope1: TfrmOscilloscope;
    trStartPos: TTrackBar;
    btnCH1Gnd: TSpeedButton;
    btnCH2Gnd: TSpeedButton;
    Screen1: TMenuItem;
    Color1: TMenuItem;
    menuBlack: TMenuItem;
    MenuGreen: TMenuItem;
    btnExpand2: TSpeedButton;
    btnExpand4: TSpeedButton;
    btnExpand1: TSpeedButton;
    btnExpand8: TSpeedButton;
    Label12: TLabel;
    Data1: TMenuItem;
    MenuData_Time: TMenuItem;
    PageControl1: TPageControl;
    Runsheet: TTabSheet;
    IntroSheet: TTabSheet;
    Memo1: TMemo;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label13: TLabel;
    btnGain0: TSpeedButton;
    btnGain1: TSpeedButton;
    btnGain2: TSpeedButton;
    SpectrumBtn: TBitBtn;
    BtnOneFrame: TSpeedButton;
    CalibrateBtn: TBitBtn;
    OnCh1Box: TCheckBox;
    OnCh2Box: TCheckBox;
    StaticText1: TStaticText;
    frmInputControl1: TfrmInputControl;
    GroupBox4: TGroupBox;
    Label9: TLabel;
    UpScaleLight: TUpDown;
    Label1: TLabel;
    upBeamLight: TUpDown;
    Label10: TLabel;
    upFocus: TUpDown;
    procedure upFocusClick(Sender: TObject; Button: TUDBtnType);

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SweepEdtChange(Sender: TObject);

    {Message handler for "buffers ready to process" message}
    procedure Bufferfull(var Message: TMessage); message MM_WIM_DATA;
    procedure BtnOneFrameClick(Sender: TObject);
    procedure TrigLevelBarChange(Sender: TObject);
    procedure CalibrateBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SpectrumBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure menuExitClick(Sender: TObject);
    procedure menuSaveImage1Click(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnDualClick(Sender: TObject);
    procedure btnTrigerOnClick(Sender: TObject);
    procedure edtGainCh1Change(Sender: TObject);
    procedure edtGainCh2Change(Sender: TObject);
    procedure sp11025SampleClick(Sender: TObject);
    procedure sp22050SampleClick(Sender: TObject);
    procedure sp44100SampleClick(Sender: TObject);
    procedure trOfsCh1Change(Sender: TObject);
    procedure trOfsCh2Change(Sender: TObject);
    procedure upBeamLightClick(Sender: TObject; Button: TUDBtnType);
    procedure btnCh2OnClick(Sender: TObject);
    procedure btnCh1OnClick(Sender: TObject);
    procedure btnCH1GndClick(Sender: TObject);
    procedure btnCH2GndClick(Sender: TObject);
    procedure MenuGreenClick(Sender: TObject);
    procedure menuBlackClick(Sender: TObject);
    procedure trStartPosChange(Sender: TObject);
    procedure btnExpand2Click(Sender: TObject);
    procedure btnExpand1Click(Sender: TObject);
    procedure btnExpand4Click(Sender: TObject);
    procedure btnExpand8Click(Sender: TObject);
    procedure UpScaleLightChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure MenuData_TimeClick(Sender: TObject);
    procedure btnGain0Click(Sender: TObject);
    procedure btnGain1Click(Sender: TObject);
    procedure btnGain2Click(Sender: TObject);
    procedure Label12DblClick(Sender: TObject);
  private
    BeamA: array of TPoint; //Array of data for the beam at channel1
    BeamB: array of TPoint; //Array of data for the beam at channel2
    StoredExpand :integer;     // Expand level of the capured frame
    StoredCH1Offs:integer;
    StoredCH2Offs:integer;


    procedure DoDrawBeamText(Sender:Tobject);
    procedure SaveImage;
    procedure ChangeSampleRate;
    procedure Start;
    procedure Stop;
    procedure SetButtonstate;
    procedure ShowStored;
    function GetExpand: integer;
    procedure CenterAdjust;
    function GetGain: double;
    procedure Recalc;
    procedure ShowScaleValue;

  public
    WaveIn : TWavein;
    {variables used by Bufferfull procedure}
      cy:integer;  //Center Y
      hInc:single; {seconds per time scale line}
      //ppL:single; {points per time scale line}
      //nbrVLines:Integer; {number of time scale lines}
      //pgL:single;  {points per gain scale line}

      errcount:integer;
      Ch1Gain:integer;
      Ch2Gain:integer;
      origbufsize,bufsize:integer;
      framesize:integer; {number of input points per frame}
      xinc:integer;
      X,Y:integer;
      PlotPtsPerFrame:integer;
      nbrframes:integer; {we'll draw this many frames from this buffer}
      time1,time2:TTime;
      singleframe:boolean;

      trigsign:integer; {+1 for + trigger, 0 for no trigger test, -1 for - trigger}
      triglevel:integer;  {current trigger level}
      triggered:boolean; {trigger had been tripped}
      triggerindex:integer; {bytes saved from 1st buffer when a frame must span buffers}
      trigbarchanging, trigGrpchanging:boolean;  {Change flags to synchronize changes}
      frameSaveBuf:array of byte; {space to save couple of buffers for single
                                   frame processing}
      calibrate:boolean;
      Offsety:integer;
      savedframedata:array of integer;

      {debug} buffer1found:boolean;
      inputfrm:TfrmInputControl;
    Procedure Posterror(S:string);
    procedure setup;
    Procedure setmaxPtsToAvg;
    procedure SetOscState;
  end;

var OscfrmMain: TOscfrmMain;

implementation

uses U_Spectrum4,uSettings ;

{$R *.DFM}
var
  framesPerBuffer:integer=2;
  numbuffers :integer=4;

const
  nbrHLines = 10;

{********************* FormCreate ************}
procedure TOscfrmMain.FormCreate(Sender: TObject);
begin
  doublebuffered := true;
 // origbufsize    := framesperbuffer*image1.width;
 with frmOscilloscope1 do
  begin
    imgscreen.top:=image2.top;
    imgscreen.Left:=image2.left;
    imgscreen.width:=image2.width;
    imgscreen.Height:=image2.Height;
    OnAfterBeamDraw := DoDrawBeamText;
  end;
  origbufsize    := framesperbuffer*frmOscilloscope1.imgScreen.width;
  bufsize        := origbufsize;
  setlength(framesaveBuf,2*bufsize);
  xinc           := SweepUD.position;
  setmaxptstoavg;

  offsety := 128;  {vertical center of screen assuming 8-bit data collection}
  StoredExpand :=1;
  setup;

  uSettings.GetSettings;


end;

procedure TOscfrmMain.FormActivate(Sender: TObject);
begin
 // windowstate:=wsmaximized;
  SetButtonState;
end;

procedure TOscfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ Stop the recorder first}
begin
  if assigned(wavein) then
  begin
    Wavein.StopInput;
    FreeAndNil(Wavein);
  end;

  canclose := true;

  if CanClose then
    uSettings.SaveSettings;

end;


  {***************** Setup ****************}
procedure TOscfrmMain.setup;
{Initialize the TWaveIn class and initial the image area}
begin
  errcount := 0;
  x := 0;

  if not assigned(Wavein) then
    Wavein := TWavein.create(handle,{orig}bufsize,numbuffers);

  With Wavein, ptrWavefmtEx^ Do
  Begin
    wFormatTag := WAVE_FORMAT_PCM;

    if btnDual.Down then
      nChannels  := 2
    else
      nChannels  := 1;

    if sp11025sample.Down then
    begin
      nSamplesPerSec := 11025;
      hinc           := 0.004;
    end
    else if sp22050Sample.Down then
    begin
      nSamplesPerSec := 22050;
      hinc           := 0.002;
    end
    else if sp44100Sample.Down then
    begin
      nSamplesPerSec := 44100;
      hinc           := 0.001;
    end;
   { else if sp4800Sample.Down then
    begin
      nSamplesPerSec := 48000;
      hinc           := 0.0009187;
    end;}

//    scalelbl.caption := format('Scale: %5.2f ms/div',[hinc*1000]);

    ShowScaleValue;
    SetOscState;

    wBitsPerSample  := 8;

    nAvgBytesPerSec := nSamplesPerSec*(wBitsPerSample div 8)*nChannels;
    onerror := Posterror;

    if setupInput then
      statustext.caption:='Stopped'
    else
      statustext.caption:='Error - Try again';

    {Initialize image}

   //if btnDual.Down then
   // setlength(framesaveBuf,4*bufsize)
   //else
    setlength(framesaveBuf,2*bufsize);

    //cy  := image1.height div 2;
    cy  := frmOscilloscope1.imgScreen.height div 2;
    //ppl := hInc * nsamplespersec;
    //nbrVlines := trunc(image1.width/ppl);
    //nbrVlines := trunc(frmOscilloscope1.imgScreen.width/ppl);
    //pgL := image1.Height/nbrHLines;
    //pgL := frmOscilloscope1.imgScreen.Height/nbrHLines;
  end;

  setlength(savedframedata,0); {forget about any saved data}
end;

procedure TOscfrmMain.ShowScaleValue;
begin
  if btnDual.Down then
    scalelbl.caption := format('Scale: %5.2f ms/div',[hinc*1000/xinc/2 ])
  else
    scalelbl.caption := format('Scale: %5.2f ms/div',[hinc*1000/xinc ]);
end;

procedure TOscfrmMain.btnRunClick(Sender: TObject);
begin
  Recalc;


  if btnRun.Down then
    Start
  else
  begin
    Stop;
  end;

  SetButtonstate;
end;

procedure TOscfrmMain.Recalc;
begin

  if btnDual.Down then
  begin
    //PlotPtsPerFrame := (frmOscilloscope1.imgScreen.width div xinc)*2;
    PlotPtsPerFrame := (frmOscilloscope1.imgScreen.width )*2;
  end
  else
  begin
    //PlotPtsPerFrame := (frmOscilloscope1.imgScreen.width div xinc)+50;
    PlotPtsPerFrame := (frmOscilloscope1.imgScreen.width );
  end;


 // bufsize := framesperbuffer*frmOscilloscope1.imgScreen.width ;
 // setlength(FrameSaveBuf,2*bufsize);  {we'll save two buffers to make sure we
                                      // get a full frame after a trigger event}
  setmaxptstoavg;
end;


Procedure TOscfrmMain.Start; {Start the recorder}
begin
  memo1.color:=clWindow;
  memo1.Clear;
  memo1.lines.add('Messages');

  Setup; {opens wavein and prepare buffers}

  singleframe := false;
  triggered   := false;

  if wavein.recordactive then
  begin
    wavein.stopinput; {just in case}
    application.processmessages;
  end;

  Wavein.StartInput; {start recording}
  statustext.caption := 'Running';
end;


procedure TOscfrmMain.Stop;
begin
  if assigned(wavein) then
    Wavein.StopInput;

  statustext.caption := 'Stopped';
end;

{************** OneFrameBtnClick ***********}
procedure TOscfrmMain.BtnOneFrameClick(Sender: TObject);
begin

  if BtnOneFrame.Down then
  begin
    StoredCH1Offs :=trOfsCh1.Position;
    StoredCH2Offs :=trOfsCh2.Position;

    SetButtonstate;
    Recalc;

    btnExpand1.Down := True;
    btnGain1.Down   := True;

    memo1.color := clWindow;
    memo1.Clear;
    memo1.lines.add('Messages');
    Setup; {opens wavein and prepare buffers}

    singleframe  := true;
    {if triggerRgrp.itemindex=1 then triggerrgrp.itemindex:=0; }
    triggered    := false;
    triggerindex := 0;

    if assigned(wavein) and wavein.recordactive then
    begin
      Wavein.stopinput;
      application.processmessages;
    end;

    {debug}
    Buffer1found := false;
    if assigned(wavein) then
      Wavein.StartInput; {start recording}
    statustext.caption := 'Frame capture - waiting for trigger';
  end
  else
  begin
    singleframe  := false;

    if assigned(wavein) and wavein.recordactive then
    begin
      Wavein.stopinput;
      application.processmessages;
    end;
    SetButtonstate;
  end;

end;

{**********************************************}
{****************** BufferFull ****************}
{**********************************************}
procedure TOscfrmMain.Bufferfull(var Message: TMessage);
{Called when a buffer fills (a MM_WIN_DATA mesage is received)}
var
  i:integer;
  p:PBufArray {pByteArray};
  pstart:integer;
  //i1:integer;
  framestoscan:integer;

      {Local function:  ScanBufferForTrigger}
      function scanBufferfortrigger(p:PBufArray{PByteArray}):integer;
      var  i:integer;
      begin
        result := -1;
        for i :=1 to bufsize-1 do
        begin
           if (P^[i-1]<triglevel) and (P^[i]>=triglevel)
           then
           begin
             result := i;
             break;
           end;
        end;
      end;

      {Local function:  Scale, scale the amplitude value for plotting}
      function Ch1scale(x:integer):integer;
      var N:integer;
      begin
         N := offsety-x; {just sample for now}
             {adjust gain using gain value as a power of 2}
        if Ch1Gain<3 then
          N := N shr (3-Ch1Gain)
        else if Ch1Gain>3 then
          N := N shl (Ch1Gain-3);

        result := Cy+ N;
      end;

      function Ch2scale(x:integer):integer;
      var N:integer;
      begin
         N := offsety-x; {just sample for now}
             {adjust gain using gain value as a power of 2}
        if Ch2Gain < 3 then
          N := N shr (3-Ch2Gain)
        else if Ch2Gain > 3 then
          N := N shl (Ch2Gain-3);

        result := Cy+ N;
      end;

var
  BeamI:integer;
begin   {BufferFull}
  {Let program respond to btn clicks once per second (in case we're swamped)}
  time2 := now;

  if (time2-time1)>1/secsperday then
  begin
    application.processmessages;
    time1 := time2;

    //----------------------------------------
    if not btnRun.Down or (Panel3.Color = clRed)
    then Panel3.Color := clMaroon
    else Panel3.Color := clRed;
    //----------------------------------------

  end;


  Framestoscan := nbrframes-1;

  if assigned(wavein) and (wavein.recordactive) then
    with Wavein do   {if  recordactive then  }
    begin

      {lparam of the the message contains a pointer to a waveHdr structure whose
       first entry is a pointer to the buffer}
      p := pointer(pwavehdr(message.lparam)^.lpdata); {pointer to filled buffer}
      {bufsize:=pwavehdr(message.lparam)^.dwbytesrecorded; }
      {we should also get the size from wavehdr since, in theory, final buffers
       might be truncated}
       x := 0;

       if calibrate then {reset zero level}
       begin
         offsety := 0;
         for i := 0 to bufsize-1 do
           inc(offsety,p^[i]);

         offsety := offsety div bufsize;
         calibrate := false;
       end;

      if btnTrigerOn.Down then
      begin
        if btnTrigPositiv.Down then trigsign := +1
        else if btnTrigNegativ.Down then trigsign := -1
      end
      else trigsign := 0;

      triglevel := -triglevelbar.position + offsetY; {make trigger level a variable} {gdd}

      //--------------------------------------

      if singleframe then
      begin
        if not triggered then
        begin {scan to see if this buffer will trigger}
          triggerindex := scanbufferfortrigger(p);
          if triggerindex >= 0 then
          begin
            move(p^[triggerindex],framesavebuf[0],bufsize-triggerindex);
            triggered:=true;
          end;
          framestoscan := -1; {draw nothing for this case - single frame and
                             not triggered or triggered with partial buffer}
          Buffer1found := true;  {Debug}
        end
        else
        begin  {we have saved buffer previously and were waiting for this one to
                  ensure that we can draw a full frame.  (The first buffer may have
                  found the trigger event near the end of the buffer and did not
                  have enough data to draw a full frame)}
          move(p^,frameSavebuf[bufsize-triggerindex],bufsize);
          p := @frameSavebuf[0];
          framestoscan := 0; {scan only one frame}
        end;
      end;

      //--------------------------------------

    //for i1 := 0 to FramesToscan do
    //begin  {start a new trace}

      pstart :=  width;

      x := trStartPos.Position;
      BeamI := -1;
      i     := 0;

      triggered := trigsign=0;

      if btnDual.Down then  //Dual trace
      begin
        SetLength(BeamA, round(PlotPtsPerFrame/2)-2  );
        SetLength(BeamB, round(PlotPtsPerFrame/2)-2  );

        while i <= PlotPtsPerFrame-6  do
        begin
          inc(i,2);
          inc(BeamI);

          if (not triggered) and (i>0)then
          begin
            if btnTriggCh1.Down then
            begin
              if (((trigsign>0) and(P^[i-2]<triglevel) and (P^[i]>=triglevel))
                or ((trigsign<0) and (P^[i-2]>triglevel) and (P^[i]<=triglevel)))
              then
                triggered := true;
             end
            else
            begin
              if (((trigsign>0) and(P^[i-1]<triglevel) and (P^[i+1]>=triglevel))
                or ((trigsign<0) and (P^[i-1]>triglevel) and (P^[i+1]<=triglevel)))
              then
                triggered := true;
            end;
          end;

          if triggered then
          begin
            BeamA[BeamI].X := x;
            BeamA[BeamI].Y := Ch1scale(p^[i])+trOfsCh1.Position;

            BeamB[BeamI].X := x;
            BeamB[BeamI].Y := Ch2scale(p^[i+1])+trOfsCh2.Position;
            inc(x,xinc*2);
          end
          else
          begin
            BeamA[BeamI].X := trStartPos.Position;
            BeamA[BeamI].Y := Ch1scale(triglevel)+trOfsCh1.Position;

            BeamB[BeamI].X := trStartPos.Position;
            BeamB[BeamI].Y := Ch2scale(triglevel)+trOfsCh2.Position;
          end;
        end;

      end
      else
      begin //singe trace
        SetLength(BeamA, round(PlotPtsPerFrame)-3 );

        while i <= PlotPtsPerFrame-4  do
        begin
          inc(i);
          inc(BeamI);

          if (not triggered) and (i>0)
               and (((trigsign>0) and(P^[i-1]<triglevel) and (P^[i]>=triglevel))
                  or ((trigsign<0) and (P^[i-1]>triglevel) and (P^[i]<=triglevel)))
            then
              triggered := true;

          if triggered then
          begin
            BeamA[BeamI].X := x;
            BeamA[BeamI].Y := Ch1scale(p^[i])+trOfsCh1.Position;
            inc(x,xinc);
          end
          else
          begin
            BeamA[BeamI].X := trStartPos.Position;
            BeamA[BeamI].Y := Ch1scale(triglevel )+trOfsCh1.Position;
          end;
        end;
      end;

      //Draw trace
      frmOscilloscope1.BeamData(BeamA,BeamB);
     // end;

       //--------------------------------------

      {Always include the next statements - needed for TWavein to
       add buffer back in }
      inc(ProcessedBuffers); {required - count buffers}
      AddNextBuffer; {required - put buffer back in the queue}

      if singleframe  {singleframe mode}
         and triggered  {it has been triggered}
         and (framestoscan >= 0) {we have drawn the image} then
      begin
        {save the frame of data for further analysis}

        setlength(SavedFrameData,PlotPtsPerFrame);

        for i := pstart to pstart + PlotPtsPerFrame-1 do
          savedframedata[i-pstart]:=p^[i]-128;


       Stop;  {then stop}
       statustext.caption:='Stopped - Frame captured';
       BtnOneFrame.Down := false;
       SetButtonstate;
       ShowStored;
      end;
    end //Wavein
end;



{**************** PostError *************}
Procedure TOscfrmMain.PostError(s:string);
{Called by Wavein when error in encountered }
begin
  inc(errcount);
  if errcount<100 then
  begin
    PageControl1.Activepage:=Introsheet;
    memo1.lines.add(s);
    memo1.refresh;
  end
  else
  begin
    showmessage('Possible error count loop, recording stopping');

    if assigned(wavein) then
      Wavein.StopInput;
  end;

  statustext.caption:='Errors - Try again';
end;

{*********************** SetMaxPtsToAvg ************}
Procedure TOscfrmMain.setmaxPtsToAvg;
{set the maximum number of points to average for each plotted point}
{set to ensure that each buffer draws at least one full trace}
{call when bufsize, or xinc changes}
//var
//  exp:integer;
begin

  //plotptsperframe := image1.width div xinc;

{
  if btnDual.Down then
    exp :=2
  else
    exp:=1;

  bufsize    := framesperbuffer*frmOscilloscope1.imgScreen.width*exp;

  PlotPtsPerFrame := (frmOscilloscope1.imgScreen.width div xinc)+50;
 }

  if btnDual.Down then
    framesize := frmOscilloscope1.imgScreen.width*2 {number of input points per frame}
  else
    framesize := frmOscilloscope1.imgScreen.width; {number of input points per frame}

  nbrframes := framesperbuffer {bufsize div framesize}; {we'll draw this many frames from this buffer}
  //if assigned(wavein) then
  //  ppL := hinc*Wavein.ptrWavefmtEx.nsamplespersec*xinc; {pixels per time scale line}

  //if ppl>0 then
   // nbrvlines := trunc(frmOscilloscope1.imgScreen.width/ppL);


  //  nbrvlines := trunc(image1.width/ppL);
end;


{******************* SweepEdtChange *************}
procedure TOscfrmMain.SweepEdtChange(Sender: TObject);
begin
  xinc := SweepUD.position;
  SetMaxPtstoavg;

  ShowScaleValue;

  SetOscState;
end;



{************ FormResize *************}
(*
procedure TfrmMain.FormResize(Sender: TObject);
{Form resized - adjust image width}
begin
  //image1.width:=width-image1.left-20;
  //image1.width := pnlOsc.Width-pnlOsc.BevelWidth*2;  //-image1.left-20;
  //image1.picture.bitmap.width := image1.width;

  bufsize := framesperbuffer*frmOscilloscope1.imgScreen.width;


  //bufsize := framesperbuffer*image1.width;
  setlength(FrameSaveBuf,2*bufsize);  {we'll save two buffers to make sure we
                                       get a full frame after a trigger event}
  {adjust memo1 width also (keep right edge with image right edge),
   otherwise scroll bars can pop up}
  setmaxptstoavg;

  {memo1.width:=image1.left+image1.width-memo1.left;
  statustext.top:=clientheight-statustext.height-2;
  statictext1.top:=statustext.top;
  statictext1.height:=statustext.height;
  statictext1.left:=statustext.width+1;
  statictext1.width:=clientwidth-statictext1.left-2; }
end;
 *)

procedure TOscfrmMain.SaveImage;
{save scope image}
var
  i:integer;
  s:string;
  path:string;
begin
  {Make a new file name}
  i:=0;
  path := extractfilepath(application.exename);

  while (i<9) and fileexists(path+'Oscope'+inttostr(i)+'.bmp') do
    inc(i);

  s:=path+'Oscope'+inttostr(i)+'.bmp';

  if not fileexists(s) then
    with frmOscilloscope1.imgScreen.picture.bitmap do
    begin
      pixelformat := pf24bit;
      savetofile(s);
      posterror('Screen image saved as file '+s);
    end
    else
      posterror('Screen save failed - max of 10 image files exist');
end;


{************** TrigLevelBarChange ************}
procedure TOscfrmMain.TrigLevelBarChange(Sender: TObject);
{Trigger level changed by user, change trigger level display}
{Kind of tricky here, we want reset the trigger level bar, but
   the trigger level change tries to reset the trigger sign radiogroup
   index, and we have to prevent loops where each change to one of the
   controls causes a change to the other, which causes a change to the
   first,... etc.}
begin
  if trigbarchanging then
    Exit;

  if not triggrpchanging then
  begin
    trigbarchanging := True;

    if triglevelbar.position*-1 > 0 then
    begin
      btnTrigerOn.Down := True;
      btnTrigPositiv.Down := True;
      //triggerrGrp.itemindex := 0;
      SetButtonstate;
    end
    else if triglevelbar.position*-1 < 0 then
    begin
      btnTrigerOn.Down := True;
      btnTrigNegativ.Down := True;
      //triggerrGrp.itemindex := 2;
      SetButtonstate;
    end
    else
    begin
      btnTrigPositiv.Down := False;
      btnTrigNegativ.Down := False;
      btnTrigerOn.Down := False;

      SetButtonstate;
    end;

    label4.caption := inttostr(triglevelbar.position*-1);
    trigbarchanging := False;
  end;
end;


{*********** CalibrateBtnClick ***********}
procedure TOscfrmMain.CalibrateBtnClick(Sender: TObject);
{Set flag to cause recalculation  of vertical offset}
begin
  calibrate := true;
end;

{************** StaticText1Click ************}
procedure TOscfrmMain.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;

{************ SpectrumBtnClick *************}
procedure TOscfrmMain.SpectrumBtnClick(Sender: TObject);
var
  i,oldlen,n:integer;
  //,pwr:integer;
  sum:integer;
begin
  {round nbrpoints up to next higher power of 2}
  oldlen:= length(savedframedata);

  if oldlen>0 then
  begin
    n:=2;
    while n<oldlen do
    begin
      n:=n*2;
    end;

    setlength(savedframedata,n);

    for i:=oldlen to n-1 do
      savedframedata[i]:=0;

    with form2 do
    begin
      nbrpoints:=n;
      setlength(XReal,n);
      sum:=0;

      for i:=0 to n-1 do
      begin
        XReal[i]:=savedframedata[i];
        sum:=sum+savedframedata[i];
      end;

      DCOffset:=sum/n;

      if assigned(wavein) then
        form2.samplerate:= Wavein.ptrWavefmtEx^.nsamplespersec;

      form2.showmodal;
    end;
  end;
end;

{*************** RateGrpClick **********}
procedure TOscfrmMain.ChangeSampleRate;
{Sampling rate changed, reset everything}
begin
  if assigned(wavein) then
  if (wavein.recordactive) then
  begin
    wavein.stopinput; {just in case}
    application.processmessages;
    start;
  end {force recalc of paramters}
  else if not singleframe then
    setup
  else
    freeandnil(wavein);
end;

//Dual input
procedure TOscfrmMain.btnDualClick(Sender: TObject);
begin
  if not btnDual.Down then
    OnCh1Box.checked := true;

  singleframe  := false;

  ShowScaleValue;
 // setmaxptstoavg;

  SetButtonstate;
end;

//Trigger on/off
procedure TOscfrmMain.btnTrigerOnClick(Sender: TObject);
begin
  SetButtonstate;
end;

// Input Gain
procedure TOscfrmMain.edtGainCh1Change(Sender: TObject);
begin
  Ch1Gain := upGainCh1.Position;
end;

procedure TOscfrmMain.edtGainCh2Change(Sender: TObject);
begin
  Ch2Gain := upGainCh2.Position;
end;

// Input Y ofset
procedure TOscfrmMain.trOfsCh1Change(Sender: TObject);
begin
  SetOscState;
  ShowStored;
end;

procedure TOscfrmMain.trOfsCh2Change(Sender: TObject);
begin
  SetOscState;
  ShowStored;
end;

// <-- X --> ofset
procedure TOscfrmMain.trStartPosChange(Sender: TObject);
begin
  ShowStored;
end;

// Screen controls
procedure TOscfrmMain.upFocusClick(Sender: TObject; Button: TUDBtnType);
begin
  SetOscState;
  ShowStored;
end;

procedure TOscfrmMain.upBeamLightClick(Sender: TObject; Button: TUDBtnType);
begin
  SetOscState;
  ShowStored;
end;

procedure TOscfrmMain.UpScaleLightChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  SetOscState;
  ShowStored;
end;

//Input sample
procedure TOscfrmMain.sp11025SampleClick(Sender: TObject);
begin
  ChangeSampleRate;
end;

procedure TOscfrmMain.sp22050SampleClick(Sender: TObject);
begin
  ChangeSampleRate;
end;

procedure TOscfrmMain.sp44100SampleClick(Sender: TObject);
begin
  ChangeSampleRate;
end;

//Input on/off
procedure TOscfrmMain.btnCh2OnClick(Sender: TObject);
begin
  SetButtonstate;
  SetOscState;
  ShowStored;
end;

procedure TOscfrmMain.btnCh1OnClick(Sender: TObject);
begin
  SetButtonstate;
  SetOscState;
  ShowStored;
end;

//Input grounded
procedure TOscfrmMain.btnCH1GndClick(Sender: TObject);
begin
  SetOscState;
  ShowStored;
end;

procedure TOscfrmMain.btnCH2GndClick(Sender: TObject);
begin
  SetOscState;
  ShowStored;
end;

// Menu functions-----------------------
procedure TOscfrmMain.menuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TOscfrmMain.menuSaveImage1Click(Sender: TObject);
begin
  SaveImage;
end;

procedure TOscfrmMain.MenuGreenClick(Sender: TObject);
begin
  frmOscilloscope1.ScreenColor := clGreen;
  ShowStored;
end;

procedure TOscfrmMain.menuBlackClick(Sender: TObject);
begin
  frmOscilloscope1.ScreenColor := clBlack;
  ShowStored;
end;

procedure TOscfrmMain.MenuData_TimeClick(Sender: TObject);
begin
  menuData_Time.Checked := not menuData_Time.Checked;
  SetOscState;
  ShowStored;
end;

//Change the expansion of an capure frame
procedure TOscfrmMain.btnExpand1Click(Sender: TObject);
begin
  CenterAdjust;
  trStartPos.Max := 400;
  trStartPos.Min := -400;
  ShowStored;
end;

procedure TOscfrmMain.btnExpand2Click(Sender: TObject);
begin
  CenterAdjust;
  trStartPos.Max := 200;
  trStartPos.Min := -450;
  ShowStored;
end;

procedure TOscfrmMain.btnExpand4Click(Sender: TObject);
begin
  CenterAdjust;
  trStartPos.Max := 100;
  trStartPos.Min := -450;
  ShowStored;
end;

procedure TOscfrmMain.btnExpand8Click(Sender: TObject);
begin
  CenterAdjust;
  trStartPos.Max := 50;
  trStartPos.Min := -470;
  ShowStored;
end;

//Change the gain of an capure frame
{******* btnGain0Click *********}
procedure TOscfrmMain.btnGain0Click(Sender: TObject);
begin
  ShowStored;
end;

{******* btnGain1Click *********}
procedure TOscfrmMain.btnGain1Click(Sender: TObject);
begin
  ShowStored;
end;

{********** btnGain2Click ***********}
procedure TOscfrmMain.btnGain2Click(Sender: TObject);
begin
  ShowStored;
end;

//--------------------------------------------------------------------
{********* SetButtonState ***********}
procedure TOscfrmMain.SetButtonstate;
begin

  btnRun.Enabled := not BtnOneFrame.Down;

  if not btnRun.Down then
    Panel3.Color := clMaroon;

  SpectrumBtn.Enabled := (length(savedframedata)>0)and not btnDual.Down ;

  //BtnOneFrame.Enabled := assigned(wavein) and not wavein.recordactive;
  //fix if wawein is nil
  if not BtnOneFrame.Enabled and not btnRun.Enabled and not assigned(wavein) then
    btnRun.Enabled := true;

  btnDual.Enabled := not btnRun.Down;
  //btnCh1On.Enabled := btnDual.Down;
  if not btnDual.Down then
    btnTriggCh1.Down := True;

  btnTriggCh1.Enabled := btnTrigerOn.Down;
  btnTriggCh2.Enabled := btnTrigerOn.Down and btnDual.Down;
  btnTrigPositiv.Enabled := btnTrigerOn.Down;
  btnTrigNegativ.Enabled := btnTrigerOn.Down;
  btnTriggCh2.Enabled := btnDual.Down;
  grpChannel2.Visible := btnDual.Down;

  frmOscilloscope1.Ch1On := OnCh1Box.checked;
  frmOscilloscope1.Ch2On := OnCh2Box.checked and btnDual.Down;

  btnExpand1.Enabled := singleframe and triggered;
  btnExpand2.Enabled := singleframe and triggered;
  btnExpand4.Enabled := singleframe and triggered;
  btnExpand8.Enabled := singleframe and triggered;

  btnGain0.Enabled := singleframe and triggered;
  btnGain1.Enabled := singleframe and triggered;
  btnGain2.Enabled := singleframe and triggered;

  if not trigbarchanging then {if  a click caused this call, then we can
                              reset the trigger level bar}
  begin
    trigGrpchanging := true;
    with triglevelbar do
    begin
      if btnTrigerOn.Down then
      begin
        if btnTrigPositiv.Down then
          If position < 0 then position:= position
        else
          if position > 0 then position :=-position;
      end
      else
        triglevelbar.position :=0;
    end;
    triggrpchanging := false;
  end;
end;


(*
procedure TfrmMain.SetOscState;
var
  s:string;
  Expand:integer;
begin
  frmOscilloscope1.Ch1Gnd := btnCH1Gnd.Down;
  frmOscilloscope1.Ch2Gnd := btnCH2Gnd.Down;

  frmOscilloscope1.ScaleLight := UpScaleLight.Position;
  frmOscilloscope1.BeamLight  := upBeamLight.Position;
  frmOscilloscope1.Focus      := upFocus.Position;

  frmOscilloscope1.Ch1Ofsett := trOfsCh1.Position;
  frmOscilloscope1.Ch2Ofsett := trOfsCh2.Position;
end;
*)

{********** SetOscState ********}
procedure TOscfrmMain.SetOscState;
begin
  frmOscilloscope1.ScaleLight := UpScaleLight.Position;
  frmOscilloscope1.BeamLight  := upBeamLight.Position;
  frmOscilloscope1.Focus      := upFocus.Position;

  frmOscilloscope1.Ch1On := OnCh1Box.checked;
  frmOscilloscope1.Ch2On := (OnCh2Box.checked and btnDual.Down)
         ; //and  not btnXYmode.Down and not btnAddSignal.Down;
end;


//Draw text at the oscilloscope screen
{********* DoDrawBeamtext ************}
procedure TOscfrmMain.DoDrawBeamText(Sender: Tobject);
var
  s:string;
  Expand:integer;
begin
  if menuData_Time.Checked then
  begin
    frmOscilloscope1.imgScreen.Canvas.Brush.Style := bsClear;
    frmOscilloscope1.imgScreen.Canvas.Font.Color  := clLime;
    frmOscilloscope1.imgScreen.Canvas.Font.Name   := 'Verdana';
    frmOscilloscope1.imgScreen.Canvas.Font.Size   := 7;
    s:= ScaleLbl.Caption;

    if singleframe and triggered then
    begin
      expand := GetExpand;
      if Expand >1 then
        s := s + '   Expand: X' + IntToStr(Expand);
    end;

    frmOscilloscope1.imgScreen.Canvas.TextOut(10,10,s);
  end;
end;

// show captured frame
{******** ShowStored ********}
procedure TOscfrmMain.ShowStored;
var
  myBeamA: array of TPoint;
  myBeamB: array of TPoint;
  Loop:integer;
  Gain :double;
  ofs:integer;
begin
  if singleframe then
  begin
    if btnDual.Down then
    begin
      SetLength(myBeamA,high(BeamA));
      SetLength(myBeamB,high(BeamA));
    end
    else
    begin
      SetLength(myBeamA,high(BeamA));
      SetLength(myBeamB,1);
    end;

    Gain := GetGain;
    StoredExpand := GetExpand;

    //Adjust Y ofset
    if Gain = 0.5 then
      ofs := Trunc(frmOscilloscope1.imgScreen.Height /4)
    else if Gain = 2 then
      ofs := Trunc(frmOscilloscope1.imgScreen.Height/4)*-2
    else
      ofs := 0;

    //ReCalc Beeam
    for Loop:=0 to high(BeamA)-1 do
    begin
      myBeamA[Loop].X := (BeamA[Loop].X +trStartPos.Position) * StoredExpand   ;
      myBeamA[Loop].Y := Trunc(BeamA[Loop].Y *Gain)-StoredCH1Offs + trOfsCh1.Position+ofs;

      if btnDual.Down then
      begin
        myBeamB[Loop].X := (BeamB[Loop].X +trStartPos.Position) * StoredExpand;
        myBeamB[Loop].Y := Trunc(BeamB[Loop].Y*Gain)-StoredCH2Offs + trOfsCh2.Position +ofs ;
      end;
    end;

    //Draw beam
    frmOscilloscope1.BeamData(myBeamA,myBeamB);
  end;
end;

{********* GetExpand *********}
function TOscfrmMain.GetExpand:integer ;
begin
  Result :=0;

  if btnExpand1.Down then
    Result := 1
  else if btnExpand2.Down then
    Result := 2
  else if btnExpand4.Down then
    Result := 4
  else if btnExpand8.Down then
    Result := 8;
end;

{******** GetGain **********}
function TOscfrmMain.GetGain:double ;
begin
  Result :=1;

  if btnGain0.Down then
    Result := 0.5
  else if btnGain1.Down then
    Result := 1
  else if btnGain2.Down then
    Result := 2;
end;

{********** CenterAdjust *********}
procedure TOscfrmMain.CenterAdjust;
var
  NewExpand:integer;
  myPos:integer;
  myCenter:integer;
  myOldCenter:integer;
begin
  NewExpand := GetExpand;
  myPos := trStartPos.Position;
  myCenter := Trunc(frmOscilloscope1.imgScreen.Width/2);
  myOldCenter := (myCenter+ myPos)* StoredExpand;
  trStartPos.Position := trunc(myOldCenter/NewExpand) -  myCenter;
end;


procedure TOscfrmMain.Label12DblClick(Sender: TObject);
begin
  trStartPos.Position := 0;

end;

end.

