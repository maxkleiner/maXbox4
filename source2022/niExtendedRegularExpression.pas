{: Extended Regular Expression matching
   @category Registered}
unit niExtendedRegularExpression;

interface

uses SysUtils, Classes,
     niRegularExpression, niTestCase;

type

TniSubRegularExpression = class;

// ==============================================================================================
// Object: TniExtendedRegularExpression
// ====================================

{: Extended Regular Expression matching functionality.
   An extension of the facilities available through TniRegularExpression that trades some
   performance for additional flexibility. Enhancements include:<p>
   <ul>
   <li> Subgroup Extraction<br>
        Portions of the Regular expression can be wrapped in parenthesis ( "(" and ")" ) and
        extracted once a match is complete. This is useful for simple parsing tasks.
   <li> Subgroup Matching<br>
        Once matched, the expression can require the same text to be repeated. For example,
        the expression (\a*)\1 will match any word composed of two identical halves, such as
        tomtom, pawpaw or nana.
   </ul>
   @category Registered }

TniExtendedRegularExpression = class(TObject)
private

  // Internal Variables

  FxFlags:              TniRegularExpressionMatchFlags;
  FxSubExpressionFlags: TniRegularExpressionMatchFlags;

  FsExpression: string;

  // Properties

  FoSubExpressions:  TStringList;
  FoMatches:         TStringList;
  FoIdentifiers:     TStringList;

  FiMatchStart:      integer;
  FiMatchLength:     integer;

  // Internal Methods

  { Attempt to find a match for the next subexpression
    @param sString String in which to match
    @param iSubExpression SubExpression we need
    @param iStart Character position to start at
    @param bFound Did we find a match? } 
  procedure TryMatch( const sString: string; iSubExpression: integer; iStart: integer;
                      var bFound: boolean);

protected

  // Internal Methods

  procedure ParseExpression( const sExpression: string);

  // Property Methods

  {: Get method for the <see property=SubExpressionCount> property
     @returns Count of Subexpressions parsed from the original expression }
  function GetSubExpressionCount: integer;

  {: Get method for the <see property=SubExpressions> property. Will instantiate
     the RegularExpression instance if required.
     @param iIndex Index of subexpression to return
     @returns Subexpression required }
  function GetSubExpressionByIndex( iIndex: integer): TniSubRegularExpression;

  {: Get method for the <see property=MatchCount> property.
     @returns Count of subexpression matches found }
  function GetMatchCount: integer;

  {: Get method for the <see property=Matches> property.
     @param iIndex Index of match to return
     @returns Text matched }
  function GetMatchByIndex( iIndex: integer): string;

  {: Get method for the <see property=MatchIdentifier> property. }
  function GetMatchIdentifierByIndex( iIndex: integer): string;

  {: Get method for the <see property=Matches> property.
     @param sName Name of Match to return
     @returns Text matched }
  function GetMatchByName( sName: string): string;

  {: Get method for the <see property=IdentifierCount> property
     @returns Count of identified subexpressions }
  function GetIdentifierCount: integer;

  {: Get method for the <see property=Identifiers> property
     @param iIndex Number of identifier to return
     @returns String name of identifier }
  function GetIdentifierByIndex( iIndex: integer): string;

public

  // Standard Methods

  constructor Create( const sRegularExpression: string; xFlags: TniRegularExpressionMatchFlags);
  destructor Destroy; override;

  // Operation Methods

  {: Search for a match in a given string.
     @param sString The string to search for matches
     @returns Result of search <See type=TniRegularExpressionMatchResult> }
  function Match( const sString: string): TniRegularExpressionMatchResult;

  // Properties

  {: Start position of overall match }
  property MatchStart: integer read FiMatchStart;

  {: Length of overall match }
  property MatchLength: integer read FiMatchLength;

  {: Count of subexpression matches found }
  property MatchCount: integer read GetMatchCount;

  {: Indexed access to found matches }
  property Matches[ iIndex: integer]: string read GetMatchByIndex;

  {: Indexed access to identifiers of found matches }
  property MatchIdentifier[ iIndex: integer]: string read GetMatchIdentifierByIndex;

  {: Named access to matches }
  property NamedMatches[ sName: string]: string read GetMatchByName;

  {: Count of Subexpressions parsed from the original expression }
  property SubExpressionCount: integer read GetSubExpressionCount;

  {: Indexed access to subexpressions }
  property SubExpressions[ iIndex: integer]: TniSubRegularExpression read GetSubExpressionByIndex;

  {: Count of identified (named) subexpressions defined }
  property IdentifierCount: integer read GetIdentifierCount;

  {: Indexed access to defined identifiers }
  property Identifiers[ iIndex: integer]: string read GetIdentifierByIndex;

