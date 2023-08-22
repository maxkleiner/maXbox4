{$A8,B-,C+,D+,E-,F-,G+,H+,J-,K-,L+,M-,N+,O+,P+,R+,I-,Q+,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{Textures v1.0 28.01.2000 by ArrowSoft-VMP}
// some remarks by max

//{$I 'maxCompilerDefines.inc'}

unit Textures;

interface

const
  MYINT1= 2147483647;
  MYINT2= 4294967295;
  MYLONGWORD =4294967295;

type
     TColorRGB = packed record
               r, g, b: BYTE;
               end;
     PColorRGB = ^TColorRGB;

     TRGBList = packed array[0..0] of TColorRGB;
     pRGBList = ^TRGBList;

     TColorRGBA = packed record
               r, g, b, a: BYTE;
               end;
     PColorRGBA = ^TColorRGBA;

     TRGBAList = packed array[0..0] of TColorRGBA;
     PRGBAList = ^TRGBAList;

     TTexture=class(tobject)
      ID, width, height: integer;
      pixels: pRGBlist;
      constructor Load(tID:integer;filename:string);
      destructor Destroy; override;
     end;

     TVoidTexture=class(tobject)
      ID, width, height:integer;
      pixels: pRGBlist;
      constructor create(tid, twidth, theight:integer);
      destructor Destroy; override;
     end;

     TTextureRGBA= class(TTexture)
      pixels: pRGBAlist;
     end;

     TVoidTextureRGBA=class(tobject)
      ID, width, height:integer;
      pixels: pRGBAlist;
      constructor create(tid, twidth, theight:integer);
      destructor Destroy; override;
     end;



implementation
uses dialogs, sysutils, graphics, jpeg, classes;
//classes  of tlist
//windows of exception dialog

var first: boolean = true;
    nulldevice: TextFile;
procedure compiler_testfunction2; forward;

//{$I 'maxCompilerDefines.inc'}

constructor tTexture.Load(tID:integer; filename:string);
var f: file;
    dims: array[0..3] of byte;
    actread:integer;
    fext:string;
    bmp:tbitmap;
    jpg:tjpegimage;
    i,j:integer;
    pixline: pRGBlist;
    r,g,b:byte;

begin
inherited create;

  //if first then Compiler_Testfunction2;
  first:= false;
{for I := 0 to 1234 - 1 do
   dims[2]:= I;  }
if not fileexists(filename) then begin
  messagedlg(filename+' not found',mterror,[mbabort],0);
   halt(1);
   end;
fExt:= uppercase(ExtractFileExt(filename));
ID:=tID;
if fext='.RGBA' then begin
 assign(f,filename);
 {$i-}
 reset(f,4);
 blockread(f,dims,1);
 {$i+}
 if ioresult<>0 then begin
   messagedlg(filename+' not found',mterror,[mbabort],0);
    halt(1);
    end;
 Width:=dims[0]+dims[1]*256; Height:=dims[2]+dims[3]*256;
 getmem(pixels,(filesize(f)-1)*4);
 blockread(f,pixels^,width*height,actread);
 closefile(f);
 end
else
if fext='.RGB' then begin
 assign(f,filename);
 {$i-}
 reset(f,1);
 blockread(f,dims,4);
 {$i+}
 if ioresult<>0 then
  begin messagedlg(filename+' not found',mterror,[mbabort],0);
   halt(1);
 end;
 Width:= dims[0]+dims[1]*256;
 Height:=dims[2]+dims[3]*256;
 getmem(pixels,filesize(f)-4);
 blockread(f,pixels^,width*height*3,actread);
 closefile(f);
 end
else
if fext='.BMP' then begin
 bmp:= TBitmap.Create;
 bmp.HandleType:= bmDIB;
 bmp.PixelFormat:= pf24bit;
 bmp.LoadFromFile(filename);
 Width:=bmp.Width;
 Height:=bmp.Height;
 getmem(pixels,width*height*3);
 for i:= 0 to height-1 do begin
  pixline:=bmp.ScanLine[i];
  {$R-}
  for j:=0 to width-1 do begin
   r:=pixline[j].b;
   g:=pixline[j].g;
   b:=pixline[j].r;
   pixels[i*width+j].r:=r;
   pixels[i*width+j].g:=g;
   pixels[i*width+j].b:=b;
   end;
  //{$R+}
  end;
 bmp.Free;
 end
else
if fext='.JPG' then begin
 // I/O runtime error reset without assign  -------------------
 //{$I 'maxCompilerDefines.inc'}
 {$i-}
  reset(f,1);    //i/o error 102!
 jpg:= tjpegimage.Create;
 jpg.LoadFromFile(filename);
 bmp:= TBitmap.Create;
 bmp.HandleType:=bmDIB;
 bmp.PixelFormat:=pf24bit;
 Width:= jpg.Width;
 Height:= jpg.Height;
 bmp.Width:= Width;
 bmp.Height:= Height;
 bmp.Assign(jpg);
 getmem(pixels,width*height*3);
 try
  for i:= 0 to height-1 do begin
  pixline:= bmp.ScanLine[i];
  // range check error ------------------
  {$R-}
   //try
   for j:= 0 to width-1 do begin
   r:=pixline[j].b;
   g:=pixline[j].g;
   b:=pixline[j].r;

   pixels[i*width+j].r:=r;
   pixels[i*width+j].g:=g;
   pixels[i*width+j].b:=b;
   end;
   //except
     //on ERangeError do
       //messageDlg('runtime not fine', mtError, [mbAbort],0);

   end;
  {$R+}
  //end;
 finally
 bmp.Free;
 jpg.Free;
 closeFile(f)
  end;
 end;
  //testfunction2;
end;

procedure Compiler_Testfunction2;
var perm: array[1..4] of byte;
   //i,k,l,m: byte;
   smallbyte, b1, i: byte;
    bigint_loc: int64;
    mypstring: pchar;
    wint: word;
    //bigint: longint;
    mylist: TList;
    //Zahl: ^Integer;
    intb1: integer;
    intb2: longword;
    intb1longint: longint;
    a,b,c: longword;

begin
perm[1]:= 1;
perm[2]:= 2;
perm[3]:= 4;
perm[4]:= 8;
i:=1;
 // k:=1; l:=1;
 {for i:= 1 to 4 do
    for k:= 1 to 4 do
      for l:= 1 to 4 do}
        //  for m:= 1 to 4 do
           //write(inttostr(perm[i])+inttostr(perm[k])+inttostr(perm[l]))
     //{$R-}
     //b1:= MYINT;
     //invalid floating point   or i/o error  ----------------------
     {$i+}
     {$Q-}

     try
     b1:= 255;
     inc(b1);
     //inc(b1);
     //writeln(inttostr(b1));  // i/o error 105!
     writeln(nulldevice,inttostr(b1));  // i/o error 105!
     {$i-}   // i/o error 103!
     //writeln('to go to sysutils');
            showmessage('from overflow main: ' + inttostr(b1));
           //showmessage(inttostr(i)+inttostr(k)+inttostr(l));
           //+inttostr(perm[l])+
          //end
      //show silent exception
      except
       //on EOverflow do
       //on E: EIntOverflow do begin
        //on E: EInvalidOp do begin
         on E: Exception do begin
             //ShowHelpException2(E);
             //raise;
          //messageDlg('runtime not fine', mtError, [mbAbort],0);
          //LogOnException(NIL, E);
         end;
      end;
       //Syntax Options Tests  -----------------------------------
        //SyntaxShout;
      //---------------------------------------------------------
      //buffer overflow
      {$Q-}  {$OVERFLOWCHECKS ON}
      {$R-}  //range check----------------------------------

      for I := 1 to 10 do begin
        //intb2:= 1 * (MYINT1-30);
      end;
       //MYINT2= 4294967295; intb2=longword
        //intb2:= inc(MYINT2) ;
        //intb2:= 4294967296;
        inc(intb2);
        showmessage('compute overflow range '+inttoStr(intb2));  //with this -->error
      {$Q-}
     { I don't understand how to safely wrap something. This code illustrates two
methods. The first one fails and proceduces an integer overflow and the
second wraps nicely without a warning. Can somebody explain to me what the
difference is and why it does not/does work ?!?}
//werden im ASM-Code keine call@IntOver generiert
//when Q also R!
     {$Q-}
     {$R-}
 a := 4000000000; // longword
 b := 4000000000; // longword
 c := longint(longword(a) + longword(b) ); // integer overflow !
 //c := longint(a) + longint(b); // no integer overflow but range check?

      showmessage('from overflow longint: '+inttostr(c));

        //showmessage(gettitle2);
    //stack overflow recursion checking !
     {$Q+}
     //Astupid;

end;


destructor TTexture.destroy;
begin
freemem(pixels);
inherited destroy;
end;

constructor tvoidtexture.create(tid, twidth, theight:integer);
begin
inherited create;
id:= tid;
width:= twidth;
height:= theight;
getmem(pixels,width*height*3);
end;

destructor tvoidtexture.destroy;
begin
  freemem(pixels);
  inherited destroy;
end;

constructor tvoidtextureRGBA.create(tid, twidth, theight:integer);
begin
  inherited create;
  id:= tid;
  width:= twidth;
  height:=theight;
  getmem(pixels,width*height*4);
end;

destructor tvoidtextureRGBA.destroy;
begin
freemem(pixels);
inherited destroy;
end;

initialization
  //assignFile(nulldevice,'nulldevfile.txt');
  //append(nulldevice)
finalization
  //closeFile(nulldevice)


end.
