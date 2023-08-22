{: Regular Expression matching library. }
unit niRegularExpression;

interface

uses SysUtils, Classes, Contnrs,
     niSTRING, niTestCase;

type

TniRegularExpression = class;
TniRegularExpressionState = class;
TniRegularExpressionTransition = class;
TniRegularExpressionMatch = class;

// ==============================================================================================
// Type: TniRegularExpressionParserState
// =====================================

{: Enumerated type to identify what the parser is currently creating.
   @enum psStates Parser is adding states to the NFA
   @enum psCharRange Parser is reading the definition of a Character Range }
TniRegularExpressionParserState  = (psStates, psCharRange);

// ==============================================================================================
// Type: TniRegularExpressionParserFlag
// ====================================

{: A list of possible flags to further identify the nature of a parsed character.
   @enum pfEscaped Character was preceded by '\' in the input stream. <p>
                   If the character normally has a special meaning (eg: ? * [ ] ) then it will be
                   treated simply as a normal character with no special significance.<br>
                   If the character normally has no significance, it may be treated with
                   special significance (eg: \d = [0-9], \t = tab and so on) }
TniRegularExpressionParserFlag = (pfEscaped);

// ==============================================================================================
// Type: TniRegularExpressionParserFlags
// =====================================

{: A Set of TniRegularExpressionParserFlag items }
TniRegularExpressionParserFlags = set of TniRegularExpressionParserFlag;

// ==============================================================================================
// Enumumeration: TniRegularExpressionStateType
// ============================================

TniRegularExpressionStateType = (stNormal, stGroupStart, stGroupFinish);

// ==============================================================================================
// Enumeration: TniRegularExpressionMatchFlag
// ==========================================

{: Specifiers for the behaviour of a Match.
   These specifiers are used to configure the Matcher for the type of matches desired.
   Note that lack of a flag implies the reverse state ie a match is case insensitive unless
   mfCaseSensitive is specified.<p>
   Some useful combinations:
   <ul>
   <li> mfStartOnly + mfLongMatches: Find longest match at the start<br>Useful for parsing
   <li> mfMultipleMatches + mfOverlapMatches: Find all matches anywhere
   <li> mfStartOnly + mfFinishOnly: Entire line must match, not just a portion
   </ul>
   Combining mfAllMatches with mvOverlapMatches may result in a large number of results.<br>
   Combinging mfStartOnly with mfFinishOnly requires that the entire line match the
   expression.<p>
   mfStartOnly can be specified by begining the Regular Expression with '^'<br>
   mfFinishOnly can be specified by ending the Regular Expression with '$'<br>

   @enum mfStartOnly
         Only match at the start of the string (default is to find a match anywhere)
   @enum mfFinishOnly
         Match must terminate at the end of the string (default is to permit a match finishing
         anywhere)

   @enum mfCaseSensitive
         Matches don't depend on case (default case is case sensitive)

   @enum mfLongMatches
         Discard short matches in favour of longer matches
   @enum mfShortMatches
         Discard long matches in favour of short matches

   @enum mfMultipleMatches
         Find all possible matches, not just the first
   @enum mfOverlapMatches
         Find overlapping matches
   @category GettingStarted
   }

TniRegularExpressionMatchFlag = ( mfStartOnly, mfFinishOnly,
                                  mfCaseInsensitive,
                                  mfLongMatches, mfShortMatches,
                                  mfMultipleMatches, mfOverlapMatches);

// ==============================================================================================
// Set: TniRegularExpressionMatchFlags
// ===================================

{: Set of <See Type=TniRegularExpressionMatchFlag> values. }
TniRegularExpressionMatchFlags = set of TniRegularExpressionMatchFlag;

// ==============================================================================================
// Enumeration: TniRegularExpressionMatchResult
// ============================================

{: Possible results from a Regular Expression Match.
   @enum mrNone No match attempted yet
   @enum mrFail No accepted Match
   @enum mrMatch Match Found
   @enum mrInsufficient Ran out of string while matching }
TniRegularExpressionMatchResult = (mrNone, mrFail, mrMatch, mrInsufficient);

// ==============================================================================================
// Exception: EniRegularExpressionError
// ====================================

{: Exception type raised for problems within a Regular Expression }
EniRegularExpressionError = class(Exception);

// ==============================================================================================
// Object: TniRegularExpression
// ============================

