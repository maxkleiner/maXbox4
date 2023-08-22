unit MultilangTranslator;
(*
   Author: kleiner kommunikation
           Kleiner, armasuisse
           max@kleiner.com
   Date:  Mai 2003
          juni 2005, resources, pascal analyzer, spain extension
          juli 2006, Max Kleiner Framework FIS-HE
          aug  2006  set Spain, more comps., resolve update problem
          sep  2006 dynamic change in same form on instance
          Jan 2007 samll changes for Lazarus 0.9
          Sep 2007 extended with dll loading
          Oct 2007 profiling, Linux testing
          locs= 390, 11.10.2007

    Description:
    Changing the language of strings(caption, hint, lines ...) of controls on
    a form to a particular language. The Tag property of the controls has to
    be set to values corresponding with the according resource strings.
    Leaving a Tag value 0 means that the caption of the according control
    isn't changed. Note that languages are distinguished by an offset of a
    multiple of 1000. For instance german is 0, English has an offset of 1000,
    French has one of 2000 and Italian's is 3000.

    Extract of a resource file *.rc:
    STRINGTABLE
{
    3, "Arbeiten im Team"
    1003, "work in team1"
    2003, "travailler en groupe"
    3003, "lavorare nel gruppo"
    4003, "trabajo en equipo"
}
    In this case to a Tag of a control which should show this text in the proper
    language we have to assign the value 3. Can be done with the ObjInspector.

    Currently TMultilangSC supports the controls in :
       procedure ChangeComponent(theComponent: TComponent;
                                  const theLanguageOffset : integer);
    This concept can be easily extended to other controls not listed
    in procedure ChangeComponent.
    Languages string are assigned to the particular captions after a forms
    has been loaded from the resources. However its possible to use
    the function GetResourceString at any time to load language dependend
    strings from the language resource file. This is especially necessary
    if TMultiLangSC is used independendly from a TForm.
    Caller example:
      objMultilang:= TMultiLangSC.Create(self);
      objMultilang.ResDLL:= 'reslang2.dll'; // in case of resDLL
      objMultilang.LanguageOffset:=  2000;  // in case of French

   Version: 1.6, Implementation with Component linking or by runtime
*)

interface

uses
  Windows, SysUtils, Classes;

type
  tLangChanging = procedure(Sender: TObject; theComponent: TComponent) of object;
  tLangChanged = procedure(Sender: TObject) of object;

  TMultiLangSC = class(TComponent)
  private
    fLanguage: integer;
    fResDLL: string;
    fResDLLHandle: tHandle;
    sDLLState: boolean;
    fOnLangChanging: tLangChanging;
    fOnLangChanged: tLangChanged;
    procedure SetLanguage(const Value: integer);
    procedure ChangeLanguage(const LanguageOffset: integer);
    procedure ChangeComponent(theComponent: TComponent;
                                const theLanguageOffset : integer);
    function GetTopComponent: TComponent;
    function IsOSMultilanguage: boolean;
    function GetActualSystemLanguage: word;
  protected
    //Loaded Initializes the component after the form file has been
    //read into memory.
    procedure Loaded; override;
    procedure setResDLL(const sDLLPath: ansiString);
  public
    constructor Create(AOwner: TComponent); override;
    function GetResourceString(const number: integer): string;
    function currentLanguage: integer;
    function currentSystemLanguage(mylid:word): integer;
    function currentUserLanguage: integer;
    property LanguageOffset: integer read fLanguage write SetLanguage;
    property ResDLL: string read fResDLL write setResDLL;
  published
    {change of published names since version 1.5}
    property OnLangChanging: tLangChanging read fOnLangChanging write fOnLangChanging;
    property OnLangChanged: tLangChanged read fOnLangChanged write fOnLangChanged;
  end;

procedure Register;

  //var objMultilang: TMultilangSC;

implementation

Uses Registry, Forms, StdCtrls, ComCtrls, ExtCtrls, Menus, Buttons;
// START resource string wizard section

resourcestring
  SSecLangDep_Kernel32Dll = 'kernel32.dll';
  SSecLangDep_Language = 'Language';
  SSecLangDep_SecureCenterXP = 'SecureCenterXP';
  SSecLangDep_SOFTWAREGSTSecureCenterXP = '\SOFTWARE\GST\SecureCenterXP';

// END resource string wizard section


procedure Register;
begin
  RegisterComponents(SSecLangDep_SecureCenterXP, [TMultiLangSC]);
