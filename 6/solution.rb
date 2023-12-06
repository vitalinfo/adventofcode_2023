# frozen_string_literal: true

require_relative '../base'
require 'ostruct'

class Solution < Base
  private

  def perform1
    times, distances = input_lines.map { |line| line.scan(/\d+/).map(&:to_i) }

    calculate(times, distances)
  end

  def perform2
    times, distances = input_lines.map { |line| line.gsub(/[^0-9]/, '').scan(/\d+/).map(&:to_i) }

    calculate(times, distances)
  end

  def calculate(times, distances)
    times.zip(distances).reduce(1) do |res, (time, distance)|
      res * (0...time).count do |time_to_hold|
        speed = time_to_hold
        remaining_time = time - time_to_hold
        dist = speed * remaining_time
        dist > distance
      end
    end
  end
end
