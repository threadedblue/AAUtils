
const format = "yyyymmdd"
function ispediatric(effective::AbstractString,birth::AbstractString)::Bool
    
    effectiveDt = Date(effective[1:8],format)
    birthDt = Date(birth[1:8],format)
    return ispediatric(effectiveDt, birthDt)
end

function ispediatric(effective::Date,birth::Date)::Bool
    return birth + Dates.Year(18) >= effective
end
