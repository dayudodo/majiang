require_relative 'extension'

class Player
  attr_accessor :shouPai

  def initialize(shouPai)
    @shouPai=shouPai.sort
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
  # 是否是连续的三张牌
  def validAAA(option={})
    validSame(3,option)
  end
  # 是否是连续的两张牌
  def validAA(option={})
    option[:start] ||= 0
    option[:length] ||= 2
    @shouPai.count(@shouPai[start]) ==2
  end
  # 是否是三个有联系的牌面，花色要一致，并且是连续的
  def validABC(option={})
    start=(option[:start] ||= 0)
    length=3
    # 开始序号不能大于10
    raise "can not beyond 10" if start > 10
    # @shouPai[start..(start+length-1)]
    # 判断是否是同一花色，不是说明没联系
    return false  if (@shouPai[start..(start+length-1)].collect{|x|x[0]}.uniq.count != 1)



  end
end
