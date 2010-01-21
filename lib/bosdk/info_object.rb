module BOSDK
  # Creates a wrapper around an IInfoObject.
  class InfoObject
    # The underlying IInfoObject.
    attr_reader :obj

    # Creates a new InfoObject from the provided IInfoObject.
    #  InfoObject.new(obj)
    def initialize(obj)
      @obj = obj
    end

    # Returns true/false if #obj is a root node.
    def is_root?
      parent_id.nil? or parent_id == 0 or parent_id == getID
    end

    # Returns the parent of #obj as an InfoObject
    def parent
      return nil if is_root?
      @parent ||= InfoObject.new(getParent)
    end

    # Returns the path of #obj as a String.
    def path
      @path ||= (is_root? ? '' : parent.path) + "/#{title}"
    end

    # Compares one InfoObject to another by #title.
    def <=>(other_infoobject)
      title <=> other_infoobject.title
    end

    # Forwards method to underlying IInfoObject and stores the results
    def method_missing(method, *args)
      eval "return @#{method.to_s}" if instance_variables.include?("@#{method.to_s}")
      if @obj.respond_to?(method)
        eval "return @#{method.to_s} = @obj.send(method, *args)"
      end
      super
    end

    # Returns true if underlying IInfoObject#respond_to? is true
    def respond_to?(method)
      @obj.respond_to?(method) || super
    end
  end
end
