unit uPSI_uPSUtils;
{
  step to support byte code compile!
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
  TPSImport_uPSUtils = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TPSPascalParser(CL: TPSPascalCompiler);
procedure SIRegister_TPSUnitList(CL: TPSPascalCompiler);
procedure SIRegister_TPSUnit(CL: TPSPascalCompiler);
procedure SIRegister_TPSStringList(CL: TPSPascalCompiler);
procedure SIRegister_TPSList(CL: TPSPascalCompiler);
procedure SIRegister_uPSUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TPSPascalParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSUnitList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSUnit(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSStringList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TPSList(CL: TPSRuntimeClassImporter);
procedure RIRegister_uPSUtils_Routines(S: TPSExec);
procedure RIRegister_uPSUtils(CL: TPSRuntimeClassImporter);

//procedure WaveOutProc(hwo: HWAVEOUT; uMsg: integer; dwParam1,dwParam2: integer);


procedure Register;

implementation


uses
   Windows
  ,uPSUtils, DBTables, ComCtrls, Graphics, mmsystem, ImageHlp;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_uPSUtils]);
end;

function ChangeAlpha(input: string): string;
var
  a: byte;//Char;
begin
  Result:= input;
  for a:= ord('A') to ord('Z') do begin
    Result:= StringReplace(Result,Chr(a), IntToStr(Ord(a)- 55),[rfReplaceAll]);
  end;
end;

function ChangeAlphaTo(input: string; aoffset: byte): string;
var
  a: byte;//Char;
begin
  Result:= input;
  for a:= ord('A') to ord('Z') do begin
    Result:= StringReplace(Result,Chr(a),
               IntToStr(Ord(a)- aoffset),[rfReplaceAll]);
  end;
end;



function CalculateDigits(iban: string): Integer;
var
  v, l: Integer;
  alpha: string;
  number: Longint;
  rest: Integer;
begin
  iban := UpperCase(iban);
  if Pos('IBAN', iban) > 0 then
    Delete(iban, Pos('IBAN', iban), 4);
  iban := iban + Copy(iban, 1, 4);
  Delete(iban, 1, 4);
  iban := ChangeAlpha(iban);
  v := 1;
  l := 9;
  rest := 0;
  alpha := '';
  try
    while v <= Length(iban) do begin
      if l > Length(iban) then
        l := Length(iban);
      alpha := alpha + Copy(iban, v, l);
      number := StrToInt(alpha);
      rest := number mod 97;
      v := v + l;
      alpha := IntToStr(rest);
      l := 9 - Length(alpha);
    end;
  except
    rest := 0;
  end;
  Result := rest;
end;


function CheckIBAN(iban: string): Boolean;
begin
  iban := StringReplace(iban, ' ', '', [rfReplaceAll]);
  if CalculateDigits(iban) = 1 then
    Result := True
  else
    Result := False;
end;


procedure SQLDropField(dbName,
                       tblName,   {Database Name}  {Table Name}
                       fldName         : String);  {Field Name to Drop}
var
  sqlDrpFld: TQuery;
begin
  sqlDrpFld:= TQuery.Create(NIL);
  with sqlDrpFld do begin
    DatabaseName:= dbName;
    SQL.Add('ALTER TABLE ' + tblName + ' DROP ' + fldName);
    try
      try
        ExecSQL;
      except
        Abort; {Just raise silent exception}
      end;
    finally
      Free;
    end;
  end;
end;


type TCastType = (ctSmallInt, ctInteger, ctDecimal, ctNumeric, ctFloat,
               ctChar, ctVarChar, ctDate, ctBoolean, ctBLOB, ctTime,
               ctTimeStamp, ctMoney, ctAutoInc, ctBytes);

procedure SQLAddField(dbName,
                      tblName,    {Database Name}  {Table Name}
                      fldName         : String;    {Field Name to Add}
                      fldType         : TCastType; {Field Type as described above}
                      fldLength,                   {Length of Field}
                      precisOrBlobLen,
                      scaleOrBlobType : Integer);  {Blob definition type 1 = Memo, 2 = Binary,       3 = Formatted Memo, 4 = OLE Object, 5 = Graphic}
var
  sqlAddFld: TQuery;
  CastType : String;

begin
  case fldType of
    ctSmallInt  : CastType := 'SMALLINT';
    ctInteger   : CastType := 'INTEGER';
    ctDecimal   : CastType := 'DECIMAL(' + IntToStr(precisOrBlobLen) + ',' +
                                           IntToStr(scaleOrBlobType) + ')';
    ctNumeric   : CastType := 'NUMERIC(' + IntToStr(precisOrBlobLen) + ',' +
                                           IntToStr(scaleOrBlobType) + ')';
    ctFloat     : CastType := 'FLOAT('   + IntToStr(precisOrBlobLen) + ',' +
                                           IntToStr(scaleOrBlobType) + ')';
    ctChar      : CastType := 'CHARACTER(' + IntToStr(fldLength) + ')';
    ctVarChar   : CastType := 'VARCHAR(' + IntToStr(fldLength) + ')';
    ctDate      : CastType := 'DATE';
    ctBoolean   : CastType := 'BOOLEAN';
    ctBlob      : CastType := 'BLOB('    + IntToStr(precisOrBlobLen) + ',' +
                                           IntToStr(scaleOrBlobType) + ')';
    ctTime      : CastType := 'TIME';
    ctTimeStamp : CastType := 'TIMESTAMP';
    ctMoney     : CastType := 'MONEY';
    ctAutoInc   : CastType := 'AUTOINC';
    ctBytes     : CastType := 'BYTES(' + IntToStr(fldLength) + ')'
  end;

  sqlAddFld:= TQuery.Create(NIL);
  with sqlAddFld do begin
    DatabaseName := dbName;
    SQL.Add('ALTER TABLE ' + tblName + ' ADD ' + fldName + ' ' + CastType);
    try
      try
        ExecSQL;
      except
        Abort; {Just raise a silent exception}
      end;
    finally
      Free;
    end;
  end;
end;

{ HTML to RTF by Falk Schulze }

