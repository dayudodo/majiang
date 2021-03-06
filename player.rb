require_relative 'extension'

class Player
  # 手里面的牌为shouPai, 适合规则的牌是rulePai, 拿到的那张牌为naPai(系统发牌或者别人打的), 14张牌为fourteenPai
  attr_accessor :shouPai, :rulePai, :naPai, :fourteenPai, :yise, :origin_shouPai, :chuPai
  # 是否胡牌？有很多类似，比如七对，碰碰胡
  attr_reader :huPai
  # 算番
  SUAN_FAN={:qidui=>2,:pengpeng=>2}

  def initialize(shouPai)
    @shouPai=shouPai.sort
    rulePai=[]
    @huPai=false
    @yise=false
  end

  def naPai=(pai)
    # @fourteenPai=(@shouPai<<pai).sort
    @fourteenPai=(@shouPai + [pai]).sort
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
    # 接收三个参数:start, :length, :pai, 索引开始start, 长度为length, pai是你检测哪个牌
    start=(option[:start] ||= 0)
    length=(option[:length] ||= how_many)
    # 如果传递的是一个剩牌组合：比如["b1","b1"], 那么同样可以检测出来！
    # whichPai= option[:shengPai] ||= @shouPai
    whichPai= option[:shengPai] ||= @fourteenPai
    # 加入判断牌并通过索引查询的方法
    if option[:pai]
      whichPai.count(option[:pai].to_s) == how_many ? true : false
    else
      whichPai.count(whichPai[start]) == how_many
    end
  end
  # 是否连续的两张牌
  def validAA(option={})
    validSame(2,option)
  end
  # 是否连续的三张牌
  def validAAA(option={})
    validSame(3,option)
  end
  # 是否四张连续
  def validAAAA(option={})
    validSame(4,option)
  end

  # 是否是三个有联系的牌面，花色要一致，并且是连续的
  def validABC(option={})
    start=(option[:start] ||= 0)
    whichPai= option[:shengPai] ||= @shouPai
    length=3
    # 开始序号不能大于10
    raise "can not beyond 10" if start > 10
    # raise "must three" if whichPai.length > 3
    # @shouPai[start..(start+length-1)]
    # 判断是否是同一花色，不是说明没联系
    # return false  if (@shouPai[start..(start+length-1)].collect{|x|x[0]}.uniq.count != 1)
    return true if validAAA(option) # 如果是AAA直接返回true, 连三就是有关系的ABC特例
    abc=whichPai[start..(start+length-1)]
    return false  unless (abc.collect{|x|x[0]}.uniq.count == 1)
    abc.collect!{|x|x[1].to_i}
    # 如果是连续的三张，则为true, 比如1,2,3或者7,8,9这样的
    (abc[0]+1 ==abc[1]) and (abc[1]+1 == abc[2]) ? true : false
  end

  def valid2ABC(option={})
    whichPai= option[:shengPai] ||= @shouPai
    if valid2ABC_base(shengPai: whichPai)
      return true
    else

      # 交换122334中的index 2 3，变成123234
      whichPai = whichPai.exchange(2,3)
      return true if valid2ABC_base(shengPai: whichPai)
      # 压缩一下牌，看是否是t1 t1 t2 t2 t3 t3这种情况，还要优先判断上面的情况
      comp=whichPai.uniq 
      # 判断是否成对，以避免 b4 b5 b5 b5 b6 b6 也被判断为正确
      doubleEqual = (whichPai[0]==whichPai[1]  and whichPai[2]==whichPai[3] and whichPai[4]==whichPai[5])
      if doubleEqual  and comp.length==3 and validABC(shengPai: comp)
        return true
      end
    end
    false
  end
  # 像是个递归的程序了,可惜还不太会写。。。
  def valid2ABC_base(option={})
    start=(option[:start] ||= 0)
    whichPai= option[:shengPai] ||= @shouPai
    # 长度为6或者7，存在1111234这种情况，这种情况不在此处理
    first_third=whichPai[start..(start+2)]
    last_third=whichPai[start+3..(start+5)]
    # p [first_third,last_third]
    if validAAA(shengPai: first_third) # 如果是aaa这样的牌，检测下一组是否是ABC
      # 如果开头三2个是AAA，只判断后面的即可
      if validAAA(shengPai: last_third)
        return true
      else
        return validABC(shengPai: last_third) ? true : false
      end
    else
      # 开头不是三连张,判断是不是123
      if validABC(:shengPai=> first_third)
        # 如果是，就判断后面的是不是123或者111
        return (validABC(shengPai: last_third) or validAAA(shengPai: last_third)) ? true : false
      else
        return false
      end
    end
  end

  def valid3ABC(option={})
    whichPai= option[:shengPai] ||= @shouPai
    raise "length at least 9" if whichPai.length<9
    if valid3ABC_base(shengPai: whichPai)
      return true
    else
      whichPai = whichPai.exchange(2,3)
      return valid3ABC_base(shengPai: whichPai)
    end
  end

  def valid3ABC_base(option={})
    start=(option[:start] ||= 0)
    whichPai= option[:shengPai] ||= @shouPai
    # 其实应该先看前6，再看后3！
    first_third=whichPai[start..(start+2)]
    last_six=whichPai[start+3..(start+8)]
    first_six=whichPai[start..(start+5)]
    last_three=whichPai[start+6..(start+8)]

    if valid2ABC(shengPai: first_six)
      return validABC(shengPai: last_three)
    else
      if validABC(shengPai: first_third)
        return valid2ABC(shengPai: last_six)
      else
        return false
      end
    end
  end
  # 确认四个ABC，即12张牌是否规则
  def valid4ABC(option={})
    whichPai= option[:shengPai] ||= @shouPai
    raise "length at least 12" if whichPai.length<12
    if valid4ABC_base(shengPai: whichPai)
      return true
    else
      whichPai = whichPai.exchange(2,3)
      return valid4ABC_base(shengPai: whichPai)
    end
  end

  def valid4ABC_base(option={})
    start=(option[:start] ||= 0)
    whichPai= option[:shengPai] ||= @shouPai
    raise "length at least 12" if whichPai.length<12
    first_third=whichPai[start..(start+2)]
    last_nine=whichPai[start+3..(start+11)]
    first_nine=whichPai[start..(start+8)]
    last_three=whichPai[start+9..(start+11)]
    # if validAAA(shengPai: first_third)
    #   return valid3ABC(shengPai: last_nine)
    # else
    #   if validABC(shengPai: first_third)
    #     return valid3ABC shengPai: last_nine
    #   else
    #     return false
    #   end
    # end
    if valid3ABC(shengPai: first_nine)
      return validABC(shengPai: last_three)
    else
      if validABC(shengPai: first_third)
        return valid3ABC(shengPai: last_nine)
      else
        return false
      end
    end
  end

  # private
  # 胡牌检测
  def piHu(option={})
    # 取出所有的对牌，然后判断是否是屁胡
    # 先要判断是否是大胡，如果是，返回大胡有几番。
    # 拿走所有的将与碰或者杠，即相同的牌
    # 找到所有的AA牌
    whichPai= option[:shengPai] ||= @fourteenPai
    pai_str=whichPai.join
    raise "起码要14张牌" if whichPai.length <14
    all_dui=pai_str.scan(/(..)\1/).flatten
    # flatten之后才会是这样：["b2", "b3", "fa", "zh"]
    # 而不flatten则没法使用，比如[["b2"], ["b3"], ["fa"], ["zh"]]
    # puts "current fourteenPai:#{fourteenPai}"
    bool_hu=false
    all_dui.each do |dui|
      reg=Regexp.new("#{dui}#{dui}")
      shengPai=pai_str.gsub(reg,"")
      # puts shengPai
      origin=shengPai.dup
      # 先去掉此对牌dui，一定得是连续的两个，不能去多喽
      # 不能使用gsub(dui,"")，因为有可能把连续三个的dui牌去掉，参见
      # majiangtest.spec中多个同花色规则屁胡中的例子

      shengPai=shengPai.gsub(/(..)\1\1\1/,"") # 先把连四去掉
      # next if not [3,6,9,12].include?(shengPai.length/2)
      2.times do
        # puts shengPai
        shengPai = strToArray(shengPai)
        # puts "屁胡shengPai:#{shengPai}"
        case shengPai.length
        when 3 then bool_hu=true if validABC :shengPai=> shengPai
        when 6 then bool_hu=true if valid2ABC :shengPai=> shengPai
        when 9 then bool_hu=true if valid3ABC :shengPai=> shengPai
        when 12 then bool_hu=true if valid4ABC :shengPai=> shengPai
        end
        # 如果还不能胡，连四去掉后检测一次是否胡
        if false==bool_hu
          shengPai=origin.gsub(/(..)\1\1/,"") # 再把连三去掉，不能先去连三
        end
      end
    end
    bool_hu
  end

  # 碰碰胡
  def pengpengHu
    raise "起码要14张牌" if @fourteenPai.length < 14
    # @fourteenPai[0]
    # 首先要把所有的将牌拿出来，或者判断三个的有多少，拿掉，再看成对的有几个，这就是碰碰胡了。
    temp=@fourteenPai.join
    reg=/(..)\1\1\1?/  # 可能是三张也可能是四张
    # pengGroup=(temp.scan reg).flatten  # 扫描过后是个二维数组，变成一维的。
    # pengGroup.each { |e|
    #   temp.gsub!(e,"") # 把三、四张连续的都删除掉
    # }
    temp.gsub!(reg,"") # 有了正则一切变得如此简单
    return false if temp.length != 4 # 最后剩下的肯定是个将，如果不为4，则肯定不是将
    # validAA(shengPai: [temp[0..1],temp[2..3]]) ? true : false
    # 或者使用正则表达式，俺更熟悉
    temp=~/(..)\1/ ? true : false
  end
  # 七对
  def qiduiHu
    raise "起码要14张牌" if @fourteenPai.length < 14
    @fourteenPai.join=~/(..)\1(..)\2(..)\3(..)\4(..)\5(..)\6(..)\7/ ? true : false
  end
  # 龙七对
  def longqiduiHu
    return false if not qiduiHu
    @fourteenPai.uniq.length < 7 ? true : false
  end
  # 有将的情况下，对剩下牌的检测，使用14张牌胡检测
  def jiangHu
    # 首先取出将牌，碰牌(似乎不对，比如123 123 55这样的牌，肯定是超过二对的，但是符合规则！)
    # 取出将牌，成对的，如果超过二对，不能胡。
    raise "起码要14张牌" if @fourteenPai.length <14
  end

  # 胡啥牌？可以检测13张牌到底胡哪些个。
  def huShaPai
    hupai_zhang=[]
    all_single_pai = BING+TIAO+ZHIPAI
    # origin_shouPai=@shouPai

    all_single_pai.each{ |single_pai|
      # fourteen=@shouPai + [single_pai]
      self.naPai=single_pai
      # 如果包括5张相同的，跳过
      next if @fourteenPai.join.scan(single_pai).length>4
      # puts "fourteen: #{fourteenPai}"
      if piHu(:shengPai=>@fourteenPai)
        hupai_zhang<<single_pai
      end
    }
    hupai_zhang.sort
  end

  # 字符串转换成数组，比如b1b2b3会变成["b1","b2","b3"]
  def strToArray(str)
    if str.class==Array
      # raise "str is array:#{str}"
      return str
    end
    str.scan(/(..)/).flatten
  end
  # 一色？检测全牌是否是同一花色
  def yise?
    raise "起码要14张牌" if @fourteenPai.length <14
    if @fourteenPai.collect{|x|x[0]}.uniq.length == 1
      return true
    else
      return false
    end
  end
end