end;

// ==============================================================================================
// Object: TniSubRegularExpression
// ===============================

{: Descendent of TniRegularExpression with the sole purpose of tracking additional information
   required by the Extended matcher
   @category Registered }

TniSubRegularExpression = class( TniRegularExpression)
private

  // Properties

  FbExtractMatch: boolean;
  FsName:         string;

  // Property Methods

  function GetIdentified: boolean;

public

  // Standard methods

  {: Create a new Regular Expression object to match a given subexpression.
     @param sExpression Text form of the Regular Expression to match
     @param xFlags Options to use for matching (See <See type=TniRegularExpressionMatchFlags>) }
  constructor Create( const sRule: string; xFlags: TniRegularExpressionMatchFlags);

  {: Destroy this instance. }
  destructor Destroy; override;

  // Properties

  {: Name of match }
  property Name: string read FsName write FsName;

  {: Should the match of this subexpression be included in matches }
  property ExtractMatch: boolean read FbExtractMatch write FbExtractMatch;

  {: Does this expression have a name? }
  property Identified: boolean read GetIdentified;

end;

// ==============================================================================================
// Test Unit: TniTestExtendedRegularExpression
// ===========================================

TniTestExtendedRegularExpression = class( TniTestCase)
private

  procedure TestMatch( oRegex: TniExtendedRegularExpression;
                       const sString: string; const sMatch: string;
                       const sID: string;
                       const sValue: string);

protected

  {: Run actual tests for this case.
     Do all of the actions required for the test. }
  procedure RunTest; override;

end;

// ==============================================================================================

implementation

uses niSTRING;

const
  csNotSupported = 'Cannot specify mfMultipleMatches or mfOverlapMatches for '
                   +'Extended Expression match';

// ==============================================================================================
// Object: TniExtendedRegularExpression
// ====================================

// Standard Methods
// ----------------

{: @todo Use curly brackets to isolate important areas. Allow ID: syntax to name them } 
constructor TniExtendedRegularExpression.Create( const sRegularExpression: string;
                                                       xFlags: TniRegularExpressionMatchFlags);
var
  sExpression: string;
begin
  inherited Create;

  FoSubExpressions := TStringList.Create;
  FoMatches := TStringList.Create;
  FoIdentifiers := TStringList.Create;

  FsExpression := sRegularExpression;
  sExpression := sRegularExpression;
  FxFlags := xFlags;
  FxSubExpressionFlags := xFlags + [mfOverlapMatches, mfMultipleMatches]
                                 - [mfLongMatches, mfShortMatches];

  if xFlags * [ mfMultipleMatches, mfOverlapMatches ] <> [] then
    raise EniRegularExpressionError.Create( csNotSupported);

  if mfStartOnly in FxFlags then begin
    Insert( '^', sExpression, 1);
    Exclude( FxSubExpressionFlags, mfStartOnly);
  end;

  if mfFinishOnly in FxFlags then begin
    Insert( '$', sExpression, Length(sExpression));
    Exclude( FxSubExpressionFlags, mfFinishOnly);
  end;

  ParseExpression( sExpression);
end;

destructor TniExtendedRegularExpression.Destroy;
begin
  FoSubExpressions.Free;
  FoMatches.Free;
  FoIdentifiers.Free;
  
  inherited Destroy;
end;

// Operation Methods
// -----------------

function TniExtendedRegularExpression.Match( const sString: string): TniRegularExpressionMatchResult;
var
  bFound: boolean;
  iScan:  integer;
begin
  FoMatches.Clear;
  bFound := false;
  for iScan := 1 to Length( sString) do begin
    FiMatchStart := iScan;
    TryMatch( sString, 0, iScan, bFound);
    if bFound or (mfStartOnly in FxFlags) then
      break;
  end;
  if bFound then
    Result := mrMatch
  else Result := mrFail;
end;

// Internal Methods
// ----------------

