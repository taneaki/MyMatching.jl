#manytoone_Vector{Int}
function my_deferred_acceptance(prop_prefs::Vector{Int},
                                resp_prefs::Vector{Int},
                                caps::Vector{Int})
    prop_size = size(prop_prefs, 2) #prop��̐�
    resp_size = size(resp_prefs, 2) #pref��̐�
    prop_matched = zeros(Int64, prop_size) #prop�}�b�`����z��̏�����
    resp_matched = zeros(Int64, sum(caps)) #resf�}�b�`����z��̏�����
    next_prop = zeros(Int64, prop_size) #prop�����Ƀv���|�[�Y�����鎞�̉�
    max_prop = Int64[] #�ő�v���|�[�Y�񐔔z��̏�����
    
    for p in 1:prop_size
        push!(max_prop, find(prop_prefs[:, p] .== 0)[1]-1) #�ő�v���|�[�Y�񐔔z��̐ݒ�
    end
    
    indptr = Array{Int}(resp_size+1)
    indptr[1] = 1
    for i in 1:resp_size
        indptr[i+1] = indptr[i] + caps[i]
    end
    
    while any(prop_matched .== 0) == true
        prop_single = find(prop_matched .== 0) #�}�b�`���ĂȂ��w���ꗗ
        if all(next_prop[prop_single] .>= max_prop[prop_single]) == true #�S�����ő�v���|�[�Y�񐔂������Ă����break
            break
        else
            for each_prop_single in prop_single
                proposing = prop_prefs[next_prop[each_prop_single]+1, each_prop_single] #���Ƀv���|�[�Y���鑊��
                if proposing != 0
                    next_prop[each_prop_single] = next_prop[each_prop_single]+1
                    if sum(resp_matched[indptr[proposing]:indptr[proposing+1]-1] .== 0) != 0 && (find(resp_prefs[:, proposing] .==each_prop_single) .<  find(resp_prefs[:, proposing] .==0)) == [true]
                        prop_matched[each_prop_single] = proposing
                        matched_index = findfirst(resp_matched[indptr[proposing]:indptr[proposing+1]-1] .== 0)
                        resp_matched[matched_index + indptr[proposing] - 1] = each_prop_single
                    elseif sum(resp_matched[indptr[proposing]:indptr[proposing+1]-1] .== 0) .== 0 #resp��0�̘g����
                        current_order = Int64[]
                        for i in 1:caps[proposing] push!(current_order, find(resp_prefs[:, proposing] .== resp_matched[indptr[proposing]+i-1])[1]) end
                        if all(findmax(current_order)[1] .> find(resp_prefs[:, proposing] .== each_prop_single)) == true
                        prop_matched[each_prop_single] = proposing
                        prop_matched[resp_matched[findmax(current_order)[2] + indptr[proposing] - 1]] = 0
                        resp_matched[findmax(current_order)[2] + indptr[proposing] - 1] = each_prop_single
                        end
                    end
                end
            end
        end
    end
       
    return prop_matched, resp_matched, indptr
end
#manytoone_Vector{Vector{Int}}
function my_deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                                resp_prefs::Vector{Vector{Int}},
                                caps::Vector{Int})
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
    return deferred_acceptance(m_prefs_2d, f_prefs_2d, caps)        
end
#onetooneVector{Int}
function my_deferred_acceptance(prop_prefs::Vector{Int},
                                resp_prefs::Vector{Int})
    caps = ones(Int, size(resp_prefs, 2))
    prop_matches, resp_matches, indptr =
        my_deferred_acceptance(prop_prefs, resp_prefs, caps)
    return prop_matches, resp_matches
end
#onetoone_Vector{Vector{Int}}
function my_deferred_acceptance(prop_prefs::Vector{Vector{Int}},
                                resp_prefs::Vector{Vector{Int}})
   caps = ones(Int, size(resp_prefs, 2))
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
    prop_matches, resp_matches, indptr =
        my_deferred_acceptance(prop_prefs, resp_prefs, caps)
    return prop_matches, resp_matches
end  