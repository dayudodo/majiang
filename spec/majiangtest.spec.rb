require_relative 'spec_helper'
require_relative '../player'

describe "valid xx xxx xxx*n" do
  it "validAA 对牌" do
    newPlayer=Player.new %w{b1 b1 b1 b1}
    res=newPlayer.validAA(shengPai: ["b1","b1"])
    expect(res).to be true
  end

  it "validAAA 三同牌" do
    three=Player.new %w{fa fa fa}
    expect(three.validAAA shengPai: %w{fa fa fa}).to be true
  end
  it "validAAA false" do
    three=Player.new %w{fa fa b1 b2}
    expect(three.validAAA shengPai:%w{fa fa b1 b2}).to be false
  end

  it "validAAAA 四同牌" do
    four=Player.new %w{zh zh zh}
    four.naPai="zh"
    expect(four.validAAAA).to be true

    result=four.validAAAA shengPai: %w{fa fa fa fa}
    expect(result).to be true
  end

  it "validABC 手牌" do
    abc=Player.new %w{b1 b2 b2 b3 b3 b4 b5 t9 di di fa fa t3}
    abc.shouPai.exchange(2,3)
    result=abc.validABC
    expect(result).to be true

    result=abc.validABC start: 4 # 从第四个，也就是b3处开始检测
    expect(result).to be true
  end
  it "validABC 仅三张牌123" do
    abc=Player.new %w{b1 b2 b2 b3 b3 b4 t9 t9 di di fa fa t3}
    abc.shouPai.exchange(2,3)
    result=abc.validABC(:shengPai=>%w{t1 t2 t3})
    expect(result).to be true
  end

  it "validABC false" do
    abc=Player.new %w{b1 b2 b2 b3 b3 b4 t9 t9 di di fa fa t3}
    abc.shouPai.exchange(2,3)
    result=abc.validABC(:shengPai=>%w{t1 t2 t2})
    expect(result).to be false
    result=abc.validABC(:shengPai=>%w{t1 t2 fa})
    expect(result).to be false
  end

  # 123123 122334 或者111234这种情况
  it "valid2ABC 六张牌123345" do
    abc2=Player.new %w{b1 b2 b3 t3 t4 t5}
    expect(abc2.valid2ABC).to be true
  end
  it "valid2ABC 六张牌111234" do
    abc2=Player.new %w{b1 b1 b1 t3 t4 t5}
    expect(abc2.valid2ABC).to be true

    abc2=Player.new %w{t3 t4 t5 b1 b1 b1}
    expect(abc2.valid2ABC).to be true
  end
  it "valid2ABC 六张牌122334" do

    abc2=Player.new %w{b1 b2 b2 b3 b3 b4}
    expect(abc2.valid2ABC).to be true
  end
  it "valid2ABC 六张牌234111" do
    abc2=Player.new %w{b1 b2 b3 zh zh zh }
    expect(abc2.valid2ABC).to be true
  end
  it "valid2ABC 6张非杠 123333" do
    abc2=Player.new %w{b1 b2 b3 b3 b3 b3}
    expect(abc2.valid2ABC).to be true
  end
  it "valid2ABC 122335 false" do
    abc2=Player.new %w{b1 b2 t2 b3 b3 b5}
    expect(abc2.valid2ABC).to be false
  end
  it "valid2ABC false 111235" do
    abc=Player.new %w{fa fa fa b1 t1 zh}
    expect(abc.valid2ABC).to be false
  end

  it "valid3ABC 正规九张牌" do
    abc3=Player.new %w{b1 b2 b3 fa fa fa t1 t2 t3}
    expect(abc3.valid3ABC).to be true
  end
  it "valid3ABC 九张 122334123" do
    abc3=Player.new %w{b1 b2 b2 b3 b3 b4 t1 t2 t3}
    expect(abc3.valid3ABC).to be true
  end
  it "valid3ABC 9张 false" do
    abc3=Player.new %w{b1 b2 b3 fa fa fa t1 t2 t2}
    expect(abc3.valid3ABC).to be false
  end

  it "valid3ABC 10张牌带杠" do
    # abc3=Player.new %w{b1 b2 b3 fa fa fa fa t1 t2 t3}
    # expect(abc3.valid3ABC).to be true
  end

  it "valid4ABC 12张牌" do
    abc4=Player.new %w{b1 b2 b3 fa fa fa t1 t2 t3 t4 t5 t6}
    expect(abc4.valid4ABC).to be true
    # 后面错位
    abc4=Player.new %w{b1 b2 b3 fa fa fa t1 t2 t2 t3 t3 t4}
    expect(abc4.valid4ABC).to be true
  end
  it "valid4ABC 12张牌 前6错位" do
    abc4=Player.new %w{b1 b2 b2 b3 b3 b4 t1 t2 t2 t3 t3 t4}
    expect(abc4.valid4ABC).to be true
  end
  it "valid4ABC 12张牌，中间错位" do
    abc4=Player.new %w{zh zh zh b1 b2 b2 b3 b3 b4 t1 t2 t3}
    expect(abc4.valid4ABC).to be true
  end
  it "valid4ABC 12 false" do
    abc4=Player.new %w{b1 b2 b3 fa fa fa t1 t2 t2 t3 t3 zh}
    expect(abc4.valid4ABC).to be false
  end

