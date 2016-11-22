# global helper that uses a module to wrap methods and matches
module GlobalHelper
  extend RSpec::Matchers::DSL

  # METHODS

  # not get_match like everywhere else.
  # not testing override behavior, just scoping
  def get_global
    "Global"
  end

  # MATCHERS
  matcher :global_match do
    match do
      expect(get_global).to eq "Global"
    end
  end
end

