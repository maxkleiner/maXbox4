unit uPSI_CromisStreams;
{
  check ustring, astring   streamdream

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
  TPSImport_CromisStreams = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TStreamStorage(CL: TPSPascalCompiler);
procedure SIRegister_IStorageStream(CL: TPSPascalCompiler);
procedure SIRegister_TNamesEnumerator(CL: TPSPascalCompiler);
procedure SIRegister_CromisStreams(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TStreamStorage(CL: TPSRuntimeClassImporter);
procedure RIRegister_TNamesEnumerator(CL: TPSRuntimeClassImporter);
procedure RIRegister_CromisStreams_Routines(S: TPSExec);

procedure Register;

implementation


uses
   Math
  ,IniFiles
  ,CromisStreams, Cromis.Unicode;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_CromisStreams]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TStreamStorage(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TStreamStorage') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TStreamStorage') do begin
    RegisterMethod('Constructor Create');
       RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure Assign( const StreamStorage : TStreamStorage)');
    RegisterMethod('Procedure WriteUnicodeString( const Name : string; const Value : string)');
    RegisterMethod('Procedure WriteUTF8String( const Name : string; const Value : ansistring)');
    RegisterMethod('Procedure WriteDateTime( const Name : string; const Value : TDateTime)');
    RegisterMethod('Procedure WriteCardinal( const Name : string; const Value : Cardinal)');
    RegisterMethod('Procedure WriteInteger( const Name : string; const Value : Integer)');
    RegisterMethod('Procedure WriteBoolean( const Name : string; const Value : Boolean)');
    RegisterMethod('Procedure WriteStream( const Name : string; const Value : TStream)');
    RegisterMethod('Procedure WriteString( const Name : string; const Value : string)');
    RegisterMethod('Procedure WriteReal( const Name : string; const Value : Real)');
    RegisterMethod('Procedure ReadStream( const Name : string; const Stream : TStream);');
    RegisterMethod('Function ReadStream2( const Name : string) : IStorageStream;');
    RegisterMethod('Function ReadUnicodeString( const Name : string) : string');
    RegisterMethod('Function ReadUTF8String( const Name : string) : ansistring');
    RegisterMethod('Function ReadDateTime( const Name : string) : TDateTime');
    RegisterMethod('Function ReadCardinal( const Name : string) : Cardinal');
    RegisterMethod('Function ReadInteger( const Name : string) : Integer');
    RegisterMethod('Function ReadBoolean( const Name : string) : Boolean');
    RegisterMethod('Function ReadString( const Name : string) : string');
    RegisterMethod('Function ReadReal( const Name : string) : Real');
    RegisterMethod('Function GetEnumerator : TNamesEnumerator');
    RegisterProperty('IgnoreDuplicates', 'Boolean', iptrw);
    RegisterProperty('Storage', 'TMemoryStream', iptr);
    RegisterMethod('Function Exists( const Name : string) : Boolean');
    RegisterMethod('Procedure Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IStorageStream(CL: TPSPascalCompiler);
begin
  //with RegInterfaceS(CL,'IInterface', 'IStorageStream') do
  with CL.AddInterface(CL.FindInterface('IInterface'),IStorageStream, 'IStorageStream') do begin
    RegisterMethod('Function _GetData : TStream', cdRegister);
    //RegisterProperty('Data', 'TStream', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TNamesEnumerator(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TNamesEnumerator') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TNamesEnumerator') do begin
    RegisterMethod('Constructor Create( const Storage : TMemoryStream)');
       RegisterMethod('Procedure Free;');

    RegisterMethod('Function GetCurrent : string');
    RegisterMethod('Function MoveNext : Boolean');
    RegisterProperty('Current', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_CromisStreams(CL: TPSPascalCompiler);
begin
 CL.AddDelphiFunction('Procedure WriteToStreamAsString( const Stream : TStream; const Content : string)');
 CL.AddDelphiFunction('Procedure WriteToStreamAsUnicode( const Stream : TStream; const Content : string)');
 CL.AddDelphiFunction('Procedure WriteToStreamAsUTF80( const Stream : TStream; const Content : string);');
 CL.AddDelphiFunction('Procedure WriteToStreamAsUTF81( const Stream : TStream; const Content : ansistring);');
 CL.AddDelphiFunction('Function ReadFromStreamAsUnicode( const Stream : TStream) : string');
 CL.AddDelphiFunction('Function ReadFromStreamAsString( const Stream : TStream) : string');
 CL.AddDelphiFunction('Function ReadFromStreamAsUTF8( const Stream : TStream) : ansistring');
 CL.AddConstantN('cDefaultSearchSize','LongInt').SetInt( 50);
  SIRegister_TNamesEnumerator(CL);
  SIRegister_IStorageStream(CL);
  SIRegister_TStreamStorage(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TStreamStorageStorage_R(Self: TStreamStorage; var T: TMemoryStream);
begin T := Self.Storage; end;

(*----------------------------------------------------------------------------*)
procedure TStreamStorageIgnoreDuplicates_W(Self: TStreamStorage; const T: Boolean);
begin Self.IgnoreDuplicates := T; end;

(*----------------------------------------------------------------------------*)
procedure TStreamStorageIgnoreDuplicates_R(Self: TStreamStorage; var T: Boolean);
begin T := Self.IgnoreDuplicates; end;

(*----------------------------------------------------------------------------*)
Function TStreamStorageReadStream2_P(Self: TStreamStorage;  const Name : string) : IStorageStream;
Begin Result := Self.ReadStream(Name); END;

(*----------------------------------------------------------------------------*)
Procedure TStreamStorageReadStream_P(Self: TStreamStorage;  const Name : string; const Stream : TStream);
Begin Self.ReadStream(Name, Stream); END;

(*----------------------------------------------------------------------------*)
procedure TNamesEnumeratorCurrent_R(Self: TNamesEnumerator; var T: string);
begin T := Self.Current; end;

(*----------------------------------------------------------------------------*)
Procedure WriteToStreamAsUTF81_P( const Stream : TStream; const Content : ansistring);
Begin CromisStreams.WriteToStreamAsUTF80(Stream, Content); END;

(*----------------------------------------------------------------------------*)
Procedure WriteToStreamAsUTF80_P( const Stream : TStream; const Content : string);
Begin CromisStreams.WriteToStreamAsUTF81(Stream, Content); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TStreamStorage(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TStreamStorage) do begin
    RegisterConstructor(@TStreamStorage.Create, 'Create');
      RegisterMethod(@TStreamStorage.Destroy, 'Free');

    RegisterMethod(@TStreamStorage.Assign, 'Assign');
    RegisterMethod(@TStreamStorage.WriteUnicodeString, 'WriteUnicodeString');
    RegisterMethod(@TStreamStorage.WriteUTF8String, 'WriteUTF8String');
    RegisterMethod(@TStreamStorage.WriteDateTime, 'WriteDateTime');
    RegisterMethod(@TStreamStorage.WriteCardinal, 'WriteCardinal');
    RegisterMethod(@TStreamStorage.WriteInteger, 'WriteInteger');
    RegisterMethod(@TStreamStorage.WriteBoolean, 'WriteBoolean');
    RegisterMethod(@TStreamStorage.WriteStream, 'WriteStream');
    RegisterMethod(@TStreamStorage.WriteString, 'WriteString');
    RegisterMethod(@TStreamStorage.WriteReal, 'WriteReal');
    RegisterMethod(@TStreamStorageReadStream_P, 'ReadStream');
    RegisterMethod(@TStreamStorageReadStream2_P, 'ReadStream2');
    RegisterMethod(@TStreamStorage.ReadUnicodeString, 'ReadUnicodeString');
    RegisterMethod(@TStreamStorage.ReadUTF8String, 'ReadUTF8String');
    RegisterMethod(@TStreamStorage.ReadDateTime, 'ReadDateTime');
    RegisterMethod(@TStreamStorage.ReadCardinal, 'ReadCardinal');
    RegisterMethod(@TStreamStorage.ReadInteger, 'ReadInteger');
    RegisterMethod(@TStreamStorage.ReadBoolean, 'ReadBoolean');
    RegisterMethod(@TStreamStorage.ReadString, 'ReadString');
    RegisterMethod(@TStreamStorage.ReadReal, 'ReadReal');
    RegisterMethod(@TStreamStorage.GetEnumerator, 'GetEnumerator');
    RegisterPropertyHelper(@TStreamStorageIgnoreDuplicates_R,@TStreamStorageIgnoreDuplicates_W,'IgnoreDuplicates');
    RegisterPropertyHelper(@TStreamStorageStorage_R,nil,'Storage');
    RegisterMethod(@TStreamStorage.Exists, 'Exists');
    RegisterMethod(@TStreamStorage.Clear, 'Clear');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TNamesEnumerator(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TNamesEnumerator) do begin
    RegisterConstructor(@TNamesEnumerator.Create, 'Create');
      RegisterMethod(@TNamesEnumerator.Destroy, 'Free');

    RegisterMethod(@TNamesEnumerator.GetCurrent, 'GetCurrent');
    RegisterMethod(@TNamesEnumerator.MoveNext, 'MoveNext');
    RegisterPropertyHelper(@TNamesEnumeratorCurrent_R,nil,'Current');
  end;


end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_CromisStreams_Routines(S: TPSExec);
begin
 S.RegisterDelphiFunction(@WriteToStreamAsString, 'WriteToStreamAsString', cdRegister);
 S.RegisterDelphiFunction(@WriteToStreamAsUnicode, 'WriteToStreamAsUnicode', cdRegister);
 S.RegisterDelphiFunction(@WriteToStreamAsUTF80, 'WriteToStreamAsUTF80', cdRegister);
 S.RegisterDelphiFunction(@WriteToStreamAsUTF81, 'WriteToStreamAsUTF81', cdRegister);
 S.RegisterDelphiFunction(@ReadFromStreamAsUnicode, 'ReadFromStreamAsUnicode', cdRegister);
 S.RegisterDelphiFunction(@ReadFromStreamAsString, 'ReadFromStreamAsString', cdRegister);
 S.RegisterDelphiFunction(@ReadFromStreamAsUTF8, 'ReadFromStreamAsUTF8', cdRegister);
  //RIRegister_TNamesEnumerator(CL);
  //RIRegister_TStreamStorage(CL);
end;

 
 
{ TPSImport_CromisStreams }
(*----------------------------------------------------------------------------*)
procedure TPSImport_CromisStreams.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_CromisStreams(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_CromisStreams.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_CromisStreams_Routines(CompExec.Exec); // comment it if no routines
end;
(*----------------------------------------------------------------------------*)
 
 
end.
