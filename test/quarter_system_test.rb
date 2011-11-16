require 'test_helper'

class QuarterSystemTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, QuarterSystem
  end
  
  test "quarters table" do
    assert_equal Array, Quarter.quarters_table.class
  end
  
  test "default quarter" do
    assert_equal :us_fiscal, Quarter.default_type
    assert_equal Array, Quarter.quarters_table(Quarter.default_type).class
    assert_equal [ [10,12], [1,3], [4,6], [7,9] ], Quarter.quarters_table
  end
  
  test "quarters_table test with type_from_args" do
    expected_table = Quarter.quarters_table
    assert_equal expected_table, Quarter.quarters_table(:us_fiscal)
    assert_equal expected_table, Quarter.quarters_table([:us_fiscal])
    assert_equal expected_table, Quarter.quarters_table([[:us_fiscal]])
    assert_equal expected_table, Quarter.quarters_table(:type => :us_fiscal)
    assert_equal expected_table, Quarter.quarters_table(:us_fiscal, :type => :us_fiscal)
    assert_equal expected_table, Quarter.quarters_table(:us_fiscal, :type => :something_weird)
    #assert_not_equal expected_table, Quarter.quarters_table([:us_fiscal], :type => :something_weird)
  end

  test "number of quarters in default" do
    expected_size = 4
    assert_equal expected_size, Quarter.quarters_table.size
    assert_equal expected_size, Quarter.number_of_quarters
  end
  
  test 'specific quarter 1' do
    assert_equal Quarter, Quarter.specific(1).class
    this_year = Time.zone_default.today.year
    assert_equal this_year, Quarter.specific(1).begin.year
    assert_equal this_year, Quarter.specific(1).end.year
  end
  
  test 'specific quarter 1 with default calendar' do
    quarter = Quarter.specific(1)
    quarter_begin, quarter_end = quarter.begin, quarter.end
    assert_equal 10, quarter_begin.month
    assert_equal 1,  quarter_begin.day
    assert_equal 12, quarter_end.month
    assert_equal 1,  quarter_end.next.day
    assert quarter_begin == quarter_begin.beginning_of_month
    assert quarter_end   == quarter_end.end_of_month
    expected_year = Time.zone_default.today.year
    assert_equal expected_year, quarter_begin.year
    assert_equal expected_year, quarter_end.year
  end
  
  test 'specific quarter 2 with default calendar' do
    quarter = Quarter.specific(2)
    quarter_begin, quarter_end = quarter.begin, quarter.end
    assert_equal 1,  quarter_begin.month
    assert_equal 1,  quarter_begin.day
    assert_equal 3,  quarter_end.month
    assert_equal 1,  quarter_end.next.day
    assert quarter_begin == quarter_begin.beginning_of_month
    assert quarter_end   == quarter_end.end_of_month
    expected_year = Time.zone_default.today.year + 1
    assert_equal expected_year, quarter_begin.year
    assert_equal expected_year, quarter_end.year
  end
  
  test 'specific quarter 3 with default calendar' do
    quarter = Quarter.specific(3)
    quarter_begin, quarter_end = quarter.begin, quarter.end
    assert_equal 4,  quarter_begin.month
    assert_equal 1,  quarter_begin.day
    assert_equal 6,  quarter_end.month
    assert_equal 1,  quarter_end.next.day
    assert quarter_begin == quarter_begin.beginning_of_month
    assert quarter_end   == quarter_end.end_of_month
    expected_year = Time.zone_default.today.year + 1
    assert_equal expected_year, quarter_begin.year
    assert_equal expected_year, quarter_end.year
  end
  
  test 'specific quarter 4 with default calendar' do
    quarter = Quarter.specific(4)
    quarter_begin, quarter_end = quarter.begin, quarter.end
    assert_equal 7,  quarter_begin.month
    assert_equal 1,  quarter_begin.day
    assert_equal 9,  quarter_end.month
    assert_equal 1,  quarter_end.next.day
    assert quarter_begin == quarter_begin.beginning_of_month
    assert quarter_end   == quarter_end.end_of_month
    expected_year = Time.zone_default.today.year + 1
    assert_equal expected_year, quarter_begin.year
    assert_equal expected_year, quarter_end.year
  end
  
  test 'specific quarter 5 with default calendar' do
    quarter = Quarter.specific(5)
    quarter_begin, quarter_end = quarter.begin, quarter.end
    assert_equal 10, quarter_begin.month
    assert_equal 1,  quarter_begin.day
    assert_equal 12, quarter_end.month
    assert_equal 1,  quarter_end.next.day
    assert quarter_begin == quarter_begin.beginning_of_month
    assert quarter_end   == quarter_end.end_of_month
    expected_year = Time.zone_default.today.year + 1
    assert_equal expected_year, quarter_begin.year
    assert_equal expected_year, quarter_end.year
  end
  
  test 'specific quarter 6 with default calendar' do
    quarter = Quarter.specific(6)
    quarter_begin, quarter_end = quarter.begin, quarter.end
    assert_equal 1,  quarter_begin.month
    assert_equal 1,  quarter_begin.day
    assert_equal 3,  quarter_end.month
    assert_equal 1,  quarter_end.next.day
    assert quarter_begin == quarter_begin.beginning_of_month
    assert quarter_end   == quarter_end.end_of_month
    expected_year = Time.zone_default.today.year + 2
    assert_equal expected_year, quarter_begin.year
    assert_equal expected_year, quarter_end.year
  end
  
  test 'specific quarter 7 with default calendar' do
    quarter = Quarter.specific(7)
    quarter_begin, quarter_end = quarter.begin, quarter.end
    assert_equal 4,  quarter_begin.month
    assert_equal 1,  quarter_begin.day
    assert_equal 6,  quarter_end.month
    assert_equal 1,  quarter_end.next.day
    assert quarter_begin == quarter_begin.beginning_of_month
    assert quarter_end   == quarter_end.end_of_month
    expected_year = Time.zone_default.today.year + 2
    assert_equal expected_year, quarter_begin.year
    assert_equal expected_year, quarter_end.year
  end
  
  test 'specific quarter 8 with default calendar' do
    quarter = Quarter.specific(8)
    quarter_begin, quarter_end = quarter.begin, quarter.end
    assert_equal 7,  quarter_begin.month
    assert_equal 1,  quarter_begin.day
    assert_equal 9,  quarter_end.month
    assert_equal 1,  quarter_end.next.day
    assert quarter_begin == quarter_begin.beginning_of_month
    assert quarter_end   == quarter_end.end_of_month
    expected_year = Time.zone_default.today.year + 2
    assert_equal expected_year, quarter_begin.year
    assert_equal expected_year, quarter_end.year
  end
  
  test 'all for no specified year, default calendar' do
    this_year = Time.zone_default.today.year
    quarters = Quarter.all
    
    assert_equal this_year, quarters[0].begin.year
    assert_equal this_year + 1, quarters[1].begin.year
    assert_equal this_year + 1, quarters[2].begin.year
    assert_equal this_year + 1, quarters[3].begin.year
  end
  
  test 'all for a specified this year, default calendar' do
    this_year = Time.zone_default.today.year
    quarters = Quarter.all(this_year)
    
    assert_equal this_year, quarters[0].begin.year
    assert_equal this_year + 1, quarters[1].begin.year
    assert_equal this_year + 1, quarters[2].begin.year
    assert_equal this_year + 1, quarters[3].begin.year
  end
  
  test 'all for a specified arbitrary year, default calendar' do
    a_year = 2030
    quarters = Quarter.all(a_year)
    
    assert_equal a_year, quarters[0].begin.year
    assert_equal a_year + 1, quarters[1].begin.year
    assert_equal a_year + 1, quarters[2].begin.year
    assert_equal a_year + 1, quarters[3].begin.year
  end
  
  test 'all for a specified this year, default calendar, force this_year' do
    this_year = Time.zone_default.today.year
    quarters = Quarter.all(this_year, :this_year => true)
    
    assert_equal this_year, quarters[0].begin.year
    assert_equal this_year, quarters[1].begin.year
    assert_equal this_year, quarters[2].begin.year
    assert_equal this_year, quarters[3].begin.year
  end
  
  test 'all for a specified arbitrary year, default calendar, force this_year' do
    a_year = 2030
    quarters = Quarter.all(a_year, :this_year => true)
    
    assert_equal a_year, quarters[0].begin.year
    assert_equal a_year, quarters[1].begin.year
    assert_equal a_year, quarters[2].begin.year
    assert_equal a_year, quarters[3].begin.year
  end
  
  test "current quarter" do
    assert_equal Quarter, Quarter.current.class
    assert Quarter.current.is_a?(Range)
    assert Quarter.current.begin.is_a?(Date)
    assert Quarter.current.end.is_a?(Date)
    assert Quarter.current.include?(Date.current)
    assert Quarter.current.include?(Time.zone.now)
  end
  
  test "general quarters" do
    assert_equal Quarter, Quarter.general(1).class
    assert_equal Quarter.specific(1), Quarter.general(1)
    assert_not_equal Quarter.specific(2), Quarter.general(2)
    expected_year = Time.zone_default.today.year
    (1..8).each do |num|
      assert_equal expected_year, Quarter.general(num).begin.year 
      assert_equal Quarter.general(num).begin, Quarter.general(num + Quarter.number_of_quarters).begin
      assert_equal Quarter.general(num).end, Quarter.general(num + Quarter.number_of_quarters).end
    end
  end
end
