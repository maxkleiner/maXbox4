

procedure TurtleEasy9(afrm: TForm);
//var cfrm: Tform;
begin
  with TJVTurtle.create(self) do begin
    canvas:= afrm.canvas;
    canvas.Pen.Color:= clred;
    penDown:= true;
    penWidth:= 10;
    setpos(100,150)
    movebackward(50)
    left(90)    
    moveforward(50)
    right(90)
    moveforward(50)
    right(90)    
    moveforward(100)
    right(90)
    moveforward(50)
   end;
end;     

//BEGIN  //Main
//LoadForm;
//TurtleEasy9;
//END. 

//----app_template_loaded_code----
//----File newtemplate.txt not exists - now saved!----