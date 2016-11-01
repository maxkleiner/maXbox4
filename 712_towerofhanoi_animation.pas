{
    Copyright (C) 11  Ralph Kokott, Niklas Kopyciok

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version. #locs:1139
    CPU Func by Max - Translate on English

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    adapt to maXbox #sign:Max: MAXBOX10: 03/09/2016 13:16:50 
}

unit towerofUnit1;

interface

{uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, math, ComCtrls, Buttons, jpeg;
  }

type  TTree = array of Record
        Belegt: boolean;
        Size:integer;
      end;

//type
  //TForm1 = class(TForm)
    var
    Image1: TImage;
    Label1: TLabel;
    Edit1: TEdit;
    Button2: TButton;
    ListBox1: TListBox;
    Timer1: TTimer;
    ListBox2: TListBox;
    Button3: TButton;
    ListBox3: TListBox;
    Label2: TLabel;
    TrackBar1: TTrackBar;
    Panel1: TPanel;
    Timer2: TTimer;
    Panel2: TPanel;
    ZielComboBox: TComboBox;
    StatusBar1: TStatusBar;
    AnimBitBtn: TBitBtn;
    Image2: TImage;
    CPULabel: TLabel;
    DauerLabel: TLabel;
    AnimNextBtn: TButton;
    ProgressBar1: TProgressBar;
       procedure Respring();
       procedure BW(Anzahl:integer;links,mitte,rechts:Char);
       procedure Button2Click(Sender: TObject);
       procedure Zeichne(turm,id,pos:integer);
       procedure TForm1Timer1Timer(Sender: TObject);
       procedure TForm1OnCreate(Sender: TObject);
       procedure TForm1Button3Click(Sender: TObject);
       function GetHigh(getarray:Array of Integer):integer;
       function GetHigh2(getarray:Array of Integer):integer;
       function GetHighA:integer;
       function GetHighB:integer;
       function GetHighC:integer;
       procedure TForm1Edit1Change(Sender: TObject);
       procedure TForm1TrackBar1Change(Sender: TObject);
       procedure TForm1Timer2Timer(Sender: TObject);
       procedure TForm1AnimBitBtnClick(Sender: TObject);
       //function GetCPUSpeed: real;
       procedure TForm1AnimNextBtnClick(Sender: TObject);
   

  //private
    { Private-Deklarationen }
  //public
    { Public-Deklarationen }
  //end;

var
  Form1:  TForm; //TForm1;
  i,ia:   integer;
  Aarray: Array of char;
  Barray: Array of char;
  ATurm:  Array[1..30] of Integer;
  BTurm:  Array[1..30] of Integer;
  CTurm:  Array[1..30] of Integer;
  runde:  integer;
  zeit:   integer;
  count:  integer;
  anim:   integer;
  Farbe:array[1..16] of TColor;
  // = (clRed,clBlue,clYellow,clGreen,clMaroon,clNavy,clSilver,clLime);
  CPU:    integer;
  zuege:  integer;

implementation

//{$R *.dfm}





function GetHigh(getarray:Array of Integer):integer;
var j:integer;
begin
   j:=0;
   if (getarray[1]>0) and (getarray[1]<10000) then j:=1;
   if (getarray[2]>0) and (getarray[2]<10000) then j:=2;
   if (getarray[3]>0) and (getarray[3]<10000) then j:=3;
   if (getarray[4]>0) and (getarray[4]<10000) then j:=4;
   result:=j+1;
end;

function GetHigh2(getarray:Array of Integer):integer;
var j:integer;
begin
   j:=0;
   if (getarray[1]>0) and (getarray[1]<10000) then j:=j+1;
   if (getarray[2]>0) and (getarray[2]<10000) then j:=j+1;
   if (getarray[3]>0) and (getarray[3]<10000) then j:=j+1;
   if (getarray[4]>0) and (getarray[4]<10000) then j:=j+1;
   result:=j;
end;


procedure Zeichne(turm,id,pos:integer);
begin
if StrToInt(Edit1.Text)>9 then begin
  if id>8 then Image1.Canvas.Brush.Color:=Farbe[id-8] else
                Image1.Canvas.Brush.Color:=Farbe[id];
  Image1.Canvas.Rectangle(40+(turm-1)*140+(50 div StrToInt(Edit1.Text)*(id-1)),
                        230-(pos-1)*180 div StrToInt(Edit1.Text),
                        140+(turm-1)*140-(50 div StrToInt(Edit1.Text)*(id-1)),
                        230-(pos)*180 div StrToInt(Edit1.Text));
                        end
else
begin
  Image1.Canvas.Brush.Color:=Farbe[id];
  Image1.Canvas.Rectangle(40+(turm-1)*140+(50 div StrToInt(Edit1.Text)*(id-1)),
                        210-(pos-1)*20,
                        140+(turm-1)*140-(50 div StrToInt(Edit1.Text)*(id-1)),
                        230-(pos-1)*20);
