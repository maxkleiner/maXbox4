unit uPSI_ByteListClass;
{
mybyte

}
interface
 

 
uses
   SysUtils
  ,Classes
  ,uPSComponent
  ,uPSRuntime
  ,uPSCompiler
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TPSImport_ByteListClass = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TByteListClass(CL: TPSPascalCompiler);
procedure SIRegister_ByteListClass(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_ByteListClass_Routines(S: TPSExec);
procedure RIRegister_TByteListClass(CL: TPSRuntimeClassImporter);
procedure RIRegister_ByteListClass(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   RTLConsts
  ,ByteListClass
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_ByteListClass]);
end;

//https://howtosolves.de/q/1-is-there-an-inverse-function-of-sysutils-format-in-delphi

 function NumStringParts(SourceStr,Delimiter:String):Integer;
var
  offset : integer;
  curnum : integer;
begin
  curnum := 1;
  offset := 1;
  while (offset <> 0) do
    begin
      Offset := Pos(Delimiter,SourceStr);
      if Offset <> 0 then
        begin
          Inc(CurNum);
            Delete(SourceStr,1,(Offset-1)+Length(Delimiter));
        end;
    end;
  result := CurNum;
end;

function GetStringPart(SourceStr,Delimiter:String;Num:Integer):string;
var
  offset : integer;
  CurNum : integer;
  CurPart : String;
