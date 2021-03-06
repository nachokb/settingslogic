require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "Settingslogic" do
  it "should access settings" do
    Settings.setting2.should == 5
  end
  
  it "should access nested settings" do
    Settings.setting1.setting1_child.should == "saweet"
  end
  
  it "should access deep nested settings" do
    Settings.setting1.deep.another.should == "my value"
  end

  it "should access extra deep nested settings" do
    Settings.setting1.deep.child.value.should == 2
  end

  it "should enable erb" do
    Settings.setting3.should == 25
  end
  
  it "should namespace settings" do
    Settings2.setting1_child.should == "saweet"
    Settings2.deep.another.should == "my value"
  end

  it "should return the namespace" do
    Settings.namespace.should be_nil
    Settings2.namespace.should == 'setting1'
  end
  
  it "should return the default namespace" do
    Settings.default_namespace.should == 'defaults'
    Settings4.default_namespace.should == 'default_settings4'
  end

  it "should get a key by a path" do
    Settings.key_by_path("language.haskell.paradigm").should == "functional"
  end

  it "should distinguish nested keys" do
    Settings.language.haskell.paradigm.should == 'functional'
    Settings.language.smalltalk.paradigm.should == 'object oriented'
  end
  
  it "should not collide with global methods" do
    Settings3.collides.does.should == 'not'
  end
  
  it "should merge defaults" do
    Settings4.haskell.paradigm.should == 'functional'
    Settings4.haskell.foo.should == 'bar'
    Settings4.smalltalk.paradigm.should == 'object oriented'
  end

  it "should allow numeric keys" do
    Settings.with_numbers.should == { 12 => 'hello', '21' => 'bye' }
  end

  it "should allow accessing numeric keys as string and viceversa" do
    Settings.with_numbers[12].should == Settings.with_numbers['12']
    Settings.with_numbers[21].should == Settings.with_numbers['21']
  end

  it "should raise a helpful error message" do
    e = nil
    begin
      Settings.missing
    rescue => e
      e.should be_kind_of Settingslogic::MissingSetting
    end
    e.should_not be_nil
    e.message.should =~ /Missing setting 'missing' in/
    
    e = nil
    begin
      Settings.language.missing
    rescue => e
      e.should be_kind_of Settingslogic::MissingSetting
    end
    e.should_not be_nil
    e.message.should =~ /Missing setting 'missing' in 'language' section/
  end

  it "should handle optional / dynamic settings" do
    e = nil
    begin
      Settings.language.erlang
    rescue => e
      e.should be_kind_of Settingslogic::MissingSetting
    end
    e.should_not be_nil
    e.message.should =~ /Missing setting 'erlang' in 'language' section/
    
    Settings.language['erlang'].should be_nil
    Settings.language['erlang'] ||= 5
    Settings.language['erlang'].should == 5

    Settings.language['erlang'] = {'paradigm' => 'functional'}
    Settings.language.erlang.paradigm.should == 'functional'

    Settings.reload!
    Settings.language['erlang'].should be_nil
  end

  # Put this test last or else call to .instance will load @instance,
  # masking bugs.
  it "should be a hash" do
    Settings.send(:instance).should be_is_a(Hash)
  end
end
