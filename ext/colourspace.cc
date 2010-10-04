/* HornetsEye - Computer Vision with Ruby
   Copyright (C) 2006, 2007, 2008, 2009, 2010   Jan Wedekind

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>. */
extern "C" {
  #include <libswscale/swscale.h>
}
#undef RSHIFT
#include "colourspace.hh"

using namespace std;

static void setupFormat( const string &typecode, int width, int height, char *memory,
                         enum PixelFormat *format,
                         uint8_t **data, int *lineSize ) throw (Error)
{
  if ( typecode == "UBYTE" ) {
    *format = PIX_FMT_GRAY8;
    data[ 0 ] = (uint8_t *)memory;
    lineSize[ 0 ] = width;
  } else if ( typecode == "UBYTERGB" ) {
    *format = PIX_FMT_RGB24;
    data[ 0 ] = (uint8_t *)memory;
    lineSize[ 0 ] = width * 3;
  } else if ( typecode == "YV12" ) {
    *format = PIX_FMT_YUV420P;
    int
      width2  = ( width  + 1 ) / 2,
      height2 = ( height + 1 ) / 2,
      widtha  = ( width  + 7 ) & ~0x7,
      width2a = ( width2 + 7 ) & ~0x7;
    data[ 0 ] = (uint8_t *)memory;
    data[ 2 ] = (uint8_t *)memory + widtha * height;
    data[ 1 ] = (uint8_t *)data[ 2 ] + width2a * height2;
    lineSize[ 0 ] = widtha;
    lineSize[ 1 ] = ( ( width + 1 ) / 2 + 7 ) & ~0x7;
    lineSize[ 2 ] = ( ( width + 1 ) / 2 + 7 ) & ~0x7;
  } else if ( typecode == "I420" ) {
    *format = PIX_FMT_YUV420P;
    int
      width2  = width / 2,
      height2 = height / 2;
    data[ 0 ] = (uint8_t *)memory;
    data[ 2 ] = (uint8_t *)memory + width * height;
    data[ 1 ] = (uint8_t *)data[ 2 ] + width2 * height2;
    lineSize[ 0 ] = width;
    lineSize[ 1 ] = width2;
    lineSize[ 2 ] = width2;
  } else if ( typecode == "YUY2" ) {
    *format = PIX_FMT_YUYV422;
    int
      width2 = ( width + 1 ) / 2,
      widtha = ( width + 3 ) & ~0x3;
    data[ 0 ] = (uint8_t *)memory;
    lineSize[ 0 ] = 2 * widtha;
  } else if ( typecode == "UYVY" ) {
    *format = PIX_FMT_UYVY422;
    int widtha = ( width + 1 ) & ~0x1;
    data[ 0 ] = (uint8_t *)memory;
    lineSize[ 0 ] = 2 * widtha;
  } else {
    ERRORMACRO( false, Error, , "Unsupported colourspace \"" << typecode << "\"" );
  };
}

FramePtr frameToType( const FramePtr in, const string &target ) throw (Error)
{
  int
    width = in->width(),
    height = in->height();
  FramePtr retVal( new Frame( target, width, height ) );
  enum PixelFormat sourceFormat;
  uint8_t *sourceData[4];
  int sourceLineSize[4];
  setupFormat( in->typecode(), width, height, in->data(),
               &sourceFormat, &sourceData[0], &sourceLineSize[0] );
  enum PixelFormat destFormat;
  uint8_t *destData[4];
  int destLineSize[4];
  setupFormat( retVal->typecode(), width, height, retVal->data(),
               &destFormat, &destData[0], &destLineSize[0] );
  SwsContext *swsContext = sws_getContext( width, height, sourceFormat,
                                           width, height, destFormat,
                                           SWS_FAST_BILINEAR, 0, 0, 0 );
  sws_scale( swsContext, sourceData, sourceLineSize, 0,
             height, destData, destLineSize );
  sws_freeContext( swsContext );
  return retVal;
}

VALUE frameWrapToType( VALUE rbSelf, VALUE rbTarget )
{
  VALUE rbRetVal = Qnil;
  try {
    FramePtr frame( new Frame( rbSelf ) );
    VALUE rbString = rb_funcall( rbTarget, rb_intern( "to_s" ), 0 );
    rbRetVal = frameToType( frame, StringValuePtr( rbString ) )->rubyObject();
  } catch ( exception &e ) {
    rb_raise( rb_eRuntimeError, "%s", e.what() );
  };
  return rbRetVal;
}
