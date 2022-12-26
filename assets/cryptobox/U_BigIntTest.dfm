object bigints: Tbigints
  Left = 200
  Top = 90
  Width = 793
  Height = 658
  Caption = 'Big integers test V2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 785
    Height = 604
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 777
        Height = 573
        Align = alClient
        Color = 14548991
        Lines.Strings = (
          
            'This is a test program for Version 3 of our TInteger Delphi clas' +
            's, UBigIntsV3.'
          ''
          
            'TInteger was developed in 2001 to explore large integer arithmet' +
            'ic. The original version contained class methods Assign, Add, '
          
            'Subtract, Mult, Divide, Modulo, Compare, Factorial, ConvertToDec' +
            'imalString with variations to accept both TInteger and in some '
          'cases:  Int64 (64 '
          'bit integer), and/or String parameters. '
          ' '
          
            'Since then a number of viewers, Charles Doumar and Hans Klein in' +
            ' particular,  have made valuable contributions to improve the'
          'speed of existing methods and to introduce additional methods.'
          ''
          'In addition to the above, the current version includes:'
          ''
          '    ¤   AssignZero;  {Fast way to assign 0 to '#39'self'#39')'
          '    ¤   AssignOne;   {Fast way to assign 1 to '#39'self'#39')'
          '    ¤   ConvertToInt64'
          '    ¤   FastMult  (Faster version of Multiply)'
          '    ¤   Pow    (exponentiation '#39'self'#39'^Y'
          '    ¤   NRoot  (Find Nth root of X)'
          '    ¤   Square ( self * self)'
          '    ¤   FastSquare (Faster version of Square)'
          '    ¤   SqRoot (Square root of self)'
          '    ¤   GCD (Greatest Common Denominatorvalue'
          '    ¤   IsOdd (Returns True if integer is odd)'
          
            '    ¤   DigitCount: integer; (Number of decimal digits in the in' +
            'teger)'
          ''
          ''
          'The following methods test or manipulate the sign of '#39'self'#39':'
          ''
          
            '    ¤   GetSign {returns +1,0, or -1 or positive, zero, negative' +
            '}'
          '    ¤   SetSign {Sets sign to +1, 0 or -1}'
          
            '    ¤   AbsoluteValue (Sets sign to +1 if integer value is not z' +
            'ero}'
          '    ¤   ChangeSign (equivalent to multiply by -1)'
          '    ¤   IsPositive  (returns True if sign = +1)'
          '    ¤   IsZero  (returns True if sign = 0)'
          '    ¤   IsNegative  (returns True if sign = -1)'
          ''
          ''
          
            'These procedures get and set the global base value used by TInte' +
            'ger classes.  They should not normally be called by users.'
          ''
          
            '    ¤   GetBase (Returns 10^x, size of each "digit", default and' +
            ' maximum is 1,000,000)'
          
            '    ¤   SetBaseVal (Changing this value from default will use mo' +
            're space and slow calculations)'
          ''
          
            'Visit Delphiforfun.org website or search the Internet for :'#39'Mill' +
            'er Rabin'#39', '#39'RSA'#39', '#39'ModPow'#39', or  '#39'InvMod'#39' for more'
          'information on the following 3 functions and their usage..'
          ''
          
            '    ¤  IsProbablyPrime (Miller Rabin primality test, identifies ' +
            'number as probably prime)'
          
            '    ¤  ModPow (X^Y mod Z, used in Miller Rabin probabistic test ' +
            'for primes and in cryptographic key generation)'
          
            '    ¤  InvMod (Used with ModPow in RSA cryptographic key generat' +
            'ion)'
          ''
          ''
          
            'Version 3 evaluates additional definitions for division with rem' +
            'ainder all meeting the requirement that Divisor*Quotient + '
          
            'Remainder = Dividend, but producing differing Quotients and Rema' +
            'inders if Divisor and or Dividend is <0.  See the paper '
          
            '"Divisions and Modulus for Computer Scientists" by Daan Leijen a' +
            't '
          
            'http://www.cs.uu.nl/~daan/download/papers/divmodnote.pdf for an ' +
            'excelent discussion.'
          ''
          
            '    ¤   DivideRem (The original divide with remainder using trnc' +
            'ated division)'
          '    ¤   DivideRemTrunc (caalls the original Dividerem)'
          '    ¤   DivideRemFloor (Floored division definition)'
          
            '    ¤   DivideRemEuclidean  (Euclidean division definition, rema' +
            'iner is always positive)'
          ''
          ''
          ''
          ''
          ''
          ''
          ' ')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Test'
      ImageIndex = 1
      object Label1: TLabel
        Left = 16
        Top = 32
        Width = 9
        Height = 13
        Caption = 'X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 16
        Top = 64
        Width = 9
        Height = 13
        Caption = 'Y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 16
        Top = 96
        Width = 9
        Height = 13
        Caption = 'Z'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 168
        Top = 256
        Width = 321
        Height = 41
        AutoSize = False
        Caption = 
          'Compare multiplply times for two random integers x and y digits ' +
          'long..  FastMult significantly faster above 4000 digits.  Result' +
          ' size (x+y) limited to 500,000 digits for time considerations. '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        WordWrap = True
      end
      object Long1Edt: TEdit
        Left = 40
        Top = 26
        Width = 401
        Height = 24
        TabOrder = 0
        Text = '2'
      end
      object Long2Edt: TEdit
        Left = 40
        Top = 60
        Width = 401
        Height = 24
        TabOrder = 1
        Text = '13'
      end
      object AddBtn: TButton
        Left = 24
        Top = 136
        Width = 81
        Height = 25
        Hint = 'Addition'
        Caption = 'x + y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = AddBtnClick
      end
      object MultBtn: TButton
        Left = 202
        Top = 136
        Width = 81
        Height = 25
        Hint = 'Multiplication'
        Caption = 'x * y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = MultBtnClick
      end
      object FactorialBtn: TButton
        Left = 304
        Top = 168
        Width = 73
        Height = 25
        Hint = 'Factorial(x), x limited to 3000'
        Caption = 'x!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = FactorialBtnClick
      end
      object SubtractBtn: TButton
        Left = 113
        Top = 136
        Width = 81
        Height = 25
        Hint = 'Subraction'
        Caption = 'x - y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = SubtractBtnClick
      end
      object DivideBtn: TButton
        Left = 298
        Top = 136
        Width = 81
        Height = 25
        Hint = 'Trunc(x/y),  i.e. rounded toward zero'
        Caption = 'x div y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = DivideBtnClick
      end
      object ModBtn: TButton
        Left = 22
        Top = 200
        Width = 81
        Height = 25
        Hint = 'Truncate Mod (d*(D/d)+ModT(D,d)=D'
        Caption = 'x modulo y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = ModBtnClick
      end
      object ComboBtn: TButton
        Left = 568
        Top = 168
        Width = 81
        Height = 25
        Hint = 'Combinations (Coose y of x)'
        Caption = 'Combo (y of x)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = ComboBtnClick
      end
      object XtotheYBtn: TButton
        Left = 385
        Top = 168
        Width = 81
        Height = 25
        Hint = 'Power function'
        Caption = 'x^y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = powerbtnClick
      end
      object Long3Edt: TEdit
        Left = 40
        Top = 92
        Width = 401
        Height = 24
        TabOrder = 10
        Text = '3'
      end
      object ModPowBtn: TButton
        Left = 288
        Top = 200
        Width = 169
        Height = 25
        Hint = 'PowMod function'
        Caption = 'ModPow(x,y) =  x^y (modulo z)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnClick = modpowbtnClick
      end
      object SqRootBtn: TButton
        Left = 111
        Top = 168
        Width = 81
        Height = 25
        Hint = 'Square root'
        Caption = 'Sq. root'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        OnClick = rootbtnClick
      end
      object SquareBtn: TButton
        Left = 22
        Top = 168
        Width = 81
        Height = 25
        Hint = 'Square'
        Caption = 'x^2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        OnClick = squareButtonClick
      end
      object CopyBtn: TButton
        Left = 624
        Top = 360
        Width = 115
        Height = 25
        Caption = 'Copy result to x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 14
        OnClick = copyButtonClick
      end
      object ProbPrimeBtn: TButton
        Left = 200
        Top = 168
        Width = 97
        Height = 25
        Caption = 'is probably prime?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
        OnClick = primetestclick
      end
      object GCDBtn: TButton
        Left = 657
        Top = 168
        Width = 81
        Height = 25
        Hint = 'Greatest Common Denominator'
        Caption = 'GCD(x,y)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        OnClick = gcdClick
      end
      object InvModBtn: TButton
        Left = 111
        Top = 200
        Width = 169
        Height = 25
        Hint = 'Inverse mod function (InvMod)'
        Caption = 'InvMod(x,y)*x =1 modulo y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
        OnClick = invbuttonClick
      end
      object YthRootBtn: TButton
        Left = 474
        Top = 168
        Width = 81
        Height = 25
        Caption = 'Yth root of X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
        OnClick = YthRootBtnClick
      end
      object Button10: TButton
        Left = 24
        Top = 264
        Width = 137
        Height = 25
        Caption = 'FastMult'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 19
        OnClick = Button10Click
      end
      object FloorBtn: TButton
        Left = 389
        Top = 136
        Width = 75
        Height = 25
        Hint = '(x/y) rounded toward minus infinityo'
        Caption = 'Floor(x/y)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 20
        OnClick = FloorBtnClick
      end
      object Button12: TButton
        Left = 488
        Top = 32
        Width = 233
        Height = 25
        Caption = 'invmod(x,y)*x mod y'
        TabOrder = 21
        Visible = False
        OnClick = Button12Click
      end
      object Memo1: TMemo
        Left = 32
        Top = 392
        Width = 713
        Height = 153
        ScrollBars = ssVertical
        TabOrder = 22
      end
      object DivRemBtn: TButton
        Left = 472
        Top = 136
        Width = 225
        Height = 25
        Caption = 'x /y (with remainder, 3 methods)'
        TabOrder = 23
        OnClick = DivRemBtnClick
      end
      object ToInt64Btn: TButton
        Left = 472
        Top = 200
        Width = 97
        Height = 25
        Caption = 'ConvertToInt64(x)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 24
        OnClick = ToInt64BtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 604
    Width = 785
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2001-2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
