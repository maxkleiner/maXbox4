(***************************************************************************)
(*               COMPFILEIO.PAS, Component File Routines                   *)
(*                 Copyright © Erwin Haantjes © 2002-2003                  *)
(*            /\          -- Version 1.03 --                               *)
(*           [_] Copyright © JoyHouse Multimedia © 2002-2003               *)
(*-------------------------------------------------------------------------*)
(* Author        : Erwin Haantjes                                          *)
(* E-mail        : DelphiApplicationDiscussion@hotmail.com                 *)
(* Project       : Designing software                                      *)
(* Develop. Date : 31/10/2002                                              *)
(* Latest Update : 12/11/2002:                                             *)
(*                 - Default naming method not correcty implemented, fixed *)
(*                 - Header routines for resource files added. This also   *)
(*                   solved a major bug (trash) writing resource files.    *)
(*                 14/12/2002:                                             *)
(*                 - Three functions added:                                *)
(*                   o ReadComponentResourceHeader()                       *)
(*                   o ConvertComponentResourceToTextFile()                *)
(*                   o CheckComponentInResourceFile()                      *)
(*                 28/01/2003:                                             *)
(*                 - Added some comments or rewrite some comments and      *)
(*                   optimized the code a bit                              *)
(*                 - Increased unit version to 1.02                        *)
(*                 31/01/2003:                                             *)
(*                 - Bug fixed in GetComponentTree(), sometimes element    *)
(*                   nil in array.                                         *)
(*                 - Function added: DeleteComponentResourceFromFile() to  *)
(*                   make it possible to remove resources from a file.     *)
(*                 07/02/2003:                                             *)
(*                 - Bug fixed in WriteComponentsResourceFile(), when a    *)
(*                   form have no components an exception will be raised.  *)
(*                 04/03/2003:                                             *)
(*                 - Bug fixed in GetResHeaderInfo(), the returned index   *)
(*                   information trashed up the file and let the file grow *)
(*                   dramaticly.                                           *)
(*                 - Increased unit version to 1.03                        *)
(*                 11/03/2003:                                             *)
(*                 - Added some comments about event properties.           *)
(*                                                                         *)
(* Language      : Delphi 4? & 5 & 6?                                      *)
(*-------------------------------------------------------------------------*)
(* Characteristics:                                                        *)
(* This unit enables you to write and read (a) component(s) to/from a file.*)
(* The file formats can be a windows resource file, some kind of DFM file  *)
(* (object binary) or a DFM styled text file. To read or write a component,*)
(* it's using delphi's component streaming capabilities. Just select some  *)
(* components you want to store and everthing is going automaticly.        *)
(* It is easy to use and absolute the best way to store the settings of    *)
(* whole forms or just several components. You will never ever need any    *)
(* registery, ini-files or databases anymore to store settings of a        *)
(* program. Sounds great, isn't it?                                        *)
(*-------------------------------------------------------------------------*)
(* REMARKS ON COMPONENTS WITH DEFAULT VALUES                               *)
(* This issue is only remarkable for components that already exist (not    *)
(* created at run-time), for example on a form:                            *)
(* When a property has a default value specified with a default storage    *)
(* specifier, it will not be saved when the property has it's defaultvalue!*)
(* This is important to know because when a property have a value that is  *)
(* not the default value and you change it (at run-time) to the default    *)
(* value and save it, it will keep it's no default value when you restore  *)
(* property settings from a file. This is because the property is not      *)
(* specified in the file. It was changed to it's default and defaults are  *)
(* not saved to a file!                                                    *)
(* But, you can do something about this. Use only the defaults of          *)
(* the components in design-time or create new components without defaults.*)
(* To override an inherited default value without specifying a new         *)
(* one, use the nodefault directive. The default and nodefault directives  *)
(* are supported only for ordinal types and for set types, provided the    *)
(* upper and lower bounds of the set’s base type have ordinal values       *)
(* between 0 and 31; if such a property is declared without default or     *)
(* nodefault, it is treated as if nodefault were specified. For reals,     *)
(* pointers, and strings, there is an implicit default value of 0, nil,    *)
(* and '' (the empty string), respectively. When saving a component’s      *)
(* state, it checks the storage specifiers of the component’s published    *)
(* properties. If a property’s current value is different from its default *)
(* value (or if there is no default value) and the stored specifier is     *)
(* True, then the property’s value is saved. Otherwise, the property’s     *)
(* value is not saved.                                                     *)
(*-------------------------------------------------------------------------*)
(* REMARKS ON EVENT PROPERTIES                                             *)
(* Event properties are not streamed to a file. I do not know exactly why  *)
(* it not happen. If you have a suggestion or a solution to this, please,  *)
(* drop me an email.                                                       *)
(*-------------------------------------------------------------------------*)
(* REMARKS ON RESOURCE FILES                                               *)
(* - Do not edit or add bitmaps or other data to the resource files        *)
(*   created with use of this unit. There is a possibilty that you loose   *)
(*   the other resources (for example a bitmap) when saving new data to a  *)
(*   resource file. I have tested it and all resources stay intact except  *)
(*   when you delete all data resources with the                           *)
(*   DeleteComponentResourceFromFile() function.                           *)
(*-------------------------------------------------------------------------*)
(* IMPORTANT NOTES:                                                        *)
(* o The code in this unit is of a such high level, if not familiar with   *)
(*   pointers, streams, forms and component creation, registering classes  *)
(*   and so on, keep your hands away off this code and just use the        *)
(*   functions only (in that case, i recommeded the resource functions     *)
(*   only).                                                                *)
(* o Use the example program to learn and see how the functions works.     *)
(* o If you find a bug or you have some comments, please let me know.      *)
(*   Use the the email address mentioned above. Don't ask me something     *)
(*   like: how it works, how to use it, what is a component. Please don't  *)
(*   send me unintresting email, please, read the comments in the code     *)
(*   carefully.                                                            *)
(* o It is not allowed to say that you wrote this software, when you find  *)
(*   useful and want to use it, mention my name somewhere (not only in a   *)
(*   source file ofcourse ;-)).                                            *)
(* o If you change something in the code or make some additions, i like to *)
(*   have a copy of it. I'm also like to know why you changed it (if you   *)
(*   don't mind ;-)).                                                      *)
(*-------------------------------------------------------------------------*)
(* ACQUAINTANCE:                                                           *)
(* This code is being released as Freeware. This means that, although      *)
(* the code is copyrighted, it may distributed freely for non-             *)
(* commercial use. Use at your own risk. This software is provided 'as-is',*)
(* without any expressed or implied warranty. In no event will the author  *)
(* be held liable for any damages arising from the use of this software.   *)
(***************************************************************************)

// Compiler settings, '+' indicates that the option is turned on,
// '-' that it's turned off:
{$O+} // Optimizations	Enables compiler optimizations.
{$A+} // Aligns elements in structures to 32-bit boundaries.
{$W-} // Forces compiler to generate stack frames on all procedures and functions.
{$U-} // Generates code that detects a faulty floating-point division instruction.

{$R-} // Checks that array and string subscripts are within bounds.
{$I+} // Checks for I/O errors after every I/O call.
{$Q-} // Checks overflow for integer operations.

{$V+} // Sets up string parameter error checking. (If the Open parameters option is selected,
      // this option is not applicable.)
{$B-} // Evaluates every piece of an expression in Boolean terms, regardless of whether
      // the result of an operand evaluates as false. !NEVER TURN IT ON!
{$X+} // Enables you to define a function call as a procedure and to ignore the function result.
      // Also enables Pchar support.
{$T-} // Controls the type of pointer returned by the @ operator.
{$P+} // Enables open string parameters in procedure and function declarations.
      // Open parameters are generally safer, and more efficient.
{$H+} // Enables new garbage collected strings.  The string keyword corresponds to the new
      // AnsiString type with this option enabled. Otherwise the string keyword corresponds
      // to the ShortString type.
{$J+} // The compiler allows assignments to typed constants.

unit CompFileIo;

interface

uses
  Windows, Messages,
  SysUtils, Classes,
  Graphics, Controls,
  Forms, Dialogs,
  ExtCtrls, StdCtrls, TypInfo
  {$IFDEF CODCOMPSTREAMS}
     // A define just for personal usage:
     // You don't have this unit. This is a unit contains special streams
     // functions to code en decode the files into an unique format. It
     // is not available in the zip file on the internet.
   ,CodUtils
  {$ENDIF};

  {$IFDEF CODCOMPSTREAMS}
type
 TComponentStream = class( TMemoryStream )
  public
   procedure SaveToFile( FileName : string );
   procedure LoadFromFile( FileName : string );
  end;
  {$ELSE}
type
 TComponentStream = TMemoryStream;
  {$ENDIF}

 TPInt32              = ^LongInt;               // Pointer to a 32 bit integer
 TFormClass           = class of TCustomForm;   // RegisterClass type
 TComponentClass      = class of TComponent;    // RegisterClass type
 TComponentFileFormat = ( cffText, cffBinary ); // Supported file formats for streaming DFM/Text files
 TPComponent          = ^TComponent;            // Type to point to a component, to avoid the lost of
                                                // the address of a component when it is created by a
                                                // function.
 TComponentArray      = array of TComponent;
 TPComponentArray     = ^TComponentArray;

  // TResourceNaming: Components in resource files must have a name. There are 7 possibilities how to
  // to store the names and how to identify the resources. You can use the tag value of a component
  // to identify to use a specific resource.
 TResourceNaming      = ( rnClassNameTag,  // Stores it like: ClassName_Name_Tag e.q. TEdit_Edit1_0
                          rnClassName,     // Stores it like: ClassName_Name     e.q. TEdit_Edit1
                          rnClassTag,      // Stores it like: ClassName_Tag      e.q. TEdit_0        *default
                          rnNameTag,       // Stores it like: Name_Tag           e.q. Name_0
                          rnClass,         // Stores it like: ClassName          e.q. TEdit
                          rnName,          // Stores it like: Name               e.q. Edit1
                          rnTag );         // Stores it like: Tag                e.q. 0

{function CONSTS}
  // These functions will be used as constants. This is, in some way, a bit strange
  // but it works. The function returning a pointer to a classtype, and this classtype
  // is only known inside the implementation part of this unit. It is also not assignable
  // like a constant, this way is only to protect that somebody using the classtype
  // to creating objects of this type.
function VOID_COMP : Pointer;  // A voided or obsolete component
function VOID_FORM : Pointer;  // A voided or obsolete form

 // Form and component routines/tools
function CreateIoForm( AForm : TCustomForm; ClassType : TFormClass ) : TCustomForm;
function GetComponentTree( Component : TComponent; pComponents : TPComponentArray; bAddSelf : Boolean = TRUE ) : LongInt;

 // Misc routines
function pPosEx( SearchStr : PChar; Str : PChar; var Pos : LongInt ) : PChar;
function pGetTextBetween( pBuff : PChar; bSearchCode : string; eSearchCode : string; Container : TStrings ) : LongInt;

 // Conversion functions
function ComponentToString( Component: TComponent ): string;
function StringToComponent( Value: string; ComponentClass : TComponentClass ): TComponent;
function StringToObjectBinaryStream(Value: string; BinStream : TMemoryStream; ResName : string = '' ) : Boolean;
function ObjectBinaryStreamToString( BinStream : TMemoryStream; var sResult: string; bResource : Boolean = FALSE ) : Boolean;
function ObjectTextToBinaryStream( StrStream, BinStream : TComponentStream; ObjCount : LongInt ) : LongInt;
function ObjectBinaryStreamToObjectTextStream( BinStream : TMemoryStream; StrStream : TMemoryStream; bResource : Boolean = FALSE ) : Boolean;

 // Resource tools routines
function GetResHeaderInfo( Stream : TMemoryStream; sl : TStrings ) : Boolean;
function GetResourceName( Component : TComponent; NamingMethod : TResourceNaming ) : string;
function GetFormResourceStream( Form : TCustomForm; ResName : string; var ResourceStream : TMemoryStream ) : Boolean;


 // Text object and binary object routines:

 // These two functions are absolutly the easiest text/binary file functions available in this unit,
 // you mostly want to use these two functions:
function WriteComponentsToFile( FormsAndComponents : array of TComponent; FileName : string;
                                Format             : TComponentFileFormat = cffText;
                                StoreComponentNames : Boolean = FALSE ) : Boolean;
function ReadComponentsFromFile( FormsAndComponents : array of TComponent; FileName : string ) : Boolean; overload;


function ReadComponentsFromFile( FileName : string; pComponents : array of TPComponent;
                                 ComponentClasses : array of TComponentClass ) : Boolean; overload;

function ReadComponentTreeFromFile( FormOrComponent : TComponent; FileName : string ) : Boolean;

 // This function is absolutly the most complex function available in this unit:
function ReadObjectsFromFile( pObjects         : array of TPComponent;
                              FormClasses      : array of TFormClass;
                              ComponentClasses : array of TComponentClass;
                              FileName : string ) : Boolean;

function WriteComponentToFile( Component : TComponent; FileName : string;
                               Format             : TComponentFileFormat = cffText;
                               StoreComponentName : Boolean = FALSE ) : Boolean;
function WriteComponentTreeToFile( FormOrComponent : TComponent; FileName : string;
                                   Format    : TComponentFileFormat = cffText;
                                   StoreComponentName : Boolean = FALSE ) : Boolean;
function ReadComponentFromFile( pComponent : TPComponent;
                                ComponentClass : TComponentClass; FileName : string ) : Boolean; overload;
function ReadComponentFromFile( pForm : TPComponent; FormClass : TFormClass; FileName : string ) : Boolean; overload;
function ReadComponentFromFile( FormOrComponent : TComponent; FileName : string ) : Boolean; overload;
function ReadFormFromFile( pInstance : TPComponent; FormClass : TFormClass; FileName : string ) : Boolean;


 // Resource routines
function ReadComponentResourceFile( Instance : TObject; FileName: string ) : Boolean; overload;

function WriteComponentResourceFile( Instance : TObject; FileName: string;
                                     StoreFormAsVisible : Boolean = FALSE ) : Boolean; overload;

 // Functions for dummies:
 // These two functions are absolutly the easiest resource file functions available in this unit,
 // you mostly want to use these two functions:
function ReadComponentsResourceFile( Components : array of TComponent; FileName : string;
                                     NamingMethod : TResourceNaming = rnClassTag; bLoadTotalForm : Boolean = TRUE ) : Boolean;
function WriteComponentsResourceFile( Components : array of TComponent; FileName : string;
                                      NamingMethod : TResourceNaming = rnClassTag ) : Boolean;


function ReadComponentResourceHeader( sHeaderInfo : TStrings; pSize : TPInt32; FileName : string;
                                      NamingMethod : TResourceNaming = rnClassTag ) : Boolean;
function ConvertComponentResourceToTextFile( SourceFileName : string; TargetFileName : string; bStoreResNames : Boolean = FALSE ) : Boolean;
function CheckComponentInResourceFile( Component : TComponent; FileName : string;
                                       NamingMethod : TResourceNaming = rnClassTag ) : Boolean;

function DeleteComponentFromResourceFile( ResourceName : string; FileName : string ) : Boolean;  overload;
function DeleteComponentFromResourceFile( Component : TComponent; FileName : string; NamingMethod : TResourceNaming = rnClassTag ) : Boolean; overload;

function CreateFormFromResFile( AOwner : TComponent; NewClassType : TFormClass; FileName : string ) : Pointer;
function CreateComponentFromResFile( AOwner : TComponent; NewClassType : TComponentClass; FileName : string ) : Pointer;

implementation

const
  // A binary file starts with this file ID. This constant is to autodetect
  // if it is a text file or an object binary file.
 BIN_FILEFORMATID     = 'TPF0';

type
  // Some worthless classes, just used for identifing
 TVoidFormClass      = class( TCustomForm )
                         published
                          property Tag default 1;
                        end;

 TVoidComponentClass  = class( TComponent )
                         published
                          property Tag default 1;
                        end;

 {$IFDEF CODCOMPSTREAMS}
procedure TComponentStream.SaveToFile( FileName : string );
begin
 if( NOT CodStreamSaveToFile( FileName, Self ) ) then
  Exception.Create( 'Stream error: Cannot save to file:'+#13+'"'+FileName+'"' );
end;

procedure TComponentStream.LoadFromFile( FileName : string );
begin
 if( NOT CodStreamLoadFromFile( FileName, Self ) ) then
  Exception.Create( 'Stream error: Cannot read from file:'+#13+'"'+FileName+'"' );
end;
 {$ENDIF}

function VOID_FORM : Pointer;
 // Returns a voided or obsolete classtype for forms
begin
 Result:=Pointer( TVoidFormClass );
end;

function VOID_COMP : Pointer;
 // Returns a voided or obsolete classtype for components
begin
 Result:=Pointer( TVoidComponentClass );
end;

function pPosEx( SearchStr : PChar; Str : PChar; var Pos : LongInt ) : PChar;
 // function to search for a substring in a string and to return the position of the substring in the string.
 // If the substring cannot be found the function returns -1.                                       
begin
 Result:=StrPos( Str, SearchStr );
 if( Result <> nil ) then
   Pos:=LongInt( Result ) - LongInt( Str )
 else Pos:=-1;
end;

function pGetTextBetween( pBuff : PChar; bSearchCode : string; eSearchCode : string; Container : TStrings ) : LongInt;
 // This function parses text and find elements between a begin string and an end string. The elements that
 // can be found are stored in the stringlist container. The position of the begin string will be stored
 // as a pointer in the objects property of the stringlist. This is not really a pointer (!) and should never
 // be used as a pointer. The pointer reflects the position of the string found in pBuff.
var
 pResult : PChar;
 Pos     : LongInt;
 CurrPos : LongInt;
 Lb      : LongInt;
 Le      : LongInt;
 c       : Char;

begin
 Result:=0;
 Lb:=Length( bSearchCode );
 Le:=Length( eSearchCode );
 if( Lb = 0 ) or ( le = 0 ) or ( NOT Assigned( Container ) ) then
  Exit;

 Container.Clear;

 pResult:=pBuff;
 pResult:=pPosEx( PChar( bSearchCode ), pResult, Pos );

 while( pResult <> nil ) do
  begin
   CurrPos:=LongInt( pResult ) - LongInt( pBuff );

   if( CurrPos < 0 ) then
    CurrPos:=0;

   if( string( pResult ) > bSearchCode ) then
    pResult:=@pResult[ Lb ]
   else pResult:=nil;

   if( pPosEx( PChar( eSearchCode ), pResult, Pos ) <> nil ) then
    begin
     Inc( Result );
     Application.ProcessMessages;

     c:=pResult[ Pos ];
     pResult[ Pos ]:=#0;

      // Add the found string to the container and set the object pointer to the position
     Container.AddObject( string( pResult ), Pointer( CurrPos ));

     pResult[ Pos ]:=c;
     pResult:=@pResult[ Pos ];

     if( string( pResult ) > eSearchCode ) then
      pResult:=@pResult[ le ]
     else pResult:=nil;
    end
   else if( pResult <> nil ) then
         pResult:=@pResult[ 1 ];

   pResult:=pPosEx( PChar( bSearchCode ), pResult, Pos );
  end;
end;

function GetResHeaderInfo( Stream : TMemoryStream; sl : TStrings ) : Boolean;
 // This function returns a stringlist with names and pointers to the resource elements
 // in a resource file/stream. This function will be used to read and write resource
 // files. With use of this 'header', it enables both read an write function to locate,
 // replace and add resources easily.
var
 s : string;
 X : LongInt;
 i : LongInt;

begin
 Result:=( Assigned( Stream )) and ( Assigned( sl ));

 if( NOT Result ) then
  Exit;

 try
   // Make a copy of the stream's memory
  SetLength( s, Stream.Size );
  Move( Stream.Memory^, s[ 1 ], Stream.Size );

   // Because binary files can contain unwanted zero's (pchar null-termination),
   // it will be replaced by a space character
  for X:=1 to Stream.Size do
   if( s[ X ] = #0 ) then
    s[ X ]:=#32;

   // Get all names and pointers to the resources
   //                          Header start   Name end
  pGetTextBetween( PChar( s ), #255#10#32,      '0'#$10   , sl );
 except
  Result:=FALSE;
 end;

 if( Result ) then
  // Because the header is not really a header,
  // we must fix up this header and check for faulty indexes. This is because
  // we search with binary values and it possible that our primitive search
  // method has made a mistake. To avoid growing files and loss of resources
  // it is necessary to verify the names and indexes.
  for X:=0 to sl.Count - 1 do
    begin
     s:=sl[ X ];
     pPosEx( #255#10#32, PChar( s ), i );
     if( i > -1 ) then
      while( i > -1 ) do
       begin
        // Our parser has made a 'mistake', try to correct it.
        s:=s+#0#0#0#0;
        s:=string( PChar( PChar( @s[ i+3 ] )));
        sl.Objects[ X ]:=Pointer( LongInt( sl.Objects[ X ] ) + i  );

        pPosEx( PChar( s ), #255#10#32, i );

        if( i < 0 ) then
         sl[ X ]:=Trim( s );
       end
     else sl[ X ]:=Trim( sl[ X ] );
    end;
end;

function CreateIoForm( AForm : TCustomForm; ClassType : TFormClass ) : TCustomForm;
 // If you pass forms as parameters, remember that a form is not created as usual. Normally, when you
 // create a form, it will load it's resource from the excutable. Then, when you read the form from a file,
 // all components already exists and the delphi parser performs an exception. Create forms, that you want to
 // load from a file, with the CreateNew( ) constructor or use the this function.
 // NOTE: If the file could not be read, you cannot show the form! Destroy the form and re-create
 // the form like you normally do.

begin
 RegisterClass( TPersistentClass( ClassType )); // I think it's not necessary but you will never know.
                                                // Anyway, it is not bad for your health ;-)
 Result:=ClassType.CreateNew( Application );
end;

function GetComponentTree( Component : TComponent; pComponents : TPComponentArray; bAddSelf : Boolean = TRUE ) : LongInt;
 // Function to get a complete tree of components inside a component
var
 c : LongInt;
 x : LongInt;

begin
 Result:=0;

 if( NOT Assigned( Component )) or ( NOT Assigned( pComponents )) then
  Exit;

 try
  Result:=Length( pComponents^ );
  SetLength( pComponents^, Result+Component.ComponentCount+Byte( bAddSelf )-Byte( Result > 0 ));

  if( bAddSelf ) then
   begin
    if( Result = 0 ) then
     begin
      pComponents^[ Result ]:=Component;
      Inc( Result );
     end
    else begin
          pComponents^[ Result-1 ]:=Component;
          //Inc( Result );
         end; 
   end;
   
   // Get all ellements
  for X:=0 to Component.ComponentCount-1 do
   begin
    if( Component.Components[ X ].ComponentCount > 0 ) then
     begin
       // It is a component with inside more components,
       // find out who they are.... (NOTE: This is a recursive call)
      c:=GetComponentTree( Component.Components[ X ], pComponents );
      Inc( Result, c );
     end
    else pComponents^[ Result+X ]:=Component.Components[ X ];
   end;
 except
  Result:=0;
  Exit;
 end;

 Result:=Result+X;
end;

function ComponentToString( Component: TComponent ): string;
 // The example of Delphi Help
var
  BinStream:TComponentStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TComponentStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;
  finally
    BinStream.Free
  end;
end;

function StringToComponent(Value: string; ComponentClass : TComponentClass): TComponent;
 // The example of Delphi Help (lightly modified)
var
  StrStream : TStringStream;
  BinStream : TComponentStream;

begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TComponentStream.Create;
    try
      RegisterClass( ComponentClass );
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result:= BinStream.ReadComponent( nil );
    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

function StringToObjectBinaryStream(Value: string; BinStream : TMemoryStream; ResName : string = '' ) : Boolean;
 // Converts an objext text to an object binary stream
var
  StrStream : TStringStream;
  FixUpInfo : LongInt;

begin
 Result:=TRUE;
 StrStream:=nil;
  try
   StrStream := TStringStream.Create(Value);
   if( ResName > '' ) then
    BinStream.WriteResourceHeader( ResName, FixUpInfo );

   ObjectTextToBinary(StrStream, BinStream);

   if( ResName > '' ) then
    BinStream.FixupResourceHeader( FixUpInfo );
  except
   Result:=FALSE;
  end;

 if( Assigned( StrStream )) then
  FreeAndNil( StrStream );
end;

function ObjectBinaryStreamToString( BinStream : TMemoryStream; var sResult: string; bResource : Boolean = FALSE ) : Boolean;
 // Converts an object binary stream to an objext text
var
  StrStream : TStringStream;

begin
 sResult:='';
 Result:=TRUE;
 StrStream:=nil;
  try
   StrStream := TStringStream.Create('');

   if( bResource ) then
    BinStream.ReadResHeader;

   ObjectBinaryToText( BinStream, StrStream );
   sResult:=StrStream.DataString;
  except
   Result:=FALSE;
  end;

 if( Assigned( StrStream )) then
  FreeAndNil( StrStream );
end;

function ObjectBinaryStreamToObjectTextStream( BinStream : TMemoryStream; StrStream : TMemoryStream; bResource : Boolean = FALSE ) : Boolean;
 // Converts an object binary stream to an objext text stream
begin
 Result:=( Assigned( BinStream )) and ( Assigned( StrStream ));

 if( Result ) then
  try
   if( bResource ) then
    BinStream.ReadResHeader;

   ObjectBinaryToText( BinStream, StrStream );
  except
   Result:=FALSE;
  end;
end;


function WriteComponentsToFile( FormsAndComponents : array of TComponent; FileName : string;
                                Format             : TComponentFileFormat = cffText;
                                StoreComponentNames : Boolean = FALSE ) : Boolean;
 // This function enables you to write more components to one single file. It is using
 // delphi's component streaming capabilities. The file format default is Text format
 // but the binary format is recommended, because it save you at least twice the space.

 // NOTE: The binary format looks like a DFM file but isn't, the DFM file contains a
 //       header with the name of the form. Another reason that it is not a DFM file
 //       is because, with this method of storage, one single file can contain several
 //       forms or components.

 // All the components in the Components array MUST be initialized, if one of the
 // components is nil, the function fails.

 // IMPORTANT: Form typed classes have the first scope while reading a file, it is important that
 //            you save the forms (and components) in the same order as you want to read them,
 //            otherwise it is possible that you get rarily results (with forms of
 //            the same type or kind) or even exceptions. After reading all forms it start reading
 //            the components. If you don't want to save forms and components, just do something
 //            like this:
 //              WriteComponentsToFile( [[Form1, Form2, Memo1, Memo2], 'example1.bin' )   <- RIGHT!
 //                                 and absolutly NOT like this:
 //              WriteComponentsToFile( [[Form2, Memo1, Form1,  Memo2], 'example1.bin' )  <- WRONG!

var
  BinStream : TComponentStream; // Held the object binary version of the components
  StrStream : TStringStream; // Held the text version of a component
  X         : LongInt;       // Array counter
  BinPos    : LongInt;       // Last end position in the BinStream after writing a component
  s         : string;        // Temporarily var to backup the name of a component

begin
   // Initialize to nil because it is not garanteed
   // that objects are initialized to nil.
  BinStream:=nil;
  StrStream:=nil;

  try
   BinStream:=TComponentStream.Create;
  except
   Result:=FALSE;
   Exit;
  end;

  Result:=TRUE;
  X:=Low( FormsAndComponents );

   // Start scanning the array and write the components
   // to the BinStream
  while( Result ) and ( X <= High( FormsAndComponents )) do
   begin
    Result:=( Assigned( FormsAndComponents[ X ] ));

    if( Result ) then
     try
      BinPos:=BinStream.Position;

      if( NOT StoreComponentNames ) then
       begin
        // Since the name is not important to store, we remove it
        // here temporarily
        s:=FormsAndComponents[X].Name;
        FormsAndComponents[X].Name:='';
       end;

      try
       BinStream.WriteComponent( FormsAndComponents[X] );
      except
       Result:=FALSE;
      end;

      if( NOT StoreComponentNames ) then
       begin
        // Give it it's name back
        FormsAndComponents[ X ].Name:=s;
       end;

      if( Result ) and ( Format = cffText ) then
       begin
         // When the file format is text format,
         // we must translate the object binary
         // to text format like i do here.

        if( NOT Assigned( StrStream )) then
         StrStream:=TStringStream.Create( '' )
        else StrStream.Seek(0, soFromBeginning );

        BinStream.Seek(BinPos, soFromBeginning );
        ObjectBinaryToText(BinStream, StrStream );
        StrStream.Seek(0, soFromBeginning );
        BinStream.Seek(BinPos, soFromBeginning );

        BinStream.CopyFrom(StrStream, 0 );
        StrStream.Size:=0;
       end;
     except
      Result:=FALSE;
     end;

    Inc( X );
  end;

 if( Result ) then
  try
    // finally, save it to a file
   BinStream.SaveToFile( FileName );
  except
   Result:=FALSE;
  end;

  // To avoid memory leaks, always check the trash
 if( Assigned( StrStream )) then
  FreeAndNil( StrStream );
 if( Assigned( BinStream )) then
  FreeAndNil( BinStream );
end;

function WriteComponentToFile( Component : TComponent; FileName : string;
                               Format    : TComponentFileFormat = cffText;
                               StoreComponentName : Boolean = FALSE ) : Boolean;
begin
  // for more information of this function refer to the function above this function
 Result:=WriteComponentsToFile( [Component], FileName, Format, StoreComponentName );
end;


function WriteComponentTreeToFile( FormOrComponent : TComponent; FileName : string;
                                   Format    : TComponentFileFormat = cffText;
                                   StoreComponentName : Boolean = FALSE ) : Boolean;
  // With this function you can stream a component that have more components inside itself.
var
 Components : array of TComponent;

begin
 Result:=( Assigned( FormOrComponent ))
       and( GetComponentTree( FormOrComponent, @Components ) > 0 )
        and( WriteComponentsToFile( Components, FileName, Format, StoreComponentName ) );
end;

function ObjectTextToBinaryStream( StrStream, BinStream : TComponentStream; ObjCount : LongInt ) : LongInt;
 // This function translate an object text file into an object binary. In fact, this format is like
 // many object binaries onto eachother. It is not the same like converting the whole object text
 // stream into a single object binary stream. Calling directly ObjectTextToBinary converts the stream
 // very well, but 'forget' to write the object signature and results in an incomplete object binary format.
 // This function 'parses' the object text and split the object text into seperated strings. The parse
 // method is not that strong, like delphi does and in that case, never ever edit the object text formatting
 // of an object text file.
 // This is a function with much overhead, but for so far, it works fine.
var
 p : PChar;    // Pointer to StrStream.Memory
 i : LongInt;  // Position (size) that is found
 s : string;   // Conversion string

begin
 Result:=-1;

  // reset the bin stream
 BinStream.Size:=0;

  // If the object count is zero, that means that only one component is
  // inside the StrStream. If there are more inside the StrStream, it is
  // not a problem because we want to read only one component.
  // In that case, it can be directly converted by the ObjectTextToBinary method.
 if( ObjCount = 0 ) then
  begin
   Result:=0;
   ObjectTextToBinary( StrStream, BinStream );
   Exit;
  end;

  // Because we use a char pointer point to the memory of this stream, and let the
  // char pointer skipping through it's memory elements ( p[Foundpos+1] ), it is
  // good idea to increase the size of it's memory with one element to keep
  // this always a safe operation.
 StrStream.Size:=StrStream.Size+1;
 p:=PChar( StrStream.Memory );
  // Terminate it
 p[ StrStream.Size - 1 ]:=#0;

  // Try to find all objects in the stream
 while( Result < ObjCount ) do
  begin
    // This is our 'parser' that do all the 'hard' searching work.
    // What we do here is search for an 'enter' and the word 'end'
   pPosEx( #13#10'end', p, i );

    // If it cannot be found, exit the function
   if( i < 0 ) then
    Exit
   else inc( i, 4 );

   try
     // Set the size of the buffer to the found size and
     // move the found object text into this buffer.
    Setlength( s, i+1 );
    Move( p^, s[ 1 ], i+1 );

     // Try to convert it
    if( NOT StringToObjectBinaryStream( s, BinStream ) ) then
     Exit;

     // Replace to pchar pointer to a new location.
    p:=PChar( @p[ i+1 ] );
   except
    Result:=0;
    Exit;
   end;

   Inc( Result );
  end;
end;


function ReadObjectsFromFile( pObjects         : array of TPComponent;       // Contains ALL classes
                              FormClasses      : array of TFormClass;        // first priority, first scope
                              ComponentClasses : array of TComponentClass;   // second priority, second scope
                              FileName : string ) : Boolean;
 // This function enables you to read more than one form AND components out of one single file.
 // It is using delphi's component streaming capabilities. This function is slightly different when
 // you compare it to the write method, reading the files is much more complicated. Before a component
 // can be readed, at first it have to register the component by using the RegisterClass method. It is
 // required to register a class with the streaming system (the VCL wants it that way). Components used
 // by an application must be explicitly registered by calling RegisterClass if components are to be read.

 // It is not neccessary to create forms or components before you want to read the settings except when the
 // file could not be found or readed. It is up to you what you preffering, 1) first creating all components
 // and to be sure that they are initialized or 2) take the risk that the file could not be read and components
 // are not created. NOTE: It is important that you initialize all objects to nil when you want to create them
 // while reading the file, otherwise this function fails.

 // Form typed classes have the first scope, it is important that you have saved the forms (and components) in the
 // same order as you want to read them, otherwise it is possible that you get rarely results (with forms of
 // the same type or kind) or even exceptions. Try to use an array to be sure that components are saved and readed
 // in the right and same order.
 // After reading all forms it start reading the components.
 // If you don't want to read forms or components, just do something like this:
 //   ReadObjectsFromFile( [@Memo1, @Memo2], [VOID_FORM], [TMemo, TMemo], 'example1.bin' )
 //                                 or:
 //   ReadObjectsFromFile( [@Form1, @Form2], [TForm1, TForm2], [VOID_COMP], 'example2.bin' )

var
  FileStream  : TComponentStream;        // Held the file contents
  BinStream   : TComponentStream;        // Object binary stream
  s           : string;                  // Name holder, temp string
  bCreated    : Boolean;                 // Indicates that a component is created by this function
  Counts      : array[0..3] of LongInt;  // Array counts
  X           : LongInt;                 // counter for both arrays
  Y           : LongInt;                 // counter for second array only
  bDoForms    : Boolean;                 
  bDoComps    : Boolean;
  bBinFile    : Boolean;                 // Indicates if it is a Object Bin or a Object Text file
  pObject     : Pointer;                 // Pointer backup

begin
 FileStream:=nil;
 BinStream :=nil;

 Counts[ 0 ]:=High( pObjects );
 Counts[ 1 ]:=High( FormClasses );
 Counts[ 2 ]:=High( ComponentClasses );

  // At least one of both arrays first element MUST be different to those void classtypes
  // Because it are pointers, we must check for both classtypes to avoid rarely
  // exceptions
 bDoForms:=( FormClasses[ 0 ] <> VOID_FORM ) and ( FormClasses[ 0 ] <> VOID_COMP );
 bDoComps:=( ComponentClasses[ 0 ] <> VOID_COMP ) and ( ComponentClasses[ 0 ] <> VOID_FORM );

  // Check if there is any reason to continue
 Result:=( FileExists( FileName )) and(( bDoForms ) or ( bDoComps ));

 if( Result ) then
  try
   FileStream:=TComponentStream.Create;
  except
   Result:=FALSE;
  end;

 if( Result ) then
  try
   FileStream.LoadFromFile( FileName );
  except
   Result:=FALSE;
  end;

  // Initialize the counters
 X:=Low( pObjects );
 Y:=0;
// I:=0;

 if( Result ) then
  try
   SetLength( s, length( BIN_FILEFORMATID ));

   if( FileStream.Size > length( s )) then
    Move( FileStream.Memory^, s[ 1 ], Length( s ))
   else s:='';

   bBinFile:=( s = BIN_FILEFORMATID );

   if( NOT bBinFile ) then
    begin
      // Text format
     BinStream :=TComponentStream.Create;
     Result:=( ObjectTextToBinaryStream( FileStream, BinStream, Counts[ 0 ] ) = Counts[ 0 ] );
     FreeAndNil( FileStream );
    end
   else begin
          // Bin format already
         BinStream:=FileStream;
         FileStream:=nil;
        end;

   BinStream.Seek(0, soFromBeginning);
  except
   Result:=FALSE;
  end;

  // Try to read all forms and components
 while( Result ) and ( X <= Counts[ 0 ] ) do
  try
   bCreated:=FALSE;
   pObject:=pObjects[ X ]^;
   bCreated:=( NOT Assigned( pObject ));

   if( bDoForms ) and ( X <= Counts[ 1 ] ) then
    begin
     //Inc( I );
     RegisterClass( FormClasses[ X ] );

     if( bCreated ) then
      pObject:=FormClasses[ X ].CreateNew( Application )
     else // Save the name of the current form
          s:=TComponent( pObject ).Name;

     try
      {pObjects[ X ]^:=}BinStream.ReadComponent( pObject );

      if( bCreated ) then
       pObjects[ X ]^:=pObject
      else // Restore it's original name
           TComponent( pObject ).Name:=s;
     except
      Result:=FALSE;
      if( NOT bCreated ) then
       // Restore it's original name
       TComponent( pObjects[ X ]^ ).Name:=s;
     end;
    end
   else if( Y <= Counts[ 2 ] ) then
         begin
          RegisterClass( ComponentClasses[ Y ] );

          try
           if( bCreated ) then
             begin
              pObject:=BinStream.ReadComponent( pObject );
              pObjects[ X ]^:=pObject;
             end
           else begin
                  // Save the name of the current component
                 s:=TComponent( pObject ).Name;
                 pObject:=BinStream.ReadComponent( pObject );
                  // Restore it's original name
                 TComponent( pObject ).Name:=s;
                end;
          except
           Result:=FALSE;
           if( NOT bCreated ) then
            // Restore it's original name
            TComponent( pObjects[ X ]^ ).Name:=s;
          end;

          Inc( Y );
          //Inc( I );
         end
        else Result:=FALSE;

   if( NOT Result ) and ( bCreated ) then
    FreeAndNil( pObjects[ X ]^ );

   Inc( X );
  except
   Result:=FALSE;
  end;

  // Throw away the trash
 if( Assigned( FileStream )) then
  FreeAndNil( FileStream );
 if( Assigned( BinStream )) then
  FreeAndNil( BinStream );
end;

function ReadComponentsFromFile( FormsAndComponents : array of TComponent; FileName : string ) : Boolean;
 // With this function you can easily stream component settings from a file. It can be forms or components.
 // The forms and components MUST be already created. This method is easier for you because you don't have
 // mention the right classtype and there is no confussion possible which array parameters to use.
 // When you want to read forms and even components, think about the order, forms first and after the
 // forms the components. Something like this:
 //   ReadComponentsFromFile( Form1, Form2, Panel1, Edit1, 'example.bin' );
 // If you pass forms as parameters, remember that is not created as usual. Normally, when you
 // create a form, it will load it's resource from the excutable. Then, when you read the form from a file,
 // all components already exists and the delphi parser performs an exception. Create forms, that you want to
 // load from a file, with the CreateNew( ) constructor or use the CreateIoForm function available in
 // this unit. NOTE: If the file could not be read, you cannot show the form! Destroy the form and (re-)create
 // the form normally.
var
 pInstances : array of TPComponent;        // Pointers to components
 Comps      : array of TComponentClass;    // Component classes
 Forms      : array of TFormClass;         // Form classes
 CompCount  : LongInt;                     // Detected components
 FormCount  : LongInt;                     // Detected forms
 X          : LongInt;                     // Loop counter

begin
 Result:=FALSE;
 CompCount:=-1;
 FormCount:=-1;

 try
   // Set the length of the arrays to the length of available components
  Setlength( Comps, High( FormsAndComponents )+1);
  Setlength( Forms, High( FormsAndComponents )+1);
  Setlength( pInstances, High( FormsAndComponents )+1);

   // Try to create the arrays
  for X:=Low( FormsAndComponents ) to High( FormsAndComponents ) do
   begin
    Result:=( Assigned( FormsAndComponents[ X ] ))
            and( NOT ( FormsAndComponents[ X ] = VOID_FORM ))
             and( NOT ( FormsAndComponents[ X ] = VOID_COMP ));

    if( NOT Result ) then
     Exit;

    pInstances[ X ]:=@FormsAndComponents[ X ];

    if( FormsAndComponents[ X ] is TCustomForm ) then
     begin
      Inc( FormCount );
      Forms[ FormCount ]:=TFormClass( FormsAndComponents[ X ].ClassType );
     end
    else begin
          Inc( CompCount );
          Comps[ CompCount ]:=TComponentClass( FormsAndComponents[ X ].ClassType );
         end;
   end;
 except
  Result:=FALSE;
  Exit;
 end;

 if( Result ) then
  begin
    // Forms found?
   if( FormCount < 0 ) then
    begin
      // No, create obsolete form array
     Setlength( Forms, 1 );
     Forms[ 0 ]:=VOID_FORM;
    end
   else // yes, set form array length to the found elements
        Setlength( Forms, FormCount+1 );

   if( CompCount < 0 ) then
    begin
      // No, create obsolete component array
     Setlength( Comps, 1);
     Comps[ 0 ]:=VOID_COMP;
    end
   else // yes, set component array length to the found elements
        Setlength( Comps, CompCount+1);

    // Finally, try to read the components from the file
   Result:=ReadObjectsFromFile( pInstances, Forms, Comps, FileName );
  end;
end;

function ReadComponentsFromFile( FileName : string; pComponents : array of TPComponent;
                                 ComponentClasses : array of TComponentClass ) : Boolean;
begin
 Result:=ReadObjectsFromFile( pComponents, [VOID_FORM], ComponentClasses, FileName );
end;

function ReadComponentFromFile( pComponent : TPComponent; ComponentClass : TComponentClass; FileName : string ) : Boolean;
begin
 Result:=ReadObjectsFromFile( [pComponent], [VOID_FORM], [ComponentClass], FileName );
end;

function ReadComponentFromFile( pForm : TPComponent; FormClass : TFormClass; FileName : string ) : Boolean;
begin
 Result:=ReadObjectsFromFile( [pForm], [FormClass], [VOID_COMP], FileName );
end;

function ReadComponentFromFile( FormOrComponent : TComponent; FileName : string ) : Boolean;
begin
 Result:=( Assigned( FormOrComponent ));

 if( Result ) then
  begin
   if( FormOrComponent is TCustomForm ) then
    Result:=( ReadObjectsFromFile( [@FormOrComponent], [TFormClass(FormOrComponent.ClassType)], [VOID_COMP], FileName ))
   else Result:=( ReadObjectsFromFile( [@FormOrComponent], [VOID_FORM],
                                       [TComponentClass(FormOrComponent.ClassType)], FileName ));
  end;
end;

function ReadComponentTreeFromFile( FormOrComponent : TComponent; FileName : string ) : Boolean;
var
 Components : array of TComponent;

begin
 Result:=( Assigned( FormOrComponent ))
       and( GetComponentTree( FormOrComponent, @Components ) > 0 )
        and( ReadComponentsFromFile( Components, FileName ) );
end;

function ReadFormFromFile( pInstance : TPComponent; FormClass : TFormClass; FileName : string ) : Boolean;
begin
 Result:=ReadObjectsFromFile( pInstance, [FormClass], [VOID_COMP], FileName );
end;

function ReadComponentResourceFile( Instance : TObject; FileName: string ) : Boolean;
begin
 Result:=( Assigned( Instance )) and ( FileExists( FileName ));

 if( Result ) then
  try
   RegisterClass(TPersistentClass( TComponent( Instance ).ClassType ));
   ReadComponentResFile(FileName, TComponent( Instance ));
  except
   Result:=FALSE;
  end;
end;

function WriteComponentResourceFile( Instance : TObject; FileName: string;
                                     StoreFormAsVisible : Boolean = FALSE ) : Boolean;
 // This function enables you to write resource files. With this function
 // it is only possible to write one single component to a file. This can
 // be a form or a component.
var
 bChanged : Boolean;

begin
 bChanged:=FALSE;
 Result:=( Assigned( Instance ));

 if( Result ) then
  try
    // Check if the forms visibilty must be changed
   bChanged:=( NOT StoreFormAsVisible )
             and ( TComponent( Instance ) is TCustomForm ) and ( TCustomForm( Instance ).Visible );

   if( bChanged ) then
    TCustomForm( Instance ).Visible:=FALSE;

   WriteComponentResFile(FileName, TComponent( Instance ));
  except
   Result:=FALSE;
  end;

 if( bChanged ) then
  try
   TCustomForm( Instance ).Visible:=TRUE;
  except;
  end;
end;


function CreateFormFromResFile( AOwner : TComponent; NewClassType : TFormClass; FileName : string ) : Pointer;
begin
 Result:=nil;
 if( FileExists( FileName ) ) then
  begin
   try
    Result:=NewClassType.CreateNew( AOwner );
   except
    Result:=nil;
    Exit;
   end;

   if( NOT ReadComponentResourceFile( TObject( Result ), FileName ) ) then
    FreeAndNil( Result );
  end;
end;

function CreateComponentFromResFile( AOwner : TComponent; NewClassType : TComponentClass; FileName : string ) : Pointer;
begin
 Result:=nil;
 if( FileExists( FileName ) ) then
  begin
   try
    Result:=NewClassType.Create( AOwner );
   except
    Result:=nil;
    Exit;
   end;

   if( NOT ReadComponentResourceFile( TObject( Result ), FileName ) ) then
    FreeAndNil( Result );
  end;
end;

function GetResourceName( Component : TComponent; NamingMethod : TResourceNaming ) : string;
 // Function to assemble a resource identifier
begin
 Result:='';
 if( NOT Assigned( Component )) then
  Exit;
 if( NamingMethod in [rnClassNameTag, rnClassName, rnClassTag, rnClass] ) then
  Result:=Component.ClassName;

 if( NamingMethod in [rnClassNameTag, rnClassName, rnNameTag, rnName] ) then
  begin
   if( Result > '' ) then
    Result:=Result+'_';
   Result:=Result+Component.Name;
  end;

 if( NamingMethod in [rnClassNameTag, rnClassTag, rnNameTag, rnTag] ) then
  begin
   if( Result > '' ) then
    Result:=Result+'_';
   Result:=Result+IntToStr( Component.Tag );
  end;
end;

function GetFormResourceStream( Form : TCustomForm; ResName : string; var ResourceStream : TMemoryStream ) : Boolean;
 // Function to strip a form from it's components, an empty body with only the form properties but
 // without components and their properties. After this operation it will translate the object text
 // to a resource stream.
var
 s   : string;
 p   : PChar;
 pos : LongInt;

begin
 Result:=( Assigned( Form )) and ( ResName > '' );

 if( NOT Result ) then
  Exit;

  // Get the whole object text of the form
 s:=ComponentToString( Form )+#0;
 Result:=( Length( s ) > 8 );

 if( Result ) then
  begin
    // Try to find the first object identifier
   p:=PChar( PChar( @s[ 1 ] ));
   Result:=( pPosEx( 'object', p, pos ) <> nil ) and ( pos = 0 );
  end;

 if( Result ) then
  begin
   p:=PChar( PChar( @s[ 7 ] ));
    // Try to find the second object identifier
   Result:=( pPosEx( 'object', p, pos ) <> nil ) and ( pos >= 0 );

   if( NOT Result ) then
     // Nope, not found, try to find the object end
    Result:=( pPosEx( #13#10'end', p, pos ) <> nil ) and ( pos >= 0 );
  end;

 if( Result ) then
  begin
    // Ok, all done, strip the object text
   s[ Pos+6 ]:=#0;
   s:=string( PChar( s ))+'end'+#13#10;
  end;

 if( Result ) then
  begin
    // if the resourcestream is not created,
    // try to create it.
   if( NOT Assigned( ResourceStream )) then
    try
     ResourceStream:=TMemoryStream.Create;
    except
     ResourceStream:=nil;
     Result:=FALSE;
     Exit;
    end;

    // finally, translate the object text into a resource stream...
   Result:=StringToObjectBinaryStream( s, ResourceStream, ResName );
  end;
end;

function WriteComponentsResourceFile( Components : array of TComponent; FileName : string;
                                     NamingMethod : TResourceNaming = rnClassTag ) : Boolean;
 // This function is absolutly the most flexibel component streaming function. It doesn't matter
 // how to specify the order of the components you want save. Because it is possible to create
 // some 'header' information, both functions (read and write) can find existing resources.
 // And, it is not neccessary to save all components at the same time. If a component does not
 // exist in the stream, it will be added. If a component is available in the stream, it will be
 // replaced. This is a smart way to store your components. The resource file can be opened by
 // other software like Resource WorkShop and the Borland Image Editor.
 //
 // NOTES: - All components are stored in binairy file format and without names. No names will be stored
 //          to avoid name conflicts. A resource in a resource file NEEDS an identifier. The final name,
 //          given to the resource, depents on the specified naming method.
 //        - Forms are splitted up into several components if there are components on a form. This method
 //          gives more possibilities loading specific individual elements (components) from a form.

var
 TempStream    : TMemoryStream;      // Temp stream to insert components
 Stream        : TComponentStream;   // Stream with the component resources
 sHeaderInfo   : TStringList;        // Header info contains information about available resources


function Reload : Boolean;
 // function to load or to reload the resourcefile after
 // all form components are streamed to the file.
begin
  Result:=TRUE;
  if( FileExists( FileName ) ) then
   begin
    Stream.LoadFromFile( FileName );

     // Great stuff, get the resource header and position information
    Result:=GetResHeaderInfo( Stream, sHeaderInfo );

    if( Result ) and ( sHeaderInfo.Count = 0 ) then
      // Possible not a resource file
     Stream.Size:=0;
   end
  else begin
        Stream.Size:=0;
        sHeaderInfo.Clear;
       end;
end;

var
 Index         : LongInt;             // Index to existing resource
 X             : LongInt;             // Components array counter
 s             : string;              // Component resource name
 ByteCount     : LongInt;             // Byte count (size) of existing resource
 ByteDiff      : LongInt;             // Difference in size between existing resource and resource to insert
 Pos           : LongInt;             // Start position of existing resource
 Pos2          : LongInt;             // End position of existing resource
 p             : PChar;               // Pointer to stream's memory to move blocks
 Name          : string;              // Original name of the component
 Component     : TComponent;          // The current component
 bIsForm       : Boolean;             // Flag if it is a form
 FormComps     : array of TComponent; // When the component is a form, this will be used to get all components
                                      // available to the form

begin
  // Try to create buffers and try to load the resource file
 try
  Stream:=nil;
  sHeaderInfo:=nil;
  TempStream:=nil;

  Stream:=TComponentStream.Create;
  sHeaderInfo:=TStringList.Create;

  Result:=( Reload );
 except
  Result:=FALSE;
 end;

 if( Result ) then
  try
    // Try to store all ellements
  for X:=Low( Components ) to High( Components ) do
   if( Result ) then
    begin
      // Component MUST be intialized
     Result:=Assigned( Components[ X ] );
     if( NOT Result ) then
      Exit;

     Component:=Components[ X ];
     bIsForm:=( Component is TCustomForm );

      // Get component name and resource name
     Name:=Components[ X ].Name;
     s:=GetResourceName( Components[ X ], NamingMethod );

      // We don't want to store the components name to avoid name conflicts
     Components[ X ].Name:='';

      // Is it a form?
     if( bIsForm ) then
      begin
       if( Component.ComponentCount > 0 ) then
        begin
          // We don't need the stream for awhile, empty it to save memory
         Stream.Size:=0;

          // Looks a bit complicated, but is an if..then statement saver.
          // 1) Try to collect all components of the form
          // 2) Try to stream all components into the component resource file
          // 3) Try to reload the component resource file
          // 4) Try to get only the form property resource
          // 5) Check if the tempstream is really assigned (double check)
         Result:=( GetComponentTree( Component, @FormComps, FALSE ) > 0 )
                and( WriteComponentsResourceFile( FormComps, FileName, NamingMethod ))
                 and( Reload )
                  and( GetFormResourceStream( TCustomForm( Component ), s, TempStream ))
                   and( Assigned( TempStream ));

          // Remove the pointers to the form components
         SetLength( FormComps, 0 );
        end
       else // Bug fix 07/02/2003: When a form have no components inside it must be saved
            // like a normal component
             bIsForm:=FALSE;
      end;

     if( Result ) then
      begin
       // Check if resourcename already exists
       Index:=sHeaderInfo.IndexOf( s );

       // Resourcename found?
       if( Index >= 0 ) then
        begin
         // Yes, check the size and (over-) write the resource....

         // One component inside the stream or component located on end of stream?
        if( sHeaderInfo.Count = 1 ) or ( Index = sHeaderInfo.Count - 1 ) then
         begin
          // Yes on end of the stream, remove the component and write the new one
          Stream.Size:=LongInt( sHeaderInfo.Objects[ Index ] );
          Stream.Seek( Stream.Size, soFromBeginning );

           // If it is a form we expect that the tempstream contains the
           // form resource
          if( bIsForm ) then
           begin
             // Triple check ;-)
            Result:=( Assigned( TempStream ));

            if( Result ) then
             begin
               // Move the form resource stream into the component resource stream
              pos:=Stream.Size;
              Stream.Size:=Stream.Size+TempStream.Size;
              p:=PChar( Stream.Memory );
              Move( TempStream.Memory^, p[ Pos ], TempStream.Size );
              FreeAndNil( TempStream );
             end;
           end
          else // Not a form, write it normally to the component stream
               Stream.WriteComponentRes( s, Components[ X ] );
         end
        else begin
               // No, remove the component and insert a new one
              if( bIsForm ) then
                Result:=( Assigned( TempStream )); // Triple check ;-)

              if( Result ) and ( NOT Assigned( TempStream )) then
               begin
                 // Only create the tempstream if it is not a form
                TempStream:=TMemoryStream.Create;
                TempStream.WriteComponentRes( s,  Component );
                //TempStream.SaveToFile( Component.ClassName+IntToStr( X )+'.txt' );
                //TempStream.Seek( 0, soFromBeginning );
                //ObjectBinaryStreamToString( TempStream, sTemp, TRUE );
                //ShowMessage( sTemp );
                //ShowMessage( ComponentToString( Component ));
               end;

              if( Result ) then
               begin
                 // Get all positions and sizes of the existing component resource
                Pos:=LongInt( sHeaderInfo.Objects[ Index ] );
                Pos2:=LongInt( sHeaderInfo.Objects[ Index+1 ] );
                ByteCount:=Pos2 - Pos;
                ByteDiff :=ByteCount - TempStream.Size;

                 // Determine how to move new component resource into the resource stream...
                if( ByteDiff < 0 { New component has a bigger size?} ) then
                 begin
                  ByteDiff:=abs( ByteDiff );
                  Stream.Size:=Stream.Size + ByteDiff;
                  p:=PChar( Stream.Memory );
                  Move( p[ Pos2 ], p[ Pos2 + ByteDiff ], Stream.Size-Pos2-ByteDiff );
                 end
                else if( ByteDiff > 0 { New component has a less size?} ) then
                      begin
                       p:=PChar( Stream.Memory );
                       Move( p[ Pos2 ], p[ Pos2 - ByteDiff], Stream.Size-Pos2 );
                       Stream.Size:=Stream.Size - ByteDiff;
                      end
                    {else (size = equal)};

                 // Copy the new component resource
                 p:=PChar( Stream.Memory );
                 Move( TempStream.Memory^, p[ Pos ], TempStream.Size );
                 FreeAndNil( TempStream );
               end;
             end;
         end
        else begin
              // No, Resourcename does not exist, put it at the end of the file
               if( bIsForm ) then
                begin
                 Result:=( Assigned( TempStream )); // Triple check ;-)

                 if( Result ) then
                  begin
                   pos:=Stream.Size;
                   Stream.Size:=Stream.Size+TempStream.Size;
                   p:=PChar( Stream.Memory );
                   Move( TempStream.Memory^, p[ Pos ], TempStream.Size );
                   FreeAndNil( TempStream );
                  end;
                end
               else begin
                     Stream.Seek( Stream.Size, soFromBeginning );
                     Stream.WriteComponentRes( s, Component );
                    end;
             end;
      end;


      // Restore the components name
     if( Assigned( Components[ X ] )) then
      Components[ X ].Name:=Name;

     // Update Resource header info
     if( Result ) then
      Result:=GetResHeaderInfo( Stream, sHeaderInfo );
    end;
  except
   Result:=FALSE;
   try
     // Exception: Restore the components name
    Components[ X ].Name:=Name;
   except;
   end;
  end;

 if( Result ) then
  try
    // Finally, save it
   Stream.SaveToFile( FileName );
  except
   Result:=FALSE;
  end;

  // Clean up trash
 if( Assigned( TempStream )) then
  FreeAndNil( TempStream );
 if( Assigned( sHeaderInfo )) then
  FreeAndNil( sHeaderInfo );
 if( Assigned( Stream )) then
  FreeAndNil( Stream );
end;


function ReadComponentsResourceFile( Components : array of TComponent; FileName : string;
                                     NamingMethod : TResourceNaming = rnClassTag; bLoadTotalForm : Boolean = TRUE ) : Boolean;
 // This function is absolutly the most flexibel component streaming function. It doesn't matter
 // how to specify the order of the components you want save. Because it is possible to create
 // some 'header' information, both functions (read and write) can find existing resources.
 // And, it is not neccessary to load all components at the same time. If a component is
 // available in the stream, it will be loaded. But, if a component does not exist in the stream,
 // it will NOT be loaded (no exeption will be raised). This behaviour is like what Delphi does
 // when reading a dfm file, a component shows it's default when it is not loaded.

 // The resource file can also be opened by other software like Resource WorkShop and the
 // Borland Image Editor.

 // If you want to read a form from a resourcefile, you must create it normally and not with the
 // CreateNew() constructor. Because the form will splitted up into seperated component resources
 // so it is required that all components on the form are initialized, otherwise the components
 // cannot be loaded from the resource stream. When a form is created with the CreateNew() constructor
 // and you want to show it after this function, you will get an exception (component not found or
 // something like that). So, don't use the constructor CreateNew() with this function.

 // NOTES: - Forms are splitted up into several components if there are components on a form. Because of this
 //          you are able to load the form settings only by setting the parameter bLoadTotalForm to FALSE.
 //        - Be sure you using the same namingmethod as you did when saving components to a resource file.
 //          Otherwise the component resource cannot be found in the resource file, because there is no
 //          name that match to the component.

const
 Stream      : TComponentStream = nil; // Stream with the component resources
 sHeaderInfo : TStringList      = nil; // Header info contains information about available resources
 CallCount   : LongInt          = 0;   // Recursive callcount, when the callcount reach zero again,
                                       // it is allowed to remove the stream and headerinfo from memory.
                                       // This method is designed to reduce memory consumption and to
                                       // reduce disk I/O.
var
 X           : LongInt;                // Component array counter
 Index       : LongInt;                // Index of a component resource that already exist
 s           : string;                 // Resource name holder of the current component
 Component   : TComponent;             // The current component that is in progress
 Name        : string;                 // Component name holder
 FormComps   : array of TComponent;    // When the component is a form, this will be used to get all components
                                       // available to the form

begin
 Result:=( FileExists( FileName ));

 if( NOT Result ) then
  Exit;

  // Increase callcount
 Inc( CallCount );

 try
   // Only create and load the stream when not assigned (because it is a constant)
  if( NOT Assigned( Stream )) then
   begin
    Stream:=nil;
    Stream:=TComponentStream.Create;
    Stream.LoadFromFile( FileName );
   end;

   // Only create and load the header info when not assigned (because it is a constant)
  if( NOT Assigned( sHeaderInfo )) then
   begin
    sHeaderInfo:=nil;
    sHeaderInfo:=TStringList.Create;
    // Great stuff, get the resource header and position information
    Result:=GetResHeaderInfo( Stream, sHeaderInfo );
   end;

 except
  Result:=FALSE;
 end;

 try
   // Try to get all components
  for X:=Low( Components ) to High( Components ) do
  if( Result ) then
   begin
     // Object MUST exist
    Result:=Assigned( Components[ X ] );

    if( NOT Result ) then
     Exit;

    Component:=Components[ X ];

     // If it is a form, try to get all components available to the form
    if( bLoadTotalForm ) and ( Component is TCustomForm ) and ( Component.ComponentCount > 0 ) then
     begin
      Result:=( GetComponentTree( Component, @FormComps, FALSE ) > 0 )
                and( ReadComponentsResourceFile( FormComps, FileName, NamingMethod ));

       // Clear the component pointer array
      SetLength( FormComps, 0 );
     end;

    if( Result ) then
     begin
      Name:=Component.Name;
      s:=GetResourceName( Component, NamingMethod );

      Index:=sHeaderInfo.IndexOf( s );

      if( Index >= 0 ) then
       begin
        Stream.Seek( LongInt( sHeaderInfo.Objects[ Index ] ), soFromBeginning );

        RegisterClass( TPersistentClass( Component.ClassType ));

        Components[ X ]:=Stream.ReadComponentRes( Component );

        if( Components[ X ].Name <> Name ) then
         Components[ X ].Name:=Name;
       end;
     end;
   end;
 except
  Result:=FALSE;
  if( Components[ X ].Name <> Name ) then
   Components[ X ].Name:=Name;
 end;

  // Decrease the callcount and....
 Dec( CallCount );

  // If all recursive callcounts are ended, callcount becomes zero.
  // In this condition it is allowed to remove the trash
 if( CallCount <= 0 ) then
  begin
   CallCount:=0; // Just for ensurance

   // Clean up trash
   if( Assigned( sHeaderInfo )) then
    FreeAndNil( sHeaderInfo );
   if( Assigned( Stream )) then
    FreeAndNil( Stream );
  end;
end;

function ReadComponentResourceHeader( sHeaderInfo : TStrings; pSize : TPInt32; FileName : string;
                                       NamingMethod : TResourceNaming = rnClassTag ) : Boolean;
var
 Stream      : TComponentStream; // Stream with the component resources

begin
 Result:=( Assigned( sHeaderInfo )) and ( FileExists( FileName ));

 if( NOT Result ) then
  Exit;

 try
  Stream:=nil;
  Stream:=TComponentStream.Create;
  Stream.LoadFromFile( FileName );

  if( Assigned( pSize ) ) then
   pSize^:=Stream.Size;

  sHeaderInfo.Clear;
    // Great stuff, get the resource header and position information
  Result:=( GetResHeaderInfo( Stream, sHeaderInfo ) );
  //ShowMessage( sHeaderInfo.Text );
 except
  Result:=FALSE;
 end;

 // Clean up trash
 if( Assigned( Stream )) then
  FreeAndNil( Stream );
end;


function ConvertComponentResourceToTextFile( SourceFileName : string; TargetFileName : string; bStoreResNames : Boolean = FALSE ) : Boolean;
var
 Stream      : TComponentStream; // Stream with the component resources
 StrStream   : TMemoryStream;
 sHeaderInfo : TStringList;
 X           : LongInt;
 s           : string;

begin
 Result:=( FileExists( SourceFileName ));

 if( NOT Result ) then
  Exit;

 try
  Stream:=nil;
  StrStream:=nil;
  sHeaderInfo:=nil;
  Stream:=TComponentStream.Create;
  Stream.LoadFromFile( SourceFileName );
  Stream.Seek( 0, soFromBeginning );

  StrStream:=TMemoryStream.Create;
  sHeaderInfo:=TStringList.Create;
    // Great stuff, get the resource header and position information
  Result:=( GetResHeaderInfo( Stream, sHeaderInfo ) );
  //ShowMessage( sHeaderInfo.Text );
 except
  Result:=FALSE;
 end;

 Result:=( Result ) and ( sHeaderInfo.Count > 0 );

 X:=0;
 while( Result ) and ( X < sHeaderInfo.Count ) do
  begin
   if( bStoreResNames ) then
    begin
     s:=sHeaderInfo[ X ]+' : ';
     StrStream.Write( PChar( s )^, length( s ));
    end;

   Result:=ObjectBinaryStreamToObjectTextStream( Stream, StrStream, TRUE );
   Inc( X );
  end;

 Result:=( Result ) and ( X = sHeaderInfo.Count );

 if( Result ) then
  try
   StrStream.SaveToFile( TargetFileName );
  except
   Result:=FALSE;
  end;

 // Clean up trash
 if( Assigned( StrStream )) then
  FreeAndNil( StrStream );
 if( Assigned( Stream )) then
  FreeAndNil( Stream );
 if( Assigned( sHeaderInfo )) then
  FreeAndNil( sHeaderInfo );
end;


function CheckComponentInResourceFile( Component : TComponent; FileName : string;
                                       NamingMethod : TResourceNaming = rnClassTag ) : Boolean;
var
 Stream      : TComponentStream; // Stream with the component resources
 sHeaderInfo : TStringList;      // Header info contains information about available resources

begin
 Result:=( Assigned( Component )) and ( FileExists( FileName ));

 if( NOT Result ) then
  Exit;

 try
  Stream:=nil;
  sHeaderInfo:=nil;
  Stream:=TComponentStream.Create;
  Stream.LoadFromFile( FileName );
  sHeaderInfo:=TStringList.Create;
    // Great stuff, get the resource header and position information
  Result:=( GetResHeaderInfo( Stream, sHeaderInfo ) )
           and( sHeaderInfo.IndexOf( GetResourceName( Component, NamingMethod )) >= 0 );
  //ShowMessage( sHeaderInfo.Text );
 except
  Result:=FALSE;
 end;

 // Clean up trash
 if( Assigned( sHeaderInfo )) then
  FreeAndNil( sHeaderInfo );
 if( Assigned( Stream )) then
  FreeAndNil( Stream );
end;

function DeleteComponentFromResourceFile( ResourceName : string; FileName : string ) : Boolean;
 // Removes a specified resource with the name Resourcename from a resource file
 // NOTE: If you want to remove all parts of a form, you have to call this function
 //       for each component available on the form.

var
 Stream        : TComponentStream;    // Stream with the component resources
 sHeaderInfo   : TStringList;         // Header info contains information about available resources
 Index         : LongInt;             // Index to existing resource
 ByteCount     : LongInt;             // Byte count (size) of existing resource
 Pos           : LongInt;             // Start position of existing resource
 Pos2          : LongInt;             // End position of existing resource
 p             : PChar;               // Pointer to stream's memory to move blocks

begin
 Stream:=nil;
 sHeaderInfo:=nil;

 Result:=( FileExists( FileName ));

  // Try to create buffers and try to load the resource file
 if( Result ) then
  try
   Stream:=TComponentStream.Create;
   sHeaderInfo:=TStringList.Create;
  except
   Result:=FALSE;
  end;

 if( Result ) then
  try
   Stream.LoadFromFile( FileName );

    // Great stuff, get the resource header and position information
   Result:=( GetResHeaderInfo( Stream, sHeaderInfo )) and ( sHeaderInfo.Count > 0 );

   if( Result ) then
    begin
     Index:=sHeaderInfo.IndexOf( UpperCase( ResourceName ));
     Result:=( Index >= 0 );
    end;
  except
   Result:=FALSE;
  end;

  if( Result ) then
   begin
    // check position and delete the resource....

    // Component located on the begining of the stream or component located on end of stream?
    if( sHeaderInfo.Count = 1 ) or ( Index = sHeaderInfo.Count - 1 ) then
      begin
        // Resource file has one or two elements

       if( sHeaderInfo.Count = 1 ) and ( Index = sHeaderInfo.Count - 1 ) then
         // Clear the file if one element inside
        Stream.Size:=0
       else // resource is located on the end of the file, remove it
            Stream.Size:=LongInt( sHeaderInfo.Objects[ Index ] );
      end
    else begin
          // Resource file has at least three elements
          // Get all positions and sizes of the existing component resource

          Pos:=LongInt( sHeaderInfo.Objects[ Index ] );    // target to overwrite
          Pos2:=LongInt( sHeaderInfo.Objects[ Index+1 ] ); // source to move
          ByteCount:=( Stream.Size - (Pos2) );  // Bytes to move

           // Move it
          p:=PChar( Stream.Memory );
          Move( p[ Pos2 ], p[ Pos ], ByteCount );
          Stream.Size:=Stream.Size - (Pos2 - Pos);  // Truncate file
         end;
   end;

  if( Result ) then
   try
     // Finally, save it
    Stream.SaveToFile( FileName );
   except
    Result:=FALSE;
   end;

  // Clean up trash
 if( Assigned( sHeaderInfo )) then
  FreeAndNil( sHeaderInfo );
 if( Assigned( Stream )) then
  FreeAndNil( Stream );
end;

function DeleteComponentFromResourceFile( Component : TComponent; FileName : string; NamingMethod : TResourceNaming = rnClassTag ) : Boolean;
begin
 try
  Result:=( Assigned( Component ))
        and( DeleteComponentFromResourceFile( GetResourceName( Component, NamingMethod ), FileName ));
 except
  Result:=FALSE;
 end; 
end;




end.

