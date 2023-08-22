{ @abstract(This unit contains some texts localized to different languages)
  @author(Tomas Krysl (tk@@tkweb.eu))
  @created(20 Oct 2001)
  @lastmod(12 Feb 2014)

  Copyright � 2001-2014 Tomas Krysl (tk@@tkweb.eu)<BR><BR>

  <B>License:</B><BR>
  This code is distributed as a freeware. You are free to use it as part
  of your application for any purpose including freeware, commercial and
  shareware applications. The origin of this source code must not be
  misrepresented; you must not claim your authorship. All redistributions
  of the original or modified source code must retain the original copyright
  notice. The Author accepts no liability for any damage that may result
  from using this code. }

unit KRes;

{$include kcontrols.inc}
{$WEAKPACKAGEUNIT ON}

interface

{ Because the resourcestring concept used in Delphi is not always the best way to localize an application,
  I decided to implement routines which allow to modify the resourcestrings dynamically at runtime.
  They allow for direct localization e.g. from XML file without the need of the standard localization scheme
  for resourcestrings. Especially if you need to translate only some of the strings it is much easier approach. }

{ Standard resourcestrings localized to english by default }
resourcestring
  // KGraphics texts
  sGrAlphaBitmap = 'KControls alpha bitmap';

  // KDialogs texts
  sBrowseDirectory = 'Choose directory:';

  // KEdits texts
  sEDBadSubDirName = 'The invalid subdirectory "%s" has been replaced with "%s".';
  sEDCurrentDirAdded = 'Current path added to path "%s".';
  sEDBadDir = 'The directory "%s" can be invalid.';
  sEDBadDirCorr = 'Invalid or incomplete directory "%s" has been replaced with "%s".';
  sEDBadPath = 'The path or file name "%s" can be incomplete or invalid.';
  sEDBadPathCorr = 'Invalid path or file name "%s" has been replaced with "%s".';
  sEDMissingFileName = 'Missing file name.';
  sEDNoExistingDir = 'The directory "%s" doesn''t exist.';
  sEDNoExistingPath = 'The file "%s" doesn''t exist.';
  sEDFormatNotAccepted = 'The text either doesn''t represent a numeral or the numeric format cannot be accepted.';
  sEDBadFloatValueAsStr = 'The text is not a float value in the range from %s to %s. Value corrected to %s.';
  sEDBadIntValueAsStr = 'The text is not a decimal value in the range from %s to %s. Value corrected to %s.';
  sEDBadHexValueAsStr = 'The text is not a hexadecimal value in the range from %s to %s. Value corrected to %s.';
  sEDClipboardFmtNotAccepted = 'The current clipboard text cannot be accepted.';
  sEDBrowse = 'Browse ...';
  sEDAllFiles = 'All files (*.*)|*.*';

  // KGraphics texts
  sGDIError = 'GDI object could not be created.';
  sErrGraphicsLoadFromResource = 'Graphics could not be loaded from resource.';

  // KHexEditor texts
  sHEAddressText = 'Address area text';
  sHEAddressBkGnd = 'Address area background';
  sHEBkGnd = 'Editor background';
  sHEDigitTextEven = 'Digit area even column';
  sHEDigitTextOdd = 'Digit area odd column';
  sHEDigitBkgnd = 'Digit area background';
  sHEHorzLines = 'Horizontal lines';
  sHEInactiveCaretBkGnd = 'Inactive caret background';
  sHEInactiveCaretSelBkGnd = 'Selected inactive caret background';
  sHEInactiveCaretSelText = 'Selected inactive caret text';
  sHEInactiveCaretText = 'Inactive caret text';
  sHELinesHighLight = 'Lines highlight';
  sHESelBkGnd = 'Selection background';
  sHESelBkGndFocused = 'Focused selection background';
  sHESelText = 'Selection text';
  sHESelTextFocused = 'Focused selection text';
  sHESeparators = 'Area separating lines';
  sHETextText = 'Text area text';
  sHETextBkGnd = 'Text area background';
  sHEVertLines = 'Vertical lines';

  // KIcons texts
  sIconIcons = 'Icons';
  sIconCursors = 'Cursors';
  sIconAllocationError = 'Error while allocating icon data';
  sIconBitmapError = 'Invalid icon bitmap handles';
  sIconFormatError = 'Invalid icon format';
  sIconResourceError = 'Invalid icon resource';
  sIconIndexError = 'Invalid icon resource index';
  sIconInvalidModule = 'Invalid module or no icon resources';
  sIconResizingError = 'Error while resizing icon';
  sIconAssocResolveError = 'Error while resolving associated icon';

  // KLog texts
  sLogError = 'Error';
  sLogWarning = 'Warning';
  sLogNote = 'Note';
  sLogHint = 'Hint';
  sLogInfo = 'Info';
  sLogInputError = 'Input error';
  sLogIOError = 'IO error';

  // KMessagebox texts
  sMsgBoxYes = '&Yes';
  sMsgBoxNo = '&No';
  sMsgBoxOK = '&OK';
  sMsgBoxCancel = 'Cancel';
  sMsgBoxClose = '&Close';
  sMsgBoxAbort = 'A&bort';
  sMsgBoxRetry = '&Retry';
  sMsgBoxIgnore = '&Ignore';
  sMsgBoxAll = '&All';
  sMsgBoxNoToAll = 'Non&e';
  sMsgBoxYesToAll = 'Ye&s to all';
  sMsgBoxHelp = '&Help';

  // KPrinterSetup texts
  sPSPrinterSetup = 'Printer setup';
  sPSAllPages = 'All pages (%d)';
  sPSErrPrintSetup = 'Print setup error';
  sPSErrNoPrinterInstalled = 'No printer is installed on this computer.';

  // KControlsDesign texts
  sInvalidGraphicFormat = 'Invalid graphic format.';

  // KDBGrids texts
  sDataSetUnidirectional = 'Cannot use KDBGrid with a unidirectional dataset.';

  // KMemoRTF texts
  sErrMemoLoadFromRTF = 'Error while reading RTF file.';
  sErrMemoLoadImageFromRTF = 'Error while loading image from RTF file.';
  sErrMemoSaveToRTF = 'Error while saving RTF file.';

  // KMemoFrame texts
  sAppError = 'Application error';
  sAppQuery = 'Application query';
  sMemoDefaultFileName = 'document';
  sQueryFileSave = 'File "%s" has been changed. Do you want to save it?';
  sErrMemoLoadFromFile = 'Error while loading file "%s".';
  sErrMemoSaveToFile = 'Error while saving file "%s".';

