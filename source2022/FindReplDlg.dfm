object FindReplDialog: TFindReplDialog
  Left = 396
  Top = 234
  BorderStyle = bsDialog
  Caption = 'Search and replace text'
  ClientHeight = 326
  ClientWidth = 403
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlSearch: TPanel
    Left = 0
    Top = 5
    Width = 366
    Height = 31
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 8
      Width = 54
      Height = 13
      Caption = 'Search for:'
    end
    object cbxSearch: TComboBox
      Left = 85
      Top = 5
      Width = 276
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbxSearchChange
      OnExit = cbxSearchExit
      OnKeyDown = cbxSearchKeyDown
    end
  end
  object pnlControls: TPanel
    Left = 0
    Top = 104
    Width = 399
    Height = 210
    Align = alCustom
    BevelOuter = bvNone
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 5
      Top = 5
      Width = 176
      Height = 61
      Caption = 'Options'
      TabOrder = 0
      object cbCase: TCheckBox
        Left = 15
        Top = 17
        Width = 146
        Height = 17
        Caption = 'Case sensitive'
        TabOrder = 0
        OnClick = cbCaseClick
      end
      object cbWord: TCheckBox
        Left = 15
        Top = 37
        Width = 146
        Height = 17
        Caption = 'Whole word only'
        TabOrder = 1
        OnClick = cbWordClick
      end
    end
    object rgpStart: TRadioGroup
      Left = 185
      Top = 70
      Width = 176
      Height = 61
      Caption = 'Origin'
      ItemIndex = 0
      Items.Strings = (
        '&From Cursor'
        '&Entire scope')
      TabOrder = 3
      OnClick = rgpStartClick
    end
    object rgpDirection: TRadioGroup
      Left = 185
      Top = 5
      Width = 176
      Height = 61
      Caption = 'Direction'
      ItemIndex = 0
      Items.Strings = (
        '&Forward'
        '&Backward')
      TabOrder = 2
      OnClick = rgpDirectionClick
    end
    object rgpRange: TRadioGroup
      Left = 5
      Top = 70
      Width = 176
      Height = 61
      Caption = 'Scope'
      ItemIndex = 0
      Items.Strings = (
        '&Global'
        '&Selected text')
      TabOrder = 1
      OnClick = rgpRangeClick
    end
    object CancelBtn: TButton
      Left = 274
      Top = 140
      Width = 86
      Height = 26
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 6
      OnClick = CancelBtnClick
    end
    object btnSearch: TButton
      Left = 185
      Top = 140
      Width = 86
      Height = 26
      Caption = 'Searc&h'
      TabOrder = 4
      OnClick = btnSearchClick
    end
    object btnReplAll: TButton
      Left = 5
      Top = 141
      Width = 86
      Height = 25
      Caption = 'Replace all'
      TabOrder = 7
      OnClick = btnReplAllClick
    end
    object btnRepeat: TButton
      Left = 95
      Top = 140
      Width = 86
      Height = 26
      Caption = 'Continue search'
      TabOrder = 5
      OnClick = btnRepeatClick
    end
  end
  object pnlReplace: TPanel
    Left = 0
    Top = 40
    Width = 366
    Height = 51
    BevelOuter = bvNone
    TabOrder = 1
    object Label2: TLabel
      Left = 5
      Top = 8
      Width = 57
      Height = 13
      Caption = 'Replace by:'
    end
    object cbxReplace: TComboBox
      Left = 85
      Top = 5
      Width = 276
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
    object cbConfirm: TCheckBox
      Left = 85
      Top = 34
      Width = 122
      Height = 17
      Caption = 'Prompt on replace'
      TabOrder = 1
      OnClick = cbConfirmClick
    end
  end
end
