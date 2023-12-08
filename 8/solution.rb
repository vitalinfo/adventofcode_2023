# frozen_string_literal: true

require_relative '../base'
require 'ostruct'

class Solution < Base
  START_NODE = 'AAA'
  END_NODE = 'ZZZ'
  INSTRUCTION_REMAP = {
    L: :left,
    R: :right
  }.freeze

  private

  def perform1
    current = START_NODE
    count = 0
    instructions, nodes = parse
    current_instructions = []

    loop do
      current_instructions = instructions.split('') if current_instructions.empty?
      instruction = current_instructions.shift
      current = nodes[current][INSTRUCTION_REMAP[instruction.to_sym]]
      count += 1
      break if current == END_NODE
    end

    count
  end

  def perform2
    instructions, nodes = parse
    nodes.keys.filter { _1.end_with?('A') }.map do |node|
      count_for(node, instructions, nodes) { _1.end_with?('Z') }
    end.reduce(&:lcm)
  end

  def count_for(node, instructions, nodes, &condition)
    (0...).each do |step|
      break step if condition.call(node)

      node = nodes[node][INSTRUCTION_REMAP[instructions[step % instructions.length].to_sym]]
    end
  end

  def parse
    instructions, *nodes = input.split("\n\n")

    nodes = nodes.first.split("\n").map do
      item, left, right = _1.scan(/[A-Z0-9]{3}/)

      [item, OpenStruct.new({ left: left, right: right })]
    end.to_h

    [instructions, nodes]
  end
end
