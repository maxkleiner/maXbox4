object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'FlowPanel Demo Application'
  ClientHeight = 273
  ClientWidth = 392
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 392
    Height = 45
    Align = alTop
    TabOrder = 0
    DesignSize = (
      392
      45)
    object Label1: TLabel
      Left = 16
      Top = 14
      Width = 53
      Height = 13
      Caption = '&Flow Style:'
      FocusControl = cboxFlowStyle
    end
    object bExit: TButton
      Left = 307
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Exit'
      TabOrder = 0
      OnClick = bExitClick
    end
    object cboxFlowStyle: TComboBox
      Left = 75
      Top = 12
      Width = 166
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = cboxFlowStyleChange
    end
  end
  object FlowPanel1: TFlowPanel
    Left = 0
    Top = 45
    Width = 392
    Height = 155
    Align = alClient
    Caption = 'FlowPanel1'
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 200
    Width = 392
    Height = 73
    Align = alBottom
    TabOrder = 2
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 390
      Height = 71
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'Select your FlowStyle and resize the form to see how the differe' +
        'nt flowstyles effect the creation of the controls. Note the cont' +
        'rols created do not have their Top and Left positions set.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
      ExplicitTop = 6
      ExplicitWidth = 465
      ExplicitHeight = 50
    end
  end
  object XPManifest1: TXPManifest
    Left = 184
    Top = 136
  end
end
