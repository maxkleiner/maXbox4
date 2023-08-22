
// if debugging is enabled in compilation
 {$ifdef VERBOSE_ERROR}
    if LibPath = '' then
      ThrowLibError('ERR: Path NIL')
    else if LibPath = '-1NF' then
      ThrowLibError(PWU_CONFIG_FILE + ' not found')
    else
      ThrowLibError('ERR: "#" not found or incorrect position in ' + LibPath);
 {$endif}
