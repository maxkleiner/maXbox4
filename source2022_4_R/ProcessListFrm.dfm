object ProcessListForm: TProcessListForm
  Left = 413
  Top = 338
  BorderIcons = []
  Caption = 'mX Attach to process'
  ClientHeight = 145
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object OKBtn: TBitBtn
    Left = 246
    Top = 112
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object CancelBtn: TBitBtn
    Left = 326
    Top = 112
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 393
    Height = 94
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object MainLabel: TLabel
      Left = 16
      Top = 12
      Width = 3
      Height = 13
      WordWrap = True
    end
    object ProcessCombo: TComboBox
      Left = 16
      Top = 48
      Width = 361
      Height = 24
      Style = csDropDownList
      DropDownCount = 14
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 0
    end
  end
end
