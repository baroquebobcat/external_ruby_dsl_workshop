module Parslet::Atoms::DSL
  def raw_as(name)
    Parslet::Atoms::RawAttribute.new self, name
  end
end

class Parslet::Atoms::RawAttribute < Parslet::Atoms::Base
  attr_reader :parslet, :name
  def initialize(parslet, name)
    super()

    @parslet, @name = parslet, name
  end
  
  def apply(source, context, consume_all)
    start = source.pos
    success, inner_value = result = parslet.apply(source, context, consume_all)
    
    return result unless success
  
    succ([:sequence, inner_value, {name => grab_raw_text(source, start)}])
  end
  
  def grab_raw_text source, start
    finish = source.pos
    source.pos = start
    source.consume finish - start
  ensure
    source.pos = finish
  end

  def to_s_inner(prec)
    "#{name}:#{parslet.to_s(prec)}"
  end
end