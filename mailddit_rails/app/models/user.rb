class User < Mongomatic::Base
	acts_as_authentic do |c|
		#c.my_config_option = my_value
	end # the configuration block is optional
	
	def self.collection_name
    	return 'users'
  	end

  	def self.create_indexes
		collection.create_index("email_address")
		collection.create_index("emails")
	end

 	def validate 
    	self.errors << ["email_address", "cannot be blank"] if self["email_address"].blank?
  	end

end
