{********************************************************************}
{  Read/Write routine for varArray variant                           }
{     based  on System.pas , Delphi 5                                }
{                                                                    }
{     Copyright (c)  04.2000 by                                      }
{     V.A.Pronov  email: VAPronov@usa.net                            }
{             and Serge Buzadzhy                                     }
{     email:  serge_buzadzhy@mail.ru,                                }
{             FidoNet: 2:467/44.37                                   }
{                                                                    }
{********************************************************************}


unit VariantRtn;

interface

uses   Windows, Messages, SysUtils, variants;

type
// CallBack procedures definitions
      TProcReadElementValue=procedure (Value:Variant; IndexValue:array of integer;
       const HighBoundInd:integer;
       Var Continue:boolean
      );
      TProcWriteElementValue=
       procedure (OldValue:Variant; IndexValue:array of integer;
        Var NewValue:Variant;  Var Continue:boolean
       );
//  End CallBack procedures definitions


function SafeVarArrayCreate(const Bounds: array of Integer;
 VarType,DimCount: Integer):Variant;

function VarArrayGet(const A: Variant; const Indices: array of Integer;
 const HighBound:integer
):Variant;

procedure VarArrayPut
 (var A: Variant; const Value: Variant; const Indices: array of Integer;
  const HighBound:integer
);


function CycleReadArray(vArray:Variant;CallBackProc:TProcReadElementValue):boolean;
function CycleWriteArray(var vArray:Variant;CallBackProc:TProcWriteElementValue):boolean;

function CompareVarArray1(vArray1,vArray2:Variant):boolean;
function EasyCompareVarArray1(vArray1,vArray2:Variant;HighBound:integer):boolean;

implementation


function EasyCompareVarArray1(vArray1,vArray2:Variant;HighBound:integer)
 :boolean;
var j:integer;
begin
 Result:=false;
 try
    for j:=0 to HighBound do begin
      if vArray1[j]<>vArray2[j] then Exit;
    end;
    Result:=true
 except
 end
end;

function CompareVarArray1(vArray1,vArray2:Variant):boolean;
var j,l,h:integer;
begin
  Result:=false;
 try
  if VarIsArray(vArray1) and VarIsArray(vArray2) then begin
    h:=VarArrayHighBound(vArray1,1);
    l:=VarArrayLowBound(vArray1,1);
    for j:=l to h do begin
      if vArray1[j]<>vArray2[j] then Exit;
    end;
    Result:=true
  end
 except
 end
end;

const   oleaut = 'oleaut32.dll';
        MaxDimCount=64;
//
threadvar
  CurIndex: array[0..MaxDimCount] of Longint;
//  CurIndex: array of Longint;

// Cut from System.pas
function SafeArrayGetElement(VarArray: PVarArray; Indices,
  Data: Pointer): Integer; stdcall;
  external oleaut name 'SafeArrayGetElement';

function SafeArrayPutElement(VarArray: PVarArray; Indices,
  Data: Pointer): Integer; stdcall;
  external oleaut name 'SafeArrayPutElement';

function SafeArrayPtrOfIndex(VarArray: PVarArray; Indices: Pointer;
  var pvData: Pointer): HResult; stdcall;
  external oleaut name 'SafeArrayPtrOfIndex';

function SafeArrayCreate(VarType, DimCount: Integer;
  const Bounds): PVarArray; stdcall;
  external oleaut name 'SafeArrayCreate';




function GetVarArray(const A: Variant): PVarArray;
begin
  if TVarData(A).VType and varByRef <> 0 then
    Result := PVarArray(TVarData(A).VPointer^) else
    Result := TVarData(A).VArray;
end;


// End Cut
  
function NextElements(v: Variant): boolean;
var
  Dimensions: integer;
  i: integer;
begin
  Result := False;
  Dimensions := VarArrayDimCount(v);
  for i := Dimensions-1 downto 0 do begin
    if CurIndex[i] = VarArrayHighBound(v,i+1) then begin
      CurIndex[i] := VarArrayLowBound(v,i+1);
    end else begin
      CurIndex[i] := CurIndex[i]+1;
      Result := True;
      Exit;
    end;
  end;
