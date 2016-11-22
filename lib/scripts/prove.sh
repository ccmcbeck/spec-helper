#!/bin/bash
# must run in isolation of each other
echo "Prove how rspec really works"

rspec -fd --order defined spec_prove/matcher_defined_override_spec.rb
rspec -fd --order defined spec_prove/matcher_dsl_override_spec.rb

rspec -fd --order defined spec_prove/method_global_spec.rb
rspec -fd --order defined spec_prove/method_include_spec.rb
rspec -fd --order defined spec_prove/method_override_spec.rb

rspec -fd --order defined spec_prove/shared_example_spec.rb
