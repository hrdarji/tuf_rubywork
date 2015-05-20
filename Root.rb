
require 'json'
require 'time'

class Root

	# Below line will define a method in the class that will give us back value of respective variable 
	# Seperate methods will be defined for eacg methid using attr_reader
	attr_reader	:keys, :role_keys, :role_thresholds, :expires

	def initialize(root_txt_file)

		# below lines will initialize blank hash varibles 
  	@keys, @role_keys, @role_thresholds = {}, {}, {}
		
    root_metadata = File.open(root_txt_file,'rb')
    #puts root_metadata.read
		#below line will parse root_txt json file
		root_txt = JSON.parse(root_metadata.read)

		
		#below loop will initialize @keys
		root_txt['signed']['keys'].each do |keyid, data|    
          #puts keyid
          #puts data
      		# below two lines will work if we have OpenSSL::PKey::RSA and Gem::TUF::PublicKey classes
          rsa_key     = OpenSSL::PKey::RSA.new data['keyval']['public']
      	   public_key  = Gem::TUF::PublicKey.new rsa_key  # this will make rsa_key an object of Gem::TUF::PublicKey class
      		keys[keyid] = public_key
      	end

      	#below loop will initialize @role_keys
      	root_txt['signed']['roles'].each do |name, role_info|
      		#puts name
          #puts role_info
          role_key_array = role_keys[name.to_sym] = []   # to_sym will return string version of the 
     	  	role_info['keyids'].each do |keyid| 
        		role_key = keys[keyid]
        		end
        	role_thresholds[name.to_sym] = role_info['threshold']
        end

        expires = Time.parse(root_txt['expires'])
   end
end

root Root.new('root_metadata.txt')