end;

  Image1.Canvas.Brush.Color:=clwhite;
end;


procedure Respring();
begin
  Image1.Canvas.Brush.Color:=clwhite;
  Image1.Canvas.Rectangle(-1,-1,form1.clientwidth+1,form1.clientheight+1);
  Image1.Canvas.TextOut(70,240,'Stapel 1');
  Image1.Canvas.MoveTo(40,230);               // waagerechte Linie
  Image1.Canvas.LineTo(140,230);
  Image1.Canvas.MoveTo(90,230);               // senkrechte Linie
  if (StrToIntDef(Edit1.Text,0)<5) then Image1.Canvas.LineTo(90,130) else
  Image1.Canvas.LineTo(90,50);

  Image1.Canvas.TextOut(210,240,'Stapel 2');
  Image1.Canvas.MoveTo(180,230);
  Image1.Canvas.LineTo(280,230);
  Image1.Canvas.MoveTo(230,230);
  if (StrToIntDef(Edit1.Text,0)<5) then Image1.Canvas.LineTo(230,130) else
  Image1.Canvas.LineTo(230,50);

  Image1.Canvas.TextOut(350,240,'Stapel 3');
  Image1.Canvas.MoveTo(320,230);
  Image1.Canvas.LineTo(420,230);
  Image1.Canvas.MoveTo(370,230);
  if (StrToIntDef(Edit1.Text,0)<5) then Image1.Canvas.LineTo(370,130) else
  Image1.Canvas.LineTo(370,50);

end;




procedure BW(Anzahl:integer;links,mitte,rechts:Char);
begin


  //Statusbar1.Panels[0].Text:=' Berechne Zug '+IntToStr(i)+' von '+Label2.Caption;
  if Anzahl = 0 then showmessage('Invalid Input') else  begin
  if Anzahl = 1 then  begin
    ProgressBar1.Position:=ProgressBar1.Position+1;
    Application.ProcessMessages;
    count:=count+1;
    {Form1.}ListBox1.Items.Add(IntToStr(count)+' - '+links+'->'+mitte);
    ia:=ia+1;
    Setlength(Aarray,ia);    SetLength(Barray,ia);
    Aarray[ia-1]:=links;    Barray[ia-1]:=mitte;
  end
  else
    begin
      BW(Anzahl-1,links,rechts,mitte);
      BW(1,links,mitte,rechts);
      BW(Anzahl-1,rechts,mitte,links);
    end;
  end;
end;


procedure Button2Click(Sender: TObject);
var j:integer;
begin
  SetPriorityClass(GetCurrentProcess, NORMAL_PRIORITY_CLASS);
  AnimNextBtn.Visible:=true;
  //Application.ProcessMessages;
  runde:=1;
  anim:=1;
if ZielComboBox.ItemIndex=-1 then showmessage('Please set B or C')
else begin
  ProgressBar1.Visible:=true;
  ProgressBar1.Max:=zuege;
  Statusbar1.Panels[0].Text:=' Calculation running...';
  Application.ProcessMessages;
  Aarray:=[]; //''; //Nil;
  Barray:=[];//Nil;
  for it:= 1 to high(bturm) do bturm[it]:= 0;
  //FillChar(BTurm,SizeOf(BTurm),0);
  //FillChar(CTurm,SizeOf(CTurm),0);
  for it:= 1 to high(cturm) do cturm[it]:= 0;
  
  ListBox1.Clear;
  ia:=1;
  count:=0;
  zeit:=GetTickCount();
  if ZielComboBox.ItemIndex=1 then  BW(StrToIntDef(Edit1.Text,0),'l','r','m');
  if ZielComboBox.ItemIndex=0 then  BW(StrToIntDef(Edit1.Text,0),'l','m','r');
  zeit:=GetTickCount()-zeit;
  if zeit=0 then
  Statusbar1.Panels[0].Text:=' Berechnungsdauer: unter 1 Millisekunde'
  else begin if zeit=1 then
  Statusbar1.Panels[0].Text:=' Berechnungsdauer: 1 Millisekunde'
  else
  Statusbar1.Panels[0].Text:=' Berechnungsdauer: '+IntToStr(zeit)+' Millisekunden';
  end;

end; // ziel ausgewählt ende

i:=1;
while i<StrToIntDef(Edit1.Text,0)+1 do begin
  ATurm[i]:=i;
  i:=i+1;
end;

Respring;

j:=1;
while j<StrToIntDef(Edit1.Text,0)+1 do begin
  if ATurm[j]<>0 then Zeichne(1,ATurm[j],j);
  if BTurm[j]<>0 then Zeichne(2,BTurm[j],j);
  if CTurm[j]<>0 then Zeichne(3,CTurm[j],j);
  j:=j+1;
