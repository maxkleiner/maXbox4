unit ExcelExport;

interface uses Windows, Classes, SysUtils, DB, DBGrids;

type
  TJsExcelExport = class(TObject)
    FBiff8:Boolean;
    FStream:TStream;
  private
    procedure WriteRecType(RecType, RecSize: word);
    procedure WriteFileHeader;
    procedure WriteEOF;
    procedure WriteSheetWindowInformation;

    procedure WriteXFRecord(IsStyleRecord: Boolean; AFontIndex, AFormatIndex: word; ATextAlignment: TAlignment);
    procedure WriteCellFormat(const AFormat:AnsiString; const aFormatIndex:word);

    procedure WriteString(const ACol, ARow: Word; const AValue: AnsiString);
    procedure WriteNumber(const ACol, ARow: Word; const AValue: Double);
    procedure WriteInteger(const ACol, ARow: Word; const AValue: Integer);
  public
    function ExportTable(ADataSet: TDataSet; AFileName: string): Boolean;
    function ExportGrid(AGrid: TDBGrid; AFileName: string): Boolean;
  end;


implementation uses Graphics;


procedure TJsExcelExport.WriteRecType(RecType, RecSize: word);
var	buf: array [0..1] of word;
begin
	buf[0] := RecType; // Record TypeID
	buf[1] := RecSize; // Anzahl der nachfolgenden Bytes
	FStream.Write(buf, SizeOf(buf));
end;


procedure TJsExcelExport.WriteCellFormat(const AFormat:AnsiString; const aFormatIndex:word);
// User-defined formats starten ab Index 164
var buf: array[0..2] of word;
    L: word;
begin
  L := Length(AFormat);
  buf[0] := $041E;
  buf[1] := 2 + L;
  buf[2] := aFormatIndex;
  FStream.WriteBuffer(buf, SizeOf(buf));
  FStream.WriteBuffer(Pointer(AFormat)^, L);
end;


// --- Extended Format Record ------------------------------------------------------------------------------------------
procedure TJsExcelExport.WriteXFRecord(IsStyleRecord: Boolean; AFontIndex, AFormatIndex: word; ATextAlignment: TAlignment);
// see Page 279

  procedure WriteXFRec_Biff8;
  var buf: array [0..11] of word;
  begin
    buf[0]:=$E0;
    buf[1]:=20;
    buf[2]:=AFontIndex;   // Index to FONT-Record
    if IsStyleRecord then buf[3]:=0 else buf[3]:=AFormatIndex; // Index to FORMAT-Record
    if IsStyleRecord then buf[4]:=$FFF5 else buf[4]:=$1;
    case ATextAlignment of
      taLeftJustify:  buf[5] := $20;
      taCenter:       buf[5] := $20+2;
      taRightJustify: buf[5] := $20+3;
      else            buf[5] := $20;
    end;
    if IsStyleRecord then buf[6] := $F400 else buf[6] := 0; // Text-Orientation
    buf[ 7] := 0; // Border line style
    buf[ 8] := 0; // Border line color left+right
    buf[ 9] := 0; // Border line top+bottom
    buf[10] := 0;
    buf[11] := $20C0; // Color-Index for fore-/background of the fill pattern
    FStream.WriteBuffer(buf, SizeOf(buf));
  end;

  procedure WriteXFRec_Biff5;
  var buf: array [0..9] of Word;
      al:byte;
  begin
    buf[0]:=$E0;
    buf[1]:=16;
    buf[2]:=AFontIndex;   // Index to FONT-Record
    if IsStyleRecord then buf[3]:=0 else buf[3]:=AFormatIndex; // Index to FORMAT-Record
    if IsStyleRecord then buf[4]:=$FFF5 else buf[4]:=$1;
     // Alignment
    al:=$20; // Vertikal: (Bit 4,5,6): 0=Top, 1=Centered, 2=Bottom, 3=Justified
    case ATextAlignment of // Horizontal (Bit 0,1,2): 0=General, 1=Left, 2=Centered, 3=Right, 4=Filled, 5=Justified.
      taCenter:       al := al+2;
      taRightJustify: al := al+3;
    end;
    if IsStyleRecord then buf[5] := MakeWord(al,$F4) else buf[5] := MakeWord(al,0);  // Text-Orientation
    buf[ 6] := $20C0; // Color-Index for fore-/background of the fill pattern
    buf[ 7] := 0;     // Border line style and colors
    buf[ 8] := 0;
    buf[ 9] := 0;
    FStream.WriteBuffer(buf, SizeOf(buf));
  end;

