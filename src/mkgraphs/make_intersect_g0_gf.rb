#! /usr/bin/ruby1.9.1

require 'graph'
require 'graphs/gdf'

('001'..'124').each { |n|

    g0 = GDF::load("../../graphs/#{n}_previous.gdf")
    gf = GDF::load("../../graphs/Gf/#{n}_gf.gdf")

    g0.edges.map! { |e|
        {'node1'=>e['node1'], 'node2'=>e['node2']}
    }

    gi = GDF::Graph.new(g0.nodes)

    edges = g0.edges | gf.edges

    edges.map! {|e|
        #e['gf'] = 0
        #e['g0'] = 0
        #e['gfg0'] = 0

        in_gf = gf.edges.include?(e)
        in_g0 = g0.edges.include?(e)

        #e['gf'] = 1 if in_gf
        #e['g0'] = 1 if in_g0
        #e['gfg0'] = 1 if (in_g0 && in_gf)

        e['gfg0'] = 0

        e['gfg0'] = -1 if in_g0
        e['gfg0'] = 1 if in_gf
        e['gfg0'] = 0 if (in_g0 && in_gf)

        e
    }

    gi.edges = Graph::EdgeArray.new(edges)

    gi.write("../../graphs/intersections/#{n}_intersection.gdf")
}
