module Transitional
  def self.included(base)
    base.class_eval do
      include Statesman::Adapters::ActiveRecordQueries
      extend ClassMethods

      has_many :transitions, as: :transitional
    end
  end

  module ClassMethods
    def initial_state
      @initial_state = []
    end

    def initial_state?(states)
      return unless initial_state

      case initial_state
      when Array
        (initial_state.map(&:to_s) & states).any?
      else
        initial_state.in?(states)
      end
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

    def model_type
      transition_reflection.type
    end

    def transition1_join
      "LEFT OUTER JOIN #{model_table} transition1 " \
        "ON transition1.#{model_foreign_key} = #{table_name}.id " \
        "AND transition1.#{model_type} = '#{name}'"
    end

    def transition2_join
      "LEFT OUTER JOIN #{model_table} transition2 " \
        "ON transition2.#{model_foreign_key} = #{table_name}.id " \
        "AND transition1.#{model_type} = '#{name}' " \
        'AND transition2.sort_key > transition1.sort_key'
    end
  end
end
