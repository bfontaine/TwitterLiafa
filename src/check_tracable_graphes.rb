#! /usr/bin/ruby1.9.1

require 'json'
require_relative '../../../../Programmation/Github/Graph.rb/gdf'

# 0) recuperer la liste des comptes qui ont 0 friends

nb_friends = JSON.parse(File.read('nb_followers.json'))
alones = []
nb_friends.each_pair{ |k,v| alones << k if (!v.nil? && v['friends']==0) }

# 1) recuperer les friends des comptes

friends_usernames = JSON.parse(File.read('friends_usernames.json'))

# 2) Pour chaque graphe…

graphs = {}
g_friends = {}

('001'..'124').each {|n|
    g = GDF::load("../../donnees_2012-02-28/#{n}_previous.gdf")

    # … on récupère la liste des utilisateurs

    labels = []
    g.nodes.each {|node| labels << node['name']}

    graphs[n] = labels 
    g_friends[n] = {} # friends_usernames pour ce graphe

    # 3) pour chacun de ces utilisateurs, on récupère ses friends

    graphs[n].each { |user|
        friends = friends_usernames[user]

        # && user[0]<'s' <- test
        if ((friends.nil? || friends.length == 0) && user[0]<'s')
            if (alones.find_index(user).nil?)
                next
            end
            friends = []
        end

        # TODO ne récuperer les friends QUE du graph courant
        g_friends[n][user] = friends
    }
    puts graphs[n].length - g_friends[n].length

    # 4) on regarde si c'est complet

    if (g_friends[n].length == graphs[n].length)
        puts "Gf #{n} tracable."

        f = File.open("gf_#{n}_relations.json", 'w')
        f.write(JSON.unparse(g_friends[n]))
        f.close
    end
}
