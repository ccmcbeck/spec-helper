module DevelopersControllerHelper
  extend RSpec::Matchers::DSL

  # METHODS
  def get_match
    "Developers"
  end

  # MATCHERS
  matcher :have_match do
    match do
      expect(get_match).to eq "Developers"
    end

    failure_message do
      "expected #{get_match} to eq Developers"
    end
  end
end

# SHARED EXAMPLES
shared_examples_for :developers_controller_example do
  specify { expect(get_match).to eq "Developers" }
end

