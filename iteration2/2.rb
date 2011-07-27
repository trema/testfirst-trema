describe "Hello Trema" do
  it 'should be a String' do
    "Hello Trema".should be_a( String )
  end


  it 'should not == "Hello Frinfon"' do
    "Hello Trema".should_not == "Hello Frinfon"
  end
end