end;
ProgressBar1.Visible:=false;
ProgressBar1.Position:=0;
end;



procedure TForm1Timer1Timer(Sender: TObject);
var j,r:integer;
begin

anim:=2;
if runde<Length(Aarray) then begin

case Aarray[runde] of
'l': begin
    if BArray[runde]='l' then showmessage('Kernel Error 0x001337CRN'); // nicht möglich

    if BArray[runde]='m' then begin
                              //if GetHighB)=0 then BTurm[1]:=ATurm[GetHighA)] else
                                BTurm[GetHighB+1]:=ATurm[GetHighA];
                                ATurm[GetHighA]:=0;
    end;
    if BArray[runde]='r' then begin
                              //if GetHigh(CTurm)=0 then CTurm[1]:=ATurm[GetHighA] else
                                CTurm[GetHighC+1]:=ATurm[GetHighA];
                                ATurm[GetHighA]:=0;
      end;
     end;
'm': begin
    if BArray[runde]='l' then begin
                               //if GetHigh(ATurm)=0 then ATurm[1]:=BTurm[GetHighB)] else
                                ATurm[GetHighA+1]:=BTurm[GetHighB];
                                BTurm[GetHighB]:=0;
    end;
    if BArray[runde]='m' then showmessage('Kernel Error 0x001337CRN'); // nicht möglich

    if BArray[runde]='r' then begin
                               //if GetHigh(CTurm)-1=0 then CTurm[1]:=BTurm[GetHigh(BTurm)] else
                                CTurm[GetHighC+1]:=BTurm[GetHighB];
                                BTurm[GetHighB]:=0;
    end;

end;
'r': begin
    if BArray[runde]='l' then begin
                               //if GetHigh(ATurm)=0 then ATurm[1]:=CTurm[GetHighB] else
                                ATurm[GetHighA+1]:=CTurm[GetHighC];
                                CTurm[GetHighC]:=0;
    end;
    if BArray[runde]='m' then begin
                               //if GetHigh(BTurm)=0 then ATurm[1]:=CTurm[GetHighB] else
                                BTurm[GetHighB+1]:=CTurm[GetHighC];
                                CTurm[GetHighC]:=0;
    end;
    if BArray[runde]='r' then showmessage('Kernel Error 0x001337CRN'); // nicht möglich

  end;

end;

if AnimBitBtn.Kind<>bkHelp then begin
  AnimBitBtn.Kind:=bkHelp;
  AnimBitBtn.Caption:='Pause';
 end;

Statusbar1.Panels[1].Text:='Step '+IntToStr(runde)+' of '
                     +FloatToStr(Power(2,StrToFloat(Edit1.Text))-1);
if runde = Trunc(Power(2,StrToFloat(Edit1.Text))-1) then begin
  Timer1.Enabled:=false;
  AnimBitBtn.Kind:=bkIgnore;
  AnimBitBtn.Caption:='Animation';
  anim:=1;
 end;
runde:=runde+1;
Respring;

//Debug3
r:=1;
Listbox3.Clear;
Listbox3.Items.Add('ATurm');
while r<5 do begin
Listbox3.Items.Add(IntToStr(r)+' '+IntToStr(ATurm[r]));    r:=r+1; end; r:=1;
Listbox3.Items.Add('BTurm');
while r<5 do begin
Listbox3.Items.Add(IntToStr(r)+' '+IntToStr(BTurm[r]));    r:=r+1; end; r:=1;
Listbox3.Items.Add('CTurm');
while r<5 do begin
Listbox3.Items.Add(IntToStr(r)+' '+IntToStr(CTurm[r]));    r:=r+1; end;

// Aktuelle Posis zeichnen
j:=1;
while j<StrToIntDef(Edit1.Text,0)+1 do begin
if ATurm[j]<>0 then Zeichne(1,ATurm[j],j);
if BTurm[j]<>0 then Zeichne(2,BTurm[j],j);
if CTurm[j]<>0 then Zeichne(3,CTurm[j],j);
j:=j+1;
end;
end;
end;

procedure TForm1OnCreate(Sender: TObject);
begin
  form1.canvas.font.size:= 12;
  form1.canvas.font.color:= clpurple;
   
  form1.Canvas.TextOut(5,5,'maXbox4 Systems proudly presents...');                                 // todo
  Farbe[1]:= clRed; Farbe[2]:= clBlue; Farbe[3]:= clYellow; Farbe[4]:= clGreen;
  Farbe[5]:= clMaroon; Farbe[6]:= clNavy; Farbe[7]:= clSilver; Farbe[8]:= clLime;
  
  // = (clRed,clBlue,clYellow,clGreen,clMaroon,clNavy,clSilver,clLime);
  anim:=0;
  runde:=0;
  //((CPU:=Trunc(GetCPUSpeed);
  CPU:= strtoint(CPUSpeed);
 
  CPULabel.Caption:='CPU: '+inttostr(CPU)+' Mhz';
