# multiarray - Lazy multi-dimensional arrays for Ruby
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

  module FrameConstructor

    def method_missing( name, *args )
      if name.to_s =~ /^[a-z0-9]+$/
        target = name.to_s.upcase
        if Hornetseye.const_defined? target
          target = Hornetseye.const_get target
          if target.is_a? FourCC
            new target, *args
          else
            super name, *args
          end
        else
          super name, *args
        end
      else
        super name, *args
      end
    end

  end

  Frame.extend FrameConstructor

  module FrameConversion

    def method_missing( name, *args )
      if name.to_s =~ /^to_[a-z0-9]+$/
        target = name.to_s[ 3 .. -1 ].upcase
        if Hornetseye.const_defined? target
          target = Hornetseye.const_get target
          if ( target.is_a? Class and target < Element ) or target.is_a? FourCC
            to_type target, *args
          else
            super target, *args
          end
        else
          super name, *args
        end
      else
        super name, *args
      end
    end

  end

  Frame_.class_eval { include FrameConversion }

  Node.class_eval { include FrameConversion }

end

