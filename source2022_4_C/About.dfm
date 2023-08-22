object RCAboutBox: TRCAboutBox
  Left = 226
  Top = 173
  BorderStyle = bsDialog
  ClientHeight = 153
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OKButton: TButton
    Left = 113
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 2
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 12
    Width = 285
    Height = 97
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object ProgramIcon: TImage
      Left = 8
      Top = 12
      Width = 32
      Height = 32
      AutoSize = True
      IsControl = True
    end
    object ProgramName: TLabel
      Left = 44
      Top = 22
      Width = 197
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Program Name'
    end
    object Copyright: TLabel
      Left = 8
      Top = 72
      Width = 269
      Height = 13
      Alignment = taCenter
      AutoSize = False
    end
  end
end
