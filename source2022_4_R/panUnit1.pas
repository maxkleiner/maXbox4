{
  Simple spherical panorama viewer using GLScene

  The sample input images are by Philippe Hurbain. http://philohome.free.fr/

  Other resources on how to make your own spherical or cylindrical panorama:
    http://www.fh-furtwangen.de/~dersch/
    http://www.panoguide.com/

  Why IPIX patents regarding use of fisheye photos are questionable:
    http://www.worldserver.com/turk/quicktimevr/fisheye.html

  10/12/02 - EG - Updated for GLScene v0.9+
}
unit panUnit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, jpeg,
  ComCtrls, StdCtrls, GLScene, GLObjects, ExtCtrls, GLMisc, ExtDlgs,
  GLTexture, KeyBoard, GLCadencer, GLWin32Viewer;

type
  TPanForm1 = class(TForm)
    GLSceneViewer1: TGLSceneViewer;
    GLScene1: TGLScene;
    Panel1: TPanel;
    GLCamera1: TGLCamera;
    BtnLoad: TButton;
    TrackBar1: TTrackBar;
    LabelYaw: TLabel;
    LabelPitch: TLabel;
    OpenPictureDialog1: TOpenPictureDialog;
    Label1: TLabel;
    Sphere1: TGLSphere;
    GLMaterialLibrary1: TGLMaterialLibrary;
    Label2: TLabel;
    GLCadencer1: TGLCadencer;
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure BtnLoadClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GLCadencer1Progress(Sender: TObject; const deltaTime,
      newTime: Double);
  private
    { Private declarations }
      mx, my : integer;
      pitch, yaw : single; // in degree
      procedure PanCameraAround(dx, dy : single);
  public
    { Public declarations }
  end;

var
  panForm1: TPanForm1;

implementation

uses VectorGeometry;

{$R *.DFM}

procedure TPanForm1.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  mx:=x;
  my:=y;
end;

procedure TPanForm1.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
   dx, dy, f : Single;
begin
  if Shift=[ssLeft] then
    begin
     f:=0.2*40/GLCamera1.FocalLength;
     dx:=(x-mx)*f;
     dy:=(y-my)*f;
     PanCameraAround(dx, dy);
    end;
  mx:=x;
  my:=y;
end;

procedure TPanForm1.BtnLoadClick(Sender: TObject);
begin
  with OpenPictureDialog1 do
    if Execute then
    GLMaterialLibrary1.Materials[0].Material.Texture.Image.LoadFromFile(FileName);
end;

procedure TPanForm1.TrackBar1Change(Sender: TObject);
begin
  GLCamera1.FocalLength:=TrackBar1.Position;
end;

procedure TPanForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
   TrackBar1.Position:=TrackBar1.Position+Round(2*WheelDelta/120);
end;

procedure TPanForm1.GLCadencer1Progress(Sender: TObject; const deltaTime,
  newTime: Double);
const step_size = 20;
var
   delta : Single;
   dx, dy : Single;
begin
   delta:=step_size * 40/GLCamera1.FocalLength * deltaTime;
   dx:=0;
   dy:=0;
   if IsKeyDown(VK_LEFT)  then dx:=dx+delta;
   if IsKeyDown(VK_UP)    then dy:=dy+delta;
   if IsKeyDown(VK_RIGHT) then dx:=dx-delta;
   if IsKeyDown(VK_DOWN)  then dy:=dy-delta;
   PanCameraAround(dx, dy);
end;

procedure TPanForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  key:=0; // all keys handled by Form1
end;

procedure TPanForm1.PanCameraAround(dx, dy : single);
begin
  pitch:=pitch+dy;
  yaw:=yaw-dx;

  if pitch>90 then pitch:=90;
  if pitch<-90 then pitch:=-90;
  if yaw>360 then yaw:=yaw-360;
  if yaw<0 then yaw:=yaw+360;

  GLCamera1.Up.SetVector(0, 1, 0);
  GLCamera1.Direction.SetVector( sin(DegToRad(yaw)),
                                 sin(DegToRad(pitch)),
                                -cos(DegToRad(yaw)));

  labelPitch.caption:=format('Pitch: %3f', [pitch]);
  labelYaw.caption:=format('Yaw: %3f', [yaw]);
end;

end.
