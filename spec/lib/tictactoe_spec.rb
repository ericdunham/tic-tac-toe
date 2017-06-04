# frozen_string_literal: true

require_relative '../../lib/tictactoe'

describe TicTacToe do
  let(:win_with_x) { TicTacToe.new %w[X X X] }
  let(:win_with_o) { TicTacToe.new %w[O O O] }
  let(:stalemate) { TicTacToe.new %w[X X O O O X X O X] }
  let(:possible) { TicTacToe.new ['X', nil, 'O', 'O', 'O', 'X', 'X', 'O', 'X'] }

  describe '#board' do
    it 'returns the current board' do
      expect(subject.board).to eq subject.instance_variable_get(:@board)
    end
    it 'returns a copy of the current board' do
      expect(subject.board).to_not equal subject.instance_variable_get(:@board)
    end
    it 'returns the board as an array' do
      expect(subject.board).to be_an Array
    end
  end

  describe '#game_over?' do
    it 'returns true on a winning board' do
      (0..2).each { |i| subject.place 'X', i }
      expect(subject).to be_game_over
    end
    it 'returns true on a stalemate board' do
      expect(stalemate).to_not be_won
      expect(stalemate).to be_game_over
    end
    it 'returns false on an incomplete board' do
      expect(subject).to_not be_game_over
    end
  end

  describe '#occupied?' do
    it 'returns true if there is a token in the requested spot' do
      subject.place 'X', 0
      expect(subject.occupied?(0)).to be true
    end
    it 'returns false if there is no token in the requested spot' do
      expect(subject.occupied?(0)).to be false
    end
  end

  describe '#out_of_bounds?' do
    it 'returns true if the index is not on the board' do
      expect(subject.out_of_bounds?(9)).to be true
    end
    it 'returns false if the index is on the board' do
      expect(subject.out_of_bounds?(0)).to be false
    end
  end

  describe '#place' do
    it 'puts the token on the board if it is a valid token' do
      subject.place 'X', 0
      expect(subject.board[0]).to eq 'X'
    end
    it 'returns the unchanged board if the token is invalid' do
      subject.place :foo, 0
      expect(subject.board[0]).to be_nil
    end
  end

  describe '#pretty' do
    it 'pretty prints an empty board' do
      expected = <<~BOARD
        -------------
        |   |   |   |
        -------------
        |   |   |   |
        -------------
        |   |   |   |
        -------------
      BOARD
      expect(subject.pretty).to eq expected
    end
    it 'pretty prints a board with tokens' do
      expected = <<~BOARD
        -------------
        | X | X | O |
        -------------
        | O | O | X |
        -------------
        | X | O | X |
        -------------
      BOARD
      expect(stalemate.pretty).to eq expected
    end
  end

  describe '#stalemate?' do
    it 'returns false if the board is too empty to make a determination' do
      expect(subject).to_not be_stalemate
    end
    it 'returns false if the board has a winner' do
      expect(win_with_x).to_not be_stalemate
    end
    it 'returns false if the board could have a winner' do
      expect(possible).to_not be_stalemate
    end
    it 'returns true if nobody can win' do
      expect(stalemate).to be_stalemate
    end
  end

  describe '#win_possible?' do
    it 'returns true if the board has already been won' do
      (0..2).each { |i| subject.place 'X', i }
      expect(subject).to be_win_possible
    end
    it 'returns true if the board can be won by either token' do
      expect(possible).to be_win_possible
    end
    it 'returns false if the board cannot be won' do
      expect(stalemate).to_not be_win_possible
    end
  end

  describe '#win_scenarios' do
    it 'returns two boards with empty spaces filled with Xs or Os' do
      xs, os = subject.win_scenarios
      expect(xs.board.all? { |t| t == 'X' }).to be true
      expect(os.board.all? { |t| t == 'O' }).to be true
    end
  end

  describe '#winner' do
    it 'returns X if X is the winner' do
      expect(win_with_x.winner).to eq 'X'
    end
    it 'returns O if O is the winner' do
      expect(win_with_o.winner).to eq 'O'
    end
    it 'returns nil if there is no winner' do
      expect(subject.winner).to be_nil
    end
  end

  describe '#won?' do
    it 'returns true if X is the winner' do
      expect(win_with_x).to be_won
    end
    it 'returns true if O is the winner' do
      expect(win_with_o).to be_won
    end
    it 'returns false if there is no winner' do
      expect(subject).to_not be_won
    end
  end
end