end

describe "糊牌之" do
  # 七对检测，差一个都不行
  it "七对与龙七对" do
    qidui=Player.new(%w{b1 b1 b2 b2 t9 t9 t9 t9 di di fa fa t3})
    qidui.naPai="t3"
    expect(qidui.qiduiHu).to be true
    expect(qidui.longqiduiHu).to be true
  end
  it "七对false" do
    qidui=Player.new(%w{b1 b1 b2 b2 t9 t9 t9 t9 di di fa fa t3})
    qidui.naPai="t4"
    expect(qidui.qiduiHu).to be false
  end

  # 碰碰胡和七对都是最容易检测的。
  it "普通碰碰胡" do
    # 碰碰胡检测
    pengpeng=Player.new %w{b1 b1 b1 b2 b2 b2 t3 t3 t3 fa fa fa di}
    pengpeng.naPai="di"
    expect(pengpeng.pengpengHu).to be true

    pengpeng=Player.new %w{b1 b1 b1 b2 b2 b2 zh zh zh fa fa fa di}
    pengpeng.naPai="di"
    expect(pengpeng.pengpengHu).to be true
  end
  it "碰碰糊带1杠" do
    pengpeng=Player.new %w{b1 b1 b1 b1 b2 b2 b2 t3 t3 t3 fa fa fa t5}
    pengpeng.naPai="t5"
    expect(pengpeng.pengpengHu).to be true
  end
  it "碰碰糊带2杠" do
    pengpeng=Player.new %w{b1 b1 b1 b1 b2 b2 b2 b2 t3 t3 t3 fa fa fa t5}
    pengpeng.naPai="t5"
    expect(pengpeng.pengpengHu).to be true
  end
  it "碰碰糊带3杠" do
    pengpeng=Player.new %w{b1 b1 b1 b1 b2 b2 b2 b2 t3 t3 t3 t3 fa fa fa t5}
    pengpeng.naPai="t5"
    expect(pengpeng.pengpengHu).to be true
  end
  it "碰碰胡false" do
    pengpeng=Player.new %w{b1 b1 b1 b2 b2 b2 t3 t3 t4 fa fa fa di}
    pengpeng.naPai="di"
    expect(pengpeng.pengpengHu).to be false
  end

  it "花色相同" do
    qing=Player.new %w{b1 b2 b2 b3 b3 b4 b4 b5 b5 b5 b6 b7 b7}
    qing.naPai="b7"
    expect(qing.yise?).to be true
  end
  it "花色相同false" do
    qing=Player.new %w{b1 b2 b2 b3 b3 b4 b4 b5 b5 b5 b6 b7 b7}
    qing.naPai="fa"
    expect(qing.yise?).to be false
  end

  # 屁胡难喽。。。还要算杠
  it "规则屁胡" do
    pi=Player.new %w{b1 b2 b2 b3 b3 b4 t4 t5 t6 fa fa fa zh}
    pi.naPai="zh"
    expect(pi.piHu).to be true
  end
  it "多个同花色规则屁胡" do
    pi=Player.new %w{b1 b2 b2 b3 b3 b4 t4 t5 t5 t5 t6 fa fa}
    pi.naPai="fa"
    expect(pi.piHu).to be true

    pi=Player.new %w{b1 b2 b2 b3 b3 b4 b4 b5 b5 b5 b6 fa fa}
    pi.naPai="fa"
    expect(pi.piHu).to be true
  end


  it "带杠屁胡" do
    gang_pi=Player.new %w{t1 t2 t3 t4 t5 t6 b4 b5 b6 fa fa fa fa zh}
    gang_pi.naPai="zh"
    expect(gang_pi.piHu).to be true
  end
  it "复杂清一色外加屁胡" do
    # 有连续的4个b5
    qing=Player.new %w{b1 b2 b2 b3 b3 b4 b4 b5 b5 b5 b5 b6 b7}
    qing.naPai="b7"
    expect(qing.piHu).to be true
  end
  it "屁胡false" do
    pi=Player.new %w{b1 b2 b2 b3 b3 b4 t4 t5 t6 fa fa fa zh}
    pi.naPai="di"
    expect(pi.piHu).to be false
  end

# huShaPai最后会返回一个排序的数组，注意顺序
  describe "胡啥牌" do
    it "清一色听牌" do
      qing=Player.new %w{b1 b2 b2 b3 b3 b4 b4 b5 b5 b5 b6 b7 b7}
      expect(qing.huShaPai).to eq ["b5", "b7"]
    end
    it "清一色听7张" do
      qing=Player.new %w{b1 b2 b3 b4 b5 b6 b7 b8 b8 b8 b9 b9 b9 }
      expect(qing.huShaPai).to eq ["b1", "b3", "b4", "b6", "b7", "b8", "b9"]
    end
    it "清一色听牌false" do
      qing=Player.new %w{b1 b2 b3 b4 b5 b6 b7 b8 b8 b8 t1 t3 t5 }
      expect(qing.huShaPai).to eq([])
    end
    it "双将倒" do
      peng=Player.new %w{zh zh di di b1 b2 b3 t2 t2 t2 fa fa fa}
      expect(peng.huShaPai).to eq(["di","zh"])
    end
  end
end
