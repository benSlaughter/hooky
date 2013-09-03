module Hooky
  module ClassMethods
    def add_hooks *args
      args.each do |name|
        create_hook name
      end
    end
    alias_method :add_hook, :add_hooks

    def hook name
      @hooks[name].each do |block|
        block.call
      end
    end

    private

    def create_hook name
      @hooks[name] = []
      define_singleton_method name do |&block|
        @hooks[name].push block
      end
    end
  end

  module InstanceMethods
    def hook name
      self.class.hook name
    end
  end

  def self.included(receiver)
    receiver.class_eval do
      extend ClassMethods
      include InstanceMethods
      @hooks = {}
    end
  end
end