begin
   if FBiff8
   then WriteXFRec_Biff8
   else WriteXFRec_Biff5;

{
E000 1000 0000 0000 F5FF 20F4 C020 0000 0000 0000  // 15 * style-FX
E000 1000 0000 0000 0100 2000 C020 0000 0000 0000  // 1 * cell-FX
E000 1000 0500 0000 0100 2000 C020 0000 0000 0000  // general
E000 1000 0500 0400 0100 2000 C020 0000 0000 0000  // 4er Format
}
{Waler: XF-Records in BIFF4
                Format
                Font
    ($443, 12, $0000, $FFF5, $0020, $CE00, 0, 0);
    ($443, 12, $0001, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0001, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0002, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0002, $FFF5, $F420, $CE00, 0, 0);

    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);
    ($443, 12, $0000, $FFF5, $F420, $CE00, 0, 0);

    ($443, 12, $0000, $0001, $0020, $CE00, 0, 0);  // der einzige Cell XF record

    ($443, 12, $2101, $FFF5, $F820, $CE00, 0, 0);
    ($443, 12, $1F01, $FFF5, $F820, $CE00, 0, 0);
    ($443, 12, $2001, $FFF5, $F820, $CE00, 0, 0);
    ($443, 12, $1E01, $FFF5, $F820, $CE00, 0, 0);


  // Additional Style Formats
    ($293, 4, $9010, $FF03);
    ($293, 4, $9011, $FF06);
    ($293, 4, $9012, $FF04);
    ($293, 4, $9013, $FF07);
    ($293, 4, $9010, $FF00);
    ($293, 4, $9014, $FF05);
}
end;


procedure TJsExcelExport.WriteFileHeader;
const
  cWindow1: array [0..10] of Word =
    ($3D,
     18,     // 18 nachfolgende Bytes
     0,      // Horizontal position of the window in Twips (1/20 of a point)
     0,      // Vertical position of the window in Twips
     400*20, // Width of the window in Twips
     200*20, // Height of the window in Twips
     $38,    // Option flags
     0,      // Index of the selected workbook tab (0-based)
     0,      // Index of the first displayed workbook tab (0-based)
     1,      // Number of workbook tabs that are selected
     $258);  // Ratio of the width of the workbook tabs to the width of the horizontal scroll bar

  cStyleInformation: array[0..3] of Word =
    ($293,
     4,      // 4 nachfolgende Bytes
     $8000,  // Index to the style XF record ($8000=Built in Styles)
     $FF00); //
{
  // Waler:
    ($293, 4, $9010, $FF03);
    ($293, 4, $9011, $FF06);
    ($293, 4, $9012, $FF04);
    ($293, 4, $9013, $FF07);
    ($293, 4, $9000, $FF00);
    ($293, 4, $9014, $FF05);
}

	 procedure WriteWindowRecord;
	 const
		 A: array [0..21] of Byte = (
			$3d, $00, $12, $00, $00, $00, $69, $00, $9f, $33, $5d, $1b, $38, $00,	$00, $00, $00, $00, $01, $00, $58, $02);
	 begin
	  	FStream.Write(A, SizeOf(A));
	 end;


   procedure WriteCodePage;
   var buf: array[0..2] of word;
   begin
     {
     buf[0]:=$42;
     buf[1]:=2;
     buf[2]:=GetACP;
     FStream.WriteBuffer(buf, SizeOf(buf));
     }
   end;

   procedure WriteColorPalette;
   const cColorPalette=$92;
   var n:Word;
      procedure WriteColor(value:TColor);
      var buf: array [0..3] of Byte;
          color: integer;
      begin
        color:=ColorToRGB(value);
        buf[0]:=GetRValue(color);
        buf[1]:=GetGValue(color);
        buf[2]:=GetBValue(color);
        buf[3]:=0;
        FStream.WriteBuffer(buf, SizeOf(buf));
      end;
   begin
     n:=1;
     WriteRecType(cColorPalette, 2 + (4*n));
     FStream.WriteBuffer(n, 2);
     WriteColor(clBlack);
{
     WriteColor(clWhite);
     WriteColor(clRed);
     WriteColor(clLime);
     WriteColor(clBlue);
     WriteColor(clYellow);
     WriteColor(clFuchsia);
     WriteColor(clAqua);
     WriteColor(clMaroon);
     WriteColor(clGreen);
     WriteColor(clNavy);
     WriteColor(clOlive);
     WriteColor(clPurple);
     WriteColor(clTeal);
     WriteColor(clSilver);
     WriteColor(clGray);
}
   end;


   procedure WriteFonts;
      procedure WriteFont(AFont: TFont);
      var buf: array [0..8] of word;
          S: AnsiString;
          L:Byte;
      begin
        S := AFont.Name;
        L := Length(S);

