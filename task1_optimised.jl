using Missings 
using BenchmarkTools

## == Part 1,  split into steps a,b & c.
""" Set of Point IDs """
struct PointSet
    pset::Dict{Int, Any}
    vset::Set{Any}
end
const PointSet() = PointSet(Dict{Int,Any}(),Set())

ps = PointSet()

""" Implement the insert! function"""
function insert!(ps::PointSet,val::Integer,x,y)
    # Allow for missing lat-long positions 
    passmissing(x)
    passmissing(y)

    #If a point ID already exists, return false
    if haskey(ps.pset, val) 
        return false
    end
    
    # Check our set of values to see if lat-long already exists
    if in([x,y], ps.vset)
        return false
    end

    push!(ps.vset, [x,y]) # Otherwise add it to our set
    push!(ps.pset, val => [x,y]) # And add it to our dictionary
    return true 

end

""" Implement the remove! function"""
function remove!(ps::PointSet, val::Integer)
    if haskey(ps.pset, val) #check if a val exists in our dictionary 
        delete!(ps.vset, ps.pset[val]) # Remove Point from our dictionary
        delete!(ps.pset, val) # Remove Point from our set
        return true
    end 
    return false
end

""" Implement the rand_function! function"""
function rand_function(ps::PointSet)
    if isempty(keys(ps.pset)) # Accounts for effort that we'd get if our dict is empty 
        return false 
    end 
    random_pair = rand(ps.pset) # Randomly picks a point from our dictionary
    return random_pair[1] # Returns the ID
end

""" Implement the rand_point function"""
function rand_point(ps::PointSet) # Accounts for effort that we'd get if our dict is empty 
    if isempty(keys(ps.pset))
        return false 
    end 
    random_pair = rand(ps.pset) # Randomly picks a key value from our dictionary
    return random_pair[2] # Returns the value (point) 
end

""" Implement the get_point function"""
function get_point(ps::PointSet, val::Integer)
    if haskey(ps.pset, val)
        return ps.pset[val] # Accounts for effort that we'd get if our dict is empty 
    end
    return false
end

""" Benchmark testing WIP """
# using BenchmarkTools
# for i in 1:999999999
#     insert!(ps, rand(Int16), rand(), rand())
# end
# insert!(ps,134872398478,3,2)

# @benchmark remove!(ps,134872398478)