unit uMain_thelift_voice3;

//#sign:breitsch: BREITSCH-BOX: 02/04/2023 23:29:04 
////for open := 1 to frm_lift.shp_door.height do :was a bug  #locs:399
// voice and door control , state machine add  - color control by mX4
//http://www.softwareschule.ch/download/maxbox_starter53.pdf

interface

{uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, shellapi;
    }
    
  {$Define VOICEMODE}
    
type
  Tfrm_lift = TForm;
   var 
    btn_6: TButton;
    btn_5: TButton;
    btn_4: TButton;
    btn_3, btn_2, btn_1: TButton;
    shp_lift: TShape ;
    Shape1, Shape2: TShape; 
    Shape3, Shape4, Shape5, shape6: TShape;
    tmr_liftdown: TTimer;
    tmr_liftup: TTimer;
    lbl1, lbl2: TLabel;
    shp_door: TShape;
    Label1: TLabel;
    abs: TBitStream;

       procedure Tfrm_liftupTimer(Sender: TObject);
       procedure Tfrm_1Click(Sender: TObject);
       procedure Tfrm_liftdownTimer(Sender: TObject);
       procedure Tfrm_Label1Click(Sender: TObject);
    { Private declarations }
  //public
    { Public declarations }
  //end;

var
  frm_lift: Tfrm_lift;

implementation
//{$R *.dfm}

var oldcolor: TShape;

procedure opendoor;
begin
//for open := 1 to frm_lift.shp_door.height do :a bug
  for it:= 1 to {frm_lift.}shp_lift.height-3 do begin
      shp_door.height := shp_door.height - 1;  //-1
      shp_door.brush.color:= clGreen;
      sleep(30); 
      shp_door.Update;
    end;
    oldcolor.brush.color:= clyellow;
   //shp_lift.brush.color:= clWhite; 
end;

procedure closedoor;
begin
  for it:= 1 to shp_lift.height-3 do begin
     shp_door.height := shp_door.height +1;  //+1
     shp_door.brush.color:= clRed;
     sleep(30); //as delay
     shp_door.update;
   end;
   shp_door.color:= clRed;
   //writeln('debug: '+itoa(shp_lift.height))
end;

procedure ChangelightColor(ashape: TShape);
begin
  ashape.brush.color:= clwhite;
  //oldcolor.brush.color:= clgreen;
end;  

procedure liftfloorState(floor:integer; lbl2:Tlabel);
begin
  case floor of
  334 : begin lbl2.caption := '1';
        {$IfDef VOICEMODE}
          voice2('first')
        {$EndIf}
        ChangelightColor(shape2); 
        end;
  270 : begin lbl2.caption := '2';
        {$IfDef VOICEMODE}
          voice2('second') 
        {$EndIf}
        ChangelightColor(shape3); 
        end;
  206 : begin lbl2.caption := '3';
        {$IfDef VOICEMODE}
          voice2('third floor')
        {$EndIf} 
        ChangelightColor(shape4); 
        end;
  142 : begin lbl2.caption := '4'
         ChangelightColor(shape5)
       end;
  78 : lbl2.caption := '5';
  18 : begin lbl2.caption := '6';
       {$IfDef VOICEMODE}
        voice2('6th floor please wait')
       {$EndIf} end;
  end;
  //oldcolor.brush.color:= clgreen;
end;

procedure buttonOnOff (onoff:boolean);
begin
  {frm_lift.}btn_1.Enabled:= onoff;
  btn_2.Enabled := onoff;
  btn_3.Enabled := onoff;
  btn_4.Enabled := onoff;
  btn_5.Enabled := onoff;
  btn_6.Enabled := onoff;
end;


procedure Movelift (Dest : Integer);
begin
  if {frm_lift.}shp_lift.Top = dest then begin
    shp_lift.brush.color:= clyellow;
    exit;
  end;
  buttononoff(false);
  if shp_lift.Top > Dest
    then begin
        tmr_Liftup.Tag:= Dest;
        tmr_liftup.Enabled:= true;
        shp_lift.brush.color:= clBlack;     
      end
    else
  if shp_Lift.Top < Dest
    then begin
        tmr_LiftDown.Tag:= Dest;
        tmr_LiftDown.Enabled:= True;
        shp_lift.brush.color:= clBlack;     
      end;
   shp_lift.brush.color:= clWhite;
   oldcolor.brush.color:= clred;
end;

procedure Tfrm_liftupTimer(Sender: TObject);
begin
  shp_lift.top := shp_lift.top -4;
  shp_door.top := shp_door.Top - 4;
  if shp_lift.top = tmr_liftup.tag
    then begin
        tmr_liftup.enabled := false;
        opendoor;
        buttononoff(true);
        liftfloorState(tmr_liftup.tag, lbl2)
      end;
    //oldcolor.brush.color:= clgreen;  
