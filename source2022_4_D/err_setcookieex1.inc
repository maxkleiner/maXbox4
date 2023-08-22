begin
  ThrowErr('Can''t set cookie: headers already sent');
  {$IFDEF DEBUGLN_ON} debugln('SetCookieEx:ERR1: Can''t set cookie: headers already sent'); {$ENDIF}
  exit;
end;
