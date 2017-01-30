require 'json'

class Cronbox
  class DataFile
    def initialize(file)
      @file = file
      reset
      reload if File.exist?(@file)
    end

    def reset
      @config ||= Hash.new
      @entries = Array.new
    end

    def reload
      import_text(File.read(@file))
    end

    def save!
      save_dir = File.dirname(@file)
      unless Dir.exist?(save_dir)
        raise "Directory does not exist, #{save_dir}"
      end
      File.open(@file, 'w') { |file| file.write(export_text) }
    end

    def empty!
      reset
      save!
    end

    attr_accessor :config, :entries

    def find_entry(query)
      k = query.keys.first
      v = query[k]
      return nil unless v
      @entries.each do |e|
        if e[k.to_s] == v
          return e
        end
      end
      nil
    end

    def add_entry(entry)
      entry['id'] = next_id
      @entries.push entry
    end

    def del_entry(entry)
      @entries.delete(entry)
    end

    protected

    def import_text(input)
      data = JSON.parse(input)
      @config = data['config'] || Hash.new
      @entries = data['entries'] || Array.new
    end

    def export_text
      JSON.pretty_generate({
          :'config' => @config,
          :'entries' => @entries.sort_by { |e| e['id'] }
      })
    end

    def next_id
      ni = 1
      indexes = @entries.map { |e| e['id'].to_i }
      indexes.sort.each do |i|
        if i > ni
          return ni
        elsif i == ni
          ni += 1
        end
      end
      ni
    end
  end
end