end;

procedure Tfrm_label1Click(Sender: TObject);
begin
  //ShellExecute(0,'open','http://www.delphi.co.nr/',nil,nil,SW_SHOW);
  openBrowser('http://www.delphi.co.nr')
end;

procedure Tfrm_liftdownTimer (Sender : TObject);
begin
  shp_lift.top := shp_lift.top + 4;
  shp_door.top := shp_door.Top + 4;
  if shp_lift.top = tmr_liftdown.tag then begin
    tmr_Liftdown.enabled := False;
    opendoor;
    buttononoff(true);
    liftfloorState(tmr_liftdown.tag, lbl2)
  end;
end;

procedure Tfrm_1Click(Sender: TObject);
var Destination : Integer;
begin
  if shp_door.height <> shp_lift.height then
    closedoor;
  Destination := 334;
  if Sender = btn_1 then begin Destination := 334; oldcolor:= shape2; end;
  if Sender = btn_2 then begin Destination := 270; oldcolor:= shape3; end;
  if Sender = btn_3 then begin Destination := 206; oldcolor:= shape4; end;
  if Sender = btn_4 then begin Destination := 142; oldcolor:= shape5; end;
  if Sender = btn_5 then Destination := 78;
  if Sender = btn_6 then Destination := 18;
  MoveLift (Destination) ;
 // shp_lift.brush.color:= clyellow;
end;

procedure loadLiftForm;
  begin
  frm_lift:= TForm.create(self);
  with frm_lift do begin
     BorderIcons:= [biSystemMenu, biMinimize]
     BorderStyle:= bsSingle
     Position:= poScreenCenter
     formstyle:= fsstayontop;
     Scaled:= False
     Icon.LoadFromResourceName(HInstance,'NEWREPORT');
     Caption:= 'Elevator - Fahrstuhl des Grauens'
     ClientHeight:= 431
     ClientWidth:= 255
     //Color := clblack; //clBtnFace; 
     Font.Charset:= DEFAULT_CHARSET
     Font.Color:= clWindowText
     Font.Height:= -11
     Font.Name:= 'Tahoma'
     Font.Style:= []
     OldCreateOrder:= False
     PixelsPerInch:= 96
     Show;
   end;
  shp_lift:= TShape.create(self)
  with shp_lift do begin
    parent:= frm_lift;
    setbounds(24,334,34,44)
  end;
  Shape2:= TShape.create(self)
  with shape2 do begin
    parent:= frm_lift;
    SetBounds(8,319,9,9)
  end;
  Shape3:= TShape.create(self)
  with shape3 do begin
    parent:= frm_lift;
    setbounds(8,255,9,9)
    brush.color:= clgreen;
  end ;   //}
  Shape4:= TShape.create(self)
  with shape4 do begin
    parent:= frm_lift;
    setbounds(8,191,9,9)
  end;
  Shape5:= TShape.create(self)
  with shape5 do begin
    parent:= frm_lift;
    Setbounds(8,127,9,9)
   brush.color:= clgreen;   
  end;
  Shape6:= TShape.create(self)
  with shape6 do begin
    parent:= frm_lift;
    setbounds(8, 65,9,9)
  end;
  with TShape.create(self) do begin
    parent:= frm_lift;
    Setbounds(8,384,169,9)
    brush.color:= clblack;  
  end;
  with TShape.create(self) do begin
    parent:= frm_lift;
    Setbounds(8,1,169,9)
    brush.color:= clblue;
  end;
  Shape1:= TShape.create(self)
  with shape1 do begin
    parent:= frm_lift;
    Setbounds(71,319,106,9)
  end;
  with TShape.create(self) do begin
    parent:= frm_lift;
    Setbounds(71,129,106,9)
  end;
  with TShape.create(self) do begin
    parent:= frm_lift;
    Setbounds(71,65,106,9)
  end;
  with TShape.create(self) do begin
    parent:= frm_lift;
    Setbounds(71,191,106,9)
  end;
  with TShape.create(self) do begin
    parent:= frm_lift;
    Setbounds(71,255,106,9)
  end;
  lbl1:= TLabel.create(self)
  with lbl1 do begin
    parent:= frm_lift;
    parentfont:= false;
    Font.Charset := DEFAULT_CHARSET
    Font.Color := clRed
    Setbounds(8,405,68,13)
    Caption:= 'Floor Number:'
  end;
  lbl2:= TLabel.create(self)
  with lbl2 do begin
    parent:= frm_lift;
    font.color:= clred;
    Setbounds(78,405,6,13)
    Caption := '1'
  end;
  shp_door:= TShape.create(self)
  with shp_door do begin
    parent:= frm_lift;
    Setbounds(56,334,9,44)
  end;
  Label1:= TLabel.create(self)
  with label1 do begin
    parent:= frm_lift;
    Setbounds(120, 405, 85,13)
    Cursor := crHandPoint
    Caption := 'maXbox www.delphi.co.nr'
    Font.Charset:= DEFAULT_CHARSET
    Font.Color:= clBlue
    Font.Height:= -11
    Font.Name:= 'Tahoma'
    Font.Style:= []
    ParentFont:= False
    OnClick:= @tfrm_Label1Click
  end;
  btn_6:= TButton.create(self)
  with btn_6 do begin
    parent:= frm_lift;
    Setbounds(104, 16, 65,41)
    Caption:= '6'; TabOrder:= 0
    OnClick:= @tfrm_1Click
  end;
  btn_5:= TButton.create(self)
  with btn_5 do begin
    parent:= frm_lift;
    Setbounds(104,80 ,65,41)
    Caption:= '5'; TabOrder:= 1
    OnClick:= @tfrm_1Click
  end;
  btn_4:= TButton.create(self)
  with btn_4 do begin
    parent:= frm_lift;
    Setbounds(104 ,144,65,41)
    Caption:= '4'; TabOrder:= 2
    OnClick:= @tfrm_1Click
  end;
  btn_3:= TButton.create(self)
  with btn_3 do begin
    parent:= frm_lift;
    setbounds(104, 208,65,41)
    Caption:= '3'; TabOrder:= 3
    OnClick:= @tfrm_1Click
  end;
  btn_2:= TButton.create(self)
  with btn_2 do begin
    parent:= frm_lift;
    Setbounds(104,272,65, 41)
    Caption:= '2'; TabOrder:= 4
    OnClick:= @tfrm_1Click
  end;
  btn_1:= TButton.create(self)
  with btn_1 do begin
    parent:= frm_lift;
    Setbounds(104,334,65, 41)
    Caption:= '1'; TabOrder:= 5
    OnClick:= @tfrm_1Click
  end;
  tmr_liftdown:= TTimer.create(self)
  with tmr_liftdown do begin
    Enabled := False
    Interval:= 20
    OnTimer:= @tfrm_liftdownTimer
  end;
  tmr_liftup:= TTimer.create(self)
  with tmr_liftup do begin
    Enabled:= False
    Interval:= 25
    OnTimer:= @tfrm_liftupTimer
  end;
