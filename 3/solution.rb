# frozen_string_literal: true

require_relative '../base'

class Solution < Base
  private

  # NOTE: could be improved with just to first non number or ., except collect all around symbols
  def perform1
    res = []
    input_lines.each_with_index do |line, l_index|
      n_index = 0
      line.strip!
      line.scan(/\d+/).each do |number|
        data = []
        n_index = line.index(number, n_index)

        data << line[n_index - 1] unless n_index.zero?
        data << line[n_index + number.size] if n_index + number.size < line.size

        data.concat(symbols_from_line(line, number, l_index, n_index, -1)) unless l_index.zero?

        data.concat(symbols_from_line(line, number, l_index, n_index, 1)) unless input_lines[l_index + 1].nil?

        n_index += number.size

        data = data.compact.delete_if { |item| item.match?(/\.|\d/) }
        res << number.to_i unless data.empty?
      end
    end
    res.sum
  end

  def perform2
    res = []
    input_lines.each_with_index do |line, l_index|
      s_index = 0
      line.strip!
      line.scan(/\*/).each do
        data = []
        s_index = line.index('*', s_index)
        # NOTE: right
        data << line.slice(s_index + 1, 3).gsub(/[^0-9]/, '').to_i if line[s_index + 1].to_s.match?(/\d/)
        # NOTE: left
        if (s_index - 1).positive? && line[s_index - 1].to_s.match?(/\d/)
          data << line.slice((s_index - 3).positive? ? s_index - 3 : 0, 3).gsub(/[^0-9]/, '').to_i
        end

        unless l_index.zero?
          p_line = input_lines[l_index - 1]

          data.concat(numbers_from_line(p_line, s_index))
        end

        unless input_lines[l_index + 1].nil?
          n_line = input_lines[l_index + 1]

          data.concat(numbers_from_line(n_line, s_index))
        end

        s_index += 1
        res << data if data.size > 1
      end
    end
    res.sum { |v| v.reduce(:*) }
  end

  def symbols_from_line(line, number, l_index, n_index, delta)
    res = []
    start_index = n_index.zero? ? n_index : n_index - 1
    end_index = n_index + number.size < line.size ? n_index + number.size : line.size
    start_index.upto(end_index) do |c_index|
      res << input_lines[l_index + delta].strip[c_index]
    end
    res
  end

  def numbers_from_line(line, s_index)
    indexes = []
    indexes << s_index if line[s_index].match?(/\d/)
    i = s_index + 1
    loop do
      break unless line[i].match?(/\d/)

      indexes << i
      i += 1
    end
    i = s_index - 1
    loop do
      break if !line[i].match?(/\d/) || i.negative?

      indexes << i
      i -= 1
    end

    indexes.size.positive? ? line[indexes.min..indexes.max].scan(/\d+/).map(&:to_i) : []
  end
end