procedure HTMLtoRTF(html: string; var rtf: TRichedit);
var
  i, dummy, row: Integer;
  cfont: TFont; { Standard sschrift }
  Tag, tagparams: string;
  params: TStringList;

  function GetTag(s: string; var i: Integer; var Tag, tagparams: string): Boolean;
  var 
    a_tag: Boolean;
  begin
    GetTag  := False;
    Tag  := '';
    tagparams := '';
    a_tag  := False;

    while i <= Length(s) do 
    begin
      Inc(i);
      // es wird nochein tag geöffnet --> das erste war kein tag;
      if s[i] = '<' then 
      begin
        GetTag := False;
        Exit;
      end;

      if s[i] = '>' then
      begin
        GetTag := True;
        Exit;
      end;

      if not a_tag then 
      begin
        if s[i] = ' ' then
        begin
          if Tag <> '' then a_tag := True;
        end
        else 
          Tag := Tag + s[i];
      end 
      else
        tagparams := tagparams + s[i];
    end;
  end;

  procedure GetTagParams(tagparams: string; var params: TStringList);
  var 
    i: Integer;
    s: string;
    gleich: Boolean;

    // kontrolliert ob nach dem zeichen bis zum nächsten zeichen ausser
    // leerzeichen ein Ist-Gleich-Zeichen kommt
    function notGleich(s: string; i: Integer): Boolean;
    begin
      notGleich := True;
      while i <= Length(s) do 
      begin
        Inc(i);
        if s[i] = '=' then 
        begin
          notGleich := False;
          Exit;
        end 
        else if s[i] <> ' ' then Exit;
      end;
    end;
  begin
    Params.Clear;
    s := '';
    for i := 1 to Length(tagparams) do 
    begin
      if (tagparams[i] <> ' ') then 
      begin
        if tagparams[i] <> '=' then gleich := False;
        if (tagparams[i] <> '''') and (tagparams[i] <> '"') then s := s + tagparams[i]
      end 
      else 
      begin
        if (notGleich(tagparams, i)) and (not Gleich) then 
        begin
          params.Add(s);
          s := '';
        end 
        else 
          Gleich := True;
      end;
    end;
    params.Add(s);
  end;

  function HtmlToColor(Color: string): TColor;
  begin
    Result := StringToColor('$' + Copy(Color, 6, 2) + Copy(Color, 4,
      2) + Copy(Color, 2, 2));
  end;

  procedure TransformSpecialChars(var s: string; i: Integer);
  var
    c: string;
    z, z2: Byte;
    i2: Integer;
  const 
    nchars = 9;
    chars: array[1..nchars, 1..2] of string =
      (('Ö', 'Ö'), ('ö', 'ö'), ('Ä', 'Ä'), ('ä', 'ä'),
      ('Ü', 'Ü'), ('ü', 'ü'), ('ß', 'ß'), ('<', '<'),
      ('>', '>'));
  begin
    // Maximal die nächsten 7 zeichen auf sonderzeichen überprüfen
    c  := '';
    i2 := i;
    for z := 1 to 7 do 
    begin
      c := c + s[i2];
      for z2 := 1 to nchars do 
      begin
        if chars[z2, 1] = c then 
        begin
          Delete(s, i, Length(c));
          Insert(chars[z2, 2], s, i);
          Exit;
        end;
      end;
      Inc(i2);
    end;
  end;

  // HtmlTag Schriftgröße in pdf größe umwandeln
  function CalculateRTFSize(pt: Integer): Integer;
  begin
    case pt of
      1: Result := 6;
      2: Result := 9;
      3: Result := 12;
      4: Result := 15;
      5: Result := 18;
      6: Result := 22;
      else 
        Result := 30;
    end;
  end;


  // Die Font-Stack Funktionen
type 
  fontstack = record
    Font: array[1..100] of tfont;
    Pos: Byte;
  end;

  procedure CreateFontStack(var s: fontstack);
  begin
    s.Pos := 0;
  end;

  procedure PushFontStack(var s: Fontstack; fnt: TFont);
  begin
    Inc(s.Pos);
    s.Font[s.Pos] := TFont.Create;
    s.Font[s.Pos].Assign(fnt);
  end;

  procedure PopFontStack(var s: Fontstack; var fnt: TFont);
  begin
    if (s.Font[s.Pos] <> nil) and (s.Pos > 0) then 
    begin
      fnt.Assign(s.Font[s.Pos]);
      // vom stack nehmen
      s.Font[s.Pos].Free;
      Dec(s.Pos);
    end;
  end;

  procedure FreeFontStack(var s: Fontstack);
  begin
    while s.Pos > 0 do 
    begin
      s.Font[s.Pos].Free;
      Dec(s.Pos);
    end;
  end;
var 
  fo_cnt: array[1..1000] of tfont;
  fo_liste: array[1..1000] of Boolean;
  fo_pos: TStringList;
  fo_stk: FontStack;
  wordwrap, liste: Boolean;
begin
  CreateFontStack(fo_Stk);

  fo_Pos := TStringList.Create;

  rtf.Lines.BeginUpdate;
  rtf.Lines.Clear;
  // Das wordwrap vom richedit merken
  wordwrap  := rtf.wordwrap;
  rtf.WordWrap := False;


  // erste Zeile hinzufügen
  rtf.Lines.Add('');
  Params := TStringList.Create;



  cfont := TFont.Create;
  cfont.Assign(rtf.Font);


  i := 1;
  row := 0;
  Liste := False;
  // Den eigentlichen Text holen und die Formatiorung merken
  rtf.selstart := 0;
  if Length(html) = 0 then Exit;
  repeat;


    if html[i] = '<' then 
    begin
      dummy := i;
      GetTag(html, i, Tag, tagparams);
      GetTagParams(tagparams, params);

      // Das Font-Tag
      if Uppercase(Tag) = 'FONT' then
      begin
        // Schrift auf fontstack sichern
        pushFontstack(fo_stk, cfont);
        if params.Values['size'] <> '' then
          cfont.Size := CalculateRTFSize(StrToInt(params.Values['size']));

        if params.Values['color'] <> '' then cfont.Color :=
            htmltocolor(params.Values['color']);
      end 
      else if Uppercase(Tag) = '/FONT' then  popFontstack(fo_stk, cfont) 
      else // Die H-Tags-Überschriften
      if Uppercase(Tag) = 'H1' then 
      begin
        // Schrift auf fontstack sichern
        pushFontstack(fo_stk, cfont);
        cfont.Size := 6;
      end 
      else if Uppercase(Tag) = '/H1' then  popFontstack(fo_stk, cfont) 
      else // Die H-Tags-Überschriften
      if Uppercase(Tag) = 'H2' then 
      begin
        // Schrift auf fontstack sichern
        pushFontstack(fo_stk, cfont);
        cfont.Size := 9;
      end 
      else if Uppercase(Tag) = '/H2' then  popFontstack(fo_stk, cfont) 
      else // Die H-Tags-Überschriften
      if Uppercase(Tag) = 'H3' then 
      begin
        // Schrift auf fontstack sichern
        pushFontstack(fo_stk, cfont);
        cfont.Size := 12;
      end 
      else if Uppercase(Tag) = '/H3' then  popFontstack(fo_stk, cfont)
      else // Die H-Tags-Überschriften
      if Uppercase(Tag) = 'H4' then 
      begin
        // Schrift auf fontstack sichern
        pushFontstack(fo_stk, cfont);
        cfont.Size := 15;
      end 
      else if Uppercase(Tag) = '/H4' then  popFontstack(fo_stk, cfont) 
      else // Die H-Tags-Überschriften
      if Uppercase(Tag) = 'H5' then 
      begin
        // Schrift auf fontstack sichern
        pushFontstack(fo_stk, cfont);
        cfont.Size := 18;
      end 
      else if Uppercase(Tag) = '/H5' then  popFontstack(fo_stk, cfont) 
      else // Die H-Tags-Überschriften
      if Uppercase(Tag) = 'H6' then 
      begin
        // Schrift auf fontstack sichern
        pushFontstack(fo_stk, cfont);
        cfont.Size := 22;
      end 
      else if Uppercase(Tag) = '/H6' then  popFontstack(fo_stk, cfont) 
      else // Die H-Tags-Überschriften
      if Uppercase(Tag) = 'H7' then 
      begin
        // Schrift auf fontstack sichern
        pushFontstack(fo_stk, cfont);
        cfont.Size := 27;
      end 
      else if Uppercase(Tag) = '/H7' then  popFontstack(fo_stk, cfont)
      else // Bold-Tag

      if Uppercase(Tag) = 'B' then cfont.Style := cfont.Style + [fsbold] 
      else if Uppercase(Tag) = '/B' then cfont.Style := cfont.Style - [fsbold] 
      else // Italic-Tag

      if Uppercase(Tag) = 'I' then cfont.Style := cfont.Style + [fsitalic] 
      else if Uppercase(Tag) = '/I' then cfont.Style := cfont.Style - [fsitalic] 
      else // underline-Tag

      if Uppercase(Tag) = 'U' then cfont.Style := cfont.Style + [fsunderline] 
      else if Uppercase(Tag) = '/U' then cfont.Style := cfont.Style - [fsunderline] 
      else // underline-Tag

      if Uppercase(Tag) = 'UL' then liste := True 
      else if Uppercase(Tag) = '/UL' then 
      begin
        liste := False;
        rtf.Lines.Add('');
        Inc(row);
        rtf.Lines.Add('');
        Inc(row);
      end 
      else // BR - Breakrow tag

      if (Uppercase(Tag) = 'BR') or (Uppercase(Tag) = 'LI') then 
      begin
        rtf.Lines.Add('');
        Inc(row);
      end;

      // unbekanntes tag als text ausgeben
      // else rtf.Lines[row]:=RTF.lines[row]+'<'+tag+' '+tagparams+'>';

      fo_pos.Add(IntToStr(rtf.selstart));
      fo_cnt[fo_pos.Count] := TFont.Create;
      fo_cnt[fo_pos.Count].Assign(cfont);
      fo_liste[fo_pos.Count] := liste;
    end 
    else 
    begin
      // Spezialzeichen übersetzen
      if html[i] = '&' then Transformspecialchars(html, i);

      if (Ord(html[i]) <> 13) and (Ord(html[i]) <> 10) then
        rtf.Lines[row] := RTF.Lines[row] + html[i];
    end;

    Inc(i);

  until i >= Length(html);
  // dummy eintragen
  fo_pos.Add('999999');

  // Den fertigen Text formatieren
  for i := 0 to fo_pos.Count - 2 do 
  begin
    rtf.SelStart := StrToInt(fo_pos[i]);
    rtf.SelLength := StrToInt(fo_pos[i + 1]) - rtf.SelStart;
    rtf.SelAttributes.Style := fo_cnt[i + 1].Style;
    rtf.SelAttributes.Size := fo_cnt[i + 1].Size;
    rtf.SelAttributes.Color := fo_cnt[i + 1].Color;

    // die font wieder freigeben;
    fo_cnt[i + 1].Free;
  end;

  // die Paragraphen also Listen setzen
  i := 0;
  while i <= fo_pos.Count - 2 do 
  begin
    if fo_liste[i + 1] then 
    begin
      rtf.SelStart := StrToInt(fo_pos[i + 1]);
      while fo_liste[i + 1] do Inc(i);
      rtf.SelLength := StrToInt(fo_pos[i - 1]) - rtf.SelStart;
      rtf.Paragraph.Numbering := nsBullet;
    end;
    Inc(i);
  end;
  rtf.Lines.EndUpdate;
  Params.Free;
  cfont.Free;
  rtf.WordWrap := wordwrap;
  FreeFontStack(fo_stk);
end;


const
  WM_FINISHED = $400 {WM_USER} + $200;
var fWaveOutHandle: HWAVEOUT;


procedure waveOutPrc(hwo: HWAVEOUT; uMsg: UINT; dwInstance,
  dwParam1, dwParam2: DWORD); stdcall;
begin
  //TForm1(dwInstance).WaveOutProc(hwo, uMsg, dwParam1, dwParam2)
end;

procedure WaveOutProc(hwo: HWAVEOUT; uMsg: UINT; dwParam1,dwParam2: DWORD);
begin
  case uMsg of
    WOM_OPEN:;
    WOM_CLOSE:
      fWaveOutHandle := 0;
    WOM_DONE:
      PostMessage(0, WM_FINISHED, 0, 0);
  end
end;

procedure Interchange(hpchPos1, hpchPos2: PChar; wLength: Word);
var
  wPlace: word;
  bTemp: char;
begin
  for wPlace := 0 to wLength - 1 do begin
    bTemp := hpchPos1[wPlace];
    hpchPos1[wPlace] := hpchPos2[wPlace];
    hpchPos2[wPlace] := bTemp
  end
end;


procedure ReversePlay(const szFileName: string);
var
  mmioHandle: HMMIO;
  mmckInfoParent: MMCKInfo;
  mmckInfoSubChunk: MMCKInfo;
  dwFmtSize, dwDataSize: DWORD;
  pFormat: PWAVEFORMATEX;
  wBlockSize: word;
  hpch1, hpch2: PChar;
  fData: PChar;
    fWaveHdr: PWAVEHDR;
//    fWaveOutHandle: HWAVEOUT;


begin
  { The mmioOpen function opens a file for unbuffered or buffered I/O }
  mmioHandle := mmioOpen(PChar(szFileName), nil, MMIO_READ or MMIO_ALLOCBUF);
  if mmioHandle = 0 then
    raise Exception.Create('Unable to open file ' + szFileName);

  try
    { mmioStringToFOURCC converts a null-terminated string to a four-character code }
    mmckInfoParent.fccType := mmioStringToFOURCC('WAVE', 0);
    { The mmioDescend function descends into a chunk of a RIFF file }
    if mmioDescend(mmioHandle, @mmckinfoParent, nil, MMIO_FINDRIFF) <>
      MMSYSERR_NOERROR then raise Exception.Create(szFileName + ' is not a valid wave file');

    mmckinfoSubchunk.ckid := mmioStringToFourCC('fmt ', 0);
    if mmioDescend(mmioHandle, @mmckinfoSubchunk, @mmckinfoParent,
      MMIO_FINDCHUNK) <> MMSYSERR_NOERROR then
      raise Exception.Create(szFileName + ' is not a valid wave file');

    dwFmtSize := mmckinfoSubchunk.cksize;
    GetMem(pFormat, dwFmtSize);

    try
      { The mmioRead function reads a specified number of bytes from a file }
      if DWORD(mmioRead(mmioHandle, PChar(pFormat), dwFmtSize)) <>
        dwFmtSize then
        raise Exception.Create('Error reading wave data');

      if pFormat^.wFormatTag <> WAVE_FORMAT_PCM then
        raise Exception.Create('Invalid wave file format');

      { he waveOutOpen function opens the given waveform-audio output device for playback }
      if waveOutOpen(@fWaveOutHandle, WAVE_MAPPER, pFormat, 0, 0,
        WAVE_FORMAT_QUERY) <> MMSYSERR_NOERROR then
        raise Exception.Create('Can''t play format');

      mmioAscend(mmioHandle, @mmckinfoSubchunk, 0);
      mmckinfoSubchunk.ckid := mmioStringToFourCC('data', 0);
      if mmioDescend(mmioHandle, @mmckinfoSubchunk, @mmckinfoParent,
        MMIO_FINDCHUNK) <> MMSYSERR_NOERROR then
        raise Exception.Create('No data chunk');

      dwDataSize := mmckinfoSubchunk.cksize;
      if dwDataSize = 0 then
        raise Exception.Create('Chunk has no data');

      if waveOutOpen(@fWaveOutHandle, WAVE_MAPPER, pFormat,  //integer(self)
        DWORD(@WaveOutPrc), Integer(NIL), CALLBACK_FUNCTION) <> MMSYSERR_NOERROR then
      begin
        fWaveOutHandle := 0;
        raise Exception.Create('Failed to open output device');
      end;

      wBlockSize := pFormat^.nBlockAlign;

      ReallocMem(pFormat, 0);
      ReallocMem(fData, dwDataSize);

      if DWORD(mmioRead(mmioHandle, fData, dwDataSize)) <> dwDataSize then
        raise Exception.Create('Unable to read data chunk');

      hpch1 := fData;
      hpch2 := fData + dwDataSize - 1;

      while hpch1 < hpch2 do
      begin
        Interchange(hpch1, hpch2, wBlockSize);
        Inc(hpch1, wBlockSize);
        Dec(hpch2, wBlockSize)
      end;

      GetMem(fWaveHdr, SizeOf(WAVEHDR));
      fWaveHdr^.lpData  := fData;
      fWaveHdr^.dwBufferLength := dwDataSize;
      fWaveHdr^.dwFlags := 0;
      fWaveHdr^.dwLoops := 0;
      fWaveHdr^.dwUser := 0;

      { The waveOutPrepareHeader function prepares a waveform-audio data block for playback. }
      if waveOutPrepareHeader(fWaveOutHandle, fWaveHdr,
        SizeOf(WAVEHDR)) <> MMSYSERR_NOERROR then
        raise Exception.Create('Unable to prepare header');

      { The waveOutWrite function sends a data block to the given waveform-audio output device.}
      if waveOutWrite(fWaveOutHandle, fWaveHdr, SizeOf(WAVEHDR)) <>
        MMSYSERR_NOERROR then
        raise Exception.Create('Failed to write to device');

    finally
      ReallocMem(pFormat, 0)
    end
  finally
    mmioClose(mmioHandle, 0)
  end
end;

 type
  TMimeExtension = record
    Ext: string;
    MimeType: string;
  end;

const
  MIMEExtensions: array[1..176] of TMimeExtension = (
    (Ext: '.gif'; MimeType: 'image/gif'),
    (Ext: '.jpg'; MimeType: 'image/jpeg'),
    (Ext: '.jpeg'; MimeType: 'image/jpeg'),
    (Ext: '.html'; MimeType: 'text/html'),
    (Ext: '.htm'; MimeType: 'text/html'),
    (Ext: '.css'; MimeType: 'text/css'),
    (Ext: '.js'; MimeType: 'text/javascript'),
    (Ext: '.txt'; MimeType: 'text/plain'),
    (Ext: '.xls'; MimeType: 'application/excel'),
    (Ext: '.rtf'; MimeType: 'text/richtext'),
    (Ext: '.wq1'; MimeType: 'application/x-lotus'),
    (Ext: '.wk1'; MimeType: 'application/x-lotus'),
    (Ext: '.raf'; MimeType: 'application/raf'),
    (Ext: '.png'; MimeType: 'image/x-png'),
    (Ext: '.c'; MimeType: 'text/plain'),
    (Ext: '.c++'; MimeType: 'text/plain'),
    (Ext: '.pl'; MimeType: 'text/plain'),
    (Ext: '.cc'; MimeType: 'text/plain'),
    (Ext: '.h'; MimeType: 'text/plain'),
    (Ext: '.talk'; MimeType: 'text/x-speech'),
    (Ext: '.xbm'; MimeType: 'image/x-xbitmap'),
    (Ext: '.xpm'; MimeType: 'image/x-xpixmap'),
    (Ext: '.ief'; MimeType: 'image/ief'),
    (Ext: '.jpe'; MimeType: 'image/jpeg'),
    (Ext: '.tiff'; MimeType: 'image/tiff'),
    (Ext: '.tif'; MimeType: 'image/tiff'),
    (Ext: '.rgb'; MimeType: 'image/rgb'),
    (Ext: '.g3f'; MimeType: 'image/g3fax'),
    (Ext: '.xwd'; MimeType: 'image/x-xwindowdump'),
    (Ext: '.pict'; MimeType: 'image/x-pict'),
    (Ext: '.ppm'; MimeType: 'image/x-portable-pixmap'),
    (Ext: '.pgm'; MimeType: 'image/x-portable-graymap'),
    (Ext: '.pbm'; MimeType: 'image/x-portable-bitmap'),
    (Ext: '.pnm'; MimeType: 'image/x-portable-anymap'),
    (Ext: '.bmp'; MimeType: 'image/x-ms-bmp'),
    (Ext: '.ras'; MimeType: 'image/x-cmu-raster'),
    (Ext: '.pcd'; MimeType: 'image/x-photo-cd'),
    (Ext: '.cgm'; MimeType: 'image/cgm'),
    (Ext: '.mil'; MimeType: 'image/x-cals'),
    (Ext: '.cal'; MimeType: 'image/x-cals'),
    (Ext: '.fif'; MimeType: 'image/fif'),
    (Ext: '.dsf'; MimeType: 'image/x-mgx-dsf'),
    (Ext: '.cmx'; MimeType: 'image/x-cmx'),
    (Ext: '.wi'; MimeType: 'image/wavelet'),
    (Ext: '.dwg'; MimeType: 'image/vnd.dwg'),
    (Ext: '.dxf'; MimeType: 'image/vnd.dxf'),
    (Ext: '.svf'; MimeType: 'image/vnd.svf'),
    (Ext: '.au'; MimeType: 'audio/basic'),
    (Ext: '.snd'; MimeType: 'audio/basic'),
    (Ext: '.aif'; MimeType: 'audio/x-aiff'),
    (Ext: '.aiff'; MimeType: 'audio/x-aiff'),
    (Ext: '.aifc'; MimeType: 'audio/x-aiff'),
    (Ext: '.wav'; MimeType: 'audio/x-wav'),
    (Ext: '.mpa'; MimeType: 'audio/x-mpeg'),
    (Ext: '.abs'; MimeType: 'audio/x-mpeg'),
    (Ext: '.mpega'; MimeType: 'audio/x-mpeg'),
    (Ext: '.mp2a'; MimeType: 'audio/x-mpeg-2'),
    (Ext: '.mpa2'; MimeType: 'audio/x-mpeg-2'),
    (Ext: '.es'; MimeType: 'audio/echospeech'),
    (Ext: '.vox'; MimeType: 'audio/voxware'),
    (Ext: '.lcc'; MimeType: 'application/fastman'),
    (Ext: '.ra'; MimeType: 'application/x-pn-realaudio'),
    (Ext: '.ram'; MimeType: 'application/x-pn-realaudio'),
    (Ext: '.mmid'; MimeType: 'x-music/x-midi'),
    (Ext: '.skp'; MimeType: 'application/vnd.koan'),
    (Ext: '.talk'; MimeType: 'text/x-speech'),
    (Ext: '.mpeg'; MimeType: 'video/mpeg'),
    (Ext: '.mpg'; MimeType: 'video/mpeg'),
    (Ext: '.mpe'; MimeType: 'video/mpeg'),
    (Ext: '.mpv2'; MimeType: 'video/mpeg-2'),
    (Ext: '.mp2v'; MimeType: 'video/mpeg-2'),
    (Ext: '.qt'; MimeType: 'video/quicktime'),
    (Ext: '.mov'; MimeType: 'video/quicktime'),
    (Ext: '.avi'; MimeType: 'video/x-msvideo'),
    (Ext: '.movie'; MimeType: 'video/x-sgi-movie'),
    (Ext: '.vdo'; MimeType: 'video/vdo'),
    (Ext: '.viv'; MimeType: 'video/vnd.vivo'),
    (Ext: '.pac'; MimeType: 'application/x-ns-proxy-autoconfig'),
    (Ext: '.ai'; MimeType: 'application/postscript'),
    (Ext: '.eps'; MimeType: 'application/postscript'),
    (Ext: '.ps'; MimeType: 'application/postscript'),
    (Ext: '.rtf'; MimeType: 'application/rtf'),
    (Ext: '.pdf'; MimeType: 'application/pdf'),
    (Ext: '.mif'; MimeType: 'application/vnd.mif'),
    (Ext: '.t'; MimeType: 'application/x-troff'),
    (Ext: '.tr'; MimeType: 'application/x-troff'),
    (Ext: '.roff'; MimeType: 'application/x-troff'),
    (Ext: '.man'; MimeType: 'application/x-troff-man'),
    (Ext: '.me'; MimeType: 'application/x-troff-me'),
    (Ext: '.ms'; MimeType: 'application/x-troff-ms'),
    (Ext: '.latex'; MimeType: 'application/x-latex'),
    (Ext: '.tex'; MimeType: 'application/x-tex'),
    (Ext: '.texinfo'; MimeType: 'application/x-texinfo'),
    (Ext: '.texi'; MimeType: 'application/x-texinfo'),
    (Ext: '.dvi'; MimeType: 'application/x-dvi'),
    (Ext: '.doc'; MimeType: 'application/msword'),
    (Ext: '.oda'; MimeType: 'application/oda'),
    (Ext: '.evy'; MimeType: 'application/envoy'),
    (Ext: '.gtar'; MimeType: 'application/x-gtar'),
    (Ext: '.tar'; MimeType: 'application/x-tar'),
    (Ext: '.ustar'; MimeType: 'application/x-ustar'),
    (Ext: '.bcpio'; MimeType: 'application/x-bcpio'),
    (Ext: '.cpio'; MimeType: 'application/x-cpio'),
    (Ext: '.shar'; MimeType: 'application/x-shar'),
    (Ext: '.zip'; MimeType: 'application/zip'),
    (Ext: '.hqx'; MimeType: 'application/mac-binhex40'),
    (Ext: '.sit'; MimeType: 'application/x-stuffit'),
    (Ext: '.sea'; MimeType: 'application/x-stuffit'),
    (Ext: '.fif'; MimeType: 'application/fractals'),
    (Ext: '.bin'; MimeType: 'application/octet-stream'),
    (Ext: '.uu'; MimeType: 'application/octet-stream'),
    (Ext: '.exe'; MimeType: 'application/octet-stream'),
    (Ext: '.src'; MimeType: 'application/x-wais-source'),
    (Ext: '.wsrc'; MimeType: 'application/x-wais-source'),
    (Ext: '.hdf'; MimeType: 'application/hdf'),
    (Ext: '.ls'; MimeType: 'text/javascript'),
    (Ext: '.mocha'; MimeType: 'text/javascript'),
    (Ext: '.vbs'; MimeType: 'text/vbscript'),
    (Ext: '.sh'; MimeType: 'application/x-sh'),
    (Ext: '.csh'; MimeType: 'application/x-csh'),
    (Ext: '.pl'; MimeType: 'application/x-perl'),
    (Ext: '.tcl'; MimeType: 'application/x-tcl'),
    (Ext: '.spl'; MimeType: 'application/futuresplash'),
    (Ext: '.mbd'; MimeType: 'application/mbedlet'),
    (Ext: '.swf'; MimeType: 'application/x-director'),
    (Ext: '.pps'; MimeType: 'application/mspowerpoint'),
    (Ext: '.asp'; MimeType: 'application/x-asap'),
    (Ext: '.asn'; MimeType: 'application/astound'),
    (Ext: '.axs'; MimeType: 'application/x-olescript'),
    (Ext: '.ods'; MimeType: 'application/x-oleobject'),
    (Ext: '.opp'; MimeType: 'x-form/x-openscape'),
    (Ext: '.wba'; MimeType: 'application/x-webbasic'),
    (Ext: '.frm'; MimeType: 'application/x-alpha-form'),
    (Ext: '.wfx'; MimeType: 'x-script/x-wfxclient'),
    (Ext: '.pcn'; MimeType: 'application/x-pcn'),
    (Ext: '.ppt'; MimeType: 'application/vnd.ms-powerpoint'),
    (Ext: '.svd'; MimeType: 'application/vnd.svd'),
    (Ext: '.ins'; MimeType: 'application/x-net-install'),
    (Ext: '.ccv'; MimeType: 'application/ccv'),
    (Ext: '.vts'; MimeType: 'workbook/formulaone'),
    (Ext: '.wrl'; MimeType: 'x-world/x-vrml'),
    (Ext: '.vrml'; MimeType: 'x-world/x-vrml'),
    (Ext: '.vrw'; MimeType: 'x-world/x-vream'),
    (Ext: '.p3d'; MimeType: 'application/x-p3d'),
    (Ext: '.svr'; MimeType: 'x-world/x-svr'),
    (Ext: '.wvr'; MimeType: 'x-world/x-wvr'),
    (Ext: '.3dmf'; MimeType: 'x-world/x-3dmf'),
    (Ext: '.ma'; MimeType: 'application/mathematica'),
    (Ext: '.msh'; MimeType: 'x-model/x-mesh'),
    (Ext: '.v5d'; MimeType: 'application/vis5d'),
    (Ext: '.igs'; MimeType: 'application/iges'),
    (Ext: '.dwf'; MimeType: 'drawing/x-dwf'),
    (Ext: '.showcase'; MimeType: 'application/x-showcase'),
    (Ext: '.slides'; MimeType: 'application/x-showcase'),
    (Ext: '.sc'; MimeType: 'application/x-showcase'),
    (Ext: '.sho'; MimeType: 'application/x-showcase'),
    (Ext: '.show'; MimeType: 'application/x-showcase'),
    (Ext: '.ins'; MimeType: 'application/x-insight'),
    (Ext: '.insight'; MimeType: 'application/x-insight'),
    (Ext: '.ano'; MimeType: 'application/x-annotator'),
    (Ext: '.dir'; MimeType: 'application/x-dirview'),
    (Ext: '.lic'; MimeType: 'application/x-enterlicense'),
    (Ext: '.faxmgr'; MimeType: 'application/x-fax-manager'),
    (Ext: '.faxmgrjob'; MimeType: 'application/x-fax-manager-job'),
    (Ext: '.icnbk'; MimeType: 'application/x-iconbook'),
    (Ext: '.wb'; MimeType: 'application/x-inpview'),
    (Ext: '.inst'; MimeType: 'application/x-install'),
    (Ext: '.mail'; MimeType: 'application/x-mailfolder'),
    (Ext: '.pp'; MimeType: 'application/x-ppages'),
    (Ext: '.ppages'; MimeType: 'application/x-ppages'),
    (Ext: '.sgi-lpr'; MimeType: 'application/x-sgi-lpr'),
    (Ext: '.tardist'; MimeType: 'application/x-tardist'),
    (Ext: '.ztardist'; MimeType: 'application/x-ztardist'),
    (Ext: '.wkz'; MimeType: 'application/x-wingz'),
    (Ext: '.xml'; MimeType: 'application/xml'),
    (Ext: '.iv'; MimeType: 'graphics/x-inventor'));



function FileType2MimeType(const AFileName: string): string;
var
  FileExt: string;
  I: Integer;
begin
  Result := 'text/html';
  FileExt := ExtractFileExt(AFileName);
  for I := Low(MIMEExtensions) to High(MIMEExtensions) do
    if SameText(MIMEExtensions[I].Ext, FileExt) then begin
      Result := MIMEExtensions[I].MimeType;
      Break;
    end;
end;


function FormatHTMLClipboardHeader(HTMLText: string): string;
const
  CrLf = #13#10;
begin
  Result := 'Version:0.9' + CrLf;
  Result := Result + 'StartHTML:-1' + CrLf;
  Result := Result + 'EndHTML:-1' + CrLf;
  Result := Result + 'StartFragment:000081' + CrLf;
  Result := Result + 'EndFragment:°°°°°°' + CrLf;
  Result := Result + HTMLText + CrLf;
  Result := StringReplace(Result, '°°°°°°', Format('%.6d', [Length(Result)]), []);
end;


procedure CopyHTMLToClipBoard(const str: string; const htmlStr: string = '');
var
  gMem: HGLOBAL;
  lp: PChar;
  Strings: array[0..1] of string;
  Formats: array[0..1] of UINT;
  i: Integer;
begin
  gMem := 0;
  {$IFNDEF USEVCLCLIPBOARD}
  Win32Check(OpenClipBoard(0));
  {$ENDIF}
  try
    //most descriptive first as per api docs
    Strings[0] := FormatHTMLClipboardHeader(htmlStr);
    Strings[1] := str;
    Formats[0] := RegisterClipboardFormat('HTML Format');
    Formats[1] := CF_TEXT;
    {$IFNDEF USEVCLCLIPBOARD}
    Win32Check(EmptyClipBoard);
    {$ENDIF}
    for i := 0 to High(Strings) do
    begin
      if Strings[i] = '' then Continue;
      //an extra "1" for the null terminator
      gMem := GlobalAlloc(GMEM_DDESHARE + GMEM_MOVEABLE, Length(Strings[i]) + 1);
      {Succeeded, now read the stream contents into the memory the pointer points at}
      try
        Win32Check(gmem <> 0);
        lp := GlobalLock(gMem);
        Win32Check(lp <> nil);
        CopyMemory(lp, PChar(Strings[i]), Length(Strings[i]) + 1);
      finally
        GlobalUnlock(gMem);
      end;
      Win32Check(gmem <> 0);
      SetClipboardData(Formats[i], gMEm);
      Win32Check(gmem <> 0);
      gmem := 0;
    end;
  finally
    {$IFNDEF USEVCLCLIPBOARD}
    Win32Check(CloseClipBoard);
    {$ENDIF}
  end;
end;


function CheckCreditCard(c: string): Integer;
var
  card: string[21];
  Vcard: array[0..21] of Byte absolute card;
  Xcard: Integer;
  Cstr: string[21];
  y, x: Integer;
begin
  Cstr := '';
  FillChar(Vcard, 22, #0);
  card := c;
  for x := 1 to 20 do
    if (Vcard[x] in [48..57]) then
      Cstr := Cstr + chr(Vcard[x]);
  card := '';
  card := Cstr;
  Xcard := 0;
  if not odd(Length(card)) then
    for x := (Length(card) - 1) downto 1 do
    begin
      if odd(x) then
        y := ((Vcard[x] - 48) * 2)
      else
        y := (Vcard[x] - 48);
      if (y >= 10) then
        y := ((y - 10) + 1);
      Xcard := (Xcard + y)
    end
  else
    for x := (Length(card) - 1) downto 1 do
    begin
      if odd(x) then
        y := (Vcard[x] - 48)
      else
        y := ((Vcard[x] - 48) * 2);
      if (y >= 10) then
        y := ((y - 10) + 1);
      Xcard := (Xcard + y)
    end;
  x := (10 - (Xcard mod 10));
  if (x = 10) then
    x := 0;
  if (x = (Vcard[Length(card)] - 48)) then
    Result := Ord(Cstr[1]) - Ord('2')
  else
    Result := 0
end;

function ComputePEChecksum(FileName: string): DWORD;
var
  h, hMap: Cardinal;
  pMem: Pointer;
  headersum, checksum, fsizehigh, fsizelow: DWORD;
  nth: PImageNtHeaders;
Label
  cleanup;
begin
  pMem := nil;

  Result := 0;

  headersum := 0;
  checksum  := 0;

  h := Windows.CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ,
    nil, OPEN_EXISTING, 0, 0);
  if (h = INVALID_HANDLE_VALUE) then
    Exit;

  fsizelow := Windows.GetFileSize(h, Pointer(@fsizehigh));

  hMap := Windows.CreateFileMapping(h, nil, PAGE_READONLY, fsizeHigh, fsizeLow, nil);
  if (hMap = 0) then
    goto cleanup;

  pMem := Windows.MapViewOfFile(hMap, FILE_MAP_READ, 0, 0, 0);
  if (pMem = nil) then
    goto cleanup;

  nth := CheckSumMappedFile(pMem, fsizeLow, @headersum, @checksum);

  if (nth = nil) then
    checksum := 0;

  cleanup:
  if (pMem <> nil) then
    Windows.UnmapViewOfFile(pMem);
  if (hMap <> 0) then
    Windows.CloseHandle(hMap);
  if (h <> 0) then
    Windows.CloseHandle(h);

  Result := checksum;
end;





(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSPascalParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPSPascalParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPSPascalParser') do begin
    RegisterProperty('EnableComments', 'Boolean', iptrw);
    RegisterProperty('EnableWhitespaces', 'Boolean', iptrw);
    RegisterMethod('Procedure Next');
    RegisterProperty('GetToken', 'TbtString', iptr);
    RegisterProperty('OriginalToken', 'TbtString', iptr);
    RegisterProperty('CurrTokenPos', 'Cardinal', iptr);
    RegisterProperty('CurrTokenID', 'TPSPasToken', iptr);
    RegisterProperty('Row', 'Cardinal', iptr);
    RegisterProperty('Col', 'Cardinal', iptr);
    RegisterMethod('Procedure SetText( const Data : TbtString)');
    //RegisterProperty('OnParserError', 'TPSParserErrorEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSUnitList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TPSUnitList') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TPSUnitList') do begin
    RegisterMethod('Constructor Create');
      RegisterMethod('Procedure Free');
      RegisterMethod('Function GetUnit( UnitName : TbtString) : TPSUnit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSUnit(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPSUnit') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPSUnit') do begin
    RegisterMethod('Constructor Create( List : TPSUnitList)');
      RegisterMethod('Procedure Free');
      RegisterMethod('Procedure AddUses( pUnitName : TbtString)');
    RegisterMethod('Function HasUses( pUnitName : TbtString) : Boolean');
    RegisterProperty('UnitName', 'TbtString', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSStringList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPSStringList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPSStringList') do begin
    RegisterMethod('Function Count : LongInt');
    RegisterProperty('Items', 'TbtString Longint', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Procedure Add( const P : TbtString)');
    RegisterMethod('Procedure Delete( NR : LongInt)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free');
    end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TPSList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TPSList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TPSList') do
  begin
    RegisterMethod('Procedure Recreate');
    RegisterProperty('Data', 'PPointerList', iptr);
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IndexOf( P : ___Pointer) : Longint');
    RegisterProperty('Count', 'Cardinal', iptr);
    RegisterProperty('Items', '___Pointer Cardinal', iptrw);
    SetDefaultPropery('Items');
    RegisterMethod('Function Add( P : Pointer) : Longint');
    RegisterMethod('Procedure AddBlock( List : PPointerList; Count : Longint)');
    RegisterMethod('Procedure Remove( P : ___Pointer)');
    RegisterMethod('Procedure Delete( Nr : Cardinal)');
    RegisterMethod('Procedure DeleteLast');
    RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_uPSUtils(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('PSMainProcName','String').SetString( '!MAIN');
 CL.AddConstantN('PSMainProcNameOrg','String').SetString( 'Main Proc');
 CL.AddConstantN('PSLowBuildSupport','LongInt').SetInt( 12);
 CL.AddConstantN('PSCurrentBuildNo','LongInt').SetInt( 23);
 CL.AddConstantN('PSCurrentversion','String').SetString( '1.31');
 CL.AddConstantN('PSValidHeader','LongInt').SetInt( 1397769801);
 CL.AddConstantN('PSAddrStackStart','LongInt').SetInt( 1610612736);
 CL.AddConstantN('PSAddrNegativeStackStart','LongInt').SetInt( 1073741824);
 //CL.AddConstantN('TPSBaseType','').SetString( Byte);
 CL.AddConstantN('btReturnAddress','LongInt').SetInt( 0);
 CL.AddConstantN('btU8','LongInt').SetInt( 1);
 CL.AddConstantN('btS8','LongInt').SetInt( 2);
 CL.AddConstantN('btU16','LongInt').SetInt( 3);
 CL.AddConstantN('btS16','LongInt').SetInt( 4);
 CL.AddConstantN('btU32','LongInt').SetInt( 5);
 CL.AddConstantN('btS32','LongInt').SetInt( 6);
 CL.AddConstantN('btSingle','LongInt').SetInt( 7);
 CL.AddConstantN('btDouble','LongInt').SetInt( 8);
 CL.AddConstantN('btExtended','LongInt').SetInt( 9);
 CL.AddConstantN('btString','LongInt').SetInt( 10);
 CL.AddConstantN('btRecord','LongInt').SetInt( 11);
 CL.AddConstantN('btArray','LongInt').SetInt( 12);
 CL.AddConstantN('btPointer','LongInt').SetInt( 13);
 CL.AddConstantN('btPChar','LongInt').SetInt( 14);
 CL.AddConstantN('btResourcePointer','LongInt').SetInt( 15);
 CL.AddConstantN('btVariant','LongInt').SetInt( 16);
 CL.AddConstantN('btS64','LongInt').SetInt( 17);
 CL.AddConstantN('btU64','LongInt').SetInt( 30);
 CL.AddConstantN('btChar','LongInt').SetInt( 18);
 CL.AddConstantN('btWideString','LongInt').SetInt( 19);
 CL.AddConstantN('btWideChar','LongInt').SetInt( 20);
 CL.AddConstantN('btProcPtr','LongInt').SetInt( 21);
 CL.AddConstantN('btStaticArray','LongInt').SetInt( 22);
 CL.AddConstantN('btSet','LongInt').SetInt( 23);
 CL.AddConstantN('btCurrency','LongInt').SetInt( 24);
 CL.AddConstantN('btClass','LongInt').SetInt( 25);
 CL.AddConstantN('btInterface','LongInt').SetInt( 26);
 CL.AddConstantN('btNotificationVariant','LongInt').SetInt( 27);
 CL.AddConstantN('btUnicodeString','LongInt').SetInt( 28);
 CL.AddConstantN('btType','LongInt').SetInt( 130);
 CL.AddConstantN('btEnum','LongInt').SetInt( 129);
 CL.AddConstantN('btExtClass','LongInt').SetInt( 131);
// CL.AddDelphiFunction('Function MakeHash( const s : TbtString) : Longint');
 CL.AddConstantN('CM_A','LongInt').SetInt( 0);
 CL.AddConstantN('CM_CA','LongInt').SetInt( 1);
 CL.AddConstantN('CM_P','LongInt').SetInt( 2);
 CL.AddConstantN('CM_PV','LongInt').SetInt( 3);
 CL.AddConstantN('CM_PO','LongInt').SetInt( 4);
 CL.AddConstantN('Cm_C','LongInt').SetInt( 5);
 CL.AddConstantN('Cm_G','LongInt').SetInt( 6);
 CL.AddConstantN('Cm_CG','LongInt').SetInt( 7);
 CL.AddConstantN('Cm_CNG','LongInt').SetInt( 8);
 CL.AddConstantN('Cm_R','LongInt').SetInt( 9);
 CL.AddConstantN('Cm_ST','LongInt').SetInt( 10);
 CL.AddConstantN('Cm_Pt','LongInt').SetInt( 11);
 CL.AddConstantN('CM_CO','LongInt').SetInt( 12);
 CL.AddConstantN('Cm_cv','LongInt').SetInt( 13);
 CL.AddConstantN('cm_sp','LongInt').SetInt( 14);
 CL.AddConstantN('cm_bn','LongInt').SetInt( 15);
 CL.AddConstantN('cm_vm','LongInt').SetInt( 16);
 CL.AddConstantN('cm_sf','LongInt').SetInt( 17);
 CL.AddConstantN('cm_fg','LongInt').SetInt( 18);
 CL.AddConstantN('cm_puexh','LongInt').SetInt( 19);
 CL.AddConstantN('cm_poexh','LongInt').SetInt( 20);
 CL.AddConstantN('cm_in','LongInt').SetInt( 21);
 CL.AddConstantN('cm_spc','LongInt').SetInt( 22);
 CL.AddConstantN('cm_inc','LongInt').SetInt( 23);
 CL.AddConstantN('cm_dec','LongInt').SetInt( 24);
 CL.AddConstantN('cm_nop','LongInt').SetInt( 255);
 CL.AddConstantN('Cm_PG','LongInt').SetInt( 25);
 CL.AddConstantN('Cm_P2G','LongInt').SetInt( 26);
  CL.AddTypeS('TbtU8', 'Byte');
  CL.AddTypeS('TbtS8', 'ShortInt');
  CL.AddTypeS('TbtU16', 'Word');
  CL.AddTypeS('TbtS16', 'SmallInt');
  CL.AddTypeS('TbtU32', 'Cardinal');
  CL.AddTypeS('TbtS32', 'Longint');
  CL.AddTypeS('TbtSingle', 'Single');
  CL.AddTypeS('TbtDouble', 'double');
  CL.AddTypeS('TbtExtended', 'Extended');
  CL.AddTypeS('tbtCurrency', 'Currency');
  CL.AddTypeS('tbts64', 'int64');
  CL.AddTypeS('Tbtu64', 'uint64');
  CL.AddTypeS('TbtString', 'string');
   CL.AddDelphiFunction('Function MakeHash( const s : TbtString) : Longint');
//   TbtString = {$IFDEF DELPHI2009UP}AnsiString{$ELSE}String{$ENDIF};
   //CL.AddConstantN('PointerSize','LongInt').SetInt( IPointer ( 8 4 ));
 CL.AddConstantN('PSMaxListSize','LongInt').SetInt( Maxint div 16);
  //CL.AddTypeS('PPointerList', '^TPointerList // will not work');
  SIRegister_TPSList(CL);
  CL.AddTypeS('TIFList', 'TPSList');
  SIRegister_TPSStringList(CL);
  CL.AddTypeS('TIFStringList', 'TPsStringList');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TPSUnitList');
  SIRegister_TPSUnit(CL);
  SIRegister_TPSUnitList(CL);
  CL.AddTypeS('TPSParserErrorKind', '( iNoError, iCommentError, iStringError, iCharError, iSyntaxError )');
  CL.AddTypeS('TPSParserErrorEvent', 'Procedure ( Parser : TObject; Kind : TPSParserErrorKind)');
  CL.AddTypeS('TCastType', '(ctSmallInt, ctInteger, ctDecimal, ctNumeric, ctFloat,ctChar, ctVarChar, ctDate, ctBoolean, ctBLOB, ctTime, ctTimeStamp, ctMoney, ctAutoInc, ctBytes)');

  {type TCastType = (ctSmallInt, ctInteger, ctDecimal, ctNumeric, ctFloat,
               ctChar, ctVarChar, ctDate, ctBoolean, ctBLOB, ctTime,
               ctTimeStamp, ctMoney, ctAutoInc, ctBytes);}

 CL.AddTypeS('TMimeExtension', 'record Ext : string; MimeType : string; end');
 CL.AddDelphiFunction('Function FileType2MimeType( const AFileName : string) : string');

  SIRegister_TPSPascalParser(CL);
 CL.AddDelphiFunction('Function PSFloatToStr( E : Extended) : TbtString');
 CL.AddDelphiFunction('Function FastLowerCase( const s : TbtString) : TbtString');
 CL.AddDelphiFunction('Function Fw( const S : TbtString) : TbtString');
 CL.AddDelphiFunction('Function FirstWord( const S : TbtString) : TbtString');
 CL.AddDelphiFunction('Function PSIntToStr( I : LongInt) : TbtString');
 CL.AddDelphiFunction('Function PSStrToIntDef( const S : TbtString; Def : LongInt) : LongInt');
 CL.AddDelphiFunction('Function PSStrToInt( const S : TbtString) : LongInt');
 CL.AddDelphiFunction('Function PSStrToFloat( const s : TbtString) : Extended');
 CL.AddDelphiFunction('Function FastUpperCase( const s : TbtString) : TbtString');
 CL.AddDelphiFunction('Function GRFW( var s : TbtString) : TbtString');
 CL.AddDelphiFunction('Function GRLW( var s : TbtString) : TbtString');
 CL.AddConstantN('FCapacityInc','LongInt').SetInt( 32);
 CL.AddDelphiFunction('Function PSWideUpperCase( const S : WideString) : WideString');
 CL.AddDelphiFunction('Function PSWideLowerCase( const S : WideString) : WideString');
 CL.AddDelphiFunction('function ChangeAlphaTo(input: string; aoffset: byte): string;');
 CL.AddDelphiFunction('function CheckIBAN(iban: string): Boolean;');
 CL.AddDelphiFunction('procedure SQLDropField(dbName, tblName,  fldName: String);');
 CL.AddDelphiFunction('procedure SQLAddField(dbName, tblName, fldName: String; fldType: TCastType; fldLength, precisOrBlobLen, scaleOrBlobType: Integer);');
 CL.AddDelphiFunction('procedure HTMLtoRTF(html: string; var rtf: TRichedit);');
 CL.AddDelphiFunction('procedure ReversePlay(const szFileName: string);');
 CL.AddDelphiFunction('procedure CopyHTMLToClipBoard(const str: string; const htmlStr: string);');
 CL.AddDelphiFunction('function CheckCreditCard(c: string): Integer;');
 CL.AddDelphiFunction('function ComputePEChecksum(FileName: string): DWORD;');


 //procedure SQLAddField(dbName, tblName, fldName: String; fldType: TCastType; fldLength, precisOrBlobLen, scaleOrBlobType: Integer);

 end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TPSPascalParserOnParserError_W(Self: TPSPascalParser; const T: TPSParserErrorEvent);
begin Self.OnParserError := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserOnParserError_R(Self: TPSPascalParser; var T: TPSParserErrorEvent);
begin T := Self.OnParserError; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserCol_R(Self: TPSPascalParser; var T: Cardinal);
begin T := Self.Col; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserRow_R(Self: TPSPascalParser; var T: Cardinal);
begin T := Self.Row; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserCurrTokenID_R(Self: TPSPascalParser; var T: TPSPasToken);
begin T := Self.CurrTokenID; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserCurrTokenPos_R(Self: TPSPascalParser; var T: Cardinal);
begin T := Self.CurrTokenPos; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserOriginalToken_R(Self: TPSPascalParser; var T: TbtString);
begin T := Self.OriginalToken; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserGetToken_R(Self: TPSPascalParser; var T: TbtString);
begin T := Self.GetToken; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserEnableWhitespaces_W(Self: TPSPascalParser; const T: Boolean);
begin Self.EnableWhitespaces := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserEnableWhitespaces_R(Self: TPSPascalParser; var T: Boolean);
begin T := Self.EnableWhitespaces; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserEnableComments_W(Self: TPSPascalParser; const T: Boolean);
begin Self.EnableComments := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSPascalParserEnableComments_R(Self: TPSPascalParser; var T: Boolean);
begin T := Self.EnableComments; end;

(*----------------------------------------------------------------------------*)
procedure TPSUnitUnitName_W(Self: TPSUnit; const T: TbtString);
begin Self.UnitName := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSUnitUnitName_R(Self: TPSUnit; var T: TbtString);
begin T := Self.UnitName; end;

(*----------------------------------------------------------------------------*)
procedure TPSStringListItems_W(Self: TPSStringList; const T: TbtString; const t1: Longint);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSStringListItems_R(Self: TPSStringList; var T: TbtString; const t1: Longint);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPSListItems_W(Self: TPSList; const T: Pointer; const t1: Cardinal);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TPSListItems_R(Self: TPSList; var T: Pointer; const t1: Cardinal);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TPSListCount_R(Self: TPSList; var T: Cardinal);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TPSListData_R(Self: TPSList; var T: PPointerList);
begin T := Self.Data; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSPascalParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSPascalParser) do begin
    RegisterPropertyHelper(@TPSPascalParserEnableComments_R,@TPSPascalParserEnableComments_W,'EnableComments');
    RegisterPropertyHelper(@TPSPascalParserEnableWhitespaces_R,@TPSPascalParserEnableWhitespaces_W,'EnableWhitespaces');
    RegisterVirtualMethod(@TPSPascalParser.Next, 'Next');
    RegisterPropertyHelper(@TPSPascalParserGetToken_R,nil,'GetToken');
    RegisterPropertyHelper(@TPSPascalParserOriginalToken_R,nil,'OriginalToken');
    RegisterPropertyHelper(@TPSPascalParserCurrTokenPos_R,nil,'CurrTokenPos');
    RegisterPropertyHelper(@TPSPascalParserCurrTokenID_R,nil,'CurrTokenID');
    RegisterPropertyHelper(@TPSPascalParserRow_R,nil,'Row');
    RegisterPropertyHelper(@TPSPascalParserCol_R,nil,'Col');
    RegisterVirtualMethod(@TPSPascalParser.SetText, 'SetText');
    RegisterPropertyHelper(@TPSPascalParserOnParserError_R,@TPSPascalParserOnParserError_W,'OnParserError');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSUnitList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSUnitList) do begin
    RegisterConstructor(@TPSUnitList.Create, 'Create');
      RegisterMethod(@TPSUnitList.Destroy, 'Free');
     RegisterMethod(@TPSUnitList.GetUnit, 'GetUnit');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSUnit(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSUnit) do begin
    RegisterConstructor(@TPSUnit.Create, 'Create');
      RegisterMethod(@TPSUnit.Destroy, 'Free');
       RegisterMethod(@TPSUnit.AddUses, 'AddUses');
    RegisterMethod(@TPSUnit.HasUses, 'HasUses');
    RegisterPropertyHelper(@TPSUnitUnitName_R,@TPSUnitUnitName_W,'UnitName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSStringList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSStringList) do begin
    RegisterMethod(@TPSStringList.Count, 'Count');
      RegisterMethod(@TPSStringList.Destroy, 'Free');
      RegisterPropertyHelper(@TPSStringListItems_R,@TPSStringListItems_W,'Items');
    RegisterMethod(@TPSStringList.Add, 'Add');
    RegisterMethod(@TPSStringList.Delete, 'Delete');
    RegisterMethod(@TPSStringList.Clear, 'Clear');
    RegisterConstructor(@TPSStringList.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TPSList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TPSList) do
  begin
    RegisterMethod(@TPSList.Recreate, 'Recreate');
    RegisterPropertyHelper(@TPSListData_R,nil,'Data');
    RegisterConstructor(@TPSList.Create, 'Create');
    RegisterMethod(@TPSList.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TPSListCount_R,nil,'Count');
    RegisterPropertyHelper(@TPSListItems_R,@TPSListItems_W,'Items');
    RegisterMethod(@TPSList.Add, 'Add');
    RegisterMethod(@TPSList.AddBlock, 'AddBlock');
    RegisterMethod(@TPSList.Remove, 'Remove');
    RegisterMethod(@TPSList.Delete, 'Delete');
    RegisterMethod(@TPSList.DeleteLast, 'DeleteLast');
    RegisterVirtualMethod(@TPSList.Clear, 'Clear');
  end;
end;

procedure RIRegister_uPSUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TPSList(CL);
  RIRegister_TPSStringList(CL);
  with CL.Add(TPSUnitList) do
  RIRegister_TPSUnit(CL);
  RIRegister_TPSUnitList(CL);
  RIRegister_TPSPascalParser(CL);
 end;


(*----------------------------------------------------------------------------*)
procedure RIRegister_uPSUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@MakeHash, 'MakeHash', cdRegister);
 { RIRegister_TPSList(CL);
  RIRegister_TPSStringList(CL);
  with CL.Add(TPSUnitList) do
  RIRegister_TPSUnit(CL);
  RIRegister_TPSUnitList(CL);
  RIRegister_TPSPascalParser(CL);}
 S.RegisterDelphiFunction(@FloatToStr, 'PSFloatToStr', cdRegister);
 S.RegisterDelphiFunction(@FastLowerCase, 'FastLowerCase', cdRegister);
 S.RegisterDelphiFunction(@Fw, 'Fw', cdRegister);
 S.RegisterDelphiFunction(@Fw, 'FirstWord', cdRegister);
 S.RegisterDelphiFunction(@IntToStr, 'PSIntToStr', cdRegister);
 S.RegisterDelphiFunction(@StrToIntDef, 'PSStrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@StrToInt, 'PSStrToInt', cdRegister);
 S.RegisterDelphiFunction(@StrToFloat, 'PSStrToFloat', cdRegister);
 S.RegisterDelphiFunction(@FastUpperCase, 'FastUpperCase', cdRegister);
 S.RegisterDelphiFunction(@GRFW, 'GRFW', cdRegister);
 S.RegisterDelphiFunction(@GRLW, 'GRLW', cdRegister);
 S.RegisterDelphiFunction(@WideUpperCase, 'PSWideUpperCase', cdRegister);
 S.RegisterDelphiFunction(@WideLowerCase, 'PSWideLowerCase', cdRegister);
 S.RegisterDelphiFunction(@ChangeAlphaTo, 'ChangeAlphaTo', cdRegister);
 S.RegisterDelphiFunction(@CheckIBAN, 'CheckIBAN', cdRegister);
 S.RegisterDelphiFunction(@SQLDropField, 'SQLDropField', cdRegister);
 S.RegisterDelphiFunction(@SQLAddField, 'SQLAddField', cdRegister);
 S.RegisterDelphiFunction(@HTMLtoRTF, 'HTMLtoRTF', cdRegister);
 S.RegisterDelphiFunction(@ReversePlay, 'ReversePlay', cdRegister);
 S.RegisterDelphiFunction(@FileType2MimeType, 'FileType2MimeType', cdRegister);
 S.RegisterDelphiFunction(@CopyHTMLToClipBoard, 'CopyHTMLToClipBoard', cdRegister);
 S.RegisterDelphiFunction(@CheckCreditCard, 'CheckCreditCard', cdRegister);
 S.RegisterDelphiFunction(@ComputePEChecksum, 'ComputePEChecksum', cdRegister);


  //procedure ReversePlay(const szFileName: string);
//procedure HTMLtoRTF(html: string; var rtf: TRichedit);
 end;



{ TPSImport_uPSUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_uPSUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_uPSUtils(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_uPSUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_uPSUtils_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)


end.
