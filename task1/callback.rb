module Blending
	def self.included(base)
		base.class_eval do
			after_save :make_juice if base == Apple
		end
	end

	def make_juice
		puts 'Apple juice is now made because we only make apple juice and not orange juice.'
	end
end

class Apple < ApplicationRecord
  include Blending
end

class Orange < ApplicationRecord
  include Blending
end