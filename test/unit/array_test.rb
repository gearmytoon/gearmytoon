require File.dirname(__FILE__) + '/../test_helper'

class ArrayTest < ActiveSupport::TestCase

  should "know if elements are not equivilent to a subset of those elements" do
    assert_false [1,2,3].equivalent?([2,3])
  end
  should "know if elements are not equivilent to a larger set including those elements" do
    assert_false [1,2,3].equivalent?([1,2,3,4])
  end  
  should "know it is equivalent if the same order" do
    assert [1,2,3].equivalent?([1,2,3])
  end
  should "know it is equivalent if the different orders" do
    assert [1,2,3].equivalent?([2,1,3])
  end
end
