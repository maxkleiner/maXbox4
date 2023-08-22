unit HarmFade;

interface

{
          HarmFade Component, by Harm

     Copyright 1998 Technoid Brain Trust
           harmans@uswest.net

Version 2.3 - 12/98. Add three new events:
                     OnMouseEnter, OnMouseLeave, and OnClick.
                     Added two new methods:
                     UnBlend and UnDissolve.
                     These excellent suggestions came from
                     Douglas@rexburg.com

****  Documentation has been moved to harmfade.txt and harmfade.doc
}

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs;

const
  Maxize = (1294967280 Div SizeOf(TPoint));
  MaxPixelCount   =  32768;
  Mask0101 = $00FF00FF; 
  Mask1010 = $FF00FF00; 

type
  EHarmFade = class(Exception);

  PRGBArray  =  ^TRGBArray;
  TRGBArray  =  array[0..MaxPixelCount-1] of TRGBTriple;

  TPnts = array[0..Maxize - 1] of TPoint;

  THarmFade = class(TGraphicControl)
  private
    {Private Declarations}
    bmF      : TBitmap;                    
    bmT      : TBitmap;                    
    bmZ      : TBitmap;                    
    FPicFrom : TPicture;                   
    FPicTo   : TPicture;                    
    FclFrom  : TColor;                     
    FclTo    : TColor;                     
    FPnts    : ^TPnts;
    FDRate   : integer;
    FBRate   : integer;                   
    FNumPix  : integer;                     
    FStretch : Boolean;                   
    FProcMsg : Boolean;                  
    FFinish  : Boolean;
    FOnBegin : TNotifyEvent;
    FOnEnd   : TNotifyEvent;              
    FOnReset : TNotifyEvent;
    FAutoRev : Boolean;
    FRevSwap : Boolean;
    FReverst : Boolean;
    FStrTmp  : Boolean;
    FDelay   : integer;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    procedure CMMouseEnter(var Msg:TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Msg:TMessage); message CM_MOUSELEAVE;
    procedure chgPicF(Sender : TObject);
    procedure chgPicT(Sender : TObject);    
    procedure WMEraseBkgnd(Var Msg : TMessage); message WM_ERASEBKGND;
    procedure SetpicFrom(Pic : TPicture);
    procedure SetpicTo(Pic : TPicture);     
    procedure SetclFrom(Col : TColor);      
    procedure SetclTo(Col : TColor);       
    procedure SetDRate(Val : integer);     
    procedure SetBRate(Val : integer);     
    procedure SetStretch(Val : Boolean);    
    procedure SetProcMsg(Val : Boolean);   
    procedure SetPnts;
  //  procedure RevDslv;
  //  procedure RevBlend;
    procedure Blendit(bFr,bTo,bLn : Pointer ; Width,Height : Integer ; Dens : LongInt);
    procedure SetAutoRev(Val : Boolean);
    procedure SetRevSwap(Val : Boolean);
    procedure SetDelay(Val : integer);
  protected
    {Protected Declarations}
    procedure WMPosChg(var Msg : TMessage); message WM_WINDOWPOSCHANGED;
  public
    {Public Declarations}
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Reset;                       
    procedure Dissolve;                    
    procedure FinishIt;                     
    procedure Blend;
    procedure UnBlend;
    procedure UnDissolve;
    property Finish : Boolean read FFinish write FFinish default FALSE;
  published
    {Published Declarations}
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter
        write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave
        write FOnMouseLeave;
    property PicFrom : TPicture read FPicFrom write SetpicFrom;
    property PicTo : TPicture read FPicTo write SetpicTo;        
    property ColorFrom : TColor read FclFrom write SetclFrom default clBlack;
    property ColorTo : TColor read FclTo write SetclTo default clWhite;
    property DisolvRate : integer read FDRate write SetDRate default 125;
    property BlendRate : integer read FBRate write SetBRate default 32;
    property StretchToFit : Boolean read FStretch write SetStretch default TRUE;
    property ProcessMsgs : Boolean read FProcMsg write SetProcMsg default FALSE;
    property OnBegin : TNotifyEvent read FOnBegin write FOnBegin;
    property OnEnd : TNotifyEvent read FOnEnd write FOnEnd;
    property OnReset : TNotifyEvent read FOnReset write FOnReset;
    property AutoReverse : Boolean read FAutoRev write SetAutoRev default FALSE;
    property SwapOnReverse : Boolean read FRevSwap write SetRevSwap default TRUE;
    property SwapDelay : integer read FDelay write SetDelay default 1;
    property Hint;
    property OnClick;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
  end;