end;

{ TMultiLangSC}

constructor TMultiLangSC.Create(AOwner: TComponent);
// this creates an instance of TSecureLanguageDepenend and initializes
// its member variables.
begin
  inherited;
  fLanguage:= 0;
  fOnLangChanging:= NIL;
  fOnLangChanged:= NIL;
  // static linking resources
  sDLLState:= false;
end;

function TMultiLangSC.currentLanguage: integer;
// this function reads from the registry the current language
// use for SecureCenterXP. It returns the base index to the
// the according language strings. A particular string then
// can be accessed adding its offset to this base value.
var
  rReg: TRegistry;
  languageStr: string;
begin
  rReg:= TRegistry.Create;
  languageStr:= '?';
  try
    with rReg do begin
      try
        RootKey:= HKEY_LOCAL_MACHINE;
        OpenKeyReadOnly(SSecLangDep_SOFTWAREGSTSecureCenterXP);
        languageStr:= ReadString(SSecLangDep_Language);
      except
      end;
    end;
  finally
    rReg.Free;
  end;
  if languageStr <> '' then begin
     case languageStr[1] of
       'D': Result:=0;
       'E': Result:=1000;
       'F': Result:=2000;
       'I': Result:=3000;
       'S': result:=4000;
     else
       Result:= 0;
     end;
  end
   else
    Result:= 0;
end;

procedure TMultilangSC.SetLanguage(const Value: integer);
// changes the language of a component tree (usually a form)
begin
  fLanguage:= Value;
  if not (csLoading in ComponentState) then
    ChangeLanguage(fLanguage);
end;

procedure TMultilangSC.setResDLL(const sDLLPath: ansiString);
const
  badDLLload = 1;
begin
  fResDLL:= sDLLPath;
  //private handle
  fResDLLHandle:= loadLibrary(pchar(sDLLPath));
  if fResDLLHandle <= badDLLload then begin
    messageBox(0,'no langauage_dll loaded','Multilang DLL',MB_ICONERROR);
    sDLLState:= false;
  end else
    sDLLState:= true;
end;

function TMultilangSC.GetResourceString(const number : integer) : string;
// reads a string from the resource file. As a parameter this function takes the
// offset of the string relative to the base index fLanguage.
// compile with {-Sd}
var pP: array[0..255] of char;
begin
   //state event
  if sDLLState then HInstance:= fResDLLHandle;
  if LoadString(HInstance, number + fLanguage, pP, sizeof(pP))>0 then
    result:= pP
  else
    result:= '';
end;

function TMultilangSC.GetTopComponent: TComponent;
// searches upwards through a tree of components until its root is found
// or a component is of type TForm.
var x: TComponent;
begin
  x:= Self;
  Result:= x; // prevent compiler warning
  while (Assigned(x)) and not (x is TForm) do begin
    Result:= x;
    x:= x.Owner;
  end;
  if Assigned(x) then
    Result:= x;
end;

procedure TMultilangSC.ChangeLanguage(const languageOffset: integer);
// this method changes the language of a component tree, if we are not in design mode.
// after the whole tree of components has been change the event fOnLanguageChanged is
// called, if a value has been assigned to it. This give the client the opportunity
// to do his own language specific text assignments using GetResourceString.
begin
  if not (csDesigning in ComponentState) then begin
     ChangeComponent(GetTopComponent, LanguageOffset);
     if Assigned(fOnLangChanged) then
       fOnLangChanged(Self);
  end;
end;

procedure TMultilangSC.ChangeComponent(theComponent: TComponent;
                             const theLanguageOffset: integer);
// this function changes the language of the components text fields recursively.
// for every component an event fOnLanguageChanging is called if a handler was
// assigned to it. This gives the client the opportunity to do additional language
// specific treatments on a component level. If for instance a component is a grid,
// the client can use this event to test whether this grid is the current processed
// component and if true he could use the opportunity to change column or
// row names using GetResourceString
var x : integer;
begin
  if theComponent.ComponentCount > 0 then begin
    for x:= 0 to theComponent.ComponentCount-1 do
      ChangeComponent(theComponent.Components[x], theLanguageOffset);
  end;
  if theComponent.tag <> 0 then begin
    if (theComponent is TForm) then
      (theComponent as TForm).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TLabel) then
      (theComponent as TLabel).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TCheckBox) then
      (theComponent as TCheckBox).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TToolButton) then
      (theComponent as TToolButton).Hint:= GetResourceString(theComponent.tag)
    else if (theComponent is TButton) then
      (theComponent as TButton).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TRadioButton) then
      (theComponent as TRadioButton).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TGroupBox) then
      (theComponent as TGroupBox).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TPanel) then
      (theComponent as TPanel).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TTabSheet) then
      (theComponent as TTabSheet).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TMenuItem) then
      (theComponent as TMenuItem).Caption:= GetResourceString(theComponent.tag)
    else if (theComponent is TImage) then
      (theComponent as TImage).Hint:= GetResourceString(theComponent.tag)
    else if (theComponent is TRadioGroup) then
      (theComponent as TRadioGroup).caption:=
                                       GetResourceString(theComponent.tag);
    if Assigned(fOnLangChanging) then
      fOnLangChanging(Self, theComponent);
  end;
