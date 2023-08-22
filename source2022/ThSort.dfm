object ThreadSortForm: TThreadSortForm
  Left = 212
  Top = 110
  BorderStyle = bsDialog
  Caption = 'Thread Sorting Demo Rosenheim'
  ClientHeight = 436
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 24
    Width = 177
    Height = 345
  end
  object Bevel3: TBevel
    Left = 377
    Top = 24
    Width = 177
    Height = 345
  end
  object Bevel2: TBevel
    Left = 192
    Top = 24
    Width = 177
    Height = 345
  end
  object BubbleSortBox: TPaintBox
    Left = 8
    Top = 24
    Width = 177
    Height = 364
    OnPaint = BubbleSortBoxPaint
  end
  object SelectionSortBox: TPaintBox
    Left = 192
    Top = 24
    Width = 177
    Height = 364
    OnPaint = SelectionSortBoxPaint
  end
  object QuickSortBox: TPaintBox
    Left = 377
    Top = 24
    Width = 177
    Height = 364
    OnPaint = QuickSortBoxPaint
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 55
    Height = 13
    Caption = 'Bubble Sort'
  end
  object Label2: TLabel
    Left = 192
    Top = 8
    Width = 66
    Height = 13
    Caption = 'Selection Sort'
  end
  object Label3: TLabel
    Left = 376
    Top = 8
    Width = 50
    Height = 13
    Caption = 'Quick Sort'
  end
  object StartBtn: TButton
    Left = 453
    Top = 403
    Width = 100
    Height = 26
    Caption = 'Start Sorting!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clPurple
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = StartBtnClick
  end
  object BitBtn1slowmotion: TBitBtn
    Left = 332
    Top = 403
    Width = 100
    Height = 26
    Caption = '&slow motion'
    TabOrder = 1
    OnClick = BitBtn1slowmotionClick
    Kind = bkRetry
  end
end
