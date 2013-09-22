module SQLAwesome
  # The Semantic Model contains the object representation of 
  # the SQL queries we're building.
  module SemanticModel
    class SelectQuery < Struct.new(:args, :from_table)
      def eval database
        database[from_table]
      end

      def inspect
        "Query: #{args.inspect} FromTable:#{from_table}"
      end
    end
    class WildCard
      def inspect
        "Fields:all"
      end
    end
  end
end