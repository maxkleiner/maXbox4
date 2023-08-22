object ActionForm: TActionForm
  Left = 219
  Top = 84
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'mX4 Action Form Demo'
  ClientHeight = 663
  ClientWidth = 890
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  DesignSize = (
    890
    663)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 605
    Width = 197
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Below is a StatusBar with AutoHint = True'
  end
  object Label8: TLabel
    Left = 8
    Top = 5
    Width = 160
    Height = 13
    Caption = '(All of the menu items use actions)'
  end
  object Label11: TLabel
    Left = 21
    Top = 544
    Width = 259
    Height = 13
    Caption = 'Any control with a Blue caption is connected to actions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 644
    Width = 890
    Height = 19
    AutoHint = True
    Panels = <>
  end
  object Button3: TBitBtn
    Left = 320
    Top = 532
    Width = 75
    Height = 25
    Action = PreviousTab1
    Caption = '&Previous'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Button4: TBitBtn
    Left = 400
    Top = 532
    Width = 75
    Height = 25
    Action = NextTab1
    Caption = '&Next'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object PageControl2: TPageControl
    Left = 0
    Top = 32
    Width = 890
    Height = 479
    ActivePage = FormatTab
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    object FileTab: TTabSheet
      Caption = 'File'
      ImageIndex = 8
      object Label3: TLabel
        Left = 93
        Top = 10
        Width = 158
        Height = 13
        Caption = '(select File|Open and select a file)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Button9: TBitBtn
        Left = 6
        Top = 5
        Width = 75
        Height = 25
        Action = FileOpen1
        Caption = '&Open...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00000000000000
          0000008484000084840000848400008484000084840000848400008484000084
          84000084840000000000FF00FF00FF00FF00FF00FF00FF00FF000000000000FF
          FF00000000000084840000848400008484000084840000848400008484000084
          8400008484000084840000000000FF00FF00FF00FF00FF00FF0000000000FFFF
          FF0000FFFF000000000000848400008484000084840000848400008484000084
          840000848400008484000084840000000000FF00FF00FF00FF000000000000FF
          FF00FFFFFF0000FFFF0000000000008484000084840000848400008484000084
          84000084840000848400008484000084840000000000FF00FF0000000000FFFF
          FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
          00000000000000000000000000000000000000000000000000000000000000FF
          FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
          FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFF
          FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
          FF0000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000FF
          FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
          000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
          00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00000000000000000000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF000000000000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
          FF00FF00FF00FF00FF0000000000FF00FF0000000000FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
          00000000000000000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object Button10: TBitBtn
        Left = 6
        Top = 35
        Width = 75
        Height = 25
        Action = FilePrintSetup1
        Caption = 'Print Set&up...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object Memo1: TMemo
        Left = 89
        Top = 132
        Width = 366
        Height = 123
        Lines.Strings = (
          'Memo1')
        TabOrder = 2
      end
      object Button11: TBitBtn
        Left = 6
        Top = 132
        Width = 75
        Height = 25
        Action = FileSaveAs1
        Caption = 'Save &As...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF000000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF0000000000000000000000000000000000000000000000
          000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000000000848400008484000000000000000000000000000000
          0000C6C6C600000000000084840000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000000000848400008484000000000000000000000000000000
          0000C6C6C600000000000084840000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000000000848400008484000000000000000000000000000000
          000000000000000000000084840000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000000000848400008484000084840000848400008484000084
          840000848400008484000084840000000000FF00FF00FF00FF00000000000000
          0000FF00FF000000000000848400008484000000000000000000000000000000
          000000000000008484000084840000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00000000000084840000000000C6C6C600C6C6C600C6C6C600C6C6
          C600C6C6C600000000000084840000000000FF00FF0000000000FF00FF00FF00
          FF00FF00FF00000000000084840000000000C6C6C600C6C6C600C6C6C600C6C6
          C600C6C6C600000000000084840000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00000000000084840000000000C6C6C600C6C6C600C6C6C600C6C6
          C600C6C6C600000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00000000000084840000000000C6C6C600C6C6C600C6C6C600C6C6
          C600C6C6C60000000000C6C6C60000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
          0000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00FF0000000000FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000}
      end
      object Button12: TBitBtn
        Left = 134
        Top = 65
        Width = 75
        Height = 25
        Action = FileOpenWith1
        Caption = 'Open &With...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object LabeledEdit1: TLabeledEdit
        Left = 219
        Top = 67
        Width = 161
        Height = 21
        EditLabel.Width = 156
        EditLabel.Height = 13
        EditLabel.Caption = 'Specify a filename or leave blank'
        TabOrder = 5
      end
      object Button13: TBitBtn
        Left = 7
        Top = 65
        Width = 75
        Height = 25
        Action = FileRun1
        Caption = '&Run...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
    end
    object EditTab: TTabSheet
      Caption = 'Edit'
      ImageIndex = 4
      OnShow = EditTabShow
      object ToolBar3: TToolBar
        Left = 0
        Top = 0
        Width = 882
        Height = 40
        ButtonHeight = 36
        ButtonWidth = 51
        Caption = 'ToolBar3'
        Images = ImageList1
        ShowCaptions = True
        TabOrder = 0
        object ToolButton3: TToolButton
          Left = 0
          Top = 0
          Action = EditCut1
        end
        object ToolButton4: TToolButton
          Left = 51
          Top = 0
          Action = EditCopy1
        end
        object ToolButton9: TToolButton
          Left = 102
          Top = 0
          Action = EditPaste1
        end
        object ToolButton10: TToolButton
          Left = 153
          Top = 0
          Action = EditDelete1
        end
        object ToolButton13: TToolButton
          Left = 204
          Top = 0
          Action = EditUndo1
        end
        object ToolButton14: TToolButton
          Left = 255
          Top = 0
          Action = EditSelectAll1
        end
      end
      object Memo3: TMemo
        Left = 0
        Top = 57
        Width = 882
        Height = 394
        Align = alClient
        Lines.Strings = (
          'Memo3')
        TabOrder = 1
      end
      object StaticText2: TStaticText
        Left = 0
        Top = 40
        Width = 882
        Height = 17
        Align = alTop
        Caption = '(all of these buttons use actions)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object SearchTab: TTabSheet
      Caption = 'Search'
      ImageIndex = 5
      OnShow = SearchTabShow
      object ToolBar2: TToolBar
        Left = 0
        Top = 0
        Width = 882
        Height = 40
        ButtonHeight = 36
        ButtonWidth = 52
        Caption = 'ToolBar2'
        Images = ImageList1
        ShowCaptions = True
        TabOrder = 0
        object ToolButton18: TToolButton
          Left = 0
          Top = 0
          Action = SearchFind1
        end
        object ToolButton19: TToolButton
          Left = 52
          Top = 0
          Action = SearchFindNext1
        end
        object ToolButton20: TToolButton
          Left = 104
          Top = 0
          Action = SearchReplace1
        end
        object ToolButton21: TToolButton
          Left = 156
          Top = 0
          Action = SearchFindFirst1
        end
      end
      object Memo2: TMemo
        Left = 0
        Top = 57
        Width = 882
        Height = 394
        Align = alClient
        HideSelection = False
        Lines.Strings = (
          
            'Here is some sample text for testing the search and replace acti' +
            'ons.  Simply click one of the '
          'actions to find or replace text within the memo.')
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object StaticText3: TStaticText
        Left = 0
        Top = 40
        Width = 882
        Height = 17
        Align = alTop
        Caption = '(all of these buttons use actions)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object AutoCheckTab: TTabSheet
      Caption = 'AutoCheck'
      ImageIndex = 1
      object SpeedButton2: TSpeedButton
        Left = 241
        Top = 77
        Width = 101
        Height = 22
        Action = GroupAction2
        AllowAllUp = True
        GroupIndex = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpeedButton3: TSpeedButton
        Left = 242
        Top = 51
        Width = 100
        Height = 22
        Action = GroupAction1
        AllowAllUp = True
        GroupIndex = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 8
        Top = 243
        Width = 249
        Height = 13
        Caption = '(Active controls on this tab are connected to actions)'
      end
      object Label7: TLabel
        Left = 9
        Top = 51
        Width = 170
        Height = 102
        AutoSize = False
        Caption = 
          'The two checkboxes below are both connected to the same action a' +
          'nd illustrate the use of the AutoCheck property of actions.  Als' +
          'o notice the items on the AutoCheck menu stay in sync as well wi' +
          'thout writing any code.'
        WordWrap = True
      end
      object CheckBox2: TCheckBox
        Left = 25
        Top = 152
        Width = 124
        Height = 17
        Hint = 
          'When executed, it will automatically trigger checked state witho' +
          'ut user code'
        Action = AutoCheckAction
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object CheckBox1: TCheckBox
        Left = 25
        Top = 174
        Width = 124
        Height = 17
        Hint = 
          'When executed, it will automatically trigger checked state witho' +
          'ut user code'
        Action = AutoCheckAction
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object ToolBar4: TToolBar
        Left = 0
        Top = 0
        Width = 882
        Height = 36
        AutoSize = True
        ButtonHeight = 36
        ButtonWidth = 93
        Caption = 'ToolBar4'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Images = ImageList1
        ParentFont = False
        ShowCaptions = True
        TabOrder = 2
        object ToolButton15: TToolButton
          Left = 0
          Top = 0
          Action = AutoCheckAction
        end
        object ToolButton16: TToolButton
          Left = 93
          Top = 0
          Width = 8
          Caption = 'ToolButton16'
          ImageIndex = 0
          Style = tbsSeparator
        end
        object ToolButton17: TToolButton
          Left = 101
          Top = 0
          Action = GroupAction1
          Grouped = True
          Style = tbsCheck
        end
        object ToolButton22: TToolButton
          Left = 194
          Top = 0
          Action = GroupAction2
          Grouped = True
          Style = tbsCheck
        end
        object ToolButton23: TToolButton
          Left = 287
          Top = 0
          Action = GroupAction3
          Grouped = True
          Style = tbsCheck
        end
      end
      object RadioButton1: TRadioButton
        Left = 240
        Top = 107
        Width = 113
        Height = 17
        Action = GroupAction1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object RadioButton2: TRadioButton
        Left = 240
        Top = 126
        Width = 113
        Height = 17
        Action = GroupAction2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object RadioButton3: TRadioButton
        Left = 240
        Top = 145
        Width = 113
        Height = 17
        Action = GroupAction3
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
    end
    object ListTab: TTabSheet
      Caption = 'Static List'
      object Label4: TLabel
        Left = 14
        Top = 151
        Width = 63
        Height = 13
        Caption = 'ComboBoxEx'
      end
      object Label5: TLabel
        Left = 193
        Top = 145
        Width = 39
        Height = 13
        Caption = 'ListView'
      end
      object Label6: TLabel
        Left = 132
        Top = 112
        Width = 201
        Height = 29
        AutoSize = False
        Caption = 'The controls below are connected to same TStaticListAction'
        WordWrap = True
      end
      object ListView1: TListView
        Left = 190
        Top = 171
        Width = 339
        Height = 238
        Action = StaticListAction1
        Columns = <
          item
            Width = 122
          end>
        HideSelection = False
        RowSelect = True
        SmallImages = ImageList1
        TabOrder = 0
        ViewStyle = vsReport
      end
      object ComboBoxEx1: TComboBoxEx
        Left = 16
        Top = 169
        Width = 151
        Height = 22
        Action = StaticListAction1
        ItemHeight = 16
        TabOrder = 1
        Text = 'StaticListAction1'
        Images = ImageList1
      end
      object AddBtn: TBitBtn
        Left = 15
        Top = 10
        Width = 107
        Height = 25
        Action = AddAction
        Caption = '&Add Item'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object AddEdit: TEdit
        Left = 129
        Top = 12
        Width = 121
        Height = 21
        TabOrder = 3
        Text = 'New Item'
      end
      object DeleteBtn: TBitBtn
        Left = 15
        Top = 47
        Width = 107
        Height = 25
        Action = DeleteAction
        Caption = '&Delete Item at Index'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object DelEdit: TEdit
        Left = 129
        Top = 47
        Width = 121
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object Button5: TBitBtn
        Left = 15
        Top = 116
        Width = 107
        Height = 25
        Action = ClearAction
        Caption = '&Clear'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object IdxEdit: TEdit
        Left = 129
        Top = 83
        Width = 121
        Height = 21
        TabOrder = 7
        Text = '-1'
      end
      object Button6: TBitBtn
        Left = 15
        Top = 82
        Width = 107
        Height = 25
        Action = SetIndexAction
        Caption = 'Set &Index'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
      end
      object ActiveBtn: TBitBtn
        Left = 267
        Top = 10
        Width = 75
        Height = 25
        Action = ActiveAction
        Caption = 'Set InActive'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
      end
    end
    object DialogTab: TTabSheet
      Caption = 'Dialog'
      ImageIndex = 2
      object Image1: TImage
        Left = 0
        Top = 28
        Width = 882
        Height = 423
        Align = alClient
        Proportional = True
        ExplicitWidth = 462
        ExplicitHeight = 234
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 882
        Height = 28
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object SpeedButton1: TSpeedButton
          Left = 2
          Top = 2
          Width = 83
          Height = 22
          Action = ColorSelect1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Button2: TBitBtn
          Left = 93
          Top = 2
          Width = 83
          Height = 22
          Action = FontEdit1
          Caption = 'Se&lect Font...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object Button1: TBitBtn
          Left = 183
          Top = 2
          Width = 87
          Height = 22
          Action = OpenPicture1
          Caption = '&Open Picture...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
    end
    object FormatTab: TTabSheet
      Caption = 'Format'
      ImageIndex = 3
      object ToolBar1: TToolBar
        Left = 0
        Top = 0
        Width = 882
        Height = 36
        AutoSize = True
        ButtonHeight = 36
        ButtonWidth = 58
        Caption = 'ToolBar1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Images = ImageList1
        ParentFont = False
        ShowCaptions = True
        TabOrder = 0
        object ToolButton5: TToolButton
          Left = 0
          Top = 0
          Action = RichEditBold1
        end
        object ToolButton6: TToolButton
          Left = 58
          Top = 0
          Action = RichEditItalic1
        end
        object ToolButton7: TToolButton
          Left = 116
          Top = 0
          Action = RichEditStrikeOut1
        end
        object ToolButton8: TToolButton
          Left = 174
          Top = 0
          Action = RichEditUnderline1
        end
        object ToolButton11: TToolButton
          Left = 232
          Top = 0
          Action = RichEditBullets1
        end
        object ToolButton12: TToolButton
          Left = 290
          Top = 0
          Action = RichEditAlignLeft1
        end
        object ToolButton1: TToolButton
          Left = 348
          Top = 0
          Action = RichEditAlignCenter1
        end
        object ToolButton2: TToolButton
          Left = 406
          Top = 0
          Action = RichEditAlignRight1
        end
      end
      object RichEdit1: TRichEdit
        Left = 0
        Top = 53
        Width = 882
        Height = 398
        Align = alClient
        HideSelection = False
        Lines.Strings = (
          'RichEdit1')
        TabOrder = 1
      end
      object StaticText1: TStaticText
        Left = 0
        Top = 36
        Width = 882
        Height = 17
        Align = alTop
        Caption = '(all of these buttons use actions)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
    end
    object ListBoxTab: TTabSheet
      Caption = 'List'
      ImageIndex = 7
      object SpeedButton4: TSpeedButton
        Left = 212
        Top = 69
        Width = 90
        Height = 19
        Action = ListControlClearSelection1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpeedButton5: TSpeedButton
        Left = 212
        Top = 92
        Width = 90
        Height = 19
        Action = ListControlCopySelection1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpeedButton6: TSpeedButton
        Left = 212
        Top = 116
        Width = 90
        Height = 19
        Action = ListControlDeleteSelection1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpeedButton7: TSpeedButton
        Left = 212
        Top = 139
        Width = 90
        Height = 19
        Action = ListControlMoveSelection1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object SpeedButton8: TSpeedButton
        Left = 212
        Top = 163
        Width = 90
        Height = 19
        Action = ListControlSelectAll1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 20
        Top = 4
        Width = 298
        Height = 13
        Caption = 'These list actions work on listboxes, listviews and comboboxes.'
      end
      object ListBox1: TListBox
        Left = 18
        Top = 53
        Width = 146
        Height = 151
        ItemHeight = 13
        Items.Strings = (
          'one'
          'two'
          'three'
          'four'
          'five'
          'six'
          'seven'
          'eight'
          'nine'
          'ten')
        MultiSelect = True
        TabOrder = 0
      end
      object ListBox2: TListBox
        Left = 356
        Top = 53
        Width = 154
        Height = 151
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object ShortCutTab: TTabSheet
      Caption = 'ShortCuts'
      ImageIndex = 7
      object Label12: TLabel
        Left = 126
        Top = 41
        Width = 221
        Height = 13
        Caption = 'This action responds to the following shortcuts:'
      end
      object Label13: TLabel
        Left = 23
        Top = 139
        Width = 330
        Height = 30
        AutoSize = False
        Caption = 
          'Type a shortcut key and click the Add ShortCut button to add a n' +
          'ew shortcut to the ShortCutAction'
        FocusControl = HotKey1
        WordWrap = True
      end
      object Label14: TLabel
        Left = 17
        Top = 7
        Width = 321
        Height = 13
        Caption = 
          'This tab illustrates the new SecondaryShortCuts property of TAct' +
          'ion:'
      end
      object Button7: TBitBtn
        Left = 19
        Top = 59
        Width = 98
        Height = 25
        Action = ShortCutAction
        Caption = 'ShortCut Action'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object HotKey1: THotKey
        Left = 22
        Top = 174
        Width = 121
        Height = 19
        HotKey = 49217
        Modifiers = [hkCtrl, hkAlt]
        TabOrder = 1
      end
      object Button8: TBitBtn
        Left = 21
        Top = 200
        Width = 75
        Height = 25
        Action = AddShortCut
        Caption = 'Add ShortCut'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object ShortCutList: TListBox
        Left = 126
        Top = 58
        Width = 121
        Height = 69
        ItemHeight = 13
        TabOrder = 3
      end
    end
  end
  object ActionList1: TActionList
    Images = ImageList1
    Left = 425
    Top = 104
    object RichEditBold1: TRichEditBold
      Category = 'Format'
      AutoCheck = True
      Caption = '&Bold'
      Hint = 'Bold'
      ImageIndex = 0
      ShortCut = 16450
    end
    object RichEditItalic1: TRichEditItalic
      Category = 'Format'
      AutoCheck = True
      Caption = '&Italic'
      Hint = 'Italic'
      ImageIndex = 1
      ShortCut = 16457
    end
    object RichEditUnderline1: TRichEditUnderline
      Category = 'Format'
      AutoCheck = True
      Caption = '&Underline'
      Hint = 'Underline'
      ImageIndex = 2
      ShortCut = 16469
    end
    object RichEditStrikeOut1: TRichEditStrikeOut
      Category = 'Format'
      AutoCheck = True
      Caption = '&Strikeout'
      Hint = 'Strikeout'
      ImageIndex = 3
    end
    object RichEditBullets1: TRichEditBullets
      Category = 'Format'
      AutoCheck = True
      Caption = '&Bullets'
      Hint = 'Bullets|Inserts a bullet on the current line'
      ImageIndex = 4
    end
    object RichEditAlignLeft1: TRichEditAlignLeft
      Category = 'Format'
      AutoCheck = True
      Caption = 'Align &Left'
      Hint = 'Align Left|Aligns text at the left indent'
      ImageIndex = 5
    end
    object RichEditAlignRight1: TRichEditAlignRight
      Category = 'Format'
      AutoCheck = True
      Caption = 'Align &Right'
      Hint = 'Align Right|Aligns text at the right indent'
      ImageIndex = 6
    end
    object RichEditAlignCenter1: TRichEditAlignCenter
      Category = 'Format'
      AutoCheck = True
      Caption = '&Center'
      Hint = 'Center|Centers text between margins'
      ImageIndex = 7
    end
    object SearchFind1: TSearchFind
      Category = 'Search'
      Caption = '&Find...'
      Dialog.Options = [frDown, frFindNext, frHideUpDown]
      Enabled = False
      Hint = 'Find|Finds the specified text'
      ImageIndex = 8
      ShortCut = 16454
    end
    object SearchFindNext1: TSearchFindNext
      Category = 'Search'
      Caption = 'Find &Next'
      Enabled = False
      Hint = 'Find Next|Repeats the last find'
      ImageIndex = 9
      SearchFind = SearchFind1
      ShortCut = 114
    end
    object SearchReplace1: TSearchReplace
      Category = 'Search'
      Caption = '&Replace'
      Enabled = False
      Hint = 'Replace|Replaces specific text with different text'
      ImageIndex = 10
    end
    object SearchFindFirst1: TSearchFindFirst
      Category = 'Search'
      Caption = 'F&ind First'
      Enabled = False
      Hint = 'Find First|Finds the first occurrence of specified text'
    end
    object GroupAction1: TAction
      Category = 'AutoCheck'
      AutoCheck = True
      Caption = 'Grouped Action 1'
      GroupIndex = 1
      Hint = 
        'Grouped Action where only one action can be checked at any give ' +
        'time'
    end
    object GroupAction2: TAction
      Category = 'AutoCheck'
      AutoCheck = True
      Caption = 'Grouped Action 2'
      GroupIndex = 1
      Hint = 
        'Grouped Action where only one action can be checked at any give ' +
        'time'
    end
    object GroupAction3: TAction
      Category = 'AutoCheck'
      AutoCheck = True
      Caption = 'Grouped Action 3'
      GroupIndex = 1
      Hint = 
        'Grouped Action where only one action can be checked at any give ' +
        'time'
    end
    object AutoCheckAction: TAction
      Category = 'AutoCheck'
      AutoCheck = True
      Caption = 'AutoCheck Action'
      Hint = 
        'AutoCheck action: when it is executed it will automatically set ' +
        'it'#39's checked state without having to write any code'
    end
    object FileExit1: TFileExit
      Category = 'File'
      Caption = 'E&xit'
      Hint = 'Exit|Quits the application'
      ImageIndex = 11
    end
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 12
      ShortCut = 16472
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 13
      ShortCut = 16451
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 14
      ShortCut = 16470
    end
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
    end
    object EditUndo1: TEditUndo
      Category = 'Edit'
      Caption = '&Undo'
      Hint = 'Undo|Reverts the last action'
      ImageIndex = 15
      ShortCut = 16474
    end
    object EditDelete1: TEditDelete
      Category = 'Edit'
      Caption = '&Delete'
      Hint = 'Delete|Erases the selection'
      ImageIndex = 16
      ShortCut = 46
    end
    object FileRun1: TFileRun
      Category = 'File'
      Browse = True
      BrowseDlg.Filter = 'Programs|*.exe;*.com;*.bat;*.cmd|All Files|*.*'
      BrowseDlg.Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
      BrowseDlg.Title = 'Run'
      Caption = '&Run...'
      Hint = 'Run|Runs an application'
      Operation = 'open'
      ShowCmd = scShowNormal
    end
    object StaticListAction1: TStaticListAction
      Category = 'List'
      Caption = 'StaticListAction1'
      Images = ImageList1
      Items = <
        item
          Caption = 'zero'
          ImageIndex = 0
        end
        item
          Caption = 'one'
          ImageIndex = 1
        end
        item
          Caption = 'two'
          ImageIndex = 2
        end
        item
          Caption = 'three'
          ImageIndex = 3
        end
        item
          Caption = 'four'
          ImageIndex = 4
        end
        item
          Caption = 'five'
          ImageIndex = 5
        end
        item
          Caption = 'six'
        end>
    end
    object DeleteAction: TAction
      Category = 'Buttons'
      Caption = '&Delete Item at Index'
      Hint = 'Delete the item indicated from the StaticListAction'
      OnExecute = DeleteActionExecute
    end
    object AddAction: TAction
      Category = 'Buttons'
      Caption = '&Add Item'
      Hint = 'Add the item to the StaticListAction'
      OnExecute = AddActionExecute
    end
    object ClearAction: TAction
      Category = 'Buttons'
      Caption = '&Clear'
      Hint = 'Clear the StaticListAction'
      OnExecute = ClearActionExecute
    end
    object ActiveAction: TAction
      Category = 'Buttons'
      Caption = 'Set InActive'
      Hint = 'Toggle the Active property of the StaticListAction'
      OnExecute = ActiveActionExecute
    end
    object SetIndexAction: TAction
      Category = 'Buttons'
      Caption = 'Set &Index'
      Hint = 'Set the selected item of the StaticListAction'
      OnExecute = SetIndexActionExecute
    end
    object FileOpen1: TFileOpen
      Category = 'File'
      Caption = '&Open...'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 17
      ShortCut = 16463
      OnAccept = FileOpen1Accept
    end
    object BrowseURL1: TBrowseURL
      Category = 'Internet'
      Caption = '&Browse URL'
      Hint = 'Browses to http://www.borland.com'
      URL = 'http://www.borland.com'
    end
    object DownLoadURL1: TDownLoadURL
      Category = 'Internet'
      Caption = '&Download URL'
      Hint = 'Downloads http://www.borland.com to a file called '#39'test'#39
      URL = 'http://www.borland.com'
      Filename = 'test'
    end
    object SendMail1: TSendMail
      Category = 'Internet'
      Caption = '&Send Mail...'
      Hint = 'Send email'
    end
    object ColorSelect1: TColorSelect
      Category = 'Dialog'
      Caption = 'Select &Color...'
      Hint = 'Color Select'
      OnAccept = ColorSelect1Accept
    end
    object OpenPicture1: TOpenPicture
      Category = 'Dialog'
      Caption = '&Open Picture...'
      Hint = 'Open Picture'
      ShortCut = 16463
      OnAccept = OpenPicture1Accept
    end
    object FontEdit1: TFontEdit
      Category = 'Dialog'
      Caption = 'Se&lect Font...'
      Dialog.Font.Charset = DEFAULT_CHARSET
      Dialog.Font.Color = clWindowText
      Dialog.Font.Height = -11
      Dialog.Font.Name = 'MS Sans Serif'
      Dialog.Font.Style = []
      Hint = 'Font Select'
      OnAccept = FontEdit1Accept
    end
    object PreviousTab1: TPreviousTab
      Category = 'Tab'
      TabControl = PageControl2
      Caption = '&Previous'
      Hint = 'Previous|Go back to the previous tab'
    end
    object NextTab1: TNextTab
      Category = 'Tab'
      TabControl = PageControl2
      Caption = '&Next'
      Hint = 'Next|Go to the next tab'
    end
    object ListControlCopySelection1: TListControlCopySelection
      Category = 'List'
      Caption = 'Copy >>'
      Destination = ListBox2
      Enabled = False
      ListControl = ListBox1
    end
    object ListControlDeleteSelection1: TListControlDeleteSelection
      Category = 'List'
      Caption = 'Delete >>'
      Enabled = False
      ListControl = ListBox2
    end
    object ListControlSelectAll1: TListControlSelectAll
      Category = 'List'
      Caption = '<< Select All'
    end
    object ListControlClearSelection1: TListControlClearSelection
      Category = 'List'
      Caption = 'Clear'
    end
    object ListControlMoveSelection1: TListControlMoveSelection
      Category = 'List'
      Caption = 'Move >>'
      Destination = ListBox2
      Enabled = False
      ListControl = ListBox1
    end
    object ShortCutAction: TAction
      Category = 'ShortCut'
      Caption = 'ShortCut Action'
      ShortCut = 16466
      SecondaryShortCuts.Strings = (
        'Ctrl+Alt+W'
        'Ctrl+Alt+X'
        'Ctrl+Alt+Y'
        'Ctrl+Shift+Z')
      OnExecute = ShortCutActionExecute
    end
    object AddShortCut: TAction
      Category = 'ShortCut'
      Caption = 'Add ShortCut'
      OnExecute = AddShortCutExecute
    end
    object FileOpenWith1: TFileOpenWith
      Category = 'File'
      Caption = 'Open &With...'
      Dialog.Filter = 'All Files|*.*'
      Dialog.Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
      Dialog.Title = 'Open With'
    end
    object FileSaveAs1: TFileSaveAs
      Category = 'File'
      Caption = 'Save &As...'
      Dialog.Filter = 'Text File|*.txt|All Files|*.*'
      Hint = 'Save As|Saves the active file with a new name'
      ImageIndex = 18
      OnAccept = FileSaveAs1Accept
    end
    object FilePrintSetup1: TFilePrintSetup
      Category = 'File'
      Caption = 'Print Set&up...'
      Hint = 'Print Setup'
    end
  end
  object ImageList1: TImageList
    Left = 426
    Top = 150
    Bitmap = {
      494C010113001500040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000000000000000000000000000000000C6C6C6000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000000000000000000000000000000000C6C6C6000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000008484000084840000000000000000000000000000000000000000000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000084840000848400008484000084840000848400008484000084
      8400008484000084840000000000000000000000000000000000000000000000
      0000008484000084840000848400008484000084840000848400008484000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000000000000000000000000000000000000000000084
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084840000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C6000000
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000000000000840000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000008400000084000000840000008400
      0000840000008400000084000000840000000000000000000000000000000000
      0000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000000000000840000000000000084000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000084848400008484008484
      8400008484008484840084000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000000000000840000000000000084000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00840000000000000000848400848484000084
      8400848484000084840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000000000000084000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000084848400008484008484
      8400008484008484840084000000FFFFFF00000000000000000000000000FFFF
      FF00840000008400000084000000840000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00840000000000000000848400848484000084
      8400848484000084840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0084000000FFFFFF0084000000000000000000000000000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000840000000000000084000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00840000000000000084848400008484008484
      8400008484008484840084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000008400000000000000000000000000000000000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF000000000000000000FFFF
      FF00840000008400000084000000840000000000000000848400848484000084
      8400848484000084840084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0084000000FFFFFF0084000000000000000000000084848400008484008484
      8400008484008484840000848400848484000084840084848400008484008484
      8400008484000000000000000000000000000000000000000000840000008400
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0084000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000008400000000000000000000000000000000848400848484000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400848484000000000000000000000000000000000000000000840000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000084848400848484000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400008484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400848484000084
      84000000000000FFFF00000000000000000000FFFF0000000000848484000084
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400FFFFFF00C6C6
      C60084848400C6C6C600FFFFFF00C6C6C6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      840084848400848484008484840084848400848484008484840084848400FFFF
      FF0084848400FFFFFF0084848400848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000084000000840000008400
      00000000000000000000848484008484840084848400FFFFFF00FFFFFF00FFFF
      FF008400000084000000840000008400000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FF00000084000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF008400000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      000084000000FF0000008400000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FF00000084000000FF00000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000000000000000000000000000C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      000084000000FF0000008400000000000000FFFFFF00FFFF0000FFFFFF00FFFF
      0000840000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000C6C6C6000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000084848400000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000000000000000000000000000C6C6
      C600000000000000000000000000000000000000000000000000000000008400
      0000FF00000084000000FF00000000000000FFFF0000FFFFFF00FFFF0000FFFF
      FF00840000000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000C6C6C6000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      000084000000FF0000008400000000000000FFFFFF00FFFF0000FFFFFF00FFFF
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000FF00000084000000FF00000000000000FFFF0000FFFFFF00FFFF0000FFFF
      FF0084000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C60000000000000000000000000000000000C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000840000008400000084000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFF7E0000FFFFFFFFBFFF0000
      EFFD001FF0030000C7FF000FE0030000C3FB0007E0030000E3F70003E0030000
      F1E70001E0030000F8CF000020030000FC1F001FE0020000FE3F001FE0030000
      FC1F001FE0030000F8CF8FF1E0030000E1E7FFF9E0030000C3F3FF75FFFF0000
      C7FDFF8FBF7D0000FFFFFFFF7F7E0000FFFFFFFFFFFFFFFFF9FFFFFFFC00FFFF
      F6CFFE008000FFFFF6B7FE000000FFFFF6B7FE000000FFFFF8B780000000FFF7
      FE8F80000001C1F7FE3F80000003C3FBFF7F80000003C7FBFE3F80010003CBFB
      FEBF80030003DCF7FC9F80070FC3FF0FFDDF807F0003FFFFFDDF80FF8007FFFF
      FDDF81FFF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFFB6E70000FFFFFE49B76B0000
      07C1FE498427000007C1FFFFB76BE00707C1FFFFCEE7E0070101C7C7FFFFE007
      0001C7C7C7C7E0070001C387C7C7E0070001C007C387E0078003C007C007E007
      C107C007C007E007C107C007C007FFFFE38FC007C007F81FE38FF39FC007F81F
      E38FF39FF39FF81FFFFFF39FF39FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      8FFFFFFFFFFFFFFF8C03C007C007C0078FFFFFFFFFFFFFFFFFFFC03FF807F83F
      FFFFFFFFFFFFFFFF8FFFC007C007C0078C03FFFFFFFFFFFF8FFFC03FF807F01F
      FFFFFFFFFFFFFFFFFFFFC007C007C0078FFFFFFFFFFFFFFF8C03C03FF807F83F
      8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFE00FFFFFFFFFFFFFFFFFFFFFF00F81FFF83F1038F8C7E3FFF39FBAD7
      F8C7F1FFF39F0000F8C7F8FFF39FD637F80FFC7FF39FC6D7F8C7FE3FF39FEED6
      F8C7FF1FF39FEC38F8C7FF8FF39FFFFFF00FFF03E10FFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object MainMenu1: TMainMenu
    Images = ImageList1
    Left = 424
    Top = 58
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Action = FileOpen1
      end
      object OpenWith1: TMenuItem
        Action = FileOpenWith1
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object PrintSetup1: TMenuItem
        Action = FilePrintSetup1
      end
      object Run1: TMenuItem
        Action = FileRun1
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = FileExit1
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object Cut1: TMenuItem
        Action = EditCut1
      end
      object Copy1: TMenuItem
        Action = EditCopy1
      end
      object Paste1: TMenuItem
        Action = EditPaste1
      end
      object Delete1: TMenuItem
        Action = EditDelete1
      end
      object SelectAll1: TMenuItem
        Action = EditSelectAll1
      end
      object Undo1: TMenuItem
        Action = EditUndo1
      end
    end
    object Search1: TMenuItem
      Caption = '&Search'
      object Find1: TMenuItem
        Action = SearchFind1
      end
      object FindFirst1: TMenuItem
        Action = SearchFindFirst1
      end
      object FindNext1: TMenuItem
        Action = SearchFindNext1
      end
      object Replace1: TMenuItem
        Action = SearchReplace1
      end
    end
    object AutoCheck1: TMenuItem
      Caption = '&AutoCheck'
      object GroupedAction11: TMenuItem
        Action = GroupAction1
        AutoCheck = True
      end
      object GroupedAction21: TMenuItem
        Action = GroupAction2
        AutoCheck = True
      end
      object GroupedAction31: TMenuItem
        Action = GroupAction3
        AutoCheck = True
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object AutoCheckAction1: TMenuItem
        Action = AutoCheckAction
        AutoCheck = True
      end
    end
    object GroupedAction12: TMenuItem
      Caption = '&Internet'
      object BrowseURL2: TMenuItem
        Action = BrowseURL1
      end
      object DownloadURL2: TMenuItem
        Action = DownLoadURL1
      end
      object SendMail2: TMenuItem
        Action = SendMail1
      end
    end
    object Dialog1: TMenuItem
      Caption = 'Dialog'
      object SelectColor1: TMenuItem
        Action = ColorSelect1
      end
      object SelectFont1: TMenuItem
        Action = FontEdit1
      end
      object OpenPicture2: TMenuItem
        Action = OpenPicture1
      end
    end
    object GroupedActions11: TMenuItem
      AutoCheck = True
      Caption = 'Tab'
      Checked = True
      object Previous1: TMenuItem
        Action = PreviousTab1
      end
      object Next1: TMenuItem
        Action = NextTab1
      end
    end
  end
end
