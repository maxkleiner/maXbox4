{*
 * Delphi LEDs Control
 * -----------------
 * Controls the state (ON/OFF) of 5 LEDs connected to an Arduino Board
 * on Digital Pins 2,3,4,5,6 thru the serial comm
 *
 * Created April 02 2009
 * copyleft 2009 Roberto Ramirez <beta@thepenguincult.com>
 * Full Source code at http://www.thepenguincult.com/proyectos/arduino-delphi-control/
 * template to maXbox 3.9.3
 * added for formtemplatelibrary at 3.9.9.80
 *}

unit delphi_arduino_Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, CPort, CPortCtl, Menus;

type
  TledForm = class(TForm)
    btn_connect: TButton;
    StatusBar1: TStatusBar;
    btn_Setup: TButton;
    chk_led1: TCheckBox;
    chk_led2: TCheckBox;
    chk_led3: TCheckBox;
    chk_led4: TCheckBox;
    chk_led5: TCheckBox;
    btn_loop: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure btn_connectClick(Sender: TObject);
    procedure btn_SetupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chk_led1Click(Sender: TObject);
    procedure chk_led2Click(Sender: TObject);
    procedure chk_led3Click(Sender: TObject);
    procedure chk_led4Click(Sender: TObject);
    procedure chk_led5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_loopClick(Sender: TObject);
  private
    { Private declarations }
  public
    ComPort1: TComport;
    { Public declarations }
  end;

var
  ledForm: TledForm;

implementation

{$R *.dfm}

procedure TledForm.btn_connectClick(Sender: TObject);
begin
  //comport1:= TComport.create;
  if ComPort1.Connected then
      begin

      btn_connect.Caption:='Connect';  // Toggle the caption of Connection Button
      btn_Setup.Enabled:=True;         // If not connected, lets enable the Setup Button
      btn_loop.Enabled:=false;         // Knight Rider demo button is disabled at first

      // This block resets the state of all Leds to Off
      // According to Arduino Code the Chars A,B,C,D,E are used
      // to set Digital Pins (2-6) to LOW
      comport1.WriteStr('A');
      comport1.WriteStr('B');
      comport1.WriteStr('C');
      comport1.WriteStr('D');
      comport1.WriteStr('E');
      //-----------------------------------------------
      // This block resets the state of all Check Boxes to Unchecked
      chk_led1.Checked:=false;
      chk_led2.Checked:=false;
      chk_led3.Checked:=false;
      chk_led4.Checked:=false;
      chk_led5.Checked:=false;
      //-----------------------------------------------
      ComPort1.Close;                  // COM Port in use is closed

      statusbar1.Panels[1].Text:='Disconnected';  // Status bar is set to display connection info

      // This block disables the check boxes
      // so the user cannot change them if COM Port is disconnected
      chk_led1.Enabled:=false;
      chk_led2.Enabled:=false;
      chk_led3.Enabled:=false;
      chk_led4.Enabled:=false;
      chk_led5.Enabled:=false;
      //------------------------------------------------
     end

    else
      begin
      btn_connect.Caption:='Disconnect';        // Toggle the caption of Connection Button
      btn_Setup.Enabled:=False;                 // If not connected, lets disable the Setup Button
      btn_loop.Enabled:=true;                   // Now that conection is posible Knight Rider demo button is enabled
      ComPort1.Open;                            // COM Port in use is finally opened
      statusbar1.Panels[1].Text:='Connected';   // Status bar is set to display connection info

      // This block enables the check boxes
      // so the user can change them to set LED states when COM Port is connected
      chk_led1.Enabled:=true;
      chk_led2.Enabled:=true;
      chk_led3.Enabled:=true;
      chk_led4.Enabled:=true;
      chk_led5.Enabled:=true;
      //------------------------------------------------
      end
end;



