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
# a_player=Player.new(yiju.pop(13))
# b_player=Player.new(yiju.pop(13))
# c_player=Player.new(yiju.pop(13))


    abc2=Player.new %w{b1 b2 b2 b3 b3 b5}
abc2.valid2ABC
