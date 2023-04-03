//include for eliZaX 

const BTNLINE = 400;
      EDITBASE = 70;

var
  frm: TForm;
  yourMemo, elizaMemo: TMemo;
  TypeHere, ElizaReply: TEdit;
  histBtn, closeBtn, okBtn : TButton;
  elizalbl, youlbl, titelbl: TLabel;
  
  
procedure CloseClick(Sender: TObject);
begin
  frm.close;
end;

procedure BitBtn2Click(Sender: TObject);
begin
  YourMemo.visible:= not YourMemo.visible;
  ElizaMemo.visible:= not ElizaMemo.visible;
end;


procedure FormKeyPress(Sender: TObject; var Key: Char);
begin
 //if Key =  #13 
   //then FormClick(self);
 if Key = #27 then frm.close;
end;

  

function loadElizaForm : TForm;
var form : TForm;
begin
  form:= TForm.create(self);
  frm:= form;
  elizaLbl:= TLabel.create(form);
  youLbl:= TLabel.create(form);
  titelbl:= TLabel.create(form);
  yourMemo:= TMemo.create(form);
  elizaMemo:= TMemo.create(form);
  typeHere:= TEdit.create(form);
  ElizaReply:= TEdit.create(form)
  okBtn:= TButton.create(form);
  histBtn:= TButton.create(form);
  closeBtn:= TButton.create(form);
  try
    with form do begin
      caption:= '*************ElizaX**************';  
      height:= 500;
      width:= 580;
      color:= clpurple;
      Position:= poScreenCenter;
      onKeyPress:= @FormKeyPress
      show;
    end;
    with yourMemo do begin
      parent:= form;
      setbounds(370,220,180,150);
      font.size:= 10;
      color:= clyellow;
      show
    end;  
    with elizaMemo do begin
      parent:= form;
      setbounds(370,40,180,150);
      font.size:= 10;
      color:= clyellow;
      show
    end;  
    with titelbl do begin
      parent:= form;
      setbounds(30,EDITBASE-20,180,20);
      font.size:= 32;
      font.color:= clyellow;
      font.name:='times';
      caption:= 'Eliza Shrink 20101';
    end;  
    with elizaLbl do begin
      parent:= form;
      setbounds(30,EDITBASE + 60,180,20);
      font.size:= 12;
      font.color:= clyellow;
      caption:= 'Eliza answers:';
    end;  
    with ElizaReply do begin
      parent:= form;
      text:= 'Hello, what would you like to talk about?';
      setbounds(30,EDITBASE + 90,310,60);
      autoSize:= false;
      readOnly:= true;
      font.size:= 12;
      show
    end;  
    with youLbl do begin
      parent:= form;
      setbounds(30,EDITBASE + 165,180,20);
      font.size:= 12;
      font.color:= clyellow;
      caption:= 'Your questions:';
    end;  
    with typeHere do begin
      parent:= form;
      //left,top, w, h
      setbounds(30, EDITBASE + 195,310,20);
      font.size:= 12;
      show
    end; 
    with okBtn do begin
      parent:= form;
      caption:= 'ElizaX';
      setbounds(30,BTNLINE,145,40);
      font.size:= 18;
      show
    end; 
    with histBtn do begin
      parent:= form;
      caption:= 'HistoryX';
      setbounds(210,BTNLINE,145,40);
      font.size:= 18;
      onclick:= @bitbtn2Click;
      show
    end; 
    with closeBtn do begin
      parent:= form;
      caption:= 'CloseX';
      setbounds(390,BTNLINE,145,40);
      font.size:= 18;
      onclick:= @closeClick;
      show
    end;   
    result:= form;
  except
    frm.Free;
    result:= NIL;
    exit
  end  
end;

//begin
//end.

//---code_cleared_checked---