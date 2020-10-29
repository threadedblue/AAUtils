module AAUtils
    using D4M, DataFrames, SparseArrays
    include("aa2df.jl")
    export aa2df, df2aa
end