procedure TniExtendedRegularExpression.ParseExpression( const sExpression: string);

  function AddSubExpression( const sExpression: string): TniSubRegularExpression;
  begin
    Result := TniSubRegularExpression.Create( sExpression, FxSubExpressionFlags + [mfOverlapMatches, mfMultipleMatches] - [mfLongMatches]);
    FoSubExpressions.AddObject( sExpression, Result);
  end;

const
  csNestingNotSupported = 'Nested {subexpressions} are not supported';
  csFoundEndExpression = 'Found end of subexpression ''}'' without matching start';
var
  iScan:         integer;
  iStart:        integer;   // start of expression (char after { or } )
  bInExpression: boolean;
  bEscaped:      boolean;
  bHasName:      boolean;
  sName:         string;
  oExpression:   TniSubRegularExpression;
begin

  iStart := 1;
  iScan := 1;
  bInExpression := false;
  bEscaped := false;
  bHasName := false;

  while iScan <= Length( sExpression) do begin
    case sExpression[iScan] of
      '{': if not bEscaped then begin
             if bInExpression then
               raise EniRegularExpressionError.Create( csNestingNotSupported);
             if iScan-iStart>0 then
               AddSubExpression( Copy( sExpression, iStart, iScan-iStart));
             bInExpression := true;
             sName := '';
             bHasName := true;
             iStart := iScan+1;
           end;
      '}': if not bEscaped then begin
             if not bInExpression then
               raise EniRegularExpressionError.Create( csFoundEndExpression);
             if iScan-iStart>0 then begin
               oExpression := AddSubExpression( Copy( sExpression, iStart, iScan-iStart));
               oExpression.Name := sName;
               oExpression.ExtractMatch := true;
               if not StrEmpty( sName) then
                 FoIdentifiers.AddObject( sName, oExpression);
             end;
             iStart := iScan+1;
             bInExpression := false;
           end;
      ':': if bInExpression and bHasName then begin
             sName := Copy( sExpression, iStart, iScan-iStart);
             bHasName := false;
             iStart := iScan +1;
           end;
      'A'..'Z',
      'a'..'z',
      '0'..'9': // Nothing
    else
      bHasName := false;
    end;
    bEscaped := sExpression[iScan]='\';
    Inc( iScan);
  end;

  if Length(sExpression)>=iStart then
    FoSubExpressions.Add( Copy( sExpression, iStart, Length(sExpression)-iStart+1));
end;

// Property Methods
// ----------------

function TniExtendedRegularExpression.GetSubExpressionCount: integer;
begin
  Result := FoSubExpressions.Count;
end;

function TniExtendedRegularExpression.GetSubExpressionByIndex( iIndex: integer): TniSubRegularExpression;
var
  sExpression: string;
  iScan:       integer;
