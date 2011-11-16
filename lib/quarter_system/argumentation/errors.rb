#########
# Error classes.
class ArgumentMergerLogger < ActiveSupport::BufferedLogger
  SEVERITIES = Severity.constants.inject([]) { |arr, c| arr[Severity.const_get(c)] = c; arr }
  
  def format_message(severity, timestamp, progname, msg)
    "(#{timestamp.to_s(:db)})[#{SEVERITIES[severity]}]: #{msg.strip}\n"
  end
  
  def add(severity, message=nil, progname=nil, &block)
    return if @level > severity
    message = (message || block.try(:call) || progname).to_s
    message = format_message(severity, Time.zone.now, progname, message)
    buffer << message
    auto_flush
    message
  end
end

# ArgumentMerger.send(:include, SetupLoggers)
# ArgumentMerger.logger = ArgumentMergerLogger.new(File.join(Rails.root, 'log', "argument_merger_#{Rails.env}.log"))

class ArchetypeError < StandardError
   def initialize(msg=nil, opts={})
     ArgumentMerger.logger.send(opts[:severity] || :warn, "#{name}: #{msg}")
   end
   
   def name
     this.class.name
    end
end
class ArchetypeMethodsError < ArchetypeError; end
class ArchetypeArgumentsError < ArchetypeError; end
