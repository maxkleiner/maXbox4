object JvErrorDialog: TJvErrorDialog
  Left = 2
  Top = 100
  ActiveControl = OKBtn
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 285
  ClientWidth = 595
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BasicPanel: TPanel
    Left = 0
    Top = 0
    Width = 503
    Height = 141
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 288
    ExplicitHeight = 108
    object ErrorText: TLabel
      Left = 53
      Top = 10
      Width = 442
      Height = 121
      Align = alClient
      WordWrap = True
      ExplicitWidth = 3
      ExplicitHeight = 13
    end
    object IconPanel: TPanel
      Left = 0
      Top = 10
      Width = 53
      Height = 121
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 88
      object IconImage: TImage
        Left = 8
        Top = 1
        Width = 34
        Height = 34
      end
    end
    object TopPanel: TPanel
      Left = 0
      Top = 0
      Width = 503
      Height = 10
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 288
    end
    object RightPanel: TPanel
      Left = 495
      Top = 10
      Width = 8
      Height = 121
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitLeft = 280
      ExplicitHeight = 88
    end
    object BottomPanel: TPanel
      Left = 0
      Top = 131
      Width = 503
      Height = 10
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      ExplicitTop = 98
      ExplicitWidth = 288
    end
  end
  object DetailsPanel: TPanel
    Left = 0
    Top = 141
    Width = 595
    Height = 144
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvLowered
    TabOrder = 2
    ExplicitTop = 108
    ExplicitWidth = 3
    object AddrLabel: TLabel
      Left = 53
      Top = 11
      Width = 121
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Error address: '
      Transparent = True
    end
    object TypeLabel: TLabel
      Left = 53
      Top = 30
      Width = 121
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Error Type: '
      Transparent = True
    end
    object MessageText: TMemo
      Left = 7
      Top = 53
      Width = 366
      Height = 84
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
    end
    object ErrorAddress: TEdit
      Left = 180
      Top = 8
      Width = 192
      Height = 21
      TabStop = False
      ParentColor = True
      ReadOnly = True
      TabOrder = 1
    end
    object ErrorType: TEdit
      Left = 180
      Top = 27
      Width = 192
      Height = 21
      TabStop = False
      ParentColor = True
      ReadOnly = True
      TabOrder = 2
    end
  end
  object ButtonPanel: TPanel
    Left = 503
    Top = 0
    Width = 92
    Height = 141
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = -89
    ExplicitHeight = 108
    object DetailsBtn: TButton
      Left = 7
      Top = 65
      Width = 79
      Height = 25
      TabOrder = 1
      OnClick = DetailsBtnClick
    end
    object OKBtn: TButton
      Left = 7
      Top = 12
      Width = 79
      Height = 25
      Cancel = True
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
end
