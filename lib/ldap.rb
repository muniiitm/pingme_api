require 'net/ldap'
module CTS
  class LdapResponse
    attr_accessor :message, :success, :user
    def success?; success; end
  end

  class Ldap
    attr_accessor :ldap_connection, :params, :ldap_response, :username, :password

    def initialize(username, password)
      self.ldap_connection = connect_to_ldap_server()
      self.ldap_response = LdapResponse.new()
      self.username = username
      self.password = password
    end

    def verify_ldap_authentication
      cts_user = username if username
      cts_pass = password if password

      filter = Net::LDAP::Filter.eq(AppConfig["ldap_search_filter"], cts_user) if cts_user

      user_details = {}
      #authenticate_ldap_user = true
      authenticate_ldap_user = ldap_connection.bind_as(:base => AppConfig["ldap_treebase"], :filter => filter, :password => cts_pass)      

      if authenticate_ldap_user
        user_details = ldap_user_search(ldap_connection, cts_user)       
        set_success_response()
        ldap_response.user =  user_details
      else
        set_errored_response()
      end
      ldap_response
    end

    def set_errored_response(message = "Error siging in")
      ldap_response.message = message
      ldap_response.success = false
    end

    def set_success_response(message = "Successful signin")
      ldap_response.message = message
      ldap_response.success = true
    end

    def check_record_and_update_passwd(email, password)
      @user = User.where("lower(email) = ?", email.downcase)
      unless @user.blank?
        delete_that_extra_record_if_exists
        @user = @user.first
        if @user.username != nil
          @user.update_with_password(params[:user])
        else
          @user.accept_invitation!(params[:user])
          @user.seed_aspects
        end
        ldap_response.user = @user
        set_success_response("Signed in")
      else
        false
      end
    end

    def delete_that_extra_record_if_exists
      if @user.count > 1
        @user.each do |user|
          user.destroy unless user.username
        end
      end
    end

    def connect_to_ldap_server
      ldap = Net::LDAP.new :host => AppConfig["ldap_host"],
        :port => AppConfig["ldap_port"],
        :auth => {
        :method => :simple,
        :username => AppConfig["ldap_username"],
        :password => AppConfig["ldap_password"]
      }
      ldap
    end

    def ldap_user_search(ldap, user_id)
      user_details = Hash.new
      filter = Net::LDAP::Filter.eq(AppConfig["ldap_search_filter"], user_id)      

      ldap.search(:base => AppConfig["ldap_treebase"], :filter => filter, :attributes => ['mail', 'title', 'department', 'displayname', 'l', 'givenname', 'sn']) do |entry|
        entry.each do |attribute, values|                    
          values.each do |value|            
            user_details[attribute.to_sym] = value
          end
        end
      end
      
      user_details
    end

    def register_ldap_user(params)
      @user = User.build(params[:user])
      if @user.save
        @user.profile.department = @profile[:department]
        @user.profile.designation = @profile[:designation]
        @user.profile.location = @profile[:location]
        @user.profile.first_name = @profile[:first_name]
        @user.profile.last_name = @profile[:last_name]
        @user.profile.searchable = true
        @user.profile.save
        @user.seed_aspects
        ldap_response.user = @user
        set_success_response("Signed in")
      else
        @user.errors.delete(:person)
        set_errored_response(@user.errors.full_messages.join(";"))
      end
    end

    def vertical_users_list
      filter = Net::LDAP::Filter.eq("CN","Advanced Web CoE All Chennai(cognizant)")
      
      entry = ldap_connection.search( :base => AppConfig["ldap_treebase"], :filter => filter)
      user_list = Hash.new
      entry.first[:member].each do |user|
        u_filter = Net::LDAP::Filter.eq("distinguishedname", user)
        ldap_connection.search( :base => AppConfig["ldap_treebase"], :filter => u_filter, :attributes => ['mail', 'samaccountname', 'name']) do |user_result|
          user_list[user_result[:samaccountname].first] = { :id => user_result[:samaccountname].first, :mail => user_result[:mail].first, :name => user_result[:name].first}
        end
      end
      return user_list
    end

    def valid_user(dl_mail, user_mail)
      dl_mail.split(",").each do |mail|
        if valid_userdl(mail.strip, user_mail)
          return true
        end
      end
      return false
    end

    def valid_userdl(dl_mail, user_mail)      
      memberof = ldap_connection.search( :base => AppConfig["ldap_treebase"], :filter => Net::LDAP::Filter.eq("mail",user_mail), :attributes => [:memberof])
      dl_filter = ldap_connection.search( :base => AppConfig["ldap_treebase"], :filter => Net::LDAP::Filter.eq("mail",dl_mail), :attributes => [:dn, :member, :managedby])
      memberof_list = memberof.blank? ? [] : memberof.first[:memberof]
      vertical_dl = dl_filter.blank? ? "" : dl_filter.first[:dn].first
      dl_list = []
      return true if memberof.first && dl_filter.first && memberof.first[:dn].first == dl_filter.first[:managedby].first
      unless memberof_list.include?(vertical_dl)
        memberof_list.each do |m_dl|
          dl_list = individual_dl(m_dl, dl_list, vertical_dl)
        end
        return dl_list.include?(vertical_dl) ? true : false
      end
      return true
    end

    def valid_dl(email)      
      ldap_connection.search( :base => AppConfig["ldap_treebase"], :filter => Net::LDAP::Filter.eq("mail",email), :attributes => [:dn])
    end

    def individual_dl(dl, dl_list,vertical_dl)      
      result = ldap_connection.search( :base => AppConfig["ldap_treebase"], :filter => Net::LDAP::Filter.eq("distinguishedName",dl), :attributes => [:memberof])
      return dl_list if dl_list.include?(dl) || dl_list.include?(vertical_dl)
      dl_list << dl
      unless result.first[:memberof].blank?
        result.first[:memberof].each do |i_dl|
          individual_dl(i_dl, dl_list, vertical_dl)
        end
      end
      return dl_list
    end

    def get_email(id)      
      result = ldap_connection.search( :base => AppConfig["ldap_treebase"], :filter => Net::LDAP::Filter.eq("sAMAccountName",id), :attributes => [:mail])
      if result.blank? || result.first[:mail].blank?
        return false
      end
      return result.first[:mail].first
    end

    def find_or_register_user(username)
      user = User.find_by_username(username)
      return user if user
      user_details = ldap_user_search(ldap_connection, username)
      return false unless user_details.present?
      @profile = {}
      params[:user] = {}
      pass = ActiveSupport::SecureRandom.hex(6)
      params[:user][:username] = username
      params[:user][:password] = pass
      params[:user][:password_confirmation] = pass
      params[:user][:email] = user_details[:mail]
      @profile[:designation] = user_details[:title]
      @profile[:department] = user_details[:department]
      @profile[:first_name] = user_details[:givenname]
      @profile[:last_name] = user_details[:sn]
      @profile[:location] = user_details[:l]
      register_ldap_user(params)
      if @user && @user.errors.blank?
        return @user
      else
        return false
      end
    end
  end
end
