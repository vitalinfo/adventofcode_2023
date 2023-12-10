# frozen_string_literal: true

require_relative '../base'

class Solution < Base
  SYMBOLS = { '|' => %i[north south], '-' => %i[east west],
              'L' => %i[north east], 'J' => %i[north west],
              'F' => %i[south east], '7' => %i[south west],
              '.' => %i[] }.freeze
  DIRECTION_OFFSETS = { south: [1, 0], north: [-1, 0], east: [0, 1], west: [0, -1] }.freeze
  DIRECTION_OPPOSITES = { south: :north, north: :south, east: :west, west: :east }.freeze

  private

  def perform1
    start, pipes = parse
    start_pipe, direction = start_pipe(start, pipes)
    pipe_loop(pipes, start_pipe, direction).size / 2
  end

  def perform2
    start, pipes = parse
    start_pipe, direction = start_pipe(start, pipes)
    pipe_area(pipe_loop(pipes, start_pipe, direction))
  end

  def parse
    pipes = []
    start = [0, 0]
    input_lines.each_with_index do |line, i|
      start = [i, line =~ /S/] if line.match?(/S/)
      pipes.push(line.strip.chars)
    end

    [start, pipes]
  end

  def start_pipe(start, pipes)
    i, j = start
    if SYMBOLS[pipes[i][j + 1]].include?(:west)
      [[i, j + 1], :east]
    elsif SYMBOLS[pipes[i][j - 1]].include?(:east)
      [[i, j - 1], :west]
    elsif SYMBOLS[pipes[i + 1][j]].include?(:north)
      [[i + 1, j], :south]
    else
      [[i - 1, j], :north]
    end
  end

  def next_pipe(from, pipe)
    (SYMBOLS[pipe] - [from])[0]
  end

  def pipe_loop(pipes, start_pipe, direction)
    coords = []
    i, j = start_pipe
    coords.push([i, j])
    loop do
      direction = next_pipe(DIRECTION_OPPOSITES[direction], pipes[i][j])
      i += DIRECTION_OFFSETS[direction][0]
      j += DIRECTION_OFFSETS[direction][1]
      coords.push([i, j])
      return coords if pipes[i][j] == 'S'
    end
  end

  def pipe_area(loop)
    sum = 0
    loop.push(loop.first)
    loop.each_cons(2) do |n1, n2|
      x1, y1 = n1
      x2, y2 = n2
      sum += x1 * y2 - x2 * y1
    end
    (sum / 2).abs - (loop.size / 2) + 1
  end
end
