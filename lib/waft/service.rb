require 'waft/repository'
require 'waft/entity'

module Waft
  class Service
    def initialize(password, filename)
      @repo = Waft::Repository.new(password, filename)
    end

    def list
      @repo.list.map { |hash| Waft::Entity.new(hash) }
    end

    def get(index)
      hash = @repo.get(index)
      Waft::Entity.new(hash)
    end

    def set(index, entity)
      @repo.set(index, entity.to_h)
    end

    def add(entity)
      @repo.add(entity.to_h)
    end

    def delete(index)
      Waft::Entity.new(@repo.delete(index))
    end

    def clear
      @repo.clear
    end
  end
end
