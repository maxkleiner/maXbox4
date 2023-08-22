unit uPSI_synaip;
{
   SYNAPSE AFTER  Sony crash   with IPUtils inline    Syna ReverseIP
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
  TPSImport_synaip = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_synaip(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_synaip_Routines(S: TPSExec);

procedure Register;

implementation


uses
   SynaUtil
  ,synaip
  ;


type TIPAdr = record
                    Oct1: Byte;
                    Oct2: Byte;
                    Oct3:Byte;
                    Oct4:Byte;
                   end;


function IPToCardinal(const Adresse:TIPAdr):Cardinal;
begin
  Result :=  (Adresse.Oct1*16777216)
            +(Adresse.Oct2*65536)
            +(Adresse.Oct3*256)
            +(Adresse.Oct4);
end;

// Cardinal in IP-Adresse umwandeln
function CardinalToIP(const Value:Cardinal):TIPAdr;
begin
  Result.Oct1 := Value div 16777216;
  Result.Oct2 := Value div 65536;
  Result.Oct3 := Value div 256;
  Result.Oct4 := Value mod 256;
end;

// IP-Adresse in String umwandeln
function IPToStr(const Adresse:TIPAdr):String;
begin
  Result := IntToStr(Adresse.Oct1) + '.' +
            IntToStr(Adresse.Oct2) + '.' +
            IntToStr(Adresse.Oct3) + '.' +
            IntToStr(Adresse.Oct4);
end;

function StrToIP(const Value:String):TIPAdr;
var n,x: Integer;
    Posi:Array[1..4]of Integer;
    Oktet:Array[1..4]of String;
begin
  x := 0;
  // es dürfen nur Zahlen und Punkte vorhanden sein
  for n := 1 to Length(Value) do begin
      // Zähle die Punkte
      if Value[n] = '.'
        then begin
            Inc(x);
            Posi[x] := n;
          end
        else Oktet[x+1] := Oktet[x+1] + Value[n];
    end;
  Result.Oct1 := StrToInt(Oktet[1]);
  Result.Oct2 := StrToInt(Oktet[2]);
  Result.Oct3 := StrToInt(Oktet[3]);
  Result.Oct4 := StrToInt(Oktet[4]);
end;

function IsIPAdr(const Value:String):Boolean;
var n,x,i: Integer;
    Posi:Array[1..4]of Integer;
    Oktet:Array[1..4]of String;
begin
  Result := true;
  x := 0;
  // es dürfen nur Zahlen und Punkte vorhanden sein
  for n := 1 to Length(Value) do
    if not (Value[n] in ['0'..'9','.'])
      then begin
          // ungültiges Zeichen -> keine IP-Adresse
          Result := false;
          break;
        end
      else begin
          // Zähle die Punkte
          if Value[n] = '.'
            then begin
                Inc(x);
                Posi[x] := n;
              end
            else begin
                 Oktet[x+1] := Oktet[x+1] + Value[n];
              end;
        end;
   for i := 1 to 4 do
    if (StrToInt(Oktet[i])>255)then Result := false;
   // es müssen genau 3 Punkte vorhanden sein
  if x <> 3 then begin
        // Anzahl der Punkte <> 3 -> keine IP-Adresse
        Result := false;
      end;
end;

 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_synaip]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_synaip(CL: TPSPascalCompiler);
begin

 // TIp6Bytes = array [0..15] of Byte;
{:binary form of IPv6 adress (for string conversion routines)}
 // TIp6Words = array [0..7] of Word;
  CL.AddTypeS('TIp6Bytes', 'array [0..15] of Byte;');
  CL.AddTypeS('TIp6Words', 'array [0..7] of Word;');

 CL.AddTypeS('TIPAdr', 'record Oct1 : Byte; Oct2 : Byte; Oct3 : Byte; Oct4: Byte; end');
 CL.AddDelphiFunction('Function xStrToIP( const Value : String) : TIPAdr');
 CL.AddDelphiFunction('Function xIPToStr( const Adresse : TIPAdr) : String');
 CL.AddDelphiFunction('Function IPToCardinal( const Adresse : TIPAdr) : Cardinal');
 CL.AddDelphiFunction('Function CardinalToIP( const Value : Cardinal) : TIPAdr');
 CL.AddDelphiFunction('Function IsIPAdr( const Value : String) : Boolean');
 CL.AddDelphiFunction('Function synaIsIP( const Value : string) : Boolean');
 CL.AddDelphiFunction('Function synaIsIP6( const Value : string) : Boolean');
 CL.AddDelphiFunction('Function synaIPToID( Host : string) : Ansistring');
 CL.AddDelphiFunction('Function synaStrToIp6( value : string) : TIp6Bytes');
 CL.AddDelphiFunction('Function synaIp6ToStr( value : TIp6Bytes) : string');
 CL.AddDelphiFunction('Function synaStrToIp( value : string) : integer');
 CL.AddDelphiFunction('Function synaIpToStr( value : integer) : string');
 CL.AddDelphiFunction('Function synaReverseIP( Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function synaReverseIP6( Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function synaExpandIP6( Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ReverseIP( Value : AnsiString) : AnsiString');
 CL.AddDelphiFunction('Function ReverseIP6( Value : AnsiString) : AnsiString');
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_synaip_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@IsIP, 'synaIsIP', cdRegister);
 S.RegisterDelphiFunction(@IsIP6, 'synaIsIP6', cdRegister);
 S.RegisterDelphiFunction(@IPToID, 'synaIPToID', cdRegister);
 S.RegisterDelphiFunction(@StrToIp6, 'synaStrToIp6', cdRegister);
 S.RegisterDelphiFunction(@Ip6ToStr, 'synaIp6ToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToIp, 'synaStrToIp', cdRegister);
 S.RegisterDelphiFunction(@IpToStr, 'synaIpToStr', cdRegister);
 S.RegisterDelphiFunction(@ReverseIP, 'synaReverseIP', cdRegister);
 S.RegisterDelphiFunction(@ReverseIP6, 'synaReverseIP6', cdRegister);
 S.RegisterDelphiFunction(@ExpandIP6, 'synaExpandIP6', cdRegister);
 S.RegisterDelphiFunction(@StrToIP, 'xStrToIP', cdRegister);
 S.RegisterDelphiFunction(@IPToStr, 'xIPToStr', cdRegister);
 S.RegisterDelphiFunction(@IPToCardinal, 'IPToCardinal', cdRegister);
 S.RegisterDelphiFunction(@CardinalToIP, 'CardinalToIP', cdRegister);
 S.RegisterDelphiFunction(@IsIPAdr, 'IsIPAdr', cdRegister);
 S.RegisterDelphiFunction(@ReverseIP, 'ReverseIP', cdRegister);
 S.RegisterDelphiFunction(@ReverseIP6, 'ReverseIP6', cdRegister);
end;

 
 
{ TPSImport_synaip }
(*----------------------------------------------------------------------------*)
procedure TPSImport_synaip.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_synaip(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_synaip.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_synaip(ri);
  RIRegister_synaip_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
