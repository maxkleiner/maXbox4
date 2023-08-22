unit uPSI_HTTPParse;
{
for webservice by max
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
  TPSImport_HTTPParse = class(TPSPlugin)
  protected
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;


{ compile-time registration functions }
procedure SIRegister_THTTPParser(CL: TPSPascalCompiler);
procedure SIRegister_HTTPParse(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_THTTPParser(CL: TPSRuntimeClassImporter);
procedure RIRegister_HTTPParse(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   HTTPParse
  ;


procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_HTTPParse]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_THTTPParser(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'THTTPParser') do
  with CL.AddClassN(CL.FindClass('TObject'),'THTTPParser') do
  begin
    RegisterMethod('Constructor Create(Stream : TStream)');
    RegisterMethod('Procedure CheckToken( T : Char)');
    RegisterMethod('Procedure CheckTokenSymbol( const S : string)');
    RegisterMethod('Function CopyTo( Length : Integer) : string');
    RegisterMethod('Function CopyToEOL : string');
    RegisterMethod('Function CopyToEOF : string');
    RegisterMethod('Procedure Error( const Ident : string)');
    RegisterMethod('Procedure ErrorFmt( const Ident : string; const Args : array of const)');
    RegisterMethod('Procedure ErrorStr( const Message : string)');
    RegisterMethod('Procedure HexToBinary( Stream : TStream)');
    RegisterMethod('Function NextToken : Char');
    RegisterMethod('Procedure SkipEOL');
    RegisterMethod('Function SourcePos : Longint');
    RegisterMethod('Function TokenFloat : Extended');
    RegisterMethod('Function TokenInt : Longint');
    RegisterMethod('Function TokenString : string');
    RegisterMethod('Function TokenSymbolIs( const S : string) : Boolean');
    RegisterMethod('Function BufferRequest( Length : Integer) : TStream');
    RegisterProperty('SourceLine', 'Integer', iptr);
    RegisterProperty('Token', 'Char', iptr);
    RegisterProperty('HeaderField', 'Boolean', iptrw);
    RegisterProperty('SourcePtr', 'PChar', iptrw);
    RegisterProperty('TokenPtr', 'PChar', iptrw);
    RegisterProperty('Stream', 'TStream', iptr);
    RegisterProperty('SourceEnd', 'PChar', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_HTTPParse(CL: TPSPascalCompiler);
begin
 CL.AddConstantN('toEOL','LongInt').SetInt(( 5 ));
 CL.AddConstantN('toGET','LongInt').SetInt(( 6 ));
 CL.AddConstantN('toHEAD','LongInt').SetInt(( 7 ));
 CL.AddConstantN('toPUT','LongInt').SetInt(( 8 ));
 CL.AddConstantN('toDELETE','LongInt').SetInt(( 9 ));
 CL.AddConstantN('toPOST','LongInt').SetInt(( 10 ));
 CL.AddConstantN('toPATCH','LongInt').SetInt(( 11 ));
 CL.AddConstantN('toCOPY','LongInt').SetInt( ( 12 ));
 CL.AddConstantN('toUserAgent','LongInt').SetInt(( 13 ));
 CL.AddConstantN('toAccept','LongInt').SetInt(( 14 ));
 CL.AddConstantN('toContentType','LongInt').SetInt(( 15 ));
 CL.AddConstantN('toContentLength','LongInt').SetInt(( 16 ));
 CL.AddConstantN('toReferer','LongInt').SetInt(( 17 ));
 CL.AddConstantN('toAuthorization','LongInt').SetInt(( 18 ));
 CL.AddConstantN('toCacheControl','LongInt').SetInt(( 19 ));
 CL.AddConstantN('toDate','LongInt').SetInt(( 20 ));
 CL.AddConstantN('toFrom','LongInt').SetInt(( 21 ));
 CL.AddConstantN('toHost','LongInt').SetInt(( 22 ));
 CL.AddConstantN('toIfModified','LongInt').SetInt( ( 23 ));
 CL.AddConstantN('toContentEncoding','LongInt').SetInt(( 24 ));
 CL.AddConstantN('toContentVersion','LongInt').SetInt(( 25 ));
 CL.AddConstantN('toAllow','LongInt').SetInt(( 26 ));
 CL.AddConstantN('toConnection','LongInt').SetInt(( 27 ));
 CL.AddConstantN('toCookie','LongInt').SetInt(( 28 ));
 CL.AddConstantN('toContentDisposition','LongInt').SetInt(( 29 ));
 CL.AddConstantN('hcGET','LongWord').SetUInt( $14F5);
 CL.AddConstantN('hcPUT','LongWord').SetUInt( $4AF5);
 CL.AddConstantN('hcDELETE','LongWord').SetUInt( $92B2);
 CL.AddConstantN('hcPOST','LongWord').SetUInt( $361D);
 CL.AddConstantN('hcCacheControl','LongWord').SetUInt( $4FF6);
 CL.AddConstantN('hcDate','LongWord').SetUInt( $0EE6);
 CL.AddConstantN('hcFrom','LongWord').SetUInt( $418F);
 CL.AddConstantN('hcHost','LongWord').SetUInt( $3611);
 CL.AddConstantN('hcIfModified','LongWord').SetUInt( $DDF0);
 CL.AddConstantN('hcAllow','LongWord').SetUInt( $3D80);
 CL.AddConstantN('hcUserAgent','LongWord').SetUInt( $E890);
 CL.AddConstantN('hcAccept','LongWord').SetUInt( $1844);
 CL.AddConstantN('hcContentEncoding','LongWord').SetUInt( $C586);
 CL.AddConstantN('hcContentVersion','LongWord').SetUInt( $EDF4);
 CL.AddConstantN('hcContentType','LongWord').SetUInt( $F0E0);
 CL.AddConstantN('hcContentLength','LongWord').SetUInt( $B0C4);
 CL.AddConstantN('hcReferer','LongWord').SetUInt( $CEA5);
 CL.AddConstantN('hcAuthorization','LongWord').SetUInt( $ABCA);
 CL.AddConstantN('hcConnection','LongWord').SetUInt( $0EDE);
 CL.AddConstantN('hcCookie','LongWord').SetUInt( $27B3);
 CL.AddConstantN('hcContentDisposition','LongWord').SetUInt( $CBEB);
  SIRegister_THTTPParser(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure THTTPParserSourceEnd_R(Self: THTTPParser; var T: PChar);
begin T := Self.SourceEnd; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserStream_R(Self: THTTPParser; var T: TStream);
begin T := Self.Stream; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserTokenPtr_W(Self: THTTPParser; const T: PChar);
begin Self.TokenPtr := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserTokenPtr_R(Self: THTTPParser; var T: PChar);
begin T := Self.TokenPtr; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserSourcePtr_W(Self: THTTPParser; const T: PChar);
begin Self.SourcePtr := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserSourcePtr_R(Self: THTTPParser; var T: PChar);
begin T := Self.SourcePtr; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserHeaderField_W(Self: THTTPParser; const T: Boolean);
begin Self.HeaderField := T; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserHeaderField_R(Self: THTTPParser; var T: Boolean);
begin T := Self.HeaderField; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserToken_R(Self: THTTPParser; var T: Char);
begin T := Self.Token; end;

(*----------------------------------------------------------------------------*)
procedure THTTPParserSourceLine_R(Self: THTTPParser; var T: Integer);
begin T := Self.SourceLine; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_THTTPParser(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(THTTPParser) do
  begin
    RegisterConstructor(@THTTPParser.Create, 'Create');
    RegisterMethod(@THTTPParser.CheckToken, 'CheckToken');
    RegisterMethod(@THTTPParser.CheckTokenSymbol, 'CheckTokenSymbol');
    RegisterMethod(@THTTPParser.CopyTo, 'CopyTo');
    RegisterMethod(@THTTPParser.CopyToEOL, 'CopyToEOL');
    RegisterMethod(@THTTPParser.CopyToEOF, 'CopyToEOF');
    RegisterMethod(@THTTPParser.Error, 'Error');
    RegisterMethod(@THTTPParser.ErrorFmt, 'ErrorFmt');
    RegisterMethod(@THTTPParser.ErrorStr, 'ErrorStr');
    RegisterMethod(@THTTPParser.HexToBinary, 'HexToBinary');
    RegisterMethod(@THTTPParser.NextToken, 'NextToken');
    RegisterMethod(@THTTPParser.SkipEOL, 'SkipEOL');
    RegisterMethod(@THTTPParser.SourcePos, 'SourcePos');
    RegisterMethod(@THTTPParser.TokenFloat, 'TokenFloat');
    RegisterMethod(@THTTPParser.TokenInt, 'TokenInt');
    RegisterMethod(@THTTPParser.TokenString, 'TokenString');
    RegisterMethod(@THTTPParser.TokenSymbolIs, 'TokenSymbolIs');
    RegisterMethod(@THTTPParser.BufferRequest, 'BufferRequest');
    RegisterPropertyHelper(@THTTPParserSourceLine_R,nil,'SourceLine');
    RegisterPropertyHelper(@THTTPParserToken_R,nil,'Token');
    RegisterPropertyHelper(@THTTPParserHeaderField_R,@THTTPParserHeaderField_W,'HeaderField');
    RegisterPropertyHelper(@THTTPParserSourcePtr_R,@THTTPParserSourcePtr_W,'SourcePtr');
    RegisterPropertyHelper(@THTTPParserTokenPtr_R,@THTTPParserTokenPtr_W,'TokenPtr');
    RegisterPropertyHelper(@THTTPParserStream_R,nil,'Stream');
    RegisterPropertyHelper(@THTTPParserSourceEnd_R,nil,'SourceEnd');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_HTTPParse(CL: TPSRuntimeClassImporter);
begin
  RIRegister_THTTPParser(CL);
end;

 
 
{ TPSImport_HTTPParse }
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTTPParse.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_HTTPParse(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_HTTPParse.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_HTTPParse(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