//        buf[0]:=$231;
        buf[0]:=$31;  // $231 in Biff3 und Biff4
        buf[1]:=14 + 1 + L;
        buf[2]:=AFont.Size * 20;   // Height of the Font in Twips (1/20 of a point)
        buf[3]:=0;                 // Font-Attributes
        if fsItalic in AFont.Style then buf[3] := buf[3] + 2;
        if fsStrikeOut in AFont.Style then buf[3] := buf[3] + 4;
        buf[4]:=$8;                // Index to the Colour Palette ($8=Black, $9=White, $A=Red)
        if fsBold in AFont.Style   // Font-Weight "Boldness" (100-1000)
        then buf[5] := 700         // 700=Bold Text
        else buf[5] := 400;        // 400=Normal Text
        buf[6] := 0;               // 1=Superscript, 2=Subscript
        buf[7] := MakeWord(0,0);   // LowByte: Underline-Style 1=Single, 2=Double.   HiByte: Font-Family 0=DontCare
        if fsUnderline in AFont.Style then buf[7] := MakeWord(1,0);
        buf[8] := MakeWord(AFont.Charset, 0);   // LowByte: Character Set.  HiByte: Reserved
        FStream.WriteBuffer(buf, SizeOf(buf));
        FStream.WriteBuffer(L, 1); // Länge als Byte, nicht Word
        FStream.WriteBuffer(Pointer(S)^, L);
      end;

   var AFont:TFont;
       i:integer;
   begin
     AFont := TFont.Create;
     try
        AFont.Name:='Arial';
        AFont.Size:=10;
        for i:=1 to 5 do WriteFont(AFont);
     finally
        AFont.Free;
     end;
   end;


   procedure WriteBof(IsWorkBook: Boolean);
   const buf2: array[0..3] of word = (0, 0, 0, 0);
   var buf: array[0..5] of word;
   begin
     buf[0]:=$809;
     if FBiff8 then buf[1]:=16 else buf[1]:=8; // Anzahl der nachfolgenden Bytes
     if IsWorkBook
     then if FBiff8
          then buf[2]:=$600 // BIFF-Version: 5=BIFF5 und BIFF7, 6=BIFF8
          else buf[2]:=$500
     else buf[2]:=0;
     if IsWorkBook then buf[3]:=$05 else buf[3]:=$10; // Substream-Type: 5=Workbook, $10=Worksheet
     if FBiff8
     then begin
            buf[4]:=$0DBB; // Build identifier: $0DBB=Excel97
            buf[5]:=$07CC; // Build year: $07CC=Excel97
     end
     else begin
            buf[4]:=$126B; // Build identifier (internal use only)
            buf[5]:=$07CC; // Build year (internal use only)
     end;
     FStream.WriteBuffer(buf, SizeOf(buf));
     // nur BIFF8 (ab Excel97): File history flags (4 Bytes) und Lowest BIFF version that can read all records in this file (4 Bytes)
     if FBiff8 then FStream.WriteBuffer(buf2, SizeOf(buf2));
   end;


   procedure WriteSheetName(SheetName:AnsiString);
   // in den Workbook Global Stream schreiben
   var buf: array[0..4] of word;
       L:Byte;
       StreamPos:cardinal; //=LongWord
   begin
     L := Length(SheetName);
     if L=0 then exit;
     StreamPos:=FStream.Size + SizeOf(buf) + 1 + L + 4;

     buf[0]:=$85;   // =Boundsheet
     buf[1]:=7 + L; // Anzahl der nachfolgenden Bytes
     buf[2]:=LoWord(StreamPos); // Stream position of the start of the BOF record for the sheet (4 Bytes). Gemessen vom Workbook-BoF!
     buf[3]:=HiWord(StreamPos);
     buf[4]:=0;     // Option flags: 0=Visible, 1=Hidden, 2=very hidden
     FStream.WriteBuffer(buf, SizeOf(buf));
     FStream.WriteBuffer(L, 1); // Länge als Byte, nicht Word
     FStream.WriteBuffer(Pointer(SheetName)^, L);
   end;


   procedure WriteSheetDimensions;
   const buf2: array[0..1] of word = (0, 0);
   var buf: array[0..6] of word;
   begin
     buf[0]:=$200;
     if FBiff8 then buf[1]:=14 else buf[1]:=10; // Anzahl der nachfolgenden Bytes
     buf[2]:=0;
     buf[3]:=0;
     buf[4]:=0;
     buf[5]:=0;
     buf[6]:=0;
     FStream.WriteBuffer(buf, SizeOf(buf));
     if FBiff8 then FStream.WriteBuffer(buf2, SizeOf(buf2));
   end;


