#!/bin/bash

echo "Prove that namespace helpers work in either direction"

rspec -fd --order defined \
spec/controllers/controller_spec.rb \
spec/controllers/admin/admin_controller_spec.rb \
spec/controllers/developers/developers_controller_spec.rb \

rspec -fd --order defined \
spec/controllers/developers/developers_controller_spec.rb \
spec/controllers/admin/admin_controller_spec.rb \
spec/controllers/controller_spec.rb \
