object YearGridEditForm: TYearGridEditForm
  Left = 303
  Top = 154
  BorderStyle = bsDialog
  Caption = 'YearGrid Edit'
  ClientHeight = 380
  ClientWidth = 378
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 336
    Width = 378
    Height = 44
    Align = alBottom
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 203
      Top = 7
      Width = 76
      Height = 30
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 289
      Top = 7
      Width = 76
      Height = 30
      TabOrder = 1
      Kind = bkCancel
    end
    object BtnLoad: TButton
      Left = 5
      Top = 7
      Width = 63
      Height = 30
      Caption = '&Load...'
      TabOrder = 2
      OnClick = BtnLoadClick
    end
    object BtnSave: TButton
      Left = 78
      Top = 7
      Width = 63
      Height = 30
      Caption = '&Save...'
      TabOrder = 3
      OnClick = BtnSaveClick
    end
  end
  object MemoText: TMemo
    Left = 0
    Top = 0
    Width = 378
    Height = 336
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 313
    ExplicitHeight = 331
  end
  object OpenDialog: TOpenDialog
    Filter = 'Text Files|*.txt|All Files|*.*'
    Left = 88
    Top = 104
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text Files|*.txt|All Files|*.*'
    Left = 120
    Top = 104
  end
end
