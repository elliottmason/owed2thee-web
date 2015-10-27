module Users
  class LoansParams < BaseParams
    class Page
      def initialize(value = nil)
        @value = Integer(value || 1)
        @value = 1 if @value < 1
      end

      def inspect
        @value.to_s
      end

      def -(other)
        self.class.new(@value - other)
      end

      def +(other)
        self.class.new(@value + other)
      end

      def to_i
        @value.to_i
      end
    end

    attribute :page, Page, default: 1
  end
end
