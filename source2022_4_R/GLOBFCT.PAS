{ ****************************************************************
  Sourcefile     :  Globfct.PAS
  Typ            :  Non Form-Unit
  Compiler       :  Delphi 1.2
  Betriebssystem :  Win95
  Beschreibung   :  Globals for Library and Synchronise
  Classes        :  TCWObj
Autor:  kleiner 
Revisionen     :  25.04.96 Import/Export
                    1.10.96 Global FirstLoadReference
                    1.11.96 sl CWObj um die Methode CopyRecTmplorFix(ObjTable:TTable;FirstField:Longint);
                            erweitert. Diese erledigt das Herstellen eines ersten Records gemäss Tmpl
                            oder dann halt gemäss dem "UrRecord" der immer die ObjNr 1 und gegebenenfalls
                            die Seq bzw KompCount 0 trägt.
                            Zudem diverse Methoden für das Handling mit CWGrids & Edits hier zentralisiert.
                    4.11.96 pg TStati und TStatusSet sowie div Konstanten eingefügt .
                    5.11.96 sl TKey und TKeySet eingefügt.
                   13.11.96 pg TCLParam und TCLParamSet eingefügt. Aufbau in Initialization
                   10.02.97 fvTablleStrich sowie Routine RHK
                   19.03.97 PackTable to reorg the base
 **************************************************************** }

unit Globfct;


interface


uses DB, DBTables, SysUtils, WinProcs, WinTypes,
         DBITypes, DBIProcs, DBIErrs,  Forms, classes, CWedit, Controls,
         Graphics, GlobPJ, DBCtrls ;

const

  CW_EXE_VERSION = 1;


  ST_SHORT = 40 ;   { Länge eines "kurzen durchschnittlichen" Strings}
  ST_DELIMCONCATSTR = '; ' ;

  (*CW_LNG = 0 ;     { Sprache des *.exe; später als Compiler-Direktive }*)
  CW_MAXLNG = 2 ;  { Nummer der höchsten Sprache }
  cw_Table_Owner : String = 'CALWIN.';  { kann mit prUserIsSchema (/U) := User gesetzt werden }
  CW_PDX_EXT = '.DB' ;  { Extension für Pdx-Tables }
  ST_ID_STD = 0 ;   { StyleID für Standard-Stil }

  MIN_MAP_WIDTH = 818;
  MIN_MAP_HEIGHT = 489;

const
  lngScreenWidth: LongInt = 1024; {I designed forms in 1024x768 mode.}
  lngScreenHeight: LongInt = 768;


