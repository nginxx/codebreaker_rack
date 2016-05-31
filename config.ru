require_relative 'app/play'

use Rack::Reloader
use Rack::Static, urls: %w(/css /js), root: 'app/assets'

run Play.new
