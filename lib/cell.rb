require 'set'

class Cell

  attr_reader :slices, :value

  def initialize(value)
    @value = value.to_i
    @slices = []
  end

  def add_slice(slice)
    @slices << slice
  end

  def solved?
  	@value && @value != 0
  end

  def to_s
  	return '_' unless solved?
  	@value.to_s
  end

  def solve!
  	return if solved?
  	candidates = (1..9).to_set.subtract(neighbours)
  	@value = candidates.first if candidates.length == 1
  end

  def neighbours
  	@slices.flatten.map(&:value).inject(Set.new) {|set, digit| set << digit}.delete(0)
  end
  
end