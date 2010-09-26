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

  class Frame_

    class << self

      attr_accessor :typecode, :width, :height

      def inspect
        to_s
      end

      def to_s
        "Frame(#{typecode},#{@width},#{@height})"
      end

      def shape
        [ @width, @height ]
      end

      def typesize
        case typecode
        when BGR
          width * height * 3
        when UYVY
          width * height * 2
        when YUY2
          widtha = ( width + 3 ) & ~0x3
          widtha * height * 2
        when I420
          width * height * 3 / 2
        when YV12
          width2  = width.succ.div 2
          height2 = height.succ.div 2
          widtha  = ( width  + 7 ) & ~0x7
          width2a = ( width2 + 7 ) & ~0x7
          widtha * height + 2 * width2a * height2
        when MJPG
          width * height * 2
        else
          raise "Memory size of #{inspect} is not known"
        end
      end

    end

    def initialize( value = nil )
      @memory = value || Malloc.new( self.class.typesize )
    end

    def inspect
      "#{self.class.inspect}(#{ "0x%08x" % @memory.object_id })"
    end

    def typecode
      self.class.typecode
    end

    def shape
      self.class.shape
    end

    def width
      self.class.width
    end

    def height
      self.class.height
    end

  end

  def Frame( typecode, width, height )
    if typecode.is_a? FourCC
      retval = Class.new Frame_
      retval.typecode = typecode
      retval.width = width
      retval.height = height
      retval
    else
      Hornetseye::MultiArray typecode, width, height
    end
  end

  module_function :Frame

  class Frame

    class << self

      def new( typecode, width, height )
        Hornetseye::Frame( typecode, width, height ).new
      end

      def import( typecode, width, height, memory )
        Hornetseye::Frame( typecode, width, height ).new memory
      end

      def typesize( typecode, width, height )
        Hornetseye::Frame( typecode, width, height ).typesize
      end

    end

  end

end

