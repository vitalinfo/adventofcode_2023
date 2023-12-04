# frozen_string_literal: true

require_relative '../base'

class Solution < Base
  private

  def perform1
    res = 0
    input_lines.each do |line|
      _, winning, numbers = data_from_line(line)
      winning_numbers = winning & numbers

      next if winning_numbers.empty?

      res += 2**(winning_numbers.size - 1)
    end
    res
  end

  def perform2
    multiplies = Hash.new(1)
    input_lines.each do |line|
      card_number, winning, numbers = data_from_line(line)
      winning_numbers = winning & numbers
      multiplies[card_number] = 1 unless multiplies.key?(card_number)

      next if winning_numbers.empty?

      multiplies = multiply_cards(multiplies, card_number, winning_numbers)
    end

    multiplies.values.sum
  end

  def data_from_line(line)
    data = line.strip.split(/:|\|/)

    [data.first.gsub(/[^0-9]+/, '').to_i,
     data[1].split,
     data.last.split]
  end

  def multiply_cards(multiplies, card_number, winning_numbers)
    winning_numbers.size.times do |index|
      multiplies[card_number].times do
        multiplies[card_number + index + 1] += 1
      end
    end
    multiplies
  end
end
