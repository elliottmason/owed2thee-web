module Transitional
  def self.included(base)
    base.include Statesman::Adapters::ActiveRecordQueries
    base.class_eval do
      extend ClassMethods

      has_many :transitions, as: :transitional, autosave: false

      delegate :can_transition_to?, to: :state_machine
      delegate :current_state,      to: :state_machine
      delegate :transition_to,      to: :state_machine
    end
  end

  def state_machine
    @state_machine ||= self.class.state_machine_class.new(
      self,
      transition_class: self.class.transition_class
    )
  end

  module ClassMethods
    def model_foreign_type
      transition_reflection.type
    end

    def most_recent_transition_join
      <<-EOS
        LEFT OUTER JOIN #{model_table} AS #{most_recent_transition_alias} ON
        #{table_name}.id =
          #{most_recent_transition_alias}.#{model_foreign_key} AND
        #{most_recent_transition_alias}.#{model_foreign_type} =
          '#{base_class}' AND
        #{most_recent_transition_alias}.most_recent = #{db_true}
      EOS
    end

    def state_machine(state_machine_class_name)
      transitional_methods = TransitionalMethods.new(state_machine_class_name)
      include transitional_methods.instance_methods
      extend transitional_methods.class_methods
    end

    def transition_class
      Transition
    end
  end

  class TransitionalMethods
    attr_reader :class_methods
    attr_reader :instance_methods

    def initialize(state_machine_class_name)
      @class_methods    = Module.new
      @instance_methods = Module.new
      @state_machine_class_name = state_machine_class_name

      compile_class_methods
      compile_predicate_methods
      compile_transition_methods
    end

    def compile_class_methods
      @class_methods.module_eval <<-EOS, __FILE__, __LINE__ + 1
        def initial_state
          state_machine_class.initial_state.to_sym
        end

        def state_machine_class
          @state_machine_class ||= #{@state_machine_class_name}
        end
      EOS
    end

    def compile_predicate_methods
      state_machine_class.states.each do |state|
        @instance_methods.module_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{state}?
            state_machine.current_state == "#{state}"
          end
        EOS
      end
    end

    def compile_transition_methods
      state_machine_class::ACTIONS.each do |action, state|
        @instance_methods.module_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{action}!
            state_machine.transition_to(:#{state})
          end
        EOS
      end
    end

    def state_machine_class
      return @state_machine_class if @state_machine_class.is_a?(Class)

      @state_machine_class = @state_machine_class_name.to_s.constantize
    end
  end
end
