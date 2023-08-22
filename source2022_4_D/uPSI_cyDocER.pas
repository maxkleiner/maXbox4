unit uPSI_cyDocER;
{
   fine OCR to forensic   rename TElement to TcyElement
}
interface
 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_cyDocER = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TcyDocER(CL: TPSPascalCompiler);
procedure SIRegister_TElements(CL: TPSPascalCompiler);
procedure SIRegister_TElement(CL: TPSPascalCompiler);
procedure SIRegister_TOCRExpression(CL: TPSPascalCompiler);
procedure SIRegister_cyDocER(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TcyDocER(CL: TPSRuntimeClassImporter);
procedure RIRegister_TElements(CL: TPSRuntimeClassImporter);
procedure RIRegister_TElement(CL: TPSRuntimeClassImporter);
procedure RIRegister_TOCRExpression(CL: TPSRuntimeClassImporter);
procedure RIRegister_cyDocER(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   Windows
  ,Controls
  ,cyStrUtils
  ,cyDERUtils
  ,cyGraphics
  ,cyDateUtils
  ,cyDocER
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_cyDocER]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TcyDocER(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TComponent', 'TcyDocER') do
  with CL.AddClassN(CL.FindClass('TComponent'),'TcyDocER') do begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Free');
    RegisterMethod('Procedure NewDocument( ImagePageCount, ImageResolution, DefaultImagePixelsWidth, DefaultImagePixelsHeight : Integer)');
    RegisterMethod('Procedure LoadFromTesseractString( aString : String; aPageNumber : Integer)');
    RegisterMethod('Procedure LoadFromTesseractFile( aFilename : String; aPageNumber : Word; aEncoding : TEncoding)');
    RegisterMethod('Procedure LoadFromTesseractBoxStringList( aStrings : TStrings; ImagePageCount, ImageResolution, ImagePixelsWidth, ImagePixelsHeight : Integer)');
    RegisterMethod('Procedure LoadFromTesseractBoxFile( aFilename : String; aEncoding : TEncoding; ImagePageCount, ImageResolution, ImagePixelsWidth, ImagePixelsHeight : Integer)');
    RegisterMethod('Procedure LoadFromStringList( aStrings : TStrings)');
    RegisterMethod('Procedure LoadFromFile( aFilename : String; aEncoding : TEncoding)');
    RegisterMethod('Procedure SaveToStringList( aStrings : TStrings)');
    RegisterMethod('Procedure SaveToFile( aFilename : String; aEncoding : TEncoding)');
    RegisterMethod('Function MmToPx( MmValue : Double) : Integer');
    RegisterMethod('Function PxToMm( pxValue : Extended) : Double');
    RegisterMethod('Procedure ClearExpressions');
    RegisterMethod('Function GetOCRText( const FromPage : Integer) : String');
    RegisterMethod('Function GetOCRTextFromRect( FromRect : TRect; FromPage : Integer; const AllowPartiallyInside : Boolean) : String');
    RegisterMethod('Function GetAsDocumentOCRText( const FromPage : Integer) : String');
    RegisterMethod('Function GetAsDocumentOCRTextFromRect( FromRect : TRect; FromPage : Integer; const AllowPartiallyInside : Boolean) : String');
    RegisterMethod('Procedure RotatePageExpressions( PageNumber, PageWidthBeforeRotation, PageHeightBeforeRotation : Integer; ToRight : Boolean)');
    RegisterMethod('Function ExpressionInRect( aExpressionIndex : Integer; InRect : TRect; const AllowPartiallyInside : Boolean) : Boolean');
    RegisterMethod('Procedure RecognizeExpressionType( aExpressionIndex : Integer)');
    RegisterMethod('Function AddExpression( aString : String; aPageNumber : Word; aOCRConfidence : Extended; aRect : TRect) : Integer;');
    RegisterMethod('Function CloneExpression( aExpressionIndex : Integer) : Integer');
    RegisterMethod('Function AddExpression1( aString : String; aPageNumber : Word; aOCRConfidence : Extended) : Integer;');
    RegisterMethod('Procedure ExpressionAdded');
    RegisterMethod('Procedure ExpressionLoaded');
    RegisterMethod('Procedure DeleteExpression( aExpressionIndex : Integer)');
    RegisterMethod('Function LocateExpression( Value : String; FromIndex, ToIndex, MaxCarErrors : Integer; Options : TLocateExpressionOptions; var RsltCarPos : Integer) : Integer');
    RegisterMethod('Function ExpressionsInSameLine( aExpressionIndex1, aExpressionIndex2 : Integer) : Boolean');
    RegisterMethod('Procedure GetAroundExpressions( aExpressionIndex, MaxCarErrors, ScopePx : Integer; SearchValue : String; SearchOptions : TLocateExpressionOptions; var RsltLeft, RsltTop, RsltRight, RsltBottom : Integer)');
    RegisterMethod('Procedure MergeExpressions( aExpressionIndex, ToExpressionIndex : Integer)');
    RegisterMethod('Function ExpressionsSideBySide( ExpressionIndexAtLeft, ExpressionIndexAtRight, MaxPxSpacing : Integer) : Boolean');
    RegisterMethod('Function IsElementKeyword( aElementIndex : Integer; aStr : String) : Integer');
    RegisterMethod('Function IsExpressionsSameValue( ExpressionIndex1, ExpressionIndex2 : Integer) : Boolean');
    RegisterMethod('Function FindExpression( StartIndex, AssociatedElementIndex, AssociatedElementKeywordIndex, AssociatedExpressionKeywordIndex : Integer; IncludeElementsTypes, ExcludeElementsTypes : TElementsTypes) : Integer;');
    RegisterMethod('Function FindExpression1( Value : Variant; ValueType : TElementsType; FromIndex, ToIndex : Integer) : Integer;');
    RegisterMethod('Procedure DissociateExpressions( FromElementIndex, FromElementKeywordIndex : Integer)');
    RegisterMethod('Procedure InitializeRecognition');
    RegisterMethod('Function RecognizeElementKeyword( ElementIndex, KeywordIndex : Integer; InlineKeyword : Boolean) : Boolean');
    RegisterMethod('Function RecognizeElementValuesFromRect( OfElementIndex, OfElementKeywordIndex, OfExpressionKeywordIndex : Integer; aValueType : TElementsType; aPageNumber, LeftPos, TopPos, RightPos, BottomPos : Integer; '+
                    'ValueLocation : TSearchValueLocation; ValueNumber, ValueCount : Integer; PatternMode : Boolean; var UserAbort : Boolean) : Integer');
    RegisterMethod('Procedure RecognizeLongDates');
    RegisterMethod('Procedure RecognizeElementValues( ElementIndex : Integer)');
    RegisterMethod('Procedure RecognizeElementsKeywords');
    RegisterMethod('Procedure RecognizeElementsValues');
    RegisterMethod('Procedure RecognizeElements');
    RegisterProperty('ExpressionCount', 'Integer', iptr);
    RegisterProperty('Expressions', 'TOCRExpression Integer', iptr);
    SetDefaultPropery('Expressions');
    RegisterProperty('PageCount', 'Integer', iptr);
    RegisterProperty('PixelsHeight', 'Integer', iptr);
    RegisterProperty('PixelsWidth', 'Integer', iptr);
    RegisterProperty('Resolution', 'Integer', iptr);
    RegisterProperty('AutoMergeExpressionsRatio', 'Extended', iptrw);
    RegisterProperty('ShortMonthNames', 'TStrings', iptrw);
    RegisterProperty('Elements', 'TElements', iptrw);
    RegisterProperty('ExpressionOptions', 'TExpressionOptions', iptrw);
    RegisterProperty('RecognitionOptions', 'TRecognitionOptions', iptrw);
    RegisterProperty('RecognitionPriorityMode', 'TRecognitionPriorityMode', iptrw);
    RegisterProperty('BeforeRecognizeElementsKeywords', 'TNotifyEvent', iptrw);
    RegisterProperty('BeforeRecognizeElementsValues', 'TNotifyEvent', iptrw);
    RegisterProperty('BeforeRecognizeElementKeyword', 'TProcOnRecognizeElementKeyword', iptrw);
    RegisterProperty('AfterRecognizeElementKeyword', 'TProcOnRecognizeElementKeyword', iptrw);
    RegisterProperty('OnValidateElementKeyword', 'TProcValidateElementKeyword', iptrw);
    RegisterProperty('OnRetrieveElementValuesFromRect', 'TProcRetrieveElementValuesFromRect', iptrw);
    RegisterProperty('OnValidateElementValue', 'TProcValidateElementValue', iptrw);
    RegisterProperty('OnExpressionMerged', 'TProcOnExpressionMerged', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TElements(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollection', 'TElements') do
  with CL.AddClassN(CL.FindClass('TCollection'),'TElements') do begin
    RegisterMethod('Constructor Create( aDocument : TcyDocER; ElementClass : TElementClass)');
    RegisterMethod('Function Add : TcyElement');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterProperty('Items', 'TcyElement Integer', iptr);
    SetDefaultPropery('Items');
    RegisterProperty('OnChange', 'TNotifyEvent', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TElement(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TCollectionItem', 'TElement') do
  with CL.AddClassN(CL.FindClass('TCollectionItem'),'TcyElement') do begin
    RegisterMethod('Constructor Create( Collection : TCollection)');
     RegisterMethod('Procedure Free');
      RegisterMethod('Procedure Assign( Source : TPersistent)');
    RegisterMethod('Function PatternRecognition : boolean');
    RegisterProperty('KeyWords', 'TStrings', iptrw);
    RegisterProperty('PatternPageNumber', 'Integer', iptrw);
    RegisterProperty('PatternPageNumberMode', 'TPatternPageNumberMode', iptrw);
    RegisterProperty('PatternFromLeftMm', 'Double', iptrw);
    RegisterProperty('PatternFromTopMm', 'Double', iptrw);
    RegisterProperty('PatternToRightMm', 'Double', iptrw);
    RegisterProperty('PatternToBottomMm', 'Double', iptrw);
    RegisterProperty('PatternPositionMode', 'TPatternPositionMode', iptrw);
    RegisterProperty('PatternValueLocation', 'TSearchValueLocation', iptrw);
    RegisterProperty('PatternValueNumber', 'Integer', iptrw);
    RegisterProperty('ValueCount', 'Integer', iptrw);
    RegisterProperty('ValueType', 'TElementsType', iptrw);
    RegisterProperty('Tag', 'Integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TOCRExpression(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TOCRExpression') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TOCRExpression') do
  begin
    RegisterMethod('Function RecognizedValue : String');
    RegisterProperty('LeftPxPos', 'Integer', iptr);
    RegisterProperty('TopPxPos', 'Integer', iptr);
    RegisterProperty('RightPxPos', 'Integer', iptr);
    RegisterProperty('BottomPxPos', 'Integer', iptr);
    RegisterProperty('Value', 'String', iptrw);
    RegisterProperty('PageNumber', 'Integer', iptr);
    RegisterProperty('DERValue', 'DERString', iptr);
    RegisterProperty('AssociatedElementIndex', 'Integer', iptrw);
    RegisterProperty('AssociatedElementKeywordIndex', 'Integer', iptrw);
    RegisterProperty('AssociatedExpressionKeywordIndex', 'Integer', iptrw);
    RegisterProperty('OCRConfidence', 'Extended', iptrw);
    RegisterProperty('RecognizedType', 'TElementsType', iptrw);
    RegisterProperty('RecognizedDate', 'String', iptrw);
    RegisterProperty('RecognizedMoney', 'String', iptrw);
    RegisterProperty('RecognizedWebsite', 'String', iptrw);
    RegisterProperty('RecognizedWebMail', 'String', iptrw);
    RegisterProperty('RecognizedPercentage', 'String', iptrw);
    RegisterProperty('RecognizedFloat', 'String', iptrw);
    RegisterProperty('RecognizedInteger', 'String', iptrw);
    RegisterProperty('RecognizedNumbers', 'String', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_cyDocER(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TReadingDirection', '( rdLeft, rdTop, rdRight, rdBottom )');
  CL.AddTypeS('TReadingDirections', 'set of TReadingDirection');
  CL.AddTypeS('TOCRCarInfo', 'record Value : String; PageNumber : Integer; Left'
   +' : Integer; Top : Integer; Right : Integer; Bottom : Integer; WordNumber : Integer; end');
  CL.AddClassN(CL.FindClass('TOBJECT'),'TcyDocER');
  SIRegister_TOCRExpression(CL);
  CL.AddTypeS('TSearchValueLocation', '( slFromLeft, slFromTop, slFromRight, slFromBottom )');
  CL.AddTypeS('TPatternPositionMode', '( ppFromTopLeftPage, ppFromTopLeftKeyword )');
  CL.AddTypeS('TPatternPageNumberMode', '( ppFromBeginning, ppFromEnd )');
  SIRegister_TElement(CL);
  //CL.AddTypeS('TElementClass', 'class of TElement');
  SIRegister_TElements(CL);
  CL.AddTypeS('TRecognitionElementsMode', '( reKeywords, reValues, reKeywordsAndValues )');
  CL.AddTypeS('TRecognitionPriorityMode', '( rpKeywordsLenth, rpSinglelineKeywordsLength )');
  CL.AddTypeS('TRecognitionOption', '( roKeywordsByPriority, roSmartNumbersRec,roSmartWebsiteRec, roSmartKeywordRec )');
  CL.AddTypeS('TRecognitionOptions', 'set of TRecognitionOption');
  CL.AddTypeS('TExpressionOption', '( eoDERValueAsString )');
  CL.AddTypeS('TExpressionOptions', 'set of TExpressionOption');
  CL.AddTypeS('TLocateExpressionOption', '( lePartialKey, leRelativePositionKey, leInsensitive, leSmartKeywordRec )');
  CL.AddTypeS('TLocateExpressionOptions', 'set of TLocateExpressionOption');
  CL.AddTypeS('TValidateElementValueResult', '( veValueOk, veInvalidValue, veInvalidValueStopSearching, veValueTooFar )');
  CL.AddTypeS('TProcOnExpressionMerged', 'Procedure ( Sender : TObject; aExpressionIndex, toExpressionIndex : Integer)');
  CL.AddTypeS('TProcOnRecognizeElementKeyword', 'Procedure ( Sender : TObject; ElementIndex, ElementKeywordIndex : Integer)');
  CL.AddTypeS('TProcValidateElementValue', 'Procedure ( Sender : TObject; Eleme'
   +'ntIndex, ElementKeywordIndex, ExpressionKeywordIndex, ExpressionValueIndex'
   +' : Integer; var ValidateElementValueResult : TValidateElementValueResult)');
  CL.AddTypeS('TProcValidateElementKeyword', 'Procedure ( Sender : TObject; Ele'
   +'mentIndex, ElementKeywordIndex : Integer; ExpressionsList : TStrings; var Accept : Boolean)');
  CL.AddTypeS('TProcRetrieveElementValuesFromRect', 'Procedure ( Sender : TObje'
   +'ct; ElementIndex, ElementKeywordIndex, ExpressionKeywordIndex : Integer; ExpressionList : TStrings)');
  SIRegister_TcyDocER(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TcyDocEROnExpressionMerged_W(Self: TcyDocER; const T: TProcOnExpressionMerged);
begin Self.OnExpressionMerged := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocEROnExpressionMerged_R(Self: TcyDocER; var T: TProcOnExpressionMerged);
begin T := Self.OnExpressionMerged; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocEROnValidateElementValue_W(Self: TcyDocER; const T: TProcValidateElementValue);
begin Self.OnValidateElementValue := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocEROnValidateElementValue_R(Self: TcyDocER; var T: TProcValidateElementValue);
begin T := Self.OnValidateElementValue; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocEROnRetrieveElementValuesFromRect_W(Self: TcyDocER; const T: TProcRetrieveElementValuesFromRect);
begin Self.OnRetrieveElementValuesFromRect := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocEROnRetrieveElementValuesFromRect_R(Self: TcyDocER; var T: TProcRetrieveElementValuesFromRect);
begin T := Self.OnRetrieveElementValuesFromRect; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocEROnValidateElementKeyword_W(Self: TcyDocER; const T: TProcValidateElementKeyword);
begin Self.OnValidateElementKeyword := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocEROnValidateElementKeyword_R(Self: TcyDocER; var T: TProcValidateElementKeyword);
begin T := Self.OnValidateElementKeyword; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERAfterRecognizeElementKeyword_W(Self: TcyDocER; const T: TProcOnRecognizeElementKeyword);
begin Self.AfterRecognizeElementKeyword := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERAfterRecognizeElementKeyword_R(Self: TcyDocER; var T: TProcOnRecognizeElementKeyword);
begin T := Self.AfterRecognizeElementKeyword; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERBeforeRecognizeElementKeyword_W(Self: TcyDocER; const T: TProcOnRecognizeElementKeyword);
begin Self.BeforeRecognizeElementKeyword := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERBeforeRecognizeElementKeyword_R(Self: TcyDocER; var T: TProcOnRecognizeElementKeyword);
begin T := Self.BeforeRecognizeElementKeyword; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERBeforeRecognizeElementsValues_W(Self: TcyDocER; const T: TNotifyEvent);
begin Self.BeforeRecognizeElementsValues := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERBeforeRecognizeElementsValues_R(Self: TcyDocER; var T: TNotifyEvent);
begin T := Self.BeforeRecognizeElementsValues; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERBeforeRecognizeElementsKeywords_W(Self: TcyDocER; const T: TNotifyEvent);
begin Self.BeforeRecognizeElementsKeywords := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERBeforeRecognizeElementsKeywords_R(Self: TcyDocER; var T: TNotifyEvent);
begin T := Self.BeforeRecognizeElementsKeywords; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERRecognitionPriorityMode_W(Self: TcyDocER; const T: TRecognitionPriorityMode);
begin Self.RecognitionPriorityMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERRecognitionPriorityMode_R(Self: TcyDocER; var T: TRecognitionPriorityMode);
begin T := Self.RecognitionPriorityMode; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERRecognitionOptions_W(Self: TcyDocER; const T: TRecognitionOptions);
begin Self.RecognitionOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERRecognitionOptions_R(Self: TcyDocER; var T: TRecognitionOptions);
begin T := Self.RecognitionOptions; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERExpressionOptions_W(Self: TcyDocER; const T: TExpressionOptions);
begin Self.ExpressionOptions := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERExpressionOptions_R(Self: TcyDocER; var T: TExpressionOptions);
begin T := Self.ExpressionOptions; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERElements_W(Self: TcyDocER; const T: TElements);
begin Self.Elements := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERElements_R(Self: TcyDocER; var T: TElements);
begin T := Self.Elements; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERShortMonthNames_W(Self: TcyDocER; const T: TStrings);
begin Self.ShortMonthNames := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERShortMonthNames_R(Self: TcyDocER; var T: TStrings);
begin T := Self.ShortMonthNames; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERAutoMergeExpressionsRatio_W(Self: TcyDocER; const T: Extended);
begin Self.AutoMergeExpressionsRatio := T; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERAutoMergeExpressionsRatio_R(Self: TcyDocER; var T: Extended);
begin T := Self.AutoMergeExpressionsRatio; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERResolution_R(Self: TcyDocER; var T: Integer);
begin T := Self.Resolution; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERPixelsWidth_R(Self: TcyDocER; var T: Integer);
begin T := Self.PixelsWidth; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERPixelsHeight_R(Self: TcyDocER; var T: Integer);
begin T := Self.PixelsHeight; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERPageCount_R(Self: TcyDocER; var T: Integer);
begin T := Self.PageCount; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERExpressions_R(Self: TcyDocER; var T: TOCRExpression; const t1: Integer);
begin T := Self.Expressions[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TcyDocERExpressionCount_R(Self: TcyDocER; var T: Integer);
begin T := Self.ExpressionCount; end;

(*----------------------------------------------------------------------------*)
Function TcyDocERFindExpression1_P(Self: TcyDocER;  Value : Variant; ValueType : TElementsType; FromIndex, ToIndex : Integer) : Integer;
Begin Result := Self.FindExpression(Value, ValueType, FromIndex, ToIndex); END;

(*----------------------------------------------------------------------------*)
Function TcyDocERFindExpression_P(Self: TcyDocER;  StartIndex, AssociatedElementIndex, AssociatedElementKeywordIndex, AssociatedExpressionKeywordIndex : Integer; IncludeElementsTypes, ExcludeElementsTypes : TElementsTypes) : Integer;
Begin Result := Self.FindExpression(StartIndex, AssociatedElementIndex, AssociatedElementKeywordIndex, AssociatedExpressionKeywordIndex, IncludeElementsTypes, ExcludeElementsTypes); END;

(*----------------------------------------------------------------------------*)
Function TcyDocERAddExpression1_P(Self: TcyDocER;  aString : String; aPageNumber : Word; aOCRConfidence : Extended) : Integer;
Begin Result := Self.AddExpression(aString, aPageNumber, aOCRConfidence); END;

(*----------------------------------------------------------------------------*)
Function TcyDocERAddExpression_P(Self: TcyDocER;  aString : String; aPageNumber : Word; aOCRConfidence : Extended; aRect : TRect) : Integer;
Begin Result := Self.AddExpression(aString, aPageNumber, aOCRConfidence, aRect); END;

(*----------------------------------------------------------------------------*)
procedure TElementsOnChange_W(Self: TElements; const T: TNotifyEvent);
begin Self.OnChange := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementsOnChange_R(Self: TElements; var T: TNotifyEvent);
begin T := Self.OnChange; end;

(*----------------------------------------------------------------------------*)
procedure TElementsItems_R(Self: TElements; var T: TcyElement; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TElementTag_W(Self: TcyElement; const T: Integer);
begin Self.Tag := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementTag_R(Self: TcyElement; var T: Integer);
begin T := Self.Tag; end;

(*----------------------------------------------------------------------------*)
procedure TElementValueType_W(Self: TcyElement; const T: TElementsType);
begin Self.ValueType := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementValueType_R(Self: TcyElement; var T: TElementsType);
begin T := Self.ValueType; end;

(*----------------------------------------------------------------------------*)
procedure TElementValueCount_W(Self: TcyElement; const T: Integer);
begin Self.ValueCount := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementValueCount_R(Self: TcyElement; var T: Integer);
begin T := Self.ValueCount; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternValueNumber_W(Self: TcyElement; const T: Integer);
begin Self.PatternValueNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternValueNumber_R(Self: TcyElement; var T: Integer);
begin T := Self.PatternValueNumber; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternValueLocation_W(Self: TcyElement; const T: TSearchValueLocation);
begin Self.PatternValueLocation := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternValueLocation_R(Self: TcyElement; var T: TSearchValueLocation);
begin T := Self.PatternValueLocation; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternPositionMode_W(Self: TcyElement; const T: TPatternPositionMode);
begin Self.PatternPositionMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternPositionMode_R(Self: TcyElement; var T: TPatternPositionMode);
begin T := Self.PatternPositionMode; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternToBottomMm_W(Self: TcyElement; const T: Double);
begin Self.PatternToBottomMm := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternToBottomMm_R(Self: TcyElement; var T: Double);
begin T := Self.PatternToBottomMm; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternToRightMm_W(Self: TcyElement; const T: Double);
begin Self.PatternToRightMm := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternToRightMm_R(Self: TcyElement; var T: Double);
begin T := Self.PatternToRightMm; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternFromTopMm_W(Self: TcyElement; const T: Double);
begin Self.PatternFromTopMm := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternFromTopMm_R(Self: TcyElement; var T: Double);
begin T := Self.PatternFromTopMm; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternFromLeftMm_W(Self: TcyElement; const T: Double);
begin Self.PatternFromLeftMm := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternFromLeftMm_R(Self: TcyElement; var T: Double);
begin T := Self.PatternFromLeftMm; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternPageNumberMode_W(Self: TcyElement; const T: TPatternPageNumberMode);
begin Self.PatternPageNumberMode := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternPageNumberMode_R(Self: TcyElement; var T: TPatternPageNumberMode);
begin T := Self.PatternPageNumberMode; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternPageNumber_W(Self: TcyElement; const T: Integer);
begin Self.PatternPageNumber := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementPatternPageNumber_R(Self: TcyElement; var T: Integer);
begin T := Self.PatternPageNumber; end;

(*----------------------------------------------------------------------------*)
procedure TElementKeyWords_W(Self: TcyElement; const T: TStrings);
begin Self.KeyWords := T; end;

(*----------------------------------------------------------------------------*)
procedure TElementKeyWords_R(Self: TcyElement; var T: TStrings);
begin T := Self.KeyWords; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedNumbers_W(Self: TOCRExpression; const T: String);
begin Self.RecognizedNumbers := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedNumbers_R(Self: TOCRExpression; var T: String);
begin T := Self.RecognizedNumbers; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedInteger_W(Self: TOCRExpression; const T: String);
begin Self.RecognizedInteger := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedInteger_R(Self: TOCRExpression; var T: String);
begin T := Self.RecognizedInteger; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedFloat_W(Self: TOCRExpression; const T: String);
begin Self.RecognizedFloat := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedFloat_R(Self: TOCRExpression; var T: String);
begin T := Self.RecognizedFloat; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedPercentage_W(Self: TOCRExpression; const T: String);
begin Self.RecognizedPercentage := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedPercentage_R(Self: TOCRExpression; var T: String);
begin T := Self.RecognizedPercentage; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedWebMail_W(Self: TOCRExpression; const T: String);
begin Self.RecognizedWebMail := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedWebMail_R(Self: TOCRExpression; var T: String);
begin T := Self.RecognizedWebMail; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedWebsite_W(Self: TOCRExpression; const T: String);
begin Self.RecognizedWebsite := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedWebsite_R(Self: TOCRExpression; var T: String);
begin T := Self.RecognizedWebsite; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedMoney_W(Self: TOCRExpression; const T: String);
begin Self.RecognizedMoney := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedMoney_R(Self: TOCRExpression; var T: String);
begin T := Self.RecognizedMoney; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedDate_W(Self: TOCRExpression; const T: String);
begin Self.RecognizedDate := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedDate_R(Self: TOCRExpression; var T: String);
begin T := Self.RecognizedDate; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedType_W(Self: TOCRExpression; const T: TElementsType);
begin Self.RecognizedType := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRecognizedType_R(Self: TOCRExpression; var T: TElementsType);
begin T := Self.RecognizedType; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionOCRConfidence_W(Self: TOCRExpression; const T: Extended);
begin Self.OCRConfidence := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionOCRConfidence_R(Self: TOCRExpression; var T: Extended);
begin T := Self.OCRConfidence; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionAssociatedExpressionKeywordIndex_W(Self: TOCRExpression; const T: Integer);
begin Self.AssociatedExpressionKeywordIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionAssociatedExpressionKeywordIndex_R(Self: TOCRExpression; var T: Integer);
begin T := Self.AssociatedExpressionKeywordIndex; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionAssociatedElementKeywordIndex_W(Self: TOCRExpression; const T: Integer);
begin Self.AssociatedElementKeywordIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionAssociatedElementKeywordIndex_R(Self: TOCRExpression; var T: Integer);
begin T := Self.AssociatedElementKeywordIndex; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionAssociatedElementIndex_W(Self: TOCRExpression; const T: Integer);
begin Self.AssociatedElementIndex := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionAssociatedElementIndex_R(Self: TOCRExpression; var T: Integer);
begin T := Self.AssociatedElementIndex; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionDERValue_R(Self: TOCRExpression; var T: DERString);
begin T := Self.DERValue; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionPageNumber_R(Self: TOCRExpression; var T: Integer);
begin T := Self.PageNumber; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionValue_W(Self: TOCRExpression; const T: String);
begin Self.Value := T; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionValue_R(Self: TOCRExpression; var T: String);
begin T := Self.Value; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionBottomPxPos_R(Self: TOCRExpression; var T: Integer);
begin T := Self.BottomPxPos; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionRightPxPos_R(Self: TOCRExpression; var T: Integer);
begin T := Self.RightPxPos; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionTopPxPos_R(Self: TOCRExpression; var T: Integer);
begin T := Self.TopPxPos; end;

(*----------------------------------------------------------------------------*)
procedure TOCRExpressionLeftPxPos_R(Self: TOCRExpression; var T: Integer);
begin T := Self.LeftPxPos; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TcyDocER(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyDocER) do begin
    RegisterConstructor(@TcyDocER.Create, 'Create');
    RegisterMethod(@TcyDocER.Destroy, 'Free');
    RegisterMethod(@TcyDocER.NewDocument, 'NewDocument');
    RegisterMethod(@TcyDocER.LoadFromTesseractString, 'LoadFromTesseractString');
    RegisterMethod(@TcyDocER.LoadFromTesseractFile, 'LoadFromTesseractFile');
    RegisterMethod(@TcyDocER.LoadFromTesseractBoxStringList, 'LoadFromTesseractBoxStringList');
    RegisterMethod(@TcyDocER.LoadFromTesseractBoxFile, 'LoadFromTesseractBoxFile');
    RegisterMethod(@TcyDocER.LoadFromStringList, 'LoadFromStringList');
    RegisterMethod(@TcyDocER.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TcyDocER.SaveToStringList, 'SaveToStringList');
    RegisterMethod(@TcyDocER.SaveToFile, 'SaveToFile');
    RegisterMethod(@TcyDocER.MmToPx, 'MmToPx');
    RegisterMethod(@TcyDocER.PxToMm, 'PxToMm');
    RegisterMethod(@TcyDocER.ClearExpressions, 'ClearExpressions');
    RegisterMethod(@TcyDocER.GetOCRText, 'GetOCRText');
    RegisterMethod(@TcyDocER.GetOCRTextFromRect, 'GetOCRTextFromRect');
    RegisterMethod(@TcyDocER.GetAsDocumentOCRText, 'GetAsDocumentOCRText');
    RegisterMethod(@TcyDocER.GetAsDocumentOCRTextFromRect, 'GetAsDocumentOCRTextFromRect');
    RegisterMethod(@TcyDocER.RotatePageExpressions, 'RotatePageExpressions');
    RegisterMethod(@TcyDocER.ExpressionInRect, 'ExpressionInRect');
    RegisterMethod(@TcyDocER.RecognizeExpressionType, 'RecognizeExpressionType');
    RegisterMethod(@TcyDocERAddExpression_P, 'AddExpression');
    RegisterMethod(@TcyDocER.CloneExpression, 'CloneExpression');
    RegisterMethod(@TcyDocERAddExpression1_P, 'AddExpression1');
    RegisterMethod(@TcyDocER.ExpressionAdded, 'ExpressionAdded');
    RegisterMethod(@TcyDocER.ExpressionLoaded, 'ExpressionLoaded');
    RegisterMethod(@TcyDocER.DeleteExpression, 'DeleteExpression');
    RegisterMethod(@TcyDocER.LocateExpression, 'LocateExpression');
    RegisterMethod(@TcyDocER.ExpressionsInSameLine, 'ExpressionsInSameLine');
    RegisterMethod(@TcyDocER.GetAroundExpressions, 'GetAroundExpressions');
    RegisterMethod(@TcyDocER.MergeExpressions, 'MergeExpressions');
    RegisterMethod(@TcyDocER.ExpressionsSideBySide, 'ExpressionsSideBySide');
    RegisterMethod(@TcyDocER.IsElementKeyword, 'IsElementKeyword');
    RegisterMethod(@TcyDocER.IsExpressionsSameValue, 'IsExpressionsSameValue');
    RegisterMethod(@TcyDocERFindExpression_P, 'FindExpression');
    RegisterMethod(@TcyDocERFindExpression1_P, 'FindExpression1');
    RegisterMethod(@TcyDocER.DissociateExpressions, 'DissociateExpressions');
    RegisterMethod(@TcyDocER.InitializeRecognition, 'InitializeRecognition');
    RegisterMethod(@TcyDocER.RecognizeElementKeyword, 'RecognizeElementKeyword');
    RegisterMethod(@TcyDocER.RecognizeElementValuesFromRect, 'RecognizeElementValuesFromRect');
    RegisterMethod(@TcyDocER.RecognizeLongDates, 'RecognizeLongDates');
    RegisterMethod(@TcyDocER.RecognizeElementValues, 'RecognizeElementValues');
    RegisterMethod(@TcyDocER.RecognizeElementsKeywords, 'RecognizeElementsKeywords');
    RegisterMethod(@TcyDocER.RecognizeElementsValues, 'RecognizeElementsValues');
    RegisterMethod(@TcyDocER.RecognizeElements, 'RecognizeElements');
    RegisterPropertyHelper(@TcyDocERExpressionCount_R,nil,'ExpressionCount');
    RegisterPropertyHelper(@TcyDocERExpressions_R,nil,'Expressions');
    RegisterPropertyHelper(@TcyDocERPageCount_R,nil,'PageCount');
    RegisterPropertyHelper(@TcyDocERPixelsHeight_R,nil,'PixelsHeight');
    RegisterPropertyHelper(@TcyDocERPixelsWidth_R,nil,'PixelsWidth');
    RegisterPropertyHelper(@TcyDocERResolution_R,nil,'Resolution');
    RegisterPropertyHelper(@TcyDocERAutoMergeExpressionsRatio_R,@TcyDocERAutoMergeExpressionsRatio_W,'AutoMergeExpressionsRatio');
    RegisterPropertyHelper(@TcyDocERShortMonthNames_R,@TcyDocERShortMonthNames_W,'ShortMonthNames');
    RegisterPropertyHelper(@TcyDocERElements_R,@TcyDocERElements_W,'Elements');
    RegisterPropertyHelper(@TcyDocERExpressionOptions_R,@TcyDocERExpressionOptions_W,'ExpressionOptions');
    RegisterPropertyHelper(@TcyDocERRecognitionOptions_R,@TcyDocERRecognitionOptions_W,'RecognitionOptions');
    RegisterPropertyHelper(@TcyDocERRecognitionPriorityMode_R,@TcyDocERRecognitionPriorityMode_W,'RecognitionPriorityMode');
    RegisterPropertyHelper(@TcyDocERBeforeRecognizeElementsKeywords_R,@TcyDocERBeforeRecognizeElementsKeywords_W,'BeforeRecognizeElementsKeywords');
    RegisterPropertyHelper(@TcyDocERBeforeRecognizeElementsValues_R,@TcyDocERBeforeRecognizeElementsValues_W,'BeforeRecognizeElementsValues');
    RegisterPropertyHelper(@TcyDocERBeforeRecognizeElementKeyword_R,@TcyDocERBeforeRecognizeElementKeyword_W,'BeforeRecognizeElementKeyword');
    RegisterPropertyHelper(@TcyDocERAfterRecognizeElementKeyword_R,@TcyDocERAfterRecognizeElementKeyword_W,'AfterRecognizeElementKeyword');
    RegisterPropertyHelper(@TcyDocEROnValidateElementKeyword_R,@TcyDocEROnValidateElementKeyword_W,'OnValidateElementKeyword');
    RegisterPropertyHelper(@TcyDocEROnRetrieveElementValuesFromRect_R,@TcyDocEROnRetrieveElementValuesFromRect_W,'OnRetrieveElementValuesFromRect');
    RegisterPropertyHelper(@TcyDocEROnValidateElementValue_R,@TcyDocEROnValidateElementValue_W,'OnValidateElementValue');
    RegisterPropertyHelper(@TcyDocEROnExpressionMerged_R,@TcyDocEROnExpressionMerged_W,'OnExpressionMerged');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TElements(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TElements) do
  begin
    RegisterConstructor(@TElements.Create, 'Create');
    RegisterMethod(@TElements.Add, 'Add');
    RegisterMethod(@TElements.Delete, 'Delete');
    RegisterPropertyHelper(@TElementsItems_R,nil,'Items');
    RegisterPropertyHelper(@TElementsOnChange_R,@TElementsOnChange_W,'OnChange');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TElement(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyElement) do begin
    RegisterConstructor(@TcyElement.Create, 'Create');
     RegisterMethod(@TcyElement.Destroy, 'Free');
      RegisterMethod(@TcyElement.Assign, 'Assign');
    RegisterMethod(@TcyElement.PatternRecognition, 'PatternRecognition');
    RegisterPropertyHelper(@TElementKeyWords_R,@TElementKeyWords_W,'KeyWords');
    RegisterPropertyHelper(@TElementPatternPageNumber_R,@TElementPatternPageNumber_W,'PatternPageNumber');
    RegisterPropertyHelper(@TElementPatternPageNumberMode_R,@TElementPatternPageNumberMode_W,'PatternPageNumberMode');
    RegisterPropertyHelper(@TElementPatternFromLeftMm_R,@TElementPatternFromLeftMm_W,'PatternFromLeftMm');
    RegisterPropertyHelper(@TElementPatternFromTopMm_R,@TElementPatternFromTopMm_W,'PatternFromTopMm');
    RegisterPropertyHelper(@TElementPatternToRightMm_R,@TElementPatternToRightMm_W,'PatternToRightMm');
    RegisterPropertyHelper(@TElementPatternToBottomMm_R,@TElementPatternToBottomMm_W,'PatternToBottomMm');
    RegisterPropertyHelper(@TElementPatternPositionMode_R,@TElementPatternPositionMode_W,'PatternPositionMode');
    RegisterPropertyHelper(@TElementPatternValueLocation_R,@TElementPatternValueLocation_W,'PatternValueLocation');
    RegisterPropertyHelper(@TElementPatternValueNumber_R,@TElementPatternValueNumber_W,'PatternValueNumber');
    RegisterPropertyHelper(@TElementValueCount_R,@TElementValueCount_W,'ValueCount');
    RegisterPropertyHelper(@TElementValueType_R,@TElementValueType_W,'ValueType');
    RegisterPropertyHelper(@TElementTag_R,@TElementTag_W,'Tag');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TOCRExpression(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TOCRExpression) do
  begin
    RegisterMethod(@TOCRExpression.RecognizedValue, 'RecognizedValue');
    RegisterPropertyHelper(@TOCRExpressionLeftPxPos_R,nil,'LeftPxPos');
    RegisterPropertyHelper(@TOCRExpressionTopPxPos_R,nil,'TopPxPos');
    RegisterPropertyHelper(@TOCRExpressionRightPxPos_R,nil,'RightPxPos');
    RegisterPropertyHelper(@TOCRExpressionBottomPxPos_R,nil,'BottomPxPos');
    RegisterPropertyHelper(@TOCRExpressionValue_R,@TOCRExpressionValue_W,'Value');
    RegisterPropertyHelper(@TOCRExpressionPageNumber_R,nil,'PageNumber');
    RegisterPropertyHelper(@TOCRExpressionDERValue_R,nil,'DERValue');
    RegisterPropertyHelper(@TOCRExpressionAssociatedElementIndex_R,@TOCRExpressionAssociatedElementIndex_W,'AssociatedElementIndex');
    RegisterPropertyHelper(@TOCRExpressionAssociatedElementKeywordIndex_R,@TOCRExpressionAssociatedElementKeywordIndex_W,'AssociatedElementKeywordIndex');
    RegisterPropertyHelper(@TOCRExpressionAssociatedExpressionKeywordIndex_R,@TOCRExpressionAssociatedExpressionKeywordIndex_W,'AssociatedExpressionKeywordIndex');
    RegisterPropertyHelper(@TOCRExpressionOCRConfidence_R,@TOCRExpressionOCRConfidence_W,'OCRConfidence');
    RegisterPropertyHelper(@TOCRExpressionRecognizedType_R,@TOCRExpressionRecognizedType_W,'RecognizedType');
    RegisterPropertyHelper(@TOCRExpressionRecognizedDate_R,@TOCRExpressionRecognizedDate_W,'RecognizedDate');
    RegisterPropertyHelper(@TOCRExpressionRecognizedMoney_R,@TOCRExpressionRecognizedMoney_W,'RecognizedMoney');
    RegisterPropertyHelper(@TOCRExpressionRecognizedWebsite_R,@TOCRExpressionRecognizedWebsite_W,'RecognizedWebsite');
    RegisterPropertyHelper(@TOCRExpressionRecognizedWebMail_R,@TOCRExpressionRecognizedWebMail_W,'RecognizedWebMail');
    RegisterPropertyHelper(@TOCRExpressionRecognizedPercentage_R,@TOCRExpressionRecognizedPercentage_W,'RecognizedPercentage');
    RegisterPropertyHelper(@TOCRExpressionRecognizedFloat_R,@TOCRExpressionRecognizedFloat_W,'RecognizedFloat');
    RegisterPropertyHelper(@TOCRExpressionRecognizedInteger_R,@TOCRExpressionRecognizedInteger_W,'RecognizedInteger');
    RegisterPropertyHelper(@TOCRExpressionRecognizedNumbers_R,@TOCRExpressionRecognizedNumbers_W,'RecognizedNumbers');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_cyDocER(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TcyDocER) do
  RIRegister_TOCRExpression(CL);
  RIRegister_TElement(CL);
  RIRegister_TElements(CL);
  RIRegister_TcyDocER(CL);
end;

 
 
{ TPSImport_cyDocER }
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDocER.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_cyDocER(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_cyDocER.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_cyDocER(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
