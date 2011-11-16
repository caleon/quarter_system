class Arguments < Array
  def self.new(args)
    arguer = args.last.is_a?(Class) && args.pop
    super.tap {|args_obj| args_obj.arguer = arguer }
  end
  
  attr_accessor :arguer
  
  # kondition needs to be a string to be evaluated when appended to the element. Refer to Arguments#passes_condition?
  def find_with_reqs(reqs={}) # Arguments itself can be any length. But these three are things allowed to be defined.
    [ total_match_value(reqs[:class], reqs[:condition]), quey_match_value(reqs[:quey]), default_value_for(reqs[:quey]) ].compact.first
  end

  protected
  def default_value_for(quey) # not schrod. arguer can be nil or methodmissing or result in raise.
    arguer.send(:"default_#{quey}") rescue nil
  end
  
  def total_match_value(*args)
    detect { |arg| total_match?(arg, *args) }
  end
  
  def quey_match_value(quey=nil) # hm, allowing nil as quey
    last[quey] if last.is_a?(Hash)
  end
  
  private
  def matches_class?(arg, klass=nil)
    arg.is_a?(klass || Object)
  end
  
  def passes_condition?(arg, konditions=nil)
    instance_eval(%{arg#{konditions}})
  end
  
  def total_match?(arg, *checks) # total_match?(thing, klass, konditions)
    matches_class?(arg, checks[0]) && passes_condition?(arg, checks[1])
  end
end