# CONFIG
RSpec.configure do |config|
end

# SHARED EXAMPLES
shared_examples_for :vendor_example do
  it { expect(get_global).to eq "Global" }
end
