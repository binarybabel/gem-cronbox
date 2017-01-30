require 'open3'
require 'cronbox/version'
require 'cronbox/data_file'
require 'cronbox/cli_wrapper'

class Cronbox

  def initialize(file=nil)
    file ||= File.join(Dir.home, '.cronbox')
    @data = Cronbox::DataFile.new(file)
  end

  attr_reader :data

  def report(errors_only=false)
    entries = @data.entries.sort_by { |e| e['ts'] }
    report = {
        count: 0,
        errors: 0,
        entries: [],
    }
    entries.reverse.each do |e|
      e = e.clone
      e['is_error'] = e['status'].to_i > 0
      e['when'] = self.class.time_delta_string(e['ts'])
      e['has_output'] = (e['output'].respond_to?(:size) && e['output'].size > 0)
      next if errors_only and not e['is_error']
      report[:count] += 1
      report[:errors] += 1 if e['is_error']
      report[:entries].push e
    end
    report
  end

  def execute(label, cmd, *args)
    e = Hash.new
    e['command'] = ([cmd] + args).join(' ')
    e['status'] = nil
    e['output'] = []
    e['label'] = label.to_s unless label.to_s.empty?
    begin
      e['ts'] = Time.now.to_i
      Open3.popen3(cmd, *args) do |stdin, stdout, stderr, thread|
        e['status'] = thread.value.to_i
        e['output'] = stderr.readlines + stdout.readlines
      end
    rescue => ex
      e['status'] = 1
      e['output'] = [ex.message]
    end

    existing = @data.find_entry(label: e['label']) if e['label']
    existing ||= @data.find_entry(command: e['command'])

    if existing
      e['label'] ||= existing['label']
      existing.merge!(e)
    else
      @data.add_entry(e)
    end

    @data.save!
  end

  def delete(id_or_label)
    if id_or_label.to_i > 0
      e = @data.find_entry(id: id_or_label.to_i)
    else
      e = @data.find_entry(label: id_or_label)
    end
    if e
      @data.del_entry(e)
      @data.save!
      e
    else
      nil
    end
  end

  def self.time_delta_string(time)
    d = Time.now.to_i - time.to_i
    case d
      when 0 then 'just now'
      when 1 then 'a second ago'
      when 2..59 then d.to_s+' seconds ago'
      when 60..119 then 'a minute ago' #120 = 2 minutes
      when 120..3540 then (d/60).to_i.to_s+' minutes ago'
      when 3541..7100 then 'an hour ago' # 3600 = 1 hour
      when 7101..82800 then ((d+99)/3600).to_i.to_s+' hours ago'
      when 82801..172000 then 'a day ago' # 86400 = 1 day
      when 172001..518400 then ((d+800)/(60*60*24)).to_i.to_s+' days ago'
      when 518400..1036800 then 'a week ago'
      else ((d+180000)/(60*60*24*7)).to_i.to_s+' weeks ago'
    end
  end
end
