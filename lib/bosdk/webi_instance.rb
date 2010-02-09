module BOSDK
  # Creates a wrapper around a DocumentInstance
  class WebiInstance
    # The underlying DocumentInstance
    attr_reader :instance

    # Create a new WebiInstance from the provided DocumentInstance
    def initialize(instance)
      @instance = instance
    end

    # Returns an array of hashes representing report objects.
    def objects
      return @objects unless @objects.nil?
      objs = []
      dict = @instance.getDictionary
      (0 ... dict.getChildCount).each do |i|
        obj = dict.getChildAt(i)
        objs << {
          :name => obj.getName,
          :qual => obj.getQualification.toString.downcase.to_sym,
          :type => obj.getType.toString.downcase.to_sym,
          :object => obj,
        }
      end
      @objects = objs
    end

    # Returns an array of hashes representing report variables.
    def variables
      return @variables unless @variables.nil?
      vars = []
      dict = @instance.getDictionary
      dict.getVariables.each do |var|
        vars << {
          :name => var.getName,
          :qual => var.getQualification.toString.downcase.to_sym,
          :type => var.getType.toString.downcase.to_sym,
          :formula => var.getFormula.getValue,
          :variable => var,
        }
      end
      @variables = vars
    end
  end
end
