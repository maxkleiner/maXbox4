{
//
// Components : InfoPower types
//
// Copyright (c) 1998-2001 by Woll2Woll Software
//
}
unit Wwtypes;

interface
//{$i wwIfDef.pas}

  uses classes, db, forms, stdctrls, dbtables;

const wwNewLineString='<New Line>';
type
  TwwInvalidValueEvent = Procedure(DataSet: TDataSet; Field: TField) of object;
  TwwFilterFieldMethod =  Function(AFieldName: string): TParam of object;
  TwwDataSetFilterEvent = Procedure(table: TDataSet; var Accept: boolean) of object;
  TwwPerformSearchEvent = procedure(Sender: TObject;
     LookupTable: TDataSet;
     SearchField: string;
     SearchValue: string;
     PerformLookup: boolean;
     var Found: boolean) of object;
  TwwGetWordOption = (wwgwSkipLeadingBlanks, wwgwQuotesAsWords, wwgwStripQuotes,
                      wwgwSpacesInWords);
  TwwWriteTextOption = (wtoAmpersandToUnderline, wtoEllipsis, wtoWordWrap,
                        wtoMergeCanvas, wtoTransparent, wtoCenterVert);
//                        ,
//                        wtoRightToLeft);

  TwwWriteTextOptions = Set of TwwWriteTextOption;
  TwwGetWordOptions = set of TwwGetWordOption;  {pwe}
  TwwEditAlignment = (eaLeftAlignEditing, eaRightAlignEditing);

  TwwFormPosition = class(TPersistent)
  private
     FLeft, FTop: integer;
     FWidth, FHeight: integer;
  published
     property Left: integer read FLeft write FLeft;
     property Top: integer read FTop write FTop;
     property Width: integer read FWidth write FWidth;
     property Height: integer read FHeight write FHeight;
  end;

  TwwCheatCastNotify = class(TComponent)
  public
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  end;

  TwwCheatCastKeyDown = class(TCustomEdit)
  public
    procedure KeyDown(var key: word; shift: TShiftState); override;
  end;

  TwwOnFilterOption = (ofoEnabled, ofoShowHourGlass, ofoCancelOnEscape);
  TwwOnFilterOptions = set of TwwOnFilterOption;

{$ifndef wwDelphi3Up}
  TCustomForm = TForm;
{$endif}

  function wwFilterMemoSize: integer;

implementation

//uses wwintl;

function wwFilterMemoSize: integer;
begin
   //result:= wwInternational.FilterMemoSize;
end;

procedure TwwCheatCastNotify.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
   inherited Notification(AComponent, Operation);
end;

procedure TwwCheatCastKeyDown.KeyDown(var key: word; shift: TShiftState);
begin
   inherited KeyDown(Key, shift);
end;

end.
