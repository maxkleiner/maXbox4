unit uPSI_TypInfo;
{
  a minimal subset  with  SamePropTypeName
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
  TPSImport_TypInfo = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TypInfo(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TypInfo_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Variants
  ,TypInfo, TypeTrans
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_TypInfo]);
end;

//function SamePropTypeName(const Name1, Name2: ShortString): Boolean;
function SamePropTypeName(const Name1, Name2: ShortString): Boolean;
asm
        { ->    EAX Name1        }
        {       EDX Name2        }
        { <-    True if Same     }
        MOV     CH,[EAX]
        MOV     CL,[EDX]
        CMP     CH,CL
        JE      @@DoCompare
        XOR     EAX,EAX
        RET

@@DoCompare:
        PUSH    EAX
        PUSH    EDX
        MOVZX   ECX,CL
        PUSH    ESI
        PUSH    EDI
        PUSH    ECX
        MOV     ESI,EAX
        MOV     EDI,EDX
        INC     ESI
        INC     EDI
        SHR     ECX,2
        JZ      @@CharLoop

@@Loop:
        MOV     EAX,[ESI]
        TEST    EAX,$80808080
        JNZ     @@Utf8Compare
        MOV     EDX,[EDI]
        TEST    EDX,$80808080
        JNZ     @@UTF8Compare
        XOR     EAX,EDX
        AND     EAX,$5F5F5F5F
        JNZ     @@NotEqual
        ADD     ESI,4
        ADD     EDI,4
        DEC     ECX
        JNZ     @@Loop

@@CharLoop:
        MOV     ECX,[ESP]
        AND     ECX,3
        JZ      @@Equal

@@Loop2:
        MOV     AL,[ESI]
        TEST    AL,$80
        JNZ     @@Utf8Compare
        MOV     DL,[EDI]
        TEST    DL,$80
        JNZ     @@Utf8Compare
        XOR     AL,DL
        AND     AL,$5F
        JNZ     @@NotEqual
        INC     ESI
        INC     EDI
        DEC     ECX
        JNZ     @@Loop2

@@Equal:
        POP     ECX
        POP     EDI
        POP     ESI
        POP     EDX
        POP     EAX
        MOV     EAX,1
        JMP     @@Exit

@@Utf8Compare:
        POP     ECX
        POP     EDI
        POP     ESI
        POP     EDX
        POP     EAX
        //JMP     SameUtf8Text

@@NotEqual:
        POP     ECX
        POP     EDI
        POP     ESI
        POP     EDX
        POP     EAX
        XOR     EAX,EAX
@@Exit:
end;


