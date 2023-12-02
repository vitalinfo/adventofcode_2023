# frozen_string_literal: true

class Base
  def perform
    puts("Part 1 result: #{perform1}")
    puts("Part 2 result: #{perform2}")
  end

  private

  def input_filepath
    Object.const_source_location(self.class.name).first.gsub(/solution\.rb/, 'input.txt')
  end

  def input_lines
    File.readlines(input_filepath)
  end

  def input
    File.read(input_filepath)
  end

  def perform1
    raise NotImplementedError
  end

  def perform2
    raise NotImplementedError
  end
end
