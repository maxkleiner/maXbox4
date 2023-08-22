unit U_Spectrum4;
{Copyright 2002-2004, Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A simple Oscilloscope using  TWaveIn class.
 More info at http://www.delphiforfun.org/programs/oscilloscope.htm
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  U_FFT, StdCtrls, Buttons, ExtCtrls, ComCtrls, shellAPI;

type
  {Define a version  of TImage with Mouse enter and leave notification.
   This is so we can show and hide the frequency display label as the
   mouse enters and leaves the spectrum image}
  TMyImage=class(TImage)
  protected
    procedure CMMouseEnter(var Msg: TMessage); message CM_MouseEnter;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MouseLeave;
  end;

  TForm2 = class(TForm)
    SaveBothBtn: TButton;
    SaveTimeBtn: TButton;
    SaveFreqBtn: TButton;
    CloseBtn: TBitBtn;
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    FreqLbl: TLabel;
    YTopLbl: TLabel;
    YMidLbl: TLabel;
    YBotLbl: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    DCBox: TCheckBox;
    Image2: TImage;
    procedure FormActivate(Sender: TObject);
    procedure SaveFreqBtnClick(Sender: TObject);
    procedure SaveTimeBtnClick(Sender: TObject);
    procedure SaveBothBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StaticText2Click(Sender: TObject);
    procedure DCBoxClick(Sender: TObject);

  private
    { Private declarations }
  public
    nbrpoints:integer;  {initialize before calling}
    samplerate:integer;  {time domain samples per second}
    DCOffset:float; {Dc Offset of Xreal data at entry time}
    XReal,XImag:TNVector2; {initialize before calling}
    Timedata:TNVector2;
    TimeDataPtr:TNVectorPtr2;
    amps,freqs:TNVector2;
    YOffset:integer;
    Image1: TMyImage;
    
    procedure calcfreqs;
    procedure Results(NumPoints     : integer;
                  which         : Integer;
              var XReal         : TNvectorPtr2;
              var XImag         : TNvectorPtr2;
                  Error         : byte);
    procedure Savedata(Kind:integer);
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

var
  Lsp:integer=2;  {pixels between spectrum lines}


{************ CMMousezEnter ************}
procedure TMyImage.CMMouseEnter(var Msg: TMessage);
begin
  form2.freqlbl.visible:=true;
end;

{************** CMMouseLeave ************}
procedure TMyImage.CMMouseLeave(var Msg: TMessage);
begin
  form2.freqlbl.visible:=false;
end;

{*********** FormCreate ************}
procedure TForm2.FormCreate(Sender: TObject);
begin
  savedialog1.initialdir:=extractfilepath(application.exename);
  yoffset:=20; {Move the spectrum up by this amount}

  {Make a special version of Timage but copy attributes from image2}
  image1:=TMyImage.create(self);
  with image1 do
  begin
    left:=image2.left;
    top:=image2.top;
    height:=image2.height;
    align:=image2.align;
    parent:=image2.parent;
    onmousemove:=imagemousemove;
  end;
  image2.free; {free the prototype image - used only for visual design}
  freqlbl.bringtofront; {Put the frequency lable on top of the image}
end;

{************** Results **************}
procedure TForm2.Results(NumPoints     : integer;
{List data and draw spectrogram }
                  which         : Integer;
              var XReal         : TNvectorPtr2;
              var XImag         : TNvectorPtr2;
                  Error         : byte);

var
  Index,n,w : integer;
  freq,sinpart, cospart, amplitude, radphase,phase:real;
  sqrt2X2:real;
  maxamp, scale:single;
  f100,f100prev:integer;
  r:Trect;
  lblinc:integer;
  s:string;
  sum:real;
  offsety:real;
  f:integer;
begin
  memo1.clear;
  case Error of
    0 : begin
           maxamp:=0;
           memo1.lines.add('   Freq           Amp           Phase');
           if samplerate>44000 then lblinc:=1000
           else if samplerate>22000 then lblinc:=500
           else lblinc:=200;
           sqrt2X2:=2.0*sqrt(2.0);
           setlength(amps,numpoints div 2);
           setlength(freqs,numpoints div 2);
           for Index := 0 to numpoints div 2 - 1 do
           begin
             freq:=index*samplerate/numpoints;
             sinpart:= -ximag^[index]/sqrt2X2;
             cospart:=xreal^[index]/sqrt2X2;
             amplitude:=sqrt(sqr(sinpart) + sqr(cospart));
             amps[index]:=amplitude;
             freqs[index]:=freq;
             if amplitude>maxamp then maxamp:=amplitude;
             If sinpart>0
             then radphase:=arctan(cospart/sinpart)
             else
             If sinpart <0
             then radphase:=arctan(cospart/sinpart)+pi
             else
             begin
               If cospart >0 then radphase := pi/2.0
               else if cospart < 0 then radphase := -pi/2
               else radphase :=0;
             end;
             phase := 180.0/pi*radphase;
             memo1.lines.add(format(' %8.4f    %10.5f    %6.1f',
                  [freq,amplitude,phase]));
           end;
           if maxamp=0 then  memo1.lines.add('Max amplitude was zero, not plottedt ')
           else
           begin
            {max amplitude at 80% of image height}
            scale:=0.8*(image1.height-yoffset)/maxamp;
            //scrollbox1.horzscrollbar.range:=image1.left+numpoints;
            with image1, canvas do
            begin
              width:=Lsp*numpoints div 2;
              picture.bitmap.width:=Lsp*numpoints;
              brush.color:=clBtnface;
              pen.width:=Lsp div 2;
              scrollbox1.horzscrollbar.range:=width;
              fillrect(rect(left,height-yoffset,left+width,height));
              brush.color:=clYellow;
              rectangle(left,top,left+width,top+height-yoffset+1);

              Ytoplbl.caption:=floattostrf(maxamp/0.8,fffixed, 5,2);
              YMidLbl.caption:=floattostrf(maxamp/2,fffixed, 5,2);
              YBotLbl.caption:=floattostrf(0,fffixed, 5,2);
              f100:=0;
              for index:= 0 to numpoints div 2 - 1 do
              begin
                {draw the spectrum line}
                moveto(Lsp*(index+1),height-yoffset);
                lineto(Lsp*(index+1),height-yoffset-trunc(scale*amps[index]));

                {Draw horizontal labels and tick marks}
                f100prev:=f100;
                f100:=trunc(freqs[index]/lblinc{200});
                if (index>1) {no label a start of chart}
                  and (f100prev<f100)then {if f100 value didn't change, then skip labeling}
                begin
                  pen.color:=clred;
                  pen.width:=3;
                  moveto(Lsp*index+1,image1.height-yoffset);
                  lineto(Lsp*index+1,image1.height-yoffset+5);
                  brush.color:=clbtnface;
                  pen.color:=clblack;
                  pen.width:=1;
                  f:=1000*(lblinc*f100 div 1000);
                  if f=lblinc*f100 then
                  begin
                    s:= format('%4.1fK',[f/1000]);
                    w:=textwidth(s);
                    n:=Lsp*index+1-w div 2;
                    {shift the last label left if necessary to keep it on the image}
                    if n+w>image1.width then n:=n-w div 2;
                    textout(n,image1.height-yoffset+6,s);
                  end;
                end;
              end;
            end;
          end;
        end;

    1 : begin
          memo1.lines.add('Too few data points: Numpoints='+inttostr(NumPoints));
        end;

    2 : begin
          memo1.lines.add('The number of data points must be a power of two, numpoints='+inttostr(numpoints));
        end;
  end; { case }
end; { procedure Results }

{************** FormActivate *************}
procedure TForm2.FormActivate(Sender: TObject);
{XReal data has been set before entry, pass a pointer to the data to
 the RealFFT procedure to create the spectrum}
begin
  calcfreqs;
end;


var
  {Header lines for saved files}
  headers:array[1..3] of string =
      ('   Freq         Amplitude   Phase',
       ' Time         Amplitude',
       ' Time         Amplitude     Freq        Amplitude   Phase');

{*************** SaveData *************}
procedure TForm2.Savedata(Kind:integer);
{Common routine to save a file}
var
  f:Textfile;
  i:integer;
  dt:float;
begin
  assignfile(f,savedialog1.filename);
  rewrite(f);
  writeln(f,headers[kind]);
  dt:=1/samplerate;
  for i:=0 to nbrpoints-1 do
  case kind of
    1: writeln(f,memo1.lines[i+1]);
    2: writeln(f,format('%7.5f      %6.0f      ',[(i+1)*dt,timedata[i]]));
    3: writeln(f,format('%7.5f      %6.0f      ',[(i+1)*dt,timedata[i]])
                         + memo1.lines[i+1]);
  end;
  closefile(f);
end;

{************* SaveFreqBtnClick ************}
procedure TForm2.SaveFreqBtnClick(Sender: TObject);
begin
  with Savedialog1  do
  begin
    Title:='Enter file name to save Frequency data';
    if execute then savedata(1);
  end;
end;

{************ SaveTimeBtnClick *********}
procedure TForm2.SaveTimeBtnClick(Sender: TObject);
begin
  with Savedialog1  do
  begin
    Title:='Enter file name to save Time data';
    if execute then savedata(2);
  end;
end;

{************** SaveBothBtnClick **************}
procedure TForm2.SaveBothBtnClick(Sender: TObject);
begin
  with Savedialog1  do
  begin
    Title:='Enter file name to save Time and Frequency ndata';
    if execute then savedata(3);
  end;
end;


{************** ImageMouseMove ***************}
procedure TForm2.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{we use this exit to display frequency and amplitude information based on the
 horizontal position of the mouse.}
var
  n:integer;
begin
  n:=x div LSP;
  if n <=high(freqs) then
  begin
    freqlbl.caption:=format('Freq:%6.1f, Amp:%4.1f',[freqs[n],amps[n]]);
    //{ for debugging} label2.caption:='X:'+inttostr(x)+', Pos: '+ inttostr(scrollbox1.horzscrollbar.position);

    {display label left or right of cursor based on cursor in relation to image edge}
    if x<image1.width-freqlbl.width
    then freqlbl.left:=x+5-scrollbox1.horzscrollbar.position
    else freqlbl.left:=x-5-freqlbl.width-scrollbox1.horzscrollbar.position;
    freqlbl.top:=y-freqlbl.height;
  end;
end;

procedure TForm2.StaticText2Click(Sender: TObject);
begin
     ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;

procedure TForm2.Calcfreqs;
var
  i:integer;
  error:byte;
  xrealptr,XImagPtr:TNVectorPtr2;
  tempreal:TNVector2;
  sum,offsety:real;
begin
  setlength(XImag,nbrpoints);
  xImagPtr:=@XImag;
  Setlength(tempreal,nbrpoints);
  xrealptr:=@tempreal;
  setlength(Timedata,nbrpoints);
  if dcBox.checked then
  begin
    sum:=0;
    for i:= 0 to nbrpoints -1 do sum:=sum+xreal[i];
    offsety:=sum / (nbrpoints - 1);
  end
  else offsety:=0;

  for i:= 0 to nbrpoints-1 do
  begin
    tempreal[i]:=xreal[i]-offsety;
    timedata[i]:=tempreal[i]; {save the time data}
  end;
  RealFFT2(NbrPoints, False, XRealPtr, XImagPtr, Error);
  Results(NbrPoints,0,XRealPtr,XImagPtr,Error); {display results}

end;

procedure TForm2.DCBoxClick(Sender: TObject);
begin
  calcfreqs;
end;

end.
