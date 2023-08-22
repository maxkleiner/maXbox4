unit ImageWin;
{$WARN UNIT_PLATFORM OFF}
interface

uses Windows, Classes, Graphics, Forms, Controls,
  FileCtrl, StdCtrls, ExtCtrls, Buttons, Spin, ComCtrls, Dialogs;

type
  TImageForm2 = class(TForm)
    DirectoryListBox1: TDirectoryListBox;
    DriveComboBox1: TDriveComboBox;
    FileEdit: TEdit;
    UpDownGroup: TGroupBox;
    SpeedButton1: TSpeedButton;
    BitBtn1: TBitBtn;
    DisabledGrp: TGroupBox;
    SpeedButton2: TSpeedButton;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Image1: TImage;
    FileListBox1: TFileListBox;
    Label2: TLabel;
    ViewBtn: TBitBtn;
    Bevel1: TBevel;
    Bevel2: TBevel;
    FilterComboBox1: TFilterComboBox;
    GlyphCheck: TCheckBox;
    StretchCheck: TCheckBox;
    UpDownEdit: TEdit;
    UpDown1: TUpDown;
    //FormCaption: string;
    procedure FileListBox1Click(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure ViewAsGlyph(const FileExt: string);
    procedure GlyphCheckClick(Sender: TObject);
    procedure StretchCheckClick(Sender: TObject);
    procedure FileEditKeyPress(Sender: TObject; var Key: Char);
    procedure UpDownEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    FormCaption: string;
  end;

var
  ImageForm2: TImageForm2;

implementation

uses ViewWin, SysUtils;

{$R *.dfm}

procedure TImageForm2.FileListBox1Click(Sender: TObject);
var
  FileExt: string[4];
begin
  FileExt := AnsiUpperCase(ExtractFileExt(FileListBox1.Filename));
  if (FileExt = '.BMP') or (FileExt = '.ICO') or (FileExt = '.WMF') or
    (FileExt = '.EMF') then
  begin
    Image1.Picture.LoadFromFile(FileListBox1.Filename);
    Caption := FormCaption + ExtractFilename(FileListBox1.Filename);
    if (FileExt = '.BMP') then
    begin
      Caption := Caption + 
        Format(' (%d x %d)', [Image1.Picture.Width, Image1.Picture.Height]);
      ViewForm.Image1.Picture := Image1.Picture;
      ViewForm.Caption := Caption;
      if GlyphCheck.Checked then ViewAsGlyph(FileExt);
    end
    else
      GlyphCheck.Checked := False;
    if FileExt = '.ICO' then
    begin
      Icon := Image1.Picture.Icon;
      ViewForm.Image1.Picture.Icon := Icon;
    end;
    if (FileExt = '.WMF') or (FileExt = '.EMF') then 
      ViewForm.Image1.Picture.Metafile := Image1.Picture.Metafile;
  end;
end;

procedure TImageForm2.GlyphCheckClick(Sender: TObject);
begin
  ViewAsGlyph(AnsiUpperCase(ExtractFileExt(FileListBox1.Filename)));
end;

procedure TImageForm2.ViewAsGlyph(const FileExt: string);
begin
  if GlyphCheck.Checked and (FileExt = '.BMP') then 
  begin
    SpeedButton1.Glyph := Image1.Picture.Bitmap;
    SpeedButton2.Glyph := Image1.Picture.Bitmap;
    UpDown1.Position := SpeedButton1.NumGlyphs;
    BitBtn1.Glyph := Image1.Picture.Bitmap;
    BitBtn2.Glyph := Image1.Picture.Bitmap;
  end
  else begin
    SpeedButton1.Glyph := nil;
    SpeedButton2.Glyph := nil;
    BitBtn1.Glyph := nil;
    BitBtn2.Glyph := nil;
  end;
  UpDown1.Enabled := GlyphCheck.Checked;
  UpDownEdit.Enabled := GlyphCheck.Checked;
  Label2.Enabled := GlyphCheck.Checked;
end;

procedure TImageForm2.ViewBtnClick(Sender: TObject);
begin
  ViewForm.HorzScrollBar.Range := Image1.Picture.Width;
  ViewForm.VertScrollBar.Range := Image1.Picture.Height;
  ViewForm.Caption := Caption;
  ViewForm.Show;
  ViewForm.WindowState := wsNormal;
end;

procedure TImageForm2.UpDownEditChange(Sender: TObject);
resourcestring
  sMinValue = 'Value below minimum';
  sMaxValue = 'Value over maximum';

begin
  if (StrToInt(UpDownEdit.Text) < UpDown1.Min) then
  begin
    UpDownEdit.Text := '1';
    raise ERangeError.Create(sMinValue);
  end
  else if (StrToInt(UpDownEdit.Text) > UpDown1.Max) then
  begin
    UpDownEdit.Text := '4';
    raise ERangeError.Create(sMaxValue);
  end;

  SpeedButton1.NumGlyphs := UpDown1.Position;
  SpeedButton2.NumGlyphs := UpDown1.Position;
end;

procedure TImageForm2.StretchCheckClick(Sender: TObject);
begin
  Image1.Stretch := StretchCheck.Checked;
end;

procedure TImageForm2.FileEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FileListBox1.ApplyFilePath(FileEdit.Text);
    Key := #0;
  end;
end;

procedure TImageForm2.FormCreate(Sender: TObject);
begin
  FormCaption := Caption + ' - ';
  UpDown1.Min := 1;
  UpDown1.Max := 4;
end;

end.
