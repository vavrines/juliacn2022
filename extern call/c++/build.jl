using CxxWrap

prefix = CxxWrap.prefix_path()
options = ["-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_PREFIX_PATH=$prefix"]
files = [""]

cd(@__DIR__)
run(`mkdir -p build`)
cd("build/")

run(`cmake $options ..`)
run(`make`)
