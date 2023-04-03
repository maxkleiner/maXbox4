//Welcome to the first article of an introductory series on simple game demos
//for teaching programming using the maXbox Tool and the VCL. 

Program PlayEarth;  //or lostWorld ;(

const RESPATH = 'examples\earthplay\';  //relative to Exe Path!
      BSIZE = 32;
      ANGLE = 5;

var
  Form1: TForm;
  bgroundI, spriteI, paddleI: TImage;
  bgroundRect, spriteRect, paddleRect, worldRect, changePaddleRect: TRect;
  x, y,  xDir, yDir, paddleX, paddleY, paddleCenter, hitcount: integer;
  soundflag, traceflag, autoflag: boolean;
  FGameOver: Boolean;
 
function InitResources: boolean;
var 
  b_bitmap, b_paddle, b_sound, b_icon: string;
begin
  bgroundI:= TImage.Create(self);
  spriteI:= TImage.Create(self);
  paddleI:= TImage.Create(self);
  b_bitmap:= ExePath+RESPATH+'maxworld.bmp';
  b_paddle:= ExePath+RESPATH+'maxpaddle.bmp';
  b_icon:= ExePath+RESPATH+'maxearth.bmp';
  b_sound:= ExePath+RESPATH+'maxbox.mp3';
  //load sound effect
  closeMP3;
  playMP3(b_sound);    
  //bgroundI.Picture.Bitmap.LoadFromFile(b_bitmap);
  bgroundI.Picture.Bitmap.LoadFromresourcename(hinstance, 'maxworld');
  //paddleI.Picture.Bitmap.LoadFromFile(b_paddle);
  paddleI.Picture.Bitmap.LoadFromresourcename(hinstance, 'maxpaddle');
  spriteI.Picture.Bitmap.LoadFromresourcename(hinstance, 'maxearth');
  //backgroundI.picture.bitmap.canvas.Brush.Style:= bsclear; !!
  with Form1.Canvas do begin
    Font.Color:= clRed; 
    Brush.Style:= bsclear;
    Font.Name:= 'Tempus Sans ITC'; 
    Font.Size:= 50;
  end;    
  result:= True;
end;

procedure FormActivate;
begin
  //.left/.top/.right(width)/.bottom(height)
  bgroundRect:= Rect(0,0,Form1.ClientWidth,Form1.ClientHeight) 
  spriteRect:= Rect(0,0,BSIZE,BSIZE);
  //windowState := wsMaximized;
  Form1.Canvas.StretchDraw(bgroundRect, bgroundI.Picture.Bitmap);
  Form1.Canvas.Draw(0, 0, spriteI.Picture.bitmap);   //icon or bitmap
  paddleX:= form1.ClientWidth div 2;
  paddleY:= form1.ClientHeight - 50;
  paddleRect:= Rect(paddleX - paddleI.Width, paddleY,
                    paddleX + paddleI.Width, paddleY + paddleI.Height)
end;

procedure CloseClick(Sender: TObject; var action: TCloseAction);
begin
  //Form1.Close;
  Application.OnIdle:= NIL;
  bgroundI.Free;
  spriteI.Free;
  paddleI.Free;
end;

procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //Animates and moves paddle
  paddleCenter:= X;
  //paddle.Picture.Width = 32
  if(paddleCenter < BSIZE div 2) then  // just first
     paddleCenter:= BSIZE div 2;
  if(paddleCenter > form1.ClientWidth - (BSIZE div 2)) then
     paddleCenter:= form1.ClientWidth - (BSIZE div 2);
end;


