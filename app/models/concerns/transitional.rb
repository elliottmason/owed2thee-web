module Transitional
  def self.included(base)
    base.class_eval do
      include Statesman::Adapters::ActiveRecordQueries
      extend ClassMethods

      has_many :transitions, as: :transitional
    end
  end

  module ClassMethods
    def transitional(name, options = {})
      transitional_methods = TransitionalMethods.new(name, options)
      include transitional_methods.instance_methods
      extend transitional_methods.class_methods

      has_many :"#{name}_transitions", as: :transitional
    end

    def initial_states
      @initial_states ||= []
    end

    def initial_state?(states)
      return unless initial_states

      (initial_states.map(&:to_s) & states).any?
    end

    def model_type
      transition_reflection.type
    end

    def most_recent_transition_join(type = nil)
      if type
        transition_type = type.to_s.classify + 'Transition'
        super() +
          " AND #{most_recent_transition_alias}.type = '#{transition_type}'"
      else
        super()
      end +
        " AND #{most_recent_transition_alias}.#{model_type} = " \
        "'#{base_class.name}'"
    end

    def states_where(temporary_table_name, states)
      if initial_state?(states)
        "#{temporary_table_name}.to_state IN (?) OR " \
        "#{temporary_table_name}.to_state IS NULL"
      else
        "#{temporary_table_name}.to_state IN (?) AND " \
        "#{temporary_table_name}.to_state IS NOT NULL"
      end
    end

    def transition_class
      Transition
    end
  end

  class TransitionalMethods
    attr_reader :class_methods
    attr_reader :instance_methods

    def initialize(name, options = {})
      @name = name
      @class_methods    = Module.new
      @instance_methods = Module.new
      @state_machine_class_name = options[:state_machine_class_name]

      compile_initial_state
      compile_predicate_methods
      compile_scopes
      compile_state_machine
      compile_transition_methods
    end

    private

    def compile_initial_state
      @class_methods.module_eval <<-EOS, __FILE__, __LINE__ + 1
        def initial_states
          super + [#{state_machine_class}.initial_state]
        end
      EOS
    end

    def compile_predicate_methods
      state_machine_class.states.each do |state|
        @instance_methods.module_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{state}?
            #{@name}.current_state == "#{state}"
          end
        EOS
      end
    end

    def compile_scopes
      @class_methods.module_eval <<-EOS, __FILE__, __LINE__ + 1
        #{in_transition_scope_method}
        #{not_in_transition_scope_method}
      EOS
    end

    def compile_state_machine
      @instance_methods.module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{@name}
          @_#{@name} ||= #{state_machine_class}.new(
            self,
            association_name: :#{transition_association_name},
            transition_class: #{transition_class}
          )
        end
      EOS
    end

    def compile_transition_methods
      state_machine_class::ACTIONS.each do |action, state|
        @instance_methods.module_eval <<-EOS, __FILE__, __LINE__ + 1
          def #{action}!
            #{@name}.transition_to(:#{state})
          end
        EOS
      end
    end

    def in_transition_scope_method
      <<-EOS
      def in_#{@name}_state(*states)
        states = states.flatten.map(&:to_s)

        joins(most_recent_transition_join(:#{@name})).
          where(
            "\#{states_where(most_recent_transition_alias, states)}",
            states
          ).uniq
      end
      EOS
    end

    def not_in_transition_scope_method
      <<-EOS
      def not_in_#{@name}_state(*states)
        states = states.flatten.map(&:to_s)

        joins(most_recent_transition_join(:#{@name})).
          where(
            "NOT (\#{states_where(most_recent_transition_alias, states)})",
            states
          ).uniq
      end
      EOS
    end

    def state_machine_class
      state_machine_class_name.constantize
    end

    def state_machine_class_name
      @state_machine_class_name ||= "#{transitional_class_prefix}StateMachine"
    end

    def transition_association_name
      "#{@name}_transitions"
    end

    def transition_class
      transition_class_name.constantize
    end

    def transition_class_name
      @transition_class_name ||= "#{transitional_class_prefix}Transition"
    end

    def transitional_class_prefix
      @name.to_s.titleize
    end
  end
end
