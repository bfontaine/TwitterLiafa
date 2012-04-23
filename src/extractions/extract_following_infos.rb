#! /usr/bin/ruby1.9.1

require 'json'
require_relative './twitterapi'

dict = JSON.parse(File.read('friends_raw_data.json'))
keys = dict.keys
len = dict.length

api_method = 'GET friends/ids'
api_params = {'include_entities' => false}

i = 0

while (i < len)

    while (!dict[keys[i]].nil?)
        i += 1
    end

    username = keys[i]

    params = {}.update api_params
    params['screen_name'] = username

    begin
        resp = JitaTwitterAPI::call(api_method, params)
    rescue JitaTwitterAPI::TwitterAPIError => err
        # error
        puts 'ERROR'
        puts err.text
        puts err.hash
        if (err.hash['text'].to_s.start_with?('401'))
            dict[username] = []
            next
        end
        # user does not exist anymore
        if (err.hash.is_a?(Hash) && err.hash['error']=='Not found')
            dict[username] = []
            next
        end
        puts "Current username : #{username}"
        f = File.open('error.json','w')
        f.write(JSON.unparse(dict))
        f.close
        puts 'file saved: "error.json"'
        exit

    end

    puts "@#{username} OK"
    dict[username] = resp['ids']
end

f = File.open('friends_raw_data.json', 'w')
f.write(JSON.unparse(dict))
f.close
puts "'friends_raw_data.json' saved."
