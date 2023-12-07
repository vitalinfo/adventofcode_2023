# frozen_string_literal: true

require_relative '../base'
require 'ostruct'

class Solution < Base
  COSTS = {
    [5] => 6,
    [4, 1] => 5,
    [3, 2] => 4,
    [3, 1, 1] => 3,
    [2, 2, 1] => 2,
    [2, 1, 1, 1] => 1,
    [1, 1, 1, 1, 1] => 0
  }.freeze

  CARDS = {
    A: 14,
    K: 13,
    Q: 12,
    J: 11,
    T: 10,
    Z: 0
  }.freeze

  private

  def perform1
    game = game_for

    calculate_ranks_for(game)

    game.map { _1.bid * _1.rank }.sum
  end

  def perform2
    game = game_for(joker: true)

    calculate_ranks_for(game)

    game.map { _1.bid * _1.rank }.sum
  end

  def calculate_ranks_for(game)
    loop_for(game) do |hand1, hand2|
      if winning?(hand1.cards, hand2.cards)
        hand1.rank += 1
      else
        hand2.rank += 1
      end
    end
  end

  def loop_for(game)
    game.each_with_index do |hand1, index1|
      (index1 + 1...game.size).each do |index2|
        hand2 = game[index2]

        yield hand1, hand2
      end
    end
  end

  def game_for(joker: false)
    input_lines.map do |line|
      cards, bid = line.strip.split(' ')
      cards = joker ? cards.gsub(/J/, 'Z') : cards
      OpenStruct.new({ init: cards,
                       cards: cards.split('').map { (CARDS[_1.to_sym] || _1).to_i },
                       bid: bid.to_i,
                       rank: 1 })
    end
  end

  def jokerize_tally(tally)
    return tally unless tally.key?(0)

    count = tally.delete(0)
    add_to = tally.max_by { |_, v| v }&.first.to_i

    tally[add_to] = tally[add_to].to_i + count

    tally
  end

  def winning?(cards1, cards2)
    tally1 = cards1.tally
    tally2 = cards2.tally

    tally1 = jokerize_tally(tally1)
    tally2 = jokerize_tally(tally2)

    cost1 = COSTS[tally1.values.sort.reverse]
    cost2 = COSTS[tally2.values.sort.reverse]

    return cost1 > cost2 if cost1 != cost2

    (cards1 <=> cards2).positive?
  end
end
