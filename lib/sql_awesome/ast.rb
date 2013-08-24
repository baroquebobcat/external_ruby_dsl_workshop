module SQLAwesome
  module AST
    class IntLiteral < Struct.new(:int)
      def eval; int.to_i; end
    end
    
    class Wildcard < Struct.new(:int)
      def eval table
        table.map { |row| row }
      end
    end

    class SelectArgs < Struct.new(:args)
      def eval table
        table.map do |row|
          Hash[
            args.map { |arg| [arg.name, arg.eval(row)] }
          ]
        end
      end
    end

    class IntArgument < Struct.new(:int)
      def name
        int.eval.to_s # :/
      end
      def eval row
        int.eval
      end
    end

    class ColumnArgument < Struct.new(:column_name)
      def name
        column_name.to_s
      end
      def eval row
        row[name]
      end
    end

    class FromSelect < Struct.new(:args, :table_name)
      def eval database
        table = database[table_name.to_sym]
        args.eval table
      end
    end

    class Select < Struct.new(:args)
      def eval table
        args.eval [{}]
      end
    end
  end
end