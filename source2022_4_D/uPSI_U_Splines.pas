unit uPSI_U_Splines;
{
Tsplines for rollercoaster y    with a TSpring Class to animate - Tvertex fix

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_U_Splines = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 

{ compile-time registration functions }
procedure SIRegister_TSplines(CL: TPSPascalCompiler);
procedure SIRegister_TBSpline(CL: TPSPascalCompiler);
procedure SIRegister_U_Splines(CL: TPSPascalCompiler);
procedure SIRegister_TSpring(CL: TPSPascalCompiler);
procedure SIRegister_U_SpringMass2(CL: TPSPascalCompiler);
procedure SIRegister_MARSCoreUtils(CL: TPSPascalCompiler);


{ run-time registration functions }
procedure RIRegister_U_Splines_Routines(S: TPSExec);
procedure RIRegister_TSplines(CL: TPSRuntimeClassImporter);
procedure RIRegister_TBSpline(CL: TPSRuntimeClassImporter);
procedure RIRegister_U_Splines(CL: TPSRuntimeClassImporter);
procedure RIRegister_TSpring(CL: TPSRuntimeClassImporter);
procedure RIRegister_U_SpringMass2(CL: TPSRuntimeClassImporter);
procedure RIRegister_MARSCoreUtils_Routines(S: TPSExec);

procedure Register;

function SmartConcat(const AArgs: array of string; const ADelimiter: string = ',';
  const AAvoidDuplicateDelimiter: Boolean = True; const ATrim: Boolean = True;
  const ACaseInsensitive: Boolean = True): string;

implementation


uses
   windows
  ,dialogs
  ,U_Splines, math, ComCtrls, ExtCtrls, Graphics, forms, controls, stdctrls, EncdDecd, Strutils, masks, XSBuiltins,
  ComObj;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_U_Splines]);
end;

type

 Tspringpointarray = array of TPoint;

