unit uPSI_IdMessageCoder;
{
  base coder
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
  TPSImport_IdMessageCoder = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TIdMessageEncoderList(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageEncoderInfo(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageEncoder(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageDecoderList(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageDecoderInfo(CL: TPSPascalCompiler);
procedure SIRegister_TIdMessageDecoder(CL: TPSPascalCompiler);
procedure SIRegister_IdMessageCoder(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TIdMessageEncoderList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageEncoderInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageEncoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageDecoderList(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageDecoderInfo(CL: TPSRuntimeClassImporter);
procedure RIRegister_TIdMessageDecoder(CL: TPSRuntimeClassImporter);
procedure RIRegister_IdMessageCoder(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   IdComponent
  ,IdGlobal
  ,IdMessage
  ,IdMessageCoder
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_IdMessageCoder]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageEncoderList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdMessageEncoderList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdMessageEncoderList') do
  begin
    RegisterMethod('Function ByName( const AName : string) : TIdMessageEncoderInfo');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure RegisterEncoder( const AMessageEncoderName : string; AMessageEncoderInfo : TIdMessageEncoderInfo)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageEncoderInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdMessageEncoderInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdMessageEncoderInfo') do
  begin
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure InitializeHeaders( AMsg : TIdMessage)');
    RegisterProperty('MessageEncoderClass', 'TIdMessageEncoderClass', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageEncoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdMessageEncoder') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdMessageEncoder') do
  begin
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterMethod('Procedure Encode( const AFilename : string; ADest : TStream);');
    RegisterMethod('Procedure Encode1( ASrc : TStream; ADest : TStream);');
    RegisterProperty('Filename', 'string', iptrw);
    RegisterProperty('PermissionCode', 'integer', iptrw);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageDecoderList(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdMessageDecoderList') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdMessageDecoderList') do
  begin
    RegisterMethod('Function ByName( const AName : string) : TIdMessageDecoderInfo');
    RegisterMethod('Function CheckForStart( ASender : TIdMessage; const ALine : string) : TIdMessageDecoder');
    RegisterMethod('Constructor Create');
    RegisterMethod('Procedure RegisterDecoder( const AMessageCoderName : string; AMessageCoderInfo : TIdMessageDecoderInfo)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageDecoderInfo(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TIdMessageDecoderInfo') do
  with CL.AddClassN(CL.FindClass('TObject'),'TIdMessageDecoderInfo') do
  begin
    RegisterMethod('Function CheckForStart( ASender : TIdMessage; ALine : string) : TIdMessageDecoder');
    RegisterMethod('Constructor Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIdMessageDecoder(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TIdComponent', 'TIdMessageDecoder') do
  with CL.AddClassN(CL.FindClass('TIdComponent'),'TIdMessageDecoder') do
  begin
    RegisterMethod('Function ReadBody( ADestStream : TStream; var AMsgEnd : Boolean) : TIdMessageDecoder');
    RegisterMethod('Procedure ReadHeader');
    RegisterMethod('Function ReadLn : string');
    RegisterMethod('Constructor Create( AOwner : TComponent)');
    RegisterProperty('Filename', 'string', iptr);
    RegisterProperty('SourceStream', 'TStream', iptrw);
    RegisterProperty('Headers', 'TStrings', iptr);
    RegisterProperty('PartType', 'TIdMessageCoderPartType', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IdMessageCoder(CL: TPSPascalCompiler);
begin
  CL.AddTypeS('TIdMessageCoderPartType', '( mcptUnknown, mcptText, mcptAttachme'
   +'nt )');
  SIRegister_TIdMessageDecoder(CL);
  SIRegister_TIdMessageDecoderInfo(CL);
  SIRegister_TIdMessageDecoderList(CL);
  SIRegister_TIdMessageEncoder(CL);
  //CL.AddTypeS('TIdMessageEncoderClass', 'class of TIdMessageEncoder');
  SIRegister_TIdMessageEncoderInfo(CL);
  SIRegister_TIdMessageEncoderList(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TIdMessageEncoderInfoMessageEncoderClass_R(Self: TIdMessageEncoderInfo; var T: TIdMessageEncoderClass);
begin T := Self.MessageEncoderClass; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageEncoderPermissionCode_W(Self: TIdMessageEncoder; const T: integer);
begin Self.PermissionCode := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageEncoderPermissionCode_R(Self: TIdMessageEncoder; var T: integer);
begin T := Self.PermissionCode; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageEncoderFilename_W(Self: TIdMessageEncoder; const T: string);
begin Self.Filename := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageEncoderFilename_R(Self: TIdMessageEncoder; var T: string);
begin T := Self.Filename; end;

(*----------------------------------------------------------------------------*)
Procedure TIdMessageEncoderEncode1_P(Self: TIdMessageEncoder;  ASrc : TStream; ADest : TStream);
Begin Self.Encode(ASrc, ADest); END;

(*----------------------------------------------------------------------------*)
Procedure TIdMessageEncoderEncode_P(Self: TIdMessageEncoder;  const AFilename : string; ADest : TStream);
Begin Self.Encode(AFilename, ADest); END;

(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderPartType_R(Self: TIdMessageDecoder; var T: TIdMessageCoderPartType);
begin T := Self.PartType; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderHeaders_R(Self: TIdMessageDecoder; var T: TStrings);
begin T := Self.Headers; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderSourceStream_W(Self: TIdMessageDecoder; const T: TStream);
begin Self.SourceStream := T; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderSourceStream_R(Self: TIdMessageDecoder; var T: TStream);
begin T := Self.SourceStream; end;

(*----------------------------------------------------------------------------*)
procedure TIdMessageDecoderFilename_R(Self: TIdMessageDecoder; var T: string);
begin T := Self.Filename; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageEncoderList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageEncoderList) do
  begin
    RegisterMethod(@TIdMessageEncoderList.ByName, 'ByName');
    RegisterConstructor(@TIdMessageEncoderList.Create, 'Create');
    RegisterMethod(@TIdMessageEncoderList.RegisterEncoder, 'RegisterEncoder');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageEncoderInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageEncoderInfo) do
  begin
    RegisterConstructor(@TIdMessageEncoderInfo.Create, 'Create');
    RegisterVirtualMethod(@TIdMessageEncoderInfo.InitializeHeaders, 'InitializeHeaders');
    RegisterPropertyHelper(@TIdMessageEncoderInfoMessageEncoderClass_R,nil,'MessageEncoderClass');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageEncoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageEncoder) do
  begin
    RegisterConstructor(@TIdMessageEncoder.Create, 'Create');
    RegisterMethod(@TIdMessageEncoderEncode_P, 'Encode');
    //RegisterVirtualAbstractMethod(@TIdMessageEncoder, @!.Encode1, 'Encode1');
    RegisterPropertyHelper(@TIdMessageEncoderFilename_R,@TIdMessageEncoderFilename_W,'Filename');
    RegisterPropertyHelper(@TIdMessageEncoderPermissionCode_R,@TIdMessageEncoderPermissionCode_W,'PermissionCode');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageDecoderList(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageDecoderList) do begin
    RegisterMethod(@TIdMessageDecoderList.ByName, 'ByName');
    RegisterMethod(@TIdMessageDecoderList.CheckForStart, 'CheckForStart');
    RegisterConstructor(@TIdMessageDecoderList.Create, 'Create');
    RegisterMethod(@TIdMessageDecoderList.RegisterDecoder, 'RegisterDecoder');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageDecoderInfo(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageDecoderInfo) do begin
    //RegisterVirtualAbstractMethod(@TIdMessageDecoderInfo, @!.CheckForStart, 'CheckForStart');
    RegisterConstructor(@TIdMessageDecoderInfo.Create, 'Create');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIdMessageDecoder(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TIdMessageDecoder) do begin
    //RegisterVirtualAbstractMethod(@TIdMessageDecoder.r, 'ReadBody');
    RegisterVirtualMethod(@TIdMessageDecoder.ReadHeader, 'ReadHeader');
    RegisterMethod(@TIdMessageDecoder.ReadLn, 'ReadLn');
    RegisterConstructor(@TIdMessageDecoder.Create, 'Create');
    RegisterPropertyHelper(@TIdMessageDecoderFilename_R,nil,'Filename');
    RegisterPropertyHelper(@TIdMessageDecoderSourceStream_R,@TIdMessageDecoderSourceStream_W,'SourceStream');
    RegisterPropertyHelper(@TIdMessageDecoderHeaders_R,nil,'Headers');
    RegisterPropertyHelper(@TIdMessageDecoderPartType_R,nil,'PartType');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IdMessageCoder(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TIdMessageDecoder(CL);
  RIRegister_TIdMessageDecoderInfo(CL);
  RIRegister_TIdMessageDecoderList(CL);
  RIRegister_TIdMessageEncoder(CL);
  RIRegister_TIdMessageEncoderInfo(CL);
  RIRegister_TIdMessageEncoderList(CL);
end;

 
 
{ TPSImport_IdMessageCoder }
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMessageCoder.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_IdMessageCoder(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_IdMessageCoder.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_IdMessageCoder(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
