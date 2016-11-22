module ModelHelper
  extend RSpec::Matchers::DSL
  matcher :have_match do
    match do |item|
      puts "Using model_helper matcher"
      expect(item).to eq "Model"
    end
  end
end

module ControllerHelper
  extend RSpec::Matchers::DSL
  matcher :have_match do
    match do |item|
      puts "Using controller_helper matcher"
      expect(item).to eq "Controller"
    end
  end
end

RSpec.configure do |c|
  c.include ModelHelper, type: :model
  c.include ControllerHelper, type: :controller
end

RSpec.describe "Model", type: :model do
  it "matches model matcher" do
    expect("Model").to have_match
  end
end

RSpec.describe "Controller", type: :controller do
  it "matches controller matcher" do
    expect("Controller").to have_match
  end
end
