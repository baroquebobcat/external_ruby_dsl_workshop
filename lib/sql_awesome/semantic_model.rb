module SQLAwesome
  # The Semantic Model contains the object representation of 
  # the SQL queries we're building.
  module SemanticModel
    class SelectQuery < Struct.new(:args, :from_table)
      def eval database
        database[from_table].map{|row| args.filter(row) }
      end

      def inspect
        "Query: #{args.inspect} FromTable:#{from_table}"
      end
    end
    class WildCard
      def filter row
        row
      end

      def inspect
        "Fields:all"
      end
    end
    
    class Field < Struct.new(:name)
      def filter row
        {name => row[name]}
      end
      
      def inspect
        "Fields:[#{name}]"
      end
    end
  end
end