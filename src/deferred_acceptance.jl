#‘½‘Î‘½Vector{Int}
prop_prefs_2d = Array{Int64}(length(resp_prefs)+1, length(prop_prefs))    
for i in 1:length(prop_prefs)
        if length(prop_prefs[i]) != length(resp_prefs)
            x = vcat(prop_prefs[i], 0)
            x = vcat(x, setdiff([i for i in 1:length(resp_prefs)], prop_prefs[i]))
            prop_prefs_2d[:,i] = x
        else
            prop_prefs_2d[:,i] = vcat(prop_prefs[i], 0)
        end
    end
    resp_prefs_2d = Array{Int64}(length(prop_prefs)+1, length(resp_prefs))
    for i in 1:length(resp_prefs)
        if length(resp_prefs[i]) != length(prop_prefs)
            x = vcat(resp_prefs[i], 0)
            x = vcat(x, setdiff([i for i in 1:length(prop_prefs)], resp_prefs[i]))
            resp_prefs_2d[:,i] = x
        else
            resp_prefs_2d[:,i] = vcat(resp_prefs[i], 0)
        end
    end        

#‘½‘Î‘½Vector{Vector{Int}}
function my_deferred_acceptance(prop_prefs::Vector{Vector{Int}}, resp_prefs::Vector{Vector{Int}}, caps)
    prop_prefs_2d = Array{Int64}(length(resp_prefs)+1, length(prop_prefs))    
    for i in 1:length(prop_prefs)
        if length(prop_prefs[i]) != length(resp_prefs)
            x = vcat(prop_prefs[i], 0)
            x = vcat(x, setdiff([i for i in 1:length(resp_prefs)], prop_prefs[i]))
            prop_prefs_2d[:,i] = x
        else
            prop_prefs_2d[:,i] = vcat(prop_prefs[i], 0)
        end
    end
    resp_prefs_2d = Array{Int64}(length(prop_prefs)+1, length(resp_prefs))
    for i in 1:length(resp_prefs)
        if length(resp_prefs[i]) != length(prop_prefs)
            x = vcat(resp_prefs[i], 0)
            x = vcat(x, setdiff([i for i in 1:length(prop_prefs)], resp_prefs[i]))
            resp_prefs_2d[:,i] = x
        else
            resp_prefs_2d[:,i] = vcat(resp_prefs[i], 0)
        end
    end
    return my_deferred_acceptance(prop_prefs_2d, resp_prefs_2d, caps)
end

#ˆê‘Î‘½Vector{Int}
function my_deferred_acceptance(prop_prefs,resp_prefs)
    caps = ones(Int, size(resp_prefs, 2))
    prop_matches, resp_matches, indptr = my_deferred_acceptance(prop_prefs, resp_prefs, caps)
    return prop_matches, resp_matches
end

#ˆê‘Î‘½Vector{Vector{Int}}
function my_deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                                resp_prefs::Vector{Vector{Int}})
    prop_prefs_2d = Array{Int64}(length(resp_prefs)+1, length(prop_prefs))    
    for i in 1:length(prop_prefs)
        if length(prop_prefs[i]) != length(resp_prefs)
            x = vcat(prop_prefs[i], 0)
            x = vcat(x, setdiff([i for i in 1:length(resp_prefs)], prop_prefs[i]))
            prop_prefs_2d[:,i] = x
        else
            prop_prefs_2d[:,i] = vcat(prop_prefs[i], 0)
        end
    end
    resp_prefs_2d = Array{Int64}(length(prop_prefs)+1, length(resp_prefs))
    for i in 1:length(resp_prefs)
        if length(resp_prefs[i]) != length(prop_prefs)
            x = vcat(resp_prefs[i], 0)
            x = vcat(x, setdiff([i for i in 1:length(prop_prefs)], resp_prefs[i]))
            resp_prefs_2d[:,i] = x
        else
            resp_prefs_2d[:,i] = vcat(resp_prefs[i], 0)
        end
    end
    caps = ones(Int, length(resp_prefs))
    prop_matches, resp_matches, indptr = my_deferred_acceptance(prop_prefs_2d, resp_prefs_2d, caps)
    return prop_matches, resp_matches
end