{: Regular Expression Matching object.<p>
   This class provides easy to use Regular Expression string matching for use in wider
   applications.  Use includes language lexers & parsers, searching tools and so on. <p>
   <b>Regular Expressions</b><br>
   Regular Expressions are a powerful mechanism for searching and matching within plain text.
   This object implements Regular expressions with the following syntax:
   <ul>
   <li> a matches the character a
   <li> abc matches characters a, b and c in that order
   <li> a|b matches either a or b
   <li> a? matches a or no a (optionality)
   <li> a* matches any number of a or no a (optional with repetition)
   <li> a+ matches one or more a (required with repetition)
   <li> . matches any one character (tab, space or visible character)
   <li> [abc] matches any one of a, b, c
   <li> [a-g] matches any letter from a to g
   <li> \d matches any digit [0-9]
   <li> \a matches any letter [A-Za-z]
   <li> \w matches any letter or digit [0-9A-Za-z]
   <li> \t matches a tab (#9)
   <li> \n matches a newline (#10 or #13)
   <li> \b matches space (#32) or tab (#9)  
   <li> \+ matches + (escape)
   <li> \. matches .
   <li> ^ matches start of string
   <li> $ matches end of string
   </ul>
   <b>Operation</b><br>
   Developed from first principals and NFA/DFA theory, this object works as follows (note that this
   description uses terminology which should in reality be confined to a Computer Science
   paper):<br>
   <ol>
   <li> Parse Regular Expression into a Non-deterministic Finite State Automata (NFA) with
        lambda transitions
   <li> Merge identical states
   <li> Eliminate Lambda transitions
   <li> Merge identical states<br>
        (The Removal of lambda transitions can reveal that two transitions are actually identical
        when they didn't appear so initially)
   <li> Removal of unreachable states
   <li> Removal of non-determinism
   <li> Use the resultant DFA to match an input stream
   </ol>
   Note that some Computer Science courses and textbooks use the term "epsilon transition"
   instead of "lambda transition" - in both cases the meaning is the same: A transition in the
   NFA which does not consume any characters of input.
   @category GettingStarted
   @example Sample Expressions
   <ul>
   <li>Integer: \d+ <br>
       (one or more digits)
   <li>Number: \d+(.\d+)? <br>
       (one or more digits optionally followed by decimal point and one or more digits)
   <li>Money: \$\d+(,\d\d\d)*(\.\d\d) <br>
       (Optional dollar sign, followed by 1 or more digits, followed by comma and three digits
       multiple times, optionally followed by a decimal point and two digits)
   <li>Words: colou?r <br>
       (Match c, o, l, o, optional u, r - american or english spelling)
   <li> Number as word: one|two|three|four|five|six|seven|eight|nine|ten <br>
        Exactly one of one, two, three, four, five, six, seven, eight, nine, ten
   </ul>
    }

TniRegularExpression = class(TObject)
private

  // Internal Variables

  FoStates: TObjectList;
  FeState:  TniRegularExpressionParserState ;
  FxFlags:  TniRegularExpressionMatchFlags;

  FoCurrentState: TniRegularExpressionState;

  FxCharRange:    TCharSet;
  FbInvertedSet:  boolean;
  FsPartialChars: string;
  FbIsRange:      boolean;

  FaoStartStack:  array of TniRegularExpressionState;         // Stack of Group start states
  FaoFinishStack: array of TniRegularExpressionState;         // Stack of Group finish states
  FiStack:        integer;                                    // Size of Stack

  // Properties

  FoMatches: TObjectList;

  FoStartState: TniRegularExpressionState;

  FsExpression: string;

  // Internal Methods

  {: Parse a regular expression and create a state machine for recognition.
     @param sRule Regular Expression to parse
     @raises EniRegularExpressionError If a syntax error is encountered in the expression }
  procedure ParseExpression( sRule: string);

  {: Preprocess the expression to simplify the cases we need to handle }
  function PreprocessedExpression( sRule: string): string;

  {: Parse a single character when creating states }
  procedure ParseForState( cCharacter: char; xFlags: TniRegularExpressionParserFlags);

  {: Parse a single character when creating a Character Range }
  procedure ParseForRange( cCharacter: char; xFlags: TniRegularExpressionParserFlags);

  {: Add a transition to a state and set that new state as the current state.
     @param oNewState State to transition to. If nil, creates a new ordinary state to use.
     @param xCharacters Set of characters to transition upon
     @returns New value of FoCurrentState }
  function AddTransition( oNewState:   TniRegularExpressionState;
                          xCharacters: TCharSet): TniRegularExpressionState;

  // State machine methods

  {: Start a New Group. Groups are enclosed in regular expressions by '(' and ')'. }
  procedure BeginGroup;

  {: Finish a Group. Groups are enclosed in regular expressions by '(' and ')'. }
  procedure FinishGroup;

  {: Start another branch }
  procedure AddBranch;

  {: Add Repeating to the last state }
  procedure AddRepetition;

  {: Add Optionality to the last state }
  procedure AddOptional;

  {: Initialise for parsing a Character Range }
  procedure StartRange;

  // Optimization Methods

  {: Optimize the NFA into a DFA for efficient use.<p>
     @see MakeCaseInsensitive
     @see PropagateAcceptedFlags
     @see RemoveRedundantStates
     @see CollapseIdenticalStates
     @see RemoveLambdaTransitions }
  procedure Optimize;

  {: Modify the NFA to be Case Insensitive }
  procedure MakeCaseInsensitive;

  {: Do some basic simplifications to the NFA }
  procedure Simplify;

  {: Transform the NFA into an equivilent DFA. This is less space efficient than the NFA but
     much much faster to handle. }
  procedure MakeDeterministic;

  {: Determine all the Accept states of the NFA.<p>
     We begin with a single acceptance state in the NFA built by the parsing routine. To allow
     for the elimination of lambda rules (which are expensive to retain when matching) we need
     to find the other states which should also accept. These are states which have a lambda
     transition (or a series of lambda transitions) to any accepting state. }
  procedure PropagateAcceptedFlags;

  {: Find and remove any states which are not reachable from our start state. }
  procedure RemoveRedundantStates( oStart: TniRegularExpressionState);

  {: Find and merge any states which are semantically identical - states which add no information
     to the NFA.<p>
     If states (A) and (B) both have identical sets of exit transitions, then we gain no
     additional information by having them as separate states - and they can be merged. This is
     achieved by changing all entry transitions to (B) to instead go to (A). Note that this
     process will result in (B) being unreachable - a subsequent call to <See
     Method=RemoveRedundantStates> will clean this up. }
  procedure CollapseIdenticalStates;

  {: Remove lambda transitions from the NFA.<p>
     Lambda transitions are a powerful expressive tool - but they are expensive to use when
     recognising a Regular Expression. By removing lambda transitions, it becomes more efficient
     to use the NFA.<p>
     This works as follows: If State A has a lambda transition to B, and B has a transition to C
     on [a-z], then the lambda transition A->B can be replaced with a normal transition A to C on
     [a-z]<p>
     ie:  (A) ---lambda--> (B) ---[a-z]--> (C) == (A) ---[a-z]-> (C) }
  procedure RemoveLambdaTransitions;

  {: Calculate the First sets of each transition - the possible characters which may result in
     a transition from a given state. }
  procedure CalculateFirstSets;

  // TniRegularExpresionMatcher Methods

  {: Record a new match for this expression }
  procedure AddMatch( const iStart: integer; const sText: string);

  {: Clear all recorded matches }
  procedure ClearMatches;

  // Property Methods

  {: Read function for StateCount property }
  function GetStateCount: integer;

  {: Read function for States property }
  function GetStateByIndex( iIndex: integer): TniRegularExpressionState;

  {: Read function for MatchCount property }
  function GetMatchCount: integer;

  {: Read function for Matches property }
  function GetMatchByIndex( iIndex: integer): TniRegularExpressionMatch;

public

  // Standard methods

  {: Create a new Regular Expression object to match a given RE.
     @param sExpression Text form of the Regular Expression to match
     @param xFlags Options to use for matching (See <See type=TniRegularExpressionMatchFlags>) }
  constructor Create( const sRule: string; xFlags: TniRegularExpressionMatchFlags);

  {: Destroy this instance. }
  destructor Destroy; override;

  {: Create a new Regular Expression from a FileSpec style string similar to those used for
     file specifications. * matches zero or more characters; ? matches any one character. }
  class function CreateGlobber( sFilespec: string): TniRegularExpression;

  // Operation Methods

  {: Search for a match in a given string.
     @param sString The string to search for matches
     @returns Result of search <See type=TniRegularExpressionMatchResult> }
  function Match( const sString: string): TniRegularExpressionMatchResult; overload;

  {: Search for a match in a given string from a designated start point
     @param sString The string to search for matches
     @param iStart Position at which the matches must begin
     @returns Result of search <See type=TniRegularExpressionMatchResult> }
  function Match( const sString: string; iStart: integer): TniRegularExpressionMatchResult; overload;

  // Description Methods

  {: Add details of this Regular Expressions state table to the give TStrings instance.
     Intended mostly for debugging changes and bug fixes. }
  procedure DumpStateTable( oStrings: TStrings);

  // Internal Methods

  {: Create a new state and return it }
  function NewState( eType: TniRegularExpressionStateType): TniRegularExpressionState;

  {: Get the composite state representing the list of states passed }
  function GetDFAState( oStates: TList): TniRegularExpressionState;

  {: Get a fingerprint number to use for this set of states }
  function CalculateDFAFingerprint( oStates: TList): integer;

  // Properties

  property Expression: string read FsExpression;

  // State Properties

  {: Count of states in this Regular expression }
  property StateCount: integer read GetStateCount;

  {: Access to states in this regular expression }
  property States[ iIndex: integer]: TniRegularExpressionState read GetStateByIndex;

  // Match Properties

  {: Count of how many matches we found }
  property MatchCount: integer read GetMatchCount;

  {: Access to stored matches }
  property Matches[ iIndex: integer]: TniRegularExpressionMatch read GetMatchByIndex;

  {: The state from which matching should begin }
  property StartState: TniRegularExpressionState read FoStartState;

end;

// ===============================================================================================
// Method Type: TniRegularExprsesionMatchFoundEvent
// ================================================

{: Method type for callbacks from a Matcher with results
   @param iStart Start position of match found
   @param iLength Length of match found }
TniRegularExpressionMatchFoundEvent = procedure( const iStart: integer;
                                                 const sText: string) of object;

// ==============================================================================================
// Object: TniRegularExpressionMatcher
// ===================================

{: Execute the DFA contained by a TniRegularExpression object and check for a match to the
   RegularExpression encoded by the DFA. }

TniRegularExpressionMatcher = class(TObject)
private

  // Internal Variables

  FoExpression: TniRegularExpression;

  FabFirstSet:  array[char] of boolean;
  FxCallback:   TniRegularExpressionMatchFoundEvent;

  FiMatchStart:  integer;
  FiMatchLength: integer;

  // Properties

  FeStatus: TniRegularExpressionMatchResult;
  FiStart:  integer;
  FiFinish: integer;
  FxFlags:  TniRegularExpressionMatchFlags;

  // Internal Methods

  function MatchExpression( const sString: string; iStart: integer): boolean;

  procedure MatchFound( const iStart: integer; const sText: string;
                        var bContinue: boolean);

public

  // Standard Methods

  constructor Create( oOwner: TniRegularExpression;
                      xFlags: TniRegularExpressionMatchFlags); reintroduce;
  destructor Destroy; override;

  // TniRegularExpression Methods

  {: Check for a match in a String at any position and return results
     @param sString String to match
     @param xNotify Method to call to indicate results
     @returns true if at least one match was found, false if not }
  procedure FindMatches( const sString: string;
                         xNotify: TniRegularExpressionMatchFoundEvent); overload;

  {: Check for a match in sString starting at position iStart.
     @param sString String to match
     @param iStart Position at which match must start
     @param iFinish Position at which last match finished
     @param xNotify Method to call to indicate results
     @returns true if at least one match was found, false if not }
  procedure FindMatches( const sString: string; iStart: integer;
                         xNotify: TniRegularExpressionMatchFoundEvent); overload;

  // Properties

  property Status: TniRegularExpressionMatchResult read FeStatus;
  property Start:  integer                         read FiStart;
  property Finish: integer                         read FiFinish;

  property Flags:  TniRegularExpressionMatchFlags  read FxFlags write FxFlags;

end;

// ==============================================================================================
// Object: TniRegularExpressionMatch
// =================================

{: Record the details of a match }

TniRegularExpressionMatch = class(TObject)
private

  // Properties

  FiStart:  integer;
  FiLength: integer;
  FsText:   string;

public

  // Standard Methods

  {: Create an instance recording a match
     @param iStart Start of Match
     @param iLength Length of Match }
  constructor Create( iStart: integer; sText: string);

  // Properties

  {: Start of match }
  property Start: integer read FiStart;

  {: Length of Match }
  property Length: integer read FiLength;

  {: Text of match }
  property Text: string read FsText;
end;

// ==============================================================================================
// Object: TniRegularExpressionState
// =================================

{: Encapsulation of a single state in the NFA or DFA used to parse regular expressions }
TniRegularExpressionState = class(TObject)
private

  // Internal Variables

  FoTransitions:        TObjectList;          // List of transitions out of this state
  FbFindingTransitions: boolean;

  FoPriorStates:        TObjectList;          // List of states with transitions TO this state

  {: Array of flags indicating what characters can start this state }
  FabFirstSet:          array[char] of boolean;

  FaoSuccessor: array[char] of TniRegularExpressionState;  // Cache of next states

  FoExpression:         TObject;

  FoStates:             TObjectList;          // List of NFA states contained by this DFA state

  // Properties

  FeStateType:   TniRegularExpressionStateType;
  FoGroupStart:  TniRegularExpressionState;
  FoGroupFinish: TniRegularExpressionState;
  FiStateNumber: integer;
  FbAccept:      boolean;
  FbModified:    boolean;
  FbReachable:   boolean;
  FbMarked:      boolean;
  FiFingerPrint: integer;

protected

  // Property Methods

  procedure SetGroupStart( oGroupStart: TniRegularExpressionState);
  procedure SetGroupFinish( oGroupFinish: TniRegularExpressionState);

  function GetPriorState( iIndex: integer): TniRegularExpressionState;
  function GetPriorStateCount: integer;

  function GetTransitionCount: integer;
  function GetTransitionByIndex( iIndex: integer): TniRegularExpressionTransition;

  function GetStateCount: integer;

  // Internal Methods

  procedure ConstructTransition( xSet: TCharSet);

public

  // Standard Methods

  constructor Create( oExpression: TniRegularExpression;
                      eType: TniRegularExpressionStateType = stNormal); reintroduce;
  destructor Destroy; override;

  // Transition Methods

  {: Add a transition to the passed state from this state.
     @param oState Destination state of transition
     @param xCharacters Set of characters on which to create the transition }
  procedure AddTransitionTo( oState: TniRegularExpressionState; xCharacters: TCharset);

  {: Add a lambda transition to the given state.
     A lambda transition is one which does not require any matching input characters
     @param oState Destination state of the transition }
  procedure AddLambdaTransitionTo( oState: TniRegularExpressionState);

  {: Remove transition to the passed state from this state on these characters.
     If there are no other characters left, the old transition will be removed.
     @param oState Destination state
     @param xCharacters Characters to remove from the transition }
  procedure RemoveTransitionTo( oState: TniRegularExpressionState; xCharacters: TCharset); overload;

  {: Remove transition to the passed state completely.
     @param oState Destination state }
  procedure RemoveTransitionTo( oState: TniRegularExpressionState); overload;


  {: Get all the transitions we can make on this character.
     If this state is the start of any lambda transitions, we implicitly follow them to find
     any additional destinations which are possible for this character. oTransitionList is
     <b>not</b> cleared prior to adding our transitions.
     @param cChar Character of input to recognise
     @param oTransitionList List to receive possible transitions }
  procedure GetTransitionsOn( cChar: char; oStateList: TList);

  {: Get the transition we make on this character, if there is only one. If there is no
     possible transition, or if there are several, return nil. }
  function GetOnlyTransitionOn( cChar: char): TniRegularExpressionState;

  {: Find a transition which can be made on the given characer.
     If no, or multiple, transition(s) can be made, returns nil }
  function FindImmediateTransitionOn( cChar: char): TniRegularExpressionState;

  // Optimization Methods

  {: Make all the exit transitions of this state Case insensitive }
  procedure MakeCaseInsensitive;

  {: Check to see if we should be an Accept state. If we have a lambda transition to an
     accept state, then we are also }
  procedure CheckIfAccept;

  {: Do some simple optimization by removing lambda rules from our state }
  procedure RemoveLambdaTransitions( var bChanged: boolean);

  {: Remove nondeterminism from this node by creating successor nodes with lambda transitions. }
  procedure MakeDeterministic( var bChanged: boolean);

  {: Mark all the states reachable from this one }
  procedure MarkReachable;

  {: Check to see if another state is the same as us.
     This is defined as another state having an exactly identical set of exit transitions.
     @param oState The state to compare against }
  function EqualState( oState: TniRegularExpressionState): boolean;

  {: Check to see if this state contains a transition identical to this one.
     @param oTransition Transition to check for }
  function ContainsTransition( oTransition: TniRegularExpressionTransition): boolean;

  {: Change all our entry transitions to point to another state }
  procedure ChangeEntryTransitions( oNewState: TniRegularExpressionState);

  {: Redirect our transition to oOldState to move to oNewState instead }
  procedure RedirectTransition( oOldState: TniRegularExpressionState;
                                oNewState: TniRegularExpressionState);

  {: Calculate our set of transition characters }
  procedure CalculateFirstSet;

  {: Indicate whether this is a DFA or NFA state }
  function IsDFAState: boolean;

  // Operation Methods

  {: Return the successor to the given state }
  function GetSuccessor( cChar: char): TniRegularExpressionState;

  {: Can the given character cause a transition from this state?
     @param cChar Character to test
     @returns True if there is an exit transition for that character }
  function CanStart( cChar: char): boolean;

  // Description Methods

  function Name: string;
  procedure DumpDescription( oStrings: TStrings);

  // DFA Production Methods

  procedure AddState( oState: TniRegularExpressionState);
  procedure Closure;

  function ContainsState( oState: TniRegularExpressionState): boolean;

  // Properties

  property StateType: TniRegularExpressionStateType read FeStateType;

  property GroupStart: TniRegularExpressionState  read FoGroupStart write SetGroupStart;
  property GroupFinish: TniRegularExpressionState read FoGroupFinish write SetGroupFinish;

  property StateNumber: integer read FiStateNumber;

  property PriorStateCount: integer read GetPriorStateCount;
  property PriorStates[iIndex: integer]: TniRegularExpressionState read GetPriorState;

  {: Does reaching this state indicate acceptance of the RE? }
  property Accept: boolean read FbAccept write FbAccept;

  {: Indicates whether this state has been modified }
  property Modified: boolean read FbModified write FbModified;

  {: Can this state be reached from the start state }
  property Reachable: boolean read FbReachable write FbReachable;

  {: Count of Exit transitions }
  property TransitionCount: integer read GetTransitionCount;

  {: Our Exit Transitions }
  property Transitions[iIndex: integer]: TniRegularExpressionTransition read GetTransitionByIndex;

  {: Marking flag used by Matchers }
  property Marked: boolean read FbMarked write FbMarked;

  {: Fingerprint used to find states rapidly when converting to DFA }
  property FingerPrint: integer read FiFingerPrint write FiFingerPrint;

  {: Return count of states contained in this state. This is used when constructing the DFA }
  property StateCount: integer read GetStateCount;

end;

// ==============================================================================================
// Object: TniRegularExpressionTransition
// ======================================

TniRegularExpressionTransition = class(TObject)
private

  // Internal Variables

  FoSource:      TniRegularExpressionState;
  FoDestination: TniRegularExpressionState;
  FxCharSet:     TCharSet;
  FbLambda:      boolean;

public

  // Standard Methods

  {: Create the transition.
     @param oSource The start state (and owner) of the transition
     @param oDestination The finish state of the transition
     @param xCharacters The characters on which to take this transition
     @param bLambda Is this transition also a lambda transition? }
  constructor Create( oSource:      TniRegularExpressionState;
                      oDestination: TniRegularExpressionState;
                      xCharacters:  TCharSet;
                      bLambda:      boolean); reintroduce;
  destructor Destroy; override;

  // Transition modification Methods

  {: Add additional characters to this transition }
  procedure AddCharacters( xCharacters: TCharSet);

  // Description Methods

  function Description: string;

  // Properties

  property Source:      TniRegularExpressionState read FoSource;
  property Destination: TniRegularExpressionState read FoDestination;
  property Characters:  TCharSet                  read FxCharSet write FxCharSet;
  property Lambda:      boolean                   read FbLambda write FbLambda;

end;

// ==============================================================================================
// Test Case: TniTestRegularExpression
// ===================================

TniTestRegularExpression = class( TniTestCase)
private

  // Internal Variables

  FsExpression: string;
  FsOptions:    string;

  // Internal Methods

  procedure IsRegularExpression( const sParam: string);

  procedure MatchesRegularExpression( const sParam: string);

protected

  // Overridden Methods

  {: Prepare the test to run.
     Create a component to test }
  procedure Setup; override;

  {: Run actual tests for this case.
     Do all of the actions required for the test. }
  procedure RunTest; override;

  {: Clean up after the test.
     Tidy up after the test is complete - usually to dispose of any resources allocated by the
     <see Method=Setup> method. Override this as required in any descendant. }
  procedure Cleanup; override;

end;

// ==============================================================================================

implementation

uses  TypInfo;

var
  GiStateCount: integer;

// ===============================================================================================
// Object: TniRegularExpression
// ============================

// Standard methods
// ----------------

constructor TniRegularExpression.Create( const sRule: string;
                                         xFlags: TniRegularExpressionMatchFlags);
begin
  inherited Create;

  FsExpression := sRule;
  
  FoStates := TObjectList.Create(false);
  FoMatches := TObjectList.Create(true);
  FxFlags := xFlags;

  ParseExpression( sRule);
  Optimize;
end;

destructor TniRegularExpression.Destroy;
var
  iScan: integer;
begin

  // Destroy our states
  for iScan := StateCount-1 downto 0 do begin
    States[iScan].Free;
  end;
  FoStates.Free;
            
  // Destroy Matches - stored matches will be destroyed for us
  FoMatches.Free;
  
  inherited Destroy;
end;

class function TniRegularExpression.CreateGlobber( sFilespec: string): TniRegularExpression;
var
  sExpression: string;
  sTerm:       string;
  cDelimiter:  char;
begin
  sExpression := '';

  while not StrEmpty( sFilespec) do begin
    sTerm := StrParse( sFilespec, '*?.', cDelimiter);
    sExpression := sExpression + sTerm;

    sTerm := '';
    case cDelimiter of
      '*' : sTerm := '.*';
      '?' : sTerm := '.';
      '.' : sTerm := '\.';
    end;
    sExpression := sExpression + sTerm;
  end;

  Result := TniRegularExpression.Create( sExpression, [mfStartOnly, mfFinishOnly]);
end;

// Operation Methods
// -----------------

function TniRegularExpression.Match( const sString: string): TniRegularExpressionMatchResult;
var
  oMatcher: TniRegularExpressionMatcher;
begin

  // Prepare for Matching

  ClearMatches;

  oMatcher := TniRegularExpressionMatcher.Create( self, FxFlags);
  try
    oMatcher.FindMatches( sString, AddMatch);
  finally
    oMatcher.Free;
  end;

  if FoMatches.Count>0 then
    Result := mrMatch
  else Result := mrFail;
end;

function TniRegularExpression.Match( const sString: string;
                                           iStart: integer): TniRegularExpressionMatchResult;
var
  oMatcher: TniRegularExpressionMatcher;
begin
  // Prepare for Matching

  ClearMatches;

  oMatcher := TniRegularExpressionMatcher.Create( self, FxFlags);
  try
    oMatcher.FindMatches( sString, iStart, AddMatch);
  finally
    oMatcher.Free;
  end;

  if FoMatches.Count>0 then
    Result := mrMatch
  else Result := mrFail;
end;


// Internal Methods
// ----------------

procedure TniRegularExpression.ParseExpression( sRule: string);
const
  ciStartStackSize = 10;
  csSyntaxError = 'Syntax Error: %s (Position %d)';
var
  iScan:         integer;
  cChar:         char;
  xFlags:        TniRegularExpressionParserFlags;
begin

  // Strip leading ^ or Trailing $ and set flags as required

  if not StrEmpty(sRule) and (sRule[1]='^') then begin
    Include( FxFlags, mfStartOnly);
    Delete( sRule, 1, 1);
  end;

  if not StrEmpty(sRule) and (sRule[Length(sRule)]='$') then begin
    Include( FxFlags, mfFinishOnly);
    Delete( sRule, Length(sRule), 1);
  end;

  sRule := PreprocessedExpression( sRule);

  if StrEmpty( sRule) then
    raise EniRegularExpressionError.Create( 'Empty regular expression not allowed');

  FiStack := -1;
  FoCurrentState := nil;
  iScan := 1;

  // Parse expression

  BeginGroup;
  FoCurrentState.GroupFinish.Accept := true;
  BeginGroup;

  while iScan<=Length( sRule) do begin
    xFlags := [];
    cChar := sRule[iScan];
    if cChar='\' then begin
      Include( xFlags, pfEscaped);
      Inc( iScan);
      if iScan>Length( sRule) then
        raise EniRegularExpressionError.Create('Empty Escape at end of string');
      cChar := sRule[iScan];
    end;
    case FeState of
      psStates:    ParseForState( cChar, xFlags);
      psCharRange: ParseForRange( cChar, xFlags);
    end;
    Inc( iScan);
  end;
  FinishGroup;
  FinishGroup;
end;

function TniRegularExpression.PreprocessedExpression( sRule: string): string;
{ We augment any occurrences of \d \a \w \t or \n which aren't enclosed in [ ] to include
  them. This means that only ParseForRange needs to know the expansions. When we extend these
  sets in future, maintenance will be easier. }
var
  bInRange: boolean;
  iScan:    integer;
  bEscaped: boolean;
  cChar:    char;
begin
  iScan := 1;
  bInRange := false;
  bEscaped := false;
  Result := sRule;

  while iScan<=Length( Result) do begin
    cChar := Result[iScan];
    if cChar='\' then begin
      bEscaped := true;
      Inc( iScan);
      continue;
    end;
    if cChar='[' then begin
      bInRange := true;
      Inc( iScan);
    end
    else if cChar=']' then
      bInRange := false
    else if not bInRange and bEscaped then begin
      if cChar in ['b', 'd', 'a', 'w', 't', 'n'] then begin
        Insert( ']', Result, iScan+1);
        Insert( '[', Result, iScan-1);
        Inc( iScan, 2);
      end;
    end;
    Inc( iScan);
    bEscaped := false;
  end;
end;

procedure TniRegularExpression.ParseForState( cCharacter: char;
                                              xFlags: TniRegularExpressionParserFlags);
var
  oNewState: TniRegularExpressionState;
begin
  if (pfEscaped in xFlags) then begin
    oNewState := FoCurrentState.FindImmediateTransitionOn( cCharacter);
    AddTransition( oNewState, [cCharacter]);
  end
  else
    case cCharacter of
      '(': begin
             // We use two layers to separate transitions within the group from those without
             BeginGroup;
             BeginGroup;
           end;
      ')': begin
             // We use two layers to separate transitions within the group from those without
             FinishGroup;
             FinishGroup;
           end;
      '|': begin
             FinishGroup;
             AddBranch;
             BeginGroup;
           end;
      '*': begin
             AddRepetition;
             AddOptional;
           end;
      '+': AddRepetition;
      '?': AddOptional;
      '[': StartRange;
      '.': AddTransition( nil, [#9,' '..#255]);
    else
      oNewState := FoCurrentState.FindImmediateTransitionOn( cCharacter);
      AddTransition( oNewState, [cCharacter]);
    end;
end;

procedure TniRegularExpression.ParseForRange( cCharacter: char;
                                              xFlags: TniRegularExpressionParserFlags);
var
  bEscaped: boolean;
  bDone:    boolean;
  oState:   TniRegularExpressionState;
begin
  bEscaped := pfEscaped in xFlags;

  if bEscaped then begin
    bDone := true;
    case cCharacter of
      'b': FxCharRange := FxCharRange + [' ', #9];
      'd': FxCharRange := FxCharRange + ['0'..'9'];
      'a': FxCharRange := FxCharRange + ['A'..'Z', 'a'..'z'];
      'w': FxCharRange := FxCharRange + ['0'..'9', 'A'..'Z', 'a'..'z'];
      't': FxCharRange := FxCharRange + [#9];
      'n': FxCharRange := FxCharRange + [#10,#13];
    else
      bDone := false;
    end
  end
  else begin
    bDone := true;
    case cCharacter of
      '^': // '^' Means invert iff present at start of range before other characters
           if FxCharRange=[] then 
             FbInvertedSet := true;
      ']': begin
             // ']' means end of range unless escaped or first character
             if (FxCharRange<>[]) or (FsPartialChars<>'') then begin
               if FsPartialChars<>'' then
                 FxCharRange := FxCharRange + [FsPartialChars[1]];
               if FbIsRange then
                 FxCharRange := FxCharRange+['-'];
               if FbInvertedSet then
                 FxCharRange := [' '..'~'] - FxCharRange;
               oState := NewState( stNormal);
               FoCurrentState.AddTransitionTo( oState, FxCharRange);
               FoCurrentState := oState;
               FeState := psStates;
             end
           end;
      '-': // '-' Means range unless first or last
           if (FsPartialChars<>'') then
             FbIsRange := true;
    else
      bDone := false;
    end;
  end;

  if not bDone then begin
    if FbIsRange then begin
      FxCharRange := FxCharRange + [FsPartialChars[1]..cCharacter];
      FsPartialChars := '';
      FbIsRange := false;
    end
    else begin
      if FsPartialChars<>'' then
        FxCharRange := FxCharRange + [FsPartialChars[1]];
      FsPartialChars := cCharacter;
    end;
  end;
end;

function TniRegularExpression.AddTransition( oNewState:   TniRegularExpressionState;
                                             xCharacters: TCharSet): TniRegularExpressionState;
begin
  if not Assigned( oNewState) then
    oNewState := NewState(stNormal);
  FoCurrentState.AddTransitionTo( oNewState, xCharacters);
  FoCurrentState := oNewState;
  Result := FoCurrentState;
end;

function TniRegularExpression.NewState( eType: TniRegularExpressionStateType): TniRegularExpressionState;
begin
  Result := TniRegularExpressionState.Create( self, eType);
  FoStates.Add( Result);
  if not Assigned( FoStartState) then
    FoStartState := Result;
end;

function TniRegularExpression.GetDFAState( oStates: TList): TniRegularExpressionState;
var
  iScan:        integer;
  iFingerPrint: integer;
  oState:       TniRegularExpressionState;
  iIndex:       integer;
begin
  Assert( Assigned( oStates), 'TniRegularExpression.GetDFAState: '
                              +'oStates not assigned (nil value)');
  Assert( oStates.Count>0, 'TniRegularExpression.GetDFAState: '
                           +'oStates is empty');

  oState := nil;
  iFingerPrint := CalculateDFAFingerprint( oStates);

  if oStates.Count=1 then begin
    oState := TObject(oStates[0]) as TniRegularExpressionState;
    if not oState.IsDFAState then
      oState := nil;
  end;

  if not Assigned( oState) then begin

    for iScan := 0 to StateCount-1 do begin
      if (States[iScan].FingerPrint = iFingerPrint)
         and (States[iScan].StateCount=oStates.Count) then begin
        oState := States[iScan];
        for iIndex := 0 to oStates.Count-1 do begin
          if not oState.ContainsState( TObject(oStates[iIndex])
                                      as TniRegularExpressionState) then begin
            oState := nil;
            break;
          end;
        end;
        if Assigned( oState) then
          break;
      end;
    end;
  end;

  if Assigned( oState) then
    Result := oState
  else begin
    Result := NewState( stNormal);
    for iIndex := 0 to oStates.Count-1 do
      Result.AddState( TObject(oStates[iIndex]) as TniRegularExpressionState);
    Result.FingerPrint := iFingerPrint;
    Result.Closure;
  end;

end;

function TniRegularExpression.CalculateDFAFingerprint( oStates: TList): integer;
const
  ciLimit = (13*17*19*23*29)-1;
var
  iScan: integer;
begin
  Result := 1;
  for iScan := 0 to oStates.Count-1 do
    Result := (Result * (TObject( oStates[iScan]) as TniRegularExpressionState).StateNumber)
              mod ciLimit;
end;

procedure TniRegularExpression.BeginGroup;
begin
  Inc( FiStack);
  if Length( FaoStartStack)<=FiStack then begin
    SetLength( FaoStartStack, FiStack+4);
    SetLength( FaoFinishStack, FiStack+4);
  end;

  FaoStartStack[FiStack] := NewState( stGroupStart);
  FaoFinishStack[FiStack] := NewState( stGroupFinish);
  FaoStartStack[FiStack].GroupFinish := FaoFinishStack[FiStack];

  if Assigned( FoCurrentState) then
    FoCurrentState.AddLambdaTransitionTo( FaoStartStack[FiStack]);
  FoCurrentState := FaoStartStack[FiStack];
end;

procedure TniRegularExpression.FinishGroup;
begin
  if FiStack<0 then
    raise EniRegularExpressionError.Create('Extra '')'' found');

  FoCurrentState.AddLambdaTransitionTo( FaoFinishStack[FiStack]);
  FoCurrentState := FaoFinishStack[FiStack];
  Dec( FiStack);
end;

procedure TniRegularExpression.AddBranch;
begin
  FoCurrentState.AddLambdaTransitionTo( FaoFinishStack[FiStack]);
  FoCurrentState := FaoStartStack[FiStack];
end;

procedure TniRegularExpression.AddRepetition;
var
  iIndex: integer;
begin
  if FoCurrentState.StateType=stGroupFinish then
    FoCurrentState.AddLambdaTransitionTo( FoCurrentState.GroupStart)
  else if FoCurrentState.StateType=stGroupStart then
    raise EniRegularExpressionError.Create( '''+'' and ''*'' cannot occur at the start of an expression or follow ''(''')
  else with FoCurrentState do
    for iIndex := 0 to PriorStateCount-1 do
      AddLambdaTransitionTo( PriorStates[iIndex]);
end;

procedure TniRegularExpression.AddOptional;
var
  iIndex: integer;
begin
  if FoCurrentState.StateType=stGroupFinish then
    FoCurrentState.GroupStart.AddLambdaTransitionTo( FoCurrentState)
  else if FoCurrentState.StateType=stGroupStart then
    raise EniRegularExpressionError.Create( '''?'' and ''*'' cannot follow ''(''')
  else with FoCurrentState do
    for iIndex := 0 to PriorStateCount-1 do
      PriorStates[iIndex].AddLambdaTransitionTo( FoCurrentState);
end;

procedure TniRegularExpression.StartRange;
begin
  FxCharRange := [];
  FbInvertedSet := false;
  FsPartialChars := '';
  FbIsRange := false;
  FeState := psCharRange;
end;

// Optimization Methods
// --------------------

procedure TniRegularExpression.Optimize;
begin
  if mfCaseInsensitive in FxFlags then
    MakeCaseInsensitive;
  Simplify;
  CalculateFirstSets;
  MakeDeterministic;
  CalculateFirstSets;
end;

procedure TniRegularExpression.MakeCaseInsensitive;
var
  iScan: integer;
begin
  for iScan := 0 to StateCount-1 do
    States[iScan].MakeCaseInsensitive;
end;

procedure TniRegularExpression.Simplify;
begin
  PropagateAcceptedFlags;
  CollapseIdenticalStates;
  RemoveLambdaTransitions;
  CollapseIdenticalStates;
  if Assigned( StartState) then
    RemoveRedundantStates( StartState)
  else RemoveRedundantStates( States[0]);
end;

procedure TniRegularExpression.MakeDeterministic;
begin
  FoStartState := NewState( stNormal);
  FoStartState.AddState( States[0]);
  FoStartState.Closure;
  CollapseIdenticalStates;
  RemoveRedundantStates( FoStartState);
end;

procedure TniRegularExpression.PropagateAcceptedFlags;
var
  iScan:    integer;
  oState:   TniRegularExpressionState;
  bDone:    boolean;
begin
  repeat
    bDone := true;
    for iScan := 0 to FoStates.Count-1 do begin
      oState := FoStates[iScan] as TniRegularExpressionState;
      if not oState.Accept then begin
        oState.CheckIfAccept;
        bDone := bDone and not oState.Accept;
      end;
    end;
  until bDone;
end;

procedure TniRegularExpression.RemoveRedundantStates( oStart: TniRegularExpressionState);
var
  iScan:    integer;
  oState:   TniRegularExpressionState;
begin
  // Remove any redundant states
  for iScan := 0 to StateCount-1 do
    States[iScan].Reachable := false;
  oStart.MarkReachable;

  for iScan := StateCount-1 downto 0 do begin
    oState := States[iScan];
    if not oState.Reachable then
      FoStates.Remove( oState);
  end;
end;

procedure TniRegularExpression.CollapseIdenticalStates;
var
  iScan:    integer;
  bDone:    boolean;
  iIndex:   integer;
begin
  repeat
    bDone := true;
    for iScan := 0 to StateCount-1 do begin
      for iIndex := iScan+1 to StateCount-1 do begin
        if States[iScan].EqualState( States[iIndex])
           and (States[iScan].TransitionCount>0) then begin
          // Two states are identical - replace entry transitions to State[iIndex] with
          // entry transitions to States[iScan]
          States[iIndex].ChangeEntryTransitions( States[iScan]);
          if StartState = States[iIndex] then
            FoStartState := States[iScan];
          bDone := false;
        end;
      end;
    end;
    if Assigned( StartState) then
      RemoveRedundantStates(StartState)
    else RemoveRedundantStates(States[0]);
  until bDone;
end;

procedure TniRegularExpression.RemoveLambdaTransitions;
var
  iScan:    integer;
  oState:   TniRegularExpressionState;
  bDone:    boolean;
  bChanged: boolean;
begin
  repeat
    bDone := true;
    for iScan := 0 to FoStates.Count-1 do begin
      oState := FoStates[iScan] as TniRegularExpressionState;
      bChanged := false;
      oState.RemoveLambdaTransitions( bChanged);
      bDone := bDone and not bChanged;
    end;
  until bDone;
end;

procedure TniRegularExpression.CalculateFirstSets;
var
  iScan: integer;
begin
  for iScan := 0 to StateCount-1 do
    States[iScan].CalculateFirstSet;
end;

// TniRegularExpresionMatcher Methods
// ----------------------------------

procedure TniRegularExpression.AddMatch( const iStart: integer; const sText: string);
var
  oMatch: TniRegularExpressionMatch;
begin
  oMatch := TniRegularExpressionMatch.Create( iStart, sText);
  FoMatches.Add( oMatch);
end;

procedure TniRegularExpression.ClearMatches;
begin
  FoMatches.Clear;
end;

// Property Methods
// ----------------

function TniRegularExpression.GetStateCount: integer;
begin
  Result := FoStates.Count;
end;

function TniRegularExpression.GetStateByIndex( iIndex: integer): TniRegularExpressionState;
begin
  Result := FoStates[iIndex] as TniRegularExpressionState;
end;

function TniRegularExpression.GetMatchCount: integer;
begin
  Result := FoMatches.Count;
end;

function TniRegularExpression.GetMatchByIndex( iIndex: integer): TniRegularExpressionMatch;
begin
  Result := FoMatches[iIndex] as TniRegularExpressionMatch;
end;

// Description Methods
// -------------------

procedure TniRegularExpression.DumpStateTable( oStrings: TStrings);
var
  iScan:  integer;
  oState: TniRegularExpressionState;
begin
  oStrings.Append('Start from '+ StartState.Name);
  oStrings.Append('');
  for iScan := 0 to FoStates.Count-1 do begin
    oState := FoStates[iScan] as TniRegularExpressionState;
    oState.DumpDescription( oStrings);
  end;
end;

// ===============================================================================================
// Object: TniRegularExpressionMatcher
// ===================================

constructor TniRegularExpressionMatcher.Create( oOwner: TniRegularExpression;
                                                xFlags: TniRegularExpressionMatchFlags);
var
  eScan:  char;
  oState: TniRegularExpressionState;
begin
  inherited Create;

  FoExpression := oOwner;
  FeStatus := mrNone;
  FxFlags := xFlags;

  oState := oOwner.StartState;
  for eScan := Low(char) to High(char) do
    FabFirstSet[eScan] := oState.CanStart( eScan);
end;

destructor TniRegularExpressionMatcher.Destroy;
begin

  inherited Destroy;
end;

procedure TniRegularExpressionMatcher.FindMatches( const sString: string;
                                                   xNotify: TniRegularExpressionMatchFoundEvent);
var
  iScan:  integer;
  bFound: boolean;
begin

  FxCallback := xNotify;
  try

    if mfStartOnly in FxFlags then
      MatchExpression( sString, 1)
    else begin
      iScan := 1;
      while iScan <= Length(sString) do begin
        if FabFirstSet[ sString[iScan]] then begin
          bFound := MatchExpression( sString, iScan);
          // Found matches - only look for more if mfMultipleMatches specified
          if bFound then begin
            if not (mfMultipleMatches in FxFlags) then
              break;
            // If not overlapping, move start on
            if not (mfOverlapMatches in FxFlags) then
              iScan :=FiMatchStart + FiMatchLength-1;
          end;
        end;
        Inc( iScan);
      end;
    end;

  finally
    FxCallback := nil;
  end;

end;

procedure TniRegularExpressionMatcher.FindMatches( const sString: string; iStart: integer;
                                                   xNotify: TniRegularExpressionMatchFoundEvent);
begin
  FxCallback := xNotify;
  try
    MatchExpression( sString, iStart);
  finally
    FxCallback := nil;
  end;
end;

function TniRegularExpressionMatcher.MatchExpression( const sString: string;
                                                      iStart: integer): boolean;
var
  oState:    TniRegularExpressionState;
  iScan:     integer;
  bContinue: boolean;
begin
  oState := FoExpression.StartState;
  iScan := iStart-1;
  bContinue := true;
  Result := false;

  repeat
    if oState.Accept then begin
      MatchFound( iStart, Copy( sString, iStart, iScan-iStart+1), bContinue);
      Result := true;
      if not bContinue then
        break;
    end;
    Inc( iScan);
    if iScan<=Length(sString) then
      oState := oState.GetSuccessor( sString[iScan]);
  until (iScan>Length(sString)) or not Assigned( oState);

  if Result and Assigned( FxCallback) then
    if (mfLongMatches in FxFlags) or not (mfMultipleMatches in FxFlags) then
      FxCallback( FiMatchStart, Copy( sString, FiMatchStart, FiMatchLength));
end;

procedure TniRegularExpressionMatcher.MatchFound( const iStart: integer;
                                                  const sText: string;
                                                  var bContinue: boolean);
begin
  FiMatchStart := iStart;
  FiMatchLength := Length( sText);

  if (mfMultipleMatches in FxFlags)
    and not (mfLongMatches in FxFlags)
    and Assigned( FxCallBack)
  then
    FxCallback( iStart, sText);

  if (mfShortMatches in FxFlags) and not (mfMultipleMatches in FxFlags) then
    bContinue := false;
end;

// ==============================================================================================
// Object: TniRegularExpressionMatch
// =================================

// Standard Methods
// ----------------

constructor TniRegularExpressionMatch.Create( iStart: integer; sText: string);
begin
  inherited Create;

  FiStart := iStart;
  FiLength := System.Length( sText);
  FsText := sText
end;

// ==============================================================================================
// Object: TniRegularExpressionState
// =================================

// Standard Methods
// ----------------

constructor TniRegularExpressionState.Create( oExpression: TniRegularExpression;
                                              eType: TniRegularExpressionStateType = stNormal);
var
  cScan: char;
begin
  inherited Create;

  FoExpression := oExpression;

  FoTransitions := TObjectList.Create(false);
  FbFindingTransitions := false;

  FoPriorStates := TObjectList.Create(false);

  FeStateType := eType;

  Inc( GiStateCount);
  FiStateNumber := GiStateCount;
  FbAccept := false;
  FbReachable := false;

  for cScan := Low(char) to High(char) do
    FaoSuccessor[cScan] := nil;

  FoStates := TObjectList.Create(false);
end;

destructor TniRegularExpressionState.Destroy;
var
  iScan: integer;
begin

  // Destroy our Transitions
  for iScan := TransitionCount-1 downto 0 do begin
    Transitions[iScan].Free;
    Assert( iScan=TransitionCount,
            'TniRegularExpressionState.Destroy: Transition not destroyed');
  end;
  FoTransitions.Free;

  // Remove transitions from prior states
  for iScan := PriorStateCount-1 downto 0 do begin
    PriorStates[iScan].RemoveTransitionTo( self);
    Assert( iScan=PriorStateCount,
            'TniRegularExpressionState.Destroy: Transition from prior state not removed');
  end;
  FoPriorStates.Free;

  //**
  // Will discard references to our contained states
  FoStates.Free;

  inherited Destroy;
end;

// Transition Methods
// ------------------

procedure TniRegularExpressionState.AddTransitionTo( oState: TniRegularExpressionState;
                                                     xCharacters: TCharset);
var
  oTransition: TniRegularExpressionTransition;
  iScan:       integer;
  bFound:       boolean;
begin
  bFound := false;
  for iScan := 0 to TransitionCount-1 do begin
    oTransition := Transitions[iScan];
    if oTransition.Destination = oState then begin
      if (xCharacters - oTransition.Characters)<>[] then begin
        // We have new information, so add it to the transition
        oTransition.AddCharacters( xCharacters);
        Modified := true;
      end;
      bFound := true;
    end;
  end;

  if not bFound then begin
    TniRegularExpressionTransition.Create( self, oState, xCharacters, false);
    Modified := true;
  end;
end;

procedure TniRegularExpressionState.AddLambdaTransitionTo( oState: TniRegularExpressionState);
var
  oTransition: TniRegularExpressionTransition;
  iScan:       integer;
  bFound:       boolean;
begin
  bFound := (oState=self);
  if not bFound then
    for iScan := 0 to TransitionCount-1 do begin
      oTransition := Transitions[iScan];
      if oTransition.Destination = oState then begin
        if not oTransition.Lambda then begin
          oTransition.Lambda := true;
          Modified := true;
        end;
        bFound := true;
      end;
    end;

  if not bFound then begin
    TniRegularExpressionTransition.Create( self, oState, [], true);
    Modified := true;
  end;
end;

procedure TniRegularExpressionState.RemoveTransitionTo( oState: TniRegularExpressionState;
                                                        xCharacters: TCharset);
var
  oTransition: TniRegularExpressionTransition;
  iScan:       integer;
begin
  for iScan := 0 to TransitionCount-1 do begin
    oTransition := Transitions[iScan];
    if oTransition.Destination = oState then begin
      // Found the transition - remove the characters required
      oTransition.Characters := oTransition.Characters - xCharacters;
      if oTransition.Characters=[] then begin
        // Nothing left of this transition
        oTransition.Free;
        Modified := true;
      end;
      break;
    end;
  end;
end;

procedure TniRegularExpressionState.RemoveTransitionTo( oState: TniRegularExpressionState);
var
  oTransition: TniRegularExpressionTransition;
  iScan:       integer;
begin
  for iScan := 0 to TransitionCount-1 do begin
    oTransition := Transitions[iScan];
    if oTransition.Destination = oState then begin
      RemoveTransitionTo( oState, oTransition.Characters);
      break;
    end;
  end;
end;

procedure TniRegularExpressionState.GetTransitionsOn( cChar: char; oStateList: TList);
var
  iScan: integer;
  oTransition: TniRegularExpressionTransition;
begin
  if not FbFindingTransitions then begin
    FbFindingTransitions := true;
    try
      for iScan := 0 to TransitionCount-1 do begin
        oTransition := Transitions[iScan];
        if cChar in oTransition.Characters then
          if oStateList.IndexOf( oTransition.Destination)=-1 then
            oStateList.Add( oTransition.Destination);
        if oTransition.Lambda then
          oTransition.Destination.GetTransitionsOn( cChar, oStateList);
      end;
    finally
      FbFindingTransitions := false;
    end;
  end;
end;

function TniRegularExpressionState.GetOnlyTransitionOn( cChar: char): TniRegularExpressionState;
var
  oList: TList;
begin
  oList := TList.Create;
  try
    GetTransitionsOn( cChar, oList);
    if oList.Count=1 then
      Result := TObject(oList.First) as TniRegularExpressionState
    else Result := nil;
  finally
    oList.Free;
  end;
end;

function TniRegularExpressionState.FindImmediateTransitionOn( cChar: char): TniRegularExpressionState;
var
  iScan: integer;
  oTransition: TniRegularExpressionTransition;
begin
  Result := nil;
  for iScan := 0 to TransitionCount-1 do begin
    oTransition := Transitions[iScan];
    if cChar in oTransition.Characters then
      if Result=nil then
        // On first match, remember it
        Result := oTransition.Destination
      else begin
        // On second match, return nil and break loop
        Result := nil;
        break;
      end;
  end;
end;

// Optimization Methods
// --------------------

procedure TniRegularExpressionState.MakeCaseInsensitive;
var
  iScan: integer;
  cScan: char;
begin
  for iScan := 0 to TransitionCount-1 do
    with Transitions[iScan] do begin
      for cScan := 'A' to 'Z' do
        if cScan in Characters then
          AddCharacters( [Char( Ord(cScan) + 32)]);
      for cScan := 'a' to 'z' do
        if cScan in Characters then
          AddCharacters( [Char( Ord(cScan) - 32)]);
    end;
end;

procedure TniRegularExpressionState.CheckIfAccept;
var
  iScan: integer;
begin
  for iScan := 0 to TransitionCount-1 do begin
    if Transitions[iScan].Lambda and Transitions[iScan].Destination.Accept then
      Accept := true;
  end;
end;

procedure TniRegularExpressionState.RemoveLambdaTransitions( var bChanged: boolean);
var
  iScan:           integer;
  oTransition:     TniRegularExpressionTransition;
  iIndex:          integer;
  oLambdaState:    TniRegularExpressionState;
  oExitTransition: TniRegularExpressionTransition;
begin
  CheckIfAccept;
  // First add all the transitions available by taking the lambda transitions from here
  repeat
    // Modified is automatically changed whenever an exit transition is changed or added
    Modified := false;
    iScan := 0;
    while iScan<=TransitionCount-1 do begin
      oTransition := Transitions[iScan];
      if oTransition.Lambda then begin
        // Replace this lambda transition with direct transitions to the states accessible
        // from this transitions target
        oLambdaState := oTransition.Destination;
        for iIndex := 0 to oLambdaState.TransitionCount-1 do begin
          oExitTransition := oLambdaState.Transitions[iIndex];
          if oExitTransition.Characters<>[] then
            AddTransitionTo( oExitTransition.Destination, oExitTransition.Characters);
          if oExitTransition.Lambda then
            AddLambdaTransitionTo( oExitTransition.Destination);
        end;
        Inc( iScan);
        bChanged := true;
      end
      else
        Inc( iScan);
    end;
  until not Modified;

  // Now remove the lambda transitions themselves

  for iScan := TransitionCount-1 downto 0 do begin
    oTransition := Transitions[iScan];
    if oTransition.Lambda then
      if oTransition.Characters<>[] then
        oTransition.Lambda := false
      else oTransition.Free;
  end;
end;

procedure TniRegularExpressionState.MakeDeterministic( var bChanged: boolean);
var
  iScan:   integer;
  iIndex:  integer;
  xCommon: TCharSet;
  oState:  TniRegularExpressionState;
  oScanTransition: TniRegularExpressionTransition;
  oIndexTransition: TniRegularExpressionTransition;
begin
  iScan := 0;
  // Scan through all but 1 transition - we compare all the others to iScan
  while iScan < TransitionCount-1 do begin
    oScanTransition := Transitions[iScan];
    for iIndex := TransitionCount-1 downto iScan+1 do begin
      oIndexTransition := Transitions[iIndex];
      xCommon := oScanTransition.Characters * oIndexTransition.Characters;
      if xCommon<>[] then begin
        // Found nondeterministic characters
        oState := (FoExpression as TniRegularExpression).NewState( stNormal);
        oState.AddLambdaTransitionTo( oScanTransition.Destination);
        RemoveTransitionTo( oScanTransition.Destination, xCommon);
        oState.AddLambdaTransitionTo( oIndexTransition.Destination);
        RemoveTransitionTo( oIndexTransition.Destination, xCommon);
        AddTransitionTo( oState, xCommon);
        oState.RemoveLambdaTransitions( bChanged);
      end;
    end;
    Inc( iScan);
  end;
end;

procedure TniRegularExpressionState.MarkReachable;
var
  iScan: integer;
begin
  if not FbReachable then begin
    FbReachable := true;
    for iScan := 0 to TransitionCount-1 do
      Transitions[iScan].Destination.MarkReachable;
  end;
end;

function TniRegularExpressionState.EqualState( oState: TniRegularExpressionState): boolean;
var
  iScan: integer;
begin
  Result := (oState.TransitionCount = TransitionCount)
            and (oState.Accept=Accept);
  if Result then
    for iScan := 0 to TransitionCount-1 do begin
      if not oState.ContainsTransition( Transitions[iScan]) then begin
        Result := false;
        break;
      end;
    end;
end;

function TniRegularExpressionState.ContainsTransition( oTransition: TniRegularExpressionTransition): boolean;
var
  iScan: integer;
  oOurTransition: TniRegularExpressionTransition;
begin
  if oTransition.Lambda then
    Result := false
  else begin
    oOurTransition := nil;
    for iScan := 0 to TransitionCount-1 do
      if Transitions[iScan].Destination = oTransition.Destination then begin
        oOurTransition := Transitions[iScan];
        break;
      end;

    if Assigned( oOurTransition) and not oOurTransition.Lambda then
      Result := oOurTransition.Characters = oTransition.Characters
    else
      Result := false;
  end;
end;

procedure TniRegularExpressionState.ChangeEntryTransitions( oNewState: TniRegularExpressionState);
var
  iScan: integer;
begin
  for iScan := FoPriorStates.Count-1 downto 0 do
    (FoPriorStates[iScan] as TniRegularExpressionState).RedirectTransition( self, oNewState);
end;

procedure TniRegularExpressionState.RedirectTransition( oOldState: TniRegularExpressionState;
                                                        oNewState: TniRegularExpressionState);
var
  iScan:       integer;
  oTransition: TniRegularExpressionTransition;
begin
  oTransition := nil;
  for iScan := 0 to TransitionCount-1 do
    if Transitions[iScan].Destination=oOldState then begin
      oTransition := Transitions[iScan];
      break;
    end;
  Assert( Assigned( oTransition), 'TniRegularExpressionState.RedirectTransition '
                                  +'Could not find required transition.');
  AddTransitionTo( oNewState, oTransition.Characters);
  if oTransition.Lambda then
    AddLambdaTransitionTo( oNewState);

  Assert( oOldState.FoPriorStates.IndexOf(self)<>-1, 'TniRegularExpressionState.RedirectTransition: '
                                                     +' No reference to self as prior state');
  oTransition.Free;
end;

procedure TniRegularExpressionState.CalculateFirstSet;
var
  iScan: integer;
  cScan: char;
  xFirstSet: set of char;
begin
  xFirstSet := [];
  for iScan := 0 to TransitionCount-1 do
    xFirstSet := xFirstSet + Transitions[iScan].Characters;

  for cScan := Low(char) to High(char) do
    FabFirstSet[cScan] := cScan in xFirstSet;
end;

function TniRegularExpressionState.IsDFAState: boolean;
begin
  Result := FoStates.Count>0;
end;

// Operation Methods
// -----------------

function TniRegularExpressionState.GetSuccessor( cChar: char): TniRegularExpressionState;
var
  iScan: integer;
begin
  if FabFirstSet[cChar] then begin
    if not Assigned( FaoSuccessor[cChar]) then begin
      for iScan := 0 to TransitionCount-1 do
        if cChar in Transitions[iScan].Characters then begin
          FaoSuccessor[cChar] := Transitions[iScan].Destination;
          break;
        end;
    end;
    Assert( Assigned( FaoSuccessor[cChar]), 'TniRegularExpressionState.GetSuccessor: '
                                            +'No state found for character in first set');
    Result := FaoSuccessor[cChar];
  end
  else
    Result := nil;
end;

function TniRegularExpressionState.CanStart( cChar: char): boolean;
begin
  Result := FabFirstSet[cChar];
end;

// Description Methods
// -------------------

function TniRegularExpressionState.Name: string;
begin
  if Accept then
    Result := Format('[[%d]]', [StateNumber])
  else
    Result := Format('(%d)', [StateNumber])
end;

procedure TniRegularExpressionState.DumpDescription( oStrings: TStrings);
var
  iScan: integer;
  oTransition: TniRegularExpressionTransition;
begin
  oStrings.Append( Name);
  for iScan := 0 to FoTransitions.Count-1 do begin
    oTransition :=  FoTransitions[iScan] as TniRegularExpressionTransition;
    oStrings.Append( oTransition.Description);
  end;
  oStrings.Append('');
end;

// DFA Production Methods
// ----------------------

procedure TniRegularExpressionState.AddState( oState: TniRegularExpressionState);
begin
  FoStates.Add( oState);
  if oState.Accept then
    Accept := true;
end;

procedure TniRegularExpressionState.Closure;
var
  axTransitionSets: array of TCharSet;
  iSetCount:        integer;

  procedure AddSet( xSet: TCharSet);
  begin
    if iSetCount>=Length( axTransitionSets) then
      SetLength( axTransitionSets, iSetCount + 25);
    axTransitionSets[iSetCount] := xSet;
    Inc( iSetCount);
  end;

var
  iState:            integer;
  oState:            TniRegularExpressionState;
  iTransition:       integer;
  oTransition:       TniRegularExpressionTransition;
  xSet:              TCharSet;
  iScan:             integer;
  iIndex:            integer;
begin
  iSetCount := 0;

  // First work out the disjoint sets of exit transitions

  for iState := 0 to FoStates.Count-1 do begin
    oState := FoStates[iState] as TniRegularExpressionState;
    for iTransition := 0 to oState.TransitionCount-1 do begin
      oTransition := oState.Transitions[iTransition];
      AddSet( oTransition.Characters);
    end;
  end;

  iScan := 0;
  while iScan < iSetCount do begin
    iIndex := iScan+1;
    while iIndex < iSetCount do begin
      xSet := axTransitionSets[iScan] * axTransitionSets[iIndex];
      if xSet<>[] then begin
        AddSet( xSet);
        axTransitionSets[iIndex] := axTransitionSets[iIndex] - xSet;
        axTransitionSets[iScan] := axTransitionSets[iScan] - xSet;
      end;
      Inc( iIndex);
    end;
    Inc( iScan);
  end;

  iScan := 0;
  iIndex := 0;
  while iScan < iSetCount do begin
    if axTransitionSets[iScan] <> [] then begin
      axTransitionSets[iIndex] := axTransitionSets[iScan];
      Inc( iIndex);
    end;
    Inc( iScan);
  end;
  iSetCount := iIndex;

  SetLength( axTransitionSets, iSetCount);

  // For each set we have, find the new state to move to and create the transition

  for iScan := 0 to iSetCount-1 do
    ConstructTransition( axTransitionSets[iScan]);
end;

function TniRegularExpressionState.ContainsState( oState: TniRegularExpressionState): boolean;
begin
  Result := FoStates.IndexOf( oState)<>-1; 
end;

// Property Methods
// ----------------

procedure TniRegularExpressionState.SetGroupStart( oGroupStart: TniRegularExpressionState);
begin
  Assert( StateType=stGroupFinish, 'TniRegularExpressionState.SetGroupStart: '
                                   +'Can only set GroupStart on Group Finish states');
  if FoGroupStart<>oGroupStart then begin
    FoGroupStart := oGroupStart;
    FoGroupStart.GroupFinish := self;
  end;
end;

procedure TniRegularExpressionState.SetGroupFinish( oGroupFinish: TniRegularExpressionState);
begin
  Assert( StateType=stGroupStart, 'TniRegularExpressionState.SetGroupFinish: '
                                  +'Can only set GroupFinish on Group Start states');
  if FoGroupFinish<>oGroupFinish then begin
    FoGroupFinish := oGroupFinish;
    FoGroupFinish.GroupStart := self;
  end;
end;

function TniRegularExpressionState.GetPriorState( iIndex: integer): TniRegularExpressionState;
begin
  Result := FoPriorStates[iIndex] as TniRegularExpressionState;
end;

function TniRegularExpressionState.GetPriorStateCount: integer;
begin
  Result := FoPriorStates.Count;
end;

function TniRegularExpressionState.GetTransitionCount: integer;
begin
  Result := FoTransitions.Count;
end;

function TniRegularExpressionState.GetTransitionByIndex( iIndex: integer): TniRegularExpressionTransition;
begin
  Result := FoTransitions[iIndex] as TniRegularExpressionTransition;
end;

function TniRegularExpressionState.GetStateCount: integer;
begin
  Result := FoStates.Count;
end;

// Internal Methods
// ----------------

procedure TniRegularExpressionState.ConstructTransition( xSet: TCharSet);
var
  cScan:   char;
  oStates: TList;
  oState:  TniRegularExpressionState;
  iScan:   integer;
begin
  oStates := TList.Create;
  try
    for cScan := Low(Char) to High(Char) do
      if cScan in xSet then begin
        for iScan := 0 to FoStates.Count-1 do
          (FoStates[iScan] as TniRegularExpressionState).GetTransitionsOn( cScan, oStates);
      end;
    oState := (FoExpression as TniRegularExpression).GetDFAState( oStates);
    AddTransitionTo( oState, xSet);
  finally
    oStates.Free;
  end;
end;

// ===============================================================================================
// Object: TniRegularExpressionTransition
// ======================================

// Standard Methods
// ----------------

constructor TniRegularExpressionTransition.Create( oSource:      TniRegularExpressionState;
                                                   oDestination: TniRegularExpressionState;
                                                   xCharacters:  TCharSet;
                                                   bLambda:      boolean);
begin
  inherited Create;

  FoSource := oSource;
  FoDestination := oDestination;
  FxCharSet := xCharacters;
  FbLambda := bLambda;

  oSource.FoTransitions.Add( self);
  Assert( oDestination.FoPriorStates.IndexOf( oSource)=-1,
          'TniRegularExpressionTransition.Create: Transition created for established link');
  oDestination.FoPriorStates.Add( oSource);
end;

destructor TniRegularExpressionTransition.Destroy;
begin
  Source.FoTransitions.Remove( self);
  Destination.FoPriorStates.Remove( Source);

  inherited Destroy;
end;

procedure TniRegularExpressionTransition.AddCharacters( xCharacters: TCharSet);
begin
  FxCharSet := FxCharSet + xCharacters;
end;

// Description Methods
// -------------------

function TniRegularExpressionTransition.Description: string;
var
  eScan: char;
  eLow:  char;
  bIn:   boolean;
  sTerm: string;
  bFirst: boolean;
begin
  Result := '    To '+Destination.Name+' on [';
  eLow := #0;

  bIn := false;
  bFirst := true;
  for eScan := Low(char) to High(char) do begin
    if bIn <> (eScan in Characters) then begin
      if bIn then begin
        if eLow=Pred(eScan) then
          sTerm := eLow
        else sTerm := eLow+'-'+Pred(eScan);
        if bFirst then begin
          Result := Result + sTerm;
          bFirst := false;
        end
        else Result := Result+','+sTerm;
      end
      else begin
        eLow := eScan;
      end;
      bIn := not bIn;
    end;
  end;

  if bIn then begin
    sTerm := eLow+'-'+#255;
    Result := Result+','+sTerm;
  end;

  Result := Result + ']';
  if Lambda then
    Result := Result + '/Lambda';
end;

// ==============================================================================================
// Test Case: TniTestRegularExpression
// ===================================

// Overridden Methods
// ------------------

procedure TniTestRegularExpression.Setup;
begin

end;

procedure TniTestRegularExpression.RunTest;
begin

  // IsRegularExpression

  TestSequence( [ 'a', 'abc', 'a|b', 'a|b|c', 'ab?',
                  'colou?r', 'a+', 'ab+', '(ab)+' ], IsRegularExpression);

  TestSequence( [ 'a++', 'b**' ], IsRegularExpression);

  // MatchesRegularExpression

  TestSequence( [ 'reset',
                  'Expression:abc',
                  'Options:mfMultipleMatches',
                  'abc:abc',
                  'abcabc:abc,abc',
                  '123abc123:abc',
                  'aababcabcdabcdeabcdef:abc,abc,abc,abc' ], MatchesRegularExpression);

  TestSequence( [ 'reset',
                  'Expression:\d+',
                  'Options:mfMultipleMatches,mfLongMatches',
                  '123:123',
                  'one 2 three 4 five 6 seven 8 nine:2,4,6,8',
                  '4 suits and 52 cards in a deck:4,52' ], MatchesRegularExpression);

  TestSequence( [ 'reset',
                  'Expression:.*\.html',
                  'Options:mfStartOnly,mfmfFinishOnly',
                  'test.html:test.html',
                  'something.html:something.html',
                  'test.jpg:',
                  'blast.htm:' ], MatchesRegularExpression);

end;

procedure TniTestRegularExpression.Cleanup;
begin

end;

procedure TniTestRegularExpression.IsRegularExpression( const sParam: string);
var
  oExpression: TniRegularExpression;
  bValid:      boolean;
begin
  try
    oExpression := TniRegularExpression.Create( sParam, []);
    oExpression.Free;
    bValid := true;
  except
    on E:EniRegularExpressionError do
      bValid := false;
  end;
  Verify( bValid, Format( '"%s" is Regular expression', [ sParam ]));
end;

procedure TniTestRegularExpression.MatchesRegularExpression( const sParam: string);
var
  sPrefix:     string;
  sContent:    string;
  oExpression: TniRegularExpression;
  xFlags:      TniRegularExpressionMatchFlags;
  eScan:       TniRegularExpressionMatchFlag;
  sFlag:       string;
  iScan:       integer;
  sMatch:      string;
  oPredicted:  TStrings;
  iCount:      integer;
begin
  if sParam='reset' then begin
    FsExpression := '';
    FsOptions := '';
  end
  else begin
    sContent := sParam;
    sPrefix := LowerCase( StrParse( sContent, ':'));
    if sPrefix='expression' then begin
      FsExpression := sContent;
    end
    else if sPrefix='options' then begin
      FsOptions := sContent;
    end
    else begin
      xFlags := [];
      for eScan := Low( TniRegularExpressionMatchFlag) to High( TniRegularExpressionMatchFlag) do begin
        sFlag := GetEnumName( TypeInfo( TniRegularExpressionMatchFlag), Ord( eScan));
        if Pos( sFlag, FsOptions)<>0 then
          Include( xFlags, eScan);
      end;

      oExpression := TniRegularExpression.Create( FsExpression, xFlags);
      try

        oExpression.Match( sPrefix);
        oPredicted := TStringList.Create;
        try
          oPredicted.CommaText := sContent;
          VerifyEquals( oExpression.MatchCount, oPredicted.Count,
                        Format( 'Expected %d matches, found %d',
                                [ oPredicted.Count, oExpression.MatchCount ]));

          iCount := oExpression.MatchCount;
          if oPredicted.Count<iCount then
            iCount := oPredicted.Count;

          for iScan := 0 to iCount-1 do begin
            sMatch := Copy( sPrefix, oExpression.Matches[iScan].Start, oExpression.Matches[iScan].Length);
            VerifyEquals( sMatch, oPredicted[iScan],
                          Format( 'Found match "%s" at %d (len=%d), expected "%s"',
                                  [ sMatch, oExpression.Matches[iScan].Start,
                                    oExpression.Matches[iScan].Length, oPredicted[iScan]]));
          end;

          for iScan := iCount to oExpression.MatchCount-1 do
            Fail( Format( 'Extra match "%s" at %d (len=%d)"',
                                  [ sMatch, oExpression.Matches[iScan].Start,
                                    oExpression.Matches[iScan].Length ]));

          for iScan := iCount to oPredicted.Count-1 do
            Fail( 'Failed to find predicted match '+oPredicted[iScan]);

        finally
          oPredicted.Free;
        end;

      finally
        oExpression.Free;
      end;
    end;
  end;
end;

// ==============================================================================================

end.
