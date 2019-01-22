import D4M
function out(A::Assoc)::DataFrame
    c = getcol(A)
    dataFrame = convert(DataFrame, D4M.full(M))
    Cols1 = names(dataFrame)
    Cols2 = Symbol[]
    push!(Cols2, Symbol("row"))
    foreach(x -> push!(Cols2, Symbol(x)), unique(c))
    rename!(dataFrame, f => t for (f, t) = zip(Cols1, Cols2))
    return dataFrame
end