#
# Converts a D4M compliant associative array structure to a Data Frame
# Depends on D4M and DataFrames modules
#
using D4M, DataFrames, SparseArrays
function aa2df(A::Assoc)::DataFrame
    df = convert(DataFrame, D4M.full(A))
    Cols1 = names(df)
    Cols2 = D4M.getcol(A)
    @debug "size(Cols1)=" * string(size(Cols1))
    @debug "size(Cols2)before=" * string(size(Cols2))
    prepend!(Cols2, [""])
    @debug "size(Cols2)after=" * string(size(Cols2))
    rename!(df, Dict(Cols1 .=> Cols2))
    deleterows!(df, 1)
    return df
end

function df2aa(df::DataFrame)::Assoc
    #Sorting Columns
    tempcolumn = names(df)
    tempcolumn = [(tempcolumn[i],i)  for i in 1:length(tempcolumn)]
    sort!(tempcolumn)

    column_mapping = [x[2] for x in tempcolumn]
    tempcolumn = [x[1] for x in tempcolumn]

    #There are two scenarios
   if isempty(searchsorted(tempcolumn,:x))
    # 1. The data frame is column saturated, where the first column isn't row names and the header for the first column is labeled.  
    # This is not the standard format csv D4M reads.
        column = map(string, tempcolumn)
        row = Array(1:size(df,1))
        mat = convert(Matrix, df[:,column_mapping])
    else
    # 2. The data frame isn't column saturated, where the first column is the row names.
    # This is the standard format csv D4M reads.
        xindex = searchsortedfirst(tempcolumn,:x)
        splice!(tempcolumn,xindex)
        splice!(column_mapping,xindex)
        column = map(string, tempcolumn)
        row = Array(df[:x])
        mat = convert(Matrix, df[:,column_mapping])
    end
    
    #Begin mapping value
    I = findall(!iszero, mat)
    r,c,v = getindex.(I, 1), getindex.(I, 2), A[I]
    val = sort!(unique(v))
    v = map(x -> searchsortedfirst(val,x),v)
    A = sparse(r,c,v)
    row = Array{Union{AbstractString,Number},1}(row)
    column = Array{Union{AbstractString,Number},1}(column)
    val = Array{Union{AbstractString,Number},1}(val)
    return Assoc(row,column,val,A)
end

# function dataFrame(A::Assoc)
#     #This requires some pigeon holing which is in part due to how DataFrame resolves column header collisions.
#     @debug "1==>"
#     fullA = Matrix(A)
#     df = DataFrame(fullA[2:end,:])
#     @debug "2==>"
   
#     #name collision pigeon hole
#     columnheader = fullA[1,:]'[:]
#     if("x" in columnheader)
#         index = 1
#         while ("x_" * string(index) in columnheader)
#             index += 1
#         end
#         columnheader[findfirst(columnheader,"x")] = "x_"* string(index)
#     end

#     #update column headers for DataFrame
#     columnheader[1] = "x" 
#     df.colindex.names = map(symbol,columnheader)
#     df.colindex.lookup = Dict(zip(df.colindex.names,1:length(df.colindex.names)))
#     return df
# end