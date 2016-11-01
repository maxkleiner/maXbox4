{ $HDR$   on progress...}
{**********************************************************************}
{ #head:Max: MAXBOX10: 05/06/2016 14:05:45 C:\maXbox\maxbox3\maxbox3\maXbox3\examples\698_new_classes_tester.pas 
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.softwareschule.ch                                         }
{**********************************************************************}
{}
{ $Log:  10063: IdAntiFreeze.pas #sign:Max: MAXBOX10: 05/06/2016 14:05:45 
{
{   Rev 1.0    2002.11.12 10:29:54 PM  czhower
        1.1    2016 tester for maXbox
        1.2    2016 add classes 
}
unit IdAntiFreeze;

{$DEFINE MSWINDOWS}

{
NOTE - This unit must NOT appear in any Indy uses clauses. This is a ONE way relationship
and is linked in IF the user uses this component. This is done to preserve the isolation from the
massive FORMS unit.
}

interface

{uses
  Classes,
  IdAntiFreezeBase,
  IdBaseComponent;    }
{Directive needed for C++Builder HPP and OBJ files for this that will force it
to be statically compiled into the code}

//{$I IdCompilerDefines.inc}

{$IFDEF MSWINDOWS}

//{$HPPEMIT '#pragma link "IdAntiFreeze.obj"'}    {Do not Localize}

{$ENDIF}

{$IFDEF LINUX}

//{$HPPEMIT '#pragma link "IdAntiFreeze.o"'}    {Do not Localize}

{$ENDIF}
//type
  //TIdAntiFreeze = class(TIdAntiFreezeBase)
  //public
    procedure Process; //override;
  //end;

  var ApplicationHasPriority: boolean;
      GAntiFreeze: TIdAntiFreezeBase; // = nil;

implementation

(*uses
{$IFDEF LINUX}
  QForms;
{$ENDIF}
{$IFDEF MSWINDOWS}
  Forms,
  Messages,
  Windows;
{$ENDIF}
  *)
{$IFDEF LINUX}
procedure TIdAntiFreeze.Process;
begin
  //TODO: Handle ApplicationHasPriority
  Application.ProcessMessages;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure Process;
var
  Msg: TMsg;
begin
  if ApplicationHasPriority then begin
    Application.ProcessMessages;
  end else begin
    // This guarantees it will not ever call Application.Idle
    if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then begin
      Application.HandleMessage;
    end;
  end;
end;

{class} function TIdAntiFreezeBase_ShouldUse: boolean;
begin
  // InMainThread - Only process if calling client is in the main thread
  Result := (GAntiFreeze <> nil) and InMainThread;
  if Result then begin
    Result := GAntiFreeze.Active;
  end;
end;

function Base64DecodeIndy(const EncodedText: string): string;
//TBytes;
var
  DecodedStm: TBytesStream;
  Decoder: TIdDecoderMIME;
  aba: TBytes;
begin
  Decoder := TIdDecoderMIME.Create(nil);
  try
    DecodedStm := TBytesStream.Create(aba);
    try
      //decoder.version;
      //Decoder.DecodeBegin(DecodedStm);
      Decoder.DecodeToString(EncodedText);
      //Decoder.DecodeEnd;
      //Result := DecodedStm.Bytes;
      result:= Decoder.DecodeToString(EncodedText);
    finally
      DecodedStm.Free;
    end;
  finally
    //Decoder.Free;
  end;
end;


function Base64EncodeIndy(const EncodedText: string): string;
//TBytes;
var
  DecodedStm: TBytesStream;
  Decoder: TIdEncoderMIME;
  astr: TStream; //TStringStream;
  aba: TBytes;
begin
  Decoder := TIdEncoderMIME.Create(nil);
  try
    DecodedStm := TBytesStream.Create(aba);
    try
      astr:= TStringStream.create(''); //('');
      savestringtostream(EncodedText,astr);
      writeln(itoa(astr.size));
      //result:= Decoder.Encode1(astr, length(astr.size));
      result:= Decoder.Encode(EncodedText);
      writeln(decoder.codingtable)
      //result:= Decoder.Encode('astr, length(astr.size');

    finally
      DecodedStm.Free;
      astr.Free;
    end;
  finally
  
    //Decoder.Free;
  end;
end;


function VariantIsObject(const V: Variant): Boolean;
begin
  Result := {Variants.}VarIsType(V, varDispatch)
    or {Variants.}VarIsType(V, varUnknown);
end;

function IsUnicodeStream(const Stm: TStream): Boolean;
var
  StmPos: LongInt;      // current position in stream
  BOM: Word;            // Unicode byte order mark
begin
  // Record current location in stream
  StmPos := Stm.Position;
  // Check if stream large enough to contain BOM (empty text file contains only
  // the BOM)
  if StmPos <= Stm.Size - SizeOf(BOM) then
  begin
    // Read first word and check if it is the unicode marker
    //Stm.ReadBuffer(BOM, SizeOf(BOM));
    Result := (BOM = $FEFF);
    // Restore stream positions
    Stm.Position := StmPos;
  end
  else
    // Stream too small: can't be unicode
    Result := False;
end;

function UnicodeFileToWideString(const FileName: string): WideString;
var
  FS: {Classes.}TFileStream;  // Stream onto file
begin
  FS := TFileStream.Create(
    FileName, fmOpenRead or fmShareDenyNone);
  try
    //Result := UnicodeStreamToWideString(FS);
  finally
    FS.Free;
  end;
end;

function TaskbarHandle: THandle;
begin
  Result := FindWindow('Shell_TrayWnd', 'nil');
end;

function TrayHandle: THandle;
begin
  Result := FindWindowEx(TaskbarHandle, 0, 'TrayNotifyWnd', 'nil');
end;

const
  cWdwCurrentVer = '\Software\Microsoft\Windows\CurrentVersion';

function GetCurrentVersionRegStr(const ValName: string): string;
begin
  Result := GetRegistryString(
    HKEY_LOCAL_MACHINE,
    cWdwCurrentVer,
    ValName
  );
end;

function ProgramFilesFolder: string;
begin
  Result := GetCurrentVersionRegStr('ProgramFilesDir');
end;

function GetRegistryString2(const RootKey: HKEY;
  const SubKey, Name: string): string;
var
  Reg: TRegistry;          // registry access object
  ValueInfo: TRegDataInfo; // info about registry value
begin
  Result := '';
  // Open registry at required root key
  Reg := TRegistry.Create;
  try
    Reg.RootKey := RootKey;
    // Open registry key and check value exists
    if Reg.OpenKeyReadOnly(SubKey)
      and Reg.ValueExists(Name) then begin
      // Check if registry value is string or integer
      Reg.GetDataInfo(Name, ValueInfo);
      case ValueInfo.RegData of
        rdString, rdExpandString:
          // string value: just return it
          Result := Reg.ReadString(Name);
        rdInteger:
          // integer value: convert to string
          Result := {SysUtils.}IntToStr(Reg.ReadInteger(Name));
        else
          // unsupported value: raise exception
          raise; //Exception.Create(
            //'Unsupported registry type'
          //);
      end;
    end;
  finally
    // Close registry
    Reg.Free;
  end;
end;

{$ENDIF}

  var aday:TStDayType; 
      akd: TKEditKey;
      akcommand: TKEditCommand;
      acommass: TKEditCommandAssignment;
      //idbase: TIdBaseComponent;
      aspstack: TKMemoSparseStack;

begin  //main
  ApplicationHasPriority:= true;
  Process;
  //class procedure DoProcess(const AIdle: boolean = true; const AOverride: boolean = false);
  with TIdAntiFreeze.create(self) do begin
    writeln(botostr(shoulduse));
    //DoProcess(true, false)
    active:= false;
    writeln('id vers: '+version)
    Free;
    //TIdBaseComponent().Free
  end; 
  
  with TIdThreadSafeStringList.create(true) do begin
    Add('coolcode!')
    lock;
    unlock;
    Free
  end;  
  
  //TIdBaseComponent missing
  { with TIdCustomThreadComponent.create(self) do begin
    Add('coolcode!')
    lock;
    unlock;
    Free
  end;    }
  
  with TIdThreadMgr.create(self) do begin
    //getthread
    free
  end;  
 
  with TIdBasicAuthentication.create do begin
    //Add('coolcode!§')
    writeln('Authentication: '+Authentication)
    //lock;
    //unlock;
    writeln(version)
    Free
  end;   
 
  
  with TKEditKeyMapping.create do begin
    EmptyMap;
    //Assign(TStringlist.create)
    //FindCommand  §
    //TKEditCommand(self).AddKey
   //&&key;
   //map;
  free
  end;
  
  with TKMemoDictionary.create do begin
    //EmptyMap;
    //Assign
    //FindCommand
    //TKEditCommand(self).AddKey
   //key;
   //map;
   AddItem(12,1234567{'coolcode!§})
   FindItem(12);
   writeln(itoa(items[0].value))
  free
  end;
  
  aday:= monday;   
  aday:= Wednesday;
  writeln(itoa(ord(aday)))  
  
  writeln(ProgramFilesFolder)
  //foldwraptext
  
   writeln(Base64DecodeIndy('SEkhIEhFTExPIFdPUkxEIE9GIENSWVBUT0JPWCAzIQ=='))
   writeln(Base64EncodeIndy('SEkhIEhFTExPIFdPUkxEIE9GIENSWVBUT0JPWCAzIQ=='))
   writeln(Base64EncodeIndy('HI! HELLO WORLD OF CRYPTOBOX 3!'))
   writeln(Base64DecodeIndy(Base64EncodeIndy('HI! HELLO WORLD OF CRYPTOBOX 3!')))
   
   //SetCustomFormGlassFrame
   
   application.UnhookSynchronizeWakeup;
 
  
   with TGlassFrame.create(nil) do begin
     sheetofglass:= true;
     free
   end;  
   
   writeln(CompressWhiteSpace('An intro    duction in  coding with maXbox'))
   
   writeln('StrbuftoHEX_1: '+buftohex('An intro    duction in  coding with maXbox',length('An intro    duction in  coding with maXbox')))
   
   sr:= 'An intro    duction in  coding with maXbox';
   writeln('StrbuftoHEX_2: '+buftohex(sr, length(sr)))
   //procedure HexToBuf(HexStr: string; var Buf: string);
   sr:= 'An intro    duction in  coding with maXbox';
   Hextobuf(buftohex(sr, length(sr)),sr);
   writeln(sr)
   
   //DOSexec
   
   //IsShellLink
   
   //StringsToMultiSz
 //  SysImageListHandle
 //SetTimeZoneInformation
 
// IsProcessorFeaturePresent
   //SetVolumeName
   AreFileApisANSI
   //WaitNamedPipe
   //SetFileApisToOEM
   //CancelIo
//   GetOldestEventLogRecord
//  DeregisterEventSource 
//  NotifyChangeEventLog 
   
   
end.

//https://www.metadefender.com/#!/results/file/d18f22811efc40c2825bd49d18783bce/regular

{An introduction in coding with maXbox the script engine. The tool is build on a precompiled object based scripting library.
The tool is also based on an educational program with examples and exercises (from biorhythm, form builder to how encryption and network works). Units are precompiled and objects invokable!}

{1.1 Command with Macros 
1.2 Extend with DLL
1.3 Alias Naming 
1.4 Console Capture DOS 
1.5 Byte Code Performance 
1.6 Exception Handling 
1.7 Config Ini File
1.8 The Log Files 
1.9 Use Case Model
1.10 Open Tool API
                  }