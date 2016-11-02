unit IFSI_SysUtils_max;
{
code implementing the class wrapper is fpr mX3 Win & Linux
  with functions of classes
  stdin, stdout, stderr, processpath
  include system const and functions   TFormClass , Overloads with *2 at end
  for example filecreate and function FileCreate2(const FileName: string; Rights: Integer): Integer; overload; inline;
     function GetFileSize2(Handle: Integer; x: Integer): Integer; stdcall;
  pointers are in sysutils_max, upsc_db, upsi_dbtables, upsi_jclbase, jvgutils , jvutils, jvjclutils, jvvclutils
  jvparsing, JclSysInfo, JvBdeUtils, jclgraphutils, jcctrlutils
 All: jvjclutils/jvctrutils/jvvclutils/dbtables/db/
  queryperformancecounter, REST Routines, boolean - bool (longbool)}
  //APPCOMMAND Shell Consts 3.9.9.80     locs 4311
   // TBytes  one and only   , TMemoryStatus , ISwindow ,assignfile, closefile  fix, bugfix loadresource

{$I PascalScript.inc}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler, Windows, JCLBase;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_SysUtils = class(TPSPlugin)
  protected
    procedure CompOnUses(CompExec: TPSScript); override;
    procedure ExecOnUses(CompExec: TPSScript); override;
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure CompileImport2(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
    procedure ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;

 PStrData = ^TStrData;
  TStrData = record
    Ident: Integer;
    Str: string;
  end;

  TDaynames = array[1..7] of string;
  TMonthnames = array[1..12] of string;

  Tforleadbytes = set of char;

  //TFormclass;

  TTextStream = class(TObject)
      private
        FHost: TStream;
        FOffset,FSize: Integer;
        FBuffer: array[0..1023] of Char;
        FEOF: Boolean;
        function FillBuffer: Boolean;
      protected
        property Host: TStream read FHost;
      public
        constructor Create(AHost: TStream);
        destructor Destroy; override;
        function ReadLn: string; overload;
        function ReadLn(out Data: string): Boolean; overload;
        property EOF: Boolean read FEOF;
        property HostStream: TStream read FHost;
        property Offset: Integer read FOffset write FOffset;
      end;


{ procedure ReadFileByLine(Filename: string);
var
  sLine: string;
  tsFile: TTextStream;
begin
  tsFile := TTextStream.Create(TFileStream.Create(Filename, fmOpenRead or    fmShareDenyWrite));
  try
    while tsFile.ReadLn(sLine) do
    begin
      //sLine is your line
    end;
  finally
    tsFile.Free;
  end;
end; }

{ compile-time registration functions }
procedure SIRegister_EWin32Error(CL: TPSPascalCompiler);
procedure SIRegister_EOSError(CL: TPSPascalCompiler);
procedure SIRegister_Exception(CL: TPSPascalCompiler);
procedure SIRegister_EStackOverflow(CL: TPSPascalCompiler);
procedure SIRegister_EExternal(CL: TPSPascalCompiler);
procedure SIRegister_EInOutError(CL: TPSPascalCompiler);
procedure SIRegister_EHeapException(CL: TPSPascalCompiler);
procedure SIRegister_EInvalidPassword(CL: TPSPascalCompiler);
//procedure SIRegister_Exception(CL: TPSPascalCompiler);
procedure SIRegister_EInvalidOperation(CL: TPSPascalCompiler);
procedure SIRegister_TLanguages(CL: TPSPascalCompiler);
procedure SIRegister_SysUtils(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_SysUtils_Routines(S: TPSExec);
procedure RIRegister_EWin32Error(CL: TPSRuntimeClassImporter);
procedure RIRegister_EOSError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EStackOverflow(CL: TPSRuntimeClassImporter);
procedure RIRegister_EInvalidPassword(CL: TPSRuntimeClassImporter);
procedure RIRegister_EExternal(CL: TPSRuntimeClassImporter);
procedure RIRegister_EInOutError(CL: TPSRuntimeClassImporter);
procedure RIRegister_EHeapException(CL: TPSRuntimeClassImporter);
procedure RIRegister_Exception(CL: TPSRuntimeClassImporter);
procedure RIRegister_EInvalidOperation(CL: TPSRuntimeClassImporter);
//procedure RIRegister_EInvalidOperation(CL: TPSPascalCompiler);
procedure RIRegister_TLanguages(CL: TPSRuntimeClassImporter);
procedure RIRegister_SysUtils(CL: TPSRuntimeClassImporter);



implementation

uses
   Types
  //,Libc
  ,FileCtrl
  ,SysConst
  ,Graphics
  ,Controls
  ,Forms
  ,DB
  ,uPSC_dateutils
  ,sdpStopwatch
  ,tlhelp32
  //,xmldom, XMLIntf, XMLDoc, ComCtrls
  //,classes
  ;

type marrstr = array of string;

{ compile-time importer function }
(*----------------------------------------------------------------------------
 So, you may use the below RegClassS() replacing the CL.AddClassN()
 of the various SIRegister_XXXX calls
 ----------------------------------------------------------------------------*)

    { TTextStream }

    constructor TTextStream.Create(AHost: TStream);
    begin
      FHost := AHost;
      FillBuffer;
    end;

    destructor TTextStream.Destroy;
    begin
      FHost.Free;
      inherited Destroy;
    end;

    function TTextStream.FillBuffer: Boolean;
    begin
      FOffset := 0;
      FSize := FHost.Read(FBuffer,SizeOf(FBuffer));
      Result := FSize > 0;
      FEOF := Result;
    end;

    function TTextStream.ReadLn(out Data: string): Boolean;
    var
      Len, Start: Integer;
      EOLChar: Char;
    begin
      Data:='';
      Result:=False;
      repeat
        if FOffset>=FSize then
          if not FillBuffer then
            Exit; // no more data to read from stream -> exit
        Result:=True;
        Start:=FOffset;
        while (FOffset<FSize) and (not (FBuffer[FOffset] in [#13,#10])) do
          Inc(FOffset);
        Len:=FOffset-Start;
        if Len>0 then begin
          SetLength(Data,Length(Data)+Len);
          Move(FBuffer[Start],Data[Succ(Length(Data)-Len)],Len);
        end else
          Data:='';
      until FOffset<>FSize; // EOL char found
      EOLChar:=FBuffer[FOffset];
      Inc(FOffset);
      if (FOffset=FSize) then
        if not FillBuffer then
          Exit;
      if FBuffer[FOffset] in ([#13,#10]-[EOLChar]) then begin
        Inc(FOffset);
        if (FOffset=FSize) then
          FillBuffer;
      end;
    end;

    function TTextStream.ReadLn: string;
    begin
      ReadLn(Result);
    end;


{procedure DomToTree(anXmlNode: IXMLNode; aTreeNode: TTreeNode; aTreeView: TTreeView);
var
  I: Integer;
  NewTreeNode: TTreeNode;
  NodeText: string;
  AttrNode: IXMLNode;
begin
  // skip text nodes and other special cases
  if anXmlNode.NodeType <> ntElement then
    Exit;
  // add the node itself
  NodeText := anXmlNode.NodeName;
  if anXmlNode.IsTextElement then
    NodeText := NodeText + ' = ' + anXmlNode.NodeValue;
  NewTreeNode := aTreeView.Items.AddChild(aTreeNode, NodeText);
  // add attributes
  for I := 0 to anXmlNode.AttributeNodes.Count - 1 do begin
    AttrNode := anXmlNode.AttributeNodes.Nodes[I];
    aTreeView.Items.AddChild(NewTreeNode,
      '[' + AttrNode.NodeName + ' = "' + AttrNode.Text + '"]');
  end;
  // add each child node
  if anXmlNode.HasChildNodes then
    for I := 0 to anXmlNode.ChildNodes.Count - 1 do
      DomToTree (anXmlNode.ChildNodes.Nodes [I], NewTreeNode, aTreeView);
end;}


function getProcessList: TStrings;
var
  t  : THandle;
  pe : TProcessEntry32;
  HasProcess: boolean;
  ProcessList : TList;
  mylist: TStringlist;
begin
  //LoadText;
  mylist:= TStringlist.create;
  ProcessList := TList.Create;
  t := CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  try
    pe.dwSize:= SizeOf(pe);
    HasProcess := Process32First(t, pe);
    while HasProcess do begin
      mylist.Add(pe.szExeFile);
      //ProcessCombo.Items.Add(pe.szExeFile);
      ProcessList.Add(pointer(pe.th32ProcessId));
      HasProcess := Process32Next(t, pe);
    end;
    result:= mylist;
    //ProcessCombo.ItemIndex:= 0;
  finally
    CloseHandle(t);
    //mylist.free;
  end;
end;

type
  PLargeInteger2 = ^TLargeInteger2;
  TLargeInteger2 = record
    case Integer of
    0: (
      LowPart: LongWord;
      HighPart: Longint);
    1: (
      QuadPart: Int64);
  end;


threadvar                               //test frame
    SafeCallExceptionMsg: String;

//function GetSafeCallExceptionMsg: String;
function GetSafeCallExceptionMsg: String;
begin
  Result := SafeCallExceptionMsg;
end;


function loadForm(vx, vy: smallint): TForm;
begin
  //psize:= vx*vy
  //constructor
  result:= Tform.create(Nil);
  with result do begin
    caption:= 'LEDBOX Formtemplate';  
    //width:= (vx*psize)+ 10;
    //height:= (vy*psize)+ 30;
    color:= clblack;
    formstyle:= fsstayOnTop;
    setBounds(0,0,vx,vy);
    BorderStyle:= bsDialog;
    Position:= poScreenCenter;
    //OnClick:= @Label1Click;
    //ondblclick:=  @saveproimage;
    //onmousedown:=  @saveproimagemousedown;
    //onclick:=  @newimage;
    show;
  end
end;

procedure paintprocessingstar2(ppform: Tform);
var winkel, laenge, dx,dy: double;
    breite, mousex, mousey: integer;
begin
  mousex:= ppform.width div 2;
  mousey:= ppform.height div 2;
  breite:= random(7)+1;
  ppform.canvas.pen.width:= breite;
  ppform.canvas.pen.color:= random(clred+clgreen);
  //winkel:= random2(round(2*PI))
  winkel:= random *(2*PI);
  laenge:= random(round((ppform.height/2)*(7-breite/6)))-550;
  // orig processing laenge:= random2(min(width/2, height/2))*(7-breite)/6);
   //+(ppform.width/2);
    //laenge:= random2(round((ppform.height/2)*(7-breite/6)))+(ppform.width/2);
  dx:= cos(winkel)*laenge;
  dy:= sin(winkel)*laenge;
  ppform.canvas.moveto(mousex, mouseY);
  ppform.canvas.lineto(round(mouseX+dx), round(mouseY+dy))
  
  //for it:= 1 to 100 do
    //  curvez(it,it)
end;



function QueryPerformanceFrequency1(var Freq: Int64): Boolean;
//var
  //T: TLargeInteger2;
begin
  result:= QueryPerformanceFrequency(Freq);
  //CardinalsToI64(Frequency, T.LowPart, T.HighPart);
end;

//--------------------------------------------------------------------------------------------------

procedure QueryPerformanceCounter1(var aC: Int64);
//var //T: TLargeInteger;
begin
  QueryPerformanceCounter(aC);
  //CardinalsToI64(C, T.LowPart, T.HighPart);
end;


Function CharToBin(vChr: Char): String;
Var
  i: Integer;
Begin
  For i:= SizeOf(vChr) * 8 - 1 Downto 0 Do
    Result:= Format('%s%d', [Result, Byte((Ord(vChr) And (1 Shl i)) <> 0)]);
End;


function ByteToChar(const value: Byte): Char;
begin
  //Result := Char(Byte);
  Result:= (chr(value));
end;

function LogicalAnd(A, B: Integer): Boolean;
begin
  Result := (A and B) = B;
end;


type
  TSte = Array[1..8] of Integer;

function BinToChar(St: String): Char;
var
  S: String;
  C, I: Byte;
  Ste: TSte;
begin
  Ste[1]:= 128; Ste[2]:= 64; Ste[3]:= 32; Ste[4]:=16;
  Ste[5]:= 8;   Ste[6]:= 4;  Ste[7]:= 2;  Ste[8]:=1;
  S:= Copy(St,1,8);
  Delete(St,1,8);
  C:= 0;
  For I:=1 to 8 do
    C:=C+Ste[I]*StrToInt(S[I]);
  Result:= Chr(C);
end;

procedure FreeAndNil2(var Obj: TObject);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj):= nil;
  Temp.Free;
end;

function TryStrToInt(const S: AnsiString; var I: Integer): Boolean;
var Error : Integer;
begin
  Val(S, I, Error);
  Result := Error = 0;
end;

procedure myVal(S: string; var I: int64; Error: integer);
begin
  Val(S, I, Error);
end;


function TryStrToInt64(const S: AnsiString; var I: Int64): Boolean;
var Error : Integer;
begin
  Val(S, I, Error);
  Result := Error = 0;
end;

const
  Dummy32bitResHeader: array[0..31] of Byte = (
    $00, $00, $00, $00, $20, $00, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00);


function BytesToStr(const Value: TBytes): String;
var I: integer;
    Letra: char;
begin
  result:= '';
  for I:= Length(Value)-1 Downto 0 do begin
    letra:= Chr(Value[I] + 48);
    result:= letra + result;
  end;
end;


function GetResourceName(ObjStream: TStream; var AName: string): Boolean;
var
  LPos: Int64;
  LName: TBytes;
  I: Integer;
  Len: Byte;
begin
  Result := False;
  LPos := ObjStream.Position;
  try
    ObjStream.Position := SizeOf(Longint); { Skip header }
    ObjStream.Read(Len, 1);

    { Skip over object prefix if it is present }
    if Len and $F0 = $F0 then begin
      if ffChildPos in TFilerFlags((Len and $F0)) then begin
        ObjStream.Read(Len, 1);
        case TValueType(Len) of
          vaInt8: Len := 1;
          vaInt16: Len := 2;
          vaInt32: Len := 4;
        end;
        ObjStream.Read(I, Len);
      end;
      ObjStream.Read(Len, 1);
    end;

    SetLength(LName, Len);
    ObjStream.Read(LName[0], Len);
    // See if there are any UTF8 chars in the name
    for I := Low(LName) to High(LName) do
      if LName[I] and $80 <> 0 then begin
        AName := UpperCase(BytesToStr(LName));
        Result := True;
        Exit;
      end;
//    AName := UpperCase(TEncoding.Default.GetString(LName));
   AName:= UpperCase(BytesToStr(LName));
  finally
    ObjStream.Position := LPos;
  end;
end;


procedure Write16bitResourceHeader(const AName: TBytes; DataSize: Integer; Output: TStream);
var
  Data: Word;
  NameSize: Integer;
begin
  NameSize := Length(AName) + 1;
  // Write the resource type
  Data := $FF;
  Output.Write(Data, SizeOf(Byte));
  Data := 10;
  Output.Write(Data, SizeOf(Data));
  // Write the resource name
  Output.WriteBuffer(AName[0], NameSize - 1);
  Data := 0;
  Output.Write(Data, SizeOf(AnsiChar));
  // Write the resource flags
  Data := $1030;
  Output.Write(Data, SizeOf(Data));
  // Write the data size
  Output.Write(DataSize, SizeOf(DataSize));
end;

procedure Write32bitResourceHeader(const AName: TBytes; DataSize: Integer; Output: TStream);
var
  Data: Integer;
  NameSize: Integer;
begin
  Output.Write(Dummy32bitResHeader, Length(Dummy32bitResHeader));
  // Write the data size
  Output.Write(DataSize, SizeOf(DataSize));
  // Write the header size
  NameSize := Length(AName) + 2;
  Data := 8 + 4{TypeSize} + NameSize + 16;
  Output.Write(Data, SizeOf(Data));
  // Write the resource type (RT_RCDATA)
  Data := $000AFFFF;
  Output.Write(Data, SizeOf(Data));
  // Now write the resource name
  Output.WriteBuffer(AName[0], NameSize - 2);
  Data := 0;
  Output.Write(Data, SizeOf(WideChar));
  // Finish off by writing the final 16 bytes which contain Version, LangID, and other fields
  Data := 0;
  Output.Write(Data, SizeOf(Data)); // DataVersion
  Output.Write(Data, SizeOf(Word)); // MemoryFlags
  Data := $0409;                    // For right now use US as the LandID since it is converted to this anyway
  Output.Write(Data, SizeOf(Word)); // LangID
  Data := 0;
  Output.Write(Data, SizeOf(Data)); // Version
  Output.Write(Data, SizeOf(Data)); // Characteristics
end;


function StrToBytes(const Value: String): TBytes;
var i: integer;
begin
  SetLength(result, Length(Value));
  for i:= 0 to Length(Value)-1 do
    result[i]:= Ord(Value[i+1])- 48;    //-48
end;

Procedure System_AssignFile(var F: Text; FileName: string);
begin
  System.AssignFile(F, FileName);
end;

Procedure System_CloseFile(var F: Text);
begin
  System.CloseFile(F);
end;

Procedure System_Reset(var F: Text);
begin
  system.Reset(F);
end;

Procedure System_Rewrite(var F: Text);
begin
  system.Rewrite(F);
end;

Procedure System_Str(aint: integer; astr: string);
begin
  system.Str(aint,astr);
end;


// CL.AddDelphiFunction('Procedure CloseFile(var F: Text);');

procedure WriteObjectResourceHeader(ObjStream, Output: TStream);
var
  Is32bit: Boolean;
  ResName: string;
  Size: Integer;

  procedure NameLengthError(const S: string); inline;
  begin
    raise EParserError.Create('@sComponentNameTooLong'+S);
  end;

begin
  Size := ObjStream.Size;
  Is32Bit := GetResourceName(ObjStream, ResName);
  if Length(ResName) > 70 then
    NameLengthError(ResName);
  if Is32Bit then
//    Write32bitResourceHeader(TEncoding.Unicode.GetBytes(ResName), Size, Output)
    Write32bitResourceHeader(StrToBytes(ResName), Size, Output)
  else
    Write16bitResourceHeader(StrToBytes(ResName), Size, Output);
end;

(*Function IntToFS (FontAttr: LongInt): TFontStyles ;
{ Übersetzt Integer-Fontattribut in Style. Es wird angenommen, dass fehlende
  Bits (z.B. FA_BOLD) automatisch gegenteilige (FA_NOBOLD) bedeuten. }
Begin
  Result := [] ;
  If FontAttr And FSBOLD <> 0 Then Include(Result,fsBold) ;
  If FontAttr And FSITALIC <> 0 Then Include(Result,fsItalic) ;
  If FontAttr And FSUNDERLINE <> 0 Then Include(Result,fsUnderline) ;
  If FontAttr And FSSTRIKEOUT <> 0 Then Include(Result,fsStrikeout) ;
End ;

Function FSToInt (Style: TFontStyles): LongInt ;
{ Übersetzt Fontattribute in Integer. Fehlede Auszeichnungen werden in FA_NOBOLD
  usw. umgesetzt }
Begin
  Result := 0 ;
  If fsBold In Style Then Result := Result Or FSBOLD Else Result := Result Or FA_NOBOLD ;
  If fsItalic In Style Then Result := Result Or FSITALIC Else Result := Result Or FA_NOITALIC ;
  If fsUnderline In Style Then Result := Result Or FSUNDERLINE Else Result := Result Or FA_NOUNDERLINE ;
  If fsStrikeout In Style Then Result := Result Or FSSTRIKEOUT Else Result := Result Or FA_NOSTRIKEOUT ;
End ;*)


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)

procedure SIRegister_TTextStream(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TTextStream') do
  with CL.AddClassN(CL.FindClass('TObject'),'TTextStream') do begin
    RegisterMethod('Constructor Create( AHost : TStream)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Function ReadLn : string;');
    RegisterMethod('Function ReadLn1( out Data : string) : Boolean;');
    RegisterProperty('EOF', 'Boolean', iptr);
    RegisterProperty('HostStream', 'TStream', iptr);
    RegisterProperty('Offset', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure TTextStreamOffset_W(Self: TTextStream; const T: Integer);
begin Self.Offset := T; end;

(*----------------------------------------------------------------------------*)
procedure TTextStreamOffset_R(Self: TTextStream; var T: Integer);
begin T := Self.Offset; end;

(*----------------------------------------------------------------------------*)
procedure TTextStreamHostStream_R(Self: TTextStream; var T: TStream);
begin T := Self.HostStream; end;

(*----------------------------------------------------------------------------*)
procedure TTextStreamEOF_R(Self: TTextStream; var T: Boolean);
begin T := Self.EOF; end;

(*----------------------------------------------------------------------------*)
Function TTextStreamReadLn1_P(Self: TTextStream;  out Data : string) : Boolean;
Begin Result := Self.ReadLn(Data); END;

(*----------------------------------------------------------------------------*)
Function TTextStreamReadLn_P(Self: TTextStream) : string;
Begin Result := Self.ReadLn; END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TTextStream(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TTextStream) do begin
    RegisterConstructor(@TTextStream.Create, 'Create');
    RegisterMethod(@TTextStream.Destroy, 'Free');
    RegisterMethod(@TTextStreamReadLn_P, 'ReadLn');
    RegisterMethod(@TTextStreamReadLn1_P, 'ReadLn1');
    RegisterPropertyHelper(@TTextStreamEOF_R,nil,'EOF');
    RegisterPropertyHelper(@TTextStreamHostStream_R,nil,'HostStream');
    RegisterPropertyHelper(@TTextStreamOffset_R,@TTextStreamOffset_W,'Offset');
  end;
end;


procedure SIRegister_TStopwatch(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStopwatch') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStopwatch') do begin
    RegisterMethod('Procedure Start');
    RegisterMethod('Procedure Stop');
    RegisterMethod('Function GetValueStr : String');
    RegisterMethod('Function GetValueMSec : Cardinal');
    RegisterMethod('Function GetTimeString: String');
    RegisterMethod('Function GetTimeStr: String');
  end;
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure RIRegister_TStopwatch(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStopwatch) do begin
    RegisterMethod(@TStopwatch.Start, 'Start');
    RegisterMethod(@TStopwatch.Stop, 'Stop');
    RegisterMethod(@TStopwatch.GetValueStr, 'GetValueStr');
    RegisterMethod(@TStopwatch.GetValueMSec, 'GetValueMSec');
    RegisterMethod(@TStopwatch.GetTimeString, 'GetTimeString');
    RegisterMethod(@TStopwatch.GetTimeStr, 'GetTimeStr');
  end;
end;


function RegClassS(CL: TPSPascalCompiler; const InheritsFrom, Classname: string): TPSCompileTimeClass;
begin
  Result := CL.FindClass(Classname);
  if Result = nil then
    Result := CL.AddClassN(CL.FindClass(InheritsFrom), Classname)
  else Result.ClassInheritsFrom := CL.FindClass(InheritsFrom);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_EWin32Error(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EOSError', 'EWin32Error') do
  with CL.AddClassN(CL.FindClass('EOSError'),'EWin32Error') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EOSError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EOSError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EOSError') do begin
    RegisterProperty('ErrorCode', 'DWORD', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EStackOverflow(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'EExternal', 'EStackOverflow') do
  with CL.AddClassN(CL.FindClass('EExternal'),'EStackOverflow') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EExternal(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EExternal') do
  with CL.AddClassN(CL.FindClass('Exception'),'EExternal') do begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EInOutError(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EInOutError') do
  with CL.AddClassN(CL.FindClass('Exception'),'EInOutError') do begin
    RegisterProperty('ErrorCode', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_EHeapException(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EHeapException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EHeapException') do begin
  end;
end;

procedure SIRegister_EInvalidPassword(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'Exception', 'EHeapException') do
  with CL.AddClassN(CL.FindClass('Exception'),'EInvalidPassword') do begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_Exception(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'Exception') do
  with CL.AddClassN(CL.FindClass('TObject'),'Exception') do begin
    RegisterMethod('Constructor Create( Msg : string)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Constructor CreateRes( Ident : Integer);');
   // RegisterMethod('Constructor CreateFmt(const Msg: string; const Args: TConstArray);');
    RegisterMethod('Constructor CreateFmt(const Msg: string; const Args: array of const);');

    //RegisterMethod('Constructor CreateRes( ResStringRec : PResStringRec);');
    RegisterMethod('Constructor CreateResHelp( Ident : Integer; AHelpContext : Integer);');
    //RegisterMethod('Constructor CreateResHelp( ResStringRec : PResStringRec; AHelpContext : Integer);');
    RegisterMethod('constructor CreateHelp(const Msg: string; AHelpContext: Integer);');

    RegisterProperty('HelpContext', 'Integer', iptrw);
    RegisterProperty('Message', 'string', iptrw);
  end;
end;

procedure SIRegister_EInvalidOperation(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'Exception') do
  with CL.AddClassN(CL.FindClass('Exception'),'EInvalidOperation') do begin
    RegisterMethod('Constructor Create( Msg : string)');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Constructor CreateRes( Ident : Integer);');
    //RegisterMethod('Constructor CreateFmt(const Msg: string; const Args: array of const);');
    //RegisterMethod('Constructor CreateRes( ResStringRec : PResStringRec);');
    RegisterMethod('Constructor CreateResHelp( Ident : Integer; AHelpContext : Integer);');
    //RegisterMethod('Constructor CreateResHelp( ResStringRec : PResStringRec; AHelpContext : Integer);');
    RegisterMethod('constructor CreateHelp(const Msg: string; AHelpContext: Integer);');

    RegisterProperty('HelpContext', 'Integer', iptrw);
    RegisterProperty('Message', 'string', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TLanguages(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TLanguages') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TLanguages') do begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Function IndexOf( ID : LCID) : Integer');
    RegisterProperty('Count', 'Integer', iptr);
    RegisterProperty('Name', 'string Integer', iptr);
    RegisterProperty('NameFromLocaleID', 'string LCID', iptr);
    RegisterProperty('NameFromLCID', 'string string', iptr);
    RegisterProperty('ID', 'string Integer', iptr);
    RegisterProperty('LocaleID', 'LCID Integer', iptr);
    RegisterProperty('Ext', 'string Integer', iptr);
  end;
end;

Function BoolToStr1(value: boolean) : string;
Begin If value then Result:= 'TRUE' else Result := 'FALSE'
End;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SysUtils(CL: TPSPascalCompiler);
begin

 SIRegister_TStopwatch(CL);
 SIRegister_TTextStream(CL);

 //   CL.AddTypeS('TConstArray','array of const');
 CL.AddConstantN('advapi32','String').SetString( 'advapi32.dll');
 CL.AddConstantN('kernel32','String').SetString( 'kernel32.dll');
 CL.AddConstantN('comctl32','String').SetString( 'comctl32.dll');
 CL.AddConstantN('gdi32','String').SetString( 'gdi32.dll');
 CL.AddConstantN('opengl32','String').SetString( 'opengl32.dll');
 CL.AddConstantN('user32','String').SetString( 'user32.dll');
 CL.AddConstantN('wintrust','String').SetString( 'wintrust.dll');
 CL.AddConstantN('msimg32','String').SetString( 'msimg32.dll');

 //CL.AddConstantN('fmOpenRead','').SetString( O_RDONLY);
 //CL.AddConstantN('fmOpenWrite','').SetString( O_WRONLY);
 //CL.AddConstantN('fmOpenReadWrite','').SetString( O_RDWR);
 CL.AddConstantN('fmShareExclusive','LongWord').SetUInt( $0010);
 CL.AddConstantN('fmShareDenyWrite','LongWord').SetUInt( $0020);
 CL.AddConstantN('fmShareDenyRead','LongWord').SetUInt( $0030);    //3.2
 CL.AddConstantN('fmOpenRead','LongWord').SetUInt( $0000);
 CL.AddConstantN('fmOpenWrite','LongWord').SetUInt( $0001);
 CL.AddConstantN('fmOpenReadWrite','LongWord').SetUInt( $0002);
 CL.AddConstantN('fmShareExclusive','LongWord').SetUInt( $0010);
 CL.AddConstantN('fmShareDenyWrite','LongWord').SetUInt( $0020);
 CL.AddConstantN('fmShareDenyNone','LongWord').SetUInt( $0040);
 //CL.AddConstantN('faDirectory','LongWord').SetUInt( $00000010);
 //CL.AddConstantN('faAnyFile','LongWord').SetUInt( $0000003F);
 CL.AddConstantN('HoursPerDay','LongInt').SetInt( 24);
 CL.AddConstantN('MinsPerHour','LongInt').SetInt( 60);
 CL.AddConstantN('SecsPerMin','LongInt').SetInt( 60);
 CL.AddConstantN('MSecsPerSec','LongInt').SetInt( 1000);
 CL.AddConstantN('MinsPerDay','LongInt').SetInt(HoursPerDay * MinsPerHour);
 CL.AddConstantN('SecsPerDay','LongInt').SetInt(MinsPerDay * SecsPerMin);
 CL.AddConstantN('Msecsperday','LongInt').SetInt(SecsPerDay * MSecsPerSec);
 CL.AddConstantN('DateDelta','LongInt').SetInt( 693594);
 CL.AddConstantN('UnixDateDelta','LongInt').SetInt( 25569);
 CL.AddConstantN('MaxInt','LongInt').SetInt(2147483647);
 CL.AddConstantN('SRCCOPY','LongWord').SetUInt($00CC0020);
 CL.AddConstantN('SRCPAINT','LongWord').SetUInt($00EE0086);
 CL.AddConstantN('SRCAND','LongWord').SetUInt($008800C6);
 CL.AddConstantN('SRCINVERT','LongWord').SetUInt($00660046);
 CL.AddConstantN('SRCERASE','LongWord').SetUInt($00440328);
 CL.AddConstantN('MinDateTime','TDateTime').SetExtended(-657434.0);
 CL.AddConstantN('MaxDateTime','TDateTime').SetExtended(2958465.99999);
 CL.AddConstantN('INVALID_HANDLE_VALUE','LongInt').SetInt( DWORD ( - 1 ));
 CL.AddConstantN('INVALID_FILE_SIZE','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('FILE_BEGIN','LongInt').SetInt( 0);
 CL.AddConstantN('FILE_CURRENT','LongInt').SetInt( 1);
 CL.AddConstantN('FILE_END','LongInt').SetInt( 2);
 CL.AddConstantN('FILE_ATTRIBUTE_READONLY','LongWord').SetUInt( $00000001);
 CL.AddConstantN('FILE_ATTRIBUTE_HIDDEN','LongWord').SetUInt( $00000002);
 CL.AddConstantN('FILE_ATTRIBUTE_SYSTEM','LongWord').SetUInt( $00000004);
 CL.AddConstantN('FILE_ATTRIBUTE_DIRECTORY','LongWord').SetUInt( $00000010);
 CL.AddConstantN('FILE_ATTRIBUTE_ARCHIVE','LongWord').SetUInt( $00000020);
 CL.AddConstantN('FILE_ATTRIBUTE_DEVICE','LongWord').SetUInt( $00000040);
 CL.AddConstantN('FILE_ATTRIBUTE_NORMAL','LongWord').SetUInt( $00000080);
 CL.AddConstantN('FILE_ATTRIBUTE_TEMPORARY','LongWord').SetUInt( $00000100);
 CL.AddConstantN('FILE_ATTRIBUTE_SPARSE_FILE','LongWord').SetUInt( $00000200);
 CL.AddConstantN('FILE_ATTRIBUTE_REPARSE_POINT','LongWord').SetUInt( $00000400);
 CL.AddConstantN('FILE_ATTRIBUTE_COMPRESSED','LongWord').SetUInt( $00000800);
 CL.AddConstantN('FILE_ATTRIBUTE_OFFLINE','LongWord').SetUInt( $00001000);
 CL.AddConstantN('FILE_ATTRIBUTE_NOT_CONTENT_INDEXED','LongWord').SetUInt( $00002000);
 CL.AddConstantN('FILE_ATTRIBUTE_ENCRYPTED','LongWord').SetUInt( $00004000);
  CL.AddConstantN('TIME_ZONE_ID_INVALID','LongWord').SetUInt( DWORD ( $FFFFFFFF ));
 CL.AddConstantN('TIME_ZONE_ID_UNKNOWN','LongInt').SetInt( 0);
 CL.AddConstantN('TIME_ZONE_ID_STANDARD','LongInt').SetInt( 1);
 CL.AddConstantN('TIME_ZONE_ID_DAYLIGHT','LongInt').SetInt( 2);
 CL.AddConstantN('CREATE_NEW','LongInt').SetInt( 1);
 CL.AddConstantN('CREATE_ALWAYS','LongInt').SetInt( 2);
 CL.AddConstantN('OPEN_EXISTING','LongInt').SetInt( 3);
 CL.AddConstantN('OPEN_ALWAYS','LongInt').SetInt( 4);
 CL.AddConstantN('TRUNCATE_EXISTING','LongInt').SetInt( 5);
 CL.AddConstantN('PROGRESS_CONTINUE','LongInt').SetInt( 0);
 CL.AddConstantN('PROGRESS_CANCEL','LongInt').SetInt( 1);
 CL.AddConstantN('PROGRESS_STOP','LongInt').SetInt( 2);
 CL.AddConstantN('PROGRESS_QUIET','LongInt').SetInt( 3);
 CL.AddConstantN('SC_SIZE','LongInt').SetInt( 61440);
 CL.AddConstantN('SC_MOVE','LongInt').SetInt( 61456);
 CL.AddConstantN('SC_MINIMIZE','LongInt').SetInt( 61472);
 CL.AddConstantN('SC_MAXIMIZE','LongInt').SetInt( 61488);
 CL.AddConstantN('SC_NEXTWINDOW','LongInt').SetInt( 61504);
 CL.AddConstantN('SC_PREVWINDOW','LongInt').SetInt( 61520);
 CL.AddConstantN('SC_CLOSE','LongInt').SetInt( 61536);
 CL.AddConstantN('SC_VSCROLL','LongInt').SetInt( 61552);
 CL.AddConstantN('SC_HSCROLL','LongInt').SetInt( 61568);
 CL.AddConstantN('SC_MOUSEMENU','LongInt').SetInt( 61584);
 CL.AddConstantN('SC_KEYMENU','LongInt').SetInt( 61696);
 CL.AddConstantN('SC_ARRANGE','LongInt').SetInt( 61712);
 CL.AddConstantN('SC_RESTORE','LongInt').SetInt( 61728);
 CL.AddConstantN('SC_TASKLIST','LongInt').SetInt( 61744);
 CL.AddConstantN('SC_SCREENSAVE','LongInt').SetInt( 61760);
 CL.AddConstantN('SC_HOTKEY','LongInt').SetInt( 61776);
 CL.AddConstantN('SC_DEFAULT','LongInt').SetInt( 61792);
 CL.AddConstantN('SC_MONITORPOWER','LongInt').SetInt( 61808);
 CL.AddConstantN('SC_CONTEXTHELP','LongInt').SetInt( 61824);
 CL.AddConstantN('SC_SEPARATOR','LongInt').SetInt( 61455);
 //CL.AddConstantN('SC_ICON','').SetString( SC_MINIMIZE);
 //CL.AddConstantN('SC_ZOOM','').SetString( SC_MAXIMIZE);

 CL.AddConstantN('MB_OK','LongWord').SetUInt( $00000000);
 CL.AddConstantN('MB_OKCANCEL','LongWord').SetUInt( $00000001);
 CL.AddConstantN('MB_ABORTRETRYIGNORE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('MB_YESNOCANCEL','LongWord').SetUInt( $00000003);
 CL.AddConstantN('MB_YESNO','LongWord').SetUInt( $00000004);
 CL.AddConstantN('MB_RETRYCANCEL','LongWord').SetUInt( $00000005);
 CL.AddConstantN('MB_ICONHAND','LongWord').SetUInt( $00000010);
 CL.AddConstantN('MB_ICONQUESTION','LongWord').SetUInt( $00000020);
 CL.AddConstantN('MB_ICONEXCLAMATION','LongWord').SetUInt( $00000030);
 CL.AddConstantN('MB_ICONASTERISK','LongWord').SetUInt( $00000040);
 CL.AddConstantN('MB_USERICON','LongWord').SetUInt( $00000080);
 CL.AddConstantN('MB_ICONWARNING','longword').SetUInt( MB_ICONEXCLAMATION);
 CL.AddConstantN('MB_ICONERROR','longword').SetUint( MB_ICONHAND);
 CL.AddConstantN('MB_ICONINFORMATION','longword').SetUint( MB_ICONASTERISK);
 CL.AddConstantN('MB_ICONSTOP','longword').SetUint( MB_ICONHAND);
 CL.AddConstantN('MB_APPLMODAL','LongWord').SetUInt( $00000000);
 CL.AddConstantN('MB_SYSTEMMODAL','LongWord').SetUInt( $00001000);
 CL.AddConstantN('MB_TASKMODAL','LongWord').SetUInt( $00002000);
 CL.AddConstantN('MB_HELP','LongWord').SetUInt( $00004000);
 CL.AddConstantN('MB_NOFOCUS','LongWord').SetUInt( $00008000);
 CL.AddConstantN('MB_SETFOREGROUND','LongWord').SetUInt( $00010000);
 CL.AddConstantN('MB_DEFAULT_DESKTOP_ONLY','LongWord').SetUInt( $00020000);
 CL.AddConstantN('MB_TOPMOST','LongWord').SetUInt( $00040000);
 CL.AddConstantN('MB_RIGHT','LongWord').SetUInt( $00080000);
 CL.AddConstantN('MB_RTLREADING','LongWord').SetUInt( $00100000);
 CL.AddConstantN('MB_SERVICE_NOTIFICATION','LongWord').SetUInt( $00200000);
 CL.AddConstantN('MB_SERVICE_NOTIFICATION_NT3X','LongWord').SetUInt( $00040000);
 CL.AddConstantN('MB_TYPEMASK','LongWord').SetUInt( $0000000F);
 CL.AddConstantN('MB_ICONMASK','LongWord').SetUInt( $000000F0);
 CL.AddConstantN('MB_DEFMASK','LongWord').SetUInt( $00000F00);
 CL.AddConstantN('MB_MODEMASK','LongWord').SetUInt( $00003000);
 CL.AddConstantN('MB_MISCMASK','LongWord').SetUInt( $0000C000);

 CL.AddConstantN('SND_SYNC','LongWord').SetUInt($0000); //default
 CL.AddConstantN('SND_ASYNC','LongWord').SetUInt($0001);
 CL.AddConstantN('SND_NODEFAULT','LongWord').SetUInt($0002);
 CL.AddConstantN('SND_MEMORY','LongWord').SetUInt($0004);
 CL.AddConstantN('SND_LOOP','LongWord').SetUInt($0008);
 CL.AddConstantN('SND_NOSTOP','LongWord').SetUInt($0010);
 CL.AddConstantN('SND_NOWAIT','LongWord').SetUInt($00002000);
 CL.AddConstantN('SND_ALIAS','LongWord').SetUInt($00010000);
 CL.AddConstantN('SND_ALIAS_ID','LongWord').SetUInt($00110000);
 CL.AddConstantN('SND_FILENAME','LongWord').SetUInt($00020000);
 CL.AddConstantN('SND_RESOURCE','LongWord').SetUInt($00040004);
 CL.AddConstantN('SND_PURGE','LongWord').SetUInt($0040);
 CL.AddConstantN('SND_APPLICATION','LongWord').SetUInt($0080);


 {CL.AddConstantN('KEYEVENTF_EXTENDEDKEY','LongInt').SetInt( 1);
 CL.AddConstantN('KEYEVENTF_KEYUP','LongInt').SetInt( 2);
 CL.AddConstantN('MOUSEEVENTF_MOVE','LongWord').SetUInt( $0001);
 CL.AddConstantN('MOUSEEVENTF_LEFTDOWN','LongWord').SetUInt( $0002);
 CL.AddConstantN('MOUSEEVENTF_LEFTUP','LongWord').SetUInt( $0004);
 CL.AddConstantN('MOUSEEVENTF_RIGHTDOWN','LongWord').SetUInt( $0008);
 CL.AddConstantN('MOUSEEVENTF_RIGHTUP','LongWord').SetUInt( $0010);
 CL.AddConstantN('MOUSEEVENTF_MIDDLEDOWN','LongWord').SetUInt( $0020);
 CL.AddConstantN('MOUSEEVENTF_MIDDLEUP','LongWord').SetUInt( $0040);
 CL.AddConstantN('MOUSEEVENTF_WHEEL','LongWord').SetUInt( $0800);
 CL.AddConstantN('MOUSEEVENTF_ABSOLUTE','LongWord').SetUInt( $8000);}

 (* {$EXTERNALSYM SND_RESOURCE}
  SND_RESOURCE        = $00040004;  { name is resource name or atom }
  {$EXTERNALSYM SND_PURGE}
  SND_PURGE           = $0040;      { purge non-static events for task }
  {$EXTERNALSYM SND_APPLICATION}
  SND_APPLICATION     = $0080;      { look for application specific association }*)

 CL.AddConstantN('VK_F1','LongInt').SetInt( 112);
 CL.AddConstantN('VK_F2','LongInt').SetInt( 113);
 CL.AddConstantN('VK_F3','LongInt').SetInt( 114);
 CL.AddConstantN('VK_F4','LongInt').SetInt( 115);
 CL.AddConstantN('VK_F5','LongInt').SetInt( 116);
 CL.AddConstantN('VK_F6','LongInt').SetInt( 117);
 CL.AddConstantN('VK_F7','LongInt').SetInt( 118);
 CL.AddConstantN('VK_F8','LongInt').SetInt( 119);
 CL.AddConstantN('VK_F9','LongInt').SetInt( 120);
 CL.AddConstantN('VK_F10','LongInt').SetInt( 121);
 CL.AddConstantN('VK_F11','LongInt').SetInt( 122);
 CL.AddConstantN('VK_F12','LongInt').SetInt( 123);
 CL.AddConstantN('WH_MIN','LongInt').SetInt( - 1);
 CL.AddConstantN('WH_MSGFILTER','LongInt').SetInt( - 1);
 CL.AddConstantN('WH_JOURNALRECORD','LongInt').SetInt( 0);
 CL.AddConstantN('WH_JOURNALPLAYBACK','LongInt').SetInt( 1);
 CL.AddConstantN('WH_KEYBOARD','LongInt').SetInt( 2);
 CL.AddConstantN('WH_GETMESSAGE','LongInt').SetInt( 3);
 CL.AddConstantN('WH_CALLWNDPROC','LongInt').SetInt( 4);
 CL.AddConstantN('WH_CBT','LongInt').SetInt( 5);
 CL.AddConstantN('WH_SYSMSGFILTER','LongInt').SetInt( 6);
 CL.AddConstantN('WH_MOUSE','LongInt').SetInt( 7);
 CL.AddConstantN('WH_HARDWARE','LongInt').SetInt( 8);
 CL.AddConstantN('WH_DEBUG','LongInt').SetInt( 9);
 CL.AddConstantN('WH_SHELL','LongInt').SetInt( 10);
 CL.AddConstantN('WH_FOREGROUNDIDLE','LongInt').SetInt( 11);
 CL.AddConstantN('WH_CALLWNDPROCRET','LongInt').SetInt( 12);
 CL.AddConstantN('WH_MAX','LongInt').SetInt( 12);
 CL.AddConstantN('WH_MINHOOK','longint').Setint( WH_MIN);
 CL.AddConstantN('WH_MAXHOOK','longint').Setint( WH_MAX);
 CL.AddConstantN('DEFAULT_QUALITY','LongInt').SetInt( 0);
 CL.AddConstantN('DRAFT_QUALITY','LongInt').SetInt( 1);
 CL.AddConstantN('PROOF_QUALITY','LongInt').SetInt( 2);
 CL.AddConstantN('NONANTIALIASED_QUALITY','LongInt').SetInt( 3);
 CL.AddConstantN('ANTIALIASED_QUALITY','LongInt').SetInt( 4);
 CL.AddConstantN('DEFAULT_PITCH','LongInt').SetInt( 0);
 CL.AddConstantN('FIXED_PITCH','LongInt').SetInt( 1);
 CL.AddConstantN('VARIABLE_PITCH','LongInt').SetInt( 2);
 CL.AddConstantN('MONO_FONT','LongInt').SetInt( 8);
 CL.AddConstantN('ANSI_CHARSET','LongInt').SetInt( 0);
 CL.AddConstantN('DEFAULT_CHARSET','LongInt').SetInt( 1);
 CL.AddConstantN('SYMBOL_CHARSET','LongInt').SetInt( 2);
 CL.AddConstantN('SHIFTJIS_CHARSET','LongWord').SetUInt( $80);
 CL.AddConstantN('HANGEUL_CHARSET','LongInt').SetInt( 129);
 CL.AddConstantN('GB2312_CHARSET','LongInt').SetInt( 134);
 CL.AddConstantN('CHINESEBIG5_CHARSET','LongInt').SetInt( 136);
 CL.AddConstantN('OEM_CHARSET','LongInt').SetInt( 255);
 CL.AddConstantN('WM_KEYFIRST','LongWord').SetUInt($00000100);
 CL.AddConstantN('WM_KEYDOWN','LongWord').SetUInt($00000100);
 CL.AddConstantN('WM_KEYUP','LongWord').SetUInt($00000101);

 CL.AddConstantN('SYNCHRONIZE','LongWord').SetUInt( $00100000);
 CL.AddConstantN('STANDARD_RIGHTS_REQUIRED','LongWord').SetUInt( $000F0000);
 CL.AddConstantN('EVENT_MODIFY_STATE','LongWord').SetUInt( $0002);
 CL.AddConstantN('MUTANT_QUERY_STATE','LongWord').SetUInt( $0001);
 CL.AddConstantN('SEMAPHORE_MODIFY_STATE','LongWord').SetUInt( $0002);
 CL.AddConstantN('PROCESS_TERMINATE','LongWord').SetUInt( $0001);
 CL.AddConstantN('PROCESS_CREATE_THREAD','LongWord').SetUInt( $0002);
 CL.AddConstantN('PROCESS_VM_OPERATION','LongWord').SetUInt( $0008);
 CL.AddConstantN('PROCESS_VM_READ','LongWord').SetUInt( $0010);
 CL.AddConstantN('PROCESS_VM_WRITE','LongWord').SetUInt( $0020);
 CL.AddConstantN('PROCESS_DUP_HANDLE','LongWord').SetUInt( $0040);
 CL.AddConstantN('PROCESS_CREATE_PROCESS','LongWord').SetUInt( $0080);
 CL.AddConstantN('PROCESS_SET_QUOTA','LongWord').SetUInt( $0100);
 CL.AddConstantN('PROCESS_SET_INFORMATION','LongWord').SetUInt( $0200);
 CL.AddConstantN('PROCESS_QUERY_INFORMATION','LongWord').SetUInt( $0400);
  CL.AddConstantN('MUTEX_MODIFY_STATE','longint').SetUInt( MUTANT_QUERY_STATE);
 CL.AddConstantN('MUTEX_ALL_ACCESS','longint').SetUInt( MUTANT_ALL_ACCESS);
 CL.AddConstantN('SP_SERIALCOMM','LongWord').SetUInt( $00000001);
 CL.AddConstantN('PST_UNSPECIFIED','LongWord').SetUInt( $00000000);
 CL.AddConstantN('PST_RS232','LongWord').SetUInt( $00000001);
 CL.AddConstantN('PST_PARALLELPORT','LongWord').SetUInt( $00000002);
 CL.AddConstantN('PST_RS422','LongWord').SetUInt( $00000003);
 CL.AddConstantN('PST_RS423','LongWord').SetUInt( $00000004);
 CL.AddConstantN('PST_RS449','LongWord').SetUInt( $00000005);
 CL.AddConstantN('PST_MODEM','LongWord').SetUInt( $00000006);
 CL.AddConstantN('PST_FAX','LongWord').SetUInt( $00000021);
 CL.AddConstantN('PST_SCANNER','LongWord').SetUInt( $00000022);
 CL.AddConstantN('PST_NETWORK_BRIDGE','LongWord').SetUInt( $00000100);
 CL.AddConstantN('PST_LAT','LongWord').SetUInt( $00000101);
 CL.AddConstantN('PST_TCPIP_TELNET','LongWord').SetUInt( $00000102);
 CL.AddConstantN('PST_X25','LongWord').SetUInt( $00000103);
 CL.AddConstantN('PCF_DTRDSR','LongWord').SetUInt( $0001);
 CL.AddConstantN('PCF_RTSCTS','LongWord').SetUInt( $0002);
 CL.AddConstantN('PCF_RLSD','LongWord').SetUInt( $0004);
 CL.AddConstantN('PCF_PARITY_CHECK','LongWord').SetUInt( $0008);
 CL.AddConstantN('PCF_XONXOFF','LongWord').SetUInt( $0010);
 CL.AddConstantN('PCF_SETXCHAR','LongWord').SetUInt( $0020);
 CL.AddConstantN('PCF_TOTALTIMEOUTS','LongWord').SetUInt( $0040);
 CL.AddConstantN('PCF_INTTIMEOUTS','LongWord').SetUInt( $0080);
 CL.AddConstantN('PCF_SPECIALCHARS','LongWord').SetUInt( $0100);
 CL.AddConstantN('PCF_16BITMODE','LongWord').SetUInt( $0200);
 CL.AddConstantN('SP_PARITY','LongWord').SetUInt( $0001);
 CL.AddConstantN('SP_BAUD','LongWord').SetUInt( $0002);
 CL.AddConstantN('SP_DATABITS','LongWord').SetUInt( $0004);
 CL.AddConstantN('SP_STOPBITS','LongWord').SetUInt( $0008);
 CL.AddConstantN('SP_HANDSHAKING','LongWord').SetUInt( $0010);
 CL.AddConstantN('SP_PARITY_CHECK','LongWord').SetUInt( $0020);
 CL.AddConstantN('SP_RLSD','LongWord').SetUInt( $0040);
  CL.AddConstantN('DC_ACTIVE','LongInt').SetInt( 1);
 CL.AddConstantN('DC_SMALLCAP','LongInt').SetInt( 2);
 CL.AddConstantN('DC_ICON','LongInt').SetInt( 4);
 CL.AddConstantN('DC_TEXT','LongInt').SetInt( 8);
 CL.AddConstantN('DC_INBUTTON','LongWord').SetUInt( $10);
 CL.AddConstantN('DC_GRADIENT','LongWord').SetUInt( $20);
 CL.AddConstantN('DC_BUTTONS','LongWord').SetUInt( $1000);
 //CL.AddDelphiFunction('Function DrawCaption( p1 : HWND; p2 : HDC; const p3 : TRect; p4 : UINT) : BOOL');
 //CL.AddConstantN('IDANI_OPEN','LongInt').SetInt( 1);
 //CL.AddConstantN('IDANI_CLOSE','LongInt').SetInt( 2);
 //CL.AddConstantN('IDANI_CAPTION','LongInt').SetInt( 3);
 //CL.AddDelphiFunction('Function DrawAnimatedRects( hwnd : HWND; idAni : Integer; const lprcFrom, lprcTo : TRect) : BOOL');
 CL.AddConstantN('CF_TEXT','LongInt').SetInt( 1);
 CL.AddConstantN('CF_BITMAP','LongInt').SetInt( 2);
 CL.AddConstantN('CF_METAFILEPICT','LongInt').SetInt( 3);
 CL.AddConstantN('CF_SYLK','LongInt').SetInt( 4);
 CL.AddConstantN('CF_DIF','LongInt').SetInt( 5);
 CL.AddConstantN('CF_TIFF','LongInt').SetInt( 6);
 CL.AddConstantN('CF_OEMTEXT','LongInt').SetInt( 7);
 CL.AddConstantN('CF_DIB','LongInt').SetInt( 8);
 CL.AddConstantN('CF_PALETTE','LongInt').SetInt( 9);
 CL.AddConstantN('CF_PENDATA','LongInt').SetInt( 10);
 CL.AddConstantN('CF_RIFF','LongInt').SetInt( 11);
 CL.AddConstantN('CF_WAVE','LongInt').SetInt( 12);
 CL.AddConstantN('CF_UNICODETEXT','LongInt').SetInt( 13);
 CL.AddConstantN('CF_ENHMETAFILE','LongInt').SetInt( 14);
 CL.AddConstantN('CF_HDROP','LongInt').SetInt( 15);
 CL.AddConstantN('CF_LOCALE','LongWord').SetUInt( $10);
 CL.AddConstantN('CF_MAX','LongInt').SetInt( 17);
 CL.AddConstantN('CF_DIBV5','LongInt').SetInt( 17);
 CL.AddConstantN('CF_MAX_XP','LongInt').SetInt( 18);
 CL.AddConstantN('CF_OWNERDISPLAY','LongInt').SetInt( 128);
 CL.AddConstantN('CF_DSPTEXT','LongInt').SetInt( 129);
 CL.AddConstantN('CF_DSPBITMAP','LongInt').SetInt( 130);
 CL.AddConstantN('CF_DSPMETAFILEPICT','LongInt').SetInt( 131);
 CL.AddConstantN('CF_DSPENHMETAFILE','LongInt').SetInt( 142);
 CL.AddConstantN('CF_PRIVATEFIRST','LongWord').SetUInt( $200);
 CL.AddConstantN('CF_PRIVATELAST','LongInt').SetInt( 767);
 CL.AddConstantN('CF_GDIOBJFIRST','LongInt').SetInt( 768);
 CL.AddConstantN('CF_GDIOBJLAST','LongInt').SetInt( 1023);
 CL.AddConstantN('FVIRTKEY','LongInt').SetInt( 1);
 CL.AddConstantN('FNOINVERT','LongInt').SetInt( 2);
 CL.AddConstantN('FSHIFT','LongInt').SetInt( 4);
 CL.AddConstantN('FCONTROL','LongInt').SetInt( 8);
 CL.AddConstantN('FALT','LongWord').SetUInt( $10);
 CL.AddConstantN('FILE_ATTRIBUTE_READONLY','LongWord').SetUInt( $00000001);
 CL.AddConstantN('FILE_ATTRIBUTE_HIDDEN','LongWord').SetUInt( $00000002);
 CL.AddConstantN('FILE_ATTRIBUTE_SYSTEM','LongWord').SetUInt( $00000004);
 CL.AddConstantN('FILE_ATTRIBUTE_DIRECTORY','LongWord').SetUInt( $00000010);
 CL.AddConstantN('FILE_ATTRIBUTE_ARCHIVE','LongWord').SetUInt( $00000020);
 CL.AddConstantN('FILE_ATTRIBUTE_DEVICE','LongWord').SetUInt( $00000040);
 CL.AddConstantN('FILE_ATTRIBUTE_NORMAL','LongWord').SetUInt( $00000080);
 CL.AddConstantN('FILE_ATTRIBUTE_TEMPORARY','LongWord').SetUInt( $00000100);
 CL.AddConstantN('FILE_ATTRIBUTE_SPARSE_FILE','LongWord').SetUInt( $00000200);
 CL.AddConstantN('FILE_ATTRIBUTE_REPARSE_POINT','LongWord').SetUInt( $00000400);
 CL.AddConstantN('FILE_ATTRIBUTE_COMPRESSED','LongWord').SetUInt( $00000800);
 CL.AddConstantN('FILE_ATTRIBUTE_OFFLINE','LongWord').SetUInt( $00001000);
 CL.AddConstantN('FILE_ATTRIBUTE_NOT_CONTENT_INDEXED','LongWord').SetUInt( $00002000);
 CL.AddConstantN('FILE_ATTRIBUTE_ENCRYPTED','LongWord').SetUInt( $00004000);
  CL.AddConstantN('SEC_FILE','LongWord').SetUInt( $800000);
 CL.AddConstantN('SEC_IMAGE','LongWord').SetUInt( $1000000);
 CL.AddConstantN('SEC_RESERVE','LongWord').SetUInt( $4000000);
 CL.AddConstantN('SEC_COMMIT','LongWord').SetUInt( $8000000);
 CL.AddConstantN('SEC_NOCACHE','LongWord').SetUInt( $10000000);
 CL.AddConstantN('MEM_IMAGE','LongWord').SetInt( SEC_IMAGE);
 CL.AddConstantN('FILE_SHARE_READ','LongWord').SetUInt( $00000001);
 CL.AddConstantN('FILE_SHARE_WRITE','LongWord').SetUInt( $00000002);
 CL.AddConstantN('FILE_SHARE_DELETE','LongWord').SetUInt( $00000004);
 CL.AddConstantN('WTS_CONSOLE_CONNECT','LongWord').SetUInt( $1);
 CL.AddConstantN('WTS_CONSOLE_DISCONNECT','LongWord').SetUInt( $2);
 CL.AddConstantN('WTS_REMOTE_CONNECT','LongWord').SetUInt( $3);
 CL.AddConstantN('WTS_REMOTE_DISCONNECT','LongWord').SetUInt( $4);
 CL.AddConstantN('WTS_SESSION_LOGON','LongWord').SetUInt( $5);
 CL.AddConstantN('WTS_SESSION_LOGOFF','LongWord').SetUInt( $6);
 CL.AddConstantN('WTS_SESSION_LOCK','LongWord').SetUInt( $7);
 CL.AddConstantN('WTS_SESSION_UNLOCK','LongWord').SetUInt( $8);
 CL.AddConstantN('MSGF_DIALOGBOX','LongInt').SetInt( 0);
 CL.AddConstantN('MSGF_MESSAGEBOX','LongInt').SetInt( 1);
 CL.AddConstantN('MSGF_MENU','LongInt').SetInt( 2);
 CL.AddConstantN('MSGF_MOVE','LongInt').SetInt( 3);
 CL.AddConstantN('MSGF_SIZE','LongInt').SetInt( 4);
 CL.AddConstantN('MSGF_SCROLLBAR','LongInt').SetInt( 5);
 CL.AddConstantN('MSGF_NEXTWINDOW','LongInt').SetInt( 6);
 CL.AddConstantN('MSGF_MAINLOOP','LongInt').SetInt( 8);
 CL.AddConstantN('MSGF_MAX','LongInt').SetInt( 8);
 CL.AddConstantN('MSGF_USER','LongWord').SetUInt( $1000);
 //CL.AddConstantN('ACCESS_STICKYKEYS','LongWord').SetUInt( $0001);
 //CL.AddConstantN('ACCESS_FILTERKEYS','LongWord').SetUInt( $0002);
 //CL.AddConstantN('ACCESS_MOUSEKEYS','LongWord').SetUInt( $0003);
 {CL.AddConstantN('APPCOMMAND_BROWSER_BACKWARD','LongInt').SetInt( 1);
 CL.AddConstantN('APPCOMMAND_BROWSER_FORWARD','LongInt').SetInt( 2);
 CL.AddConstantN('APPCOMMAND_BROWSER_REFRESH','LongInt').SetInt( 3);
 CL.AddConstantN('APPCOMMAND_BROWSER_STOP','LongInt').SetInt( 4);
 CL.AddConstantN('APPCOMMAND_BROWSER_SEARCH','LongInt').SetInt( 5);
 CL.AddConstantN('APPCOMMAND_BROWSER_FAVORITES','LongInt').SetInt( 6);
 CL.AddConstantN('APPCOMMAND_BROWSER_HOME','LongInt').SetInt( 7);
 CL.AddConstantN('APPCOMMAND_VOLUME_MUTE','LongInt').SetInt( 8);
 CL.AddConstantN('APPCOMMAND_VOLUME_DOWN','LongInt').SetInt( 9);
 CL.AddConstantN('APPCOMMAND_VOLUME_UP','LongInt').SetInt( 10);
 CL.AddConstantN('APPCOMMAND_MEDIA_NEXTTRACK','LongInt').SetInt( 11);
 CL.AddConstantN('APPCOMMAND_MEDIA_PREVIOUSTRACK','LongInt').SetInt( 12);
 CL.AddConstantN('APPCOMMAND_MEDIA_STOP','LongInt').SetInt( 13);
 CL.AddConstantN('APPCOMMAND_MEDIA_PLAY_PAUSE','LongInt').SetInt( 14);
 CL.AddConstantN('APPCOMMAND_LAUNCH_MAIL','LongInt').SetInt( 15);
 CL.AddConstantN('APPCOMMAND_LAUNCH_MEDIA_SELECT','LongInt').SetInt( 16);
 CL.AddConstantN('APPCOMMAND_LAUNCH_APP1','LongInt').SetInt( 17);
 CL.AddConstantN('APPCOMMAND_LAUNCH_APP2','LongInt').SetInt( 18);
 CL.AddConstantN('APPCOMMAND_BASS_DOWN','LongInt').SetInt( 19);
 CL.AddConstantN('APPCOMMAND_BASS_BOOST','LongInt').SetInt( 20);
 CL.AddConstantN('APPCOMMAND_BASS_UP','LongInt').SetInt( 21);
 CL.AddConstantN('APPCOMMAND_TREBLE_DOWN','LongInt').SetInt( 22);
 CL.AddConstantN('APPCOMMAND_TREBLE_UP','LongInt').SetInt( 23);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_MUTE','LongInt').SetInt( 24);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_DOWN','LongInt').SetInt( 25);
 CL.AddConstantN('APPCOMMAND_MICROPHONE_VOLUME_UP','LongInt').SetInt( 26);}
 {CL.AddConstantN('APPCOMMAND_HELP','LongInt').SetInt( 27);
 CL.AddConstantN('APPCOMMAND_FIND','LongInt').SetInt( 28);
 CL.AddConstantN('APPCOMMAND_NEW','LongInt').SetInt( 29);
 CL.AddConstantN('APPCOMMAND_OPEN','LongInt').SetInt( 30);
 CL.AddConstantN('APPCOMMAND_CLOSE','LongInt').SetInt( 31);
 CL.AddConstantN('APPCOMMAND_SAVE','LongInt').SetInt( 32);
 CL.AddConstantN('APPCOMMAND_PRINT','LongInt').SetInt( 33);
 CL.AddConstantN('APPCOMMAND_UNDO','LongInt').SetInt( 34);
 CL.AddConstantN('APPCOMMAND_REDO','LongInt').SetInt( 35);
 CL.AddConstantN('APPCOMMAND_COPY','LongInt').SetInt( 36);
 CL.AddConstantN('APPCOMMAND_CUT','LongInt').SetInt( 37);
 CL.AddConstantN('APPCOMMAND_PASTE','LongInt').SetInt( 38);
 CL.AddConstantN('APPCOMMAND_REPLY_TO_MAIL','LongInt').SetInt( 39);
 CL.AddConstantN('APPCOMMAND_FORWARD_MAIL','LongInt').SetInt( 40);
 CL.AddConstantN('APPCOMMAND_SEND_MAIL','LongInt').SetInt( 41);
 CL.AddConstantN('APPCOMMAND_SPELL_CHECK','LongInt').SetInt( 42);
 CL.AddConstantN('APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE','LongInt').SetInt( 43);
 CL.AddConstantN('APPCOMMAND_MIC_ON_OFF_TOGGLE','LongInt').SetInt( 44);
 CL.AddConstantN('APPCOMMAND_CORRECTION_LIST','LongInt').SetInt( 45);
 CL.AddConstantN('APPCOMMAND_MEDIA_PLAY','LongInt').SetInt( 46);
 CL.AddConstantN('APPCOMMAND_MEDIA_PAUSE','LongInt').SetInt( 47);
 CL.AddConstantN('APPCOMMAND_MEDIA_RECORD','LongInt').SetInt( 48);
 CL.AddConstantN('APPCOMMAND_MEDIA_FAST_FORWARD','LongInt').SetInt( 49);
 CL.AddConstantN('APPCOMMAND_MEDIA_REWIND','LongInt').SetInt( 50);
 CL.AddConstantN('APPCOMMAND_MEDIA_CHANNEL_UP','LongInt').SetInt( 51);
 CL.AddConstantN('APPCOMMAND_MEDIA_CHANNEL_DOWN','LongInt').SetInt( 52);
 CL.AddConstantN('APPCOMMAND_DELETE','LongInt').SetInt( 53);
 CL.AddConstantN('APPCOMMAND_DWM_FLIP3D','LongInt').SetInt( 54);
 CL.AddConstantN('FAPPCOMMAND_MOUSE','LongWord').SetUInt( $8000);
 CL.AddConstantN('FAPPCOMMAND_KEY','LongInt').SetInt( 0);
 CL.AddConstantN('FAPPCOMMAND_OEM','LongWord').SetUInt( $1000);
 CL.AddConstantN('FAPPCOMMAND_MASK','LongWord').SetUInt( $F000);}

 //cl.AddVariableN('ListSeparator','char');
 //cl.AddUsedVariableN('DateSeparator','char');

//   WAIT_OBJECT_0 = ((STATUS_WAIT_0 ) + 0 );
//    STATUS_WAIT_0                   = $00000000;
  //MinDateTime: TDateTime = -657434.0;      { 01/01/0100 12:00:00.000 AM }
  //MaxDateTime: TDateTime =  2958465.99999; { 12/31/9999 11:59:59.999 PM }
   (*SRCPAINT    = $00EE0086;     { dest = source OR dest            }
  {$EXTERNALSYM SRCAND}
  SRCAND      = $008800C6;     { dest = source AND dest           }
  {$EXTERNALSYM SRCINVERT}
  SRCINVERT   = $00660046;     { dest = source XOR dest           }
  {$EXTERNALSYM SRCERASE}
  SRCERASE    = $00440328;     { dest = source AND (NOT dest )*)

  //CL.AddTypeS('PDayTable', '^TDayTable // will not work');
  CL.AddTypeS('TFilenameCaseMatch', '( mkNone, mkExactMatch, mkSingleMatch, mkAmbiguous )');
 // CL.AddTypeS('TReplaceFlags', 'set of ( rfReplaceAll, rfIgnoreCase )');
  //CL.AddTypeS('TSysCharSet', 'set of Char');     //!!! not to define!!! in StrUtils!
  //  TSysCharSet = set of Char;
   //{$EXTERNALSYM FILEOP_FLAGS}
  CL.AddTypeS('FILEOP_FLAGS','Word');
   CL.AddTypeS('TCaption','string');
   CL.AddConstantN('RTLVersion','Extended').setExtended( 18.00);    //3.7
 //CL.AddConstantN('GPL','Boolean')BoolToStr( True);
 CL.AddConstantN('varEmpty','LongWord').SetUInt( $0000);
 CL.AddConstantN('varNull','LongWord').SetUInt( $0001);
 CL.AddConstantN('varSmallint','LongWord').SetUInt( $0002);
 CL.AddConstantN('varInteger','LongWord').SetUInt( $0003);
 CL.AddConstantN('varSingle','LongWord').SetUInt( $0004);
 CL.AddConstantN('varDouble','LongWord').SetUInt( $0005);
 CL.AddConstantN('varCurrency','LongWord').SetUInt( $0006);
 CL.AddConstantN('varDate','LongWord').SetUInt( $0007);
 CL.AddConstantN('varOleStr','LongWord').SetUInt( $0008);
 CL.AddConstantN('varDispatch','LongWord').SetUInt( $0009);
 CL.AddConstantN('varError','LongWord').SetUInt( $000A);
 CL.AddConstantN('varBoolean','LongWord').SetUInt( $000B);
 CL.AddConstantN('varVariant','LongWord').SetUInt( $000C);
 CL.AddConstantN('varUnknown','LongWord').SetUInt( $000D);
 CL.AddConstantN('varShortInt','LongWord').SetUInt( $0010);
 CL.AddConstantN('varByte','LongWord').SetUInt( $0011);
 CL.AddConstantN('varWord','LongWord').SetUInt( $0012);
 CL.AddConstantN('varLongWord','LongWord').SetUInt( $0013);
 CL.AddConstantN('varInt64','LongWord').SetUInt( $0014);
 CL.AddConstantN('varStrArg','LongWord').SetUInt( $0048);
 CL.AddConstantN('varString','LongWord').SetUInt( $0100);
 CL.AddConstantN('varAny','LongWord').SetUInt( $0101);
 CL.AddConstantN('varTypeMask','LongWord').SetUInt( $0FFF);
 CL.AddConstantN('varArray','LongWord').SetUInt( $2000);
 CL.AddConstantN('varByRef','LongWord').SetUInt( $4000);
 CL.AddConstantN('vtInteger','LongInt').SetInt( 0);
 CL.AddConstantN('vtBoolean','LongInt').SetInt( 1);
 CL.AddConstantN('vtChar','LongInt').SetInt( 2);
 CL.AddConstantN('vtExtended','LongInt').SetInt( 3);
 CL.AddConstantN('vtString','LongInt').SetInt( 4);
 CL.AddConstantN('vtPointer','LongInt').SetInt( 5);
 CL.AddConstantN('vtPChar','LongInt').SetInt( 6);
 CL.AddConstantN('vtObject','LongInt').SetInt( 7);
 CL.AddConstantN('vtClass','LongInt').SetInt( 8);
 CL.AddConstantN('vtWideChar','LongInt').SetInt( 9);
 CL.AddConstantN('vtPWideChar','LongInt').SetInt( 10);
 CL.AddConstantN('vtAnsiString','LongInt').SetInt( 11);
 CL.AddConstantN('vtCurrency','LongInt').SetInt( 12);
 CL.AddConstantN('vtVariant','LongInt').SetInt( 13);
 CL.AddConstantN('vtInterface','LongInt').SetInt( 14);
 CL.AddConstantN('vtWideString','LongInt').SetInt( 15);
 CL.AddConstantN('vtInt64','LongInt').SetInt( 16);
 CL.AddConstantN('vmtSelfPtr','LongInt').SetInt( - 76);
 CL.AddConstantN('vmtIntfTable','LongInt').SetInt( - 72);
 CL.AddConstantN('vmtAutoTable','LongInt').SetInt( - 68);
 CL.AddConstantN('vmtInitTable','LongInt').SetInt( - 64);
 CL.AddConstantN('vmtTypeInfo','LongInt').SetInt( - 60);
 CL.AddConstantN('vmtFieldTable','LongInt').SetInt( - 56);
 CL.AddConstantN('vmtMethodTable','LongInt').SetInt( - 52);
 CL.AddConstantN('vmtDynamicTable','LongInt').SetInt( - 48);
 CL.AddConstantN('vmtClassName','LongInt').SetInt( - 44);
 CL.AddConstantN('vmtInstanceSize','LongInt').SetInt( - 40);
 CL.AddConstantN('vmtParent','LongInt').SetInt( - 36);
 //CL.AddConstantN('varDispatch','LongWord').SetUInt( $0009);
 CL.AddConstantN('WM_ENABLE','LongWord').SetUInt( $000A);
 CL.AddConstantN('WM_SETREDRAW','LongWord').SetUInt( $000B);
 CL.AddConstantN('WM_SETTEXT','LongWord').SetUInt( $000C);
 CL.AddConstantN('WM_GETTEXT','LongWord').SetUInt( $000D);
 CL.AddConstantN('WM_GETTEXTLENGTH','LongWord').SetUInt( $000E);
 CL.AddConstantN('WM_PAINT','LongWord').SetUInt( $000F);
 CL.AddConstantN('WM_CLOSE','LongWord').SetUInt( $0010);
 (*
  {$EXTERNALSYM WM_SYSCOLORCHANGE}
  WM_SYSCOLORCHANGE   = $0015;
  {$EXTERNALSYM WM_ENDSESSION}
  WM_ENDSESSION       = $0016;
  {$EXTERNALSYM WM_SYSTEMERROR}
  WM_SYSTEMERROR      = $0017;
  {$EXTERNALSYM WM_SHOWWINDOW}
  WM_SHOWWINDOW       = $0018;  *)

  { TMethod = record
    Code, Data: Pointer;
  end;}

 //LANG_SYSTEM_DEFAULT   = (SUBLANG_SYS_DEFAULT shl 10) or LANG_NEUTRAL;
  //{$EXTERNALSYM LANG_SYSTEM_DEFAULT}
  //LANG_USER_DEFAULT     = (SUBLANG_DEFAULT shl 10) or LANG_NEUTRAL;
 CL.AddConstantN('LOCALE_SYSTEM_DEFAULT','Longint').SetInt((SORT_DEFAULT shl 16) or LANG_SYSTEM_DEFAULT);
  //{$EXTERNALSYM LOCALE_SYSTEM_DEFAULT}
 CL.AddConstantN('LOCALE_USER_DEFAULT','Longint').SetInt((SORT_DEFAULT shl 16) or LANG_USER_DEFAULT);
  //CL.AddTypeS('CONTEXT', '_CONTEXT');

  {HRSRC = THandle;
  TResourceHandle = HRSRC;   // make an opaque handle type
  HINST = THandle;
  HMODULE = HINST;
  HGLOBAL = THandle; }

  //CL.AddTypeS('mUINT64','Uint64');      //3.6.3.
  CL.AddTypeS('HRSCR','THandle');
  CL.AddTypeS('TResourceHandle','HRSCR');
  CL.AddTypeS('HMODULE','THandle');
  CL.AddTypeS('HINST','THandle');
  CL.AddTypeS('HFONT','LongWord');
  CL.AddTypeS('HGLOBAL','THandle');
  CL.AddTypeS('ATOM','Word');
  CL.AddTypeS('TATOM','Word');
  CL.AddTypeS('HLOCAL', 'THandle');
  CL.AddTypeS('HHOOK', 'LongWord');
   //HFILE = LongWord;
  CL.AddTypeS('HGLRC', 'LongWord');
  CL.AddTypeS('HDESK', 'LongWord');
  CL.AddTypeS('HENHMETAFILE', 'LongWord');
  //CL.AddTypeS('HFONT', 'LongWord');
  CL.AddTypeS('HICON', 'LongWord');
  CL.AddTypeS('HMENU', 'LongWord');
  //CL.AddTypeS('HMETAFILE', 'LongWord');
  CL.AddTypeS('HPALETTE', 'LongWord');
  CL.AddTypeS('HWND','LongWord');
  CL.AddTypeS('HMETAFILE','LongWord');
  CL.AddTypeS('HBITMAP','LongWord');
  CL.AddTypeS('HDC','LongWord');
  CL.AddTypeS('HCURSOR','LongWord');
  CL.AddTypeS('HBRUSH','LongWord');
  CL.AddTypeS('HICON','LongWord');
  CL.AddTypeS('HPALETTE','LongWord');
  CL.AddTypeS('HRSRC','LongWord'); //Windows resource
  CL.AddTypeS('HKL','LongWord');   //keyboard layout
  CL.AddTypeS('HKEY','LongWord');   //win reg layout
  CL.AddTypeS('HFILE','LongWord'); //A handle to an open file
  CL.AddTypeS('HGDIOBJ','LongWord'); //a GDI object. Pens, device contexts, brushes, etc.
  CL.AddTypeS('LPARAM','LongInt');
  CL.AddTypeS('WPARAM','LongInt');
  CL.AddTypeS('LRESULT','Longint');
  //CL.AddTypeS('ULONG','Longint');
  //CL.AddTypeS('UINT','Integer');
  CL.AddTypeS('UINT', 'LongWord');
  CL.AddTypeS('ULONG', 'Cardinal');
  CL.AddTypeS('HRGN', 'LongWord');
  CL.AddTypeS('HSTR', 'LongWord');
  CL.AddTypeS('HTASK', 'LongWord');
  CL.AddTypeS('HWINSTA', 'LongWord');
  CL.AddTypeS('HKL', 'LongWord');
  CL.AddTypeS('HSTR', 'LongWord');
 //CL.AddTypeS('HFILE', 'LongWord');
  CL.AddTypeS('HCURSOR', 'HICON');
  CL.AddTypeS('COLORREF', 'DWORD');
  CL.AddTypeS('MMResult','UInt');
  CL.AddTypeS('TLargeInteger','Int64');
  //CL.AddTypeS('HGLOBAL', 'THandle');

  //  TLargeInteger = Int64;
  CL.AddTypeS('UCHAR','Byte');
  CL.AddTypeS('BOOL','LongBool');  //long !
  CL.AddTypeS('SHORT','SmallInt');
  CL.AddTypeS('LCID','DWord');   //A local identifier
  CL.AddTypeS('TColorRef','DWORD');
  CL.AddTypeS('LOWORD','Word');
  CL.AddTypeS('FARPROC', '___Pointer');
  CL.AddTypeS('TFARPROC', '___Pointer');
  //TFNHookProc

  {CL.AddTypeS('LPCSTR', 'PAnsiChar');
  CL.AddTypeS('LPCTSTR', 'PAnsiChar');
  CL.AddTypeS('LPTSTR', 'PAnsiChar');}
  CL.AddTypeS('TFNThreadStartRoutine', 'TFarProc');
  CL.AddTypeS('TFNFiberStartRoutine', 'TFarProc');
  CL.AddTypeS('TThreadFunction2','procedure; stdcall');

 // record DebugInfo : PRTLCriticalSectionDebug;
 CL.AddTypeS('_RTL_CRITICAL_SECTION','record DebugInfo: TFARPROC; LockCount: Longint;'+
 'RecursionCount: Longint; OwningThread: THandle; LockSemaphore : THandle; Reserved : DWORD; end');
  CL.AddTypeS('TRTLCriticalSection', '_RTL_CRITICAL_SECTION');
  CL.AddTypeS('RTL_CRITICAL_SECTION', '_RTL_CRITICAL_SECTION');
  CL.AddTypeS('LANGID','Word');  //A language identifier
  //CL.AddTypeS('RT_RCDATA','Types.RT_RCDATA'); //MakeIntResource(10);
  CL.AddTypeS('RT_RCDATA','PChar(10)'); //MakeIntResource(10);
  CL.AddTypeS('RT_RCDATA1','PChar'); //MakeIntResource(10);
  CL.AddTypeS('RT_CURSOR','PChar(1)'); //MakeIntResource(10);
  CL.AddTypeS('RT_BITMAP','PChar(2)'); //MakeIntResource(10);
  CL.AddTypeS('RT_ICON','PChar(3)'); //MakeIntResource(10);
  CL.AddTypeS('RT_STRING','PChar(6)'); //MakeIntResource(10);
  CL.AddTypeS('RT_FONT','PChar(8)'); //MakeIntResource(10);
  CL.AddTypeS('RT_DIALOG','PChar(5)'); //MakeIntResource(10);
  CL.AddTypeS('RT_MESSAGETABLE','PChar(11)'); //MakeIntResource(10);
//  CL.AddTypeS('TMsg', 'record hwnd: HWND; message: longword; wParam: WPARAM; lParam: LPARAM; time: DWORD; pt: TPoint; end');
   {tagMSG = packed record    -------> in upsc_forms
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;
    pt: TPoint;
  end;}
  CL.AddTypeS('INT_PTR', 'Integer');
  CL.AddTypeS('LONG_PTR', 'Integer');
  CL.AddTypeS('UINT_PTR', 'Cardinal');
  CL.AddTypeS('ULONG_PTR', 'Cardinal');
  CL.AddTypeS('DWORD_PTR', 'ULONG_PTR');
  CL.AddTypeS('LONGLONG', 'Int64');
   // LONGLONG = Int64;
  CL.AddTypeS('TFloatingSaveArea', '___Pointer');
  //CL.AddTypeS('FLOATING_SAVE_AREA', '_FLOATING_SAVE_AREA');
 CL.AddTypeS('_CONTEXT', 'record ContextFlags: DWORD; Dr0 : DWORD; Dr1 : DWORD; Dr2 : DWORD; Dr3 : DWORD; Dr6 : DWORD; Dr7 : DWORD; FloatSave : TFloati'
   +'ngSaveArea; SegGs : DWORD; SegFs : DWORD; SegEs : DWORD; SegDs : DWORD; Edi : DWORD; Esi : DWORD; Ebx : DWORD; Edx : DWORD; Ecx : DWORD; Eax : DWORD'
   +'; Ebp : DWORD; Eip : DWORD; SegCs : DWORD; EFlags : DWORD; Esp : DWORD; SegSs : DWORD; end');
  CL.AddTypeS('TContext', '_CONTEXT');
  //CL.AddTypeS('UInt64', 'Uint64');
   //CL.AddTypeS('IXMLNode', 'interface');
 { CL.AddTypeS('IXMLNode', 'IInterface');
  //CL.AddTypeS('TTreeView', 'TCustomTreeView');
  CL.AddTypeS('TTreeView', 'TObject');
  CL.AddTypeS('TTreeNode', 'TPersistent');}
    //3.8.2
  CL.AddTypeS('TFloatRec','record Exponent: Smallint; Negative: Boolean; Digits: array[0..20] of Char; end');
  CL.AddTypeS('TSysLocale','record DefaultLCID, PriLangID, SubLangID: Integer; FarEast, MiddleEast: Boolean; end');
  CL.AddTypeS('TIdentMapEntry','record Value: Integer; Name: String; end');
  CL.AddTypeS('TMessage','record msg: Cardinal; WParam, LParam, Result: Longint; end');
  CL.AddTypeS('TMessage2','record msg: Cardinal; WParamlo, WParamhi, LParamlo, LParamhi, Resultlo, resulthi: word; end');
  CL.AddTypeS('TTerminateProc','function: Boolean;');
  CL.AddTypeS('TMemoryStatus','record dwLength,dwMemoryLoad, dwTotalPhys,dwAvailPhys, dwTotalPageFile, dwAvailPageFile, dwTotalVirtual, dwAvailVirtual: dword; end');
  CL.AddTypeS('_MEMORYSTATUS', 'record dwLength : DWORD; dwMemoryLoad : DWORD; '
   +'dwTotalPhys : DWORD; dwAvailPhys : DWORD; dwTotalPageFile : DWORD; dwAvail'
   +'PageFile : DWORD; dwTotalVirtual : DWORD; dwAvailVirtual : DWORD; end');
  //CL.AddTypeS('TMemoryStatus', '_MEMORYSTATUS');
  CL.AddTypeS('MEMORYSTATUS', '_MEMORYSTATUS');
  CL.AddDelphiFunction('Function CreateEvent( lpEventAttributes : TObject; bManualReset, bInitialState : BOOL; lpName : PChar) : THandle');
  CL.AddDelphiFunction('Procedure GlobalMemoryStatus( var lpBuffer : TMemoryStatus)');
  CL.AddDelphiFunction('Function LocalAlloc( uFlags, uBytes : UINT) : HLOCAL');
 CL.AddDelphiFunction('Function LocalReAlloc( hMem : HLOCAL; uBytes, uFlags : UINT) : HLOCAL');
 //CL.AddDelphiFunction('Function LocalLock( hMem : HLOCAL) : Pointer');
 CL.AddDelphiFunction('Function LocalUnlock( hMem : HLOCAL) : BOOL');
 CL.AddDelphiFunction('Function LocalSize( hMem : HLOCAL) : UINT');
 CL.AddDelphiFunction('Function LocalFlags( hMem : HLOCAL) : UINT');
 CL.AddDelphiFunction('Function LocalFree( hMem : HLOCAL) : HLOCAL');
 CL.AddDelphiFunction('Function LocalShrink( hMem : HLOCAL; cbNewSize : UINT) : UINT');
 CL.AddDelphiFunction('Function LocalCompact( uMinFree : UINT) : UINT');

{   _MEMORYSTATUS = record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    dwTotalPhys: DWORD;     dwAvailPhys: DWORD;
    dwTotalPageFile: DWORD;     dwAvailPageFile: DWORD;
    dwTotalVirtual: DWORD;      dwAvailVirtual: DWORD;
  end;}
  //type
  //TTerminateProc = function: Boolean;
  { TMessage = packed record
    Msg: Cardinal;
    case Integer of
      0: (           WParam: Longint;
        LParam: Longint;
        Result: Longint);
      1: (           WParamLo: Word;
        WParamHi: Word;
        LParamLo: Word;
        LParamHi: Word;
        ResultLo: Word;
        ResultHi: Word);
  end;}

  //LPARAM      Longint;    A 32-bit message parameter
  //LRESULT     Longint;    A 32-bit function return value
  //CL.AddTypeS('MakeIntResource','PANSIChar');
   //CL.AddTypeS('THexArray', 'array[0..15] of char;');
  //CL.AddTypeS('TIntegerSet', 'set of Integer');
  //CL.AddTypeS('PByteArray', '^TByteArray // will not work');
  //CL.AddTypeS('PWordArray', '^TWordArray // will not work');
  //CL.AddTypeS('TFileName', 'type string');
  //CL.AddTypeS('TFileName', 'string');    in strutils
  CL.AddTypeS('Text', 'File of char');
  //CL.addTypeS('CmdLine', 'PChar');
  CL.AddClassN(CL.FindClass('TPersistent'),'TGraphic');
  CL.AddClassN(CL.FindClass('Class of TForm'),'TFormClass');   //3.8
  //CL.AddTypeS('TGraphic','Class');
  //CL.AddTypeS('TGraphicClass','Class of TGraphic');
  CL.AddTypeS('TPersistentClass', 'TPersistent');
  //CL.AddTypeS('class of TPersistent', 'TPersistentClass');
  //CL.AddTypeS('TShiftState', '(ssShift, ssAlt, ssCtrl, ssLeft, ssRight,ssMiddle, ssDouble)');
  CL.AddTypeS('TKeyboardState','array[0..255] of Byte');
 // CL.AddTypeS('_FILETIME', 'record dwLowDateTime: DWORD; dwHighDateTime: DWORD; end');
 // CL.AddTypeS('FILETIME', '_FILETIME');  move to strutils
  (*CL.AddTypeS('_SYSTEMTIME', 'record wYear : Word; wMonth : Word; wDayOfWeek : '
   +'Word; wDay : Word; wHour : Word; wMinute : Word; wSecond : Word; wMillisec'
   +'onds : Word; end');
  CL.AddTypeS('TSystemTime', '_SYSTEMTIME');
  CL.AddTypeS('SYSTEMTIME', '_SYSTEMTIME');           in upsc_dateutils*)
  CL.AddTypeS('_BY_HANDLE_FILE_INFORMATION', 'record dwFileAttributes : DWORD; '
   +'ftCreationTime : TFileTime; ftLastAccessTime : TFileTime; ftLastWriteTime '
   +': TFileTime; dwVolumeSerialNumber : DWORD; nFileSizeHigh : DWORD; nFileSiz'
   +'eLow : DWORD; nNumberOfLinks : DWORD; nFileIndexHigh : DWORD; nFileIndexLow : DWORD; end');
  CL.AddTypeS('TByHandleFileInformation', '_BY_HANDLE_FILE_INFORMATION');

//CL.AddTypeS('TSearchRec', 'record Time : Integer; Size : Integer; Attr : Integer;'
  // +' Name : TFileName; ExcludeAttr : Integer; end');
  CL.AddTypeS('TFloatValue', '( fvExtended, fvCurrency )');
  CL.AddTypeS('TFloatFormat', '( ffGeneral, ffExponent, ffFixed, ffNumber, ffCurrency )');
  CL.AddTypeS('TTextLineBreakStyle','(tlbsLF, tlbsCRLF)');
  //CL.AddTypeS('TTimeStamp', 'record Time : Integer; Date : Integer; end');
  CL.AddTypeS('TWordArray', 'array[0..16383] of Word;');
  CL.AddTypeS('TByteArray', 'array[0..32767] of Byte;');  //also in unit uPSI_StrUtils
  CL.AddTypeS('TCharArray', 'array[0..32767] of Char;');
  //register also in upsi_idglobal
  CL.AddTypeS('TBytes', 'array of Byte;');    //case of many and write16bitresourceheader !!
  Cl.AddTypeS('TRect2', 'record TopLeft, BottomRight: TPoint; end;'); //3.8
   //CL.AddTypeS('TFontCharset','0..255');  // from sysutils   tfontcharset
   CL.AddTypeS('marrstr', 'array of string;');
     //CL.AddTypeS('Tdnames', 'array[1..7] of string;');
  //CL.AddTypeS('Tmnames','array[1..12] of string;');
  CL.AddTypeS('TDayNames', 'array[1..7] of string');
  CL.AddTypeS('TMonthNames', 'array[1..12] of string');
   CL.AddTypeS('TStreamOriginalFormat','(sofUnknown, sofBinary, sofText)');
  //CL.AddTypeS('TStreamOriginalFormat', '( sofUnknown, sofBinary, sofText )');
  CL.AddTypeS('TMbcsByteType', '( mbSingleByte, mbLeadByte, mbTrailByte )');
  SIRegister_TLanguages(CL);
  CL.AddTypeS('TEraRange', 'record StartDate : Integer; EndDate : Integer; end');
  SIRegister_Exception(CL);
  //CL.AddTypeS('ExceptClass', 'class of Exception');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TClass');
   CL.AddClassN(CL.FindClass('TOBJECT'),'EAbort');
  SIRegister_EHeapException(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOutOfMemory');
  SIRegister_EInOutError(CL);
  //CL.AddTypeS('PExceptionRecord', '^TExceptionRecord // will not work');
  SIRegister_EExternal(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EExternalException');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIntError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EDivByZero');
  CL.AddClassN(CL.FindClass('TOBJECT'),'ERangeError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIntOverflow');
  CL.AddClassN(CL.FindClass('EExternal'),'EMathError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidOp');
  CL.AddClassN(CL.FindClass('EMathError'),'EZeroDivide');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EOverflow');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EUnderflow');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidPointer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidCast');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EConvertError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAccessViolation');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPrivilege');
  SIRegister_EStackOverflow(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'EControlC');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EVariantError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPropReadOnly');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPropWriteOnly');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EAssertionFailed');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EIntfCastError');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidContainer');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EInvalidInsert');
  CL.AddClassN(CL.FindClass('TOBJECT'),'EPackageError');
  SIRegister_EOSError(CL);
  SIRegister_EWin32Error(CL);
  SIRegister_EInvalidPassword(CL);
  CL.AddClassN(CL.FindClass('TOBJECT'),'ESafecallException');
  CL.AddTypeS('TSignalState', '( ssNotHooked, ssHooked, ssOverridden )');
 CL.AddConstantN('MAX_PATH','LongInt').SetInt( 4095);
 CL.AddConstantN('Win32Platform','Integer').SetInt( 0);
 CL.AddConstantN('Win32MajorVersion','Integer').SetInt( 0);
 CL.AddConstantN('Win32MinorVersion','Integer').SetInt( 0);
 CL.AddConstantN('Win32BuildNumber','Integer').SetInt( 0);
 CL.AddConstantN('Win32CSDVersion','string').SetString( '');
 CL.AddDelphiFunction('Function CheckWin32Version( AMajor : Integer; AMinor : Integer) : Boolean');
 CL.AddDelphiFunction('Function GetFileVersion( AFileName : string) : Cardinal');
  CL.AddTypeS('MaxEraCount', 'Integer');
 CL.AddDelphiFunction('Function Languages : TLanguages');
 CL.AddDelphiFunction('function getProcessList: TStrings;');
 CL.AddDelphiFunction('Function FindFirstFile( lpFileName : PChar; var lpFindFileData : TWIN32FindData) : THandle');
 CL.AddDelphiFunction('Function SearchPath( lpPath, lpFileName, lpExtension : PChar; nBufferLength : DWORD; lpBuffer : PChar; var lpFilePart : PChar) : DWORD');
  CL.AddDelphiFunction('Function FileTimeToSystemTime( const lpFileTime : TFileTime; var lpSystemTime : TSystemTime) : BOOLEAN');
 CL.AddDelphiFunction('Function SystemTimeToFileTime( const lpSystemTime : TSystemTime; var lpFileTime : TFileTime) : BOOLEAN');
   CL.AddDelphiFunction('Function FileTimeToLocalFileTime( const lpFileTime : TFileTime; var lpLocalFileTime : TFileTime) : BOOLEAN');
 CL.AddDelphiFunction('Function LocalFileTimeToFileTime( const lpLocalFileTime : TFileTime; var lpFileTime : TFileTime) : BOOLEAN');
CL.AddDelphiFunction('Function CompareFileTime( const lpFileTime1, lpFileTime2 : TFileTime) : Longint');
 CL.AddDelphiFunction('Function FileTimeToDosDateTime( const lpFileTime : TFileTime; var lpFatDate, lpFatTime : Word) : BOOLEAN');
 CL.AddDelphiFunction('Function DosDateTimeToFileTime( wFatDate, wFatTime : Word; var lpFileTime : TFileTime) : BOOLEAN');
  CL.AddDelphiFunction('Function WFindClose( hFindFile : THandle) : BOOLEAN');

 //CL.AddDelphiFunction('Function AllocMem( Size : Cardinal) : Pointer');
 //CL.AddDelphiFunction('Procedure AddExitProc( Proc : TProcedure)');
 //CL.AddDelphiFunction('Function NewStr( S : string) : PString');
 //CL.AddDelphiFunction('Procedure DisposeStr( P : PString)');
 //CL.AddDelphiFunction('Procedure AssignStr( var P : PString; S : string)');
 CL.AddDelphiFunction('Procedure AppendStr( var Dest : string; S : string)');
 CL.AddDelphiFunction('Function UpperCase( S : string) : string');
 CL.AddDelphiFunction('Function LowerCase( S : string) : string');
 CL.AddDelphiFunction('Function CompareStr( S1, S2 : string) : Integer');
 //CL.AddDelphiFunction('Function CompareMem( P1, P2 : Pointer; Length : Integer) : Boolean');
 CL.AddDelphiFunction('Function CompareText( S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function SameText( S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiUpperCase( S : string) : string');
 CL.AddDelphiFunction('Function AnsiLowerCase( S : string) : string');
 CL.AddDelphiFunction('Function AnsiCompareStr( S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function AnsiSameStr( S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiCompareText( S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function AnsiSameText( S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiStrComp( S1, S2 : PChar) : Integer');
 CL.AddDelphiFunction('Function AnsiStrIComp( S1, S2 : PChar) : Integer');
 CL.AddDelphiFunction('Function AnsiStrLComp( S1, S2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function AnsiStrLIComp( S1, S2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function AnsiStrLower( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function AnsiStrUpper( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function AnsiLastChar( S : string) : PChar');
 CL.AddDelphiFunction('Function AnsiStrLastChar( P : PChar) : PChar');
 CL.AddDelphiFunction('Function WideUpperCase( S : WideString) : WideString');
 CL.AddDelphiFunction('Function WideLowerCase( S : WideString) : WideString');
 CL.AddDelphiFunction('Function WideCompareStr( S1, S2 : WideString) : Integer');
 CL.AddDelphiFunction('Function WideSameStr( S1, S2 : WideString) : Boolean');
 CL.AddDelphiFunction('Function WideCompareText( S1, S2 : WideString) : Integer');
 CL.AddDelphiFunction('Function WideSameText( S1, S2 : WideString) : Boolean');
 CL.AddDelphiFunction('Function Trim( S : string) : string;');
 CL.AddDelphiFunction('Function Trim2( S : WideString) : WideString;');
 CL.AddDelphiFunction('Function TrimLeft( S : string) : string;');
 CL.AddDelphiFunction('Function TrimLeft2( S : WideString) : WideString;');
 CL.AddDelphiFunction('Function TrimRight( S : string) : string;');
 CL.AddDelphiFunction('Function TrimRight2( S : WideString) : WideString;');
 CL.AddDelphiFunction('Function QuotedStr( S : string) : string');
 CL.AddDelphiFunction('Function AnsiQuotedStr( S : string; Quote : Char) : string');
 CL.AddDelphiFunction('Function AnsiExtractQuotedStr( var Src : PChar; Quote : Char) : string');
 CL.AddDelphiFunction('Function AnsiDequotedStr( S : string; AQuote : Char) : string');
 CL.AddDelphiFunction('Function IsValidIdent( Ident : string) : Boolean');
// CL.AddDelphiFunction('Function IntToStr( Value : Integer) : string;');
// CL.AddDelphiFunction('Function IntToStr( Value : Int64) : string;');
 CL.AddDelphiFunction('Function IntToHex( Value : Integer; Digits : Integer) : string;');
 CL.AddDelphiFunction('Function IntToHex64( Value : Int64; Digits : Integer) : string;');
 CL.AddDelphiFunction('Function StrToInt( S : string) : Integer');
 CL.AddDelphiFunction('Function StrToNum( S : string) : Integer');
 CL.AddDelphiFunction('Function StrToIntDef( S : string; Default : Integer) : Integer');
 CL.AddDelphiFunction('Function StrToInt64( S : string) : Int64');
 CL.AddDelphiFunction('Function StrToInt64Def( S : string; Default : Int64) : Int64');
 CL.AddDelphiFunction('Function StrToBool( S : string) : Boolean');
 CL.AddDelphiFunction('Function StrToBoolDef( S : string; Default : Boolean) : Boolean');
 CL.AddDelphiFunction('Function LoadStr( Ident : Integer) : string');
 CL.AddDelphiFunction('function FindStringResource(Ident: Integer): string)');
 CL.AddDelphiFunction('function FindStringRes(Ident: Integer): string)');
 CL.AddDelphiFunction('Function FileOpen( FileName : string; Mode : LongWord) : Integer');
 CL.AddDelphiFunction('Function FileCreate( FileName : string) : Integer;');
 CL.AddDelphiFunction('Function FileCreate2( FileName : string; Rights : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileSeek( Handle, Offset, Origin : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileSeek2( Handle : Integer; Offset : Int64; Origin : Integer) : Int64;');
 CL.AddDelphiFunction('Procedure FileClose( Handle : Integer)');
 CL.AddDelphiFunction('Function FileAge( FileName : string) : Integer');
 CL.AddDelphiFunction('Function FileExists( FileName : string) : Boolean');
 CL.AddDelphiFunction('Function DirectoryExists( Directory : string) : Boolean');
 CL.AddDelphiFunction('Function ForceDirectories( Dir : string) : Boolean');
 //CL.AddDelphiFunction('Function FindFirst( Path : string; Attr : Integer; var F : TSearchRec) : Integer');
 //CL.AddDelphiFunction('Function FindNext( var F : TSearchRec) : Integer');
 //CL.AddDelphiFunction('Procedure FindClose( var F : TSearchRec)');
 CL.AddDelphiFunction('Procedure AssignFile(var F: Text; FileName: string)');
 CL.AddDelphiFunction('Procedure CloseFile(var F: Text);');
 CL.AddDelphiFunction('Procedure Reset(var F: Text);');
 CL.AddDelphiFunction('Procedure Rewrite(var F: Text);');
 CL.AddDelphiFunction('Procedure Str(aint: integer; astr: string)');
//Procedure System_Str(aint: integer; astr: string);
 CL.AddDelphiFunction('Function Flush(var t: Text): Integer');
 CL.AddDelphiFunction('Function CharToBin(vChr: Char): String;');
 CL.AddDelphiFunction('function BinToChar(St: String): Char;');
 CL.AddDelphiFunction('procedure FreeAndNil2(var Obj: TObject);');
 CL.AddDelphiFunction('function Addr(Varname: string ): ___Pointer;');
 CL.AddDelphiFunction('Function GetResourceName( ObjStream : TStream; var AName : string) : Boolean');
 CL.AddDelphiFunction('Procedure WriteObjectResourceHeader( ObjStream, Output : TStream)');
 CL.AddDelphiFunction('Procedure Write16bitResourceHeader( const AName : TBytes; DataSize : Integer; Output : TStream)');
 CL.AddDelphiFunction('Procedure Write32bitResourceHeader( const AName : TBytes; DataSize : Integer; Output : TStream)');
 CL.AddDelphiFunction('Function FileGetDate( Handle : Integer) : Integer');
 CL.AddDelphiFunction('Function FileSetDate(FileName : string; Age : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileSetDate2(FileHandle : Integer; Age : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileSetDateH( Handle : Integer; Age : Integer) : Integer;');
 CL.AddDelphiFunction('Function FileGetAttr( FileName : string) : Integer');
 CL.AddDelphiFunction('Function FileSetAttr( FileName : string; Attr : Integer) : Integer');
 CL.AddDelphiFunction('Function FileIsReadOnly( FileName : string) : Boolean');
 CL.AddDelphiFunction('Function FileSetReadOnly( FileName : string; ReadOnly : Boolean) : Boolean');
 //CL.AddDelphiFunction('Function DeleteFile( FileName : string) : Boolean');
 CL.AddDelphiFunction('Function RenameFile( OldName, NewName : string) : Boolean');
 CL.AddDelphiFunction('Function ChangeFileExt( FileName, Extension : string) : string');
 CL.AddDelphiFunction('Function ExtractFilePath( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileDir( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileDrive( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractFileExt( FileName : string) : string');
 CL.AddDelphiFunction('Function ExpandFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function ExpandUNCFileName( FileName : string) : string');
 CL.AddDelphiFunction('Function ExtractRelativePath( BaseName, DestName : string) : string');
 CL.AddDelphiFunction('Function ExtractShortPathName( FileName : string) : string');
 CL.AddDelphiFunction('Function FileSearch( Name, DirList : string) : string');
 CL.AddDelphiFunction('Function DiskFree( Drive : Byte) : Int64');
 CL.AddDelphiFunction('Function DiskSize( Drive : Byte) : Int64');
 CL.AddDelphiFunction('Function FileDateToDateTime( FileDate : Integer) : TDateTime');
 CL.AddDelphiFunction('Function DateTimeToFileDate( DateTime : TDateTime) : Integer');
 CL.AddDelphiFunction('Function GetCurrentDir : string');
 CL.AddDelphiFunction('Function SetCurrentDir( Dir : string) : Boolean');
 CL.AddDelphiFunction('Function CreateDir( Dir : string) : Boolean');
 CL.AddDelphiFunction('Function RemoveDir( Dir : string) : Boolean');
 CL.AddDelphiFunction('Function StrLen( Str : PChar) : Cardinal');
 CL.AddDelphiFunction('Function StrEnd( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrMove( Dest : PChar; Source : PChar; Count : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrCopy( Dest : PChar; Source : PChar) : PChar');
 CL.AddDelphiFunction('Function StrECopy( Dest : PChar; Source : PChar) : PChar');
 CL.AddDelphiFunction('Function StrLCopy( Dest : PChar; Source : PChar; MaxLen : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrPCopy( Dest : PChar; Source : string) : PChar');
 CL.AddDelphiFunction('Function StrPLCopy( Dest : PChar; Source : string; MaxLen : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrCat( Dest : PChar; Source : PChar) : PChar');
 CL.AddDelphiFunction('Function StrLCat( Dest : PChar; Source : PChar; MaxLen : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrComp( Str1, Str2 : PChar) : Integer');
 CL.AddDelphiFunction('Function StrIComp( Str1, Str2 : PChar) : Integer');
 CL.AddDelphiFunction('Function StrLComp( Str1, Str2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function StrLIComp( Str1, Str2 : PChar; MaxLen : Cardinal) : Integer');
 CL.AddDelphiFunction('Function StrPos( Str1, Str2 : PChar) : PChar');
 CL.AddDelphiFunction('Function StrUpper( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrLower( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function StrPas( Str : PChar) : string');
 CL.AddDelphiFunction('Function StrAlloc( Size : Cardinal) : PChar');
 CL.AddDelphiFunction('Function StrBufSize( Str : PChar) : Cardinal');
 CL.AddDelphiFunction('Function StrNew( Str : PChar) : PChar');
 CL.AddDelphiFunction('Procedure StrDispose( Str : PChar)');
 CL.AddDelphiFunction('Function FloatToStr( Value : Extended) : string;');
 CL.AddDelphiFunction('Function FloatToStr1( Value : Extended; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function CurrToStr( Value : Currency) : string;');
 CL.AddDelphiFunction('Function CurrToStrF( Value : Currency; FormatSettings : TFormatSettings; Digits: Integer) : string;');
 CL.AddDelphiFunction('Function CurrToStrFS(Value: Currency; Format: TFloatFormat; Digits: Integer; const FormatSettings: TFormatSettings): string');
 CL.AddDelphiFunction('Function FloatToCurr( Value : Extended) : Currency');
 CL.AddDelphiFunction('Function FloatToStrF( Value : Extended; Format : TFloatFormat; Precision, Digits : Integer) : string;');
 CL.AddDelphiFunction('Function FloatToStrFS( Value : Extended; Format : TFloatFormat; Precision, Digits : Integer; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function FloatToStr2( Value : Extended; Format : TFloatFormat; Precision, Digits : Integer; FormatSettings : TFormatSettings) : string;');

 //CL.AddDelphiFunction('Function CurrToStrF( Value : Currency; Format : TFloatFormat; Digits : Integer) : string;');
 //CL.AddDelphiFunction('Function CurrToStrF( Value : Currency; Format : TFloatFormat; Digits : Integer; FormatSettings : TFormatSettings) : string;');
 //prototypes for overload
 CL.AddDelphiFunction('Function FormatFloat( Format : string; Value : Extended) : string;');
 CL.AddDelphiFunction('Function FormatFloat2( Format : string; Value : Extended; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function FormatCurr( Format : string; Value : Currency) : string;');
 CL.AddDelphiFunction('Function FormatCurr2( Format : string; Value : Currency; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('function Format2(const Format: string; const Args: array of const;'+
                              'const FormatSettings: TFormatSettings): string');
 CL.AddDelphiFunction('Function StrToFloat( S : string) : Extended;');
 CL.AddDelphiFunction('Function StrToFloat2( S : string; FormatSettings : TFormatSettings) : Extended;');
 CL.AddDelphiFunction('Function StrToFloatF( S : string; FormatSettings : TFormatSettings) : Extended;');
 CL.AddDelphiFunction('Function StrToFloatFS(S: string; Format : TFloatFormat; Precision, Digits : Integer; FormatSettings : TFormatSettings): extended;');
 CL.AddDelphiFunction('Function StrToFloatDef( S : string; Default : Extended) : Extended;');
 CL.AddDelphiFunction('Function StrToFloatDef2( S : string; Default : Extended; FormatSettings : TFormatSettings) : Extended;');
 CL.AddDelphiFunction('Function StrToCurr( S : string) : Currency;');
 CL.AddDelphiFunction('Function StrToCurr2( S : string; FormatSettings : TFormatSettings) : Currency;');
 CL.AddDelphiFunction('Function StrToCurrDef( S : string; Default : Currency) : Currency;');
 CL.AddDelphiFunction('Function StrToCurrDef2( S : string; Default : Currency; FormatSettings : TFormatSettings) : Currency;');
 CL.AddDelphiFunction('Function DateTimeToTimeStamp(DateTime: TDateTime): TTimeStamp');
 CL.AddDelphiFunction('Function TimeStampToDateTime(const TimeStamp: TTimeStamp): TDateTime');
 CL.AddDelphiFunction('Function MSecsToTimeStamp( MSecs : Comp) : TTimeStamp');
 CL.AddDelphiFunction('Function TimeStampToMSecs( TimeStamp : TTimeStamp) : Comp');
 CL.AddDelphiFunction('Function EncodeDate( Year, Month, Day : Word) : TDateTime');
 CL.AddDelphiFunction('Function EncodeTime( Hour, Min, Sec, MSec : Word) : TDateTime');
 CL.AddDelphiFunction('Procedure DecodeDate( DateTime : TDateTime; var Year, Month, Day : Word)');
 CL.AddDelphiFunction('Function DecodeDateFully( DateTime : TDateTime; var Year, Month, Day, DOW : Word) : Boolean');
 CL.AddDelphiFunction('Function InternalDecodeDate( DateTime : TDateTime; var Year, Month, Day, DOW : Word) : Boolean');
 CL.AddDelphiFunction('Procedure DecodeTime( DateTime : TDateTime; var Hour, Min, Sec, MSec : Word)');
 CL.AddDelphiFunction('Procedure DateTimeToSystemTime( DateTime : TDateTime; var SystemTime : TSystemTime)');
 CL.AddDelphiFunction('Function SystemTimeToDateTime( SystemTime : TSystemTime) : TDateTime');
 CL.AddDelphiFunction('Function DayOfWeek( DateTime : TDateTime) : Word');
 CL.AddDelphiFunction('Function Date : TDateTime');
 CL.AddDelphiFunction('Function Time : TDateTime');
 CL.AddDelphiFunction('Function GetTime : TDateTime');
 CL.AddDelphiFunction('Function Now : TDateTime');
 CL.AddDelphiFunction('Function CurrentYear : Word');
 CL.AddDelphiFunction('Function IncMonth( DateTime : TDateTime; NumberOfMonths : Integer) : TDateTime');
 CL.AddDelphiFunction('Procedure IncAMonth( var Year, Month, Day : Word; NumberOfMonths : Integer)');
 CL.AddDelphiFunction('Procedure ReplaceTime( var DateTime : TDateTime; NewTime : TDateTime)');
 CL.AddDelphiFunction('Procedure ReplaceDate( var DateTime : TDateTime; NewDate : TDateTime)');
 CL.AddDelphiFunction('Function IsLeapYear( Year : Word) : Boolean');
 CL.AddDelphiFunction('Function DateToStr( DateTime : TDateTime) : string;');
 CL.AddDelphiFunction('Function DateToStr2( DateTime : TDateTime; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function TimeToStr( DateTime : TDateTime) : string;');
 CL.AddDelphiFunction('Function TimeToStr2( DateTime : TDateTime; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function DateTimeToStr( DateTime : TDateTime) : string;');
 CL.AddDelphiFunction('Function DateTimeToStr2( DateTime : TDateTime; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Function StrToDate( S : string) : TDateTime;');
 CL.AddDelphiFunction('Function StrToDate2( S : string; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function StrToDateDef( S : string; Default : TDateTime) : TDateTime;');
 CL.AddDelphiFunction('Function StrToDateDef2( S : string; Default : TDateTime; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function TryStrToDate( S : string; Value : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function TryStrToDate2( S : string; Value : TDateTime; FormatSettings : TFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function StrToTime( S : string) : TDateTime;');
 CL.AddDelphiFunction('Function StrToTime2( S : string; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function StrToTimeDef( S : string; Default : TDateTime) : TDateTime;');
 CL.AddDelphiFunction('Function StrToTimeDef2( S : string; Default : TDateTime; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function TryStrToTime( S : string; Value : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function TryStrToTime2( S : string; Value : TDateTime; FormatSettings : TFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function StrToDateTime( S : string) : TDateTime;');
 CL.AddDelphiFunction('Function StrToDateTime2( S : string; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function StrToDateTimeDef( S : string; Default : TDateTime) : TDateTime;');
 CL.AddDelphiFunction('Function StrToDateTimeDef2( S : string; Default : TDateTime; FormatSettings : TFormatSettings) : TDateTime;');
 CL.AddDelphiFunction('Function TryStrToDateTime( S : string; Value : TDateTime) : Boolean;');
 CL.AddDelphiFunction('Function TryStrToDateTime2( S : string; Value : TDateTime; FormatSettings : TFormatSettings) : Boolean;');
 CL.AddDelphiFunction('Function FormatDateTime( Format : string; DateTime : TDateTime) : string;');
 CL.AddDelphiFunction('Function FormatDateTime2( Format : string; DateTime : TDateTime; FormatSettings : TFormatSettings) : string;');
 CL.AddDelphiFunction('Procedure DateTimeToString( var Result : string; Format : string; DateTime : TDateTime);');
 CL.AddDelphiFunction('Procedure DateTimeToString2( var Result : string; Format : string; DateTime : TDateTime; FormatSettings : TFormatSettings);');
 CL.AddDelphiFunction('Function FloatToDateTime( Value : Extended) : TDateTime');
 CL.AddDelphiFunction('Function TryFloatToDateTime( Value : Extended; AResult : TDateTime) : Boolean');
 CL.AddDelphiFunction('Function SysErrorMessage( ErrorCode : Integer) : string');
 CL.AddDelphiFunction('Function GetLocaleStr( Locale, LocaleType : Integer; Default : string) : string');
 CL.AddDelphiFunction('Function GetLocaleChar( Locale, LocaleType : Integer; Default : Char) : Char');
 CL.AddDelphiFunction('Procedure GetFormatSettings');
 CL.AddDelphiFunction('Procedure GetLocaleFormatSettings( LCID : Integer; var FormatSettings : TFormatSettings)');
 CL.AddDelphiFunction('Function InquireSignal( RtlSigNum : Integer) : TSignalState');
 CL.AddDelphiFunction('Procedure AbandonSignalHandler( RtlSigNum : Integer)');
 CL.AddDelphiFunction('Procedure HookSignal( RtlSigNum : Integer)');
 CL.AddDelphiFunction('Procedure UnhookSignal( RtlSigNum : Integer; OnlyIfHooked : Boolean)');
 CL.AddDelphiFunction('Procedure HookOSExceptions');
 //CL.AddDelphiFunction('Function MapSignal( SigNum : Integer; Context : PSigContext) : LongWord');
 CL.AddDelphiFunction('Procedure SignalConverter( ExceptionEIP : LongWord; FaultAddr : LongWord; ErrorCode : LongWord)');
 CL.AddDelphiFunction('Procedure SetSafeCallExceptionMsg( Msg : String)');
 //CL.AddDelphiFunction('Procedure SetSafeCallExceptionAddr( Addr : Pointer)');
 CL.AddDelphiFunction('Function GetSafeCallExceptionMsg : String');
 //CL.AddDelphiFunction('Function GetSafeCallExceptionAddr : Pointer');
 //CL.AddDelphiFunction('Function LoadLibrary( ModuleName : PChar) : HMODULE');
 //CL.AddDelphiFunction('Function FreeLibrary( Module : HMODULE) : LongBool');
 //CL.AddDelphiFunction('Function GetProcAddress( Module : HMODULE; Proc : PChar) : Pointer');
 //CL.AddDelphiFunction('Function GetProcAddress( hModule : HMODULE; lpProcName : LPCSTR) : FARPROC');
 CL.AddDelphiFunction('Function GetVersion : DWORD');
 CL.AddDelphiFunction('function FloatToTextFmt(Buf: PChar; const Value: Extended; ValueType: TFloatValue; Format: PChar): Integer');

 //FloatToTextFmt
 CL.AddDelphiFunction('Function GetModuleHandle( ModuleName : PChar) : HMODULE');
 CL.AddDelphiFunction('Function GetPackageModuleHandle( PackageName : PChar) : HMODULE');
 CL.AddDelphiFunction('Procedure Sleep( milliseconds : Cardinal)');
 CL.AddDelphiFunction('Function GetModuleName( Module : HMODULE) : string');
 //CL.AddDelphiFunction('Function ExceptionErrorMessage( ExceptObject : TObject; ExceptAddr : Pointer; Buffer : PChar; Size : Integer) : Integer');
 CL.AddDelphiFunction('Procedure ShowException(ExceptObject : TObject; ExceptAddr : ___Pointer)');
 CL.AddDelphiFunction('Procedure Abort');
 CL.AddDelphiFunction('Procedure OutOfMemoryError');
 CL.AddDelphiFunction('Procedure FPower10');
 CL.AddDelphiFunction('Procedure Halt');
 CL.AddDelphiFunction('Procedure RunError(errorcode: byte)');
 CL.AddDelphiFunction('Function EOF: boolean');
 CL.AddDelphiFunction('Function EOln: boolean');
 CL.AddDelphiFunction('function IOResult: Integer');
 CL.AddDelphiFunction('function GetLastError: Integer');
 CL.AddDelphiFunction('procedure SetLastError(ErrorCode: Integer)');
 CL.AddDelphiFunction('function IsMemoryManagerSet: Boolean)');    //3.6
 CL.AddDelphiFunction('function IsConsole: Boolean)');
 CL.AddDelphiFunction('function IsLibrary: Boolean)');
 CL.AddDelphiFunction('function IsMultiThread: Boolean)');
 CL.AddDelphiFunction('Function Output: Text)');
 CL.AddDelphiFunction('Function Input: Text)');
 CL.AddDelphiFunction('Function ErrOutput: Text)');
 CL.AddDelphiFunction('function HiByte(W: Word): Byte)');
 CL.AddDelphiFunction('function HiWord(l: DWORD): Word)');
 CL.AddDelphiFunction('function LoByte(l: WORD): Byte)');
 CL.AddDelphiFunction('function MakeWord(A, B: Byte): Word)');
 CL.AddDelphiFunction('function MakeLong(A, B: Word): Longint)');
 CL.AddDelphiFunction('Function LogicalAnd( A, B : Integer) : Boolean');
  CL.AddDelphiFunction('function getLongDayNames: string)');
 CL.AddDelphiFunction('function getShortDayNames: string)');
 CL.AddDelphiFunction('function getLongMonthNames: string)');
 CL.AddDelphiFunction('function getShortMonthNames: string)');

  //CL.AddDelphiFunction('function Slice(var A: array; Count: Integer): array');
 //function StringOfChar(ch: AnsiChar; Count: Integer): AnsiString; overload;
 //CL.AddDelphiFunction('Procedure Beep');
 CL.AddDelphiFunction('Function ByteType( S : string; Index : Integer) : TMbcsByteType');
 CL.AddDelphiFunction('Function StrByteType( Str : PChar; Index : Cardinal) : TMbcsByteType');
 CL.AddDelphiFunction('Function ByteToCharLen( S : string; MaxLen : Integer) : Integer');
 CL.AddDelphiFunction('Function CharToByteLen( S : string; MaxLen : Integer) : Integer');
 CL.AddDelphiFunction('Function ByteToCharIndex( S : string; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function CharToByteIndex( S : string; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function StrCharLength( Str : PChar) : Integer');
 CL.AddDelphiFunction('Function StrNextChar( Str : PChar) : PChar');
 CL.AddDelphiFunction('Function CharLength( S : String; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function NextCharIndex( S : String; Index : Integer) : Integer');
 CL.AddDelphiFunction('Function IsPathDelimiter( S : string; Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function IsDelimiter( Delimiters, S : string; Index : Integer) : Boolean');
 CL.AddDelphiFunction('Function IncludeTrailingPathDelimiter( S : string) : string');
 CL.AddDelphiFunction('Function IncludeTrailingBackslash( S : string) : string');
 CL.AddDelphiFunction('Function ExcludeTrailingPathDelimiter( S : string) : string');
 CL.AddDelphiFunction('Function ExcludeTrailingBackslash( S : string) : string');
 CL.AddDelphiFunction('Function LastDelimiter( Delimiters, S : string) : Integer');
 CL.AddDelphiFunction('Function AnsiCompareFileName( S1, S2 : string) : Integer');
 CL.AddDelphiFunction('Function SameFileName( S1, S2 : string) : Boolean');
 CL.AddDelphiFunction('Function AnsiLowerCaseFileName( S : string) : string');
 CL.AddDelphiFunction('Function AnsiUpperCaseFileName( S : string) : string');
 CL.AddDelphiFunction('Function AnsiPos( Substr, S : string) : Integer');
 CL.AddDelphiFunction('Function AnsiStrPos( Str, SubStr : PChar) : PChar');
 CL.AddDelphiFunction('Function StringReplace( S, OldPattern, NewPattern : string; Flags : TReplaceFlags) : string');
 CL.AddDelphiFunction('Function WrapText2( Line, BreakStr : string; BreakChars : TSysCharSet; MaxCol : Integer) : string;');
 CL.AddDelphiFunction('Function WrapText( Line : string; MaxCol : Integer) : string;');
 CL.AddDelphiFunction('Function FindCmdLineSwitch( Switch : string; Chars : TSysCharSet; IgnoreCase : Boolean) : Boolean;');
 CL.AddDelphiFunction('Function FindCmmdLineSwitch( Switch : string) : Boolean;');
 CL.AddDelphiFunction('Function FindCdLineSwitch( Switch : string; IgnoreCase : Boolean) : Boolean;');
 CL.AddDelphiFunction('procedure AddTerminateProc(TermProc: TTerminateProc);');
 CL.AddDelphiFunction('function CallTerminateProcs: Boolean;');

 CL.AddDelphiFunction('Function GetWindowWord( hWnd : HWND; nIndex : Integer) : Word');
 CL.AddDelphiFunction('Function SetWindowWord( hWnd : HWND; nIndex : Integer; wNewWord : Word) : Word');
 CL.AddDelphiFunction('Function GetWindowLong( hWnd : HWND; nIndex : Integer) : Longint');
 CL.AddDelphiFunction('Function SetWindowLong( hWnd : HWND; nIndex : Integer; dwNewLong : Longint) : Longint');
 CL.AddDelphiFunction('Function GetClassWord( hWnd : HWND; nIndex : Integer) : Word');
 CL.AddDelphiFunction('Function SetClassWord( hWnd : HWND; nIndex : Integer; wNewWord : Word) : Word');
 CL.AddDelphiFunction('Function GetClassLong( hWnd : HWND; nIndex : Integer) : DWORD');
 CL.AddDelphiFunction('Function SetClassLong( hWnd : HWND; nIndex : Integer; dwNewLong : Longint) : DWORD');
 CL.AddDelphiFunction('Function GetDesktopWindow : HWND');
 CL.AddDelphiFunction('Function GetParent( hWnd : HWND) : HWND');
 CL.AddDelphiFunction('Function SetParent( hWndChild, hWndNewParent : HWND) : HWND');
 CL.AddDelphiFunction('Function GetTopWindow( hWnd : HWND) : HWND');
 CL.AddDelphiFunction('Function GetNextWindow( hWnd : HWND; uCmd : UINT) : HWND');
 CL.AddDelphiFunction('Function GetWindow( hWnd : HWND; uCmd : UINT) : HWND');
 CL.AddDelphiFunction('Procedure PostQuitMessage( nExitCode : Integer)');
 CL.AddDelphiFunction('Function InSendMessage : BOOL');
 CL.AddDelphiFunction('Function InSendMessageEx( lpReserved : ___Pointer) : DWORD');
 {CL.AddConstantN('ISMEX_NOSEND','LongInt').SetInt( 0);
 CL.AddConstantN('ISMEX_SEND','LongInt').SetInt( 1);
 CL.AddConstantN('ISMEX_NOTIFY','LongInt').SetInt( 2);
 CL.AddConstantN('ISMEX_CALLBACK','LongInt').SetInt( 4);
 CL.AddConstantN('ISMEX_REPLIED','LongInt').SetInt( 8);}
 CL.AddDelphiFunction('Function GetDoubleClickTime : UINT');
 CL.AddDelphiFunction('Function SetDoubleClickTime( Interval : UINT) : BOOL');
   //CL.AddDelphiFunction('Function CmdLine( Switch : string; IgnoreCase : Boolean) : Boolean;');
 CL.AddDelphiFunction('Procedure RaiseLastOSError');
 //from unit filectrl
 {procedure ProcessPath (const EditText: string; var Drive: Char;
  var DirPart: string; var FilePart: string);}
 CL.AddDelphiFunction('Procedure ProcessPath(const EditText: string; var Drive: Char; var DirPart: string; var FilePart: string);');
 CL.AddDelphiFunction('Procedure ProcessPath1(const EditText: string; var Drive: Char; var DirPart: string; var FilePart: string);');
 CL.AddDelphiFunction('function SlashSep(const Path, S: String): String');
 CL.AddDelphiFunction('procedure CutFirstDirectory(var S: String)');
 CL.AddDelphiFunction('function MinimizeName(const Filename: String; Canvas: TCanvas;MaxLen: Integer): TFileName');
 CL.AddDelphiFunction('function VolumeID(DriveChar: Char): string');
 CL.AddDelphiFunction('function NetworkVolume(DriveChar: Char): string');
 CL.AddDelphiFunction('Procedure OutputDebugString(lpOutputString : PChar)');
 CL.AddDelphiFunction('Function ExpandEnvironmentStrings( lpSrc : PChar; lpDst : PChar; nSize : DWORD) : DWORD');
 //REST Routines
 //procedure DomToTree (anXmlNode: IXMLNode; aTreeNode: TTreeNode; aTreeView: TTreeView);
  //CL.AddDelphiFunction('Procedure DomToTree(anXmlNode:IXMLNode; aTreeNode:TTreeNode; aTreeView: TTreeView)');

 //var prototypes func
 CL.AddDelphiFunction('function randSeed: longint');
 CL.AddDelphiFunction('procedure SetrandSeed: longint');
 CL.AddDelphiFunction('function currencyString: String');
 CL.AddDelphiFunction('function currencyDecimals: Byte');
 CL.AddDelphiFunction('function currencyFormat: Byte');
 CL.AddDelphiFunction('procedure SetcurrencyFormat(aset: Byte)');
 CL.AddDelphiFunction('function MainInstance: longword');
 //CL.AddDelphiFunction('function ListSeparator: Char'); in fmain
 CL.AddDelphiFunction('function SysLocale: TSysLocale');
 //CL.AddDelphiFunction('function AddDelphiFunction(const Decl: tbtString): TPSRegProc;');
   CL.AddDelphiFunction('procedure raise');
  // SysLocale: TSysLocale;
  CL.AddDelphiFunction('function MainThreadID: longword');
 CL.AddDelphiFunction('function TrueBoolStrs: array of string');
 CL.AddDelphiFunction('function FalseBoolStrs: array of string');
 CL.AddDelphiFunction('function LeadBytes: set of char');  //TForLeadBytes
 CL.AddDelphiFunction('function DefaultTextLineBreakStyle: TTextLineBreakStyle');

 //cl.AddVariable(trueboolstrs, array of string)
  { Object conversion routines of unit classes}
CL.AddDelphiFunction('procedure ObjectBinaryToText(Input, Output: TStream)');
CL.AddDelphiFunction('procedure ObjectBinaryToText1(Input, Output: TStream;'
  +'var OriginalFormat: TStreamOriginalFormat)');
CL.AddDelphiFunction('procedure ObjectTextToBinary(Input, Output: TStream)');
CL.AddDelphiFunction('procedure ObjectTextToBinary1(Input, Output: TStream;'+
  'var OriginalFormat: TStreamOriginalFormat)');
CL.AddDelphiFunction('procedure ObjectResourceToText(Input, Output: TStream)');
CL.AddDelphiFunction('procedure ObjectResourceToText1(Input, Output: TStream;'+
  'var OriginalFormat: TStreamOriginalFormat)');
CL.AddDelphiFunction('procedure ObjectTextToResource(Input, Output: TStream)');
CL.AddDelphiFunction('procedure ObjectTextToResource1(Input, Output: TStream;'+
  'var OriginalFormat: TStreamOriginalFormat)');
CL.AddDelphiFunction('function TestStreamFormat(Stream: TStream): TStreamOriginalFormat');

{ Utility routines of unit classes}
CL.AddDelphiFunction('function LineStart(Buffer, BufPos: PChar): PChar');
CL.AddDelphiFunction('function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar;'+
  'Strings: TStrings): Integer');
 CL.AddDelphiFunction('Function TestStreamFormat( Stream : TStream) : TStreamOriginalFormat');
 CL.AddDelphiFunction('Procedure RegisterClass( AClass : TPersistentClass)');
 CL.AddDelphiFunction('Procedure RegisterClasses( AClasses : array of TPersistentClass)');
 CL.AddDelphiFunction('Procedure RegisterClassAlias( AClass : TPersistentClass; const Alias : string)');
 CL.AddDelphiFunction('Procedure UnRegisterClass( AClass : TPersistentClass)');
 CL.AddDelphiFunction('Procedure UnRegisterClasses( AClasses : array of TPersistentClass)');
 CL.AddDelphiFunction('Procedure UnRegisterModuleClasses( Module : HMODULE)');
 CL.AddDelphiFunction('Function FindGlobalComponent( const Name : string) : TComponent');
 CL.AddDelphiFunction('Function IsUniqueGlobalComponentName( const Name : string) : Boolean');
 CL.AddDelphiFunction('Function InitInheritedComponent( Instance : TComponent; RootAncestor : TClass) : Boolean');
 CL.AddDelphiFunction('Function InitComponentRes( const ResName : string; Instance : TComponent) : Boolean');
 CL.AddDelphiFunction('Function ReadComponentRes( const ResName : string; Instance : TComponent) : TComponent');
 CL.AddDelphiFunction('Function ReadComponentResEx( HInstance : THandle; const ResName : string) : TComponent');
 CL.AddDelphiFunction('Function ReadComponentResFile( const FileName : string; Instance : TComponent) : TComponent');
 CL.AddDelphiFunction('Procedure WriteComponentResFile( const FileName : string; Instance : TComponent)');
 CL.AddDelphiFunction('Procedure GlobalFixupReferences');
 CL.AddDelphiFunction('Procedure GetFixupReferenceNames( Root : TComponent; Names : TStrings)');
 CL.AddDelphiFunction('Procedure GetFixupInstanceNames( Root : TComponent; const ReferenceRootName : string; Names : TStrings)');
 CL.AddDelphiFunction('Procedure RedirectFixupReferences( Root : TComponent; const OldRootName, NewRootName : string)');
 CL.AddDelphiFunction('Procedure RemoveFixupReferences( Root : TComponent; const RootName : string)');
 CL.AddDelphiFunction('Procedure RemoveFixups( Instance : TPersistent)');
 CL.AddDelphiFunction('Function FindNestedComponent( Root : TComponent; const NamePath : string) : TComponent');
 CL.AddDelphiFunction('Procedure BeginGlobalLoading');
 CL.AddDelphiFunction('Procedure NotifyGlobalLoading');
 CL.AddDelphiFunction('Procedure EndGlobalLoading');
 CL.AddDelphiFunction('Function GetUltimateOwner1( ACollection : TCollection) : TPersistent;');
 CL.AddDelphiFunction('Function GetUltimateOwner( APersistent : TPersistent) : TPersistent;');
 CL.AddTypeS('TWndMethod', 'Procedure (var Message : TMessage)');
 //CL.AddDelphiFunction('Function MakeObjectInstance( Method : TWndMethod) : Pointer');
 CL.AddDelphiFunction('Procedure FreeObjectInstance( ObjectInstance : ___Pointer)');
// CL.AddDelphiFunction('Function AllocateHWnd( Method : TWndMethod) : HWND');
 CL.AddDelphiFunction('Procedure DeallocateHWnd( Wnd : HWND)');
 CL.AddDelphiFunction('Function AncestorIsValid( Ancestor : TPersistent; Root, RootAncestor : TComponent) : Boolean');
 CL.AddDelphiFunction('function IdentToInt(const Ident: string; var Int: Longint; const Map: array of TIdentMapEntry): Boolean');
CL.AddDelphiFunction('function IntToIdent(Int: Longint; var Ident: string; const Map: array of TIdentMapEntry): Boolean;');

//procedure BinToHex(Buffer, Text: PChar; BufSize: Integer);
//function HexToBin(Text, Buffer: PChar; BufSize: Integer): Integer;
//function FindRootDesigner(Obj: TPersistent): IDesignerNotify;
{ CountGenerations:  Use this helper function to calculate the distance
  between two related classes.  Returns -1 if Descendent is not a descendent of  Ancestor. }
CL.AddDelphiFunction('function CountGenerations(Ancestor,Descendent: TClass): Integer');
 {  Call CheckSynchronize periodically within the main thread in order for
   background threads to synchronize execution with the main thread.  This
   is mainly for applications that have an event driven UI such as Windows
   or XWindows (Qt/CLX).  The best place this can be called is during Idle
   processing.  This guarantees that the main thread is in a known "good"
   state so that method calls can be safely made.  Returns True if a method
   was synchronized.  Returns False if there was nothing done.
}
CL.AddDelphiFunction('function CheckSynchronize(Timeout: Integer): Boolean');
//CL.AddDelphiFunction('function FindObjects(AClass: TClass; FindDerived: Boolean): TObjectArray');;

 //functions and procs over units -----------------------------------------
 CL.AddDelphiFunction('Procedure Check(Status: Integer)');
 CL.AddDelphiFunction('Function ColorToRGB(color: TColor): Longint');
 CL.AddDelphiFunction('function ColorToString(Color: TColor): string)');
 CL.AddDelphiFunction('function StringToColor(const S: string): TColor)');
 CL.AddDelphiFunction('function ColorToIdent(Color: Longint; var Ident: string): Boolean)');
 CL.AddDelphiFunction('function IdentToColor(const Ident: string; var Color: Longint): Boolean)');
 CL.AddDelphiFunction('function CharsetToIdent(Charset: Longint; var Ident: string): Boolean)');
 CL.AddDelphiFunction('function IdentToCharset(const Ident: string; var Charset: Longint): Boolean)');
 CL.AddDelphiFunction('Procedure DataBaseError(const Message: string)');
 CL.AddDelphiFunction('Procedure DBIError(errorCode: Integer)');
 CL.AddDelphiFunction('Function GetLongHint(const hint: string): string');
 CL.AddDelphiFunction('Function GetShortHint(const hint: string): string');
 CL.AddDelphiFunction('Function GetParentForm(control: TControl): TForm');
 //CL.AddDelphiFunction('Function GraphicFilter(graphicclass: TGraphicClass): string');
 CL.AddDelphiFunction('Function ValidParentForm(control: TControl): TForm');
 CL.AddDelphiFunction('Function IsAccel(VK: Word; const Str: string): Boolean');
 CL.AddDelphiFunction('Function ForegroundTask: Boolean');
 CL.AddDelphiFunction('Function LoadCursor(hInstance: HINST; lpCursorName: PChar): HCURSOR');
 CL.AddDelphiFunction('function LoadPackage(const Name: string): HMODULE');
 //CL.AddDelphiFunction('function LoadPackage(const Name: string): HMODULE');
 CL.AddDelphiFunction('procedure UnloadPackage(Module: HMODULE)');
 CL.AddDelphiFunction('procedure GetPackageDescription(ModuleName: PChar): string)');
 CL.AddDelphiFunction('procedure InitializePackage(Module: HMODULE)');
 CL.AddDelphiFunction('procedure FinalizePackage(Module: HMODULE)');
 CL.AddDelphiFunction('Function GDAL: LongWord');
 CL.AddDelphiFunction('procedure RCS');
 CL.AddDelphiFunction('procedure RPR');
 CL.AddDelphiFunction('function LoadLibrary(const Name: PChar): HMODULE');
 //CL.AddDelphiFunction('function LoadModule(const Name: PChar): HMODULE');
 CL.AddDelphiFunction('function FreeModule(var hLibModule: HINST): BOOLEAN');
 CL.AddDelphiFunction('function FreeLibrary(Module: HMODULE):boolean');
 CL.AddDelphiFunction('Function GetProcAddress(Module : HMODULE; Proc : PChar): Dword');
 CL.AddDelphiFunction('function GetThreadLocale: Longint; stdcall');
 CL.AddDelphiFunction('function GetCurrentThreadID: LongWord; stdcall;');
 CL.AddDelphiFunction('Procedure MoveMemory( Destination : ___Pointer; Source : ___Pointer; Length : DWORD)');
 CL.AddDelphiFunction('Procedure CopyMemory( Destination : ___Pointer; Source : ___Pointer; Length : DWORD)');
 CL.AddDelphiFunction('Procedure FillMemory( Destination : ___Pointer; Length : DWORD; Fill : Byte)');
 CL.AddDelphiFunction('Procedure ZeroMemory( Destination : ___Pointer; Length : DWORD)');
 CL.AddDelphiFunction('Procedure FreeLibraryAndExitThread( hLibModule : HMODULE; dwExitCode : DWORD)');
 CL.AddDelphiFunction('Function DisableThreadLibraryCalls( hLibModule : HMODULE) : BOOLEAN');
 CL.AddDelphiFunction('Function GlobalFree( hMem : HGLOBAL) : HGLOBAL');
 CL.AddDelphiFunction('Function GlobalCompact( dwMinFree : DWORD) : UINT');
 CL.AddDelphiFunction('Procedure GlobalFix( hMem : HGLOBAL)');
 CL.AddDelphiFunction('Procedure GlobalUnfix( hMem : HGLOBAL)');
 CL.AddDelphiFunction('Function DrawCaption( p1 : HWND; p2 : HDC; const p3 : TRect; p4 : UINT) : BOOLEAN');
 CL.AddDelphiFunction('Function DrawAnimatedRects( hwnd : HWND; idAni : Integer; const lprcFrom, lprcTo : TRect) : BOOLEAN');
 CL.AddDelphiFunction('Function DrawEdge( hdc : HDC; var qrc : TRect; edge : UINT; grfFlags : UINT) : BOOLEAN');
 CL.AddDelphiFunction('Function DrawFrameControl( DC : HDC; const Rect : TRect; uType, uState : UINT) : BOOLEAN');

 CL.AddDelphiFunction('Function GetSysColor( nIndex : Integer) : DWORD');
 CL.AddDelphiFunction('Function GetSysColorBrush( nIndex : Integer) : HBRUSH');
 CL.AddDelphiFunction('Function DrawFocusRect( hDC : HDC; const lprc : TRect) : BOOLEAN');
 CL.AddDelphiFunction('Function FillRect( hDC : HDC; const lprc : TRect; hbr : HBRUSH) : Integer');
 CL.AddDelphiFunction('Function FrameRect( hDC : HDC; const lprc : TRect; hbr : HBRUSH) : Integer');
 CL.AddDelphiFunction('Function InvertRect( hDC : HDC; const lprc : TRect) : BOOLEAN');
 CL.AddDelphiFunction('Function SetRect( var lprc : TRect; xLeft, yTop, xRight, yBottom : Integer) : BOOLEAN');
 CL.AddDelphiFunction('Function SetRectEmpty( var lprc : TRect) : BOOLEAN');
 CL.AddDelphiFunction('Function CopyRect( var lprcDst : TRect; const lprcSrc : TRect) : BOOLEAN');
 CL.AddDelphiFunction('Function InflateRect( var lprc : TRect; dx, dy : Integer) : BOOLEAN');
 CL.AddDelphiFunction('Function IntersectRect2( var lprcDst : TRect; const lprcSrc1, lprcSrc2 : TRect) : BOOLEAN');
 CL.AddDelphiFunction('Function SubtractRect( var lprcDst : TRect; const lprcSrc1, lprcSrc2 : TRect) : BOOLEAN');
 //CL.AddDelphiFunction('Function OffsetRect( var lprc : TRect; dx, dy : Integer) : BOOL');
 //CL.AddDelphiFunction('Function IsRectEmpty( const lprc : TRect) : BOOL');
 //getprocessaddres
 {function BitBlt(
  hdcDest: HDC;     // handle to destination device context
  nXDest,           // x-coordinate of destination rectangle's upper-left corner
  nYDest,           // y-coordinate of destination rectangle's upper-left corner
  nWidth,           // width of destination rectangle
  nHeight: Integer; // height of destination rectangle
  hdcSrc: HDC;      // handle to source device context
  nXSrc,            // x-coordinate of source rectangle's upper-left corner
  nYSrc: Integer;   // y-coordinate of source rectangle's upper-left corner
  dwRop: DWORD      // raster operation code
): Boolean; }
 CL.AddDelphiFunction('Function StretchBlt(hdcDest: HDC; nXDest,nYDest,nWidth, nHeight: Integer; hdcSrc:HDC; nXSrc, nYSrc, sWidth, sHeight: Integer; dwRop: DWORD): Boolean;');
 //CL.AddDelphiFunction('Function BitBlt(hdcDest: HDC;nXDest,nYDest,nWidth, nHeight: Integer; hdcSrc:HDC; nXSrc, nYSrc: Integer; dwRop: DWORD): Boolean;');
// CL.AddDelphiFunction('Function StretchBlt(hdcDest: HDC;nXDest,nYDest,nWidth, nHeight: Integer; hdcSrc:HDC; nXSrc, nYSrc: Integer; dwRop: DWORD): Boolean;');
  CL.AddDelphiFunction('Function CreateCompatibleDC( DC : HDC) : HDC');
 CL.AddDelphiFunction('Function ReleaseDC(hdwnd: HWND; hdc: HDC): integer;');
// CL.AddDelphiFunction('Function BitBlt( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc : Integer; Rop : DWORD) : BOOL');
  CL.AddDelphiFunction('Function BitBlt( DestDC : HDC; X, Y, Width, Height : Integer; SrcDC : HDC; XSrc, YSrc : Integer; Rop : DWORD) : BOOLEAN');
 CL.AddDelphiFunction('Function Arc( hDC : HDC; left, top, right, bottom, startX, startY, endX, endY : Integer) : BOOLEAN');
 CL.AddDelphiFunction('Function AddFontResource( FileName : PChar) : Integer');
CL.AddDelphiFunction('Function GetSystemMetrics( nIndex : Integer) : Integer');
 CL.AddDelphiFunction('Function UpdateWindow( hWnd : HWND) : BOOLEAN');
 CL.AddDelphiFunction('Function SetActiveWindow( hWnd : HWND) : HWND');
 CL.AddDelphiFunction('Function GetForegroundWindow : HWND');
 CL.AddDelphiFunction('Function PaintDesktop( hdc : HDC) : BOOLEAN');
 CL.AddDelphiFunction('Function SetForegroundWindow( hWnd : HWND) : BOOLEAN');
 CL.AddDelphiFunction('Function WindowFromDC( hDC : HDC) : HWND');
 CL.AddDelphiFunction('Function GetDC( hWnd : HWND) : HDC');
 CL.AddDelphiFunction('Function GetDCEx( hWnd : HWND; hrgnClip : HRGN; flags : DWORD) : HDC');
 CL.AddDelphiFunction('Function DefineHandleTable( Offset : Word) : BOOLEAN');
 CL.AddDelphiFunction('Procedure LimitEmsPages( Kbytes : Longint)');
 CL.AddDelphiFunction('Function SetSwapAreaSize( Size : Word) : Longint');
 CL.AddDelphiFunction('Procedure LockSegment( Segment : THandle)');
 CL.AddDelphiFunction('Procedure UnlockSegment( Segment : THandle)');
 CL.AddDelphiFunction('Function GetCurrentTime : DWORD');
 CL.AddDelphiFunction('Function Yield : BOOLEAN');
 CL.AddDelphiFunction('Function GetShortPathName(lpszLongPath: PChar; lpszShortPath: PChar; cchBuffer: DWORD): DWORD');
 CL.AddDelphiFunction('Function GetVersion : DWORD');
  //procedure Exclude(var S: set of T; I: T);
   //getwindowdc  //getwindowrect(
 CL.AddConstantN('CPUi386','LongInt').SetInt( 2);        //3.7
 CL.AddConstantN('CPUi486','LongInt').SetInt( 3);
 CL.AddConstantN('CPUPentium','LongInt').SetInt( 4);
 //type
//(*$NODEFINE TTextLineBreakStyle*)
 CL.AddTypeS('TTextLineBreakStyle' ,'(tlbsLF, tlbsCRLF)');
 CL.AddDelphiFunction('Function GetWindowDC(hdwnd: HWND): HDC;');
 CL.AddDelphiFunction('Function GetWindowRect(hwnd: HWND; arect: TRect): Boolean');
 CL.AddDelphiFunction('Function BoolToStr1(value : boolean) : string;');
 CL.AddDelphiFunction('Procedure SetLineBreakStyle( var T : Text; Style : TTextLineBreakStyle)');
 CL.AddDelphiFunction('Procedure Set8087CW( NewCW : Word)');
 CL.AddDelphiFunction('Function Get8087CW : Word');
// CL.AddDelphiFunction('Function WideCharToString( Source : PWideChar) : string');
// CL.AddDelphiFunction('Function WideCharLenToString( Source : PWideChar; SourceLen : Integer) : string');
// CL.AddDelphiFunction('Procedure WideCharToStrVar( Source : PWideChar; var Dest : string)');
// CL.AddDelphiFunction('Procedure WideCharLenToStrVar( Source : PWideChar; SourceLen : Integer; var Dest : string)');
// CL.AddDelphiFunction('Function StringToWideChar( const Source : string; Dest : PWideChar; DestSize : Integer) : PWideChar');
 CL.AddDelphiFunction('Function ShowOwnedPopups( hWnd : HWND; fShow : BOOL) : BOOL');
 CL.AddDelphiFunction('Function OpenIcon( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function CloseWindow( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function MoveWindow( hWnd : HWND; X, Y, nWidth, nHeight : Integer; bRepaint : BOOL) : BOOL');
 CL.AddDelphiFunction('Function SetWindowPos( hWnd : HWND; hWndInsertAfter : HWND; X, Y, cx, cy : Integer; uFlags : UINT) : BOOL');
  CL.AddDelphiFunction('Function IsWindowVisible( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function IsIconic( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function AnyPopup : BOOL');
 CL.AddDelphiFunction('Function BringWindowToTop( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function IsZoomed( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function IsWindow( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function IsMenu( hMenu : HMENU) : BOOL');
 CL.AddDelphiFunction('Function IsChild( hWndParent, hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function DestroyWindow( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function ShowWindow( hWnd : HWND; nCmdShow : Integer) : BOOL');
 CL.AddDelphiFunction('Function AnimateWindow( hWnd : HWND; dwTime : DWORD; dwFlags : DWORD) : BOOL');
 CL.AddDelphiFunction('Function ShowWindowAsync( hWnd : HWND; nCmdShow : Integer) : BOOL');
 CL.AddDelphiFunction('Function FlashWindow( hWnd : HWND; bInvert : BOOL) : BOOL');
 CL.AddDelphiFunction('Function IsWindowUnicode( hWnd : HWND) : BOOL');
 CL.AddDelphiFunction('Function EnableWindow( hWnd : HWND; bEnable : BOOL) : BOOL');
 CL.AddDelphiFunction('Function IsWindowEnabled( hWnd : HWND) : BOOL');

  CL.AddTypeS('UTF8String','String;');
  CL.AddTypeS('UCS4Char', 'LongWord;');
  CL.AddTypeS('UCS4String', 'array of UCS4Char;');
  CL.AddTypeS('IntegerArray','array[0..$effffff] of Integer;');
  CL.AddTypeS('marrastr','array of string;');
  //UCS4Char = type LongWord;
  //UCS4String = array of UCS4Char;

 //CL.AddDelphiFunction('Function PUCS4Chars( const S : UCS4String) : PUCS4Char');
 CL.AddDelphiFunction('Function WideStringToUCS4String( const S : WideString) : UCS4String');
 CL.AddDelphiFunction('Function UCS4StringToWideString( const S : UCS4String) : WideString');
 //CL.AddDelphiFunction('Function UnicodeToUtf8( Dest : PChar; Source : PWideChar; MaxBytes : Integer) : Integer;');
 //CL.AddDelphiFunction('Function Utf8ToUnicode( Dest : PWideChar; Source : PChar; MaxChars : Integer) : Integer;');
 //CL.AddDelphiFunction('Function UnicodeToUtf8( Dest : PChar; MaxDestBytes : Cardinal; Source : PWideChar; SourceChars : Cardinal) : Cardinal;');
 //CL.AddDelphiFunction('Function Utf8ToUnicode( Dest : PWideChar; MaxDestChars : Cardinal; Source : PChar; SourceBytes : Cardinal) : Cardinal;');
 CL.AddDelphiFunction('Function UTF8Encode( const WS : WideString) : UTF8String');
 CL.AddDelphiFunction('Function UTF8Decode( const S : UTF8String) : WideString');
 CL.AddDelphiFunction('Function AnsiToUtf8( const S : string) : UTF8String');
 CL.AddDelphiFunction('Function Utf8ToAnsi( const S : UTF8String) : string');
 //CL.AddDelphiFunction('Function OleStrToString( Source : PWideChar) : string');
 //CL.AddDelphiFunction('Procedure OleStrToStrVar( Source : PWideChar; var Dest : string)');
 //CL.AddDelphiFunction('Function StringToOleStr( const Source : string) : PWideChar');
  CL.AddTypeS('TRuntimeError', '( reNone, reOutOfMemory, reInvalidPtr, reDivByZ'
   +'ero, reRangeError, reIntOverflow, reInvalidOp, reZeroDivide, reOverflow, r'
   +'eUnderflow, reInvalidCast, reAccessViolation, rePrivInstruction, reControl'
   +'Break, reStackOverflow, reVarTypeCast, reVarInvalidOp, reVarDispatch, reVa'
   +'rArrayCreate, reVarNotArray, reVarArrayBounds, reAssertionFailed, reExtern'
   +'alException, reIntfCastError, reSafeCallError )');
 //CL.AddDelphiFunction('Procedure BlockOSExceptions');
 //CL.AddDelphiFunction('Procedure UnblockOSExceptions');
 //CL.AddDelphiFunction('Function AreOSExceptionsBlocked : Boolean');
 //CL.AddDelphiFunction('Function ModuleCacheID : Cardinal');
 //CL.AddDelphiFunction('Procedure InvalidateModuleCache');
 CL.AddDelphiFunction('Procedure SetMultiByteConversionCodePage( CodePage : Integer)');
 CL.AddDelphiFunction('Function _CheckAutoResult( ResultCode : HResult) : HResult');
 CL.AddDelphiFunction('Procedure FPower10');
 CL.AddDelphiFunction('Procedure TextStart');
 CL.AddDelphiFunction('Function CompToDouble( Value : Comp) : Double');
 CL.AddDelphiFunction('Procedure DoubleToComp( Value : Double; var Result : Comp)');
 CL.AddDelphiFunction('Function CompToCurrency( Value : Comp) : Currency');
 CL.AddDelphiFunction('Procedure CurrencyToComp( Value : Currency; var Result : Comp)');
 //CL.AddDelphiFunction('Function StringOfChar1( ch : AnsiChar; Count : Integer) : AnsiString;');
 CL.AddDelphiFunction('Function StringOfChar2( ch : WideChar; Count : Integer) : WideString;');
 CL.AddDelphiFunction('Function AttemptToUseSharedMemoryManager : Boolean');
 CL.AddDelphiFunction('Function ShareMemoryManager : Boolean');
 CL.AddDelphiFunction('Function FindResource( ModuleHandle : HMODULE; ResourceName, ResourceType : PChar) : TResourceHandle');
 CL.AddDelphiFunction('Function LoadResource( ModuleHandle : HMODULE; ResHandle : TResourceHandle) : HGLOBAL');
 CL.AddDelphiFunction('Function SizeofResource( ModuleHandle : HMODULE; ResHandle : TResourceHandle) : Integer');
 CL.AddDelphiFunction('Function LockResource( ResData : HGLOBAL) : ___Pointer');
 CL.AddDelphiFunction('Function UnlockResource( ResData : HGLOBAL) : LongBool');
 CL.AddDelphiFunction('Function FreeResource( ResData : HGLOBAL) : LongBool');
 // from controls
 CL.AddDelphiFunction('function SendAppMessage(Msg: Cardinal; WParam, LParam: Longint): Longint');
 CL.AddDelphiFunction('procedure MoveWindowOrg(DC: HDC; DX, DY: Integer);');
 CL.AddDelphiFunction('function IsDragObject(Sender: TObject): Boolean;');
 CL.AddDelphiFunction('function IsVCLControl(Handle: HWnd): Boolean;');
 CL.AddDelphiFunction('function FindControl(Handle: HWnd): TWinControl;');
 CL.AddDelphiFunction('function FindVCLWindow(const Pos: TPoint): TWinControl;');
 CL.AddDelphiFunction('function FindDragTarget(const Pos: TPoint; AllowDisabled: Boolean): TControl;');
 CL.AddDelphiFunction('function GetCaptureControl: TControl;');
 CL.AddDelphiFunction('procedure SetCaptureControl(Control: TControl);');
 CL.AddDelphiFunction('procedure CancelDrag;');
 CL.AddDelphiFunction('function CursorToString(Cursor: TCursor): string;');
 CL.AddDelphiFunction('function StringToCursor(const S: string): TCursor;');
 //CL.AddDelphiFunction('procedure GetCursorValues(Proc: TGetStrProc);');
 CL.AddDelphiFunction('function CursorToIdent(Cursor: Longint; var Ident: string): Boolean;');
 CL.AddDelphiFunction('function IdentToCursor(const Ident: string; var Cursor: Longint): Boolean;');
 CL.AddDelphiFunction('Procedure PerformEraseBackground(Control: TControl; DC: HDC);');
 CL.AddDelphiFunction('procedure ChangeBiDiModeAlignment(var Alignment: TAlignment);');
 //CL.AddDelphiFunction('Function SendMessageTimeout( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM; fuFlags, uTimeout : UINT; var lpdwResult : DWORD) : LRESULT');
 //CL.AddDelphiFunction('Function SendMessageCallback( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM; lpResultCallBack : TFNSendAsyncProc; dwData : DWORD) : BOOL');
 CL.AddDelphiFunction('Function SendMessage( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('function SendMessage2(hWnd: HWND; Msg: longword; wParam: pchar; lParam: pchar): Boolean;');
 //CL.AddDelphiFunction('function PostMessage(hWnd: HWND; Msg: longword; wParam: longint; lParam: longint): Boolean;');
 CL.AddDelphiFunction('Function PostMessage( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : BOOLEAN');
 CL.AddDelphiFunction('procedure FloatToDecimal(var Result: TFloatRec; const Value: extended; ValueType: TFloatValue; Precision, Decimals: Integer);');
 CL.AddDelphiFunction('function queryPerformanceCounter2(mse: int64): int64;');
 CL.AddDelphiFunction('function QueryPerformanceFrequency(var lfreq: int64): boolean; stdcall;');
 //CL.AddDelphiFunction('function QueryPerformanceCounter(var lcount: Int64): LongBool; stdcall;');
 CL.AddDelphiFunction('function QueryPerformanceCounter(var lcount: Int64): Boolean; stdcall;');
 CL.AddDelphiFunction('procedure QueryPerformanceCounter1(var aC: Int64);');
 CL.AddDelphiFunction('function QueryPerformanceFrequency1(var freq: int64): boolean;');
 {CL.AddDelphiFunction('Function OpenProcessToken( ProcessHandle : THandle; DesiredAccess : DWORD; var TokenHandle : THandle) : BOOL');
 CL.AddDelphiFunction('Function OpenThreadToken( ThreadHandle : THandle; DesiredAccess : DWORD; OpenAsSelf : BOOL; var TokenHandle : THandle) : BOOL');
 CL.AddDelphiFunction('Function PrivilegeCheck( ClientToken : THandle; const RequiredPrivileges : TPrivilegeSet; var pfResult : BOOL) : BOOL');
 CL.AddDelphiFunction('Procedure SetFileApisToOEM');
 CL.AddDelphiFunction('Procedure SetFileApisToANSI');
 CL.AddDelphiFunction('Function AreFileApisANSI : BOOL');
 CL.AddDelphiFunction('Function RevertToSelf : BOOL');}
 //CL.AddDelphiFunction('Function QueryPerformanceCounter( var lpPerformanceCount : TLargeInteger) : BOOLEAN');
 CL.AddDelphiFunction('function IsAssembly(const FileName: string): Boolean;');
 CL.AddDelphiFunction('function GetModuleFileName(Module: Integer; Filename: PChar;Size: Integer): Integer; stdcall;');
 CL.AddDelphiFunction('function GetCommandLine: PChar; stdcall;');
 CL.AddDelphiFunction('procedure ExitThread(ExitCode: Integer); stdcall;');
 CL.AddDelphiFunction('procedure ExitProcess(ExitCode: Integer); stdcall;');
 CL.AddDelphiFunction('function CharNext(lpsz: PChar): PChar; stdcall;');
 CL.AddDelphiFunction('procedure RaiseException2;');
 CL.AddDelphiFunction('function GetFileSize2(Handle: Integer; x: Integer): Integer; stdcall;');
 //CL.AddDelphiFunction('procedure GetSystemTime;');
 CL.AddDelphiFunction('Procedure GetSystemTime( var lpSystemTime : TSystemTime)');
 CL.AddDelphiFunction('Procedure GetSystemTimeAsFileTime(var lpSystemTimeAsFileTime : TFileTime)');
 CL.AddDelphiFunction('Function SetSystemTime( const lpSystemTime : TSystemTime) : BOOLEAN');
 CL.AddDelphiFunction('Procedure GetLocalTime( var lpSystemTime : TSystemTime)');
 CL.AddDelphiFunction('Function SetLocalTime( const lpSystemTime : TSystemTime) : BOOLEAN');
 CL.AddDelphiFunction('Function SetFileAttributes( lpFileName : PChar; dwFileAttributes : DWORD) : BOOLEAN');
 CL.AddDelphiFunction('Function GetFileAttributes( lpFileName : PChar) : DWORD');
 CL.AddDelphiFunction('Function GetFileInformationByHandle( hFile : THandle; var lpFileInformation : TByHandleFileInformation) : BOOLEAN');
 CL.AddDelphiFunction('Function GetFileType( hFile : THandle) : DWORD');
 CL.AddTypeS('va_list', 'PChar');
 CL.AddDelphiFunction('Function wvsprintf( Output : PChar; Format : PChar; arglist : va_list) : Integer');
 CL.AddDelphiFunction('Function wsprintf( Output : PChar; Format : PChar) : Integer');

  //  CL.AddTypeS('TSystemInfo', '_SYSTEM_INFO');
 // CL.AddTypeS('SYSTEM_INFO', '_SYSTEM_INFO');
 //CL.AddDelphiFunction('Procedure GetSystemInfo( var lpSystemInfo : TSystemInfo)');
 CL.AddDelphiFunction('Function IsProcessorFeaturePresent(ProcessorFeature: DWORD) : BOOLEAN');
 CL.AddDelphiFunction('function CloseHandle(Handle: Integer): Integer; stdcall;');
 CL.AddDelphiFunction('function GetStdHandle(nStdHandle: Integer): Integer; stdcall;');
 CL.AddDelphiFunction('procedure RtlUnwind; stdcall;');
 CL.AddDelphiFunction('function SetEndOfFile(Handle: Integer): LongBool; stdcall;');
 CL.AddDelphiFunction('function FindCloseW(FindFile: THandle): LongBool; stdcall;');
 CL.AddDelphiFunction('function LoadLibraryEx(LibName: PChar; hFile: Longint; Flags: Longint): Longint; stdcall;');
 CL.AddDelphiFunction('function LoadString(Instance: Longint; IDent: Integer; Buffer: PChar;'+
                          'Size: Integer): Integer; stdcall;)');
 CL.AddDelphiFunction('procedure SysFreeString(const S: WideString); stdcall;');
 CL.AddDelphiFunction('function SysStringLen(const S: WideString): Integer; stdcall;');
 CL.AddDelphiFunction('function RemoveDirectory(PathName: PChar): WordBool; stdcall;');
 CL.AddDelphiFunction('function SetCurrentDirectory(PathName: PChar): WordBool; stdcall;');
 //CL.AddDelphiFunction('function GetSysColor(nIndex: Integer): DWORD; stdcall;');
 CL.AddDelphiFunction('function IsVariantManagerSet: Boolean;'); //deprecated;

 // from forms
 CL.AddDelphiFunction('function KeysToShiftState(Keys: Word): TShiftState;');
 CL.AddDelphiFunction('function KeyDataToShiftState(KeyData: Longint): TShiftState;');
 CL.AddDelphiFunction('function KeyboardStateToShiftState2(const KeyboardState: TKeyboardState): TShiftState;');
 CL.AddDelphiFunction('function KeyboardStateToShiftState: TShiftState; overload;');

 //function LoadLibraryEx(LibName: PChar; hFile: Longint; Flags: Longint): Longint; stdcall;
  //external kernel name 'LoadLibraryExA';
 { function CreateThread(SecurityAttributes: Pointer; StackSize: LongWord;
                     ThreadFunc: TThreadFunc; Parameter: Pointer;
                     CreationFlags: LongWord; var ThreadId: LongWord): Integer; stdcall;
  external kernel name 'CreateThread';}
 CL.AddTypeS('TFarProc', '___Pointer');
 CL.AddTypeS('TFNThreadStartRoutine', 'TFarProc');
 CL.AddTypeS('TFNTopLevelExceptionFilter', 'TFarProc');
 CL.AddTypeS('_CONTEXT', 'record ContextFlags : DWORD; Dr0 : DWORD; Dr1 : DWOR'
   +'D; Dr2 : DWORD; Dr3 : DWORD; Dr6 : DWORD; Dr7 : DWORD; FloatSave : TFloati'
   +'ngSaveArea; SegGs : DWORD; SegFs : DWORD; SegEs : DWORD; SegDs : DWORD; Ed'
   +'i : DWORD; Esi : DWORD; Ebx : DWORD; Edx : DWORD; Ecx : DWORD; Eax : DWORD'
   +'; Ebp : DWORD; Eip : DWORD; SegCs : DWORD; EFlags : DWORD; Esp : DWORD; SegSs : DWORD; end');
  CL.AddTypeS('TContext', '_CONTEXT');
  CL.AddTypeS('CONTEXT', '_CONTEXT');
  CL.AddDelphiFunction('Function CreateThread(lpThreadAttributes: ___Pointer; dwStackSize: DWORD; lpStartAddress : TFNThreadStartRoutine;'+
   'lpParameter:___Pointer; dwCreationFlags: DWORD; var lpThreadId: DWORD) : THandle');
 CL.AddDelphiFunction('function CreateThread1(ThreadAttrib: dword; stack: dword;'+
        'ThreadFunc: TFarProc; parameter: integer; flags: dword; thrid: DWord):THandle');

 CL.AddDelphiFunction('Function CreateThread2(ThreadFunc: TThreadFunction2; thrid: DWord) : THandle');
 CL.AddDelphiFunction('Function GetCurrentThread : THandle');
 CL.AddDelphiFunction('Procedure ExitThread( dwExitCode : DWORD)');
 CL.AddDelphiFunction('Function TerminateThread( hThread : THandle; dwExitCode : DWORD) : BOOLEAN');
 CL.AddDelphiFunction('Function GetExitCodeThread( hThread : THandle; var lpExitCode : DWORD) : BOOLEAN');
 CL.AddDelphiFunction('procedure EndThread(ExitCode: Integer);');
 CL.AddDelphiFunction('Function WaitForSingleObject( hHandle : THandle; dwMilliseconds : DWORD) : DWORD');
 CL.AddDelphiFunction('Function MakeProcInstance( Proc : FARPROC; Instance : THandle) : FARPROC');
 CL.AddDelphiFunction('Procedure FreeProcInstance( Proc : FARPROC)');
 CL.AddDelphiFunction('Function AddAtom( lpString : PChar) : ATOM');
 CL.AddDelphiFunction('Function FindAtom( lpString : PChar) : ATOM');
 CL.AddDelphiFunction('Function Succeeded( Status : HRESULT) : BOOLEAN');
 CL.AddDelphiFunction('Function Failed( Status : HRESULT) : BOOLEAN');
 CL.AddDelphiFunction('Function IsError( Status : HRESULT) : BOOLEAN');
 CL.AddDelphiFunction('Function SmallPointToPoint( const P : TSmallPoint) : TPoint');
 CL.AddDelphiFunction('Function PointToSmallPoint( const P : TPoint) : TSmallPoint');
 CL.AddDelphiFunction('Function MakeWParam( l, h : Word) : WPARAM');
 CL.AddDelphiFunction('Function MakeLParam( l, h : Word) : LPARAM');
 CL.AddDelphiFunction('Function MakeLResult( l, h : Word) : LRESULT');
 CL.AddDelphiFunction('Function PointToLParam( P : TPoint) : LPARAM');
 CL.AddDelphiFunction('Function WaitMessage : BOOLEAN');
 CL.AddDelphiFunction('Function WaitForInputIdle( hProcess : THandle; dwMilliseconds : DWORD) : DWORD');
 CL.AddDelphiFunction('Function DefWindowProc( hWnd : HWND; Msg : UINT; wParam : WPARAM; lParam : LPARAM) : LRESULT');
 CL.AddDelphiFunction('Procedure InitializeCriticalSection( var lpCriticalSection : TRTLCriticalSection)');
 CL.AddDelphiFunction('Procedure EnterCriticalSection( var lpCriticalSection : TRTLCriticalSection)');
 CL.AddDelphiFunction('Procedure LeaveCriticalSection( var lpCriticalSection : TRTLCriticalSection)');
 CL.AddDelphiFunction('Function InitializeCriticalSectionAndSpinCount( var lpCriticalSection : TRTLCriticalSection; dwSpinCount : DWORD) : BOOLEAN');
 CL.AddDelphiFunction('Function SetCriticalSectionSpinCount( var lpCriticalSection : TRTLCriticalSection; dwSpinCount : DWORD) : DWORD');
 CL.AddDelphiFunction('Function TryEnterCriticalSection( var lpCriticalSection : TRTLCriticalSection) : BOOLEAN');
 CL.AddDelphiFunction('Procedure DeleteCriticalSection( var lpCriticalSection : TRTLCriticalSection)');
 CL.AddDelphiFunction('Function GetThreadContext( hThread : THandle; var lpContext : TContext) : BOOLEAN');
 CL.AddDelphiFunction('Function SetThreadContext( hThread : THandle; const lpContext : TContext) : BOOLEAN');
 CL.AddDelphiFunction('Function SuspendThread( hThread : THandle) : DWORD');
 CL.AddDelphiFunction('Function ResumeThread( hThread : THandle) : DWORD');
 CL.AddDelphiFunction('Function CancelDC( DC : HDC) : BOOLEAN');
 CL.AddDelphiFunction('Function Chord( DC : HDC; X1, Y1, X2, Y2, X3, Y3, X4, Y4 : Integer) : BOOLEAN');
 //CL.AddDelphiFunction('Function ChoosePixelFormat( DC : HDC; p2 : PPixelFormatDescriptor) : Integer');
 CL.AddDelphiFunction('Function CloseMetaFile( DC : HDC) : HMETAFILE');
 CL.AddDelphiFunction('Function CombineRgn( p1, p2, p3 : HRGN; p4 : Integer) : Integer');
 CL.AddDelphiFunction('Function CopyMetaFile( p1 : HMETAFILE; p2 : PChar) : HMETAFILE');
 //CL.AddDelphiFunction('Function CopyMetaFileA( p1 : HMETAFILE; p2 : PAnsiChar) : HMETAFILE');
 //CL.AddDelphiFunction('Function CopyMetaFileW( p1 : HMETAFILE; p2 : PWideChar) : HMETAFILE');
 CL.AddDelphiFunction('Function CreateBitmap( Width, Height : Integer; Planes, BitCount : Longint; Bits : ___Pointer) : HBITMAP');
 CL.AddDelphiFunction('Function CreateBitmapIndirect( const p1 : TBitmap) : HBITMAP');
// CL.AddDelphiFunction('Function CreateBrushIndirect( const p1 : TLogBrush) : HBRUSH');
 CL.AddDelphiFunction('Function CreateCompatibleBitmap( DC : HDC; Width, Height : Integer) : HBITMAP');
 CL.AddDelphiFunction('Function CreateDiscardableBitmap( DC : HDC; p2, p3 : Integer) : HBITMAP');
 CL.AddDelphiFunction('Function CreateCompatibleDC( DC : HDC) : HDC');
 //CL.AddDelphiFunction('Function CreateDC( lpszDriver, lpszDevice, lpszOutput : PChar; lpdvmInit : PDeviceMode) : HDC');
  CL.AddDelphiFunction('Function RoundRectA( DC : HDC; X1, Y1, X2, Y2, X3, Y3 : Integer) : BOOLEAN');
 CL.AddDelphiFunction('Function ResizePalette( Palette : HPALETTE; Entries : UINT) : BOOLEAN');
 CL.AddDelphiFunction('Function SaveDC( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function SelectClipRgn( DC : HDC; Region : HRGN) : Integer');
 CL.AddDelphiFunction('Function ExtSelectClipRgn( DC : HDC; Region : HRGN; Mode : Integer) : Integer');
 CL.AddDelphiFunction('Function SetMetaRgn( DC : HDC) : Integer');
 CL.AddDelphiFunction('Function SelectObject( DC : HDC; p2 : HGDIOBJ) : HGDIOBJ');
 CL.AddDelphiFunction('Function SelectPalette( DC : HDC; Palette : HPALETTE; ForceBackground : BOOLEAN) : HPALETTE');
 CL.AddDelphiFunction('Function SetBkColor( DC : HDC; Color : COLORREF) : COLORREF');
 CL.AddDelphiFunction('Function SetDCBrushColor( DC : HDC; Color : COLORREF) : COLORREF');
 CL.AddDelphiFunction('Function SetDCPenColor( DC : HDC; Color : COLORREF) : COLORREF');
 CL.AddDelphiFunction('Function SetBkMode( DC : HDC; BkMode : Integer) : Integer');
 CL.AddDelphiFunction('Function SetBitmapBits( p1 : HBITMAP; p2 : DWORD; bits : ___Pointer) : Longint');
 CL.AddDelphiFunction('Function CreateRectRgn( p1, p2, p3, p4 : Integer) : HRGN');
 CL.AddDelphiFunction('Function CreateRectRgnIndirect( const p1 : TRect) : HRGN');
 CL.AddDelphiFunction('Function CreateRoundRectRgn( p1, p2, p3, p4, p5, p6 : Integer) : HRGN');
 CL.AddDelphiFunction('Function GetUpdateRect( hWnd : HWND; var lpRect : TRect; bErase : BOOLEAN) : BOOLEAN;');
 //CL.AddDelphiFunction('Function GetUpdateRect( hWnd : HWND; lpRect : PRect; bErase : BOOLEAN) : BOOLEAN;');
 CL.AddDelphiFunction('Function GetUpdateRgn( hWnd : HWND; hRgn : HRGN; bErase : BOOLEAN) : Integer');
 CL.AddDelphiFunction('Function SetWindowRgn( hWnd : HWND; hRgn : HRGN; bRedraw : BOOL) : Integer');
 CL.AddDelphiFunction('Function GetWindowRgn( hWnd : HWND; hRgn : HRGN) : Integer');
 CL.AddDelphiFunction('Function ExcludeUpdateRgn( hDC : HDC; hWnd : HWND) : Integer');
 //CL.AddDelphiFunction('Function InvalidateRect( hWnd : HWND; lpRect : PRect; bErase : BOOL) : BOOL');
 //CL.AddDelphiFunction('Function ValidateRect( hWnd : HWND; lpRect : PRect) : BOOL');
 CL.AddDelphiFunction('Function InvalidateRgn( hWnd : HWND; hRgn : HRGN; bErase : BOOL) : BOOLEAN');
 CL.AddDelphiFunction('Function ValidateRgn( hWnd : HWND; hRgn : HRGN) : BOOLEAN');
 //  cm_copymode
 //CL.AddDelphiFunction('Function ValidateRect( hWnd : HWND; lpRect : PRect) : BOOL');
 //CL.AddDelphiFunction('Function RedrawWindow( hWnd : HWND; lprcUpdate : PRect; hrgnUpdate : HRGN; flags : UINT) : BOOL');
 CL.AddDelphiFunction('Function SetFocus( hWnd : HWND) : HWND');
 CL.AddDelphiFunction('Function GetActiveWindow : HWND');
 CL.AddDelphiFunction('Function GetFocus : HWND');
 CL.AddDelphiFunction('Function GetKBCodePage : UINT');
 CL.AddDelphiFunction('Function GetKeyState( nVirtKey : Integer) : SHORT');
 CL.AddDelphiFunction('Function GetAsyncKeyState( vKey : Integer) : SHORT');
 CL.AddDelphiFunction('Function GetKeyboardState( var KeyState : TKeyboardState) : BOOL');
 CL.AddDelphiFunction('Function SetKeyboardState( var KeyState : TKeyboardState) : BOOL');
  CL.AddTypeS('tagKERNINGPAIR', 'record wFirst : Word; wSecond : Word; iKernAmount : Integer; end');
  CL.AddTypeS('TKerningPair', 'tagKERNINGPAIR');
  CL.AddTypeS('KERNINGPAIR', 'tagKERNINGPAIR');
 //CL.AddDelphiFunction('Function GetKerningPairs( DC : HDC; Count : DWORD; var KerningPairs) : DWORD');
 CL.AddDelphiFunction('Function GetDCOrgEx( DC : HDC; var Origin : TPoint) : BOOLEAN');
 CL.AddDelphiFunction('Function UnrealizeObject( hGDIObj : HGDIOBJ) : BOOLEAN');
 CL.AddDelphiFunction('Function GdiFlush : BOOLEAN');
 CL.AddDelphiFunction('Function GdiSetBatchLimit( Limit : DWORD) : DWORD');
 CL.AddDelphiFunction('Function GdiGetBatchLimit : DWORD');
 CL.AddDelphiFunction('Function WNetAddConnection( lpRemoteName, lpPassword, lpLocalName : PChar) : DWORD');
 CL.AddDelphiFunction('procedure mxButton(x,y,w,h,t,l,ahandle: integer);');
 CL.AddDelphiFunction('Function GetWindowText( hWnd : HWND; lpString : PChar; nMaxCount : Integer) : Integer');
 CL.AddDelphiFunction('Function SleepEx( dwMilliseconds : DWORD; bAlertable : BOOLEAN) : DWORD');
 // CL.AddDelphiFunction('Function RedrawWindow( hWnd : HWND; lprcUpdate : PRect; hrgnUpdate : HRGN; flags : UINT) : BOOLEAN');
 //CL.AddDelphiFunction('Function ValidateRect( hWnd : HWND; lpRect : PRect) : BOOLEAN');
 //CL.AddDelphiFunction('Function InvalidateRgn( hWnd : HWND; hRgn : HRGN; bErase : BOOLEAN) : BOOLEAN');
 //CL.AddDelphiFunction('Function ValidateRgn( hWnd : HWND; hRgn : HRGN) : BOOLEAN');

 CL.AddDelphiFunction('Function TryStrToInt( const S : AnsiString; var I : Integer) : Boolean');
 CL.AddDelphiFunction('Function TryStrToInt64( const S : AnsiString; var I : Int64) : Boolean');
 CL.AddDelphiFunction('Function GetMessage( var lpMsg : TMsg; hWnd : HWND; wMsgFilterMin, wMsgFilterMax : UINT) : BOOLEAN');
 CL.AddDelphiFunction('Function DispatchMessage( const lpMsg : TMsg) : Longint');
 CL.AddDelphiFunction('Function TranslateMessage( const lpMsg : TMsg) : BOOLEAN');
 CL.AddDelphiFunction('Function SetMessageQueue( cMessagesMax : Integer) : BOOLEAN');
 CL.AddDelphiFunction('Function PeekMessage( var lpMsg : TMsg; hWnd : HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg : UINT) : BOOLEAN');
 CL.AddDelphiFunction('Function GetMessagePos : DWORD');
 CL.AddDelphiFunction('Function GetMessageTime : Longint');
 CL.AddDelphiFunction('Function GetMessageExtraInfo : Longint');
 CL.AddDelphiFunction('Function ExitWindows( dwReserved : DWORD; Code : Word) : BOOLEAN');
 CL.AddDelphiFunction('Function ExitWindowsEx( uFlags : UINT; dwReserved : DWORD) : BOOLEAN');
 CL.AddDelphiFunction('Function SwapMouseButton( fSwap : BOOLEAN) : BOOLEAN');
 //CL.AddDelphiFunction('Function GetMessagePos : DWORD');
 //CL.AddDelphiFunction('Function GetMessageTime : Longint');
 //CL.AddDelphiFunction('Function GetMessageExtraInfo : Longint');
 CL.AddDelphiFunction('Function SetMessageExtraInfo( lParam : LPARAM) : LPARAM');
 CL.AddDelphiFunction('Function GetRValue( rgb : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetGValue( rgb : DWORD) : Byte');
 CL.AddDelphiFunction('Function GetBValue( rgb : DWORD) : Byte');
 CL.AddDelphiFunction('Function PaletteRGB( r, g, b : Byte) : COLORREF');
 CL.AddDelphiFunction('Function PaletteIndex( i : Word) : COLORREF');
 CL.AddDelphiFunction('Function GetCValue( cmyk : COLORREF) : Byte');
 CL.AddDelphiFunction('Function GetMValue( cmyk : COLORREF) : Byte');
 CL.AddDelphiFunction('Function GetYValue( cmyk : COLORREF) : Byte');
 CL.AddDelphiFunction('Function GetKValue( cmyk : COLORREF) : Byte');
 CL.AddDelphiFunction('Function CMYK( c, m, y, k : Byte) : COLORREF');
 CL.AddDelphiFunction('Function MessageBeep( uType : UINT) : BOOLEAN');
 CL.AddDelphiFunction('Function ShowCursor( bShow : BOOLEAN) : Integer');
 CL.AddDelphiFunction('Function SetCursorPos( X, Y : Integer) : BOOLEAN');
 CL.AddDelphiFunction('Function SetCursor( hCursor : HICON) : HCURSOR');
 CL.AddDelphiFunction('Function GetCursorPos( var lpPoint : TPoint) : BOOLEAN');
 //CL.AddDelphiFunction('Function ClipCursor( lpRect : PRect) : BOOLEAN');
 CL.AddDelphiFunction('Function GetClipCursor( var lpRect : TRect) : BOOLEAN');
 CL.AddDelphiFunction('Function GetCursor : HCURSOR');
 CL.AddDelphiFunction('Function CreateCaret( hWnd : HWND; hBitmap : HBITMAP; nWidth, nHeight : Integer) : BOOLEAN');
 CL.AddDelphiFunction('Function GetCaretBlinkTime : UINT');
 CL.AddDelphiFunction('Function SetCaretBlinkTime( uMSeconds : UINT) : BOOLEAN');
 CL.AddDelphiFunction('Function DestroyCaret : BOOLEAN');
 CL.AddDelphiFunction('Function HideCaret( hWnd : HWND) : BOOLEAN');
 CL.AddDelphiFunction('Function ShowCaret( hWnd : HWND) : BOOLEAN');
 CL.AddDelphiFunction('Function SetCaretPos( X, Y : Integer) : BOOLEAN');
 CL.AddDelphiFunction('Function GetCaretPos( var lpPoint : TPoint) : BOOLEAN');
 CL.AddDelphiFunction('Function ClientToScreen( hWnd : HWND; var lpPoint : TPoint) : BOOLEAN');
 CL.AddDelphiFunction('Function ScreenToClient( hWnd : HWND; var lpPoint : TPoint) : BOOLEAN');
 CL.AddDelphiFunction('Function MapWindowPoints( hWndFrom, hWndTo : HWND; var lpPoints, cPoints : UINT) : Integer');
 CL.AddDelphiFunction('Function WindowFromPoint( Point : TPoint) : HWND');
 CL.AddDelphiFunction('Function ChildWindowFromPoint( hWndParent : HWND; Point : TPoint) : HWND');
 CL.AddDelphiFunction('Procedure Val(S: string; var V: int64; var code: integer);');
 CL.AddDelphiFunction('Procedure keybd_event( bVk : Byte; bScan : Byte; dwFlags, dwExtraInfo : DWORD)');
 CL.AddDelphiFunction('Function OemKeyScan( wOemChar : Word) : DWORD');
 CL.AddDelphiFunction('Procedure mouse_event( dwFlags, dx, dy, dwData, dwExtraInfo : DWORD)');
 CL.AddDelphiFunction('Function GET_APPCOMMAND_LPARAM( const lParam : LongInt) : Shortint');
 CL.AddDelphiFunction('Function GET_DEVICE_LPARAM( const lParam : LongInt) : Word');
 CL.AddDelphiFunction('Function GET_MOUSEORKEY_LPARAM( const lParam : LongInt) : Word');
 CL.AddDelphiFunction('Function GET_FLAGS_LPARAM( const lParam : LongInt) : Word');
 CL.AddDelphiFunction('Function GET_KEYSTATE_LPARAM( const lParam : LongInt) : Word');
 CL.AddDelphiFunction('function loadForm(vx, vy: smallint): TForm;');
 CL.AddDelphiFunction('procedure paintprocessingstar2(ppform: TForm);');
 CL.AddDelphiFunction('function getForm(vx, vy: smallint): TForm;');

 //  foregroundtask endthread
 //findclasshinstance
//procedure ExitProcess(ExitCode: Integer); stdcall;
  //external kernel name 'ExitProcess';

 {function GetCommandLine: PChar; stdcall;
  external kernel name 'GetCommandLineA';}
 //variant.progidtoclassid

 //SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOLEAN;
 //PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOLEAN;

 //CL.AddDelphiFunction('Procedure DBIError(errorCode: Integer)');
 //CL.AddDelphiFunction('Procedure DBIError(errorCode: Integer)');
 //CL.AddDelphiFunction('Procedure DBIError(errorCode: Integer)');
   //maxintvalue
   end;

(* === run-time registration functions === *)

function EnumStringModules(Instance: Longint; Data: Pointer): Boolean;
{$IFDEF MSWINDOWS}
var
  Buffer: array [0..1023] of char;
begin
  with PStrData(Data)^ do begin
    SetString(Str, Buffer,
      LoadString(Instance, Ident, Buffer, sizeof(Buffer)));
    Result := Str = '';
  end;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  rs: TResStringRec;
  Module: HModule;
begin
  Module := Instance;
  rs.Module := @Module;
  with PStrData(Data)^ do begin
    rs.Identifier := Ident;
    Str := LoadResString(@rs);
    Result := Str = '';
  end;
end;
{$ENDIF}


function FindStringResource(Ident: Integer): string;
var
  StrData: TStrData;
begin
  StrData.Ident := Ident;
  StrData.Str := '';
  EnumResourceModules(EnumStringModules, @StrData);
  Result := StrData.Str;
end;


function SlashSep(const Path, S: String): String;
begin
  if AnsiLastChar(Path)^ <> '\' then
    Result := Path + '\' + S
  else
    Result := Path + S;
end;

procedure myHalt;
begin
  Halt;
end;

procedure myRunError(errorcode: byte);
begin
  system.runerror(errorcode);
end;

//PROTOTYPES for vars of system and sysutils

function myrandSeed: longint;
begin
  result:= system.randSeed;
end;

procedure mySetrandSeed(aset: longint);
begin
  system.randSeed:= aset;
end;

function mycurrencyString: String;
begin
  result:= sysutils.CurrencyString;
end;

function mycurrencyDecimals: Byte;
begin
  result:= sysutils.CurrencyDecimals;
end;

function mycurrencyFormat: Byte;
begin
  result:= sysutils.CurrencyFormat;
end;

procedure mySetcurrencyFormat(aset: Byte);
begin
  sysutils.CurrencyFormat:= aset;
end;

function myListSeparator: Char;
begin
  result:= sysutils.ListSeparator;
end;


function mySysLocale: TSysLocale;
begin
  result:= sysutils.SysLocale;
end;

function mygetwindowrect(hdwnd: HWND; arect: TRect): boolean;
begin
  result:= windows.GetWindowRect(hdwnd, arect);
end;

function myMainInstance: longword;
begin
  result:= system.mainInstance;
end;

function myMainThreadID: longword;
begin
  result:= system.MainThreadID;
end;

function myLeadBytes: TForleadBytes;
begin
  result:= sysutils.LeadBytes;
end;


function myboolstrstrue: marrstr;
begin
  result:= marrstr(sysutils.TrueBoolStrs);
end;

function myboolstrsfalse: marrstr;
begin
  result:= marrstr(sysutils.FalseBoolStrs);
end;

function mylowbyte(myword: word): byte;
begin
//hibyte:=myword shr 8;
  result:=myword and $FF;
end;

procedure myraise;
var a: byte;
begin
  try
    //a div 0;
    //raise;
    writeln(' ');
  except
  //finally
  raise;
  end;
end;

{function myOutput: Text;
begin
  result:= system.Output;
end;

function myInput: Text;
begin
  result:= system.Input;
end;

function myErrOutput: Text;
begin
  result:= system.ErrOutput;
end;}

{function mycmdlineing: String;
begin
  sysutils.CurrencyString;
end;}

{function mycurrencyString: String;
begin
  sysutils.CurrencyString;
end;}

procedure myProcessPath(const EditText: string; var Drive: Char;
  var DirPart: string; var FilePart: string);
begin
  FileCtrl.ProcessPath(EditText, Drive, DirPart, FilePart);
end;


function myEOF: boolean;
begin
  result:= Eof;
end;

function myEOLN: boolean;
begin
  result:= Eoln;
end;


procedure CutFirstDirectory(var S: String);
var
  Root: Boolean;
  P: Integer;
begin
  if S = '\' then
    S := ''
  else begin
    if S[1] = '\' then begin
      Root := True;
      Delete(S, 1, 1);
    end
    else
      Root := False;
    if S[1] = '.' then
      Delete(S, 1, 4);
    P := AnsiPos('\',S);
    if P <> 0 then begin
      Delete(S, 1, P);
      S := '...\' + S;
    end
    else
      S := '';
    if Root then
      S := '\' + S;
  end;
end;

function VolumeID(DriveChar: Char): string;
var
  OldErrorMode: Integer;
  NotUsed, VolFlags: DWORD;
  Buf: array [0..MAX_PATH] of Char;
begin
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    Buf[0] := #$00;
    if GetVolumeInformation(PChar(DriveChar + ':\'), Buf, DWORD(sizeof(Buf)),
      nil, NotUsed, VolFlags, nil, 0) then
      SetString(Result, Buf, StrLen(Buf))
    else Result := '';
    if DriveChar < 'a' then
      Result := AnsiUpperCaseFileName(Result)
    else
      Result := AnsiLowerCaseFileName(Result);
    Result := Format('[%s]',[Result]);
  finally
    SetErrorMode(OldErrorMode);
  end;
end;

function NetworkVolume(DriveChar: Char): string;
var
  Buf: Array [0..MAX_PATH] of Char;
  DriveStr: array [0..3] of Char;
  BufferSize: DWORD;
begin
  BufferSize := sizeof(Buf);
  DriveStr[0] := UpCase(DriveChar);
  DriveStr[1] := ':';
  DriveStr[2] := #0;
  if WNetGetConnection(DriveStr, Buf, BufferSize) = WN_SUCCESS then begin
    SetString(Result, Buf, BufferSize);
    if DriveChar < 'a' then
      Result := AnsiUpperCaseFileName(Result)
    else
      Result := AnsiLowerCaseFileName(Result);
  end
  else
    Result := VolumeID(DriveChar);
end;

function CurrToStr1(Value: Currency): string;
var
  Buffer: array[0..63] of Char;
begin
  //currtostr
  SetString(Result, Buffer, FloatToText(Buffer, Value, fvCurrency,
    ffGeneral, 0, 0));
end;

function getIsConsole: boolean;
begin
 result:= IsConsole;
end;

function getIsLibrary: boolean;
begin
 result:= IsLibrary;
end;

function getIsMultiThread: boolean;
begin
 result:= IsMultiThread;
end;

{function getLongDayNames: TDayNames;
var i: byte;
begin
  for I:= 1 to 7 do
    result[i]:= result[i] + longdaynames[i];
end;}

function getLongDayNames: string;
var i: byte;
begin
  for I:= 1 to 7 do
    result:= result +','+ longdaynames[i];
end;


function getShortDayNames: string;
var i: byte;
begin
  for I:= 1 to 7 do
    result:= result +','+ shortdaynames[i];
end;

function getLongMonthNames: string;
var i: byte;
begin
  for I:= 1 to 12 do
    result:= result +','+ longmonthnames[i];
end;

function getShortMonthNames: string;
var i: byte;
begin
  for I:= 1 to 12 do
    result:= result +','+ shortmonthnames[i];
end;

function getDefaultTextLineBreakStyle: TTextLineBreakStyle;
begin
  result:= DefaultTextLineBreakStyle;
end;

function FileSetDateH(Handle: Integer; Age: Integer): Integer;
begin
  result:= FileSetDate(Handle, Age);
end;

Function FloatToStrFS(Value: Extended; Format : TFloatFormat; Precision,
            Digits : Integer; FormatSettings : TFormatSettings): string;
 begin
   result:= FloatToStrF(Value, format, precision, digits, FormatSettings);
 end;

// Overload Prototypes

function WrapText2(const Line, BreakStr: string; const BreakChars: TSysCharSet;
  MaxCol: Integer): string;
begin
 result:= WrapText(Line, BreakStr, BreakChars, MaxCol);
end;

function WrapText1(const Line: string; MaxCol: Integer): string;
begin
 result:= WrapText(Line, MaxCol);
end;

function FormatFloat2(const Format: string; Value: Extended;
  const FormatSettings: TFormatSettings): string;
begin
   result:= FormatFloat(Format, Value, FormatSettings);

end;

function Format2(const Format: string; const Args: array of const;
  const FormatSettings: TFormatSettings): string;
begin
  result:= SysUtils.Format(Format ,Args, FormatSettings);
end;

function StrToFloat2(const S: string; const FormatSettings: TFormatSettings): Extended;
begin
  result:= StrToFloat(S, FormatSettings);
end;


function StrToCurr2(const S: string; const FormatSettings: TFormatSettings): Currency;
begin
  result:= StrToCurr(S, FormatSettings);
end;

function StrToCurr1(const S: string): Currency;
begin
  result:= StrToCurr(S);
end;

function CurrToStrFS(Value: Currency; Format: TFloatFormat;
  Digits: Integer; const FormatSettings: TFormatSettings): string;
begin
  result:= CurrToStrF(Value, Format, Digits, FormatSettings);
end;

function StrToCurrDef2(const S: string; const Default: Currency;
  const FormatSettings: TFormatSettings): Currency;
begin
  result:= StrToCurrDef(S, Default, FormatSettings);
end;

function DateTimeToStr2(const DateTime: TDateTime;
  const FormatSettings: TFormatSettings): string;
begin
  DateTimeToString(Result, '', DateTime, FormatSettings);
end;

procedure DateTimeToString2(var Result: string; const Format: string;
  DateTime: TDateTime; const FormatSettings: TFormatSettings);
begin
  DateTimeToString(Result, Format, DateTime, FormatSettings);
end;


function FormatDateTime2(const Format: string; DateTime: TDateTime;
  const FormatSettings: TFormatSettings): string;
begin
  DateTimeToString(Result, Format, DateTime, FormatSettings);
  //  DateTimeToString(Result, Format, DateTime, FormatSettings);
end;

function FormatCurr2(const Format: string; Value: Currency;
  const FormatSettings: TFormatSettings): string;
begin
  result:= FormatCurr(Format, Value, FormatSettings);
end;

function FloatToStr1(Value: Extended; const FormatSettings: TFormatSettings): string;
begin
  result:= FloatToStr(Value, FormatSettings);
end;

function StrToFloatDef2(const S: string; const Default: Extended;
  const FormatSettings: TFormatSettings): Extended;
begin
  result:= StrToFloatDef(S, Default, FormatSettings);
end;

function DateToStr2(const DateTime: TDateTime; const FormatSettings: TFormatSettings): string;
begin
  DateTimeToString(Result, FormatSettings.ShortDateFormat, DateTime,FormatSettings);
end;

function TimeToStr2(const DateTime: TDateTime; const FormatSettings: TFormatSettings): string;
begin
  DateTimeToString(Result, FormatSettings.LongTimeFormat, DateTime, FormatSettings);
end;

function StrToDate2(const S: string; const FormatSettings: TFormatSettings): TDateTime;
begin
  result:= StrToDate(S, FormatSettings);
end;

function StrToTime2(const S: string; const FormatSettings: TFormatSettings): TDateTime;
begin
  result:= StrToTime(S, FormatSettings);
end;

function StrToDateTime2(const S: string; const FormatSettings: TFormatSettings): TDateTime;
begin
  result:= StrToDateTime(S, FormatSettings);
end;

function StrToDateDef2(const S: string; const Default: TDateTime;
  const FormatSettings: TFormatSettings): TDateTime;
begin
  result:= StrToDateDef(S, Default, FormatSettings);
end;

function StrToTimeDef2(const S: string; const Default: TDateTime; const FormatSettings: TFormatSettings): TDateTime;
begin
  result:= StrToTimeDef(S, Default, FormatSettings);
end;

function Trim2(const S: WideString): WideString;
begin
  result:= Trim(S);
end;

function TrimLeft2(const S: WideString): WideString;
begin
  result:= TrimLeft(S);
end;

function TrimRight2(const S: WideString): WideString;
begin
  result:= TrimRight(S);
end;

function FileCreate2(const FileName: string; Rights: Integer): Integer;
begin
  result:= FileCreate(FileName, Rights);
end;

function FileSeek2(Handle: Integer; const Offset: Int64; Origin: Integer): Int64;
begin
  result:= FileSeek(Handle, Offset,Origin);
end;

function TryStrToDate2(S : string; Value : TDateTime; FormatSettings : TFormatSettings) : Boolean;
begin
  result:= TryStrToDate(S, Value, FormatSettings);
end;

function TryStrToTime2(const S: string; out Value: TDateTime;
  const FormatSettings: TFormatSettings): Boolean; //overload;
begin
  result:= TryStrToTime(S,Value, FormatSettings);

end;

function StrToDateTimeDef2(const S: string; const Default: TDateTime;
  const FormatSettings: TFormatSettings): TDateTime; //overload;
  begin
    result:= StrToDateTimeDef(S, Default, FormatSettings);
  end;

function TryStrToDateTime2(const S: string; out Value: TDateTime;
  const FormatSettings: TFormatSettings): Boolean; //overload;
begin
  result:= TryStrToDateTime(S, Value, FormatSettings);
end;


procedure mXButton(x,y,w,h,t,l,ahandle: integer);
var rgn: HRgn;
begin
  rgn:= createRoundRectRgn(x,y,w,h,t,l);
  setWindowRgn(ahandle, rgn, true);
end;


type
 //TThreadFunction2 = function: Longint; stdcall;
 TThreadFunction2 = procedure; stdcall;
 TThreadFunction1 = function: integer; stdcall;

//var mxThreadFunc: TThreadFunction2;

function CreateThread2(ThreadFunc: TThreadFunction2; thrid: DWord): Integer;
var
  thr: THandle;
  //thrID: Dword;
begin
  //thr:= createThread(NIL, 0, @afunc, NIL, 0, thrID);
  //if (thr=0) then thrOK:= true;
  result:= CreateThread(NIL, 0,  @ThreadFunc, NIL, 0, thrid);
end;


function CreateThread1(ThreadAttrib: dword; stack: dword;
        ThreadFunc: TFarProc; parameter: integer; flags: dword; thrid: DWord): Integer;
var
  thr: THandle;
 var   mx: TFNThreadStartRoutine;

  //thrID: Dword;
begin
  //thr:= createThread(NIL, 0, @afunc, NIL, 0, thrID);
  //if (thr=0) then thrOK:= true;
  result:= CreateThread(NIL, stack, ThreadFunc, NIL, flags, thrid);
end;


(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Function StringOfChar1( ch : WideChar; Count : Integer) : WideString;
Begin Result := System.StringOfChar(ch, Count); END;

(*----------------------------------------------------------------------------*)
Function StringOfChar2( ch : AnsiChar; Count : Integer) : AnsiString;
Begin Result := System.StringOfChar(ch, Count); END;


(*----------------------------------------------------------------------------*)
procedure EOSErrorErrorCode_W(Self: EOSError; const T: DWORD);
Begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EOSErrorErrorCode_R(Self: EOSError; var T: DWORD);
Begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure EInOutErrorErrorCode_W(Self: EInOutError; const T: Integer);
Begin Self.ErrorCode := T; end;

(*----------------------------------------------------------------------------*)
procedure EInOutErrorErrorCode_R(Self: EInOutError; var T: Integer);
Begin T := Self.ErrorCode; end;

(*----------------------------------------------------------------------------*)
procedure ExceptionMessage_W(Self: Exception; const T: string);
begin Self.Message := T; end;

(*----------------------------------------------------------------------------*)
procedure ExceptionMessage_R(Self: Exception; var T: string);
begin T := Self.Message; end;

(*----------------------------------------------------------------------------*)
procedure ExceptionHelpContext_W(Self: Exception; const T: Integer);
begin Self.HelpContext := T; end;

(*----------------------------------------------------------------------------*)
procedure ExceptionHelpContext_R(Self: Exception; var T: Integer);
begin T := Self.HelpContext; end;

(*----------------------------------------------------------------------------*)
Function ExceptionCreateResHelp_P(Self: TClass; CreateNewInstance: Boolean;  ResStringRec : PResStringRec; AHelpContext : Integer):TObject;
Begin Result := Exception.CreateResHelp(ResStringRec, AHelpContext); END;

//Function ExceptionCreateHelp(const Msg: string; AHelpContext: Integer : Integer):TObject;
//Begin Result:= Exception.CreateHelp(ResStringRec, AHelpContext); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
Function ExceptionCreateRes_P(Self: TClass; CreateNewInstance: Boolean;  ResStringRec : PResStringRec):TObject;
Begin Result := Exception.CreateRes(ResStringRec); END;

(*----------------------------------------------------------------------------*)

(*----------------------------------------------------------------------------*)
procedure TLanguagesExt_R(Self: TLanguages; var T: string; const t1: Integer);
begin T := Self.Ext[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesLocaleID_R(Self: TLanguages; var T: LCID; const t1: Integer);
begin T := Self.LocaleID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesID_R(Self: TLanguages; var T: string; const t1: Integer);
begin T := Self.ID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesNameFromLCID_R(Self: TLanguages; var T: string; const t1: string);
begin T := Self.NameFromLCID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesNameFromLocaleID_R(Self: TLanguages; var T: string; const t1: LCID);
begin T := Self.NameFromLocaleID[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesName_R(Self: TLanguages; var T: string; const t1: Integer);
begin T := Self.Name[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TLanguagesCount_R(Self: TLanguages; var T: Integer);
begin T := Self.Count; end;

function myIntToHex64(Value: Int64; Digits: Integer): string;
begin
  result:= sysUtils.IntToHex(Value,Digits)
 end;

function KeyboardStateToShiftState1: TShiftState;
var
  KeyState: TKeyBoardState;
begin
  GetKeyboardState(KeyState);
  Result := KeyboardStateToShiftState(KeyState);
end;

function KeyboardStateToShiftState2(const KeyboardState: TKeyboardState): TShiftState;
begin
  result:= KeyboardStateToShiftState(KeyboardState);
end;

(*----------------------------------------------------------------------------*)
Function GetUltimateOwner_P( APersistent : TPersistent) : TPersistent;
Begin Result := Classes.GetUltimateOwner(APersistent); END;

(*----------------------------------------------------------------------------*)
Function GetUltimateOwner_C( ACollection : TCollection) : TPersistent;
Begin Result := Classes.GetUltimateOwner(ACollection); END;


(*----------------------------------------------------------------------------*)
procedure RIRegister_SysUtils_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@CheckWin32Version, 'CheckWin32Version', cdRegister);
 S.RegisterDelphiFunction(@GetFileVersion, 'GetFileVersion', cdRegister);
 S.RegisterDelphiFunction(@Languages, 'Languages', cdRegister);
 S.RegisterDelphiFunction(@AllocMem, 'AllocMem', cdRegister);
 S.RegisterDelphiFunction(@AddExitProc, 'AddExitProc', cdRegister);
 S.RegisterDelphiFunction(@NewStr, 'NewStr', cdRegister);
 S.RegisterDelphiFunction(@DisposeStr, 'DisposeStr', cdRegister);
 S.RegisterDelphiFunction(@AssignStr, 'AssignStr', cdRegister);
 S.RegisterDelphiFunction(@AppendStr, 'AppendStr', cdRegister);
 S.RegisterDelphiFunction(@UpperCase, 'UpperCase', cdRegister);
 S.RegisterDelphiFunction(@LowerCase, 'LowerCase', cdRegister);
 S.RegisterDelphiFunction(@CompareStr, 'CompareStr', cdRegister);
 S.RegisterDelphiFunction(@CompareMem, 'CompareMem', cdRegister);
 S.RegisterDelphiFunction(@CompareText, 'CompareText', cdRegister);
 S.RegisterDelphiFunction(@SameText, 'SameText', cdRegister);
 S.RegisterDelphiFunction(@AnsiUpperCase, 'AnsiUpperCase', cdRegister);
 S.RegisterDelphiFunction(@AnsiLowerCase, 'AnsiLowerCase', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareStr, 'AnsiCompareStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiSameStr, 'AnsiSameStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareText, 'AnsiCompareText', cdRegister);
 S.RegisterDelphiFunction(@AnsiSameText, 'AnsiSameText', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrComp, 'AnsiStrComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrIComp, 'AnsiStrIComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLComp, 'AnsiStrLComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLIComp, 'AnsiStrLIComp', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLower, 'AnsiStrLower', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrUpper, 'AnsiStrUpper', cdRegister);
 S.RegisterDelphiFunction(@AnsiLastChar, 'AnsiLastChar', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrLastChar, 'AnsiStrLastChar', cdRegister);
 S.RegisterDelphiFunction(@WideUpperCase, 'WideUpperCase', cdRegister);
 S.RegisterDelphiFunction(@WideLowerCase, 'WideLowerCase', cdRegister);
 S.RegisterDelphiFunction(@WideCompareStr, 'WideCompareStr', cdRegister);
 S.RegisterDelphiFunction(@WideSameStr, 'WideSameStr', cdRegister);
 S.RegisterDelphiFunction(@WideCompareText, 'WideCompareText', cdRegister);
 S.RegisterDelphiFunction(@WideSameText, 'WideSameText', cdRegister);
 S.RegisterDelphiFunction(@Trim, 'Trim', cdRegister);
 S.RegisterDelphiFunction(@Trim2, 'Trim2', cdRegister);
 S.RegisterDelphiFunction(@TrimLeft, 'TrimLeft', cdRegister);
 S.RegisterDelphiFunction(@TrimLeft2, 'TrimLeft2', cdRegister);
 S.RegisterDelphiFunction(@TrimRight, 'TrimRight', cdRegister);
 S.RegisterDelphiFunction(@TrimRight2, 'TrimRight2', cdRegister);
 S.RegisterDelphiFunction(@QuotedStr, 'QuotedStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiQuotedStr, 'AnsiQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiExtractQuotedStr, 'AnsiExtractQuotedStr', cdRegister);
 S.RegisterDelphiFunction(@AnsiDequotedStr, 'AnsiDequotedStr', cdRegister);
 S.RegisterDelphiFunction(@IsValidIdent, 'IsValidIdent', cdRegister);
 //S.RegisterDelphiFunction(@IntToStr, 'IntToStr', cdRegister);
 S.RegisterDelphiFunction(@IntToHex, 'IntToHex', cdRegister);
 S.RegisterDelphiFunction(@myIntToHex64, 'IntToHex64', cdRegister);
 S.RegisterDelphiFunction(@StrToInt, 'StrToInt', cdRegister);
 S.RegisterDelphiFunction(@StrToInt, 'StrToNum', cdRegister);  //alias
 S.RegisterDelphiFunction(@StrToIntDef, 'StrToIntDef', cdRegister);
 S.RegisterDelphiFunction(@StrToInt64, 'StrToInt64', cdRegister);
 S.RegisterDelphiFunction(@StrToInt64Def, 'StrToInt64Def', cdRegister);
 S.RegisterDelphiFunction(@StrToBool, 'StrToBool', cdRegister);
 S.RegisterDelphiFunction(@StrToBoolDef, 'StrToBoolDef', cdRegister);
 S.RegisterDelphiFunction(@LoadStr, 'LoadStr', cdRegister);
 S.RegisterDelphiFunction(@FindStringResource, 'FindStringResource',cdRegister);
 S.RegisterDelphiFunction(@FindStringResource, 'FindStringRes',cdRegister);
 S.RegisterDelphiFunction(@FileOpen, 'FileOpen', cdRegister);
 S.RegisterDelphiFunction(@FileCreate, 'FileCreate', cdRegister);
 S.RegisterDelphiFunction(@FileCreate2, 'FileCreate2', cdRegister);
 S.RegisterDelphiFunction(@FileSeek, 'FileSeek', cdRegister);
 S.RegisterDelphiFunction(@FileSeek2, 'FileSeek2', cdRegister);
 S.RegisterDelphiFunction(@FileClose, 'FileClose', cdRegister);
 S.RegisterDelphiFunction(@FileAge, 'FileAge', cdRegister);
 S.RegisterDelphiFunction(@FileExists, 'FileExists', cdRegister);
 S.RegisterDelphiFunction(@DirectoryExists, 'DirectoryExists', cdRegister);
 S.RegisterDelphiFunction(@ForceDirectories, 'ForceDirectories', cdRegister);
 {S.RegisterDelphiFunction(@FindFirst, 'FindFirst', cdRegister);
 S.RegisterDelphiFunction(@FindNext, 'FindNext', cdRegister);
 S.RegisterDelphiFunction(@FindClose, 'FindClose', cdRegister);}
 S.RegisterDelphiFunction(@System_AssignFile, 'AssignFile', cdRegister);
 S.RegisterDelphiFunction(@System_CloseFile, 'CloseFile', cdRegister);
 S.RegisterDelphiFunction(@System_Reset, 'Reset', cdRegister);
 S.RegisterDelphiFunction(@System_Rewrite, 'Rewrite', cdRegister);

 S.RegisterDelphiFunction(@System_str, 'Str', cdRegister);
 S.RegisterDelphiFunction(@FileGetDate, 'FileGetDate', cdRegister);
 S.RegisterDelphiFunction(@FileSetDate, 'FileSetDate', cdRegister);
 S.RegisterDelphiFunction(@FileSetDateH, 'FileSetDateH', cdRegister);
 S.RegisterDelphiFunction(@FileSetDateH, 'FileSetDate2', cdRegister);
 S.RegisterDelphiFunction(@FileGetAttr, 'FileGetAttr', cdRegister);
 S.RegisterDelphiFunction(@FileSetAttr, 'FileSetAttr', cdRegister);
 S.RegisterDelphiFunction(@FileIsReadOnly, 'FileIsReadOnly', cdRegister);
 S.RegisterDelphiFunction(@FileSetReadOnly, 'FileSetReadOnly', cdRegister);
 //S.RegisterDelphiFunction(@DeleteFile, 'DeleteFile', cdRegister);
 S.RegisterDelphiFunction(@RenameFile, 'RenameFile', cdRegister);
 S.RegisterDelphiFunction(@ChangeFileExt, 'ChangeFileExt', cdRegister);
 S.RegisterDelphiFunction(@ExtractFilePath, 'ExtractFilePath', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDir, 'ExtractFileDir', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileDrive, 'ExtractFileDrive', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileName, 'ExtractFileName', cdRegister);
 S.RegisterDelphiFunction(@ExtractFileExt, 'ExtractFileExt', cdRegister);
 S.RegisterDelphiFunction(@ExpandFileName, 'ExpandFileName', cdRegister);
 S.RegisterDelphiFunction(@ExpandUNCFileName, 'ExpandUNCFileName', cdRegister);
 S.RegisterDelphiFunction(@ExtractRelativePath, 'ExtractRelativePath', cdRegister);
 S.RegisterDelphiFunction(@ExtractShortPathName, 'ExtractShortPathName', cdRegister);
 S.RegisterDelphiFunction(@FileSearch, 'FileSearch', cdRegister);
 S.RegisterDelphiFunction(@DiskFree, 'DiskFree', cdRegister);
 S.RegisterDelphiFunction(@DiskSize, 'DiskSize', cdRegister);
 S.RegisterDelphiFunction(@FileDateToDateTime, 'FileDateToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToFileDate, 'DateTimeToFileDate', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentDir, 'GetCurrentDir', cdRegister);
 S.RegisterDelphiFunction(@SetCurrentDir, 'SetCurrentDir', cdRegister);
 S.RegisterDelphiFunction(@CreateDir, 'CreateDir', cdRegister);
 S.RegisterDelphiFunction(@RemoveDir, 'RemoveDir', cdRegister);
 S.RegisterDelphiFunction(@StrLen, 'StrLen', cdRegister);
 S.RegisterDelphiFunction(@StrEnd, 'StrEnd', cdRegister);
 S.RegisterDelphiFunction(@StrMove, 'StrMove', cdRegister);
 S.RegisterDelphiFunction(@StrCopy, 'StrCopy', cdRegister);
 S.RegisterDelphiFunction(@StrECopy, 'StrECopy', cdRegister);
 S.RegisterDelphiFunction(@StrLCopy, 'StrLCopy', cdRegister);
 S.RegisterDelphiFunction(@StrPCopy, 'StrPCopy', cdRegister);
 S.RegisterDelphiFunction(@StrPLCopy, 'StrPLCopy', cdRegister);
 S.RegisterDelphiFunction(@StrCat, 'StrCat', cdRegister);
 S.RegisterDelphiFunction(@StrLCat, 'StrLCat', cdRegister);
 S.RegisterDelphiFunction(@StrComp, 'StrComp', cdRegister);
 S.RegisterDelphiFunction(@StrIComp, 'StrIComp', cdRegister);
 S.RegisterDelphiFunction(@StrLComp, 'StrLComp', cdRegister);
 S.RegisterDelphiFunction(@StrLIComp, 'StrLIComp', cdRegister);
 S.RegisterDelphiFunction(@StrPos, 'StrPos', cdRegister);
 S.RegisterDelphiFunction(@StrUpper, 'StrUpper', cdRegister);
 S.RegisterDelphiFunction(@StrLower, 'StrLower', cdRegister);
 S.RegisterDelphiFunction(@StrPas, 'StrPas', cdRegister);
 S.RegisterDelphiFunction(@StrAlloc, 'StrAlloc', cdRegister);
 S.RegisterDelphiFunction(@StrBufSize, 'StrBufSize', cdRegister);
 S.RegisterDelphiFunction(@StrNew, 'StrNew', cdRegister);
 S.RegisterDelphiFunction(@StrDispose, 'StrDispose', cdRegister);
 S.RegisterDelphiFunction(@FloatToStr, 'FloatToStr', cdRegister);
 S.RegisterDelphiFunction(@FloatToStr1, 'FloatToStr1', cdRegister);
 S.RegisterDelphiFunction(@FloatToStrF, 'FloatToStrF', cdRegister);
 S.RegisterDelphiFunction(@FloatToStrFS, 'FloatToStrFS', cdRegister);
 S.RegisterDelphiFunction(@FloatToStrFS, 'FloatToStr2', cdRegister);

 S.RegisterDelphiFunction(@CurrToStr, 'CurrToStr', cdRegister);
 S.RegisterDelphiFunction(@CurrToStrF, 'CurrToStrF', cdRegister);
 S.RegisterDelphiFunction(@CurrToStrFS, 'CurrToStrFS', cdRegister);
 S.RegisterDelphiFunction(@FloatToCurr, 'FloatToCurr', cdRegister);
 //S.RegisterDelphiFunction(@FloatToStrF, 'FloatToStrF', cdRegister);
 //S.RegisterDelphiFunction(@CurrToStrF, 'CurrToStrF', cdRegister);
 S.RegisterDelphiFunction(@Flush, 'Flush', cdRegister);
 S.RegisterDelphiFunction(@FreeAndNIL2, 'FreeAndNIL2', cdRegister);
 //overload prototypes
 S.RegisterDelphiFunction(@FormatFloat, 'FormatFloat', cdRegister); //prototype
 S.RegisterDelphiFunction(@FormatFloat2, 'FormatFloat2', cdRegister);
 S.RegisterDelphiFunction(@FormatCurr, 'FormatCurr', cdRegister);
  S.RegisterDelphiFunction(@FormatCurr2, 'FormatCurr2', cdRegister);
 S.RegisterDelphiFunction(@Format2, 'Format2', cdRegister);
 S.RegisterDelphiFunction(@FloatToTextFmt, 'FloatToTextFmt', cdRegister);

 S.RegisterDelphiFunction(@StrToFloat, 'StrToFloat', cdRegister);
 S.RegisterDelphiFunction(@StrToFloat2, 'StrToFloat2', cdRegister);
 S.RegisterDelphiFunction(@StrToFloat2, 'StrToFloatF', cdRegister);
 S.RegisterDelphiFunction(@StrToFloat, 'StrToFloatFS', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatDef, 'StrToFloatDef', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatDef2, 'StrToFloatDef2', cdRegister);
 S.RegisterDelphiFunction(@StrToCurr1, 'StrToCurr', cdRegister);
 S.RegisterDelphiFunction(@StrToCurr2, 'StrToCurr2', cdRegister);
 S.RegisterDelphiFunction(@StrToCurrDef, 'StrToCurrDef', cdRegister);
 S.RegisterDelphiFunction(@StrToCurrDef2, 'StrToCurrDef2', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToTimeStamp, 'DateTimeToTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@TimeStampToDateTime, 'TimeStampToDateTime', cdRegister);
 S.RegisterDelphiFunction(@MSecsToTimeStamp, 'MSecsToTimeStamp', cdRegister);
 S.RegisterDelphiFunction(@TimeStampToMSecs, 'TimeStampToMSecs', cdRegister);
 S.RegisterDelphiFunction(@EncodeDate, 'EncodeDate', cdRegister);
 S.RegisterDelphiFunction(@EncodeTime, 'EncodeTime', cdRegister);
 S.RegisterDelphiFunction(@DecodeDate, 'DecodeDate', cdRegister);
 S.RegisterDelphiFunction(@DecodeDateFully, 'DecodeDateFully', cdRegister);
 //S.RegisterDelphiFunction(@InternalDecodeDate, 'InternalDecodeDate', cdRegister);
 S.RegisterDelphiFunction(@DecodeTime, 'DecodeTime', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToSystemTime, 'DateTimeToSystemTime', cdRegister);
 S.RegisterDelphiFunction(@SystemTimeToDateTime, 'SystemTimeToDateTime', cdRegister);
 S.RegisterDelphiFunction(@DayOfWeek, 'DayOfWeek', cdRegister);
 S.RegisterDelphiFunction(@Date, 'Date', cdRegister);
 S.RegisterDelphiFunction(@Time, 'Time', cdRegister);
 S.RegisterDelphiFunction(@GetTime, 'GetTime', cdRegister);
 S.RegisterDelphiFunction(@Now, 'Now', cdRegister);
 S.RegisterDelphiFunction(@CurrentYear, 'CurrentYear', cdRegister);
 S.RegisterDelphiFunction(@IncMonth, 'IncMonth', cdRegister);
 S.RegisterDelphiFunction(@IncAMonth, 'IncAMonth', cdRegister);
 S.RegisterDelphiFunction(@ReplaceTime, 'ReplaceTime', cdRegister);
 S.RegisterDelphiFunction(@ReplaceDate, 'ReplaceDate', cdRegister);
 S.RegisterDelphiFunction(@IsLeapYear, 'IsLeapYear', cdRegister);
 //S.RegisterDelphiFunction(@IsLeapYear, 'IsLeapYear', cdRegister);
 //S.RegisterDelphiFunction(@IsToday, 'IsToday', cdRegister);
 S.RegisterDelphiFunction(@DateToStr, 'DateToStr', cdRegister);
 S.RegisterDelphiFunction(@DateToStr2, 'DateToStr2', cdRegister);
 S.RegisterDelphiFunction(@TimeToStr, 'TimeToStr', cdRegister);
 S.RegisterDelphiFunction(@TimeToStr2, 'TimeToStr2', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToStr, 'DateTimeToStr', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToStr2, 'DateTimeToStr2', cdRegister);
 S.RegisterDelphiFunction(@StrToDate, 'StrToDate', cdRegister);
 S.RegisterDelphiFunction(@StrToDate2, 'StrToDate2', cdRegister);
 S.RegisterDelphiFunction(@StrToDateDef, 'StrToDateDef', cdRegister);
 S.RegisterDelphiFunction(@StrToDateDef2, 'StrToDateDef2', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDate, 'TryStrToDate', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDate2, 'TryStrToDate2', cdRegister);
 S.RegisterDelphiFunction(@StrToTime, 'StrToTime', cdRegister);
 S.RegisterDelphiFunction(@StrToTime2, 'StrToTime2', cdRegister);
 S.RegisterDelphiFunction(@StrToTimeDef, 'StrToTimeDef', cdRegister);
 S.RegisterDelphiFunction(@StrToTimeDef2, 'StrToTimeDef2', cdRegister);
 S.RegisterDelphiFunction(@TryStrToTime, 'TryStrToTime', cdRegister);
 S.RegisterDelphiFunction(@TryStrToTime2, 'TryStrToTime2', cdRegister);
 S.RegisterDelphiFunction(@StrToDateTime, 'StrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@StrToDateTime2, 'StrToDateTime2', cdRegister);
 S.RegisterDelphiFunction(@StrToDateTimeDef, 'StrToDateTimeDef', cdRegister);
 S.RegisterDelphiFunction(@StrToDateTimeDef2, 'StrToDateTimeDef2', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDateTime, 'TryStrToDateTime', cdRegister);
 S.RegisterDelphiFunction(@TryStrToDateTime2, 'TryStrToDateTime2', cdRegister);
 S.RegisterDelphiFunction(@FormatDateTime, 'FormatDateTime', cdRegister);
 S.RegisterDelphiFunction(@FormatDateTime2, 'FormatDateTime2', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToString, 'DateTimeToString', cdRegister);
 S.RegisterDelphiFunction(@DateTimeToString2, 'DateTimeToString2', cdRegister);
 S.RegisterDelphiFunction(@FloatToDateTime, 'FloatToDateTime', cdRegister);
 S.RegisterDelphiFunction(@TryFloatToDateTime, 'TryFloatToDateTime', cdRegister);
 S.RegisterDelphiFunction(@SysErrorMessage, 'SysErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@GetLocaleStr, 'GetLocaleStr', cdRegister);
 S.RegisterDelphiFunction(@GetLocaleChar, 'GetLocaleChar', cdRegister);
 S.RegisterDelphiFunction(@GetFormatSettings, 'GetFormatSettings', cdRegister);
 S.RegisterDelphiFunction(@GetLocaleFormatSettings, 'GetLocaleFormatSettings', cdRegister);
 {S.RegisterDelphiFunction(@InquireSignal, 'InquireSignal', cdRegister);
 S.RegisterDelphiFunction(@AbandonSignalHandler, 'AbandonSignalHandler', cdRegister);
 S.RegisterDelphiFunction(@HookSignal, 'HookSignal', cdRegister);
 S.RegisterDelphiFunction(@UnhookSignal, 'UnhookSignal', cdRegister);
 S.RegisterDelphiFunction(@HookOSExceptions, 'HookOSExceptions', cdRegister);
 S.RegisterDelphiFunction(@MapSignal, 'MapSignal', cdRegister);
 S.RegisterDelphiFunction(@SignalConverter, 'SignalConverter', cdRegister);
 S.RegisterDelphiFunction(@SetSafeCallExceptionMsg, 'SetSafeCallExceptionMsg', cdRegister);
 S.RegisterDelphiFunction(@SetSafeCallExceptionAddr, 'SetSafeCallExceptionAddr', cdRegister);
 S.RegisterDelphiFunction(@GetSafeCallExceptionMsg, 'GetSafeCallExceptionMsg', cdRegister);
 S.RegisterDelphiFunction(@GetSafeCallExceptionAddr, 'GetSafeCallExceptionAddr', cdRegister);}
 S.RegisterDelphiFunction(@LoadLibrary, 'LoadLibrary', CdStdCall);
 S.RegisterDelphiFunction(@FreeLibrary, 'FreeLibrary', CdStdCall);
 S.RegisterDelphiFunction(@FreeModule, 'FreeModule', CdStdCall);
 S.RegisterDelphiFunction(@FreeLibraryAndExitThread, 'FreeLibraryAndExitThread', CdStdCall);
 S.RegisterDelphiFunction(@DisableThreadLibraryCalls, 'DisableThreadLibraryCalls', CdStdCall);
 S.RegisterDelphiFunction(@GetSafeCallExceptionMsg, 'GetSafeCallExceptionMsg', cdRegister);

 //S.RegisterDelphiFunction(@LoadModule, 'LoadModule', cdRegister);
 S.RegisterDelphiFunction(@GetProcAddress, 'GetProcAddress', CdStdCall);
 S.RegisterDelphiFunction(@GetModuleHandle, 'GetModuleHandle', CdStdCall);
 //S.RegisterDelphiFunction(@GetPackageModuleHandle,'GetPackageModuleHandle',cdRegister);
 //S.RegisterDelphiFunction(@GetPackageModuleHandle, 'GetPackageModuleHandle', cdRegister);
 S.RegisterDelphiFunction(@Sleep, 'Sleep', CdStdCall);
 S.RegisterDelphiFunction(@GetModuleName, 'GetModuleName', cdRegister);
 S.RegisterDelphiFunction(@ExceptionErrorMessage, 'ExceptionErrorMessage', cdRegister);
 S.RegisterDelphiFunction(@ShowException, 'ShowException', cdRegister);
 S.RegisterDelphiFunction(@Abort, 'Abort', cdRegister);
 S.RegisterDelphiFunction(@OutOfMemoryError, 'OutOfMemoryError', cdRegister);
 S.RegisterDelphiFunction(@FPower10, 'FPower10', cdRegister);
 S.RegisterDelphiFunction(@myHalt, 'Halt', cdRegister);
 S.RegisterDelphiFunction(@myRunError, 'RunError',cdRegister);
 S.RegisterDelphiFunction(@MoveMemory, 'MoveMemory', cdRegister);
 S.RegisterDelphiFunction(@CopyMemory, 'CopyMemory', cdRegister);
 S.RegisterDelphiFunction(@FillMemory, 'FillMemory', cdRegister);
 S.RegisterDelphiFunction(@ZeroMemory, 'ZeroMemory', cdRegister);

 //S.RegisterDelphiFunction(@Slice, 'Slice', cdRegister);
 S.RegisterDelphiFunction(@myEOF, 'EOF', cdRegister);
 S.RegisterDelphiFunction(@myEoln, 'EOLn', cdRegister);
 S.RegisterDelphiFunction(@IOResult, 'IOResult', cdRegister);
 S.RegisterDelphiFunction(@GetLastError, 'GetLastError', cdRegister);
 S.RegisterDelphiFunction(@SetLastError, 'SetLastError', cdRegister);
 S.RegisterDelphiFunction(@IsMemoryManagerSet,'IsMemoryManagerSet', cdRegister);
 S.RegisterDelphiFunction(@getIsConsole,'IsConsole', cdRegister);
 S.RegisterDelphiFunction(@getIsLibrary,'IsLibrary', cdRegister);
 S.RegisterDelphiFunction(@getIsMultiThread,'IsMultiThread', cdRegister);
 S.RegisterDelphiFunction(@HiByte,'HiByte', cdRegister);
 S.RegisterDelphiFunction(@HiWord,'HiWord', cdRegister);
 S.RegisterDelphiFunction(@myLowByte,'LoByte', cdRegister);

 S.RegisterDelphiFunction(@MakeWord,'MakeWord', cdRegister);
 S.RegisterDelphiFunction(@MakeLong,'MakeLong', cdRegister);
 S.RegisterDelphiFunction(@myVal,'Val', cdRegister);

 S.RegisterDelphiFunction(@getLongDayNames,'getLongDayNames', cdRegister);
 S.RegisterDelphiFunction(@getShortDayNames,'getShortDayNames', cdRegister);
 S.RegisterDelphiFunction(@getLongMonthNames,'getLongMonthNames', cdRegister);
 S.RegisterDelphiFunction(@getShortMonthNames,'getShortMonthNames', cdRegister);

//VAR PROTOTYPES
  S.RegisterDelphiFunction(@RandSeed, 'RandSeed', cdRegister);
  S.RegisterDelphiFunction(@mysetRandSeed, 'SetRandSeed', cdRegister);
  S.RegisterDelphiFunction(@myCurrencyString, 'CurrencyString', cdRegister);
  S.RegisterDelphiFunction(@myCurrencyDecimals, 'CurrencyDecimals', cdRegister);
  S.RegisterDelphiFunction(@myCurrencyFormat, 'CurrencyFormat', cdRegister);
  S.RegisterDelphiFunction(@mySetCurrencyFormat, 'SetCurrencyFormat', cdRegister);
  //S.RegisterDelphiFunction(@mylistseparator, 'ListSeparator', cdRegister);
  S.RegisterDelphiFunction(@mySysLocale, 'SysLocale', cdRegister);
  S.RegisterDelphiFunction(@Output, 'Output', cdRegister);
  S.RegisterDelphiFunction(@Input, 'Input', cdRegister);
  S.RegisterDelphiFunction(@ErrOutput, 'ErrOutput', cdRegister);
  S.RegisterDelphiFunction(@myMainInstance, 'MainInstance', cdRegister);
  S.RegisterDelphiFunction(@myMainThreadID, 'MainThreadID', cdRegister);
  S.RegisterDelphiFunction(@myboolstrstrue, 'trueboolstrs', cdRegister);
  S.RegisterDelphiFunction(@myboolstrsfalse, 'falseboolstrs', cdRegister);
  S.RegisterDelphiFunction(@myleadbytes, 'leadbytes', cdRegister);
  S.RegisterDelphiFunction(@getDefaultTextLineBreakStyle,'DefaultTextLineBreakStyle',cdRegister);

 //S.RegisterDelphiFunction(@Beep, 'Beep', cdRegister);
 S.RegisterDelphiFunction(@ByteType, 'ByteType', cdRegister);
 S.RegisterDelphiFunction(@StrByteType, 'StrByteType', cdRegister);
 S.RegisterDelphiFunction(@ByteToCharLen, 'ByteToCharLen', cdRegister);
 S.RegisterDelphiFunction(@CharToByteLen, 'CharToByteLen', cdRegister);
 S.RegisterDelphiFunction(@ByteToCharIndex, 'ByteToCharIndex', cdRegister);
 S.RegisterDelphiFunction(@CharToByteIndex, 'CharToByteIndex', cdRegister);
 S.RegisterDelphiFunction(@StrCharLength, 'StrCharLength', cdRegister);
 S.RegisterDelphiFunction(@StrNextChar, 'StrNextChar', cdRegister);
 S.RegisterDelphiFunction(@CharLength, 'CharLength', cdRegister);
 S.RegisterDelphiFunction(@NextCharIndex, 'NextCharIndex', cdRegister);
 S.RegisterDelphiFunction(@IsPathDelimiter, 'IsPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IsDelimiter, 'IsDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingPathDelimiter, 'IncludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@IncludeTrailingBackslash, 'IncludeTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingPathDelimiter, 'ExcludeTrailingPathDelimiter', cdRegister);
 S.RegisterDelphiFunction(@ExcludeTrailingBackslash, 'ExcludeTrailingBackslash', cdRegister);
 S.RegisterDelphiFunction(@LastDelimiter, 'LastDelimiter', cdRegister);
 S.RegisterDelphiFunction(@AnsiCompareFileName, 'AnsiCompareFileName', cdRegister);
 S.RegisterDelphiFunction(@SameFileName, 'SameFileName', cdRegister);
 S.RegisterDelphiFunction(@AnsiLowerCaseFileName, 'AnsiLowerCaseFileName', cdRegister);
 S.RegisterDelphiFunction(@AnsiUpperCaseFileName, 'AnsiUpperCaseFileName', cdRegister);
 S.RegisterDelphiFunction(@AnsiPos, 'AnsiPos', cdRegister);
 S.RegisterDelphiFunction(@AnsiStrPos, 'AnsiStrPos', cdRegister);
 S.RegisterDelphiFunction(@StringReplace, 'StringReplace', cdRegister);
 S.RegisterDelphiFunction(@WrapText1, 'WrapText', cdRegister);
 S.RegisterDelphiFunction(@WrapText2, 'WrapText2', cdRegister);
 S.RegisterDelphiFunction(@FindCmdLineSwitch, 'FindCmdLineSwitch', cdRegister);
 //S.RegisterDelphiFunction(@FindCmdLineSwitch, 'FindCmdLineSwitch', cdRegister);
 S.RegisterDelphiFunction(@RaiseLastOSError, 'RaiseLastOSError', cdRegister);
 S.RegisterDelphiFunction(@myProcessPath, 'ProcessPath1', cdRegister);
 S.RegisterDelphiFunction(@myProcessPath, 'ProcessPath', cdRegister);
 S.RegisterDelphiFunction(@CharToBin, 'ChartoBin', cdRegister);
 S.RegisterDelphiFunction(@BintoChar, 'BintoChar', cdRegister);
 S.RegisterDelphiFunction(@SlashSep, 'SlashSep', cdRegister);
 S.RegisterDelphiFunction(@CutFirstDirectory, 'CutFirstDirectory', cdRegister);
 S.RegisterDelphiFunction(@MiniMizeName, 'MinimizeName', cdRegister);
 S.RegisterDelphiFunction(@VolumeID, 'VolumeID', cdRegister);
 S.RegisterDelphiFunction(@NetworkVolume, 'NetworkVolume',cdRegister);

  { Object conversion routines of unit classes}
S.RegisterDelphiFunction(@ObjectBinaryToText,'ObjectBinaryToText', cdRegister);
S.RegisterDelphiFunction(@ObjectBinaryToText,'ObjectBinaryToText1', cdRegister);
S.RegisterDelphiFunction(@ObjectTextToBinary,'ObjectTextToBinary', cdRegister);
S.RegisterDelphiFunction(@ObjectTextToBinary,'ObjectTextToBinary1', cdRegister);
S.RegisterDelphiFunction(@ObjectResourceToText,'ObjectResourceToText', cdRegister);
S.RegisterDelphiFunction(@ObjectResourceToText,'ObjectResourceToText1', cdRegister);
S.RegisterDelphiFunction(@ObjectTextToResource,'ObjectTextToResource', cdRegister);
S.RegisterDelphiFunction(@ObjectTextToResource,'ObjectTextToResource1', cdRegister);
 S.RegisterDelphiFunction(@FindGlobalComponent, 'FindGlobalComponent', cdRegister);
 S.RegisterDelphiFunction(@IsUniqueGlobalComponentName, 'IsUniqueGlobalComponentName', cdRegister);
 S.RegisterDelphiFunction(@InitInheritedComponent, 'InitInheritedComponent', cdRegister);
 S.RegisterDelphiFunction(@InitComponentRes, 'InitComponentRes', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentRes, 'ReadComponentRes', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentResEx, 'ReadComponentResEx', cdRegister);
 S.RegisterDelphiFunction(@ReadComponentResFile, 'ReadComponentResFile', cdRegister);
 S.RegisterDelphiFunction(@WriteComponentResFile, 'WriteComponentResFile', cdRegister);
 S.RegisterDelphiFunction(@GlobalFixupReferences, 'GlobalFixupReferences', cdRegister);
 S.RegisterDelphiFunction(@GetFixupReferenceNames, 'GetFixupReferenceNames', cdRegister);
 S.RegisterDelphiFunction(@GetFixupInstanceNames, 'GetFixupInstanceNames', cdRegister);
 S.RegisterDelphiFunction(@RedirectFixupReferences, 'RedirectFixupReferences', cdRegister);
 S.RegisterDelphiFunction(@RemoveFixupReferences, 'RemoveFixupReferences', cdRegister);
 S.RegisterDelphiFunction(@RemoveFixups, 'RemoveFixups', cdRegister);
 S.RegisterDelphiFunction(@FindNestedComponent, 'FindNestedComponent', cdRegister);
 S.RegisterDelphiFunction(@BeginGlobalLoading, 'BeginGlobalLoading', cdRegister);
 S.RegisterDelphiFunction(@NotifyGlobalLoading, 'NotifyGlobalLoading', cdRegister);
 S.RegisterDelphiFunction(@EndGlobalLoading, 'EndGlobalLoading', cdRegister);
 S.RegisterDelphiFunction(@GetUltimateOwner_P, 'GetUltimateOwner', cdRegister);
 S.RegisterDelphiFunction(@GetUltimateOwner_C, 'GetUltimateOwner1', cdRegister);
 S.RegisterDelphiFunction(@MakeObjectInstance, 'MakeObjectInstance', cdRegister);
 S.RegisterDelphiFunction(@FreeObjectInstance, 'FreeObjectInstance', cdRegister);
 S.RegisterDelphiFunction(@AllocateHWnd, 'AllocateHWnd', cdRegister);
 S.RegisterDelphiFunction(@DeallocateHWnd, 'DeallocateHWnd', cdRegister);
 S.RegisterDelphiFunction(@AncestorIsValid, 'AncestorIsValid', cdRegister);
 S.RegisterDelphiFunction(@RegisterClass, 'RegisterClass', cdRegister);
 S.RegisterDelphiFunction(@RegisterClasses, 'RegisterClasses', cdRegister);
 S.RegisterDelphiFunction(@RegisterClassAlias, 'RegisterClassAlias', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterClass, 'UnRegisterClass', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterClasses, 'UnRegisterClasses', cdRegister);
 S.RegisterDelphiFunction(@UnRegisterModuleClasses, 'UnRegisterModuleClasses', cdRegister);

// S.RegisterDelphiFunction(@TestStreamFormat, 'TestStreamFormat', cdRegister);
S.RegisterDelphiFunction(@TestStreamFormat,'TestStreamFormat', cdRegister);
S.RegisterDelphiFunction(@LineStart,'LineStart', cdRegister);
S.RegisterDelphiFunction(@ExtractStrings,'ExtractStrings', cdRegister);
S.RegisterDelphiFunction(@CountGenerations,'CountGenerations', cdRegister);
S.RegisterDelphiFunction(@CheckSynchronize,'CheckSynchronize', cdRegister);

//S.RegisterDelphiFunction(@Check,'Check', cdRegister);     //DB
S.RegisterDelphiFunction(@ColorToRGB,'ColorToRGB', cdRegister); //Graphics
S.RegisterDelphiFunction(@ColorToString,'ColorToString', cdRegister); //Graphics
S.RegisterDelphiFunction(@StringToColor,'StringToColor', cdRegister); //Graphics
S.RegisterDelphiFunction(@ColorToIdent,'ColorToIdent', cdRegister); //Graphics
S.RegisterDelphiFunction(@IdentToColor,'IdentToColor', cdRegister); //Graphics
S.RegisterDelphiFunction(@CharsetToIdent,'CharsetIdent', cdRegister); //Graphics
S.RegisterDelphiFunction(@IdentToCharset,'IdentToCharset', cdRegister); //Graphics

S.RegisterDelphiFunction(@DataBaseError,'DataBaseError', cdRegister); //DB
//S.RegisterDelphiFunction(@DBIError,'DBIError', cdRegister);        //DB
S.RegisterDelphiFunction(@GetLongHint,'GetLongHint', cdRegister); //Controls
S.RegisterDelphiFunction(@GetShortHint,'GetShortHint', cdRegister); //
S.RegisterDelphiFunction(@GetParentForm,'GetParentForm', cdRegister); //Forms
//S.RegisterDelphiFunction(@GraphicFilter,'GraphicFilter', cdRegister); //Graphics
S.RegisterDelphiFunction(@ValidParentForm,'ValidParentForm', cdRegister); //Forms
S.RegisterDelphiFunction(@IsAccel,'IsAccel', cdRegister); //Forms
S.RegisterDelphiFunction(@ForegroundTask,'ForegroundTask', cdRegister); //Forms

S.RegisterDelphiFunction(@LoadCursor,'LoadCursor', CdStdCall); //Win
//S.RegisterDelphiFunction(@BitBlt,'BitBlt', cdRegister); //Win
S.RegisterDelphiFunction(@StretchBlt,'StretchBlt', CdStdCall); //Win
//S.RegisterDelphiFunction(@ReleaseDC,'ReleaseDC', cdRegister); //Win
//S.RegisterDelphiFunction(@GetWindowDC,'GetWindowDC', cdRegister); //Win  //3.7
S.RegisterDelphiFunction(@GetWindowRect,'GetWindowRect', CdStdCall); //Win in graphics
S.RegisterDelphiFunction(@SetLineBreakStyle,'SetLineBreakStyle', cdRegister); //Win in graphics
 S.RegisterDelphiFunction(@Arc, 'Arc', CdStdCall);
 S.RegisterDelphiFunction(@BitBlt, 'BitBlt', CdStdCall);
 //S.RegisterDelphiFunction(@CreateDC, 'CreateDC', CdStdCall);
 S.RegisterDelphiFunction(@AddFontResource, 'AddFontResource', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemMetrics, 'GetSystemMetrics', CdStdCall);
 S.RegisterDelphiFunction(@UpdateWindow, 'UpdateWindow', CdStdCall);
 S.RegisterDelphiFunction(@SetActiveWindow, 'SetActiveWindow', CdStdCall);
 S.RegisterDelphiFunction(@GetForegroundWindow, 'GetForegroundWindow', CdStdCall);
 S.RegisterDelphiFunction(@PaintDesktop, 'PaintDesktop', CdStdCall);
 S.RegisterDelphiFunction(@SetForegroundWindow, 'SetForegroundWindow', CdStdCall);
 S.RegisterDelphiFunction(@WindowFromDC, 'WindowFromDC', CdStdCall);
 S.RegisterDelphiFunction(@GetDC, 'GetDC', CdStdCall);
 S.RegisterDelphiFunction(@GetDCEx, 'GetDCEx', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowDC, 'GetWindowDC', CdStdCall);
 S.RegisterDelphiFunction(@ReleaseDC, 'ReleaseDC', CdStdCall);
 S.RegisterDelphiFunction(@DefineHandleTable, 'DefineHandleTable', cdRegister);
 S.RegisterDelphiFunction(@LimitEmsPages, 'LimitEmsPages', cdRegister);
 S.RegisterDelphiFunction(@SetSwapAreaSize, 'SetSwapAreaSize', cdRegister);
 S.RegisterDelphiFunction(@LockSegment, 'LockSegment', cdRegister);
 S.RegisterDelphiFunction(@UnlockSegment, 'UnlockSegment', cdRegister);
 S.RegisterDelphiFunction(@GetCurrentTime, 'GetCurrentTime', cdRegister);
 S.RegisterDelphiFunction(@Yield, 'Yield', cdRegister);
 S.RegisterDelphiFunction(@GetShortPathName, 'GetShortPathName', CdStdCall);
 S.RegisterDelphiFunction(@GetVersion, 'GetVersion', CdStdCall);
 S.RegisterDelphiFunction(@GetCValue, 'GetCValue', CdStdCall);
 S.RegisterDelphiFunction(@GetMValue, 'GetMValue', CdStdCall);
 S.RegisterDelphiFunction(@GetYValue, 'GetYValue', CdStdCall);
 S.RegisterDelphiFunction(@GetKValue, 'GetKValue', CdStdCall);
 S.RegisterDelphiFunction(@CMYK, 'CMYK', cdRegister);
 //S.RegisterDelphiFunction(@RGB, 'RGB', cdRegister);
 S.RegisterDelphiFunction(@PaletteRGB, 'PaletteRGB', CdStdCall);
 S.RegisterDelphiFunction(@PaletteIndex, 'PaletteIndex', CdStdCall);
 S.RegisterDelphiFunction(@GetRValue, 'GetRValue', CdStdCall);
 S.RegisterDelphiFunction(@GetGValue, 'GetGValue', CdStdCall);
 S.RegisterDelphiFunction(@GetBValue, 'GetBValue', CdStdCall);

S.RegisterDelphiFunction(@Set8087CW,'Set8087CW', cdRegister); //Win
S.RegisterDelphiFunction(@Get8087CW,'Get8087CW', cdRegister);
S.RegisterDelphiFunction(@WideStringToUCS4String,'WideStringToUCS4String', cdRegister); //Win
S.RegisterDelphiFunction(@UCS4StringToWideString,'UCS4StringToWideString', cdRegister);
S.RegisterDelphiFunction(@UTF8Encode,'UTF8Encode', cdRegister); //Win
S.RegisterDelphiFunction(@UTF8Decode,'UTF8Decode', cdRegister);
S.RegisterDelphiFunction(@AnsiToUtf8,'AnsiToUtf8', cdRegister); //Win
S.RegisterDelphiFunction(@Utf8ToAnsi,'Utf8ToAnsi', cdRegister);
(*{$DEFINE PC_MAPPED_EXCEPTIONS}
S.RegisterDelphiFunction(@System.BlockOSExceptions, 'BlockOSExceptions', cdRegister);
S.RegisterDelphiFunction(@System.UnblockOSExceptions, 'UnblockOSExceptions', cdRegister);
S.RegisterDelphiFunction(@System.AreOSExceptionsBlocked, 'AreOSExceptionsBlocked', cdRegister);
S.RegisterDelphiFunction(@System.ModuleCacheID,'ModuleCacheID', cdRegister);
S.RegisterDelphiFunction(@System.InvalidateModuleCache,'AnsiToUtf8', cdRegister); //Win
{$ENDIF}*)
S.RegisterDelphiFunction(@SetMultiByteConversionCodePage,'SetMultiByteConversionCodePage', cdRegister);
 //S.RegisterDelphiFunction(@_CheckAutoResult, '_CheckAutoResult', cdRegister);
 S.RegisterDelphiFunction(@FPower10, 'FPower10', cdRegister);
 S.RegisterDelphiFunction(@TextStart, 'TextStart', cdRegister);
 S.RegisterDelphiFunction(@CompToDouble, 'CompToDouble', CdCdecl);
 S.RegisterDelphiFunction(@DoubleToComp, 'DoubleToComp', CdCdecl);
 S.RegisterDelphiFunction(@CompToCurrency, 'CompToCurrency', CdCdecl);
 S.RegisterDelphiFunction(@CurrencyToComp, 'CurrencyToComp', CdCdecl);
 S.RegisterDelphiFunction(@GetMemory, 'GetMemory', CdCdecl);
 S.RegisterDelphiFunction(@FreeMemory, 'FreeMemory', CdCdecl);
 S.RegisterDelphiFunction(@ReallocMemory, 'ReallocMemory', CdCdecl);
 S.RegisterDelphiFunction(@StringOfChar1, 'StringOfChar1', cdRegister);
 S.RegisterDelphiFunction(@StringOfChar2, 'StringOfChar2', cdRegister);
 S.RegisterDelphiFunction(@FindResource, 'FindResource', CdStdCall);
 S.RegisterDelphiFunction(@LoadResource, 'LoadResource', CdStdCall);
 S.RegisterDelphiFunction(@SizeofResource, 'SizeofResource', CdStdCall);
 S.RegisterDelphiFunction(@LockResource, 'LockResource', CdStdCall);
 S.RegisterDelphiFunction(@UnlockResource, 'UnlockResource', CdStdCall);
 S.RegisterDelphiFunction(@FreeResource, 'FreeResource', CdStdCall);
 S.RegisterDelphiFunction(@AttemptToUseSharedMemoryManager, 'AttemptToUseSharedMemoryManager', cdRegister);
 S.RegisterDelphiFunction(@ShareMemoryManager, 'ShareMemoryManager', cdRegister);

 S.RegisterDelphiFunction(@SendAppMessage, 'SendAppMessage', cdRegister);
S.RegisterDelphiFunction(@MoveWindowOrg, 'MoveWindowOrg', cdRegister);
S.RegisterDelphiFunction(@IsDragObject, 'IsDragObject', cdRegister);
S.RegisterDelphiFunction(@IsVCLControl, 'IsVCLControl', cdRegister);
S.RegisterDelphiFunction(@FindControl, 'FindControl', cdRegister);
S.RegisterDelphiFunction(@FindVCLWindow, 'FindVCLWindow', cdRegister);
S.RegisterDelphiFunction(@FindDragTarget, 'FindDragTarget', cdRegister);
S.RegisterDelphiFunction(@GetCaptureControl, 'GetCaptureControl', cdRegister);
S.RegisterDelphiFunction(@SetCaptureControl, 'SetCaptureControl', cdRegister);
S.RegisterDelphiFunction(@CancelDrag, 'CancelDrag', cdRegister);
S.RegisterDelphiFunction(@CursorToString, 'CursorToString', cdRegister);
S.RegisterDelphiFunction(@StringToCursor, 'StringToCursor', cdRegister);
S.RegisterDelphiFunction(@CursorToIdent, 'CursorToIdent', cdRegister);
S.RegisterDelphiFunction(@IdentToCursor, 'IdentToCursor', cdRegister);
S.RegisterDelphiFunction(@PerformEraseBackground, 'PerformEraseBackground', cdRegister);
S.RegisterDelphiFunction(@ChangeBiDiModeAlignment, 'ChangeBiDiModeAlignment', cdRegister);
//3.7
S.RegisterDelphiFunction(@LoadPackage, 'LoadPackage', cdRegister);
S.RegisterDelphiFunction(@UnLoadPackage, 'UnLoadPackage', cdRegister);
S.RegisterDelphiFunction(@GetPackageDescription, 'GetPackageDescription', cdRegister);
S.RegisterDelphiFunction(@InitializePackage, 'InitializePackage', cdRegister);
S.RegisterDelphiFunction(@FinalizePackage, 'FinalizePackage', cdRegister);
S.RegisterDelphiFunction(@GDAL, 'GDAL', cdRegister);
S.RegisterDelphiFunction(@RCS, 'RCS', cdRegister);
S.RegisterDelphiFunction(@RPR, 'RPR', cdRegister);
//3.8
S.RegisterDelphiFunction(@SendMessage, 'SendMessage', CdStdCall);
S.RegisterDelphiFunction(@SendMessage, 'SendMessage2', cdRegister);
S.RegisterDelphiFunction(@PostMessage, 'PostMessage', CdStdCall);
S.RegisterDelphiFunction(@FloatToDecimal, 'FloatToDecimal', cdRegister);
// S.RegisterDelphiFunction(@SendMessageTimeout, 'SendMessageTimeout', CdStdCall);
// S.RegisterDelphiFunction(@SendMessageCallback, 'SendMessageCallback', CdStdCall);
 {S.RegisterDelphiFunction(@OpenProcessToken, 'OpenProcessToken', CdStdCall);
 S.RegisterDelphiFunction(@OpenThreadToken, 'OpenThreadToken', CdStdCall);
 S.RegisterDelphiFunction(@PrivilegeCheck, 'PrivilegeCheck', CdStdCall);
 S.RegisterDelphiFunction(@RevertToSelf, 'RevertToSelf', CdStdCall);
 //S.RegisterDelphiFunction(@SetThreadToken, 'SetThreadToken', CdStdCall);
 //S.RegisterDelphiFunction(@AccessCheck, 'AccessCheck', CdStdCall);
 S.RegisterDelphiFunction(@SetFileApisToOEM, 'SetFileApisToOEM', CdStdCall);
 S.RegisterDelphiFunction(@SetFileApisToANSI, 'SetFileApisToANSI', CdStdCall);
 S.RegisterDelphiFunction(@AreFileApisANSI, 'AreFileApisANSI', CdStdCall);}

//S.RegisterDelphiFunction(@LoadLibrary, 'LoadLibrary', CdStdCall);
//S.RegisterDelphiFunction(@FreeLibrary, 'FreeLibrary', CdStdCall);
S.RegisterDelphiFunction(@queryPerformanceCounter, 'queryPerformanceCounter',CdStdCall);
S.RegisterDelphiFunction(@queryPerformanceCounter, 'queryPerformanceCounter2',cdRegister);
S.RegisterDelphiFunction(@QueryPerformanceFrequency,'QueryPerformanceFrequency',CdStdCall);
S.RegisterDelphiFunction(@queryPerformanceCounter1, 'queryPerformanceCounter1',cdRegister);
S.RegisterDelphiFunction(@QueryPerformanceFrequency1,'QueryPerformanceFrequency1',cdRegister);

S.RegisterDelphiFunction(@IsAssembly, 'IsAssembly', cdRegister);
S.RegisterDelphiFunction(@GetThreadLocale, 'GetThreadLocale', CdStdCall);
S.RegisterDelphiFunction(@GetModuleFileName, 'GetModuleFileName', CdStdCall);
S.RegisterDelphiFunction(@GetCommandLine, 'GetCommandLine', CdStdCall);
S.RegisterDelphiFunction(@ExitThread, 'ExitThread', CdStdCall);
S.RegisterDelphiFunction(@ExitProcess, 'ExitProcess', CdStdCall);
S.RegisterDelphiFunction(@CharNext, 'CharNext', cdRegister);
S.RegisterDelphiFunction(@RaiseException, 'RaiseException2', CdStdCall);
S.RegisterDelphiFunction(@windows.GetFileSize, 'GetFileSize2', CdStdCall);
//check all CdStdCall
//S.RegisterDelphiFunction(@GetSystemTime, 'GetSystemTime', cdRegister);
 S.RegisterDelphiFunction(@GetSystemTime, 'GetSystemTime', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemTimeAsFileTime, 'GetSystemTimeAsFileTime', CdStdCall);
 S.RegisterDelphiFunction(@SetSystemTime, 'SetSystemTime', CdStdCall);
 S.RegisterDelphiFunction(@GetLocalTime, 'GetLocalTime', CdStdCall);
 S.RegisterDelphiFunction(@SetLocalTime, 'SetLocalTime', CdStdCall);
 S.RegisterDelphiFunction(@GetSystemInfo, 'GetSystemInfo', CdStdCall);
 S.RegisterDelphiFunction(@IsProcessorFeaturePresent, 'IsProcessorFeaturePresent', CdStdCall);
S.RegisterDelphiFunction(@CloseHandle, 'CloseHandle', CdStdCall);
S.RegisterDelphiFunction(@GetStdHandle, 'GetStdHandle', CdStdCall);
//S.RegisterDelphiFunction(@RtlUnwind, 'RtlUnwind', cdRegister);
S.RegisterDelphiFunction(@SetEndOfFile, 'SetEndOfFile', CdStdCall);
S.RegisterDelphiFunction(@windows.FindClose, 'FindCloseW', CdStdCall);
  S.RegisterDelphiFunction(@Windows.FindClose, 'WFindClose', CdStdCall);
S.RegisterDelphiFunction(@GetCurrentThreadID, 'GetCurrentThreadID', cdStdCall);
S.RegisterDelphiFunction(@LoadLibraryEx, 'LoadLibraryEx', CdStdCall);
S.RegisterDelphiFunction(@windows.LoadString, 'LoadString', CdStdCall);
 S.RegisterDelphiFunction(@CreateThread2, 'CreateThread2', CdStdCall);
 S.RegisterDelphiFunction(@CreateThread, 'CreateThread', CdStdCall);
 S.RegisterDelphiFunction(@CreateThread1, 'CreateThread1', CdStdCall);
  S.RegisterDelphiFunction(@FindFirstFile, 'FindFirstFile', CdStdCall);
 S.RegisterDelphiFunction(@SearchPath, 'SearchPath', CdStdCall);
 S.RegisterDelphiFunction(@SystemTimeToFileTime, 'SystemTimeToFileTime', CdStdCall);
 S.RegisterDelphiFunction(@FileTimeToLocalFileTime, 'FileTimeToLocalFileTime', CdStdCall);
 S.RegisterDelphiFunction(@LocalFileTimeToFileTime, 'LocalFileTimeToFileTime', CdStdCall);
 S.RegisterDelphiFunction(@FileTimeToSystemTime, 'FileTimeToSystemTime', CdStdCall);
 S.RegisterDelphiFunction(@CompareFileTime, 'CompareFileTime', CdStdCall);
 S.RegisterDelphiFunction(@FileTimeToDosDateTime, 'FileTimeToDosDateTime', CdStdCall);
 S.RegisterDelphiFunction(@DosDateTimeToFileTime, 'DosDateTimeToFileTime', CdStdCall);


 //S.RegisterDelphiFunction(@CreateRemoteThread, 'CreateRemoteThread', CdStdCall);
 S.RegisterDelphiFunction(@GetCurrentThread, 'GetCurrentThread', CdStdCall);
 //S.RegisterDelphiFunction(@GetCurrentThreadId, 'GetCurrentThreadId', CdStdCall);
 {S.RegisterDelphiFunction(@SetThreadAffinityMask, 'SetThreadAffinityMask', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadIdealProcessor, 'SetThreadIdealProcessor', CdStdCall);
 S.RegisterDelphiFunction(@SetProcessPriorityBoost, 'SetProcessPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetProcessPriorityBoost, 'GetProcessPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadPriority, 'SetThreadPriority', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadPriority, 'GetThreadPriority', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadPriorityBoost, 'SetThreadPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadPriorityBoost, 'GetThreadPriorityBoost', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadTimes, 'GetThreadTimes', CdStdCall); }
 S.RegisterDelphiFunction(@ExitThread, 'ExitThread', CdStdCall);
 S.RegisterDelphiFunction(@EndThread, 'EndThread', CdStdCall);
 S.RegisterDelphiFunction(@TerminateThread, 'TerminateThread', CdStdCall);
 S.RegisterDelphiFunction(@GetExitCodeThread, 'GetExitCodeThread', CdStdCall);
 S.RegisterDelphiFunction(@WaitForSingleObject, 'WaitForSingleObject', CdStdCall);
 S.RegisterDelphiFunction(@MakeProcInstance, 'MakeProcInstance', cdRegister);
 S.RegisterDelphiFunction(@FreeProcInstance, 'FreeProcInstance', cdRegister);
 S.RegisterDelphiFunction(@AddAtom, 'AddAtom', CdStdCall);
 S.RegisterDelphiFunction(@FindAtom, 'FindAtom', CdStdCall);
 S.RegisterDelphiFunction(@Succeeded, 'Succeeded', cdRegister);
 S.RegisterDelphiFunction(@Failed, 'Failed', cdRegister);
 S.RegisterDelphiFunction(@IsError, 'IsError', cdRegister);
 S.RegisterDelphiFunction(@SmallPointToPoint, 'SmallPointToPoint', cdRegister);
 S.RegisterDelphiFunction(@PointToSmallPoint, 'PointToSmallPoint', cdRegister);
 S.RegisterDelphiFunction(@MakeWParam, 'MakeWParam', cdRegister);
 S.RegisterDelphiFunction(@MakeLParam, 'MakeLParam', cdRegister);
 S.RegisterDelphiFunction(@MakeLResult, 'MakeLResult', cdRegister);
 S.RegisterDelphiFunction(@PointToLParam, 'PointToLParam', cdRegister);
 S.RegisterDelphiFunction(@WaitMessage, 'WaitMessage', CdStdCall);
 S.RegisterDelphiFunction(@WaitForInputIdle, 'WaitForInputIdle', CdStdCall);
 S.RegisterDelphiFunction(@DefWindowProc, 'DefWindowProc', CdStdCall);
 S.RegisterDelphiFunction(@ExpandEnvironmentStrings, 'ExpandEnvironmentStrings', CdStdCall);
 S.RegisterDelphiFunction(@OutputDebugString, 'OutputDebugString', CdStdCall);
 S.RegisterDelphiFunction(@InitializeCriticalSection, 'InitializeCriticalSection', CdStdCall);
 S.RegisterDelphiFunction(@EnterCriticalSection, 'EnterCriticalSection', CdStdCall);
 S.RegisterDelphiFunction(@LeaveCriticalSection, 'LeaveCriticalSection', CdStdCall);
 S.RegisterDelphiFunction(@InitializeCriticalSectionAndSpinCount, 'InitializeCriticalSectionAndSpinCount', CdStdCall);
 S.RegisterDelphiFunction(@SetCriticalSectionSpinCount, 'SetCriticalSectionSpinCount', CdStdCall);
 S.RegisterDelphiFunction(@TryEnterCriticalSection, 'TryEnterCriticalSection', CdStdCall);
 S.RegisterDelphiFunction(@DeleteCriticalSection, 'DeleteCriticalSection', CdStdCall);
 S.RegisterDelphiFunction(@GetThreadContext, 'GetThreadContext', CdStdCall);
 S.RegisterDelphiFunction(@SetThreadContext, 'SetThreadContext', CdStdCall);
 S.RegisterDelphiFunction(@SuspendThread, 'SuspendThread', CdStdCall);
 S.RegisterDelphiFunction(@ResumeThread, 'ResumeThread', CdStdCall);
 //S.RegisterDelphiFunction(@EndThread, 'EndThread', CdStdCall);
 S.RegisterDelphiFunction(@GlobalFree, 'GlobalFree', CdStdCall);
 S.RegisterDelphiFunction(@GlobalCompact, 'GlobalCompact', CdStdCall);
 S.RegisterDelphiFunction(@GlobalFix, 'GlobalFix', CdStdCall);
 S.RegisterDelphiFunction(@GlobalUnfix, 'GlobalUnfix', CdStdCall);
 S.RegisterDelphiFunction(@GlobalUnfix, 'GlobalUnfix', CdStdCall);
 S.RegisterDelphiFunction(@DrawEdge, 'DrawEdge', CdStdCall);
 S.RegisterDelphiFunction(@DrawFrameControl, 'DrawFrameControl', CdStdCall);
 S.RegisterDelphiFunction(@DrawCaption, 'DrawCaption', CdStdCall);
 S.RegisterDelphiFunction(@DrawAnimatedRects, 'DrawAnimatedRects', CdStdCall);

 //S.RegisterDelphiFunction(@SysFreeString, 'SysFreeString', cdRegister);
//S.RegisterDelphiFunction(@SysStringLen, 'SysStringLen', cdRegister);
S.RegisterDelphiFunction(@RemoveDirectory, 'RemoveDirectory', CdStdCall);
S.RegisterDelphiFunction(@SetCurrentDirectory, 'SetCurrentDirectory', CdStdCall);
//S.RegisterDelphiFunction(@GetSysColor, 'GetSysColor', CdStdCall);
S.RegisterDelphiFunction(@IsVariantManagerSet, 'IsVariantManagerSet', CdStdCall);

 S.RegisterDelphiFunction(@CancelDC, 'CancelDC', CdStdCall);
 S.RegisterDelphiFunction(@Chord, 'Chord', CdStdCall);
 //S.RegisterDelphiFunction(@ChoosePixelFormat, 'ChoosePixelFormat', CdStdCall);
 S.RegisterDelphiFunction(@CloseMetaFile, 'CloseMetaFile', CdStdCall);
 S.RegisterDelphiFunction(@CombineRgn, 'CombineRgn', CdStdCall);
 S.RegisterDelphiFunction(@CopyMetaFile, 'CopyMetaFile', CdStdCall);
 //S.RegisterDelphiFunction(@CopyMetaFileA, 'CopyMetaFileA', CdStdCall);
 //S.RegisterDelphiFunction(@CopyMetaFileW, 'CopyMetaFileW', CdStdCall);
 S.RegisterDelphiFunction(@CreateBitmap, 'CreateBitmap', CdStdCall);
 S.RegisterDelphiFunction(@CreateBitmapIndirect, 'CreateBitmapIndirect', CdStdCall);
 //S.RegisterDelphiFunction(@CreateBrushIndirect, 'CreateBrushIndirect', CdStdCall);
 S.RegisterDelphiFunction(@CreateCompatibleBitmap, 'CreateCompatibleBitmap', CdStdCall);
 S.RegisterDelphiFunction(@CreateDiscardableBitmap, 'CreateDiscardableBitmap', CdStdCall);
 S.RegisterDelphiFunction(@CreateCompatibleDC, 'CreateCompatibleDC', CdStdCall);
 //S.RegisterDelphiFunction(@CreateDC, 'CreateDC', CdStdCall);
 S.RegisterDelphiFunction(@RoundRect, 'RoundRectA', CdStdCall);
 S.RegisterDelphiFunction(@ResizePalette, 'ResizePalette', CdStdCall);
 S.RegisterDelphiFunction(@SaveDC, 'SaveDC', CdStdCall);
 S.RegisterDelphiFunction(@SelectClipRgn, 'SelectClipRgn', CdStdCall);
 S.RegisterDelphiFunction(@ExtSelectClipRgn, 'ExtSelectClipRgn', CdStdCall);
 S.RegisterDelphiFunction(@SetMetaRgn, 'SetMetaRgn', CdStdCall);
 S.RegisterDelphiFunction(@SelectObject, 'SelectObject', CdStdCall);
 S.RegisterDelphiFunction(@SelectPalette, 'SelectPalette', CdStdCall);
 S.RegisterDelphiFunction(@SetBkColor, 'SetBkColor', CdStdCall);
 S.RegisterDelphiFunction(@SetDCBrushColor, 'SetDCBrushColor', CdStdCall);
 S.RegisterDelphiFunction(@SetDCPenColor, 'SetDCPenColor', CdStdCall);
 S.RegisterDelphiFunction(@SetBkMode, 'SetBkMode', CdStdCall);
 S.RegisterDelphiFunction(@SetBitmapBits, 'SetBitmapBits', CdStdCall);
 S.RegisterDelphiFunction(@DeleteObject, 'DeleteObject', CdStdCall);
 S.RegisterDelphiFunction(@CreateRectRgn, 'CreateRectRgn', CdStdCall);
 S.RegisterDelphiFunction(@CreateRectRgnIndirect, 'CreateRectRgnIndirect', CdStdCall);
 S.RegisterDelphiFunction(@CreateRoundRectRgn, 'CreateRoundRectRgn', CdStdCall);
 S.RegisterDelphiFunction(@GetUpdateRect, 'GetUpdateRect', CdStdCall);
 S.RegisterDelphiFunction(@GetUpdateRect, 'GetUpdateRect', CdStdCall);
 S.RegisterDelphiFunction(@GetUpdateRgn, 'GetUpdateRgn', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowRgn, 'SetWindowRgn', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowRgn, 'GetWindowRgn', CdStdCall);
 S.RegisterDelphiFunction(@ExcludeUpdateRgn, 'ExcludeUpdateRgn', CdStdCall);
 //S.RegisterDelphiFunction(@InvalidateRect, 'InvalidateRect', CdStdCall);
 S.RegisterDelphiFunction(@ValidateRect, 'ValidateRect', CdStdCall);
 S.RegisterDelphiFunction(@InvalidateRgn, 'InvalidateRgn', CdStdCall);
 S.RegisterDelphiFunction(@ValidateRgn, 'ValidateRgn', CdStdCall);
 S.RegisterDelphiFunction(@RedrawWindow, 'RedrawWindow', CdStdCall);
// S.RegisterDelphiFunction(@GetKerningPairs, 'GetKerningPairs', CdStdCall);
 S.RegisterDelphiFunction(@GetDCOrgEx, 'GetDCOrgEx', CdStdCall);
 S.RegisterDelphiFunction(@UnrealizeObject, 'UnrealizeObject', CdStdCall);
 S.RegisterDelphiFunction(@GdiFlush, 'GdiFlush', CdStdCall);
 S.RegisterDelphiFunction(@GdiSetBatchLimit, 'GdiSetBatchLimit', CdStdCall);
 S.RegisterDelphiFunction(@GdiGetBatchLimit, 'GdiGetBatchLimit', CdStdCall);
 S.RegisterDelphiFunction(@WNetAddConnection, 'WNetAddConnection', CdStdCall);
 S.RegisterDelphiFunction(@mxbutton, 'mXButton', CdRegister);
 S.RegisterDelphiFunction(@GetResourceName, 'GetResourceName', cdRegister);
 S.RegisterDelphiFunction(@WriteObjectResourceHeader, 'WriteObjectResourceHeader', cdRegister);
 S.RegisterDelphiFunction(@Write16bitResourceHeader, 'Write16bitResourceHeader', cdRegister);
 S.RegisterDelphiFunction(@Write32bitResourceHeader, 'Write32bitResourceHeader', cdRegister);
 S.RegisterDelphiFunction(@GetSysColor, 'GetSysColor', CdStdCall);
 S.RegisterDelphiFunction(@GetSysColorBrush, 'GetSysColorBrush', CdStdCall);
 S.RegisterDelphiFunction(@DrawFocusRect, 'DrawFocusRect', CdStdCall);
 S.RegisterDelphiFunction(@FillRect, 'FillRect', CdStdCall);
 S.RegisterDelphiFunction(@FrameRect, 'FrameRect', CdStdCall);
 S.RegisterDelphiFunction(@InvertRect, 'InvertRect', CdStdCall);
 S.RegisterDelphiFunction(@SetRect, 'SetRect', CdStdCall);
 S.RegisterDelphiFunction(@SetRectEmpty, 'SetRectEmpty', CdStdCall);
 S.RegisterDelphiFunction(@CopyRect, 'CopyRect', CdStdCall);
 S.RegisterDelphiFunction(@InflateRect, 'InflateRect', CdStdCall);
 S.RegisterDelphiFunction(@Windows.IntersectRect, 'IntersectRect2', CdStdCall);
 //S.RegisterDelphiFunction(@Windows.UnionRect, 'UnionRect2', CdStdCall);
 S.RegisterDelphiFunction(@SubtractRect, 'SubtractRect', CdStdCall);
 S.RegisterDelphiFunction(@IdentToInt, 'IdentToInt', CdStdCall);
 S.RegisterDelphiFunction(@IntToIdent, 'IntToIdent', CdStdCall);
 S.RegisterDelphiFunction(@LogicalAnd, 'LogicalAnd', cdRegister);
 S.RegisterDelphiFunction(@SetFileAttributes, 'SetFileAttributes', CdStdCall);
 S.RegisterDelphiFunction(@GetFileAttributes, 'GetFileAttributes', CdStdCall);
 S.RegisterDelphiFunction(@GetFileInformationByHandle, 'GetFileInformationByHandle', CdStdCall);
 S.RegisterDelphiFunction(@myraise, 'raise', CdRegister);
 S.RegisterDelphiFunction(@GetWindowText, 'GetWindowText', CdStdCall);
 //S.RegisterDelphiFunction(@RedrawWindow, 'RedrawWindow', CdStdCall);
 S.RegisterDelphiFunction(@SleepEx, 'SleepEx', CdStdCall);
//from forms
S.RegisterDelphiFunction(@KeysToShiftState, 'KeysToShiftState', cdRegister);
S.RegisterDelphiFunction(@KeyDataToShiftState, 'KeyDataToShiftState', cdRegister);
S.RegisterDelphiFunction(@KeyboardStateToShiftState1, 'KeyboardStateToShiftState', cdRegister);
S.RegisterDelphiFunction(@KeyboardStateToShiftState2, 'KeyboardStateToShiftState2', cdRegister);

 S.RegisterDelphiFunction(@TryStrToInt, 'TryStrToInt', cdRegister);
 S.RegisterDelphiFunction(@TryStrToInt64, 'TryStrToInt64', cdRegister);

 S.RegisterDelphiFunction(@GetMessage, 'GetMessage', CdStdCall);
 S.RegisterDelphiFunction(@DispatchMessage, 'DispatchMessage', CdStdCall);
 S.RegisterDelphiFunction(@TranslateMessage, 'TranslateMessage', CdStdCall);
 S.RegisterDelphiFunction(@SetMessageQueue, 'SetMessageQueue', CdStdCall);
 S.RegisterDelphiFunction(@PeekMessage, 'PeekMessage', CdStdCall);
 //S.RegisterDelphiFunction(@RegisterHotKey, 'RegisterHotKey', CdStdCall);
 //S.RegisterDelphiFunction(@UnregisterHotKey, 'UnregisterHotKey', CdStdCall);
 //S.RegisterDelphiFunction(@ExitWindows, 'ExitWindows', cdRegister);
 //S.RegisterDelphiFunction(@ExitWindowsEx, 'ExitWindowsEx', CdStdCall);
 //S.RegisterDelphiFunction(@SwapMouseButton, 'SwapMouseButton', CdStdCall);
 S.RegisterDelphiFunction(@GetMessagePos, 'GetMessagePos', CdStdCall);
 S.RegisterDelphiFunction(@GetMessageTime, 'GetMessageTime', CdStdCall);
 S.RegisterDelphiFunction(@GetMessageExtraInfo, 'GetMessageExtraInfo', CdStdCall);
 //S.RegisterDelphiFunction(@SetMessageExtraInfo, 'SetMessageExtraInfo', CdStdCall);
 //S.RegisterDelphiFunction(@SendMessage, 'SendMessage', CdStdCall);

 S.RegisterDelphiFunction(@MessageBeep, 'MessageBeep', CdStdCall);
 S.RegisterDelphiFunction(@ShowCursor, 'ShowCursor', CdStdCall);
 S.RegisterDelphiFunction(@SetCursorPos, 'SetCursorPos', CdStdCall);
 S.RegisterDelphiFunction(@SetCursor, 'SetCursor', CdStdCall);
 S.RegisterDelphiFunction(@GetCursorPos, 'GetCursorPos', CdStdCall);
 S.RegisterDelphiFunction(@ClipCursor, 'ClipCursor', CdStdCall);
 S.RegisterDelphiFunction(@GetClipCursor, 'GetClipCursor', CdStdCall);
 S.RegisterDelphiFunction(@GetCursor, 'GetCursor', CdStdCall);
 S.RegisterDelphiFunction(@CreateCaret, 'CreateCaret', CdStdCall);
 S.RegisterDelphiFunction(@GetCaretBlinkTime, 'GetCaretBlinkTime', CdStdCall);
 S.RegisterDelphiFunction(@SetCaretBlinkTime, 'SetCaretBlinkTime', CdStdCall);
 S.RegisterDelphiFunction(@DestroyCaret, 'DestroyCaret', CdStdCall);
 S.RegisterDelphiFunction(@HideCaret, 'HideCaret', CdStdCall);
 S.RegisterDelphiFunction(@ShowCaret, 'ShowCaret', CdStdCall);
 S.RegisterDelphiFunction(@SetCaretPos, 'SetCaretPos', CdStdCall);
 S.RegisterDelphiFunction(@GetCaretPos, 'GetCaretPos', CdStdCall);
 S.RegisterDelphiFunction(@ClientToScreen, 'ClientToScreen', CdStdCall);
 S.RegisterDelphiFunction(@ScreenToClient, 'ScreenToClient', CdStdCall);
 S.RegisterDelphiFunction(@MapWindowPoints, 'MapWindowPoints', CdStdCall);
 S.RegisterDelphiFunction(@WindowFromPoint, 'WindowFromPoint', CdStdCall);
 S.RegisterDelphiFunction(@ChildWindowFromPoint, 'ChildWindowFromPoint', CdStdCall);
 S.RegisterDelphiFunction(@ChildWindowFromPointEx, 'ChildWindowFromPointEx', CdStdCall);
  S.RegisterDelphiFunction(@GetWindowWord, 'GetWindowWord', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowWord, 'SetWindowWord', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowLong, 'GetWindowLong', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowLong, 'SetWindowLong', CdStdCall);
 S.RegisterDelphiFunction(@GetClassWord, 'GetClassWord', CdStdCall);
 S.RegisterDelphiFunction(@SetClassWord, 'SetClassWord', CdStdCall);
 S.RegisterDelphiFunction(@GetClassLong, 'GetClassLong', CdStdCall);
 S.RegisterDelphiFunction(@SetClassLong, 'SetClassLong', CdStdCall);
 S.RegisterDelphiFunction(@GetDesktopWindow, 'GetDesktopWindow', CdStdCall);
 S.RegisterDelphiFunction(@GetParent, 'GetParent', CdStdCall);
 S.RegisterDelphiFunction(@SetParent, 'SetParent', CdStdCall);
 S.RegisterDelphiFunction(@GetClassName, 'GetClassName', CdStdCall);
 S.RegisterDelphiFunction(@GetTopWindow, 'GetTopWindow', CdStdCall);
 S.RegisterDelphiFunction(@GetNextWindow, 'GetNextWindow', CdStdCall);
 //S.RegisterDelphiFunction(@GetWindowThreadProcessId, 'GetWindowThreadProcessId', CdStdCall);
 //S.RegisterDelphiFunction(@GetWindowThreadProcessId, 'GetWindowThreadProcessId', CdStdCall);
 S.RegisterDelphiFunction(@GetWindowTask, 'GetWindowTask', cdRegister);
 S.RegisterDelphiFunction(@GetLastActivePopup, 'GetLastActivePopup', CdStdCall);
 S.RegisterDelphiFunction(@GetWindow, 'GetWindow', CdStdCall);
 S.RegisterDelphiFunction(@PostQuitMessage, 'PostQuitMessage', CdStdCall);
 S.RegisterDelphiFunction(@InSendMessage, 'InSendMessage', CdStdCall);
 S.RegisterDelphiFunction(@InSendMessageEx, 'InSendMessageEx', CdStdCall);
 S.RegisterDelphiFunction(@GetDoubleClickTime, 'GetDoubleClickTime', CdStdCall);
 S.RegisterDelphiFunction(@SetDoubleClickTime, 'SetDoubleClickTime', CdStdCall);
 S.RegisterDelphiFunction(@AddTerminateProc, 'AddTerminateProc', cdRegister);
 S.RegisterDelphiFunction(@CallTerminateProcs, 'CallTerminateProcs', cdRegister);
 S.RegisterDelphiFunction(@ExitWindows, 'ExitWindows', cdRegister);
 S.RegisterDelphiFunction(@ExitWindowsEx, 'ExitWindowsEx', CdStdCall);
 S.RegisterDelphiFunction(@SwapMouseButton, 'SwapMouseButton', CdStdCall);
 S.RegisterDelphiFunction(@SetMessageExtraInfo, 'SetMessageExtraInfo', CdStdCall);
// S.RegisterDelphiFunction(@DomToTree, 'DomToTree', CdRegister);
   S.RegisterDelphiFunction(@wvsprintf, 'wvsprintf', CdStdCall);
  S.RegisterDelphiFunction(@wsprintf, 'wsprintf', CdStdCall);
  S.RegisterDelphiFunction(@getprocesslist, 'getProcessList', CdStdCall);
  S.RegisterDelphiFunction(@keybd_event, 'keybd_event', CdStdCall);
 S.RegisterDelphiFunction(@mouse_event, 'mouse_event', CdStdCall);
 S.RegisterDelphiFunction(@OemKeyScan, 'OemKeyScan', CdStdCall);
 S.RegisterDelphiFunction(@GET_APPCOMMAND_LPARAM, 'GET_APPCOMMAND_LPARAM', CdStdCall);
 S.RegisterDelphiFunction(@GET_DEVICE_LPARAM, 'GET_DEVICE_LPARAM', CdStdCall);
 S.RegisterDelphiFunction(@GET_MOUSEORKEY_LPARAM, 'GET_MOUSEORKEY_LPARAM', CdStdCall);
 S.RegisterDelphiFunction(@GET_FLAGS_LPARAM, 'GET_FLAGS_LPARAM', CdStdCall);
 S.RegisterDelphiFunction(@GET_KEYSTATE_LPARAM, 'GET_KEYSTATE_LPARAM', CdStdCall);
  S.RegisterDelphiFunction(@GlobalMemoryStatus, 'GlobalMemoryStatus', CdStdCall);
 S.RegisterDelphiFunction(@LocalAlloc, 'LocalAlloc', CdStdCall);
 S.RegisterDelphiFunction(@CreateEvent, 'CreateEvent', CdStdCall);
 S.RegisterDelphiFunction(@LocalReAlloc, 'LocalReAlloc', CdStdCall);
 S.RegisterDelphiFunction(@LocalLock, 'LocalLock', CdStdCall);
 S.RegisterDelphiFunction(@LocalUnlock, 'LocalUnlock', CdStdCall);
 S.RegisterDelphiFunction(@LocalSize, 'LocalSize', CdStdCall);
 S.RegisterDelphiFunction(@LocalFlags, 'LocalFlags', CdStdCall);
 S.RegisterDelphiFunction(@LocalFree, 'LocalFree', CdStdCall);
 S.RegisterDelphiFunction(@LocalShrink, 'LocalShrink', CdStdCall);
 S.RegisterDelphiFunction(@LocalCompact, 'LocalCompact', CdStdCall);
 S.RegisterDelphiFunction(@SetFocus, 'SetFocus', CdStdCall);
 S.RegisterDelphiFunction(@GetActiveWindow, 'GetActiveWindow', CdStdCall);
 S.RegisterDelphiFunction(@GetFocus, 'GetFocus', CdStdCall);
 S.RegisterDelphiFunction(@GetKBCodePage, 'GetKBCodePage', CdStdCall);
 S.RegisterDelphiFunction(@GetKeyState, 'GetKeyState', CdStdCall);
 S.RegisterDelphiFunction(@GetAsyncKeyState, 'GetAsyncKeyState', CdStdCall);
 S.RegisterDelphiFunction(@GetKeyboardState, 'GetKeyboardState', CdStdCall);
 S.RegisterDelphiFunction(@SetKeyboardState, 'SetKeyboardState', CdStdCall);
 S.RegisterDelphiFunction(@IsWindow, 'IsWindow', CdStdCall);
 S.RegisterDelphiFunction(@IsMenu, 'IsMenu', CdStdCall);
 S.RegisterDelphiFunction(@IsChild, 'IsChild', CdStdCall);
 S.RegisterDelphiFunction(@DestroyWindow, 'DestroyWindow', CdStdCall);
 S.RegisterDelphiFunction(@ShowWindow, 'ShowWindow', CdStdCall);
 S.RegisterDelphiFunction(@AnimateWindow, 'AnimateWindow', CdStdCall);
 S.RegisterDelphiFunction(@ShowWindowAsync, 'ShowWindowAsync', CdStdCall);
 S.RegisterDelphiFunction(@FlashWindow, 'FlashWindow', CdStdCall);
  S.RegisterDelphiFunction(@ShowOwnedPopups, 'ShowOwnedPopups', CdStdCall);
 S.RegisterDelphiFunction(@OpenIcon, 'OpenIcon', CdStdCall);
 S.RegisterDelphiFunction(@CloseWindow, 'CloseWindow', CdStdCall);
 S.RegisterDelphiFunction(@MoveWindow, 'MoveWindow', CdStdCall);
 S.RegisterDelphiFunction(@SetWindowPos, 'SetWindowPos', CdStdCall);
 //S.RegisterDelphiFunction(@GetWindowPlacement, 'GetWindowPlacement', CdStdCall);
 //S.RegisterDelphiFunction(@SetWindowPlacement, 'SetWindowPlacement', CdStdCall);
 //S.RegisterDelphiFunction(@BeginDeferWindowPos, 'BeginDeferWindowPos', CdStdCall);
 //S.RegisterDelphiFunction(@DeferWindowPos, 'DeferWindowPos', CdStdCall);
 //S.RegisterDelphiFunction(@EndDeferWindowPos, 'EndDeferWindowPos', CdStdCall);
 S.RegisterDelphiFunction(@IsWindowVisible, 'IsWindowVisible', CdStdCall);
 S.RegisterDelphiFunction(@IsIconic, 'IsIconic', CdStdCall);
 S.RegisterDelphiFunction(@AnyPopup, 'AnyPopup', CdStdCall);
 S.RegisterDelphiFunction(@BringWindowToTop, 'BringWindowToTop', CdStdCall);
 S.RegisterDelphiFunction(@IsZoomed, 'IsZoomed', CdStdCall);
 S.RegisterDelphiFunction(@IsWindowUnicode, 'IsWindowUnicode', CdStdCall);
 S.RegisterDelphiFunction(@EnableWindow, 'EnableWindow', CdStdCall);
 S.RegisterDelphiFunction(@IsWindowEnabled, 'IsWindowEnabled', CdStdCall);
  S.RegisterDelphiFunction(@loadForm, 'loadForm', CdRegister);
  S.RegisterDelphiFunction(@loadForm, 'getForm', CdRegister);
 S.RegisterDelphiFunction(@paintprocessingstar2, 'paintprocessingstar2', CdRegister);

    //S.RegisterDelphiFunction(@system.Addr, 'Addr', CdStdCall);
  // CL.AddDelphiFunction('function Addr(Varname: string ): ___Pointer;');
 { procedure SysFreeString(const S: WideString); stdcall;
  external oleaut name 'SysFreeString';
function SysStringLen(const S: WideString): Integer; stdcall;
  external oleaut name 'SysStringLen';}
//   procedure RtlUnwind; stdcall;
 //procedure ChangeBiDiModeAlignment(var Alignment: TAlignment);
                       //makeintresource

{$DEFINE DEBUG_FUNCTIONS}
//S.RegisterDelphiFunction(@System.FindObjects,'FindObjects', cdRegister);
{$UNDEF DEBUG_FUNCTIONS}

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EWin32Error(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EWin32Error) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EOSError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EOSError) do begin
    RegisterPropertyHelper(@EOSErrorErrorCode_R,@EOSErrorErrorCode_W,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EStackOverflow(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EStackOverflow) do
  begin
  end;
end;

procedure RIRegister_EInvalidPassword(CL: TPSRuntimeClassImporter);
begin
  //with CL.Add(EInvalidPassword) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EExternal(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EExternal) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EInOutError(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInOutError) do begin
    RegisterPropertyHelper(@EInOutErrorErrorCode_R,@EInOutErrorErrorCode_W,'ErrorCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_EHeapException(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EHeapException) do
  begin
  end;
end;

procedure RIRegister_EInvalidOperation(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(EInvalidOperation) do begin
   RegisterMethod(@EInvalidOperation.Free, 'Free');
   RegisterConstructor(@EInvalidOperation.CreateRes, 'CreateRes');
    RegisterConstructor(@EInvalidOperation.CreateFMT, 'CreateFmt');
   //RegisterConstructor(@ExceptionCreateRes_P, 'CreateRes1');
    //RegisterConstructor(@ExceptionCreateRes_P, 'CreateRes');
    RegisterConstructor(@ExceptionCreateResHelp_P, 'CreateResHelp');
    //RegisterConstructor(@ExceptionCreateResHelp_P, 'CreateResHelp');
    RegisterConstructor(@EInvalidOperation.CreateHelp, 'CreateHelp');
    RegisterPropertyHelper(@ExceptionHelpContext_R,@ExceptionHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@ExceptionMessage_R,@ExceptionMessage_W,'Message');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_Exception(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(Exception) do begin
    RegisterConstructor(@Exception.Create, 'Create');
    RegisterMethod(@Exception.Free, 'Free');
     RegisterConstructor(@Exception.CreateRes, 'CreateRes');
    RegisterConstructor(@Exception.CreateFMT, 'CreateFmt');
   //RegisterConstructor(@ExceptionCreateRes_P, 'CreateRes1');
    //RegisterConstructor(@ExceptionCreateRes_P, 'CreateRes');
    RegisterConstructor(@ExceptionCreateResHelp_P, 'CreateResHelp');
    //RegisterConstructor(@ExceptionCreateResHelp_P, 'CreateResHelp');
    RegisterConstructor(@Exception.CreateHelp, 'CreateHelp');
    RegisterPropertyHelper(@ExceptionHelpContext_R,@ExceptionHelpContext_W,'HelpContext');
    RegisterPropertyHelper(@ExceptionMessage_R,@ExceptionMessage_W,'Message');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TLanguages(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TLanguages) do begin
    RegisterConstructor(@TLanguages.Create, 'Create');
    RegisterMethod(@TLanguages.IndexOf, 'IndexOf');
    RegisterPropertyHelper(@TLanguagesCount_R,nil,'Count');
    RegisterPropertyHelper(@TLanguagesName_R,nil,'Name');
    RegisterPropertyHelper(@TLanguagesNameFromLocaleID_R,nil,'NameFromLocaleID');
    RegisterPropertyHelper(@TLanguagesNameFromLCID_R,nil,'NameFromLCID');
    RegisterPropertyHelper(@TLanguagesID_R,nil,'ID');
    RegisterPropertyHelper(@TLanguagesLocaleID_R,nil,'LocaleID');
    RegisterPropertyHelper(@TLanguagesExt_R,nil,'Ext');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SysUtils(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TStopwatch(CL);
  RIRegister_TLanguages(CL);
  RIRegister_Exception(CL);
  RIRegister_TTextStream(CL);

  with CL.Add(EAbort) do
  RIRegister_EHeapException(CL);
  with CL.Add(EOutOfMemory) do
  RIRegister_EInOutError(CL);
  RIRegister_EExternal(CL);
  with CL.Add(EExternalException) do
  with CL.Add(EIntError) do
  with CL.Add(EDivByZero) do
  with CL.Add(ERangeError) do
  with CL.Add(EIntOverflow) do
  with CL.Add(EMathError) do
  with CL.Add(EInvalidOp) do
  with CL.Add(EZeroDivide) do
  with CL.Add(EOverflow) do
  with CL.Add(EUnderflow) do
  with CL.Add(EInvalidPointer) do
  with CL.Add(EInvalidCast) do
  with CL.Add(EConvertError) do
  //with CL.Add(EInvalidPassword) do
  with CL.Add(EAccessViolation) do
  with CL.Add(EPrivilege) do
  RIRegister_EStackOverflow(CL);
  RIRegister_EInvalidPassword(CL);
  with CL.Add(EControlC) do
  with CL.Add(EVariantError) do
  with CL.Add(EPropReadOnly) do
  with CL.Add(EPropWriteOnly) do
  with CL.Add(EAssertionFailed) do
  with CL.Add(EIntfCastError) do
  with CL.Add(EInvalidContainer) do
  with CL.Add(EInvalidInsert) do
  with CL.Add(EPackageError) do
  RIRegister_EOSError(CL);
  RIRegister_EWin32Error(CL);
  with CL.Add(ESafecallException) do
end;


{ TPSImport_SysUtils }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.CompOnUses(CompExec: TPSScript);
begin
  { nothing }
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.ExecOnUses(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SysUtils(CompExec.Comp);
  //SIRegister_TTextStream(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.CompileImport2(CompExec: TPSScript);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SysUtils(ri);
  RIRegister_SysUtils_Routines(CompExec.Exec); // comment it if no routines
  //RIRegister_TTextStream(ri);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SysUtils.ExecImport2(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  { nothing }
end;
 

end.
