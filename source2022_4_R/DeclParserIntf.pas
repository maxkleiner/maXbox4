// Productivity Experts by Chua Chee Wee, Singapore
//
// Chua Chee Wee,
// Singapore
// 19 April 2005.
//

// Use the Regular Expression parser engine encapsulated in
// the VBScript library, as opposed to using freeware engines elsewhere
// which, I would have to seek the author's permission for inclusion.

// Requires the following
// Microsoft Windows Script 5.6
// Win2K, XP      - http://www.microsoft.com/downloads/details.aspx?FamilyId=C717D943-7E4B-4622-86EB-95A22B832CAA&displaylang=en
// Win9x, Me, NT4 - http://www.microsoft.com/downloads/details.aspx?FamilyId=0A8A18F6-249C-4A72-BFCF-FC6AF26DC390&displaylang=en

unit DeclParserIntf;
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRegExp2 = interface;
  IMatch2 = interface;
  IMatchCollection2 = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RegExp = IRegExp2;
  Match = IMatch2;
  MatchCollection = IMatchCollection2;

// *********************************************************************//
// Interface: IRegExp2
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {3F4DACB0-160D-11D2-A8E9-00104B365C9F}
// *********************************************************************//
  IRegExp2 = interface(IDispatch)
    ['{3F4DACB0-160D-11D2-A8E9-00104B365C9F}']
    function Get_Pattern: WideString; safecall;
    procedure Set_Pattern(const pPattern: WideString); safecall;
    function Get_IgnoreCase: WordBool; safecall;
    procedure Set_IgnoreCase(pIgnoreCase: WordBool); safecall;
    function Get_Global: WordBool; safecall;
    procedure Set_Global(pGlobal: WordBool); safecall;
    function Get_Multiline: WordBool; safecall;
    procedure Set_Multiline(pMultiline: WordBool); safecall;
    function Execute(const sourceString: WideString): IDispatch; safecall;
    function Test(const sourceString: WideString): WordBool; safecall;
    function Replace(const sourceString: WideString; replaceVar: OleVariant): WideString; safecall;
    property Pattern: WideString read Get_Pattern write Set_Pattern;
    property IgnoreCase: WordBool read Get_IgnoreCase write Set_IgnoreCase;
    property Global: WordBool read Get_Global write Set_Global;
    property Multiline: WordBool read Get_Multiline write Set_Multiline;
  end;

// *********************************************************************//
// Interface: IMatch2
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {3F4DACB1-160D-11D2-A8E9-00104B365C9F}
// *********************************************************************//
  IMatch2 = interface(IDispatch)
    ['{3F4DACB1-160D-11D2-A8E9-00104B365C9F}']
    function Get_Value: WideString; safecall;
    function Get_FirstIndex: Integer; safecall;
    function Get_Length: Integer; safecall;
    function Get_SubMatches: IDispatch; safecall;
    property Value: WideString read Get_Value;
    property FirstIndex: Integer read Get_FirstIndex;
    property Length: Integer read Get_Length;
    property SubMatches: IDispatch read Get_SubMatches;
  end;

// *********************************************************************//
// Interface: IMatchCollection2
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {3F4DACB2-160D-11D2-A8E9-00104B365C9F}
// *********************************************************************//
  IMatchCollection2 = interface(IDispatch)
    ['{3F4DACB2-160D-11D2-A8E9-00104B365C9F}']
    function Get_Item(index: Integer): IDispatch; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[index: Integer]: IDispatch read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// Interface: ISubMatches
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {3F4DACB3-160D-11D2-A8E9-00104B365C9F}
// *********************************************************************//
  ISubMatches = interface(IDispatch)
    ['{3F4DACB3-160D-11D2-A8E9-00104B365C9F}']
    function Get_Item(index: Integer): OleVariant; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[index: Integer]: OleVariant read Get_Item; default;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// The Class CoRegExp provides a Create and CreateRemote method to          
// create instances of the default interface IRegExp2 exposed by              
// the CoClass RegExp. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRegExp = class
    class function Create: IRegExp2;
  end;

implementation

uses
  ComObj, ActiveX;

const
  CLASS_RegExp: TGUID = '{3F4DACA4-160D-11D2-A8E9-00104B365C9F}';

class function CoRegExp.Create: IRegExp2;
begin
  Result := CreateComObject(CLASS_RegExp) as IRegExp2;
end;

initialization
  CoInitialize(nil);
finalization
  CoUninitialize;
end.
