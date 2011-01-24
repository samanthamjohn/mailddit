class Email < Mongomatic::Base
	
	def self.collection_name
    	return 'emails'
  	end

  	def self.create_indexes
		collection.create_index("tags")
		collection.create_index("status")
	end

	def validate
		self.errors << ["status", "cannot be blank"] if self["status"].blank
	end 
	

end