end;  //frm *)

 
begin //@main
  loadLiftForm;
  //((lbl1.Caption := 'Floor Number:';
  //writeln(itoa(shp_lift.height))
  //state init ---
  Tfrm_1Click(btn_1)
  
 // --- sequence test ---
 { Tfrm_1Click(btn_3);
  delay(3000)
  Tfrm_1Click(btn_6);
  delay(4000)
  Tfrm_1Click(btn_2);
  delay(2000)    }
  
  writeln(gethostName)
  
 {srlist:= TStringlist.create;
  ab:= false;
  LoadDFMFile2Strings('C:\maXbox\examples\mX425010\[SRC]TheLift\uMain.dfm',srlist,ab);
  writeln(srlist.text)
  srlist.free;  //}

End.

// timer switches on and off during simulation !
// script for Tutor 53

//Doc: http://www.softwareschule.ch/download/maxbox_starter53.pdf

(*First we have to clarify the relationship between the object paradigm and real time systems.
Overwhelming complexity is by far the biggest hurdle in most real time software systems. On the other side the structure of real time system tends to persist through time because it reflects the physical entities of the real world. So here's my definition1 of Real Time UML:

Compute events in the real order of their occurrence.

//another definition: the actual time during which something takes place

In a Use case diagram we capture the functional requirement of the system and it’s interaction between the actor the system.

Each elevator has a set of <n> buttons, one for each floor and position. These illuminate when pressed a panel and cause the elevator to visit the corresponding floor. Waiting people is indicating by a blue light inside cabin. The illumination is cancelled when the elevator visits the right floor.

The system has 2 main sensors and 2 actors:

Sensors:

    Door Push
    Button Press

Actors:

    Floor Indicator
    Speaker Information


By “Real-Time UML”, I mean the application of the UML standard to the development of real-time and embedded systems, and focusing attention on those aspects of UML especially relevant to the areas of special concern for such physical systems like heat or speed.

 The door closes automatically after a predefined amount of time. The touch panel above also shows position (up and down) and the waiting people of the elevator at real time!

According to Kopetz, a real time computer system is a computer system in which the correctness of the system behaviour depends not only on the logical results of the computations, but also on the physical instant at which these results are produced.

    *)