TSpring=class(tPanel)
    private
      Image:TImage;
    public
      K:single;   {spring constant}
      M:single;   {mass}
      G:single;   {gravity}
      A:single;   {acceleration}
      x:single;   {displacement}
      v:single;   {velocity}
      C:single;   {damping}
      X0:single;  {initial displacement}
      //F0:single;  {initial force}
      V0:single;  {initial velocity}


      XEnd:single; {resting displacement G*M/K}
      InitiallyConstrained:Boolean;
      Timeinc:single;
      Scale:single;
      Stype:integer;  {spring type, 0 - pull only, 1= push/pull}
      delay:integer; {ms wait between frames while animating}
      pts: Tspringpointarray; //array of TPoint; {points drawn, used to erase spring}
      step:integer;  {pixel increment while drawinga spring}
      wraps:integer; {nbr of coils in spring}
      drawColor:TColor;
      constructor create (Aowner:TPanel; r:Trect); //reintroduce;
      procedure drawspring(Len:single);
      procedure erasespring;
      procedure redrawinitial;
      function Setup({newF0,}newV0,newX0,newC,newK,newM, newG, newTimeInc:single;
                      newconstraint:boolean;
                      Nbrloops,newStep,newdelay:integer;
                      newcolor:TColor):boolean;
      procedure animate(form1: TForm; memo2: Tmemo);
      procedure animate2(form1: TForm; memo2: Tmemo; detail: boolean);
      procedure sizechanged(sender:TObject);
      function GetMaxAmp:single;
  end;


  const
  {we'll just use constants for these for now}
  nbrloops=4;   {wiggles in the spring}
  resolution=2; {pixel step when drawing spring}
var
  delayms:integer=10;   {ms delay bewteen frames while animating}

{****************** TSpring.Create *****************}
Constructor TSpring.create(Aowner:TPanel;R:TRect);
begin
  inherited create(Aowner);
  parent:=Aowner;
  color:= Aowner.color;
  left:=r.left;
  top:=r.top;
  width:=r.right-R.left;
  height:=aowner.height-{ r.bottom-}r.top-2;
  doublebuffered:=true;
  borderstyle:=bsNone;
  bevelinner:=bvnone;
  bevelouter:=bvnone;
  onresize:=SizeChanged;
  timeinc:=1;
  image:=TImage.create(self);
end;

{********************** TSpring.DrawSpring ***************}
procedure TSpring.drawspring(Len:single);
{draw a spring an mass image with height Len}
var
  inc:single;
  cyclelength,cyclewidth:integer;
  i,startx,starty:integer;
  halfheight,PixelLen:integer;
begin
  if wraps=0 then exit;
  halfheight:=height div 2;
  pixelLen:=halfheight+trunc(Len*scale);
  cyclelength:=pixelLen div wraps;
  cyclewidth:=width div 4;
  if (step<=0) or (cyclelength<=0)  then exit;
  setlength(pts, pixelLen div step);
  inc:=step*2*pi/cyclelength;   {GDD}
  startx:=width div 2;
  starty:=0;
  image.canvas.moveto(startx,starty);
  image.canvas.pen.color:=drawColor;
  for i := low(pts) to high(pts)-1 do
  with pts[i] do
  begin
    x:=startx+trunc(cyclewidth*sin(i*inc));
    y:=starty+step*i;
    image.canvas.lineto(x,y)
  end;
  {make the final point back in the center of the weight}
  with pts[high(pts)],image,canvas do
  begin
    x:=width div 2;
    y:=pts[high(pts)-1].y;
    lineto(x,y);
    lineto(x,y+2);
    brush.color:=clblue;
    fillrect(rect(2,y+2,width-2,y+width-2));
  end;
end;

{*********************** TSpring.EraseSpring ****************}
procedure TSpring.erasespring;
{with double buffering - fillrect might be faster and not cause flicker}
var
  i:integer;
begin
  if length(pts)=0 then exit;
  with  image.canvas do
  begin
    pen.color:=color;
    moveto(pts[0].x,pts[0].y);
    for i := 1 to high(pts) do
    with pts[i] do lineto(x,y);
    with pts[high(pts)] do
    begin
      lineto(width div 2,y);
      brush.color:=color;
      fillrect( rect(2,y,width-2,y+width-2));
    end;
  end;
end;

{*************** TString.RedrawInitial **********}
procedure TSpring.redrawInitial;
{Draw unconstrained spring position whenever mass, gravity,
 or spring constant changes}
begin
  if not initiallyconstrained then
  begin
    erasespring;
    x:=g*m/k;
    drawspring(x);
  end;
end;


{**************** GetMaxAmp ***********}
function TSpring.getmaxamp:single;
var
  tt,aa,vv,cc,xx:single;
  maxamp:single;
begin
  aa:=a;
  vv:=v0;
  tt:=0;
  If initiallyconstrained then maxamp:=abs(X0+xend)else maxamp:=0;
  xx:=maxamp;
  cc:=c*sqrt(4*k*m);  {scaled damping factor}
  {calculate 1/4 cycle or until motion stops}
  while tt<=0.5{2}*pi/sqrt(k/m){/4} do
  begin
    vv:=vv+aa*tt;
    xx:=xx+vv*tt;
    if xx>maxamp then maxamp:=xx;
    //aa:=G-(cc*vv+k*(abs(xx)-xend))/m;
    if stype=0 then    {for a floppy spring use this}
    begin
      if x>xend then aa:=G-(cc*vv)/m -k*(xx)/m
      else aa:=G-cc*vv/m; {no spring effect when spring is compressed}
    end
    else
    begin
      {For a stiff spring (K acts in both directions}
      aa:=G-(cc*vv+k*(xx))/m;
    end;
    if (abs(vv)<0.01) and (abs(aa)<0.01) then break;
    tt:=tt+0.01;
  end;
  result:=maxamp;
end;


{****************** TSpring.Setup ********************}
function TSpring.Setup(newV0,newX0,newC,newK,newM, newG, newtimeinc:single;
                        newconstraint:boolean;
                        Nbrloops,newStep,newdelay:integer;
                        newcolor:TColor):boolean;
{Set up a case for drawing}
var
  maxamp1:single;
begin
  V0:=newV0;
  X0:=newX0;
  c:=newC;
  K:=newK;
  m:=NewM;
  G:=newG;
  TimeInc:=newTimeInc;
  result:=true;
  if (m<=0) or (K<=0) then
  begin
    result:=false;
    MessageDlg('Mass and Spring constant should be positive.', mtError, [mbOK], 0);
    exit
  end;

  if (c<0) or (c>1) then
  begin
    result:=false;
    MessageDlg('Damping factor range is from 0 to 1', mtError, [mbOK], 0);
    exit
  end;

  if (g<0) then
  begin
    result:=false;
    MessageDlg('Graviy must not be negative.', mtError, [mbOK], 0);
    exit
  end;
  step:=newstep;
  delay:=newdelay;
  Xend:=G*M/K; {where the spring will come to rest realtive to the unweighted spring}
  initiallyconstrained:=newconstraint;
  v:=V0;
  if initiallyconstrained then x:=xend+x0  else x:=xend;
  a:=0;
  maxamp1:=getmaxamp;
  scale:= (0.4*height/maxamp1);  {pixels per spring unit}
  wraps:=nbrloops;
  if length(pts)>0 then erasespring;
  drawcolor:=newcolor;
  drawspring(x);
  application.processmessages;
end;

var tab:char=#09;

{****************** TSpring.Animate *******************}
Procedure TSpring.Animate(form1: TForm; memo2: Tmemo);
{Loop and draw the action}
var i:integer;
    cc:single;
    time:single;
begin
  if initiallyconstrained then
  begin
    erasespring;
    drawspring(x0+xend); {draw the weight with initial displacement}
  end;
  application.processmessages;
  sleep(1000);   {sleep 1 second before starting}
  tag:=0;
  Memo2.Clear;
  memo2.lines.add('Time'+tab+'A'+tab+'V'+tab+'X');
  cc:=c*sqrt(4*k*m);  {scaled damping factor}
  time:=0.0;
  {Continue if weight is not within a pixel of resting position
   or it is still moving or accelerating significantly}
  memo2.lines.add(format('%8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
  while (tag=0) and ((abs(x-xend)>0.1) or (abs(v)>0.01) or (abs(a)>0.01))
  do begin
    {accelerate/decelerate velocity by one time unit's worth}
    v:=v+a*timeinc;
    {change distance for one time unit}
    x:=x+v*timeinc;
    time:=time+timeinc;

    {damping force, cc,  proportional to velocity}
    {spring constant force, K,  proportional to displacement}
    {acceleration determined by gravity, damping, and spring forces}

    if stype=0 then    {for a floppy spring use this}
    begin
      if x>xend then a:=G-(cc*v+k*(x))/m
      else a:=G-cc*v/m; {no spring effect when spring is compressed}
    end
    else
    begin
      {For a stiff spring (K acts in both directions}
      a:=G-(cc*v+k*(x))/m;
    end;
    if (abs(v)>0.5) or (abs(a)>0.5) then
    begin
      with form1, memo2 do
      //if (displaybox.checked) and (lines.count<2000)
      //then lines.add(format('%8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
      erasespring;
      i:=trunc(x*scale); {get pixel length for plotting}
      if height div 2 +i<0 then
      begin  {spring is trying to fly away}
        drawspring(-height div 2); {draw it a top}
        break;                     {and break the loop}
      end;
      drawspring(x);
      sleep(delay);
    end;
    application.ProcessMessages;
  end;
  memo2.lines.add(format('*End* %8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
end;

{****************** TSpring.Animate *******************}
Procedure TSpring.Animate2(form1: TForm; memo2: Tmemo; detail: boolean);
{Loop and draw the action}
var i:integer;
    cc:single;
    time:single;
begin
  if initiallyconstrained then begin
    erasespring;
    drawspring(x0+xend); {draw the weight with initial displacement}
  end;
  application.processmessages;
  sleep(1000);   {sleep 1 second before starting}
  tag:=0;
  Memo2.Clear;
  memo2.lines.add('Time'+tab+'A'+tab+'V'+tab+'X');
  cc:=c*sqrt(4*k*m);  {scaled damping factor}
  time:=0.0;
  {Continue if weight is not within a pixel of resting position
   or it is still moving or accelerating significantly}
  memo2.lines.add(format('%8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
  while (tag=0) and ((abs(x-xend)>0.1) or (abs(v)>0.01) or (abs(a)>0.01))
  do begin
    {accelerate/decelerate velocity by one time unit's worth}
    v:=v+a*timeinc;
    {change distance for one time unit}
    x:=x+v*timeinc;
    time:=time+timeinc;

    {damping force, cc,  proportional to velocity}
    {spring constant force, K,  proportional to displacement}
    {acceleration determined by gravity, damping, and spring forces}

    if stype=0 then    {for a floppy spring use this}
    begin
      if x>xend then a:=G-(cc*v+k*(x))/m
      else a:=G-cc*v/m; {no spring effect when spring is compressed}
    end
    else begin
      {For a stiff spring (K acts in both directions}
      a:=G-(cc*v+k*(x))/m;
    end;
    if (abs(v)>0.5) or (abs(a)>0.5) then begin
      with form1, memo2 do
      if (detail) and (lines.count<2000)
          then lines.add(format('%8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
      erasespring;
      i:=trunc(x*scale); {get pixel length for plotting}
      if height div 2 +i<0 then
      begin  {spring is trying to fly away}
        drawspring(-height div 2); {draw it a top}
        break;                     {and break the loop}
      end;
      drawspring(x);
      sleep(delay);
    end;
    application.ProcessMessages;
  end;
  memo2.lines.add(format('*End* %8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
end;


{**************** TSpring.Sizechanged ***********}
procedure TSpring.sizechanged(sender:Tobject);
{needed when resize is implemented to keep the image
 filling the panel}
begin
  image.free;
  image:=TImage.create(self);
  with image do
  begin
    parent:=self;
    left:=1; top:=1;
    width:=self.width-2;
    height:=self.height-2;
    canvas.brush.color:=color;
    canvas.fillrect(image.clientrect);
  end;
  if wraps>0 then drawspring(0);
end;


procedure SIRegister_TSpring(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'tPanel', 'TSpring') do
  with CL.AddClassN(CL.FindClass('tPanel'),'TSpring') do
  begin
    RegisterProperty('K', 'single', iptrw);
    RegisterProperty('M', 'single', iptrw);
    RegisterProperty('G', 'single', iptrw);
    RegisterProperty('A', 'single', iptrw);
    RegisterProperty('x', 'single', iptrw);
    RegisterProperty('v', 'single', iptrw);
    RegisterProperty('C', 'single', iptrw);
    RegisterProperty('X0', 'single', iptrw);
    RegisterProperty('V0', 'single', iptrw);
    RegisterProperty('XEnd', 'single', iptrw);
    RegisterProperty('InitiallyConstrained', 'Boolean', iptrw);
    RegisterProperty('Timeinc', 'single', iptrw);
    RegisterProperty('Scale', 'single', iptrw);
    RegisterProperty('Stype', 'integer', iptrw);
    RegisterProperty('delay', 'integer', iptrw);
    RegisterProperty('pts', 'Tspringpointarray', iptrw);
    RegisterProperty('step', 'integer', iptrw);
    RegisterProperty('wraps', 'integer', iptrw);
    RegisterProperty('drawColor', 'TColor', iptrw);
    RegisterMethod('Constructor create( Aowner : TPanel; r : Trect)');
    RegisterMethod('Procedure drawspring( Len : single)');
    RegisterMethod('Procedure erasespring');
    RegisterMethod('Procedure redrawinitial');
    RegisterMethod('Function Setup( newV0, newX0, newC, newK, newM, newG, newTimeInc : single; newconstraint : boolean; Nbrloops, newStep, newdelay : integer; newcolor : TColor) : boolean');
    RegisterMethod('Procedure animate(form1: TForm; memo2: Tmemo)');
    RegisterMethod('Procedure animate2(form1: TForm; memo2: Tmemo; detail: boolean)');

    //procedure animate2(form1: TForm; memo2: Tmemo; detail: boolean);
    RegisterMethod('Procedure sizechanged( sender : TObject)');
    RegisterMethod('Function GetMaxAmp : single');
  end;
end;


function StringFallback(const AStrings: array of string; const ADefault: string = ''): string;
var
  LIndex: Integer;
begin
  Result := '';
  for LIndex := 0 to Length(AStrings)-1 do
  begin
    Result := AStrings[LIndex];
    if Result <> '' then
      Break;
  end;
  if Result = '' then
    Result := ADefault;
end;

function StreamToBytes(const ASource: TStream): TBytes;
begin
  SetLength(Result, ASource.Size);
  ASource.Position := 0;
  if ASource.Read(Result, ASource.Size) <> ASource.Size then
    raise Exception.Create('Unable to copy all content to TBytes');
end;

function StreamToBase64(const AStream: TStream): string;
var
  LBase64Stream: TStringStream;
begin
  Assert(Assigned(AStream));

  LBase64Stream := TStringStream.Create('');
  try
    AStream.Position := 0;
    //TNetEncoding.Base64.Encode(AStream, LBase64Stream);
    EncodeStream(AStream, LBase64Stream);
    Result := LBase64Stream.DataString;
  finally
    LBase64Stream.Free;
  end;
end;

procedure Base64ToStream(const ABase64: string; const ADestStream: TStream);
var
  LBase64Stream: TStringStream;
begin
  Assert(Assigned(ADestStream));

  LBase64Stream := TStringStream.Create(ABase64);
  try
    LBase64Stream.Position := 0;
    ADestStream.Size := 0;
   // TNetEncoding.Base64.Decode(LBase64Stream, ADestStream);
    DecodeStream(LBase64Stream, ADestStream);

  finally
    LBase64Stream.Free;
  end;
end;

function IsMask(const AString: string): Boolean;
begin
  Result := ContainsStr(AString, '*') // wildcard
    or ContainsStr(AString, '?') // jolly
    or (ContainsStr(AString, '[') and ContainsStr(AString, ']')); // range
end;

function MatchesMask2(const AString, AMask: string): Boolean;
begin
  Result := Masks.MatchesMask(AString, AMask);
end;

function DateToISO8601(const ADate: TDateTime; AInputIsUTC: Boolean = False): string;
begin
  Result := DateTimeToXMLTime(ADate, not AInputIsUTC);
end;

function ISO8601ToDate(const AISODate: string; AReturnUTC: Boolean = False): TDateTime;
begin
  Result := XMLTimeToDateTime(AISODate, AReturnUTC);
end;

function CreateCompactGuidStr: string;
var
  LIndex: Integer;
  LBytes: TBytes;
  NewGUID: TGUID;
begin
  Result := '';
  //LBytes := TGUID.NewGuid.ToByteArray();
   NewGUID := StringToGUID(CreateClassID);
   LBytes:= TBytes(GuidtoString(NewGuid));
  for LIndex := 0 to Length(LBytes)-1 do
    Result := Result + IntToHex(LBytes[LIndex], 2);
end;

function StringArrayToString(const AArray:array of string; const ADelimiter: string = ','): string;
begin
  Result := SmartConcat(AArray, ADelimiter);
end;

function EnsurePrefix2(const AString, APrefix: string; const AIgnoreCase: Boolean = True): string;
begin
  Result := AString;
  if Result <> '' then
  begin
    if (AIgnoreCase and not StartsText(APrefix, Result))
      or not StartsStr(APrefix, Result) then
      Result := APrefix + Result;
  end;
end;

function EnsureSuffix(const AString, ASuffix: string; const AIgnoreCase: Boolean = True): string;
begin
  Result := AString;
  if Result <> '' then
  begin
    if (AIgnoreCase and not EndsText(ASuffix, Result))
      or not EndsStr(ASuffix, Result) then
      Result := Result + ASuffix;
  end;
end;

function StripPrefix(const APrefix, AString: string): string;
begin
  Result := AString;
  if APrefix <> '' then
    while StartsStr(APrefix, Result) do
      Result := RightStr(Result, Length(Result) - Length(APrefix));
end;

function StripSuffix(const ASuffix, AString: string): string;
begin
  Result := AString;
  if ASuffix <> '' then
    while EndsStr(ASuffix, Result) do
      Result := LeftStr(Result, Length(Result) - Length(ASuffix));
end;


function SmartConcat(const AArgs: array of string; const ADelimiter: string = ',';
  const AAvoidDuplicateDelimiter: Boolean = True; const ATrim: Boolean = True;
  const ACaseInsensitive: Boolean = True): string;
var
  LIndex: Integer;
  LValue: string;
begin
  Result := '';
  for LIndex := 0 to Length(AArgs) - 1 do
  begin
    LValue := AArgs[LIndex];
    if ATrim then
      LValue := Trim(LValue);
    if AAvoidDuplicateDelimiter then
      LValue := StripPrefix(ADelimiter, StripSuffix(ADelimiter, LValue));

    if (Result <> '') and (LValue <> '') then
      Result := Result + ADelimiter;

    Result := Result + LValue;
  end;
end;

function getPython: string;
begin
  result:=
  'import json                              '+#13#10+
  'import http.client as httplib            '+#13#10+
  'connection = httplib.HTTPSConnection("api.parse.com", 443)'+#13#10+
  'connection.connect()                                      '+#13#10+
  'connection.request("GET","api.parse.com/echo")            '+#13#10+
  'print(json.loads(connection.getresponse().read()))        '+#13#10+
  '                                                   ';
end;


function getPython2: string;
begin
 result:=
 '  with TPythonEngine.Create(Nil) do begin '+#13#10+
 '    pythonhome:= ''C:\Users\max\AppData\Local\Programs\Python\Python36-32\'';'+#13#10+
 '    try                                                           '+#13#10+
 '      loadDLL;                                                    '+#13#10+
 '      Println(''Decimal: ''+                                      '+#13#10+
 '            EvalStr(''__import__("decimal").Decimal(0.1)''));     '+#13#10+
 '    except                                                        '+#13#10+
 '      raiseError;                                                 '+#13#10+
 '    finally                                                       '+#13#10+
 '      free;                                                       '+#13#10+
 '    end;                                                          '+#13#10+
 '  end;                                                           '+#13#10+
 '                                                                   ';
end;

function getPython3: string;
begin
 result:=
 '  with TPythonEngine.Create(Nil) do begin                         '+#13#10+
 '    pythonhome:= ''C:\Users\max\AppData\Local\Programs\Python\Python36-32\'';'+#13#10+
 '    try                                                           '+#13#10+
 '      loadDLL;                                                    '+#13#10+
 '      execStr(''import http.client as httplib'');                 '+#13#10+
 '      execStr(''connection=httplib.HTTPSConnection("api.parse.com",443)'');'+#13#10+
 '      execStr(''connection.connect()'');                          '+#13#10+
 '      execStr(''connection.request("GET","api.parse.com/echo")'');'+#13#10+
 '      println(evalStr(''connection.getresponse().read()''));      '+#13#10+
 '    except                                                        '+#13#10+
 '      raiseError;                                                 '+#13#10+
 '    finally                                                       '+#13#10+
 '      free;                                                       '+#13#10+
 '    end;                                                          '+#13#10+
 '  end;                                                            '+#13#10+
 '                                                                   ';
end;

procedure CopyStream2(ASourceStream, ADestStream: TStream;
  AOverWriteDest: Boolean = True; AThenResetDestPosition: Boolean = True);
begin
  if AOverWriteDest then
    ADestStream.Size := 0;
  ADestStream.CopyFrom(ASourceStream, 0);
  if AThenResetDestPosition then
    ADestStream.Position := 0;
end;

// 16 functions


(*----------------------------------------------------------------------------*)
procedure SIRegister_U_SpringMass2(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('Tspringpointarray', 'array of TPoint');
  SIRegister_TSpring(CL);
  //7/SIRegister_TForm1(CL);
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TSplines(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TSplines') do
  with CL.AddClassN(CL.FindClass('TObject'),'TSplines') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure AddSpline( BSpline : TBSpline)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure InsertSpline( Pos : Integer; BSpline : TBSpline)');
    RegisterMethod('Procedure DeleteSpline( BSpline : TBSpline)');
    RegisterMethod('Function GetSplineNr( Nr : Word) : TBSpline');
    RegisterProperty('NumberOfSplines', 'word', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TBSpline(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TBSpline') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TBSpline') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    //RegisterMethod('Procedure Free2;');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure PhantomPoints');
    RegisterMethod('Procedure Interpolate');
    RegisterMethod('Function Value( Parameter : Single) : TSplineVertex');
    RegisterMethod('Function Value2( Parameter : Single) : TVertex');
    RegisterMethod('Procedure AddVertex( Vertex : TSplineVertex)');
    RegisterMethod('Procedure AddVertex2( Vertex : TVertex)');
    RegisterMethod('Procedure InsertVertex( Pos : Integer; Vertex : TSplineVertex)');
    RegisterMethod('Procedure InsertVertex2( Pos : Integer; Vertex : TVertex)');

    RegisterMethod('Procedure DeleteVertex( VertexNr : word)');
    RegisterMethod('Procedure ChangeVertex( VertexNr : word; X, Y : Single)');
    RegisterMethod('Function NumberOfVertices : word');
    RegisterMethod('Function VertexIsKnuckle( var Nr : integer) : boolean');
    RegisterMethod('Procedure KnuckleOn( Nr : integer)');
    RegisterMethod('Procedure KnuckleOff( Nr : integer)');
    RegisterMethod('Function VertexNr( Nr : integer) : TSplineVertex');
    RegisterMethod('Function VertexNr2( Nr : integer) : TVertex');

    RegisterMethod('Procedure SaveToStream( st : TStream)');
    RegisterMethod('Procedure LoadFromStream( st : TStream)');
    RegisterProperty('Interpolated', 'boolean', iptr);
  end;
end;

procedure SIRegister_MARSCoreUtils(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Function CreateCompactGuidStr : string');
 //CL.AddDelphiFunction('Function BooleanToTJSON( AValue : Boolean) : TJSONValue');
 CL.AddDelphiFunction('Function SmartConcat( const AArgs : array of string; const ADelimiter : string; const AAvoidDuplicateDelimiter : Boolean; const ATrim : Boolean; const ACaseInsensitive : Boolean) : string');
 CL.AddDelphiFunction('Function EnsurePrefix2( const AString, APrefix : string; const AIgnoreCase : Boolean) : string');
 CL.AddDelphiFunction('Function EnsureSuffix( const AString, ASuffix : string; const AIgnoreCase : Boolean) : string');
 CL.AddDelphiFunction('Function StringArrayToString( const AArray : array of string; const ADelimiter : string) : string');
 //CL.AddDelphiFunction('Function StreamToJSONValue( const AStream : TStream; const AEncoding : TEncoding) : TJSONValue');
 //CL.AddDelphiFunction('Procedure JSONValueToStream( const AValue : TJSONValue; const ADestStream : TStream; const AEncoding : TEncoding)');
 //CL.AddDelphiFunction('Function StreamToString( const AStream : TStream; const AEncoding : TEncoding) : string');
 //CL.AddDelphiFunction('Procedure StringToStream( const AStream : TStream; const AString : string; const AEncoding : TEncoding)');
 CL.AddDelphiFunction('Procedure CopyStream2( ASourceStream, ADestStream : TStream; AOverWriteDest : Boolean; AThenResetDestPosition : Boolean)');
 CL.AddDelphiFunction('Function DateToISO8601( const ADate : TDateTime; AInputIsUTC : Boolean) : string');
 CL.AddDelphiFunction('Function ISO8601ToDate( const AISODate : string; AReturnUTC : Boolean) : TDateTime');
 //CL.AddDelphiFunction('Function DateToJSON( const ADate : TDateTime) : string;');
 //CL.AddDelphiFunction('Function DateToJSON1( const ADate : TDateTime; const AOptions : TMARSJSONSerializationOptions) : string;');
 //CL.AddDelphiFunction('Function JSONToDate( const ADate : string; const ADefault : TDateTime) : TDateTime;');
 //CL.AddDelphiFunction('Function JSONToDate3( const ADate : string; const AOptions : TMARSJSONSerializationOptions; const ADefault : TDateTime) : TDateTime;');
 CL.AddDelphiFunction('Function IsMask( const AString : string) : Boolean');
 CL.AddDelphiFunction('Function MatchesMask2( const AString, AMask : string) : Boolean');
 //CL.AddDelphiFunction('Function GuessTValueFromString( const AString : string) : TValue;');
 //CL.AddDelphiFunction('Function GuessTValueFromString5( const AString : string; const AOptions : TMARSJSONSerializationOptions) : TValue;');
 //CL.AddDelphiFunction('Function TValueToString( const AValue : TValue; const ARecursion : Integer) : string');
 //CL.AddDelphiFunction('Procedure ZipStream( const ASource : TStream; const ADest : TStream; const WindowBits : Integer)');
 //CL.AddDelphiFunction('Procedure UnzipStream( const ASource : TStream; const ADest : TStream; const WindowBits : Integer)');
 CL.AddDelphiFunction('Function StreamToBase64( const AStream : TStream) : string');
 CL.AddDelphiFunction('Procedure Base64ToStream( const ABase64 : string; const ADestStream : TStream)');
 CL.AddDelphiFunction('Function StreamToBytes( const ASource : TStream) : TBytes');
 //CL.AddDelphiFunction('Function GetEncodingName( const AEncoding : TEncoding) : string');
 CL.AddDelphiFunction('function StringFallback(const AStrings: array of string; const ADefault: string): string;');
 CL.AddDelphiFunction('function StripPrefix(const APrefix, AString: string): string;');
 CL.AddDelphiFunction('function StripSuffix(const ASuffix, AString: string): string;');
 CL.AddDelphiFunction('function getPython: string;');
 CL.AddDelphiFunction('function getPython2: string;');
 CL.AddDelphiFunction('function getPython3: string;');

end;


(*----------------------------------------------------------------------------*)
procedure SIRegister_U_Splines(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('MaxNoVertices','LongInt').SetInt( 100);
  CL.AddTypeS('TSplineVertex', 'record X : Single; Y : single; end');
  CL.AddTypeS('TSplineRow', 'array of TSplineVertex');
  SIRegister_TBSpline(CL);
  SIRegister_TSplines(CL);
 //CL.AddDelphiFunction('Procedure Register');
 SIRegister_U_SpringMass2(CL);
 SIRegister_MARSCoreUtils(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TSplinesNumberOfSplines_R(Self: TSplines; var T: word);
begin T := Self.NumberOfSplines; end;

(*----------------------------------------------------------------------------*)
procedure TBSplineInterpolated_R(Self: TBSpline; var T: boolean);
begin T := Self.Interpolated; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_U_Splines_Routines(S: TPSExec);
begin
// S.RegisterDelphiFunction(@Register, 'Register', cdRegister);
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSplines(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSplines) do begin
    RegisterConstructor(@TSplines.Create, 'Create');
    RegisterMethod(@TSplines.Destroy, 'Free');
    RegisterMethod(@TSplines.AddSpline, 'AddSpline');
    RegisterMethod(@TSplines.Clear, 'Clear');
    RegisterMethod(@TSplines.InsertSpline, 'InsertSpline');
    RegisterMethod(@TSplines.DeleteSpline, 'DeleteSpline');
    RegisterMethod(@TSplines.GetSplineNr, 'GetSplineNr');
    RegisterPropertyHelper(@TSplinesNumberOfSplines_R,nil,'NumberOfSplines');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TBSpline(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TBSpline) do
  begin
    RegisterConstructor(@TBSpline.Create, 'Create');
    RegisterMethod(@TBSpline.Free, 'Free');
    RegisterMethod(@TBSpline.Clear, 'Clear');
    RegisterMethod(@TBSpline.PhantomPoints, 'PhantomPoints');
    RegisterMethod(@TBSpline.Interpolate, 'Interpolate');
    RegisterMethod(@TBSpline.Value, 'Value');
    RegisterMethod(@TBSpline.Value, 'Value2');
    RegisterMethod(@TBSpline.AddVertex, 'AddVertex2');
    RegisterMethod(@TBSpline.InsertVertex, 'InsertVertex2');

    RegisterMethod(@TBSpline.AddVertex, 'AddVertex');
    RegisterMethod(@TBSpline.InsertVertex, 'InsertVertex');
    RegisterMethod(@TBSpline.DeleteVertex, 'DeleteVertex');
    RegisterMethod(@TBSpline.ChangeVertex, 'ChangeVertex');
    RegisterMethod(@TBSpline.NumberOfVertices, 'NumberOfVertices');
    RegisterMethod(@TBSpline.VertexIsKnuckle, 'VertexIsKnuckle');
    RegisterMethod(@TBSpline.KnuckleOn, 'KnuckleOn');
    RegisterMethod(@TBSpline.KnuckleOff, 'KnuckleOff');
    RegisterMethod(@TBSpline.VertexNr, 'VertexNr');
    RegisterMethod(@TBSpline.VertexNr, 'VertexNr2');
    RegisterMethod(@TBSpline.SaveToStream, 'SaveToStream');
    RegisterMethod(@TBSpline.LoadFromStream, 'LoadFromStream');
    RegisterPropertyHelper(@TBSplineInterpolated_R,nil,'Interpolated');
  end;
end;

procedure RIRegister_MARSCoreUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CreateCompactGuidStr, 'CreateCompactGuidStr', cdRegister);
 S.RegisterDelphiFunction(@SmartConcat, 'SmartConcat', cdRegister);
 S.RegisterDelphiFunction(@EnsurePrefix2, 'EnsurePrefix2', cdRegister);
 S.RegisterDelphiFunction(@EnsureSuffix, 'EnsureSuffix', cdRegister);
 S.RegisterDelphiFunction(@StringArrayToString, 'StringArrayToString', cdRegister);
 S.RegisterDelphiFunction(@CopyStream2, 'CopyStream2', cdRegister);
 S.RegisterDelphiFunction(@DateToISO8601, 'DateToISO8601', cdRegister);
 S.RegisterDelphiFunction(@ISO8601ToDate, 'ISO8601ToDate', cdRegister);
 S.RegisterDelphiFunction(@IsMask, 'IsMask', cdRegister);
 S.RegisterDelphiFunction(@MatchesMask2, 'MatchesMask2', cdRegister);
 S.RegisterDelphiFunction(@StreamToBase64, 'StreamToBase64', cdRegister);
 S.RegisterDelphiFunction(@Base64ToStream, 'Base64ToStream', cdRegister);
 S.RegisterDelphiFunction(@StreamToBytes, 'StreamToBytes', cdRegister);
 //S.RegisterDelphiFunction(@GetEncodingName, 'GetEncodingName', cdRegister);
  S.RegisterDelphiFunction(@StringFallback, 'StringFallback', cdRegister);
  S.RegisterDelphiFunction(@StripPrefix, 'StripPrefix', cdRegister);
  S.RegisterDelphiFunction(@StripSuffix, 'StripSuffix', cdRegister);
  S.RegisterDelphiFunction(@getPython, 'getPython', cdRegister);
  S.RegisterDelphiFunction(@getPython2, 'getPython2', cdRegister);
  S.RegisterDelphiFunction(@getPython3, 'getPython3', cdRegister);
end;


(*----------------------------------------------------------------------------*)
procedure TSpringdrawColor_W(Self: TSpring; const T: TColor);
Begin Self.drawColor := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringdrawColor_R(Self: TSpring; var T: TColor);
Begin T := Self.drawColor; end;

(*----------------------------------------------------------------------------*)
procedure TSpringwraps_W(Self: TSpring; const T: integer);
Begin Self.wraps := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringwraps_R(Self: TSpring; var T: integer);
Begin T := Self.wraps; end;

(*----------------------------------------------------------------------------*)
procedure TSpringstep_W(Self: TSpring; const T: integer);
Begin Self.step := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringstep_R(Self: TSpring; var T: integer);
Begin T := Self.step; end;

(*----------------------------------------------------------------------------*)
procedure TSpringpts_W(Self: TSpring; const T: Tspringpointarray);
Begin Self.pts := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringpts_R(Self: TSpring; var T: Tspringpointarray);
Begin T := Self.pts; end;

(*----------------------------------------------------------------------------*)
procedure TSpringdelay_W(Self: TSpring; const T: integer);
Begin Self.delay := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringdelay_R(Self: TSpring; var T: integer);
Begin T := Self.delay; end;

(*----------------------------------------------------------------------------*)
procedure TSpringStype_W(Self: TSpring; const T: integer);
Begin Self.Stype := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringStype_R(Self: TSpring; var T: integer);
Begin T := Self.Stype; end;

(*----------------------------------------------------------------------------*)
procedure TSpringScale_W(Self: TSpring; const T: single);
Begin Self.Scale := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringScale_R(Self: TSpring; var T: single);
Begin T := Self.Scale; end;

(*----------------------------------------------------------------------------*)
procedure TSpringTimeinc_W(Self: TSpring; const T: single);
Begin Self.Timeinc := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringTimeinc_R(Self: TSpring; var T: single);
Begin T := Self.Timeinc; end;

(*----------------------------------------------------------------------------*)
procedure TSpringInitiallyConstrained_W(Self: TSpring; const T: Boolean);
Begin Self.InitiallyConstrained := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringInitiallyConstrained_R(Self: TSpring; var T: Boolean);
Begin T := Self.InitiallyConstrained; end;

(*----------------------------------------------------------------------------*)
procedure TSpringXEnd_W(Self: TSpring; const T: single);
Begin Self.XEnd := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringXEnd_R(Self: TSpring; var T: single);
Begin T := Self.XEnd; end;

(*----------------------------------------------------------------------------*)
procedure TSpringV0_W(Self: TSpring; const T: single);
Begin Self.V0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringV0_R(Self: TSpring; var T: single);
Begin T := Self.V0; end;

(*----------------------------------------------------------------------------*)
procedure TSpringX0_W(Self: TSpring; const T: single);
Begin Self.X0 := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringX0_R(Self: TSpring; var T: single);
Begin T := Self.X0; end;

(*----------------------------------------------------------------------------*)
procedure TSpringC_W(Self: TSpring; const T: single);
Begin Self.C := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringC_R(Self: TSpring; var T: single);
Begin T := Self.C; end;

(*----------------------------------------------------------------------------*)
procedure TSpringv_W(Self: TSpring; const T: single);
Begin Self.v := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringv_R(Self: TSpring; var T: single);
Begin T := Self.v; end;

(*----------------------------------------------------------------------------*)
procedure TSpringx_W(Self: TSpring; const T: single);
Begin Self.x := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringx_R(Self: TSpring; var T: single);
Begin T := Self.x; end;

(*----------------------------------------------------------------------------*)
procedure TSpringA_W(Self: TSpring; const T: single);
Begin Self.A := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringA_R(Self: TSpring; var T: single);
Begin T := Self.A; end;

(*----------------------------------------------------------------------------*)
procedure TSpringG_W(Self: TSpring; const T: single);
Begin Self.G := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringG_R(Self: TSpring; var T: single);
Begin T := Self.G; end;

(*----------------------------------------------------------------------------*)
procedure TSpringM_W(Self: TSpring; const T: single);
Begin Self.M := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringM_R(Self: TSpring; var T: single);
Begin T := Self.M; end;

(*----------------------------------------------------------------------------*)
procedure TSpringK_W(Self: TSpring; const T: single);
Begin Self.K := T; end;

(*----------------------------------------------------------------------------*)
procedure TSpringK_R(Self: TSpring; var T: single);
Begin T := Self.K; end;

(*
procedure RIRegister_TForm1(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TForm1) do
  begin
    RegisterPropertyHelper(@TForm1Panel1_R,@TForm1Panel1_W,'Panel1');
    RegisterPropertyHelper(@TForm1Memo1_R,@TForm1Memo1_W,'Memo1');
    RegisterPropertyHelper(@TForm1Panel2_R,@TForm1Panel2_W,'Panel2');
    RegisterPropertyHelper(@TForm1Label2_R,@TForm1Label2_W,'Label2');
    RegisterPropertyHelper(@TForm1V0Edt_R,@TForm1V0Edt_W,'V0Edt');
    RegisterPropertyHelper(@TForm1Label4_R,@TForm1Label4_W,'Label4');
    RegisterPropertyHelper(@TForm1DampEdt_R,@TForm1DampEdt_W,'DampEdt');
    RegisterPropertyHelper(@TForm1Label5_R,@TForm1Label5_W,'Label5');
    RegisterPropertyHelper(@TForm1SpringEdt_R,@TForm1SpringEdt_W,'SpringEdt');
    RegisterPropertyHelper(@TForm1Label6_R,@TForm1Label6_W,'Label6');
    RegisterPropertyHelper(@TForm1MassEdt_R,@TForm1MassEdt_W,'MassEdt');
    RegisterPropertyHelper(@TForm1Label8_R,@TForm1Label8_W,'Label8');
    RegisterPropertyHelper(@TForm1GravityEdt_R,@TForm1GravityEdt_W,'GravityEdt');
    RegisterPropertyHelper(@TForm1ConstraintRgrp_R,@TForm1ConstraintRgrp_W,'ConstraintRgrp');
    RegisterPropertyHelper(@TForm1X0Edt_R,@TForm1X0Edt_W,'X0Edt');
    RegisterPropertyHelper(@TForm1TypeRgrp_R,@TForm1TypeRgrp_W,'TypeRgrp');
    RegisterPropertyHelper(@TForm1StartBtn_R,@TForm1StartBtn_W,'StartBtn');
    RegisterPropertyHelper(@TForm1Memo2_R,@TForm1Memo2_W,'Memo2');
    RegisterPropertyHelper(@TForm1TimeScaleGrp_R,@TForm1TimeScaleGrp_W,'TimeScaleGrp');
    RegisterPropertyHelper(@TForm1Label1_R,@TForm1Label1_W,'Label1');
    RegisterPropertyHelper(@TForm1TimeIncEdt_R,@TForm1TimeIncEdt_W,'TimeIncEdt');
    RegisterPropertyHelper(@TForm1StopBtn_R,@TForm1StopBtn_W,'StopBtn');
    RegisterPropertyHelper(@TForm1Memo3_R,@TForm1Memo3_W,'Memo3');
    RegisterPropertyHelper(@TForm1StaticText1_R,@TForm1StaticText1_W,'StaticText1');
    RegisterPropertyHelper(@TForm1Displaybox_R,@TForm1Displaybox_W,'Displaybox');
    RegisterMethod(@TForm1.StartBtnClick, 'StartBtnClick');
    RegisterMethod(@TForm1.StopBtnClick, 'StopBtnClick');
    RegisterMethod(@TForm1.FormCloseQuery, 'FormCloseQuery');
    RegisterMethod(@TForm1.X0EdtChange, 'X0EdtChange');
    RegisterMethod(@TForm1.DampEdtChange, 'DampEdtChange');
    RegisterMethod(@TForm1.SpringEdtChange, 'SpringEdtChange');
    RegisterMethod(@TForm1.MassEdtChange, 'MassEdtChange');
    RegisterMethod(@TForm1.EdtKeyPress, 'EdtKeyPress');
    RegisterMethod(@TForm1.FormCreate, 'FormCreate');
    RegisterMethod(@TForm1.EdtKeyUp, 'EdtKeyUp');
    RegisterMethod(@TForm1.FormActivate, 'FormActivate');
    RegisterMethod(@TForm1.GravityEdtChange, 'GravityEdtChange');
    RegisterMethod(@TForm1.ConstraintRgrpClick, 'ConstraintRgrpClick');
    RegisterMethod(@TForm1.TypeRgrpClick, 'TypeRgrpClick');
    RegisterMethod(@TForm1.TimeIncEdtExit, 'TimeIncEdtExit');
    RegisterMethod(@TForm1.TimeScaleGrpClick, 'TimeScaleGrpClick');
    RegisterMethod(@TForm1.StaticText1Click, 'StaticText1Click');
    RegisterMethod(@TForm1.V0EdtChange, 'V0EdtChange');
    RegisterPropertyHelper(@TForm1spring1_R,@TForm1spring1_W,'spring1');
    RegisterPropertyHelper(@TForm1timescale_R,@TForm1timescale_W,'timescale');
    RegisterPropertyHelper(@TForm1timeinc_R,@TForm1timeinc_W,'timeinc');
    RegisterMethod(@TForm1.setup, 'setup');
  end;
end; *)

(*----------------------------------------------------------------------------*)
procedure RIRegister_TSpring(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TSpring) do
  begin
    RegisterPropertyHelper(@TSpringK_R,@TSpringK_W,'K');
    RegisterPropertyHelper(@TSpringM_R,@TSpringM_W,'M');
    RegisterPropertyHelper(@TSpringG_R,@TSpringG_W,'G');
    RegisterPropertyHelper(@TSpringA_R,@TSpringA_W,'A');
    RegisterPropertyHelper(@TSpringx_R,@TSpringx_W,'x');
    RegisterPropertyHelper(@TSpringv_R,@TSpringv_W,'v');
    RegisterPropertyHelper(@TSpringC_R,@TSpringC_W,'C');
    RegisterPropertyHelper(@TSpringX0_R,@TSpringX0_W,'X0');
    RegisterPropertyHelper(@TSpringV0_R,@TSpringV0_W,'V0');
    RegisterPropertyHelper(@TSpringXEnd_R,@TSpringXEnd_W,'XEnd');
    RegisterPropertyHelper(@TSpringInitiallyConstrained_R,@TSpringInitiallyConstrained_W,'InitiallyConstrained');
    RegisterPropertyHelper(@TSpringTimeinc_R,@TSpringTimeinc_W,'Timeinc');
    RegisterPropertyHelper(@TSpringScale_R,@TSpringScale_W,'Scale');
    RegisterPropertyHelper(@TSpringStype_R,@TSpringStype_W,'Stype');
    RegisterPropertyHelper(@TSpringdelay_R,@TSpringdelay_W,'delay');
    RegisterPropertyHelper(@TSpringpts_R,@TSpringpts_W,'pts');
    RegisterPropertyHelper(@TSpringstep_R,@TSpringstep_W,'step');
    RegisterPropertyHelper(@TSpringwraps_R,@TSpringwraps_W,'wraps');
    RegisterPropertyHelper(@TSpringdrawColor_R,@TSpringdrawColor_W,'drawColor');
    RegisterConstructor(@TSpring.create, 'create');
    RegisterMethod(@TSpring.drawspring, 'drawspring');
    RegisterMethod(@TSpring.erasespring, 'erasespring');
    RegisterMethod(@TSpring.redrawinitial, 'redrawinitial');
    RegisterMethod(@TSpring.Setup, 'Setup');
    RegisterMethod(@TSpring.animate, 'animate');
     RegisterMethod(@TSpring.animate2, 'animate2');
    RegisterMethod(@TSpring.sizechanged, 'sizechanged');
    RegisterMethod(@TSpring.GetMaxAmp, 'GetMaxAmp');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_U_SpringMass2(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TSpring(CL);
  //RIRegister_TForm1(CL);
end;



(*----------------------------------------------------------------------------*)
procedure RIRegister_U_Splines(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TBSpline(CL);
  RIRegister_TSplines(CL);
  RIRegister_U_SpringMass2(CL);
end;

 
 
{ TPSImport_U_Splines }
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_Splines.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_U_Splines(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_U_Splines.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_U_Splines(ri);
  RIRegister_U_Splines_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
