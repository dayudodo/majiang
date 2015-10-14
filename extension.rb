# 全局常量，所有的牌
BING = ['b1','b2','b3','b4','b5','b6','b7','b8','b9']
TIAO   = ['t1','t2','t3','t4','t5','t6','t7','t8','t9']
# 中发白（中风、发财、白板），为避免首字母重复，白板用电视拼音，字牌
ZHIPAI    = ['zh','fa','di']

# 交换两张牌的位置
  class Array
    def exchange(i,j)
      self[i],self[j]=self[j],self[i]
      self
    end
  end
