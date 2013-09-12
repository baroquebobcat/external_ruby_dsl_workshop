module SQLAwesome
  module SemanticModel
    class Statement < Struct.new(:int)
      def eval(database); [{int.to_s => int.to_i}]; end
      def inspect
        "Statement[#{int}]"
      end
    end
  end
end