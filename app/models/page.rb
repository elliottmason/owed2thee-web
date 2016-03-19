class Page
  def initialize(value = nil)
    @value = Integer(value || 1)
    @value = 1 if @value < 1
  end

  # def -(other)
  #   self.class.new(@value - other)
  # end

  # def +(other)
  #   self.class.new(@value + other)
  # end

  # def ==(other)
  #   @value == other.to_i
  # end

  def to_i
    @value.to_i
  end
end
