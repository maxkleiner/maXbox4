object ViewToDoForm: TViewToDoForm
  Left = 192
  Top = 107
  BorderStyle = bsSizeToolWin
  Caption = 'To-Do list'
  ClientHeight = 504
  ClientWidth = 987
  Color = clBtnFace
  Constraints.MinHeight = 136
  Constraints.MinWidth = 394
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    987
    504)
  PixelsPerInch = 96
  TextHeight = 13
  object lblFilter: TLabel
    Left = 8
    Top = 463
    Width = 25
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Filter:'
    ExplicitTop = 172
  end
  object lv: TListView
    Left = 0
    Top = 0
    Width = 986
    Height = 452
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        Caption = 'Done'
      end
      item
        Caption = 'Prio'
        Width = 40
      end
      item
        Caption = 'Description'
        Width = 460
      end
      item
        Caption = 'Filename'
        Width = 300
      end
      item
        Caption = 'User'
        Width = 100
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    SortType = stBoth
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = lvColumnClick
    OnCompare = lvCompare
    OnCustomDrawItem = lvCustomDrawItem
    OnCustomDrawSubItem = lvCustomDrawSubItem
    OnDblClick = lvDblClick
    OnMouseDown = lvMouseDown
    ExplicitHeight = 439
  end
  object btnClose: TButton
    Left = 861
    Top = 467
    Width = 112
    Height = 29
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Close'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object chkNoDone: TCheckBox
    Left = 8
    Top = 483
    Width = 289
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Don'#39't show items marked as done'
    TabOrder = 2
    OnClick = chkNoDoneClick
    ExplicitTop = 470
  end
  object cmbFilter: TComboBox
    Left = 236
    Top = 467
    Width = 477
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akBottom]
    ItemHeight = 13
    TabOrder = 3
    OnChange = cmbFilterChange
    Items.Strings = (
      'All files (in project and not)'
      'Open files only (in project and not)'
      'All project files'
      'Open project files only'
      'Non-project open files'
      'Current file only')
  end
end