end;

procedure TMultilangSC.Loaded;
begin
  inherited;
  LanguageOffset:= currentLanguage;
end;

function TMultilangSC.currentSystemLanguage(mylid: word): integer;
begin
  case mylid of
      // german dialects
        $0407, {German (Standard)}
        $0807, {German (Switzerland)}
        $0c07, {German (Austria)}
        $1007, {German (Luxembourg)}
        $1407: {German (Liechtenstein)}
                Result := 0;
      // french dialects
        $040c, { French (Standard)}
        $080c, { French (Belgian)}
        $0c0c, { French (Canadian)}
        $100c, { French (Switzerland)}
        $140c, { French (Luxembourg)}
        $180c: { Windows 98/Me, Windows 2000/XP: French (Monaco)}
                Result := 2000;
      // english dialects
        $0409, {  English (United States)}
        $0809, {  English (United Kingdom)}
        $0c09, {  English (Australian)}
        $1009, {  English (Canadian)}
        $1409, {  English (New Zealand)}
        $1809, {  English (Ireland)}
        $1c09, {  English (South Africa)}
        $2009, {  English (Jamaica)}
        $2409, {  English (Caribbean)}
        $2809, {  English (Belize)}
        $2c09, {  English (Trinidad)}
        $3009, {  Windows 98/Me, Windows 2000/XP: English (Zimbabwe)}
        $3409: {  Windows 98/Me, Windows 2000/XP: English (Philippines)}
                Result := 1000;
        $0410, {  Italian (Standard)}
        $0810: {  Italian (Switzerland)}
                Result := 3000;
           //LANG_SPANISH = $0a;
         //{$EXTERNALSYM LANG_SPANISH}
          //$01;    { Spanish (Castilian)
        $040a:
                result:= 4000;
   else
    Result:= 0;
  end;
end;

function TMultilangSC.currentUserLanguage: integer;
var
  lid: word;
begin
  if self.IsOSMultilanguage then begin
    //Nur für Multilanguage Plattformen wie: W2K, XP, Win2003, etc.
    lid:= self.GetActualSystemLanguage;
    result:= currentSystemLanguage(lid)
  end
  else begin
    //Für alle andern Plattfomen wie: Win95, Win98, ME, NT
    lid:= GetSystemDefaultLangID;
    result:= currentSystemLanguage(lid);
  end;
end;

function TMultilangSC.IsOSMultilanguage: boolean;
var
  aOsInfo: TOSVersionInfo;
begin
  aOsInfo.dwOSVersionInfoSize:= SizeOf(TOSVersionInfo);
  GetVersionEx(aOsInfo);
  if aOsInfo.dwMajorVersion >= 5 then //Grösser als 5 ist W2K oder XP oder 2003
    result:= true
  else
    result:= false;
end;

//function GetUserDefaultUILanguage:word; stdcall; external 'kernel32.dll';
function TMultilangSC.GetActualSystemLanguage: Word;
type
  FunctionWithDWORDReturnValue = function: DWORD; stdcall;
var
  libInstance: HINST;
  GetUserDefaultUILanguage: FunctionWithDWORDReturnValue;
begin
  //result := GetUserDefaultUILanguage;
  result:= 0;
  libInstance:= LoadLibrary('kernel32.dll');
  try
    if libInstance <> 0 then begin
      GetUserDefaultUILanguage:= GetProcAddress(libInstance, 'GetUserDefaultUILanguage');
      Result:= GetUserDefaultUILanguage;
    end;
  finally
    FreeLibrary(libInstance);
  end;
end;

initialization
  //objMultilang:= TMultiLangSC.Create(NIL);

finalization
  //objMultilang.Free;

end.
