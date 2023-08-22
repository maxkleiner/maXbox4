unit HyperLabel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  StdCtrls;

type
  THyperLabel = class(TCustomLabel)
  private
    FHyperLinkColor, FOldColor: TColor;
    FHyperLinkStyle, FOldStyle: TFontStyles;
    { Private declarations }
  protected
    procedure Click; override;
    procedure CMMouseEnter(var msg: TMessage);
              message cm_MouseEnter;
    procedure CMMouseLeave(var msg: TMessage);
              message cm_MouseLeave;
    { Protected declarations }
  public
    constructor create(aOwner: TComponent); override;
    { Public declarations }
  published
    { Published declarations }
    property HyperlinkColor: TColor
      read FHyperlinkColor write FHyperlinkColor
      default clBlue;
    property HyperlinkStyle: TFontStyles
      read FHyperlinkStyle write FHyperlinkStyle;
    property Caption;
    property Font;
    property ParentShowHint;
    property ShowHint;
    property OnClick;
   end;

procedure Register;


implementation

uses shellAPI, Forms;


  constructor THyperLabel.create(aOwner: TComponent);
  begin
    inherited create(aOwner);
    FHyperlinkColor:= clBlue;
    FHyperLinkStyle:= [fsUnderline];
    FOldColor:= Font.Color;
    FOldStyle:= Font.Style;
  end;

 procedure THyperLabel.click;
  var URLBuf: array[0..255] of char;
  begin
    inherited click;
    strPCopy(URLBuf, Caption);
    ShellExecute(Application.handle, NIL, URLBuf,
                  NIL, NIL, sw_ShowNormal)
  end;

 procedure THyperLabel.CMMouseEnter(var msg: TMessage);
 begin
   inherited;
   FOldStyle:= Font.Style;
   FOldColor:= Font.Color;
   Font.Style:= FHyperLinkStyle;
   Font.Color:= FHyperLinkColor;
 end;

 procedure THyperLabel.cmMouseLeave(var msg: TMessage);
 begin
   inherited;
   Font.Style:= FOldStyle;
   Font.color:= FOldColor;
 end;

procedure Register;
begin
  RegisterComponents('MixMax', [THyperLabel]);
end;

end.
