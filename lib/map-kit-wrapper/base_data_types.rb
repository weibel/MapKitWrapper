##
# Base data types
#
module BaseDataTypes

  ##
  # Simple vector implementation
  #
  class Vector
    ##
    # Total MKMap width in pixels
    #
    MERCATOR_OFFSET = 268435456.0

    ##
    # Map radius in pixels
    #
    MERCATOR_RADIUS = (MERCATOR_OFFSET / Math::PI)

    ##
    # Attr reader
    #
    attr_reader :x, :y

    def initialize(x, y)
      self.x, self.y = x, y
    end

    ##
    # Setter for x
    #
    # * *Args*    :
    #   - +x+ -> Int or Float
    #
    def x=(x)
      @x = x.to_f
    end

    ##
    # Setter for y
    #
    # * *Args*    :
    #   - +y+ -> Int or Float
    #
    def y=(y)
      @y = y.to_f
    end

    ##
    # Scalar multiplication
    #
    # * *Args*    :
    #   - +scalar+ -> Int or Float
    #
    def *(scalar)
      self.class.new(@x * scalar, @y * scalar)
    end

    ##
    # Scalar division
    #
    # * *Args*    :
    #   - +scalar+ -> Int or Float
    #
    def /(scalar)
      self.class.new(@x / scalar, @y / scalar)
    end

    ##
    # Addition
    #
    # * *Args*    :
    #   - +add+ -> Vector
    #
    # * *Returns* :
    #   - Vector
    #
    def +(add)
      self.class.new(@x + add.x, @y + add.y)
    end

    ##
    # Subtraction
    #
    # * *Args*    :
    #   - +sub+ -> Vector
    #
    # * *Returns* :
    #   - Vector
    #
    def -(sub)
      self.class.new(@x - sub.x, @y - sub.y)
    end

    ##
    # Find the span between two Vectors
    #
    # * *Args*    :
    #   - +spanner+ -> Vector
    #
    # * *Returns* :
    #   - Vector
    #
    def span_to(spanner)
      Vector.new((@x - spanner.x).abs, (@y - spanner.y).abs)
    end

    ##
    # Get self as an Array
    #
    # * *Returns* :
    #   - <tt>[latitude, longitude]</tt>
    #
    def to_a
      [@x, @y]
    end

    ##
    # Get self as a Hash
    #
    # * *Returns* :
    #   - <tt>{:x => x, :y => y}</tt>
    #
    def to_h
      {:x => x, :y => y}
    end

    ##
    # Get self as a String
    #
    # * *Returns* :
    #   - <tt>"{:x => x, :y => y}"</tt>
    #
    def to_s
      to_h.to_s
    end
  end
end