var i:integer;
begin
  FBiff8:=false;

  // BoF WorkBook ($809)
  WriteBof(true);

  // Windows-Code-Page ($42)
  WriteCodePage;

  // Window Information ($3D)
//  FStream.WriteBuffer(cWindow1, SizeOf(cWindow1));
  WriteWindowRecord;

  // 5 Fonts ($31)
  WriteFonts;

  // 15 Style XF-Records ($E0)
  for i:=0 to 14 do WriteXFRecord(True, 0, 0, taLeftJustify);

  // 1 Cell XF-Record
  WriteXFRecord(False, 0, 0, taLeftJustify);

  // User defined Cell XF-Records
  WriteXFRecord(False, 5, 0, taLeftJustify);
  WriteXFRecord(False, 5, 4, taLeftJustify);

  // 1 Style Record ($293)
  FStream.WriteBuffer(cStyleInformation, SizeOf(cStyleInformation));

  // Colors (optional) ($92)
  WriteColorPalette;

  // alle Sheet-Names mit der BoF-Position ($85)
  WriteSheetName('Sheet1');

  // Eof WorkBook ($0A)
  WriteEOF;

  // -------------
  // BoF WorkSheet
  // -------------
  WriteBof(false);

  WriteSheetDimensions; // ($200)


  // Daten
end;


procedure TJsExcelExport.WriteEOF;
const cEof: array[0..1] of Word = ($0A, 0);
begin
  FStream.WriteBuffer(cEof, SizeOf(cEof));
end;


procedure TJsExcelExport.WriteSheetWindowInformation;
// in den Worksheet Stream schreiben
const buf2: array[0..3] of word = (0, 0, 0, 0);
var buf: array[0..6] of word;
begin
  buf[0]:=$23E; // =Window2
  if FBiff8 then buf[1]:=18 else buf[1]:=10; // Anzahl der nachfolgenden Bytes
