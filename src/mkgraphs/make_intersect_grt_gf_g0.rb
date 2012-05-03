#! /usr/bin/ruby1.9.1
# -*- coding: UTF-8 -*-

require 'graph'
require 'graphs/gdf'

('001'..'124').each { |n|

    g0  = GDF::load("../../graphs/#{n}_previous.gdf")
    gf  = GDF::load("../../graphs/Gf/#{n}_gf.gdf")
    grt = GDF::load("../../graphs/GRT/#{n}_grt.gdf")

    gi_0_rt = Graph::intersection(g0, grt, {:same_fields => true})
    gi_f_rt = Graph::intersection(gf, grt, {:same_fields => true})
    gi_0_f_rt = Graph::intersection(g0, gf, grt, {:same_fields => true})

    gi_0_rt.write("../../graphs/intersections/grt-g0/#{n}_intersec_grt_g0.gdf")
    gi_f_rt.write("../../graphs/intersections/grt-gf/#{n}_intersec_grt_gf.gdf")
    gi_0_f_rt.write("../../graphs/intersections/grt-g0-gf/#{n}_intersec_grt_g0_gf.gdf")
    puts "#{n}/124"

}
