// delphi system compat problems
{$IFNDEF FPC}
function uppercase(const s: string): string;
var len, i: Integer; p: PChar;
begin
  result:= S; uniqueString(Result);
  p:=Pchar(Result);
  len:= length(result);
  for i := 1 to len do begin
    if (p^ in ['a'..'z']) then P^ := char(byte(p^) - 32); inc(p);
  end;
end;

 function lowercase(const s: astr): astr;
 var len, i: integer; p: PChar;
 begin
   result:= S; uniquestring(result);
   p:= Pchar(result); len:= length(result);
   for i:= 1 to len do begin
     if (p^ in ['A'..'Z']) then p^:= char(byte(p^) + 32); inc(p);
   end;
 end;

 procedure val(s: astr; var i: longint); overload;
 var dummy: integer;
 begin
   system.val(s, i, dummy);
 end;

 procedure val(s: astr; var i: longword); overload;
 var dummy: integer;
 begin
   system.val(s, i, dummy);
 end;

 procedure val(s: astr; var i: double); overload;
 var dummy: integer;
 begin
   system.val(s, i, dummy);
 end;
                            
 function BoolToStr(b:bln):astr;
 begin
   if b = true then result:='TRUE';
   if b = false then result:='FALSE';
 end;
{$ENDIF}
