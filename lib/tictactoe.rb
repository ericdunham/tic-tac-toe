# frozen_string_literal: true

# A simple library to play tic-tac-toe
class TicTacToe
  # A 2-dimensional array of every winning slice on a board.
  #
  # A winning slice is defined as the 3-element +Array+ of indexes that, if they
  # all contained the same token, would indicate a win for the player of that
  # token.
  WINNING_SLICES = [
    [0, 1, 2], # across the top
    [3, 4, 5], # across the middle
    [6, 7, 8], # across the bottom
    [0, 3, 6], # down the left
    [1, 4, 7], # down the middle
    [2, 5, 8], # down the right
    [0, 4, 8], # diagonal from top-left
    [2, 4, 6] # diagonal from top-right
  ].freeze

  # Returns a copy of the current board as an +Array+.
  def board
    @board.dup
  end

  # Creates a new tic-tac-toe board, initialized with +board+, or empty.
  #
  # Params:
  # +board+:: +Array+ (containing 'X', 'O', or +nil+)
  def initialize(board = nil)
    @board = board || Array.new(9)
  end

  # Returns whether or not the game is over, either by it being won or it being
  # unable to be won.
  def game_over?
    won? || stalemate?
  end

  # Returns whether or not the board is occupied at index +i+.
  #
  # Params:
  # +i+:: +Integer+
  def occupied?(i)
    !@board[i].nil?
  end

  # Returns whether or not the index +i+ is within the bounds of the board.
  #
  # Params:
  # +i+:: +Integer+
  def out_of_bounds?(i)
    !i.between?(0, 8)
  end

  # Plays the given +token+ (an 'X' or an 'O') at index +i+, returning the new
  # board.
  # If +token+ is invalid, the current board is returned, unchanged.
  #
  # Params:
  # +token+:: The +String+ 'X' or 'O'
  # +i+:: Integer
  def place(token, i)
    return board unless %w[X O].include? token
    @board[i] = token
    board
  end

  # Returns a pretty (well, prettier than +Array#inspect#) version of the
  # current board, complete with borders and such.
  def pretty
    # return the token or an empty space if there is no token
    t = ->(i) { @board[i] || ' ' }
    # this heredoc could be replaced with some fancy map calls along with
    # each_slice and then interspersing borders, but I think this is ultimately
    # clearer and not nearly as clever
    <<~BOARD
      -------------
      | #{t.call 0} | #{t.call 1} | #{t.call 2} |
      -------------
      | #{t.call 3} | #{t.call 4} | #{t.call 5} |
      -------------
      | #{t.call 6} | #{t.call 7} | #{t.call 8} |
      -------------
    BOARD
  end

  # Returns whether or not the current game is a stalemate.
  def stalemate?
    @board.select(&:nil?).size <= 1 && !won? && !win_possible?
  end

  # Returns whether or not a win is possible for Xs or Os.
  #
  # see #stalemate?
  def win_possible?
    return true if won?
    with_xs, with_os = win_scenarios
    !with_xs.winner.nil? || !with_os.winner.nil?
  end

  # Returns the possible win scenarios remaining with the current board, which
  # effectively involves filling every empty space with Xs or Os, and returning
  # an +Array+ of +TicTacToe+ boards, of length 2.
  def win_scenarios
    [self.class.new(board.map { |t| t.nil? ? 'X' : t }),
     self.class.new(board.map { |t| t.nil? ? 'O' : t })]
  end

  # Returns the winning token on the current board, otherwise +nil+.
  def winner
    WINNING_SLICES.each do |(i, j, k)|
      return @board[i] if [@board[i], @board[j], @board[k]].uniq.length == 1
    end
    nil
  end

  # Returns whether or not this game has been won.
  # see: #game_over?
  # see: #stalemate?
  def won?
    !winner.nil?
  end
end
