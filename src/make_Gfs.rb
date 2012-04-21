#! /usr/bin/ruby1.9.1
# -*- coding: utf-8 -*-

require '../../../Programmation/Github/Graph.rb/gdf'
require 'json'

# -- configuration
graph_files = Dir.glob('../graphs/*_previous.gdf')
Friends_ids_dir = '../json-utils/friends_ids'
Output_dir = '../graphs/Gf'
# -- /configuration

names_to_ids = JSON.parse(File.read('../json-utils/cache_ids.json'))
ids_to_names = {}

names_to_ids.each_pair { |n,i| ids_to_names[i] = n }

if !Dir.exists?(Output_dir)
    Dir.mkdir Output_dir
end

def get_friends_ids(name)
    if !File.exists?("#{Friends_ids_dir}/#{name}.json")
        puts "No friends_ids data for @#{name}"
        return []
    end

    begin
        return JSON.parse(File.read("#{Friends_ids_dir}/#{name}.json"))
    rescue JSON::ParserError => err
        puts err.message
        return []
    end
end

users = JSON.parse(File.read('../json-utils/all_usernames_uniq.json'))

users_friends = {}

puts 'Getting users friends names…'
users.each { |u|
    ids = get_friends_ids(u)
    li = []
    ids.each{ |i|
        n = ids_to_names[i];
        li << n if (!n.nil?)
    }
    users_friends[u] = li
}

puts 'Making Gfs…'
('001'..'124').each { |n|

    g = GDF::load("../graphs/#{n}_previous.gdf")
    # delete edges, keep nodes
    g.edges = GDF::Graph::EdgeArray.new
    g.edges.set_default({'directed' => true}) #FIXME not used

    g_users = g.nodes.map {|n| n['name']}

    g_users.each { |u|

        friends = users_friends[u]
    
        friends.each { |f|
            if (g_users.include?(f))
                g.edges.push({'node1'=>u, 'node2'=>f})
            end
        }
    }

    g.write("#{Output_dir}/#{n}_gf.gdf")
}
