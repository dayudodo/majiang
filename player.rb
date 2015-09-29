class Player
	attr_accessor :current_pai
	
	def initialize(current_pai)
		@current_pai=current_pai.sort
	end
end