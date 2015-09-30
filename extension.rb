# 交换两张牌的位置
class Array
	def exchange(i,j)
		self[i],self[j]=self[j],self[i]
	end
end