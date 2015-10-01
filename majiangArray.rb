# require './player'
require_relative 'player'
# 卡五星的牌面分析，两种牌，b代表饼，t代表条，就这两种牌，没有万。
BINGZI = ['b1','b2','b3','b4','b5','b6','b7','b8']
TIAO   = ['t1','t2','t3','t4','t5','t6','t7','t8']
# 中发白（中风、发财、白板），为避免首字母重复，白板用电视拼音
ZHIPAI    = ['zh','fa','di']
# puts (BAIBAN*4).shuffle[1..4].collect{|x|x[1]}
# 使用product产生所有的牌


# 每局牌都是花色的四种，最后打乱（感觉shuffle）
yiju=(BINGZI*4 + TIAO*4 + ZHIPAI*4).shuffle
# p yiju.count # 斗地主一共76张牌？

# 三个玩家，每个人都是13张牌。
a_player=Player.new(yiju.pop(13))
b_player=Player.new(yiju.pop(13))
c_player=Player.new(yiju.pop(13))

p a_player
# 桌子上的牌，需要记录是哪个打的，以便统计
paimian=yiju.pop
p paimian

# 当前用户，发的牌属于当前用户，包括还要记录当前用户打的牌，于是，类就产生了。
# current_player

# 有牌了需要进行交换或者原样打出

# 电脑的好处就是可以自动排序
# fapai=

# test =============
# chupai="bai"
# someUser=Player.new(["b1", "b2", "b2", "b3", "b4", "b6", "dian", "dian", "fa", "fa", "fa", "t3", "t5"])
# someUser.exchange(2,3)
# p someUser.shouPai.zip [*0..12]
# p canPeng?(someUser, chupai)
# p someUser.canGang?("fa") # 能够扛发财不？

# 是否是一组牌，指三张连续或者三张相同
# p someUser.delete "bai"
# p someUser
# p someUser.changePai("b5",5)
# p someUser.validAAA pai: "fa"
# p someUser.canGang? "fa"
# p someUser.validAAA start: 8
# p someUser.validABC start: 2
# p someUser.huPai
# p someUser.naPai="fa"
# p someUser.fourteenPai
# 三个顺子是否正确 abbccd, aabbcc, aaabbbccc,似乎用数字更好解决，也就是可否整除3？
# 111,222,123,789,或者他们的和都是可以整除3的
# sanshun=%w{b1 b2 b2 b3 b3 b4}



# 或者使用纯粹的数字，然后把这些数字重复一下，打印出来，比字符串要快多了。
# BAIBAN_NUMBER = [11,12,13,14,15,16,17,18,19]
# 21,22,23,24,25,26,27,28,29
# puts (BAIBAN_NUMBER*4).shuffle[1..4]
