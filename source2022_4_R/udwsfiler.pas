{-Modulename and path: udwsfiler
//
//D:\franktech\Delphmax\dws\DWSServer.mpb
//Category    Access method
//
//Developer kleiner kommunikation
//Last Modification on 30.06.03 17:51:54:
//question is destructor of grid
  descript as a new field on 20.6.03
  modified flag on 30.6.03,
  longer filename, initvalues 12.2.07, LOCs = 152
  add to mX march 2014
//==========================================================================}
unit udwsfiler;


interface
uses
//{$IFDEF Linux}

 Grids;
//{$ELSE}
//  Grids;

// {$ENDIF}


type
 TAppData = record
   Name: string[50];
   size: longint;
   Release: string[30];
   descript: string[80];
 end;

  TBuildAppGrid = class (TObject)
  private
    aGrid: TStringGrid;
    app: TAppData;
    f: file of TAppData;
    FaDatfile: ShortString;
    FModified: Boolean;
  protected
    function GetaDatfile: ShortString;
    procedure SetaDatfile(const Value: ShortString);
  public
    constructor Create_initGrid(vGrid: TStringGrid; const vFile: shortString);
    procedure fillGrid;
    procedure storeGrid;
    property aDatFile: ShortString read GetaDatfile write SetaDatfile;
    property modified: Boolean read FModified write FModified;
  end;


implementation


uses
{$IFDEF Linux}

 QDialogs, QControls, QStdCtrls,
{$ELSE}
 Dialogs, Controls, StdCtrls,
  sysutils;

{$ENDIF}

{
******************************** TBuildAppGrid *********************************
}
constructor TBuildAppGrid.Create_initGrid(vGrid: TStringGrid; const vFile: shortString);
begin
  aGrid:= vGrid;
  aDatfile:= vFile;
  with aGrid do begin
    ScrollBars:= ssVertical;
    FixedRows:= 1;
    FixedCols:= 0;
    ColCount:= 4;
    RowCount:= 2; //title is one row
    DefaultColWidth:= 90;
    DefaultRowHeight:= 20;
  end;
end;

procedure TBuildAppGrid.fillGrid;
var
  crow: Integer;
begin
  crow := 1;
  with aGrid do begin
    Cells[0,0]:= 'Application Name';
    ColWidths[0]:= 140;
    Cells[1,0]:= 'App Size';
    ColWidths[1]:= 60;
    Cells[2,0]:= 'Release Date';
    ColWidths[2]:= 90;
    Cells[3,0]:= 'Description';
    ColWidths[3]:= 120;
    if aDatFile <> '' then begin
      AssignFile(f,aDatFile);
      Reset(f);
      try
        while not Eof(f) do begin
          Read (f, app);
          Cells[0,crow]:= app.Name;
          Cells[1,crow]:= intToStr(app.size);
          Cells[2,crow]:= app.Release;
          Cells[3,crow]:= app.descript;
          Inc(crow);
          RowCount:= crow +1;  //new entry
        end;
      finally
        CloseFile(f);
    end;
   end;// if FileExists...
  end; //with
end;

function TBuildAppGrid.GetaDatfile: ShortString;
begin
  if FileExists(FaDatFile) then
    result:= FaDatFile
  else begin
     AssignFile(f, FaDatFile);
     Rewrite(f);
     closefile(f);
     result:= FaDatFile;
 end;
end;

procedure TBuildAppGrid.SetaDatfile(const Value: ShortString);
begin
  if FaDatfile <> Value then begin
    FaDatfile:= Value;
  end;
end;

procedure TBuildAppGrid.storeGrid;
var
  crow: Integer;
  realRowCount: byte;
begin
  if FModified then
  if MessageDlg('Save Changes in ' +
             aDatFile, mtConfirmation, mbOkCancel,0) = mrOK then begin
     realRowCount:= 0;
     AssignFile(f, aDatfile);
     Rewrite(f);
   try
     for crow:= 1 to Pred(aGrid.RowCount) do begin
       if (aGrid.Cells[0, crow]) <> '' then
       inc(realRowCount)
     end;
     for crow:= 1 to realRowCount do begin
       app.Name:= aGrid.Cells[0, crow];
       app.size:= strToInt(aGrid.Cells[1, crow]);
       app.Release:= aGrid.Cells[2, crow];
       app.descript:= aGrid.Cells[3, crow];
       Write (f, app);
     end;
   finally
     CloseFile(f);
   end;
  end; //if MessageDlg...
end;

end.
