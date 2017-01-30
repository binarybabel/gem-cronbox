class Cronbox
  class CliWrapper
    def initialize(app)
      @app = app
    end

    def report(type=nil, include_only=nil)
      if include_only
        include_ids = include_only.map(&:to_i)
        include_labels = include_only.map(&:to_s)
      end

      any_output = false

      report = @app.report(type.eql? 'errors')
      report[:entries].each do |e|
        if e['label'].to_s.empty?
          e['f_label'] = e['id'].to_s
        else
          e['f_label'] = %("#{e['label']}" #{e['id']})
        end
        if e['has_output']
          any_output = true
          e['f_status'] = '*' + e['status'].to_s
        else
          e['f_status'] = e['status'].to_s
        end
      end

      fw = self.class.calc_widths_of_fields(report[:entries], {
          f_label: [2], command: [10, 70], f_status: [4], when: [4]
      })
      w = fw.values.reduce(:+) + fw.size*3 + 1

      ## BRAND
      puts ''
      brand = '| Cronbox |'
      if any_output
        puts "%s%#{w-brand.length}s" % [brand, '*=Output']
      else
        puts brand
      end
      puts '=' * w

      ## HEADER ROW
      tpl = [nil,
             "%#{fw[:f_label]}s",
             "%-#{fw[:command]}s",
             "%#{fw[:f_status]}s",
             "%#{fw[:when]}s",
             nil].join(' | ').strip
      puts tpl % %w(ID COMMAND EXIT WHEN)
      puts '=' * w

      ## ENTRY ROWS
      report[:entries].each do |e|
        if include_only
          next unless include_ids.include? e['id'] or include_labels.include? e['label']
        end
        puts tpl % [
            e['f_label'],
            e['command'],
            e['f_status'],
            e['when']
        ]
        if type == 'errors' or type === true
          if e['has_output']
            puts 'v' * w
            puts ''
            puts e['output'].join("\n").sub(/\s*\z/, '')
            puts ''
          end
          puts '-' * w
        else
          puts '-' * w
        end
      end
      puts ''
    end

    def delete(entry)
      if (entry = @app.delete(entry))
        STDERR.write("Deleted entry ##{entry['id']}\n")
      end
    end

    def self.calc_widths_of_fields(table, fields_with_opts)
      result = Hash.new
      fields = fields_with_opts.keys
      table.each do |e|
        fields.each do |f|
          w = e[f.to_s].to_s.length
          result[f] = [result[f].to_i, w].max
        end
      end
      fields_with_opts.each do |f, opts|
        opts = [0, 99] unless opts
        opts.push(99) unless opts.length > 1
        result[f] = [[result[f].to_i, opts[0]].max, opts[1]].min
      end
      result
    end

    def self.calc_width_of_field(table, field, min=0, max=99)
      field = field.to_s
      width = table.inject(0) do |w, e|
        [w, e[field].to_s.length].max
      end
      [[width, min].max, max].min
    end
  end
end
