object Form2: TForm2
  Left = -4
  Top = -4
  Width = 1032
  Height = 776
  Caption = 'Spectrum of last captured frame'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SaveBothBtn: TButton
    Left = 16
    Top = 336
    Width = 121
    Height = 25
    Caption = 'Save Both'
    TabOrder = 0
    OnClick = SaveBothBtnClick
  end
  object SaveTimeBtn: TButton
    Left = 16
    Top = 304
    Width = 121
    Height = 25
    Caption = 'Save Time Data'
    TabOrder = 1
    OnClick = SaveTimeBtnClick
  end
  object SaveFreqBtn: TButton
    Left = 16
    Top = 272
    Width = 121
    Height = 25
    Caption = 'Save Freq Data'
    TabOrder = 2
    OnClick = SaveFreqBtnClick
  end
  object CloseBtn: TBitBtn
    Left = 16
    Top = 384
    Width = 121
    Height = 25
    TabOrder = 3
    Kind = bkClose
  end
  object PageControl1: TPageControl
    Left = 152
    Top = 16
    Width = 633
    Height = 401
    ActivePage = TabSheet2
    TabOrder = 4
    object TabSheet1: TTabSheet
      Caption = 'List'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 457
        Height = 373
        Align = alClient
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Spectrum Graph'
      ImageIndex = 1
      object YTopLbl: TLabel
        Left = 14
        Top = 16
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = 'x.xx'
      end
      object YMidLbl: TLabel
        Left = 14
        Top = 144
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = 'x.xx'
      end
      object YBotLbl: TLabel
        Left = 14
        Top = 272
        Width = 20
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = '0.0'
      end
      object ScrollBox1: TScrollBox
        Left = 48
        Top = 0
        Width = 512
        Height = 337
        VertScrollBar.Visible = False
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 288
          Width = 15
          Height = 13
          Caption = '0.0'
          Visible = False
        end
        object FreqLbl: TLabel
          Left = 120
          Top = 160
          Width = 90
          Height = 13
          Caption = 'Freq: 0.0, Amp: 0.0'
          Visible = False
        end
        object Image2: TImage
          Left = 0
          Top = 0
          Width = 508
          Height = 281
        end
      end
      object StaticText1: TStaticText
        Left = 48
        Top = 344
        Width = 402
        Height = 17
        Caption = 
          'Scroll to see complete frequency range.  Move cursor over chart ' +
          'lines to see details  '
        TabOrder = 1
      end
    end
  end
  object StaticText2: TStaticText
    Left = 0
    Top = 718
    Width = 1024
    Height = 20
    Cursor = crHelp
    Align = alBottom
    Alignment = taCenter
    BorderStyle = sbsSunken
    Caption = 'Copyright  © 2002-2004, Gary Darby,   www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText2Click
  end
  object DCBox: TCheckBox
    Left = 16
    Top = 192
    Width = 113
    Height = 17
    Caption = 'Remove DC component'
    TabOrder = 6
    OnClick = DCBoxClick
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 360
    Top = 65528
  end
end
