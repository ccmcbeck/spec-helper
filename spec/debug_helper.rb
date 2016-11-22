module DebugHelper

  def included(parent)
    debug_included(parent)
  end

  def debug_message(msg)
    puts msg if DEBUG
  end

  def debug_loaded
    debug_message "#{self} loaded"
  end

  def debug_included(parent)
    debug_message "#{self} included in #{parent} #{parent.class}"
  end

  def debug_registry(msg)
    debug_message "REGISTRY: #{msg}: #{RSpec.world.shared_example_group_registry.send :shared_example_groups}"
  end

end