procedure TledForm.btn_SetupClick(Sender: TObject);
begin
comport1.ShowSetupDialog;                                   // Opens the predefined Setup Dialog (part of ComPort component)
statusbar1.Panels[0].Text:='Port in use ' + comport1.Port;  // Status bar is set to display Port in use after setup dialog
end;

procedure TledForm.FormCreate(Sender: TObject);
begin
  comport1:= TComport.create(self);

  statusbar1.Panels[0].Text:='Port in use ' + comport1.Port;  // Status bar is set to display predefined Port in use at begining of program execution

  if comport1.Connected=true then
    statusbar1.Panels[1].Text:='Connected'                  // Status bar is set to display connection info at begining of program execution
    else
    statusbar1.Panels[1].Text:='Disconnected'
  end;


// Next are the procedures to turning ON and OFF each led using the variables
// defined on both Arduino code and delphi code.
// Sending the predifined vars thru serial comm (on byte at the time)
// Ports 2,3,4,5,6 are turned ON by sending it corresponding var 1,2,3,4,5
// and they are turned OFF by sending it corresponding var A,B,C,D,E


procedure TledForm.chk_led1Click(Sender: TObject);
begin

    if chk_led1.Checked=true then
    comport1.WriteStr('1')
    else
    comport1.WriteStr('A')

end;

procedure TledForm.chk_led2Click(Sender: TObject);
begin
    if chk_led2.Checked=true then
    comport1.WriteStr('2')
    else
    comport1.WriteStr('B')
end;

procedure TledForm.chk_led3Click(Sender: TObject);
begin
    if chk_led3.Checked=true then
    comport1.WriteStr('3')
    else
    comport1.WriteStr('C')
end;

procedure TledForm.chk_led4Click(Sender: TObject);
begin
    if chk_led4.Checked=true then
    comport1.WriteStr('4')
    else
    comport1.WriteStr('D')
end;

procedure TledForm.chk_led5Click(Sender: TObject);
begin
    if chk_led5.Checked=true then
    comport1.WriteStr('5')
    else
    comport1.WriteStr('E')
end;

// Here ends the ON/OFF procedures for each led


procedure TledForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ComPort1.Connected then
      begin
        comport1.WriteStr('A');     // If the application is closed, its good to leave
        comport1.WriteStr('B');     // everything as we found it at start.
        comport1.WriteStr('C');     // So we reset all the leds to OFF
        comport1.WriteStr('D');
        comport1.WriteStr('E');
        ComPort1.Close;
        end
end;

procedure TledForm.btn_loopClick(Sender: TObject);
begin

// We turn off all Led Check Boxes to allow a clean state before and after Knight Rider Demo mode
      chk_led1.Checked:=false;
      chk_led2.Checked:=false;
      chk_led3.Checked:=false;
      chk_led4.Checked:=false;
      chk_led5.Checked:=false;


// Here begins the rough mode of Knight Rider Demo ;)

        comport1.WriteStr('1');
        Sleep(50);
        comport1.WriteStr('A');
        Sleep(50);
        comport1.WriteStr('2');
        Sleep(50);
        comport1.WriteStr('B');
        Sleep(50);
        comport1.WriteStr('3');
        Sleep(50);
        comport1.WriteStr('C');
        Sleep(50);
        comport1.WriteStr('4');
        Sleep(50);
        comport1.WriteStr('D');
        Sleep(50);
        comport1.WriteStr('5');
        Sleep(50);
        comport1.WriteStr('E');
        Sleep(50);

        comport1.WriteStr('4');
        Sleep(50);
        comport1.WriteStr('D');
        Sleep(50);
        comport1.WriteStr('3');
        Sleep(50);
        comport1.WriteStr('C');
        Sleep(50);
        comport1.WriteStr('2');
        Sleep(50);
        comport1.WriteStr('B');
        Sleep(50);
        comport1.WriteStr('1');
        Sleep(50);
        comport1.WriteStr('A');
        Sleep(50);
end;

end.

// That's it!!! Pat yourself on the back if you made your way thru all this bad written code :P
