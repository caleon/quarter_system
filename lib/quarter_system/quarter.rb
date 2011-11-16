class Quarter < Range
  extend Argumentation
  
  DEFAULTS = { :us_fiscal => [ [ 10, 12 ],  # Q1
                               [  1,  3 ],  # Q2
                               [  4,  6 ],  # Q3
                               [  7,  9 ] ] # Q4
              }
              
  
  class << self
    def default_type
      :us_fiscal
    end
    
    def default_year
      Time.zone_default.today.year rescue Time.new.year
    end # depends on time zone.
    
    def default_number
      1
    end
    
    # Changing this so that table type can be input as an option. This is so that when changing quarter system, the dev can use
    # the with_options to change the type easily for all relevant calls.
    # Ex: Quarter.quarters_table(:uk_fiscal)
    #     Quarter.quarters_table(:type => :uk_fiscal)
    def quarters_table(*args)
      DEFAULTS[type_from_args(args)]
    end
    
    def number_of_quarters(*args);
      quarters_table(*args).size
    end
    
    # Sequential returns the Quarter for the correct year depending on the magnitude of the `number` argument.
    def specific(*args)
      number, year, type  = number_and_year_and_type_from_args(*args)
      index               = number.pred % number_of_quarters(*args)
      opts                = args.extract_options! # at this point, args not needed in its original form.
      
      months_array            = quarters_table(type)[index]
      first_months_array      = quarters_table(type)[0]
      specified_quarter_month =       months_array[0]
      first_quarter_month     = first_months_array[0]
      
      year += opts[:this_year] ?  0 : (number.pred / number_of_quarters) + (first_quarter_month > specified_quarter_month ? 1 : 0)
      
      new(Date.new(year, months_array[0], 1), Date.new(year, months_array[1], 1).end_of_month, :number => number)
    end
    
    def all(*args)
      type, year = type_and_year_from_args(*args)
      1.upto(number_of_quarters(type)).map { |number| specific(*args.merge_options(:number => number)) }
    end
    
    def general(*args)
      specific(*args.merge_options(:this_year => true))
    end
    
    def current(*args)
      all(*args.merge_options(:this_year => true)).detect { |rng| rng.include? ::Time.zone_default.today }
    end
    
    def current_number(*args)
      current(*args).number
    end
    
    # ARGUMENTS MUST NOT BE SPLATTED INTO THIS. Point is for this method to not be destructive.
    # Also, whatever `type` is defined within normal list of arguments overrides any written as a hash value.
    # Thing about this whole file is that `type` is the only argument ever that's a symbol,
    #                                     `year` is the only argument that's ever a Numeric of length == 4,
    #                                   `number` is the only argument that's ever a Numeric of length < 4.
    def type_from_args(*args)
      find_from_args(args, :quey => :type, :class => Symbol)
    end
    
    def year_from_args(*args)
      find_from_args(args, :quey => :year, :class => Numeric, :condition => ".to_s.size == 4")
    end
    
    def number_from_args(*args)
      find_from_args(args, :quey => :number, :class => Numeric, :condition => ".to_s.size < 3")
    end
    
    def method_missing(method_symbol, *arguments, &block)
      ordinals = Integer::ORDINALS
      method_symbol.to_s.match(/^(#{ordinals.join('|')})$/).only_if_a?(MatchData) { |md| specific(ordinals.index(md[1]), *arguments) } || super
    end
    private :method_missing
  end
  
  attr_accessor :count, :number, :type
  
  def initialize(*args)
    attrs       = args.extract_options!
    self.type   = attrs.delete(:type)
    self.count  = attrs.delete(:number)
    self.number = (self.count.pred % Quarter.number_of_quarters(:type => self.type)).next
    super
  end
  
  def include?(date_or_time)
    if date_or_time.is_a?(Time)
      super(date_or_time.in_time_zone(Time.zone_default).to_date)
    else
      super
    end
  end
  
  # Instance method from a Quarter object, such that quarter.next returns the following Quarter object. Doesn't mean next one in relation to the current.
  # for that you would need to use Quarter.current.next or Quarter.next on the class itself.
  %w(next prev).each_with_index do |method_name, i|
    class_eval(%{
      def #{method_name}(size=1)
        Quarter.specific(number.send(:#{%w(+ -)[i]}, size))
      end
    })
  end
end
