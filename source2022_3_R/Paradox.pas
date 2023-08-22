(******************************************************************************
*  TParadox Component to Read Paradox 4.0+ .db Files Using File I/O (No BDE)  *
*  vers 1.3                              by Howard Flank flank@speakeasy.net  *
*******************************************************************************

TParadox allows you to read a Paradox 4+ table without using the BDE.  It is
short (adds no more than 11K to the program, less if you're already using File
I/O), fast (faster then TTable + BDE), and simple (needs only the Paradox.pas
file). It can read all Paradox field types except BCD fields which are not
handled at all.  TParadox.FindKey can find a record using the Primary Index,
but it can't use any secondary indexes.
TParadox does not use or recognize Paradox multi-processing.

You can install TParadox in the Component Palette - Put the Paradox.pas and
Paradox.dcr in your custom components directory (e.g. \Imports) and select:
    Component|Install Component... then enter "<path>\paradox.pas" for the
    "Unit file name:", click [OK] -- now drop it on your form from the Palette.
-Or- just put it in your program directory (or a directory on the Library path -
Tools|Environment Options(Library) or Project|Options(Directories)Search Path).
Then use this code snippet (or equivalent) to create the object:
    var Pdx: TParadox; {-or- const Pdx: TParadox =nil; in a subroutine}
    ...
    {--Create TParadox Object & Set Properties--}
    Pdx := TParadox.Create(Self);
    Pdx.TableName := 'C:\MyDir\MyTable.db';  Pdx.Name := 'MyPdox';

Properties:
  Active      Table status. Set to True to Open, False to Close.
  BlobInfo    (aPdoxBlob) The BLOB info block in the .db file record.
  BlockSize   Paradox Table BlockSize (after open) r/o (Integer).
  EOF         If attempt to access past last record r/o (Boolean).
  FieldCount  No. of fields in the Table r/o (after open) (Word).
  KeyFields   No. of fields in the Primary Index (after open) (0 if no index).
  ReadOnly    Open the table "ReadOnly", Set to False to allow updates.
  RecordCount No. of records in table r/o (after open) (LongWord).
  RecordSize  Paradox record size in bytes (after open) r/o (Word).
  TableName   Filename of the Paradox Table to Read.
Methods:
  Open: Boolean;
    Opens the Table and positions to the first record. Returns true if OK.
  Close;
    Closes the Tables and releases any buffers. Can be called even if already
    closed. Same as setting Active := False;
  First;
    Positions to the first logical record in the table.
  Next: Boolean;
    Positions to the next logical record in the table. True if OK.
  Field(FldNo or FldName): String;
    Returns the contents of the numbered or named field as text. Only the first
    nnn bytes of a Memo defined as Mnnn are returned. Use "GetBlob" to retrive
    entire Memo (or Blob) field from the .mb file.
  FieldAsInteger(FldNo or FldName): Int64;
    Returns the binary contents of the field as Int64 or StrToInt() if String.
    Time, Date and TimeStamp are TDateTime -- Use Move(Res,DT,8) to put it in a
    TDateTime Field (typecast doesn't seem to work for this).
  FieldIndex(FldName: String): Integer;
    Returns the field no. of the named field (0=first field, -1=not-found)
  FieldName(FldNo: Integer): String;
    Returns the field name of the number field.
  FieldType(FldNo or FldName): Integer;
    Returns the Paradox internal field type for this field:
      1=(A)Alpha, 2=(D)Date, 3(S)Short integer, 4(I)Long integer,
      5($)currency, 6(N)Number, 9(L)Logical, 12(M)Memo BLOb, 13(B)Binary BLOb,
      14(F)Formatted Memo BLOb, 15(O)OLE, 16(G)Graphic BLOb, 20(T)Time,
      21(@)Timestamp, 22(+)Autoincrement, 23(#)BCD, 24(Y)Bytes.
  FindKey([KeyVal1,KeyVal2...]): Boolean;
    Positions to a matching row using the Primary Index (.px file). Time is
    about 20% faster than BDE TTable.FindKey. No. of KeyVals supplied must be
    equal to or less than the no. of fields in the Primary Index. Currently
    FindKey only works for Alpha key fields (or string equivalents).
    Returns "True" if a match is Found.
  GetBlob(FldNo or FldName, BfrSiz: Integer, var BlobBfr);
    Get a BLOb from the .mb File and put it into BlobBfr. BfrSiz is the max no.
    of bytes to return, BlobBfr must be alt least this big. The actual size of
    a Blob can be determined by first accessing it with "Field()" and then
    checking the BlobInfo.Length property.
  Locate([FldNo1,FldNo2...],[Value1,Value2...]): Boolean;
    Positions to the Next Table Row that Matches Single or Multi-Fields. Values
    must be the String equiv. of the Field. Uses a slow full table search.
    Returns "True" if a match is Found. Locate starts with the current record,
    so call "Next" first if you want the next match. Or You could just use:
      While not Pdx.EOF and (CompareText(Pdx.Field(1),FindIt)<>0) Do Pdx.Next;
  Version: String;
    Returns the Paradox version of the current table as a string.
  WriteField(FldNo or FldName, Fld): Boolean;  Updates a alpha field in the
    current record to <Fld>.  ReadOnly must be False (before opening table) and
    you must use the Close method before exiting your program to insure all
    updates are written. Can't update index columns. Rtns False if no update.
  CompareBytes(const S1,S2; Len: Integer): Integer;  Internal Byte Compare.
    Similar to CompareStr, but doesn't stop at a hex 00.

Version 1.1
  o Added Support for Time and TimeStamp fields.
  o FieldAsInteger() returns a TDateTime (as an Int64) for Time, Date or
    TimeStamp fields.
Version 1.2
  o Add support for Blobs stored in the .mb file.
  o BlobInfo property is now public.
  o Added FieldType() method.
  o Added support for Paradox 7 tables.
  o Added Error if table is pre- Paradox 4.0
Version 1.3
  o Added a check for empty tables in First().
  o Added WriteField() method for alpha fields, and ReadOnly property.
  o Modified ReadDB() to accept truncated final block in some Pdox 4.0 tables.
  o Fixed a multi-level index bug in the FindKey routine.

THIS PROGRAM UNIT IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED. INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO
QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE UNIT PROVE
DEFECTIVE, YOU ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING, REPAIR OR
CORRECTION. THE AUTHOR IS NOT LIABLE FOR ANY DAMAGE INCLUDING BUT NOT
LIMITED TO: DAMAGE TO HARDWARE, LOSS OF DATA, LOSS OF TIME, LOSS OF MIND, OR
ANY ANTI-SOCIAL BEHAVIOR. YOU MAY USE ANY OR ALL OF THIS PROGRAM CODE FOR
WHATEVER PURPOSES YOU SO DESIRE AND YOU MAY GIVE THE AUTHOR CREDIT OR NOT. *)

unit Paradox;
interface
uses Windows, Messages, Classes, SysUtils, Math, Dialogs;

type {--Types for TParadox routine--}
  aPdoxHdr = Packed Record {Paradox Table Header Info}
    RcdLen,HdrLen: Word;  FileType,Blk: Byte;  Rcds: LongWord;
    Used,Total,First,Last: Word;  x1: array[$12..$1D] of Byte;
    Root: Word;  Levls: Byte;  Flds,Keys, Curr: Word;  Vers: Byte;   end;
    {FileType: 0=Indexed(.db), 1=PriIndex(.px), 2=NonIndexed(.db), >2=SecIndex;
     Blk = Blksize in Kb (1024 bytes);
     Vers: 03h=3.0, 04h=3.5, 05h-09h=4.0, 0Ah-0Bh=5.0, 0Ch=7.0}
  aBlobHdr = Packed Record {}
    RcdType: Byte;  BlkSize: Integer;
    end;
  pPdoxBlk = ^aPdoxBlk;
  aPdoxBlk = Packed Record {Paradox Data Block Header}
    Next,Prev,Last: Word;   end;
  aPdoxBlob = Packed Record {10-byte Blob Info Block}
    FileLoc,Length: Integer;  ModCnt: Word;  Index: Byte;   end;
    {Offset: xOOOOOOII = MB-Offset + Blob-Index}
  aBlobIdx = Packed Record {Blob Pointer Array Entry}
    Offset,Len16: Byte;  ModCnt: Word;  Len: Byte;   end;
  aPdoxFld = Record {Internal Field Table}
    Name: String[25];  Typ,Start,Len: Integer;   end;
  EParadoxError = Class(Exception);

type TParadox = class(TComponent)
  private
    fTableName: string;
    fBlkSize,IndxSize,RcdIdx: Integer;
    fActive,fEOF,fReadOnly: Boolean;
    Flds: Array of aPdoxFld;
    Pdox: File;  Bfr: string;  PH: aPdoxHdr;  DB: aPdoxBlk; {.db}
    Indx: File;  Idx: string;  PI: aPdoxHdr;  PX: aPdoxBlk; {.px}
    BLOb: File;  BX: aBlobIdx; BI: aPdoxBlob;               {.mb}
  protected
    procedure SetActive(const Value: Boolean);
    function  ReadDB(BlkNo: Word): Boolean;
    function  ReadPX(BlkNo: Word): Boolean;
    function  WriteDB(BlkNo: Word): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  Open: Boolean;
    procedure Close;
    function  Next: Boolean;
    procedure First;
    function  Field(FldNo: Integer): String; overload;
    function  Field(FldName: String): String; overload;
    function  FieldAsInteger(FldNo: Integer): Int64; overload;
    function  FieldAsInteger(FldName: String): Int64; overload;
    function  FieldType(FldNo: Integer): Integer; overload;
    function  FieldType(FldName: String): Integer; overload;
    function  FieldIndex(FldName: String): Integer;
    function  FieldName(FldNo: Integer): String;
    function  FindKey(Val: Array of String): Boolean;
    procedure GetBlob(FldNo,BfrSiz: Integer; var BlobBfr); overload;
    procedure GetBlob(FldName:String; BfrSiz:Integer; var BlobBfr); overload;
    function  Locate(FldNo: Array of Integer;  Val: Array of String): Boolean;
    function  Version: String;
    function  WriteField(FldNo: Integer; Fld: String): Boolean; overload;
    function  WriteField(FldName: String; Fld: String): Boolean; overload;
    property  BlobInfo: aPdoxBlob read BI;
    property  BlockSize: Integer read fBlkSize;
    property  EOF: Boolean read fEOF;
    property  FieldCount: Word read PH.Flds;
    property  KeyFields: Word read PH.Keys;
    property  ReadOnly: Boolean read fReadOnly write fReadOnly;
    property  RecordCount: LongWord read PH.Rcds;
    property  RecordSize: Word read PH.RcdLen;
  published
    property  Active: Boolean read fActive write SetActive;
    property  TableName: string read fTableName write fTableName;
  end;
function CompareBytes(const V1,V2; Len: Integer): Integer;
procedure Register;

implementation
{---- TParadox Constructor and Destructor ------------------------------------}
constructor TParadox.Create(AOwner: TComponent); begin
  inherited;  fActive := False;  fEOF := True;  ReadOnly := True;
  Flds := nil;   end{constructor};
destructor TParadox.Destroy;  begin
  Close;  inherited;   end{destructor};

{---- Change the "Active" Status (Open or Close) -----------------------------}
procedure TParadox.SetActive(const Value: Boolean);  begin
  If Value=fActive Then Exit; {No Change}
  If fActive Then Close Else Open;   end{SetActive};

{---- Open the Paradox Table and Get the Field Info --------------------------}
function TParadox.Open: Boolean;
  var i,fs: Integer;  p: PChar;  fm: Byte;
begin   Result := True;
  If TFileRec(Pdox).Mode>fmClosed Then Exit; {Aready Open}
  AssignFile(Pdox,fTableName);  fm := FileMode;
  If ReadOnly Then FileMode := fmOpenRead  Else FileMode := fmOpenReadWrite;
  Try  Reset(Pdox,1);  FileMode := fm;  BlockRead(Pdox,PH,SizeOf(PH));
  Except on E:EInOutError Do
    Raise EParadoxError.CreateFmt('%s: Unable to open database "%s" - %s',
	[Self.Name,fTableName,E.Message]);  end{Try};
  fBlkSize := PH.Blk*1024;  SetLength(Bfr,fBlkSize);
  BlockRead(Pdox,Bfr[SizeOf(PH)],PH.HdrLen-SizeOf(PH)-1);
  PH.Vers := Byte(Bfr[$39]);  PH.Curr := 0;  BI.Length := 0;
  If PH.Vers<5 Then Raise EParadoxError.CreateFmt('%s: Unable to access tables'
      +' prior to Paradox 4.0',[Self.Name]);
  SetLength(Flds,PH.Flds);  p := @Bfr[6*PH.Flds+203+182*Ord(PH.Vers>11)];  fs := 0;
  For i := 0 to PH.Flds-1 Do begin {-Get Fld Name,Type,Len,Start-}
    Flds[i].Name := StrPas(p);  p := p+StrLen(p)+1;  Flds[i].Start := fs;
    Flds[i].Typ := Ord(Bfr[2*i+120]);  Flds[i].Len := Ord(Bfr[2*i+121]);
    If Flds[i].Typ=$17 Then Inc(fs,17)  Else Inc(fs,Flds[i].Len);   end{For i};
  First();  fActive := True;   end{Open};

{---- Close the Database & Index Files and Release Buffers -------------------}
procedure TParadox.Close;  begin
  If TFileRec(Pdox).Mode>fmClosed Then CloseFile(Pdox);
  If TFileRec(Indx).Mode>fmClosed Then CloseFile(Indx);
  If TFileRec(BLOb).Mode>fmClosed Then CloseFile(BLOb);
  SetLength(Bfr,0);  SetLength(Idx,0);  Flds := nil;  PH.Vers := 0;
  fActive := False;   end{Close};

{---- Position to the First Logical Record in the Table ----------------------}
Procedure TParadox.First;  begin
  If PH.Rcds=0 Then begin  fEOF := True;  Exit;  end;
  fEOF := False;  ReadDB(PH.First);   end{First};

{---- Position to the Next Logical Record in the Table ----------------------}
function TParadox.Next: Boolean;
begin  Result := False;
  If fEOF or not fActive Then Exit; {EOF or Not Open}
  If RcdIdx>DB.Last+6 Then {Read Next Block}
    If DB.Next<>0 Then ReadDB(DB.Next)  Else fEOF := True
  Else Inc(RcdIdx,PH.RcdLen); {Next Rcd in Bfr}
  Result := not fEOF;   end{Next};

{---- Get the Contents a Field as Text by Field Number (0 is the first) ------}
function TParadox.Field(FldNo: Integer): String;
  var  i,fs,fl: Integer;  pc: PChar;  dt: TDateTime;  s: String[7];
    si: SmallInt absolute s;  li: Integer absolute s;  d: Double absolute s;
begin
  If fEOF or not fActive or (FldNo<0) or (FldNo>=PH.Flds) Then begin
    Result := '<error>';  Exit;   end;
  fs := RcdIdx+Flds[FldNo].Start;  fl := Flds[FldNo].Len;
  pc := @Bfr[fs];  BI.Length := -1;
  If Flds[FldNo].Typ in [2..6,$14..$16] Then begin {-Cvt Numeric Types-}
    For i := 0 to fl-1 Do  s[fl-i-1] := Bfr[fs+i]; {Invert Low/High Bytes}
    s[fl-1] := Char(Ord(s[fl-1]) xor $80);   end; {Invert Sign Bit}
  Case Flds[FldNo].Typ of
    1: SetString(Result,pc, Min(StrLen(@Bfr[fs]),fl));                  {Alpha}
    2: begin  dt := li-693594;  Result := DateToStr(dt);  end;           {Date}
    3: Result := IntToStr(si);                                          {Short}
    4,$16: Result := IntToStr(li);                              {Integer,+Auto}
    5,6: Result := FloatToStr(d);                                {Money,Number}
    9: If Bfr[fs]=#$80 Then Result := 'False'  Else Result := 'True'; {Logical}
    $14: Result := TimeToStr(li/86400000);                              {*Time}
    $15: Result := DateTimeToStr(d/86400000-693594);               {*TimeStamp}
    $17: SetString(Result,pc,17); {Returns the Raw Value}                {*BCD}
    $18: SetString(Result,pc,fl);                                       {Bytes}
    $C..$10: begin  Move(pc[fl-10],BI,10);                              {BLOBs}
      SetString(Result,pc,Min(fl-10,BI.Length));   end;
    Else Result := '<Unknown Type>';
    end{Case};   end{Field};
{---- Get the Contents a Field as Text by FieldName --------------------------}
function TParadox.Field(FldName: String): String;  begin
  Result := Field(FieldIndex(FldName));   end{Field};

{---- Get the Contents a Field as Integer by Field Number --------------------}
function  TParadox.FieldAsInteger(FldNo: Integer): Int64;
  var  i,fs,fl: Integer;  dt: TDateTime;  s: String[7];
    si: SmallInt absolute s;  li: Integer absolute s;  d: Double absolute s;
begin
  If fEOF or not fActive or (FldNo<0) or (FldNo>=PH.Flds) Then begin
    Result := 0;  Exit;   end;
  fs := RcdIdx+Flds[FldNo].Start;  fl := Flds[FldNo].Len;
  If fl<9 Then begin
    For i := 0 to fl-1 Do  s[fl-i-1] := Bfr[fs+i]; {Invert Low/High Bytes}
    s[fl-1] := Char(Ord(s[fl-1]) xor $80); {Invert Sign Bit}   end;
  Case Flds[FldNo].Typ of
    2: begin  dt := li-693594;  Move(dt,Result,8);  end;                 {Date}
    3: Result := si;                                                    {Short}
    4,$16: Result := li;                                        {Integer,+Auto}
    5,6: Result := Round(d);                                     {Money,Number}
    9: Result := Ord(s[0]);                                           {Logical}
    $14: begin  dt := li/86400000;  Move(dt,Result,8);  end;            {*Time}
    $15: begin  dt := d/86400000-693594;  Move(dt,Result,8);  end; {*TimeStamp}
    Else Result := 0;{StrToIntDef(Field(FldNo),0);}
    end{Case};   end{FieldAsInteger};
{---- Get the Contents a Field as Integer by FieldName -----------------------}
function  TParadox.FieldAsInteger(FldName: String): Int64;   begin
  Result := FieldAsInteger(FieldIndex(FldName));   end{FieldAsInteger};

{---- Get The Field Type Code by Field Number or Name ------------------------}
function  TParadox.FieldType(FldNo: Integer): Integer;  begin
  If fEOF or not fActive or (FldNo<0) or (FldNo>=PH.Flds) Then Result := -1
  Else Result := Flds[FldNo].Typ;   end;
function  TParadox.FieldType(FldName: String): Integer;  begin
  Result := FieldType(FieldIndex(FldName));   end;

{---- Read BLOb Directly Into a Program Buffer  (by Field Number) ------------}
procedure TParadox.GetBlob(FldNo,BfrSiz: Integer; var BlobBfr);
  var  fs,fl: Integer;  pc: PChar;  MemoName: String;  fm: Byte;
begin
  If fEOF or not fActive or (FldNo<0) or (FldNo>=PH.Flds)
      or not (Flds[FldNo].Typ in [$C..$10]) Then begin
    PChar(BlobBfr) := #0;  Exit;   end{If fEOF};
  fs := RcdIdx+Flds[FldNo].Start;  fl := Flds[FldNo].Len;
  pc := @Bfr[fs];  Move(pc[fl-10],BI,10);
  If BI.Length>fl-10 Then begin {-Get BLOb from .mb file-}
    If TFileRec(BLOb).Mode<=fmClosed Then begin {Open the .mb file}
      fm := FileMode;  FileMode := fmOpenRead;
      MemoName := Copy(fTableName,1,Pos('.',fTableName))+'mb';
      Try  AssignFile(BLOb,MemoName);  Reset(BLOb,1);  FileMode := fm;
      Except on E:EInOutError Do
	Raise EParadoxError.CreateFmt('%s: Unable to open memo file "%s" - %s',
	    [Self.Name,MemoName,E.Message]);   end{Try};   end{If TFileRec};
    BI.Index := BI.FileLoc and $FF;  BI.FileLoc := BI.FileLoc and $FFFFFF00;
    If BI.FileLoc and $FF = $FF Then begin {-Read from a Single Blob Block-}
      Seek(BLOb, BI.FileLoc+9);  BlockRead(BLOb,BlobBfr,BI.Length);   end{If BI}
    Else begin {-Extract from a Suballocated Blob Block-}
      Seek(BLOb,BI.FileLoc+12+5*BI.Index);  BlockRead(BLOb,BX,5); {Blob Index}
      Seek(BLOb,BI.FileLoc+16*BX.Offset);
      BlockRead(BLOb,BlobBfr,Min(BfrSiz,BI.Length));   end{Else};
    end{If BI.Length>}
  Else Move(pc^,BlobBfr,BI.Length); {Get Blob from .db file}
  end{GetBlob};
{---- Read BLOb Directly Into a Program Buffer (by Field Name) ---------------}
procedure TParadox.GetBlob(FldName:String; BfrSiz:Integer; var BlobBfr);
  begin  GetBlob(FieldIndex(FldName),BfrSiz,BlobBfr);   end;


{---- Find the Next Table Row that Matches a Multi-Column Key ----------------}
{     Uses a really slow full table search.  Returns "True" if Found.         }
{     Search starts with current record, so call "Next" first for next match. }
function TParadox.Locate(FldNo: Array of Integer;
	 Val: Array of String): Boolean;
  var  i: Integer;  Found: Boolean;
begin   Result := False;  Found := False;
  If not fActive or (High(FldNo)<>High(Val)) then Exit;
  While not fEOF and not Found do begin   Found := True;
    For i := 0 to High(Val) Do
      If Field(FldNo[i])<>Val[i] Then begin  Found := False;  Break;  end;
    If not Found Then Next();   end{While};
  Result := Found;   end{Locate};

{---- Search for a Specified Record Using the Primary Key (Fast) -------------}
function  TParadox.FindKey(Val: Array of String): Boolean;
  var  b,b1,b2,bn,block,cmp,i,ip,len: Integer;  LookFor: String;  fm: byte;
begin   Result := False;  LookFor := '';
  If not fActive or (PH.Keys=0) or (High(Val)>PH.Keys) then Exit;
  If TFileRec(Indx).Mode<=fmClosed Then begin {-Open the .px file-}
    AssignFile(Indx,Copy(fTableName,1,Pos('.',fTableName))+'px');
    fm := FileMode;  FileMode := fmOpenRead;
    Try  Reset(Indx,1);  FileMode := fm;  BlockRead(Indx,PI,SizeOf(PI));
    Except on E:EInOutError Do
      Raise EParadoxError.CreateFmt('%s: Unable to open primary index %s - %s',
	  [Self.Name,TFileRec(Indx).Name,E.Message]);  end{Try};
    IndxSize := PI.Blk*1024;  SetLength(Idx,IndxSize+4);
    BlockRead(Indx,Idx[SizeOf(PI)],PI.HdrLen-SizeOf(PI)-1);
    PI.Curr := 0;   end{If <=fmClosed};
  For i := 0 to High(Val) Do {-Create Key to Match in Index-}
    LookFor := LookFor+Val[i]+StringOfChar(#0,Flds[i].Len-Length(Val[i]));
  len := Length(LookFor);  block := PI.Root;
  For i := 1 to PI.Levls Do begin {-Search down the index levels-}
    ReadPX(Block);  Idx[PX.Last+PI.RcdLen+7] := #$FF;
    bn := PX.Last div PI.RcdLen +1;  b1 := 0;  b2 := bn;
    Repeat {-Binary Search for entry1 < LookFor < entry2 in Index-}
      b := (b1+b2) div 2;  ip := b * PI.RcdLen + 7;
      cmp := CompareBytes(LookFor[1],Idx[ip],len);
      If cmp<0 Then b2 := b  Else b1 := b;  Until (b2-b1)<=1;
    If (b1=0) and (CompareBytes(LookFor[1],Idx[7],len)<0) Then Exit; {Too Low}
    ip := b2*PI.RcdLen+7;
    Block := (Ord(Idx[ip-6]) xor $80) shl 8 + Ord(Idx[ip-5]);   end{For i};
  ReadDB(Block);  Dec(RcdIdx,PH.RcdLen);
  Repeat   Inc(RcdIdx,PH.RcdLen); {-Find Key in Rcd-}
    cmp := CompareBytes(LookFor[1],Bfr[RcdIdx],len);
    If cmp=0 Then begin  Result := True;  Break;  end;
    Until (cmp<0) or (RcdIdx>DB.Last+6);
  end{FindKey};

{---- Update a Alpha Field in an Existing Row (by Field no. or Name) ---------}
function TParadox.WriteField(FldNo: Integer; Fld: String): Boolean;
  var  fs,fl,l: Integer;
begin   Result := False;
  If fEOF or not fActive or (FldNo<0) or (FldNo>=PH.Flds)
      or (Flds[FldNo].Typ<>1) Then Exit;
  fs := RcdIdx+Flds[FldNo].Start;  fl := Flds[FldNo].Len;
  l := Length(Fld);  Move(Fld[1],Bfr[fs],Min(fl,l));
  If fl>l Then FillChar(Bfr[fs+l],fl-l,0);
  WriteDB(PH.Curr);  Result := True;   end{WriteField};
function  TParadox.WriteField(FldName: String; Fld: String): Boolean;  begin
  Result := WriteField(FieldIndex(FldName),Fld);   end{WriteField};

{---- Get the Field Number of a Field by FieldName ---------------------------}
function TParadox.FieldIndex(FldName: String): Integer;
  var i: Integer;  begin
  For i := 0 to PH.Flds-1 Do
    If CompareText(FldName,Flds[i].Name)=0 Then begin
      Result := i;  Exit;   end;
  Result := -1;   end{FieldIndex};

{---- Get the FieldName of a Field by Number ---------------------------------}
function TParadox.FieldName(FldNo: Integer): String;  begin
  If (FldNo>=0) and (FldNo<PH.Flds) Then Result := Flds[FldNo].Name
  Else Result := '<error>';   end{FieldName};

{---- Get The Paradox Version of the Current Table ---------------------------}
function TParadox.Version: String;  begin
  Case PH.Vers of
    3:     Result := '3.0';
    4:     Result := '3.5';
    5..9:  Result := '4.0';
    10,11: Result := '5.0';
    12:    Result := '7.0';
    Else Result := '?';  end{Case};
  end{Version};

{---- Internal Routines to Read/Write a .db and .px Data Block ---------------}
function TParadox.ReadDB(BlkNo: Word): Boolean;  var AmtRead: Integer;  begin
  If (BlkNo<1) or (BlkNo>PH.Total) Then begin  Result := False;  Exit;  end;
  If BlkNo<>PH.Curr Then begin
    Seek(Pdox,(BlkNo-1)*fBlkSize+PH.HdrLen);
    BlockRead(Pdox,Bfr[1],fBlkSize,AmtRead);
    Move(Bfr[1],DB,6);  PH.Curr := BlkNo;   end;
  RcdIdx := 7;  Result := True;   end{ReadDB};
function TParadox.WriteDB(BlkNo: Word): Boolean;  begin
  If (BlkNo<1) or (BlkNo>PH.Total) Then begin  Result := False;  Exit;  end;
  Seek(Pdox,(BlkNo-1)*fBlkSize+PH.HdrLen);
  BlockWrite(Pdox,Bfr[1],fBlkSize);  Result := False;   end{WriteDB};
function TParadox.ReadPX(BlkNo: Word): Boolean;  begin
  If (BlkNo<1) or (BlkNo>PI.Total) Then begin  Result := False;  Exit;  end;
  If BlkNo<>PI.Curr Then begin
    Seek(Indx,(BlkNo-1)*IndxSize+PI.HdrLen);  BlockRead(Indx,Idx[1],IndxSize);
    Move(Idx[1],PX,6);  PI.Curr := BlkNo;   end;
  Result := True;   end{ReadPX};

{-----------------------------------------------------------------------------}
{  COMPAREBYTES Compares <Len> Bytes at V1 with Bytes at V2, Including 00h's  }
{  Returns: 1 if V1>V2, 0 if V1=V2 and -1 if V1<V2                            }
{-----------------------------------------------------------------------------}
function CompareBytes(const V1,V2; Len: Integer): Integer;
  asm		Push	ESI		{Save ESI,EDI}
		Push	EDI
		Mov	ESI,EAX		{Get Addr of V1}
		Mov	EDI,EDX		{Get Addr of V2, Len already in CX}
		RepE	CmpSB		{Compare v1 and V2}
		Mov     EAX,1		{Set V1>V@ code}
		JA      @Exit
		MOV	EAX,0		{Set V1=V2 code}
		JE	@Exit
		DEC	EAX		{Set V1<V2 code}
  @Exit:	Pop	EDI		{Restore EDI,ESI}
		Pop	ESI
  end{CompareBytes};


{---- Register this Weazel with Delphi IDE -----------------------------------}
procedure Register;  begin
  RegisterComponents('Data Access', [TParadox]);   end;

end.
