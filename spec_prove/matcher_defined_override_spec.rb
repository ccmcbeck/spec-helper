RSpec.describe "DSL matcher override" do

  # gets overridden by third matcher
  RSpec::Matchers.define :have_match do
    match do |item|
      puts "Using first local matcher"
      expect(item).to eq "First"
    end
  end

  it "fails to match first matcher" do
    puts "First example"
    expect("First").not_to have_match
  end

  # gets overridden by third matcher
  RSpec::Matchers.define :have_match do
    match do |item|
      puts "Using second local matcher"
      expect(item).to eq "Second"
    end
  end

  it "fails to match second matcher" do
    puts "Second example"
    expect("Second").not_to have_match
  end

  # scoping has no effect
  context "Scoped matcher" do

    # overrides all previous matchers
    RSpec::Matchers.define :have_match do
      match do |item|
        puts "Using third local matcher"
        expect(item).to eq "Third"
      end
    end

    it "matches final matcher declared in any scope" do
      puts "Scoped redefined example"
      expect("Third").to have_match
    end
  end
end
