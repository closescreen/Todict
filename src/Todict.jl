module Todict

export todict
"todict(123, :asd) -> Dict(:asd => 123)"
todict(x, k::Symbol) = Dict( k=>x )

"123 |> todict(:asd) -> Dict(:asd => 123)"
todict(k::Symbol) = x->todict(x,k)

"todict(123, :a, :b=>x->x+1) -> Dict(:a => 123, :b => 124)"
function todict(x, k::Symbol, p::Pair)
 Dict( k=>x, p.first=>p.second(x) )
end

"123 |> todict(:a, :b=>x->x+1) -> Dict(:a => 123, :b => 124)"
todict(k::Symbol, p::Pair) = x->todict(x,k,p)

"""
todict(123, :a, :b=>x->x+1, :c=>x->x+2) -> Dict(:a=>123,:b=>124,:c=>125)
"""
function todict(x, k::Symbol, p::Pair, p2::Pair)
 Dict( k=>x, p.first=>p.second(x), p2.first=>p2.second(x) )
end

"123|>todict(:a, :b=>x->x+1, :c=>x->x+2) -> Dict(:a=>123,:b=>124,:c=>125)"
todict(k::Symbol, p::Pair, p2::Pair) =
    x->todict(x,k,p,p2)

"""
todict(123, :a, :b=>x->x+1, :c=>x->x+2, :d=>x->x+3) -> 
    Dict(:a=>123,:b=>124,:c=>125,:d=>126)
"""
function todict(x, k::Symbol, p::Pair, p2::Pair, p3::Pair)
 Dict( k=>x, p[1]=>p[2](x), p2[1]=>p2[2](x), p3[1]=>p3[2](x) )
end

"""
123|>todict(:a, :b=>x->x+1, :c=>x->x+2, :d=>x->x+3) ->
    Dict(:a=>123,:b=>124,:c=>125,:d=>126)
"""
todict(k::Symbol, p::Pair, p2::Pair, p3::Pair) = 
    x->todict(x,k,p,p2,p3)

"""
todict(123, :a, :b=>x->x+1, :c=>x->x+2, :d=>x->x+3, :e=>x->x+4) -> Dict(...)

todict(123, :a, :b=>x->x+1, :c=>x->x+2, :d=>x->x+3, :e=>x->x+4, :f=>x->x+5)
"""
function todict(
       x, k::Symbol, p::Pair, p2::Pair, p3::Pair, p4::Pair, pp::Pair...)
 dict = Dict( k=>x, p[1]=>p[2](x), 
           p2[1]=>p2[2](x), p3[1]=>p3[2](x), p4[1]=>p4[2](x) )
 for (k,v) in pp
    get!(dict, k, v(x))
 end
 dict              
end

"""
123|>todict(:a, :b=>x->x+1, :c=>x->x+2, :d=>x->x+3, :e=>x->x+4) -> Dict(...)
"""
todict(
    k::Symbol, p::Pair, p2::Pair, p3::Pair, p4::Pair, pp::Pair...) = 
       x->todict(x, k, p, p2, p3, p4, pp...)

"todict( Dict(:a=>123), :a=>:b, x->x+1 ) -> Dict(:a=>123,:b=>124)"
function todict{P<:Pair{Symbol,Symbol}}(d::Dict, p::P, f::Function) 
    get!(d, p.second, f(d[p.first]) )
    d
end    

"Dict(:a=>123) |> todict( :a=>:b, x->x+1 ) -> Dict(:a=>123,:b=>124)"
todict{P<:Pair{Symbol,Symbol}}(p::P, f::Function) = d->todict(d,p,f)

"""
todict( Dict(:a=>123), :a=>:b, x->x+1, :b=>:c, x->x+1 ) -> 
    Dict(:a=>123,:b=>124,:c=>125)
"""
todict{P<:Pair{Symbol,Symbol},F<:Function}(
    d::Dict, p1::P, f1::F, p2::P, f2::F, other...) = 
       todict( todict(d,p1,f1), p2,f2, other... )

"Dict(:a=>123) |> todict( :a=>:b, x->x+1, :b=>:c, x->x+1 )"
todict{P<:Pair{Symbol,Symbol},F<:Function}(
    p1::P,f1::F, p2::P,f2::F, other...) = 
   d->todict(d,p1,f1,p2,f2,other...)


end # module
