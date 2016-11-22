RSpec::Matchers.define :have_match do
  match do |item|
    puts "Using global matcher"
    expect(item).to eq "Global"
  end
end

RSpec.describe "DSL matcher override" do

  it "fails to match global matcher" do
    puts "Global example"
    expect("Second").to have_match
  end

  # gets overridden by second matcher
  matcher :have_match do
    match do |item|
      puts "Using first local matcher"
      expect(item).to eq "First"
    end
  end

  it "fails to match first matcher" do
    puts "First example"
    expect("First").not_to have_match
  end

  # overrides the first matcher
  matcher :have_match do
    match do |item|
      puts "Using second local matcher"
      expect(item).to eq "Second"
    end
  end

  it "matches the second matcher" do
    puts "Second example"
    expect("Second").to have_match
  end

  # but scoping works
  context "Scoped matcher" do

    matcher :have_match do
      match do |item|
        puts "Using first local matcher"
        expect(item).to eq "Third"
      end
    end

    it "matches the third scoped matcher" do
      puts "Scoped redefined example"
      expect("Third").to have_match
    end
  end

  # sibling honors example_group scope
  context "Sibling matcher" do

    it "matches the second scoped matcher" do
      puts "Sibling example"
      expect("Second").to have_match
    end
  end
end
