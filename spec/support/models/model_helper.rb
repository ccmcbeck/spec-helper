module ModelHelper
  extend RSpec::Matchers::DSL

  # METHODS
  def get_match
    "Model"
  end

  # MATCHERS
  matcher :have_match do
    match do
      expect(get_match).to eq "Model"
    end

    failure_message do
      "expected #{get_match} to eq Model"
    end
  end
end
