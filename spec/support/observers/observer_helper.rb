module ObserverHelper
  extend RSpec::Matchers::DSL

  # METHODS
  def get_match
    "Observer"
  end

  # MATCHERS
  matcher :have_match do
    match do
      expect(get_match).to eq "Observer"
    end

    failure_message do
      "expected #{get_match} to eq Observer"
    end
  end
end

# SHARED EXAMPLES
shared_examples_for :observer_example do
  it_behaves_like :vendor_example
end

