using Todict
using Base.Test

@test 123 |> todict(:asd) == Dict(:asd => 123)
@test todict(123, :asd) == Dict(:asd => 123)
@test todict(123, :a, :b=>x->x+1) == Dict(:a => 123, :b => 124)
