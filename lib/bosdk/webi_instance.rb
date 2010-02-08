module BOSDK
  class WebiInstance
    attr_reader :instance

    def initialize(instance)
      @instance = instance
    end

    def objects
      return @objects unless @objects.nil?
      objs = []
      dict = @instance.getDictionary
      (0 ... dict.getChildCount).each do |i|
        obj = dict.getChildAt(i)
        objs << {
          :name => obj.getName,
          :qual => obj.getQualification.getString.downcase.to_sym,
          :type => obj.getType.getString.downcase.to_sym,
          :object => obj,
        }
      end
      @objects = objs
    end

    def variables
      return @variables unless @variables.nil?
      vars = []
      dict = @instance.getDictionary
      dict.getVariables.each do |var|
        vars << {
          :name => var.getName,
          :qual => var.getQualification.getString.downcase.to_sym,
          :type => var.getType.getString.downcase.to_sym,
          :formula => var.getFormula.getValue,
          :variable => var,
        }
      end
      @variables = vars
    end
  end
end
