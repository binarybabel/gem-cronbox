require 'test_helper'

class CronboxTest < Minitest::Test
  def test_version_number
    refute_nil ::Cronbox::VERSION
  end

  def setup
    @file = File.join(File.dirname(__FILE__), 'tmp', 'test.data')
    @app = Cronbox.new(@file)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_two_commands_two_entries
    assert_equal 0, @app.data.entries.size
    @app.execute(nil, 'echo', 'hello')
    @app.execute(nil, 'echo', 'world')
    assert_equal 2, @app.data.entries.size
  end

  def test_same_command_shares_one_entry
    assert_equal 0, @app.data.entries.size
    @app.execute(nil, 'echo', 'hello')
    @app.execute(nil, 'echo', 'hello')
    assert_equal 1, @app.data.entries.size
  end

  def test_labeled_command_shares_one_entry
    assert_equal 0, @app.data.entries.size
    @app.execute('alpha', 'echo', 'hello')
    @app.execute('alpha', 'echo', 'world')
    assert_equal 1, @app.data.entries.size
  end

  def test_labeled_commands_grafting
    assert_equal 0, @app.data.entries.size
    @app.execute(nil, 'echo', 'hello')
    @app.execute('alpha', 'echo', 'hello')
    assert_equal 1, @app.data.entries.size
  end
end
