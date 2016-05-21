require 'json'
# Game api class
class Game
  ATTEMPTS = 4
  CODE_SIZE = 4
  NUM_RANGE = 1..6

  attr_accessor :name, :secret_code, :attempts,
                :error, :result, :content, :hints

  def initialize
    @secret_code = code_generator
    @error, @result, @content, @name = nil
    @attempts = 0
    @hints = @secret_code.chars.sample
    @win = false
    @start_time = Time.now
  end

  def compare_input(num)
    return count_attempts(num) unless num == @secret_code
    @win = true
    save_result
    'won'
  end

  def validate(rule, item)
    case rule
    when 'name' then item =~ /^[a-zA-Z]+$/
    when 'number' then item =~ /^[1-6]+$/ && item.length == CODE_SIZE
    end
  end

  private

  def code_generator
    code = []
    CODE_SIZE.times { code << rand(NUM_RANGE) }
    code.join
  end

  def save_result
    time = (Time.now - @start_time).to_i
    result = { name: @name, secret_code: @secret_code, attempts: @attempts,
              hints: @hints, win: @win, time: "#{time} sec" }
    File.open('results.json', 'a+') do |f|
      f.puts(result.to_json)
    end
  end

  def match_position(num)
    code = @secret_code.chars
    num = num.chars
    guess = num.map.with_index do |item, index|
      next unless item == code[index]
      code[index] = nil
      '+'
    end
    num.each do |item|
      next unless code.include?(item)
      guess << '-'
      code.delete_at(code.index(item))
    end
    guess.join
  end

  def count_attempts(num)
    @attempts += 1
    return "Your guess: #{match_position(num)}" unless @attempts == ATTEMPTS
    save_result
    'lose'
  end
end