procedure IdleLoop(Sender: TObject; var Done: Boolean);
begin
  //keeps loop going
  done:= false;
  //slows down action
  Sleep(1);
  //.left/.top/.right/.bottom
  spriteRect:= Rect(X,Y,X+BSIZE,Y+BSIZE) //spriteRect:= Rect(X,Y,Y+32,Y+32)!!! 
  // move paddle
  Form1.Canvas.Draw(paddleX, paddleY, paddleI.Picture.bitmap); 
  changePaddleRect:= paddleRect;
  if autoflag then
    paddleRect.Left:= x -(BSIZE div 2) //automodus !!
  else
    paddleRect.Left:= paddleCenter - (BSIZE div 2);
  paddleX:= paddleRect.Left;
  paddleRect:= Rect(paddleX, paddleY, paddleX + BSIZE, paddleY + BSIZE)
  // move earth and repaint
  if traceflag then
    Form1.Canvas.Rectangle(x, y, spriterect.right, spriterect.bottom)
  else begin
    Form1.Canvas.Draw(x, y, spriteI.picture.bitmap);
     //bgroundRect:= Rect(0,0,spriterect.right,spriterect.bottom)
     //bgroundRect:= Rect(x-100,y-100,x+100,y+100)
     //form1.Canvas.StretchDraw(bgroundRect, bgroundI.Picture.Bitmap);
     //bgroundrect:= Rect(0,0,form1.clientWidth,form1.clientHeight) 
     //form1.Canvas.StretchDraw(paddlerect, bgroundI.Picture.Bitmap);
    worldRect:= Rect(0,0,Form1.clientWidth div 2, Form1.clientHeight); 
    Form1.Canvas.StretchDraw(worldRect, bgroundI.Picture.Bitmap);
  end;
  //ChangeRectCalcs as Angle
  if (y <= 0) then yDir:= ANGLE;
  if (y >= form1.ClientHeight - 16) then begin
    FGameOver:= true;
    Application.OnIdle:= NIL;
    Form1.canvas.TextOut(40, 470, 'hits :' +inttostr(hitcount)); 
    if (InputBox('You lost World', 'Try Again?', 'Y') = 'Y') then begin
      x:= 0;
      y:= 0;
      hitcount:= 0;
      FormActivate;
      Application.onIdle:= @IdleLoop;
    end else
      Form1.Close;
  end;
  if ((spriteRect.Bottom - 16) >= (paddleRect.Top)) //catch the ball
    and ((spriteRect.Bottom - 16) <= (paddleRect.Top + ANGLE))
    and ((spriteRect.Right) >= (paddleRect.Left))
    and ((spriteRect.Left) <= (paddleRect.Right)) then begin
      yDir:= -ANGLE;
      inc(hitcount)
      if soundflag then
      //PlaySound(pchar(back_sound), SND_ASYNC or SND_FILENAME);
    end;
  if (x <= 0) then xDir:= ANGLE;
  if(x >= Form1.ClientWidth - 16) then
    xDir:= -ANGLE;
  x:= x + xDir;
  y:= y + yDir;
  //PaddleDifference:= changePaddleRect.Left - paddleRect.Left;
  //If Difference < 0 then paddle to the right
  if(changePaddleRect.Left - paddleRect.Left) < 0 then
    changePaddleRect.Right:= paddleRect.Right
  else
    changePaddleRect.Left:= paddleRect.Left;
  Form1.Canvas.TextOut(550, 50, 'Save World 3'); 
  Form1.Canvas.TextOut(40, 470, 'hits: ' +inttostr(hitcount)); 
end;


procedure FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Form1.close;
end;

function FormCreate: boolean;
begin
 result:= false; 
 Form1:= TForm.create(self);
 with Form1 do begin
   //FormStyle:= fsStayOnTop;
   Position:= poScreenCenter;
   caption:='Play Lost World Box';
   color:= clred;
   width:= 1000;
   height:= 600;
   onMouseMove:= @FormMouseMove
   onKeyPress:= @FormKeyPress;
   onClose:= @CloseClick;
   Show
 end;
  if InitResources then  
    if InputBox('Play World', 'Try Again?', 'Y') = 'Y' then begin
      x:= 0;
      y:= 0;
      hitcount:= 0;
      FGameOver:= false;
      soundflag:= true; 
      traceflag:= false; 
      autoflag:= false;
      result:= true;
    end else
      Form1.Close;
end;

// main GAME drive
begin
  if FormCreate then begin
    FormActivate;
    //Assign idle time function
    Application.OnIdle:= @IdleLoop;
  end;
end.


