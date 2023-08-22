{*******************************************************************************

                             Powtils Url Encoding

********************************************************************************
 HTTP Encoding / Decoding Unit

 Authors/Credits: Trustmaster (Vladimir Sibirov), L505 (Lars)
 License: Artistic
********************************************************************************}


unit pwurlenc; {$IFDEF FPC}{$MODE OBJFPC}{$H+}  {$IFDEF EXTRA_SECURE}  {$R+}{$Q+}{$CHECKPOINTER ON}{$ENDIF} {$ENDIF}


interface

function UrlDecode(const svar: string): string;
function UrlEncode(const svar: string): string;

implementation

const   
  HEX_TABLE = '0123456789ABCDEF';
  LAT_TABLE = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

{ ------------------------------- PRIVATE -------------------------------------}

{$IFNDEF FPC}
 { delphi 5 doesn't have HexStr() }

 const
   HexTbl : array[0..15] of char='0123456789ABCDEF';

 function hexstr(val: longint; cnt: byte): shortstring;
 var
   i: longint;
 begin
   hexstr[0]:= char(cnt);
   for i:= cnt downto 1 do
   begin
     hexstr[i]:= hextbl[val and $f];
     val:= val shr 4;
   end;
 end;
{$ENDIF}

// Traslates Hexadecimal value of hx (2 charecters) to char
function HexToChar(const hx: string): char;
var
  cnt,
  digit,
  ascii: byte;
begin
  ascii := 0;
  for cnt := 1 to 2 do
  begin
    digit := (pos(hx[cnt], HEX_TABLE) - 1); 
    // Decimal value of this HEX digit
    if cnt = 1 then
      ascii := ascii + (digit * 16)
    else
      ascii := ascii + digit;
    // Transtated from HEX to Decimal
  end;
  result := chr(ascii);
end;

{ ------------------------------- PUBLIC -------------------------------------}

//Decodes the original values of transfered variables from HTTP-safe
function UrlDecode(const svar: string): string;
var
  i, len: longword;
  c: char;
begin
  result:= '';
  i:= 1;
  len:= length(svar);
  while i <= len do 
  begin
    c:= svar[i];
    if c = '%' then
    begin
      if (i + 2) <= len then
      begin
        inc(i);
        result := result + HexToChar(copy(svar, i, 2));
        i:= i + 2; 
      end
        else
      begin
        i:= len;
      end;
    end else
    begin
      if c = '+' then
        result := result + ' '
      else
        result:= result + c;
        inc(i);
    end;
  end;
end;


//Encodes variable to HTTP safe
function UrlEncode(const svar: string): string;
var i, len: longword;
    c: char;
begin
  result := '';
  i := 1;
  len := length(svar);
  while i <= len do
  begin
    c := svar[i];
    if (pos(c, LAT_TABLE) = 0) and (c <> ' ') and (c <> '_') then
    begin
        result := result + '%' + HexStr(ord(c), 2);
        inc(i);
    end
      else
    begin
      if c = ' ' then
        result := result + '+'
      else
        result := result + c;
      inc(i);
    end
  end;
end;


end.