(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TypInfo(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TTypeKind', '( tkUnknown, tkInteger, tkChar, tkEnumeration, tkFl'
   +'oat, tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString, tk'
   +'Variant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray )');

   { TTypeKind = (tkUnknown, tkInteger, tkChar, tkEnumeration, tkFloat,
    tkString, tkSet, tkClass, tkMethod, tkWChar, tkLString, tkWString,
    tkVariant, tkArray, tkRecord, tkInterface, tkInt64, tkDynArray);}

 CL.AddDelphiFunction('Function PropType( Instance : TObject; const PropName : string) : TTypeKind;');
 CL.AddDelphiFunction('Function PropType1( AClass : TClass; const PropName : string) : TTypeKind;');
 CL.AddDelphiFunction('Function PropIsType( Instance : TObject; const PropName : string; TypeKind : TTypeKind) : Boolean;');
 CL.AddDelphiFunction('Function PropIsType1( AClass : TClass; const PropName : string; TypeKind : TTypeKind) : Boolean;');
 CL.AddDelphiFunction('Function IsStoredProp( Instance : TObject; const PropName : string) : Boolean;');
 CL.AddDelphiFunction('Function IsPublishedProp( Instance : TObject; const PropName : string) : Boolean;');
 CL.AddDelphiFunction('Function IsPublishedProp1( AClass : TClass; const PropName : string) : Boolean;');
 CL.AddDelphiFunction('Function GetOrdProp( Instance : TObject; const PropName : string) : Longint;');
 CL.AddDelphiFunction('Procedure SetOrdProp( Instance : TObject; const PropName : string; Value : Longint);');
 CL.AddDelphiFunction('Function GetEnumProp( Instance : TObject; const PropName : string) : string;');
 CL.AddDelphiFunction('Procedure SetEnumProp( Instance : TObject; const PropName : string; const Value : string);');
 CL.AddDelphiFunction('Function GetSetProp( Instance : TObject; const PropName : string; Brackets : Boolean) : string;');
 CL.AddDelphiFunction('Procedure SetSetProp( Instance : TObject; const PropName : string; const Value : string);');
  CL.AddTypeS('TTypeKinds', 'set of TTypeKind');
  CL.AddTypeS('TOrdType', '( otSByte, otUByte, otSWord, otUWord, otSLong, otULong )');
  CL.AddTypeS('TFloatType', '( ftSingle, ftDouble, ftExtended, ftComp, ftCurr )');
  CL.AddTypeS('TMethodKind', '( mkProcedure, mkFunction, mkConstructor, mkDestr'
   +'uctor, mkClassProcedure, mkClassFunction, mkClassConstructor, mkOperatorOv'
   +'erload, mkSafeProcedure, mkSafeFunction )');
  CL.AddTypeS('TTypeInfo', 'record Kind : TTypeKind; Name : ShortString; end');
 CL.AddDelphiFunction('Function SamePropTypeName( const Name1, Name2 : ShortString) : Boolean');
 CL.AddDelphiFunction('Function FloatToStrEx( Value : Extended) : string');
 CL.AddDelphiFunction('Function StrToFloatEx( const S : string) : Extended');

end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
Procedure SetSetProp_P( Instance : TObject; const PropName : string; const Value : string);
Begin TypInfo.SetSetProp(Instance, PropName, Value); END;

(*----------------------------------------------------------------------------*)
Function GetSetProp_P( Instance : TObject; const PropName : string; Brackets : Boolean) : string;
Begin Result := TypInfo.GetSetProp(Instance, PropName, Brackets); END;

(*----------------------------------------------------------------------------*)
Procedure SetEnumProp_P( Instance : TObject; const PropName : string; const Value : string);
Begin TypInfo.SetEnumProp(Instance, PropName, Value); END;

(*----------------------------------------------------------------------------*)
Function GetEnumProp_P( Instance : TObject; const PropName : string) : string;
Begin Result := TypInfo.GetEnumProp(Instance, PropName); END;

(*----------------------------------------------------------------------------*)
Procedure SetOrdProp_P( Instance : TObject; const PropName : string; Value : Longint);
Begin TypInfo.SetOrdProp(Instance, PropName, Value); END;

(*----------------------------------------------------------------------------*)
Function GetOrdProp_P( Instance : TObject; const PropName : string) : Longint;
Begin Result := TypInfo.GetOrdProp(Instance, PropName); END;

(*----------------------------------------------------------------------------*)
Function IsPublishedProp1_P( AClass : TClass; const PropName : string) : Boolean;
Begin Result := TypInfo.IsPublishedProp(AClass, PropName); END;

(*----------------------------------------------------------------------------*)
Function IsPublishedProp_P( Instance : TObject; const PropName : string) : Boolean;
Begin Result := TypInfo.IsPublishedProp(Instance, PropName); END;

(*----------------------------------------------------------------------------*)
Function IsStoredProp_P( Instance : TObject; const PropName : string) : Boolean;
Begin Result := TypInfo.IsStoredProp(Instance, PropName); END;

(*----------------------------------------------------------------------------*)
Function PropIsType1_P( AClass : TClass; const PropName : string; TypeKind : TTypeKind) : Boolean;
Begin Result := TypInfo.PropIsType(AClass, PropName, TypeKind); END;

(*----------------------------------------------------------------------------*)
Function PropIsType_P( Instance : TObject; const PropName : string; TypeKind : TTypeKind) : Boolean;
Begin Result := TypInfo.PropIsType(Instance, PropName, TypeKind); END;

(*----------------------------------------------------------------------------*)
Function PropType1_P( AClass : TClass; const PropName : string) : TTypeKind;
Begin Result := TypInfo.PropType(AClass, PropName); END;

(*----------------------------------------------------------------------------*)
Function PropType_P( Instance : TObject; const PropName : string) : TTypeKind;
Begin Result := TypInfo.PropType(Instance, PropName); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TypInfo_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@PropType, 'PropType', cdRegister);
 S.RegisterDelphiFunction(@PropType1_P, 'PropType1', cdRegister);
 S.RegisterDelphiFunction(@PropIsType, 'PropIsType', cdRegister);
 S.RegisterDelphiFunction(@PropIsType1_P, 'PropIsType1', cdRegister);
 S.RegisterDelphiFunction(@IsStoredProp, 'IsStoredProp', cdRegister);
 S.RegisterDelphiFunction(@IsPublishedProp, 'IsPublishedProp', cdRegister);
 S.RegisterDelphiFunction(@IsPublishedProp1_P, 'IsPublishedProp1', cdRegister);
 S.RegisterDelphiFunction(@GetOrdProp, 'GetOrdProp', cdRegister);
 S.RegisterDelphiFunction(@SetOrdProp, 'SetOrdProp', cdRegister);
 S.RegisterDelphiFunction(@GetEnumProp, 'GetEnumProp', cdRegister);
 S.RegisterDelphiFunction(@SetEnumProp, 'SetEnumProp', cdRegister);
 S.RegisterDelphiFunction(@GetSetProp, 'GetSetProp', cdRegister);
 S.RegisterDelphiFunction(@SetSetProp, 'SetSetProp', cdRegister);
 S.RegisterDelphiFunction(@SamePropTypeName, 'SamePropTypeName', cdRegister);
 S.RegisterDelphiFunction(@FloatToStrEx, 'FloatToStrEx', cdRegister);
 S.RegisterDelphiFunction(@StrToFloatEx, 'StrToFloatEx', cdRegister);

end;

 
 
{ TPSImport_TypInfo }
(*----------------------------------------------------------------------------*)
procedure TPSImport_TypInfo.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_TypInfo(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_TypInfo.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  //RIRegister_TypInfo(ri);
  RIRegister_TypInfo_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
