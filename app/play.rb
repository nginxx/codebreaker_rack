require_relative 'game'
# Managing game class
class Play
  def initialize
    @game = Game.new
  end

  def index
    reset
    @game.content = render('index.html.erb')
  end

  def start
    reset
    return define_name if @game.name.nil?
    guess
  end

  def call(env)
    @request = Rack::Request.new(env)
    router(@request.path_info)
    Rack::Response.new(render('layout.html.erb'))
  end

  private

  def router(route)
    case route
    when '/start' then start
    else index
    end
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def define_name
    @game.error = nil
    if @request['name'] && @game.validate('name', @request['name'])
      @game.name = @request['name']
      return @game.content = render('code.html.erb')
    elsif @request['name']
      @game.error = 'Enter valid name !'
    end
    @game.content = render('name.html.erb')
  end

  def guess
    @game.error, @game.result = nil
    if @request['code'] && @game.validate('number', @request['code'])
      @game.result = @game.compare_input(@request['code'])
    elsif @request['code']
      @game.error = 'Enter valid code !'
    end
    @game.content = render('code.html.erb')
  end

  def reset
    if !@request['reset'].nil? && (@game.result == 'won' || @game.result == 'lose')
      @game = Game.new
    end
  end
end
