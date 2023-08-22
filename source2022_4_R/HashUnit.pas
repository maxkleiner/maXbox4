unit HashUnit;

interface
type



  THashObject=class(TObject)
    s:string;
    t:TObject;
  end;

  THashObjectArray = array of THashObject;

  THashStr = class(TObject)
    test: THashObjectArray;
    maxhash:integer;
    maxloadfactor:single;
    maxused:integer; {based on maxloading factor from create}
    used:integer;  {number of table positions occupied}
    {Fields just to keep stats for testing}
    nbrcollisions:integer;
    maxcollisions:integer; {longest collision set}
    constructor create(newmaxhash:integer; newmaxloading:single);
    destructor destroy;    override;
    function exists(s:string;var T:TObject):boolean;
    function AddIfNotDup(s:string;t:Tobject):boolean;
    procedure  resethash;
    procedure rehash;
    function hash(s:string):integer;
  end;

implementation
  uses sysutils, classes, dialogs;

 {Thash Methods}

  {***************** THash.Create ******************}
  constructor THashStr.create(newmaxhash:integer; newmaxloading:single);
  {Create THash object}
  begin
    inherited create;
    maxhash:=newmaxHash;
    setlength(test,maxhash);
    maxloadfactor:=newmaxloading;
    resethash;
    {maxused:=trunc(newmaxloading*maxhash);}
  end;

  function THashStr.hash(s:string):integer;
  var
    i:integer;
  begin
    result:=1;
    for i:=1 to length(s) do result:=(result * ord(s[i])) mod length(test);
  end;

  destructor THashStr.destroy;
  {destroy it - probably not necessary}
  begin
    setlength(test,0);
    inherited;
  end;

  procedure THashStr.resethash;
  var
    i:integer;
  begin
    {zero out the array of hashed values}
    setlength(test,maxhash);
    for i:= 0 to length(test)-1 do test[i]:=nil;
    nbrcollisions:=0;
    maxcollisions:=0;
    used:=0;
    maxused:= trunc(maxloadfactor*maxhash);
  end;

 function THashStr.exists(s:string;var t:TObject):boolean;

    function scansuccess(start,stopper:integer; var found:boolean):boolean;
      var
        i:integer;
      begin
        result:=true;
        found:=false;
        i:=start;
        while (i < stopper) and (test[i]<>nil) and (comparetext(test[i].s,s)<>0) do inc(i);
        {statistics keeping}
        {nbrcollisions:=nbrcollisions+(i-start);  }
        {if (i-start)>maxcollisions then maxcollisions:=i-start;}
        If i<stopper then
        begin
          if (test[i]=nil) then  found:=false
          else if Comparetext(test[i].s,s)=0 then
          begin
            t:=test[i].t;
            found:=true;
          end
          else result:=false;
        end;
      end;

  var
    h:integer;
    found:boolean;
  begin
    found:=false; result:=false;
    h:=hash(s);
    if h>length(test) then exit;
    if not scansuccess(h,length(test),found)
    then {loop around and try from beginning} scansuccess(0,h,found);
    result:=found;
  end;


  {***************** AddIfNotDup *********************}
  function THashStr.AddIfNotDup(s:string; t:TObject):boolean;

      function scansuccess(start,stopper:integer; var found:boolean):boolean;
      var
        i:integer;
      begin
        result:=true;
        found:=false;
        i:=start;
        while (i < stopper) and (test[i]<>nil) and (comparetext(test[i].s,s)<>0) do inc(i);
        {statistics keeping}
        {nbrcollisions:=nbrcollisions+(i-start);  }
        {if (i-start)>maxcollisions then maxcollisions:=i-start;}
        If i<stopper then
        begin
          if test[i]=nil then
          begin
            test[i]:=THashObject.create;
            test[i].s:=s;
            test[i].t:=t;
            found:=true;
            inc(used);
            if used>maxused then  rehash;
          end
          else if comparetext(test[i].s,s)<>0 then result:=false;
        end;
     end;

  var
    h:integer;
    found:boolean;
  begin
    h:=hash(s);
    if not scansuccess(h,length(test),found) then {loop around and try from beginning}
    If not scansuccess(0,h,found) then
    begin
      {Could make this a warning and expand hash table}
      {To do that, we'd have to copy over existing data to temp array,
       expand the hash table with new maxhash, then rehash all numbers into the
       expanded table and make a recursive call to AddIfNotDup for the current N}
     { showmessage('Hash failed - table is full, contact vendor');}
      found:=false;
    end;
    result:=found;
  end;

  procedure thashstr.rehash;
  {Max load factor exceeded, rehash everything}
  var
    list:TStringlist;
    i:integer;
  begin
    list:=Tstringlist.create;
    for i:= 0 to length(test)-1 do
    if test[i]<>nil then list.addobject(test[i].s,test[i]);
    if list.count<>used
    then showmessage('Invalid count on rehash, contactvendor');
    setlength(test,length(test)+maxhash);
    resethash;
    for i:=0 to list.count-1 do addifnotdup(list[i],list.objects[i]);
    list.free;
  end;


end.
