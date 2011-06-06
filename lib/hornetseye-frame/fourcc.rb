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

  class FourCC

    def initialize(a, b, c, d = nil)
      @a, @b, @c, @d = a, b, c, d
    end

    def inspect
      to_s
    end

    def to_s
      "#{@a}#{@b}#{@c}#{@d ? @d : ''}"
    end

    def to_str
      to_s
    end

    def ==( other )
      ( other.is_a? FourCC ) and ( other.inspect == inspect )
    end

  end

  def FourCC(a, b, c, d = nil)
    FourCC.new a, b, c, d
  end

  module_function :FourCC

  BGR  = FourCC 'B', 'G', 'R'
  BGRA = FourCC 'B', 'G', 'R', 'A'
  UYVY = FourCC 'U', 'Y', 'V', 'Y'
  YUY2 = FourCC 'Y', 'U', 'Y', '2'
  I420 = FourCC 'I', '4', '2', '0'
  YV12 = FourCC 'Y', 'V', '1', '2'
  MJPG = FourCC 'M', 'J', 'P', 'G'

end

