##########################
# Custom handling or arguments:
# Allows things like User.with_arguments(1, 2, 3).find(:order => 'id DESC')
#    result: => User.find(1, 2, 3, :order => 'id DESC')
# but also checks to see that arguments are valid.
#
# Also, allows us to condense patterns like:  record.perform_action! if record.respond_to?(:perform_action!)
# by doing the following instead              record.maybe.perform_action!
class Object
  def with_arguments(*arguments)
    arg_merger = ArgumentMerger.new(self, arguments)
    block_given? ? yield(arg_merger) : arg_merger
  end
  [ :with_argument, :maybe_with, :maybe ].each { |meth| alias_method meth, :with_arguments; }
  
  def with_nonnil(*arguments);  with_arguments(*arguments.merge_options(:nonnil   => true)); end
  def with_present(*arguments); with_arguments(*arguments.merge_options(:present  => true)); end
end