begin
  Result := FoSubExpressions.Objects[iIndex] as TniSubRegularExpression;

  if not Assigned( Result) then begin
    sExpression := FoSubExpressions[iIndex];
    for iScan := 0 to MatchCount-1 do
      sExpression := StringReplace( sExpression, '\'+IntToStr(iScan), Matches[iScan], [rfReplaceAll]);
    Result := TniSubRegularExpression.Create( sExpression, FxSubExpressionFlags );
    FoSubExpressions.Objects[iIndex] := Result;
  end;

end;

function TniExtendedRegularExpression.GetMatchCount: integer;
begin
  Result := FoMatches.Count;
end;

function TniExtendedRegularExpression.GetMatchByIndex( iIndex: integer): string;
begin
  Result := FoMatches[iIndex];
end;

function TniExtendedRegularExpression.GetMatchIdentifierByIndex( iIndex: integer): string;
var
  oExpr: TniSubRegularExpression;
begin
  oExpr := FoMatches.Objects[iIndex] as TniSubRegularExpression;
  Result := oExpr.Name;
end;

function TniExtendedRegularExpression.GetMatchByName( sName: string): string;
var
  iExpression: integer;
  oExpression: TniSubRegularExpression;
begin

  iExpression := FoIdentifiers.IndexOf( sName);
  if iExpression=-1 then
    raise EniRegularExpressionError.Create( 'No subexpression with name '+sName+' found')
  else begin
    oExpression := FoIdentifiers.Objects[iExpression] as TniSubRegularExpression;
    Result := oExpression.Matches[0].Text;
  end;
end;

function TniExtendedRegularExpression.GetIdentifierCount: integer;
begin
  Result := FoIdentifiers.Count;
end;

function TniExtendedRegularExpression.GetIdentifierByIndex( iIndex: integer): string;
begin
  Result := FoIdentifiers[iIndex];
end;

// Internal Methods
// ----------------

procedure TniExtendedRegularExpression.TryMatch( const sString: string; iSubExpression: integer;
                                                       iStart: integer; var bFound: boolean);
var
  iScan:          integer;
  oSubExpression: TniSubRegularExpression;
  oMatch:         TniRegularExpressionMatch;
  bDone:          boolean;
begin
  if iSubExpression >= SubExpressionCount then begin
    FiMatchLength := iStart - FiMatchStart;
    bFound := true;
  end
  else begin
    bFound := false;
    oSubExpression := SubExpressions[iSubExpression];

    if oSubExpression.Match( sString, iStart)=mrMatch then begin

      if mfShortMatches in FxFlags then
        iScan := 0
      else iScan := oSubExpression.MatchCount-1;
      bDone := false;

      while not bDone do begin
        oMatch := oSubExpression.Matches[iScan];
        TryMatch( sString, iSubExpression+1, iStart+oMatch.Length, bFound);
        if bFound then begin
          if oSubExpression.ExtractMatch then
            FoMatches.InsertObject( 0, Copy( sString, oMatch.Start, oMatch.Length), oSubExpression);
          break;
        end;

        if mfShortMatches in FxFlags then begin
          Inc( iScan);
          bDone := iScan >= oSubExpression.MatchCount;
        end
        else begin
          Dec( iScan);
          bDone := iScan <= 0;
        end;
      end;

    end;
  end;
end;

// ==============================================================================================
// Object: TniSubRegularExpression
// ===============================

constructor TniSubRegularExpression.Create( const sRule:  string;
                                                  xFlags: TniRegularExpressionMatchFlags);
begin
  inherited Create( sRule, xFlags);

end;

destructor TniSubRegularExpression.Destroy;
begin

  inherited Destroy;
end;

// Property Methods
// ----------------

function TniSubRegularExpression.GetIdentified: boolean;
begin
  Result := not StrEmpty( Name);
end;

// ==============================================================================================
// Test Unit: TniTestExtendedRegularExpression
// ===========================================

procedure TniTestExtendedRegularExpression.RunTest;
var
  oExpression: TniExtendedRegularExpression;
begin
  oExpression := TniExtendedRegularExpression.Create( '{ID:[A-Za-z]+}={VALUE:[0-9]+}',
                                                      [ ]);
  try
    VerifyAssigned( oExpression, 'Should have an expression to test');

    TestMatch( oExpression, 'X=4', 'X=4',
                            'X', '4');
    TestMatch( oExpression, 'one two three x=4 five six', 'x=4',
                            'x', '4');
    TestMatch( oExpression, 'twohundredfiftytwo=252', 'twohundredfiftytwo=252',
                            'twohundredfiftytwo', '252');
    TestMatch( oExpression, 'one thousand and twohundredfiftytwo=252 does not match',
                            'twohundredfiftytwo=252', 'twohundredfiftytwo', '252');

  finally
    oExpression.Free;
  end;
end;

procedure TniTestExtendedRegularExpression.TestMatch( oRegex: TniExtendedRegularExpression;
                                                      const sString: string;
                                                      const sMatch: string;
                                                      const sID: string;
                                                      const sValue: string);
var
  eMatch:      TniRegularExpressionMatchResult;
  sFound:      string;
begin
  eMatch := oRegex.Match( sString);
  Verify( eMatch=mrMatch, 'Should have match for '+sString);

  sFound := Copy( sString, oRegex.MatchStart, oRegex.MatchLength);
  VerifyEquals( sFound, sMatch, 'Should have found '+sMatch+'; actually found '+sFound);

  VerifyEquals( 2, oRegex.MatchCount, 'Should have two matches');
  VerifyEquals( 'ID', oRegex.MatchIdentifier[0],
                'First match should be "ID", actually have '+oRegex.Identifiers[0]);
  VerifyEquals( 'VALUE', oRegex.MatchIdentifier[1],
                'Second match should be "VALUE", actually have '+oRegex.Identifiers[1]);

  VerifyEquals( oRegex.Matches[0], sID,
                'Should have ID='+sID+'; actually have ID='+oRegex.Matches[0]);
  VerifyEquals( oRegex.Matches[1], sValue,
                'Should have VALUE='+sValue+'; actually have VALUE='+oRegex.Matches[1]);

end;

end.
