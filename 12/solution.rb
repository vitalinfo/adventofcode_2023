# frozen_string_literal: true

require_relative '../base'
require 'parallel'

class Solution < Base
  private

  def perform1
    input_lines.map do |line|
      pattern, group = line.strip.chomp.split(' ')
      calculate_for(pattern.chars, group.split(',').map(&:to_i))
    end.sum
  end

  def perform2
    Parallel.map(input_lines, in_processes: 10) do |line, _|
      pattern, group = line.strip.chomp.split(' ')
      calculate_for(([pattern] * 5).join('?').chars,
                    group.split(',').map(&:to_i) * 5)
    end.sum
  end

  def calculate_for(chars, group)
    unknown_indxes = chars.each_with_index.filter_map { |char, index| index if char == '?' }
    (0...2**unknown_indxes.size).count do |index|
      unknown_indxes.each_with_index { |i, j| chars[i] = (index & (1 << j)).zero? ? '.' : '#' }
      valid?(chars, group)
    end
  end

  def valid?(chars, group)
    chars.chunk { _1 }.filter_map { |char, seq| seq.count if char == '#' } == group
  end
end
