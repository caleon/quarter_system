class ArgumentMerger
  instance_methods.each do |method|
    undef_method(method) if method !~ /^(__|instance_eval|class|object_id|respond_to?|puts|logger|extend|kind_of?)/
  end
  
  attr_accessor :archetype
  def initialize(archetype, arguments, opts={})
    @archetype  = archetype
    @arguments  = arguments.compact
    @opts       = opts.tap { |o| o[:else] ||= nil }
    self
  end
  
  ######
  ## Shit, all Private
  ######
  private unless Rails.env.development?
  def archetype_respond_to_proc
    proc { |method_sym| @archetype.__send__(:respond_to?, method_sym) }
  end
  
  def archetype_send_proc
    proc { |method_sym, *args, &b| @archetype.__send__(method_sym, *constrained_args_for(method_sym, args)) }
  end
  
  def archetype_respond_to?(method_sym)
    archetype_respond_to_proc.call(method_sym)
  rescue NameError => e
    throw(:argument_error, raise(ArchetypeMethodsError, "For #{@archetype}, calling #archetype_respond_to? using method_sym=#{method_sym} led to argument_error"))
  end
  
  def archetype_send(method_sym, *args, &b)
    archetype_send_proc.call(method_sym, *args, &b)
  rescue NameError => e
    throw(:argument_error, raise(ArchetypeMethodsError, "For #{@archetype}, calling #archetype_send using method_sym=#{method_sym} and args=#{args} with &b=#{b} led to argument_error"))
  end
  
  #####
  # @_archetype.method Info grabbing.
  def archetype_method(method_sym)
    @archetype.method(method_sym)
  end
  
  def archetype_method_params(method_sym)
    archetype_method(method_sym).parameters
  end
  
  def archetype_method_params_size(method_sym)
    archetype_method_params(method_sym).size
  end
  
  def archetype_method_arity(method_sym)
    archetype_method(method_sym).arity
  end
  
  #####
  # Minimum number of args
  def minimum_args_from_params(method_sym)
    archetype_method_params(method_sym).count { |type, meth| type == :req }
  end
  
  def minimum_args_from_arity(method_sym)
    archetype_method_arity(method_sym).if?(:negative?).succ.abs # upto succ only happens to negatives.
  end
  
  def minimum_args(method_sym)
    Array.new(2, "minimum_args_from_").zip(%w(params arity)).map { |strs| self.__send__(strs.join, method_sym) }.max
  end
  
  ####
  # Maximum number of args
  def maximums_for_param_types
    { :req => 1, :opt => 1, :block => 1, :rest => 1.0/0 }
  end
  
  def maximum_args_from_params(method_sym)
    return 1.0/0 if archetype_method_params(method_sym).detect { |type, meth| type == :rest }
    archetype_method_params(method_sym).inject(0) { |sum, (type, meth)| sum += maximums_for_param_types[type] }
  end
  
  def maximum_args_from_arity(method_sym)
    archetype_method_arity(method_sym).abs
  end
  
  def maximum_args(method_sym)
    Array.new(2, "maximum_args_from_").zip(%w(params arity)).map { |strs| self.__send__(strs.join, method_sym) }.max # from .min...
  end
  
  ####
  # All those for these
  def constrained_args_for(method_sym, args)
    args.take(maximum_args(method_sym).unless?(:finite?) { args.size })
  end
  
  def provided_minimum_arguments?(method_sym, arguments)
    minimum_args(method_sym) >  maximum_args(method_sym)  and raise ArchetypeError, "Range of argument arity is invalid!"
    minimum_args(method_sym) <= arguments.size
  end
  
  def method_missing(method_sym, *arguments, &block)
    return @opts[:else] if check_conditions?
    arguments = Array.wrap(arguments.last.is_a?(Proc) ? lambda { |*args| @arguments | arguments.pop.call(*args) } : @arguments) + arguments.compact
    
    catch(:argument_error) do
      archetype_respond_to?(method_sym)                   or raise ArchetypeMethodsError,   "Issue with #{method_sym}"
      provided_minimum_arguments?(method_sym, arguments)  or raise ArchetypeArgumentsError, "Issue with #{method_sym}"
      archetype_send(method_sym, *arguments, &block)
    end
  rescue ArchetypeError => e
    logger.error "<errorClass>#{e.class}: <method>#{method_sym}: <msg>#{e.message}" if Rails.env.development?
    super
  rescue
    logger.error "Giving up rescuing #{@archetype.name rescue nil}##{method_sym}. Arguments are #{arguments.inspect}" if Rails.env.development?
    @opts[:else]
  end
  
  def check_conditions?
    @opts[:nonnil] && arguments.empty? or @opts[:present] && arguments.any?(:present?)
  end
end