{ Localize given resourcestring directly.
  Usage: ResMod(@sYourResourceString, 'New text');
  Note: Text passed to NewValue must persist through the entire
  application lifetime under Delphi, as only its pointer is taken! }
procedure ResMod(Res: PResStringRec; const NewValue: string);

{ Localize all resourcestrings to Czech language. }
procedure LocalizeToCzech;

implementation

uses
{$IFDEF FPC}
  LResources;
{$ELSE}
  Windows, KFunctions;
{$ENDIF}

{$IFDEF FPC}
type
  PResModRec = ^TResModRec;
  TResModRec = record
    DefStr: string;
    NewStr: string;
  end;

function ResModIterator(Name, Value: AnsiString; Hash: Longint; arg:pointer): AnsiString;
begin
  if Value = PResModRec(arg).DefStr then
    Result := PResModRec(arg).NewStr
  else
    Result := '';
end;

procedure ResMod(Res: PResStringRec; const NewValue: string);
var
  RM: TResModRec;
begin
  if (Res <> nil) and (Res^ <> '') then
  begin
    RM.DefStr := Res^;
    RM.NewStr := NewValue;
    SetResourceStrings(ResModIterator, @RM);
  end;
end;
{$ELSE}
procedure ResMod(Res: PResStringRec; const NewValue: string);
var
  OldProtect: LongWord;
  OK: Boolean;