procedure Register;

implementation

Var  
  EBX, ESI, EDI, ESP, EBP,
  FinA,
  Dens1, Dens2 : Longint;

constructor THarmFade.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FclFrom := clBlack;
  FclTo := clWhite;
  FDRate := 125;
  FBRate := 32;
  FStretch := TRUE;
  FStrTmp := TRUE;
  FProcMsg := FALSE;
  FFinish := FALSE;
  FAutoRev := FALSE;
  FRevSwap := TRUE;
  FReverst := FALSE;
  FDelay := 1;
  ControlStyle := ControlStyle + [csOpaque] + [csNoStdEvents];
  FPicFrom := TPicture.Create;
  FPicTo := TPicture.Create;
  bmF := TBitmap.Create;
  bmT := TBitmap.Create;
  bmZ := TBitmap.Create;
  bmZ.PixelFormat := pf24bit;
  bmF.Canvas.Brush.Color := clBlack;
  FPicFrom.OnChange := chgPicF;
  FPicTo.OnChange := chgPicT;
  Width := 75;
  Height := 75;
  bmF.Width := Width;
  bmF.Height := Height;
end;

procedure DoIco(I : TGraphic; B : TBitmap; C : TColor; W : integer; H : integer);
var
  bmIco : TBitmap;
begin
  bmIco := TBitmap.Create;
  bmIco.Width := I.Width;
  bmIco.Height := I.Height;
  bmIco.Canvas.Brush.Color := C;
  bmIco.Canvas.FillRect(RECT(0,0,bmIco.Width,bmIco.Height));
  bmIco.Canvas.Draw(0,0,I);
  B.Canvas.StretchDraw(RECT(0,0,W,H),bmIco);
  bmIco.Free;
end;

procedure THarmFade.Reset;
var
  pTmp : TPicture;
  cTmp : TColor;