------------------------------------------------------------------------

  //Perform dirty rectangle animation on memory and Form canvas
  {workbmp.Canvas.Draw(x, y, spriteImage.Picture.bitmap);
  workbmp.Canvas.Draw(paddleX, paddleY, paddle.Picture.bitmap);
  //RealizePalette(backgroundCanvas.Handle);
  form1.Canvas.CopyRect(changeRect, workbmp.Canvas, changeRect);
  form1.Canvas.CopyRect(changePaddleRect, workbmp.Canvas, changePaddleRect);}
    //application.invalidaterect
    //form1.canvas.Rectangle(0, 0, form1.Width, form1.Height);
    //form1.repaint


procedure CopyTest;
begin
  spriteI.Canvas.CopyRect(
    Rect(0,0,spriteI.Width-100, spriteI.Height-100),
    form1.Canvas,
    Rect(0,0,paddleI.Width+100, paddleI.Height+100));
end;
You may use CopyRect function for copying part of one canvas to another.


procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Image1.Picture.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Image2.Canvas.CopyRect(
    Rect(0,0,Image2.Width,Image2.Height),
    Image1.Canvas,
    Rect(0,0,Image1.Picture.Width-50,
      Image1.Picture.Height-50));
end;


procedure voidCanvas;
var myrect, myother: TRect;
    mybitmap: TBitmap;
begin
  myRect:= Rect(10,10,150,150);
  MyOther:= Rect(10,11,150,150);
  mybitmap:= TBitmap.create;
  mybitmap.LoadFromFile('mycard.bmp');
  //Form1.Canvas.BrushCopy(MyRect, Bitmap.get(), MyRect, clBlack);
  Form1.Canvas.CopyRect(MyOther, myBitmap.Canvas, MyRect);
end;  

  //Set up workCanvas
  //workdc := CreateCompatibleDC(Canvas.Handle);
  //bmp := CreateCompatibleBitmap(Canvas.Handle, ClientWidth, ClientHeight);
  //SelectObject(workdc, bmp);
  //SelectPalette(workdc, backgroundImage.Picture.Bitmap.Palette, false);
  //workCanvas.Handle := workdc;

 // If SideDiff < 0 the paddle is to the right
  {if(changeRect.Left - spriteRect.Left < 0) then
    changeRect.Right:= spriteRect.Right
  else changeRect.Left:= spriteRect.Left;
  // TopDef:= changeRect.Top - spriteRect.Top;
  // If SideDiff < 0 the paddle is to the Down
  if(changeRect.Top - spriteRect.Top < 0) then
    changeRect.Bottom:= spriteRect.Bottom
   else  changeRect.Top:= spriteRect.Top;} 
 

In this series, we are going to build a simple game to illustrate the various components of a commercial game. We will cover how to create great looking graphics in 3D, how to handle user input, how to add sound to a game, how to create computer opponents using Artificial Intelligence, and how to model real-world physics. In addition we are going to cover how to make your game playable over the network and how to optimize your game for performance. Along the way, I will show you how to apply principles of object-oriented development and, as well, I will share some of my experience in creating well-organized and elegant code. 


My first experience using a computer was in 1981 on a Sinclair ZX Spectrum. The first 5 years of my computing life were spent on nothing but writing and modifying games for the Sinclair and later the Atari, but, what else are you going to do as a teenager? While much has changed in terms of hardware capabilities and available APIs, the properties of a great game have not. 

Games today have become so complex that they require large numbers of developers, graphic artists, testers and managerial overhead to develop. They rival large commercial enterprise application in their complexity and cost many millions of dollars to develop and market. The payback, however, can be enormous and rival Hollywood blockbuster movies in sales – Halo 2 grossed $100M in its first day of availability.   

All successful games have a couple of features in common that made them stand out. 

The main ingredient for a successful game is the game idea. Regardless how cool your graphics are, how good music is, if the idea is lame no one is going to play the game. 

 
Rambo II: "Das war nicht mein Krieg. Ich bin nur hier, um den Dreck wegzuräumen."
Oder wie wir Programmierer zu sagen pflegen: "Das ist nicht mein Code. Ich mache nur die Fehler raus." 