module ActiveModel
  module MassAssignmentSecurity
    module Sanitizer
    protected
      def warn!(attrs)
        self.logger.debug "WARNING: Can't mass-assign protected attributes: #{attrs.join(', ')}" if self.logger
        raise(RuntimeError, "WARNING: Can't mass-assign protected attributes: #{attrs.join(', ')}") if ['test', 'development'].include?(Rails.env)
      end
    end
  end
end