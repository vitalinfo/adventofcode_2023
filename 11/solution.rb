# frozen_string_literal: true

require_relative '../base'

class Solution < Base
  private

  def perform1
    expansion_y, expansion_x = expansions_for(2)
    stars = stars_for(expansion_y, expansion_x)

    calc_dist_for(stars)
  end

  def perform2
    expansion_y, expansion_x = expansions_for(1_000_000)
    stars = stars_for(expansion_y, expansion_x)

    calc_dist_for(stars)
  end

  def rows
    @rows ||= input_lines.map { _1.strip.chars }
  end

  def expansions_for(multiply)
    expansion_y, expansion_x = [rows, rows.transpose].map do |xs|
      xs.reduce([]) do |expanded, col|
        prev = expanded.empty? ? -1 : expanded[-1]
        expanded << prev + (col.all? { _1 == '.' } ? multiply : 1)
      end
    end

    [expansion_y, expansion_x]
  end

  def stars_for(expansion_y, expansion_x)
    res = []
    (0...rows.size).each do |y|
      (0...rows[0].size).each do |x|
        res << [expansion_x[x], expansion_y[y]] if rows[y][x] == '#'
      end
    end
    res
  end

  def calc_dist_for(stars)
    res = 0
    (0...stars.size).each do |i|
      (0...i).each do |j|
        a = stars[i]
        b = stars[j]
        dist = (a[0] - b[0]).abs + (a[1] - b[1]).abs
        res += dist
      end
    end
    res
  end
end
