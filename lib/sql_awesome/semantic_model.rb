module SQLAwesome
  module SemanticModel
    class Statement < Struct.new(:args)
      def eval(database)
        [
          Hash[args.map{|a|[a.name, a.value]}]
        ]
      end
      def inspect
        "Statement[#{args.map(&:inspect).join(", ")}]"
      end
    end
    class Integer < Struct.new(:int)
      def name
        int.to_s
      end
      def value
        int.to_i
      end
      def inspect
        name
      end
    end
  end
end