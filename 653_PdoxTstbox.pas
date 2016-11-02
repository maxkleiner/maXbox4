unit PdoxTst_mX4;

//http://www.softwareschule.ch/images/maxbox4_ubuntu14_weatherCapture.PNG

interface
//uses Windows, SysUtils, Classes, Forms, Controls, StdCtrls, Buttons, Paradox;

//type TPdox = class(TForm)
    
    var
    ClearBtn: TButton;
    CloseBtn: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    FindBtn: TButton;
    aMemo1: TMemo;
    NextBtn: TButton;
    procedure BtnClick(Sender: TObject);
    procedure TrapDoor(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
  //private
  //public
  //end;

VAR Pdox: TForm; //TPdox;

implementation  //{$R *.DFM}
var  Pdx: TParadox; // =nil;  
 const  NL = #13+#10;

{---- My Test ----------------------------------------------------------------}
procedure TrapDoor(Sender: TObject; Button: TMouseButton;
	  Shift: TShiftState; X, Y: Integer);  begin
  If (Sender=Edit1) and (ssAlt in Shift) and (Button=mbRight) Then begin
    If Pdx<>nil Then Pdx.Close;
    Edit1.Text := '\apa\data\thesaurs.db';  Edit2.Text := '23100';
    end{If Sender=Edit1};   end{TrapDoor};

{---- Test Direct File I/O for Paradox tables --------------------------------}
procedure BtnClick(Sender: TObject);
  var  i,j,L,fnd: Integer;  v: Int64;  dt: TDateTime;  S: String;
    blobrec: aPdoxBlob;
begin
  If Pdx=nil Then begin   Pdx := TParadox.Create(Self);
      Pdx.Name := 'MyPdx';  Pdx.ReadOnly := False;   end;
  If not Pdx.Active Then begin
    Try Pdx.TableName := Edit1.Text;  Pdx.Open;  Except;  end;
    Pdox.Caption := 'Test Paradox Table: '+Pdx.TableName+'  v'+Pdx.Version;   end;
  If Sender=CloseBtn Then begin  Pdx.Close;  Exit;  end;
  If Sender=ClearBtn Then begin  aMemo1.Clear;  Exit;   end;
  If (Sender=Edit2) and (edit1.text='sample.db') Then begin
    Pdx.First;  Pdx.WriteField(0,Edit2.Text);  Exit;   end;
  If Sender=FindBtn Then begin   S := Edit2.Text;  fnd := 0;
    If Pdx.KeyFields=0 Then begin {No Primary Key: Use Locate}
      If Pdx.Locate([0],[S]) Then fnd := 1;   end
    Else begin  j := Pos(';',S); {Up to 2 Key Flds using ";"}
      If j=0 Then begin  If Pdx.FindKey([S]) Then fnd := 2;  end {1 Key Fld}
      Else If Pdx.FindKey([Copy(S,1,j-1),Copy(S,j+1,99)]) Then
	fnd := 3; {2 Key Flds}   end{Else};
    If fnd=0 Then begin
      aMemo1.Lines.Add('<<'+S+' Not Found>>');  Exit;   end;   end{If =FindBtn};
  If Sender<>NextBtn Then Exit;
  If Pdx.EOF Then begin  aMemo1.Lines.Add('<<EOF>>');  Pdx.Close;  Exit;   end;
  For i := 0 to Pdx.FieldCount-1 Do begin {Dump the record}
    S := Pdx.FieldName(i)+': '+Pdx.Field(i);  v := Pdx.FieldAsInteger(i);
    If v>4000000000000000000 Then begin   
    //Move(v,dt,8); {Move to DateTime}
      S := S+' (AsDT='+FloatToStr(dt)+')';   end
    Else If v>0 Then S := S+' (AsInt='+IntToStr(Pdx.FieldAsInteger(i))+')';
    For j := 1 to Length(S) Do {Memos don't like ctrl chars}
      If S[j]<' ' Then S[j] := '.';
    If Pdx.FieldType(i)=12 Then begin {Memo Blob}
       blobrec:= Pdx.BlobInfo;
      L := blobrec.Length; 
       j := Pos(':',S);  S[j] := '>';
      SetLength(S,L+j+1);
      //Pdx.GetBlob(i,L,S[j+2]);   
      end{If Pdx.FieldType};
    If Pos(':',S)<>Length(S)-1 Then aMemo1.Lines.Add(S);   end{For i};
  aMemo1.Lines.Add('- - - - - -');  Pdx.Next;
  end{PdoxBtnClick};
  
  procedure openParadox(Sender: TObject);
  var  i,j,L,fnd: Integer;  v: Int64;  dt: TDateTime;  S: String;
    blobrec: aPdoxBlob;
begin
  pdx:= NIL;
  If Pdx=nil Then begin   
    Pdx := TParadox.Create(Self);
      Pdx.Name := 'MyPdxbox3';  
      Pdx.ReadOnly := False;
         end;
  If not Pdx.Active Then begin
    Try 
      Pdx.TableName:= 
         'C:\Program Files (x86)\maxbox3\Import\Paradox\sample.db';  
      Pdx.Open;
      pdx.close;
      pdx.free;  
    Except;  
      writeln('except: could not open')
    end;
  end;
 end;
 

begin

 openParadox(self);  
 
 if ISInternet then
   //openIE('http://www.softwareschule.ch/images/maxbox4_ubuntu14_weatherCapture.PNG');
   //OpenURLWithShell( const AText : TKkString)');  
   OpenURLWithShell('http://www.softwareschule.ch/images/maxbox4_ubuntu14_weatherCapture.PNG');
END.