end;

procedure TForm1Button3Click(Sender: TObject);
begin
if Timer1.Enabled=true then Timer1.Enabled:=false else
   Timer1.Enabled:=true;
Listbox2.Items.Add('A '+IntToStr(GetHighA));
Listbox2.Items.Add('B '+IntToStr(GetHighB));
Listbox2.Items.Add('C '+IntToStr(GetHighC));
end;

function GetHighA:integer;
var j,k:integer;
begin
   j:=0;
   k:=1;
   while k<StrToIntDef(Edit1.Text,0)+1 do begin
   if (ATurm[k]>0) and (ATurm[k]<10000) then j:=j+1;
   k:=k+1;
   end;
   result:=j;
end;

function GetHighB:integer;
var j,k:integer;
begin
   j:=0;
   k:=1;
   while k<StrToIntDef(Edit1.Text,0)+1 do begin
   if (BTurm[k]>0) and (BTurm[k]<10000) then j:=j+1;
   k:=k+1;
   end;
   result:=j;
end;

function GetHighC:integer;
var j,k:integer;
begin
   j:=0;
   k:=1;
   while k<StrToIntDef(Edit1.Text,0)+1 do begin
   if (CTurm[k]>0) and (CTurm[k]<10000) then j:=j+1;
   k:=k+1;
   end;
   result:=j;
end;

const berechnungsk=0.00000007754774789320;

procedure TForm1Edit1Change(Sender: TObject);

var scheiben  :integer;
begin
  scheiben := StrToIntDef(Edit1.Text,0);
  anim:=0;
  if scheiben = 0 then exit;
  if scheiben <= 12 then
   image2.picture.bitmap.LoadFromResourceName(getHINSTANCE,'C'+inttostr(scheiben)); 
  
  if scheiben > 31 then
    begin
      showmessage('Stop Berechnung überschreitet zugewiesen Speicher - Berechnungsdauer von mehreren Tagen');
      exit;
    end;

  if scheiben>0 then
    begin
      zuege:= trunc(Power(2,StrToFloat(Edit1.Text))-1);
      Label2.Caption:='Steps: '+IntToStr(zuege);
      DauerLabel.Caption:='Estimated Time: '+
          FloattoStr(round(zuege*berechnungsk*CPU *1000) / 1000)+' Secs';

    end;
end;



procedure TForm1TrackBar1Change(Sender: TObject);
begin
 if Trackbar1.Position=1 then Timer1.Interval:=2000;
 if Trackbar1.Position=2 then Timer1.Interval:=1100;
 if Trackbar1.Position=3 then Timer1.Interval:=500;
 if Trackbar1.Position=4 then Timer1.Interval:=165;
 if Trackbar1.Position=5 then Timer1.Interval:=80;
end;



procedure TForm1Timer2Timer(Sender: TObject);
begin
 Panel1.Visible:=true;
 Panel2.Visible:=true;
 Timer2.Enabled:=false;
 Image1.Visible:=true;
  form1.canvas.font.size:= 30;
  form1.canvas.font.color:= clred;
   
  form1.Canvas.TextOut(130,30,'Tower of Hanoi 3');                           
end;


procedure TForm1AnimBitBtnClick(Sender: TObject);
var i,j:integer;
begin
if anim=0 then exit;

if anim=1 then begin
  i:=1;
  while i<StrToIntDef(Edit1.Text,0)+1 do begin
    ATurm[i]:=i;
    i:=i+1;
  end;
  Statusbar1.Panels[1].Text:='';

  // Animation
    runde:=1;
  Timer1.Enabled:=true;

  Image1.Canvas.Brush.Color:=clblack;   // 40-140 Grundebene     // 280 = Y Startkoordinate
  Image1.Canvas.Pen.Color:=clblack;

  j:=1;
  while j<5 do begin
    BTurm[j]:=0;
    CTurm[j]:=0;
    j:=j+1;
  end;

  Respring;

  j:=1;
  while j<StrToIntDef(Edit1.Text,0)+1 do begin
   if ATurm[j]<>0 then Zeichne(1,ATurm[j],j);
   if BTurm[j]<>0 then Zeichne(2,BTurm[j],j);
   if CTurm[j]<>0 then Zeichne(3,CTurm[j],j);
    j:=j+1;
  end;
 end; // if anim=1

if anim=2 then begin
  Timer1.Interval:=Timer1.Interval+1;
  Timer1.Enabled:=false;
  anim:=3;
  exit;
end;

if anim=3 then begin
  Timer1.Enabled:=true;
  anim:=2;
  exit;
end;

end;