begin

  bmF.PixelFormat := pf24bit;
  bmT.PixelFormat := pf24bit;
  bmZ.PixelFormat := pf24bit;

  if FReverst = TRUE then begin
    cTmp := FclFrom;
    FclFrom := FclTo;
    FclTo := cTmp;
    pTmp := TPicture.Create;
    pTmp.Assign(FPicFrom);
    FPicFrom.Assign(FPicTo);
    FPicTo.Assign(pTmp);
    bmF.Canvas.Brush.Color := FclFrom;
    bmT.Canvas.Brush.Color := FclTo;
    FReverst := FALSE;
    pTmp.Free;
    FStretch := FStrTmp;
  end;

  if FStretch = TRUE then begin
    bmF.Width := Width;
    bmF.Height := Height;
    if FPicFrom.Graphic = nil then
      bmF.Canvas.FillRect(RECT(0,0,Width,Height))
    else begin
      if FPicFrom.Graphic is TMetaFile then
        bmF.Canvas.FillRect(RECT(0,0,Width,Height));
      if FPicFrom.Graphic is TIcon then begin
        DoIco(FPicFrom.Graphic, bmF, FclFrom, Width, Height);
      end
      else
      bmF.Canvas.StretchDraw(RECT(0,0,Width,Height),FPicFrom.Graphic);
    end;
    bmT.Width := Width;
    bmT.Height := Height;
    if FPicTo.Graphic = nil then
      bmT.Canvas.FillRect(RECT(0,0,Width,Height))
    else begin
      if FPicTo.Graphic is TMetaFile then
        bmT.Canvas.FillRect(RECT(0,0,Width,Height));
      if FPicTo.Graphic is TIcon then
        DoIco(FPicTo.Graphic, bmT, FclTo, Width, Height)
      else
      bmT.Canvas.StretchDraw(RECT(0,0,Width,Height),FPicTo.Graphic);
    end;
  end;

  if FStretch = FALSE then begin
    if (FPicTo.Graphic <> nil) and (FPicFrom.Graphic = nil) then begin
      Width := FPicTo.Width;  
      Height := FPicTo.Height;
      bmT.Width := Width;
      bmT.Height := Height;
      if (FPicTo.Graphic is TMetaFile) or (FPicTo.Graphic is TIcon) then
        bmT.Canvas.FillRect(RECT(0,0,Width,Height));
      bmT.Canvas.Draw(0,0,FPicTo.Graphic);  
      bmF.Width := Width;         
      bmF.Height := Height;
      bmF.Canvas.FillRect(RECT(0,0,Width,Height));
    end;
    if (FPicFrom.Graphic <> nil) and (FPicTo.Graphic = nil) then begin
      Width := FPicFrom.Width;  
      Height := FPicFrom.Height;
      bmF.Width := Width;
      bmF.Height := Height;
      if (FPicFrom.Graphic is TMetaFile) or (FPicFrom.Graphic is TIcon) then
        bmF.Canvas.FillRect(RECT(0,0,Width,Height));
      bmF.Canvas.Draw(0,0,FPicFrom.Graphic);  
      bmT.Width := Width;            
      bmT.Height := Height;
      bmT.Canvas.FillRect(RECT(0,0,Width,Height));
    end;
    if (FPicFrom.Graphic = nil) and (FPicTo.Graphic = nil) then begin
      bmF.Width := Width;         
      bmF.Height := Height;
      bmF.Canvas.FillRect(RECT(0,0,Width,Height));
      bmT.Width := Width;
      bmT.Height := Height;
      bmT.Canvas.FillRect(RECT(0,0,Width,Height));
    end;
    if (FPicFrom.Graphic <> nil) and (FPicTo.Graphic <> nil) then begin
      Width := FPicFrom.Width;   
      Height := FPicFrom.Height;
      bmF.Width := Width;
      bmF.Height := Height;
      if (FPicFrom.Graphic is TMetaFile) or (FPicFrom.Graphic is TIcon) then
        bmF.Canvas.FillRect(RECT(0,0,Width,Height));
      bmF.Canvas.Draw(0,0,FPicFrom.Graphic);  
      bmT.Width := Width;
      bmT.Height := Height;
      if FPicTo.Graphic is TMetaFile then
        bmT.Canvas.FillRect(RECT(0,0,Width,Height));
      if FPicTo.Graphic is TIcon then begin
        DoIco(FPicTo.Graphic, bmT, FclTo, Width, Height);
      end
      else
      bmT.Canvas.StretchDraw(RECT(0,0,Width,Height),FPicTo.Graphic);
    end;
  end;

  bmZ.Width := bmF.Width;
  bmZ.Height := bmF.Height;

  Invalidate;

  if Assigned (FOnReset) then FOnReset(Self); 

end;   

procedure THarmFade.SetPnts;
var
  x, y, n, r : integer;
  tmpPt : TPoint;
begin
  FNumPix := Width * Height;
  n := 0;
  FPnts := AllocMem(FNumPix * SizeOf(TPoint)); 
  for x := 0 to Height-1 do begin
    for y := 0 to Width-1 do begin    
      Fpnts^[n] := Point(x,y);
      n := n + 1;
    end;
  end;
  Randomize;
  for n := 0 to ((Width * Height)-1) do begin   
    r := Random(FNumPix);
    tmpPt := Fpnts^[r];
    Fpnts^[r] := Fpnts^[n];
    Fpnts^[n] := tmpPt;
  end;