//     buf[2]:=$00B6;
  buf[2]:=$06B6; // Option flags
  buf[3]:=0;     // Top row visible in the window
  buf[4]:=0;     // Leftmost column visible in the window
  buf[5]:=0;     // Index to color value for row/column headings and gridlines
  buf[6]:=0;
  FStream.WriteBuffer(buf, SizeOf(buf));
  if FBiff8 then FStream.WriteBuffer(buf2, SizeOf(buf2));
end;


procedure TJsExcelExport.WriteString(const ACol, ARow: Word; const AValue: AnsiString);
var buf: array[0..5] of word;
    L: Word;
begin
{
  if AValue<>'' then begin
     L := Length(AValue);
     buf[0] := $204;
     buf[1] := 8 + L;
     buf[2] := ARow;
     buf[3] := ACol;
     buf[4] := 16;
     buf[5] := L;
     FStream.WriteBuffer(buf, SizeOf(buf));
     FStream.WriteBuffer(Pointer(AValue)^, L);
  end;
}
end;

{
procedure TJsExcelExport.WriteString(const ACol, ARow: Word; const AValue: AnsiString);
var buf: array[0..4] of word;
    L: Word;
begin
  if AValue<>'' then begin
     L := Length(AValue);
     buf[0] := $204;   // $18
     buf[1] := 6 + L;
     buf[2] := ARow;
     buf[3] := ACol;
     buf[4] := 16;
     FStream.WriteBuffer(buf, SizeOf(buf));
     FStream.WriteBuffer(Pointer(AValue)^, L);
  end;
end;
}
{
procedure TJsExcelExport.WriteString(const ACol, ARow: Word; const AValue: AnsiString);
var buf: array[0..5] of word;
    L: Word;
    flag: byte;
begin

  if AValue<>'' then begin
     flag:=0;
     L := Length(AValue);
     buf[0] := $18;
     buf[1] := 9 + L;
     buf[2] := ARow;
     buf[3] := ACol;
     buf[4] := 16;
     buf[5] := L;
     FStream.WriteBuffer(buf, SizeOf(buf));
     FStream.WriteBuffer(flag, SizeOf(flag));
     FStream.WriteBuffer(Pointer(AValue)^, L);
  end;

end;
}

procedure TJsExcelExport.WriteNumber(const ACol, ARow: Word; const AValue: Double);
var buf:array[0..4] of word;
    CellAttribute: array [0..1] of Byte;
    iFormatIndex:word;
begin
{
  iFormatIndex:=2;
	CellAttribute[0] := iFormatIndex and $FF;
	CellAttribute[1] := (iFormatIndex shr 8) and $FF;

  buf[0] := $203;
  buf[1] := 14;
  buf[2] := ARow;
  buf[3] := ACol;
  buf[4] := 17;    // XF-Record-Index
  FStream.WriteBuffer(buf, SizeOf(buf));
  FStream.WriteBuffer(AValue, SizeOf(Double));
}
end;

procedure TJsExcelExport.WriteInteger(const ACol, ARow: Word; const AValue: Integer);
var buf:array[0..4] of word;
    V:integer;
begin
  WriteNumber(ACol, ARow, AValue);

{
  buf[0] := $27E;
  buf[1] := 10;
  buf[2] := ARow;
  buf[3] := ACol;
  buf[4] := 17;
  FStream.WriteBuffer(buf, SizeOf(buf));
  V := (AValue shl 2) or 2;
  FStream.WriteBuffer(V, SizeOf(Integer));
}
end;


// ---------------------------------------------------------------------------------------------------------------------
function TJsExcelExport.ExportGrid(AGrid: TDBGrid; AFileName: string): Boolean;
var MaxCols:integer;

  procedure WriteRecord(ARow:integer);
  var x:integer;
      ft:TFieldType;
  begin
    with AGrid do begin
         for x := 0 to MaxCols - 1 do begin
             if Columns[x].Visible then begin
                if not Columns[x].Field.IsNull then begin
                   ft:=Columns[x].Field.DataType;
                   case ft of
                     ftSmallint,
                     //ftShortint,
                     ftInteger,
                     ftLargeint,
                     ftWord:  WriteInteger(x, ARow, Columns[x].Field.AsInteger);
                     ftFloat: WriteNumber (x, ARow, Columns[x].Field.AsFloat)
                     else     WriteString (x, ARow, Columns[x].Field.AsString);
                   end;
                end;
             end;
         end;
    end;
  end;

