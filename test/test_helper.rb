ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

# Helper para testes de integração
class ActionDispatch::IntegrationTest
  def login_as(user)
    post login_path, params: { email: user.email, password: "96334505" }
    follow_redirect! # Garante que a resposta redirecione corretamente
  end
end
