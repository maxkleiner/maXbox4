begin
  ThrowErr('Can''t set cookie, headers already sent');
  {$IFDEF DEBUGLN_ON} debugln('SetCookie exit 1'); {$ENDIF}
  exit;
end;