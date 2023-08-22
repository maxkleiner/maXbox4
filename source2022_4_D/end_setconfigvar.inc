  {$IFDEF DEBUGLN_ON} debugln('SetConfigVar end'); {$ENDIF}
  exit;

  error1:
  begin
    ThrowWarn('header charset can''t be set after headers sent');
    {$IFDEF DBUG_ON}debugln('SetCfgVar: ERR1: header_charset can''t be set after headers sent');{$ENDIF}
    exit;
  end;

  error2:
  begin
    ThrowWarn('output compression needs output_buffering on');
    {$IFDEF DBUG_ON}debugln('SetCfgVar: ERR2: output_compression can''t be set without out output_buffering');{$ENDIF}
    exit;
  end;

  error3:
  begin
    ThrowWarn('output compression can''t be unset after headers sent');
    {$IFDEF DBUG_ON}debugln('SetCfgVar: ERR3: output_compression can''t be unset after headers sent');{$ENDIF}
    exit;
  end;

  error4:
  begin
    ThrowWarn('session path/lifetime can''t be set after headers sent');
    {$IFDEF DBUG_ON}debugln('SetCfgVar: ERR4: session_path/lifetime can''t be set after headers sent');{$ENDIF}
    exit;
  end;

  error5:
  begin
    ThrowWarn('upload max size can''t be set after headers sent');
    {$IFDEF DBUG_ON}debugln('SetCfgVar: ERR5: upload_max_size can''t be set after headers sent');{$ENDIF}
    exit;
  end;

  error6:
  begin
    ThrowWarn('session cfg can''t be set without session unit');
    {$IFDEF DBUG_ON}debugln('SetCfgVar: ERR6: session cfg can''t be set without session unit');{$ENDIF}
    exit;
  end;
