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

require 'test/unit'
begin
  require 'rubygems'
rescue LoadError
end
Kernel::require 'hornetseye_frame'

class TC_Frame < Test::Unit::TestCase

  YV12 = Hornetseye::YV12

  def F( *args )
    Hornetseye::Frame *args
  end

  def test_frame_inspect
    assert_equal 'Frame(YV12,320,240)', F( YV12, 320, 240 ).inspect
  end

  def test_frame_to_s
    assert_equal 'Frame(YV12,320,240)', F( YV12, 320, 240 ).to_s
  end

  def test_frame_shape
    assert_equal [ 320, 240 ], F( YV12, 320, 240 ).shape
  end

  def test_typecode
    assert_equal YV12, F( YV12, 320, 240 ).typecode
  end

  def test_shape
    assert_equal [ 320, 240 ], F( YV12, 320, 240 ).shape
  end

  def test_width
    assert_equal 320, F( YV12, 320, 240 ).width
  end

  def test_height
    assert_equal 240, F( YV12, 320, 240 ).height
  end

end