end;

procedure THarmFade.WMEraseBkgnd(var Msg:TMessage);
begin
  Msg.Result := 1;  
end;                

procedure THarmFade.Paint;
begin
  Canvas.Draw(0,0,bmF);
end;

procedure THarmFade.Dissolve;
var
  x, y, n, r, l : integer;
  Block : integer;
  ba, bb : pByteArray;
begin
  Reset;
  SetPnts;
  Block := FNumPix Div FDRate;
  if Block < 1 then
    raise EHarmFade.Create('DisolvRate cannot be > Width * Height!');

  if Assigned (FOnBegin) then FOnBegin(Self);

  for r := 0 to ((FNumPix Div Block)-1) do begin
    for n := (r * Block) to ((r * Block) + Block - 1) do begin
      x := Fpnts^[n].x;
      y := Fpnts^[n].y;
      ba := bmT.ScanLine[x];
      bb := bmF.ScanLine[x];
      for l := 0 to 2 do
        bb[(y*3) + l] := ba[(y*3) + l];
    end;
    Repaint;

    if FProcMsg = TRUE then    
      Application.ProcessMessages;
      
    if FFinish = TRUE then begin
      FinishIt;
      FreeMem(FPnts, FNumPix * SizeOf(TPoint));
      Exit;
    end;

  end;
    for n := ((FNumPix div Block) * Block) to (FNumPix-1) do begin
      x := Fpnts^[n].x;
      y := Fpnts^[n].y;
      ba := bmT.ScanLine[x];
      bb := bmF.ScanLine[x];
      for l := 0 to 2 do
        bb[(y*3) + l] := ba[(y*3) + l];
    end;
  Repaint;
  FreeMem(FPnts, FNumPix * SizeOf(TPoint));

  if FAutoRev = TRUE then begin
    Sleep(FDelay * 1000);
    if FRevSwap = TRUE then
      UnBlend
    else
      UnDissolve;
  end;
  if Assigned (FOnEnd) then FOnEnd(Self);
end;

procedure THarmFade.UnDissolve;
var
  x, y, n, r, l : integer;
  Block : integer;
  ba, bb : pByteArray;
  cTmp : TColor;
  pTmp : TPicture;
begin
  FStrTmp := FStretch;
  FStretch := TRUE;
  bmF.Canvas.Brush.Color := FclTo;
  bmT.Canvas.Brush.Color := FclFrom;
  cTmp := FclFrom;
  FclFrom := FclTo;
  FclTo := cTmp;
  pTmp := TPicture.Create;
  pTmp.Assign(FPicFrom);
  FPicFrom.Assign(FPicTo);
  FPicTo.Assign(pTmp);
  pTmp.Free;
  Reset;
  FReverst := TRUE;
  SetPnts;
  Block := FNumPix Div FDRate;

  for r := 0 to ((FNumPix Div Block)-1) do begin
    for n := (r * Block) to ((r * Block) + Block - 1) do begin
      x := Fpnts^[n].x;
      y := Fpnts^[n].y;
      ba := bmT.ScanLine[x];
      bb := bmF.ScanLine[x];
      for l := 0 to 2 do
        bb[(y*3) + l] := ba[(y*3) + l];
    end;
    Repaint;

    if FProcMsg = TRUE then    
      Application.ProcessMessages;
      
    if FFinish = TRUE then begin
      FinishIt;
      FreeMem(FPnts, FNumPix * SizeOf(TPoint));
      Exit;
    end;

  end;
    for n := ((FNumPix div Block) * Block) to (FNumPix-1) do begin
      x := Fpnts^[n].x;
      y := Fpnts^[n].y;
      ba := bmT.ScanLine[x];
      bb := bmF.ScanLine[x];
      for l := 0 to 2 do
        bb[(y*3) + l] := ba[(y*3) + l];
    end;
  Repaint;
  FreeMem(FPnts, FNumPix * SizeOf(TPoint));
  Reset;
