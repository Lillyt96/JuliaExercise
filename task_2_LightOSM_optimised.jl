""" download 20km LightOSM Graph data, uncomment to redownload """
# data = download_osm_network(:point,
#                             point = GeoLocation(-37.8155, 144.988, 0.0),
#                             radius = 20,
#                             network_type=:drive,
#                             download_format=:json,
#                             save_to_file_location="task2_data.json")
using LightOSM
using JSON
using BenchmarkTools

struct shortestpath
    rand_o_d_indices::Vector{Any}
    rand_o_d_nodes::Vector{Any}
    paths::Vector{Any}
    distance_dict::Dict{String,Any}
    shortest_latlong::Vector{Any}
    longest_latlong::Vector{Any}
end 

data = JSON.parsefile("task2_data.json")
shortestpath() = shortestpath([],[],[],Dict{String,Any}(),[],[])

shortestpath_struct = shortestpath()
osm_graph = graph_from_object(data, network_type=:drive, weight_type=:distance)


""" Return the shortest and longest path length and lat long """
function shortest_path_information!(osm_graph, shortestpath_struct, n_paths)
    println(string("Generating shortest path for ",n_paths, " node pairs"))

    # Randomly generate n number of node pairs
    rand_o_d_indices = rand(1:length(osm_graph.nodes), n_paths, 2) # Returns an array of 5 graph verticies pairs
    rand_o_d_nodes = [[osm_graph.index_to_node[o], osm_graph.index_to_node[d]] for (o, d) in eachrow(rand_o_d_indices) if o != d] # Returns an array of 5 node id pairs

    # Find the shortest path of n node pairs and populate shortestpath_struct.paths with the node ids
    for (o, d) in rand_o_d_nodes
        try
            push!(shortestpath_struct.paths, shortest_path(osm_graph, o, d, algorithm=:dijkstra)) # populated with node ids of the shortest path
        catch
            # Error exception will be thrown if path does not exist from origin to destination node
        end
    end

    # Find the distance of the longest and shortest path for n node pairs
    longest_distance = 0
    shortest_distance = 9223372036854775807
    
    for x in shortestpath_struct.paths
        weights = weights_from_path(osm_graph, x)
        cum_weights = cumsum(weights)
        distance = cum_weights[end]
        # Add longest distance to longest_dict. Structure is "longest_distance" => [[distance val], [lat/long pos]]
        if distance > longest_distance
            longest_distance = distance
            push!(shortestpath_struct.distance_dict, "longest_distance" => [distance,x])
        end
        
        # Add shortest distance to distance_dict. Structure is "shortest_distance" => [[distance val], [lat/long pos]]
        if distance < shortest_distance
            shortest_distance = distance
            push!(shortestpath_struct.distance_dict, "shortest_distance" => [distance,x])
        end 
    end 


    # Extract the lat/long positions between the node pairs of the shortest and longest distances.Store in an array.
    for node_id in shortestpath_struct.distance_dict["shortest_distance"][2]
        push!(shortestpath_struct.shortest_latlong, osm_graph.node_coordinates[osm_graph.node_to_index[node_id]])
    end 
    
    for node_id in shortestpath_struct.distance_dict["longest_distance"][2]
        push!(shortestpath_struct.longest_latlong, osm_graph.node_coordinates[osm_graph.node_to_index[node_id]])
    end 


    println(string("The shortest path is ", shortestpath_struct.distance_dict["shortest_distance"][1], " kms with lat long coordinates of ", shortestpath_struct.shortest_latlong, "."))
    println(string("The longest path is ", shortestpath_struct.distance_dict["longest_distance"][1], " kms with lat long coordinates of ", shortestpath_struct.longest_latlong, "."))

end 


# for i in 1:5
#     @time shortest_path_information!(g, s, i)
# end 
shortest_path_information!(osm_graph, shortestpath_struct, 10)