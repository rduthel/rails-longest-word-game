class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @letters    = generate_grid(9)
  end

  def score
    @end_time   = Time.now
    @start_time = Time.parse(params[:start_time])
    @attempt    = params[:answer]
    @letters    = params[:grid]
    @result     = run_game(@attempt, @letters, @start_time, @end_time)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    charset = [*('A'..'Z')]
    (0...grid_size).map { charset[rand(charset.size)] }
  end

  def clean_string(string)
    string.downcase.gsub(/\W/, '').chars.sort
  end

  def count_char(string)
    h = {}
    string = clean_string(string)
    string.each { |char| h[char.to_s] = string.count(char) }
    h
  end

  def word_in_another?(a_string, another_string)
    # TODO: implement the improved method
    a_string       = count_char(a_string)
    another_string = count_char(another_string)
    a_string.all? do |key, value|
      another_string.key?(key) && another_string.value?(value)
    end
  end

  def test_exist(attempt)
    url        = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    check_word = open(url).read
    word       = JSON.parse(check_word)
    word['found']
  end

  def define_message(attempt, grid)
    if word_in_another?(attempt, grid)
      if test_exist(attempt)
        'well done'
      else
        'not an english word'
      end
    else
      'not in the grid'
    end
  end

  def compute_score(attempt, grid, start_time, end_time)
    score_time   = (1 / (end_time - start_time)) * 10
    score_length = attempt.length * 100
    if word_in_another?(attempt, grid) && test_exist(attempt)
      (score_time + score_length).round
    else
      0
    end
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    result           = {}
    result[:time]    = end_time - start_time
    result[:score]   = compute_score(attempt, grid, start_time, end_time)
    result[:message] = define_message(attempt, grid)
    result
  end
end
