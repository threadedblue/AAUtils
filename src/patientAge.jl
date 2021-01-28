function(A::Assoc, B::Assoc, sep=":", format="yyyymmddHHMMSS")::Assoc

    if size(A) != size(B)
        println(" A and B are not the same size.")
        return 
    end
    AA = col2type(A, sep)
    BB = col2type(B, sep)
    rA, cA, vA = find(AA)
    rB, cB, vB = find(BB)
    vAA = Dates.DateTime.(vA, format)
    bBB = Dates.DateTime.(vB, format)
    vAges = Dates.year.(vAA) - Dates.year.(bBB)
    cAge = fill("Age", length(vAges))
    return Assoc(rA, cAge, vAges)
end