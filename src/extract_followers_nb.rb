#! /usr/bin/ruby1.9.1

require 'json'
require './twitterapi'

dict = JSON.parse(File.read('cache_ids.json'))

dict.each_pair {|k,v| dict[k] = nil}

keys = dict.keys
len = dict.length

api_method = 'GET users/lookup'
api_params = {'include_entities' => false}

users = []

i = 0

while (i < len)

    # get 100 usernames
    usernames = []

    while usernames.size < 100
        if (dict[keys[i]].nil?)
            usernames << keys[i]
        end
        i += 1
    end

    params = {}.update api_params
    params['screen_name'] = usernames.join ','

    begin
        resp = JitaTwitterAPI::call(api_method, params)
    rescue JitaTwitterAPI::TwitterAPIError => err
        # error
        puts 'ERROR'
        puts err.text
        puts err.hash
        puts "usernames: #{usernames.inspect}"
        f = File.open('error.json','w')
        f.write(JSON.unparse(dict))
        f.close
        puts 'file saved: "error.json"'
        exit
    end

    resp.each {|u|
        puts "@#{u['screen_name']} OK"
        dict[u['screen_name']] = {'followers'=>u['followers_count'], 'friends'=>u['friends_count']}
    }
end

f = File.open('nb_followers.json', 'w')
f.write(JSON.unparse(dict))
f.close
