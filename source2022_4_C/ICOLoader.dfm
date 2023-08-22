object IconSelectionForm: TIconSelectionForm
  Left = 388
  Top = 522
  BorderStyle = bsDialog
  Caption = 'Select icon to import from file'
  ClientHeight = 169
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    296
    169)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 152
    Width = 279
    Height = 13
    Caption = 'Note that writing of files with multiple icons is not supported.'
  end
  object ColorLabel: TLabel
    Left = 157
    Top = 125
    Width = 50
    Height = 13
    Caption = 'ColorLabel'
  end
  object OkButton: TButton
    Left = 213
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelButton: TButton
    Left = 213
    Top = 44
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object SelectBox: TComboBox
    Left = 8
    Top = 8
    Width = 193
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    OnChange = SelectBoxChange
  end
  object PanelFrame: TDoubleBufferedPanel
    Left = 8
    Top = 40
    Width = 193
    Height = 73
    BevelOuter = bvLowered
    UseDockManager = False
    TabOrder = 3
  end
  object TransparentButton: TButton
    Left = 8
    Top = 120
    Width = 113
    Height = 25
    Caption = 'Transparent color'
    TabOrder = 4
    OnClick = TransparentButtonClick
  end
  object ColorPanel: TPanel
    Left = 128
    Top = 120
    Width = 25
    Height = 25
    BevelOuter = bvLowered
    TabOrder = 5
    OnClick = TransparentButtonClick
  end
  object ColorDialog: TColorDialog
    Color = clFuchsia
    CustomColors.Strings = (
      'ColorA=fe00ff')
    Options = [cdFullOpen, cdAnyColor]
    Left = 212
    Top = 116
  end
end
