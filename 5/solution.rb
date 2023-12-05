# frozen_string_literal: true

require_relative '../base'
require 'ostruct'

class Solution < Base
  private

  def perform1
    seeds, maps = parse1

    dst = seeds.map do |seed|
      maps.reduce(seed) do |value, map|
        res = map.each_slice(3).find { |(_, source, length)| value >= source && value < source + length }
        res ? value - res[1] + res[0] : value
      end
    end

    dst.min
  end

  def perform2
    seeds, maps = parse2
    seed_ranges = seed_ranges_for(seeds)

    maps.reduce(seed_ranges) do |ranges, map|
      ranges.map do |src|
        dest_for(map, src)
      end.flatten.sort { _1.first <=> _2.first }
    end.first.first
  end

  def parse1
    seeds, *maps = input.split("\n\n")
    seeds = seeds.split[1..].map(&:to_i)
    maps = maps.map { _1.split.map(&:to_i)[2..] }

    [seeds, maps]
  end

  def parse2
    seeds, *maps = input.split("\n\n").map { _1.lines(chomp: true) }
    seeds = seeds.first.scan(/\d+/).map(&:to_i)

    [seeds, maps_for(maps)]
  end

  def maps_for(maps)
    maps.map do |_, *map|
      map.map do
        dest, source, length = _1.scan(/\d+/).map(&:to_i)
        OpenStruct.new(source: source...(source + length), offset: dest - source)
      end.sort { _1.source.first <=> _2.source.first }
    end
  end

  def seed_ranges_for(seeds)
    seeds.each_slice(2)
         .map { _1...(_1 + _2) }
         .sort { _1.first <=> _2.first }
  end

  def dest_for(map, src)
    # Any subrange that does not fall within a mapping remains identity-
    # mapped, but the entire range must be preserved.
    dest = map.filter_map do |mapping|
      n = src & mapping.source
      next unless n

      [n, (n.first + mapping.offset)..(n.max + mapping.offset)]
    end

    return src if dest.empty?

    # Mappings are contiguous, so we only need to check the bounds of the
    # range to determine what is not covered by another mapping.
    first_n = dest.first.first.first
    last_n = dest.last.first.max
    dest = dest.map(&:last)
    dest << (src.first...first_n) if src.first < first_n
    dest << (last_n...src.max) if src.max > last_n
    dest
  end
end