begin
  CurNum := 1;
  Offset := 1;
  While (CurNum <= Num) and (Offset <> 0) do
    begin
      Offset := Pos(Delimiter,SourceStr);
      if Offset <> 0 then
        begin
          CurPart := Copy(SourceStr,1,Offset-1);
          Delete(SourceStr,1,(Offset-1)+Length(Delimiter));
          Inc(CurNum)
        end
      else
        CurPart := SourceStr;
    end;
  if CurNum >= Num then
    Result := CurPart
  else
    Result := '';
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TByteListClass(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TByteListClass') do
  with CL.AddClassN(CL.FindClass('TObject'),'TByteListClass') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Function Add( Item : Byte) : Integer');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure SaveToStream( const S : TStream)');
    RegisterMethod('Procedure LoadFromStream( const S : TStream; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure SaveToFile( FileName : string)');
    RegisterMethod('Procedure LoadFromFile( FileName : string; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure Delete( Index : Integer)');
    RegisterMethod('Function ErrMsg( const Msg : string; Data : Integer) : string');
    RegisterMethod('Procedure Exchange( Index1, Index2 : Integer)');
    RegisterMethod('Function Expand : TByteList');
    RegisterMethod('Function First : Byte');
    RegisterMethod('Function IndexOf( Value : Byte) : Integer');
    RegisterMethod('Procedure Insert( Index : Integer; Item : Byte)');
    RegisterMethod('Function Last : Byte');
    RegisterMethod('Procedure Move( CurIndex, NewIndex : Integer)');
    RegisterMethod('Function Remove( Item : Byte) : Integer');
    RegisterMethod('Procedure Pack( NilValue : Byte)');
    RegisterMethod('Procedure Sort( Compare : TByteListSortCompare)');
    RegisterMethod('Procedure SortUp');
    RegisterMethod('Procedure SortDown');
    RegisterMethod('Procedure ShowList( StringList : TStrings; Descriptor : TByteDescriptor; ClearIt : Boolean)');
    RegisterMethod('Function Minimum : Byte');
    RegisterMethod('Function Maximum : Byte');
    RegisterMethod('Function Range : Byte');
    RegisterMethod('Function Sum : Extended');
    RegisterMethod('Function SumSqr : Extended');
    RegisterMethod('Function Average : Extended');
    RegisterMethod('Procedure CopyFrom( List : TByteList; const KeepCurrentSortType : Boolean)');
    RegisterMethod('Procedure CopyTo( List : TByteList; const KeepDestSortType : Boolean)');
    RegisterMethod('Procedure Push( Value : Byte)');
    RegisterMethod('Function LifoPop( DefValue : Byte) : Byte');
    RegisterMethod('Function FifoPop( DefValue : Byte) : Byte');
    RegisterProperty('List', 'PBytePtrList', iptr);
    RegisterProperty('Capacity', 'Integer', iptrw);
    RegisterProperty('Count', 'Integer', iptrw);
    RegisterProperty('Items', 'Byte Integer', iptrw);
    SetDefaultPropery('Items');
    RegisterProperty('SortType', 'TByteSortOption', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_ByteListClass(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('SByteListVoidError','String').SetString( 'Invalid method call (empty list)!');
 CL.AddConstantN('SByteListSortError','String').SetString( 'Invalid method call (sorted list)!');
  //CL.AddTypeS('PBytePtrList', '^TBytePtrList // will not work');
  CL.AddTypeS('TByteSortOption', '( ByteSortNone, ByteSortUpWithDup, ByteSortUp'
   +'NoDup, ByteSortDownWithDup, ByteSortDownNoDup )');

    CL.AddTypeS('TBytePtrList', 'array of Byte');
    { TDoubleListSortCompare
   = function (Item1, Item2: Double): Integer;
    TDoubleDescriptor
   = function (Index:Integer;Item : Double) : string;  }

     CL.AddTypeS('TByteListSortCompare', 'function (Item1, Item2: Byte): Integer;');
      CL.AddTypeS('TByteDescriptor', 'function (Index:Integer;Item : Byte) : string;');
  SIRegister_TByteListClass(CL);
 CL.AddDelphiFunction('Function DefDescByte( Index : Integer; Item : Byte) : string');
 CL.AddDelphiFunction('function NumStringParts(SourceStr,Delimiter:String):Integer');
 CL.AddDelphiFunction('function GetStringPart(SourceStr,Delimiter:String;Num:Integer):string');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TByteListClassSortType_W(Self: TByteListClass; const T: TByteSortOption);
begin Self.SortType := T; end;

(*----------------------------------------------------------------------------*)
procedure TByteListClassSortType_R(Self: TByteListClass; var T: TByteSortOption);
begin T := Self.SortType; end;

(*----------------------------------------------------------------------------*)
procedure TByteListClassItems_W(Self: TByteListClass; const T: Byte; const t1: Integer);
begin Self.Items[t1] := T; end;

(*----------------------------------------------------------------------------*)
procedure TByteListClassItems_R(Self: TByteListClass; var T: Byte; const t1: Integer);
begin T := Self.Items[t1]; end;

(*----------------------------------------------------------------------------*)
procedure TByteListClassCount_W(Self: TByteListClass; const T: Integer);
begin Self.Count := T; end;

(*----------------------------------------------------------------------------*)
procedure TByteListClassCount_R(Self: TByteListClass; var T: Integer);
begin T := Self.Count; end;

(*----------------------------------------------------------------------------*)
procedure TByteListClassCapacity_W(Self: TByteListClass; const T: Integer);
begin Self.Capacity := T; end;

(*----------------------------------------------------------------------------*)
procedure TByteListClassCapacity_R(Self: TByteListClass; var T: Integer);
begin T := Self.Capacity; end;

(*----------------------------------------------------------------------------*)
procedure TByteListClassList_R(Self: TByteListClass; var T: PBytePtrList);
begin T := Self.List; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ByteListClass_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@DefDescByte, 'DefDescByte', cdRegister);
 S.RegisterDelphiFunction(@NumStringParts, 'NumStringParts', cdRegister);
S.RegisterDelphiFunction(@GetStringPart, 'GetStringPart', cdRegister);

end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TByteListClass(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TByteListClass) do begin
    RegisterConstructor(@TByteListClass.Create, 'Create');
    RegisterMethod(@TByteListClass.Destroy, 'Free');
    RegisterMethod(@TByteListClass.Add, 'Add');
    RegisterMethod(@TByteListClass.Clear, 'Clear');
    RegisterMethod(@TByteListClass.SaveToStream, 'SaveToStream');
    RegisterMethod(@TByteListClass.LoadFromStream, 'LoadFromStream');
    RegisterMethod(@TByteListClass.SaveToFile, 'SaveToFile');
    RegisterMethod(@TByteListClass.LoadFromFile, 'LoadFromFile');
    RegisterMethod(@TByteListClass.Delete, 'Delete');
    RegisterMethod(@TByteListClass.ErrMsg, 'ErrMsg');
    RegisterMethod(@TByteListClass.Exchange, 'Exchange');
    RegisterMethod(@TByteListClass.Expand, 'Expand');
    RegisterMethod(@TByteListClass.First, 'First');
    RegisterMethod(@TByteListClass.IndexOf, 'IndexOf');
    RegisterMethod(@TByteListClass.Insert, 'Insert');
    RegisterMethod(@TByteListClass.Last, 'Last');
    RegisterMethod(@TByteListClass.Move, 'Move');
    RegisterMethod(@TByteListClass.Remove, 'Remove');
    RegisterMethod(@TByteListClass.Pack, 'Pack');
    RegisterMethod(@TByteListClass.Sort, 'Sort');
    RegisterMethod(@TByteListClass.SortUp, 'SortUp');
    RegisterMethod(@TByteListClass.SortDown, 'SortDown');
    RegisterMethod(@TByteListClass.ShowList, 'ShowList');
    RegisterMethod(@TByteListClass.Minimum, 'Minimum');
    RegisterMethod(@TByteListClass.Maximum, 'Maximum');
    RegisterMethod(@TByteListClass.Range, 'Range');
    RegisterMethod(@TByteListClass.Sum, 'Sum');
    RegisterMethod(@TByteListClass.SumSqr, 'SumSqr');
    RegisterMethod(@TByteListClass.Average, 'Average');
    RegisterMethod(@TByteListClass.CopyFrom, 'CopyFrom');
    RegisterMethod(@TByteListClass.CopyTo, 'CopyTo');
    RegisterMethod(@TByteListClass.Push, 'Push');
    RegisterMethod(@TByteListClass.LifoPop, 'LifoPop');
    RegisterMethod(@TByteListClass.FifoPop, 'FifoPop');
    RegisterPropertyHelper(@TByteListClassList_R,nil,'List');
    RegisterPropertyHelper(@TByteListClassCapacity_R,@TByteListClassCapacity_W,'Capacity');
    RegisterPropertyHelper(@TByteListClassCount_R,@TByteListClassCount_W,'Count');
    RegisterPropertyHelper(@TByteListClassItems_R,@TByteListClassItems_W,'Items');
    RegisterPropertyHelper(@TByteListClassSortType_R,@TByteListClassSortType_W,'SortType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_ByteListClass(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TByteListClass(CL);
end;

 
 
{ TPSImport_ByteListClass }
(*----------------------------------------------------------------------------*)
procedure TPSImport_ByteListClass.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_ByteListClass(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_ByteListClass.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_ByteListClass(ri);
  RIRegister_ByteListClass_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
