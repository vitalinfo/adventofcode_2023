class Range
  # Compute the range over which this range and the specified other range
  # overlap. Returns nil if no such overlap exists.
  def intersection(other)
    last_element = ->(range) { range.exclude_end? ? range.max : range.last }
    self_max = last_element.call(self)
    other_max = last_element.call(other)
    return nil if other.first > self_max || first > other_max

    [first, other.first].max..[self_max, other_max].min
  end

  alias & intersection
end