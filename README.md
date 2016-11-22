# Spec Helpers

This Rails project is an RSpec design pattern and best practices for modularizing the `/spec/support` folder when a project grows too big.

## Macros

"Macro" is an umbrella term for RSpec helper constructs:

* Methods
* Matchers using either:
    * `RSpec::Matchers.define do...end`
    * `extend RSpec::Matchers::DSL` and `matcher do...end`
* Shared Examples and Contexts

## Tools

* `rspec -fd` to run the `/spec` tests on the design pattern
* `lib/scripts/prove.sh` to figure out how RSpec macros really works
* `lib/scripts/type.sh` confirms that `/spec` works independent of order
* `lib/scripts/subtype.sh` confirms that `subtype` metadata isolation
* `lib/scripts/all.sh` runs the previous 3 in succession

## Best Practices

Here are the practices I came up with:

### Helpers

1. Automatically `require` all helper files in `spec/support`
    1. No need to `require` manually
1. Use separate `spec/support/<folder>` to segment helpers for easy lookup:
    1. One folder for each spec type (e.g., `request`, `model`)
    1. `vendor` folder for gems, rails monkey-patches, etc. Forex:
        1. `spec/support/vendor/capybara.rb`
    1. `global` for project helpers that are global to all spec types
        1. `spec/support/global/translation_helper.rb`
1. Name helper files according to purpose.  Forex:
    1. `vendor.rb` is inline and not wrapped in a `module` Forex:
        1. `capybara.rb` has `RSpec.configure` statements
    1. `model_helper.rb` has all the common macros for models
        1. "methods" and "matchers" wrapped in a `module` like `ModelHelper`
        1. "shared_examples" appear inline after the module definition
            1. Eventually `model_examples.rb` might contain just the shared examples
1. Add new `:type` metadata for new types with `define_derived_metadata`
    1. This metadata can be used to `RSpec.configure include WorkerHelper, type: :worker`
1. Add `:subtype` metadata for nested folders / namespaces.  Forex:
    1. `subtype: :admin_controller` for ActiveAdmin
    2. `subtype: :api_request` for your API

### Methods

1. Don't define global methods since they get mixed-in to `Object`
1. Scope all methods inside `module <Name>Helper` for proper encapsulation
    1. Use `RSpec.configure #include Helper <metadata>` for selective inclusion
    1. Allows consistently named methods like `sign_in` to behave differently by context

### Matchers

1. Use `RSpec::Matchers.define` for global matchers
1. Scope overridable matchers inside `module <Name>Helper` for proper encapsulation
    1. Use `RSpec.configure #include Helper <metadata>` for selective inclusion
    1. Use `extend RSpec::Matchers::DSL` and `match...do` to define matchers

### Shared Examples

1. Prefer symbols over strings for shared_example names
    1. `:my_example` over `"my example"`
1. Shared examples declared in a "module" or "include file" are ALWAYS global to RSpec
    1. Don't wrap these shared_examples in modules as it's misleading
        1. Place them inline below the `module` definition
    1. Disambiguate global :names by prepending with :type or :subtype
        1. `:request_success`
        2. `:controller_failure`
        3. `:admin_page_available`

The same holds true for these additional RSpec `aliases`:

    alias shared_context      shared_examples
    alias shared_examples_for shared_examples

### Individual Specs

Each `*_spec.rb` should

1. Have a single top level `require` for either `spec_helper` or `rails_helper`
1. Begin with `RSpec.<method>` for forward compatibility

## Helpers

`rails generate rspec:install` creates:

* `spec/spec_helper.rb` is the minimal needed for every spec
* `spec/rails_helper.rb` is the minimal needed for every spec that depends on rails
    * calls `require spec/spec_helper.rb`

### rails_helper

Auto-require all the support files like this to avoid having to do it manually:

    Dir[Rails.root.join("spec/support/**/*.rb")].each {|file| require file }

Extend the built-in spec metadata for custom types:

    %w(observer worker).each do |type|
      config.define_derived_metadata(:file_path => Regexp.new("/spec/#{type.pluralize}/")) do |metadata|
        metadata[:type] = type.to_sym
      end
    end

Introduce `subtype` metadata for namespaces that are nested below traditional types:

    %w(controller feature request).each do |type|
      %w(admin api).each do |sub|
        config.define_derived_metadata(:file_path => Regexp.new("/spec/#{type.pluralize}/#{sub}/")) do |metadata|
          metadata[:subtype] = "#{sub}_#{type}".to_sym
        end
      end
    end

### Vendor Helpers

Include all vendor related configuration in separate folder `spec/support/vendors/<vendor>.rb`.  `capybara.rb` is the canonical example:

    require "capybara/rspec"

    Capybara.default_wait_time = 10

    RSpec.configure do |config|
      config.include Capybara::DSL, type: :feature

      config.after type: :feature do
        page.driver.reset!
        Capybara.reset_sessions!
      end
    end

Vendor helpers should not be wrapped in modules.  To configure a new gem, just add a new `<vendor>.rb` file to this folder and it will be auto-required.

### Project Helpers

The general format for a project helper (one that is unique to your Rails project) is

    module FooHelper
      extend RSpec::Matchers::DSL

      # METHODS
      def foo...end

      # MATCHERS
      matcher do...end

    end

    # CONFIG
    RSpec.config do...end

    # SHARED EXAMPLES
    shared_example :foo do...end

