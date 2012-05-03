#! /usr/bin/ruby1.9.1
# -*- coding: UTF-8 -*-

require 'graph'
require 'graphs/gdf'

CSV = File.open('stats_intersections.csv', 'w')

_cols = ['G0 & GRT', 'Gf & GRT', 'G0 & Gf & GRT']

cols = ['"numero"', '"taille du graph (noeuds)"', '"taille du graph (liens)"']

_cols.each { |c|
    cols << "\"#{c} (recouvrement GRT (liens))\""
}

CSV.write(cols.join(',')+"\n")

def percent(a, b)
    (a.to_f*100/b).round(2)
end

('001'..'124').each { |n|

    grt = GDF::load("../../graphs/GRT/#{n}_grt.gdf")
    #gf  = GDF::load("../../graphs/Gf/#{n}_gf.gdf")
    #g0  = GDF::load("../../graphs/#{n}_previous.gdf")

    gi_0_rt   = GDF::load("../../graphs/intersections/grt-g0/#{n}_intersec_grt_g0.gdf")
    gi_f_rt   = GDF::load("../../graphs/intersections/grt-gf/#{n}_intersec_grt_gf.gdf")
    gi_0_f_rt = GDF::load("../../graphs/intersections/grt-g0-gf/#{n}_intersec_grt_g0_gf.gdf")

    # num, taille graph (noeuds, liens), % G0&GRT (noeuds, liens),
    # % Gf&GRT (noeuds, liens), % G0&Gf&GRT (noeuds, liens)
    cols = [n,
            grt.nodes.length,
            grt.edges.length,
            percent(gi_0_rt.edges.length, grt.edges.length),
            percent(gi_f_rt.edges.length, grt.edges.length),
            percent(gi_0_f_rt.edges.length, grt.edges.length)]

    CSV.write(cols.join(',')+"\n")
}

CSV.close
