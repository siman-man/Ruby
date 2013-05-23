require '/Users/siman/Programming/ruby/Ruby/ryudai_rb/ryudai_rb4/lib/to_j'

describe String do
  it "日本語を英語に" do
    "こんにちわ".to_j.should == "Hello"
  end
end
