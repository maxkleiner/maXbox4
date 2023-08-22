object RCMainForm: TRCMainForm
  Left = 223
  Top = 151
  Caption = 'Resource Explorer maXbox Edition'
  ClientHeight = 495
  ClientWidth = 831
  Color = clBtnFace
  ParentFont = True
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000888
    888888888888888888888888000008F7777777777777777777777778800008F7
    FFFFFFFFFFFFFFFFFFFFF778880008F7888888888888888888888778880008F7
    FFFFFFFFFFFFFFFFFFFFF778880008F7888888888888888888888778880008F7
    777777777777777777777778880008F7222777777777777777777778880008F7
    AAA777777777777777777778880008FFFFFFFF00000000000000000008000087
    7777778777777777777777770800000877777787FFFF8FFFFFFFFFF708000000
    88888887FFFF8FFFFFFFFFF70800000000000087F18F8FFFFFFFFFF700000000
    00000087FFFF8FFFFFFFFFF70000000000000087F18F8F88F88F88F700000000
    00000087FFFF8F88F88F88F70000000000000087F18F8FFFFFFFFFF700000000
    00000087FFFF8F88F88F88F70000000000000087F18F8F88F88F88F700000000
    00000087FFFF8FFFFFFFFFF70000000000000087777777777777777700000000
    0000008766666666600000070000000000000087666666666F0F0F0700000000
    0000008777777777777777770000000000000088888888888888888800000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFC000000F800000078000000380000001800000018000
    00018000000180000001800000018000000180000001C0000001E0000001F000
    0003FFC00007FFC00007FFC00007FFC00007FFC00007FFC00007FFC00007FFC0
    0007FFC00007FFC00007FFC00007FFC00007FFC00007FFFFFFFFFFFFFFFF}
  Menu = MainMenu
  OldCreateOrder = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 476
    Width = 831
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 500
      end>
  end
  object TreeViewPanel: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 476
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 21
      Align = alTop
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = ' Resources'
      TabOrder = 0
    end
    object TreeView: TTreeView
      Left = 0
      Top = 21
      Width = 185
      Height = 455
      Align = alClient
      Images = Small
      Indent = 19
      ReadOnly = True
      TabOrder = 1
      OnChange = TreeViewChange
    end
  end
  object Splitter: TPanel
    Left = 185
    Top = 0
    Width = 2
    Height = 476
    Cursor = crHSplit
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    OnMouseDown = SplitterMouseDown
    OnMouseMove = SplitterMouseMove
    OnMouseUp = SplitterMouseUp
  end
  object ListViewPanel: TPanel
    Left = 187
    Top = 0
    Width = 644
    Height = 476
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object ListViewCaption: TPanel
      Left = 0
      Top = 0
      Width = 644
      Height = 21
      Align = alTop
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderWidth = 1
      TabOrder = 0
    end
    object Notebook: TNotebook
      Left = 0
      Top = 21
      Width = 644
      Height = 455
      Align = alClient
      Color = clBtnFace
      PageIndex = 1
      ParentColor = False
      TabOrder = 1
      OnEnter = NotebookEnter
      object TPage
        Left = 0
        Top = 0
        Caption = 'ListViewPage'
        object ListView: TListView
          Left = 0
          Top = 0
          Width = 644
          Height = 455
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 150
            end
            item
              Caption = 'Offset'
              Width = 80
            end
            item
              Caption = 'Size'
              Width = 80
            end>
          ColumnClick = False
          LargeImages = Large
          ReadOnly = True
          SmallImages = Small
          TabOrder = 0
          ViewStyle = vsReport
          OnEnter = ListViewEnter
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'ImageViewPage'
        object ImageViewer: TImage
          Left = 0
          Top = 0
          Width = 644
          Height = 455
          Align = alClient
          Center = True
          ExplicitWidth = 382
          ExplicitHeight = 174
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'StringViewPage'
        object StringViewer: TMemo
          Left = 0
          Top = 0
          Width = 644
          Height = 455
          Align = alClient
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 0
          WantReturns = False
          WordWrap = False
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'OtherViewPage'
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 530
    Top = 161
    object miFile: TMenuItem
      Caption = '&File'
      object miFileOpen: TMenuItem
        Caption = '&Open...'
        OnClick = FileOpen
      end
      object OpenmaXbox1: TMenuItem
        Caption = 'Open maXbox'
        OnClick = OpenmaXbox1Click
      end
      object miFileSave: TMenuItem
        Caption = '&Save Resource...'
        OnClick = SaveResource
      end
      object miN1: TMenuItem
        Caption = '-'
      end
      object miFileExit: TMenuItem
        Caption = 'E&xit'
        OnClick = FileExit
      end
    end
    object miView: TMenuItem
      Caption = '&View'
      OnClick = ViewMenuDropDown
      object miViewStatusBar: TMenuItem
        Caption = 'Status &Bar'
        OnClick = ToggleStatusBar
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object miViewLargeIcons: TMenuItem
        Caption = 'Lar&ge Icons'
        GroupIndex = 1
        RadioItem = True
        OnClick = SelectListViewType
      end
      object miViewSmallIcons: TMenuItem
        Tag = 1
        Caption = 'S&mall Icons'
        GroupIndex = 1
        RadioItem = True
        OnClick = SelectListViewType
      end
      object miViewList: TMenuItem
        Tag = 2
        Caption = '&List'
        GroupIndex = 1
        RadioItem = True
        OnClick = SelectListViewType
      end
      object miViewDetails: TMenuItem
        Tag = 3
        Caption = '&Details'
        GroupIndex = 1
        RadioItem = True
        OnClick = SelectListViewType
      end
      object OnlyText1: TMenuItem
        AutoCheck = True
        Caption = 'Only Text'
        GroupIndex = 1
        OnClick = OnlyText1Click
      end
    end
    object miHelp: TMenuItem
      Caption = '&Help'
      object miHelpAbout: TMenuItem
        Caption = '&About'
        OnClick = ShowAboutBox
      end
    end
  end
  object FileOpenDialog: TOpenDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]
    Left = 497
    Top = 161
  end
  object FileSaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]
    Left = 463
    Top = 161
  end
  object Small: TImageList
    Left = 384
    Top = 161
  end
  object Large: TImageList
    Height = 32
    Width = 32
    Left = 417
    Top = 161
  end
end