{function TForm1.GetCPUSpeed: real;

const TimeOfDelay = 100;                                  // Zeit ist variabel (??)
//var TimerHigh, TimerLow: DWORD;
var TimerLow:DWORD;

begin
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(7);
  asm                                // Assembler-Sprache
   dw 310Fh
   mov TimerLow, eax               // TimerLow in Speicher A
  //   mov TimerHigh, edx              // TimerHigh in Speicher D
  end;

  Sleep(TimeOfDelay);
  asm
    dw 310Fh
    sub eax, TimerLow        // subtrahiert
  //    sbb edx, TimerHigh         // SBB : Speicher D - TimerHigh(+Carry-Flag)
    mov TimerLow, eax          // TimerLow := eax		- Speicher A in TimerLow
  //    mov TimerHigh, edx         // TimerHigh := eadx  - Speicher D in TimerHigh
  end;
                              // TimerHigh kann auskommentiert werden -> keine Verwendung
  // wird TimerHigh nicht benutzt, kann die Messung ungenau werden.. eigentlich TLow-THigh/(1000*(Sleep2-Sleep1)
  Result := trunc(TimerLow / (1000.0 * TimeOfDelay));
end;}


procedure TForm1AnimNextBtnClick(Sender: TObject);
var j,r:integer;
begin
if runde<Length(Aarray) then begin

case Aarray[runde] of
'l': begin
    if BArray[runde]='l' then showmessage('Kernel Error 0x001337CRN'); // nicht möglich

    if BArray[runde]='m' then begin
                              //if GetHighB)=0 then BTurm[1]:=ATurm[GetHighA)] else
                                BTurm[GetHighB+1]:=ATurm[GetHighA];
                                ATurm[GetHighA]:=0;
    end;
    if BArray[runde]='r' then begin
                              //if GetHigh(CTurm)=0 then CTurm[1]:=ATurm[GetHighA] else
                                CTurm[GetHighC+1]:=ATurm[GetHighA];
                                ATurm[GetHighA]:=0;
      end;
     end;
'm': begin
    if BArray[runde]='l' then begin
                               //if GetHigh(ATurm)=0 then ATurm[1]:=BTurm[GetHighB)] else
                                ATurm[GetHighA+1]:=BTurm[GetHighB];
                                BTurm[GetHighB]:=0;
    end;
    if BArray[runde]='m' then showmessage('Kernel Error 0x001337CRN'); // nicht möglich

    if BArray[runde]='r' then begin
                               //if GetHigh(CTurm)-1=0 then CTurm[1]:=BTurm[GetHigh(BTurm)] else
                                CTurm[GetHighC+1]:=BTurm[GetHighB];
                                BTurm[GetHighB]:=0;
    end;

end;
'r': begin
    if BArray[runde]='l' then begin
                               //if GetHigh(ATurm)=0 then ATurm[1]:=CTurm[GetHighB] else
                                ATurm[GetHighA+1]:=CTurm[GetHighC];
                                CTurm[GetHighC]:=0;
    end;
    if BArray[runde]='m' then begin
                               //if GetHigh(BTurm)=0 then ATurm[1]:=CTurm[GetHighB] else
                                BTurm[GetHighB+1]:=CTurm[GetHighC];
                                CTurm[GetHighC]:=0;
    end;
    if BArray[runde]='r' then showmessage('Kernel Error 0x001337CRN'); // nicht möglich

  end;

end;

if AnimBitBtn.Kind<>bkHelp then begin
  AnimBitBtn.Kind:=bkHelp;
  AnimBitBtn.Caption:='Pause';
 end;

Statusbar1.Panels[1].Text:='Step '+IntToStr(runde)+' of '+FloatToStr(Power(2,StrToFloat(Edit1.Text))-1);
if runde = Trunc(Power(2,StrToFloat(Edit1.Text))-1) then begin
  Timer1.Enabled:=false;
  AnimBitBtn.Kind:=bkIgnore;
  AnimBitBtn.Caption:='Animation';
  anim:=1;
 end;
runde:=runde+1;
Respring;

//Debug3
r:=1;
Listbox3.Clear;
Listbox3.Items.Add('ATurm');
while r<5 do begin
Listbox3.Items.Add(IntToStr(r)+' '+IntToStr(ATurm[r]));    r:=r+1; end; r:=1;
Listbox3.Items.Add('BTurm');
while r<5 do begin
Listbox3.Items.Add(IntToStr(r)+' '+IntToStr(BTurm[r]));    r:=r+1; end; r:=1;
Listbox3.Items.Add('CTurm');
while r<5 do begin
Listbox3.Items.Add(IntToStr(r)+' '+IntToStr(CTurm[r]));    r:=r+1; end;

// Aktuelle Posis zeichnen
j:=1;
while j<StrToIntDef(Edit1.Text,0)+1 do begin
if ATurm[j]<>0 then Zeichne(1,ATurm[j],j);
if BTurm[j]<>0 then Zeichne(2,BTurm[j],j);
if CTurm[j]<>0 then Zeichne(3,CTurm[j],j);
j:=j+1;
end;
end;

end;

