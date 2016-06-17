function deferred_acceptance(m_prefs, f_prefs)
    m_size = size(m_prefs, 2)
    f_size = size(f_prefs, 2)
    m_matched = zeros(Int64, m_size)
    f_matched = zeros(Int64, f_size)
    next_prop = zeros(Int64, m_size)#プロポーズする相手の選好順
    max_prop = Int64[]
    
    for m in 1:m_size
        push!(max_prop, find(m_prefs[:, m] .== 0)[1]-1)#各男性の最大プロポーズ回数
    end
    
    while any(m_matched .== 0) == true
        m_single = find(m_matched .== 0)#独身男性一覧
        if all(next_prop[m_single] .>= max_prop[m_single]) == true#全ての男性の選好が0になるときbreak
            break
        else
            for each_m_single in m_single#それぞれの独身男性について
                proposing = m_prefs[next_prop[each_m_single]+1, each_m_single]#プロポーズする相手
                if proposing != 0
                    next_prop[each_m_single] = next_prop[each_m_single]+1#次回プロポーズする相手の選好順
                    if f_matched[proposing] == 0 && (find(f_prefs[:, proposing] .==each_m_single) .<  find(f_prefs[:, proposing] .==0)) == [true]
                        m_matched[each_m_single] = proposing
                        f_matched[proposing] = each_m_single
                    elseif f_matched[proposing] != 0 && (find(f_prefs[:, proposing] .==each_m_single) .<  find(f_prefs[:, proposing] .==f_matched[proposing])) == [true]
                        m_matched[each_m_single] = proposing
                        m_matched[f_matched[proposing]] = 0
                        f_matched[proposing] = each_m_single
                    end
                end
            end
        end
    end
    return m_matched, f_matched
end