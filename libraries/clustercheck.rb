require 'net/http'
require 'json'

def get_node_json(selfipaddress,ipaddress,username,password)
    body=""
    clusterip=""
    clusternodes=""
    incluster=false
    uri = URI("http://#{ipaddress}:8091/pools/default")
    check = Net::HTTP::Get.new(uri)
    check.basic_auth "#{username}", "#{password}"
    begin
        res = Net::HTTP.start(uri.hostname, uri.port, :open_timeout=>10) { |http| http.request(check)}
        if res.code=="200" then
        #    print "got 200\n"
            body = JSON.parse(res.body)
            return body 
        end
    rescue => e
        #print "error is #{e.inspect}\n"
        return
    end
end

def is_cluster(jvalue)
    if jvalue['nodes'].length > 1 then
        return true
    else 
        return false
    end
end

def not_in_cluster(jvalue,selfipaddress)
    hostcheck= selfipaddress + ":8091"
    jvalue['nodes'].each do |ncheck|
        if ncheck['hostname'] == hostcheck then
            return false 
        end
    end
    return true 
end
        
def get_known_nodes_from_json(jvalue)
    prefix="ns_1@"
    separator=","
    known_nodes=""
    jvalue['nodes'].each do |known|
        known_nodes = known_nodes + separator + prefix + known['hostname'].sub(/:8091/, '')
    end
    return known_nodes
end

def get_timestamp(jvalue)
    timestamp=""
    jvalue['nodes'].each do |cnode|
        ts=Time.now.to_i
        timestamp = ts - cnode['uptime'].to_i
    end
    return timestamp
end

def node_to_join(searchhash,selfipaddress,username,password)
    clusterfound=false
    joinhash={}
    joinarray={}
    pick=""
    prefix="ns_1@"
    separator=","
    i=0
    while i<3 do
        breakloop=true
        if !searchhash.empty? 
            searchhash.each do |node|
                info=get_node_json(selfipaddress,node['ipaddress'],username,password)
                if info then
                    if is_cluster(info) then
                        if not_in_cluster(info,selfipaddress) then
                            clusternodes=get_known_nodes_from_json(info)
                            joinarray['knownnodes']="ns_1@#{selfipaddress}"+clusternodes
                            joinarray['nodetojoin']=node['ipaddress']
                            return joinarray
                        else 
                            return
                        end
                    end
                    if node['ipaddress'] != selfipaddress then
                        joinhash[node['ipaddress']] = get_timestamp(info)    
                    end
                else
                    breakloop=false
                end
            end
        end
        if breakloop
            break
        end
        i=i+1
        sleep 10
    end
    if !joinhash.empty? then
        pick=joinhash.sort.reverse.pop
        print "pick is #{pick}\n"
        joinarray['nodetojoin']=pick[0]
        joinarray['knownnodes']=prefix + selfipaddress + separator + prefix + joinarray['nodetojoin']
        #print "join array is #{joinarray}\n"
        return joinarray
    end
    return
end

    
#target=node_to_join(cluster,selfipaddress,username,password)
#print "goning to join #{target}"
