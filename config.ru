require_relative 'app/index'

use Rack::Reloader
use Rack::Static, urls: %w(/css /js), root: 'app/assets'

run Index.new
