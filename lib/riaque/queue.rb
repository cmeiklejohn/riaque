module Riaque
  class Queue
    include Riik::Document

    property :name

    def self.name_for(klass)
      klass.instance_variable_get("@queue") || :default
    end
  end
end