begin
  if (Res <> nil) and (Res.Module <> nil) then
  begin
    OK := VirtualProtect(Res, Sizeof(TResStringRec), PAGE_EXECUTE_READWRITE, @oldProtect);
    if OK then
    begin
      Res.Identifier := LONG_PTR(NewValue);
      VirtualProtect(Res, SizeOf(TResStringRec), oldProtect, @oldProtect);
    end;
  end;
end;
{$ENDIF}

procedure LocalizeToCzech;
begin
  // KGraphics texts
  ResMod(@sGrAlphaBitmap, 'Alpha bitmap KControls');

  // KDialogs texts
  ResMod(@sBrowseDirectory, 'Vyberte slo�ku:');

  // KEdits texts
  ResMod(@sEDBadSubDirName, 'Neplatn� podslo�ka "%s" byla nahrazena "%s".');
  ResMod(@sEDCurrentDirAdded, 'Aktu�ln� cesta byla p�id�na k cest� "%s".');
  ResMod(@sEDBadDir, 'Slo�ka "%s" m��e b�t neplatn�.');
  ResMod(@sEDBadDirCorr, 'Neplatn� nebo nekompletn� slo�ka "%s" byla nahrazena "%s".');
  ResMod(@sEDBadPath, 'Cesta nebo soubor "%s" nemus� b�t kompletn� nebo platn�.');
  ResMod(@sEDBadPathCorr, 'Neplatn� cesta nebo soubor "%s" byl(a) nahrazen(a) "%s".');
  ResMod(@sEDMissingFileName, 'Chyb� n�zev souboru.');
  ResMod(@sEDNoExistingDir, 'Slo�ka "%s" neexistuje.');
  ResMod(@sEDNoExistingPath, 'Soubor "%s" neexistuje.');
  ResMod(@sEDFormatNotAccepted, 'Text nen� ��slem nebo ��seln� form�t nelze p�ijmout.');
  ResMod(@sEDBadFloatValueAsStr, 'Text nen� re�ln�m ��slem v rozsahu od %s do %s. Hodnota opravena na %s.');
  ResMod(@sEDBadIntValueAsStr, 'Text nen� cel�m ��slem v rozsahu od %s do %s. Hodnota opravena na %s.');
  ResMod(@sEDBadHexValueAsStr, 'Text nen� hexadecim�ln�m ��slem od %s do %s. Hodnota opravena na %s.');
  ResMod(@sEDClipboardFmtNotAccepted, 'Text ze schr�nky nelze p�ijmout.');
  ResMod(@sEDBrowse, 'Proch�zet...');
  ResMod(@sEDAllFiles, 'V�echny soubory (*.*)|*.*');

  // KGraphics texts
  ResMod(@sGDIError, 'Objekt GDI nelze vytvo�it.');

  // KHexEditor texts
  ResMod(@sHEAddressText, 'P�s adresy - text');
  ResMod(@sHEAddressBkGnd, 'P�s adresy - pozad�');
  ResMod(@sHEBkGnd, 'Pozad� editoru');
  ResMod(@sHEDigitTextEven, 'P�s ��slic sud� sloupec - text');
  ResMod(@sHEDigitTextOdd, 'P�s ��slic lich� sloupec - text');
  ResMod(@sHEDigitBkgnd, 'P�s ��slic - pozad�');
  ResMod(@sHEHorzLines, 'Vodorovn� linky');
  ResMod(@sHEInactiveCaretBkGnd, 'Neaktivn� kurzor - pozad�');
  ResMod(@sHEInactiveCaretSelBkGnd, 'Neaktivn� kurzor pozad� v�b�ru');
  ResMod(@sHEInactiveCaretSelText, 'Neaktivn� kurzor text v�b�ru');
  ResMod(@sHEInactiveCaretText, 'Neaktivn� kurzor - text');
  ResMod(@sHELinesHighLight, 'Zv�razn�n� ��dk�');
  ResMod(@sHESelBkGnd, 'Pozad� v�b�ru');
  ResMod(@sHESelBkGndFocused, 'Pozad� aktivn�ho v�b�ru');
  ResMod(@sHESelText, 'Text v�b�ru');
  ResMod(@sHESelTextFocused, 'Text aktivn�ho v�b�ru');
  ResMod(@sHESeparators, 'Odd�lovac� linky p�s�');
  ResMod(@sHETextText, 'P�s textu - text');
  ResMod(@sHETextBkGnd, 'P�s textu - pozad�');
  ResMod(@sHEVertLines, 'Svisl� linky');

  // KIcons texts
  ResMod(@sIconIcons, 'Ikony');
  ResMod(@sIconCursors, 'Kurzory');
  ResMod(@sIconAllocationError, 'Chyba p�i alokov�n� dat ikony');
  ResMod(@sIconBitmapError, 'Neplatn� popisova�e bitmap ikony');
  ResMod(@sIconFormatError, 'Neplatn� form�t ikony');
  ResMod(@sIconResourceError, 'Neplatn� zdroj ikony');
  ResMod(@sIconIndexError, 'Neplatn� index zdroje ikony');
  ResMod(@sIconInvalidModule, 'Neplatn� modul nebo chyb� zdroje ikon');
  ResMod(@sIconResizingError, 'Chyba p�i zm�n� velikosti ikony');
  ResMod(@sIconAssocResolveError, 'Chyba p�i nahr�v�n� asociovan� ikony');

  // KLog texts
  ResMod(@sLogError, 'Chyba');
  ResMod(@sLogWarning, 'Varov�n�');
  ResMod(@sLogNote, 'Pozn�mka');
  ResMod(@sLogHint, 'N�pov�da');
  ResMod(@sLogInfo, 'Informace');
  ResMod(@sLogInputError, 'Chyba zad�n�');
  ResMod(@sLogIOError, 'Chyba IO operace');

  // KMessagebox texts
  ResMod(@sMsgBoxYes, '&Ano');
  ResMod(@sMsgBoxNo, '&Ne');
  ResMod(@sMsgBoxOK, '&OK');
  ResMod(@sMsgBoxCancel, 'Storno');
  ResMod(@sMsgBoxClose, 'Za&v��t');
  ResMod(@sMsgBoxAbort, '&P�eru�it');
  ResMod(@sMsgBoxRetry, '&Znovu');
  ResMod(@sMsgBoxIgnore, '&Ignorovat');
  ResMod(@sMsgBoxAll, 'V�&e');
  ResMod(@sMsgBoxNoToAll, 'Ni&c');
  ResMod(@sMsgBoxYesToAll, 'Ano pro v�e');
  ResMod(@sMsgBoxHelp, 'N�pov�da');

  // KPrinterSetup texts
  ResMod(@sPSPrinterSetup, 'Nasteven� tisk�rny');
  ResMod(@sPSAllPages, 'V�echny str�nky (%d)');
  ResMod(@sPSErrPrintSetup, 'Chybn� nastaven� tisku');
  ResMod(@sPSErrNoPrinterInstalled, 'Na po��ta�i nen� instalov�na ��dn� tisk�rna.');

  // KControlsDesign texts
  ResMod(@sInvalidGraphicFormat, 'Neplatn� grafick� form�t.');

  // KDBGrids texts
  ResMod(@sDataSetUnidirectional, 'Nelze pou��t KDBGrid s jednosm�rn�m datasetem.');

  // KMemoRTF texts
  ResMod(@sErrMemoLoadFromRTF, 'Chyba p�i �ten� souboru RTF.');
  ResMod(@sErrMemoLoadImageFromRTF, 'Chyba p�i �ten� obr�zku z RTF souboru.');
  ResMod(@sErrMemoSaveToRTF, 'Chyba p�i z�pisu souboru RTF.');

  // KMemoFrame texts
  ResMod(@sAppError, 'Chyba aplikace');
  ResMod(@sAppQuery, 'Dotaz aplikace');
  ResMod(@sMemoDefaultFileName, 'dokument');
  ResMod(@sQueryFileSave, 'Soubor "%s" byl zm�n�n. P�ejete si jej ulo�it?');
  ResMod(@sErrMemoLoadFromFile, 'Chyba p�i �ten� souboru "%s".');
  ResMod(@sErrMemoSaveToFile, 'Chyba p�i z�pisu souboru "%s".');

end;

end.
