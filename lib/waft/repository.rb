require 'waft/util'
require 'json'

module Waft
  class Repository
    def initialize(entity_class, password, filename)
      @entity_class = entity_class
      @password = password
      @filename = filename
    end

    def list
      ensure_load
    end

    def get(index)
      ensure_load
      @dict[index]
    end

    def set(index, hash)
      ensure_load
      @dict[index] = hash
      save_dict
      hash
    end

    def add(hash)
      ensure_load
      @dict << hash
      save_dict
      hash
    end

    def delete(index)
      ensure_load
      hash = @dict.delete_at(index)
      save_dict
      hash
    end

    def clear
      @dict = []
      save_dict
      @dict
    end

    private

    def ensure_load
      @dict ||= loadfile()
    end

    def save_dict
      @dict ||= []
      @dict.sort!
      savefile(@dict)
    end

    def loadfile
      begin
        raw = File.open(@filename) do |file|
          file.read
        end
      rescue Errno::ENOENT
        return []
      end

      JSON.parse(Waft::Util.decrypt(@password, raw), symbolize_names: true).map { |entry| @entity_class.new(entry) }
    end

    def savefile(entries)
      File.open(@filename, 'w') do |file|
        file.write Waft::Util.encrypt(@password, JSON.generate(entries.map { |entry| entry.to_h }))
      end
    end
  end
end
