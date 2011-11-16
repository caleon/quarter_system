require 'quarter_system/argumentation/constants'

module Argumentation
  def build_arguments(*args)
    args = args.first if args.size == 1 and args.first.is_a?(Array)
    Arguments.new(args + [self])
  end
  
  private
  def find_from_args(arguments, reqs={})
    build_arguments(*arguments).find_with_reqs(reqs)
  end
  
  def method_missing(method_symbol, *arguments, &block)    
    method_symbol.to_s.match(methods_match_regexp).only_if_a?(MatchData) do |md|
      md[1].split('_and_').push(md[2]).map { |prop_name| :"#{prop_name}_from_args" }.map { |method_sym| send(method_sym, *arguments) if respond_to?(method_sym) }
    end || super
  end

  def methods_match_regexp
    /^((?:#{REGEX[:method_name_without_capture].source}(?:_and_)(?!from_args))+)#{REGEX[:method_name].source}_from_args$/
  end
end

require 'quarter_system/argumentation/arguments'
require 'quarter_system/argumentation/object'
require 'quarter_system/argumentation/argument_merger'
require 'quarter_system/argumentation/errors'