end;


procedure InitializationCurIndexArray(vArray:Variant);
var
  i: integer;
  Dimensions: integer;
begin
  Dimensions := VarArrayDimCount(vArray);
  for i:=0 to Dimensions-1 do
    CurIndex[i]:= VarArrayLowBound(vArray,i+1);
  for i := Dimensions to MaxDimCount do
    CurIndex[i] := 0;
end;



function CycleReadArray(vArray:Variant;CallBackProc:TProcReadElementValue):boolean;
var
  Value: Variant;
  HighBoundInd:integer;
begin
 Result:=false;
 if not Assigned(CallBackProc) then Exit;
 if not VarIsArray(vArray) then Exit;

 InitializationCurIndexArray(vArray);

  HighBoundInd:=VarArrayDimCount(vArray)-1;
  repeat
    Value:= VarArrayGet(vArray, CurIndex,HighBoundInd);
    Result:=true;
    CallBackProc(Value,CurIndex,HighBoundInd,Result);
    if not Result then Exit;
    if not NextElements(vArray) then Break;
  until False;
end;


// Cut from System.pas

procedure VarStringToOleStr(var Dest: Variant; const Source: Variant);
var
  OleStrPtr: PWideChar;
begin
  OleStrPtr := StringToOleStr(string(TVarData(Source).VString));
  VarClear(Dest);
  TVarData(Dest).VType := varOleStr;
  TVarData(Dest).VOleStr := OleStrPtr;
end;                    
// end Cut from System.pas

function CycleWriteArray
 (var vArray:Variant;CallBackProc:TProcWriteElementValue):boolean;
var
  OldValue,NewValue: Variant;
  HighBoundInd:integer;
begin
// vArray - Variant array of Variant
 Result:=false;
 if not Assigned(CallBackProc) then Exit;
 InitializationCurIndexArray(vArray);
 HighBoundInd:=VarArrayDimCount(vArray)-1;
 repeat
    OldValue:=VarArrayGet(vArray, CurIndex,HighBoundInd);
    Result:=true;
    CallBackProc(OldValue,CurIndex,NewValue,Result);
    if not Result then Exit;
    VarArrayPut(vArray, NewValue, CurIndex ,HighBoundInd);
    if not NextElements(vArray) then Break;
 until False;
end;



const
  reVarNotArray   ='Variant is not an array.';
  reVarArrayBounds='Variant array index out of bounds.';
  reVarArrayCreate='Can''t create variant array ';

//Cut From System
function SafeVarArrayCreate(const Bounds: array of Integer;
 VarType,DimCount: Integer):Variant;
var
  I: Integer;
  VarArrayRef: PVarArray;
  VarBounds: array[0..MaxDimCount-1] of TVarArrayBound;
begin
  if not DimCount>64 then
    raise Exception.Create(reVarArrayCreate);
  for I := 0 to DimCount - 1 do
    with VarBounds[I] do
    begin
      LowBound := Bounds[I * 2];
      ElementCount := Bounds[I * 2 + 1] - LowBound + 1;
    end;
  VarArrayRef := SafeArrayCreate(VarType, DimCount, VarBounds);
  if VarArrayRef = nil then
   raise Exception.Create('Can''t create array');
  VarClear(Result);
  TVarData(Result).VType := VarType or varArray;
  TVarData(Result).VArray := VarArrayRef;
end;


function _VarArrayGet(var A: Variant; IndexCount: Integer;
  Indices: Integer): Variant; cdecl;
var
  VarArrayPtr: PVarArray;
  VarType: Integer;
  P: Pointer;
