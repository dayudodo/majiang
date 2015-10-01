require_relative 'spec_helper'
require_relative '../player'

describe "hupai" do
  it "七对与龙七对" do
    qidui=Player.new(%w{b1 b1 b2 b2 t9 t9 t9 t9 di di fa fa t3})
    qidui.naPai="t3"
    expect(qidui.qiduiHu).to be true
    expect(qidui.longqiduiHu).to be true
  end
  # 七对检测

  it "碰碰胡" do
    # 碰碰胡检测
    pengpeng=Player.new %w{b1 b1 b1 b2 b2 b2 t3 t3 t3 fa fa fa di}
    pengpeng.naPai="di"
    expect(pengpeng.pengpengHu).to be true
  end

  # xit "碰碰糊中有杠" do
  	
  # end
end

describe "valid same" do
	it "杠牌" do
		gang=Player.new %w{fa fa fa fa }
		expect(gang.validAAAA).to be true
	end
	it "三张相同" do
		three=Player.new %w{fa fa fa}
		expect(three.validAAA).to be true
	end
  
end
