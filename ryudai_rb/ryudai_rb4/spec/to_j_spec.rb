require '/Users/siman/Programming/ruby/ryudairb/round4/lib/to_j'

describe Numeric do
  it "range 0 - 1万" do
    0.to_j.should == "零"
    1.to_j.should == "一"
    3.to_j.should == "三"
    10.to_j.should == "十"
    33.to_j.should == "三十三"
    77.to_j.should == "七十七"
    100.to_j.should == "百"
    108.to_j.should == "百八"
    285.to_j.should == "二百八十五"
    330.to_j.should == "三百三十"
    777.to_j.should == "七百七十七"
    999.to_j.should == "九百九十九"
    1000.to_j.should == "千"
    1001.to_j.should == "千一"
    2013.to_j.should == "二千十三"
    3333.to_j.should == "三千三百三十三"
    9999.to_j.should == "九千九百九十九"
  end

  it "range 1万 - 1兆" do
    10000.to_j.should == "一万"
    10001.to_j.should == "一万一"
    12345.to_j.should == "一万二千三百四十五"
    100000.to_j.should == "十万"
    100001.to_j.should == "十万一"
    330030.to_j.should == "三十三万三十"
    100800.to_j.should == "十万八百"
    1000000.to_j.should == "百万"
    1000001.to_j.should == "百万一"
    7770000.to_j.should == "七百七十七万"
    1001001.to_j.should == "百万千一"
    10000000.to_j.should == "一千万"
    30030030.to_j.should == "三千三万三十"
    10000001.to_j.should == "一千万一"
    33333333.to_j.should == "三千三百三十三万三千三百三十三"
  end

  it "range 1兆 - 1垓" do
    1000000000000.to_j.should == "一兆"
    1000000000001.to_j.should == "一兆一"
    1000100010001.to_j.should == "一兆一億一万一"
    2000000000000.to_j.should == "二兆"
    10000000000000000.to_j.should == "一京"
    10000000000000001.to_j.should == "一京一"
    10001000000000001.to_j.should == "一京一兆一"
    12345678912345678.to_j.should == "一京二千三百四十五兆六千七百八十九億一千二百三十四万五千六百七十八"
    100000000000000000000.to_j.should == "一垓"
  end
end
