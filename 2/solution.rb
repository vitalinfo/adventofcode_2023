# frozen_string_literal: true

require_relative '../base'

class Solution < Base
  MAX = { 'red' => 12,
          'green' => 13,
          'blue' => 14 }.freeze
  COLORS = %w[red green blue].freeze

  private

  def perform1
    data.select do |_, sets|
      sets.all? do |color, set|
        MAX[color] >= set.max
      end
    end.keys.sum
  end

  def perform2
    data.map do |_, sets|
      sets.map do |_, set|
        set.max
      end.inject(:*)
    end.inject(:+)
  end

  def data
    @data ||= begin
      res = {}
      input_lines.each do |line|
        game_id = game_id_from(line)
        res[game_id] = {}

        results_from(line).each do |set|
          parse_set(set).each_pair do |color, amount|
            res[game_id][color] ||= []
            res[game_id][color].push(amount)
          end
        end
      end
      res
    end
  end

  def game_id_from(line)
    line.match(/Game (\d+):/) && ::Regexp.last_match(1).to_i
  end

  def parse_set(set)
    res = {}
    COLORS.each do |color|
      next if set.match(/(\d+) #{color}/).nil?

      res[color] = ::Regexp.last_match(1).to_i
    end
    res
  end

  def results_from(line)
    line.gsub(/Game (\d+):/, '').strip.split('; ')
  end
end
