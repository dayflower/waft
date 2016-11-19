require 'waft/repository'
require 'waft/entity'

module Waft
  class Service
    def initialize(password, filename)
      @repo = Waft::Repository.new(Waft::Entity, password, filename)
    end

    def list
      @repo.list
    end

    def get(index)
      @repo.get(index)
    end

    def set(index, entity)
      @repo.set(index, entity)
    end

    def add(entity)
      @repo.add(entity)
    end

    def delete(index)
      @repo.delete(index)
    end

    def clear
      @repo.clear
    end
  end
end
