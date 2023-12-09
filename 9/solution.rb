# frozen_string_literal: true

require_relative '../base'
require 'ostruct'

class Solution < Base
  private

  def perform1
    history.each do |item|
      sequences_for(item)
      calculate_new_right_for(item)
    end

    history.sum(&:new_right_value)
  end

  def perform2
    history.each do |item|
      calculate_new_left_for(item)
    end

    history.sum(&:new_left_value)
  end

  def calculate_new_right_for(item)
    item.new_right_value = item.sequences.map(&:last).sum + item.values.last
  end

  def calculate_new_left_for(item)
    sequence = item.sequences.reverse
    (0..sequence.size - 2).each do |index|
      sequence[index + 1].unshift(sequence[index + 1].first - sequence[index].first)
    end
    item.new_left_value = item.values.first - sequence.last.first
  end

  def history
    @history ||= input_lines.map do |line|
      OpenStruct.new(values: line.strip.split.map(&:to_i),
                     sequences: [],
                     new_right_value: nil,
                     new_left_value: nil)
    end
  end

  def sequences_for(item)
    current = item.values
    loop do
      sequence = []
      (0..current.size - 2).each do |index|
        sequence.push(current[index + 1] - current[index])
      end
      item.sequences.push(sequence)
      break if sequence.all?(&:zero?)

      current = sequence
    end
  end
end
