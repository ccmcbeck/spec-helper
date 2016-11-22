module AdminControllerHelper
  extend RSpec::Matchers::DSL

  # METHODS
  def get_match
    "Admin"
  end

  # MATCHERS
  matcher :have_match do
    match do
      expect(get_match).to eq "Admin"
    end

    failure_message do
      "expected #{get_match} to eq Admin"
    end
  end
end

# SHARED EXAMPLES
shared_examples_for :admin_controller_example do
  specify { expect(get_match).to eq "Admin" }
end

