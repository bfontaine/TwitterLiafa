#! /usr/bin/ruby1.9.1

require 'json'
require './twitterapi'
dict = JSON.parse(File.read('cache_ids.json'))
keys = dict.keys
len = dict.length

api_method = 'GET users/lookup'
api_params = {'include_entities' => false}

users = []

i = 99

while (i < len)

    # get 100 usernames
    usernames = []

    ((i-99)..i).each {|j|
        usernames << keys[j] if (dict[keys[j]].nil?)
    }
    i += 100

    params = {}.update api_params
    params['screen_name'] = usernames.join ','

    begin
        resp = JitaTwitterAPI::call(api_method, params)
    rescue JitaTwitterAPI::TwitterAPIError => err
        # error
        puts 'ERROR'
        puts err.text
        puts err.hash
        f = File.open('error.json','w')
        f.write(JSON.unparse(dict))
        f.close
        puts 'file saved: "error.json"'
        exit
    end

    resp.each {|u|
        puts "@#{u['screen_name']} OK"
        dict[u['screen_name']] = u['id']
    }
end

f = File.open('cache_ids.json', 'w')
f.write(JSON.unparse(dict))
f.close