procedure TForm1_Destroy(Sender: TObject);
begin
  if assigned(timer1) then begin
  timer1.enabled:= false;
  timer2.enabled:= false;
  timer1.free;
  timer2.free;
  end;
   writeln('Free and destroy finished');
  
end;

procedure CloseClick(Sender: TObject; var action: TCloseAction);
var i: integer;
begin
   //if MessageDlg('Wanna Leave?',mtConfirmation,[mbYes, mbNo],0)= mrYes then begin
   //form1.Free; //bmp.Free;
   //for i:= 1 to QB+1 do bArr[i].Free;
   action:= caFree;
   TForm1_Destroy(self)
   writeln('Free and Closer test finished');
   //end else
     //Action:= caNone;
end;

procedure SetAForm;
 begin
  form1:= TForm.Create(self);
  with form1 do begin
    Caption:= '********** Tower of Hanoi Template ***********';  
    height:= 550;
    width:= 636;
    Position:= poScreenCenter;
    FormStyle:= fsStayonTop;
    //Color:= clwebGold;
    //keypreview:= true;
    //SetDesignVisible(true);
    //onClose:= @TFrm_closeClick;
    //onPaint:= @TFrm_FormPaint;
    //Canvas.Pen.color:= clBlue;
    //GetControlsAlignment;
    //EnableAutoRange;
    //formstate;
    //ScreenSnap;
    //SnapBuffer;
    Show;
    //showbitmap(GetFormImage);
   // writeln('hasParent: '+booleantoString(hasParent))
    //canvas.brush.bitmap:= getBitmapObject(Exepath+'examples\images\citymax.bmp');
    //Canvas.FillRect(Rect(850,390,600,140));
    //onkeydown:=  @TForm1FormKeyDown;
    //onkeyup:=  @TForm1FormKeyup;
    //onkeypress:=  @TForm1FormKeyPress;
    onclose:= @CloseClick;
   end;
   Image1:= TImage.create(form1)
   with image1 do begin
    parent:= form1
    Left := 20
    Top := 96
    Width := 450
    Height:=   290
    Visible := False
    
  end;
  Image2:= TImage.create(form1)
  with image2 do begin
    parent:= form1
    Left:=   10
    Top := 40
    Width:=   401
    Height := 63
    AutoSize:=   True
    picture.bitmap.LoadFromResourceName(getHINSTANCE,'CASTLE'); 
    //glyph
    //bitmap
   end;
   
    ListBox2:= TListBox.create(form1)
    with listbox2 do begin
    parent:= form1;
    Left := 896
    Top := 336
    Width := 193
    Height := 145
    ItemHeight := 13
    TabOrder := 0
    Visible := False
  end;
   Button3:= TButton.create(form1)
   with button3 do begin
    parent:= form1;
   
    Left := 880
    Top := 24
    Width := 75
    Height := 25
    Caption := 'Timerkill'
    TabOrder := 1
    Visible := False
    OnClick := @TForm1Button3Click
  end;
  ListBox3:= TListBox.create(form1)
   with listbox3 do begin
    parent:= form1;
    Left := 920
    Top := 80
    Width := 169
    Height := 225
    ItemHeight := 13
    TabOrder := 2
    Visible := False
  end;
   Panel1:= TPanel.create(form1)
   with panel1 do begin
    parent:= form1;
   
    Left := 16
    Top := 416
    Width := 369
    Height := 73
    TabOrder := 3
    Visible := False
    end;
     Label1:= TLabel.create(form1)
      with label1 do begin
      parent:= panel1;
   
      Left := 8
      Top := 12
      Width := 98
      Height := 13
      Caption := 'Number of Disks'
    end;
    Label2:= TLabel.create(form1)
     with label2 do begin
      parent:= panel1;
      Left := 16
      Top := 36
      Width := 3
      Height := 13
    end;
    CPULabel:= TLabel.create(form1)
    with cpulabel do begin
      parent:= panel1;
      Left := 272
      Top := 16
      Width := 3
      Height := 13
    end;
    DauerLabel:= TLabel.create(form1)
     with dauerlabel do begin
      parent:= panel1;
      Left := 187
      Top := 48
      Width := 3
      Height := 13
    end;
    Edit1:= TEdit.create(form1)
    with edit1 do begin
    parent:= panel1;
      Left := 111
      Top := 12
      Width := 58
      Height := 21
      TabOrder := 0
      OnChange := @Tform1Edit1Change
    end;
    Button2:= TButton.create(form1)
     with button2 do begin
      parent:= panel1;
      Left := 182
      Top := 8
      Width := 75
      Height := 25
      Caption := 'Compute'
      TabOrder := 1
      OnClick := @Button2Click
    end;
    zielComboBox:= TComboBox.create(form1)
    with zielcombobox do begin
      parent:= panel1;
      Left := 112
      Top := 40
      Width := 57
      Height := 21
      ItemHeight := 13
      TabOrder := 2
      Text := 'Aim'
      Items.add('B')
      Items.add('C')
    end;
  //end
   Panel2:= TPanel.create(form1)
     with panel2 do begin
      parent:= form1;
    Left := 488
    Top := 40
    Width := 110
    Height := 370
    Caption := 'Panel2'
    TabOrder := 4
    Visible := False
    end;
    ListBox1:= TListBox.create(form1)
     with listbox1 do begin
      parent:= panel2;
      Left := 0
      Top := 0
      Width := 109
      Height := 280
      ItemHeight := 13
      TabOrder := 0
    end;
    TrackBar1:= TTrackBar.create(form1)
     with trackbar1 do begin
      parent:= panel2;
      Left := 0
      Top := 315
      Width := 109
      Height := 33
      Max := 5
      Min := 1
      Position := 1
      TabOrder := 1
      OnChange := @Tform1TrackBar1Change
    end;
    AnimBitBtn:= TBitBtn.create(form1)
     with animbitbtn do begin
      parent:= panel2;
      Left := 0
      Top := 285
      Width := 109
      Height := 25
      Caption := 'Animation'
      TabOrder := 2
      OnClick := @tform1AnimBitBtnClick
      Kind := bkIgnore
      Caption := 'Animation'
    
    end;
    AnimNextBtn:= TButton.create(form1)
     with animnextbtn do begin
      parent:= panel2;
      Left := 0
      Top := 350
      Width := 109
      Height := 20
     // Caption := 'N'#228'chster Zug'
     Caption := 'Next Step'
    
      TabOrder := 3
      Visible := False
      OnClick := @tform1AnimNextBtnClick
    end;
  //end
   StatusBar1:= TStatusBar.create(form1)
    with statusbar1 do begin
      parent:= form1;
    Left := 0
    Top := 491
    Width := 590
    Height := 19
    panels.add;
    panels.items[0].width:= 400;
   { Panels := <
      item
        Width := 400
      end
      item
        Alignment := taCenter
        Width := 50
      end> }
    panels.add;
    panels.items[1].alignment:= tacenter;
    panels.items[1].width:= 50;
  end;
  progressBar1:= TProgressBar.create(form1)
   with progressbar1 do begin
      parent:= form1;
    Left := 400
    Top := 464
    Width := 200
    Height := 17
    TabOrder := 6
    Visible := False
  end;
  Timer1:= TTimer.create(form1);
  with timer1 do begin
    Enabled := False
    OnTimer := @tform1Timer1Timer;
    //Left := 512
    //Top := 8
  end;
  Timer2:= TTimer.create(form1)
  with timer2 do begin
    Interval := 500
    OnTimer := @tform1Timer2Timer
    //Left := 544
    //Top := 8
  end; //}

 
  end;
  
  
  function Extract(const Delims : array of string; var S : string; var Matches : TStringList; Remove : boolean) : boolean;
