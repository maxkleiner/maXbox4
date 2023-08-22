unit ip_misc;
(*@/// interface *)
interface
  (*$x+ *)

(*@/// uses *)
uses
  sysutils,
(*$ifdef ver80 *)
  winprocs,
  wintypes,
(*$else *)
  windows,
(*$endif *)
  winsock,
  classes;
(*@\\\*)

var
  tcpip_ready: boolean;
const
  INVALID_IP_ADDRESS= $ffffffff;  (* only invalid as a host ip, maybe OK for broadcast *)

type
  ta_8u=packed array [0..65530] of byte;
  t_encoding=(uuencode,base64,mime);

(* The date in RFC 822 conform string format *)
function internet_date(date: TDateTime):string;

(* Hostname (or IP-String) -> ip-address (in network order) *)
function lookup_hostname(const hostname:string):longint;

(* Name of the local computer *)
function my_hostname:string;

(* (Main) IP address of the local computer (network order *)
function my_ip_address:longint;

(* IP-Address (network order) -> ###.###.###.### *)
function ip2string(ip_address:longint):string;

(* IP-Address (network order) -> (Main) hostname *)
function resolve_hostname(ip: longint):string;

(* Parse the n'th email address out of a string *)
function address_from(const s:string; count: integer):string;

(* Binary stream -> Base64 (MIME) encoded strings and back *)
function encode_base64(data: TStream):TStringList;
function decode_base64(source:TStringList):TMemoryStream;

(* Find n'th occurence of a substring, from left or from right *)
function posn(const s,t:string; count:integer):integer;

(* Find the n'th char unequal from left or from right *)
function poscn(c:char; const s:string; n: integer):integer;

(* Parse the filename out of a DOS/UNC file and path name *)
function filename_of(const s:string):string;

(* Delphi 1 didn't know these, but they are useful/necessary for D2/D3 *)
(*$ifdef ver80 *)
function trim(const s:string):string;
procedure setlength(var s:string; l: byte);
(*$endif *)

(* The offset to UTC/GMT in minutes of the local time zone *)
function TimeZoneBias:longint;

(* Convert 8bit to 7bit and back *)
function eight2seven_quoteprint(const s:string):string;
function eight2seven_german(const s:string):string;
function seven2eight_quoteprint(const s:string):string;
(*@\\\0000000401*)
(*@/// implementation *)
implementation

(*@/// Some string utility functions *)
(*@/// function posn(const s,t:string; count:integer):integer; *)
function posn(const s,t:string; count:integer):integer;

{ find the count'th occurence of the substring,
  if count<0 then look from the back }

var
  i,h,last: integer;
  u: string;
begin
  u:=t;
  if count>0 then begin
    result:=length(t);
    for i:=1 to count do begin
      h:=pos(s,u);
      if h>0 then
        u:=copy(u,pos(s,u)+1,length(u))
      else begin
        u:='';
        inc(result);
        end;
      end;
    result:=result-length(u);
    end
  else if count<0 then begin
    last:=0;
    for i:=length(t) downto 1 do begin
      u:=copy(t,i,length(t));
      h:=pos(s,u);
      if (h<>0) and (h+i<>last) then begin
        last:=h+i-1;
        inc(count);
        if count=0 then BREAK;
        end;
      end;
    if count=0 then result:=last
               else result:=0;
    end
  else
    result:=0;
  end;
(*@\\\*)
(*@/// function poscn(c:char; const s:string; n: integer):integer; *)
function poscn(c:char; const s:string; n: integer):integer;

{ Find the n'th occurence of a character different to c,
  if n<0 look from the back }

var
  i: integer;
begin
  if n=0 then  n:=1;
  if n>0 then begin
    for i:=1 to length(s) do begin
      if s[i]<>c then begin
        dec(n);
        result:=i;
        if n=0 then begin
          EXIT;
          end;
        end;
      end;
    end
  else begin
    for i:=length(s) downto 1 do begin
      if s[i]<>c then begin
        inc(n);
        result:=i;
        if n=0 then begin
          EXIT;
          end;
        end;
      end;
    end;
  poscn:=0;
  end;
(*@\\\0000000C10*)
(*@/// function filename_of(const s:string):string; *)
function filename_of(const s:string):string;
var
  t:integer;
begin
  t:=posn('\',s,-1);
  if t>0 then
    result:=copy(s,t+1,length(s))
  else begin
    t:=posn(':',s,-1);
    if t>0 then
      result:=copy(s,t+1,length(s))
    else
      result:=s;
    end;
  end;
(*@\\\000000012D*)
(*$ifdef ver80 *)
(*@/// function trim(const s:string):string; *)
function trim(const s:string):string;
var
  h: integer;
begin
  (* trim from left *)
  h:=poscn(' ',s,1);
  if h>0 then
    result:=copy(s,h,length(s))
  else
    result:=s;
  (* trim from right *)
  h:=poscn(' ',result,-1);
  if h>0 then
    result:=copy(result,1,h);
  end;
(*@\\\0000000C0B*)
(*@/// procedure setlength(var s:string; l: byte); *)
procedure setlength(var s:string; l: byte);
begin
  s[0]:=char(l);
  end;
(*@\\\000000012C*)
(*$endif *)
(*@\\\0000000201*)

(*@/// function TimeZoneBias:longint;          // in minutes ! *)
function TimeZoneBias:longint;
(*@/// 16 bit way: try a 32bit API call via thunking layer, if that fails try the TZ *)
(*$ifdef ver80 *)
(*@/// function GetEnvVar(const s:string):string; *)
function GetEnvVar(const s:string):string;
var
  L: Word;
  P: PChar;
begin
  L := length(s);
  P := GetDosEnvironment;
  while P^ <> #0 do begin
    if (StrLIComp(P, PChar(@s[1]), L) = 0) and (P[L] = '=') then begin
      GetEnvVar := StrPas(P + L + 1);
      EXIT;
      end;
    Inc(P, StrLen(P) + 1);
    end;
  GetEnvVar := '';
  end;
(*@\\\0000000922*)

(*@/// function day_in_month(month,year,weekday: word; count: integer):TDateTime; *)
function day_in_month(month,year,weekday: word; count: integer):TDateTime;
var
  h: integer;
begin
  if count>0 then begin
    h:=dayofweek(encodedate(year,month,1));
    h:=((weekday-h+7) mod 7) +1 + (count-1)*7;
    result:=encodedate(year,month,h);
    end
  else begin
    h:=dayofweek(encodedate(year,month,1));
    h:=((weekday-h+7) mod 7) +1 + 6*7;
    while count<0 do begin
      h:=h-7;
      try
        result:=encodedate(year,month,h);
        inc(count);
        if count=0 then EXIT;
      except
        end;
      end;
    end;
  end;
(*@\\\*)
(*@/// function DayLight_Start:TDateTime;     // american way ! *)
function DayLight_Start:TDateTime;
var
  y,m,d: word;
begin
  DecodeDate(now,y,m,d);
  result:=day_in_month(4,y,1,1);
  (* for european one: day_in_month(3,y,1,-1) *)
  end;
(*@\\\0000000701*)
(*@/// function DayLight_End:TDateTime;       // american way ! *)
function DayLight_End:TDateTime;
var
  y,m,d: word;
begin
  DecodeDate(now,y,m,d);
  result:=day_in_month(10,y,1,-1);
  end;
(*@\\\000000060B*)
type    (* stolen from windows.pas *)
(*@///   TSystemTime = record ... end; *)
PSystemTime = ^TSystemTime;
TSystemTime = record
  wYear: Word;
  wMonth: Word;
  wDayOfWeek: Word;
  wDay: Word;
  wHour: Word;
  wMinute: Word;
  wSecond: Word;
  wMilliseconds: Word;
end;
(*@\\\0000000201*)
(*@///   TTimeZoneInformation = record ... end; *)
TTimeZoneInformation = record
  Bias: Longint;
  StandardName: array[0..31] of word;  (* wchar *)
  StandardDate: TSystemTime;
  StandardBias: Longint;
  DaylightName: array[0..31] of word;  (* wchar *)
  DaylightDate: TSystemTime;
  DaylightBias: Longint;
  end;
(*@\\\*)
var
  tz_info: TTimeZoneInformation;
  LL32:function (LibFileName: PChar; handle: longint; special: longint):Longint;
  FL32:function (hDll: Longint):boolean;
  GA32:function (hDll: Longint; functionname: PChar):longint;
  CP32:function (buffer:TTimeZoneInformation; prochandle,adressconvert,dwParams:Longint):longint;
  hdll32,dummy,farproc: longint;
  hdll:THandle;
  sign: integer;
  s: string;
begin
  hDll:=GetModuleHandle('kernel');                  { get the 16bit handle of kernel }
  @LL32:=GetProcAddress(hdll,'LoadLibraryEx32W');   { get the thunking layer functions }
  @FL32:=GetProcAddress(hdll,'FreeLibrary32W');
  @GA32:=GetProcAddress(hdll,'GetProcAddress32W');
  @CP32:=GetProcAddress(hdll,'CallProc32W');
(*@///   if possible then   call GetTimeZoneInformation via Thunking *)
if (@LL32<>NIL) and
   (@FL32<>NIL) and
   (@GA32<>NIL) and
   (@CP32<>NIL) then begin
  hDll32:=LL32('kernel32.dll',dummy,1);            { get the 32bit handle of kernel32 }
  farproc:=GA32(hDll32,'GetTimeZoneInformation');  { get the 32bit adress of the function }
  case CP32(tz_info,farproc,1,1) of                { and call it }
    1: result:=tz_info.StandardBias+tz_info.Bias;
    2: result:=tz_info.DaylightBias+tz_info.Bias;
    else result:=0;
    end;
  FL32(hDll32);                                    { and free the 32bit dll }
  end
(*@\\\0000000501*)
(*@///   else  calculate the bias out of the TZ environment variable *)
else begin
  s:=GetEnvVar('TZ');
  while (length(s)>0) and (not(s[1] in ['+','-','0'..'9'])) do
    s:=copy(s,2,length(s));
  case s[1] of
(*@///     '+': *)
'+': begin
  sign:=1;
  s:=copy(s,2,length(s));
  end;
(*@\\\*)
(*@///     '-': *)
'-': begin
  sign:=-1;
  s:=copy(s,2,length(s));
  end;
(*@\\\000000030A*)
    else sign:=1;
    end;
  try
    result:=strtoint(copy(s,1,2))*60;
    s:=copy(s,3,length(s));
  except
    try
      result:=strtoint(s[1])*60;
      s:=copy(s,2,length(s));
    except
      result:=0;
      end;
    end;
(*@///   if s[1]=':' then    minutes offset *)
if s[1]=':' then begin
  try
    result:=result+strtoint(copy(s,2,2));
    s:=copy(s,4,length(s));
  except
    try
      result:=result+strtoint(s[2]);
      s:=copy(s,3,length(s));
    except
      end;
    end;
  end;
(*@\\\0000000A01*)
(*@///   if s[1]=':' then    seconds offset - ignored *)
if s[1]=':' then begin
  try
    strtoint(copy(s,2,2));
    s:=copy(s,4,length(s));
  except
    try
      strtoint(s[2]);
      s:=copy(s,3,length(s));
    except
      end;
    end;
  end;
(*@\\\0000000A01*)
  result:=result*sign;
(*@///   if length(s)>0 then daylight saving activated, calculate it *)
if length(s)>0 then begin
  (* forget about the few hours on the start/end day *)
  if (now>daylight_start) and (now<DayLight_End+1) then
    result:=result-60;
  end;
(*@\\\0000000401*)
  end;
(*@\\\*)
  end;
(*@\\\0000000201*)
(*@/// 32 bit way: API call GetTimeZoneInformation *)
(*$else *)
var
  tz_info: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(tz_info) of
    1: result:=tz_info.StandardBias+tz_info.Bias;
    2: result:=tz_info.DaylightBias+tz_info.Bias;
    else result:=0;
    end;
  end;
(*$endif *)
(*@\\\*)
(*@\\\0000000301*)

const
  bin2uue:string='`!"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_';
  bin2b64:string='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  uue2bin:string=' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_ ';
  b642bin:string='~~~~~~~~~~~^~~~_TUVWXYZ[\]~~~|~~~ !"#$%&''()*+,-./0123456789~~~~~~:;<=>?@ABCDEFGHIJKLMNOPQRS';
  linesize = 45;

(*@/// function decode_line(mode:t_encoding; const inp:string):string; *)
function decode_line(mode:t_encoding; const inp:string):string;
var
  count,pos1,pos2: integer;
  offset: shortint;
  s: string;
  out: string;
begin
  s:=inp;
  setlength(out,length(s)*3 div 4 +3);
  fillchar(out[1],length(s)*3 div 4 +3,#0);   (* worst case *)
  if (mode=uuencode) and not (s[1] in [' '..'M','`']) then
    count:=0   (* ignored line *)
  else begin
    count:=0; pos1:=0;  (* Delphi 2 Shut up! *)
    case mode of  (* !!! No check for invalid data yet *)
(*@///       uuencode:    set count,pos1, string -> Data into $00..$3F *)
uuencode: begin
  count:=(ord(s[1]) - $20) and $3f;
  for pos1:=2 to length(s) do
    s[pos1]:=char(ord(uue2bin[ord(s[pos1])-$20+1])-$20);
  pos1:=2;
  end;
(*@\\\000000031B*)
(*@///       base64,mime: set count,pos1, string -> Data into $00..$3F *)
base64,mime: begin
{   count:=length(s)*3 div 4; }
  count:=poscn('=',s,-1)*3 div 4;
  for pos1:=1 to length(s) do
    s[pos1]:=char(ord(b642bin[ord(s[pos1])-$20+1])-$20);
  pos1:=1;
  end;
(*@\\\000000041F*)
      end;
    pos2:=1;
    offset:=2;
    while pos2<=count do begin
      if (pos1>length(s)) or ((mode<>uuencode) and (s[pos1]='\'))  then begin
        if offset<>2 then inc(pos2);
        count:=pos2-1;
        end
      else if ((mode<>uuencode) and (s[pos1]='^')) then   (* illegal char in source *)
        inc(pos1)  (* skip char, prevent endless loop jane :*)
      else if offset>0 then begin
        out[pos2]:=char(ord(out[pos2]) or (ord(s[pos1]) shl offset));
        inc(pos1);
        offset:=offset-6;
        end
      else if offset<0 then begin
        offset:=abs(offset);
        out[pos2]:=char(ord(out[pos2]) or (ord(s[pos1]) shr offset));
        inc(pos2);
        offset:=8-offset;
        end
      else begin
        out[pos2]:=char(ord(out[pos2]) or ord(s[pos1]));
        inc(pos1);
        inc(pos2);
        offset:=2;
        end;
      end;
    end;
  decode_line:=copy(out,1,count);
  end;
(*@\\\0000001101*)
(*@/// function encode_line(mode:t_encoding; const buf; size:integer):string; *)
function encode_line(mode:t_encoding; const buf; size:integer):string;
var
  buff: ta_8u absolute buf;
  offset: shortint;
  pos1,pos2: byte;
  i: byte;
  out: string;
begin
  setlength(out,size*4 div 3 + 4);
  fillchar(out[1],size*4 div 3 +2,#0);   (* worst case *)
  if mode=uuencode then begin
    out[1]:=char(((size-1) and $3f)+$21);
    size:=((size+2) div 3)*3;
    end;
  offset:=2;
  pos1:=0;
  pos2:=0;   (* Delphi 2 Shut up! *)
  case mode of
    uuencode:     pos2:=2;
    base64, mime: pos2:=1;
  end;
  out[pos2]:=#0;
(*@///   while pos1<size do begin ... end;     Das eigentliche Encoding *)
while pos1<size do begin
  if offset > 0 then begin
    out[pos2]:=char(ord(out[pos2]) or ((buff[pos1] and ($3f shl offset)) shr offset));
    offset:=offset-6;
    inc(pos2);
    out[pos2]:=#0;
    end
  else if offset < 0 then begin
    offset:=abs(offset);
    out[pos2]:=char(ord(out[pos2]) or ((buff[pos1] and ($3f shr offset)) shl offset));
    offset:=8-offset;
    inc(pos1);
    end
  else begin
    out[pos2]:=char(ord(out[pos2]) or ((buff[pos1] and $3f)));
    inc(pos2);
    inc(pos1);
    out[pos2]:=#0;
    offset:=2;
    end;
  end;
(*@\\\0000000D01*)
  case mode of
(*@///     uuencode: *)
uuencode: begin
  if offset=2 then dec(pos2);
  for i:=2 to pos2 do
    out[i]:=bin2uue[ord(out[i])+1];
  end;
(*@\\\0000000401*)
(*@///     base64, mime: *)
base64, mime: begin
  if offset=2 then dec(pos2);
  for i:=1 to pos2 do
    out[i]:=bin2b64[ord(out[i])+1];
  while (pos2 and 3)<>0  do begin
    inc(pos2);
    out[pos2]:='=';
    end;
  end;
(*@\\\0000000301*)
    end;
  encode_line:=copy(out,1,pos2);
  end;
(*@\\\0000001A0E*)

(*@/// function encode_base64(data: TStream):TStringList; *)
function encode_base64(data: TStream):TStringList;
var
  buf: pointer;
  size: integer;
begin
  buf:=NIL;
{   result:=NIL; }
  try
    result:=TStringList.Create;
    getmem(buf,linesize);
    data.seek(0,0);
    size:=linesize;
    while size>0 do begin
      size:=data.read(buf^,linesize);
      if size>0 then
        result.add(encode_line(base64,buf^,size));
      end;
  finally
    if buf<>NIL then
      freemem(buf,linesize);
    end;
  end;
(*@\\\0000000201*)
(*@/// function decode_base64(source:TStringList):TMemoryStream; *)
function decode_base64(source:TStringList):TMemoryStream;
var
  i: integer;
  s: string;
begin
  result:=TMemoryStream.Create;
  for i:=0 to source.count-1 do begin
    s:=decode_line(base64,source[i]);
    result.write(s[1],length(s));
    end;
  end;
(*@\\\0000000701*)

(*@/// function eight2seven_quoteprint(const s:string):string; *)
function eight2seven_quoteprint(const s:string):string;
var
  i: integer;
begin
  result:='';
  for i:=1 to length(s) do
    case s[i] of
      '=',#$80..#$FF: result:=result+'='+uppercase(inttohex(ord(s[i]),2));
      else            result:=result+s[i];
      end;
  end;
(*@\\\0000000201*)
(*@/// function eight2seven_german(const s:string):string; *)
function eight2seven_german(const s:string):string;
var
  i: integer;
begin
  result:='';
  for i:=1 to length(s) do
    case s[i] of
      #192..#195,#197: result:=result+'A';
      #196,#198:       result:=result+'Ae';
      #199:            result:=result+'C';
      #200..#203:      result:=result+'E';
      #204..#207:      result:=result+'I';
      #209:            result:=result+'N';
      #210..#213,#216: result:=result+'O';
      #214:            result:=result+'Oe';
      #217..#219:      result:=result+'U';
      #220:            result:=result+'Ue';
      #221:            result:=result+'Y';
      #223:            result:=result+'ss';
      #224..#227,#229: result:=result+'a';
      #228,#230:       result:=result+'ae';
      #231:            result:=result+'c';
      #232..#235:      result:=result+'e';
      #236..#239:      result:=result+'i';
      #241:            result:=result+'n';
      #242..#245,#248: result:=result+'o';
      #246:            result:=result+'oe';
      #249..#251:      result:=result+'u';
      #252:            result:=result+'ue';
      #255:            result:=result+'y';
      #0..#60,#62..#127: result:=result+s[i];
      else result:=result+'='+uppercase(inttohex(ord(s[i]),2));
      end;
  end;
(*@\\\*)
(*@/// function seven2eight_quoteprint(const s:string):string; *)
function seven2eight_quoteprint(const s:string):string;
var
  i: integer;
begin
  result:='';
  i:=0;
  while i<length(s) do begin
    inc(i);
    case s[i] of
      '=': try
          result:=result+char(strtoint('$'+s[i+1]+s[i+2]));
          i:=i+2;
        except
          result:=result+'=';
        end;
      else    result:=result+s[i];
      end;
    end;
  end;
(*@\\\0000001209*)


(*@/// function my_hostname:string; *)
function my_hostname:string;
const
  bufsize=255;
var
  buf: pointer;
  RemoteHost : PHostEnt; (* No, don't free it! *)
begin
  buf:=NIL;
  my_hostname:='';
  try
    getmem(buf,bufsize);
    winsock.gethostname(buf,bufsize);   (* this one maybe without domain *)
    if char(buf^)<>#0 then begin
      RemoteHost:=Winsock.GetHostByName(buf);
      if RemoteHost<>NIL then
(*$ifdef ver80 *)
        my_hostname:=strpas(pchar(RemoteHost^.h_name))
(*$else *)
        my_hostname:=pchar(RemoteHost^.h_name)
(*$endif *)
      else my_hostname:='127.0.0.1';    (* no Hostname received *)
      end
    else my_hostname:='127.0.0.1';      (* no Hostname received *)
  finally
    if buf<>NIL then  freemem(buf,bufsize);
    end;
  end;
(*@\\\*)
(*@/// function my_ip_address:longint; *)
function my_ip_address:longint;
const
  bufsize=255;
var
  buf: pointer;
  RemoteHost : PHostEnt; (* No, don't free it! *)
begin
  buf:=NIL;
  try
    getmem(buf,bufsize);
    winsock.gethostname(buf,bufsize);   (* this one maybe without domain *)
    RemoteHost:=Winsock.GetHostByName(buf);
    if RemoteHost=NIL then
      my_ip_address:=winsock.htonl($7F000001)  (* 127.0.0.1 *)
    else
      my_ip_address:=longint(pointer(RemoteHost^.h_addr_list^)^);
  finally
    if buf<>NIL then  freemem(buf,bufsize);
    end;
  end;
(*@\\\0030000E01000E01000E01*)
(*@/// function internet_date(date: TDateTime):string; *)
function internet_date(date: TDateTime):string;
(*@/// function myinttostr(value:integer; len:byte):string; *)
function myinttostr(value:integer; len:byte):string;
begin
  myinttostr:=inttostr(value);
  while length(result)<len do
    result:='0'+result;
  end;
(*@\\\*)
(*@/// function timezone:string; *)
function timezone:string;
var
  bias: longint;
begin
  bias:=TimeZoneBias;
  if bias=0 then
    timezone:='GMT'
  else if bias<0 then
    timezone:='+' + myinttostr(abs(bias) div 60,2)
                  + myinttostr(abs(bias) mod 60,2)
  else if bias>0 then
    timezone:='-' + myinttostr(bias div 60,2)
                  + myinttostr(bias mod 60,2);
  end;
(*@\\\*)
var
  d,m,y,w,h,mm,s,ms: word;
const
  weekdays:array[1..7] of string[3]=('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
  months:array[1..12] of string[3]=('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
begin
  decodedate(date,y,m,d);
  decodetime(date,h,mm,s,ms);
  w:=dayofweek(date);
  internet_date:=weekdays[w]+', '+inttostr(d)+' '+months[m]+' '+inttostr(y)+' '+
     myinttostr(h,2)+':'+myinttostr(mm,2)+':'+myinttostr(s,2)+' '+timezone;
  end;
(*@\\\0000000201*)
(*@/// function ip2string(ip_address:longint):string; *)
function ip2string(ip_address:longint):string;
begin
  ip_address:=winsock.ntohl(ip_address);
  result:= inttostr(ip_address shr 24)+'.'+
           inttostr((ip_address shr 16) and $ff)+'.'+
           inttostr((ip_address shr 8) and $ff)+'.'+
           inttostr(ip_address and $ff);
  end;
(*@\\\0000000401*)

(*@/// function address_from(const s:string; count: integer):string; *)
function address_from(const s:string; count: integer):string;
var
  p, ca, sp, co, se: integer;
begin
  (* search the count'th @ *)
  ca:=posn('@',s,count);
  if (ca=0) or (ca>length(s)) then
    result:=''
  else begin
    (* search for delimiting char before the @ *)
    sp:=posn(' ',copy(s,1,ca),-1);
    co:=posn(',',copy(s,1,ca),-1);
    se:=posn(';',copy(s,1,ca),-1);
    p:=0;
    if (sp<ca) and (sp>p) then  p:=sp;
    if (co<ca) and (co>p) then  p:=co;
    if (se<ca) and (se>p) then  p:=se;
    result:=copy(s,p+1,length(s));
    (* search for delimiting char after the @ *)
    sp:=posn(' ',result,1)-1;
    co:=posn(',',result,1)-1;
    se:=posn(';',result,1)-1;
    ca:=length(result);
    p:=ca+1;
    if (sp<p) and (sp>0) and (sp<ca) then  p:=sp;
    if (co<p) and (co>0) and (co<ca) then  p:=co;
    if (se<p) and (se>0) and (se<ca) then  p:=se;
    result:=copy(result,1,p-1);
    while result[1] in ['"','(','<'] do
      result:=copy(result,2,length(result));
    while result[length(result)] in ['"',')','>'] do
      result:=copy(result,1,length(result)-1);
    end;
  end;
(*@\\\0000001F35*)

(*@/// function lookup_hostname(const hostname:string):longint; *)
function lookup_hostname(const hostname:string):longint;
var
  RemoteHost : PHostEnt;  (* no, don't free it! *)
  ip_address: longint;
(*$ifdef ver80 *)
  s: string;
(*$else *)
(*$ifopt h- *)
  s: string;
(*$endif *)
(*$endif *)
begin
  ip_address:=INVALID_IP_ADDRESS;
  try
    if hostname='' then begin  (* no host given! *)
      lookup_hostname:=ip_address;
      EXIT;
      end
    else begin
(*@///       ip_address:=Winsock.Inet_Addr(PChar(hostname));  { try a xxx.xxx.xxx.xx first } *)
(*$ifdef ver80 *)
  s:=hostname+#0;
  ip_address:=Winsock.Inet_Addr(PChar(@s[1]));  (* try a xxx.xxx.xxx.xx first *)
(*$else *)
 (*$ifopt h- *)
  s:=hostname+#0;
  ip_address:=Winsock.Inet_Addr(PChar(@s[1]));  (* try a xxx.xxx.xxx.xx first *)
 (*$else *)
  ip_address:=Winsock.Inet_Addr(PChar(hostname));  (* try a xxx.xxx.xxx.xx first *)
 (*$endif *)
(*$endif *)
(*@\\\*)
      if ip_address=SOCKET_ERROR then begin
(*@///         RemoteHost:=Winsock.GetHostByName(PChar(hostname)); *)
(*$ifdef ver80 *)
  RemoteHost:=Winsock.GetHostByName(PChar(@s[1]));
(*$else *)
 (*$ifopt h- *)
  RemoteHost:=Winsock.GetHostByName(PChar(@s[1]));
 (*$else *)
  RemoteHost:=Winsock.GetHostByName(PChar(hostname));
 (*$endif *)
(*$endif *)
(*@\\\000000090C*)
        if (RemoteHost=NIL) or (RemoteHost^.h_length<=0) then begin
          lookup_hostname:=ip_address;
          EXIT;  (* host not found *)
          end
        else
          ip_address:=longint(pointer(RemoteHost^.h_addr_list^)^);
            (* use the first address given *)
        end;
      end;
  except
    ip_address:=INVALID_IP_ADDRESS;
    end;
  lookup_hostname:=ip_address;
  end;
(*@\\\0000001601*)
(*@/// function resolve_hostname(ip: longint):string; *)
function resolve_hostname(ip: longint):string;
var
  RemoteHost : PHostEnt; (* No, don't free it! *)
  ip_address: longint;
begin
  ip_address:=ip;
  RemoteHost:=Winsock.GetHostByAddr(@ip_address,4,pf_inet);
  if RemoteHost<>NIL then
(*$ifdef ver80 *)
    resolve_hostname:=strpas(pchar(RemoteHost^.h_name))
(*$else *)
    resolve_hostname:=pchar(RemoteHost^.h_name)
(*$endif *)
  else
    resolve_hostname:=ip2string(ip_address);
  end;
(*@\\\0000001007*)

{ Initialize and clean up the winsock DLL }
(*@/// procedure init; *)
procedure init;
var
  point: TWSAData;
begin
  tcpip_ready:=false;
  if @Winsock.WSAStartup<>NIL then
    case Winsock.WSAStartup($0101,point) of
      WSAEINVAL, WSASYSNOTREADY, WSAVERNOTSUPPORTED: ;
      else tcpip_ready:=true;
      end;
  end;
(*@\\\0000000503*)
(*@/// procedure shutdown; FAR; *)
procedure shutdown; FAR;
begin
  if tcpip_ready then begin
    Winsock.WSACancelBlockingCall;
    Winsock.WSACleanup;
    end;
  end;
(*@\\\0000000601*)
(*@\\\0000000501*)
(*@/// initialization *)
(*$ifdef ver80 *)
begin
(*$else *)
initialization
begin
(*$endif *)
  init;
(*@\\\*)
(*@/// finalization *)
(*$ifdef ver80 *)
  AddExitProc(Shutdown);
(*$else *)
  end;
finalization
  Shutdown;
(*$endif *)
(*@\\\000000070C*)
end.
(*@\\\0000000305*)
