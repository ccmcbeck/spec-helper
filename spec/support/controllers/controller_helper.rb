module ControllerHelper
  extend RSpec::Matchers::DSL

  # METHODS
  def get_match
    "Controller"
  end

  # MATCHERS
  matcher :have_match do
    match do
      expect(get_match).to eq "Controller"
    end

    failure_message do
      "expected #{get_match} to eq Controller"
    end
  end
end

# SHARED EXAMPLES
shared_examples_for :controller_example do
  it_behaves_like :vendor_example
end

# shared example with a namespaced method #method
shared_examples_for :controller_param_example do |str|
  specify { expect(get_match).to eq str }
end

