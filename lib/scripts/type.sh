#!/bin/bash
echo "Proves that type helpers work in either direction"

rspec -fd --order defined \
spec/controllers/admin/admin_controller_spec.rb \
spec/models/model_spec.rb \

rspec -fd --order defined \
spec/models/model_spec.rb \
spec/controllers/admin/admin_controller_spec.rb \
