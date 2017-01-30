require 'test_helper'

class CronboxCliWrapperTest < Minitest::Test
  def setup
    @file = File.join(File.dirname(__FILE__), 'tmp', 'test.data')
    @app = Cronbox.new(@file)
    @klass = ::Cronbox::CliWrapper
    @cli = @klass.new(@app)
  end

  def teardown
    File.delete(@file) if File.exist?(@file)
  end

  def test_calc_widths_of_fields
    t = [
        {'a' => '123', 'b' => '12345'},
        {'a' => '123456789', 'b' => '123456'},
        {'a' => '12345'},
    ]
    assert_equal(
        {a: 9, b: 6},
        @klass.calc_widths_of_fields(t, {a: nil, b:nil})
    )
    assert_equal(
        {a: 9},
        @klass.calc_widths_of_fields(t, {a: nil})
    )
    assert_equal(
        {a: 5},
        @klass.calc_widths_of_fields(t, {a: [0,5]})
    )
    assert_equal(
        {a: 9},
        @klass.calc_widths_of_fields(t, {a: [0,15]})
    )
    assert_equal(
        {a: 15},
        @klass.calc_widths_of_fields(t, {a: [15]})
    )
  end

  def test_calc_width_of_field
    t = [
        {'a' => '123'},
        {'a' => '123456789'},
        {'a' => '12345'},
    ]
    assert_equal 9, @klass.calc_width_of_field(t, :a)
    assert_equal 9, @klass.calc_width_of_field(t, :a, 0, 15)
    assert_equal 5, @klass.calc_width_of_field(t, :a, 0, 5)
    assert_equal 10, @klass.calc_width_of_field(t, :a, 10)
  end
end
