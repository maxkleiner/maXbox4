object JvQueryParamsDialog: TJvQueryParamsDialog
  Left = 210
  Top = 119
  ActiveControl = ParamList
  BorderIcons = [biSystemMenu]
  Caption = 'mX Query parameters'
  ClientHeight = 339
  ClientWidth = 583
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100001001000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    00000000000000000BBBB0000000000BB000BB000000000BB0000B000000000B
    BB000BB00000000BBB000BB00000000000000BB00000000000000BB000000000
    00000BB00000000000000BB00000000000000BB00000000000000BB000000000
    00000BB0000000000000BBBB00000000000BBBBBB0000000000000000000FFFF
    0000F87F0000E73F0000E7BF0000E39F0000E39F0000FF9F0000FF9F0000FF9F
    0000FF9F0000FF9F0000FF9F0000FF9F0000FF0F0000FE070000FFFF0000}
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    583
    339)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 9
    Top = 3
    Width = 557
    Height = 269
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Define Parameters'
    TabOrder = 0
    ExplicitWidth = 328
    ExplicitHeight = 109
    DesignSize = (
      557
      269)
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 80
      Height = 13
      Caption = '&Parameter name:'
      FocusControl = ParamList
    end
    object Label2: TLabel
      Left = 364
      Top = 66
      Width = 30
      Height = 13
      Anchors = [akTop, akRight]
      Caption = '&Value:'
      FocusControl = ParamValue
      ExplicitLeft = 135
    end
    object Label3: TLabel
      Left = 364
      Top = 40
      Width = 49
      Height = 13
      Anchors = [akTop, akRight]
      Caption = '&Data type:'
      FocusControl = TypeList
      ExplicitLeft = 135
    end
    object ParamValue: TEdit
      Left = 429
      Top = 62
      Width = 121
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 2
      OnExit = ParamValueExit
      ExplicitLeft = 200
    end
    object NullValue: TCheckBox
      Left = 364
      Top = 112
      Width = 82
      Height = 17
      Anchors = [akTop, akRight]
      Caption = '&Null Value'
      TabOrder = 3
      OnClick = NullValueClick
      ExplicitLeft = 135
    end
    object TypeList: TComboBox
      Left = 429
      Top = 36
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
      OnChange = TypeListChange
      ExplicitLeft = 200
    end
    object ParamList: TListBox
      Left = 8
      Top = 36
      Width = 342
      Height = 219
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
      OnClick = ParamListChange
      ExplicitWidth = 113
      ExplicitHeight = 59
    end
  end
  object OkBtn: TButton
    Left = 46
    Top = 279
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = OkBtnClick
    ExplicitTop = 119
  end
  object CancelBtn: TButton
    Left = 139
    Top = 279
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    ExplicitTop = 119
  end
  object HelpBtn: TButton
    Left = 491
    Top = 279
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Help'
    TabOrder = 3
    OnClick = HelpBtnClick
    ExplicitLeft = 262
    ExplicitTop = 119
  end
end
