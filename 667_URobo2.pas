unit URobo2_mX4;

interface

{uses   #sign:Max: MAXBOX10: 12/10/2016 23:17:06 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;   }   //#locs:195

Const
  maxpoints=1000;
  sleepms=20;  {milliseconds (ms) delay between points}

var //#tech:60perf: 0:0:4.279 threads: 8 192.168.56.1 23:17:06 4.2.4.80
  //TForm1 = class(TForm)
    Robo: TShape;
    ResetBtn: TButton;
    StartBtn: TButton;
       procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer);
       procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
         Y: Integer);
       procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
         Shift: TShiftState; X, Y: Integer);
       procedure FormActivate(Sender: TObject);
       procedure ResetBtnClick(Sender: TObject);
       procedure StartBtnClick(Sender: TObject);
       procedure FormPaint(Sender: TObject);
  //private
    { Private declarations }
  //public { Public declarations }
    var Drawing:boolean;
    StartPoint:TPoint;
    saved:array of TPoint;
    count:integer;
    freq:int64;  //end;

var
  Form1: TForm;

implementation

//{$R *.DFM}
//{Uses mmsystem, {to get to queryperformance functions}
  //   math; {to get to max function}

procedure FormActivate(Sender: TObject);
{Called when the form is activated - do initialization stuff}
begin
  drawing:=false;
  setlength(saved,maxpoints); {initialize saved array size}
  count:=0;  {set saved point count to 0}
  form1.doublebuffered:=true; {prevent ficker}
  resetbtnclick(sender);
  {Get timer counts/sec for use in cointrolling speed later}
  queryperformancefrequency(freq);
  freq:=freq div 1000; {convert it to counts per ms}
end;

procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 {Called when user presses the mouse}
begin
  Drawing:=true;
  {Set up for drawing}
  form1.canvas.moveto(x,y);
  form1.canvas.pen.width:= 9;
  form1.canvas.pen.color:=clBlue;
  {increment counter and save the starting point}
  inc(count);
  saved[count]:=point(x,y);
end;

procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
{User moved mouse}
begin
  If drawing then begin
    form1.canvas.lineto(x,y);
    sleep(sleepms);
    inc(count);
    if count>length(saved) then setlength(saved,length(saved)+maxpoints);
    saved[count]:=point(x,y);
  end;
end;

procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{User released the button}
begin
  Drawing:=false;
  Robo.left:=saved[1].x-robo.Width div 2;
  Robo.top:=saved[1].y-Robo.Height div 2;
end;

procedure ResetBtnClick(Sender: TObject);
{Called to reset the track}
begin
  if count>0 then begin{erase the track}
    form1.canvas.pen.color:= form1.color; {Set brush to form color}
    form1.invalidate; {This forces the form to be repainted - only it will be erasing}
    count:=0;
  end;
  {Move the robot back out of the drawing area}
  Robo.left:=8 * form1.width div 10;  {90% across}
  Robo.top:= form1.height div 4;    {1/4 from the top}
end;

procedure StartBtnClick(Sender: TObject);
{User clicked start}
var  i:integer;
  drawtime:integer;
  startcount,stopcount:int64;
begin
  for i:= 2 to count do begin
    {put center of robo on the point}
    Robo.left:=saved[i].x-Robo.width div 2;
    Robo.top:=saved[i].y-Robo.height div 2;
    queryperformanceCounter(startcount);{Get time before we repaint}
    application.processmessages;
    queryPerformanceCounter(stopcount);{Get time after repaint}
    drawtime:=(stopcount-startcount) div freq;  {Compute ms to repaint}
    writeln('test freq ms: '+itoa(drawtime))
    sleep(max(0,sleepms-drawtime));   {wait whatever time is left, if any}
  end;
end;

procedure FormPaint(Sender: TObject);
{Called eveytime anything visual changes on the form}
var i:integer;
begin
  {Redraw the track which got erased when windows erased everything to repaint}
  If count>0 then begin
    form1.canvas.moveto(saved[1].x,saved[1].y);
    for i:=1 to count do form1.canvas.lineto(saved[i].x,saved[i].y);
  end;
end;

procedure loadRoboform;
begin
  Form1:= TForm.create(self)
   Robo:= TShape.create(self)   //cause of resewt in formactivate
   with form1 do begin
     SetBounds(69,73,710,650)
     Caption:= 'mX4: Click & drag to draw path, click Start to make Robo eat it'
     Color := clBlack; //clBtnFace
     Font.Charset := DEFAULT_CHARSET
     Show;
     //OnActivate := @FormActivate
     FormActivate(self)
     OnMouseDown := @FormMouseDown
     OnMouseMove := @FormMouseMove
     OnMouseUp := @FormMouseUp
     OnPaint := @FormPaint;
     PixelsPerInch := 96
     //TextHeight(16)
    end; 
    with robo do begin
       parent:= form1
       setbounds(600,228,50,50)
       Brush.Color := clRed
       Shape:= stCircle 
       Brush.Style:= bsCross;
     end;
     with TBitBtn.create(self) do begin
       parent:= form1          
       setBounds(545,30,120,50)
       glyph.LoadFromRes(HINSTANCE,'TAFTERMINAL'); // CL_MPSTOP');
       font.size:= 11
       Caption := 'Start Robo'
       OnClick := @StartBtnClick
     end;
    with TBitBtn.create(self) do begin
       parent:= form1          
       setBounds(545,90,120,50)
       glyph.LoadFromRes(HINSTANCE,'TASBARCODE'); 
       font.size:= 11
       Caption := 'Reset Robo'
       OnClick := @ResetBtnClick
     end;
  end;


Begin //main
  ProcessMessagesOFF;
  loadRoboform;
  
  {with TStringStream.create('this is string') do begin
    // read('fdjjjd',7)
     read(sr,7)
     writeln(sr)
     Free
   end; } 
   
   //RegSetValueEx

End.

//http://www.themoviespoiler.com/Spoilers/Gravity.html
