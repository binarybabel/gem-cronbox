require 'test_helper'

class CronboxDataFileTest < Minitest::Test

  def setup
    @file = File.join(File.dirname(__FILE__), 'tmp', 'test.data')
    @data = Cronbox::DataFile.new(@file)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_file_storage
    @data.empty!
    assert File.exist?(@file)
  end

  def test_storage_recall
    @data.config['hello'] = 'world'
    @data.save!
    @data = Cronbox::DataFile.new(@file)
    assert_equal 'world', @data.config['hello']
  end

  def test_storage_delete
    e = {'hello' => 'world'}
    @data.add_entry(e)
    assert_equal 1, @data.entries.size
    @data.del_entry(e)
    assert_equal 0, @data.entries.size
  end

end
