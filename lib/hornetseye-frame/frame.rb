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

      def storage_size
        case typecode
        when BGR
          width * height * 3
        when BGRA
          width * height * 4
        when UYVY
          width * height * 2
        when YUY2
          widtha = ( width + 3 ) & ~0x3
          widtha * height * 2
        when YV12
          width * height * 3 / 2
        when I420
          width * height * 3 / 2
        when MJPG
          width * height * 2
        else
          raise "Memory size of #{inspect} is not known"
        end
      end

      def rgb?
        true
      end

    end

    attr_reader :memory

    def initialize( value = nil )
      @memory = value || Malloc.new( self.class.storage_size )
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

    def storage_size
      self.class.storage_size
    end

    def rgb?
      self.class.rgb?
    end

    alias_method :orig_to_type, :to_type

    def to_type( target )
      if target.is_a? Class
        if ( target < INT_ and target != UBYTE ) or target < FLOAT_ or
          target < COMPLEX_
          to_type( UBYTE ).to_type target
        elsif target < RGB_ and target != UBYTERGB
          to_type( UBYTERGB ).to_type target
        else
          orig_to_type target
        end
      else
        orig_to_type target
      end
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

      def storage_size( typecode, width, height )
        Hornetseye::Frame( typecode, width, height ).storage_size
      end

    end

  end

end

