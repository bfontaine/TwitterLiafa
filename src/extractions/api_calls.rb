#! /usr/bin/ruby1.9.1

require 'json'
require './twitterapi'

Usernames_file = '/home/baptiste/Documents/Stages/TwitterLiafa/extractions/all_usernames_uniq.json'
Rel_file = '/home/baptiste/Documents/Stages/TwitterLiafa/extractions/relations.json'
Last_index_file = '/home/baptiste/Documents/Stages/TwitterLiafa/extractions/extraction_last_index'

names = JSON.parse File.read(Usernames_file)

i = 0
len = names.length
relations = {}

if (File.exists? Last_index_file)
    i = File.read(Last_index_file).to_i+1
end

if (File.exists? Rel_file)
    relations = JSON.parse File.read(Rel_file)
end

rate_limit = JitaTwitterAPI.call('GET account/rate_limit_status')['remaining_hits']

begin

    while((rate_limit >= 2) && (i<len))
        scr = names[i]
        following = JitaTwitterAPI.call('GET friends/ids', {'screen_name'=> scr})['ids']
        followers = JitaTwitterAPI.call('GET followers/ids', {'screen_name'=> scr})['ids']
        rate_limit = JitaTwitterAPI.call('GET account/rate_limit_status')['remaining_hits']

        relations[scr] = {'following' => following, 'followers' => followers}
        puts "#{scr}: ok (following #{following.length}, followed by #{followers.length})"
        i+=1
    end

rescue JitaTwitterAPI::TwitterAPIError => err
    puts err
    puts "name: #{names[i]}"
end

j = JSON.unparse relations

File.open(Rel_file, 'w').write(j)
File.open(Last_index_file, 'w').write(i.to_s)
