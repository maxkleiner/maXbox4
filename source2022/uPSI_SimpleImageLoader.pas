unit uPSI_SimpleImageLoader;
{
needs  OpenCL1.2 and Delphi and Windows      experimental

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
  TPSImport_SimpleImageLoader = class(TPSPlugin)
  public
    procedure CompileImport1(CompExec: TPSScript); override;
    procedure ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter); override;
  end;
 
 
{ compile-time registration functions }
procedure SIRegister_TImageLoader(CL: TPSPascalCompiler);
procedure SIRegister_SimpleImageLoader(CL: TPSPascalCompiler);

{ run-time registration functions }
procedure RIRegister_TImageLoader(CL: TPSRuntimeClassImporter);
procedure RIRegister_SimpleImageLoader(CL: TPSRuntimeClassImporter);

procedure Register;

implementation


uses
   //CL_platform
 //CL
  Graphics
  ,SimpleImageLoader
  ;
 
 
procedure Register;
begin
  RegisterComponents('Pascal Script', [TPSImport_SimpleImageLoader]);
end;

(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TImageLoader(CL: TPSPascalCompiler);
begin
  //with RegClassS(CL,'TOBJECT', 'TImageLoader') do
  with CL.AddClassN(CL.FindClass('TOBJECT'),'TImageLoader') do begin
    RegisterMethod('Constructor Create( const FileName : String);');
    RegisterMethod('Constructor Create1;');
    RegisterMethod('Procedure Free;');
    RegisterMethod('Procedure SaveToFile( const FileName : String)');
    RegisterMethod('Procedure Resize( const Width, Height : Integer)');
    RegisterProperty('Width', 'Integer', iptr);
    RegisterProperty('Height', 'Integer', iptr);
    RegisterProperty('Pointer', 'Pointer', iptrw);
    RegisterProperty('Format', 'PCL_image_format', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_SimpleImageLoader(CL: TPSPascalCompiler);
begin
  //CL.AddTypeS('PArrayByte', '^TArrayByte // will not work');
  SIRegister_TImageLoader(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TImageLoaderFormat_R(Self: TImageLoader; var T: PCL_image_format);
begin T := Self.Format; end;

(*----------------------------------------------------------------------------*)
procedure TImageLoaderPointer_W(Self: TImageLoader; const T: Pointer);
begin Self.Pointer := T; end;

(*----------------------------------------------------------------------------*)
procedure TImageLoaderPointer_R(Self: TImageLoader; var T: Pointer);
begin T := Self.Pointer; end;

(*----------------------------------------------------------------------------*)
procedure TImageLoaderHeight_R(Self: TImageLoader; var T: Integer);
begin T := Self.Height; end;

(*----------------------------------------------------------------------------*)
procedure TImageLoaderWidth_R(Self: TImageLoader; var T: Integer);
begin T := Self.Width; end;

(*----------------------------------------------------------------------------*)
Function TImageLoaderCreate1_P(Self: TClass; CreateNewInstance: Boolean):TObject;
Begin Result := TImageLoader.Create; END;

(*----------------------------------------------------------------------------*)
Function TImageLoaderCreate_P(Self: TClass; CreateNewInstance: Boolean;  const FileName : String):TObject;
Begin Result := TImageLoader.Create(FileName); END;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TImageLoader(CL: TPSRuntimeClassImporter);
begin
  with CL.Add(TImageLoader) do begin
    RegisterConstructor(@TImageLoaderCreate_P, 'Create');
    RegisterConstructor(@TImageLoaderCreate1_P, 'Create1');
    RegisterMethod(@TImageLoader.Destroy, 'Free');
    RegisterMethod(@TImageLoader.SaveToFile, 'SaveToFile');
    RegisterMethod(@TImageLoader.Resize, 'Resize');
    RegisterPropertyHelper(@TImageLoaderWidth_R,nil,'Width');
    RegisterPropertyHelper(@TImageLoaderHeight_R,nil,'Height');
    RegisterPropertyHelper(@TImageLoaderPointer_R,@TImageLoaderPointer_W,'Pointer');
    RegisterPropertyHelper(@TImageLoaderFormat_R,nil,'Format');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_SimpleImageLoader(CL: TPSRuntimeClassImporter);
begin
  RIRegister_TImageLoader(CL);
end;

 
 
{ TPSImport_SimpleImageLoader }
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleImageLoader.CompileImport1(CompExec: TPSScript);
begin
  SIRegister_SimpleImageLoader(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TPSImport_SimpleImageLoader.ExecImport1(CompExec: TPSScript; const ri: TPSRuntimeClassImporter);
begin
  RIRegister_SimpleImageLoader(ri);
end;
(*----------------------------------------------------------------------------*)
 
 
end.
