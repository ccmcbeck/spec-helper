module WorkerHelper
  extend RSpec::Matchers::DSL

  # METHODS
  def get_match
    "Worker"
  end

  # MATCHERS
  matcher :have_match do
    match do
      expect(get_match).to eq "Worker"
    end

    failure_message do
      "expected #{get_match} to eq Worker"
    end
  end
end

# SHARED EXAMPLES

shared_examples_for :worker_example do
  it_behaves_like :vendor_example
end

