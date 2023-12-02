# frozen_string_literal: true

require_relative '../base'

class Solution < Base
  LETTERS_NUMBERS = { 'one': '1',
                      'two': '2',
                      'three': '3',
                      'four': '4',
                      'five': '5',
                      'six': '6',
                      'seven': '7',
                      'eight': '8',
                      'nine': '9' }.freeze

  private

  def perform1
    input_lines.each.map do |line|
      number_from_line(line)
    end.sum
  end

  def perform2
    input_lines.each.map do |line|
      LETTERS_NUMBERS.each_pair do |letter, number|
        line.scan(letter.to_s).each do
          loop do
            break if (index = line.index(letter.to_s)).nil?

            line[(index + letter.to_s.size / 2)] = number
          end
        end
      end
      number_from_line(line)
    end.sum
  end

  def number_from_line(line)
    numbers = line.gsub(/[^0-9]/, '').split('')
    "#{numbers.first}#{numbers.last}".to_i
  end
end
