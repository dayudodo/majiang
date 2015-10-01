require_relative 'extension'

class Player
  # 手里面的牌为shouPai, 适合规则的牌是rulePai, 拿到的那张牌为naPai(系统发牌或者别人打的), 14张牌为fourteenPai
  attr_accessor :shouPai, :rulePai, :naPai, :fourteenPai
  # 是否胡牌？有很多类似，比如七对，碰碰胡
  attr_reader :huPai
  # 算番
  SUAN_FAN={:qidui=>2,:pengpeng=>2}

  def initialize(shouPai)
    @shouPai=shouPai.sort
    rulePai=[]
    @huPai=false
  end

  def naPai=(pai)
    @fourteenPai=(@shouPai<<pai).sort
  end


  # 玩家换牌并打出一张
  def changePai(pai,index)
    temp=@shouPai[index]
    @shouPai[index]=pai
    temp
  end
  # 其它玩家打出一家牌，系统需要判断是否有人要碰，即其它两家牌的当前牌中是否有相同的两张牌
  def canPeng?(pai)
    validAA(pai: pai)
  end
  # 是否可以杠
  def canGang?(pai)
    validAAA(pai: pai)
  end
  def validSame(how_many,option={})
    # 接收三个参数:start, :length, :pai
    start=(option[:start] ||= 0)
    length=(option[:length] ||= how_many)
    # 加入判断牌而并通过索引查询的方法
    if option[:pai]
      @shouPai.count(option[:pai].to_s) == how_many ? true : false
    else
      @shouPai.count(@shouPai[start]) ==how_many
    end
  end
  # 是否连续的两张牌
  def validAA(option={})
    option[:start] ||= 0
    option[:length] ||= 2
    @shouPai.count(@shouPai[start]) ==2
  end
  # 是否连续的三张牌
  def validAAA(option={})
    validSame(3,option)
  end
  # 是否是三个有联系的牌面，花色要一致，并且是连续的
  def validABC(option={})
    start=(option[:start] ||= 0)
    length=3
    # 开始序号不能大于10
    raise "can not beyond 10" if start > 10
    # @shouPai[start..(start+length-1)]
    # 判断是否是同一花色，不是说明没联系
    # return false  if (@shouPai[start..(start+length-1)].collect{|x|x[0]}.uniq.count != 1)
    abc=@shouPai[start..(start+length-1)]
    return false  unless (abc.collect{|x|x[0]}.uniq.count == 1)
    abc.collect!{|x|x[1].to_i}
    # 如果是连续的三张，则为true, 比如1,2,3或者7,8,9这样的
    (abc[0]+1 ==abc[1]) and (abc[1]+1 == abc[2]) ? true : false
  end
  def validAAAA(option={})
    validSame(4,option)
  end

  # private
  # 胡牌检测
  def pengpengHu
    # @fourteenPai[0]
    true
  end
  def qiduiHu
    raise "不够14张" if @fourteenPai.length!=14
    @fourteenPai.join=~/(..)\1(..)\2(..)\3(..)\4(..)\5(..)\6(..)\7/ ? true : false
  end
  def longqiduiHu
    return false if not qiduiHu
    @fourteenPai.uniq.length < 7 ? true : false
  end
  # 有将的情况下，对剩下牌的检测，使用14张牌胡检测
  def jiangHu
    # 首先取出将牌，碰牌(似乎不对，比如123 123 55这样的牌，肯定是超过二对的，但是符合规则！)
    # 取出将牌，成对的，如果超过二对，不能胡。
    raise "不够14张" if @fourteenPai.length!=14

    
  end
end
