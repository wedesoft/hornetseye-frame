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

static enum PixelFormat stringToPixelFormat( const string &str ) throw (Error)
{
  enum PixelFormat retVal = PIX_FMT_NONE;
  if ( str == "YV12" )
    retVal = PIX_FMT_YUV420P;
  else if ( str == "UBYTERGB" )
    retVal = PIX_FMT_RGB24;
  else {
    ERRORMACRO( false, Error, , "Unsupported colourspace \"" << str << "\"" );
  };
  return retVal;
}

FramePtr frameToType( const FramePtr in, const string &target ) throw (Error)
{
  int
    width = in->width(),
    height = in->height();
  FramePtr retVal( new Frame( target, width, height ) );
  uint8_t *sourceData[3];
  sourceData[0] = (uint8_t *)in->data();
  sourceData[1] = (uint8_t *)in->data() + width * height * 5 / 4;
  sourceData[2] = (uint8_t *)in->data() + width * height;
  int sourceLineSize[3];
  sourceLineSize[0] = width;
  sourceLineSize[1] = width / 2;
  sourceLineSize[2] = width / 2;
  uint8_t *destData[1];
  destData[0] = (uint8_t *)retVal->data();
  int destLineSize[1];
  destLineSize[0] = retVal->width() * 3;
  SwsContext *swsContext = sws_getContext( width, height,
                                           stringToPixelFormat( in->typecode() ),
                                           width, height,
                                           stringToPixelFormat( target ),
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