If you are adding methods and overridable matchers, you will need to add this to `rails_helper`:

    RSpec.configure do |config|
      config.include FooHelper
    end

As the number of shared examples increase, you should make them into a separate `foo_examples.rb`  Notice that CONFIG and SHARED_EXAMPLES are not inside the `module`.  This is because the are evaluated at load time and are not scoped in any way by the `module`.

## Methods

    # global scope
    def foo...end

    RSpec.describe "My Spec" do

      # example_group scope
      def foo...end

      context "My Context" do

        # context scope
        def foo...end
      end
    end

In "global" scope, `#foo` is a **private** instance method on `Object`.

* Which is inherited by `RSpec::ExampleGroup < Object`
* This can lead to some unusual results.
    * Forex `"string".send(:foo)` is allowed
    * Avoid this pattern where possible

In "example_group" scope, `#foo` is a **public** instance method on class `RSpec::ExampleGroups::MySpec`

* `public RSpec::ExampleGroups::MySpec#foo` overrides `private Object#foo`
* `#foo` is inherited by every nested `describe` or `context` class

In "context" scope, `#foo` is a **public** instance method that overrides `example_scope` because `RSpec::ExampleGroups::MySpec::MyContext < RSpec::ExampleGroups::MySpec`

## Matchers

    # global scope
    RSpec::Matchers.define :foo do...end
    matcher :bar do...end

    RSpec.describe "Top" do

      # example_group scope
      RSpec::Matchers.define :foo do...end
      matcher :bar do...end

      context "My Context" do

        # context scope
        RSpec::Matchers.define :foo do...end
        matcher :bar do...end
      end
    end

* `RSpec::Matchers.define do...end` globally defines a matcher.
    * Call it again (no matter how it's scoped) and the most recent declaration wins
    * In this example, "context_scope" `:foo` is used
* To get predictable overrides, always use the `match..do` DSL
    * `match..do` declarations are only available in the scope in which they are declared
    * `RSpec::Matchers::DSL` is already mixed in to `example_groups`
    * Manually `extend RSpec::Matchers::DSL` in `modules`

Like this:

    module FooHelper
      extend RSpec::Matchers::DSL
      matcher :foo do
        match do...end
      end
    end

## Shared Examples

    # global scope
    shared_examples_for :foo do...end

    RSpec.describe "My Spec" do

      # example_group scope
      shared_examples_for :foo do...end

      context "My Context" do

        # context scope
        shared_examples_for :foo do...end
      end
    end

At load time, shared examples populate a global RSpec registry which can be examined with:

    RSpec.world.shared_example_group_registry.send(:shared_example_groups)

After declaring "global" `:foo`, the registry looks like this:

    {
      :main=>{
        :foo=>#<RSpec::Core::SharedExampleGroupModule :foo>
      }
    }

After declaring "example_group" `:foo`, the registry looks like this because the classes are cleverly used as the keys:

    {
      :main=>{
        :foo=>#<RSpec::Core::SharedExampleGroupModule :foo>
      },
      RSpec::ExampleGroups::MySpec=>{
        :foo=>#<RSpec::Core::SharedExampleGroupModule :foo>
      }
    }

And so on:

    {
      :main=>{
        :foo=>#<RSpec::Core::SharedExampleGroupModule :foo>
      },
      RSpec::ExampleGroups::MySpec=>{
        :foo=>#<RSpec::Core::SharedExampleGroupModule :foo>
      },
      RSpec::ExampleGroups::MySpec::MyContext=>{
        :foo=>#<RSpec::Core::SharedExampleGroupModule :foo>
      }
    }

They *are overriding* each other based on the way RSpec looks up keys in the global registry.  There is, however, an important consideration:

    # global scope
    shared_examples_for :foo do...end

    module ScopedFoo
      shared_examples_for :foo do...end
    end

    RSpec.describe "My Spec" do
      # example_group scope
      include ScopedFoo
    end

You might think `ScopedFoo shared_examples_for :foo` overrides global `:foo` but it doesn't.  The keys will collide and RSpec generates this warning:

    WARNING: Shared example group 'foo' has been previously defined at:
      /spec-test/includes/foo_spec.rb:13
    ...and you are now defining it at:
      spec-test/includes/foo_spec.rb:24
    The new definition will overwrite the original one.

This is because `shared_examples` in a separate `module` or `include file` (whether wrapped in a `module` or not) calls `Module.shared_examples` which ALWAYS adds a registry entry using the key `:main`:

    module TopLevelDSL
      def self.definitions
        proc do
          def shared_examples(name, *args, &block)
            RSpec.world.shared_example_group_registry.add(:main, name, *args, &block)
          end
        end
      end
    end

It can be deferred until "include" time, but the effect is the same -- they are added to `:main`.

    module SelfIncludedFoo
      def self.included(parent)
        shared_examples_for :foo do...end
      end
    end

Whereas declaring `shared_examples` inside ANY `RSpec::ExampleGroup` class using `describe` or `context` adds a registry key using the parent class `self` as the key:

    module SharedExampleGroup
      def shared_examples(name, *args, &block)
        RSpec.world.shared_example_group_registry.add(self, name, *args, &block)
      end

The bottom line is this: shared_examples declared outside of "example_groups" all exist in the same `:main` namespace and must be unique.
