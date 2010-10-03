# hornetseye-frame - Colourspace conversions and compression
# Copyright (C) 2010 Jan Wedekind
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Namespace of Hornetseye computer vision library
module Hornetseye

  class Node

    alias_method :orig_to_type_with_frame, :to_type_with_frame

    def to_type_with_frame( target )
      if target.is_a? FourCC
        if ( typecode < INT_ and typecode != UBYTE ) or typecode < FLOAT_
          to_type( UBYTE ).to_type target
        elsif typecode < COMPLEX_
          real.to_type target
        elsif typecode < RGB_ and typecode != UBYTERGB
          to_type( UBYTERGB ).to_type target
        else
          orig_to_type_with_frame target
        end
      else
        to_type_without_frame target
      end
    end

    alias_method_chain :to_type, :frame

  end

end

