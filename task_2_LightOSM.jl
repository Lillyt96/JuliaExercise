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
    shortest_dict::Dict{Any,Any}
    shortest_latlong::Vector{Any}
    longest_latlong::Vector{Any}
end 

data = JSON.parsefile("task2_data.json")
shortestpath() = shortestpath([],[],[],Dict{Int,Any}(),[],[])
s = shortestpath()
g = graph_from_object(data, network_type=:drive, weight_type=:distance)


""" Return the shortest and longest path length and lat long """
function shortest_path_information!(g, s, n_paths)
    # println(string("Generating shortest path for ",n_paths, " node pairs"))
    
    # Randomly generate n number of node pairs
    rand_o_d_indices = rand(1:length(g.nodes), n_paths, 2) # Returns an array of 5 graph verticies pairs
    rand_o_d_nodes = [[g.index_to_node[o], g.index_to_node[d]] for (o, d) in eachrow(rand_o_d_indices) if o != d] # Returns an array of 5 node id pairs

    # Find the shortest path of n node pairs and populate s.paths with the node ids
    for (o, d) in rand_o_d_nodes
        try
            push!(s.paths, shortest_path(g, o, d, algorithm=:dijkstra)) # populated with node ids of the shortest path
        catch
            # Error exception will be thrown if path does not exist from origin to destination node
        end
    end

    # Find the distance of the shortest path for n node pairs
    for x in s.paths
        weights = weights_from_path(g, x)
        cum_weights = cumsum(weights)
        final_distance = cum_weights[end]
        push!(s.shortest_dict, final_distance => x) # Maps total distance to node ids of the shortest path
    end 

    # Output shortest path of n pairs and longest path of n pairs to the following arrays
    shortest_path_length = minimum(collect(keys(s.shortest_dict))) # Identifies the node pair with the shortest path
    longest_path_length = maximum(collect(keys(s.shortest_dict))) # Identifies the node pair with the longest path

    for node_id in s.shortest_dict[shortest_path_length]
        push!(s.shortest_latlong, g.node_coordinates[g.node_to_index[node_id]]) # populates array with lat and long positions between the nodes with the shortest path
    end 


    for node_id in s.shortest_dict[longest_path_length]
        push!(s.longest_latlong, g.node_coordinates[g.node_to_index[node_id]]) # populates array with lat and long positions between the nodes with the longest path
    end 

    # println(string("The shortest path is ", shortest_path_length, " kms with lat long coordinates of ", s.shortest_latlong, "."))
    # println(string("The longest path is ", longest_path_length, " kms with lat long coordinates of ", s.longest_latlong, "."))

end 



for i in 1:20
    @time shortest_path_information!(g, s, i)
end 
