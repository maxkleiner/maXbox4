unit pwerrors; {$ifdef fpc}{$mode objfpc}{$h+}{$endif}

interface
uses 
  pwtypes;
  
type
  errcode = word; // incase we have more than 255 errors, word allows plenty

const
  GENERAL_ERR = 0;
  OK = 1;  
  FILE_READ_ERR = 2; // file not found or can't open
  CFG_PARSE_ERR = 3;

const
  CANT_READ_CFG_FILE = '1A: can''t read cfg file';
  MISSING_INIT_CALL_OR_UNIT = 'missing Init() call or unit';



function errtostr(e: errcode): astr;

implementation  

function errtostr(e: errcode): astr;
begin
  case e of
    GENERAL_ERR: result:= 'general err';
    OK: result:= 'ok';
    FILE_READ_ERR: result:= 'file read err';
    CFG_PARSE_ERR: result:= 'cfg parse err';
  end;
end;


end.
  
  