const CW_DISPLAY  = ',##0';
      CW_DISPLAYTAIL = ';;''''';


  WQ_MAX = 1000;

  Attr1 = 32;     {Formatiert einen CW-Wert auf 2 Kommastellen}
  Attr2 = 6176;   {CalcField,uebersteuert,2 Kommast}
  Attr3 = 4128;   {CalcField,2Kommas}
  Attr4 = 4144;   {CalcField,3Kommas}
  Attr5 = 48;     {3Kommas}
  Attr6 = 4096;   {CalcField,0Kommas}
  Attr7 = 0;      {Nichts mit Null}
  Attr8 = 16;     {Eine Kommastelle}
  Attr9 = 3;      {Auf Hunderter ohne Komma}
  DefaultObj = 1; {Das ist die Nummer des eingebrannten Obj's}
  crHourGlass = -11;
  crDefault = 0;



  ALIAS          = 'CWBASEII';
  FirstLoad: boolean = true;    { no iniWrite without load}



  pageFirst      = 0;      { 1. Seite des Notebooks        }
  pageTabelle    = 0;      { Konstanten für die Seiten des }
  pageAdresse    = 1;      { tTabbedNoteBook »NoteBook«    }
  pageBemerkung  = 2;
  pageSuchTab    = 3;
  pageSuchAdr    = 4;
  pageKalender   = 5;
  pageTermine    = 6;
  pageLast       = pageTermine;   { letzte Seite d. Noteb. }

  paramIcon      = '/ICON';{ Parameter: iconisiert starten }

  { Konstantenstrings für die Anzeige des Wochentags       }
  Weekdays : array[1..7] of string[10] =
           ('Sonntag', 'Montag', 'Dienstag', 'Mittwoch',
           'Donnerstag', 'Freitag', 'Samstag');

  { Konstantenstrings für die Anzeige des Monatsnamen      }
  Months: array[1..12] of string[9] =
         ('Januar',  'Februar',  'März',   'April', 'Mai',
          'Juni',    'Juli',     'August', 'September',
          'Oktober', 'November', 'Dezember');


   { Konstanten für Rückgabewert von WizDlg }
   mrWDReload = mrAll+1 ;
   mrWDDelDim = mrAll+2 ;
   mrWDNewDim = mrAll+3 ;


 type

  Domaene = LongInt;

  TFooClass = Class(TControl);      {for relative resolution}


  TStati = Byte;
  TStatusSet = set of TStati;



  Const
   stFehlt = 0;
   stVorhanden = 1;
   stUebersteuert = 3;

   stLGKNH = 10;
   stLGKSVIT = 11;
   stLGKVAS = 12;
   stLGKWohnen = 13;
   stLGKGewerbe = 14;
   stLGKIndustrie = 15;
   stLGKGemischt = 16;
   stLGKSteigRed = 17 ;

   stLWLWubst = 10;
   stLWRWubst = 11;
   stLWLWAubst = 12;
   stLWAusschluss = 13;


   stAWGVGVTab = 10;
   stAWGVVerf = 11;

   stGRSGRS = 10;
   stGRSLAGE = 11;

   stGBKKubisch = 10 ;
   stGBKHuelle = 11 ;
   stGBKGeschoss = 12 ;
   stGBKIndex = 13;
   stGBKFix = 14;


   stAARelAUbst = 10;
   stAAWirtAUbst = 11;
   stAAWMT = 12;
   stAATotUbst = 13;


   stNZWGBK = 10;

   stZWNull = 10;

   stMWMEUbst = 10;
   stMWNoDet = 11;

   stEWKSUbst = 10;

   stVWRWA = 10;
   stVWEWA = 11;

   stNNFIDFUbst = 10;
   stNNFKorrUbst = 11;
   stNNFHasKorr = 12;

   stVWKHasMultParz = 10;
   stVWKHasMultObj = 12;
   stVWkHasMultET = 13;
   stVWkHasBrr = 14;
   stVWKHasMultOT = 15 ;
   stVWKHasSist = 16 ;

   stGDHasMultParz = 10;
   stGDHasMultObj = 12;
   stGDHasMultET = 13;
   stGDHasBrr = 14;
   stGDHasMultOT = 15 ;
   stGDHasSist = 16 ;

   stGBParz = 10;

   stObjCapBKP3TableVorhanden = 100;

   SchTyp = 0;
   SzenTyp= 1;
   TmplTyp= 2;



 Const
    rwNBW    = 17;
    rwNBWVor = 18;
    rwNBWum  = 19;
    rwNBWBau = 20;


 Const
  {Domänen}
     DOMNBW = 29;
      DOMAA = 31;
      DOMZBW = 30;
      DOMZW = 28 ;
      DOMLW = 34 ;
      DOMRW = 35 ;
      DOMEW = 40 ;
      DOMAW = 6  ;
      DOMMW = 66;
      DOMME = 67;
      DOMVWKORR = 43 ;
      DOMGV = 7;
      DOMRR = 35;
      DOMLGK = 32;
      DOMKS = 39;
      DOMGewEW = 44;
      DOMWW = 41;
      DOMGBKOT = 8;
      DOMAAOT = 76;
      DOMFRM3 = 9;
      DOMBKP1ZBW = 10;
      DOMBKP2ZBW = 11;
      DOMBKP3ZBW = 12;
      DOMBKP4ZBW = 13;
      DOMBKP5ZBW = 14;
      DOMBKP9ZBW = 15;
      DOMBKP1aa = 16;
      DOMBKP2aa = 17;
      DOMBKP3aa = 18;
      DOMBKP4aa = 19;
      DOMBKP5aa = 20;
      DOMBKP9aa = 21;
      DOMBKP1NBW = 22;
      DOMBKP2NBW = 75;
      DOMBKP3NBW = 23;
      DOMBKP4NBW = 24;
      DOMBKP5NBW = 25;
      DOMBKP9NBW = 26;
      DOMEWET = 38;
      DOMMWET = 36;
      DOMMEET = 37;
      DOMVWGER = 42;
      DOMGEWRW = 45;
      DOMMWOBJ = 66;
      DOMMEOBJ = 67;



 type
  TEnv = (enInsert, enOverride) ;  { Achtung: Für jeden Zustand in CWMain
                                     eine Zeile in memEnv anlegen ! }
  TEnvSet = Set of TEnv ;

  TKey = (kyDim,kyObj,kySchatz,kyDocNode,kyTmplNode,kySite,kySTWEi,kyUT,kyGRS,
  kyBBB,kyTransakt,kyStyle,kyFmtVorl,kyGB,kyRW,kyVersion);
 {Ordinal-Typ für die diversen Keys in der GetKey-Table}
  TKeySet = Set of TKey;

  CWObjDelType = (Obj,Complete);
  CWObjDelSet = Set of CWObjDelType;

  TParam = (prNoSplash,prOracle,prEditStdStyle,prFranz,prItal,prSchemaHolder,prEditRW,prPGFurz1) ;
  TParams = Set Of TParam ;
  TParamMark = Array [TParam] Of String ;
  TLng = (lgDt,lgFr,lgIt) ;
const
  clParamMark: TParamMark = ('/N','/O','/S','/F','/I','/H','/R','/PGF1') ;
  clParamSep = '/' ;

Type

  TState = (cmRan,cmDestroying,    { CWMain }
            wzRan,wzDestroying,
            wzWorking,            { immer gesetzt, wenn eines der folgenden: }
            wzLoading,wzLoaded,wzUnloading,
            wzInssheeting,wzDelSheeting,
            wzNewDimming,wzDelDimming,
            dmRan, dmDestroying,             {DocMan}
            dmLoading, dmLoaded,
            dmDisplaying, dmDisplayed,
            dmUpdateing,
            ctRan, ctDestroying,             {Ctroller}
            ctLoading,ctLoaded,
            wdRan,                           {WizardDlg}
            tmRan,tmLoaded,                  {Tmpl: Loaded=Table pos.}
            fmRan,fmDestroying,
            fmLoading,fmLoaded,              {FlowMan}
            txRan,txDestroying,txActive,
            doRan,                          {DBOpen}
            gdRan,gdLoaded,                 {Grunddat: Loaded=Table. pos.}
            izRan,                           {Iazelen}
            ftRan,ftDestroying,             {FmtMan}
            ftLoading,ftLoaded,
            asRan,                            {Assi}
            jpJumpBack,                        {Jump retour möglich}
            obCopRecWorking,                    {while CopyRecTmplorFixing}
            SaveAsIng                           {while Save as...}
           ) ;
  TStates =  Set Of TState ;

  TSchID = Record
    SiteID: LongInt ;
    SchID: LongInt ;
  End ;

   TTmplID = Record
    TmplSiteID: LongInt ;
    TmplID: LongInt ;
  End ;

  TIaziID = Record
     SiteID: LongInt;
     TransaktID : LongInt;
  End;

{Die folgenden Typen beziehen sich auf den Austausch von Tabellen von CWObjs zum}
{Textteil}

type
  TNextStep = (nsTab,nsNewLine,nsEnd);
  TFmtvorl  = (fvUnknown,fvFliess,fvTabelle,fvTabHead,fvTabHeadSmall,
               fvHead1,fvHead2,fvHead3,fvHead4,fvHead5,
               fvHead6,fvHead7,fvHead8,fvHead9,fvHead10,
               fvSubTotal,fvTitel,fvTotalVW,fvFliessTotal,fvFliessEmpha,
               fvFliessEinzug,fvTabelleTotal,fvTabelleStrich,fvFliessZentriert,fvTabelleSmall);
type
  TTabAttr = Record
   Inhalt : String;
   Fmtvorl: TFmtvorl;
   Next   : TNextStep;
  end;

  PTabAttr =^TTabAttr;


{-------------------------Typendeklaration für Formate----------------}
type
  TFmtPage = Record
    Portrait: Boolean ;
    Width: Integer ;      { alle Werte in Twippers}
    Height: Integer ;
    Margins: TRect ;
    Kopf: Integer ;
    Fuss: Integer ;
  End ;

  PFmtPage = ^TFmtPage ;

  TFmtTab = Record
    nTabFlag: Byte ;     { LEFTTAB, RIGHTTAB, CENTERTAB, DECIMALTAB }
    wTabPos: Word ;      { Twips }
  End ;

  TFmtTabs = Array [0..NTABS-1] Of TFmtTab ;       {NTABS aus GlobPJ}

  PFmtTabs = ^TFmtTabs;

  TFmtFont = Record
    Font: TFont ;
    blAlign: Word ;        { FA_NOCOMMONS, FA_STANDARD, FA_SUPERSCRIPT, FA_SUBSCRIPT }
    blValue: Word ;
  End ;

Const
  IN_LEFT = 0 ;
  IN_RIGHT = 1 ;
  IN_FIRST = 2 ;
  IN_TOP = 3 ;
  IN_BOTTOM = 4 ;

  LS_PROP = 0 ;   { Ob Linespacing proportional oder fix ist }
  LS_FIX = 1 ;

  SCH_NIL : TSchID = (SiteId :-1;
                      SchId :-1);
Const
  TX_PHYSFIELDS = True ;    { Versuch mit Logischen Feldern, die markiert werden, für eindutige }

Type
  TLSp = Record
    Case Byte Of
      1: (L: LongInt) ;
      2: (LoWord: Word ;
          HiWord: Word );
      3: (LoInt: Integer ;
          HiInt: Integer );
  End ;

  TFmtPar = Record
    Format: Word ;   {TF_LEFT .. TF_BLOCK}
    Indents: Array [IN_LEFT .. IN_BOTTOM] Of Integer;
    LSKind: LongInt ;   { LS_PROP oder LS_FIX }
    Linespacing: Word ; { the Value in % or Twips }
    Uppercase: Boolean ;  { True, wenn Uppercase (nur für Headings) }
  End ;

  TFmtVorlage = Record     { eine Formatvorlage }
    Nr: LongInt ;
    ID : TFmtVorl ;
    BezD: String ;
    BezF: String ;
    BezI: String ;

    Font: TFmtFont ;
    Tabs: TFmtTabs ;    { nimmt die Tabulatoren auf }
    Par: TFmtPar ;
  End ;

  PFmtVorlage = ^TFmtVorlage ;

  TStrCompatSet = Set of 0..99 ;
  TNTabIDs = TStrCompatSet ;

{-------------------------Ende typendeklaration Formate-------------}

{ ------------------------Typen für den Austausch von Markierungen --}
Type
  TSelEls = (SEL_START,SEL_END) ;
  TSelection = Array[TSelEls] Of LongInt;
  PSelection = ^TSelection ;



{Typendeklaration für die Richtwerte}
type
  TRWId = (rwGBK,rwUT,rwGV,rwGVData);

type EKeyViolation = Class(Exception);
     EObjBase = Class ( Exception);

Type
  TCWOBj = class(TForm)
  private
   RobjNr:Longint;
   RobjArt:Longint;
   RDimNr:Longint;
   RDimArt:Longint;
   RRemoveable:Boolean;
  public
   constructor CreateObj(Aowner:TComponent;AObjNr,ADimNr,ADimArt,AVorlage:LongInt); virtual;
   destructor DestroyObj(Meth:CWObjDelSet); virtual; abstract;
   procedure RegisterImport(ImportList:Tlist); virtual;
   function Getstatus(ADimNr:LongInt): TStatusSet ; virtual; abstract;
   Function GetvalueR(Dom:Domaene;Dim:LongInt; var Status:Integer):Real; virtual; abstract;
   Function GetvalueS(Dom:Domaene;Dim:LongInt; var Status:Integer):String; virtual; abstract;
   Function ExportRecords:TStringList; virtual; abstract;
   Procedure ImportRecords(ImpRecords:TStringList); virtual; abstract;
   function GetDocTable(TableNr:Longint;DocTableList:TList;ADimNr:LongInt):Boolean; virtual;
   procedure CopyRecTmplorFix(ObjTable:TTable;FirstField,AVorlage,Seq:Longint);
   procedure CopyKompTable(aTable:TTable;aVorlage,aTargetObj:LongInt);
   function GetDefaultValue(ObjTable:TTable;aFieldName:String):Double;
   procedure Recalc; virtual; abstract;
   procedure Save;
   procedure SetinBrowseMode;
   Procedure PrepareToReParent ;
   property Objnr:Longint Read RObjNr write RObjNr;
   property Objart:Longint Read RObjArt write RObjArt;
   property Dimnr:Longint Read RDimnr Write RDimNr;
   property Dimart:Longint Read RDimArt write RDimArt;
   property Removeable : Boolean Read RRemoveable Default True;
   procedure CWObjExit(Sender : Tobject); virtual;
  end;


{Exemplare dieser Klasse benötigen die CWObjs zwecks Import von Werten aus anderen
 CWObjs}
 type
  TImport = Class(TObject)
  Public
   DimNr:Longint;
   Dom:LongInt;
   Ref:TCWObj;
  end;


  PtrImp= ^Timport ;

type               {Entspricht einer Gridzeile bzw. deren entspr. Record}
  RecRecord = Record
   GbkObj: TCWobj;
   AAObj : TCWobj;
  end;

  PRecRecord = ^RecRecord;


 type
   TAssiParams = Class(TObject)
   Public
    DimArt,Seq :LongInt;
    Bz : String;
   end;

 {Die nachfolgenden Definitionen enthalten die in CWMain benötigten Typen
  um ".Ini" Eintäge in einer Tabelle niederzuschreiben und zu lesen}
 type
  TUserPrefs = (upTxForm, upTxFormCtrlChars, upTxFormBar, upTxFormRuler, upTxFormStatus,  { fuer TextFenster }
                upCWForm, upCwLast, upCwSound, upCwHints,        { fuer Berechnungsfenster }
                upOptTitel, upOptExperteKurz, upOptExperte, upOptOrtDatum, upOptKopf,
                upOptFuss, upOptGVIndex, { fuer Optionen }
                upTranslation, { fuer Substitutionen }
                upObChce, {fuer Darstellung & Sortierung}
                upTmplStyle,
                upOpts,    { für Optionen - Einstellungen }
                upRW       {RW editierbar oder nicht}
                );


  TUserPrefsRec = Record
   Integer1,Integer2,Integer3,Integer4,Integer5:LongInt;
   Value1,Value2,Value3,Value4: Double;
   StringD : String;
   StringF : String;
   StringI : String;
   Bool  : Boolean;
  end;

PTUserPrefsRec = ^TuserPrefsRec;

{ ----- Typen und Konstanten für die Übersetzungen ausm Text ------ }
Const
  TR_MARK = '@' ;
  TR_SYMBOLDIMS = '@DA99@' ;        { DimensionsArt, werden in DocMan.Translate verarbeitet }
  TR_ESC = '@EC99@' ;               {Steuerzeichen}

 Type
  TtrItem = (trGV, trAW) ;         { In Opts wird dieser Typ quasi auscodiert. Dort anpassen,
                                      Falls Liste erweitert wird }
  TtrSymbol = Array [TtrItem] Of String ;
Const
  TR_SYMBOLS: TtrSymbol = ('@GV@','@AW@') ;

  TR_MAXSYMLEN= 6 ;   { Maximale Länge eines Symbols (mit @'s. ggf Anpassen !!!!!!!!! }

{ ----- Ende Typen und Konstanten für die Übersetzungen ausm Text ------ }

Type
  {Sammlung von in CWObjs oft bis jedesmal verwendeten Routinen für Ihre CWEdits}
  CWEditMethType = (Unused,Uebersteuert,Uebersteuerbar,AutoLeer);
  CWEditMethSet  = Set of CWEditMethType;

  function AddDocTableLine(s:String;AFmt:TFmtVorl;ANext:TNextStep):PTabAttr;
  procedure DocLineFeed(Var DocTableList:TList);
  function Null2Blank(aString:String):String;
  Procedure AddDocTableMemo(dtList: TList; dbM: TDBMemo) ;
  procedure SetStandardAttribut(Attr:SmallInt;Felder:Array of TSmallIntField); {Setzt Standardattribut in At-Feld}
  procedure SetSeveralCWEdit(Meth:CWEditMethSet;Attr:Boolean;Felder:Array of TCWedit); {Versetzt Sammlungen von CWEdit}
  procedure ClearRefArray(var aRefArray:TStringList);
  procedure AddtoStructure(var aRefArray:TStringList;myImport:TImport;i:LongInt);
  {in andere Zustände je nach Meth}



  {Dispose't alle vorhandenen FImport's und postet falls notwendig hängige Records aller Tables}
   procedure BeforeDestroyObj(Sender:TComponent);

  procedure Getattrs(Sender:TComponent); {Liest für Sammlungen von CWEdit die gesetzten Attribute}

  function RHK(AString:String):String;   {'R'emove 'H'ot 'K'ey  : nimmt '&' weg}

  {Ende davon}

  {Entfernt Formatierung mit Tausenderstrichlis}
  function RemoveDF(aString:String):String;
  function FormatNumber(l:real):string;
  procedure CenterDlg(AForm: TForm; MForm: TForm);   { Zentriert Forms ex PHIL}
  function MyIntToStr(Value : Longint; Trennzeichen : string) : string;
  function RealToStr(Number: extended; Decimals: byte): string;
  function GetNetUserName: string;
  function GetNewKey(Key:TKey):LongInt;  {Gibt neuen Key für Key}

  procedure BeepOk;          { MessageBeep-Zusammenfas-  }
  procedure BeepQuestion;    { sungen für die diversen   }
  procedure BeepHand;        { Warnungen und Infos. Ab-  }
  procedure BeepExclamation; { hängig vom Menüpunkt ob   }
  procedure BeepAsterisk;    { Sound an- oder ausge-     }
  procedure BeepInformation; { schaltet ist.             }
  procedure DoExportNonIterative;
  procedure ExportToASCII_Iterative;
  { procedure ExportTodBase;}

  { Utilities, die PG nützlich fand }
  function booltoint(aBool: Boolean): LongInt;
  function inttobool(aInt: LongInt): Boolean;
  Function StrConcatDelim(aStr1: String; aStr2: String): String ;
  Function StrConcat(aStr1: String; aStr2: String): String ;
  Function StrConcatCustom(Const aStr1: String; Const aStr2: String; Const aSep: String): String ;
  Function GetLngBez(VTbl: TTable; VFName: String; VLng: LongInt): String;
  { String aus einem TabellenFeld, das [Vlng] nach dem mit dem übergebenen Namen steht }
  Function SetToStr(St: TStrCompatSet): String ;
  Function StrToSet(s: String): TStrCompatSet ;
  { wandelt Strings für Datenbank in Set um und umgekehrt.
    Für String-Kompatible Sets (Elemente 0..99, Max. 99 Stellen), z.B. TNTabIDs }

  {DataBase Stuff}
  function ShowRecordNr(VTable: TTable): string;
  procedure PackTable(VTable : TTable);
  procedure FlushTablesBack(sender: TComponent);
  procedure FlushBuffer(DataSet: TDataSet);


  Function IntToFS (FontAttr: LongInt): TFontStyles ;
  Function FSToInt (Style: TFontStyles): LongInt ;
  Procedure MBeepNWait ;
{  procedure getLangImport(VMulti: TMultLang; dfmName: string);}
  //procedure TransL(VMulti: TMultLang; dfmName: string);

 // Procedure Tx2Tbl(Const aField: TBlobField; aTxCtrl: TTextControl) ;
 // Procedure Tbl2Tx(Const aField: TBlobField; aTxCtrl: TTextControl) ;

  Function TmplIDString (aTmplID: TTmplID): String ;

  Function IsSchEqual(Sch1, Sch2: TSchID): Boolean ;

 {Aufruf der Richtwerte mit ID}
Function RW(aRWID:LongInt;var aRWValue:Double):Boolean;

 {Spezialfunktion gebraucht von mehreren CWObjs}
 Procedure DeleteObsolDims(aTable:TTable;aRefArray:TStringList;aObjNr:LongInt);
 function RefCopy(aRefArray:TStringList):TStringList;

var
  glbCLParams: TParams ;   { aktivierte Command-Line-Switches }
  glbState: TStates ;      { Stati div. Strg-Objekte }
  activeIazTable: TTable;  {In Search of IAZI}
  CW_lng: byte;

implementation

uses  CWMain, Grunddat, dialogs, delFrm, FlowMan, cwTmpl; 

function RHK(AString:String):String;
Var
 i: Integer ;
begin
 i := Pos('&',AString) ;
 if i <> -1 then begin
  Result:=Copy(AString,1,i-1)+Copy(AString,i+1,Length(AString))
 end else Result:=AString;
 If Length(Result) >= 1 Then
   Result := AnsiUpperCase(Copy(Result,1,1)) + Copy(Result,2,Length(Result)) ;
end;

function AddDocTableLine(s:String;AFmt:TFmtVorl;ANext:TNextStep):PTabAttr;
begin
 Result:=New(PTabAttr);
 Result^.Inhalt:=s;
 Result^.FmtVorl:=AFmt;
 Result^.Next:=ANext;
end;

procedure DocLineFeed(Var DocTableList:TList);
begin
 DocTableList.Add(AddDocTableLine('',fvFliess,nsNewLine));
end;

function Null2Blank(aString:String):String;
 Const  arNull : array[0..2] of String = ('0','0.0','0.00');
 var i:Longint;
begin
 result:=aString;
 for i:=low(arNull) to high(arNull) do if aString = arNull[i] then Result:='';
end;

Procedure AddDocTableMemo(dtList: TList; dbM: TDBMemo) ;
{ Zerlegt den Inhalt eines übergebenen DBMemos nach harten Zeilenschaltungen in Strings.
  Falls länger als 255 Zeichen keine Harten kommen, wird der String zwangsumgebrochen
  Hier später ändern, falls DocList PChars aktzepiert }
Var
  i: Byte ;
  str: String ;
  blnFirst: Boolean ;
  Pstr: PChar ;

Procedure SendString ;
Begin
  If blnFirst Then
    blnFirst := False
  Else
    dtList.Add(AddDocTableLine('',fvFliess,nsTab));  { für Einzug }

  Str[1] := Char(i) ;
  dtList.Add(AddDocTableLine(str,fvFliessEinzug,nsNewLine));

  i := 0 ;
  Pstr := @Char(str[1]) ;

End ;

Var
  buf: PChar ;
  bufsize: Word ;
  rBuf: PChar ;       { running Buf }
  eBuf: PChar ;       { End Buf }
  Oldww: Boolean ;    { ev. alte Einstellung von WordWrap }
Begin
  bufsize := dbM.GetTextLen + 1;
  If bufsize = 1 Then Exit ;

  If bufsize <= 256 Then Begin
    { alte Logik von SL, für kleine Memos }
    oldWW := dbM.WordWrap ;
    dbM.WordWrap := False ;
    For i:=0 to dbM.Lines.Count-1 do begin
     If i > 0 Then
      dtList.Add(AddDocTableLine('',fvFliess,nsTab));
     dtList.Add(AddDocTableLine(dbM.Lines[i],fvFliessEinzug,nsNewLine));
    end;
    dbM.WordWrap := oldWW ;

  End Else Try

    GetMem(buf,bufsize) ;
    dbM.GetTextBuf(buf,bufsize) ;
    (buf+bufsize-1)^ := #0 ;             { String beenden }
    rBuf := buf ;   { Zeigt aufn Beginn }
    eBuf := StrEnd(buf) ;  { zeigt auf das letzte #0 }
    i := 0 ;
    Pstr := @(str[1]) ;
    blnFirst := True ;

    While rBuf < eBuf Do Begin  { solange es noch Zeichen hat }
      Case rBuf^ Of
        #13:
          Begin
            SendString ;
            inc(rBuf) ;
          End ;
        #10: inc(rBuf) ;   { Überlesen }
      Else
        Begin
          If i = 255 Then
            SendString ;
          pStr^ := rBuf^ ;
          Inc(pStr) ;
          Inc(i) ;
          Inc(rBuf) ;
        End ;
      End ;  { Case }
    End ;
    If i > 0 Then
      SendString ;


  Finally
    FreeMem(buf,bufsize) ;
  End ;
End ;



Type EKey = Class(Exception);


{Holt den gewünschten Key aus der Table, inkrementiert ihn und liefert den Wert}
function GetNewKey(Key:TKey):LongInt;
Begin
 Result:=-1;
 With CWForm do begin
  While True Do try
   If not TblNextKey.FindKey([Ord(Key)]) then
    Raise EKey.Create ('No Key available for Key Nr:' + IntToStr(Ord(Key))) else begin
     TblNextKey.Edit;
     If not (key = kySite) and
        not (key = kyVersion) then TblNextKey.Fields[1].Asinteger:=TblNextKey.Fields[1].Asinteger+1;
     Result:=TblNextKey.Fields[1].Asinteger;
     TblNextKey.Post;
     Break ;
    end;
  except
    on EDataBaseError do {NOP bzw. aber i wott}
    {Raise EDataBaseError.Create('Table Nextkey not available')};
    On E: Exception Do Begin
      MessageDlg(E.Message,mtError,[mbOk],0) ;
      Break ;
    End ;
  end;
 end;
end;

{Setzt die in Attr(n)-Konstanten  definierten Attribute}
 procedure SetStandardAttribut(Attr:SmallInt;Felder:Array of TSmallIntField);
  var i:Integer;
  begin
   for i:=0 to High(Felder) do Felder[i].Value:=Attr;
  end;

{Setzt in einer Sammlung von CEdits je nach Meth das Attr}
 procedure SetSeveralCWEdit(Meth:CWEditMethSet;Attr:Boolean;Felder:Array of TCWedit);
  var i:Integer;
  begin
   for i:=0 to High(Felder) do begin
    if Unused in Meth then Felder[i].Wertunused:=Attr;
    if Uebersteuert in Meth then Felder[i].Wertuebersteuert:=Attr;
    if Uebersteuerbar in Meth then Felder[i].Wertuebersteuerbar:=Attr;
    if AutoLeer in Meth then Felder[i].AutoLeer:=Attr;
   end;
  end;

procedure ClearRefArray(var aRefArray:TStringList);
 var i:LongInt;
begin
 for i:=0 to aRefArray.Count-1 do TStringList(aRefArray.Objects[i]).Destroy;
 aRefArray.Clear;
end;


{Liest bei allen CWEdits das Attribut}
procedure Getattrs(Sender:TComponent);
 Var i:Integer;
 begin
  with Sender do
   for i:=0 to componentcount-1 do
    if (components[i] is TCWedit) then TcwEdit(components[i]).getattribut;
 end;

{Dispose't alle vorhandenen FImport's und postet falls notwendig hängige Records aller Tables}
procedure BeforeDestroyObj(Sender:TComponent);
var i: Integer;
 begin
  with Sender do
   for i:=0 to componentcount-1 do begin
    if (components[i] is TCWedit) and (TcwEdit(components[i]).FImport<>Nil) then
     Dispose(PtrImp(TcwEdit(components[i]).FImport));
    if (components[i] is TTable) then if TTAble(Components[i]).State <> dsBrowse then begin
     {if prOracle In glbCLParams then TTAble(Components[i]).UpdateMode:=UpWhereKeyOnly;}
     if TTAble(Components[i]).Modified then TTAble(Components[i]).Post else TTAble(Components[i]).Cancel;
    end;
   end;
 end;


Procedure DeleteObsolDims(aTable:TTable;aRefArray:TStringList;aObjNr:LongInt);
  var i,PlaceinTList,CountofArray:LongInt;
      PartList:TList;
      TempStringlist:TStringList;
 begin
  aTable.Active:=True;
  aTable.SetRange([aObjNr],[aObjNr]);
  aTable.First;
  While not aTable.EOF do
   if aRefArray.IndexOf(Format('%10d',[aTable.Fieldbyname('DIMNR').AsInteger])) = -1 then
    aTable.Delete else aTable.Next;
  aTable.Active:=False;
 end;


 function RefCopy(aRefArray:TStringlist):TStringList;
  var i,e:LongInt;
 begin
  result:=TStringList.Create;
  for i:=0 to aRefArray.Count-1 do begin
   Result.AddObject(aRefArray.Strings[i],TStringList.Create);
   for e:=0 to TStringList(aRefArray.Objects[i]).Count-1 do
    TStringList(Result.Objects[i]).AddObject(TStringList(aRefArray.Objects[i]).Strings[e],
     TStringList(aRefArray.Objects[i]).Objects[e]);
  end;
 end;

 procedure AddtoStructure(var aRefArray:TStringList;myImport:TImport;i:LongInt);
  var p:LongInt;
 begin
  p:=aRefArray.IndexOf(Format('%10d',[myImport.Dimnr]));
  {Dim noch nie dagewesen also neu eintragen}
  if p= -1 then p:=aRefArray.AddObject(Format('%10d',[myImport.Dimnr]),TStringlist.Create);
  {Es wird nun dem Flowman blind vertraut und nicht weiter abgecheckt ob bei
   dieser Dimnr schon dieselbe Dom registriert wurde}
  TStringList(aRefArray.Objects[p]).AddObject(Format('%10d',[i]),TObject(myImport));
 end;



Procedure FillParams ;
  Var i,k: Integer ;
      j: TParam ;
      sParam : String ;

  Begin
    For i := 1 To ParamCount Do Begin
      sParam := UpperCase(ParamStr(i)) ;
      For j := Low(TParam) To High(TParam) Do
        If copy(sParam,1,Length(clParamMark[j])) = clParamMark[j] Then Begin
          Include (glbClParams, j) ;
          If j = prSchemaHolder Then Begin
            k := Pos(':',sParam) ;
            If k >= 1 Then
              CW_TABLE_OWNER := Copy(sParam,k+1,Length(sParam)-k) + '.' ;
          End ;
        End ;
    End ;


  End ;

type  EObj = Class(Exception);

constructor TCWobj.CreateObj(Aowner:TComponent;AObjNr,ADimNr,ADimArt,AVorlage:LongInt);
begin
 inherited Create(Aowner);
 onExit:=CWObjExit;
 RobjNr:=AObjNr;
 RDimArt:=ADimArt;
 RDimNr:=ADimNr;
end;

procedure TCWobj.CWobjExit(Sender : Tobject);
 var i:LongInt;
     objmodi:Boolean;
begin
 Screen.Cursor:=crHourGlass;
 for i:=0 to componentcount-1 do if (components[i] is TTable) then if TTAble(Components[i]).Modified then objmodi:=True;
 if objmodi then try
  flmn.Recalc(RObjnr);
 except
  raise EObj.Create('CWOBJ Recalc : Flowman not loaded !');
 end;
 SetinBrowseMode;
 Screen.Cursor:=crDefault;
end;

procedure TCWObj.RegisterImport(ImportList:Tlist);
begin
end;

procedure TCWObj.Save;
 var oldState : TDataSetState;
     i:LongInt;
begin
 for i:=0 to ComponentCount-1 do
  if (Components[i] is TTable) and ((Components[i] as TTable).Active) then begin
   oldState:=(Components[i] as TTable).State;
   (Components[i] as TTable).CheckBrowseMode;
   FlushBuffer((Components[i] as TTable));
   Case oldState of
    dsEdit : (Components[i] as TTable).Edit;
    dsInsert : (Components[i] as TTable).Insert;
    dsSetKey : (Components[i] as TTable).SetKey;
   end;
  end;
end;

procedure TCWObj.SetinBrowseMode;
 var  i:LongInt;
begin
 for i:=0 to ComponentCount-1 do
  if (Components[i] is TTable) and ((Components[i] as TTable).Active) then
   (Components[i] as TTable).CheckBrowseMode;
end;

procedure CenterDlg(AForm: TForm; MForm: TForm);   { Zentriert Forms }
begin
     With AForm Do Begin
          Left := Abs(MForm.Left) + Round(Abs(MForm.Width - Width) / 2);
          Top := Abs(MForm.Top) + Round(Abs(MForm.Height - Height) / 2);
     End;
end;


function RemoveDF(aString:String):String;
begin
 result:=aString;
 while pos(ThousandSeparator,result) > 0 do
  result:=Copy(result,1,pos(ThousandSeparator,result)-1)+Copy(result,pos(ThousandSeparator,result)+1,length(result))
end;

function FormatNumber(l: real): string;
 var testform : string;
  begin
    result := FormatFloat('#,##0.00',l);
 end;

function TCWObj.GetDocTable(TableNr:Longint;DocTableList:TList;ADimNr:LongInt):Boolean;
var PAttr : PTabAttr;
begin
 PAttr:=New(PTabAttr);
 PAttr^.Inhalt:='Tabelle #'+IntToStr(TableNr)+' von '+Classname;
 PAttr^.FmtVorl:=fvTabelle ;
 PAttr^.Next:=nsEnd;
 DocTableList.Add(PAttr);
 Result:=True;
end;

{Diese Routine wird von jedem Obj-Constructor im Falle eines erstmaligen Erscheinen }
{benötigt. Bedingungen :                                                            }
{- Nur Felder der Typen LongInt,Float,String  (Stand 30.10.96)                      }
{- Index ObjNr                                                                      }
{-Reihenfolge des Felderindex ist so,dass ab FirstField nicht noch ein KeyFeld kommt}
{Kopiert wird in dieser Priorität VorlagenObj ansonstne bei Vorhandensein der       }
{Templ.-Record ansonsten das Standard Fix-Obj mit der Nummer 1.                     }

type ETmplFix= Class(Exception);



procedure TCWObj.CopyRecTmplorFix(ObjTable:TTable;FirstField,AVorlage,Seq:Longint);
type ValueHolder = Record
      BufSize : LongInt;
      Data    : Pointer;
      case Byte of
       0: (WertFld : Double);
    //   1: (TextFld : string);
       2: (ATFld   : Integer);
      end;

      PValueHolder =^ValueHolder;

var Sourceobj,i:Longint;
    WList :Tlist;
    VH: PValueHolder;
    Stream : TBlobStream;

 begin
  glbState := glbState + [obCopRecWorking];
  Wlist:=Tlist.Create;
  ObjTable.SetRange([Nil],[Nil]); {Zustand normalisieren}
  {Fragt nach ObjNr des Templates und holt bei Misserfolg das DefaultObj}
  if (AVorlage = -1 ) then begin
   if not FrmTmpl.GetObjNrbyObjArt(ObjArt,SourceObj) then SourceObj:=DefaultObj;
  end else SourceObj:=AVorlage;
  If not ObjTable.Findkey([SourceObj]) then begin
   if SourceObj <> DefaultObj then SourceObj := DefaultObj;
   if not ObjTable.Findkey([SourceObj]) then Raise ETmplFix.Create('SourceObj Nr.1 not found in Table :'+ObjTable.TableName);
  end;
  for i:=FirstField to ObjTable.FieldCount-1 do begin
   VH:=New(PValueHolder);
   Case ObjTable.Fields[i].DataType of
    ftFloat : VH^.Wertfld:=ObjTable.Fields[i].AsFloat;
    ftInteger,ftSmallInt : VH^.ATfld:=ObjTable.Fields[i].AsInteger;
   // ftString : VH^.TextFld :=ObjTable.Fields[i].AsString;
    ftMemo : begin
              Stream:=TBlobStream.Create(TMemoField(ObjTable.Fields[i]),bmRead);
              VH^.BufSize:= Stream.Seek(0,2);
              Stream.Seek(0,0);
              GetMem(VH^.Data,VH^.BufSize);
              Stream.Read(VH^.Data^,VH^.BufSize);
              Stream.Free;
            end;
    else
   end;
   WList.Add(VH);
  end;
  If Seq < 0 then begin                                   {ist's eine Obj Haupttable}
   ObjTable.Append;           {Fügt ein neues an}
   ObjTable.Fieldbyname('ObjNr').AsInteger:=ObjNr;
  end else if not ObjTable.Findkey([ObjNr,Seq]) then  Raise ETmplFix.Create('CopyRecTmplorFix : TargetObj not found');
    {oder eine Komp Table}
  For i:=FirstField To ObjTable.FieldCount-1 do begin
   ObjTable.Edit;
   Case ObjTable.Fields[i].DataType of
    ftFloat : {Nuller sollen nicht geschrieben werden}
               if PValueHolder(WList.Items[i-FirstField])^.WertFld <> 0 then
                ObjTable.Fields[i].AsFloat:=PValueHolder(WList.Items[i-FirstField])^.WertFld;

    ftInteger,ftSmallInt : ObjTable.Fields[i].AsInteger:=PValueHolder(WList.Items[i-FirstField])^.AtFld;
 //   ftString : ObjTable.Fields[i].AsString:=PValueHolder(WList.Items[i-FirstField])^.TextFld;
    ftMemo : begin
              VH:=PValueHolder(WList.Items[i-FirstField]);
              Stream:=TBlobStream.Create(TMemoField(ObjTable.Fields[i]),bmWrite);
              Stream.Write(VH^.Data^,VH^.BufSize);
              FreeMem(VH^.Data,VH^.BufSize);
              Stream.Free;
             end;
    else
   end;
  end;
  Objtable.CheckBrowseMode;
  ObjTable.SetRange([ObjNr],[ObjNr]);
  for i:=0 to Wlist.Count-1 do Dispose(WList.Items[i]);
  Wlist.Destroy;
  glbState := glbState - [obCopRecWorking];
 end;


function TCWObj.GetDefaultValue(ObjTable:TTable;aFieldName:String):Double;
var SourceObj:LongInt;
begin
 if not FrmTmpl.GetObjNrbyObjArt(ObjArt,SourceObj) then SourceObj:=DefaultObj;
 ObjTable.SetRange([nil],[nil]);
 If not ObjTable.Findkey([SourceObj]) then begin
  if SourceObj <> DefaultObj then SourceObj := DefaultObj;
  if not ObjTable.Findkey([SourceObj]) then Raise ETmplFix.Create('SourceObj Nr.1 not found in Table :'+ObjTable.TableName);
 end;
 Result:=ObjTable.Fieldbyname(aFieldName).AsFloat;
 ObjTable.SetRange([ObjNr],[ObjNr]);
 ObjTable.Edit;
end;

{Kopiert ganze Komponententabellen von aVoralge zu aTargetObj}
procedure TCWObj.CopyKompTable(aTable:TTable;aVorlage,aTargetObj:LongInt);
type ValueHolder = Record
      case Byte of
       0: (WertFld : Double);
     //  1: (TextFld : string);
       2: (ATFld   : LongInt);
      end;

      PValueHolder =^ValueHolder;

 var WList,TblList:TList;
     VH: PValueHolder;
     oldIndex,oldMaster : String;
     oldMasterSource : TDataSource;
     oldOnNewRecord: TDataSetNotifyEvent;
     i,r:LongInt;
begin
 {Table-Zustand erfassen und für geplante Aktionen einstellen}
 oldIndex:=aTable.IndexFieldNames;
 aTable.IndexFieldNames:='OBJNR';
 oldMaster:=aTable.Masterfields;
 aTable.MasterFields:='';
 oldMasterSource:=aTable.MasterSource;
 aTable.MasterSource:=nil;
 oldOnNewRecord:=aTable.OnNewRecord;
 aTable.OnNewRecord:=nil;

 TblList:=TList.Create;         {enthält alle Records}
 TblList.Clear;
 {Table-Range auf aVorlage setzen}
 aTable.SetRange([aVorlage],[aVorlage]);
 aTable.First;
 While not aTable.Eof do begin
  WList:=TList.Create;
  for i:=0 to aTable.FieldCount-1 do begin {1 da 0 per Default Objnr ist}
   VH:=New(PValueHolder);
   Case aTable.Fields[i].DataType of
    ftFloat : VH^.Wertfld:=aTable.Fields[i].AsFloat;
//    ftInteger,ftSmallInt : VH^.ATfld:=aTable.Fields[i].AsInteger;
//    ftString : VH^.TextFld :=aTable.Fields[i].AsString;
    else
   end;
   WList.Add(VH);
  end;
  TblList.Add(WList);
  aTable.Next;
 end;
 aTable.SetRange([nil],[nil]);
 for r:=0 to TblList.Count-1 do begin
  Wlist:=TList(TblList.Items[r]);
  aTable.Append;
  aTable.FieldbyName('OBJNR').AsInteger:=aTargetObj;
  aTable.Post;
  aTable.Edit;
  For i:=1 To aTable.FieldCount-1 do begin
   Case aTable.Fields[i].DataType of
    ftFloat : {Nuller sollen nicht geschrieben werden}
               if PValueHolder(WList.Items[i])^.WertFld <> 0 then
                aTable.Fields[i].AsFloat:=PValueHolder(WList.Items[i])^.WertFld;
    ftInteger,ftSmallInt : aTable.Fields[i].AsInteger:=PValueHolder(WList.Items[i])^.AtFld;
 //   ftString : aTable.Fields[i].AsString:=PValueHolder(WList.Items[i])^.TextFld;
    else
   end;
  end;
 end;
 {Table-Zustand zurücksetzen}
 aTable.IndexFieldNames:=oldIndex;
 aTable.MasterFields:=oldMaster;
 aTable.MasterSource:=oldMasterSource;
 aTable.OnNewRecord:=oldOnNewRecord;
 {Struktur abbauen}
 for r:=0 to TblList.Count-1 do begin
  Wlist:=TList(TblList.Items[r]);
  for i:=0 to Wlist.Count-1 do Dispose(WList.Items[i]);
  Wlist.Destroy;
 end;
 TblList.Destroy;
end;


procedure TCWObj.PrepareToReParent ;
{ destroyt hwnd, falls vorhanden }
Begin
  If (Parent = Nil) And (HandleAllocated) Then
    DestroyHandle ;
  { HWND abhängen, falls das noch nicht geschah }
  { wird implizit gemacht, wenn parent <> Nil }
End ;

function RealToStr(Number:extended; Decimals:byte):string;
var  Temp: string;
begin
  Str(Number:15:Decimals, Temp);
  repeat
    if Copy(Temp, 1, 1) = ' ' then Delete(Temp, 1, 1);
  until Copy(Temp, 1, 1) <> ' ';
  RealToStr := Temp;
end;


{Formatiert einen String in Dreiergruppen}
function MyIntToStr(Value : Longint; Trennzeichen : string) : string;
var s, s2 : string;
  rest : shortint;
begin
  s := IntToStr(Value);
  s2 := '';
  if s[1] = '-' then begin
    s2 := '-';
    s := copy(s, 2, length(s) - 1);
  end;
  if length(s) > 3 then begin
    rest := length(s) mod 3;
    if rest > 0 then begin
      s2 := copy(s, 1, rest) + Trennzeichen;
      s := copy(s, 1 + rest , length(s) - rest);
    end;
    while length(s) > 3 do begin
      s2 := s2 + copy(s, 1, 3) + Trennzeichen;
      s := copy(s, 4, length(s) - 3);
    end;
    s2 := s2 + s;
  end else begin
    s2 := s;
  end;
  MyIntToStr := s2;
end;

function getNetUserName: string;
var
  szVar: array[0..32] of char;
begin
  DBIGetNetUserName(szVar);
  result:= StrPas(@szVar) ;
end;


procedure BeepOk;
begin
 { if CWForm.soundmnu.Checked then MessageBeep(MB_OK);}
end;

 procedure BeepInformation;
begin
{  if CWForm.soundmnu.Checked then
    MessageBeep(MB_ICONINFORMATION);   }
end;

procedure BeepExclamation;
begin
{  if CWForm.soundmnu.Checked then
    MessageBeep(MB_ICONEXCLAMATION);   }
end;

procedure BeepAsterisk;
begin
 { if CWForm.soundmnu.Checked then
    MessageBeep(MB_ICONASTERISK);    }
end;

procedure BeepQuestion;
begin
{  if CWForm.soundmnu.Checked then
    MessageBeep(MB_ICONQUESTION);    }
end;

procedure BeepHand;
begin
{  if CWForm.soundmnu.Checked then
    MessageBeep(MB_ICONHAND);       }
end;



Function BoolToInt(aBool: Boolean): LongInt;
Begin
  If aBool Then
    Result := 1
  Else
    Result := 0;
End ;

Function IntToBool(aInt: LongInt): Boolean ;
Begin
  If aInt = 0 Then Result := False Else Result := True ;
End ;

Function StrConcatDelim(aStr1: String; aStr2: String): String ;
{ Concateniert zwei Strings mit Trennzeichen }
Begin
  IF (aStr1 <> '') And (aStr2 <> '') Then
    Result := aStr1 + ST_DELIMCONCATSTR + aStr2
  Else If aStr1 <> '' Then
    Result := aStr1
  Else If aStr2 <> '' Then
    Result := aStr2
  Else
    Result := '' ;
End ;

Function StrConcat(aStr1: String; aStr2: String): String ;
{ Concateniert zwei Strings mit Leerzeichen }
Begin
  IF (aStr1 <> '') And (aStr2 <> '') Then
    Result := aStr1 + ' ' + aStr2
  Else If aStr1 <> '' Then
    Result := aStr1
  Else If aStr2 <> '' Then
    Result := aStr2
  Else
    Result := '' ;
End ;

Function StrConcatCustom(Const aStr1: String; Const aStr2: String; Const aSep: String): String ;
{ jetzt hat es mir gereicht. Für das Komma und alle weiteren, die noch kommen (wenn überhaupt ???)
  habe ich StrConcat gebaut, an das man das Trennzeichen übergeben kann }
Begin
  IF (aStr1 <> '') And (aStr2 <> '') Then
    Result := aStr1 + aSep + aStr2
  Else If aStr1 <> '' Then
    Result := aStr1
  Else If aStr2 <> '' Then
    Result := aStr2
  Else
    Result := '' ;
End ;


Function GetLngBez(VTbl: TTable; VFName: String; VLng: LongInt): String;
{ Sucht den String eines Feldes, das Vlng Sprachen weit vom Feld mit dem
  Namen VFName entfernt ist }
Var
  i: Integer ;
Begin
  Try
    i := VTbl.FieldByName(VFName).Index ;
    Result := VTbl.Fields[i+Vlng].AsString ;
  Except
    Application.MessageBox ('Problems with Language-sensitive Bez','GetLngBez',mb_OK) ;
    Result := '' ;
  End ;
End ;

Function SetToStr(St: TStrCompatSet): String ;
Var
  i: Integer ;
Begin
  Result := '' ;
  For i := 0 To 99 Do
    If i In St Then
      Result := Result + Format('%2d',[i]) ;
End ;

Function StrToSet(s: String): TStrCompatSet ;
Var
  len,i: Integer ;
Begin
  Result := [] ;
  len := Length(s) ;
  If Frac(len/2.00) <> 0 Then Begin
    Application.MessageBox ('String of Impair Lenght','StrToSet',mb_Ok) ;
    Exit ; End ;

  If len > 198 Then Begin
    Application.MessageBox ('String too long','StrToSet',mb_Ok) ;
    Exit ; End ;

  For i := 0 To (len shr 1)-1 Do
    Include(Result,StrToInt(Copy(s,2*i+1,2))) ;

End ;

Function IntToFS (FontAttr: LongInt): TFontStyles ;
{ Übersetzt Integer-Fontattribut in Style. Es wird angenommen, dass fehlende
  Bits (z.B. FA_BOLD) automatisch gegenteilige (FA_NOBOLD) bedeuten. }
Begin
  Result := [] ;
  If FontAttr And FA_BOLD <> 0 Then Include(Result,fsBold) ;
  If FontAttr And FA_ITALIC <> 0 Then Include(Result,fsItalic) ;
  If FontAttr And FA_UNDERLINE <> 0 Then Include(Result,fsUnderline) ;
  If FontAttr And FA_STRIKEOUT <> 0 Then Include(Result,fsStrikeout) ;
End ;

Function FSToInt (Style: TFontStyles): LongInt ;
{ Übersetzt Fontattribute in Integer. Fehlede Auszeichnungen werden in FA_NOBOLD
  usw. umgesetzt }
Begin
  Result := 0 ;
  If fsBold In Style Then Result := Result Or FA_BOLD Else Result := Result Or FA_NOBOLD ;
  If fsItalic In Style Then Result := Result Or FA_ITALIC Else Result := Result Or FA_NOITALIC ;
  If fsUnderline In Style Then Result := Result Or FA_UNDERLINE Else Result := Result Or FA_NOUNDERLINE ;
  If fsStrikeout In Style Then Result := Result Or FA_STRIKEOUT Else Result := Result Or FA_NOSTRIKEOUT ;
End ;


{only for design time}
(*procedure getLangImport(VMulti: TMultLang; dfmName: string);
begin
  with VMulti do begin
    if not (Import('M:\DELPHI\CALWIN2\CWLANG\'+ dfmName +'.TXT')) then      {path !}
    {if Translate('FRANZ',true) then Visible:=false else}
    messageDlg('CW2 Language Translator' + dfmName + 'not imported',
                  mtInformation, [mbOK], 0);

  end;
end;*)


(*Procedure Tbl2Tx(Const aField: TBlobField; {aTxCtrl: TTextControl}) ;
{ Zeigt Blob aus der Tabelle im TxCtrl an }
var
   buf: Pointer;
   hnd: THandle;
   bufsize: LongInt;
   blbText: TBlobStream;
   aSel: TSelection ;
   strEmpty: PChar ;
Begin
  //With aTxCtrl Do Begin
    aSel[SEL_START] := 0;
    aSel[SEL_END] := -1 ;
 //   SendMessage(Handle,TX_SETSEL,1,LongInt(@aSel)) ;         { Alles auswählen }
  //  blbText := TBlobStream.Create(aField, bmRead);
    bufsize := blbText.Seek(0,2);
    blbText.Seek(0,0);
    If bufsize = 0 Then Begin
      strEmpty := '' ;
  //    SendMessage(Handle,TX_REPLACESEL,0,LongInt(strEmpty)) ;
     End Else Begin
      hnd := GlobalAlloc(GHND, bufsize);
      buf := GlobalLock( hnd);
      If blbText.Read(buf^, bufsize) <> bufsize Then
         Raise Exception.Create('Opts: TBlobStream.Read failed');
  //    If SendMessage(Handle, TX_IMPORTTEXTBUFFER,word(hnd), 0) = 0 Then
         Raise Exception.Create('Opts: TX_IMPORTTEXTBUFFER failed');
      GlobalUnlock(hnd) ;
      GlobalFree(hnd);
 //   End;
 // End;
//  blbText.Free;
//End;
end; *)


(*Procedure Tx2Tbl(Const aField: TBlobField; aTxCtrl: TTextControl) ;
var
   buf: Pointer;
   hnd: THandle;
   bufsize: LongInt;
   blbText: TBlobStream;
   aSel: TSelection ;
Begin
  With aTxCtrl Do Begin
    aSel[SEL_START] := 0;
    aSel[SEL_END] := -1 ;
    SendMessage(Handle,TX_SETSEL,1,LongInt(@aSel)) ;         { Alles auswählen }
    hnd := SendMessage(Handle, TX_EXPORTTEXT, Word(-1), 0);
    {handle to Text in TxFormat, as WParam:=-1 and LParam contains no filter}
    If hnd = 0 Then
      Raise Exception.Create('Opts: TX_EXPORTTEXT failed');
    buf := GlobalLock(hnd);
    bufsize := GlobalSize(hnd);
    blbText := TBlobStream.Create(aField, bmWrite);
    If blbText.Write(buf^, bufsize) <> bufsize Then
      Raise Exception.Create('Opts: Could not write whole TBloblField');
    GlobalUnlock (hnd) ;
    GlobalFree(hnd);
    blbText.Free; { PG says before Post, sonst Aerger... non vedo i guai ma lo faccio lo stesso }
  End;
End; *)



Function TmplIDString (aTmplID: TTmplID): String ;
{ macht String für Bangkok aus TmplID }
Begin
  Result := Format('%10.10d%10.10d',[aTmplID.TmplSiteID, aTmplID.TmplID]) ;
End ;

Function IsSchEqual(Sch1, Sch2: TSchID): Boolean ;
Begin
  Result := (Sch1.SiteID = Sch2.SiteID) And (Sch1.SchID = Sch2.SchID) ;
End ;


Function RW(aRWID:LongInt;var aRWValue:Double):Boolean;
begin
 
end;

function ShowRecordNr(VTable: TTable): string;
var
  aRecProps  : RECProps;
  lRecNo     : LongInt;
begin
  with VTable do
  begin
    UpdateCursorPos;
    Check(DBIGetRecord(Handle, DBINoLock, nil, @aRecProps));
    lRecNo := aRecProps.iSeqNum;
    result:= Format(' Datensatz %d von %d',
                              [lRecNO, RecordCount]);
  end
end;

function IsReadOnly(const Filename: string): boolean;
begin
  result:= boolean(FileGetAttr(Filename) and faReadOnly);
  if result then MessageDlg(Format('%s is readonly!',
     [ExtractFileName(Filename)]), mtWarning, [mbOK], 0);
end;

procedure PackTable(VTable : TTable);   {ckecked it once mk}
var
  aCurProps : CURProps;
  aTblDesc  : CRTblDesc;
  aHDBI     : HDBIDB;
begin
with VTable do
  begin
    { vorher Exclusiv öffnen ! }
    Active:= False;
    Exclusive:= True;
    TableName:=VTable.TableName;  {DBVerzeichnis+'\'+TableName;}
    Active:= True;
    { dBase oder Paradox ? }
    Check(DbiGetCursorProps(Handle, aCurProps));
    Screen.Cursor := crHourglass;
    case aCurProps.iSeqNums of
      { 0 = dBase }
      0 : Check(DbiPackTable(DBHandle, Handle, nil, nil, True));
      { 1 = Paradox }
      1 : begin
            { TTable darf nicht offen sein !!! }
            Active := False;
            FillChar(aTblDesc, SizeOf(aTblDesc), #0);
            { CRTblDesc-Record ausfüllen (3 von 25 Feldern) }
            with aTblDesc do
            begin
              StrPCopy(szTblname,VTable.TableName);
              bPack := True;      { Komprimieren ! }
              iFldCount := 0;     { keine Strukturänderung ! }
            end;

            (* TTable geschlossen -> DBHandle ist ungültig !
               Daher wird die Datenbank mittels IDAPI-Aufruf
               geöffnet, die Tabelle selber allerdings nicht. *)

            Check(DbiOpenDatabase(nil, nil, DbiREADWRITE,
                                  DbiOpenShared, nil,
                                  0, nil, nil, aHDBI));

            (* Keine Umstrukturierung, Tabelle wird nur gepackt *)

            Check(DbiDoRestructure(aHDBI, 1, @aTblDesc,
                                   nil, nil, nil, False));
           end
    end;
    { Anzeige im DBGrid wieder aktivieren }
    Active:= False;
    Exclusive:= False;
    Active:= True;
    Screen.Cursor := crDefault;
  end
end;

procedure FlushTablesBack(sender: TComponent);
var i: Integer;
 begin
  with Sender do
   for i:=0 to componentcount-1 do begin
    if (components[i] is TTable) then if TTAble(Components[i]).State <> dsBrowse then begin
     {if prOracle In glbCLParams then TTAble(Components[i]).UpdateMode:=UpWhereKeyOnly;}
     if TTAble(Components[i]).Modified then FlushBuffer(TTAble(Components[i]))
     else TTAble(Components[i]).Cancel;
    end;
   end;
 end;


procedure FlushBuffer(DataSet: TDataSet);
begin
  with DataSet do begin
    UpdateCursorPos;
    check(dbiSaveChanges(Handle));
    CursorPosChanged;
  end;
end;




(* ====================================================== *)
(*                   begin von ASCIIEXP                  *)


procedure DoExportNonIterative;
  var
    MyBookmark : tBookmark;
    TxtName,
    TxtPath    : string[255];
    f          : TextFile;
    i          : INTEGER;
    Delimiter  : string[20];
  begin
(*    Delimiter := '^M^J';   {DelSelWindow.Select.Text;}
    if Delimiter = '^M^J' then Delimiter := ^M^J;
    with Grunddatfrm do
    begin
      TxtName := tblGrund.TableName;
      TxtPath := tblGrund.DatabaseName;
      if TxtPath[Length(TxtPath)] <> '\' then
         TxtPath := TxtPath + '\';
      Dec(TxtName[0], 2);
      TxtName := TxtName + 'EXP';
      AssignFile(f, TxtPath + TxtName);
      try
        Rewrite(f);
      except
        if CWform.Soundmnu.Checked then
          MessageBeep(MB_ICONEXCLAMATION);
        MessageDlg('Fehler beim Erzeugen der Textdatei!',
                   mtError, [mbOk], 0);
        Exit;
      end;
      MyBookMark := tblGrund.GetBookMark;
      tblGrund.First;
      while not tblGrund.EOF do
      begin
        if Delimiter <> ^M^J then Write(f, Delimiter);
        Write(f, DBSchatzNr.Text, Delimiter);
        if (Length(Delimiter) = 1) and not
           (Delimiter[1] in [',', ';', '.']) then
          Write(f, ',');
        if Delimiter <> ^M^J then Write(f, ' ', Delimiter);
        Write(f, DBAltlastenNr.Text, Delimiter);
        if (Length(Delimiter) = 1) and not
           (Delimiter[1] in [',', ';', '.']) then
          Write(f, ',');
        Write(f, ' ', Delimiter);
        {if DBMemo1.Lines.Count > 0 then
          for i := 1 to DBMemo1.Lines.Count do
            Write(f, DBMemo1.Lines[i] + ' ');}
        Write(f, Delimiter);
        if Delimiter <> ^M^J then WriteLn(f);
        tblGrund.Next;
      end;
      tblGrund.GotoBookmark(MyBookmark);
      tblGrund.FreeBookmark(MyBookmark);
    end;
    CloseFile(f);
    if CWForm.Soundmnu.Checked then MessageBeep(MB_OK);
    MessageDlg('Daten wurden nach ASCII exportiert.',
               mtInformation, [mbOk], 0);
 *) end;


procedure ExportToASCII_Iterative;
var
  I: Integer;
  Dlg: TSaveDialog;
  ASCIIFileName: String[150];
  ASCIIFile: TextFile;
  Delimiter: String[20];
  Res: Boolean;

begin
  Application.CreateForm(TDelimitFrm, DelimitFrm);
  with grunddatFrm.tblGrund do
  begin
  DelimitFrm:=TDelimitFrm.create(Application);
    DelimitFrm.ShowModal;
    if (DelimitFrm.OKBtn.ModalResult = idOK) then
    Delimiter := DelimitFrm.Select.Text;
    if Delimiter = '^M^J' then Delimiter := ^M^J;
    if Active then
      if (FieldCount > 0) and (RecordCount > 0) then
      begin
        Dlg := TSaveDialog.Create(Owner);
        Dlg.FileName := ASCIIFileName;
        Dlg.Filter := 'ASCII-Dateien (*.asc)|*.asc';
        Dlg.Options := Dlg.Options+[ofPathMustExist,
                            ofOverwritePrompt, ofHideReadOnly];
        Dlg.Title := 'Daten in ASCII-Datei exportieren';
        try
          Res := Dlg.Execute;
          if Res then
            ASCIIFileName := Dlg.FileName;
        finally
          Dlg.Free;
        end;
        if Res then
        begin
          AssignFile(ASCIIFile, ASCIIFileName);
          Rewrite(ASCIIFile);
          First;
          {if ASCIIFieldNames then}
          begin
            for I := 0 to FieldCount-1 do
            begin
              Write(ASCIIFile, Fields[I].FieldName);
              if I <> FieldCount-1 then
              Write(ASCIIFile, Delimiter);
            end;
              Write(ASCIIFile, Delimiter);
            {end;}
            while not EOF do
            begin
              for I := 0 to FieldCount-1 do
              begin
                Write(ASCIIFile, Fields[I].Text);
                if I <> FieldCount-1 then
                Write(ASCIIFile, Delimiter);
              end;
              Next;
              if not EOF then
              Write(ASCIIFile, Delimiter);
            end;
            CloseFile(ASCIIFile);
            if IOResult <> 0 then
              MessageDlg('Fehler beim Erstellen oder Schreiben '+
                'in die ASCII-Datei', mtError, [mbOK], 0);
          end; {field count}
        end;  {Res check}
      end
      else                                    {FeldCount else}
      MessageDlg('Es sind keine Tabellendaten zu exportieren.',
      mtInformation, [mbOK], 0)
    else                                      {Active else}
    MessageDlg('Datenbank-Tabelle muß geöffnet sein, damit Daten '+
    'ins ASCII-Format exportiert werden können.', mtError,
    [mbOK], 0);
  end;
end;

(* ====================================================== *)
(*                   Ende von ASCIIEXP                  *)


(* ====================================================== *)
(*                   begin von dBase Export               *)


(* PROCEDURE ExporttoDBase;
  { Per SQL (Table1->Query1->BatchMove1->Table2) wird die  }
  { komplette Tabelle in eine DBF-Datei gleichen Namens    }
  { umkopiert. Dies erleichtert das Einlesen in Programme, }
  { die das Paradox-Format nicht lesen können.             }
  VAR
    s, OldName, OldPath: STRING[255];

 PROCEDURE RestoreNames;
 BEGIN
    with grunddatFrm.GrundTbl do
    begin
      TableName    := OldName;
      DatabaseName := OldPath;
     { TableType    := ttDBase;}
    END;

 (* BEGIN
    Query1.Close;
    Query1.SQL.Clear;
    WITH Table2 DO BEGIN
      Table2.Close;
      OldName      := TableName;
      OldPath      := DatabaseName;
      Databasename := Table1.DatabaseName;
      TableName    := Table1.TableName + 'F';
      TableType    := ttDBase;
      CreateTable;
      Open;
    END;
    Query1.SQL.ADD('SELECT * FROM "'   +
                   Table1.DatabaseName +
                   Table1.TableName    + '"');
    TRY
      Query1.Open;
      BatchMove1.Execute;
    EXCEPT
      BeepInformation;
      MessageDlg('Datenbank konnte nicht nach '  +
                 ANSILowerCase(Table1.TableName) +
                  ' konvertiert werden!',
                 mtError, [mbOk], 0);
      Table2.Close;
      Query1.Close;
      RestoreNames;
      Exit;
    END;

    Close;
   Query1.Close;
    RestoreNames;
    BeepOk;
    MessageDlg('Tabelle wurde nach '            +
                ANSILowerCASE(TableName) +
                ' konvertiert.',
               mtInformation, [mbOk], 0);
  END; *)



{OlD Routine}


(*oldWizard in
const outlevel: integer= 0;
      dimCounter: integer= 0;
var parzNr, objektNr, objektEditNr, otNr, otNr1, otEditObNr, otEditEtNr,
            WQNr, DimNr,DimNrSuper: integer;
       firstWQ: boolean;
       mark: TBookmark;
begin
otlWiz.clear;
firstWQ :=true;
tabMaster.first;
{***}
  with otlWiz do
  begin

    {read from master table}
    parzNr := add(0,'Parzelle');
    {WQNr:= addchild(parzNr,'Eigentumseinheiten');}
    with otlWiz[parzNr] do {if level > 1} changelevelby(0);
    objektNr:=addchild(parzNr, 'Objekte');
    {otlWiz[1].changelevelby(1);}
    while not tabMaster.eof do
    begin
      if {(tabMasterSchatzNr.value = tabDetailSchatzNr.value)}
      (tabMasterDimArt.value = 1)
      then
      begin
        otNr:=addchild(objektNr,tabMasterBez.value);
        otNr1:=otNr;                       {save for move}
        dimNr:=tabMasterDimNr.value;
        otEditObNr:=addchild(otNr,'Objektteile');
        mark:=TabMaster.GetBookMark;
        tabMaster.first;
        while not tabMaster.eof do
        begin
          if (tabMasterDimArt.value = 2) and
          (tabMasterDimNrSuper.value = dimNr) then
          otNr:=addChild(otEditObNr,tabMasterBez.value);
          tabMaster.next;
        end;
        otEditEtNr:=add(otNr,'Ertragsteile');  {add of objekte}
        with otlWiz.Items[otEditEtNr] do       {move ertragsteile}
        MoveTo(otNr1+1, oaAdd);
        tabMaster.first;
        while not tabMaster.eof do
        begin
          if (tabMasterDimArt.value = 3) and
          (TabMasterDimNrSuper.value = dimNr) then
          addChild(otEditEtNr,tabMasterBez.value);
          tabMaster.next;
        end;
        TabMaster.gotoBookmark(mark);
        TabMaster.freeBookmark(mark);
      end;  {while DimArt = obj}
      if (tabMasterDimArt.value = 4)
      then
      begin
       if firstWQ then
       begin
         WQNr:=add(objektNr, 'Eigentumseinheiten');
         addchild(WQNr, tabMasterBez.value);
         firstWQ := false
       end
       else
       addchild(WQNr, tabMasterBez.value);
      end;
     tabMaster.next;
    end; {end eof while}
   with otlWiz.Items[otEditEtNr] do       {move last ertragsteile}
        MoveTo(otNr-2, oaAdd);
   otlWiz.FullExpand;
  end; {with begin}

  procedure TfrmWizDlg.otlWizDragDrop(Sender, Source:
                                    TObject; X,Y:
                                          Integer);
begin
if source is TOutline then
  begin
    if otlwiz.items[otlwiz.getItem(x,y)].level = 1 then
    exit
    else
    with otlwiz.Items[dragSourceRow] do
    moveTo(otlwiz.selectedItem, oaInsert);
  end;
end;

  *)
Procedure MBeepNWait ;
Var
  Start: TDateTime ;
Begin
  Start := Now ;
  MessageBeep(Word(-1)) ;
  While Start + 1.00/24/60/60 > Now Do {Repeate} ;
End ;


initialization
  { Command-Line-Arguments heraussuchen }
  FillParams ;


end.
