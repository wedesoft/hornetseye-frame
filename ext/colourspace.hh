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
#ifndef COLOURSPACE_HH
#define COLOURSPACE_HH

#include <ruby.h>
#include <string>
#include "error.hh"
#include "frame.hh"

FramePtr frameToType( const FramePtr in, const std::string &target ) throw (Error);

VALUE frameWrapToType( VALUE rbClass, VALUE rbTarget );

#endif