var
  I, J : integer;
  Points : array of integer;
begin
  Result := false;
  if Matches <> nil then Matches.Clear;
  SetLength(Points, length(Delims));
  J := 1;
  for I := 0 to high(Delims) do begin
    J := PosEx(Delims[I], S, J);
    Points[I] := J;
    if J = 0 then
      exit
    else
      inc1(J, length(Delims[I]));
  end;
  for I := 0 to high(Delims)-1 do begin
    J := Points[I] + length(Delims[I]);
    Matches.Add(trim(copy(S, J, Points[I+1]-J)));
  end;
  if Remove then S := copy(S, Points[high(Delims)] + length(Delims[high(Delims)]), length(S));
  Result := true
end;

function CaseOf(const S : string; const Cases : array of string) : integer;
begin
  for Result := 0 to high(Cases) do
    if SameText(S, Cases[Result]) then exit;
  Result := -1;
end;

function FirstDelimiter(const Delimiters, S : string; Offset : integer) : integer;
var
  I : integer;
begin
  for Result := Offset to length(S) do
    for I := 1 to length(Delimiters) do
      if Delimiters[I] = S[Result] then exit;
  Result := 0;
end;

//const
  //cHexChars = ['0'..'9', 'A'..'F', 'a'..'f']; // set of valid hex digits

function StrToJS(const S : string; UseBR : boolean) : string;
var
  I, J : integer;
  BR   : string;
  ase: charset;