var x,y,i:integer;
    b: TBookmarkStr;
begin
  Result := False;

  if (AGrid=nil) or (AGrid.DataSource=nil) or (AGrid.DataSource.Dataset=nil) or (not AGrid.DataSource.Dataset.Active) then exit;

  FStream := TFileStream.Create(PWideChar(AFileName), fmCreate or fmOpenWrite);
  try
     WriteFileHeader;

     with AGrid.DataSource.DataSet do begin
          MaxCols:=AGrid.Columns.Count;
          y:=0;
          for x := 0 to MaxCols - 1 do begin
              if AGrid.Columns[x].Visible then WriteString(x, y, AGrid.Columns[x].Title.Caption);
          end;
          inc(y);


          DisableControls;
          b:=Bookmark;
          try
             if AGrid.SelectedRows.Count>0
             then begin
                    for i:=0 to AGrid.SelectedRows.Count-1 do begin
                        Bookmark:=AGrid.SelectedRows[i];
                        WriteRecord(y);
                        inc(y);
                    end;
             end
             else begin
                    First;
                    while not eof do begin
                          WriteRecord(y);
                          Next;
                          inc(y);
                    end;
             end;
             Bookmark:=b;
          finally
             EnableControls;
          end;
     end;

     // Sheet Window Information (Window2)
     WriteSheetWindowInformation;
     WriteEof;

     Result := True;
  finally
     FStream.Free;
  end;
end;


// ---------------------------------------------------------------------------------------------------------------------
function TJsExcelExport.ExportTable(ADataSet: TDataSet; AFileName: string): Boolean;
var MaxCols:integer;

  procedure WriteRecord(ARow:integer);
  var x:integer;
      ft:TFieldType;
  begin
    with ADataSet do begin
         for x := 0 to MaxCols - 1 do begin
             if Fields[x].Visible then begin
                if not Fields[x].IsNull then begin
                   ft:=Fields[x].DataType;
                   case ft of
                     ftSmallint,
                     //ftShortint,
                     ftInteger,
                     ftLargeint,
                     ftWord:  WriteInteger(x, ARow, Fields[x].AsInteger);
                     ftFloat: WriteNumber (x, ARow, Fields[x].AsFloat)
                     else     WriteString (x, ARow, Fields[x].AsString);
                   end;
                end;
             end;
         end;
    end;
  end;

var x,y,i:integer;
    b:TBookmarkStr;
begin
  Result := False;

  if (ADataSet=nil) or (not ADataset.Active) then exit;

  FStream := TFileStream.Create(PWideChar(AFileName), fmCreate or fmOpenWrite);
  try
     WriteFileHeader;

     with ADataSet do begin
          MaxCols:=FieldCount;
{
          for x := 0 to MaxCols - 1 do
              if (Fields[x].Visible)
              then if (Fields[x].DataType in [ftFloat])
                   then WriteCellFormat('#,##0')
                   else WriteCellFormat('General');
}
          y:=0;
          for x := 0 to MaxCols - 1 do
              if Fields[x].Visible then WriteString(x, y, Fields[x].DisplayLabel);
          inc(y);


          DisableControls;
          b:=Bookmark;
          try
             First;
             while not eof do begin
                   WriteRecord(y);
                   Next;
                   inc(y);
             end;

             Bookmark:=b;
          finally
             EnableControls;
          end;
     end;

     // Sheet Window Information (Window2)
     WriteSheetWindowInformation;
     WriteEof;

     Result := True;
  finally
     FStream.Free;
  end;
end;

end.
