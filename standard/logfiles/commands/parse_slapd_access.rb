description "parses access logs written by the 389 LDAP directory server as packaged for centos"

param! 'data', 'the data lines that should be parsed', :allows_multiple_values => true

display_type :list

execute do |params|
  params['data'].map do |line|
    entry = nil
    
    line.strip! and line.chomp!
   
    matched = /^\[([^\]]+)\]\s+conn=(\d+)\s(.+)$/.match(line)
    if matched then
      timestamp = matched.captures[0]
      # separate year and hour with space instead of colon (how i hate timestamps)
      if /^(\d+\/\w+\/\d+)\:(.+)/ =~ timestamp
        timestamp = "#{$1} #{$2}"                
      end
      
      entry = {
        :log_ts => Time.at(DateTime.parse(timestamp).to_time.to_i).utc,
        :connection => matched.captures[1]        
      }
      
      rest = matched.captures[2]
      
      if /op=(\d+)\s+([A-Z]+)\s+(.+)/ =~ rest
        entry.merge!( 
          :op_code => $1,
          :op_name => $2,
          :message => $3
        )
      end
    end
    
    entry
  end
end

__END__
# [13/Feb/2014:17:42:19 +0100] conn=17177 fd=64 slot=64 connection from 10.60.10.4 to 10.60.10.9
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=0 EXT oid="1.3.6.1.4.1.1466.20037"
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=0 RESULT err=2 tag=120 nentries=0 etime=0
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=1 BIND dn="cn=manager" method=128 version=3
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=1 RESULT err=0 tag=97 nentries=0 etime=0 dn="cn=manager"
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=2 SRCH base="cn=philippt,ou=people,dc=dev,dc=virtualop,dc=org" scope=0 filter="(objectClass=*)" attrs=""
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=2 RESULT err=0 tag=101 nentries=1 etime=0
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=3 SRCH base="cn=philippt,ou=people,dc=dev,dc=virtualop,dc=org" scope=0 filter="(objectClass=*)" attrs="uid"
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=3 RESULT err=0 tag=101 nentries=1 etime=0
# [13/Feb/2014:17:42:19 +0100] conn=17177 op=4 UNBIND