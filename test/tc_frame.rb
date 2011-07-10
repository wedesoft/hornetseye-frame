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

  UBYTERGB = Hornetseye::UBYTERGB

  BGR  = Hornetseye::BGR
  UYVY = Hornetseye::UYVY
  YUY2 = Hornetseye::YUY2
  I420 = Hornetseye::I420
  YV12 = Hornetseye::YV12

  F = Hornetseye::Frame

  def C( *args )
    Hornetseye::RGB *args
  end

  def M( *args )
    Hornetseye::MultiArray *args
  end

  def F( *args )
    Hornetseye::Frame *args
  end

  def test_frame_inspect
    assert_equal 'Frame(YV12)', F(YV12).inspect
  end

  def test_frame_to_s
    assert_equal 'Frame(YV12)', F(YV12).to_s
  end

  def test_frame_typecode
    assert_equal YV12, F(YV12).typecode
  end

  def test_frame_equal
    assert_equal F(YV12), F(YV12)
    assert_not_equal F(YV12), F(I420)
  end

  def test_dup
    f = F.new UYVY, 8, 2
    f.memory.write 'abcd'
    f.dup.memory.write 'efgh'
    assert_equal 'abcd', f.memory.read(4)
  end

  def test_typecode
    assert_equal YV12, F.new(YV12, 320, 240).typecode
  end

  def test_shape
    assert_equal [320, 240], F.new(YV12, 320, 240).shape
  end

  def test_width
    assert_equal 320, F.new(YV12, 320, 240).width
  end

  def test_height
    assert_equal 240, F.new(YV12, 320, 240).height
  end

  def test_to_type
    m = M(Hornetseye::UBYTERGB, 2).new(160, 120).fill! C( 32, 64, 128 )
    [ UYVY, YUY2, I420, YV12 ].each do |c|
      result = m.to_type( c ).to_type UBYTERGB
      assert_equal ( m / 8.0 ).round, ( result / 8.0 ).round
    end
  end

end