begin
  BR := IfThen(UseBR, '<br/>', '\n');
  Result := AnsiReplaceStr(S, '"', '\"');
  Result := AnsiReplaceStr(Result, '^M^J', BR);
  Result := AnsiReplaceStr(Result, '^M', BR);
  Result := AnsiReplaceStr(Result, '^J', BR);
  if (Result <> '') and (Result[1] = #3) then begin // Is RegEx
    delete(Result, 1, 1);
    if Pos('/', Result) <> 1 then Result := '/' + Result + '/';
  end
  else begin
    I := pos('%', Result);
    ase:= StrToCharSet(letters);
  //  isCharInSet(Result[I+1], TCharset(ase));
    writeln(botostr(isCharInSet(Result[I+1], ['a','b','c','i','z'])));
    writeln(botostr(CharInSet(Result[I+1], ['a','b','c','i','z'])));

    if (pos(';', Result) = 0) and (I <> 0) and ((length(Result) > 1) and (I < length(Result)) and CharInSet(Result[I+1], ['0','1','2','3','4','5','6','7','8','9'])) then begin // Has param place holder, ";" disable place holder
    //then begin
      J := FirstDelimiter(' "''[]{}><=!*-+/,', Result, I+2);
      if J = 0 then J := length(Result)+1;
      if J <> (length(Result)+1) then begin
        insert('+"', Result, J);
        Result := Result + '"';
      end;
      if I <> 1 then begin
        insert('"+', Result, I);
        Result := '"' + Result;
      end;
    end
    else
      if (I = 1) and (length(Result) > 1) //and CharInSet(Result[2], ['a'..'z', 'A'..'Z']) then
       
       and CharInSet(Result[2], ['a','b','c','d','i','z']) //then
       then 
        Result := copy(Result, 2, length(Result))
      else
        Result := '"' + Result + '"'
  end;
end;


procedure bitmapPower;
  var mymap: TBitmap;
  begin
    mymap:= TBitmap.Create;
    mymap:= CaptureScreen1(Rect(150,150,600,600));
    with mymap do begin
      saveToFile(exepath+'screenmap.bmp');
      Free;
    end;           
    writeln('filesize bmp '+intToStr(GetFileSize(exepath+'screenmap.bmp')));
    ConvertImage(exepath+'screenmap.bmp',exepath+'screenmap.png');
    writeln('filesize png '+intToStr(GetFileSize(exepath+'screenmap.png')));
    OpenFile(exepath+'screenmap.png'); 
    //CaptureScreenFormat(exepath+'screenmapdirect','.png');
  end;
  

CONST
  n=9;
  
  PROCedure magicorder;
(* Magic squares of odd order *)
VAR
  i,j :INTEGER;
BEGIN (*magic*)
  WRITELN('The square order is: '+itoa(n));
  FOR i:=1 TO n DO
  BEGIN
    FOR j:=1 TO n DO
      WRITE(itoa((i*2-j+n-1) MOD n*n + (i*2+j-2) MOD n+1)+'  ');
    WRITELN('')
  END;
  WRITELN('The magic number is: '+itoa(n*(n*n+1) DIV 2))
END; (*magic*)


  
  var MediaPlayer4: TMediaPlayer;
  
  CONST MEDIAPATH = 'C:\maXbox\maxbox3\work2015\Cygwin\space-invader\astroids';

begin

 //form1.Icon.Data
 SetAForm;
 TForm1OnCreate(Self);
 writeln('cpu speed: '+cpuspeed)    
 zielcombobox.itemindex:= 1;
 edit1.text:= '3';
 
 writeln(bigfact(250))
 writeln(itoa(length(bigfact(250))))
 //writeln(bigpow(250/2.78,250))
 //sterlingsche form
  maxCalcF('((250/e)^250)*SQRT(2*PI*250)')
 
 {MediaPlayer4:= TMediaPlayer.create(form1); 
  mediaplayer4.parent:= form1;
   MediaPlayer4.FileName :=MEDIAPATH+'\sounds\music.wav';
 MediaPlayer4.DeviceType:=dtWaveAudio;
 Mediaplayer4.Open;  }
 
 //writeln('GetDosOut: '+GetDosOutput('java -version','c:\'));
 writeln('GetDosOut: '
            +GetDosOutput('powercfg energy -output c:\maxbox\osenergy.htm','c:\'));
            
  // RunAsAdmin2(hinstance,exepath+'maxbox4.exe',+ 
    //'"C:\Program Files (x86)\maxbox3\examples\116_ping2.txt"');           
  
   // RunAsAdmin2(hinstance,'cmd.exe',+ 
    //'"powercfg energy -output c:\maxbox\osenergy.htm"');           
           

  //RemoveLastJSTerminator
  
  writeln(StrToJS('this %is the 4 string thing',true))
  
  //opendoc('C:\WINDOWS\system32\energy-report.html')
  opendoc('C:\maxbox\enreport.html')
  
  magicorder;
  
  //bitmapPower;
  
end.

//https://www.mathsisfun.com/games/towerofhanoi.html

//max.kleiner.com 64.29.151.221

{

The Robots industry is promising major operational benefits, although no one is quite sure where robots and the Industrial Internet of Things (IIoT) will take manufacturing. IoT represents a closing of the gap between production and IT and is seen as the next big step for automation. 
Lets see some algorithms and safety concepts behind this topic.

}