end;

procedure THarmFade.FinishIt;
begin
  Canvas.Draw(0,0,bmT);
  if Assigned (FOnEnd) then FOnEnd(Self);
  FFinish := FALSE;
end;

Function Pt(B : TBitmap) : Pointer;
Begin
  Pt := B.Scanline[(B.Height-1)]
End; 

procedure THarmFade.Blendit(bFr,bTo,bLn : Pointer ; Width,Height : Integer ; Dens : LongInt); assembler;

ASM

  MOV &EBX, EBX
  MOV &EDI, EDI
  MOV &ESI, ESI
  MOV &ESP, ESP
  MOV &EBP, EBP

  MOV EBX, Dens 
  MOV Dens1, EBX

  NEG BL
  ADD BL, $20   
  MOV Dens2, EBX
  CMP Dens1, 0
  JZ  @Final
  MOV EDI, bFr
  MOV ESI, bTo
  MOV ECX, bLn

  MOV EAX, Width
  lea EAX, [EAX+EAX*2+3] 
  AND EAX, $FFFFFFFC
  IMUL Height
  ADD EAX, EDI
  MOV FinA, EAX

  MOV EBP,EDI
  MOV ESP,ESI
  MOV ECX,ECX

@LOOPA:  
  MOV  EAX, [EBP] 
  MOV  EDI, [ESP] 
  MOV  EBX, EAX   
  AND  EAX, Mask1010 
  AND  EBX, Mask0101 
  SHR  EAX, 5       
  IMUL EAX, Dens2   
  IMUL EBX, Dens2   
  MOV  ESI, EDI     
  AND  EDI, Mask1010 
  AND  ESI, Mask0101 
  SHR  EDI, 5        
  IMUL EDI, Dens1    
  IMUL ESI, Dens1    
  ADD  EAX, EDI
  ADD  EBX, ESI     
  AND  EAX, Mask1010 
  SHR  EBX, 5        
  AND  EBX, Mask0101 
  OR   EAX, EBX      
  MOV [ECX], EAX     

  ADD  EBP, 4       
  ADD  ESP, 4
  ADD  ECX, 4

  CMP  EBP, FinA
  JNE  @LOOPA

@FINAL:

  MOV EBX, &EBX
  MOV EDI, &EDI
  MOV ESI, &ESI
  MOV ESP, &ESP
  MOV EBP, &EBP

End;

procedure THarmFade.Blend;
var
  r : integer;
begin
  Reset;
  if FBRate < 1 then
    raise EHarmFade.Create('BlendRate must be between 0 and 256');
  if Assigned (FOnBegin) then FOnBegin(Self);
  bmZ.Canvas.Draw(0, 0, bmF);
  for r := 0 to FBRate do begin
  Blendit(Pt(bmZ),Pt(bmT),Pt(bmF),bmF.Width,bmF.Height,(r*$20 Div FBRate));
  RePaint;
  if FProcMsg = TRUE then
    Application.ProcessMessages;

    if FFinish = TRUE then begin
      FinishIt;
      Exit;
    end;

  end;

  if FAutoRev = TRUE then begin
    Sleep(FDelay * 1000);
    if FRevSwap = TRUE then
      UnDissolve
    else
      UnBlend;
  end;
  if Assigned (FOnEnd) then FOnEnd(Self);
end;

procedure THarmFade.UnBlend;
var
  r : integer;
  pTmp : TPicture;
  cTmp : TColor;
