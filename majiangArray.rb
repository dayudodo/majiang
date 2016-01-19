# require './player'
require_relative 'player'

# puts (BAIBAN*4).shuffle[1..4].collect{|x|x[1]}
# 使用product产生所有的牌


# 每局牌都是花色的四种，最后打乱（感觉shuffle）
# yiju=(BING*4 + TIAO*4 + ZHIPAI*4).shuffle
# p yiju.count # 斗地主一共76张牌？

# 三个玩家，每个人都是13张牌。
# a_player=Player.new(yiju.pop(13))
# b_player=Player.new(yiju.pop(13))
# c_player=Player.new(yiju.pop(13))

qing=Player.new %w{b1 b1 b1 b2 b2 b2 b3 b4 b5 b6 b7 b8 b9 }
p qing.huShaPai

qing=Player.new %w{b1 b2 b3 b4 b5 b6 b7 b8 b8 b8 b9 b9 b9 }
p qing.huShaPai

qing=Player.new %w{b1 b2 b2 b2 b2 b3 b3 b3 b4 b5 b6 b7 b8}
p qing.huShaPai

peng=Player.new %w{b1 b2 b2 b2 b3 b4 b5 b6 t1 t2 t2 t3 t3}
p peng.huShaPai # wow, 碰碰胡啥牌也可以检测出来了！
# t1 t1 t2 t2 t3 t3 如何检测出是正确的牌？
peng=Player.new %w{b1 b2 b2 b2 b3  t1 t1 t1 t1 t2 t2 t3 t3}
p peng.huShaPai # wow, 碰碰胡啥牌也可以检测出来了！
# t1 t1 t2 t2 t3 t3 如何检测出是正确的牌？

    # qing=Player.new %w{b1 b2 b2 b3 b3 b4 b4 b5 b5 b5 b5 b6 b7}
    # qing.naPai="b7"
    # qing.piHu
    # puts qing.piHu