# frozen_string_literal: true
RSpec.configure do |config|
  config.include_context "mocks"
  config.include_context Async::RSpec::Reactor
end
