unit CustomDrawTreeView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtDlgs, StdCtrls, ExtCtrls, ColorGrd, ImgList, Menus;

type
  TCustomDrawForm = class(TForm)
    TV: TTreeView;
    ImageList: TImageList;
    MainMenu1: TMainMenu;
    Drawing1: TMenuItem;
    Font1: TMenuItem;
    Background1: TMenuItem;
    Color1: TMenuItem;
    Bitmap1: TMenuItem;
    DefaultDrawing1: TMenuItem;
    OnCustomDraw1: TMenuItem;
    OnCustomDrawItem1: TMenuItem;
    BrushStyle1: TMenuItem;
    Solid1: TMenuItem;
    Clear1: TMenuItem;
    Horizontal1: TMenuItem;
    Vertical1: TMenuItem;
    FDiagonal1: TMenuItem;
    BDiagonal1: TMenuItem;
    Cross1: TMenuItem;
    DiagCross1: TMenuItem;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    TVFontDialog: TFontDialog;
    Tile1: TMenuItem;
    Stretch1: TMenuItem;
    None1: TMenuItem;
    Selection1: TMenuItem;
    SelectedFontDialog: TFontDialog;
    BkgColorDialog: TColorDialog;
    SelBkgColorDialog: TColorDialog;
    SelectionBackground1: TMenuItem;
    ButtonColor1: TMenuItem;
    ButtonSize1: TMenuItem;
    ButtonColorDialog: TColorDialog;
    Image1: TImage;
    TreeView1: TMenuItem;
    Color2: TMenuItem;
    TVColorDialog: TColorDialog;
    CustomDraw1: TMenuItem;
    Font2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TVCustomDraw(Sender: TCustomTreeView; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure TVCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure TVGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure TVGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure Exit1Click(Sender: TObject);
    procedure Selection1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure SelectionBackground1Click(Sender: TObject);
    procedure Solid1Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure OnCustomDraw1Click(Sender: TObject);
    procedure OnCustomDrawItem1Click(Sender: TObject);
    procedure TVExpanded(Sender: TObject; Node: TTreeNode);
    procedure ButtonColor1Click(Sender: TObject);
    procedure ButtonSize1Click(Sender: TObject);
    procedure Drawing1Click(Sender: TObject);
    procedure Color2Click(Sender: TObject);
    procedure CustomDraw1Click(Sender: TObject);
    procedure Font2Click(Sender: TObject);
  private
    FButtonSize: Integer;
    FDefaultDraw,
    FDefaultDrawItem: Boolean;
    FBackgroundColor: TColor;
    FBrushStyle: TBrushStyle;
    procedure DrawButton(ARect: TRect; Node: TTreeNode);
    procedure DrawImage(NodeRect: TRect; ImageIndex: Integer);
    procedure SetCustomDraw(Value: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CustomDrawForm: TCustomDrawForm;

implementation

{$R *.dfm}

procedure TCustomDrawForm.FormCreate(Sender: TObject);
begin
  FBackgroundColor := clWindow;
  FDefaultDraw := True;
  FDefaultDrawItem := True;
  FBrushStyle := bsSolid;
  FButtonSize := 5;
  BkgColorDialog.Color := clWindow;
  SelBkgColorDialog.Color := clHighlight;
  TVFontDialog.Font.Assign(TV.Font);
  SelectedFontDialog.Font.Assign(TV.Font);
  SelectedFontDialog.Font.Color := clHighlightText;
  SelBkgColorDialog.Color := clHighlight;
  TVColorDialog.Color := TV.Color;
end;

procedure TCustomDrawForm.TVCustomDraw(Sender: TCustomTreeView; const ARect: TRect;
  var DefaultDraw: Boolean);
begin
//This event should be used to draw any background colors or images.
//ARect represents the entire client area of the TreeView.
//Use the TreeView's canvas to do the drawing.
//Note that drawing a background bitmap is not really supported by CustomDraw,
//so scrolling can get messy. Best to subclass the TreeView and handle scrolling
//messages.
  with TV.Canvas do
  begin
    if None1 <> nil then
    begin
      if None1.Checked then //no picture
      begin
        Brush.Color := BkgColorDialog.Color;
        Brush.Style := FBrushStyle;
        FillRect(ARect);
      end else
        if Tile1.Checked then //tile bitmap
        begin
          Brush.Bitmap := Image1.Picture.Bitmap;
            FillRect(ARect);
          end else //Stretch across the canvas.
              StretchDraw(ARect, Image1.Picture.Bitmap);
    end;
  end;
  DefaultDraw := FDefaultDraw;
  //setting DefaultDraw to false here prevents all calls to OnCustomDrawItem.
end;

procedure TCustomDrawForm.DrawButton(ARect: TRect; Node: TTreeNode);
var
  cx, cy: Integer;
begin
  cx := ARect.Left + TV.Indent div 2;
  cy := ARect.Top + (ARect.Bottom - ARect.Top) div 2;
  with TV.Canvas do
  begin
    Pen.Color := ButtonColorDialog.Color;
    //draw horizontal line.
    if Node.HasChildren then
    begin
      PenPos := Point(cx+FButtonSize, cy);
      LineTo(ARect.Left + TV.Indent + FButtonSize, cy);
    end else
    begin
      PenPos := Point(cx, cy);
      LineTo(ARect.Left + TV.Indent + FButtonSize, cy);
    end;

    //draw half vertical line, top portion.
    PenPos := Point(cx, cy);
    LineTo(cx, ARect.Top-1);

    if ((Node.GetNextVisible <> nil) and (Node.GetNextVisible.Level = Node.Level))
    or (Node.GetNextSibling <> nil) then
    //draw bottom portion of half vertical line.
    begin
      PenPos := Point(cx, cy);
      LineTo(cx, ARect.Bottom+1);
    end;  

    if Node.HasChildren then
    begin
      //Let's try a circular button instead
      Ellipse(cx-FButtonSize, cy-FButtonSize, cx+FButtonSize, cy+FButtonSize);

      //draw the horizontal indicator.
      PenPos := Point(cx-FButtonSize+2, cy);
      LineTo(cx+FButtonSize-2, cy);
      //draw the vertical indicator if the node is collapsed
      if not Node.Expanded then
      begin
        PenPos := Point(cx, cy-FButtonSize+2);
        LineTo(cx, cy+FButtonSize-2);
      end;
    end;
        //now connect vertical lines of higher level nodes.
    Node := Node.Parent;
    while Node <> nil do
    begin
      cx := cx - TV.Indent;
      if Node.GetNextSibling <> nil then
      begin
        PenPos := Point(cx, ARect.Top);
        LineTo(cx, ARect.Bottom);
      end;
      Node := Node.Parent;
    end;
  end;
end;

procedure TCustomDrawForm.DrawImage(NodeRect: TRect; ImageIndex: Integer);
var
  cy: Integer;
begin
  cy := NodeRect.Top + (NodeRect.Bottom - NodeRect.Top) div 2;
  //center image in NodeRect.
  ImageList.Draw(TV.Canvas, NodeRect.Left, cy - TV.Images.Height div 2,
                 ImageIndex, True);
end;

procedure TCustomDrawForm.TVCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect: TRect;
begin
  with TV.Canvas do
  begin
    //If DefaultDraw it is true, any of the node's font properties can be
    //changed. Note also that when DefaultDraw = True, Windows draws the
    //buttons and ignores our font background colors, using instead the
    //TreeView's Color property.
    if cdsSelected in State then
    begin
      Font.Assign(SelectedFontDialog.Font);
      Brush.Color := SelBkgColorDialog.Color;
    end;

    DefaultDraw := FDefaultDrawItem;
    //DefaultDraw = False means you have to handle all the item drawing yourself,
    //including the buttons, lines, images, and text.
    if not DefaultDraw then
    begin
      //draw the selection rect.
      if cdsSelected in State then
      begin
        NodeRect := Node.DisplayRect(True);
        FillRect(NodeRect);
      end;
      NodeRect := Node.DisplayRect(False);

      if None1.Checked then
      //no bitmap, so paint in the background color.
      begin
        Brush.Color := BkgColorDialog.Color;
        Brush.Style := FBrushStyle;
        FillRect(NodeRect)
      end
      else
        //don't paint over the background bitmap.
        Brush.Style := bsClear;

      NodeRect.Left := NodeRect.Left + (Node.Level * TV.Indent);
      //NodeRect.Left now represents the left-most portion of the expand button
      DrawButton(NodeRect, Node);

      NodeRect.Left := NodeRect.Left + TV.Indent + FButtonSize;
      //NodeRect.Left is now the leftmost portion of the image.
      DrawImage(NodeRect, Node.ImageIndex);

      NodeRect.Left := NodeRect.Left + ImageList.Width;
      //Now we are finally in a position to draw the text.

      TextOut(NodeRect.Left, NodeRect.Top, Node.Text);
    end;
  end;
end;

procedure TCustomDrawForm.TVGetImageIndex(Sender: TObject; Node: TTreeNode);
begin
  if Node.HasChildren then
    if Node.Expanded then
      Node.ImageIndex := 3
    else
      Node.ImageIndex := 0
  else
    Node.ImageIndex := 1;
end;

procedure TCustomDrawForm.TVGetSelectedIndex(Sender: TObject; Node: TTreeNode);
begin
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TCustomDrawForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TCustomDrawForm.Selection1Click(Sender: TObject);
begin
  if SelectedFontDialog.Execute then
    TV.Repaint;
end;

procedure TCustomDrawForm.Color1Click(Sender: TObject);
begin
  if BkgColorDialog.Execute then
    TV.Repaint;
end;

procedure TCustomDrawForm.SelectionBackground1Click(Sender: TObject);
begin
  if SelBkgColorDialog.Execute then
    TV.Repaint;
end;

procedure TCustomDrawForm.Solid1Click(Sender: TObject);
begin
  with Sender as TMenuItem do
  begin
    FBrushStyle := TBrushStyle(Tag);
    Checked := True;
  end;
  TV.Repaint;
end;

procedure TCustomDrawForm.None1Click(Sender: TObject);
begin
  (Sender as TMenuItem).Checked := True;
  TV.Repaint;
end;

procedure TCustomDrawForm.OnCustomDraw1Click(Sender: TObject);
begin
  FDefaultDraw := not FDefaultDraw;
  OnCustomDraw1.Checked := FDefaultDraw;
  TV.Repaint;
end;

procedure TCustomDrawForm.OnCustomDrawItem1Click(Sender: TObject);
begin
  FDefaultDrawItem := not FDefaultDrawItem;
  OnCustomDrawItem1.Checked := FDefaultDrawItem;
  TV.Repaint;
end;

procedure TCustomDrawForm.TVExpanded(Sender: TObject; Node: TTreeNode);
begin
  TV.Repaint;
end;

procedure TCustomDrawForm.ButtonColor1Click(Sender: TObject);
begin
  if ButtonColorDialog.Execute then TV.Repaint;
end;

procedure TCustomDrawForm.ButtonSize1Click(Sender: TObject);
var
  S: string;
begin
  S := IntToStr(FButtonSize);
  if InputQuery('Change button size', 'Enter new size', S) then
    FButtonSize := StrToInt(S);
  TV.Repaint;  
end;

procedure TCustomDrawForm.Drawing1Click(Sender: TObject);
begin
  ButtonColor1.Enabled := not OnCustomDrawItem1.Checked;
  ButtonSize1.Enabled := ButtonColor1.Enabled;
end;

procedure TCustomDrawForm.Color2Click(Sender: TObject);
begin
  if TVColorDialog.Execute then
  begin
    TV.Color := TVColorDialog.Color;
    TV.Repaint;
  end;
end;

procedure TCustomDrawForm.SetCustomDraw(Value: Boolean);
begin
  if not Value then
  begin
    TV.OnCustomDraw := nil;
    TV.OnCustomDrawItem := nil;
  end else
  begin
    TV.OnCustomDraw := Self.TVCustomDraw;
    TV.OnCustomDrawItem := Self.TVCustomDrawItem;
  end;
  Drawing1.Enabled := Value;
  TV.Repaint;
end;

procedure TCustomDrawForm.CustomDraw1Click(Sender: TObject);
begin
  CustomDraw1.Checked := not CustomDraw1.Checked;
  SetCustomDraw(CustomDraw1.Checked);
end;

procedure TCustomDrawForm.Font2Click(Sender: TObject);
begin
  if TVFontDialog.Execute then
    TV.Font.Assign(TVFontDialog.Font);
end;

end.
 