begin
  FStrTmp := FStretch;
  FStretch := TRUE;
  bmF.Canvas.Brush.Color := FclTo;
  bmT.Canvas.Brush.Color := FclFrom;
  cTmp := FclFrom;
  FclFrom := FclTo;
  FclTo := cTmp;
  pTmp := TPicture.Create;
  pTmp.Assign(FPicFrom);
  FPicFrom.Assign(FPicTo);
  FPicTo.Assign(pTmp);
  pTmp.Free;
  Reset;
  FReverst := TRUE;
  bmZ.Canvas.Draw(0, 0, bmF);
  for r := 0 to FBRate do begin
  Blendit(Pt(bmZ),Pt(bmT),Pt(bmF),bmF.Width,bmF.Height,(r*$20 Div FBRate));
  RePaint;
  if FProcMsg = TRUE then
    Application.ProcessMessages;

    if FFinish = TRUE then begin
      FinishIt;
      Exit;
    end;

  end;
  Reset;

end;

//procedure THarmFade.UnBlend;
//begin
//  RevBlend;
//end;

//procedure THarmFade.UnDissolve;
//begin
//  RevDslv;
//end;

procedure THarmFade.WMPosChg(var Msg : TMessage);
begin
  Reset;
  Invalidate;
  inherited;
end;

procedure THarmFade.CMMouseEnter(var Msg:TMessage);
begin
  inherited;
  if Assigned (FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure THarmFade.CMMouseLeave(var Msg:TMessage);
begin
  inherited;
  if Assigned (FonMouseLeave) then FOnMouseLeave(Self);
end;

procedure THarmFade.chgPicF(Sender : TObject);
begin
  if FReverst = TRUE then Exit;
  Reset;
  Invalidate;
end;

procedure THarmFade.chgPicT(Sender : TObject);
begin
  if FReverst = TRUE then Exit;
  Reset;
  Invalidate;
end;

procedure THarmFade.SetpicFrom(Pic : TPicture);
begin
  FPicFrom.Assign(Pic);
end;

procedure THarmfade.SetpicTo(Pic : TPicture);
begin
  FPicTo.Assign(Pic);
end;

procedure THarmFade.SetclFrom(Col : TColor);
begin
  if FclFrom <> Col then begin
    FclFrom := Col;
    bmF.Canvas.Brush.Color := Col;
    Reset;
    Invalidate;
  end;
end;

procedure THarmFade.SetclTo(Col : TColor);
begin
  if FclTo <> Col then begin
    FclTo := Col;
    bmT.Canvas.Brush.Color := Col;
    Reset;
    Invalidate;
  end;
end;

procedure THarmFade.SetDRate(Val : integer);
begin
  if FDRate <> Val then
    FDRate := Val;
  if FDRate < 1 then
    FDRate := 1;
  if FDRate > (Width * Height) then
    FDRate := Width * Height;
end;

procedure THarmFade.SetBRate(Val : integer);
begin
  if FBRate <> Val then
    FBRate := Val;
  if FBRate < 1 then
    FBRate := 1;
  if FBRate > 255 then
    FBRate := 255;
end;

procedure THarmFade.SetStretch(Val : Boolean);
begin
  if FStretch <> Val then begin
    FStretch := Val;
    Reset;
    Invalidate;
  end;
end;

procedure THarmFade.SetProcMsg(Val : Boolean);
begin
  if FProcMsg <> Val then
    FProcMsg := Val;
end;

procedure THarmFade.SetAutoRev(Val : Boolean);
begin
  if FAutoRev <> Val then
    FAutoRev := Val;
end;

procedure THarmFade.SetRevSwap(Val : Boolean);
begin
  if FRevSwap <> Val then
    FRevSwap := Val;
end;

procedure THarmFade.SetDelay(Val : integer);
begin
  if FDelay <> Val then
    FDelay := Val;
end;

destructor THarmFade.Destroy;
begin
  FPicFrom.Free;
  FPicTo.Free;
  bmF.Free;
  bmT.Free;
  bmZ.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Samples', [THarmFade]);
end;

end.
