#! /usr/bin/ruby1.9.1

require '/home/baptiste/Documents/Programmation/Github/Graph.rb/gdf'

GRAPHS_DIR = '../../donnees_2012-02-28/*.gdf'

tweets = []
friends = []
followers = []

Dir.glob(GRAPHS_DIR).each {|f|

   g = GDF.load(f)

   g.nodes.each {|n|
       tweets << n['nb_tweets']
       friends << n['friends']
       followers << n['followers']
   }
}

def stats(o)

    len = o.length
    o.sort!
    median = (len%2 == 1) ? o[len/2] : (o[len/2-1]+o[len/2]).to_f/2

    "#{o.min}\t#{o.max}\t#{(o.inject{|s,e|s+e}.to_f/o.size).to_i}\t#{median}"
end

File.open('friends.txt', 'w').write(friends.join("\n"))
File.open('followers.txt', 'w').write(followers.join("\n"))

puts "\t\tMin\tMax\tMean\tMedian"
puts "friends\t\t#{stats(friends)}"
puts "followers\t#{stats(followers)}"
puts "tweets\t\t#{stats(tweets)}"
