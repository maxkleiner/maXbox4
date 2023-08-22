unit UtilsTimeCode;

interface

uses System.SysUtils;

function TCtoFrames(S:String):Integer;
function FramestoTC(Fi:Integer):String;
function DFtoFrames(S:String):Integer;
function FramestoDF(Fi:Integer):String;
function ValidDropFrame(S:String):Boolean;

implementation
//------------------------------------------------------------------------------
function DFtoFrames(S:String):Integer;
Var F,H,M,Sg,C,Mt:Integer;
    T:String;
begin
if (Length(S)=11) and
   (S[01] in ['0'..'9']) and (S[02] in ['0'..'9']) and
   (S[04] in ['0'..'9']) and (S[05] in ['0'..'9']) and
   (S[07] in ['0'..'9']) and (S[08] in ['0'..'9']) and
   (S[10] in ['0'..'9']) and (S[11] in ['0'..'9']) then
  begin

  H:=StrToInt(S[01]+S[02]);
  M:=StrToInt(S[04]+S[05]);
  Sg:=StrToInt(S[07]+S[08]);
  C:=StrToInt(S[10]+S[11]);

  //Detectar si es minuto con cuadros 00 o 01
  T:=Copy(S,7,5);
  if (S[5]<>'0') and (T='00;00') then
    begin
    M:=M-1;
    Sg:=59;
    C:=28;
    end
  else if (S[5]<>'0') and (T='00;01') then
    begin
    M:=M-1;
    Sg:=59;
    C:=29;
    end;


  Mt:=60*H+M;
  F:=108000*H + 1800*M + 30*Sg + C - 2*( Mt - (Mt div 10) );
  end
else
  F:=0;

DFtoFrames:=F;
end;

//------------------------------------------------------------------------------
function FramestoTC(Fi:Integer):String;
Var F,C,S,M,H: Integer;
begin
F := Abs(Fi);
C := F mod 30;
S := (F div 30) mod 60;
M := ( (F div 30) div 60 ) mod 60;
H := ( ( (F div 30) div 60 ) div 60 );

FramesToTC:=Format('%.2d',[H])+':'+Format('%.2d',[M])+':'+
            Format('%.2d',[S])+':'+Format('%.2d',[C]);
end;

//------------------------------------------------------------------------------
function FramestoDF(Fi:Integer):String;
var D, M, Fn, F : Integer;
    S: String;
begin
F:=Abs(Fi);

D := F div 17982;
M := F mod 17982;

if (M=0) or (M=1) then
  Fn := F + 18*D
else
  Fn := F + 18*D + 2*((M-2) div 1798);

S:=FramestoTC(Fn);
S[9]:=';';
FramestoDF:=S;
end;

//------------------------------------------------------------------------------
function TCtoFrames(S:String):Integer;
Var F:Integer;
begin
if (Length(S)=11) and
   (S[01] in ['0'..'9']) and (S[02] in ['0'..'9']) and
   (S[04] in ['0'..'9']) and (S[05] in ['0'..'9']) and
   (S[07] in ['0'..'9']) and (S[08] in ['0'..'9']) and
   (S[10] in ['0'..'9']) and (S[11] in ['0'..'9']) then
  begin
  F:=StrToInt(Copy(S,10,2));
  F:=F+30*StrToInt(Copy(S,7,2));
  F:=F+30*60*StrToInt(Copy(S,4,2));
  F:=F+30*60*60*StrToInt(Copy(S,1,2));
  end
else
  F:=0;

TCtoFrames:=F;
end;

//------------------------------------------------------------------------------
function ValidDropFrame(S:String):Boolean;
Var T:String;
    Valido: Boolean;
begin
Valido:=True;

if (Length(S)=11) and
   (S[01] in ['0'..'9']) and (S[02] in ['0'..'9']) and
   (S[04] in ['0'..'9']) and (S[05] in ['0'..'9']) and
   (S[07] in ['0'..'9']) and (S[08] in ['0'..'9']) and
   (S[10] in ['0'..'9']) and (S[11] in ['0'..'9']) then
  begin
  T:=Copy(S,7,5);
  if (S[5]<>'0') and ((T='00;00') or (T='00;01')) then Valido:=False;
  end
else Valido:=False;

ValidDropFrame:=Valido;
end;

//------------------------------------------------------------------------------
end.
