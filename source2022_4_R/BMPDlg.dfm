object NewBMPForm: TNewBMPForm
  Left = 253
  Top = 114
  ActiveControl = OKBtn
  BorderStyle = bsDialog
  Caption = 'Bitmap Dimensions'
  ClientHeight = 120
  ClientWidth = 233
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 217
    Height = 65
    Shape = bsFrame
    IsControl = True
  end
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 23
    Height = 11
    Caption = '&Width'
    FocusControl = WidthEdit
  end
  object Label2: TLabel
    Left = 24
    Top = 48
    Width = 26
    Height = 11
    Caption = '&Height'
    FocusControl = HeightEdit
  end
  object OKBtn: TButton
    Left = 32
    Top = 84
    Width = 77
    Height = 27
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 116
    Top = 84
    Width = 77
    Height = 27
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object WidthEdit: TEdit
    Left = 88
    Top = 12
    Width = 121
    Height = 24
    TabOrder = 2
  end
  object HeightEdit: TEdit
    Left = 88
    Top = 44
    Width = 121
    Height = 24
    TabOrder = 3
  end
end
