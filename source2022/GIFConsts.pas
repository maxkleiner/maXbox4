unit GIFConsts;

interface

////////////////////////////////////////////////////////////////////////////////
//
//                      Error messages
//
////////////////////////////////////////////////////////////////////////////////
resourcestring
  // GIF Error messages
  sOutOfData		= 'Premature end of data';
  sTooManyColors	= 'Color table overflow';
  sBadColorIndex	= 'Invalid color index';
  sBadColorIndexFixed	= 'Invalid color index - color map expanded';
  sGIFErrorSaveEmpty	= 'Cannot save empty GIF';
  sBadSignature		= 'Invalid GIF signature';
  sScreenBadColorSize	= 'Invalid number of colors specified in Screen Descriptor';
  sImageBadColorSize	= 'Invalid number of colors specified in Image Descriptor';
  sUnknownExtension	= 'Unknown extension type';
  sBadExtensionLabel	= 'Invalid extension introducer';
  sOutOfMemDIB		= 'Failed to allocate memory for GIF DIB';
  sDIBCreate		= 'Failed to create DIB from Bitmap';
  sDecodeTooFewBits	= 'Decoder bit buffer under-run';
  sDecodeCircular	= 'Circular decoder table entry';
  sBadTrailer		= 'Invalid Image trailer';
  sBadExtensionInstance	= 'Internal error: Extension Instance does not match Extension Label';
  sBadBlockSize		= 'Unsupported Application Extension block size';
  sBadBlock		= 'Unknown GIF block type';
  sUnsupportedClass	= 'Object type not supported for operation';
  sInvalidData		= 'Invalid GIF data';
  sBadSize		= 'Invalid image size';
  sFailedPaste		= 'Failed to store GIF on clipboard';
  sTPictureConflict	= 'Another TGIFImage class has already been registered with TPicture';
  sScreenSizeExceeded	= 'Image exceeds Logical Screen size';
  sNoColorTable		= 'No global or local color table defined';
  sBadPixelCoordinates	= 'Invalid pixel coordinates';
  sUnsupportedBitmap	= 'Unsupported bitmap format';
  sInvalidPixelFormat	= 'Unsupported PixelFormat';
  sBadDimension		= 'Invalid image dimensions';
  sNoDIB		= 'Image has no DIB';
  sInvalidStream	= 'Invalid stream operation';
  sInvalidColor		= 'Color not in color table';
  sInvalidBitSize	= 'Invalid Bits Per Pixel value';
  sEmptyColorMap	= 'Color table is empty';
  sEmptyImage		= 'Image is empty';
  sInvalidBitmapList	= 'Invalid bitmap list';
  sInvalidReduction	= 'Invalid reduction method';
  sMultipleGCE		= 'Frame contains multiple Graphic Control Extension blocks';
  sNoPalette		= 'Missing, invalid or empty palette';

////////////////////////////////////////////////////////////////////////////////
//
//                      Misc texts
//
////////////////////////////////////////////////////////////////////////////////
  // File filter name
  sGIFImageFile		= 'GIF Image';

  // Progress messages
  sProgressLoading	= 'Loading';
  sProgressSaving	= 'Saving';
  sProgressConverting	= 'Converting';
  sProgressRendering	= 'Rendering';
  sProgressCopying	= 'Copying';
  sProgressOptimizing	= 'Optimizing';


implementation

end.