begin
  if TVarData(A).VType and varArray = 0 then
   raise Exception.Create(reVarNotArray);
  VarArrayPtr := GetVarArray(A);
  if VarArrayPtr^.DimCount <> IndexCount then
     raise Exception.Create(reVarArrayBounds);
  VarType := TVarData(A).VType and varTypeMask;
  VarClear(Result);
  if VarType = varVariant then
  begin
    if SafeArrayPtrOfIndex(VarArrayPtr, @Indices, P) <> 0 then
     raise Exception.Create(reVarArrayBounds);
    Result := PVariant(P)^;
  end else
  begin
  if SafeArrayGetElement(VarArrayPtr, @Indices,
      @TVarData(Result).VPointer) <> 0 then;
     raise Exception.Create(reVarArrayBounds);
    TVarData(Result).VType := VarType;
  end;
end;

function VarArrayGet(const A: Variant; const Indices: array of Integer;
 const HighBound:integer
): Variant;
asm
        {     ->EAX     Pointer to A            }
        {       EDX     Pointer to Indices      }
        {       ECX     High bound of Indices   }
        {       [EBP+8] Pointer to result       }

        MOV     ECX,HighBound
        PUSH    EBX

        MOV     EBX,ECX
        INC     EBX
        JLE     @@endLoop
@@loop:
        PUSH    [EDX+ECX*4].Integer
        DEC     ECX
        JNS     @@loop
@@endLoop:
        PUSH    EBX
        PUSH    EAX
        MOV     EAX,[EBP+8]
        PUSH    EAX
        CALL    _VarArrayGet
        LEA     ESP,[ESP+EBX*4+3*4]

        POP     EBX
end;


procedure _VarArrayPut(var A: Variant; const Value: Variant;
  IndexCount: Integer; Indices: Integer); cdecl;
var
  VarArrayPtr: PVarArray;
  VarType: Integer;
  P: Pointer;
  Temp: TVarData;
begin
  if TVarData(A).VType and varArray = 0 then
       raise Exception.Create(reVarNotArray);
  VarArrayPtr := GetVarArray(A);
  if VarArrayPtr^.DimCount <> IndexCount then
       raise Exception.Create(reVarArrayBounds);
  VarType := TVarData(A).VType and varTypeMask;
  if (VarType = varVariant) and (TVarData(Value).VType <> varString) then
  begin
    if SafeArrayPtrOfIndex(VarArrayPtr, @Indices, P) <> 0 then
     raise Exception.Create(reVarArrayBounds);
    PVariant(P)^ := Value;
  end else
  begin
    Temp.VType := varEmpty;
    try
      if VarType = varVariant then
      begin
        VarStringToOleStr(Variant(Temp), Value);
        P := @Temp;
      end else
      begin
        VarCast(Variant(Temp), Value, VarType);
        case VarType of
          varOleStr, varDispatch, varUnknown:
            P := Temp.VPointer;
        else
          P := @Temp.VPointer;
        end;
      end;
      if SafeArrayPutElement(VarArrayPtr, @Indices, P) <> 0 then
     raise Exception.Create(reVarArrayBounds);
    finally
      VarClear(Variant(Temp));
    end;
  end;
end;


procedure VarArrayPut(var A: Variant; const Value: Variant; const Indices: array of Integer;
 const HighBound:integer
);
asm
        {     ->EAX     Pointer to A            }
        {       EDX     Pointer to Value        }
        {       ECX     Pointer to Indices      }
        {       [EBP+8] High bound of Indices   }
// Add HighBound Variable

        PUSH    EBX

//        MOV     EBX,[EBP+8]
        MOV     EBX,HighBound
        TEST    EBX,EBX
        JS      @@endLoop
@@loop:
        PUSH    [ECX+EBX*4].Integer
        DEC     EBX
        JNS     @@loop
@@endLoop:
//        MOV     EBX,[EBP+8]
        MOV     EBX,HighBound
        INC     EBX
        PUSH    EBX
        PUSH    EDX
        PUSH    EAX
        CALL    _VarArrayPut
        LEA     ESP,[ESP+EBX*4+3*4]

        POP     EBX
end;
// end Cut from System.pas
end.





